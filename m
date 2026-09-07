Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6241EC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F1B6B00A0; Sun,  6 Sep 2026 23:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3100F6B00A1; Sun,  6 Sep 2026 23:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226AC6B00A2; Sun,  6 Sep 2026 23:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3E906B00A0
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:31:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 793BBC062A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:31:57 +0000 (UTC)
X-FDA: 85185542274.19.81261AA
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DD2240006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:31:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6OmzNGU;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788751915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JaxYLz5R40zaYRSxG1SBGkIH6LhSURiCzxHMVnkgPY=;
	b=b2NXxNiwE4NP5UKjEWi/JhGWpu/2fmslrWlfH8vt8YguDKcxptCmBepi+8C5MLkKfthPjY
	4SE9xIj8PEqTFV2h3Cn86Os2zXawDXCT4OB95RNn6fCC0HSRUqnu00y9PXZxtvcQgpewve
	URAp4wW66b5bCPnlDMI5lWMt6TTnVNc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6OmzNGU;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788751915;
	b=tYAZ2XtT3JgBGDWvf9yC9Pp4VB/hXvekSD3oWvCvKXbfGVzVngqIgbGAjNDaMDQkuSwz/x
	WuoXQl/iv5GVHUreiqu337k5cPEsdesqum7K7AOD4Wp5y2b6FmYjvrSGaH0C4Y8WRGvmeS
	WK9HkKPUW19YmaOzjf6GjaDdo/V7JxQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VMIbqoBiQDeHLrphbYg5Mf+UsKXgH9fka3p1+aplsZE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788751912; v=1; x=1789356712;
 b=u6OmzNGU6htyuZB9kN7btaayVrma/AWzfBItwEpaUeH0V41C7JjCziCsc5jEP8DRP40gFMob
 zsCf0t0tNlPry5kBEzxBgbXn1sVrSo6Sbk+ycC1m02xzhhSl7BQQZrzbFlOcf5b2ILk6Q6cjvND
 AwoiubskkSQiExq+8lzrnfak=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e3763fd486958387;
	Mon, 07 Sep 2026 03:31:52 +0000
X-Mizu-Trace-ID: e3763fd486958387
X-Migadu-Flow: FLOW_OUT
Message-ID: <13813a74-1f1b-4fb5-a589-6eda1e99bd19@linux.dev>
Date: Mon, 7 Sep 2026 11:31:46 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH bpf-next v7 0/2] bpf: BPF-driven proactive memcg reclaim
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn
 <inwardvessel@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788516769.git.zhuhui@kylinos.cn>
 <DL7CFVDSDV92.1VPGNHDCKVVIV@gmail.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <DL7CFVDSDV92.1VPGNHDCKVVIV@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jcm3i8gfm8zs4ai4cucexbhi5xqbspwk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DD2240006
