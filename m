Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2FB8606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtBKFY07
Received: by kanga.kvack.org (Postfix)
	id 9FE7B6B06D0; Fri, 13 Nov 2026 06:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFD16B06D1; Fri, 13 Nov 2026 06:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D906B06D2; Fri, 13 Nov 2026 06:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 642556B06D0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:26:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F26DE140266
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:53 +0000 (UTC)
X-FDA: 85429868706.08.A69C1CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 47CC3180002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtBKFY07;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794569212;
	b=cdjvKanTRd6QUCuAY4kLMDYinOTgzquYdWmVxKptegE+XlPovTmWFNdVZcZocRN7CrVVun
	+LVBO5yInKyrQqDA5bLn/z8atbIf1zdn4b9W3QsuC0ERLgk6g+3uqyrP/Nbc1KN5GZJS0z
	i8OUNBpT87DgVI4upn+DQOoE+8QgDZU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtBKFY07;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794569212;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiUyDGvyJZYcarOEG6jgNk6cI+3HgzA5UHXjxD6ye7Q=;
	b=D9rFuRrnDQt6ui/ltkBp24yzggptzr23t1P/Zjlp1juoJL87VglPIXJxTGJ6mGMz4IBZvf
	LCld4S4ulLtLDoy30Q5muWzdp/Oq92Z/o84e9JgEa9BneRV2GNVZA1qzvfDRarlPWgZn03
	rK0Kwuw5PW++/3y/1V5IChB5kPlMdQ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B96A9626EF;
	Fri, 13 Nov 2026 11:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B203A1F000C9;
	Fri, 13 Nov 2026 11:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794569211;
	bh=tiUyDGvyJZYcarOEG6jgNk6cI+3HgzA5UHXjxD6ye7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WtBKFY07TfFOGI8cC1iNRsjDxmyO16QY6swnPdrpayO98nGEczEVRhy0ZZe0/AV3c
	 t6H/qbBhXz6mhA6Aub6m0NLR73R1BSua+HmAzZlTw9nwnYvLoKOruA5l51tAEye8VK
	 AXfGq9tKsI3pfs6Pm/3joLDlrqsSDNJkHehQPWDIN7yBEyKbRgRUHuw4xgJ2sf1/bZ
	 8dtIiEN80CTtv1Rp00FjD2sKBNXwdkYUpISJNUjkcsskw4cY48sikVsd1/raNX/N49
	 dBxD9knUyiCXXaotAsImJ6PbWGoETtjh32AvqyT9ki7951oI37H9Q9SX2ukK01cLuL
	 7a1hukkOEn/uA==
Message-ID: <sashiko-outbox-212715@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/6] ARM: remove support for highmem on VIVT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Andreas
 Larsson" <andreas@gaisler.com>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Linus Walleij" <linus.walleij@linaro.org>,
 =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Richard Weinberger" <richard@nod.at>, "Russell
 King" <linux@armlinux.org.uk>, x86@kernel.org
In-Reply-To: <20261112112528.1116405-2-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 11:26:50 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 47CC3180002
X-Stat-Signature: pbnhh83e4ka8jzmyymwfatinjr17qc34
X-Rspam-User: 
X-HE-Tag: 1794569212-339851
X-HE-Meta: U2FsdGVkX1+qFmXhPSwL1/eJumEeoa839SfAaxePghmBTsLMoecuFH4nDQDQUlPhnhI8Qhxm7Y1IjtiN6W2pJmDF3GWKYTTkL13pE05OGooqOTKTBG4vgfbX1pSZytXTEftUwtzU6i68I1nfmF37d/n7iIBH6isaEa91S2FBslfj3Cvs3TX0cImVNzwBh3AnZfFfM0MOYaKiPZ10MvW/HKgYZ9ZVK86+c9wc2EiFWXS2ydGe4NAjuE6bHKNwuIMoT8xtfyDNP+te8xNsj/OrSrI1HNLHdIiBUzkNBuMRDtWPWOSLL3KEGfGB03V6OpAv+HV369dU9cCW0frZbRiXyWD69XuhjSf5JzAZJY2EtS5kFfeBvTpsogcLJq6fNngGZDAvVOT/7tIVb5B8MGS4uDOEqE//QxlRvo28+p5xldEK+46sW9W78cUJAJDv6oqJatgILvsE8O5yWEIbC7dWYz+cu0Tig69AMUGnq6X9a560S9+E9tDrCSOy9QEvIAzoRQ5q/c76ieBH+9L8p6lLJxLbWGueBo68DbIrIfA+H+u07A/UwoXJbWQtQb2cwHTWCDiCgP9nmJYISuff3wnAOiq7hpRzaAIaZMZgEOfhUcAHfw1srf5mNcOuKCfF/o1BLi/577IvK3l138RqVYbJ+vh2fLDroYlpU7lZWZh6W3XAsVhx8675hHiX8yD2BECt3PD9tDjmspeH3qSFQhwho9dDRmKDRoiY3esrhhOMkdR/V5tMpItwDBoQ9mijTWEkBJSZWrzuE1JIf4xBC/hFWu5E3cvRfdT138H1dmysTGNbsGIDBBwrQTCug2zOOXK1a4cbzywrxv98vovtWPzCI+Q+qixx8zJcT+RsWooVvU3lA1KoJQ21MtgVBLxQCjYr4iFYUqLD+z+is4OMxF1PnxtrMDH5YYgWnfuIAMdUcri26TYjUw69LnMnNEZuzPWWZsdIJNaWl20DZX+bVCC
 PLB8gqeG
 tVmoN9HFTg8MHLmV7Z+N29PgDtyz0jsWeFrIhWJBDdgRAswWqP2gARPJONuEXUe5CYvKrvM9OY7YnYVR1CMRwuQ/Szb598Chw2J2e1d6BIF8L40lc7+Ro9jtxO3BQFmmP+XaIvuBKHK906lumtltgKRgy0PipKhThT35EKaiKFKpmhpO8ZAo5ckzJeE5bB6bIl1eDjn3kcZlzyCNa996WM2buO3E8QCYvu8W1dcH5iNNYx07fBxc3eBNkAVUipCL1blvOfBFahC4nIkei9Aq8v0cV/nykvbakgE0WpKxLs9nCuo0TCXMjx+8PBVl7Z1uji9Qx4cqw/GUqLgZpFV1mGu/ZIgwBaiutfS1JD8P5bk5WYT1dxsgnIHPdETgKB3W4F+6CHKxT5rZ2QwVRLiqs/sb6/rC5IV+z0nv4b0qlE1A9QczqKKyaSlY7GZZILMamDwG19JspVhTDbI4uHQNDHb1CGJnODouULQBmcjRpN16JaK/L32VkOXIhktr5l8X69/Gj43j6NSVKFsLguvIvIotgiJw4C4dTK1d5JoPLu5qer0yHVWTQKvxny4ZK7OtJKuMC9ZA/nzM4wt1CbOqb/3B1eQxnmdt2X0T/IdeoP/2HPNSWot7yOgoiMpYiQyG/XseibIIPGnMou/IsqP+AxJkqeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ARM: configs: mv78xx0_defconfig retains unreachable
  CONFIG_HIGHMEM=3Dy
