Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F7D7C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312476B0092; Tue, 15 Sep 2026 13:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2A16B0096; Tue, 15 Sep 2026 13:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9B46B0098; Tue, 15 Sep 2026 13:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F07306B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:34:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E980A1204E8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:34:07 +0000 (UTC)
X-FDA: 85216694934.05.58E8D1F
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id D46221C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:34:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ATUjGByI;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789493646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHLXQF9aGovXJClL3PLk4pJ9zv8zwI/U3ejUzIOmUPA=;
	b=RxeK4NELEBmFTkSEtKuzgUE5vKJMibowlA8n+mR2D5siFo7hANJNfpqmsfLIaeMzlyWEe3
	F2HNVSHFcPJnY89Txux/oVxs2Rlaz8HUSf3rOjMamU4Bu2oUjls/ID4IhATaDg60/TVqkY
	QmZfFnb8KwUckrqhz7knmdlm/k+7CW8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ATUjGByI;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789493646;
	b=348V0sri66vn/FdBScVkOysWdo7JFxqodXvwjETBYs3W16nY47FjGXnUmsxCz4MQL829ip
	goBY1bzRi9Pv4jWeOYxNFkXDGpKGSGkQyhAfgFlllvulk3VIoSFprF3psrYKJTmg1reJv0
	LAuFG7QJDQpRFDRW9K6paZIBCvCmqRo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ny8gsx/+aib1LL/z4GtATlgXdDqmpbtNu+AdXrRe4y8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789493643; v=1; x=1790098443;
 b=ATUjGByI2+VF6GY0inbQrN6K5+Re57pPgbh40dV8JE6eHV1NPYFk4hyADTE4ETZcqxsekadY
 vPtvp6V9zqDbDZbTrmWqpn7gdXX+6M1TR51lBni2pisNwKO4PrU2k1MADZTBcEpsGq7d8oEoHf1
 SOm/5Wh+6MhDjYEaH3i+h5lo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 70d28aa2d60e653d;
	Tue, 15 Sep 2026 17:33:53 +0000
X-Mizu-Trace-ID: 70d28aa2d60e653d
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 10:33:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v11 2/2] selftests/bpf: Add memcg async reclaim
 test
Message-ID: <aqmBRjy07jIYdl-7@linux.dev>
References: <cover.1789475073.git.zhuhui@kylinos.cn>
 <93289af4317b57caa4e393d73fe6c786b24a4c2a.1789475073.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93289af4317b57caa4e393d73fe6c786b24a4c2a.1789475073.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D46221C0006
X-Stat-Signature: gnypx3bnbcsymuea1ki35t9umdm73xso
X-Rspam-User: 
X-HE-Tag: 1789493645-738662
X-HE-Meta: U2FsdGVkX1816ini4WQ7jaDDmbVzFZzlS32WjJRp1sH2Q632XzONUoOd+wG7OTT7pteFJdmWBtlvUEpXkMu6wvLVCtHPg7rwtz+BmEf8RQNeX5zmOZP6AO7F/4B8kHUY5kroNrasijeAHvm0w8gR6M6DyuYJm40gCxI697BHwOWabdufBqzE2QyKSpXysTthP0VGuPnMyC3pK/anqEK2SBa8ngPCKpDvRD01rm9TD9wQrQtMh0K2NTYKVHttdGS9g8EnVYAw9IsvJJc1PjJ1+RlRBjq4XeVUOuhbnZXXfZSjzfubwOi8GAV1WZqZPf1e03FAx+zpJShgfdmdJkHhMCi/4raD94IkOOPuUlVx+F8QCLC50hnveiH4aiQdAO4jmojv5WaCdjIUFZ32NZExb1C4/j6Ja/mmiVEe9PntlYhi/uvCXhKExKK3bH/BTGyFpxakbwiXkjyY6g4W5hyQSrkjydaEayNShFOKhZRBz6+s6DQkzPgc27OcppnbeuU/rDLtSJrrlE2rV2kOCiZY4fuSZn9sY0sj4LMI9odv5T+ahRpEfxKzHizde3SDYvt5yNqpwGCCzPUAoRZm7P/E9giS1NGzNW5vU9pYB1wiDR1L/iJtSzIcFeI2g0+1+46BFgVFR7KSj/pP/MNFK8vtDBJpxPU8eFiL8ToPcz6JdZMC6wDFjBlC9qZjgRXsXxokkRirm2j2rocXisPjfEq9u2UufLRNnqIuN1EKF9MXXzMJrZw+bTIccQ9ix1NMRWguhBIB9cR7SmGem2J98geEvY1ymga1WqtN4tp3xumyIMQHF5at+21/OkH7yyIwGbaHjXnvy2tonZht2pi3Ba8dYlBadkGiGp8lDHd5jffy25d0IrwpIdl+W53aGcRZtUbeJFUVRKL4LZDU1e/TKEpna/F4rku8J5jH4nI9cK08BAougxKRos7Zl6vxlbW4H5WnXQtGWykyiH7zXCNZ/eg
 eAQiQktW
 H/XXnzEmoBRIplUr3tddWRvMAS5BC+6R6EFXUk0BEPLH4r/ycDBNFZzIh2u+H4YKB75NXdjGgFlZTwWTH8m6NBsw2cTUfIoWPPotHvuLhkVaUopZea0EGRptQjXHOMB5vOK7uouBpI5Dk4YKQqaHgf+PLKJGPjIP7jCZyzi+mQowJz8IKpOpjUFupDo3ChIRQV3UQZKDgpIFDM4Tq65GU79hWz1b2zMxqeXaaBgxi+S1tDSipYiM7TImd83aOlSe0XnWyCReBLJX6/g8uH0+OeWbMQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 08:29:36PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add a test for BPF-driven async proactive reclaim: a BPF program
> watches the refault stats of a memory-pressured cgroup and, once they
> grow, reclaims another cgroup from a bpf_wq callback through
> bpf_proactive_reclaim(). Reclaim is verified through the reclaim_calls
> and reclaimed_bytes counters; the workload timings are only logged, as
> they are a benchmark rather than a pass/fail criterion. Setting
> TEST_MEMCG_ASYNC_RECLAIM_BENCH=1 adds a baseline run without the BPF
> program.
> 
> A second test covers a dying target: bpf_cgroup_from_id() keeps
> returning a cgroup until its last reference is dropped, so the program
> checks the css flags and skips reclaim once the target is offlined or
> dying, and the test removes the target while reclaim is in flight and
> verifies that reclaim stops. Each attempt reports its outcome through
> a ringbuf, so the test waits for events rather than polling counters.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Comments from bpf-bots seems serious. Let's address those and then I think we
are good with this series.


