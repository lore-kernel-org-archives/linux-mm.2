Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F70C44514
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 20:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679056B008C; Thu, 16 Jul 2026 16:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629646B00B9; Thu, 16 Jul 2026 16:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2936B00BA; Thu, 16 Jul 2026 16:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED55F6B008C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:35:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F8D71C0224
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:35:52 +0000 (UTC)
X-FDA: 84995796144.26.A36E465
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 95BA040004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:35:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=on85Wbbu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784234150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRWx41NRFgTecmM6KmOP+beLAPd4keVAZx1WV12sXws=;
	b=37MeTu4ExYMVfdt18NWVjYp4klL4Jdl2wgugMvnb5+9wJ3Dwed0/quioR9Ov8WD1KC4pj+
	z/kdrVwTOVZPxJFTX5/0xnfAcuzweYfPG076HUcQqGxz1JX1yCP5Be+EJzNVCkEckX/mGq
	9ONDrL84xrUzeVzGZa98Z2TWUe3PmF4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=on85Wbbu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784234150;
	b=RXL+25mXXljvhvVEjh/amaOB/8bmjkLkDmaAUjel8TKskDlNEJ6rLNVoPgsUciEdFPNzQ4
	/nSwFe5spbgpxwGz5BQSR6FkprZk2YToPCc1YtszyO6SJX3CoxI4Gr+1bS4lqvTY3ODjA8
	djORUHlnjWN8p6UaghF/KQR2mm3ujUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1C2D60A6B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DC41F00A3F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784234149;
	bh=VRWx41NRFgTecmM6KmOP+beLAPd4keVAZx1WV12sXws=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=on85WbbuidISrNOBZAzYZIuanG1MWPgiEexydexAg7nvc5+evnbEqJAvCIJa/QfAR
	 Op88aHpQzsmqNWHobMNCD+sCF0k0jpuSZqo2HZsDBjQiXeoUIK+nC1Uzj7fCEcz2ki
	 pDixRm4nsFYkYjUCP5ngH66fXjqBm49SL/HBU4EzA+IULRdO56Z2lDd1K/S7+w18GF
	 fKxop6AE2/FG3mrIP9I+Cc272GtbZST63shlT3fe7qtmvjC/e5RqnKsmk1jVZz89YX
	 wj6UZKB7LTBEIG/UXx9kCWzv66GMsQ7N2110COMKhBWLgr0M47fdkO6VAHFXH+tuoD
	 +ZWTkpXvupm5g==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1677c91969so299299966b.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:35:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr/A1g5GDAS5NPbYkD53vQpExi6ApIEDN0BEmtYxekmep+4p7r77M+dui8igeMi3b9MD1bWmntSsw==@kvack.org
X-Gm-Message-State: AOJu0Yx23izFCh+EEtTsEkBurYS89ciH1fFUgJLRhydcj10BZUFnGeyw
	zikAzcR85dtagCg2/QxZreJnIkOEnWq2WpvndaJriIbj+d3g9BZ7XFNkiqIs4dQ5PRkUsXK8caW
	Zr8xV6NpDjtiVMjKqvmpAvBjd7SqwxqI=
X-Received: by 2002:a17:907:3e05:b0:c16:aad4:2d55 with SMTP id
 a640c23a62f3a-c16aad43b3emr62858566b.3.1784234148367; Thu, 16 Jul 2026
 13:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com> <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
 <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com> <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
 <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com>
