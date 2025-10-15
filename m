Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DE4CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FF98E0032; Wed, 15 Oct 2025 09:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56FD8E0020; Wed, 15 Oct 2025 09:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C466E8E0032; Wed, 15 Oct 2025 09:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3F078E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:11:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CE3955A6D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:11:56 +0000 (UTC)
X-FDA: 84000386232.05.2FCC4A9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id E018B8000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:11:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GHGDsIXc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/SqK4l1+";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GHGDsIXc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/SqK4l1+";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760533914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQi+dhYrJXBSl35q86HIQWqi7/gBcyLZtUjN+URTrIw=;
	b=8qLnZD49BlbUmT1Kvd0oJoM3Cjy6QsoDHe4pMotGic0W+gjoSUuQKT4VPESeBSN2rNPXUk
	ukFOVKE9rFE6y7+UU4ZwxU/k5aM+kf6r38pP2F1M5o8hk31bW+n4zlN7Vycl822ygP9GZL
	SzdL2ZrNCWecIcQuCMward9XaEsRSRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760533914; a=rsa-sha256;
	cv=none;
	b=uI1eV66G6uhH6G9FdAAQGinFZ5t5QrYjzZ/a0dhIq0n5s7H9u+EBmlVLQKWUxk44M6YpIA
	tLQiiLAMjoRx76EzKiPiF/TBP4n0bMlDSrBAPuBB4V8WJ5KQYm7tNojipVUqQ0Oz4gHNeM
	x4alvnqsrHKVfDPcXtD9JaF3YnLkij8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GHGDsIXc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/SqK4l1+";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GHGDsIXc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/SqK4l1+";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1EA9B1FC31;
	Wed, 15 Oct 2025 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760533912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AQi+dhYrJXBSl35q86HIQWqi7/gBcyLZtUjN+URTrIw=;
	b=GHGDsIXcxEv/qA3WtSEleATzL8n9WUyhWSuW4rUwe2e27Sue8pBRKzauOfTu4K+W/HK+1j
	KVFeO5Ig4zWfouc6/BGf3rukn686T73O7ygvTHcR1XQapU+3KURgK9BeujH+ZDGB3WfIqP
	gCqCHpfQ2uZL6GeeqQeEJbjYN3TdJao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760533912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AQi+dhYrJXBSl35q86HIQWqi7/gBcyLZtUjN+URTrIw=;
	b=/SqK4l1+xY1NZEwTQgtgkeFKYwvPHejVfo+N4AlHaoz1WSXhV/ycQ6bz0TPZdpa0nVs4hM
	2zdCJ14m1uVS7vBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760533912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AQi+dhYrJXBSl35q86HIQWqi7/gBcyLZtUjN+URTrIw=;
	b=GHGDsIXcxEv/qA3WtSEleATzL8n9WUyhWSuW4rUwe2e27Sue8pBRKzauOfTu4K+W/HK+1j
	KVFeO5Ig4zWfouc6/BGf3rukn686T73O7ygvTHcR1XQapU+3KURgK9BeujH+ZDGB3WfIqP
	gCqCHpfQ2uZL6GeeqQeEJbjYN3TdJao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760533912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AQi+dhYrJXBSl35q86HIQWqi7/gBcyLZtUjN+URTrIw=;
	b=/SqK4l1+xY1NZEwTQgtgkeFKYwvPHejVfo+N4AlHaoz1WSXhV/ycQ6bz0TPZdpa0nVs4hM
	2zdCJ14m1uVS7vBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 088C313A29;
	Wed, 15 Oct 2025 13:11:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IdTBAZid72gXOwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 13:11:52 +0000
