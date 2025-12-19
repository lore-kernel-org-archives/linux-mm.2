Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8597D78794
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4BA6B0088; Fri, 19 Dec 2025 10:59:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BBD6B0089; Fri, 19 Dec 2025 10:59:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8A36B0093; Fri, 19 Dec 2025 10:59:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA266B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:59:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC754136B34
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:59:05 +0000 (UTC)
X-FDA: 84236679450.25.50A7CF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86B11C0007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:59:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jGEbws7z;
	dkim=pass header.d=redhat.com header.s=google header.b=mvZaG3P6;
	spf=pass (imf28.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuVKMRCOXiL/q8JSNbJx7Vrep0Xak1sDKET9rwhN+f4=;
	b=uUUyP4GgvJ+agMRR3+mRxdqlLzT6SFw9Rc3hOTA+I/c89zR7NCaPGr+QyH5j4BMElwTohw
	oaUIA7vJ6+PGphO8wN5B6ITa2PMO0AslgeDalpMmL0KLOwcro9JN+Ac5hsiBmJXgmqh3zO
	PnWp7La44wfnd9OhNZQ/+xXlp4sCoKQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jGEbws7z;
	dkim=pass header.d=redhat.com header.s=google header.b=mvZaG3P6;
	spf=pass (imf28.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159943; a=rsa-sha256;
	cv=none;
	b=SFEBDtS8tutE8/vf2sv9/9AZQizNU1Cry9Ekf20/DiHkLzHtJoa1Xl//WPvQcIvu2hytra
	h07utmuNvQeSQM8ttv77y3LXoeadqw90TNsVX/aEQ2a745BhuXt1JRYhadMthQ2u0U0Nsv
	3UB09JyB8Dow6Zn7n9TV+PGK2DPAe2Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766159942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NuVKMRCOXiL/q8JSNbJx7Vrep0Xak1sDKET9rwhN+f4=;
	b=jGEbws7zX+XBTH8UMxl6XsHCHT36VZ660+SsoXOCkDp11Y5iCUEQ4pCgN0BusDWoOOh87C
	xv8E4AQRjhgpQunlxLdiFVR/YuvO3+dLp6Rus1OojtDoqhpmdAK3qrbYFMjfHhCzbk0a4r
	CLrjOaNFfjsGgKdEStmZ6+eOq5df8gg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-7nWOLSzXOV2E054-qDTCnw-1; Fri, 19 Dec 2025 10:59:01 -0500
X-MC-Unique: 7nWOLSzXOV2E054-qDTCnw-1
X-Mimecast-MFC-AGG-ID: 7nWOLSzXOV2E054-qDTCnw_1766159940
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d17fff653so4564235e9.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766159940; x=1766764740; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NuVKMRCOXiL/q8JSNbJx7Vrep0Xak1sDKET9rwhN+f4=;
        b=mvZaG3P6Prk5tOECW4nBebZqgBmZntG5OwtvH+lm1Vb8m1OCdwwHLNPSyH4Izm6VXr
         yf4br1Xh5nCxj19z2dGUp8r2ZrAxgCfa/Pthkpu4HFd9R2hehmnWTwHkKPxkSp6z+R3t
         9rFZg86YJrQ4rlSuvTBAvE0+Wnjg5Sy/hyBKBpsc8aOMyX2dNL18Z287IBNPQrzJawGQ
         5gGxhHzNQ03QMFIVqyMQnErEsrmcpbLH/f/CYeRUTiVZGRwE4arQBr7/4nfjmWc3KqwR
         6BOCR0A/jTbybWpzm2Fst/1MikulYppTNMhO8DENsU9d3Ijo8SpL/9p0qNNLVxPd5kd4
         /Luw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159940; x=1766764740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NuVKMRCOXiL/q8JSNbJx7Vrep0Xak1sDKET9rwhN+f4=;
        b=hpIvwPcL5pALLU4GCv4Ja8uTRoph1/04XMxCtTYU1K8E49M2DHetlwlGAPg0LXtzAV
         JCbXm76wpNgnigCAfZ2KEQpA7SE8ZjDsW36Y3/FGv2AQ+BJLoN5hGA6mw8WJtVlObP5I
         5gR0PoLMLLxXAk/NJf1YCLfhBSMnQWJ0/YIB/5s6N+cUqp3tXFb2RGf++AZXcDg1+zp0
         XhWcWFDItiIigvK0onhHXdnQSsZMUa7992KbyUz5W6IV+DZgUkLdQKsMIMF76TsmkW5N
         ZPUaeWP+wzqOGrtS1VA7CYr0Jze1R4mQSYE+JvroHVZKs0Uo+q3j3e6ReoN+GdCAGBep
         IwyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXijbVxzUvTqRqVS8gCB2Hlf2iOrI6BboUIWnFaF+FwX4vO8hFLmbjNxRD+06pekRkOS36X9cgH3A==@kvack.org
X-Gm-Message-State: AOJu0YwYN7cMn5jkT4JpC9zCTkklPydKw+n7sHUf5om8p6NbhgtYgPeg
	4PcQ7JtB66A4f/uE1SIqSDRXYpiAg+1bbsogByE9iE52XAl4vUdBOReI3vz+uUVgfGPaQTlBCYP
	tF7rgzceqv4eBcX+ddxT9443sl5Il2hd0800UeWhqqwFbaUfA1FY8
X-Gm-Gg: AY/fxX4DbO9OAybTEmM7hO/S+qcGvxwH8PqQD+lfT7hh8ifwR2RoPHAzuhDOS4s0lJf
	e4455/GFi4bxwZzCsVW/KNIIJAveLxm/uafN4bf34ily3tSxHKGPsF8H7lnCvpiTqvonzwMhA6D
	l7llNQo4OtVekytJJuOTsogrjCfJpXH2acFdEgORJYezNeLlY6qIOzAdCqQKo+9FZFiWYCPGjZx
	1CgRhg43mwrNsC6bV5DFjbRmj/PM/SN5cZ124ZBlcKaRih6VbfMWYcIxnx2KSJEkaAaSQNdM6iO
	1LgWJN9ICszhMNv6Hpdyty4pAkxAfwSpc7sUh9iQCzd252du8lx0aQlw+uhPdQ==
X-Received: by 2002:a05:600c:8710:b0:475:da13:2568 with SMTP id 5b1f17b1804b1-47d19592102mr31215185e9.25.1766159940206;
        Fri, 19 Dec 2025 07:59:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGz4saKUE5xlJBqdu6Gk7rmDOjerDoiXpYwJNHDHvTSpuZXU0uy6ESaJF6LqfbEUnkQVRXGsw==
X-Received: by 2002:a05:600c:8710:b0:475:da13:2568 with SMTP id 5b1f17b1804b1-47d19592102mr31214855e9.25.1766159939720;
        Fri, 19 Dec 2025 07:58:59 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d192e88f5sm49165545e9.0.2025.12.19.07.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:58:59 -0800 (PST)
Date: Fri, 19 Dec 2025 16:58:58 +0100
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
Message-ID: <20251219-cuddly-platinum-cormorant-ae6d0e@houat>
References: <20251211193106.755485-2-echanude@redhat.com>
 <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
 <07cdcce2-7724-4fe9-8032-258f6161e71d@amd.com>
 <20251215-garnet-cheetah-of-adventure-ca6fdc@penduick>
 <ef52d9e9-6abe-421a-98f8-f96353652e1e@amd.com>
 <20251219-large-daffy-monkey-74665d@houat>
 <5eda1755-865c-4bb0-a1a0-a4e6dac5388c@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="62gvz4x3u7aurz3v"
Content-Disposition: inline
In-Reply-To: <5eda1755-865c-4bb0-a1a0-a4e6dac5388c@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86B11C0007
X-Stat-Signature: 91wz14byuh3u6h18w5meu665bxegg49m
X-HE-Tag: 1766159943-163012
X-HE-Meta: U2FsdGVkX181SyMHuccfjF4IwT60vaAbJM+bARp/vGwbChxLxdN4k4vy6HP7Wv/Nah77Kz08PJpyf2oyXQnHtScr+vSbeAWJYGPqQrxkBbLCNmjfd+hPPp2c5xQ6PRLBOHtZrCBVlgQFKPvC0p814UOR1kGfb7gpma2kK5+b/LOWkRcv5aHTbcYHZw4fdNc9idll4oOUfR6ibYjNgCBxwqcwqsk7kGR5l4yDYxXIhds4sxjgpIWcF9azl6OoP1pNRh23MHncw5vueHO7vOtqWKL5Yogl696vs8kmHvLYfTib2+FozU86aCGtGvrpl+f/oXa0mwymt5QaGvChGJpsBBSTjiU07qFfnGemJ+NcrvgdJuU0aj8/2vtORff0hAJJPQq6pytf20dXhNT2ZFkrpUSDXfPz2uCe2/is8eq3jHdUKN40GKHMGCTerZIcypeeN/D5676D7wERa3B99hz4rBEFPm+BjcrevM0CQHSuEMik18JtT9S5p5i7uwtfnE7po7bgNUwQdXtWHEvszV636jx9rTt8YrifGmE9IQiaRGFRhSVB8+GPdS5jqLkE7HJnlQYKIqatUrAZaO6nA2HLjKdGROp4JmFB+qso4OA6zQVA/4GNlmDYS3deGYYg8u1la1TLEYN26z1c9yI3aP5BSN3Xx9wUk86pmrlilg/Y5nH0msnQ7CWlWtSsVTjBZzsd8wkwr6C5qeZczCuPzRU2oMZFzbHK2+sVRBeAgFc1ziRD0Ym8Sh7LpnHYQsI3iiB/FAQIxTE8EPCo15LG1kRDs8fKBDxqCleQYS1C8LV4uLhfZpLpvDV+zlSbYTLDBX7sFffeXZGIABPpXW8MF2a0exOba79tV3/OAqOp+bARhF7MkM3UqIaL4vvtapdISbxt1rqTpoSgLMjOO/gOn9vH7gbkjC4o0ExXQ9H0Rr76BunSJrGwa2ZEirQoneIoed0haZw/oebwh3Shvl6OnmE
 9wV0lqjO
 X6HutztiD1W+zVSXa99Cay2UjZLFHI0fTTfw2Ytegux4FTU5YksTIdrdy2BRDZ7N7gxz2kQ8yIr3rKvSR0SmeJTXeQSyeZUjfHN3fONtnW3iuH/enVX1OE3rktzkCezjFgU5o2l+q+LaFVrQ2Pl1PKiNw4zSO03PIB2PYaBrr3yPFNc+ldpfw+BMTKDwki8twUx7HuCJRHQ6BxuuhctM2Mum9BI9ufdwEn/VpLusa72mv/+TmyeUg4X17ofYTqunlrXksR/RXj32fwOq0OxkXF987lo6ajiCLLPQ7xsnSTxjY1pBoOtK2jLfLWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--62gvz4x3u7aurz3v
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
MIME-Version: 1.0

On Fri, Dec 19, 2025 at 02:50:50PM +0100, Christian K=F6nig wrote:
> On 12/19/25 11:25, Maxime Ripard wrote:
> > On Mon, Dec 15, 2025 at 03:53:22PM +0100, Christian K=F6nig wrote:
> >> On 12/15/25 14:59, Maxime Ripard wrote:
> ...
> >>>>> The shared ownership is indeed broken, but it's not more or less br=
oken
> >>>>> than, say, memfd + udmabuf, and I'm sure plenty of others.
> >>>>>
> >>>>> So we really improve the common case, but only make the "advanced"
> >>>>> slightly more broken than it already is.
> >>>>>
> >>>>> Would you disagree?
> >>>>
> >>>> I strongly disagree. As far as I can see there is a huge chance we
> >>>> break existing use cases with that.
> >>>
> >>> Which ones? And what about the ones that are already broken?
> >>
> >> Well everybody that expects that driver resources are *not* accounted =
to memcg.
> >=20
> > Which is a thing only because these buffers have never been accounted
> > for in the first place.
>=20
> Yeah, completely agree. By not accounting it for such a long time we
> ended up with people depending on this behavior.
>=20
> Not nice, but that's what it is.
>=20
> > So I guess the conclusion is that we shouldn't
> > even try to do memory accounting, because someone somewhere might not
> > expect that one of its application would take too much RAM in the
> > system?
>=20
> Well we do need some kind of solution to the problem. Either having
> some setting where you say "This memcg limit is inclusive/exclusive
> device driver allocated memory" or have a completely separate limit
> for device driver allocated memory.

A device driver memory specific limit sounds like a good idea because it
would make it easier to bridge the gap with dmem.

Happy holidays,
Maxime

--62gvz4x3u7aurz3v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaUV2PQAKCRAnX84Zoj2+
doBbAYCwC6GM+nDbVQ+qPSj3EG6TPcebfy5+uYyIL8SOICJl/3ohBlkB/AN0k0qs
+sZn+aYBewZWQxkmfc2iSOFLjm35fV4hD2oDDGu74kWLPPrJefPelEf0OooFJoux
CX9E84nf8Q==
=seo3
-----END PGP SIGNATURE-----

--62gvz4x3u7aurz3v--


