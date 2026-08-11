Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E0EC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EA66B00AD; Tue, 11 Aug 2026 11:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF7C6B00B8; Tue, 11 Aug 2026 11:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE226B00B9; Tue, 11 Aug 2026 11:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5F566B00AD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:39:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BE14404C8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:39:02 +0000 (UTC)
X-FDA: 85089396924.19.5E4F6EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD70240007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:39:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RWQiad2L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vty8HoeDTr0Ll+bsIomYHFcGaBT3FmdH1oXuNYagVx8=;
	b=kcQraU1oI0gDwI0em3W28A3Rc5cngO0V6bBzL/bkMuq6JOR7BvaV1ox290Ix+prUNFXlBZ
	eOgub6U0GjisEHjpDNec1oXrB+yX9fFiB3E7/EC9nHgi9gmKEYT3s3Cd0dsk4KHTzxSWMy
	te3BaW6RySi2fojHk52wqjGUqFu2Id0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RWQiad2L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462740;
	b=yQhiBxCCkTfFm4TEhAzjLL5N197ODjgwf7J9YYciKHil+OjeBA6EyXAzD0jlfTYKgJcA6e
	XgRHKlHyRm8Ppnx/nSmUDjDTFxRx1CBE4ehhIs4OQ1jjAndTdDsvwkXymLSAr0q9XozV0v
	j7EkHBcSr2n1IFFyo3sZ3yJQrZQ9RhI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE01441E8E;
	Tue, 11 Aug 2026 15:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332B31F000E9;
	Tue, 11 Aug 2026 15:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462739;
	bh=vty8HoeDTr0Ll+bsIomYHFcGaBT3FmdH1oXuNYagVx8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RWQiad2LffBylWd986oIPwwUu+DA2UISu4R2DBDtCFwDvLnA948PxR/kEN5ijUfdO
	 vblsE4BkCOLbZD6WPgKTjF9g1W+kxCIuBXwMXXSiYeLtJqwgkC2E9fJSrCBvD9OjFr
	 CgGdLX1Kl+iNvlN2YQ1uv3y8C5+QtBDrs+cYm6ghLkF1bEPj7TuAWWFrcyFMsP7SW5
	 Z/TKXOJRv6s2QNLc9KBCeHj+WO4dnCcTmIsF7kM0Ymj3p84zv5VmOwaiyIbpopXkeg
	 gmDPrTfiQ58RMuIExi8Z66vkKUSURJNYAGa3L9ScCyMYUr7DoS9CgnTmL5E6tA1IRQ
	 zfTkT0M6U9dYg==
Message-ID: <8c16339b-6050-4a5e-aa89-9f2f96e7dcb4@kernel.org>
Date: Tue, 11 Aug 2026 17:38:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: fail the fault on a malformed swap entry instead
 of retrying it
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-3-375ef0767206@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260810-swap-v1-3-375ef0767206@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AD70240007
X-Stat-Signature: fujywpbmqneetzytfrmxa1it7remddqn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786462740-194145
X-HE-Meta: U2FsdGVkX1+4MI3xcSxYv0RXydz2K85vAvyR4IfxYoRE3IdbEJLN1vFBPYx4K9w5UcFS7dIQ4L23g3XybDduXgMMhrEQbn5lwHuvDkXuyFei+B1bzEuYHKNuWPJtsGPvUgHT/1PpBOC6aNIiZlNFBUA6BGTkllMrMv30PCU9ux6sLLvmtW+gi8n+MlIOgLyrAHQujQWMtoWF8InxhhRGYRX7oo7lKYhWYpp9va3tekYSbMrFc6a89dPNiMOcbGeRWLtqImpdADOY+k71jemWKsxwMUacaqGLyMHcAkhq1lH/PJ/Sifr4cuzMv97vMA19XVSUX9nyX1Bk2CDSZvpx7745Ap8uF0S96xoaTySfTtyqypgZotVD3ueEXJAMYp8+EIAoPVQ5UMqPlpsIpeCbKpfhWjujUmAJbd5titNoDATKh/hRORJw909BGManHbvnmpfUKKdRm39AJpug1+5Rb/luK0JPj3Q+d7a4Y8+8zrfdVf6QD3XBKxtQcw+GdaaSpQhb/tMneWp1Xsu4YT9Tm4J9SAAxziOgDU0VmSEDQSadXfdGMm2R4xUgQBFloghpTgMqZyIBj69FbTpGOBA4c538VyN9L5u4HN3CHPQNFG/aPpI57c7K0aCH2yR0yzfUjAmUrNep/ueyaPaaUj1mUr5sO//adkElblmdfsyxKINNbHRANJAZRZeVLFlAo7QC/w2ZQZ3pAVMvy5K1AnaifUgZb6G+cNWR4yZ8QUQ6qhEcSn1lMl0TLhzH/lwR7lEOUXJHKkslfHP+GCFmMqwOKtEDTN+DMtWu9VsynI8MiR/F+Vn0UBXmEWrMBmh6zQ3DuiP4GpGwIS7TwxeseHV0UI1IuNpz0tskGI4lKXKltdFlhRQma0OqYS6c9yN7eQBj8V77GWnHK1NjHYY74A6nGJN5CNATZtlaIpoAXvBX/emrTQjHxNMBtWXZn/mUjz59IvelfkSiJ62+zCaaLnN
 FeHJgXli
 QkdYLkf13bSDi4YCn3ahpLgFXylnC+j85ddfXD51J0Mpf9XcM7hV+9U8gyad5ZU9yAvXu5EAGM0DmFRh9LMj/f74C6MZfFmdXkw/SFDcHBLINTS44JnNFcl/xhV0Eusdcup/QlRhzRWltZsApeK/XwVbOkbM9838UMpBwK7us/uGWehKam9+5/jIZpTJbwUW5vmnCrOdPffvmu9LiB16aHqEjamhZJNU2QrW3MF5LF5Y2P9CLWmhUeRpwAPjUgnfdqzhcp+caTIyfnBUYZ5lA9yxzgabhh7qVwlB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 18:26, Breno Leitao wrote:
> do_swap_page() returns 0 when get_swap_device() fails, which the fault
> handler reads as "handled". For an entry that can never become valid
> the retry takes the same fault again, so the thread spins until it is
> killed.
> 
> Return VM_FAULT_SIGBUS for a malformed entry, as the sibling arm
> already does for an unrecognised non-swap entry. A NULL return still
> means swapoff, which is still worth retrying.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4238778b66c42..2842cd976f1d3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	/* Prevent swapoff from happening to us. */
>  	si = get_swap_device(entry);
>  	if (IS_ERR_OR_NULL(si)) {
> +		/* A malformed entry never becomes valid, so don't retry it. */
> +		if (IS_ERR(si))
> +			ret = VM_FAULT_SIGBUS;
>  		si = NULL;
>  		goto out;

Better update the comment above get_swap_device() to include "bad swap entries"
as well. Best do that as part of patch #2.

I didn't look too closely, but conceptually LGTM

-- 
Cheers,

David

