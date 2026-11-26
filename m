Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B94C606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FrHK60xi;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9SPaV1VN;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FrHK60xi;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9SPaV1VN
Received: by kanga.kvack.org (Postfix)
	id E53376B05B3; Thu, 26 Nov 2026 04:06:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A336B05B4; Thu, 26 Nov 2026 04:06:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D187D6B05B5; Thu, 26 Nov 2026 04:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A232F6B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:06:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEC3FA8F6A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:06:46 +0000 (UTC)
X-FDA: 85476690012.09.93409EF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9F7C14000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:06:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FrHK60xi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9SPaV1VN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FrHK60xi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9SPaV1VN;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795684004;
	b=XO36wtdmy8kVUNqy/1WPLGaGVeLna1VcPphj9Jvz4qRpIClehVXSf4jP7PzzvV85upftPq
	3r5Adf8TfRe8En5Otf/V/2UG6itxA47uKpgdU17Q9kGdCkugmKjvt8TFUK2rLB8DXr5Bi/
	p9G7qFR2DPtHOItHVF58LYlB0TQxKos=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795684004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39yPdNuJb0udHLAJFrorC5cCcHhnCJIncBEZ1J342vU=;
	b=NBcpSZ0K7OiUcbs+FhcShzgTIvcF4qhiFCV0NbEGOEkr9xs8HaYAALhZki9LEZETA999Xq
	5yvE4RUMPEUBKCHaWEF0v8oj/xHNE+q1mvaifkjJ+KCDwaojLvcLTFl06BLXVGgYArdfxA
	E1Y9fY4PwczGxtP+k/vix/vQPIzV82E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FrHK60xi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9SPaV1VN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FrHK60xi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9SPaV1VN;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E71922688;
	Thu, 26 Nov 2026 09:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795684003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=39yPdNuJb0udHLAJFrorC5cCcHhnCJIncBEZ1J342vU=;
	b=FrHK60xiPLeKlT1sSH5Q20B2+d/AbScE9RcAHGXZhrD/3jTYyClPEpX92WSF1W0zEnuV7i
	JW1gzl5z4Tq3LoafQjvoXXo5LfTiVX5bpn3tC2r77oUsrGutCcvbQhOQTXLAOYiGrUDiKq
	aM3Dq+nCb8seaEN7ZI5shQrPOsllFZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795684003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=39yPdNuJb0udHLAJFrorC5cCcHhnCJIncBEZ1J342vU=;
	b=9SPaV1VNP8RzeVfIHQf1g3LXlIJAsbPen6y8ZFMgxQS707IWLOlJe4SyZ2PL7gEkznrvW+
	p294Re6jlcOzVBCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795684003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=39yPdNuJb0udHLAJFrorC5cCcHhnCJIncBEZ1J342vU=;
	b=FrHK60xiPLeKlT1sSH5Q20B2+d/AbScE9RcAHGXZhrD/3jTYyClPEpX92WSF1W0zEnuV7i
	JW1gzl5z4Tq3LoafQjvoXXo5LfTiVX5bpn3tC2r77oUsrGutCcvbQhOQTXLAOYiGrUDiKq
	aM3Dq+nCb8seaEN7ZI5shQrPOsllFZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795684003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=39yPdNuJb0udHLAJFrorC5cCcHhnCJIncBEZ1J342vU=;
	b=9SPaV1VNP8RzeVfIHQf1g3LXlIJAsbPen6y8ZFMgxQS707IWLOlJe4SyZ2PL7gEkznrvW+
	p294Re6jlcOzVBCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6906134C3;
	Thu, 26 Nov 2026 09:06:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hMxfJKL2B2ubTgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Nov 2026 09:06:42 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5978B27D9C; Thu, 26 Nov 2026 10:06:42 +0100 (CET)
Date: Thu, 26 Nov 2026 10:06:42 +0100
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
Subject: Re: [PATCH slab/for-next v2 10/14] fanotify: specify
 SLAB_MAY_ACCOUNT for event caches
Message-ID: <5ubs2kqiytosrur35di2zlg26c7tfjjadjvqrp447utjxaozbl@vrjndb7avfa4>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
 <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-10-7c680f02a734@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-10-7c680f02a734@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F7C14000C
