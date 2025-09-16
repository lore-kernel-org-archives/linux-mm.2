Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F04CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 10:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4966B8E0002; Tue, 16 Sep 2025 06:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4469D8E0001; Tue, 16 Sep 2025 06:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E7F8E0002; Tue, 16 Sep 2025 06:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1655C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:21:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C04AE5BC70
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:21:29 +0000 (UTC)
X-FDA: 83894721498.30.AEA8BDD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5389140003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:21:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uHhmcomd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T2IEMIuj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uHhmcomd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T2IEMIuj;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758018087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x60UAmmdtyxUGPNMyl1h14VzGLr5bgbrZHtvveeVkQY=;
	b=c/V1+yxIlTDN8gwe4XZdMlmwTkWaF5mSv827p7U+wT1r7n3aIS2P2X/skYeiEmZr+qKDnY
	PBonlVJ/TM4gmXumDcvUC2CsOzjBtpA76YS6k0rCSkhPFBdNoG2fUIuZWXUbCDxrxs4vDM
	rJTRffRaDwXPR2PENDKBMWa/RwMEz1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758018087; a=rsa-sha256;
	cv=none;
	b=ofxe3XX617wKK0KNHRYHQUEqugTuDxUnkMGaJoICPj3fUTcTILfjeC68n9Spxy8yD+g5Fg
	xQvwPkyBIQ+eQq+sPRwNDjtylHpMRekiVR/0P/dpwWlsSrd07hLu84aVq03W+JISfVJQXu
	ghD0wfyU3eTpK2il7FJ2bj8iH1uiMTg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uHhmcomd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T2IEMIuj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uHhmcomd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T2IEMIuj;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E2851F805;
	Tue, 16 Sep 2025 10:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758018085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x60UAmmdtyxUGPNMyl1h14VzGLr5bgbrZHtvveeVkQY=;
	b=uHhmcomdT48oChR7TsvJuX9515nG5TF2KzkCfT5Ym6OnFncF5XdDc1p12RKBPp/EQYxegd
	TrUMAyiz+J1AOLeRrRBJZWhkVLcSJ+tXPXN4/twp5pQzQJb63Dw0IXRYkZ9O1dck60TUvn
	SRVrKZbYiSB7AsWjbp2ZoVPoks0sLN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758018085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x60UAmmdtyxUGPNMyl1h14VzGLr5bgbrZHtvveeVkQY=;
	b=T2IEMIujbvQGmfC6QOhfQ6BZC4SVfH32JahhIjyi2F2dSnV91a8TXhBhgFQnR0zux+ASAx
	GZB/XmuaqZTzSADQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758018085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x60UAmmdtyxUGPNMyl1h14VzGLr5bgbrZHtvveeVkQY=;
	b=uHhmcomdT48oChR7TsvJuX9515nG5TF2KzkCfT5Ym6OnFncF5XdDc1p12RKBPp/EQYxegd
	TrUMAyiz+J1AOLeRrRBJZWhkVLcSJ+tXPXN4/twp5pQzQJb63Dw0IXRYkZ9O1dck60TUvn
	SRVrKZbYiSB7AsWjbp2ZoVPoks0sLN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758018085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x60UAmmdtyxUGPNMyl1h14VzGLr5bgbrZHtvveeVkQY=;
	b=T2IEMIujbvQGmfC6QOhfQ6BZC4SVfH32JahhIjyi2F2dSnV91a8TXhBhgFQnR0zux+ASAx
	GZB/XmuaqZTzSADQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7677713A63;
	Tue, 16 Sep 2025 10:21:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4DiWHCU6yWhDTAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Sep 2025 10:21:25 +0000
Message-ID: <ef34e217-580d-4d91-9bfb-4db1699e249a@suse.cz>
Date: Tue, 16 Sep 2025 12:21:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] slab: Clarify comments regarding pfmemalloc and NUMA
 preferences
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org,
 linux-mm@kvack.org
Cc: harry.yoo@oracle.com, shakeel.butt@linux.dev, mhocko@suse.com,
 bigeasy@linutronix.de, andrii@kernel.org, memxor@gmail.com,
 akpm@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org,
 hannes@cmpxchg.org
