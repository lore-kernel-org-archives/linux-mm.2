Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0515D5B87D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061976B0005; Mon, 15 Dec 2025 21:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31326B0089; Mon, 15 Dec 2025 21:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E086A6B008A; Mon, 15 Dec 2025 21:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CADF56B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:08:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C9E41403D0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:08:24 +0000 (UTC)
X-FDA: 84223699728.08.B978E84
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DBCA180002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:08:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U6NLS+js;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765850902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5bsBULlMz6QGKo15fJSSkYOWsdYZVhr1CJojovu2xo=;
	b=NloD2n8Rfb5HxVONs6Hk6tCH7dsNKUeUg0qHaqy1EkpubAuATZTX7GqHk9yR55L9nRaz8M
	7VZ+NhkmGEtrZ/CtsAPi549X3/x6Mj/Yt0Y+V8uDl8aIWC6hKtAty3bMBbS2w1Ypcw8oaB
	CzpWm8prvmHR5DyTKwZ6wwfDnuTi0wk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U6NLS+js;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765850902; a=rsa-sha256;
	cv=pass;
	b=gwk30GbL3ZknWscSzPnIeG25RIHP0+pKbYFWiwon/oTrN9JvDIQX2p4e11jre3L39XolK7
	YYx7n7BnwP7DPHXeq5pa+7u58mmS90cumsPvPrKV4t67o3FyXaI0Ybx92fAUdI6XNvefGP
	wrh0b32Jk+OZX61hnW3sNmKtDhsA59E=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so22265e9.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:08:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765850901; cv=none;
        d=google.com; s=arc-20240605;
        b=Q0g2TgcQ2u/WAlXbrm5mM32JOwaK2Wt9Jne8I5EtnWYrXDSUpzElUeaF9lse1ffqDF
         UpyLRk0kHxhgRcSPfeBvWmn0Qpob9wQ7ooqjtO+RVAtXTqoOH1+CoPXXenVFc2hM6cSx
         EwJTAN6cjWLGRrOLTWS7uJ/lBvb6yk9UlUl1cKABzMeGMt6dmBKJLf/U8HrR76lWRAmC
         LAIk/sDkrcDg9j964ROxonpFQJoca4AI5zwZpd9JgEB5rD6vXaudG2ryH4DCkG/nhsx7
         FRiytil4TvTFLNQ/xPwStXCDkwaeddWbfTwf7X2RIRnT2d/27Ij9dqTQ3QtNb7DgpPjn
         qwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X5bsBULlMz6QGKo15fJSSkYOWsdYZVhr1CJojovu2xo=;
        fh=9s9h5SEw+LVzSDzGzBs1Bq+nAKsJrzdKnJ811VRrRhY=;
        b=Z1fQ5FypTvIBxKkUGmPGMT5nALuGOLTaC3Upcj8pMMrDbt1F1n9rx3yP7ptSbcBcxF
         r8JMDydWyYedk1yk/cVWW2pXyj6JxgiLyA7Pmvg7/Bz+gV+yP+MLJzy54cw/B067lPso
         b2oBrxDboaGHgywf48GbX06+5fXo+Jhjx7IcWgTqtp5IcJF7Ga6FQS+8NXLqwQHWzRTb
         thtMzDFMRmDNxkoFFxe0AMW1XFAl1iPRdollkuGQ7O3f4n+eNzuS/7++Y888g9TDCbrC
         YAC+YYEA68rZMcvn0p6a7+cttvMKsHGCTHUu9rH2Sx9c8BgV1Fv8D0Y9oLyPLY7bFE7U
         tNNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765850901; x=1766455701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X5bsBULlMz6QGKo15fJSSkYOWsdYZVhr1CJojovu2xo=;
        b=U6NLS+js15hbY3JDPR1jF/jlnKQ+Vfebiv7DOzTdFzyZit9xzvYc0nxYIzCOotWypx
         uCRC7iHQeHwIweWnT7VQRcTOQpSKAbwEmUOakzNWgTJob7r8XMVcZppKsQLJKPdD3Xp0
         m23Tae3R1geuPyD7+fbOdjFjnAXgKRuOfiSA/cJ9A8s2RR011StK7h+Fn7nT4dGxScOp
         cRBk/POvGp/Uhs3/lKDtjTI+vvgar61ILGQMGE9awBzpu+lvHGSKdqtpzKASPv31gtBy
         m/TYJXUGKyaq7NwlgKuOdVcTJPJd/XUpLzzRQBZxYpr9ieeWwl6NfrTNpjtcFtCcSVac
         B7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765850901; x=1766455701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X5bsBULlMz6QGKo15fJSSkYOWsdYZVhr1CJojovu2xo=;
        b=Y7DJPcQJbKA8rsPIFHuEtJRbDaviy0aa33/1j8nNMN3FTtTikzwZc2/C8qyHDs/BFU
         cKD9uqb4R7wZO7uuwXyK8+0mOz8kXb9Eho/Vl6Js+WzuTXxhepvXtbUrQw4J1+3c2Byo
         B6UuFBCDhBiIavej7MP+hABOGwESh6um9ojlKYwbTw9Ur61YLXVag3yC/I5o/gKltZVN
         49F+xS6+S9TUT6vAbLCuPZvP5iEzvODMaLEfGtzq+lsj0hOKRU7Zv0xYP6M4kparuVD0
         WHAwvaITA+eQaqlqRN8meT+gfj1K/rkW1TKFWUpjYhy3wmyrU1RT6bK35KTGW4rSmoMl
         C1RA==
