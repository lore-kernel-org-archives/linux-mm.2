Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2278E606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SptBZ+49
Received: by kanga.kvack.org (Postfix)
	id 1E0046B00EF; Tue, 17 Nov 2026 10:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191386B05B0; Tue, 17 Nov 2026 10:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7746B05B1; Tue, 17 Nov 2026 10:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE6A6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:28:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 696E414045E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:28:33 +0000 (UTC)
X-FDA: 85444992906.09.763D881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9416C0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:28:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SptBZ+49;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eabcSSyR8dinR+klZl3/g1Fw10Duq9Lg/6T5SwUMuWY=;
	b=Kt05lOpgyiJLlLhFbGgRaCYyW4hFfTolLVoh57Egjbx/BlZoGA6qkBv8wVS+CoVF+TyX1/
	Dh3wxLrFx6f/iRVLiDaESgb0kIf1FDQHaZrIGPGOhV0AaRoPIAOby7mciOUZWveFuZbz3d
	FpBr7c7uC83dYoECaG9Fkwc6SijirLY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SptBZ+49;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929312;
	b=gZKyeg7USG30ALzlonXdJ9HGb6ziJrN8ZB35OoUicAAXU95SbIkHN9ksuTVNToUESVZ5pB
	HEhA0+IThXCCXkBmWSYRGehqGepNqT3LzUBKv+gOOUSMYnzffHlo592ip7pOzeG/fzci/8
	jlDuz3ZuVqfsUBIBZzP8n+KF4dspCFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A919F404CF;
	Tue, 17 Nov 2026 15:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44711F000C4;
	Tue, 17 Nov 2026 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794929310;
	bh=eabcSSyR8dinR+klZl3/g1Fw10Duq9Lg/6T5SwUMuWY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=SptBZ+49ZOIkxFB04dM1CXWSnEFLFmyyRgTzudB0TYtbzjO6UjAk1s/fFk1zbwel+
	 OC5NmWdNbTUVbBGwLAiA5GBxSwadyrnVZ43vzoIeUK/HM1zRS+C9n40vSwEcL3RJnA
	 qRNMQvUCkt05yw5Ta6Tn8gusgAPRy8TDhbEPdmWMWUqxYByTM6dLKi0LWS6doxMDlb
	 tH5Wr+iYFybXMvmsChF+zvDtui/7y/ZZzv7+VFj8oqKZQwen7LdUDaUtkUDGZG9zY5
	 yJBV/PaeEOfBPYg5aaDU/vTD1tSMUhEi/H9Xvhk/ZutbqDLWIdIEiIRRYSsUrLiXNs
	 l5qQuBZ8z6F4g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Tamir Duberstein
 <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,
 Matthew Wilcox <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Harry Yoo <harry@kernel.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 09/12] rust: mm: sheaf: allow use of C initialized
 static caches
In-Reply-To: <0082d06b-381d-4001-9ea6-cd3217e437dd@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
 <20260902-xarray-entry-send-v5-9-d18adae40708@kernel.org>
 <0082d06b-381d-4001-9ea6-cd3217e437dd@kernel.org>
