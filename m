Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570D2606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7626B08B3; Tue, 27 Oct 2026 15:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278346B08B5; Tue, 27 Oct 2026 15:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191346B08B6; Tue, 27 Oct 2026 15:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCAA06B08B3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:20:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B9CF40AF4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:20:21 +0000 (UTC)
X-FDA: 85369372242.19.96EF273
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id B0B0AC0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:20:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf22.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8q9qM/hZwHShCYQg/3HhVfggR1TOZYI42k3fGiqzpEA=;
	b=W7++YmRqjyi+ogBwIQCSzqGWtkK4Mr19tdDs70uyRUofdQ5KsKFyNXgEo3hhXFoHPr0AbP
	P+Ljd5bfpKNzgxEQ1raswKJIOqGlqDzja2PJ389TB/92vcfwRo5Ub4YvaiBJX+pxcITa0b
	3nH+00FSHWeVaX6nPx77rPjS3hVQDhA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf22.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128819;
	b=NSKgA+ZZxrvqMTL0WbnTLui0uv8I2GQCAAasmPb82KIBOg5QMt1i6fQmhPXXxDnRxOG+1t
	RnxIQ2VPft1An1jXmXa/bXqjsApBepJnYO9lq7HmZutT+7e3xVUHrDVTHKThOQpJ+ZHjCr
	EEZRrSHYvWMKLO7Gr7IwsV+pMps88iI=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xLmiU-00CXea-Tw;
	Tue, 27 Oct 2026 15:20:14 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v2] xarray: clear the new head's parent before freeing the old head
Date: Tue, 27 Oct 2026 15:20:14 -0400
Message-ID: <20261027192014.844878-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <attzI4sj2Pagmvkd@casper.infradead.org>
References: <attzI4sj2Pagmvkd@casper.infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0B0AC0002
X-Stat-Signature: xg1ubjga7hjqwxceas7f9576qmh39k7i
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793128819-449316
X-HE-Meta: U2FsdGVkX1/7O0qtrLb9GUW9m8ioZsKgilz+ZO6wBIlXf3RW4NoWDW3FknUYl5ee+/3qoja6/H8BBnLOU22H1RKxzQGJMXtepQwBDyqTRWuBDBkVkG03JuB/cNeIiVR3RJJe8yQxAxxPs9a19w4iT5iXK2IB6OEWelwZX3JuRDBwrlDq2F+xXQzFrUXTijFrAEoT8BCUH+NCiOSiy0btZ8wL2d+SnF1U2qhqcIdI/kYVYNBnq7jxYMuViKSJtk7lVbS8aeS+OTx3YEzKZD/2Yg/h2sprzpS+3Va2AOXodGTTenPzgjCmXttKn2UOJ8PhQeoYUlzIq8KlwrE3TXnyJ672UFAlK0fMFneIyNidam7IIuNySbzFlDjTwv8WzXUA+iofybwHwVw4D6SLRtc+ewo9B3MRTd6G8umSLwl8PtEtRNKCs0DVpL8WI578bRNJmkfQDfMIVJWSdyLwHPEfI/7pzWv5nQL6FjI+h4uFjj3HquALYbJjslFC+DiMfqR8syBMgLeRFTsQPtkUvi7N7AhkF7mZLIYw/MfB6pDuWp4JLUoE094c5FgBRPM4vOfxQLB8i6xHo8O/tzN+LfOVIDXKat9iE/5PDEKy5Ptl377YGWT0RdGJZ+ndgwuwGHbhwnIGK8EDO2WhUvDN+2b6hAArSKmoG5Qa+40LolApNx+D2FowQ4PQzKALoiEIH2gEc3v4O9yGFSB9JaxANXBALPbGj2fvFXkd3eV/wmLbmhEJwdbTO8gSr8/3rMwizLh8zJhcxtG2OwZdIKWNGVQjSMxwcmq2hQWdEevZbKIvhLYsz3T1DanbTSlwfItndXulAkcpgpZ5nrjlCfyIui8lpt9xlF7mZ7BMzoZHYbc9/YaZ4WwsmBRWbmkUkGlNeQvAEXbvMvg3IfhSTb2ErrKxzVCmB/lxFEuRrNddxTDlYSGvlVRo5zkb6FA3jIAuyMYVM7JQiq2O9BzrRA3iXpP
 YYiVDGRq
 pmRGXdmny9uCULaseCoVWGdFHXIQ5x2OngHBsGw2qgRzBWPTX1Q+M7m9/8AQ57FdSzkgQCcxsv7JynKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xas_shrink() passes the old head to xa_node_free(), which queues it with
call_rcu(), before it clears the new head's parent pointer.  A lockless
walker that loads the new head after the grace period has started can
still climb from it into the old head through xa_parent(), as
xas_find(), xas_find_marked(), xas_next() and xas_prev() do when they
step past the end of a node, and read the old head after it is freed.

Clear the parent pointer before freeing the old head, as
radix_tree_shrink() does.

With a delay injected after xa_node_free() in xas_shrink(), KASAN
reports a slab-use-after-free in the walker; with this patch it does
not.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
---

Notes:
    This patch was prepared with the help of an AI tool.
    
    Changes in v2:
    - Shorter commit message (Matthew Wilcox).  No code change.

 lib/xarray.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34e..ae9d7fc68861c 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -471,11 +471,12 @@ static void xas_shrink(struct xa_state *xas)
 		if (!xa_is_node(entry))
 			RCU_INIT_POINTER(node->slots[0], XA_RETRY_ENTRY);
 		xas_update(xas, node);
+		if (xa_is_node(entry))
+			xa_to_node(entry)->parent = NULL;
 		xa_node_free(node);
 		if (!xa_is_node(entry))
 			break;
 		node = xa_to_node(entry);
-		node->parent = NULL;
 	}
 }
 

base-commit: 62c457528529cdcfa32bc52b331ceca10f3937b6
-- 
2.53.0


