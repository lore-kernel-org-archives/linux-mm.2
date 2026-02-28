Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D6E3104892C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 03:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE626B0005; Fri, 27 Feb 2026 22:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5BE6B0088; Fri, 27 Feb 2026 22:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEA36B0089; Fri, 27 Feb 2026 22:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0726B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:10:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33F981408E7
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 03:10:59 +0000 (UTC)
X-FDA: 84492388638.03.25234AD
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id F239E80009
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 03:10:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/IUwjHo";
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772248256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYQQLk8wpmk+sABOYPuHFRoK/LYQ6t6e9PEJlhNNQ1c=;
	b=g+onUtP1Pemr+G5WNo8OKtEseiKJ+UhmvIlqS1/XdkLAhNMdHWyFETHAlqPmsxAcbtItpw
	2AKMzH7v4NGARBF0C25J1qrEt/n5pH1KgH6/sVWgzp2/sSxwKqXd7d1LT3zvvL5Li7bJiR
	0gUGaiIR7SaZnwxkBHF6bWHf0gswV/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772248256; a=rsa-sha256;
	cv=none;
	b=GazJNZpYkCl3XRU7qfXgJzyAFcjjBvrF3Xascn1evxHKOdrnv0gk1DX/7WOJ8WlhGa9+YV
	Dvu28+M12TXc3FYXVLpMk/HDK6JqvgKTGquoHD+AAQha+BJc98FAKpJ2cuvQho1xTMECPA
	2TJAevStOt5yYYQu+K/ebNd8GQTxIIc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/IUwjHo";
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d9e30bef-621f-444a-a1b0-510c50927d9b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772248253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYQQLk8wpmk+sABOYPuHFRoK/LYQ6t6e9PEJlhNNQ1c=;
	b=i/IUwjHoBmbin/bk4vmzAyNuXXnNsDly9+ntzJ+UD3h3i+ybef+o76so/8CXJDE5DIeaBh
	KBLEDNWenb4Ov8Mc/yi3lIUejaCsiv3OD4dv8VHcyYBNonnljwaj+M/qAoUibHlR1xEpTo
	K/3dqOsB2xj9dcW8neHDZYTamke2rrM=
Date: Sat, 28 Feb 2026 11:10:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: fix a folio_split() race condition with
 folio_try_get()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Bas van Dijk <bas@dfinity.org>, Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260228010614.2536430-1-ziy@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260228010614.2536430-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: fpuydwi8bj8xp86keuae3smpa4rx5393
X-Rspamd-Queue-Id: F239E80009
X-Rspamd-Server: rspam03
X-HE-Tag: 1772248255-693435
X-HE-Meta: U2FsdGVkX1/4bn7YgFBi9O6zHFvYmG93X1H5n+LpCuqNn2Tdnxg7upcWOBlVKkUOG2jjoKFyF5TpkdicLiAt44bpsbCwrH/d94HEMlEeVZhkJDZJajZIllj3KtI4iyHLFzN+DmwHzC6r6dURIreQLbn/ly2gpmDOd1JQ0VOudf98hn1VaRzBiA0ebIc/3XZ+gMqA+XeCssnX8KW2xwQI068O4gDOfSS7bXWKqZV68kKKeY2jYoDRYdgkOGSIgdxSuRYVK277eqssvqcVUaq/nPQLTL49gTMS8OQmDBoyqB3IWEJBCwktx37JxbsV1zl75ueHpXPsWL0DJYCaKSJxx4KknKO/00aVkqAGs+04GC680xYg8JLWzHFx8yXBmYqnTWAbNMSz7bq5GK8awoIkZxk4bwyZQElKxJW1d83+9GglCuACvarQ4pRV3+7oX3/rMC2KwMlYvKYUxonkZeBrgoJ7eAu2ny7HUfQTmqhcfm7Uozanxpj/6Z/o44c+Z1cDuffdsmCOm3UUUpGvizuf/q0wGVXCwsipGUq6YtrXdcpeGF2LEz+MACffmZDm9zbwPtLiL39UPSB1WmTp+rhxZxe01KBnx9BN6ltJ2X0eCDN5Oufvcxth9m7+scuYemISGvEQAYVxJJ8jiYUrVbIOCcqlFojVNmBtNREI/7TX2mt7uhUGOKuBd6mdW/SN8RceIMn7oBY8z/YezAuuUmq7wM3iH0x8XztDRnuW7RGCetfcQakplFXkRYuW8WfQOS27+ewyk36224tny5Gt4E5BdiBQlw+kH3nIbpqvvFkdvg4SeR6bY4owFx/G4zOuApXPSGTxEBU60Hs1DtU5gwCD9kuaUlsTfsI3IpxTvjtZpSPQUTWuuP5B8PcIyc6d1RVomqvTscI5jYOkbMZMIjooSTVQkV2JB9DRyMZUVVck57+cU9QIaXgTLIVfLlslbdREkx758dCED8uKJQjrcXo
 zqj/gDkK
 NpfO+9UlZ87r8ZbsvR9JKS2cVAipqkVOl/ngIsE+PZfDTFWAaXGdrO9dJJLu4etwQOWX7XdkA04lnYQ2fkTGBt4T4TcEOCNYksgWt9vA/x3ZZEYrWpTxye5shd1D7+YHXePePNYfOK+UWWcN/fhi053WocH6wWWzAr5vk+5h4vHE+aqt60H+ngdN4X23NBFmkoqOfLiaZZZXifTml3tPtGp/Ode8bmjYCYgb/++lhRJNjc0qWNCgRxktdtmcGbw13CCd89vJbJ8mwOnmA0JH4cpdEAIMyhgS0m3/QRGsoEKYUENkRLPVGnVbu+q1eg+HYSnWNeNiozHbKNr/F0sTphO3zS2aZmS5JBHQNyj1wzYDc7KnnzRtixVbtG/SMPRKLXgjW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/28 09:06, Zi Yan wrote:
> During a pagecache folio split, the values in the related xarray should not
> be changed from the original folio at xarray split time until all
> after-split folios are well formed and stored in the xarray. Current use
> of xas_try_split() in __split_unmapped_folio() lets some after-split folios
> show up at wrong indices in the xarray. When these misplaced after-split
> folios are unfrozen, before correct folios are stored via __xa_store(), and
> grabbed by folio_try_get(), they are returned to userspace at wrong file
> indices, causing data corruption.
> 
> Fix it by using the original folio in xas_try_split() calls, so that
> folio_try_get() can get the right after-split folios after the original
> folio is unfrozen.
> 
> Uniform split, split_huge_page*(), is not affected, since it uses
> xas_split_alloc() and xas_split() only once and stores the original folio
> in the xarray.
> 
> Fixes below points to the commit introduces the code, but folio_split() is
> used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
> truncate operation").
> 
> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
> Reported-by: Bas van Dijk <bas@dfinity.org>
> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: <stable@vger.kernel.org>
> ---

Thanks for the fix!

I also made a C reproducer and tested this patch - the corruption
disappeared.

Without patch: corruption in < 10 iterations
With patch: 1000 iterations, all clean

Tested-by: Lance Yang <lance.yang@linux.dev>

