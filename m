Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B119FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D1B6B0005; Fri, 24 Apr 2026 14:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDD66B008A; Fri, 24 Apr 2026 14:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3B46B008C; Fri, 24 Apr 2026 14:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3D66B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:50:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB49A1B7471
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:50:19 +0000 (UTC)
X-FDA: 84694339758.23.FE49FA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A18FE1A000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:50:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pftDalM3;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777056617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4C3FewfjEWfeVFCs+GkHycvgwaNmSe1j4HxrdF5jm4Y=;
	b=Yp4QPafIdkaTYqv485bJc6c/hqXQHqh+y//l3iTwapuknsWFwG1XT0lYZtxRQqLrt/l65h
	ntAGPln+pNqOVUG+xHxQ5Ew+OYHBuKfdLYX2yP/dpIbo/rQpNVewS4F8Sn0thQCax4jgjo
	9Z4HlYHd3wtVfo8svq2gKFL64O6wxNs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pftDalM3;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777056617; a=rsa-sha256;
	cv=none;
	b=6A9FVg0BwBh2D510xM5z/c4ICEkMK+2OI6f9DiZXH1OaP3T2+XJAdQcTbUoE9c32DP3tg6
	Zk4wE63cvKc1F80Js7d52+vf3q1F3liTAW0cn0ZB6WXD+vznbO9x9RqkWXcMSKxJQNco0S
	FFM/GBeQ8SEuWj8FcdA4kpyoSSI8gDc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 843EB44590
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F9CC2BCB8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777056616;
	bh=w5kUoCAdRW22OY51cZNgSK5N7Gpb3BDGbpsiHoe6xEA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pftDalM3kJ9DPPvgqPonQ8Vuac/lSzURnxnvhHdDJpTgHP0CDrIvO8ljHgA/fBiH6
	 12m42BYH8ANEfIcVa+brAYwt+ei5bXS84bXwbuc/W+GfHRNCHqqQdHtVJ2gH7VqiqY
	 izqXhaLsSXtSq5Tx50f+kHKWJ3HhvIVdUh+IUxp9TpZG2WLyZ8aL4P/629m+/Q+ErU
	 ZglR5Y9QZOOWcmcHa+C0vr7X8x1aH6uNqjNmdHhayQcuQM68oXiN6BGhm4WJSczF2Y
	 DRugXmwBSroybC7MpT+/CqOhNAY3G3BQ39fm9SOKNxB6PPd7TK94BwTN1DEcqA6LTb
	 ymVgyyrngrjug==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ba36357195bso1000095666b.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:50:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8ZIEZuccsYBHGCRwZ2qwUyt5oiLsyao2RPyG0kI+lp0tqC+RAnOF0rp7XE7/t12sNlMMs9kGf/yw==@kvack.org
X-Gm-Message-State: AOJu0YwX8Vb5g0rlGZ0xjum01ds2iar6fedNSLYCMFMc/Ywi+6ppnOVa
	7uY1fJ5OVQk+zSuyISiDYLqdQN0KcNtMv0UnqInMTrUx611QpfVQECXi9a7jjN62JQ5DHQDQ3sc
	ZJGKtOUlQPBOt9ftr7jZU1OokyTMlei0=
X-Received: by 2002:a17:907:2d9e:b0:ba7:ade5:8605 with SMTP id
 a640c23a62f3a-ba7ade5873cmr1292114966b.6.1777056615011; Fri, 24 Apr 2026
 11:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260424062528.71951-1-lance.yang@linux.dev> <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex> <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org> <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
