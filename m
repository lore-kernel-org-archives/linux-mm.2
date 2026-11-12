Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78223606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSxzzXAQ
Received: by kanga.kvack.org (Postfix)
	id 9E8686B05B7; Thu, 12 Nov 2026 03:54:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFF66B05B8; Thu, 12 Nov 2026 03:54:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE796B05B9; Thu, 12 Nov 2026 03:54:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 629986B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:54:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0DD840477
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:54:16 +0000 (UTC)
X-FDA: 85425855312.22.FBEAAB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B85440004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:54:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HSxzzXAQ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473655;
	b=MTCqH+y+YCLb2AwSC76weU8h79Vjd+BhBT969jdphVVdgLwAPIYUbX/qSCnvJzeSjZZ7MV
	XqJZDQJBBsfqlf1e1H3NrKIRC+5lIHI64ndsy48L0Bbl3PuBD3gt9C6tDQnybWuWy5dK/X
	Rd5yUHIVFdr7gid+XZqVv+T+PZRnw3I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HSxzzXAQ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OT4UYzJ55zbPPzE3sSYyUxZKuwkGev+001urY+Jtyv0=;
	b=Wghdz/M/TxkCvkPJY5W7xoWnYcyevv2soZAnK9LXqYLRZaVDfqg79WvnaFmeGRZS3Ce9Y9
	Zt9onYOPq4JyqwVCv92mJqVURTOiQ+b5VvGIndFxN4yLgwpQzVyBkEKfwGcC6FIVrIQGUg
	aUsmDPIDv18YJrQ7BALtg19OEvct7Tc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 417B642DB4;
	Thu, 12 Nov 2026 08:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED451F00A05;
	Thu, 12 Nov 2026 08:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473654;
	bh=OT4UYzJ55zbPPzE3sSYyUxZKuwkGev+001urY+Jtyv0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HSxzzXAQAXajBmw3uzuM1xXEfDxqd9aJG7PLJu051MyVrGQ1NaJm3jkY2BfPcSs61
	 KQVrEw+f/uZxjoPuRgJso2EKttZxcRCo50io39UiuYuf4Il8I1iDf4lFu29Je5hkke
	 wMxFFXLGjAE0evcUlapK2syy4lY2aGUBLtmwfUcQP5TEPNcCO9sC/3Oe+1isVNwt6l
	 Oe6xf2kLohBkQTpw7HlPYlVGuPoUTVTpLqvCRH7aIGvPwbYKHiCVA5kXV0VH7M8nio
	 zhe7wrGIvhQ6/RoYNJw700AstBFvZkICaw2fkm+pVWHqezWETqQZc1oun5vXPru4x1
	 ZsuSAGWiWPm2Q==
Message-ID: <bfe69f54-9eda-454b-a764-7a9b185e2175@kernel.org>
Date: Thu, 12 Nov 2026 09:54:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, ridong.chen@linux.dev,
 shivankg@amd.com, willy@infradead.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com
References: <67275d3d-cc60-406c-a088-298b948d7577@kernel.org>
 <20261112024855.424402-1-husong@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112024855.424402-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B85440004