--

commit a6e3d614ee0118d4a0f2639acca9b5620bed4dd2
Author: Arnd Bergmann <arnd@arndb.de>

ARM: remove support for highmem on VIVT

This commit makes CONFIG_HIGHMEM depend on !CPU_CACHE_VIVT, drops the
now-unreachable CONFIG_HIGHMEM=3Dy entries from VIVT defconfigs, and
removes VIVT highmem handling from ARM cache and DMA code.

Link: https://lore.kernel.org/all/20251219171412.GG254720@nvidia.com/

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index ffbc7f3861315..77614080f317c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1210,6 +1210,7 @@ config ARCH_SPARSEMEM_ENABLE
>  config HIGHMEM
>  	bool "High Memory Support"
>  	depends on MMU
> +	depends on !CPU_CACHE_VIVT
>  	select KMAP_LOCAL
>  	select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
>  	help
> diff --git a/arch/arm/configs/gemini_defconfig b/arch/arm/configs/gemini_=
defconfig
> index 5860b2fe7d1fb..95debf46581be 100644
> --- a/arch/arm/configs/gemini_defconfig
> +++ b/arch/arm/configs/gemini_defconfig
> @@ -11,7 +11,6 @@ CONFIG_KEXEC=3Dy
>  CONFIG_ARCH_MULTI_V4=3Dy
>  # CONFIG_ARCH_MULTI_V7 is not set
>  CONFIG_ARCH_GEMINI=3Dy
> -CONFIG_HIGHMEM=3Dy
>  CONFIG_CMDLINE=3D"console=3DttyS0,115200n8"
>  CONFIG_PM=3Dy
>  CONFIG_PARTITION_ADVANCED=3Dy
> diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi=
_v5_defconfig
> index a0d2fb2fcf9a8..bc34b6026e377 100644
> --- a/arch/arm/configs/multi_v5_defconfig
> +++ b/arch/arm/configs/multi_v5_defconfig
> @@ -27,7 +27,6 @@ CONFIG_MACH_D2NET_DT=3Dy
>  CONFIG_MACH_MSS2_DT=3Dy
>  CONFIG_ARCH_SUNXI=3Dy
>  CONFIG_ARCH_VERSATILE=3Dy
> -CONFIG_HIGHMEM=3Dy
>  CONFIG_ARM_APPENDED_DTB=3Dy
>  CONFIG_ARM_ATAG_DTB_COMPAT=3Dy
>  CONFIG_CPU_FREQ=3Dy
> diff --git a/arch/arm/configs/mvebu_v5_defconfig b/arch/arm/configs/mvebu=
_v5_defconfig
> index dbc6c511e70bc..5adf6c75304eb 100644
> --- a/arch/arm/configs/mvebu_v5_defconfig
> +++ b/arch/arm/configs/mvebu_v5_defconfig
> @@ -13,7 +13,6 @@ CONFIG_MACH_RD88F5182_DT=3Dy
>  CONFIG_MACH_LINKSTATION_MINI=3Dy
>  CONFIG_MACH_D2NET_DT=3Dy
>  CONFIG_MACH_MSS2_DT=3Dy
> -CONFIG_HIGHMEM=3Dy
>  CONFIG_ARM_APPENDED_DTB=3Dy
>  CONFIG_ARM_ATAG_DTB_COMPAT=3Dy
>  CONFIG_CPU_FREQ=3Dy

[Severity: Low]
Should arch/arm/configs/mv78xx0_defconfig also drop CONFIG_HIGHMEM=3Dy?
ARCH_MV78XX0 selects CPU_FEROCEON, which selects CPU_CACHE_VIVT, leaving
CONFIG_HIGHMEM=3Dy unreachable there as well.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112112528.1116=
405-1-arnd@kernel.org?part=3D1

