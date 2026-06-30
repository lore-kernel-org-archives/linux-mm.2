Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD77C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7FD6B00A1; Mon, 29 Jun 2026 21:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF8C6B00A4; Mon, 29 Jun 2026 21:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF8B6B00A5; Mon, 29 Jun 2026 21:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36CC26B00A1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:18:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADBE91A02FB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:18:28 +0000 (UTC)
X-FDA: 84934818696.19.527120E
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id D0B0216000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:18:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EQYJHyoB;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782782306;
	b=yrJH6UfhLLFvWWCmlCjDpwsWfwK5UiD2QMEcjV5SLlSFx+LNua+TSpR2fyZjKTHzKInXXA
	taOBhuzZ51O2DnVs8/3HO3HY18zIeQ+2+nfAYF9SoAEGj/KM9n8QK9SrA6rdPa+G9xw2Tf
	A5Q40pkcWxr9pApodMWevB6q0YyFfTA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjccltFszzoLCJ/RxIOjcBIRQ6g0sQYI1eSvIvcwjP8=;
	b=ByK5lG7mh2ex8j0gVt8CWC92NUx/+Jf624BtTBTgTnKgeGDFV1p/eyFgt5ajN7TJzkRpQi
	EgfidDVOsaoc8+cm+i+ZwA3kZjYB7JnlAY//B6WApYIDwYiMcMUHVisj+13ZCcHj31q9dl
	qjFXpuV+HV8rCbjhQZCFxqRjrBQutws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EQYJHyoB;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37ff436a048so926531a91.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782782306; x=1783387106; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjccltFszzoLCJ/RxIOjcBIRQ6g0sQYI1eSvIvcwjP8=;
        b=EQYJHyoB1t3O6YPSz6u09KPo2wjAppDsuqZ0ZJ9Pwt+pduDQHmaPkODfyOfpJVJ/FW
         9/Sk4x/TbXuztniZXNY8hfhLGGuUv5OFjxJoALMTRPFXYz85TRpgDz7FwTf0nh4CF0GI
         tXb9ri9M9lt2hHdqK3TYFlSFZwz5BB48xtH2iQze3KgItV2pA+RLgLJpj7vhOWDme0sc
         35iWhA5MC9RyMlBpCTsu+3QV0M6aQUKMpQCrUuOK3YsQtvzTxYOZkOXrNGd+lQv5k6h7
         VC3f1ztI0tLrieobRkcx29pCB2k36dYaL2xEcK2MCPWV9iIsKePv+F+GPQJB+imd2uvc
         XwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782782306; x=1783387106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VjccltFszzoLCJ/RxIOjcBIRQ6g0sQYI1eSvIvcwjP8=;
        b=K4LqTWdkTWC//kbH8gRGR/yx/L39giVTvwByqshejgPufz0T0E/AXQmscPiNOPmlW/
         5tOhEQKqFB0aVHDlSiKg8hMgDq9jvUOTfDN+90kxL8oN9tnCfFPbYgqfgBj0Qwx8ZNXU
         FIWcY/SvpVammnJuy3382EJw76SRvXaMxGCRA20DHFuFrr/unA1M4hzJyvFuRYLqL4xh
         Bt+6UjiELzJnutqMTQgureaFXh3zJ6SWx4Uh97mLDCSUY6uXOjVYVKnrgdz1q8ZThKrn
         y9ebllwXsK30sc/Vzlba+yUAPBmr9S33q8EJdKwY1/urtNRWrBAmJEF1aU7xYjfb1VpX
         SMuw==
X-Forwarded-Encrypted: i=1; AHgh+RqERg2muS1oxZE4JhcjcAVcgOGCMPgk53SpvyFfRZDyMI3DES5wzXqtDrHoMA/wSbUGn9rkpmaIbQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4ei1kG20ov2aOA1NABes+BOxP8h2VBijTMYGBr+fM6QLQOhJw
	KPecYvMmIOaTzCAJ98dROwXARhgDX9Y0sccXK/3LQ1xWElhTUVSWDVyj
