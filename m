Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92AFD767C1
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 10:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5B16B0088; Fri, 19 Dec 2025 05:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83A66B0089; Fri, 19 Dec 2025 05:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61F06B008A; Fri, 19 Dec 2025 05:19:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A17F36B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:19:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 268A613B2CF
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:19:23 +0000 (UTC)
X-FDA: 84235823406.08.DF615C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1DFA140003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:19:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FpNhUZOU;
	dkim=pass header.d=redhat.com header.s=google header.b=Jje+dfT9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766139561; a=rsa-sha256;
	cv=none;
	b=M0BtezFC7kufWFdcKIwcOxV99mZNsDqEH8J7aMXOeuqc3KPKee30Gr4Vib41lXZj+C456m
	UWOme546A8qa12LCwku8EMVBdP+xbp8rlfMLkuc3/6gL4jEIUe1FVU2RqnDbvrRMPm+A+8
	I3MNIJ1Lv3erwJCZ01rVoMOSEx8VMU4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FpNhUZOU;
	dkim=pass header.d=redhat.com header.s=google header.b=Jje+dfT9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766139561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+Sjh7UuYFLIovf/XxlzAidLiUL3k2dY2RdNBAzDrDc=;
	b=1TCVoLqn6kKqriGULcA0XicA5BEn+HJ7VLdJgsUdoo+wJI179sO8PaaXFN0cLsS1wI5k3Q
	12ESaL3jw6Nk4pMzmeeP18iWpMvc095KHTjA99RL+yvlbu5u/PmOa/sMm0/n6oqhM0BT3p
	QqR0FNrGyyARGR2JxEFjyLv65fXe7rA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766139560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+Sjh7UuYFLIovf/XxlzAidLiUL3k2dY2RdNBAzDrDc=;
	b=FpNhUZOUC81ql5ptF8dqy1pu+8kqqMuibACzm9NTcpudYVPO4s3KgGYyhcQIryOTHkUuwb
	7sRaaL5xzQRpSKu+7rbRJmBdRbscO2WzQqSezrRNFKQUrDHHiSOs+vJAqVN/iLciznZK1V
	REQMkToL5Lfc0HELFpkfj3XilWP9lHw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-dL27xG0BNiik9W9MmzSZGQ-1; Fri, 19 Dec 2025 05:19:18 -0500
X-MC-Unique: dL27xG0BNiik9W9MmzSZGQ-1
X-Mimecast-MFC-AGG-ID: dL27xG0BNiik9W9MmzSZGQ_1766139557
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43009df5ab3so938581f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766139557; x=1766744357; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+Sjh7UuYFLIovf/XxlzAidLiUL3k2dY2RdNBAzDrDc=;
        b=Jje+dfT9SzyJyhSvm6gnC196/YyoO1LT1gwJvBi0NrOPV0kixQO/N5A7CG1esEAnuv
         s1NIyhPFTjeURWaSiYXaEolNRfT6DVL5g2Q+jgRGiv7dX+CJLhtiht0VsbXoLnYcCj1b
         RSOBk8pE0naUvBECKFZ2Dt+Ts8xNDwynDpCNwlqXXJMFb3hA49WoJQLa46tGovmIZQvA
         SWcrJvVzk2JU78Wdx6BMwS1NryfyLAMElVHWGflqKovQ8CCULF5wTwfV6FNoRy5BDMDV
         43VocxSXLYHLr3st+1Pk2L6f8BeLmLg3WC4ht/PraHbzaMHSTgzc3aSw7BDsm8mTw+Hv
         iIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766139557; x=1766744357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n+Sjh7UuYFLIovf/XxlzAidLiUL3k2dY2RdNBAzDrDc=;
        b=i9W3P+c6YOo/LflggVBDJ6DHnV+4wNZ7lNOiynf1mZ8VOmJWgphNuITKRcfz+NmLIt
         Xk47JwxP1hPj28HkKFrXBGaC2UuqJ6IhDti82AHO1Vvw5EkDrmuL4hr732g4XqEY1mbJ
         BlNiw7cp7exsr5JOJ/e5jEilcQMurnWjNctmpWj2MjyiZ4n+ZMkjsSa7YEPNKdJVuyYC
         lepeZ+BbVguFw2MmjNHRLFvH/ib0dhQ0yiJW0fuum1IHbzJ9dVbxO4QnN/rCAhxT5LOW
         9kByXF3UcnUSQdwyKqf6klyCxrLg6ezxC77HJLo+NBSW6XFYXbzsogKQkkDCjrZDUqtJ
         PPXA==
