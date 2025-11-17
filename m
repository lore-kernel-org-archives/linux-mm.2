Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD10CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EF28E0016; Mon, 17 Nov 2025 10:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF738E0002; Mon, 17 Nov 2025 10:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEC78E0016; Mon, 17 Nov 2025 10:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 066978E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:36:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B433C12CDD8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:36:29 +0000 (UTC)
X-FDA: 84120500898.05.421CBBA
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7DBDB18000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:36:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=bTgByaG4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="a 3V3ZZ/";
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.157 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763393787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dumULOFDFktDrAv/FEHp3FtDy5iDmeMi8WaBMWjFFc0=;
	b=TAXWk55HIbaw0tD/2ijhVH0jHZY1TLWeSsdezNVkDy+kWW4RGJfHqKYsrslnZ6QYZrFrVr
	RxAgdaiqh6dRAF8voPZpfFZ7BnnRw9bC3+WLzqFWme2mXxWn/7x2VRBvfT/7H0SJSDlWjX
	VBygIErGqhISMnETt2tEFnLP5sOYWbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763393787; a=rsa-sha256;
	cv=none;
	b=b/lbpgUKtFemgQjNZUKSFjTsiiuvCOPy3VyVkAxvDiUJcxmH/xRE8X9wDV+WzmLKLLXnuW
	xwefBZI5fwBSWjsfUJWHsOiDL7kF7T8ZwWFDMJsdShv9BuGnALAsJYZM2i/M99uuMjtPYN
	mlwjOb59DMg5l6iGPR4HqgvkTvMpyaE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=bTgByaG4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="a 3V3ZZ/";
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.157 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AEDCD14001CD;
	Mon, 17 Nov 2025 10:36:26 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 17 Nov 2025 10:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763393786;
	 x=1763480186; bh=dumULOFDFktDrAv/FEHp3FtDy5iDmeMi8WaBMWjFFc0=; b=
	bTgByaG40HRwAAQHrZmUb1QxjoIKG692YfpeDBRFe9Iu6ybe//AfCHpW3mIPsM1M
	WYnkzK8lh2vXojzl2+qseUFiMvxqQKr0IYjFET9zskLG20I8YPQxfkYQYgftEyWx
	jeD3gXXQIl0ubwQsOnRCneY9Ee+d3+FyAnOe8/ZEXTNbJBdR9zsD/Uqm6CFnrieJ
	60m+mV6mdpdJNLWAtv0sUtz2nkHnAVCeUhvAsXprKWeJ9SeFuthsuY3OGDw1Tpsw
	ZMjmSiwEFqUDMvWqfBkZB2f2ikmXmb74OaRGArj1p0panyj3vvVWtNAew6f7EjEB
	kku47rytqu0faY0bmEgdRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763393786; x=
	1763480186; bh=dumULOFDFktDrAv/FEHp3FtDy5iDmeMi8WaBMWjFFc0=; b=a
	3V3ZZ/HrTsgG7BZQp9uEsbe6TdQbscGPUzzV1ucmE75P+RX148fjF6z3+eDtfxE/
	+LIsnQGcry5t2eP9DsugDIxSRuHjQL4Pa48vQlCFL4Aj9/mvHNagLk5oliXqjZiN
	P7d9HhnMs2X2J530B8bl9/HIJt7CTkAoGK83TiPn4Am8w3vpm2woXXyidHxnjDmy
	AoDIYJqVBQO7kNTSKqZlkxYHdKM38pK6DV5BLhEpHopJc14gJ9bdwbzb1CECdFQ4
	29UG0a8x0Qak4XNvR1lJ563e3TxaNlVHCoAPZmYQcpWw6cJWVjhYMw/XcXCtUO7+
	0XyIT5kl1gHE9x0NMHR1g==
X-ME-Sender: <xms:-EAbaWyQ-WAwnluLWHzIZSr0mg8fK4EjRWclwqn4UadFrYR9CFAq3A>
    <xme:-EAbaYnO_OBUD04HGAVXLl5Y0sdGgCgZ0LkU9JWquhPnnfcmXV8ZdkOcf5KlVUEak
    U9OYBBXPjLciDkkfhjTYgSLsu-_gFaVGAR6arDrg1_4BpjJyD5n4g>
X-ME-Received: <xmr:-EAbaeV7CxOi5NsfI_0iHooQtOGJov1ufXfnaa1D97FrNVc9zEAX-2Uc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvudekkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgffggfegffffhffhhefftdeikedtueefkefghfehledtkedvvddtieehveej
    fffgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepfeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegthh
    hrihhsthhirghnrdhkohgvnhhighesrghmugdrtghomhdprhgtphhtthhopehlvghonhes
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghhvghlghgrrghssehgohhoghhlvgdrtg
    homhdprhgtphhtthhopehlohhgrghnghesuggvlhhtrghtvggvrdgtohhmpdhrtghpthht
    oheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehrohgsihhnrdhmuhhrph
    hhhiesrghrmhdrtghomhdprhgtphhtthhopehjohhroheskegshihtvghsrdhorhhgpdhr
    tghpthhtohepfihilhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmrdhsiiihph
    hrohifshhkihesshgrmhhsuhhnghdrtghomh
