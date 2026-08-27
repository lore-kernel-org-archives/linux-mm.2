Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB32C61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA856B0088; Wed, 26 Aug 2026 23:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49AAC6B008A; Wed, 26 Aug 2026 23:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C866B008C; Wed, 26 Aug 2026 23:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED13B6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:21:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B7B01602BA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:21:04 +0000 (UTC)
X-FDA: 85145598048.10.87EC515
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7576A40005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:21:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pdHkVXM3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787800862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPmrkgLMFyln5L0U9MxoTdvQW7FzvHOtKlle0J83sYM=;
	b=XJqQJx4ZfwoS57jyC1o2skJDMXy8Z0tvUe3Z3cq185S2/2/rAoYTcpLMlJB5kQxqtsQHKY
	58j5xcbM5TLegJsPICRmOLvovSxFn6CcbODjMMbx9nZbEuHtCgJT5jIA32w6FveTRS54ez
	DQ5ULAS+XQpS9LJqk4KYqa6n0/zDiEs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787800862;
	b=GjFurARpSwX1DXSFWeh7pz20PnJ1lpynjJs8PXG3gJP6lAwYQ1UzKX5Hz388eL8bHOFupk
	DNr66GeIWfsMyMB0+WTGxcpsHoWK0b0dPHsT47dVrWH840ODvLhBX3lQ+xEy6gx8r/KR5o
	bCcs6CWKjyzaVz6ISTbRuIx4NnSuLH0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pdHkVXM3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a38098734bso294357a12.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:21:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787800861; cv=none;
        d=google.com; s=arc-20260327;
        b=Xum4EWokfm8s2MgknGzIiEXjdtM08g7l/zkA7eJq4Q6qRMwaa+akgDQcPV1Uodi+W1
         nheuyLzKgO4YYf/bcLID3rKTcUV88IuQ7vxjTWXnS2O606BiEaWWtuAHWsrGCWM9/Wgk
         Gt0cTyvlm7EZKzJ92yhrdhZf5QrwUHXNeVljJ4gf5VkNA4RanCXP4UrPIh3FBfDptZ5I
         YjZgu57vyH97L1bgBED8vKhmKd5juyWRN6fTh0S5jb3ew4zw6mnly/6XZMCRHaHZvRab
         30Zpw8mp6LwceXpvOwhqv8D7XeSlrdAuZyPR4mKaAqxBEHYHa4tMlkffATfXLrQDnpNI
         +EOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FPmrkgLMFyln5L0U9MxoTdvQW7FzvHOtKlle0J83sYM=;
        fh=LsQ+wDHu8lmZxM7n139F5tAc1ejMYvvYtL6P8kplMNk=;
        b=RTKO/XCXHHgKxtLLLeKD19M/lRx8wv/nlGIwscu07/mquatMInqzgrIq31KEFDJuwK
         uQ9AUhaU+ZXZBERQCEfPtvNH1gqB+s1jzjlbmkwHy99QHPNyDb7UPwhOOBkanXDc6JqQ
         9d4QEsFm65rVnJv+1MU3sSBOOVyr5tr8FRyY957qJvOodejSqT08xkI+X03xXC5yDhcQ
         uw456Ln3s3H+soCJP711HACysgMVHyrFZa48j59EvBT7ooOwaDvOlM8phMI4MlkS5zZZ
         9uv6Nzhc1WANThiUOEMRMQ9JFS3sriApLmHeez+oGn2rz23w6E7VV61UGOpgXRuH4Zse
         fU+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787800861; x=1788405661; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FPmrkgLMFyln5L0U9MxoTdvQW7FzvHOtKlle0J83sYM=;
        b=pdHkVXM3GO90lRGYba0IFUd6wzrswqOn0K3wj2MXdUFRJwY0MQKNfk+QWQJIVzXZxI
         9GtMay3+JP6Q/kVsseZnMVZlNue8K0vRO0n7zk8ZoQfEGIaL1cQaRnzEW3PEgNaLH+GL
         LBMgN2/UDXdddUY8Yn4JpELkqAP8dJB4gNTDc/m4PZ6GtkO2v+Gzy5s2DtCtRIDzHEZO
         jhJHpQ7f1qfY928gERls4rV/aZIBXVjL3jDY2z9/+MyxkNS/YHOM7p7odIj8+VFEkkpA
         NOm4KdIIVaZS72eVudERy2OJs3mOiaZwdtRi25wMmElMu5pqJlXPfcI9e8qAgkv3Ipni
         3R4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787800861; x=1788405661;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FPmrkgLMFyln5L0U9MxoTdvQW7FzvHOtKlle0J83sYM=;
        b=HUiEmcjDxAvtzuNAOQdiUwEccvH6j+5ABZKSR/XsSIh210YeoRL25fHgCpdlJwu/k9
         nC70Tre13cKRie4tM9zyIarDI8E/49xJBv5fAwIf0XOZpIIRlfu+thwAiDK7/lSiXRDd
         mnnAuk3GvFdkkHe1rs7qDU9GzkGNhehHRpiA3kaPrCO2bYskLRiZ3DHGK9hMHzFTTrUG
         oyRAmBQ/Yz9jmjupsJju4Py2LlmIJuFAY0IKAnvUTahBUcho67cSVCrMqhNKAJeeeghP
         te+QwfNnh6MBlEvXhH/a/mzNxS6nsXxIJY7+keVU8rnEl90ttCiJaBfZTxcR3vF3r2UV
         fKwg==