X-Forwarded-Encrypted: i=1; AJvYcCUrO3+iZ1J3EoR8OXkB7U9fhRk5frxjr1MlpJotlaKGNWT2Ar3oaulzteUhPHqwtLO16N2mzwbInw==@kvack.org
X-Gm-Message-State: AOJu0YxfhasXzCveUjZL7hKZCp+0vw+87Z7I3Llomtf2bjEfRhPPDs9D
	9V4egWWE9mGz0lCk1MhX3fnUVwZLb4Gm4ZRDatSf4gZWNk881fJEy8lKE/7AsnpH3BVreatxChq
	euBfjUi9kZWDGB+Xjmn/Ds7Sa4wlO76itOBM6Pxy+
X-Gm-Gg: AY/fxX5bUJzJyNIL2kyIb/dVRF4Um940r6jbrn5BMMY/CGQOsDbcA9V28cCPStL8mpf
	q1+KZ4JxurtLDeFUjdNcSlm/ZyJSvw9f6C+6/XL928WobHMh28rVq1VS+cKFmfiphmgSiNeAi2C
	kMbqSPe+6zIiBZkQSrHjRO4wt9wKelq5fBW1zjQqUaTLYrTUi3T47yD520qhysVj/+IYTnQShPk
	DrslSnaGUVsxWEUk11jRM9+oNDOOUyt7m4qacEtziXmdZyRF90luBLKQjMSWAyJ9eh92Hwiio2D
	NeoJwpgrUDC9VSW1ytIaWuTly0w+
X-Google-Smtp-Source: AGHT+IFy6wLOsC060mVmB9YoWUm0Z5j4XnF5LngURno1tGmqsHKnjp9hIaHtC1jrdIxRXLXpgf9/cJDauopceh8NjdU=
X-Received: by 2002:a05:600c:8a0d:10b0:477:779a:67fc with SMTP id
 5b1f17b1804b1-47bd797450emr116845e9.5.1765850900900; Mon, 15 Dec 2025
 18:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20251211193106.755485-2-echanude@redhat.com> <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick> <07cdcce2-7724-4fe9-8032-258f6161e71d@amd.com>
 <20251215-garnet-cheetah-of-adventure-ca6fdc@penduick> <ef52d9e9-6abe-421a-98f8-f96353652e1e@amd.com>
