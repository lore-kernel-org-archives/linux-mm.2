Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EB3C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7876B0095; Wed, 19 Aug 2026 11:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41856B0098; Wed, 19 Aug 2026 11:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08726B009B; Wed, 19 Aug 2026 11:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78EF26B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:14:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E53851A0334
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:14:09 +0000 (UTC)
X-FDA: 85118364618.04.0C568B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E304C4000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:14:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyTW9KxM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787152447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtA5mvQQ7MuCXISnQbexM1kw6XBF0r5MhQXIqx1BTrs=;
	b=k6TPT0JaigpZcbNacDMUBMcSc+i9JbWzm55CsU+dVK7IkeAAGmpZHuaL2jMidfPAR4zfga
	GSILlhJ4KZGJZrcDEMJGjQTaeqARJ5lMLzIh0TlMfaegj2mp9O+1k5t2E4Fv3KPeBck6vh
	s2nqyn2yydCukFvFKvZpn/7jZqyccAI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyTW9KxM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787152447;
	b=MY/Ztd1qwUndmeLXjTPThiFP1qhIrdDOgFlDcsg+/Gm7K6aGbPUb9Yv3R71JXwx/+sz2d5
	ixrLxqcYaaFsvmxIPCV6VJNYlosA1SyMZx4ID+uXQjKV56spV1QEohqhlalVbhCNfWiBFv
	pg73kobM0qdtqg95rYxVi+tuU+4y2Xs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B7C161133;
	Wed, 19 Aug 2026 15:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6C81F00A3A;
	Wed, 19 Aug 2026 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787152447;
	bh=AtA5mvQQ7MuCXISnQbexM1kw6XBF0r5MhQXIqx1BTrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kyTW9KxMeGmjCVvOyZovqsWUN19LtbHsM6+pFG9g9C0IY2Gzm5jeHEZuIX4R4WYgD
	 L2q+4GcZrdsNv2NR/2WgLvvASYQEmE5B5Mp0S7W6dXcb+nJZ8QRek+EfeJty+wMjsM
	 w0dT/z0hgYYnm3N2qzo5IQkMOQ3Cy/G2Tkdr24RdUWQTVZNE9Y6pvv3xgpCxng3Hh4
	 wOvwnD4fqnpSzkMwrIYZ+kJn34EiwpKs5zQoEMalI2wZpkjNMklHh2hYEX/gSPhncF
	 2ZRyu8J/1WbXIzWuRDPQWvznzBZqYdYEo8CemYNOR1w1Nyb20wKWTvswo4DLDO4usz
	 YlgI0u/nwqXPg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 58FEB198007C;
	Wed, 19 Aug 2026 11:13:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 19 Aug 2026 11:14:03 -0400
X-ME-Sender: <xms:NsiFamOuKZvGYeAAZ4L5ohcD3ssXy7I_ylmo8Kawg94Gx37f_cvwIw>
    <xme:NsiFat4mYgYDhTg9Xqls3EOPayqV9OoTnY-rq_KP3JhUhMNKrkPyAl6p7F8LjV5RY
    4_TxSounAexYmN_4KXvl1dbujckye7fYzjIH-sHbQ9lc46KizskvA>
X-ME-Received: <xmr:NsiFamAm2qXSqU33q9I8fSCrdWuiigNIrxM0aZyaSJ8zPl3gd65ihLXMIOA>
X-ME-Proxy-Cause: dmFkZTFC874SqF5jgsGEVLBfbAFduP+mDXsDSwMWKiKTuMoavP1oB+KifqBRX/hDeHraKn
    C7cfsEd3id27APShl8ehKo2D/BrLfhYUjDUUJSYZnUAyHw5GR6ippKZ0dIcwwUwUUBJHfz
    tLscdKxQf9sMOh/ztP/IltP5J74r5Gk8cLjJqG8ArQ1asEjzFDgrqUKPLajNVdLLdS11CP
    wjMu8+NSt/1a+rRq3Y1/7hVBbm06JC+qs9eHXcOOmC/NdFBysy20LymarntUyvWTXty776
    ciqsnw8bL1OmbbhooeEbBHnb/FJ3/96PTKBGsUb/yZ5BM81GiTeOkmXadYlHbmd0wp4Ycz
    6h4eGTiM3n+KmSTR9SP8vg14497+uVjAkCKo4mr/vkRcVVB7VWoR4cyUF7fSjESRpzXqAU
    nIlwrXfkMuO5qFJUmYazFuG/a1G+DBMOlQHq0FMvaDl+Vl9MEE/sIf/7eyBSFvPEYMDqov
    BHrBgWFdhKuZ93N2kRYuKtkW9mXDEwmf1CfDwLKjsCVO4d6gui12hg275bxNEE2HSBRvi/
    e6/tsu9TCQGecnn/t06T2OHuU84IlSjNfnzHk158PHdeyb3jcwEpOw/Z3kuMOsPLoN4K93
    RhGohPwdLXodlGh5VZmkyITb3tPMBvQ1zGE9qe4yNl5pCS7lNXmFpVjUE7rg
X-ME-Proxy: <xmx:NsiFap2xZmdtLZKCbarFoA0iZSm4qgWMQrobeQkxT_obtjN3a-3CWQ>
    <xmx:NsiFal9tTi1hjYBwFaWcBM_9zeLojWqtH2Fj_mPaM3rNbTjNZ7GRMg>
    <xmx:NsiFasULBJKl4x-J88OWpdLTxnSj0AYgofXFu1cFKiNPhbl1IDdsqQ>
    <xmx:NsiFan_GPLdcQtcMD_vjiF86soiIhawNtWSh1hKPBRZWQdVOgtIljQ>
    <xmx:NsiFasbruTA37Tr2NPbaSU2DLnYA9adkZTCDAUTYsuUAYxcSu28E-Rkd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 11:13:58 -0400 (EDT)
