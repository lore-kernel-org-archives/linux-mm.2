Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3211CCFA466
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 02:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F8E6B0026; Thu, 20 Nov 2025 21:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706ED6B002A; Thu, 20 Nov 2025 21:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DC56B002B; Thu, 20 Nov 2025 21:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 511136B0026
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:42:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE38C1402FA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:42:13 +0000 (UTC)
X-FDA: 84133064946.11.72E6DB5
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id E123B1C000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:42:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OKLAh/Wv";
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763692932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aG1gNvX12mFbaTVukDWqvg7Sz0xqHjumlFfhuK5ypGQ=;
	b=Sg85K1o5YmkkafJQMhtBdTYqLSqXPyiVSpkZO3KvveCVui9kF1RIUQnL7UB0zcd5i16BD3
	mOjepVHr2WwMwTQglQXXaZ4OaWDPkb+M90G3JdXn6220Rs/AwfogxB0c0vpsniXL8OiviV
	xhDNA2I4LfRj+TTqJ99EUffG8v5CJY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763692932; a=rsa-sha256;
	cv=none;
	b=GhUP+Zv0K+6zvBhG2LqqruL6peSKmpXJ80CR+o9kmHVOGgVftIc+bpA0qSgW1dHbbALIVJ
	wpuAH2RTU6pOxndr72+cveZMAcsyQG0UbIt1BX8lGK8A/QyRaF2pfnqFBWYIL3Jo4VCGzm
	cRpVa9pcPc0WUYaqsoxxXpEEQ94nOMQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OKLAh/Wv";
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so2762837a12.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763692930; x=1764297730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aG1gNvX12mFbaTVukDWqvg7Sz0xqHjumlFfhuK5ypGQ=;
        b=OKLAh/WvmzWN1g7Zc51MapiXUCsl2TXePQcrJoo4CW73mL8fT1BOs5VwA4uv8urCvw
         2bv7s71fBpeDT/CPNAc898xMnTkP2CbF4NWHAynTbrSstbkqYIYiWetXjz6f5AkCCG0x
         5Y/STGjvIs3AuiMNXlU0OJKb5n+FcCkRL2lC440Cp8n/89XTou5v7z/0YgRTemPooLwE
         S3SyVUQbZU+fzcG98QJOeuEUozZnhugOuk4mHDbvyi6WbBySdxdVWw1j013iZs7WlNXK
         LD/8NxeF19Cy2rMoVa503Lim6MlzfDpmkUMbFnlp8jda0GYyHRU2F3Wz6VC9UyoB9deG
         FfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763692930; x=1764297730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aG1gNvX12mFbaTVukDWqvg7Sz0xqHjumlFfhuK5ypGQ=;
        b=WiVz3tLkVv9oDq+NQvwMmPm3xTiB+TnwcN7KlJDoVCWnE42KJCmJAGbE1BtPMkZWyL
         MoDxg0JLBXC52lrV1NSVWoAJ4Q4uMksRke6A8PbffV0x7SHi9UgoqCF12klqW2LG3znn
         iqj+z7VY4CSSwXamovC2q3ppCUzeW6jql+IwAoPU+tYhQnOU9wkbdvTFfLAZJ/2GbGka
         REyyIhfbvmo7UcpMevJzOzuFZ2Nw/+tr+nq0CzEUOgIiX63jW2reLeM2aWsrM/Uk8FRh
         MhoKEBvVLIBsH8C9gMngLgSbF3yXtMSHGDadTrgi4Ub4z8UX0BE5DjzpiQWBn4Upxlg0
         ziZg==
X-Gm-Message-State: AOJu0YzfsWBWoQbOT7GZw3mZ79sxskudd7+dtgqZ256CgcFH/0QI1dMQ
	rAgD/6ij10DJFrSKNZSCJd77feE5x3IIRw8Msl3ABU15WQ0RC2T+eNv+T5PvJSlJ8vd9u9j6pVL
	UE3fra8ogO51EXYxqbjqvAqBt9rfs2eQ=
X-Gm-Gg: ASbGncu423MoMap1A10mqAR/Vw+nk7mJkG7mSJrNkzwmigO4HVUy7sTm/Vs3GRu88ac
	TWhO6ntq7sxetyf2/VS3Iv3tYGzl/t7L/iTHLaLm3LIl0JcrgqeyQ7CH2Xx2eGMHD/Q6756IOGh
	R6gGOG5e1Z2uzYnK9edCkAPpA0BIUa/ELVOjJKPeMS1pWZEV9LmjbKuSDKBqsUg44mYeBLDa7tT
	USQUTm1CPj/ZwRGbvX2NHpiWHfLfB1Tgnm0+sI3uIrs5FjSaYLV5FsuFmEdEIBfb0AYR77DYte3
	kJhIWxqyi0pkh8UxFZ9QpsIcqZgGDFA=
