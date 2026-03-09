Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807D4F3C248
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED50D6B0089; Mon,  9 Mar 2026 08:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B2D6B008A; Mon,  9 Mar 2026 08:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77676B008C; Mon,  9 Mar 2026 08:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0C796B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:34:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 844CC56385
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:34:59 +0000 (UTC)
X-FDA: 84526469118.25.988522F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F0D68160008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:34:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VgRs7yMh;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773059698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+QvVfVDDjSHdOMuU9xEZB+TDS7YqSYDHOoyyOBkn68=;
	b=3NmAfVOJ1cy8s+NAmxTMxTUhAhDWAjxv/CYq0UBuLx09cmeY/lbJfLTzLCoKi5t4oObvkJ
	gvRtxlIpY8/kZ/B5IOsXChfqYgg3DWEPk1HpgNZ9OyiujyH8AcWTJRbOmSFrm8KFWLrZSK
	IcjsIPltvBRI1AWuUF/P/rZLYkzW/7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773059698; a=rsa-sha256;
	cv=none;
	b=L1PJOZIt7hxSPtWPdj2xRmBkI4JgrRDWWoJKVRoVNLz1f0isRLvUyDgVy431W0fT/mWqHq
	2VRwDdKWxxUGCVbPCTUSXqbILrt30/Kdcht/UlxlljJGmbZemdO3bDWSu5GFbyD1owgq3O
	AKjxWB4S8gWw0gSCNViqO9MkA+eCbl8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VgRs7yMh;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67BF36013A;
	Mon,  9 Mar 2026 12:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E5AC2BC86;
	Mon,  9 Mar 2026 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773059697;
	bh=+0wA474v7nGumxjsD4uBjOHoecHS+At9sWy47yvU5l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgRs7yMhnJmvtZQe6EkaO6+UoTSVjE9edgYr80SRJ2nUwqQ+tMX3FpQy0xEUzElMa
	 GfKLr1bFcQ3BBJFwmFS36Jm3ULHgZZUQfkZ6TbtdS2lBvAWOj6MYOAeS5qZ1JhUge4
	 U4OnGbdoMqOLhOAfFvzeVtcpwlfPzR/152dQvJAQMno18ikG+2u/7CpP9oirOn1KqR
	 kgCqOnhQ5AzednCk+s2cw5aTdEYLFBNp1qE15umTtU2PPaTmAPlo8RGXErq8c/PWTE
	 cYT0FseEtymrV41BwP5IDGMSJ1KEy2sszqbVIrS76ThxLAhwyq11rCJJ2HEl9+D03W
	 JOQShaugTHwrw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kho: drop restriction on maximum page order
Date: Mon,  9 Mar 2026 12:34:07 +0000
Message-ID: <20260309123410.382308-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309123410.382308-1-pratyush@kernel.org>
References: <20260309123410.382308-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y3hinjas4tgf8myd5n8unu9t5yrty69u
X-Rspam-User: 
X-Rspamd-Queue-Id: F0D68160008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773059697-343387
X-HE-Meta: U2FsdGVkX18FCasH3nL8J6Cql2km54hkXorFb2aWm1kihOPAB0S+yY4Jtj0XfOIlFl9bBbrdmw2NI+F65/3pWKXE1bJtesyJ8rWRTq11mOAxv0PeN7P5X+laSK2u40iziU0QRJ2+tKiyX3UlZELQWVPe/a64gi5pKl0Mfr7xiR/1SBFRyP/D2cgngqKhX2pr8drMq7y4hIYv9zwyKQNRzAJX70aOZ4lfrW+jbLQBlm4SQrQZ28HZ9eGvQ0FTFn/3YwV8euzpTBVOo7+hb5CfQG1ko9mSHMwOJskXJ92+wFRCw2X22ZPsggW5F3OS8WM5eOqOGfUBn2/9G67BdtyPTr3tKF6GfUeXqpp+uVZmZHGK/5OW40ZwEFSEXR3AJUFLw+poh27m7NTm6xwE45rsgDzJF6HGSaLRtEYEYN2DCYNMCBBiZle89IQXPBDydo0iPidoeJkfYenaYVzhHyUBv/+8cDeikr6WGvxKFqT6oIR8i7qn7MDHOuzy/7pgxRMUp/ZIgCGjZU62iVG26gspR0jhWDBYVdweMe5eunUwfULsjBeXNu6rc1/FhI25qEgwSkiE2X0FZobj2nAyKtu3J9rAGb0ijLa2wgdD6CfFh7oaNznarIkzF8FrS8//MSArFdSgNvYBrerGzrJ0ArEzXSA3Ro210UA+J9g+OoG5aKRAtsPKgfWp0CyPxEXWJk9wx6s08PwoHFp+boBh8+3wFU+1++jcvLFvA/flOWaa48+Y+Syh6kPLXeFRNW0W1eGn2iuF9lSgYxxmL4+j8VzeX5rSAZJUC6Tr2GO3dVk31IaUNnEs/sNUVsHiEJ83gZFy2HBYhvkNAbncDG41p/k5roXeNA94VPclQ7uQrHWQV0oo1RMdqn3+n5YKziLtM2QYiGbxOC8oEvYZ/sX3wuH+suPG6iyK9VlnX/+f9OKu2osGHcWDgrnYkxnwaLoE3liVbShRVYGukHErMivKGBd
 2gmLV7qV
 nNBBWYCB3nfU17foNPG5SiQU0x7gnWNAaAMT98lBlVPGfz3/8tBaKyN4JXxFncmTPOLJlwmj06+/13uAnUjwQKP2RzMQ4n2uQYtoyQxwIY/YnZRBdU52a1gvMjHxvHwRpULfCGnoB8mbiLbUReAKsjdbrmL3dysxr8gpe9IJ2LU0fduME8rQe6BumjSsmzNZMm4UPQeQfK4SOdkjO3gxmKYdXmKuWcm39Muz0OspOA+eefVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO currently restricts the maximum order of a restored page to the
maximum order supported by the buddy allocator. While this works fine
for much of the data passed across kexec, it is possible to have pages
larger than MAX_PAGE_ORDER.

For one, it is possible to get a larger order when using
kho_preserve_pages() if the number of pages is large enough, since it
tries to combine multiple aligned 0-order preservations into one higher
order preservation.

For another, upcoming support for hugepages can have gigantic hugepages
being preserved over KHO.

There is no real reason for this limit. The KHO preservation machinery
can handle any page order. Remove this artificial restriction on max
page order.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    This patch was first sent with this RFC series [0]. I am sending it
    separately since it is an independent patch that is useful even without
    hugepage preservation. No changes since the RFC.
    
    [0] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u

 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index bc9bd18294ee..1038e41ff9f9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -253,7 +253,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	 * check also implicitly makes sure phys is order-aligned since for
 	 * non-order-aligned phys addresses, magic will never be set.
 	 */
-	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
 		return NULL;
 	nr_pages = (1 << info.order);
 
-- 
2.53.0.473.g4a7958ca14-goog


