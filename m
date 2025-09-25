Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 218EFCAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360A08E000B; Thu, 25 Sep 2025 14:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316AC8E0001; Thu, 25 Sep 2025 14:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFD98E000B; Thu, 25 Sep 2025 14:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C72B8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:08:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4BF1C04C0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:08:20 +0000 (UTC)
X-FDA: 83928557160.22.BD64E79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 165BB40014
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:08:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VCu6O0CK;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758823699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB0wMFj3w5DkAOIrIXxqOs+t0v3g0aa+ZLNBwn+S47g=;
	b=M8q1JP6dhKWuCFVZLhGl1x9zke9R0BMEOV6T26TMg4U7iF5BarkXPLI89389BPQlcATowi
	VDwLuVs70u6Q4NGJOs/Y9CJKA5fCvbHj6wuWfR96gemg8KW1vP1+CxOikCpsqATjd7Zj1/
	57F2ljNPdin69mGuCr10hS4CuRcrwwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758823699; a=rsa-sha256;
	cv=none;
	b=a8enZ6qwDFWd5malvNGtllMCWctm+iyniTgun7LbLJinRiRAF5vKTXDG3mtwqNQ2mDrdo/
	31uNkrIV/VWaof1sAW0DydZk0rW7zSGIE3KKfwjZObtUviW2KcWqg0Md0Pw0LwJQvxJIML
	gavPD6YG8p/zGmxuCo+MV5DNjNXWRPU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VCu6O0CK;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54800611D5;
	Thu, 25 Sep 2025 18:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DCDC4CEF7;
	Thu, 25 Sep 2025 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758823698;
	bh=IhODLG7SpC8UqyOFOuzbmh0gcIPtUBtutMgkCPYtEUk=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=VCu6O0CK3C1ef63EnTIG+lUmaIsdZkkSe1ltZTKpv+91uTh6+AjhH0TkIsDJJy1Us
	 AIcqy1EbJe/0A6P/lr1YLsOkv5kUc+dhLl33PWTq2LSCeEXhFCaKAvrd+xhA7b546P
	 3CWDoQc01y+F1MYSoCIqWM/trQ7FaCxKUApR3QpeRphIY8FE2voJMj/gH2nK/+vTlQ
	 ndlsHXiGA0f57OJkWXLJ9PUTJKQ0IECqwTG5OaHDHihAtmnJpoKmljf0T9f2cu08wz
	 WF7Sj+sPjU3rfdgQ6DOUK3RUAbKQg3V1BwyLw4G/8qdx1KykUGS9BXE7XnYSANZP3O
	 tkYHsJILaJzYw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Sep 2025 20:08:13 +0200
Message-Id: <DD22YQ6BWOVR.3NCRQJHLL63DO@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Elijah" <me@elijahs.space>, "Elijah Wright" <git@elijahs.space>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>,
 "Uladzislau Rezki" <urezki@gmail.com>, <linux-mm@kvack.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
 <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
 <bypo74mzotejpsjdqd55sxygq3wjffnnimpm3vhm2xr5bddmen@lt6sr77ys73g>
