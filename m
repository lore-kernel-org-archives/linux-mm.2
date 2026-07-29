Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E303C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402116B00DB; Tue, 28 Jul 2026 20:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3066B00DD; Tue, 28 Jul 2026 20:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBA06B00DE; Tue, 28 Jul 2026 20:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA1746B00DB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:54:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EF021605A6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:54:15 +0000 (UTC)
X-FDA: 85039992870.30.79453CC
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4512E1C0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:54:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RQcIAewA;
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785286453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nf2kVIa1iq8ffqxguVBUrufk1tDQ9g0pRNci3rwl+08=;
	b=8QrfkQihHPJ5M6o1z10NQP35dedKfj0vh7AiO9aNefDJKVyLhtyH7Qk/hlZZ6eO7K/zlyy
	ZGJzF9e7kNLKCusZUER2HOKpixjOoKn8KV14KoydxdWc8rF3iscqwqo+OiOLYRlvbh1ZCf
	5aMPlGh4HcweoG8DKPcAWAQNh7H+qZs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785286453;
	b=qoDEIYRXbPrEdlHbYHYilsUTtvpCll+geG5nUPupZP3mgm74dS2QqRFW31wQeOSHJVrdRY
	a871Wrvkc+pXp5BEkLL07yiuQHVwx2xWoCJmGkDEV53ByT2BhW+Q2nH3vzuvnJ55zSs5Fz
	jL+kRvNj6S5cTBrw7osNG+PhrS95Wxo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RQcIAewA;
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b15c6fb864so299055e87.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785286452; cv=none;
        d=google.com; s=arc-20260327;
        b=I9vaAqDcMCg1W/yEY0xQLbdBjlVW05+ksiIO1V+HrscwGAuR0gx243s2hyJ71Pbs9Z
         p5mRzd9zRe1N6OzAU5D9JOvoQZfZYriYN5Gu5AUsq6kd0+bq274psTD8zWyF9tnYobV+
         QGjUZ8ayXF+0vEm6xEuTd+C1HfTTW8eNPoIsOlDq59aJqQAsrTu0CKzLIUAo5uPxB5hm
         QUMzapDLLMUiVhmlFOsSQYjScTwjRxkqVTwbQ/cR41C6pRYPCI1F92L8LywMPQLnhyL6
         d467JwrvH/ewKtakAie9J5/Ve58L4wr09JeNDUf0Pe4WKPccCZv1EDEWWWZ8smWPAJ28
         7bUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nf2kVIa1iq8ffqxguVBUrufk1tDQ9g0pRNci3rwl+08=;
        fh=b0e2w+kszFNyXeUextSg2+rRRO4u/S+Ve28YxasiInw=;
        b=OtbnmbNUG8HrQly3x2Wp0IT5hZv5CDGfiU9Hl4X/AZlp45hQMNsrxrbOgBM7W3TVnW
         sU3d3w82lNQel6NfLi9BMwpiA6fXYAXJ3894u8+rg4Jz14hI4lCt5zH7dxbKnL+OQhvP
         UkIr3kRrkJUY3SwkxMbNtK0pIVIk2qAE0X82tA24L3HI0q8EWw+ooDnUhxplhtfN4Vzt
         bvgSj7gW9DqjlPbKhfbPU9ecOXAQBzejPISh4StsNbIrHn0qv24Ns2xmWPHelJBT4U76
         5AKsUWKCVzSoV2DEc8wzja8dp2eBawF3YcTlMDzz8JQ0KVy9pPxsQUSB8ZZVYqzXc9R+
         wBnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785286452; x=1785891252; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nf2kVIa1iq8ffqxguVBUrufk1tDQ9g0pRNci3rwl+08=;
        b=RQcIAewAKNgOExeTQVO7TdB6gzJge2d9pxZLHxRiJ6v7jm8B3iybmhgEuKfbQPpwzg
         ZylQ5AypAv7wZ4zlVAmWllpkh1mFPhx/B0a7+7SeC4vRh7Iaw+ZuOU6RFyLQr7dx0mkU
         S21r4PXFisBjyN6cfTfPzTuuc4czZEgDZDmRAuZeBExDQ4AOtCRWhxpTJQd+W37+9J4H
         6mFaSyZak9798bXD2NN/T7p8BqVme+E5rFk3z1DDrdsoc0XkYF0RfAmxYzFet0LfN3wB
         NVdIlxA3vkFC3+ncGeDZ5pH3rdIrgZOPL0OMTlkA6+CUQn+O7IoEG4uLIYpQcCNQbW6B
         404Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785286452; x=1785891252;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nf2kVIa1iq8ffqxguVBUrufk1tDQ9g0pRNci3rwl+08=;
        b=WEG0W/U4XmzGYFj3DFHpc5Bi8od/xYz4G9lTyMmyyr9w3+5IOKsYnowaMnBL5Mfdk4
         TU97CnSzxDrX4KoVCIkT/hr8IDv9xzWEllzBUlUaBKMBfrjzxuZGi0qAhjIYdxz8N1Y1
         qDHtNOn2YkuHyYYbz6QCWkKLKVwzgYoN2loaI0f8KFbUWN20khLQeuuedQydhd65vv9o
         J95wt661Xb66a5qAAS4OogPeB0Jqar0z7UkKX58X4VSUZCAg7xPhKM4QuTr3IFjr4mk6
         2dIh5oPkwwacsxsFfNHo73nEsIbQVXVInx+i4iCEfG3Ydbyw55qTuANDVQAycNiOIvrW
         e5nA==
X-Forwarded-Encrypted: i=1; AHgh+RrTLev1GXyKXUqKpFnMvgFhwQ+YII7v2Wa7urf8GXx1iVX/tn7+6QOirz+qzW1nSD4zpK+2W+j2zQ==@kvack.org
X-Gm-Message-State: AOJu0YzuQd77lYjyMTQsrjJdy0Eqo0PcYPUEBJDNjL8UrYJljH0xjZwO
	VUlV7p40kUbzDNUKEPyO398yrxotO2eozNJYOs+XIsUkd330qYMJLZ7tZy3mxJGrlOEtM8sqCV8
	qPjOWTmV41nZXsee62JaXwN3LaKQdUxo=
X-Gm-Gg: AR+sD11BWdz95ytWlBPlgiIxWrRtP820qRDHfgJaVqfaxLCwF3OehpfGXn8XEl2JjhC
	hmynmtrdHI5N+XaZQ7Yw8oQs8/S+sO/ZYjkHcHdrybnlThHWqEFOyekfH3bU7TleAQ4IQS2hDJ7
	/g+jEVzVkRp/1xgESGb2tn8jZQ1jOZ4JebB9ZfxVaeXvmqmDigEnUzz3t9vmIacIWQRGRYtHfPN
	628wXXBRufCzN7+UFkJagSMOt+QI1742753lij47ibowjSuC/HVDZB95SllyEC6dwN9+9qc8Woi
	bczsQHXSUlvCoFO/pTO3k4+AUVl8OshiM/IW8CMa+0KCY/C+6tC5oLN6DgmTP6Np84Vu5TLojA=
	=
X-Received: by 2002:a05:6512:3d10:b0:5aa:8822:c945 with SMTP id
 2adb3069b0e04-5b2d0257139mr869739e87.47.1785286450543; Tue, 28 Jul 2026
 17:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
 <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
 <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
 <CAKEwX=MwhU74Ak01kEa7VL_mKNY1gO_hX_aAPvMkXo-72MB52g@mail.gmail.com>
 <CAO9r8zPsQ6rzhuRopvepxmrXg6q2r+ixRvL2vdG2FVmxBcUn=A@mail.gmail.com>
 <CAJxJ_jhvyMukPLThpgcdCMHwbp3b3bFvc4Va1cK79_3z6ubhwQ@mail.gmail.com> <CAKEwX=P-+=tfmohdG5+QKsrsWNyHtVahFv5+FR5nLeSH=kk-pg@mail.gmail.com>
