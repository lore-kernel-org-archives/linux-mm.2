Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBBFECFD36B
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EFD6B0031; Mon, 24 Nov 2025 20:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E9A6B007B; Mon, 24 Nov 2025 20:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CE36B0089; Mon, 24 Nov 2025 20:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF2EC6B0031
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:09:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 712D9160654
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:09:59 +0000 (UTC)
X-FDA: 84147347718.07.067A734
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 811B914000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:09:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DVdKEk5K;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764032998; a=rsa-sha256;
	cv=none;
	b=DCukgKoDWm5FhBF13c5ew+Ii7JlanM78cuNMXhxKHrShP4Q9xjfBs4+nfVpFtxUi/ZkZXm
	LTXENHXq4YFLc8E9AX3TqY/vfn3XmueP7wj+8JqC5GVUY/aF5G/8Fshj9tvp8n4HJztOkA
	YK8pJxOSu6HjBgDIjEs8J7meAbJvJ54=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DVdKEk5K;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764032998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kODB23LtSbraMlqmSxfIt3k86wJC3FJBaXEatSPUpUQ=;
	b=jW8M8QYloJCw1/DKNbnytjKZ4MUWpG/9BLsPp0K8deDYJzY3TjNB6Ftzot3tlhM2wpXiBQ
	lNmEfrteAcd3OmT60P2eXAyRTPdWqkvqCyr28iXJwSOfbrkx4tSxZRiwBf8cSFNUZyGMgp
	UDk0Kf3xbUAzwRZTH6u65hFCExuWrI0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kODB23LtSbraMlqmSxfIt3k86wJC3FJBaXEatSPUpUQ=; b=DVdKEk5KJpBpl4fxfo17HNT9Sn
	FguEXYplzXPLC2lfaSPPb+sZHMy3AZtx01hgFGTzP7cs0ll7knzhR/LjNNFeTrTIQQDXpuiTx8NHZ
	ZCBoo299KS4ajjUc7Pt51EG6RLjcAF1A9pRwozBoUWqKBt35C8isgETMOimHohxhxxH6N4eEmC44Z
	nBzm3cIO3FCf0xxvcucbFzT6TfLpIdLjiF00ngCX5H9O0jmqSmtB0V6/fR2vaUmlcVkprQrsiMNAO
	AQXJBEyIo+o12XDvE7T8NXiHzdF0Zed+SI0pTTTLXqrUnNQsx/f3RttycuGMJOe05pnge9Vljdy6T
	vZKmeWKw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNhYs-00000007nVS-1SdO;
	Tue, 25 Nov 2025 01:09:42 +0000
Date: Tue, 25 Nov 2025 01:09:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
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
Message-ID: <aSUB1qrfhXp3suGn@casper.infradead.org>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
 <aSTKLsRNiEKtDqPI@casper.infradead.org>
 <202511241317.516BDE7B@keescook>
 <aSTRsIUPeT5EC5An@casper.infradead.org>
 <CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 811B914000A
