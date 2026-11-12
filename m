Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA58606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gk7n35q/
Received: by kanga.kvack.org (Postfix)
	id 880536B05BF; Thu, 12 Nov 2026 03:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8579C6B05C0; Thu, 12 Nov 2026 03:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D066B05C1; Thu, 12 Nov 2026 03:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7D26B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:27:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DCA4160480
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:27:33 +0000 (UTC)
X-FDA: 85425787986.17.A7A9EFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92E311A0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:27:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gk7n35q/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anBOo7skxIusRxuUYrRZR6ZmK2In80o3FSHqv4V/uok=;
	b=FquCtioDm9lXDfdig7Ep6LCLW3kiuBxWR55TJUwnKvQdnbwOZFBdrnXFHutHb3N5YAXeG1
	C0n13dRMj0DPfXoGGPRb5F6v1YQtQUXsJkOptEKSnfDXPK71GGMAVQqa+WcmR+ESofE3ic
	dJtP6ci5uxRbc4+hk0MPHEs2JxeF5aI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gk7n35q/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472051;
	b=rs12MariVgfzwWBFuHMMEi8eba+W64c0D1GuYnFZjfMTpUlQvVTOHNP065qTRHWFW0hE6F
	X2elMKDJLwJN16yEhhWfO+YKkNl4qeopYnFyA3cortpfOVoWOjd1xHbv7LKNtsS3Pml7fl
	mti5/TwKGq83FtiB/6XyJgu8GYtvKyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F232401F5;
	Thu, 12 Nov 2026 08:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429EE1F00A05;
	Thu, 12 Nov 2026 08:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472049;
	bh=anBOo7skxIusRxuUYrRZR6ZmK2In80o3FSHqv4V/uok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Gk7n35q/j5Z+w6T3RsNBVb9DiyZBYKFdQ4QjiOe2NWhUI4yStdbyFMa7Z9OuGxsrL
	 eBkm0wVrusupAswCs6V+aTvkeTdlQmYgf4aSPorSOgSEZgUswRmrqsGWKaRzWBsuqp
	 cHF05739MSi2RXCvo5e6agVYH4F6IOIPF9/LuYkQT7w+zdURILFMccGS6dwSmI7SBz
	 lEiBLtTAvGH9cFiaDmoFWLT/JED9ZQz5q7Bccj6zPtu+3LAs6XfTnNiRgGQTe10m0T
	 I+7DSK1425xCvtWZbD301dL+SrgL+LuxZGTNnYtkAZRX18L9XExgUIsfSplpzR/bSd
	 rMbZzoBvXC71g==
