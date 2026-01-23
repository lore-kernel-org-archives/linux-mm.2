Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FCF8D7788E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 17:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C841A6B051B; Fri, 23 Jan 2026 12:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31DB6B051C; Fri, 23 Jan 2026 12:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A866B051D; Fri, 23 Jan 2026 12:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDA76B051B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:14:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B0F1140412
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:14:27 +0000 (UTC)
X-FDA: 84363877374.21.F0828D8
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7218318000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:14:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4GYPYDtj;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769188465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pyus2eAL7FKDQhWIyVygHBSccAuw4WPN19E7Fh2kf3Y=;
	b=UfjkjeklygWxHCFr0kY3Fny/310N04y8aGvWNN6jEyE4WYeuAB94mDVsV9AmrihzZuBFNw
	K9/JUjtId9cyMFS7RoEC4bRLWv5W8RKvBGLO3OLgskUgc10KSr3d2dYxY7QvgNX4VY5r72
	0K6bVR8nrjU2PnDXDfFcb3k9jFdZiqw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4GYPYDtj;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769188465; a=rsa-sha256;
	cv=pass;
	b=tWoHywOfI3KQhr2dTDGyR+zs5pscF9ARc/Kp1FenWWBmD91xabcMUm/GUch+E9pRvt8SK9
	KOfpq3fwvu/A/m1W+Jmkfjc3+whc+CyBVlziGxhJ3Cz1IyOAIyJdvm9ONztqekvxGZhHLZ
	z+TzjT7ygUg8s58Q9HgYSQVyeCmKMTs=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c1d98ba11so2239321a91.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:14:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769188464; cv=none;
        d=google.com; s=arc-20240605;
        b=PEw/BM/FHhTmtsefgd5uvEPlomADWMB0M13lnEetZEEsZi9tWJUMNux9/xYkYShZaO
         UlYanjgnNpqd8208sBeX/JFqYbd9DcPAVdHDyXZQXJhi1RVFIs0duA8IuYpyHTn1MiMa
         lr/mjWxz0whww4GUWWxwl2ARmqDAzionkuOva2ZDWRDzzeEpXymX5c8gle5erK1Sa/iq
         cSpm+Ad6lR8Vl2G25punDAPT7+iByZ4ZyKJhk0Ev4mm+BvsAz4z3krbSe2Xt8fEeGhrj
         2AMsvqMqgzI4fU8WiBT62ELqbHIY6x75ahUKuKake6cwnFBx32MkKcu9fx4thC6mZQPV
         NqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Pyus2eAL7FKDQhWIyVygHBSccAuw4WPN19E7Fh2kf3Y=;
        fh=7exeWzo6SihN5o/YJ+pi/Ea9NH6p6zmGZfMzsM345H8=;
        b=XsNAPF0uDO7WJxwhKZfMhmLLkAW6Iwc51LfbEWGpWD5Ui0lim8X3BNxgb4WjTU1E0x
         SIuLgGgaroU2VJoqN6L6UzzreUS8U3IDt9Ojg9qR06vl5szHv64DUAgthFLNx4DPVudz
         yNf8wusXoi7QDCS+RpcthrmIzWx4ZqP0LKKYJLha/LoHP7kQyZ8qa4mWFRx6rlpKDlxC
         QbRi5uO9zBidI8O0F6kCMwWkMmcSYBVzZPk9H62DhUv4DJjIKi4hrrZWAfA0WIgRKTvh
         yD83F501sBdhjUV75el6fdbpNyNIDbpQ32ScOg1A/BKKuGBdJNwju3V9dwFt/0gCB5HC
         inFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769188464; x=1769793264; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pyus2eAL7FKDQhWIyVygHBSccAuw4WPN19E7Fh2kf3Y=;
        b=4GYPYDtjlViMquY9of1IBGwVgu8YG9dkxnNzR1FVJ/IaUWEwBJ5RP6X8NTB3S+HVqp
         +TEq6LvmvwxXi9Duz3mw6frvbO8TZyN7vmemXGGyyvQ0g+pdg/yUo/XlHG3AaqdYJlI0
         5P3RqqQQLIUUBlkEJSab0Llo3FYIVZIMBzlRdWXKVGko1qpmXtkPENsSwEVpKngyc/K1
         A06qHhKgMJRrmPW30F5Ws/0R2LpV4Q0D6gbitekRLrHy+PxQ0mQ9mAyU33uPA2KK9RYK
         5oTBO6SdowEucVw3spCfBaf7zIGE31OYQJegD6IkyYS3u4NQNPh2S1O55KxInTUMmKrp
         Fauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769188464; x=1769793264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pyus2eAL7FKDQhWIyVygHBSccAuw4WPN19E7Fh2kf3Y=;
        b=mtITA4N+AuE8Vwf+DK6kUoCMPlmnyQYn/JeO8Jfmx8qkngeY4mn79Tbucj/ZhSTrtc
         jjMY5Y1JMVwTbHbLZOawlLgEOXAYJwhXefxFz7UVsHUN9c0uHoRyfEvxj9NwB0M5CHWm
         ua2kwfjgHtlkmrhBwGml8YFArqYsuKjccrK8ifjFJBRfmnypvHmwEvKrMcJ/BtAassh4
         7eHDP1OtyKuX7ra2vRxh5v5eq4DKcyGCcE+uEQo6+ToCGMUc1U5Lg8fjBqAmrtPXo9wr
         pVZ7riyBm4AYLz89XxsXrFp60scD2s2JhKDrFc1KPO4eabYZg8VQ/eLiNjB03ibkGF27
         FCEA==
