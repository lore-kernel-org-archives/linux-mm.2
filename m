Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640F2C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF93F6B0098; Wed, 19 Aug 2026 11:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA816B009B; Wed, 19 Aug 2026 11:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98E56B009D; Wed, 19 Aug 2026 11:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3DD6B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:17:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FE7D140339
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:17:03 +0000 (UTC)
X-FDA: 85118371926.25.D36CFD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1AF5E1C0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:17:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dErVKzXQ;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787152621;
	b=7M768Dr+J0btFtka9OvUClC/YZdMC7MyuDI+JIv0jvnyySC+/R75rbT9kaFoovOVNrYoER
	A2QxiTUPwh0y40iOfPcg3qNAYd/NcSgKsPH4Thob4en4WaENpF2OPKEI7Fd+crwFKX2XzK
	4rc/aljoQLr5Pz4TJJ1uxc8p5wPSAF8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dErVKzXQ;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787152621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIJZ+Vnf9H1+s4n3J23U2JGF74uy2+otNg6jnrrxAo0=;
	b=3cTb0iXk8sps3gIyXM4JNYC+wzSGVBfzyzGDfr+tHk0lvBHuAul9hBtubCZ4Tbzo4Xt/NA
	9sBTF3GPYctBJNUw1A21JNiIvhmY+G7E+Y5vROxMio+d7mdZZE0TPEblBSOWqClxLVgNWL
	QUo6G0qTUT9Qh+k2vPjuJrEBR85UxOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77B5360A92;
	Wed, 19 Aug 2026 15:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218A51F00A3A;
	Wed, 19 Aug 2026 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787152620;
	bh=TIJZ+Vnf9H1+s4n3J23U2JGF74uy2+otNg6jnrrxAo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dErVKzXQKg0Vtr6WVxumyAni+L6Yc8iWA62lmnz3K9DTVZn0pf1Y2GevFdDzwSmMJ
	 Cd1rcnih5RhWWEEz+lAwF4Cus/h4T8TL+kujwBDRwLRUwsfC8cJ2JQKRcgjttobWzC
	 zkhpNM3xHJtGI8w7fk9nwP72f4roNoyOx02O94NeR5n5W5lMm9so2SwviGC44bNeMN
	 ooLSg/m9sp1E8YyPMIgUELQcfizwGFdeSAhXHugmZHuLRwsguT3UvJRUNZeUvJFEeX
	 22oqv7HHZ22Nr0+z3sD5LUSHY2ffVnzglsVqAQ+96BfwyLj5ozgEu7740yugCnQwIY
	 aR1pyghYwCmcw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 55D661980045;
	Wed, 19 Aug 2026 11:16:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 19 Aug 2026 11:16:57 -0400
X-ME-Sender: <xms:5MiFavCzyH7N3KN95DzcBTX116WEzP1A6k_zO21BJjrXh-jQbYmgpg>
    <xme:5MiFaucxEDTA7a_jSM2HbMB4lYdWNcOW9sGiwrQMIzFbSDpuwERmt7S8MY40bwBzz
    -7kwzhqtYhGIqDA9w2XzUfiOxfL0k9qdzcYAMbpL5CtHu22BjJYS4o>
