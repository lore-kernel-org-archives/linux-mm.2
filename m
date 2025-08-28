Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC286C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8DF8E0010; Thu, 28 Aug 2025 05:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0948E0003; Thu, 28 Aug 2025 05:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178468E0010; Thu, 28 Aug 2025 05:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04DB68E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:03:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1BD71A0A42
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:03:26 +0000 (UTC)
X-FDA: 83825577612.29.6A8A878
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3134E1C0002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:03:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2f+XuTTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XhNZ0LfP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vMwW8MFu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1QSW4NzJ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756371804; a=rsa-sha256;
	cv=none;
	b=i4mmMi7OOHRHtDYH9F8ATizcJ2p0tsDHiKm19/Am1wlN5j9ajJmOFUS7dKwv7yDLruWz57
	PNiKWMLCtaJPjB9g54BFuguR0vXEmw6xzbFhnXZDdKDhRDRXMyUEh8OwhlT0Aser+Nl27g
	admMIHDRJfPqHMyr3vJcftUCYIuRCEI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2f+XuTTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XhNZ0LfP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vMwW8MFu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1QSW4NzJ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756371804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnWnXs0CP780edLigY1ylIrEEjBBKs5wL6WsgJXXSl4=;
	b=74eOIvWaCyzKQHyCAb8nFHZ90PSt/wWrvdYoR81jxv4sy3UnSY9SNytDMvUkqPmLDw4EcE
	K6nILITxTCccxTVCyClR4kwD9u+LEZINKl2PKaxBWABJfuQYah27bIhsR/2+BkWpwwecMA
	N2zwaa/EIkytxv2y4dEVcb8kkn6rI20=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 528E01F45A;
	Thu, 28 Aug 2025 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756371802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LnWnXs0CP780edLigY1ylIrEEjBBKs5wL6WsgJXXSl4=;
	b=2f+XuTTo/Q2Vq5YdTEYIm0BOPLvUaIam+4Auv+w10RpXRV9vJnD7EdRs9u3eTsL6gllUzL
	KtK1Prc/dbAohnFHHQhE1wIUcxX/tUgq8d7AgRH7eufzN9DeIxB1lJGWMtjxPt3MtVgbXo
	dpzbp7MCGITs1kkmiGHJ+g7xZqUN8yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756371802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LnWnXs0CP780edLigY1ylIrEEjBBKs5wL6WsgJXXSl4=;
	b=XhNZ0LfPmwZwzEW+1STFcfMcv74GO1GROTAkNI+YU3/pUfNPyjLa45UTOJxm68NjCHM9e5
	3ksv5BMeefa48XCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756371801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LnWnXs0CP780edLigY1ylIrEEjBBKs5wL6WsgJXXSl4=;
	b=vMwW8MFuIyTkeIclx4zAp2CO9EGH8uavven0DthvVSOLmBl8wXL6CULlgc2imORQej9HcH
	McbZLiohLZFnrJvuXY1aTT++YiGty2/pu64BaS/vNhziAv0HNOXmnyCZ2J59JjVx5smzgd
	wKnHIChm97guBTxQiX/nqOmtIgxdVWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756371801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LnWnXs0CP780edLigY1ylIrEEjBBKs5wL6WsgJXXSl4=;
	b=1QSW4NzJcSRXbjIl+kt1QfdTqg+AWLhk28rSJwePQhuGvxI9CntrgBQqfSUY3VqT7+jei8
	lbI1CtjUBF3jnpCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 183851368B;
	Thu, 28 Aug 2025 09:03:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VE0EBFkbsGh1NwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 09:03:21 +0000
Message-ID: <d883b845-28ce-4804-b2bb-0ccea0100fa2@suse.cz>
Date: Thu, 28 Aug 2025 11:03:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] slab: add opt-in caching layer of percpu sheaves
Content-Language: en-US
To: Thorsten Leemhuis <linux@leemhuis.info>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
 <20250827-slub-percpu-caches-v6-2-f0f775a3f73f@suse.cz>
 <9f61c814-0d39-46f2-a540-cc9c0e716cf6@leemhuis.info>
 <e58c8482-bd11-4111-b912-daf8b43ebb15@suse.cz>
 <4585de6e-a7ec-45a3-8421-dc9e1490cdf7@leemhuis.info>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4585de6e-a7ec-45a3-8421-dc9e1490cdf7@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3134E1C0002
