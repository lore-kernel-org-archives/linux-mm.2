Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56A0C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF076B009B; Sun,  6 Sep 2026 23:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7096B009D; Sun,  6 Sep 2026 23:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3C26B009E; Sun,  6 Sep 2026 23:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 908E36B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:18:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D4B74061C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:18:04 +0000 (UTC)
X-FDA: 85185507288.22.B6B21CD
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3099120008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:18:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XoH3rQxV;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788751082;
	b=jeH917TWY8nwtdRUlrG90hjSx4c37PjHohbKVQqGoDSQciA6vdt3hxiJgeN7LUuFbCPSRC
	Umcbgm7O9K79EvEt9H9es9pqLpD7XCIKwNCLP/a3JRQma+nr3ow1zSvIQSar98aLQjyBOp
	9xg81KuSc8dmDphG5c0Xl4ukE+Yqk7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788751082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bSdYV4jlw/OSsrz0QrP+bxNxkbonIdmhAnr4R/6jvM=;
	b=soIYUNc70FnsxBBNw5EVXuBdLVwWvXz6YP4m6zIK0bBiShILfMpwpVR22m3yYDPVnEHNYN
	5bFCH9bXNGZ8nK0LJQQJz3iRVHZqK9Z6FlL9inyFL+ARZ+cyDdnHyUJHcCehR6gg/Jo4wx
	czxempQUK/250yGlVAQQsN1Nu/fKEQY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XoH3rQxV;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4NwIip7/KPKLo7TJlw7Cq9K17+JHbn+jGgJ7eRNJyU0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788751080; v=1; x=1789355880;
 b=XoH3rQxVvtuIH7YZpNDAHgio5/F4WQsDsrj8RjgmAC10i7CcIlUmwP8bUuqy+LE3zPIcbj04
 IYLPnM5exsQpB6aWrbShgAicYDAcFxlT0NrwXT9CkxeMUCHSBGE+86fLTrj/ZsT+fVqzdHni+bQ
 1eKKrZXMfRktIHDLCqB1UHQs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 557dbd025e9566f7;
	Mon, 07 Sep 2026 03:17:50 +0000
X-Mizu-Trace-ID: 557dbd025e9566f7
X-Migadu-Flow: FLOW_OUT
Message-ID: <4525fdf8-def6-4f24-abe8-1948eab54d6e@linux.dev>
Date: Mon, 7 Sep 2026 11:17:43 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH bpf-next v7 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn
 <inwardvessel@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Ihor Solodrai
 <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788516769.git.zhuhui@kylinos.cn>
 <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
 <20260904110308.4473cde499e91aab14dbd5fc@linux-foundation.org>
 <DL7CEX9EX781.23V26M3600JEI@gmail.com> <apxB5tyglnSbqmEu@linux.dev>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <apxB5tyglnSbqmEu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3099120008
X-Stat-Signature: 95f6qygr5x74iucttx5e64n9hdkibshp
X-HE-Tag: 1788751081-917144
X-HE-Meta: U2FsdGVkX18cduFlkHrO5vvCB1QMl+UGTn1qektWA+wzukBDkmKWmhFie/Cov9xWvil5ij0si13UwdXWE8PA4h/sw0xiNi446M1iTflyy79DkDe7ChIWGdh/QreW496nwnpCAGNuPEZ+oMt1pphxKxVHVGae7MiYXSNKsGG4BK6vUgFKOO1tmj1Z8pwEO48V07SYwULHvdLV5LyxXSFK4jULVgnW80pxRnxvazaHc+JerCtO3caDw5/WUn8wyENKcxZBX8WbrMUzSwFnkGQaxjYCg11ZqIO7ffkrvn6kb/3gfbiUUy2YEMObTumFwfBwvDrJDzjFzSg134dKHxHXoYgfhqjdNABmc0g3XhgfZ1xnGc9QsmKKC/2/nsljn1y10hLhgLnToqdi9E6mG9arUmQRVrW4/2Geb+p5MCEWciWvv8kTZxqbsrKcm4ESlelYp2t36I30KtEKCjn3s+WcPGoWq8IB0SAFA+x1RpcDGWhBa2BAVvcqatJof757CNSitGifY1XrMrXxoAcl98ZbGsJPEEzgvsSROKeqhH136xBhB5UqwAiigXpzGzggBtFyPccWD7nz6OTz4pyMCJ2bq51aP15x5Q+bSe4jix10fgvemLWbMXe1Du6rYhtwzNdiLnSdLV/iTUc/VTtREFHwxc9lLagOpUztpzBP9abYkaZ0HXqOIjc/7Q1dOxAy7MX2NXKBpzoMwjolqiv0RkmtCfxnYNfELuFWdk23Xya8wvtz6KfMI06Al2LNbCRb9dFKC3BXCeAGlhnNWIfFKSqA6BxPfxayQml6A82ZnPgNtkbf7bH7FRfoD3pZYZQrQQMDRNy7Jqe2D+oBLwtmlEGQM26yIPX5XpsM7wnq9CX4mRYMcx2TrFV3N3Ygxt8REAz4pbjvgZatCyghKtQSM8YdHtdIKD2EdG/FO4lz9hfgYkSBCS+kPDtmSU2+Aavz8pt93mmrTKfEsQ8+tavjSOt
 zYHZ8Ado
 uQBC//yghyECB951vu9iZJygIhZYcUmPI0izcbj2zIOdmUyEuS95y3DZknYyk0PzPTsA3ORezoeb+0q1SFEYYTj0d4PdAVL4KHch8jL4zgzAgxQya9FKw9H9ftOZDZR7c1orpl7xti146/uFPLEhxb4BAkReEvk2OheJHz1so1kqNusqQg3M9yI5rrWawnOte7JrDou2qwm6wppV8nzaU77TtSdYpmGtnOXfa+Ieuldb3+0aCM5HVSRTBz7HR9BPTnyd1k/gw4+TSrdNO0XSzzCbjqQTXMQ3DqdH4EV2BxoGEFSxGcWPA1Aq/1HgC0k3pUapf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Sat, Sep 05, 2026 at 01:23:39PM +0200, Kumar Kartikeya Dwivedi wrote:
>> On Fri Sep 4, 2026 at 8:03 PM CEST, Andrew Morton wrote:
>>> On Fri,  4 Sep 2026 18:20:19 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
>>>
>>>> @@ -159,6 +160,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>>>   	mem_cgroup_flush_stats(memcg);
>>>>   }
>>>>
>>>> +/*
>>>> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>>>> + * current->reclaim_state, so a nested call would corrupt the outer
>>>> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
>>>> + * reclaim_state is also checked because it is installed slightly
>>>> + * before PF_MEMALLOC.
>>>> + */
>>>> +static bool bpf_in_reclaim_context(void)
>>>> +{
>>>> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>>>> +}
>>>> +
>>> Would life improve if try_to_free_mem_cgroup_pages() didn't do that?
>>> If try_to_free_mem_cgroup_pages() (or some variant of it) were to
>>> permit nesting?
>>>
>>> 	rs = new_thing(current, &sc.reclaim_state);
>>> 	...
>>> 	set_task_reclaim_state(current, rs);
>>>
>> My understanding is that given the current restrictions on where this kfunc can
>> be called, this is mostly a defensive and shouldn't be firing (?). Given that,
>> we can probably revisit this when such reentrancy is necessary, even though I
>> doubt it would be the case in the future. It will at most be invoked from a wq
>> callback or a kthread, so should be fine.
>>
> If with the current restrictions, this recursion can not happen then let's not
> add this check here. We never want recursion/reentrancy here.

Will remove it in the next version.

Best,
Hui


