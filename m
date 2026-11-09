Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BAC606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DsUGr9C5
Received: by kanga.kvack.org (Postfix)
	id 754626B05B3; Sun,  8 Nov 2026 23:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BF66B05B4; Sun,  8 Nov 2026 23:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6417B6B05B5; Sun,  8 Nov 2026 23:27:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36C286B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:27:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0DF41205A4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:27:56 +0000 (UTC)
X-FDA: 85414297752.13.B9241EB
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id B3648180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:27:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DsUGr9C5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794198474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/V8s8uaYeKYuAXh83eqMNrq3SnymKmItW+yIrZGRcc=;
	b=WG0khxBN11L4WIAkIrcDHevg4YNJq50hz9GLTj6k8CswkXL9jEPgfX2uYOHN51Nh5Em0X8
	Wcq6fvtv3qDBTC8djlM3e7n1q/WYheL7Fb9blNKmmf0ePuUgfL+zG1jmTCcVvQOMoMPFim
	PlLLHE7AqsvWsHoWYwAZA4TmZ8qN8X0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794198474;
	b=Jpcwma1x4oJdzphI8OqAiyJrbajRz+laPZ3O8FbevNMBPNgqllmoSs6Uf0c11qUu3/kAxg
	1/ztH5sdDYgF1EJKemD6RemfbT1dCHrL8RID9r3t9Pd6L6UibmjjoItCOAASCohuuVqWY4
	8PZ2zTpXPtsn2H/zXSz5yGANtTSz56k=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DsUGr9C5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-930c0f9c1b1so39179285a.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 20:27:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794198474; cv=none;
        d=google.com; s=arc-20260327;
        b=BKZlpvwAlyMNI98Zqh88KWQd0gR7+4UM99hFz+1XJucFzA4awzfR8mqgTcIr1hZvuB
         3xKcCmD1GPtWq8xY77CdejUPVwsT9OAwjC2iyFNubfWnwPu66UB0HJOwdTkU2418RMa1
         7tTydFBJFNCAljSBffADIoiCubGFhKRXZv81uk9PNyaPDEI21kougSVJ45ZPCt3fEsUh
         7Ngn3uTP3Zaoa1yrpZfpKibOsjVaRJchpJxdc2FUdU7LJYMjlLH6H89MWDnzYZ/x9OWS
         DWX78MCg0pziBt52B59kJ8o21Cla8iP5a0WRNZu0AH8rsrpuEpfGL+dlDAzgX0lFMqEY
         t7YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x/V8s8uaYeKYuAXh83eqMNrq3SnymKmItW+yIrZGRcc=;
        fh=GhS7JFQ1nWim9d4zghlFMf/A4pi09n+cQFiZvzy0QUc=;
        b=fTQJNMWgRZe7Fft7gveR+uLnAUmkXMzEPO9pM9Y9bpw0JMYWYlHL0yRKzswDvOS6kt
         nsUn8HpZM+urFVbK1EHS5YNTHHOOurPx7RiRwIGmt7bO+R2Db3LFElaHXZobowiCOAy0
         moTUA+C5Zh/3to03wEI0SHg7QTvVP282mTPBlq8U3syok5E9WyY5pTDQmGVOMhuP+l7U
         x4/zooTDfQqWy7y2t1HSAEnbXUJJEzRBUmkWIcAgqDPFemZnN1S8pCCDO3mcqOGED/pI
         AkqKkkdhOittMs0wb7CUXiYOJvT8ZBTb+5Z2xrXRNue74dg7hTRtwO3YLKqiLhJdr466
         pXwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794198474; x=1794803274; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x/V8s8uaYeKYuAXh83eqMNrq3SnymKmItW+yIrZGRcc=;
        b=DsUGr9C5KLkiFbnAD3zMpiLIYIA/f7Vr6BeaXDqnrjn3t0IWQFGJPzS7iSysVG/93P
         KBPCgQkVu1cp91zZ6+6JX5tWnSCxmZYlTVFtVUSgAGZwp2rgVMWAAWro4/oVIlNU/o57
         ICKcV7hsYOxa6EJtLN2mnpon8gowWru9mfHnfBjcc6Qx/UwHXpkzxjk3wkDK8OF+TWI0
         NBm8ifvH/d7O04ru48sdSmJTX352bBPRgB211OuZT3z946JJGH0+zOubzvRmCIqtwC6Z
         KsNvR/1LCV1cq8N5vNLYoYFl0ABqZI2RHtat1vGkg+Fj4emuD0Gvtkm5wEdzciDnnyDL
         QGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794198474; x=1794803274;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/V8s8uaYeKYuAXh83eqMNrq3SnymKmItW+yIrZGRcc=;
        b=H5AcnyA1AhGAv6Y+Av9gGv4Q9c0juZk0ApM404URyPIhRUkWJxPUQPYnMwa0RGlssY
         hVa4/Yzb83sr8PuhhAdpKHog1tskKm2EEvi92sx78C85tN8Kzv/PTe3yX/lFI+5Ub/LW
         WRQyfDtpc/C390vGkVHvBBBoSVjODIkNbfvSuO2z4qk6ifk8GUo7ifPSHlJT2v2fYP2e
         7nOWbzcLERDu5qlJRiCy0ZhIIkEoXb4PohBZjoqPIhzCuzpEa2qHLjDJzEe6ZeekGBzG
         c6bSRxVhlxSE380uanPe1PCU+1UU0erX71kbkNomqoDmK8S/oNTIllBgmgvyTs7a3aIC
         6H9g==