Date: Wed, 19 Aug 2026 16:13:57 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 03/12] mm: add PMD swap entry splitting support
Message-ID: <aoXCVDkaEpvk3GOA@thinkstation>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818131202.494754-4-usama.arif@linux.dev>
X-Stat-Signature: yh9nuntynpsjdtpj5qpbjfmtga76fodu
X-Rspamd-Queue-Id: E304C4000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787152447-638704
X-HE-Meta: U2FsdGVkX193WbOxNHpU3rEyz8fQ2BdJ3tAKoZ5s1DlNHr6cIieAlt9WBZxAWuuxAhwSJS07qnU1Mzz2eU2ZT7b3+ugmI8wxQcNpyd6p2lkXkJKD97uBb/tWNsO/MCYz5Vp8I5jDMlwJURW4v7W8T/WKsZj0SjBcOBtjp/ij2xcP5JiFAWlxTTLRHewxl0LuMik6G8kKYJhH6F5VHMaf+Frt4K/x3kAYDV3/SPqM8la38I5YLmLSCt90XUx7ZzUr33kXpTB/22ryF6h8U2Fw/K7/+gxTndmKnG9nusFpu4lZ5OsQkwz2aqTFTFRvSWpesiV+gj/RQW6Ft0XXoCHKs1HhvuOL/G/YcxaKxWwWlr0k5p1YFPyritwfxc28UJ7DEVIL5q9dr85SZfrTV2ChM85cJXGa2ulW8/+08KlQ4oCgyRWe8vYReGzCsH99hywv49JC82WppK6biFb3iNCZsaSSS7WaMpkbmoEabLC9UH5yQMdctN2PKLN3vN7K1Dge7yDE2exreQLicg10oxnC8ImXFZMhHug/xaphA3MQpd7Vy9DKXLwqnHXSs/foMKCAbDACzEbBGEfyDena55d7VqunJLiZlVAPU0A6jqzBiSBlpDQapPAOHO7eHAgj3YLffMkMirL7ixueC3bqmJfKHeaKrXi2u76x6OneWSqE4gy/k0J6YXBaxzvlKpVjLQQ1+ts6YVMQ4WyLrVt56VMSJ4eNhLMgjScwS6+KccW5HN5rum2ayiJRnfwP8fZx7ze8b8X5g+lWiYFXeHu0lW1AXMcV1uZGY3XkJQ/3ZSZFu+i/UPWQF1aBK++BH7uKG2g6Harw0L5TTEKWW/rZZZt8EYSa1f0HgQj+SbfSMWkON1gDcK8uwHSGZHinQkYDDf7zEy87msfFsVQLDFokESpfSw4T7FNk1XpD4++h3aM5ooRW1XG+lF4xtByt0wElVEeaM6ZBgOlWw7W2owxDSUS
 +SmdPldT
 yQHXBbAo5mPducOikKiOWVUO1DhyvSUgpwOwMRvjgApIskgdh1+o742oBl8GunOr8GJ70a9VTZNOGH5+ObQ2Jx5irn/dnQKZ8iFUIpXjn5/n84+BLXw2X2tcZXjyyAv2zGgnjYzcacGN1OlJq4hsXNotgrmdOSNU/qTxfyPuiA+JASZoKlktRrYwGQAayesVXFcyjkfvgBhI+3R9rEHSp0zNUxEUfl6JKx1+TUFRZefYttXA3TceDwW/et/KnJqBpoFeCYexEEDfrk5vDN7Dp5pN5Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 06:09:44AM -0700, Usama Arif wrote:
> Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
> entry into 512 PTE swap entries. No folio reference is needed because
> swap entries point to swap slots rather than pages. Each PTE inherits
> the correct sub-slot offset and preserves soft_dirty, uffd_wp, and
> exclusive flags.
> 
> The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
> rather than *pmd: for a present THP split, *pmd has already been
> cleared by pmdp_invalidate(), and that invalidated bit pattern can
> decode as a plausible swap entry.

Hm. On x86, pmd_present() recognises !_PAGE_PRESENT | _PAGE_PSE PMDs as
present. Other archs do similar thing. pmdp_invalidate() clears present
bit, but keeps PSE around, so it is present from SW PoV.

pmd_is_migration_entry() should work correctly on pmdp_invalidate()ed
entries.

> This branch is reached from the explicit __split_huge_pmd() callers
> that hit a non-present PMD: partial-range mprotect / munmap, the
> wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
> added in later patches when the cached folio is no longer PMD-sized.
> page_vma_mapped_walk() does not iterate PMD swap entries, so
> try_to_unmap_one() and try_to_migrate_one() do not reach this branch
> and freeze=true cannot occur in this branch today.  page and folio
> are therefore left uninitialized in the swap branch; a
> VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
> invariant before the freeze path dereferences page_to_pfn(page + i)
> or put_page(page).
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b6b0aa2baa3b..a473e85d30f51 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3252,6 +3252,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>  						 vma, haddr, rmap_flags);
>  		}
> +	} else if (pmd_is_swap_entry(*pmd)) {
> +		VM_WARN_ON_ONCE(freeze);
> +		/* Swap entries have no page for the migration freeze path. */
> +		freeze = false;
> +		old_pmd = *pmd;

PTL protects us from value drifting under us if compiler decides to load
it multiple times, right? Same pattern as the migration/device-private
branches above, so not a new concern, just checking.

BTW, do we want VM_WARN_ON_ONCE(pmd_is_swap_entry(old_pmd)) in
!vma_is_anonymous() branch to avoid surprises?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

