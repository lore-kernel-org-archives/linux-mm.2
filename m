Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2602DCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681B58E000C; Fri, 26 Sep 2025 12:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632BC8E0001; Fri, 26 Sep 2025 12:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA768E000C; Fri, 26 Sep 2025 12:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5F88E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:32:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFFE91A06C8
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:32:16 +0000 (UTC)
X-FDA: 83931943872.22.80DFAE0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4FAF7180005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:32:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1bjT9Dgg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v3x5dWDs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1bjT9Dgg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v3x5dWDs;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758904334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++3RPss8tkNMIueGBaayAZaz5nmpmygwhQ2OcWCTOH4=;
	b=lI1tUM7kvrXQRmsuSx0PCWN19RpAaNU9VF7VHiWiGjBD/UUMqYT/Hd7u5v6eRVzFCv1esa
	GzlR9iuMJGlfuM3Sw3T+Thr2KRZUAc6PLgwXObEk1uvI/62kQXFdZRE45TF2XPpA7ENntL
	PH0trIfSfq3YfUffXH6QbOeMp8kCb6Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1bjT9Dgg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v3x5dWDs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1bjT9Dgg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v3x5dWDs;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758904334; a=rsa-sha256;
	cv=none;
	b=nETIHhT1/Avt6K0eqexfJkpKmNJxmjgtTs7HgHB2CNqA1bEa/dvFo+GGHsZ0KmpN7WbIjr
	76N0zJ9G4IL+DhQmaj7DNKRIuBxUIIZ1kDXGANCd2w9MJTYkUJO8kQfJFW8rW3P8waWnuO
	18C9vIuOz+P3sUM5Nz0CzDWk5PbWFyU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B9A4243E1;
	Fri, 26 Sep 2025 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758904322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=++3RPss8tkNMIueGBaayAZaz5nmpmygwhQ2OcWCTOH4=;
	b=1bjT9Dggyy4vaeHcTGPGSNoQDV72hf/p9M/oU59RlRU3ONgrHJ9v4hBYWXYwCLRCLpF2mm
	KufAscfRjqNdNJS4mBME8ayLYTT+REA0bQ+ibvWI4mvD7i0CpQXf4anZG4UAA+iXB5eqV4
	yS2ZPrd5V8VMGJuh9Mtfh8Gl1KGOD00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758904322;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=++3RPss8tkNMIueGBaayAZaz5nmpmygwhQ2OcWCTOH4=;
	b=v3x5dWDskwXHex4TOwIaXMfrG4SqkjXD8uw3xjznSINafXy4jCMgpWUgFlgb3PiSG2EWNK
	A/OptQhSZH/FgQBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758904322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=++3RPss8tkNMIueGBaayAZaz5nmpmygwhQ2OcWCTOH4=;
	b=1bjT9Dggyy4vaeHcTGPGSNoQDV72hf/p9M/oU59RlRU3ONgrHJ9v4hBYWXYwCLRCLpF2mm
	KufAscfRjqNdNJS4mBME8ayLYTT+REA0bQ+ibvWI4mvD7i0CpQXf4anZG4UAA+iXB5eqV4
	yS2ZPrd5V8VMGJuh9Mtfh8Gl1KGOD00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758904322;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=++3RPss8tkNMIueGBaayAZaz5nmpmygwhQ2OcWCTOH4=;
	b=v3x5dWDskwXHex4TOwIaXMfrG4SqkjXD8uw3xjznSINafXy4jCMgpWUgFlgb3PiSG2EWNK
	A/OptQhSZH/FgQBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2757B1373E;
	Fri, 26 Sep 2025 16:32:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fUhHCQLA1mgcFQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 16:32:02 +0000
Message-ID: <1f5ae3bd-db21-4042-b177-55464644ce2e@suse.cz>
Date: Fri, 26 Sep 2025 18:32:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: slab: add basic slab module
Content-Language: en-US
To: Danilo Krummrich <dakr@kernel.org>
Cc: Elijah Wright <git@elijahs.space>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <5f09b7f5-e7de-4333-8de5-322eb6d93aa9@suse.cz>
 <DD2UB5P01XW7.1GW33112S22Y@kernel.org>
 <DD2URCNO2P88.168J48GHSJRRL@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DD2URCNO2P88.168J48GHSJRRL@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4FAF7180005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gat4hshyb6nzecs48187ipfmzz7fuowb
