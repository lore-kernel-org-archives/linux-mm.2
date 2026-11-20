Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A2C606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BLUp4lYO
Received: by kanga.kvack.org (Postfix)
	id 67A4B6B00EF; Fri, 20 Nov 2026 11:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B446B05B0; Fri, 20 Nov 2026 11:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519EA6B05B1; Fri, 20 Nov 2026 11:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 228E86B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:48:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D213120F60
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:48:56 +0000 (UTC)
X-FDA: 85456081872.20.E5F4EE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77EA3120005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:48:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BLUp4lYO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795193335;
	b=bCnYlJKmn2kOMygpFUasv3dAfRfKqmnz3TZCf8cDt1j6zAOlWYSUIuJGrCON+pWG4faIiP
	PrmksUPylHQ8lfkKJ8F4GTp+n49EUazLMj3K8HJg889xwt19IBhKltRisRNs6y3Whf26KA
	NXikfou8E2vcd9GZ0cv8/CoRop/ByjI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795193335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWlboDYBd5BGl+p3WRU/hoNuEIs3lMzUvVPPx0RwBac=;
	b=D+vI6b3r2CStEIDqbuBBXazXgRf1eusTJREJDtc4HmWZQj/tk7wm7tzjeogrSYlATlRy0D
	JqSp8xaQu7yQJ4xwaLMHJoMdoSuAqxmNIi8SbcA3UUUhQ0AXBVfzI+RY2C+kuhjS5dza+e
	3d9ypYAzgi30ZxSvPaAiQkBGfiK2/Tw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BLUp4lYO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EEFB1575;
	Fri, 20 Nov 2026 08:48:50 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D22FB3F882;
	Fri, 20 Nov 2026 08:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795193333; bh=wE0tnPT5bhRkJ3p9KFR14+0FV3MqcU0Hq6gMMmUBPHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BLUp4lYO5xM+mHKj+9mRsDBnlTM0X4YPScwuiUjDcgvaqV4OlDJQUIgd7+5xtyTJI
	 kdqcMXaofKElkdLmL/c1hVIMwzg1cBTo3LXReHLkjUqYuKleU5s9QQE62owlL6LQfk
	 hWmvZ4XkibssNAhaQIYwIkWoBhGc+yd7AYV1OuRY=
Date: Fri, 20 Nov 2026 16:48:44 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] mm: distinguish HW PTE pointers from SW PTE value
 pointers
Message-ID: <awB57BlYzicAJzqr@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <avtAQCkvRr1xkxMF@arm.com>
 <959a843d-f579-4aa7-8299-c6e9c5d03812@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <959a843d-f579-4aa7-8299-c6e9c5d03812@arm.com>
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: f8t9yo8wee6dohxy6x1qzttg5gb3tx5f
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77EA3120005
X-HE-Tag: 1795193334-301361
X-HE-Meta: U2FsdGVkX19zJfRNHb6qrTI5gINRjX61fT+77vV4Vh3113rLXuWCSYKC6VtPH8C1FBktfQ6NCnA/rOK9m1UK4vVXI4g8BQX92NA/T4L8Jqvtf0ZJ5WPsmfomsu0Y6ER4q9zOvlMUKJvDH1v8MiA0ZJcvfjmrBDsT5OMzuBYnK6fPSjhxmJWfs9/uqPGxyRqg5E4MjFnQF5vXEX+goqgG89ssvL7m8bCPiM+jhM7++5tVCZT0ZxwJJwCB+0ma4eZ/J7exvI0WURFk3EOE0SV/eCCpHScFwAcVSA8uu+VjAF5N+xDMD/+iPElrkCSmZ84hCZFI62+c+3ArojoI+ULPUCh8WngWHgVaWtz78TVC5FtMaQNjDH/L51QP3+UDrfGMCHo+eztg7ylPP6D1Vo8WPPBh/X+K0Hg05epcReHGsq1kVaDMLhFHlGw28TYejH81AYOSORzFfLiE7kOGbgCt5yDGSB136JO+U5o+tGacdQlOD6QyX7YfuXeGbqJVxJJCd0QvJ0+NTeTdg6/64MSqvpPjUmWj6RjXMj+L5ZJkmq+eok30+4h2ygb/AVfvmRwXX00dfUF1xHM/V7ntYsePJFDdfii78NQz4blao2YN/E7M5qFr81SU3f0+Fs/q0uc8Y7AmCKgzg46L6x50M3W9SRIzQUnQ5p2zMaeOPv/OXgX668CJ9m8J30IRtZ5RgJ+IEEpcyXOsdXZoB6hnvs0++gwx6QWtesGn/pqVb16sNPezlNImSrHnEeiR+2vOCm65HenERWcOAxYT+gLvx7h3Thf0GvYKCku/wHS3WVzoHbKsgWOZJqPfYN2FjpA5j/f/v/Q16SgGZzBiFZKbZLcIXiO+NPf5K1i6XYYBB7boDlILnxWt5z9ffgbIPXFslOhTck8omYhr8IYNp8SywZV6U3X+/7koWAOEmdnqbY5fWtUEaZ8wgSeg7rVcqEiDkeCbkqqOQlzBmuxF0NZSW6N
 UEj5SCLx
 D0GJTQLN5g/W2h4k07QjjYQgaILU4ihu0xdyULofRZ6Z1p8/12212m6NCA74f9+h2vUkuLJhQ6gtFzt5sHfCOz+xJNERsmj0t1SpGP4thH/ST2+dVn9W/e8Ebn7OmNTQP7ayVyJjguVQZZbVQV59l/+DgjNI9DKYFUJkL+Ldi95Qrh6JFA1sBWfNoV5J5mxUMjTxgMIUS6nr7BbGALV+NJRofSGqzaXa7ag0ErIra31QTFd+8gGbI+v3l30w502RcmM6PRYu2CureEaLNUBOFCy7RXpVcJ/Oyh2iQCTF5DcxFWDl7Dz2T7FbMkXqFRIn+8XWQFv95zJbmAFb26OINwa3d5ykXlgXIdVCzDD2qzWAY5HTPRNfchsWnrUHr+O56LP6xSciRpMAC0HD5PdMcFButCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:41:41PM +0000, Muhammad Usama Anjum wrote:
> On 16/11/2026 5:41 pm, Catalin Marinas wrote:
> > On Tue, Sep 22, 2026 at 06:12:28PM +0100, Muhammad Usama Anjum wrote:
> >> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
> >> converted in later series after the PTE boundary is agreed, avoiding the
> >> PMD-specific cases that made an all-level conversion difficult to
> >> review.

[...]

> > First, I'd like to see all such on-stack p*d pointers addressed as a
> > prerequisite (e.g. fix pmd_populate() in __split_huge_zero_page_pmd()).
> > If for some reason we deem pmd not fixable, I don't like half (or
> > quarter) baked solutions just addressing the pte.
> 
> Only pmd pointers conversions may require careful review and some discussion.
> Other remaining p*d would be straight forward again. I think if I convert
> everything, we'll have 30-35 patches for generic side only. It would a little
> time consuming to rebase that again and again.
> 
> I think, a simpler plan can be to post the pmd pointer conversion series
> as well  in the open to get better acceptance of this overall effort.

I didn't ask for the full pmdp conversion but only to see if we can
remove the on-stack uses first. At a quick grep, there are only a few:
pmd_populate() on a local pmd_t in __split_huge_zero_page_pmd(),
__split_huge_pmd_locked() and vmemmap_split_pmd().

> > Second, we could add a run-time page table check, at least for pmd/pte.
> > Something like below, gated by CONFIG_PAGE_TABLE_CHECK or
> > CONFIG_DEBUG_VM (untested and not entirely sure about using
> > PageTable()):
> > 
> > static inline void pgtable_ptr_check(struct mm_struct *mm, const void *p)
> > {
> > 	if (object_is_on_stack(p)) {
> > 		WARN_ON_ONCE(1);
> > 		return;
> > 	}
> > 	if (mm != &init_mm && virt_addr_valid(p))
> > 		WARN_ON_ONCE(!PageTable(virt_to_page(p)));
> > }
> 
> s390 already has CONFIG_STRICT_MM_TYPECHECKS, but that only provides type
> checking for page-table values. It cannot distinguish a pointer to
> page-table storage from a pointer to a copied value. Consequently, direct
> dereferences still appear in generic code and can bypass s390’s
> architecture-specific handling. They have been trying to fix [1] differently.
> 
> RISC-V has independently encountered the same problem. Some RISC-V
> platforms must transform page-table entries whenever they are read from
> or written to hardware page tables, so generic code must consistently
> use the architecture accessors. They were trying to fix it [2].

I thought these were about direct dereference of the pointer to pte. We
could use some sparse annotations like __ptent (already proposed). The
run-time check is about valid pointer accesses but when the PTE is on
stack.

> > You already have some coccinelle patches to make the conversion. Could
> > we turn them into a coccicheck to detect new uses? With LLM reviews like
> > Sashiko, we can probably catch new uses violating the requirement (we
> > need to document it).
> 
> Coccinelle can identify common syntax, but cannot reliably distinguish the     
> meaning of two pointers when both are pte_t *.

No, that's what we'd use a runtime check for. The incomplete types probably
help, though you can't fully prevent explicit casting.

> > LLMs and coccicheck won't catch all abuses nor does this series prevent
> > one from declaring hw_pte_t on the stack.
> 
> By using Coccinelle and LLMs we can still get regressions which arch-es
> have been doing over the year.
> 
> hw_pte_t * makes accidental violations compilation errors in every build.
> Deliberately declaring hw_pte_t on the stack remains possible, but is explicit
> and reviewable. (RFC of this series has info on why we aren't using opaque
> objects.)

I'm not sure what the conclusion was on opaque hw_pte_t. IIRC Lorenzo
also proposed a non-opaque type that Ryan agreed to some time ago. IIUC,
if we take that route, we'd need to go again through all type changes in
this series. On arm64, some of the functions proposed like hw_pte_val(),
__pte_from_hw() would need converting again.

IOW, I'm trying to understand the road to get there, like ptep_advance()
instead of ptep++ and so on. Once we are clear, maybe without a full
patchset, we can go ahead in steps but at the moment it's not clear to
me you won't post another conversion like this soon after.

Anyway, that's not my code, so if the mm folk are happy, please go ahead
with the generic series. I may wait enabling it on arm64 until the
opaque pte type discussion is settled.

> > Once the above are in place, I'd look again at these patches and see
> > whether they improve code clarity and are worth the churn.
> > 
> > Maybe an argument in favour of these patchsets is future dynamic support
> > for FEAT_D128, we'd need to separate the software representation of a
> > pte from the hardware one but we've done this before (arm32 non-LPAE has
> > different representations).
> 
> Yes, that's also the big motivation of this work. We don't want to depend on
> the config options to turn on/off features. Arch should be able to turn on/off
> code based on the cpu features.

It's a lot more work than the pte size here. PTRS_PER_* have different
values, ptep_advance() would be more dynamic. It's doable but it's a lot
more involved and I think the types are the least of our problems. I'm
also waiting to see how many CPUs implement D128 before committing to
supporting it upstream (it doesn't buy us much anyway).

Thanks.

-- 
Catalin

