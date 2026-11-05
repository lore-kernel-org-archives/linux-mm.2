Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED38606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uf3p/qK8
Received: by kanga.kvack.org (Postfix)
	id BFADA6B05B4; Thu,  5 Nov 2026 09:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B842A6B05B5; Thu,  5 Nov 2026 09:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24BB6B05B6; Thu,  5 Nov 2026 09:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80AE16B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1873840A56
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:36:33 +0000 (UTC)
X-FDA: 85401316266.09.7DE5005
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E42180003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:36:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uf3p/qK8";
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793889391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNaqt/zIb1JcNg4K9VF2Y1BZCn/3lY00rDpw9JPXaO4=;
	b=NphxVhomTSFtusNrR8LjcX8+j8JwJo4tttG3ETSFhnlFhPy2b7FAl5va+MG2LYirwNWI/l
	XKKsxCz8OQM9Nm/LJzosfO0uZdtoUl9+FI+B+NKK40Sl/2BorY0E4/BCZEpMRQNNgAx1Te
	UqM6RhEalTX5ITr2SGlr5X1rUgFE6TQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uf3p/qK8";
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793889391;
	b=k/rTCPJf1T2JUQP7H2g99MeOMW3qZEw5yuuhl4S/qkYosfmAgvmdOgKom9Zt8p/vwYR9RV
	lIow4wtrIrcSaIdaC3av+zO5GEfUtdb2OeTerHRzamMvmBJObcJoxMjjn+btDF2WqhKoII
	TE/efIH3EfiiV1FtqY70E8wsddNwzbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6508243F13;
	Thu,  5 Nov 2026 14:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552531F00A02;
	Thu,  5 Nov 2026 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793889390;
	bh=WNaqt/zIb1JcNg4K9VF2Y1BZCn/3lY00rDpw9JPXaO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Uf3p/qK8HfA39sBKpscrP9nuzc7KDsHZ2Vx8Y9W96aHVWtCxznsy40xG0npgM9465
	 5zwUW0irw1IHHwMfWjgQTbTMZcKc6P6628L0oLGw+0keqR0HR52xr0xgmGePiiJECZ
	 NwHotTeojiTcb3NGGIa2fHVQZXsnCR88mG5sxv2zZLh9D2b8ZfFqUaU+ZHJb/9pXCN
	 5NKgc/goLiGEmoilpEqvIGFiFwenpnRpLZ/LdGvzQu0msxmMz2RUAYwxhdI6TWb39x
	 KDDm58Kbn3YpOFvGPgIeGwvGXOrmATQf3G8oifQdLXSdW1OjmULR3C+QhV+3Fm+bkY
	 pGcQ56QvG3v2w==
Message-ID: <7ac409a1-fe3e-4b37-8130-4d49ecb6106a@kernel.org>
Date: Thu, 5 Nov 2026 15:36:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] mm, slab: introduce slab_debug=N
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
 <auyFYsbsMm8qGThW@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <auyFYsbsMm8qGThW@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r5g5gjpjgaeyz8tmjia9s9wnk93w8goy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2E42180003