X-Stat-Signature: hkq5jif485k9b4qttxde4rq1hzqq41r7
X-Rspam-User: 
X-HE-Tag: 1794473654-981612
X-HE-Meta: U2FsdGVkX1/uBE68Z3EuKYvICTzS8+Gcaxr4jQ5FSdzQH2Z+PJooqmOuvV4htMNQJTcwDfUIBtx41gleWE4+8oSY7YKp/QxvHFVuyKb4Xk4uljL9sE3041UhM//1yfU7ZMPraZubN342S8Pmw4lCgBQx1km55MGuWZDU5IFDf03kQZZMm01TCL8A0NpdN0zhEpQUHh4ZBqUGTQ+0DId5iSahFKz+0lBq7csdPLKUQmOypXenNDI0khJ9Xs182u9Mh6UOD5xeW790x2Q7GONkts5Af9sD6qrGt1pmUfmXrOZRlNRLHmmaTQK2whWttuNhrhxhasNt4GTt5jDbxG3ej1QP83L7fAQyxDxbMHG9nNq0vxt24CXRyWhFXqNNb2NLtwS1HZIemQmh7p9VyCq2IFOGCQOEPglE74N26Btz0b3JUiFj/PUnck9+/PMhPS8cBy7nOlalcCz7PWuVYoke9a63iGJ9fJlAxIiwhB3V6RK31f6Rw49EbDBsjfiCemPkW6I9jEVoEPgEeICy5V1Wn2N15TNqGuOv0LxcAn0CUp41P0bJsC6OKLGPp88u6fbcd/23P/ZBYHkrRkfARqYidhCKw73/DAmUQlBS9kTGxFdqUtDb0Xfk5mSNcmNyO27Jzx3XEKGa+k/ZS9TbWYVfsxoRWsoP5ehCvPdHuQvJB0xaJNjSdkriyu6ROHSQ4/MeDvs9GdrlaBYdCsIO9zmXYNrJ7j/Rt+ZCFosIzIR9wBvuhAUkH5C9gFdSSToqN4asJ19vQrFZRSAxm74LxUQwDOU3gByDsfEqEbh4YGtzTQLYBDU5Jw9CaUYC5WgbxFpQIXVN5wW0SXMV3gRLmiiJmdf5gABXB61BtMBoi4RtBdVuHusj2dEqmGFtLPrh3N33mo0uFVt6UdRx+5vTGMzCFl1NpFBjyEwICmusPiNZFxZEcCRnZeOj5k+ni9FBXhWcNq5DZW3AHl+cAZRypTL
 964VSW9f
 LKAJIDmDPXATs/OkQy9TjQdtN5g+iU5Px+joPAoThYFy+CH3eB8mRovQ1+wANOaoJI+1DowQa0nmoiIAuvm4jDzT8N+YgCk6fosb4XcCPhlH446eF6W5msYdE5pc68l9/5BygbfunpxwP/ZjAuzl+RAmHeWb1dWWOeGO6Ru78yyi8FthL/QJI/6sCqSSOnkCSrlpP5lgxafAFhe5LdhUDF+dmn8xgCY4DIc251PgXoWA+L+vCjTzn2VqdfwtDHcdct8lLY6nblA+kttWta1XQo2PWZSx/Vsez5HX87sC9er7FDmcPubcrpSPkZAAwEjBwB2OHpsD7kpXMpYipP6egYELlp+HtMC1MYudj8SiTyGR03yljoUZOCU2vI5uT/05raSKGUIp2gwx4e2r1j6w5YwgkH+Ka5drmPNJHZ1tNZZt0XWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 03:48, Song Hu wrote:
>> On 11/10/26 04:09, Zi Yan wrote:
>>>
>>> It would be better to simplify the above like Joshua suggested.
>>>
>>>
>>> Like Joshua said in another email, it will be more readable if
>>> NR_SWAPCACHE updates can be moved into the then branch above.
>>
>> Can one of you write me the updated patch description? Thanks1
> 
> Sure. Here's an updated commit message incorporating Joshua's
> suggestion to describe the accounting model first and then explain why
> migration gets it wrong.
> 
> mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
> 
> NR_FILE_PAGES is accounted on both the node and memcg planes for page
> cache folios.  Swapcache folios are the exception: they keep
> NR_FILE_PAGES only on the node plane, while their memcg accounting is
> tracked as NR_SWAPCACHE.
> 
> The cross-zone path in __folio_migrate_mapping() currently migrates
> NR_FILE_PAGES through mod_lruvec_state(), which updates both planes.
> This is correct for normal page cache, but wrong for swapcache folios
> because there is no memcg NR_FILE_PAGES state to move.  As a result,
> migration incorrectly increments the destination memcg counter and
> decrements the source one, leaving the per-memcg accounting incorrect
> until the memcg is destroyed.
> 
> Reproducer, on a 2-node QEMU guest with cgroup v2:
> 
>   1. create a cgroup with memory.max = 50M and swap enabled;
>   2. memset 128M of anonymous memory in it, so reclaim swaps most of
>      it out;
>   3. fork to raise the swap entry refcount, then fault the memory
>      back in, so the resident folios are swapcache ones;
>   4. migrate_pages(pid, node0 -> node1).
> 
> "file" row of memory.numa_stat (bytes) after step 4:
> 
>                     without this patch      with this patch
>                       N0          N1          N0          N1
>                      0 (*)  51691520         0           0
> 
>   (*) the source counter has gone negative; negative values read as 0.
> 
> Fix it by updating the node accounting directly for swapcache folios
> while leaving the nonexistent memcg NR_FILE_PAGES state untouched.
> Non-swapcache folios continue to use mod_lruvec_state(), preserving
> the existing behaviour.  This mirrors the existing swapcache handling
> for NR_SHMEM in the same block.  It accompanies
> commit 4eef27af2932 ("mm/migrate: move NR_FILE_THPS on cross-node
> migration") and commit c5eef2e03618 ("mm/migrate: move
> NR_KERNEL_FILE_PAGES on cross-node migration").
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> 
> Thanks to Joshua and Zi for the helpful reviews.

Updated, thanks!

-- 
Cheers,

David

