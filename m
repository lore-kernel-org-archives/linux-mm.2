Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 837B2C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DD76B00A9; Thu,  3 Sep 2026 06:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEA06B00AA; Thu,  3 Sep 2026 06:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDB46B00AB; Thu,  3 Sep 2026 06:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65C486B00A9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:09:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6809AC04A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:09:26 +0000 (UTC)
X-FDA: 85172028732.05.2A2F84A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A351D14000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:09:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWQUiP1o;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430164;
	b=a/TgfYSpgmWfODTA70GK2H+D3QPctXFt7d2Dbsk9MPDv/t/cfpkzG34AUy0rXS1uhRGuJ+
	4mLAYNN4lU5db7+9aSpk54PtoHPgkt04AGcJuKpNuHjyGJ4ue9XNfY38t4M7wYG1oXFbLq
	WjrljKWtBFZHsST7LYIbjkbo95hzI1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kdCJbwtYjwdwpiipUS39ooVAOG5yIhe/eZjFNLrhWw=;
	b=R5Z02tbjgxha1Lqs72o/S/H+p6RcJt6YKI/cw3HJJvF+giAxVeHZTCnKSRiQjZ95CyYNsV
	Q0w3uWRrUTz/ndnQql2qBOF60VHDg+AQyUp1h1t83/ufmWY5KN6jiEpHdTPRlzXfWjhU9K
	MNwmFcV3DbNiObHlFjFXdrGUAK/HKkA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWQUiP1o;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A89A360210;
	Thu,  3 Sep 2026 10:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FF11F000E9;
	Thu,  3 Sep 2026 10:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788430163;
	bh=5kdCJbwtYjwdwpiipUS39ooVAOG5yIhe/eZjFNLrhWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LWQUiP1oDc+eiSZLGgpmxHE3o0lgmGDPD6pRBrIEybso4LD+iiD7oVPSZybfQqn+N
	 e+pXcMxx5xEbYpf67YbwHxpTwZAiunjHBdLE6XwEDjOu21gwI13462hMLlD7KpoXu1
	 QWRUYN/6v0rGEnohmMPUkmr9WhTTqDF+ssDO4uo78F0xcMUWhcZ5IjBqTTc5Smn84h
	 5hQn78UWMGO49s2DR4NTu5g+yo/jFVcpmyGWE4hu9r4k6lFYGrMnuaqUWqKUOaBYkQ
	 Cgee9cf8BCGHqX8IbGo7fq9ainGRzpHhoJY1L2lMe1bbHsOVxqdbsIBTY29RrS0iEq
	 Ozc+uYBVvmEZg==
Message-ID: <8a73da1c-0167-4aa5-a62c-4190327685cd@kernel.org>
Date: Thu, 3 Sep 2026 12:09:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] rust: mm: add abstractions for allocating from a
 `sheaf`
Content-Language: en-US
To: Andreas Hindborg <a.hindborg@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
 <20260902-xarray-entry-send-v5-8-d18adae40708@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260902-xarray-entry-send-v5-8-d18adae40708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A351D14000E
X-Stat-Signature: r87dxfc4jpyirttwaexagamu9qj5kxi8
X-HE-Tag: 1788430164-854741
X-HE-Meta: U2FsdGVkX1+r6GHwI/7JH84pXbTXrXLLpkReYHN6ifgjJUDxC5AElLiIR30mu0VeN+A8OueoR1k3mitc/ub/UIWRomwJyxWfm94DBZOGZKK8hvy2iUT8UdWCVD8zqn2T6KvmXtzPRfbbVCGizEj4LpkN2WwrhY01ruDmQ+xFErD94swdxcjQL0zF3jk5E9kvXYT8oal31oxKJTldDshRIB/IJdxOgbUUeQJKkmbUhD72KgReJwqgraVDQ4qmwZKJDpIlZXQk9/SA2uiKOoHbixZwNdWi8v+o6/0Qi5ZAFMW4+czP5Hqo+Z3EjyXH9JsVi6S7VGM0fyWPLDc2DH8KjbfLJu4PS9wQ9BO/m0rai173ifEgBAXSv1REg0iV9Sg6KlLe0AZD5W4yz1ArUULnV2l57xgx4VlUJU2JeUMPLqUlk39lA7bXKD/F0JNxTBOGYPnYs4OsOEf9C9E5dZ/x1YpTuzkUYv8wn1Tqgk3Ff5PpOFttJqK3S0Yx5+a0yHZP660oFiuzJ+A0v9nU9KBkrKkQ28jWYDpTYEaiEZpBO/HicRfg3ISGW2nuZNv8EaO3IVuSvhtI6K1cUcZHgUdepyupj0A5b3G3FTBvB9WtkR76HOVKg2im1VX5SDm6GN7JrcDTVuRmnmyKs/VPGlC8fEI3jAkKJo4D9MREWW4syYefr1rzbxDxu7lNOW7AJYq+bhd4X2jyM1XaYLcqs8yGBQIf9LmZZX5MShbgPQf4P4WWY48pGOWYc+MvKIokTCUu+VLOpuEaarYi8dlMJv9TgBOOb/kYwdUXzntnya/5Z/XjDt4r+YM6QgYOw8+LBZNE1zr2mPhCkPSkQSa6TziHgBt0iMmq5VU4QKHMDZCjTXsL+uvEGMFkNmYKOweKJ+gzfi6hHcSXABYnlwW19XgMwev0VGlJ92zvjOYvZXUFfzR8AZLvQgA1q7VBAG4WUeXNnZmDoLG1q5wrRhkSjof
 lmpJtPcT
 saEV4oo0Pwl+gv/+WljNf3lD38IGK9u3w5V1YAbVTxotwxkz2xX1sDZEUJVuq6KMxVW/Z82GAra3V8Rzze5cUBBlmmRrGvv0s7g7usDCamZq3HutNO4buA2un1yRykGCZlbT7kY0gCadCq9xv51iRqHQ8qgA57uLes8/uC89w6/8nI34yjkPYsDu7VN0Cz9EDdc0r/kc69wVOdUTiM60PDx40XtJRfIefCnprnRFeTJGG2d2+6vLx55Qr7CqnkIQvUKgtzTfEPTUNuyP5x7vneEjzYrMNdMfglT31jFqG7bDfGHxG38W5Pd6bN9m+Pjsq4E5UqLz50I+eY/5n9VeXBmOYHi70etrB8u6XZUzKybqmQriGBj34N+j5uZN2nFS2UTmveEDMJkHE6RC/XB47Hkq0PmVvKuOyQ/SAEx9Oy7k7KyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 15:26, Andreas Hindborg wrote:
> Add Rust APIs for allocating objects from a `sheaf`.
> 
> Introduce a reduced abstraction `KMemCacheInit` for `struct kmem_cache` to
> support management of the `Sheaf`s.
> 
> Initialize objects using in-place initialization when objects are allocated
> from a `Sheaf`. This is different from C which tends to do some
> initialization when the cache is filled. This approach is chosen because
> there is no destructor/drop capability in `struct kmem_cache` that can be
> invoked when the cache is dropped.
> 
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: linux-mm@kvack.org
> Assisted-by: LLM
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Note that currently all caches have sheaves (except CONFIG_SLUB_TINY or
slab_debug enabled), and sheaf_capacity on creation is treated as a minimum,
which the automated sizing calculation can make larger - in case you want to
reflect this detail in some of the description comments.


