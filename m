Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF50C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 18:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E9D6B00F7; Thu, 16 Jul 2026 14:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0A06B00F8; Thu, 16 Jul 2026 14:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF516B00F9; Thu, 16 Jul 2026 14:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2016B00F7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:04:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AF3E402B8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 18:04:18 +0000 (UTC)
X-FDA: 84995414196.19.406517F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11FC540008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 18:04:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ewg2IhJ3;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784225056;
	b=JD0An+bY+2/VE4RG7rE+5jq6+pmoCv64h/1XhjawT/3kgyvzaZ/e79aircL7ovh5NLBIXH
	QrZMHITQdj5UIupdRU6FYJDKpvlbIG+9CRg0GkUKEIkvA0WowIU0c3E34NsFnpYM9hukeW
	guo9+yH1I/rHsoGYNpkxtaG4UFRs/lY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ewg2IhJ3;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784225056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77tHDlt+8tJnQcJXrmrz9A2sC4mcOMXwb04I269B9Ww=;
	b=YBlDCfafwN0j9vnlsVNdCd+mTAiOoJsj9aNDw5HH3KPCRXZ4cnpGV4EsiAyiM5JHCp66Yn
	qlTVNbibucVfycULfgdlYI7W+AHD0PwuoKDiyGrMB4kIyeQz1T31lCxKM7M5K1EyURx3Bd
	UMVMyjEiovlb2ssIzuOyUdZBqodEhBo=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493ae59eca6so19078655e9.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784225054; cv=none;
        d=google.com; s=arc-20260327;
        b=QYE/Bc3cIIVoVBjKDVgDUi1T2LPilpZa4D50rZIUf5qBJC6laN3PI9+anh6lt1IobI
         eYkIk8PAQxHxnhZi4DyzYBdXu3JZS4TUkNzj8QoWm+QgAUcUfStaiRWVGsvL495TohOg
         z+2otEam6k79b+oOx0ben6tA7RF83MKGS+yamNj9TLUXHeXuWGkuvCI8HWy7dCJZQcQ7
         argpG3o7X1uZfyR9H0e2HGKmqcl0EDOr4VikPrNHxAwoEXRKjvpRAp0YbSkgUm0QVSnA
         CW9W28L1h4jwerJyizBMc4ulIYhUJU/bFufoVDSlkY4sDLoTdnIW+fAdKYb5M+7Idm9O
         qy1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=77tHDlt+8tJnQcJXrmrz9A2sC4mcOMXwb04I269B9Ww=;
        fh=1HRhs/u317u+YxQqj828x6u13h/7Ts+ow9taA3FsQgc=;
        b=fTR3VMCSXL71PRHjCQm3YiUQTQj+a0fSyNpy0w+ri9oIJTN1/dUU9VSj/VUUEEowNB
         y9EBjt2rPbyhMyAunq6PBL+3KviY798OVWvTxT1TTTNcw3Ge3k37TcDAFDZ2cr0ONmk4
         hDrUCQ6O9lFdagDNXFU4JRKLy731FG1+6MO6QxwrvE3nQl/Y07MCx2J/1CgUtnyoK4hH
         nCRTURA08cUewWR4U6h7ExkdsuoJE3KZYe8zyW2ZTvAMsFjBppgHQEra7pTpHFIjNcj/
         tzxIKhBVbmW9DcJijU7BhNqzsff5GN62ei9BLRByqF/H9+jbItzgAoVLvcb8jipoJxpn
         pPKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784225054; x=1784829854; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=77tHDlt+8tJnQcJXrmrz9A2sC4mcOMXwb04I269B9Ww=;
        b=ewg2IhJ3e9WArvhbQrA+b8qkX2ShhIrfD/Ga1T2gdRW1NzAROeAlwSuPBu0omvti/i
         s43YkwI8fAXVsiW1lMMCuVCZb/jv/HIBfCyMbV0Jyl7tRLpzBQn6NOaxibaJzQGnh2DP
         XOcRO6Z8s5nPNc7mqIxvsmBY75HJQd0MhtNjbIahbi3OpQJEE61iF50spcziIue9Ar9L
         dSSyp9psHoRTaHwxn3Z5jZnhGTK4YexHMPjf7HAdsw34+tlf6WbK1T9CTTQsKVaxHRh3
         sqFiBWtM0FRnBehz2V3GKG7u+x+IPoZ7+tHFmupzZqfyQiK0T7QcwVvCpxLa3eZFSwqh
         v22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784225054; x=1784829854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=77tHDlt+8tJnQcJXrmrz9A2sC4mcOMXwb04I269B9Ww=;
        b=BiPWX9qSdGz0aQFthYqLkhVRSn+q8ZSfWCiZbfz3vfNbO8THRzJa015+gztvdyCsD3
         r9f4zYFROEeG9QggO+6LxY9PoqaJQ1AFnW0DwtQM9dHUgHRkqfB3zOmkR72UMmkVMP8z
         MLHBLCSgTgWId7MqxDAhu8aIspOdfQxJnQRDUa1hKg9QK4ShLfQWMb5nhKAYy5fKlwm3
         jLKQCJ13W9lgWBc1oB9d/vmT2qy1NXQUFbBrwiF4ZETn0XvP+TMsHYMspoP9LtxIunys
         dY1/UGCxajVx+L3jZWaY5Ugcxv7jWJC/8c3GRDOLV6BgvNCn8/USuRDxpViZQLO20WMG
         RgcQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbIzNLR9c2OiUbjiPNG7HH/uzyd+YERl2AMCJSF1G28FepZX6Sr2kmrVLD88QDOMwZXwwiUAbE9w==@kvack.org
