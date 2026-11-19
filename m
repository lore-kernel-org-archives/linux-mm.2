Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6766160A2611
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCAiOHRv
Received: by kanga.kvack.org (Postfix)
	id 872FA6B05B7; Thu, 19 Nov 2026 11:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AAF6B0699; Thu, 19 Nov 2026 11:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75FD06B05C9; Thu, 19 Nov 2026 11:45:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A74F6B06B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:45:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E593D140A66
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:45:49 +0000 (UTC)
X-FDA: 85452445218.10.5641636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BA5414000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:45:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCAiOHRv;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795106748;
	b=Y3dl6TjfxZWOrovsDIj6msDJnid8a4tJbjuMB+u1lLpoWjtCjIMwXlsAfpiJx/l2hKFBWw
	U0fSDSkCjRNv8Yg5Nw4ncUB7ZNuL0UJZy+aTIZNpoyCpABUTqP5fYxUL7cwz7mBcYNeiRy
	eevSRz9LbnW1+ft35Q/OaZtC+3xQrlk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795106748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZlGQuCX7qTKr4D2OG4zoMh6nRgfrVAsN0lt/KJAFf0=;
	b=IAgsWelqnJhFCD2hgxGuZH9hIZ0wWe6TuwV+NHxjnI7GATEwyHVH5i/HwxydDejSrjqcJ9
	IUfEZsinvb+GKFvTl5Ms3XeShOcw7AGXGmYJafSMtvgjrLL+nfWSe8kFNqNYv+fkyLUz4P
	OTtxKz4LJ6mO67mRvPLI+/0n0fUHikQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCAiOHRv;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB20262FD2;
	Thu, 19 Nov 2026 16:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B83E1F000C5;
	Thu, 19 Nov 2026 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795106747;
	bh=gZlGQuCX7qTKr4D2OG4zoMh6nRgfrVAsN0lt/KJAFf0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GCAiOHRvbgv3EYZiKjEnuFXPB1GLTlBbdCeR6du21xUp3FTJ//T3/k7eO25oh2wHd
	 vMaegGC1QAJnk03tu4gRu3JHade3myeZ6QyTUdLRql3D7Jl3E3Uku/HjI60+wqMIPJ
	 zcWGOE1E4vVRkmFBBiW3yu66wLE4VXU9vkdkToI47ER8mXOptjTnogjmrUdCjWXyhC
	 o4I2kd3FpbKyWlukmU+IiXO457vWi6ji5b3gJ1iTkfWAw3zbx35ti+ydL3DHnwcM8K
	 u5CqY3KAvamjo8NwVXZXTAzIGNwt/GLttV5VSoryR/8cwFCZG7LCE2TLYQM2BfdPBi
	 BVOKChem1XxUg==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Usama Arif <usama.arif@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
References: <20261119134236.3745231-1-kas@kernel.org>
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
Message-Id: <179510674270.3156.17546947206038231492.b4-ty@b4>
Date: Thu, 19 Nov 2026 17:45:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 3BA5414000B
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hjcbzurpy5tumqmisb4umq4pnbnpb58b
X-Rspamd-Server: rspam10
X-HE-Tag: 1795106748-493476
X-HE-Meta: U2FsdGVkX1/r1IaUDyiU4tJ2UrphOs4rH3+NNliFh6ild8TKmKzwCuj/olkaaOyYLBrB9vfBwjozg42PHSLRopVLNcxj/fR1a1B6e33ol86bcoH2vJbplzL20zZti2+X09yhmj7Ff1LTJG1s1pmPbn1SbSYqildziWpiB3/n2BTViB11hYXhMPCiWSSlWOhrx2vjm9yz63cnq9Q+JmrF95XYhEJZZIB9hBz44Y6/9EBJfGLKeG0F+fQVmoC+NSejEdixcNQaiaIou/j1MD1cOYxqwHKkHvsg/PcKvWsGgLPcMQtRHDlzDtoEOBzGyNp+qaYlo/ztunjJZFW+tDHtU7phLp7oEzsatBLHOuh9zhrLc9OYyHu0JcTIoSW1gInDNChqeifWCkHb1dRs0VWwAjItK7BlWPTAsl2YKT5LQjPDvf7Y6XTeZpkSBHolZvRCE+Q3l00hdAyoR5usu/mkJenOkgdfwVfX0n6pycOlApz8kVyFkErXBLtn0orSLcvVjTdwHygjH0cjW7XJdxnqHdSRVg8yUNvo7h3mPzTRihBpVmvNG0C0yRI9MzgLLtpzfxaDsriQ/fpRuBqaQT6A7mNN2VPmu34r37Tkjk7v844FaqWjIOKKJrtK3+AGwZs64kxHjw/HUMC55duDc3QOpy4wxOFHEWRV5Sm9MhAKkf7DffDdhHYHEnwv9Ku3HhXTPs9p1TkcHjoIdVTIh6X8MlEel4n45ENLyxXqNnt11nNZYdxzSNLwou3MhXtE4SXY1moI35JF5aCTnD8N8AqyDBEPAlRi3y+LEBB9icU04sdVyX/SFym/Zlixsej16YJveavOnO7R7/Kmg7W3GTmlFUmUSo7fVtM/ylu1dSaWCUi7y7P7dKNcsqp0k8zcO1ME5ZqkWajq4fK3eZhP24MdJhQidV5am1PL7EAcGUUVOEopw0TsY4RmeAiM30U8rljH5kzs/mo2KYfDCKUPiKX
 q4Gs6rOD
 gyNQcfwJ7JVKl/my1lxyzBwk727HHS1toB7LFgMsxHmPV1B/kLWW09ApHLyX8yz1Irv+9cwRWj0Se0wO4C16FpGF5VBxCVc0iPz0B7rLBcy+eqy7tVyYsqCz2LyIQO+BfyBmW7qIoO58YjazHM8SrYPseU7ah3ZTXqxX4yV307V9xH4kmKj4H26w5J7Syv5WUiRkMiblfTeHgtSSQgISrZ8070KH1/156P+kcy+Xin3Ja5dUezwPxMafGiDJnso4pX0WHtaXfxNtW0MrkjMY0pf8WRdHxkahO6wHiab6xzhvWy/29onJ580XwhLETyF1CILlFLl55KefQBHH+q0/3xWl1KfpHdsIxY5WgNIfk8I3PmnWTVyJWeb+fXifInPxkX9vJPNinnc8wmlZTYydYEbHPKbAPHODlkvIRvEwEyal/WEpMNt4NYH0bxq00Q9uhUUFijIeIJpOmtAi+xWNOCvAZ3kqM2QyTUlcQHtKWpIf60CSi3k6pUwEiV/PAQqCfRHRVrQxgd9t50ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 13:42:31 +0000, Kiryl Shutsemau (Meta) wrote:
> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
> 
>     do_shared_fault()
>       __do_fault()
>         PageHWPoison(vmf->page)
>           // the faulting page only
>       finish_fault()
>         do_set_pmd()
>           // backs off on has_hwpoisoned
>         set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>           // maps the poisoned page as well
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory: don't map hardware-poisoned pages in finish_fault()
      https://git.kernel.org/mm/core/c/2c536883

-- 
Cheers,

David


