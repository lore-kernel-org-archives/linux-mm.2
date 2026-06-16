Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4A0CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E896B00B2; Tue, 16 Jun 2026 16:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F086B00B4; Tue, 16 Jun 2026 16:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E186B00B5; Tue, 16 Jun 2026 16:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46AB16B00B2
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:49:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BEE714010F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:43:30 +0000 (UTC)
X-FDA: 84885892980.16.904C907
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 694DBC0003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:43:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCSNGbwd;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781617408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Oh0YS9b7Onf91e9ZZvanm7f8j4pWdMaNaTk7gpNPIo=;
	b=prCLzSQMsgtd/BwBWUqgGJt+4CMWGqDD1WVPeK9RDGtZj5ulHYFbOSzP7ZE1c668X1b3/F
	ryAnMMcVReOVfREL7D2jM+akDKrVHtVM4AIQYgjrZ4E1XLsuVFYpBfBQ/q2FZAps73tRAp
	JCNVsUqloPTm25YDCongKrgdKzNUWbQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCSNGbwd;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781617408;
	b=lek/4PdTrLjVn0Zqo7tAWCqYJSe2U6UVCKTgAhZ4TZ4tLg5k49ljHxCjV5M5vhZyWXLlOh
	ecK6MJ9b9J2Giyfq9Jnn5V36yxPNBM9XGfisbVew1gcFqbnV1qf8tKz5dOPX0Xd4pNJeFT
	D/73HO4l791tAkCpKtmgiCVoBvoi7BY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E20743D3F;
	Tue, 16 Jun 2026 13:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3924C1F00A3F;
	Tue, 16 Jun 2026 13:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781617405;
	bh=0Oh0YS9b7Onf91e9ZZvanm7f8j4pWdMaNaTk7gpNPIo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aCSNGbwdLj3Zayt1teh5UoLkNXqA1qaYUk18rDsMPc/r87sJ5sUV9x9b9AwCHF2QH
	 3ef1qoWTZUDSd8DiEd6gUuODwjrgkpihoBb60QeixWbAdaOcN7Uvt6e1OWYj0K/9cI
	 qSqHhYCrulgOtvpxYchB+1Tp88iFkZDbuO+mtnowPqMONzrqatat0CBxIU9+hpVMse
	 JVmUqHO8twhuXMP/yYAxDMEA+QMqVksfT/r6meISjvr13E77Wnmyoq7eJf2Kn0r2mz
	 PEwm2wa0Qv9JuhzvAMrMGqfvPUnORRRtgjMUVLyTfJnwdXXKpN0QE6UH7ZoYtC7dJg
	 2jipYxMaQMV8A==
Message-ID: <a9483db7-5b13-40ff-8d45-12f40dc97c77@kernel.org>
Date: Tue, 16 Jun 2026 15:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] mm/memory: Batch set uffd-wp markers during
 zapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-5-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 694DBC0003
X-Stat-Signature: 1jh49b53naj54otd9mq11zp9jjz8xrgd
X-Rspam-User: 
X-HE-Tag: 1781617408-732320
X-HE-Meta: U2FsdGVkX19rOKKvt7TFM8Tj9Z/PLaA6PPq738EQLLRHsyQiMmUYf8KWLbokUCW5EQ1ZeUXC+4v/bWIyVCS23IdkjCxrlzGB6sLWHqSTCVqLTzAgUx9c5XKn1ESPBWibkg1I8oVp7V8LzbG1adqCqJzSzrIuml34mrloTs//NFDJWzt2UaPjCJz/dsFfGhL64dGhNTDqFB3PBzaOa6ZWlfUd46R4iEfRVGZxk1lFr8378IfCZzC8epg97wDLxJm9baLIQ94O0FIe/bqprUI5/NZ4DhuRxD1F2MxK44SXK0U7Tub5WhMPn8WnvVMSB+VR+kR+lj+nKikApQu3uGejvi52rJpfEfRLjZO9TnI/F9k1+HbcvBg/byjuBDfgjnzEq3pmtr+k5Qu4/TkZp3nTR6v/yaDSYli3i95E8F7mCUwKtb8KGjnbi/LyOZFGAi/9VeufNiV8NNB9f4hQ8K+FfCPcjSfYYocBSJc3EN0q5lbBle1XDGQrRmImuLVldeQvgffqV7a/SAYdHj59S2D1W0rOAgK9CLqqc4dCEPGSSUvoeKGzAES4XsML20a2kd0LGcVoaiDbk2AixjSkqxOErW6ZW9g1nUcJpRVIuKRVLHCliu/jDcyx4bAgg21CPSGn1T7vHcnbjkjbim5yY34i0+w8Y3DoaWQx+ErPnVyqPX6zWsEEOgXx0DrtEhbKB+1fgkLyke6JsQh0tPgS/NMvG8ytHIo1+l/8k5MP+A+vttB5v22JoeXwMsa9jlOizgsulVpn1x3h/ZVNs/MGLmrlD7s1b6boIuxpGDxfJ2eNyYWV0kzOxxJv6N0PE+pmiSF5QpiceN/nivf8TRgUnqonHYWgCyNPqtUu3fUYcrD2Tb6dswpZDgFej8LWA6Sk0NRf5+5CwAOgWqhDEh6HbUl398BfRE1+UqkwS4yUshDKjOdaPvgbfAVyA21ocEwEq+C6DL3zjgNJJjYd9jsGEe/
 nsNokbj6
 xHJuR0RBM1i/fxKnMcL5njIgvERheQEEraK2EtxPBFawnuyY4LDD04AX2Nj/vVrymbpGdTOTHuRw1Lck/3AwC+OUonpxc1+F+nIt1hsWFwnlHoGI1hsC+U03ox7T4JvEV4f/J9K1IBtLI3nZpTf9zD/X0FPOWarycBsG69FgCht2HSbIOT+RyTQ+J97cCKAsEV2n24Vctr0kJSvwnCPZ9a1WV8v2U3cBKX/mU3vX0Vkq4Ups8xZ7K9OBsIL2DQjO7YqRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> In preparation for the next patch, enable batch setting of uffd-wp ptes.

Avoid talking about "next patch". Phrase it as "In preparation for batching...".

> 
> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
> that nr through either folio_pte_batch or swap_pte_batch, therefore
> batching is correct:
> 
> 1) all ptes belong to the same type of VMA (anonymous or non-anonymous,
>    wp-armed or non-wp-armed)
> 
> 2) all ptes being marked with uffd-wp or all being not marked (same is the
>    case with the pte_swp_uffd_wp_any check)
> 
> 3) uffd_supports_wp_marker() is independent of the function parameters
> 
> Note that we will have to use set_pte_at() in a loop instead of set_ptes()
> since the latter cannot handle present->non-present conversion for
> nr_pages > 1.

Below you have

> +	/* The current status of the pte should be "cleared" before calling */
> +	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));

Could we easily extend set_ptes() to allow for non-present -> non-present with
nr > 1?

> 
> Rename the function to cond_install_uffd_wp_ptes, and convert the
> documentation to kerneldoc format.
> 
> Move the function to memory.c since this has grown too long to be kept
> in mm_inline.h, while retaining the inline hint.

Well, for functions in the header you really need "static inline", so it's not a
hint and I would just drop that comment.

However, the move while modifying a larger function is rather suboptimal for
reviewing (more like "spot the difference between these two pictures"). I'd
suggest moving it in one patch, and thenb modifying it in a second (this) patch
instead. You can perform the rename already while moving I think.


Nothing else jumped at me.

-- 
Cheers,

David

