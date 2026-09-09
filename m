Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5573C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A8D6B008C; Wed,  9 Sep 2026 04:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1AB6B0092; Wed,  9 Sep 2026 04:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A736B0093; Wed,  9 Sep 2026 04:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54DCC6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:22:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 018C81A0136
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:22:07 +0000 (UTC)
X-FDA: 85193531136.16.F9A219C
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38355C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:22:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NNcE+wR2;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788942126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdvGaYGhPQtbODP5jHxh4QECoIrAIjuXWV8VMXv4teE=;
	b=lFQ5LC3oeQLrneW8Jk1S8hopGQsep5r33QAKtsvJK3HD1bA+hwfnjaohz1cKmIdaAC8xUI
	3BrotgIzmHBH/VzS2/b3GUcWH4RG2s+4VqOAbi25IvSRH5rtcl7iSjoRc3n9IjlzrEB/y2
	100UCU6lowPPxU3TmApaH5+W7UkmgdA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788942126;
	b=7XMqiwVasEFFfOh3Bayp2CMpmKiNQ9hv7CAwGRgJQBZNDEORhffirXvFeAeg71NjTJZR3m
	G5YQTNZYSRw6qDcHhcx76B6euKc36QCdO2tvadf8f+ib6pmLbixhn++gkbi9vElxdJUnS3
	bnL3l9eGAylinGHIGsKlron/UQ5WUv8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NNcE+wR2;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788942119; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rdvGaYGhPQtbODP5jHxh4QECoIrAIjuXWV8VMXv4teE=;
	b=NNcE+wR27+bPFzY3eYMf6xCf98icc4BMkiB+vrItFwX6iGWhMRg1TT3WJ9hLp8Uw6/tHARScBd9UHBgU1UB6UT0IjVOlZ23++Wt3vA7X/wxT5UtPBn9BzngTM79JnHMeWHXqa67difzPAbQepS/N51724bAsl4S+L3JHmL+LUfg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAeKi9D_1788942115;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAeKi9D_1788942115 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 16:21:56 +0800
Message-ID: <95ada031-0fe3-4191-b09e-56b324247456@linux.alibaba.com>
Date: Wed, 9 Sep 2026 16:21:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] selftests/mm: skip khugepaged page cache cases
 without a PMD folio
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
 <20260908125105.1510704-5-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-5-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hms3afj1ba88bd3ydt9s8buzpxhft3t5
X-Rspam-User: 
X-Rspamd-Queue-Id: 38355C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1788942123-446860
X-HE-Meta: U2FsdGVkX1+pavswfvi2CgbMPeymBRK7jl36bigOY6oRpjSPUYEiVmJyY9+/NIC/o+2UyYM63ZRGxwVMYJIls4F/EBEkgTxN8LO1OiZk5d8R8EgOTmgZmt4lGYR1HYFDtOH56GDWOh+Q6xl4hHlC3D8Ai+YIQmzmJOQzPKfawZVPJKdDCIPk4fH2HOSml7U0l3X3lmjZVrZmuCgMN/+NdlX74jFePN6wic/nyGEvqQMHgnNCk7/iti14obTHWaxa5GJhAOPv5cLxJpguUkRd2VJ96r3IZ0m38sYibsAMfHclddfbXVtpSxbONXCls9RjFvhg4tOyL+ZD3U0HmN/ZtnbipyDQt1b1Mi5Fz8TLNy0HB6XY7Cd8DVnRCmU1l4tC0eae3qPq8qNLABcBrtOZAaGzVUbBx1iwMr6F/kNQPJu1e7sJl0B5Rer5nw/8jnEYx7+JzrU3TpahP+xS+bfUoGBzL2rYGpS59nm0fxAEBlUXjoWjTyTJpxA4xDsHXXvn9nm7/nDZunzZ344diwml4ouAPMXs2Qp4oXuQfHPGwI7tMzymTG1yZWPxu3k923cjLvm8hu/9f5yAWrnagQAWtYr+nQAZFCGgg45crYrBUf+1cQRMR2Tf7LhXxmSPJ9M5zFv5yN5JrqIChU91ulsYIwbPqe0pZGem32t73BkvtUmrNyZWgeTJnDHmkVDX7StD/6nQrvHCVnFbmULxXRpMlx8qiwp6AdCB8eKr5995kiusQWSMpkpVfkuU44T//FiVBDpjrZQ9MI7RYhlnOIXXDGlyNQgyGQyCQ6O3w93G8agvQNONLaAeSqNdSPHlN9xqThE/g2yJshnPGoIFZeOEwrJMFYufClQa5Kyf7HlX1XTSTzHl3pLHYQw5PdTuS5u5J05zJ3WfvNxktIJcXsKMpPJtbf8Nd2yHu9lr6vljPuYfleqzYa7uezyMdtnJQKv3EpiqIU7v/h43fXo5yBb
 W/kjH/JZ
 kSJJVr8/P94ep6oDNANNr74N1hb+lQ5OphUiebyzoCP8itPMUwIqYVNallEdkXQdI42UficRzru5oP7BxCnZ3ZgZGSrPhBuGps0ueAbZocH33kFjziVpGIcOzAFqsICGFW2ewi6G5ktpmH5GEgfCTjaHbImXfQMcYuMGNVzqI7/cBIFRR8l7Tj7vwAJVBF0ia/WGlyeztqqqnLxuuH7F5Q6FqwDai9AAFTg2u8lpmeis+rouevYFAMxXY2NzN64ffa8raqSA75muMsSBX4B1p69qMBFIasByvhLpYrqlBL32gPC8UjU1sMU2n2xfi3CNLUGrojbsigyErJ2FjAGAiopDs09hP8gANMhM7DTGB5C6puMKHgCVDpr6jw73RvXM5r/Kb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The page cache caps folio order at MAX_PAGECACHE_ORDER, which is below the
> PMD order on arm64 with 64K pages, where a PMD is 512M.  A PMD-sized page
> cache folio is impossible there, so the kernel refuses these collapses:
> MADV_COLLAPSE answers -EINVAL and khugepaged passes over the range.  Four
> shmem cases ask for a PMD-sized folio anyway, fail, and the run bails out
> in the middle.
> 
> Skip the shmem and file mem types where the cap is below the PMD order.
> 
> The cap is not shmem-specific: it applies to every file folio.  Add
> thp_file_supported_orders() to read the orders the page cache allows.
> 
> Anonymous collapse is unaffected: its orders are not capped this way.
> 
> Assisted-by: LLM
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

