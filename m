Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F813FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0116B00BF; Fri, 27 Feb 2026 12:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880AF6B00C1; Fri, 27 Feb 2026 12:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F806B00C2; Fri, 27 Feb 2026 12:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD406B00BF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06C4E8C281
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:32 +0000 (UTC)
X-FDA: 84490993944.26.06C0AC7
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5A241C000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=aat5WdRO;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W xqmtJc";
	spf=pass (imf21.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.138 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2yQm0oOGTcRJfhcrEhEmD0poePPSAOAfmgoK4/aZLQ=;
	b=mtDV+6gAsmZaYEn2JIoJRqw3J+mxLRmVGkzZ93XWu/kePljOTkoigaZsN3DqbA/87ZMJBP
	xn9F4sHJ4GqwGfrU3iQsiQL3xGxYNKrVAjLKRGClwJEdpMjhzDLt9Do4uWmUXJ7/pYCtb7
	GGq3RjhV4d9W/CLG+PuyyCtjBk/Hs5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215050; a=rsa-sha256;
	cv=none;
	b=GUhnWRndlP82whgjmVJsqpNQ1Vabm934x/VrWQkRiNFHeaJg5fIAPesL9KoPA4WfmQJSof
	FXP4H69QMT1QI8ba/gDxm4y5YG1zUxfsONQ0+7eYlMf4q3r+5i/Jb2BSOQrsMb/eRWQDlI
	ghOEEbITCXNx2NYdUoP6Ghas4tEilys=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=aat5WdRO;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W xqmtJc";
	spf=pass (imf21.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.138 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 3F62C1300E62;
	Fri, 27 Feb 2026 12:57:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 12:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772215047;
	 x=1772222247; bh=K2yQm0oOGTcRJfhcrEhEmD0poePPSAOAfmgoK4/aZLQ=; b=
	aat5WdROMFK4MIAhDBYWwdq0MIcDck8De3aplVKiAQDST6EhMB5PcW5tdYpMASS+
	Lwzt8PZ2t/Vks2Gz4X5ZD6pdN26+IdzlXQZqudjRIN25E+9WKMhgqSWnxhjoWCuU
	Vvy+OwWxDo/e5yr0fnLuFRHymkkXqvE8y6wWzNE3Ojj+EoITsFc3+feRRhqKx7uw
	QCtWIHCyzSB2nG8tHB3q5wtWzmKHRV3bhThUKDX8lSL5eLjDzt9Ltx1XWwPicyHc
	gBFcO+3nfj61Pc3XM1/KVRAyL71hj680c6ci4mtUugl5CjPxlzT1d41uQ+cB3Kjw
	/SxMAZO1OqzqUyUmadPSPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772215047; x=
	1772222247; bh=K2yQm0oOGTcRJfhcrEhEmD0poePPSAOAfmgoK4/aZLQ=; b=W
	xqmtJcO9/vYtHkLC8ry/T0H4riRZtlEP84tsZsbvOF7uyDV2DhRDT9EFxWz8XiZ3
	5YimAM/blxiy5DiQdzLbwfFBeoCdw5gLmTW9CVQOea7C3zb0AyB1sf1XS+wmfv3Q
	Ds3c8w7JL5YsaMfC5Al7JyE92WwHtRZLH8a0uMk94qa9MVsfoP6yhSuvimDw6m7/
	0Vz8KIDNfDn+zdyVaa/tMTWGIwc8UccFyxqFQglgrsg4CseIls3XRYZIDO4ePIei
	HCyVzy589uVArJ51VYsNvO/jUSHwDM0rW/z2eNUHdq2EX5myg0+WDdo9RdMlxi0o
	IsS6cWHKbOS2VNTCGTGUw==
X-ME-Sender: <xms:BtuhaeIZ2jS2UzpJd553k8XHA1Sp13wdZhBu7QQZtWIcByVOCp_UKg>
    <xme:BtuhaS8hJK-hkPnFru1C9zc1y9z6dwFIhx7qBKUOL3_IP1aZ0UeNjHLjD_ZPtaIJb
    Ap74DRRikSk2ywtNYvGEudDqP4xYKNin3E1E33BFNp5CKHwOsAWgQ>
X-ME-Received: <xmr:BtuhaS7gLyrUe-l3rxzVCz0cLdnzfbW-UmoTkvJBStG9ul5e7o1ztrntfSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:BtuhaRgx07S3OQW05vQUdMULcKyIxw-lTak2T16g5_r3LQCchEXMMw>
    <xmx:BtuhaZgs_wOwuGV3uCTzdlPxPYWSRXfna-r2yxAr8x8ogV-5YZqCiQ>
    <xmx:BtuhaX1nJjDQ-xPKXDYD3-xh--mPBEI78fmknqtRndSlh83yiY3kdg>
    <xmx:BtuhaUhbU6JSFEpTI_Y42gSPmoFE2aI-6lqMPTHvgr6MwH-vurp96w>
    <xmx:B9uhaXpqlDvWlnCcYlLipLPhEwUJg3Efvxe_E5IjWKRMOlvzQntJDuNL>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 12:57:22 -0500 (EST)
Date: Fri, 27 Feb 2026 10:57:20 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260227105720.522ca97f@shazbot.org>
In-Reply-To: <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
	<20260227084658.3767d801@shazbot.org>
	<CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iszdc9fjb6anmn5y4ut98n6mcne669qd
X-Rspam-User: 
X-Rspamd-Queue-Id: D5A241C000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772215049-898847
X-HE-Meta: U2FsdGVkX18KFc4RTQXTEG3PUqd5djAp4hDAinO+4WvlQnntr1eANzg401FbA6hAC34KC58/u5gGoCoKtq3zirzwTpqrtoRPFAA7d4J37/aQ/tfvBtu043KylQJ6pdbD0ikDhhm/H6//4FlSbQsr4/y6s9QJObxOUggSLXYShCCgunqBXTKxzUjvOrBvsJWZ6wirlir1cRQ9xWXhbGbmk/KpgQ0GXamHGvf+vDIyThx6DpaIgCIppHvEO/KXdwFJOjajtx11qCe2O7IzosRKzKY+r0m/xW2Lfujj+ZaGwfpDCrxvwF7k4V4Q23h+dyf6WGDPOuviXULWcNLh3k0Qmt/2KoEmPXxO8bW4NLBKurwNJ3XCA/cxpjub2tGMAL5rxwFAsb6VB0tYVYyNZirM0eVI+vmxavNWNd85lFZKVeJ/RZexiD+/2CrF5ScpMHKBOva7PsxizZyadg7dcXsPyYcVmb3/n0PXMFv/2eozlyCb4SlNHGp69lzXqnmHWe67nZr4+pzV95wiBh15PancaVZ52VwK0GyUTHEZr8AIa2S9R0HCkWMNfa21EHul+scRPBLQdvtTIM1x+XaU02lBKlkyEtkk6Pr773P9/40rR2cxCYk55ZB+kmHmJPEZLebU0c4vxODcvHeDURfQSa/zgGUdm32x8h1AgWOOWMrT9701XcZhvROJgDpEz9PQuAyOX6h44nO+wcXQQqMAIiZLm1UULqPny3AuiCzk1P0nDv7J/E0nmy1RH1eGOxhJangmvKXwpmpnZFlnipzI7IUclbP7tJFkWLzBFzQxBEZmj8jR4KCL72zI6yB+S7zg9uVQ3pjM8yrZ4eg0jehYFmM/Im9ogmbDVk/UAsVWefdqMxyyk9Jj/TQXmiXIbAhL4p7xKTjYGPljDN9zyrH1Cl+boMFVnaJXQTGW8ssq3pNm0HRwF0cPIOOfahvvRAy5fe8qu/fzNs8LbxucodL6qJ8
 PJHl1b0r
 Ju0GP9mO6Ka4U34w+p92hm4spx44MMJBkaA5F0BdMdoFI4m2mvHx3PmO7ODKmG2UU7+EzwEqxKf8q9vEhNjiQg01N4jO7dhLTH7yiNRPa7NUF4G8OrWowExvf1KeQ9tIFRMjKeGvL2QO261q9WE+5tiK9zoBHwxveKpu6VLQ9+PVkNTWQhg/JKqaMF+/62eLO9LJW4AAABS2cOn5mLIhot9gExtsEBJEaZVwVrY9Rmlxvug6lzuEGzow0Jr0yJMlQBrXrJuddeqUCK/CLZuUZtXmVItJqZPYk6ORU4DTbUfqbuz1aZ0q9hKO/kJ2WP7oe5hBkhaX5N/8Q/npL/30359G1ObhH2UekfUcGjUzImqlCbCxxuF7jACc3fC+LqvRQsrJBGzDI6eADfosVYJSBNz2H1dI/2yWWa4PR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 09:07:48 -0800
David Matlack <dmatlack@google.com> wrote:

> On Fri, Feb 27, 2026 at 7:47=E2=80=AFAM Alex Williamson <alex@shazbot.org=
> wrote:
> >
> > On Fri, 27 Feb 2026 00:51:18 +0000
> > David Matlack <dmatlack@google.com> wrote:
> > =20
> > > On 2026-02-26 05:00 PM, Alex Williamson wrote: =20
> > > > On Thu, 29 Jan 2026 21:24:57 +0000
> > > > David Matlack <dmatlack@google.com> wrote: =20
> > > > >
> > > > > - vdev->reset_works =3D !ret;
> > > > >   pci_save_state(pdev);
> > > > >   vdev->pci_saved_state =3D pci_store_saved_state(pdev); =20
> > > >
> > > > Isn't this a problem too?  In the first kernel we store the initial,
> > > > post reset state of the device, now we're storing some arbitrary st=
ate.
> > > > This is the state we're restore when the device is closed. =20
> > >
> > > The previous kernel resets the device and restores it back to its
> > > post reset state in vfio_pci_liveupdate_freeze() before handing off
> > > control to the next kernel. So my intention here is that VFIO will
> > > receive the device in that state, allowing it to call
> > > pci_store_saved_state() here to capture the post reset state of the
> > > device again.
> > >
> > > Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() =
and
> > > preserve vdev->pci_saved_state across the Live Update. But I was hopi=
ng
> > > to add that in a follow up series to avoid this one getting too long.=
 =20
> >
> > I appreciate reviewing this in smaller chunks, but how does userspace
> > know whether the kernel contains a stub implementation of liveupdate or
> > behaves according to the end goal? =20
>=20
> Would a new VFIO_DEVICE_INFO_CAP be a good way to communicate this
> information to userspace?

Sorry if I don't have the whole model in my head yet, but is exposing
the restriction to the vfio user of the device sufficient to manage the
liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
the knowledge to QEMU... what does QEMU do with that knowledge?  Who
imposes the policy decision to decide what support is sufficient?
Thanks,

Alex

