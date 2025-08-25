Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED00CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060888E0027; Mon, 25 Aug 2025 09:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FF48E0001; Mon, 25 Aug 2025 09:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A1D8E0027; Mon, 25 Aug 2025 09:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDE228E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:47:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84BA21A0437
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:47:16 +0000 (UTC)
X-FDA: 83815406472.25.7413A23
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1BA9F140013
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:47:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZMQTpjUB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nK8fbP6x;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZMQTpjUB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nK8fbP6x;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756129634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GlwXmq6kbIWIColIFVeW2+LyxHSdo8BUYgwpSLJsOE=;
	b=WFqds6rxkmOOVNdk57tueaxN4xHY/oXnCjNrCytpGjVrMklpUsdk7dbw2BxQNUIq5wvQQL
	ZtZrGXG1/h0Eel56m9enrouGn1bKCjNLZ4M8Vo/JY+pLDuqcwWGCGt3QYDf4JpIWudeQTt
	ej7u8T3dnzJA8GBxzPFq6SUKUfH2ZT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756129634; a=rsa-sha256;
	cv=none;
	b=8r86XHwQWiIGuth30L96K/GguuqsVMItVje+xwZaCnyTKXJ5lUnHfwFdm/2q3Mnhr+EwUN
	O50/2n28qL2cBOujwn5IrwVPbptpd7ef8U5pZArAsRIQ3YlOJBDKM0g4t5/fnXXHMV2gEr
	vkVlrQEG1LK3gNlYN4hzH9wRW94bKN4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZMQTpjUB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nK8fbP6x;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZMQTpjUB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nK8fbP6x;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 340071F792;
	Mon, 25 Aug 2025 13:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756129632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6GlwXmq6kbIWIColIFVeW2+LyxHSdo8BUYgwpSLJsOE=;
	b=ZMQTpjUBWKxSxljjSDMmMkazWnWsCPK2VOyVp0Dky25NVF4tY+QNDlXzayd++5aghl7Krt
	MHp/QlFqp09Y5Sbur4hEKis/ltC3uOSMxhapefBosnAycmT1HQRuonPuHtk03ZcHFWyH2D
	bqqSdGvlQW5dbOKlHl7uE+S5WoTTrwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756129632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6GlwXmq6kbIWIColIFVeW2+LyxHSdo8BUYgwpSLJsOE=;
	b=nK8fbP6x2CUvXEJZrBQ7qF7hfZHU4s9rlpfmqjdhvbL8A5NlVXfzOrzMw+spE9QZKCz6Na
	y7ZFI3WAYYvwgdBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756129632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6GlwXmq6kbIWIColIFVeW2+LyxHSdo8BUYgwpSLJsOE=;
	b=ZMQTpjUBWKxSxljjSDMmMkazWnWsCPK2VOyVp0Dky25NVF4tY+QNDlXzayd++5aghl7Krt
	MHp/QlFqp09Y5Sbur4hEKis/ltC3uOSMxhapefBosnAycmT1HQRuonPuHtk03ZcHFWyH2D
	bqqSdGvlQW5dbOKlHl7uE+S5WoTTrwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756129632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6GlwXmq6kbIWIColIFVeW2+LyxHSdo8BUYgwpSLJsOE=;
	b=nK8fbP6x2CUvXEJZrBQ7qF7hfZHU4s9rlpfmqjdhvbL8A5NlVXfzOrzMw+spE9QZKCz6Na
	y7ZFI3WAYYvwgdBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 142541368F;
	Mon, 25 Aug 2025 13:47:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bpyKBGBprGiRKgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 25 Aug 2025 13:47:12 +0000
