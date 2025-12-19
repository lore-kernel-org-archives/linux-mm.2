Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDABD767F9
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B168D6B0093; Fri, 19 Dec 2025 06:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7156B0095; Fri, 19 Dec 2025 06:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED456B0096; Fri, 19 Dec 2025 06:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90C346B0093
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:58:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BFAC140550
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:54 +0000 (UTC)
X-FDA: 84236074188.15.F00C577
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 24F8D8000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fwFXoheP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766145532; a=rsa-sha256;
	cv=none;
	b=N0aRgy8lflwARgLMcdSLFLFFl3I+St6t/EAAd2XtLTVxkMYouGTuoh3c9AIgQN8d8Asal/
	d6cmkXoR/sIqb8nnHmoJYfQc+WksqjSe6vNZJE91sezYw1OaWH5XZJk2k1Yl/wdPM1FVam
	/eAZzbmJC8nhO3GkmHLUlTr/7yfzJSc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fwFXoheP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766145532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsWpa24lxI6xHk1ZPBUYj2BnfB01U6tPDq237TH7seo=;
	b=OslI3Nn0iir7qhADIdSS5CyxiHutToyf5gfJwJAw1VyMTjsZetjegMIcdt7kpDrDfMwzCq
	1B3LVzvcQVkQnhiJuLTM7eKx3J1SgvnE/EsDJIcs2HolvFotm7akeYG/llf5QQnjusc+Zz
	BpH5XorYsK+1tgG38sMJYYCgnNfQ/4I=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so1585307b3a.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766145531; x=1766750331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsWpa24lxI6xHk1ZPBUYj2BnfB01U6tPDq237TH7seo=;
        b=fwFXohePmL+n67Rk+7mTN3/leoBhXPzQ+hpqfnHoSBwXPFzs77e9A+c40uLsaYNmLE
         IbHYrKiKRahixNunZChb1152aIWHGYgvkqHo74WuJSmoLoH+hm+5WFeGk9adLWPekqyO
         ZZyh+2c/4+GplaWC6xBf1wq8/+DiTCfpaYh1jvwMUMtwUFyel4So2doMQRYVae+cqLts
         px9XrbNN6yrzKHXx4l3MxvvDhAATwMHvrS1deYpaiXnosR+tmKevbfcWRD9WspV+J4QE
         s1MkBV3ML92Fyl0gmpKX23hVeDBBs4Dd3gE6eCYV6UEGIwIPEQugGl+KyyTLRO4UjVwv
         lL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766145531; x=1766750331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RsWpa24lxI6xHk1ZPBUYj2BnfB01U6tPDq237TH7seo=;
        b=L2JN1QRwTAcKyrDa0RXKl+UEEmdnJ0EO5asx6SMFJOxU0F5pStKzbH68Bbxqn1Xoej
         hr/KphrzYx1xp1Mihz8xhYnBHSTUD3i94hmc+yuL7jn+0NV2cZPFD4nWhebfSh5f1vew
         wACgDBzBsujMlAu5KBhVBpzgKaa8xDJvKPorFdi6p3e1VnqRv2s1uAC3kRwxP48dGar7
         UeQ1SqEoAko5kJw7D0bxw9xA7CwTpHA8keVWOAfGP+qRD7f45YFkw/WkgsKAQfzD3Aeu
         PToOJzrnIo1/aV9u7EoB1N9QstgUq9/9S+LhRq9uHX2JZxMDKm9dMn4P/jRc0B9oq3u0
         2ihA==
X-Forwarded-Encrypted: i=1; AJvYcCUd9qnWOFJbyB+8buBv8TDSQM34vsR4RxMZJ82+Q9RJs5ruUujoIYcYTyajLE2Cy8ubZP3ZDZNrmQ==@kvack.org
X-Gm-Message-State: AOJu0YxWJnVQDviAihF7GkmekTZuvGx3nQMXqUGx47xHN4zOtxx9nrLU
	gA1WlNtlrb3zl7Ad/yxioUq9vYkb7sQXafzU0fk1HqvXTuIioGT9DJCV
