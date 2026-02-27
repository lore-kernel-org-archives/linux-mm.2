Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C3E4104891E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924186B00BA; Fri, 27 Feb 2026 17:23:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7386B00BE; Fri, 27 Feb 2026 17:23:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751736B00C0; Fri, 27 Feb 2026 17:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDF96B00BA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:23:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D8891A086C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:23:45 +0000 (UTC)
X-FDA: 84491664810.16.9AF09FC
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf25.hostedemail.com (Postfix) with ESMTP id CEEAAA000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:23:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=ibyQ9xq8;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h eYMklf";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf25.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.139 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772231023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gDryY4zQRH428jXcjjSGP/R/ZBS8LlxLYxDdPgkkiE=;
	b=m60RPcpkd9ECh5nSenIQjaSw2XNGVQuUiKcDTAklHhtKiVSyAKHNIYpaHXHIpc3xM5Tb9B
	g52hHD1jpH0XoF9lYT9B+FsvWx/Z3yEsnsKceqsR+0XFXlC2YoNAZcpyWp/JPVo439+zVk
	rMzh5M2D+qaQDgJ8LPR74Crms0diHsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772231023; a=rsa-sha256;
	cv=none;
	b=8VzIxKMCaanUcr8oyKoAOiEth5dX+um29xVAuL6K8QhmiE+6TxlKiZNxgVQHiUxagoF2uC
	LkcPZZtZAIZn5h304cyoI8c7cxQoOAdUDRYNHlLWA1KM315SPBp4dxQ+VtfcYC6QVUHmfw
	vGUYlmNCH8m9tlNa1tpJBWH4tYXRz0o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=ibyQ9xq8;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h eYMklf";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf25.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.139 as permitted sender) smtp.mailfrom=alex@shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id 617581300E4D;
	Fri, 27 Feb 2026 17:23:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 27 Feb 2026 17:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772231020;
	 x=1772238220; bh=5gDryY4zQRH428jXcjjSGP/R/ZBS8LlxLYxDdPgkkiE=; b=
	ibyQ9xq81ZUFDtngjlebvG4FaCgNpNNbQr1R+mWKzerZDqZJKaMwf0HBblpSPQ91
	VFdvsMyKGU5Tg9sMFl/57BZro8wkMOPw1LWE3jqikOFmHEQcnmlkJjpTO3zUAXow
	XOqfcAa0iIMoieG9RdcB8yL8non1RpY3YX3cBZWsNRzgZoVDHcW4WvsrdYMvRR4O
	kXG9r5jcj3nRPeI3wIZjCqx9pYJ+ovtiJyFyz/zG1Tnpx+Wt4tq5H6UYxb5/xjlk
	lkG0YgCvfdWXxZfC5tYJ4+h6oCW1XZQUWE5ZXPBMY4qfpryKhrz4mlFKl0CtABZh
	ozaeXUkPc0VOpKeMVm0KzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772231020; x=
	1772238220; bh=5gDryY4zQRH428jXcjjSGP/R/ZBS8LlxLYxDdPgkkiE=; b=h
	eYMklfxrT1hKh6s89IGlVCYgodJjyXuEtJzsN6GWawwrgE3RWvsVXiKD+nITWgWN
	uNh/M4JytKcYo90WUBaxX6+sbp0D1FJQarxN9Bl5nKn6toxi0MxhIWTI6N3FuwqC
	O38dHRyoBq/f0uv0cZ0cpvnBSDck1XGNuRuaccj7YkBP9n+efQLf7Dwy5Hdi+GHk
	8YOK86rNlDdXf8PkgONcfllG3kXVA5sq8Bm5XES78tNMaptniFche5ptLjl7/U+u
	AoG867Fox04IbnG/hATygTqTDaZqoKyJxDxYxhOyZQugp7Mthn77Ts4A+ePYYqlV
	Z++xJLYSuIBgqTjIBJbjg==
X-ME-Sender: <xms:ZhmiaTqQpfHE1fOXkXhzKjbpYL9Yr0pf-ceFjB6YPvRSGWBU1Ok5Eg>
    <xme:ZhmiaWpKATxZf0QUyqaYcd-5hQ6sPzPCE5RK_NWP5U50Ly0JADS68CrX2pDqRubi0
    NRsKG0qW5uMqo9Qv9rFyGUBShb1aqFQUKn-lJVJvFbN5ytXZJ2VBg>
