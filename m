Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F645C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109646B00CD; Tue, 14 Jul 2026 10:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E11E6B00CF; Tue, 14 Jul 2026 10:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B126B00D0; Tue, 14 Jul 2026 10:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1BE16B00CD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71F38A03E9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:16 +0000 (UTC)
X-FDA: 84987559272.15.9274DD2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF080180002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P+LRFNmi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biZLC3R/yhMAmfYncffmcVjM/UrFKnhHBc/APXxn250=;
	b=akJ5Zv/gff0bp5debQo2+gSdiztz6EI7vkhFqo8RR/5eBhPEbG+UVrHS6cA3PeXqHi5/q4
	LBC6RbLg3rtiUh86JK1hF1ZLkTUodhrfGJZQSDHbOINWbCddvRzuHMvA6VyNLotHvLszCd
	b39Xoa+VZ7+Z9RMvqPpktrXOLd1W6xk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P+LRFNmi;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038034;
	b=wp6tXCqCH2Hxo0MqDmxKg8TFM+uA0RPT3C2UaLs8kLyTZVdJTFKZtrDj8sRfP4fWuAWDT4
	x5kD5UG9xV62dW3Sn5b+0iJtle1k+QBCluDlS9YYFtBqgKQJdlFwYKf/oNw1uziHUUI4tA
	1qnFbQsbKiXaGeFjlgH1wkbz1DMekZw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEF3A1CC4;
	Tue, 14 Jul 2026 07:07:09 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 645503F7B4;
	Tue, 14 Jul 2026 07:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038033; bh=rJhmHjtmDwxS2CewudUO1k4saVZojxZevQnlJp6OZ7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P+LRFNmiDvhW3q79+Et/h/V1cKdtJE0WCcRDkD/ESazXMLOt5jc8Kgt41NbWh4J4L
	 irPYHd6dn5v2zgZP369nbxfm7fp2OsfV6xC2C9cTmmDmdF9sgXDGCBBMWKG6COr/1p
	 x9UUMt3JnkFOkdtZWVFuRaLX87Bjnkvu74XTX8nc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:05 +0100
Subject: [PATCH 16/22] efi: mark efi_mm as a kernel mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-16-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1355;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=rJhmHjtmDwxS2CewudUO1k4saVZojxZevQnlJp6OZ7c=;
 b=xEbohehI3oM6XdwxICHsVginMSV7tAi9MA1ZH+OAmyTQN4j1iQ5NsQqwBRdPZXQYf6lyJ7RCE
 SjcaLPZMgbgBfEX879PTsxhhu4WlXQHubYLk+EEaXhOv3f1B8VSkhhq
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: gxy663imbgu9qreopj84tfc4y7uoppim
X-Rspamd-Queue-Id: AF080180002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784038034-490990
X-HE-Meta: U2FsdGVkX18HcK1q1qnEtQkyY9r0PPHqZapaZD/SXvyA/7Mv8cJUTXJsr12OTCDMSFTcWyMFDTq24SvsmKlbXwm7JvDdXhac5sUI+94KbdEOuPFVANxqPpr77vCPibc4gVqZ8e7Neb8/fqcqJHt8P7O0Ahxb8Ksx3T4vjbSlf9uNysTUP3jDJsIV8inGzOcpKDO+AU81CauJWxQNAxf2Ga1XDYzHycDZPWo/QZH+wTEHsUmqfE68IgucXCaVVKQkjUpgfp2WFIxfokcXFIvpQT55/JtQzK6z3LhgTjB7nHJuxWFVe7KCJRTgz5f31AoMWqYNoLExFDgZRg8ktIBxyOlfXYfYZQ9nnUNSsQB7tJ+89LolwLnB62QYS7YqiaXRlprZc4i7xY7vfrykBSvawzrHMWaGwu81q1CE42mAlKxN2AKxa/tsjoKuKkAH+WOQsJEEth4mYhLshRAK0nloTR/5+d2Ad2jky0mJ7X41f2Z+tnHktQFq3ML4wNDmZMtsSKp7Sm7eq7uLoT0q2LII6mDdTl4nUONfIm0rVqBxQ/tlMAI8yUBdmuMbX6zUzZbBOl+7HUM4kCAzla4779u8eStWV7XkDdWTgMekmNmmcDc5W2gooovkzaMaBlHEpnIgSI8sFKnOol3GpR6K0uIC8PeyLes8y2NO+8xqRSnsosy3gPDFZBu8gXuh/U9sLIhtONx2blUfoPogOdR7bz1eCoWBygOmBJebK1QhDqkWkoEo1Wqt2286e7kAQPWP8vkd9VJt0wW21SUYI4y2STl0GKk8uS60G7HFLLEOINyYL+zFX8UxhprkdFl3QcPtzxHNuordx49y6s42zjKQ9nNgiSvySBhAIhhJmnYg1Es6zdptW0Y2qvgOc/DMo6qqqNsdRzYw/xNHph0KtgTJ3mUzTUQeiSaqJW9APNe7iHGLS6dfvyFVLkVGH0VVRGerfWGiajLlAI2jeG7v2KjoS8p
 NfxadZ32
 gKTuXCIU5N+00IVKUXxmdX40U4AeM3PB4IaPoDX4AILQQrghaLFtDopojAbp4+k19hnvAmfA0BR6It6/hh7DEOTEB3f4AZ3i0beemp2r0SbF/XLFQAcYDxiVnmeNs+AAxNfJUDS6yenQWrBdWncW6ZaQgBcWk6xQ6eNQfSjoQOxkkP62Xl/w6zggUzqFP7MyaDoxTf2PnfdJECJdR74zmome73vLdL+s1DLwCUm7/NsfnBYwqSbeMnKbM4M5rmuAMoS2WBx4/XNANzduZ8r8FNIYPvG5zTvHQE437h28AtieAIGXEH9GzZ8PmF+m1e642odxHvXqOnP9JDJyarssXJ/O/IcALuLgnhbffX88WSeHiuOxL9lpwlbOXrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

efi_mm is a kernel-owned address space used for EFI runtime
mappings, but it is currently treated like a user address space when
manipulating its page tables. There does not seem to be a good
reason for this, and it creates unnecessary complications when
creating its page tables.

Mark it with the new MMF_KERNEL flag so that the page table handling
treats it like init_mm. In particular, this means that:

* Split page table locks are no longer initialised or used for
  efi_mm's page tables.

* pagetable_*_ctor() and pagetable_dtor() no longer need to be
  called for efi_mm's page tables.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 drivers/firmware/efi/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa..e5ca45bdc890 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -69,6 +69,7 @@ struct mm_struct efi_mm = {
 	.mm_mt			= MTREE_INIT_EXT(mm_mt, MM_MT_FLAGS, efi_mm.mmap_lock),
 	.mm_users		= ATOMIC_INIT(2),
 	.mm_count		= ATOMIC_INIT(1),
+	.flags			= MM_FLAGS_INIT(MMF_KERNEL_MASK),
 	.write_protect_seq      = SEQCNT_ZERO(efi_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),

-- 
2.51.2


