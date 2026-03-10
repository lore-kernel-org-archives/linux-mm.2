Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67684FCC9AE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D066B0088; Mon,  9 Mar 2026 23:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4936B0089; Mon,  9 Mar 2026 23:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900AE6B008A; Mon,  9 Mar 2026 23:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 814DB6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:02:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07464C1B9B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:02:56 +0000 (UTC)
X-FDA: 84528656352.16.D3596C5
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22050180004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:02:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VRlRqtGq;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773111773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHBHkkng8rV2mhedXap1Lsv/z2EqeSLBm/xnyxfphXw=;
	b=SzJkCM3kIRWqC0lX6835aqQowllh8i8PagYi/M8SqGsOsDG2tb2BWKBRfgWUnV3LoAK36o
	UwViaKBhizjsl4XJriMbLcyaQxjSk0tq+A8oomquMKpcHnsF2aTzaoWogynHo3DqxVZ3C6
	SsKNgEtK0jFZQ2UB6RF8AtdKnuAQpqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773111773; a=rsa-sha256;
	cv=none;
	b=DPb70kozJ+MCI5Za3HiDxDZcmdQf35XOUVP4EYIZ6kkoOY5Q9++WrKG60ktud8stqf0Om+
	eqIrSXyuv6RJ9zFJ//Ij1aF5yY+1aSSDwnXlp7rSHPrZk6qgYED0g5YQLSmn0DBeqCoVNO
	qVyc3rlA1Tf4/LSnnnMDSFxPoM92ABY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VRlRqtGq;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773111768; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qHBHkkng8rV2mhedXap1Lsv/z2EqeSLBm/xnyxfphXw=;
	b=VRlRqtGqzhhDekNejaE6Q/3QxLxBtWuzA5yRVrrPibuq1H6QxpHhcrnX77iSvRdQmVHpbw/BsqW/DiE8zV0sBd+Ke/C5wYVuQlAC4KP65NQpgsxCditUniXnhHgVzO+6YM3/5qSQGWGU0eevT5cDVOydkNykxPXH8Z4DBmRRD/0=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-eGuu-_1773111765 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Mar 2026 11:02:46 +0800
Message-ID: <de4f2c3a-1fe0-421a-b795-268573573cb9@linux.alibaba.com>
Date: Tue, 10 Mar 2026 11:02:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: ratelimit min_free_kbytes adjustment messages
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-4-926b9840083e@debian.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260309-thp_logs-v4-4-926b9840083e@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22050180004
X-Stat-Signature: 4fyjoirwgh4n1wfyozwwqwe6qobm5pjb
X-Rspam-User: 
X-HE-Tag: 1773111771-451847
X-HE-Meta: U2FsdGVkX18w8kfaUaXsntXm5TIqmHrQ+uSZ0HqbzkrW8EntFu+llZtSHo6fhyB0GV5KElK0A3+PfTTlrlut5HvclnTeouSi9IUWVu2XvGctEENJU5U++sqUVrngdI0F/ElbbmgywuaPZPbylkkKejl8OrUL+DIuRfn652ofKNiF4K9ediG/IBepeElpW2hb7dTv+KzXro67tysgr6iYhhiQU0RmEHFipNURKWK+rtuBWCb9fdojB5z+Op20YKux3+BmBDNIBGgwTLs5CmebFuXQLh4L8ZHsAMxVgMaAs/Shz1nsTW9weifAGmahXYkrr5jKrRn8hvmjt42ZZjgkZeBr5TVX+rd3HX8blseDnenPDKQGPMEBZPdIzKv2KZvX++dNhpbjOBWuDNnhLCFwjA1dtzzt/hX7DJHMUy1mWDv/s+u4huO7kHwj8gB8cW6nJdZwKgPmh4PdjypOizC/KF6IN8tZCZWJwn9rwWKMwDj8pOP6eulo08rkwJ6rKIgNqUU3Z+XGqe8eU+dgfbw8YeGwXHEDEt+wkhFN45njdD6DqaLAP6pv9dWdHocf746BghSs1Mcdk19EeIb5+LB4f/XfGXP4vp4NDTPftaI0EAiiPbaAIutw3QWBYKHdIsSEIIHUDgahlSbB70uK45XWDL/H1U7Z/o2nLM+IjMmWWDQ0gOKKm2OuIgUu0tRWJxdnlK/qyk6mDs5o0JU8/4iN+KMNXXdQvULvoeIbSPNITiDHh8ZjEf6+fzx6PX77tompfnEYvquDhc91czxaKG64bjFEbD3BmxkTK4iQGHqM7TOGFCang+5H9JmRCpS5yP1cHv9LqjrBZPMzOis/1MvttLZOhoChNTAd4Xn6nqe8kJPjwJk7sXsHlZspTpPclKNbalyRjfal3L+HuSWhZXXFEwV1pktB3ydG4XwN00fuJx4+axgOZN+m7YhvzBpwK+nO1arAkkM0dT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/9/26 7:07 PM, Breno Leitao wrote:
> The "raising min_free_kbytes" pr_info message in
> set_recommended_min_free_kbytes() and the "min_free_kbytes is not
> updated to" pr_warn in calculate_min_free_kbytes() can spam the
> kernel log when called repeatedly.
> 
> Switch the pr_info in set_recommended_min_free_kbytes() and the
> pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
> to prevent the log spam for this message.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

