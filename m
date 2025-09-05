Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67082CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF81D8E0001; Fri,  5 Sep 2025 05:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF516B0007; Fri,  5 Sep 2025 05:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97468E0001; Fri,  5 Sep 2025 05:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 966126B0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:40:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4479B140423
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:40:50 +0000 (UTC)
X-FDA: 83854702260.25.03BD63B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id F040018000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:40:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c9eeM+E5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757065248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QoVoPbILYJ1+I01JkZn/InNWSrN6NXwr249ONpvW0g=;
	b=Y7oTTkqU+a/xY3y182+El6wLjgKB/wMMUVeeufXs6tu9NB78MXzoV+CfXpyRaZW9lrtT08
	WWrgAz03aRgJGFzOk2Fz4/+gz1IwCLauLPDOGaU+HdiK4fdfcfp+YV6yWpbl17k8yEEFJg
	OjJhLMx7Mmn5JBJvPWTSOP2KS6f1O4Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c9eeM+E5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757065248; a=rsa-sha256;
	cv=none;
	b=gAMTp0dxDht1CsAgmwRi1s2E/K9KEJQmkgezZ1sfyRMBm3AX7ePI0mfJuuoDA1IhilpIbn
	CRIq/I2liyDqsC4HRaE1BlftQjQZxr2G44kzJgs4WKEDTitkRxPYHKUcpaE+eVTNlmDK1l
	Ip4h3jzPu37Ki46ZrLfFPhX1R7akue0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757065247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1QoVoPbILYJ1+I01JkZn/InNWSrN6NXwr249ONpvW0g=;
	b=c9eeM+E51SQx23WrE54xtxwm/77TWdEeKSvOgxMAPCKgK/4vj4ZP2eOeK6ZZBSPbbxTqXk
	x/n1Lk6Gl+BCjQZKd7BHtH0GfjnwCOCeeYrElhhPIPlu2vTfwaLA8cPE6e26TPpwG8jteD
	27WhfY56xZ9z6upf6MxG0dPl/y4WEgA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-dpxSBRi1OJSHVEP7czyR5Q-1; Fri, 05 Sep 2025 05:40:45 -0400
X-MC-Unique: dpxSBRi1OJSHVEP7czyR5Q-1
X-Mimecast-MFC-AGG-ID: dpxSBRi1OJSHVEP7czyR5Q_1757065245
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e26569a11aso865392f8f.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757065245; x=1757670045;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1QoVoPbILYJ1+I01JkZn/InNWSrN6NXwr249ONpvW0g=;
        b=Lqrd2ov4oWq0EC1l8muANPUNB3W8d8PXxGopsco5NXF3CPGmRt2uj19K9ifFhXrBOf
         Y+JoxQGWK12ikPqZ7KYFpY4v4YGiSozjhjY+6jDzTbbgAEk2/VoIraGy4ZXvB87u03Ki
         n69NFY+XR0Xv+Xk7vNfPAjDnm0yKpBZIXfCu8e7ZVxXpy9TbUU+vUq3xNA5wcVL8erAy
         K2MD1pnkm4A/ih7ijKvirUJBiyUGv2gbCKEXhk3cUXYbLwabpLDVpbL9dRaBJuXIqRFM
         V0q6mvjPYkZjLTmQvbz+SQ+bkAqKroqQiUHFTIFhrXixZwTfGtHap6ijZz2YaH3wdMBB
         fotQ==
X-Gm-Message-State: AOJu0Yy96b5ENZ7BDRnr8/i76DQOXSuwjPyBYoS7ES4F4I3a+DlLXnxl
	hCmg3yB119IhX66501Gx1QRJrmdP3ly/mdmVGXSMKGzgeYbCLvZE3QV7A4uaDCN8Lr5PLdFONrL
	tfNORESWu0E+iYyl9bF642MO7mBgP5j+Vr74QNge361fqPQdY5U5bOffJE7iM
