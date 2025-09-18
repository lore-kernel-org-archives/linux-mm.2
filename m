Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8ECDCAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD428E00F4; Thu, 18 Sep 2025 07:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E368E0093; Thu, 18 Sep 2025 07:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2457F8E00F4; Thu, 18 Sep 2025 07:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC008E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:30:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4861160153
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:30:46 +0000 (UTC)
X-FDA: 83902153692.16.9D97314
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 069591C001A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:30:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X5XJO4wX;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758195044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBqPf02a1oTGK+tCJbE1ES/WnQGlGEKm2G2y16LpUTI=;
	b=Ie9yFbmcwolaDB8ccxFZ2GqZ8ZF+1ZHWqMh3uVUGoQOayID3u/04r2b0avAqtd52QaeCmI
	JKHuPB1V/zhZN/YRc3pKqzmGJk3XYnWj+UhX7WzMUD2Dc9sAoKVX1r6ShsNOxOH3UnVleS
	3hl9s1c9TJbQvDD+Q48yHxZYfvEwrRI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X5XJO4wX;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758195044; a=rsa-sha256;
	cv=none;
	b=YPYA4xTaRKIfxk5Ho0EJlDHV6K9+6AI/ZD+gjQV8OJhlLCqWhnQnNAES2e52vkn0NnwWhJ
	Oc8GL2e0k0J9l4zz3F9IqTiWlwZvXgCu2OM6VNyDCKLfUXZLoy1aUrBiKenzFT9EJ2nwbW
	XczTFarsexoLUJn6KESJmjlHf07CvEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758195043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pBqPf02a1oTGK+tCJbE1ES/WnQGlGEKm2G2y16LpUTI=;
	b=X5XJO4wXVII/p9stQBEBdWXtLqd+lRJHFbO4IE0+VZLXyEHsSEwXWFzYEXlBJ6533xKoQe
	taPkGjS093uySOdiTJwgUpFJMxArHDUrQ9PI6xgOBQGxUVZgjpdKmh3pTj1fiYCd1Q9/41
	uexQE1NTqbBTNXd5yD+sjDcBDsrWs9E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-eiAcemP4Pra1UI1AGy8-6w-1; Thu, 18 Sep 2025 07:30:36 -0400
X-MC-Unique: eiAcemP4Pra1UI1AGy8-6w-1
X-Mimecast-MFC-AGG-ID: eiAcemP4Pra1UI1AGy8-6w_1758195035
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f2f1a650dso5808695e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758195035; x=1758799835;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pBqPf02a1oTGK+tCJbE1ES/WnQGlGEKm2G2y16LpUTI=;
        b=IMXlgMiyBE6157gJ766Grtr4KusznePxDV7zhNKm+5vNXkeBtzAwPRByP/lkGu25r/
         WsltKI5Zn4lr9uuxEn5YycimY1iVheco6cFHvUZ7rgnYYqEd9WBisU/J9UqCcgWVlYBU
         1rHHDpujRGzxbXXYg3cKdq2ydrObfws/akS5d1EFvywgA/jPlbWeVzeOfwSyVjBAvt2i
         jmYAu9qpRZYHQDO6rW6pF4XBCp59sjPTBm/R0w+f/SGoxtibq9ztVu1RS2rzyKeWUM00
         FlaSCayIXE3b/atIG1RDPUwa5qYOfgRJkh8fZS04XFfAW8CtnVciJp+qTIWtsEks3XkZ
         U0ag==
X-Forwarded-Encrypted: i=1; AJvYcCVRaeFOmRwiZZ1UH1q7USzkJqDK5lyeOuVi6q2L+EzsqtJhcSiZK/F04wF3bq07dnEJxmshCvARcg==@kvack.org
X-Gm-Message-State: AOJu0YxywnYjew3RqvEF+RFojZPt/a0b4WCaGNOR8ZjZAce0UFmjOyyD
	uYqjP9nFlAZ5/bn2etiDh9Z3OgNPvWUxC7F5fh5gHopvyJU9D574ZySEAYsL2EEChhS4p9PFHTB
	JsHviXnQXqlnlGz1b2QL/oJz9A6NkVVbJYcI2xwBFjj42mgp2GRG5
