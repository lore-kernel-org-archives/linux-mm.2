Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4D0C44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A8E6B009D; Tue,  7 Jul 2026 11:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703D46B009E; Tue,  7 Jul 2026 11:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6429C6B00A0; Tue,  7 Jul 2026 11:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 381296B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:34:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B693C14046F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:34:46 +0000 (UTC)
X-FDA: 84962378172.26.001536F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 53F3A40003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:34:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G11/WMN5dE1Bd8sP/K8r9zEJI1qpmCvNR8L9pw/8bZ8=;
	b=RYqWIO8VBAIL0nknNI2y4mq5qw86s40tpMeXdRGya2wpl5N9tdXaLFHFzKBK3QPpakd/lW
	O0JSuLQZfXUtuoMwnf/NGIihMhstAMPDzNxVBKPrLJHYlksKmtacJQAwUq64O/KxBtquYc
	QFxTvegoxtQh52Xu3ESMuAH/kotrs2E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438484;
	b=U8Ssq1C/X6Z8p+uwE3ClhpyKfQrTGQy7bLGbMWTJJJpntAN9JPIXmk5NKrDmGwUiu5peG9
	C8LjHTg3jREUG0VrjH04vxAu6YnpCqYTWScY/uhfCLbfiCE6OPATD7mdrEK3i6U5p8MkZ9
	Y65CAbj7FWG4pz6RiIhZtXrhNXjlJ84=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gvldp0Vd6z5BNRf;
	Tue, 07 Jul 2026 23:34:38 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 667FYUXZ094331;
	Tue, 7 Jul 2026 23:34:31 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Jul 2026 23:34:33 +0800 (CST)
X-Zmail-TransId: 2afc6a4d1c89061-0a291
X-Mailer: Zmail v1.0
Message-ID: <20260707233433577tAGELJALunrdd2lZy83V-@zte.com.cn>
In-Reply-To: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
References: 20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org
Date: Tue, 7 Jul 2026 23:34:33 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <vbabka@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2xhYjogZXh0cmFjdCBfX2ZyZWVfdG9fcGNzX2JhdGNoKCkgZnJvbSBmcmVlX3RvX3Bjc19idWxrKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 667FYUXZ094331
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 07 Jul 2026 23:34:38 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4D1C8E.000/4gvldp0Vd6z5BNRf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53F3A40003
X-Stat-Signature: uox5qs5e6cbkkrmm5j9aoetm1uu6rm6o
X-HE-Tag: 1783438481-879596
X-HE-Meta: U2FsdGVkX18YOnS/+DhlANG0nRQa4qrra8UwiER7LSkaoSUbCGwfBfHdkBDeoBebBM22JYtztJLjlRasPGPC1i79Xvlagnb7ImfvSl2I79A284j4TQoenIZWhkOwU6hmbGqtmo5DMxJ0WYD5/CwNW/33+RLqvaGp3OvftYWh6xkLgUFYIhZJVoSblpZibL9Ut5vXFTJK9snwnayyn6clQ2oeJ7fXovOuwFZ9u2i2Jw5BGoPc1QJh66X/SaSBTuEZb3JoxDVhmaPv9j1Iu/L8aEmZ+Z786UyjLnzfLQcWqkMfss9gBO2Yt8iMK14MJYhENGHd8TRcaPlQL5XLEyB9cNpjFlzb1oHAtCWpz9uVmRJJHXWJwscNsjMs9sWbNHq9BbD0sJ4QQ5MSoD0VPnLjAREMNTUkt/Gt9ufs/Vy3m1fulW2ZG/K5Gg/5bS+pEPZOk5LSVmcOBBBnn4QcvKyBLOPgTdy1Ulblg/rcDSb3YPIYBOR8VZc2SuV4X7s8lap7f/f4YC7xHG+ThjEdufTrQclrc4gOjaaQlEgCiQa9Q3DS+eXsdLxFpcqa0jowj5LiuPfut75aCzrHy/dml5r5xU1e36T91dMa1U9yPKk1Fpt0X4W3fA7u0o80aNbVAopvnehIjm8KuUa5o0T0djvfK+7ClhijQQmIYIgWGGBGuW5ncT+tT4GHB7EnTYMCjNH5ei52FW0MlKPY/j6e5fF3/LEkPFKBdKrCf2hVZHmoHUxuQUXWxSxQiPfG0A59eduqztf4CgCTux1es14yFdDmis8cCvRGxQc4i8xTyqhlGUcK4QuB01SDMPh27CUxexbhui/M/JUDDa60rQ/gQzkgN+jVLzyZ0NlFvs1uIp0yVHpZZmnJadnKwt1Op3hGYXtGtozNan2xfWQRhXig2TdWrNy/7sadlNef+JI6//rM2AyBO7qWk81z2BfMQBQ7HDa5ROCsDMgVt8dKfKY6JHP
 9eHlqyYN
 MYDQ+RLrWvTWaZiTN5EMUAH6C8mrVuCw5OLorY2OVQWgvSjko5JBgjvtHfQS2DqR0rGbCyiC6TewzYsGu7OxtVCC/R2ALo1jh6OeEjJZJpUlPlMRowBkUZbx298nqPGxDITNPIlfg6ZKkbQ5QWJ0b0q3xg93yRDRB08V4LUlJPxE77WNUylWA7U3VwqxqS4fO0XbsR1652kXmrA8vx+ehTsoecMZ70hHEbaYcIoorPtnJFCMNHKgZDlfRumaV3e2fTW0iVZSYKr1+ni4MU5Dbv+QgylisEr6bu1Ub
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> It has been noted that free_to_pcs_bulk() is difficult to follow, with a
> number of goto labels, and this has contributed to two memory leak bugs
> in there.
> 
> Extract part of the code to __free_to_pcs_batch(), which focuses only on
> freeing free-hook-processed local objects to a percpu sheaf, and
> returning how many were freed. Zero means a trylock failure or no empty
> sheaf available, and thus the caller should fallback to
> __kmem_cache_free_bulk().
> 
> Make free_to_pcs_bulk() call this in a while loop, removing all goto
> labels from the function. __free_to_pcs_batch() retains two rather
> straightforward ones.

