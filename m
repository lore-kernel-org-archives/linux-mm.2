Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E0CD111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38696B002C; Thu, 27 Nov 2025 12:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1A46B0098; Thu, 27 Nov 2025 12:36:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A624F6B0099; Thu, 27 Nov 2025 12:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD276B002C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:36:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48FE812ADB
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:36:03 +0000 (UTC)
X-FDA: 84157090206.27.198BAB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1871A100013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:36:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jQsMAm3r;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764264961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwQ6vFGfOsv5fxq6SjDgt4ks23fqMxMHcUj+j+M0fg4=;
	b=oMFkSO4ELzo7nzXJ0c8yFSKsDH6PLzx0HrhF0dGW2IZKEpq7DeFMSxqUqqh0fmOOS2I1q+
	BR371HIyWmmonjlCf2Xqk8tvVL+B55F+1XSgsHQOPPROvi+7lp2ZLHHxXVyUMG9iJUiZcS
	olWJgCaomvDNJNNu6lBsWmd492EAv/Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764264961; a=rsa-sha256;
	cv=none;
	b=HBFkQ9t+F1G5v9XV3+JS4nWMcnQBpVgdGQS0fsy+DExaKdArMmjk/cECYbVkPWTkwepoBN
	CUpW0yJGrw3s6BrNZmATcgyMxMiCzqs1rwHJKlFHDt48NdPMh0NOuAaJAcIwbGiVR9B+vI
	CQDGPqWKXggr22FkZzE06qvslRl/DMo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jQsMAm3r;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB4E1437FF
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEB0C116D0;
	Thu, 27 Nov 2025 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764264959;
	bh=1bKaUQJjk7onHAJ7LM9S6djrYU/YUN9thAsdh7lkx1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jQsMAm3rJAmREBgoiT6UVgl/2m6daTCoAUGCG/aFzy23FKWf1IRt2pOcqL/o02neK
	 z31NQoZp+Xq7oIPg9Ln6zqZdnDfSMu3st6oBVUjcD05M3XNXHCQGCoDmUphuEWXA6Y
	 W3eJsJOz2eRGiCNb+q8xNz/sadt/B8lVQ+6HZJZ327OvcSoaNek8D7ARYO8EmKF5En
	 za2Qsuwg21sBG7eI5vsFeHp0iDHlUxtjYB+fsoaRoK7e5lT9fImRbbumXEh6blW+wf
	 eK5ijZ0w9/G+YZJ1xpmyDQN7sZ81ctcKoRIdd0ee232VpikhpIUA7IeGpCMN0aX6Nv
	 KS+V2vnNLkCtA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id B4FC4F40075;
	Thu, 27 Nov 2025 12:35:58 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 27 Nov 2025 12:35:58 -0500
X-ME-Sender: <xms:_osoaQwWPaEieY1br7DZkeVphjqMCBSEtgP6-Le93aV3X2LmOULmSQ>
    <xme:_osoaRzbsHN_dgyG6RpwUE_kgYvBGvJxCFpqsYhpzINhcyNB9zi_LU4khX-vETWI9
    7ZJ0qvaK8lcH3wzJiP8ZZSoWY8Gzrm-CPCyU2YvRAEuDxJSzxuSNw8>
X-ME-Received: <xmr:_osoaeaIbXfvF2FB-G3B7qcQmAb1234r4WCi9mttgI8X1MhqkxlVVZRgTUEoiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopehprhhsrghmphgrthesrghmug
    drtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphht
    thhopehlihhnuhigqdgtohgtoheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtth
    hopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    giekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhho
    nhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:_osoabzVGoneUI9bcGJpOEKwo-4Kyoc7Pp4k_O66__SSZgVrhQOH3g>
    <xmx:_osoaUhqnSkooMnXFxuH3Wgxv20PIKkfYihKsVwfWiBcjpW_V9tqVQ>
    <xmx:_osoaaqrgt2vnUA_Mpduv6oyYvQUpmujbNtzg1hVLFYlKAAlklnljA>
    <xmx:_osoaTdlzjKaVIDPRlENYBvpOcia0uFb3pRE82NtnPX6FLAjI8PgLA>
    <xmx:_osoaddOrOMRw4zNiHP37WyO6uX5UemRRCtkTWhj9mk6TNbwTw1PWnzN>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 12:35:58 -0500 (EST)
