Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D04CA5FD7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 14:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B476B0005; Wed, 21 Jan 2026 09:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224A96B0088; Wed, 21 Jan 2026 09:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E056B0089; Wed, 21 Jan 2026 09:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 038BD6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:38:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A027A160498
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:38:44 +0000 (UTC)
X-FDA: 84356227368.11.6F288DC
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1E84F140007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:38:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=H11EW6za;
	spf=pass (imf26.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769006323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w/WDHKSYXm8Fddt+PSh+C072ZZ2mR98/5mghWuOHgEc=;
	b=KjXYRiQhlt6lO/veSSkDOJW9TK3ZtKXPGyh7QMtIsxrnkVcI0lrQGZ9AD3PIhM0ke5AElw
	Nek9KKe5MfumNF1FMymHv7VbP4F8+kENJEmCoMyMzkwd9PV5HqQ2bwRCa1eCx56Nx9vTSc
	yifxar8iIqYTJ9NH4XTCDxxQNd7HkhM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=H11EW6za;
	spf=pass (imf26.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769006323; a=rsa-sha256;
	cv=none;
	b=NN89TaCydG6u2TOkYg1j6Om3ho6KoQGVAVD+TNysJBgUXPTlV+iVuSoLeG6G0tcABm39rE
	/XGDLMpVnS7Wa26j4hT98RDDLRnQOEz+8EJlzKF+HzRsBeu1KfIFy7e2OTmk8sl6vd2CuN
	6J/1uAsN1tTmBpGR3KIJu7cnxYfDEtQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=w/
	WDHKSYXm8Fddt+PSh+C072ZZ2mR98/5mghWuOHgEc=; b=H11EW6zabDu1SOki7q
	DfOJPT+8F8W1lFgEMzRSRCSDRiA3xmPo9TLo2eko2FxeV7lHoWoKSp28ZMxGletz
	+ux56OGnr8BVOcIPtgYpn/mhAUOArjE5TDpgKRhg8QHAeXXV3NzMPZ5fpLWoK60x
	duqIyhzT4ikaLYVm9w7GdCgK0=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgA3oF_443Bpg3L7MA--.289S2;
	Wed, 21 Jan 2026 22:34:35 +0800 (CST)
From: ranxiaokai627@163.com
To: pratyush@kernel.org,
	surenb@google.com,
	akpm@linux-foundation.org
Cc: pasha.tatashin@soleen.com,
	kent.overstreet@linux.dev,
	rppt@kernel.org,
	graf@amazon.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v3] kho: init alloc tags when restoring pages from reserved memory
Date: Wed, 21 Jan 2026 14:34:30 +0000
Message-ID: <20260121143430.175294-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgA3oF_443Bpg3L7MA--.289S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWkWr1xuFWrXFyruw4xXrb_yoW8KFyfpr
	W8tw1ktayrJan8Za17ta1q934ftws5JayrJay7u34fXFnxA3Z2yas7Xa4jvFy5Gry8XF4x
	Ww4UJrZ0v3Z09aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piFdgJUUUUU=
X-Originating-IP: [218.203.227.98]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxRyu+mlw4-xfYwAA33
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E84F140007
X-Stat-Signature: 1p3oirh4tghompb1b7kabcoqu9x7d8ey
X-Rspamd-Server: rspam02
X-HE-Tag: 1769006321-706220
X-HE-Meta: U2FsdGVkX1/losHUxiSojXjs6d04CttmJbddSqMKXkWozUN/KVq96r9tY14BBj0bxy/m2jUslC97y/5xElxPhDX+9dBD4qpi1Rqf71M40YSxijwYEY5zVP4bqoHQDuwjkyiSCFA72i52SlyXevzChhurPEWTqJyw7aFkT5htkodOnV17j+lk5NfJyDQSBgCtmIAKBKdZ2vrToNSHeORU2Cu0GlKnT6UC8h7aaTTbv9irlEyYBjkM2e4YLiZ56Zp1QKz+jMuLNotLj1vYOX4TbAT0ziQDHj+KlvT03+oqIHyNNmZrKfemNQGoXkMw1f2Ye2vMDKTWSQ8Zn/j3ajB1D0LFsdAZPOFqCUraiGN5ZqqF080YC7wFUZBGV5QPdJH6Szx7Z8x4AMPue3YenzFYie2+6nZLZ1E44jMFaanhYLw+fqJhEYZq9tHwKSbR4REARAXDRjv/LTyN/VCDsn9W3JEcB1IF/OupRBfof6PDjw6X7u8QL9l6JZXMfpAbB9lCxqIuzLOZAsoI3cBgXgLs1oIW7xwl4M3GlmC8K6yYiaGHnLBD3ypRl0HH2LSclmp2G4K38HGFTXdT0csS5Y+Fqy350s6QtZ/eSGSvJg+mvwpe7JbzhgYHeOUUDqh4dD6ook1ur4bKJhvmDbppc8g13PzH6r5BZkGqZpYQliBwnWllyciCLz9azWiiCC8mMBKLaL3dt/7Q59L1tuOsgUdDDusN3auFXjewkyZQoAMKf7JLH8S4SEfqUT4P54vwbj3jsWDjgh2fvrxWdg0FUDopy1w7J8Zbrxge3drt+DHYIAdLq5V+GFXpHbZS6iN565IqkO1KHlOkYZ+DeqnvSKoWG2OQtqutuOr2EElFUhD8W+ef3o+MkWyiAYKEbAdbKg+3+QjFAtMHwOAYQEjp081/GeiLJqj7P5ouvvzFk5XngQOnri0nNNxfz1Aeek4G98Hapt0579CzFRbPUTvmWXP
 qC5Jjmcc
 4DUoOrjF5JU2+SJyszlT60D+fOknnJ56VY+nL8rTe38upT6Hxqet0H/jkJs0hBVeVKSBee0igrF9BfXrUzWJSxX75NaRmQOmSuHEXrTptJxlkvH25/ymCG1xsU24cjoR0r9dpb83FdnmTbfRitWF8sMihM04PLE5I7hS3Hzt7xd1egIbYQW7oE65AlvtiZtiwY6fGOU2edeYvBny8mLl18flo0AlCoyQ3BIQ+fYE8SRSRpWgvYdqzz3/CeybNhX3zXIE+3JvLLt/N9MszizIJBqCYpBbmhWU7DKnDTzubbASaJ9MedW1if4ocsbIM+1FyGGOqu4J0jqx07rtEQmerCh4atgpTauwxaDN3uC9+Jiv7i62Gy4H/suX1dNCuXPTKZv3Yipq0a+FsF0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Memblock pages (including reserved memory) should have their allocation
tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
released to the page allocator. When kho restores pages through
kho_restore_page(), missing this call causes mismatched
allocation/deallocation tracking and below warning message:

alloc_tag was not set
WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
RIP: 0010:___free_pages+0xb8/0x260
 kho_restore_vmalloc+0x187/0x2e0
 kho_test_init+0x3c4/0xa30
 do_one_initcall+0x62/0x2b0
 kernel_init_freeable+0x25b/0x480
 kernel_init+0x1a/0x1c0
 ret_from_fork+0x2d1/0x360

Add missing clear_page_tag_ref() annotation in kho_restore_page() to
fix this.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
It is based on linux-next 20260120. I dont konw whether this base is ok ?

 kernel/liveupdate/kexec_handover.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 43d9d2661163..8f7e09d67e1b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -219,8 +219,11 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
-	for (unsigned long i = 0; i < nr_pages; i++)
+	for (unsigned long i = 0; i < nr_pages; i++) {
 		set_page_count(page + i, 1);
+		/* Mark the codetag as empty to avoid accounting mismatch */
+		clear_page_tag_ref(page + i);
+	}
 }
 
 static void kho_init_folio(struct page *page, unsigned int order)
@@ -236,6 +239,9 @@ static void kho_init_folio(struct page *page, unsigned int order)
 
 	if (order > 0)
 		prep_compound_page(page, order);
+
+	/* Mark the codetag as empty to avoid accounting mismatch */
+	clear_page_tag_ref(page);
 }
 
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
@@ -265,7 +271,6 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	else
 		kho_init_pages(page, nr_pages);
 
-	clear_page_tag_ref(page);
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
-- 
2.25.1



