Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C289EE20BD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5C76B0005; Mon,  9 Feb 2026 03:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793646B0088; Mon,  9 Feb 2026 03:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FF46B0089; Mon,  9 Feb 2026 03:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 555F96B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:23:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2B6A160715
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:23:02 +0000 (UTC)
X-FDA: 84424227804.11.749B47A
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 22E104000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:23:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="YYyf8R2/";
	spf=pass (imf01.hostedemail.com: domain of 3YpmJaQkKCA8p0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3YpmJaQkKCA8p0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770625381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1z62XI4JGEoZVPtufxwSYx1SFhBLLihIdxzj7l54Q9E=;
	b=8qgx81629LuN5SQUW+e+Vqb0nlsW0vR9meQe+scDD0jIt99njTciDHGMv4J2iY2HIbB+Fs
	5s3W0XJ19UByRzVVi6kQKXoqJJuL8NdT442PsdgNE/3zO8sWbAOVBDy94m44iV9JzvcPLY
	wQuceheWXfdqVtbIevoZjIcsgxLNavQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="YYyf8R2/";
	spf=pass (imf01.hostedemail.com: domain of 3YpmJaQkKCA8p0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3YpmJaQkKCA8p0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770625381; a=rsa-sha256;
	cv=none;
	b=NGmXNStpKaFbx50kCJN9cWUv9oQawWjRB1+nfbG15IrgBstDbLo3OSpNFINbZtzgefAQiq
	V7IfGI5d6ayM37vx7nI8OSsM9R4POwkkKyn02ueGUXKOTRN67nOzNot+63Py9Z/sAYreQD
	xbF2kx2W9SsNApXLqWmynGhbfjDHxXY=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b884bfed5a7so175068866b.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 00:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770625379; x=1771230179; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1z62XI4JGEoZVPtufxwSYx1SFhBLLihIdxzj7l54Q9E=;
        b=YYyf8R2/UwxtaTXZ9f27evAmZehCfEAlSrllnM9pQv5WkxM4Z7WSsZNjIXW0wVHTnh
         EiKwgGtWHPBisYZQB0q/sNLukGZzzJMMqPZ2F7s/dyn9EM8/rs+CjMZF+3URUhH2uIOd
         Ny3N0cKkQ9/+VUnx5GLZNSbt+GTroDEqfLaSuzDdj7+VTjZWTHbMw6t+C5Fvnt9CqPT4
         8/xzEgzSJ24lBAQ549VJjVqAR5Bhr3AtuWr3f5QxctU20IKZrZEhaVcN31l9oh+D+TZJ
         hzXUWk0DOY9obki1uW7P22692Ih2DSODX/gK32YgjaGTRWsFAaLsapp1u9nyY0qwEKUM
         iIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770625379; x=1771230179;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1z62XI4JGEoZVPtufxwSYx1SFhBLLihIdxzj7l54Q9E=;
        b=qyyP4LW0Q5mKBgXNqRz7nVn+Gxae0ExyK9+1PwA8K0idYdyDhwg3tq1VpXdbgO8ujb
         UHVGqNiEJHTf2Mj481JiWXkcdKITDJtCYlnzgBwesM8d/PTk3qrKEpcrQUnyy7HxJyJV
         DTcEMnisuGXFoZ7ThdtZnK4VNmSRvco7nGQxXo29cGwDJRki0ZxYq8UpFfd+J6RAd6AJ
         mSxIk9SxiLuA8ASGwILX2qsbQ+qhm18RyIqgLonfUfepRwSqEv5odn5Qnj1N2dS8JsAm
         aVqXorV89neEoRNHp8rOZmxXUPvhC2I15L5rhf4dMEcgl4rt8QBK9op09+0gVJWI+PRR
         fScg==
X-Forwarded-Encrypted: i=1; AJvYcCXFB48hfvJpnfvN5WqzjGPc4mv/PBrB8PhIyfpQV451ThxH6BmdBWmQHiLP/ZJ+9RJIBhuRbkZHew==@kvack.org
X-Gm-Message-State: AOJu0YzjVn/F+nCWKWbY6h5MQfZ+CCplEYIHQ9iOYOJF+yNzaXKVym/i
	rDQtOozXq23Vae1d8Xv4FuCE81ut0VAQS+C10nOOHXxM/yUUS6icpXujJf5ZXSVAie6RoFVOxNw
	yCf1wIDqV+BBxwGlf8A==
X-Received: from ejbri1.prod.google.com ([2002:a17:906:d7c1:b0:b8e:b016:f0a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a0d:b0:b86:f495:5e4c with SMTP id a640c23a62f3a-b8edf3749a6mr545462266b.55.1770625378829;
 Mon, 09 Feb 2026 00:22:58 -0800 (PST)
Date: Mon, 9 Feb 2026 08:22:57 +0000
In-Reply-To: <6agwmmfv26g2ljxv2cvd5sbskkjgurnu2mhbsg5ssxkdikxpdp@xehzjz57omb7>
Mime-Version: 1.0
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
 <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
 <aXCiv9vOrMTbiJtb@google.com> <6fgs2mcvwlitkjza5d7cpu3mk34sqqn53vqazkicyge4gtqt7f@5dvqmpubypip>
 <aYNlvQmpL5FVpGNz@google.com> <6agwmmfv26g2ljxv2cvd5sbskkjgurnu2mhbsg5ssxkdikxpdp@xehzjz57omb7>
Message-ID: <aYmZYRyY2emr9I7W@google.com>
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 22E104000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 9gg9txh15mw5mugfjexgp8a4jbg7oipc
X-HE-Tag: 1770625380-15333
X-HE-Meta: U2FsdGVkX1/zxo5wl5G+RyOX57xIJgbwPPeN0yX7JzdYKKcYz9wXvCxM8nUn7dfRVMNNyxCc1+hMI5GZPsgIEGam7ZPCf9IHiyqQvEVfw8Aw7iiIIBP2Pp2dUX4AuMYuJdAx6GL/T+VaGqPdb02AivgAakhY2Th1GpCsC6aQUgf2313z8v6ncBeSpuCc4Q9p+QlGyQgwBx/hYylE1JEIIIk5fFVufwZlac6K9my/vDcNoUEmHOo2dI4nn5otEmKsZjUg4DDArDhosUttzMNlHpXt1eiN0SBE8sNsZ4C5LClPYFqZa8JYqCHPV8Smh+t1gNYB3ETLmicJJONGhX5BX7D912hjU1vb6H1l1s2LEAv7iBkxD0LYHhNeMpz8PMan9EdhoFq9IuN6I9OjT2RxY6Omt058DLe+5xo4quDr7CApQ5iFscoHhRQnzm3+Th+4uCsWiPrLue0GR5CNQZSa0GC0r5YvSiOolhIc6tyBMTrDbDyXM5cq3MjNMa3IjgHvOwJymj9DuKMMOZt9Z0kLB326Utizx8M/p2RuuW3WTFg3S41oO8GzPxM6AaJOHYzp2nPsljkAianpOXloTZYWwqv4s63Q8c8JKHMNJfBAf7NQVAxunlAuHT3mWEqhMTWdimTwZxMUjYHzF5Z4b+RJxy2Ca2I4+FwayT4pw6MPVxr1jWtY3QhZ0QPkSbHAjbzs6uM2SronroMfp5InjHXuU4zoLgec44pS+0ie1SzVgIjRcUmDp03X0lpxR4fHH50a4vB05fM86wY/ERMEDcV1dGcbCikHMDpTrOPDbz4b4LMatkkyF1fEKtf8smSgFbjROB/4jV6hxAqeFvkODHe5v3qmpr7ysQjH+5kiqmmOhXZ6c4NL32L2NdtIc9ocKQdfyL2fxyq6Fg0B+kto/6Gy7ym51rXDQKFhEft5KTNHj23vm9U2QTM6BWd8VhKKF6DwSI37VUmOBzXtUew7Gde
 svzMz+zc
 2c7CfZLaEEM63B9Sl+/pNO9L0585AXveJmvY8quTsomrfjx3n32obF9cZZZ8BVPxtJEsDYd569QF9p9guT6aczszb6Q0ekMh6cVGRsmykyvA8F22hIDytBQAzIIDaEn0L3obsY1QSXCMrkO5J7i8cTEIYl4mxzNya8l2i5UriL+PFCG+rJB3ckl3ijy81LmpOnDVCpsk37eSVcQkZG3k+N9kW+WuZmJOkiLjude+sHT0cWQfEoZcmJf28/xIHyFLxA+5U1IbsN/vk2RMrYH6ukFavXVDdl92j+TVZCEK+53QG6aADfACjBoXt4p6wAF4tO5jf7NXUvUlbeSgRFFRjoPdhfQ7M9TDyuF0BEHNo1Hg/WdTqPC7GGeQsfPY5dsvhhlP7Q+Aq9FjUqnsb+/ulmNbFtvQj1S0mdcZbdb6h2CsfnpCVt5NeccIOIYNTi1lCgTLVPI5LbTSYp+fjyzKTVHLZkmv76zrtQnogfpNfAOQ6AzgT1KQpauGOJVV05NEg7ieR7c2EfWwpvZr68Y5V1cLwHZGJnxDv/8zvz2eNGNmk+oFpIbyHKCP7m+DtLhEEggp8eapqd3JUu138AX6G9UAP23ILKHSpi6VyzF9ZN2rhj7qQ8d/M9vlpYhqtCnaAwryiWu1rCoslHyB0mcL0BK9xl0q5xGLXpjxKoKbXhLT7gxitr5Errl6Nkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 07, 2026 at 08:16:56AM +0000, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [260204 15:29]:
> > On Mon, Jan 26, 2026 at 03:20:17PM -0500, Liam R. Howlett wrote:
> > > * Alice Ryhl <aliceryhl@google.com> [260121 04:56]:
> > > > On Tue, Jan 20, 2026 at 12:54:47PM -0500, Liam R. Howlett wrote:
> > > > > * Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> > > > > > If you read the docs, it sounds like the difference between these
> > > > > > functions is whether mas->index and mas->last are updated. However, if
> > > > > > you read the implementation, you will instead find that the difference
> > > > > > is whether NULL entries are skipped.
> > > > > 
> > > > > This is not the intent.
> > > > > 
> > > > > mas_ should return special values including the XA_ZERO_ENTRY.
> > > > > 
> > > > > mas_next() should get the next non-NULL value.
> > > > > 
> > > > > mas_next_range() should advance the maple state to the next range,
> > > > > regardless of what is in the range (NULL, special, or a regular entry).
> > > > > 
> > > > > Both should update the mas->index and mas->last values, if it moves
> > > > > (ie, no error state is encountered).
> > > > 
> > > > I guess I'm a bit confused about the difference between XA_ZERO_ENTRY
> > > > and returning NULL. Isn't the case where we return NULL when a slot has
> > > > been reserved but not inserted yet?
> > > 
> > > mas_ will return the special entries.
> > > 
> > > mtree_ will return NULL on special entries.  I think this is just
> > > mtree_load().
> > > 
> > > If you want to use your own locking and use mas_, then you can filter
> > > out the special entries yourself.
> > > 
> > > If you want to use the normal api, then the special entries are filtered
> > > for you.
> > > 
> > > This way you can mix/match the apis but the noral api still remains
> > > simple to use - even if there are advanced users that mixed in.
> > > 
> > > The idea is that if you're using the advanced interface and storing
> > > special entries, then you probably want to do something different on
> > > those entries - at least sometimes.
> > > 
> > > > 
> > > > Like the docs, you use "get" vs "advance" wording here, but I don't
> > > > think there's any difference behavior-wise? Is one intended?
> > > 
> > > On return type, no, there isn't a difference.  The difference is where
> > > the mas points in the end (mas->offset, mas->index, mas->last).
> > > 
> > > If a NULL is encountered bu mas_next(), then we proceed to the next slot
> > > (which must have a value, if there is a next slot).  So, mas_next() will
> > > always return the next entry until there is not a next entry - then it
> > > returns NULL.  Note that mas_next() takes an 'end' value where we'll
> > > stop advancing slots regardless if there are values.
> > > 
> > > If a NULL is encountered by mas_next_range(), then we return the NULL.
> > > So, in this way, we can move to the next range even if it's NULL.
> > > 
> > > I hope this makes the difference more clear?
> > 
> > Yes.
> > 
> > But I guess the docs should still need to be updated? Right now, both of
> > them say "Can return the zero entry.", but one of them can't because it
> > skips them.
> 
> Neither of the ones you are updating should skip the zero entry as they
> are both the advanced interface.

What do you call the entries that mas_next() skips? You know, the ones
where it would otherwise return NULL.

Alice

