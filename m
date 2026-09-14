Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C28CC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A746B0096; Mon, 14 Sep 2026 12:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233616B0098; Mon, 14 Sep 2026 12:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149426B0099; Mon, 14 Sep 2026 12:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E862F6B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:57:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3911AA42FA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:57:20 +0000 (UTC)
X-FDA: 85212973440.06.55DEAD0
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5AA31120004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:57:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQQoaMWp;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789405038;
	b=mfgOTmRhXPLJYRaspgH5oSO5d/sriv+90Gs4WiDSYaHV3C4upDsTUhk3wNW6ToSfhsnw5f
	623dkMZkYd+0O0QuvbRWu2gES9M51+NM3uzEIb4xNhGCdy3vHCDkwwqzr+z6j5K6of73Et
	YKD8Y8neCVYG8lJxMze+yiAJc8ZjUCM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQQoaMWp;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789405038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QL8RwUf/cYtMAICbILIWEvYNZJnqZvkmMoFZxOMHTyE=;
	b=agUGpuVavhHDtQ5fPNwtuGFYrwR1vycesHFkgLYOIbJEulN/9lyOcmRBcWBXSFYkRi27qz
	FR0BEA9u/V8bo13k543AYrBIzkG3k5QpKHk1vKPGv/WjATo1R/oyMmCKQWCAOCWyhycm6F
	TqzbrTS18YQInW5XwkrBNMbn81uFVJs=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c294ad260fdso3176266b.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789405037; x=1790009837; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QL8RwUf/cYtMAICbILIWEvYNZJnqZvkmMoFZxOMHTyE=;
        b=cQQoaMWpPDUpTNwj8E5RfAioan/Riu6vPpGtFBBiB3XZwPBSK0b927N7/ao7yvq6oX
         tkheSs31l0Z76AfYyj0DIova4TWJyh/II6aLB2RqRRlBlabPWlDXQ8wZzQONetOQj+4i
         V2cg1IXfSCZvIRcGaEXldcNIb91UmGlCjHQRUqd8yzI51TlKWGibpOgPy5GtO4P1oFbs
         IXikBFictQK93pUB1J4AlgkVpo/wymZwhV96VlYf84hEys3sejosxeps7CYKGYqpr4Qq
         KorsV6883PAQzDPbF8ZXWG5NTsNingh6Xwr1/3dfT+yygx7IlLt0RyIY25oayE4wx5/8
         ZVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789405037; x=1790009837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QL8RwUf/cYtMAICbILIWEvYNZJnqZvkmMoFZxOMHTyE=;
        b=qHE9D/luuZwdLFYD+WmOl9AuE1DEBr51F9+gPy36P8S7UNbJeL6JgkgXAAjGPcXgit
         A+w19EZSHYfQtFpgAmSdl/A9E+at3nxaderS9f+GIyJOu5JumAZq5jRauZ/sA3ft8HH4
         iQJduK3V+p10dvJWZVIAqjdk4KRT2t/EioypAjIK/GlA7J6pAti+kB53PE7KuwJ0B1un
         ETd24l2HHDWZljdHggD8vyDeuVF53OHekx59+UFyVmIJEhrHRsg4pvreyq4w9t08PdW7
         t4F8lMHUDQopr/lD6mpLdWWM+pjFs0VwMiB894NLW6dRV7RxlRcGgAGKIIy95E1Od31D
         TTBQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8T8JyYE8lZwuGs4Z1QiDjsFrAUB8dWJWGtenUbkxnzFj4nV6XpFJ3pQJJo/N6Cf1UZN/GOUi+Mg==@kvack.org
X-Gm-Message-State: AFuF++lTT2CW//eO1u95oYhygU3mB6pWotYIErq5COXgj2DdmX9GSqcM
	HmICKrhba7UnK932SG2swTgyMOkOf9E9Gjstyp39jXP33SixVgMGB3xN
X-Gm-Gg: AYBFou1I1Rj1UstEeU9r2Lx/mPF+fIsuXjtVmZpB0FZ23u9X6jSKpcSJBOqsiMts9S1
	r30YekapoZ2X8yvCtCDAImYBvOzNwsYdHC068j7RQQBI0S8LKJf2ErSYm7rzYcMl4ODi1eFJe86
	e2L8Uavuu/uky9GYPrZzvpyem2TgooyJjTSPeq2zhmBk6Ul0lS57DjmMQC1ZwNRSFH98jSUhjRg
	Zxbgjat9n3CtHFLcuYArBIxjA1Mj4VQeSQ6DKpHRNSr9TquHnBXSzQzLnVQ+3yDzzj7WUCbjATY
	MeshQxH4SN3umgJKdFoGuLtJZZzY9T82MoguVlecc7Fnn7kJiqNPTjZfRKA2Akn6GemAU0wjjY0
	A+Akvo/VFwu1E0XK1iWzjWWm1Wp0+ZBNs/PknYv9JRLBhoTiwvjPK6pUMPmSMHt8COsdM2SqjCz
	aVrfkb9YOT/JRlP5vsUvEYckxJh7MWMZOoYnHc2aSIRK4IXUg=