In-Reply-To: <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 16 Jul 2026 13:35:37 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMLGMpsQ+HbLA5SFSMEc_ctuZoScJMkybnXMp+_0MW-yQ@mail.gmail.com>
X-Gm-Features: AUfX_mwTGzvIQNQhF060UOLCh2zaMJh59HMirX7aHamE1mBFkxh5HCs1pt2xGHk
Message-ID: <CAO9r8zMLGMpsQ+HbLA5SFSMEc_ctuZoScJMkybnXMp+_0MW-yQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 95BA040004
X-Stat-Signature: fq3m3fqxffkewc54m9hbn18zpdk3ok9t
X-HE-Tag: 1784234150-3013
X-HE-Meta: U2FsdGVkX1/WnKlW23tfT9+sHj1oRqooct4OlObcncMSdDX+j9FDVghbiY1JbDAMi19fEvuY6EbsQURusJuOVPjQRtIAtlJ0EIswepHhnEb2NKQgLvn6hNUIqaHfleOS6CF277pt1REOdbulabAtOmTruNY3JQ5rNJxzEU8pjI3GfqsAC4/uyMsX8iUUHdSTuCUjsflWHqGlBHGVGuAcJv9MIRi6mzHFRD5Yt4IrGxfUJEnwCDFpdF2N0eykbb8YmfsfHHlY08BijZ8Y8zGuv8TdtitB5sMdnFmwGe8YgoQQxsjISOJSWyIAkblHlJ200t0j2akn+Gdyvx0SIt4bVD7fKrudDM3dQ/Zlamk4hsY0fG4rptrgU1MtWlqovKXlXnWMG+buTcSxIuXT2jwtsRJk1K9wh2wg69r9w0GJjINlRrNbn+03ERoIj7yDJFelUwzhI/hD7lWq1lgc32cfBuqRVJJrtjEs0S4S1KwJVWzCCA1e3Hwf87EaclJUdzitYVA65yjvaauN95/MhXf+e4x0jwY9rt84rFp2AChekWzcq3qGF2vU6/53Pm4/gAlthYpJZJESSOYMb5zDmjelJvyTAHJDXdCgtg+AVj4SHCVJIJTcEgqj03jI/PvwoGu4ECt8Had2lbGBs9isglZ+3/Ye+Dddmhnzd9E6NZQBaFzLN3ujzhR5crJPOk2EdmH0wX+P5m+mZz14HKgOD1D7v9Zxxj1NtaH1pyK7rmgc+C6Kw/i8A7z1zn70nmSAHpFoM4cyBrOzQ7nRTFLX58dbC1KwKHGEZ4rLB2jItyCnqLrxZMWEqiHz66fl4RIgUcqGawfpStwODtUx24U2i1e5vwFtc/pGZaeVfUBKQpA1nqyCfLB8YMjypkXhj5thSkU2q/xlcBBUbm6aQNWe54o9IfihPXC8atoQoVE9WIu5l0jW9hFUThvupNd/g4sPxdAMA/FxRxO6u0Z3dFY8eTL
 dUYCmqKC
 xb2lPke0Q+T5j6PQVSeXKOgWPrrsRGLLoiSA4DpyS24DGNKwtm8zGTHjVBFMjkNikPsJQD51Qx/CEXIDk1o+uQWG1OU+5lKnuQzmozldN7fNvjShpoZq7JCVniOY3p56dZKm6+/tQapllBCE39qzluO8R9PJDWabtCO1ym6z9V/OEXw6TkjhjZbogOTr7/yjWPD/wD1If8LP8WKSNCmp6y7CfHjpGzhUd4b3gv5xvP2O6pt+xstoWhN5dcBS/Z5mR5rD4TA+jK+9M/nNWciNrys9T/i7lO4pzMu1uZCPIWpqCTGnq+qbjIocQ/DJLw+p0prR2iN8JJPpwRnnuLEwEWGii8TUNPPtDFPcV7PvOx15U693LmWMK2qnzcMW3ne1ijekUllkpHMvW3TxIFBDAwEq7CQSAs+SU+KohMH/HEED4qf1mcMI/H9RcWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 7:54=E2=80=AFPM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/16 00:14, Yosry Ahmed wrote:
> >>>> Test Setup:
> >>>> Total memory: 32 GB.
> >>>> zswap settings: max_pool_percent=3D1, accept_threshold_percent=3D50,
> >>>> shrinker_enabled=3DN.
> >>>> Allocate 512MB of anonymous pages and fill them with random data (to=
 avoid
> >>>> compression), then use cgroup memory.reclaim to force a large amount=
 of
> >>>> anonymous pages into zswap. At an interval of 2ms, allocate a 4K ano=
nymous
> >>>> page where the first 4 bytes are random numbers and the rest are zer=
os, and
> >>>> then trigger a reclamation of this 4K anonymous page through cgroup
> >>>> memory.reclaim. When the pool threshold is reached, shrink_memcg() w=
ill
> >>>> be triggered.
> >>>>
> >>>> The test data after running for 120s is as follows:
> >>>>                              Baseline         Patched
> >>>> shrink_worker wakeups          5363             85
> >>>> shrink_memcg calls       11,345,012        188,264
> >>>> written_back                  40214          40275
> >>>>
> >>>> Conclusion:
> >>>> Under the same workload and run duration, the patched kernel shows a
> >>>> significant reduction in both shrink_worker wakeups and shrink_memcg=
 calls.
> >>>
> >>> Please also include data from the case where zswap store failures are
> >>> observed and pages go to disk, and compare before and after this
> >>> patch. I think that part is also really important.
> >>
> >> I retested and added some collected information. Perhaps
> >> `pool_limit_hit` and `pswpout` can explain that batch shrinking of zsw=
ap
> >> can reduce the number of pages that fail to be stored due to the pool
> >> limit, allowing zswap to skip zswap and go directly to disk.
> >
> > Oh I meant the other test case with high memory pressure where we saw
> > a lot more writeback with this patch. Do you have similar data from
> > that test case?
> >
>
> Below are the results from stress-ng (high memory pressure case), which
> lead to a similar conclusion:
>
>                                Baseline      Patched
> shrink_worker wakeups         5,640           987
> shrink_memcg calls        8,481,500     2,504,818
> written_back pages               260       768,576
> zswap_store calls           2,742,756     2,301,414
>    store succeeded (ret=3D1)     934,640     1,308,686
>    store rejected (ret=3D0)    1,808,116       992,728 <-
>    store reject rate            ~65%           ~43%
> pool_limit_hit delta        1,181,310       101,593 <-
> pswpout                     1,808,376     1,761,304
> pswpin                      4,288,497     3,902,658
>
>
> pswpout =3D store rejected + written_back pages
> Note that pswpout comprises two parts: the store rejected count (where
> we skip zswap and go directly to disk) and the number of pages written
> back by shrink_memcg().
>
> Therefore, we can directly leverage store rejected to evaluate the
> scenario where zswap is skipped and pages bypass it to disk. This
> provides a much clearer picture than looking at pswpout alone.
>
> Do we need to include both sets of test results along with the
> comparison data in the final commit message?

Yeah, I think you can include a summarized version of both sets of
results. I think the important part to highlight here is that batching
results in a great reduction in store rejection rate, which translates
to significantly more writeback, as the LRU ordering is maintained
more correctly. We are also doing a bit less swapping from disk
overall if I am reading this correctly, which means we are placing
less hot data on disk as expected.

It is a bit alarming that the store rejection rate is still 43% with
batching, but we can worry about this later :)

