Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF0CCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AECE88E000E; Wed, 22 Oct 2025 14:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4848E0003; Wed, 22 Oct 2025 14:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BC68E000E; Wed, 22 Oct 2025 14:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 865238E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:00:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2339D1608B8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:00:02 +0000 (UTC)
X-FDA: 84026513844.27.57FE2E0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9E1F11C0007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:59:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S5Ws6VZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h8uIG2fp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fVjNoCkz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oPGTYGUM;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761156000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1yHQMqazpboWI+TSW3xPU/Qy5qrxJsWnX2WlOm+nFI=;
	b=V7yNTktNjUIlLI6oHhvYjcRe8/VMLYOFUX1xPHBv6GOG3PF9mOPNcZNF6OPcOohBP+8GUH
	s9kd+LT/GONh+CvCcXaiyswsmp3FO03k9Gmi6bjqjiHP9blyJsdn7iS6Fet5gsmuLdeZlO
	1LOR0Yh9C5QIVh4o7yk2vSmGbKX3IQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761156000; a=rsa-sha256;
	cv=none;
	b=iU+ibWkXYwXjdH5Uy+heT8LJ6ROASFuljg9a+X/EF6WFWS9Tg8djkJos2GaWbNNRU9sPaG
	eBfqLDjZ92EYJxi9H48te9HtfVlc5UH7GZ0elVvffV/LFILnfmP9myX3aQXFYTgKqvuJu8
	TLHKvB9ebuvUTLWFvc1O3roZlaFUrd8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S5Ws6VZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h8uIG2fp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fVjNoCkz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oPGTYGUM;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0B0B211EF;
	Wed, 22 Oct 2025 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761155993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L1yHQMqazpboWI+TSW3xPU/Qy5qrxJsWnX2WlOm+nFI=;
	b=S5Ws6VZDQpXUs8hKP+1klrluTXUmm6/DbdW1+GWKalcN8mugpKRJKMO7hoANcuhEVb+Ff2
	Zr0wH7ArFZWUm7ROsBMAMofen30N1jABYTSr451WX/Mms4BahGeve5g9F9crkSFQDEFITT
	SEGzNqv7vMK4D6EPsC7RGAdeS/4i+bE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761155993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L1yHQMqazpboWI+TSW3xPU/Qy5qrxJsWnX2WlOm+nFI=;
	b=h8uIG2fpLajdmf8JJafwm4+maTWMS3GAbkprZ80DGDcJpkLjAJZVvXTWfYGE9S2Q2NQSTy
	StjMcAkVMdsremDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761155989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L1yHQMqazpboWI+TSW3xPU/Qy5qrxJsWnX2WlOm+nFI=;
	b=fVjNoCkz/IH+9cRgyV5by3uyVhZZPW5zcsdv7lWndUrJtcEHk/utbOXmCYmJnmLcvT+n0w
	H7zrcE+CdCSr+UV38CT4S/ErNBVXCnnbfjf1pFiRArbcD/IM8B3r6OaC+pvwX9NDdl0+GC
	Ig5qytRywayPc7jZ6sqyvbUJlD3JQzg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761155989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L1yHQMqazpboWI+TSW3xPU/Qy5qrxJsWnX2WlOm+nFI=;
	b=oPGTYGUMgMXb5U22xD4oi3PE9iIkNU0DqZgGrjK3t0ll2b8jAbu/Y79cvyr7oEwQ9rRAuR
	knhdYvyyGyry0UBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD30213A29;
	Wed, 22 Oct 2025 17:59:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B3ruKZUb+WhebAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 22 Oct 2025 17:59:49 +0000
