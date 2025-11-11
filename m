Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFF7CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCCD8E000B; Tue, 11 Nov 2025 08:13:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D3F8E0002; Tue, 11 Nov 2025 08:13:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835038E000B; Tue, 11 Nov 2025 08:13:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2888E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:13:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2821CBA1C1
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:13:27 +0000 (UTC)
X-FDA: 84098367654.04.CDDA014
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A74E180004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:13:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="EOIGsCW/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vWErObxf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cv2D4oFR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m8FsmAqi;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762866805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4IP2Ij1kIgre9FOWsT1hivuwcuK7qKmFs5s63y9LJY=;
	b=aGQYnSFM7NT/Xx3PCGQsYQPol2gqrGTMn9gY9GSJZZzondo3Mn9JkmG9JhzaySbzxmtEhF
	asRGOLg1EaQ40LQI5Kchu0Ks0Qon4mA+AqRJG/452eZBPwfOctsmAD9g9xsc0rqFh+QOIl
	RoUPeklOic7ImytQfNMqVDZSEm3vkdk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762866805; a=rsa-sha256;
	cv=none;
	b=BlrDDe/3ez1I6vjDVxacutTvYqe5pYXXGk+hGtFG2sFA1bZ3kKxlDJPQ160TlVrmAW0yUK
	VfG9YD1+7PAbApBYp1mtmDL4eaKy8sg+XomHN/ssf88XehhEjOjU4WZLD9RvlVoo95OUFp
	6/fCeLfWzlayNrSkLZkV/nUOPbqzSPY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="EOIGsCW/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vWErObxf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cv2D4oFR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m8FsmAqi;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A5D161F7B0;
	Tue, 11 Nov 2025 13:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762866803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P4IP2Ij1kIgre9FOWsT1hivuwcuK7qKmFs5s63y9LJY=;
	b=EOIGsCW/2VKTVH2VAuuREl0fNpIaRFneBMNAtkIkyaAzcKs5uCukyBAVTXcNaJ8IjDMDPh
	uuWn4cHjlEIVrfs5fdq7N3KdzFeXn3216K02r87PPSJQlISKlXdyixZzHMB4AQmC5YBuVg
	VHwFmFJ5EBQok9/hdY/zfr01BkJu9lI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762866803;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P4IP2Ij1kIgre9FOWsT1hivuwcuK7qKmFs5s63y9LJY=;
	b=vWErObxfdKf6zYA2bjpFvGlQl90S2iePY3FVhIozwrCPpq37/F85pj1cvXopry70x4jdPb
	tDWkX+rJwgtHABDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762866802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P4IP2Ij1kIgre9FOWsT1hivuwcuK7qKmFs5s63y9LJY=;
	b=cv2D4oFRRpLTe+mAHpXqrJU/KyGOKY4/fdfokOazlIGpE75sjBdQeUz9IMTEcTuiMzLfkT
	K7FjPKPCvSwzXSEb9DqvtPaYoQc6qf7p4imFfO8MWOJVYuq7mdPxl67idn32EF3fALGaTa
	gQDzwRt6qvBIGUnfC9SSWDU37oRO9OY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762866802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P4IP2Ij1kIgre9FOWsT1hivuwcuK7qKmFs5s63y9LJY=;
	b=m8FsmAqiBpQj0Wl6+U0BK3ccKK+wLjh2LvBWHdlBlu1rQmFmkQGbrTSYtmgxTETFqPfYdA
	rAm9aZpL1sVySVDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 842CB1498C;
	Tue, 11 Nov 2025 13:13:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sxTwH3I2E2mkUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 11 Nov 2025 13:13:22 +0000
Message-ID: <f506ecf9-8315-47b9-807a-f87a9902e118@suse.cz>
Date: Tue, 11 Nov 2025 14:13:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Tytus Rogalewski <tytanick@gmail.com>, "Darrick J . Wong"
 <djwong@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20251111125331.12246-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251111125331.12246-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A74E180004
