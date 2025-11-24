Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB72CFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0246B000D; Mon, 24 Nov 2025 16:33:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696E36B002B; Mon, 24 Nov 2025 16:33:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4996B002D; Mon, 24 Nov 2025 16:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C61E6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:33:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19A37BA3A2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:33:59 +0000 (UTC)
X-FDA: 84146803398.28.D0634A8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id B7BB640013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:33:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VjaCuJvV;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764020037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFlI9oMmK8KOch+nom628TiyApNTBVZwzhoepQIUmfg=;
	b=ZIv96i3jF6ARJOXpYEDqHF9ba12sMJ3ODaGKzqQkiC42egiTiVtSnKfgUIxulERmEwkVo2
	zhFeZ3Qy4u8VjlE5SvFoQivxNhFgwByMStOZhlwaukRQE2S3vS7F/ToTCERbAyUkR8s/6G
	JZPx0RuDzOz3ft+LhetxDl+9vRj38DQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764020037; a=rsa-sha256;
	cv=none;
	b=zj2Xl8jJdLRVVLjJI+E+WDyS+3edFVfsGmDB2oivicmxWQjYz40vK1bCjpp2QnYDHKZ7jk
	68Ku3tPGZtZWH5Mfe+vR4BOJIT5MTEowzK85sB89xf/Ki28FCxlCWmG3xk9dV7EwYdaFFk
	NZ2LGzYw29hpw0jWue+B/2KbncAf8Sw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VjaCuJvV;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=KFlI9oMmK8KOch+nom628TiyApNTBVZwzhoepQIUmfg=; b=VjaCuJvVsCAUOc2cB3tGbSpLHp
	TEnpEW/iiCPQdHEu2kvEiksTgQw2JR04LylC1eGrJyWwfF6H/dXVC/DDsSf9qXo8JVX98ggTyDNj9
	TbdAJWjPoGoKwvlzYdgysxdjeAZA97i3RDQCWN63bnAi0RuK6IzKNzdYMaVBEikTUsRPT9v9zgdvo
	m9yGP3fNQSMq2tX5JOF3wgkX6flOHuU8oPstj1+wH/jIjJMYB5Gd6AMt2ej0dxAUMd4iiAUnBVNcF
	gFBh04tustsd5kN6hXTAvMVHJTuxINIzonaGGaFFIhF4iX0ImzeAVac1J8mfTPP4dNG3lZVyYNBEu
	DbZT0cAA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNeBu-00000007ZJQ-0Ejv;
	Mon, 24 Nov 2025 21:33:46 +0000
Date: Mon, 24 Nov 2025 21:33:45 +0000
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
Message-ID: <aSTPOYLVzgkWDZR-@casper.infradead.org>
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B7BB640013
X-Stat-Signature: dwhxibkfo547wzm9a46mbo5yjwgbrg3y
X-HE-Tag: 1764020036-318700
X-HE-Meta: U2FsdGVkX1+9KXWfTxE6o8JlBPphnVXv39jSv9ICI/Pu+k8lQ54cfMWSrBntauKeWr2MeU7lZs7dF4M2q0L9FaVdMEoGC1aIj5xbK0Y/wtIMWzVYFLhawFp3STHed4Hf/yHeOxOk2Xv6R2jF0DxexhuXlNsj3D8sRWVdb833KpcTvHrFzx2ujpOrso2UcxZTplOGSJ8QqCQ7gjKP2be4Zk4G9ng1QpU+P62MG703drpxbgs6x/xi5FlTaNoVNyEutnnjxBQlv49rxpKOwxQUD7M131A2+AMUVXLwZVGUq5OMq+WQSm5btbJZkKbyFUHhI8HCX1P4kaV18H7UeCAY/yEz0X//krxW+mcXZvGDHaGzlA7oRhUfZK3gRIRhV/3a5vOchf6X+/A+OLckA4SDx60ahlKtM6xA0pw6mAWOTSmTQpo2gTplJiwp80mlcVROV601p0mlRfVAZS0hvnLoL8ZDEf66RrPqjCfYqFOPLp77eUvP94Dzm4Co7x9fE3ok12kXsChHtG/xINORRnDC4CqNd+3GVoSyfxlINEDzn/pdwDjsYzr9+mdrjlA/908bxzNQTsKFlgJ9/J7EC+yhuHU9d8UseSLweIfO53ZkuZb49QuewUiRdxamkqHYItNrnTyE2m4qkzOT+KqBMjRcHg/T7Z7wZLRNqPh3eojc+X6mqETMtKXCsmgM1Ut9+kg7ABcxyAEfFXFpQFogew3JG05B3JatvLcfEEYvis4WSQFDQkODg9hWkuoWGoOv3ifiO7Ypkbl1ggJwGrKA7eaI7HCTtHC+0MRW8by0D+R422NCT2ehMhHib9YVSUUo26/iwGJPR7XZzz23Eir/baGtdjSCgd0ClXYo3Jws8uI5747QNn6BcMp3yRMaOV8Wx6e/05EABkTm6W6NnKP3L19y1Fu+g9zRYDN4Lx8iPiUMKw1+4hz1ZZ/WojjypRM6dL0d5WfNiYtG3ie7eodqBQH
 95IFhlMZ
 Yk9lpCLyquWSj60Eh2sP7YxMJsLXSTAbOWkFt18GtIyNz3jB9VXfrFNakBNeRLR2TERfciiDJCXET4Oo0Ol6m/mXpPrwh5q59CNj2rQUL4qR1yNblvj509iZgavFq6qeEkmAG5hzWP9rTTsgx+ncOlYvcbYCwCpqWVHKm9plUX7Q+ubnhtMpvY3GMwI8Qw8Cj4zFr4zacLrie7PC5jy9rXOvzlpxfScBJYiBPkWQy4AQL534D6B2hQZOI5J88HCZxOAxkZ65cMBXHltazTkhcvoBVXBweNCmmOJlJBbp7zpLPVoiEFqAnHi7RSBmAyR3G1DJC4UgnFFIAOqnstQRsBQZCkU1p3QJv5lrjcYPbtvmIjSPKNIUkPb+M9ycOw31Txo29IUcc5vY5gfiCErdqFxsi+wUIPdVeJQV198qw5Xh6xAkdMVI33dTWjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:20:21PM -0800, Kees Cook wrote:
> > Maybe such a warning already exists and it's just too noisy to even
> > start thinking about turning it on?
> 
> Yes, -Wconversion (W=3) is mind-blowingly noisy, unfortunately.

It looks like GCC isn't smart enough.  The first warning I saw was legit
and easy to fix.  The second one is bogus:

include/linux/err.h: In function ‘PTR_ERR_OR_ZERO’:
include/linux/err.h:120:24: error: conversion from ‘long int’ to ‘int’ may change value [-Werror=conversion]
  120 |                 return PTR_ERR(ptr);

But GCC can prove that this isn't true; it just chooses not to:

#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)

static inline bool __must_check IS_ERR(__force const void *ptr)
{
        return IS_ERR_VALUE((unsigned long)ptr);
}

static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
{
        if (IS_ERR(ptr))
                return PTR_ERR(ptr);

So GCC knows in this path that 'ptr' is in the range [-4095..-1] and
the conversion from long to int will not change the value.

I imagine that fixing this is not high on the GCC developer priority
list, but if we filed a bug that might change?

