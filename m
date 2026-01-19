Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BDAD2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AF76B0316; Mon, 19 Jan 2026 18:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F91F6B0318; Mon, 19 Jan 2026 18:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0D86B0319; Mon, 19 Jan 2026 18:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 796626B0316
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 288C51A02E7
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:33 +0000 (UTC)
X-FDA: 84350239386.23.A53BA24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6B8D9C000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SY7D/mYb";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863751; a=rsa-sha256;
	cv=none;
	b=Ah3dVVd3l00bbrGeeu0ir6wAuKvNZLStQEGUb7AWdhECjuEVAiONWRQuvEAyoh+rNkuZjZ
	qvg5GmeD/brB621ZF23vaRAdBpK9xwPShEwuU1/gIx/rcRF3mM+Uek3yRHiCXO00+z9spr
	hAU0p4u+xN11XCu4RiWeHzywkxwnrw0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SY7D/mYb";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H27x4sd+fs2hvGMcG84zQviCz5mtdCa9UUxgKgfMqNY=;
	b=3eRs6Rvun5eqzIjckyFEBVg9zcWkoxjlK531xLCAaJkt9lhjnYDVC4vY5Nbg4Sqc2pLLVh
	e87flZqxcAK2J9OorvFdRWNSqjtnu9Xu9qiT9yibELXXWBkd1WSCCxlkujqWpMON8R+qeH
	pd/iQdZCim4ZqHiNjzHOTEWB0xt4wEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9875443AE0;
	Mon, 19 Jan 2026 23:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0EAC116C6;
	Mon, 19 Jan 2026 23:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863750;
	bh=02rD+PHNM+b5mi9R1g7ROou+G35A+7jKPB0WnczT56k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SY7D/mYbjCn4fSG5EK9Rs05NbqgkjcvZRltvk7rG+REHOYD4VoywWrL8DPMjIlCcY
	 +Anh5u4jPWUZ0WpEcg8Acxj///jncJ2pqp++vuhDmyJIiSltCy9qQNuYkSqwOpbN36
	 uRcWnbEEo7Rfqk2rOhSMtm7xky6vRVHdXUjBas4Pl3BhRMezTZbRDSV/VUOYmHVOcL
	 WLk7DCCJIIx+cyLjsfkRFfOY3h3tDXL9nJjvWTb7hY+HKaWKvdxcE0BiOTSO2j005n
	 9XBTUVvE6+aB8dtpNneIWdpY5bowk676SjtHxNTXLEKEA5zl09lwv91vfDW/3Fmu7j
	 J9ZJbQiiEihHQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 07/24] vmw_balloon: stop using the balloon_dev_info lock
Date: Tue, 20 Jan 2026 00:01:15 +0100
Message-ID: <20260119230133.3551867-8-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nroy3xrfg17os68aqswr37uabhi8gs6x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B8D9C000D
X-Rspam-User: 
X-HE-Tag: 1768863751-216831
X-HE-Meta: U2FsdGVkX180r6xHKMEkAjs+7KqpJqbSYkwr8rv11RE3HPQoZrznjz9tnGCgF2KHSUxw1s6ZcnYOAc7tgTOtZEtCvuhfUtdEnPZChQVAIKwDx6uLVL1XDDqw/KYImZvihOArCrAy+DuNYSj773gA4682VDqZW8vW3aV1S3qhQ/7vbUH6yohJO/x4k5NE5rxQQ+9b/BEC/THKdO9L4usjr1uhVuerqiHI/kZ3UT/FpiyI2RkxNPQYvpB1d6Y7GdxmER2fjDeLVSnnM68XCPf0dHGgRM0VhA1md9zO8WdhVAllNAZXnZnJimbn7tNHze/2Bdg4jy22wKxxZmXnb7feWnI85mcRxL45VzzDrFFXuqAYIqAzjM/0Q0iKNwTi8ECPZegQpdpkIYgZcaONbkxCO0a2Pm0dIL9yILvj1nro70TlzjzAGDfpH7KAG7n5sluuJceU7dI5Js8xQ7MA1pUF0gZ/MU4nik0VjEqFU8KnYw+dWLr8T97UEbqAnfPx6gegz8pF/aJkqKVlvGrSTZ2ENffvm8pHyg3bOY/W5hMU+N2TsYFqB8byKq5lOHujOqUvS4YVNKA8UICmr7gHJOCG0uFs3SXc6jYSiJSBbSA19VARw8U4Vn4VD50sww2thfwo6vsOMnPijIkMKlX/uwh2vpGqAU0TVX1sjM3h8MpMxyi3u6lAGyYADHS478C3HzJPTzhH9maBmPqNldRX1SeDH8/JXv3udH93pJ7dMHd3B4w9V+0G+hEDda906meDtGN12cdmGFN6KN9YSVzlXDf10iiJlzlKb8UNLNEjZtTCu+gb3XlVtt1jwp8U7SQtFPf+Jai/4mUGt8kH9OK8yt3NjvVTjqrtVU78yxJlgncLLx3+kbcNITqBo90FxyWzl01TELZI8HlTNCuQfQwnx/r4v0Gzy6Ek8VRV7DrvVly4KQhsyrdF5ryFXOhxRE+XVEh0wXuNCf5G4MFj9VDcZ+p
 Fi9Bzjaj
 sXOnNbRL0lOk8xs6VWysU4/cBuLs0O92mV6lykf7yzy1q/7iSUJGt+FWGlAy84QptCYGW9P66tE3dHskvNjLbnenYsIn7vtClgB9inzzxuPjVbA1MgmmVzyvl4/DF6jD5Wjxw/mh4m8GyUM+pX2IecowDX+OHDqgM1FQGCvE2T36gAWa2ef2+WMTeHpUyknBuSt3Q/q2riLcnH+qMf4OLHxUeQxuzTObdDcOr1b4GoT+aXJcwU4pKTT5mI/zFPm0/+UCQwSHQDUhZRFk8iYClK8wXgveEuIlUAGKC19K4iN/v+Pr2GU9zU+fYWcoUnuJYlbOANpi62quzA04=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's not piggy-back on the existing lock and use a separate lock for the