X-Gm-Gg: ASbGncs+98gqJq9AVx2i4hEJJedYh/b5KBnIxYs+3+qmas5f8lOUtRcvov3VqKN87W/
	O6okbuagIthKoXGNnNo1PavAkdBi+DK3STg1knRG0Fv4XOJUXc5DDrUKs6vxkguYp6kdE9FkVbA
	Oru2L3CY3jWUaFI8ehXsvrpGlq3NZ7n9HMPh4hnHht7qcB2zY5kjZVsaYM1ABTdjn+jEF0gKnFt
	wHASfwFUxw51t042+H2Bz73mQwzdwCcJ1OYDB916R6l3T8iNlJ02C/cWF9bZhs1oHsS2PJpIe7s
	awPQaUJap5ek2Juj+mjxUzKlyGHmNy4s7ROBKqWjBQ1Gne9w5va//WcFlLzZp2UD/ibOzvq04Cy
	ndlLF/E34rk//gdMtqjPUkxxec2xU8bNq5apMHEduGLO3RZfRKjbdT9lu
X-Received: by 2002:a5d:5f93:0:b0:3db:dd47:b5e4 with SMTP id ffacd0b85a97d-3dbdd47b6femr7470973f8f.2.1757065244632;
        Fri, 05 Sep 2025 02:40:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsEQ7vYPeoftKHjOSmlOOsaI4uHVEvtZaUkQ+0CW6oWuN5Sl87AdayqC1r/YqNS2f0lL3kuw==
X-Received: by 2002:a5d:5f93:0:b0:3db:dd47:b5e4 with SMTP id ffacd0b85a97d-3dbdd47b6femr7470953f8f.2.1757065244155;
        Fri, 05 Sep 2025 02:40:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd063fc8dsm34549275e9.7.2025.09.05.02.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 02:40:43 -0700 (PDT)
Message-ID: <83f5643f-7a6f-4954-a989-4d76a206d0a9@redhat.com>
Date: Fri, 5 Sep 2025 11:40:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: check the correct buddy if it is a
 starting block
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20250904020654.28689-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250904020654.28689-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: irkwZTENLDOFgwykWj2PyHS0Rd9Fk1BwCXHU76rveYk_1757065245
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F040018000A
X-Stat-Signature: qo58c3q353qz98a6s5d6wtnbfynwq5op
X-Rspam-User: 
X-HE-Tag: 1757065247-5723
X-HE-Meta: U2FsdGVkX1+DkbUsT9gK+cuywlmHkhSXCn4J3Bwzu7n8tgLdKu/wB5wZDWnDZnH85EJqYkqpeLejp7LQfDwiIzDvo62tl4ae7aEy6mwFcRJC5Y9Ez1gOlbOc/CMzUG/hDK1xH6sfGxCGua4IqIcUKSWbJzTaAdX4EQKgH4lOcecvfamaU2R1rl/HSQdlbQa7BKGc1fkJOFnnH4ji+8WIvp6xXHKkDQdjJ8A84JzIz4d7ERzeC2kGeaIrAP+RMNV/0lbUFAkNUGtKcE0TGn8+CZs06IQuytfHQdgynv7pgZPHq2VdDJXzw+LIcsLhTE0wsan52l+ps3gtoFWpQ7N0lw47ALh7EX3Q71yIt+XZiO3H/IA4307/iCD/0/To0c//eNESpWHoupU8qENVzJSSs1gjhyz+WRpoaFbF3yLkZw96A5CixYAstFS9ZbRR3mdMUGFA1TbP22awFfkqhc+/h54Tl2elVcNjp4CR2ZsxiTm3IcHOvmGTbgncHmvfjrDFDnPgWACs2O+bT7zJizlU/+VEmbw1ktL5YeoUJy2dne8mwka8KOQ0Dt060PGiaqNFaxF4g1fXcqLem+uKZpfQRRhNobKmki0VcvC1zrDhEQxBgp3+lq5PV8xwPvXMjkZlmKPRm0LtZVa2dRI++Eziy+wtO9Vb+BzpNBZuB+XDGef8uvTeeB7zXbtQJqO6WXi+RFm+wFFMnWDglqSuLlz3Fi6nvJyw5EXN88QNE/w+/I2jiIZqblZgHo8CvqQnI6LGhsfB1k+JIFQZRlGbXi+wNKCRSrRJcrQ9+OB6EzZ8gTc3bEIELKpeYhkhAYbhk0vQlbzYzVhTYRCalGfzz15r0jWvEigIy6FiCrlk3o7td+iAS+tKuQZG8yuJfOQOvTGOapSyNwllt2YxA/mjqIG8d/wCWNnfu7tL+Vuvpt2NGlakz5svTRBeOGJ0zhVD40FjZqVEFKaHe0BFRKfvGrl
 55DFbt3h
 yqlhJMpwyki4o0gK9D6S7FpkXFawrodMbsuQJ0TuspOVdCsrF6HLs4WU9WoNlwHYQ3FFVCipYruMz8z6xJZ5dLf5u9pvjffwAbokqL4oa00ZgWt+VW+mi95ByG7TeMSpT98UJZPeVFJQtENs4nC4ZgvjH9gDa2l2QTWnk2GBqtLCWTRi/q4DeDbl8lRzYS6YQWibrmzvCPCOtk2QliH1V812nBCa4nKkk3knQov/Gdzw8S7IpqMLNXSKYYkJUwQMs8wbbpYXRwx9lwB9F2hccc1jIemHslMJGAqR4xA19bfNe0hqCLMGXqa+Hh05jWZm2a960xNf/SHjhKAJk63RIR0g7NSp6aEI6IA6EEHZoVgBpR5cR47g06U/z2F7YGKkD/ldbdSyPJvrhi3gGQ6k7OnT51Z8dvrrUTznhE5A9dv/biPQY3CCW7IxbMBTHTAsOp+Kl/k/sRYGLVfNN9hRMaipCNaWva0isko5bfMR06VDt9bAK1MfjyZNAL8gk33XJYEORVw+fmmF49hQFJje8UXZmRBrZvGcvsIN3z+b8NdXzWeJVe7r0DW0dh7GkFBdHyz0scUOAuq3cMiVJqFwqLVAfBd5g34y95MGb9GwtzSlpoKqEcVNA3Dl3m9tRzvQMLCfj1AmUUuHMqoAn/w3D0fuEv7e3jE8xwqbZwcKs5bDG6emm6LHfCW6LRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 04:06, Wei Yang wrote:
