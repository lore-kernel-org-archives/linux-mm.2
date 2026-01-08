Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C477FD1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308BC6B00B2; Thu,  8 Jan 2026 12:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5F86B00B6; Thu,  8 Jan 2026 12:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8246B00B8; Thu,  8 Jan 2026 12:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09EF76B00B2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:48:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB77816024C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:48:16 +0000 (UTC)
X-FDA: 84309530592.28.9D936CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id F172C40003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:48:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M57mQ1lg;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767894495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qk9S4KNKepzCX1eBVjxs5f/+OHMV9b4pDDFNJeSFV+0=;
	b=eU4T14toC+H3q8/5VYNU1ogL77ossZkVWrz1pPdzoOzNbBBcYj+tynzHMdyc24bQVjDiEu
	qP9HUhR8KrK+a1AoFint7OvLIgY9DvhGzOaihY4kM9Nb2/dzL1ukKuhuP2GRrkKRaa8TOK
	Ykny4m0ayxozi81lniWgInIZQu4IBUA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M57mQ1lg;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767894495; a=rsa-sha256;
	cv=none;
	b=IaZ7ZUzSxqU5hhloO0cuo26d5vSHXUULMXOLWJ2n+v8LyMjEAwUXqStbGBDvQ/mvquwKJY
	KNyy/TzfDQ2uEuj/mdW+DLYhc/Qt+VMpf99ewxOZ/A3hrz9iSVF44xPO2ACUZMsOYr4n22
	tyBoCtP0NDEKaMEhv7ottydWKDWxhzE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFF1243354;
	Thu,  8 Jan 2026 17:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8476AC116C6;
	Thu,  8 Jan 2026 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767894493;
	bh=p4zq5TLeaIF9oBTh+MeDW7ixwfbdKuP/Hlh1oSPZ4OA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M57mQ1lgAvcDoFKMJagLrAPDOPLRGYbL54K0eggKgRhi+HLPrzU/+ou4rdo9OGqeM
	 1ehjSVG0IY7mMD0hvPbVHFCjQl7f0aVtD6H/W9ELDFzfWT/yyWosIXwgaCmV7X3tEE
	 OkiPvmjt6tir0FKmyOWOYrpazHopBAj2Zc+UEQRg=
Date: Thu, 8 Jan 2026 09:48:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Mike Rapoport
 <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-Id: <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
In-Reply-To: <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
	<20260106031042.1606729-2-cuichao1753@phytium.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j3unmwk16ippxktwccyfunt5xcfo7aig
X-Rspam-User: 
X-Rspamd-Queue-Id: F172C40003
X-Rspamd-Server: rspam08
X-HE-Tag: 1767894494-868982
X-HE-Meta: U2FsdGVkX18aM30QlaKH6i5ygVNvJLn+44jdgh7KBWQ+BfLYyw9I/Fk79tKGzzmfRdMeCJcXQW2ZSbVIrcKorrg8uLIZXdhS+u+BuEhiKycPVhac7awZfVQvFWgBgkp1/1+SGqyk6jkwNDYn9F51UNMRaOJ9yae2qa8Oiim4ov17pK/I5kqTZhW6bVpskWkLSsDRrEV32Q0ZjjvBczy2O2un+ZTaF1j5wy01IVHyH7pKBmXDZdKNshrmmHHCZ5IrdenYDCrsc6mSGIIi37KRWrnnjRpKtHsy1G7wQkhlIIfUxeyg5mznPhaKltQmNbBvlMVWml52f/ZODOGlaCCXcUYMHKACrjniT7B10/zrGdn9C7MfoYkFzj8xhUgvjuVevfbiPWraxsAgN9+FfrK3vdo++PQ4FEMwrpzQt7A9vRnK/5DLWnPZMz+RgDACnqRCh8S8qwHOYsOLeflpuAn69H8DmcTjc8SpXjf/tGnE7w3msiFDYV5dum6k9Nsku/sYtZwncKzcgAcEtmOeos6qMbgsHYXWUSIs8Koe/tRIXGsMN2GBz5b8xuG6sKLy9PfuzuLQbxp9he8sSJq0J7eTFffnyAh89sPWWJiBca/ezrJMlpwsbVHszIHYbbnEDua12ddhiozRnnJajLVzpGfUb0VtOXLGFyaXlPlxYLfIJY/UuSYf5KZZCF1TRDZ4cu+yKSuxj0zBhnMn1qsrRKQGO7E+UVVbrY1w1tfPxfLY2zxzayom7FYWpo+ocetYBvbIklmJzIVDCTBUlJYBKUmi9uYkH0pKofCxpL60Z+ZA7inL9oAxPp4mQ/bHLzE3Xa4H97h/YCFBVAUepeHT6TOcNvDfr4XkjnSY540DeqbsTvO/29uNtFna7lB3lWf6+NHPsYTsqS0Yk6xM8m+0rlHx49EugCnkqaRgRVJnUNR5mAMNNr1wvJtwOaIXNuvPusHNoMvJJsv+R2WoULIxyGz
 LYQs3gT2
 6yFLaQI53gp1ZmbybdyKYJCVmQFRMfsULFjSx0ATC4/hBGMFiMj4CmuLM5vPBR8Cd7jNPk9JoW4xiKT3DQ9YqmeQKnO7v2DYkZbtvCarjtefFMT6/4RI48VDgMx7CvKeMy/NLIaIKU5MCHY+RqQI0si8WcO8nRaOQg9mnNJVowwkWuRltgp//Op9ZXbLoj9xgB5UkZZHbunO1/O7mq6++CnoAF66fdK6s/9vDNbbtwJyFo0QGwGqk15ZWI7ILVHR3UbJpMkhqj9lTGrdeSQweTRIK9XX/aIW8lvexTpjtlrR0ioI4fStzQEB3C/6hPEDPn507zHfaB3ig/q6+yBz+In6mqgyWw/6ZfATG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Jan 2026 11:10:42 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:

> In some physical memory layout designs, the address space of CFMW
> resides between multiple segments of system memory belonging to
> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
> of system memory are merged into a larger numa_memblk. When
> identifying which NUMA node the CFMW belongs to, it may be incorrectly
> assigned to the NUMA node of the merged system memory.
> 
> Example memory layout:
> 
> Physical address space:
>     0x00000000 - 0x1FFFFFFF  System RAM (node0)
>     0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>     0x40000000 - 0x5FFFFFFF  System RAM (node0)
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>     0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.
> 
> To address this scenario, accurately identifying the correct NUMA node
> can be achieved by checking whether the region belongs to both
> numa_meminfo and numa_reserved_meminfo.

Thanks.

Can you please help us understand the userspace-visible runtime effects
of this incorrect assignment?

