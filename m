Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75639CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980CE8E003D; Wed, 29 Oct 2025 04:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958B28E0002; Wed, 29 Oct 2025 04:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895538E003D; Wed, 29 Oct 2025 04:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78AD58E0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:48:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EF721A03A2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:48:24 +0000 (UTC)
X-FDA: 84050525328.12.AED4EEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5ACBA1C0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:48:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UTwtpv8o;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761727702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/nrwmmcxPBnnlOaAQxGyOvDVELrUXsiy5HEaGeoqDM=;
	b=Xzph8FNClra512fHU1xPnmp/C6iioTUBzQdLq82+Qo6mp06KHGhDYYIyL03tfhEQYFShxK
	5M29BZHfpGOvX0X6gLFgBHe0FNAt1w8dAXa+afH66GjFl1uCnWmDkqI6fXqob1XmxDWKm9
	hlECxYvDxl/XVuwdWG6qQHBmqmNxSm4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UTwtpv8o;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761727702; a=rsa-sha256;
	cv=none;
	b=eFjNUgAuAv399tLVvW5ntCSMhS0gxm5DnMEzR7vEdm8wuoXisdJJabq0cL+AvgrMBx3egi
	uGlvilZoBRp7jT7dFHyBYE5QEQw13MTG9pBokrEBnqwAJPp+qd5k45DGVZWqvoa1v5JB6p
	eqTtpCwudaULG7YlSFS3XFIgGNkC1Mc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2253D44AF2;
	Wed, 29 Oct 2025 08:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69DCC4CEF7;
	Wed, 29 Oct 2025 08:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761727701;
	bh=8LCr7xd/jmmNjcvpirRO3kvfys/9fQeeVOSR54kjbeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UTwtpv8oJD8EZiajnivSmX6Fc7GX8PIFPB+LboAL/lm5CE66mEi9sRdekgYGUs+9D
	 XgTH3OyTZTg51j0rUaloNpReW/Y88yGWDwFlg5WQGP42MWrytUW4vdgDVDJ+CmGPNL
	 NmOcQqrJ0FTTq8daOxy3FpjwVYRR+pbMENuYac5nBMe92KQ6TS2kCcTx1Z4LFP59YM
	 CzCx26duht1FqOdD2OTYFa03z/JjVS6zsGvbeNswRpEstkEHMHo8g56uIPC1GqDd3h
	 h1/QZmyXKBCdqFGw+6Zuwbv+EZWJx4QejFElSIYzWmMUC+6SdoW1bcoXXa2XTrBf+B
	 W45p2x9UApgpQ==
