Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B260BD2A52A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF416B0008; Thu,  4 Dec 2025 15:25:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087916B009F; Thu,  4 Dec 2025 15:25:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF1A6B00DA; Thu,  4 Dec 2025 15:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBEC76B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:25:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 887E8B8955
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:25:58 +0000 (UTC)
X-FDA: 84182919996.17.7DF50D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E52731C000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:25:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/ts9h1y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764879956; a=rsa-sha256;
	cv=none;
	b=S7BgISmM6wUn4V8ehWQTACoqwo07kAJPq73xSqcK4q8O6Ch9LvTtP7L3SAPIrRf5QSNLIR
	4lsMcKJmcQL3isSPx7zhK3C5k5VFIU+Z0OKayTNlOPcdJbJ5psaU/Cx6nB39oNbbPhzABA
	7R9cy8BAnylcLAlcTISQ4BmTLOzKV0M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/ts9h1y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764879956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLvoncY/tHs9CfYoqfaZID8irk7E895nqjr3AYoVOZU=;
	b=uWN/9Gxc/ic4bEGit/OJk2lnGD/1AkF2U7zVgftiVweWVCHLN1hR80vb7mCnEfPQ6IMMxw
	eHniCNdPQtvsqzsulJhI+yxrVgIsh+kw93Z6Z2Q+lBYbS0cs9OAAJ5BEKI+FyxVpqm/8iE
	xOPZVLGMkTvP1mL6J0lGEyUmMSSSLzo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08EE76017B;
	Thu,  4 Dec 2025 20:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B6DC4CEFB;
	Thu,  4 Dec 2025 20:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764879955;
	bh=kaPs0IQaF7S1VKck3FZz6uJuYv3S2JC1BT6Tky0WNBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/ts9h1yO6KJK6fBmRkUgCRFbLgOKPgwRBpvdMm7W5xS9EmK5iebZlcKqTo2jyx2L
	 Ro7nmWQaTVjDXmyjjNd4fzNLHtn2FfViF92pIX3od5R+vnopde+GbSHtdSLEleZvlv
	 C55Q4kRI1a9rdPulSxXB9pH+qmBtWoX6blshzuG0183Dds+kO++CfJzx+Q+gddIv+y
	 GSpM2wFbD8a7at6iSPH5GOL1iPEU05fJgs7oNext5Eu8eOUZjv6MEckThfwTYk4M4B
	 acpwg74GxE5yNIOnQbi6acGvlFA0L7cCpweWRexjPD6c1KYUwqVo2N5saAJeqQhJ+3
	 o9LATwSnjw1TA==
Date: Thu, 4 Dec 2025 12:25:55 -0800
From: Kees Cook <kees@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Miguel Ojeda <ojeda@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Marco Elver <elver@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	linux-hardening@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v6 3/5] compiler_types: Introduce __flex_counter() and
 family
Message-ID: <202512041215.44484FCACD@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-3-kees@kernel.org>
 <20251204085435.GC2528459@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204085435.GC2528459@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E52731C000E