X-Forwarded-Encrypted: i=1; AJvYcCVfSoji4Od6T+nnpZupu/6fbPllmeAGHcDTrgMP3pYtFYLlvyfK3ExEh7n8I9HWJSjF/+GPozO+9g==@kvack.org
X-Gm-Message-State: AOJu0Yzs8hQFpaxLwy/uq1YTj3G0Cow6wLjeOJ/IX45F6+l+qWmTE+gN
	yo3vuPCA7fQxgongZS22DF+7giXGUJ96eN6C6Awd4Q9oIvxQmxcyEVCafMHcWgHRA0MSfD2nfK2
	vEHQWnVa+5iLlhs8wxgh1X15IXgbClN8h/T3+xu3Fs9lVBWSrQqOF
X-Gm-Gg: AY/fxX5FezdyMmUQ8FuDmB40fHL9cRLynm0L5marXTigssdYiD3jJdeoJMAl7qphplT
	tH0nVPDgzG0qiaFHQT1QWPOOkoj3IZUWstDpgz2g8F6TsxiVd5/hWp3XM7uv7av3NI95kCCajkQ
	Sqidaw58YyBJPVIcFYKy6Jfw72TQZjv40a1GKEGmOfJMb7Z3jTZmxkL3NL1m0bVbPdQTXoZ4um4
	8LxYKkjolo8aFE9BAMKMoFPQlMZUw//YsB0YBTHH7YKM7hDhVt8Wxnm4xiztvDUlBSot9WkLjAX
	Thw9CsFAIgjVoH/bcMZVhENS4h/kffCoX9q2KFEPYAvR2eDxloPWgsmyP9X05g==
X-Received: by 2002:a05:6000:1868:b0:430:fc0f:8fb9 with SMTP id ffacd0b85a97d-4324e4f9458mr2556873f8f.36.1766139556956;
        Fri, 19 Dec 2025 02:19:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeh4Zbkr/D6P7HWKArF0jdwKfFL+l6ZrJJ1FavgfXi5moav7Q7vb1/nUNiIeSf8i+9DMCNLQ==
X-Received: by 2002:a05:6000:1868:b0:430:fc0f:8fb9 with SMTP id ffacd0b85a97d-4324e4f9458mr2556840f8f.36.1766139556391;
        Fri, 19 Dec 2025 02:19:16 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa0908sm4147867f8f.31.2025.12.19.02.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:19:15 -0800 (PST)
Date: Fri, 19 Dec 2025 11:19:15 +0100
From: Maxime Ripard <mripard@redhat.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Eric Chanudet <echanude@redhat.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Christian Koenig <christian.koenig@amd.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
Message-ID: <20251219-precise-tody-of-fortitude-5a3839@houat>
References: <20251211193106.755485-2-echanude@redhat.com>
 <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
 <CABdmKX1HgSzUPS1Ot93tpctgunfHt_F_XNROB6zzpu_u0oH2=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="4cy66ljvjeto773l"
