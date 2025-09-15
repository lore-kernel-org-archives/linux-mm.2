Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B427CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E1F8E0007; Sun, 14 Sep 2025 23:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E908E0001; Sun, 14 Sep 2025 23:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B628E0007; Sun, 14 Sep 2025 23:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A71C88E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:36:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04A93139FF2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:36:20 +0000 (UTC)
X-FDA: 83890071762.16.44D01E0
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id B573F40004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:36:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=k0haYbzR;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757907379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2b6sC4/5fn9cn7zC7Lhch8bDm46TCCw/xd6ul129aIg=;
	b=ZGVQBehuJ4HMwx+7ALI3ebR0m0npf0f5emzdFk2Bx3rlKmvSjOcLyiJ215QYZEoHphACp8
	lznUyTwe1jzyU6l7gwx/+xUcBnRKqfJinB/Z6yk9jCX5ZgfasEQTkhFqinn/zVMHQbcFpO
	lMyCxS8Izz6qw2ZV/27BJ9bH9TY5Gxk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=k0haYbzR;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757907379; a=rsa-sha256;
	cv=none;
	b=OUNye3wIj7dBhWoqAlnA1beOAfbn8KKta2c4PpHWQV3+oRE+qQWC8+SYVn0tLaw+v5DrMh
	ulgkAeOG4FJrazXB4sSC0T0VS5XXr723TzXDOJW4kq6UU3lxtZ4mEWK3ojFokS4NmRP+tP
	9cs1Gtme7dk3nnMXklTQspxPY7TgvAs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757907374; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2b6sC4/5fn9cn7zC7Lhch8bDm46TCCw/xd6ul129aIg=;
	b=k0haYbzR4oQN00/MbDH/8+KsfR/E9N1haXdek6Gr62vtpCtq3onF4h/kyT2FuAEBx63TtBdC+rBen1U5vxuw1RtXVLQQ95HCZGcPOGnOO6e6YmB1jyJMx8LTl3v+/FjEipSkK72aCIAXYrU05GV6wSpYL82iK0NsJBS9KImmuiU=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnxDIio_1757907373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Sep 2025 11:36:13 +0800
Message-ID: <fef6da33-2035-480d-9351-bd2ef066b3ba@linux.alibaba.com>
Date: Mon, 15 Sep 2025 11:36:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c7g8s8myyfdmaozezt6c1mkpejhbgn7d
X-Rspam-User: 
X-Rspamd-Queue-Id: B573F40004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757907377-378555
X-HE-Meta: U2FsdGVkX1//HV2mM1zXqRg3lmCFw+gSHcelgRJ86l7EoOxK6EgJVA57mb9p8MB7Ooie865qN+soYhym5eYg5CwRsVgpeAvDqty8oTDPN6Ta/UqXkoRZ2BughDiwOJRUep8mdZNlCACUvP2FuNO0ZKqZZXo0IQXqzvWPId6WMnN6rpRlgIS/A3a7WXq8ep7KQELA24JnSSuyzOjqJpppQEWMurKTyls4Kf1zm+40SYaWpDPa0xAQ+cEqgFQ8PyCX2pytL6T3peyRitoOiYi0HDpTxjVEfFVuo8hwFPP0Evw3FAobp170VuwHwmkbIHTEW7zwjktoPF5rkcV5iMPQPuxwYpZY9v/92yDl1JxNIcKBsj6QLe5mgQnYg5qR0zP65/CJjZ1OePHmyEvQ2oQOLDAyRoFLYGQdshlwkt9DlKE8TP5eAHy10O5wy5Jj5JABORzTuY9C5SlX6SdI+9NfXcBnNKDeazjgwwYnNkm/k+7Mzgrdn9mVLcWEqht346bx+phOZVxVfFzuADA8txG3eV3Y7t34k0BwDlyBasj9zXuQmvQho82XY3Nea6Ktkfha7YaOiduptrH359+iofKUXO+Jft1840syqDWpPlrceTeGNjJWLyI4LEiOKF3Dnxz3W2Qbo3GF7Wh+8S8PTqoiszWOnsYyGP20qw3Y9uBFrnnnF4ns3nIRgTpe1vPR6w8uKiL1G/uZK4SxzveUignjgCx2nkEbXXDF20BkV78bwBCKUfwC5rUnLRyGFfoHIKS0f9GhKJ8y0J+gNcgUWZolp73l53An1w+f+q/JVlY9WKHYvS6Z87Em/Ps8HnV62ZJmkuNE9fwrEj+Fv09u0Rb78EaeNDCfof/RWB1wgNy1ncYO+BU4Y9lECkXj7VbKYRDp+0YEUAEY98wJfZ5pUd7p6z7XIs34EQJpnDeQfKssEd1SZOPUaPm7MR08aFQ5/Urtg/6ddUL/Nkre+wEMhJP
 tMgrEEKw
 g0eUxOe5v2bp2up9JQvfxwkYMdPmxNVPdcwtxFzrzAH1wSkxGp7R9xOM1HGb5oem5dvDFwHVk6S6YLAj4spBMHKuS38v94nGzFFeH8bsz3Rxib0sFC48rhbQ+k9/G3TUwYu1kGYI6+DIO5VA+AK2U+GMsLUl+WZnkGT5PLykI3mAAwKMWBqYQYWaD4gRUNNtkjPcLwkvc7fnTEEe/o8s86EBJiIgeBZaqAc7V8WXrTxkqPDuWPFOuBjppCJ8tgJSsi48bL4W0XOUwiZZPCi7GIeGptrOoFw9cR0Pn+NGvNYERgIZyBZKb8yqrHLLcDCHlFf2pcCzxYnHBP6orsvEbVluFUVK1PPpVfwJPaGK4v36RkK9kTOyX/gBK9P4KU72O65e22hBWLIsMF1bw/VjHekKQXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/13 00:58, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
> 
> Consider following example:
> 
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
> 
> fd is a populated tmpfs file.
> 
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
> 
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
> 
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Make sense to me. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

