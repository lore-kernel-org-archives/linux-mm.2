Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBD3E73146
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 08:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF406B008A; Mon,  2 Feb 2026 03:54:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A216B008C; Mon,  2 Feb 2026 03:54:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95E96B0092; Mon,  2 Feb 2026 03:54:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5FA96B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:54:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 593738CD01
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:54:32 +0000 (UTC)
X-FDA: 84398905584.11.D3051A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7CBBB80005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:54:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcBNFCom;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770022470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPhUceXo37yyQ+zV+eFKfIu+AQ7o+/D2Vd+1IyyChqw=;
	b=TPkADH4SALWuHLXh+eWNmb20RJc/U92CsPz66D2rjDN3ZY0bRWu3rRPbIWxVPfmn8qzOx8
	UkU5EtyJRombi/O6/UhJEdvmnLLGIpU5HflZCS2lLCJfU8JO9NjJzAoAcBVL704ddR5eGn
	zd5wrzZ42qmaKDFsHhVzwgRMA+fG6zM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcBNFCom;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770022470; a=rsa-sha256;
	cv=none;
	b=gwd/4xHmzRPP142ctaNH5q1Ro57pi/mLaI9R7Cqy3k6GKImDK0A6Jn9vntHJRFUjc7N1lf
	DYVDLgJU5puXg0JINU5r/bteaMgbdwxQZxk6o6U+/oB9wWZsrm6dBYo9F2sXFpgtjjw+yu
	ATmmXsI4M4i3OX+yuAipOkf5REE5sOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A8B744074;
	Mon,  2 Feb 2026 08:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5749C116C6;
	Mon,  2 Feb 2026 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770022469;
	bh=MQ//LRuRwIOcuIdtbZVPm+JV7pTg2KFfd8sRxJWPxA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qcBNFCom2YKxtvDr5sWJo4j8GKmxq0ElE/v7IWinJfipbyDOuouxfnCz2AtIe7RNh
	 SkFGm9CCSCmuUCOgac3BTVJfYnn5Pa7IB4OA07iT/PCZGixe10UkY9N0+ZDAhcBDt8
	 4VMphSJslcqbSsdZrQW6rqJuH1nowgPWN0e6XjN0umv+O+6+jLnFOuBq8oJ6rcn9wV
	 K4UeIWmADalAgc7zztRfw2TQMpUed2ZIqR96v0i0dxyi/Fqecc5iKhJtum3TNp73ya
	 BC2vvMeScPd0DtmME4k8qIiUeXuLXdKu7Az8hL96nrbC3A/+DW6xP+e0k/mL0yhwTx
	 iYkTsHUJ3lNig==
Message-ID: <10e483b2-2aa2-48a9-bc96-2cfb8125824d@kernel.org>
Date: Mon, 2 Feb 2026 09:54:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7CBBB80005
X-Stat-Signature: bnnx6xkugzxzm5x9zr9zure46jyko8t7
X-Rspam-User: 
X-HE-Tag: 1770022470-808486
X-HE-Meta: U2FsdGVkX188t3UTCfDd5LRDewvG1esUFwx6sz7bbMWGtZjbiP1/03ADZwd2KgyJvzqNlbapxMThKYonwd3CIetBefRkpryj+2rSYA9+E+JQzqKoPlwWAjU+rHJlsWJ4cqqExsgwsIZLZpzffcl7VN2bjU1saI0pwrhDyyOP2e3YsKphe/maaqVYsZotP9o6YMTZ2QK9zOk3URWRIMWrkofann5Aya4JHzLLZvoxEnkrE+uL77fd18eUz5GJrn6sHiU1ehA7s4GrwFwL7EtUL8gObFZfnsZHNhQIHyQdFkr+dEbjKpgPImn+lCmMaFytPuJVT+xa/P+kXe7mPXscAhjyKutkZpq5BSUtetEgFnklSiA4Q2Zw53lCP0604z8jY6KcihI6Hpc6Gm02nJAKnwi6BV4cHaFyOF14t40tFotT5hYh/qFyBE5DPAnaxnT35xq392FQ3ZymQIKO4F7XXCQ+37Xy1pZxADaQ/JOzG+N4bGFpmuPy4EItyc7rhc8HcD06sJf0h4yfU61m+i1DvXB2UqH7X/fLYbgEDXWQHHmdK163LeJnm5VPKgcnifRqDEckcAktc9ORMt6x2zMzO9avKTx4wXG/03Z0Z3ZJy7bFLlIYNZaWMI3AWcqraKRpuyVN6ehFE8PwWvsXJAzfe4q0DoD8BApn/4xHg6YZL+B/Wc2EDz43HzaxhZCFj3JRtEdopyZcNedu43v21QyFtm3Az4JsZlW7bKMi9QJo/0CAnZykFGJkqsMnRyKdgcNEFG8t4QAVSF58IuZv7mXEcp9BpTXksFLIpDwExjwm0/BhrTF6DSU2Lt/Wp8lXcdi3M9MyA7rODduOiybT5hqYmDoza9PTHOit+Ds3H3DjFFM+sMC5vk9bWHWjPjDEW+mX12xGO4C01OZ4tNHhZN8KD/LV90I3J9E5fIdMKTwUmJL55HhzQnPR3et859T1FBK5eJALNkzEeNVH9bSSJ/4
 lFuokZXr
 eajUeQePLbd2nCoZ2xXty0+a2gnzv3PvI4i0pS4zXUDoUaIXfPCQQ3UWeca0QVjV/hXd4go5uZ6QIcSBkck7+avvRmkj2+K5VgWSuROYY5xr7465cjSa/+Lez3kTShtdYAXFlXkusbhRaD5wLUyhQSWkttWETWyHjf38SWKcwFL6JlzNU5pIRntUuZe4CYx5S7B/JLYoQ0pNiyjx9E9+00tDwJiN98Ps8aNrxTjUDdGlK2/8phmXaUANof7fGOjN1BYi7hR+FsltlzCav6nVfnWqd16K4u8Bdew8/Vuj9/BLb5152Nwn1SsU2auW787ZomEuk+bfedW37ODE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 05:29, Shakeel Butt wrote:
> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
> 
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
> 
> The assumption breaks in scenarios such as:
> 
> 1. Small folios allocated on one node while the THP gets allocated on a
>     different node.
> 
> 2. A package downloader running in one cgroup populates the page cache,
>     while a job in a different cgroup executes the downloaded binary.
> 
> 3. A file shared between processes in different cgroups, where one
>     process faults in the pages and khugepaged (or madvise(COLLAPSE))
>     collapses them on behalf of the other.
> 
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
> 
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

