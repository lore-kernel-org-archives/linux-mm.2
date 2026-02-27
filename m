Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8F9FEFB5D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E766B0005; Fri, 27 Feb 2026 10:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5BB6B0088; Fri, 27 Feb 2026 10:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690536B0092; Fri, 27 Feb 2026 10:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB4A6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:47:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C37D160754
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:47:11 +0000 (UTC)
X-FDA: 84490665462.22.E2A59FC
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id DFF7E120009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:47:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=nSbeJn09;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="A 7cma9d";
	spf=pass (imf29.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.136 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772207229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3lrzFyQElxBxtWsP+osjrtrIRj/rA3HI8aIxSL+eHc=;
	b=iLLV4tJ6LwdVOPa9vKYROpSyxTtDSRTunIKiltkY00JOdypEs1WA1WGHctArTsstekar8A
	hLDU9bjF0STPxccEUsnUab/e6k0XQCSnR/xhb+qBJytN1473YnfYOb9EX8s4facAsANnBq
	2Px2lcvtm79qaIdbmKFVVjq/iqcbBTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772207229; a=rsa-sha256;
	cv=none;
	b=yglpmpmE2Qf+XdT+ft3uB+DjTTyahbhyoYoEWaUZzWfcKYO9dmQ43afA41hSozAqiB3rOU
	e+PYLBC04jZKub9Y/hhG8xDTsu7/qeeQQJs4Z1t7Cmjy5ZFRUjuCqdf4C8DcsS4la3RKA+
	VY/LIYxJJjfrWCT9GrRsZ4KWk9S5BLo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=nSbeJn09;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="A 7cma9d";
	spf=pass (imf29.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.136 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 1409613013DF;
	Fri, 27 Feb 2026 10:47:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 10:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772207225;
	 x=1772214425; bh=P3lrzFyQElxBxtWsP+osjrtrIRj/rA3HI8aIxSL+eHc=; b=
	nSbeJn091CVUD7FTBlfHAGofIbMFpGvhhKPN5P+AXxi2R6g+zB9bTzPy8M7zKOX9
	190koYZVQtOhErFW5Nk2ZXp3dvbyl6UiMLVn8Vdws7SsR0yodwKy9wHBllJkNGeA
	AsGuDTTDeNXhDKsH6A+ttPLVwAgWN6I/IDfUUfKYIDL7djAhXluESe2mDgoVuE/0
	H5H5lmhuaO4ap/bK0tc8OziXtOlDMPcxvZ9+r+b71xqQG/wIdKjH1rs6QDjOCkRk
	NLaqv5GEjMIEAoVWLHqK6FLBpxQhya3L1m/31iVG+OzOLBESOmuKD7/FN0SBI+f3
	94CVvMVtttES7JAOlQJp3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772207225; x=
	1772214425; bh=P3lrzFyQElxBxtWsP+osjrtrIRj/rA3HI8aIxSL+eHc=; b=A
	7cma9dBosB0GIWXa1m7+Lm/GchbRtgqA/xwo85CSUbQlkjtuGWtWnsFqnFaEz26K
	XIjU47rn+BcT8PvTsqtvovSTHPoqwmFxcttdD8BqQeCdzm/9K2blLDhKqWUl3idP
	wIyeWR3wYpc5y+VTOnLFWijeVmHt3I48Wf5E5jBf3bfwmmPzfIEl5Uiq1ztEtCUb
	TtxChaiXmQlGbcnDqB0XuSPH9RUPouePhNnHw66TqOLnqCXBdIR+BZZwgl/mePTT
	2Ndu2PcdwnDMxOAC1MaII1xlSg8Ocgn1jc3idGiGtiMejdDwaHcAThhlfyHUQ01U
	YmEbEKrgFw3TDqLvqVi1A==
X-ME-Sender: <xms:eLyhae8NLfiHQAfvFbwIf5yfJxGrx7KxbtT7pspvJckoKaT9zcfsGw>
    <xme:eLyhae4tsQgypPwTHo2DeWnsQy7bTLUs3VcUPfd9RrYRFV5seJeMAhrG_sP3LC7Is
    d9Lnz9eMprZ9jmWg9vNexMWxYMBNR85faQxljPC31hLURgUua9RsQ>
X-ME-Received: <xmr:eLyhadjLu8rkkCiD9LuU-gLeXJaelMWBSD-DAgNH5GYD2MjN3YfraFIWVNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelfeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:eLyhaViQEXxZhGRPLBgx3cIxwcB6BJldmDuFBveN-s3uybKGEg4BVQ>
    <xmx:eLyhaT1gmUrj3pS2nastletXexcegngkRYpkqQAlCWEUiBVKvt_8Uw>
    <xmx:eLyhaQjFwwGVa8eE3K-VjdGUDc_gumNbDo92PQ-hmX33aTYcusuheg>
    <xmx:eLyhaWqfdVOxky2hgCGNQH7N4KhqFKsCvw6Ruxq0xBQwJyfcQ9Ociw>
    <xmx:ebyhaTuRNv-HWsJCaeyQT_E-CL0vqudE11keKbVebqGUMZseVXYpmczH>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 10:47:00 -0500 (EST)
Date: Fri, 27 Feb 2026 08:46:58 -0700
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
Message-ID: <20260227084658.3767d801@shazbot.org>
In-Reply-To: <aaDqhjdLyf1qSTSh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFF7E120009
X-Stat-Signature: hgb5cmb7g1f37ghdykggqx6p6nyqasmo
X-Rspam-User: 
X-HE-Tag: 1772207228-110676
X-HE-Meta: U2FsdGVkX1+v0L3iyFTgjv2Xr4i/Q72hZMaVxQyrSqg1vxwRhxN9e8FC2gGy9SJzCvSCLEkF6AxsR1zBV2ZKZyrH7M09B1Wko6meWQcf4J147caDLh8y1tEHJP3IPZQlR92zNvTDu2rCukq54wg0frGTxLDyZ70aHAiQNtjHZaxU3NAm8GXLArVt1j7lerB6z6TZsCujS84ap5GAVYpvb0NjxNTs0VOzfOCBmaB1+TVGuPBLHas9zwH+OwyluUELg+RTxGMOEiTlDQkB2nv8R54u3YR+JDINNZLJEQjXbeBjrw0o2v7xFKQo8/z8G/2j1P00iyWRlnFoJOT/BezGgiId0mrxyHJWiLHxdAh+URO+qiFIedD7b3GJtbzzZrpdRTceMsQLH7d94GiPzZTZJwZMOs396rRiPmkQKOROGH+UOn4RhSJ5GyQlbX8qPjZHmyBVhkypJIQG56atURPTN+TVtnClRmuGd2GpBb9scLf3FSlb71y1cXSuZXTkDe9v7xuNCF/tjIkTTLYPp1Fn/7XGJiTopgEbMTez5LKk9Q+3cPLpEsvsZGR5bcjSlLtKdwP6/kTowoLzk17Aiqj7YEufopA4nn8SbNqJXsgSKIEMwzogsLyozzXg1/67PvUWSmnlHaYsGHTpTJrJBHPqmMY17GH6mToh70m1v846rGj97mN6+/NhxC4sRcvQb6tCgvC6iCujnRFOxQW+weNrwt7vSEWAVinfNDA62P/RuGiJ29vroFI/ztzvPyetuOKMk/hmrmS+bBBRPyC59gc3tEe2sUz/9IliKCua/eWfY/sNLce1esbhnJXao+G4JUp20zX7LtDmRkPW/8vdKoGXYYmE5gYEt0uXO1d45Y3Z5E6/AhLOW35urG4Hf8FGiNpHRxJLaaAPWFThq7XqP/7YRSa4/XAEK4H5wsIm2Q1OlKaJ+cda0ahIsT3l8j3CDkXjeH2hJ26ncLnpFDXW/mH
 dti0kz1H
 xZrh4ej7tGpqWjHmFdn7NBQlaR3L0TJEFxnEbwl0EQDV85bl3Rgoy6ZGDmuwxVxgisKR/1O8hhN509ZbF6R+qvViwHnXpg8Yr8jMlUpqkwZLIKt1AsvgB+rkBkZ7x1GVeUhsGr2Za0ncOpmogDbDXsFopRqH4eUizITag239PDTkHiz3VyH7wmxqUz+eV6s7hm5JqY3Fl+TBbasPVU1oyxMM5xjIVc7t6iLVadxWtzgfkhk64o/9+dbp0cI6vYbVXCCDWqe0pWuFtpxrHNy89nTmEcNbOEEQmMFk2hP2Fh5rHYNlDnOTpIyrkfXzk4L2kmwz4BX/WUxtpl5zihRfgOzVJKMd9LHGCE8EV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 00:51:18 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-02-26 05:00 PM, Alex Williamson wrote:
> > On Thu, 29 Jan 2026 21:24:57 +0000
> > David Matlack <dmatlack@google.com> wrote:  
> > >  
> > > -	vdev->reset_works = !ret;
> > >  	pci_save_state(pdev);
> > >  	vdev->pci_saved_state = pci_store_saved_state(pdev);  
> > 
> > Isn't this a problem too?  In the first kernel we store the initial,
> > post reset state of the device, now we're storing some arbitrary state.
> > This is the state we're restore when the device is closed.  
> 
> The previous kernel resets the device and restores it back to its
> post reset state in vfio_pci_liveupdate_freeze() before handing off
> control to the next kernel. So my intention here is that VFIO will
> receive the device in that state, allowing it to call
> pci_store_saved_state() here to capture the post reset state of the
> device again.
> 
> Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() and
> preserve vdev->pci_saved_state across the Live Update. But I was hoping
> to add that in a follow up series to avoid this one getting too long.

I appreciate reviewing this in smaller chunks, but how does userspace
know whether the kernel contains a stub implementation of liveupdate or
behaves according to the end goal?

Also, didn't we violate our own contract in this patch by adding the
reset_works field to the serialization data without updating the
compatibility string?  Thanks,

Alex

