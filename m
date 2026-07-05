Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30FAC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 21:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C196B009E; Sun,  5 Jul 2026 17:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2C56B00A0; Sun,  5 Jul 2026 17:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1B76B00A2; Sun,  5 Jul 2026 17:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE206B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:24:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C484AC0AE2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:24:47 +0000 (UTC)
X-FDA: 84956002614.22.CAA651F
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF655C0009
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:24:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eE67IVBE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783286685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqm18FcCePNaQ04txiTHWmTH5EAjMzaf4nG108kJoks=;
	b=OqjktTodeQEM9ty4ME96K868CIQaNP3yLkcRnB1rcajiQazAnEzo1bT6rsxVnrY1DZ6Z7Q
	0caLoXuEiOd96lZdjidy1ZrrAl4RTXIb1KgU+PnFCSe9ZvqHyHX3E0eQImBy4JaPE59laR
	l+0C18MZJ/G2cqiuZ01XMPz0holwgJs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eE67IVBE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783286685;
	b=5viyngUBVTpStX0piytP/yXzZrQS22+FoqvgCkwgLi0iPHsInPzvK4PeuCNmLLudOeVmim
	vmxIE6eGQNY8KcL3dqahvzSkd47KtTuzGNlur5mOJ6ZTN3gw6V8WnJBh7UBeHCclZBaIPu
	r2BFpZpTjBBqJRunaDR2VjGEjpMUP5g=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8114a4542b2so35370397b3.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 14:24:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783286685; cv=none;
        d=google.com; s=arc-20260327;
        b=M/QZpZD2Dzjbmg23wL1DgxkD7GI/cTPFiRMlPS1ZNGBAAhBfktGNy4c1pj+6oajiuS
         lYV7m9wfcWmMqdaMZzNOsCJvMgKd1zeOmNZfIaPWtOvB6Inu5TKwW62PG9GoyPgQtlBv
         fJVZf1cPHSJbmadrvSbiimW2SaMVnetP2ellz4boj3YFk8tv/zcEzjPlmxOe3472zWfW
         b4y4goYX67qTbS+eiJEW7BFPdvIdt91jtWz/uYwP8qMJZgJdyl2GWxw9s8LM0PqMwgF6
         fyzHrHizYsdPhuoCRBDkc6Cciu5YIO9UWfX+qhc1i70xYALKqpgakFbVwMjatYmmty/j
         QghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lqm18FcCePNaQ04txiTHWmTH5EAjMzaf4nG108kJoks=;
        fh=PwMQxl5DqcK2lYkyL1oB+rHGmz/op7NM111uv9OeNTA=;
        b=s4rq3DrNtibXgwP27LwY/w5qCxvxeD/A/HiQgc8KK58yivRI9ZZBtKYJ9ntipTKuv5
         OiEeUxhMYItCqLSFxr6dUdEEi+m18AxTXCgga7JqSLNolRybKLb/CDc4vCMB8DMqkyhm
         pnZ/RVhhqfbXXec3q06miLieCKgrKQvDdYHvgSAE3hJtEEqntrHI8CMzkqqFEKO06KF6
         GrnkkXpFFwd6pv6DBIMbMoAXFJgeow77yh2DDbmBY0CIGV6uImyM7FJTHop83s1zANdl
         P+InkWsx3BkHTJEbjrZ6NYLx1mOR7b3ghRPIkFaU1BDSE3GKen6r5oQV/axgW9ZFsSkl
         sXtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783286685; x=1783891485; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lqm18FcCePNaQ04txiTHWmTH5EAjMzaf4nG108kJoks=;
        b=eE67IVBESsCbH+zMijDKmSUBDLMDHnsFhDfYU/EOm1QM0avYLgHjxAco4EnWr49mBt
         acGEcML+Ga4fNCyPWZvDntl6Rdm5cte4LXj4QxYzEK1CwunwWyIpvMc1UcA7hZfQ9T+x
         X5ar6gjrbqyyfgMK0vX/VCqgxRhaDhmX7LAy+cBDocGetNqu9ibiQA2W72Op7usdhBKR
         DfKVnVE0Qf2j//5gBV6vKFSd4Q/r1UKHUn+8sZMhnnNK1FqMKswNyiJ/hHRLAmjeq/MW
         qmZB2OE3hWZBj9Jmd9KCdtPVJ+baFFXE7SfqGHaTPHzg0ko/AuGdHPKitQWVtwc2ARxX
         DLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783286685; x=1783891485;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lqm18FcCePNaQ04txiTHWmTH5EAjMzaf4nG108kJoks=;
        b=Q6XPi+pgUxJ4c9W8NzkeBOEAUXJ4O6hhKF7vyaTJIUa48MAX/hO2q2SgYLuW49fx9l
         X32LLgQdmI0ajxJPL0g2uxU53rt5Mg0ZT60gsPzdpu0qaw8IxqGrOA6bEh0zdG6301EQ
         99ENcPz7+XSg8m+4Auhyu3eQyAaONhp0XsbFWesfL3stcuqs1xAf+yy04Yk8NRq68+Yq
         7fuSiLktp8WywQgAfmY1aokqJDPi9q9JD+iTPAM969h6lXvFz4irpt1Ni2+iRk9PH3do
         AlMY1DHtKkca/v4uT4SNtnYeTNfvrWtWk/Gz4sDXiyVJHbULrtTq0EqT350dkqxXTbJx
         7THA==
