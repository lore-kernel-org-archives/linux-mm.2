Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C8ACCD1A2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 04:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3AA8E0007; Thu, 16 Oct 2025 00:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB6B8E0002; Thu, 16 Oct 2025 00:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008138E0007; Thu, 16 Oct 2025 00:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E53F78E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:18:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C96EB6C13
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:18:59 +0000 (UTC)
X-FDA: 84002671998.17.128F1C8
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5B90A0008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:18:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvVkZIX8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of yonghong.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yonghong.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760588338; a=rsa-sha256;
	cv=none;
	b=qq4bN7D2TvQ6BS3ylKWM2otGnAU1GnoLEPg4FT/04+xmcXvQ5wQAZGtiCKHVO/sRKt6OOp
	8MDWSuN8VCsKn05nkkb/sLtOud6MTEgMZ6Hxs35yjdyV5tx/T3Mi7d/rXGr3UJFP4MDz4F
	/xr4YWZyZS/6zPpcAfwDyvir1j0gT3k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvVkZIX8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of yonghong.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yonghong.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760588338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j74IkFY/9p07YTv56+MgM3TYZlLX13fwYDRNS0UGDp4=;
	b=mb3IQjfeoAfswDudcQfk8uxJggze+AjX9H2GciZNf5qvhwaJA/TdbeMO5TVAqA0OyY5Wrv
	LwgdCY3hA1xKnzQnN7c6qz54CF7IgBomM2lm16CVev2qEXG3T4fT45oirXUyVQ3DeNcYx4
	D1jGoYk8kmI8JbSR5bCj3m8MWdiGkfQ=
Message-ID: <987ef44e-55ef-4e6c-92e8-daaf005701b2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760588335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j74IkFY/9p07YTv56+MgM3TYZlLX13fwYDRNS0UGDp4=;
	b=pvVkZIX83jiJ/l+3B/CwdBQUhQL29T6Aj19njZ+XX6q1LWoomT7wZsh5h1ncbJVRXdf4vr
	gjEhpT8HhNyc47WmdOIbHNdqLpCbpbnhoMkVsax9ENfy7QAqeeLTOp0dsGdFxAPjfwPVBX
	yv6tpCQoAyeGEWWTPOZGCcRpcgwqZPQ=
Date: Wed, 15 Oct 2025 21:18:42 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
Content-Language: en-GB
To: Song Liu <song@kernel.org>, JP Kobryn <inwardvessel@gmail.com>
Cc: shakeel.butt@linux.dev, andrii@kernel.org, ast@kernel.org,
 mkoutny@suse.com, yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 kernel-team@meta.com
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <20251015190813.80163-2-inwardvessel@gmail.com>
 <CAHzjS_s3L7f=Rgux_Y3NQ7tz+Jmec5T8hLyQCxseLJ9-T-9xuQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <CAHzjS_s3L7f=Rgux_Y3NQ7tz+Jmec5T8hLyQCxseLJ9-T-9xuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xztip87jhi3b3coz7i4kigj9ipmkmnxw
X-Rspamd-Queue-Id: A5B90A0008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760588337-586909
X-HE-Meta: U2FsdGVkX181YHD7jUVO3boCyR5z0G5DaVvR78BsA1NXv1SsErE40NcaFr4iphPuVFN3ToIYT2p32bZCEVr45bGK2VN2Y86aZOqiHAPR8bXBRV1UZFVV9ywlbn7r5/SrGiS21hdD5eEXm+SPs0Kgud/qpnlVlZyPzavNPcPKZnrSHFWJ4M02J9fcZSOgLzzelqo9Zg4DOu2R1d7uwc8cR13z3rrc8FJom2HfGAkDFbY+yw7cfYJIgdOQAVZtYL9WUn3dQqYLN3zLlwHPIDikhHrTJOqT73xYBuYyBERTsQWP5eaqSC90OEgI8IPK+rmuoYDvOZ2yXktzwNqQ5KoMdQwMX41PE3liwTNK0D5YR9QmkJk92OJYFFC5xOG1ShJ71m42WTQDX5PcuzHq8RzRaW6Yl2bTvz7irMZj9WvXTiSdGqSLe0QvkveO+qcMzgiGLXhvwlhhpnvzrTZkdWffkwRdAT3z/CWfy0yqC/+RgY5fCqClJBHL8R1LV+khLiEue4n4B79ELZQGG4yc6zuD+7Lry+JQOoSb/wFendBkm+O3XZebk/8CKZMwTdae4ZvjE6lmcaBKT5KqOT5XXb1wFwJQKixiIWdBkiCpTRRxMYPssAeUtxRTDPhC0UDtApK0Oub/bH67rN859LtSEvzZjWGY1MCcjZWl/QrDVNZzIs207CSCud0HXsboNeGfbsG9dDdO641aCgEgQiBx4Yjvo9UsAt+XaNaisBONfujmvMCrHrm/SmxJWVLFdoQGXTG1riOVuM3WPrFvQca6ofW51TqR7IzBx4cD6QjdAQuYwgvV05TKBE66Exzgs2/7kUaZN3rEsvxiWlRYDxUq6ZhLxv+x1BULjsCyB3hH/xUJTKyhiaEBa6+c0PW+xG4VN4vGL6BQKyHV5yZiwkPU1xKqzKRdsA7fNuXOB8JqvnSMKyBNnws4LtbfsHekx31mmtVJk2z1iLR+gg/Z5iCPXGL
 4BuDrOSp
 NBIDQXZnilhKZGa5K20c1X7dwVEhPeprsvvqoApPF1NuePPaQru1JbqGb35ooEUAIRsv8He2dgCJfwb5zUPOuWeuOSZMKueZi5m7DDGETKiIIdTwCVI5DdYTnHn6ZbMnIRZurB9/b9xPvDUPDfcKPF8l4ECcKPr1gp6G8sSlgjioyN/vJ1I9Lp1TNdHvz6kn2/PvNSIQBLeQauvFMrIMPiKaKTcVWqhGAs4hvNnu6+O/rA5Y0FY0vclbnFs4QXC2/oRvuXcAvPfZyluimIuINRKfd3DPvdn55yL7b3hHA7yyIsZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/15/25 4:12 PM, Song Liu wrote:
> On Wed, Oct 15, 2025 at 12:08 PM JP Kobryn <inwardvessel@gmail.com> wrote:
> [...]
>> ---
>>   mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 67 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4deda33625f4..6547c27d4430 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -871,6 +871,73 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
>>   }
>>   #endif
>>
>> +static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
>> +{
>> +       return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
>> +}
>> +
> We should add __bpf_kfunc_start_defs() here, and __bpf_kfunc_end_defs()
> after all the kfuncs.
>
>> +__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
> We mostly do not make kfunc static, but it seems to also work.

Let us remove 'static' in __bpf_kfunc functions in order to be consistent
with other existing kfuncs.


The __bpf_kfunc macro is
    linux/btf.h:#define __bpf_kfunc __used __retain __noclone noinline

__used and __retain attributes ensure the function won't be removed
by compiler/linker.

>
>> +{
>> +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
>> +
>> +       if (!memcg)
>> +               return;
> Maybe we can let memcg_flush_stats return int, and return -EINVAL
> on memcg == NULL cases?
>
>> +
>> +       mem_cgroup_flush_stats(memcg);
>> +}
>> +
> [...]
>


