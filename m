Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F042D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C083B6B0088; Thu,  8 Jan 2026 12:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6336B0089; Thu,  8 Jan 2026 12:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE536B0092; Thu,  8 Jan 2026 12:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F31C6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:12:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FFD41A0163
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:12:12 +0000 (UTC)
X-FDA: 84309439704.12.C255111
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A3CB18000F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:12:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o2GlYfqj;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892330; a=rsa-sha256;
	cv=none;
	b=IjMQSpWYPvyeHc0eWJozZ5IjcHD4IRDPh/2lQNfUcY5zDuftXP3LIka0diZGxQgfaL2Wev
	Vh9XL93V4iUoHSEwNYWr6TYH4Y+PqzG/EEtcvBYU3r2vpP6pZr0zbpAk6O1qH7s6fO7pnu
	ecYXpm7r9qJ2rM+6TxErbYLCJiU0JNA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o2GlYfqj;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2anQxHlJ4vz5zwJhXe6vczATuor63nEvHniLjHUI+I=;
	b=2NRxk1FwWb+pt0vSzKsFXsIo57sAq8+fdsDfvh/dAMHsRqIOG7NGfbU9BKB745mUF+KHll
	QUpMqRzDpj2VGGvbwWik/0NE4yk5oof/ukwTLDoHHIKiDfdTJ9WoDAVgQY1SYU4gNm/qzK
	5lE+eRBk8eKpVolEfa1jgAja+FCllg8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFD5F6012B;
	Thu,  8 Jan 2026 17:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89280C116C6;
	Thu,  8 Jan 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892329;
	bh=LetoQP40gZ1AyG9X4BvpWxEt04ybOeOdK9lGPopip2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o2GlYfqjWCuHEGGgPcxNvy20Jt31rvHXCfJXRQrxEnRZmM6qC0Z/RvgY1k+nr/ypH
	 VWP1GfA9Pdsir3ysjvAX13fGkwKstN6C5+WmdGJuX+hwHwQtUQezMEqtJc3ZevEI/b
	 R0DbQpsk6s0CzpWsa8qn+wc5iau95SCa9SCRYtVf0074JEAmEBUjGpH+hYhqKXG3Ms
	 1gM+NaEq4K/ZSl7dAlp8jxJZQ/CDtA7edAqd0EMYyPV4ljGfBEVIUakuASb5LSlwj/
	 oSKdz7rpTwi0YuRuuMv2WoRTohxFNB3XSHdyYZ7HBu9WsImqX4JtigaxzI12VH906r
	 sRqyZImoMZ2+Q==
Date: Thu, 8 Jan 2026 09:12:09 -0800
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Message-ID: <202601080908.398D2129A@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-4-kees@kernel.org>
 <f1f06db9-a12c-4999-9723-1fca5e8383a4@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1f06db9-a12c-4999-9723-1fca5e8383a4@suse.cz>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A3CB18000F
X-Stat-Signature: jqb4i7p483553cpig37jeoc88jzx49zg
X-Rspam-User: 
X-HE-Tag: 1767892330-127377
X-HE-Meta: U2FsdGVkX19wqFohGmKYF/ibVQTGkPgPwi7zqdRxZN66UzhBbZ/+On/SBXCN/SkeBeP/ZwCyvmX9qFfncNK6hpWgXPnG0MPq1qjKdkvK7Kh4uIrcM3eKA0FK+SIQZevfZpzVyF6HjbzW7UxBZnKqxYXfQZViiDf+8mvOjexEZ4/NJ+V7xyVhgrQ0epeONkriiKIsDt7TJWCUF1YXJeu1g0cm36OZac7gJPKMqFeHGGyKCCPq6MJG0qsz0W8Nkmgre9ncCNRYaPkI8bX5d6PZkHhpggBm5CtTMIHZHjqpufTay/EvHR5C2bMPK9Cm9N95i2bRYa9oQIFn7/8wnAz4wg16j0+szjLaJCqgfR9BeCQq8cW0ScVvnHECwucnNMLickpNv/vrJ2kmElCTXar/C8t/cKNmZQ9kzPs7/sjSlsVtse6As+ekR0Rxm42cbDDSvO8LFOggBVUhOnQl1d+H47MvyxOZotVu8r0TfU/UaiUWxzTGqrVVPWKSyIYY03LuDWvrfPG6khNm4ywJyIWgZIMcFVryshm58omVdi83FRwW+2mCB7cZvJAWyYTtuSSSCielia5yAqQhifARywLkKR1SmPCBUBjyGqW/bHdxRfQWlqLC/x/qReGicSZodBpkIdATnCnVQAKy5anNpy8Lk9XubZp5rgjiwyXkGCv5AhReyngzlWsAxJXxIGSr9Ph4wMKpZNOocsTiJkKblt+sege+mxs3cwgZHGJZT/VDMUn6/6tex/pR7KDit+bX0cLV5ITWLy5tzMQTS06lVdrotNLTqTdJ7x/uW7O6Q8PoKLlM2FpJCAYOEeDh63mdIbOk0PpCjdnlCEOB5BguQIK3+R7KvUrtx+bEvUsYDFucSp2xRjLLGAo1bG7cCM//+kpieLz+liqaZLzsSNzYz1Vt81WHfE+m0it+GeGB3IcS3EMxjO/RLuqeJzrsftliReMcfW8CxVQFiJUj4N4XxLe
 /WpwQqvj
 v05jsQIgVeXHaAbeAIa8zWYKy9j37pr4Qyr9MuawwZZqBbyve8qvACFXkzu6ZeHcef2cJbKy46cs6Z1oULDjjnSkEnnnKX3yL4+tpY5IZyiPYPyScRf6uC1Ah3OXKiYMPvXRgKCXd8aiMeHd/Ccj0mfx1HTwcPpAALDJ9ad/yyeYk387FFuRhtH1z4MP+gHjlB/RxPgDmYn2GpOP1PhaNN6RRW+XjteM6Ohbq3+Rd04xg40a+ufMb1wHI1xWecfxEldv/RtxI4plxzWJgFYN07bTIxDvOXsItNQ700EU3eN7YBHmFfipWaO8jNOxJ/PTM5IjeWwvlkgQPsCrgDN1SOesVET/c8oNuB/r1rk+xDe0Tt0nBXMGeRAVziA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 03:06:31PM +0100, Vlastimil Babka wrote:
> On 12/4/25 00:30, Kees Cook wrote:
> > As done for kmalloc_obj*(), introduce a type-aware allocator for flexible
> > arrays, which may also have "counted_by" annotations:
> > 
> > 	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
> > 
> > becomes:
> > 
> > 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> > 
> > The internal use of __flex_counter() allows for automatically setting
> > the counter member of a struct's flexible array member when it has
> > been annotated with __counted_by(), avoiding any missed early size
> > initializations while __counted_by() annotations are added to the
> > kernel. Additionally, this also checks for "too large" allocations based
> > on the type size of the counter variable. For example:
> > 
> > 	if (count > type_max(ptr->flex_counter))
> > 		fail...;
> > 	size = struct_size(ptr, flex_member, count);
> > 	ptr = kmalloc(size, gfp);
> > 	ptr->flex_counter = count;
> > 
> > becomes (n.b. unchanged from earlier example):
> > 
> > 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> > 	ptr->flex_count = count;
> 
>              ^ flex_counter ?
> 
> But if it was "too large", ptr is NULL so this will oops?

Oops, yes, typo in the example. I will fix that. As for NULL, I dropped
the NULL checking on both sides of the example just to focus on the
differences.

-- 
Kees Cook

