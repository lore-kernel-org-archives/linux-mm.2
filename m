Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF1DCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8058E0019; Mon,  8 Sep 2025 07:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF918E0005; Mon,  8 Sep 2025 07:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F188E0019; Mon,  8 Sep 2025 07:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C70BC8E0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:45:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B8E513C0BA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:45:26 +0000 (UTC)
X-FDA: 83865902652.09.5FC020A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2474A40009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:45:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=abFrH7f5;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757331924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12h3i1q+WWrHAuJ5iIWUvL4KT2SfI+Lf5biZMpfNNBU=;
	b=hSbKudtChXDBMyCCij6oIcX+SlKd9QCii8t2UIwSYigaPNlxTbvJqrcdnR6JjQCI7LWSu+
	LridTMOcYO79eCQFlfJHAmGiHopkkeUw8GbJuVUU76jVVnIRjsUHdkrhXNG4tS0YF1z+8f
	GP+SVaPMl0/9PCtZaIBDoRZriMsC/lY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=abFrH7f5;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757331924; a=rsa-sha256;
	cv=none;
	b=12+Q8v/Be9E0ilYv3djWza/yfM1AHFr0jMMtKpbknV0OnxgbZ5LvoNhnmG/5VJwJ0sG5PI
	W2aRUHiPIhuhTrcsBQ7BNtGjR81Bn/9VKbO42mDGm4Rhc05NmWi4zd5Cu0t7n9zdfvSSOE
	WILr+q2gXYDerrZHCHXLGIUr7psx75A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757331923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=12h3i1q+WWrHAuJ5iIWUvL4KT2SfI+Lf5biZMpfNNBU=;
	b=abFrH7f5851+IFKJHVgf4AYfVOdf/s0zhAYAjtrMdNzPOL350RfYa4okniPt4Squ898ffp
	nPm5otdsIIcSnzv54j7f9tgm2sev0sVcmjMv3xeD+QPXqJAf8PUppe0KBYilFxZqipheFa
	iknlr7EDgvvMCM15zg7fVZanUN0WmDE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-PvuglNgFM1mot4liNmFsVQ-1; Mon, 08 Sep 2025 07:45:22 -0400
X-MC-Unique: PvuglNgFM1mot4liNmFsVQ-1
X-Mimecast-MFC-AGG-ID: PvuglNgFM1mot4liNmFsVQ_1757331921
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dda7c0e5eso24561565e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 04:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757331921; x=1757936721;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=12h3i1q+WWrHAuJ5iIWUvL4KT2SfI+Lf5biZMpfNNBU=;
        b=LRoBtllh6Z0cr0y1FBaVRVVZMnA4wUvn6eRVBvTAEhhdWRQ16b0SkMbVLFoOy29mkm
         Rp+VF5tpnj6nDpR9QsDysuswRYdq4jlQJb2N5EWY/s9pEef/9x41XrLStKCRa/uGSAtN
         uQs9ww37lIY/BfvtVViHBmWzp7geCfDMB1fWUA1hnmS+XkH1mHObxUqmDO7hSxWwoi5s
         8OD0Jid39HwjJ5OiuJhvinhwXK8XVSAkLJ4ahW5sWRDPfc0ARdpm2U9XKqOSeDefy+ey
         KuxFWd8VNLb4VV80p4/e0qMNVD28qfIaDccHIzO4sssWyYpeqrwmSfB5tdgQk/UveAkB
         5Q+w==
X-Forwarded-Encrypted: i=1; AJvYcCV9OjdSTt+L602DA95Pn6n3vbw73L5zg0RD0FA2qIia1NDOhpuO4SaX0krkXeSxof+qax3U0Tqyhg==@kvack.org
X-Gm-Message-State: AOJu0Yy4noF6RD54VfKp8s3mJCxD4SOQyVy/3VcNnIYGk588SHXn/ieo
	uCZeCNV+miu18e+5jW1KcQCywuN0beKkR+oQPPIOo8qBrq3DSK1yoMDf6wECWzHu13qu/3prwY+
	wiyGrdn/k1WjJG3kcoq0rd0SwDaqOGJ2ZbxmaMPW3KzWXjWEVRgRApAXBi6zO
X-Gm-Gg: ASbGncsClGM3wIBjQAfrTvFWmuQz/MJwmEw0t4SMAgEwHdIFfRRoFqyv3GUrfGfzQmM
	vUkNJcLrbGwe5RcUZxZLA0AnRM8IAvUSoczrfbImUwGu2C8Y4d4PeAMAjanp4Fe6TEmfw8uNl1X
	gneZ+UPUhnAUmhO25/8aBxLjKPRrTQILmGwU9z8r1ibk0I4cqK71sx+nxlEaZ6Z0kGan81PjBCh
	1FJA9xnWYaMqzH+CyHLHCYh4ydoeXy7ygOWXUA8BcZi+akcl+j+km/8JQGHFvqeIdRnO99q0j+A
	HhEvt9IA5UtvMwz0HnP/GxzgQm8IoPGkSXWPqd61SZK92PbfYejzqlaCeP4duw81DB14XgG6qAA
	DgTPkHrjtN2Tecv01J5zcJadZJUrvn1YMM4nMt0gjdVb+OL1LIaLpOA9KW1joviW0
X-Received: by 2002:a05:600c:5254:b0:45c:b607:ea95 with SMTP id 5b1f17b1804b1-45dddeeebcemr65061525e9.18.1757331921004;
        Mon, 08 Sep 2025 04:45:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZMDWEcg53mmAIOa8ZxjdF1reUktiTZGkLpalLwMR7JFbLd43vy4hZ2Zk1Uqm7PJJc5QHe/A==