X-Gm-Gg: AY/fxX65ar+A9FelJDJThTx7u9ZSsYRHdw0YsXfuipLnuekJcB7lbFq4NVhTijqE48+
	mJktCgBBy3w704vfKYirZgl508C9P9ZpMob5c4erskOc4wjq2WqfCru0aV25AOlQASop9Algknt
	mpqWourbMRw7qoWV4kVVm3bKHb3P8hWKnPQ0aDPt+AB5kTfU3vYjj5z55kPymyM8VAVVKfzVTtu
	zUQME8Siynr6YYJD3AXS+TP8Mc7POCu+5WazVL8/m2w2czwGr6tqVJ5I14M3Y8b7WqyrXeyt86/
	CLEGjQnsLxQBsIykZJnjZ+FIcyxTxmbWyvGad/A671XwI/iWkVHm3oesbrGEZGH931ssXmVDyjq
	MQ+RwnWRKVYOeEMfw2A80Fbikm8HzILNDG43AzX/QzVsMMd82+UGRX/CfybDWhubMo/1UXPqXFL
	ve6TnY5TcbjcGWSD1hludu3d9l9kemYfxYQv8hRnKWfUQsZpvHClNx
X-Google-Smtp-Source: AGHT+IF11NXTxykBJC+oLwlMsW0lPOQ7p7i34Dr/aL0JQHuQ9W6RwWlf8VZxMOhy6Q0w9LFlCexwYQ==
X-Received: by 2002:a05:6a00:884:b0:7ff:8cde:f202 with SMTP id d2e1a72fcca58-7ff8cdef2e8mr2140403b3a.15.1766145531015;
        Fri, 19 Dec 2025 03:58:51 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b127b00sm2258560b3a.21.2025.12.19.03.58.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Dec 2025 03:58:50 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 3/3] sparc: Remove unnecessary whitespace
Date: Fri, 19 Dec 2025 19:58:12 +0800
Message-ID: <20251219115812.65855-4-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251219115812.65855-1-pilgrimtao@gmail.com>
References: <20251219115812.65855-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24F8D8000B
X-Stat-Signature: igkcnmzxibn4juogkc4dc4iufqnw47eh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766145531-544827
X-HE-Meta: U2FsdGVkX19EtccbBLWU0YuEpxi4TmeCMOpF4e7cnsn/Z385rylGUkaagROe1y1QmG3snT0arK82pv0WIGTV9f57+r4YIqxK/RL5JkV2dzWbbTwZbmQWPyKzNR4NFb82BcVorKKRwrzIf3OAAIVN+gPHYTeUy+T2+DeN1FHgfiZQxblXhxrfMgBWnOydON9wF0uFM/ugQ+QP50e2R84ED1u+Iu2bvyHM1gM5//BZDIJSoKi4QppThmg7iQcOlWbBHkGi/knyq+WswDYfc1NUMOZ0KKxDm1k3+2BIdwy2Zc/tMvfwmxtULouIVpbWK1eu4j4WXITS8gLldVrOCnK0c1xusUb0XW6KeBFAvzHpks69VMXTst2rKsPET5Uqs1FWE+K/VFZMkAdzKBr/f+KsPGYMTgaszajuflXTjhzLRoDNgmKTShAmUMYAw1NXkMolGvfKHLkEU3IsQhDdN4mCaraGFfzh7w6rWuO22RdWJ9EujwQ5uQnuzQ5IxsmT9cZBev6TVZVkAo+B8Jy6RsjBzydU6kax/OXnSJINdHQkm4VHm1Ra0CJxg8EG42xPp0q5FtNan2NHpHkvb49kojQbTSkIhxBV2wulCm8/2cmbTA0ciwiHLlb/883Fx8TeHF7uYYPGpNw6Tdsq26Kg5Yx0fJsNslsl0kex9mNJW0HrtaWbSMCloAEP39dDlcz4Z7n2hJIXVgxpTsUuCI7nGCayQsiL+Vj1eaddWCYqLstL/hdXrJ+lNvxFLab2TF2vWREbt8Qy163YpkBY33lv5NHSpohbO1pocrmd64pcvcAVX6xMPCAbwaZ/GzuxLhFWsk94tDfMAFMgFG5npg6fx8t56OSfd3vot+jzb8fD8Sb6ZqGL7zt9BFrPBdLL3vJOkWS1+M9wDk+ROMn+PUQVzsLGwpAowzjA8JUY3DYUp0Nw8RCSzei+CPR68WBrFG8BHfWEHXAAuoLresIZvj3ypDy
 Xb6h0jFt
 Mq3apRIiVXzwC99PCltCVDlwhAYb2SZorbZqKhL+pah+EGwosIZZWpdalmHHNk3/Iq1DO9mbKAk4m4tCqpVRxdNOxptb8RCGF0gJAcJQA07LAKepF0c6GoGqgwlq5mmZqwCq/ATjo4qxTw0O00nc/Qv/8twzWbBP96p+kXAMoxpSK1QNWxyxXrMgiXqeF49bJ5j/0IgHRcGL2qdISx5AC3aM7ZsSsFYgA/JwkYQJ3hBNL4mzGj585f5hXnYrxmbrDQ/pQonh/coTcERrKV80Yjxnl2VfLQ1drrEOazDIovDGzHE1jyQiRv7gNfl/QEQTEpsWRSjbtsgFaWGwzie7rblQLxTNuw+x4AF9b2ykvGhXjHliOPv8g5SfjwERCHJa4vKtMU9TRhLTK+4M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