X-Forwarded-Encrypted: i=1; AHgh+RoFd2AHLJmpFL9Em6OglHvy/VC88QxS0bYV0R4emc6L3TrhMwI4v+aidBQs0UOkV3EZ4d/rRN1o+g==@kvack.org
X-Gm-Message-State: AFuF++kAZEyFdWUXvGu6wLop4Zme82ONIBABsR+pLxi66/kBZDdSjvZO
	GjKy9BibdE9IpWxBuK4+8o8jX1u1R3yX+9h8qwBkyJUVx1Np1A5p2VMuv9xc7G6JjioLw3v7+PM
	ED+JnW91Qw6AACEp/V6/DbvBL3KyJezU=
X-Gm-Gg: AR+sD10lkqLj6WqVtMAKN681OKRrQZMloGXVkLLpFtx2TuizizokmoJcL1qib34X/lh
	ewwRr1jSZEXIwlhN7/tcWInyIvSoVBVYEpRpze+nftH7GZ0i1KF/CJtQommNyQJENgGQzvhD8uU
	iQuvP4oVaVrz2Ko5JnaWDNHElb9zucyjQemdJvGNEgf9CjlozSku/TbieSkIxvpDUMMHNAmuDXj
	dAa1j0XzHvwgn5FTY01XMfhbVOItfTbcDsW1Dmkf1fD2lg0S9aP8dtH6WCS8NuRCr3ZGdVdvqOZ
	LH0HhqNRoFVlutmhXYvW30eU3uRPvOEpx9XbkvUJmGas81KlUCaoK+bZaB78V0PWU4E7pcpzmH2
	+
X-Received: by 2002:a17:907:1b1d:b0:c1f:8021:deef with SMTP id
 a640c23a62f3a-c250bbc69a4mr1290633466b.10.1787800860849; Wed, 26 Aug 2026
 20:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-2-baohua@kernel.org>
