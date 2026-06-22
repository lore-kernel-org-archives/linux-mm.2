Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4836CD98F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 06:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9538F6B0088; Mon, 22 Jun 2026 02:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AC96B008A; Mon, 22 Jun 2026 02:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3226B008C; Mon, 22 Jun 2026 02:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 566586B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 02:09:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC0AB166F0B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:09:05 +0000 (UTC)
X-FDA: 84906520650.17.C5740EF
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD63D160003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:09:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ps5iefhM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782108543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDyp+nco3B5NIcQm8dnJlrIpz1rH5PTwVnURehE3SCs=;
	b=H/8ZtZ/wTXU4g1FaTooDwPUvK8KfPvn0t5OR20xTmtQYPb8FhPPdqiCArXYRQ4ut8Y4anI
	vPJy4uvyixzitrIKoZoYWVZND5jDPMRQp3rwvT/4U3KoaDjSBOAEFxjKjEczWQLl6bkO/h
	HCox6ytTZug/sKjpmLM0J4kLAT7QQy8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782108543;
	b=tZWPsAfLag6rQFp4IgGVkkVbu0EdtwQPJ3AKEtNWSTVCpSeDgCk13ryxAUjeVEirJGquWY
	T+pRZvxlWxtwEeyq+0LK622iIcXZ7VbtHr4IIipX/QTBbLj0CyYubICyrK64s2/XylmY6n
	8pPYFhyzRbpOGPGFgnR58oU42XtbPLg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ps5iefhM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c40397e3caso37415215ad.2
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782108543; x=1782713343; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eDyp+nco3B5NIcQm8dnJlrIpz1rH5PTwVnURehE3SCs=;
        b=Ps5iefhM7a9ziMJxrAYK4ykkQyKhXp1tl90yUIeKl1Ag+onxkLbBUhoaUTY8uNUzn+
         5Q5qHpIANyv0zdKHoCxegXuigx6sJitJiDkf97oeFUM8KIV9ZJYGWiAzcY8B6MP0HDC5
         QynxpbUXZy4mBtoytojnVkFH2jsyETxEn6baDcuIzhBbF7tSn7QR/WtKb4hPeyDpMzgB
         iVnHyJL0Uiuhr5MswsHffzzT1+KZp/A3s0//I8YlboHsoprvcftryxCnOKaig9uLLShn
         Yw7hQTLeqnG+GdnIMM4h4mLoC3XIiFwpjk2ERZ0YR8VMUGNNaW+SrmKrE8vaBS+LvsD1
         DspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782108543; x=1782713343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eDyp+nco3B5NIcQm8dnJlrIpz1rH5PTwVnURehE3SCs=;
        b=lHK7BjsyloVEVxG1ldRzC50IMUW+ETZ9gkCm/mNBxTxmErBe6II8McgZeBUG31GJif
         9uSTIpizTeoT8QYx8XQA6WQcX8ygnw8kZV6Ser0Fx6qzeLGTWVMRD0LCvrrRncwZguwi
         sjfSiVeWNm3cFRKN2A03p375f7j2CKLyeLf40RKV5NSUO7/h3dcNu7ELsN3lWvMTM+lL
         ok5ptRhtgLz9ncyaV3REyqxF2GLVPuIaQ8aNF1GabPVaOZHb+huHFXCVKNwmQdUXKnUE
         oOt3t5flCwo9CikrC5yiJCsqTNWxxnB4nFx2s9jQZJlcJ6Xiu+DK52xU8SCLU/oDOHV5
         WYyA==
X-Forwarded-Encrypted: i=1; AHgh+Ro7K9QqOZg2xM/0COIH0WwhzVaahwzdyxzS4smG0NaDdX9olFsQ4ThNWZDK0tVLIv21sHU2vmE4xw==@kvack.org
X-Gm-Message-State: AOJu0YytuVjqtFNB6oXAFZfOJdis/YDHRjDCqaqLqNAAW9jzenwEfi8D
	kuvlUClNKHOEaEZbcvn+SBD0RkNDfti6Sv17pZP19geS9ISui/PsM4fS
