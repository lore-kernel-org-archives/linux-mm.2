Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B5FEA3F35
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4916B0005; Tue, 10 Feb 2026 04:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862546B0088; Tue, 10 Feb 2026 04:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A686B0089; Tue, 10 Feb 2026 04:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 601DD6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:59:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7CB5C1ABF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:59:01 +0000 (UTC)
X-FDA: 84428098482.01.B554737
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95A17140007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:58:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WqJPW+Sc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yfvxgddK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jsjNvcsR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+zis9JZy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770717540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ErpO1/mo6MLCsg7ossIPnTy5U0UzlNYCmCh8RRuT6U=;
	b=TQHDbMusImPlDYyNRoXWTxHRd8sbAvjf0JVIro+LlbUgK6+5sJslBDBvdkDqdAjQaw7+Ai
	hOwMtrtQJmKx68yWJhUlHkKhGunG56oj4XlthF4qsGRyDPaBWZplKjXFA7td3UPUa6+tb6
	ITu512MJyKMsbfW9d7SFRk+xbDc42zI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770717540; a=rsa-sha256;
	cv=none;
	b=tRxd+t8/Z9eWLC5OvphlgKPXnHsGrGdyJRFoKCPqu5eFVkyBdKvXuSu/AHel0p86s9OD4l
	TULTek9wGenUrk4DUYsVOx1tgMEWW5D6TjlnIvF53aD+A3K3kY3kD4c1ntW6tTtbPYZvXP
	cAvSmRfgMkRzInp3mbncPiwrPPmbl80=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WqJPW+Sc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yfvxgddK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jsjNvcsR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+zis9JZy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A78D63E712;
	Tue, 10 Feb 2026 09:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770717537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ErpO1/mo6MLCsg7ossIPnTy5U0UzlNYCmCh8RRuT6U=;
	b=WqJPW+ScWxutmzD1EjNPn2gI/+Z/PkqCrw/H3F7XZBuxCg4DOjz0uZpDs1fwZUtgV+3WrW
	ruDt6pLnH09FUKmqUfn8P8XxfJ2A8fu/bFqH4Gjvq34kkdhK7jo1CeW5JH7AquX0iMfQXn
	4Ttla0R/6auumozOnZADL4mfi7+NeZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770717537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ErpO1/mo6MLCsg7ossIPnTy5U0UzlNYCmCh8RRuT6U=;
	b=yfvxgddKltvd4IAArSdsZx6e9Da+ALtsybkx4lJHTGEk2RUvdwq3N/GXQMUE1lTkkBIZez
	IMELmulNwijwoxAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770717536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ErpO1/mo6MLCsg7ossIPnTy5U0UzlNYCmCh8RRuT6U=;
	b=jsjNvcsRl1/pjz5iHBUHLsU9QqDK+eBiBsKNePQ4wsyCYLjoz1UvChOOkhZ582PXWlW9gd
	zLDe+wscRG0WJGhxZVWPTj2QvfzGy5RrL0HUt54RI/wNJQitAuY8Z8sklEi6sE0yf+NdI3
	hKb+lX3X+s/6g5EM9Nx4lqWf1hspt4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770717536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ErpO1/mo6MLCsg7ossIPnTy5U0UzlNYCmCh8RRuT6U=;
	b=+zis9JZy314f212smcIAmp8xWWtq7EnUj6vrJK9pXg7jAe7II6C7LHE1HAutSDZHeaQzqa
	PRIXHamC8Ut4XCBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C9923EA62;
	Tue, 10 Feb 2026 09:58:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5REdHmABi2meIAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 09:58:56 +0000