X-Gm-Gg: ASbGncsxle+72k/Engn3rEAeL5/P/eHa2hGjLFRgcrUD2bIYgtOdo0+fS6sNsPej/7P
	rYiyOmRO/dK/P5feRCAt74ZJ/H8sHJm/sfiBPG82VkMQy4KjtMpT10hYRGYgUg/+M9QQQ2pCTdY
	vl5PF8BVG/KrsXMCMcGCTHS1LpDkOX+ciZ2jhG2FLB6GP4uPbAqh410bmWXxgPhpHl9+Wp4ZrO3
	sPMQXTnu57kYNtmcOvVlGWpLDDzpOEHd8Z8LJGBg671UOMFvdyFfkrvG8AiYdPsExSGxZo6uujS
	E0GkI123HaUOKKA8jNndu5LektXnNlBaq2aeJpA826p+6r5AmGmZdSC+RHRxKoWKBV1rnBqF6lH
	2iLX80HyJIsspAGqZGcg6are/mK364HBPRu+NWGUhX/FeDzekrrunRp1fZMzwM4gLIAPg
X-Received: by 2002:a05:600c:8b5b:b0:45b:4a98:91cf with SMTP id 5b1f17b1804b1-46202a0e941mr53963125e9.15.1758195034887;
        Thu, 18 Sep 2025 04:30:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGD9aiGVd8wYPkpij9ydkBEiOHOxxDrIOX+4KKE+0QofLHzUS5fuCtWvKkqly/0tsK+aQgr+Q==
X-Received: by 2002:a05:600c:8b5b:b0:45b:4a98:91cf with SMTP id 5b1f17b1804b1-46202a0e941mr53962745e9.15.1758195034398;
        Thu, 18 Sep 2025 04:30:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f0d8a2bfsm38316155e9.2.2025.09.18.04.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 04:30:33 -0700 (PDT)
Message-ID: <6e6f596a-1817-45d6-b674-04e8aefde6d4@redhat.com>
Date: Thu, 18 Sep 2025 13:30:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/fault: Try to map the entire file folio in
 finish_fault()
