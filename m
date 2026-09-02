Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51045C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 23:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C436B00D1; Wed,  2 Sep 2026 19:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D306B00D3; Wed,  2 Sep 2026 19:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C046B00D4; Wed,  2 Sep 2026 19:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED346B00D1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:13:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 281F08039C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:13:05 +0000 (UTC)
X-FDA: 85170374730.30.FA55881
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A0C812000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:13:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enMkLhYT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788390783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oANsTqPYV0zfdfhrNmsez3y2Ei2vdqKIizOLng4NKB4=;
	b=0+WrkeCNM1hiRz/mJfHnG147bPk/staEzPMsD//C6JOqzmRTJ7eOThmur6AVYEc7Zi0rQN
	/MJuEWXnXPPux6szCNpJWUUxXoEmBufVupmXEgkuVva1ZIQfZiD7lySYys5tJUCHXLAxkG
	xis2tbTc8fo07yweD8AhyersDvEVvuk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enMkLhYT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788390783;
	b=690ExjOJenyuM7NbH5MIRFD0SKEIBc1PSUEZMywJ0GBmOnY1OB12DsRhSPKogqDEglS7o5
	AnCJ5fmjka08W1LwmmYcLgTAURf3uKCP/7UhvIg/l4mLHThKn9RNqcSJCcchpy+9qqxOK0
	YjoirMIzj9pCX65BK7fSHfw1ZvBfGng=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-382ef647e20so2046195a91.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788390782; x=1788995582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oANsTqPYV0zfdfhrNmsez3y2Ei2vdqKIizOLng4NKB4=;
        b=enMkLhYT6mPeII5yxjafx35FbE1E53E8MajeFW4Bhr1TIcKnbAmKY3BE9sW7Tp2fXG
         5/TDEE3wCDcIEez7D0iK+3UchMwlzwbme0XbaZ5x4OzIDiWI5yd/AJcM7GoEA4IGN/Iw
         CRSAwAkeJLPYiNuK8d+2mSmauYhWJizcs+o0FN92uz1eTL9SyjCeb3/vm7GAT7Kz8AaI
         408CAUhs773aiIN88KidTASdM1rzs3+YhWS6lDRazM2Wvm3PDVWyUnOz4iVqRIHOIkVR
         ge4mpW4LqeKRH9dX5RSFnF4xa4R7Q06ZK+sZTv7iOrYF45mIEqtJajLuP3/T2lwvVgDV
         9BYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788390782; x=1788995582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oANsTqPYV0zfdfhrNmsez3y2Ei2vdqKIizOLng4NKB4=;
        b=MmR6CBqi68wOokpc5PJmvObREbRsQsc7Ad9nqYkfbEi+tWYrC2GCyqmsR1+c3aXHa2
         DJCgWsCewe9E4PD3KeYPZ07aX1BdQ9Sq3we046zmvs8h9xYAsuoRotGmoQ2m2UMB4pKo
         wMPU/JdbscgcysCwyCDSwSCM3PadrKu0Po1O2d7TrPDmLAuViuZJlI3qr3idTgl4abd5
         q6tmnTNpQTrT9VufpPwul+b+4gZni3XPR80rPXltkVWZkulRWnowt5CkqKrlCSnZ3wEO
         5Y6YrhaEkh2b6s8IbjiRGPxcSBb1dcp1y1NX1SZYNB/ksNy8l80oXJ0CNJyCMMAUwNnP
         pIXQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5gSnkYhjyDGUJ7+7HyTqSidnRFx3hsAwRgdJrpNLkO1sDEIgc2BRVR9X76d/Y1gld91Quhc31Jw==@kvack.org
X-Gm-Message-State: AFuF++msPOfBEPJsOlsfkRn3RVPXJY4rZQhdHv/qbCK5wY5lhvjppe5j
	NICvS/c7ISxUqyLiscxdH+FkCaUAwZPOHcAoBkDcOct0qfB2CQM07Hdk
