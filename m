Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF15CCAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9CF8E0003; Thu, 25 Sep 2025 13:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1018E0001; Thu, 25 Sep 2025 13:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE968E0003; Thu, 25 Sep 2025 13:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD0408E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:20:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 920F8C047D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:20:53 +0000 (UTC)
X-FDA: 83928437586.02.DFE1996
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB41B18000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:20:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=VhtuGPKN;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b="R4Pwbk/D";
	spf=pass (imf16.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758820851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxL2goKemleRYcSYppLicJLKpdb0DPjV8PfpFSBecT0=;
	b=aJMJvLqLyx22wqK6ps6I/Lu6JlXU0zZVLrQfw+5KZ6km3bPG2JhoR57/D6/SJGQgFYeVXP
	7/T1nH/nRuAyq5WXmOjjw815+2/l0yBujaAwgN6QcGL5/9NpCydZpBxrPkl9MHP0zCl+c3
	x4/gvdZVb0d0Gi/hU+0YtEf4GqIx8qE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=VhtuGPKN;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b="R4Pwbk/D";
	spf=pass (imf16.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758820851; a=rsa-sha256;
	cv=none;
	b=F0B40tO72aSIGVH/z95RhDlaCij9NjFBLuiaz2PwzOhmQfe51NwPWRoA3xlHhjE6w6U9dy
	khkO/jhD2SVK/eWhd7UJ+k1GhuCL68lSPO4ZCtoh/sVXDjJ5LpZXpDdWCH7PTWcfj6OkdM
	PSQwRZDgFTJ+M6psu7pIViItf6M8U/s=
DKIM-Signature: a=rsa-sha256; b=VhtuGPKN+ofn4I8WGP0GkYmDMBmyLJdRXM8GhaHAkMsxRw8oMqH7q7350yJDTUbHyK1e+7b9vfft8bnL+YKirFTJD+l7eRwyNgxTqoOVpNfibMYy1i7OPrsmO0FikERsv1QzGycVfjTVLnK+38a7oofcABek8kvO1nH8m8Cue00F1BbCHr8OOsXjC8hO59i9VBmo/twYVWB4asO6+8QzpM/p0o5GVma+9okSV/0NHuGsnWVYBAxmEaK5elRhsVFm/arVDUC6qmzOJdCwlZViB3slKY2HQ3xUP3HdY5hkaJTj98lwuqhuCeoSJP0CwE7ZdVoOD4nJnF6HM/Xn0s3lQA==; s=purelymail2; d=elijahs.space; v=1; bh=97iUBxcczrc8d4ZjA8iMJpyUnogsQG3SuufPU6f2ca0=; h=Received:Date:Subject:To:From;
DKIM-Signature: a=rsa-sha256; b=R4Pwbk/D+8Y/tpVxz1UD8WEKrmqbA1h2GH4KbnVGeeySbeDisfO8qO3fvelzJbOJ1GQM0IUB1lAcZqtoNhdWY9lsXo9bfhPHW31qumeUiphzJ1GQJXxxnsYwCtvZez47QBUsWLwtmtdU6pv/YmH7ioxgQPykEMFls79gAAuvo7LawcnDhTg9Zc0shEJbwCxlJjp+XwVfKqG1dGgmZu+gk0InSlSG2DACOjX4b6rkaVYaulLmCDOeOOxYA29hIeriQ6YgQA4cHtQCIYBt+Ebu+iRF0dPhPID5tumsI3rtrwN55+NOkja+EFaDwCb93TOgXu6BGvB9LMoq7et39OzB4Q==; s=purelymail2; d=purelymail.com; v=1; bh=97iUBxcczrc8d4ZjA8iMJpyUnogsQG3SuufPU6f2ca0=; h=Feedback-ID:Received:Date:Subject:To:From;
Feedback-ID: 26912:4866:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 1074361899;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Thu, 25 Sep 2025 17:20:15 +0000 (UTC)
Message-ID: <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
Date: Thu, 25 Sep 2025 10:20:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: slab: add basic slab module
To: Danilo Krummrich <dakr@kernel.org>, Elijah Wright <git@elijahs.space>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
Content-Language: en-US
From: Elijah <me@elijahs.space>
In-Reply-To: <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BB41B18000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zx3zr1ek44i5isfxcgdo6tu7qik1qwrr
X-HE-Tag: 1758820851-249567
X-HE-Meta: U2FsdGVkX1865cLENj+oclSW/WKe0GVPZ/ArJAMtx/hsbf/HVQmLOIkpKlv9QZYj8kMqX3jvgAoA7HbRJxCgsA7z6diE78YUWmcMrngnYO5/KzroDH+pNyUwfSutFj3u6409l0PVjZ5AIUzmdRm1s7GQUDpFyweyr+kqxqfZ+jXRFxAMvbVnqZ3AIBjrtwKScfXLEG2yKdbCZCbnRC91AqTXrJya7r4r3lG732wnDS41jbvTFr9C4Rk9M5iEriVWZm/pHVQxQ4oj2iJDuPKiqeRRVsv1Ub26M5D6+LXzCXF4TvETpbZlfl5otRivjeE+bD9e1RhlPHPaaec4wEqWluB44TprFcPesnMp9RFuQyizZns9+nJn/Pv7n5j/Eb6wtxqoU701uYX3LTE9ANaxRJwzdgiLLL8SJIhJBxlouHJcfsDjyC/uyAKirWpeWnfmwkVfWi4qV1oUtXhRvWpWcRxhQTOzBcHInCC32FfiG6dRL0IOyDyxMgZFIsqNscoQhsVHWtjsdYw/ha/4N0eE43NuVxNeTLwK2bNjS2YDgtBtY61ge/fttQmtx0d3Cl3QI393S2mPrCzl7G2hmmoKNnroWnanjoUbGTqZyf5HjYqxZr6RBv/fNosD2qrOo9FyvvBi35VLEaQzWeId9vSQnX7qR/7lG5a++bi++BORB1Q1U13r0VXlrEpHf/LmXo+himBow17yUFh+J4mIoxIwiLBQk1d6w5qTt7o1aEtywlu625AUTN4zbNz8sWBlVpaVfLzV6fQqaWJlgK++q9qzyvrjC2ZVrpahbRn5eyafWwCZAg9BoxiZfe4oRkeYDJqyoP6Ovj3pGbmvVt0Yam2tuziUIr/k5LmBG9J/HVzG6VQvNpVvrOc6B07phkapUOVI/Mor9sbZEJISbq52OXFCWmYGDwdveQpwy4+wpS2TMExbsPqs0qKtxacp7DZYV9qRrnCogCihdkNGQLLW/Np
 aW9we7o3
 LCYClmWcHDXCwzkoAG718iL3RFDFhlLUNdeSebZpnHjsQn3SuET10jfwWq/FQiQC51bX8+SXV8Zjqtxg+6nj1RuG8h2yIl7XwusXT2xNhLFw+gZrAdasi5XJ4UbJkepfIdy+F9MOsV4/4VOD3KB50RJnUPnsxpROcty+FuhCBf8PKClBDDmc8WykegNnT5SCT0AQDAe2UZJE4A2nhEVK54MhByQe2HP8Je5tx9NyTE73L0rJHMTxG62FAQZ1fovyJk7XgMf2fiBy5VUnkfYrZgJHQqcLWhiQwf490yrU9W1HKCQ4iPDH6MCzcd/jlwihRtKG8p/F5c4INqYLelfoGwrFozOzmVkfm40iq9WwKhfrvA4fDHkaHpBj/Wsf0weGiMB6uz1w8LwKNOjh1oNcbd/f5E/xgsJcdhMTyaiN1XpbCO9dKVfKexE4OaDUjDuDoJDJbBikoJ4+ESwOyvJ0oyWMuwegsWPLL2/uWh7dNefAptX6WgB+G3m46yDD79Uf2ZiIKJeEVwOqgv9jsZLDgII5XdURcrBJbHbOXCU0phPSy/+dU0AfH6PZcx6QDUMjG+nTUvhkyRAjpQJoS6PqaGkqc25ajwaWoyYbC+bUslXy4Pb3YhtcY5ZLRTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I was thinking of maybe creating something like KBox for kmem_cache but 
I didn't want to touch allocator code yet, I figured I would just create 
the groundwork for that to exist. rbtree.rs uses KBox now but I'm not 
sure it should, at least if it's going to scale to many nodes

On 9/25/2025 2:54 AM, Danilo Krummrich wrote:
> What's the motivation?
> 
> I mean, we will need kmem_cache soon. But the users will all be drivers, e.g.
> the GPU drivers that people work on currently.
> 
> Drivers shouldn't use "raw" allocators (such as Kmalloc [1] or Vmalloc [2]), but
> the corresponding "managed" allocation primitives, such as KBox [3], VBox [4],
> KVec, etc.
> 
> Therefore, the code below shouldn't be used by drivers directly, hence the
> question for motivation.
> 
> In any case, kmem_cache is a special allocator (special as in it can have a
> non-static lifetime in contrast to other kernel allocators) and should be
> integrated with the existing infrastructure in rust/kernel/alloc/.
> 
> I think there are multiple options for that; (1) isn't really an option, but I
> think it's good to mention anyways:
> 
>    (1) Allow for non-zero sized implementations of the Allocator trait [3], such
>        that we can store a reference count to the KmemCache. This is necessary to
>        ensure that a Box<T, KmemCache> can't out-live the KmemCache itself.
> 
>        The reason why I said it's not really an option is because it discards the
>        option for dynamic dispatch of the generic Box type.
> 
>    (2) Same as (1), but with a custom Box type. This keeps dynamic dispatch for
>        the generic Box type (i.e. KBox, VBox, KVBox), but duplicates quite some
>        code and still doesn't allow for dynamic dispatch for the KmemCacheBox.
> 
>    (3) Implement a macro to generate a custom KmemCache Allocator trait
>        implementation for every KmemCache instance with a static lifetime.
> 
>        This makes KmemCache technically equivalent to the other allocators, such
>        as Kmalloc, etc. but obviously has the downside that the KmemCache might
>        live much longer than required.
> 
>        Technically, most KmemCache instances live for the whole module lifetime,
>        so it might be fine though.
> 
>        (This is what I think Alice proposed.)
> 
>    (4) Solve the problem on the C side and let kmem_cache_alloc() take care of
>        acquiring a reference count to the backing kmem_cache. The main question
>        here would be where to store the pointer for decreasing the reference
>        count on kmem_cache_free().
> 
>        Theoretically, it could be stored within the allocation itself, but it's a
>        bit of a yikes.
> 
>        However, it would resolve all the mentioned problems above.
> 
> I'd like to see (3) or (4), also depending on what the MM folks think.


