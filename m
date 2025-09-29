Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2FFCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C2A8E0014; Mon, 29 Sep 2025 03:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5F38E0002; Mon, 29 Sep 2025 03:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D908E0014; Mon, 29 Sep 2025 03:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72AB28E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:14:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 099891602A3
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:14:17 +0000 (UTC)
X-FDA: 83941424154.11.6C557DF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91536140005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:14:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvsOAoWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B2rxinS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvsOAoWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B2rxinS;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759130055; a=rsa-sha256;
	cv=none;
	b=n5Hk+i5D1ixshWiJeqzl0+HYKI5yP7MHqkIRUyXWOYd/rnEZ6Mkxz8eD7puHjL6Dgg21s6
	CVxthL4j11HouXSPjIbpz5xHygcn0dbngVzzARxR+QViAs3g8TQZOblH1JZ+kVv9bdwn5T
	vniQU/wzoHB8nS8ibpgoKPvF95RnxGk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvsOAoWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B2rxinS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvsOAoWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B2rxinS;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759130055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9AaWbGFpDWZOYuqnMD+7E3e81CpVcwRgDIw1Tv8xGA=;
	b=ZJAhUfCzK6DVo/3JZeOOCYXCsVyYBRlrjFzHxrOp4shEMnC/T9GLzWG175GNKeYJd26YpA
	kAL5pXlS5Ljw15GRQLr0Bc7/xTV+RSExCWw2X7Dor/rDzVsxbdK97fN6YTzydJv2iFXEW3
	PLv1BUOrj2wMearwVFzyYG2oR/hCm6s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5703430724;
	Mon, 29 Sep 2025 07:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759130051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9AaWbGFpDWZOYuqnMD+7E3e81CpVcwRgDIw1Tv8xGA=;
	b=qvsOAoWuHXrgPiL1hl4YuWa0RQ2Goaa/WbIFQSpa+PIJoYmJ4aOmK+aMBlXU46o8YDL45M
	OyowUg5+U0yK6sV1BbT2PT9csKVa4jiu6GuIcgqwTSHYju/nvlGGjZsIVvlXCsOEGYkTKq
	7srPzGVjV++WEYMA9cRAAvAVRexLgAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759130051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9AaWbGFpDWZOYuqnMD+7E3e81CpVcwRgDIw1Tv8xGA=;
	b=5B2rxinSiVE1mrpqSY34o7rYAstH4wwgQkmBv+ZCpaXndS0At+AZEQLClO0TiwGklysWX2
	VF4121wvhXczWTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759130051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9AaWbGFpDWZOYuqnMD+7E3e81CpVcwRgDIw1Tv8xGA=;
	b=qvsOAoWuHXrgPiL1hl4YuWa0RQ2Goaa/WbIFQSpa+PIJoYmJ4aOmK+aMBlXU46o8YDL45M
	OyowUg5+U0yK6sV1BbT2PT9csKVa4jiu6GuIcgqwTSHYju/nvlGGjZsIVvlXCsOEGYkTKq
	7srPzGVjV++WEYMA9cRAAvAVRexLgAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759130051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9AaWbGFpDWZOYuqnMD+7E3e81CpVcwRgDIw1Tv8xGA=;
	b=5B2rxinSiVE1mrpqSY34o7rYAstH4wwgQkmBv+ZCpaXndS0At+AZEQLClO0TiwGklysWX2
	VF4121wvhXczWTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3554C13782;
	Mon, 29 Sep 2025 07:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oteeDMMx2migFwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Sep 2025 07:14:11 +0000
