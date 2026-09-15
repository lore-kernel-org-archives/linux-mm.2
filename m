Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54779C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 04:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B83B6B0088; Tue, 15 Sep 2026 00:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3692D6B008C; Tue, 15 Sep 2026 00:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259246B0092; Tue, 15 Sep 2026 00:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0540C6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:22:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DB6AA4EC6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:22:12 +0000 (UTC)
X-FDA: 85214699304.17.AEF322F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B0B1420004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:22:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HjMkU9d+;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789446130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ift+8DOHb+25wOaqafeC4wcfvzXMnHSS8K6du3vmu8k=;
	b=27VrLEc+X7+kvXCtIWRlYmHgdVvZ8Dyp8OgeirgCoKIuEI8hOCuZfnqLOtWp3H/rtD3V0n
	oETqt9HJTadiAqOTuPsvF4rgpG55p5A2VTs+1ajU5KswuDbSNSRe4aqK9g84XXMvyNh/q3
	pbBr4BZHz3yrr6kbAS9PpCIvqQ8MipU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789446130;
	b=yH7RFs4hDPdynHr6soClrLcV5S5tUCbBTrx4S0NC0xCsTDjHpeqGU6vFX/TYgTV01svZJg
	49UzL6W79u3sE3Zb9uMO4TghVLqF+U1UzAH3cz4NfAeEHejmvmLKf3F5qmCev13C3FBERg
	FF5VOkZ7thYodxsmm1dwBObT14biYFs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HjMkU9d+;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFC95414FC;
	Tue, 15 Sep 2026 04:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04171F00893;
	Tue, 15 Sep 2026 04:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789446129;
	bh=ift+8DOHb+25wOaqafeC4wcfvzXMnHSS8K6du3vmu8k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HjMkU9d+BgVEFK7w9OEsa07Hxd+IEX0/9SPIjTm8q/qBwGp/Hib20MhNeAn2yF4qT
	 izlwmKZd2Y9HCX5CglHOMNjP1J6FtHorkkg/QuTp8qlaVXmsewQy9z/BbEEmOCT6ml
	 GmYcxgiFtalrqIO8ne4uIbK9LqgFyskfY28Dy+mk=
Date: Mon, 14 Sep 2026 21:22:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Muchun Song
 <muchun.song@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm: Remove unused exact_nid parameter from
 memmap_alloc()
Message-Id: <20260914212200.75878c86ab806c7e09b6c69e@linux-foundation.org>
In-Reply-To: <20260914055130.44543-1-kaitao.cheng@linux.dev>
References: <20260914055130.44543-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0B1420004
X-Stat-Signature: weu6cns7k3qphepdpf6p9jjguitbpm9h
X-HE-Tag: 1789446130-603385
X-HE-Meta: U2FsdGVkX18eby2hn8p4ipGr+5H5ogyIPDzljZ6pvc951IaIL0lbtQGSEnuJyZG9CUFVyNFK8aywvTQWb0Q+YgGokf+kv1qa8taxENBSxJl4qMIVHquPUl1uqAzxyQ9BSjJTha5q5M8vwlEJUalJtLSBEvK2d9sKd9W7VZfLf1Z37lrL1aCaEgc7VYYC71eeGaipi9uci9Py6seqbg0h+umrglQIMDBkTI4bx8HPYa/KrHTzeaich5oP/RYAwda3kd/+DU913LqcF/PjabX5hP05awaR31Q+iTDiIzTO66Z6dTVT8tjepvdLTfqyiL8TTmAy9tg4fHuA0ehbXxES05iYREOsYMpeZQvjAgL9v4R93aqvJq/BiJtySiIaSZkQuNTixmfY0fT3GmleUEHjbpeA7EuBgjnMLiDKIJFuyYDhzrg0LE3UknI9p4RRenBDgCwugkeknf9FQoeiVn6fI8PeUmCn4tm6KB8QYbwlwqXR2EnPMfx9lAs4orDZXhEbfqaJQl+3fWmegpAISCz31rHSBLi6hfzyya1b4yWzF5Gddk9M+f5MDlTPyhvEKvC2PWgWWJ8TxFsJH16g3IGbKRvAKE64OUTIPAuY4TEbeG6LxrwOrttho9UDOtz4DZCHfhbRPjc5+z8NO79YNFdz4K7zTbZ2/ZDB4ENdeYLmo6J2b5vk07Tg9Sy0hmT6yFfzl41qwmeRKah6fcLcPNefOCEeYr2UEeHcFX2QJP3+QPTrObq6qVSP8UKkTp52iHvn9x9AEYLweCsVchQ2DLM2l10MUhghjPb8PbpafWhi58oFDSwjfEnUvEIaISVquCWSpNS5eo0VDgOe7CXRIXTun0m8CHwu1xF/jiW8NLlYMbVkg1ba1l0aJfqAKHPU8fiVGZoHU/zVVXeFvaRE+l9yWb+jzFa1+6YtKbUukxToRfY9oYEk+yj16rF8cDrTYQZwpHDueNPOlHw1eTytfQE
 giW1Sml1
 S8QLjCFIZUmhGjJKRTsPzjiEs3gItmkM5PreHAPtl5/XrlDwVPgnWiu32mcdSZswucEZuxXWHcAKwI9RV7MqUELKUkRicLY8qeuBRse23u6VBfSKwkSF1AisDd2bdVXqaV/RT2Tkyg34BkWell0qgc8PVCFYhqatFd9uOpXEjpqFt/j2mp/S9AtJjvnB9Slo0tnn1N/gLPvWo9w1RyBL3yXQHBXPlrn1VjJXQ3Htmwiri+Bia08i85oV3ONDDgxJns/8cL43vLWkciWo+m5UauBhdOvKRgs82X7xOB2oGSYowDuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 13:51:30 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
> mechanism") removed sparse_buffer_init(), which was the only caller of
> memmap_alloc() that passed true for exact_nid.
> 
> All remaining callers pass false, leaving the exact-node allocation
> branch unreachable. Remove the exact_nid parameter and unconditionally
> use memblock_alloc_try_nid_raw().
> 
> This has no functional impact.
> 

Latest development code has changed quite lot, but this was an easy reject
to fix:

> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -53,7 +53,7 @@ static void * __ref __earlyonly_bootmem_alloc(int node,
>  				unsigned long align,
>  				unsigned long goal)
>  {
> -	return memmap_alloc(size, align, goal, node, false);
> +	return memmap_alloc(size, align, goal, node);
>  }
>  
>  void * __meminit vmemmap_alloc_block(unsigned long size, int node)


--- a/mm/sparse.c~mm-remove-unused-exact_nid-parameter-from-memmap_alloc
+++ a/mm/sparse.c
@@ -215,7 +215,7 @@ struct page __init *__populate_section_m
 {
 	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
-	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 