Date: Thu, 27 Nov 2025 17:35:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, david@redhat.com, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1871A100013
X-Stat-Signature: apbdmzfaoihiqt37gqzq97asjfptcrsy
X-HE-Tag: 1764264960-582923
X-HE-Meta: U2FsdGVkX1/I2hspgpTPwS8FmqxY19/2nyVJP+6bytxDRECXL9kCx27XRk7dRTNyVZsk/mGoT+ddrUQRmyeAHKG0q1N5Zlt82bzIC6mHYJie02EHTRtHLtgsUWMPok0V/yqOukayyBtxkbqoo1wUOeToYoJxeBtdBcZELHt4FU+oY0TsIn/57fIeYLDZz1Ldwvkfqy28N6F4Rssigm/MqiwmXfLBAMbgONOm1UJLLvMiRYNBbrklRsWTTyAKu63jUCfvzykYGAwGMHbWK9u8bYGzcRhqJSoD/cv/DF8WyHSAbj+rNbGItX9O9Xlg6zmdzhDjSb7LrwKcGY2YMIDMGXPeCcbuQwontBdolWOCVDR2fja1HZupu5H6PInKSxWVyML8WSwEQgjxQqDRY1E+JKbf7PM8kGDZhdku84s0ht7y9yX7iqtq5grPs80EbSMtx8iemyTFxm7o7BwD84ngDIX5x06djLLaJlJRVcBZTvLxEWzvb3wRUtH3crtNFvbzH2Ai3A8l8780UoNs5A0lkfmNg4LDPR+Qtf15u4B6X8yBocDz3VBzKJaRZcEvzMlVogwVQGiMB27v8jGZSUk5fNf233ZbSdhhcu5h+gmqtNgNlBwmCIEJxPKgqm9hUPC9Hhnob8UXg8ppkBHsjJupa+HEQsHXBMhCRcT/DVQXFM/N+HriACY3YCUI7EZ4/tnyO40Hb36uKdPAmPAtpkmwU0ETba8Api6JaFAQfJTqpgXqovbrxmzw6z0903M5lBdidvQnLG0sH7LiKpk3QlZ66VI2kJ5lXf8iYGwDbwNSZfepI/WxbXHnwIgVV80L4Je8YAR9odbxf9PbEecXkYz/Txwt9VHTpqZJ95o4Q31tcCwFoPxkxMuCiL7+oQu8TClcNbp2YRwr1WvBdSPuN1ZcARl8gnaujbqetK+zeuBdMvwgRCOgH2QJbaavg0E8Qmj/Ad+EvEWEzmEbsIPLHMl
 MVumGLRC
 QVGCwTCcahXAzYEcLVqG22zxT1ES2KPyeC14CZXoizCCpLcUz+2yqMMANeRJefCUWTnxCSJwniKo1dsra0sG2m4i2417oh9EVDuoJEmqRpFjyG29TJO8HYKGTB0Vw/uf0UTqnEC4CF6HxZH3i3dSopKnxgvnYgErfvq4G/u6ledIrQGlpfMH0KXKIPbTVR14yt33gVg4vo/916ACuD/cZMMWPY8lVbgqXaxwurvHWVP0k6hcFGg95HUiWxWuHsIQzDSZaPd8o2JRVvO8OSxXkB+Lhqc//Ervp2S0o6KhTli929q9DQ1Ksn4ZPHQYUHP75Xl3XW7HoAT6cAYWJi1IbHLVstCLvdjBVMhw+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 11:31:27PM +0100, Borislav Petkov wrote:
> On Wed, Nov 26, 2025 at 11:12:13AM +0000, Kiryl Shutsemau wrote:
> > > diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
> > > index 4f7027f33def..a220a1966cae 100644
> > > --- a/arch/x86/boot/compressed/efi.h
> > > +++ b/arch/x86/boot/compressed/efi.h
> > > @@ -102,6 +102,7 @@ struct efi_unaccepted_memory {
> > >  	u32 unit_size;
> > >  	u64 phys_base;
> > >  	u64 size;
> > > +	bool mem_reserved;
> > >  	unsigned long *bitmap;
> > >  };
> > >  
> > 
> > Again, this is ABI break for kexec.
> 
> ABI break for kexec? Is that a thing?
> 
> Since when do we enforce ABI compatibility for kexec and where are we
> documenting that?

The whole purpose of kexec() is to switch between kernel versions. This
struct defines format we communicate information about unaccepted memory
between kernels. The mismatch will lead to boot failure.

The structure is versioned. Ideally, we should know the format of the
structure the next kernel supports and act accordingly in the first
kernel. Like, we can accept all memory before kexec on mismatch.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

