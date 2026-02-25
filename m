Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6206EFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243036B00A0; Wed, 25 Feb 2026 03:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC626B00A1; Wed, 25 Feb 2026 03:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF1E6B00A2; Wed, 25 Feb 2026 03:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED7DF6B00A0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:20:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75BA3C1F39
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:20:55 +0000 (UTC)
X-FDA: 84482283270.11.459ECD8
Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	by imf19.hostedemail.com (Postfix) with ESMTP id D34781A0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:20:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=R0VUdg69;
	spf=pass (imf19.hostedemail.com: domain of re@w6rz.net designates 35.89.44.33 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9769W8VHpJro6GAQ/EcmKlyQChcM6EoaPrkzXWmeTLY=;
	b=BKSCeQehdDXeMrkMavQ/7N3E673j62Cg1ZGe/lqjvSJF8fdlUT7rN3nUnToWBF6gLEfAI3
	2jpojv8fJiVg+PzuKHYWdkupodXs6brSB+nPfqf0/4stYmZWx8MpaYe6sKq/O8c55Meo7J
	ZlMhlYZrydUIxb1x4/dkI7OiuxRofYY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=R0VUdg69;
	spf=pass (imf19.hostedemail.com: domain of re@w6rz.net designates 35.89.44.33 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007653; a=rsa-sha256;
	cv=none;
	b=hikNe+eB228K62weyybz6Lh0i7VV1RUMsBwxG/T9zK1D0EigvRGrKINURWKshuHsSqwoIL
	MOURRiJ6WuD/2u69KsLWjjRc9fb2d6W7ZvoQf2qNrrTU7EGbPqxBHb7wHYrH1krIZRPTmE
	cHQk/bW1A4jY6aoUmm0Jy1uxtXADwro=
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id v7wLviinLKjfovA8ZvdyyQ; Wed, 25 Feb 2026 08:20:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id vA8WvmkvTqfpWvA8WvmLoD; Wed, 25 Feb 2026 08:20:48 +0000
X-Authority-Analysis: v=2.4 cv=A55sP7WG c=1 sm=1 tr=0 ts=699eb0e3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=i0EeH86SAAAA:8 a=Ikd4Dj_1AAAA:8 a=XXQT6F6NWBzNftsnd64A:9
 a=QEXdDO2ut3YA:10 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9769W8VHpJro6GAQ/EcmKlyQChcM6EoaPrkzXWmeTLY=; b=R0VUdg69K8zE7eegG+hUV11zF+
	BoXW9Abokzmyr5TPW73yMiDDN34VajncGJZruUqfXcha4ei93ShH6xrtPKML8qpQRjQNZNUMTsngv
	yFNd2bPPV1DmahKvX6COL6LF2vi1rAxVtvPjUt58Tzcyv0mix6mfYsJA2p1ze9aizUxIzz3pkOlyb
	jz2ZCabE47iFzYOQ3a/Jdo+0SDtmdEShuB2T4Ix3HwY63SgLLubAUpmunbj7vuhhpzcgOI3V5AlQv
	d7GFY5ecpE9ts+M8YKuMIiu2DVOvkoe1vFQOqGePHu+bC2wc6ravKlM5H5o8+wKIb820cyeY2Q9QX
	4VXxl3nA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:46688 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vvA8V-00000000zeI-1LXO;
	Wed, 25 Feb 2026 01:20:47 -0700
Message-ID: <de0a394d-65a4-4f17-8424-2a1c9a82bf98@w6rz.net>
Date: Wed, 25 Feb 2026 00:20:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>
References: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vvA8V-00000000zeI-1LXO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:46688
X-Source-Auth: re@w6rz.net
X-Email-Count: 16
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGxPhqF9mOZEpiAIrOn6F8qKxqVtXc947Sgzf0IwgMhkRAKb38B2vvWgW59a1cJVW1SAq5s7YuC/jjJILm695geEUqtBNFkGZy0CfOarl+kG4zkjIgGq
 Iq4Pry4uGhkR0HZSuqHUR6xR3vCyxCASXrDUyue8UwWXplxwfvbEekeIhKp/OI6lQuIOkwGyNDAV9A==
X-Stat-Signature: jdkp499kafadecaq89953esdd5jius59
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: D34781A0006
X-HE-Tag: 1772007652-91982
X-HE-Meta: U2FsdGVkX1/unY+jSYEh7hPAExZPRDfg4zrWi7C73WWoStBjRz0EXBP1/CqYTs6rIw/Vlmt/fwdLFXEEjsJDLrZzl7yrhkpvrzf5bHUXklFCyE632MaC15PjP80D6bUksY3DurS+Jvl5UlVz0S9LJLtm1ngfks2sl21ZlS5rOqQhoUb/htn1fM/PTzt+VzsLnNcvplYhIAw4bDL9RGKo/ULTtvg3LtD+kvpxaydunlaCbSmOanoHlGyHMFr1QW3D+QybnnkIV8/8mAHCEknomSXTdmfghynwtL23ugLbwQvn8UuqSKWFemtm0QanVoQFQtrHpSK9FmWK4IVbG9LsmbhRHBWJyQIT7clyM7A4CJIKqXKtJ9jQ3jNrK65TTNWRWAWYtoYlO0jsSx11u+ZssvwcbHNhwgCr+5+717Q1W9nAjJPTT4h3Xv4lNUxodDkKL1pInEqBOOUMlr1PQFm4FiqnIY1ZPtH3IML2jzwCeZgk8vLznb6Vcw8pF0fU5fBx751WucrcqEgLraE3eyR2Tm4GogEj8x2QFcpkxO/erRcPIHD0NGr5Oie0+V4Y++X4IKoa9SckFKEI4HnVhhG2hSTBDFQlqTzbON607ZsVjgsFvGT7wGFNDJ8mMEh1Y6qkLu62AFOiWxUIn2y3GriS+nTwpYNNhQ2M0ttF6ZWbs67APedxNl761YYVyV8Dv3daUeIwdEqszadq4M4Nw5nbga7AQRdqBBBWx0tBcQYqSpid7RhvBXm6Hem+WrigwIOI7E5/HdKSsUi3jfgWDnz8Qu5leuS8gjqaDSwxN2N9SCuInWz2jLTmrSzQTvKrZ23JEIVRAMrqptkv+OpiReXir2qe95f7nkzQWFwTbEkCoQ4YrFV7W/IGdOaEiWax6yosHNvWmg5GB/YEKYsrCsyyD34VIWOEUztVbr5HR3wUpuXp0BIpLpZPtxFSqqL6BCKVpw38ednOzAE9MHRBa82
 d8kAmApJ
 6hS9nxZVXeqcUdbAMkpHpsu+enJbfKb31EBjJO/idk/ulepHXXQ5LFae9snz7ahR0IcUT1IwvKi3WSsOV96N2mmwYcjoklXxt8JML5fnB02P2XuKI4dfhfJbG1eYssElUFcQD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 19:12, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
>
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  From V2:
> - Collect !put_page_testzero() to get the right result.
>
>  From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>    loop.
>
>   mm/cma.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..15cc0ae76c8e 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		 unsigned long count)
>   {
>   	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>   	unsigned long i, pfn;
>   
>   	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   
>   	pfn = page_to_pfn(pages);
>   	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += !put_page_testzero(pfn_to_page(pfn));
> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);
>   
>   	__cma_release_frozen(cma, cmr, pages, count);

Tested-by: Ron Economos <re@w6rz.net>


