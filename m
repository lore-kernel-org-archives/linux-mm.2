Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BDCD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EE46B0006; Mon,  8 Dec 2025 13:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FAB6B0007; Mon,  8 Dec 2025 13:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565206B0008; Mon,  8 Dec 2025 13:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 453126B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:57:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D77B61A0296
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:57:31 +0000 (UTC)
X-FDA: 84197212302.02.86D60AB
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6F0FA0015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:57:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AjBR/ssk";
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765220249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWyaFrEhG3z3cIAYB95757Y84D0cm8l/dldSl2D79pM=;
	b=ARspfNnWF3/RECHVv6Sk60FUGCqN9Dm8j3c/qZjYdRoQNdoCkaQuc13itodFz2zmAoq4LR
	+iN2KwocFH6esT4LISsTx5TD8qf8t/EQIgcU+m2TynEv6JzwJU+QJx+aatzTLq56mN7mAR
	z25vVZ3gXvDrTPCaWzFisI2Jr8u0t+M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AjBR/ssk";
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765220249; a=rsa-sha256;
	cv=none;
	b=UASXg1f8rUcgsjsUJdw+AFsuG57MzzAO1ZjqwDjCL8RSHeKXaGwPW9+3ScaYUlNxXEXVyF
	VS8SLCU8ayP7qYQiq/Lm+tcT/1r/hI8ej5b2+BRi4xdXtetGMd+vTdJp63Sie8nauixWw9
	zCQsqHFuzycN6E/ZZ6TDDdK4JIgrk5Y=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42e2e47be25so2428909f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 10:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765220248; x=1765825048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWyaFrEhG3z3cIAYB95757Y84D0cm8l/dldSl2D79pM=;
        b=AjBR/sskGD4qozhN5+RRXlHISVzImwzFh8J8V+mTb5Ckpb7acJBFkPDU9b6rXg3xmy
         pPqqvRQtExOxBAV8Dgc5dnOQ7HZchALc0bUJDrQZ9p5tvQB8c4aCPhnY6VC6GIKd4aVK
         D3Cxp4b0BVhEcgwPQUCVpWi2QF9KXj8liNWZIuzqxXUCK89P6SHgVxQJZUTRmYWK3PIL
         DiYY97QG5wBmYgdZHCL9P8weh28etQEwjdZki36pluMy2Ot433JNwov70V8M9ZXffjl9
         CFqezdRnKyXyNvprg9whIl+YTffJeqWvPJzeU6pN+bdcJcHKP+iuja6fiskvqskcacTM
         sCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765220248; x=1765825048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KWyaFrEhG3z3cIAYB95757Y84D0cm8l/dldSl2D79pM=;
        b=DzdHA5cpzik73CkELYZDGnXB4oFQyPKBvPoqthBT1T9+nHUs5cvmsKIjBofceABHG6
         ZUeNg/hcJjK6lm3TpSRaIB1Dah9M+bj1itUcJ5Sx+JOZ623z6DnbpmN5eECB/TtleLG3
         nuBmFgXK5EdlCAofQiLM4vwTF4CHb+je3AkK0nf79P9RPTkbQfJY6AJhRHlsTJ3X5Vta
         BcVPREOvMmEMkYivo3pb9/fx2v1JqJIRAF/0gMjIfVAzAXvuwx65FeOEvnCjtXZzWoRG
         3XYD5BvBnVvxmlAIIo4tqsYVuLhnTskhS9QeeXY6EcINFuqCb7QzpPyZGAUKxNsI9F4f
         8YEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSQnUv1rliLjtdsbJQlk9wcBOHaVQWm+uxy4EGpMf8CujVrn75z6sLhgUTPhBvve+4h7KEpbiEeg==@kvack.org
X-Gm-Message-State: AOJu0YxsqnbQ/VQNGFXGMmJxuAsG6o2GY61xGbFFFkV0KbR1HqL2EOYc
	/HXBc6L5jxzn2s+4dXt58A+v5o11bDQHVYG0RSIYBw8QOsBYs0PiE1bn
