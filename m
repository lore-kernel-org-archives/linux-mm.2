Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C64D2CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 14:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A8D6B0005; Wed,  3 Jun 2026 10:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC1D6B0096; Wed,  3 Jun 2026 10:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D566B009B; Wed,  3 Jun 2026 10:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0CC36B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:34:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81BDA120399
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:34:22 +0000 (UTC)
X-FDA: 84838846764.22.8D4564C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CE0952000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:34:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RncmSrbY;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780497260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu2f5FIaIpPGb9LsISKA98pvWiCaazPbEtHtZWNusVY=;
	b=4m2inG0RaMtakz8sMNGggBf9is7Q4DPi6Q62QeArVEG6WDuFDBw3kpGD0090acE60ag1Z8
	EUiRo/DKMq6agtCddGYmUpMVSJHrPWJ0DDANeGL2rsbly88/R/FQZQ0Rm9ciF3Yd/olVZu
	hOg63JjUW9frO2nFP1P9tGEFxhKpVm4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780497260;
	b=ulAv6p4VmwdkhYYU6fAw3MZzG5lslAT0n1PuBKlxoQjodfSIDdH/SZhOC9vOe9Z8IYqlv4
	ZTF2InaMSTEBIoyoP8HssO2KVT5fvK+UKpuJcPTEHkOE4qKm+K9qELvL/eKfpY3+btP/hv
	uKnn/brziWhKJ6QN2y+viBz6Hc3lFvk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RncmSrbY;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E54D60233;
	Wed,  3 Jun 2026 14:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2ED1F00893;
	Wed,  3 Jun 2026 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780497260;
	bh=yu2f5FIaIpPGb9LsISKA98pvWiCaazPbEtHtZWNusVY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RncmSrbYsIH29DH7UOSflSaLWXVrOKpLLAkTNCb1nluOnMdGip2i37TURU6W4HJeJ
	 TZmp9pFP/lbNDNr3NmDkkjJQARDS1Em4yc4OBjvD/HMqo5Kld1S1vJuw7KOZcI/GDd
	 IjXr1uUeuaJ6ivMy9Kcf1kEZLJ30C1L9MYns8jf2EuhRyGX6snzePBcWJ0eCFfN0FT
	 focV5Pz8fwOO1Xg4xet9jBisJNLqZE3MMFs794fvDkya9D/WUwSrHHZT26Bl5MLnrR
	 fi6kk90xXakTHdzzz88I1gudGHOY/XZtbx+xIuSYhxAJQiCjkJycHRHBYMAZXRurbj
	 7KVS/pipaYesw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block
 serialization
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kselftest@vger.kernel.org, 
 shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
 skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com, 
 kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com, 
 graf@amazon.com
In-Reply-To: <aiA1slnqPnC4_8XY@plex>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
 <aiANtYRRDr5iO5QR@plex> <aiAzT9TvGYjITiB8@kernel.org>
 <aiA1slnqPnC4_8XY@plex>