Content-Disposition: inline
In-Reply-To: <CABdmKX1HgSzUPS1Ot93tpctgunfHt_F_XNROB6zzpu_u0oH2=A@mail.gmail.com>
X-Rspamd-Queue-Id: D1DFA140003
X-Rspamd-Server: rspam03
X-Stat-Signature: fkgdyxy55s5xyxnikh59ensu5e5ezn46
X-Rspam-User: 
X-HE-Tag: 1766139560-820408
X-HE-Meta: U2FsdGVkX1/kyhmAogZitAWJLf0VfXtd76JggUtgvJy1ieumqK9wCq5mxayBuXM+Rlrto4TGiZI/K08WS7PZQhDxPCqFZE64B/BC1PEbgyWyQMDlCB7c7ljn3ibDypJmAF/coVpynKbH1yinsDCGE1gup+tz3jav0Z/N6WlbEPyBZFFMLYnKywAk3OYUBC/QugyC/3FjdwQXd3CADjbgYedt6cq+Jxz1ri2ZQQxf4w9elYhRPYqR/YGN9FE15IS/Eh34cimlAJc4WgewkD6feMHRM7acN96BRYQcOsSKc/Gn+NZ7oniLf83jO2F2X1/DQxyysBGTlFH12UL55orkFyaIK/XUg8m5HgXqYjpVEHS2SkcQ9xIMMPy8DP4Dn3K9TnOr5B2VPCDu+tcwNis1I93DdWTnp5VH5xylUCZDOyOU9WlA2yQ8BeYjCeJF1AH4KZr7Q2qytzzj55i7vZYjja6Pr5XeNp/dnzx5dm/VM7rqMsAwNtil6s0FQwCJqDBNzcsntD5PSG5HZAdph8jRHCDj0Qg3CILvl7mHgBr7ZplB3/CngkxoyJ+ZzUWdeiBQIHLO8mgtuRGTNlbZOlGGMVcMH1mWG1W+dLn3kNxJBJHSwdhaQ6JtlGS1v6/pHHDbMV6SSuiYXg9MYQD65eHK+j4OvXlqxlbVr6wM5j+hTTGbiC0Pwuy2lpvH38mZCExMuDDW7Egf0ywHUvJl8U6M6JgqIdb9iMVBLr6pVrmf0++K3xqMc5u6whio0YWP8q9r6sYadXnNlkGV3yYIK7bbUGlOUJSlz9jIbPYd2XQ9ranhHno+JG2Ty5G3H1jBN8PgHVMjR0Q59Mcu0jQZ1xE/xrH64gp+AwdjilQrc4QhohDrRI9JcQDmw6Z+eilzl5vQPmUlU0DHdC+YEqdTuipAKu2eN+cJSk7nldLghGUUBUCteIjbAr8KyXu2IptI51kp/yCMRwBIjYo0xegkeS/
 m4HOe8YU
 jjyNmTFlVxzhTH5x7iqIdBdUxIBEfv0Dlv8iK2R0HveIsj5392encHvm4LnP9q1fRnI2obXrv+LOfrmazm/kzQvm12xaQdIa4/piPFFCaRtNCSESfS9vEg6VVVuhS+0nmzKmDml1NZg3qXiQ6ZyH9i7KKvJrfSgHFWvrBfP/A7Eeh46kdTXYq2esWDm72+YT21AkXsjwRqXRnVxihrqdvPm2PKrW+q2d/MkvXrab2gAMgHKnnG4Q6fxh0UN4qXTdH8Mx9dWgGAbWeaR83iiDdQ9FeVL1ucffBhBZXk+3FtXDLn+G5VMuO/R2Q8RdIOnT9LAk+bIXTrHoRYG8EK0AiMenHAvto/9wzahIZkkNFHz/uU/fftrwA+k9GfG5ywNsRXqwI76czd5Kh+vBxIdnUbIsli7+9SY08B4ZmYDTDQ8uGtHRZpepB1+p3477oe8tpjgKXoFNolGCRKZl23ai9NEdTm3H9WkPZRGfUubhr7TN36ayWepJQbblHEZPrDeYpFR2wal6fCuXe7Sanl9buIThA0/r0cmEBNLWelewndOW/bnhLmKbIn5NAJ4R+JD/hkoNpbRkx+Hk8cb9DCNYOTQUoPzoB8UGCRos2uBYUOAq43qYrJTkCRMsC5wuep/qzg2wDKvpBTe6wqku1jX8dTEKnIKzAHeZ01Pm3dICehonHubQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4cy66ljvjeto773l
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
MIME-Version: 1.0

Hi,

