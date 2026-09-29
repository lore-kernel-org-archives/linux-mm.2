Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2867CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40BB6B008A; Tue, 29 Sep 2026 03:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1CE6B0092; Tue, 29 Sep 2026 03:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFE56B0096; Tue, 29 Sep 2026 03:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 918026B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:40:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E6ECA0412
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:40:02 +0000 (UTC)
X-FDA: 85266001044.12.9F86CD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51FC21C0003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:40:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIPigIjl;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3EVKaVLylqb9RWBjtjzgElhNbiD4VmAvFVDm8rDfD4=;
	b=jEhKVf8EiAgcL7Xece1p4VXVLJQzTUhJ9QXLeSLqIKQM7+cLEq7pqB8GgQpJfleQFrvYt9
	X/5XpQRAGnyR6HtYpVNIQU2aghC0LEpCotOC9IT25/aaGRSVRb2ARNaIdURAwzSEYeyQxi
	aTFF0iz+A8FZFY3U51xtmrXdWnNfzx4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667600;
	b=zybKwCxyaObzXiDaSDi1q/NkQNQ4yQq876OwnZYrXtWuSJzfG2GgInBqtGi0rLQMDb7BDW
	0iPnMtyMljzTF1+V0Ho03xV3m/vWegK/E43OlUTAfysBbwymbjadQxqgnMFCdg2vTx9pNz
	hdEotY5ZAxoS6C+tSH1JUzfZ6geFUOI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIPigIjl;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 876B543942;
	Tue, 29 Sep 2026 07:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3991F000FF;
	Tue, 29 Sep 2026 07:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667599;
	bh=G3EVKaVLylqb9RWBjtjzgElhNbiD4VmAvFVDm8rDfD4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HIPigIjlsAUgH2jHDO9FkW0Y8+CWBqCvft5W6cCrP5+fYqW/khvQic3GSlV0DZDGd
	 Yzxjn0LLsdXvtpNd1OTY8YAjKFv1ThHYFUTY0cM0DUJj2GDhA0iExCdDLfIw2hT6HR
	 SsdBTLb4xeYO76hMr6zhJ0D94UZqpa4yqeLSG28mS0hX257UBTf4CbWYeYD9/WYbP4
	 Er7hHht/rArymYXeCoIyQfCNorypWHmHtzLTXYC+Ey4jV9Xf/p61MdSJNTdMCwKkT/
	 RZhSbxga5O0aBiH4/K0wTR6ycSjijqr8blTJtnk7AwRyX5LwzY2hWpI5gI0Y+LVRvy
	 QzEXoBo+iTp+w==
Message-ID: <a31cc06a-c22f-41c2-851e-4827869e9df1@kernel.org>
Date: Tue, 29 Sep 2026 09:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm/sparse-vmemmap: move vmemmap optimization
 helpers to a public header
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-9-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-9-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51FC21C0003
X-Stat-Signature: d3si1pjn668hhztcsia411fowbne1red
X-HE-Tag: 1790667600-409616
X-HE-Meta: U2FsdGVkX18u6eQDEOWLoTzfAEz2e2nTOdAVxwphMIVsM4QhaqniTW8jz5eMErgwi5vDPkUJ3O7puaRyGkv5XdtM+ZCxbo9lNYRVV2PLWDDndPi2+5rWUMsWnTJC/NG9c9j4UmzQp5UQKo//6O2+fiwbcTtQXW5GSYLs2SpPNbhWtmz9hSatdvGtek40ajovOR+7zmae37QFs7X0ARzPIgWy7RqWgHN2j5GSB64DvZuA+XUR/0rBcWtLeugTy5ptxZhVLHD4XyWjp/aereg7aGbuEnp+iXDS+kRQ/7Xq8qh1zJhXp3ihSwPiK3zc5T4IGS1HVMCoYFKSBoTDb5bxeso9Wvj1UyCS2LnrvQQ57ztng7gkj/73blUTyEMyDPhwr2EYWAXnph5B+TZDZXNScKy65Lflmm2ht6K1t6kHoGt4X2ernZuFdtqjPe/b/5wiZJ7ZgMGA9+EDz+syKfZ7GhlaGoNhEzlukSVwi9OtaVYVVTkGfLmPo3IZlQOxx5fdN5LM2QYVJCr9k/lOP1q8GcPEhkQ1A8Lrhw03Q8tjL9k6hPsYK0In+7Oam3vxopGxLhg7z+8eRYT3lVIUuOtSTai/9tViSaf+6uxHOnCrpMxdZSBgADlVpapePzsmbF46Xc5NfkeI1VzMU0JSY785LcqNV49CJWxqChlusqv0g+19R8ahNFgpSkU3/pK+wFn5pdIguOuZvzEkiWPlvAzYLvgZCe1Aqpf4i3x4XFYCb2KFXsZ+OWxoOkZKtCzTbdUQy7U5LNnIHDJZYV4dF3v7BNEWHVwCTbX5RoSN2QAGgpSb4eLl2EaazUYuXVKmSLE0YgPTvaBKt7eCwLDQwAwTn+10wXq8Zm1ElmAgFOHA/VCjvyE9pKlomad7TWmhsw6nKN4p43uaVAqvV7OyzqSLGaoqkGcYQo4+QabV6vmm29sOZk0F7PZ72kV4cSvAubdHC25VM1WNF5+/MEgWNDg
 MkLXI4dp
 SiKabCreLGnYsjMyOJ3KGGBj0cKbOTtRMaY01TgfAoJIskmwVMew87hTmcdUNYMCYHNGeyjUbd1v2BU6ySjmOuy5xhjwGzv30pkCJpwdfX+h1JeetVGxdui1PQfvwe5AWRoNWJDaKZfW5/Ib8JQMPW2SwfD/OCqdXM2ACoaGML856NEXsFF0w12/+WaTr6hmHJF+oz16LQKqu99JzTsP1VEcYMuOXtFhSM3yLH/9XAyO/Jsx7gYk5jJWJHasEnBwY/wMWDnL0TnWmomcR+INzd1r26BEEesESXOpw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> The vmemmap optimization helpers currently live in mm/sparse.h,
> which is an internal MM header. That works for MM code, but
> prevents powerpc from using the same interfaces without including a
> private header.
> 
> Move the declarations and inline helpers to vmemmap-optimization.h.
> This is a preparatory change for powerpc, which has its own vmemmap
> optimization implementation and needs to use the common vmemmap
> optimization interfaces from architecture code.

Which raises the question why powerpc was special and will remain special. Wha's
the big problem here that powerpc must do special things?

Change itself looks good.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

