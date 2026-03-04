Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B77CEF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569E26B0092; Wed,  4 Mar 2026 08:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521076B0095; Wed,  4 Mar 2026 08:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4196B6B0096; Wed,  4 Mar 2026 08:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8F56B0092
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:39:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 043308BC66
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:39:55 +0000 (UTC)
X-FDA: 84508488792.06.8FEE40F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B9CB1C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:39:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OmVfd74f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQIxw/Z/MQdGpERM5wxCSHfUwJz5mLloHMNRL2tJ/vM=;
	b=q9qyd676l8p0AP3SRFr871pCBDvxCzVg322HhBK3WpupkwAkBvcRBiMvKfS3GM5fljaiNm
	S6wHULpHqLmpk4QgeCceY46d99fGt4eATpFU88gGxGkPerAhLL2NEQUb2VjTyHspO0JnUx
	g2GfUU18QDp5szhzIu6BbjTHbuiFPh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631594; a=rsa-sha256;
	cv=none;
	b=Lrx5EPmzE2POQZc0zIAj5OUNrj2auFU8HTtMprnCpWs8q1Q9xf0blcMEYMiRywkIioMnLk
	GMDfntnCvjAH/AtcFx1ZTYVI4y1pVzTSpDM7Tu8sBJuu/NSUyzFL3BL19uEGU9dI8pE80q
	jK8NZt9eoTXY345sn8qWMAsSLBCirec=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OmVfd74f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4145D437E1;
	Wed,  4 Mar 2026 13:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ECAC19423;
	Wed,  4 Mar 2026 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631593;
	bh=tBg/hfXGbB8kC2UwsbFj4SllrfktIr46ew/BFF078eA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OmVfd74fEjgnoLPP+YJzeIx2IjGp7V0GPXUHue1QkmLdIDIJNgfvesZsuVutlPBPW
	 +yQiwp2wzAl2OLloNNG3I2H2o37SlIBQSx1Rsr77wESVy6yIsEI0BXcjm757AwgLvk
	 cCNHhAxwddyuzkM8oL9xzu7pls0y/+yGaISktJWKXtdvuanO2ssGqIDXLs1BXwxqMR
	 mh5dRFdKmFHHrG7CGzHxpkANcEmqQ5quTPgCDxT9g7elPNd+JeTHPAMdILHfdhzBi+
	 ryjJRBLNPlFp77s7IDc7SvOxX9exg6SGTVH4daWRSbgz7J/oiu3Qby6/Q4O3Xy10qU
	 +7EkbTJUJjvqQ==
Message-ID: <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
Date: Wed, 4 Mar 2026 14:39:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qing Wang <wangqing7171@gmail.com>,
 syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
 jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz, Hao Li <hao.li@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org> <aaeLT8mnMMj_kPJc@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <aaeLT8mnMMj_kPJc@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B9CB1C0002
