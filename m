Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1168BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9426B00A6; Wed,  1 Jul 2026 01:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C818D6B00A8; Wed,  1 Jul 2026 01:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96D66B00A9; Wed,  1 Jul 2026 01:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 840C96B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:57:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E11FDC14EC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:57:26 +0000 (UTC)
X-FDA: 84939150492.12.BC62B49
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id F2CAE20003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:57:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J2jOhahb;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782885445;
	b=QWFvjy7tR+H2QwJ3kkBC9s4bvc6p6RbxEKU3aqY8q6SJnf6aSkdOMZ7xVtSpJeRVNTR3pd
	YOGTGbCbIGlu7TJfWJ/J/jQcnPLR+5MVuYJhh/Ktc8n/xUyCybqrMDI+TJY5hQTotC23pX
	99nZs1jCbRbPkaCR9IrK5IWkJsryNHg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782885445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yqKyNfIbdPZZEIoT3pMj0snBSQheCwfRoFMX7jxNy4=;
	b=xnzKQQuXfxl3ySEymwnpMvWAClzDof+uVzPOd0BlK8j4IihQ1ltCwXMizAK+HJg6gvqL41
	ip4ZR6GJpWQQipiqtwgAfrEaJ3cokITyZZIBwZ55436FLTKzNmWGlXhmQfPUwkeFrcxTFS
	iwXlmMKF1BazyNqHjA7KyQ/uxtNkDqc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J2jOhahb;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4414d76270cso137541fac.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782885444; cv=none;
        d=google.com; s=arc-20260327;
        b=LxJL1zbvgI9X9TRCdrrUFESbzCaWi7V0Kz0PvE77p+DPB93vzmdZiqBPLtJEvcw14p
         e6XL5YiXGDXx0CPt/PkWLVnkNU8OxegIeZ4sWZW5ZRE4reMuCWVFlFL5cxIw2sSN+uEQ
         IYuH4WiD490pbmJXcT1/pMhSmFAP4GzkV13T5+dhF7IOks2LdG/zEAi1SzS8vQUlbON2
         L/fYyrT9/LO7+zwg2BOjZdxPMlabS56181+oQmhQIBJYAbYzq3jX8xtuNljkzHwtPrUG
         /Q7rgNFAYodfoHTbe5GGWvS9vv0Iuz6PLX06p/NL8WEybk8EaIegq27jiep4CTJ9nOsy
         Deig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/yqKyNfIbdPZZEIoT3pMj0snBSQheCwfRoFMX7jxNy4=;
        fh=VkCsdROmlgg3x8UFJPAS1y+OTkOwNSEuwVgdGc9b6bo=;
        b=ouvYTHty8b7/e4yWcOJWVLQZH14n9r/iKKA/Oo29cvpwFKhNUFne6Ma5ArIwCTqodc
         xQypskkC/Zr1bKzuCsnStOGLe8oecdTJ25nOoR8kuy1gBmw/Ojo4fQ3uNUDSeZRQsx8X
         lF5C8k+cIBqwiGrXZylsUbf20Q0t2vORZl0BY+VNyFUAUYdbGxWYYNR1Vrt10MXTzDRu
         Il8ddZWg/FuFliYUIo2Br+P0TqaP0B0IQ1Q3mru02RdDV+yoaNe0+BgX85b1+nJZHsj5
         GIK8GUCZjwe3y5l7k+4H/JpQ0ms2eblMNlzomzr90kgI9sM1TiDh8w6ZYj5/5jVPTH8M
         fTgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782885444; x=1783490244; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/yqKyNfIbdPZZEIoT3pMj0snBSQheCwfRoFMX7jxNy4=;
        b=J2jOhahbRfOY6wsuIq+scH+LT7APHU4Gb5RiGcjLkaGBF4oqMjGVLsZmIef5FG6dm+
         yxeSsoUmB0Zf6pUlNIKeCqxpCwaf2HxKhFFbitQSs/nGzfj3xrFE01zhO40TGxgY89IN
         uWMfcQbAbD0PnI873wPMXMvRdHF82v7XAIUUErBkRp/xL0jJxUkeb8aZIjZAQDdm4eEU
         jt/7AXmUIEWe7CoWC7ID+hUmS1dfRMBrlaBTQ+2CI/s680kshTGOyA326zB8sMCPT43t
         ifzKlJCt+As/Y/xLgEBDIz86o7HOHekFVrbIfTeAbEb1zYe/6MZp31IDdUi6sg9Vu2Hp
         Awag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782885444; x=1783490244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yqKyNfIbdPZZEIoT3pMj0snBSQheCwfRoFMX7jxNy4=;
        b=J+8o3mHFNq+wu92gv3zspdeKHe86dG/VzuCuKZ4vCPMhCbnJu0zg9m4a8x6vtTc8UO
         FJekzbzXzPcvhiYBpiHqfrDNEKC167AK062AXcA4wDAxmBE3qR2GsnvWXy7tLbjHvhgw
         SbwTdSxRLWrxZ8dk5wRBm/9cLk3bOnG+9YD3qDJ7zIq/992/rJCj9ZKnEzDlKmEmwU84
         sjxvUQRs/e6G8/2YGHGpmsa+iTaONiFwu/AD7qFypuZAfndvkDYpp0LcM1RcK5lz9XFE
         2+YikVJAjqz1A2vtcMgNTgSC6n2EUcplIixLCaJJvLECuNVYcMzkGL4o5PEgFVuTSa7c
         fpCA==
