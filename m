Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B91BC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46AE06B009B; Mon,  7 Sep 2026 09:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442036B009D; Mon,  7 Sep 2026 09:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334036B009E; Mon,  7 Sep 2026 09:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4766B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:36:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F94EC011F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:36:39 +0000 (UTC)
X-FDA: 85187066118.01.1C4AF2E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id B4CE74000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:36:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Pp0fBinA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWt4misabhLOnV//lu2h3uE6MQyjYWXsTbiIxpiihLI=;
	b=CZtnn8BYMz6lsUjKstaWfENG2PyY1rDPwm9uwitJwukNzGKNVDS94p/GxaimfGABG0M5sb
	aNjMQFVMWmG0PoniCbDveCeszRin6MZWAexTwsXwzwEGLo8l7su++vjNKaDq2GjMeQnn87
	QUr8jN9GTmzI2T9Sv9BAmlbZGn8GHw4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Pp0fBinA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788198;
	b=6d/P9Mb7XNvjJn40nKaGAweNatCH0XkY5dQGqH3Fu8OME9qrA9ioBCN+RG3qscU/i1S4Jv
	m+E0N3MchPspyRBnQph35WFgEGLZiS1oFB6ZJP+y9nvOGqhEyMfMaoch2LokiawGz2WWy4
	DPtvzd7MdnwCvw1Vf1cn9KdOk6Vv/2E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E72CB1476;
	Mon,  7 Sep 2026 06:36:32 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBD973F528;
	Mon,  7 Sep 2026 06:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788788196; bh=DeeXP5VTRAaxBpRd5mSKpS9jcefo3GPkzMjxSmfNmxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pp0fBinAfSAERaH+4GMK9+su2zRdcdSsv6MOvALzgktaheLoMKrQ6T4cii4dcsXm6
	 cm8NTsibWj8CenWDa8KVg8LzXKEIRur5kVtj095fytxsJ0RlBjy1VgL7lDzLEpFVzf
	 OMEXSJBomvM/JSvQWC/oz3gdFzrXQeuE3VwPANQk=
Date: Mon, 7 Sep 2026 19:06:33 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 02/25] set_memory: Introduce set_memory_pkey() stub
Message-ID: <ap694bZb0crWvLo3@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-2-743ad31b2c8f@arm.com>
 <apbiQtt-cAlLkDqV@a079125.arm.com>
 <66270f42-931f-4043-b24c-edcc4cad74b8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66270f42-931f-4043-b24c-edcc4cad74b8@arm.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4CE74000E
