Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2ABAC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE346B00B3; Mon, 21 Sep 2026 06:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87D06B00E2; Mon, 21 Sep 2026 06:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E0A6B00E3; Mon, 21 Sep 2026 06:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD9D36B00B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:05:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7062A02E3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:05:12 +0000 (UTC)
X-FDA: 85237336464.16.1E2CBE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CA1FB1A0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:05:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cawTD/xB";
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789985110;
	b=K4QVbXLKJyl1LlD0RtIawdJKdUYwDe/7uVSVV1u9GqXL6pLzbnKhDNe5LEXyhcrXcFH55z
	0+rTK7X/3s3kPfzuFIJyHa1hIPrJykuJEjluvMUzqiVo/2QtLG78aREuUye51LHDYfBbqz
	jfWiju8WBe0fFrZ8eanh9itggUvV5l8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cawTD/xB";
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789985110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItsNNwAC4qDBxc++9nFU+MdfBqnLWO3YTK9IF8ecdnU=;
	b=IpDoIhASzy1+VvK4juC6T2JOn4pLBOJfJsT1iwBqsNz0LnmJ0GarqGOn/GeRHxYbGwLHUv
	Le1sjhFY4Qq54G1zZ5rviDwVg0Ph0Y8ldhPdKYvDhBfop07oxRsfx7G7T872N24Pjeuy1g
	NC8E7YtG5a+BHzsjVGyu2sYKZNruePQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D8804194F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E7C1F000FF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789985109;
	bh=ItsNNwAC4qDBxc++9nFU+MdfBqnLWO3YTK9IF8ecdnU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cawTD/xBgMRny4z8uZGxzSPXt/+aU16nwAyWskz/Bqr0/KjcXKyBfKItIvRjgvUhq
	 EuLM6J/VXW/9INL625iS/VTyPE+A6xqOxdokoFqUn1jHzbD024ztyjlW3NxyATo411
	 8l2XNCqyBpaXqiMt6ilhZBOGK19p7nwxPCaO8B/Vl27p4zKSq0oOgAfh4z8e7NMfqk
	 kCQCB0ycm7a6MYrIlAa+n8HX7Xe8ZueNNbNlkzraIM+iN4FDBiXKLuj78O6kqoSqvO
	 WvSKsV8LnYcPLGCdJEAgnFDywPTbRh+C1j6U9XN6JmWyazk6EFz2BI6czOt3ITIkN/
	 NwV33UyRuWz2Q==
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-98296941f99so1302513241.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:05:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxwN0ZWd4XYrg7HVNGHGk6g4yUUP8FhZufrS8jlteGHPZp3YMSKH1xZXewBlfUuHmluDUXPQzlMag==@kvack.org
X-Gm-Message-State: AFuF++nYLwznW3urnmUAEAOfXnBdy4CP2Stmq3wNpT9X1Bm1wFdUNK98
	1nkOoZyX/5pb1FPrMVVAMobULcxp07oZWRYCltFM/2xhZFJ4MKoOsa5xDaPqItgPL5hS42ioXG7
	1OtgLg+OpNakaksOZCPlsUu5IYMayXDw=
X-Received: by 2002:a05:6102:4189:b0:7a1:f951:6648 with SMTP id
 ada2fe7eead31-7a55c888c4amr4953994137.15.1789985109343; Mon, 21 Sep 2026
 03:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com> <20260920162014.4479-1-lance.yang@linux.dev>
