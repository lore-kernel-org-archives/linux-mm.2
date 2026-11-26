Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F5B606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2Aj1MXJl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aKDUHDex;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2Aj1MXJl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aKDUHDex
Received: by kanga.kvack.org (Postfix)
	id F13726B05B0; Thu, 26 Nov 2026 04:05:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB4C6B05B2; Thu, 26 Nov 2026 04:05:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8FE6B05B3; Thu, 26 Nov 2026 04:05:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6106B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:05:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C714116033F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:05:40 +0000 (UTC)
X-FDA: 85476687240.15.1B91CED
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 616541C000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:05:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Aj1MXJl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aKDUHDex;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Aj1MXJl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aKDUHDex;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795683938;
	b=IWCqmSKSfYUMHRMDSZJD+NH0fbW6PjW/+X7wsalO7klK8reSReWD9Mk1JxWR9nUWX1ICSD
	bSldIus4KDVvV11kT3vcTmEMnp7H5UK+lpYAyK3+ta+4z5lO6baCT41VLJyffWy4NeuiTk
	K5HOu5vKFHva/02RO01YlG0sq5OwXH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795683938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5FM9vVnkaYr5oiSZF4qGOvuP/i123ZW74JzPvuX6pg=;
	b=AaDQnTBYkXvzK3guraDxS3A2+GUY0NWVQy7MuBIs9i35Y3fTgSbjWE8xFam1UE3D+BwhhF
	Vjz60kLU+FizI492KR0JgveprBE2WQ6yCaEFQkK7s9GXU1I66yvwR7AhzXOBUclGmpfFDl
	jBkmHJOtD6qp1VYb3ea8d7NLpBXFoAM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Aj1MXJl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aKDUHDex;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Aj1MXJl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aKDUHDex;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A246D21D8F;
	Thu, 26 Nov 2026 09:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795683936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e5FM9vVnkaYr5oiSZF4qGOvuP/i123ZW74JzPvuX6pg=;
	b=2Aj1MXJlIYpqdmjnsQ0sPyQux4kSV5g4Dsvpn6MzW7FExaq2EkvverSLjQXcNc+6bKKtoy
	XxcllSyZ+V7edM65UBTv09Yhg3V1KYx1lxcmjqqR+CDO5ZEFQHWH+N1a/+UGiHumsuLmTt
	ctIrIlDk/wLwqOwjhdBQgfX+DCCOWFs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795683936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e5FM9vVnkaYr5oiSZF4qGOvuP/i123ZW74JzPvuX6pg=;
	b=aKDUHDexsKNu7mk1FQDN4+wzC9n5YJr8g3hfI3/jNWMmzqqRUZXH69IyO/q+qyDg6RgAIb
	u9PtFijfU1TL7JCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795683936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e5FM9vVnkaYr5oiSZF4qGOvuP/i123ZW74JzPvuX6pg=;
	b=2Aj1MXJlIYpqdmjnsQ0sPyQux4kSV5g4Dsvpn6MzW7FExaq2EkvverSLjQXcNc+6bKKtoy
	XxcllSyZ+V7edM65UBTv09Yhg3V1KYx1lxcmjqqR+CDO5ZEFQHWH+N1a/+UGiHumsuLmTt
	ctIrIlDk/wLwqOwjhdBQgfX+DCCOWFs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795683936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e5FM9vVnkaYr5oiSZF4qGOvuP/i123ZW74JzPvuX6pg=;
	b=aKDUHDexsKNu7mk1FQDN4+wzC9n5YJr8g3hfI3/jNWMmzqqRUZXH69IyO/q+qyDg6RgAIb
	u9PtFijfU1TL7JCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73C03134C3;
	Thu, 26 Nov 2026 09:05:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /qoxFGD2B2ufTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Nov 2026 09:05:36 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id F321627D9A; Thu, 26 Nov 2026 10:05:35 +0100 (CET)
Date: Thu, 26 Nov 2026 10:05:35 +0100
From: Jan Kara <jack@suse.cz>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Amir Goldstein <amir73il@gmail.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Eric Dumazet <edumazet@kernel.org>
Subject: Re: [PATCH slab/for-next v2 04/14] fs/buffer: specify
 SLAB_MAY_ACCOUNT for buffer_head cache
Message-ID: <gmnosp2u47xewnszzrx4asmldxsyjtejyrbrng2ckrcfedymeu@evhwupv3iwhf>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
 <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-4-7c680f02a734@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-4-7c680f02a734@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 616541C000A
