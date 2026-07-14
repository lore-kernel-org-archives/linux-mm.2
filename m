Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30400C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363DC6B008C; Mon, 13 Jul 2026 21:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED536B0092; Mon, 13 Jul 2026 21:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1914C6B0093; Mon, 13 Jul 2026 21:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E17106B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:26:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E20F12023E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:26:20 +0000 (UTC)
X-FDA: 84985641720.29.1CC359F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id B10611C0008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:26:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p0iZ8MLW;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783992378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIoMcvTFIfW1r4frYiiiGythz0GswtcHVUqWTKN3FCg=;
	b=rTwoPe2WI2aaj6PLb6cP8Y/ED8ZW1Cs49ZhTThUA3KqHmWmkZWpIAg+O6Wfje9sZnGWmdg
	t2WKoclQvJSYoeVHoEeO8TfbcSTUP7yf6QobVjFOn0rpBEDPtGNJIVWQUAk7Rj+vvZIQt/
	1Z/gfYRhELAxZTbBsdrUoIoQnoBjNkE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p0iZ8MLW;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783992378;
	b=Nsjp5l0l0cB859oMYAqKXfEXd8/mp318y0FRotai3miusEp3Wc6ccYlRfxkzYtCXSWcUFk
	1J8x5tYrQVGW2ShUyWDa91LGOShXX9XuIKezHl7z7wjEU7EAytw2xJw/J5odMjbWiHvMlY
	p95D3cXYrLBRksGhcHXtPG2168k466Q=
Date: Tue, 14 Jul 2026 09:26:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783992376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LIoMcvTFIfW1r4frYiiiGythz0GswtcHVUqWTKN3FCg=;
	b=p0iZ8MLWqrtzSMozPGPBlmXzYUJbV1J4YFEDh3bp1JezJzIjDNhTjFZusJYgmUoxgfeX3G
	LS+Yk1SA9N/tu1O5McqLmhrNEM+QCaP+JHeW8bOChZcHbenLieXN/ag56PTEY3KvAs6ZtY
	7HSSoeK7EVO+ZresGOvtTBQ1hrJXVRE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm/swap: introduce struct swap_io_ctx
Message-ID: <alWQMssVSvO8Zp1U@MiWiFi-R3L-srv>
References: <20260713093350.2154226-1-hch@lst.de>
 <20260713093350.2154226-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093350.2154226-3-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B10611C0008
X-Stat-Signature: ukxgbe8s8r3u3n3w85nybbxjn6rzq4af
X-HE-Tag: 1783992378-48140
X-HE-Meta: U2FsdGVkX1/mKCtHStPtkOFM7Dme46+4Cnq7YHxkZuAXKkyzFx49qraRq707JcS4oGyc3/45wDHUWVKshzjWrvGlBCGrQZcOvMjddr929m7HWneuYEjPXddItB1iAuKEaAzBPtwWfOrXOVAr4UaNBL15Xa5s3bhN2im0qkAQVh97JKYiAzLS+4CYJkrby4Lnxbnybue3WGRXKy9OeUNBouXqvLGwz1GHI35kYYh8ik6YHS9mIR1jMyBzOIy6JJ5yWY/AvP6vjhP3BQxAvrLBq6an4MzLppR8O7xHCJD0M/gJtq2nhirpV1l+7rh8fVzJ9y6mc4a27/PxADyC2hPe3fSY2Y4riZabNKU2FdjdNlch5hrRM5XZwyaVCKh2Na54/n2YeuHYs6phxkFnScXKn18fSZjDmMuy54s9HjEuQS7cID+VmJJsGP4PyMsZlqig3sssZhiIYBmnEzvbezuDGfu8AgN/kNexmUP5mHRZe7ecAvivsfk3Ek2PCHA3LVYLkegZS0QNzgxFWJBVg3L/PtGFOB63xHiho77NYVXRAPzR4wcx7My8bbb3WQOiZ3dgY7A4V4Gqh2DQ2kgAf4xSTOBXXLtQ7bGJ5VzgwJQmXOQKLWLv7DGVuluTM4M6PR05v1b6M0Nj0SxuTP+GRu0G0+81w572KhVAToWqI31Q/bIdoxqt2brZJcfilJKjjTKu6u1FsR5D0XIwRZEmUH0sqkZalti2+heIWA1CY0HKIpURwLYNF8uy9z1q90KmU3Lttmupwun8Wh+igpBb+UlKGacuHyefsfc2p35kyWVJs1y4ZQhzg6BKf1kkWqp/ADQjYpTQHHwbb1J4SU3Wt9d5ECoL+f15oh+hGTFN9jvQS6stE3Kj4RT3XiXLcHxCXlScEGKqKGNzcOjVkPqQCPS9/E2cE3WlV+vKMC8DGZvxLy+4tjj1VhLdR5xLJ/rGj0Me2+qDn5olLi93aTsHe5l
 RfQdBuz1
 1P2ppR1k8UD7GWGhMv/F38rNywsE+Z8IPMZKnGD8tlbZI93lbbqX585yr0+MyCWclllSCEYIJxwNGfJ9GmFD+t32Eh6GzNvCYHRD9b19t9uXZkKqIRTz1rK6fgDIgu2vt2tayMrTgs1+P0efRO3JslxF20lji2U597iExcaEAWArNhn7lJVaQF32uo1AL+mWvwBBb/aqVY6/EdpKvBEa2L3DAHtUQWTHRCVafJueaeS7z2k/+MfrUoS30qJ0/9I/tRmmbH8nR9GFvxze6IpWpQPcaCgEmn6BCg5MLnVNnGX2sAw2DgUfSgr8fKaBcoFWFCVRw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chrisoph,

On 07/13/26 at 11:33am, Christoph Hellwig wrote:
......snip...
> @@ -212,15 +212,15 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
>  		pte_unmap_unlock(ptep, ptl);
>  		ptep = NULL;
>  
> -		folio = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
> -					     vma, addr, &splug);
> +		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
> +					vma, addr);

Could you please help answer the question in v2?
https://lore.kernel.org/all/aiFaWmCWgEWAFj4W@MiWiFi-R3L-srv/T/#u

It's not clear to me why ctx need be put at the 1st parameter. And if
only replace &splug with &ctx, there will be one less line of code
change, and this applies to other places of change.


...snip...

