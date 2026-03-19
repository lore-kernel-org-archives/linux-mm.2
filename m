Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 099D91088E70
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B156B03D1; Wed, 18 Mar 2026 23:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652466B03D2; Wed, 18 Mar 2026 23:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F696B03D3; Wed, 18 Mar 2026 23:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45AB46B03D1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:29:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6600B818D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:29:21 +0000 (UTC)
X-FDA: 84561382122.22.66E302F
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 26ACE1A0008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:29:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SiMp9/si";
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Jdin2qZ38rLer8OS0q7B4P3hCVAxCOXUo7HjD7FoDE=;
	b=C7GE1z/Nf0sIxxLQOMjPY3yAh/NrayMHuP3sxE9PgyrnGG7glXCNcKdVDyFrpQJvD0Leyc
	PnfFy48MXHVDAijZv6Ab1b4PKC7ByJXsqTJSYXjo3FbXV2aSbW1TtxqWSxHvZe8Bp+D2oA
	/QUtmvVnrCkU/usb74c9PmrKua5vfQs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SiMp9/si";
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890960; a=rsa-sha256;
	cv=none;
	b=N+c7SkCh1SJ4Lb+PHQqelKUxtdvbo1do/MfSbbmydKWwG7Pk7YA8reYHmOrs0NrM0DOgyx
	8mT0XTm1dbGROY0HUqu3BDRKOpRYTR6oA3wQX836Jdf+dLvvTUMWbA7ywEph1lBqZ5KsH3
	AuOP2V3q0czLGdjv89SEMEBuFg++1a0=
Message-ID: <4492ce34-a498-4ec7-86ac-9ac1c164baec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773890958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Jdin2qZ38rLer8OS0q7B4P3hCVAxCOXUo7HjD7FoDE=;
	b=SiMp9/siy8oo1yxfsHFN2LvE5xOmdmA5kGs0JVjE6qrFKJjVjbZaMTILA/dsyNw3eSo6WU
	vOys8OEkVGvUMMUYX9mMJTqgBAD08Ucm818Sc133Kqg8YNkEaysdtRacE3l+uTn6cGExTy
	Aw5e8wGJ0HBjFc1FNbbNd/e1JQa7HaI=
Date: Thu, 19 Mar 2026 11:29:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/8] mm/huge_memory: have zap_huge_pmd return a boolean,
 add kdoc
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <cover.1773865827.git.ljs@kernel.org>
 <20e00d784adf1540c32b46024a709dfe1be93019.1773865827.git.ljs@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20e00d784adf1540c32b46024a709dfe1be93019.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 26ACE1A0008
X-Stat-Signature: 31k1ez5ne3qp388ox7rhhpp94hbjqaa8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773890959-260797
X-HE-Meta: U2FsdGVkX1/gsIQSaYEqss5qvlxaLUpZ1KxJKFBhHD6kRh3A0eFO4XmjArZHwz84ylaUyTTVOwjSm4ttPsNYDI2kA7xC2qlt8h9JMA8wLOLIFATDd3OVuNrCMeoR9LFZcbDU/c17NNJvXgiktAPxkX++/mbDyzc/+Xx5oJByvVorrIVUBZ2N4bOxPI/cDC29ozTsyDCJutgIiKq1Fv40/wCf3VXfwQY8hnAdxzLYNyjy8+uMW4iSJPcFuTZHl/xSaYiTOIumCPgZWlsjAQVGe1tU9F0QMOcvOzTTHXCXb3tw0dB4EZBA3xLQr4g5BImtPf+F3wk1yfSZ4i4acrsuSoOijkJ+QyCxoFiWrng9sGoaeyG1odY9lIsIR/oyjn6yhFdDrNs5vZuuktfh1hZRqJUAUBPt28K/mNeWbRlZuStdk/Mo4KHnYZGaFjCmu8kyLCxvPk2+4Z2QQwsnd64r8awW8kFQsOTG6Jo+nQeB5frRTO8xBZRf6yXfRR7qsQlXcDz4fFz10aq9tFw2bLpMuBekfa0UtJLJcha5tN/hSru26j6sMq3lYtDVyMO+lgMiQtxTe9883w7OPL+D70B2+0od97fpm9IM0/rJvOU2SdCRHc8GwrBuNYohFHFGMkZ7JJtR4ju3nhfqgyjvNLHFZFHvSmf/uLm1qz5WmZXN4pxN1TkAhgfvFjE5a6n+CFVk9kzNgaqa9y25MZeBsvuMjoIdOIugy8t2JGVNFpYa4sznV/hWBiR3HGTy8Kg93+zY8ngA85ykv0fzVNOomNS6T+jb13mpepH1n72SX6f7tTuN8kq1TRZw5xvlsRbI/A42VYMt7tT/z7qkHoiYQZk7tMBZu6kJ5cmRP60s+yM1uluz9bF4v+TIwAwQ7lW4AEfUW+uGriND3CGd4a94t/akVuYIirOuiLono8dRAVBixcI6WHW7dyCPN8iMSBJ/U5l9GZCGjYaFUZYpjduA1rj
 rqMPOHuP
 uBROHo5cuoW5vWcV193uJSoub0DzUDiJTbvR81YhlMpWUH5hmX5/jo4U0NGWGXouE+jWTrLfi75e8GhRoDP3nIJY388+OqaP/MswUPPmkGbXUdeLYouJpPTxLd1EHOfk4+pnfsJKp6pNd4L7wt2cS3t0mqrCZjvd0wSL1/p0Fqa5t9TAtB+ew8nQyuZMCbCzt8oDsaQ037lQEpW48gKpz3cYUYiCxc1+n2xALx5t9mQFH2PtRtOoRHF+7fmsfBOoKwbPmQrPqbhrZhB+WrlgTWZ7oa/tSYmZFm8PP0owpN8iR1dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> There's no need to use the ancient approach of returning an integer here,
> just return a boolean.
> 
> Also update flush_needed to be a boolean, similarly.
> 
> Also add a kdoc comment describing the function.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>   include/linux/huge_mm.h |  4 ++--
>   mm/huge_memory.c        | 23 ++++++++++++++++-------
>   2 files changed, 18 insertions(+), 9 deletions(-)
> 

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>