X-Rspam-User:
X-Stat-Signature: phe6qhuzyhauxyfpyb46sgpp3idb3qgg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795683938-114311
X-HE-Meta: U2FsdGVkX19JBy+1VXbz+RiNQdvcEUNfzRP0qdaWD+RQyuTnlBsHFjikYswhZwNySaB9Ze32FCY/l9WWBcwATeeD/tPXix+C/D/gJCMz/QuZMX940ndpBgypjkSQJdLsj2enbNyjO2yBQOsaVxusTQy2LDGqpZCgdRiTwsoxqTjxRGx/BKf8pLtXrrXA4EqY4FZ2ZsaTe/uVKR3DOODLdTFnAoxkE6Tr20SV5ZcNIzg6yPDx6IHPyKE1xgBa46tZIPfLQGoAwjjsw9odne5qNYLlvA8oPUkzPU3y2ilz+m/nQAOAlb6QonZ8mrkSzOthdHwJ70nIrTSP/Uiu1Ltp6xp4inZBzH/56kRwg9lfgbf1O0kNoH1VpdOeyNkFiejmqZwsoC3XJdWJNJtA6xlx/ZRXmtpQBlfNHTt2DIhjGP3fMjIjXMkt9eWg6Y7QQDf3F3mQ40KFSxzoo/+VlI8IBujjg58Yh9NA0igFwWsSQp8ncd1T8YTzZyj40lUFDHJHGr0apaQhj0oEQgPK4d59svjeCQE8WQuwvpJI84GoaS55bcFcxsCzv9hIoagGcjNBHFGnqVQDQlnY0DtRXcaRDREzeDPISfXJQheltBQuUWKH9vNBukXkZU4bEJZvkgarNHO03ZG/Ia7XjrJfF4pepRqgsH+PGixciNVSnCPieW2V8M7RCVxw/HRSCJVjmDZvbJ6t4ntZdgif75RRR/uyZWKB2qtvt+0ceJx14G0qPccqViSOfNUkNJuW8ERlPSAIfOldMxE++FCKmBzTr5gWMOVCRnMVtdONh5fIifulUeASaJI6k+5gvXxCWpp9j/00cRAhmmle7o20zFTv5TO9EC2OZzlQMXuRIoiP4uSoBNPpR2r6U+ZlEnVHG3TNSIm8UONOXprtnb6Q2Chesos1INvVijYydt87spyrYF5cJlJwSN28UkHrdNZrZqPAwtajIjfi69lfNa+8+BrQTXY
 1QwXXafG
 9B2bsDfhKllI2m0kjEjER7d6DRoKKWZ271mlg/pA0hc7+jPLoTUyiQSuh3h3bvzAwxq6QmYixDCJtPp9VRDWHhx+0pwBaZxRE/WSl1qWic/vu23hHinXRCBd32lu/BhLk2lSujIU5CwtkbwiYNg0Uwkcuduxokg5uCVv+jnVHTl8V+lsEpW1pakzz1bKGkg6FfE9iRk1rFnFXcoRl01mD4eRgQWzUTfrMJSIL8tmYfZ7H3zI2MW6Zd5hzP/0K7B3zRNxCZYT68gAjlL9cVH/HPCmK7rVjndEBgRtWSPE8VkIBgC+y5ybVApRsfu+KsCYcBx4mjOOL5w8N6i4lGekSP+zIdTOg/7nvUpm5NMLB3svASYqqz7ezOu22CHfaVKqyPJl7p5SHvi3RaOmS7GwGv/m3dNw6xltVgCt/T1kFXN9mcX4L6vmqXO/8sUz1Y63lRXcod5fSxdfvxVgbTW86iqVmLsTVb2fYw8jMjT8NHObb6BnpAIrGOJAUn0fa7wLFB3lU5xGSk6eoZMc6w5KnjsidDz3J7IhzOOKo91ii3C2bNxBUqnyWalFw41fRgaqemKXkNk64RgBtzHVutsKvE5Z7CtPeCrhbQSn4xhd+li+dWTgQnrURSdkteXzYdbeXnBfIRW2wH5ILEb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 21:37:05, Harry Yoo (Meta) wrote:
> Buffer heads are allocated with __GFP_ACCOUNT to charge them to the
> memcg of the folio they are attached to. Specify SLAB_MAY_ACCOUNT when
> the object may be charged to a memcg. __GFP_ACCOUNT without
> SLAB_MAY_ACCOUNT will not be allowed.
> 
> Path: ext4_getblk() -> folio_alloc_buffers(GFP_NOFS | __GFP_ACCOUNT)
>   -> alloc_buffer_head() -> kmem_cache_zalloc(bh_cachep)
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Looks good. Feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index f951559e7d32..4c24f4546106 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3006,7 +3006,7 @@ void __init buffer_init(void)
>  	int ret;
>  
>  	bh_cachep = KMEM_CACHE(buffer_head,
> -				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC);
> +				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MAY_ACCOUNT);
>  	/*
>  	 * Limit the bh occupancy to 10% of ZONE_NORMAL
>  	 */
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

