Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE7CCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3303A8E0013; Thu, 25 Sep 2025 05:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0D58E0001; Thu, 25 Sep 2025 05:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0B08E0013; Thu, 25 Sep 2025 05:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07FCB8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:54:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A3F41DF89D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:54:29 +0000 (UTC)
X-FDA: 83927312658.09.B55C28B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FFA3180010
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:54:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhLOPzA9;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758794068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odFwyj49eFO1SIKaPBFCNOqfjbV4lBeIjEN5T7KnNg8=;
	b=ShnPQC73WLVEgN4f7/b2lKHzT8NeRKQrAtI0OsRQH/F6yb7ZPndidTOP9JEkGswvQFr38+
	+WFbmsWSjHRldgJnxtYom4nsOpAmKQvztWHoLjhI+REG0j+G1Y43mVz8FszRCUOgfldMle
	FwHiZ+r2JotSD+nP2Ts8AhO3wC6YvIo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhLOPzA9;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758794068; a=rsa-sha256;
	cv=none;
	b=pleggotP6N9y4KyZALHGX6tCZWpXJaiB2O3p/Hh68hkdNmVo+XE48YAcK56jTxSmcjTIq1
	kc5fivltor4+hRoLOBR9zCvgF0LKdgxAyT+/do8WYddXquERbxkI5CFNaOSdkGlNjy3hz1
	mFyGwmKa8uJWV3JpVQy/yIQWO/uTCWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CD4960493;
	Thu, 25 Sep 2025 09:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED149C4CEF4;
	Thu, 25 Sep 2025 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758794067;
	bh=xfXQiQFl7Tui7XJKKsNvDs46qyN1OX4PNUAUOBUQd2g=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=GhLOPzA967PCCw7XlP2pnKVSM5E+BTjPS6wrBIWagHaG22BtnNAJ47vSD6MdEN+Le
	 sPUGTUs/mQ63cxS7ROkrSbvKIRPxTMmOF1G/DqVcDWqCSkFchLyXlwk9YpeZqJdJ+j
	 Iw1iT63w/VyKZIZKY+ux1OyQPI4BhRsEkgoipDw8AULKU2PbMRruJ719exxqHv8I++
	 Hq3vbsMq4GoKJ4F3/c9RphxH9HKhg1PnLaqmQjMhm+v6CK5AewuXriViXLLFzmoCpd
	 J4w3utXUms1jrsVhkuU3jNSutwtGPVnN7KAIwOaPNlPcLIBvqxL4ueoiORRqfSghzk
	 qiNmNBTMhP45g==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Sep 2025 11:54:22 +0200
Message-Id: <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <linux-mm@kvack.org>
To: "Elijah Wright" <git@elijahs.space>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250924193643.4001-1-git@elijahs.space>
In-Reply-To: <20250924193643.4001-1-git@elijahs.space>
X-Stat-Signature: eyphyenk34sf8wtmsi3rdwzttwr51xin
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FFA3180010
X-Rspamd-Server: rspam04
X-HE-Tag: 1758794067-548898
X-HE-Meta: U2FsdGVkX196NP8B76gJRghLtCIxriDfP5i3KEM3qUh0NLUWjXJXRL2hrSHGSaQ31AK/kSpn/7E+yywi0kZ60KDHWId50rK68ZlbcJJ7ylxMhNaYgpjl+u45Qq8xDtKtDX4OkpHDH9C1ZnGGNMg7WGkW6CDZOd1EM5N+go7ayJVAe6Fji3nY0b3RMAqaYGWEBW2hn/F+zVYOqqXn9nrMnhWf+1iFfz9X/2QPGUw3XMDXhuHKYUVRWX/ONVuQoRrLnSU1kHa+9SYbEetQxqStg2tbV9xGrnnCOmbgZt5p50BFYBKIhUFRm2ZH5bF3gXp0r9fDnH6TZZfFcjQ8lklckKNfgDfakJbrGB7evvX//c0NyKyoo+XaCPKXF09reD/gjXaCJ8BqydwfPSqhFUqwh7BLq3tAFclV6QlGi3B29NjbgLd8tf5Av/nnvcae1GgARO78ynsycWYDWRMHPp2xqb76czQ3tcCq2n60o5ITTG38ZncgtvMiZm8NMZrzPuY1xWQQMd4+D+l52vCgoGKN/PvfAXlzT3eyi5XES1NfJaP4evwg2TwUgoqvEk6oM8y8IBGIqeg7dreL05Lp1vCZoAFDXzX/uysplRZHnM+YHfPgPnFP1dVvEq3rFRBV1I+uzFg9axha5hNwKW9bX0e59MUE4Jvqejavqp/+9zaA2rXJP06nl5fJ6Sovcvb9t1kiOT9qO3lXE7lzQxW16J35W7qKb+2RhVBV+OYcDo+x+UnxH2i9miFQIt2mnitD7K/4JBWswb8r1GVIodSMMs5lkl3CZ059WY4AO/bKIbIZ5UdyFLuVXGgAiF+5A0/fxgM9zJTQO8M/QsHcxAvn1L1gxa1b7Wn+vXAKpXQaIpSXISFB7Cy4tHMm9Y6UvT/lUaDpzYQOyNgGnXhKlLt6DfZkFyKw9+7t6VgUALhy3O+4H9GnyLcsPlbpJvx4w3/h3PnMy6IZWDsQLc9eTtR4hQx
 P0njKyvX
 jC3nElRRtblAIP/OJ8KdYcdC8zi6sr7X+rbldZKz1rbIBwUjV+gyjv7pN2ute1ZkCaZABYA/KXzSF4xxBgo4aj1uiLbsPTk60epXwm+mEiI7r1rqCVh3Hd6/JYQ3oRHkNjTnRxtFZMNlFD+AMNC2xPmwtxuTOHoBFlal/KgpclC4Wzp0hoXI/V7b9wUVpoKoxUpiRbai5NE6YfKLSvT7SZ3kmXIhythwk4do1hB2MAoZJZn23PJJW2sDNFuX9ctC/Uva7GeILac7Vo4ypd7D5Dfh9i2Y3swhQjsR1gd+PgQ171BgJcyzcmtVu9AXIoYwucBbbQ4ZOKXne5uVnb/eZpywPM1Rfm/jl2VbrS6Wpm9+ToP2CdmcNOj1DpffPAZw1w2+g+bH6RoVoTw2J+/tFpRUsXJAFor56+17bI9APlbr6SE1p0S04vP+b4smdzsTbGmHu8DtEF0guwlNvt+BcgJ1Phdqqrtlo5wvyEf7vBx+fiAabwlFksLlRig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(+Cc: Lorenzo, Vlastimil, Liam, Uladzislau, MM)

On Wed Sep 24, 2025 at 9:36 PM CEST, Elijah Wright wrote:
> this patch adds a basic slab module for kmem_cache, primarily wrapping
> kmem_cache_create, kmem_cache_alloc, kmem_cache_free, and kmem_cache_dest=
roy.

What's the motivation?

I mean, we will need kmem_cache soon. But the users will all be drivers, e.=
g.
the GPU drivers that people work on currently.

Drivers shouldn't use "raw" allocators (such as Kmalloc [1] or Vmalloc [2])=
, but
the corresponding "managed" allocation primitives, such as KBox [3], VBox [=
4],
KVec, etc.

Therefore, the code below shouldn't be used by drivers directly, hence the
question for motivation.

In any case, kmem_cache is a special allocator (special as in it can have a
non-static lifetime in contrast to other kernel allocators) and should be
integrated with the existing infrastructure in rust/kernel/alloc/.

I think there are multiple options for that; (1) isn't really an option, bu=
t I
think it's good to mention anyways:

  (1) Allow for non-zero sized implementations of the Allocator trait [3], =
such
      that we can store a reference count to the KmemCache. This is necessa=
ry to
      ensure that a Box<T, KmemCache> can't out-live the KmemCache itself.

      The reason why I said it's not really an option is because it discard=
s the
      option for dynamic dispatch of the generic Box type.

  (2) Same as (1), but with a custom Box type. This keeps dynamic dispatch =
for
      the generic Box type (i.e. KBox, VBox, KVBox), but duplicates quite s=
ome
      code and still doesn't allow for dynamic dispatch for the KmemCacheBo=
x.

  (3) Implement a macro to generate a custom KmemCache Allocator trait
      implementation for every KmemCache instance with a static lifetime.

      This makes KmemCache technically equivalent to the other allocators, =
such
      as Kmalloc, etc. but obviously has the downside that the KmemCache mi=
ght
      live much longer than required.

      Technically, most KmemCache instances live for the whole module lifet=
ime,
      so it might be fine though.

      (This is what I think Alice proposed.)

  (4) Solve the problem on the C side and let kmem_cache_alloc() take care =
of
      acquiring a reference count to the backing kmem_cache. The main quest=
ion
      here would be where to store the pointer for decreasing the reference
      count on kmem_cache_free().

      Theoretically, it could be stored within the allocation itself, but i=
t's a
      bit of a yikes.

      However, it would resolve all the mentioned problems above.

I'd like to see (3) or (4), also depending on what the MM folks think.

- Danilo

[1] https://rust.docs.kernel.org/kernel/alloc/allocator/struct.Kmalloc.html
[2] https://rust.docs.kernel.org/kernel/alloc/allocator/struct.Vmalloc.html
[3] https://rust.docs.kernel.org/kernel/alloc/kbox/type.KBox.html
[4] https://rust.docs.kernel.org/kernel/alloc/kbox/type.VBox.html
[5] https://rust.docs.kernel.org/kernel/alloc/trait.Allocator.html

