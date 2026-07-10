Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCFA6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5206B00AD; Fri, 10 Jul 2026 17:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCCB6B00AF; Fri, 10 Jul 2026 17:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5736B00B1; Fri, 10 Jul 2026 17:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E05B6B00AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:25:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04EAF8F97B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:25:39 +0000 (UTC)
X-FDA: 84974148840.06.6654D88
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 17FE0180003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:25:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=LiufzIh6;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf16.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpQVACRA0YQHSvoDEslBHd2K3n2s5imQlegmnY3XjcQ=;
	b=60n4VFr6VxXa7cTFnkDwAXqRCwTS0k6etTVjuytzv/RB794ZRJ3iy6dB9VtJnAtG/2nedH
	mKwZdetZe1uW9PzLzywPFIm2q/dJwxvG188L0RV+t/jlLXYeXKujjazzxGqN+9HbrRE8LE
	FRDLORZHC0JLBp3fCAjN1K9HuNDEB3g=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=LiufzIh6;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf16.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783718738;
	b=MHhlG7uj33/+lSpzG2pUkTmyCg4bmWLgqaKnM7Pi4YW0h7SPjBq/oI8QGuIOxlzyIZ6JmM
	O7x8oOqpaTRp6w4SsfeWmmtfEjwVMapllIfqKsE4TKqCJdX2k/z8DWvJ6KPK0HP/g8NUjT
	Vg3heJnSmOdB9JhwE211SfkWk9Y/pXM=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-497e6956acfso1357825b6e.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:25:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783718737; cv=none;
        d=google.com; s=arc-20260327;
        b=kI1HwZeQ/hYw5Rvnos4CNndl4mruvAOjzg1pODu8MAbzu6tr/T3H/Oj97p9o6/kZKr
         VRrLDyHlKyfQeiGP3B2oWBQKFqZ7zH8lBYBZX/ck430wrSnYSvvC2MSAOIU7lF4Qvafi
         Q3GEAB9eddCRWaHgfUhedmF8VgDQy+tpbQYEUpd+4OZzxDCLKR2oPDwSYPhOUUgRmssT
         fmSuCTHuYIcIb41OMluDq3W1TJ69lBAsQzTNKi6IchoeNYUdjZeIhQ5DRgHvMdD2NXPc
         hUKUHtMEWUHHg52uj61qub6NjyfrT1CrChtPnSivt9DCUQEYQeeRtENj2iN/w0z7nHNc
         1m8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cpQVACRA0YQHSvoDEslBHd2K3n2s5imQlegmnY3XjcQ=;
        fh=C736WfuDlm/rMzZl9g/qGLfzi5q+4qnBsA3kdegMpGo=;
        b=EHxrH3TNE9L5IC6Bol35zWEwVfdx/PCWdvI4DQbpwEH0T2lwuZ/fFV4DkE8bUaSuid
         Kv+v28Iw3l+3RPKVNtWU2FlCRQQ7mIH85NqskeMRoI/v9L7ti3W4lx5Z1GqVacgXbzPZ
         bfiiiRuaj+O4CBXi8gDOHInqwByznw97dRXMDfP5+7A/JddJ0b3VSp2PY67tjkh/cu7/
         F+geWlMbODH4IBGFMDCLQNjW2xXBPEZTVWzcj4OcXU3uOVwOSukif1FaUmO1IWYOXDOz
         n3ng1i4xvSm6IhQF5KxDOdkZg2i3wZIla71K8ogK+qItyrgGbqtJPoh8Rw25m6TtL+Gn
         Trhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1783718737; x=1784323537; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cpQVACRA0YQHSvoDEslBHd2K3n2s5imQlegmnY3XjcQ=;
        b=LiufzIh6qGNZ0aCd+7ZQ1aTROew0Firs5tkmrEk9kg5zwX6JnCwby4DS1Zy2y9EiIr
         Ll2uD3kxfjgkV10RcRit9r+ydTP4yNWhzfvQMk1qAOuKzb9BIj41ENVPx+NIfk5qYFZo
         6Vm3Itz2RxQERmM2Uledx6HEG/xYBfPMrH9jfLsL8/hWYnEOUPSacy5BBYrPxrRXidT8
         4fYaRuOWqnLQ12nACVKJGTwWUkDmXyILEJgEAokRtEJoh84koDUqzuckEaQ+HrFLvUSm
         nzyhQX5N8ybTPx6MpggZw+rnz3DE7dvvDvvmeSdJsOHvOBO6ylh4IMp7b7L2XvDEB8gy
         D6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718737; x=1784323537;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cpQVACRA0YQHSvoDEslBHd2K3n2s5imQlegmnY3XjcQ=;
        b=RkAfNyhyw1y+Y3WCNetZRKw9fyIplGyrpv7fv8yS+P+4EW3i21BdgX4jzdNac4qo30
         nQcTBkPhBaQWeCIqPkGWoefTfkSP9qMw/UYlNFj/mb9tpyRqMdGDXuZbLCQNrU7baQky
         3Xp0FgYtWtEpu0U7UlJeZSTtLIcK5qIjGoCik4qflIPkZhHAYkxMGQqtV/g+PRgf3bnM
         mqPuHSGHPHf0sNyhXy0pRVHTk4AY5iKjazmKQFYSpzYgIJeEcPyQp7NIZKwEvgFfxom3
         BXXBn02LgrehgzpECF2hs/Tl/3354CxWfreScKoh4Uqch0HMB0wuXpg7nKnvaTOtfkUL
         HcPg==