Date: Wed, 03 Jun 2026 17:34:14 +0300
Message-Id: <178049725439.475072.11560134126837430744.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE0952000C
X-Stat-Signature: nu95dnnw56z5b1rxuf3iw8hkqdgtcg56
X-HE-Tag: 1780497260-416565
X-HE-Meta: U2FsdGVkX1+QgucV8GzENOLGeuarGINPuxLrQsmJXIgV7dBmDDxCZJQUxSxusCpevbO/frAR4vJupTdXz0ZlaSGQ/46llPDHZVYXaYFQHsJ/W1zkva16/VMdHipzW4ENiCeFUDvEOFNFLHHuHMHMDt5pxHgyOIpvUFIsSkQvJButXRa1flAQ1spgN22VJmybb33Zuw7SbljC0UhUBBPe9Y3YpUE6Fnt1c5LcLH8G1qxtRF0v2w3ZA8gQP1kQtBtolkHw4ETpW+qXfWUC4V10d7eO5TlQ+t8wlqkxIZUfR9Ow5Np+DAD80XoKyXd6GUKcadZ022+e7GXzGIAlp6ZzVEO3YW6n6bs3Kc1AprNNez0pFw39/qakiURjHlpiy3euysRNUNkk42/G9V7eyuqtdrHo4kAF8zXDw84rGkQMlxxNeV5h7eF6Qf4runPhMhyTrRqgJ4NkI+OAVvW7ysZRV3LigXfuw/MIfIi7lfQflsh43T097YfKRqYy9FZmYE/dKMmeb3H960oO3HlFb2+xFjRM6mRWD6WvslZNV4tBEz/dGwUFq/NUMacybXYqthzsqwsB4ma+bHfEgcMhfQrfPUwmosp4X1VMmtLsSUbYkTCqgroUygneoGugIeIrbM7wXh5qiC90jqvzWqEgUqj89LCZ3Eu9X23j/ZsU2kLppkmTW1ulgBbxQi9nLEkQFQCWuZoziXyECniznvAoBUgCd1r8iGWZRTPj3tGG8NM80FLjT2VMetShE1t2NhLW9yJCBO89NQ3nYNmzSa7NU1ifW8wXBlQG5GZVX2iDUx7mmGbhhuHCyJrpH2+HdqJGaiCFsiqOQZShXaCzj02FMPpT56xk1vnpRWgiAhtmwo2jG80u/N+5w5lXQgplG1/Nb9YDIBLE9eOMB4uMGWErNQH5s6b8A8iMsMpQJQwr0J2YIGRTZEAreyFJuouXSC2/lpNRsf17h0neCcnF45uC1wu
 cjyt7/Xu
 LUZcpgmNd9FVs697RiALb0hbLXrSlyQD8CG8tYlZQBqNFzY/KPA8af/V4JHw9sdO9QjW7+d0hwoACK55ky3tyC69xxA72C+uUtbqrA8KTtTKmmYW+gE1fzkMtcuLceoxvbZTdaHj6tTYvtTtWXcgyllr3xmPOaAEpxpNbD2ha2xXzhyqUnH5LdKK4g4VTO9/tEPYtKHTDqrRA7JEFXm6zR8riq7tSnvQepP+N3FyHeLtrtB6m52G6dVCqm2gQl7FgVX9DN5MTxhFX9UoMhlQM2KDBXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 14:11 +0000, Pasha Tatashin wrote:
> On 06-03 16:59, Mike Rapoport wrote:
> > On Wed, Jun 03, 2026 at 12:05:04PM +0000, Pasha Tatashin wrote:
> > > On 06-03 09:49, Mike Rapoport wrote:
> > > > On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > > > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > > > > new file mode 100644
> > > > > index 000000000000..8641c20b379b
> > > > > --- /dev/null
> > > > > +++ b/include/linux/kho/abi/block.h
> > > > > @@ -0,0 +1,56 @@
> > > > > [ ... skip 25 lines ... ]
> > > > > +#define _LINUX_KHO_ABI_BLOCK_H
> > > > > +
> > > > > +#include <asm/page.h>
> > > > > +#include <linux/types.h>
> > > > > +
> > > > > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> > > > 
> > > > It's never used by block set and after looking at the following patches I
> > > > found that it's appended to LUO compatible string.
> > > > 
> > > > While this works for LUO, I think it should be kho_block_set_restore()
> > > > responsibility to verify the compatibility.
> > > 
> > > It should work for any component that relies on  kho_block. My proposal 
> > > is to use this method for other common KHO data structures (e.g.,  kho 
> > > vmalloc,  kho radix, future kho xarray). There is no need for them to 
> > > carry the compatibility string in their metadata, as whoever uses them 
> > > will include their compatibility string.
> > 
> > So if, say, memfd_luo uses kho vmalloc, xarray and blocks it'll have five
> > compatibility strings glued together?
> 
> That is correct, but it will be in only one place: the header of the 
> client's KHO subtree. Since it is dynamically sized and 8-byte aligned, 
> it should be safe to include in any struct.

This is safe, you are right.
But I have more usability concerns from one side and the duplication it
causes from the other.

I can see the downside of putting the version information in the data
structure itself as it either requires a different header for the first
element or needlessly increases all the headers.

But 

#define LUO_ABI_COMPATIBLE     LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE "-" KHO_VMALLOC_ABI_COMPATIBLE "-" KHO_RADIX_COMPATIBLE

is not really digestible too. And it forces KHO users to potentially
track KHO internal changes.

We still don't promise any compatibility between different kernel
versions so to avoid blocking this series on the decision what is the
best way to convey KHO data structures compatibility I suggest to bump
kho ABI version in v6.2* of the patch that adds KHO blocks and postpone
this discussion to after rc1 when we'll have plenty of time.

* sending a new version of a single file does same email traffic, but it
confuses b4 and quite possibly other tools, so I think v7 is better.

> Pasha
> 
> >  
> > > For now, reviewers will have to make sure that if the ABI header content 
> > > is changed, the compatibility string is updated.
> > 
> -- 
> > Sincerely yours,
> > Mike.
> 