> find_large_buddy() search buddy based on start_pfn, which maybe
> different from page's pfn, e.g. when page is not pageblock aligned,
> because prep_move_freepages_block() always align start_pfn to pageblock.
> 
> This means when we found a starting block at start_pfn, it may check
> on the wrong page theoretically.
> 
> The good news is the page passed to __move_freepages_block_isolate() has
> only two possible cases:
> 
>    * page is pageblock aligned
>    * page is __first_valid_page() of this block
> 
> So it is safe for the first case, and it won't get a buddy larger than
> pageblock for the second case.
> 
> To eliminate the ambiguity, unify the handling for starting/tail block.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> 
> ---
> Tried memory online/offine, which looks good.
> ---
>   mm/page_alloc.c | 17 ++++-------------
>   1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5183a646fa09..453cd361386c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2093,6 +2093,7 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>   	unsigned long start_pfn, pfn;
>   	int from_mt;
>   	int to_mt;
> +	struct page *buddy;
>   
>   	if (isolate == get_pageblock_isolate(page)) {
>   		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
> @@ -2107,10 +2108,10 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>   	if (pageblock_order == MAX_PAGE_ORDER)
>   		goto move;
>   
> -	/* We're a tail block in a larger buddy */
>   	pfn = find_large_buddy(start_pfn);
> -	if (pfn != start_pfn) {
> -		struct page *buddy = pfn_to_page(pfn);
> +	buddy = pfn_to_page(pfn);

While at it, can you please rename "pfn" to "buddy_pfn" ?

> +	/* We're a part of a larger buddy */
> +	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
>   		int order = buddy_order(buddy);

Yes, I think this should work.

-- 
Cheers

David / dhildenb


