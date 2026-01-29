Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04A2D61010
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 12:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E8D6B0089; Thu, 29 Jan 2026 07:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06746B008A; Thu, 29 Jan 2026 07:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08326B008C; Thu, 29 Jan 2026 07:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCCA6B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:28:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D8C913BF39
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:28:53 +0000 (UTC)
X-FDA: 84384930546.09.7600F54
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 253C8180006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:28:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NjKZLrx3;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769689731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHqjURYN4atUfE0BElSDPuu2blTOLD3T/7U5tuCcJy0=;
	b=aGj4/FNmDIsz+UlltbNm5X8AT8isSHxddj5aaDzysIIYNO/EB7SfZDylwg3EGzTSTEnKFK
	Xnm28vKP7twCCsZaOHZNGyBkBlNJ9MZB/6JTS0V+sAjJN9pNA3zLgVtigs4e2qxzW4exAt
	L2gNOMmfipUM03QIeOu9DCEwMeX1Vx4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NjKZLrx3;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769689731; a=rsa-sha256;
	cv=pass;
	b=khsVxW8WPTjWkqYk1msEoUT5WZYVsM+DG7Q8+UfEHcJUCQvgp+7MaYeRUyURNNu2/5ibSc
	Q46kYTO2qZMC1hnUhvb/SK3sVkRXEY5ILnJH5gZ1FXTUzhu1TrsHtDunNKDvPEZJ4zpWe5
	s8oZo9mIvh+dhP8PBn63+9iNvPJn/Jc=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37fd6e91990so9759191fa.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:28:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769689729; cv=none;
        d=google.com; s=arc-20240605;
        b=Fbz8mvqCLmpo6Xgzyb0q+FfKDkdJ6CWu/DKfRiKyr76peHQM1+caoYeKWoVfH0tXnL
         puXZ1sjRGdUIz2ILFh1F01Tb168+h5fzPRslEHZrk2FNgdaE96q6y1iOdunD9U8cd3qb
         fBxf5Aol4c53iCPK3GSUcZiRPE8gUIM+ndy/YgIf3Et9Ykq9SxHh1juKUI7fBdpXF7gn
         BUb/MCYqbKmWVKEZGQ1NPAyGAjOTFdp4jwhQU2C5jp+9ttBr56JXXhiazwItAIgQ2GD1
         ekAzQ/BS49gX8+sZkfxKo7ugcaB8lhN6GOFu4JmYMgcg1+xROYDAmDPt9llQNFYlHD0N
         LY9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dHqjURYN4atUfE0BElSDPuu2blTOLD3T/7U5tuCcJy0=;
        fh=y5DM3VEPAwm4CRiroXjj0l3H9MEi99XhRsPpRQeAXtY=;
        b=jNHyig/7CfZDvVz6YlMF5sumt2km1mRSoRLuXgdcN85N6gORXoyH06R82d8m1SqChj
         OfypOZCzpjU2ON0YTCL/cbHxTavLJeRWuQx8CAtnbdveEDHEAoABvSXKI6mj/zAZvKkf
         FsOCErmLdGp97vG0WR711JR8dI6TfbzLV6uY/LGUaN0rG6o3+PtLGFbrzY9tGTuI60Jo
         uI6oPNJbRBYOVgAtqFaX6Elxhacc8xPxNt5gnPPkdGedBcU8AIXeQ9hTbTvye9y4KE1a
         xpUt50s5h/0MymCQTYm3xgbD9LI18J4bN6qq0pxhIkk3SSoi0PHA7DIx8IdZiy52GWTE
         AZqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769689729; x=1770294529; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHqjURYN4atUfE0BElSDPuu2blTOLD3T/7U5tuCcJy0=;
        b=NjKZLrx3If14jFRdqv+Cn0YTtEWoldW1sHDUs1Ifw1Y+pz8x5y27XaRy7Mdxx1vz7h
         Z+8992wsd+MDrj+RBuYkMpd0ZflSafAdmcPiirwcRdAlARTamkrLtQZkKdUAi7y/PEvN
         BbpQ8cpx1oyGUM1MLNYgOPGbxtHJM9xnqpgdc3Ryr5dW8R6n+ly5Nqi5H0I2EmNryuc5
         dJRwiOzlRq0E8U3XRPbd329ThHHW0SI5RNiEICrpfR8vT55Aeir/MvnFBBqUabodFOnN
         N1WDHmTHA+cB9jZc4o8Zyx8FYgBE3jJssOn7hEG9mBhJEAUb+0mi1roRlUOHSbigeZOl
         sfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769689729; x=1770294529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dHqjURYN4atUfE0BElSDPuu2blTOLD3T/7U5tuCcJy0=;
        b=iTHorwOgPbsstHEeoLTTs4TKFgdvY2luvapm30whW9qalFCyErMWX4nc2V2D+CFXdM
         EOaze9RdeUtX8PNV+zVZ0LjbRszKQRSzFcO/oA2/YTuwA1HxM/aqAfjE0zyG0RVYGHkR
         TbfLuHmFrrYzaJZ8lwFoxHW0dYN1EhE5B8mbDfkpROUYARUFikxjK2DH1jvTMbekgZnb
         4uqrUuqPMEoQS9AGdx8xl4bZvSS96IhntHCAQdAOz+8aw2/jYzKgyORbmPefWbkjlVFO
         05uwIOJtr8sy7Sv1FO90O7F0wRNFd/9+LEgEu9RaRO66EoU7y/sp7KohqTFRxmIdPSnA
         qt0A==