X-Gm-Message-State: AOJu0Yx7IZ1fRQSarVmMO1vbEaBwzoE5YoiQTGm/pDnZtAAGtOTv19DO
	iwYCZdcrRbXc8Wn+XoVycF0BVbqqHJrKA0viRCONLkvryqGpYmn41rxLElPmlU5vvZCz3LgiaLA
	4GSR9JvZa4R/6mZmV5fPsTmm0kA0iA8w=
X-Gm-Gg: AfdE7cnte0YicdNLnPcqu0nHiE+3Uc8zaIr/gDvKa4HSkvjqcw9T3iW3G/va+NlG84o
	/ULSy0z+BoIwzKlXJlIoikcf2jsJ8DmKKyCbFkJ3xQG45KkzUgpr+jv9R9B6fGiGVi1zIY+g+cg
	FKZgsBRfosXlw2A0phzKWyl2cBLTZ3tMFXvEZzguiYicEoxVIDa8rzTykSR1pMAz2J0/1R6TqL4
	gt3+7x/Hlikd4K1nzGJQ/1ZtqEOKvA9ywS/HDAa0rX4DGe3h+P0Fi45kqkKwGF27GZf5nNt9SRo
	9e2Ec7fH4lgH9ZAUJppVOHC6FDDkbYTIxA==
X-Received: by 2002:a7b:c042:0:b0:493:df5d:6ca6 with SMTP id
 5b1f17b1804b1-495483be428mr3111725e9.25.1784225054291; Thu, 16 Jul 2026
 11:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com> <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
 <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com> <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
 <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com>
