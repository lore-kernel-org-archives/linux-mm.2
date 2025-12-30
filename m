Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648A3EE0203
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7CE6B0088; Tue, 30 Dec 2025 16:00:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8857C6B0089; Tue, 30 Dec 2025 16:00:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791FB6B008A; Tue, 30 Dec 2025 16:00:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64A566B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:00:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C26BC1992
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:00:51 +0000 (UTC)
X-FDA: 84277356702.04.6E202D5
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2ABCB4000D
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:00:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jcgg3koN;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767128449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRIHEk0dRJ5d7qN6JdXfLwTI0SjQwuqnSM6RZ2ji4I0=;
	b=Gxn9lqyj8ov6yqD9ryhJwR+fNR6VDHsjjUghr8ydV9ovEcUntfrXj7+7Wnes5WDjuaKS53
	BcHQCqHN5jXV3e2eJ5qwywhMTVeRXu0TLZhawxZTBlxII5cDcy8Xr9RxyKadvMhSlIZY2y
	Z2+nyQYdP04zn7sr05tBmoAERjfkwDw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jcgg3koN;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767128449; a=rsa-sha256;
	cv=none;
	b=E3joEIeP/X4gOMVVskagQe2ctPuaS3UJrUrs8wKRy2DCXEuIhX5HLl7reR2TGJWT1j0RY1
	tZi8hnASjAIDOE2NDcgLnrj+dTQYsmOqxEMmw+sXfnMYlLWeUbVtbWKwpx3W9XRxR9p2VC
	AKBpp3Jqx7/nG5F6012gzqJRtLsPTIQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767128443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tRIHEk0dRJ5d7qN6JdXfLwTI0SjQwuqnSM6RZ2ji4I0=;
	b=jcgg3koNkQo7ZKi4SR5FHC6HWg81ZfOljZo3eST1XZvTvfO/oiXaYQ7Q+SL33fi1A8xrwl
	k5aWAU8mm93npTJU2oGM4EJbtSFNVxstrD9How00yt51w0t46olSWtRJ2QQT5eEPHLvdXa
	ud3k5VybY7LYIiN+gOgczUKpUf7Okcs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: bpf@vger.kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  JP Kobryn <inwardvessel@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Michal Hocko <mhocko@kernel.org>,  Johannes
 Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