In-Reply-To: <CAKEwX=P-+=tfmohdG5+QKsrsWNyHtVahFv5+FR5nLeSH=kk-pg@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 29 Jul 2026 08:53:57 +0800
X-Gm-Features: AUfX_myG2zt5WOMRydrSJlhQRSet-VKW3faLeERsSZgi7Zl05ts998z0PMwaFkc
Message-ID: <CAJxJ_jgBxd30+95SSR5DvvDC4gLV0pDX=_KfrcEFyi91QE-2FA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4512E1C0009
X-Stat-Signature: z89be67e9xbztrrdxwp9ie4nuaqdbixr
X-Rspam-User: 
X-HE-Tag: 1785286453-433139
X-HE-Meta: U2FsdGVkX1/VZz8STs0lmxBPAB8U2Uafxk0CW4G0wi3U13TrP0D+HXaZAZ/QjfqYaX2t6eVmugqBQNa4XIG2AC1MlkDakZh94LDmZJnLrzJIyqoPYSIHIC6iduaN/ZJi5wIpMTlfytQRhggLkrM6xXywxltgUuUQDRjb1i1I/OUSzyPHAM2L8Tsd28SbkAupqsEhOPGryAoqyp2zT/b6bxbMAK9uOR7Th/l4uMOr0/2LaxRDh8jLfhhG7xTQcVzQVK0AntKWbmsjFvxJqQrkj3G+ifyqo8B6IQOh7/oqlqsz5crs8mE77sSeBeaAisPsWirEfEl7fimWfD8MF1ExErstWOpCbmUAR8PtZFQR4vru0cQv953fNzONUeJP/h+LChwSTAiEv5pVl/5PzUXw0VCWxjXtt2KpKdPte4IDx9EMQ0l3ZPRS5B5s407zq7hjEs3r6a3K7fy2OEKEmKLECWivsfaeAA4MFZexGS8LnayTQNv6JvNgHZS6JGWGSfwBP0iMDoNHNzxdIO99o2VYhBNwXgn+xh3m0NwGgs1Nx4ld8KCd0BAgtVBLgQAnD6FREhURe24Rof9YJMINakBwRb2uysBCWVJR3WrUlpUvoIQc9HAe3x68oDLRHerI86FYqH9JXqcFkYtm3CevzZyNMqIbOcJG4CT7afNljbN7OTVcnbNdrnJ5+BANN/gnx9yY9LHZzIh3fidMlXjoN9u25jiBB7Ukhk3mRD2Z4XH20oRdmq69KHWannKudv4IjbOmXnFlAW7JB13UjqoHwD2N7iViwMd8XSz5er6O0V7xvKyBQzy52hE3nrlz1juRPO/EjXQx/7Frb1mcxjO/u35rnjFFXi+yeUJqcUaJMREPo6IMfvDC41DmkZ/Fa5YWo7ObVeh82djQ84/CBfpvpVrrVFrNIIW2LztKgvgKzLQPhjfqL7xiZswXwSKYVWwyuz2w1/y00GTTi49mQGuultV
 wRKWYQEZ
 OYMMT2KOj7cDlu5+oEcD7wfJaVKZTGB6Qe9wznhy16kHRbQ8obd7eoEVpJExBm3MI4dO58Zcq0VW14o94GKwrrc5pHaiEzbIXX3Vl5YJOjXCwo3guQwf7aaA32nntF+YaFblr0jb5POHKY9pI8XhJRUC+0i7PD0Ru+HFsiBxmSk6Qp7QvWi84Eod5NC6y5JmMlAB6zq+LnMB9xeYpBLq4eMk1Tv3TOrDVUvqkva3+KqVR1sQBVddLuhgcU0zCTspadazLPe6pGoimaTvg9D6a7TWgmEmrsggOj3tWhVIkNKJlyK6+miLQSa5oOSudSHVU0chY8u0sZgGmSHT3KcZvzsPshJs6ybsBp45z/1mRkmPhzJrLJ+jZ4+izOSdXQg5jLcQ0Ja+LU+0p/6vWGLAtGVxAiKKpxWkBu3PoD9TzSUYak3/hK5ErHKftNuZ1pgxOmqxURoXTBWJ2G6LMzEyA4SxtNCZp/Oo5E0DOzsE6bEy54kx996FFEm5qJ9bn5akDmsNyrTohPy3YmcNOBCVXjJKjtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 11:34=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> > Throughput in MB/s:
> >  alg      | acomp store | zcomp store | acomp load | zcomp load
> > ----------+-------------+-------------+------------+-----------
> >  lzo      |        1140 |        1710 |       1070 |       1070
> >  lzo-rle  |        1490 |        1320 |       2030 |       2070
> >  lz4      |        1520 |        1600 |       1710 |       1870
> >  lz4hc    |         640 |         680 |       1770 |       1850
> >  zstd     |         740 |        1190 |        980 |       1720
> >  deflate  |         180 |         180 |        665 |        660
> > But that's another topic.
>
> What the hell. Do you know why that's the case? That's almost double
> the the throughput with zcomp???
Not sure, assume mostly comes from crypto-sg re-init the cctx/dctx
on every request (zstd_init_cctx()/zstd_init_dctx()), while zcomp's zstd
init the contexts once per CPU stream and reuses them on the hot
path. Crypto-nondma looks can be faster, but not checked yet.
2nd difference might be: crypto/zstd sizes the workspace
for a 256KiB window (streaming-oriented), while zcomp sizes it for
PAGE_SIZE. zswap itself is single-shot per page, so PAGE_SIZE is enough
there, not sure if we can optimize it.
That is separate from this shrink series though.

> Let's go with that. We can be defensive and just block users when they
> try to add the 17th zswap pool.
>
Ack, will use a fixed array of 16 and fail/warn on the 17th.

> Yeah you can leave that for now :)
Ack, will leave it.

Best regards,
Jianyue

