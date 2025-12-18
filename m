Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D13D68BCB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A3A6B0092; Thu, 18 Dec 2025 02:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7EC6B0093; Thu, 18 Dec 2025 02:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9416B0095; Thu, 18 Dec 2025 02:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C51B6B0092
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:21:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB7EBC1004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:21:17 +0000 (UTC)
X-FDA: 84231745794.22.CF4352A
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C7D3A000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:21:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NYEjKcXO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042476; a=rsa-sha256;
	cv=none;
	b=3g4I+L97FzFe+w5Dj7XLJbt7Vg9I7KQdkwNxUMCElsGaSJccEgql6j7wWfTZjge/2arRhO
	oXzfm5DzlpZHe+wyNUX73OpnRyYPlmwKEbfJyjSEWI57sunqbUQ4Zbth0c3UOzmFnhwJql
	Z+xh7Ph7gK6CN8aBySxsr7aHodlyAf0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NYEjKcXO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdZo6L5c2+gsxT6SqfejRQC9h/QKy9Y5BdqFa3CYsb4=;
	b=DqxNT2iOpo94DaVXL5GpmpdGDAKcHJSvl4X396eEfE+Wng3o8WBgu7HLhtv8qQPP8tQZwx
	LQIIGfXFMtzexss7R/Y6PjOfH6jNNa0lXZwsssPnlPWaRzSa+aOXV8pLy0oTeZOvmUNxsM
	Nam1RCsIyNB53eLUT8nqSPPfRvv3M5g=
Date: Wed, 17 Dec 2025 23:21:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766042469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QdZo6L5c2+gsxT6SqfejRQC9h/QKy9Y5BdqFa3CYsb4=;
	b=NYEjKcXO6pX2fx2bGc9uptFb6pO6C7AvivV0STkov7inU2M0mWHwcirHJByV6wiDvx7Q/9
	geB+YHVMeOYQHkAzN/u+sdw+gGRFHY+EtZktne3zFLOebRl/GVvuJY5T3FvETtId+qsf7S
	sBpWzybG3rneiH3E2lrowpR3ysywg9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <vs6nessf2rp4qvh7lpfybntrqzjnvthfykpf4h6rzxwlm77eyr@w74i6i4ojsgz>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
 <aUENEydFvVvxZK8r@infradead.org>
 <20251216185201.GH905277@cmpxchg.org>
 <gweo3wdh3agfavhiky5cloweu4m2hvgzk2j2euckbka5x7n47e@ezjmx7eq7ks5>
 <aUMLmJ0En24pQBX_@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUMLmJ0En24pQBX_@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C7D3A000F
X-Rspamd-Server: rspam10
X-Stat-Signature: zobpe8bpxwuu556sdcx95rcf7m6ds1nd
X-HE-Tag: 1766042475-770824
X-HE-Meta: U2FsdGVkX1+Ul0NDDnCTjQgrWpXhSbVPgbZ7ozmorRdKgCNUWlmJG5WZP9SC75ssz2vkWdzc9yFazd3ELRhrxSTpsga+qup8EK+ij1pm4lOLo6wbMnV0Yfed37Wf6jHlelLgj6aQe8u4pyB6Eh+IT/803hCvr2OyGxnuXLEbruSLYnyzh651NoznyLo+JXOnMwW6KrIVnNv6iLD1q3ec8ZPTKuNYfWV/lU000LIXkWt5NM6zziJa1LcyIadjI0W61LeDuMQKFF/WasyhJy9wOcOCcMt6ybdiNqtTN4l54LuSJqdPZi0y3pqkmEX194S7CmTrtlcpc4uBKB0PDA3QUOndMUJpyf0Jg0/gH6hEOUKftStDHPs1uLvdj3X0QdpoMsWYDkZvEtiTw4vC6KtWKf2ZGQrgb2xONTWBPLXMTVa64C7+iArcz4N5Q5pB38OqwBAIZs10atsQU1P+iu/uWF+Y+yk88pRYJhqngd5mht1tHtlz4iw2pxrhzlI0p/ePhNpmfjM/4GJIiXb1dSi/nwv5URa9xJXbJ51J5FGQbatjL5n5fGnI7Wci51/OXXd8x2iQCjXU3WI0UDJuVoGNMwsA37p2j7mugz4asJzso4vukFzJ3JoLlNkWKCYiNfW4xJrzEUarJolZO/zMyY6Xez8NQFsVUDXQchvC7VSa1S+xvgdD7qahn+31OsIBwPlyQBUKgOK0WK9QMMScBT3iGwjbyXkALt7R+ItKHsaQV5dR9EaDEguOlnLOGAxj66blmx5e8OE65/ZPNomGgKW5vAy2jwm9IfpsJTmYo/zEKakS+859qUbpaCocT6YqSpKCMyoktTVhNyuI/2IgtG6+ET5d03N1NVmnRxTFgGXpJo1d4VnoJMGyjqgr2Xl59DFj3A6ASlxVW0T51lVgtwyu6S70Ee8koUga
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 02:59:20PM -0500, Johannes Weiner wrote:
> On Tue, Dec 16, 2025 at 03:23:53PM -0800, Shakeel Butt wrote:
> > On Tue, Dec 16, 2025 at 01:52:01PM -0500, Johannes Weiner wrote:
> 
> > Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Thanks!
> 
> > > --- a/include/uapi/linux/sysctl.h
> > > +++ b/include/uapi/linux/sysctl.h
> > > @@ -183,7 +183,7 @@ enum
> > >  	VM_LOWMEM_RESERVE_RATIO=20,/* reservation ratio for lower memory zones */
> > >  	VM_MIN_FREE_KBYTES=21,	/* Minimum free kilobytes to maintain */
> > >  	VM_MAX_MAP_COUNT=22,	/* int: Maximum number of mmaps/address-space */
> > > -	VM_LAPTOP_MODE=23,	/* vm laptop mode */
> > > +
> > 
> > There are 8 earlier enums here with names like VM_UNUSED* along with
> > the information on what were they. Should we have something similar for
> > this one? Something like:
> > 
> > 	VM_UNUSED10=23, /* was vm laptop mode */
> 
> The other enums in that file leave holes, the VM ones have a mix of
> VM_UNUSED and holes. I don't think it matters either way since the
> sysctl syscall has been removed and nothing new should be compiled
> against the definitions in this file, right?

Yes, you are right.

