Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B01D44C48
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D616B0088; Thu, 15 Jan 2026 09:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C256A6B0089; Thu, 15 Jan 2026 09:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC0A6B008A; Thu, 15 Jan 2026 09:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A003E6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:26:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C9401B948
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:26:05 +0000 (UTC)
X-FDA: 84334422690.05.6D94EA2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id C394018000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:26:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="SjCXVf/h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A2kN+Uxa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AtRUrw1V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4CyY8kO1;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768487163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfTxd2GfKuJ3dsjZX+Qbvihtf44lZSO03FfpQ6Ft3Hc=;
	b=xYeDQiXM5/uD2pQ0HM5LxrLmV36i+eX8G7kE81rUE05zXATzi/Ej76Li+R1T/4RH7RcZXX
	wiKPffCHoaNL7PF8MAM7IUgsHCEzwt4I8Cr313CNVkrV9NSE8qr3HzeuXwMG6RukV5gPW/
	+ri75YEPEtLckUgF1wAoXca8+shMeds=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="SjCXVf/h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A2kN+Uxa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AtRUrw1V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4CyY8kO1;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768487163; a=rsa-sha256;
	cv=none;
	b=ZXAB/Kvsu9AefFfQ1A+TXhT77K7YK+/o+/AoUEVrveaV0vP5Q3EuUxaFAMMk9HLPRQEpMi
	9pZeJDtkVL2e3zc/UjFYyFOrhkwM9dig9iWXMmXwdesF/bCTCOfld5oSCQK/2H4F/0vYTX
	AY36iPdnj4yejwyDP2lKJ3z9Io/MOjk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C403C5BCEB;
	Thu, 15 Jan 2026 14:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768487160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CfTxd2GfKuJ3dsjZX+Qbvihtf44lZSO03FfpQ6Ft3Hc=;
	b=SjCXVf/hkxCWf9OE9sqi6iBYJCrYt4D53VlPrydF+HjNowKjI7aUqzf2cXT/kJUm0CJN36
	ZPQjpz7muzWpVHcWqzBX7utb8OobPpeL3HR80ri4YYJQCDaDkpygGFCXmPGQiVFYSr8GA0
	zlh9AYaM4ghYGJOziVIP2WC6zjYe2M4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768487160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CfTxd2GfKuJ3dsjZX+Qbvihtf44lZSO03FfpQ6Ft3Hc=;
	b=A2kN+UxaKDBrbs09pzxcPR0/bsIRZjRoIS5RY14/NPzsNdzMBhFmBPUm0Gc9gr+lCDvSCs
	qZXBiRoDAfpEzzAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768487159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CfTxd2GfKuJ3dsjZX+Qbvihtf44lZSO03FfpQ6Ft3Hc=;
	b=AtRUrw1VV55YNBaizuHVn4Ni6uOAux5IHU8K4x+CQKibmWkTft/ZLLRxPusc3O0NrSj0Ua
	jQ6qVhPOyKRxM+8PyRM1VLUT4reSJhGj5ncB6ASnvpvnfK8xP/7+24jE1LiZ2XeXF0anWN
	hOgro2bEOxl6v3lCZHYx8jF36hMTwLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768487159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CfTxd2GfKuJ3dsjZX+Qbvihtf44lZSO03FfpQ6Ft3Hc=;
	b=4CyY8kO1qh6VZwm/c8EsIIREjPYNOyQP9E0xjdHgsDxw+Y/oAiYRZpo61I9tPhp5wx+/YI
	PO4ThoS9qeBCeCDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4A793EA63;
	Thu, 15 Jan 2026 14:25:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 79zeJ/f4aGlOZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 14:25:59 +0000
