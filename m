Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348AE606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SUDChHMD
Received: by kanga.kvack.org (Postfix)
	id DC0986B05B0; Wed, 28 Oct 2026 14:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98266B05B1; Wed, 28 Oct 2026 14:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF4A6B05B2; Wed, 28 Oct 2026 14:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D36B6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:33:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6FA180193
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:33:41 +0000 (UTC)
X-FDA: 85372883442.05.4ECCA4A
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4E7218000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:33:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SUDChHMD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793212419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
	b=V5UQA21LGquwBpORpT/EuYeiCgfYKx+hQ1jcbYikXN5qj6B/rLPlm1M5vvs9kPFP4VfgPE
	Duo7IUvQFWBI4KK/dkiypBetLGp6e6U2DX9HB/Q12Dezsvjk8ck9B7AH9rFFgQcd9Q9flf
	Bns1lknICQI3Byy7rjWKqEpixiwjaWY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SUDChHMD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793212419;
	b=KXmTPv6ynsunZRcBeRMRiMvMpyNYWVn7YnUrJNkgdy0tarCQIIoOTcc4j9Zsa9UbNPiCTx
	+RCbY6RlH4HstO6MmXiQJfgcDHgd9UeEBgOscgN4F1T+t4NmnZK8db2VM8RZGUHb1GPr0K
	uPQwy4hKuQN/vzLbEHpWZOTlaA/fnnc=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1096099f8f.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793212418; cv=none;
        d=google.com; s=arc-20260327;
        b=gJ3j3/bhUR/bW4iFKEPXLiOQiG7h1PYKJ4fs8of3PUO/VV+8ACZ7YJnJgc9rOd6VGc
         0DokxsZda6E1g0imfM4qxfap1qBEzM50BfUecBFpxJnsz/azWORrmXWXa5reDKSvRgPd
         khX6O+L5eqT6Vt6OZnBvpSHoPS11WajEOSuzdwPLcUvcyIH36rHvhQDge9ndIAXLzMye
         +709Bmi6WnVQbQTh3VXla36YqYQ3ECgOmyl4GEEaiW4MpCKHSoJ6y7FsJSHnjCRPojKb
         S+xPq0G7sP61Mv1KhB0XjZOGR84I+bTG2PBbbnQvsPb7ng4RKZm13n8M2I5bCsah2imM
         Hmtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
        fh=+XpAE+U2xOkd9hPc6NlBCyf0VLf1dtrBK4a55xaYGkQ=;
        b=VBRdASZhCdU72rCrMkQ87L+iwHqZFFFjAOEPXdQzPMV/mI2aSCM9QD+9N4nS9VgKvX
         T2J7jlrx5Hgj7Ms8tJ5aBn00pn3+PtkF/8MHH7E9ohOyxf95dxXRO715GdAaXhemeeh9
         geEUGpG6ps0zeuhhDU7xYrYzRhpxdxH4+/8fTDaDe78R38Vr5GK5QO04JzAM+8RDIGU4
         zZ7N3A4qiOP9wdcPZqzAqCvctD4EYJ4OruWxN6fRg8k0qZ1TVwRUcym4imzSsjcdFJck
         U/HtRkIzdkxjQACzTnzc+MKLpIOULVtmGrj74JUBF9E0tRW0+yhYkQA65m4MQvIYLzDv
         itOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793212418; x=1793817218; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
        b=SUDChHMDsIUE7b260UkTCfv1ieiX8YAdj2mwmq2pw48kRzUoJ8y6wZYI6VVApu/Tqp
         LHJJ2AlLIesG3gUR1FmY3fiaLPKbGFskP4bjcb0Dz2X7Lbbm5raobQTZka9I9ziyLL+e
         0v0hpw69pZsF53Rnlc4vwvSk8kba2tHdPF5+8JPkLwQ7WU5HGJ0ikc3ndrKtUOX3qOyw
         1BRi6qPtfwxJA7YuwV1Cs11K4Zdla9oxGb9h5fHQbfgSp1QM8mgFxc+w7G75E0yu8sJg
         BgRmbdrT74Zse5lg161dhEYkXSZd+ATdfcfwV1tlW9fNrvaGwMsHgt6WFugdQOk6L/kM
         enDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212418; x=1793817218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
        b=CKc3+nTWmJuPoc/v9RGcbRlOiwSzXd+fh5VA/X0Nz1lE7ABuHOUXPWxO0jEPQEn21D
         z5s3m33t4YEfqnn6rCBEZidmx/MYx/2Ih9Sg9wkXoAdG2bgC7a+BHIcxdYmlqDz0tBbe
         uLqYJ2b9EeFvpPK0RZABGsec0VFBPPaZwUUukh7Hb2gyHSlLASp3zbrStdGJJxBUPv05
         VFNb/VzVk9NP1+foRpvCGziZ9wCnHoja7ZRFPsIePc/nEXBx0XahFxYEofihTtTjzHi9
         BTmygiEq4SYawtjP857zkcikzGRkY2TfMoNcLyWO2GT6OqlYBXWyFNQwTzUlkNY0+vrO
         UaOA==
