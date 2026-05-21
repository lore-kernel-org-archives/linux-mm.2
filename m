Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32A8CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3BC6B0088; Thu, 21 May 2026 09:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CACD6B008A; Thu, 21 May 2026 09:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1084B6B008C; Thu, 21 May 2026 09:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 048F66B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:18:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2D4C1608DF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:18:12 +0000 (UTC)
X-FDA: 84791480424.29.8C88A49
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C278A000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:18:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m8dK+X2H;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779369491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGlW8OhXAGKNCm5ixrBnlcHP1gUwh/mnEV1I5l7eHu4=;
	b=cMWrD8mcduNtAhjVphK7trZd+QS2spEHsmr5a8zPg5VN2JaF19Rc2JrK+X5M3J0sAB7Whq
	RCIli+qSKYC8JlOncDOD6tj7NDhNnY2vvwp0iY6Pwwxhseq7A4vOQmkc3lmPjFiRgP6SDy
	vXjCbf7uqhlA5Bsxd188SvS4jDZQzR8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m8dK+X2H;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779369491; a=rsa-sha256;
	cv=none;
	b=Fnd4mof4Z4Xe8mmeXJAkN7FCHTZzYgmTZj1hg1OYbNY6Pbm+PxyX/DQ/A5EC3Vt5bY7jtA
	UE6zDCIbFhXKz8viDWs6chN8ayqmeGVtCFj0povmRWM3SN3tYVdLUH525lTo+eYLC7bsLk
	WJ6QWbjedikim32Z137sxs9fMbTpppI=
Message-ID: <6a5a87f5-4f01-4b49-abdc-130165463d6c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779369488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGlW8OhXAGKNCm5ixrBnlcHP1gUwh/mnEV1I5l7eHu4=;
	b=m8dK+X2Hlp1M7QXFezf6ppAphPTq/paZieXtIi/Zjmfb3X+IzPcaTh/Er+TjqUv3VBrUMa
	CZkWXRNiKNmtGGzDnNhFLmiNM/hkyqvZ8dozNXkGcXBLmL1DoP6FWdK/ju6X5a9QSrAe9A
	f7pWpYwuGXCtY6Lzq1qPrhujv/AK6YI=
Date: Thu, 21 May 2026 21:17:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
To: ranxiaokai627@163.com
Cc: leitao@debian.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hughd@google.com,
 baohua@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-2-ranxiaokai627@163.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260518123238.56344-2-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4cgzkf69rq9f9x6j3hejtoqkqt91nrbt
X-Rspamd-Queue-Id: 9C278A000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779369490-815191
X-HE-Meta: U2FsdGVkX19uGn2z2VKsh2N4Wskut7tWec8VZIbU783+x2m+vx1xfx8QRxkE6HRp1dE4I6nAoiE/ghNniDhve207JpIIU/S2d+PRD00lU1m7yiuAb4VZ0vsbCSEguU6G0br3/9j9z4EJ3kpk5drboiAzZ6NrBeA4sAkkqlaI6h0Bbc5t76U6XhHftoJb5b+hdpvhxhyPg9vAdlsTXCWzBbqPwDi1YdW6gb5THMgvBV2+xMU+JE8GGFT4K2+9U+RbpHTEJ5ja4QPXIRYw3SQ65l44YuV/qev1qnW4cfqXnWCMAyUCumsGvRlcVp185A8BuKgFSInSeABsRZ3+kMrBJdf0tVo+AkvSOVCEeXSPhwe4FCuALRNHUbCDf/nDqpOLFmFvcv5WIQGyd9FN4KXm6YYNoz8gpTY87hslqCFxUZfICliXn9vbKs2uIsMyJHgVjpHpKhvoc4O3aPxiYm1rrLqYotvQuZREhOtiJV4a2yZAp52UKPUFgYkD7xJxGE5scU0iMkUET8hv59e77gz1mQlgltlUyapHbDdyU4DJ5dQVvjJu/+dCi+h/QRHoGaanAXGv71J4EfE3Dz+hBm+OwjbAFge/3K+fhOWAUiaXlDuziMTW7DWPKaj/DNqRTO5+z2Gimk80N3QATmnAB5tOGIoi483ScqusL/inRfWCNVeqqTOs1CzldbGBO6Cu9DRAsjMjKRFGXYA7d+afJ7t4wu6tTiIhOuKN1DPG6yI6oBLGqueoMs7F6ULctXiIi3+uVOrkTfe+OBd0MV0Tog5hez1/1GwHyhskkF2ESuQwvndhKPJo+aRZMGYucsObBhnaYebgBXuTS9kMSzhDyoifl6c5wU+ukuGvVgHruHCCJs8kxqTbaR4bQVGFH6lN7K3UoJ9JLS57NbfLG/8GCfBZA9bG4iDJ0YdtjH3QooKjrPcGj4lAcrEk7PqF5i9A6LbJQAMloqeS4xw9tJO8p04
 kBpb6+TL
 Y7yfgj5uvQ5CpdAuQUrY7NTuHp8gP4nHDQu1vCEOTPrsOUOQO70Lo85Sn1F6mB4g6QyZGGShHqwyVDfbB4fyis9h93FHW+X/7HRV+NbECtur0iiyJV40kVt4bFQtXu/I9ttM8SB2ryEYJ65MxPTBucwofq6WfIxsSP++opFi9BHaWYigDM5snwVIQg7os+sWgZepGrOXygt9zYXptJb5hnaLLqFG69F/LeNAvLaRPznQxixw6dVq8J7pXzsSmWDuuUleP4rXM33YK3ZoTblF15HIKRK5CbaqADbcceM3g70Dz06wVd9DR9oHg0/dIUdcBBH96cGHxUCPTetJrv70MU3rDVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/18 20:32, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
> 
> Behavioral change:
> Call start_stop_khugepaged() only when the mode actually changes.
> If unchanged, call set_recommended_min_free_kbytes() to preserve
> legacy watermark behavior. This avoids unnecessary khugepaged restarts.
> 
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---

Thanks.

Tested-by: Lance Yang <lance.yang@linux.dev>