Message-ID: <d64a369e-c0e1-4dd1-b032-660f467914a6@suse.cz>
Date: Mon, 25 Aug 2025 15:47:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mempool: rename struct mempool_s to struct mempool
To: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250812083105.371295-1-hch@lst.de>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250812083105.371295-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BA9F140013
X-Stat-Signature: q7zy16a4cqxjnstf5ukqh95gajkqzekn
X-Rspam-User: 
X-HE-Tag: 1756129633-547894
X-HE-Meta: U2FsdGVkX18BeZbISEMFNn5sjHEmnZ5k0zrbgaHN6FLR3ynCeUSsqJ1WqLOGjNaQ5PaWVXlSHlctbKcYDaIQScMGaj0rOBlOCBbK0E1NbxEhubazz6IpTQSiaL33vqtehPd87ce9jxluHlr7lKeVptryU1WmuEin9wa0xnU7d9e+63vZpsHbRnwnH1Q+MrCKLyvoiMx07ne6AeTq9CHG6Wsw6i1mn4Uee6B/09Opyf0Rnz3PtUaPBF3c7upWhF2m5jq/XKhgClHLHjPgJD8w+YrPtgiTFkkf0lls5d8lYabvkt2mVK3IiS7vtfQzDmy1R7fBsLmPLrJ4PbnUZdHlgj3yRQ5KM9v6VQcFzF+VOqgPjCr2TkwrWJqvWVifgsg6KRmfVZqEQ6/fGeYLz325xdh4FzA1V5zjfe94cnr93zYoFdhO2rcZV+qkRl67PV3c5RQHsRzuVyECkUd61TC8OSZuNXN9bWieXqsuzGQSzLJLWZm65GFwoHnoLb55HuEmHC4f+jFWATHbtex9jdlJFo29FDBcOZYaA8/wRokNZz1WWU92PHFoC1fBZ96QaAgkSZCyhdFtNpuqTw7JlS96D65yV8parjoaJp2ZWlErkvkDVcK8QabJagNsKhLFa3N5ae1g4325+csmrM7jk1ThFnvBSzAm/3IAgtnSTZqJG3bMn3o9kMStCYdRZTaC9HHaWL7kTNsx0ZH/bopgzltuLOAiIG3Wvd0L+pKAPk8WcHxRFVtGBSMSPjSiedI5vR3vMqGCSU/OxDrljIkXfrhX/wkfWbvd6+NHJeQl0e6QbLCQh1DvLApjSlvbGx47s8tWtJFMozd8RX+dCsSxO8Q2TN+MLs4ad+u6qnHsJo3wCBYemrE/3l7h9xiQ/fmTjsr43qk3ZkPLxjhCKvtkd1DIBgfSkU0w+QkCguD9/S233nZVJA6zIkGBe7YRi6pl4DrjZAdI2Vma4b93wTnb5i7
 nVmRWgQN
 GrCC89qdYLoAcM87EtEQsgInuHxhgCYdvOqZtjYKAIk0va2cADQqmZpetj/VYpOYSHoviMk+zmeqTE6lKMF3/VkXR3/CmIWS6nr9+iDVHblclLSFMo2TrD5QDmsb6OiTfJD4RGZ/1gt7pAEKMsQDOy5chsC7QDLXin6ciC4XR0dkFDXj63YoBgtoeISv8qn3F2l3IL3XYTIrNs2i56jMlBu8a2qO+yZsx8rvrE5w8AsypVijRDteNK9vju03zoMm14ltW7S1sC1kAMX0xRGZje3bhh3IZmm4afCGUXPJ5HBeV063W/g5qZo3XpRo6fSPsOMMb9Lw/8fKtccfbQEWHb6AKo6PD71yU7JGR/upItNZCWU8LF5f028xLEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/25 10:30, Christoph Hellwig wrote:
> Drop the pointless _s prefix and align to the usual struct naming to
> prepare for actually using the struct instead of the typedef so that
> random headers don't need to include mempool.h for just having a
> pointer to the mempool.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/blkdev.h  | 2 +-
>  include/linux/mempool.h | 2 +-
>  include/linux/netfs.h   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 95886b404b16..c3f3ec5bb864 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -199,7 +199,7 @@ struct gendisk {
>  	unsigned int		zone_wplugs_hash_bits;
>  	atomic_t		nr_zone_wplugs;
>  	spinlock_t		zone_wplugs_lock;
> -	struct mempool_s	*zone_wplugs_pool;
> +	struct mempool		*zone_wplugs_pool;
>  	struct hlist_head	*zone_wplugs_hash;
>  	struct workqueue_struct *zone_wplugs_wq;
>  #endif /* CONFIG_BLK_DEV_ZONED */
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index 7b151441341b..34941a4b9026 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -15,7 +15,7 @@ struct kmem_cache;
>  typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);
>  typedef void (mempool_free_t)(void *element, void *pool_data);
>  
> -typedef struct mempool_s {
> +typedef struct mempool {
>  	spinlock_t lock;
>  	int min_nr;		/* nr of elements at *elements */
>  	int curr_nr;		/* Current nr of elements at *elements */
> diff --git a/include/linux/netfs.h b/include/linux/netfs.h
> index 185bd8196503..270ed0822efa 100644
> --- a/include/linux/netfs.h
> +++ b/include/linux/netfs.h
> @@ -21,7 +21,7 @@
>  #include <linux/rolling_buffer.h>
>  
>  enum netfs_sreq_ref_trace;
> -typedef struct mempool_s mempool_t;
> +typedef struct mempool mempool_t;
>  struct folio_queue;
>  
>  /**