X-Forwarded-Encrypted: i=1; AJvYcCXdstlqt3HitKKJ0kzxvnWhSYuRT6m/2B2ceJD7Uc48proZ+FdiaHraK8EZWcrvyKbuxGznlMRFQA==@kvack.org
X-Gm-Message-State: AOJu0YyfSuKq346QF9cQRWcKNKz/VRx2Q0t1qS3M78rwLZFuZGBL+sXL
	7C9Ce1Cpu2ZFl0T1Y8GLNQNHOwQqYqluuEPPwS+X1N5ZvXmZoVbAmG/x8tmQ4qY9YfLNn95JRG9
	RDUaeIThPCsf96+UIb9J1xsr++AAIEPw=
X-Gm-Gg: AZuq6aL8KC8Sn0YxLVTE8iXB8JVIPvaULi58nvdT+B22Xm7Q8s/VpkcNBFKThqJgxB+
	y69bh07si5+qSlxm3TdVBPfC6H2m10GFJp7Ql/v5iIqffjJYGqQOAyl62sSZ/4XX0g0hCpbh3pD
	ww8hwekea4NqvuPB7lcQQFbskKSsy+wTylTq85KKcqWwbSPMAf5tXQcQ0JqoqJ1HrYpq71utZmv
	suO+HPkxVPsA6kTdgIdiuASeqDY0YstWy1huICnizs5pbWaclYtWvqFrIfOBxECJnc+AUz5u9t3
	fHvPWoY=
X-Received: by 2002:a2e:b895:0:b0:382:fccd:f999 with SMTP id
 38308e7fff4ca-3861c90df4emr38830551fa.25.1769689729230; Thu, 29 Jan 2026
 04:28:49 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com> <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
 <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com> <d719e478-4849-4c5f-9e6c-f45d9771b37b@linux.dev>
