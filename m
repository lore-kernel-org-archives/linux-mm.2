Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8DF606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=a3uy0tnS
Received: by kanga.kvack.org (Postfix)
	id 50C966B00EF; Tue,  3 Nov 2026 21:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC896B05B1; Tue,  3 Nov 2026 21:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD776B05B2; Tue,  3 Nov 2026 21:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 127556B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:45:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B56E80622
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:45:20 +0000 (UTC)
X-FDA: 85395895200.22.03CBA4D
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF3E7140006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:45:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=a3uy0tnS;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793760318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRzhUBlhk/MV6qetpAub4eArNWxfVuqj/T9Xhffcs+I=;
	b=cekI+aKaaqb9RbttcZY98vH0u57YAr3+/xay0EToikneq8hRYX1twUtKshkiT9h2oil7eP
	22nrLVSQxcRzkZw7oQA08qKKekw0v5Y9IPtDY5mGkJugupWReJKu9wyDOfm7KP2Z5ZBYqW
	20GSlPfBgVK6jyI6h6WREXFKjpex9RQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793760318;
	b=SpwRjCZglDwMRipxwet40cB8sa8cM+eX9Egwg+XXmd0D8tiaSnGUeIjiedrNFnYvwxKlW3
	DP+nbGwh3pTZPYXHn/pRAvkaXIotAfAmGanNLIGlpCcwhaOSV0eT2Pt92gWUpfMMLjG1bV
	QLNv3LjAvTPjoyQIOJXuWwFY1umaAMM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=a3uy0tnS;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793760311; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=rRzhUBlhk/MV6qetpAub4eArNWxfVuqj/T9Xhffcs+I=;
 b=a3uy0tnSn2cJBr5aBLK8fXX5Ap+fy0xWiabvtBdkU30DxrO5TfMZMmfSbqWVG5UQ8DMX7Y
 5SRrXF+D395hSWT3hX2UJD8DMrWn+XO6vzfJg3g1BOd5xn80IPBmZUdxN32Avvk37foB0w
 DoeDyCoPlToHA3kZLB0gLh3AZXqdubVxF33fnCvt8hlM4qhfgswauCoccOk8e/tzyk/Ug+
 9eFkJ6+CDc8x/15HlMWqXDrg2sgq+G+HdygOrKyXCzCsQZw+dHnSbNo6ltBSg2EsNfIcmz
 eFMexcSAP5x7RHi9SLOwKv3OG1hKtQGuYICvLX7N3y7szk/xK9DSjU/NKP7XQw==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26aea9c34+144ed5+kvack.org+lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com> <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
Content-Transfer-Encoding: 7bit
To: "Tejun Heo" <tj@kernel.org>
Cc: <hannes@cmpxchg.org>, <mkoutny@suse.com>, <akpm@linux-foundation.org>, 
	<david@kernel.org>, <gourry@gourry.net>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<ljs@kernel.org>, <liam@infradead.org>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<bpf@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
