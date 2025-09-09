Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D3ECAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D0B8E0005; Tue,  9 Sep 2025 12:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E098E0001; Tue,  9 Sep 2025 12:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5318E0005; Tue,  9 Sep 2025 12:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99A648E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:29:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60F50C06AA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:29:35 +0000 (UTC)
X-FDA: 83870247510.29.18E2C26
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62C3214000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:29:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyOFHoDT;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9QtIdHCJUCA2JKczntVa9IJYW4w3x9PZbG69hcS1lU=;
	b=sNvmYScZosWR2k06iIaUJyJ9MyAh16b0w6E3o4P6or86jAgAhkCMZfOdxBphNugCnuko0S
	MQAcEouOS21sJkdamSILVk+zabHgGUfZ47KMcFfaWs4yFTlboDcg/4ObByLP6D/ND8qeWT
	jXSUOrfY9s/okhXEJqdFJK0pXqRQxR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435373; a=rsa-sha256;
	cv=none;
	b=z+Z+p8dV5gMoaDTA89Dw705lZUzexIQMWTt88Gn29EF034TdSP1bSw5753N34EiNqFj4X0
	Ev/ET3xyhRVh6NQobCvV+JKABX4f+ddkIps5SO/ylb40GGnZr7cy6gBMblq96m0ZauVXzx
	94f+oI7HGM+2KtGcfVwrXenSDzkISqo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyOFHoDT;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so23a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757435372; x=1758040172; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9QtIdHCJUCA2JKczntVa9IJYW4w3x9PZbG69hcS1lU=;
        b=LyOFHoDTOUP4eRgCXWYASuN2svwMg8idHVe8E3hBgFP+bVzVIxWGeAf8eD/k+PaGcj
         EAfNGpzHCuVvEZIbkClGNQ1yMqU20vh2B5sFpaN7Ozch795Sa2/m8MUXcMcTg4wm56Fa
         0NVPT0NTh0oWKqEaYC5bSkDh9CT4TnJksqvoYRfnV1k4Lp7gubBYdf+DHBDM/k50XLFA
         Qoc0K4W9ndJMPKYPOuf0cdGYwAYTLSe7NObJqycC0kr4CDy59WP80Qpcixu/XFUfD8JT
         3jkb9S1oVsUbRHTHH24JzXg5hx3fJp9gfuhiPwQ0QMYj5X3OrzuJDM0+B029pU9+lJTe
         miZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435372; x=1758040172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9QtIdHCJUCA2JKczntVa9IJYW4w3x9PZbG69hcS1lU=;
        b=qTOWyIgcaS1mBhyLjv2vOLf1+GBfkZP8e6QpjllgvRDIwTOreT6ZSSDWDbQCLAyNuJ
         SQHyzDaQ03vLZSR2xiNo67wf1lba5rlJGRTH3lgi4Zm8gD2amTG2AsdWGtRTO/PNiGYC
         46R3aY53fC833O+KpJJlZ+84H/gfgN49YWpDMhdf4L/KAYzlX2EDxkwtv3+T5iXgBWtZ
         gB372/Cy/vuhqL+fDoWQS8qOesxzcHEfHbhQsSeocRjV3xbpCkAltYjt1vENAvX6E2rt
         h1cyNses2uSp+/c2qO5Za7mRcWTqJhS0/QumXWtlYWe1g5s2oLPqCcx+a3PXyduCxt4s
         knyA==
X-Forwarded-Encrypted: i=1; AJvYcCVbn0PAkzaTS8pREY2dYT7ZV79Q8i++WduWKmIW+cSMKrubPXkTeHNsNohF4C/A8S83jM4xCYpHCg==@kvack.org
X-Gm-Message-State: AOJu0YzNa56Lp7G8ZH60rw7U1cEcCm4/HRgFiCbfRwbAHJH2qPhjuzU+
	xW7XO1r50PRC+cQWxl1Ka6+VKVU8fcjML+gv6HTBzV454xx1BmjT7qr2mfrQ257KI4EFnf5iKUC
	F8Eyl+LB/tc8fc7Hcapot3IUZDicBk0myzjelr+u/
