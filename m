Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D93D358F9
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 10:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DA06B0088; Thu, 29 Jan 2026 05:35:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945C06B0089; Thu, 29 Jan 2026 05:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847FE6B008A; Thu, 29 Jan 2026 05:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72DA86B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:35:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48A1016040C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:35:32 +0000 (UTC)
X-FDA: 84384644904.05.B371A12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 26F2C16000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:35:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGm+Pe5L;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769682930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt/fJrEfptWIMl6gJnBgyhZ2v64WL4kEDwxRsPYbGlM=;
	b=w8626fFLGupyfPj8aBjSMOwwml0IeojAKwBAVFOJu/QehD938OQC6JLMQ2AY18gmaOwe7T
	yC/79iMN6pSHNpCbhDet6rR8Yh6PKq+MN63SAufvaMebNshAzM26jkmDGlubdhjBxJ1rWC
	IxdZXyQvCDtw3icovDyXNNtAJtBg5PI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769682930; a=rsa-sha256;
	cv=none;
	b=Mhi7taN/Yb4kLbI9tevpcmnVZ4dv935ELCz5mr4xFlgq/2mdEMFWV8k5GPBkvV+GvlfFj7
	NEV66D8yFdytiGqvPo8Ze44hqG70+PLEhlN/eJYCYRvZTTzYpgLZGq0oTpwQXWwBK3tU0Z
	CR5jMIAqq/pl80503p2uqBA6c2xoGGk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGm+Pe5L;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8B3C44262;
	Thu, 29 Jan 2026 10:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F97C16AAE;
	Thu, 29 Jan 2026 10:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769682928;
	bh=B7t+HX7cNhdeA2zHoB8ThQ6BCCEjOkvXW+5RQmoXcqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGm+Pe5LVrS1PH26EJ06OJbvCkYSjmCQAQZi9v2MpV1ld6e2sLKst4M+MqyMvgIYS
	 qFURRvzfYva0IqejrqLqhVJTphOz4DaiFLYx2fy72WrvQ2ZjTG8ZgsWMWM7d5TMQVV
	 I8rlMzuAZwxNvXEQ5bUa4GN8gnMz7cLiHiHPW3gtfFt8cmh0Ra38xu8+wkAz+ygmgE
	 kBkNV5yh7ldmTIORTrOEQewRueaVs602d0Kk0ckQTJWci7nUoMkANoZkGvPgZSZ1BY
	 TCq+5o4DDG5mviyrWmTa7Qw34U2Dh9IRoznrCiW0pLY39o01poMq7PpSzH2jfAvcWm
	 wY0H2bRr49elw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4B707F40075;
	Thu, 29 Jan 2026 05:35:27 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 29 Jan 2026 05:35:27 -0500
X-ME-Sender: <xms:7zd7aWQJIlX8xOpb0kie4rT16Qk1y3GzYJWoOJaYFH279eSUu-yz2w>
    <xme:7zd7acjgkHUISUSxBOAYvg0ACK-12IlSUtj5HajaTpOj9PTe-YLEyRSwsTQItoRyo
    e4OFTcM4M_87wkApNTragA0rp6a_I21i5qVR8Rks5J_B2IdngLHzBI>
X-ME-Received: <xmr:7zd7acuUyA6shq1QXasNuesRZEluwD8lmK27JJ5o-ojX2trXs2zMiR40DGWtog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieehleejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:7zd7aZ5S2PtK8kE94JZRSTnBS8HuW9UF_Qt30LmF8-RuV0Vw5LhZfg>
    <xmx:7zd7aepjz50WxJBcHBoKzoi-w8Hrs4p9jcbqVkSnGBYYX5RRcNi6MA>
    <xmx:7zd7aVc23eMBzgziJueSlmU9gfPoeexdkR8_7cHNmUckjb512LujWw>
    <xmx:7zd7aaIHC1DIYHwFrhQrOFkcu9-raY4Qqo0-_nV7V_heWN1NR1sUzw>
    <xmx:7zd7aXcBWU0tMq_Su0hEacRzXc6HpK27MXmIWeJSsHwsR9oWHj2EeWa_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jan 2026 05:35:25 -0500 (EST)
