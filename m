Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75879D5B174
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 13:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC72A6B0006; Mon, 15 Dec 2025 08:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C776A6B0007; Mon, 15 Dec 2025 08:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65C36B0008; Mon, 15 Dec 2025 08:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5C136B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:59:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56632B7273
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:59:12 +0000 (UTC)
X-FDA: 84221862144.01.06FD3C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1AD681C0010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:59:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PLrKnES5;
	dkim=pass header.d=redhat.com header.s=google header.b=cFlBbPcT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765807150; a=rsa-sha256;
	cv=none;
	b=2iPUrvYdKJogvP04DWbaWxe38Xsc1ZH7YKWNwjxuOQm5/nRleZ2TlPRt6YQ/kx24nRDifi
	3GDjwOmdPYU4mAviDFS2RfSmqC6bpqvtvLAvrt+7lp1JopdVSpoogxHUKEFSnW8S1kUelF
	03zEdOrPdp0dVI6hco+AuYNNA1MH1i4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PLrKnES5;
	dkim=pass header.d=redhat.com header.s=google header.b=cFlBbPcT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765807150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxDTKwhMmaT8yFIgWPPRxzSP91DdXIWwn+nIL+l50K8=;
	b=MnnRyvNh3UrAqRaAD6g1tZ28AvZO+RMjOFDx9V7/wGFmVCKidSHw7+aUSXj03aRt9x25M4
	Ckxmu0nq2SiLuSgwI50O2oAz760qpTR6knuP6zQ2EkXGhe+FirQjbG1fVUfVSM5SBD3h+Q
	tgIZb2D4mwTaV/5ccelFnXDbuCbb4b4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765807149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fxDTKwhMmaT8yFIgWPPRxzSP91DdXIWwn+nIL+l50K8=;
	b=PLrKnES5VVMlwfJXVGQqt+vJ3Jq5vo3CXkiQIvJnoqHEOLIifjwd8v6cx6/yOmEWHVoRE+
	sBUdFDDW86LbQl6my7mXyEZwDvLK/4mKTFsU67UPlDoNIsZXuMZ9zXWWV3lPwUfZQSOKpY
	KEdoSpJGOthz/4r9ybQfMbeFV7XaYKU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-ETEgWj7QNzG-K1ekZSNRuw-1; Mon, 15 Dec 2025 08:59:07 -0500
X-MC-Unique: ETEgWj7QNzG-K1ekZSNRuw-1
X-Mimecast-MFC-AGG-ID: ETEgWj7QNzG-K1ekZSNRuw_1765807147
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477c49f273fso36719125e9.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765807146; x=1766411946; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxDTKwhMmaT8yFIgWPPRxzSP91DdXIWwn+nIL+l50K8=;
        b=cFlBbPcTJNoGhwszT4QlUwsaqKPM7ZVPuxAZoRBxk6jQI86LoEs93zVC66Q+g5a5A6
         RRdIAdhAFJLH9SVK1u1W6YKzS+VeJJfU0Lr9CozvNKYtI9oMByr/UYdHZd0OzA9kOuQN
         +KKnIZoebm3o43ERT9zLyedSKdHfngbXbveUi5A+OkdwG2Rk/O05zFMpZlSUE2dpi5x3
         DB6zcMGSCoJM3FlTLJq/QguBIdUa37z+0ael4zOrjQMh8hfv7f8NInFUhX0xV0ZHZmuV
         L2R2iyyV4Hxka/cT11qOPoLTXLX0dfefw4l9qbsfajzONzeXfFjB9Xc9m4D9p7EBnsib
         lMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765807146; x=1766411946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxDTKwhMmaT8yFIgWPPRxzSP91DdXIWwn+nIL+l50K8=;
        b=lgwufLe0bf17TlWrbD9oeDrFE2vk3ncjTAp0UipjqXVVm4BEaVCM5UW55N1vactZQe
         A2roZW1O4JInU5/MBsRBq+M9k3TTutwrEEImZ4MZey/3HIQzx26Xy9AR4T+UzZ78krN4
         dEDvHbAaMzBe3c8e5aaIzdcQ0aKnsZk1gLKjjDhuvQLmi8wd0DvmTwvsxjlFS87HxPQX
         K6n+k1zY7APUdwZf2YLMZB36Z2e1GoRV6gYIDXoBR7DHANXMEqC4oQFsqsxmO2/lHgxu
         BppJYacU+B1DJBzEhquDscDn4BDBL3QB5paWttxMgVSDp05DRhAOMrO4ZJdmsoJJzIYv
         8MQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUl8QArS/OP38rscDS32kMUD1bSQJUgNtyOAvyAVmeXGuGlulzjNeCGlC5E3OmlgXDv5JG5bAM+1A==@kvack.org