Message-ID: <f7d29197-d8d5-440b-98bd-77eea9f9b2f6@kernel.org>
Date: Thu, 12 Nov 2026 09:27:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Ye Liu <ye.liu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92E311A0007
X-Stat-Signature: t3ej6wadp4gyatpj9imqq1qmezbjri79
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794472051-248364
X-HE-Meta: U2FsdGVkX1/m5zDNR+/inXqv1XH+tVHAmSuYlwyJABTlx2P8oHDmirEv7gYW8YAn5klpzxc75i9eqV/gW5km/yCXvwFhsxNsvIXD0cLWm6ZQ5ey20DFwKwpUC3NDzuE3UuuNN/BnZ9Lyjic0rf1S/42DmjoxvploxdBiJ8B8Qba75ZV9Lgn5ZG4jalX1ZzZ5rpRMf8ZL6rPMYRakcRQuaaDE6roFEYqBjQlMerpg7mz7wsFUbPYDHIzv06ld8RjGRNJeoPZwqF68t7nr1HTAt8gWowL0y5+/OmD29qQVIs62T3blHGxsxSaH0BesC3bZeih0F2EtSbdysQID6NHsuWWjqdG0YfmgNm8CTRwpXH4Hu5IemVbjp1Huyx8FMghsSw4Kg45vffdKkq+so0yKN+FmMs8T4QVwS3Pn4SzFusTEU9vYdasp6+rI9oQYHys+VcTdPzaDt497dF0r/TNDLCKy77JcOupd9N2STouWFGD+OxAtO0/ibXZPnmPClBo6p561vVA4g4gqihcqxzXtcTRJXrzgPeoM6dQPnpkSGik//xp/173fAhKw0ZPTUYjGH9339nq5QzZJVtiVGAjHASUJ47+53bFsMSmEkt1Zl5HDM0yQxorPsQ7gY4N6MKAem9CqKGjmGVVSCCjfNHA9m8rNVcjPHy4iL1kKN03DlcNeWSpycaNPL/8aBMsMuu8sePpGih/3X7AVm2ZNTIfWaczzxnr4Z0chgJMzck3wYVcaaVdIjlnvPFV7BQEGv+eGWuDIHXUl1Sa0JeE0exQFrDLZ8fbiMMGbsPAOo5STltEFEdPJnBoDKyL2ZlRFg2c5LjQzCCZrsyslhVVpERkqF/IGWnU9e0KtMrr1yMpIxerMfd9qn+etzFSCPZKy+x0L74YrmCR8NZBNKnjwDU4LjK9h1TbJoAG955Auq1MKgQA+Z3TU23G3oSNdbotqEmi7qPOj+Nesmh0GbeQhtjT
 QsHvBrHm
 ve5Z9mZMLLv2DEH8gO3UA7/XKm6J0xlPF5rPf1CLsUZUb9DoqWQBus/2UjsHfqxplrkq6tAS1BjuephKfZmm49H8+hDbywLPeMe6UduaXM75YfsqT+UWT5K5VWEdfbaPIzsLKesYcSw2LgqNoeqiYhRb32Dm9wFiz9m1KtSHSMhIovup/uhsrv7yaiPPippQJ/mtvl3fxqSER5XKIGMSupMr4lBcSeGOprAcA70wANN8GuRKmpkGG+lasClTRJduwIrgaJMFFF0CF8sQqfzqjO9TFzWj6H6FAnJ8cs7BnHT/e2+MsOmUOWpY0PDW6fp3PSa/MPvW1JE861k2cSA9g75cOaPn5APfmLSYP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 04:19, Zi Yan wrote:
> __split_folio_to_order() calls prep_compound_page() on each new head page
> to create a compound page after clear_compound_head(). prep_compound_page()
> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
> and frozen and no one else is supposed to modify the folio's flags.
> 
> However, code calling migration_entry_wait() can reach the folio by PFN,
> then access its flags. It is because softleaf_entry_wait_on_locked() used
> by migration_entry_wait() sets PG_waiters concurrently without taking a
> reference and the frozen refcount during split cannot block it. Meanwhile,
> __SetPageHead() does a plain read and write, so PG_waiters atomically set
> by softleaf_entry_wait_on_locked() will be lost if the set happens after
> __SetPageHead()'s read and before its write.
> 
> One example code interleaving:
> 
> CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()
> 
> 1. clear_compound_head(new_head)
>    new_head->compound_info = 0
>    (page_folio(new_head) == new_head now)
> 
>                                            2. migration_entry_wait()
>                                              softleaf_to_folio(entry)
>                                              page_folio() -> new_head
>                                              (not the old head any more)
> 
> 3. prep_compound_page(new_head, new_order)
>      __SetPageHead(new_head)
>        tmp = new_head->flags.f  <-- load; PG_waiters == 0 in tmp
> 
>                                            4. folio_set_waiters(new_head)
>                                              set_bit(PG_waiters, &flags.f)
>                                              enqueue on waitqueue, sleep
> 
> 5.     new_head->flags.f = tmp | (1UL << PG_head)
>        <-- store; overwrites step 4, PG_waiters == 0 again
> 
> Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(),
> and CPU1 can remain blocked indefinitely.
> 
> Fix it by setting PG_head along with other flags in new_folio->flags before
> smp_wmb() and clear_compound_head(). The remaining compound page metadata
> is set after clear_compound_head(). In that way, after
> clear_compound_head() makes new_folio visible, nothing overwrites the
> PG_waiters from softleaf_entry_wait_on_locked() by modifying
> new_folio->flags non-atomically.
> 
> While at it, use data_race() to suppress the KCSAN issue reported by Ye
> Liu's patch (the second Closes) on reading folio->flags in
> __split_folio_to_order().
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Reported-by: David Hildenbrand <david@kernel.org>
> Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com/
> Reported-by: Ye Liu <ye.liu@linux.dev>
> Closes: https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
> Fixes: c010d47f107f6 ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