X-Gm-Gg: AfdE7clUZlv/+LCKv+dpWY9WFirYSnnhknKMcSxs3Puwm5XSOdZGGBsnPX0yd1E5hni
	FmIcPmSUaC19e23G8pqYt1rYnu8lwuDNG1ozmWuykkGYLJiCn2rW+xMYAiySUKgw9dJf6GLXAmq
	86Y6qIk9OdbewJxpNPfFxxrHZ+bSEshEV60CUtxilb26MgkT0wbtVWmVsLHFIdcLbWfO14pZuzH
	dTiUjsBe6UeHsJl+DAFQeP+fUrWDrTnDmmUVva+XsuPcEAKQ6c1Zlk1Oy+ypIelygBFdZvr7yyW
	WzNucXuigsEnqkubYVf61WUhJYW4TqEBGCU1V67AVi4PCqnOMO+s/RoS1YY7ZNjXzmO/ZaZrfu6
	8hPJ/lqvW1jIS4JVs8FRYjwt+T+p8/mDbWAseDQGsG/I5h64d0PWSPK25RFw7j0bRwBbbXgxo6p
	4sW/brgnmSMUgnH+g8N3qj2vU2vCM9VlqkPhwbLYz5ElQ=
X-Received: by 2002:a17:90b:2cce:b0:37f:9ce1:7367 with SMTP id 98e67ed59e1d1-3805277ed34mr1245013a91.29.1782782305643;
        Mon, 29 Jun 2026 18:18:25 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-380529ab9f4sm603942a91.7.2026.06.29.18.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 18:18:25 -0700 (PDT)
Message-ID: <a152be7a-b36b-3b54-0cf8-20f453905bef@gmail.com>
Date: Tue, 30 Jun 2026 09:18:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 2/6] mm/zswap: Support batch writeback in
 shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-3-jiahao.kernel@gmail.com>
 <akMK9z_GOarOZWHz@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <akMK9z_GOarOZWHz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0B0216000A
X-Rspam-User: 
X-Stat-Signature: 8pm1rrhpqhkh4wcha13m9kobmaheeozu
X-HE-Tag: 1782782306-281813
X-HE-Meta: U2FsdGVkX1/injcgKRr/dzYC5F1x4mtD6w7bIQdkPVAgh1jVDPar1mm6/u/M266I5cl/y5afb5CDQOZ3Mjl0bpkY1c8ZEALcHvQGHBDiFZFlKVHTD+5bPrpzSjRaZIfXOgn9kIzD0HWY8LCkY7VrdDL9c47zFQSKcUsTfQThpqpaKc20/OoTw++OH73YJ5zfV6VJkGECJB85SnYePykClJ9Opc2sWDCl5vcKYUeX++ajYEpLwIe5t0RETJ1pMe9GvefFdXLryh3MjSpLshBDnJki5HlNhnv4g8WCw0C3P3I/0LyLXRvgDpA2kmtzX+zr4A4GUkJmGSs3OM/kkGoTytVDON9UXHOXEOhR0/wq1az0SEmUaIJxpS8aXt4ETyMNhkCpvi5E7Kgu01i+k08zYLjKbr/H7SHzVC7bUAUwqZlOeGK+JRsC15kEG1ItuJf48C270bq+TsQG26WuQtZyII9OTp9TWfLCTrO17780zUL7m1oV+ov4UjHZiC9BS5GdXg+QHHJKPA20iiWmZ7ftcQlqJIwAj6dgEp7DE+aMoK9yU/nZuK60nBgHd5QXv2kBIYsgviXSOFKAZ2n0upgbcuPsDQE435v/3NxLWPTO17+qTYJod4PiSzYIX9Daow+mYrUtVRZenKaaHcui2XXAgSeS4pbuZDpreU6y+/u2z6flp+yVloqPQDVFVsJndqtA//2OIzUpx3UkT+ZF896AxRFz4ILrEfoCmMILtew4fezvfaI/wyMgL9sgaQzfOo4Zy32VLSijf0FoRic8nKCMi2+9/ekzZOMHwXmVSM2VA5KD4swoWTAyWNM0IF7oPzYU2uc78LXYWl/fmoI9frK6H7xlNsnW4GUKRchCHzeqiK+Ew5OOSXfP5EQ+Rlnl/UdybNXd0NIxoEm8odkowx3e4n6kjpsc1o/V4YrByMrIBBcqXlQo/dMqZx/waki+7JScGrFb0GIDoNuZHZlXlnw
 XI3gmpQ8
 XMl4tVdFBKVvAJx8SiITPYkB/5oKrArZS95iE/mbmI0Fq891+t7BWF7WJdAu6LOaE8X6b9h3CoBCQ3WkvCI/4LARs8nNXAyk8fN0X3j1+pFvGZl2WFaRHnX55yIagr/R2l++tNLP9v+w+ffAvrBNBUjjB4wDBQDt0Oe40DDBSAeUu6ZfAm/HaILJi3J1WRTN9u9LpRqVpI4+X0akAbCbG/sJCQ92ORgc0Y6/5fjMchABki6KWnqn8YV1Je26HPn7sWA03pUoTIKIJFjsrrk6tYhTCC7cg7piB3M1mC77n8esRfkbXU0tu8iA5u2TlT2lYVu2nuKKfGn4jSntV7rhkOwvkePDhKlBZFrmYViB7SF3jXDknpaitIIVJElzoL0r3qiKNqZ9wn3YzGgkaQs8gQmWKvHN9iGNNndjQ8qgAUfzsIK6sJIQllu38MkFXV5MOKVpdEUtGohCquGSzDEPdwr5hHhDlAg8SgPV7N4ikdFNAB0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/30 08:21, Yosry Ahmed wrote:
> On Mon, Jun 29, 2026 at 07:20:28PM +0800, Hao Jia wrote:

>>   
>>   static void shrink_worker(struct work_struct *w)
>>   {
>>   	struct mem_cgroup *memcg;
>> -	int ret, failures = 0, attempts = 0;
>> +	int failures = 0, attempts = 0;
>>   	unsigned long thr;
>> +	long ret;
>>   
>>   	/* Reclaim down to the accept threshold */
>>   	thr = zswap_accept_thr_pages();
>> @@ -1373,7 +1422,7 @@ static void shrink_worker(struct work_struct *w)
>>   			goto resched;
>>   		}
>>   
>> -		ret = shrink_memcg(memcg);
>> +		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>>   		/* drop the extra reference */
>>   		mem_cgroup_put(memcg);
>>   
>> @@ -1394,7 +1443,7 @@ static void shrink_worker(struct work_struct *w)
>>   		}
>>   		++attempts;
>>   
>> -		if (ret && ++failures == MAX_RECLAIM_RETRIES)
>> +		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
>>   			break;
>>   resched:
>>   		cond_resched();
>> @@ -1504,7 +1553,7 @@ bool zswap_store(struct folio *folio)
>>   	objcg = get_obj_cgroup_from_folio(folio);
>>   	if (objcg && !obj_cgroup_may_zswap(objcg)) {
>>   		memcg = get_mem_cgroup_from_objcg(objcg);
>> -		if (shrink_memcg(memcg)) {
>> +		if (shrink_memcg(memcg, num_node_state(N_NORMAL_MEMORY)) <= 0) {
> 
> Why not just 1?
> 
> I guess the current behavior will try each node. But this doesn't really
> match it, as we may reclaim everything from the first node. Right?
> 

Yes, it just keeps the number the same as before, but the behavior is 
not exactly the same.

> I think it's probably fine to just do 1 here, fairness is not the main
> concern in this code path, we're really just trying to free up some
> space to free up some space for the incoming page. I doubt these limits
> are actually being used extensively anyway, so we can revisit this later
> if needed.

Okay, I'll do this in the next version.

Thanks,
Hao
> 
>>   			mem_cgroup_put(memcg);
>>   			goto put_objcg;
>>   		}
>> -- 
>> 2.34.1
>>

