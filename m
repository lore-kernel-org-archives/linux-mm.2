Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFFFCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD958E000A; Wed,  3 Sep 2025 08:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E388E0001; Wed,  3 Sep 2025 08:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255938E000A; Wed,  3 Sep 2025 08:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1FD8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:47:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8F025A7FA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:47:33 +0000 (UTC)
X-FDA: 83847915186.19.CB5DDD6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 92C6B2000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:47:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Idrf0T4V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WAZz2a5e;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Idrf0T4V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WAZz2a5e;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756903651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKDLo2U6wbZmGQq3JLrc2as1Kfyo9X875klaxHPtp1I=;
	b=kWZvyMBvWJuGHJvfLK0XjNbCSe4TiTkXjQ+6UD0Emhb/MStmm4SFF240iY3Pn9sYI1nrK3
	vhxbeCKjkr+ZnGAhwcdxXhp+s1gCaBrFl/fjmuzeugBPKmVSygtF+MRBKVdPeRihm0Fs7j
	zuNQbasaRbfrTVX+lzoiO7uBi6PE70Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Idrf0T4V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WAZz2a5e;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Idrf0T4V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WAZz2a5e;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756903651; a=rsa-sha256;
	cv=none;
	b=UlqNurjxNv61YT3n+w3yDdRoPnfT3x8BLH6vr+/Ni3cdYe/g8v+JLGE1mSPjFhmq3VNFvm
	bXPz5UiQdvG1hD0DK4VJo6+C/+yaiOL4/pIqi5vET3ZOjTD1xDkmvfOlPWaHvRr3NejqMn
	HMshI17K4Na43DOUP6b5w30Qh7T1Gxs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD56D211A7;
	Wed,  3 Sep 2025 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756903648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OKDLo2U6wbZmGQq3JLrc2as1Kfyo9X875klaxHPtp1I=;
	b=Idrf0T4VqKTntXRozIlmr4GI3JLoXycvFaV2uWpOTnXDCMsVmlLl/W2ZqYYVj6Ui7JvG4e
	6GWqt1HM2Yi3wVuhrkd2xMV2uX9lSGk6dosLytSqNiyBoNzPG2abm5outxoihR2b7JuWoU
	EZ+Vp/30/MGRd5xoehmVoKPuOZCxcgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756903648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OKDLo2U6wbZmGQq3JLrc2as1Kfyo9X875klaxHPtp1I=;
	b=WAZz2a5eznf/jwAWDExdbBvi3kfFLd/PXdRK137e98aTHgqvQAQ0cyNzf3ohDvoei0lHK0
	PyT0PtWqslJ8bdAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756903648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OKDLo2U6wbZmGQq3JLrc2as1Kfyo9X875klaxHPtp1I=;
	b=Idrf0T4VqKTntXRozIlmr4GI3JLoXycvFaV2uWpOTnXDCMsVmlLl/W2ZqYYVj6Ui7JvG4e
	6GWqt1HM2Yi3wVuhrkd2xMV2uX9lSGk6dosLytSqNiyBoNzPG2abm5outxoihR2b7JuWoU
	EZ+Vp/30/MGRd5xoehmVoKPuOZCxcgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756903648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OKDLo2U6wbZmGQq3JLrc2as1Kfyo9X875klaxHPtp1I=;
	b=WAZz2a5eznf/jwAWDExdbBvi3kfFLd/PXdRK137e98aTHgqvQAQ0cyNzf3ohDvoei0lHK0
	PyT0PtWqslJ8bdAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A69AA13888;
	Wed,  3 Sep 2025 12:47:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jS1YKOA4uGhdNAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 12:47:28 +0000
Message-ID: <814c7054-3a43-4190-893f-22e074dc93cd@suse.cz>
Date: Wed, 3 Sep 2025 14:47:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/10] mm, vma: use percpu sheaves for vm_area_struct
 cache
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
 <20250827-slub-percpu-caches-v6-8-f0f775a3f73f@suse.cz>
 <195d00ab-5429-48ff-b5dd-a45b26cd9ea9@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <195d00ab-5429-48ff-b5dd-a45b26cd9ea9@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92C6B2000C
