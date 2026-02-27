Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A543FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 18:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED0E6B00B4; Fri, 27 Feb 2026 13:25:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4E56B00B6; Fri, 27 Feb 2026 13:25:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2996D6B00B7; Fri, 27 Feb 2026 13:25:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 183C06B00B4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:25:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A629F1B8173
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:25:13 +0000 (UTC)
X-FDA: 84491063706.12.2ED0E27
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf16.hostedemail.com (Postfix) with ESMTP id 895D718000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:25:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=M5HcbGYu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G qh9tuz";
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.138 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772216711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2MIetHNFq+qTvq+cXYYK0YgcuU2lcFpP3MOKL3SGt4=;
	b=NK4X37EURkj0JWBRmj4iKvBJzayDU1rxILAH9XAjroYGh+BH+PcJ0HUDuuwYKJA9hf7GZo
	3tD9R4tx3ldnBEUfabgQax7W4cS24svrBL0NuET/lNi16nKaMQC9DnjnGFSVM6WWDRgzRh
	4T0Wu731pxB5WeSzsvwzh5xMidJoc5g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=M5HcbGYu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G qh9tuz";
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.138 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772216711; a=rsa-sha256;
	cv=none;
	b=sXxivuDTYdlioZuNWThbjfu+LYNm/t9rKqNFstzfTDWDp3X5uN4EF6Hbj+dSljRAxH1Cqk
	GAQTOp7duGcr599nJkQbsQ6A1qGRxfy5LRfEPkgfx/DL/kpMGo3qNCrtBQesXYSUanAd3x
	SC7J7yn9mG9Ukp3BT9inWBQhNpZlSrs=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id E683C13014A3;
	Fri, 27 Feb 2026 13:25:08 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 13:25:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772216708;
	 x=1772223908; bh=h2MIetHNFq+qTvq+cXYYK0YgcuU2lcFpP3MOKL3SGt4=; b=
	M5HcbGYuV2I6ExGXjWjOd4SeeCigxt2cqKKirjhfZh06/QH5jWk5Z0JXXsThF4Fa
	7RNYoPp8Q5eAqiRc4MvFU9TfVLtKQF2soXn5Oi+wy5mVV02Y9V6al1nzNE0dM4Kf
	WM/D1Xyoo09YEP+zJELM7kvTK/Ul5KUP+3qr1TPLZTPStNtbStFcdz+hWfflEMCR
	eQDCZ0Ft8O0kf3j2MmhqyBxK+mhdOncmKEF4Dp4ercNY5ApAahSRV2An/RJEd4i7
	BdyHODrQLIwkBu6mJDWJbQjY2nSQJaubJmCsA0WpqDsoj1gNpOHZWdqR9igUU03x
	BT+8ghQY6qxqc1r0rOqLpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772216708; x=
	1772223908; bh=h2MIetHNFq+qTvq+cXYYK0YgcuU2lcFpP3MOKL3SGt4=; b=G
	qh9tuzfCH3lGFGrRjjXpdIFarDbZ9CPj/YT4lwdF5h6EzJZsS7JvnCF0Ks8Fnt0K
	LLfTOS7cdqhASypxTn6RzcsJBbGS38oM2wwz7RMuVfeRK5coZnlcRuACt2MXtpC7
	oHxISpVXtMqtiuv/OOXKhaJEtt7KniH7T4QEfK6G5L7z1cX/ZSU5pv5LbVF42vgh
	Zas7Cla0p33GtwfHxAEvLwtGrQiXgWNPpsRDMpMBUt041aDFgywssveH5+UbFKfk
	+EdQzATJOuDsuK2NDYiJdTUMuhVhgtTwQOO6Zr5EeJ3shSuZkI0NQLDWzZr01fnv
	3H57jQf4QaTibPhvtFDqQ==
X-ME-Sender: <xms:g-GhafZtSzmZsd9mg_1JeAf4a7CBH5YscM2LP9OxDN6vYBmrOT2RjQ>
    <xme:g-GhacBgZvn3vllUUZAduJus40XYnJCARLd5Qn2lpnCZ3hm5LcKmaH3_ifCdg8nRc
    bhfW2epKwLgco9PQY9RMjvB-8ySVXhjHa2szTFK4d0BoXgBo_sTQA>
