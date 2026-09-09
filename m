Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAB0C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E586B009E; Wed,  9 Sep 2026 10:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845C36B009F; Wed,  9 Sep 2026 10:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C156B00A0; Wed,  9 Sep 2026 10:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 519C26B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC68A1C18FA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:35 +0000 (UTC)
X-FDA: 85194386550.01.458813E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5286180013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDD4HS0b;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdGQNBbV5rgyR6AC1v+rMzMBWuTn1mX6O2sJk9ZzEuI=;
	b=ZG1KtdGDB5R8zuGoYn10jGa5IHD3QWtxFEMmdauJdSTBmrhcMiHQWJhq30TUYF7lOga4dQ
	3C335Ws9RG5HFBUUUN1v3x3tR05+i4ThutEeNuMk2S1IB6u1XMiDZ/faP7by7HwHK4aJqE
	vNgsYzWiT04ugBjulfkMlrhWKBGNX6o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962493;
	b=o3Qf8sH6GpYYJnVt9s5HgcnoyvSc64549zXUT/1y0X5xDw0Cvbt9eu+OEtK5MZrqKGKI3e
	ku2+/dsfSBPfg2SDaVm8jIwf4pUnerCgd1FC2X8zIdTJktBTRIm8smlLHhoGJjiiTKxWC2
	51hRko/GWeWHIdNzyNEj/Bv0VaOPFrc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDD4HS0b;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16540401AC;
	Wed,  9 Sep 2026 14:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348811F00A3A;
	Wed,  9 Sep 2026 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962493;
	bh=CdGQNBbV5rgyR6AC1v+rMzMBWuTn1mX6O2sJk9ZzEuI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VDD4HS0bFNN/fUrWGwry9H610uhD3sA91TeA2++WjM0PWm+SEvctvTbSwinGPBAqt
	 6CIYzwKk19mN5tLGwhYdyiYErv/wNsG2DdcHKhsu5tjypdIN6ZIyn7zhhliqKylFcm
	 P1wdNHWUBfWUHHFShC0uSMl7Z5/Rm3xMdixXzRJfhGVBlqGngEHoJw1eMd0dtAvGLP
	 tCKQ82vPwy6gbGbgrLOt9FrNauHmAuIwM3BWyOttGSagdd1BgTbs1gEuUKoBYOfp5g
	 cincbrs7xqsl5bROa6us9e3np8OHmlsRbqad2nzkagOha1kq4NOO7SuvrVNWJLNIQj
	 OrAXaf8UfthYQ==
Message-ID: <c33cbd18-a506-4301-91d4-7cee033d2536@kernel.org>
Date: Wed, 9 Sep 2026 16:01:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] mm/swapfile: use folio_page_swap_entry()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-5-ee6d01dfa5e1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-folio_swap_entry-v2-5-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5286180013
X-Stat-Signature: zzkb1t7dy1jke1a8ut8qewkjddqfpgb8
X-Rspam-User: 
X-HE-Tag: 1788962493-122153
X-HE-Meta: U2FsdGVkX1+1D+kJRyoX16+oapReLtOvjUOUJPKQ7Mdq65yhMOAomvYF63KdTeamJp4utvXnxAZWPrArieuJV3Py/vlE02FQqZDA8M+tTzPO4WsbJG/RoBZzhPMO8uTcL0Wj3wwyuoZxa+mAZM0abBBVXzIGbt/6V3p5c3FHBXE7InXd7u+KJ6oWpjLHjeetVXMFc7P36A1pg9rxPagaRqB2iIxFyNgJ7rpKxlgDQVrLtQset1LfZxduFKuZk9g6mnFtvdZi8mpojSiEALlZfSM/mtwl11yBZyOzIVVWrrqCQ++WRKRJ0gy5VuS4aGAWCj3tGs1G16msKAr4CLyxn3opv94JA72/+NQDb3Iu8+hTgqNDrjQi6wS0BFA7ri1Q0QBfF3pCvlyR11R25NoE/unziWjbFXneezdfjgcL/shpoe+Avfo33Z55VLvPgaOj+55Y7xt7vm20oq9ZKod4z3VtJX3URa/6d/Me2XSdWuDTGGrXn5mFNFNHs6PGVRjcUYcwfmQyNrgDqnnEawzXB1DX3YZch54TvqOOqZt0s1VFK2PeBJzBqm4FZYYDB3LcFusJlmL+uNLgbt9AT+KMyEKa3k30UZeM8M2wT/EmNtqSuwlP3HCZEFPQQA3VhP9TLWeWAwuFklJnp/PD1RJ7KDS65FSRsfn1OEANCfU1GWLIKETowI9LMfqhb0Bxtx/UNSpV8pjlM6pmmLNTXmFxlD15bBvWVhexWdIerqB8crFNodNvqfqjULlaBROnH7g9qzUURdjSNBYyzf1Sq3gvwIFNca6NF/m6pTySG9mYpxWDaiIPchiEBjJtRLod0IMZQerSd84kCEIfbDyJIphtXGDkMS0y0E5+72avE09eJ/yW4nIt9UdJ4oQRm0i0w/Rrk2HbNsaAaFG/fSCc51yx+sIsGzi5d1z/4x0Y9I6qfJpdJbpSw5sQpcxqJ0WeoDamVxh0TFIkZKPqrNb7yvN
 D7mglZct
 VO+3wxVB235QBFpfSBjMkaX7cWzgcjI+EiqP1VQ8b99jkqf0PW8R8rRwdTbyeO/JrqzYdt6k3fmJGtr+4/oosrFp+GViJa5E0MjFjyc17pbay2ipZauK0AnEvyVOz3A+VmigbIwSJZtTpOzWUcbZeqoKV0fbLBQgJ2DX5POBVbKkVxpsczVVPxMhHyxbhlUHsgj8BoCe3yunCUqWo6yOP5j188HAM7exnIZDYoodRloFjByF7R2gKds5+GvyNvkTeYe7gVIdoeZiqtA9fPAwfU4SPIkcEUX5COe3itff5W4FflizMXO5+UYFnUcx2qc08dpt1X+7alLj+LjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> folio_dup_swap() and folio_put_swap() open-code the swap entry
> computation from folio->swap and folio_page_idx(). Use
> folio_page_swap_entry() instead.
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