In-Reply-To: <d719e478-4849-4c5f-9e6c-f45d9771b37b@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 29 Jan 2026 20:28:37 +0800
X-Gm-Features: AZwV_QgPLE28dBC2wSWpclQwzNa1tJ8emQ_klM22EQIeDU8pM5A_ljYeGghyBzU
Message-ID: <CACZaFFN28j97OzV0Yz6EySJdhQYnVRh5h2JC8ZY+yuGvupwrNA@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Dev Jain <dev.jain@arm.com>, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 253C8180006
X-Stat-Signature: c8htkytdt7dos9htg88wq1xupd1iar5i
X-Rspam-User: 
X-HE-Tag: 1769689730-631558
X-HE-Meta: U2FsdGVkX18ao8/GCVqNzJ9403NiV7AUjMUWV225A58Qpd61C0ppYL3KFPkdCwSeU1JAo0yqicfa5dJHixKxDjoaEpnIm7mLdV5t0PVlu2QjEnwTx23FYM1ZQUCjuGa+XhI/R4lTpZRqftKhabF1+0mZeCi5I1Ghx4Z20k7IJjVbGUOK32aP3l7bVfRjgY/AoM1Nd27qQy43MyBWyzHKVdfxL8w3buQUzwa6jHfKkNeWZeZ4ZFINPFJCwF43i7KJoriTrk/dsgeypqlFdV96ppoUOkXzbUe4VV6SXQub4DqrcoJ0OXEiBAB5Bx0Pv3/fRjj/G3XO39pbE10CB9UeAUm1z5M4noO8b5kOLg9l3E4meWwqL0OFP3g9iLih2R5ZBwX23KAev6nCduWIoMEgJT3oRZH5VtXwnMOORZPncWe4o+u5v40ctip3fxAk730OBqvprJHLx1srOY3wBvWdpthFidpo+s57ei/NKpHMdkmD0vmF3NuV3Eyd0lsykasvzBSBsakOK+BDkGoF2G5+qQV5RGJkWf+XOHkTYJMgugnyIWzaWTksehNmSD2EtzdEsCNyuTWffxWziNjMVpNhGd0iuz/5HoEHftekN3xR+khAFln4BrFgzhG2Qs0aFusrcG7uIU5FD6qKHnpLajFwZP5c1jr+l9fZ8sUGkoKuvP0AfjdqutHRCOe8HLquKjC3QRUTREyu+euH2ARIN1gN6atA8NaUEeuCuEBnMx3u+LKXUoEczNHNecXmk/KOkKgg0ZJOnG9hBQlXHj42xNKFEzAPd44baBfoo+L2zVL1+JM5565OcrOyncW3BDMSeOJsWgWGxPihHDUBUM7y8x8YVrojNdgbyDkS8qs8ArcIbwLsxwHyQhS0C/XRNs6NxEzjNw3nAXm1yGA9KqX2qPZPFyUCCcrgxOItocFTl2QyqHquiEC81KKMXWUYaLkVZAk+9lWXsrug/Mr4YEKEWtQ
 oOM9FW0n
 tGTEjoPX1+UhW2bEiuW5iB4u7/MHAzFFAy9UsAtqqb30LUy0h0C6dkzoPlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 5:18=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On 2026/1/29 13:35, Dev Jain wrote:
> >
> > On 28/01/26 8:04 pm, Vernon Yang wrote:
> >> On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
> >>> On 23/01/26 1:52 pm, Vernon Yang wrote:
> >>>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>>
> >>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> >>>> even if only scanning a single PTE/PMD entry.
> >>>>
> >>>> - When only scanning a sigle PTE entry, let me provide a detailed
> >>>>    example:
> >>>>
> >>>> static int hpage_collapse_scan_pmd()
> >>>> {
> >>>>    for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >>>>         _pte++, addr +=3D PAGE_SIZE) {
> >>>>            pte_t pteval =3D ptep_get(_pte);
> >>>>            ...
> >>>>            if (pte_uffd_wp(pteval)) { <-- first scan hit
> >>>>                    result =3D SCAN_PTE_UFFD_WP;
> >>>>                    goto out_unmap;
> >>>>            }
> >>>>    }
> >>>> }
> >>>>
> >>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exit=
s
> >>>> directly. In practice, only one PTE is scanned before termination.
> >>>> Here, "progress +=3D 1" reflects the actual number of PTEs scanned, =
but
> >>>> previously "progress +=3D HPAGE_PMD_NR" always.
> >>>>
> >>>> - When the memory has been collapsed to PMD, let me provide a detail=
ed
> >>>>    example:
> >>>>
> >>>> The following data is traced by bpftrace on a desktop system. After
> >>>> the system has been left idle for 10 minutes upon booting, a lot of
> >>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> >>>> by khugepaged.
> >>>>
> >>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >>>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> >>>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> >>>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
> >>> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
> >> These 1,6 are value of "enum scan_result", you can directly refer to t=
he
> >> notes on the right.
> >>
> >> These 1,2,142,178 are number of different "enum scan_result" from
> >> trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
> >>
> >> as example, SCAN_PMD_MAPPED has 142 times during a full scan by
> >> khugepaged.
> >
> > Thanks. Can you please mention this in the patch description. You can s=
imply
> > right it like this:
> >
> > "From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, t=
he
> > following statuses were observed, with frequency mentioned next to them=
:
> >
> > SCAN_SUCCEED: 1
> > SCAN_PMD_MAPPED: 142
> > ....."
> >
> > and so on.
> >
> >>
> >>>> total progress size: 674 MB
> >>>> Total time         : 419 seconds ## include khugepaged_scan_sleep_mi=
llisecs
> >>>>
> >>>> The khugepaged_scan list save all task that support collapse into hu=
gepage,
> >>>> as long as the task is not destroyed, khugepaged will not remove it =
from
> >>>> the khugepaged_scan list. This exist a phenomenon where task has alr=
eady
> >>>> collapsed all memory regions into hugepage, but khugepaged continues=
 to
> >>>> scan it, which wastes CPU time and invalid, and due to
> >>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >>>> scanning a large number of invalid task, so scanning really valid ta=
sk
> >>>> is later.
> >>>>
> >>>> After applying this patch, when the memory is either SCAN_PMD_MAPPED=
 or