X-ME-Received: <xmr:5MiFajXvKnHIqJMCYuFL39983ee2Pw-bVaBUJMcogpyT0z1fbhJnpixDcyo>
X-ME-Proxy-Cause: dmFkZTFFAQcZD930YtWtoCMZ6vOXHN1s/JZZPiHZlmcWnnVTPS89T5ThnggZ/j1JZQrgY+
    mfbzDzM/k5+b0KuvdZXgKBkmN5a6XSbon/TUIrGY9Cj2rhLJG7IXeceW08r9F3K052egp+
    w4P4Dxj56kJ5eMHulVxcC9wt50/9fYRr1dzx9qH1RUpA7C25j8+4qXCEZkODRGJSWOFFM6
    jMU2iIK63RNBoZy6so2dmyWmBMy/12VsGpBxLKHN+s6WNB/3HBxp7S+QeZzhhSfQypNpBP
    14zTUjgq85k8Lkq0EyNGzDvkIJY6IPYEaNp+sgeUPbNvoOX8SLs+kk37/PGb1saa9CRfgd
    XZaQDuCE1MUQ59BwBccZA6dv4aOhR3Bwfmi0FJeb8UHJel0YMPSdkP315hT2mxeozV+WeU
    2i+8oEA6KAahf0ZyUAUmkpNZtHRO5nwf7FbYL5VOtilLVb/OjwFLH6RQKAb9h8RJbZkwGb
    VnxNiYovji+Z9nO1/lYmaJK73AWhsajX3zIhaCq+Zza9ZjA4ShcFuaN1gv2z2atRyAaxTH
    zmKL8yI2yFKPrx8pLOnsfcEyH2TM5XgugHcS7qdMcNbOLsP88Qyyrijoko31N64nB4q76z
    GfhNJJ0mVsAPl424reFUAZUtaQlA8Vx2ONA+1soticZrLcpLyO3Yb/NtcQ5A
X-ME-Proxy: <xmx:5MiFak6Sl2dml8_jKHzJb2rR2YEa5wsQ9phYCNpEabfLIdg7w9qYxQ>
    <xmx:5MiFarweKc2puMyjIPXIDZieytna5g_UxsHAiSIqZ8r65rvBm91RYw>
    <xmx:5MiFal4eN0X6AyFrTJ7Zu6U1u2Jmwko9eu_LVvxQGQqWMnCftJaGng>
    <xmx:5MiFaqQnvbmtNMZoo9Hf5mYB4aChhZ6gLyygGNBElczEQsm2pa9Ipw>
    <xmx:5MiFaoeGxjziW4kntCmejbJBa_tG1dwwBeL1gvKJHHcswySQ5VNBtwLj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 11:16:51 -0400 (EDT)
Date: Wed, 19 Aug 2026 16:16:51 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, 
	ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 03/12] mm: add PMD swap entry splitting support
Message-ID: <aoXIQWO6NEfEKipn@thinkstation>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-4-usama.arif@linux.dev>
 <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
