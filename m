Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C36C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CB06B00C6; Mon, 17 Aug 2026 08:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1070E6B00CC; Mon, 17 Aug 2026 08:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F103E6B00D0; Mon, 17 Aug 2026 08:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D09486B00C6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:59:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C6F6C0715
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:59:41 +0000 (UTC)
X-FDA: 85110768162.28.5571AE8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id BDC20120002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:59:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786971579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LR1r2e/3rZ3IV1rsw1yPeH6bda+mK29ckcB6mmgrfSI=;
	b=7XrcV8DSYWazWOAnoC5hrqN9CiO7xxDjAL22q3e697Q4q6zkRw0D3HTaF2WpULo6ysjgAT
	rgu3ZgMB1Wef3mLRTJGQX3wVkwQDSY1VH4zhCe3OdWaa8dnU8ODSOcOJO1dKQhhDw/enDk
	jK6ySF5xsrEMMTLh7E3bR54prFCPw5s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786971579;
	b=bQhihSoS9WiIArl/mk4new9/PZqpVW7uKdtZhyux8FC8tLjooao4Xhl2U/+/ByjcReflyV
	dRsul+fqzHqVsr64ByLhowFWwAIo0D5Ox0sj5RYBUcKeVT7Jv6ykyCBYbDcyCe9EPl3nqo
	gOMfBWkmJMMB0dsNFDLURW6OCzExdsE=
X-UUID: 78d2afd29a3b11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:20c77bfc-890c-454f-b469-44eaec05df7f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION
	:release,TS:18
X-CID-INFO: VERSION:1.3.19,REQID:20c77bfc-890c-454f-b469-44eaec05df7f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION:r
	elease,TS:18
X-CID-META: VersionHash:7db8b62,CLOUDID:9d44d1eae9543b53943c25c0b960a562,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:6,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 78d2afd29a3b11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1916834942; Mon, 17 Aug 2026 20:59:24 +0800
Message-ID: <64e6f737-292f-4678-a1c2-aca95cfb672f@kylinos.cn>
Date: Mon, 17 Aug 2026 20:59:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, akpm@linux-foundation.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, zhuhui@kylinos.cn, joshua.hahnjy@gmail.com,
 audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
To: Matthew Wilcox <willy@infradead.org>
References: <20260817025917.66233-1-husong@kylinos.cn>
 <aoJ83tk7R1x3Jul-@casper.infradead.org>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <aoJ83tk7R1x3Jul-@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gozidfahodang4dbmarydycp5gmcdt6i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BDC20120002
X-HE-Tag: 1786971575-641209
X-HE-Meta: U2FsdGVkX1+S+RCZCsZq2j+TwyyxrF+/ua2xTZTNiFXeeJrLShNp3Y8jU/vSPTwIor2N8sApwHqnlR2gh9MDsUkhBljtGMFFt8IWKlwGpASqP2V3ZW9JL2j/jXYX5rbNv7x02+6csv4aWZ2AuPYXmtbMVfBNr6QV8vIJBPUA6eI2eTMAMPpUtCkmthW373XoL1426uDD64wK4G0iIPMMD+ZyftC3XJWxG9jIOyLj5RkSNHIcAGPVQXQJdulBm6ZK3P7APT3HP3itgjJv82AEvzCC7JALuOusm/CTIYCbneIkTT8xDMPuUqCZXg+egS0dNOzLo8GtbgteE5HZTRWpQTGpj9N1yTW+r+GvwAFm1pIdWnK/AjalhvncTwICQRkSBgEfd9beafdgEMn+yqXDS8ZcoKiXEh6GXlAPfrMVrU5b9xsu6M24w+mtRC32Ge/Bf5RHZE41SNppEQdCY4VSaNb/9n7MJQENiGZ+IOYVdge1ve6qkCkG30Xxt4KWVOyFTe1bD/RC98VroT+rD0krHpnQoaJzfcEZ0PHubSPcZTQHI4EnzQqlEI4NG7EB5MUXjvODuhK+UhL2U+5sv86ozEaVE2cAckfKupR7M1uW8JSxpI8OlNoS9/Eh93gN6kgwoh8c+RGnylPqLp5ya6DVwgTf95pyhvoSE8m4o4K1mPam1/wooJieFW3V/U0sElfLVLG7ldH0ne9OrkjAP2BaYulh9XTg8rSJio+hY2g2nH0S4+fDQVUmUlEiGxoLNsWc6AZQNrXSw20CmH2fkhJKfp2O1JZiToN1udrtgci8ZEBXd5/yy3obMNMubkAH9VAYHT7cfRUqjsWOxKUghUAg9ueAFS0vvLTU0cfMkpGnfg2LeHo/lzX11/PWE0ZfFGfw2toAxTzyHQ7TvQPXPePH1qQ4rohwrYULL8mZv+GWUwXS+WKHcVbgiSRKcSOYi4C/0KIZgWUhtkCR4pYXA8Z
 xLx6JOhf
 toirtB0zC5KCuIcn9KiTwTzXd4Mku9c/ncmVTJJLocC16/JrysI9mN9wDjb/nKJWd467R/VBPsGHj9u7HtKgmS/nIxC9QbvJNYemwEmB2g7PlOOWVvl0T4Gt7GTuAht29w7XkcfwFN6mt1hVDsrkWoA5jxA7giZi9v6FWQN0+JdPmPxvF2uCioikiI45uEFTbgJq8oyjvij/NGsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2026/8/17 11:15, Matthew Wilcox 写道:
> On Mon, Aug 17, 2026 at 10:59:17AM +0800, Song Hu wrote:
>> refill_stock() takes a css reference for each cached memcg slot and
>> mem_cgroup_css_offline() relies on drain_all_stock() to release those
>> references before the cgroup can finish dying.
>>
>> consume_stock() can drive a slot's nr_pages to zero while its cached[]
>> pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
>> the offlining drain is a no-op for them: the pinned css reference is
>> released only if the slot happens to be evicted by later unrelated
>> charges on the same CPU, or by CPU hotplug.  The memcg then lingers
>> in the dying state indefinitely.  On a CPU with container churn, a
>> per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.
>>
>> The sibling obj_stock_flush_required() has no such gate: a cached
>> objcgs slot is flushed regardless of its byte count.  Drop the
>> nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
>> empty slot is a single css_put() and a NULL store, and it happens at
>> most once per slot per drain, so the extra work is negligible.
>>
>> This is easily reproduced with short-lived cgroups pinned to one CPU:
>> 12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
>> across later slot displacement.
>>
>> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/memcontrol.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 17da1f43b7d3..b931ec16bb82 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>>  		if (!memcg)
>>  			continue;
>>  
>> -		if (READ_ONCE(stock->nr_pages[i]) &&
>> -		    mem_cgroup_is_descendant(memcg, root_memcg)) {
>> +		/*
>> +		 * An empty slot still pins a css reference which
>> +		 * mem_cgroup_css_offline() relies on drain_all_stock()
>> +		 * to release.
>> +		 */
> 
> I don't think the comment adds any value.  It explains why something
> _isn't_ there which makes no sense to someone reading the code.
> 
Fair enough, will drop it in v2.

Thanks,
Song>> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>>  			flush = true;
>>  			break;
>>  		}
>> -- 
>> 2.43.0
>>
>>


