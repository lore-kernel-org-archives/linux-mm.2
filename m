Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DAECA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782976B0181; Tue, 26 Aug 2025 04:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A6B6B0182; Tue, 26 Aug 2025 04:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649026B0183; Tue, 26 Aug 2025 04:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8526B0181
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:51:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E81C5C06B5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:51:38 +0000 (UTC)
X-FDA: 83818290276.03.1B58ACA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id A750EC0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:51:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q36scFBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t53TWzCe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q36scFBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t53TWzCe;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756198297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufVkpPwtQutVDZsBUYqAOSqGDbYTWA0sDjJ69c5U8ZI=;
	b=6jjG+oZn5JoYMVutzvlE89be5ar0DjRPs/tdcZc0hwp5oGP6MTZQA9LeyS2001hGudnyS9
	NbinPVPzCfKBrCik4h1Buwt47Jn27Guw0/TpQu6XI7QGXct+/yjHUDkGmrpkxYaagWvx0h
	mNdbpCj1hjduoGt+Kb0e/WB/HXFnpvg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q36scFBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t53TWzCe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q36scFBY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t53TWzCe;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756198297; a=rsa-sha256;
	cv=none;
	b=pNyluKjjux6NGnPolCbqzJ9pFQp7DQimnoZ/f747rHKZ/8CsJJcqzntuPTaR63QTUiGDl+
	2VoHqwjBmtjSxio6nDDp1U7uQHtC552PY/j4IL7ZLPL4PPkioRAbsSf2LcTxLS2WVAYjLl
	9yq3rTq+2fVvKIYP2U3ANMEKM72HtD8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D271021241;
	Tue, 26 Aug 2025 08:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756198294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ufVkpPwtQutVDZsBUYqAOSqGDbYTWA0sDjJ69c5U8ZI=;
	b=Q36scFBYhGcmbA/HFYYrNeARQr1EN3ffNW5Fk+uMM/wdhwEStZOMiwhmEYUamCEFLUVQjR
	1p/hAXLzJFonWw+5Q5cR1DL/XVZ6iwTyN5fc54qafVjto5Ab8lqU8MNXYTWhueGa1bHD7C
	JsuJ7ylY3Qhd7KMOnrqkMp7FrLAS0ws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756198294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ufVkpPwtQutVDZsBUYqAOSqGDbYTWA0sDjJ69c5U8ZI=;
	b=t53TWzCeusuWJG/2cJ0mHNI/Tx282ahU/hmVeTE15zfNo/Y9+0sX6Vh80I0CfsIa8ratpi
	E/U/kEL5buYK6nAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756198294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ufVkpPwtQutVDZsBUYqAOSqGDbYTWA0sDjJ69c5U8ZI=;
	b=Q36scFBYhGcmbA/HFYYrNeARQr1EN3ffNW5Fk+uMM/wdhwEStZOMiwhmEYUamCEFLUVQjR
	1p/hAXLzJFonWw+5Q5cR1DL/XVZ6iwTyN5fc54qafVjto5Ab8lqU8MNXYTWhueGa1bHD7C
	JsuJ7ylY3Qhd7KMOnrqkMp7FrLAS0ws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756198294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ufVkpPwtQutVDZsBUYqAOSqGDbYTWA0sDjJ69c5U8ZI=;
	b=t53TWzCeusuWJG/2cJ0mHNI/Tx282ahU/hmVeTE15zfNo/Y9+0sX6Vh80I0CfsIa8ratpi
	E/U/kEL5buYK6nAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8FC313A31;
	Tue, 26 Aug 2025 08:51:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Lz6SLJZ1rWhHVQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 26 Aug 2025 08:51:34 +0000
Message-ID: <ce289766-6d7d-427a-b9bb-8cb3634dbe9b@suse.cz>
Date: Tue, 26 Aug 2025 10:51:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
 <CAJuCfpG5+oJY0aaE3=VOGtRxEoCgjejg-WTqrXU0TffFQ+7TQA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpG5+oJY0aaE3=VOGtRxEoCgjejg-WTqrXU0TffFQ+7TQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A750EC0005
