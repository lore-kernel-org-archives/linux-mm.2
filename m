Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 153F8E95385
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD776B008A; Wed,  4 Feb 2026 06:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B536B0092; Wed,  4 Feb 2026 06:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A326B0093; Wed,  4 Feb 2026 06:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 233566B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:22:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5312D56F2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:22:47 +0000 (UTC)
X-FDA: 84406536774.22.E987820
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AAF97C0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:22:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PUXU4qbr;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770204165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iOfjMvdSX9wYIVLMns6yxQ+qZN1af5L7/jjD+Lknf0=;
	b=woCAKQF2MdCgxMfHcxE5dztJ4S93a8PvXcgNHpjxe8tQAry3ZeyQNERj7VMl3V8InhytHi
	JleVyi5YH+B0LAEQzyrgU4I19EKn2DjyuwggIRWH97c7oCRA4xjo6U3u13oUc7joYa03GH
	7EArz7zqjmmJWmoHKgjx+2p3YoKXaZ4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PUXU4qbr;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770204165; a=rsa-sha256;
	cv=none;
	b=n+mmwOESu77kTJwymFGDfjKLLrYJbDD/bj6JBBFKBqvVFPE5BRQZvwh+f6wv4ZWiT+99md
	kKMC3chtv0r7vBKqRxS5Q4c1yAOcrkXpwW2lMDY+zdzsoeSggoJ5awxdYzay0f8JWzq7E9
	mYMPWi8N5EMQdkn9BzFpecDu6K3zeI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B19B40BB8;
	Wed,  4 Feb 2026 11:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5A7C4AF0B;
	Wed,  4 Feb 2026 11:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770204164;
	bh=BJIDXXgBuKxRtpxYGYjkSIboKZRBz0aB2ToXuvdwHfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PUXU4qbrT3jzzDesvgUaNyGjY/3Fz9r72nTElF8l7MooBGYwo+p7AQ5u2o11tb2L9
	 KhTHkQZV79AmyjoGVpv10zw7Mpuuq8qLCXTeDeXpeaAc9OnVZEr1gtFxLTXXrbeiQJ
	 RJg+XDSdIdQFD/jyRW+I+vAJNoWtFz4x2z6aDUwZJyFnC5lz6xaiTdud9TFXPO2/dc
	 Z+QpST3IvSt45ihQE/yCWZtDBjDVA379pb7YrQjgFE1NhwBfFeBDy3F3a2/ingvgdc
	 Swk69IZDawVQUhFnknf4Qn0ZACJXVp7fl9akV7Zsrx+yOna8pw/5n8Aj7lTCpwVOAf
	 bnyq+lbfXxkaA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E2C4AF4006A;
	Wed,  4 Feb 2026 06:22:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 04 Feb 2026 06:22:42 -0500
X-ME-Sender: <xms:AiyDaUL3F9n3DNPjuSDCd23uY22UkYpDhwpKL_T79q6pms2EIOMZdg>
    <xme:AiyDaU6cpGU6s6dKLYN8uHo_xbrD0Ivb5ANIwCiD-ncsaeYfOmf1WGkqzL55nV4LN
    a1yAeLkQbEyZEqcTTYtsZZDG58gjNJxS92OPTvHnn1-9qi4zcc0sNI>
X-ME-Received: <xmr:AiyDadnQMRWXBPIxL__hR2uQ_TjXXNeXMKT27Q1EHYDWSB1_bXtmRH39xPwnDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukedvfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:AiyDaZR4g8P1oPcROqQ2WPtnhXz3ACGkzlh5Gj8bU76LM8SqByRTdw>
    <xmx:AiyDaaiRkbjWP5pqUymNm3nSmfvZ0VrcGwTlaiLW1C9mRtydAoQgGA>
    <xmx:AiyDaT1ky6zD1is-cSozOnwrJqSSWgk6DRPLqMM7cv4PIB2ShqyIhA>
    <xmx:AiyDaZA2uZ5pHL3_XQDkheAP42GKjwTXMpDfqg1_aiUiVelE4qJhPQ>
    <xmx:AiyDac3QFPOBI_Ph4m9-sBGH2Kclp7CQJXruc2UkM9egc4Ie8vHbb7B3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Feb 2026 06:22:40 -0500 (EST)
