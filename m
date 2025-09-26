Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BACCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB828E0005; Fri, 26 Sep 2025 13:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90EE8E0001; Fri, 26 Sep 2025 13:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7FE88E0005; Fri, 26 Sep 2025 13:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 903618E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:12:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B03AC03DB
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:12:06 +0000 (UTC)
X-FDA: 83932044252.26.35DA01F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC05A1A000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:12:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nRwpXO+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LR7sDKlf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nRwpXO+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LR7sDKlf;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758906724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKHikqJ1cn2yMHDVFPGBQhz/2NMrhqlW0Rdo3rkQdqw=;
	b=SLfj+EUNOGs/VSR9ghwDD/6FgDHdSj/5RY0ZLwG4O3ZGC/ixp1pF9lfst0KEP/r64X+fn3
	Id2j0W51eNlsZGkq8U8lM5Eq1nLIs363ZWO0jlyeJcu00BE/sxm90hkMXaSHsWFfbAdYTG
	43WJ7wmKbimKa5vDKTEbimBDU9dpUrI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758906724; a=rsa-sha256;
	cv=none;
	b=Cd9rN+rUu4RCrRFGHLRV6xFjH5mB5qLiih/SwbxczGA9bWAk2dRyibLNmB0jqdHTTGz26m
	33+mRsPnoFU9dnv4M2l4U6AOqTpoy7vuQnuS0jhTLC+hpe6cHnJQ1PXOT907gpTBv0QTqG
	GQMPs8P0NnHNRVWwleTF6/nEeJGkiiM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nRwpXO+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LR7sDKlf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nRwpXO+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LR7sDKlf;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5131B243F7;
	Fri, 26 Sep 2025 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758906720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IKHikqJ1cn2yMHDVFPGBQhz/2NMrhqlW0Rdo3rkQdqw=;
	b=nRwpXO+EozLOwUrBDa+iKRMbOE56Uo1YAqA4ShhGZ9N6+0/Mnppklo/HXx51bKxIm9K4Z+
	pSpXULhlqcJQp9MSBdivQAYCZHSCrYYSNDuJIOUXLzkr+mZxia/xpLzt4Ej+P7OQGAiPDN
	WE4OcYvjh9etGPI9l9FNwU8NWVIgOKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758906720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IKHikqJ1cn2yMHDVFPGBQhz/2NMrhqlW0Rdo3rkQdqw=;
	b=LR7sDKlfHO9YZuEM9w1sG8Fqn766R0+/Auz4r5Kgb3Azgngf+U1RS41J2xBYM7fsomZGWF
	ofYq0PV/OoT8nECg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758906720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IKHikqJ1cn2yMHDVFPGBQhz/2NMrhqlW0Rdo3rkQdqw=;
	b=nRwpXO+EozLOwUrBDa+iKRMbOE56Uo1YAqA4ShhGZ9N6+0/Mnppklo/HXx51bKxIm9K4Z+
	pSpXULhlqcJQp9MSBdivQAYCZHSCrYYSNDuJIOUXLzkr+mZxia/xpLzt4Ej+P7OQGAiPDN
	WE4OcYvjh9etGPI9l9FNwU8NWVIgOKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758906720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IKHikqJ1cn2yMHDVFPGBQhz/2NMrhqlW0Rdo3rkQdqw=;
	b=LR7sDKlfHO9YZuEM9w1sG8Fqn766R0+/Auz4r5Kgb3Azgngf+U1RS41J2xBYM7fsomZGWF
	ofYq0PV/OoT8nECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 324BE1373E;
	Fri, 26 Sep 2025 17:12:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NJS6C2DJ1mjSIAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 17:12:00 +0000
Message-ID: <57b01f59-f4b1-4f5f-bb63-fd8eea19b7ba@suse.cz>
Date: Fri, 26 Sep 2025 19:11:59 +0200
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
 <1f5ae3bd-db21-4042-b177-55464644ce2e@suse.cz>
 <DD2W3LCC7FWA.2X90YAPLI1FGC@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DD2W3LCC7FWA.2X90YAPLI1FGC@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 4kyfrj8woic3176kufatft787oy6sc6i
