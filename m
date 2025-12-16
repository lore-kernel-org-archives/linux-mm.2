Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D5ED5E14E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187FC6B0089; Tue, 16 Dec 2025 08:25:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131C46B008A; Tue, 16 Dec 2025 08:25:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E706B008C; Tue, 16 Dec 2025 08:25:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E37C36B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:25:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D1D68B2EF
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:25:13 +0000 (UTC)
X-FDA: 84225405306.27.FC748C2
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf22.hostedemail.com (Postfix) with ESMTP id 485B0C0011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:25:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZmXqtNke;
	spf=pass (imf22.hostedemail.com: domain of "prvs=438402146=epetron@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=438402146=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765891511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Owz+SqmUbMxEza/nbiqSp1ZviUjX8HAPBLSYA5hAFI=;
	b=lFXN/mR/1xgChkwpHvJa4R//UOSbseAJt+ZEDdRAm7Nh82Cj4MlMNY95H2xBKP+eoNLOP6
	UiJTIKAewZ7dbsU9MTD+TU6NTPpDAAZvogkMMdpiKkE1zIzKtJv30ze+6NEAwWJAkIKJgS
	MBwCjxk0YcM3Em5AEnLBfGZicjPjq+k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZmXqtNke;
	spf=pass (imf22.hostedemail.com: domain of "prvs=438402146=epetron@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=438402146=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765891511; a=rsa-sha256;
	cv=none;
	b=gYz0UyPb/huvcwUwfP0AOIm3u8D+NL+G6mrqlL+FkGULcu/a1d8gU7pfrVP8eK6KPK7eeL
	XmiDtl2WvdDVGNvL/5gVQZokYk+2duhUYdfn9gsWdnvZikjIe4Czm5hgtUPuRYhEYwSe1L
	mGbWIUaxi6hHqpfyqgGdbY9KId4u5EQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1765891511; x=1797427511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Owz+SqmUbMxEza/nbiqSp1ZviUjX8HAPBLSYA5hAFI=;
  b=ZmXqtNkenElHjiZDdFAT1yRUM7Ts0nBCJJHtNVt1oaPlNnlPGYynh3UC
   zeJKObu4B75jSMvyd7+s1ZOSJKguS5pBFzVus3BGmtkPnZCChJXMUbntH
   ZHwA8hQydOqj8LFO2WokSCbR1zR5OngS7pku6P71HeeWlghrovBO+Tin2
   //LOWQb9Gh2ewomk1hQ8Q7Bk8Pirdd54m1BIUlYcqo3fOKFELFtj/zB9Q
   0gYSW2khaCAjOfX5E3WlBTWaYacfVIYGeKnKI8oewVQU0iWoecljrgL2i
   4ggnWoCN2uNWO406w0LGh8nHmNK79BUPGygyzcy7bFisbJV07bg5BwJ7n
   w==;
X-CSE-ConnectionGUID: K5ndT0gFQmeqj3A9lSSyfQ==
X-CSE-MsgGUID: 8SweK6QCRJ6oI+XRhjCbsA==
X-IronPort-AV: E=Sophos;i="6.21,153,1763424000"; 
   d="scan'208";a="9177461"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:25:07 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:17082]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.21.145:2525] with esmtp (Farcaster)
 id 8dfd8098-be01-4286-baba-bb6b63f882de; Tue, 16 Dec 2025 13:25:07 +0000 (UTC)
X-Farcaster-Flow-ID: 8dfd8098-be01-4286-baba-bb6b63f882de
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 16 Dec 2025 13:25:00 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Tue, 16 Dec 2025
 13:24:58 +0000
Date: Tue, 16 Dec 2025 13:24:55 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Pratyush Yadav <pratyush@kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>, Jason Miu <jasonmiu@google.com>,
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <kexec@lists.infradead.org>
Subject: Re: [RFC PATCH] liveupdate: list all file handler versions in
 vmlinux section
