Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C8DCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8DD8E0006; Mon,  6 Oct 2025 16:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78C68E0002; Mon,  6 Oct 2025 16:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A680D8E0006; Mon,  6 Oct 2025 16:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9338E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:33:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 628D41A06CE
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:33:12 +0000 (UTC)
X-FDA: 83968839024.20.EDD7D5B
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E25B14000D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:33:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fRts5o6C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759782790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTuvAWVj1xNY2RCe1+5+6DP2geal1bbUoeJ33CVd4DU=;
	b=BChdP5Sdow6m+LwLtlQVk9hQWGH/DlUKuhVl3H9eJ7h5rC8OysrgwqvRi7Xzh6x+z7XO4S
	e4yiszNLOyEjJNNe6BodknEdDh4yhGmX7Ki24qVGXiYCCDGtaQrOmOKS6qg8YFN+e+pC0j
	VPByAZeJAz8Q5utZf9VAMGBIfjxDTds=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fRts5o6C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759782790; a=rsa-sha256;
	cv=none;
	b=LYYDgn1StLfWxJnq6tTx4xs6ep5wni8l9hQ1LHsChJvzMlQTij7+EYck3s/+zJMPf4BG/O
	N/3a9Zo042Y4ab7xMSkoWiVzgfk2/Q2fE629C6n4DyNnbXBAloRi9XHO/Y3z/qFDa5NNuo
	wn7IPIIpER8JdjHrgGTftI0mqSr9iSw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27ee41e074dso58623945ad.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759782789; x=1760387589; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jTuvAWVj1xNY2RCe1+5+6DP2geal1bbUoeJ33CVd4DU=;
        b=fRts5o6CbSwssSKrbj8BTs6czrvrpMbjUkPkbHI/JNikYRJ13cuA35KPdDJNUADkCX
         xzP9WS6j2yZTSYxjnLhWcBTJsf0WSGaNmv6DgVOhzQU7yw6h3CGx057hdGZSkWo7myF3
         63yUDz2I+WIS46YmC4Pm0aeEpREmVm1h7fWoug36apUQM0zYL8R2UVq+biTynq3+/u0O
         28QwT0jzr7m2XNduEWu9AP3py8/V0quLYr4sa2DkcD0N3K2qItcA0toGBZ2NDiWogioa
         bYfXyntErTRHiDZ7Q7HCEj5DNuGNuaGaFcKppjLANstVi+YP5G1jRRGx8A7LgPVZYWic
         Breg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759782789; x=1760387589;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTuvAWVj1xNY2RCe1+5+6DP2geal1bbUoeJ33CVd4DU=;
        b=Aa4eIQWiJpL2TGLOoXRIHnZyCxbC3xexXlIwwsLAVPw1E6use5y3YrYM9rBmYHfsrM
         TljbsOtvSsYjmo3DqGjOeke843XJE+dLjYJseeGeMRQEIxocZ4RbxeHSQDmZ7Sj4J2uE
         hbRPHy5RKq/P+dX8aNXE8uF/bOdssMdo+SJdIF02aCALBfLLpV9c+5GC6JVdYGSfSapr
         khZnox4haa/S7sdUmoE3TmNqvUfvd0wCCbxFFLBrnGh+dnvNUtirxmNoOklK4N6PUXLD
         8A/jYOrM15Awfbei3Cx3cJnp7exRBWQpWC8kwivrw84n4Q2RAAAoeMGJ3Bx5t/Kix2Ix
         r1kw==
X-Forwarded-Encrypted: i=1; AJvYcCU3lXx6h3zmCdFamITrzOUDU1D4TsYD6Lhv0J4uWRGrLsrfbnsFSvw+o8zn6zbNwoM+dAaP1EZY8Q==@kvack.org
X-Gm-Message-State: AOJu0YzMl3CrSsn18gPjDaJm5BAk6BEjyTyOp+IpBe+hS2YMJXszm3Ma
	c02PKDcokPmJSfq5QjZuG2cect0pUIZavZnidOkvDPmmYD+m4WJ0FA2o
X-Gm-Gg: ASbGnctZLQiYugP3m1XZ95adRn486OSkV2SCJpVqH1R1zBWfSKNU/yxpS0n+SfDxkpG
	Dx7T6+COL/xwqEs8APcVdVCyqvKadhj27bCqyAgIGYsqRPeZrEwYc+OvNejUqDRrL6JGZ77h9h5
	2T0jNNYaCvEDsAbsvHufFoiSy9Vw9+aJ3+W4OPrOx1TU7fFrSKPyvoyBU4MwnmPv1VfGVNB7g9O
	BtK408uK/PH/WuW3ygW9GGN3vN3LGJsTxKRGLIlGVSuSlq/P86q7rXOIn6VhGtPVNmopvYh4Ifn
	e9aFIJ3GGpBxZgpxqY3FqBgFGrbHdZ6QfXpEjJPEBsWSOOiCEzjgBwdIl+0THQ0RF5NTc2tJyYe
	yo6wVuMYPMu1JoPCdTSx3rFOX7Z5+5RVCMuPUK2IvwyaW7FfIztilYLOjaBmlsj705GuM4h2FCE
	B1+rFV
