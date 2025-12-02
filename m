Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8F5CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 11:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89F86B0026; Tue,  2 Dec 2025 05:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61C66B0027; Tue,  2 Dec 2025 05:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977576B00A2; Tue,  2 Dec 2025 05:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83EF86B0026
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:59:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35B9B8A3C3
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:59:59 +0000 (UTC)
X-FDA: 84174236118.03.C139E0E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id B79831C0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:59:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kYK8mDlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wBzTPwQb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GwtxQqt1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b/N4BDHQ";
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764673197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpPZq1ebEKteQ+9yrfqNhjqVx+GrI8hP1XeJMZZ+U9w=;
	b=gwsm2CHkwK9Jm97INkbIA7WX2gJAOtu3LYr+VWLjw70VWeJu/QJSYW2FVJBWzlDz/JZRi1
	EPBm1qlaDcxW8XR51fwIQYBeQZwVbImPQhd1bJvyNCSGQjd6x6e24LHw3jkiysdjnUlsow
	8qMIk+gWrYGJ4ZBj+zgr07yPnyPudVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764673197; a=rsa-sha256;
	cv=none;
	b=ePSV7p8LfhHKcLWTKsKfHu/C+CFJLujij+RwIsevC1a4UHu/GN4ICvgBx5QNp4uyTf1ubI
	k6e9/tAWMoKwgEbKZXhfbUnb692F1OHIwkn2Pd5bAuUwqw6GkOpadrzo6sLoDUnQHy0ZVz
	I0CmT1YDvLmxhMGq+TjNa34O1wcTZvs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kYK8mDlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wBzTPwQb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GwtxQqt1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b/N4BDHQ";
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EFD35336CA;
	Tue,  2 Dec 2025 10:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764673195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpPZq1ebEKteQ+9yrfqNhjqVx+GrI8hP1XeJMZZ+U9w=;
	b=kYK8mDlXBLzbanglCnilh8EIFD0FvvsnTriZBg4ErNUOb2WZioRd+Tu92hONFfT+fCkuiw
	jt2Rm9Sq/Q+ASdgduKKm15LS39TcIJkdAjkPWZI3kKutIAIP2/rzfQ4uSLjHquXTRGKfci
	TqPuSTL3D1XAQJWR1sSc6kdjXJYC+Ik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764673195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpPZq1ebEKteQ+9yrfqNhjqVx+GrI8hP1XeJMZZ+U9w=;
	b=wBzTPwQbU/PG4I2Boipq9NgZ8SbjMfvwr3+KF+035N55PVSb4qalVsK0ld4x971Bek4XVg
	1JKv78g7g6ptUwAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764673194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpPZq1ebEKteQ+9yrfqNhjqVx+GrI8hP1XeJMZZ+U9w=;
	b=GwtxQqt10Db18f9KoYM4k/bDIR3cvnWfPLfvNrSuwXjzmFMJhAF9CJX7wkhCdTI+Lf/YP8
	HAscpQ7i+Mi7nx1qnfVDOdf7+nzFKfrlzO3HXwJ/hNDdkUY3OEyWTZ59YlI1uGwDxALuBW
	kel8BTiM1yAKEsd0jW62G/H1l6qx4FM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764673194;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpPZq1ebEKteQ+9yrfqNhjqVx+GrI8hP1XeJMZZ+U9w=;
	b=b/N4BDHQKTzZDCfX/+/0MJpJ+FccmOB9VpHaRQ1X2FGZ8AirDaqjq0PSfuTgc/bQ2mTHDl
	MxagHneD1QSnMCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E157A3EA63;
	Tue,  2 Dec 2025 10:59:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RdDNNqrGLmnNNQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 02 Dec 2025 10:59:54 +0000