Message-ID: <aUFdp_fsGCNrFf76@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
References: <20251211042624.175517-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251211042624.175517-1-pratyush@kernel.org>
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D035UWA002.ant.amazon.com (10.13.139.60) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam02
X-Stat-Signature: e3idce3z3f3g8b5hs8tz6n7jeyrwos5b
X-Rspam-User: 
X-Rspamd-Queue-Id: 485B0C0011
X-HE-Tag: 1765891511-858210
X-HE-Meta: U2FsdGVkX19dYqwfpFXcLSKRiC/cPaaS6aA1OYbLhotqWu6mMe4fx4rhUj2B36X3YMP82/ifpqdv0+6tAHQrd+qbkDO5397WbqE25bCmYm6rIPZu0i5gpeGRPUOCYGPJ+cLVI9+WjrIQ0gfEyJqiZrQNbUZ1+anDc01W4IjxHGtatF7m1GV0JpWrtbrl/SazLThdEgF8qSz2peplh3Y0c6brhB4hrxYn7EtXv3O/c6+h6VEDMZIxURC47X0X+o7RRmy/lBwep2ZT6OYYLm4VeSqb0KxZ3BFk6lXl2nZZVudnzLPgL/A3bRliC3ItuCRN1Dwn327UOc+Tg0xJxXsA4lTuElBX4QDmu3S+rE9qqbw5WBiYAw0GwOhHx62W7anNf+fzQUY5h07o+jtAMjYyjknX79nt4pM6DPJ34l9M44Sq0xNPqu32WKKwoG6NJPuuppYu0f+27H/TR7vJwcBoTDrY8gJ+0kUsInTQ7XIgS5kVn6MHuu3sWvIrFyzp8IS2YZL5XUQQkRKTOcVcVy0VP2f38FZQ4QAOk+VfTP8wawgtACwMsYi/4RUmq3Yl+fKJntf7SWjzFkC44at1obyp57GW8u09dj+SJ4datzK7Op2Af5/hR5/TEKgbDWLXEyaFlepIQXsojJbMC8kwSqTx0pu5bY80+5KTTahW13umKnhg/owB55BU6oC/ASUM5IQ94FOFlgvFOPoEntUiaJ0D0Msr4BHXimhgSWxl5yeCVvlpLtZVdgfQGFEW1twWoDvdCX24+dikIRsP0l1bXcoy1yxIDg1a4gofV7BWEZjmvO/v7ZoSZG22hXuWNJTPdQYTRciUMZXANHNbKTbPaSnWc1WNs65M7uVHS+ROPbT/3FbsKZC2Xt88yljSjQz/9VERMeSbYAxJL/IsAhv6rofS4OgAN9Z3e3A9S5f52u5T2sA7adZXijDhRDAdwy2r9mm73E3XG8nZYm/xfGZt3au
 30ODR8rl
 qNgLlIyLLnNo61LcD9C1QAfR5r66rs2ywfuDFMD3GAgfR98HrTuEPprogIZQb9bAH5LpwN8CvVd/Vlh6fHDI4a6sNp/cq01qyxRtSNdK6nzOMi8+xKiVgCaYoFDY95e0YeyESWFQVfQ9xDxbhQ0/fQrHcs6RR4daIYUVISP9Fc/GyLX0gHKlgx2ij6xxV72ZH6EZ8XE+k1RQe0eWWVJhtF581oz7bKOQKoVeoQrNNg+6b81jfsnCe17TA3exDINa3ok4OODTCgf2QvXfkOhhUjZj5pPJn1OfIGzUV37IIe88sBXJMUku9CLXSvbWByyIgwwGPSSL1dw5ZeYnNZcBuHNoZV8o2HJlZ75fwgTy02EeJeGfoTCt9EUzZ/6uPsKL5eVhS6MsNFylG0PTAZiSmVVJWMN/mHSjUFdprlAP2DeaBm9XF6C052zg+3qa63a6pJ102nOZD5P13zpDYw7z48eMUAuxNZD658S60JJ+lOcrXQUX2r17gkhzxcm+HY1vfORcSkcArM3gHQteGjiGlebpGEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:26:22PM +0900 Pratyush Yadav wrote:
