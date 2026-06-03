Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4512ECD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF966B009D; Wed,  3 Jun 2026 11:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6A26B009E; Wed,  3 Jun 2026 11:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3706B00A0; Wed,  3 Jun 2026 11:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D88A6B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:18:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A55668DCDF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:18:48 +0000 (UTC)
X-FDA: 84838958736.18.2D782F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5BAB4000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:18:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqiDx2XI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780499926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Row1/ZMLh6mM+sigh4dqTjgwYgOfCp9sUzuCj7aY0Fw=;
	b=fwsH2UzDChKCf1hConPU+khBiZ7ahA9ywHCnaiYiTe2U9UTgCfegKs143pkMjT/Y9Tn4Af
	QNfn3Xn7ugU7GMHrjaF9pbqxj5JfRQj1C8hLpIZ2qMlvd9vYQSArYw97fLPLTQFVQNy9xR
	eESJ8MVtc2N9DhlrxmlYrQ+mVGQH2lM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqiDx2XI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780499926;
	b=k1SSU7URR75mEnqFQL/TeExLxCM6m4cB/ZhgCe3sQVUQEooS8qpiPHpZX8qsccaJhyW9UP
	HwFNXYhsRuwNWP9HJzCLsrno70uyOR+gZSzzLtZDGofk0J4WXP0U5rmlXJwZLCFmApEX5n
	5R/ZTqfFAoaPHeOuV2EfiZODdgzyFew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FE2C601DD;
	Wed,  3 Jun 2026 15:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17521F00898;
	Wed,  3 Jun 2026 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780499926;
	bh=Row1/ZMLh6mM+sigh4dqTjgwYgOfCp9sUzuCj7aY0Fw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=gqiDx2XIJ6TAOhH6COyc85O7nZTepQiHDoIwbNNC292yB9TuNTxpGhJ/VrhM5MgSG
	 hCV+5zMk9sWy8BJLb6mJEiXT/PFhFr/ysO1atbo7egQSNjeeYYqVvW3/maP6WuQDLl
	 4ksBKHdCFbbC0xk3Wc6+1V91XA5ji5JyMED+9Rqs+mbNNtuzP4kry6+rq0iFxpuMv9
	 QzEbzzSDWUgCIhTx4qU+EXMSm3EoPiuHSgHqN00eIC2jOYah12EaiVGODawZwWRz12
	 01NbzKgqcrqvjs5B7e9buR3+Wf9D07ezTSb5wyK22sUjVLWU7hMtWJvkm2AbPEunzS
	 0JKuLIzwWry2w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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
In-Reply-To: <aiA_j7udFaO9TRBP@plex>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
 <aiANtYRRDr5iO5QR@plex> <aiAzT9TvGYjITiB8@kernel.org>
 <aiA1slnqPnC4_8XY@plex>
 <178049725439.475072.11560134126837430744.b4-reply@b4>
 <aiA_j7udFaO9TRBP@plex>
Date: Wed, 03 Jun 2026 18:18:38 +0300
Message-Id: <178049991886.481270.8804649242857550471.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 51syxms5d14chcgcpd757dw9fuhbiyon
X-Rspamd-Queue-Id: D5BAB4000F
X-HE-Tag: 1780499926-902799
X-HE-Meta: U2FsdGVkX19ocbqaxXEPONY50MtVfL42hSdfSBKVKPfo1a1/nBM3uC1XlVl5jLjCWP3sh14o+upGgZy3pEPtvbhYx1YBo5F3NXZdqdlaC83+RNFsO+F16eWg2Oe/F5Fwxqdf5TkxsTSlAchB0R8dzsXkMxpuevsSY0d6FfddpjH83TqYmC05cbbEnsdQ6Y1Lq1oqYG8h+n3lcDYprWe5uvDvrtrG94Es6CvY/AZgYWX3/uDtxgMgykNq7PC7B8ZtdMLe2HHn4RJkjGUdz3kmHP8LExu9QvfajS0OQWly9IuGeV29jxc1xftQXPLs1KGrvpQiZ0oED+Q3V6Q/CkpiVgSaSQ8vtIF5ahHnIpFZ58OX4vm9hNkGRGNgzkWMuOfovMnLlFTu7gxSpgvaexkhmkBvgCblPTEc7R+Z5hzaLVM770u5gj+Jf6lT0AhJ/DyNAD7zOcvZyZwX6tgpmPHffq1FVrpVHKJWAodp/opxKnquemDtCuqr0VJxKN0NR1D5ubKFF4X2pd9ZdlukWX68CHMBdmKIecwrz+wq3EgvmokPKOi6ZcGU0OqaQez7lcEqpqKee/D8yykp4vzjZ74YrcSU6+MhLNEvBW9nHCTaICwrvkt/RkEOZ61F6gA9xOnNd5HcxODn+qTzB6Zyvlox/AE84MidmNE3FWvpuMJljaUKkGGmo5OK4TjhYIR1VxppB3l6lkUMupZNx3+/UxiFyWUGLTmnaCk8nIwTgJungSPFK4HFhdBClBGoOdUdd9rytaAXnYuQFd2L4q6E6BGFCGlHgF69kED/qKegN1blmzRZErl1lQEJGND89xpgc7acGtpmPnPCxJ2ywbxt8fhBuK9ccdGJRrBrvMwKw0JdTaAs5LGRJLjta8aUczmWHXSLiJDga+YSi4YRNJV46C8USdwB2fAAz7v4ti00aCyuc6qvH4r/NU7nuHBJ0OeG0pdL9L6gwXWN4i+HMOnM3XD
 ZbE2byYD
 ccNiCBWmm+KQuGnZfD59NqPLxyY1Gn4Qo0EuCTFMLYxCn0SEPqBFJ5ENO94noQ4X8N7UGLnPuxttE3kp9nqgjh2RW/q/Ou5LSKM+qb+sFodTRdvx0YuN7qKH4YL3LA/WL20OsVE6EekskSjuw+hB+3t5iMQPheoqydIgfTpOWhm7zTKAjwPsmqGGRA0FrQFh8Zc7VjmMyUefPiKT/Rr25IDB2xRqFTgadfoddwXKW+oB/UAyX9BRuITCbzM3RRdGY1UoPnWqIPHZRrGQn79Qw8Jdu25m5bTLHVIXSYJwom7ImaAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 15:03 +0000, Pasha Tatashin wrote:
> On 06-03 17:34, Mike Rapoport wrote:
> > On 2026-06-03 14:11 +0000, Pasha Tatashin wrote:
> > > On 06-03 16:59, Mike Rapoport wrote:
> > > > On Wed, Jun 03, 2026 at 12:05:04PM +0000, Pasha Tatashin wrote:
> > > > > On 06-03 09:49, Mike Rapoport wrote:
> > > > > > On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > > > > > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..8641c20b379b
> > > > > > > --- /dev/null
> > > > > > > +++ b/include/linux/kho/abi/block.h
> > > > > > > @@ -0,0 +1,56 @@
> > > > > > > [ ... skip 25 lines ... ]
> > > > > > > +#define _LINUX_KHO_ABI_BLOCK_H
> > > > > > > +
> > > > > > > +#include <asm/page.h>
> > > > > > > +#include <linux/types.h>
> > > > > > > +
> > > > > > > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> > > > > > 
> > > > > > It's never used by block set and after looking at the following patches I
> > > > > > found that it's appended to LUO compatible string.
> > > > > > 
> > > > > > While this works for LUO, I think it should be kho_block_set_restore()
> > > > > > responsibility to verify the compatibility.
> > > > > 
> > > > > It should work for any component that relies on  kho_block. My proposal 
> > > > > is to use this method for other common KHO data structures (e.g.,  kho 
> > > > > vmalloc,  kho radix, future kho xarray). There is no need for them to 
> > > > > carry the compatibility string in their metadata, as whoever uses them 
> > > > > will include their compatibility string.
> > > > 
> > > > So if, say, memfd_luo uses kho vmalloc, xarray and blocks it'll have five
> > > > compatibility strings glued together?
> > > 
> > > That is correct, but it will be in only one place: the header of the 
> > > client's KHO subtree. Since it is dynamically sized and 8-byte aligned, 
> > > it should be safe to include in any struct.
> > 
> > This is safe, you are right.
> > But I have more usability concerns from one side and the duplication it
> > causes from the other.
> > 
> > I can see the downside of putting the version information in the data
> > structure itself as it either requires a different header for the first
> > element or needlessly increases all the headers.
> > 
> > But 
> > 
> > #define LUO_ABI_COMPATIBLE     LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE "-" KHO_VMALLOC_ABI_COMPATIBLE "-" KHO_RADIX_COMPATIBLE
> > 
> > is not really digestible too. And it forces KHO users to potentially
> > track KHO internal changes.
> 
> These are compatibilities; I think they are quite digestible, both to 
> write and also when the  LUO_ABI_COMPATIBLE  string is printed out for 
> debugging/info purposes.

I agree to disagree :)

It's KHO property, not it's users.

> > We still don't promise any compatibility between different kernel
> > versions so to avoid blocking this series on the decision what is the
> > best way to convey KHO data structures compatibility I suggest to bump
> > kho ABI version in v6.2* of the patch that adds KHO blocks and postpone
> > this discussion to after rc1 when we'll have plenty of time.
> 
> Let's keep this patch as is for now. We will have a broader discussion 
> when we convert other participants to this new scheme. If we decide not 
> to pursue this approach, we will change this code to use an independent 
> compatibility string. However, having this in place as a template will 
> help us convert other components correctly, ensuring proper alignment 
> and that correct string helpers like  strncmp / strscpy are used—which I 
> have already ensured is the case in LUO.

Pasha, this sounds like salami approach :)

We didn't agree yet to convert other components and even to use this
scheme globally. Changing this during -rc does not seem a good practice.
So whatever new versioning scheme we'll come up with, it'll have to wait
until v7.3.

Let's bump kho and LUO ABI versions and drop the concatenation for now.
It's a small change to the patches, so I don't see it as a blocker for
merging them in v7.2.

> > * sending a new version of a single file does same email traffic, but it
> > confuses b4 and quite possibly other tools, so I think v7 is better.
> 
> Agreed, I also prefer re-sending the whole series...
> 
> Pasha
> 
> > > Pasha
> > > 
> > > >  
> > > > > For now, reviewers will have to make sure that if the ABI header content 
> > > > > is changed, the compatibility string is updated.
> > > > 
> > > -- 
> > > > Sincerely yours,
> > > > Mike.
> > > 
> > 
> > 
> 