X-Stat-Signature: hrak5p77u3sgdec8dy1ygzkbi7mboj38
X-Rspam-User: 
X-HE-Tag: 1756903650-613999
X-HE-Meta: U2FsdGVkX180n7wMv6WzMNmbOowr09Utq6npB48cEzd9kiSzN66QG2MubphQDqltgMQC0uWJ1iRJDvwn5eFpDHK5D21AWs3amVSqye4Mn8un2q4xjqbDBSS8yR50RNLGqCv0Ic9N4Dqx6anXrk0bjHBiUWqn/d5DkmMVJ4dGrEMMA7i57uZm5wghrm6J5PXX27ssTJBf8DFEMqfDQpD+UQYOC9DgW2aiyCCFcAHPr198s5tfsrSG8IJ1b4teEM5u4uiwoeURDczeXP6Qwd2rZv7ahQXWIQbAKsef5puoQlluIyTiwxJ6XqmLsKU7I//sAJCQrkxSMTHjxc/4IUMTmzNeXO/J93Lc+vKlvAFF8gNoOyiXZkYY47wkyDieNucrJ/+PPbmnrUaKqnNTCLTyLtfZlMUGcImXPF4lhuhQSkoYMk3s8LX4KfTqalnZZOC9K7STVZJTfDXNyAgWU2sLvu23O5HsHKH5j2p1sjkVGrZ5LSVKK70PZmGGNoWPdnp/hEnXgct4fgZfUlHt8FVBe5pu8mnegNAOcZxBiJiIqIYeuxMPGxv8feQDDa8bMhCpv8V1VHjV8EyxL81b5D1IJW8UvQ+fcCj1cf5F5VX4rlTziZelPDJo9g/2cmaPCgECN8p0GZv04pWlp5Ayn8YcrF7BvWB7qu/alaEqcbT3oEz7pB1d/xQGTn69/bRNNHPOM9mjpbJ4NAhyz+qvthWjLMf5rojVc7hRiIOPqSMsDPadrqBpNzxSp1XCiphoKJwd1skUkeB3YsTgg/GZe1xgIyn3zeV+9JNABlWn22k//r0Wvd2KfYWA3g7UJtxOsqmnYhMm0z0OE+TyFwzw/91mJOZhPTC1b8zXCkzxGDxKLcC+dwE/2/3ROT7rKoh9yTZDkmtCTBsvu2B1w1La0lZ8PLyr6R3HJy0czJX55y26EUhbdQ+BZnq7DVlDwb/Torf8cUvfMKXhqqj8Yu5Si4x
 DlOAfRKX
 lKq9heMuXO43/KoyA/ZQyYAr9YiIHW78JCrhZ+58bqv6nqGRI3XwHy0mOV5CmoSJ38VGQthxM8ntFZn8bmkzHnK8cAIXUTytNttiRlEqwGFKX2oJWx79l6wSY53j/cCBm223r8gGUhp9/JdHgBmnu/wWOMHBk+LbYid8Tvh3sEacXio6WbhmoNPebHR3ccV38ZSs/OfvLSzkNp6DyAEVHQ0vZvBsQgBG0WbZVbVBLTG0WVpTaaUHmW3+aLLsMzXa8HY0QgvVxS0koPecwsq+CAiNWvBjy8pMQz8oFTSqb8PYutWXpzIFYGUZgw5pOZ4h+F9V8BoSb/BgHbC84PQ/LDojzGm5SfGvtYbvQZqOcIr8FAD4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 13:13, Lorenzo Stoakes wrote:
> On Wed, Aug 27, 2025 at 10:26:40AM +0200, Vlastimil Babka wrote:
>> Create the vm_area_struct cache with percpu sheaves of size 32 to
>> improve its performance.
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/vma_init.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/vma_init.c b/mm/vma_init.c
>> index 8e53c7943561e7324e7992946b4065dec1149b82..52c6b55fac4519e0da39ca75ad018e14449d1d95 100644
>> --- a/mm/vma_init.c
>> +++ b/mm/vma_init.c
>> @@ -16,6 +16,7 @@ void __init vma_state_init(void)
>>  	struct kmem_cache_args args = {
>>  		.use_freeptr_offset = true,
>>  		.freeptr_offset = offsetof(struct vm_area_struct, vm_freeptr),
>> +		.sheaf_capacity = 32,
> 
> This breaks the VMA tests.
> 
> Please also update tools/testing/vma/vma_internal.h to add this field
> (probably actually at the commit that adds the field in mainline :P)

Thanks, one of Liam's patches to support maple tree tests with sheaves does
that, we somehow missed that the vma test also needs it so will reorder
accordingly.
> I do wish we could have these tests be run by a bot :/ seems today I am
> that bot :)
Sorry :)

>>  	};
>>
>>  	vm_area_cachep = kmem_cache_create("vm_area_struct",
>>
>> --
>> 2.51.0
>>
>>
>>


