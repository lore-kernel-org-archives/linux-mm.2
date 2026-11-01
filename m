Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8261606A327
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 14:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51206B05B2; Sun,  1 Nov 2026 09:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01A36B05B3; Sun,  1 Nov 2026 09:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EE36B05B4; Sun,  1 Nov 2026 09:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B08126B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 09:04:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48D3FA87C3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:04:35 +0000 (UTC)
X-FDA: 85386720510.20.B7BCF3A
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id A911D180009
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:04:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf16.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793541873;
	b=SGYrHqAX5yWy01AFbZej+OYil+iy82DoSk/KE0mPlarOtgO0LDfS80hUyhRN2AICMXxpAh
	323JDGF68eJ2R6BdrGI0Vz+BKSK6cypzBzayfMv4KQ/D/QxCo4insgyqmct3aJQ9s95b3J
	oUuQg/57EH9kgeOM5Q9sqUuOZz3lJJM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf16.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793541873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=x2LG4I8K268YSfho51Oa9+mfFy/fqJPwPrh4z5MqxDg=;
	b=tgWIla76apel9Xx6nT25UDou1I3jJQIIqEx6hBxZilLSwd2xVPpFZ6PrEi8e6i0jwbpbg3
	xjyUbVqxH43cRCeEGupmGrV3bp2y8Nfd6qmNU+UqAe+QeZ/vX05rgqWZondSbTWwBRLGHX
	HvfnTxJrwaJHFtGt+oXtnG+VKeeAkdE=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xNWAf-001kRh-Ol;
	Sun, 01 Nov 2026 09:04:29 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v2] xarray: unlink a node before freeing it
Date: Sun,  1 Nov 2026 09:04:29 -0500
Message-ID: <20261101140429.862287-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A911D180009
X-Stat-Signature: jmixf47jeu7h7iybu9kt5dwnypqc9exq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793541873-384797
X-HE-Meta: U2FsdGVkX182kJBpFfxFFPlmpn1tGSqNzLhTQVNKZeSlYDqm/f387nmeKNiK2K+dpWZXRzj5920CKZsO6Wkqnh52mZrIGXz1xDCGJyIoSIljtWnk+ewGqhOm2EeYAbIEU/XCDnjJK5JptSL6PGvTlrxeILu6s1gbg//uvmexHmBUVubwwa9Vjlf66/Yt7U2SiTw/DsVeih0bzes5/w+IZbQl3PlsAReUoQr9ZmdTxjUXKbifLjwduIuv5VPCE0TnknBqqLoxhLjfx6NrDVbzSofE6WU6ezdIT0kkeiBWVY0kVKIy0WcsEr9rLlFzaWKr9RSF5V4bCCwqELIY0UT3BX1zpflbo9itvfCri/kt4IcmeA+ChHm067dOGay7gZPzpHlmupwsWqYeRo9uDUGyL7t+SC3BY1zwdad4KDhdcB8NptUb9CZlc3OKHog8TsSaJbJhy4rhV5TMMTziqSLbeXRBsDUTUklk/KiQ4DtX5gY5KGTro3RKEBz7Y5+EOcKLePa3UtsXp62qu9kGznJ7x7IdYQP+dmQB3HquOnAOqL62tJZOgVI/uHsQ+9GfAtfw878NsO3qVJrJq5TUvcXAdQXlR0mNseco4cUYQum2Gg4bNQe6z4ym4dqqkVNNFhluQJ6ofvMBOPAqOUHTi2J1wKMV3CCU23EAZcHvqXbcvEivh1+UZz99IV2fry+JRr15IzsYrfWWlSwyRc/G5LXSu1YQpinHYh9BkNKYu12Uk58a4LGTHv23kbS+LXwSTbfwuDGJaRgvuGxacAlAlTGpFcW0wLC6JWCQjqpu1j9N1w/U/Az6m7xuyEtUbW4PTdsCj/omRmdG2QcCNkMXwz6U4DJof1qQIErZnFbLIuq9oZaDs6Yj3CdvES0puOEo4NnZEeCGz4GXQLm2y/BuqSFrm4bpaYI2d7SxbxlQbytOzT7sv/mdVqGpCooTfE0L6haWq/wFBH10iw0RkPLMwLR
 itsgRsM1
 4a+PZnkdhWXKP3DaCdmPcWtBsfwhIr48Q0vNX2CB3WAy1LsL5TWZ7S2bkHhln8fhwe+nr4BJRUlS3dSKVM1MDrRt2kKUKD4cohNkL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xas_delete_node() passes an empty node to xa_node_free(), which queues
it with call_rcu(), before it stores NULL over the pointer to the node
in the parent's slot or in xa_head.  A lockless walker that loads that
pointer after the grace period has started is not waited for, and
reads the node after it is freed.

Free the node after unlinking it, as delete_node() in lib/radix-tree.c
does.

The radix-tree test suite's multiorder test hits this under
AddressSanitizer: a heap-use-after-free in xas_start() in 19 of 200
runs, none with this patch.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    This patch was prepared with the help of an AI tool.
    
    Changes in v2:
    - Resend with a shorter changelog, per Andrew Morton and Matthew Wilcox.
      No code change.
    
    v1: https://lore.kernel.org/all/20261012174230.772325-1-nickolai@csail.mit.edu/

 lib/xarray.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34..d48754c5f8b8 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -500,17 +500,18 @@ static void xas_delete_node(struct xa_state *xas)
 		parent = xa_parent_locked(xas->xa, node);
 		xas->xa_node = parent;
 		xas->xa_offset = node->offset;
-		xa_node_free(node);
 
 		if (!parent) {
 			xas->xa->xa_head = NULL;
 			xas->xa_node = XAS_BOUNDS;
+			xa_node_free(node);
 			return;
 		}
 
 		parent->slots[xas->xa_offset] = NULL;
 		parent->count--;
 		XA_NODE_BUG_ON(parent, parent->count > XA_CHUNK_SIZE);
+		xa_node_free(node);
 		node = parent;
 		xas_update(xas, node);
 	}

base-commit: cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
-- 
2.53.0