Message-ID: <127ca65a-bc74-4554-b0bd-f75ea2d099bb@suse.cz>
Date: Tue, 2 Dec 2025 11:59:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mm_init: Introduce a boot parameter for check_pages
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
References: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B79831C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ryjmdsont46x4oda5nziae4o1cmng3h4
X-HE-Tag: 1764673196-845449
X-HE-Meta: U2FsdGVkX19Y9GgukGDnFCIoLQ7fJ+DhJfa4b2gKmvWnTgMTjehjhSQRgO93cZ5o7zs198dTBlKJLllCexrmyqm7AUeSxI03g/Mv845MjrOtjAov7G6KnRKKuA3KdXx3Q1g7gKU+DFsgoxXSlwTaHiZ5OYYXf36JjM3VSO/HsN+sSPy7I3AGHyExqS1YmpNBXEU3tudIyt8m5zL7cK+h1uKwLV6JLQUmYp/sPQpQNj31+/2jkWawUe5wQ0VUlAzMAtWJLK8Ihe7CR0CendylFwGoWgwScUiK1DQ/mvzBZG02vD0xKyG12/od7S85j/+G2j+QiC0597Gu1hEx6qaHCIdCGgHFx+Neuy1yPvdmWj3caju4rN7Ti7zsA70AP7vk6c7L/zLPHQBtDcJ+yV9XDvNckzdyKSG9nZ25A0S8419M4O5W8jUsBDjZKH1laDY62iCbjtiOLxCj3pVJVBcpomCGaLJPEowLAWvP2TtFm1H4JmfWkNmiZmhPcjvrQbNvrxxvvWfdPFU6jNEks/Xl6KKRrCiPGtUxAdL6CpbcWt7bHbl8MFkTusUJK+QuywpII4SHICBXNx7mILK0soHmQBoiNKbNuD0JTZVFO7RACTgVe1nmOKA0MQx7RuM9x1wp97RfM7232zWd5aS2xExXp8Vd0M9opPMPzwKA7P0+N7IpsfZvpgLLjf5pSlNKYajzmp1tkJIjS+oqsVqedb0iWDn+YcbXgcri8X09GTnDhVllng7Mem2M0pVL5Bd28wJybXJXn7uCdTBLAyuTpVmGyUyO9o2LfvnZJW6g4A7OZ3aj6okngHavSC4WJxRuzha4RVWwE/I624C3wNVu9rZRT/UnF4XbYE6FGytwAHsIuu1b6uR4nuPVKzy5md/LEygjOQTjRvo+vJ/XpFHR+Tfi1jeZ2TzlsSgzZ+T6bBRrlAgSCuR6bxf7/N45j2SkLqJZAviYnTN4HoHVXm6rwGL
 ok7DmdEu
 IOZa/X5B/BZqGN73sedOiAoBPZm08De9XKjuk+lnBwPHkIBNyBarvAQ3RfJkxP1X3WeRnhVtS6mMC9L5S6h0/OB3IKLP4cdst0Vrn6XTXt8f1+WzdnnzJL399/LLi+kSAy937vveNdj6SYA8CJtB39HB0wz9XmErc/rS0utuenCaDbgLJ72osLDN6Dk4dfIFGivXfEyRYLyyH+d+B5N7lnw/zxLQIi+Cny4R+HC+gm2Qz7nk6Qq0ofGJYY+78kMPrGCQ69tNMQ2kW8U/RMsgrN1NGlANHx0VVwaf/NGa3cdYjqpOVPFT1gSTW44eQcf48X26I+Aw37OlWBoIS6m1ri0KO4uHRAMeABq9ie3J+QlxkJQ0vEJ2z0/C3juhOb81QYxTG+UaQWQCUCZE7hQXmP916vdGMCxeTFlvk+xJGZccbN7S5nDU76Z713KM5WaQuEHHzsl6UEkpfhLAwflpcAvw/BeqTC7kX6NpYZrLygqxyWzeh8WwdpIl4msrtXBz8/Hl9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 7:07 PM, Joshua Hahn wrote:
> Use-after-free and double-free bugs can be very difficult to track down.
> The kernel is good at tracking these and preventing bad pages from being
> used/created through simple checks gated behind "check_pages_enabled".
> 
> Currently, the only ways to enable this flag is by building with
> CONFIG_DEBUG_VM, or as a side effect of other checks such as
> init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> These solutions are powerful, but may often be too coarse in balancing
> the performance vs. safety that a user may want, particularly in
> latency-sensitive production environments.
> 
> Introduce a new boot parameter "check_pages", which enables page checking
> with no other side effects. It takes kstrbool-able inputs as an argument
> (i.e. 0/1, true/false, on/off, ...). This patch is backwards-compatible;
> setting CONFIG_DEBUG_VM still enables page checking.
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

> ---
> v2 --> v3:
> - Dropped the second patch. I may pursue it at another time : -)
> - Variable renaming (dropping leading _) and cleaner check in
>   mem_debugging_and_hardening_init, as suggested by Mike Rapoport
> v1 --> v2:
> - Changed check_pages from a build config into a boot config, as suggested
>   by Vlastimil.
> - Introduced the second patch, which decouples page checking from 
>   init_on_page_alloc and init_on_page_free.
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
>  mm/mm_init.c                                    | 10 +++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..acdc7fbdecac 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -669,6 +669,14 @@
>  			nokmem -- Disable kernel memory accounting.
>  			nobpf -- Disable BPF memory accounting.
>  
> +	check_pages=	[MM,EARLY] Enable sanity checking of pages after
> +			allocations / before freeing. This adds checks to catch
> +			double-frees, use-after-frees, and other sources of
> +			page corruption by inspecting page internals (flags,
> +			mapcount/refcount, memcg_data, etc.).
> +			Format: { "0" | "1" }
> +			Default: 0 (1 if CONFIG_DEBUG_VM is set)
> +
>  	checkreqprot=	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
>  			See security/selinux/Kconfig help text.
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index c6812b4dbb2e..fc2a6f1e518f 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2525,6 +2525,14 @@ early_param("init_on_free", early_init_on_free);
>  
>  DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
>  
> +static bool check_pages_enabled_early __initdata;
> +
> +static int __init early_check_pages(char *buf)
> +{
> +	return kstrtobool(buf, &check_pages_enabled_early);
> +}
> +early_param("check_pages", early_check_pages);
> +
>  /*
>   * Enable static keys related to various memory debugging and hardening options.
>   * Some override others, and depend on early params that are evaluated in the
> @@ -2534,7 +2542,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
>  static void __init mem_debugging_and_hardening_init(void)
>  {
>  	bool page_poisoning_requested = false;
> -	bool want_check_pages = false;
> +	bool want_check_pages = check_pages_enabled_early;
>  
>  #ifdef CONFIG_PAGE_POISONING
>  	/*


