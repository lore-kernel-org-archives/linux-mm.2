Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0396C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 08:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC08F6B00EE; Tue, 30 Jun 2026 04:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98826B00EF; Tue, 30 Jun 2026 04:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5D06B00F1; Tue, 30 Jun 2026 04:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BCB86B00EE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:25:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECD44403B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:25:34 +0000 (UTC)
X-FDA: 84935894988.13.EB07E3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 462DB120002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:25:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrRzEu1W;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782807933;
	b=PS+BeNQKLQnHeqcYREvPSOjPUmYNziGEG6hMLh6sPSbIfBUIL7yyj/JaFmxiQjEt53Swcl
	aqrElK1ldNbwqRwHOLbEVSCMPNTSc3V1Qx8l2Tcebrwdn+I2Q5Gc4NqLeKvFK4Y7Ra/82W
	dmnf93jhpYMJWcfSEj3Dnw71Nad1o4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782807933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tiv5sKfRU7cDw1nDu0n1efMC2uJ4FhpSJnzoMpQ3YZA=;
	b=2koAmcjcvZ5luLkMH8cJraiBHexYB6ll2JO9Uy4w0FzVSNY4JCN26rv9EGlFgYG37Rv093
	RhkXcyGJNCcKPKLln+B18R3JKCkihGbOgoyqyW2Y/E9NcCKIUFhX3uaZ3kGAPT9Vv+aPcq
	4hUBn1DoG253b+3SCAftPeEuvFzEJuo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrRzEu1W;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7159D40341;
	Tue, 30 Jun 2026 08:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FC01F000E9;
	Tue, 30 Jun 2026 08:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782807932;
	bh=Tiv5sKfRU7cDw1nDu0n1efMC2uJ4FhpSJnzoMpQ3YZA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nrRzEu1WoXW4u/A28LMDLk6N4XxCgWA6O4IrrfWXawfj2Vzocz9WXjT/QxIEwe/fj
	 lMhDZ20QnHFdt76YZ7YUe/vlfrf4ADa5WnNaDWuNSDvCizIbgf2P8CO/EE6a9DRsxW
	 z3hfVKaoostuc9nsbvNx1FgH1OC/Nr4GXMztsPBzJ354foe+sDEgks6O0LM3Sbbm3q
	 aU4XHM434bFR2QAy2LmlZ03ChykyK3AkxHqxgbn2Uw+D3pvqwtb3ZaAi3/EwTjHa0c
	 vWRmoqooOBgbhQrUL1q5Bz90Abo3geyKmzBh3J355r8GKkj+8x7rDx7Wla38JUEPVI
	 yW607NT3WfQMg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 8/8] mm/hugetlb: remove unnecessary empty range
 check in hugetlb_bootmem_set_nodes()
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: rppt@kernel.org, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20260629163736.1606688-9-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
 <20260629163736.1606688-9-ekffu200098@gmail.com>
Date: Tue, 30 Jun 2026 11:25:26 +0300
Message-Id: <178280792630.625070.17772458635324199462.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: tbbph1sahm1z6g7b49s76e7toxp58j93
X-Rspamd-Queue-Id: 462DB120002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782807933-136065
X-HE-Meta: U2FsdGVkX19K53K8GuI3QyXS4K98TGZtVWaI6gdMcYd2iIE/Ivcy7j6Y832/4tFC4rqVfv787uoEKe+Op+uh+t+oIcgG/dyCfhW+Eb/oolmPy+ZX81vYMfVOa6bG80sRdlweJdbsvt/DLzf1dTl9KfPVxCJ/3yXI6jMhHiWMXKgEaTyl9Ojp/BG8cqvlqyvZhm6fYLxq8nHguAYLc/WmH/wSk9XvmPAfpwR+v4YjnDtvurK1rxLVTM1G1gNKpsG0paMhZFK2C0gA3J4hBUiR3IDhYeOGGssp4nxtOcJ10uQ9V8Pywj0iYTfGmsr65KhN14PgyoM+8IOL8uXD3basQ3tUpffIWG0xifzIxwJDt68sLLXIUPO5AoR424Fte5mCquoEjsLpTmNi9OEfvIdGklFYsoczuuI4KUwJTBnsmC1L8yvV6+/tF3bo4U+hgpHYi5VvXDIa9rB1N/h6TQfwWBK5pBZrHkomb23h5JA45sbzpcYwe/xKzBH/jQjwNQlZ4TZdfOw23x+9Gep+GGER50PhfWfjWHznEu1a3u47YQYe/6nN7AcNaGJx1NMinXzh0gQgV3jN9GVuq5p/8zm6lAr3P2K12fjO5IfeXkoIMxpL5HCvaz0nafq89P77XlbvG4CKs2rj6SeIxU628t5w5MZBkNCAfVbiE+UYD1UwYm1wmJerv28YxFMW+u75WsAN1QEr3X5lYqdQzLQ6stU0QuPjvHYbTl8k++rEAqW49/JeTTap/gRMJggs8UQY/j2NL1hwMm+H93NJ0wSpNTkLnN1DF4RoHe/73KWDOInf45W1SPOCfzS9N37gYe0xdevyjzTxNwDfOK1oNDSQVWk56dcQyQM2J7Xcsyv5r6ReKzMWt3Wec0TD9QNEEChAY6vTtYcm2zAZAvXVWCNA8RhGiRmVrCmYXV6whK6aIV0lbpnTc4hTvRGJTX6/22VCRe0UqHi+4CV3J253WRDnsZv
 0Mrtb0r0
 yAf2wb2YwsSS1EifzFcNpg86ADoIZawIUm6hAytDUUQvrNl2NzsuRF2jgUDSk6Yaph9GFrWVzmix4kDyO0/hIGkW61Yodsh+/Uq5AXPy6S7lj81rnel/mZjYlqGNbXvep4a4UCzSi1s02E+9EguNqgweI/2/x0uJHcG+RUP9jTs5/3t2eZ22G9HAXE4nZ+I2PNR4lrU40C6uVzoLgMuV0DOj5br6Gxx6hLfmffou7j034bKafnn0boq57m9hDICEqaaWwP6BJknDCmYh2kJcdwbafoq3WiQAj9VW/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 01:37:36 +0900, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

Hi,

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..d4d4c9df5f51 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4450,8 +4450,7 @@ void __init hugetlb_bootmem_set_nodes(void)
>  		return;
>  
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> -		if (end_pfn > start_pfn)
> -			node_set(nid, hugetlb_bootmem_nodes);
> +		node_set(nid, hugetlb_bootmem_nodes);

Sashiko says:

  Since the check was removed, are start_pfn and end_pfn now unused dead
  stores?

  Looking at hugetlb_bootmem_set_nodes(), it appears these variables are
  populated by reference in the macro but never read in the loop body
  anymore. The underlying iterator function __next_mem_pfn_range()
  supports passing NULL for out_start_pfn and out_end_pfn.

  Would it be better to remove the local variables entirely and pass
  NULL to the iterator instead?

and I agree :)

-- 
Sincerely yours,
Mike.


