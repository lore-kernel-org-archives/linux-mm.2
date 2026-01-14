Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE258D37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46BEF6B0005; Wed, 14 Jan 2026 09:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF0B6B0088; Wed, 14 Jan 2026 09:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D236B0089; Wed, 14 Jan 2026 09:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1689A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:27:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EC1713B35B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:27:22 +0000 (UTC)
X-FDA: 84330797124.02.2E340AE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id B59071C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:27:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MW4GGyfe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=74Ziwu1o;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hHY3ND4u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GUme21VT;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768400840; a=rsa-sha256;
	cv=none;
	b=UBa2LTIedcf4IOEObh9HlagCA0a6OO1AiSa3LF/dSYj10vUQy+koo1lyF2vtM30nRaRWob
	piOp8G4MUu+sRRld14SBHx7KxuJAV6pzbN8VYMCVFKimzx1scfY+iyZcIF21/Ewdi4nWRR
	0FdMlzdfb4jxJH+0+iA3ihqqnCiyNWQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MW4GGyfe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=74Ziwu1o;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hHY3ND4u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GUme21VT;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768400840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1v0fTkoGFDb/2np0GkwTVI3vsgeJZfvm+cmCONlDas=;
	b=VeP7ssdY3DfoiXKYJHVmFLJWUTDOiS/mAQlexR3t0gONu6n0OMeSUtWyoWZxCCBE9O0pcR
	VkPYHE8p/zIGdIKxeLzZ8PoN9gimr++ZerOLUF0Q+dUzwE7l2Zbj3ycfFc/XhzzV42AlAc
	CmX9U1NOs3FwJLtxVSbpnofqEJofMtc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EDEAB5C9B8;
	Wed, 14 Jan 2026 14:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768400837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l1v0fTkoGFDb/2np0GkwTVI3vsgeJZfvm+cmCONlDas=;
	b=MW4GGyfeD0H7IgguxMIa/dYigPdhrxD4Z3yvY7MhjhSiUg9bjmx4T6mMsvvmOVhevTqWlh
	31HCauJzcC92UmslUAgwrxyDVonaoTub6QWNF1+0n99JlHmzQUX/L2gCEznO0Obmkwgvpd
	qLnVDR8Ge8ad7EdfjAXcS/YuKdGFB/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768400837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l1v0fTkoGFDb/2np0GkwTVI3vsgeJZfvm+cmCONlDas=;
	b=74Ziwu1owD5J4geJcvPlUD03GnMXK+HKYH3tuHSnLMFgBNAc3z1FgXDN3UR0kMki59HZwE
	nOD4ft32O04b2ZCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768400835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l1v0fTkoGFDb/2np0GkwTVI3vsgeJZfvm+cmCONlDas=;
	b=hHY3ND4uN0cYet/7VWBW3y2R8NXoagb+5Rxgi2abwvsDNro8+UqxQQLvRwNCIFlrP2STMR
	LIy1RnqHZbWNxY2ue+RIvyaoggBiwiNX0cZkN2HVSmNjJiNsk5QgAzWSZXlP46CmHPuRa0
	UrCCnRl8r/T7llospToIoJ2HGZhDXcs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768400835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l1v0fTkoGFDb/2np0GkwTVI3vsgeJZfvm+cmCONlDas=;
	b=GUme21VTNXlFWevXsX5cmlTrN9JJgiwozTGx5imoWCX9R83M6CNecchjx/dEon2mbnFcsI
	LUNE7jf1wl0NOqBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C28E43EA63;
	Wed, 14 Jan 2026 14:27:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EbC7LsOnZ2nwSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 14 Jan 2026 14:27:15 +0000
Message-ID: <dd21a95e-3c78-4259-a20a-4d580bea96ee@suse.cz>
Date: Wed, 14 Jan 2026 15:27:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slab: fix kmalloc_nolock() context check for
 PREEMPT_RT
Content-Language: en-US
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>,
 "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT"
 <linux-rt-devel@lists.linux.dev>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