X-ME-Received: <xmr:g-GhaXh3-jN2zQNLkCxS_aGmExZJC3QTxFCBwgyNzGHK4F5uOcX9ANZcPzI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeeljedvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:g-GhaZTBdxISglkYbGFG0qQfvpfCG4WwcCrRmOzReyBOsLRaTibMXA>
    <xmx:g-GhaZuzpGX7ZWhZ_xeqPZZfg5xHy96idHFhKwVKbQXv6_voPSqgXg>
    <xmx:g-GhaT_XKP-XkGzZ4qGYqUFyPdICEwLE_1eo3ZKj2dbSLvmaUQ6GRw>
    <xmx:g-GhaVbO8hrlbCn4XT7ZfiNIekMI1_uwVcu6rbUJGDu-1KeSuemYKg>
    <xmx:hOGhaZd0C4q89F5ZU_31WMqce-tyc-ZrNJ3uFW7ijN5Nq5kVoD4bQVYy>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 13:25:03 -0500 (EST)
Date: Fri, 27 Feb 2026 11:25:01 -0700
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
Message-ID: <20260227112501.465e2a86@shazbot.org>
In-Reply-To: <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
References: <20260129212510.967611-3-dmatlack@google.com>
	<20260225224651.GA3711085@bhelgaas>
	<aZ-TrC8P0tLYhxXO@google.com>
	<20260227093233.45891424@shazbot.org>
	<CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 895D718000D
X-Rspamd-Server: rspam08
X-Stat-Signature: xmskqmwgr6qhwhr3m5xsbqaax7cts1ey
X-HE-Tag: 1772216711-596795
X-HE-Meta: U2FsdGVkX1/Ob8i027W9d6pg/Nkx3Cb2Mrf+L5sUgbS+DWS2cLLMpk6slvzPz+iVj+LcohM3BdepGiT6u6FJ+zxQy+S9e85VDOqmIRpcuW38W/zyOo30nCnhvluSXTgwYG087F8KkuExm2uvyjXE3ucmx1ozjOsBhfP8y5ALUISQLomGJVDATz3RFmm9WB20B81CEbCovP372yU0PfyV01RpOHI6ioaQobhkeNGKcJ57Df40wdtuQdwC2Ulmr9xjXpdiL++sHQvAMunyNvtR/2+a6zQ1Cmu/PdVR5qi/jS9Y3uJW17ASwpFAcWRcKK4iQZv4I2BsldBce+xcr6UNyJahY6IvMhrjvRIIGnkDa/En4CJdnNo7gjwScVq8E7fbpFdWlvmYtUfNmZyUAL9V5qMajpilfsIcFsCter9pxPt7DVtT0UZfg6EEnoeo9CLteu5fMHjHUX9ySD6T1VemabZBDo4JSsdY53nmZGyVIgVSAJ86vlcpyT98+0/88Ghe2u2VbydHFqFqidkM74et4y7dzrsjpNfL27nG574+d/1MoDgw7Y++qhXL/XXvBP/7AacIYMQtM+O6RqYoKHvffg9oZq7WrtMZ1EbYJTxpHL5kol1R7FmHKGcHtTauuGucK84RhOTtM6EqyOsCMn9wjOoKrJ3AQFqH5OnzmlEeQIuFDz/NNTPWo2d04JQPIEnnLMo4WhS4/jjnoSqb7WwDcSWvOqmyfD9uk4YyyvT1smkNTRAxYNTlHO0iuE1inmPw5Ez9uVX9GCbR99NfFWCD9R9AmvA4kaypYz9TFpo9hIpCw2vz1enRAAAGDlZ29oXQhh1kUV3rp/3i1R/QWTx2yrZyje6oWApBPc1jauOANPG+vnWq3/aedjT5x/PqHVt1dyrqsb5Zy0OhfdwoPS7h66HV/2mVxZ8A6EHkCsPUucF+x8FH6Uf9xOKu/rTgGqjpkmz9Ep92VVGBkyYEYhA
 YpWMYu3V
 6IKMOwne1fCNRwzsDzUqLiY55CgWPN5VYEFKq6N5DbisxsnCP7tXEveE9gbsP4QScJSTDIFdwlbq9wcoMsWxuiVu3ksKY8s39kX2unwG4qzuWPJFVGkF12wIUeeAT4shOtqB4+UbFBBUILAAZFVsQwSvg1uJqfHoWWhYpsfhFP4ZsEWwG9DqWmHcEJOSYbWHUam+KvazFPGvYA/ebBIzpiTGBVaFxIJW2dxlgY3yVhIKE3AGiFA6BpMeS7UVUZ+v4KR5nw7LnW31hY3anLoi2PojGSfpA8LszQE47P7uxjGxIGt93hQrIw1jGcN5crmOKK4VeAVjqUQpcEeZcuqEolribMnkJdluqed/nlE3jjQJwwEKEeWw/hiYGMOc6TnB+i1k7mf/VhaRJVgdQ+ypylNjvaVjEP0ntukmVNvYAvUBocF6L3WbjbLLmArNgwxpvkbJwnZjGDudpOypQsm15i7Jld7TSE+awuMfsjPC174P0OS0beucFy4UFKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 09:19:28 -0800
