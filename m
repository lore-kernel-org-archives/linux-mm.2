Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638E4CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBA26B0088; Mon, 11 May 2026 22:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC106B008A; Mon, 11 May 2026 22:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AA66B008C; Mon, 11 May 2026 22:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 543DB6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:31:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEE661C021B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:31:43 +0000 (UTC)
X-FDA: 84757192086.16.482C1B9
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C7A7140008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:31:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GyUGK0YJ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778553102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrtZb448NrHIsfPspS1Njut8kvZNG6sBP0VsaE/hSZE=;
	b=JtfdEgeu+yeW5QKWo0fnFXPAeIrB1GoR2OnNIw5dAOwE85SfECvF+Giqe2/t4d2Jd+0apd
	sWK6ThuZg40X1ufyn3odAbTzXD96DAH5cN6cuhHGxHvLgw8VOJkBQegjzfrhc4gjm8v8gS
	bTnDGAGYu/vSGfi0HPuRdoXAXvRlwBA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GyUGK0YJ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778553102; a=rsa-sha256;
	cv=none;
	b=isHf+W1+KyD0uTPH/bhXbDySz1EjfAsCch+r0VzeezeckMRCt953DAnamSv6r/sgELsej0
	ZiWVu2+K8iaXVhCEjscW80XKhfWOGJQTAz0eCUyztIgsTX3EgNlXoorBgx2b+PRad3X+xQ
	iNPRmxt8AeeLsu0rB/mcUjAxRB0ZU4Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778553098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrtZb448NrHIsfPspS1Njut8kvZNG6sBP0VsaE/hSZE=;
	b=GyUGK0YJHbec8/rg/NvHo0Q02EmZGAa7e94VCOrmhBd3dcKkUiij82TaEsuXGxxKpKFMRA
	d/xdNjCaCZp140PimKqafnzuoApiErZ1aok+Bv9U569JWmTHGfzzRpf0kocVXbdOS0g+Ee
	OBCOnaIbMvPdmGPjRu7MW0VTQ0cg73Y=
From: Lance Yang <lance.yang@linux.dev>
To: jannh@google.com
Cc: rppt@kernel.org,
	akpm@linux-foundation.org,
	arnd@arndb.de,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	ardb@kernel.org,
	sethjenkins@google.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm: make zeropage read-only
Date: Tue, 12 May 2026 10:31:29 +0800
Message-Id: <20260512023129.44966-1-lance.yang@linux.dev>
In-Reply-To: <CAG48ez2ed44M=-qsZO7gwcz5L2njdRdk54d47jEg48MhWTkaew@mail.gmail.com>
References: <CAG48ez2ed44M=-qsZO7gwcz5L2njdRdk54d47jEg48MhWTkaew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C7A7140008
X-Rspam-User: 
X-Stat-Signature: 8xji8ity5u4ify8atuyo491767c8k3y5
X-HE-Tag: 1778553101-194854
X-HE-Meta: U2FsdGVkX1/ofJ6Iy6nZBYty8fP81/2JCBSP2vAvdZKb7CDT9q2p7VEt0g7L2eC8/jZjEc54eFIFlmrLKLk9Uosqk2QddYBzKSgpN02j55WQ56uwk7RCH1imL3Xm9Pf1o9io9723JPpeckzYfF0pHt7E0j9ysNUlYRBcWVAAycF13jNFDvYokRQPmStBZFDy9ZTApZVuI4T7J0Q8ef2fn/0JK1WkgwZD0v5CH/Sr0pJYfqR+LyHVDqrCg/bI4+ZV8HWZV4ugY/8EwBEAZg45uThqHfXr1paZ3K3j0iSlnvIvNkqURnu6ilH3cb6FvXr0L2bxqSt9ROGQjXtFq+4/zd2HJ/jd4RZcyPrJYoga5MIPw5zwVT1a2vM+lvpBkHlZEJ4d2vgAuj/SFL/cHBt67Fg473P3CBJ6W/UaPkDndw7o3sBL2kjXzlABGeOudNbrjEEUnnqaM+A0eOaUlvzp/lXJR/g/6DExfAnFz6a63LrxZmQGUdtOw87ziUZNufVl+oZyMpwAP9rmCnH5ZcTNtpxa5lAJKgECDcGfGPEp8Wyb6Xq+bIRF49h1bjpBJZfVQev8o2VyiIGtmGu1Dl70tizvwpc0BTF8+doMCqzy3yM0pYbsAW9Y76zHwUNk4oU4dknuLl12LUXybmhiYS7qvizC4cjOgf+Ju7fDZhNpc00rF23WxiwtKJIobNKuXSu7SBMc1xCn+0GoCKevGBfDIrffgQ534ni3Ebflk+tuJG/TiW2h2MHOSziP104EngtAxY1xrFhSSuzp4zWZ5d4QNT9gdW7KL0sJmMFEV1EQyDeJkDjyaonZFaegHlS9F3b3E/BMw1SzlAUQ1LSvjjouFraTIhHoYEc2eb7KfIK+WMMd+O/qVqC9qXqop5VG0Kca4nO9zk3wt9jI/VMBt7x0b4lIeAK1oEi6wrTka1QrMIfmelr663YqQhq5jg8IwiWvl4sSviX1VbVh4Q3pMDe
 szrUGFv9
 /gEnBw1/DkJ5vfhKZdGfhAdSOSaeD193dqdok/FleVIbAhpzyslFmA14UdZkOHHJJDn+hyAh/K5veIFS4vj6INXZekKWjJOmIaRJOSfT7i7EdX3oR+o+clTC1T410QRru5zZEYp5tE1Fsn8VQzDVe2pQVtoXrOAAxDMKBtoBHM4v7paxUU9PaJWJ0MTE/Fl6wv2R+K1pU0cLwg24S//cHTUdNDLgI1eBzB37pq2h9UDQmI6m/AFBzW1jKtMi5lajzQAP4WAuhgdc/91IZPZPDXJHs2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 08, 2026 at 06:26:32PM +0200, Jann Horn wrote:
>On Fri, May 8, 2026 at 6:12 PM Jann Horn <jannh@google.com> wrote:
>> Put the zeropage in the read-only data section - nothing should ever change
>> its contents. Set up a new section .rodata..page_aligned to mirror the
>> existing .data..page_aligned and .bss..page_aligned sections.
>>
>> There have been several security bugs where the kernel grabs references to
>> pages from some userspace-specified source, via GUP or splice, with
>> read-only semantics; and then later on, the kernel loses track of the
>> pages' read-only semantics and writes into them.
>>
>> I have seen such bugs in out-of-tree GPU drivers before, and recently
>> upstream Linux bugs of this shape have been discovered as well.
>>
>> One problem with these bugs is that fuzzers and such will have a hard time
>> noticing them, because the kernel has no mechanism to directly detect that
>> such a bug has occurred. It would be nice if we had debug infrastructure to
>> keep track of whether file pages are supposed to be writable, or such; but
>> for now, the easiest way to make these bugs detectable in at least some
>> cases is to make sure that writing the 4K zeropage is mapped as read-only
>> in the kernel, so that attempting to write into it immediately crashes
>> (unless the write happens through a vmap mapping or such).
>>
>> This patch might increase the size of vmlinux by 4K since .rodata is stored
>> in the ELF file while .bss is not; but the compressed kernel image size
>> shouldn't change much, since it's compressed.
>>
>> I have tested that with this patch applied, calling
>> `get_user_pages_fast(address, 1, 0, &page)` on a freshly-created anonymous
>> VMA and writing into the page with
>> `*(volatile char *)page_address(page) = 0` will cause an oops.
>>
>> Signed-off-by: Jann Horn <jannh@google.com>
>> ---
>>  include/asm-generic/vmlinux.lds.h | 1 +
>>  include/linux/linkage.h           | 1 +
>>  mm/mm_init.c                      | 2 +-
>>  3 files changed, 3 insertions(+), 1 deletion(-)
>
>Seth pointed out that this is more or less a duplicate of Ard's
><https://lore.kernel.org/all/20260427153416.2103979-19-ardb+git@google.com/>.
>
>So this patch is redundant; sorry for the noise.

Would it makes sense to apply a similar treatment to huge_zero_folio
as well?

with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y, it is allocated at boot and
never freed, so it should never be written after initialization either :)

Cheers, Lance

