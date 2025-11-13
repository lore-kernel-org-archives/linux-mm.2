Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D0CCCD8C9C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704738E0008; Thu, 13 Nov 2025 11:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4A68E0002; Thu, 13 Nov 2025 11:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CFD8E0008; Thu, 13 Nov 2025 11:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4438B8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:29:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 011AB1397B5
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:29:03 +0000 (UTC)
X-FDA: 84106118208.25.99864FD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A8BC1C000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:29:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GjK9z3pR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r13tS6gE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GjK9z3pR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r13tS6gE;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763051341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEsVD8ohyNabwarW835Ycw9hRo7+/LeNqu9ZNgvImfM=;
	b=sRsGXZbBd31ucmFzNSXZ684QsfVbADn/EEumGs5POFGmuegE439Ec8Yhk0k4Luw1YaNlg6
	VbB+usA8J8OloSAPn9FlOpM6TiffVSQkBDRylrlKSVuQqjcV96z4RvT1hqSY4QrHZuGHfc
	BG48sxQiGGuJkHM1bUb/oaXe3B2T430=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GjK9z3pR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r13tS6gE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GjK9z3pR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r13tS6gE;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763051342; a=rsa-sha256;
	cv=none;
	b=c7ZJDccw/ibCtfajGKvkOh99qzUXbUrIW/9KF+/cTo1nsjwqmH5qLMDvbeE0aHI9uae8QW
	GVsQ0oQ16C2OxJNzUV8ROjOLFdNcUZ9raetPhhFZ5nng1Vjjc2LXM6uTQgSxvzSuamJgpA
	spqAqtGYdZhhFeGdl8exCqISvLkISuE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C8D551F449;
	Thu, 13 Nov 2025 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763051339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iEsVD8ohyNabwarW835Ycw9hRo7+/LeNqu9ZNgvImfM=;
	b=GjK9z3pR1rXGLEcXbwxj2ecT0+AqqChQCB+Oz5adAFaE+StufOUfVFI6/dZHPPv6mbaJKb
	pzJyjzylfur2SyCH6PsBFZgtOKg5FvKMyaROdMnlPf7vh8d23YO5USzXSLoo79BAqWC9mI
	n6mrrAjBsiFuOHbFWOe8eps3ghpq/lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763051339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iEsVD8ohyNabwarW835Ycw9hRo7+/LeNqu9ZNgvImfM=;
	b=r13tS6gEUVNG7/MZ68HLj61LN9ZHR0XrEnl5YAaOdEZnIsDqfWwAmRdQ+Q52fryEQNliYX
	k8tQxvZNL/tJDcAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763051339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iEsVD8ohyNabwarW835Ycw9hRo7+/LeNqu9ZNgvImfM=;
	b=GjK9z3pR1rXGLEcXbwxj2ecT0+AqqChQCB+Oz5adAFaE+StufOUfVFI6/dZHPPv6mbaJKb
	pzJyjzylfur2SyCH6PsBFZgtOKg5FvKMyaROdMnlPf7vh8d23YO5USzXSLoo79BAqWC9mI
	n6mrrAjBsiFuOHbFWOe8eps3ghpq/lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763051339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iEsVD8ohyNabwarW835Ycw9hRo7+/LeNqu9ZNgvImfM=;
	b=r13tS6gEUVNG7/MZ68HLj61LN9ZHR0XrEnl5YAaOdEZnIsDqfWwAmRdQ+Q52fryEQNliYX
	k8tQxvZNL/tJDcAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE8803EA61;
	Thu, 13 Nov 2025 16:28:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XVg/KksHFmnkHAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 16:28:59 +0000