In-Reply-To: <bypo74mzotejpsjdqd55sxygq3wjffnnimpm3vhm2xr5bddmen@lt6sr77ys73g>
X-Stat-Signature: 8j9i75peoxobi4xy3c7ydr9tbu85yb77
X-Rspamd-Queue-Id: 165BB40014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758823698-521034
X-HE-Meta: U2FsdGVkX19A+Gmi9v0Ym6FoKqChwwR9ZhhGmLy81VsbkDOGggrLRf25qgoF2kc4yjZI2Aa2m+xN9kE3y3mp5TbPFE+aGWIn77TTrkHs+8a42O0t+R/VR1v7v6tfQUswuY6sP86zLl2ORxVJhsqESXGqTmooaQCa5THgCMCgUhdLRMDq6KThdNoYFgLRKgHSlvlDD19iKIFvTGxcBBO3aRnNIgKq5Rffv15FVVyjZX2jT2BqSqB1in8tDVcxsxKmXoUZ9wnb/+yWFZwrQo5i6+4ZFgq/cRaq5LDfRMKVVI4FAT1eime9bruCdyp1iStDAackcS/QdXyvIpPgUwkcMvXKO5m7O+yyUAUkQ9RltNSY2S84in3ZtxKTqWUpSJuwusAZbXKkEDwerJIL2daY4CnoOYBgbS4xw41OkTnO+bDiRFRRObT+PcAJz22F9bL+2uHcpDsGInifsRI8AlQM9jYiNIpxzKQ4E8AHOcEL4DK0nupsKzvS8tgRoOWEBPkJ3bfbfUAeGFyr5cmfa8PgdIcK8q5WEMJPTyWiSaweKPA33D/TSYxbSKrZEtO3b8bhT3GEk6WfCFjwqoMuRE/LJlib/WBmo9blAOWO+InuuBf5NY+AhI1bxle9ehg/mXusBZbf4lzmiOuLj9qbn4eeKFqzojuPmB9Y56iLtKfqvg1/Be05Bf5AHW8PonY5EIUilg5HFZ2AplLcOvtKi5W9hjjuwlKEOdTY85o7eIQInyttU5w0oRUbuiwto1DsC6bnJUxHymUzloyK8ywivhmqxWKQv2O9OZIqiq9NKl/G/eoKriGoNXuywdoEEi5+7L8TZbjGLGDxH/fdNrHVz80hG849i385+XEui6qYlXlJpYhtgkgfkU1XpzwdxZMppmjjRwCAhyL6HOjSFmUOxojV9kpXXeTx0VyA+DdgA5+7PbNtw0itaOmXxjV7WidEuFvHxa6MiIRqIbBU9Ibc+Gj
 8vfNCd9M
 OgOREoVVHhUkCIHuRz9Q38kJxPOo9epm2TcYJqiKZoduoUkE6P9FxWSoJMvBxnWSEAtleFbWj4j+9aN5pb0J9D0dKDOB5BHJVkejqYWCp0L40x+kOUrHbVfqVUpnU+BQJoWwpN9RH2a4Flp2nvc5D8bqlZdRpl8w0mrGqhXtzOqCelxb318kN4t5inQxLsQC41YziHiMx3zNOUgpMHfZo7Wwcm/Rf6cXR9JSZsVoNuMEauJ6e47dMfoskWWc2mqMhEl78YEHZ5xdKbVKQVb0Nmq7cKM924V0vLhSof590yb/d5cA1OFW/fZ35LSeSig6i27PaiSZMUrAqeoYOWXYsmX96WqgvrOBa9VTkbbuR/ItVveb51okUVTrxvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 25, 2025 at 8:02 PM CEST, Liam R. Howlett wrote:
> * Danilo Krummrich <dakr@kernel.org> [250925 13:43]:
>> On Thu Sep 25, 2025 at 7:20 PM CEST, Elijah wrote:
>>=20
>
> ...
>
>>=20
>> > I was thinking of maybe creating something like KBox for kmem_cache bu=
t=20
>> > I didn't want to touch allocator code yet, I figured I would just crea=
te=20
>> > the groundwork for that to exist. rbtree.rs uses KBox now but I'm not=
=20
>> > sure it should, at least if it's going to scale to many nodes
>>=20
>> Ok, so you want to support kmemcache for rbtree nodes. Ideally, you shou=
ld also
>> have a use-case for that, but given that we'll also need kmemcache in ot=
her
>> drivers (such as Nova) anyways, I think that's fine.
>
> This seems different than what exists on the C side, at least to me.
> The rbtree is implemented by embedding the links to the prev/next into
> the struct which is using the tree.
>
> The above sounds like the nodes of the rbtree are allocated on its own
> and not part of another allocation on the rust side?
>
> That is, the kmemcache would allocate the struct that contains the
> rbtree linkage (or nodes, I guess), but not the nodes alone.

On the Rust side the rbtree's Node structure looks like this:

	struct Node<K, V> {
	    links: bindings::rb_node,
	    key: K,
	    value: V,
	}

The allocation would be for the entire rbtree::Node and not only for the C
struct rb_node.

