Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C1BD73EB7
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 05:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35CD6B0005; Fri, 30 Jan 2026 00:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE37A6B0089; Fri, 30 Jan 2026 00:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFDC6B008A; Fri, 30 Jan 2026 00:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB0016B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:47:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 039AE13A56F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:47:09 +0000 (UTC)
X-FDA: 84387547020.20.41C9C41
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA226140006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:47:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WMI9hY1q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769752028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77Nrg4O5LoXp8ea1NF3SV8uU8VwqaIAVT4aaN0oPDq8=;
	b=Rc+gVcanERQapHztdnTnnDSJJMcI1uL3UoZy3O7MhGr29WIdRj4eYQHvr8vaYWjQq7wqd+
	osuZyaNxVMmmptMh+d2zlu23AxQ4iaLwQ9d+Bfun9B76gkfiKJCK8gEavL8O1qOTA13Ek7
	z6qDUhhIuQ28naomtY8PpEqjkugQdhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769752028; a=rsa-sha256;
	cv=none;
	b=B4UC002/pbFICCX+EwRE+X6DGtk2knZ0xJuL7yNRCoN/7r97MKiJnvQKn5nrA7ZxiT2uJu
	RCNmxlwQwcer4+TFjoaUsRRTlcQZmEB6saAfNNUMJQbnG/jUUZHaC7lCpfbL2bIwJsGgVT
	dlyluzC0CyL5Ej4RsTaPUG0vKSU4sxI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WMI9hY1q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769752023; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=77Nrg4O5LoXp8ea1NF3SV8uU8VwqaIAVT4aaN0oPDq8=;
	b=WMI9hY1qCP4M3Jf/mN1vNukwdcL2LGZBKpFvu5r99pUH/W7dAYIwYl16Q46XeaBIcdm7hhMjDjL398gxVNOrLAx25Aai60A3qF2HzTmv7zWx69LNt0lj5xS8WlUacCcmoWyHAd/bh6dEAEcMGq4EHHCNO8bkDZ05tyVQxFP2WOQ=
Received: from 30.74.144.133(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wy9eGt5_1769752021 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Jan 2026 13:47:01 +0800
Message-ID: <98256ecd-2b1f-42e9-9569-445909a1d223@linux.alibaba.com>
Date: Fri, 30 Jan 2026 13:47:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CA226140006
X-Stat-Signature: n7oot61gg8qor7iqjm3piuyspfptorfo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769752026-230206
X-HE-Meta: U2FsdGVkX18LpqBSDWybNngQnchfT16g4UQCkqks2ZBTvsYpRzLN4IeW/NOZYQt3bEzmdxrFQj+SdMSGIy9bujQmvaiWPFlj9eY7YZC2m4RStRYLu/jCq7qRI6tEKir4kraAeWoMLSbiyAn+aT5ScH2UPkH4hYedMsNrE4gyu1rHHjJoXRl19WCpsLiJlShxmX6pD8VG6euvVsSg/EwAjTg6tstIBphp1lGuVCyA6Hdj+S7S7+gWh6PH8fUDFM+ptb3RzkkfEg2zfhu40R5qMzQ8ybfhA9PNKMfUssHbwsYV4MLGr7AlukfvWZW6JA+eqBtfl2J6sKWk+fGHYpK/TPDOmgYSVGlwQEikKzgG+kPb0HPufc099JbilSgFJf/86eK5q+Cf1LuQR0X4rXHeD6bQlrc3o5GZIuoyo2rvsmMrs9rh3dIF0MJm/ia7vRipE0iye1XvBcaboPNrEqAMA0ty97QKJz7sz6mfZ1FGpdOWDpofjxCWFqcWtW2e5/ygHYd4Cvs2aV0dWSRxvJPRcctxRNpO/4sxPniRndJdnKvzWirtTrRUy+HoV4z0guVjGvu3OZBSiNPPRDvKNqeJk5dIR1AbRAai9ocG7kQPVBoVk4i3W3FwN0f28SrAJS5XLBT6DbXycXxahtpHpQ6PRTGbGPukaAIoli0EuFtfzbtZWx+pwI7ssLIXOdvyP1CdlOxHJOIX2p6S1poJwmOhcGYxT2GqcAwypF9kWm2gLMJUm5pNYrWQi0HNTiRW7Pu55iLIqCeixZMgVdGb6Uxd7zmhTGQRqbsNCN20YDg1UeL111qemFdMGxsR41jhT63bx6hTiR2IPEi1ScdAdqOr+0GWHWLF1wpE8sHQzkEVnYvGGoY1k3MuUmYWQiHWjX04peYfASPLSu0IHsOU1BdeREFYPe2kPDHaeDesVzjLftQ6gWrD77Gd+tU5xzHmfaUOTlGoIFii7TJXNLFq9jv
 6LmaswoQ
 mXVnk3TkmWK6xu7wpX5u8xqBAwiN49Ev7JKF3dSDrFKIuhP6L9AMDjNPxFsp3tuBL6cWkoKnFJtJ1FKUP8mBS3dUxoS8r5koqwqhS/NhAlZLeakCpGb+58M3IG9Myg23cPsn2b5zs9ZyLcehXbWyKGid0kVeooGBSF6eg6aL0XNIVPs1S32CgBInxh1rDFSxLtaWT86xaFTkTwf10UTVYydMktza8Zi2fOQu2WPyV1dOLOau8lhTJi+zGbL+tKixIg9KD+icBggvKasg3azZcrAzDRv/lFqafxoDzr2mqAVh04Bbqe25FBFoRfCfvn9kfY353RX7qYpw+mSyuRT1/TF5IAz7tSdvFNklM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/30/26 12:29 PM, Shakeel Butt wrote:
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

Thanks for the fix. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

