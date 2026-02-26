Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB0FFD9E1E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53296B0279; Thu, 26 Feb 2026 18:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00DA6B027C; Thu, 26 Feb 2026 18:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D71C6B027D; Thu, 26 Feb 2026 18:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75B426B0279
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:42:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 385C21A021E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:42:46 +0000 (UTC)
X-FDA: 84488235132.11.0A6A0F0
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf03.hostedemail.com (Postfix) with ESMTP id 224DA20011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:42:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b="gLN0v/HG";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="A Vqkdu0";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf03.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.142 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772149364; a=rsa-sha256;
	cv=none;
	b=c3aInSv0d2aB9QCizwitdOtZVMsNyTCBb48+/Sv89l2N1HC/tLxH8DfPxZTl6SwSyvnmhx
	gKi90ogD8eVlXInfvHpqhgVk05rzRQoMLl3eqQWhwI9xlO62OHYji8T0PQwpmC5UDc+hiK
	M5giSX58wwm5KWuFaMuW2jzoES9BsEg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b="gLN0v/HG";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="A Vqkdu0";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf03.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.142 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772149364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=du7fewflJTiy4RY4M9JcEhPtcfpcGR3V2HHqx7PYFdQ=;
	b=o1UPg9h2MPJSIuzb/coSNYVizubEBavU+EWlph9PS7BO4SVsrYff62BHVoxl/4mx8LRhJ5
	8KV46pVbbwhFbS0V/MoUIBLZEDjzngKJUhcdclrY7pIaoVLAA4ggnTdk5ismAOVaoE39wC
	w5i7hLeEqEQkZ9u+DeH9CXbLhz7IRr0=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id B11A81300CD7;
	Thu, 26 Feb 2026 18:42:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 26 Feb 2026 18:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772149361;
	 x=1772156561; bh=du7fewflJTiy4RY4M9JcEhPtcfpcGR3V2HHqx7PYFdQ=; b=
	gLN0v/HGUd/V0nfv+tewCC0psNtLQyjZbWvqVO9SniKU+XNel86qvzNsxsTS2rhP
	+Sasie1tUUqBrpPWrS09obG6ygRmkANwrxgWOkCDM99YeG1dyTDlauIbYKRX8PE2
	WMakPQx/cPdRv4HjyoQeOHuAIZTAsaIRiUHu3wpM4uMYzA7nCBVjEz06MLdEm41A
	Sd4QgIB3SB6ZjLRB8hTA+mwlxHlwx7LRGMAhY+tlWeo8q2rfRxajhWY6qzz8WA9h
	w990EEzbp4MIikkoNHGMBz72bsWhYPccOx4lL3iso06dObf9sebg+f59s/ouRF2H
	bgZsfIzIQ8mNqjwY526TqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772149361; x=
	1772156561; bh=du7fewflJTiy4RY4M9JcEhPtcfpcGR3V2HHqx7PYFdQ=; b=A
	Vqkdu04ZkIyGghzqKCUsqcO0POg3Ui7ZMXshuBnxTI388SOk5n10HzYar+rqSDAe
	C/6uGkhD0UC469ivtIUm6MMC5QT+s8RjGroeEQvOS7hXEzSI7hPHQ1ifklfb12AJ
	PZd4rLcWNzS3UBm315m+HpVcQYcoJZ47S4md1oBQZBtfB/90epcrjjt5NDuahanp
	yQ3OJeL9M9U+r3JPhk7hScLGNo3WIMaBA+LMuiOdPtSeCN+7DALf2bLoYs+W0zFh
	vTB1GITGhgd6ioaYRTmpsF+ZbOVhD3SSJMh1OEJPx8/oaB0nIvL/n0pYvarZcmQ1
	/SgJdlDJNbNiv4KcTcrxQ==
X-ME-Sender: <xms:cNqgaXpMmxoB3kSOky1mjx1TJLbpYE_Q3lq2_z-dSIS4jA6vVHQ8qA>
    <xme:cNqgaec7-4keVSCV7QvjAX8g0Bou_cq9lPLalblxCAnCUWGc4psij64v2CSOOGvJO
    09nNikj6hf5yRVfrj5XEWa0utzNlcS8aA1clUFTK3T5w5NPDwIqAQ>
X-ME-Received: <xmr:cNqgaYaQZ8vQYnZbKPuXo5gMhT_Lqft1yYIxjfNrQSAa3SsKG1FQ_U4-QlY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejgeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:cNqgaZBWGEMBMo6wAeDnQPoMQ1RB3_FyXD2bgYUBYWWoy3Nil71WIQ>
    <xmx:cNqgabDwuVEK97fr6qnquLcLxnx5_OEE9X7aEzrRhC22YMC0y9IyVw>
    <xmx:cNqgabV1-aqR1IFCc4MWo42xThetUjXbFjeGkiZ1NoD4KZoSUHe_tw>
    <xmx:cNqgaSC5ljiRgzmy6yv2HrPe3PYxrEU4Q8gCyruiHKSfRU2iM0Ohlw>
    <xmx:cdqgadKScMQkDT3KYeKNbDm9q2hUFzCVi1EFn1C9LtAtHYSjWGZ0Cjjz>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 18:42:37 -0500 (EST)
