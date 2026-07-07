Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37A9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA7D6B00A5; Tue,  7 Jul 2026 09:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AEE6B00A6; Tue,  7 Jul 2026 09:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8436B00A7; Tue,  7 Jul 2026 09:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9A66B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:46:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C26E1C39D1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:46:04 +0000 (UTC)
X-FDA: 84962104248.12.592F647
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7093AA0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:46:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/Co+LzW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6j+iHhuiu0EvX2FuvbrpgVLF9g7qDAk982La+RkgbHo=;
	b=Bi94YxFBkDG0uE61VVFqBIohBOHuqgp65kNClTsQ8DzAQan3MAU7tkWjiXzIaRBoI52MVh
	BUrJMiZf8KAq7YOlWuwMK27aQoZQpJsVlfL8Z8g+2Wammlj6SNybMhg86X6deTJrbtgPfT
	/6qT/CRcisoDX4iyeU2/JS7WMRMaYoE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/Co+LzW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431962;
	b=P27QiBlpyMACWgbfihDxgk5gCxIPhhtW70SYy+TbB+x5Wc8mURH2i25NG0d+uU6hCqLSv9
	XQPzBPti6mVVpS3A6KVvsogPgqfTt77sgvO/tReJ9/HZ3TUw8LdkAxPP8DboLJjzm9RqUT
	PYea8cYp/rvvd65l/n5InOXOmIYvOFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C30C543ABE;
	Tue,  7 Jul 2026 13:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241471F00A3E;
	Tue,  7 Jul 2026 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431961;
	bh=6j+iHhuiu0EvX2FuvbrpgVLF9g7qDAk982La+RkgbHo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l/Co+LzW+6cqyQ1rPBAG5Hlp/dHcizMJr7FXhAOso+ileGfMkbIBqNNiUhFlo0qB5
	 tmzV4ONg8hQFSqYUq/CwwqkSPHsjO9bSCEx6PiDwPVHGd0cw7JBtjweVaTyOuSr7es
	 7z+NT60Q+t3Y5dgi4ZenyqNkirgs4M+eloaYeHx77IyuxWX6uI+IS7hxCkTORXsMZd
	 nmtzKMwN0M8YaoU1MH7fhKazduAaSfI5bhVJYUNeTCQ0zbOEPR6pgQHBtvNitlIygK
	 SHzhUZqrWrqb/uWS1V6d47XzNJ+0EZ/3Fk4gaEUZcCBd6mkAgFkKEWLQjXtbD8RVXp
	 z3DuDMxzj1ceg==
Message-ID: <a70a5aea-012d-4bfa-8be9-3f8ba55c53f8@kernel.org>
Date: Tue, 7 Jul 2026 15:45:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mm_init: drop overlap_memmap_init()
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Taku Izumi <izumi.taku@jp.fujitsu.com>, Wei Yang
 <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260630072212.624305-1-rppt@kernel.org>
 <20260630072212.624305-3-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630072212.624305-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7093AA0005
X-Stat-Signature: 8xbxbhmtgqb4z6x9n7hmmb3omuicuz8f
X-HE-Tag: 1783431962-627254
X-HE-Meta: U2FsdGVkX19drlErfpJS8dDlb7xy9n/R22XhUy4VTA+4a/G1IL09tuTQxH3JhETZ1nHUbR1JQAqajs2qXVEINPxbjRbu7Tp7MANYkuN53OGshfHaZtjwRZx8v9dWTckatJi9sOw/T/5EU2EtWGAH5J1L2E86bvAbrOXqVXSBgB0rYHmfo54orGzyRKBveyLVrgJz8PQ7qEIFLe6BGo8/awLXEMZt9d+jC/+9x8n5Tl2gbvRoeSZjHOS5EqJkXLduoqnpt/o46a4lLaCvOgsi2vctXxALHn3tES0Jxfvj1+tPWp1dDpW+tcxmugatFP249qC2Yx4ef7BbiL2I/AqdrEo//wRmz7IY8NlmdCHfY1u5ln6SZD0GEPXtPpS5NifbiaGvJOnVR7ATmmd7ppVndXr1vVwS2qB2RtyxcGoqiYvBVF19J5je629djp/7zSDSI5/ihaxRn0u1jm6Cprt6vUMmfXObE87SJDwd0KBKrY4SYKNt+/5F0JBbqTleIpzcGimFnj9SP3pkRbHxoRVKqSg73zzSWoOkLtfOEP2Pw/k9TAYnFGQ2udpiNprtUgYdzTpPP7nPrhAOrxj1MxE28nhJt5PzgbpMJcbwicF8zIhWdNzyF+s4mut/HjtfFwO7K05aJahZlOcnAPQdgKh29L3TL9DJ1+qzBGWGPtsF/6FFa7dmkGPKgtStEK8TM5RSpgdrLLfRU81x8qYKeJPlw0+GStwYAiJSYVs2fnofESpMB/7v2Z4nybyv2Qz7zo79lopR1npitsxIhg8XUGb/y4g53UeiS5KdVv+KQONeNsZv8Tr2Wsr2tljJ0A3ZBqXKIFRV3/dEJxGgjgWistZP7J+uqKYkEOK3oIY78OVH/McWLJNl4eJFRLab3Ezjt4CyJLcSGfPor7R+wA+6a9ileLRvvyyhFe0F8ISy9t+Qe1DPkPU8VxfHNF1nnYMjgDjJ5y0BYiOfVWGwHilHvHx
 q7TvL+/a
 j8tlL+mcRdenHQjoB6aRHWGxQEJF9ONoTUMnNYRrI049ZlxMY5UQl3OWrtQR9WeCgGxl9HFD5edlLq+UCKTXucFqzO+PTf5KYjPZhuUN6AvraX8Jdr+EMmazMeEKKVT+IkJH+sSwGFkLu+d/C8dnquBfDWx+7g+9o2UVebZL5KDG0lIPOGmlTerHsD8RxBDDnx4PGFP59uffCcUnm8Tv1MnpW4BwQtlIdcZ0q509IafCYO1Z72RKT7g/P2Oi6ttlUWlMjcUMP8lszJxLXqGGJ4MxAZjyxY8fkR/BTNG32gukTPxIGaeEuwL/XcOVUE4BX9/YcbXSvmZhO8ju+sKBJtu/rBn+2wKM46eSuLzff36DcRGded6gwIoM7DMdaVsOUGQ3rLskg2A82SnDPKuBjaC0si9g37gGdSvLvMDRlkNRRAbjKG4/OgtaxrT5Tp1W6XJNqp/5xKrb94ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 09:22, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
> didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
> to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
> double initialization of the same struct pages.
> 
> Since kernelcore=mirror works now the same way as other variants of
> kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
> be an overlap between ZONE_NORMAL and ZONE_MOVABLE.
> 
> Remove overlap_memmap_init().
> 
> Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

