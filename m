Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AFBCD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800F96B0005; Fri,  5 Jun 2026 03:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8016B0088; Fri,  5 Jun 2026 03:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF1D6B008A; Fri,  5 Jun 2026 03:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8FE6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:16:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9ECB8140AFD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:16:32 +0000 (UTC)
X-FDA: 84845001024.21.1D9F1DA
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA325140014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:16:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wy8GR38X;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780643791;
	b=2ccDiWk1pVcc1jsT2cTPF4ChSckT6DBpSGDoC3Et2/qiMV0FJ1jW6NnWZZWdiAd4GEXZgR
	GPumf0avCJZyPFe4LkkFAOw53twfn6otC7u7j0GakvzMZqbtG9L9w1ciE9pxkUxcbireYa
	YOpmQw9mNcbu1VP4jum3zivgDnxdbnU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wy8GR38X;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780643791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9V/8n2hTJ/zr2Eaq/yNhVAHj7+OUcODMwuLh782cBs=;
	b=WnRwKyqnjGRgsjNTKXvAdsHidAPj1tGMhq1uT/T5LCrZUf/IQtgWCXJ3P4s7XtgMStmEMi
	lKzaQ1rCPTPskVkNjxhbvAdrHxgTRiJ9sb712z8wLqM9CHhNh5wiYFq691T4QXOiBAnqD+
	iN8XqBhipxyncHt+lioPeo+rUXT+A6Y=
Date: Fri, 5 Jun 2026 15:16:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780643789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9V/8n2hTJ/zr2Eaq/yNhVAHj7+OUcODMwuLh782cBs=;
	b=wy8GR38XCR+AQqOoEUs1odpFoHJxXlqBxIAhiYGXNSaOlDwyRpgnWOmqbfCoiPjoyeLabJ
	UduXZudGU9Ir3fh9WO36vlGLji59LoNCQO6fIFP9s2aOXIShjAjAISxvTzpUgehXZbNar0
	AwlfYjTSGxOTgrNMbrnZBXGZFpwDpo4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 8/8] mm/vmstat: add NRSWP{IN,OUT} counters
Message-ID: <aiJ3xfFxcS62MOK9@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-9-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA325140014
X-Rspam-User: 
X-Stat-Signature: iq87r1f3usm4y8pn4brftb8n3xwwf4ei
X-HE-Tag: 1780643790-928001
X-HE-Meta: U2FsdGVkX19A/s9DvPs9kqVzT+TmMFKVAgktZqofQC+Qxx3l+JnFYPhQjKjlO6PzeUUgv5qOO1sdtcQzDQxM8EP81H28RDAw4RplmbJZ53A3PbnX8kKeuh0QwiYPQYJevTfOxuK2LT6TUXJnG7EBpWm0ufDwHqC8pYxKxG+aTE1+hPFPkyQbFbAfdrjq1vFO1mq+998BZdHMROoYfsePwZUSmdB7g4ZRUTj8HAQSv/qjvSeCa513ID0LHI5mIV3jbUgi2HQd4OCbCFATZQYzP+LIVMR/ZAOonJsBAiT7ubBW2aINrwD1dFiH+58gi8FcmjEwKZjPldqSpD7T9J2VbsDQX8mnx3gQCtLReQ6AaeDY6YIX729Qtxs1aVyRuH1jpwQP56S5scEh+rlWvjBGeLRxdmUv07TVAJp9bo1O7C8Aytw8Ln/DeECJoldW00wadOeoKxmnmeOS+rZrY/IQB3zkGuOqLflxSJ+BhrIqxQw3VffIt5vWh4e/MH6znGGpOsz2Od5Ayq6kJnRpAHbdWVn8dtZvy7/r+2Y9t1VkIxQvvtD3wKz6rZIxfg7K57b9rSkU/jAzH2ccfjAlhvcog0T7Zqxfed4ToEHW8zoHvWJcyY6x2s/hB9ztFaD0J6SUvGiqBcl2ZOh34X0BIMmbh4+M4MHiCbRSmZA5mBRBJLU385pa3RQnIfbVSl5UwXhx0HL6uylfPNANFZcjajHLQurYFwdsuAqvupCIy/CBwA6SujnOygjmYHaXg96mr+cxq2cPFOvcyaWVaeiMnvnh2aUTS7uzNraT4VNZeeYsGm8bDbfvOwvf+gHtXWQNdIuAHEVb/F4koojb90RcvfBrk15JTLjDkLrw5qvJ6vWyQ4RDO2egCJEubRISOrbz9xI1yoaqrETHDdk8HsPQzcdRDm6PcpYWqN8eofwE2FLCwZNbUiaRWs30u3UlXXAbIvoMOqmJC9oOsNWLM+DDHs0
 l8HsvkBI
 FmIGj9dAvpqpAWtrVP6xZe8RUsEBqDUH7S2ej22HnNsscKiIQTOqS85m4ueCKbVqpUxI9zIE4SabqB+ECxfZRG8/9vlMLhkig4OA1Qiqrg4RDGUbPwT3txLOAvxM/V4VBDOoQulIHPbanjR0V7C3QZUyuMxp55O6VCX0KEpFJae9sUfMu4GEQtjJJ09kqyU8ava8iH5NPNmUM6Pnjlu248ZTQd2G2i96y0i+T7/xPtw8uWwM1LZQz6vNwZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> Count how many swap I/Os we cause.  Due to batching this can be
> different than the currently counter number of pages written/read,
                     ~~~~~~~ current, typo?
> and tracking this information is useful to see how efficient the
> batching is.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/vm_event_item.h | 4 ++++
>  mm/page_io.c                  | 2 ++
>  mm/vmstat.c                   | 6 +++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 03fe95f5a020..2628ccda076a 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -175,6 +175,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		KSTACK_REST,
>  #endif
>  #endif /* CONFIG_DEBUG_STACK_USAGE */
> +#ifdef CONFIG_SWAP
> +		NRSWPIN,
> +		NRSWPOUT,
> +#endif /* CONFIG_SWAP */

Putting them together with 'SWAP_RA ... SWPOUT_ZERO' could impact the
ongoing program/script?

>  		NR_VM_EVENT_ITEMS
>  };
>  
> diff --git a/mm/page_io.c b/mm/page_io.c
> index cdac55d0a2e9..c020e8ebf966 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -695,6 +695,7 @@ void swap_write_submit(struct swap_io_ctx *ctx)
>  {
>  	if (!ctx->sio)
>  		return;
> +	count_vm_events(NRSWPOUT, 1);
>  	ctx->sis->ops->submit_write(ctx);
>  	ctx->sio = NULL;
>  	ctx->sis = NULL;
> @@ -704,6 +705,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
>  {
>  	if (!ctx->sio)
>  		return;
> +	count_vm_events(NRSWPIN, 1);
>  	ctx->sis->ops->submit_read(ctx);
>  	ctx->sio = NULL;
>  	ctx->sis = NULL;
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517d..9559f3c95735 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1488,7 +1488,11 @@ const char * const vmstat_text[] = {
>  #if THREAD_SIZE > 65536
>  	[I(KSTACK_REST)]			= "kstack_rest",
>  #endif
> -#endif
> +#endif /* CONFIG_DEBUG_STACK_USAGE */
> +#ifdef CONFIG_SWAP
> +	[I(NRSWPIN)]				= "nrswpin",
> +	[I(NRSWPOUT)]				= "nrswpout",
> +#endif /* CONFIG_SWAP */
>  #undef I
>  #endif /* CONFIG_VM_EVENT_COUNTERS */
>  };
> -- 
> 2.53.0
> 