X-Forwarded-Encrypted: i=1; AKwUvBwmcuP71RrSlO+zhEmmI9omq91jDk5eNuB61A+IXLK8mWiFt4snQi63UHYVCp/AxvV3eCzwsHTsMg==@kvack.org
X-Gm-Message-State: AFq9FYJVgBaNz6NqpyISvqOnSZ6UOw75AKukRGfL6K6dUBGSAXyjFnkl
	gqHbH54N++W3EHmY/kRXAHQz6V9onnFerFpJJoKXxsMy2kf6nYgISwyb3pV9xH/0AvTx/lE/PzQ
	sbsTCA52TKyhKszv8EZoxJA4Tx1uqwdg=
X-Gm-Gg: AYBFou32Tf/vDgBCoYYV3dvLc7SQcMejjSH8L4sIzURc/X4k4Wb05J3ASKrGcD+dfcL
	1S79GFZG3xp5QVubG9NicY1wYC+B60hmufzEwhcs1WquM1ICfbRqS9d/8u+pPKiIdKVc1tYklO4
	ZcUoZS1ECcvBJljmPEhflfhV1NUHF6vu9ZMlRpXqabs72UOXvK2eyCXgqabz1AoYr3aXePyV3FC
	cLGZYRlqDeAQCwbW2/gDhj/8PIL5uW0ZnHxnhbjOcHUU3VJomvGlKw99rd4p0YbABmwMbB5onbg
	/LqOXayiW40liArJeJYmtPbJGxkYJcVnN9Rk3q6edTlWgRPzH/29aIL0dedJX5K486V1xRzXGwU
	UHHtZia/L/jrUWM9JG7HSR72fk4rs8JB7Duj7v3gEMYbpGsvvTgxX/HZ0At3Mjsh7WjoO/AGl6N
	T+qEEjdYEuaJ8y2e1OVg==
X-Received: by 2002:a05:6000:24c5:b0:48d:fbdd:4132 with SMTP id
 ffacd0b85a97d-48e5d2e735fmr7896834f8f.18.1793212418278; Wed, 28 Oct 2026
 11:33:38 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
 <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
 <CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com> <20261027192414.cb3318abc07232ec5f1bc937@linux-foundation.org>
