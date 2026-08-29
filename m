Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17ECDC61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 03:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F936B0088; Fri, 28 Aug 2026 23:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C08F6B008A; Fri, 28 Aug 2026 23:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17946B008C; Fri, 28 Aug 2026 23:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEF886B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:35:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEB871C20E7
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:35:05 +0000 (UTC)
X-FDA: 85152890970.29.78F78AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3C86180002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:35:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cfm8s5qU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787974504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yAywSgOCSK1fCox2+toPCjcPuWCAJR0UBUdjbUi4aw=;
	b=Ey25nYVYt6bosqv7LsOB9i8/DAWy1JdxsmJvKWs/gu/TWM8T5I4OdFcIQr5H5eAWfCrr1N
	oHmqqG8HGCK81wwtxnmFnqukGAC7iJOJFBcsB/6F4kOBFLx71lSCZ1WdQIpPTfT+heJHg6
	wXiDSg/IHYWjeSTJRNg/vDKNWOBcBv8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cfm8s5qU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787974504;
	b=0W5TV0G4yKKeXrm+/sXYdfkE0C/TUCpYozGEomN8SeV0PLYSzDaKiMx/3WppvJsXEmUaqA
	/d4jFaaFiL3iNFs0Szbwz04sO2ktKatmkh0pgnA2oOiiRajwiR2N9vHGOHBF4CZqjaC+0n
	4Jrano9Un4f9RbRnDZglk8wLHGpbTrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E5C360D82
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C11F00ACA
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787974503;
	bh=8yAywSgOCSK1fCox2+toPCjcPuWCAJR0UBUdjbUi4aw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cfm8s5qU2msB9/1h7moyZ6tSFsusG89fmAeWBlt9HtHBBkc5igneHUtZh/Ka5ksAa
	 deohhCbeHtgQ4joCZCm7rxke1psvcS6Y332qfpx92RsGr4evnULtiG77Lita4FVNxd
	 PJFhzvLLSwPiO9QMtyQhCFacFCW2D5X2ZfYCdTtxHVWxMU7n/F0RdqDwcI7HS4eTrF
	 fhy+rcUUrQfZI790pRboMXz5yCs2aBxU80FiX4JevPD+pKwFnkKrg34cd9VCUWQmDK
	 kKTk0L4h3xeB/MJxzrnaR5xaEUsq5ZO3Z8in59mIrASxRfPD0MJnZ8THdIvALSz6em
	 gckm1CwjVkLIw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-90e7d9c747eso321196d6.2
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:35:03 -0700 (PDT)
X-Gm-Message-State: AFuF++kZMdJxg1AQZBisQeha1ILNFPQMf6AMpl0tHbIEVNI++yz9P4Tv
	wQ2n0/iEYGp4DHVQDmelRuy5c9JTEw738eSTmSG0iAf7tRkrMaXI51BtZy0/K4VYk4sIzL+Gpc6
	XYTXmDldzF0RgqtVOmxoXXPDYi/OqhY0=
X-Received: by 2002:ad4:5c4c:0:b0:90c:d136:f686 with SMTP id
 6a1803df08f44-90ce0c5e041mr152357926d6.8.1787974502361; Fri, 28 Aug 2026
 20:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-1-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-1-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 11:34:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xqEpAxO4wuxFruYaRphSeD=Zmz5nUZCMoJYEbyprP+6g@mail.gmail.com>