In-Reply-To: <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Apr 2026 11:50:03 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
X-Gm-Features: AQROBzAzgmye5h2hgq6OujP1bhxfaF6hprGZxVf_6cZmOYHaxIkk2WQtzQUABGE
Message-ID: <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Lance Yang <lance.yang@linux.dev>, peterz@infradead.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bneo3k6qu9zny3m7639xguh6b9deccyw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A18FE1A000D
X-Rspam-User: 
X-HE-Tag: 1777056617-65517
X-HE-Meta: U2FsdGVkX19oHIL6hecMCOLZexm6rxNWTnQK3AmPKutMVmzNz2RXhR4W9WP0MltmlHUBQY5P5oKAoTspjxYeoDQ9JkFiIz0hXiDI3CJQNaUERNZIw2rmEV++W64ZZR2NjUcKYzEKbjsswsOS8E2UUzRR6BUE6bhW8+UROl9pVyVk9HGKDob9tOTw8yIH72EOHep98KOHUfoeoX0Yus4TrO9O8ImKo2AITB4WGwLTbcUYW8EmCT+ZXBrQFPOe9tJJNEphMquf0hmhlcG8BuJ3V6nTspLlZfvCE4+Vr9b9pgXojR4yH5ToWCcQN9uSv9bqJycvtXqf7+Ldq7NOfQYawGLMIdA1j+2JLolNJ3jl/jy+kdf4nRYQXsyNcYlXwULgYznFsJCXYjIeffZ/RKpLTIK4E+F+aM92Oipl3cs9UmXzKDqG+b0fxYrJPq/HTVlEm5CKdIpcV2OSOFRVpKd0d5Ug1skYnVmSozrJA0HP6IWjfrclDcWHj8VrcG6O8x7ub9ZVvirkRPuBXGPZC7MCwbKg7yrexk2zokYHiXgE7bW8XYKWOM7e9bTVfo1axvR7+kEzCFFyxS37FQX/J1Yy2lXv2Zg/7Rov/PXL3OV3ABjsIRPYPSOedkPLy5GQJ9twTNAtlIlq/uKtyVF2ctaqpZ5OA6ZPKqDaW/8ojBlDbuzxxYTNPgCXbB3mc3Iqpyiqj0MYDIP6twoMKYUzLf9BZHupBrYY2P0b4HABE9c+wTux/Qe2YILybDI4JBbA5nFnOpO1O6lVH3AA6hAyc9Pu/LjiuwEeOMjd8+zaL+azAZaFDFqplnvaBHGo7JQ3YXoNskXU33vF6+LWo2qXHvStJcNywfqiiLjNG3TdGw4MuKSiDVh5QUPBRPMvOMXzImvv3TFc21m0YTO3Lg+n+myHkP8k8JS/Du30co0FKvY25nNy7nT2oSSNefupn7wkJDd2wQ1YMH+mA0hY2UYWnyN
 kvayHBYR
 zlXhazwGSoEwP9mWFMqAoHpjgq0YeGez2Pl+BCWxeTDteQhe9kwxozGca7TXYsWWUyzWgwHi/3Bi8G2WtWYjg1fkZvfGry0ztqxUulHQkM9dpMJpfr6TdDkump4bF4o4iq+zGzqYqGoTlfBufzjtTWY34TwW7zhTY33vEcJwntHg2Nu8TpDPayLHBdq3ADK49o/NNbhk8bfgMP8aX3iARlUdvhLAOXQuaXuqzeNqAePWOQJD53UyrSYgPQnli5W4UPIBYkQWALlecUoHJ6tY15HTJeSboJBgv7ahkuBO8OWjQUWI7BLhsrdjrXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:36=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/24/26 16:31, Andrew Morton wrote:
> > On Fri, 24 Apr 2026 16:20:55 +0200 "David Hildenbrand (Arm)" <david@ker=
nel.org> wrote:
> >
> >> On 4/24/26 16:15, Andrew Morton wrote:
> >>>
> >>>
> >>> Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't lik=
e
> >>> that.
> >>>
> >>> An alternative I've discussed with Roman is an automated
> >>> reply-to-author with a cc to a dedicated list (we could use mm-commit=
s
> >>> for now).
> >>>
> >>> Preferences?
> >>
> >> Reply-to-author would likely be better as a first step.
> >
> > Why do you think so?
>
> The most important part for me is that authors are aware of the reports.
>
> Sending them as a mail forces people to publicly reply to the feedback, a=
nd at
> this point in time, I am not convinced that that is the right approach.

But I imagine it's useful for reviewers to see Sashiko's feedback as
well (without having to go look on the website). It's possible that
Sashiko is right but the author isn't convinced, so getting more eyes
on the feedback would help. If Sashiko is wrong, it's still useful for
more people to see it and point it out, instead of Sashiko privately
misguiding the author, especially that reviewers are probably more
likely to tell if Sashiko is right or wrong.

I understand the fear of too much noise, but I think it's easy to
ignore Sashiko if we want to. It's also a good exercise to spell out
why Sashiko is wrong (e.g. improve changelogs/comments to document
assumptions more obviously). We can always tune it down later if we
think it's too much, right?

