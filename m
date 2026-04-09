Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57309E98FC2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F08D6B0088; Thu,  9 Apr 2026 02:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8696B008A; Thu,  9 Apr 2026 02:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905576B008C; Thu,  9 Apr 2026 02:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 771756B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:40:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1538CC19F6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:40:12 +0000 (UTC)
X-FDA: 84638067864.25.092FC37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D97040002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:40:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NSeu73gL;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775716810; a=rsa-sha256;
	cv=none;
	b=XB779JKXg3u8W4ickR+QEuAw/0MshG0vrmT7YdbYKClMA5EnTaQnHNgwm/IidisXPEpD3v
	GPTNmT83PDrOayGWVpqm2Rutp4Cb4B+GKTftLZNzOFNFqq2DicRjbFwYh/3Xf4c0otOA0+
	oOK7rLhU0XDBRNOY6i4sjnRTyQcoH4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775716810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3qs2WvXJCK1NjdZXLaap//2oG2muDn+xCN/vbSLBUg=;
	b=Qam0znc2YMvPAvKNURNFl0g3Ag9H+Kide61MAWuyYJnv7e0/t+/k0c6CqyP/1z3CT4xMkB
	+8L44Noef5hlwLX3h12c2TcWxCuVC+M2/Eia/LrSSBAa2B15QF2Q1K1VNFE+WdljSk7pDF
	qnWj87/DnckHcD8LkCzSiOZSdWl65ZI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NSeu73gL;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CAE8600AD
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C46C2BC9E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775716809;
	bh=m/KUgWQBVlYZqSEpIrfPXdjeYxunnzBiV9K29n98MBw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NSeu73gLsV/FduqgPghAhak11a9NsRfZS56QtPp67FsL1qCqA5K9LK2c6wl+eq+fG
	 gcDgO9t+rQk3KDjKjAEipsd8QgeJYWVnuBVPoD43cmOFGTP9PtHWq91cdkovqPj9vb
	 DtYdKOhaw64FpleUUOExnoEqCgpVU23ozaTQxi0M1ClbgSAXc3i1n7ssgf83OzUWLR
	 pDd/xyauohqNTi/f3armdSnZgzkHOGxLKvFh+gzoVowdMyBQq8AemxeiGFs557dOH/
	 0PUJUGl/sqrUpz1yWxsAlSr6jqJMyQRxJTk+BjxxyaxGQOWNtRa8LRQXZNornIbSJg
	 ay56Jh+fErLfQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cfc2d1fdbfso34748085a.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 23:40:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX6PVc7MlEvUHOcftmkdFHv8ffh8wQlR3iXP9cr45x3f6tGEjbV4BryR2jEdiITtAoaAh7j/qEfDg==@kvack.org
X-Gm-Message-State: AOJu0YwKVCbCOwZ+aDWhhkRvF1mboox3aSyQWdqlt4//it3MyCXUSV52
	efUmzEXz+ruYbqqqcyS5W5HkKWjRAFqaYZA8hcfIE/rrMRkt1UggvT4N0UAAPzoIXOG+w1MeaYX
	UnvZfztP/O+k90rzpon6ZCkwFJwJUkSQ=
X-Received: by 2002:a05:6214:4842:b0:8a6:efd8:9b30 with SMTP id
 6a1803df08f44-8a7024bb2d3mr359282286d6.6.1775716808293; Wed, 08 Apr 2026
 23:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260225223712.3685-1-21cnbao@gmail.com> <2558f7d82b9a482387960f45409e1b76@honor.com>
 <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com>
 <adfc0959cf294aa4ab71c60ee1e35720@honor.com> <CAGsJ_4xUA9MfzYbTdpGsLsWoRb5ORV=_Vi6-jDh6VC=guOdcbQ@mail.gmail.com>
 <d11be6d7aaf14d6e8542c5bfb56bb0c1@honor.com>
In-Reply-To: <d11be6d7aaf14d6e8542c5bfb56bb0c1@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 9 Apr 2026 14:39:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wqd6Lg8vba8oeHjZTmahOdROG6eb4+f1QmGUtOBK8g0A@mail.gmail.com>
X-Gm-Features: AQROBzBFFgXqKlv_o5ZR9dTKxNwA2xe_KZOUjC_6kA9NSmBmBHXczrpco-9bVqU
Message-ID: <CAGsJ_4wqd6Lg8vba8oeHjZTmahOdROG6eb4+f1QmGUtOBK8g0A@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
To: wangzicheng <wangzicheng@honor.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, wangtao <tao.wangtao@honor.com>, 
	liulu 00013167 <liulu.liu@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D97040002
