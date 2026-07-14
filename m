Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9580C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 16:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D0A6B00D6; Tue, 14 Jul 2026 12:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5EB6B00DA; Tue, 14 Jul 2026 12:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95516B00DE; Tue, 14 Jul 2026 12:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9719E6B00D6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:53:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BD9216043A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:53:15 +0000 (UTC)
X-FDA: 84987977550.27.123FC83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 514AE40009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:53:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8C2R35o;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784047993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GuTTRWvyCne6K/TMPuZlWhgMIx0adVHAqSG19V+XXw=;
	b=icqXSbZlNFE0v1iZTL3gHKp+7d2Le++t+QFgk50dQ9d6K6o0vT1R2TztL+uW+J3Pyahoaf
	4xyz9Q3lifcfF1VGbDPa1sByMVkbPRqQtT2pPYt1lsph3Vk3NCCXdVFhyS3Mfoise7c+yi
	2qkkFg4deXS8H6QmP2Nvfh9CFgUqyhY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8C2R35o;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784047993;
	b=cOkGNNr8eqIyUgKuZ0nkcPE1oZiorjGNVre4peOwQ3u/lNwGS812apDQK2eQbyCnc9bPbs
	3j57m1PV4uFfw2OcRsFcFgu4BZtMjyY9VAiYZbSjSO60iBRQJ5ZyrkLHGaoRa+ea+G0dYF
	zDP7isn3OO7HjKw48djaN3X7JJUhMtY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB15160254
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A7E1F00A3F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784047992;
	bh=0GuTTRWvyCne6K/TMPuZlWhgMIx0adVHAqSG19V+XXw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W8C2R35o/I1X5fPhJO9ImuwUaHrliG8WoQRrIrsHHP4d1xxjszyvgMZi2CiFMypDn
	 uoN3tI+ojAif5C21kFnBwncWcXpTiI7KPsUfIgW6T108T0FTvUlrkqToyUX1LH+q6m
	 Wbbt2qPDYd76RKnyIBH+ReHj+2xasBqZAkwiH1tBsHjEO3oysgzORSsjibaQJH4zGq
	 LxM8U53HTEsaopQ+3EIXviGDjsK6JFEHg+x/w/+24Tw2g68cYfSCabaVhWzhSzr0tQ
	 168cUo75DXafH+UqJ/UJdHSvxrCoNu+ToDYsf4RhSx2v+HLQu2zSJftwhhRfkP0CXB
	 hnajdki9ChO7w==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698ab9aae16so2266261a12.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:53:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpUNZFUYmpmu73cw4rvZd1fPgttslulIi8vLfiCs7maYYsxIss+xDoKx6xDCC5w1ov+zkZlWBbj+w==@kvack.org
X-Gm-Message-State: AOJu0YxUBJIoc2ErZIwPJOJUeGFuiUQVnAJc8BTJchV+fVWpWFkkEHFs
	uD4uKwvWCXFL+W0A6ppMOnFFAWQzvx+GY+Xezv+vn4GGJorRd85t75131DwAUdj2DJMDOyydfqF
	GYukJnqxlJJoU8ylPrT8w7LZAZr95x40=
X-Received: by 2002:a17:906:f5a1:b0:c16:12ff:dc8b with SMTP id
 a640c23a62f3a-c161f3b58ecmr712408966b.54.1784047991521; Tue, 14 Jul 2026
 09:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com> <20260714081510.16895-2-jiahao.kernel@gmail.com>
