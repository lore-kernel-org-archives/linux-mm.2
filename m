Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DF5CF9C7B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DCE6B0028; Thu, 20 Nov 2025 13:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55D86B002A; Thu, 20 Nov 2025 13:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9723B6B0028; Thu, 20 Nov 2025 13:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83C0A6B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:14:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3042BC02E2
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:14:07 +0000 (UTC)
X-FDA: 84131784534.18.6757502
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4998A2000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:14:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rt2MiAwf;
	spf=pass (imf03.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763662445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnAwwRG1xi5brVg3f34AJJJ2ozsmQIQit6jyVLGvFj8=;
	b=rATcdAfnkt3gKBNowcG40AR8oLj6OeIasuPiL8EXeP0y5GTMLFEL5HbZApGfqIVa4tXAyL
	puyta6XN7WiE7hfiY7RZ8eWxvSLsSTDCHqrvWHLyhwg49GbxWmoJwymKAp2Zfqxq/0uh3n
	Y8nCbOJoVc8JfiNO5mE36QRgWGjr5YY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rt2MiAwf;
	spf=pass (imf03.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763662445; a=rsa-sha256;
	cv=none;
	b=SPWpkzXM3ZfcY/yjG2g0Y/PIwmk4wSM5Tg9HqmmtZ/EAoVmJ/Whm7X6AQG1zUf4YZk4Jg4
	UfDTlGsDPfj3Sg6PgwgLQK0KBwDv/sOKvoikhIVjKwL2A+ZxcBt4ySxbizqQxFLqezo8HU
	V4im162dE5TVkvT+WUSaI/Wq78lS1NA=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29852dafa7dso9105ad.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763662444; x=1764267244; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnAwwRG1xi5brVg3f34AJJJ2ozsmQIQit6jyVLGvFj8=;
        b=Rt2MiAwf1OSDgbJnacV/4gzCR07ysRCkgBFPDFS9TbnnduqkqmMac1r2s119NUxkyz
         NMoIYbpMF03lRiR6+Umse7vQQZUq7FHPNmZcpO7SLONVzww6T3lWMpNvLgTyW2uxQmKy
         GQzhigaPEurnLhb1tIO5yZvM2ccz+qYSvhTWTM3oWUKEE1OjhZGmbv+35/81kRWSUUbn
         QCEtBRgDS8dNxDo9DOjZnE99LTm+XkivoDnGtQXd3Svresic6uNvEdzxMSwitz7HttAI
         hv2K7lTYAbzNi6gZYozVcUuuhJTGzNY4LmTFeGW6evm+tlJBUh3RTl8pYHAKXHRoLYHS
         8Xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763662444; x=1764267244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qnAwwRG1xi5brVg3f34AJJJ2ozsmQIQit6jyVLGvFj8=;
        b=HKs43cCJx5nXfXHBtnzBzDZ3+UM7ZZSyWYW5h50hHuFyW6Ge8/KTvDlp+dmEGghO5b
         BdwQy63gcl/4Ba8BdMA3wEs8twS44HxobRvSk2Auvh1oo/uc3e7Dhe39DAMAhTzoj3hd
         +sEZ7ak5QuPjceUDP2wJ5sDNVgHg8WlVtYjOlcQuuRKDpAznjqdFdyOrEOd3FNm4Ql2J
         YmWUFpGl1ow8TgN2/dkY8HG9Jn0R3wJh+gPTsTbjjj6LF7ZBJLeYOEvXNiZgzMhbEalU
         2NWtsC3xaZfH3oZkXmwsbzkagz8zHKSFGab3T/G9HSt4fCdLK/8V3xgwi2eLbfPWlDQ3
         z0pg==
X-Forwarded-Encrypted: i=1; AJvYcCXju9+imHYcC5J+7AahQo81sgcei+OitvvjFsxMW/wQXDriikWKkM33lHqFjJhq0/53QhBo7ysevA==@kvack.org
X-Gm-Message-State: AOJu0Yxk8rGckWPkG3UtvuhPEbDqA3thviFbg98fRG6KKoTaXVa4dVEq
	E0aneGsGSbgrQF6Kur+AS/ArF1o34J7eQOCymf1yaUgvq7m4NaG/9Rrz2G1GyTYi1PKtCnQjk2t
	hAHP3h9/DOJLu/zcxZVj4/zb3E9cm6XBMGCgOKubO
X-Gm-Gg: ASbGncuf0hNbS3vUn1pysPTNJkTHoDUDkHwHcPF13mP5btBaFijzrl/fpaWW+sB5cyh
	AQcl8kIyETgAnOIjPaznjFFViPkaS0HqcQtwKrZw8NshQrEyK1MzS1MlCsK9vfpAOvWLOgVHmt4
	0RB+FfOvNvaGhVauQqyd73XDVqYCNbXc3VPThm1xzUYUsBZzvBisuF03Wq1yACEbboAhqom+777
	8IN40Y8p8pXoOFIQpHqYEAMEPtfrC/RrRVAAWL2AOMMTXEmgfa+wKLFHy21EAlOATOEN+riMnuS
	rHXVtXM6FnObe1FzLPkVnd7tn1dYpMpRPw4E74wOqHhR8A60yAnzhjU=
X-Google-Smtp-Source: AGHT+IEJ6cqaG6MxrDd8DOBVpTVgsb8olGtjFPzybXpMgpdvGH1Vhu3k2CqvjEEfwDleme6JIj7dMMORoMIFPxwwh7Q=
X-Received: by 2002:a17:902:f68d:b0:295:1351:f63e with SMTP id
 d9443c01a7336-29b6a3ecb55mr12825ad.10.1763662443808; Thu, 20 Nov 2025
 10:14:03 -0800 (PST)
MIME-Version: 1.0
References: <20251120152126.3126298-1-senozhatsky@chromium.org> <20251120152126.3126298-7-senozhatsky@chromium.org>
In-Reply-To: <20251120152126.3126298-7-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Thu, 20 Nov 2025 13:13:27 -0500
X-Gm-Features: AWmQ_bmSMHceSjxinDeE8mTZc06D2U4HleB3jocgu3xFUGTZUMDr9Qt-L6LI5Ok
Message-ID: <CADyq12xmCgX1_KA+bKt=r=MWRKSX6N3bsuxBn4LRy7M1K9=1mg@mail.gmail.com>
Subject: Re: [RFC PATCHv5 6/6] zram: read slot block idx under slot lock
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4998A2000C
X-Stat-Signature: muepch17p8dh3r9urfbdi1xfu73zt98i
X-Rspam-User: 
X-HE-Tag: 1763662445-438758
X-HE-Meta: U2FsdGVkX1+AFvt1kmXEk6WqfjyElPuYxvKjoksLgmY0qRHTD/ipEiGOZg2DJpz4DfhrSQnKw4SGPdPRSCcPLH4ClfM6XJdMUO/Zt1d8mOH/bEjjI6hrRSEnk7O8HHPqfNTDlz+ReFXmeh82Cvix8j09XwZi90zAsZd89KF3IIh/L4XRjkEUUgJUXJeDwsqJ+6aL6AN6HmZ+LTdIViD8ZkKPRhDNtmvgOZP5g3lvxwFg0QLxCdKaA90jwTEkw65CDaWI2sSkOiSbqZv5gTtKjlEjyVZQIhO7NgGT3r5dLiTZDj3Inmzgdp+jJ1fT2ZWqQqeDyk2l93UBgZDqTBcg5lQg1og2L2Tx64BeIoT4/sQ+QlUrYJKj2UUOsU5jG3PrUSTO2ojHWQ2z6MwljRmGPsoYdmGyc6FNJlohgIvdl8kAmYIHrd1vTuBPMpjVo1kNkrmqKHKVzDOqxUD3UV9OrwN6AfgYwmwzKXTwQOywjYnNjJnd1xpU8rE+Hq17YGvw5MGVAvVOWF0CFGvrXIPhyrR7qY0LI/7ni4XPYyrdgaXqhwAevTV9X4KYgdqWta8Tewep35+LVA37QSLjcbQq+FhT1bOJys2iwpWTrlyeF2J4fdm+oLWS8/xDpjKkgomKS5Ok16oaj05J4O1DdL3TzekU8DAMFQZqTzRgD2oV2detoxx/nVU1EGRmghKRkK/waMBhYyyM2ykjamhxp8IGyxbmZOpTSw7lLeq+O/UZHdiEx8crM3GaBsPRIMudiQP/032a29P9cVDlnByrRO6VHZVWJYsd3LZIR+/8t1pcC7nOUpWMQJV6IAVhJnkk3puAZz7nj5ovZvT+pzy1uuEoKYbqXUyZF3Veuu45gYLVcVpl5kw7LYYJJL6J9lDFAHDDHADDMg4deAUxR62pNxvO8IUBJsmjoW6HNcptFfKNg5wkPzuoFrPFe21u0Zwqn5OOc8lOQ0ts2MHt6xrLJ5J
 wkeKCTLz
 RXSU0X26vE0v21ZQ+1By/JW6hHw/syJpV0K0VdQv/SgugH1///RRC0s1DAxhN9RVfBMaUtZZFIPTHhrC5gdCdFBYcXnB4wLKpcvUp/GBldLjbOGVjfgTQuY/ks8htAivr2kyGevw6EXBcQ8dFX2TGz4fVtKPgexGzsMN4VreoEx7ChBiDMogsKiRB+JjdpIzp+tIK8xXk6RT5MDUaS4rGt6fwGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:22=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Read slot's block id under slot-lock.  We release the
> slot-lock for bdev read so, technically, slot still can
> get freed in the meantime, but at least we will read
> bdev block (page) that holds previous know slot data,
> not from slot->handle bdev block, which can be anything
> at that point.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/block/zram/zram_drv.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index ecbd9b25dfed..1f2867cd587e 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1994,14 +1994,14 @@ static int zram_read_page(struct zram *zram, stru=
ct page *page, u32 index,
>                 ret =3D zram_read_from_zspool(zram, page, index);
>                 zram_slot_unlock(zram, index);
>         } else {
> +               unsigned long blk_idx =3D zram_get_handle(zram, index);
> +
>                 /*
>                  * The slot should be unlocked before reading from the ba=
cking
>                  * device.
>                  */
>                 zram_slot_unlock(zram, index);
> -
> -               ret =3D read_from_bdev(zram, page, zram_get_handle(zram, =
index),
> -                                    parent);
> +               ret =3D read_from_bdev(zram, page, blk_idx, parent);

This patch doesn't really change things in a meaningful way, wouldn't
it be more correct to take the slot lock again after the read and
confirm the handle is the same and it's still ZRAM_WB?

>         }
>
>         /* Should NEVER happen. Return bio error if it does. */
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

