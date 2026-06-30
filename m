Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E836C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B566B00BB; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB896B00BD; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219D96B00BF; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE9C46B00BB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71EE9120398
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:06 +0000 (UTC)
X-FDA: 84935760252.23.A9D0D6E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id B082020003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=V4R6bgie;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ljxxedR7;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804724;
	b=Xt6dexXH6iafuQLMCiub8MSKD9lkVIWZMBsWIIdXu4vPty96ZL809pRYwAQNqEA4viTxsm
	18YQFPw9/knGxxhIsq7sGFb6Mr7h1NJ7PseYNHhwFePoCpacsbZ0HIEzy7g0+WBdbVtoXK
	3ev2Ka0dR46A1BYvyJxjtgI8V8yN7zw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pKh2f77m/+CAvr5W8wkHo9AO1t2s6dXpZFMecXchAc=;
	b=3sAlwhUajmQN8cBCT6SFnPf7/0fDp6tOnmzcecEqLqfP895+6YVclvlbQL4bVDCFkeTqYc
	hZ7zykRzDqS2mhgNicANDua+fJkawmPvU7PXSDpZCo+JQTmNfonFhLgmJuW9YuEOKDO9R3
	44uoXsv9nitVk9OR2KXDHpr/pYNum38=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=V4R6bgie;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ljxxedR7;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pKh2f77m/+CAvr5W8wkHo9AO1t2s6dXpZFMecXchAc=;
	b=V4R6bgieP28Y/buSKCgijJhFtTo7vOgLdID50UJf7y9JShtFsa/UWQGcQbu7Xulu9+atcr
	qwk8wiN2TsmFAR+IN+MQyo1k/3YP4iJUQdiT+nAMHNxUwi4OOPPYPZ1djGj30czsWKblKU
	YHrsmudlv4fNF2/gM3iRfYXA5MFOGsjt4PuS0E7gO/eKBOAfx3IZ8tDLuDAoA/dmB1SX+R
	IVHghBVwJsB38HFCPnV4wLD+8XiTu9ZH+8Z8txsv5sPDeRyZqIbmP9PMuk9AM/AB1OqAwi
	iYg+UTVKT0EqlinKP0CKCmFoXw7RBIWj2TcedveRSCudyqTOC3s87e/nSdFqzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pKh2f77m/+CAvr5W8wkHo9AO1t2s6dXpZFMecXchAc=;
	b=ljxxedR7x0sXHU03E5wU7iF1bAqjDW2yOA7o/6eI96ye7PSWiuh8wXoKLwGMU0x7fuNQwW
	wsz28ZZZlHOKjRAQ==
Date: Tue, 30 Jun 2026 09:31:56 +0200
Subject: [PATCH v4 2/6] vdso/datastore: Map pages in terms of the faults
 pgoff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-mlockall-v4-2-6c93708ce723@linutronix.de>
