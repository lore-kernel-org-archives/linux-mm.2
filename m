Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97275C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948076B00B9; Tue,  7 Jul 2026 10:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920046B00BA; Tue,  7 Jul 2026 10:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F1A6B00BB; Tue,  7 Jul 2026 10:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0B16B00B9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:06:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E38961202C6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:06:33 +0000 (UTC)
X-FDA: 84962155866.05.34402E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10E351A0016
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:06:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFUcLTWb;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783433192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+I9nwTpmAA6ni1EUvKuDo6D13VJBDaUZF/B29cKK82I=;
	b=M3jYIvAOBfeyg51q1ofRPOeXplo4kouikD84V0R75mAQUfD9LAwdEUYrNDVeqbJr19OlXy
	Wt+qnN6JCXVLeIvkYrNzHjTkUKs78w0w7Q6gzZX2XHrxsPRM1VJILcLFNFZ23C1KnHj3h2
	j1k0jzDqpcAssq+w3UvxJwmT+oCjgGg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFUcLTWb;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783433192;
	b=r6QU/COMvFHakVVqV72T7U9tWHMOwDztUE2Pu+Jpgrz4XcBEJJlyfan4ioTBExFCdkMAbU
	6WWRAKRCbeJbdQ1JuujWJOcLic8uTpEyivrHUg+STOFeWTjAGreGyUMKWUeTk62fcrsNXK
	C7zejSB4HWPLD3cT6oHhV3+7wheUoho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B22DF437D4;
	Tue,  7 Jul 2026 14:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659B41F000E9;
	Tue,  7 Jul 2026 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433190;
	bh=+I9nwTpmAA6ni1EUvKuDo6D13VJBDaUZF/B29cKK82I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bFUcLTWbY9u4JjmZ2KB27ZH9NdS6qqvpUyrJlti8p7P9PYfY7vUy+TDF2m9MzE73z
	 6aZks5W7/06uOq8f/Va67YrTGfeXD7nj4DUwc3ZfZWg2HjMfJLi9LNlMc4pGhEVseR
	 5xxDxObh+Y72ApN9L5A+r/zo/CVmHZR7as+gWu8ot31jnAKFagT/B+IDWYfUDCxscn
	 87TQ8OhYiuW97PkB2ubUtUMW3Ouq7XVAqaKaeCTL9zbTTJXvpUv703WGJGG8ypWpyT
	 VZ0V4KwU/CW5XL+WT+iKdU5CUJT6oZi0jp4lJgfdl+Y8Osw9/xiB7hSsm/aoUKxZQS
	 IDTQtCsX+RzLQ==
Message-ID: <825d6190-b197-40c0-972d-7ffecf74978b@kernel.org>
Date: Tue, 7 Jul 2026 16:06:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm/rmap: convert page -> folio for hwpoison checks
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-2-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707121128.373192-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10E351A0016
X-Stat-Signature: tuz9d5hunsyiisx9mmumc16pmqxacuh4
X-HE-Tag: 1783433191-322276
X-HE-Meta: U2FsdGVkX1+CC9OibV74hKuP5OrMGmZpcWrLQMnKXn/pPIUsdKZ9hzGwpEHzT4LsDF7Pxj0SjAk9xN5ia6XWpeVEyU8wLUa4KC3gSeM1NnUrbwKDk/cH90JwjfYY0l/xNE+9wb8Au5V8vvpctlFv7JsH2i9oiX26ZphspYLgMxTKIF2hdbVSuv+aIb90/JSBNmHYc95j6k1jQWU6eJc09pMxFqvQ21T9dmVZxyX2eRBF7EWF6hmbUH/UQLmbLqLZGG37C3KbCZqPybH6FUnB3j+pSDFdj2y6R39oymd+C+qINm1syeDHslJhr4RflG+9IPoYr6GjiS9vAeOsKes21ogXPC6B7u8FomHo5JMTI8+g0mVcvL3aW97G7RBXOWqSPNHZJfuNFOpsWAPWUrG5BoF1p12mZ09JYpz2qQxqHGqHmWPmHWWyioskYTKZNtiC272HMq3HgqhKHDGV1b6xuYO4fn9r1MJMVFoERq3HQEkWMJ5aWt2i2Wtdj2PToomeHFR+i3B9wsVXz92iwUo+8hrPqCWAE8tMDbHZI9lEdNosOe389G75DoMw4DLRID1tigrPFfeJL/CMp/MQwmDcES7eKXEc0D/aB+dvhOixgvbP8Zm4DhlqMNn4jMlZIM7DvNSo/1Q29tK3Qhe8xChOB3mS4/B044lHdV0v/wN7XT/7+ukl9PBc8z6qQmPWqJcFAX9l3z5TLNyCqeDDxW3yFbVGXtRa3YBuQPWcAW0JpYz5dBx+ey0P5MAT3hE3fQp97sbC3yzD0PXMvcN2aAU5+EGT/zbp3mUuvVVZotidMPfLat/Anj9r5BNd+nwDZxPd+Pv2TiZEDXFlzHVCMBp6q0tThu/jw5AwezdA6Q84cE7taQxtLrjm+zkrg/T5pc3ljX+/2JTjTvPDSpiAO2wXunpzy8/cNw6vpg1LLwx/N9NzxqXukvP2eu66LMKcWQwygnfhlPZ8riJEtVphqQs
 AtSx3Rn/
 SWW4+06bkwVGRJsoHyuzstak5aoYXzQBaQwg9fWO8QZUyZe0h42Eehfkd74FF6tz82hMyZ099Yvs7XESnWJvNi9PBQYX2tWQiXOKVCsVd17jjiop4s6R+Ag/5OLFiBD64m/ysLfAkceeBlZHEgst3UmbbJVEQD42oKInVk6V+vNO6KndG9/H8qgvAEcjLz57Vb8EZGfuveMeNG2XmJytIn3RDfkqI0e65xw10zx3nucfX3IGS5WqbRf0Ti16Wgt0fcCBMLlk4wsI48piH9eS5zXEtz0muKXhk7wzijQPt1mcAx0u4YDy/+dgDrIy5vl6pa/VvL8zMWm87eulPppUOvGXM3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 14:11, Dev Jain wrote:
> try_to_unmap() receives hugetlb folios only from the hwpoison path.
> hugetlb_update_hwpoison() sets the hugetlb folio's head-page
> hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
> the head PFN, so the previous PageHWPoison(subpage) check happened to
> work for hugetlb.
> 
> For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
> folios before calling try_to_unmap(). Hence it is always the case that
> if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
> marked with the poison bit.
> 
> Therefore, convert the poisoned subpage checks to folio_test_hwpoison().
> 
> No functional change intended, except that, while at it,
> convert VM_BUG_* to VM_WARN_*.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Yes, LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