X-Stat-Signature: k8qi1wpn7cyffdcmg3anyghunjenzz8t
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795684004-216895
X-HE-Meta: U2FsdGVkX1+N8yYirz6FDy4l+ZhUSZLRchr9TvwyoaBey8vZXa1Uv8Z+xFSvDgp//PfE1iTeFTq7dhMOfZdcDxkXvXVUCjGF8yqugUX/05A2bcdCdnIxEzfF3UtiMxEae5PW+qMjG5q6Zv2rV5+PRN2SiXLnkIyNXSfU3cVRmpHlbvkdirkml/T1w8Sz5y1m2xmdD4z5gyq035p7cbWnM6TdwxK3F+FjPY3JnVR9V9VgkQInUJfzd4SxmxlbHn8pzIbf1wfTrpSSzLVVaUBzjRseOtp5gA4cJHa4lW4Jc9QysNOUDMMXFV3smqw2kXFcGAgnU+h1WI9B+dsnPbNMLQPDPSru22yTKVFxyrq0dpGntiYVz9HYQFCXbWNtmNqmywhX83vyqF1hkAuPkOQuLXxAOZOTW9ctx+PufIJmW+6oR0vVN5xwZD3dCSaUUKoJ4fyjDLsVtLTuQzlTBRxcPTYBaFJSgVSBcDbDAyMfvzmqopBccTHO6VuqJlItIviJA/TbisJuDD1r+32JgGtXKGfTP6oN5ND/CzGZzpVVKCxPqWPjgknf62qigAz1mSCgJj59B4yZkCVyaAvfPzOVgsHbS9sd1ap4KCWuH8kdgqHQ8FaUPT3oHbCP6qDqeq6z8zaTxjsodnrpVvDdV3NJiLKTsuHTFfHXSCiGmmsQWRTX879LCyw6np8UcDpL8nggKTzQtmqtUTUaCox+jQYoUKE517SNVIQV8/MbcjF4hkQn++AXIcwqkhSOMREKHOyNXEQ8rXhqtEHexfjSZKHRBG3WxvrCxnjLDqwSNOoHpWM6YcYjY3TdhY3xZk8pXdqhxMlAivsuaqzjRMAY6eCJsCNq9yr9nqnbuYA+u5VHyirOVuijF2yxaCA2VSXBs4ejmqVL9Wwxf5qFbBgrQNHSd0hOrTHUztFSCjFsg9HzIMFVEOdExpVkWvT3bdsYMCfBWIbN4X95t94Ip0inP2j
 2L6p29qa
 jgVAFDQdUbppMG7JFV6PGnd//AuH71mWTC4c8GFhDEzfDxVfoue/xiG8ZiuV7Og2gWXuGn6HepdCY1W/YPwfuZ6DNcnmH2bAjkNHRvHK+vfXb/ChP7/0uTNwo4ER/kMV1a4Gn9JbEWWBGe5bsswair5GHtF5ORRKNmFlGlgv1urmiqld0+oHsOvj/MwGlgMI1A3w6QOxReiQYZu7I+zhb7lagvkLN+mI/32F911eMiquAH/gNBOeQOxFJXGAfd+q0BJ+ApJ98SzbHcVbsmbq9aHyukBhpU7OuoGHYUdPHfbsMZuJH/jPKW0fgTktAFv8+v9ZDfPuYfeIH6UPwBoriaUEDYmMB2C5JpzGLkOwB3wbXmx8gD66AohazBhiu3SCi1jWXyo7FLB/ps38n9wilS07ByovzO2vjlr7vPWoSdaPDGA9qvEBu2W7wNJhyrKzp09mYW6J4Mxnj+Kr480QC4QfI18EqOBqxryartu9Pqo8OXKLT894SdrJ9Zc8ID7AKqw9WS1gUO+vkWn/V9crupmbxhIjm2B+ulyWLKuCHDaY/rZdPv72VUwf5yviQPLgHvC3hIrhLhxATs/G2tqUDVR2M3PztHGk9195FSPVaf3m9XqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 21:37:11, Harry Yoo (Meta) wrote:
> fanotify events are allocated with GFP_KERNEL_ACCOUNT and charged to
> the memcg of the listener. Specify SLAB_MAY_ACCOUNT when the object
> may be charged to a memcg. __GFP_ACCOUNT without SLAB_MAY_ACCOUNT
> will not be allowed.
> 
> Path: fsnotify() -> fanotify_handle_event()
>   -> fanotify_alloc_event(GFP_KERNEL_ACCOUNT)
>   -> kmem_cache_alloc(fanotify_{fid,path,perm,mnt}_event_cachep)
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Looks good. Feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/notify/fanotify/fanotify_user.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 63c9759fc3b0..3575c681abc1 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -2184,14 +2184,16 @@ static int __init fanotify_user_setup(void)
>  	fanotify_mark_cache = KMEM_CACHE(fanotify_mark,
>  					 SLAB_PANIC|SLAB_ACCOUNT);
>  	fanotify_fid_event_cachep = KMEM_CACHE(fanotify_fid_event,
> -					       SLAB_PANIC);
> +					       SLAB_PANIC|SLAB_MAY_ACCOUNT);
>  	fanotify_path_event_cachep = KMEM_CACHE(fanotify_path_event,
> -						SLAB_PANIC);
> +						SLAB_PANIC|SLAB_MAY_ACCOUNT);
>  	if (IS_ENABLED(CONFIG_FANOTIFY_ACCESS_PERMISSIONS)) {
>  		fanotify_perm_event_cachep =
> -			KMEM_CACHE(fanotify_perm_event, SLAB_PANIC);
> +			KMEM_CACHE(fanotify_perm_event,
> +				   SLAB_PANIC|SLAB_MAY_ACCOUNT);
>  	}
> -	fanotify_mnt_event_cachep = KMEM_CACHE(fanotify_mnt_event, SLAB_PANIC);
> +	fanotify_mnt_event_cachep = KMEM_CACHE(fanotify_mnt_event,
> +					       SLAB_PANIC|SLAB_MAY_ACCOUNT);
>  
>  	fanotify_max_queued_events = FANOTIFY_DEFAULT_MAX_EVENTS;
>  	init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS] =
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