X-Rspamd-Queue-Id: 1AF5E1C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dks81x49fjg83c7f6tm4399fj9oxk9m7
X-HE-Tag: 1787152620-106822
X-HE-Meta: U2FsdGVkX196wjySUXeCR0nc8pRooA/KEuGF1u0lcng+Y6ZjCVjaXuqp5GlSnVKKTH1m1rSMBWumxq4Q4IeYIhvxtYScw9/PlSyk1mHdfBnZTJkp1fHv1qGqXkqa7AjTclpa13cH3LyN0eruKJUGAX9+U+UvfSGo2ZZPjArbfHX2EsyvgO84uErQL5GJG7iO3CwDXVVyUoecmZzhPFnnR4JMCtS+gMALH+9vCldFXlblqA0D+a4TqF3Oh32pmr/4MMyg6Qb5zBw/NLgYu4Gj60vG9Clv2wxd5hnNQbyaI05AhD1+KsZ4MVT+HjmjHWPIc3gMbwBAeJlJVL+6/3DeRSZoi2snrF3W8fIMfgBIf/NbTWD7qD3qiSJSfRjmSq8Xl35HX0p2whMDfzdZfaPrmyW5ENvmcWHCpaslF0GUhLq3Bwl41WcDyUpHdKVjniKgc2mIiQe72LOriYunJLLEndlFepT6ZHyU14Lvn3VvjFPVcVg11DQ1huUBTTKu4HsOx77I4kpLaxsDhimWXLQPEeHYW+TMV03yzVjyDT2OzRlJXcpBaeBDja5HYeuJmjkzu1ZP78hcOt7nLE3FEaWzoYTTgXMGz1ocFwiRrIHlZpoBTHzSA+rIKQaxuoY7CaEzKKo3eIoEXgbiHrAa+QE/nk3fH5a9tLvkP9vTfZsyLUCzodgCmUgZtuRBDR5DcUUekAKiXnGxesxHZyS0hPyLgwJBmenkIy1QiamGtxnCRoXSFRNZwZ93I4t4cp7Cq/dWhFFVnvyHxYpVQ/l2TeRbmGOkyeOP8IRE8wNwTJqXa4+7qAtHH3Pvxfp5UZHHzryNoo7fzjdAm0+nrAcb+0qeeAgHEPObeauj1Wv7FzvTvC8CNS7qhQbWmemr4wTOKeL/P7wreeKuLNzZZoTzORXL4lFO3+d2yuem8+W2oszHAl7hlZBUZlqhD7EvS4JZKw/nvhCsqDGwObMzNRjF4jM
 LaYVJ8Zh
 G7Y1w01ovau9ryW4XGeOq97PCnRgMOh+RM5l6neT7wyNU3M22EAuMw1aWh2Ab3TL1SdJo9DFlmuYMM02tN0SycQ/wGdJ9NzS7a1fAE4sDC9h1WtKmWNphpAs1wjqAqOZwOaGTS3CCt3tmHxolmkn7+ZABfSmO9yliocU+9C8pOOwNeSbLGydqTLu864V7XSURGcXD7IaNbyd/Q+yDWwViJBlLKACGm2qNFap34lLTxr41I7R2mvU0HdxIqHDnOatJFm7YlfQkiZpasKqQoI5r1yienA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 07:53:48PM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 15:09, Usama Arif wrote:
> > Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
> > entry into 512 PTE swap entries. No folio reference is needed because
> > swap entries point to swap slots rather than pages. Each PTE inherits
> > the correct sub-slot offset and preserves soft_dirty, uffd_wp, and
> > exclusive flags.
> > 
> > The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
> > rather than *pmd: for a present THP split, *pmd has already been
> > cleared by pmdp_invalidate(), and that invalidated bit pattern can
> > decode as a plausible swap entry.
> > 
> > This branch is reached from the explicit __split_huge_pmd() callers
> > that hit a non-present PMD: partial-range mprotect / munmap, the
> > wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
> > added in later patches when the cached folio is no longer PMD-sized.
> > page_vma_mapped_walk() does not iterate PMD swap entries, so
> > try_to_unmap_one() and try_to_migrate_one() do not reach this branch
> > and freeze=true cannot occur in this branch today.  page and folio
> > are therefore left uninitialized in the swap branch; a
> > VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
> > invariant before the freeze path dereferences page_to_pfn(page + i)
> > or put_page(page).
> > 
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
> >  1 file changed, 28 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 1b6b0aa2baa3b..a473e85d30f51 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3252,6 +3252,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> >  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
> >  						 vma, haddr, rmap_flags);
> >  		}
> > +	} else if (pmd_is_swap_entry(*pmd)) {
> > +		VM_WARN_ON_ONCE(freeze);
> > +		/* Swap entries have no page for the migration freeze path. */
> > +		freeze = false;
> 
> It's odd to VM_WARN_ON_ONCE() and then set freeze=false;
> 
> I'd just add the comment above the VM_WARN_ON_ONCE() and drop the =false.

VM_WARN_ON_ONCE() is compiled out without DEBUG_VM. The freeze = false is
what actually keeps the swap entry out of

      if (freeze || pmd_is_migration_entry(old_pmd)) {
              ...
              make_writable_migration_entry(page_to_pfn(page + i));

and out of the put_page(page) below it, where page is uninitialized in the
swap branch. Dropping it leaves nothing on production builds.

If freeze = false goes, folio and page must be set to NULL there (or
something along the lines).

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

