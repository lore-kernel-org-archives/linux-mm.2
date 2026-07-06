Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B654C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FC26B009D; Mon,  6 Jul 2026 13:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9086B00A0; Mon,  6 Jul 2026 13:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964E76B00A1; Mon,  6 Jul 2026 13:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67ED56B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:13:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B79341670EA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:13:58 +0000 (UTC)
X-FDA: 84958999356.08.3400C5D
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E8BE140007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:13:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wq/bsZxk";
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783358037;
	b=gVjSuIJbbxBNrd0WrJGpGaopE/RaA/XkHW24sNbuqcC0r0NeCE1uqAan2qZp8KQv+BwZIe
	qZAFuUvjCUzX/HQEAJM0NPYCvzE4fUgNNBf2rP02wHrYqSgWpsaAnDd0nCRu+thLGcYUJD
	4lmtZGuz20Vg79yCvnpQkTezL7wvDv0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wq/bsZxk";
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783358037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYBXnEO5ho5yjc38RkkAzyA0H5Kuo8pmYf/iF3Dm/aE=;
	b=Kx2gKcP3olX1OlbyrmomGi/75yVJX4FkWJuuqZSTFiGcJeKc8UdYt6037Es/ZzcJHE3ELp
	lNZMcuwsGsanNP5BW3BftsjCbBKSygzJWXFts51qjQSpiwZeb22VUBk+ZnKQgTysixQnxU
	m5jTeSSVAJtUnQRC67TvMa9er+QkHes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783358034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wYBXnEO5ho5yjc38RkkAzyA0H5Kuo8pmYf/iF3Dm/aE=;
	b=wq/bsZxk+uUleNpI29BoyVUAWtfH0wjUWyCRpB+20iruD48WIQXzTnjww7CPzrszu8IdgO
	wYquS+7dDzM7KW46jECbdbFquPnTSCJU089t54O7PvTC7peMoJKVsxX+GrQB2ZOHDm/ZPH
	MH4rb6WAxX5U1f6gaJFIncjmVYDvs48=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 4/8] mm/khugepaged: fix outdated comments
Date: Mon,  6 Jul 2026 10:13:37 -0700
Message-ID: <20260706171338.3614400-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-5-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E8BE140007
X-Stat-Signature: zox6rkq1ffa6tw4yzxekx4cch5dn18fc
X-HE-Tag: 1783358035-513956
X-HE-Meta: U2FsdGVkX18+mrPPkYDlwf9BWyCXkbbAswmInu6VcaOth9qdNV9CV/kuy9orHj4Z3Fy+ElqaFuGZDkooth/JSC+B0FTpNcUCHY07vWjsdxbHILJzGc8OmgS7vgIFvCibkLEQmJ1JjqWfaIPZH2FrYQncWN8TZUuet13yeLrbSuJNbmTqjVVAJwcHYLK2dx/5bh8Ff6crn0xp09IFP2e4H04s9ZOTl8duPH52ab3irqSaauB6zYJ/HeVgroRc9YecMWYxHwPiGvpMrOtFtqtLiuLcJp2gdMtpARDEjS8HJ8AWRbkn1S+T1zlO+UVusqGtylHFlwFNGyb4NRoyTwzxEsdo6Gyl0Ps00xPzHr/xigAbvIi/LJiP8LjqQOx7meOb3lHbBysniCxp1jyQ3iDxN093sFDa10pd7F9jQSzuemqalZ1UVMmcDTx9OmRmEPFoxYF5deIVeSQ5b/WgcEPAyLrhyF/HSvXoWg+zCkvbZ55o42rhncNcBQ4vcD87k77UncvVMkrEaEafQC8zDegR7GPpXCOB5oCi7bhZSGFN0Sm2jVcHrtloQKTIEyWxo1nJVnqSNOdcjnE4emJtaghSS5Muqew90fOF1NzuQUqTxZf6WCWV+So+4wjbhAzut2HGmgv9Yrr1ZFxjsHzwRUNHsiH1FPQN/3KYK9hakwfTdSVUqg1ijib/TnTyIP+72oCgHBSd/7hbF5TEcv8ScGzs2CeDT++eI0XbOLZW5YnqPrirnA7tW4TE6Cpwcl8dXlL7DJp3apXzz40QeR65PXbBUP7V7bDG+NaqhREWtsO67LlLZV3Yv2X7wrLUeuz2xR0V3EM7357tFJQoS2EXOy8iZv6uZgHCmQ4l2p+x9ctFSEXZKoHp4GmT4HDnkHdxFwPlpCAxXMzfLcGAyuBRpBVipLM1yoGQXOjrFl7CG322GNfoxPAriUOmiH4zkcbXaXQEK39ergwB1UIeddKhKPR
 0CCtDGav
 KhYt4HcQUW98YB6pHlF8V5GzCwWOD2vdot11OGgL7cbjPZongAnY4gMFQht7nMGSs8fBi/Awmy6cD/K7lQt7TdMNdmxjCJGHZUjWqYDyZGxnoumLenPayRzlkpzEDKyk8k+TRjYHCYR8BSezoka/difGU8Rdrmk2QBTwpjCY02hthsh0Ds/J6smZQkTykCq+FXG6XltYbzb2OlrMQW2mDXfsZ84Te9QeJ7jS1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:51 -0600 Nico Pache <npache@redhat.com> wrote:

> Fix comment in collapse_scan_pmd() that still described the old
> folio_mapcount() > folio_ref_count() check and a "512" false-positive
> scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
> which doesn't suffer from the same limitation.
> 
> Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
> when the code actually uses pmdp_collapse_flush.
> 
> Fix comment in __collapse_huge_page_swapin() that referenced the old
> function name khugepaged_scan_pmd, now collapse_scan_pmd.
> 
> Also clean up some simple typos and stale terminology (mmap_sem ->
> mmap_lock, PG_lock -> folio lock, page -> folio, grammar).
> 
> Assisted-by: Cursor(claude-sonnet-4):4.6
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>
 