David Matlack <dmatlack@google.com> wrote:

> On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot.org=
> wrote:
> >
> > On Thu, 26 Feb 2026 00:28:28 +0000
> > David Matlack <dmatlack@google.com> wrote: =20
> > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > > > +{
> > > > > + struct pci_dev *dev =3D NULL;
> > > > > + int max_nr_devices =3D 0;
> > > > > + struct pci_ser *ser;
> > > > > + unsigned long size;
> > > > > +
> > > > > + for_each_pci_dev(dev)
> > > > > +         max_nr_devices++; =20
> > > >
> > > > How is this protected against hotplug? =20
> > >
> > > Pranjal raised this as well. Here was my reply:
> > >
> > > .  Yes, it's possible to run out space to preserve devices if devices=
 are
> > > .  hot-plugged and then preserved. But I think it's better to defer
> > > .  handling such a use-case exists (unless you see an obvious simple
> > > .  solution). So far I am not seeing preserving hot-plugged devices
> > > .  across Live Update as a high priority use-case to support.
> > >
> > > I am going to add a comment here in the next revision to clarify that.
> > > I will also add a comment clarifying why this code doesn't bother to
> > > account for VFs created after this call (preserving VFs are explicitly
> > > disallowed to be preserved in this patch since they require additional
> > > support). =20
> >
> > TBH, without SR-IOV support and some examples of in-kernel PF
> > preservation in support of vfio-pci VFs, it seems like this only
> > supports a very niche use case. =20
>=20
> The intent is to start by supporting a simple use-case and expand to
> more complex scenarios over time, including preserving VFs. Full GPU
> passthrough is common at cloud providers so even non-VF preservation
> support is valuable.
>=20
> > I expect the majority of vfio-pci
> > devices are VFs and I don't think we want to present a solution where
> > the requirement is to move the PF driver to userspace. =20
>=20
> JasonG recommended the upstream support for VF preservation be limited
> to cases where the PF is also bound to VFIO:
>=20
>   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
>=20
> Within Google we have a way to support in-kernel PF drivers but we are
> trying to focus on simpler use-cases first upstream.
>=20
> > It's not clear,
> > for example, how we can have vfio-pci variant drivers relying on
> > in-kernel channels to PF drivers to support migration in this model. =20
>=20
> Agree this still needs to be fleshed out and designed. I think the
> roadmap will be something like:
>=20
>  1. Get non-VF preservation working end-to-end (device fully preserved
> and doing DMA continuously during Live Update).
>  2. Extend to support VF preservation where the PF is also bound to vfio-=
pci.
>  3. (Maybe) Extend to support in-kernel PF drivers.
>=20
> This series is the first step of #1. I have line of sight to how #2
> could work since it's all VFIO.

Without 3, does this become a mainstream feature?

There's obviously a knee jerk reaction that moving PF drivers into
userspace is a means to circumvent the GPL that was evident at LPC,
even if the real reason is "in-kernel is hard".

Related to that, there's also not much difference between a userspace
driver and an out-of-tree driver when it comes to adding in-kernel code
for their specific support requirements.  Therefore, unless migration is
entirely accomplished via a shared dmabuf between PF and VF,
orchestrated through userspace, I'm not sure how we get to migration,
making KHO vs migration a binary choice.  I have trouble seeing how
that's a viable intermediate step.  Thanks,

Alex