X-Forwarded-Encrypted: i=1; AHgh+RqaMPpdWFsvxO7rhP6R2qE3pkUMzFvZxIYnYtao1upfoFauRjqggLPiXqhF+HwgRuql6CxmuXHGMA==@kvack.org
X-Gm-Message-State: AOJu0YxTE0NimqLpTMYz15x6wOn/DUE1qJwOMktCnWDLGu0PPWpDuBAZ
	SQvheUMbOZwmvjMrVT1NGddrzwl4S0mJbyZ00n5nzSNHwFXoEBsRdnwNSU12bP2i7McwPQHAoKK
	JXz2s2w/znhl3c50Wt4+ahXPRxDZ5Dz0=
X-Gm-Gg: AfdE7clBSXwPRdeXr2DF0m1+RF/H0tXips/siOjkl5wRGlQxVFSszm1MXXkvKpB98bi
	kPAehZSkb9Uho1ZhgzwS2PTdIdlVo23DdC7eAkrxXEZHgpxq29g3BRStb+iCU/JjLe5+6YI36RU
	WkPdW7HTiSIW0+7d8mprrtMwU5HAE1pf5TQ+QyzpEBn7eNbLu8GLWdUOAFRdiDMFVzYSLIct5AR
	QEnl/J6/PeMVkGJCQ4PN1P5wAFnr1pDOuDZ8UScbKnx6lJbmyDQrgq46i6yOjF+OWGNiytV183U
	u2k2vEcHm6RpezexJrNSqn1Vtw0=
X-Received: by 2002:a05:690c:6e0e:b0:7ff:19d6:74ee with SMTP id
 00721157ae682-81739bf3e93mr83761947b3.33.1783286683896; Sun, 05 Jul 2026
 14:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260702093011.336036-1-devnexen@gmail.com> <20260705133129.74b3bf92ed21c9bcddaf6174@linux-foundation.org>
