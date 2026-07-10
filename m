Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6258BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2966B008A; Fri, 10 Jul 2026 08:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453916B0092; Fri, 10 Jul 2026 08:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345C86B0093; Fri, 10 Jul 2026 08:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0CBF6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:17:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C82DA0414
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:17:22 +0000 (UTC)
X-FDA: 84972767124.26.D4D3C20
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 677851C0007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:17:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uPxhxBfJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bojB2edu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uPxhxBfJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bojB2edu;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBwrVz2fgaureVqk8n3H3VymA2WLTvgQYFJq8nXiOwA=;
	b=w4JIHIz9wBgjYkOVxB0rrxSN6NPuGD7hCu3ju6ZCUoc3ACFwGLWI77WfjhjB+pD6fJt56p
	skg2+zOYpVeI1NpLSWPFCby1+Km6jDaxZTqudL/tSbpcFdio9VgselSOvRVa3zo6MY6TLO
	soR0a+bsBQYNCg003Q9Oh+k6lojWXBM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uPxhxBfJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bojB2edu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uPxhxBfJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bojB2edu;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685840;
	b=REyaSl7pluNJyEvj0Sukghe4H6mSAdbBQ6W+9cOGCzSE3vPD39b+nyfgtgleBp8gT3jOcX
	nxEf8m6U0B54X9fMSxzoKN0l2+aJt8FuD6JVZhRGNow6wdPni5LiS4GhfyNju+tpD8f+4P
	U4h9DaYhVAvNYLY7AMpyEdxrIElN34k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A48375BC3;
	Fri, 10 Jul 2026 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783685839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBwrVz2fgaureVqk8n3H3VymA2WLTvgQYFJq8nXiOwA=;
	b=uPxhxBfJzjYJtVdWkN80jYm7LAxyLfMne8/+hcHSP0iPISThH4ZNXnA7aEsmUAJlFN5qYX
	HHbKxBZ2ybiSuIDX/zpvxeiANW6Jr/TuVOeemZY+O25K8infjCKSjWvSpoSUjjpw0QzVUX
	BpftPqD1O7lKZId2g+qhBVFtvcdUcGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783685839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBwrVz2fgaureVqk8n3H3VymA2WLTvgQYFJq8nXiOwA=;
	b=bojB2eduFQUP+QTcwHK6P5QLmZ9aW0yhJDb8k8VL8U77TsH1ugjB22zINIy/zD2aKSYs08
	EyEQY/IeReiNi8Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783685839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBwrVz2fgaureVqk8n3H3VymA2WLTvgQYFJq8nXiOwA=;
	b=uPxhxBfJzjYJtVdWkN80jYm7LAxyLfMne8/+hcHSP0iPISThH4ZNXnA7aEsmUAJlFN5qYX
	HHbKxBZ2ybiSuIDX/zpvxeiANW6Jr/TuVOeemZY+O25K8infjCKSjWvSpoSUjjpw0QzVUX
	BpftPqD1O7lKZId2g+qhBVFtvcdUcGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783685839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBwrVz2fgaureVqk8n3H3VymA2WLTvgQYFJq8nXiOwA=;
	b=bojB2eduFQUP+QTcwHK6P5QLmZ9aW0yhJDb8k8VL8U77TsH1ugjB22zINIy/zD2aKSYs08
	EyEQY/IeReiNi8Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63F9E779BE;
	Fri, 10 Jul 2026 12:17:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V4X1FM7iUGryRAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 10 Jul 2026 12:17:18 +0000
Date: Fri, 10 Jul 2026 13:17:16 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Shengming Hu <hu.shengming@zte.com.cn>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH slab/for-next] mm/slab: simplify freeing remote objects
 in free_to_pcs_bulk()
