Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEC1C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E696B0088; Thu, 27 Aug 2026 02:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8266B008A; Thu, 27 Aug 2026 02:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0F56B0095; Thu, 27 Aug 2026 02:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 692576B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:06:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB6D640325
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:06:35 +0000 (UTC)
X-FDA: 85146015150.19.FDE1F8E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 134A74000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:06:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=atxvd2MB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787810794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFqSOaKx9Xi2yFDGQqxuznFOFvbkTjJnP1Uaos7GH1U=;
	b=uqNSOMsYGbBER5HRWo/DcGrfTBBZrXkCb6OmSJ1yVNfwpf09lb4muxefR8DDa5zW73dO3X
	jEpwsl0Vo+XR97mOJfpc1R13EPM2c/xW/jtaBHK9x2zYnuPDbqbblRvueA0+CgIkPLERGo
	n0rLWXvLX8tPEpl0CrVPyFZ1yR0m+nM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=atxvd2MB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787810794;
	b=t3yWofvfx2bym5QkOUnUbBhOX6Vq9yjqm4+eMvqw5hn3HQnIZH+lXmPUt7F6kLgYrQ/anq
	YlXS1W8URKCJHAkax+PDatRrru+8TteUnvd8xcP8prDYSgSocKj35Mi/pe9a4IUp3SzruI
	W3+dRjqgRuXxhtW9WCmWQYSaECj+Mx0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 343D01691;
	Wed, 26 Aug 2026 23:06:29 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46D2D3F85F;
	Wed, 26 Aug 2026 23:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787810793; bh=4MEVYAYSJL4cEovvPaUuVnqFB51awZSJxYddF6SWzro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=atxvd2MBYeFEkKGg88c3L5GRhXIVBg8ao3BgsUAsWkYA7ds0RiLYyyyMKGlCqEe4v
	 MOEpEcQqGd8VjOnqn4rLw1NEKggOUfl9biN2Je1oGa1rmznEcLbhjXu1/IkCtDfkV+
	 TlSm0YogFKVAPwPubmvtzGJxMq025DHHeIV/tBH0=
Date: Thu, 27 Aug 2026 11:36:29 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
Subject: Re: [RFC V3 1/8] mm: Make ptrval_to_str() generally available
Message-ID: <xj6w5re27lbtih3lxksk2jxv6kvnpek25urjjcoobwj5pgfqtr@z5loauvsw3jj>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-2-anshuman.khandual@arm.com>
 <029cfde8-74fc-4437-bc18-b1b53d44cab2@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029cfde8-74fc-4437-bc18-b1b53d44cab2@sifive.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 134A74000A
X-Stat-Signature: jrost49ijqwkqhft6jrri89qz4w1kyiq
X-Rspam-User: 
X-HE-Tag: 1787810793-196443
X-HE-Meta: U2FsdGVkX196g3OdH+ZT4U0I/EmWFk8TWF4BdUPvCC4znCbk+98naj76JOMDKKIDKkct52RmxLIc5hs6TTENoA/ffq3XeqdXH0OF9eyN34Z0Qjy4uSaxVZIXzdhRUKCcEx+5lwQk2VNPbutqkRcf1wh2ufMKfjcbAt5mrNCrb0dmPgpVonuV8+NTtIEpeBtTeCTU3z33+ECrEHt5NBuzHXTDsUw/wx5ageFhYKN6ngswMl62QDNnr4NSub6TtBaLWugqk7MVgjAjhN3e5QRTmf9DA2OOLCONkEt6F7RNlmDtoyuCi6veVDCcOny8n4wh0HT3Hy8zxzQ9IYJPDRHVHTeaX3GTlr0cfUGdzvFWI5/hMrQQfN5ZMIGHHpL+sXh86n+fyL1V+JmZRXW62bQwkfaBj3IEhd13cZ7jPAHgFylhLxa8J2Atoxgon7XxJg0XAa0XcD7pO4HgVnSxAxwGYJU5+75uIf27aTyWVKvqu5tD286JGTuD2Tcmh1CoCMEW4NhAVMrD2/Vda4wpYSh6qlXZR8RoSciF5ABz6J/RSSNKSDy1EsohyYUc2iUpVvoe2S5sLm05x7k69ZYQQnhgYf2KbJ09cEU3jUn57H3Ij+9iM5xnWyE3taF4SkS9yt384Csv48erl6VnMWLx70/d9nxMUCb+Q8UKgwBUg+swbersRk+bdn1wd995nhRUEzxv7XVvTiCZsGTWpye7+2LSfu5ZT/RBLbvBi2Kh2oPfByivI2kuPAElk6C9s+WbA9JrwQr60p5jjSA6qvqE0JDKtu0MFeT2EnZmjm0WEVFVSJb2gMO0kSQWGpIeTkxAG+WscojYQMzu+Xc6YX6CJD0EpWajXZ8zbgpsNWJWkVI+SbT9JrF9cf/+QfJzA517/nQkB65yLh652XEaYkIfGab59XkMYZB7x3u0CSJRpflm6wsyfDK4pDPiV7Mv+J/V2ea+2XsDYYGvrZKORuckypi
 YvIf+5NH
 gF3EK1Wo723d+2AS5JX+Jp6LyxdkZwY2/RIEVKHiCsGSUtmsJCvcOJ09dyboN4zg6AKYRM5tVtv6f1ipVInsMiO3L5diUTMwBVFJkeYVOx8VO50fMesQU1azv5Lxa+bucRhpibCkM1PBCGfLFCdxRWqGfZeedWxgNQPGN8Pju4KFsWzuqog73FZhQPZLr0nIRk6UhSs55JsP6NOlWehNjV0MWLb2ZsoRS2h48vyNs09b5Htr+zHNpZQiqQmw2x2eDvAi/Bcv/rhKM7FEX45CHAT/DY67cDAD+AQfBAx4KbKDYitDvXUGqKnFshNwKBn7T/tIK31WzNNy40/1ldWiwUvdNXVk5mo41sUCJKtwJ+8cBchAirMIMY616HXB048iC7dmnaeZvtq8+wzjdm9Hkw8Ox7V8Wo9Rzwf22VqV5Cs4MjNIBwZ1/3rtMPCBQTWWsFTFcJMaKvzTXavPj0jStEMfjZcyYMM4GNd6e5LcNXP6c5h/Ujy1qbElnYvsTyFLuQAcCAPntV/cyyTDMNF+TcNqArQJw0mPCX5uHTmJscadC4F2oQF7rdbS7WiEOZrM04srUIRgaKwnO1j0dUYsAEKA2YGzEo4WwxAi3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:45:09AM -0500, Samuel Holland wrote:
> On 2026-08-17 11:00 PM, Anshuman Khandual wrote:
> > Move ptrval_to_str() inside a header thus making the helper more generally
> 
> Typo here and in subject: ptrval -> ptval

Fixed.

> 
> > available for new users which are being added later. While here, also move
> > another related string size macro PTVAL_STR_MAX inside the header as well.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  include/linux/mm_types.h | 15 +++++++++++++++
> >  mm/memory.c              | 16 ++--------------
> >  2 files changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index b18c2b2e7d2c..a5b514e55dd7 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -2001,4 +2001,19 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
> >  	return flags & MMF_INIT_LEGACY_MASK;
> >  }
> >  
> > +void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
> > +
> > +#define ptval_to_str(buf, val)								\
> >...