In-Reply-To: <b910e870-9583-a2f5-b681-e69edb9af290@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 16 Jul 2026 11:04:02 -0700
X-Gm-Features: AUfX_mzsZSO0qoILpPdSsgOGYm9EmmbkyLHIWDWjIDJN1Fs37o-23mqOd14RmEM
Message-ID: <CAKEwX=Mdi5au5aXWdx3C7d1N4_3o2uiJh2sZ=sf6kpKAdtD1zQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11FC540008
X-Stat-Signature: xo9f8hiy6s6cdtx6xqfgs1aoywzkoyo6
X-HE-Tag: 1784225055-702257
X-HE-Meta: U2FsdGVkX1/6A6agRsRRP2AuCSFoW/lN/8VVE/ivE36N6zueOOkyrBW7jvU0XM2XfA0rWe3kHFTaj16ab4nkcJFuj0OFDJAExg7eDZKZbqO8G7RIvXXfRjcEo2QhjNhwLuBx+9J0FFxcRMOeT4fEcfIKR7wFA51H4zLXUcWKnPv+0d/6jDg3EKDRxqvdP54cFciVdP83Ja5mPaqC9yZYH/xl9PP8XlSXet3Js+0vqTSZtPiCrILelKsNnJt1bzTHd67qx4EVk17N4NNxrtyKPpMgWKJzdpRUF3oZ0oFRaWO/aA5vAMcHk9ohwYiFgP0QcTVy1gmvBdvMczxhZjLjvL22pks9BoaraZyStz5TDawiOgSSkYwKV4s70s7Kpix/2FilRUbxzGtc3j8wlUgwy6jCEyUmsSzWmepxp6sVcI1tkmvTm3xywSLxGYc9bmHSJJL4vOqtn4UMnF5vjuLp/ZgrzH0XnO64xiFK9A0ocLSaSKpyBZHVlh3HMAL+DJ2wTRJw3/QdH0pHmcEeMz0pE0e2HsZccUKKty1jKzF+nyYWxC/fZWYblBh3oLzlx8EhNMj9At1+1kTNLURzPfrn7xLWg/Ie3szhP9myOsQ5qkNZEnEuWCC7FJyiAS9CTHqF33tN6qBT6I6A8egEqjzRkheLIfuABBJPGmotdzUy32L6/+h1DNzb/z98G7zjkKUtvE4xrxB5UYwrmtxlwcL6OduqYX5XSQZwomCuECwVbtzWuN9CQoWDlpF2ZYW0KvPjUuWBQYMNegPVKw8j2sD+86xfDcHPgaD58UyweVALWCyvbClxbFauVzhnX5aLMW7gD9Oj4qtblRF0q6qOl0QAItElhi5LDr38rmT2gDFWxOKDoGEzRVJuxF1Deb1+aWHWCPtxhHKSPRH8nUYcakv/8cQp9g0AmLtUnDBO3o/d7HSQEhApzVA4EGkC/LFHMF+ZekOInLDr16UNx6YS/4e
 J46HTBmK
 IYgPsxDhNKtKEtG7q37AYlkWsBbmcTrRh/ICBtcmsUkb2+ilsNS6kpJ71NivkU1gL44Wqi1SlWZ1bEW49xT57ix4UyTW0DJOibF4BeBP8S9jAy9XfZPRvYNY4LFfrM0O/IFsT51j1GDVERyl9WZzsJ4T/IwOTLllwLSSNtXWff3DOL9ZaiQwa7oCu5a0Qxb+bw+ePVbM9bhqhe8qDqRZ54G37JIGyApnq/pgJnFMGHOCszFW7FQuNEyiM7PBiT64Khc+lmkjbndH1I9YS1gqNtIIjw8ZnGzxicvyCdjVHAPPrvrHS9hlzURJF7leztEZLBoaRop78ek+HqvPLz6Ap9fnGVxUR5YW9NKBe/lpMIp/74bflk5VsLxUgLTfxePv2WQlT1xRil3s8LgXTcBV2uaeHq96Gi1G00qJZFwEFb/ej2mxsGGcaZyFBucfAwZAywFdQwA9/CRJj3rDRVbtqjT3aohyG8blh0WTJNY49+Km8/UnCDvoDtojahCMfKr7eaMiTL/J33C2ENMbHKJBvlzr8ST3PEVyjrCqoHkXE7mslyK0=
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

I mean, it helps your case no? :)

But nicely done. My understanding is, this batching of the global
shrinker reduces overall disk swap fallback, correct?

Other than Yosry's comment, the rest LGTM FWIW :) Thanks for fixing this, H=
ao!

