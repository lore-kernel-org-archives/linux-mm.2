Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701E2C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39ED76B087C; Mon, 17 Aug 2026 21:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376786B0880; Mon, 17 Aug 2026 21:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3D16B0884; Mon, 17 Aug 2026 21:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0154F6B087C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:53:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 843A5C0A13
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:53:34 +0000 (UTC)
X-FDA: 85112718348.10.FFA79B8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 783A140004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:53:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787018012;
	b=veY232PFd+qTqe9enYJKpB2AMNEZnqDJp8Aw8DP99C9kI2mxNm6AVOh/umRMCRU47OdYGP
	0ukYN0l+AnLFx6Y4Ch6LCCPxYk1FKNSNu8fp2PjoW4FDDWWiNtr5e5zq6noku7vcrJZhdz
	1/waGAub+uCCNJaSTDwkfSAdcoJQ1/U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787018012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmXD+HmT0AIOaJEmNMywZ/skNFvdR8wHQABZSAO5Tp4=;
	b=orN4RxFw57EPp7jkys+raLWoLjhcbnkIvIfRgNkL4P3TuYT5wiCos1Tzm9DFzLLGhYiIGK
	6qFIbFKhIsu25O75CSMyldNb8JFxdiOyKi8qXfZLkt9Zkg5bE2E5pdw0yLOfuk66WBTs7S
	zqJx27n3C/qb9Ixq2scQsktFbeakfSE=
X-UUID: 98f26d409aa711f19a56ed5b684f684d-20260818
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
X-CID-O-INFO: VERSION:1.3.19,REQID:3467a7b8-6acd-4bba-98ca-171a139c49ab,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:3467a7b8-6acd-4bba-98ca-171a139c49ab,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:82d02ce816d1a340e5eda7bf45feaeec,BulkI
	D:260817213154BZG2GML9,BulkQuantity:2,SF:17|19|64|66|78|80|81|82|83|101|10
	2|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 98f26d409aa711f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 839497270; Tue, 18 Aug 2026 09:53:24 +0800
Message-ID: <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
Date: Tue, 18 Aug 2026 09:53:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, akpm@linux-foundation.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
 nphamcs@gmail.com, yosry@kernel.org, chengming.zhou@linux.dev,
 yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
To: Shakeel Butt <shakeel.butt@linux.dev>
References: <20260817131843.45121-1-husong@kylinos.cn>
 <1787017182353556.21.seg@mailgw.kylinos.cn>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <1787017182353556.21.seg@mailgw.kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 783A140004
X-Rspam-User: 
X-Stat-Signature: bhmupnygek5c9554peb9zhyts4j9hxpt
X-Rspamd-Server: rspam06
X-HE-Tag: 1787018011-411596
X-HE-Meta: U2FsdGVkX19j77b3deV0vhlfDUUI8vy/ESNDuzLtJLjCsKywHVlOgFtYtyIJS8pSb06cTvNsRWiXJuRePe4X9tPjnFa9Sd2uHcJRBwm10j5cJrni+MDmRLn8TMLD84weIINZpaeGBwJCCJzllA0YDbIubD7lFzqPsUbFzkLYVWlRpsZkJL8SwF0xuejHTuMX82WzjnF/PMlghY5dBA8yl82CjJnjt4T6WZ1eepODxyDE0Sfi6Wh4teJbybTNx37CcFBjhIACoqxkTFFF7zIDTgmzCHozSL38F6iDeIE/aPD5nCJfpEvvtyvpH7w5fFYSimV6oHPFoYWkb5rjtqZVHCSZKXFdM7Hz9L0z+NG0JXcM5a3nrd6piF70VVyyGo1d4xyo2ctRjySyxVjgp2+EeSvKMLNxLCn1NJjCv96rmIT8c7INNioPwnQwkQjiLG97QNIt8MJeMCwvuJPaSoN0OZwwTupT3DzE7Qiv4XQZFWiO6Gg32AlxIhKe/r+DplOkZUGQrGGeP0CmSMnWtCRzjJ9o3D7XF8Qq0KCSX6zDX054B1fEQLbiRkthVfHNETDZHEHtKavAPxukrFrtNH7TshZZsPePB/g9W95ohC9oWZej1lOEOYq4MbhzfXkkOVhht5kYDRJ9TU3OlTzEqDfi0cGQoW5bY7B9oeLIwRoOrAHbz+lXiILcNC/mt2m0Rz3ExCCfGqmMztHbWwnSffo7jrSgxCUClKxzF9ljbPbZ3ew/xqThNTVY1aaIB3tW2CsKovkSXZUQNBWUE8jsfezcguMJAcpbw1ezk6njw38UenpKIj081/O9VQpd7hFO5YyClVqK0bRlHhcWGWn3yUbi1xrPk47ikkoaQsBEBhCwVbqii+EJGZf+WB/ymQV7X1k5D2Q8hZDS2n/pu51mTfe9QMau2tvzqFXaruYJRxdx41OunRERw4JwqED4Np9B1UibCcCkB5Jh4r5L1AGyd7k
 dva6J8Xk
 Jp015avpNhVWS347pOa+T0dPdl0+XqV+nijj9UW0XHNckF9MWnC8VA/v0dM3Da63GplxjkkOybYGqDr1HWfdq3AKN9EDFxgIcevT3SfbY2QC40PyCVnOyDIKNkFISMndUcWLj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/18 00:04, Shakeel Butt 写道:
> On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
>> obj_cgroup_may_zswap() runs on every folio swapped out through
>> zswap.  For each ancestor with a non-max zswap.max, it flushes the
>> cgroup rstat hierarchy synchronously with force=true, which skips
>> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
>> with zswap.max configured, a container takes the global rstat lock
>> on every swapped-out folio.
> 
> Any reason you are limiting zswap through zswap.max?
> 

Mostly fairness on a shared pool: zswap.max_pool_percent is global
only, so on a multi-tenant host one cgroup's cold anonymous memory
can soak the pool and crowd out the others.  zswap.max is the only
per-cgroup control over that share; memory.max bounds the total
footprint, not the share of the pool.

>>
>> zswap_shrinker_count() had the same pattern and switched to
>> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
>> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
>> where the same flush on the shrinker side showed up at 2.88% of
>> kernel cycles under osq_lock on a 96-core machine.
>>
>> Measured on a KVM guest with a swap storm under a cgroup with
>> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
>> before the patch and 198,968 times after, while
>> __mem_cgroup_flush_stats() was entered 281,017 times before and
>> 80,445 times after.  The removed 200,572 flushes match the store
>> attempt count almost exactly; the remainder comes from other stats
>> readers in the swap path.
> 
> This is a known issue. Using ratelimited interface also comes with a drawback
> that the kernel may react on stale information and the consequences might be
> unneeded oom-kills.
> 
> There was orthogonal discussion on moving zswap limit enforcement away from
> rstat. Yosry, any updates on that?
> 

Fair point.  The direction I had considered is the benign one -
stale low after a burst of stores overshoots admission for a cycle.
But after a burst of writebacks the folded value can be stale high
too, and premature rejection with zswap.writeback off or swap.max
tight ends in a memcg OOM kill that accurate stats would have
avoided.  may_zswap() is admission control rather than a hint, so
the guarantee matters more here than for the shrinker side
of ea80da363a1f.

If moving the limit enforcement off rstat is happening, that
supersedes this patch and I am happy to drop it.  Otherwise it can
serve as a stopgap for the per-folio lock cost - your call, and
curious where Yosry's discussion stands.

Thanks,
Song

>>
>> The stats can now be up to one flusher cycle stale, so zswap.max
>> admission can overshoot for one cycle in a storm; the overshoot is
>> corrected as soon as the next flush lands and later stores see it,
>> the same tradeoff the shrinker side made.
>>
>> Fixes: f4840ccfca25 ("zswap: memcg accounting")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/memcontrol.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 17da1f43b7d3..7a8f689055c6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -6000,8 +6000,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>>  			break;
>>  		}
>>  
>> -		/* Force flush to get accurate stats for charging */
>> -		__mem_cgroup_flush_stats(memcg, true);
>> +		mem_cgroup_flush_stats_ratelimited(memcg);
>>  		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
>>  		if (pages < max)
>>  			continue;
>> -- 
>> 2.43.0
>>