X-Gm-Gg: AYBFou0TS0eXNVLmuP5/zKpSzpY2HjQ+8d/LZGEGb77GctGbeoz6kZAbmGA1ef7F2Nn
	gn6VGQzN8U3oyXyT4D3ILvCZYC7/6OpvBweZvIPprZPQBG7X/aDLG0zubqyqMILKU3oNbOOVTXv
	R28OtfQuWweA7/OC9TFUDZIqSWK/K/ENfPh4npyBsXoxyoQVGd/H807vBFIjOdXPOpBTfpSfj3Q
	0tj12w2Pj5k6/N+oNC29++e7sO1ip+jg1Z52CYmLQuxrVRrYeqRmHbXh4k4GRl0+HauXt4frDPQ
	462biIWANTbxGMdR3PFPZjDZwenEF+3l1VDsg/kSJPAyKL0USOX8LozG9gV7cNIN42mCoEmcmbv
	kZTvg0DRHS2/DxmN83tzyGWZLnBgNJCc1aU5X7W/ysRmF7Vh+LuArsgi8DXY0Sx+OuQRiHIvQDF
	aHb4AsjNWssu36Nx8tD8hlwC7SlVmR3c9fyJpQO7YEJXug/e1EAOwnu1/WR8qUsjtj
X-Received: by 2002:a17:90b:4ac9:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39aee0b498dmr10034854a91.19.1788390782043;
        Wed, 02 Sep 2026 16:13:02 -0700 (PDT)
Received: from celestia ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083f04d1sm1501603a91.8.2026.09.02.16.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 16:13:01 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: allow esz to be set to zero
Date: Thu,  3 Sep 2026 07:12:15 +0800
Message-ID: <20260902231311.17490-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902150301.88535-1-sj@kernel.org>
References: <20260902150301.88535-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9uax4rz64zyz8wuyr4zy8mrwxr7kzhei
X-Rspamd-Queue-Id: 5A0C812000C
X-HE-Tag: 1788390783-133292
X-HE-Meta: U2FsdGVkX19go5NnDXCgnxvQiy0tF0W5gTgkW7Afjf1c5dNA3lz/pqphcpWtOgJ1IsproSOXs7Rj017dx4JMbjfMKtJQXzkie3QOAlMDUncSbw6sHnqlTW9q3m5hN2BD2d/HxYJI8+LI2+zxX2MK5A+WtUpsezc0wrXeokpwI0a/lqJVsMoNnWgCGvLB+1lhy7MVyULGCif3VT+bcG8i9G/ymk/6GdgtnAU8o2hO3BA9pG0SUioFWSMQDe6u/kXEwFeAeUi2GkmN69T66DB44YP4ntHbRg2dlorqM5JnCldrdCFcPyHLPUuMNfUqTNH5wPRNlhm6YeQCkpVe7Rb9/VBGFuDZVLKcXrEoNKyQKNmTxTSxiUj7Yf12SN7McF3krAgyh+uVDeuZwCJViW/CD2y6zILaD4OdmtnjEVDXvpL6wJQUvckpxaNF/dAqWakeqQAa6mwi3ivFN84M9uEPCExbTtckjpQ1feLabmhmazi3cXxhHHUNfbFO/kjqT6lYYb/+oorTHkOxFfkkEXopjpJl1V2na9q2xG1Ticnwpd9MZBIulRuuO7fX5Hon1cagBhEDaQxGYHlOK2Fpp59QctNvyr19X6MbA365igLkBXkGbk2EIy1e+I7qYdO5GcoQknJ77OfYHvVQiXmr4g2VBJEw/pferYq15iEbZB6n4NSCgniEmTxGmFAq+Nl/ewjJWMV8Mm0EmvOQxw94kOndB717dulThM7FxNVteceZp00llu1CgvdGrQo4D+wE/dIO2Wsis65rAdAShs/Ocf7ALvpaqbQDhXTlcpo5NTou5snXCbnM35QyUBejeatdQ9UpzIopVkaJ/BCxUDlyDmpYXainNGpWmqa9oWN3GDFgYYNSh9UkZe8myKzG8Lbj3Vo/sINQbv3vlVb/4j6tTa1FcGXHZuWz3F8DTGdrjv48ytAHLNE8DwASRuCs/7M68c5Zbji5IPlQ2dpgnp1mShb
 xNoNXviR
 uwpCtDwW+TEhRR1+K65Yox6Ccmo9WtGDgsrZB00LgxAOiqT9U3p6TnDlp4TRJ9VrkYUO+RF+UgiNQE6Bt5HE7Hzs9NX6hwcYo+ftoF41vB0ul0BXO2fVwZVIwTMfD9hsjmx49HZraL2eN6WVDUVlDrhSDaS+FzzPUQf62ULpojnJPkSmb/pXA6fJktmaGeF1HbHJnY/I/o/hg/q8dyzkhIlfHjtucZJdG9etwNpUyVgVqAk10lEWlhVR2JdzcXibDsNyVdSMTUme7MAXPL1WDQdzZt0XqogCb6XludT+O2NAtUjJ2jFc00StYxQ2gfhXMfeZlhKlWtOLoBCw2/oIpkaOFlWDNYxESQFt3L8Bfe8QjYA3cnCuawJXS7TqNcoooMQUG15lCdhMEnmZxAUyvn6hK9lLeRt5fNr+wW6v+gQ9su56BULv6jQuP+QqonKSC6S8F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 08:03:00 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  2 Sep 2026 22:35:20 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Wed, 02 Sep 2026 07:13:48 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Wed,  2 Sep 2026 16:20:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > When the temporal quota goal tuner determines that the goal has been
