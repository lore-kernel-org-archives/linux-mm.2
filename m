Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAD9E63F2B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 07:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7C56B0005; Tue, 17 Feb 2026 02:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6557E6B0089; Tue, 17 Feb 2026 02:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536AA6B008A; Tue, 17 Feb 2026 02:48:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB726B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 02:48:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 971B9BE2CE
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:48:48 +0000 (UTC)
X-FDA: 84453171936.01.DCBA822
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf15.hostedemail.com (Postfix) with ESMTP id AF506A0008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:48:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mFS1Ors/";
	spf=pass (imf15.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771314526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnMNqYmQNZzpA0ckivNAm3K36XWptoI0fu8qkH7ny3w=;
	b=nJWcMMyn6d07RwWvGPHx0gU5SQgfgI4NmpUnVyxJ3Q7s/33CeHq+1+1UaxsS+NzZr7WKm0
	MApO5pg480g1Tg1If+qiPErzI4luX1oUW+K5qGShBlgF4m2LvJRlgFQR6yOgB0Hs3ym+Q1
	TTeIkKjG7+0zxNGcLhuXRmEYWYVotcA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mFS1Ors/";
	spf=pass (imf15.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771314526; a=rsa-sha256;
	cv=none;
	b=WySoEMaDbeezV/LSp3nQ0PUjlnYHJykrngd7RlOzF+iYIqAsVdH5nD6rt+VAlEpW0vhM4t
	opbSH6H87YEvjH4Mgp4XTwqlQKE6tb1Jce0ocbFMjtrTQ0sYK7Ws71onGtfB0tMHVXQGO5
	G2O6QeUqU7exX/QkTe7smg2WkhhaXzI=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-1248d27f293so8827079c88.0
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 23:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771314525; x=1771919325; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FnMNqYmQNZzpA0ckivNAm3K36XWptoI0fu8qkH7ny3w=;
        b=mFS1Ors/aI20nk9TCXqq9Rou1thheaL1RqD9ONJ7WP7r2CRSsSO0HHejeHbiCT5V1o
         JyQms/mwbfPwAwTAlHbvX/rGYRFMbOBePeasig9qP7Meu2/GmfMO4J2kYeQxftXs1JA6
         udGYH3Ht0TLaONNPiIchsYIym1LIw8MwIXCGmEY3TU5aoz/cHQbkWh0XPzLz84F/4E2L
         rNSWlX142bgFSl5j0/FVJunpWpoW3YMwFuJElUFC/ZPGmIYnI1GvKocshAbNmwcgyQSg
         kTCRjrvaDzGcRTYr8NyNqivGC4ry3zWKxHM5rLU4RNG65JdqFYHmZVCT5XkBcklTe5ah
         FBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771314525; x=1771919325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FnMNqYmQNZzpA0ckivNAm3K36XWptoI0fu8qkH7ny3w=;
        b=lPa++c0sq2ZvEzjMssg/1IvMbICOClZq7LOwXSlepOQzgI/FZ3asN4LM45Kf40DfAE
         7V5TkaDzo6y3CjroIrgP3HTT6xDEdlY2GMLSONhJsG8CunSIz4I3hCODD9ms1F9JtbnP
         aI4nkqmTlUH7Jz1wGY3or/efp/o1o1EX8A7D969C0BEAnoLLnqyvradqSxA1DcdCPlfo
         Mnnnlnl/gm+J2p0krsWKeUeYrkg+rdVSgN/qNsRjbQGtA/C2nonBs5VcaJ/d6iUC92TW
         W+QylZaSFiqfHAywIGmVUTtVew+hmTN/1iVLjMOq0+SQ/L2Ur04pHRpt45r3/FtrZgpY
         6NvA==
X-Gm-Message-State: AOJu0YzccGeib99Sr2Tnj52VunlaXllXnx4xu8/zJSj9UNsVvkgW7Lrq
	XfVSkdr00d1zc8ejEoAfPYMo1RkRj4yYUtkvYnKH589VQKSNFfAGE2f/
X-Gm-Gg: AZuq6aI+l77N6esB+20jBIFFGvBzZfto0orKy4R6WuwEjDJpXjDXmD/uMwLdE3X5IJw
	h/YcFRwn+nPOOI1MxxwDnys7HFJi/49cYZiFs1ZSFcBYerjbtvs5Ce8SMLedLoNP2JBdJ6VW5Qr
	3UTGrMuxo4Wv582IoKuOt2eFILhUSH5tums8kGkgYMrb+btRLwjkJHl0N5yc0UnZU6L5ZZKpT6M
	6TUkquIvVX6x2/qZEsGcDG68W8bzzmKNrX3jgXbyVsA3JwCqZp62PdtOEXLytqRjpKCGlYIFxGI
	j161EXhpfAkMiBpUDcgkM6fgR3DUwO3KEOZ3BNgMAhUUqLAjZn8ha/gxY39EWj1ffAulnC1py3A
	qzAOP9qT9QUdPjkl0vZOCya4ossl2biQmp2AbeUxyyOxYqkOq2gbZfdjW0lGaCMRasD7VvSPdfz
	FzqVnC4opXPe6/YdrN1/Z8/j3WrLuQan4v
X-Received: by 2002:a05:7022:f102:b0:11d:e25a:d9ca with SMTP id a92af1059eb24-1273ae69c9bmr5761013c88.26.1771314525054;
        Mon, 16 Feb 2026 23:48:45 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12742cada1csm13124794c88.9.2026.02.16.23.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 23:48:44 -0800 (PST)
Message-ID: <9ae80317-f005-474c-9da1-95462138f3c6@gmail.com>
Date: Mon, 16 Feb 2026 23:48:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com> <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com> <aZLUm95Y-dKkdBWI@tiehlicka>
 <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com> <aZOHIQj3pJ-9dW_0@tiehlicka>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <aZOHIQj3pJ-9dW_0@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mi8pxaho4z8xmiicyci7jgz1qpjxhrxd
X-Rspamd-Queue-Id: AF506A0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771314526-34352
X-HE-Meta: U2FsdGVkX186zXMT56aNTcHD70h9yLAU2WDM73OHE+epWI6CKTVRhByyBj+msYXzfJ1ixWBtgiLIEJKBwjz9I/riSMaaB+ft+hjZcygLCXu5LzJsl4NppUSu3M/cIO9LadUvhLOFdggPhUHucZEovBFEWGgDjDPMfz+vJAcBRDpgslJ3AqaBI6EXDz0Y3GRpQlXz6XXp9xtAgtUaQJy9iQPYrpSeaslC8CnA5KMTTYFlYQKhlPmvTKH7e6svnx6vsZSz6WAPBpz+AoZSbcjZGotFDlgOPZ/DZWhNgeXmhK4TlmtjGH/QV5gKXVtcuwh9qwKQpYbvFn535lcPTAGdQaNB9+GjJMZdLQLkGJ9EkunBkk+o+R8FtVKKGuaESA/NK08Vrg311JVgdieiNvPj8ZH6wi0oufQuygLRQZ2Q49t1EY/TGcDDFnNNs77N7WQPDffTNxqMbRXwewYg+zLgcPb+OfrTDJkWKvuRr7zbUi1D7REnxG790ypUO1N68FuCUSs92gTzGkXP3Hh91nVY+YVnd9LXyAAnz4Y52nYHluVKKnoblvaxfeTOm4zy5jubfEb2m/UIq9GIH28jOE3YdcwaJN6d67yXTByylWOVTc54wAVkqGJijJ2HBog1CxXXNz6Y13MgC1NK5RVm5Cw36GYajecT+A4Xb2fDbT5Y1Yf2qx7+DjGl28GDhjKK9GhNbQVDpezqqwroeolXEQgJvRStda4fQLNpnKLf2fIzveOCAtD7xhPs8X7RE3uV/rzY98ofKzLdhSKfpcb0PNxz7OxpxGeMEHJ17AWezqlnFbrcdVJ3DvC6MBVJT/X4R90mCJUo8zbijAFAm+Ta2xMVRnmy3HwG2XOnnc1J6E4HZRTpV/28FrD76JR0ZnB/EQz+FpLzWJUHI6H1G46ns+k9EEK22hNKAUYZZankgRPyHfj40uaxYPvTUiDysl294RkqqEl2TdkqoCRCXxNqPUa
 pKs3oaul
 AL5c+36mnd4FNYlPJvPGFMMdtoSyqo2Xjfo+BgaMXaKdc2RusRaZcOqmIPCtQTMzwX6x187XPrvmr7Kpcl8RcMR9ZUsUDJ9S+8AyZwmvW9ab9r7aX7W8dlqNs916/YwMeAWwCfJX3kv+tGJh01Z/j2AJd14H/Vi2in1XncEhOU+zoxWa7G2uq6rbeoeoZ6ugLPxGTzGvF7+7UjbyqbBXB8oJSg5YqYcEGf1ejTqh7LsJ8SI2dtzvqKXqQ9ps0SWJHa4hrXuWfU6MFTf9yxH9Tm3ty3Ose0xmuDv3cFbzWf0gFmKwvkBllKObtJg2ZUVp522KK6bbPIlvkHbiRI8HhUTeN5Zoi40awhKzQ1hDJyYAvnenWkE5fP81F9cpQLjcsWJm20XnwBWNLFjPu3x37wiqtSZV90xZBpLxWjZEoX/BF5sW639PavG1NVzt5u0AiIiuvKpmjaRiOlvfVzX4QqreRb1NiKFZvsJzOMKiG6vB0Huyw+/L6cqJdsLw1g1eQkCgAi3zixp6PKNu2Jl5UvbtTc251vyutGJcjAVWZ3EHc74Wc9zs+NEJnX6shMNvHXsHsjartZ0YLbY0tM8jPN7y2Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 1:07 PM, Michal Hocko wrote:
> On Mon 16-02-26 09:50:26, JP Kobryn (Meta) wrote:
>> On 2/16/26 12:26 AM, Michal Hocko wrote:
>>> On Thu 12-02-26 13:22:56, JP Kobryn wrote:
>>>> On 2/11/26 11:29 PM, Michal Hocko wrote:
>>>>> On Wed 11-02-26 20:51:08, JP Kobryn wrote:
>>>>>> It would be useful to see a breakdown of allocations to understand which
>>>>>> NUMA policies are driving them. For example, when investigating memory
>>>>>> pressure, having policy-specific counts could show that allocations were
>>>>>> bound to the affected node (via MPOL_BIND).
>>>>>>
>>>>>> Add per-policy page allocation counters as new node stat items. These
>>>>>> counters can provide correlation between a mempolicy and pressure on a
>>>>>> given node.
>>>>>
>>>>> Could you be more specific how exactly do you plan to use those
>>>>> counters?
>>>>
>>>> Yes. Patch 2 allows us to find which nodes are undergoing reclaim. Once
>>>> we identify the affected node(s), the new mpol counters (this patch)
>>>> allow us correlate the pressure to the mempolicy driving it.
>>>
>>> I would appreciate somehow more specificity. You are adding counters
>>> that are not really easy to drop once they are in. Sure we have
>>> precedence of dropping some counters in the past so this is not as hard
>>> as usual userspace APIs but still...
>>>
>>> How exactly do you tolerate mempolicy allocations to specific nodes?
>>> While MPOL_MBIND is quite straightforward others are less so.
>>
>> The design does account for this regardless of the policy. In the call
>> to __mod_node_page_state(), I'm using page_pgdat(page) so the stat is
>> attributed to the node where the page actually landed.
> 
> That much is clear[*]. The consumer side of things is not really clear to
> me. How do you know which policy or part of the nodemask of that policy
> is the source of the memory pressure on a particular node? In other
> words how much is the data actually useful except for a single node
> mempolicy (i.e. MBIND).

Other than the bind policy, having the interleave (and weighted) stats
would allow us to see the effective distribution of the policy. Pressure
could be linked to a user configured weight scheme. I would think it
could also help with confirming expected distributions.

You brought up the node mask so with the preferred policy, I think this
is a good one for using the counters as well. Once we're at the point
where we know the node(s) under pressure and then see significant
preferred allocs accounted for, we could search the numa_maps that have
"prefer:<node>" to find the tasks targeting the affected nodes.

I mentioned this on another thread in this series but I'll include here
as well and expand some more. For any given policy, the workflow would
be:
1) Pressure/OOMs reported while system-wide memory is free.
2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
down node(s) under pressure. They become available in
/sys/devices/system/node/nodeN/vmstat.
3) Check per-policy allocation counters (this patch) on that node to
find what policy was driving it. Same readout at nodeN/vmstat.
4) Now use /proc/*/numa_maps to identify tasks using the policy.

> 
> [*] btw. I believe you misaccount MPOL_LOCAL because you attribute the
> target node even when the allocation is from a remote node from the
> "local" POV.

It's a good point. The accounting as a result of fallback cases
shouldn't detract from an investigation though. We're interested in the
node(s) under pressure so the relatively few fallback allocations would
land on nodes that are not under pressure and could be viewed as
acceptable noise.

