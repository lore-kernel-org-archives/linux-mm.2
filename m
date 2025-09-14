Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CE1CAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 20:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09FEB8E0003; Sun, 14 Sep 2025 16:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050AB8E0001; Sun, 14 Sep 2025 16:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5AD08E0003; Sun, 14 Sep 2025 16:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6B558E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 16:24:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2861C1DE986
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 20:24:24 +0000 (UTC)
X-FDA: 83888983248.13.EA51C6B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9941D180002
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 20:24:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=18xK0+w4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q7Rhd/9S";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=18xK0+w4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q7Rhd/9S";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757881462; a=rsa-sha256;
	cv=none;
	b=YSXGaDPY1KM7wnzWGGurh89TuP6IgMImryoXcMLlfZX2YuRdHjws80iizVv9E1OIuwbpmS
	EwP909hvz6P3mxcWkay6H/5gKW3u2egnCiz7hqiYI6diaNfzJznyow0KIe5t6Xx7tMNhh2
	irYpX6srUWuNXIRYSAtn/98ZiKzfufA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=18xK0+w4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q7Rhd/9S";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=18xK0+w4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q7Rhd/9S";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757881462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1RrKipMkrXfC/ghghu9BRVvYF8cwFoT1zHSSPQh0bk=;
	b=5dl68+pw6cfnzJy16Dtnf9w8O3YWWzwRnLm50fZNR4mpq9Qi84/lNbFLh0eH9N7YQfBpcb
	+jBe1GeCyLf62xE1UTwwsL21mitjr8KNXCadERjS9cDA1pLFEmGM2oka+BQKH+e4SNGMze
	quJSKQZI7Xm+TEoLku690vHCXJ4D+x4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 736911F769;
	Sun, 14 Sep 2025 20:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757881459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/1RrKipMkrXfC/ghghu9BRVvYF8cwFoT1zHSSPQh0bk=;
	b=18xK0+w4i+mY9aX74zo7Z263OgzVwvThg8K5pqiQ0i1ng84TiE1oetVCpxtV5AsrFkuMII
	EViJ5T+sx3UPXHRLsWMFX7eopIvazH8VTjsg6j3eZauAV4+MZf1Ot6+5gg6DQcvFTkMGYp
	kI4b//UlbSjMHEd12SZkqLOSC7ES9J0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757881459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/1RrKipMkrXfC/ghghu9BRVvYF8cwFoT1zHSSPQh0bk=;
	b=Q7Rhd/9SrlHt3186nF/+ljPxl5v45mJW810N8C0tA4Dx2Njwc4twuExFNcMEDfXiS/U9sR
	epjW4PPBIfvHAUCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757881459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/1RrKipMkrXfC/ghghu9BRVvYF8cwFoT1zHSSPQh0bk=;
	b=18xK0+w4i+mY9aX74zo7Z263OgzVwvThg8K5pqiQ0i1ng84TiE1oetVCpxtV5AsrFkuMII
	EViJ5T+sx3UPXHRLsWMFX7eopIvazH8VTjsg6j3eZauAV4+MZf1Ot6+5gg6DQcvFTkMGYp
	kI4b//UlbSjMHEd12SZkqLOSC7ES9J0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757881459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/1RrKipMkrXfC/ghghu9BRVvYF8cwFoT1zHSSPQh0bk=;
	b=Q7Rhd/9SrlHt3186nF/+ljPxl5v45mJW810N8C0tA4Dx2Njwc4twuExFNcMEDfXiS/U9sR
	epjW4PPBIfvHAUCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5906D13419;
	Sun, 14 Sep 2025 20:24:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEmRFHMkx2g6LwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 14 Sep 2025 20:24:19 +0000
