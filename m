Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871FED711D5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F9B6B0088; Thu, 18 Dec 2025 21:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3326B0089; Thu, 18 Dec 2025 21:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABED06B008A; Thu, 18 Dec 2025 21:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9449B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:49:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A1ADB9275
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:49:44 +0000 (UTC)
X-FDA: 84234690288.06.B48B301
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78EA1C000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:49:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pI4nKNEv;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766112582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abd/44gPrDqvBL/2LyNnB1pB9d9gpdKplEObPG4utUA=;
	b=nri7jtWYm0Q/j2sHjgqcltpffm3gS9VuRWgrE1K/Wcc7QEKXnCBhD8g/0b1gKv5PQBh60K
	7Qm+qlL7Wc8CI2u57pHfm5x1Y7+Dsrgc+SBKvhU2y6tuFi5LD9HPYKiMg/rJfuFdgzt2Dy
	lZtneuehvmPmbYBCJBxayojrt0FLgZs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pI4nKNEv;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766112582; a=rsa-sha256;
	cv=none;
	b=vzkuhl3efCSX0toXgxCTlorOYyg9MsMhwXy/+3UQUuEicLH/tQh85vaUp3C4rbyBP67DnZ
	aeFrkhlgkL3Wt+ZzXSoDRTl/KE+N2oS1AVXQN4FZtcKk86Z9ke8jKSHNlECuclBGxy51nc
	uXK5sljvew4GSCgg6uDE7lHQme06Gkg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766112576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=abd/44gPrDqvBL/2LyNnB1pB9d9gpdKplEObPG4utUA=;
	b=pI4nKNEv57QpGkjms+FO+OVqvN/dvP3YiYsx0xarnEsiCnH4BErdFjMIC9Pe/5Z8eWZ+zv
	hmJofNw0nk7tikxTe/wsF8R16TfIFQmAvU/5WGTCVz8J0VCQiq5uL7Di6bdR/twt3OIc+a
	hFzrgZV0SJJtPpec9hJMioiFImoD1Go=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
  inwardvessel@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 shakeel.butt@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
 mhocko@suse.com, andrii@kernel.org, martin.lau@kernel.org,
 eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com,
 ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v1 4/6] mm: introduce BPF kfuncs to access
 memcg statistics and events