X-Gm-Features: AcwNN1WEqRQ3mtVBCtrOuN4gMOImSKKb5i3DYRumzgHPVKAv8X125ymB3I-vnAo
Message-ID: <CAGsJ_4xqEpAxO4wuxFruYaRphSeD=Zmz5nUZCMoJYEbyprP+6g@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rd1xur3etjz89qmgrz7z4g4ohbmxm36m
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F3C86180002
X-Rspam-User: 
X-HE-Tag: 1787974503-534433
X-HE-Meta: U2FsdGVkX18w7wwcHDMScoUjiGtm+lJl45f4GARADq1FVBLAv4mu7LgQDkPkb5+j762m3IZW78WjJLyIQobpyNCDKloPJM1j5JhLkRiieXOE12ai1SPSZPp7/awHkzThV/LCa/3Cw2JvdCkiq4fKwOPW9anR3jwkJwTbAuY6mIYnIe7lVPg+ndJTeqU/9BD5U/ti7iv7BB578clP2DrGuYfMrDJ1Dm14mv36FNuk4l7Pe7kd5TIoAwlIY7mvwM1JSu9nZcUpxGIIDVwcZDmh09jwSpWxnVPMd1soZVdPCMh8YfDPiup9jMuXFTxAL0KXL6SN+Lv9TFaVl425OZbgqc4hexUUEpwY7kPJ7W1eofz74FiD2fFLJJcvDOiQfe1RvU5+agMDkQkZh1Cx08R+sfnHK6KfPeohDo+Ag59riqZDwqMaciIFkcC/Ikyv7eIfDLBBpAYefzVY0kTPQMdUK66Rt+3MQZHOII5KNofF6PAL1P8DonRad4xX6bKkunEHnd8DWs+nzGEaLIv/KDhs5XFB9/b+kJDhTGs9E2qCovMijzwuPP+0NKjdZU9yIVekbXzS0Dq5XMsNQ/HT5a8DaU4MiZjekmq4NnvLAqTbQsgPLMobJ+P7Vdmvs7o6QLIAUTOI2v782ceyvsWdp8VSSZ0AqS/tbl00j/G/YbEliVshHqGei6suVuYUj3wJuUmUbY+QGuCDugxdWBrCwKDxHo7XzNOGjRrmKlCCiaAMY6D1Da+zOnN1eJ5C/lu/3lymlocqPQXVO57z9uL3tTFJEXw8I8Xx5G5mS1r6Q76PVOyyGsTonWkwr4+3eeIM3P5xbq9OYAGnN9LJLnTNutj+nzt97HfiFDQ9hKbKmwcsEwVuabftj/l11EaH577pFFDSuu1YGYTVIg5O/mMmPXBP+77c+nLVuE0ku9iQ/5NCZL4jvNXL7Y9Gd3tAG+b3PZPI0BrtfA3t2ttE0xx1n2v
 HFYdlU3M
 ddJQ0uwyCczw2z0yOBNWKNeTZHMo3uZkKfdJgRSTYPx9O29QcXm4afF30ar8XWyyQ/Vx74hOqZEdSBMcR3e+tnONATF2A8v/adDcwIYjA8Rs0xwHjOMCBBfClwabGG4eqm+mW2ZbK+5cMUogHaXSU//uPexLeoiy+bQlvYkgfS3HW+qj5RnEZP2QTU76RN8Z6+DFJFCTo1bBN2mHDiZWkkVqKg6SPCqv+SyFxnJiXPCKXPnU23YAT4n716lEl2Ws5FdCiTmOWT23/uHOLxE1hw2yrXkV6VEgYIZuv/6V4IisJWPfdXs1Cyx9RKFvJi6cZkFIUA8ZonAKH1zDbytpPCLrKiLGyv5H2JTNde8KAOFAzDm39vN8y4qJ+Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which was
> more of a workaround for another bug: lru_zone_size is unsigned, so
> underflow wraps it around and returns an enormously large number, then
> the memcg shrinker loops almost forever as the calculated number of
> folios to shrink is huge. That commit also checked if a zero value
> matches the empty LRU list, so we have to hold the LRU lock, and
> handle the positive and negative deltas separately.
>
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> for lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, so handling the deltas separately is no longer
> needed. And if we just turn it into an atomic long, underflow isn't a
> big issue either, and can be checked at the reader side, which is
> called much less frequently than the updater.
>
> So let's turn the counter into an atomic long and check at the reader
> side instead, which has a smaller overhead. The underflow correction
> is removed: a massive leak of the LRU size counter would indicate
> that something else has gone very wrong, and one should fix that
> leaking site instead. Besides, the updater-side sanity check is
> unlikely to catch the leaking site anyway: if a folio was removed
> without updating the counter while other folios remain on the LRU,
> the WARN only triggers much later, from a likely innocent callsite.
>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

