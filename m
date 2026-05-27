Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9291CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7C76B0005; Wed, 27 May 2026 19:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78956B0088; Wed, 27 May 2026 19:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E816B008A; Wed, 27 May 2026 19:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C88356B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:52:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87CEC12070A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:52:57 +0000 (UTC)
X-FDA: 84814852794.11.B0233E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B0CC418000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:52:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fzs7Og60;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779925975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeUqDM6kHXI4MJO5NxIZnBVQL7CgctHkwj3f11Zgvb0=;
	b=t7x9dqRUwMzpXJLrmFBkBHDKpckajfqOp2mp6kkjwOIA0O4ZMyftbl2CuGfPoyP5zo61x9
	zXnApwNw4nWDzQWFeCFGU+8lGm9AJ3Ae1TaxLZja9OOjh/CvoDSuSH7/jpvzuaAfr6EmLf
	Od1gOQxEPbzRUgBt6nGD96gwV04+vcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779925975; a=rsa-sha256;
	cv=none;
	b=K0rmc+Ea029kLQjTXbgrl7yG7towPEcVDs8It1qy+pyYGLtIMB/1C7/bjfh7iSAf0fptWN
	DwTflPdqsWlW0dsk8Oh6Ml3f6ctuRCPhibEPz+TBOlw1n1HGDuxHYAXdJ2OwCOALW2daW+
	1ZMIIXFL9ej5Y+0gOjlKBOX1+quFu90=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fzs7Og60;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2239B605C4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE941F00A3D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779925974;
	bh=SeUqDM6kHXI4MJO5NxIZnBVQL7CgctHkwj3f11Zgvb0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Fzs7Og60UWY5kTdAr0mOQdyMusHW8uYLwojCS/PzybvSQ5RCGkqDXCXe3c9Xth5fp
	 xUyFmmVvwlChpcla9IQrqjsDDKK42e7pvncYG+M+1cBCClbHaS4OPyEWLHPkOuUwWk
	 cz27kd1HGr1bQv2yAnQMMOr7NIvYiNL3Y0mPAGaLttowQItJXrzvu4JiJPO5//XdeX
	 FQ4wv+ghVyAVVpgHmSmNqn0seICehPUIFohz981l6UQo3CkpJiFgC72nbeEmvkeqay
	 TgRnwKyLIBAwnDGcmH1rNb76gQhI5JJI3tohVcNtxL+BssOnEEd/0kyOcRUxUAwCCb
	 Hc9piOSDLaOBg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6896c54a7easo2732698a12.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 16:52:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+vvynRHNCm6j3xmyZ4ZdCDGpzF6wAgwGyCWKDAdP+BoJedosP2kA/40zUttP5abutIEdGB1hrFFg==@kvack.org
X-Gm-Message-State: AOJu0Yx/88o2zI4ttZg8exTVitDBi1GyV6I10pKAHQTDbNSh965n/AcP
	1YGjXs+HnP0ZzXcUpF+vp2qTKMoFpEd3ElfDHJhQA3EfFHW1vF9ynxN480BYV0Y6qvsXCnuYQ17
	Yw0gG5C2OD3VAaObWVIjQK10iiIp8OUM=
X-Received: by 2002:a17:907:a80c:b0:bdb:c0f7:ed68 with SMTP id
 a640c23a62f3a-bdd268c0eb6mr1575121366b.42.1779925973705; Wed, 27 May 2026
 16:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260527062247.3440692-1-youngjun.park@lge.com> <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