Message-ID: <53f0cc42-e19a-4b84-8631-390cc5b178f5@suse.cz>
Date: Wed, 22 Oct 2025 19:59:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: perform inc_slabs_node() as part of new_slab()
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: nwrb1rsrrbsbrc45z5ae7oh5pbqdt379
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E1F11C0007
X-HE-Tag: 1761155999-158137
X-HE-Meta: U2FsdGVkX18Fnqg0NSYI/MR0CBSMVF8cTATGz+j3dF8iD476ClfUU0VF8MbOlCQbmaafxllGEp9GAA3kipQ1JENVghykEfp7oYROYS2eAYi5ToNMtMwRztfhhk6kUQRylAL7UAaDfDadgxH+KepaxO+k1pv0bwdmLRNe7Eah3N8XxJtEqwufDz6+CI6dE2IMhA29xa7090z7rZgnwn3pH6sftrjYuZ/Ld1NNM8fSWLYxSIY8f5/3cL+yqw/tkTdC1T1WgEcoxbfR3JLxlwaIS2h68/z2MuepPkwvGMOZcc+0XhK/y8sQUhLdVM6TNZ5X1rjRhW2hcj6njbP9sTjHKcPhHI64YELicpW4vnigjKJLeFW7yX+g1MWZGBWKgx4I+lCbnW4IYnMEpfV0aRa7I0gg5y3VxJuHYxGBxvS8Rqulwf+p4rtqucXBJpbPyVW8C/SFb+aqC6keoz8Oo8Chrl2RSmdrH6vhm/UJ70FZ3vAAl0IngpvNn1PdBabDOqVBDXYRWBqgWW790as5q2UIeV6a8aywBLV5Mu42OZAcSarZ8DJxLGuZgZJLnl4LdZY9QbnBDkKwC1bSpQFURnla1jYPA7wejH406ANWVz78+EEAw2E4Dfh1a66hDoMwc7L4AV8Hzw/psocqHg7dKhl+Jgll2zyYMaciOAXzi+Gni7ZsPyEiWW+PBvK1mGIRmHPbJL6m0xWVH5+dIK3IbjVFbkBSIiMPvVd9nOOKGnbYWMswluSyLLLh/IcCvHuQyrn9s2jUsSrIqLfBgfsyNddEbaQTS67mQfSPodUbYEnfLrutADFqkeSN0RSo6LhtzdN622kG51KXKAKXYpRDOXGtktRLGe918/UWXjjRGlKxz6zIDa9dblfSVorcphLwq+ohBPcEvPL0Uwghe28GwwdOHqLnsWJI6Z5FoEeA5JuEH/ItLrFD8LBlcovsAGhohXLGphAxYrQr/ZNZkGv7OrD
 blu5Tf5m
 UUKduCDR/Tkn3j0hybrZ3arx1hbX5CXM9Y9SVqj5d/9TJ7oS0XscVGRgTXclf+nls30SoCzAWIVW/b6lEsJgKKL9DTKr/xfR9dHfyAMimfeuKoF3JbEJBzepdXKD5mhHcRID2nejr0eYrbWMo/t8eQq0XwvG+RXIoaABMVi3thwG/s22RibkVqKAPuz/KJe9y5Y/MqlMOxhDZCWJThPZjs988WxT/xLWg6JMEuL0rF1jUip3Dsu9XTiUfmRzgTdZkIeTX0rPdQwazg9IwWGb4QVQp/OOub2gGOYF8GBhiAzkxpKpJx+zesGLT5C3GXzmBRam2qvHmmuOn+N0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/22/25 19:23, Vlastimil Babka wrote:
> Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
> that we discard the newly allocated slab if we can't spin and we fail to
> trylock. As a result we don't perform inc_slabs_node() later in the
> function. Instead we perform a deferred deactivate_slab() which can
> either put the unacounted slab on partial list, or discard it
> immediately while performing dec_slabs_node(). Either way will cause an
> accounting imbalance.
> 
> Fix this and also make the code more robust by performing
> inc_slabs_node() in new_slab() itself, and removing it from its callers.
> As a side effect, in the theoretical case where the new slab is
> immediately leaked due to debugging consistency check failure, it will
> be accounted (as full) in /proc/slabinfo anyway, which is not wrong.
> 
> The exceptional caller is early_kmem_cache_node_alloc() where the node
> for stats is not yet initialized. We can handle it by using
> allocate_slab() there as the gfp flags are known and fixed and we don't
> need need new_slab()'s fixups.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Pushed to slab/for-next-fixes for testing.

Note I haven't seen the imbalance happening. During the ongoing development
work I caused a very deterministic underflow elsewhere, decided to make the
code more robust by creating this patch, and when going through new_slab()
callers I realized it fixes an existing issue.

