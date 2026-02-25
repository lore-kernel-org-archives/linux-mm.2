Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C72FD3769
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBBF6B0093; Wed, 25 Feb 2026 10:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3F66B0096; Wed, 25 Feb 2026 10:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12D26B0098; Wed, 25 Feb 2026 10:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBC2E6B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:51:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8704EC2431
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:51:28 +0000 (UTC)
X-FDA: 84483418656.21.6401D3B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id E5E50100015
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:51:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772034687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5wd1fZsmh9UNN8+BLmZOG2AsYoZQcf+cyz1/pxL0Ec=;
	b=sjPBD/y6FVVKz7GvOkSnRSEGxU2H5HsM0FeZGMoE0w0zepQlJ15Tydf1vsFobywNrtdcaM
	Z5SwOVickfzOdxaLJ+nRUyyuRlbaMxWHRSR5JYtQwbT9iQFzV0OLKjNP9B3dQR+MhsBaHw
	Ar0DN7wxazBRGjzGDi897D3lWAnX/4s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772034687; a=rsa-sha256;
	cv=none;
	b=IZNy39cpR7rkCYexGewppjvIIWv3E+TVUoS6veklAvWDWDliAcSIlFwEB85Q1ErFIbjLzi
	iRZF/k4pm4VM0et9AtIpF3Tf0w2X4cwjp9cOM82BINWjSjhlJDJhrZM4w+WmeNJoayJ20A
	wJsJzyY70JBykVeVTY3V8L77zuTduLo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6415B165C;
	Wed, 25 Feb 2026 07:51:19 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE9613F62B;
	Wed, 25 Feb 2026 07:51:22 -0800 (PST)
Date: Wed, 25 Feb 2026 15:51:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mm: Do not map the shadow stack as THP
Message-ID: <aZ8aeHpn_KElP2jm@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-6-catalin.marinas@arm.com>
 <5570c06d-fbc1-42c9-9b27-26211e8b033c@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5570c06d-fbc1-42c9-9b27-26211e8b033c@sirena.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5E50100015
X-Stat-Signature: aj7je7y61s4ssmnn4mps9rrwbhqgdm6q
X-HE-Tag: 1772034686-486307
X-HE-Meta: U2FsdGVkX19UaZ/8DPyp2TlIeQed8RrvWvJqLK8gxMwBQyPZwkJq92oB/ESNl4rZ4r9C7gWi1yhwY51mkoJ+J2cOH1K/L7KDCzTDN86LXVJH8taRu4WJUz1GRNOkW+AUVZZS9Aqf8eHYTfgH9x5IhOBxCSfy+5ZxADXznwyPi8nCprpMFH5HbCVt1xkfF4b+jKKiDcGyAmGlPg9r4MSsq7xC4BDqv3cDOrbSZt6RM+0d04Txf64zVpRnk2w392l5OMKRrMov/r/6Q4FIfCiOQAmxnpJdK1aEp+x+GgONzAEULGHiPj2SK+KMVoYd/kP9Zwn0dmtnmghQJ8j2unGaQ0PxD91x6ilsvML6VvsQBSYIczBWxvmGVO4bQfgiLep037SP4XPuZd4tqDT5YNiPM90F8jjMCoU4SdZVOMzBqWNiKT2SqvHmvbz4QPqoXjz5c/JnfzANX8m5syCB1GfSJu9lSe2xjzfHTKQCHG9mgsX3JXuXfkyiYOotnxxoZ/oUvpL2wvc+0TTLD4iPX1etYjn2I7jQzPcRbCO88vdVGu0p5+v4QbUGZ7IDg9sIQW+gLGAeIfY01vUWxjcUoXSrcR+LXcXvMgjO/OuvsVH6zljDQ0rW9ACGbYIHEX9jFqpSsqx61fe7698McOVM5D+GMi05TsKDUX0J2VaGS6cuNVllkvTovtwf63P8eZuF/p6V1k031t0U5USguwBv5/ijXb4PNbMXT0P6yCfyfh5Adm8XukoT8KzrT7NP6NG4TJYSR1F/YInj/DnFjUQXz60hdYRkkOclipr8yy7AZIGr8wZ42zf0StbcOrBB6d6amfRFgpE3LPhDxjsjlbNTvyhl5/ABSriDRy5/NGiweEKymImbks/OYdvzVnqe4dzZiP8RX+JstFbyXOA2NcoFb4Sm1rxx56M690gCuxOp9gna/fqN7gStAzy0Db8ueXupeTt8jaSYtPBlozzf9pLiG2s
 eqpDZ1HA
 iatNYCUP7MV+faUjRWX4l3hVSm/gpvTrdKZqFHT5L3Lx5xTwiHMPsJEXwhY9WIIw7zRf1UtOstyNlsfBz2mhdHeCvG4OGv8/AaKJ+yZCZJn3gUnBHJJHOBsCs5H+e2WskPXPhJNAFdxhiT1+5NKsBwSLzZygnrU/vG/Dy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 01:02:36PM +0000, Mark Brown wrote:
> On Tue, Feb 24, 2026 at 05:57:57PM +0000, Catalin Marinas wrote:
> > The default shadow stack size allocated on first prctl() for the main
> > thread or subsequently on clone() is either half of RLIMIT_STACK or half
> > of a thread's stack size (for arm64). Both of these are likely to be
> > suitable for a THP allocation and the kernel is more aggressive in
> > creating such mappings. However, it does not make much sense to use a
> > huge page. It didn't make sense for the normal stacks either, see commit
> > c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>

Thanks.

> The create THP and immediately splitting it pattern is very clear when
> checking the mm behaviour on new GCSs, this should help performance.

If the first access is a write, the kernel allocates a THP from the
start without subsequent splitting. Also since 6.13 (commit 1ced09e0331f
"mm: allocate THP on hugezeropage wp-fault"), we go for another THP on
write. It's still wasting memory and time to zero the full 2MB when
it's highly unlikely we'd ever use that much for a shadow stack.

-- 
Catalin

