Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7464EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384C96B0093; Thu,  9 Jul 2026 04:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BD96B0096; Thu,  9 Jul 2026 04:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278286B0093; Thu,  9 Jul 2026 04:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E83336B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:25:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FC5E1A0431
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:25:47 +0000 (UTC)
X-FDA: 84968554734.30.D055B21
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A4E1180003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:25:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MrnApL8O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783585545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZYBoXNfxRtgISWI6nwLbyRJgOnKdbrwsBmGvBXyyQo=;
	b=C+AMslp5aV2Y3MK3ceUOs9duTIr4dPQFuwXVjVf2XutQgWsgmHrbOTFVp6LWqSBxdVzJIq
	9aEWxhfhSsFH5YAlZNPX4zYulg8CmQ3rBnOerHm1m1JwVeSMOB3oCsGpE+f6FRJB7EqgUg
	uTea8afGf8X1+0uUOYmaRFaHt499lhs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MrnApL8O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783585545;
	b=RfSNzIbSqsUxEBjuVRG1cX+JCHGTvP16eHSHZ4ZAkS23qFCIze1fwI7cy4egQEzT26wylr
	nEDcgr53XKekvYBJdw3Cb6OH8x/VHmvI1dPdMcf8KC9HLi3Yix+AM6O2TH1+9Z90wYD9ml
	4ZnYVB3cBg+mEDOgzkSVqw1anfgg4jA=
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-381a094c43fso1066201a91.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783585544; x=1784190344; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fZYBoXNfxRtgISWI6nwLbyRJgOnKdbrwsBmGvBXyyQo=;
        b=MrnApL8OwDnyNEbTqOT6AvVrCc8ydmo+33uFVUyyPxkV5WMnki3+7/JJuPUg6fZ5iD
         nW81Y9UpEuJMutZ0bCLCn/J0OV7v9dtvRaBP68tnMRTqnZgoFA5D8fEiB2RkbjJKqniC
         ipNR8U6EzH05viAWCHJqQNaeiIchGMOG9I02iLwkeJ8x0QAZg+qb/rdzQ5Wh8chuEfLz
         RqH73XfFHJ5YWSB21lyTj44wN/FUEuTI2TxK4zzqYuzPqemfNGYblRBTX2emeu/SMpIT
         M/BSzlOQNsLV3ZUuZXj1DbqcCuC0U3sjg6bsKl9PxkcENI8oTWMn1Rm2m/666vBt6pzR
         2DkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783585544; x=1784190344;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fZYBoXNfxRtgISWI6nwLbyRJgOnKdbrwsBmGvBXyyQo=;
        b=qr+BmJNcgIbJriz7nnL9Bi0yT5WAXdgJTWke8TaOmoc0MH4FnizeygeYOyVAcNoSb7
         v+O11q5KnrOEPCfOegiXSMIqSp2fBs9TPMlspKAG0yI8rdqjmVFoM4vC0nbQx60v6C2S
         X1MBJ4qxsDgCMyrQNTdgp/ugjmgwut+ksDbOwE55LFl8zgmRQmxOIPgRKNYmOpITXp4W
         RijEqJLIl3bzCIC4Ta2AtKoAsDFpkRPrMjpRTrQlrztWENCglQvM+uVSUl97i9PKwCW7
         IR080S89MyMuLORfARd/jWZHWsfGQOp2Qy1U9orsFa8rrTSpHSRy7xucqeHHfONNUjZS
         hY6A==
X-Forwarded-Encrypted: i=1; AHgh+RohdlbyHqMbSJvh7nJvd1sEmwolK/41nbueg6miXa4hhIBT9S+r6TXTESN0d4/HYo2+hGfLhWi13A==@kvack.org
X-Gm-Message-State: AOJu0YwXxD8+lRVNAFXui1c9ptYkJyxidPtC98URcRnQalb1C2vgD+MB
	F5msPKAxNpm/ib1hflo8agUeeJTFZMCU2PWMi8wTW12G2kdL+sDM15DI
X-Gm-Gg: AfdE7ckFl800N45OwZdmdMwAvnn/q/sT435lnQCSHnzPjQ/a8Kspj2foHq2YSqQfLrx
	lEz0mWY1pRTWGjuKaIBVvSs6ZbRkXWFVkvijK62FU5ga6P8lb9g+4MrEDEw0M7T6tP43SQsSKLY
	L14L0a3XwpSI2KaL9r6G0sUeao7aN3WPKhItp+wUtrDZ8FfMn+cSuhSPbYWjnW/Sd9cvOl5Vvsc
	Sp2Nk22BZqfukIKHAQeKAPHTJEM+xBextFwWjBCq07hBHjtBfMjlTsU5IwUR93EWL7SIYzIhbbh
	IW2SDg5jgpLFuIpBRbGnr0MA2Lg+1Bk3WpHljZlLNp5rnuA/kHgrbORLK/2HVHRv1rCIwYLT0p+
	SV0RApUQUkDhgUF1Or4llKnuWcdECEr7I9wbU6DicsWcVHOmtV9Po7bfMyIJt0NOLCmVH1vipUv
	SND4rGenq7nrkUznDvVWrVNTDS0d3Qr9c=
X-Received: by 2002:a17:90b:3b45:b0:387:e0db:3d89 with SMTP id 98e67ed59e1d1-389434634f6mr6128019a91.36.1783585544240;
        Thu, 09 Jul 2026 01:25:44 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a5574c513sm786919a91.5.2026.07.09.01.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 01:25:42 -0700 (PDT)