X-Gm-Gg: ASbGncsBT4nn9TSA7EHVgnNwz9BzVu8CxNZ8hamTdALHc82Psfhmr/nqjTfLhFzXlzu
	wUWxmulReSPzY7Yf99yyd8bkfFdPQOs0g2WofXwoS6IM6ot0bjpmG8sbvoywiWTzGsGUPQo9OtL
	rFls1KcP50oPPKE7wbBuGbsvad51dFWqhpgeIgZpr2fgTVXlZU4oB2YuqHlWBRrYSuWsfQYDQGx
	y3T4oLpFy0je3AePqWgKWEmSuF7Q3DPa1r3T9ucYsz2
X-Google-Smtp-Source: AGHT+IEZR0ggMbAaCS/pzuxrCrwK8WEzlmOxK64na+KYxM4rF7an2S8xhVcBEwF2bYBe42b+GcnA0H0ZoT7PNYRUAek=
X-Received: by 2002:a50:ccdb:0:b0:61c:1dbc:67a with SMTP id
 4fb4d7f45d1cf-623d4bf0798mr239582a12.3.1757435371609; Tue, 09 Sep 2025
 09:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250909090659.26400-1-zhongjinji@honor.com> <20250909090659.26400-4-zhongjinji@honor.com>
In-Reply-To: <20250909090659.26400-4-zhongjinji@honor.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:29:18 -0700
X-Gm-Features: AS18NWCZpqRQFgOViNXjblOghswTXc_q2re1TtWPGuwM3l9i6O4APd0wr9oM6UY
Message-ID: <CAJuCfpHVzRtUQukO0kZP072vCu89DwOEAocS571b4sGxMc6Zow@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tglx@linutronix.de, liam.howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org, 
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62C3214000D
X-Stat-Signature: 4ambzpusmebe7snazh6q94o77ecxyxw9
X-Rspam-User: 
X-HE-Tag: 1757435373-893888
X-HE-Meta: U2FsdGVkX197AjIm3As9iQNqf2ZRU2bxv+TOEoOHG0RZStzBcJC1oR3ssghZNM8xCAzcpMI8XG/fSQJYmpAw6UCt25n0UorrsSfMEOjlSq65u5AfcowOP1KCgdU7mbZijCdhIyzpR7K42YBhgKyO+oR+/0cNCE0ozoKxf+mO8wjdZfEqtyblKOCtOe+DECALVEG+O3neg8x8ibaZaxqfW0QNw19uUZc/tDGDkC3xvXp3NsGYrEl+Qfp4HhC2/k7xpVk0OyPSBODdFiGkG3ZWjfJKd/37JqPfvxw9SyXWsBdLS0vV+x4PfGp32jpIPQZHcpp3Z97qwBTVFPO+0nyFO+ATqj6M4nHWjTc2Yq/t/u2fHnsTRCA9aJOYGSHKNJotDrEEhdFur1j/nUCljHYXCLNsIE3hrADHArgNEl5WbzWS8wkMRrEVx8FhXU31yWAHaPS/67dRBRYZcYNyRC2tnGfJH/gUWAPqnhWsKLWK2hApkcIpPVeBfDTrUs2UCRhqnqGtwh1aGew8U/xUjh6KSl1XsvecaQQqv3sTpWckb7zRByH08I8xYiKgmhHYbceIvHHtxyxvLl9jw3j4b3CFGM3lzEHDaEES7f+c7uHVu3SRikvmFrUaZ+TLqKUIunDRTc8dhZ9091tvHa6KlbSAP5nx6YlHIzWhMwcAddhQEPjUCUG5IAedw5eIu4bZ6IO/PDDMf5dCKYYfhl08ldjycTSGC3acAcHs5qu4M3rho71u85+taO83GUh5ebBK+MuOE55ThG9JQG6yfmBXoamOcP21xN/AhO/Gq6tUS/tvyKrRgx+ZzoNG9lFROVE7RFuCVm0oPtpQdn8DIZij8H6qFTflIJgOhrpzHy9je+yu4hA5izH9YPL4j3ptEtub/RtLqBlk2WZOkJ9mxBefSa3fC4+qdw+1RZSUpUFQZdArnjnFHCTPAfOFjQWeDiRN8Ot/OFMEOadQPKsOnRIpItv
 sKadjC75
 F1HJv3v76vT27Cr8qm81TaQrLLRBaaExiX8zUNnCqxEQz5UYx3uZ9powHCn27f6ISjKLsfHmngMZz8wrw88nX6gkMEtnlhFO9hIMkGljABEI8UzvUgMzdnYjSvcdYjCRVwFvKbSnai2pdE3l7f9DLeujw+a3tN9XqZd5ESLJacPyZaOPshHhyK5RyxpvZSEYRgemG0Mg4JXvKNcKNkCTLyjaGlDWc3KDGIcNPpMCW/Jv20FA6Mdpe6YCKKmQR0gNE6RL/iOiWXYRIxDq7X9s//pZB5y3JzehULRdqzFNim2c2iyeilrk4l2G6H8KaQnKTh3w5CsWw5mXirtUA61j+R/nsppQtA7Q709EvcbT8XkKeje7fJQcTfPdjSe+0Xogh+gBqAhE7jH42C6142vTlO2BOWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 2:07=E2=80=AFAM zhongjinji <zhongjinji@honor.com> wr=