X-Forwarded-Encrypted: i=1; AHgh+RrjP5x1nr94twJOeIfcJCSYBiITH142QaVytY/wTlUmVatwT5cImeVBnLsr7ZwYGKZovPcK2978ag==@kvack.org
X-Gm-Message-State: AOJu0Yz9cnMmK/Uqqp/dCnjrKtyJQ4RvPCV1hnTPg3pcJHzKXSR6Mw8D
	l5kKJXCylHw/T2B0hP3xNy/AGoQFedHhcJ9YfCDdqnKbNfuewgYpbPN018Ws19SUNng4XUQB3GT
	PoBHWSRU9yjJl1WitWW0PxQk++ErY408=
X-Gm-Gg: AfdE7clCmWGzddEnysU+0bTDS6MAZSGFtNTQr5tEoU1YoqtWi0OA4zSQTltiAJGIFzn
	PbwBskZ3VEjKHxbflDFmxiRlNcmTqjC8/V0OelEO++DVTSiJhNKKhHhEG6wFeP+Ob77ldjrHyB9
	T5d68sAtfOav3Lr+cfvfZYC0+udUp2EV3Ylm1Zec15YB8heGG4ddJ+b4ZCEg29daYc5itieJTdW
	UjVDPpGgWwxQa9uuUvfFRbJ1LAczva9Za17+B5NqBi3W9b7aXYkphvN5Jd1YbegUWy5OQG6Bw7k
	D2lQU6gCQrCBlfPwx2SHNiVFfNI=
X-Received: by 2002:a05:6870:65a9:b0:441:39e1:246d with SMTP id
 586e51a60fabf-44cab591a28mr62771fac.11.1782885443809; Tue, 30 Jun 2026
 22:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260630041012.5975-1-devnexen@gmail.com> <c3ea35e4-833f-487f-8a8b-6f8f95b7ba95@arm.com>