In-Reply-To: <20260920162014.4479-1-lance.yang@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 18:04:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zV5PMR4JdNtHsYhUK9MNUMuC5pa7b+Tx800YGJotOyhw@mail.gmail.com>
X-Gm-Features: AcwNN1WN80W2AMBhuPmQGkvtliIEPiQUjsMcIsyBA-H8xOiD3kaUc0wv43rwWS8
Message-ID: <CAGsJ_4zV5PMR4JdNtHsYhUK9MNUMuC5pa7b+Tx800YGJotOyhw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Lance Yang <lance.yang@linux.dev>
Cc: joannelkoong@gmail.com, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA1FB1A0006
X-Rspam-User: 
X-Stat-Signature: owgr58ri5s8ao3x6j7m17eq8d566gb1g
X-HE-Tag: 1789985110-381474
X-HE-Meta: U2FsdGVkX18ssaXKr4qF4yHUnCHRadpLs7wrzACUvPbuRBAeejNfiOK5sp9//TMP99Rk1eg/QyVwl+DwR2XVhoMi3umssx+2GzreucokAa6Nb0Rxe/lTmOBH4VIJa9XWwnC8l8CbwG7tYY6si+QP0+AMcTbaAd2/ycGaOZ7RQp7snM2BlXWLQcqyGN/yQtM33fD8YEwT2vwWO5UDGi9Ph8NvWmPOXP3FVG7AVQLZ+0I1z/L2rtNrxla2a2fgqCgzuZobCm2cmkL5hIPvtAbitxmomgLuVA+Lx452tjDY6tOUCdJ7SZ0j55i3VL3ewlvyDHptAdFkaQeY3rMkIg4ke8ixN3HPcc5p/RrRVt7cHwtANWce/x6ORqEKa2RKXejJnEb1EJvNuM8bEzLrbb3axVZySVhUR7OudKKvAmZpf1RYdnWtJiEHaC2eF3w6oZsYFKQEUKGKJneqNO58S3U9SAEPFiwm7ZcnxR96gkfjY2ilYmGXuCmnh+peOAwXMfKdnHnhzrp3IYOZZe1W+a+TtNxhgers20PtGKByrAXdHEYtSGcf3ClnGfn74z1nN26zHtf5Nd7Zc8hcMlZ/zFh1UK/Jfj8zBo6eag93it1PNKeDaKSxEWXgNWJNbabCP1G+mf90qeniT/LIgEkFE+hsyLSBdOWrvygJIxbsUGqdZyQoDWJbVKRFI3ro2FxzlPkJDzzcniyMfNEQfFwx1qpmXA+qKwf2qXUwTwmVIPb0jo3FklIf+focCXBhjUvXCGRzBoii/7c3Pv5ni2bIuDXndjBLWrX5xtP8CD43dcLzHEf2w9cracchxE5zYvU0PbNDMrPxwm9wy/vzCbVdg2QTEyj3tseY+3+9SmrqjKgy9XQn4+CdmhJvY6RLLl4s3Mq63zAlqXpkduZr7Q4Is3ZlSIHyB9iqKIUJFYTibnT2IW+7lYEU+3zAiV+AZieihttuP09/wCWnowCj07TJlqn
 81MtcJOO
 Ne8gvTGTZBgTU4aXEYoDSnW4bCAc4cASS1zBDZpNjfRuLhEMLzlCf+R9IoDyH2HDIIqxisuE/qRDm9jjqPaGjENTUZFcmtMnuY6jG03VoqRoI9p58zmV9vdsqcI+4rUyW8GGcT37OKlIEMNuWwB97qfrwKuCrXKmXkniyyGRMy1il5vt1QFiYRKIUvpy9SrJQYYclov5G0JnbRa4c8Ecft038fz7lOAUeNBMTT1Jrr2T6xlhbYHCvvAuvwZyT/PPvYVNJqGRXvcKzxXUlMrdckXVUUhdXK3DSn2qUllUp+IjOalEnmNfRCV10RQ4T0WTk/MpyE0N5F+YnVvppAb17uOFlTsUhfyQTBWSpxEWWhuPG9raT3fM2J6SgDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:20=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
>
> On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
> >PMD-sized THPs that are mostly zero-filled are reclaimed under memory
> >pressure by the deferred split shrinker, but this is not done for mTHP
> >folios. At Meta we would like to deploy 2M THP=3Dalways on arm64 with 64=
k
> >base pages, as 2M provides the contpte benefits while the PMD size there
> >(512M) is too big to use. However, 2M THP=3Dalways causes memory regress=
ions
> >unless the unused portions of those folios can be broken down and
> >reclaimed.
> >
> >v1 did two things. It scaled khugepaged_max_ptes_none down per folio ord=
er and
> >it queued every anonymous mTHP folio. David objected to the scaling sinc=
e
> >collapse had already rejected proportional scaling as either letting the=
 memory
> >footprint creep or being confusing to reason about. David and Barry sepa=
rately
> >objected to the queuing, which adds list_lru lock contention on every an=
onymous
> >fault, and hurts lower-order use cases such as Android's order-2-only
> >configuration. Johannes suggested keeping khugepaged_max_ptes_none absol=
ute and
> >simply not queuing folios that could never exceed it, which addresses bo=
th.
> >
> >Read as an absolute count, khugepaged_max_ptes_none also implies the
> >smallest folio that takes part in underused splitting. A 2M folio on 64k
> >base pages is 32 pages, so the knob has to be set below 32 for those to
> >be queued at all, and any folio with no more pages than the value stays =
off
> >the queue entirely.
>
> Em ... I'm not sure max_ptes_none should also become the mTHP underused
> threshold ...
>
> Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> collapse uses 16, while mTHP collapse turns the same value into 0. With
> this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> because it has 32 pages, and is considered underused once more than 16
> pages are zero-filled. So the same knob means 16, 0, and 16 depending on
> where it is used ... That's a bit odd ... no?

Lance, I actually had a long discussion with Usama, Joanne, and
Johannes:

https://lore.kernel.org/linux-mm/7bb32d25-2c3e-40ab-904a-ba22fff60cca@linux=
.dev/
https://lore.kernel.org/linux-mm/anHxPU17Ui4MTcCb@cmpxchg.org/

I feel this is correct though it is a bit hard to follow.

Best Regards
Barry