X-Stat-Signature: 8mzf9ygc6didopb7pkngt6h5wfc6xgrm
X-Rspam-User: 
X-HE-Tag: 1788788197-781154
X-HE-Meta: U2FsdGVkX19dQ9OGNC7S7Te2aTHx13yvG+PTSB/12ywY33srh0Pe2T1B6XWOKH7HBpgCZ1BdcgWCPp8GLjLFAyI5PLvAA3BEtevdGUFBI8TRw+w/Klv4vjj5fZOeO7ihDP3UZVTBHnSTcUdVQmyFricHDKoJk4/jchcoy2Q/YGxba/bapro8nc72H9NZshGAgaZ+hEpEggqqDN3lI9qh3lo4L8M+nkqtSozFcYdCrrJbJNj6EyqHyAyrAB9+vfurVH0s11nlefZKvyicT8Cm6JRPSNMepovGtJHnhPtCWo0dIo4jpi8hqiAkQ1g/Be8qr2qJPyeO3EB5ZV4vkAo66UD80A5zvKhF8l7YXIq1yjcGEh0xYbmgv+rrHtIdhEBcPVvVfoFdQDeWsWyvYK6KEgcXPD1K1UFRYHzIfexbJ26hwNOLxxioO1nnAkMntf3GCmhS6gokZVFj307CEvaaOhBPu2p04j3wF1S82kgWxziyBGdlgcDyrn5QtIi9YLkTFwXufWphA0DspQ/RQimKJzTGHL2OjtR8uvOmI3JCeA85nWzvDaOJXL1aXNPAahObLqEAlA83bs35ZDysHNnEUrojdUBZpU1FhLjwvamu09nMv4y2rwl6LMeBtmiS55JTxmDyrb/QaNWQBpDhGz2gbeX7aM2r3lrBWj1VnmElB0fnH0N6ZVxqIRAZP0m06gKIwFIYpmxSvNoHtBYRi55Zu1hot+gLiR/s+AgrGcmVCJuczjE8e5f9PwUin3WUTjiSL13FhHL9NBK4+jB3kwGFg4+grs9SKA7QVYF36Xk04AO5n19CwP1uw8DFf6dRnf0dbyaDEQluUvJIL7I2/iPnkXW5/aey/hM3fV9iKfB7NpDtrEqJcdV2Yz9zGQsNAXal8cECt0q+8+ufNktahoZyqSh2wM8S+yeN7gT94p0lOQqLCZmonMEwgObq0sGfdR2FVlZn3vpWm7Y+HN/t8BF
 UFuQnfy6
 rnJp412lSwjKRse1xUZXYsduEbpjY8bxFFAq4gprxYmMTPgFyKmVoHpxkHY185DPwgS0EIDu7kjgEw9LOgByC/xzrrfEDQ4GXt395nzqLiK3YKW7AeUbqGoggjxzL1+AOh7rxDGSD2gU7iivL8bVK9yxFzq7q7sEye90NBPIHobouJoqKVrGtaA3P0HCNDHPn26D6/Ym+hYc8xd+GS76/EaQ2og4VBCdQKsBHayyPLvo3xjEBWSsINH9QV0Jnlismt8B+6eSkARMKQlbrjvMi5qL9B27h/y9XJBareP4rAu1svt3ENR6Ihbo6sTt8Ku34zHKMX0DVSbzDUeHngG3+L0vDfYmSPv9mhoEdhER5z8zukl4xy1slo5pls7duZLzL73My
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 06:41:33PM +0200, Kevin Brodsky wrote:
> On 01/09/2026 16:33, Linu Cherian wrote:
> > Kevin,
> >
> > On Tue, Aug 18, 2026 at 03:08:44PM +0100, Kevin Brodsky wrote:
> >> Introduce a new function, set_memory_pkey(), which sets the
> >> protection key (pkey) of pages in the specified linear mapping
> >> range. Architectures implementing kernel pkeys (kpkeys) must
> >> provide a suitable implementation; an empty stub is added as
> > Could you make it explicit here why we are restricting this only
> > to the linear mapping range ? Would be helpful to add the reasoning
> > in the commit message and as comments.
> >
> > Essentially we are also making a assumption here that there are no
> > aliases to the linear map ?
> 
> We're not assuming this, this function is called on pages that are also
> mapped as part of the kernel image. But indeed it ignores aliases,
> unlike e.g. set_memory_ro(). Really its name is wrong as discussed below.

Just trying to understand, does it also imply that we dont have use cases that has aliases.

> 
> >> fallback.
> >>
> >> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> >> ---
> >>  include/linux/set_memory.h | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> >> index 3030d9245f5a..7b3a8bfde3c6 100644
> >> --- a/include/linux/set_memory.h
> >> +++ b/include/linux/set_memory.h
> >> @@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
> >>  }
> >>  #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
> >>  
> >> +#ifndef CONFIG_ARCH_HAS_KPKEYS
> >> +static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
> >> +{
> >> +	return 0;
> >> +}
> >> +#endif
> > Would be better to make this (linar map range)constraint on the API name or that passed
> > as a boolean flag ?
> 
> Indeed, in fact I've been thinking about renaming this function for a
> while and I've already done it locally :) It'll be set_direct_map_pkey()
> in the next version.

Okay.

> 
> > Also, it would be better to have the __is_lm_address checks in this generic wrapper which
> > then calls arch_set_memory_pkey ?
> 
> That's not unreasonable, but such pattern isn't used by other functions
> in set_memory.h and I'd rather not deviate too much without a good reason.

Ack.
> 
> - Kevin

