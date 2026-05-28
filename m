Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B64CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFBC6B0092; Thu, 28 May 2026 13:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6600C6B0093; Thu, 28 May 2026 13:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576A46B0095; Thu, 28 May 2026 13:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47AD76B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:59:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09C94162160
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:27 +0000 (UTC)
X-FDA: 84817590774.23.0A748A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3AB8D1C000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WABDmyaY;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779991165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkmpRH9UNpSvrtaG0hoUp63QJw6OttsyKLxOKt4UekE=;
	b=CEPDb+s7UkYKUMqwHKmir3534U4ejk3eBxVNCNDGqCD3uk9tDL2yJeu5oPq3k7BrD3VaOo
	g6PKaqYskHThW1l3xZ0b7kz0SkOObYz78arBT+CWtoE9d822oTJTlJRcaNFFSmMxrvHyRR
	jTewIz+bbFzpdhhq0/hx3WUClkyCa3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779991165; a=rsa-sha256;
	cv=none;
	b=VDWxS46RpAvSP0AFappIXqf8ZFmlsMMtdIiwp0W06e6nzvYxXUNaaXEjKJ9UwMJXfzEH5R
	XIPpX7FPtOwmX3pYPmNRBskgzfc+QYCyKUHf8G3IepMVw29Yi0IdmM0HeSuu4o9qA9lYSr
	uYlfzlZPPrYxovqhWJe74GyLQxRA2Jw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WABDmyaY;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B70243961;
	Thu, 28 May 2026 17:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB31F000E9;
	Thu, 28 May 2026 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779991163;
	bh=lkmpRH9UNpSvrtaG0hoUp63QJw6OttsyKLxOKt4UekE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WABDmyaY4CmqSIRKitMqyYR4m7+sNSlgG7XnwB2ueRz+whknEeVOr93I+7N+OoMuI
	 U0PvZATRvkrQNcdnXDsg6xaOq1Q4n1XppsNXR4+xUrgDmuUhdvZCpweNUHBe9X25WR
	 mg8rTlHac60MKJPEQWNREo5vPGfap/q+8HnyV3+XzErx0kNbjJN3o9En6K7Hx4uZ6k
	 gcFU+JJAv+gCFdZxftU53M2g+tCwIYQ3/wOr8f+nPIb2Ug6XFcfFgNIOd+2UKqFfLW
	 zLazeHbFSrOWtZiZ3PBvOyGd4esgjgC6bJTlTKWRyHf1EqBkiyI9oGzoYLUkFonOOD
	 KMTsXLHvz9jkg==
Message-ID: <61a25965-cb89-4a6a-bd69-16a467ce84f2@kernel.org>
Date: Thu, 28 May 2026 19:59:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/slub: use empty sheaf helpers for oversized sheaves
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AB8D1C000A
X-Stat-Signature: gg6o5a57mmh937aj7yka4oqkp6rr6c5s
X-Rspamd-Server: rspam06
X-HE-Tag: 1779991165-655150
X-HE-Meta: U2FsdGVkX19eRJULeBRAlGq/mUcTC+8UGXdbLRwQd/4ZOyXBee+oLe7+oo129d9f25HDX0KxFgW/Vcf6jcD99NLmfMJ8oQpditM4aI4KjjBDyQm4FxRmS00eXut+3k4k88gNrtrZIkuAi64pE1tRjC3+1HXm0HUr5vERK9V48NIQAcpLO4PSPpFHcpl8W+UgONjNgODlF7Kt+XhqONygdhiFg3FSeA4YU83ZsUiwjNDQwE1hcFwgPDACaOl3LzGQpSvFAG5PkewSYzCwBL5iq1o8++gS74oNHp5NtL6kVTLfaV8i/rjAb2Ki+4WHw8guvqh5k3A7lpP8oLdH/v4S0T3dQA14pHjxInUqa1ugZZWr7tB/Uuu406jRAfsWucb5iFgN2s5X+15E7QLJkkOn15EWfTEzYKLQtavOJ5WwXctseHdi8RiUphMOEjwcsJzFbwjxJrvH7TZkt4cXnrbOoBWsYFYLNptbIpWHPkn0MR0JhSmEDalvXw1lcWwM65uuAOorPsG0TbXV4pl76cYaazPb8n3nSi/iSnx4tDONXgICRNOTT5XY8bd91JmspKuuWpvcfwESBW9E0A/mw/r2M4p/lbNV4en1ODS4ZrXDODoza/41KkJCJB+c+zRanDuXYFzfXk7USCCUbtN1+GqBQLw6BAKcSDuztHbxkYcfX2qQKSAwiTeXafObp7VfZ5pvLeQTbv7eUsHsKNVojiH4t75dJGXmv+4lO3tVmGVJHlAWwwmNUMP2x0Iz+79A1vrPcCqvrF4ugTNyXQmRjIQjGOAOUQJUCGauwHTbNjv49Sg53XIsws/YGdgsTX7zHDj7I7qdBMGl+x/8SftIXudqzZVwoWmBj3dA3soLSHQQX7E1Nbt9PWeu23IM7oW1KXxEvnZUBhDyV3D5Kix8Tx4LyObwZB1N7uqXDaSxCQkGs5aRunzP1rJXrYLZc9UWbxNK+HYMHnICaKx+Ez0tJrx
 1TpA5AGF
 iErQy9vjWo3gN8pEXlMvMsUlvaabmjhrd5ArrUKfKPqf+WynqpS9Ib+B1LPJUF5Vyywz76/qg2iMIEdMhTvahEzmGuwAGjQFmX7H/h5FDxriEvYkG1Exk+Hy8KCRzZ0GyWiDV9rgaMYJyWaFMxr8ov8fSAmg3c2fXgTXp3yXazz5KjH8gT8Z8JVvHrT0vx2jQGomiToCM7LgUpejmap7JKYQm5o/AJXH2oin0heDuPtZeJ9B5bVsus3AXU868pleExfm92T6lDJBp0MYNuDu4gUDx6NeqEpM/HcoGRi2XCLdjf3vKA0MCqWdblTrPB1QFdPXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 13:35, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Oversized prefilled sheaves are allocated separately because their
> capacity can be larger than the cache's regular sheaf capacity. After
> they are flushed, however, they are empty sheaves as well, and should be
> released through the same empty-sheaf helper.
> 
> Allocate oversized prefilled sheaves with __alloc_empty_sheaf() and free
> them with free_empty_sheaf() after a failed prefill or after they are
> returned and flushed. This keeps the oversized and pfmemalloc return paths
> consistent, including the SLAB_KMALLOC-specific __GFP_NO_OBJ_EXT and
> mark_obj_codetag_empty() handling.
> 
> Keep the caller-GFP filtering in alloc_empty_sheaf() instead of
> __alloc_empty_sheaf(). In particular, do not clear OBJCGS_CLEAR_MASK in
> the raw helper, so the oversized prefill path does not unexpectedly drop
> caller-provided flags such as __GFP_NOFAIL. The SLAB_KMALLOC-specific
> addition of __GFP_NO_OBJ_EXT remains in __alloc_empty_sheaf(), matching
> the free_empty_sheaf() assumption.
> 
> Since oversized sheaves are now allocated and freed through the empty
> sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
> sheaves. Update the stat comments accordingly.
> 
> Keep the capacity initialization in the oversized prefill path, since
> capacity is currently only used for prefilled sheaves
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Thanks! Applied to slab/for-next


