Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2722ECD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 01:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576276B0005; Wed,  3 Jun 2026 21:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFA66B0088; Wed,  3 Jun 2026 21:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7516B008A; Wed,  3 Jun 2026 21:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27F846B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:58:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF5EE140504
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:58:38 +0000 (UTC)
X-FDA: 84840571116.07.57ACF26
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8E08C0003
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:58:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QIdgNneW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780538316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnlelyjEPA4eQLtR+vH42NF5EXOCOjHQA+g+i9GlLcA=;
	b=MeZl/hecWUCNQhErJaOYR9Op8LihWP8JPdZHYOA7KHgkZ417+8N6GEGHyfCjxdt8WbnvAV
	I4x6ItyIRqR3u9PrYMIog2Qt1XRzWbeVDuxXo40Zy05xIm0f3xJH1NhvYUsp6BuIXnAqO2
	uqi9JVKqXe6gcpw/X8k+3M2p9s5QDWU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QIdgNneW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780538316;
	b=ldcykPLCN/uCIMsdaqEGcvmybD04WQjw8SRgZZo+mpSWs++1upPcftcKJ37yEPtMKtNNqz
	gYJx9KMWOYeMrV445rHxJ1bRkud/D/9/uRS6qWpW0B7XLM+1JseYJOYYFRQKpC7v0IuWob
	jPD6YigenoO2an3C+KpMBlvEr0N6n3Y=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36ba285e98bso138996a91.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 18:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780538315; x=1781143115; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnlelyjEPA4eQLtR+vH42NF5EXOCOjHQA+g+i9GlLcA=;
        b=QIdgNneWHZTG2yySdaAbrGzjxPtt7mpJinbs+Aeobg+Q4pVp5ogohMXiwYRaI1p8o5
         VnrAmVqDctT0d9swnZ8vrRPbp2fIkDCtj+GOPujdTKP18BFPcgEvAMLoUK1/8uSUE+ZZ
         lbQyXBl+QjJAigCpHTjEJFq8dOBf+NmZ7vccseXyszjmZIqP0GZMIRfTRZTZ01BtzIL2
         G6n19Qu1oBgE8tRoZGKo99FANOyCeN4ko4VfSGQjw0bFCDHjYEIS4Qcx8jepynglw7Jy
         uT9LUSQ8wm4IYsUlNtqNM+6jQsiDZpE3Zi230vVFj7wSlUcm+tuT5YB4F1WZ3CPeLDCk
         S8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780538315; x=1781143115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CnlelyjEPA4eQLtR+vH42NF5EXOCOjHQA+g+i9GlLcA=;
        b=FGKG0ibf+0xI/3Ps8DSOfpiG/0ny1itb1e2jQWCgHXzf7vjLaeOjp9u90uL+GPCvLw
         sqO+9mI4D3DlqsmVI7UVA6NJLukHgZmNaW8HpM0fEwULIsLMwhv1lk7/nANVrGH7Y5Sa
         PeIHD0Geu/Io+8z+IYAdiWG7HuMS2CBJujsRCFBF5CjE6ReyK4bi1Z13+r703fznyAsV
         LkHn3Qhx8BGtsy4OOoYhHcHlLTTd4JxtiGean+ZT+SjQKkWDWWxYTYluMH19YecgvBhJ
         JCJBi4XxDTO8r2rD+gQ+58o9/nFD4VQDj9CeVa3yckwz6umG7sRw0JPS6KC6nKHHWPfW
         mK1g==
X-Forwarded-Encrypted: i=1; AFNElJ8c8lygPnMCxEk1aeUYL75sxuN1l5zjr2Z+yyUMs1Le6kTTSbmPwUw5cPM4vmee4WHW9E3DiilsUg==@kvack.org
X-Gm-Message-State: AOJu0YxMOmVRV2gF2fHq4BjFWfXSx+6TN78aHlC+DX3S4umUDyzgLptH
	W1jTT8en5Rg8eKz2r/0+xWomewrBO2dihVf86YYjmzwWMpOToG4+MQYu
