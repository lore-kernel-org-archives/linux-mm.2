Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691AED767C6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 10:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F146B0088; Fri, 19 Dec 2025 05:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66E66B0089; Fri, 19 Dec 2025 05:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49DC6B008A; Fri, 19 Dec 2025 05:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94D036B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:25:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B5EB1604F2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:25:54 +0000 (UTC)
X-FDA: 84235839828.01.B9A2555
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3C89120003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:25:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XY0E51TM;
	dkim=pass header.d=redhat.com header.s=google header.b="X44/8Vq4";
	spf=pass (imf29.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766139952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjDiJjB7C2v1UtJ+RkaYpL+6MQ9Nkb3DziS0e1v2t2k=;
	b=ynmV5w7gDt5sDOIvVz5y/SxAY17gyp9iCgTPtze2OB0QexcB6KK7y6hKVG+9/ngzNi1BOb
	o/Jan3JtQ34iaCiYjo8Tn/AdazeBFHeI5WtVyrhOyVT0QX4rxAjt2Hx32fTjok230jTlx5
	U0rFdpeXwA16zM2l9PJmowgYNOGo9ZI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XY0E51TM;
	dkim=pass header.d=redhat.com header.s=google header.b="X44/8Vq4";
	spf=pass (imf29.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766139952; a=rsa-sha256;
	cv=none;
	b=1psC9EXECXucNjZz3sD0c01gA4CYQJH/R/2bEE6B0mz9Mm1qzr7fVGJdOWR8KvxRPHwvzP
	2I8f8P5QAhPzxV7hn/MjxUBgDjX22jWJDOV1LOvPwe9w6U0ZgDdXxpN+9gfVVJHnoEUXee
	y1dHMc6vXFbOLER0Kc3G/XiHBh8rJYM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766139951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QjDiJjB7C2v1UtJ+RkaYpL+6MQ9Nkb3DziS0e1v2t2k=;
	b=XY0E51TM52om5sttWahtQqSsOzXtJz8LFQssXjIM79ZQVWEy93/QgiftO1peyhRx3ESioK
	PHZ/d8de3cEYX6Z9qju3PR1wGIIjVwu7g7jl5ZhYTOPa8FSWQGARo/lGCEMbigsUOis3VH
	BxIUgbW2dEtH3dDerpUyqvBxOtCvN0k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-lbhj_mxUPXChz_G5NJSeRQ-1; Fri, 19 Dec 2025 05:25:47 -0500
X-MC-Unique: lbhj_mxUPXChz_G5NJSeRQ-1
X-Mimecast-MFC-AGG-ID: lbhj_mxUPXChz_G5NJSeRQ_1766139946
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so11666875e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766139946; x=1766744746; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QjDiJjB7C2v1UtJ+RkaYpL+6MQ9Nkb3DziS0e1v2t2k=;
        b=X44/8Vq4NZuZRQk1fdcujLPHxLHikfphO1FVYaUi20rufMau2Y8+L7onPuJWWZH85O
         6fKDNWC9h9x0Y/4XA3f/BpYD5vToypfy/zTfzfr3NXTvcHBfW5BWZI7ymgbtsywHqbpU
         O/c7KJgsZL9gSzrVTnHV7fJD0jKKqnmp1Ub1WCZ9gBys9kM0pQNj/YnNQKdd6ic3sFLq
         lFhLfvIKmLLGSSaruOgvj/MdXrcH6BNGXTdTkG5ZVtq3Mo4FV7Vglwo7u9rmfM7tAxf3
         o2f59QkPG3ZJdCJ32tKx39xmOhTNUcDUDhXmVRHPtW4zPQFNe/mOcWHb1e2oAKsaTqE+
         4aIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766139946; x=1766744746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjDiJjB7C2v1UtJ+RkaYpL+6MQ9Nkb3DziS0e1v2t2k=;
        b=knCe+qtkNWDPHV9VAG66qYjCjazxp2g5wld29cXCcF/+yaEAWlzpCYxCsXG9KFM3ye
         8B1RsK40HMiVZO7Vr/kj+tIsY3XF7357B+8A0j95Hz7CSNMjDviM9zQLbRiHmoyNGmvj
         pKP4jv1l4AqjYuL8JQLnHuHo259bLKWJ9zpj5g9mVa3CWrNKshrlslzcThBREYM54BwM
         IWe5wIR+T8+/dbQN2blq7d0CM8mxi/Cjfr12YVPqhlxTkO57nq2ZSlWGWvGFdkh6s6Rr
         4/CnpxQyZV2FMxdcAkByv1brkD7yEJKjRLsMHftYDS/NieZ9shQoFAQZU1/BvyQvXb6v
         5ZrA==
X-Forwarded-Encrypted: i=1; AJvYcCW2xqzzuM9IJuYPLY4CCJkS/V+hMwkrA9Eknx3WXcZaD7CrixjScjWRDdeM4yXQEbNaxV0oA27ANw==@kvack.org
X-Gm-Message-State: AOJu0Yxg7iSNamNhFWdD+QukQdzk549snp/Kb3B44CIPUyBy9WlBkEd7
	6vJ9OJ5XcRj3Lmn/m0l/uVojGsUlw51Ds8qXDltqMztESxRGEIu+bOqkxJc+J9rltvG0dKcye7w
	mgIfj7F5fAHT8TlRpiNhnpFxe2pu3Y9fMlyRcs9f4Y5/dpOp/ouzT
X-Gm-Gg: AY/fxX7PTb8Mwhjypz5zXKYhqhsIBcOQ1Y3E10tkC50mjINn897gjPGkclWqYTTU81i
	4EEWek7+PxrgitmhhLPVpWRPrOUVTR4g1g1HUKl5YtqP8Zo8/Wm+nfWL4pmvs05pVs/BXcbUUQ5
	ByP9UrK/e/4aZ4LAkOCYMiDk+Gem0F/FFiH4hf1PdtzDdfTf9QXVokQEyoWceqX/rQQG7BWBlSt
	3t+Y3SglZydTYC8xvCnklYWdkWRN4dmnX/FNabFfEh7P2R+hYx/j9JLuUQXhTu4KPNXUywFc+r/
	N8OcWx4fCWnTLubAnuqDAng81/hvuWtvoTbmmxeMkKmE48h20zD851A6UTnz3Q==
X-Received: by 2002:a05:600c:5248:b0:47a:8154:33e3 with SMTP id 5b1f17b1804b1-47d1958958dmr21132305e9.28.1766139945698;
        Fri, 19 Dec 2025 02:25:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFagDmA6mPBXBEAFzxJYNGFzP2GgCwlY1oy9ixI0iy9zInEz22wLjFWwqDhC49txteMc6NoXg==
X-Received: by 2002:a05:600c:5248:b0:47a:8154:33e3 with SMTP id 5b1f17b1804b1-47d1958958dmr21131995e9.28.1766139945121;
        Fri, 19 Dec 2025 02:25:45 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4e91sm37190635e9.13.2025.12.19.02.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:25:44 -0800 (PST)
Date: Fri, 19 Dec 2025 11:25:43 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, 
	Eric Chanudet <echanude@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
Message-ID: <20251219-large-daffy-monkey-74665d@houat>
References: <20251211193106.755485-2-echanude@redhat.com>
 <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
 <07cdcce2-7724-4fe9-8032-258f6161e71d@amd.com>
 <20251215-garnet-cheetah-of-adventure-ca6fdc@penduick>
 <ef52d9e9-6abe-421a-98f8-f96353652e1e@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="5d5u624ftgk7q5qf"
Content-Disposition: inline
In-Reply-To: <ef52d9e9-6abe-421a-98f8-f96353652e1e@amd.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3C89120003
X-Stat-Signature: u3ox5djto388q8ae7sjh3h4kp7yga74n
X-Rspam-User: 
X-HE-Tag: 1766139951-290743
X-HE-Meta: U2FsdGVkX1/lSekyH/933Ed8/qLO8lNkxfwLMEkvJ2hCNbeq7s6i4HTc1i4cMITFU+ID5OL3L9HBCiS7I+n23Bll3zStp3ZNXeTl5zmrWt5J17jZOFldiAWGceJI25EY8ewtx2YKWKFK1tY/gW3WkA0itpv2to2i3lCKTBFy9Q/52vmGofaTZNEIWpsco3/uQligEwGvJG6espTipSCyi+TlO6iPAs0axDxXjxLx++/9v21/wCOSeesBtC1kP86Px8GBqzmAoqKEFc48F0IN4QPvLOPA+xLkwxLF8ac96Xbb55eT/y7MTGw9DTG7us7k4JKFB5YMZQALpOeieed7GpB10gNxXuGXQepsYMizo3wKGoBLCXjlBXgwY0qPeGmLZBhtYeKHog1EyAMZVNdfPi/WpoZlf4flLDy+j59LL5prNw7v457p/N3v4TryAJ7A3enQZG/0VssYnkZe7uV5x8QejBT6L7kQm2wjF9sBAxf+iPhv/P/otJitAOgd+1p2YngfUi282c2kQIFq6STHuRQh3G14Ku3dNTVNFv2lUtuICcr19a7KC4rWWrlXRyq0UHaQk2cG3SPuglJyPmRsFFJ4uMkm89cj1ciCNxezQzAhUpB3j99Mdy8uQ0VyyUg3HSFKVAvedvE2eWcoA6iMis2Rz64CnXt2Zh9TwZY3Nlo2teZuperaG0wi4AG2W/ECJq7STB9HnA+WDC8l2Ba3adMiqhUXAy9nHRdAtiwoXdc9qeyhf3EHIIXIvKT8X6jNDDJEGKIoOWv7V9jcHuyqJJ5I4IWFQQ2+SEwQNlNDakaw108zWsY8bffSVLVV+zVLFxjblOOgLP3p7Q1HxuS0PndTh9Jxs1vd3DCyQ8C9ckjU06hnsSBn+BuyHVleqVtzqVF7oCRvPFhhJvOKAFV6QeLKTEIKbL/T2fD9fzKgn2ugZ0OogwL3/e9ABxZkA1BMtZjwDeoX40u6LLfC7/1
 wQXOTGUz
 4uF+zE6un2GdoXiIUdNkLkN8pjic2hm05Z26qjM448In4RKE4UwDQY7fW9TTqITvSFXqrvNqGdHY+GAnyODJdvvE+B27a06GkxUoncju3Nko/AiRTNElC5oaP3x+viQlWlJFdJhj8eT6I50ItYhKSnGWIPzsShY91utjg0oVl21jzc0Zjm2btbT8BJ4yG9rK+ZtmF9D78HkB8KV9d7thjiq+P0CF3JA/frPVNZjr8z4iHv18137QqMwl37G0QdVrRCuNqBQa0AxU0IBZJcODFcnk1rp/GNs93Y/n2/l+8L3h1nmfinNzaGFrCtfrdcW/DbxkBpyLuf1K8kO+hIJG/qftg1rDzPcSDZx1ZrNGrclb7qBGhKzBZZcUwRetB6kPWOIBWIi3T50/vBu5KhQIYE/SBuVwuR+7EWzfNkQNaapm27C7f+dGHwM4agH3CDmbpwWd3qb4BL4yT5kI5DusLm2b5YTBwHGcma14abZLelz0WvQwh3gigVQBIWjUaQcpnj11NssmSPAUE3/ys1LHxOat+t/a31tvkvFMp8EB1HRFtQ4MnyulAqfz0k0DPB6EPHVALtBtD9OGdCvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--5d5u624ftgk7q5qf
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
MIME-Version: 1.0

On Mon, Dec 15, 2025 at 03:53:22PM +0100, Christian K=C3=B6nig wrote:
> On 12/15/25 14:59, Maxime Ripard wrote:
> > On Mon, Dec 15, 2025 at 02:30:47PM +0100, Christian K=C3=B6nig wrote:
> >> On 12/15/25 11:51, Maxime Ripard wrote:
> >>> Hi TJ,
> >>>
> >>> On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
> >>>> On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@redh=
at.com> wrote:
> >>>>>
> >>>>> The system dma-buf heap lets userspace allocate buffers from the pa=
ge
> >>>>> allocator. However, these allocations are not accounted for in memc=
g,
> >>>>> allowing processes to escape limits that may be configured.
> >>>>>
> >>>>> Pass the __GFP_ACCOUNT for our allocations to account them into mem=
cg.
> >>>>
> >>>> We had a discussion just last night in the MM track at LPC about how
> >>>> shared memory accounted in memcg is pretty broken. Without a way to
> >>>> identify (and possibly transfer) ownership of a shared buffer, this
> >>>> makes the accounting of shared memory, and zombie memcg problems
> >>>> worse. :\
> >>>
> >>> Are there notes or a report from that discussion anywhere?
> >>>
> >>> The way I see it, the dma-buf heaps *trivial* case is non-existent at
> >>> the moment and that's definitely broken. Any application can bypass i=
ts
> >>> cgroups limits trivially, and that's a pretty big hole in the system.
> >>
> >> Well, that is just the tip of the iceberg.
> >>
> >> Pretty much all driver interfaces doesn't account to memcg at the
> >> moment, all the way from alsa, over GPUs (both TTM and SHM-GEM) to
> >> V4L2.
> >=20
> > Yes, I know, and step 1 of the plan we discussed earlier this year is to
> > fix the heaps.
> >=20
> >>> The shared ownership is indeed broken, but it's not more or less brok=
en
> >>> than, say, memfd + udmabuf, and I'm sure plenty of others.
> >>>
> >>> So we really improve the common case, but only make the "advanced"
> >>> slightly more broken than it already is.
> >>>
> >>> Would you disagree?
> >>
> >> I strongly disagree. As far as I can see there is a huge chance we
> >> break existing use cases with that.
> >=20
> > Which ones? And what about the ones that are already broken?
>=20
> Well everybody that expects that driver resources are *not* accounted to =
memcg.

Which is a thing only because these buffers have never been accounted
for in the first place. So I guess the conclusion is that we shouldn't
even try to do memory accounting, because someone somewhere might not
expect that one of its application would take too much RAM in the
system?

> >> There has been some work on TTM by Dave but I still haven't found time
> >> to wrap my head around all possible side effects such a change can
> >> have.
> >>
> >> The fundamental problem is that neither memcg nor the classic resource
> >> tracking (e.g. the OOM killer) has a good understanding of shared
> >> resources.
> >=20
> > And yet heap allocations don't necessarily have to be shared. But they
> > all have to be allocated.
> >=20
> >> For example you can use memfd to basically kill any process in the
> >> system because the OOM killer can't identify the process which holds
> >> the reference to the memory in question. And that is a *MUCH* bigger
> >> problem than just inaccurate memcg accounting.
> >=20
> > When you frame it like that, sure. Also, you can use the system heap to
> > DoS any process in the system. I'm not saying that what you're concerned
> > about isn't an issue, but let's not brush off other people legitimate
> > issues as well.
>=20
> Completely agree, but we should prioritize.
>=20
> That driver allocated memory is not memcg accounted is actually uAPI,
> e.g. that is not something which can easily change.
>=20
> While fixing the OOM killer looks perfectly doable and will then most
> likely also show a better path how to fix the memcg accounting.

I don't necessarily disagree, but we don't necessarily have the same
priorities either. Your use-cases are probably quite different from
mine, and that's ok. But that's precisely why all these discussions
should be made on the ML when possible, or at least have some notes when
a discussion has happened at a conference or something.

So far, my whole experience with this topic, despite being the only one
(afaik) sending patches about this for the last 1.5y, is that everytime
some work on this is done the answer is "oh but you shouldn't have
worked on it because we completely changed our mind", and that's pretty
frustrating.

Maxime

--5d5u624ftgk7q5qf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaUUoJwAKCRAnX84Zoj2+
dj4lAX0Yy0is1eVfn9GJZ8tPnOe91CbMkIdAor1dgBxh5RGL/e9IAXnnFFQzaX12
w2/x3FEBfA/Q0bKegplzRU4jhv1EueYV2Vj5bqPF2sIKW/Eff7kOIT0+y8L+DyLg
WOULpERarw==
=8moi
-----END PGP SIGNATURE-----

--5d5u624ftgk7q5qf--


