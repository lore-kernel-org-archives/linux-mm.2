Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B1FAC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 07:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0A26B0088; Sat, 12 Sep 2026 03:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0814E6B008C; Sat, 12 Sep 2026 03:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED98B6B0092; Sat, 12 Sep 2026 03:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5C426B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:38:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 427451A0439
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:38:19 +0000 (UTC)
X-FDA: 85204307118.19.EAA3C76
Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EFC0180009
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:38:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j/DGK12B";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j/DGK12B";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789198697;
	b=oWvZ1+WHn8LFbBFjI+jyafq9hb8OE0EE48zBGg6ehjMX1Glnub84QVGEOGXahmBZ4PAqdK
	7PdRXQRRHdFyCMORhth/t7U7rnqtOulKlSLOiSsEpBg9rLYCzk87x91EcplV8P3vd0QIKm
	bki+U1OuemaDj8G1yIi+YbvUtbzsqPQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789198697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSgwKggMZZEINRzruvckSYN8CkiG0YlzpT9zzqZL75c=;
	b=WZS87ZmqnGVzlS9PusGA55QsrpynasP5hpEEchSqiIvNGVTwZobIAGMh1K2JFz4Wi2tj5l
	EGbEw9T0jZGc37IXD6DjeWZdeMKXUf0rriENeAmZiyWVWVSzcn7Ut1nihHfSGP7HyVZQWG
	wO0uPjnP50yjzhVbowvvXzQpWdMr/XQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=951k9p3C3OHpYcCEeTeS+zKRLsyye3/AWkca/cyq9wg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789198695; v=1; x=1789803495;
 b=j/DGK12BR0xHMsYBEEZM/+30kdmK5ECke9/XzCHuHtvXLqaJIeT/IO6DihCINCA9AMuOLYQb
 E1pOYpwKWHbWg6zZufKQwBZXBunNYpsvYZgFKUd4Q87sDa+YNSoiGt0w5zP1ctX2b+kQXA/HOoA
 hdDQ3yazcuwOWBGIBwAXei1U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 937d4987c72d0ac1;
	Sat, 12 Sep 2026 07:38:05 +0000
X-Mizu-Trace-ID: 937d4987c72d0ac1
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: yintirui@gmail.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	david@kernel.org,
	ljs@kernel.org,
	dev.jain@arm.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	nico.pache@linux.dev,
	usama.arif@linux.dev,
	liam@infradead.org,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 4/9] mm/huge_memory: use normal_or_softleaf_folio_pmd() in the PMD split path
