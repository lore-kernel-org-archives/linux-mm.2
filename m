Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD722CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C39A8E00A1; Fri, 17 Oct 2025 10:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374478E003B; Fri, 17 Oct 2025 10:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C4F8E00A1; Fri, 17 Oct 2025 10:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10FAE8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:51:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FFA2B6FFB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:51:15 +0000 (UTC)
X-FDA: 84007894110.26.29863CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1E6A40014
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:51:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iHZQKr9H;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iBgvSFA9wqQN42AVm4tDtxe28Jc5wuc+NIBnNh4EXQ=;
	b=Q90RjLIh6RguOBWymTx0k5hdWkgY1nkKu68v9DGYW5mbT0yYnhIP1Z5+HrNu/6IeQhHEHT
	oxLjuCp9gZPOwgrBdWq2aRE9yBhIyyPlZYCgPSAgEGgLCseBPdZJEwEKdf1NLCk56O+svr
	69vyHp4oQKBIvukgBzBunnmvvM1OsyA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712674; a=rsa-sha256;
	cv=none;
	b=ijaS0vrftuRbYalckrFI0lPypf6rLgq25pMAnBwm+G98+rw5Bd7DTo7YODLpcjqN9NvaCB
	7E/ww24BqyoY+vcPeBF/WC80GqC7+QEtZnKZ2dntzs5X6asr4Ezj4jWocRPSdkmQBHvhOt
	ysVNvemy+voTEaZVKS8MfZzAlDnCTU8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iHZQKr9H;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2iBgvSFA9wqQN42AVm4tDtxe28Jc5wuc+NIBnNh4EXQ=;
	b=iHZQKr9HtKiMKEzakFZoHIAIoXZnQ5Ab1VAd9pUL2WobM0YWIVFjy/gMGHzehPjQGCvM4Q
	tjhHZC/PKZXdt0GszfROD1ouRtlbvlWzYAYQCAWnwUG1LLMiFlyPsfWwqZkeQYuulb5N/M
	VYmvfsTn/lzRJeOP/MGbS/OnPq91HOo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-5Vqg52vFMhKqn6iP4ELsRw-1; Fri,
 17 Oct 2025 10:51:08 -0400
X-MC-Unique: 5Vqg52vFMhKqn6iP4ELsRw-1
X-Mimecast-MFC-AGG-ID: 5Vqg52vFMhKqn6iP4ELsRw_1760712666
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39FC41956095;
	Fri, 17 Oct 2025 14:51:04 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.82.94])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2063A1956056;
	Fri, 17 Oct 2025 14:50:54 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: lianux.mm@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [V2] mm/khugepaged: fix comment for default scan sleep duration
Date: Fri, 17 Oct 2025 08:50:51 -0600
Message-ID: <20251017145051.13842-1-npache@redhat.com>
In-Reply-To: <20251015092957.37432-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam05
X-Stat-Signature: 3aigq9cwypz3kdbqki3b3g5e9hhqcy5k
X-Rspam-User: 
X-Rspamd-Queue-Id: F1E6A40014
X-HE-Tag: 1760712673-827450
X-HE-Meta: U2FsdGVkX1+XKRi3LbT8eJ3fhftdCFxBXiHhbdKhPoGcLeQcv5zdy3uxmmcCD1LyCpMuM0Ypq77jh3gpD2p8im0zi0JqHFiij1jUUVSQczXTs7/e7j7zagCEYmSycvZMpDIJ69AvKWldNIJxNXLCAe79afp2clbpLC/D53vimbbO5VMuTmDjdb8MvHbf9W5DQWDCrXX2uxbGxvpSXuBqapRt/R45OcZ80NVWZfpFHxfSqusQgGPKcZhPprvxlaoBiMWZCXCOJqLaAbR7GTrkHiXIidaaypmc7Sr61YVbcNKn4PIVrx7SPixzbEV8eNZZczmv70YyUzy6uC5hSz1wpnDazpGtR6/hXGmuxoHzZ7yIdOvbaCBlpk//1FZmGnvFs9NowKwGYugjFl4+l6fhlyfSbN3YYy8QPSnj/R1NQnqC8+dNNKx8LlzB0/SGd+tSsC8YZcAGJYRJCI3a1MB/PkIdAMuy4Jy0uYtjevkEiT5PeBwv96cdRUJSAQFYUpQFeYE0z8Vq1PRgynPy9ChSw+bmwHjwo8Qtq7pBTUl7rjRucLni03vz7ReqEjP99nrkjdPepR46Sa6KACh3E2h57FSlF7htQuHcDwDm7oHnuzrTYBvj1VBwgO4MzyFzN9Y0PGwZ91zGC1pQaX0uH++IZwU//bcJqJ2ZCTPjhU/6x4pm1gAvhqsGXFemrbd5LVqnwAwTdQsuG02ghpVvvb2B38LyO2XwpY2D4Kijuhq1i2rVIFiAw6QihkQEeP2xV3sC3t8pgU4tET2ZX9UEDderfy7XokcAheRQItOR02fWd06guUtjd2kUqY1CeS9Ej94ufRh4RQdYqVplA3qeEFYcssxZNBNIQb+uAocnMpcevXz65LWqjCpBD9nFIQtDE1p+k0twzBcTzDNGmylgqBbbiilZOYfrv7SOHi26bGr/xiH5FhH0gSTTDJy4pET5venMesvRy2foWwvZE0XmB3Q
 dgSbkjey
 qKXLeFlJirgfhAiKTal1mD+v1b6rNzkrgKMdQ2ePSSkPLkUn9T1rLqHQgbsLWlyoWVdodzosjX/us5cKv36b+nOEca71gu6MLjAyrIzgFZqNG7wbaw75K7wYGFDeyRMk4/SIV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
> 
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.
> 
> Fixes: ba76149f47d8 ("thp: khugepaged")
> 
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Nice cleanup for the comments!

Acked-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e947b96e1443..d635d821f611 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -67,7 +67,7 @@ enum scan_result {
>  static struct task_struct *khugepaged_thread __read_mostly;
>  static DEFINE_MUTEX(khugepaged_mutex);
>  
> -/* default scan 8*512 pte (or vmas) every 30 second */
> +/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>  static unsigned int khugepaged_pages_collapsed;
>  static unsigned int khugepaged_full_scans;
> 


