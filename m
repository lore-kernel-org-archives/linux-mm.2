Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD7ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34D06B009D; Tue, 12 May 2026 05:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5FD6B009E; Tue, 12 May 2026 05:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5586B009F; Tue, 12 May 2026 05:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7EE56B009D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:32:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 814441C0E6A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:32:52 +0000 (UTC)
X-FDA: 84758253384.07.F72906E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9F4E140007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="X3DG/qAc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778578370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5G6+bx80FRHpgHi4yg0luQJohBPaG8COWz9arYdTBtw=;
	b=hS4rDtBTsXD1eBjtSY06hEL9HikohSIk55VTOPgeTRnjOnZ/vbZQz4AXLQSj73hbyUF8Rq
	G685toGetS3BzyrvvdSjHok8+b3TyvrgwXc7wgNVx7z+j1C+9uMhS6wvXM616vrUGSytA3
	sogeumUvcjzX1WHSAHZiOCA1K7elpWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778578370; a=rsa-sha256;
	cv=none;
	b=AN3FLMpXExsepgMMf8mV/xJlciZcUUjQuVNFpEiNeRV7podTzvKiuG1QvdyHiP8Q+WUKww
	XSn02gSsWd1U43jJFb1A6bFD8eSRZ8L7ofCIHsGD2SQic0Fom7sznmPEQoF6MLT/pVOLS4
	Bb8r3eimDSqi4P3DQYlf6F/myQVtxLQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="X3DG/qAc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b9705613ddso32632925ad.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 02:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778578369; x=1779183169; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5G6+bx80FRHpgHi4yg0luQJohBPaG8COWz9arYdTBtw=;
        b=X3DG/qAc5OnjqrNOxWzMpjxEYZ5AXa1JydfKtFPyPh14l+Clp0v9jG2iiw1X8s/i+R
         QaEL0O2aTReIJXLWmj4rhz5JbKSPRlrIy+2T+lbbU+u/gSUaNSXwWbVlG/fCBPwmPvHT
         kjQffENFdVKe25i9zZOguORUOqiomxO0IdkMMgSy7nbi4S63J33DYDhlY4n74niqtcpt
         m4C9HBSUjV9cbVcyjD0ojf54uyE36mo3UQUX3h31F6uCPkWZEj4Pn49S/EUgUq6Gyw1n
         vwAlnNVjCUcSPIwBKDk1u33VKWXoaSCvf2yO2i26IOcuJhbdnefqTHkJjptkcQidayqu
         hIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778578369; x=1779183169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5G6+bx80FRHpgHi4yg0luQJohBPaG8COWz9arYdTBtw=;
        b=pWAyl8ZHGtUoQbyczKGlcSaMlOXxqKXgSpxjdoRwqiQILfb1E3+g3vrSl7rsXhvFDg
         1doZe0m2YAP6cn//MnEloPyw7luHrxWu/ONUFPjXOG4PwfCTogpQWdzGYFkWE4sn3jRE
         sMycMLVU0PSK9jt+5UTQivhzx5AqwU/S7ODoG8/MBZ9J+NIUPjDNZctfBU5ycd9ApIef
         Du+p2orIpgs7LepL5tYXCFtzSBX+dz6tuzSPVhQStWI4C65TNsPMNOWW5qSelFsZJaeN
         WzD8LTbf7tK9WDjHbh1aX285ZHiuKpp5Eb4TMnz3wkUdsXy0zIoxWXdRRHMLOAnH6GzQ
         Sr9w==
X-Forwarded-Encrypted: i=1; AFNElJ9KvlFNnpEDjuwVNa/zdyruV72jrF1HCViNVdyRjHa/h2SG/BdoPw246lgTQ4PyFZz6tM1EGLqaoA==@kvack.org
X-Gm-Message-State: AOJu0Yxyl/hV7eafRO3kVAlSlEh8or+tEB2/CEKHdXOdFVB238YCqKDl
	lXrh1Du2i1X74oWpki0ojMcnAonlRJ3Yt08DHgt1PdscYWE5erMUuW9M
