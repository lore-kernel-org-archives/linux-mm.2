Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4667CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A026B00A3; Fri,  9 Oct 2026 14:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21FC6B00A4; Fri,  9 Oct 2026 14:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9385F6B00A5; Fri,  9 Oct 2026 14:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0166B00A3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:06:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD9974048D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:57 +0000 (UTC)
X-FDA: 85303868874.13.148AB75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1F907C000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bi3Y+hEv;
	spf=pass (imf22.hostedemail.com: domain of blum@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=blum@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zD4NycKYzR4b+3JMqBPIZjbkNo8vo1ksVX3mK7N/Ig=;
	b=u2ZkEfH7LPPAQqyFnn24BVJa5C7fm/2QIjAOHLzksUF/xHSPCZ6YpDrw4Vc9XTYPHr/Ur5
	W8k3MOwsju94/m12CpWtbARzUkdFVbtkOZ+oENb0UcO0curCoa0SHIlt+8X4McDfbpyqFU
	9WKBwFnXrXvKUduQXUdvMeeExDdwcOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569216;
	b=wJ99iD4YjfljbWL5WxlGr2i90uWfmYIpsPQ4IsjH0DLoamoxCz21UxEKIQWIU/wpCqb+ze
	MZjdqYl7qGccvNGUsW58wA36IWuvd7UoXJ8WgQ4ZcnOwNG87HwUDHwg8jk0UdA/OdzEIpL
	Wgr27gRpBOyhAm2RY27Labg8UlI4OgA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bi3Y+hEv;
	spf=pass (imf22.hostedemail.com: domain of blum@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=blum@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D84D40323;
	Fri,  9 Oct 2026 18:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4694E1F00893;
	Fri,  9 Oct 2026 18:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569215;
	bh=8zD4NycKYzR4b+3JMqBPIZjbkNo8vo1ksVX3mK7N/Ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bi3Y+hEvxhTKGPnvRXnd/oWDFx1A1IKHvDWstaqyRbySmBo/iD9xB9FQnFGvSZCxc
	 65xQqNX7/iEWYesSg7DY9qV3ChEvsma6PZ4lENH5CjKXcFyuJE3LhNToIR0dbOwcsx
	 GYIPvBmOokc9cWxxcZRJEtk9xDy9mwUkO/GVqUXtyxir3+cb5ykKcyoEZoFCuPBuvl
	 xpyEHW21/P8TaujPzQ+mRVkaJAZ8HbDBQI6VRK0noggLtAGzJjraMq11zQ6d4oMxUy
	 fL7xrTm9k0LqfJue2/vHPGlLLuFNhn9o2hyiWa0eo5/iSyvjpr9dAeYDiiDIM0jCiU
	 nfxFcGPubISdA==
Date: Fri, 9 Oct 2026 20:06:49 +0200
From: Thorsten Blum <blum@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, corbet@lwn.net,
	hpa@zytor.com, "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v2] x86: remove the BIOS memory corruption check feature
Message-ID: <asktOXVRiXNOTcqH@kernel.org>
References: <9e1a161e-9246-41d1-9651-ffa85b1bc99b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e1a161e-9246-41d1-9651-ffa85b1bc99b@redhat.com>
X-Rspamd-Queue-Id: 1F907C000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8saw839tn599r17myc1wymcy5wh9x5tp
X-HE-Tag: 1791569215-810017
X-HE-Meta: U2FsdGVkX1+3jLjl/qKKq4A9J57qSaltWoV13yG4ZsgwT/7hVos49MtC5uGlX1vjT66ZQyWTqLecck/rpdM/U0pZ251hUUmhcOHBk6/Xm1g+uklTo4pV9NV21FRu+mKV2v02dljKHwkMEB3giLOzIns1zQMd1Mfdlvae5+gxLdQ5KZTh3dupugRmw1pf8m/g9xXylKYuD4Yn5alHjp4s/yy/8CpAjnFhWDMAPJIH8hD1afFXxWofQfNS2zMxJGXjuP2l3KFpxm5eva1q5roM/1aWSQg1lwCThG3hNz7F+tOH8dTyhnIP3LN+UmSHNxrNWWo/HRpKq4U0xe2+RVOftYZRqh3I2QFCB8P9F4/THeiT80fH4IN9fCjsnthohTsK0bl05HmvnTtKi1ephJ5uN4j5qVC9ngam9r2/EVnaXWIbGS8E+p2GCSALZ4jC0+OUCrx6aY5cPIWXPCaAur8NRhxOWSTkSIt05V4e9WiU4q0d07SErqP+jBWlZ/gHJV0uUXOd4wTFG/YbvmddLcFliqraG1BVMFt74K9ytfKx9x3cfuo4zGsdpvJc7ELH8z57HG00jPIDLEyB8oMRf3L+CaskZFHH4WzAGB87lyIF625N6kyCmcqAj5Xe9yCP27Ms8ii51617df1tFM3dr7JdpNAPnH8CrQQRTL+07j+6QD1YrJp0YW9stypXCZTFMzwfXi5Bjx/8dh9CFoZ+ZDhi2XbLi0DLAI1OTnl9je+64wF1vpmYL8f/yjvtts49eBBr6R2ffZ9SIRm9aExjLsi/mcnZAFocOInieHafai4pmLgp5xXR6URaOcOUisSu4BJv4TEwEImlJrZ778jeHTvOOqRZUgQd1cyic91yHmg/y1Xj4gyMpUz9KRIXcDuQTomq3ryJT/bCIJM9FwKA5m4uKwZTD6th/I6CdwG7JFpAOBhjbh2asg9+Tj8ipSXNlAo4n+Vt34OeHu4q9sLS6W/
 cuzGKN7u
 0QEYOlCuF/msTflS1bUZcciF9Si6o0C2DwkKXtIrw2igx7R4rpACufTJQiQLninMUyrcjkVRuGh7LuNi4VBK6R+YLoNgUx7RAwx8w3eK/RTKXwz0Nedq/X2ka8SX1QH758nORpU7pUjNOcX0IQ1Y+bOEfsGHnENdqgb5uU5YAY7dSRZ9WhYLtD5eZFZVQmi5F7gKJWt9kD+9IPbUDthkeqWowxHA0lFdV7kQIw6E0UwNHmsJ0YuGQAexMcxDFTHwIlbLJyhdyJ93m+MzexaODCD3wuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:41:05PM -0400, Luiz Capitulino wrote:
> By default, the BIOS memory corruption check works by reserving the
> first 64 KiB physical area from memblock, zeroing it and then scanning it
> periodically.
> 
> However, this functionality has been broken since v5.13 by two commits:
> 
> - Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
>   Moved trim_low_memory_range() into early_reserve_memory(), which runs
>   earlier in setup_arch(), causing the first 64 KiB to be reserved (when
>   CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs
> 
> - Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
>   Hardcodes the reservation of the first 64 KiB early in
>   early_reserve_memory()
> 
> It might be possible to get this feature to work by allowing
> setup_bios_corruption_check() to run first, but it's just not worth it
> given that the kernel will never access this memory area anyways.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
> 
> Changelog
> =========
> 
> v2
> - Rebase against latest Linus tree (v7.2-rc4)
> - Improve changelog
> 
>  .../admin-guide/kernel-parameters.txt         |  23 ---
>  arch/x86/Kconfig                              |  30 ---
>  arch/x86/configs/i386_defconfig               |   1 -
>  arch/x86/configs/x86_64_defconfig             |   1 -
>  arch/x86/include/asm/bios_ebda.h              |  17 --
>  arch/x86/include/asm/setup.h                  |   1 -
>  arch/x86/kernel/Makefile                      |   2 -
>  arch/x86/kernel/check.c                       | 187 ------------------
>  arch/x86/kernel/setup.c                       |   4 -
>  9 files changed, 266 deletions(-)
>  delete mode 100644 arch/x86/kernel/check.c

Hi Luiz,

v2 no longer applies to mainline - are you planning to rebase it for v3?

Regarding the changelog: did you consider that the check is only broken
for the default size? Booting with

  memory_corruption_check=1 memory_corruption_check_size=256K

still works and I get:

  check: Scanning 1 areas for low memory corruption
  check: Scanning for low memory corruption every 60 seconds

Thanks,
Thorsten

