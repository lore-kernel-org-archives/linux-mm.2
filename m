Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A0D606AC2E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YNMXeSlR
Received: by kanga.kvack.org (Postfix)
	id A05356B05B3; Fri, 30 Oct 2026 06:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC4E6B05B4; Fri, 30 Oct 2026 06:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB476B05B7; Fri, 30 Oct 2026 06:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B76E6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:59:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82B1E1A06A3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:59:57 +0000 (UTC)
X-FDA: 85378997634.27.B1B7001
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9691E10000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:59:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YNMXeSlR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793357995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grU69V2izEqiyRQzFTG28lTTPJjElzjd757Ih1SjJmw=;
	b=k06Su33pqkEarsweM5Vn4AUsYBQLT/KH5P8xbqcw37wZTX6kdw2faaU4hLAc6GQH3tkWRv
	1rXXvPk6284BlGBKLrL4z1tbcWCc9S51b0IUF0mm9uAebmHZgy9rTvRrawphaDBqpysfAr
	nOIP2ZfJ/WIwQ/BIdXw47EUFwwVy1tY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YNMXeSlR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793357995;
	b=nRWeY2pRzGQIL5dbsRnQqNTuGhSxz/7cWt/z7O14coC2GHrbQaEmIGEySh6/C/Vbzrs6x6
	uARTv3PHJzUw6AC8bj3crvS+bBl65N3GtFWb6em4eRplPkNWkjvt3QMZSby6fuzIJXwo1x
	z1ivwxZqJhJZ6hSjWdQsvJ/ALYj3wPs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CuJ+ZQTil/SFgi386JLyvRG7Aby/Bj7KaYnuIE8fy6Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793357994; v=1; x=1793962794;
 b=YNMXeSlR7KwSt0ujwdKsVyF8AnGTOL1mV2LrEKPXtGkpKM9rtYC6gw6Cjf3If9zhhjhyoXnz
 e7ux1o9ap5yFJwr1RMIMyrPlU8acMLGOuliKufNgYwKQ+xeAO1J2aQdAoKHvo1GMzb1oFTtH1aw
 idfIR1JUxbG7/vNIocBuqkK4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4afd703a427bb278;
	Fri, 30 Oct 2026 10:59:53 +0000
X-Mizu-Trace-ID: 4afd703a427bb278
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: akpm@linux-foundation.org
Cc: palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	glider@google.com,
	dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [PATCH 1/2] riscv: Recognize P4D leaves when splitting the linear mapping
Date: Fri, 30 Oct 2026 18:59:32 +0800
Message-ID: <20261030105933.4180-2-liu.yun@linux.dev>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030105933.4180-1-liu.yun@linux.dev>
References: <20261030105933.4180-1-liu.yun@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9691E10000D
X-Stat-Signature: 1614u313yfua5k1ek99sxx31jpxch6ty
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793357995-489992
X-HE-Meta: U2FsdGVkX19Lpu6daPMVgE4MSsmB+rUhTlkKN/VQ2b7yVvmFzSw+hu1u3Bdkk1My6m1QE75F3PMx1GoJaDUuvv21ks+uZ9E5HZ4BdH/bxWgk80miks+XgFNuk7yEXvNltocchKxVQ1CikyYj49RtVWT4+yNm+CFQrP5XdiIK65hWkTd+SJG8DLFu1c98Z61BMjIFxN8rhRzquAALkGZ99mLUCAtGvKYn/lCtvPsG4TO21VnVcTlpgKuhv0HUbbFz7jzLec+pdLrCa9CZjEZDXjbaR5XataEd5dgeqCU1oDtrmA/DvQsRizTPM8WX29by0SZR+IkZPNPOKD1EVH0x5XVfDe3T0aDtbt6K8m71RthZEknWGcOJ6kssrSbvPz2G/71KkpirQB1sVpVLHfNvkv/XmqDmD+wgqF894TayHpUYcdbwbTXpwHd1SjDSVCcvHq9wK+riJ5sDppDa33+Z+7N4eJLJYGFGSkOGiqUFVQuTrKqMWCrdgrGRRsiYyVs7lIJ6+hmoVVUX3nCQnM+dEheNykuhCj0wQ2Hhl/XSzhSeOS0P2Dw72irdKViPpXo5X8MPpuL83n+pPE9pG3lY/67/cIpiC+k5/+dBmeACJhxb57vO4Jkygd6c+v6E1hxCJ5Y2ltSpzekY9ANyIEDuIiw9RzSkhSw0aEudWZnD/ZMkYZj1g4siMuhETNRAPtxh7wY+VasQ9lgDfhQ4P6FzQDfEIUHSbyHKHDYkeXiisjr80kChLSKdzwAgzAMXlnff39sDKj6UVU/uLgYlG1dAvpNCnsnGBxwtf+dQ5dKcWjGkddJXQLVOXwSnWmT/YrigOOL2KzwcbJnxRtybOa0+/F1AnJEmV0oaAOrT94phC9laBiVP8tw5AUysdMVPraxr3w9bK74WQBSySJQZUI+ywJGZzAb40uF0ojkHELb0WPg1/Wnm0rQT4/cvoI13It4HKnILqej/tekEHke/R9G
 NdUs5A2S
 pL2bCa2tR1rIyNocXCFjzgq5UEQNhWy3dOHpZ7SQF7QZnGDqBFWIhLEH/X24Kzt7S56dH8WHIbfOWThc7AplkuSWXFtAFuottcH2CFMvZXoDeSyEVQzHeYgIUfo0QLstdBfxAlKa7mPsCDyYjIhBrItfIzGEFRRK1B641I73hoKGRbXgrB5MK2kzek2CnNjr0Sd5ZGcZUaCDV8OpMHmtxQ/QCI8N6gllxkpOnlo0lDkSdM3XovoLJcyzLaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

The linear mapping can contain P4D leaves on Sv57, but p4d_leaf() uses
the generic definition which always returns false. Splitting a partial
P4D range therefore treats the mapped physical memory as a PUD table
instead of allocating and populating that table.

Check the hardware leaf bits in the linear-map splitter. Only do so
when the PUD level is present: on Sv39 the folded P4D entry may contain
a PUD leaf, which must be handled by the PUD splitter.

Keep this check local to kernel mappings. Defining p4d_leaf() globally
would conflict with the GUP assertions that userspace P4D leaves are
unsupported.

Link: https://lore.kernel.org/all/sashiko-outbox-190189@kernel.org/
Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear mappings")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/riscv/mm/pageattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 5b3cf326455db..32834a09a8097 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -197,7 +197,8 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
 		    vaddr <= (vaddr & P4D_MASK) && end >= next)
 			continue;
 
-		if (p4d_leaf(p4dp_get(p4dp))) {
+		/* p4d_leaf() does not cover kernel-only leaf mappings. */
+		if (pgtable_l4_enabled && (p4d_val(p4dp_get(p4dp)) & _PAGE_LEAF)) {
 			struct page *pud_page;
 			unsigned long pfn = _p4d_pfn(p4dp_get(p4dp));
 			pgprot_t prot = __pgprot(p4d_val(p4dp_get(p4dp)) & ~_PAGE_PFN_MASK);
-- 
2.43.0