X-ME-Received: <xmr:ZhmiaZ7-_PGS79ULJoNU-MK8CiMWbivAY9WumbCm0ZFBs9Fvq0YS9WcGEe8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvhedtudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetuefgleefhfdvueegffdtffevhfffgfffiedutdetgffhheejtdekfeek
    ieehgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeegiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepug
    hmrghtlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopehhvghlghgrrghssehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegrjhgrhigrtghhrghnughrrgesnhhvihguih
    grrdgtohhmpdhrtghpthhtohepghhrrghfsegrmhgriihonhdrtghomhdprhgtphhtthho
    pegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhopegrphhophhplhgvsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:Zhmiad2sbjfkxksva4ZZqUdWmMjzHkXGC5X8v-2AP5oEUrr0XTMl1A>
    <xmx:ZhmiaVlE8cxGOSiEybB2C9Afiqd60myTjWnbPqKtENleQaquZovVjA>
    <xmx:ZhmiaWieRutAuXs_kAh6v5Y6dFLmaFCfa8MUC0xje_WFkspzBxewcA>
    <xmx:Zhmiac30mxy-wDrums-gZ6YprIYdP06ito0nnSpm_CQ9sTCgWFmiig>
    <xmx:bBmiacvgXgNhRla-HV46CCK5l8R8PlNCFfSmuJ_LXC__y0uuR4tYHQ8Z>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 17:23:31 -0500 (EST)
Date: Fri, 27 Feb 2026 15:23:30 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?B?TWlj?= =?UTF-8?B?aGHFgg==?= Winiarski
 <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260227152330.1b2b0ebb@shazbot.org>
In-Reply-To: <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
References: <20260129212510.967611-3-dmatlack@google.com>
	<20260225224651.GA3711085@bhelgaas>
	<aZ-TrC8P0tLYhxXO@google.com>
	<20260227093233.45891424@shazbot.org>
	<CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
	<20260227112501.465e2a86@shazbot.org>
	<CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEEAAA000F
X-Stat-Signature: mgb9jc1tuo3waac6z5dnrusoch8aw791
X-Rspam-User: 
X-HE-Tag: 1772231022-382146
X-HE-Meta: U2FsdGVkX1+k2sfN8HoRO+LlpSRFGRLMNoqItFvIftVSUyKrmAcmDb2CGCC9yReDxD79hmTyM+mkgeDwJJ1Z3E1fslXKDmsRe6tute6xCxChoJezccXJsIdVyJ7j7p7ogM71hwcEAql1/AOGDNeDgvOywQQr9ENEEwYQljqs/N+YqTWrUB4QKZfWFlrcykInKvIBhwmBgz2uFB6PkbDf6YD6D0Uq9NY0ClMxhggWYwLTVKrA427aSQxsPhnx0Br29W1SdUM5QPQ5FydOcJvJ9Mu2CdEXh2UWiyzRgxxwWHPbyQNbSpnUF7jIY5DkSbCor2wKzXXh11z6kJ9jYatHHkR4LYhbRe9Tld29E9TJuYiZOwuDoq+2R/tnlSwQzp2mOjvWGNZe6YfNFCQarYjQWlG7chXEjzGu5QKfAsbhosgFdn2CTrJWTmnfHVZX8bjaNZ7O67apxe68Zf786nD1F5HVGCXJwNyj4pnod2Gq996YxUIjUg3h1gnRLiOwplS9zHEToA/BNM6dul1VB19VwHUNqPAzviFMr40aBhoBu8tWPqdITNHizrwSuTLlaAuSV7JIibh/S77PF6H9o5zW82MvDcxanwx5bmgJsAk+lTm0k7hKFsJgZ7DIWUGKKYwmHvRHl69d/j2fi60Af3CzKfETiqGo5wqRzqXBjDBIxFNdEHfKVQNOXEvNc6H3LjivjVYNPSHQnbbcI/D7L+B9v1vIxa5XW2A/crqpi/iOa5sy9stDpNNvAYOMJ+SKAl5MZ7rWscJZ7adlN/ZezNb43yv0JKWwvjDe98aAoqWgCizDJTsT9xULzlMiI/uWQkFRawUeKaBZe1b1PQ2lQ+0/OPNZb658mWAjopeyhfJyjWXFdq8dR/imXTJYoaxePvSjCr8nkwejAAZGmAnBgg4nMVpZWnvFqALHUYYtusV0QwaceFi7uml6jZaS9rBjSk03MXXxiNv+uqR8gN34ZCf
 eXx85r3H
 gCsqjHHojpJj7MAjUS6rAappehZOZlPE8KlfAlGOdqoe8t32UnQyVsprSZcEXCU0P5K8EApy7daLGmPrX14Y7eo4L0bDMwO5BOIillG8lmWPPMj9RK+jBxh6o0PxGMVSJvS8TgNhunpUarT3mkXOVLOAKgKJpzSw+0E2SmI8y/AKFcUEpg4Rw+kCY6H9BHq0/i0qbB5EPclRNxuNwIuyawk4K5HQaKT6UT6urq9bP3+okvqduk5U3nB2IjUhCCuid1T3yK0h2VywqPkoVFPcx+tvFxySUcNqMLkD/Eso77XBVPiAEU0JUAJFNZpYlS6rkh+AP+bt2r1Kj22aOGGuXV3V1f1+xeFZ8Croj2BxFOWx6Ytky73flQr7cyEwHY9mms0QjLrFSPpyDG+cO9FtlyueZ8wMteoGOprYS4zlZq9wiqDlQldorsWNAdv+DhSdZj+ka3dUygwfhNLttaM0jOHZoXnujzgne0YZ44mpZz7k3XwmEZQF0WhmwsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 14:19:45 -0800
