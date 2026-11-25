Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5974B606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GY/6JvUl
Received: by kanga.kvack.org (Postfix)
	id 76CB76B0A65; Wed, 25 Nov 2026 11:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743F56B0A67; Wed, 25 Nov 2026 11:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681006B0A68; Wed, 25 Nov 2026 11:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43CCF6B0A65
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:01:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C62E8A0FFF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:01:27 +0000 (UTC)
X-FDA: 85474106214.09.AA8D3E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id ECAF5C0010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:01:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GY/6JvUl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795622486;
	b=AD+AGaoZfC9K5Rbw5M63t1uovft+le8PTdWwWbBgmT4vb//WEu35fOBIJFUA+esXxJZViF
	5YFqqt6DvyM4u94aYAjDahIU6TMuw/cbC7b1Zv7DjlVqyyEsbsJR/ym+0KxHietfAm8VGT
	ZCDu5NxgwNTIZAdnFiCa+XJfBi9t+8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795622486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJKWVw1mHimfCQu8lU34qXadL8opeU6DRxhW8P4L9IA=;
	b=I46RXMedcnPnVLGMry6p1eACmSRcq2K+1fV2D6jj6qyjuyZ0KKdpU2wMv/J+p5WgSF9H3y
	9Zmplh67nsjM3GUuLBkize5eC6DKDNaMWgyB/+dF6tUoGqvTMEOHb5cTdxrSyxzHSlgM0i
	S8WuA/6jp06oZieLfPHMBM8gv41Tbwo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GY/6JvUl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61F4F6335E;
	Wed, 25 Nov 2026 16:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329C81F000C4;
	Wed, 25 Nov 2026 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795622485;
	bh=JJKWVw1mHimfCQu8lU34qXadL8opeU6DRxhW8P4L9IA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GY/6JvUl3stImu68lSohHFhu2ZL/UrMus+gJqIU+OYYfyMjcRYE7/RYkOCuFBsju+
	 d205sFdwtt1N4C+8XrQ8mC2pBEk/jY+eOj5w07c9rXPpAuKbnNGuKZlmoA9wglQc0z
	 TuhTP6OIkxEv6J0YZnS6HSZXkPoPFjKmz9WvX2iM8479Vf56Z6dTRVXN9H5W0NoWFn
	 gjFfliYM3HEu2+/eo/Y/57aY9YwU07ZlIReIT2dz/uaqNeJ/Z9TsXidnkT95HAQnWm
	 /oND0kIzvJxPZcYMSqiANEx9AMCGK/fIynh03jpjIae/92tlfHnWj2u8LNbBpqgljM
	 Zp9KQPusr9WXg==
Message-ID: <sashiko-outbox-233694@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for
 confidential guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikolay Borisov" <nik.borisov@suse.com>, x86@kernel.org
Cc: mhocko@suse.com, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org, "Dan
 Williams" <dan.j.williams@intel.com>, "Kees Cook" <kees@kernel.org>, "Ingo
 Molnar" <mingo@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Kirill
 Shutemov" <kirill.shutemov@linux.intel.com>, "Arnd Bergmann" <arnd@arndb.de>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Michael Ellerman" <mpe@ellerman.id.au>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?TmF2ZWVuIE4gUmFvIChBTUQp?= <naveen@kernel.org>