X-Stat-Signature: xtb5ug3szy5jzkc9s1z1cgm85xx8pqtz
X-Rspam-User: 
X-HE-Tag: 1756198296-473831
X-HE-Meta: U2FsdGVkX1+/XSfY7u3phE1TcKR7GkQdBOGnizz6IHQosMgcdoZbuAy3zKhZb8ZRs0azIrRMaHujVwtevBQU27B69ffYGqTecLgJx/Qn4ZBCwZSGhqLa+T+nDNEhiHScd5P2lZf4txY2EIsE3gyR5sVwLRrVmQUMG+fsuYtddBNi24w70/xBQELOjLDV7zFL7IVMRCEBtS1FfS2pOUbA6mm422wo32n7RI7w3UvUA4ftQn2UQ4i4NizrlNjUKI5IgqDJLWkP/c/P7LI/+tt9xZ0olTXeeobvPX4OUqZ9uDmFbAiLOLLON4RmsqRVQ9wc6UEV5A86zT92O24cLyIraKeLjm7RSOaKzeHvnwk2XigxdqpJuWMEHki+9+T0kg8UEJBYEGHf3XOD4MFBcFsRWALwp+uyXglX3SoRGVwqYlbWjjcAu07NX2W8tV1WaJsSzrTwnhns18EsdARjKPlyJ8+CycT1rR8YH70GsouT8IqHlGpaFiiavTCdj1YGuJ/H8Xt24U8/XWgnEs64vf3QCJhyRSS51xXFTDvLF3nqFOdZwctDIajG3wBCPnQBR/xN7V3vHj5qn2RwUzivEeShNgdIea0TpzLscfew4eSk9LNd4HlPRei9vVB6Dj3RTZZk6jxiGiKo657z3Jzb8Insgl5hholLDDxrTjf0+M4CoQ805YKENrUdVJB1gfq7hcs5oP+IdIEUQdnODR0tpIxrNlBxds2KjAfINYWqUvxQs75lzSPgIkqqqyThEFUhVEU8YzYxIVYEIylI+sGMHsixj3K4D7cUFQllwqSs35QGqlanjRcCxKY5c3YWt/LL7MkRZU3uULCJ3jQpS3r00iqpuK2pm+0C8i9SB9ZaWUV0SLwgivqUsp7CUbT+5W0fwWF9r7dAaOkaUcXJ/FrPQrgWfOUKxu+QmAF5IizPfL+Et4jihwEN/G3Ud04opYhI0MehbT4wSuYmSoMrMUE76U+
 tlKwLjts
 oPV7GOq5cZEvn+HqwdWyn/lFs9k5kfEdVMY+b7exiRIcbX2eMHeI7mDLcvQVEsgGf7t73mWQ3pzHDQO5NfhQnuqVv15ZahW0IEau/tpVKlIyXsks1kQPfrcVunlAHtNExmuK9cWDre0d2AJ3vOv8x3VVaPYmY+Oyy/LgP/k1+ShiwqYVDW+Zh8SqUlmbSx6Eu/p1nuIPg/UtxXCv/Bx5ATCRDx/zuBVYlJwB/T1FmU9FJ2l9d1Sjynows9hkfV51lOiMQ7iO9esEKg1ioy71AVSc8pea1LHOG3e6Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/25 06:19, Suren Baghdasaryan wrote:
>> @@ -5624,20 +6561,29 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
>>
>>         for_each_node_mask(node, slab_nodes) {
>>                 struct kmem_cache_node *n;
>> +               struct node_barn *barn = NULL;
>>
>>                 if (slab_state == DOWN) {
>>                         early_kmem_cache_node_alloc(node);
>>                         continue;
>>                 }
>> +
>> +               if (s->cpu_sheaves) {
>> +                       barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
>> +
>> +                       if (!barn)
>> +                               return 0;
>> +               }
>> +
>>                 n = kmem_cache_alloc_node(kmem_cache_node,
>>                                                 GFP_KERNEL, node);
>> -
>>                 if (!n) {
>> -                       free_kmem_cache_nodes(s);
> 
> Why do you skip free_kmem_cache_nodes() here?

It's not necessary as the caller will perform __kmem_cache_release() which
calls free_kmem_cache_nodes()

I have incorporated your other suggestions, thanks!

