Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144BEEC1E99
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D0F6B0092; Thu,  5 Feb 2026 06:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7043D6B0098; Thu,  5 Feb 2026 06:00:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610956B009B; Thu,  5 Feb 2026 06:00:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8066B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:00:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA3C613AFD6
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:00:01 +0000 (UTC)
X-FDA: 84410108202.16.70473AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2320180014
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:59:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZPCsRmv;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770289200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRF9CjxhoVN8golQWlYqYREeSJk0EpIF4jgYVFobFMk=;
	b=tNUNY5JiKyGQiT0o4h2dcJC9Da5/iIscphxo/21IqoEoAQUBkIpLzoD8N94stzggOmQhWk
	fCkHpNmJOR9a8gYou0ZJpvLa/pwYX0YI6FVpiwYRPqPNeYrDJ8sxa/uPAegeJu1D3xkDYv
	xVj8/nuYjtdN8ABuDY65zoaSrax00qE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZPCsRmv;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770289200; a=rsa-sha256;
	cv=none;
	b=4fn02nYF3+24bHTybQfkqs7uEupEneSdLVyx3ypQN4G6Trlp0YFP4w2wAP6e8pwBvc8i+K
	yVUjsMl2sgWZpeTJYxc9zpNVRDT+wY6ukTLbH6rrGTl+f4H1o4IOIfWS+Z/p6eQS3/kNfF
	zGgN5Ch/wVKSgodnaEvO3zwsCGn4gOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 74249600AD;
	Thu,  5 Feb 2026 10:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D5EC4CEF7;
	Thu,  5 Feb 2026 10:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770289199;
	bh=TV/07xKPaVDFHwJQhTcGrz8XFLH13N3ZBmOPPvSZvcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DZPCsRmvuMh3OUdACeIOpeuD8Jd6KYr9na4LMoILdnUlbZtnWKI6VepqjdYDBEucA
	 hg7C7yINxi5s7NfCxgv3ocIhNceziOvf8cQ5AIMnVxub59l/CuxUIomXNIB0XoCUUA
	 /BaoSjdQCTv8ADbLK8pIcxCZMhRn6jc6SDZf4rAZg9WsIuB3lQ+mNmMNB+OxwqTtQD
	 uwi0GR95qGQW5wudgmBwoOBolRnAPG4Yio9G5pndm2ObbJmjIzdxBFpP4zpr5lzq8+
	 FRy9wOsnPQjGktgVAiZSCSib3O8DLpQr/p1f/269HHfhAuB/NsREQ+a77H77dEG0A0
	 AIIUJLHY33TgQ==
Message-ID: <d3dca137-2e4c-4a1a-bdec-63cc2477bfda@kernel.org>
Date: Thu, 5 Feb 2026 11:59:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Alice Ryhl <aliceryhl@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ewbn4ibnrwmdr3bd9id4rx8cxkge14u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2320180014
X-HE-Tag: 1770289199-512386
X-HE-Meta: U2FsdGVkX19tyjk1vntRPjgWx/6bWiow9UHHON7SdKKfgBSpqPHAzKM4MflOWVzWUJ+akme+wCnHHLid8Ys2bsus8YKiepZoRwd+Vm98LrVpL2eqcCS/+VCjNTtP8HD83j8TivMiDpCiqokafYosy0336l4Diz1FD2dn51y9Ts9S4UwZJVSoW1EUkysk8NEk/sTCvD8r/Acimy/jsFSmDRIBOxrTtrKqw67WAGVfFYgxHUXk1IX3vFeRY4aBk6jxllU4oM7uFMTxbwxdQSEjciFjqKZgG+9X1C2LwenRRg9lh4aw9uLuIK8INVNaRFiSeRV9Xua3j1dBLU6j7lFP1ZD3HVEVis4UQ20xqlnZ2+wF+RlmV0K1Gpl1FXHHYAiRt+NUwkdf6RL9CccPTRLIDJwoo59VB0zEiqUPlr/5p/2MLR/mCPNUQJ5FSuep/ftq99Z03Op6rEfHLzDOIRbbHK/GcSQCTrPd43/krFnOMtihzocNN7uDtTJl9KLqNYyAExbAkq3gMSefq10fI/4bcdhuDsOMg891NmQfCFh4DsamphnNbUdRx7P8+Zw3No54OPyofEsOjrz/kr3WbBZwhiLWMo+fyQsnQvRiAA3K8t4RSWqw9/hULpTeArWfiQoVOye+RzWkP+mgkGXCfn5R2mEGRiriKGjPN4uyIrm4z5KQA6NpCDaCrh0d7ifWqgrNq5X/lYL77nTscxUmsw8qz+r70zX02uSCVGWB4mIvw40so2EfgV/m6n1GfMeGNBdOIKnxJzdXEuf+edI9pKcuUJgNS1dQTbjiCuy+pEoWIOBiXIpzW8S/b31HqaFPOmdih/CRLVl2Q+GitFFpzTSj7OxyyjM4u0xBwCz4hIC9JgNprmrQ2SdjCKCvhJdXmNVNAwiKmkN1bt7wkYZaweKFD8x6hdxr0smQJb2Q2l7yxjK/95AU7A9Lrt8faMKY0W2HzJ1Bw1B2xRxmdqmr8Cj
 2T51XBuC
 bERJum7xOUQ/qYPWrWbtBrHafWGHx42bdEhar5rRE9o3vZo68fnuUlDXVbr5oBQW9/PaU9/hDFmxSpV7lWpJvjdEqpJptebKky41wiEJ7ZEQpm4bzJR1DsP3SdGmDoctKCHu0piy0N9+4PgXEgwk/nPciAOscolU6e694X+wKcFXS0j9X33y+/38/C3jn5rfwbThFSQLtJDI1agu4PVtCbqdQcyn79Gcz0JxjhacQfCS4v6RS2js6s5yvPpymmj3k67vforfTytllTKX4hyTAbgVJXil8PsKFLp231CODOTmjEUnUgTUUNYocbPXKvfqLL6xNfTApt4RDzlk8ODycwSxpVz3Jpp0d0Oxz61H7Gfn1yLghVY53wZ0effWnfUgZYE/RTU1moW/ZIXX9S3ndBUtrvU4Ky4DGhFcGrGhzusmHuti30+3My+QOJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 11:51, Alice Ryhl wrote:
> These are the functions needed by Binder's shrinker.
> 
> Binder uses zap_page_range_single in the shrinker path to remove an
> unused page from the mmap'd region. Note that pages are only removed
> from the mmap'd region lazily when shrinker asks for it.
> 
> Binder uses list_lru_add/del to keep track of the shrinker lru list, and
> it can't use _obj because the list head is not stored inline in the page
> actually being lru freed, so page_to_nid(virt_to_page(item)) on the list
> head computes the nid of the wrong page.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>   mm/list_lru.c | 2 ++
>   mm/memory.c   | 1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>   	unlock_list_lru(l, false);
>   	return false;
>   }
> +EXPORT_SYMBOL_GPL(list_lru_add);
>   
>   bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>   {
> @@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>   	unlock_list_lru(l, false);
>   	return false;
>   }
> +EXPORT_SYMBOL_GPL(list_lru_del);
>   
>   bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
>   {
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>   	zap_page_range_single_batched(&tlb, vma, address, size, details);
>   	tlb_finish_mmu(&tlb);
>   }
> +EXPORT_SYMBOL(zap_page_range_single);

Why not EXPORT_SYMBOL_GPL?

-- 
Cheers,

David