References: <20250916014609.47273-1-alexei.starovoitov@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250916014609.47273-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g1swgiaaymqxasa65fwak73shsa4jy3d
X-Rspamd-Queue-Id: 5389140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758018087-270580
X-HE-Meta: U2FsdGVkX18b/DnOOMLDDc93PX+fzr/I2OF7IAy1l8mgYsWM2fHckGUs0PhOWHtedYTxjRcRPQGepNalX9o34VXiosR+AfrtJGN6f+8yTeidqFzAE5o1z/UF+t5+ZIXCsOpZYE3EEue8DrWJTKaYHp0t1GFhJr3FTE3/dOm4Kj6LcdKheqf/wW1FuIy+fHSYFBNGpWhQlsfbqaqjC50QvkOrfV9wow9V65U0s+ZQ9feudpc10288V/T20qmlR+6xQeJkUqqYMcw6l+c1+hzN1cxfLD9ft80XVdFBCQfjt08IxwlcZky9Hh7iKtUX3cXdEdy01iZKydvjjZmNQQgmTWFXb3Qe415GJCARfiGsMF8KDZkuxOeytv+C9tpO7/S60iiMeeOqDczp6qwF/ZOu+zfuh9IgxCPrl51yyezcuG2hCEECEJK+ju5oDhKNSffsWgE2u3oeaopCjDYYQ3i2sYQphKxC7Badj+k8+mNiWS19OnM6Tq0R3D566MlkENRuXYgfqbql4Knd1gyPY22J2nbhYNDlGTEdPk9GX9RNX+eBNm7rLU/iuI6qq/LztHRlthMA6q4IdKl98Jn0M8rVoSADdCGB0PApAH67/A4I1duZvs0zu3ou1xmUrW6Dto4AbVVaCm1tQgyjhMKvtZet6lY3QrkoCiFn3I1niM1U3kZKAODM5cd3TTQaDbPBsBQLwgcpMT/W+4kHcAHoZpLq0NzAEmYmd7M1Il48mjg1TM9ikdgfj0QslGbAVTvu0WyV2EKmKFYEuMT/HzfJdvGhMYm8k7i9HVjswyvD6r+Rw7ylyvFJ1pyICZUg+o0UgzL0aiwMxwilc2czHAqZIYG6wW7lH6A73Et4Dag4GLunoJvxzka2m19hhvCwAZ5abar9xNMWDSaTA2ORSxfyY4UiIes3Vn01AbYVFLcPiFk820bfOQ0xp9lREg5KOWBG/uNb1ZEAxtQG8KL7n9JnGGO
 C0UEzY94
 XOeIeYgqIdmI0cUNF/bo/Mn/s3V/HuBxRHkA3xVoMC51Ucw2EUDjruwl25yvFDaiO0Jp4OQz4swJguV23np8bn9afKQYAXgYc6p3e055MgJufUW4AGeWERRm6aRorVOd6YY7YsGNhUtHCEMZ3ke9Yn7VqUKYi5e3LghuLUTnX4IDYysUFmOGY/sb5PDzfmfuVrgjQARBBWdh2MQCeXzzaADoeXv/c47OfJD0kt8sW3K14RWep6GBwpglaGcVYZVpDNE5UC6pgCPRiHUdTDxL1ZAfcVCO2JpsoTe5EZGPLGn64Gtk8zxT9baoW334NJid3bpqRxDww/m52ZLHV05xEsn3th42oSNhFCLmqk6Lt6nRcyBU4B4nwmxYPGYURQquEgRq+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/25 03:46, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Clarify comments regarding pfmemalloc and NUMA preferences
> when ___slab_alloc() operating in !allow_spin mode.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Folding that into "slab: Introduce kmalloc_nolock() and kfree_nolock()." in
slab/for-next, thanks.

> ---
>  mm/slub.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 83983de948f3..c995f3bec69d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4456,9 +4456,17 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  		/*
>  		 * same as above but node_match() being false already
>  		 * implies node != NUMA_NO_NODE.
> -		 * Reentrant slub cannot take locks necessary to
> -		 * deactivate_slab, hence ignore node preference.
> -		 * kmalloc_nolock() doesn't allow __GFP_THISNODE.
> +		 *
> +		 * We don't strictly honor pfmemalloc and NUMA preferences
> +		 * when !allow_spin because:
> +		 *
> +		 * 1. Most kmalloc() users allocate objects on the local node,
> +		 *    so kmalloc_nolock() tries not to interfere with them by
> +		 *    deactivating the cpu slab.
> +		 *
> +		 * 2. Deactivating due to NUMA or pfmemalloc mismatch may cause
> +		 *    unnecessary slab allocations even when n->partial list
> +		 *    is not empty.
>  		 */
>  		if (!node_isset(node, slab_nodes) ||
>  		    !allow_spin) {
> @@ -4547,11 +4555,6 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  		slab = slub_percpu_partial(c);
>  		slub_set_percpu_partial(c, slab);
>  
> -		/*
> -		 * Reentrant slub cannot take locks necessary for
> -		 * __put_partials(), hence ignore node preference.
> -		 * kmalloc_nolock() doesn't allow __GFP_THISNODE.
> -		 */
>  		if (likely(node_match(slab, node) &&
>  			   pfmemalloc_match(slab, gfpflags)) ||
>  		    !allow_spin) {