In-Reply-To: <20260714081510.16895-2-jiahao.kernel@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 14 Jul 2026 09:52:59 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
X-Gm-Features: AUfX_myK2ScSuKb9Od0WSe9xHl83YPOH--7pRL1A1D1eWAOU3YMEEFq2p0-lNTY
Message-ID: <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
To: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 514AE40009
X-Stat-Signature: 8jkmhuafsa6xaif6qiztf5a6h8u61c6u
X-HE-Tag: 1784047993-750443
X-HE-Meta: U2FsdGVkX19Aq36dLEk85FtNrXpJy55mdzl5Djv8LTAVJHr87Q/VIMbUaPdVF26JzBouxPlvjI1ZCbxijhV44ka9MHiVXwh59Nhe8un/15rnUD/Y1k0sC+8ff139yjdyu8bTsn88CyV4H4pzXLTCyT5Pbwt54TOyidEpj0XaLnX6vZ3zYG51DxDkKAUds3J2aPzGYyTmJp73bzq0nXlv+LM8WdkVApQRwvHv5h5XDhW6ee7G3xG2ViUgIAv2sy9xi4N/hVLR2LJay4BPCmXcaVGnVHPuHk8JeHllv5llH5y7r9nNZnSRu/ghjktNr4ljqgabkzXUwMTKC39XtmRXL+Ec7SyUzC+WFsqW2ubEvASFqEwktWCokw942r7yM/S78WPdoe0hOZnOUlusZw+uKHHyIlkurWglRLSIxx1eYRLLz5q6+curI6fmIZeqQQFxKLnqE+Otp1Y8rTeJTE4I1znb6uHpiBDzxZve9kXw9KzZDkNWNt66M7ber/U2uc5odQu52cAIrWuBhTbmb6O2ZRkRzh25HMSM25OMrgPDpGYskaXpfscqJqTA8d7syw3ok2UsuyeP7tSKxlFnGCbv+fK3yn//ZU4YslIhP+2eKt/Zn+o1ocKot1wrEp6xbjfJ5CBv/6kLcvVCRGzvYPG+MbfdDWae3qRwjTMfrcQhsHC4mbOYLnDAdkUdoGoN54YjRfVmp0VENosT7i//BtCv5YyWBJ8zv7nTMbIy3YjAIe7imp4Das4MHShquZCQDBMValx53ZDeFTTmpDJfGjRusADnj7o26KD9Xs7X7Bi4SWjphnUGuQdp+ToATOK55ulJ/1mRtVw9Lbs+1abEVdm9ZFVWyV7Gy+3xX3ROv/6RfWYwS3RO1kage7s5ITejbLANR8UCTl6hOEUe6tcwoIgiqSL9zwZF5bI01Skui81cU9i/GT0R4Jhnb5Vt9TF6JY/VqmOKNvUUUtzikqA4TP5
 h2Ff/Oq2
 SCBZ7UFUEyN53Pebk8l+v3RFzdKLB4mnd62v9Sqj3wHR6r+RN6xWjwF3tKE3Ivtq7uAEolxEafFrxCGkkJqRetTiwRiJdXc0+6aus7ja/waFxVIG6aO4T3MV9lhsSMKDLZitdAYald/bRoGBV0/th2IxbAOTIoG7Gd8k/yGaJ7oy0+cOZIScBSweXEriy8/M24JWOSfk7ZdnINXWHkrtzsiemkAPSu2ozYDjJDQ1+gVc/0HsHyzfIO0bZbdibkhr2wqvqXB4LbLEXhNqkCQYT48S53lAtzGGN+Msq8wk/KrVG6DaLCG5g6fk/8OHnABUqnp1pCrEonN1L+643w75mX/AjIwpAJNZw/0h5NrH02jrHPx4KtY/CT4GV9m9e7eVSa+9LU6imE/6HiZTUqt/vvFNJU4mNzSSacLizNFNajlJXbZWKoRn5DaB93CuibG+2XvrbCom3UORiRZgUmrVBw2PBeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 1:15=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
> Therefore, the global shrinker shrink_worker() always takes the !memcg
> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up=
,
> so it fails to write back anything.
>
> Therefore, when memory cgroup is disabled, fall through with the !memcg
> branch and shrink the root memcg directly.
>
> With memcg disabled, shrink_memcg() only returns -ENOENT when the root
> LRU is empty, which means the total pages are already below thr. The
> loop then safely bails out via the zswap_total_pages() <=3D thr check.
> For any other return value from shrink_memcg(), the loop is guaranteed
> to terminate, either after MAX_RECLAIM_RETRIES failures or once the
> threshold is met.
>
> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> Cc: stable@vger.kernel.org
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Reported-by: Yosry Ahmed <yosry@kernel.org>
> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeL=
c=3DeyTPKPVQgX4g@mail.gmail.com
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>

Patch 2 doesn't really depend on this one, right?

If that's the case I think this can (and should be) picked up
separately as a hotfix. Andrew, WDYT?

> ---
>  mm/zswap.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index b5a17ea20237..3d697a1a5365 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_struct *w)
>                 } while (memcg && !mem_cgroup_tryget_online(memcg));
>                 spin_unlock(&zswap_shrink_lock);
>
> -               if (!memcg) {
> -                       /*
> -                        * Continue shrinking without incrementing failur=
es if
> -                        * we found candidate memcgs in the last tree wal=
k.
> -                        */
> +               /*
> +                * A NULL memcg ends a full hierarchy pass (except when m=
emcg is
> +                * disabled, where it is always NULL: fall through to the=
 root LRU).
> +                * Count a failure only if the last pass found no candida=
tes.
> +                */
> +               if (!memcg && !mem_cgroup_disabled()) {
>                         if (!attempts && ++failures =3D=3D MAX_RECLAIM_RE=
TRIES)
>                                 break;
>
> --
> 2.34.1
>

