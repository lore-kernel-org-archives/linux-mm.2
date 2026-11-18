Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDF6606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTauBCrb
Received: by kanga.kvack.org (Postfix)
	id 450E86B05B7; Wed, 18 Nov 2026 09:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4013C6B05BE; Wed, 18 Nov 2026 09:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31ACA6B05C0; Wed, 18 Nov 2026 09:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 114226B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:58:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D7C6A07BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:58:10 +0000 (UTC)
X-FDA: 85448545140.30.00B582B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E829020005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:58:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTauBCrb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHuM99Jzt7UiO9ZNKymx5rMYrueAFx5g8jXrXfP2WNk=;
	b=OLMU27l4fRTzDOrfOrA8aqZ8Kwf0tRHfcXHhVblBf8lb5+gi7UkP5VcZZTlxy+wpXHzFYg
	U8SqGaXxxYq4/Ed7m/wGER2MS0hrNDHRlyTNobu8XLz7rZgrCSB+S1j/+KuXPUZfvpdM+x
	gv3fx/2Y+TN0JRe89v6xTwI/gfadYOI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013889;
	b=VLTRiqwTb8fPBQnCM4+A86j8rSkrfVLQWuU/eUHLucTfRxBXzMAfufv5bx/lvjbqnq3y5i
	DSQLqv9P4gGqSt+uVjaupSepFCHvBZCD+C0vmwroqa+bXMbs4iUunf5lg9P7+Q2w2Z9trs
	8iai4DSXOyAGGnv7wvuFyifIi5mNl2Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTauBCrb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A605414BB;
	Wed, 18 Nov 2026 14:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3F61F000C6;
	Wed, 18 Nov 2026 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013887;
	bh=tHuM99Jzt7UiO9ZNKymx5rMYrueAFx5g8jXrXfP2WNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BTauBCrbJxPM5YsvKQ8IjqqOrGylzv7sM/nWNL7FPmqkjf0V4niGgT8RPZAoNNxxQ
	 PFDhn+JEsYYdlwO4dhAt2wjuA3sfUBlWxgEWynEsaGgvj1eOxjkW/W/CtaFz+Qjp8V
	 9+GP2zD+gN0ZbWiXrKqewDIfDiyYJ8R6CyielFazlZCs7w9tIqgy0XumuVIpwwpxeq
	 8NAdldESd3h6zJ6lW9GPsJ6VAwbL88tBJ9UxAIRViPO1hjSp1NPwIHjuIKQ79i5vzk
	 P5RUDlljycF1t7XPxEauMY5IqfJJcKQjcyXQomUAhxOb5VgQKJg479tCJkRuZ7PbpF
	 WddlgxNHkEE3A==
Date: Wed, 18 Nov 2026 16:58:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
	Jingyi Sun <1045704958@qq.com>
