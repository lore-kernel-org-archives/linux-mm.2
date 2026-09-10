Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F04C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 01:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159246B008C; Wed,  9 Sep 2026 21:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3446B0092; Wed,  9 Sep 2026 21:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D1C6B0093; Wed,  9 Sep 2026 21:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C970D6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:17:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E4ED4039E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:17:28 +0000 (UTC)
X-FDA: 85196089776.07.2EDC363
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 44BBC40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:17:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=p6733vXn;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789003046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IVJH8MPwJAkeuj2dMMiZHrS4p/p8L2+EkoUpA5hPNI=;
	b=lD1/zaA0urFHHIWXaCEi2vHv6/SR3zYMmPKoFrnf4GOdn8dGAZ6NdIaSq4jyLD1LUlPPmd
	gP/IMbXVrFnK4DuRb3V0S6/KRiGpJuvdbjr7db5E0LVEkliOQfTZ21UEg4faKrVshI1qHu
	paqp+TAEOt+zxYnDh/TWUd8awoqp4ak=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=p6733vXn;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789003046;
	b=SZYWamKj1N9FYQ7A8QxVfWI8ya+SvDzGWfrj+tNQ3hCK9Nr64wQQfRs3YCK72OTPeznsn3
	KV2WPaeECUMgxeGPBA+v9B2XTokQVfA5FqYjEYfxGytINKuEuNmgjSGdStZFWDkuZPmfJM
	xThGTjTkG79d3NgYKjPrh5LSPq3xOB4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789003042; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2IVJH8MPwJAkeuj2dMMiZHrS4p/p8L2+EkoUpA5hPNI=;
	b=p6733vXnaxnNV/DL+umHCEwzQM1WfBhHAB8HYwIsgMMztIuNm5L4cn+fVr9gRC8FwmwGoEPjgB39rY/mxAIWhdM33kqMVksIuyG0X/Qjx/XP8wineZat3xYAw/PyRIN+/Bhp8u3S6TdnQIx59o2w1qRVXePcNwL6LBqVLoD4HsA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAg1fiJ_1789003039;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAg1fiJ_1789003039 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 09:17:20 +0800
Message-ID: <d65b4d23-b9d4-405e-84f5-a814fc984ebd@linux.alibaba.com>
Date: Thu, 10 Sep 2026 09:17:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/19] selftests/mm: add khugepaged completion barrier
 helper
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-11-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-11-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44BBC40006
X-Stat-Signature: 57s7wzbc5frq8ezhqm9rfcawik9jpehg
X-Rspam-User: 
X-HE-Tag: 1789003044-9214
X-HE-Meta: U2FsdGVkX19OsUPPVdpdxTnHXYGyHcSzKuevIO0cXg56Wwh3vt7/kIWHzXyyB0ivwaJ8uhLOOaPc4FxW9NZgzr4lFvkfNOuF999+xHTPU5wI7cpk3zwm3ZOYZLCIxHDf8D1tG2WUm00m4Hzg17RQM+Vj0oSJTRenIJcOVYQktEXGcXlGPP25wbLRl9wjzQBtBinMY2fqNWgJq4fNMlqcD5ivLQtbTEjp8ZobpgqXHzEid90V5QBQ1kJ6ftxRA4YJDoESgOc5x6xUtxKLXD/cVLX7G0f4n1p2YGHPiGIE68LmoQONKNHvLs/oDsTEZznp45qtlq1KtF5X07pjsaOwJrVxmC7JSw2KO0Bbc86RTwk8uNdoHWTertn61F+Lji43sdjAprBqVWcBYH0BrtiSuDjDhe9l59+nVvXF4qaQU2boRf9i2NinmvQla/HUHdqg0GGFus31B+XrQc0H1VwkbNeMFc7MjpTdH0lGU2JqtOUDNlyVp2g4zQ55ZlN96T3dehj+dfelYptiza/8TuIOMfpP3ou49RnRWZWyUtcFtLKjZ4as2ybc0O/uXv6b2M54CpygqWLhGLZCmHIm/bPyVEvta6mkUx+hTMgPleUEBWYBh6cQgqsACWgAxYxiRgm01HY4RWoUngHULwPG5JhxZPJuHM9WSH5lY9jEU4X7ZgV67psRnsdyYvmtPVOBhoGXbk/Jx76Xn/3LZuWEZCHM523/2hyQm3MCnlaoOAc2OCO4gft/dPuq3VFWHpgK/0N4xCagLQIl2PcVVgtbp72csP0U+umG2jsXVQahWeoJ4osF0X6RfvbObpPMggEI9KMQA2JvbZtDdYh+yjftJQl3OAmWQyVQgLnCQ1kTRZDG/u3Ex88R9jCqYpcZwPvOsyT5kW41O0Tq8CtrnmH3TYEzftmGdhut99K4KbQMOhlbuPgALmDJG7t/XghELk51iGvwh+JzzhArCXJUBHzxtkz
 Bwl5kMYb
 hutrOnc3diEkVSfnfv+pAolMHrLDY5ZzAyzOE1UdeqLfETbgqLE1ltMcGV765YcVeyAY7kipLomhvjgZPHm+JYKqVqbGvsJX5kdZMFTOazVfFYUMvtrPrpSBkZwvNnJNHP7eId4hfffrd3JpxJ6+fBso798//mOyZRvAWCBrPp/11x8p3KeBN3JkjJP+MTnZK+u9DajSFvgUL6vAFc+7m0RHJKpzUcq4DLd2Eg36aKmjL+jttEzQad0C/VdTjdDcTfioKJJ3up3+IdlT6zgAYu9PkQtremhRuOfX6HCTfRnxumwTfCnSPYTk3Tyfz6nULOXCGI45BUq+E6HUW34L4shCB5ceNOCRFDWGyu2zQ7tWXmRNdXzKofq1h9VEVGPEbh9/n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A khugepaged test has to tell "not collapsed" from "not scanned yet", and
> nothing in the selftests can.  wait_for_scan() in khugepaged.c comes
> closest: it polls full_scans until the counter has advanced by two, since
> the pass in progress may already have passed the test's mm.  But it only
> returns in time if scan_sleep_millisecs happens to be short, and it is
> private to that one test.
> 
> Add khugepaged_full_pass() to hugepage_settings, built on the same
> advance-by-two wait but driven through sysfs: a store to
> scan_sleep_millisecs wakes the daemon, so the barrier completes whatever
> the scan cadence.  A store made while the daemon is scanning rather than
> sleeping is lost, so the helper keeps storing until the pass lands.
> 
> One wake completes one pass only if pages_to_scan covers every mm on the
> list, so callers need it large.
> 
> Settings pushes must not start passes of their own.  A store to either
> sleep knob wakes the daemon, so thp_write_settings() now writes a
> khugepaged knob only when its value changes.
> 
> Assisted-by: LLM
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