In-Reply-To: <aVQ1zvBE9csQYffT@google.com> (Matt Bobrowski's message of "Tue,
	30 Dec 2025 20:27:58 +0000")
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
	<20251223044156.208250-4-roman.gushchin@linux.dev>
	<aVQ1zvBE9csQYffT@google.com>
Date: Tue, 30 Dec 2025 21:00:28 +0000
Message-ID: <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 4jy83k55bpjt9bh1dgcaoi9jg16h98sh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ABCB4000D
X-HE-Tag: 1767128448-607138
X-HE-Meta: U2FsdGVkX18QHB+RdZhVxGTFM8ESatsnSDHr4Do8mq6reV4Spuw9TYNRIJRkHyZq0h6F+/HTZ3CA683gDBRf6bKf9m1ELeqilfwR/kU/2iyVZ64LTfq6G2YWUN6Nhgrnx+eaqsbV2hfwKAB4qrlnvtf1NlxpH1JuiDBUH5IcXOJMDoMYX2V9lBNDV/f+8Z9/JfArh2tlBgSw7At0T8Bm/at2vzbVPjOyocdY7hgXE51CPZf6N319OlmvmaIbwTW47QLaJ3VxU4vSyXi0MWg3evidpTZr8AHNASZPfmIQs0Zi0noo4hyKAcgqza5zsB+BMz2zVD96efcqz23Lr+BzNyzVB3LnQDv/WES3jx/M/SmHRZvomzmxE2ePtl2J+tnyaRjekzUYXzWfHyLxARHuz2yaqgTf5Or3H3KD2eMEjFTQVHkJz5F6f+52hJGtIHOlxRGIzcGw3LRRFdnOvEaYQy342n5CE6X6oOAHK/iuc3OZ+dv2nkGIwPvITDKntOUWmeqFVOvRq3BZre2ALDywHDMDpN3d3hy+4PHf5bztUa+QjrEq+400bt5Cqvrjwtt7uvp3/bymAkpfcg/pQOGquNjZg8V3RmembTN56hnnHeBOkZe+c1GX/TAavjudKnRKCOzt0eHawHCGaxA7xf0BYmEk/XfeDzqktKe0ea58abq3rlCwMTHV4nfu5PG7edOkkzv64cpHcthXPfwkIAeanWkQTakfD02R5WxTEpQr9/TezvkBx0e/jHaGtSpTtdfXWTR4NOR2GjFlxwTPE+w+1q3sIpIpwyj8V3rVY4bJud5LymLdP064L69Sl8mfXOPYclFlTEo7wGwCxTAPMVqxLDicymtkg70cPc5UNvlgS/gL2KYohNHFPm347eqq0EWVO60CP7RDWO7rVqCbO/LEm+VAIXY+jMA1SC5kYz/bq8r3rqJRAo0FpbwsMBOXkOlNTAevZmF+FZgsmkgR7j3
 fRgWS2jI
 WeWU1OMCb7SMHkEqAnoGrzxVNN60B3eQ6EVYmz3q/9N5Xfos0FJxc5vBdviQSElckYilCALJdsTou78EA5SzvqaYMvqhAcszOlagAiO0o4FdayeIOO3S9433H5K2NSkcNz/Dl93IuJdMQ6EppAdWFkfZfKOa4vsXBgvXmRseGHKuZg6cuJQd37H0osN7S+Ddm6UMW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matt Bobrowski <mattbobrowski@google.com> writes:

> On Mon, Dec 22, 2025 at 08:41:53PM -0800, Roman Gushchin wrote:
>> Introduce a BPF kfunc to get a trusted pointer to the root memory
>> cgroup. It's very handy to traverse the full memcg tree, e.g.
>> for handling a system-wide OOM.
>> 
>> It's possible to obtain this pointer by traversing the memcg tree
>> up from any known memcg, but it's sub-optimal and makes BPF programs
>> more complex and less efficient.
>> 
>> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
>> however in reality it's not necessary to bump the corresponding
>> reference counter - root memory cgroup is immortal, reference counting
>> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
>> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
>> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>> 
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 82eb95de77b7..187919eb2fe2 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -10,6 +10,25 @@
>>  
>>  __bpf_kfunc_start_defs();
>>  
>> +/**
>> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
>> + *
>> + * The function has KF_ACQUIRE semantics, even though the root memory
>> + * cgroup is never destroyed after being created and doesn't require
>> + * reference counting. And it's perfectly safe to pass it to
>> + * bpf_put_mem_cgroup()
>> + *
>> + * Return: A pointer to the root memory cgroup.
>> + */
>> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>> +{
>> +	if (mem_cgroup_disabled())
>> +		return NULL;
>> +
>> +	/* css_get() is not needed */
>> +	return root_mem_cgroup;
>> +}
>> +
>>  /**
>>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>>   * @css: pointer to the css structure
>> @@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>>  __bpf_kfunc_end_defs();
>>  
>>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>
> I feel as though relying on KF_ACQUIRE semantics here is somewhat
> odd. Users of this BPF kfunc will now be forced to call
> bpf_put_mem_cgroup() on the returned root_mem_cgroup, despite it being
> completely unnecessary.

A agree that it's annoying, but I doubt this extra call makes any
difference in the real world.

Also, the corresponding kernel code designed to hide the special
handling of the root cgroup. css_get()/css_put() are simple no-ops for
the root cgroup, but are totally valid. So in most places the root
cgroup is handled as any other, which simplifies the code. I guess
the same will be true for many bpf programs.

Thanks!

