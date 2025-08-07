Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4E4C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8798E0006; Thu,  7 Aug 2025 06:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288B58E0001; Thu,  7 Aug 2025 06:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170FC8E0006; Thu,  7 Aug 2025 06:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3F728E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:42:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB08282396
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:42:35 +0000 (UTC)
X-FDA: 83749622670.23.1387801
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf26.hostedemail.com (Postfix) with ESMTP id A473714000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:42:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=XuYOyLEo;
	spf=pass (imf26.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754563354; a=rsa-sha256;
	cv=none;
	b=tEO3+yOn/LNSlkFHo1xWLPTm0sY5F6n6sO5pm4VtxuAGdKQrfOXsclTYxQsP5I+vZ0MSEt
	cDpi+I27A3DXBZRFghldz6ZCmAUU6B4d2VL1e9JD71aJbjABnJ78SqbX2nGdm46Sy4edpH
	AEXyxuJm7v0sI/jtpSkLoNBGUjjTJmA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=XuYOyLEo;
	spf=pass (imf26.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754563354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/+/mrODyNw9MXZjsQrkLISHSqDimQvNJ/N4aXmdAMc=;
	b=zR0gPNPfZc6R8yqOq4JuG1ROB22jR2B3sknJPsLOawT0Zqh93KoEAIND9zfNfMBXYyP99G
	zJW1vZFflVXaaeBE/oI9zuLLrVTQqqmDxOPVmuBWGo6FrhZ/9SFHNeKZsLmhhVwlVCRUNu
	/vJsnr5XXL8vJfypF9bhmtnFWpeC6pE=
DKIM-Signature: a=rsa-sha256; t=1754563352; x=1755168152; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=t/+/mrODyNw9MXZjsQrkLISHSqDimQvNJ/N4aXmdAMc=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=XuYOyLEof/yR5Zigu2Yo4wxAWely2P7euLKqPrM8XmzwNIIvYr/gXj/bEhITTxfUjJq20CDRtCBQiGhkrskF1qyy2KHxWL++0IcvEA/n5GvW3IIBGGfhIoR4pddJnbqLOZ/jfPZD23Jq2QVGlxDKrgZdXCNZBe9B9fTXLGpU6nQ=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508071242243634;
        Thu, 07 Aug 2025 12:42:24 +0200
Message-ID: <5e32aded-bcff-40d2-aef1-20a1cf6f4f8e@cdn77.com>
Date: Thu, 7 Aug 2025 12:42:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A00210C.689482D2.0077,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A473714000A
X-Stat-Signature: 3ff85krgibfztgiywg86jcrqfhd3bn4j
X-HE-Tag: 1754563353-333438
X-HE-Meta: U2FsdGVkX1/FHrJSHVnyaZwmkv1xpltCeC1UstKJlY+ynCPAo4B1jRCfsOFFMJtx7LSPaTPMhkb8BTWto8Q24N0EEErMs9ej3nXyOE/qaNABGBeXBw/Gs8wdwo9nIaY918O4+OocprjIqcC8leRgKcoALERuwlk9OSqa6i8fBzXGbbJDvNIQ01M6m/yBq+DncphGGZA5bc+jrDai9LNG86AjwgpdLFjb7RUxiSM7oUTJRR3rbPFljmtvdJFs15QKY2u7epcGhJCkZYgvEA3aSu55Qao8JdCMca777lyWPcTrPq9NW1rO8x4YnPJtsjTs8ET5HQd8JbgtjfvNdB1AWpbBqR5Ns7u6xx4bYzV59QXkbxy5gsdlL/YanSUCmekH9A9WVs9wZ5/ZzjM4+bqxZgTCeg0or9Td5WDixCSWpVLiGAOwmtO8cwIf8MQ2ZyhUzKNO1aWVKSYb3zmBElX2TsGWFfw3qRqZ47f+o5I3p+qZQ3MtGOPTa6uaDxQ+tSWb82uHAxOwPvD/1R+XJP81SuX3CJF+mPfRN7YJkj87UDNYKrhhI+OhW3QTx3DILvsGLX+UPIVY7WBYdFdQMAKQVR835+Kjf4QKPCUG71ayrFxxeSfykD24PNTrwwGrmjlt/mYiEgC8ugfoaQkeuPsmk+kEFdaVJg9I4iaI8zRcr//VV77KF4nlFDLlLLB77Y8ebTbITDg4IxjoX3ZRFFoU4jnA2rRqC0v+0vW6cwE9eeGBt37ghVnRXsENv+hrnr0BkQ99GI27h2DTaYbq4fW1QRWwqAHb5dwita2FjYwJ2aOB0uBlX5NVjCEW870s1hUSWZL1jzJFqk/9XKo24tsdmoojiAJVz2gT6JpcpgVmT0YmontYM1wRGlj55FkPqqDm9WMvnXE+OHGu06BTB+A3lXlt3X5CkWuRdDJx8LTD0GCKgStBSCj8Q5KLe2UXPOr3O2nUnJVEMSIEIDhrYMX
 2Ua9pAHn
 Uxjwk9xjjk0Zp5esjslDWIdg3sDY3lcrIi9dA6xhSr4eyWnpHjASdTl0l2Hz2leA48MzHFD/VgjjWHQMKl0fiwNSZxgtkLlB/17vQWqnVJgEgf7lykyrpGoubNmllw7/zNfrRRHVEfVA5yDhFGBVjaNXcjCLVHLOzmZGO0pHorQCq/MWutt/IJc6M7QrSO1juNS1VavstC7SIhH+Q0STeBELJ9ljTe03WFmOjYdcVx+ZnPUcCODI4LzH/+j0H8Bm/Za+jQAUHYILjigk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/25 1:02 AM, Shakeel Butt wrote:
> On Tue, Aug 05, 2025 at 08:44:29AM +0200, Daniel Sedlak wrote:
>> This patch is a result of our long-standing debug sessions, where it all
>> started as "networking is slow", and TCP network throughput suddenly
>> dropped from tens of Gbps to few Mbps, and we could not see anything in
>> the kernel log or netstat counters.
>>
>> Currently, we have two memory pressure counters for TCP sockets [1],
>> which we manipulate only when the memory pressure is signalled through
>> the proto struct [2]. However, the memory pressure can also be signaled
>> through the cgroup memory subsystem, which we do not reflect in the
>> netstat counters. In the end, when the cgroup memory subsystem signals
>> that it is under pressure, we silently reduce the advertised TCP window
>> with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
>> throughput reduction.
>>
>> Keep in mind that when the cgroup memory subsystem signals the socket
>> memory pressure, it affects all sockets used in that cgroup.
>>
>> This patch exposes a new file for each cgroup in sysfs which signals
>> the cgroup socket memory pressure. The file is accessible in
>> the following path.
>>
>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> 
> let's keep the name concise. Maybe memory.net.pressure?
> 

Sure, I can rename it for v5.

Thanks!
Daniel