X-Stat-Signature: emarfakq1ho91q7t6qtqes8zfxa4p3yf
X-HE-Tag: 1775716810-870829
X-HE-Meta: U2FsdGVkX1/JajCEIGpzH+aaeCk7L9g8Gf1tFCmxa79yS8Tnvw2i/a5CUie7rrYGRrCMb+2Q+5owmiWr273TWreL0r/IaJJDmYovXb+NF+1kFPrG4LUZkrJrhJbY7BaX02M8ytpRAVhe6qu/Uhr9S1HPmLAOF5fRuRiFrxpA+yETnjw17P2KvBJ/EzNo407QxOJVFK20QB7DyOu720mFTc0VGEgfuzAfPLlewARSVRmcuk/JU3OxGJF7dsEbzBszCvBRSpr6DJECSFXpwqnDB+pCpwQVcx3qD9Gu08YrJ/gRa8YdZ9/0nU9sne8ipnXm5sZBPRXn3o8T7rpDeTPJwgtjpdilslVZ0YMv3OlMSVoDdFtXt3CPU6Ep0ubb/JrKKzk6hJzurxjLtDELRgKmdM6VhpmI0Qx602n3MHGF4BXlrzup7Q+aBKKGbLfU8Ufyje8JjMftQNr4EmkKy6babAfmn+x/YlAo04prBZTbieKAqAnzsAnpAXNBJRqto5uUc1VRA3b0lUNLW9Tus6ITOg/NCh72WrwagN4qol5ZzEYSdmlTOgYznV3PmjVJzlZgfRto8agTyfejmNWbO5nivQRWRcIsnA/kz2w8O1ahpitK5RIWxIuaqSpeVlcf2yG5lfPMzMtGPkBrAVoaN6q+U5irZTg8x9neCXB+PUrfDJqMX6XrZN0EWhijgNU/DjcynZwaJRgy1KXhrX8auQRr8objZCE46UhcwncpMMQjH4tkBZj5c6Ng71wUa7EMBccOO3nj5cOG4APuv20j3a13iof3p6Va8xHPTMvo51CY5/Mekn5ivRzQUNMDSKUHwufX4tma4kZTdL43sokoUh1bNT9hVPvu1OrGGiO0qciF0d4e2bNLt+rhYGouzZ15SvR2zIN8PHZM8PRfe5IsV13SSEuDAlIGiC1Zrlu808sl6ywdPXuerz369WwOGqgf/oNq50ZgpJQfY1uBac6aJnc
 LgjXbBy0
 GL+DPy/Ixh798nrkUSmYpartPD/TpuFSNNrI9xAXXfktxSqvbe/4Z8jVTd9DCgTvJuNY6ssSZVKDyTk8nIeWd1iAp5WvTYgX0GHI5wOivTgxaJnlYWjr40prt1H9UekFaG4ZdrD2Uzx7j+Ebjj26sJ9vf2B7Yusxerv/Agr8BZum1lma0hVAHeF3Vjb2KDrvATVWb0r0eEY248ueA9/HsesWF4T2CxZ4aatsXQPK5CdAN5gvGPZmRBgxJBMcZl+rT5NYOS0Oq4DZ3xsaaVKdDknKvOwrsDiCcBsSRDGPHHCKSn2NmcDIW1RyGnwhmXUECHg2LwNjxq86Ls0o1cNtVwlmTi53GU7E/tCoC49SZiVWs0sNc2pXzJAg/Wapy7yPyMeWp6lQwkBa3p5opx4BmtuhWAbuj8S+xQyova/w9oDw1amE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 6:13=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
>
> Hi Barry,
>
> Thank you for the suggestion.
>
> I have re-designed the workload and get the relative promising results.
> The workload repeatedly launches and switches between 30 apps
> for 500 rounds. Since the test takes quite a long time, the final results
> appear relatively stable across runs.
>
> The testing was done on an Android 16 device with kernel 6.6.89,
> 8GB RAM, MGLRU enabled.
>
> However, the results are not very easy to interpret.
>
> Average number of kept-alive apps: =C2=B10.08 apps
> Average available memory (sampled after each app launch):
> baseline vs patched: 2216MB vs 2218MB (~2MB difference)
>
> Below is the vmstat comparison (patched vs baseline):
>
> Metric                       Change
> ---------------------------  --------
> pgpgin                       +2.06%
> pgpgout                      +3.10%
> pswpin                       +14.13%
> pswpout                      +4.55%
> pgfault                      -3.19%
> pgmajfault                   +12.75%
> workingset_refault_anon      +14.77%
> workingset_refault_file      +3.48%
> workingset_activate_anon     -3.45%
> workingset_activate_file     -17.76%
> workingset_restore_anon      -3.44%
> workingset_restore_file      -19.13%
>
> In v6.6, when PG_active is set, pages go to the youngest generation,
> while pages without PG_active go to the second oldest generation.
> ```
> static inline bool lru_gen_add_folio(
> ...
>               if (folio_test_active(folio))
>                 seq =3D lrugen->max_seq;
>         ...
>         else
>                 seq =3D lrugen->min_seq[type] + 1;
> ```
>
> My rough expectation was that the patch should make file pages more
> prone to reclaim and make file page hot/cold aging more accurate, so
> both file refault and anon refault might decrease. But here anon refault
> increases instead.
>
> I=E2=80=99m not sure if this assumption is correct. Could you share your =
thoughts
> on how to interpret these results?

Probably because readahead folios are soon mapped via
fault-around. Currently, the fault_around_pages value is quite
large.

There is an Android hook available for adjusting fault-around:

static inline bool should_fault_around(struct vm_fault *vmf)
{
        bool should_around =3D true;
        /* No ->map_pages?  No way to fault around... */
        if (!vmf->vma->vm_ops->map_pages)
                return false;

        if (uffd_disable_fault_around(vmf->vma))
                return false;

        trace_android_vh_should_fault_around(vmf, &should_around);
        if (!should_around)
                return false;

        /* A single page implies no faulting 'around' at all. */
        return fault_around_pages > 1;
}

If you reduce fault-around from 16 pages to 4 pages when
available memory falls below a certain threshold, you=E2=80=99ll see
this RFC deliver a significant improvement on low-memory
devices, such as 8=E2=80=AFGB phones.

But for mainline, we still need an approach that can be merged.

Traditional LRU relies on PTE scanning to activate folios,
while MGLRU assumes mapped folios should be activated.
However, fault-around may map folios that are not actually
needed. If we drop activation in map_pages, we miss future
opportunities to promote those folios at mapping time.

Best Regards
Barry