ote:
>
> Although the oom_reaper is delayed and it gives the oom victim chance to
> clean up its address space this might take a while especially for
> processes with a large address space footprint. In those cases
> oom_reaper might start racing with the dying task and compete for shared
> resources - e.g. page table lock contention has been observed.
>
> Reduce those races by reaping the oom victim from the other end of the
> address space.
>
> It is also a significant improvement for process_mrelease(). When a proce=
ss
> is killed, process_mrelease is used to reap the killed process and often
> runs concurrently with the dying task. The test data shows that after
> applying the patch, lock contention is greatly reduced during the procedu=
re
> of reaping the killed process.
>
> The test is based on arm64.
>
> Without the patch:
> |--99.57%-- oom_reaper
> |    |--0.28%-- [hit in function]
> |    |--73.58%-- unmap_page_range
> |    |    |--8.67%-- [hit in function]
> |    |    |--41.59%-- __pte_offset_map_lock
> |    |    |--29.47%-- folio_remove_rmap_ptes
> |    |    |--16.11%-- tlb_flush_mmu
> |    |    |--1.66%-- folio_mark_accessed
> |    |    |--0.74%-- free_swap_and_cache_nr
> |    |    |--0.69%-- __tlb_remove_folio_pages
> |    |--19.94%-- tlb_finish_mmu
> |    |--3.21%-- folio_remove_rmap_ptes
> |    |--1.16%-- __tlb_remove_folio_pages
> |    |--1.16%-- folio_mark_accessed
> |    |--0.36%-- __pte_offset_map_lock
>
> With the patch:
> |--99.53%-- oom_reaper
> |    |--55.77%-- unmap_page_range
> |    |    |--20.49%-- [hit in function]
> |    |    |--58.30%-- folio_remove_rmap_ptes
> |    |    |--11.48%-- tlb_flush_mmu
> |    |    |--3.33%-- folio_mark_accessed
> |    |    |--2.65%-- __tlb_remove_folio_pages
> |    |    |--1.37%-- _raw_spin_lock
> |    |    |--0.68%-- __mod_lruvec_page_state
> |    |    |--0.51%-- __pte_offset_map_lock
> |    |--32.21%-- tlb_finish_mmu
> |    |--6.93%-- folio_remove_rmap_ptes
> |    |--1.90%-- __tlb_remove_folio_pages
> |    |--1.55%-- folio_mark_accessed
> |    |--0.69%-- __pte_offset_map_lock
>
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Suren Baghdsaryan <surenb@google.com>

> ---
>  mm/oom_kill.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index ffa50a1f0132..52d285da5ba4 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>         struct vm_area_struct *vma;
>         bool ret =3D true;
> -       VMA_ITERATOR(vmi, mm, 0);
> +       MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>
>         /*
>          * Tell all users of get_user/copy_from_user etc... that the cont=
ent
> @@ -526,7 +526,13 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>          */
>         set_bit(MMF_UNSTABLE, &mm->flags);
>
> -       for_each_vma(vmi, vma) {
> +       /*
> +        * It might start racing with the dying task and compete for shar=
ed
> +        * resources - e.g. page table lock contention has been observed.
> +        * Reduce those races by reaping the oom victim from the other en=
d
> +        * of the address space.
> +        */
> +       mas_for_each_rev(&mas, vma, 0) {
>                 if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>                         continue;
>
> --
> 2.17.1
>