In-Reply-To: <c3ea35e4-833f-487f-8a8b-6f8f95b7ba95@arm.com>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 1 Jul 2026 06:57:12 +0100
X-Gm-Features: AVVi8CdMasNhHqRsxHAh6nfzwOsbjW2pLFWQnLH3HrhJiEQliG3CECnY09AAYEg
Message-ID: <CA+XhMqzErBiN5w56fO2_2T3Yj=-L+dPUDjoMvNdK9PcF37nsbw@mail.gmail.com>
Subject: Re: [PATCH] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: e8hyj7fyq9m5zrqnbd5whzuy91nbi4w1
X-Rspam-User: 
X-Rspamd-Queue-Id: F2CAE20003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782885444-908938
X-HE-Meta: U2FsdGVkX1+sUzggDfs5h3tfC7YRiFYU1xQRa8AAgrBDzKPZBnW+8S7OtAFEJKNw29/gou5c2bIi6zJ2L0D+lk2Uk3FuWjoKM570s14GAA9dYJyGGYAjAhLv2GfJgrGIjipO2hbW9FNbDuM0mkU8Oxow/sVMu2k4in2oMjCslE5Ny1xjye62h8XULPJFGMTyRo5o/cI1NDEph6Lcw4oa5gKuljcNoCkWdYlpHyLcLtcsqSvd+2LuBBjbtftZROfNAzx3uvdOR1LdYO+h2p4xtxHIwoOmUOJlSrKDP+OvMnaK1ILC9Jny7FdKwPqw6gfpahWeJW92vTRyrj31QdJ1/+6o55hjoplo9Fogna2CpbvQXvjsMJVUVBsbGBKZi8l3MzDWJAIjwl7T+iNNbXM8CjQD/4pe8Zh0VGX1UfXK3/XV7xXCvYQKaY3Tw1fzGZbKD7YYibAWizLD9vcx4CC/lhJStJo+ZsKTCK8IeEsmtqstHNs6voHhBpEcekuDlpaFAiS4r/mRQyy/Nu1fLEp6XXMq7svzg//UrsUmWhWkQWltqpX3OVF/GGactJOx20+kULzpDBjpCXgl6+2ZGJgvPlBtn/nW/ixOivPvCIy6O/vgjK7hQYWmBwwYG64pTErDCFcEvnZmnPWIdHr3Bwth8XZBnhyGYxM9cPpjgJOJvkcN3fKwBLLsV5mZzj6dyGxhCh4L0Ig1ot49E/czWh/Se228mf+S0Pu15a4OloG0d6SbBzTybkxLq8w7khAl+QKXPWN4Uub5wxhPQTXja5OiOa1yH1ZkBt37v+TGrfJFFUf+Jpz+XljlS0t/HOYqdT0ImZ1+wMgLwhAaTXxxtKhW9rL41W5pPPL+9s0PHZxJ/5rmVLvkl7OV5wiU6q/68+Tzc1AiUTyJX9vLY8YD/IG+Pm3WNI6qjH4YIZeIKwjXzXx0e9DsWvF7t/sgTrBXLo0TASyWKmVTWz2ma3Copox
 NB3jqBIr
 F0y2nGfNnFRGeHDZr/L952KMci8/z6ykZqcrKHTQ80P3mTPmiKw6c+m/ixG+wy8rDFAtrMh5UfSaukN3/6Fes63RpT7OqPKjoysLG8OBfwNYJiTqkcI/0Gky4V0ZRlUcs+MLXoKiDljppAxLcZn0q++lbmRY/SXHqYbFEWnes/DVKB1eLBxBre/t8c/99xqchN0n3vqoHhiZVT4i9U15yQfdPSNW69S9eKp6o2iZWosEmvQuxWbwSrnoMog+YDNgFRlde0EWgx5n3G/9O+FxHz52yk3JU2gxGYO8vV6eOLpdrVbcFK2sfouo+pTprvdhYKQYoiJ7cUk6Bh1oGoLxtRh9WmVLrLjnFGnqPncLb/lDJh5ekSzrhRJegFWn26G6he/w93mkpXK3eUB+K3umXenIOj0k7zambQ2pki7WRy7W3F31N+3x61npOy7NN5ch27wDxLT9nt5bZ/iTqolQFVE6DZF33hxftln7F6jDOzilClLz5Vm/OAQtkttphpmZ/9OW+3vMyPZ9lAotaiBZ1xti1Cxi+vRo/iBD8Vfb4vMqVEM3ZsWHwpOMkBujwy6GwwOkwChHJPmhjHHiTkYjpTJagu5MBRgWCmmXfDc49LWkBJHOB12dXd0bZVhqkYtJRl8H0NRHkWv6n8VsRXDx8uVN+ByTWz8HkOxwfhkh7gOVdU4SM+4p+rOy5ZFXlJ06+WRBKKeebsaCNj1ayafZ8B7mRnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,