X-Rspam-User: 
X-HE-Tag: 1788751915-296418
X-HE-Meta: U2FsdGVkX18O1aVE7YaNqHKjQbkh5VuN1zac4ZxFPrSvOdxQ8Hf1uuAKlsqYwBlqc1ztVhY8dmKVooER56I36n8VZwTIt0yyUprD4SGowMMgTliNHDOSsc/rEIkD/mch5NPwI81/H/7ph1VlSDwiu9ykeIWYwIUjXfVbq+Je61WQfioArCIfseiycaI+Vxd5KqJFQUUUwwkp/SPXYQ44cevZrUbBKHcCtQr4iygkbGzexfa/c+Zd8zz+Ki4XQqbl8ZF/AAxrDC9puAtmeOiZP2AiBl/efOfv5udUuKVI3qWGVDflruB1G367EKMrG6qp7QgMBFY/xOrwR/U7Ex0VR53ZyP/XfZ1f9hPMAdvY5qlN5hwMfbYHRXkd4phsa6LB5ME/uYlaVZd8Hn6dw/V3644Y9Q1cJNwjUGYs92+XI7/kdbcto888EKLqAEcv0r4vyZXheYNfMa1h0TckF1iqmbxWyIIVBiEQUghC5xaDEhEIQeYThmufjsiVSwBSshvY7FF8gSOt1UfWQsiAKynazbScHAXTq1N9OsZApw8vYNNcU27rIclHQ8nxErra71UnTqWp2AHAkVNuEnOmDse01xMMRjpV6rUbWbWL8BxVX+E/yqxYubBJLKC/EBqzsWSRa2rlQSmin4bD+6rX/p4V+9T50v140hrVcObCMHAbjBTfxVUfajJm+/g0IlsDOJRruBOEQ1IUy/+IOGr+2z1Q+rGGDg8zUP4k6gDsYvKxk+H5nS8nWa9bTjvKBB/iX/AGKd1MIVeH+rKWUQiKZsmeHMVOPCKmFPlb9Zxuv1WQ+f5xgOQx1HpauGdj5e2ONMAIaPR3mQ4b6ORJquV+3hN+sPz9cdOB5bONo3qw4SN8AbfQh4vqWwMe22o69KMrXYn1+fp6FgOhAOraOK8ad4KuVcEpRntj50YDoGCzE9lEzuTb7t4+f+q9nThDULrP8RUih8vnenM9kbjYW4WBg8E
 TfiZ1yi7
 sXJB+tywDMPrK/OI1wP9+VzNcxv1tnzYhjBYu8xXFUAa6e6pH+2BQwuFHqRr6yAGlBCVcXH8ezTu6Kvy0QAbpDwXSLOthxtG6zekIJ9yNxQJMuzuePidALc1VNJiFJRzPv0lRyZA/3Ph7sEGssMIeX6FIoB6J7qQQTAQc9Je35AyJlqwfEjn+HHLw6mH85BsRcAeai3xk/zpJokw4+p0ICdZGGbBIqtGYNOa5z4DegRJN/4mDGaMtHACzFuqsafGAK+alZOoSS+5MxKKxJROkeFOeqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Fri Sep 4, 2026 at 12:20 PM CEST, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> BPF programs can observe memory pressure on a cgroup (e.g. refault
>> stats via bpf_mem_cgroup_page_state()), but cannot act on it:
>> triggering reclaim on a chosen cgroup requires writing to
>> memory.reclaim, which BPF cannot do. This series adds
>> bpf_proactive_reclaim(), a sleepable kfunc performing one proactive
>> reclaim pass on a target memcg, so when and how hard to reclaim is
>> BPF policy rather than hard-coded thresholds.
>>
>> The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
>> always runs in a clean process context: generic sleepable programs
>> may execute with filesystem locks held or in NOFS/NOIO contexts,
>> where the reclaim path could deadlock in filesystem shrinkers. The
>> bpf_wq and task_work callbacks of a SYSCALL program keep its program
>> type and run in process context, so reclaim work can still be queued
>> asynchronously through them, as the selftest does with bpf_wq.
>>
>> The use case we are looking at is protecting high-priority workloads:
>> a BPF program monitors the state of a high-priority cgroup and, when
>> it degrades (e.g. PSI rises or refaults increase, as in the
>> selftest), asynchronously reclaims memory from low-priority cgroups
>> via bpf_wq and bpf_proactive_reclaim(), giving the pressured cgroup
>> more free pages.
>>
>> Another use case: several vendor-maintained kernels carry private
>> implementations that trigger asynchronous reclaim when a memcg enters
>> a certain state. These exist for historical and partly psychological
>> reasons, but the underlying demand is real. We expect BPF-driven
>> proactive reclaim, combined with the BPF hooks for the memory
>> controller currently under discussion and development, to serve these
>> needs in mainline, reducing kernel fragmentation and improving kernel
>> maintainability.
>  From BPF perspective this looks ok to me. I saw you dropped the swappiness
> argument, what happened there? I thought we agreed to just include it in the
> kfunc now. Did something change?

Nothing changed. I misunderstood the earlier discussion and dropped the
swappiness argument by mistake. The plan to include it in the kfunc
still stands, and I will add it back in the next version.

Best,
Hui