X-Stat-Signature: 5h3hhp1n1pe4kqf6rphe5ssxtkkbhw6o
X-Rspam-User: 
X-HE-Tag: 1764032996-964159
X-HE-Meta: U2FsdGVkX1/9sztZZ414MSHYD8KvnkOoeGrRf4YdArJudIEuLTz+QIsB1CLMf/grABtYwUHcsg05+cqwV2ym7qRL096vm3KsAax2w4n2kUzgyE4htXSxCvxm/mCDJ8EAeJB1bVE0ENlu8ziyBAlqzquToT3JtMIVYo/WLD1wPmVYUs6+gGFHBBKc6iTCWTadx50x2sUj0CnUhuduGHfEkl4KqLjXrIr1JJKtOG1QsTfGIpj0pxwoUi1G1atbUadnT68M4XeywgQ4/MDNrDyzliwIwQho+Q/zOP6P1+TC1OG1Oh5fz3V8HEyi3nxDYLda1n/4Yr684S+ilBbmdS/d/nt9yklCXazLZ9yGRxlsatdBYVS5ah7qmIS1kQj02T3wdz36kEuQTy+93y3qAabgNCFbGqQXyk3RjoRnF7RCwb0x7hpmnM/XB+Y7SCE5rZbKPJynAIzdFQmwqjjlES1M6T1WswGpdgrPQlv63sNelyj7/oz6nXCEcDUoHoJ1V3dnSQ4AGzL1SegXlGUxdSjR55C/cI0pN4dg0E+sgHYGYj0YkfmDOlvpDAVzLQLtYdwc/Yb3cOu6IPJAMcg6LDigXrqwC0Sx6lrb5vPQcENLR5fAR3gzlyWULOH5bs7vPlvsO70NUV0z3VMTNOG2uG7gZUAOfmKxf4B8ME5IharbvzsCkhq0FYKWOzEKPkBo3Q0P6QvaHmnTnE0uJunVGfaYnEPkN2wwnz1hdkVtPmSIq6RIgtZN9ZcbYSRlI82w6NStyDWGaXyHT5/dZhCUMrrohTkl1k5uI/gyje6D/rNQNLmhf5vujVDM3/CAKMknpiCVVqbUo2eMUAdUZGpf7xSi+erujI2sW8nLOqQMOML5A4FGcG8ncRnA9CVvZlNTaD3KN7+Lol4LLvRpw/us2Paxhehj/xGGel8p6/OwuR3LWaDwSEBWXb7lKNu57/P4dO2HH8OCbnaOC02NFNtw9Hq
 PVSKf+y4
 DUqoaKsRnC5b1QpPTrOrHbh0VWNc4CNPgoQZ3k+dVOm3dWguokgoa51/r3mZxvnDd4B+EovY3hK1AvfbhZVj0948gO7Zit5uTljrzcTH71Vt1aGuJaEgVtsLHlG/5bNE251LRZwf0KxWvvan4bZJ/PNKlHx9oqKIVh9oLcNDpikxAhkth1MfAobL+4HNZT5RGHbKfNyTr/VkcvITL3ulT/uxoz2nmoJtVKGoW6ORLOsC0q+EYBWhh/flIlfwR8NHnz2o6Zs39UqmC362yYeFgaYtbTQgCyczNvMI69OMAokw5JQpkbzT6f5w9GK28TAvz2lE2Js6Ejz48KfBDy3y1CkXSLfGBd7/4eq41QPHA8kYPlyyA1WckDTMHQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 03:30:19PM -0800, Linus Torvalds wrote:
> That all a very standard thing in assembly programming, which this is
> all about. 'entry' is a signed offset from its own address.

I used to be an assembly programmer ... 28 years ago.  I've mostly put
that world out of my mind (and being able to write a 20,000 instruction
ARM32 program entirely in assembly is just not that useful an
accomplishment to put on my CV).  Anyway, this isn't the point ...

> > The warning is ... not the best phrased, but in terms of divining the
> > programmer's intent, I genuinely don't know if this code is supposed
> > to zero-extend or sign-extend the s32 to unsigned long.
> 
> What?
> 
> A signed value gets sign-extended when cast to a larger type. That's
> how all of this always works. Casting a signed value to 'unsigned
> long' will set the high bits in the result.
> 
> That's pretty much the *definition* of a signed value. It gets
> sign-extended when used, and then obviously it becomes a large
> unsigned value, but this is how two's complement addition
> fundamentally works.

Yes, agreed.

> So honestly, what's the problem with this code?
> 
> The warning makes no sense, and is garbage. Are we not allowed to add
> signed integers to unsigned 64-bit values now, because that addition
> involves that cast of a signed 32-bit entry to an unsigned 64-bit one?
> 
> There is NO WAY that warning is valid, it's; not *ever* something we
> should enable, and the fact that you people are discussing it as such
> is just crazy.
> 
> That code would not be improved at all by adding another cast (to
> first cast that s32 to 'long', in order to then add it to 'unsigned
> long').
> 
> Imagine how many other places you add integers to 'unsigned long'.
> EVERY SINGLE ONE of those places involves sign-extending the integer
> and then doing arithmetic in unsigned.

I have bad news.  Rust requires it.

fn add(base: u64, off: i32) -> u64 {
    base + off
}

error[E0308]: mismatched types
 --> add.rs:2:12
  |
2 |     base + off
  |            ^^^ expected `u64`, found `i32`

error[E0277]: cannot add `i32` to `u64`
 --> add.rs:2:10
  |
2 |     base + off
  |          ^ no implementation for `u64 + i32`
  |
  = help: the trait `Add<i32>` is not implemented for `u64`
  = help: the following other types implement trait `Add<Rhs>`:
            <u64 as Add>
            <u64 as Add<&u64>>
            <&'a u64 as Add<u64>>
            <&u64 as Add<&u64>>

so the Rust language people have clearly decided that this is too
complicated for your average programmer to figure out, and you need
explicit casts to make it work.