X-Gm-Gg: Acq92OFzLrKe69ismwJNrVabqXymyf6KlsFKyi3xiZ3X0Zc31tzRdZKZCoqM3//tf7T
	5t5dt2GPmXxdFGM25BQP3/dyv69hZjJUa2cZW0Vb6qoplX9hDqYRF+vC8+daUUEU34nGEAV2cg/
	7T9dT1JSQOoJ1DCitFUN/SDQahB+5enXaCVyFArz9DxiQxLwsnpnQ5fV5uVcnTpVYzd/7rsCLLA
	fb/IsulppC1SuQdl/eZRLLwPeFpbt5L1qw0pE6HR+ZjXXYLbHm5j2T14roXWaMFOSihAX9rk13F
	mjybnvrHEGBbQbITfKc9CSzEm954UxmJ18NKOmryCGBKjCP3ZaRPo0XRfcPTNBMtQny66HoxCd8
	UMfnYY7lilr2ioUq39JmJPMjXnr4LlU2tJGV/dqSnbBnfqCkNaoM+9bSOQ6neAKHGAvOpYw0YsT
	TwNpcMBLLwHoRxohzoXMLKrd8F+/hzemYoMSuqAUMc4Tg=
X-Received: by 2002:a17:903:1d2:b0:2b0:663f:6b53 with SMTP id d9443c01a7336-2ba7908bfb1mr288266195ad.13.1778578369221;
        Tue, 12 May 2026 02:32:49 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1ebe0e8sm137692965ad.76.2026.05.12.02.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 02:32:47 -0700 (PDT)
Message-ID: <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com>
Date: Tue, 12 May 2026 17:32:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com>
 <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F4E140007
X-Rspamd-Server: rspam04
X-Stat-Signature: mzs97bdirni5d9x7r7gj7rrbdqoffne9
X-HE-Tag: 1778578370-455222
X-HE-Meta: U2FsdGVkX1/iowgA2oR9ZdKMV1cr+FW26ECz/bqWOypBh2CJ3C4ovmEJ75VigOnctYZwaZt/O6bIvR2htek4GN/i29H41CafIH1J4c6vYSI92TIgj+YAgvz5Vv3kOG7fX6b5hFZXj+nyuN4jz2KrJFH9WQc0T9guwfoUt+8OJVc/ac2tKDAlh0ES+9ZcSzuSyZrVGuif88jP7RAWnWg+n7KDnG/Bvi76LIecq7Xu3BBtpuS74oKv3rGd6pIcrf+yS1t7F3q42ZYF5Nlg18vstQFetypJ4foCiC3B4NfaJNBfisVTT0JwlaOWY5twZtnIYzyOcyKnbLBEpy4T18jFD9SrD91r7r4Jw2bQR5hG0ubTuwtWCAeM09W28Et6FkLxWZ9ccpie61U9ikjxGMgreDJmM/BMF2RYlpImI7fL3hawf6JvoiUkqNfOW1EqzNkXS59AA304n89KTiWxa9Aq77zU1ZnWVBZOi65mOY8mQxGxnF+NT2CkAkIiT1ayB85pTOMbaS7xxY+SVTXOfQi3nctHL2b+ZczxOa9sAm395yCq9egfTLeQBNowHTVzj3Js8Wn/rhtyvsoJxRaOVVa8hlVpmKvRzxB4kFjynYBr6Vs7P3M8NbZ+hI27Z1fn2rU7I6bANex/XNnlKyAvlr6zannroRo75h5aQjjfosTf31fobyvI9fo4mY55xiEQm6u9UKFzAwEvtfrmkqSuvk4ql+Wthu7NiN0R7U40C+9G/vxWCBqEckAS7QfPS/qF8KbwnTkDycMekgbCNIxoZ0nS3h53rXBih+AuBo7H3T2euWjbc0V0yjb/BcmodBo44wU5qvLRNLIgoeJ2GxoWvGqHPLg0O09CgTq1eoeUfWFHD1fp0duor4qlh7UkTGWpWtN9B6+zK6l5T+k4WSvJ9I51zs9VIiz0nTHcikKkiLrGvePS02cM0Lbpu3Ev1Fmzv7vXiM3N82u+fFXMhv/kcFd
 xwlc5EYs
 1aEMIIJIUovhX5tBER1PqKt+J8Jo709fXfDXs8Y6thva6OYclBu7uxFEhksjqqVfa2d6LMLYnzIIKvQYVyzpDusCg1hx7H7KRISYA8WjYd+gxUgXpj1vbOwboH4XKimr+n9Sm0aE18nq1kiy20yi69zitXIKc3nQs7jhmE4hj1xdU1OR9CF4AT9K9UAzDI87euqbhReYMVrE0OijQmQgt+4bIipZGB4w+42xuVZfTcm9pOoK/ovDx5pJ41Ve01okbZHW7KxaA/eCrDYlC9O4Mgp5H7NCZ8iGWGGuGEOa4nJ5lvKJwSK1dxsorvlmHE25nrcKBsLY7QJFVQezxIjWJzXZlm6VaiXmu4I3/vHBle4MekNT4vaCKWEd9mHqodxPj3GcHtGY+B92e+PGwiGFv4HXIfGMqyTzDeFlSLwavdErlPCsicNbfNZmsgoptCCPycXJMXk2NTrKZzMgAhWv7mb+EWGmG2LD//lZayHuqvSDgNL3PuoTsC0RAQiW0OY3lL5w1HcbX5TdEaAS4zaylwCo7bgzGfVeshIX1ao606UzzXcDEFHJjv/QnzyFmPjnSFFmnIn7O9vipBU0jBtqDbjQFLMkShIZWdtSAfkQkPNA0bDxjqQp/FVpoUXcpEJFduSo2/Lg0PoPhy/w/T14PP9FUWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/12 03:57, Yosry Ahmed wrote:
> On Mon, May 11, 2026 at 12:49 PM Nhat Pham <nphamcs@gmail.com> wrote:
>>
>> On Mon, May 11, 2026 at 3:52 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>
>>> From: Hao Jia <jiahao1@lixiang.com>
>>>
>>> Zswap currently writes back pages to backing swap devices reactively,
>>> triggered either by memory pressure via the shrinker or by the pool
>>> reaching its size limit. This reactive approach offers no precise
>>> control over when writeback happens, which can disturb latency-sensitive
>>> workloads, and it cannot direct writeback at a specific memory cgroup.
>>> However, there are scenarios where users might want to proactively
>>> write back cold pages from zswap to the backing swap device, for
>>> example, to free up memory for other applications or to prepare for
>>> upcoming memory-intensive workloads.
>>>
>>> Therefore, implement a proactive writeback mechanism for zswap by
>>> adding a new cgroup interface file memory.zswap.proactive_writeback
>>> within the memory controller.
>>

Thanks Nhat, Yosry — let me address both comments together.

>>
>> We already have memory.reclaim, no? Would that not work to create
>> headroom generally for your use case? Is there a reason why we are
>> treating zswap memory as special here?
> 

Apologies for the lack of detailed explanation in the patch description, 
which led to the confusion.

While we are already utilizing memory.reclaim, it does not fully address 
our requirements.

Our deployment runs a userspace proactive reclaimer that drives 
memory.reclaim based on the system's runtime state (memory/CPU/IO 
pressure, refault rate, ...) and workload-specific
policy. That first stage compresses cold anon pages into zswap. Entries 
that then remain in zswap past a policy-defined age threshold are 
considered "twice cold", and the reclaimer wants
to write them back to the backing swap device at a moment of its own 
choosing, to further reclaim the DRAM still held by the compressed data.

This is the "second-level offloading" pattern described in Meta's TMO 
paper [1]. zswap proactive writeback is what this series introduces to 
address that second-level offloading stage.

[1] https://www.pdl.cmu.edu/ftp/NVM/tmo_asplos22.pdf


> +1, why do we need to specifically proactively reclaim the compressed memory?
> 
> Also, if we do need to minimize the compressed memory and force higher
> writeback rates, we can do so with memory.zswap.max, right?

Here are a few reasons why memory.zswap.max is not enough:

1. Writing memory.zswap.max itself does not trigger any writeback 
immediately. For a memcg that has reached steady state (on which the 
userspace reclaimer is no longer invoking
memory.reclaim), after enough time has passed, the reclaimer has no good 
way to trigger proactive writeback for second-level offloading by 
lowering memory.zswap.max, because in steady
state nothing drives the zswap_store() -> shrink_memcg() path. The 
userspace reclaimer still has no control over when proactive writeback 
happens.

2. memory.zswap.max currently triggers zswap writeback via zswap_store() 
-> shrink_memcg(), and each over-limit event can write back at most 
NR_NODES entries. If zswap residency is far
above memory.zswap.max, converging to the target size requires at least 
O(over-limit pages / NR_NODES) zswap_store() events, with no batching — 
proactive writeback therefore has
significant latency.

3. memory.zswap.max is a stateful interface. If the userspace reclaimer 
crashes for any reason mid-operation, it may leave memory.zswap.max at 
some set value, putting the application in a
  persistently throttled bad state.

4. Once the userspace reclaimer has lowered memory.zswap.max, if the 
workload is rapidly expanding and triggers memory reclaim via 
memory.high / kswapd / etc., the actual amount written
back can exceed what was intended.

Thanks,
Hao