In-Reply-To: <20261027192414.cb3318abc07232ec5f1bc937@linux-foundation.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 28 Oct 2026 11:33:25 -0700
X-Gm-Features: AclHuK88Lp-URHNAJMmVOulPZwNOZDWdUu5bfn4DmWPf6pmLBXKAO1fN5Zvq1ww
Message-ID: <CAJnrk1Zxwn8W4w5-rJw9DNPvZU0Or6Z26nL47RGxRHhFCKu=ag@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec stat
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E4E7218000A
X-Stat-Signature: jj3kusuxqsze8ghyzhyn1nhfqmfzn9x4
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793212419-883077
X-HE-Meta: U2FsdGVkX1834F7X1B3O5mRM/WACMsCWBw0ySS5Z9JShZ8H/T80XzXzXBmXda5H263xIR7rOutvZFtP1ecuRppkaFPMwWHTTnC1sFDMT+VxL+Tsvj6i5ajbNryduOdFuiWbiosgsWZHa9OHmgJZsxPriB58+UWd8/iUEim5wkWBe5YhYl/B8rsHZfgTOhQqNeInM6T8OhRafLVxfaoz1TXKOR7M4HwwCGECLOO7R9fDlhfHrOxkkcBMnu1wbFwdgngTc8REzSVmezmYm2mQC0coEjxirxJ8KfdyHmQDlQknw5s24K6MRA+r8g7EwIpMdj+l91lkV8EO2jNRdJEtTV8fuvBc61R+/4KEMl0bilfinQEfHPErAJOBN2als0xFBox1Y0E03/o8/tsLZDY4JAB9QnF6wzZS6LothvjtuDdWQqb2B/4ExO9mBABM9uXoidv016I48xCWgW1ojC1Q+EOI95xw8DfTDLIdWuQShMs2VLFtNMWLo9kszFyKUfaj3z8p6/WB0/rWFXI+Y55G4ulpxGDb+03bo5orB4NLCEB0GRo/q81zURdAzieQk9nlSdL0Ut+xzMSh2IKiOaDlA4+1N52/GEBs4y4gV1Poz+QRg5ny+AGM0rAmUWOUc9pd2NXBsufPHCsiYK6EY/IoT6SpexEe2siqqrsgKZFhiOv3wLfIN3Q1x5CQfHxEEcwGhh8JhXuQpinEI4FtfONXCoHWxBwimN77QSiFlwQdcw0nkTtis155G671C64YLXPNiIp8hn7cISHFmcdSN4JmEX1EEq93ZMJU9hZlyfupNbwvuUK0ieBMqE3RhafPZW8f7/MYvLFcPHbYrJLe9Qm75aBKwpi/y6L0OegDrU91YLc3eElaeZBe34HMClKqjabhZpZ/KwCzCFXwl9sqDqr+4GzK6mDrcK6dbE0BFXasGpUPLNMuTWCWgM3A1cPBhRWjvKXdid+yjh1LxzGYkOK3
 HcLlM7vt
 GTL6cxpE5AK9l5IQck9RtQcw1FNmqMYKsCzo5fbmnz6SOGaRZ26IPkMphIUzLHcap0B0r/JZTPJswhxZG6Pu4FVvusUS8tCFKEhRgQv7M6BiItTAULkyk97ObEnxmD8LmWvNQADzCJ8kvhgcuZabJih8pZWocBaI/GfuRy5G4y945tNpusq55qswa9gde0VrgaZ++NFXedG8wmhv9eBQMBPsdekZaZEKziE/nKTsFKRQGGzFXjGMZCrTEcPo23jerABPjZfYcCnYBkJuTfOV7pI6GLjrhOZzxHqO0u8IYvl6GKGXmv8lrkl7cYAFjkibYwEA5B3oUTxkZpRjwWtzuRd6DJjqCpo129xassb7wal/JUTHO+k2rLM0FoJ5vchLt5NO1hyY24zB1m3IxS7rO5PSeLkbeCBiumttBXWk8Q6n58QHE8Q+bQxP0RPSC1IevUeUXUa3ZZSE9XE95TRZ6IPl5a4vNQV+jhMxy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:24=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 27 Oct 2026 15:57:43 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > Here's an updated version of the "Fix this by moving the memcg_pn_cold
> > group..." paragraph in patch 1 that mentions this:
> >
> > Fix this by moving the memcg_pn_cold group, which is only touched when
> > the memcg is reparented or freed, right after memcg_pn_read_mostly.
> > SLAB_HWCACHE_ALIGN only aligns objects to a cacheline, and the struct
> > is 576 bytes, so depending on where an object lands, its read-mostly
> > cacheline is now paired either with its cold cacheline or with the last
> > cacheline of the preceding object, which holds the end of
> > lru_zone_size[] and the reclaim iterator. Both are rarely written
> > outside of reclaim, so either way the read-mostly cacheline is no
> > longer paired with the LRU list heads.
> >
> > Would you be able to swap it in or would you prefer that I send a v4?
>
> Thanks.  I'll take care of this when I process the patchset.  Which
> will be quite soon now we're all merged up.

Sounds great. Thanks, Andrew!