X-Stat-Signature: kbuyj3t3cu6zt7efnpxj13dmofuy87uh
X-HE-Tag: 1756371803-374965
X-HE-Meta: U2FsdGVkX1/xoYKBdA2q/z52V84a+woWvLAmgcB4jff7uIIXt6V160X3MxKowO9VEMdF5pmJYfmQdgV6p0vjhwDJmXLd2+TEUeq6A8f6AxackuSNjC/D3K8rCoW9CsElDLZYrrm5sRk3gdf3ssAqiZ+6L149xpObN2SrHkcqoM3+1oBOuzQgYe4V5FTlO/TNFlGrFRvhFREsgW74CRUqbThUgmGKvMck+PLQuSO/R80uDFkdBEJqaIAtW1prxGivCxfc1VCElStuuubZsgbYEkbOurFUK4wiBzSG1TII9k2OTXS5/MDnN64QHCMmnVkwo2z2cdj31TCPy99qzthOEI3+Qzu6D9i4CHG7t0sBQiWiwdkfSy35C7IgaOcNLIDr5oO8KlKrvlvFev0fGtXW3kLbFI/ZzQHgu6znBKnvlG3V+Yqak7/g4tscvMgcRshWx+bduq0fwgToTYnMBOGuj0NuwaIRL8JnuCb7E54BO9oGhu4BzG9jzkV0qAtm5tLqOHQIvLaHOCDhDwBmbQWOO5CJDkgqAuGt5Vr8nB4OQ+Ja1SUnlGJBqZvn1sLJ3Tzqj3l0jDqis3Qu+/OFEnwCzf9KMxmAlt9xXZE92L5YE5qvjfQwgoKtC2/TNaAM6Ok6LP4LgTMWibSHenWr+hzNktkLDj7lLktjA01j+XQV6xeurpvpQFYQ1uUiczxINteQo4rgMpfXjXJnoAuW11rWCAwh6TG89WSHs5qK4B+VA6tgPcecqQERN91FUoRtVdQYcNIvtR8l7vU4RP3P1quMYtFeA3Nhz2loMf/dKdOmOFmqxyI0AOzXJvIWnw64SO2Vk5QJW5bLoCC86ymL5CnSiva8W6YvfKQz1jT7riKrI2UuWBrPWK8jATe45IPSgjm5hjrp0TTeEfMRjwGqbQS4cIWHljRdXOGq3ZIeKuLfiseLwrH936F9vTG6wps/GfVtM8MdN/GMiDGCzNy10b2
 4jYnIxld
 BTI1wCLb4hHDpGc4xaDm3FFhrMv0JHu0+q0TrKzL+n8gVNL+/eJGdF+I+W0V1e37RFHzBlndPAahvMjmIg6GXnMQj6XxYpV0vM48LU82bw6QyR5GxEcTjizWSXvlejWpcLQifM9uZ8jSr4VB1ruDXEiJg6p47Mtl4lzWIHliltcCKWh8sGG7una046hz6RIqVTzGnpHTVk9++dkJAxxUekp4MiDUWB4fYC9jhUh+2cpQeWoLW1LpILElJEYElNUbsfHbqgiup9HPBWulX8jb1veum4M3Io7vLGng1GT8CmYd5tylvGCsI2YWIys5UnSr9FlTGlqsPXFoHqaR0hQ8v+mlJv+K3EtZGYHRAEPCPg4Ah084snor8lYPIBng66i1fe/EzYsmKOUp2TgDoJZfYHiVKIDV8qSPjLykFV6BnN0QU0leiud0JeqQlGXnc8cTIdinDAv18n+7A51Y9Q10YqDRCV6VNPmap9Ur3bekk0rUfonI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 10:53, Thorsten Leemhuis wrote:
> On 28.08.25 10:01, Vlastimil Babka wrote:
>> On 8/28/25 09:43, Thorsten Leemhuis wrote:
>>> On 27.08.25 10:26, Vlastimil Babka wrote:
>>>> Specifying a non-zero value for a new struct kmem_cache_args field
>>>> sheaf_capacity will setup a caching layer of percpu arrays called
>>>> sheaves of given capacity for the created cache.
>>>>
>>>> Allocations from the cache will allocate via the percpu sheaves (main or
>>>> spare) as long as they have no NUMA node preference. Frees will also
>>>> put the object back into one of the sheaves.
>>>> [...]
>>>
>>> This patch showed up in linux-next today and from a *quick* glance at
>>> things I suspect it might be the reason why my daily next rpm builds for
>>> Fedora failed today like this:
>> 
>> Hi, thanks for the report.
>>> ""
>>> In file included from ./include/linux/spinlock.h:63,
>>>                  from ./include/linux/mmzone.h:8,
>>>                  from ./include/linux/gfp.h:7,
>>>                  from ./include/linux/mm.h:7,
>>>                  from mm/slub.c:13:
>>> mm/slub.c: In function ‘__pcs_replace_empty_main’:
>>> mm/slub.c:4727:64: error: ‘local_trylock_t’ {aka ‘__seg_gs struct spinlock’} has no member named ‘llock’; did you mean ‘lock’?
>>>  4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
>>>       |                                                                ^~~~~
>>> ./include/linux/lockdep.h:392:61: note: in definition of macro ‘lockdep_assert_held’
>>>   392 | #define lockdep_assert_held(l)                  do { (void)(l); } while (0)
>>>       |                                                             ^
>>> [...]
>>> mm/slub.c:5653:29: note: in expansion of macro ‘this_cpu_ptr’
>>>  5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
>>>       |                             ^~~~~~~~~~~~
>>> make[3]: *** [scripts/Makefile.build:287: mm/slub.o] Error 1
>>> make[2]: *** [scripts/Makefile.build:556: mm] Error 2
>>> make[2]: *** Waiting for unfinished jobs....
>>> make[1]: *** [/builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250828/linux-6.17.0-0.0.next.20250828.432.vanilla.fc44.x86_64/Makefile:2017: .] Error 2
>>> make: *** [Makefile:256: __sub-make] Error 2
>>> ""
>>>
>>> Full log: https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-rawhide-x86_64/09498568-next-next-all/builder-live.log.gz
>> 
>> Oh so I assume the .config here has both LOCKDEP and PREEMPT_RT?
> 
> PREEMPT_RT yes, LOCKDEP no.

Ah right the compiler evaluates that assert param even if not enabled.
> The config the failed build actually used is generated on the buildsys,
> but it should be identical to the one I attached here when you process
> it with olddefconfig.
> 
>> I tried to make lockdep_assert_held() with trylock but forgot about the RT
>> difference. The solution is Alexei's patch
>> 
>> https://lore.kernel.org/all/20250718021646.73353-2-
>> alexei.starovoitov@gmail.com/
> 
> Hmmm, that one didn't do the trick for me.

Yeah it won't help alone, the lockdep_assert_held() calls in this patch will
also need to remove the ".llock" part. But if we did that without Alexei's
patch, it would fix RT but break !RT.