Message-ID: <06b0c6fb-0123-4482-ac07-80f0faec3532@suse.cz>
Date: Wed, 15 Oct 2025 15:11:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
Content-Language: en-US
To: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <20251015125945.481950-1-hao.ge@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251015125945.481950-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E018B8000C
X-Rspamd-Server: rspam02
X-Stat-Signature: gbzewrtkhrwurywugopzigomqiwc4a5q
X-HE-Tag: 1760533913-890485
X-HE-Meta: U2FsdGVkX19GYh/pZBAXQaaLDHvOswFkLUhw3kO8Fh9lDYYbDeSJWGQs/z/iAR5Qi+vf2Dv7KdcA86i/AamqSJffuFwiXhn0zecY8SCs3nBcOqSi+eEMH7dPKvxpig6mT5pRv0OdzYGYaDcJ1f7+aLjjSiTTykMbNLsLKTvCq1xA1PfWaRTNwoWX0vgEMHHARQE+C1OK9753KP1l0wlpszHDPvKWzYgWdiFkiY+s60AWS4ULabxdnoULS7Na/BHMBHlLto3lVdYIt7SAXXf0jF8Js3I3UMHsRaWnkoM7SL5bXUdJ1RSqsa9pE/Ad02SsdLL7B8E3EzFQLOqfPhdnPm3+uIB0HKbJXabCpG//2UyTt0sVAckrPOLgXSgryGI9rApTkoF3kJ1SAQpvJuAxsyE7W/y2SpDXUcV2qfRo3EjGU1JzH3f6ryxMzhW3eo2OvTaaA/y7fU6Te6MEHnKXJlibsGqXVyMEDPSK9iCc6cRM7jiIuQKEtix9RElm5flfLCu4qJyOqxPM39U+nvGKl0f5hTQ0/TRqUjortTBOkcdCULFCkA42AyLkvocv1WgxD9Cw2GRD4VlF7ieUu2te0ZJDFBlU/iW0Aum9yPz8BI4ndtG4EO0opmWmpPS2bfjMBDBaFMN0yAUFwG8bWxDx8oK+QGihqZo59fzbmZM5oBt3WGyyVy4gfvUT3AK8vFH/A9WslrV57+HhHZd+IJQHXOyNh0D4a6EVlfBB40wr86PQ5kRSDMvuD02O32P+/WqR1x5wIVyK7znluAswzd0/cXzXLJjzlbl2bg+GhZqmnpvd5TNvfIR4vgYSTIneN9FldB+hHPxmzDQznfvS0datfmX4xiRZB974H7wak/ka7xazK1+69O6p9NeA+k42dD+4OEdTh4xqR4B5ZM/fCAj+xtvyUgGOrAjpc5Knz4SOAsG64fvqcYxs3ZA7UNgujiLw770n/2S0cGj+KmKv0Ts
 FwFKpYTr
 UQYxfgbMUzwUCJscE/f8zAnMnJ3KF3qr+JfcbDgjztkWIwEIa/bg7s3MKGMWKcI35C5G5i8NkKha39E3YYz4lSgEqB0BtrxfWyQbEap+NeIoMFgdU86Bcy0/2x8/1ERTG5IUuJSywjwCoGPgSq0hRhsSGo246aBY92a/heKOHRtszHyDkYLhF5LKHCtAP5P3WiUcCzktFIzYdvvZBcqXCsR0VOcvZa6W472J7Iuq0jgH951na2VBzHP+SjZiw3DtZAvNstFsYyBaMEBaQKaGjYCisMfOnLpqMC+DAFSZ/hgs47KPmVHmNYaGxmPnoCx5tcATShIl1TdanB6HYfU4AbN2SnBy7rqiFveterWIJrPtdmVU5ij1RL85AwQ85iuTvnLKuahHIAs4Rjm7aaxbK9AdQRZSl3MPUNDYg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 14:59, Hao Ge wrote:
> From: Hao Ge <gehao@kylinos.cn>
> 
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> a valid folio->memcg_data was not cleared before freeing the folio.
> 
> When freeing a slab, we clear slab->obj_exts if the obj_ext array has been
> successfully allocated. So let's clear OBJEXTS_ALLOC_FAIL when freeing
> a slab if the obj_ext array allocated fail to allow them to be returned
> to the buddy system more smoothly.

Thanks!

> Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Since we changed the approach completely, I think we should not carry over
the previously added review tags in this case.

> ---
> v4: Based on the discussion between Vlastimil and Harry,
>     modify the solution to clear OBJEXTS_ALLOC_FAIL when freeing a slab.
>     This does seem more reasonable. Thank you both.
> ---
>  mm/slab.h | 26 ++++++++++++++++++++++++++
>  mm/slub.c |  6 ++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 078daecc7cf5..52424d6871bd 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -547,6 +547,28 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
>  	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
>  }
>  
> +/*
> + * objexts_clear_alloc_fail -  Clear the OBJEXTS_ALLOC_FAIL for
> + * the slab object extension vector associated with a slab.
> + * @slab: a pointer to the slab struct
> + */
> +static inline void objexts_clear_alloc_fail(struct slab *slab)
> +{
> +	unsigned long obj_exts = READ_ONCE(slab->obj_exts);
> +
> +#ifdef CONFIG_MEMCG
> +	/*
> +	 * obj_exts should be either NULL, a valid pointer with
> +	 * MEMCG_DATA_OBJEXTS bit set or be equal to OBJEXTS_ALLOC_FAIL.
> +	 */
> +	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS) &&
> +		       obj_exts != OBJEXTS_ALLOC_FAIL, slab_page(slab));
> +	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
> +#endif
> +
> +	obj_exts &= ~OBJEXTS_ALLOC_FAIL;
> +	WRITE_ONCE(slab->obj_exts, obj_exts);
> +}

This is much larger than necessary I think. See below.

>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                          gfp_t gfp, bool new_slab);
>  
> @@ -557,6 +579,10 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
>  	return NULL;
>  }
>  
> +static inline void objexts_clear_alloc_fail(struct slab *slab)
> +{
> +}
> +
>  #endif /* CONFIG_SLAB_OBJ_EXT */
>  
>  static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
> diff --git a/mm/slub.c b/mm/slub.c
> index b1f15598fbfd..80166a4a62f9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2169,6 +2169,12 @@ static inline void free_slab_obj_exts(struct slab *slab)
>  {
>  	struct slabobj_ext *obj_exts;
>  
> +	/*
> +	 * If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> +	 * Therefore, we should clear the OBJEXTS_ALLOC_FAIL flag first when freeing a slab.
> +	 */
> +	objexts_clear_alloc_fail(slab);
> +
>  	obj_exts = slab_obj_exts(slab);
>  	if (!obj_exts)
>  		return;

It should be enough that this return path does "slab->obj_exts = 0;" no?



