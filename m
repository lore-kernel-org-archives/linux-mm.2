Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5062CC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584956B0296; Thu, 13 Aug 2026 07:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BE36B04B9; Thu, 13 Aug 2026 07:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4725C6B04BB; Thu, 13 Aug 2026 07:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2115D6B0296
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:25:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2EFEA01E2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:25:08 +0000 (UTC)
X-FDA: 85096014696.28.E66090C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD89140005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:25:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMiwcJFz;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786620306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUeFZ/rzaYnHTLRCJJTJr4rtfJES3QZuRtQt4YmtUsM=;
	b=20ogDEiWpnFxmN3MyU2MSwUdUGijghSBhgtBxKpefiMyBwqgDDOMi8qjRO2XJfNX81mvUn
	koeKV9qjTql5bZiaIEHE0eyHdS8wqvjGHzCmHiwzxcUWWwYxnM68fsrFa+3u4JsEcHaG8U
	n5T3KbfSZT9zPN9BEp12mka8zobkcnA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMiwcJFz;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786620306;
	b=PNPiw875RsGRArNPjJpE6YbINKphHdZ47qvUy23WXE5cwzTfKQBiYtuQsAcFWBubIeTmqa
	FyRmqQRbXgX2UJX6AQJ5gJs4j2/UHc4uzLpxSk+NnRX0ZPMx61CW3x3Kb+SSMWBvSi9K9H
	Y47VyYKlYw35p7ixMBjZ1TteDAidSic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD9434400B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FB31F00A3F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786620305;
	bh=bUeFZ/rzaYnHTLRCJJTJr4rtfJES3QZuRtQt4YmtUsM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TMiwcJFzKZBEvS9+CtWNmykkuhxl78+ZSi0hinDRxsV4FE5xHd50E4tMtmp0nwL8X
	 vI4PHX3jni5vKRBnBA/j/0HDikDYZiP1CP6C4+C5bBo+HApKHS3+dXycN5VtRCs84x
	 pi8j8sn/eDTHAx3ZiCFaBfksbRlTGMPyRKGNjbNm0udO6/C84AcJ7sSmRcKwaHxB2V
	 aW2WqUmry1N2zpfKvxaeZcT30QkUZyt5vzHitUL1cGnM56RUQYP1bRbuZOhlIoexnO
	 YSFO4bxkX46fgS4z5FIbupdJ80VTmpbHk6WVfnvQHB+8kMGhFUViV2/K1EGjLaqt8W
	 sJTqitN6ZvlRg==
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-52b6543169fso13115251cf.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:25:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp7Snt89pL1GcV8V1NQAJdW86oseVL8TIFX1A3TX1Gm96E1gvsK68Kh5G8pui5ahKHpjw0iPvBqmg==@kvack.org
X-Gm-Message-State: AOJu0Yy/8XLLOfdXxaHsMS6dKInbe0vsBZ9U6+E+pguhGbzhQyFSPS9Z
	NvMwdkMKSWNSOo05AtPsv4PLuDPumGijIHY4+fPqw3ZcGwcW195rs6qVVl0gDrPWbFTCjp4OyJl
	7R8othrdqhIh97Ad9hh7EnF1eqa6iJEo=
X-Received: by 2002:ac8:5715:0:b0:51e:4f6a:b9b8 with SMTP id
 d75a77b69052e-52d73c1e381mr45405011cf.1.1786620304846; Thu, 13 Aug 2026
 04:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260813110230.2124785-1-ridong.chen@linux.dev>
