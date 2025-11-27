Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 827E3D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67AE6B0093; Thu, 27 Nov 2025 12:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18696B0095; Thu, 27 Nov 2025 12:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D636B0098; Thu, 27 Nov 2025 12:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0F86B0093
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:40:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40A3C1401E6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:40:30 +0000 (UTC)
X-FDA: 84157101420.30.311DACA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 21B1F4000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:40:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6KAeKYH;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764265228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXFedSl70VT3X/3+pF248yFQj7j1j8UZxxS7srC0qlI=;
	b=tmt3RPl0rSKLmDBeNYTEQpYHimTIdnqpez8Imw9nMiGnopXpj6rS3zUKwDB7VQvvstPwoM
	IoJCDzDA9r50QXkmVPqoa55/KsPoU1FyRlnyt0bvxecR03T1RB/t2LtxVs5bN8JIJax2F6
	VlwRnRkRyU/Uo8UXcfMG4wftePXDHEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764265228; a=rsa-sha256;
	cv=none;
	b=335jnxL5vQ/i2fnez0uZzuMaDNxHi7aov9FH7Nle3+e5RPFcA4ArH0HO1x603c7aHkIL7I
	HHzi9eiTXecsx/NzdFeUjofjCfJO0eIab7PG2MoWGaERIlXqLSUS7Ww+cK60DOQggxJfGa
	PGjO8g9c0GS8sRHlXm0sspa0oCHTews=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6KAeKYH;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12BA84427B;
	Thu, 27 Nov 2025 17:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40580C113D0;
	Thu, 27 Nov 2025 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764265226;
	bh=9fFK8uSNyFugEtT3snd0Du4kcqgnaKPZIsCUJy+1QZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6KAeKYHBPaFNr9lkiGFlrREU/yBUfh+robz08P/eZf9eqBRYMT9LzVOrLOCb6pEE
	 n7iUJDN+VjA1MBuP2u+IhMEWGbxodUo8CZ+/Xx8LH7lhVhWzDQvO0e48NGspPBhd8v
	 o/Xk8JvzgBClSRjPZlcHld32oo4Xu/WOvQhFPJjI97eu2vbSneM+6mkdeBdoiOgeay
	 GxU9SEjXrrNijEtfjXMmJk5dnQXr7sM01nEP37ENZr3s/iemu4q4bnCWRz3l6kwO23
	 amwSAIpWdxoh889s2QDGP3ua0UkDQpi3O8QmaodwxyIXVd36OD/sFeg3G8V2uEk/Hz
	 iSwKx14MM7vxw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 83329F4006B;
	Thu, 27 Nov 2025 12:40:25 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 27 Nov 2025 12:40:25 -0500
X-ME-Sender: <xms:CY0oaQIiDrhEv_K-RbyPcD6HXu2gYPKwiyag62XA2nc8bTx-NeAW9Q>
    <xme:CY0oadr2OVZivmTKbSy5KaW73OLe-1w2RxdW3oFJVJUg2VsGcdgOnQ1tbM0Rur-Y9
    RY6KHVbMDJnSp5wRCFOEvmStZwDl19e9fInVP5oBkiK29LQw8aNkeY>
X-ME-Received: <xmr:CY0oacwM43GT6XbezS8e9t0SScyPcUCzHw2UwZb-zIjec399H1KDpGY9puXWag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohes
    rhgvughhrghtrdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:CY0oaaqirM3EjJG4FTKCafXOIhSssiROrKOwiMwloed9df-GSH-vAw>
    <xmx:CY0oaZ5_N6lDtaSFUA5XpmUb8Gmh8_PFEvm2LzK2YExCdtohIzp0VA>
    <xmx:CY0oaUgFkeAYmET-buxhAOiKHTYGYVgEoq9BpbypAa2VIkaHrV4ofA>
    <xmx:CY0oaX2BFgbqjRkgEZ36rbhLKK0g0NljSv7Nubq5vET8zsRcqy19Dw>
    <xmx:CY0oaaU8T2fr7mCRIn-AAnQ27DtjClC1SuHN-RdidgsyrmR4fuQOvHkQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 12:40:24 -0500 (EST)