In-Reply-To: <20260705133129.74b3bf92ed21c9bcddaf6174@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Sun, 5 Jul 2026 22:24:32 +0100
X-Gm-Features: AVVi8CdS0SjiWzvz3RbG60N7881_6OO2pbbtITZHEXQIfY7vFhv9eNLjyTssOB4
Message-ID: <CA+XhMqzOqk9GSRrvLkjP3oGyxGeOzogoqbCjVZj6Pq9iPPhaYA@mail.gmail.com>
Subject: Re: [PATCH v7] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF655C0009
X-Stat-Signature: xyubhe58r7eera6dwif43khf6xn4z9bj
X-HE-Tag: 1783286685-356380
X-HE-Meta: U2FsdGVkX19FM+T5Wv8kmp3PxTCAWmpRlGYWzFbF6vKhsz6WSPkYCH9HL9Qkh8ZvDb+ULoGSqhz928eTFh/Ry/rZ97ocO75vngJQg5SdgB0x3w0wrqJKY54AJIVVExDdXkevp5FT2KXWofVrkRDe2AUNxp60jgpKo6TQkgviUth9cw0Wwq8zm48WHxArf/iQ5Noq/QcHbh4WTPpaVyDNZPvDTeg8XW6LjGvZSHZmEzPgB3npia+K9HTMjtH5UuSDLP7SH5+1UmDKnZLbfuGFha7IBrG7gwgxWafTcdn0t2UiomUXGux2v0FSm3A3Vdg36yEJZlgVoLDREPmFYGiF2jtmg5A9F5mxLcMLtXUUJ5kmOPeL4B6DSzhehIJsJXWRtg7TKbwP6012+GZIPDPl1S0jFFsGr0+fiOusrm9KlQNKANbyehg9dtMtZHZxmozIXpfOxW4HnouYPrdKNvtL9sfabgKPOcVGEerAhkCqBc8Gj/EvDCPoyaNvLrH4+qO/w09WjnncMY8CK5UoRfTm6w9wQdJRkpFueZFPkbaao8XvbMhilfKOvYEMuyhpkct0xvWcTeVT7u9WfV7Yv7ov23yJhbwQTN/Su4RLoseB0cCh88DEm12aUECK11RVjIkr54Yb5KsLxH252aTRnAWfW24b28wfOlU5oMUltHEzukUkthE6eNUi7jpXrjbBBz70kIflUIYtQn2LIWgtOAQTGGTE8IQ/CXrKbgruLNjOUkzk2RRnv5rqsa/XDqiZPydkkO0meLGO7pfIVvbH9PIDUNjvi5uZlbxTJ/JkGUxW8rgt2KP1HisHuH1HI2AIZRppUTnLh6OWcf4wt2UpMKVWDs84ypWR0aDrxKDaHhEBwYjNSfDG5LnsOu1nRPy8Zp5Re81+Tyc809fsObzYX7osB3y3n/tWCuEmicyiOP2MswFMBpGESIDRhcHAdTIjFGCJa54GNXIMbug5bEldGA9
 HITt9FPN
 Trr7h/ZfQ3s3FBpKl4w2AqTEvj2rGmpX8EgGdDnoG0j9Mu5fu3xO/hb/iPiJ34eFYVM7tc0MLHjsPsOeA4TG4Vff0vkLW0RzG0tCpDquAyYh+BtODra+AjmPeaaiGTjiZa53Dim/6ggtYq8PlItiyiLgwNUxVg2WsCdFPhq2jpxTbx5QMxadqUBEqUj0HVPey3si18B6NKJG4jEwzNaXY2Mv5H2yYKoaQyChMbWh1lyV6eMCzQs9uKn8fRJlnzFI8dXwfEE0omHaELTVIlz9tc17nOcQGZM8WeCCKS0iOOAeA80B3RNz7TwkxDPaPEesvz+TmlFlBpZMjk3IdTglu+aJKHX8lajNfq6GOBcYE3Rx6ogQSJewZL0Es0v59PvhRVs8jnkk0+n7ZstkCWokTiPIiftV2Ua7PMt5C9Cw4KbRmjIc1LDNtcoQomvRBg3K66lTj369vdDp20RMfpLuC+LloB0GwduLe6rRWbBottq6orJavj/kNixKA7kHV/o0eoZSL2FeOKbi609igjWEQIgyBk7R93ywQeeDMeF+rsVc0IMll+TuqaWpsE98UIXMrX7Qih3SvVuo93a9xTkl/6bHXYofx1DzaHMt3T6/4CWnRpn6SwWQhBKcjdLYPs+NdSTlDXm5TQH34PE+ZqBd0oufE9BRRFUW9IOhgRZwpLTsrYvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew

On Sun, 5 Jul 2026 at 21:31, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  2 Jul 2026 10:30:11 +0100 David Carlier <devnexen@gmail.com> wrote:
>
> > ptdump_walk_pgd() walks the kernel page tables under get_online_mems().
> > That does not stop vmalloc from freeing a kernel PTE page underneath the
> > walk.
> >
> > When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
> > existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
> > powerpc this runs without the init_mm mmap lock; only arm64 takes it, and
> > not on the block-split path. So ptdump can dereference a just-freed PTE
> > page, which is the use after free syzbot hit in ptdump_pte_entry().
> >
> > The race is not new. ptdump walks the whole kernel address space, including
> > ranges other code is actively mapping, so it reads page tables it does not
> > own. 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > only widened the window; the Fixes tag points there for that reason.
> >
> > Every other walker works on a range it owns and is the only one mutating
> > it: set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
> > openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
> > concurrently, so they cannot race and do not need RCU. ptdump is the only
> > walker that traverses ranges it does not own.
> >
> > Defer the free by an RCU grace period. pagetable_free_kernel() now frees
> > via call_rcu() in both the async and non-async configs. The async path
> > still flushes the TLB first, then queues the per-page RCU free. The page
> > stays valid until any walk that may have observed it drops its RCU read
> > lock.
>
> Thanks.  A use-after-free is something we should attend to!
>
> AI review had some thoughts, but in a strange manner:
>         https://sashiko.dev/#/patchset/20260702093011.336036-1-devnexen@gmail.com
>

The review reads oddly (it couldn't quote the diff), but the four points
are valid:

- The init_mm walk still calls walk_kernel_page_table_range(), which
  asserts the mmap lock I dropped; it should use the lockless variant.
- ptdump_walk_pgd() also runs on efi_mm and current->mm, so the lock
  drop needs to be init_mm-only -- otherwise it walks user tables
  locklessly against munmap().
- The chunk end overflows at the top of the address space; pgd_addr_end()
  handles that.
- The RCU deferral misses powerpc: pmd_free_pte_page() frees the PTE
  synchronously and the ptdesc isn't flagged kernel, so it never reaches
  pagetable_free_kernel().

Cheers.

