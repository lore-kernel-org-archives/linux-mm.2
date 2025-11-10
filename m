Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4688CCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BFD8E0005; Mon, 10 Nov 2025 15:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3608E0002; Mon, 10 Nov 2025 15:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8213C8E0005; Mon, 10 Nov 2025 15:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF478E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:32:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21C77C0292
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:32:11 +0000 (UTC)
X-FDA: 84095844462.27.8FFD9FF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90E54A0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:32:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="kWfKSBi/";
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762806729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KKvojf7ihiTi7OSg70nJoZtjRFEPDyWu6n7ESufOMo=;
	b=4riyQqTSgwuQlviHyzLiBR4Bnjbq4eeoHYWu5Qx850RDYqSOeatQ6nOxIc65FCuZJ9lPjf
	78WC5jO626oA8KOQQsEwu+Gz6/y/+U2yvrSIyL84e5EIui1j4J2hxl7eP9Eva3kd9aY4mV
	iZkvaQU39ONpx8IfdaZhLcrzAPeuqs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762806729; a=rsa-sha256;
	cv=none;
	b=cgAEDz904I2/EspV2GxuPgTGmXGqpRRTk7ErI7I2cVNPFwRBYy//PluuE7gOLEn3STWihf
	mv+EkAk8NCodpprANUP0JyRH0e69ktuFdkoVwi+FmTqqKgNNqwLDcl853MkvgDSSYUJwCK
	7oIrk7bSBWyA4TEMEwF8QpMtCz9YF0w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="kWfKSBi/";
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4KKvojf7ihiTi7OSg70nJoZtjRFEPDyWu6n7ESufOMo=; b=kWfKSBi/a4bgSGm9hexpvSOwrB
	X/PjDU2VP3/AtE5qUrE0ux2FYYSm95nR/gk8A9y6LpipJpCsWbetizMx9OxxReumAg6PZPoSfkwA3
	KpvH+io9saxUG97Sxnxd0AeLVOGE2HuGTlN64igZulDzzOGqMV6qipq7WQDZIwnUmtUyp1nZ22rVh
	FZ8NGJDKxmLHB93WCG7ZjPXSTt+hRimZMYpuoDRIm7xqsdXP0APo/0zeYt0ewYUkFAdHAidkDalMq
	XzNIKVp8wWzaogCQaCJLAFivnjforH677SSCxYpZnFvbITKrFO4GZtAPDzblSnZk9lS02dBdCDq2W
	de9EIOmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIYYX-000000066Kq-31eG;
	Mon, 10 Nov 2025 20:32:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Li <chriscli@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 2/2] mm: Use vma_start_write_killable() in dup_mmap()
Date: Mon, 10 Nov 2025 20:32:02 +0000
Message-ID: <20251110203204.1454057-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110203204.1454057-1-willy@infradead.org>
References: <20251110203204.1454057-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 90E54A0005
X-Stat-Signature: 6qiugxj4fnd7kgpo4tp9r7bqs91usrnd
X-HE-Tag: 1762806728-733290
X-HE-Meta: U2FsdGVkX1+BXhdngFki9/4XfYUYkDU+h0jM54pS5Hvm3/aJnXZAwvW+mohbAPlspTPkiGA+Q+BxJ7qDAGhaxdpcpp4nEFZ0XAVfiwm0LT7mfDCOZMsdiicrp09k6sv7liu3Da3dPkAjs73gfHNF/10BO1Tq7lpi/4B2D4Sq4flDIuNYpKh8D4nqnLwDnHS6jB+bBxJq/FUcxe1r0aO5FuAfs5HkRatVYccBSovqs7cws3+2uAuU2fF9d8f6xwulssVHjWXNGa9VcZXy7C48iNHbDdwYmu7JQsSQk0yb18SsHFY+mplBtr3QoMISsq8OaeO3/od+/Hsb/fSCOsVawE0rywTLtifAjB0GeipDPPvzK8+EEVtSpPgcWNcEfon2jNsgEscVphI5YSOP6F/RWkCuBSX9RJAZKT1ag0CBLitnMuN6lewFekZKf4m3+lOlWk2Ytp4YdoilAvHJTeES9e4NMECy3fLBZJ2wdvzVSNeUzGEO4/aGseiV6CtSJHqUcg0XSjSwwrBUWFJM4W3JkMe14jHJQvQSSDlzGSKAvYNfEZtSqExPinZ+mxIEO0CQdwn/tB2YkWM0uo126YeGfbCKbi0OlAtII8NM23VqdA8zvjELDwZOXS5Gm7TC13lwNClXmXBRvBSzHXSDvY9aV0hC/385X/IsFWvgZf1Ijmvqwc53u9tcKkNFwjnm17ENXQzBjLBesZyuBKTsD5pXoiW3tXHL7GzMRQJs7X1Dlc9lDjdcibyF/jEzJXXbtV8Xow2ogvSA9x8HS5HJPbXI8TJ50Qy6U/UZrFJymrFRY74OhZHiXI+v2ewA0gM9doq+ZLzQPcxOIfdlwUmsbHsQ6ipcLnb42mq2b89b18pxL1hR0Jf4UhOoAyM0Sr/Q0jprQKOBRiqejs6HpjDusy8tV0ikoKaDYQtDApy15GyxBSP06FXWt4FjTeY5AFIpCYdMAw84aKu4pYs30QXkJqi
 wR6hMWR6
 YvI8wM5C2fYAWn1YseIT/gz5Zo9D7dFCwP0ER5X//tfqOmhaahO9TRXrTDz/REr+E8TIbwOkQSstvqQpkHz9ns5M0rZx2JCcaRNg8ObyYtYjspucTjXZz9HWQRpDQsO/6SypPgmzA0hJWC8rLhitNSpghh7oeFXXUHqauF8QwTZqYmcqcA71ye1TaMyP7Zjo1aWKeuFiI/nBDQcL6OZs6yAYbUzUhvrKPTDL+cIRlUty/FqMsv0RquSELH/o4Ch9X5JyU7bWmli9w3bSFi+o8D0xXpkBF+7aD8RHFPqbq8GR3ZDUKY+8S0Y+bHeCeaEV0f1RrItJZ/mpUtNMau2Gcuwj6iIKcj3+WFyqz5Oz2GheeZwPjf8lcVo0JDi6p3TmEETobAYeA81XYMDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow waiting for the VMA write lock to be interrupted by fatal signals.
The explicit check for fatal_signal_pending() can be removed as it
is checked during vma_start_write_killable().  Improves the latency
of killing the task as we do not wait for the reader to finish before
checking for signals.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5fd3b80fda1d..03773fe777b7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1750,7 +1750,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	for_each_vma(vmi, mpnt) {
 		struct file *file;
 
-		vma_start_write(mpnt);
+		retval = vma_start_write_killable(mpnt);
+		if (retval < 0)
+			goto loop_out;
 		if (mpnt->vm_flags & VM_DONTCOPY) {
 			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
 						    mpnt->vm_end, GFP_KERNEL);
@@ -1761,14 +1763,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			continue;
 		}
 		charge = 0;
-		/*
-		 * Don't duplicate many vmas if we've been oom-killed (for
-		 * example)
-		 */
-		if (fatal_signal_pending(current)) {
-			retval = -EINTR;
-			goto loop_out;
-		}
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len = vma_pages(mpnt);
 
-- 
2.47.2


