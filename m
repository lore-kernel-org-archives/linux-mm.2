Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CC4606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I+ke6zdQ
Received: by kanga.kvack.org (Postfix)
	id DC8B66B05B0; Sun, 22 Nov 2026 14:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79F26B05B1; Sun, 22 Nov 2026 14:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F866B05B2; Sun, 22 Nov 2026 14:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9D876B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:15:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23D5C806F8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:15:21 +0000 (UTC)
X-FDA: 85463708442.15.F27685D
Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0E2E140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:15:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I+ke6zdQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.99 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795374919;
	b=pwJxNQOeegsaqBJY9gG3HIhRX8l79Fzay9JrnXjvcqZ0Mi+yvZeGo01nEz3kekuBYvEq8s
	iQU0Q+v+/Hcdxy8AHPfd+P+R/G+qR+rfUNodJauGE21JUZqAxYc+4ja9EM/z55zodz1rHz
	ripADuIuETO833i9mZo/bQH0u4DFnpU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795374919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqurIDgbeEe2K43Zq1XV0Q8E+eXK8AG7Zt+b/v9C/ZU=;
	b=khZRZk3umwkO5HY7wn8orrbk+pGMiowpcu9EPHVtlKfLFE2I0MRI1+kUvK6cBcnIJZp+Ys
	vrtP6xA7am/F5OacHUC9WSj3FrUh41mQZB0uycL/1jtbIX4t6TctoNtkZgYwhCWmmzr32s
	RdR0x4OQ61nEcnEofzLkfIDCvEnXJC4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I+ke6zdQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.99 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LcJnLrBE/05Yu8bxeXg4dmOsRNfKSgLvD3cHJQIgLZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795374917; v=1; x=1795979717;
 b=I+ke6zdQ1G0LKD8eSdZHs5yHzPM93jDOv3pAD34cThH1oBb1m+n4nANQEmI5524awhYTHQUD
 FvZbbtywt9eLRvVXQQCcgVoVNymseKj7KXXqLcIuziUBtQtz/QjeAgpDr8QUUz4G5pes3Gc2Vum
 ar5N21e7SrRJ8dfxaZKuKQ98=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 576918abaff7db61;
	Sun, 22 Nov 2026 19:15:17 +0000
X-Mizu-Trace-ID: 576918abaff7db61
X-Migadu-Flow: FLOW_OUT
Message-ID: <8e2b160d-0a80-4dc6-8a28-3c7a19f1676f@linux.dev>
Date: Sun, 22 Nov 2026 12:15:11 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: honor VM_SELFTEST_ITEMS from the
 environment
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Tianyi Chen <hi@tychen.cc>, stable@vger.kernel.org
References: <20261122-vm_selftests_items_fix-v1-1-9edef5e7975d@linux.dev>
 <20261122110211.81cf2fbbfc9048264aba50c5@linux-foundation.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <20261122110211.81cf2fbbfc9048264aba50c5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0E2E140007
X-Stat-Signature: zh45i4m4xrcph9gnyyj5w6u7wxzcw5ms
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795374918-191549
X-HE-Meta: U2FsdGVkX1/yWhTwbBDudVHOgOXO6yI3m/DhMXDA6qnoph5zWzUkcNGGkSKF3TZx+RQhCl2jjzgWIO7TRROaxGXLVInJ+vDy06AQmALXg4kEPf+4FBhfAXQYIk6CbOcymiLqKOxen9bzFvpqVzCkoV6/CQCeBtEkpb3YnZHElVOd3uFIlDLUiSNgSPbD7ZZJALLz2nS2bJUVDwT9xM9qge59PvEKWAgxXKuWs7B+wPrpER9GXhho26eHXbAYr7Qpa4eXCt3FY4w9U7fDR6sXnGBTXHfBg1J7Xud4HwdEQYpbtrrxL7ewaMUqxPcnlwRhCA5cF2wDU363xHk7EA6/bXaWJ2mpabNZ0FKy5OSoNZKkwLf9QQu8AnoBoONK0TYuQgctGf4YClTzc2NTUdbFpdMxvDnw0kmEpwdUimIi/xTBg3iPclEI8p0Se1UN7yyV0Bk2F16U9F5ExoZ7lA4lbhg5fscYGR8Wy3XJotbR4Af/QP6PTfZGwprbQ6zZAezrNAT5OCi915XQMrtWvl+ESZ0UYlmLE8EGQZzComJuC3YQeYDv2Ddq/uAkPofOX3cqd0YJ5gRYsaMY4kER0sqi6rSBdZeTvGDFYntHJZSZszscdl1zOuaYKB4R3uk9tZdsIRUlsKWI68IWDxeQB6ZsCIBeQHwAkF4lYmePHTY0PCxoWNURgaOfV1nsdQT+vArUxvKMU4h4dI0JI4RVMrBn3q6e84TytmY5/Frc2pRZ1Sxt/+m2Nw4OpE81wWWZR1VqZSfiSovPG1xO0lNIxB75RVvv2l9RDJFS5kI1bBScZ0nTS98BLoTsSsGEcXOeteNUpGuDIUj80uwzf7mKAU+CHPu/KhXUzAi9FeavbWNfti5moUJcRdyTcRcd349iy4dXKQEB6QQCH2Iaoo50rmJ8rZJP1zQZp5wcMNGtcQXU2h8boZXT79UF1hRdZwneMUE1VLwYnJzoCkwyrv3jorj
 KB0ZJe3L
 0MNhSlnvLf/I/u2IrqgcvOEXEMSwVBdjsAvg1vSEpFqhwHmMB17u0uOR+sT0l34QPPMOtX+4vmDMr48hELbStJMScN0TxKGRz3vUgXXs0NqvxfOVSI4n6+pGez1Vmhs72uDMBnH4hL4e+RNfm+jVavV3NLlKiqL60HEuyjK5BEtPg5yB7YJWMhYRpPUOK9M51i1806dO7pcfPE228lqVzC040vPy0Upji0ViHGTKRHf/H/cgXcH2wIVsGHGkW6EiS1d5o6twqwTIn/fC22/i31Z4hvMWhHwk8jcWEM87ZQnNaysCsF51INR+9L2R9ZyPSd4CjCGwpUYjlR6w7wgjlACUioMAc/Bu/+Di9/zYiASFJqyekfQ4Nk0IocuioV1expXUDeX9YaUa0v0VQsFJahndogqT/z15zhjkUpHM0k2R4xIj4kBgeyPvGhXuBJvFjceBUk8EmLxd5AxL8yOAlmFL8cv0CTHNlEtoZ0tHwrox+oYu089YChUEduFH9vuDuwywoQs0o0rf+JNd2xvpduFneLTZnbMbsapRJPVbsf2DqaFcrMISagNut1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/22/26 12:02 PM, Andrew Morton wrote:
> On Sun, 22 Nov 2026 11:50:36 -0700 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:
> 
>> The unconditional default assignment overwrites VM_SELFTEST_ITEMS from
>> the environment. This regresses environments that use the variable to
>> select test groups: without -t, all default test categories run instead
>> of the requested groups. The -t option continues to override it.
> 
> Oh.  Is "setenv VM_SELFTEST_ITEMS" really a thing?

Thats how we've been utilizing it since we added this. It was the 
easiest solution for our testing infrastructure.
> 
> afaict the official way of doing this is to use -t.  Continuing to
> support "setenv VM_SELFTEST_ITEMS" is perpetuating bad behavior.  How
> about teaching "environments" to use the official selection method?

Ok, fair enough. I will look into switching over.

Thanks,
-- Nico