Date: Wed, 29 Oct 2025 10:48:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
Message-ID: <aQHUyyFtiNZhx8jo@kernel.org>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021000852.2924827-2-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 5ACBA1C0009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f3asqa3tig7as8ui7qbbsbempxemu4wj
X-HE-Tag: 1761727702-486505
X-HE-Meta: U2FsdGVkX1/4oyzLK9l3iZwX6R6XXJnKkrvUibou7A1ofRiG9eeZh+o08g78idUmlTcK9firoFdBfL30QLLytJH+GdK53kAHJRbqiSZOfjq04/0r1l3oegDoyt6aTwsJQom4WJ2jAIbzDjvNFvuIKN6oaT4ywnV4nx4Wjihua02J7Cy/i+IbjLSTP94zulrPMlyrtFxCTtPYyimC2si/nT0llSFEqYmzNcLjjYUrPFt5ig/eKOy2wKtWW8DRtGRx6RfXOmQBzqKYSlB7cSv23dhXSY9X6Gfmm4HiNrFBxkCQHzwqCY/ar43QLmGYcmEiljdU+s9YOv7JgXkX+JSgdGzi6LgB04IfZyXVWf1wM6qdfP+JdrOnM+utJQM+aNQCu99ZXiniUWCyyo505zx0Q8m+z4fTNUq/coTh2zWRkUVH0A5ESju5ujNhbWgQJe9ffty2YKOF3V/sbPH3KiO7v+812qre1Nw2fxz3au0Mz60hr1GumQeR+rkNhqYgK/0RDwYGwZ/4shP0TX0jzwV2PHgjjoyqVUoTs4SBlBYemmhZ53bsUc/yLNRPrLKM48ZkKFFJCg7qssCI+hP6x1cun//LDmUnIyVB4MCBj+Peyi4p01mYiSjdHye+IE8LaGZ/+phnnQR/ZWzd6jJWfkodiaF5l2JcpkqER6tuu6Qi5uVyqITEplD7WpP32D6bxKJuEJ6FAKf73rAUbyksn3zuj3Zns5dRJytZUyW89iTxhAZlBMj51p6z7US3oKXM5yy1C6JT1cJi4yVN8ld57QPuOmd5EDodBwK8gn6kaq8PkjgGEcP2jEuRNHJSM2F8jzOV5uQ45kotuW/1BoAFtgd3CBxJHuHg15EYgWwGiDhU0H5PuzoiJWy7QqeiQKZ1c607vCIBDDw+o3LYnBv5NK5lgE7drsaXvY6quYoT2AC1pXANyMnBL0E3d6RfHgJnz8G8IHgQ9UxQO6SnpHRpDu9
 nrBVJdVe
 jJHoZuitjCyO8mio4oWY3Zk2XyQfcHixeIM1yOCc7OkQYtQ/RsUTemDRGmxMEKMxyTVg/EU62z/ZR1m+M0WUMIT2ZAxngLxS7NA2lJG1htZXmrXMgjo7TCTayGkD2kEM7xJWTE2z5Oiiz1Sx66q6Lsvq/PHJ06GEYwveB9kZU6UIdBYQ1B/FQn0ztQWl4h74HoF4Wdq4Bri331Xsr7HqN6VZqGTlZZEcnhkwjPoFq2cAUC97SoQnrouCtT+kz6214Wd3Vx6T76uQLt4WfMWP5lbfknGqfLhXD3IY3fbv1xu51+4QMC1JxlN2m3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Oct 20, 2025 at 08:08:50PM -0400, Pasha Tatashin wrote:
> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel. This can
> lead to memory corruption.
> 
> Adds checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region. If an overlap
> is detected, the operation will fail and a WARN_ON is triggered. To
> avoid performance overhead in production kernels, these checks are
> enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/Kconfig.kexec             |  9 ++++++
>  kernel/Makefile                  |  1 +
>  kernel/kexec_handover.c          | 53 ++++++++++++++++++++++----------
>  kernel/kexec_handover_debug.c    | 25 +++++++++++++++
>  kernel/kexec_handover_internal.h | 16 ++++++++++
>  5 files changed, 87 insertions(+), 17 deletions(-)
>  create mode 100644 kernel/kexec_handover_debug.c
>  create mode 100644 kernel/kexec_handover_internal.h
> 
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 422270d64820..c94d36b5fcd9 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -109,6 +109,15 @@ config KEXEC_HANDOVER
>  	  to keep data or state alive across the kexec. For this to work,
>  	  both source and target kernels need to have this option enabled.
>  
> +config KEXEC_HANDOVER_DEBUG
> +	bool "Enable Kexec Handover debug checks"
> +	depends on KEXEC_HANDOVER_DEBUGFS

I missed that in the earlier review, should be "depends on KEXEC_HANDOVER"

@Andrew, can you please fold this into what's now commit 0e0faeffd144
("kho: warn and fail on metadata or preserved memory in scratch area")

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index c94d36b5fcd9..54e581072617 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -111,7 +111,7 @@ config KEXEC_HANDOVER
 
 config KEXEC_HANDOVER_DEBUG
 	bool "Enable Kexec Handover debug checks"
-	depends on KEXEC_HANDOVER_DEBUGFS
+	depends on KEXEC_HANDOVER
 	help
 	  This option enables extra sanity checks for the Kexec Handover
 	  subsystem. Since, KHO performance is crucial in live update

> +	help
> +	  This option enables extra sanity checks for the Kexec Handover
> +	  subsystem. Since, KHO performance is crucial in live update
> +	  scenarios and the extra code might be adding overhead it is
> +	  only optionally enabled.
> +
>  config CRASH_DUMP
>  	bool "kernel crash dumps"
>  	default ARCH_DEFAULT_CRASH_DUMP

-- 
Sincerely yours,
Mike.