In-Reply-To: <20260821102538.22642-2-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 11:20:24 +0800
X-Gm-Features: AcwNN1WtoZ8Q8cI3Ievd4oOCnzXv86_Xn-VvBZtvQXKmSYIiN3EGlABnTS8ddKw
Message-ID: <CAMgjq7AZtqdu-yJ3TSa9Zq=Cwuqv-NY+ptz3Qpive-iFXR6e0w@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7576A40005
X-Stat-Signature: m4b9rnmnbqyfjnpeoj44tb3jrrgebnpi
X-Rspam-User: 
X-HE-Tag: 1787800862-71663
X-HE-Meta: U2FsdGVkX19XgSFurT82+uao+1U+o+wWTCN9SxwdHMNyw2/ptdLmh5T8l+Qee4mzy+7xusr8nO2vdVRWD3gZU5g0IOuZMV33TqQHfi4b7U0qLiXIqYQw5doHsiRJx6VBDUfHQj29seqSlPYdcxNBQ9qmkWz/Xdx08Cp3z6sJAIkxaC1g/itrE39bjJyLfZq9kUrD+xI3ekcmjvnwAwjTy16DHeJhMUoo2tlWM1V1R42U19aXxtFV0HbrSc4HVDLdN7o0c9WFYNFale4zYtZzLWLi9nkWtlS/jSl6OIJBUwo24pH9Cgzr5ROaWmLldUzYT4oxUczwBEkleBpbTkOimeHPSIAO7FPo4BQ1SygS6MAA+0zF8LM4z2ksPLbfEs+KfIt3M0UFLs6uAMTQwR5Vikl5aWroy0RvKnEsO7/gegtcwaUZqKGEIA8Hq8M2gXxE15mqfEzyDQJlQR9gEMN2mAMGunie1OFM4YHHH1PyuSTkkXoZStj18cFMRTM+8xEbDEHfxKvpVofnFyFSn13p9X3/+qqH4Ql2n68NcrEwZsaVCw8IgJJvYh6yrNPx2zB14BPXeAtwlkDqrH6GwN1BwOngshf9YpZtLNv/pvkoIadNXN/YYj46NXoxrokH3YNcDhd1jjzUfR0/lkvRwQs3Boxl7FvZSHIbsylDgCt6LtZak8ub1DW+bl44XeyV981ksI1SGDfUxcSFedWPYkg1Xe8V6oXYjgUx7bCBF/lyrxbBmtTeFM+8Rp1thGooPaPqCwDx06/SC1Zy82lUPdieI5YAbhUFDFZ3AzulGWbGjTad2vAKNESckGhKqo/dQSRio7ZH8G5sBdmz7RYOI13SG6a967Yi65VhBh+nDWX7+82As9nwSuPxwkylqK9XVPywh53XV42flOzKJuKtvY6jyp9x25ZFDPNCEwX9OZ1Ke4WICg6VA9ykfohBpsgkg8O5WNSn6fm4J+q+iZa7N8s
 JgL5eDJc
 gRk1f4/2RiuIubG34ZGTgLDxmZJkM1Zld5KktuyXKU6oSFr/+l32VmQRPaGBCQKpm+FESsxZnm0Cx9CvpkdEuA81Hqo3ECz3IuiPDMzD6W0OvpQGEJ/ZKeuyhmR55/qnGktXAF9KcpaM0s3CmRqKPs1jId57wKBKp0oAWc2VLo62uMiDHQutSQCNTOSzf9bZEnnO4msNoHD/PG78L0ncVJrESWc3vd9gIGHVE84uvgpX+1rg5DM7e3tPPakzUZN99CPQkz3u8g66aPHfupa1NhOwoG2y7VhedxieSBVBRhSbqk+BOYuTXc6cTeOvz7vrj9Tx518si30TUko3h2jxLPKGSu65KRtLUpaRyrrSfpoTFJE0ytbN1+4K1meaXZVC/gZziZhVMzEHn+BMcSTEz43SpNK4vqhsfTT69x05ezNZVkl0GmXe23absSJtFrz6auUnRW1E5whdsKFeeWxBebN9FcEdRhGGGwbBGtLUsy1hc5byYZUG1GGaNasS3cStX6fEPEnhsIf1KJREE3NcvekeR2HiyLrOZ22Qw8frQXQ9m8v2OilKakcp6TPBc464+eD0rM4BlJsG6oocefxs9OpGbwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 7:09=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> as it advances generations. Instead, accumulate the size changes
> and update lrugen->nr_pages in a batch after scanning the entire
> oldest generation, or when the scan stops because remaining reaches
> zero.
>
> Since we only move folios from the oldest generation to the second
> oldest generation, the active/inactive state cannot change. We can
> therefore skip __lru_update_size().
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 11 deletions(-)

Hello Barry

Thanks for the patch!

>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..0d74fc00abd3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3296,20 +3296,21 @@ static int folio_update_gen(struct folio *folio, =
int gen, const vma_flags_t *vma
>  }
>
>  /* protect pages accessed multiple times through file descriptors */
> -static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> +static int __folio_inc_gen(struct folio *folio, int old_gen, bool *incre=
ased)

I feel the naming is a bit confusing, the __ prefix doesn't tell how
it differs from folio_inc_gen very well, maybe just name one
folio_inc_gen (the old gen could be any gen), another one is
folio_inc_min_gen (the old gen can only be min_seq), and with sanity
check in folio_inc_min_gen that expects get_nr_gens =3D=3D 4, and
lru_gen_is_active(min_seq) =3D=3D lru_gen_is_active(min_seq + 1)? This
could be a build-time sanity check instead of a runtime debug check.

I saw baoquan also mentioned the debug check on
lru_gen_is_active(min_seq) =3D=3D lru_gen_is_active(min_seq + 1), which I
agree.

And BTW I'm suggesting changing the definition of active/inactive for
MGLRU from gen-based to refs-based. The gen-based active/inactive
reading has been giving us headaches for years and is a main blocker
for server production, and I think no one cares about the
active/inactive reading for MGLRU for desktop / mobile right now
(especially anon active / inactive, which is basiclaly random number
at this point :P, and files are almost always stuck at inactive).

However that contradicts this change by a lot, folio_inc_gen will
always have to update the statistic, see (was planning to send RFC
after more test on Android):

https://github.com/ryncsn/linux/commit/d13a3abdd22a97eca32a7207fce56cc6030a=
3bd7

This is another reason why I'm trying to avoid aging rather than
optimizing it. I once tried some aging optimization two year ago, the
result was good by then but I gave up due to the added complexity:
https://lore.kernel.org/linux-mm/20240123184552.59758-1-ryncsn@gmail.com/

I realized the main blocker was cmpxchg and maybe async aging with a
refined reclaim cycle was the better solution rather than making
things complex.

But anyway, let's process with this; perhaps we'll need to find a
different way to batch aging later to fit the implementation of the
FG, OOM prevention or refs-based idea.