> >>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
> >>>>
> >>>> @scan_pmd_status[6]: 2
> >>>> @scan_pmd_status[3]: 147
> >>>> @scan_pmd_status[2]: 173
> >>>> total progress size: 45 MB
> >>>> Total time         : 20 seconds
> >>>>
> >>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>>> ---
> >>>>   include/linux/xarray.h |  9 ++++++++
> >>>>   mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++----=
----
> >>>>   2 files changed, 47 insertions(+), 9 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> >>>> index be850174e802..f77d97d7b957 100644
> >>>> --- a/include/linux/xarray.h
> >>>> +++ b/include/linux/xarray.h
> >>>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *x=
as, unsigned long index)
> >>>>    xas->xa_node =3D XAS_RESTART;
> >>>>   }
> >>>>
> >>>> +/**
> >>>> + * xas_get_index() - Get XArray operation state for a different ind=
ex.
> >>>> + * @xas: XArray operation state.
> >>>> + */
> >>>> +static inline unsigned long xas_get_index(struct xa_state *xas)
> >>>> +{
> >>>> +  return xas->xa_index;
> >>>> +}
> >>>> +
> >>>>   /**
> >>>>    * xas_advance() - Skip over sibling entries.
> >>>>    * @xas: XArray operation state.
> >>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>>> index 6f0f05148765..de95029e3763 100644
> >>>> --- a/mm/khugepaged.c
> >>>> +++ b/mm/khugepaged.c
> >>>> @@ -68,7 +68,10 @@ enum scan_result {
> >>>>   static struct task_struct *khugepaged_thread __read_mostly;
> >>>>   static DEFINE_MUTEX(khugepaged_mutex);
> >>>>
> >>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> >>>> +/*
> >>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vm=
as
> >>>> + * every 10 second.
> >>>> + */
> >>>>   static unsigned int khugepaged_pages_to_scan __read_mostly;
> >>>>   static unsigned int khugepaged_pages_collapsed;
> >>>>   static unsigned int khugepaged_full_scans;
> >>>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(str=
uct mm_struct *mm, unsigned long a
> >>>>   }
> >>>>
> >>>>   static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *=
mm,
> >>>> -          struct vm_area_struct *vma, unsigned long start_addr, boo=
l *mmap_locked,
> >>>> +          struct vm_area_struct *vma, unsigned long start_addr,
> >>>> +          bool *mmap_locked, unsigned int *cur_progress,
> >>>>            struct collapse_control *cc)
> >>>>   {
> >>>>    pmd_t *pmd;
> >>>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pm=
d(struct mm_struct *mm,
> >>>>
> >>>>    VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >>>>
> >>>> +  if (cur_progress)
> >>>> +          *cur_progress +=3D 1;
> >>> Why not be a little more explicit, and do this addition if find_pmd_o=
r_thp_or_none fails,
> >>> or pte_offset_map_lock fails? The way you do it right now is not read=
able - it gives no
> >>> idea as to why on function entry we do a +1 right away. Please do add=
 some comments too.
> >> If this way is not clear enough, we can directly add 1 in
> >> find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
> >> Please take a look at which one is better.
> >>
> >> case 1:
> >> as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
> >> [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglinchen=
g@kylinos.cn
> >> [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglinchen=
g@kylinos.cn
> >>
> >> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>              struct vm_area_struct *vma, unsigned long start_addr,
> >>              bool *mmap_locked, unsigned int *cur_progress,
> >>              struct collapse_control *cc)
> >> {
> >>      ...
> >>      result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>      if (result !=3D SCAN_SUCCEED) {
> >>              if (cur_progress)
> >>                      *cur_progress +=3D 1; // here
> >>              goto out;
> >>      }
> >>      ...
> >>      pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >>      if (!pte) {
> >>              if (cur_progress)
> >>                      *cur_progress +=3D 1; // here
> >>              result =3D SCAN_NO_PTE_TABLE;
> >>              goto out;
> >>      }
> >>
> >>      for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >>           _pte++, addr +=3D PAGE_SIZE) {
> >>              if (cur_progress)
> >>                      *cur_progress +=3D 1; // here
> >>              ...
> >>      }
> >> }
> >>
> >> case 2:
> >>
> >> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >>              struct vm_area_struct *vma, unsigned long start_addr,
> >>              bool *mmap_locked, unsigned int *cur_progress,
> >>              struct collapse_control *cc)
> >> {
> >>      ...
> >>      result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>      if (result !=3D SCAN_SUCCEED) {
> >>              if (cur_progress)
> >>                      *cur_progress +=3D 1; // here
> >
> > Let us be more explicit and set this equal to 1, instead of adding 1.
> >
> >>              goto out;
> >>      }
> >>      ...
> >>      pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >>      if (!pte) {
> >>              if (cur_progress)
> >>                      *cur_progress +=3D 1; // here
> >
> > Same comment as above.
> >
> >>              result =3D SCAN_NO_PTE_TABLE;
> >>              goto out;
> >>      }
> >>
> >>      for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >>           _pte++, addr +=3D PAGE_SIZE) {
> >>              ...
> >>      }
> >>      ...
> >> out_unmap:
> >>      if (cur_progress) {
> >>              if (_pte >=3D pte + HPAGE_PMD_NR)
> >>                      *cur_progress +=3D HPAGE_PMD_NR;   // here
> >>              else
> >>                      *cur_progress +=3D _pte - pte + 1; // here
> >>      }
> >> }
> >
> > I will vote case 2. In case 1 I don't like the fact that the if (cur_pr=
ogress)
> > branch will be checked each iteration - and I don't think the compiler =
can
> > optimize this since the body of the loop is complex, so this check cann=
ot
> > be hoisted out of the loop.
> >
> >
> >>
> >> case 3:
> >>      current patch, and add more comments to clearer.
> >>
> >>>> +
> >>>>    result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >>>>    if (result !=3D SCAN_SUCCEED)
> >>>>            goto out;
> >>>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_p=
md(struct mm_struct *mm,
> >>>>            result =3D SCAN_SUCCEED;
> >>>>    }
> >>>>   out_unmap:
> >>>> +  if (cur_progress) {
> >>>> +          if (_pte >=3D pte + HPAGE_PMD_NR)
> >>>> +                  *cur_progress +=3D HPAGE_PMD_NR - 1;
> >>>> +          else
> >>>> +                  *cur_progress +=3D _pte - pte;
> >>>> +  }
> >>>>    pte_unmap_unlock(pte, ptl);
> >>>>    if (result =3D=3D SCAN_SUCCEED) {
> >>>>            result =3D collapse_huge_page(mm, start_addr, referenced,
> >>>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct m=
m_struct *mm, unsigned long addr,
> >>>>    return result;
> >>>>   }
> >>>>
> >>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *=
mm, unsigned long addr,
> >>>> -          struct file *file, pgoff_t start, struct collapse_control=
 *cc)
