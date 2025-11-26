Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF655D10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307886B0030; Wed, 26 Nov 2025 06:12:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291126B0032; Wed, 26 Nov 2025 06:12:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FA16B0062; Wed, 26 Nov 2025 06:12:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 030836B0030
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:12:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4C72160522
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:12:18 +0000 (UTC)
X-FDA: 84152494356.06.10D0EFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CDE46180014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:12:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ahas3Q9R;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764155536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmMFe2NqCcDkVtYt8FkNPAhVsdA2xKCWpY7c33v+/uY=;
	b=8YNUUE44uaIRzn1kGq6HtOYn/uNOLWpejUM3xGNIjRs4nloa8K5R73Nt2/fxi20K2sNHfE
	nY7geIMdaSE8dvAMbctQxSrTnfI0a0wB1Sad8KPHGEuPMgSs8u6HHnVoHFlYi3po+VXAaA
	IZltKW1pu9bs5Kf6s8cnaRcL70b6NL0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ahas3Q9R;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764155536; a=rsa-sha256;
	cv=none;
	b=Xe+csUeNxdhY3sMxMvRJk7lhqPubDbKDEAHuI88hgsBogvQCmOV7g4ZhxwvXpXFbUh7tuo
	iHeXh55y9tEtJyz99jjocdTSF9RPGvMOEn/P70CSeEgKz643bGz8xEWlNVrGcjKiGvnBVm
	PuRBLrjOltTW85g/AEDfkSXt0POO7us=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D434601D3;
	Wed, 26 Nov 2025 11:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50491C113D0;
	Wed, 26 Nov 2025 11:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764155535;
	bh=5phfIDtqojfphtJHC0IyyK88IR5Qb0Al5LqeMavVjCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ahas3Q9R7vcSoOjtyH5xVKKoUfwGEdH9YMldDKqXq7mpjBVe/reDYQk7Rgzkj4e+s
	 TBIa+lBkRYJGxTRgrDpPfWyRv35mTXW5fWk9DgMd+XM6igQi6F+fwRaZOxbnmrCXYr
	 a09ZJ3S13BjHAStYY6A2tjPlghbu/LOoumFRrjgFt65256V45WJ+S+uuVdk6NfwCNr
	 d7FlobxPExcOh4NnQYVFm7NbSsKXXG42nfB6UH/INHjNpu1CuNWXRzpULftHLpU4OF
	 nEpaUs6QJ36yfubqngrXcfFa8768pBWmASIN295allbJG6nZI5Oono8+fhC/CmS7/w
	 4EXevleu9s31A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 94BB2F40074;
	Wed, 26 Nov 2025 06:12:14 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 26 Nov 2025 06:12:14 -0500
X-ME-Sender: <xms:juAmaY-bPQxSpO90AeZ11ay5E1II4KyzeP-auTctxsJsyfe8E6ERhQ>
    <xme:juAmaeNloSl5Oz3Rld8lU_p-bcUfLyTHkQfLufFM7sFemsug7VmlCZ5iobxMMWkHX
    q6XdRpgqKrzzJuBnzHzAaJBmgruoWypZ1PYHoqzCoMk6RlLvGhgBmQ>
X-ME-Received: <xmr:juAmaaFp-4zS2N67TEm6DLu-cw5C6ucRk0LqboOy0Q_Mb5plFPd5GChN7ZjKkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegudelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:juAmaVuHz4Q9ULWzJJUeST1UHoh03F3sIGKS5znoOrD4KIgaxwi6Dg>
    <xmx:juAmafvktU0ExlYil5wOkBt_9KuFRpW4x_r0K_ahKgKpZr1_VL6Cxg>
    <xmx:juAmaeG7L5E0ycU4wuE0iz1pFqA4px9-clJYEo19cBuLfVjKP-BV3A>
    <xmx:juAmaaK2w9R9Yt78YpWSRzvsz5mxG5QWTCrJalRDZsTdXL6CTZ9LXw>
    <xmx:juAmaWYb6hiZ2alAOSPn83_ldxz5MrrVXz7FSLLFWHIsvoMAmDw3uegM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 06:12:14 -0500 (EST)
