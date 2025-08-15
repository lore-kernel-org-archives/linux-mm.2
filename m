Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38916CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9B28E01B6; Thu, 14 Aug 2025 21:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1A58E0002; Thu, 14 Aug 2025 21:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE2E8E01B6; Thu, 14 Aug 2025 21:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4758E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:59:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A6BD5B7DF
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:59:15 +0000 (UTC)
X-FDA: 83777334270.12.05F7253
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5FB36C000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:59:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CC8SV4ny;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755223153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzKVb+OuhpcSSRMoVYa9IuCr7Oh6acF4Qvk0wsQHiRY=;
	b=DBLinQCvAAq1GaKcocNLWXcpRsGD+CzNoj+ZTqgQIqpRwueOhxG3Dt7s+Z3tUZcrkRU4kg
	vEDCuFnPMqakmjhBECjLA8xokQot+H86XP+NANRBwXnBvwAC6oPqf3qaxPEoUpXLBaPArX
	2zPOyGtB24U2IbzuF33QruM/759sxPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755223153; a=rsa-sha256;
	cv=none;
	b=6ai/Yeo1ODxCKkXLrLvRy+2+FZPLunfe/sgE+9GXc4YOx9aI1jgtiB+CKI4t7stCCYSRRY
	LFzS5MoAab5zxia4ciaRtzgAKTjex0P00zcSGE6CIWikSY+VUwYKKQEIz4Ia14yQeVw2hu
	IUGgv0zSMAI77QqefbMhEvr/WBHuBEc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CC8SV4ny;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e5b381aa-33a2-4537-9f71-a95f621441a7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755223151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzKVb+OuhpcSSRMoVYa9IuCr7Oh6acF4Qvk0wsQHiRY=;
	b=CC8SV4nybWBdyn4sb5Ef9djH6SombrOwQmW9xgpmCO4hNoUez8LppozIaHXhYsoJlXRzpS
	DkMzD5134Mn+VZVSjdVu7R5h8FW/yZMrUXRdIHpmRD33VcC21R2FGvVAsq/Mrhqv5jXFr7
	8Y/hMUzHHjxNTYXur5IUPLAjuDNgWus=
Date: Fri, 15 Aug 2025 09:59:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: simplify lowmem_reserve max calculation
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250814090053.22241-1-ye.liu@linux.dev>
 <20250814140713.GF115258@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20250814140713.GF115258@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FB36C000B
X-Stat-Signature: tbostas6pr563xom4xa1w1tzu3pbzsaq
X-HE-Tag: 1755223153-355350
X-HE-Meta: U2FsdGVkX1/7VZ2VxH8Qazwe4FyGU3zHkNoJ8nfqvbxkCybaJQ7VchcKyUL4zoqhyRAzgPxvmIYGvImEjJtw1baKL6fjGvAufS0OFbIe+8pDuOAWdBrpNhGWM1cnuESWLNF9Bm8hzD+ac/rjrDHNXNkZOfXi+JfFesiRXmSxB4zunfZj5vHzmAKmBeyr8womnWLU4/hfnowFpg7oWyDT01eyf+Fp2sQTEcUWyibq8BUkL8OO0MDCxlE2OcGK9hQQ+WDgbpift+GAB6sM6DojYXA9ZL0DQ+BJorILv5wA8/P1nJ/I/OXeRTyIQ+mBPGgnbPpDlor0KbYAUeZobfL/nzpogIDwYZea5LlSWXvskhH5c7Ut4uA8pmFLWFmnvjCLZUlwSkbvL3YuiM1dAc6hPE9qXYO/2sZRtw+XYTvCAzJlbvhveNHsD20uv6sqrw7689kIBTBh4P9ByW1Xzi9gvLvOf0O0KpFaIAcPAaxFHsFZD6xUMEmDpbhjePrViQdKkqUbifZwg+GdK1MGrXrXYzVg3GPWl8ASiTPiEqUe6q1w9MRDYOxhFg8I2uJCKjWio6KFo+D1NFw7StIFdkdXjDGfMO4ysz/fROnVD0IkFcQYj69aDSZtAA5yFy07jNlLTt87TKT3K3qgSfu+f4XVba/97hy6rcDliDlkCGfETHYXwK6cJi5WPv4ZE3J7BpD9uW4Jqg1CGzKs2w3N9Hii+8dNZkWIiZItckVonAJGaV+MkkizZs0mQAKyaq64J/yEKNi44SFHMznYwfK96biwlDTXi3yfOyDODjZxZ+mF/XCmfTtvLtITpEHrCfmMbijvWgBUno1XAS61wA44cap4UmtDWnj1FBK2qhlE61oX9Sb84eD34fAXjOvVA4+5x5gx39rYW/JVtxK6B2vmYBnSE5iStmcagex6zFTEVPmkQyDMpQ89d02q90p3y+xjXnhgYZZnIR9KWKTE/BO8C1G
 zwzc2zbi
 I4mBmxIHjCMjBN3hafNvkxgV+Jn+FjNeNyeskZRID/nSZFIOkth59AjxtYoo6LtSBcOsAxLCmN1Z9RH1ATNALB+dwERSBcXGzsy9UBSj/Q1EA603ySMcMAEoSJgiCwavDg1D8UzwiI6F4jxSlj3XxdmfwT2hEsVb0YfEcsNX/DUt2H7DoLNTUK+H1DmxaIDgdTc9HCqcDd45tKxSuj6pn0IP1BqLUdYmPhZuuxsmrl4qnshGNFZjwOO6nPB/qk77IyfOHj9PmxD1BDcs63+KFi/1CwLGAcgW5fiA2CFSFf17aaS5kRJCoMVMT/64zgclGtywDXuU8tAUFRgF6rqKoNXDPoxLbBD9mhqn+5q8n5LPWw50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/8/14 22:07, Johannes Weiner 写道:
> On Thu, Aug 14, 2025 at 05:00:52PM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Use max() macro to simplify the calculation of maximum lowmem_reserve
>> value in calculate_totalreserve_pages(), instead of open-coding the
>> comparison. The functionality remains identical.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> You can remove the {} from the for block as well now.

I agree to delete it, but I noticed a patch has been added to the -mm 
mm-new branch by Andrew Morton[1]. What should I do now? Send v2 ? 
Or send a new patch? If this is my first time, please feel free to give me some advice.
[1]：https://lore.kernel.org/all/20250815004917.03FD7C4CEED@smtp.kernel.org/
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

-- 
Thanks,
Ye Liu