X-Forwarded-Encrypted: i=1; AL+hErFwzqE3uYxUasH2gwzFrleqkInJuRGxFlg1/++ZEY212FyoPmIjjAqekxZtqDF8kYUif46zuZ7XFg==@kvack.org
X-Gm-Message-State: APuU4Z9h4HDTtbU3jKTOpoY7RpioU/MCnC/PuI99CfN3C40UCEkLz74u
	TmonbbqYBTRvp2UCuyL2EYpwzcw6KGscVjVF5TOzsYpzL66a5fKHiAuZ8XKPKI+TszChQxd6zXQ
	wgFhK9dSQR4Eqhor0gijAtpBV3PgEeko=
X-Gm-Gg: AYBFou2XyS+VcIQfcciNGCMLlMR6qEY/mGcoZ/AKpya0HZ7kZsVMJDxYpaeOgG5RyCX
	xOfOgWHS9Ffhwl1S8mQ3XaOX2AUjeMVpw0LNXr7bJZvxdNZohCb2g3eSVBOcZD4nCBIx1jHdMHm
	Rmp6C6T51j5ZhFMimPAdzeri7BAh+O7wsU4HJBJDZHPV1l+WG2q2nU4huzZ09DUeDXxNyixLl+J
	4v9TOAvKEucz5ek8/IyCLj8uItYlSgLnDKspzdHHdua0atAua+NeiB6QUOdO2G+vPLDQ4KMBCCF
	MsNiL5tCcXaRAN6XwHZfdZKMYhie3FEB/KNGZMF+7HRsVAbX2/i9V3Ljkgs8GQcumnSbdsUlzAE
	nx22U6SmdA+eTKUNUA9HeUBY8R4pvqs/h0x7hJ8GBi1URKnBvhVJwPxWMJiiFEKRPloQnfaPliM
	OMhZ7qyaeBBuSe8qXApulCucSJZmTtJQTe42alQSoFpdyOeEg=
X-Received: by 2002:a05:620a:3190:b0:939:7683:33d5 with SMTP id
 af79cd13be357-9478485d5femr443802185a.19.1794198473590; Sun, 08 Nov 2026
 20:27:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <auxqWxUfRVvxnk_n@pedro-suse.tail5790ac.ts.net> <44740e38-77ae-457e-97db-d6e0a0149dc2@linux.alibaba.com>
 <4a64ea17-6ac2-406e-a432-b82c481a4f84@kernel.org> <a069e3ca-6bbc-481e-acec-5ef21855b9ec@linux.alibaba.com>
