Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B59CFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28F26B002B; Mon, 24 Nov 2025 16:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA266B002D; Mon, 24 Nov 2025 16:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC88F6B002E; Mon, 24 Nov 2025 16:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95AE16B002B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:44:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F8BE13B437
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:44:30 +0000 (UTC)
X-FDA: 84146829900.05.BBF1C4C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id E90AD40009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:44:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iYS4s0Ge;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764020669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUlF99W657ayuADOKzDUmOVkCyncPMqxdy/NyyNnkH4=;
	b=L7X6fgWHzr9xUi+agDYXUiOLBtKOoA0tqUreaLh1BKoNVI5rtS0Au8UhNzkaSuGNv9Ko5G
	iynH/ZDmyds9NQu1zLSDngH69n2k6qlKrnERSiecVB785u4XDFbmAOip5wteLf2sE9MYp8
	LbL2FeeXvNlw7oQK+ri+a5xcvxtZrVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764020669; a=rsa-sha256;
	cv=none;
	b=lfM14vgbQXtEu5PDDLM6IDajei/M+ARv5ceEjgI7t031/nr3ljR4KSPOGIG+k6lU5xWv1M
	5i8dEIdO5XZh9KA/soLadd7EHQO6Fpx8GHwIMATREonOHYQQjFvVtlaFy72KuvuewE4fpI
	GEiCPzk6/ujpcMKIfOjaEtrzswRJ18g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iYS4s0Ge;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=SUlF99W657ayuADOKzDUmOVkCyncPMqxdy/NyyNnkH4=; b=iYS4s0GeWS1ULvqQotv3tAHC8R
	xxqu6rXYTNSh/Cju3mOVXHckGXuANK4kN0epUwZo4hJ/hnHfY9O4BDB2S+WysWiuMouXizQgvY8rw
	F7d0p7NOnwi/gos09F3Evi6KLDFoy3B2MeTSWybXlMZxi4s9J/vBqvfnBHR5yMzEJnoDjqPd36vpC
	yMxpAo4fsBx5NlEptnHooDmU0MGJ/5Q7NZhnZexoavMzCOPNt1FrAqkdV2D6uXf80IH/rkh/Mj9CH
	TWcxCcrLU9SwlZECIYN0U11dbbjzH/bMalezzpGAYGt6jIzBa4MYmEXtyS7sNd2Hb+DaoJZnf6v1u
	luqhvyHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNeM4-00000007a4O-2Sbg;
	Mon, 24 Nov 2025 21:44:16 +0000
Date: Mon, 24 Nov 2025 21:44:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
Message-ID: <aSTRsIUPeT5EC5An@casper.infradead.org>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
 <aSTKLsRNiEKtDqPI@casper.infradead.org>
 <202511241317.516BDE7B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202511241317.516BDE7B@keescook>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E90AD40009
X-Stat-Signature: dquod1usimgqfidp48r59a4mxswmqrfg
X-Rspam-User: 
X-HE-Tag: 1764020668-277648
X-HE-Meta: U2FsdGVkX1/m4TSrPz58h05/wG3H2sWc3DbA4Kt5P9yUAoDjQ21nyeslCjkKNPZGNELzzxx8s5DCdnmmpQEwJ5cifPTbF9Rt+YdeYzNJkMDU+qtbTVRV+c9levAcKUFHqT2USrp8fdHro8ZN2XI3KJmo0gJnJhnGda/hcirOrPeH8oVPMCOZ/f/2ae7HVRrAD+0JrKEESwjp+kas3Iy8W5zyMwUJos6bD2V+QIjqG7h2SI3Ans7dZ89ozeycmF+3M+jNsxBBvOsJfwVCgBqR+6aWbS2UAuG5eQi6qjkiNdd/UeHOvUPu/E7d0ravxVsZ57VEWUiXPyWNxU5QwjbMVPJ/ZP+Crzoue3ippG4ESfRmAVD7SMBmgmgdiIsHl6I3LlGwhJqdy3eC5kYh2XBy2EH4619PvexnGzm1IPukBOIkMRlwTIZXq/FjBawKUSDTfmK3jCx0oLEv9kVcBzVjokWaQzw7Gw6OEXjo0Lhbg/NNuJJsfVK6VC20OyM3yH1mUzpQOmGbN0kl4V3E8MLvbzv9Tqc4iUInu4LYt6G4yVqa3rAhNrgkdQTvP5WcLZYxw8CCmhOdBLGj2N7DO7FhS24EjTrT00ZBbHazAXdY7o4PHGcd/MkHydbzVJf33bGX3WYTC3KLO7AIfMUqqi5Vh0lCef/KwWcxrpE+4VY+km73ewJPNGlZhkpgUBSVYmtz//HLteOYc4QNlxhhVcnvEPktuK9ce8lCuut7yx1GkMgy8okPNijMRwp8z0dqEOXzd1AkNHbiHEOEUpXOEcXEg64/XE8I0Z+dwtawaUcHbUViYzsYso0j1RbYv20h6TcVEFtsTjkSE5qDi4UYjCjrxOTDkDjByI3VlZN7FNKaiXLswJ98hWu5CbHVny4GQ/TGkTFDAGVqjqwAW1xaLf/yjn41S0zPNtReRTphRIU7YtfnQW0QRg8LdJaS8uVBFXI5ywNLwydxPaKH4aWnYkk
 P5L8bAII
 bkqV8nUDNNd8XhZd325WLFPxD/f1bqond7RMvuEkyIB8Be+EREmnGFSdA7WOV7VjoU1QQu1DiJAx5umMId8qsf+NbRdS5XcU8LdH143S2kGQqaJG3+b3OrsChWtkiBonilZTJLZCmAqhnTprsEwtBnBmxUK6P+BQc9OuwivL++1I6qYwbiyT9WkLjHV5Xhl2SNE2rqGyBBUnpjO06mfG2KAI//QafIaFkei0NEwtOGrPqwmkBT8l0OzUi8QPv6xCeBBMbcujN7R8hu1jQwvbAjizj2gQg6VVr0HYryHM6rtq/Jpc1e6q2jjss/YW07hhWB+elJLgS3C/QoELiWGnBnEuJSt3sTG/UGGXj7pw3tDr5GQrptBGV8TecW35qJU2D9fY+Tju+84fQ9nVDf7o47tbzPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:20:21PM -0800, Kees Cook wrote:
> Yes, -Wconversion (W=3) is mind-blowingly noisy, unfortunately.

This third one is interesting.

include/linux/jump_label.h:126:44: error: conversion to ‘long unsigned int’ from ‘s32’ {aka ‘int’} may change the sign of the result [-Werror=sign-conversion]
  126 |         return (unsigned long)&entry->code + entry->code;

static inline unsigned long jump_entry_code(const struct jump_entry *entry)
{
        return (unsigned long)&entry->code + entry->code;
}

The warning is ... not the best phrased, but in terms of divining the
programmer's intent, I genuinely don't know if this code is supposed
to zero-extend or sign-extend the s32 to unsigned long.  I know what it
*does*, but I don't know if it was *supposed to do that*.  So I wuold be
in favour of enabling this warning ... if we have a small army of people
on tap to get the kernel to build.  There's 374 lines of errors to fix
from the header files included by scripts/mod/devicetable-offsets.s alone.

