Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DC7D4335A
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 22:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9606B0005; Thu, 11 Dec 2025 17:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153B36B0006; Thu, 11 Dec 2025 17:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AF16B0007; Thu, 11 Dec 2025 17:00:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCBAE6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:00:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C2BA1A036A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:00:06 +0000 (UTC)
X-FDA: 84208558812.20.94F7F8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A14480005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:00:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLgG52d2;
	spf=pass (imf02.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765490404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3fqfXyDSrCRZXs5nkveZ7Ixu6k88TY9NIyx1hqaFfE=;
	b=KJs7BZUhdA6JFKsovF0x08+AV0tkZ8ViTswVn2Pf8NCzHAY7Zwe4dYljHvZFgf+9kMWY2Z
	AiNYrOzGZzcmdoG1eMyv5f47BiiZP5DduLgumgHYcZFErFGi5VpU54WqCw43FjNBW5a6vD
	P8nMDRSy0VQEQiGJ2kczbUHR+pfYAv8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLgG52d2;
	spf=pass (imf02.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765490404; a=rsa-sha256;
	cv=none;
	b=kwEHavli4ffBkNBsvEMGrSLUIdrQg6YOtJopbG3tKzJeiEoRkZ9AZGcia5powIN553VS2R
	PyiVoWnvCu718+9IK63wNJ2X8xjIxvzmypUB8ShMRfgfT29lTNnKV+S1bb+BOzKdIFkKpm
	V0pUchgOB49G5Z+Pi3NYSkMn3RqdVQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A111F417D3;
	Thu, 11 Dec 2025 22:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1F1C4CEF7;
	Thu, 11 Dec 2025 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765490403;
	bh=UvpgNVZQBWlxwITboFxyD5AfPO8Qk05RYT6bTgKrZ7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NLgG52d2/iqu1sxj7GYeS2a/Sxw8ThW6asIItsBe4kdxmkTf8muRLSxBmDfDUTeAF
	 guQJFMWlzhh11fUv6sxEdcmn/B9+GrK0YpJUOqE7A5THK68fja/llOeE22CgM8PLgo
	 56ivDIlpPa8XuqMLyAPrOmA07fT29ybf+hXS1MRhbIdq0+qLFMIPntyOA4br2g9nha
	 PCNZe03aSRsb04tEgRdKfNkcDlc01Uvwi75gsu7SDAFpyCQM+3hd9aroWHh5f8wiXU
	 VShVo5/xMhwkWswOD6iQteeJ7JE/5mZy7VLpW5MosqnduOK9I0Bm6h1O7oc4PJK2lY
	 5X0kyKCamIa6A==
Date: Thu, 11 Dec 2025 14:00:02 -0800
From: Kees Cook <kees@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: cocci@inria.fr, linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	llvm@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Jakub Kicinski <kuba@kernel.org>,
	Jan Hendrik Farr <kernel@jfarr.cc>, Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Justin Stitt <justinstitt@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Pekka Enberg <penberg@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [cocci] [PATCH v5 4/4] coccinelle: Add kmalloc_objs conversion
 script
Message-ID: <202512111352.387A339CE@keescook>
References: <20251122014304.3417954-4-kees@kernel.org>
 <71d406fb-9fb1-44a9-912a-7a0d270b9577@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71d406fb-9fb1-44a9-912a-7a0d270b9577@web.de>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A14480005
X-Stat-Signature: uy7ncreuxxhdijoyta35tduw1d8qw96f
X-Rspam-User: 
X-HE-Tag: 1765490404-21162
X-HE-Meta: U2FsdGVkX1+JUNNrA4hqYDz4k1vQUGVOqLL6BKxSxpDZtNZhV1bO/iPwLt6xqPG6kolcRKlRgRvbNz3ROhKNyx39dJBOHWuwqQjj+sp4pVtc0h/3CGSBeCNisWa0FNKyfjSjGy9LzGV+lJLbclWSt3C/1glv9LqyAoAfgDgGUp5GVpP6WSGOOuiw8NsKunZfx7s+DnnYlwkObLzPdUc1LN7sjtsxIx42VGhivefyiLQJGzgLIW1Sz3fpQLI1KRPUzNQ9HftOmiGcfrqC7Hc1U9sOQ2/K6XjTf1roEquOYqzCAjT8ytsMZ0Su9xxj4GlempKNjslS91cZbz1VHB3QFOAKEvB3z1fu4RN+ZozPn+3dU+z7w0ZUyQ1G004B3PgR1K++n9wV4X6KbKPqxgKEYXyjPkGdgQ2lOg5bpaTL6RiNrI84ia5fy6ZDNiC6GQbXf4EOHrkMMBqrJ5wQx5kxSzWIqCaQ3WUoscEFQE1I0rAO+pCrYp+MdbpHpo+zLNcdZAN54pClZ4VkQqdCNw7Zv1V1zxnXlnI/Zg4klX0aWkBOpdsiIfOFS1PK7dC5fgMphVllHUnUcAGW5K7dNdTwHuhDryRCHlEjBUwiAmROsliPDvw/AElUuEE9La4JX2yn5H1yyWf1lscSBiutAKL2HqoJe9yCUJsyU/E82/Pz/D5iiFkQeHwo2D2mjTIXwYoT+6MUO/dkwMPM2yy36kzidmDKYYrfqtldxaxW8XRm6Q+CrMEdCxJz5jfaDgnREqnKMwhWxDTv81kwxbUyP1IUg7RiIC0xnkUTkeBYQdP/2HhaiTeaNxR3vK+q5+FJ+gGg9RhgjtZFiZPaJWBzow8NhGNK7ajBPX0TvCQM5cHo9BAZ6x9qcylBHAQQl7RFxcPH5R8LLVa/CAF7KrqPEkSKswPsq3XIYmSfTM+jmJtjQBhq+9chBQilml6dtqZ31/wP661HnFwFtHMKE4C5hva
 IsxM3nwd
 vpVX0nYWbYbbpSgFH/TuuSES5UTlAc7hb2HCrcXXYp8BFDaLt1inXUUKoCAhzLY5jzEiI+ch6yeNKX/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:50:23PM +0100, Markus Elfring wrote:
> > Finds and converts sized kmalloc-family of allocations into the
> > typed kmalloc_obj-family of allocations.
> 
> See also:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.18-rc7#n94

"Describe your changes in imperative mood"

I guess I can try rewording this, but it is describing the behavior of
the script. Normally the imperative language for a patch is about what
the patch accomplishes. In this case, I've added a script and it does a
thing itself.

> …
> > +++ b/scripts/coccinelle/api/kmalloc_objs.cocci
> > @@ -0,0 +1,168 @@
> …
> > +// Comments:
> …
> 
> * Please omit such an empty information line.

Agreed; I removed this in v5.

> 
> * Would a field like “Keywords” become helpful?

I only see a few using this -- what benefit is there to adding it? It
seems redundant to the rest of the file, its opening comment, etc.

> > +virtual patch
> 
> Will additional operation modes become relevant after clarification of implementation details?

I am not interested in other modes; if people want to contribute them,
they are welcome. :)

> 
> 
> …
> > +def alloc_array(name):
> > +	func = "FAILED_RENAME"
> > +	if name == "kmalloc_array":
> > +		func = "kmalloc_objs"
> …
> 
> * I suggest to avoid duplicate variable assignments.
> 
> * How do you think about to collaborate with the Python data structure “dictionary”?

I wanted the stderr warning when there was no match, but to return
"FAILED_RENAME" in such a case. Using a dictionary was basically the
same length as the elif stack. If you have an alternative, I'm happy to
replace it with what you come up with.

> 
> 
> …
> > +type TYPE;
> > +TYPE *P;
> > +TYPE INST;
> > +expression VAR;
> > +expression GFP;
> …
> 
> Such repetition of SmPL key words can eventually be also avoided.

That is true, but I like having them separated -- I find it more
readable that way.

-- 
Kees Cook

