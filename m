Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AFD608360B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Xxk+Rn3Z
Received: by kanga.kvack.org (Postfix)
	id 6213D6B05B5; Fri,  6 Nov 2026 04:32:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4566B05B7; Fri,  6 Nov 2026 04:32:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7CD6B05B8; Fri,  6 Nov 2026 04:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30AB96B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:32:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD8AC80CA5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:32:07 +0000 (UTC)
X-FDA: 85404177894.17.D9350C0
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17AFAC0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:32:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xxk+Rn3Z;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaIe5Wr+Y328ng3DOApERKuc976xe46hLddSwck69AU=;
	b=cQCGUXaZe59yPPd9wKvj6R51dSN78ctNQjzeRC67jU1KTKWifNrAlvYskS58h8f3OcGo/B
	6n6hYvxUqIT5FgcO1tQxx+8b+cCx9tw4hzPivf664eU0s5Yrv2OKnvFw5oBJiVg+ny+PWs
	XRkf3Mb0EKXfygkIuGYcq8qvUPDSNQ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957525;
	b=olYeowARu4PPyX4LUp8LDD3KRa1LOdg84kLqV3iQekyHa1GZnbaNMrOOV097RrEHfLtI/p
	uqI1t1e+F0A39PpIIIVKF/IOUX8bYa0/CkhfC0C/5UNH3KaMTZ9bcrcGCZCs0jRRcoIRSp
	XLxyj0HJ3AUr3JN7w5w5SOPiit1cMiI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xxk+Rn3Z;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793957520; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WaIe5Wr+Y328ng3DOApERKuc976xe46hLddSwck69AU=;
	b=Xxk+Rn3Zpl3YHFyYQm9Aba3Tq3WEo3rYPE6FBPpNgxdXI1Wh4b328+R8WgkOwqmQySxWAVsjTA12mCKnLC4mYPVwJEmBVhe0fLlLADsF2nlehGiX7dPVyinZxqXp1B2/pA80zH8gX8gDKU7ZjUPAP+fWuMrjAGUcjtCnP5HtD2M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEBFSv4_1793957518;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEBFSv4_1793957518 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 17:31:59 +0800
Message-ID: <daef8492-d3e7-4a73-ac52-2b4400825b6c@linux.alibaba.com>
Date: Fri, 6 Nov 2026 17:31:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/khugepaged: scan mm's more efficiently under
 mmap_lock contention
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-2-4384bbfe4606@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-2-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17AFAC0003
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 49ni9hsyoqeujoan4qd1ciss5ijadhj3
X-Rspam-User: 
X-HE-Tag: 1793957522-42347
X-HE-Meta: U2FsdGVkX1+K8oIcFvWcVR5GBqzQtKImNe7vrly52o6/SIYk0E94X7Pap1Yz5mkbKiFxDJT4Gs2r34WgN0w2+yCQF7HfZkuX0YOQDZP/n9odsiI6/22jKJa5f7BiA7/jPvKiix16rqkgn1vseDPAhKuCqQSylGiYeWeXNNVzgd4wpXjT63YvXsmis+kBxaD2FNHc3vD4rBoSa+lS6qnn9BN3l3dnc5yAYcpwziNE1/S0MetAG+y+0rORmif3Vbf/Des1wNYoV94V4ezOFqtc2MVLYremhTwfJ8hh6ldpTkynSOgGlMdMHhLKjb7DvydBQJh/EKQZ0EbpRKeOmIXGihiwXA8lFJEUrH1lPYBAP/gs8XKKb8/rovpiEOTN0lUXYArTWIzWNftmXn9BUChw8Xp3yEAUp4YYSIC6Uv3cVh30nsIflXfF+pZJYsAKDAl5xyIuZbOqzUEKrRVQX8IqwSGrbp1n4uZ2t6dgvCEaGGiI1c+JNbd4C6B/2W5GI5hqJOFRyXvipxtCHgsdatKNdggE9CP5BZ1W2H5SWfLy+WNcfax3CfvZ3pUHmPfCqFnHtDpLBF0h+IcPFY+qXSVzEx4GNhuTRHcPK0IfvhTJaKrlw0AVwOuMReGl2ctXDPyU86ScYZrKBAH8K+hoz4chJ5DnGf93gkGXjpVeDUdlC4aRu8wnP8CooqBmCUVfkipYVoVEmepNwoUrb1L9H0VxVigeyWqGLdIndRtgoAxQSzsat2uTGKZLsq/e3aPTBJJNQpP5FPk5grbYZ4fzN7wzJry7oPtg8LnCia8MthIw9Nd+L1HL91eqrbfJoAH82iBw1OW+O6+wWbSP9PDFmtHlUGmjhFqZZn40JN14Aqyt/Mp1SJyFm8a1KYfsFrnXd2D/HLl8KA7sC1Xdgu4hcf8VjYEmgVS7WgFcuYzBBqQNgPS8c4YPJKEGUt5q9EgKMB0DgqGMyoTIh2bkdJFAbrr
 oPcOn/XO
 NHd4W3RAh8uU7k7JtK7sLKLHjL+sBYo7MROrlszIZHxSz+MQ1oKm7uhnyBFdmm2SIF44LDnAY/n71LFptaelLsiqGpcpeRosss1PMmNLgjDKfAAE9H0d2WO4kN4CxAD5VaHpIVvbSFrBOft1vj66zQorHj5onrwHO7qUb0LMU2KW3GI+JPVNTRbW0dBZST7dCEs3/CxhH9wBmesUrSp1sN66fVR604DOq/w6zqRPfLPyfD5FM/F8OtHYmc0Q+A4IzRNQn4R5EYz600tFMMHWD1qBvkdmDo9KI6iAaRHIj7+oXSTUq4fSA4YujOk4CMj+Z6jGly39uDtF5zg/hX09mo9HuQs9k6aGG+K5Gx6OfxO7g3ArFD0npfQxlyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 4:57 AM, Lorenzo Stoakes (ARM) wrote:
> khugepaged scans VMAs in collapse_scan_mm_slot() in the same mm until it is
> about to be torn down, prctl(PR_SET_THP_DISABLE) disables THP for it,
> mm->mmap_lock contention occurs, or all its VMAs have been scanned.
> 
> When lock contention causes the function to bail out, khugepaged doesn't
> keep track of where it left off, so when the mm is next scanned, it starts
> from address 0 again.
> 
> If there's a lot of mmap_lock contention this can significantly slow down
> collapse later in the mm, since the /sys/.../pages_to_scan budget can run
> out before the end of the mm is reached.
> 
> The budget is incremented (as tracked in cc->progress) at a rate of 1 page
> per ineligible VMA, but the budget is only checked once eligible VMAs are
> encountered.
> 
> Then, it only takes the combined total of ineligible VMAs and eligible but
> non-collapsible pages to exceed the /sys/.../pages_to_scan budget for the
> rest of the mm to be skipped.
> 
> For a system with 4 KiB page size and default sysctl settings this only
> requires 4096 ineligible VMAs/uncollapsible pages to be skipped before this
> happens.
> 
> Resolve the issue by simply tracking the last examined address in the
> khugepaged_mm_slot object, so when the mm is resumed, the scan starts from
> where it left off.
> 
> Additionally, skip to the next candidate if a VMA cannot be collapsed.
> 
> This issue was noticed during some work in which an mm was instantiated
> with a large number of small VMAs under significant mmap_lock contention,
> during which collapse was observed to take 10.8s. With this patch applied
> it took 3.6s to collapse the same mm.

Nice results!

> 
> Also, while here, update a couple VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s.
> 
> This patch is also a prerequisite for the next patch in the series.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