X-Google-Smtp-Source: AGHT+IE/MvX+CuLujIbF0sgN/kXRntG3wFGfdpL/t6ZHiDkab3quyg+ufA6rxyIuFBes0xT9d3Is4A==
X-Received: by 2002:a17:903:1b43:b0:267:a8d0:7ab3 with SMTP id d9443c01a7336-28e9a693f40mr159740215ad.61.1759782789065;
        Mon, 06 Oct 2025 13:33:09 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1151:15:6b87:8abb:5d27:d3d8? ([2620:10d:c090:500::6:c573])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1dc00esm140825475ad.117.2025.10.06.13.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 13:33:08 -0700 (PDT)
Message-ID: <82c392dc-e750-43d9-9394-1df00a366ae0@gmail.com>
Date: Mon, 6 Oct 2025 13:33:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: JP Kobryn <inwardvessel@gmail.com>
Subject: Re: [PATCH] memcg: introduce kfuncs for fetching memcg stats
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Yosry Ahmed <yosryahmed@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
 Kernel Team <kernel-team@meta.com>
References: <20251001045456.313750-1-inwardvessel@gmail.com>
 <CAADnVQKQpEsgoR5xw0_32deMqT4Pc7ZOo8jwJWkarcOrZijPzw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAADnVQKQpEsgoR5xw0_32deMqT4Pc7ZOo8jwJWkarcOrZijPzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E25B14000D
X-Rspamd-Server: rspam03
X-Stat-Signature: s7kwthrqq7o7qxsprfxcouzoqixk9y5q
X-HE-Tag: 1759782790-641524
X-HE-Meta: U2FsdGVkX18TBL2Y5HS9jpI36BTTv4iOl718RTr37n88NG3drMPDcadPRVVtYPmM87SnqNGk5LEnmNBFRdYmN/9r4+2LF1tF8fLjIXvmeiAkztomS9ppNcXgo95Ys6dWuE1lH+FRAaSEFWJp9niQm/UYsDV8viCj0Cb+Cpuo5ifk+wkfxexPKH1ULKZnUhUSX1ccklBa3L0zsWW3ZOpKZu+HVFPLCjoWzlFROYecDw0FxYvdSRmDOt2N7vTUohqGHW8N8Y5hRRVfL6yf0tHD5ZRV8+JD0KBlZdqg8m7r+G9cl9K4ghRS3FHJOonvwX5gbvDlfOvvDjjqsbqkR1rFnRgHkd2y07SvAcX1Q61tOgrYEhtvUAVE8ZyRifN86GlKNbjZfZR0dWrBXrdiHN8yAAVLADvgBWb7P7kRqtX2tErRPbDvjenQ+nFvNNVSrjFmOrFKoICpcdGB/QsaJXbwlZiRtyTjmlIcvr7G1fqH5ICtjHr7t4U1yBuu3GxyLlHqqzq37flDwxXXyLqvupqIhVzrkrsKExafGZkGUP1jT5IlGjj9G7lxoYTAElJsUajYkBHkuICYAx+OR66G+ALqluooYrhD/bDrt5n45OzXMm35ZjFoQ5WHqscYkS05lt5HvfMpxpxVczmgYYqKgGRK3B3Nvkc5CZeVV5YQfLB/+2kvyfTV2flb+qjQ9e06sLDkf3l+FeLyLYLfduYL5JODbZFrqwx+04oxwXkgV8/zVj2HbRsWYQBYqUu93sQyUvllGxdXE+kV9zOzqPXJV8JSEmR+2lS1Bu1K72QK2Et6gPk0BuT77FYJQwjbvoogp90GHTpEmG69O1W5dbo0gnGf9bGY/zZpf7+SOggd3DIbEkfeQ8FF3qON0yd4ObKkPZb7goFsM2ue3M5oD2AocfJs8iEK77cLcOt4TlE0ALACeacAbXDVaBFvVAeTWGS+GBUeiU4BAsnjSYXifN57odQ
 xEPlMYQy
 lcGlUzixZGpexVrL1cHhIQAPxq4jjMEAnzFPfoPcmXWv8t4tiJES6jWjswNYkT6LpE327ReBxei0NXu1gP2EDOVvya1O9PPjH21FYBDYUyITlCNP1rT9RqKaCbUuehBKWl+mRc7YlyEqt+ebN5wEE/QpYzjiNWYbgkR6IMJlh33MsTzgvGhZGFyN3QhsMqa325EO4DacYcRe9XoGMMR6m/tHClMEd/kCbQD1Y0K5Nw4eAov7RvD7JICryS3JbzsqngDUvPIdDJdHjIahk2PERIKGNWemQhfRsyYFy9LUbdtEV3tpX1l+ZrWtiH/ChFHsB9wQj1OeitwoGZa4TlGaM0FLl0Sovia8fPMJgY2TOrhqMrUDFfhZNvBkBq0z3BYzuqEFI5X9WU7gXX8OwBHbnGfnFgihV+Bkj2U6nLWIYEPDcPZxy0RAIykmpzph2odbcqm6b++LisvsE6YByG/jEcQL/sa9FJu8CqMZt9AUtXEewKdfJHljTcA4MvQW8EWn9wdMyc6bhULGQid4fT8jc1KNizpkopE/ugp4aJst0RSgPIKy+Q5xU7tH4hmhLFRYbxkhzFn6M9kIcNgHwIrpI18QVwr9cx4UZU0xh6CV65vv3BaB3pKgGpkPf7S7L9SYmCbGQNm7l9Be8R6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/25 3:25 PM, Alexei Starovoitov wrote:
> On Tue, Sep 30, 2025 at 9:57 PM JP Kobryn <inwardvessel@gmail.com> wrote:
[..]
>>
>> There is a significant perf benefit when using this approach. In terms of
>> elapsed time, the kfuncs allow a bpf cgroup iterator program to outperform
>> the traditional file reading method, saving almost 80% of the time spent in
>> kernel.
>>
>> control: elapsed time
>> real    0m14.421s
>> user    0m0.183s
>> sys     0m14.184s
>>
>> experiment: elapsed time
>> real    0m3.250s
>> user    0m0.225s
>> sys     0m2.916s
> 
> Nice, but github repo somewhere doesn't guarantee that
> the work is equivalent.
> Please add it as a selftest/bpf instead.
> Like was done in commit
> https://lore.kernel.org/bpf/20200509175921.2477493-1-yhs@fb.com/
> to demonstrate equivalence of 'cat /proc' vs iterator approach.

Sure, I'll relocate the test code there.

[..]
>> ---
>>   mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 67 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8dd7fbed5a94..aa8cbf883d71 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -870,6 +870,73 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
>>   }
>>   #endif
>>
>> +static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
>> +{
>> +       return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
>> +}
>> +
>> +__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
>> +{
>> +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
>> +
>> +       if (!memcg)
>> +               return;
>> +
>> +       mem_cgroup_flush_stats(memcg);
>> +}
> 
> css_rstat_flush() is sleepable, so this kfunc must be sleepable too.
> Not sure about the rest.

Good catch. I'll add the sleepable flag where it's needed.

> 
>> +
>> +__bpf_kfunc static unsigned long memcg_node_stat_fetch(struct cgroup *cgrp,
>> +               enum node_stat_item item)
>> +{
>> +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
>> +
>> +       if (!memcg)
>> +               return 0;
>> +
>> +       return memcg_page_state_output(memcg, item);
>> +}
>> +
>> +__bpf_kfunc static unsigned long memcg_stat_fetch(struct cgroup *cgrp,
>> +               enum memcg_stat_item item)
>> +{
>> +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
>> +
>> +       if (!memcg)
>> +               return 0;
>> +
>> +       return memcg_page_state_output(memcg, item);
>> +}
>> +
>> +__bpf_kfunc static unsigned long memcg_vm_event_fetch(struct cgroup *cgrp,
>> +               enum vm_event_item item)
>> +{
>> +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
>> +
>> +       if (!memcg)
>> +               return 0;
>> +
>> +       return memcg_events(memcg, item);
>> +}
>> +
>> +BTF_KFUNCS_START(bpf_memcontrol_kfunc_ids)
>> +BTF_ID_FLAGS(func, memcg_flush_stats)
>> +BTF_ID_FLAGS(func, memcg_node_stat_fetch)
>> +BTF_ID_FLAGS(func, memcg_stat_fetch)
>> +BTF_ID_FLAGS(func, memcg_vm_event_fetch)
>> +BTF_KFUNCS_END(bpf_memcontrol_kfunc_ids)
> 
> At least one of them must be sleepable and the rest probably too?
> All of them must be KF_TRUSTED_ARGS too.

Thanks, I'll include the trusted args flag. As to which are sleepable,
only memcg_flush_stats can block.

> 
>> +
>> +static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
>> +       .owner          = THIS_MODULE,
>> +       .set            = &bpf_memcontrol_kfunc_ids,
>> +};
>> +
>> +static int __init bpf_memcontrol_kfunc_init(void)
>> +{
>> +       return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
>> +                                        &bpf_memcontrol_kfunc_set);
>> +}
> 
> Why tracing only?

Hmmm, initially I didn't think about use cases outside of the cgroup
iterator programs. After discussing with teammates though, some other
potential use cases could be within sched_ext or (future) bpf-oom. I'm
thinking I'll go with the "UNSPEC" type in v2.