In-Reply-To: <20260813110230.2124785-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 13 Aug 2026 19:24:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xBQ1r7_rzmu7fBvuy6c3eZCW0Xq=puXtoiGf=JeVnjvA@mail.gmail.com>
X-Gm-Features: AUfX_mwRb8MxzC-0Q5A1JDcaD_Rw5HQLZO49eER21tnHFR5PPqGra_1qBsQ4Utw
Message-ID: <CAGsJ_4xBQ1r7_rzmu7fBvuy6c3eZCW0Xq=puXtoiGf=JeVnjvA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: preserve inactive placement when enabling MGLRU
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Brian Geffon <bgeffon@google.com>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Steven Barrett <steven@liquorix.net>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD89140005
X-Stat-Signature: 4ohs3ypcxu4bbcifjqncdjzdg699jr7p
X-Rspam-User: 
X-HE-Tag: 1786620306-356841
X-HE-Meta: U2FsdGVkX1++FH3Hjgs+A1TJ5JSA53xq+xGD2jpdSlUJ0/FBVBSczmF/cZy0NBmOPllJvE8dzqXonw3OQclqk/MDRvhUElrctp6KSKFcGhUojkK0HaYJOD2CZDC1/wxkQv09U3TxNDvufyF11LoP/xjxepTkuhUEuknlJkNXcgdMIziU8bEbusfp/gycuNakZaasP4uZi1hVeMnUJK4Ny+oFQ92Su/B30PPRnTRaGbUJG7IkvyfuQWjibITLZWLT2hV8JG/MlBdA0gowP4bgGoU4EdNt1v1rUlj7wV7UQvyePJ0VGSgZf5azdVaMnOMyxPhKERR8uQ053wSn3Ues2h7+46JBRu78lUzDAp84UfnK5+RTfHHtoyahhL4DAbjbX0LAA2JKJwGLIyH/6yuWehF1c5nxtHxPrTARpHXnOfez0Xd+dIgzGcmy8kuWDiodYtutpdOWArSxsP6UorhVffTDatb3ts63A5kmjxKr6tJddP87uHB1gkUG1uklHvgHcBVurMwJCsV30R+bTx1/6Rfvh/L/PJDFY9u6Cn2UK73JkzKBhQjfDxrznbFjCfwGuAPtmant4aHa5cH6zEP+tGZNeNXzln1KMaLhTOzlQf8FOGLx4VLUPgWH7WpEnVtL3ObClOdBR9alqQ0Sok7xzMJihKifcv4a78r2Cx4acczTAuUvRGaWxxAEfTtfVEw3Hwa2S5R2fW1+2zcgSKhGYZgbnI7vUzEFH7JFoI+rRFvaHiD1tpht6+RCQmKeVglru/SZ6tfJbe4yADaafAgu549ELH2mtIYtsfUkRPC6EuloEqYKqx4MDpDDzwrCOXJXcyLvOirgt8mx7WHNcSRuvhQBRK75XVC9sbVeilXrYZFyShk3CaMZYJo3Xf2n6PKow5yjLHZCJAX041LxgCya0lOlJvePSpO0InYvKXSgnRvAj5yoVUHnMUjyCrmTS2XLJkDNS4jRZexljP4RLZb
 ei1Bei3v
 71MJD8z3nc4XfiEZ/ZJKExCIq0KsE+HWu+HQs+mE4UATl2GITvqKRgPzeVCDThmdi5saYtGXBna19yBi073WCG5zzvWTlpCZdWOALiTjOfakjJfeVLUzXq+CAuMA16dHMAYcdlq9m4Il8p+ozroI1TDsQJBazv1ySX0mdHcqaYH0J9hRkdZT/Do5xI8HhRN7BQcnWW6dO0cDqVzlqfqettf6to2f7fHYPLdATT3MRb4AspOSifUKUt9zg8EPYGZOKDUVZLuzcrY+5ai+Q0UbEKEXSqJCz0IO8/nsm4CKRWADMmPJHQIcvlTLAuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 7:02=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
> enabled), fill_evictable() re-inserts every folio via
> lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
> inactive anonymous folio (no PG_active, not in the swapcache) takes the
> "gen =3D MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
> seq =3D max_seq - 1, which lru_gen_is_active() treats as active.  Its
> inactive placement is lost and NR_INACTIVE_ANON is folded into
> NR_ACTIVE_ANON.
>
> Pass reclaiming=3D!active so a folio from an inactive list is seeded into
> an older generation.  Folios from the active list carry PG_active and
> hit the first branch either way, so they are unchanged.
>
> Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
> the inactive list before enabling MGLRU:
>
>                          Active(anon)  Inactive(anon)
>   before switch (legacy)        2952         1548792   kB
>   after `echo y`, unpatched  1552052               0   kB
>   after `echo y`, patched      15144         1536636   kB
>
> Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
> preserved).
>
> Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 94fc4f25e99f..2befc8d7dd3f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5319,7 +5319,12 @@ static bool fill_evictable(struct lruvec *lruvec)
>                         VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D -=
1, folio);
>
>                         lruvec_del_folio(lruvec, folio);
> -                       success =3D lru_gen_add_folio(lruvec, folio, fals=
e);
> +                       /*
> +                        * Keep a folio from the inactive list inactive:
> +                        * pass reclaiming=3D!active so it is not seeded =
as
> +                        * active.  See lru_gen_folio_seq().
> +                        */
> +                       success =3D lru_gen_add_folio(lruvec, folio, !act=
ive);

This is a very interesting use of the reclaim argument, as it is not
intended to serve this MGLRU switch purpose. It is really only meant
for `folio_rotate_reclaimable()`.

However, the change itself seems to be *partially* correct and
*partially* wrong.

One real issue is that inactive is always placed in the oldest
generation, while we have two old generations. Maybe we can ignore
this for now.

but somehow, are we also inverting the cold/hot ordering in the
inactive list?

`lru_to_folio(head)` always takes the tail, but now we are putting the
tail before the head folios.

Because reclaim =3D=3D true will use list_add_tail().

if (reclaiming)
list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);


> VM_WARN_ON_ONCE(!success);
>
> if (!--remaining)
> --
> 2.34.1
>


Thanks
Barry

