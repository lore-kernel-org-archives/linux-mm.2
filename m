Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F78105F7A8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E986B008C; Fri, 13 Mar 2026 09:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC6F6B0092; Fri, 13 Mar 2026 09:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE8A6B0093; Fri, 13 Mar 2026 09:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29D286B008C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:49:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E179DB3FB5
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:49:48 +0000 (UTC)
X-FDA: 84541172856.13.5B0703D
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D9384000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:49:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773409787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thXjloBmguuNA1pMHHFc2Xj65b+Mqqy05OB2wAB6eh0=;
	b=GuUY8CnFasoYvjtF3KmXbjPna1R6sdrTJ8XMJVAk6IX+LEV8uBqxtWr2yykjYwhAIlCYU7
	I7n49jS56MCNBFPXwsVsnK3xG/z9vwSmHrIx8mLosMbjiA4s7jM1oTAX7ToMkD3wsCYN7n
	0djdkxJkZDN9iOZ3H//c+tUvbDjjT70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773409787; a=rsa-sha256;
	cv=none;
	b=3WQ5M83MLTD4L2Sap28hC097yOFQjvKvikrpMvdXEja+ADHcM9Tyl+kFuojrZN4KPkkDL9
	vjyf+uoUHKoWHepsZ/3MGDXtdEz6e/2cWLEj4Dca9htqJxUHQjuA9nxVRoC7fTJek/Difx
	M7fcQB1/kfxx4jaDYCJJTKX//+86E80=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 906A93E97C;
	Fri, 13 Mar 2026 13:49:40 +0000 (UTC)
Message-ID: <3020ec8a-5ff9-4816-ad3c-f81dd4513e1a@ghiti.fr>
Date: Fri, 13 Mar 2026 14:49:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after
 setting GFP_TRANSHUGE
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, alexghiti@kernel.org, kernel-team@meta.com,
 akinobu.mita@gmail.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bing Jiao <bingjiao@google.com>,
 stable@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-4-alex@ghiti.fr> <abGsagHIieEobFbB@cmpxchg.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <abGsagHIieEobFbB@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeelkedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpefhhfdutdevgeelgeegfeeltdduhfduledvteduhfegffffiefggfektefhjedujeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedufeekrdduleelrdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepudefkedrudelledriedrvdefkedphhgvlhhopegluddtrddugedurdeitddrkedtngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhqihgupeeltdeiteelfefgleejvedpmhhouggvpehsmhhtphhouhhtpdhnsggprhgtphhtthhopedvledprhgtphhtthhopehhrghnnhgvshestghmphigtghhghdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvgigghhhihhtiheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmp
 dhrtghpt
 hhtoheprghkihhnohgsuhhmihhtrgesghhmrghilhdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrgh
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0D9384000E
X-Stat-Signature: 8pk1opyoazib3ds9p675ypmiotptea69
X-Rspam-User: 
X-HE-Tag: 1773409786-158604
X-HE-Meta: U2FsdGVkX18APmrSQJImlTRVBqDUTIrHvFxsC4edU7EwFxLXr8ukxxoAiRY92q8wygawt54YBwoRpMi7MpuG3M9+0Mi0zzc17OHOOgks0kOxJk+dq8B8cpzOhggXquSNm3Lbck6Rl3iGe41G1+ZdtSopD37QtIWHw8KboHeWG2U1jtVmJWyBb5kPKc9HlkB6m7vqEfkwJ4SgqeXDvyJrq/Az7ojULMVfG1w+Q/Q3mzBG0UGxLSlcn1zs6CrTLLN8N9BBszK3Nuj7C17clyHDcYD/IDaTeJ66iuNcOsrEdSJKG6FID2PUFK6PHHC3LemhG6M1/dPqA42tQBye0vUa9PwmJmBe/77Cyqdz60VLgYLtfkSGTF02K2RSVUValJR2CErNT75uewjHLumrquBWUmeUsUpQQodmiuT8E13cdEYx24eUE5JR9kKo/vqJyYKwo682RnRzfeG5Kqw7Yu5WJqAFP305ih9gghPLvkyZ7pqa/muTCO5l69svwNd+UzTfaFTOTr+DN7sf6xlb6DBuXLyVhh7VFuLy6eqn2v11SRTJgql2ENAWP+yEF+ffP6tPIm1HDUfK2QX6VZStS0hwalzv/0HfKZxm2vmZI17jL/nJKQQrS9x2fBYCYa88Uk/eW/Quvy8Fba3bd7AXcfbZblBMBg6N1VRbblPbXwkO3/r/23LLR6E5dYtEmowOVqpdBa9xyyl41sFnZv9En0/iJkeZK7xbAsbSbxFiqXe1Qx+ZGX5WtGwWDxvdvFm4sBWalhoBr8Neo+67fWVlBmVin+II7MfbUr6RWdgNWCnoEFtpHYBXH/98NDS+mM1heZZ7bWm7v5kFh04UExW93NZPAFCSeexEnUInjAEaWJrTFxOwvMDAihBT8ev/4m84831r6LZtp73JRK1qItUio69MFWm5r0OVOE8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On 3/11/26 18:54, Johannes Weiner wrote:
> On Wed, Mar 11, 2026 at 12:02:42PM +0100, Alexandre Ghiti wrote:
>> GFP_TRANSHUGE sets __GFP_DIRECT_RECLAIM so we must clear GFP_RECLAIM
>> after, not before.
>>
>> Reported-by: Bing Jiao <bingjiao@google.com>
>> Closes: https://lore.kernel.org/linux-mm/aXlKOxGGI9zne8sl@google.com/
>> Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>   mm/migrate.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 2c3d489ecf51..ee533a4d38db 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -2190,12 +2190,12 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
>>   	}
>>   
>>   	if (folio_test_large(src)) {
>> +		gfp_mask |= GFP_TRANSHUGE;
>>   		/*
>>   		 * clear __GFP_RECLAIM to make the migration callback
>>   		 * consistent with regular THP allocations.
>>   		 */
>>   		gfp_mask &= ~__GFP_RECLAIM;
>> -		gfp_mask |= GFP_TRANSHUGE;
> I don't think this is right.
>
> The Fixes: did it this way to disable kswapd for THP allocations,
> while still allowing the customary direct reclaim. Maybe a better
> comment would have been: /* GFP_TRANSHUGE has its own reclaim policy */
>
> After your fix, direct reclaim isn't allowed either, which makes the
> request unnecessarily wimpy.
>
> The Closes: refers to reclaim that should be avoided during demotion.
> But if this path is taken during demotion it will already not recurse
> into direct reclaim due to PF_MEMALLOC.
>
> So I don't see a bug in the existing code. But maybe the comment could
> be clearer.


Makes sense, I had not understood the comment indeed. I'll drop this fix 
in the next version then.

Thanks,

Alex