X-Forwarded-Encrypted: i=1; AFNElJ/0iaQPT6ElO3hnWdQsjD1xDJvKkrQLNdmYPCcnBYPP4gQ9NZ9tqyK2dKGhAPW6HERq3cs0roMG5A==@kvack.org
X-Gm-Message-State: AOJu0YxcEDfc6ZXwzHDEl2K9aLlUL1wActzaoBIUpPYY2zhb6Sov1fg+
	GPr6D/tm1A1nFIonS1L8dINuXfPWC8JTNdEFEj8mRP9jOR45glQWFJZQxSSknu6MRcPRUFcHD7z
	DU7RP83i5jcLOTAbJ3Z5m8i8fY2PYd777W898iJ8idQ==
X-Gm-Gg: AfdE7ckGhuVa0ZV9MCRV2I4wDTKUgVxdCN9yAt2awrRNy6qYvLDdGVpj3cmEVCzJ0rz
	9jHUu5lYgTRyevWDbWHLcwgUXzGjsMeOObop4oY6uylfOxFDjydxNHiYBL00izr0fS/J7KBVazd
	3+laiYx5Im35evKV1YPBWo9QSa86iHWwKE6GMa7C4NDekHflBDz6JKtSz5myi1iDNkdCVY1QUrO
	cmZuke0YNaKidvgOPTJrY4wRsRz14MDpmUOQde950zv+T8EeEhB1PNwCeg32LeKDXtd1MWGCm46
	nxARmmaOeTThEvA=
X-Received: by 2002:a05:6808:1a0c:b0:485:7c46:b866 with SMTP id
 5614622812f47-4a40ef57435mr3103342b6e.16.1783718737133; Fri, 10 Jul 2026
 14:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
 <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
 <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
 <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
 <CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com> <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