> >>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *=
mm,
> >>>> +          unsigned long addr, struct file *file, pgoff_t start,
> >>>> +          unsigned int *cur_progress, struct collapse_control *cc)
> >>>>   {
> >>>>    struct folio *folio =3D NULL;
> >>>>    struct address_space *mapping =3D file->f_mapping;
> >>>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_f=
ile(struct mm_struct *mm, unsigned
> >>>>                    cond_resched_rcu();
> >>>>            }
> >>>>    }
> >>>> +  if (cur_progress) {
> >>>> +          unsigned long idx =3D xas_get_index(&xas) - start;
> >>>> +
> >>>> +          if (folio =3D=3D NULL)
> >>>> +                  *cur_progress +=3D HPAGE_PMD_NR;
> >>> I think this whole block needs some comments. Can you explain, why yo=
u
> >>> do a particular increment in each case?
> >>>
> >>>> +          else if (xa_is_value(folio))
> >>>> +                  *cur_progress +=3D idx + (1 << xas_get_order(&xas=
));
> >>>> +          else if (folio_order(folio) =3D=3D HPAGE_PMD_ORDER)
> >>>> +                  *cur_progress +=3D idx + 1;
> >>>> +          else
> >>>> +                  *cur_progress +=3D idx + folio_nr_pages(folio);
> >>>> +  }
> >> The "idx" represent PTEs number already scanned when exiting
> >> xas_for_each().
> >>
> >> However, the last valid folio size was not counted in "idx" (except
> >> folio =3D=3D NULL, "idx" equal to HPAGE_PMD_NR), which can be further
> >> divided into three cases:
> >
> > But, the number of PTEs you account in these three cases, are *not*
> > scanned, right? So we can simply drop these 3 cases.
> >
> >>
> >> 1. shmem swap entries (xa_is_value), add folio size.
> >> 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
> >>     to PMD, so add 1 only.
> >> 3. Normal folio, add folio size.
> >>
> >> Is the version below more readable?
> >>
> >>      if (cur_progress) {
> >>              *cur_progress +=3D xas.xa_index - start;
> >>
> >>              if (folio) {
> >>                      if (xa_is_value(folio))
> >>                              *cur_progress +=3D 1 << xas_get_order(&xa=
s);
> >>                      else if (folio_order(folio) =3D=3D HPAGE_PMD_ORDE=
R)
> >>                              *cur_progress +=3D 1;
> >>                      else
> >>                              *cur_progress +=3D folio_nr_pages(folio);
> >>              }
> >>      }
> >
> > Yep, this is unneeded complexity. This looks really ugly and the benefi=
ts of
> > this are not clear. You can simply do
> >
> > if (cur_progress)
> >       *cur_progress =3D xas.xa_index - start;
> >
>
> I agree with Dev here. The extra complexity in hpage_collapse_scan_file()
> doesn't seem worth it.
>
> Suggest:
>
> if (cur_progress)
>         *cur_progress =3D max(xas.xa_index - start, 1UL);
>
> Just keeps it simple, and handles the idx=3D0 case you mentioned as well.

Thank you for your suggestion, but two scenarios are still missing. For a
detailed explanation, please refer to the link below.

https://lore.kernel.org/linux-mm/20260123082232.16413-1-vernon2gm@gmail.com=
/T/#mc3969cb0d52e28ffea2fb96260f0880a5f005848

