Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4655C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0C76B009B; Fri, 18 Sep 2026 05:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8556B009D; Fri, 18 Sep 2026 05:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05596B009E; Fri, 18 Sep 2026 05:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE58E6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:31:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CACE80629
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:31:47 +0000 (UTC)
X-FDA: 85226365854.18.13FEE77
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B388180004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:31:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HH8Z5fZU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723905;
	b=QxsH1LqObdRLpPKQeG6s+UyB4mOXuNyv+rpjfUVoxK6BLC+MhfPOKMak6xI0KnpxBbYDjW
	yGC9dfw68+3cPQuwaVk61zMaAf/nN5RpHVeWOGEHjzbTgjEIC01uYjy/013TJJu6O+zvQM
	YxJH040CBxpUjOaZOfDm+sOMwi6UnCo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HH8Z5fZU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nebxqloBPR+qahIcZagugq7FoabEe/MUo9EvuHQcjxY=;
	b=8Tg1xlKSVVrPny2eT8LOz2PeFJwQ8+eYTBhkECEBaQH3R/YezsiakIeRguZ5SkxIx0g1xu
	wE9iL4cYTyM6V0ikpZvFCzYpHRs9yfduikRodAQIS8eDVo+CTRUSAf7VGpzmK3nz3bNPwx
	xgQ+jjY0qxVnlHoCBdtt8sd+taKsfvY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789723901; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nebxqloBPR+qahIcZagugq7FoabEe/MUo9EvuHQcjxY=;
	b=HH8Z5fZUaOgOdsgJHLxl7+8ckK7rPhPpuCjeMWMgx+smDx6CVl7bBuCoVEJ4V/foE3zhZI4pzQB26iDvOqrLDsp3kx8zGLMorh/x09acWui8sYBVlTD9FP8elQXYCVtXPfx2arTgoWsJkl0bG7CPNHiclU1P9V4je28hdjJq9AY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XBAoOVz_1789723897;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBAoOVz_1789723897 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 17:31:39 +0800
Message-ID: <31658d2e-6e97-4771-aca3-ddc60484f326@linux.alibaba.com>
Date: Fri, 18 Sep 2026 17:31:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-10-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260916093145.4022188-10-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B388180004
X-Stat-Signature: xcx7nonpcye8yyaepw7dachbrhdkhewg
X-HE-Tag: 1789723904-781609
X-HE-Meta: U2FsdGVkX1/j6eRRRDLB0exMwP+hO5VhrepzIPSTtxL/r1XUwokZjGWBREkM5Vp0RaUUfMxpaFC/ozKjH2wv1qIH+Zxr/mUNyq3b+XPYw4Fmo0UZ51Dw+MRtYr9lgebtjmY+H1PKvPe1i5U+EM2PG/hRkETRSohgq/NJPVOXKRxvOPRWsfom5Hce0+LIpGoqQLwSjvJNha2HxwXpTQKx59AAxZtTXJLnIrl1AMgE4RmFdP9Vxr9e5d+OJo2pJ9OJfruYQKracgoTghMqNF1u9OTb0ls8dOK8qNHkgPWfq9E66Uf7P8NzE2CpkXAaOvtBbwwFITRum885DvmaGPUZI4Jxn0HbrjxlqEX//P5Xo3xUAQNqBuS2jPfFu7Lgjt3kxJjcg4yjP0DOFxGZ98VJT51tYEHKpPxvj/Isqyg0UX5ppvtEmcexofabGYgXY2sykK4piiNmihHt0enYKz9g/7gCxhkBHZyKFROmTEQ1449p99Typ73SreXHYw8VU+QiCpXHvvTcJI79wDu1274KkLdDw5AwINEGkSz8Swz2y0rFfYjOZ066VzaTi/gepX19btz1jD7e/clIYEB81Vm08YzxmedfyqgPJtzoaKl7B1iMuAtmHgQ5lrdkNQ1KfqLbCXHi1izluRr4buYslA3i11j6gErWUiSmqf2F3aLUadagO8V6Qt8nQFmhwbCS8Bb5pugBjmn2QATOTDnA2m2gpxl2lgQWUaVZk9ezcTMmPvA7j5ZQOwED1MiIwm5xcPDCisEN77PoakGXaKzDvs6aRgpGkps7Hqd4X8W0xpB33GEvptEea4TV1Pb4k/IUm+KlIDPmVuE06JXX5rTF9pE+qgwcvYM02qHjGV7C2BVeWe6Mt76sLRy3qB9OMO4TnlyIBQYeH9YQ4ly0uZQ++7RI85+EUYggbgy5XZLdI8hiaA5NCTZZWEOixoZtxFBW6uCk108yEkKSit+4OTt93cQ
 3MIpCXxd
 V1P9ESBelo3WgqkLTX5LLBTuOgY41k/+A3oidZL0XBhHe6d00BC8OqKqo1C+gn0WADC7r9mTuqcTm/lxQPGtkDzzPCOhEgn8CEcQwmVfneeZwvZ6dsIWn5OZSaEPqlY7zadBwCnfE10p6EF4aSRKKjO+aYlWGfYjV7GgEVJmn0YD6HvybGLFDtUrtocf7zDt8yC9txV0smDOk0sPl2GcU45nXKpVTLtBjX8e+04PHXLVjs2nRggmTQYMhNIodROifFvqNeDKeII7tAJ9eNT8quUSMs4plmFcUuiXGI3+uPPyXDfWKOYVVKaPOv//KOitYrWoQ8sxjOCHTIsPPURfFkFonsynMTw60jEgz1SvshlGpSbFFD6PBbidk2R4CO1aNnPgjnYNRfglHnN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/26 5:31 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
> contract.  The scan is called with mmap_lock held for reading and returns
> with it still held.  The collapse is called without it.
> 
> collapse_single_pmd() kept that boundary inside itself.  It dropped the
> lock on some paths and not others, and reported which by way of a bool its
> callers had to carry along and then act on.
> 
> Open-code it in the two callers.  Each scans under the lock it already
> holds and, when the scan found work, gives the lock up before running the
> collapse.
> khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
> the code dropping the lock is now the code that wanted to know.
> 
> khugepaged's walk carries on to the next table while the scan keeps
> refusing, and ends once a collapse has taken the lock from under it.
> madvise_collapse() re-finds its VMA after a collapse, which it did before,
> and now uses a NULL vma to say that it has to.  It still reports the drop
> to its own caller, from the line that does it.
> 
> The lock is given up and taken again at the same points as before.  No
> functional change.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Thanks for removing the ugly 'lock_dropped', and I also did some testing 
with my shmem mTHP collapse, and no issues found. So,

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