References: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B59071C0005
X-Stat-Signature: o955ygwgd4jgyia6hajrqfggdy3ak14w
X-Rspam-User: 
X-HE-Tag: 1768400839-161937
X-HE-Meta: U2FsdGVkX1+KSFBpuBPeH+lGVu7d+fLHKxhOHwD4QANo6HnpQ75n5L2trqHLOLop6Q873Ynn1J18yL4kdNgI3uQDzghd5FNtmpi6QDOK/OvfRjYEkd0GS2gRHl2wgyjoyPvQxNzXe+zkGdr7MVDSWDnkBTTrJgnW1xAOFFZbFHZRnkEjmIrYm4ji859sXZnGJWmmvDB9J3yuDOEkO0KZgrBbYFbopoEE1AwtzR/ynFGHL258ke19nwhMOz4iO50CuL+MhwinUb1I+Qh1V/1hBHQVuAXj2pcT7PF2JV790KQf3Mt7EaSwtWeLLJd8evHheXvfbLpKl0HV4YUAl5R3aZ1GFLZy9+pP4g2Q43ScrVes7SZQdj4zCvH2Xilu/VOpVDADINE3d+4ZsqGaRi57+xwyhQKkbR+oCUJCWYbvnHn7xWep1+/pTkYNKSccJZXtDk+tuxf+xrX9zJIF5AG5eRXdforB5W7d+bgtOzjsNwswJJpC2rQvdykuzovjKJoy555/XX9ZfZ9lgJU8ZnBraEtoGcJ4M3YWOOkxF9SKy8ve4hOVp+8MBURV9LqYBLWGfIFuptlfbjdzjTRs4C2ox5cR/drTLdLo5+u9MQaylvaGCk2ZksBl97FES6Inwh2oK14Bl94Ec9AS8Hq4ypDqJqTE6CLB88oiSIpdSM8z2kCwoT4wVUOm1CAfgyDSuiPJyRaugqUbzmYewX3yncj+PemIBIJGtcUGn+Xg+XcGw6y05i7wQSOPPECrUDf6CfZf9uIxcdXS3F6iiBlDQlnW1nU7YEJtoNjLKveXCjQY9WRrIrgandehepQWWRBNT3Hlzgtf+JwGAWID88SW9O4pdvcE5PDv3McF7peC+4geRiDWzj+jieL1T2z+75FY8ihciEN3758KjxrnAAhvh+9+gXiqtX0/iyl//0rSsZzDtnbMoDlUCC2q3PzIYsMVt9RP+o93+p4gii0o4wHJLzA
 Pxk2q7lr
 A7yIXekeQrgyHI7GWVhHCUcm+CCZ/7ssSseW/fee0z7aFI2UMgYyajj4FMXldmASiQXCXr/yT5FP7CCIRaunCrCdnNFhwwp+UVp28SaBxPLOZRPQDeIopNVTfZRgLaR5DZQL6p6jz7ESi61OatJ+SMAPrcBqCreCqkpo0cWI1SOvVQESJ/oHrBI5jhaOnegKELWcht2N3IxD1byoAXT/bjtQRerH7z+rLz2x/pymLTXzQbuqBQlUnvjCXBDhjxeQtUR3ywVO3Ccbz7Kj+l2/1kMqxrnqai5eHQaeup780YaNyXhf0pv2ZNJUL0/kqWZis2OIdkTZVr+XMtg5Y4wyaCHFns5gJXyoDEN+EVBRDHPgtaKy3FnspCBdCN/kvSGN6aDHqwTTDnyPwLepLIIWNSBZkenI8kYJ2B70tnhRk9R0nONOS7+SzSyzPkU8m2ASZ6n3V6C3aXX+ROho3pJOWfOMcAvHTirD/fLnvM6qEZ9tOGdIXEK+hCE/SWei0TUExt4/CAbmr6NY6kVJOJ1V3M/LJhBWRqZuQ2+bq2g0xApJXPX6+9RVa62RVJLcVpLcontXi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 16:06, Swaraj Gaikwad wrote:
> On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> context, but misses the case where preemption is disabled.
> 
> When a BPF program runs from a tracepoint with preemption disabled
> (preempt_count > 0), kmalloc_nolock() proceeds to call
> local_lock_irqsave() which attempts to acquire a sleeping lock,
> triggering:
> 
>   BUG: sleeping function called from invalid context
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
>   preempt_count: 2, expected: 0
> 
> Fix this by checking !preemptible() on PREEMPT_RT, which directly
> expresses the constraint that we cannot take a sleeping lock when
> preemption is disabled. This encompasses the previous checks for NMI
> and hard IRQ contexts while also catching cases where preemption is
> disabled.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Added to slab/for-next-fixes, thanks!

> ---
> Changes in v2:
> - Simplified condition from (in_nmi() || in_hardirq() || preempt_count())
>   to !preemptible() as suggested by Luis Claudio R. Goncalves and agreed
>   by Vlastimil Babka
> - Updated comment to reflect the more descriptive check
> 
> Tested by building with syz config and running the syzbot
> reproducer - kernel no longer crashes.
> 
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2acce22590f8..642f4744d5c6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
> 
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
> +		/*
> +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> +		 * non-preemptible context because local_lock becomes a
> +		 * sleeping lock on RT.
> +		 */
>  		return NULL;
>  retry:
>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> 
> base-commit: 559e608c46553c107dbba19dae0854af7b219400
> --
> 2.52.0
> 


