Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ACAA606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Tiaytl9j
Received: by kanga.kvack.org (Postfix)
	id 3C97E6B05B4; Fri,  6 Nov 2026 23:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379836B05B5; Fri,  6 Nov 2026 23:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F8A6B05B6; Fri,  6 Nov 2026 23:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E51096B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 896C7A7BED
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:26 +0000 (UTC)
X-FDA: 85407051492.12.4E00E4D
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C72440002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Tiaytl9j;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794025944;
	b=RjksWVVvZkR5dMaH3rc2g1VFRRWpc49dZeTRWawuQJfmFvCQnFkPbl80/Cu0cM3op9THzi
	L/IA8+LX5u5yUU6bi+Cq+QPdxbZ4GelrpVH26LhBbn5DHCJtxF3+hyWjmNYCexHnO1MRrz
	xWsF/bUvBVqskJgGD8EnlCTjlZNL1WU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Tiaytl9j;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794025944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SKim++0/v959SqW2Qj0ZN00Ia9M3Z26xYKJjxKUd6k=;
	b=jfGKKtHVj70HbRrSoEeAstXRtiSYOVOX0Rd37xbaZN95KSzreFQHC+oS3zV5tHoCjbDyk8
	Sf4qXsEN83hWH55sdKiX91i9YTDXNt9la/5ERgJwsxOXInplSevZnF1ACmVQKEf7xf+VUU
	r0b2acbsjf9Yi16wmHxvOIiHH3hgr4I=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so1075015a91.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 20:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794025943; x=1794630743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/SKim++0/v959SqW2Qj0ZN00Ia9M3Z26xYKJjxKUd6k=;
        b=Tiaytl9joDkeTzAC4sklJhRk97wurJCzmiGhOzgd3OppC6TxMR/h7i54Ve5Ys7e6Ld
         jkOHVnabLvUYELpFg6Ob9seyd0dh+kzx2WGorbY3foviAEKGDK30NyEeKLtL2nI6WWNf
         rbI4p6vzL07SPmwWbhYoVkq3TlLjoddmyX0m+ov39QmmYObktkdp/SUP41DRUiKZV45k
         qWW0zP3i6ZkbR5NKU0tr+5YSf8YdmuUo/o9aHzkjMFRBGRTaeFZhKjMNpvRMzZYskz1Y
         tjw8kyd5a8KmTfqssuGYjAR44uRPBI3PfvAHPqVSsX1fExRLw7v+mBr3grwS10XQ6W/L
         HxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025943; x=1794630743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/SKim++0/v959SqW2Qj0ZN00Ia9M3Z26xYKJjxKUd6k=;
        b=imSHtEKCyCrmVpFBINl+1Dat/P5TRiwoJAPB/xOG9BVA4UB0sOzxhDWb9F2A1NBweL
         KnI6tIoIZdHCl49N8MLFBYEFhnNph9d2Br6NUg1bO5GOLUFXnjajiFfdIr8xptrg2hv3
         d4jp0+MA3jblsY8VawTeLCHOyyzL0KlJZhZOS9MCMtTUJo9L1gKAn9LkOSmk4AHEAAsn
         Hx6vnC1nTaxcMXRpndwh829y/TR2mXth58g7fyu0oq+ytu60u4Hqoqez3biBZPrB/whK
         XtBCJcoO/k5jgpqpW75Xzn8pjcMtE2KPnhWNZW1qG+6xjT1eYjnRc81ZKC6R1hkHTaI5
         e4ZA==
X-Forwarded-Encrypted: i=1; AL+hErHTX0PiXVa69cEYI4vyFMjHlfGLN0j8GabZq8A3BuMGVYEEmvvCA+CIBap2wqlYUKQu8+AfRC982A==@kvack.org
X-Gm-Message-State: APuU4Z/vErc1FgBB0xJlsGk5B2HQ5B1DR3eELHrwz9oz0CNk0V/oAt4r
	r5lJq+RJgz0ReLVIYerEXyOXRhKHpcgON4c7FXqFNzXaFK1p9A7uETQv948mCA4fP34=
X-Gm-Gg: AYBFou33tfYFigx8spPRB5YM1GnFU9iBQ1e8k7pwTsIIcxT3DLBMbmM/yQYJt9S9di9
	A+oNWo54dv08z1bpl2jg6Eu0RUmTCmo1t3+/KhHVCDp9nAvG7rDVX84UZtreWTJz/twacQA6EET
	Offlg3LDpZcAIptPoPWNEJCaL0pl1dC4CUB/lsfbkzjwm2V1SlI4UHy+2Vo1DnwNBrt9uRkQ9eQ
	sw0Ct64JQWQFU76sRSxhDcEqadM5paelqk6nbFfVd/pOj5AAtdhUiK2JZv1f+driRguBV+ap5xG
	cDZTTZpLIGBBR4U9P4ZwsCF7IAZsTGZpPzO58gTTGb2/zd8jwDN84Q78eoEIj8xXP/U3nU+/ihF
	ibvE80Lc47FFzKieNt+XZkUEYw03LF7SjyIuLP/7O7WnkQkVLCQmXKEsRolfvrbQr8Djk1wTypr
	BHA0bmBHHpoSd+lKgLjHCAs+a+9MncNoCu4rdaMRZQwIszu3uPIfcWNxu2aR7rdZsH2jgo0dDAM
	GcUtd8ruU9vRhS4/az7M15/0q+aBG48tWGUOHL1F74tkgKXoIEbqthuYq9sYJENPkvrv9Tapns6
	Jqao7ToMskMI1T3eFHWMtEdxF+0cm49yKnSj45UF7yVrK50wtBiQgSDrzmV7
X-Received: by 2002:a17:90b:5608:b0:3ac:c024:b275 with SMTP id 98e67ed59e1d1-3b0db605906mr4825186a91.9.1794025942667;
        Fri, 06 Nov 2026 20:32:22 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10584b66bsm1578451a91.14.2026.11.06.20.32.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:32:22 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 3/5] loongarch/mm: disable device DAX vmemmap optimization
Date: Sat,  7 Nov 2026 12:31:20 +0800
Message-ID: <20261107043122.25650-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107043122.25650-1-songmuchun@bytedance.com>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C72440002
X-Stat-Signature: erpp6hoei66m1ua6ctfnh573dn9wbjqy
X-Rspam-User: 
X-HE-Tag: 1794025943-731739
X-HE-Meta: U2FsdGVkX18iIZBXJjyiISe400rzwFlMK09L9Ntt60I2ElRjdisCqM/lZ0V1yDslD//IthlfuIQzDrLsj3Eghy/tn3vPUnDKaJJA4ZrnNoWvTmdIgCUoE9GnNJ+fQHRc4oToVbkqGYpE92sFVWGIm7PTwRPhzuBXGE3yNYkkhX4efgjguf77N2E+cLOY4a7WHWWcc6BYZfKRja4wbONrD6l7qSXF5M+nLD5lLoEkYOcs+YZOqdiHwXe2vvKc+tB6ekmqQH77XGkUENasHa4bP56GayYTPSY1C+p3PoPCBH9ys7wBJqP4Zbh9lpsU07Dde95E6c+nERMWpdzo2Ec4/SF4cbsiuOVC/0ZJVKEfsVoC0KYks+8LOnr8uF5f8CJkOIj4VMbpKx9gmSsMA9ecr3H+0KnGDnsEqPAIwsUVPFgXo70HhFtnf/MB/MOdCWS4vfksEyoDiw8xNF+VFTeRx6D83mNRI5KF8GZA/QVdbiu6yGXzDBFdq3JSWBHXhOP2jFZsP4CAqJVIQtc0K20REsPdOej7Vb2XiMStxyJrRHODKfbbSRsgX0pR5tSHw6Hky2CkYrNFkNOkmmXuTIOY/UNuMQIjS15l7Bi3THDTwXP6E1DwsNAkPay7MMTCekbBDTlV9/nhSgnNV/1a5Eauk49MtwX2JVdwJ8afAaDge3rbyhFyCuHL22Dv0+Ckmfx0zyJKNFQpRS6MfDkXqAVGxu0Qwkf8PyDbuc83Jo6hfco6D93LPFEH5MRl3qld+Es55TWAwXTildey6SyQYKzZVb4nPtbZ0ZOaEO4+dD6dDhqgIeP3A+mHV6UR/CLa8s4n/vuTWCk3e0c/Sp1RvG7YhEaj3T7YQ7ZsNsDS8KRBg/kMwMMYqpM+a1b6JXJBZD+a2Bm/YdPIQ0dlESBHLDcox/sXpg6RUOL69xgv33U3PnSLc91IpDWCJbAS+T9CtrDzS/WDKvUTmzbZdpBTGXA
 35CKZQyB
 bETNueRDcLfpWc/YuXvdnJKe9grwq30BtLiwasxWayPIzcx03+c3HeRpeCguqqcvua9Db6ZsH7k6IBNSmNJlW48e3ldaM056zCFE37WhTqAYI23r/6mTd/KgrtZmT4ojHjrccBNfoLJ6Q6N5lAIw8JQtSvpC0SGzoJOoGSyV8/vpAskK9CRTCPZ5yn9jwj3nf74So6Zd+tEdmAFNGKsEnZgCJnfA9vEVokv7mNn23p/ACBX68e5DUI/fTxJYaNOzdO4jGvxHWtuB3KC/fj8vlP+hK4AGZpKthfqY2dvjSeDejDIQfEAIo+J8JZC/G0ZfFMGbXCAw8errqxHJXj7D5PXdLByImCvT6XNaBWg84PsvfMsCIbCterv7XfYNTTaB5eHmrx3OZsiS3lv6j4Z3PkZEvwB1OV/09b7AdIg6c1EpOw+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

LoongArch selects ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP but not
ARCH_WANT_OPTIMIZE_DAX_VMEMMAP. Its vmemmap_free() implementation is also
empty, so it cannot tear down optimized Device DAX mappings.

A later change removes the generic Device DAX architecture gate and lets
vmemmap_populate() decide whether a section can use optimization. Clear the
section compound order in the LoongArch path so Device DAX keeps using
unoptimized mappings.

This does not affect HugeTLB HVO: LoongArch does not support gigantic
pages, so HugeTLB does not use section-based vmemmap optimization there.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- New patch using section_vmemmap_optimization_disable() to keep Device
  DAX vmemmap optimization disabled on LoongArch (reported by Sashiko)
---
 arch/loongarch/mm/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index f801f7097f03..ea769e479241 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -15,6 +15,7 @@
 #include <linux/memblock.h>
 #include <linux/memremap.h>
 #include <linux/mm.h>
+#include <linux/vmemmap-optimization.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
@@ -143,6 +144,7 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
+	section_vmemmap_optimization_disable(start, end);
 #if CONFIG_PGTABLE_LEVELS == 2
 	return vmemmap_populate_basepages(start, end, node, NULL);
 #else
-- 
2.54.0