Date: Thu, 27 Nov 2025 17:40:24 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <dy65eupwalp5wsljetlto27l6tjjvoygeotjd3n7mk7zjc4dma@jf4hzsy6rtcd>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <14df1d99-7df0-4982-8029-e66dfb140399@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14df1d99-7df0-4982-8029-e66dfb140399@amd.com>
X-Rspamd-Queue-Id: 21B1F4000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 1kxkapq3gzagajk4k9kd3kuic576hwk6
X-HE-Tag: 1764265227-756958
X-HE-Meta: U2FsdGVkX18C5J7x6/edBI1CDxc/SqqfX/uFJhzLAcopjEfhYl0ArKM9v/oCNGe5uoUyTplsU6W+dyoaWdvWahxzKH8QYLeFtP8xMoR2WQU7H5hy1VNBr4MFotikR3k0lhZY/vRfXxqefe8DIFzTefBVDee2gDsBvCl7u6H0haXTUnXR402o670Jux/7WM0Mxrl8Cw7QZo9V89h8BFznDvbd1zcWxWjoXEcsJE5zUMhFOLgqYZy1kmjbQZQqGjXX5DKTMaUmMoi7XNXSrTfZd8VD0NteafoQifwzWWu/L2HYtc/GtEJsSnlZfymudn94ki5GVtnrwfYl9tnf61Cc1xp1Cq8JShLGSgfcAMgTw+jLSzAI2JwhNdoXM/kmTeHk+7kv2TQri4hY7JeA6BBOGiBOz7a9V9u8PZTXa0w2Ud6xZl+hO2tlGxRSJhwsmHINjc6TbHssUVIY5Lwo+Qg3oB6lvg5L9z4dEbPhR8hsOb3Cc1cS8sMAKCXR+K49Jl2Kkb3OY5RXrMMYmDnFdtU5IjSJoYSoLL3PsaUy4ZdMc/malnX3p0/jxbWiU++vTQ9khqETIENG7nCFg0lW12ahjhbwK37xMnel/zO5YnbETEALQIDds4mEkwjTKS0+JWOzKS6oJOt1P4NxRHpVdXEq4PZsa9UU/Jl1S1Fg8K1ZB3EyRgPotsxjzmwuHNTKBXyuTBDaR7wlVtDJ26Ye67KiEKN7V0xMwU0A5g7yjrL85h6qN/BUjiIE1AsFMiWNVxZ+rg94JjxtFYOPztZ6BW8V95akbxTt5FCH1js0fXmnYIrgthdBZ/G6ZvXYD60yJ9L9EBaAMC7btNC6rOz4zatswMyHDavYgTz0enRllSqOcvjpGmCDQlJeLHWpjwJnuOqllq7Ww6fT8Rasx3nvUOQsJk1dDDVyxgYq6thckUd+GRy7IuEOvo8iwjh7neNnC5DaodrdWJC35+0KtHjVWev
 ednUXdVM
 5QbRkqJ+miKkpZD0zZLZGXsK/4Va2ajaa43sENCMQB3jrBh3cGsD3a3i0D4+SQDDww+DMDrleqgBm2ZydjBMF35uZxr0ICv+lz70EuFocZ1zY/xCjMuFg6SytP+TfjDaQZFbKX21y61aEHhXMUluym42ONeEdIX0fx+pMnCPxGx3O6D5txxzsX5DN3KgnJDvNJL8s9VVv24aEMOsIE5yKsDq1ccRGWezNOylH/RA0BM6pPjd5aHtjikLovYfmDO2yxP4KjnUJN1IZ5uLV0vxVxEMzrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 04:27:29PM -0600, Pratik R. Sampat wrote:
> 
> 
> On 11/26/25 5:12 AM, Kiryl Shutsemau wrote:
> > On Tue, Nov 25, 2025 at 11:57:51AM -0600, Pratik R. Sampat wrote:
> >> The unaccepted memory structure currently only supports accepting memory
> >> present at boot time. The unaccepted table uses a fixed-size bitmap
> >> reserved in memblock based on the initial memory layout, preventing
> >> dynamic addition of memory ranges after boot. This causes guest
> >> termination when memory is hot-added in a secure virtual machine due to
> >> accessing pages that have not transitioned to private before use.
> > 
> > How does the hot-pluggable memory look in EFI memory map? I thought
> > hot-pluggable ranges suppose to be declared thare. The cleanest solution
> > would be to have hot-pluggable and unaccepted indicated in EFI memory,
> > so we can size bitmap accordingly upfront.
> > 
> 
> I'm not quite sure if I fully understand. Do you mean to refer to the
> EFI_MEMORY_HOT_PLUGGABLE attribute that is used for cold plugged boot
> memory? If so, wouldn't it still be desirable to increase the size of
> the bitmap to what was marked as hotpluggable initially?

I just don't understand how hotpluggable memory presented in EFI memory
map in presence of unaccepted memory. If not-yet-plugged memory marked
as unaccepted we can preallocate bitmap upfront and make unaccepted
memory transparent wrt hotplug.

BTW, isn't virtio-mem a more attractive target to support than HW-style
hotplug?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