Yes, the RCU deferral covers arm64 too, so the static key and the
mmap_lock in pud_free_pmd_page()/pmd_free_pte_page() are now
redundant. Keep the arch_vmap_*_supported() changes though.

Cheers.

On Wed, 1 Jul 2026 at 06:42, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 30/06/26 9:40 am, David Carlier wrote:
> > ptdump_walk_pgd() walks the kernel page tables under get_online_mems() and
> > mmap_write_lock(&init_mm). Neither lock stops vmalloc from freeing a kernel
> > PTE page underneath the walk.
> >
> > When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
> > existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
> > powerpc this runs without the init_mm mmap lock; only arm64 takes it, and not
> > on the block-split path. So ptdump can dereference a just-freed PTE page,
> > which is the use after free syzbot hit in ptdump_pte_entry().
> >
> > The race is not new. ptdump walks the whole kernel address space, including
> > ranges other code is actively mapping, so it reads page tables it does not
> > own. 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > only widened the window; the Fixes tag points there for that reason.
> >
> > Every other walker works on a range it owns and is the only one mutating it:
> > set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
> > openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
> > concurrently, so they cannot race and do not need RCU. ptdump is the only
> > walker that traverses ranges it does not own.
> >
> > Defer the free by an RCU grace period. pagetable_free_kernel() now frees via
> > call_rcu() in both the async and non-async configs. The async path still
> > flushes the TLB first, then queues the per-page RCU free. The page stays
> > valid until any walk that may have observed it drops its RCU read lock.
> >
> > On the read side ptdump_walk_pgd() takes the RCU read lock around the walk,
> > and walk_page_range_debug() asserts it with RCU_LOCKDEP_WARN() for the
> > init_mm case rather than taking it, matching pagewalk.c convention. A walker
> > either sees the cleared PMD and skips, or keeps the page alive until it drops
> > the lock. The owned-range walkers are unchanged.
> >
> > ptdump callbacks now run under RCU, so they must not sleep. The arch
> > note_page() and effective_prot() callbacks only format into the preallocated
> > seq_file buffer, and the walker does not call cond_resched(); the only
> > GFP_KERNEL marker setup runs before the walk.
> >
> > Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
>
> Thanks.
>
> Is my assessment correct that this patch deems commit fa93b45fd397
> ("arm64: Enable vmalloc-huge with ptdump") redundant? (in which
> case I can send a partial revert for that)
>
>
> > v5: reframe changelog around the pre-existing race and range ownership;
> >     correct the mmap-lock description (arm64 is the exception, not x86);
> >     move rcu_read_lock() into ptdump_walk_pgd() and assert it in
> >     walk_page_range_debug(); drop walk_kernel_page_table_range_rcu(); fix the
> >     pgtable-generic.c comment; document the no-sleep audit of the callbacks.
> > v4: defer the free in both the async and non async configs, not just
> >     the async one. Move the walk under a named
> >     walk_kernel_page_table_range_rcu() helper instead of open coding
> >     rcu_read_lock() in walk_page_range_debug().
> > v3: take rcu_read_lock() in the init_mm branch of
> >     walk_page_range_debug() rather than inside the lockless walker,
> >     which the arm64 split paths also use with GFP_PGTABLE_KERNEL and
> >     can sleep.
> > v2: use call_rcu() instead of synchronize_rcu().
> > ---
> >  include/linux/mm.h   |  7 -------
> >  mm/pagewalk.c        | 14 +++++++++-----
> >  mm/pgtable-generic.c | 22 +++++++++++++++++++++-
> >  mm/ptdump.c          |  2 ++
> >  4 files changed, 32 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..79408a17a1b0 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3695,14 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
> >       __free_pages(page, compound_order(page));
> >  }
> >
> > -#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> >  void pagetable_free_kernel(struct ptdesc *pt);
> > -#else
> > -static inline void pagetable_free_kernel(struct ptdesc *pt)
> > -{
> > -     __pagetable_free(pt);
> > -}
> > -#endif
> >  /**
> >   * pagetable_free - Free pagetables
> >   * @pt:      The page table descriptor
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index 3ae2586ff45b..c0be87580989 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -620,7 +620,7 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
> >   * Note: Be careful to walk the kernel pages tables, the caller may be need to
> >   * take other effective approaches (mmap lock may be insufficient) to prevent
> >   * the intermediate kernel page tables belonging to the specified address range
> > - * from being freed (e.g. memory hot-remove).
> > + * from being freed (e.g. memory hot-remove, vmap huge page promotion).
> >   */
> >  int walk_kernel_page_table_range(unsigned long start, unsigned long end,
> >               const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
> > @@ -643,7 +643,7 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
> >   * Use this function to walk the kernel page tables locklessly. It should be
> >   * guaranteed that the caller has exclusive access over the range they are
> >   * operating on - that there should be no concurrent access, for example,
> > - * changing permissions for vmalloc objects.
> > + * changing permissions for vmalloc objects, or vmap huge page promotion.
> >   */
> >  int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
> >               const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
> > @@ -692,9 +692,13 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
> >       };
> >
> >       /* For convenience, we allow traversal of kernel mappings. */
> > -     if (mm == &init_mm)
> > -             return walk_kernel_page_table_range(start, end, ops,
> > -                                                 pgd, private);
> > +     if (mm == &init_mm) {
> > +             RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
> > +                              "RCU read lock must be held across kernel page table walk");
> > +             return walk_kernel_page_table_range(start, end, ops, pgd,
> > +                                                     private);
> > +     }
> > +
> >       if (start >= end || !walk.mm)
> >               return -EINVAL;
> >       if (!check_ops_safe(ops))
> > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > index b91b1a98029c..7a32e4821957 100644
> > --- a/mm/pgtable-generic.c
> > +++ b/mm/pgtable-generic.c
> > @@ -410,6 +410,13 @@ pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
> >       goto again;
> >  }
> >
> > +static void kernel_pgtable_free_rcu(struct rcu_head *head)
> > +{
> > +     struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
> > +
> > +     __pagetable_free(pt);
> > +}
> > +
> >  #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> >  static void kernel_pgtable_work_func(struct work_struct *work);
> >
> > @@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
> >       spin_unlock(&kernel_pgtable_work.lock);
> >
> >       iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
> > +
> > +     /*
> > +      * Debug walkers (ptdump) may walk ranges they do not own and race this
> > +      * free, so they walk under rcu_read_lock(). Free after a grace period:
> > +      * a walker either already saw the cleared PMD, or keeps the page alive
> > +      * until it drops the RCU lock.
> > +      */
> >       list_for_each_entry_safe(pt, next, &page_list, pt_list)
> > -             __pagetable_free(pt);
> > +             call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
> >  }
> >
> >  void pagetable_free_kernel(struct ptdesc *pt)
> > @@ -446,4 +460,10 @@ void pagetable_free_kernel(struct ptdesc *pt)
> >
> >       schedule_work(&kernel_pgtable_work.work);
> >  }
> > +#else
> > +void pagetable_free_kernel(struct ptdesc *pt)
> > +{
> > +     /* Defer the free by a grace period; see kernel_pgtable_work_func(). */
> > +     call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
> > +}
> >  #endif
> > diff --git a/mm/ptdump.c b/mm/ptdump.c
> > index 973020000096..50cd96a33dfd 100644
> > --- a/mm/ptdump.c
> > +++ b/mm/ptdump.c
> > @@ -178,11 +178,13 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
> >
> >       get_online_mems();
> >       mmap_write_lock(mm);
>
> mmap write lock is not required anymore no?
>
>
> > +     rcu_read_lock();
>
> Is there a possibility of RCU stall here? For example a system with
> lots of physical memory will have a huge linear map.
>
> >       while (range->start != range->end) {
> >               walk_page_range_debug(mm, range->start, range->end,
> >                                     &ptdump_ops, pgd, st);
> >               range++;
> >       }
> > +     rcu_read_unlock();
> >       mmap_write_unlock(mm);
> >       put_online_mems();
> >
>

