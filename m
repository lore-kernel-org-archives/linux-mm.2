Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2BBFD706B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A49D6B0005; Tue, 17 Mar 2026 06:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BD16B0088; Tue, 17 Mar 2026 06:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAB56B0089; Tue, 17 Mar 2026 06:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBB2C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:35:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86C89BA47B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:35:20 +0000 (UTC)
X-FDA: 84555198000.25.27F9040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D18B918000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:35:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=he5PaZ07;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773743719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ib3ejZ/DBts+2W2EXSquPNMgv2MwnyJTBW1XTHXW5Ts=;
	b=fc+haihqOudfpq7svdZj6JVNTsgQd4g3CvHTHz6wQdNHyugP85F5/63lXWydF1X1PORnEb
	4gljyNrv/OrxoKNUxJl06qfPp9RxYtRwb5nlorHc+VJkVxfO5K9THBsua5rvHO6+qIDB79
	4jizpu9OhtTkuMSIjFn3CV2VCHDz+xo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=he5PaZ07;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773743719; a=rsa-sha256;
	cv=none;
	b=x/tdbuXxrUpMN5BCxKJ6kiPb2OWQRbva9qlJTn1jTh3JUEt2AB9VkLqhxCAa+nDifipDd1
	hA0kF+92dNcJsFeKBZREe5sAA+fYl5ZFbm3J6sRcn39yV5Qds50APbJzYE1K2JI5jzGR3R
	dP1UNblUS6Xh4nvIkh5PaPaeR7ihtCI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2FB5442BC;
	Tue, 17 Mar 2026 10:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7E2C4CEF7;
	Tue, 17 Mar 2026 10:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773743717;
	bh=4/IkLFplsBX9CDR3n4uqSrG68fmITpAJIJjqY1jWYAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=he5PaZ07HRCwRWE/JnlN46TWcmHXX4ILtqREpatB3T4GYFmyb7xNp7uPoULGSnk7W
	 z+fvFm1bnGQkyNDFrcRVg4l00WSKcs2EZyY075PDyHOrmpoNBMriA+32okeiO4lH7E
	 DQaVTDevzhguejSzg664RGljnqCE2TdEBfYszjvJ9SOLTXH/H8qLyX6ID+fR+tNCVv
	 XdUrAOuH1OmleoJiDJ/uWUqkXggoQbYZpi74O6pH0I/7hA1AfPaiU7SAMzl2QtqP0y
	 i7f49BVjIjsWNt4CyMu0B68gahsDbMbCg8fDK0H0Mht097ntEIBIajMAInC8B+aua7
	 trm99hxAtZoKQ==
