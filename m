Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBCACCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF0D8E00AC; Mon,  3 Nov 2025 11:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA70C8E0057; Mon,  3 Nov 2025 11:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3F98E00AC; Mon,  3 Nov 2025 11:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9F68E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:39:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F77FC01FA
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:39:04 +0000 (UTC)
X-FDA: 84069855408.01.D474647
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8931F12000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:39:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FakmInk3;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762187942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYvhL7W4k7bZaqAg+5Qo3jTA5a+2yjdrv6jycIhaHTc=;
	b=Go4pjktd60U9XzGhIx3WyzN0ksUGNXI6LLzUA87awwSBvBr+g1xnsuyAkq2ZoOBGrJTmly
	GGUTwEJyOXnxLNkkBxWYcrPS1RIHD47/h+TEQxu9yOK3QSgqKyJTtyrD/0bDnHBnS020R9
	d9gdlcxI7GgRjslOrX8gpdSxZbDqjYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762187942; a=rsa-sha256;
	cv=none;
	b=p66h4EhUXHF1YoZ9rb56Ah40k1dhLM8wqFK5jyj++W0pubajcomvZ2rptcHk4HDFcb0zu2
	J2bdd1pdjJs3QF03ubjzo8XcH/TXd4ofThxdDIKBs/zpmZz85fxDb3JbvPqmnD6jI/eX+D
	WdDLu1hu11beCpuv34ORpiW8469KXQs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FakmInk3;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0269601B5;
	Mon,  3 Nov 2025 16:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1150C4CEE7;
	Mon,  3 Nov 2025 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762187941;
	bh=MJf28eCwFjXy43H5HkPqmDjsZqFEkChdkvJCw3zVsbc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FakmInk37hbSkL1UHSx54jy0CI61iH1VgLKnghGMCpnPVWHqwAx5xSsUC0yeqMZi6
	 2GmCQt5UVt1fR2a5SLg1lEvBS+XECag4pIoPR0D9Lvdgj+Qq14VBP6wkKycGgJv44e
	 pyiA1tGhZLqAslFWZedz5dZOTwgI4IC6sqYoeBSqTf0T9UislrqMcrXKujaoF4EYmu
	 w02Lmva3QPEzqjXBtJapusaYj6QieQ7y44LsSMzldDMwnqKBXWFtekdpFbPcrbHeHu
	 bxuJZnFfvsHS66DyHzpz0gK9UBUwrFSerdYrIVLaFVi2ndoMu9lYJEySXC4aHzVRJr
	 vzEz0sSA77Geg==
Message-ID: <6ab96953-3475-41c2-b31b-e50f15088f0d@kernel.org>
Date: Mon, 3 Nov 2025 17:38:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
To: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org,
 Wei Yang <richard.weiyang@gmail.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251031162001.670503-1-ziy@nvidia.com>
 <20251031162001.670503-4-ziy@nvidia.com>
 <20251031233610.ftpqyeosb4cedwtp@master>
 <BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8931F12000E