Date: Sat, 12 Sep 2026 15:37:55 +0800
Message-Id: <20260912073755.8403-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <efae5222ad43f749c40aaca9b759b41844fdded8.1787941780.git.yintirui@gmail.com>
References: <efae5222ad43f749c40aaca9b759b41844fdded8.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EFC0180009
X-Stat-Signature: ypkj516db8zcb113m9mqjtc9yuwr1xx1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789198696-693723
X-HE-Meta: U2FsdGVkX18J5ZzGP9f/z6F4raAv90L8ps7JHA0cs8N20ukx0qfv8cQis4EBvAmm3GRW7oISBDHPeFNqDGMoykayYXE1NItUkt3778CpGoc0qPXRdXxSLlRaAoRM5uOS0pJOHJk1PURsmofftGcMxcRqcnXPasvcJuaAQsvKVaOchp6y6ny4JbBfZyV8c8gjxN6Y3nrJtILM01AXeEgg9VZ0EN73dTJfU7cgXKl2epRcujoOpMQyU5MBPPVpIx0JCqS1n3yR4Vo1QQMWyqDq1lLmir+5zpxXPRCRbYYKgNsgzGUWONy4DDLsEMCLOMqerQgnqQGNyGz2yEaFk8S9ZGDI5QybpVOCjL79lDwm0C8fxT9ynG0Jcdw+REa/TFy8wuzAACoi3fIll8jNJYZLwKhM7NyvZV0bB1VmTXJOqQchWTG2cgi4WcWSfKzeHaXidYJUnoG4RaCoQTgLIHjWRC5R4yH+6c2Cdyc3ngShPI8d9Bb/NML6uv4BRZAKjeenvp5bzmwXzGUV66fPr+u0UtT+RndKi/rqyoXTO0xnOAKCVLyj5BYg9YdjQlQRqt1WqHrRbWU1RGMLW9HafwzbK3ULDrU3aAqq/xrdMVkfvQxRcUC7/vSVGKONQaOWiDGqF/cAzY0FARFOaHVhdZql/2Mnzw9xLjIf+n50Sg8aHFPGWSn9k6yQVopc3Fp/gytNkvm7LP+ozFMrwEgfqzjLJM3+FF9FaFEK6b4fUGogGGaEkY0CTuUVbHJ43TO/k3fG/neIOioUttBcHFmhOUEdjlJmjJxweeUBM5P6MqE0FLoA7PKLkdCqOWn4CMKLOVVO+kngb3rJIPPH3JEbOtm92Dda/uiyURP0cpUoGipXzsaA6vquz2HaDBX86INh5FlQPywumerjz+yufJhh/u8PAJ1uMv2tMXuJeYELzZJTkZAEJf9dRuZoLYfavHFRr/CJJrDPGCfIFP1gtxuxez3
 IH7Ozo0m
 LpvTsXy5i8MfhOLfGByat8mWNCINI1nJWuonovOuH9PwFr2QSvf7Xib6xnNbBs+lShTrlO2bFJwJqPahVQ/IXGSqKqfUPxoauO8Jqc18qnecHeWAsMTb/IrUoec0+B2lsAHu2Zx+u0oVTL/++P6ZVR8dJAG/l9tbA3pzj/yVc1ScBk95FMi4KH+c3BI+jFUZImDBAPRO0Mmm9mem80Fz4YL/5bBmaP0D/pHTFosgqmJF0bndUCXZM9g9QXbn55u8AizyOUde3EHalTwscctDGNF3gE1eiuV2dYDXaNv4EN2UMIVYu4mcUwSKU1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Aug 29, 2026 at 02:33:14AM +0800, Yin Tirui wrote:
>Get the folio once with normal_or_softleaf_folio_pmd() and decide the
>deposit once with has_deposited_pgtable(), as zap_huge_pmd() does. That
>makes split and zap classify an entry the same way, and drops
>vma_is_special_huge() from this path.
>
>Behaviour changes only where the entry and the VMA flags disagree, which no
>in-tree path produces.
>
>Signed-off-by: Yin Tirui <yintirui@gmail.com>
>---
> mm/huge_memory.c | 21 ++++++++++++---------
> 1 file changed, 12 insertions(+), 9 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index aefd62827139..b2ede9a6ae5d 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3172,7 +3172,7 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
> 	 * We are going to unmap this huge page. So
> 	 * just go ahead and zap it
> 	 */
>-	if (arch_needs_pgtable_deposit())
>+	if (has_deposited_pgtable(vma, old_pmd, folio))
> 		zap_deposited_table(mm, pmd);

Staring at this ... I think we're missing raw PFN mappings of the huge
zero folio ...

static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
		struct folio *folio)
{
	/* Some architectures require unconditional depositing. */
	if (arch_needs_pgtable_deposit())
		return true;

...
	if (is_huge_zero_pmd(pmdval))
		return !vma_is_dax(vma);

...
	return folio && folio_test_anon(folio);
}

If a non-DAX raw PFN mapping on x86 (say, via mshv_vtl_low) matches
huge_zero_pfn, vmf_insert_pfn_pmd() won't deposit a page table, but
has_deposited_pgtable() will return true ...

Before this patch, arch_needs_pgtable_deposit() skips withdrawal when
splitting this mapping on x86. The new check would instead reach
pgtable_trans_huge_withdraw() and dereference NULL through pgtable->lru
if pmd_huge_pte(mm, pmd) is NULL.

The helper already causes the same bug in zap_huge_pmd(), but extending
it to split is a regression introduced by this patch. I'll send a separate
fix, and we need it landed first :D

[...]

Cheers, Lance

