Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1775C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7216B00A0; Thu, 10 Sep 2026 07:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786976B00A1; Thu, 10 Sep 2026 07:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D106B00A2; Thu, 10 Sep 2026 07:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45AA76B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:14:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4456404A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:14:56 +0000 (UTC)
X-FDA: 85197595392.19.E750C56
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A24A140002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:14:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jFf8rHCT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038895;
	b=aiB2zFl3sSS0SzF4qBdryR4r1A9wLKnnlTErZPB1MHqdenCNIpCY/tDZ0U+s/sWD7INvJh
	imxij1kOSOVK+Zf4rZkfJ60MlTaFEsjcvzfVPAaccRETPunX6Lan98/nb4ZYlCh/YWtxnf
	jL+12f5I6JM6wegyEM5TMBE1WGZH6VI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jFf8rHCT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eL738YFl/z7Tr4I2W3yCdK3smYYU50aios13U3epmI0=;
	b=uBNebe0gPFf/+uWelpnA55BjYO7RhQE8E6hBCsIBdyKEl1v0mizii+iG5SzPwUWxfpDC9h
	s0oHeDzkjeKZBDO3GFnfl0FgXk4qsGi2Ujg2TzWpjkO3Tvrw9yXL4iT7C4zcESbEIzK27z
	iU8nw7kfX2EpslCSIhaa/JU3mBz9IDI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789038887; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eL738YFl/z7Tr4I2W3yCdK3smYYU50aios13U3epmI0=;
	b=jFf8rHCTH49nGr989S2AyPg+bXct/7w82abPtTPRwDc3uUFPasL/xrBSog/q65K89PIqTsJit3BGAmgyWysok7BlCG93o2jEWq0vghhGKyX0w9XaTib2k1kCMfAMt2KouknuytwcKOSEPVCr8lKB7C4zOhFDAcbj40LZQ72nhvo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XAhWCyU_1789038883;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAhWCyU_1789038883 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 19:14:43 +0800
Message-ID: <65bf1722-c1fd-452a-88c1-c030b042cfbc@linux.alibaba.com>
Date: Thu, 10 Sep 2026 19:14:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/19] selftests/mm: add folio-order check for address
 ranges
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-9-kirill@shutemov.name>
 <feb76c81-db9d-4a36-9a31-0b2b31e3c3fb@linux.alibaba.com>
 <aqKFXlpSELmCtt-z@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqKFXlpSELmCtt-z@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A24A140002
X-Stat-Signature: mozaozxmcsn3177ib46w1gg5kqafxefm
X-HE-Tag: 1789038891-754452
X-HE-Meta: U2FsdGVkX1+4Fw+vZLgR8MDGrXA+5qi+XJASl5OKdxLUdOP94nJ36uCkdfabRWcSKS181EfX+wCQhsvnt+T09ER1Ndjzpir2ErxagE+GANzSAaCxwyc7xVYQ5WWjSa6ZG+JAs3PqR0jNqh09YKhsS+FjzWCCOQbOy3wkwmzY4YNs8rgHOBacc/tTfJgK/I2RlvsdEVbmpT+5025P16NKtBRpXcxwl0kA9Qx5jvB8IZIfJrTUO9k6NQ190LNKA03LE8zmE3C+Hrf2hfKkR3Tkf+iBuQGGomAubTLU9NitYEwBMzW363rmWPOcLUH1LMTr3MBOZGEQbU0prVoRQUrmH1Wahh2ekhr2Y0ZJvKmQrHsn54RUVL0yexYcnecbaU08oBK/EA6S1tX5k/wsx86FxsRFWaA8xb0GmtJmYvIdSwTjJbjsCwQdRc8pg1YWag1xYjzSEJsA4yDYBwA9DU28+AUXqZgiQBtBw8KasHvEenaoI0Gn+7lbxer5LGkcYX8esYmhipYWlBpEDhyowiTIBohSRHtMi/m0tQHjiWVe8VdOuY5l6Esev0aQYArUEw4UoX1aBH33q0uyZ2oLzsumDr+59+wqp+P/zQBkU9XvZEWrg+oyqoq8hnsaTw3tFnhLZ11ocilNPUCU4DBZGcEYrjaDhQub/rPdhCkN+gP50/EnQ/Fg7G+KdLzuRaOr3ueuL3m4bFCRIzy33NLNvx5X1iowHlkl/1ETf0rc2703Bbayr2wsqXXtEULQ05qnlnlp/LaDDwuCILLeOAjxwETXZZIzpgDEbmTrwXqth50WenMcEQ44Nt04KKG07AfFA2vJQpnVezTkhM8DwpdCL8fZdmHM8Aj+jF8Arlh9htGzw3uiQjGu3UOu0ujAZhNahJpI7v1xrG/jX1kPJ2eFSxLcS9WvecqH3AI2oUsZbbn34bKBe/A6gw+RRNWdjhbBS7LaG8uNX6344mE3ChhaRal
 dDzt5yrQ
 Ij0l477ise8uvjgpFxh1h07bTFvFwepz3IPfebVaNSD15pvE+Q3SHgEytkha/oWERN+7EwMP8wo3560Xpzfrx4pzXY3mR1+x5RlmOb069yJHYQREw+uYxLdG0cATUMCpQ+umBoepbRODKC+XYLsDzu4ulXNSGNyj0zbrQDHqxj0pBvayJGq1XA61AFxzX8Pq82OBITneQWjSYOE4ggxibUya326sz5vNmVwgwfCgoRZxgvIhgOJL5d6W9ZTwF1tZHIqtO2ioUPs9ANdj8y9QEZnIYEQofltpc7WzcNp6piPZGMdwSkLzvsgw9PJA1kTGxdm1C7twkspdyPPhpc+7qq0UXzTl/b/g4rcUccsUZCbEneuOOnKL/YGUURXX965DVcifpRYUJeJ+zmNA5le1zS5OpXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 6:45 PM, Kiryl Shutsemau wrote:
> On Wed, Sep 09, 2026 at 06:01:13PM +0800, Baolin Wang wrote:
>>
>>
>> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> An mTHP collapse test needs to know that a range is backed by folios of the
>>> target order, and that they sit where a collapse would put them.  Nothing
>>> answers that today: is_backed_by_folio() classifies the folio behind a
>>> single page, and check_huge_anon() reads smaps AnonHugePages, which only
>>> accounts PMD mappings.
>>
>> Have you checked check_large_folios() in vm_util.c? It seems to meet your
>> requirements, or am I missing something?
> 
> The changelog is out of date, sorry: since 6dedaf0d46a9 check_huge_anon()
> counts mTHP folios through check_large_folios() rather than reading
> smaps, and it is what check_huge() already uses for mthp_khugepaged.
> 
> It could do this job too, called once per window.
> 
> What is_range_backed_by_order() adds is alignment check: the folio has
> to sit at the window start. And check_large_folios() reopens two fds per
> per call which kinda wasteful.

OK. But can we extend the check_huge_xxx() functions to meet your 
requirements, for example by adding a check_aligned_huge_xxx() that 
wraps the underlying implementation of check_large_folios()?

I still find it confusing that khugepaged.c has two separate sets of 
functions for checking large folios.

Also, Yeoreum has also extended check_large_folios() further[1].

[1] 
https://lore.kernel.org/all/20260907-fix_split-v5-2-822b810458bc@arm.com/