X-Gm-Gg: ASbGncuMJwP2G/w5nOhDwAn5sSdFzcJbbUgLHcI/HDxk8x6p1mEXlaGgnNC+Gp6DKKA
	/bttenGD7TtC9J0UBtSNOpXe8o2NtSbrTqGua43MmxD04knlfNBbOx+1r5bTo/jM6ET1ToLVdpT
	aPW81Vj+yQ9K2tcolOkCdKnJZPyBLZBNDwC1peUNEF5gt8Asap9Or4AllvaMYcChekqaNQKUcW4
	atEGjKeDtNJHarQNvzgt/2jXIjALqQzhFKjjN2zde7nPyWKxfGALOMF+RbcfC8Dc9zRI1CoVscV
	g++/5L8/GEtR7Dp09qmwjLkIfmnqCjCiYx4+LQ4JcpI0tpmBQhp23k5aoIP72Ip18yj0IBdBWXM
	6tTPpI6geFjSl/1vsK8D6Q3q32vrgvsWZSiAMCFRVur/SKvjoWtJw463Ajhk5kxBNeUVJk55j79
	8qwfadsGPheWT35LpJmQM7gAzYy1XHVV3vCiCKTNiIcSnw4wOUn8+h
X-Google-Smtp-Source: AGHT+IG0dUoaqrtgWtzPv53mIAeFPpwBu8JvslqiBa2uwkU22Y0TLTRiSrVJGb1khvuOup2fFSbmVg==
X-Received: by 2002:a05:6000:2891:b0:42f:8816:9505 with SMTP id ffacd0b85a97d-42f89f58e5dmr9440683f8f.61.1765220247936;
        Mon, 08 Dec 2025 10:57:27 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331df0sm28107904f8f.36.2025.12.08.10.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 10:57:27 -0800 (PST)
Date: Mon, 8 Dec 2025 18:57:25 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251208185725.6ab9bf7e@pumpkin>
In-Reply-To: <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
	<20251205184342.2cfcc73e@pumpkin>
	<4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
	<20251205213449.12bf4819@pumpkin>
	<d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
	<e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 39u7dq6uikzxkfucmsx5nkgyp3x46kw1
X-Rspamd-Queue-Id: C6F0FA0015
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765220249-776224
X-HE-Meta: U2FsdGVkX1+aopPHAIEl5CQdKJkDzrpQbK2rEZEwK/WdVqZWVnukClvuxprBaXPztXEafkPQ6aYX7zhYAfB68rav4eHICuBEbn1EY36NuxQG1XC70LtSPASJ+R79JTdtgmVlFLdxfjRrS3JNytUQ86nw0rsRxZVwWaXjxFI7/4wN+0//QhJk6nZZC1jZ33Pz8wmcBFXNkVinx7qA3mGPfet5devuN2ncMfPg9fMtH72/GYG/5G+r+AwTRgmtqdKSgDWPr/fSkzFbSOPXha75pSkNNz8CBtM+OBgxHHc6aXUyICzsnV7fElNbV42jiPJoSTxLDxDlWIv9WggeoJa1TxbRndYT7QpLQIC+/Zh48EJ2+WHXD+hrn6q3LWMtNSijYrPS1I6b0wYhO2WBQ/FlGRh3mebnDLtQMJXWwkbuSR7Fe0yWD3qg1ujWTz/pRzeg7QdA4abfmKE+Q7mKwzBgypn9Kmyp42hCJhqM29j6QXhFo7zHkxOKNQ73GdPWVAG5B89NpDrFCk1L1D494cR3plWfMgFJqCi+zh1k8cRnLJymdw1wFG1kdk6zulSUk/GkacDKbjdDojcs18Avu8TWjuLR8N23pH4gLaakXbiJoCSDlo8hYTdrmkfCpeusn40dl/9smh58JaXWt83EZykhnXLz51JpdODm6nKNsWD5Tot+Df1TGOTcaMF9SOlt1OCOR/H17x7kwkNkSrLmkKIoY6NiPGfFDxZWruDYidOJSLc4N+mSB+Q0ZQ9IOBN1vjKHCKNCOgD0RNOWdvUFYcwXskl7OJO4sMmJHIw4NqwfuW8e5tMCjKjuw3H6dOPu3D06y91z16/7ILmsSqEXba2Jig3GrpZ/KKCIhI7uWkb/j6mF6bGZ1G7UJFhV3Sz41ZzczKgnCe+8EGlUaQ3FCpc5o3Xiw4jrudzt6QMT9oLOWH1VokZjN2Mwk/EiNKaIGcl1XSUZl1YBhsaeQYkHDpL
 M+3QtsuG
 qmGmgjALdJo+K7NE80gx7RFvY3GUeHD/q6iF5sTHqyFs/fQTNe6hVe5y789IlZVlG/RwiMSpKcoaDYNdEFWNgrCGm27+dVlgReuhmno6MJRwxgbr832unPiHCj7hcyUTa8TIAqAWZhrX10bvFM6+2oM6agrr7ktv6W2TRl1TVUvI/VRR96aaT4BqsPWKA8MUf+a5DyIhS8uttfv2kJWCNSmzqfQxeWKZgxYx6HD3yVAsk+eims9X2y6T5wYGH6VFThlU/WGvx2RmAxaxjhWpnyawhukbBSUPXV2EpzLYcFxPHsdpTTpRnLFXMu6AyyCzF527bUjMJuXDAldW8PRqS/4ddkA1+3fVY+vXMRlSBERfMwsZGKYMj9ZANmBR1hLVnJz5ecv66eCog5c+Cd5z3h4K8FvXI16A0aJ/FcjtDA6vqxjfPkY43mv+fCJ7rGJVZLYWsmA0CV545VvwcV3hCo3KCB0jNuJyduFGAmJpCriuoZiVU+rtQcLECl5EowDU+941Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 16:42:43 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Sat, Dec 06, 2025 at 04:43:57PM +0000, Lorenzo Stoakes wrote:
> > On Fri, Dec 05, 2025 at 09:34:49PM +0000, David Laight wrote:  
> > > On Fri, 5 Dec 2025 19:18:56 +0000
> > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >  
> > > > On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:  
> > > > > On Fri,  5 Dec 2025 17:50:37 +0000
> > > > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > > > >  
> > > > > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > > > > > how VMA flags are declared, utilising an enum of VMA bit values and
> > > > > > ifdef-fery VM_xxx flag declarations via macro.
> > > > > >
> > > > > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > > > > > the newly introduced VMA bit numbers.
> > > > > >
> > > > > > However, use of this macro results in apparently unfortunate macro
> > > > > > expansion and resulted in a performance degradation.This appears to be due
> > > > > > to the (__force int), which is required for the sparse typechecking to
> > > > > > work.  
> > > > >
> > > > > Does sparse complain if you just add 0? As in:
> > > > > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
> > > > >
> > > > > That should change the type without affecting what BIT() expands to.  
> > > >
> > > > Thanks, checked that and unfortunately that doesn't satisfy sparse :)
> > > >
> > > > I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
> > > > that this is an issue.  
> > >
> > > I might use some of my copious spare time (ha) to see why BIT() fails.
> > > I bet it is just too complex for its own good.
> > > Personally I'm fine with both explicit (1ul << n) and hex constants.
> > > The latter are definitely most useful if you ever look at hexdumps.  
> >
> > Thanks :) yeah I just didn't want to go down that rabbit hole myself as I seemed
> > to have the answer and wanted to get it fixed, but obviously am quite curious as
> > to what on earth is causing that.  
> 
> I did wonder about _calc_vm_trans(), given the 'interesting' stuff it does.
> 
> Maybe I should fiddle with that and see...

Hmmm...
/*
 * Optimisation macro.  It is equivalent to:
 *      (x & bit1) ? bit2 : 0
 * but this version is faster.
 * ("bit1" and "bit2" must be single bits)
 */
#define _calc_vm_trans(x, bit1, bit2) \
  ((!(bit1) || !(bit2)) ? 0 : \
  ((bit1) <= (bit2) ? ((x) & (bit1)) * ((bit2) / (bit1)) \
   : ((x) & (bit1)) / ((bit1) / (bit2))))

The comment fails to mention it is only sane for constants.
If nothing else 9 expansions of BIT() are going to generate a very
long line.

For starters make it a statement expression and use __auto_type _bit1 = bit1.
Then add a check for both _bit1 and _bit2 being constants.

It is also worth checking the compiler doesn't do it for you.
Looks like gcc 7.1 onwards generate the 'optimised' code.

https://godbolt.org/z/EGGE56E3r

	David