X-Rspamd-Queue-Id: AC05A1A000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758906723-454015
X-HE-Meta: U2FsdGVkX18uwBTHBDdu9oDwc/kNCwRPp4KdhpQn6NqE0vj7jzK3R3sWT4fJuICEnCAYV2zYSJG1a3rIWjpktwJP2wZDVvxwJFHGcuFEWxgia3GIxCtGU9mtybkZGBryMvQADIgV/LByYWy6+pbOTk0hagKc1qet2oWxo39Ww6Yk5Fq2m+3zLifkeGLKwvKIz3aPw+fvZA/f1Ro2A9xkobM6Gp+t2WLU57BGLe0JnKcGpWJADRtSc4laVr2ttQmm4ptN2xp1vkMr6ACycK1rwYR1qeXo/HkeUJdtEwgX5CSyJaoYrCbEcbs+fUmAjB4csxRj4mUl/T00T9Uv/qGx8RpUbaBEGXRG2xmF/1yYFT1xadp90lymYRbsnTq2CI13Ts4BIfaI8EZUDo3glicWiVg5MuDZ4ctN5+d9tbeYG0qyt+umiTeOma17loZPEQAArMWSGkceRejOAXZ7GAylFBB6JQv619KGWedseX1S6MtEB/d26z62s/uc/S4XgR8MccKMC/CGIbQVqgYdAr9J+b58zXR7ipUEUVZxgvSKj8uwWk7bCYb+By06hkuIx8sqXUkQvHkk1i2g3VFWAA/dfJ2oAq0cpZYkNL8be9HJHV0Yqkn/kmAP0TxoPKHPFsAJWDTOQm7Z+5bWieN8GYwtIfFR+qc6U3krQlNPokUg+Uo92Jvgy1AaHSJdP2oFYDVzROhoFPVBaqO+K+nhWox/RAJJJ6OkavMl6V0pWueHuP4Ch2rRsbwOXBX24Z0xcipBM4Y6maSHr4OJq3oPJMk9ZLuRkR3SXCq59xIXlMea+egTIWCpi6X9ACK6AthPxY78M+7Fk0Di2u9DFS5TZOnbl2DqBkG+rij690FOTMQV9eq5XqomokU0gjlgfc737a9lVhWF3iQsZbXO46OU1Ln0mIZnX/AKi90Dh2DetyLXavZTWnUkoLPI2TCnO8mqi3IgxeQk1XziFEwWF4T9Bfn
 KQH7qWZX
 tljn6+5fvhgveGXDYoXmhwNyyn0ra6nlzI46U/IXZAs4s+zRLTt5lWoIbzz0YexuMwBfOG/5pHKQ5dJkBSYM75fcbDQ+wKJLJ+uuKA92vIJwaKFyHaEDd0dQphMPI3neDhw6ijbKTbt5+HI2u/Tm4eJLQRnLExD7aC7mO7Zck3mG7QIllYu0Z2An04HlBX4jcCc7TRgKambMH6kwpaZhB9kQgwGzTNCoYyVSzKMZZMJoSdGwoDcQRZHZv4iVaqDAMK1WkQ8rgDsabve50oRHw1R79Shdq+I1tvCNgTz0OTqG0BEnFRP8M2++9873dUc2eTR1bDg9+KNv8cAPCKGD7yZdvjdhbckQGyz8RZ6jk0N8ljv4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 18:58, Danilo Krummrich wrote:
> On Fri Sep 26, 2025 at 6:32 PM CEST, Vlastimil Babka wrote:
>> On 9/26/25 17:55, Danilo Krummrich wrote:
> 
>>> 	// Frees foo and causes the "zombie" cache to actually be destroyed.
>>> 	kmem_cache_free(foo);
>>
>> The free will be fine. But not cause the cache destruction, as that would
>> require checks on each free. But should be fine wrt safety if we only leak
>> some memory due to a wrong usage, no?
> 
> Yes, technically that's safe, but we wouldn't prevent the leak, which still
> is not desirable (and not our ambition for a Rust API).
> 
> From a C standpoint, both the warning and the cache leak could be solved by
> making kmem_cache_destroy() fallible as you mentioned previously.
> 
> On the Rust side the cache would be represented with a struct KmemCache<T>
> (where T is the type that should be allocated by the cache).
> 
> kmem_cache_destroy() would be called from KmemCache<T>::drop(), which is not
> fallible. But even if it were, we can't enforce that users keep the KmemCache
> instance alive as long as there are allocations.
> 
> So, either we always keep the KmemCache<T> alive for the whole module lifetime
> (which depending on whether its built-in or not could be considered a memory
> leak as well). Or we ensure that the last kmem_cache_free() also frees the cache
> if kmem_cache_destroy() was called previously.

The rust wrapper side could do that so we don't have to add that check in
all kmem_cache_free() calls, maybe?
Also either way it could perhaps be difficult/expensive (memory barriers
etc) to properly handle a racing kmem_cache_free() and kmem_cache_destroy()
in a way that ensures the cache is always being destroyed, and not have the
kmem_cache_destroy() observe the destroy was premature, while the racing
kmem_cache_free() doesn't yet observe that destroy was attempted, and not
try to remove it.
> OOC, does the cache pointer remain valid if kmem_cache_destroy() is called while
> allocations still exist? I.e. is this, except for the WARN(), valid code?
> 
> 	kmem_cache_destroy(cache);
> 	kmem_cache_free(foo);
> 	kmem_cache_destroy(cache);
Currently not, but making it valid hopefully should not be difficult,
without affecting fast path.

> At a quick glance it appears to me that things would go south in
> kmem_cache_release(). Anyways, I don't think it would help, if it would be the
> case.

It would help if it was safe and the rust wrapper side did this retry?