Hi Vlastimil,

This looks like a very nice refactoring to me. Splitting out the actual
per-CPU sheaf batching into __free_to_pcs_batch() makes the control flow
in free_to_pcs_bulk() much easier to follow, and also keeps the fallback
handling clearer.

Please feel free to add:
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

--
With Best Regards,
Shengming

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> A followup refactoring to Shengming's fix.
> ---
>  mm/slub.c | 116 +++++++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 61 insertions(+), 55 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 65febe957886..3f13f497aab4 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6203,51 +6203,21 @@ static __always_inline bool can_free_to_pcs(struct slab *slab)
>  }
>  
>  /*
> - * Bulk free objects to the percpu sheaves.
> - * Unlike free_to_pcs() this includes the calls to all necessary hooks
> - * and the fallback to freeing to slab pages.
> + * Try to free as many objects (already processed by free hooks) as possible to
> + * a single per-cpu sheaf.
> + *
> + * Returns how many objects were freed. Zero means failure and the caller should
> + * fall back to __kmem_cache_free_bulk().
>   */
> -static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> +static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void **p)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	struct slab_sheaf *main, *empty;
> -	bool init = slab_want_init_on_free(s);
> -	unsigned int batch, i = 0;
>  	struct node_barn *barn;
> -	void *remote_objects[PCS_BATCH_MAX];
> -	unsigned int remote_nr = 0;
> -
> -	while (i < size) {
> -		struct slab *slab = virt_to_slab(p[i]);
> -
> -		memcg_slab_free_hook(s, slab, p + i, 1);
> -		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
> -
> -		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> -			p[i] = p[--size];
> -			continue;
> -		}
> -
> -		if (unlikely(!can_free_to_pcs(slab))) {
> -			remote_objects[remote_nr] = p[i];
> -			p[i] = p[--size];
> -			if (++remote_nr >= PCS_BATCH_MAX) {
> -				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> -				stat_add(s, FREE_SLOWPATH, remote_nr);
> -				remote_nr = 0;
> -			}
> -			continue;
> -		}
> -
> -		i++;
> -	}
> -
> -	if (!size)
> -		goto flush_remote;
> +	unsigned int batch;
>  
> -next_batch:
>  	if (!local_trylock(&s->cpu_sheaves->lock))
> -		goto fallback;
> +		return 0;
>  
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  
> @@ -6293,29 +6263,65 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  
>  	stat_add(s, FREE_FASTPATH, batch);
>  
> -	if (batch < size) {
> -		p += batch;
> -		size -= batch;
> -		goto next_batch;
> +	return batch;
> +
> +no_empty:
> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	return 0;
> +}
> +
> +/*
> + * Bulk free objects to the percpu sheaves.
> + * Unlike free_to_pcs() this includes the calls to all necessary hooks
> + * and the fallback to freeing to slab pages.
> + */
> +static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> +{
> +	bool init = slab_want_init_on_free(s);
> +	void *remote_objects[PCS_BATCH_MAX];
> +	unsigned int remote_nr = 0;
> +
> +	for (unsigned int i = 0; i < size;) {
> +		struct slab *slab = virt_to_slab(p[i]);
> +
> +		memcg_slab_free_hook(s, slab, p + i, 1);
> +		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
> +
> +		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> +			p[i] = p[--size];
> +			continue;
> +		}
> +
> +		if (unlikely(!can_free_to_pcs(slab))) {
> +			remote_objects[remote_nr] = p[i];
> +			p[i] = p[--size];
> +			if (++remote_nr >= PCS_BATCH_MAX) {
> +				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +				stat_add(s, FREE_SLOWPATH, remote_nr);
> +				remote_nr = 0;
> +			}
> +			continue;
> +		}
> +
> +		i++;
>  	}
>  
> -	if (remote_nr)
> -		goto flush_remote;
> +	while (size) {
> +		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
>  
> -	return;
> +		if (!batch_freed)
> +			break;
>  
> -no_empty:
> -	local_unlock(&s->cpu_sheaves->lock);
> +		p += batch_freed;
> +		size -= batch_freed;
> +	}
>  
> -	/*
> -	 * if we depleted all empty sheaves in the barn or there are too
> -	 * many full sheaves, free the rest to slab pages
> -	 */
> -fallback:
> -	__kmem_cache_free_bulk(s, size, p);
> -	stat_add(s, FREE_SLOWPATH, size);
> +	if (size) {
> +		__kmem_cache_free_bulk(s, size, p);
> +		stat_add(s, FREE_SLOWPATH, size);
> +	}
>  
> -flush_remote:
>  	if (remote_nr) {
>  		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
>  		stat_add(s, FREE_SLOWPATH, remote_nr);
> 
> ---
> base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
> change-id: 20260707-slab-simplify-bulk-pcs-a8d0478feef6
> 
> Best regards,
> --  
> Vlastimil Babka (SUSE) <vbabka@kernel.org>