In-Reply-To: <e80e8faecbfd7099950485f4de08a1226ae10282ec44fe9e6b3610fcb00c8400@mail.kernel.org>
	(bot's message of "Fri, 19 Dec 2025 02:15:11 +0000 (UTC)")
References: <20251219015750.23732-5-roman.gushchin@linux.dev>
	<e80e8faecbfd7099950485f4de08a1226ae10282ec44fe9e6b3610fcb00c8400@mail.kernel.org>
Date: Thu, 18 Dec 2025 18:49:29 -0800
Message-ID: <87bjjvb2yu.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: s8wjkjp5shkju3dt5qju7jzhe1eqnxp9
X-Rspam-User: 
X-Rspamd-Queue-Id: 78EA1C000D
X-HE-Tag: 1766112582-273445
X-HE-Meta: U2FsdGVkX18d16cyU46dQl4FDN26eVXnkzQk7+M0jqn4345PDqD3dBtBFESw2krJLYVnQ9z9SLvs04NsjzV2c6Tq+myxeMJkBK5y7kY02YxHq75X/Dj0z98/YkOMDIEsv7WpbSLHAF4oRmS/SFu0GrrBvy7lXMi4fA8IRLqBlg3lf5kstf+tu87GknD0sQehebHHQlQwBd0mvilsjVcW6KU6V3BeCFtPD/CL59tiBoxQsxBDxB4Dg1oUSn25Nb96v4uqYkE7e0IYjLbUFPydPyWgbSIIFw5ugS/B7YVttPkqAqnJSNSrH8QNaRO7FuGf3Fytjj0E+Mpa6z69Cn9Y4l/vxwZZbeLNbwh+0VOVuQXnUXFG3nmCQiXiCD/kqWyLrmF/6g9rQdfAkGJTo/X7XzwvnPide9g0wEqMa4ZAXAeAsrZloB7YJfyVVv1GgQ1f1TRryichZpBrUTRSoRqIlwGVzjswrq3NF1PZ7gYjvepOZShlb/xukcIErI5/A0BBB81ecB+uRsvZqXiewiR+YYxUGu84zUCJj2kDXbFZOfzq/jlB1pq+hf6KqYjS9CObiz+5c3MDOymTxslYMc7F9nVf6YbLwyZpgDLZn9c3AaxvhpbTyr138Qhy78jKSXGDAwQLJFvE7dDeRSaSy/CotEMLzj027U13ygpY3fhCKpXq2Dp2J2kU7G1UhBFTXHV6Ec4dwqxD6m5dQYgH3LEWoHb9a3gVJ7d9O1Y4M8iGaV8QIKt6kfjY1jPJqFvQXOumzLuqiHnHzXO8oEaW29idT1KROlJO/kB2YhH4etquFJZpXnRBdpbv6m9t3byBwiBeGsP34rU7Q1HH/gHyOE9YwRF1Lv/+dB/0dUGKhLJ9ILsHyEMPKcRBx4W36I82my+oOGrFpMCsWZ1sUmFhfd3yo9YR4NkJk03j798nDE+VjcepAcNFC2mcXkpqRw2F/wLdnNgxfcLLwfkHXP4T0x6
 2WGjki6v
 tFfXSLLdgD5EugZLSzRGxw65oA/wTj0f4mnilhlrvs1dBSbvwgH3kGv5xu/KEnOrkIR9UXCZm0U6esfSXgcfqk/I8zD7xwXfGIlAT0CTiK/ANNzop4Od/m735wVDoVDam8B7qTMRaSZTKpHrcYYfp52T/i4WWmWqYwyaBJX9jAXvgUX4si99lFVpvCkJ3jtmYcVkwWHi3A7vMDrNZMz01anf4g6N0MNZqS3PWY2HzApkYAujAHwLr5dDK4NY8HhShFX1Lagf6NnaKf0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 6d0d73bf0dd1..4d9d7d909f6c 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>
> [ ... ]
>
>> +/**
>> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
>> + * @memcg: memory cgroup
>> + * @event: event id
>> + *
>> + * Allows to read memory cgroup event counters.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
>> +						enum vm_event_item event)
>> +{
>> +	return memcg_events(memcg, event);
>> +}
>
> Should bpf_mem_cgroup_vm_events() validate the event parameter before
> passing it to memcg_events()? The call chain is:
>
>   bpf_mem_cgroup_vm_events() -> memcg_events() -> memcg_events_index()
>
> And memcg_events_index() does:
>
>   return mem_cgroup_events_index[idx];
>
> where mem_cgroup_events_index is an array of size NR_VM_EVENT_ITEMS. If a
> BPF program passes event >= NR_VM_EVENT_ITEMS, this would be an
> out-of-bounds array read.
>
> The sister function bpf_mem_cgroup_page_state() below validates its idx
> parameter before calling its callee:

It's a false positive: the check is enforced by the bpf verifier based
on type information.

>
>> +/**
>> + * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
>> + * @memcg: memory cgroup
>> + * @idx: counter idx
>> + *
>> + * Allows to read memory cgroup statistics. The output is in bytes.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
>> +{
>> +	if (idx < 0 || idx >= MEMCG_NR_STAT)
>> +		return (unsigned long)-1;
>> +
>> +	return memcg_page_state_output(memcg, idx);
>> +}
>
> Should bpf_mem_cgroup_vm_events() have a similar bounds check, perhaps:
>
>   if (event >= NR_VM_EVENT_ITEMS)
>       return (unsigned long)-1;
>
> before calling memcg_events()?

No. Here is required because idx is a simple int.