X-HE-Tag: 1793889391-694244
X-HE-Meta: U2FsdGVkX18L6afMrPpTcqyfHJJl2SPJGcsiZnvexj2G6mUAfsw15Uof5acaLYqkvmIL7KxEgxrOAVM32c2iYTrJn4NbtoADa5AibP0X6JXcjvfM4zgmgJJbJeR3jiGvaZDtrhv/Hx1PVkH/jCwJiDuEnFP1+/bkoNMhcvT3isWRUK+rmvONG6qbtJtp0WD8kkZutqCaLemzugmcdhy3VSja44A0CR1s8OYZR9sMQ3ZFlYMIbwoa8AtT0/UXJy6LWFhWhGvwW+VsSSXObc/AT3MYQ5fFlVaBozyqsuw19pumYN5WOxvbqdieHkwaS6OU8mWWmkXXpqyEkx/IkOz/2LMtBA3KGG7ujDPzPrPhN4D6eTs/6+IeLsPWeYAnF/BoVZPrmxRUBsUbaJrA2vt94MyhShnfkCAGQ5CxXhzv4RgDtbmQ5YLE1E/2JoJ3BaKWhZ29/sKP0/HZbuGtGlDJIZSwXhE7ag8I5uggd8jfiA45GgSDdXsYAzp3qfsl8iqDgcElM1J7mc092DHtTUbi/XIvm6ZnYcA18fHpFN2pO2aHkSKUh9R3FCak0J4VTfFQBNcqhEDfVt5ACZbtPDvyVKeSLbynsGc5K7Zh4G3vQ5kUXaPlo6fkYkTh39sFKc2a1GC4A5/1XjKyXeQFTukPO7Bu47HaJxrnWMny4x5sIfUdCvMkWMXRbVjIvo6v6wvwC7p5r//sYREgqYdQSTyOV152C3Vmukuop61w6N56H6DCz37VII98kKzrTBtGV9x+8i/TpAssxUelW1xp8p3xLH/DPGzftCQeFFltJRsgpKVrbDI/JVLlHz524O8UZn5L1kVPgscsyK9+uR/YH5O1yFz9+VCtuLa97sMQWrlRg+Gzq9olgPgu+KyykyW63AyLiOdrDF7HXEiUi0bm42vXYT04dD8KG5YPIC/YtOlAMIRvuOo9nZdNerVc1DEyraSn/TRFNw7b4MAp+fHg5dQ
 ziYPvZrg
 /iE9ENId3sH6z7kBYFbTakiYM7Nd2uMGqEX0x31gZOuyuayP3eefes/Rjm3Tp7ZxAbQi8X44gs4KtZz/4AKcWafH0B1v2qYo5f/RdUv1aLUdJb6IHn80JU4ear5PcmuNdNnu2cChkIi5hTKZtTx+zBzFQ/ta58glBuPfOFgvQhOeG2ANPYzO1mFjOn86UmYbRijOjzhFIVBQBH7ljphDdRFwZft/zncFLNr/6uBKB7UbQwCUwz04pQfpSfzDaWfHhdPKvYyBjtgk+XcwzLPWMQfob98MbKgAzXVV2xgQ46wopwwZt0avTBDh9cRgtfE1WDjVTGP25pVtLMggE3OITluw4WX5djz6aiXdyCYVDnl7yivUeHbL2c1dAbUMNF10Hdj03X//QiC6GaH4LNIU7qvuyAdsFF0BN6urrMidnKCOt/4NM+mDmYV8DRzmMII/LjacJ03DYiBZHKnVMVeB781jhhx8RfqNshbZ0ewQTJlNl0l2rZfl4vQfuxlHFUeJEeD+3DvPmkV/wYoQSDLbptu0tuKzWkZiKrHoyyA8C2xiZZJ8A+C/1EJbG1w3nAWHzFp+c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 15:30, Harry Yoo wrote:
> On Thu, Nov 05, 2026 at 09:43:53AM +0100, Vlastimil Babka (SUSE) wrote:
>> Enabling slab_debug has the side-effect of disabling all percpu caching
>> of objects (now via sheaves), which can be sometimes useful for saving
>> memory for e.g. kdump kernels. To make this possible without the
>> overhead (CPU or memory) of actual debugging options such as poisoning,
>> introduce a No-op debug option that only forces the debugging slow paths
>> and zero sheaf capacity. The new corresponding slab flag is
>> SLAB_DEBUG_NOOP.
>> 
>> This will also allow reimplementing CONFIG_SLUB_TINY as a boot-time
>> option.
>> 
>> Two details have to be considered, as suggested by Harry Yoo [1].
>> 
>> - While SLAB_DEBUG_NOOP is part of SLAB_DEBUG_FLAGS, it should not
>>   prevent cache merging as it doesn't affect object metadata, and lack
>>   of merging would go against the memory footprint reduction. Thus
>>   exclude the flag from SLAB_NEVER_MERGE.
>> 
>>   - However add the flag to SLAB_MERGE_SAME, per sashiko.
>> 
>> - SLAB_DEBUG_NOOP alone should not request disabling printk pointer
>>   hashing. Thus rework the call to hash_pointers_finalize() to not rely
>>   on the slub_debug static key state. Instead determine whether the
>>   global or per-cache slab_debug options include any flags that are not
>>   SLAB_DEBUG_NOOP. This does not change the fact that caches created
>>   with explicit debug flags (i.e. slub_kunit tests) later in boot have
>>   no effect on pointer hashing, which is determined in
>>   kmem_cache_init().
>> 
>> While documenting the new N option, remove obsolete SLAB references from
>> the F option description.
>> 
>> [1] https://lore.kernel.org/all/arUx56ee_nkxYP_f@thinkstation/
>> [2] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=2
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> With the sashiko report to this patch fixed, this looks good to me.
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> 
> One nit comment:
> 
> specifying SLAB_DEBUG_FLAGS depends on CONFIG_SLUB_DEBUG, and with this
> patchset there is no way to minimize slab memory usage w/o SLUB_DEBUG.

Maybe not at this point, but unless I made some mistake, later slab_tiny=1
stops depending on SLUB_DEBUG. slab_debug=N itself does depend on it but I
think that's acceptable

> Sounds like it's time to make SLUB_DEBUG unconditional. It's enabled on
> all distros listed in kconfigs [1].

Yes it's my plan to do that next, I did even discuss it with Christoph at LPC :)

> I built kernels w/o SLUB_DEBUG and the difference in the kernel
> binary was about 40 KiB.
> 
> [1] https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLUB_DEBUG
> 