X-Forwarded-Encrypted: i=1; AJvYcCX4Cq4AFQqnvzBdFgT+WzEeG80x5OnPVwdpRWfrPUcQRBPZrGSmMl3mV8FIZdyvPiue2b01SD//Cg==@kvack.org
X-Gm-Message-State: AOJu0Yxa9LEJBIaY3gA7PvKs5lwtrnaoCjGlod7oItZLs8mtTO5wfOFN
	FwFrD+lVatXTQD0d4j86Wh/fGmAFEswpY2Vz41Bdpat4cSZbWquPEzO+8qWWuMLi4H7OMiNNSHM
	BAkQDpLs0Cl1DqmpYP9pIUDnUfjQlDDOJ6sKhAvwe
X-Gm-Gg: AZuq6aLuKgbTjppnTGeC2wGRl4G2e1nORJF+NAaQeUfrDGYk8Y4+DrdgyzfmqPz3Cp0
	4WVbC0UGbayMgVf3j4yqqrAr1is5ALMcE6HWPmHL9Ft0ECppKNS+OsqadGSeiX98E6W/mX6v5aP
	8WPBSOKlYOiaIKxgbbX2z7Sc6X9c0MDKNOMJ9RV6MUz71x4x4ApP2NrMSX996B/KOREGnTj53ka
	1K0L3uo/MdYvuTzQc9M1vKPIC1RkvAvHRaoBsk6p0aIPCR+UnQcvnf3arhtmy74NbKGxHvKNLXR
	RudrZMMQHifpwFSTlo27yAe1CA==
X-Received: by 2002:a17:90b:1348:b0:341:8ac7:39b7 with SMTP id
 98e67ed59e1d1-35368b4001dmr2872028a91.25.1769188463940; Fri, 23 Jan 2026
 09:14:23 -0800 (PST)
MIME-Version: 1.0
References: <20260120161510.3289089-1-pimyn@google.com>
In-Reply-To: <20260120161510.3289089-1-pimyn@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 23 Jan 2026 18:13:42 +0100
X-Gm-Features: AZwV_Qh6jled3JZeU3ngx8ww-lKGy8zUdUXhvPlVWuqudohIm--Rh3iTGeTZBa8
Message-ID: <CAG_fn=WTEM5m7zcVO+S74JNz2t3nYY0vJNDyRrAhuHxrvHCv9Q@mail.gmail.com>
Subject: Re: [PATCH] mm/kfence: randomize the freelist on initialization
To: Pimyn Girgis <pimyn@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com, 
	kasan-dev@googlegroups.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7218318000A
X-Stat-Signature: uh59fgu41w8umuer89atxisxx4hugag8
X-Rspam-User: 
X-HE-Tag: 1769188465-423729
X-HE-Meta: U2FsdGVkX196bFmujsBN/bmymixT74MsSjn76Qne557Y7SRs59g5st5PM3j/skh3FjxquPz3Xx33FxHvvHhTbsFreucSq6qYBJNwSc/6hpInc3Gofe/Rs5cQLginKNF0s+vtNCetxiGL0eymT/JGHXh4PpkMJbZeHCC/pHiYUQa1BMyJ3Va4NjzDePixTKwH26mxexAuwt0bug9sskiKTRUgkRK2mOBYNTr/4dSUPlIxgBHmk3Dv1vwd0lFYke2KlTbt3bTtHOEdlB2ljtncqzIdv/G2uaoNNCvjn1cWaLs7uZzruVpgCK7xIIaXCM2YyVNF/wb0oO34LFSqvICl9ptJJbL0SSYsONnfLBQdJt74RLeXrOypxYlW2wtijUPQfrjwGbINemiswQqHnGhLDgXXc7JR+LvMiy1FRfxKzIJlGBklPssSoERw86gPwzpQfP2Oj+yAodmbWB2zHUivW+MVIY55Hlv6PZb3JqU9SVdvfKYFi3ZHlvLsS1OdkBYLtPjdQY0Pn9fhDxwbkYdx8HEVCaGAGHB20J+rH/HLyl2otPYWVOE296jsD2F9vr6d8rlmKOaPp/skRYnHCmCeU2wG2xqZi1V87DRYudf2ZOZvX29UTu77G2XUPtUMPN2GyHTaB5WWLzIn9Zr3De5R8M/9XhhQo9qfC+vp0K+4cV1jK/gKoJ6XR5bPpqBTiBVTFTg95+PCZ8rYWHJriN+iH8MtLE9bQqYeANdvT+djOKB6ymiaXRqDKKjt3b5iqjJRTAC4OzPWD9x8vIRqc4tFxhWXIEfBhgkBX+DYyy3NHSFnqwNbvoQwT/9vaDRH72FNIKIkw2WueWLN80aq8Uh7QptPigrWWneE2U8CfLlTlKuxZeMx4gE8Kgf3rj1iu2ppJPkgAPaYOcLB+adeodpCOCWZ5A03cjo4d3TN5ealWq7Wvdh2YhP/8+tLooSn3y8l95uyYlSkZA8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000010, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 5:16=E2=80=AFPM Pimyn Girgis <pimyn@google.com> wro=
te:
>
> Randomize the KFENCE freelist during pool initialization to make allocati=
on
> patterns less predictable. This is achieved by shuffling the order in whi=
ch
> metadata objects are added to the freelist using get_random_u32_below().
>
> Additionally, ensure the error path correctly calculates the address rang=
e
> to be reset if initialization fails, as the address increment logic has
> been moved to a separate loop.
>
> Cc: stable@vger.kernel.org
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> Signed-off-by: Pimyn Girgis <pimyn@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