X-Gm-Message-State: AOJu0YyjbWuTNWDZU+dOpqgPlULr9RTiMMzJQR8EKK4Ril1hLpOiG3Wz
	voWz7ut8aWytAv7FOmrTKESgdlFNSO8fovTO1HgXzVjR/0qpSRBBPE0MZJFlibI6+Zq8AQiuyL8
	d4Z+iG8fQpuILh3zVaF9XADvTkDp4g7j821swg2B0slFt6eqDQ78Y
X-Gm-Gg: AY/fxX7C0ALEZIkCBwvUhZCZPLvwfeeSCtq2dPOd7Nc6EnQmplQh41k6gmVgMBGDQBs
	ys3QPWgZb4+uMeKxmom/x39wf3qXG4Ixm1aHd3FP4z4wpOxwZnij1SjYJBE9dZO1AHPkNajqQCj
	aetQG9Po49tdDbKwVrxTK3NzXiMiJzyK7OXl4++0lWDBgtSxR1j2E4nGFiMjQQr7/VSCcXXjaQU
	BRiB9wGd9wj1ckuOCatJQ9hyGU6jB5B9LUfx7qMFYc5V6p7iT8d6hCpDs6iWMulo0NWZoM/3UEY
	Z2avC65RE9xYevwuns4ZR2oTYpFnCght8HqwibyvKEO0MwCvg+t9Z5pVWR/VfItMwab3Mb7XjBZ
	4X6hJ
X-Received: by 2002:a05:600c:a40e:b0:477:b734:8c52 with SMTP id 5b1f17b1804b1-47a900bd6cfmr88610685e9.14.1765807146410;
        Mon, 15 Dec 2025 05:59:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqFocdgwq3FCiLwNZCPP3yGh7X+/+A4X5ZrVtcOGVh8JXh/FPlhQAyGrD/wsm7r0PlrPxysw==
X-Received: by 2002:a05:600c:a40e:b0:477:b734:8c52 with SMTP id 5b1f17b1804b1-47a900bd6cfmr88610465e9.14.1765807145881;
        Mon, 15 Dec 2025 05:59:05 -0800 (PST)
Received: from localhost ([82.66.159.240])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f4a3e9fsm187336645e9.6.2025.12.15.05.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 05:59:05 -0800 (PST)
Date: Mon, 15 Dec 2025 14:59:04 +0100
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
Message-ID: <20251215-garnet-cheetah-of-adventure-ca6fdc@penduick>
References: <20251211193106.755485-2-echanude@redhat.com>
 <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
 <07cdcce2-7724-4fe9-8032-258f6161e71d@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="l7ljucmjyhr7i7d4"
Content-Disposition: inline
In-Reply-To: <07cdcce2-7724-4fe9-8032-258f6161e71d@amd.com>
X-Rspamd-Queue-Id: 1AD681C0010
X-Stat-Signature: 3s6gjw9ykgifp5c1q8gg6yh873gsad1w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765807149-935556
X-HE-Meta: U2FsdGVkX19luOQPlKhJU0sppMRtwkPGdvcBaFlS/e69SggNR/kZtjsJ/qM1MUEYxcfZmw2kfq0UVvy0rX8PByra4JwaFZARnhiDs5khfXI29xW45iri3BG+8beF2kmAyOVOPnlpSv/p9eJWKY9y4OyBA5bdttUnZZWYFnLBWKClpeS62GFDJjImsi+2QAYEAJWxAKbeEtMIfLTTXQpt3yWXS5VJwg6e/Lq90jtFdapa5+7MwC7JN+LEGdMqBQJRcYfXKwvOGtpHwFcQfHiu2ocPX78izd+xdVRrx9FM8B5TZp4WlM5jFIJFUiVPAtG5ww2OwmoAB3rxlxx/2gOVJXMr/BKst/5vgBw/oH6GdzLJ1m78UgxBULTYQbsXwH9cFkNafhUKVMsbKOl/sXKtTnQnyRqIqqnMwbfsFE2iOUMbwZO+J6iB/WDiXR/vnAkjNMliJrWyCgvz74STRGV0czevt1gDdurRkQg4IFgdL9EI40lHjFHHrmLPAVx7dUO9KL4gg/e+Jwnze9joIoG9S0AU1u1KFpBlLLYIQ0c8Wtb5r1aeliHWd5BK7C5z7skDDcqgQy1L3+0d6dotCncgBc77UWZEM/9nxUy/oh8h8zBXQi2e1AT7gY0csF7TOSqnCaCGU3OQf47KEcpN5ukiJi1MxAajN8l6B/bOrRl6/RPOLYblYjvGNfIL71dwV5QxfaLELP01YwroJJ1R61BDOnQHkeDyC6yGLkHIXTQnk1qc+8TUamZaE6/hBYqAcZ8KOcoXJyNxKuHyl8480rScnRqIoOl0ot3Uw3Ifz+p0l59OgIAiu6eZo07JfKXM/WCe8rJDBt1yLL6ZVQk6TMo/+IhWYlVWnJTKvUPivIflH4z1tsO3riMuyzjhpW+i3aySYQcb67xPjN5ZwA2NoQJXOEmQxqMqBpAoPAOX25BJ5E8Ho9DWvc3XuHWTg0AOqFGYxI81vLQuO9TNzJfeZl3
 gV87dUO/
 fN+swZ68fD3AQcmYeHm45u2cUCi9j6wRtfl68mG1Xw9mesLUTeEnnxq41r5RpNKNpR5pc1gsPvyLqhxBGiQ/F2sr2Be4+Ieg8vJKcp1wf0XR92mnZuSQvgk7n15RdVuM6HsKIWDqvjAkzQGBW0yO5Uep3Ac/aBJBOhWuc2N0IHTx4lPiz7sQ4WRQsrSkfnWWInlGB6OSAISW0v9HnpETsZ2lOjATasrGgAlHwLwHE5vi3Ti8DPWmhMAnkD5SFB3FXbECeaGZUd7JHX4T95VdNNYO6el2vL/yCj05JZ9dHR60hm/+tOHnrjAwzsvEXxi4V956JlXh06SehdBWAGe6f1VLhmH8Qj5WMXHp8oHudj7kjAaDBJoWHFY5isw5aqZggT9BJxN7+IhUgHAtAwSlXOp9c4UXCdLyzXsTrJPVrGgELR64AeFCWWz4CvLhJ8o89Yo30c7XRN7er6JmncziCkX3Cofl2UiTXONNU9hhdTBjV+pidYblHxjOdY6OK6xoyQ/5/KOjQUst62C1wiP2IAxCnAStM8xmfjeEXROI2UvaBpnHo6v6uakRH1FOLRZanqUhLQcLpFvht7hw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--l7ljucmjyhr7i7d4
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
MIME-Version: 1.0