This is purely a code formatting change with no functional impact.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 arch/sparc/mm/fault_64.c   |  4 ++--
 arch/sparc/mm/hypersparc.S |  4 ++--
 arch/sparc/mm/init_64.c    |  6 +++---
 arch/sparc/mm/io-unit.c    | 12 ++++++------
 arch/sparc/mm/iommu.c      |  2 +-
 arch/sparc/mm/swift.S      |  2 +-
 arch/sparc/mm/ultra.S      |  4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index e326caf708c6..963b2c4c87e2 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -201,7 +201,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 				      unsigned long address)
 {
 	unsigned char asi = ASI_P;
- 
+
 	if ((!insn) && (regs->tstate & TSTATE_PRIV))
 		goto cannot_handle;
 
@@ -229,7 +229,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 			return;
 		}
 	}
-		
+
 	/* Is this in ex_table? */
 	if (regs->tstate & TSTATE_PRIV) {
 		const struct exception_table_entry *entry;
diff --git a/arch/sparc/mm/hypersparc.S b/arch/sparc/mm/hypersparc.S
index 6c2521e85a42..bac194982498 100644
--- a/arch/sparc/mm/hypersparc.S
+++ b/arch/sparc/mm/hypersparc.S
@@ -30,7 +30,7 @@ hypersparc_flush_cache_all:
 	ld	[%g4 + %lo(vac_cache_size)], %g5
 	sethi	%hi(vac_line_size), %g1
 	ld	[%g1 + %lo(vac_line_size)], %g2
-1:	
+1:
 	subcc	%g5, %g2, %g5			! hyper_flush_unconditional_combined
 	bne	1b
 	 sta	%g0, [%g5] ASI_M_FLUSH_CTX
@@ -325,7 +325,7 @@ hypersparc_flush_tlb_page_out:
 	 sta	%g5, [%g1] ASI_M_MMUREGS
 
 	__INIT
-	
+
 	/* High speed page clear/copy. */
 hypersparc_bzero_1page:
 /* NOTE: This routine has to be shorter than 40insns --jj */
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 858eaa6615ea..cf30040db2bf 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -5,7 +5,7 @@
  *  Copyright (C) 1996-1999 David S. Miller (davem@caip.rutgers.edu)
  *  Copyright (C) 1997-1999 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
  */
- 
+
 #include <linux/extable.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -2397,11 +2397,11 @@ void __init paging_init(void)
 	 * work.
 	 */
 	init_mm.pgd += ((shift) / (sizeof(pgd_t)));
-	
+
 	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
 
 	inherit_prom_mappings();
-	
+
 	/* Ok, we can use our TLB miss and window trap handlers safely.  */
 	setup_tba();
 
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index d409cb450de4..15f83e6d21e2 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 1997,1998 Jakub Jelinek    (jj@sunsite.mff.cuni.cz)
  */
- 
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -62,7 +62,7 @@ static void __init iounit_iommu_init(struct platform_device *op)
 		prom_printf("SUN4D: Cannot map External Page Table.");
 		prom_halt();
 	}