Date: Tue, 17 Mar 2026 10:35:15 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
Message-ID: <d8028d32-4791-4993-aae3-66506bf6d1bd@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032631.234234-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226032631.234234-1-npache@redhat.com>
X-Stat-Signature: a11yqpoodz1fejfnats3zfikf3f59jdt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D18B918000E
X-HE-Tag: 1773743718-709248
X-HE-Meta: U2FsdGVkX1+5GrdZNPZjySEo5Yq6FMyM56vgs19iee3QL+7zImPW1s8qOS3ECZctrlrfTVmvZfEFYHlBPYHdQp7edS45QlnxQrB1c2q/WOZok9gsbMUE7mFIKnvOfG/XYX5i/d2denJtGpT82QnVROW2HseYtcYh7LDjn1m8VLunNZrPicHgllgTsfbMYn0RkGCz9wlM917RlvPO7bpjnW/EFRI/cjAONGgtOd0FB0zRbNCXd3K3X9T7zLqIw/aiUf8Kdja08CwyqQPd8FctBrBCT9+iGtlfsQ/WngblGumFBPC69AxYtUE1n8S5pGHR+CNBj2ps4ZyTAg9Nlu6gFX0zSPbKpwSqXRvmFsiLbz6qYVpnwLaKCdZK5MSNhs0ikWihFjFRHk721X7f4WF+xAmU7ldguwmYeva1u3CQl97OsgK2y6GXshJEVH0KIWFwtFKMsUtNArf7bGh7jQIHSTnvrPmE8oPWa57O6TaCfCbmKHpq2dpMVf60hMpJRGKuY6m83bQ0Lh+I7Q2G0Rjjs/qm41g0sd2QGGZGLGfg1ZlG/iMd2h6Gm50P22GBX1ENzBuYY+3gLMfrTeRSoarCPosU5H8DGycOMgu5IFUl8FgAPHUK3xzKmFtBP+vHIDngk9pqCXMj9vCLgUMQtqQcMxm0cJINghYU58XW0kvw6UhDSde4/s22mjRuX1ca1wJukbsq26/JlFSrreYO7Aj4S1PSI/L6WlYw85iVJpQ32nRdn0H87uKLm+QtrKttDc7Pe2mGHfy6W2DMaTMvSd65bCoZdZBEXymnbosnIETZzdc2b2PfImDazIEtaiBy/eZM286QZ+zpEmekgzErXP5kNho5SQv+g7ZoJiYJfZ+BIE1XfmcQz6uaCIqJF0FCUn0SOu3lPHPGVGEkPmxUHMZ2SmeAqYv8c5XCDChzxTW9yXZ69rzVoqj2fgh2jSqIeVj0q2YJAl+8BMtc0qjqW52
 7YIOW4mk
 H8vDpy1L5O1wSGPN8206hw+e0SDhQow6vSpxRoXr54ctMUCKa31UdIaxB5Oqki3zg2dcQilILxnTPPgjkDXbO0MHYkNcZx61V9xyOItUuY+ievoppEuSdCOMdpE8mLlXije62sNlmpeprOfvVmLfbk2H2jJvRMhn+te8gnyUkM+8agigVkNOKai6P9vcTWol4vPMp1g2UOD1pJghYnacEAUKYw7O6EalMALq9KoqEIbiPcnoaGWtrXZ1qJDaGiNv1Ykn9jpJr6/rSxrxByVxs313spmSHIjf4v6RmmPAIa9u58nGdWrl+DqlkDXcHjhAUgAWSpBQ/ogZqah8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:26:31PM -0700, Nico Pache wrote:
> There are cases where, if an attempted collapse fails, all subsequent
> orders are guaranteed to also fail. Avoid these collapse attempts by
> bailing out early.
>
> Signed-off-by: Nico Pache <npache@redhat.com>

With David's concern addressed:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1c3711ed4513..388d3f2537e2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>  			ret = collapse_huge_page(mm, collapse_address, referenced,
>  						 unmapped, cc, mmap_locked,
>  						 order);
> -			if (ret == SCAN_SUCCEED) {
> +
> +			switch (ret) {
> +			/* Cases were we continue to next collapse candidate */
> +			case SCAN_SUCCEED:
>  				collapsed += nr_pte_entries;
> +				fallthrough;
> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>  				continue;
> +			/* Cases were lower orders might still succeed */
> +			case SCAN_LACK_REFERENCED_PAGE:
> +			case SCAN_EXCEED_NONE_PTE:
> +			case SCAN_EXCEED_SWAP_PTE:
> +			case SCAN_EXCEED_SHARED_PTE:
> +			case SCAN_PAGE_LOCK:
> +			case SCAN_PAGE_COUNT:
> +			case SCAN_PAGE_LRU:
> +			case SCAN_PAGE_NULL:
> +			case SCAN_DEL_PAGE_LRU:
> +			case SCAN_PTE_NON_PRESENT:
> +			case SCAN_PTE_UFFD_WP:
> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> +				goto next_order;
> +			/* Cases were no further collapse is possible */
> +			case SCAN_CGROUP_CHARGE_FAIL:
> +			case SCAN_COPY_MC:
> +			case SCAN_ADDRESS_RANGE:
> +			case SCAN_NO_PTE_TABLE:
> +			case SCAN_ANY_PROCESS:
> +			case SCAN_VMA_NULL:
> +			case SCAN_VMA_CHECK:
> +			case SCAN_SCAN_ABORT:
> +			case SCAN_PAGE_ANON:
> +			case SCAN_PMD_MAPPED:
> +			case SCAN_FAIL:
> +			default:

Agree with david, let's spell them out please :)

> +				return collapsed;
>  			}
>  		}
>
> --
> 2.53.0
>

