Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374C3C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 18:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC6F6B0096; Wed, 22 Jul 2026 14:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383C96B0098; Wed, 22 Jul 2026 14:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C17D6B009B; Wed, 22 Jul 2026 14:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E90BA6B0096
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:43:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65DF81C0020
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:43:11 +0000 (UTC)
X-FDA: 85017284982.02.3161A0F
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id 074F640009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:43:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BsgpXMd+;
	spf=pass (imf12.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784745789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jU7TNupb0pdhQBzs77sfqtrZ1+d4xoAeYWx+j3QiA1A=;
	b=6TkOzfuDpy0pY/KeRklZsQARluafhGKwlsl+JHXNzAVYnehc2vpyGZOwAExCLSYwwzUSAY
	ScqE9NRnatBxXnqd4IP1BE56/+Aa5l9LfqTss3Vnq4qXT62XntzE3Vc9bL2Zn6uO5SF+/b
	3eNqwCcOOxJ+bV2ksOM0iXqGSxK0soo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BsgpXMd+;
	spf=pass (imf12.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784745789;
	b=VDqAGspJKKdgLhMCwMAUxf1XNmS6lqXBe6RX57YOw9UhCk0dWEqnHDnZGx3spUQuPL8qUJ
	4GCvx8CjRiy6XNNqdjcoMcJCCSmvngT8ZnB6a50SnfJ9ImQyLzUaUQhQU8Yk/RbL3G0GZu
	BIT85foUNfOYXV5QmUWNJbi3B32Frng=
Message-ID: <f83b6c93-b32e-434a-94b7-68628a2e8527@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784745786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jU7TNupb0pdhQBzs77sfqtrZ1+d4xoAeYWx+j3QiA1A=;
	b=BsgpXMd+bM/LhQJ2Rz7ftetxHEMGudfLcMl4EwXOOefgsqqUA+QfxR2ssFJp4BuLLOtnV8
	wr0DW6Ha7NOne5YliUKnWr4ctzX7Wb4TOO9wzA1gl/rTqa474oUAM576CKQ0vhO6rpIyJr
	lWH6SLT6mICi3YJyQVJ+jlD9UymTRoA=
Date: Wed, 22 Jul 2026 11:42:58 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
To: Ziyang Men <ziyang.meme@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 David Vernet <void@manifault.com>, Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Mykola Lysenko
 <mykolal@meta.com>, Nathan Chancellor <nathan@kernel.org>,
 linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
 linux-input@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org,
 kernel-team@meta.com, bpf@vger.kernel.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-3-ziyang.meme@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <20260721174833.1232771-3-ziyang.meme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 074F640009
X-Rspam-User: 
X-Stat-Signature: mnuxigbdo1pqhckzopp53cdf5nasso1s
X-Rspamd-Server: rspam04
X-HE-Tag: 1784745788-322208
X-HE-Meta: U2FsdGVkX198jb1IjAWHaDmEHLPao5T9xkDnuo71vzHRRfr+8KxAp+E0eEgZ8lUHldt2/qHjNN8C1DISAqW794Y0cvFI9ZObKBDFYPpge8hjrL9VHt0vV+Qb3aFdg3K3wxvLgDr57swEbBVzbJdMKApHRX3dW+iTAgMmadr2HZv9Y77/bYoXpGuGpdFSlsF/GCmNVzSpN9Sunp2YlK1jjgMhDbgaQd2pGI+WcXtIHmljsUOhbQfLJW852hlHFMJhk9W2ORF3AjyEDWQz/XjfSEQ1WVgHkN4kt+1nyit0a+WMxOQWg8QXv1DmQ1wDgj9sufkHerFlZpQ2dkL3BVxQrZVjphgInZCCZLnaUFfwsEiFhBCr3LrQA3Ps80AI4bDA0ks+L8gwkIeoo+PjxHgp3MfZt+93JlZG4w+d/xT1T6ZIY4KP3k/Tjbulbu1ygRHzhymmXn9hioZv0W4T2cn+ULd3RT0mRG/ludGOE3Guw+P08kUYOPZPpR8kLiuUK2wRbB+S/amckPXJg6LOtgxEBFTN3JslTpjJRWGwD/LFW+3x7/fHYxRn3TYPpTM0eOebmLCF8IHw9YtT9F5K9ggEqXpDyKqXxvv57FmAb/a14y/pURyA3GGahSxEuUT0MMf8+IKuO2dm3vCfCs3lFkC1sHlnQi5JAj6iTCaoSUwjBC8+x94ZpNpok6gqorNV1xnpgpnnJ5cbmv+U6TdTaZrJf8GkZtxVnVdIaWZ2kVbh5CAbBsYLi+79DywaqUcOnOsqDi0ioxmWHwdLo+ihwP8kUvNZLZRmwwNxI7KQIAJFZPhU8sGsZ5NQNlbv6phOGncS1lY6dIXYanxRLEyE4xOSgwLdh9NA5gnxL6KojtSCFOT8snjyYqxIxu+w3vhA3wi40+4D3PloxQLD1MMRNx1JgSwEy7XylwLYYh51RunGNJiiH2jpSKjVpOirBhTYKobBm+oN1eTdLwE2syp5fDA
 uIUDpZOD
 eXfITp8B56/ze09qFozOkBACmDQDYso6ZkSbnu+PqYb3TI3VmOFgnK642fnlW3DWwAJWxYp/hNJku73R/paGDRZXvmR0/1y00TbY25FYMRjn1Qy2sCecEFTvckZO7MTOdCChH5CnHCSyTmYZgU/XWJmYfidagnVBjGHLnaoaAem8gwxyo4GZIYunErn8eOSt/0A10QYunkqttdx4/aAbS2ACwbgShTn5y5VmN/G/KLaBo8qcufsDPouZdF5bJ0K6d4dgGhS59xdcSdkla5qi0MSBORkTd0V/YYbG+EDWSkWy8/sLIwQKnhQ/xEQiYjDuPTa7mxoglEE6N1WM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 10:48 AM, Ziyang Men wrote:
> Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
> return values that agree with what userspace reads from cgroupfs, across
> a whole cgroup subtree that has been charged on many CPUs.
>
> It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
> calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
> only asserts each value is greater than zero, so it never checks that a
> value is actually correct.  This test compares the kfunc values against
> what userspace reads from memory.stat, and checks every node in the
> cgroup tree.
>
Can you extend the existing test instead of adding a new one?