Message-ID: <bbdb72e1-ada9-44e2-9ec1-53fd6ed92e84@suse.cz>
Date: Sun, 14 Sep 2025 22:24:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
Content-Language: en-US
To: Hillf Danton <hdanton@sina.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250914022258.7062-1-hdanton@sina.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250914022258.7062-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9941D180002
X-Stat-Signature: nm79bziz3a31wug8j1sfukz9renjx3xf
X-Rspam-User: 
X-HE-Tag: 1757881461-881234
X-HE-Meta: U2FsdGVkX1/NnX+OfXskzsGnRh3XwRBnBw7AiwQ9Jb/hlMRBqXfftCqLlgUXVRgop2cQzC1ZLVc5X+O3U96MRMuTCdlRsI84mtGaK2mJL/mL7W4qBSegHoDW7wkrI3QI0tnq7j1sREnMPz2ojI4IW/qQjyCJf19SmGqObiyIXza1RNddVeiDCMSQmMwzKiAF3z153rgwcLwXT16D0oz9ef+mNn+CeTP2xKtLxbg2fa4FWmHq2fEQ8wVlUsd0FaXTb7zImHnpxmJ8nAkupyr4AOVUR/rvP/vlLFEtfAJSc+nUehdAHRB+2hL6zIJpk0Kl1Z2SlNXLMplSoTa5HkMwkjpL2acn1m7n/pJz9pP7+xWARu7EXkG9wze3hD+lgHrWhR+7FQU7NAllsw1kPE4EtP1P5nE+KwxnCQZo66sekuXA7qSUv3A/wuIb32CLJlqCEuWqgyWznKc5Loe6TUN8j9Hir//L6h07UpQiwvUrWKJTZoqZpgYSSSn9vz6PIyDEvwR6NpagyYfMkNFhydlBtxKNhH/ODOdIquBTqm1AkWwtLf4xHkRaF/1iFL6gxBoFfCuTM/Rf0BO9V6qyopjzGd+Y7RbpTIt3d96CbtYPu+AU7pjE44HojP0A4Zu7nNwG6H9IeKipP31n3LwF9HZa6y/lYXdgVw3bQ4ZLWhHeTr9Dym8QJ+1AyaDRzfqujqwqdRCDCduk3xiSy8UqIk8Z1wRoTMjZq+4cl3JqiZJXzpUATEhTpVnRkJkx36DeWOvD6Uc+KolW4zUD9JXwKzMfnjFPXSbo+btLka08o70mznXK+5d5AXcjEjGMQjANX2e7anDp0g25li5WvE+3uKLp0xm94Nh/5u6pXvI0WK8gPC7Bpb6w/gD9HcHvhHOD46WpLaleQzawHoA5jJJ4BqAMWXVM42V/kozUV3TyuvsfJYJfu3AF+SbeVHToEm33z4a7ozye5DbyPk8FbsrqTjV
 RaTMBkI/
 imFE7rL3G5uzBI1dxm56YGlmqSmQ5E92QEtAv64nJT/pS+1lNEhjagGwPSl8FyAm1K9mYFQjZIue8XT7r6628xae9UjUJLZWU9iPGT03nhUNPlzAbxmRkxjiq3/9rS0Hn7B3N8TrZzsziC4cq0o8KgZW/ajTy6ri++cbdubSLRn9Rc+UQ04yiEo4ZsoUDZtvQVmI18V1uZ2qp9ggfpIWLNprzZjAc8KWlFO9uGbloBI41w2pXoUBXk5tyEEGkGtx2YdV9iCGfx1EQIPzYDram4UjsTG4rNosRfLY6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/25 04:22, Hillf Danton wrote:
> On Wed, 23 Jul 2025 15:34:34 +0200 Vlastimil Babka wrote:
>> +
>> +/*
>> + * Caller needs to make sure migration is disabled in order to fully flush
>> + * single cpu's sheaves
>> + *
> This misguides, see below for a workqueue case.
> 
>> + * must not be called from an irq
>> + *
>> + * flushing operations are rare so let's keep it simple and flush to slabs
>> + * directly, skipping the barn
>> + */
>> +static void pcs_flush_all(struct kmem_cache *s)
>> +{
>> +	struct slub_percpu_sheaves *pcs;
>> +	struct slab_sheaf *spare;
>> +
>> +	local_lock(&s->cpu_sheaves->lock);
>> +	pcs = this_cpu_ptr(s->cpu_sheaves);
>> +
>> +	spare = pcs->spare;
>> +	pcs->spare = NULL;
>> +
>> +	local_unlock(&s->cpu_sheaves->lock);
>> +
>> +	if (spare) {
>> +		sheaf_flush_unused(s, spare);
>> +		free_empty_sheaf(s, spare);
>> +	}
>> +
>> +	sheaf_flush_main(s);
>> +}
>> +
>> @@ -3326,30 +3755,18 @@ struct slub_flush_work {
>>  static void flush_cpu_slab(struct work_struct *w)
>>  {
>>  	struct kmem_cache *s;
>> -	struct kmem_cache_cpu *c;
>>  	struct slub_flush_work *sfw;
>>  
>>  	sfw = container_of(w, struct slub_flush_work, work);
>>  
>>  	s = sfw->s;
>> -	c = this_cpu_ptr(s->cpu_slab);
>>  
>> -	if (c->slab)
>> -		flush_slab(s, c);
>> +	if (s->cpu_sheaves)
>> +		pcs_flush_all(s);
>>  
> Migration is not disabled.

Can you elaborate how it's not? There's a comment above the function saying
"Called from CPU work handler with migration disabled." and we have relied
on this before sheaves. queue_work_on() says it will run on the specific
cpu. AFAIK the workqueue workers are bound which is effectively disabled
migration (we hold the cpu hotplug lock).

>> -	put_partials(s);
>> +	flush_this_cpu_slab(s);
>>  }