In-Reply-To: <20261124160025.738362-2-nik.borisov@suse.com>
References: <20261124160025.738362-2-nik.borisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 16:01:23 +0000
X-Rspamd-Queue-Id: ECAF5C0010
X-Stat-Signature: ggwi5xejdiwnq38et3ubkiy5crt6xado
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795622485-943927
X-HE-Meta: U2FsdGVkX18bmmhdTgLk49loFBAa0pL/Zun4iuOe2aCwz6wfRSEz1asNLhkSryQWkwoqxEY1TljNM5iPe5FF3Ong3P9AxsgVZWcTF3Ct0Yk2SRkUZ1gBNzUnEmw9PEFgjDZThboHiUYkk0wS+Gjn25v86hbSjLFVvx5SlxxfR+45zESsdyKD/73ENOln30VjNQSmfvO2WfHUQnpBtqAyvgtLIb9TKfiCwh5v8LHw21VRx8Su5TP4TL3ynfW1DDnYIW9KOEGdu7tCjxRxRzo8Fs7jpqkJ4R/5LymOkr6n0QxAEUUSNHXefvgS/VsR3vumh6wfR3AZAw7HAwPTrWKzQ4Y6sM0AKWyVyR86LBEsguu4t5+Al+JQ9QE9Iuke6QosZl+bngVhXf1NWGrjLaWQjEuqqQSzOlAFiphqZ6iE4wvlf98gzN7nxeMvq2uP/dATiQ6a59HlO/vexxMFOW57HTC9eZv9ghDlU3pERxmB8SKI4NDYgtXTeJX5PUhMiwvdfWxTnyZxli2sQ9RHea88Jvt7NPHlNcnU+QRdYIteiauXJl3CJlqMr+SIUgusX2t2W6GD//ZfMV5LjGGJdV2GO7qh1tH16u+xb0H9F1aCBSdJ2s4p3K35DQtdJuB+LbAg6eNPoNmXsHD9TOagk/0g1H+gPnX6ZDQlSNcnALulssRnvfCX92wfGvMlyMoxh6EVZQb+tftoqbfuAAX6rTOa6DzQiElejcTHTC/VzUwTmZTZyXgyJ2vbp8AszWYk/Z8olVmWNNqfMIjKMV88Q7B6AH5KSMP/3hij/6LbwmpLa18vTU4+NCRVij0ydP43nYazoVTt+wxDR8MvPOC3D58cEKIL26hmUrtRHG7D8XCVsk37PxlWaW2MmDFNprubqsF0Dt2CAgYe+4z05U/UEdb6fEQEwCVJP1UESc6LLylX/C/i2y48zzgtB3P2zpzhitbx0+Use+Uq2K0JEbLHVSW
 q/LIXbRN
 8UmK5Nntgc5vNPZ9MEDRvA3tIAFw+N72ELvtXmNsyFQ51cTT61tZanKaSxn0/cz6O0PA9Wu6ri+wdNo+0EKMYtXO7eewtEHY3Vk8eE1MBdmhja13vM+gE6Ckbzdmuqd1cMchJhq+5tahYw5U4j/B0e10KtgzPrQ0PGxBkoBPC8jx4bHikBUb19w0hJukr8mtiFD52KfXdahtGDj+MkQWW1SqL4VPo4hfucIwyX/lwqa4wJpTH3XLvd9OOz87ItRXfmemdDBZFIJVWDHaTs+WqX5irzGFuplZ3TFPJyFpBPqT3IaHkeX7GmwebldNNjeDdlKXJw9rZUyEdUr0l/1vn+6C019YMIEWQNK+X3TmKSXLGcAXyALpvCK/FUlNBYxSnUkWzx3MsymK3+OsIokR1w9ida0BMv2wD3N/HA7mkj+B91SNm1ml1ZrLu33SA+OQJLYhMVMuutybvUJhwlcl14ackcxozMy/5hhYhmTe0n3QVe3H6CplxhCiWUFKgbKeL/FPFW3Zz+wp876NEI9bH6lWIddutdO27/IMxOOTnRfT0XHibLuEFw1H9mnHgJbyPXIn9Jff0NXM3RywOPXMpCmQJux1UNIR8QoLrWFM594JCq45ZqKjrhiCmZWUUuMJURCkFOu0+XYrgFJjsxDvl2/UhQIltyEbQD0Mdyp7gXaL5xcryfLbJJaJEEyfW05Q0jyhlhW281VNRhbPkIgf6Duq1de+N3jAxkWRXsVcw0rEuJCOSPWQKCOQRlQn5dWH6MMQD3sLpo34G/4ikLdiKZGS7cJj39KaDZuCKYEBpP3eTaHkgMZqp0/gqhLPgz9v5GKLDvCX8RUD80egPobRg4GaBMlvnbkjAYLgTPeBDm4zmRufEMoQENKxzOWYDWwzGzZKUv19uFIidd/J7QrYGuMA9LtEQCN3CdxouBzP2NTes16X7MiAjRqdBIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] x86/kconfig: unmet DEVMEM dependency when selecting
  STRICT_DEVMEM
