Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7CFCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 18:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E8B6B0005; Mon, 25 May 2026 14:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818416B0088; Mon, 25 May 2026 14:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E02F6B008A; Mon, 25 May 2026 14:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57DC56B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:33:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF5A8140185
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:33:19 +0000 (UTC)
X-FDA: 84806789718.07.4192256
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29274140009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:33:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRCcHEdc;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779733998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uuxz6XiEPlrlI9c6Z+z5A3E39OfNrZDc6vCJ0X/IkI8=;
	b=GnZNf5doSb9Fv7r/y7MJir18sqD0ymX/gAp+TwlAdfYh+K1uaGPUZW/fK4na9ea3yuNkOB
	S2lvaR6APcUQ8cvGRT2hn+IDFUmyzFhDS6u/SnaiIJFj7JMbNCBvaOpQ6Q+tQh0g8ozdns
	49oNNeZPSU88iC8lrzOo1PPXsiMcpI0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRCcHEdc;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779733998; a=rsa-sha256;
	cv=none;
	b=0QMlhC7S3krwCubwy2UP2Ijs2YMlGeDW9WYVvpbrcpTFrnihFo0RhPfxU7mnGU13G/0PzU
	F5UCRRZgYNq8jxsTyYFodEB2V7I9E5mExYdo7QcdKKRnL2UB6fw7p6FL+1q8BD5rffuq0C
	Wo52kQSNutot75nbywSPUIq3A4u7+XI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A89E260008;
	Mon, 25 May 2026 18:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE781F000E9;
	Mon, 25 May 2026 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779733997;
	bh=Uuxz6XiEPlrlI9c6Z+z5A3E39OfNrZDc6vCJ0X/IkI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FRCcHEdcW9LzZJmGu+k1WyW+wkxPatbzICAuxS44eHG73hsVM1TBKhb/SiI742nYB
	 SJyj+ceaspIq8f/l2ESaeuqzJnri3kP/nPvNsjfSY3WmnDbGYP82gOTMOrvwELEX11
	 894d0Nf8qQyuLMa3Fs8gMp/XzNvoIOrEHbDW7JR9iJbOZ9WaZpoY583BVEgmLspn5t
	 owzlpjEmv3Ghn270xxhZRraV7r9Tr2i98ACE/OFDBzqbSBhXry87QjTyCwYxTZtbBI
	 g7NCNtZkTQO2HmMqw/kVsvY1V/YVMy5kol9sA6jOBLZFXvCET4UwhUWpWODq0vw7YK
	 wjde+V0nc+rGg==
Message-ID: <9787578f-91ee-4f37-b13c-26c447db8f5e@kernel.org>
Date: Mon, 25 May 2026 20:33:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] MAINTAINERS: add slab-related scripts and tools to
 SLAB ALLOCATOR
Content-Language: en-US
To: SeongJae Park <sj@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260525180940.10383-1-sj@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260525180940.10383-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29274140009
X-Stat-Signature: j517764gt3771he6qw9edy1pddgshou8
X-HE-Tag: 1779733998-703677
X-HE-Meta: U2FsdGVkX19gssx6pC24Z2h0I1V6xbhBCZDGtrUYVgv1Oq4QV89+MSStaagemwIS0grkzLP7n9kA/mAV+AUczSmpvwFkyzF0dPgtBj0KzbkxwZuKum0hVH2BJAzB3N83a2qXfEnhrg73tpWQJY6U8Calqq7C2GkER8om+yWxiw11j7Q8WjNsrLzIK/UhUANXkmHxCiBbXK8lEfA0D8RhYSpvS4sKwZwBhefP8MZ8PU7CPGtZBn7XPNSlxRfZeAtDGfQwEZSSOrgXh05ghyKk69MTwtyyM7WzY/ms7yO+ssrGNsPuvMVcqwa9T6/Sq5oS45eBphz7OifgPztNdcHQj5gI8YfsE9r/Cg3zrkTJ3DaRcY2832k0aPh2eVTS+LTBYXylLStmQZOZTxxGcl+qK527OO87mz1Bboq42Z7y9qRkAiJi1VWXyqUhZsd1jwbP73b+V0ayMtCgStszOTO4foK9PsshZSOdlb5TIw5sqDYv/wncMa4/bkNRk7ODSQ70OsHL4TG1676ZnvzY0sQW5s1dwEdCZq3hR7WX+FMHPko8ZQn100CWtEhsepVLDblOLj3Q7lLAszYRFEKedVj/E6KztviTeBKl/aw48ZBy6Q45TuP2X8sZRKdCJ7qByKjvqycuJhULeFmB1z4OeSqzwY9T5tAW9QN2MshKIcyxAxtv22LRGaGK38mRaKy5vJ6wbCFJGq5jKyfMKuNUpGirDn38qmZZ1cVxpKbwCYNivL28dGjMsuUW4TyV3sulfg/jyShFbbPw674M+qevHw2RzZZLuFaq6/BD38pC2VQBFYiyj1klVcm6Dyq9mpPrn8KhK+TEkZzDN/0h+xZ4rfqQT+g9CLdwjm1sFdw8kKpsHEH6FNJDR/qorR0Q1xO9vzT/OljTLPW+dygCeeKrY2k1vUQL1cKOtFjIfF1e0p8/61++mgoScWAjtwtcoPSNH2q63FLA8MjFwQdILXzQncP
 ix6xaAfu
 Lm3Z7hmmrHdkD+Vryk/rhq6FS+tuXqJWalugEhwFHRfRN0O3zeniueXeLhSZLHtxltIavduB53vqjP40vBxWRYbsEKf2hE0sMOP3t4UB+eZHMtzRMC6QQQCrou99EUucqvNw67cn0TMV5RxOo/S08KirCx7xwYv6isERF1jJnIp5HDw/PdP0512mFYVyN8oiuti24+7hWoLNnZHGaXb2Tdku45aU7wIjNtpmsQLReyOvB1F30R1tLaqQdEJvRAF5+05IpSZuuWThVFBuRdr5XqVArPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 20:09, SeongJae Park wrote:
> On Mon, 25 May 2026 09:26:39 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>> Make sure the maintainers and reviewers are CC'd on changes to the
>> scripts and tools that depend on slab internals.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> 
>> ---
>>  MAINTAINERS | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 288866c32ade..9ee06cd35793 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -24555,6 +24555,12 @@ F:	mm/mempool.c
>>  F:	mm/slab.h
>>  F:	mm/slab_common.c
>>  F:	mm/slub.c
>> +F:	scripts/gdb/linux/slab.py
>> +F:	tools/cgroup/memcg_slabinfo.py
>> +F:	tools/include/linux/slab.h
>> +F:	tools/lib/slab.c
>> +F:	tools/mm/slabinfo-gnuplot.sh
>> +F:	tools/mm/slabinfo.c
>>  
> 
> I found there is rust/helpers/slab.c file and it is not in this section.  Is it
> intentional?  I found commits for the file doesn't have Vlastimil's R-b or A-b
> tags, so it might be intentional for rust code, but I'm just curious if that's
> correct.

Yeah, thanks. AFAIK these are just thin wrappers to overcome some bindgen
details? I think whatever the rust side finds necessary to do there, they
can and it's under RUST section, while the tools had no maintainer at all.
So we don't need to cross-maintain that.