Date: Thu, 26 Feb 2026 16:42:36 -0700
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
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <20260226164236.1d091ffe@shazbot.org>
In-Reply-To: <aaDW86eWuQLZ3cfP@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-9-dmatlack@google.com>
	<20260226161512.532609ec@shazbot.org>
	<aaDW86eWuQLZ3cfP@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 224DA20011
X-Stat-Signature: am7zh5cfs9hg97er98ih9zr4455k5soq
X-HE-Tag: 1772149363-804052
X-HE-Meta: U2FsdGVkX18Qd2Qph0nY4Pf22xbZ17sWh0aXvc3K6u524H4sU0nYtUOfkMosUOssuoE7fxqMj0iHeoV4Xd9JDDoSHnxbbaN72Y5PXIVskyryvOwO7ZwP+TqsWLKsslznycJHP66S0p7LXAo9tzz5pTbwIHcxtgHBUjTvOCZKT0iZQumf6z0+XqfS6poPYig/GpjOMBlY46hGgVbUcu++61FTre5yYC6V2l3TVWDstmcpMjzuQPU11o0BFWBm0JZr/9RB6OZ6S1RN8ii6NUhVRisY5pzAHUdVtNxOGzfHdv+Ur70fM6GoAVJ393oaXMptnsj7+pBfTwqMsi58yvxwuilYFg2IOWxQOVMZFWdrKGeqNJ0vHboaCKbtniyKjGioFStgiphEoavtjellxNDZZ7xrqnNneTh2rIoRs2O4sSkSe/EG5q+8+G4J0HwxqNBZnlXwJUjL89Lwp/baZ98dvbkNpk0QXbMMIx18HBn4zmbPeHjZK/dvBxHsDFruQK04rTntXPQFuQIdBMwAi6TKmFu/KZaJwyJIonU4+/rm7QhSxslM4gQoYeJdKR9qv9kjvSxID+PUZU0WRR1urVuwaBRdFRqEnLS7QQv/QKZX4YdHvEHznnkit1eQITy2hPgEwTef7hfxH1/IIWFPv+V3y1v+/haoHZJIXqkM0+cV9zQE91euR7ullyHvkW/h7lh7hcAphkibydSHc1vaSp4RirhfTQTcaROQQuZrPdXyE5zQzwTkTHgT6BFGnmsS9TcrVfZYhkUgYcuh1zsLY1zFc+6/r796jj4eiv9KwZgW14tjr3hH9PF7rDf4l56kgtzl8Ehys88fniQp7hVCBDpUFs1ZeKREZN1tV2oStpwMtfrqXt0DfYYlXJc3MZCjfuCtE3zEX8JPdWKoI+YYjC+UMxgf+6Sg6q2iyY7mQt2pPSFo2azfrgfOq6BBNZmAmYUqrWydfbmSXmG4EfbBMag
 Dkv0IY//
 pPk7Jx+T57GZAN3QI9zaet6jmsB5viledcd9+0PvMILWVg3BetP4iB4Eknj6euNrhPc278XCLZ+V8fq8+L3Vgiduid0B1M9OYMFdzDXbuO2ifIA+nZWXiNPun0kmx7YkSo6//8Gq42y8i+slAGdiXXU/M4hO+Pc3O6iVsXmnf86gCBF1Yu0TqwBIvYiD+asiHqxTTF72/hVNTfeQKxHHBtynBobjdW9oNHT14XnNMG5dHV3hPsIywjJbMRN5goEkIGqrbL0u7hcZ8JCX1j9ZFSNrZmj61nrT9wRrK5ekYRRqh3FjwXLxDtXTRgxzcUkox7KNaevkO18z6XKK7WjZODkVFPTlJN6l1PFf1yxiiykARxWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 23:27:47 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-02-26 04:15 PM, Alex Williamson wrote:
> > On Thu, 29 Jan 2026 21:24:55 +0000 David Matlack <dmatlack@google.com> wrote:  
> 
> > > +	/*
> > > +	 * This device was preserved across a Live Update. Accessing it via
> > > +	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
> > > +	 */
> > > +	if (vfio_liveupdate_incoming_is_preserved(device)) {
> > > +		vfio_device_put_registration(device);
> > > +		return -EBUSY;  
> > 
> > Is this an EPERM issue then?  
> 
> I was thinking EBUSY in the sense that the device is only temporarily
> inaccesible through this interface due it being in a preserved state as
> part of a Live Update. Once the preserved device file is retreived and
> closed, the device can be accessed again through
> VFIO_GROUP_GET_DEVICE_FD.
> 
> EPERM might lead to confusion that there is a filesystem permission
> issue?

Ok, fair explanation.  Thanks,

Alex