On Tue, Dec 16, 2025 at 11:06:59AM +0900, T.J. Mercier wrote:
> On Mon, Dec 15, 2025 at 7:51=E2=80=AFPM Maxime Ripard <mripard@redhat.com=
> wrote:
> > On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
> > > On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@redha=
t.com> wrote:
> > > >
> > > > The system dma-buf heap lets userspace allocate buffers from the pa=
ge
> > > > allocator. However, these allocations are not accounted for in memc=
g,
> > > > allowing processes to escape limits that may be configured.
> > > >
> > > > Pass the __GFP_ACCOUNT for our allocations to account them into mem=
cg.
> > >
> > > We had a discussion just last night in the MM track at LPC about how
> > > shared memory accounted in memcg is pretty broken. Without a way to
> > > identify (and possibly transfer) ownership of a shared buffer, this
> > > makes the accounting of shared memory, and zombie memcg problems
> > > worse. :\
> >
> > Are there notes or a report from that discussion anywhere?
>=20
> The LPC vids haven't been clipped yet, and actually I can't even find
> the recorded full live stream from Hall A2 on the first day. So I
> don't think there's anything to look at, but I bet there's probably
> nothing there you don't already know.

Ack, thanks for looking at it still :)

> > The way I see it, the dma-buf heaps *trivial* case is non-existent at
> > the moment and that's definitely broken. Any application can bypass its
> > cgroups limits trivially, and that's a pretty big hole in the system.
>=20
> Agree, but if we only charge the first allocator then limits can still
> easily be bypassed assuming an app can cause an allocation outside of
> its cgroup tree.
>=20
> I'm not sure using static memcg limits where a significant portion of
> the memory can be shared is really feasible. Even with just pagecache
> being charged to memcgs, we're having trouble defining a static memcg
> limit that is really useful since it has to be high enough to
> accomodate occasional spikes due to shared memory that might or might
> not be charged (since it can only be charged to one memcg - it may be
> spread around or it may all get charged to one memcg). So excessive
> anonymous use has to get really bad before it gets punished.
>=20
> What I've been hearing lately is that folks are polling memory.stat or
> PSI or other metrics and using that to take actions (memory.reclaim /
> killing / adjust memory.high) at runtime rather than relying on
> memory.high/max behavior with a static limit.

But that's only side effects of a buffer being shared, right? (which,
for a buffer sharing mechanism is still pretty important, but still)

> > The shared ownership is indeed broken, but it's not more or less broken
> > than, say, memfd + udmabuf, and I'm sure plenty of others.
>=20
> One thing that's worse about system heap buffers is that unlike memfd
> the memory isn't reclaimable. So without killing all users there's
> currently no way to deal with the zombie issue. Harry's proposing
> reparenting, but I don't think our current interfaces support that
> because we'd have to mess with the page structs behind system heap
> dmabufs to change the memcg during reparenting.
>=20
> Ah... but udmabuf pins the memfd pages, so you're right that memfd +
> udmabuf isn't worse.
>=20
> > So we really improve the common case, but only make the "advanced"
> > slightly more broken than it already is.
> >
> > Would you disagree?
>=20
> I think memcg limits in this case just wouldn't be usable because of
> what I mentioned above. In our common case the allocator is in a
> different cgroup tree than the real users of the buffer.

So, my issue with this is that we want to fix not only dma-buf itself,
but every device buffer allocation mechanism, so also v4l2, drm, etc.

So we'll need a lot of infrastructure and rework outside of dma-buf to
get there, and figuring out how to solve the shared buffer accounting is
indeed one of them, but was so far considered kind the thing to do last
last time we discussed.

What I get from that discussion is that we now consider it a
prerequisite, and given how that topic has been advancing so far, one
that would take a couple of years at best to materialize into something
useful and upstream.

Thus, it blocks all the work around it for years.

Would you be open to merging patches that work on it but only enabled
through a kernel parameter for example (and possibly taint the kernel?)?
That would allow to work towards that goal while not being blocked by
the shared buffer accounting, and not affecting the general case either.

Maxime

--4cy66ljvjeto773l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaUUmogAKCRAnX84Zoj2+
docaAX97oRKC47EmRfraR77g2nPKkhNGbslMpV97iGWZDw9W7qVFZSWxAm3ZOecR
fdkqIH0BgJFWYMfMj1oLwlijaHOD41ueRI3Yd6gM9FpeT9i1TBtqRQpdmR+3tIkc
JQn/bUAXkA==
=H3ZY
-----END PGP SIGNATURE-----

--4cy66ljvjeto773l--


