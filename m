Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1C3E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068196B0089; Fri, 19 Dec 2025 23:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015156B008A; Fri, 19 Dec 2025 23:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83F06B0092; Fri, 19 Dec 2025 23:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D99856B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:42:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82EAC8ABDE
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:42:01 +0000 (UTC)
X-FDA: 84238602042.12.F3FF67A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id B12E31A0015
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:41:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pemPTR8e;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766205719; a=rsa-sha256;
	cv=none;
	b=ap708izF5s4ZO5QExXwogvd9YmiXsScJyMaW8GWN7JReTmCIxYLfBbJ+neHZn4LlxWq8wI
	emuyliAgRk9kz8gxnG5CW2Qy9ekxH45Biv9jV/Epml4AdehEz2hDIbzfZz2CjaZmSsbuzR
	2pMUxt/Vs+8W8UPBCvutmSiaNG74NQU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pemPTR8e;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766205719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7Snbm0Eo1c02EpdvweabpFtfhZ7BzYRezRTB+jU0tU=;
	b=wReWepCqaCJmHlhcqM0r/byg06VW/FXQ9R6c31yl5vwJwrC5zz6HZ7CgvBdeGSmHl745GR
	Sq8dCS85IZuEzKl8Bo3XymBAtupcveRYXQPdJCGv5CsvFqWLi8v9PdLi8gHn2PsmrAxa56
	c6QLPuy6EpdpNM0KvMWzLE3+yF4vk98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766205717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S7Snbm0Eo1c02EpdvweabpFtfhZ7BzYRezRTB+jU0tU=;
	b=pemPTR8ev8HpuCLVTeOWEkRrVdoyuxKuCQGz0yU7B0TB8v58cGyViXXAAhEskmIXYycUiy
	Svz88HANmMEw1m33XBEX538UgrPaONSqyZS+zyc7j97jx/QGKfHWaMjY8LIWB1+HLGbmR+
	NWKRdWZzV3lCLByxaWlBylwGuemNA1A=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
  inwardvessel@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 shakeel.butt@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
 andrii@kernel.org, martin.lau@kernel.org, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access
 memory events
In-Reply-To: <8f23848b8ac657b4b4a2da04da242039c59e9ad9826a8d5fa0f5aee55acfecc9@mail.kernel.org>
	(bot's message of "Sat, 20 Dec 2025 04:29:44 +0000 (UTC)")
References: <20251220041250.372179-6-roman.gushchin@linux.dev>
	<8f23848b8ac657b4b4a2da04da242039c59e9ad9826a8d5fa0f5aee55acfecc9@mail.kernel.org>
Date: Fri, 19 Dec 2025 20:41:46 -0800
Message-ID: <87a4zdepdh.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B12E31A0015
X-Rspamd-Server: rspam04
X-Stat-Signature: wr8w73be7b5go361r4ewoampa8h4ckhs
X-HE-Tag: 1766205719-917643
X-HE-Meta: U2FsdGVkX1/RGqSzWvXMcBKj9J8lzX4v1QVoPJ7SRqyQ4vZMCnEwjLBbL6Gow8dnRA60Sm+PuPlA6jcCvT8Us4eWRWxDWsbMdRaywrk3P5UkIR55sCog1Jd5cKFFNnzdQD69wmSFbR6CJWERm1TWWlVcSJX0PinD695PxaeILzfC/e1Ztz/ZAlYkWZJirAKW0TLeNs5pKW0++ZPmz1Y9z6H0Vc4JQdP38DxlanfhE3bCY8eDZp1rwEOC1TblICA7kr3MX/QTsNXnApWokug8foqKjVTy0auyoSxakvaq6bNi6/ULY+3U0QLcQ32qUJ9IziSW3q6OXv1wJyxbGoK71xt10qY4h9o97lnizqFV89MNt0rCr9IRpLwibNEMHzzqorYOTW0vNdej6RVaQz8kVBK8Ce+tuHtzvhXR9gbdgrbkqFUUY4dcKuWRBIUdilhTHG7ewXtgob41/s5GtwPLYBKdg3r6s/sAc9QApa809Z+8fayEQANpTOxc85Ing4pkR8JccNElscLKkJZEa2KtHp1X7NTQ9xUB8Hy75fQ/fTuIbMSaO2rIt+pdwcuqhGRlPxmYVTgM+z0V44Hewy/8NPYSzFmd6TlGsDysvcH5q0OQKEkSS5wkjTU0uOhx2I+Wan2QQ5gdw5b+04ngpkkfIYTz5BV6G4G6jok0McQB1Puf998bpesDJ4NuN6DIjf49KRRIJ0QuukV+wKTICWkYxEqWVS4oblwLBXAGQFCmzr+pmEtIKtLfvuF2YadpUwi/bg4XxpYJOiuOClxTqzbJd5uo5CBNi7EpXiAPKSSvrr2UQj5eo46grKxsupzGZy1rcVDfCU8VucUzdCKMvoAE7xuZB3f3g/MD/MdQZVXMU/Oz5/P5SC3f9zbTnZfMhImnkwsqjUbFW0Ph3xPd4Cf+ktyWFhg61zPoXzHn04kbf7CbJ/DB0w6vrC6YIzPO+nzUXWF/CaNIkeKnFWj0Dt6
 YciIFo83
 OTv3qw6xZEmQmhr0cKRhF5nW1etPQ6E8BZ7SnPf+mJ0NmNFPk2bDfx18Ss0A6+RU5GL0hNYBsjuQNd/KfHGU+dxgXd8PMo9f32DW4urUq8hByvPX5Q35t8459+6MyPf5IT/ID4VGTGCLEwQE/XHT8YImgvcStk1aNcpPexMoN2iettjHWZxiSE1HJ2wb8T5L16DHEC3npNtr493G/40UmsHC4itqAAg5YVjZq/Lu1vd8km0Y07ZDCQI1HTQ4qDPAtExC3wURglF+OMrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index d84fe6f3ed43..858eb43766ce 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>>  	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>>  }
>>
>> +/**
>> + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
>> + * @memcg: memory cgroup
>> + * @event: memory event id
>> + *
>> + * Returns current memory event count.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
>> +						enum memcg_memory_event event)
>> +{
>> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
>> +		return (unsigned long)-1;
>
> Should this also check for negative values?  The enum type is typically
> signed, so a BPF program passing a negative event value would pass this
> check but cause an out-of-bounds read from memcg->memory_events[].
>
> The similar bpf_mem_cgroup_page_state() in this same file uses:
>
>     if (idx < 0 || idx >= MEMCG_NR_STAT)
>
> which checks both bounds.  Could the check here be changed to:
>
>     if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)
>
> to match that pattern?

No, the bpf verifier enforces event > 0.
It's a false positive.