Message-ID: <alDiNYqWzXKWFGXb@pedro-suse.lan>
References: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
X-Rspamd-Queue-Id: 677851C0007
X-Stat-Signature: u4g4kmzpfbgmjeuxxspog9bgboy4dux4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783685840-121488
X-HE-Meta: U2FsdGVkX19JKyHxE70pNn6RuGIBxZj0TQTH+gH5dggu4+wXrxzAeb908+KWeZUMbpwVhTvclnome8QfZeqHpulBxMrMBn2oehhqh6RwuhMOcoqA1T3rsNdWqFytoM8v5Gb4z7rSZMaB+TzfiXnsRd6zzos4WwgYs5be9JGnyyntQACv5NfETxVPkYyNpNHcdByFMcqgmHECbdhBWQ65oZ0GNZZz//yhuSERH4VME77LTxi9fR9ZSD4AAAqdsayBtAlNajfm3cK395GwYISFKJpIjJVQAN+nPygPMp3CCwY7fsyMzcIaSZvUUsua7JXfoihsWIVchwWwnTwB7sDF0DpDhgtGPnbTeWQDNAOIqWwZJZRAMFwpiA06DLJlAu3n/ArjVmo2VqM2uvM85T1ZXuINkTX8+GSCedqZnjV98TuuZ1uDmJlX/t20vvoT7dYjPB5TNuuymErWbvhjMEfumUugl14bOCTccC+Whcxn9HNDoCgi51wY4AzeSQWKeWp0zjO+kuTz0i5J0yXmXT9/A+YDtzUNRMT7ga5YAJH8j+5sSNLn7ktFKNfberdzZrDuzbKqGX78ZTVa/igEMmbR/EYYkPnqrD+T6Cq4vy2Irg7BO9XcPGORhfVvkouA8XqwSHq8NNPXnjvq2ZCBJXSJEqJnduBNVeIUeInRFh11L/GL79pzHkPtVceS9BtNiUTI+7T/7UVjqc0V1W1V7jICGpEc4sdfdy8Fpd0inxrcm09/9ZNM61hEcyr6+fpExjiOGJSOSQ0kLA1FYdKo+vV38hsDeZgdvqmvETH0fn8oD1nIzFTCPL3sVOQ6R2ThkN3Fhvb6K/Y65AlfLnDMrpG21bgGkUUWwhPrn2dAfW8SETjkZRdsxBsjNdcdeBkDAVEvWV62ROKVQQJ6jGiN4zJeUDnqNBVbzdCiYGCmcpvO35m6msyclVXqT96rNI9WoxsCLhpbfo4HTN+O6j8npC+
 +OPC5gOT
 FWpIauWhZD8E7l+Jf0Z2wftO7AG5VG8vGCPb7u3cu3CpTkyQwQhuXtX2oXa6ZYI7+BHnXk2vs7PV1qXZyeemsZV/IipXlYMLw1IKXFL1ALOrH3mqnTmww6gi3kM3d5Inttjdw7/xVK5iv11Z+lW4qcUhv3Zw/ipSnOApwrhgFV4FcacuuZS5EHKC0KT3YEVR/zmXVFZ3xkeZWvfe8TcmNyS7mJdk/2+VlhriBnlRSimug3yL4On2NjpTugGAKyp2hLpRtH3FiNEuJURc6gxXymWgCZbsILVCtdcafRMw1VUGGrwmKxEy96+MgGTR+Fy1qYgj7tb+VdufVSws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:04:58PM +0200, Vlastimil Babka (SUSE) wrote:
> We have been moving remote objects to an on-stack array and flushing it
> when full. Instead, we can swap them towards the beginning of the
> supplied array and bulk-free it just once.
> 
> Also add a comment to explain the rationale of freeing remote objects
> last, because now it would appear to be simpler to free them first.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> One more cleanup I realized it's possible when processing feedback to
> the previous one [1]
> 
> [1] https://lore.kernel.org/all/20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org/
> ---
>  mm/slub.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 22045dc919ef..966d2fb114e8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6255,7 +6255,7 @@ static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void
>  static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  {
>  	bool init = slab_want_init_on_free(s);
> -	void *remote_objects[PCS_BATCH_MAX];
> +	void **remote_objects = p;
>  	unsigned int remote_nr = 0;
>  

Maybe explaining what magic you're pulling off would be useful in the code
as well.

>  	for (unsigned int i = 0; i < size;) {
> @@ -6270,19 +6270,17 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		}
>  
>  		if (unlikely(!can_free_to_pcs(slab))) {
> -			remote_objects[remote_nr] = p[i];
> -			p[i] = p[--size];
> -			if (++remote_nr >= PCS_BATCH_MAX) {
> -				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> -				stat_add(s, FREE_SLOWPATH, remote_nr);
> -				remote_nr = 0;
> -			}
> -			continue;
> +			if (i != remote_nr)
> +				swap(remote_objects[remote_nr], p[i]);
> +			remote_nr++;
>  		}
>  
>  		i++;
>  	}
>  
> +	p += remote_nr;
> +	size -= remote_nr;
> +
>  	while (size) {
>  		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
>  
> @@ -6296,8 +6294,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		size -= batch_freed;
>  	}
>  
> +	/*
> +	 * Processing remote objects last decreases the chances of cpu migration
> +	 * while freeing to sheaves and compromising object locality
> +	 */
>  	if (remote_nr) {
> -		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +		__kmem_cache_free_bulk(s, remote_nr, remote_objects);
>  		stat_add(s, FREE_SLOWPATH, remote_nr);
>  	}
>  }

All-in-all, LGTM

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> 
> ---
> base-commit: e1fa26489025d6deac76d1dbfe2e0720a3ad84b1
> change-id: 20260710-bulk_free_remote-7fbe6f3abf5d
> 
> Best regards to everyone but Pedro (btw this is not hard-coded,
> there's a config option for this),

I know there's a config option to change your signature but I haven't
been able to simply omit this bit :|

Anyway, I get a stray, you get a stray review. Nice trade.

-- 
Pedro