> > > > achieved (score >= 10000), it sets esz_bp to zero so that the effective
> > > > quota (esz) becomes zero.  However, damos_set_effective_quota() clamps
> > > > the quota to min_region_sz, preventing the quota from ever reaching
> > > > zero.
> > > 
> > > Where in the code it is clamped to min_region_sz, when?  And what user issue
> > > this can cause?
> > 
> > In damos_set_effective_quota(), when quota->ms is set.
> 
> Please clarify this kind of thing (when quota->ms is set) from the next time.
> 
> > 
> > '''
> > 	if (quota->ms) {
> > 		if (quota->total_charged_ns)
> > 			throughput = mult_frac(quota->total_charged_sz,
> > 					1000000, quota->total_charged_ns);
> > 		else
> > 			throughput = PAGE_SIZE * 1024;
> > 		esz = min(throughput * quota->ms, esz);
> > 		esz = max(ctx->min_region_sz, esz); /* <- HERE */
> > 	}
> > '''
> > 
> > This is a minor issue, the main problem is that it doesn't match the
> > description in the documentation, which states that if the goal has
> > already been [over-]achieved, the quota will be set to 0.
> > 
> > Original documentation:
> > 
> >     - ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
> >     fast as possible, using maximum allowed quota, but only for a temporal short
> >     time.  When the quota is under-achieved, this algorithm keeps tuning quota to
> >     a maximum allowed one.  Once the quota is [over]-achieved, this sets the
> >     quota zero.  Useful for deterministic control required environments.
> 
> Thank you for clarifying.  Please clarify what is the problem like this from
> the next time.  Without it, reviewing spend unnecessary time.

Noted.  I will ensure future commit messages and descriptions clearly
state the triggering conditions and potential user impact to make the
review process more efficient.

> 
> I feel like your recent patches tend to lack such clarifications and spend
> unnecessary time for reviewing.  If you unsure, please ask questions first or
> use RFC tag at least.

Understood.  I will use the RFC tag or ask questions first when the
nature of the issue is ambiguous.

> 
> I agree this behavior is not matching with the documented one.  The point of
> quota is making DAMOS not unnecessarily aggressive.  Hence it is designed to be
> set as minimum as possible.  How about below?
> 
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3485,6 +3485,7 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
>         struct damos_quota *quota = &s->quota;
>         unsigned long throughput;
>         unsigned long esz = ULONG_MAX;
> +       unsigned long esz_time;
> 
>         if (!quota->ms && list_empty(&quota->goals)) {
>                 quota->esz = quota->sz;
> @@ -3505,8 +3506,8 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
>                                         1000000, quota->total_charged_ns);
>                 else
>                         throughput = PAGE_SIZE * 1024;
> -               esz = min(throughput * quota->ms, esz);
> -               esz = max(ctx->min_region_sz, esz);
> +               esz_time = max(throughput * quota->ms, ctx->min_region_sz);
> +               esz = min(esz_time, esz);
>         }
> 
>         if (quota->sz && quota->sz < esz)
> '''

This solution is much better than my initial approach.

I will incorporate this change into the next version.  Thank you for the
review and the improved fix!

Best regards,
Rui Yan