X-Stat-Signature: 3ok818a49zaz16h6b7xkaffk5a7r331n
X-HE-Tag: 1762187942-465859
X-HE-Meta: U2FsdGVkX18fh8/pRnugvXpLfWyRQeYEeq3Al/LOHDq8GDWDOPYlucUNAuZt7hptrsikm8xHOHNpWwrusOtOxffaxyNSgID9Iz1nd5VyFCKA7XKf+SIdzW+1T2z8tjikgmrOQPlFTpjmpMxE8CdnpQO3CORzCBo7y5oVMDH7+kAVRDzhPEWpnuzkrneH9Dx/K2D8tb3nt1t7h0ZCiGbUAZnbdfVoRLqAA8kmR4ffRM7W0kt6iJGDZ58pjypahKeseylqbg5i4T4reEG78NticwOM1B9q/+s2f/mhs67bcT+cXxsmf8EBN7p7/BTtyj7693ogaxvcxR4VSb0X7XBa4HNdyIbv90r6Ryhd7LlVdciQ6/weR2qcqHjZzMk5Ie/7J1CnxbTIe62gAnULqVmzEpS9aPxoCz+DMnZa8j1VN+MCkqJwxQo2PtcKk4FUNmY4+r3+ehyWSAbXK7LKZr9z2pz9L27U+l4PiDSl7xE7zMztgRXzmhl893nWz41tgBSWvAWfjnpF87gidE1nG7ttbxImJydeXCI7dzxBN2VyWVurbQDaOUulZD0hMa217yg3yzdLqRh8quX9XZUSYAorN5H/4xOirnrI8797OkzYS3dz/YZTd1MrNG0K9Zwub4NOxfx1K36Grg0lvpAGelptucVn9C3HaNXdaZAai3sFuytyQLUCQ7LYlGLbKGWtwz4C2QrLy0TeNAieCTQWEwRl2fMKfiGwpApPUr1ru3mMO8eeE6BtoKGpsLxj76xag7aYw/oU3EMzGVm6lvWDkFrvtK238NT848tih7JdG+zdRruuLwa0emXqoyCMEBk7UrofxJe6/6Ifa1KD7hfNPBKyQ77asY65twGwKa08bHrwljHuUnRUb97IkVjG2pjD7mtiwPD5P4UKCb45QM22Oyd5wuiIBLmaQMOLhxtx7r961a+UQ1tQ73FNVkHG5WasUmyq+CbTOOYn5Sv134Zq+hh
 m+Lc0D8F
 9BQEt53S+6ApryEl7pjirYVc0z4PV0+MRegFIXTUqORXNl7H7m1//9noe5N9eCfb+RIZ0D6fU5lM19rUBLDSHYJ2FnyjzorUMHUSiDEaBRzNUXBaRHQ5kZ9VQakTzEKfMu+LQIH+n6f4X4XCtmh4ZG3R4cHRw9S7yJji6mttUpUa3K8snK50fC0WN4ccCFVXRNRcUlwglmI9TQmd706KQU+Hkap6E4DmSY+uJm2q/dqJKHyWfyu+YgLFnmifMA76jfGcGXra8A8paRlnA9jw77XyaONY3nKy0GGrnoEu0nEun1tRt+EkRmgFy04/mGgafTTif1ysNdB55wHMJw+9V1FtrHTe3GhU3jWwHvfCovVbSDGXYDLLb/VfRK6UwXLlERvyw56C35U2yKzNOXs+q+sS5DTGIaCALfpQOsS0vVpeGUkgUEHq1HDfq9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ad2fc52651a6..a30fee2001b5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3586,7 +3586,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>    *    uniform_split is true.
>    * 2. buddy allocator like (non-uniform) split: the given @folio is split into
>    *    half and one of the half (containing the given page) is split into half
> - *    until the given @page's order becomes @new_order. This is done when
> + *    until the given @folio's order becomes @new_order. This is done when
>    *    uniform_split is false.
>    *
>    * The high level flow for these two methods are:
> @@ -3595,14 +3595,14 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>    *    along with stats update.
>    * 2. non-uniform split: folio_order - @new_order calls to
>    *    __split_folio_to_order() are expected to be made in a for loop to split
> - *    the @folio to one lower order at a time. The folio containing @page is
> - *    split in each iteration. @xas is split into half in each iteration and
> + *    the @folio to one lower order at a time. The folio containing @split_at
> + *    is split in each iteration. @xas is split into half in each iteration and
>    *    can fail. A failed @xas split leaves split folios as is without merging
>    *    them back.
>    *
>    * After splitting, the caller's folio reference will be transferred to the
> - * folio containing @page. The caller needs to unlock and/or free after-split
> - * folios if necessary.
> + * folio containing @split_at. The caller needs to unlock and/or free
> + * after-split folios if necessary.
>    *
>    * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
>    * split but not to @new_order, the caller needs to check)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