Subject: Re: [PATCH] mm/userfaultfd: reject DAX mappings
Message-ID: <av28-asG0qH2Tpsf@kernel.org>
References: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E829020005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zmkzempcxg3h33tsfnbn17ca51osjkgo
X-Rspam-User: 
X-HE-Tag: 1795013888-891724
X-HE-Meta: U2FsdGVkX1/b+YSK7rXZdIpjveaL8WxVfo+ZGRP+SStA29XEvFeiQ3SNrHRdRLl/GCqqwEskKERRHwPXmJ2Qlnzy8/yuvxuf1DPsvzCoGSY+zc2rZdAGrFPUy2Gjpk39raduBnd0S0Yv8lGSDRJIoWu6Ca5pbPQz0Ifht9gnDf3N6OE9rrUlUVX+FZyHZYaKRk3CLcakgp8npE0rCLQPByHAHUsHYzN3nPFf2SO2rgrslYEHfMXclk1DHP8ntbi0ykCjjwJ25BEkDrHCqxZiKfjBv9Z20OloxGJUWnmDTofCFDx3b2WTBa3ltu7RylJkU5An632D3w9VxKAWlSLyGI+0DaSiKd8S++iMsAFF00cxP1Vhio0lSDVWXiqyjrZNf1JrUhmOHbss9/pqGxYWM+p0bPVjoMyiP2UReyv/g0BmwsHzaqALB3Mo0Q92zNfjkBM0qWU2xCNdmYDr9Ly/o9EXpYZ9VHvDORaOqRNukwl4sEQzKlLeV57Adjsaa7Xe70CA7AZ6mPWTU42BpgsBFCYkRa9gp3bIH5MwEtCq2OoDShU4lNrPZZhRoSksMkqE1BbV3uOeExi0IRvH1fgaKb+JATrX2Qq2htSnPYkmVV7rnksPfqsQ0iDn6HZrTYUqUW/2V6/bwerEuIMZelkahKfRR00HuOVHEPzT+Yu7y5E7MP2Y5WeSgO2RczsrRxc4z1aPs8d6V7SfALAKqYuNI7WJIO2bflNT6w3Uj5AR7WE6dSwh8wZGEO2+uPHLaIVChirRoYgmxevRoAAF5FRny3i8vj9+oIyGrgZ5NYxA5fZKBUif9Fiwvd9f16CV7mxmRmDDxCn7HeZT/3yWj2bzitYmi4vSs04KABzdZZDbnS19d5sG4M96q6KH9HeyoXo8ZfarT99JFaGzUfkrd4se2UcFA8bzpd5Z5yvVrdYlQ/jKElW7HAYAaSvlGJIE1Qy8nCsJ8E201DqSjIB1WTP
 W7eUyyew
 8RW82S8zIKiwWN0V2QWhf4B6pnIa1GQDajalaxKVnlT5cNw2ACu/j+MtL3d8ECRlPVDW4ppLsg8cm/8XEK0uOyiZCUwAwTTWz4fdbPRLhmleBy/YQophFoO7RC7RKILiU2NVlAuRtQ3to4KqvU/owL9AMA+P3M14zXWFTPD2ZwhrmQBYCi+uJ2+8wmyAV4CN5tLChee8m/0Ogntin/LO8RaccxQTuSwjtbEgoVc6aVvG9hrqEsAV7L62StN30ISmrMKlVxdNwgknlsU7o7PDxXnxxpA5Rv+IXjLdiUltVsHnVAFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:03:00AM +0100, David Hildenbrand (Arm) wrote:
> UFFD_FEATURE_WP_ASYNC made DAX mappings eligible for userfaultfd
> write-protection, but the DAX fault paths have never fully supported it.
> 
> DAX faults use vmf_insert_mixed() and vmf_insert_mixed_mkwrite(), which
> treats any non-empty PTE, including uffd-wp markers, as an existing mapping.
> A read fault on an uffd-wp marker therefore returns VM_FAULT_NOPAGE without
> replacing the marker, causing the fault to repeat indefinitely.
> 
> PAGEMAP_SCAN can also write-protect a DAX PMD, but the huge DAX write-fault
> path can make it writable without clearing its uffd-wp bit, breaking async
> write tracking.
> 
> Device DAX mappings requiring huge-page alignment and cannot serve PTE
> faults after UFFDIO_WRITEPROTECT has split their huge mappings.
> 
> So let's just disallow DAX mappings in vma_can_userfault() entirely,
> making UFFDIO_REGISTER fail with EINVAL.
> 
> Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Jingyi Sun <1045704958@qq.com>
> Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 169f681f9849b..6656233d5dcc7 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2131,6 +2131,9 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  	/* Only mm-backed memory can have its faults handled by userspace. */
>  	if (!vma_is_mm_backed(vma))
>  		return false;
> +	/* DAX fault handlers do not support uffd-wp. */
> +	if (vma_is_dax(vma))
> +		return false;
>  	/* Core mm may discard droppable memory at any time. */
>  	if (vma_test_single_mask(vma, VMA_DROPPABLE))
>  		return false;
> 
> ---
> 
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
> 
> change-id: 20261118-dax_uffd-0fb2c6d1c087
> 
> --
> 
> Cheers,
> 
> David
> 

-- 
Sincerely yours,
Mike.

