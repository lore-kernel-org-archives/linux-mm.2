Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98731CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40B080078; Mon, 27 Oct 2025 12:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF09C8000A; Mon, 27 Oct 2025 12:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF3E80078; Mon, 27 Oct 2025 12:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A61938000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:58:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FAA4139983
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:58:44 +0000 (UTC)
X-FDA: 84044503368.29.44CFF93
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE72BA0013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:58:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vvs2T6bx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pl89WX8m;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vvs2T6bx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pl89WX8m;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761584322; a=rsa-sha256;
	cv=none;
	b=ifROZIZ5/t4bTFoBicKj/Dv3cxLXDwd9LIkJQ8pYvQpdaSz0sk0LQSAS2KDTCwAavNidHt
	3mO/0pZoJxRVure6O1j3vgm0pmXAUpqedKt6S2ZJZEnl9EmhRFoRbHiZDl7t29EN+CX/Nt
	QiHLqq982tBCRXY1dAiFy0myBpCHlWE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vvs2T6bx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pl89WX8m;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vvs2T6bx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pl89WX8m;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761584322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBjwsxEHIHP+J4fNYl/ok/bADeRw4tHN4tElEgTPgzQ=;
	b=omsQ7Ddv0cfRHb+dyKaI7Cw4isTY0f2g9q769c5OcexU4Biqb2yaNFc9W4wpUoBb/DYO0y
	EQ4ynnfSDGeJWtRmvUjfOCUyczLvwcceZ9CSXDFodGLS4NswrGe20m3Xe5yO8B9dOVgoBt
	6pA1LzLH4i4PqYPvoCu6rNavxYuQa/g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2378B1F451;
	Mon, 27 Oct 2025 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761584320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dBjwsxEHIHP+J4fNYl/ok/bADeRw4tHN4tElEgTPgzQ=;
	b=vvs2T6bx0WaUyZKAZAX4aKOIBHmBdt8sQdmrgXXIwmHt0M6jk0DnDs9r03rkZkEheWTST6
	nmlYjhdYWxg8+ikZ8RsshPlWsDAwfGtNXuE8t8lN7ieCiN1DaK0+pDxVEgZDhtPc8iEEai
	sDW7OZrGXgeEAYirtPJysT/hGTOswos=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761584320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dBjwsxEHIHP+J4fNYl/ok/bADeRw4tHN4tElEgTPgzQ=;
	b=pl89WX8mAFemKP3WsROYNG3xi+W8q7WYTM2WiIio/8vrcRdmxzJAAIG6zxx8qbu+sOUV5A
	hV2Se8m6Pl0YR+Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761584320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dBjwsxEHIHP+J4fNYl/ok/bADeRw4tHN4tElEgTPgzQ=;
	b=vvs2T6bx0WaUyZKAZAX4aKOIBHmBdt8sQdmrgXXIwmHt0M6jk0DnDs9r03rkZkEheWTST6
	nmlYjhdYWxg8+ikZ8RsshPlWsDAwfGtNXuE8t8lN7ieCiN1DaK0+pDxVEgZDhtPc8iEEai
	sDW7OZrGXgeEAYirtPJysT/hGTOswos=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761584320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dBjwsxEHIHP+J4fNYl/ok/bADeRw4tHN4tElEgTPgzQ=;
	b=pl89WX8mAFemKP3WsROYNG3xi+W8q7WYTM2WiIio/8vrcRdmxzJAAIG6zxx8qbu+sOUV5A
	hV2Se8m6Pl0YR+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D7CD13693;
	Mon, 27 Oct 2025 16:58:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AlT2AsCk/2hULwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 16:58:40 +0000
