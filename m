Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9487CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BA56B0098; Wed,  3 Jun 2026 09:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7E36B009B; Wed,  3 Jun 2026 09:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6886B009D; Wed,  3 Jun 2026 09:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78CD6B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:59:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B16A1C1625
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:59:53 +0000 (UTC)
X-FDA: 84838759866.20.95E9245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A807D180005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:59:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="etVZk3/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780495191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhF+jUpU1E0204EIQ63W4XnUB7T83kejus0i2mjqkkQ=;
	b=pwP1qn+XkmI7sqrlBKJbgiV0qezilNzfyNLQ2jvniqHJ5dAeEzoPZTgt4Uy+OZtG5BtO9+
	7t2VPwNRmylOr11FbN7utSHc3nJuaAUy4fracYW+w6QEqbYYlGnmHi71wDHf8+hPKnXL7z
	O+3CLl4jvUoSB9z4S9ouepkRPyT+tag=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="etVZk3/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780495191;
	b=KcveHR/CrgTNl5hb9DZBlPLbaZ9+epO4K5WAwxNO0NDSg11PLiRB6kpFfvlwLnEd/NVIGk
	9yeri7M/cPV3JqSs97nBH47r2zFIdtGs8j1S22DW/r+DYCLQp7z2qfro2ZsXbomTnBLRb5
	hbShBswEMJRuhUoPfVCedQEcSt9zQwU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 131F56021A;
	Wed,  3 Jun 2026 13:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948C71F00893;
	Wed,  3 Jun 2026 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780495190;
	bh=AhF+jUpU1E0204EIQ63W4XnUB7T83kejus0i2mjqkkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etVZk3/aXRNhvGcH3Bm6kbdy06t+JcMXHeruO2GnT/u6CtGXxBz8gfWLcADNEMK+W
	 TrgH1b1J0MvahPjHWsUzff9yQnoRg1zcYs4RD762G651aDk+OSt8A1CowDDE8at8R2
	 ytUnXImjFNGI1IoeZMrkD39QqUJHdMTAMWeoIJCpyABH9UHsJirRprFUWWOroEHiuM
	 lEzJwr5Hpirzmly1jAEX5EDKKn3TwLd/iP3y/wuvPqUJISIi/JVf0XiiG3di9Mmawm
	 NOlnD0DFIRpnMHBYzHIZq2SbVwtglNMvID+T04ePOW5h3np1YwRp0rEHVNzWVWoutH
	 Y2cnIDgib1x5w==
Date: Wed, 3 Jun 2026 16:59:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block serialization
Message-ID: <aiAzT9TvGYjITiB8@kernel.org>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
 <aiANtYRRDr5iO5QR@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiANtYRRDr5iO5QR@plex>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A807D180005
X-Stat-Signature: 1s1jugtc7465dq78t79qjxd8go7em8on
X-HE-Tag: 1780495191-515865
X-HE-Meta: U2FsdGVkX1+mM9914FsctnIpogrIck8u/VpIuhK/R3Dtb6MklfEhlbQS8tpE5PNrbvPXb7z4X3E0AdmgxWRa8STuPg5ny+HsZBEjhQY+TtiqFxOS7uHQzQWNh/c2nLYeeAEoirLbVl7po1GcomYVKMCJLWdRvIxRuE2kE7gSElEP8nslW8AnwFv5mcODmnj9TEq1luYLRE+XNrVImBy2NDFgtb9BU5VIF4+RkfnPA9lhfybZ8flO8FnGuHckXcJZlMN7Cn4FP+wQby8SS3l/qYe1wjcMDnQBt4WrBoym8Q6lIVKvoqbw3RJY4b+UHMizy64aQYYHOqIEjrFa14QuUsZpBcq1yBdYMBfH5pr0wsEJbUMkQvt/f8ASeZOa3Govx/igsCHXNUd32zJKdIt7otZCDWpJ7eQLN/ZGwjPrUNp+AXHw4JnHjWWQ8wbJHpl+AAUemh3mu/G7yxSMgf0UprRQrXh+K6WSJzFRa61CpRLy4aXSiD5kTjca1214RjasElhrPAGYUac5OmUcoKXqFx6wBii6p7JYrkFRmRQebDFLExAjJzVNy/GDG3un/7F0491OE9W9i8el56Kf8+X3HTPvdrQg1uTyi2Hg/7ZWf1ZD1CgedaObFD5sVIYaaaUNomq7Z1fFA3qbdyN4lZKap3+cdtRjkogG4O6c4C8ggzzXV/7Tfe7CmXNTeuVyA8Vh0aVNnX+iupHKyiJFPbHwpvg99CI2Zsk5S2uQU8wVMduy/HFOwQObflm40JgUDK1QD3m66IzxcZ4VehQZ67xXaa4LO+rSqelud8VMG9pzr4rBt78VtgRr2zNL7AlaKE+BXgNA97ayC+LsR6lszXU0XKDEowzzUwPovmPpufnzJDulFTT/cc7+LUJNUdlRBcGXcgio04ChFDSu90FbDji2VhqwYtrQHweeQX8WJQS8n0drAxtS5W+IBhj/YialVAaWd7jR5wBCEEVLmaiJBgT
 qbcyOML7
 zjdXh+z+wHtjCMHdtOIv9iTChzuHcc8mnNTXEX2QDMzvqoHgXudl0uqSEuuHZ+wpfm+VF/JKvZpa59QUXUUv0usV398Z3o0MFcMvwqpzcKoqohja9f1PQ5kKahJh4gignpGtJnZwNWozDSclMLJNNQY87DE87WuE8zObjWq+kQS1pdrKGkuk15S5sCwRNEIeGV9U3jd+Gx8qaAX3x1W6OxYf/tBTZ3+77qMSnsvDqBtiN8BFsaZZ7+BLUOFDUs7HqIfaxWmgSp9frpAhhjaKvM0Q1MglzQ3Acd7F7voIXZOeN6epxVacaG/x2aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 12:05:04PM +0000, Pasha Tatashin wrote:
> On 06-03 09:49, Mike Rapoport wrote:
> > On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > > new file mode 100644
> > > index 000000000000..8641c20b379b
> > > --- /dev/null
> > > +++ b/include/linux/kho/abi/block.h
> > > @@ -0,0 +1,56 @@
> > > [ ... skip 25 lines ... ]
> > > +#define _LINUX_KHO_ABI_BLOCK_H
> > > +
> > > +#include <asm/page.h>
> > > +#include <linux/types.h>
> > > +
> > > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> > 
> > It's never used by block set and after looking at the following patches I
> > found that it's appended to LUO compatible string.
> > 
> > While this works for LUO, I think it should be kho_block_set_restore()
> > responsibility to verify the compatibility.
> 
> It should work for any component that relies on  kho_block. My proposal 
> is to use this method for other common KHO data structures (e.g.,  kho 
> vmalloc,  kho radix, future kho xarray). There is no need for them to 
> carry the compatibility string in their metadata, as whoever uses them 
> will include their compatibility string.

So if, say, memfd_luo uses kho vmalloc, xarray and blocks it'll have five
compatibility strings glued together?
 
> For now, reviewers will have to make sure that if the ABI header content 
> is changed, the compatibility string is updated.

-- 
Sincerely yours,
Mike.