In-Reply-To: <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
From: Yunzhao Li <yunzhao@cloudflare.com>
Date: Fri, 10 Jul 2026 14:25:26 -0700
X-Gm-Features: AVVi8CeRviw_Gpi7oUwkO6qkir0oC48PYpt5DImSLkGaT44u7nQEerv0qoLy2wc
Message-ID: <CAAnvDSwJqEGDJft4bL0HOJfqOqiph8L0WuMyGb2Djgx4FaEk6w@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17FE0180003
X-Stat-Signature: qtgwaj1hhzww8qkzzqk4afwus1zo966q
X-HE-Tag: 1783718737-654387
X-HE-Meta: U2FsdGVkX19MTBruzSHGaz4gKFEN703SXKHT5cSk5eSiHRi9CeZnzwFuWbCFGNHEIpog3AuDDJ3Cgnwzd8ZLQiGIB3aebfZE6WLHYVyvDfwZYhSrZ5AlIp1abVg9bDD++3MfeCLmwOhcsR+PoVNp36xWXaXmtjRjOMgMPHNaYOihWDGzTI9qYxXjpPez9VfDo+rB1zFRXZv6YgAaNq41sDlvsQnl0jp+ItyC7Jr9337LQB+RWk1GmSgX8B0t1hS+j+XwTEL9vkkm2h9DJXzWRtNNQS3IEmJkl6EBgS/S9B+iZKJHoQkQkCtmW8DEmMLWcq8tKRFfxuoipNKc9uj7Uite993/IrFzWnHdyKeWmJUzVn/22DhEhjdz556MP6qhBY5YthrQBszyDLZ50UQQkZ25y49uSdJ1ePmEmFQFik0dV8hWRgOfyEBKfxuP/jg7OsjY2Ew/UdauMVMWnLgH+4Db9d/NBzpzMUcqLy/Xuwj2oyUZvoweHuDQopkMamcM3+av4SinuI2jPWCfEVJMEH4qWk2R4RDv9OSqLBns1LpYRAB7Mi/fDaf89YPITnzL6HLsPxzJ69sEBOayyax0Qdq/yNTfW+5A5qblWT1UQor+7QaBhwnKurcmo5+IljRNAIu6emZu0adJ2VQINLxdTVH09U0FPLkbBGDWsphWu6+73L8YtRiuIoS5Q6up50708c+LD15HLiglr+3nCZKB+WOl9FTjeWlTSVFntzF57rgkg6NFqosF6fme7Xtibv4/+0AO/29n3r65Lyh900WiKrgbA/6Ky8HR5rmaHP8Ao/aqzodTjXm4PW9uXSsAenJaJBgqFDpXSEvax7UlPMUCUxGFlIJzcp9H0qgoEl9syFj4rw9snPXpjkPaUdy5EUoNacbN00dOe4KyfrkfKfXB6HT3QizNlmSLR0wOhbOVELx9ZnwZloQg0cxR/OSslBzPtwpwNC7RWkkmXgNAPwr
 gQQa53hf
 PiB2VHe64AJZ0BnvFFXn4l3T09gfqcYqkJEeaju+4MMlhxoaEWTImroEEyE3/h2lnBQLZUnWfSo1E8seUZpTE2CbDO3rIkhszIyvkL0tqd3XpDjkwH24VxL+uHiGILBf060aKpHVbhHhy0AaO0oeIzyBj4BGhv4m0HrKlt0E80pV2sqhZ1MXN2sma/qZALb9pb6CvibTthkODfhLxpK92aWS2j+KpQBBEiAHRrakUQOsZ68QepI/poNcHz1tNvxUseDFGmR94DIRZnJZRrac5mh+wVNtpU7gjxwQJMv5rTM7xR6wU395CprXuIgyfHtDDO/Np2Mk3k/MsHI3gS2DNuBA4JedlEpvfKo+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:27=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Jul 10, 2026 at 9:36=E2=80=AFAM Yunzhao Li <yunzhao@cloudflare.co=
m> wrote:
> >
> > > Yeah the per-fault latency is exactly what I was looking for. Seems
> > > like most of the faults are not faulting in the pages written back to
> > > disk, nice.
> >
> > Yeah, at least for our workloads the cold entries seem to
> > stay cold.
> >
> >
> > > Would you be able to take a stab at eliminating the flushes as I
> > > suggested above as an alternative?
> >
> > memcg internals are a bit out of my depth to be honest. I can
> > definitely test a patch on our fleet though and get it verified
> > if someone picks it up.
>
> I can try to come up with a patch if you can help with testing, but it
> won't be for a week or two. How long would it generally take to verify
> such a patch?

Testing a couple of days once we have the patch. The main wrinkle is we're
still on 6.18, so depending on how much the memcg code has changed
it might take a bit longer to backport.


> > The ratelimited fix in mm-new is working well for us in the
> > meantime, so it'd be great to keep that moving forward.
>
> Hmm we can keep it in the pipeline for now and perhaps drop it if we
> can get a proper fix before the next merge window. Does this sound
> good to you?

Sounds good to me.

