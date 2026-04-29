Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CE0CD13D2
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871466B0092; Wed, 29 Apr 2026 11:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBE26B0093; Wed, 29 Apr 2026 11:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D816B0095; Wed, 29 Apr 2026 11:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8806B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:30:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED4D31B9187
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:30:29 +0000 (UTC)
X-FDA: 84711980178.29.EB99E0F
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id E84FA18000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:30:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N2xbpZiW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRKjPGTHB7gLsglvS58rZ1PmYiUs4SxFlaTZpxLq+pI=;
	b=5MkK7RBohdMnskkS+tGWoO9ufFsUxZuQnKlatsjKrqwIGFVx5aJi3F060dFkHhfKdxcAtH
	qBPt3+pc8k7Lh1bIeBuyigbzhkxkQfn8Hkn+UAFak/QYsi//trSEbMkaVOpzIEuucgWzCx
	opcdymao+GNxGlV6Q+OqlCGBbZsQEV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777476628; a=rsa-sha256;
	cv=none;
	b=OlsWyU7cwxZFfCMp+Smp/gbxHRJcFb4hradauJ2CV11k51vjT1eJ7+PXdbKOymNOCN1DlJ
	fEbo6QkiBUnsBN7x/tZqT8Jn/ea+MdXMRgL8TtZhaMSXsQhmlEDZa7chiy11tcURJKEWtS
	9f/DKFfiY8UfEeacTWN5QNqN+NGzVO4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N2xbpZiW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <2aa36364-6c60-4927-9344-6c4e0a072aac@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777476625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRKjPGTHB7gLsglvS58rZ1PmYiUs4SxFlaTZpxLq+pI=;
	b=N2xbpZiWavmWTwLOQZ9SLU3kOEvqkgRkMHKC2SfGAAdy2KqvPcXuf7tfqARmWRGt7BgSDf
	h03I8++9UxXR5pvDvj1K1I7HyZd7fLtpLApqxFr7VluomyCioKyr7kzB71uz/uydKe/v51
	+0jD4ZvgPMiL0Gq0oVrNCjzSzsGQetE=
Date: Wed, 29 Apr 2026 23:29:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andy Lutomirski <luto@kernel.org>,
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E84FA18000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 91w9sj5mp6b84y9pf44mruymopexnzk7
X-HE-Tag: 1777476627-920607
X-HE-Meta: U2FsdGVkX1/5bsdGP7L/VC8dRwpG3CdWWeci4+gx5KXUt5SA6uP5x8APyvh2g2ZZswWjOGQmhTbv2BME+oWaC7v6qhBCzSEISyZ4qg2eJODfCiD59MyBGAIKc9S5rLjqhU6MK7Pmw5cDfsBb4p3WJXpyy4dqxPncGGRZ0pF8YXC9NpFLJQlw3tcpqP1ND4qC1DBxelNdZ29iu53a5LzjmQv+wnv/fFqhuDspsvUF8GUs9Ni40NR5zDZJp6AgvhDzC2ogqh+L8o9mm/cEpGexZn/YVWFAhGTnF1XPguKG5H0GoPgPMag0b8bpppGFCOWYFlkSNlfg7z6fzLj+DmZ+hBkqWQhe7EOGpUfKpAhDf06+VAqJfgz6gNEIwW3kvkQ/lTu8qqZbiWqVEmtN2XZ/pc23Podp+yiPybrkARna/zGs9r2QTfV50RPu5ST6d6pCGcXfQwA5QgXS/eUFiITEL+rw/NeApWJOxBIZbhsTrspz9v7r5Orru0ZF7YjsITM4ixiiVEVQwrYfk9pJiY+VsUXb3Jhyoi2PSh3E8yQfcrbhnNWeX1+mW6DbWiPGxSwtU8tLsmPMhgXpj7laWTnfVQzprju41mUrbqjLq9fJogafHn9fNReRkN40xtgAaYfJ9rXYDVREE8U2zjzMYjhB7gaKvsWZ0nl8mCK8M/1eyWfQB3xX9u8owoz0gwMsobES3wq3Ny6fOwsiL2C6U15FvM/jnBuBmDcptoSQo7qC56W552M+xv5mHIp4JVUNxUvis9CWe1lTeWKZonF0quk3qsaZhhh1rYZQ4bwJQO9D4N9BFiWeBfs7isbTbSdBirEh1Tc5gglgYQiE8xxagHbqgSgKl4QoEYvKTBHVqTCHaqBpKSbV2iuq5Y/8TOCLflVISLjfWhvTIijSIiG3IoM2fsTJnc9/RdxEhODqPMQMpJzvP4Yfo+H/G2up30HEfj+4AtHafsAalA8l12/2o/z
 8fWhRiw+
 YK8fb4h06F/5pZ+/VeVKPw5UU297KYCL5yVY57tbhKFhYofher76v4r/V9JyNdwzg/hpipqPMiD079DLvU4lLgy2krVGMg0R9vL2KS321jP1IQj8ZZud19L5lGkVrKvwuOtCQ9Y4qspO/4CykPgVKSOsV047QpKbhoyk/7OEycbZPgLsRV/WyiZp3rxbjnzjThO+NZ/qtBM3ZZqzYGufpkeMbV2Ihs+ATrFMA0Gpq73O9uhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/29 18:49, David Hildenbrand (Arm) wrote:
> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
> from freeing non-boot page tables through __free_pages() to
> pagetable_free().
> 
> However, the function is also called to free vmemmap pages.
> 
> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
> is wrong. But worse, pagetable_free() calls
> 
> 	__free_pages(page, compound_order(page));
> 
> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
> except for HVO, which doesn't apply here -- we will only free the first
> page when freeing a PMD-sized vmemmap page, leaking the other ones.
> 
> Fix it by properly decoupling pagetable and vmemmap freeing.
> free_pagetable() no longer has to mess with SECTION_INFO, as only the
> vmemmap is marked like that in register_page_bootmem_memmap().
> 
> The indentation in remove_pmd_table() is messed up, let's fix that
> while touching it.
> 
> Note that we'll try to get rid of that bootmem info handling soon. For
> now, we'll handle it similar to free_pagetable(), just avoiding the
> ifdef.
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Reproduced and tested with a simple VM with a virtio-mem device,
> repeatedly adding and removing memory.
> 
> Found by code inspection while working on bootmem_info removal.
> ---

Retested. Works as expected :)

Cheers, Lance