Message-ID: <45ea66a3-bf8b-4c12-89cd-d15ba26763fa@suse.cz>
Date: Thu, 13 Nov 2025 17:28:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251113161424.GB3465062@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7A8BC1C000E
X-Stat-Signature: r7r9fswdinz3ss99e4srzt3s5cnzdps9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763051341-35770
X-HE-Meta: U2FsdGVkX1+1baSoPaZVLxVPVXD8vmarh+tTU+xvpy5bqoSunGguML+jpNqzz8Q6YM8Jgo+od2PJJrNLRBuMLODyVYuGKTKJ3Y9+7lXTzQ5tAfnIR8i8dHxt5TKO6fB0e6JmgBOD4i9XK6tSjov+fHOVxoTP0agMuTVKjn84tv4NQ1xr0Xxsa5aRaBcbSHNMCdJBiKkiIzMooxmuHrJuWt62f7uwh5XvdUjNHYiuynuuZQcHgM7kcfbCoN2HjEUmkTYvNjfG5YHYfFmmS4UGhBT7FimbmgdGsZFZsEQfg2xmI6tpYxA+H80GmTWWFDKQHpXix6zpU+iL5fsMHv60X58jlhhWF2KJSDOf+k6lft5i0oti8fAHH1D0vacaqTFy4MSCLhNpzKB2lTpqoOWBMAXinHYjkhHh4s3BBLLDS02GFsYwF/tcaNPN6pmWc17D9j1aMpZgIeOxDvKu99H+PkeYj3iZCT6I3m9DWsG3YgJF+dK+UMqHLNEwK7NEDBhhVMAeZuajI5TsmUS9ag4piFSfOOFwtY0u8uS+TgT7SZGITEuCgBtwk7PxoQcTM5JhtzFMw0zmD8yxdv4ZLrw8MraCb3Ac5rsddr38jfqytbEik7aJJHS5/+KmuS9mcCJ3r2PkPNMczF/BR1hyRs11NtRAz1XTb+UN9Bi9ndNpmawbgp/fkfe57nVj64vDV4+pyOjIM9qj4zaIw+7AsWkRuCHdxjAf0NfO6KcacyJg8IKSmK0qKXoCCSU6JMWjmhIhVZvzjNroqFAwRuSmEUjiMx9TZKJuSnAY5KNh10af5ASGZJSV5Sa47JXnoCkFG8rVIBnfZkMKOzl3EsK5TBhpslNFGOiGj3q3CoP6iBrgBKaaxYgknJOjtMPVUCGMFCOTWvfiVPbxl8NVL2anjUwF50Eb9foZYiS8HK3qbG0E8do3nzMDvvIUCuN1CRvuaRElLVTa35GM6HrkUL3PyrS
 rOjpjYa8
 YHxX2JVfIlvTOQhr1Ocv6S5jWV35jCxPuAc+i4K8oONURDKQau0fRr4zQSuWcaaOeLtE+/BhbLR5KSB1XjlfXQaFAKHEyema4q/bFJgtUw0LxwDfpNyu5y25fzRkPXA8TeeUs/msJgZYBHSjfdb02TvzvGAFA+Aw1uY68MTniCIC3lUQxjHe2j0rhU4vVCpBKOvEa7PR6nAx8O764Ux29TD8Gv4KsmfM9VwBYAHgvlcmf6xFFpbOKzEjL9TxaW5cZ/13gLyg6LHdeJDhDS4iMk3XdiJ41LwdgORpk7rPHLJwtYMnMIGYcPyQBQ3cYhxTNygcZISV5R7DA8Vc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 17:14, Johannes Weiner wrote:
> On Thu, Nov 13, 2025 at 12:09:28AM +0000, Matthew Wilcox (Oracle) wrote:
>> -	/*
>> -	 * folio_memcg_check() is used here, because in theory we can encounter
>> -	 * a folio where the slab flag has been cleared already, but
>> -	 * slab->obj_exts has not been freed yet
>> -	 * folio_memcg_check() will guarantee that a proper memory
>> -	 * cgroup pointer or NULL will be returned.
>> -	 */

I've only noticed this comment and thought it describes something impossible
to happen (maybe it was possible in the past) so seemed fine to delete it.

>> -	return folio_memcg_check(folio);
>> +	off = obj_to_index(slab->slab_cache, slab, p);
>> +	if (obj_exts[off].objcg)
>> +		return obj_cgroup_memcg(obj_exts[off].objcg);
>> +
>> +	return NULL;
>>  }
>>  
>>  /*
>> @@ -2637,7 +2627,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>>  	if (mem_cgroup_disabled())
>>  		return NULL;
>>  
>> -	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
>> +	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
> 
> The name undoubtedly sucks, but there is a comment above this function
> that this can be used on non-slab kernel pages as well.

Didn't notice this one.

> E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab
> 
> How about:
> 
> 	if ((slab = virt_to_slap(p)))
> 		return mem_cgroup_from_obj_slab(slab, p);
> 	return folio_memcg_check(virt_to_folio(p), p);

page_memcg_check() maybe instead? we shouldn't get a tail page here, no?