X-Stat-Signature: oyzqy8zezin6jhkzi9y1fkdx54uthqfy
X-Rspam-User: 
X-HE-Tag: 1772631594-466945
X-HE-Meta: U2FsdGVkX19EGN7LdxTeq3ioMFYownKW8xpRCqbiDcsDPcGsS5RaEqRYb7SWWKyTnb/7ewC2LmoMdD2KHm7Hf1eldOePy+B6J1dmA22l2BIyrA1wisuV4Qsb5jrfPPwNsH9k9JWHN1Q8hg19w4FPeTbrTNDB/67xDSJeVcC514C2neXXp8x5sojZ42SNuAWijTiwyjULWxSMqE02uzcR5+Jha5Rumoz7PTEsPXbjbA3fogBUqUrjvmAefQe+tV26cGS8u40jlW/6sLKIPnN7vYQ0NtuxOIt5BzAAPJkWX57cfWciDeUfkPjjWjHvh8y3Fq6DCcJ/mh53yU+97uM4MPtEm0r+3XU34fAm3mjVn5GjH+ATmhYBhTCkDJDnxUKspsptLRvjNtGioa3GBAWzdYAAy2snOauS3HHL10pdITvg/QNmTZGgK2eb7VIsRG42czvi0NRXu/hfpuaWo8D7y9SlXgPiQteM706keEGd4Eaulf7MDG9U/ktlKnS9AHjERfioUPBSjmEe8bETBZSG7IYt1Yq1sg5+oQoDcPn9YSUKIgShAj7vTznWgDjekAyAwHQPTgRbAZbxS999MAnWJFJtbkd18ao+w5ikwqQQfBp2r6PfNqtKrMVL1lut7kiafAQGpKV7f+9+okNgFkimIw9BQPhWWpTWMVR3+W+1ZG7UZfaGeobaoZwOoVgRoc/Fooz0n7GM1zYP7v0benuzXO9J/6b6u82EYr2WWk5T3ksk4Fh9ZjqAO0/vn/rOYpHfR66gfrfa3fLCMcrhYBYzFC+d+jksO294jB6zh4VA7V/83lZVWrXtEJJToi0dSGkHOIehkFboyX5+0/XRTgoEhSCcxmgBmRx5A04IWe/2HdDVuDcYYqO/BJTUfPc96Rsz+MwFJe9W9daYnRImodrXuxNRZ5nedO/eNKj9zaEnPtrQ7J6zJ0LZ9eRKkK7tq4oEL+Dd8E79p/rJX1YyrJM
 NPm/S1lg
 bF24miCWdg319JGFyYuU4q6DE9aS/lRUxSmrWL67yMpaThdcO+M+YBkPqPCirFyvtQUmiErdM3XvQClxkODt19Yi1SFnqPO5U4Y9iZXWcQCe/pLSKxVkDU7SkY0tLTF+YqJr+of+kNrf5YXGER0nXro2DhmN+ghFGx3CTN16vjmuDanUU54qbANvzibJ+hSAQeMAGb00g01Ssfzvxl+GarxwTtIdZjidOGqPUIplAXph1tWCbNeAsAZ6EzHGuUEZM/tFplH8QwSyVN604kwCtDO3qph1Aqp4uOEbqv4q0e1daQnNGDVaISQT0FX8tGWP1CuPhpaua4gh6um2XaSFzklxH7dIhOmhOsEUW3DUyx8fEdvhXcF6R4zYhfwg9AgadKKxommE+oPtkL0lcpgUVnUSzpefPCuGzLH3dQwrB8eyGD8pB1D/EkRQxQ76qHsoMGzJM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 2:30 AM, Harry Yoo wrote:
> [+Cc adding Catalin for kmemleak bits]
> 
> On Mon, Mar 02, 2026 at 09:39:48AM +0100, Vlastimil Babka (SUSE) wrote:
>> On 3/2/26 04:41, Qing Wang wrote:
>>> #syz test
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index cdc1e652ec52..387979b89120 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -6307,15 +6307,21 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>>>  			goto fail;
>>>  
>>>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
>>> -			barn_put_empty_sheaf(barn, empty);
>>> +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
>>> +				barn_put_empty_sheaf(barn, empty);
>>> +			else
>>> +				free_empty_sheaf(s, empty);
>>>  			goto fail;
>>>  		}
>>>  
>>>  		pcs = this_cpu_ptr(s->cpu_sheaves);
>>>  
>>> -		if (unlikely(pcs->rcu_free))
>>> -			barn_put_empty_sheaf(barn, empty);
>>> -		else
>>> +		if (unlikely(pcs->rcu_free)) {
>>> +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
>>> +				barn_put_empty_sheaf(barn, empty);
>>> +			else
>>> +				free_empty_sheaf(s, empty);
>>> +		} else
>>>  			pcs->rcu_free = empty;
>>>  	}
>>
>> I don't think this would fix any leak, and syzbot agrees. It would limit the
>> empty sheaves in barn more strictly, but they are not leaked.
>> Hm I don't see any leak in __kfree_rcu_sheaf() or rcu_free_sheaf(). Wonder
>> if kmemleak lacks visibility into barns or pcs's as roots for searching what
>> objects are considered referenced, or something?
> 
> Objects that are allocated from slab and percpu allocator should be
> properly tracked by kmemleak. But those allocated with
> gfpflags_allow_spinning() == false are not tracked by kmemleak.
> 
> When barns and sheaves are allocated early (!gfpflags_allow_spinning()
> due to gfp_allowed_mask) and it skips kmemleak_alloc_recursive(), 
> it could produce false positives because from kmemleak's point of view,
> the objects are not reachable from the root set (data section, stack,
> etc.).

Good point.

> To me it seems kmemleak should gain allow_spin == false support
> sooner or later.

Or we figure out how to deal with the false allow_spin == false during
boot. Here I'm a bit confused how exactly it happens because AFAICS in
slub we apply gfp_allowed_mask only when allocating a new slab, and in
slab_post_alloc_hook() we apply it to init_mask. That is indeed passed
to kmemleak_alloc_recursive() but not used for the
gfpflags_allow_spinning() decision. kmemleak_alloc_recursive() should
succeed because nobody should be holding any locks that would require
spinning.

Unless it's some interaction with deferred pages like the one fixed by
commit fd3634312a04f33?