In-Reply-To: <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 27 May 2026 16:52:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPpXsehvHK+iBgORXKfpKWJBfdH-_3_+PNT+RwzJ+q9pA@mail.gmail.com>
X-Gm-Features: AVHnY4L6f5NybnTdGBEWK83rJj50WfqT7n2xN92NCKzNHLpFzapdUfhgSzX9qRA
Message-ID: <CAO9r8zPpXsehvHK+iBgORXKfpKWJBfdH-_3_+PNT+RwzJ+q9pA@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Youngjun Park <youngjun.park@lge.com>, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 6ejpmztbd3t1j754g639sugysczze4wx
X-Rspamd-Queue-Id: B0CC418000A
X-Rspam-User: 
X-HE-Tag: 1779925975-598312
X-HE-Meta: U2FsdGVkX1/3mksZDzyu0A4E7iGlhFzhUilcnE9dhrpl+20X7LG1Wm6fsJeU3xXEJvrN2e2EALNf/4UQtDhYycbGq89LaUDzR7LlJ/Uc7pJBz5RJm2SVWK+MNyTa8zGe6VyvDMM7IXoGITDCPo0to8HEKUkxP5LDVCwvJXEKWMFXDBt1TKjXBHETtsww6J/VU1+620pOkRZt20GsPlJJmm/Js0IncfRvYVnnZLDTUy3TJ1ik74pAWiAUGMPr6mTZaxdWmcWwhTy4HrcFU50QfEnD5eVRjzHpEKAONCMrS+AydH8nDWjJeVkJTp1bOpyEF8W+bPK3h+jgSRKoaVSGcY2aPhY8kRSIfMLfZnRYOY5rfedwZzItOE9mZBdPZO9JExLsbryRqRRVyaoa+eR9t9vl2MlDcopTr4LwcLit4+njVz/44vdcyk7Z4ePC1IdHm6Cw1JSY1I7L+jKw4StXpoTOhhybI5KUzOPF1EGDL0/Qz/bQonHAwlyXYexNSBOWUyXwWerZqAuaMEkYIyysQyGopvcpp5WFft33/SiHaAMWW+7BrkDAACXLeCVACLyaS/bNG8ASLf6NiR5S78H30h7q+cori/LiYQKVBYvaKY/iUF2I1wGAYNrsqWD/jc+WITuoUvL0YEB9HZAvksYN3i4Ssc9TJG7F0R4Ukaj1uF10zl69vQ3wNODY66LRyaqPgnuqpTMwAcy45VU40J5ZgWWAMK6MJPMmmz9dkolL9Pag9kf/X0jS+p/gonzHoPMVHcwxs1sOed0TrIWXEPrJMBTs6eiLIiqavE40YccbM/nHdQZGNqZXuNgljpghshVN7yVtob2DCfekKA2e+3fDXQk2sODUA9cWQljYl9pZQqKKOgu1/q8gqAWCRx71IQ2F84aoq+ivAgvd1bMy1Gt3s+YhvxaA4ArUI6MoUHhIvzVM19JXgLt63eDidZs5xDcxXwY1xxV6/dgy7Tmyqi5
 J2MD3lJV
 1rGf50OyIapRCubUb9f005T39seoWlI9vRKLZlSdd8SOOiX3CQdzHbUcCvtM4HD14TQGBxYE9lu9MfIPE0vq4fIjZopvoKmrLpm43lvjVqVV2pS+uLaffDKoFEQZflxKVK7acXKVPlrRKgyngxL+IIpVHcIfdEobGJfz4uQHPkc8IpCGZpZNBOaLYI2lpIbpcHslkXh33GOAJtvpYjVMFXjw6WYszx75A5PONZQmCozjcHp1X7SBqQIBPmBBHO9cdl+/+wgHuVi0vxbi34pRIIGGgnMU3Pu+qOwAa03MeD120+ZDP0K0ka+N165j/v6dTL81vOAGqdpGsKJ8TXcZNGYID0qi1cCCJqe9zLriusTPbEu1Hk2p+SL9bQYZKtu19guZNesc0i85S3ttn8JLqjjnp484PHNk4yV81FYKyERIo470=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 1:36=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 27 May 2026 15:22:43 +0900 Youngjun Park <youngjun.park@lge.com> =
wrote:
>
> > This is v7 of the swap tier series addressing review feedback.
> > The cover letter has been simplified.
>
> One question from Sashiko.   Minor, but easy to address.
>         https://sashiko.dev/#/patchset/20260527062247.3440692-1-youngjun.=
park@lge.com
>
> I'm reluctant to add a new feature patchset at this time - we have a lot
> already and we're at -rc5.   What do others think?

This adds new user-visible interfaces and I think we didn't reach an
agreement on them. I specifically recall Shakeel (and perhaps other
memcg folks) having questions about the memcg interface, and I don't
see any Acks on that patch. I don't think this should be included.

