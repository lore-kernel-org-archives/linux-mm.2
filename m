Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD960C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330AF6B00A6; Tue,  5 Aug 2025 20:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E10F6B00A7; Tue,  5 Aug 2025 20:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0516B00A8; Tue,  5 Aug 2025 20:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C84C6B00A6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:03:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D26851DB1D1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:03:46 +0000 (UTC)
X-FDA: 83744384052.18.7DD047C
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38C2EA000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:03:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpG2udaw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754438625; a=rsa-sha256;
	cv=none;
	b=LGlVqZ0fxtw6jEDaQ7WJb4ILMEwYoqIlXujiS9k5waza5pjfxwZIM7rYlumjZ6UkwYosw3
	OCIHvvlgzR4fqROEBVqSwLRfn4dRfT44UeAoIUwFyKAnYQnxzX5ccu1TAtUEU3DHsSDmcD
	ekuBhRBM1GjMmpXleEZtbiS+ypYBkzE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpG2udaw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754438625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9Az5nMK8fbyPLQPVq6entSkBs9bBtBVFWXE9onhr3A=;
	b=uauLxtzMlDhwSc/149oRc113T8q2JUMItvf+qOK9oJumtxS2Vnyhnu1XqhF7V+/QdK1wfb
	p8meCfnzoZidzOX6oCDDrFBLcp+cER/o0kgjZe2ZqMzGi8qShka5FHeWsMp+A/2bKtyOO4
	BjASPoa81c4zoLMvSuZflzNpc6LBJnc=
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e3f378ea68so42589095ab.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 17:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754438624; x=1755043424; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9Az5nMK8fbyPLQPVq6entSkBs9bBtBVFWXE9onhr3A=;
        b=IpG2udawrYUH4Q8zC/kF32tEQMWTcpmIOlqHfSVf7BczxbQ70rzdlTgDNdxFTzzLsr
         F8V/OpgaPirKWHBZaxDC1kgyghFkR4tbam0fh7Xq8tU+Uhsp9OVehCFmXqUqpVNehiHK
         dtpgFCkjKsxSW4Rh0MtZfAXvtI/IkTEj8fwdFUFbwWKI8G5WoUxLu0BSFWwNbGKGHMKj
         w9+a7B4iaqEcQgST9KmSfQrOd9yUANHLouUJwm3G4JEuDUE76VBNJp0S6k6qrDQM16cM
         o6uNMxzITbLdM150jeAqVHtE/42N9sTSJO+SNXrwQ2o2nvEPUpYOKJxw7uEqJrXBhxzf
         NVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754438624; x=1755043424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9Az5nMK8fbyPLQPVq6entSkBs9bBtBVFWXE9onhr3A=;
        b=V2kVQ5K5YRrJqcPpfoxQaQT0G1DayopZxeyh+deQNu/ka/4a5UL7yOtcRt336NAnZk
         8FDBDAo9tgPZ31eJcLYJq+xmpzRsF1NBpNNhAQRujVwTNK3303IG2TrxqCfEe/LAhlGF
         7ETvrMHogNjvIAjJ1qQ0uTF3HK22vDaZ06m8tOcxuh8IQbl4sELrVkNjY9is7boWxLks
         5A44Mb+F2VRDc0zPlEj6H/st/TBjHdD6n8Zw1WYeTSVycqtr97Yt4ywIE7lRPC+Qlfre
         CWBhJ+S1tmXWCWOnrCYhJREmSG1Y0uLNQC1PWuqr11CXjstUXVToDiTCUCZh+ivBAqPE
         TrEQ==
X-Gm-Message-State: AOJu0YzsE4WujJajiEaofbO5NJVx63epiPPly0YE0YG8cTPRGtQbUAV/
	4jxbVXc8/oFZmYoDk0IkVstTdnXJcCv1Qr/rEeCh1KhRC96ld0ZT4UHhuSEjVLm8IWvM165XV42
	oG2NZl+4i41XF/yUgC1VaFIX92kZaHMk=
X-Gm-Gg: ASbGncvG03tCkwNwMnvo7CcX7heNHSHMTxOANygDAm1yasACLtEjplSRBY0vaPYRqOD
	y+8wCKRkztHzS+MIu0PjRH6jyGIwIAtzT4/d/DutgS2vNDqdTdXUzoJNTK73S6Fbp3Nfzvyo1+5
	m2InJo8knwYf9KVjs0AV605o+TVZxg0ObDAvCJl77kXHRb03ilXguf34uIq+x3Rr2umYU+XucyE
	UQqOH8siZLVkXj13IguhYY=
X-Google-Smtp-Source: AGHT+IH4/jj76l3ofQECGaPWCFATYwMGPMeaqkfQQVMXyZcr9rWEy+uXsODNIG0ouW7aTNjLVw3SAVzKrkpnpXdH5rY=
X-Received: by 2002:a05:6e02:3193:b0:3e2:c5de:5fb with SMTP id
 e9e14a558f8ab-3e51b91907fmr11548015ab.18.1754438624092; Tue, 05 Aug 2025
 17:03:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com> <20250804172439.2331-3-ryncsn@gmail.com>
In-Reply-To: <20250804172439.2331-3-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 5 Aug 2025 17:03:33 -0700
X-Gm-Features: Ac12FXy864CCrnwXvvUn6b07bRzjYU7wFBiXElgxTmW8DadL4kPHfdqHucJZ40o
Message-ID: <CAKEwX=PkJdz3Um9j4m2bPahN9NbQpn7QnOvEAxDdWUHTqSvchg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm, swap: prefer nonfull over free clusters
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38C2EA000A
X-Stat-Signature: pafyp7w96z4nupjg4k7pzcpushqhnngb
X-Rspam-User: 
X-HE-Tag: 1754438625-367949
X-HE-Meta: U2FsdGVkX18qHMjkc8xE4lXJgOSrlN0ik1Ad6p//El92Y5Zt++VPCUc76pcsyZ2lMuqAqsysnZVBWn3/ejfYjbBBbXn1ANBMESctZWTe1f5Wmll/Dgme0AlASyb6KkqspXrBD4hw5seR0w14S6VJZFL/4oCiNPfiZIkBcuVlnXGa6wDyssgRORGBH5tKeXZhhQnhI/HZ50ZpHwxvs714SxZkhbdXnA9fGvwsQoumTTWosfidt2a484SgsTPosaCBHsXmGbTOwO7PCKZD2mn4TJzxsC2WnY13+bYOWSuQj5gn0ZM1Er/x3Sogq4rAZa8WvzwzeHBNJDSqnX56Sm1M9K7vlsVUhvs6SysNtFZddduLWK850dT8aWC7ldLpBcdXVOIIb7OZF7H6uGhtPp3BjtiLJJr9Ol0mTAnWYsEd4pWcrs6d36dH8a3P+zUm02wmxVZ84DVIDX1wG9Qe+Whwx/eEYyIsGxYiBZB9VSky4zP4ikZmLViYfIR8sv5JKpv5pSSAcVfsoT6lnQTYIn+sLB15MJNtjHci5yWm5VgCf0LXQOGtOymlVdoFQPwjEn/14vbMaXpGjlUJooVtmbk7hCQAiErqpL4z3UJcD33rAabZDhiNIMoomWGPiz0R0P+/hpKRcvPbQsaRaRcPe2O+SF0S9E0islOMEsV2jM7dPjfqqYD/fZxaM/cc1vBdjLic2f+tyHS6PsAFHZM9o2z5FDwab1Bkw/QM0u7pL986UxmkDU/e3Wx5Wge9S84UecexTaoijt1ymKsgslGJol1e+lryIuR7SvjX+Z02kRcBicBPiSorDFsi4ruQrOMfaLEPKFqw12c/gtGpbXTMNt7tBAsydvv9m/kp/EgZhvagcQn2TglgYLq0SFjuK3R8hOFgxVt+Tp2HwBvCE1v7uMor0i9UYkgjIX6oZNqEe3WiiFS5QpUC3nIikJZsJLnSC9ZIY7UUWHsfV7abEaUs6dj
 sa7OZqA5
 /JJL0sviZPsxsuRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 10:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> We prefer a free cluster over a nonfull cluster whenever a CPU local
