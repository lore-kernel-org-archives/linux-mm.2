Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77ABDC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465C26B0099; Tue,  8 Sep 2026 06:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEFC6B009B; Tue,  8 Sep 2026 06:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7F26B009D; Tue,  8 Sep 2026 06:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E98F26B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:39:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5512C04E7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:39:38 +0000 (UTC)
X-FDA: 85190248836.23.9ACDA7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB01040002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:39:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z85uGoCq;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788863977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjJUbcma5aHPiCDKq7gAqglFN4GHXWVPea1PTRoIqQA=;
	b=mbSRwZcXGCrfKKxEFCTOS7nzH1M/iOdHz31RRc4MZMfh9r5G8u4TmJokiUGCk0mVnNI/E7
	1FkThk690rRr3HFQ0YwigjP0SiT5mL+gle5slcMsu1p5PFEm2FksodG9TI90gAmnGZXZun
	HyrdDe5YxqfjgwKfPY40HnQLJHHBd/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788863977;
	b=4GL2TRqcyCdYMy72Xqk2hDSuGxZhxQ0lwZohagCiZB05fUBtgFC6qSg556kr+DbrPd3xnG
	HnidR3fpDKfF6j1nvYVCZRl/1vTkJuxSHXOtlvcUkQW/C+KiDwltYl9EJ4ChcWSD1Ag5KY
	2ugBPkMpj8W8T+0i0+QS1fIvgMcNr8k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z85uGoCq;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 228E242B97;
	Tue,  8 Sep 2026 10:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6E71F00A3A;
	Tue,  8 Sep 2026 10:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863976;
	bh=YjJUbcma5aHPiCDKq7gAqglFN4GHXWVPea1PTRoIqQA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z85uGoCqW2p5OrfqlMbTAXWNhCWyeFTtc6hPJunew+AqwO8w3KB84dcM7HtTXc+Dp
	 kIrVqA2uHjib4MQly5gG2sAWV4JPCDgZISbnhtgKcwHR0xCz3uoLmbPWy83eL6Z/Cn
	 7Lv/ROM/uizyH06RQra7gnEsreWgzAfIm1COqq1/Jt9LqHb15MQ60SKteLfcaZSGfI
	 3GWTl8KLB7IIHzthOvHejwNUNWLKZhaPmnBi5AvPtpnqb+e2YL/n96OxzCrewy3Byx
	 lQOgGTIiQ5sPobSvuqfU6Zg9lgBvOxQl/s7HfzGNxSg2KmHXL0TCEKI4aeLa4S2kBG
	 Aax0efOl35LZw==
Message-ID: <610ebd79-3ad4-432c-ac92-b8956d7150d1@kernel.org>
Date: Tue, 8 Sep 2026 12:39:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB01040002
X-Stat-Signature: 34bs4iyokqruphp3wpqoimnd8c3qf4sx
X-HE-Tag: 1788863976-707613
X-HE-Meta: U2FsdGVkX19TR0lx+btEy+Cmjg1FuyqHNAzjsrog68gelOt4qu2UJsEsWUCkmSlIa8g3zexZEIcdZOvKmvTCCHeFkHDoMPxRG68RV91YikrtuB+E2fL6NEZi2+/LoWyc3SUuJM4a8vXZbs8Wc0Qy38NGdvJBK/3N5Tpw72c5yGNlvC/mydwDVwa8j+WcsVHsAxeEcyR1+FeOlhLPQ9RnmlLVDjIbGQfxnq7YT0LM53dUGTUy8R31+76DYJZWQfYrOEgFLJsAw4z+f2ifEszgiyQrnZhgI1qOw4mU3Ivm3kFD53m5/1mh7j+wL7HTomJG1PAWi6BQkC/yP72/NzKrWV0Hf6eesEZkyzYU9NHq4JgSYwz/gou5zAgVEX6VFJ2AU8ewiIKpDtv3PhRk0UxvZeyqhHGozDNWlMKztQcWitkYpZjqBoyDUrxyL4SEAZMrzBTPmjtM6aQ/mF9bn3Mu0O2P2OZ2PRH1RKI4pCaAXPWtKuqWgznX9pA8xOVyS/EcT0QOhg3/jqW6b/lFdtkvmYGGNC9Na/SojIlzNsILNHn7IvUfUaNei8jVGDybMQPVaxOnOZz4NXI7hjQJjonPeTDPRcmrIO14iICsczEm0Fwg7Kr9ym85IpxLMfzD5FcfqOUWDCvVn+vX1K1qynFdi3t4jtYR+t/6VdWPUhlTWG41zqGm6hbpIEFXakzbuBH8mEvDEveNBluS4oJ23xaAK1i2ce1BGKhTw1riFiKSkq1N21LUjiCaluGVHTZQRgPP5gYPcqJMLpvZ1Fty3w6jbTSNpMAczhk4yGA00VyrfkSyzfEvbgo7VwnrEE1SUQQwcWoyrXl4gbFL7gy5ZnoB1EOd8bH1IIPqAguxpAzYp+8q9PoZ4yIAjGUOKTAfC0SJqAnmpD67RPwh1fcrUPDZ7h+g9Ueu4Lvh2PebF8gJmQfClV/9WNSiHUVk1vFb6k3+xXKnqc/QMvEj6hOtpkx
 +BUd8QG/
 aehyMlhn5yN0t4RfyvbOj+e32dzPVMySOKUaMeaiewUYsHfUkC5QM6C/C+QiPIvA/xAU1Z6d+Qc6MrIhiXD2bbq6G9u2+om/XR3tcobHVSBtmXvJOszBcZpXjiPMBajH+BBIfUN2zsayczHBtX3/KT9cP2n441KGbDsyyerE7rfyZdDBvaX5hCLeMWYmODTCiKfkQj3hvwKYm98fb0tYKzxPFxNEtYvaoB62ceqXr8mWs7Ad3pjOnhw1Qz/IcGnR0GDI9J9uXg8Z6bEUh5/QRnoKU4q6xsXDqJAMglFW695e5wCbvurhsW+rNSDJi6HPmBv17Zsyl0eAYNGTV+3eTA4Rv53EjAITenqeZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
> get_vm_area_page_order() and vm_area_page_order() do not need to modify
> struct vm_struct passed to them.
> 
> Constify the parameter.
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