Date: Thu, 29 Jan 2026 10:35:20 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v3 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <aXs09b7Q8wmHMFNQ@thinkstation>
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-2-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128204105.508855-2-prsampat@amd.com>
X-Rspamd-Queue-Id: 26F2C16000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qraxpjdoybxt8m8b81q6hws1ufzfexk3
X-HE-Tag: 1769682929-66887
X-HE-Meta: U2FsdGVkX18Th78pWmPvoKHJ9Hd2vGq1JANxakEzLRd2W9nlqsMpdp9kCYPNCHkiJAEbWUyt5kQAieHPMiIbKm5wQ+S37fqlnGT4SC4mX84tgERUaFoBGYBj0uITHslTQCQusE897FjG5oCIDbx8wE+MRBPHuzY8E/tpYe0qT1AAkXCTnhH4dQweRVbmyKJJf9a13jNKjMVzu/vXbSyWiY+hn48x4/TS4tZ7BNZRXGg4zeaXrttXcU3Yq8tRjDprNLDYJQadTaEv570sfuHJBm5X3Mjo9hPPjWfPSu9BIPMghW941SY/9b18OZ4St5iIw1+bQ7WMvb+my/kPwvn/qDEzL+wY+ZR4FX5ZnpTODPxFOmDn4hl4KzG85j/jMgj4a7fY/og4ad3T1BqsN6QO/ziOXJqGfbp0Aq2ygszXAfZitiu5dzeco61IQVfKvyYnPLSQUYXHKmfFLs2QeDXbRIX7q+FxCrToMdajjVm/9w6ObiHvyDLyDAdDO3lv94qHU/SV2tntZxgqbfkLxDLTmHxE6tR/xUACczH8/XBk5bb3h+76JDTPppufAR23rUNIf1AG6sG9sKmKjA1879urODp1YcATH4+Xt/rWfl980QMrCPaTQSZVWWdrxm5cPm2ER7+BfCzBW0zUR4kLK+75DbY5twY/SXnq7XI78zuHolhGONR8+y1hlc/Fd4XGlH+4/Z5C6zr/dsHAm3gsuec+LWea4gGB8HzOzt3j7hRe0X1DaLCvO0r1dz6b14uAkb46YUGL4YPoK3kvPIi2y9KplN4ffBJcSpgna2G1/Kvz14CIIDr5vCcEkC3U1V9J7iKdjQzIi5ZyWCtj0hrSq4O2FDZUSPO6N9Gcyj4MMXRH/UCcDIKABmnA6lYLyKRdLw2WJi2bSfl5kISsWxJglUp5OBCLKcWwL9cjG3KCgzgBF1brRKlGXG0ndZeHruaVGw73IdO1VlPMT7xgWBfyIch
 rz1EPIU3
 rleP22OXjsiJ9uoZ0EMHJMyzrLMKqdqzYiULEsy79qBvnrEeU8+MaObVeyqkf7qNfIzNmLIb4OMDK31F3QmyOX27EGDwLPAuD4ovK7CMGbCBfDfLkT8oFfZt5CdbSA50bGcvWaxz/CpTXR7p+FMZwv8YMOTmry2rzgMWkzWyOcJLqgl1jfWVsp3PeCumlpQDcBr5dW5q91nQ+RKwuNBS+LDbG9sZDUmg+c/AzMm4XmgVLZILeVhUothjLMDc13hnZkEqM6xIBVOGwAP97nYqXw/Xer6F1LUZY0hdpVs9YbI5bX8nQeNdXqEYKj6BRowG3vZsrk145aJHDFdNi5HHZvOdElO75jmwkki8o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 02:41:04PM -0600, Pratik R. Sampat wrote:
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
>  drivers/firmware/efi/unaccepted_memory.c | 18 ++++++++++++++++++
>  include/linux/mm.h                       |  5 +++++
>  mm/memory_hotplug.c                      |  2 ++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> index c2c067eff634..5a4c8b0f56c8 100644
> --- a/drivers/firmware/efi/unaccepted_memory.c
> +++ b/drivers/firmware/efi/unaccepted_memory.c
> @@ -209,6 +209,24 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>  	return ret;
>  }
>  
> +/*
> + * Unaccepted memory bitmap only covers initial boot memory and not the
> + * hotpluggable range that is part of SRAT parsing. However, some initial memory
> + * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
> + * that can be hot-removed. Hence, handle acceptance in accordance with the
> + * unaccepted bitmap. Otherwise, perform the state change for the memory range
> + * up-front.
> + */
> +void accept_hotplug_memory(phys_addr_t start, unsigned long size)
> +{
> +	if (range_contains_unaccepted_memory(start, size)) {
> +		accept_memory(start, size);
> +		return;
> +	}

No. This is buggy. The memory has to be accepted regardless of state in
the bitmap. If the memory is ever unplugged the bitmap state is not
relevant.

So, accept it unconditionally and mark the memory accepted in the
bitmap.

> +
> +	arch_accept_memory(start, start + size);
> +}
> +
>  #ifdef CONFIG_PROC_VMCORE
>  static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
>  						unsigned long pfn)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..2d3c1ea40606 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4504,6 +4504,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
>  
>  bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
>  void accept_memory(phys_addr_t start, unsigned long size);
> +void accept_hotplug_memory(phys_addr_t start, unsigned long size);
>  
>  #else
>  
> @@ -4517,6 +4518,10 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
>  {
>  }
>  
> +static inline void accept_hotplug_memory(phys_addr_t start, unsigned long size)
> +{
> +}
> +
>  #endif
>  
>  static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..549ccfd190ee 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1567,6 +1567,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	if (!strcmp(res->name, "System RAM"))
>  		firmware_map_add_hotplug(start, start + size, "System RAM");
>  
> +	accept_hotplug_memory(start, size);
> +
>  	/* device_online() will take the lock when calling online_pages() */
>  	mem_hotplug_done();
>  
> -- 
> 2.52.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