Date: Wed, 26 Nov 2025 11:12:13 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125175753.1428857-3-prsampat@amd.com>
X-Rspamd-Queue-Id: CDE46180014
X-Rspamd-Server: rspam02
X-Stat-Signature: fs8erzd5brkba6w7gejmyy8mkpyrge8q
X-Rspam-User: 
X-HE-Tag: 1764155536-122141
X-HE-Meta: U2FsdGVkX1+fZF/g4gEtm2qsuJ/DiS1Hsp9QIs9GXCA/kT41i6IvU8VRTyVY4KNvRBLPqclp+g7Q/AgonVbccDV3pLEPLpuOOewx2Ia53pmC+z+uwGtuk2o7qHkq/6ELA7noH/MNl3j9CM1NtEgkKJIuOczoB4tyLm7XXx5BQYcfpdcvD/vNVLJxrKfZ7HLqhOJ/5JIUb1SXl1aCqzQmT2Vqk5jAC3xJW/OqbBSUgwGmm7G6Q8fp/vFO4N/rlF0WCrcArbObtX8vJxYSgxpLJGDBeqaqzyJHec3dOeS6+IWpaFlmCRPI00wbiTBzmEDwTgS3ysDfgludQ07J4MQ3WG0+FSYqOS/Df0v/QJxCWTve0CoJNu1N71yLuskpw6uWYAE7C28u0pg0aSlG/0z0uavRBMy2pfdt9O/aQeZymozZv/UTRo8TgVqrs7nKWOAj33iw6NP2ZWez7uhI3sKI7xIEVigx+xPBQNIBJFlV2FebTl7HKSZppFMqf4uBdqtaFUZfKGWe9XmJTwAErGYNrndYhXqVsGmpmBJMAGQIJ1I/xD9Nsg8iBURxOTusVOCzsyMv/5YeULCrwdBkegCTdz/Wop5xFL8HvO0lpRiVCv4aazKGoHCfRaSCGsSRMRb2i+ykjEvVVYStN0b671dBSagm+d94tEpgFyl1NjwgnJ2g1zuEMg/kIgz/XEmU4yL8DOjzHDYqlS1OYQWU2Y1THS3gWrZ4I58JDOtulv53x8dnT2f2IDCTgHSaUJS+5YCzG0Jcyl24B8SSJQ0XRZyXgNDRd9csFqYmgU3GG0UIWWEDJ97JVXxFfR27ZA+VNaEyMfGwW6v1ZXNhejbFsjDdpwQ6pGtZcsPBjkqNr5OpOhxHz06Lp6UspbtrCAPheKqQZMvHQoGIeuM9M71tzUpeuCchCKdWRy1KV2uq9BPeT5LL0NUUcIZ+hal9FRcAX9l5/6LPzhxEy+m0HYypwMF
 u+aSP50C
 lV3Roi/PkZMhvQ17zaO+4cmnbKN05Vez9dO3BSjqrjTEPvmhMUnhOxRNMlYsLCFVSfT/djxtIV2MdK9zsUfz7QDiclvx7L+63x+Z3XAezGltZwW0v0pChY9LFraIVYP8wgONShCqe6rZ9ya7vNNuBAxWsxlzKhfSrlF0vuQRd8kfIfiB4Xv/a18ZPe0Zx6zizL9ZXWKzrpGS5Uwt2w5aGMlzkqlpbcCmrkK4IxawYNKQtzg7gt7iCprKGjNlkPOxxaOb9MpSWslgHEG11FPMAz+/GUHO/PrCp98Phf0PxpdWvnF4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:57:51AM -0600, Pratik R. Sampat wrote:
> The unaccepted memory structure currently only supports accepting memory
> present at boot time. The unaccepted table uses a fixed-size bitmap
> reserved in memblock based on the initial memory layout, preventing
> dynamic addition of memory ranges after boot. This causes guest
> termination when memory is hot-added in a secure virtual machine due to
> accessing pages that have not transitioned to private before use.

How does the hot-pluggable memory look in EFI memory map? I thought
hot-pluggable ranges suppose to be declared thare. The cleanest solution
would be to have hot-pluggable and unaccepted indicated in EFI memory,
so we can size bitmap accordingly upfront.

> Extend the unaccepted memory framework to handle hotplugged memory by
> dynamically managing the unaccepted bitmap. Allocate a new bitmap when
> hotplugged ranges exceed the reserved bitmap capacity and switch to
> kernel-managed allocation.
> 
> Hotplugged memory also follows the same acceptance policy using the
> accept_memory=[eager|lazy] kernel parameter to accept memory either
> up-front when added or before first use.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>  arch/x86/boot/compressed/efi.h                |  1 +
>  .../firmware/efi/libstub/unaccepted_memory.c  |  1 +
>  drivers/firmware/efi/unaccepted_memory.c      | 83 +++++++++++++++++++
>  include/linux/efi.h                           |  1 +
>  include/linux/mm.h                            | 11 +++
>  mm/memory_hotplug.c                           |  7 ++
>  mm/page_alloc.c                               |  2 +
>  7 files changed, 106 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
> index 4f7027f33def..a220a1966cae 100644
> --- a/arch/x86/boot/compressed/efi.h
> +++ b/arch/x86/boot/compressed/efi.h
> @@ -102,6 +102,7 @@ struct efi_unaccepted_memory {
>  	u32 unit_size;
>  	u64 phys_base;
>  	u64 size;
> +	bool mem_reserved;
>  	unsigned long *bitmap;
>  };
>  

Again, this is ABI break for kexec.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

