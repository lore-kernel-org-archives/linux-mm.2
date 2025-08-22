Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185E0CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 05:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589996B015D; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540C36B015E; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365CE6B015F; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDEA6B015D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 824D883BE6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:54:43 +0000 (UTC)
X-FDA: 83803329246.19.9F07E35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE12D140008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:54:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BALTpbRI;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755842082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OayMFp7klbIL6YRC89S+RhcdWHLnx/0eWN4tjihaA4s=;
	b=WqKO2dcnhN5Ohslvs5OjvooyXAodLNRv8VHSimRANDPFQaF6O8gjBakmm+XU6+B0OzYDSv
	xQhcNfDd6buoFYyCSLGkfvGmcp/rDnxKqrVq8cehVbeGlWXkcTALAkjHTx+eSTUFX2bnbP
	vjbvoChFYNTFH23Wi/ep5oB/DQ39UJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755842082; a=rsa-sha256;
	cv=none;
	b=olaelKbqoa9VNWucH5jdZP01SBguBBQcJGFPa9EM2r9p0+9wpX5rW6XMYuqgKT1oYXM7/L
	BMk/o5XewiFWKTy0TtIKvUTW7MLaN5IkR/oI+pggkNgZbEA1PIsQWVUwX9PHYLDF68OgmG
	7mUBtOZKcPB6XfEjoBLZndFtq86+PFo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BALTpbRI;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44E8360256;
	Fri, 22 Aug 2025 05:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24A7C4CEF1;
	Fri, 22 Aug 2025 05:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755842081;
	bh=2tPcGfaM9fCEwka0ObLPD13Jx+z47kuisz3Emc4w6xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BALTpbRISpGpz7f9L+iMxDqhbRXo+WEArVF+If32LVKoLo9g1XGL7T6MEwr6Nir4A
	 U1RLLNsCiXjyVn5PsScryWng/UsqdS1yaluv95zbxPd+E3h9mEcib97pt7lU5mP3Tf
	 sEoEHAup6UQZ3wFig68QpIntp0PO95oZbgq6qUJdwrJC8nxcPSiJyHwmPrl5okW5UR
	 yp9w7LZzfEutso9xFz2djU61/c8wD9Ncqq9AmzhwF+PkqT9IZ5aKYlBfRhnGu28+Tp
	 5v2ByFvQuIYoslZlpKtrhKVW1XH/K4w5B0Q6K/3cDdAFQ+TNj832aGAMSjL9dYjk3D
	 JU9Sivey4NMNw==
Date: Fri, 22 Aug 2025 08:54:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH 0/4] mm/mm_init: simplify deferred init of struct pages
Message-ID: <aKgGGLEcLEKEHt0Q@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818064615.505641-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE12D140008
X-Stat-Signature: emsih61qj7any1i5ce6go1u6fdh3w99d
X-HE-Tag: 1755842081-585087
X-HE-Meta: U2FsdGVkX1+kFC7mmqCsUYwkY6K9FTzLIQr8QhlTKsitSH69XwE9VLnmZvsIjShibnHxgfWHX66xopC6GTCZT1isKA4w+cFU/RdPBuJPp0w65P/vlMpXY3PckYp5zVULsaPswepRKY/dCJ8FyvgT6YPyZAECaoaCEuvSKdaoNVrL26+BmCiG6at7NtPWWDcOxFX62Fyxatd4qHC7FoBk86Uyu6PXaqE25yPQgjkST5yIzgOJ4GmOVCFchb6UUpisXg+4lgihg8CRDJlCqJsihUjHftd55VoGywEhw0qKsjxlB6MaDmXnHH6RxLXG+V+BfHP8poxmibyU+XVsF0m2V2FM/AJN871LsNvJmZ8jjQcF49lOTdcMyVwkmBVmiSBPRLb94h9yRltfKWpAhLi2RAQs6NS/zLuXEZqSdU3EheSBBJTbb+amn/J8eugGwO5WoAH8bMBuXAE6NdqHiajZmEvQX23RZsNC1WDrTe8ya+zD2+hhZw1AWxLQ6zc1F35fr9X42Gd8pS3uhkhbWNsrM8hn/XPySMt0XBbHHEGei45Gw3c86vImlJFfpgp/QPUO3Ltoi/Og1uAQfgQTNf6fcS3tZhO26dlSVH5kIk5u+ALJfwVPLMVeLem2+7UsbqU8b7mDy4ZOvRS6gUGQhIP6P6tDrDdY1+hpoEDmsFRt3/eVDi01SD/NaKx5auOQBnpn1TfeF/4Cjj2xnSphxepQJ3e0f2WB+7K9DBGjlNOGVWKmHkRQDcQGkoP4T0mBjUpRH/+fd6lMZhdZ5nliokwm6v+cJ/GhQ2mxN3QoFoNmznyof0k5tv/jgjhR0e/LbEl5O6K/n4mzJoHCxg/mlK+3bH4Nl7I7mY2yrdNzlaVuFZ8UIGPjhMKplc8rhQ+rP07DdZMivP9LOUSpwEryFdvAwttQB1EiJ1+5AXjCYtJbtNKfqsLmgnSH8whTTDT2GM3TRpS+ejxJNl6nC2LCmIZ
 v3PHjO2j
 ouwqewd1Z0sno3n1rp6jfieW6rxqXoppNPkw3WCp7BKgdJ9waljgMxqdjGxGp29v5cxx2CuflbVfGFBbd39hTIhEt7rh3dOlsMYVdiepVk39Bup+A3fLBsnQ1fJe3qKdC5YkkZ9nGes3x5am7yYzsINxZgkryIPtXVvTBKTGPwk2JWiIitV1yA/pJ7N+ZWpMK4PgJs0+xG2T1C693FdwmsxuFF5P3oSqFlHElEvtrbaGVYdevMb4iSrAEXDI/YgmA5Jm8Tn3l/jmAm9i7uOGyvyavTC91fLCTU5eB6UFOv0cvHQckJL0FQ+rayK8mp8/YJitr3old6X9KydxTmbmRLlsVSfFR//u4AdRsjnCJpgDSeTpskmqKGi2h86vEWxsgLEwFwHB/PKQIzfVytmSp8QpR1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 09:46:11AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches simplify deferred initialization of the memory map.
> 
> Beside nice negative diffstat I measured 3ms reduction in the
> initialization of deferred pages on single node system with 64GiB of RAM.
> 
> I don't have access to large memory machines, so I'd really appreciate
> testing of these patches on them to make sure there's no regression there.
> 
> The patches are also available at git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=deferred-memmap-init/v1
> 
> Mike Rapoport (Microsoft) (4):
>   mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
>   mm/mm_init: deferred_init_memmap: use a job per zone
>   mm/mm_init: drop deferred_init_maxorder()
>   memblock: drop for_each_free_mem_pfn_range_in_zone_from()

I've added those to memblock tree
 
>  .clang-format            |   1 -
>  include/linux/memblock.h |  22 -----
>  mm/memblock.c            |  64 -------------
>  mm/mm_init.c             | 195 +++++++++++++--------------------------
>  4 files changed, 62 insertions(+), 220 deletions(-)
> 
> 
> base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

