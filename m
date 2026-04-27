Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7351DFF8869
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BFA6B0095; Mon, 27 Apr 2026 11:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68DF6B0096; Mon, 27 Apr 2026 11:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79A36B0098; Mon, 27 Apr 2026 11:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5C6D6B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:03:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA23D1B8BA9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:55:13 +0000 (UTC)
X-FDA: 84704633706.28.5DF609B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD470120003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:55:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v19bN0oa;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5asOrC39cbHqyOf1X+8mxsVafQvLiJ/WFq1M5hjKT4=;
	b=yV4SyjeYnL0UIC/zxk9IcDV4xQRNM5I6XZmM4/3M4guKhLzQxJ5t+KmZLxRwpn6ruzJPB/
	PNgrLxw+nMbg2V6VNC4MB5lar7wGjuTViF03F1BimR3rjJnDL4ly/I7MBD4cWZ0ZuQpnGu
	GOES0aN/6TE1cbGN5AlkOvEbVE97nB8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v19bN0oa;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301712; a=rsa-sha256;
	cv=none;
	b=Ktc/PeZgTdxRx0ewu6Br9sk0F+z1hA1K4GoBRsggmQ0cjuT6t6ibKuvuv6AaT5ts+k4Sps
	pEzC364VqP8NYosT/oGaAGx6UPNFvjx9CUXe/uuexceZEDVvNBE9oa1S9thsAxER0NyxfB
	jsnJosiaqBMdbh/WaAQ+u2lao0Kxh0c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B596014B;
	Mon, 27 Apr 2026 14:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3C2C19425;
	Mon, 27 Apr 2026 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777301710;
	bh=4fuQfK0U3MCtLpCaqNDn3ZYnCmYAsN25PDsyXgxtvfM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=v19bN0oao0FGtM0DaQMaeWM4xHGqaVBcVrB4U4tQxwlnqKjCjaxELNE14NBxwYH9D
	 At4/U96J4/daE4Wwk7pKQ+2PXcI5iGgh0LcSPbv6RTIxaD07I6rr47xv3R5ftzzy9q
	 ga50uMqOlVHIesyKg6QL0lSHxe9wrQYBeBVk0yn0=
Date: Mon, 27 Apr 2026 07:55:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 <mm-commits@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [akpm-mm:mm-new 117/130] ./include/asm-generic/fixmap.h:77:9:
 error: implicit declaration of function '__set_fixmap'; did you mean
 'set_fixmap'?
