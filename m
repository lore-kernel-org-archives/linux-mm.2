Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FFCE7E0C5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFB96B0005; Mon,  9 Feb 2026 05:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83DA6B0088; Mon,  9 Feb 2026 05:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26E36B0089; Mon,  9 Feb 2026 05:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3666B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:51:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 464D913B964
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:51:35 +0000 (UTC)
X-FDA: 84424602150.14.5768D44
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id D299D1C0009
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:51:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D5BLWbaZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cYr2yEgi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CglPIfHO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8T5a8tSu;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770634293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tl9GPRip3rgX2OqDOoiS8dQTWDyvLwz1/dMI6eGzFFE=;
	b=fkS/bdnD8tQJPtybRU5EjEwXZXymLaeERwbZAj4Hwr33oPtZ0C+p7DUHiAlmgnV4Z12tew
	zvYdRhcQAHmJ0NZns+4BlT2ixe+hvdJnFEhRF9EHbLwU0R1Foj0fVpx1mIj28W+Ax4WiaK
	sw79w5j0twNZt2WQJE5XqTaItpbJGKg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D5BLWbaZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cYr2yEgi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CglPIfHO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8T5a8tSu;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770634293; a=rsa-sha256;
	cv=none;
	b=C/5lQYj1swUJVGdo9Rxjf06oaKuVakTwq06LTyk0U7DOqSo2F3Rz8dUtrIl71xCTmKPLze
	8BoOMJ/kh8ukG9Ik0DzvNEKb8K9LyAdJPi3bAHbvW4ZgacCL5jFYy7qtAgkcjxxv7troey
	cYD6ibdpJ0ROhBxZ23CnKvtg0v1m6W8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAE8D5BD0C;
	Mon,  9 Feb 2026 10:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770634291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl9GPRip3rgX2OqDOoiS8dQTWDyvLwz1/dMI6eGzFFE=;
	b=D5BLWbaZKlII/sOXZc2a6C0+5OkIW73vhjG5RqLeBCp6KdYKOnDrZgvLBvX5RBQp2aAh+K
	a2Eaap/FKpm0T5jFbHGmuyxfEVSEgE3c5eAWoS2uf7cwp2LeDAL67H7KhuW11Hr5cHl8mA
	YZDnbJPwg5dMLuvh2GKS3Dymx8cFn7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770634291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl9GPRip3rgX2OqDOoiS8dQTWDyvLwz1/dMI6eGzFFE=;
	b=cYr2yEgiU1eHJSf/pQ7P5KvmQR9wK+FsWcCorHMmQkk67qKJ8lDKhRT+UUgZmeqklOkYXE
	e+QsITG32pNkskCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770634289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl9GPRip3rgX2OqDOoiS8dQTWDyvLwz1/dMI6eGzFFE=;
	b=CglPIfHObV7n/enWmPPUs2yFg0dvdh7F1X5BhmH7NuHl8y+oT9NL9YzrW+gIck0qKLf9HR
	8p54+0Z1rLas7yXzR9brrYC0rbrIAW5MJywQ/BNwfGWxb1nxJr2aSN9Rr1GmmTPkLZZiVL
	MJApKEZ9g7T/GglrNJENpjjq21kPhao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770634289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl9GPRip3rgX2OqDOoiS8dQTWDyvLwz1/dMI6eGzFFE=;
	b=8T5a8tSuhBcQ2x/0EcWspreSTEAUVDgxMKKyAhzKwKkNCCjofilt/uJ4vf/Q3mWsPNepVD
	Gd3s+T+Aji6RR7Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD6B53EA63;
	Mon,  9 Feb 2026 10:51:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9FilKzG8iWmPDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Feb 2026 10:51:29 +0000