X-Gm-Gg: Acq92OG7BL/uBPxgCpf8Hs/5IKae/R4MkbxXuixvHnSxgjt2tHAhAkc7qH8yh/Ne5wi
	hIMz1VAhyLRmycfSXcYv+yFXHyY/Wj+KkssddrsvTolKO+rtdo82vqeDxPoyMm2VNluWXFZlD0S
	XZisoUvwGm039mSvZvr78MpgJHyQOMtOiPzXqhqEQiy+9JM8o4pn81fVasy3i3ESvraRkp4vy50
	ZC7iLFqckIdY6QLTOhThTRA9lUEZEP6oPBaDdneMS7ulnbj812LYQ5U6LhPJLM3U0/zW+5SCQgy
	5zzDJif8tnd4rhZUKls+NgVX5IhgCynIchbD/23AE5knqOpZhG8hlney2Epvu2jw0BMxzFsJiuM
	aUjQHDV+XADsI4itSLFKwB8Iq49+XEmCJb5ZR1QZnOtq9O8gn6UoROG9v92e4bGuAw0Iw/+jq6y
	XD4eOB5cHji3H6VBeOFh0NgIdrAZXm48cKtwqVyDC1p4wYk6gZDtBGsg==
X-Received: by 2002:a17:90b:224e:b0:36d:f28b:72e2 with SMTP id 98e67ed59e1d1-36e32a4281dmr5807810a91.8.1780538315484;
        Wed, 03 Jun 2026 18:58:35 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8064sm1082124a91.12.2026.06.03.18.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 18:58:35 -0700 (PDT)
Message-ID: <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
Date: Thu, 4 Jun 2026 09:58:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
 <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
 <aiBpibRNi0BcM1Zu@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <aiBpibRNi0BcM1Zu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8E08C0003
X-Rspam-User: 
X-Stat-Signature: 1658i619qkhqz5jg1nbacxbxjc5k7yad
X-Rspamd-Server: rspam09
X-HE-Tag: 1780538316-377838
X-HE-Meta: U2FsdGVkX186kCDVbWDWoTPH8sgiaoCp7mS59Kan9k1NepYyd1FmT1g8fDiy88gp5HDl8VS2bWTJVg+SEx6L+CdOm/s33mSBZQPA6s0sL615907NlP+aiX+q8cBRbaWUH0l/K2Qg/CQsLVNccahNAh6I9b2GrJy470SCPGjLseQijJZbtijHaPRo+muVPXGqZr3ajQq5JJsYabL7KgkWlrICGM5ydA/k/GeBHS4j9ZC9IUZY+yZlQ0TVb9sJf+w/0mD7t+o1ZHzRU7SZtWl3VUrKMM5RqIQayXunEl3TWcZROb2zj4yZWt0OrPg0j5TMgogl1gLGRldTwe/4wDDYU//4Hzgg4cAoBmpHQaUElpWD6StIBHvyk+fihD0KnFU58v8lnN6fPNyKPtN9qZym2hUddQk6yoT/6PP1haqRWt5fCEs7CMDn4tDYqnLeYvRWdCDRAAqBtDu6/zGGO3an6q2UiP7gmgRWhwbY1wgMaFSKBAscTv+zdmeBL7dPZLDCUpiEHGaezO4sL/wbnbhBRz2HP/LTdz4jFm42rzdRMNJQTzbpRIU5oWRJzmivdojttynkfpNBNh8bNSShUtvzi96NS8hxPF+G5KnE94FIojXdT3cd/jEU7CgiIH/wiTrSzcOxxeIyKm0PY2JytBG9kfc6f0sljjBmGfi9MFnTmbHFWoF9qFuaaYYmZVmlp/LobvBL60vdTamNncBpvlXeRIacZEMXxY/4Zqy7Zo145ulnQ1Xl+Lc3PZ4KE31UhxdSkfw50wC9IPLt34xfvBKl/GZuCfOBleg4acEizKpHQc9htleEAQr9Xe3HGJsMuSkRHIN8Xlc+ufIEK0Mv+f1TQysuYABE/+w/XplOHazVc3KV0ZdcbNY6tZHlJEvuAcaFGykQV6M1e5hvhksEq8zO27SGcJ32mftqYQISUZ5h7T1Y3YJp40KOyY6+6/88+VgC+7rxtZIJoxZdAsmtJfP
 mLI44wjN
 NAbhHCdJTJ8wAP1k9WYmuCl5bUuqpBXwwsBfVjwy14BVH5jzRL0cj7pf1WeMLE0HU47ITCJa8gj01Qp468FZRttQVCGfcBT0rNMZmIxyce7U/EzP1B6rM4bj0nDCK5OBLS5ew7QtLcn+0ynnHQY1WAzwBOv3KDSYATmi8Fugua2Aup+AGr4zRdoGWHA36iSmTx5Xy++03dvMlLN/Vy/tt7gngvAx0rsUY0bYx+zn6korbo1N2XlflqBkefVJtHpuHzHsrRn+o01xoKT/CAbslBHAWaktreUR2eLEfwdBfgQ4N8Z1ewA6vthhvLpGfYuAL5BxRmzkOEPxzWUZaIdnYZfeKQ96YsBiwCFjPHKboEQJAPtRCBajTj8e88N5QsWIj0CuLUwQVuorUW/XWdh6oCt8xed8/EZbd3WcbLITGP1u+K2z4AQ3to/7+thkbCPfhj9lmwseY+jTNu5k17bsYReajfQNLtP06lCnx6n5EdcuqObA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/4 01:53, Yosry Ahmed wrote:
> On Wed, Jun 03, 2026 at 11:02:54AM +0800, Hao Jia wrote:
>>
>>
>> On 2026/6/3 07:19, Yosry Ahmed wrote:
>>>>>>>> Proactive writeback also wants a similar per-memcg cursor that is
>>>>>>>> scoped to the specified memcg, so that repeated invocations against
>>>>>>>> the same memcg make forward progress across its descendant memcgs
>>>>>>>> instead of restarting from the first child memcg each time.
>>>>>>>
>>>>>>> Is this a problem in practice?
>>>>>>>
>>>>>>> Is the concern the overhead of scanning memcgs repeatedly, or lack of
>>>>>>> fairness? I wonder if we should just do writeback in batches from all
>>>>>>> memcgs, similar to how reclaim does it, then evaluate at the end if we
>>>>>>> need to start over?
>>>>>>>
>>>>>>
>>>>>> Not using a per-cgroup cursor will cause issues for "repeated small-budget
>>>>>> calls" cases. For example, repeatedly triggering a 2MB writeback might
>>>>>> result in only writing back pages from the first few child memcgs every
>>>>>> time. In the worst-case scenario (where the writeback amount is less than
>>>>>> WB_BATCH), it might only ever write back from the first child memcg.
>>>>>
>>>>> Right, so a fairness concern?
>>>>>
>>>>> I wonder if we should just reclaim a batch from each memcg, then check
>>>>> if we reached the goal, otherwise start over. If the batch size is small
>>>>> enough that should work?
>>>>
>>>> Even with a small batch size, for small writeback requests triggered by
>>>> user-space (e.g., 2MB, which is batch size * N), it might still repeatedly
>>>> write back from only the first N child memcgs.
>>>
>>> Yes, I understand, I am asking if this is a problem in practice. For
>>> this to be a problem we'd need to trigger small writeback requests and
>>> have many memcgs.
>>>
>>>> This could cause the user-space agent to prematurely give up on zswap
>>>> writeback.
>>>
>>> Why? The kernel should not return before trying to writeback from all
>>> memcgs. If we scan the first N child memcgs and did not writeback
>>> enough, we should keep going, right?
>>>
>>
>> Yes, this issue is not caused by the kernel, but rather by our user-space
>> agent itself.
>>
>> For instance, suppose a parent memcg has two children, memcg1 and memcg2,
>> each with 200MB of zswap (100MB inactive). Triggering proactive writeback on
>> the parent memcg will exhaust memcg1's inactive zswap pages. After that,
>> even though memcg2 still has plenty of inactive zswap pages, it will
>> continue to write back memcg1's active zswap pages. Writing back active
>> zswap pages causes the user-space agent to prematurely abort the writeback
>> because it detects that certain memcg metrics have exceeded predefined
>> thresholds.
> 
> This will only happen if the reclaim size is smaller than the batch
> size, right? Otherwise the kernel should reclaim more or less equally
> from both memcgs?
> 

I gave it some thought. Not using a cursor could lead to unfairness 
issues with certain writeback sizes:

  - If the writeback size is an odd multiple of WB_BATCH (e.g., 
triggering a writeback of 3 * WB_BATCH), with 2 child cgroups, the 
writeback ratio might end up being 2:1.
  - If a memcg has 5 child cgroups and a writeback of 2 * WB_BATCH is 
triggered, it might repeatedly write back from only the first 2 child 
cgroups.

Although setting a smaller WB_BATCH might mitigate this unfairness, it 
could hurt writeback efficiency. Let's just use per-memcg cursors to 
completely fix these corner cases.

Thanks,
Hao

>> Of course, real-world scenarios are much more complex, and this kind of case
>> is extremely rare in our environment.
>>
>> That being said, your suggestion of using the global lock for the per-memcg
>> cursors makes the writeback fairer and would resolve these corner cases.
> 
> Right, but I'd rather not do per-memcg cursors at all if we can avoid
> it. Will using batches help make reclaim fair over all memcgs without a
> cursor?
> 
> We can always add the cursor later if needed.