huge page list. Now that we use a separate lock, there is no need to
disable interrupts, so use the non-irqsave variants. We only required
the irqsave variants because of the balloon device lock.

This is a preparation for changing the locking used to protect
balloon_dev_info.

While at it, talk about "page migration" instead of "page compaction".
We'll change that in core code soon as well.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/misc/vmw_balloon.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 52b8c0f1eead7..53e9335b6718c 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -354,10 +354,15 @@ struct vmballoon {
 	/**
 	 * @huge_pages - list of the inflated 2MB pages.
 	 *
-	 * Protected by @b_dev_info.pages_lock .
+	 * Protected by @huge_pages_lock.
 	 */
 	struct list_head huge_pages;
 
+	/**
+	 * @huge_pages_lock: lock for the list of inflated 2MB pages.
+	 */
+	spinlock_t huge_pages_lock;
+
 	/**
 	 * @vmci_doorbell.
 	 *
@@ -987,7 +992,6 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 					unsigned int *n_pages,
 					enum vmballoon_page_size_type page_size)
 {
-	unsigned long flags;
 	struct page *page;
 
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -995,9 +999,9 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 	} else {
 		/*
 		 * Keep the huge pages in a local list which is not available
-		 * for the balloon compaction mechanism.
+		 * for the balloon page migration.
 		 */
-		spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+		spin_lock(&b->huge_pages_lock);
 
 		list_for_each_entry(page, pages, lru) {
 			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
@@ -1006,7 +1010,7 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 		list_splice_init(pages, &b->huge_pages);
 		__count_vm_events(BALLOON_INFLATE, *n_pages *
 				  vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-		spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+		spin_unlock(&b->huge_pages_lock);
 	}
 
 	*n_pages = 0;
@@ -1033,7 +1037,6 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 {
 	struct page *page, *tmp;
 	unsigned int i = 0;
-	unsigned long flags;
 
 	/* In the case of 4k pages, use the compaction infrastructure */
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -1043,7 +1046,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 	}
 
 	/* 2MB pages */
-	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+	spin_lock(&b->huge_pages_lock);
 	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
 		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
 
@@ -1054,7 +1057,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 
 	__count_vm_events(BALLOON_DEFLATE,
 			  i * vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+	spin_unlock(&b->huge_pages_lock);
 	*n_pages = i;
 }
 
@@ -1828,6 +1831,7 @@ static int __init vmballoon_init(void)
 		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
+	spin_lock_init(&balloon.huge_pages_lock);
 	spin_lock_init(&balloon.comm_lock);
 	init_rwsem(&balloon.conf_sem);
 	balloon.vmci_doorbell = VMCI_INVALID_HANDLE;
-- 
2.52.0