X-Google-Smtp-Source: AGHT+IFIhnYEepkxXziqlUOUfduozhyl+4q52apImGvyha6PIl/kObL/KhTey6tNzbVpl9UVS8ZcSk482g2P748epa0=
X-Received: by 2002:a05:6402:510b:b0:640:ccb0:f4da with SMTP id
 4fb4d7f45d1cf-6455469bf9fmr719414a12.29.1763692929878; Thu, 20 Nov 2025
 18:42:09 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-3-37730e6ea6d5@tencent.com> <CAGsJ_4zSqQax-Ct-zz3uMZ_dD7vnvTjWZ_BsnXBnMVpVNNDYUA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zSqQax-Ct-zz3uMZ_dD7vnvTjWZ_BsnXBnMVpVNNDYUA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 21 Nov 2025 10:41:33 +0800
X-Gm-Features: AWmQ_bkT9_nY4s0wnqQFGfaNrU0zB4Zg3rHgZ_Puymj_6T3RSmTCG_WLjSidrSw
Message-ID: <CAMgjq7BYNwVSX+=KDxmdFpUZ4gnTDjA7LU_Fi=J6SFUV8pAcUg@mail.gmail.com>
Subject: Re: [PATCH v2 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E123B1C000D
X-Stat-Signature: mza4uwecsnocjdc1pm4f3ogf95xu7wbz
X-HE-Tag: 1763692931-817778
X-HE-Meta: U2FsdGVkX1/kkfrxdEVkDeH4f8Ck/n3IaSxrK8VlsTl2mwCS9SifaTQzwiZ2GwxlcrjJ9CzgiElBcT0EbtUvRkiNbG2uuUG61646WUc0MUR8mS0DpfaOX8gmn3QPZ4WCqN7395U+F99rmLucNnaiKWuRStjuoCff2VzS+bP0bRYtI3oba36pRHL6pbCdXKGHdB5miXcWwLOJbgBxJn+LlUT0J3ShMdMzKKWXL6Qe11WHu00HL578FYCPTwGJGvtNjv3FGrXY03ilAriBYpnLyMqWIeJwSIWbz5M3SdixTlVw0+uwREdQqZWa5rFqmrizaeP7chb0VzkJ7dEH2AU+k7HxVp1n/tJDRjEOlEoalsxmjQV4wweApAwVOnLWU9ewcDoP6IQiJ7oYiVvWmfsEFA/rePcM+TYV07oViRSyzz7/t4D60pTT6Ec3V90E2ZpFGCVsCMsOX2KAi/trHJwnF0wpcQeQ92shQqjS3j03TfurDNOPyUYMWuz0NiIxyunNAyYl5FNzuwluMNnTrTJmHmorgwrwC2hXCN2TX+Y5n18Z9e0Btlrl/cBlpBx8WD4w0AEzoJna175ZDFNLotmI8mdq0mnJAxmV4/xQUMfaxwBpKCKGuZazXEMRorxXCZ6rSDlHZZHxFFJuAWM5aMYhpiGWvJ00Tlx4+CKIHL7bz5SLZf42KvQPDFO06jgKbjSyL5auIqKiUzikSwHaLwC1O5x1aLz+kqof4QyWGYAEuhgAx1UOxwt7Nlp1pI3C88B/oWKbI2hmFKfjaJF4DMGi8McgMhI96l0xArAQLPF5k3WC70Y6tJme4jsB0M5MaJKcBpydsr2QFC8b7S/pSnwFOvsHVzSJYXw9dS/JsvqNtvHiD0t54VP4M4fne+zSZglxia5FcPCqu5mKRYieBCUXQkwMGEf8KadR5A8eCxZqEi6cy1ylZel6uBbandcPuVoWZ5o1iJlItHpvEJShZjo
 nqXAL3Bg
 yY/Q6dDrE+1znttoIoZ2S+Jonnv9Obwt58L+hG5/gDG6L8878ZXleb7sAWZt/snQyIuuvMFyfW4jm3wZ7CZEJIvg6wvqgdvc/WbQ59tGYNnqDf32Pk0wT//ZmuH2CiSdwGtoXYVpvz8OMiPPExXQNSRakvVSqAASu/HojSUxrWRGy2d4fq/Et2F58X9qN38rzobrD5PFcwwyKghyoMr0Ivc2dBeMu5UeGxveQqcL+WLTfzb/QdzbsVYOU3mrTCpEdHM3TOVqwyY04dqfh1AiTTdGCDRkpT4kEg0GgWDCKtzdBzqiXrhCJmYr9BaxUaZCN26YDlkte6bCuVntArSAtk3SJZRaFA3lhZ8E4fX0fx19GI74c15WqrGs0gEMnPNb9o+Bl6QQMViioXU2ZYTXtERVvRPN3V6m5faMrQF/GTCfjPJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 8:55=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> Hi Kairui,
>
> >
> > +       /*
> > +        * If a large folio already belongs to anon mapping, then we
> > +        * can just go on and map it partially.
>
> this is right.
>

Hi Barry,

Thanks for the review.

> > +        * If not, with the large swapin check above failing, the page =
table
> > +        * have changed, so sub pages might got charged to the wrong cg=
roup,
> > +        * or even should be shmem. So we have to free it and fallback.
> > +        * Nothing should have touched it, both anon and shmem checks i=
f a
> > +        * large folio is fully appliable before use.
>
> I'm curious about one case:
>
> - Process 1: nr_pages are in swap.
> - Process 2: "nr_pages - m" pages are in swap (with m slots already
>   unmapped).
>
> Sequence:
>
> 1. Process 1 swap-ins the page, allocates it, and adds it to the
>    swapcache =E2=80=94 but the rmap hasn=E2=80=99t been added yet.

Yes, whoever wants to use the folio will have to lock it first.

> 2. Process 2 swap-ins the same folio and finds it in the swapcache, but
>    it=E2=80=99s not associated with anon_mapping yet.

If P2 found it in the swap cache, it will try to acquire the folio lock.

> What will process 2 do in this situation? Does it go to out_nomap? If so,
> what happens on the second swapin attempt? Will it keep retrying
> indefinitely until Process 1 completes the rmap installation?

P2 will wait on the folio lock, which I think is the right thing to
do. After P1 finishes the rmap installation, P2 wakes up and tries to
map the folio, no busy loop or repeated fault.

If P1 somehow failed to install the rmap (eg. a concurrent partial
unmap made part of the page table invalidated), it will remove the
folio from swap cache then unlock it (the code right below). P2 also
wakes up by then, and sees the invalid folio will then fallback to
order 0.

>
> > +        *
> > +        * This will be removed once we unify folio allocation in the s=
wap cache
> > +        * layer, where allocation of a folio stabilizes the swap entri=
es.
> > +        */
> > +       if (!folio_test_anon(folio) && folio_test_large(folio) &&
> > +           nr_pages !=3D folio_nr_pages(folio)) {
> > +               if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> > +                       swap_cache_del_folio(folio);
> > +               goto out_nomap;
> > +       }
> > +
> >         /*
> >          * Check under PT lock (to protect against concurrent fork() sh=
aring
> >          * the swap entry concurrently) for certainly exclusive pages.
> >          */
> >         if (!folio_test_ksm(folio)) {
> > +               /*
> > +                * The can_swapin_thp check above ensures all PTE have
> > +                * same exclusivenss, only check one PTE is fine.
>
> typos? exclusive=C2=ADness ? Checking just one PTE is fine ?

Nice catch, indeed a typo, will fix it.

>
> > +                */
> >                 exclusive =3D pte_swp_exclusive(vmf->orig_pte);
> > +               if (exclusive)
> > +                       check_swap_exclusive(folio, entry, nr_pages);
> >                 if (folio !=3D swapcache) {
> >                         /*
> >                          * We have a fresh page that is not exposed to =
the
> > @@ -4985,18 +4962,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         vmf->orig_pte =3D pte_advance_pfn(pte, page_idx);
> >
> >         /* ksm created a completely new copy */
> > -       if (unlikely(folio !=3D swapcache && swapcache)) {
> > +       if (unlikely(folio !=3D swapcache)) {
> >                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLU=
SIVE);
> >                 folio_add_lru_vma(folio, vma);
> >         } else if (!folio_test_anon(folio)) {
> >                 /*
> > -                * We currently only expect small !anon folios which ar=
e either
> > -                * fully exclusive or fully shared, or new allocated la=
rge
> > -                * folios which are fully exclusive. If we ever get lar=
ge
> > -                * folios within swapcache here, we have to be careful.
> > +                * We currently only expect !anon folios that are fully
> > +                * mappable. See the comment after can_swapin_thp above=
.
> >                  */
> > -               VM_WARN_ON_ONCE(folio_test_large(folio) && folio_test_s=
wapcache(folio));
> > -               VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +               VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pag=
es, folio);
> > +               VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>
> We have this guard to ensure that a large folio is always added to the
> rmap in one shot, since we only support partial rmap addition for folios
> that have already been mapped before.
>
> It now seems you rely on repeated page faults to ensure the partially
> mapped process runs after the fully mapped one, which doesn=E2=80=99t loo=
k ideal
> to me as it may cause priority inversion.

We are mostly relying on folio lock now, I think there is no priority
inversion issue from this part.

There might be priority inversion in the swap cache layer (so we have
a schedule_timeout_uninterruptible workaround in
__swap_cache_prepare_and_add now), that issue is resolved in the
follow up commit "mm, swap: use swap cache as the swap in synchronize
layer". Sorry I can't make it all happen in one place because the
SYNC_IO swapin path has to be removed first for that to happen. That
workaround is not a critical issue besides being ugly so I think
that's fine for intermediate steps.