Date: Wed, 4 Feb 2026 11:22:35 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <aYMjjyVVax5cml9B@thinkstation>
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203174946.1198053-2-prsampat@amd.com>
X-Stat-Signature: ewuqhpuo3jxfiqytk4xhrk8fmnybx4us
X-Rspamd-Queue-Id: AAF97C0005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770204165-416010
X-HE-Meta: U2FsdGVkX18dYA0PuyGUKxmvjxh1ptHWJmPUQhDHEa9GtgqrbxGHgG87HmRTfWZasVeu26o/+dpwH5HhlEXkxeDjhUpRE7TEsvnb89gH34OBVu2xKxkcrJtBlxe8tTnbXb1K65PQN0bhuUiNnSHAj1DjouaCtfjve6xRB413VHijRl+OrjYGNIpa+GdLAvHDehv0OkryyJFzoI50SrncPThxTk/+gfmONQ+PJwZvYqK9HCY5QZX69fvNrmSciHHIvwYfXqtllr156ocIV8UcQOtjKdk94eD7OLb+kQRihKqsSa7uCXwMfZwW4DzL+kWeOplOnZencEnZGdTo17l1yGMr9FaadbJoYobz51aW+hAIfQtuVh7CEkQRK6Xp517ju+FYEk1HPQPJbnj5AuQ76vOAM6p4ZWW2KTl4SGw71CTkFlAbJPBF6qA4dO+qxuNiNepftOPB8il9kDeCgw7En24rsGXf5DaB1iLJs7Eir6rgA/g7kTJBVm2rLimhi7rnPnifzmI17visPbERpq2p/F1rSa7wqSSuVMnPZ1vOUcYDgVSgC+BbdGpXRMH6faBVLRXvunmGY7eNmF0sMLKrKFeE5x4YaKb8LNVlvf0xy824Y+GwcI3j2LcV5PPJzW4kNrg1UFp1Qdnvvr1kyA/vSDFTRx6vCRbEAD9jM2H4mu+nhcC66lPOE+i2rNfMHcrzKEiqEvenCOwSIE6dsy1ufYDJylPPcQ6QmZaRCy9IEE44LZAutwiPjebfRHpMtXmqFd+vAV2R0J5Tz0cUwWqWjRFe+PQfPpbaAZQ434/sfKhbqyat9DRZIGUv/fmKzvMMbOzsCehE5kp7SMyZw/q66vhyPdk2OcV6BSnavbB8h2Ky0Pb/CQ9TRFe46Np6DrNa27gW/oagGL/0QI+VS4rWD9pCXXkVOfr6c38AhxoTHoCIRj+9NsfjJaxUZ6ADiUirorUd4WNhwNMcqUb1DlA
 HySyna0F
 v44UDwNLDjcSo8F+hSQ4s37e84Z5HhUT7In5JMmt4azXiU2qdqZduaU5TKOOwDKrYbeV+czU09f/PU9SrRXLRsUcdsR3X/oAJgQMhxP1aSwfdmSbb9MKTTdst2nyRUqYHh6NTO+tKWQ2Ytmz6hZ3YwiMgGG5ZR4Ki1npfN5s3nydr/EAu6cctvs5Np+hz4WEOCml+mFDsRZNJePj1T4W59BJ6KBBSsi18pGial0lx55NfbVn85i3PNLW3oy8qVRxGwa6vDvw81GXGwKQgP4ersX1QOFovURhgzQlcT8pY+Q3j0MccYKLW9Ked9AIDYNE9MYR+WG8cUklRbic+A9h0tR7gk6U81ReqALBm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:49:45AM -0600, Pratik R. Sampat wrote:
> Confidential computing guests require memory to be accepted before use.
> The unaccepted memory bitmap maintained by firmware does not track
> most hotplugged memory ranges apart from system memory annotated to be
> cold plugged at boot.
> 
> Explicitly validate and transition the newly added memory to a private
> state, making it usable by the guest.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>  drivers/firmware/efi/unaccepted_memory.c | 47 ++++++++++++++++++++++++
>  include/linux/mm.h                       |  5 +++
>  mm/memory_hotplug.c                      |  2 +
>  3 files changed, 54 insertions(+)
> 
> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> index c2c067eff634..359779133cb4 100644
> --- a/drivers/firmware/efi/unaccepted_memory.c
> +++ b/drivers/firmware/efi/unaccepted_memory.c
> @@ -209,6 +209,53 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>  	return ret;
>  }
>  
> +/*
> + * Unaccepted memory bitmap only covers initial boot memory and not the
> + * hotpluggable range that is part of SRAT parsing. However, some initial memory
> + * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
> + * that can be hot-removed. Hence post acceptance, only for that range update
> + * the unaccepted bitmap to reflect this change.
> + */
> +void accept_hotplug_memory(phys_addr_t start, unsigned long size)
> +{
> +	struct efi_unaccepted_memory *unaccepted;
> +	unsigned long range_start, range_len;
> +	phys_addr_t end = start + size;
> +	u64 phys_base, unit_size;
> +	unsigned long flags;
> +
> +	unaccepted = efi_get_unaccepted_table();
> +	if (!unaccepted)
> +		return;

This can be tricky.

If we boot a VM with <4GiB of memory and all of it is pre-accepted by
BIOS, the table will not be allocated.

But it doesn't mean that hotplugged memory above should not be accepted.

I don't think there is a way to detect such cases.

Your check is probably the best we can do, but it means VMs are going to
crash if memory accept is required by no table.

This is ugly situation.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

