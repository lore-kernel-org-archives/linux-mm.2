Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65736CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 01:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E2E6B0005; Wed, 20 May 2026 21:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707046B0088; Wed, 20 May 2026 21:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0AE6B008A; Wed, 20 May 2026 21:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 478C96B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:43:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D60D6A04BD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:43:17 +0000 (UTC)
X-FDA: 84789729234.11.DBE361E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28B4DC0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:43:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUoRj7Xx;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779327796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjSMEOl6HoJhfnGhlg9lwlgKo2mAJunoCTjT72+1vmE=;
	b=ktqK0jaC/3GMLeXhdqGxbjon25HuaBLpZzqaU0JzKazoGUpMxfDjcHKOkrKncgAZvRKBs2
	ZmQmVVOWUfU/nK/Rv0NywcTDyw1Xi/4cy52rQyDQG2FRWXJ+FiT56WjSGjH5qDdcMJ23hs
	Hv0CiCxTBYdjZEvgN63Lf0hH3UNDcBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779327796; a=rsa-sha256;
	cv=none;
	b=oRR50m1kWL4tCyyhq1Ulvr9/+dhMNncovlBSuBh9Z237jlByscTJKY5Nvd+tE86A4psCWM
	/TN1xaNwzKv5CUWkw51fO1k5jWAGzWcE/zhgRu9y8pWi7ftaqQ52FirSzKCWP/vwYXCr8x
	WEuyE+9fm9NlxWDHGgy9hWFkFnxnBAg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUoRj7Xx;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DF5A60098;
	Thu, 21 May 2026 01:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B589E1F000E9;
	Thu, 21 May 2026 01:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779327795;
	bh=TjSMEOl6HoJhfnGhlg9lwlgKo2mAJunoCTjT72+1vmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hUoRj7Xx7zxiV+y2G/ilfDYIoH03YyCV33rF5ZScmU4APkemG0NbVIlfShmstGYt6
	 f0GlCYPAR8fEcrG6sdt7CoPyyEM/eE9tW58ruj7OMa6SzbSXowgHgF4RFAnenu+VOq
	 8w/ByKROGz2z2bg2xsS5O/8UorPYoh3ahCu29UKzbQ6hcRKyJXgZdGSsO2QaiJa1NL
	 REFS4+E4XIIWs20Am3SV+m/fPATBFrERJqYmxwwRHASUGUVaIrzzIurw0iCj1cer2x
	 05aBKdCSdnrUwVRT12R9PSEal3c//gBn8AiJ9oJzRosvwhVIpbK3bctDGWLJIrBRoG
	 x8HDoFG0Rbmdw==
Message-ID: <5b09f618-3b84-4163-84f9-f3adc0f1cc97@kernel.org>
Date: Thu, 21 May 2026 10:43:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] memcg: multi objcg charge support
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-5-shakeel.butt@linux.dev>
 <4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org>
 <ag5Z9uIMoXpr3rLP@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ag5Z9uIMoXpr3rLP@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28B4DC0006