Message-Id: <20260427075510.bbac70576250c2af5e76bbcc@linux-foundation.org>
In-Reply-To: <ae92kz3LeyaFBvKw@rli9-mobl>
References: <ae92kz3LeyaFBvKw@rli9-mobl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s1eiys6yphy8q6afbpftf3ipd11cwp1f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD470120003
X-Rspam-User: 
X-HE-Tag: 1777301711-322340
X-HE-Meta: U2FsdGVkX19t3iKx39U/sy6rki/MxwtYGUk8ENjZwdRHnO7Ff+KV5D3MJsIp2nVWxCfbqhdFy9dt0C9qyn20xdmtqoedqceQcBIohN3wqqGA9K/5POUms3PuCNl7toJh66gkjWo5svQmUfuajVYsh3IhyV8MntMcXETvBJ8YsOefaXq3kpwZwICTwk9C/CzNpKEiusP7kTJKtxwlJ/kzxT+JdeUI+NFIDK//VRiF3XIzn8BQmtyWxDLfm3zAema6UVMq5WSm0wQsd/thWWkrkBu6vi1NI0Py0ZSl8UgRLz86u/PUeJJwQfVZwCFuFGWhKQvhc2i2flSHo/qSaJaL+qHRWiUkEB9pP2CSRnnIntRQbFaZBr3bMLO3yhAIQRU/qU+POQwcr+EL6CvugG8qZIDwW9QaoazrADsaHADrn1fCPcagev7k50rIGpdSo1+je1dTh8K0kbyO3T1EgK6icoPNeNUSXbdTo5sLQRXvzAUtMPVrT5u3+0KfWZMvtHT2m7H5NLkLDsi0rRz5RkyDPkei3W10AdHG/j7XoabeLxLKwZLHEbQ2td26eDujcA37uBWlTil8ZDMnmdNW2hWAQmXbjxIZ5FF8HeEL9EmEGL+uy/Oa31Dv9MH3//ocbCsO3wLBxZDXzcZLaAqubfwRw1xr0GSHOSBrtttATclrhW5ay6KqKNdESxlk+mqpq0C7yLsRLASxzNprUQrGmkfspYAiItIVesX/3uW2VKnpxUBNPJLjapm8VCt9ojeySC59ZxDbSI9rhi9X1d2nw6kZOjaEx6JGQoa0XYJovN0G+/9qw+dJi9mBwMsu+5uvMEurOdb9520qi8t+MjeHpCUVpftk/8AHGALYwwoYxywej0IrtVO/1W74ycy5bJuyPRgSyhRlP8M0oZAjEZXcW1jckF7e/WwY1Q08HafY2ZzSXxCAOBDwd9aLr8oB12E2PbhlQpkybWrlcQO0HMkVTrP
 okwCJ4id
 EBEx97iVqDEUo6MnM5D4M3605312SrsiUTw1D0LrsQ6THPbuvx08bR/3UyX+44VQ2Xi3afPC76K7s5NXfNCzhg840hQQFYERHEQVJq+IfSPCMKTfDgaQLBdrHICP/u9fZquHaM2XfWHLj5E4mV5XvbunGNv+90aqJs+ezLOpAMBWkSYHvFO/VLNgWpmfWzMWnPy1ePHRDv8/xsgyiCJwIX0ef+9lN1e+Nu26XqKVph+WGdbC0OHHP3MsUB4DgmG9sNi9TnNnQVCZMNtHkH76C4148C4fyXaqVQ/4brRe0FM9RPePmtiHtx+P1CzMz6c7FucwUrGPuZYtSFy7SkkDZonnzxDrkEsoMptJzSZoeoczHMED8qhPwLfwToR0xFUIhuCB37940DBnkyEX1mUVHA+A0YTLuFI+elwP9plWKuqPvEnVTbmr4jAP+PrPWbdC22vyA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 22:45:39 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
> commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
> config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/config)
> compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/r/202604271114.ebmzs1LE-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from ./arch/powerpc/include/asm/fixmap.h:91,
>                     from mm/early_ioremap.c:18:
>    ./include/asm-generic/fixmap.h: In function '__set_fixmap_offset':
> >> ./include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
>       77 |         __set_fixmap(idx, phys, flags);
>          |         ^~~~~~~~~~~~
>          |         set_fixmap
>    ./arch/powerpc/include/asm/fixmap.h: At top level:
> >> ./arch/powerpc/include/asm/fixmap.h:93:20: warning: conflicting types for '__set_fixmap'; have 'void(enum fixed_addresses,  phys_addr_t,  pgprot_t)' {aka 'void(enum fixed_addresses,  long long unsigned int,  pgprot_t)'}
>       93 | static inline void __set_fixmap(enum fixed_addresses idx,
>          |                    ^~~~~~~~~~~~

Sigh, thanks, of course one architecture had to go and be weird.

hacky fix:

--- a/arch/powerpc/include/asm/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -88,6 +88,9 @@ enum fixed_addresses {
 #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NCG
 #define FIXMAP_PAGE_IO	PAGE_KERNEL_NCG
 
+static inline void __set_fixmap(enum fixed_addresses idx,
+				phys_addr_t phys, pgprot_t flags);
+
 #include <asm-generic/fixmap.h>
 
 static inline void __set_fixmap(enum fixed_addresses idx,
_


