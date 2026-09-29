Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 447B9CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 06:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53516B0088; Tue, 29 Sep 2026 02:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04166B008A; Tue, 29 Sep 2026 02:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19846B008C; Tue, 29 Sep 2026 02:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A45C86B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:37:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 398B64028C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:37:04 +0000 (UTC)
X-FDA: 85265842368.16.499AA9E
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D35D120006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:37:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QFMxmYSo;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790663822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHGoHv8Lq74Dy6sjVbuTyE2Azn0gGlPCXjF0DUVDx64=;
	b=mFke6in27hg9fu7auCY+ZMBV4/skVBnxFELKMqmL92Rz/KCLIcJpAWbtAtpSfQ66P9J+dU
	cc++JS1oQA7hEify41acJcV41ETrtWXN2UHStze4rWpNgwKwaMe83fhrqVAfLHr0vd2JCZ
	bZv04PmiLayYQUSa3LnIrmfFptkyluM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QFMxmYSo;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790663822;
	b=2fW1QrVxlJbEpS0duzcqUp+96WWr+raihzzMtFc46M09xajgZxcXchpSnYlVlxBidlgBDw
	Cw/whau3svw7PRnkKK2Dz8foNOsgkDgMpXWGifbZFjCU3L1Okv1RxBXKxLAQNjmUlAy/7v
	UaUFh0QGDPoEtkoiEfUfi/MretX2oRU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790663818; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nHGoHv8Lq74Dy6sjVbuTyE2Azn0gGlPCXjF0DUVDx64=;
	b=QFMxmYSogrdLuUHdGzaxMcsH4BLBiLPe8IegtXmOEdmmvdHAUXzhbpmx1yJbrIsS/mZ8tdmNm9zPf1qbR9D4lO1zuWW4Xc5TRkLX0WPSnF3WutxY2+di2PZGzpBDZSk5jGHbbwxEOqRu92Gllb5W/AFI7UsgIOwUys2SkdyrWnI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XBsKUCx_1790663816;
Received: from 30.74.144.142(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBsKUCx_1790663816 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Sep 2026 14:36:57 +0800
Message-ID: <c324eab6-aaae-47c8-bc89-d2dbf4b0a1ad@linux.alibaba.com>
Date: Tue, 29 Sep 2026 14:36:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-2-cba7359d882a@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260924-fix_split-v8-2-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D35D120006
X-Stat-Signature: qc5er1syi793oujwmq7zmfxoxkkd365z
X-HE-Tag: 1790663820-178327
X-HE-Meta: U2FsdGVkX1+LuU65nOgz934SNvmK052dW7CvXK2Wju77r6OsawlUfjz/oWyrPz0DZFgcGTeyY+cNkW3KLDh1Vaq56Jqq7D260cHG1V8wtWHglxxDkofZ6vcOo9Oii/yt6IgIYlHvknt1lsT7TbwBrjnXE7wdSi781oo2w+2+/8uuzjkgiVFWlnwlAdLvatH4aa52qf8HwlsgkHtVWCxTgRGUx2AMO6BtH6nNOH+omLImm2N1MDU6gBWouzczh9Z9o9A5+iy5BpJnwipPEYqbOgyTMGzMHm8pDa3xWPvx+biAkG+MwtJe0lD3YiL2H2vABiM5Bh6NEXgJE9npSemqLRvMoBtiN678u0llpL204UGvmUe163Lewb3sEZDSMDKjBaqjbiD3VtuQLwX0yGdTHflpMMwSasswTglOdeV/uU2RtVDE7P96KFI6NZFyiH0Q9p8qCB4UU55395lUO8X0Q+vKB5hcd6bJ2mgZ9SPJouY+jmnGCC5ikLwILt4ha1d9zQ6llMQ2QI4CouzaPcDoKuYb+TReYKgPUrPn8YjovtIvD3stT1WqgJ1x0itsrwzNmyTY28xJd0hRUB/mjhhox4eIKdNEoaFNr9VRLng8/yXoLsVpi05qFp/Nb+ZZk1NKNRnHXo9/efFkfUIw1FnAT/GFfK3AfBpU0zzHRIe8iNa4GHjznGgePfUG3EKq5nPSzakW3F4iyLEz06KBeeskafGfUYaspCTFrsTzoScJNGdcs11H2v4JVpFvn4X7SI55aY+rOwaOIW7+ZDpQVM0JLoTxBlQssj8JPKAQoTGlZ0fY4jyb4iT4q3JOYZxFw46lQAHJDAZsiG01/WDWEEJg6Ycq/khkaNKnxbuJKuulvPXOoqOLAh/ukLRM8Pu4lBTcgz759dgV70lZ3B4DD+kg9W8H4vb9CLVOQVn+smcNUxAu+K4hCzzKyooBZrvN3Z1CBpFRSIKsxeKZD9aYGhG
 tGo5Qp2K
 UGRL2sAaPY6EYgxDOgAqK41movxqyxhtGABvy0wQrloi3jQFYZaRyGhPP/pp7y48EPq6vZGjhcDwIiAuR0TMGG4Bb0jlxk38wWA1l7pepFG+1vPUPCXIuj72ZfqidFN+x7XhvfkjOCoc00GBPLlVo5LyPMhP+CXzh8tvidIGvwFY1vvG+C0PWGz4SqMVEMKMwnoVf/az/FihFQd65dJvzbPdtPVPtEh03OsE66o7C7vmhqSPi5cGclYrjIwSa2g3KexhJ0J7AZxA7DAoaP1SW0mgyNLovEmNUTG+x1Wn6W9cVS7ZD1lZg7GxbD8Dt0+6m68OX4H0/eXPKYW70KYuERPAoRplpUTsi++ZYLrPa7/AJQrzzJ4kPUZVrofLRDqoCQXwsiz3gZFUssJhqpyfFssMPb+XPeYTruZLThjFUQVUubrfxivrsDJEV1MdtW0ZcXWvsOAdHqEIZx9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 3:11 AM, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
> 
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
> 
> This causes split_huge_page_test to fail because the check_pmd_huge()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
> 
> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
> and PAGE_IS_FILE accroding to type of huge page.
> 
> Since shmem pages are also file-backed, simply check whether the page
> is file-backed.
> 
> Fixes: 642bc52aed9 ("selftests: vm: bring common functions to a new file")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

With comments from Sarthak addressed,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