X-ME-Proxy: <xmx:-EAbaZ0fTJm_ATpV97jWOpcVupVrX5qYHi8qRNGt3G3rqeBOTipOKQ>
    <xmx:-EAbaekY7TK2z-tERLv9vPNj8oV4GTGLaugTF_hEpglIkqI0gqjajw>
    <xmx:-EAbaQEqElQCUqBqS26kmOTvil5W3KYOkdSQUnH2TTqyeLc7k0jBCw>
    <xmx:-EAbabl0qbHJHfqmS6yt46qZ4Q6MuXUoWNyxiao6TOaw-x3l0mdFoA>
    <xmx:-kAbaVsEtsMVur8JcMzBXoqZTmuBVUtCij-s3rV4asHdXPXnRrkBls7n>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Nov 2025 10:36:22 -0500 (EST)
Date: Mon, 17 Nov 2025 08:36:20 -0700
From: Alex Williamson <alex@shazbot.org>
To: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
 Nicolin Chen <nicolinc@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251117083620.4660081a.alex@shazbot.org>
In-Reply-To: <da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
	<20251110134218.5e399b0f.alex@shazbot.org>
	<da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tr7113gcci5r8bioh1qqda818gap5k1i
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DBDB18000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763393787-433671
X-HE-Meta: U2FsdGVkX1/bpqo4Ob75ipC+SsJZmthjCWu/+VaPRmGdFr5BN6RoMnK4tsfmA+T9HyGhbEtmDNSAnyH6zPCcbEQ8aAP+ypshjdxJFS/873SSvyP+7kliMg7C6cTjcoVlBjRRZQuIJNR5JXEfSu4DCZYftMwccN9WaAV6h1jp842imqD+7W62GivjuOY5hzl+Huk4BqRBiZN0/Y+aNtKL7GT3hgcm+7clWtF9CguwGe66jq8aSg3KFoaQedBPynjR5v+MgFXk5oCt5JTZVm7Uqw2Fnyi4bWiw2N9DPfsQ4ehrLF42WUqh4RKHjXM2ST6Npew8Hg4KoD4ftx4f0hFSuv8LzoXdsH1+GoxSLF1gYdq+qk7kM4m/0E/QXG3fFY86RZwKbxYLosBgqM1IjJH3cRZZRrszvK7dFTtKP/jC9lie+SDg65hLb09HbC5Tki3fd78JX/p5MJ8azmr7WQjLo+o2WgxfgZMJ/rnjCrCGiEMjXAmUZl7k3myrxQ1aKQFvdtF3iFeXRmLkVq8yfH3mP1rlJ+L/AUYvTuK2PZrzCIJAgR9QWdsqe8UJ/aosagqaZmsFCMbYndHHABKzE03dhtGOaxzzM802RrB7jzXIWBJEinu8v0r71yNEgGFQIRiNIJS7qfxKT3MtwC7yolfAWInPN5odbXzLfeD07EZChq0v7I26r0fUd6fluk60xIW8ivVBsBrg9vVxaj1LS7MHLvTBG03vtcfY8w7WWtCT2FNVIz1FluJjW+oownv5+jxd0bUYy1zXF4Gj8yXlVRznobiFx89BiXJcTUdc8stqGe4+ZO2jerYDO+A6qDbcOX1h9frjzOCe8FQeirvy+LvcTs+13O0B72yg1lKKXUYcfoRSEp+COPnOFZsXMeyot1Mv6nJ8wnXFijuiKPUYzb9pCC0vA+9gdrFhIqHo+Xy2rKQwCObi3i33+eCoGV+znrt0d4AykftlU/TdMw8ReJE
 pumbmjNr
 3/P4Xdf2ZX8FafxdSn58OA122glzgxaLzyH1Gqn/P1T/Zzhb8Z0rPEO1PqRxYUkvwunlU7dBLrW/AgUVUM3J2cMdDo4EdOPoB+5g9bizdKYocIpSW6KXiaE55nObrJq0gm5GMs+9DQuYMQzVPuWd5QgwA2okKo2hDgfKraEKVTPYzDuBwNHQOE4/4RUgoygN6PMKJ7pbsVo0FasvvjDS8g0J+Bp+M+gjq1BJ1I52mQzqgR4gpNDkMxBUmmG2E7SkPj8t+ZuF6Sf2fR019ryGQE18YUnpv2z97JvAnI06HvFbau0Z8QFGXWCbD1j8tDo4nXfnhoCAbIbeQxO9urfrPtTT4YPLgzsYJZsPxBuUtJP+E8D9+mgfSC6tuqXaOeEMZx4Pysg0TSW5Xg/8QF1ekOqBCtZQifHQ3TuSloPjIkJ2t9AFju2XyEeZ2zQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 09:54:22 +0100
Christian K=C3=B6nig <christian.koenig@amd.com> wrote:

> On 11/10/25 21:42, Alex Williamson wrote:
> > On Thu,  6 Nov 2025 16:16:45 +0200
> > Leon Romanovsky <leon@kernel.org> wrote:
> >  =20
> >> Changelog:
> >> v7:
> >>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
> >>    to reverse loop.
> >>  * Fixed spelling errors in documentation patch.
> >>  * Rebased on top of v6.18-rc3.
> >>  * Added include to stddef.h to vfio.h, to keep uapi header file indep=
endent. =20
> >=20
> > I think we're winding down on review comments.  It'd be great to get
> > p2pdma and dma-buf acks on this series.  Otherwise it's been posted
> > enough that we'll assume no objections.  Thanks, =20
>=20
> Already have it on my TODO list to take a closer look, but no idea when t=
hat will be.
>=20
> This patch set is on place 4 or 5 on a rather long list of stuff to revie=
w/finish.

Hi Christian,

Gentle nudge.  Leon posted v8[1] last week, which is not drawing any
new comments.  Do you foresee having time for review that I should
still hold off merging for v6.19 a bit longer?  Thanks,

Alex


[1]https://lore.kernel.org/all/20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidi=
a.com/