Message-ID: <f33a9dca-03d6-45f8-bd25-717b9033c75c@gmail.com>
Date: Thu, 9 Jul 2026 16:25:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into
 VM_LOCKED VMAs under compaction
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-2-chenwandun1@gmail.com> <akz7ythMxfIZeT0d@lucifer>
 <ak0EsCeucJarlI7G@lucifer>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <ak0EsCeucJarlI7G@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e8kcy8uiigpe6cqmkpueohbh17cwox1x
X-Rspamd-Queue-Id: 6A4E1180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783585545-744037
X-HE-Meta: U2FsdGVkX18D5v/n7LekIlDBmPyRMZ4CGPgmad7ri9hzjkSDn36dleXKkPPyJcsNoEYhB6BpJznXnXB4v7qiTbGKpBYBtj/sXyHRRnis59r2g2k/UX193NsAjSJyVRmjhk4LcV7UmT2zy7cSYico5Exdko7B6QvOfOKzpP2do9B7A4WxtZ0sXwW3Fr6qZVgL8ubABy4jG7qedF3AS5l+NcLe2/4flw4ZYEPdoQKRebOaZIJ/bcXEtF82hUEF4DCL7qFrtGyk42YbHhpM561vF6sW/o/z8E01zThXnzHjxOQyaw4mYkgOK5WOxlUEdINkU210B8b3i+qEZ42hTgs8HckDoN3e7bkCFklzzgcIkp88uyXIGFSmBKgVrJqsy9hgc+FnmnIgrStTm4abzdH/xYMbNSGDAwanPrpURfvJ067Km6L8UcsVCDPAw+wXRuG0U/sZPpahcJBk3Cc24H7lMhVnxsKuSZIWHk8gGfoip7exFWLHo/jHryjiF8BOHhP1/Xmjhj4gsCEcB9Y24P9G4ZtCOYAl+C3LHMtzVJmfsbK6sDacy8VbgrY8Rn/tUSrFavADQm3GumTU81PGq4dS/NvD63v4DZwag60lTXDX1rKfN5+PocEOLcbhiq+apKBgwUrTds8UvpZfCuneuuSXlcAWnMCCs6WTsskbC/2NEDf+bP1X96CaKiD/p9wKUmYa1ICR/yDanQPd/JNkZ4hPI+A+DpeG91s5s3iRjkKWM1nzyoi6QXP8BbnCjGkXTj3F0HVC9flyuK8N7fUfVNCbZcII3yCJQauB6YwDS8P+rXYkKAsy/hiug3g3emisJoHOhUOuHlIvk545n+jjbH5d7nQpaceyYEUGZRLHWNYZrd9fLwM8+l5RbHUDqt/aih9lzhDg9jmsN9C70P1tGLen9wF8VUEyzGcvILQ+UBGbqQN6RGRtLBka9GcD6vsvW1kUV5NUkISTRlluQLklp15
 iZz5vQRl
 hu7TDNU5bj/wFMLi8AlyxlC2gg7axP/KcL5VmMkf5SnJXJL3ExQxkwj6kKtq0LFtNhZYpg4kibHLZMEv0t8Hui54vEOY0xa1VaPMa2TZpQYBgLkfy3HrmiuiVyCYMpTue/YI3BWBzvGW3SHQ6BPl3fD4NHX+dc2mlvisnb7/msB44ObSWzhvsBK77o/KnFTq54/MnK8nLrq0ob32gwt55hCPAJhS/D6uDEoV/qyrh8XRVqR7oO5yCecWA1e1pQkG8Ahi4OLZ5UmIkFjbZ+cFKreWWJYQ1kBPfN02DRPu477s2DGLopuFOA9UNC2Wtpetg9zwfzX6gBRhDYEFIfUPz/0gWVv2RCnu9m1/O0CCWc7eMLRky7vNsdeeJ+mtd+RmHKx2HiBqjcQpPDJAW4zpXnc3ta0W8f8liziP1acqTCpqZgXErLVd+Cn5kvakYDVYoRuNkQ5Wtrx+O5FOm5KsL0YK8qVQHEL6ZVrgfqy3037C/AXccbUAczBIyskTt4R6HY0NTULwdnu0pR7hNBFAGM4QvVTvQONSkXjB95P/a6ta/uZuf+2Hu2TI9AgQQxl1fQI8MmrD5Fu1VgldPo/MjZdhnREFkKN2M0tx3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 21:55, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 02:44:50PM +0100, Lorenzo Stoakes wrote:
>> See above about deduplicating.
>>
>>> +			ttu |= TTU_RESPECT_MLOCK;
>>
>> Hmm. I don't love 'respect mlock'. I guess we only know about the reason
>> being compaction here.
>>
>> But I'm confused anyway. We have the folio, why aren't we just checking for
>> PG_mlocked() here instead of getting the rmap to see if it's mapped
>> anywhere with VMA_LOCKED_BIT?
> 
> Also, since compaction_allow_unevictable() is a function that is accessible
> elsewhere, you could literally just have a TTU_MIGRATION here instead and have
> the rmap logic call compaction_allow_unevictable() instead rather than this.
Do you mean:
1. change TTU_RESPECT_MLOCK to TTU_MIGRATION, that'is OK.
2. move call compaction_allow_unevictable() to try_to_migrate_one? but as you suggested
   migrate_mlock_allowed function, it already called compaction_allow_unevictable()
   in order to determine whether TTU_MIGRATION needs to be added. Did I misunderstand
   something somewhere?

> 
> And then you could adapt the function I suggested before not to take a reason
> parameter but rather a 'is_migration' one instead possibly and then pass (ttu &
> TTU_MIGRATION) in.
> 
> BUT. I still question whether this is at all needed since you have the folio you
> can check for PG_mlocked...

I described a race scenario at this link:
https://lore.kernel.org/lkml/c372e68f-2bfc-45b6-a431-01bf55717247@gmail.com/


> 
> Cheers, Lorenzo


