Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5CFC88E7B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402266B008A; Mon, 26 Jan 2026 04:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABF16B008C; Mon, 26 Jan 2026 04:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7FE6B0092; Mon, 26 Jan 2026 04:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF016B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:07:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B89308C00E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:10 +0000 (UTC)
X-FDA: 84373535820.12.18E8F9F
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B7B818000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kh1KQRH94uTdJAeDB5PZVmChDNSYXnaMbF1ERdVlcmw=;
	b=PSS7YiboCFKYfrE7HwoWKBOcgKK+6F3q2SW8t8JvAqMtJ/TPIDD8T/K3RTBsSnrLUdR5hb
	EYjtFW1QP63iPhZEfABb5h+ihP9G/n9D33BHfx7nYzTUaLC6dTU4Xveqj5u3db7TH7VF1M
	8eMwP9Ibe4X8B8gjVUzKOaUGzVOdigg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418429; a=rsa-sha256;
	cv=none;
	b=4HsLrFdyOlKKXacEQalduGr1J/N5xr0pc/epqBJ0oTnzgQgJ6V8L9SjRkJ+eGMIPu0mSjq
	Q0Y04I26vbOg73Dd6IOgjxevfTdh8KDFOeFHhwnI00j4zNPSZfc5/+Nt5Q2GywQZunz+bj
	W4bWqJ+U4HLYSuKYnmOz5lpKhbvL5ek=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwBHSJStLndpWbZbBg--.242S2;
	Mon, 26 Jan 2026 17:06:53 +0800 (CST)
Received: from [10.22.77.56] (unknown [123.150.8.50])
	by mail (Coremail) with SMTP id AQAAfwAHX+yrLndpaKIWAA--.39254S2;
	Mon, 26 Jan 2026 17:06:52 +0800 (CST)
Message-ID: <a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
Date: Mon, 26 Jan 2026 17:06:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of
 CFMW
To: Gregory Price <gourry@gourry.net>
Cc: dan.j.williams@intel.com, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Mike Rapoport <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
 <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
 <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
From: Cui Chao <cuichao1753@phytium.com.cn>
In-Reply-To: <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwAHX+yrLndpaKIWAA--.39254S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAHAGl2eO0EOAAAsw
X-Coremail-Antispam: 1Uk129KBjvJXoW7WF1DKrWUXr4rXF13CF48JFb_yoW8Zw48pa
	yrKrZYyFnrKFyS9wn29w4DWr15ZFs5CayUCryUuFyxZF4q9F1ftr48tan09a9rJr1xC3W0
	qFsFqr93uF95Z3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Server: rspam11
X-Stat-Signature: zu8fufyoudj6uon7xnan9tsnrssz5r58
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B7B818000D
X-HE-Tag: 1769418426-642564
X-HE-Meta: U2FsdGVkX182spkDYyYp0gvMbOud0TxMPhsdHpjIn5w6qqYHbaGGGq9zt6YJ6BQdIZVe2rvl5gDuI6NAOk4q5Xx3/hjY5iLPZ4/b5B4ntz5ZZk00KX/DFQlZ6jCZx/ds/HdyTW/JT98S0hGkzsn2DXAWc906tZIyZuMI12ppPDJ9TdXG8AGSowH3kUfm2YdxLNjvsv+Bp1Zput0kjafDbuqSdotg8c9zZJv92fQ4W92VnWf5Adyulm3WdLPyDrBSHQG+UHFzbU1xo4u4pqpRXvKhE3DhJPc4RztCmJqbsijFmaSdM5fYKr9wXWElDpXIqj0mkqC2rZku1OzR4cSPlQEQjwy5Y1R8vvVQ41iSpertxKLD5Lk4sA/Pa56HSG9gDIw2ax9hy2mL1Ij1SsQNh/gQ5yH0QZy+2l9WGStKiFPdpAT9phvi25cYk8i4J+gh+ZtfthNLZllNvbgsxyrqael/Hv8DcNqL+YFQX5KR6Cxmiru0BDzkXI/TQifeRXOMf3f7ZxISzasOaGZfqDAAHpHEQjAaCcmV/E/bZa+KOl5amMGY5xZ+GlhczN0y8fvL8tsCLX83k4z8OBqmcduZCL9ye4GNRQXuJq1GuPepu72coRrRYkjbeF7mag7UxNV9MGGKObxQiZeMCFpTa9MwbxJIHIVoQfYCa31GgidgdMOdFurToLwzWgG62uVDHlbTmKtunmWPvOexGGCuvBXs4t3cQLswyPtF93xHy/QPxuaOmiU/A6UmNFMOr75SA9c0IoRCvZwFuFGjacEEHK93R/grzWZkc2XmCtfAYcMRADT0Z0j48ZfO0S1OffcOZWeUJqCaK/eYbZOQbLbMPAdABLX+W5/EIe2V1FnjRQwJM0C/CDj9GkjF1A/2kYldzCzR/nA6J947qn9TVbfpGhUhdFvm6InQ6NmSCDqzUobMu8uPn9pE8A7f7NOaj9dgdj8BZttXGs4XmRPqKGbdNgh
 NlUYorEg
 Imt2GJoC0c6r3451Oz+ZC1mNwSaUwnXdDZNcAZUzS+y5uSgBU8t3TZtb1D5tonPp9LU7iC1bJ4bBX6CQwVVDcehiSi86cMu4h8wjkM8R7y6y+sox6trupAzf0yeljrPRqDFz7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/24/2026 12:46 AM, Gregory Price wrote:
> On Thu, Jan 22, 2026 at 04:03:49PM +0800, Cui Chao wrote:
>> 2.Why a Kernel Update is Recommended Over a Firmware Update:
>>
>> In the scenario of dynamic CXL region creation, the association between the
>> memory's HPA range and its corresponding NUMA node is established when the
>> kernel driver performs the commit operation. This is a runtime, OS-managed
>> operation where the platform firmware cannot intervene to provide a fix.
>>
> This is not accurate
>
> The memory-to-node association for CXL memory is built by acpi logic:
>
>     linux/drivers/acpi/numa/srat.c
>
> Specifically:
>
>     acpi_parse_memory_affinity()  /* if SRAT entry exists */
>        -> numa_add_memblk(node, start, end)
>
>     acpi_parse_cfmws()  /* if no SRAT entry exists */
>        -> numa_add_reserved_memblk(node, start, end)
>
>
> This patch implies the latter is occurring - as it queries the reserved
> block associations - meaning your platform is not shipping SRAT tables
> for CXL memory regions.
Sorry，my previous statement was ambiguous. What I intended to convey is 
that the moment when CXL memory is actually assigned to a dedicated NUMA 
node and becomes ready for use by applications is precisely during the 
creation of the region.
> We have only seen this in QEMU - and this is correctable in firmware.
>
> But if this is shipped hardware, letting us know the platform lets us
> know whether we should backport it.
>
> ---
>
> All that said, this does look harmless, and seems reasonable - but the
> changelog should reflect what the hardware is doing above.
This issue was discovered on the QEMU platform. I need to apologize for 
my earlier imprecise statement (claiming it was hardware instead of 
QEMU). My core point at the time was to emphasize that this is a problem 
in the general code path when facing this scenario, not a QEMU-specific 
emulation issue, and therefore it could theoretically affect real 
hardware as well. I apologize for any confusion this may have caused.
>
> ~Gregory

-- 
Best regards,
Cui Chao.


