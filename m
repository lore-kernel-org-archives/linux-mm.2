Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D30EEB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3DE76B0088; Wed,  4 Mar 2026 04:21:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5066B0089; Wed,  4 Mar 2026 04:21:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7A36B008A; Wed,  4 Mar 2026 04:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0D56B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:21:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7EE6C1AD0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:21:11 +0000 (UTC)
X-FDA: 84507836742.22.4A690C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1FB0180006
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:21:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2VatNr2;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772616070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcDSODhy1U1tvRxD5I7vdoPA7Qv9khhqYVsPLGBWhFM=;
	b=foaZSGzLvvY61tuwkzpzvl9ba8/Z3Q7X0+JcPK1NPA1jkNl+BQtWioTBnscC0Jzz6ASaFr
	SaH7wej1IAPGYDFnLFw5+3KN0+nscKnas5RQAm+oxJgHKdhvyHV8TIIoIkOpki+biYhQAQ
	1EvAYhvyt4OeUUI2xoNq+NKEgebtwXA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2VatNr2;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772616070; a=rsa-sha256;
	cv=none;
	b=IcIJbSJzaVOOTMRfq8X5D4z2fvUYT/rQt7CHYLR+0YxkDcvzR1uJy5hPCqYx9KT2F7GUsQ
	Nuquk2rCm2CERTufiXsqDfObM/npvhZZdUbDYHnU51H05wR+TEslN24oL7dX0sQIZUypDf
	4O9hjuyuysku0mAHBxA0guJopxytiDE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98541442B7;
	Wed,  4 Mar 2026 09:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F06C19423;
	Wed,  4 Mar 2026 09:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772616068;
	bh=lYiqGVVRlGcEQbjg4Ysb7oHD+BPMIPaVIjThrPNbaIU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=u2VatNr2EyMWrBy3hoSLl/D2A+kvAR8wZSxNY2qXDTdlTd3dvidpn+rN3eYsHUtpR
	 ALLPBvaKYTbSwq1D1RjmFr/ldnUUSv99KDkVoH7J1xXwgANEQqbm3Sx+9LxnZYB5GG
	 VbwhfwI39lqK31XvQqCYK51vgVvQMVcdmEOtqMXWPXnJiwe6rrYRsPdOP2Wj4JoOZ4
	 hgm4k/FPAdCsMjIqEm8EGN6oMpnuby416Sjz5wuTg06sPmc90CxbZZeAfl8upPkFBR
	 XMLiG7scwlqGu3oqgNbH3Up4eLzyKTSJ6HNAl2TGKgBwdwiKNSH9yFTSaAEmQdFBPM
	 Pyl/dHSpkHA8Q==
Message-ID: <d6032abd-eabe-4552-b10e-9f4160edc609@kernel.org>
Date: Wed, 4 Mar 2026 10:21:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm: bail out when the PMD has been set in bloom filter
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>,
 steve.kang@unisoc.com