X-Stat-Signature: ibd6i78wjpg9ji83faqnzmniepbraswq
X-HE-Tag: 1762866804-945762
X-HE-Meta: U2FsdGVkX1/U4i5C1v9Ftg423Bj6jxv74rFLicIHtGD7avkoEWAC2peI+kKM13ov0h4x2j0Dp6bYsHoLWejlJvhye29DDNe9RTLKlTKLiTcOEFgAiTscIkP30P/gp9lQ3oZG0IeYY1SuU8Rjip/HA4JOSIWRLTS+SIm36n5d+M2o4vyc8Rwec9xZDbG9WrZc6q584ZOE28yCCzJBkIsI/VBbDdR2S4paImfWAW9WFQ1rBZpnnPeLgluX4wum0EVwf+IlGnm8yjB59VDPd75dDERR8J4GULJvi3Ugi1j05CgOaSGKKtIV0VSSmyfPu7b2sQdNLrT2rn0teo3hkmZ23P5eQ/sOBeHS4jCKqaE/t+n2J/GFu+HXQeqgDEYd7LSAJHjgrcJih1AabRTjcXo6FTFUYdO4J8JLFbNmRgJieGZKsYZplkkHM+OxR1byyUDkvQ11BlnA27K8jCKpuDV4p/BxKN5wUPB/CuHhmzQUlITVlolJ0CsxOHU91bgqJtusIU6twc89HnG7QiUTv0gsLlBJF9bHxBaWQzbg//MEjngLqY5GDaZJvSvTyolQMcUB5d+t1YfFIGVk4YFj1eJs4uk/J+j3/cSpRZQ+n+nxxVSSn3SzbM6nb0BQPKJQgRT/tc6uVuDMNcDG+TDHyJc7ZRwZ105UYzY9z1NIOh5KAZQK+/sZcNDEeXba9+W/0b7QXC65KiItQfYQf8TStzac4qYRyWdH3EAZDCTtV3K29s7/JeQl+ClYWm7LTxsmngcEGImjsdAUIxTKj4MGNCT/BOHj60zSDn9SmJf/91XEdJPc4/8rzY762YSh1qGtbDbyWIMhWi+uFLrZbpKsOEGkFuth7cQVIDYpNo8NFVwYSDA2VYEwpH9AuWgNaO9zhigJKN75zM+bFTNz+lY9A6FlDiZbs+kjvSg3lZOcIjOxBQgxex95z0Jk2YzPaCYBC6id9jsEt1E+QqqtFHFQV8d
 fdMSKG8E
 MwzvOUjUQD6vLs2dvjoHl9GCaTK/dyCEdkmSi5RZWQtZYZEi+qMU9FYDlye6Vlh5/qXhhsjka2LCMWlxxTRdjwLxUgMvPepqDlOC/EW0BEi8kpprruZ3LgbVhqaLrJJVRAEyEKUoNAeRx2kvnIOG2mwcofJlH/EeiYdsXwmV2Sn5iAZf6BwTk0jrOjHx0pXBgD+1PjjlkdW8ExuxuO+5TGDjRqaIMWAXoUt9pfbTZvG+VyjVsKRfKPMyL8aK3ocIvZkujcnWxPddsxQkBo7R+Wn672uUrl1sFQ0itzNIHLXAcwa67vxOwE/qDeP6A91l4JW/1t+gE82C4KP4NFRcrjQZPrWIFi+TQJCLIEXgmr9DJnupC3weMxy/cZWNN1yZInOS3Sp+wTvhG4qRbk+bOBh4seKdlCm8bn0QFUScs8yiu/FYOSiFsZqZ4Emo4yvzDR3dc8OxWiHN14EM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 13:53, Harry Yoo wrote:
> The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> skip sheaves when objects from a remote node are freed.
> 
> However, the array is flushed only when:
>   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
>   2) slab_free_hook() returns false and size becomes zero.
> 
> When neither of the conditions is met, objects in the array are leaked.
> This resulted in a memory leak [1], where 82 GiB of memory was allocated
> for the maple_node cache.
> 
> Flush the array after successfully freeing objects to sheaves
> in the do_free: path.
> 
> In the meantime, move the snippet if (!size) goto flush_remote; outside
> the while loop for readability. Let's say all objects in the array are
> from a remote node: then we acquire s->cpu_sheaves->lock and try to free
> an object even when size is zero. This doesn't appear to be harmful,
> but isn't really readable.
> 
> Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220765 [1]
> Closes: https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org
> Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object freeing")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Thanks a lot! Adding to slab/for-next-fixes
Vlastimil

> ---
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f1a5373eee7b..a787687a0d59 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  
>  		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
>  			p[i] = p[--size];
> -			if (!size)
> -				goto flush_remote;
>  			continue;
>  		}
>  
> @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		i++;
>  	}
>  
> +	if (!size)
> +		goto flush_remote;
> +
>  next_batch:
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		goto fallback;
> @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		goto next_batch;
>  	}
>  
> +	if (remote_nr)
> +		goto flush_remote;
> +
>  	return;
>  
>  no_empty:


