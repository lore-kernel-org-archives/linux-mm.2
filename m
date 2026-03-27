Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C45510ED664
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB886B0095; Fri, 27 Mar 2026 08:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2E16B0096; Fri, 27 Mar 2026 08:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510176B0098; Fri, 27 Mar 2026 08:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDF96B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:42:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBB871B965F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:42:33 +0000 (UTC)
X-FDA: 84591806586.23.329B021
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C834160004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:42:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgS84UX4;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774615352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYxJqnvRzuzxG7x8NM/L44QVG/0/ZaPq0h/TQQYNn58=;
	b=Xs00aTjoWlJa9fqIknnmXyeXdH3Kw/p1RniGFTS5XO8qU2QFIXPpREOxfAazNGyvv8Dj7p
	iwqZ+BPnKu6tSvezEEYte6yQBCmE6IaE4eX4TQ+Qf14duGKFusoqTqjNN9DU/NW3tCLuq8
	fYB2ypBFLrfgEDXq/pj2Yk4qnKRsu4g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgS84UX4;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774615352; a=rsa-sha256;
	cv=none;
	b=SgYmBphfID6MkoozY+bAl1oyW0BULKWc9KV9IWh6Vv9R+qKZVpFUgaUMDUzCLK/AK3xy8H
	jJW7+QNjNbn/Tj5YmiOMS6xvXaP9YtqTgGxPCDIbRwDQWuogWbCxYz4oToTpW6VOkVEdzw
	yX7fUiFYW9K+twwSYq1V7MpmNnSSD9A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D51043FFF;
	Fri, 27 Mar 2026 12:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580B1C19423;
	Fri, 27 Mar 2026 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774615351;
	bh=ScnDchtxz3nbi7fNStj38W0DlgF4uUAXNKsNM9UtlG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NgS84UX4fepMHIzVRMxlxt8c4PNx4Lya0rELlZuOIREISup3fXx7EAl/yssL53GMb
	 yJpn8LwbkGfuY9kIrhEJ5WFKEah4afqMIhdg/2OA9WdokrehMn2KzghmJQfTKF3dUc
	 2V6+fVywGgUmW2nFrij7A/0/JeHrqFABHPQLWZU6y98OppmfAKkmGajb6/zgIkc1PY
	 MroVcDBhYiaIMJDq1rOBLAZWfmTKkVg/mpiLKcri/Ob8guDAdcLLeOs0WBCARqqTup
	 cQJNiAtzEDQoz9oqFkIhcXz07ceXau3Qh6h4xDc8KUC7T4oVZAegzO1fltxzZnDIKA
	 EEoIHwWVH8GLg==
Date: Fri, 27 Mar 2026 12:42:28 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-6-ziy@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C834160004
X-Stat-Signature: 5xta7h5owffwk9xec9y8a7qksyh3eoy3
X-Rspam-User: 
X-HE-Tag: 1774615351-819066
X-HE-Meta: U2FsdGVkX19tkYS5XAhqBS/BGC+Lu48AlTnP0ZrcJkgfSYJpJdSMEWql8kLLt86OZSZWnSSxfywx5LDsBWjIaOkkdXPHWrG+e8B890v9+vXarTRf47DhJ0asZtbO4UAcK5mje0Fxf+57Vm4XZp1XjUBa9bdrD2mo7v8ITDkaLg93qYnAjw7znUzONSkh+qWcm84s3pMkrvIxdKS/SqERzDwfPGnUZLUMfuEF8RhXx146kkqRNsp9p2k+f6+5qts4wlMtkJUHGK4+bRi86OGsBZkiBfuse4Mc6UeOxl0c9w89shFO3E8vyBqfbu7QZMaDuIf+vF+LpXpYUuYjQErTvqI3Mbvs82NBGiSGu6rHYaSWYNHCPaDLT+tP6yPwzQnTwk90S/t6Bsaf3vZbGD48bWy5s+6A5XJeZQ5OYxBZTQoGjXRpX5+wsXbY9XOMj54W5sj2iOP2+uB3okNZx3s5AY849Xndy+RHmxSiYt8Fs8FEDj2z1JzhOYIjy7lg/dK5Z1sJwTdx3byvZ/B+zS+nP+QAU/L+AtYNtGOwSTQcqdDQ59Big0yNJKkOJn2kDha2+gX/l1MRd5g+E04qZ0ScT5gzOHr97qaoVGUPDQ2DPBdu6LO0nReL+FA8ojkJNt5DGCaI0sMuYazMcVUj29IsLCrUfqMAcX34V9C61FtG2qwa39kv9mW1dFl08DC04W1k0ikoT2WCjUbZI6lKooA3xo6HigT6waD5wtx5wsQvXIkgKn9Ajrsa8pbIUvz2KMUV6Tq5aXYXqrY6u6SeA+whLiu+jTkJ8hWP7unirxAYXzWly2B08J+hSHUmtALx/aW9cmZ4UaaZLHUaqMFw7UMPEBFdpPZourq6fVqVhtEQEsFMxLpVda2WuNdlTBK42B5NlBl0xGGVhuChyk449pkakqWUFUp89j2dCsEdz+WZYBXsYBhMoDRRavtctnotBNgX5ruwgYZeMlOF0YRkTq2
 vAP3pGkw
 FZG5wR72TO3FQ4Th9Kqd6RWEprjixf0ZafTEf9RFqrtE7uQUH00mjGtTVC31rE2E9j13JidJIkpncVzto1v4uHY181YlYIShiTBhOIjL57wqvpNXEZQTfetpLH4PhgEoi3LEBMgfhys73mEwdQG6aYSTH/jKBoi4OldDVK6tiOGzRXbBVYj3wCtZkOj4YDwvyMnO9M69M/SyUaNyi38gvv5tY6M/VdDQrp88f79SYrZ1Mwc6BJoyUu23Wxf+KE+tgKuT91G8K+rHF+CmPcgA7qezTMWuxP58Xs6VEeQx0tNAWX7c6+U6S0MDhj6WcmHYnNMSj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD_ORDER is supported.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c7873dbdc470..1da1467328a3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>
> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>
> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> +		return false;
> +

At this point I think this should be a separate function quite honestly and
share it with 2/10's use, and then you can put the comment in here re: anon
shmem etc.

Though that won't apply here of course as shmem_allowable_huge_orders() would
have been invoked :)

But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
unfortunate.

Buuut having said that is this right actually?

Because we have:

		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
			return orders;

Above it, and now you're enabling huge folio file systems to do non-page fault
THP and that's err... isn't that quite a big change?

So yeah probably no to this patch as is :) we should just drop
file_thp_enabled()?

>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>
> --
> 2.43.0
>