Message-ID: <988a1020-d4e2-4515-ae92-03298553d09c@suse.cz>
Date: Mon, 27 Oct 2025 17:58:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/17] slab: Remove folio references from kvfree()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-9-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-9-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 553rog888etfw3d1tjuphj7x4m7dj3rh
X-Rspamd-Queue-Id: BE72BA0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1761584321-984023
X-HE-Meta: U2FsdGVkX1+c+K2+XMQmjcjurWmdg3+DNthHfhvX+cxqrDnEl8P+FbwNdCft1Ip7W/Aj4v4XmV7nq9y6wY9cOuzxI+57tHuoiVXGEAqDrDmb05XjH/f28dpHd0ixaljunXSK6K0twa0nBWXYm3RZtJjF3K9aJNygu/mEPcYsbsmkyH/obd/cszNXHzx6RHWNtrtnq/iiGObH5saZH8SbDKo7R1vHIm5jTAnluJpIFjLqV6fDh5n6uTlhQwTJvHazudgm/Ok7ngeOgQ+SDxE+GH6D4iWI/i6aKI/0Nal1DvNvVyXhaYNCKnkKNoDcqOilVUBicPYfyjRDQDZqDHgaAG9JFcWeZM8IR1CtTNcMovVkXaaTWrAM9AXOaTikr3wX4kYhiUHBF6in15mB8ynIH7Vgwai4ogE4OOhG38MMypC5PEKpBf7nefUfmdBTY0WR6809F2ynHTLPORu5TlWo0eNSPzeo1mAiqZI7OH1xrMa7a6e2KbQvrBBdzdrN7/6IAnJv2dEV4CzNrLANP5e9DRAKDO7k0Qg9K6c77iRoM1xf/Kd9hD/hPZqws+SH6tn0p3mNO102gHWyltju46Obp+TDYZuZzN0dLjMQALM0+xx/A8EEVdM8gspms2f8I57pOfTbs2xyc1D6ygRBd+cea9CuGZCDejFMvE3Eohw/q5Ivy0uOCjueA3ocgkKLRpsOshvxRZTZTZJaBANbeV4jL4E3D0RlVRnuM7bHa1NHjMgGZT7cD/yJBhLakPlb6mheeK2VvzAnzxWTmjPsU4bqem7OwIKQCa4YUaDbE/4NmDledhiau+0aMIYXwpQBK7/7HFz/T9HgYpkj9Wn8giDK/a0DVLcBBZfGBTSSpm7PDrpaBpMCyRiZTjmetMOUXvqk8pGJFow7Z0IhrxsUMHz6YLCUuDTeKJcGKZ1mUfV3+hA1gWNOT3nBZgZxs6PkbFRY7UmpXSZEaoiiMNkVP/U
 Li8JOJw2
 Sa6E0GY7/uKKOvymYtqdQyZt3HTgLeyhXcITM/jLszoPpxzpRWpQFFHRbdLrwtsF1UIRxj/dEr7CPzLUPsuxy5V4ezQMmfgP42a3adQgjtos6vzaivshYWB1yNwNHJrWeGoSa63CrKp4YvIXrCHi4AW9K+cH24+SldGt23iQK3gv4nScVgg8Cv6uu952pQYRxYrf0gWdEVOVHO3xQNzSqgK2UzSjdN1YrLttcRBz3twd3mZimZalj2A/ZqN2G+w6tiNP9NTpKFqOlfRLQGWFEH+eo/5BQGAYLuszkSJxATJvFqYr2uswcfW6Z/ivz24KwVwLlEXxOlkNg6RndOB1fNMj1Mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject says kvfree() but it's kfree()

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> As with memcg_slab_post_charge(), we save a call to compound_head()
> for large kmallocs.

I'd consider small kmallocs the more common path and so...

> This has a slight change of behaviour in that
> non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
> pointer dereference rather than a warning.  We could add that back if
> really needed.

... considering also this...
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I'd rather restructure it to try page_slab() first, and free_large_kmalloc()
if it's unlikely(NULL), without checking the PageLargeKmalloc flag (let
free_large_kmalloc() do it for the WARN).

kvfree_rcu_cb() in previous patch too then, for consistency

> ---
>  mm/slub.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index debe7132b343..100ed979312d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6809,7 +6809,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
>   */
>  void kfree(const void *object)
>  {
> -	struct folio *folio;
> +	struct page *page;
>  	struct slab *slab;
>  	struct kmem_cache *s;
>  	void *x = (void *)object;
> @@ -6819,13 +6819,13 @@ void kfree(const void *object)
>  	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return;
>  
> -	folio = virt_to_folio(object);
> -	if (unlikely(!folio_test_slab(folio))) {
> -		free_large_kmalloc(&folio->page, (void *)object);
> +	page = virt_to_page(object);
> +	if (unlikely(PageLargeKmalloc(page))) {
> +		free_large_kmalloc(page, (void *)object);
>  		return;
>  	}
>  
> -	slab = folio_slab(folio);
> +	slab = page_slab(page);
>  	s = slab->slab_cache;
>  	slab_free(s, slab, x, _RET_IP_);
>  }


