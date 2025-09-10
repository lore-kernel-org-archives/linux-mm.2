Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99F0CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B528E0006; Wed, 10 Sep 2025 01:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502728E0001; Wed, 10 Sep 2025 01:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F568E0006; Wed, 10 Sep 2025 01:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8088E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:36:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E73AE11AC61
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:36:16 +0000 (UTC)
X-FDA: 83872229952.12.0D74A82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5955B10000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:36:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sOrIUiin;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXgy77XhDP4+bOokknBRzPilErrmlOoR0vDQ69kUmC4=;
	b=uy/OTAcixcBTjqEFwQp/9Rv8sM1tT617HT7v4kQLsHhvtjmPNL+S8dhx1NqMTLS9WpiRxj
	FH3H+aBS5KilBHMbSdbT9hXyh+8UeuAM6HGWmkAZSnj7Jq7IbgcogrJmitB2qgs71lB7VA
	ZKBBiAeawKxRvbRP8r/0eX5jqe0qqWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482575; a=rsa-sha256;
	cv=none;
	b=lnAlQLgqgp3aS8yv5pCL0p9j7vtt0xncbvghmVMXXlkwu1t7T6wJ5jOUmprPaWW4z7tusI
	RRxfRqrWuEtXDmTnW7oeIgqunMDwlzHEynlQa3ebVXR/77Mht0mFA8/r5X2RD2eEB6Aqcv
	0tcjsNTG37uN6POTkh4oiykcOZU+Vas=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sOrIUiin;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44675436FE;
	Wed, 10 Sep 2025 05:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE7EC4CEF0;
	Wed, 10 Sep 2025 05:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757482574;
	bh=5/tGb29AoTR19zttNulm62dEg7qbxGYqbvexI4uRPYM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sOrIUiing2YlYWY68MMv0n3bmumkyxurFIw2yqzdtXtypibY5ofZ0VMBH0DTAClr5
	 /efTlONBPnLPOU1Juby7jAF2YSud/YuiCdT0NHwlzFHFaar/OVsTj27V09K3nZksPH
	 UCYSgNY2UzWJhLsuNKVGthXPiRLq5F0KhgbVM1u8=
Date: Tue, 9 Sep 2025 22:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Kairui Song <kasong@tencent.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>, Chris Li <chrisl@kernel.org>
Subject: Re: [akpm-mm:mm-new 359/411] mm/swap.h:455:24: error: implicit
 declaration of function 'swp_offset'; did you mean 'bh_offset'?
Message-Id: <20250909223613.6427ab904277aabbdbe1454a@linux-foundation.org>
In-Reply-To: <202509100956.7q0VPOo2-lkp@intel.com>
References: <202509100956.7q0VPOo2-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yz5r3mpt668n7csnuafg4oubbt4whncz
X-Rspamd-Queue-Id: 5955B10000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757482575-723791
X-HE-Meta: U2FsdGVkX1/I/wp6Kp2HkysbuHt14mT4q6/0F9rFw3gYoA32a0Vg/7k5wregx4yYOjoelDhht0Bu+eYGFjRSC8Obo121XaT6+n3VMmzVnOogfKJDlloAdEAHzAdhP8rvq/Vjo1oDkmc3XJVPNihUaoOKYg5vSUNrLT+VJOMjFpo2QlL8qFFHTyqdkLZudzYGH8zNgNuFZYtoRtSanhw97oAYkFY6Mr+OhndDe9AHWtPL1IPHRJzpjFLU3jDP28/G1NChEAhlvrDimPfjhudBnWQQrbNtno1yKNnM2yxuIsFfvBlQsvSEarZGSMLcG+p16cpD8fMtGfmGjFJ5Eg7eydKyfAFNie34e63JoqSXCTMNSUoEOvZ3XOOO/HOuvQnTlqaI7+W+C5SunoIX5I4rDb/VZaiyPQRQ0NOGRXWubdbG3m8zdQjGgrnD65+myTAzsBqldGMfNNFtn/mbaFPYhUTYvTg24CEUOU4BJ6ntX9mw3JN5XjRnjw2NfTcftjhqA3ZmhKIZpl51VWPEwZyERNK5Oo4e+aE5VlJUOduCh5OXnjUBUsrHifufXK1CtPz1qTmCw3l+Kx82v6RR2pWA9ZshgRyjDou9GBlT99Aspqn6o24uX5/I6URf/e7FP1iWXyLZHZyJRXunPN1rhZscJkI9U6jAwEv9SbAu2+WQB3j9WNBhM/gYhNbDW68n4jK0ffp2QBRExR6Mihj704yvlFG1kkI3wcif1dcm6en690pYnlIHzPQtbFUrHF7vkfJ2/bYnhkOMOYQU/QNXBLqiONz4fTt6vRWAvvecGCCa/qM9fIAg9yOn/iD3472g4gCHXYtadNUg7I7Qgdo8S02n+2tMkmmq2VtIcgQkBb7k/io4Mw5Ln/YpRM92Dz65XPLa7cXHNFJUFUWaf/Z16ka0VvMQnUZC7nv+mHBfKzKpYA+6SMl3jS4JYRZtE5/2EsBq8I38jA4xjT4UUNQ/gkD
 itZmO/NU
 nWs6ZOf2YzNbmzdk6uxllz4Kj1YU3AJrq4etAiETvfQZikFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 09:28:50 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   f4e8f46973fe0c0f579944a37e96ba9efbe00cca
> commit: aabe1e0289084317ef7603c14132758fad3a975e [359/411] mm, swap: use the swap table for the swap cache and switch API
> config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20250910/202509100956.7q0VPOo2-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250910/202509100956.7q0VPOo2-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509100956.7q0VPOo2-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from mm/filemap.c:65:
>    mm/swap.h: In function 'folio_index':
> >> mm/swap.h:455:24: error: implicit declaration of function 'swp_offset'; did you mean 'bh_offset'? [-Wimplicit-function-declaration]
>      455 |                 return swp_offset(folio->swap);
>          |                        ^~~~~~~~~~
>          |                        bh_offset

Thanks.  I'll do this:

--- a/mm/swap.h~mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api-fix
+++ a/mm/swap.h
@@ -451,8 +451,10 @@ static inline int non_swapcache_batch(sw
  */
 static inline pgoff_t folio_index(struct folio *folio)
 {
+#ifdef CONFIG_MMU
 	if (unlikely(folio_test_swapcache(folio)))
 		return swp_offset(folio->swap);
+#endif
 	return folio->index;
 }
 
_