X-Stat-Signature: 6zdc5dn7doghsw4te4kas6jryy38nmcj
X-Rspam-User: 
X-HE-Tag: 1764879956-181120
X-HE-Meta: U2FsdGVkX18S42K+zsq9OotAEsGv5Esi9tFRnEvly17SiwBz5GCTncfQ6ck6tr2//J+uSdVEjBNrwOj1sKwuROJ8Ukw5mYXWnVWTQxHYQpFD1BIXJX7ej2FOsXqcibOblT5iTudhe0bpe70oO+dk0bzOPunBPlQYtWL9422tLieAAxRzQyV5hp5u/cmxZD8SLcdCrd9EnflMeE1oiNvtGo/ns5y9GyGrjhotL2SXRDdZFwuwIWkjTgpAOQ7UEUkjrr4SyxolupZ6ZSsH8LzGiMp10pXfdEMtegLeNE5f91ZuKqqmG0vQW3Pj8f4jjjrnP2Ng4qaZe9KUvtzXAzJF/GQ9J5UakAqAdxdneVOTzJeyMMlQf4nMniGQSPxltzdag4EeZ0hofLkAsMmli+A+6oPKp8mZ8FCGUwreENlrwTaf/EhDL11zBCNEIS2SzoUxhJnhhDM+70zNelYeaLV2q6aMtgVMjPSFDRKuQ2Ot551dZarcO3UtjADpSEm7vm5AEI/N/HhybAqyL0GjSgAc4fAw4ihoxqLUrw2FkyRDlX4Q4N67xSqWhBO6JZLdy6DOYR1XeFs5t8nbTJCkpB3qOi5Ra21c4T7nWrwOujyFDRCEZlKKTYTIUyb3UoKKY9ZQHH3ZqZbeECdTvDvUOrsDFwjSwInV2iUK8ptonqSISs7uMdN9xuKZInMk9jjGnhb8bNzou7TilIHQ4t9zp/c7c+CkeKXNNNospNE+/zWHf+LPx0BQqCdaagY20BR8l0p8FX2Ck5AsMf1TvEtrhSdARr0eFlxdfhjG7XzKfFwtF4aTufTyay6pVfz04k7zRZQenQw2wXRKC9p1AmMLsgC7NiDXJwMRMQ+ZGicHMvOVNdvECjME1vUAhDvzwixt6TIdq3tX6Qj37ZipLGg02Dc+iDnoVakYVly3LC/VI+lNSBbOoiHa8KDD2OXtAHkSjDnId16hU7ZtVJ54tqaSaqR
 yh7h2E4o
 Ddyzhga8PsmYkIS90kcy0Jsm09BN8RLh6mEGUPzsdYPauVuaCFIQ+xRmsGj679dpB44XojhdJLUE+bSGB2oI5NcyQwUGRKmu2XOM5j8xVNuR8zukEYnQyrfKWIa5bQ5ZoJ9GwkXY0cRUzbmxz4B8TJrgt8ERtxRCoCDk/i7jmA0CovhZohsoNb6/5laWkqWBpQaz64ItO9ezeGwuBpbD3W3Rt5QSoKXZC6a7JO2aSCW3HSDFaHazPc/o5KHz0pjI9YfT7bpI7c4GzA5C6yhWKaEzP/Ui58pulx4uQXfzhTMjCUuYBE5Isl7ZoO965XdbV8/ZBEzUa17LRPeNPeR+6/V8OYo6JuZGUU0DZcbu8Stb6+I/4V9MG/5/Q+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 09:54:35AM +0100, Peter Zijlstra wrote:
> On Wed, Dec 03, 2025 at 03:30:33PM -0800, Kees Cook wrote:
> > Introduce __flex_counter() which wraps __builtin_counted_by_ref(),
> > as newly introduced by GCC[1] and Clang[2]. Use of __flex_counter()
> > allows access to the counter member of a struct's flexible array member
> > when it has been annotated with __counted_by().
> > 
> > Introduce typeof_flex_counter(), overflows_flex_counter_type(), and
> > __set_flex_counter() to provide the needed _Generic() wrappers to get
> > sane results out of __flex_counter().
> > 
> > For example, with:
> > 
> > 	struct foo {
> > 		int counter;
> > 		short array[] __counted_by(counter);
> > 	} *p;
> > 
> > __flex_counter(p->array) will resolve to: &p->counter
> > 
> > typeof_flex_counter(p->array) will resolve to "int". (If p->array was not
> > annotated, it would resolve to "size_t".)
> 
> Uhh, how will this interact with the proposed extension of
> __counted_by() to normal pointer types?

Good point -- at present __builtin_counted_by_ref() only works on flex
arrays. I will ask the compiler devs their thoughts on expanding it to
the pointer references too...

-- 
Kees Cook