- [Medium] char/mem: confidential guest check in open_port() blocks
  /dev/port
--

commit 044352a94dad5df8ad0a8efbc1156eb4b277903b
Author: Dan Williams <djbw@kernel.org>

x86/devmem: Drop /dev/mem access for confidential guests

This commit selects STRICT_DEVMEM and IO_STRICT_DEVMEM for INTEL_TDX_GUEST
and AMD_MEM_ENCRYPT, and blocks opening /dev/mem in confidential guests by
returning -EPERM when CC_ATTR_GUEST_MEM_ENCRYPT is active.

Link: https://sources.debian.org/src/libdebian-installer/0.125/src/system/s=
ubarch-x86-linux.c/?hl=3D113#L93 [2]

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58dce0b66179b..7a212f8363e35 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -901,6 +901,8 @@ config INTEL_TDX_GUEST
>  	depends on X86_X2APIC
>  	depends on EFI_STUB
>  	depends on PARAVIRT
> +	select STRICT_DEVMEM
> +	select IO_STRICT_DEVMEM
>  	select ARCH_HAS_CC_PLATFORM
>  	select X86_MEM_ENCRYPT
>  	select X86_MCE
> @@ -1490,6 +1492,8 @@ config AMD_MEM_ENCRYPT
>  	bool "AMD Secure Memory Encryption (SME) support"
>  	depends on X86_64 && CPU_SUP_AMD
>  	depends on EFI_STUB
> +	select STRICT_DEVMEM
> +	select IO_STRICT_DEVMEM
>  	select DMA_COHERENT_POOL
>  	select ARCH_USE_MEMREMAP_PROT
>  	select INSTRUCTION_DECODER

[Severity: Medium]
Does selecting STRICT_DEVMEM and IO_STRICT_DEVMEM here trigger an unmet
direct dependency warning when CONFIG_DEVMEM is disabled?

In lib/Kconfig.debug, STRICT_DEVMEM depends on MMU && DEVMEM, and
IO_STRICT_DEVMEM depends on STRICT_DEVMEM.  Because DEVMEM is an
independent user-configurable option, building with CONFIG_DEVMEM=3Dn and
either CONFIG_INTEL_TDX_GUEST=3Dy or CONFIG_AMD_MEM_ENCRYPT=3Dy warns on
unmet direct dependencies for STRICT_DEVMEM (and fails the configuration
step under KCONFIG_WERROR).

Note that simply gating the selects with "if DEVMEM" would leave
CONFIG_IO_STRICT_DEVMEM disabled when CONFIG_DEVMEM=3Dn, which would leave
iomem_is_exclusive() inactive for PCI sysfs MMIO mappings unless
STRICT_DEVMEM also drops its dependency on DEVMEM.

> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index 53ce0034a4c13..c06970238bf49 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
[ ... ]
> @@ -609,6 +610,15 @@ static int open_port(struct inode *inode, struct fil=
e *filp)
>  	if (rc)
>  		return rc;
> =20
> +	/*
> +	 * Enforce encrypted mapping consistency and avoid unaccepted
> +	 * memory conflicts, "lockdown" /dev/mem for confidential
> +	 * guests.
> +	 */
> +	if (IS_ENABLED(CONFIG_STRICT_DEVMEM) &&
> +	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> +		return -EPERM;
> +
>  	if (iminor(inode) !=3D DEVMEM_MINOR)
>  		return 0;

[Severity: Medium]
Does placing this check before the DEVMEM_MINOR check unintentionally
block /dev/port in confidential guests as well?

open_port() is shared as the .open handler for both mem_fops (/dev/mem)
and port_fops (/dev/port).  Because the CC_ATTR_GUEST_MEM_ENCRYPT check runs
before "if (iminor(inode) !=3D DEVMEM_MINOR) return 0;", opening /dev/port
will also fail with -EPERM whenever CONFIG_STRICT_DEVMEM is enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124160025.7383=
62-2-nik.borisov@suse.com?part=3D1