X-Rspam-User: 
X-Stat-Signature: 5ierbfrs195udd7xdtg4aczcsgx34pk9
X-HE-Tag: 1779327796-47895
X-HE-Meta: U2FsdGVkX19M0DZ7CRFTwlfYjkCqcobmLF0MnyFMpoAOxFDRMuntRXVuQSveGBeJzy+gxdSC15czw/P9cY3en9uU5ncp4ZhlW1lk/R+kdn2SU/oE7egNwvEwC056iywujIgKs/sFEOazmtkQlNd++gt4w4LAXyWLQoo2rocDI7GTUoLg9dZ+WWnuDg+9dcRmlHsbuc2XO8zVCLFGEx9g0A78ASR2E/bSSgARMG0ad92d61vJfWD0hpY+RQdjQIh8qxZqm/HnvRP/uT2dMETRKjbB0ZlL+WG9P7f8/2VHUiep9/WmaGOERHFWmv3WjBTpkxRC1BT+p5i029w87XBeK8N37EmAY9CQrmXmdU/tl87Qb+ALrWVZBuFsq/L69c6GpW8P/r3Esl42XLu15x2O423hQFGKDsPm3PzYjQxWxpTRsUjchluMAzhFxi5CiXmRwR1P1B/72vfhJlfgrqcLPoI9NAKLwLkAmZSsLJgndNEp73hJBcUkFXaVe4LsMFCtHGUhKf5OIB5aOI1/sAGrEb7uf5yqgZoaz5yJgVU2vd4Ix3JT6W1BwJYtZOsD5w+MgntSjpuXGkg2a9TTCPzoMDf2rpLo90a4hRNK2BG1tThAkPnMRvPhNHF9yZ3/3PDadTUq09PEnKqRLjiy6fYiOhXDJwWFcFIvFZDZZvLcj9pO6s7ExIOTW4bIC1yptHlL1l9KRBg88qIOjxOLRzWOSqtgiWau8eZKw+IL8XYrli6B5AEsIIiiuU16++SIkV7SYQWKi69pTytrUlj2hkGw4UjuNJ6A1kPcJN2dJiK7V1a03Ya95ScDBIF+YottgKPyFxsY3wwfdugjlUuqiJ0gkNsE/ZRyxFKHUY/nmcDUYI0XUxeaRG9I50EDYDmaxps1BALp/w33S/LI582ECrUPiZ6phSM4U7nFSp+iDErgsqCow16mkRde9pK7b7ufjc0XFqdMfG+UAnWUitQTg1g
 yjRYh7iv
 a5ZlaV+iBintwcM6aFz8aK9Uvutb+jgh7Z6o7MUnh2ObxrcqCGfTzXvcFmxtkYXjrPiN5UExDij0UxElA25/9oHgpDwB5H5oEHfA7Qz9ZLcBSg7qJ9jxnDMq9b9k4FXxzBYyjMiYWadEub1FakMpCZrqxttIYTSgFyR+520Jk6cwOgxh1xLua9Iy2vSbPorK/enV+kDunVayjDvOey4kyov9Nc5qjh77QTOrFRoE9ceHUeW8/F8Hc0RS6hY/STqujetGJgeNt2IryOMVP0dJow6G5OdJoUzi4Rg0jMnVl2p18p8kDP7/OEsJZErRkDtwCBNihzCkuJJiMtuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/21/26 10:05 AM, Shakeel Butt wrote:
> On Wed, May 20, 2026 at 06:35:30PM +0900, Harry Yoo wrote:
>>> @@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>>>    		goto out;
>>>    	}
>>> -	stock_nr_bytes = stock->nr_bytes;
>>> -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
>>> -		drain_obj_stock(stock);
>>> +	for (i = 0; i < NR_OBJ_STOCK; ++i) {
>>> +		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
>>> +
>>> +		if (!cached) {
>>> +			if (empty_slot == -1)
>>> +				empty_slot = i;
>>> +			continue;
>>> +		}
>>> +		if (cached == objcg) {
>>> +			slot = i;
>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	if (slot == -1) {
>>> +		slot = empty_slot;
>>> +		if (slot == -1) {
>>> +			slot = get_random_u32_below(NR_OBJ_STOCK);
>>
>> It would break kmalloc_nolock() because _get_random_bytes() uses a spinlock.
>> perhaps prandom_u32_state() should be sufficient in this case.

s/spinlock/local_lock/

>> Is there a reason why it uses random eviction, unlike multi-memcg percpu
>> charge cache?
> 
> Oh I didn't know and actually we are already using get_random_u32_below() in
> refill_stock(). So, it need fixing as well. That would be a separate patch.

Ouch, I see.
> I will explore prandom_u32_state().

Thanks!

FYI, SLUB had a similar issue that was recently fixed:
commit a1e244a9f1778 ("mm/slab: use prandom if !allow_spin").

It uses prandom if spinning is not allowed when shuffling slab freelist.

-- 
Cheers,
Harry / Hyeonggon