David Matlack <dmatlack@google.com> wrote:

> On Fri, Feb 27, 2026 at 10:25=E2=80=AFAM Alex Williamson <alex@shazbot.or=
g> wrote:
> >
> > On Fri, 27 Feb 2026 09:19:28 -0800
> > David Matlack <dmatlack@google.com> wrote:
> > =20
> > > On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot=
.org> wrote: =20
> > > >
> > > > On Thu, 26 Feb 2026 00:28:28 +0000
> > > > David Matlack <dmatlack@google.com> wrote: =20
> > > > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *a=
rgs)
> > > > > > > +{
> > > > > > > + struct pci_dev *dev =3D NULL;
> > > > > > > + int max_nr_devices =3D 0;
> > > > > > > + struct pci_ser *ser;
> > > > > > > + unsigned long size;
> > > > > > > +
> > > > > > > + for_each_pci_dev(dev)
> > > > > > > +         max_nr_devices++; =20
> > > > > >
> > > > > > How is this protected against hotplug? =20
> > > > >
> > > > > Pranjal raised this as well. Here was my reply:
> > > > >
> > > > > .  Yes, it's possible to run out space to preserve devices if dev=
ices are
> > > > > .  hot-plugged and then preserved. But I think it's better to def=
er
> > > > > .  handling such a use-case exists (unless you see an obvious sim=
ple
> > > > > .  solution). So far I am not seeing preserving hot-plugged devic=
es
> > > > > .  across Live Update as a high priority use-case to support.
> > > > >
> > > > > I am going to add a comment here in the next revision to clarify =
that.
> > > > > I will also add a comment clarifying why this code doesn't bother=
 to
> > > > > account for VFs created after this call (preserving VFs are expli=
citly
> > > > > disallowed to be preserved in this patch since they require addit=
ional
> > > > > support). =20
> > > >
> > > > TBH, without SR-IOV support and some examples of in-kernel PF
> > > > preservation in support of vfio-pci VFs, it seems like this only
> > > > supports a very niche use case. =20
> > >
> > > The intent is to start by supporting a simple use-case and expand to
> > > more complex scenarios over time, including preserving VFs. Full GPU
> > > passthrough is common at cloud providers so even non-VF preservation
> > > support is valuable.
> > > =20
> > > > I expect the majority of vfio-pci
> > > > devices are VFs and I don't think we want to present a solution whe=
re
> > > > the requirement is to move the PF driver to userspace. =20
> > >
> > > JasonG recommended the upstream support for VF preservation be limited
> > > to cases where the PF is also bound to VFIO:
> > >
> > >   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
> > >
> > > Within Google we have a way to support in-kernel PF drivers but we are
> > > trying to focus on simpler use-cases first upstream.
> > > =20
> > > > It's not clear,
> > > > for example, how we can have vfio-pci variant drivers relying on
> > > > in-kernel channels to PF drivers to support migration in this model=
. =20
> > >
> > > Agree this still needs to be fleshed out and designed. I think the
> > > roadmap will be something like:
> > >
> > >  1. Get non-VF preservation working end-to-end (device fully preserved
> > > and doing DMA continuously during Live Update).
> > >  2. Extend to support VF preservation where the PF is also bound to v=
fio-pci.
> > >  3. (Maybe) Extend to support in-kernel PF drivers.
> > >
> > > This series is the first step of #1. I have line of sight to how #2
> > > could work since it's all VFIO. =20
> >
> > Without 3, does this become a mainstream feature? =20
>=20
> I do think there will be enough demand for (3) that it will be worth
> doing. But I also think ordering the steps this way makes sense from
> an iterative development point of view.
>=20
> > There's obviously a knee jerk reaction that moving PF drivers into
> > userspace is a means to circumvent the GPL that was evident at LPC,
> > even if the real reason is "in-kernel is hard".
> >
> > Related to that, there's also not much difference between a userspace
> > driver and an out-of-tree driver when it comes to adding in-kernel code
> > for their specific support requirements.  Therefore, unless migration is
> > entirely accomplished via a shared dmabuf between PF and VF,
> > orchestrated through userspace, I'm not sure how we get to migration,
> > making KHO vs migration a binary choice.  I have trouble seeing how
> > that's a viable intermediate step.  Thanks, =20
>=20
> What do you mean by "migration" in this context?

Live migration support, it's the primary use case currently where we
have vfio-pci variant drivers on VFs communicating with in-kernel PF
drivers.  Thanks,

Alex