X-Received: by 2002:a05:600c:5254:b0:45c:b607:ea95 with SMTP id 5b1f17b1804b1-45dddeeebcemr65061175e9.18.1757331920496;
        Mon, 08 Sep 2025 04:45:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de229238fsm73104815e9.16.2025.09.08.04.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 04:45:20 -0700 (PDT)
Message-ID: <22bc228e-4598-4b5d-ab5d-f9f493a4d961@redhat.com>
Date: Mon, 8 Sep 2025 13:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-4-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-4-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ys8lZPU_cbjg4gQE3we59LvcyWwXTm1aQYNrSv6550U_1757331921
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2474A40009
X-Rspam-User: 
X-Stat-Signature: zy9q36wo5tcf1pizrhipws8c55gdnt7g
X-Rspamd-Server: rspam09
X-HE-Tag: 1757331923-121054
X-HE-Meta: U2FsdGVkX19a5KB6oIMWOtGYkQbVN6EYqgjVRz8wRQ6xJjg4LljBgch5P+OWSPdtzj2Y44xM1AUCn5SqQE7LvpNfGRfOI6FQRP9Ctcsugz/t/xjxfHFZO9cGl2LyU2kKhKFaX76U2JH8IeLSnmbz42M+UZrAVsmCp/wODO2Fjl+Di7UqTZYHY86rcHeBdKTR7WERSTtuQcBHJKVOMmKQ4E7rwI6Uh8d9C3fx66NC+G5x7ThVCt0MTVfXIO4UGwfgAYuwjrkWdp+6fWBf1nvYIasKmRJPJ7LQ636oTnS7gruYoputkdpO1avb9+GLHaEXBpIn40o177DnzARNFO+U8uaEHOjK1mdqINIwYQD2krQB5sMmI2Tp7Ar2+wRh8FNtVfp/7Jzs0tK1SF/2K+7AkOeSUyCzEv+HL7AxRjmBQYkgPWNW+ihYBxvXc2exCzUHr9JmrNMMhTJj+6hcKzedDgFWh44lj4OsYaw/W2L9TzUF/xj4qKuGmf6339kyJ9U1BbynX/MW8HOzBjAw/r4Q03qnCe/xWFaJkHHTxlhwYiOGBmiMemwy5UEqG/kNhUBjTRI6V9/SXL9Fi05EY/xzPjifkcyQg9PI11Lqp9ZRF7mPQ+EYJr963tf/7nS0lLoA6a2/rX07UoxgmhpRv6ajXuGwV68+FtPsVZeLLYaLAId9OEcg2TYI9/+xIoH+qGlt3gJcCnkRrbMgwGUETyOzL6RF+ckTi6SQdQqGOK3/ovagiKYtKUgpBuMlwpgnMlf+zmlHzRcxaj/7hx9tK4m0K+ACyKDBD3NwOy6xjz+TKM4B9wfjWHhNM83QfwbTmZgP1TXa1omItEi3DVahaRsh1yqNIgsTZ8QcaqLPYJM/PoQFWYm1pDKWg1QsNcJ5vU0BjhTn5AHmFte0BH/Qluz0e1TlAgs0HdK5wAtSBxcWkp1+0THQYYxI+JAKz0oyGgm9ek/H3UN1vbGTNFO33KC
 rlfJPr6C
 ywju9DgYSydRyO+7NfK9yAos5Y1PRkKgGBMO3YAyrX5vR5WE9GkeWrEmAF/YQtGGoKKH0Ww4JPK/vYFDa4IRu4pjyuW5RMe5YK1AWsnafjPgmfqryJzvLAZEYlaHJNeFJtXJItnpNwM3ImJMno3lUowsh7b7MXQWodbxFnY8vYjQKGjC0jnf2ykI4Paf7nIc1EJeIxNr2XcpyIFMFQBE+gobiXhB46mam/vNIh9OC8LYK6scYdZFjVmijkI3Z0pBlICVWcO7KKt4a06WJ+wQ5BdxHTe4P5om9UhX2gliSbp9ADMYDNVf6+xK9iDn3Q09ZkBWdPBTtFfJsrtqB94UUv0zxNLRqm9Fqt5NTBeT+NoUK97ej4fap0zHSPtCa486RxQnuIIFm8pX6oTqy6OZEnoGAH2jry0lOCh3/U3L0BzoTkSeWnHrKxXyo8aA9K5sR3tsQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 21:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>

Subject: s/cahe/cache/

> 
> The allocator will reclaim cached slots while scanning. Currently, it
> will try again if the reclaim found a folio that is already removed from

s/the reclaim/reclaim/

> the swap cache due to a race. But the following lookup will be using the
> wrong index. It won't cause any OOB issue since the swap cache index is
> truncated upon lookup, but it may lead to reclaiming of an irrelevant
> folio.
> 
> This should not cause a measurable issue, but we should fix it.
> 
> Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/swapfile.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4b8ab2cb49ca..4c63fc62f4cb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>   	 * Offset could point to the middle of a large folio, or folio
>   	 * may no longer point to the expected offset before it's locked.
>   	 */
> -	entry = folio->swap;
> -	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
> +	if (offset < swp_offset(folio->swap) ||
> +	    offset >= swp_offset(folio->swap) + nr_pages) {
>   		folio_unlock(folio);
>   		folio_put(folio);
>   		goto again;
>   	}
> -	offset = swp_offset(entry);
> +	offset = swp_offset(folio->swap);
>   
>   	need_reclaim = ((flags & TTRS_ANYWAY) ||
>   			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