In-Reply-To: <ef52d9e9-6abe-421a-98f8-f96353652e1e@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 16 Dec 2025 11:08:09 +0900
X-Gm-Features: AQt7F2ou8MoET7GIPVWKsZ-i26gYeKvHlpUnDll8hGkIZCEC5OR1rT4MBoIc71U
Message-ID: <CABdmKX1XE5dzB9go1AStRY4B5-TrFF4pvCR+JLxPeOahso+ePQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maxime Ripard <mripard@redhat.com>, Eric Chanudet <echanude@redhat.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DBCA180002
X-Stat-Signature: x9mzcikg7a8izpmaiq3wdt7x4buwz587
X-Rspam-User: 
X-HE-Tag: 1765850902-223864
X-HE-Meta: U2FsdGVkX19V4odybjBTAm5WkhGUMY9NSji7Lm5UWp2nJwEMeE34V2iwLeYl+js1j0dvOSH1yFnbdEoayFdK4mLX8lI0Ftt4WQ+Cz09gZhQwMRxCh/SFUSKPnIRFfZpiRzKZWFyGbqdgRHRnIn263Epra/Mxr0teXShB8diCw5rzhKKkTK2KWMKB6bL/hXyYvb3hrDwuVgzU5vKIiENV5wLwi/Ny+YcDnm9yX4df8x0wRG6SYZHDXpo3zJ5IbC7tiueZJzvFkrdj1FYiw8+U8dxaFfrk78w99/Vh+1PsxtRBJWppe93rCSrgCwBpC4D2lH+tNqdO2PScH5P4wjJKDMg7ku+wWJTLMVdHF2xexGl0tjZFYDjqYEa5+BpKhhd0wb/MEP4djPgafWQQcKDSP6/Olju0z5eKNC90bG8kzjW50neUmIS86cLTsCOQFEI6bQKP/z/Y1MjKTF5VRb8j5Xlqe0zbJ7+++ixl7R86mL3+PvCtiUCdWQhyOL9tNdzZqkfDe1YXQ+TeSwiM401HaQYSfSp4icNuaF7Ry+EnSfV/BeHTrpzSAeO+mECrB9lxvDu+p1iCVANGg1CLkRt4/shdQ6K0u0Fw+2rojZHezatqAevP6Xl+0+MAiIXYK4Obh9YydoUNeYa85DNFpwj0jgTf2bfJp+VD4WbTJCv9FKoj3WRRrl6sKlIOOuFFdOFKTgXUNybQf71FFqK55b0TqX5v5p/f03bpL1wUhRqz3awO/WWrLFFi2r0MfcrlBjJodyqX5BmdlHFmXhzBBx8AHZ6vklwL8JknsV8Lf/OGGfGp4GtlU8cdrahUzQqRwnT/W68+xzvi77nBf/xgl/CfLi0kxmuzwJrCwd4SqwFNyurVrxMIcOA95cTWmrs9ZEEnwd070WTM2oDhm5JUYXMC1+/nO0d/mFuk6q+yyxmFSOZfncDBMayPgTt8183+dUJaVDOjSq7RYOZiGzCGWu/
 RLtiPu8V
 wdfSsqEwsUEsh8fToRmfSmmH8FXtED5is+p98BhKV1k7qYstp4f6fBsarDnL4INnN5cCIxrk2gleRlqv42NjiWgQF+Hc2+GTYWAbRIM0Bj29mXzFc+MyiNvGoLI1kvW6P8iSlWjumf10ycmcQRaYGh3FoiMsO+50QUqYXVr7fBaOnB8fLyuR6eqTIw6/pBRpKf803sHDr9k7ZT2wq7tFowNiXleBsmrZaJzd0ddkiYsI8istnanMym6UYsFmvhUSYCnPujqTtw37ENOMf0sEMuG6lnIUwySEYObvxJuMhX61ZlO6p8m2Cxd1jw+cu37FMIvknJhhg7PFPOf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 11:53=E2=80=AFPM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
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
> >
> > Yes, I know, and step 1 of the plan we discussed earlier this year is t=
o
> > fix the heaps.
> >
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
> >
> > Which ones? And what about the ones that are already broken?
>
> Well everybody that expects that driver resources are *not* accounted to =
memcg.
>
> >> There has been some work on TTM by Dave but I still haven't found time
> >> to wrap my head around all possible side effects such a change can
> >> have.
> >>
> >> The fundamental problem is that neither memcg nor the classic resource
> >> tracking (e.g. the OOM killer) has a good understanding of shared
> >> resources.
> >
> > And yet heap allocations don't necessarily have to be shared. But they
> > all have to be allocated.
> >
> >> For example you can use memfd to basically kill any process in the
> >> system because the OOM killer can't identify the process which holds
> >> the reference to the memory in question. And that is a *MUCH* bigger
> >> problem than just inaccurate memcg accounting.
> >
> > When you frame it like that, sure. Also, you can use the system heap to
> > DoS any process in the system. I'm not saying that what you're concerne=
d
> > about isn't an issue, but let's not brush off other people legitimate
> > issues as well.
>
> Completely agree, but we should prioritize.
>
> That driver allocated memory is not memcg accounted is actually uAPI, e.g=
. that is not something which can easily change.
>
> While fixing the OOM killer looks perfectly doable and will then most lik=
ely also show a better path how to fix the memcg accounting.

You think so? I can see how the OOM killer could identify that a
process is using a dmabuf and include that memory use for its decision
making, but the memory for it won't be reclaimed unless *all* users
get killed, which isn't easily known right now.

> Christian.
>
> >
> > Maxime
>

