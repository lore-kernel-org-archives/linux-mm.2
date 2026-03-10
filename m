Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15631FCC9D9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250066B0088; Tue, 10 Mar 2026 03:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D38D6B0089; Tue, 10 Mar 2026 03:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF926B008A; Tue, 10 Mar 2026 03:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF2456B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:57:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5A1A1A0483
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:57:07 +0000 (UTC)
X-FDA: 84529397694.21.CD79028
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2399B1C0002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:57:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qzMBJqJ/";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773129426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23tUe0a+NwEyNwsMC6T0ScoiXnNceFqmSGaZ8YFbDzs=;
	b=NoWQb1rvSBi8HpcokTUH9a3ch+JSUOkLel567iYj9ouMKSl1Jr2PPQ3nfiiOujULmHWsKX
	Dte3A/UA1PouvxWexj90mKNeoPn0mZg9paulmP0kxeJqsTU9pJApwJpn4Nbkk1XeJx9PN5
	hhr8rlq31YibXOWC6xC/eHUBGAw/z9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773129426; a=rsa-sha256;
	cv=none;
	b=77N1j5IsOb98fODVCBIYg0u6AIEF6xTgWMMvF8IqNyFM5myzPUJcA+y/Ncy5nupr/yeo2L
	HrcySS7SitlfSqwGdNcYUdKgmdUBXRVtZi9KMUpT8yglzOHP+WlnrkA+EBsYcleSJG5oFp
	4DxcpRliGZtEuiofj1/AyvglZKXJqWM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qzMBJqJ/";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F17E60054;
	Tue, 10 Mar 2026 07:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD1FC19423;
	Tue, 10 Mar 2026 07:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773129425;
	bh=X9YMbOQWGRlITo5g86lvNrEVXklk0jAjT5ujJ5DMb4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qzMBJqJ/CkX22YMjxInR8KPOs1WydZlWfE3u04qA4qRQGBtS9ORp5ykmHbbMD+FT5
	 iRvB+omVod31Eh1004YiGlNXtSQmilLRUmjU7eyEhHFDNmJ1jmKH80omHTUeAiC3TM
	 UpKmMIMRnqb5VHDNcLDlFJ0l0gqZoA6Qg5B6EmoAlWFNq3txMOKX35KeyaIj1Ff0MC
	 Mkc45NpQ7TeXi9npg5eZhMbVpxDBDhF4LQLwaYG7ICwptEIo6zG7H+sgI0v0+QFzjp
	 E13QV27r4xwT4/IX0t2efZo5zUTPOcPKoeKFdrtAoAHqOvC7DFkQdDDm2vKet1EFmG
	 dlLyBt/5fqwbQ==
Date: Tue, 10 Mar 2026 07:56:54 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 1/9] mm/rmap: make nr_pages signed in try_to_unmap_one
Message-ID: <21801fb7-0f42-4ad3-8b85-2ac6013b8aa5@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-2-dev.jain@arm.com>
X-Rspam-User: 
X-Stat-Signature: 3atryd6ncscxc3yhraaqnc6h5if9pg5n
X-Rspamd-Queue-Id: 2399B1C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773129426-191759
X-HE-Meta: U2FsdGVkX1/N+pilp8QoFgJDzaBOrlYtWbVYrHuAxnRjmboqPpHnDuPyh3l1lJhwGnXTWJmxFZ9mmaH9U0DhZTr9DRW+KjbZpUkULkRTKQ5Rsk8aG5j53FMrWLV0KkuFZ63OYUVv7oAWf72VojORWLFQMjgvVCpjQwC+8ysIMTbqp1nfa8Lt6cuV2v9P1l17wPbvAPapB0cxp3svLtlB2bFhUoO+zbUr6f4V7n8uuqvbB6Coi5zH3M1PgR0wOhgiNImw2ltHW2S/AKkkBCzBKqb5mIO8icMbTL5JFMzt32IMJVEzB7B6rL67em821Nf0wkha6JqQvNDU6iz9xavI7Gbty/sF0veBopXSCgUbI/DEYPtngjYdUOdm/FoG+DORn5RwGwx/vRV6pAUrwaIxM8Inp9kYka7o+pd9rW+G4rKT/OjJdjpKSZ0qPSnrAGzcLocYqrnakTquLzjx3S99a57rwsd1Dp3S5zU9W9BOdqYb9+4mglS12sCWAfKg1F/h/et9XtddvOEnLsK0AnP4AE+VFeAdPeXumD6GogjrK10G11mGJ6yYdfapHq27cG9GjcCfrpZC2a+pdNIWTBO6zi3+VgO4XZajZ6KQ14nZHVA/pkMXCp97AXFnc1u+1dO7dIYsHhKN6WlofvT4VH4s9YSP1NJUrkufT4i/cpAnSa+6p4IOaytTtrVMGZpvENVPlv/VcjoyHAI11l2pYIflZnGrC8eNNiGeyEjtqP60VELArw0CIJr1mdVknxh75ZrC5v6/GJL0ckel3YvhWs0fAn8DRaa+OW8sDWt/qoa/o4lezCq0La0a7xMRSPycPpMJurfqE69Oa5kb7vzy6UPDH5Os/ohgQ+r+u8JwhCuokP+G3hhD5lVbK7yOp9OB+jQXeyErqyelt/B8dtpK0BlqCvOxNcng5roFRWN/z1ycEz1XTR8poeUgf5YpeGH2SBmmXB7xH7hJBV1M72kLI1U
 N67EylNA
 FGvOa8qW1AR6xuS0Os4we87uKCUI9r26Kcjce5qT7HC2ML/jBMb7lgPP1VukCQNv9Idb08N/WuMmy5aCwln3LzbcJ0sGDA1PBj+RiHvRNf7v65QReiGxjkDtPXIxOZdJWxKQdo3DfPX37bZX99OTOwJkTTjM+5exbym6Nk/z/xNuzMM6EPEGOZnh4QyTMQ27KpV2kBQ/I/a7ElFZuCGipmrd1ecuPAwYTeHgQC+f1BlfJlhJcgejhNAex+EhEmi+I4saJn6TMKvAHlLTA1u30uhRvlxac2MhRZSqEQhFIYRF0rPcPFNdyrV4MWj/TF/REqsdv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:05PM +0530, Dev Jain wrote:
> Currently, nr_pages is defined as unsigned long. We use nr_pages to
> manipulate mm rss counters for lazyfree folios as follows:
>
> 	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>
> Suppose nr_pages = 3. -nr_pages underflows and becomes ULONG_MAX - 2. Then,
> since add_mm_counter() uses this -nr_pages as a long, ULONG_MAX - 2 does
> not fit into the positive range of long, and is converted to -3. Eventually
> all of this works out, but for keeping things simple, declare nr_pages as
> a signed variable.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6398d7eef393f..087c9f5b884fe 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1979,9 +1979,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	struct page *subpage;
>  	struct mmu_notifier_range range;
>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
> -	unsigned long nr_pages = 1, end_addr;
> +	unsigned long end_addr;
>  	unsigned long pfn;
>  	unsigned long hsz = 0;
> +	long nr_pages = 1;

This is a non-issue that makes the code confusing, so let's not?

The convention throughout the kernel is nr_pages generally is unsigned because
you can't have negative nr_pages.

>  	int ptes = 0;
>
>  	/*
> --
> 2.34.1
>