Message-ID: <38de0039-e0ea-41c4-a293-400798390ea1@suse.cz>
Date: Thu, 15 Jan 2026 15:25:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 08/20] slab: add optimized sheaf refill from
 partial list
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-8-98225cfb50cf@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260112-sheaves-for-all-v2-8-98225cfb50cf@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C394018000C
X-Stat-Signature: gg77rxdqiakw9tc4egjtk11tku7ohzwk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768487162-909098
X-HE-Meta: U2FsdGVkX18JM/mqKIp/AaA97nMxgKMTbkDoZhz9n6Kt522gauR6mbasP/0NnYTpwCDnPohAfbgf+PmB03rX9ksxvFWyKXCL9yYg7UPXk/Fbxw3GxYWeJqnurSMDwc0tyhWuWnMbvifxaG6MwrnIUC88WlVlNUTM5xLGiheb4kzgl8wc+IJ1q88c3tK0Xg/24AMYT3A4iXz9oy9Us4OQa3uSNd6u1K80JV7zxzmIsBIOXq9DvYuOD6GBPK0k2qN/zDVPK9DLqn8GfQTrsi1mRkzK97sCNlNVHtJGKas4p5crhrwvSMGZ8NFMJpYxJNSAmJC9MgKevJkchnXEaXcJC1B6RUgaMmdN0Y7UBQMCpK6QNW5Jdm5ANTn9RRJ7mnPx2M0M3QTaHsxM8ifWaqygH5D88Mkz4ceEZuKvcgita2M7OvMV5MczQjWawXgGkxrMqKotcL0BN9vdHVmoDdh3h0BK4OsUMCtmFZzpjrOWDlOQvvYajw3Y26G8e/I4DmArl4Uz7ECrMWtfl5tdQxCUUNfwTiVT7AjQqPPRzGSbAuzNYGItsvYUGeh/gDgMWjJgDtzJIqwRoekPfB6hiYq7p9sdoZnODZKU6rZmjr9o6T6kvvZyMdFLBS+eDEnNnLA4mR87fDV7XxeVjFCNYZD5AKZgdDayaLViyZgrtLt5HN+a7wPvBGLJQaUAoDEFDdn+uIBzTErDONAIMM9F6Ju/IVMAvLNqQT3jqTydRNVuPreXxJTG1aHCCKiAfta48p/5ui8iuTcLnVuC4wOnOH2LmYdszcS3wHIk/+ppNnqG+2ES6xr3kQz8VmtgIHhLHL4q6Nc9RM0N6qf8Z/n5+D5thI3UHz75ZAfF2xG67JuZHEWw0I0Mxp239M/nZ90iaMzAVRyhZUgzRNVe9EAVehA2H8Pux8yntqVXgOZwA48rcP+OH5iGw/A2/TS6njpshvvfj7ZjDcZXV5lAwkZxECG
 Z7/iccbp
 0NZQInBmTVir8J8WBeiacAYJm68tdrRt47O4Mtwb2m3zjVEqwy8m6sbVwxILgdres7QNITZ3p/PDCoZCRQdGTfUmaUcg76IE0Z3SM13xiKPqrCpq1e0Atf1cqt3KolwHXENa8ZlAb0yJiZFgqRTacP9lORWaRBuxCIEvVZpnStl/hh8zi3aJ41c863u+4yZqKv+8hkxH1DtSWimPNd8UnMhD4p4JbwHKI2QekXpxnY9/tqAlUB8k7ju0WxGsWqYTH8vVm5VTAdzCdHIb/HM9xJaiE6UQldR97sFyK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 16:17, Vlastimil Babka wrote:
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
> 
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> 
> Extend struct partial_context so it can return a list of slabs from the
> partial list with the sum of free objects in them within the requested
> min and max.
> 
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list.
> 
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
> 
> Introduce alloc_from_new_slab() which can allocate multiple objects from
> a newly allocated slab where we don't need to synchronize with freeing.
> In some aspects it's similar to alloc_single_from_new_slab() but assumes
> the cache is a non-debug one so it can avoid some actions.
> 
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs. It is intended to be only used
> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> 
> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> only refilled from contexts that allow spinning, or even blocking.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

...

> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> +		void **p, unsigned int count, bool allow_spin)
> +{
> +	unsigned int allocated = 0;
> +	struct kmem_cache_node *n;
> +	unsigned long flags;
> +	void *object;
> +
> +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
> +
> +		n = get_node(s, slab_nid(slab));
> +
> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +			/* Unlucky, discard newly allocated slab */
> +			defer_deactivate_slab(slab, NULL);

This actually does dec_slabs_node() only with slab->frozen which we don't set.

> +			return 0;
> +		}
> +	}
> +
> +	object = slab->freelist;
> +	while (object && allocated < count) {
> +		p[allocated] = object;
> +		object = get_freepointer(s, object);
> +		maybe_wipe_obj_freeptr(s, p[allocated]);
> +
> +		slab->inuse++;
> +		allocated++;
> +	}
> +	slab->freelist = object;
> +
> +	if (slab->freelist) {
> +
> +		if (allow_spin) {
> +			n = get_node(s, slab_nid(slab));
> +			spin_lock_irqsave(&n->list_lock, flags);
> +		}
> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +	}

So we should only do inc_slabs_node() here.
This also addresses the problem in 9/20 that Hao Li pointed out...

> +	return allocated;
> +}
> +

...

> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max)
> +{
> +	struct slab *slab, *slab2;
> +	struct partial_context pc;
> +	unsigned int refilled = 0;
> +	unsigned long flags;
> +	void *object;
> +	int node;
> +
> +	pc.flags = gfp;
> +	pc.min_objects = min;
> +	pc.max_objects = max;
> +
> +	node = numa_mem_id();
> +
> +	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +		return 0;
> +
> +	/* TODO: consider also other nodes? */
> +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> +		goto new_slab;
> +
> +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +		list_del(&slab->slab_list);
> +
> +		object = get_freelist_nofreeze(s, slab);
> +
> +		while (object && refilled < max) {
> +			p[refilled] = object;
> +			object = get_freepointer(s, object);
> +			maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +			refilled++;
> +		}
> +
> +		/*
> +		 * Freelist had more objects than we can accomodate, we need to
> +		 * free them back. We can treat it like a detached freelist, just
> +		 * need to find the tail object.
> +		 */
> +		if (unlikely(object)) {
> +			void *head = object;
> +			void *tail;
> +			int cnt = 0;
> +
> +			do {
> +				tail = object;
> +				cnt++;
> +				object = get_freepointer(s, object);
> +			} while (object);
> +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +		}
> +
> +		if (refilled >= max)
> +			break;
> +	}
> +
> +	if (unlikely(!list_empty(&pc.slabs))) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +
> +		spin_lock_irqsave(&n->list_lock, flags);
> +
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> +				continue;
> +
> +			list_del(&slab->slab_list);
> +			add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		}
> +
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +
> +		/* any slabs left are completely free and for discard */
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			list_del(&slab->slab_list);
> +			discard_slab(s, slab);
> +		}
> +	}
> +
> +
> +	if (likely(refilled >= min))
> +		goto out;
> +
> +new_slab:
> +
> +	slab = new_slab(s, pc.flags, node);
> +	if (!slab)
> +		goto out;
> +
> +	stat(s, ALLOC_SLAB);
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);

And remove it from here.

> +
> +	/*
> +	 * TODO: possible optimization - if we know we will consume the whole
> +	 * slab we might skip creating the freelist?
> +	 */
> +	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> +					/* allow_spin = */ true);
> +
> +	if (refilled < min)
> +		goto new_slab;
> +out:
> +
> +	return refilled;
> +}
> +
>  static inline
>  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  			    void **p)
> 


