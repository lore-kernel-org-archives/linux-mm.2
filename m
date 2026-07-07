Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36131C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 05:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EF56B009D; Tue,  7 Jul 2026 01:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1202D6B009E; Tue,  7 Jul 2026 01:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010746B009F; Tue,  7 Jul 2026 01:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C73EF6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:03:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50E1A8CE40
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:03:59 +0000 (UTC)
X-FDA: 84960788598.27.607B38B
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68833100003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:03:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783400637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6RzR/pMgepW/QEzSHfK1nzA/aBBle6WMwTm0+/8k4M=;
	b=KqepqTMkoSlBJK3Ph3w4Hsp+1gHegq8XxzQ+nzxNet8EF7MxpZABu93HTS084ZbVIgyNjy
	L+LIC7MIFFE1D4wXiwBQeazjuJhk7j4UkuXci7jw8Gayqisct7nSAWR4Jy8dcGj8334W4z
	M5fgDWZ66LEIytF5a5RpNdYRUwEycgA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783400637;
	b=vnb39IUSrosX2BYZPtV14qNPKKIObsxeKLRTaM4+yXK0RUqpGtGcaY7WfgiZGgkiw+g10n
	0auQ4hZyGEDgoDBVDj9EOlYjWo31I5zX+FaNr7BjvnJih1CmeyPM7yFICPwZ/97aTcQJm3
	KkUMezbNXrtjOi3eU/h0UfIKEuQD3Mg=
Received: from [10.213.6.103] (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnytKviExqhn4OBQ--.11100S2;
	Tue, 07 Jul 2026 13:03:44 +0800 (CST)
Message-ID: <99eac2ba-a4e5-4885-aa81-b0c43f6fc4b2@iscas.ac.cn>
Date: Tue, 7 Jul 2026 13:03:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
To: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Muchun Song <muchun.song@linux.dev>
References: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowAAnytKviExqhn4OBQ--.11100S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtr1fJr4UZry3GF43Aw4fKrg_yoW8Jr47pr
	Z7Can8tFs5Wryayw48u342grna9ws3t3y8JF4Fvr1j9wn8WFyjgrnxKayvgF97u3s3uayj
	krs8u34DWFyDZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
	8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F
	4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUqP8nDUUUU
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68833100003
X-Stat-Signature: kwfc7t3odww7squ3ntiqte4o4f7z49ax
X-HE-Tag: 1783400635-11279
X-HE-Meta: U2FsdGVkX1/ttbX92Bhs+bp7N7J7uqF2zW6eMNC71ISoCwVXCALbGqsXHhs8/PRwq7inBit3HDAhgmbcYZ9PuyYLrPKW1WP8VJQZelVFn1j5CLDCkyOawVz12V33ETFws95ymG+c2k96Hrjaqb8/RuCtvV5RV16uJlqncQavDOur3T2wBqQhqciiXznRkyZfTF8SzG9kEylfyVbbYpXeCNlzHn6cPs7rd5KF4QUU2kiATKoVQzwM9FJZy3UZ0aBQHhdSBpaRk8A3sEySVW3+g6p7E3kFAHp8i/p+TPvQDJJlLKIJg43xxAury+Yc3elR8bGGUsr01OWNvNCfH1fQfZI6o7BlMEaCutKxtcV2zvkN4pBap0UvMkQAwxrBW0QOyG+Dm3hEW733bdlhXFjjZgufa9KXQQK6WADuvRIBufuD75BLEKQlulSftN16g/J5Xz5uPcwH970Er9e6KupBzt47AKPznN1rFi0uLkINUJORh8zNFSRt8FPX3N9jFVs138misAfIN4rr6BuDj8x7W9Lse3naan6Nl9VwxUhmQRKG7/H18K4/uKsZPL9vXEA/DfGz2/JG3QBRZM8YFj1fgULqhiKg5cbVyeSxIN0/EI9aEJp+yX8eir4wrsTPXgKUeq7laVK/DII/49BzX/HpfZZpXaRUg2F430eclacFRoJZgjS2P98vEcgkKS9F5A6O7LZf6H4QlZlNGETn0we1uj3bnhxan1bY0ewXLCm0NF5hs8h/z1GTXuzldsW8lg/WGzZCyF7iJZ4FX5wIsx9TtE30NK84sb4zZXqpIAvjXZTXQcGx8Acnn3viWtNWEPftOEL4IO1PO/zFvYYdFsyRfFevQr0JfntV3piHeMamw7j+eX2JbaSB9UibW9xMv8gBjdeQ67Mi2sOq3bUKhjlWq5vVX9zL1LHOgOjr9UyKSqPAwFuS9p6Za6T+b+tt5wjmTcQGuPhDtbtHngW0blP
 OAGjY/oY
 t7v9RugHz93cvuULm8ypQRGrVTVrdFs/x42r7V5aWSuvVWcOT0ECO6JIv3h9yYSwcA9lwMH3DVW8pcJKzQJGrvlEkMbuKT5YFffhwSaCQGXzeY7yvtgl4qhEEgySku+Fq26D7HGW/h9oM1NPGpNLUv8owAfDmOR+2hg2U5Td9RuXrmGLs/VpZtRyjYULJcLivCMdx1Vs6cEtNvm58DleLQHgQuxd/q3qbIYFMfey5F2IKryp9atBcAvJL5OioDfOrq/L9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please disregard. I made a mistake while submitting this patch.

I'll send a fixed v6 later. Sorry.

On 7/7/26 12:10, Vivian Wang wrote:
> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
>
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
>
> Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
> and call it after hotplugging vmemmap, which gets the possible spurious
> fault handled in the exception handler.
>
> At least for now, the only other architecture with both
> SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
> problem with newly valid PTEs. But there flush_cache_vmap() is just a
> ptesync. So it should be safe to do this for generic code while having
> minimal performance impact.
>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
[...]


