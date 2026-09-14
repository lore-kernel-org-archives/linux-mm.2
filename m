Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF4AC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E306B009E; Mon, 14 Sep 2026 07:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF3E6B009F; Mon, 14 Sep 2026 07:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D396B00A0; Mon, 14 Sep 2026 07:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 081556B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 176621A032F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:57 +0000 (UTC)
X-FDA: 85212183714.15.C761317
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3241BC0003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mmzsJiAM;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsHDceZzlS+Rh+iWWqSfagDmXjRCcCnvqYJsO8T0XHA=;
	b=G1v4+g0bOPKxwIiG2LgGCJ0aqz1tkYYi0Wn6vODjDDGEcOk7nelIuB+kSBZfZlNhZHFUPx
	TeLZMGmmningY9+bKSs8V1K9YUFplNiedDlkyhWZUBZBI8i9Z77W4AKf4M/yn2QGxBK53M
	wB3z/37mnV7OXFHl8n+5ALN01JkR1ig=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386235;
	b=ZugYGdYnaaXCSSbg3/8p+4TVFTsjT9zIPXVSGWtnMK+404UWcNciZSqBgc7pvKmT/pAo2H
	QBmpUnkGWg//MzHgXkqB+oLZv9e5B91vOxjmwSWRp0mDAFozc4CyWWZ39zarvzsCFbVen3
	IVFnPwEuAeVrXd3t0NmKdWtl0ppuRJo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mmzsJiAM;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JTBS0CwwRKFBvKNpf3wbmiqAAg6MPp22qwqUFuq1B2o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386233; v=1; x=1789991033;
 b=mmzsJiAM1kaMT79fE0HYBjBkhl0bS4rxqCFRYXMOSqkU0IE4mhBpBIB9RbhwrvRu0Y5FVltP
 l4gnuxahWYVXSURIijwrUBRRTdmIGqL200WLmLnLaZajyxUfJiDv5nadQoTuKxmtzaJMYXxo2Tv
 o63YOSc+MbRmyjzDjqdCeJ7Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id adc92ad1db3905af;
	Mon, 14 Sep 2026 11:43:53 +0000
X-Mizu-Trace-ID: adc92ad1db3905af
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v7 05/29] riscv: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:41:57 -0700
Message-ID: <20260914114320.12988-6-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3241BC0003
X-Stat-Signature: yp6e3cksk44p76kmmkgj9jwfktn84nu1
X-Rspam-User: 
X-HE-Tag: 1789386234-109200
X-HE-Meta: U2FsdGVkX19NnDH5XDz6LfP00900rdtHjo122ng9x27LUSdx5gWV2kldB988js5WQnp/q0BTzMFHZ2BTzC/JR8ILVaINqamHoK7Va7KsWWnBkpNgg/xjC0RydJEv1Iy5bRN9t9NS/8arBHvh9swZ8QAae20zypViaE9oqNewVdGLA384Af+LrEV9Zx31MYP3WIqvFWM0tSdTvPmNz9wibxZW6K8LQ0vVM9nUwAlV9KqQ2ZWjXHVCTzAgk4Vx3EejepYgqbTVqOgv70O5/1UWIFNztWe9ge62c94S2gBwGpAG3Vp1Z3i4NzioM407M98aU5qj+gmG1t75WDOr883XDvzLBFtRlUwItDuRQ3DEiWusMC9s3AAoWY3koEUW5FgwMaYvFjPYF2OGXzTNAnIL8i/UDoEZONZnLzdwsdr36m8iNV1qEpdnlD/Y35KzGQ/sKUmfc5n0FtL3J4FdOQv7O1TT0UE58tzyC9OKDRTPrHckxU0uo3Ki6jp6Fpj9mpYpB3iE6qQpxe2rKkTqawYSZHJa0eyAP6GoRPNutcEDfwv6mlqCz6xGafWXTSxji16g03G2CrpSFRCspkWOEs5a1icohRiMtnVTJus9/EchNeNQDZbeXuce3kuADvAeInA+QaulCX8Z6Sh/kllcjZsYw8KtAeUIhfP+O78XMo5CXPr5CnEg7hAg8Q4ybxyUM6d0z7tsdT/4z+r3rYlf6iS9ix5G0otcnODvxtP9XRpaEHhvVvDFa9U+R9thVpAafEyuLm3lvCr3+HWKWxkFceYb9YhgFmT7gOwhh+3y8bUSixCMkDcisoRSCLIxHFGmmxagszKwhj2uUJuiO7oeSNufByWtgHkc7CbdNsO1IgVKgvhBGkCGudwIY68GmuiI2uw5jrbhXvEQ6BbReffoLIGHlGtmnip7E9rp8snaZxv9kSZ/soAULKkAzVcez7ycE4b65gRk84mz/cXgrT5VW7z
 2C6vZJbW
 OtPOuL0HKBdQQ39ieVj2LUsVD0p1lA2RHKAKJzNIYcfokXp93YqsAfIkmedvB2yLQrUiloEWn7XZfk+9W1WdIw2RhBRptRej6aRnKshIkKw4MkHBCjDDI1++WEHObMVTJr5TY7fZocWKhP82LdXpelD1Z0GLa0ZDavuc/N40ZXaR6C4XWoTryDItNL361ULdFvNOSZEYRiqkKx0Nwvs4mXnx4fS6IHSqBFSiPEHobRgGXQq1F9nISu9Ehy3QTJLA6+YqBXhgiQA89MhACqyGARIFGQgIxXsLHX5D4MVbeFQNSnPUfJCtb8mWVug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

riscv encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse _PAGE_SWP_EXCLUSIVE.

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/riscv/include/asm/pgtable.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d48f90140841e..b644db16bda94 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1219,6 +1219,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pte_swp_exclusive(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
+}
+
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
 #endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
-- 
2.53.0-Meta