References: <20260304031538.1258114-1-zhaoyang.huang@unisoc.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260304031538.1258114-1-zhaoyang.huang@unisoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E1FB0180006
X-Rspamd-Server: rspam07
X-Stat-Signature: fahxuuhyshgurffkgaku5mufxh1dw8yz
X-Rspam-User: 
X-HE-Tag: 1772616069-997771
X-HE-Meta: U2FsdGVkX1/2wf84UB/cNUsxfVcHwY20sqQ3D7Uovzm1wpTPOawWcK/JCB7WdNgcaVdfEr6pjMg/oHS/du296RoO0UdSwaCVIwpYdlASm6q2YoGNqfPMVU7keZ/QL/7fJMKj/rOBmWI6sJvyKEHfXm0gk2j6Sm87iHZiDL8GmiSkbslmPObT9JPp2yGZTmKQl6mbMpJcJcPZ6Uls9LOV/Al+hHomkq8YkC1AL6K5KTq6R7qthpx3hucErpIh16h7uF4YLOmNPmIfHsi4giPIftaV4yrm697a13T8rHcE3wB1viddqOIt63ITaj41FWMrxCgn2ncTKncxEEDwiyW/mXZbrgS6BnTQELdJy3chnb6JvP4178e6zi5DuFAn8Z1yqfbDyiNtXqGJ6GSj03ttH44jMtDlM2uVHQpowIWH6Hc3epCMY0gJ0IIOvlUbWjBKe9pLijaObX72x7n+nEEs36JjDOsEasUP0syEQXwtTx93qX+XDkey/USh7QRLsa9Zr07xQ4KEGonWDeISAY8Fyxs76dsR0NqRQx+IWY0o98EuI9dzo/VNe+tAmnTCXdak4miKNnqHpy/gix5VEtpqBt2Y2u1dWRcI4vicYhHw71z189H259W6tJOSVz6BQCck7skRaCPPGgHvzsP2VaUxG3LfSmX5jqL2eXVQNbf7H05Aoxvt4LLptnJksd2F3dh4lM9wl6EOMwsCIFbJAdCAvIU62/dkTUkEWF7RN98wnePd70IsLzT/sn//7Ytc2nJcO0Gngd1WpaJbm/nXPavNnyq4QwvvaLj4Ddszfz2za1Y2zs/mUcNNXuSqhI1R/wTlAgR32GNq94DVifLa1f+6yO/Z2cCCYUAj2/3PGw4YKqNWQD+xcxWLQiZjGWgv4fO0p01f6XKDkG7kat/IMzUOecRhRbzz/2ZO7rsMAvVfmUFutpPvH/2GQXdSCIFJa+e1QjHILA/LnE/40Kst0yk
 YHuEEdO0
 IlweeRZfLScAJc7C3Bhr71ehW/LEmEYwppCk32gj1cUsy5mC5boelFuNKWsAjg5q1D49cT+C0Z2eG9Xpb2gu5BZ8L4ncS0KmgL6Kp+xYJLiVvceto2EGZMC0MxaJ3R1a9qzv59KA0yjK4t965aVCyGL1lMsI9X+zlXEcMgRU1Z+ydXIhuO3PS1ldWK4neKJ4tTYM8F+6oXqW/rLsqNfaVSSnJMTe/gntwYp7kbnGwl5eHKvwsOzWjRQ65WTpKG4Aa6O0UpoqKqSfjOhsfkDIWRuaykH+6QPwnDEtVA5+vIU3hhZ4oTu0ZclnQj38skUI4sgYcxoofTcUNRwhnYVAgqCh/iHmyG9OWmySGgG8DsPPNH16dGfJOyKjd3Zisb+Eu9cFQnLCALFofBReJwKRCCk3O6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 04:15, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Part of bloom filter utilization in MGLRU are listed below, in which we
> can see that the step '3' will prevent the hot PMD to be carried to new
> gen since the new arrived rmap_walk clears the page's young flag.
> This commit would like to suggest to query the PMD in bloom filter
> before starting the rmap walk to improve this. In terms of the cost,
> test_bloom_filter only consume 20~30 instructions in modern processors(25
> instructions in ARM64).

This is hard to follow, for example because

* You forward-reference things
* You talk about "this commit". A commit does not suggest anything,
  people to.
* It's unclear what the real benefit of the patch is or which problem it
  tries to solve.


You could start with a template like the following, where you clearly
express what is currently problematic, and why, and how you are
intending to optimize:

"Currently, lru_gen_look_around() does not properly consider the bloom
filter when processing a PTE. This is suboptimal, because TODO ...

To improve performance, let's consult the bloom filter for the PMD we
are processing, to just skip processing all PTEs in the PMD table.
"

In general, for performance optimizations that are not completely
obvious, we prefer actual proof that it is worth the additional code.

If it's a correctness issue, we should spell that out. I'm still not
sure what it is :)

> 
> 1. rmap_walk set suitable PMD in filters[max_seq] while all page's turn
>    to be non-young status
>    * rmap_walk->lru_gen_look_around->update_bloom_filter(max_seq)
> 2. young pages gathering on the PMD if it is a hot VM area
> 3. newly arrived rmap_walk in the same PMD clears page's young which
>    are set in step 2
> 4. walk_mm test the PMD again during aging, which will bring the
>    suitable PMD to filters[max_seq+1]
>    * walk_mm->walk_pmd_range->test_bloom_fitler->update_bloom_filter(
>    walk->seq + 1)
> 
> Tested-by: syzbot@syzkaller.appspotmail.com

That doesn't really count as "Tested". It just verified that the problem
in v1 no longer results in a splat, but it didn't really test if the
patch does the right thing.


> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> v2: fix null-ptr-ref of mm_state and update commit message
> ---
> ---
>  mm/vmscan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 10f1e7d716ca..5558a24d1564 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4234,6 +4234,10 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  	/* avoid taking the LRU lock under the PTL when possible */
>  	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
>  
> +	/* may the pmd has been set in bloom filter */

That comment is not really helpful given that the code does exactly that.

> +	if (mm_state && test_bloom_filter(mm_state, max_seq, pvmw->pmd))
> +		return true;


-- 
Cheers,

David

