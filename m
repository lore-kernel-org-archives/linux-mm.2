Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD3CCFD355
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2BE46B002E; Mon, 24 Nov 2025 16:20:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC9D6B002F; Mon, 24 Nov 2025 16:20:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB506B0031; Mon, 24 Nov 2025 16:20:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C90986B002E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:20:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63518C04F6
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:20:24 +0000 (UTC)
X-FDA: 84146769168.17.B107794
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF94540003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:20:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekqcbge6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764019222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4JgFORQ4lI3CHQnttAjPtIP896vDjPpqA//MKwm16o=;
	b=PjByG+runLk79BffCPSs9/plVWeZPQOCsAHR1e5pK2DFS7VMyOBqPEpY/1zN3ceijUdxpz
	9ogHgTuMiiXtESV/uTfiwma0+gLeFqxD/L35DyGn9Ad6famCUhna5NERO7StuAZhZSoQvW
	/px2fDn82qoEvU+ZvBuA+9csnbuGNlk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764019222; a=rsa-sha256;
	cv=none;
	b=UNX2L4KOELbhjeKDwGYHeoJqLq0olCEurkMjogrV5ssaBJP0vcbWcyMco5JWEZjw+H865n
	po9Cz5vWxhDtUNzR6G7kNN81n4W/LaEATCwfuNlh+d0a4COG3uVr1KH9jYSn5xiIv98arE
	MJHOt7acs8NA3tS5ggZXrZeaP8SapbI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekqcbge6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12BC36016B;
	Mon, 24 Nov 2025 21:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B34C4CEF1;
	Mon, 24 Nov 2025 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764019221;
	bh=Y94JlBIHLA/laoTq4h3TEpMFWZb/beHXXRUBICAqz4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ekqcbge6rAcDI+vCK69msAZ9ML3+CijFroR0b3AHsruJPJSvQ3noWvLTMSnppkKFl
	 qXFyify01DoKJErGd0BBVdT105e/DEHg+sxCdybxEwiR2mhdmrcxeWnKu5ccjRczsO
	 DNtfhJTJTxDkZNpH/0Gld6cIW5pFWKnN+GJHBT63x7sNsg/owugYAg10Ujmsn2D2xJ
	 GdWhpkUqmbvxF6CZxjW6wV+OjEvSJRer7UWpG8RrLHChBv/kQWP/+Lm33186vc87VV
	 BJuqTDJYc92FShtapn0/rmaoXHEkZxZcEDW3BJt6KnC/vP3D5RSaW0qntmn7G/CvoJ
	 vpDa8V0/Ngkmg==
Date: Mon, 24 Nov 2025 13:20:21 -0800
From: Kees Cook <kees@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
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
Message-ID: <202511241317.516BDE7B@keescook>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
 <aSTKLsRNiEKtDqPI@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSTKLsRNiEKtDqPI@casper.infradead.org>
X-Stat-Signature: a4q5z1s8b9zfkdhu8tjgoqdh9gqykchp
X-Rspam-User: 
X-Rspamd-Queue-Id: CF94540003
X-Rspamd-Server: rspam10
X-HE-Tag: 1764019222-910315
X-HE-Meta: U2FsdGVkX19L9DJCp4wZ4/mF2ZmfKB3qZOZq5k3jcSuRFJqUg4HkI8aPgs1RHh1kcTCRdVpYFYEzVe8KoYgngqji2tih/OIJgI33Yl00VkBMNg19e1A7mzuhrZUjtWyosgh0PWsBUJ/fQcfiK5SQfk+H9yPcT8jfeI5zEMwQq2oNAml7xfRq7CGQdWbT8Bmil2U5gz6qw8RISP9G3lv2gPT1OxdijKsTaiVu5kRJ+dUyKWbqiGZOUBkU98/1v4bDdgEdfgujFql8hRO+WM6lbQNueOCOSprLXUbkjaqpaHre0PQu6WT558Cjt7UhHDdY4ilOa9b3XhiT8G1TLx5F1jdsbR4xyywMCN1EGW2Fbf2gUtsYZUYQ70hnQvHc6LmleSaBKrzlsyKZV7h+jPaE+EQ//FC+inGZOaoLIZzdvTL5PuU1jLLiPyDAn7cIu6tAdrjD4/8w/2VENR85CYS6f62OCwfnCytW/vFyfU8pfm9iQp6eFdHH7T5tUPgDpKm6a/m+rSkrhJ/mlLV8wbW7giaj/fNDXm7BTAzHT27yEGvWB4ooAaNQkXoEg09Eu7sYZ0+kwrXf02DHY1o+pxSSSyjJVHj1LBf56bmdf/fwqj2aLax04qq3CtMOoJSh2NSUa1PEm42FW5vQvnUeprym+0ta3z+k8+CkeGNevsn74s4y4Cf7DiSBAcZ371TjeiZo8EFq2F9sg9zHTNhUxWrfHMvFr3eIfLIDRIoBJVZjC68dX5tjSgk6bt9fNCUm5mZYSvz/crZZIpiL5BPmrpvs2OzL7zW/q15NRSdsRzAtUc6FUHp/OAG9hccqx3ein3RjtmOle+LMhnHqzzsEAL3ddKKa5+kWdXqAlFfRVxGr9HLv7m9S71qXwYlvRcmhr5BYPpC1sudW1j/Ri+o1cFta3rwmjiOkJugj1RzW7nwUCeAa7AW648RIEtTSkOW0W4aBUwS6Gd/WdIwuRO3hQ41
 +QPHtg9q
 gk3QlszlNRniuNZ83imsbWR4VTOeyR015AQTUHa+AuVRyEQQZioZ0BCyiyFfH264j+FtI8mGCjBnrmwWRhT2FaD/lTsKCBJm4NEr3YjeD6SolKJ2jUhoiBt4EvaRxECY8IP1GCkWapsfKTSTmdDTIrkHtTXORCs0hB+No4K9hVO/LIjD+4lyDfyz95V2JJu73wG0i7uVlH9l83auM+InPTLlnvpkolG1Xz+rDSlGDuFQyswLHsP/FjisWV4KRCVPAeTZkSdyuOYln8ZJLbiZ/oTPzHeGFWasmahJL/eZPmfvTDviqP5VCEADpamjdMFQ9zxvtYSQtOxzoXA+LPtAvXiEp0A8kAVPPEEa/qFr9fCQjW6GYyJBNCJ+aZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 09:12:14PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 24, 2025 at 12:38:57PM -0800, Kees Cook wrote:
> > For code like:
> > 
> > 	u8 size;
> > 	...
> > 	size = struct_size(ptr, flex_member, count);
> > 	ptr = kmalloc(size, gfp);
> > 
> > While struct_size() is designed to deal with overflows beyond SIZE_MAX,
> > it can't do anything about truncation of its return value since it has
> > no visibility into the lvalue type. So this code pattern happily
> > truncates, allocates too little memory, and then usually does stuff like
> > runs a for-loop based on "count" instead of "size" and walks right off
> > the end of the heap allocation, clobbering whatever follows it.
> 
> Have we investigated a compiler warning like
> -Wimplicit-arithmetic-truncation that would complain about this kind of
> thing and could be shut up by an explicit cast:
> 
> 	size = (u8)struct_size(ptr, flex_member, count);
> 
> or arithmetic that can be proven to not overflow:
> 	size = struct_size(ptr, flex_member, count) & 0xff;
> 
> Maybe such a warning already exists and it's just too noisy to even
> start thinking about turning it on?

Yes, -Wconversion (W=3) is mind-blowingly noisy, unfortunately.

-- 
Kees Cook