References: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
In-Reply-To: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=2391;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=v+s3eegLtl06E0VWrRB2TMTDrXQKVH75BuSy1mEU1sY=;
 b=tZ1bSMpHj+1/cZ0YW6L8GKtTuLVi+pUpSWQrEAT1X4kYn6l9u7b/rxP/SKMkGJsmagWNj6hRI
 N3FEu2SysyzDkpFBHdNuKETGfNi+aDaM0SRrpbcZTu1pUCLCoOGgxXE
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: yzephno93urj36w9ead7johhddmk47fx
X-Rspamd-Queue-Id: B082020003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782804724-225895
X-HE-Meta: U2FsdGVkX1+0vngGQYHFhDkuiUucJEsRza2QYX5udfQ5YaVzooBFv6Kdt8XSA5Y1AIniM0bMK216f3jJRK8ppJxKMpUakJjDqDiTx53DT4zVMuVzQopqlER1O0nmxVWiJ13VUkYPWIKywyMSN4ZYfTRC15ZkCVXZQceQjTUAeERa7XOKX8ilwjBSza54fhhwTMnN/ziM/URYYu9ufQ2iq1FJRvD3x0CiFesAwHEUXro4GOWompM+OCvmcbJZsRCKct8bZbTLxLrZruObPS5QoP7E2iaMfXGY7L5BaH7IaHs4gxQ8//pH/bMvFOFVopNwtap7tTB9Fj8eEQ26cx7D36azWwDhBrsPpKAPLLjEIY2xy6DI3DYDVCdXzrzw20jjI38hbJLkxZdvcWjrBrBK9BbDAICJFni7mVGe+LYmj8p9917R9rrSaLS0sBcMfS5Lm8nzl02QOxwBwIN/KM3MjI3DxBMyaZVmMVa6iCTMTO2hlu7nhtnpYxnliPb0OisNsFtd7dr5r9gxlRY8tMV5Ml61JCpUAdBsERcF3kZtjZHbxx0NdokptM+D9vQhIdrJrIVV106W8aIBhzZuc2kT6DiYx9xworR6n4Nv45bYoZg1yurU8u/Dl0pNIeQsmlZXEdvdTxnZVnyaiEAvAO9VCkfCL6VGez5xQV9p1F1juvvnolyceM2gX08ERFT3brwqy1CoLBNZfA3VgzJohOd2ZrJqCmBnzdFNfYoUtdzD8gL+1ChStO74sMeXvwU6dP55BdoC/NyyM0dsKCzN78JfviqHjadWDkHPOnuxqNN2cUA4fXhzCimX5lcgvsMBX3KdeTRUiStz1McgCrQIB7/UmcOmR9zY0trYZyAqVigd8+MgeXPgxEZgs/JEdQQifz2DLbgQL/o2oqkh3h8KJY09xVHEtO3eiZSruSNmUVmWYeRMXO4DEY3lerbXi4KaEQpR6NhvN45KsG4J88MAdBT
 SZrBdqEz
 IbDptR9Ul1hw5AgwVil/6S0YUgdVK9gLP/BW7V5U5wZNNUWIIWF4Ll7onCSBKNRQNWVO4twsgeEtP3sBRe/QWLzzLrhyrmh/fARKbV9DUbjYDtoQJ/goIwE/XorTkGEDMq8leVyi8LFfTkOi5tQ1gSpg28rsBcdUii0qY8KSsQdnnA1hCDxQZyrdI2d+76rk6h+qzxndzbRUa61aAGVNnUtnJG5DfomP6qVu8VDVUVWMr7R3rbeKd0ZxY6WLiRpdrVUepNSIkP3bP0YLSbOsHvkt5Y4AYsoNsSLziShNzGO1DCNeQV0RK4rr2GyO50C8TKcuR26dZ20/F/vs2oubpdD3toXuwDenMuFlh9QQp1f2qAYI2QlJwDK8X/qV/PGIuwOWOP1V4aqItt1GVtoP/PDTuTadM4ZuXPhJGwMMZy5JXpsYXokGFwAFiyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support mlockall() on the datapages the VMA can have no holes where
inner pages return VM_FAULT_SIGBUS. An upcoming change will avoid these
holes by mapping a zeroed pages into these holes. That logic will be
simpler when the mapping logic is based on vmf->pgoff instead of the
vdso_k_ symbols.

Switch to the equivalent vmf->pgoff logic.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 7f78a32656aa..e01db9607534 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -29,10 +29,11 @@ struct vdso_arch_data *vdso_k_arch_data __ro_after_init =
 	(void *)&vdso_initdata[VDSO_ARCH_PAGES_START * PAGE_SIZE];
 #endif /* CONFIG_ARCH_HAS_VDSO_ARCH_DATA */
 
+static struct page *vdso_data_pages __ro_after_init;
+
 void __init vdso_setup_data_pages(void)
 {
 	unsigned int order = get_order(VDSO_NR_PAGES * PAGE_SIZE);
-	struct page *vdso_data_pages;
 
 	/*
 	 * Allocate the data pages dynamically. SPARC does not support mapping
@@ -67,13 +68,13 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 {
 	struct page *page, *timens_page;
 
+	page = vdso_data_pages + vmf->pgoff;
 	timens_page = find_timens_vvar_page(vma);
 
 	switch (vmf->pgoff) {
 	case VDSO_TIME_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_time_data);
 		if (timens_page) {
 			/*
 			 * Fault in VVAR page too, since it will be accessed
@@ -99,17 +100,15 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		 */
 		if (!IS_ENABLED(CONFIG_TIME_NS) || !timens_page)
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_time_data);
+		page = vdso_data_pages + VDSO_TIME_PAGE_OFFSET;
 		break;
 	case VDSO_RNG_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_VDSO_GETRANDOM))
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_rng_data);
 		break;
 	case VDSO_ARCH_PAGES_START ... VDSO_ARCH_PAGES_END:
 		if (!IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_arch_data) + vmf->pgoff - VDSO_ARCH_PAGES_START;
 		break;
 	default:
 		return VM_FAULT_SIGBUS;

-- 
2.55.0