-	
+
 	op->dev.archdata.iommu = iounit;
 	iounit->page_table = xpt;
 	spin_lock_init(&iounit->lock);
@@ -109,9 +109,9 @@ static dma_addr_t iounit_get_area(struct iounit_struct *iounit,
 	case 2: i = 0x0132; break;
 	default: i = 0x0213; break;
 	}
-	
+
 	IOD(("%s(%pa,%d[%d])=", __func__, &phys, size, npages));
-	
+
 next:	j = (i & 15);
 	rotor = iounit->rotor[j - 1];
 	limit = iounit->limit[j];
@@ -150,7 +150,7 @@ static dma_addr_t iounit_map_phys(struct device *dev, phys_addr_t phys,
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
 	dma_addr_t ret;
-	
+
 	/* XXX So what is maxphys for us and how do drivers know it? */
 	if (!len || len > 256 * 1024)
 		return DMA_MAPPING_ERROR;
@@ -185,7 +185,7 @@ static void iounit_unmap_phys(struct device *dev, dma_addr_t vaddr, size_t len,
 {
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
-	
+
 	spin_lock_irqsave(&iounit->lock, flags);
 	len = ((vaddr & ~PAGE_MASK) + len + (PAGE_SIZE-1)) >> PAGE_SHIFT;
 	vaddr = (vaddr - IOUNIT_DMA_BASE) >> PAGE_SHIFT;
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index f48adf62724a..f43163a9a812 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -89,7 +89,7 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	iommu->end = 0xffffffff;
 
 	/* Allocate IOMMU page table */
-	/* Stupid alignment constraints give me a headache. 
+	/* Stupid alignment constraints give me a headache.
 	   We need 256K or 512K or 1M or 2M area aligned to
            its size and current gfp will fortunately give
            it to us. */
diff --git a/arch/sparc/mm/swift.S b/arch/sparc/mm/swift.S
index f414bfd8d899..cfcc48b6c5c7 100644
--- a/arch/sparc/mm/swift.S
+++ b/arch/sparc/mm/swift.S
@@ -243,7 +243,7 @@ swift_flush_tlb_page:
 	 nop
 #if 1
 	mov	0x400, %o1
-	sta	%g0, [%o1] ASI_M_FLUSH_PROBE	
+	sta	%g0, [%o1] ASI_M_FLUSH_PROBE
 #else
 	lda	[%g1] ASI_M_MMUREGS, %g5
 	sta	%o3, [%g1] ASI_M_MMUREGS
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index 70e658d107e0..66cbfbb1d3cd 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -284,7 +284,7 @@ __cheetah_flush_tlb_page:	/* 22 insns */
 	be,pn		%icc, 1f
 	 andn		%o1, 1, %o3
 	stxa		%g0, [%o3] ASI_IMMU_DEMAP
-1:	stxa		%g0, [%o3] ASI_DMMU_DEMAP	
+1:	stxa		%g0, [%o3] ASI_DMMU_DEMAP
 	membar		#Sync
 	stxa		%g2, [%o4] ASI_DMMU
 	sethi		%hi(KERNBASE), %o4
@@ -312,7 +312,7 @@ __cheetah_flush_tlb_pending:	/* 27 insns */
 	be,pn		%icc, 2f
 	 andn		%o3, 1, %o3
 	stxa		%g0, [%o3] ASI_IMMU_DEMAP
-2:	stxa		%g0, [%o3] ASI_DMMU_DEMAP	
+2:	stxa		%g0, [%o3] ASI_DMMU_DEMAP
 	membar		#Sync
 	brnz,pt		%o1, 1b
 	 nop
-- 
2.50.1 (Apple Git-155)


