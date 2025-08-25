Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBAACA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246268E001A; Mon, 25 Aug 2025 08:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D578E0001; Mon, 25 Aug 2025 08:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A5E8E001A; Mon, 25 Aug 2025 08:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 058138E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:30:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACFA91DD7A0
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:30:19 +0000 (UTC)
X-FDA: 83815212558.02.E52047F
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id D9032140009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:30:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nt46Qorf;
	spf=pass (imf09.hostedemail.com: domain of 3WFesaAkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3WFesaAkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756125018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLj1YIFjwaRAHRpa3eawEDP1UKRYIus63pdnhlf7p74=;
	b=4rS/QgPYUDvwlXdI0BrqQODkvixw4b331Hvfa87Y1AGq87IMJNW1XMsgXbIcVym8nRYpr3
	ULa0FaZoeG3DdQl0kkCHMAMb5Gec7m2NH3RMTzOWRuYH9e62vVHg0sGoHifwQoVebJLfn6
	g4sI7df/N9ozcAhi3H5j2Ub3RBhlXW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756125018; a=rsa-sha256;
	cv=none;
	b=R8x0mWETy/JS2MF96BTjMct8MndRtAKlLKgEc9ca89mWorrYmaZowKksNQCDFTomtMYmKR
	FRX67r+czmusBpklaeuucyh1on7mGP+Z3VWGGCuz5cjM+A/EMIqvLM55cULqsAemynBu3Y
	gCH8cYik9Pz/b6cysAxFRL6O45UzWRY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nt46Qorf;
	spf=pass (imf09.hostedemail.com: domain of 3WFesaAkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3WFesaAkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b9edf5b346so1875871f8f.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756125016; x=1756729816; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SLj1YIFjwaRAHRpa3eawEDP1UKRYIus63pdnhlf7p74=;
        b=nt46QorfEGc/aL/y3y1gLtvtiXNKY+r0COgTtWE5OSZ5wirithPtlpCsroJ5Yp47K0
         W9b4SVaQ2+5vDNHU7bsNc17LZCNSz8ECKQkJDGQ5N5Au8CoXr6wXGmNLf8fl5YDC+eNG
         xVvLlvxUXqgGTnSnX/2DfwKQcXmCGaDxr/XjPlRaEzi+ZbcP1OLtKH9SoLgHIhjpOYfm
         MQkXomxKWVYYhRqoGfMgmIc1TJFMtHL0HBdHzkOx5Bv17X4UTMZzkCobQVrJKB9pvCdY
         tdGe1FWPvUlQKon7B9dwdesSABxMwyK4NoC/qDhnAV7rJokGcHSua1DZGM0yCQT4HWvJ
         4tCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756125016; x=1756729816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SLj1YIFjwaRAHRpa3eawEDP1UKRYIus63pdnhlf7p74=;
        b=IA58fBWUSeed2JJqXoouGR3ZRHahP3gaSM674AnOT2scau0D5rZOtJaC64NfXnJoql
         XrAlVoPsds8qWwdqDfLMtA/YC8wP+f7lLg/u2WhJ2krWiRDJXgdklyJ6mwL4UvyK2UFf
         pms1CqOgLA3AJgjit9d4L0GLDG9CuxEcCQgxzhAM+Cafd4cXvN/88VK/ruLzVGse/ipL
         DkW13P/+IJl8jeRv94cKvqgkWbPwLPj4BWfif80QJxhxS63WX36Tgwg7BGJD1rNAqgQ1
         zci659qvlunaQo35G4wa79F8/Jz6orikWrvRNJrDVS158hFuQYau2N6iR677UkH75oQz
         mZeg==
X-Forwarded-Encrypted: i=1; AJvYcCUFi8Qoye9y741uN/cWQaYi1JWZIjfSbqxyf2cJ3LS7pLKAlazj5CbBMAB8l0srR1gZ7uxnZB7onw==@kvack.org
X-Gm-Message-State: AOJu0YzHOAw9EgAL20o6vDAeDOKFgk7d1pKRfX1g+lmt3ntiIj13bIeG
	CIoWBn0iUA946feibhM2qi3P10MYqMG3sUbElsFe5n0295EAS4TXqfEcnxd80vjs8vcNvHCRhw+
	BKc5J82v25ZJLQW9viA==
X-Google-Smtp-Source: AGHT+IGfNfFcJqlPPh2CO3TEuFlkWXy0Jp7NPDl4lcwbEkAaO8Ya/l16lBvI3Ir5wd+v5zFUtMC7R0Fb1fNxLXs=
X-Received: from wrbeh5.prod.google.com ([2002:a05:6000:4105:b0:3c9:38ca:2c34])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5887:0:b0:3b7:78c8:9392 with SMTP id ffacd0b85a97d-3c5daa2b898mr7662572f8f.19.1756125016321;
 Mon, 25 Aug 2025 05:30:16 -0700 (PDT)
Date: Mon, 25 Aug 2025 12:30:15 +0000
In-Reply-To: <5ssx3vakl3enjeaygpxfqtb26ufehwfjvcwqfna4xbhc645xpj@lzuvaf3my3f6>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-5-229b48657bab@google.com> <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
 <5ssx3vakl3enjeaygpxfqtb26ufehwfjvcwqfna4xbhc645xpj@lzuvaf3my3f6>
Message-ID: <aKxXV5BgpW9Gzw-v@google.com>
Subject: Re: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Ballance <andrewjballance@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9032140009
X-Stat-Signature: f8whf4z1uachaewg8xrf1fdwgteboiby
X-HE-Tag: 1756125017-938543
X-HE-Meta: U2FsdGVkX1/RFAobm2hE6/VTkrxEhbqzm0FMm7NAC8cWjrUOHwgUjZJQQpIf0d3kcZHXa+OTSzxIitxj2OIcwl22gmg+3lH3uAn4MBUTxxwdgPCqwLRdnnfp+fb1dXSaUMdLavSogGWee/xGW+m8cMJwpkRYz7iK3Nng1JZdpR3Byr/B5kfq5Yr3t+Z+al6h8sqnMUwbL8rcqd2SHiztyjYL3E2O0v0/FHWwFfrFVZgHNQnTAWwQFALkLRZqSfrnjxaNj2pMoGwGa+jdBJr8n7UOGwTNvr2pV0hlc/f9BtoIYYwgKWiDk1D6DuZK/SebN+toX48bt4xllBSWfUA/+/H8QZBImWzNx8nYteraz6Nx/HhUAUAv0g6eWTTF5PI0KnWX0iOyHeUy7RQNlUqs+yYu4niAHA6AuNkLgKNyGUaj+nlYo2qUkKXy7zoWNmDNIDuKeIgSc0F1rbphJEShBCDmrdmex+q+33s+zFSyYl2La5ksEIeqF8tMgCZmmMu60FSmNWPEAxfU9f55Wyh9lOMXdlb/oURf9ts83g4EOWZzkqveK9+Vpk8TWSvju8OWhzybEE1u0+XQAYwWv6VNeXDzDyntLynuBKKdhOKpjDDCg1xrX4K/cLUOwGIlEaEChjkD2Djkw4CNuMfG7NyKpvcqZphGqLgWI2WQXjQcGtpY+6xRT8rhn5+qiH5zk8UqPXHmG5mEm2apo2N+2XNz2kdzCX+160fFvr/Q7PpdLemOJV/7Pm7HDroXjtMH6psVW9a59YQVtIf4HUXox4XnVSsrrgxq2jFwBAWkzf8fFK6gDZEKS9W14f5lacpRToQGPS2poLAi/k3yfcY1x3GcYykWFnNM/NgfWBv31dEKnpLGt0N+sCgP2+1/oqEL0CblAlnHGlPaTmawmkGhJQ42FNd6DLhvbntsVovtgaK3SMcZg5EkXIlcPiK7WkIgtFIUOXNQUgSv2+IKBoPMNeM
 8cmRBxUy
 MSPBNS43mY9QWNRxYmV9SpILQZuRZGtGs3YEWxDiy4U1TiYFMFkodj9aTben1k8XgIvNuo5Ox0GCl0WWWv7syLDsnRx/m7wpGw7pexNABR3I5/6G7Mz+/UByyKvSwrAyuK9twun/+Sxke9OgKT8GId5dswQwSTu+5bw8kvdPbro3r2UTaE933/n5D3LaZhMW0KzlD61ax/DgLIZzk2+SyfZOSuIxPOHLwhcobJZ8g10tgC4TAUwDeOfkCtjwPq6w6e9Ahmkxhs5x/c7UlcQ2M/eU6B68wW5yLziJcFelo07Tsad4NZm/qtYMWTmriQGaghVcvoxojTfw+gneupMP3dwVUhFv7yeMEnio+uttcbN4KbIL0iLbwaWCWJMzOcbYj5dWUw0MdBJFxW6T5GyrZ2cjB1B9+aM4HwlcUrfNYKqxc57DBb41VDYJde2ZbExvtBnCCwyOpYAEV/1RRUFaHQHiXi4xhDzF7jXUSUcjGBurpHElhZx51WIovKItyq5Zm1s6LKtK1mko39vK6JvQb900VZzC28A66Sz+Ox/qY3mcblmfg32lA4aCoDcxX3MgEoMK2AttIU8jguT7ScNtdUipha560C7DN5z5c8NQnNBAC93LnK65iq7HQrkhQ7wYYTMnws127W4l0JM5x7Bh9LK3a6HzwFp8N7DHRkhKyXL0lC+8UZjXVB4bgsd4pbXu2SOQvkfk9tsUTpI+xEbMQydIh7AP147ycq3uEpboRWItk+wejUCilrTtNPMmVVYV8Lp8BTGbEPjh0L+IcUboYdIl+rR4qg6uJtJVGwJV7s5OIXT0+/WMNRLNWyjUc3pe0t9UK/9Lzk+p0lU7sGjkloFTViYqRIDdq7RL2k04dOvNN0TivkZ8+ZvNFixP6YaiOGMy5MAkIayvULg7xsrV7Efwg/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 09:36:10AM -0400, Liam R. Howlett wrote:
> * Danilo Krummrich <dakr@kernel.org> [250819 07:49]:
> > On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> > > Similar to and just below the existing MAPLE TREE entry.
> > >
> > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > > ---
> > > Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let me
> > > know if you want anything changed. There are also a few other options,
> > > for example, I could just add the files under the existing MAPLE TREE
> > > entry? The get_maintainers script should still send any relevant patches
> > > my way because they also match the RUST entry that has a wildcard on the
> > > rust/ directory.
> > 
> > From v1 [1]:
> > 
> > 	>> We should have another section for the maple tree, since it's not just
> > 	>> used for mm.  Your stated plan is to use it for GPU allocations and the
> > 	>> code doesn't live in mm/, wdyt?
> > 	
> > 	> Sure, I can add a new section if you prefer that.
> > 
> > Maple tree is already used outside of mm, e.g. for regmap stuff and I also use
> > it in nouveau. Hence, I read this as moving maple tree to e.g. lib/ adjusting
> > the existing entry.
> > 
> > I personally think that - of course unless the affected people prefer otherwise
> > - it is usually best to keep a single maintainers entry for the C and the Rust
> > code. Maybe Alice can simply be added to the existing maintainers entry?
> > 
> > What do you think?
> 
> I'm not sure what you mean by lib/ since the lib files are spread into
> other entries by the looks of it?
> 
> I'm okay with the entry below or adjusting the existing one.

In that case, I suggest we do this:

 MAPLE TREE
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Alice Ryhl <aliceryhl@google.com>
+R:	Andrew Ballance <andrewjballance@gmail.com>
 L:	maple-tree@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Supported
 F:	Documentation/core-api/maple_tree.rst
 F:	include/linux/maple_tree.h
 F:	include/trace/events/maple_tree.h
 F:	lib/maple_tree.c
 F:	lib/test_maple_tree.c
+F:	rust/helpers/maple_tree.c
+F:	rust/kernel/maple_tree.rs
 F:	tools/testing/radix-tree/maple.c
 F:	tools/testing/shared/linux/maple_tree.h

Optionally we could add (RUST) similar to the LOCKING PRIMITIVES
maintainers entry.

Thoughts?

Alice