User-Agent: Mozilla Thunderbird
Message-Id: <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 4 Nov 2026 10:44:46 +0800
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: f5icqhag6n33559fcrjebgxhcuhkt5i4
X-Rspamd-Queue-Id: DF3E7140006
X-Rspam-User: 
X-HE-Tag: 1793760317-964352
X-HE-Meta: U2FsdGVkX198aLpDap1VOFp88PvadcmoJNGGZqrwWcJY0ZZNV1bCi/3ft8JPfm1hD4kK3sr0/CIGZ0Qq2pRO5AfZIVs7jvMUKzOYkxYVETNawqfiEr3WlDAK+iVz+KygqwzpcY5bEocZ4phdW8lmzlkC3NtVnQVk3QMBh1qeNwbK4JL8TuxnHIA3+mzwicws6MFVAIg385ryjtSzlfFJerEoBRK6bl5k1nS4rEoS9edtwA4GDDFXye+QPzHq+QB6rYIwqor68ZLEnT6UbC3C2KqjmxaHLhVHephGJSQjlYxYa5MkBWX7VkNZvKQSnK7LNLbzahY/zWOk5ZMfUNStvQoQlEoNXzBLH9tWbwhvA70DmZAy1R89j6z8d3YpYLy9JEJhh3X6gDXD8sb9OjX0dGwTwrI4T9OyaQKcQC8N9kLSWca4PSSXsZDJAAuBRFtgCH92eeOeCumm1dzsCgyDFQ7D8hrsYzhqgGy2WzKrcK6DjzGCTrXCqStf8EVyrIOIc1IzScJgjTpRjmvUntyclRV9IWGBMV3vAVnomUcyezeaoIeRAMJnEqq5jtnf2vSSNrYBBBbIqMFnCT13lgAFecAgm3NdGUPmliYmiiEDc68iltXCPHK+o2FqzJdxCvT6ix+Y28NLRsvMyNB3gpRci9dhKt4N4JJABt1Z4wNIWi5C61qr6TbUjV2R6Zt8Cpv1ugS+wFQTX2wuPLd6/xQrkZrb3PsFgctdkwIkYOF+BvgQZModYNTyk7FG90wBwrXU+CM5ZEDt/+1rdI5/xOX4dDU0zmBkkaUwdEK/zjSL6QlCyvDvmCfTAhvJJiCkiFIy67flCxM0x0nEDe6LRcMxZojyALIV/x8K+9CMJF5r+UhdcaNY2E7nlf2g9LA4KhrxDeRvAJ2Nj5RX72z2Q2q/mPKwnpWKG4TZreIvdFtjdctyMTMVy4DodWLXVc4jSyHQBtQ2uIdxROaHLa1bovG
 rp4Wy7gv
 x5hJcI9BoUDAj53o4tS8b2puJCAe4I81R7AKZmfS5/HDpzjKxv4hWbUYQ4FQ4ycGJKReaLUL/AxIJanXNHWWA1mBCHF/EQdGAEaWzX7hblbNWq1gOtnQUrMXPIsnmWKjeXW6x6nqtKBUYxdtHuz43x4f8RcaO+2uict7WXKr9Nzky8IqBMLFpf9z7Z3bADRj3QjPBAcZlyai3oZ1o9+OGnK4kH7ou4HYQjHJjTsdvxrhfrynGrUjQlF+pwK0BluG3E8BLEy52JoHs8wcuE3uzJxQlaq6gV8Pwf0qB3H35aDYvq4qjzoQo9EZjVWWCDGazbEkJf/CvoknfigZywTZtf7KYrOTzPpId7rUYPKMCZdN3BP7SrJi6IS92+z68tJE2WN52jP7VP+AygJzzVzvnrOnUojT0gHFqZAV7Ra9d2q3QZbs17ZeAnTF/gT6azEqAK6t8zi0pCZRsBzEoD/hV+JoFtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 11:35 PM, Tejun Heo wrote:
> Hello, Zhe.
>
> On Tue, Nov 03, 2026 at 08:28:13PM +0800, Li Zhe wrote:
>> MPOL_WEIGHTED_INTERLEAVE currently has one system-wide weight table,
>> configured through sysfs or auto-derived from node bandwidth. This series
>> adds an optional BPF control plane that lets privileged BPF syscall
>> programs install manual weighted-interleave overrides for individual
>> cgroups.
> ...
>
> I don't think this has much to do with cgroups. Weighted interleave is
> already a per-thread/per-VMA policy chosen through set_mempolicy() and
> mbind(), and the weights are parameters of that policy. I think this
> should be tied to the memory policy instead. This is different from
> the per-cgroup NUMA balancing kfuncs. NUMA balancing has no per-task
> opt-in and acts on memory with no task context.
>
> Gregory Price's mempolicy2 series already proposed set_mempolicy2() and
> mbind2() with task-local weights:
>
>    https://lore.kernel.org/all/20240103224209.2541-1-gregory.price@memverge.com/


Hi Tejun. Thanks for taking a look.

I agree that MPOL_WEIGHTED_INTERLEAVE itself is selected by the task or
VMA through the existing mempolicy interfaces. This series is not trying
to make cgroups select that policy for tasks. A task still has to opt in
to MPOL_WEIGHTED_INTERLEAVE explicitly.

The part this series tries to make cgroup-scoped is the weight table.
Today that table is already outside struct mempolicy and is configured
as a system-wide administrative parameter. The problem we are trying to
solve is that different co-located workloads may need different DRAM/CXL
ratios while using the same MPOL_WEIGHTED_INTERLEAVE policy.

I have looked at the mempolicy2/mbind2 direction. It would model the
weights as task-local or VMA-local policy parameters, but it also requires
new syscall ABI and a much larger mempolicy UAPI extension. This BPF kfunc
interface was intended as a smaller administrative control plane for the
existing global-weight model: keep the existing mempolicy ABI, keep the
global sysfs table as the default, and allow a privileged manager to
install an override for a cgroup in the default hierarchy.

Does that distinction make the cgroup-scoped override acceptable? If not,
could you suggest a better way to support this kind of administrative
weight override without adding new mempolicy syscalls?

Thanks,
Zhe

>
> Thanks.
>
> --
> tejun

