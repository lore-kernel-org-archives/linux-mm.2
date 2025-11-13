Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFCBCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151F28E0008; Thu, 13 Nov 2025 14:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129AD8E0007; Thu, 13 Nov 2025 14:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018568E0008; Thu, 13 Nov 2025 14:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3D518E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:26:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3303AD43B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:26:58 +0000 (UTC)
X-FDA: 84106566516.20.21D7F1B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A80B160010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:26:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=czRcA7DK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DbmFBU72;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=czRcA7DK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DbmFBU72;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763062016; a=rsa-sha256;
	cv=none;
	b=h4DOrwHvcCFyOfhQoOZdD1fSRSQ2UInvIS+l5amPGF8PiBcOnGxxIon+KXRSEew6vq5O2x
	2i3qS32OGF3rg+rRxDsVuyVNmB2cCMr6SHI96DWSWuJuLaE6CzqR0ivRZ2sNoaJVPZLFzf
	2KPYzA/CRuEn2wLbWp5YzzeWZfFC1w0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=czRcA7DK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DbmFBU72;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=czRcA7DK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DbmFBU72;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763062016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApmPNMsQ5P8JOyIRSuIZemOyEvUP5woSMa2h7S6We3o=;
	b=RUxJa4Ackzf6AJqOMi8p5PxqE+OjbmOzvsJnF/im4fggrIBY53lb2JWWN1o7Y1e8v6obDW
	npS3HZGIjRHvNx8FZVyrIyuZAxjyBJqG6+X/3iHtXd1d/ZNYyKTldxuuZmCOOyXQ7rg0PJ
	jN5mmJwGcap1/YiwpH7eFG01ajlHptc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D2611F444;
	Thu, 13 Nov 2025 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763062014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ApmPNMsQ5P8JOyIRSuIZemOyEvUP5woSMa2h7S6We3o=;
	b=czRcA7DK6KuVnpG2KPuH30sxjstEa7zIOQBmar2zztdjGgMrjAgoq5v9HfqVYDv/2ZyckU
	23gbIz/PJ0tm8El77LGqu0fhwDF3DLtrNOkDXyIyxApNwPlvDXAZlZIqvakkrj6kssNYn3
	colFjI8oi2GkG8ccclowaxmS/GW9nJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763062014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ApmPNMsQ5P8JOyIRSuIZemOyEvUP5woSMa2h7S6We3o=;
	b=DbmFBU72tsPlhIt993gyVnbLqLavnPRenY/LE8txH24EiSi+mWhukO1i9If7AIEXTNpb4j
	U6bzQT0+45syZpDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763062014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ApmPNMsQ5P8JOyIRSuIZemOyEvUP5woSMa2h7S6We3o=;
	b=czRcA7DK6KuVnpG2KPuH30sxjstEa7zIOQBmar2zztdjGgMrjAgoq5v9HfqVYDv/2ZyckU
	23gbIz/PJ0tm8El77LGqu0fhwDF3DLtrNOkDXyIyxApNwPlvDXAZlZIqvakkrj6kssNYn3
	colFjI8oi2GkG8ccclowaxmS/GW9nJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763062014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ApmPNMsQ5P8JOyIRSuIZemOyEvUP5woSMa2h7S6We3o=;
	b=DbmFBU72tsPlhIt993gyVnbLqLavnPRenY/LE8txH24EiSi+mWhukO1i9If7AIEXTNpb4j
	U6bzQT0+45syZpDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FF763EA61;
	Thu, 13 Nov 2025 19:26:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R2S0Cv4wFmnFRAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 19:26:54 +0000
Message-ID: <469f1896-00c1-4174-a0e5-4f2987b19b38@suse.cz>
Date: Thu, 13 Nov 2025 20:26:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
 <aRYJzbZpd-UP3jh9@casper.infradead.org> <20251113191637.GA1240@cmpxchg.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251113191637.GA1240@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A80B160010