X-Gm-Gg: AfdE7cnBt3s3IkRIX9F5KvM9a91otxlTXbY1rOQi/hS4JFrt4lY5sCoKHfGd9x/rCa/
	jtMk5ObpPWGQHGuOySlm//vdbQhc03taj6k83HQfeNObirIQXMUfJp1cAlnm/pJ8lcS1dUdb5HS
	nYOHJ0b8/AeQG2KbC7HWGIBGKetK2yPLovSq8yiUf0DjNb9HIxYUyykyW5ORAOpcpfsM9Q6bwAA
	S+jSIHTFXT4SE6Ej26hVEx+WF9c0pWZd366WyJGtlRno02v/DwoCaB3Rn132laMupuxc0bTEqX3
	gmtVNcvNzBx1p8IF5G2bFdKeS4Wtfg8XhMLb6xb09zAksoiFXewnb06S0L4Kn14c1L7280L2tYq
	/cBGqOlQ7pfSv9L6UqMX7Ls88kdZCc1xgyfNVMWwtP0L2NZBgINv0cEmGDuNGOaoq1QmLUn/gb1
	upqd4AilxrlRE/mEhi3KfVfeYEZ6XO8M5a
X-Received: by 2002:a17:902:db0c:b0:2bd:8dbb:293e with SMTP id d9443c01a7336-2c725bf2b83mr132353945ad.14.1782108542643;
        Sun, 21 Jun 2026 23:09:02 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436f6395sm67323825ad.28.2026.06.21.23.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2026 23:09:02 -0700 (PDT)
Message-ID: <26a034b3-9cfa-e4f5-eea1-e69fbfff02b4@gmail.com>
Date: Mon, 22 Jun 2026 14:08:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 0/5] mm/zswap: Implement per-cgroup proactive writeback
To: Muchun Song <muchun.song@linux.dev>, youngjun.park@lge.com,
 yosry@kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <CAAAF57B-7DE9-45EA-8AB6-DE6CFAF60F47@linux.dev>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAAAF57B-7DE9-45EA-8AB6-DE6CFAF60F47@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: epx7fxu1ct77qycu1q6hycz3o4cxfqqu
X-Rspamd-Queue-Id: DD63D160003
X-Rspam-User: 
X-HE-Tag: 1782108543-367854
X-HE-Meta: U2FsdGVkX1+gC+wnwr93SWexhccxZihwxkgkw0bgzmSosJNf2bHEfe32nnXVH1IYXWLsfvrTy3uTk1cDMIObCq5Em8pns4NePg3RqRlsmkfeqhUSmc2Ko72PkpAb3HyX7dLZJDWB2VE02+0opu0JbcW2CaV6bCroqmOVCVEGAKeRjVDRw50Gw9XzdXdcg7QHsuqnB4whlUDAyaBXLrVZ4hdXi1xLrUfstuPKKqQLwSFmfkRZBvlP3nEGcKCCPHZs6+jdGX9WPlUOEV4Nbt+kozG8vBwo4pQ+Xv1djkqJBBQE4FmYSuhqQbYHgNaJgdCCzSbunS4FCHORD9XJkWRPezAWGwH1FFG09rpbhX3X2dj5rilBPx5VB+dO2mfLuRG4kJm8Zz23XL70DQfzu/dk05WSqI1oaQILPLD9y/bjQqfb5yjCTH0NG08Bpddq/zvOED0EcbTyD0NlL99pF6iCWrb0P2I96T5x/jCpDkffccZH/D4kcBqpKeN9kFsFtoKDZQb+POumE7uI4LJiIZeZBiG++ODUtcWXsPfw3jROo/4sEdE6Y3PDUdaU6B03/x7pGdidKV+BTRb/LfSeVP92TkISF0NISyQREx0w7hz0sDAc4y37OeHwPUecoVvhJKBasTCT8g9xxOjsu+1BG6XTxUL7bXKTFghVMGc6f8E+tD0w4zxyWIro0lqoLv2blNnz6YLENw19bTx8N1EvO3GdIHjag4mz++baS4Js6SuZUrQfux1zvbET+xLw3TOn0tC0e0SdwRMIlnKqFY/cPBr/6txCwqqKTh0yIv/mqoTwN5bEEkvhE0yjLfsrU1i0unTyaw9Mti9/3zWtLq23GSgMoylm/IWkus24GhlDNGLl+qNrjmlGfXTfYZWIo2Hj0xnAsnbqc6ivbtGj46oQkekeFZT+GtEqE23WF7XjH5hW1K1XrPciLmZ1zHaC0AMOkH8Xi+bFcXt4riHAjJ5bC3m
 veP4zHzl
 CJa0OgAZ0yius4GzIIDpA181Dw1tGbq79vfiNzmx+Tkmjre058Y+j9xNWQZ3a9Abl7zOKENZ2EsFt54FUoQLyyBW2KW0927hcXuKF1GlpOv9UOgFPvRVLUPLAEYJNlYrT+hd53vuYYG610x/3b2+npWhGjyEOjLJu8yNXLSg0552mSco1lXF1+WpmvbBdPNz2IN/S5ZBQ2eNfRZesn4NnVTTbVJrmPAq0CHBgeWi+CIKRosi6d/p30YmpM20NsMHiCKHicSdiIAxncIs8rzo1NLbn5e79IDhxIo6zOlNl5yG7YmL4ngLGeo2ZpKIEgWLjiRGDzy6B9C7AouyK+axQ5t7EgcQmbthKwQqyL37QDwPrZbkJ2D9rY6ybLSPDFC0fGZK8n8xkn/xPdhYTtA2jC7+0pEEgzYMws3llb5QRqAMPF6jbG2EHD3xUZz4gnj8JzHB7WBMqDw2XMh0hKHAD0iNQWITUS6vSBvQ/n0Jf1vkDfqQu0PACIzXfpGA+yKUVG2S3sCgKDCyMl0rktEuS4KOS1D7gCKs8YU+1V3EeBd29WXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/21 12:20, Muchun Song wrote:
> 
> 
>> On Jun 18, 2026, at 12:48, Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Zswap currently writes back pages to backing swap reactively, triggered
>> either by the shrinker or by the pool reaching its size limit. Although
>> proactive memory reclaim can automatically write back a portion of zswap
>> pages via the shrinker, it cannot explicitly control the amount of
>> writeback for a specific memory cgroup. Moreover, proactive memory reclaim
>> may not always be triggered during a steady state.
>>
>> In certain scenarios, it is desirable to trigger writeback in advance to
>> free up memory. For example, users may want to prepare for an upcoming
>> memory-intensive workload by flushing cold memory to the backing storage
>> when the system is relatively idle.
>>
>> This patch series introduces a "zswap_writeback_only" key to memory.reclaim
>> cgroup interface, allowing users to proactively write back cold compressed
>> data from zswap to the backing swap device. When specified, this key
>> bypasses standard memory reclaim and exclusively performs proactive zswap
>> writeback up to the requested budget. If omitted, the default reclaim
>> behavior remains unchanged.
>>
>> Example usage:
>>   # Write back 10MB of compressed data from zswap to the backing swap
>>   echo "10M zswap_writeback_only" > memory.reclaim
> 
> I’m not entirely sure if other candidate names were already brought up
> in previous discussions, so my apologies if I'm repeating something here!
> I do think expanding memory.reclaim is a great approach. That said, I
> was wondering if we could make the interface a bit more concise while
> keeping it flexible for future extensions.
> 
> Essentially, what we want is to control the specific targets of the reclaim
> process—such as file, anon, or zswap. What do you think about using
> something like "source=zswap"? For instance, if we want to reclaim 10M from
> zswap, the command would look like this:
> 
> 	echo "10M source=zswap" > memory.reclaim
> 

Thanks for the suggestion. TBH, I personally think your approach makes 
more sense than "zswap_writeback_only".


Hi YoungJun and Yosry,

I am not sure if this suggestion from Muchun could decouple zswap 
proactive writeback from the swap tiers, or make it easier to migrate to 
swap tiers in the future:

     echo "10M source=zswap" > memory.reclaim

For now, we only specify the source. Later on, the swap tiers feature 
could extend this to control whether to demote to SSD swap, HDD swap, or 
other tiers.

Thanks,
Hao


> If we only want to reclaim 10M from file pages, we could easily extend the
> syntax:
> 
> 	echo "10M source=file" > memory.reclaim
> 
> And of course, we could even combine them down the road:
> 
> 	echo "10M source=anon,file" > memory.reclaim
> 
> to only reclaim anon and file but bypass zswap.
> 
> Just some thoughts of mine.
> 
> Muchun,
> Thanks