Message-ID: <577befda-7f41-40bf-8a44-095ae184a100@suse.cz>
Date: Mon, 9 Feb 2026 11:51:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/page_alloc: skip debug_check_no_{obj,locks}_freed
 with FPI_TRYLOCK
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Alexei Starovoitov <ast@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20260209062639.16577-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260209062639.16577-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D299D1C0009
X-Stat-Signature: f9qsuutt9nob6szubcmksac34nxt39jg
X-Rspam-User: 
X-HE-Tag: 1770634292-93278
X-HE-Meta: U2FsdGVkX18IogfteF7S34IKqEkeHBodMrowfp9vOnrMDOId1KQAODHmFhAh3hUWRGIzCAcHhflKMIY0et6YW3u2am3EH5UpG79wurafd0PEB8vfE48TBM47liB0NVQ52c4baqluqO3SzfVkJpbA4g8fEeUPi6oKDvgm/O/AoMi1/V07+Dedg67daMMtEX0hZwQayOjqxT4e8NpZUuJnC2WIYKnfrPuKn3aSaBLQVEtrjfD4CDDMwWBiJNQ0aOw03BpIBE3Fhcl4MxPuCIF/+PF1gu+S8ov0tcy875xHmQmOBAzBVSswn/ywyNLg1rFzk52ons/Uvj4Gz2QBZTpEkdHS4FBTzRrJiBC3FOq+H3xMTz+Uy08DdNhFanzIiZjW1Nts4N9Daq+sxoujSjd2RnNqvqDVeegU9BgCPXStlELGtMLFmkYv1lzEcbq/6I7TlwGduvgkNcA+QLxmlFU+wcU3//1VuGXSw/VmN6M1zeN5LFjqH3Q3dnks/6BE956HON9TXKrsKt/Lg5z+XRSOwWbfEeXBbG0b7gzWHxAZ1HS07sVmTwr0A73a0oJD/aqk9szSBzlBiXAUQFP3XmZuUZizBKu3qrptu0JAZnUq5Wy8g2VyxTkcqAYr5MOJ3oxJyJOOGrsJta5b0c2qMXfKs+D5lUJ7ZXy4xBdnSv3+/tQ5eIEsINeZrrFD3Aye0Ru7fb4RpA2npObI8A738ukj0cF9t07HQK1BgVIH2KOKpDGuswIa949IU4yUOH3VyC1JkFydoVFofaguh+5g4sSPWyMBBqSmRiSs7SAvFPUoAunwEpRLppzD18ttqaw/dGId2a/AwjkKVrHlr+HHCrAqNmwtkwp63RWdpXHD9aSBVj+UstZ75nKzcZ5APqAbzMzOL06e1pViijSerhLg7rrooGVaQb+ALSbxKgsN64VNCMo9SfeIlJLLvWF1bOsiyRxhJxpryXKFIGGCwhz3txM
 /6oSRwcj
 VWSQqiYhmD8H0p9w9EXFE7HmyJDYzgG04iuf/9UC7MxNKUPLn8SH7Fkt9ib8KuUzGzHtc3dtANHP0HF/G2xOV2m+nB5HS19ctvWZfpn36zuUJ8zFQ5BLN85Ijj9jSmSkSINeuhEhIrBSQOVFBxsNdQA4twAbH8pzsj5bSG57HlgFVt570EhxXfMkwHJSfAu4jBVvqjJgNQjX3646wS57AR5W1f6XKJrTi7XXre+0gSWxYtZk/VREREo6LnVsU7r+xcXKA2CQJLhm88J4BMcX/1PT0XInu1LUW5W7PwF4wFIocj+FMZlidhBkicOcaY1frWm3grun34f5q+bD5Hz2KpUaj30CFmEeHLDYuKAOVFbH+Ess71I0i6J6al3E2KkzeWOKy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 07:26, Harry Yoo wrote:
> When CONFIG_DEBUG_OBJECTS_FREE is enabled,
> debug_check_no_{obj,locks}_freed() functions are called.
> 
> Since both of them spin on a lock, they are not safe to be called
> if the FPI_TRYLOCK flag is specified. This leads to a lockdep splat:
> 
>   ================================
>   WARNING: inconsistent lock state
>   6.19.0-rc5-slab-for-next+ #326 Tainted: G                 N
>   --------------------------------
>   inconsistent {INITIAL USE} -> {IN-NMI} usage.
>   kunit_try_catch/9046 [HC2[2]:SC0[0]:HE0:SE1] takes:
>   ffffffff84ed6bf8 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_check_no_obj_freed+0xe0/0x300
>   {INITIAL USE} state was registered at:
>     lock_acquire+0xd9/0x2f0
>     _raw_spin_lock_irqsave+0x4c/0x80
>     __debug_object_init+0x9d/0x1f0
>     debug_object_init+0x34/0x50
>     __init_work+0x28/0x40
>     init_cgroup_housekeeping+0x151/0x210
>     init_cgroup_root+0x3d/0x140
>     cgroup_init_early+0x30/0x240
>     start_kernel+0x3e/0xcd0
>     x86_64_start_reservations+0x18/0x30
>     x86_64_start_kernel+0xf3/0x140
>     common_startup_64+0x13e/0x148
>   irq event stamp: 2998
>   hardirqs last  enabled at (2997): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
>   hardirqs last disabled at (2998): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
>   softirqs last  enabled at (1416): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0
>   softirqs last disabled at (1303): [<ffffffff813c1f72>] __irq_exit_rcu+0x132/0x1c0
> 
>   other info that might help us debug this:
>    Possible unsafe locking scenario:
> 
>          CPU0
>          ----
>     lock(&obj_hash[i].lock);
>     <Interrupt>
>       lock(&obj_hash[i].lock);
> 
>    *** DEADLOCK ***
> 
> Rename free_pages_prepare() to __free_pages_prepare(), add an fpi_t
> parameter, and skip those checks if FPI_TRYLOCK is set. To keep the
> fpi_t definition in mm/page_alloc.c, add a wrapper function
> free_pages_prepare() that always passes FPI_NONE and use it in
> mm/compaction.c.
> 
> Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