Message-ID: <7c3549cd-35a9-48cd-b49c-e3a211b8c811@suse.cz>
Date: Tue, 10 Feb 2026 10:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] fix lockdep warnings with kmalloc_nolock()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <20260210081900.329447-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260210081900.329447-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95A17140007
X-Stat-Signature: xnb4kfyq56d963m1px4q7feu7owk4ry4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770717539-345370
X-HE-Meta: U2FsdGVkX1+KkfsL3IMsIRoIFkE//+3dgwHuk4iW8V8QjXUWd3hxTwWevgc7abwnos/fEtBKvDi+Dc+D3HUP5Z3Hx2JFWhA00Xf2MVPgqVE2aABL7J1Hz6EsHGGakObjtDMKuL8I44xNh9HasDyPUMnjmK+IHZ90A5+S2I16sQmjf6SDOEIKI5lLkYzV/ueMN3wjzoPaRQQ4TZ6qtQu+iZVznJxVSePi6DGM2Tgc8D0ncyRiQJvkyAuuo8fjik7JEfIkR5nvpdBAT5B6TIFJlQRaNfPq2Fvb65aiYTvwEpyNL6uqp/cJ+6doiOgcbrM2eb2RTG4tFWUAZU2dcEpFNYTMm1uw+bIqRqeM8stCrfqSW2NLR/TpHJ/4Z0wiXw3Yck+2OMhEF8NX5XIikT5Ez4HHWtZjq6mn/VF2PayUJOzyo9UzVo3h+MRv2TQyfDDMEbWLHtSBsuRDPBYLzIwRzolVTrVoECYSAAy6p3wMSXWnvsb9UEyEZwHjUh5U5h5HvcgmxpSKe8J67MpesToUdwHXOWAGAO+va2oHIFt2yOs8nhATETGRf0zqbk52dH2XCfN4S5d4oezeiDnzLjvc+7QvM590bl5nM57ux3rzl1yShreMecbUNS9CD8liKadP68RuMYUiufaXB3BwvXsffjl6lVzf9H3bVzktIRb69+uxTn2pG6nUP3qmweCZ9ySw2Z6WOFxxEVPQPxVrjSnxgCTU0Q9QjXvO9PWGDcbnBphoDfSg32bJIP9aMp27wZNyubxxBLEfXnVzr3ANS3Dhg6ka8GA6cEt1bMxTEohNlmWeGs3HOAsFUZI4QFLd2QqzYPsiUbqwkSOm3eSZxMY7TrtPmD7ESTCUivhpv/9fq/XfXRD4M+l8nnYauds157ybIrBIo108Q1SaCCC8AhJQhcgwV93Weot6/RLjXNq0bTklD4iAri1YtxvrXdi+y/H28uD8mC2Ntw+6psciez+
 Q6SK0wel
 +V4KdB1WR+ckyBG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 09:18, Harry Yoo wrote:
> Hi, I've observed two lockdep warnings while testing
> kmalloc_nolock() in NMI:
> 
>   1. Accessing current->mems_allowed_seq seqlock in NMI isn't safe
>      and lockdep complains.
> 
>   2. w/ CONFIG_SLAB_FREELIST_RANDOM, get_random_u32() acquires
>      a local_lock, which isn't safe in NMI and could cause a deadlock.
> 
> Let's fix them.
> 
> Note: This is based on the latest slab/for-next. It wasn't clear to me
> if I should base it on slab/for-next or slab/for-next-fixes,
> because the merge window has started, this series needs some exposure
> in -next, and the patches in slab/for-next might land in mainline
> in the meantime.

Right, adding to slab/for-next on top of the submitted PR, so I can send
another next week. Thanks!

> But the conflict resolution should be trivial even if it should have
> been based on slab/for-next-fixes.
> 
> v1 -> v2:
>   - Patch 1: per Vlastimil's suggestion, do not access
>     current->mems_allowed_seq and avoid retry if !allow_spin,
>     rather than returning NULL.
> 
> v1: https://lore.kernel.org/linux-mm/20260206171348.35886-1-harry.yoo@oracle.com
> 
> Harry Yoo (2):
>   mm/slab: do not access current->mems_allowed_seq if !allow_spin
>   mm/slab: use prandom if !allow_spin
> 
>  mm/slub.c | 41 +++++++++++++++++++++++++++++++++++------
>  1 file changed, 35 insertions(+), 6 deletions(-)
> 
> 
> base-commit: f6ed7e47c1fc78e78c9bfeb668b1ad9ba5c58120
> 