> As live update evolves, there will be a need to update the serialization
> formats for the different file types. This could be for adding new
> features, for supporting a change in behaviour, or to fix bugs.
> 
> If the current kernel does not understand the same set of versions as
> the next kernel, live update will inevitably fail. The next kernel will
> be unable to understand the handed over data and will be unable to
> restore memory, devices, IOMMU page tables, etc.
> 
> List the set of versions the kernel understands in a section in vmlinux.
> This can then be used by userspace tooling to make sure the set of file
> descriptors it uses have the same version between both kernels. If there
> is a mismatch, the tooling can catch this early and abort live update
> before it is too late.
> 
> The versions are listed in a section called ".liveupdate_versions". The
> section has a header that contains a magic number and the version of the
> data format. The list of version strings directly follow this header.
> Only the version strings are listed, and it is up to userspace to map
> them to file descriptor types.
> 
> The format of the section has the same ABI rules as the rest of LUO ABI.
> 
> Introduce a LIVEUPDATE_FILE_HANDLER macro that makes it easy to define a
> file handler while also adding its version string to the right section.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index e04d56a5332e..a474c9529a5f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -342,6 +342,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>  #define THERMAL_TABLE(name)
>  #endif
>  
> +#ifdef CONFIG_LIVEUPDATE
> +#define LIVEUPDATE_VERSIONS						\
> +	. = ALIGN(8);							\
> +	.liveupdate_versions : AT(ADDR(.liveupdate_versions) - LOAD_OFFSET) {	\
> +		KEEP(*(.liveupdate_sec_hdr))				\
> +		KEEP(*(.liveupdate_versions))				\
> +	}
> +#else
> +#define LIVEUPDATE_VERSIONS
> +#endif
> +
>  #define KERNEL_DTB()							\
>  	STRUCT_ALIGN();							\
>  	__dtb_start = .;						\
> @@ -544,6 +555,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>  	RO_EXCEPTION_TABLE						\
>  	NOTES								\
>  	BTF								\
> +	LIVEUPDATE_VERSIONS						\
>  									\
>  	. = ALIGN((align));						\
>  	__end_rodata = .;
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 4a1cc6a5f3f8..57ef75695f62 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -244,4 +244,38 @@ struct luo_flb_ser {
>  #define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
>  #endif
>  
> +#define LIVEUPDATE_VER_HDR_MAGIC 0x4c565550 /* 'LVUP' */
> +#define LIVEUPDATE_VER_HDR_VER   1
> +
> +/**
> + * struct liveupdate_ver_hdr - Header of vmlinux section with version lists
> + * @magic:     Magic number.
> + * @version:   Version of the header format.
> + *
> + * This struct is the header for the vmlinux section ".liveupdate_versions". The
> + * section contains the list of file handler versions that the kernel can
> + * support.
> + */
> +struct liveupdate_ver_hdr {
> +	u32 magic;
> +	u32 version;
> +};

I believe we are going to have two main classes of LUO objects that are
going to participate in Liveupdates, when it comes to their criticality

- Core/Mandatory components. Theese components are necessary for the
kexec to be succesfull. Think components like IOMMU page tables, as
you have mentioned.

- Acceleration/Optional Components. As we strive to minimise the blackout
time, we will trying to persist more and more state across kexec, that
are currently being initialised from scratch during boot. Thing of
certain optimisation like PCI onboarding (at least parts of it)
and the PCI Config Space Cache. If theese components are incompatible
between versions, we might still want to proceed, with the LU, at the
cost of increased blackout time.

I believe it will be quite usefull to be able to have the ability
to differentiate between the two.

> +
> +/**
> + * struct liveupdate_ver_table - Table of file handler versions that the kernel
> + * can support.
> + *
> + * @hdr:        Table header.
> + * @versions:   List of versions the kernel supports. The strings ate
> + *              NUL-terminated, but to keep the format simpler always take up
> + *              LIVEUPDATE_HNDL_COMPAT_LENGTH bytes.
> + *
> + * The list of versions immediately follows the header. The number of versions
> + * are determined by section length.
> + */
> +struct liveupdate_ver_table {
> +	struct liveupdate_ver_hdr hdr;
> +	char versions[][LIVEUPDATE_HNDL_COMPAT_LENGTH];
> +};
> +
> -- 
> 2.43.0
>

Kind Regards,
Evangelos



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