> cluster is drained to respect the SSD discard behavior [1]. It's not
> a best practice for non-discarding devices. And this is causing a
> chigher fragmentation rate.
>
> So for a non-discarding device, prefer nonfull over free clusters. This
> reduces the fragmentation issue by a lot.
>
> Testing with make -j96, defconfig, using 64k mTHP, 8G ZRAM:
>
> Before: sys time: 6121.0s  64kB/swpout: 1638155  64kB/swpout_fallback: 18=
9562
> After:  sys time: 6145.3s  64kB/swpout: 1761110  64kB/swpout_fallback: 66=
071
>
> Testing with make -j96, defconfig, using 64k mTHP, 10G ZRAM:
>
> Before: sys time 5527.9s  64kB/swpout: 1789358  64kB/swpout_fallback: 178=
13
> After:  sys time 5538.3s  64kB/swpout: 1813133  64kB/swpout_fallback: 0
>
> Performance is basically unchanged, and the large allocation failure rate
> is lower. Enabling all mTHP sizes showed a more significant result:
>
> Using the same test setup with 10G ZRAM and enabling all mTHP sizes:
>
> 128kB swap failure rate:
> Before: swpout:449548 swpout_fallback:55894
> After:  swpout:497519 swpout_fallback:3204
>
> 256kB swap failure rate:
> Before: swpout:63938  swpout_fallback:2154
> After:  swpout:65698  swpout_fallback:324
>
> 512kB swap failure rate:
> Before: swpout:11971  swpout_fallback:2218
> After:  swpout:14606  swpout_fallback:4
>
> 2M swap failure rate:
> Before: swpout:12     swpout_fallback:1578
> After:  swpout:1253   swpout_fallback:15
>
> The success rate of large allocations is much higher.
>
> Link: https://lore.kernel.org/linux-mm/87v8242vng.fsf@yhuang6-desk2.ccr.c=
orp.intel.com/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>

Nice! I agree with Chris' analysis too. It's less of a problem for
vswap (because there's no physical/SSD implication over there), but
this patch makes sense in the context of swapfile allocator.

FWIW:
Reviewed-by: Nhat Pham <nphamcs@gmail.com>

> ---
>  mm/swapfile.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5fdb3cb2b8b7..4a0cf4fb348d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -908,18 +908,20 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>         }
>
>  new_cluster:
> -       ci =3D isolate_lock_cluster(si, &si->free_clusters);
> -       if (ci) {
> -               found =3D alloc_swap_scan_cluster(si, ci, cluster_offset(=
si, ci),
> -                                               order, usage);
> -               if (found)
> -                       goto done;
> +       /*
> +        * If the device need discard, prefer new cluster over nonfull
> +        * to spread out the writes.
> +        */
> +       if (si->flags & SWP_PAGE_DISCARD) {
> +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> +               if (ci) {
> +                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> +                                                       order, usage);
> +                       if (found)
> +                               goto done;
> +               }
>         }
>
> -       /* Try reclaim from full clusters if free clusters list is draine=
d */
> -       if (vm_swap_full())
> -               swap_reclaim_full_clusters(si, false);
> -
>         if (order < PMD_ORDER) {
>                 while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[order]))) {
>                         found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> @@ -927,7 +929,23 @@ static unsigned long cluster_alloc_swap_entry(struct=
 swap_info_struct *si, int o
>                         if (found)
>                                 goto done;
>                 }
> +       }
>
> +       if (!(si->flags & SWP_PAGE_DISCARD)) {
> +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> +               if (ci) {
> +                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> +                                                       order, usage);
> +                       if (found)
> +                               goto done;
> +               }
> +       }

Seems like this pattern is repeated a couple of places -
isolate_lock_cluster from one of the lists, and if successful, then
try to allocate (alloc_swap_scan_cluster) from it.

Might be refactorable in a future clean up patch.

