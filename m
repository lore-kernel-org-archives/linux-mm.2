Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE043CFD355
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8B26B002B; Mon, 24 Nov 2025 16:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90516B002F; Mon, 24 Nov 2025 16:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD9E6B0062; Mon, 24 Nov 2025 16:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF4BB6B002B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:12:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6998DC0584
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:12:31 +0000 (UTC)
X-FDA: 84146749302.02.65E0D57
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D3E1A0005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:12:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K3KqGjjZ;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764018749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbFLNQfa1lwkUj1c6wEBCQkuto/HQ8MD1t1w/QlDuKE=;
	b=l7nXgi3HuqM4edChpQ2gPE9m8Tf3zY9l8x55IfMH8CmXXWAxw8F9ylSC/LR0r6Dh6hsEBO
	dOqO0bw3maquvN7DAiiLrW2V1qujOoQ8RTVOcPxoCQF0crsjN81oZF6nftw4FmOUYIxhBj
	rkUHgc+OsPqx+tqtgw5YCay/cMo/xl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764018749; a=rsa-sha256;
	cv=none;
	b=Pzqe7gSkjXiwYohBeBNftF3HIC1MFt9S4BAWa+USI1q2nhv3mJ4P/53zEpdKmCoEgqhGdg
	QKEx6VuUPtrqTTkjSPoCwa67Yyv7DeFkgqEbyl+9HGy7CYgAe9Q4NJyT7oYMEtnmN7zVOu
	NN4VsgHipYggbIPJa6okpq10Pxc/yAQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K3KqGjjZ;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pbFLNQfa1lwkUj1c6wEBCQkuto/HQ8MD1t1w/QlDuKE=; b=K3KqGjjZfNg+chFeoY8EF1luJ8
	yv4rmbRZFXywOqiF9wwHgnSWhuN8N77C5eYkvTUzeHAUDWisXjNcJbafeY58VPfjZoppu/SS94Vgg
	tJYHvnI/3nFsQhOW7X1kZBfoqtz9IyMRGxTpeUWoD1dhtQiktCCCbNYjh3YA9ZBLd2n92EeOuuN7k
	czcAXu14cYg0vNYEsb88MA8+J99yz0Z4sRVdVBfKQbr1tEsKSBb6IswrqYZPkGG9te6VYAM104e03
	ZckhHCkk4bmC3f+NNjeAcr5KuiGAqYLX0qcqKi+YofXhWRgufo4XTN2v38rcP2OgelFfG6o6Yg38W
	JvMf2AGQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNdr4-00000007Xk7-3jr0;
	Mon, 24 Nov 2025 21:12:14 +0000
Date: Mon, 24 Nov 2025 21:12:14 +0000
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
Message-ID: <aSTKLsRNiEKtDqPI@casper.infradead.org>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511241119.C547DEF80@keescook>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D3E1A0005
X-Stat-Signature: o5z5tnz9ezo346htethj9nuix3ae81qj
X-HE-Tag: 1764018749-201800
X-HE-Meta: U2FsdGVkX18gmUIASA4CTxCx65eQ3E4h9SiCem6Ore6NBuoGoZ0b0ywHoyuSbhEKW6uX1VCcI0vw1JakXIzkE8nNI20mo9sA5yd5+peuitKiT/d6MizDbuqkBnUEGe1HKNLWbwkduDlUzJK6NeRhIVGhRqgDvflVZfEyYwCPCJNlqyi6FZuT1p6s62XShhUrfvbQPoNJLm5tsRIAOh09GUzpe3tDcxHKYYOUSKAxyqAi+sJdGJUB0Z26foMGOrrP7C5spW6viVp6PjlifrujkGGr5bB39IFCn58LE/IKZiuYxhXZvARh+w2bKSOpzk67A4uvAiS/6i3LbsOBlwDjIvMeH4o+u+8YaWUiOPDQZTUSC6UEPlkoxLkWsquXOqnWNrnBjrUV8aWDewxjGTB2NCERenUo6NY3IvqUiBOntEVRqmpGwGRnVDGp2XDW1BI6MuGO51gFnK8PiB3pqJuBuzFF2vYf5XiMkCOu081OV6TsZ5k65OlP0CUSkWlUsXjngKd2w8vkLbl5URlzU0vzuA/oRLw8lwsaIBMLPp/5od9nR/u4pYCdAgPoxjeaF00bfUsKqHVSzHU8R8eLPRKUY0PUXYfdKFEo8MHO1l4CVbQ3z4W65f3sespQ0Bgu7STbf/9ttoy9OVB5grA4sqYYhoulYuYWY4ZlmCAMbwVTmhpTCY8p4FJcyicHOpEnG0tqMCYMHrlwrepjxZG2OYyF4l+MBT+hbzQCh3YIs5E8JkK2XE/Nce6/Nh6PJx60oGxA3kEK2sFbF5fqAH5jOLAOSTmqUCFSz+tp+HKsfbfLzobX5EwUGKaj9CWb0ixjGaTetk1slzwej/7nDX21s8XtZg1ajFuHOeJoQ2x+yFc1X5Su37AvEuXoEchDaeTsxfr1uHeR0JaKsz7Uan+OrBtz/uAjeeBQzscuFuy7HrvJfAmTuxa90kUmNbDTngIaQcUSipzVI5JKJKFgYSje0AT
 r+zKg1rf
 gPYSvKFjUtxZT47F4LCoG/Zi9mC/KlJ91CN1VAxcZIDIiFDqvRj++pG29QMCGiHAdUpfHKVr+7eFZn62eUgpdgvh1i9hzC4SMwime3xlLOgVwfhRb/M/YGPmZsX9bPx0sv/MR4p3jU6dK2npjMo7LWduRWe3toTNGjwyb6Sfo8bCwA53QNN87hewKNkoH6Hw7xGEiKJahr8thm/TYNec6kJU+AYrpEH0fDlFk0+JB193VFCJMNg0aVRLlSx/zCiuC52kF6625JxXhVO/2kEc1PeIvOTs+16Al+tENorCe3/2reSfr1P72nSp49xQy4Bd3+r9yyyKso2SghOjeD6/Iq/R15g4JhE4a2dHc491rAjwMRtt4K9BNhjxFAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 12:38:57PM -0800, Kees Cook wrote:
> For code like:
> 
> 	u8 size;
> 	...
> 	size = struct_size(ptr, flex_member, count);
> 	ptr = kmalloc(size, gfp);
> 
> While struct_size() is designed to deal with overflows beyond SIZE_MAX,
> it can't do anything about truncation of its return value since it has
> no visibility into the lvalue type. So this code pattern happily
> truncates, allocates too little memory, and then usually does stuff like
> runs a for-loop based on "count" instead of "size" and walks right off
> the end of the heap allocation, clobbering whatever follows it.

Have we investigated a compiler warning like
-Wimplicit-arithmetic-truncation that would complain about this kind of
thing and could be shut up by an explicit cast:

	size = (u8)struct_size(ptr, flex_member, count);

or arithmetic that can be proven to not overflow:
	size = struct_size(ptr, flex_member, count) & 0xff;

Maybe such a warning already exists and it's just too noisy to even
start thinking about turning it on?

