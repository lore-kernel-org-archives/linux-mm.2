Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F76CCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102566B008A; Tue, 19 May 2026 12:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA436B008C; Tue, 19 May 2026 12:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017506B0092; Tue, 19 May 2026 12:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E58B76B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:32:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 734B01206DC
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:32:11 +0000 (UTC)
X-FDA: 84784711662.10.1286128
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA65140017
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:32:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qs10YNzG;
	spf=pass (imf07.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779208329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzpovHMoKEOZz3NZw5bD7XsjuYX6EnzOkbjbXVaRR6E=;
	b=y2wdy3qIpFVoe7cAfullpg5JE0KVogY/hu2Deeu/IU2CFrpb6KphrAjrO+4RfzB/UeM52/
	NE09XbWhgWrMTNvGFFCGgge+4guDDMlxRJRs5Ep2XdjzqvQ/R8s3hH5BMteU1LyV5ffRGm
	GSgDs5g0OHRYWquEdd59Bx8oXdiML6w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qs10YNzG;
	spf=pass (imf07.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779208329; a=rsa-sha256;
	cv=none;
	b=79JCg+cDPzvXEuMSKZu7ARPMJjF2yZHssYqYBG4GU40ZDqpg5omgIfQlAICjQ8vv0iUgQn
	iQuglfM132Xo0zeJUFYwTgXNyy6TEw4nXXykj9CuTHOKjvZOT06l3f3pMxGrs563lzHZcH
	uGE8FC7qh0ezgyIFXposOeWSidtq1CE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F0F2409B5;
	Tue, 19 May 2026 16:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FF4C2BCB3;
	Tue, 19 May 2026 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779208328;
	bh=SzpovHMoKEOZz3NZw5bD7XsjuYX6EnzOkbjbXVaRR6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qs10YNzGekgmtvHxgReV7P65tiMHHCYBYIjL502DOF/37vXQZXib42brdzZbD1BpW
	 apttq7P/8t6ZJA5lh1XjKteQRKGy4IUleOftZiOcSJsul4W7AKVx3Ez6YGa8R6OZB6
	 CwAt12wi/8Lw6DlCo2ZSjnidYwVR01dnhiDj2cTIMr5ZPTxXTEbbfXSw+aTnzpEZe2
	 dItkNurzD1Uu3US5tLWBeZGSHywlXtbBITQXETM353dDe9pdSg6bBaIdcVy6uqixof
	 W/luHicp+KZcBO1+K9htM0KBLl83yP0yCtyjGiv1wasSx7UUKxcdI2k7orYuuNWSJj
	 4AogqySbyMoSQ==
Date: Tue, 19 May 2026 18:32:04 +0200
From: Maxime Ripard <mripard@kernel.org>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Albert Esteve <aesteve@redhat.com>, Barry Song <baohua@kernel.org>, 
	"T.J. Mercier" <tjmercier@google.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri- <devel@lists.freedesktop.org>, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, echanude@redhat.com
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
Message-ID: <20260519-graceful-hypnotic-penguin-0be97e@penduick>
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
 <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
 <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com>
 <CADSE00Lc42s2bzXzV5D7t1Enf56u4BVj-yXLp3Yxhm0=qMPvuw@mail.gmail.com>
 <9cc79977-9a42-40eb-bfa7-460881c1e10f@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="ran3hospswhrt5o6"
Content-Disposition: inline
In-Reply-To: <9cc79977-9a42-40eb-bfa7-460881c1e10f@amd.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA65140017
X-Rspam-User: 
X-Stat-Signature: kjjyru64r1pg1gg3o7yaeb8wjqbqxsp9
X-HE-Tag: 1779208329-680943
X-HE-Meta: U2FsdGVkX1/71fjBXDWtHkO0hFMMUNUbqYJ5RbS7vQoAl5vd4eVKca/6N40T6FxB/9YoAl4/A+6mNN2JeNxOdFHO2Wi8zG5qHhN5KCMMzbLdrJbsPxXoAKlQW+87obNJ0wT0W9C3xd5yLN+lFMCYxTcsSjAaTNIHrrUka0l3JCSUnG3RVORpD148wM47Ydf3enstjskaNKzKDYJxqBGLE/f+cq543tJ+bMU/+pvgWEcZDpEpJIqm0+3bC4RnxtjQybYAIXHfaEA5qgqBbwtXoVPeYq367x1uXUgKYUwimk4DFaDQkZI6Tcux1cXRGUnemZ+xGoYdd/j9ZQz++C2mqCgt2gV9aF6z1JGLg6qzPQq5VsPU1MY5PX7Wof9NgVuo/WdMcDRxegHqhRJbFx0ZPN0+JzK+eh1Hq1qGh0AkvVxXx7Q6et0RCM6RlNsPqCzi8QomonFNgj7GYDWrlDJL+6NG2RWN85edJ3hEs2FShGoKiWA+QV/4JoIenLeLd79mFy9ZJPD6zDnZ5bvs/9ynlSYh89/vC4OLBn3Luowe7mLEvgOCtW+g8ifbLQjPPAS385euufOaj5vuo4JcC+Cb5DR77TMw3tm2A4ak9pm3xpAFzigo7S66JMNFv7O9c/nyLljij/hXBYKIX8PrldOyKcf2bsv0QLTiCjkbqGnxpJiReyGmivBJHp03IEXtR3WAQ2v/QxfmPrqMROICmb92oeBjBSFlHoIMIFoWwC6EsprO+vCkgHWAkSs5HptbeL/kGCNau0cH0dQGnGEg+HjrkJKbvjwfxhq7uqbENcVmf/YB/P4LIwMob6ANIzjRPnzQeC9rJWZ4OZK+Kjm20vR8FYbobH2YuryqSzU9BmVIvUD756XZgvADrB2/19JdtcH8Ncx4aYfeS2xnY9Dd5zswswJR9821rG/VaWEqR3SaUXH29vGednU/VqU5KX7SnP4Yvuz/WbJ7gdR5//7k0i8
 5FWdOT2K
 Ia91kMcaqny2g+lbKdTqy9yKJgsRVdBFz2dTYnbiue1xrooPI3g9xw/H+GPLhWJtD3YAFNU0diH+dQw5Q8ltskPJaYokBAVMjcbVvgBZCz2vv5vVzCvHUxVL1R238mFXUpgrqecBLB4MwP0i4ppnD0Gova6+6TlPKU3x7Xkn3hvpsh1cXrDpDUhcmP+EAjyhSbKtrYcu1Duf48jnYbnzoJymOJxxNTMNiW9ZbyUE2RiuDsCDOB4jZ4SUbl/wWw4sX7M5EfhghoWU84PHA5FQm6VEI1HoHxYr5Z49vsy9E974DH7cIw31DCwjI5zZsDT23u+sNWkXCvJWjf9sDpLhUkJcH6vNpU3zyAm5CEhBIH8o8ZyAbZchLFQXNwTR8e09Dpr4YRm8yTsPFhFYOaS8MneXJqk2Nnog3mlPfAcRnMU1abrZq+H4dgxD6fscE4s3yOVVwrfLh/qFKJ1BGvjPRTqluTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ran3hospswhrt5o6
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
MIME-Version: 1.0

Hi Chritian,

On Tue, May 19, 2026 at 09:53:19AM +0200, Christian K=F6nig wrote:
> On 5/18/26 14:06, Albert Esteve wrote:
> >>>>> udmabufs are already
> >>>>> memcg-charged, so adding a separate MEMCG_DMABUF would double count.
> >>>>> Are there any other exporters you had in mind that would benefit fr=
om
> >>>>> this approach?
> >>
> >> Well apart from DMA-buf memfd_create() is one of the things which as b=
roken our neck in the past a couple of times.
> >>
> >> But thinking more about it what if instead of making this DMA-buf heap=
s specific what if we have a general cgroups function which allows to chang=
e accounting of a buffer referenced by a file descriptor to a different pro=
cess?
> >>
> >> That would cover not only the DMA-buf heaps use case, but also all oth=
er DMA-buf with dmem and whatever we come up in the future as well.
> >=20
> > I removed a draft adding an ioctl for charge transfer from the series
> > before sending because I wanted to focus on the charge_pid_fd approach
> > and keep things simple, deferring the recharge path to a follow-up
> > depending on feedback.
> >=20
> > The main difference between my removed draft and what you're
> > describing, iiuc, is scope and layer: my draft was an explicit ioctl
> > on the dma-buf fd that the consumer calls to claim the charge (see
> > below), while you seem to be suggesting a more general kernel-internal
> > function that could work across buffer types and cgroup controllers,
> > so not necessarily userspace-initiated? A kernel-internal function
> > will need a way to identify the target process, which sounds similar
> > to the binder-backed approach from TJ [1]. For everything else, the
> > receiver still needs to declare itself, which the ioctl accomplishes.
> >=20
> > ```
> > # When an app imports a daemon-allocated buffer, it can transfer the
> > charge to itself:
> > int buf_fd =3D receive_dmabuf_from_daemon();
> > ioctl(buf_fd, DMA_BUF_IOCTL_XFER_CHARGE); /* charge now attributed to
> > apps's cgroup */
>=20
> Well that thinking goes into the right direction, but the requirements ar=
e still not completely
> covered as far as I can see.
>=20
> Let me explain below a bit more.
>=20
> >=20
> > [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@g=
oogle.com/
> >=20
> >>
> >> The only drawback I can see is that DMA-buf heap allocations would be =
temporarily accounted to the memory allocation daemon, but I don't think th=
at this would be a problem.
> >=20
> > The main reasons we moved away from TJ's transfer-based approach
> > toward `charge_pid_fd` are: avoid the transient charge window on the
> > daemon's cgroup; and to decouple from Binder, allowing any allocator
> > to use it.
>=20
> Yeah those concerns are completely correct.
>=20
> The application should not volunteering says 'Charge that buffer to
> me.', but rather that the daemon says force charge that buffer to this
> application and tell me when the application is over its limit.

I would agree, but with a caveat: how do we want to deal with malicious
applications here? The application should have expressed that it's okay
for it to be charged by a different process, otherwise it becomes
trivial for a malicious app to create arbitrary charges against another
application in the system and DoS it.

But then, that means that an application could arbitrarily charge the
daemon as well if it doesn't opt-in but asks for allocations.

So maybe we should have an opt-in for the caller, and a way for the
daemon to check if the caller has indeed opted in before performing the
allocation (and the charge transfer)?

> > Technically, both approaches could coexist, though. Of the three
> > scenarios TJ described:
> > - Scenario 2 is directly addressed by charge_pid_fd approach without
> > any transient charge on the daemon at the cost of one extra field in
> > the heap ioctl uAPI struct.
>=20
> Yeah extending the uAPI to pass in the pid on allocation time is not
> much of a problem, but you also need to modify the whole stack above
> it and that is a bit more trickier.
>=20
> > - Scenario 3 can be handled by the charge transfer function without
> > changes to SurfaceFlinger. The app or dequeueBuffer claims the charge
> > for itself or the app, respectively (depending on whether we include a
> > pid_fd field in the transfer ioctl). It also covers non-heap
> > exporters. The con in both variants is the transient charge window on
> > the daemon.
>=20
> It should be trivial for the deamon to charge the buffer to an
> application before handing it out.
>=20
> > Both approaches shift the responsibility for correct charging
> > attribution to userspace: first, 'charge_pid_fd` on the allocator's
> > side, and the transfer charge on the consumer's side.
>=20
> Yeah that's why I said it would be better if we do that without any
> uAPI change, but with all the uAPI we have to transfer file
> descriptors (dup(), fork(), passing FDs over sockets etc...) it could
> be really tricky to implement that.
>=20
> > Deciding on one, the other or both depends on how much we value
> > avoiding transient attribution, and how much we need a non-heap
> > generic solution. With the XFER_CHARGE we can cover both. Thus, the
> > `charge_pid_fd` approach in this RFC can be seen as a
> > performance/strictness optimisation, eliminating transient charges to
> > the daemon at the cost of a permanent uAPI addition to the heap ioctl
> > struct, but not strictly required for correctness.
>=20
> Well all we need is a uAPI which says charge this buffer (file
> descriptor) to that cgroup (pidfd).
>=20
> With this at hand we should be able to handle all use cases at the
> same time.
>=20
> > On the other hand, if we agree on the end goal of migrating other
> > exporters to use dma-buf heaps
>=20
> That won't work. DMA-buf heaps is actually only a rather small and
> Anroid specific use case.

I don't think that's true anymore. heaps are used in lots of different
use cases now in the embedded space, including in regular, generic,
components not specifically used for embedded systems.

Maxime

--ran3hospswhrt5o6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCagyQfwAKCRAnX84Zoj2+
dtabAX9HzGm1Ns4iAysPJk3eSmxFA0qKTFqj4loXjy2WUfrHE3uAJd/mivZu/62z
8PDG3v4Bf0oF/N6HgEYqscS3K19cW4kROdi4s5J7LhNBraebPMHWMnpHJVUOF4SA
yFPMifkqJw==
=3qFV
-----END PGP SIGNATURE-----

--ran3hospswhrt5o6--