On Mon, Dec 15, 2025 at 02:30:47PM +0100, Christian K=C3=B6nig wrote:
> On 12/15/25 11:51, Maxime Ripard wrote:
> > Hi TJ,
> >=20
> > On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
> >> On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@redhat=
=2Ecom> wrote:
> >>>
> >>> The system dma-buf heap lets userspace allocate buffers from the page
> >>> allocator. However, these allocations are not accounted for in memcg,
> >>> allowing processes to escape limits that may be configured.
> >>>
> >>> Pass the __GFP_ACCOUNT for our allocations to account them into memcg.
> >>
> >> We had a discussion just last night in the MM track at LPC about how
> >> shared memory accounted in memcg is pretty broken. Without a way to
> >> identify (and possibly transfer) ownership of a shared buffer, this
> >> makes the accounting of shared memory, and zombie memcg problems
> >> worse. :\
> >=20
> > Are there notes or a report from that discussion anywhere?
> >=20
> > The way I see it, the dma-buf heaps *trivial* case is non-existent at
> > the moment and that's definitely broken. Any application can bypass its
> > cgroups limits trivially, and that's a pretty big hole in the system.
>=20
> Well, that is just the tip of the iceberg.
>=20
> Pretty much all driver interfaces doesn't account to memcg at the
> moment, all the way from alsa, over GPUs (both TTM and SHM-GEM) to
> V4L2.

Yes, I know, and step 1 of the plan we discussed earlier this year is to
fix the heaps.

> > The shared ownership is indeed broken, but it's not more or less broken
> > than, say, memfd + udmabuf, and I'm sure plenty of others.
> >=20
> > So we really improve the common case, but only make the "advanced"
> > slightly more broken than it already is.
> >=20
> > Would you disagree?
>=20
> I strongly disagree. As far as I can see there is a huge chance we
> break existing use cases with that.

Which ones? And what about the ones that are already broken?

> There has been some work on TTM by Dave but I still haven't found time
> to wrap my head around all possible side effects such a change can
> have.
>=20
> The fundamental problem is that neither memcg nor the classic resource
> tracking (e.g. the OOM killer) has a good understanding of shared
> resources.

And yet heap allocations don't necessarily have to be shared. But they
all have to be allocated.

> For example you can use memfd to basically kill any process in the
> system because the OOM killer can't identify the process which holds
> the reference to the memory in question. And that is a *MUCH* bigger
> problem than just inaccurate memcg accounting.

When you frame it like that, sure. Also, you can use the system heap to
DoS any process in the system. I'm not saying that what you're concerned
about isn't an issue, but let's not brush off other people legitimate
issues as well.

Maxime

--l7ljucmjyhr7i7d4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaUAUIwAKCRAnX84Zoj2+
duttAX9Ga4fqCYlX2dwZgwnc6nPNr0N4H4lEcTNLVs1FO6VC/tdfQXgym9Jnci7z
b5tpPZkBf06sCKJuANIMHhKZwJ4dsNb9bC0X9JuS9CoEhy2fKPraCO3Vf1oezx0e
uJhMcKjuFg==
=SrQ0
-----END PGP SIGNATURE-----

--l7ljucmjyhr7i7d4--