To: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
 Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-2-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918112157.410172-2-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qcE3tDNTr6pxO97uBW4sn6sA6XDBCRj09UFah-7hRk4_1758195035
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 069591C001A
X-Rspamd-Server: rspam05
X-Stat-Signature: zgk5eud7srsbqnqyc35dcsya3zcamow1
X-Rspam-User: 
X-HE-Tag: 1758195043-852949
X-HE-Meta: U2FsdGVkX19ZrIwTnoJctkuBOIX0IdNFezDb4kWAA+wXhi7OuwWxx8bYmIMOzP1mMnWIXVnPOe4p9d/ZJG79JJ2l5DHTv3aOADJ1ZmcQOrQdEfMtW2nP5RupmgBv0G+h92H99FKMnbKuL6naWwjQMk0asvii9KYK6dC83L4LGKaBOvlUwSXO13DZMBoBa6fKS52m8Lc5iI3vxDQv7ajm5S12LXGpHqzDtAyagXkEfWxGEGzoZhJhBf7xIgIH/2wSCM7JKnOhFQGZtqOoHsD/MG0crL5aQV4JwkT1ZDmhEvlsczFHgNzxWbUSg3vzqVSYPEmEwLl2002O5vKzVZNRSj0OP20B8vmqwHZCoOzMy7f4VesSu7yMpd5H/1VArOpg+APAwk/1TV0bevuUooHbQaWSL91mSjQmjyYftM7U0wDPCYP7jB45ULVI1qEuSakkS0oxZM1uA172Zr+V0xDhDifJtHOM0PC4eduY7jUqb4ibgt5kVrlCEi+zOdVYt3cdxwh4mlJh9x/NfAFg+2nROqdTJDJOb5dyQ0CxQzBDUxaAFwPWoldxwHjCxh4ZYObkl8q00YcZ4x88s/FIe647qaLznaIC+XF+rA7wAeYHzc8XNY0JcqMHGMpiUc65KfVHvl2mZ0ieAiEmpFGCik4JFU72P3JXNZGVHfz48WCJvWOEZrKPA5iqe1pBI4+D4I2X0182wugUb0ZaqCYvwamAxzYwdXSB3N4fd4I6rH8whi2Q+WD8ScEQONZsc3jLt5jk4no7jHlRhW8qd9CYs6AHl3uMZL0nswD8B8e66LQlZivBE4Q5GlCQYViUO7GVhszuyl2uXT8d7G6G87KTkq85/hE3dn3Zm5RC9HeQAM3TzwhAGHaQEYkGfXvI0Fg10WBWU6rk55LVd+aeZWjYzx8hLYK/6Z+IcJwJgbW4/Pat4iDntEfR+ipUNr1TISfXEqekBQ/gIaO6nDQXsZK92Jv
 sd7bCi6o
 Hg9DPSVFmjW2pzY5q7bbGigQ/Hom1oMsMk/uChCiD75p6t7ykhS1H62b6QeNaj8seSBgc0hz4nw01ECDcpQ3KBSIRmhvZeC1+Rie/dsk4FmoQucdXHrhw/Mjw5mBMX81AY2JFU9oR9Fu9TXazQXDFNsZNOJJSIbFFO+dHTKYLOii/P0vKcGR4OgnNYgMrISc2uNGSol8UIXck1+r2G0rgAhmfajCFapWmXuq2/VjXn6fPpsA4OOt8EIt9QC0B8wM3IM/VM1dBA2ViJlSpfupnfC089VV/UG9Uejt0mjR68ghFka33iA+b8uNdH7kNCew+BviIEidzeFiS6ZhmKfLQa2cuqOTTFjt6b6f7k5O5KxC1+Ou4rxQVCYrVsuxqB5iIs2ufEvY4+nkK4TgfRL8RAbceTdhaQxU1RjVXQcz44uuBmIvuITeyhVh0YqV9y4hCyeqjdX4qkDi2gPxYTQr/AQ+849nqhrreOJDzavW62CyV8MlX4UzUOHymIEh2HbcEo5P/drISAzvG7I0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 13:21, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The finish_fault() function uses per-page fault for file folios. This
> only occurs for file folios smaller than PMD_SIZE.
> 
> The comment suggests that this approach prevents RSS inflation.
> However, it only prevents RSS accounting. The folio is still mapped to
> the process, and the fact that it is mapped by a single PTE does not
> affect memory pressure. Additionally, the kernel's ability to map
> large folios as PMD if they are large enough does not support this
> argument.
> 
> When possible, map large folios in one shot. This reduces the number of
> minor page faults and allows for TLB coalescing.
> 
> Mapping large folios at once will allow the rmap code to mlock it on
> add, as it will recognize that it is fully mapped and mlocking is safe.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   mm/memory.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..812a7d9f6531 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   
>   	nr_pages = folio_nr_pages(folio);
>   
> -	/*
> -	 * Using per-page fault to maintain the uffd semantics, and same
> -	 * approach also applies to non shmem/tmpfs faults to avoid
> -	 * inflating the RSS of the process.
> -	 */
> -	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
> -	    unlikely(needs_fallback)) {
> +	/* Using per-page fault to maintain the uffd semantics */
> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>   		nr_pages = 1;
>   	} else if (nr_pages > 1) {
>   		pgoff_t idx = folio_page_idx(folio, page);

I could have sworn that we recently discussed that.

Ah yes, there it is

https://lkml.kernel.org/r/a1c9ba0f-544d-4204-ad3b-60fe1be2ab32@linux.alibaba.com

CCing Baolin as he wanted to look into this.

-- 
Cheers

David / dhildenb