X-HE-Tag: 1758904334-251788
X-HE-Meta: U2FsdGVkX18PuOLdze6JJcqP1C0/ecTTDibsK83paURlAqksvMriGgr7svpr+MIPKlgPxnDf5caQsAjTTIDTwLR7TGY9lsGA9BItpAenmjk+ghNoLTqEdyNAGdy+qagMLNJE7NlhvVHpo/+msxu00LzQwGNblm2Rhb7ZfsRZ2sSr70Sj2Uj9U+vZ68r/lw4ZkR52kgwPLjzgkknkX7PuijchKqWT/NG7MJQIbOxr8dZ1eqHPKDHsru6UTtvkXJxgJg3wDvGR7kPUwvJuroQF2C9yBmhb7foMFvkPXlwCzMCQZpD61WR7ib/J3WZRzCTMWXe6mUAX3pZQEzDW33t7YMoe2Dr5WjElgFEpgSG+QmXf0I+nlnoS1huntMe9WaEvahd5lvA6jLs7X7EeWFq9fjpVbcP0HLv78RiQMb2rBvAdXeg4cIbSpRfNs7UXTupzOMbfOsHMLciDN5QyxJQCkDKGjcQPcUPy5SVnDl9yYS6t5MLHAnLSBS6n/uAgXoxMQtVQtVoJvy4wstA3TylC6a7tUOrKBenEU9ac37HNwZt6oAZepgRVpcFMLhZTraOPp2zUZL+eKBz3+vxJfV6/jsJOlgfpWIR8DcOPEMr1sscNDEglHClLuIJ5NBWxaW+dDx45emNj49Xg8FTgbtXh3K0HyfVM3+MyVUH5PBSXhw//rCmRbOnoFi87OxKESfaQZ6BFVMVetX/PTaE7jojbplmQDvFY4HT/GTRgSGxpoZWB3i+lMe9jfbLB4ehnkT80/Rws0oafPm8sfffZoKdoerqFHZ2jglz0BN/Wk+E+/zwzQBsCeqsUOGIk/NgRuB/4vL/l320VNeh2lpO/y+eCW6kARw2nR4MySTjSpz07vY7IQIX3nW0jWB4pzOFPb24zN4JFm3Z3UtqJOLQuLSqw1R0+cmNZw/fwQDXSOaVJuN9ncLXDPeHMXP7D1IPey5s5cVGpbIoVD6RRwRocDfM
 iTZ7fofE
 Uy77pMzfuEcMK++ZAuAPLjeiaD2ZdCMSnNrIAdMjmjcRfsHscEn+60cxV4EO7z4Ssa0xioNXHJ3kIe/cF8GDPqrkDGw0ek2cJLjZXqPOm8ZhRmkxOO43GDBmNIk1zACZik/SdWm58r0V9AJmVcz+vXl7YWvLywPZnR6TfKJE8kpk5X3HSjfhEwM5/7xdBhRpVQclrnPywUC4urYCu4V2MNc/cOqNmqLR9YqUrjakc98TNZeC1Z47i1lireth6hHcYPK5lh+c5tS/ZNDLxMdZDOsRoWh9hqwjzsUOLmEgistUcBwjT/iaPcsO7mM1ZmXNfQJdG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 17:55, Danilo Krummrich wrote:
> On Fri Sep 26, 2025 at 5:33 PM CEST, Danilo Krummrich wrote:
>> The only thing we need on the Rust side is that existing allocations remain
>> valid even if the cache is destroyed. Or the other way around the cache is
>> silently kept alive internally.
> 
> Or to express it in C code:
> 
> 	struct kmem_cache *cache = kmem_cache_create();
> 	struct Foo *foo = kmem_cache_alloc();
> 
> 	// After this call cache will never be accessed; leaves a zombie cache,
> 	// since foo is still alive.
> 	kmem_cache_destroy(cache);

This will cause a WARN.

> 	// This must still be valid.
> 	foo->bar = 42;

Yes this will be safe.

> 	// Frees foo and causes the "zombie" cache to actually be destroyed.
> 	kmem_cache_free(foo);

The free will be fine. But not cause the cache destruction, as that would
require checks on each free. But should be fine wrt safety if we only leak
some memory due to a wrong usage, no?