Date: Tue, 17 Nov 2026 16:28:15 +0100
Message-ID: <87fqwzv5o0.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C9416C0007
X-Rspam-User: 
X-Stat-Signature: eqndz8r6hwyot85ytsd3w83c3tpbw9u8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794929311-658541
X-HE-Meta: U2FsdGVkX1/+TYBOKQrp35EALkkYn1zEDmIPkVzTzj4a2ai4E2ETaSv/zT6qkZBQ/MVzKQQRNueDWPuqALEQEOeSo2Gmz+0/so6LLCEoxoOxmwiNHNk2EBGPcUpjW/JsXsgRARzm1s60bMxCvBhgAe+H5ebRmoBrpdVzxCWF4H55qEvLhh1/FlXNJkiv7IsEC2y7uisHIwWFU6d8mvtFK95li5dCbb8sZwOY3t42cNdXpJhQMWWpxcY2WmklJMsU/Q8Wuk7GP3qNaHHBZ8km5FcU8PIG/AzlT3r9j3TYnucOgMcJIy9oIXr5HRncl1Gmh/qYhkvC1sgQBHHhHqjgQdnSvg+o/ye+20Q4YHsgFQGOKU2ncxMgJt+3r7ky+0V/dVYJQrSu7ADoajxwCK+SP1n6bqM8/RnHIDpwRz+W5VD2//gxtct/aZnDP8kefIiyWNIbk6d3l66Ci1sKEj7wZiYIlDsttFcRE8ZEmwKbIxub28+EQutOT8OzI9S7yuOBjNm890YwgReU46zuj/Bhp4V3lBm2lrhZxtgvnIsaUg3nCMPs2yDqCHMo8l1XhHCopGQVATbaBCmYHOuY0kKZ5t5YrjcvP1bDhcNelG1JAcqp7VQ+qCxoSjCi/go15CyPy0baeYfqJuqPWs5clLHRmFLaCYje4XF0l44Qv1ly3SbYlKVOBFYBFFyPI7U89huC9rp6D5+7T6OzaBSohVXdmkcHBDcrie83M6FDq8bOKfQuwBVCC6paIfVFcMveVXc1KsAygFwd91YSTofIm3mpVcyoaX6C/8Co8s+NfpDl3mkA5GA4kUwoCP4xKtlUYQfNe/rkR8LUV8qtslcUqpbGEjByMRW5ZJsdRGGpaRIzqcmxtuj/pN7FG/huiPyQnDOgDPOUXy2drftWhfLXwuIbyuOJEVEKD/n5ZfSxwtYncOHdlkYnchO9QTfOpcdVOxga8EnNfMB/rjwETza6Qpi
 gn/eEM7x
 wsKl+5N9/hcAzdVjVYjh7lACCHEizUg75NV3NrlFGh/p3snQVDh0NsjBE4XtvvNX108avy/3ptav52UexELZFW9FenNnlsKVhnwtffBat/al9HuduLhzKs/rMtr7RYH/+VWhTnx4vkk9bhaSNVR4BiM/+5bCVfkUbJTLva5oOSknhzgJ1puj3jJBjg3L+Hrb+GbI3A6Gsa1cHSfMZHU/nxEzT3k+TPsg5vLXnzjoi0KQiCqr2k4OQkQVdQlj19ad+K5j2uY6QRQ4RgBT7U7MAmYUv19n+Kbx4jKRoO5Cd9WgdgnAIeNksXiUPM7+rQI7J4VKQUSE8wPvx1PxiX/tbl6LieBiHyY1/Cg1dlDdoHsgfCIfCxzRhJq8T3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:

> On 9/2/26 15:26, Andreas Hindborg wrote:
>> Extend the sheaf abstraction to support caches initialized by C at kernel
>> boot time, in addition to dynamically created Rust caches.
>
> Nit: in C code caches can be also dynamically created :)

Right. But the Rust abstractions do not support interacting with those. Only
dynamic caches created through the Rust API or static ones created in C
are supported.

>
>> Introduce `KMemCache<T>` as a transparent wrapper around `kmem_cache` for
>> static caches with `'static` lifetime. Rename the previous `KMemCache<T>`
>> to `KMemCacheHandle<T>` to represent dynamically created, reference-counted
>> caches.
>> 
>> Add `Static` and `Dynamic` marker types along with `StaticSheaf` and
>> `DynamicSheaf` type aliases to distinguish sheaves from each cache type.
>> The `Sheaf` type now carries lifetime and allocation mode type parameters.
>> 
>> Add `SBox::into_ptr()` and `SBox::static_from_ptr()` methods for passing
>> allocations through C code via raw pointers.
>> 
>> Add `KMemCache::from_raw()` for wrapping C-initialized static caches and
>> `Sheaf::refill()` for replenishing a sheaf to a minimum size.
>> 
>> Export `kmem_cache_prefill_sheaf`, `kmem_cache_return_sheaf`,
>> `kmem_cache_refill_sheaf`, and `kmem_cache_alloc_from_sheaf_noprof` to
>> allow Rust module code to use the sheaf API.
>> 
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: linux-mm@kvack.org
>> Assisted-by: LLM
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

Best regards,
Andreas Hindborg