X-Stat-Signature: oxr5hac95tpyntbq9uwew4e17b49qqry
X-Rspam-User: 
X-HE-Tag: 1763062015-576896
X-HE-Meta: U2FsdGVkX1/6M0Yw4nMwJowfKySOTJH1attwayO8yBCksC5siYzVQDNMpBrSYDatXCMmowc/8vQEgyxVTfs47i7YyXDktNL81QPsUqOb7Ja+PG3zu7nJGvy+cdzVxlgK3cqF5hwX9P25UjYeoIGdxs+tqm3BGMV3AACIQ0ROVMuyAySZpssLjCAG64GyK3PmhtlMaUBzOVjJ72IqV23DZkgEtAcIqFq4gqH46RraWChhVZuq6Ltg3NSJNcKoCEUWAko13efjEMmAQWYSYI0/Ytk9M76AX2tRrn7T7Sv2pe6ucOlxFkTwb7ANh9nymOaSGDhPXvL+08M1qhlW4uldi1BeyZLOb4iIkqQ0uKDMUqjNdbHbyaFX7RZ2p/B/tdvz7dpI7oPBvB6+zgsyb2ZmImxaM2o+vlBQZbB56K30RhAmp6pOjIszWfUjtg94qZa/JPF74VQx92C1uIPkaZ0LvnO70yWGEkudgFMjZhXbWNnachQJVLZHXj2ip0SsPslppeIPsJS3+e0uaTR80Xvwr2MYyyGeF5ucAicSQ7keMZrnPBhSDg8RQd/C8SO87yAbmWGHCd4AD69Ys0s13HrUmrNSf6wokf/asWELAbj6u/jciPQzXW+ehnuwrn9NkGOqinqZSW5ANPjIgO9SviEfDVYJCBdAjBOBVAZQ6N8rnqerTjEPfuGubah/WpE5lD5Oyz/3PcSnYiOKVQz/RzWDKlg+wnbngt3giyrU8sHj6X9elP7c98jJQtaAAkQkZe41m9WEl0serJ5oKLU0JyEneA1HtEeIp0HY+WKr+5hUGrqtr3ncua4RP7eoiduDRxtFhjGSzQhMhHWrYCrL8FtCiQI59/TXPpGlJmq8K8FuqqEw5Z2cR7CASshqmgfxPUK9PCCC0Iu1zGeFOzKdQFGO/pM8IrjoDux9rZZhbRa7AvY3iYaGuJPuzoz+WW7kEXD0hrCQrl0Jh8wX/JYAZm1
 ik4v/zAp
 Uhoin64TH6tqMt1B4bzxGfz3eQRbnCluz4RGwL3erv63j8c5rJCQfiINaQ86dJx8JBsmwiyY9AyWzuHV8C/VGhZ6kXJdZdvwxCyRs5Nkras1xrwH6LQKbIKygrYpaSLwUcQMegKpGlnu+n+bGrJf6x1gYAX/rORq9H31yFwL2uixxdB0fysz6D7XVbs9W0St/56Xv3XAuAEZkbNYa/Wdq3BFI0wEeiaFGT1niTnaEjUx52lm1fvvoIC0nGj1T9SESDFS1MSrOZnpXsp/phjNZ6vKPz+PUncK6DNHJnx3c1ZucL0xB6F1A2diGKEekC8j124PC1drEd+6dhKdChBT+aq5W2/4b8a4U8kuQ6pbrKV7q4XjQNLCkilR5717IGtvLQSKFIhu1jFog2sE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 20:16, Johannes Weiner wrote:
> On Thu, Nov 13, 2025 at 04:39:41PM +0000, Matthew Wilcox wrote:
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2599,9 +2599,6 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>>  	struct slabobj_ext *obj_exts;
>>  	unsigned int off;
>>  
>> -	if (!slab)
>> -		return NULL;
>> -
>>  	obj_exts = slab_obj_exts(slab);
>>  	if (!obj_exts)
>>  		return NULL;
>> @@ -2624,10 +2621,15 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>>   */
>>  struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>>  {
>> +	struct slab *slab;
>> +
>>  	if (mem_cgroup_disabled())
>>  		return NULL;
>>  
>> -	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
>> +	slab = virt_to_slab(p);
>> +	if (slab)
>> +		return mem_cgroup_from_obj_slab(slab, p);
>> +	return folio_memcg_check(virt_to_folio(p));
> 
> Looks good to me, thanks!
> 
> With that folded in, for the combined patch:
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, folded.

