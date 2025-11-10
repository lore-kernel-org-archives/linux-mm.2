Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0768CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAD38E0007; Mon, 10 Nov 2025 08:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AE18E0002; Mon, 10 Nov 2025 08:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223AF8E0007; Mon, 10 Nov 2025 08:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0548E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:46:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B48A0140D33
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:46:50 +0000 (UTC)
X-FDA: 84094822980.21.A4D4D13
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86B98C0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:46:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762782409; a=rsa-sha256;
	cv=none;
	b=l9fIF7NvPh7xkdCav6My1cVmJelxVz6tBqunGIPJfrCE+OTiD/6T1cjw0PdHPyZpIhybfR
	amE/r4QVSLq4O7LIHEVcWjHsnea9v7S07wfBDjflNYscnltj3yqrBJq+XPQm+Zmq9eeedU
	vMlZ+j0OS90u9uRFhKcjwIT8Pa5KQ9s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762782409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDLLB1M6WLciY9qjz+s2OgBw+gv+1lWn40h7rXt0cPw=;
	b=Zz+T/dEkWFCMkNcZTYOq3pmfBiqUqGZRjg3wVFB86Pq/G/iWXqyi9KCKIO7UpWt5V1MLQd
	6SNUJmfxQClDfsNx/uEHM/ddAfwZM6GL8pFsK2C8PJapASiWBBMe3A/4LboPsxPPb1njie
	Cf7lRIZYneRaOyHViwvkB2enq6rco58=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 171C42F;
	Mon, 10 Nov 2025 05:46:40 -0800 (PST)
Received: from [10.164.136.34] (Mac.blr.arm.com [10.164.136.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E67353F63F;
	Mon, 10 Nov 2025 05:46:42 -0800 (PST)
Message-ID: <4ab54ae0-2607-443d-8698-788d8e951bdd@arm.com>
Date: Mon, 10 Nov 2025 19:16:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/khugepaged: return EAGAIN for transient dirty
 pages in MADV_COLLAPSE
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251110113254.77822-1-shivankg@amd.com>
 <20251110113254.77822-3-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251110113254.77822-3-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86B98C0004
X-Stat-Signature: hiyfo6i6diun6r4xhqfzz9si8u7w4jr6
X-HE-Tag: 1762782408-829506
X-HE-Meta: U2FsdGVkX19KVip77FzLon07vX8NujVzZFIUx48EUy1qczL6aQCj0xs3KF3UzsFaOzLAPkIGPWPvEpSmU5tXhyg/6zciB2sRHEqgbSaWX5oYf4IExSDwUPMkUbpxZ/jmf2wFvXGEoicVVSWGWa6QWaY7Q7mNXGGqims5EvnnLyMviU+CT4ZpZY8L/jSB4Bj7GkP+8JsT5nOvAtzbHuY3eUjrm2hlM7pCJGWC3DR+L/1QLrrqdSNEPmwRhzlT0HC5NNyApJ3nCyPbrfUGQYZnhX9cMj1PP+kYjEAc7SlZhj34TCTDnlfdjLK4ODpWQUpE+UbfeFDL0uDP8O5DZ1MoBGzusg6RTG6eGZFkM6lG6vJ8ZbT/VB4CG7naqblldTeFAIJq3tSx4ADDhwFbKvR9hrbJwtPwk1hxPmmgaRzr2AfC2n1m+TSNstU1k1W1bMtO1HsxVznfNJT+eUC7N1qdh1Cgzg6eVK5Z43R2Z77QF2nltuR6DhWqDuy9m9zVwuLGizw5n80mIDkphgB0cEHS4iVeMRP6fVfSle9PNxs3cqiJmScWaUbXDQLfXwvCfMJqHGIUL9Lnt098yYpVZAc3+TVzGrnggYl/Y5mvY6p4otfpvgWBnAqf7MMh669zq5kj1iB/Wy4UJdYlPssGfbUkUizpwgYbEpb4vaimzmilu4XHM2YTd3RdLlTK/4yp6X36gVkeJ8BR1XI4/bTl4jVM7tAwgoCwVGu2wUsIZiyiD4nGPqDIwgLenk4q+N4sV57AosLHKTk24ZYC47TdNrYL4+3pZGrMRrRT1LTQi02BB2UXcAAVpQ2KQBiIZhwxt9aWVBs/QXnvH0Y5Yl8hDOPtjztmmIudE5a/nRFq+5eSRKDKwsq4sb11PEGNHtSYoUtyZVVw3X8jYTFT2j6mGC5YJbA7sG3wSGMAOY09SWknq2ff1hUH2g3za8EEYuYVtqmtdOV8Ku/p8wg8qlzdvFr
 59H37M77
 b+7pU0ubFiNaAMCVXJGrEfURgs/5e0ox5mN7qvFqnrtD+pi/H3MwfeGeJn+K8BXD4mP0BmeLn1Jc8KExB76jvXW79c5mxI3EdO3p3MSOCDSlBtA/9X5phiJFXRerTR/cNVuJLZekgvhBlkKCSgH1vLoRi+3NB1T10AoyZz5XSTFkBkLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/11/25 5:02 pm, Shivank Garg wrote:
> When MADV_COLLAPSE encounters dirty file-backed pages, it currently
> returns -EINVAL, this is misleading as EINVAL suggests invalid arguments,
> whereas dirty pages are a transient condition that may resolve on retry.
>
> Introduce SCAN_PAGE_DIRTY and map it to -EAGAIN. For khugepaged, this
> is harmless as it will revisit the range after async writeback completes.

Taking a cursory look at enum scan_result, I am sure there are other error
codes as well which redirect to -EINVAL when they actually should to something
else...

>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   include/trace/events/huge_memory.h | 3 ++-
>   mm/khugepaged.c                    | 4 +++-
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index dd94d14a2427..9014a9bbe64c 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -38,7 +38,8 @@
>   	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
>   	EM( SCAN_STORE_FAILED,		"store_failed")			\
>   	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
> -	EMe(SCAN_PAGE_FILLED,		"page_filled")
> +	EM(SCAN_PAGE_FILLED,		"page_filled")			\
> +	EMe(SCAN_PAGE_DIRTY,		"page_dirty")
>   
>   #undef EM
>   #undef EMe
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d08ed6eb9ce1..7df329c9c87d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -60,6 +60,7 @@ enum scan_result {
>   	SCAN_STORE_FAILED,
>   	SCAN_COPY_MC,
>   	SCAN_PAGE_FILLED,
> +	SCAN_PAGE_DIRTY,
>   };
>   
>   #define CREATE_TRACE_POINTS
> @@ -1967,7 +1968,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>   				 */
>   				xas_unlock_irq(&xas);
>   				filemap_flush(mapping);
> -				result = SCAN_FAIL;
> +				result = SCAN_PAGE_DIRTY;
>   				goto xa_unlocked;
>   			} else if (folio_test_writeback(folio)) {
>   				xas_unlock_irq(&xas);

Now that you are at it, it would make sense to redirect this folio_test_writeback()
branch also to -EAGAIN, and call the common error code SCAN_PAGE_UNDER_WRITEBACK.

> @@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
>   	case SCAN_PAGE_LRU:
>   	case SCAN_DEL_PAGE_LRU:
>   	case SCAN_PAGE_FILLED:
> +	case SCAN_PAGE_DIRTY:
>   		return -EAGAIN;
>   	/*
>   	 * Other: Trying again likely not to succeed / error intrinsic to