X-Received: by 2002:a17:907:3fa3:b0:c29:3d25:15fc with SMTP id a640c23a62f3a-c29c8b91192mr20436766b.18.1789405036895;
        Mon, 14 Sep 2026 09:57:16 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296605c2bbsm452079766b.24.2026.09.14.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:57:16 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 14 Sep 2026 18:57:14 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH 1/3] mm/vmalloc: group xa_init with vbq field
 initializations
Message-ID: <aqgnahEAk7GAGi-g@milan>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-1-526f68559706@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-vmalloc_study-v1-1-526f68559706@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5AA31120004
X-Stat-Signature: qfxxp5x1tw493z8jucecttwt9bxwb7hp
X-HE-Tag: 1789405038-482361
X-HE-Meta: U2FsdGVkX1+19jVnqYX5mJ3vd7f77RRBEY/rmVL5pMiyKUDkV1EEzAy228IPJprskRX/zLC8RXNPJGm+PN9kagsWsFUPWsAtNKxkCcxOEvKc3xXXIFUQ+yrkFujAGTtvCn5MuDHBeH0H1P5cL64T546jzAs9GdNF1/uSFGZRw9B2Hum4WEQRoJSAYqJikOY+cozYHiSlKxgXncvkEK8HeQTD3po4TbuDzbnfZH5fhGPRneyVu27KXgXGjR625hVr22lAHjJvmhqnFSyUn0t9Z5hyWPmtqxqYY6vR01PnIqxSzlmq/itE/0QaxRua5f2z9/T6aQgS+1uXc6abFSXx+2ejIDIYWYJ+/7pAaUi9+iTVAx5FJX6wQ18x/qn/AX3UAWLzWUp3gnzEfye+y8K1BaeCFncgFMTpUkZdm2n09Pr+dmoJAEf3sGUzmYVqlMC4HkV2ivOr1ciC5cHfuydkrv7Ci1OTOfmDdSMYqQ4OYEMeU1hs0RGcNFUh68rccWihgIMyOdb5S1Wuh5LogndGO69qQ8PICQRWMDYasn89X5fOatvmkIINICUcwjYZ9B7mTqRRiYU/s5h0+27hvbDUbco3tyV8y/b8IeiIx0EJ7YtDcbTW6fepMsmlk0IonXQO9zE5ivijrUcM1JnrU9+Z5+tLSoQrHm2QDnpreIeYC1kFETIYQw0U4QwrF65z+YFgnwEHSTv2ZtnCNgEHysh9vnFFY+ujV7P82/eS643RVsv76YFUqipoJyoF3lrwdHaSi91hh6nnOjpebzTYJpU4YePpccjY+cEfQ9OPvSwn8P+tsI96X2L5uA1Gv2QHUCnMyeBWlawa+UIT3ftA1ma2r3EOMsK5EkFNQ3U/9AGkOTzjJ2lzT6AFvLMrgH1HsMZlz8WGScHZHeggxr60s71swRcUibQ58F/PLjeS8jLdXOZOJnYTeF4JvvSF5aacKdXk8OG7kULJzYmXMLJ+EfY
 f+EnFXWj
 aJeX+HHTAjSLg0UezzqWEXp3Prmlyf9Kva1EcCCF87qJ5fR4YYKmguK+U/q0ubtUWVMwRAbEJ316Q2EsoK/r3gC1uj/tDtmUWR1c3pMO0hD0KZFbMNiKB3jtJGgbeR/6e72DPPfQwgd60MqXER36xVt0FZEsf9k5sAkIRxYneeoHPBoM7cDV6wVavWOkZzd80KCl0Mx+UBeNKnb9UhmyPSv5GdGFG7mownJx9IhcOcNFOP1iQf4wt38iF0M0Sd2ZCd4r3ck49lOS/0ExJAx9RFjqsfXE2ZjE0U777dOcyfUg54FaepRpYDmsOlfdOkdAHbYc0MoO1yQ81HYy3nCpXDcJ8oIPeuxHKQC9+zmniS1rBtXMQga49GVQZxIb4i5dIiHvg5Bz8O8eZx2y+nqZuiHmYN7/c4F8Wu3l/y7N2Cq8ujRyIgcaZRhPpXm89JqOXym1nWtJtLtz9u3puJiF7pNMGrEEnbMl87MYucBHWUfNleznJZx116MkGuxjSiZd0Ivhr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:34:00AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Move xa_init() next to the other vbq field initializations instead of
> after the unrelated vfree_deferred setup.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 859e6d2d57a3..117483dd048c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5585,10 +5585,11 @@ void __init vmalloc_init(void)
>  		vbq = &per_cpu(vmap_block_queue, i);
>  		spin_lock_init(&vbq->lock);
>  		INIT_LIST_HEAD(&vbq->free);
> +		xa_init(&vbq->vmap_blocks);
> +
>  		p = &per_cpu(vfree_deferred, i);
>  		init_llist_head(&p->list);
>  		INIT_WORK(&p->wq, delayed_vfree_work);
> -		xa_init(&vbq->vmap_blocks);
>  	}
>  
>  	/*
> 
> -- 
> 2.25.1
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