Message-ID: <a6de773c-77f4-4f2b-b8fa-464493ca7c75@suse.cz>
Date: Mon, 29 Sep 2025 09:14:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: slab: add basic slab module
Content-Language: en-US
To: Danilo Krummrich <dakr@kernel.org>, Elijah Wright <git@elijahs.space>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <DD4IKU7O94WN.2VALE9M80XGQ7@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DD4IKU7O94WN.2VALE9M80XGQ7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91536140005
X-Stat-Signature: d67ux1eyjm5yj7ehsna9omk5r1ppnhsb
X-Rspam-User: 
X-HE-Tag: 1759130054-392926
X-HE-Meta: U2FsdGVkX1/HT3eg4/NL+hf4zUEwYWuHI2rq6nHKwTmZna5fdfVzBdt+DUSGVwj87Ztmo4ktwojzZK18xSpdwATzFFimta6o9imrN1IUrL3qchKmrdpOyrehtjCynQIRVgeCAFUEoh2zun4ztV3EknWNw4aSBoi6ra6Hl85i/UM3b3EQEXmBt6LkZT6mJ9g9klAPoiu/xPYeeFU8lNxXCFmwYx8MA7W3BckcPav8TfHFYU5TldFsQKbcihAl/i6qkJ8sYktZsma4pNT5tZ7i2uwtqOg2DsWXQTq0rNj9VjcVb8OZgjnxoO9vz6f9rCoMob8leM8OEs0u5sWI2CS5ZdR6JFHxxrtWvTQmNWAWZnzjNpsEgA0sQWgaqQzTvfxXR/vYVy23YfmQsFz4OBtlzp38INgP6iKXsmFDWrsy1u19yMtfkLpbzFJAiFIBAVIaYYEqBHdDAUtrE5BSy7mqC288D26irCl5UyMZKpmQ8PGmw6VIehkHntwVGOa9tiSaoIY+zMf1h68zLS+z1YbtrNrWxaCgdmEz7uh4lezFb5D+M5AWWa5SXvozoL4SPbdK4VZO61t/uxFaI/Uqah0UX+/f+yxxBdJcZDonw7V8PjgiVJCGcWva8Blbi7ctqWb8jirFEJSN+UPhqKU05QhwkVaR70hG0YCR/aHQbfev9IwBBmNO8lxvS25emYLz6fV+G3vrmWHyqHjVojnhW1LsFaEH4j/Vvtqrl71hXjmvIzhIsnUEcMmHNcM/puniDbNXM6Y5eqNhOtejDuWRD5FqKyy9mIk2heYz48gloCl4NqNJRjPUWPqRjKzWxwICO9rbCL8vI0lPx7k6u9VyCik58WtKUNUhPdIm/anJROUaw9yKAb+zyNAYU3Wrj673BuiwnmigzBLN+n4Gm/BYvXfAG/B4lxV95WNWTcoGdMvfhW253mLZkAI7bU+kolX2+pTOxmqC5Jk9laKOm8EASCA
 F1821Se6
 OjmWMKrWRULbykCuW239KNURBQFfUWyD5/chxEjfqGr8K8bccsoMUFQYRPITC2e2P5XChDdimnO+9GsRlmySntHPZE4OGav4RFffEzYmuYzEkTAuofvWN9Z12GlgR/cbZx7cRDgCcHHTJMnki45jsTkKRrAkRX0AP/AyYGlMshnDcUl969TU13Vg5/ZboLDZi4RlSa61MB8vjkXQTKXOz5PXPBp3s5B+l+87vV9CL3IoAjcsjgziBPYhZSJwBEE/6+8mJ42WJQFJudZimUTO2ntSbViXSgxP3LaENkVNmBNaJzNJ0iBG4S5bvAw++wlQnjNc+8p8z+hkPuxgvThrSh4aZZCq861Ts+0G/kquxk52q1vM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/25 16:47, Danilo Krummrich wrote:
> On Thu Sep 25, 2025 at 11:54 AM CEST, Danilo Krummrich wrote:
>>   (3) Implement a macro to generate a custom KmemCache Allocator trait
>>       implementation for every KmemCache instance with a static lifetime.
> 
> Thinking about it a bit more, I think we should go with option (3) for now.
> 
> With its only limitation being that it always binds the lifetime of a kmemcache
> to the module lifetime, it still seems to be the best option, considering that
> the alternatives require additional synchronization in hot paths, may *silently*
> leak the kmemcache, cause significant code duplication or break dynamic
> dispatch.
> 
> Tieing the kmemcache to the module lifetime should cover the vast majority of
> use-cases; should we ever really need something else we can still revisit the
> options.

Sounds good.

> Thanks,
> Danilo


