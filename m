Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 427BBD2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 20:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A94D6B0089; Tue, 27 Jan 2026 15:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986F16B008A; Tue, 27 Jan 2026 15:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F876B008C; Tue, 27 Jan 2026 15:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7302D6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:47:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 043BD85E48
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:47:33 +0000 (UTC)
X-FDA: 84378929628.02.7AEB234
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E65D20007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:47:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MXrV5wPR;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769546852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p62oMbD2WGIl31iE58AjJBexIFrmv0YyTyX0OQvm33U=;
	b=Wae5nuJZuIJ0kFy9xxPMn3ngHxQfMD3Z3D62xTl8eeQzO3EcTRKwLD3XqP2HcQrKj9NvYo
	JcMF2sJiriAM0mpk7RraMWJ+dVhNV+01LsZS5e+3KO5NkFF4dqSN/jYoQ6mBw62NQ3ErCF
	7YzvRisws3Vh/raTNm8l/Cv9oYdG9q8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MXrV5wPR;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769546852; a=rsa-sha256;
	cv=none;
	b=n5aKMeSEI/c39GmuntpMHLvlJF4hK9m3DEw0EUeqxTIImEgMItQrGzwIVS+ZE3yWJ559Jy
	hMEY3qRPfT6VF/EGNbUApwnU+MiHGQfcBYLq4izrTLZ29vFIauOrqgi/41hOoHxKtnulqI
	zUWx1HT9AYeVo90vEa/A2+WvUFa+kHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769546849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p62oMbD2WGIl31iE58AjJBexIFrmv0YyTyX0OQvm33U=;
	b=MXrV5wPR59IDMmslYF9So3TZUiPFv26eBfOnddXc6nMgRjMhB+pPURPChm0vE2CuMcyCMe
	TivIEtPADaLv6IkiwsRuiagd892Hf21vczCj5R9zqXFJFBfDwlb7Uvj2u7I0qDsgo1EeRD
	oxHDJcrrjld+4Lxv4mpaOFiYGYO71jw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>,  Alexei Starovoitov <ast@kernel.org>,
  Matt Bobrowski <mattbobrowski@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 08/17] mm: introduce bpf_oom_kill_process()
 bpf kfunc
In-Reply-To: <9a2c5f29-b45c-4ff3-a8f4-51d207a82d38@linux.dev> (Martin KaFai
	Lau's message of "Tue, 27 Jan 2026 12:21:03 -0800")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-9-roman.gushchin@linux.dev>
	<9a2c5f29-b45c-4ff3-a8f4-51d207a82d38@linux.dev>
Date: Tue, 27 Jan 2026 20:47:11 +0000
Message-ID: <7ia48qdilr5c.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E65D20007
X-Stat-Signature: jap7m1n3uzdzpza1a5wz6tbqe3w76yn1
X-Rspam-User: 
X-HE-Tag: 1769546851-415191
X-HE-Meta: U2FsdGVkX1++GUska3yClXRI+jr4Lm8YwIRh/2Hoo1X8LB64b6+DtIeu6/l6gVH/QJ5wT7WGUhaYanRrciVV3LQLqtQ5Ick+USFu/VpgBhgj/npL9BEyY00vE097CBsc3piNM5oqQXroOT4/61YU0ykE0+kMObsk3JKZWmlOvSNSCzgkPga7cVF5qgaGY4KuM+LKVb/DmJwbEm2KRoqBsxjDAHo7RS/SdA8+i4AStCfDWw7s2Vz6ybV0MR0Tj2QGd0AEGG6gEZ5PCjmgHyBaZhKddwMbMBkrGmH1/rErxuSHmzdmY/EvEG3k7FRJOqEtkLrEGC4Fwq/ZDeODxda/1q1EOH9EP1AaQlae9XsQoefGP0FzA3WTM+yyF3W+xfRzkRu14L5zneYyRloqZDQpSBnTR+8EI9kZOPm/E4MVzrV9uyX2jzwvklpRHpOZqTNDvkT5QgxEYBO2tHBkDJd8iSfpiZ/J11NE/D141oh4xvGHv06cXhaBMNvNU7/icx2WZTd9ta8YLpD8hQW70VwUU5yIqsVo+vvIRkWVFRgNMXtucDrWC1Z/eNDmH7051XhzwqcOsICu1tpXTBcPC1dbj8MGFSAe+CYrMFLMKenaXO+geJ9Kl7tHJAxzuq6aQs6n/8KSSOuxREJgeXyKFPBtZgJePC/sqM834cXlaeYq9Opga1Pfws59AVAtp/+W9XqITQacw9TAYkzcAA+wDo2zzgiDr01wcggcW3/kxtf4/8Zu3tQoAd1WsWw3dnSCzXZKK+QJ9YXV6lRtgW5eIq6icaPAo2Mw9RIYHw7ye2aN+e4Yc1RnKrR8tIMJvMVPQ3p1ryK3htD6UIP2nXGTOw2quYS4Lrso1r4YrtqxEsyMBzMJ6/GkEJd68r6TgO1thWo8pQjG7BWTzQdvstv8NHwNtAnlqqxnAEFnxN8MZa/beS5Q9eH0MWy5CwhCFMdolOsK2ap7fNmXJPFBPqiuJ6A
 4IMbSu0o
 YJN6uC5RnPh06E5cCgfRgz6HExOfVAp1gF/vDdvKaNXHUMWEkW8nApuifVlxbvS03CIo0a6B+/HDMPXwE8oo5MRqgFZl6dL6u/mDAomXTfbndKIM/xgBGslyoJzM3X8tVBkFTjRLS6ohiLOA+W+U+fH71Ow6b7dLsaH4eYvy993rQUCo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 1/26/26 6:44 PM, Roman Gushchin wrote:
>> +static int bpf_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
>
> The filter callback is registered for BPF_PROG_TYPE_STRUCT_OPS. It is
> checking if a kfunc_id is allowed for other struct_ops progs also,
> e.g. the bpf-tcp-cc struct_ops progs.
>
>
>> +{
>> +	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
>> +	    prog->aux->attach_btf_id != bpf_oom_ops_ids[0])
>> +		return -EACCES;
>
> The 'return -EACCES' should be the cause of the "calling kernel
> function XXX is not allowed" error reported by the CI. Take a look at
> btf_kfunc_is_allowed().
>
> Take a look at bpf_qdisc_kfunc_filter(). I suspect it should be
> something like this, untested:
>
>         if (btf_id_set8_contains(&bpf_oom_kfuncs, kfunc_id) &&
> 	    prog->aux->st_ops != &bpf_oom_bpf_ops)
>                 return -EACCES;
>
>         return 0;

Oh, I see.. It's a bit surprising that these .filter() functions
have non-local effects...

Will fix in v4.

Thank you, Martin!