In-Reply-To: <a069e3ca-6bbc-481e-acec-5ef21855b9ec@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 9 Nov 2026 12:27:39 +0800
X-Gm-Features: AclHuK_sNTtrjAjIrpAQh7idqCIEWYHWxlYsqsc4o9-_q-3EsWqOtHAcPFa_q7M
Message-ID: <CAGsJ_4wGQ68vEhCS=6CAAr9K4O3Q2fazjpP8QSK2Zs3r6R4Wfg@mail.gmail.com>
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: erinpt34855hxi5m9joq67rmp414pw31
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3648180004
X-HE-Tag: 1794198474-177448
X-HE-Meta: U2FsdGVkX19Xoe7gMI0lzjOWkcVArXiR6XUUmfo8rOI5PrNYQPIIjVxu/xoJaYQ43/r/F26n3IYGBGRiy/9081Zr07B4v2KTMF6EgcRMUp/JxJDSjXvwxBUC8C4GaFhbAOzode7deUZRmk/ZE7Q69hDaEwKBUeP4kBK3Reb7hICbh/f0/YC9jX/gQv42VUIRCRL5EPXcxYD0X3AcZHLeGM4VqPjxmAqwi1b8aBV86bwJuR5JMhva8OkrTFAo08C2qu2NuzRVe6zE7GSqlgHXuK/K8KwZbBFbObO5rqEaep7tt8i+iWQYxJa4caadMQ0DQEeesRCb4qKaoe4yVGE9ezonZ1ro37DG0fy+4bJ0o+WN6/yHQotcRhTxw2YGKogsB1L/fcj3dtoIMFFHFpEmXBRDZBM0wJ0BGBwS+S6/zfYPTcSG/zNCVIufHDvDKoxyLm36G+xB4kt3BAd1Ihpw7eEt5EkLwE2FptjoTHf8lJp3TpSpaptjX3JRAWjYAjni9/Ztq95T492TyPlGBMcQv2eyXWkNv0VcoKHrBQZDM/v4z72515UxuPw6TaXTVhgC4ZecmhssgjbNHPsD3svaHiuaDx9WsgOpW+bug0cjVXvc0uyLX6lMq+TyOnZtGGyH2BIT5GNgovJEkyf34DkinWg/30//om7Vulxm0/p+jRTUhuxMcf0I1NqbnlOIA/QarQEZ4+SdZHT9BdGVcesNZQfneD/FRV32Gzr71Dep+fvtM9ZgQhoqWYac0qnFZiZnwCk6I+Im8r1El/ASDN1kvIGxdLW35g1BVWuZVoGadKuAxlxfCAtClubCqQaZzsw9MO3NtpV0LW9r/Meo14fVXZahUm/e9qtZIPY1pj6MiInCNd6GysoeyksIcIZRPvtA9+KKFShcq56a35X+AM9yxXkGvok+z5AMSWAEGS8xu/Eqb46knEoFcAIM04I3XEmBUyhW9Aiil3Gm7z3lEsv
 TLCfyT0g
 9uqwNBnHS04oogV+jHE8AMVABOjUErXOJ/6t5Se9YUV6fiZPpVNs4EFiuArafrSWFSSoe4P3752HucH4+Ie1gcVsHWnM1EJHPaGIfnKHLLZIfAYSGN8IWMlLnGYGIMuh2LwBo+3BOnP0bgQ9js39ZDlZon8nagpqKpymyV7XTq2Nj/nHc0bP97PZR8N0ifDQa/tWMI9SPTdRScyBO1+eYR7VTGt7q2hAEzVvaG/gAduI/pTWyP6mWu+gDjepdoeakeBD5VM517uC9jsZGZb+EuW7xU8n7zgly8UktUJRgEojyBhRvHSg4/+Dire/RSJ3Z/RYJYsitNEAaQdj0qifMxvB0hBuUgF9ELQTzy72OFcNUWhWOui9P9+ysTL9YLEcLhsOr47NJZkI3ZsDwqd0U+gHxVOQTVEALBpx7VHeFpAsjrwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 11:42=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 11/8/26 3:58 AM, David Hildenbrand (Arm) wrote:
> > On 11/6/26 03:12, Baolin Wang wrote:
> >>
> >>
> >> On 11/5/26 7:37 PM, Pedro Falcato wrote:
> >>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
> >>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing=
 mapped
> >>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can a=
lso race
> >>>> with concurrent page table reclamation via zap_empty_pte_table().
> >>>>
> >>>> page_vma_mapped_walk() is used by many functions including try_to_un=
map(),
> >>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migra=
tion_ptes(),
> >>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_=
to_unmap()
> >>>> and try_to_migrate(), the other callers do not perform post-walk acc=
ounting
> >>>> checks, so the race has no observable impact on them.
> >>>>
> >>>> For migration, the race can cause unnecessary retries. For reclaim v=
ia
> >>>> try_to_unmap(), the race can cause failure to reclaim a folio that i=
s in
> >>>> fact already unmapped (as shown below), which may lead to unexpected=
 OOM
> >>>> or increased refaults.
> >>>
> >>> This is very handwavy. Do you have numbers? Does this actually make s=
ense?
> >>
> >> This is hard to measure in practice. But in theory, if we can't reclai=
m
> >> cold large folios that are actually unmapped due to the racy checks, i=
t
> >> could cause cold/hot inversion (e.g., in MGLRU) and increase refaults.
> >> In extreme cases, failing to reclaim unmapped large folios could even
> >> cause OOM.
> >
> > Yeah, but the question is if it really matters in practice.
> >
> > I agree that page_mapped_in_vma() should sync properly, but the current=
 impact
> > might not be as severe.
>
> Yes, what I meant is the theoretical impact. In practice, this race is
> not easy to trigger with no real reports so far, or the impact is tolerab=
le.
>
> But I still think the fix is needed, as it matches the purpose of the
> TTU_SYNC flag.

I assume the impact comes from LRU over-protecting folios
that remain mapped after try_to_unmap().
                        try_to_unmap(folio, flags);
                        if (folio_mapped(folio)) {
                                stat->nr_unmap_fail +=3D nr_pages;
                                if (!was_swapbacked &&
                                    folio_test_swapbacked(folio))
                                        stat->nr_lazyfree_fail +=3D nr_page=
s;
                                goto activate_locked;
                        }

folios are activated -  over protected in LRU.

The racy window should be quite small in theory, so the
impact might not be that severe. There is no evidence
that it could lead to OOM.

For large folios, the impact could be greater because
we are over-protecting more memory, potentially
increasing with the folio order. For small folios, we
are only over-protecting a single 4KB page.

So perhaps the current TTU_SYNC flag for large folios
is reasonable. Baolin's patch to respect the flag,
which currently applies to large folios, also seems
reasonable, as long as we don't extend it to small
folios and introduce regressions, possibly in
map_pte()?

I'm also wondering whether we should downgrade
ACTIVATE to KEEP, which would allow racy folios to be
reclaimed sooner.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 071a6eaef1a1..726266e49533 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1353,7 +1353,7 @@ static unsigned int shrink_folio_list(struct
list_head *folio_list,
                                if (!was_swapbacked &&
                                    folio_test_swapbacked(folio))
                                        stat->nr_lazyfree_fail +=3D nr_page=
s;
-                               goto activate_locked;
+                               goto keep_locked;
                        }
                }

Maybe it's just a silly idea, or perhaps over-engineering :-)

Thanks,
Barry

