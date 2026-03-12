Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC86A106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332436B0088; Thu, 12 Mar 2026 17:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC836B0089; Thu, 12 Mar 2026 17:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E456B0092; Thu, 12 Mar 2026 17:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 064676B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:00:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7BD458ACE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:00:44 +0000 (UTC)
X-FDA: 84538630008.24.3257460
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D651420002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:00:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bw/JPR9u";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773349242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UewpNMGtmwOQLHuilKMwaS5zEA/i7Y3qxct5DrFinMA=;
	b=USEWnDp/8R6S8AEhaM/luu8Fiyt5XyuIAFCVH5NVHPmRr0sYZgnsmcna/ihjZjbD+X2kgQ
	1FVtVXzUTRTpLZIAtmx7IBBFwElpey5ncOL+Dx0AWGX6seMc7TQjqd4QkPosGXGyhZumRc
	Y8BKeay1NnItvErW0NQ/hVVzwTsQO4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bw/JPR9u";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773349242; a=rsa-sha256;
	cv=none;
	b=vBhwE3IMcmf0hOdS5Bg77mGVGrFn+XNiqgr6Lqc3TbA7LfmKgLC2b7YLT2UkbPuOT06rvH
	MOLpOW+AGTfE5PYAzVCMuEGHcH7YTYKEoBEbarNwEnEAuPRBmE4KfIX4MgSv2C6faeqywn
	0L1PrhU7a8L0GUYKYX4VKGx/xpgmQ5M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25E1561334;
	Thu, 12 Mar 2026 21:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5BEC4CEF7;
	Thu, 12 Mar 2026 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349241;
	bh=t9qyAMUJYtt/iJt7vCWYgq7XtCHiecN6JSg3RByJFk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bw/JPR9uqN4l5Dxlb2N4tR3WTfviG/7xqecf/Jyr6pGYfeyUdqczyUH71g7LwG6Ib
	 N4qV5KNb3VSbfVKOvCmvTaOAD0oGwPgmlJSDzrMeDJMuxCVoe9ALODHzXeNzDVs2IB
	 04m3EHp7gP16jBblhaVF2TafrDDLGu+shiq+7YWx0s+uDbEsyuwb36zIBqOWihC+AH
	 M5bNkg81zo2yrAJoP68uAaUfpSPye9ZUoaGcEKujr4hrEdSwkV4tBWuiBcVu/9VGUc
	 tfvLISkyYzaPHxrFKc8nT3WEtxqO+2DqxvxkQwYImDkT8Z/7drl2BVajvs0swnk3Cf
	 EgSTQoM/Sbp/g==
Message-ID: <94290ad5-f63d-4fa7-a898-dcfe6cd9998b@kernel.org>
Date: Thu, 12 Mar 2026 22:00:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 06/13] mm/khugepaged: skip collapsing mTHP
 to smaller orders
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032445.233437-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032445.233437-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k9tesgnghgu8e3qt5e71a1iufmmo6wzk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D651420002
X-HE-Tag: 1773349242-338273
X-HE-Meta: U2FsdGVkX1+gYxH9/XNE+raCZRjMohITR+Nn1X8XdeSj3dA5XjcGCFPVtCnG7J8dcLG+FTaLRQgI5oxt1oWp8Id+L99d+ly/Y32iNw83WZAE54xu6yzPidzmyE7XxHpSSNIrPMmGHaCuiR9gy8BbGqAuNUTUW8sBlPes93uw4aYbKT1GI05SBflLl43cSYFtTFbpQs3CLmkrYLvpfm2ooppNR4TMPAfQ+fy+RluRLJo0arsrRSclyKbIWdsgn/7tFij/UvcXqhzOM1uC+OlTnHFA+IjetqRHqT+nNkkU3ud4c8KxgUBoSJqDEW5lU7ms1LEzYS+r/aSJ4q/1U8X47v/y/NaBhXnjFmJJtmMk0Os2Prw2k0k34s5q4+gUA1KLi5EiJL9x4AW4cGU+S4pXAQeiLM8WmdT7RySU9xCRISZmcZIWToUJ/0ggF/nxub1bZwgGLiR/Mb5PSVBHKVpx83prRLn597BuCztE/LPm2H4aHPpyWupv50hV2lc2FqzxQYdMY9SbG0h2PbZeiLqWmn6vU/sh5LUBCfzaL1Zv5dCMIHBCnU6J+NiwTkOA4VdYmVJGy76fS4ON/Cxu3psqSRfgc58nE6dm9Bs8jHw3oCvywdktYSIf0bcXTKlTft9yTKNVbxrMQT2e7sxSe5S7AxLgVdQxP4YH6MSE3nEvXVcTyUJwa52zDtwpn9c/pACjPw+NM/JfGcaaTMm3CgER8jYmLgDLT+4/3ktFYQ35++ljGFr5TObaasrBhT/TJUS8CQXhJcMjYihgbN7GJoW17oVwigzFgnQKYwdg5CP1vV8FqoDwGbSoIexiZYjQSdldsH7Q92UZtn2YPU2r+SWjknZ3zrlKhdSFWoOSjCHvrkrw98kpaK/oQKCkBM86vg2nX0pXxHlaeuGJN4n5/yNdL4ToXrFk286gv0MTNDMxTtKs4XZXPI/K9lCuDpm9UsjxRUwdkh664IE5Oo9Wki2
 /Dk6nwsK
 qtOgPaVL7hM/2PpYdZgCVm91oEGkPYoGj9NDPUMKpFW11W3wVPlX2gbxdCRLjDS/jgO9nM+AEHJeU4HREM7vcQc8F9QlJuav4G6BTgnvd6db/Nh9MYZToqnq65gozsmls5qyFQXpyxqyeU1H7HTLuyLh0vFDA3fjRuk4KHYj04Ymyt1uAo/cB9c6VFhawpFgcjhJr+p73Uh9Mrt4y5WG5y/vXKsNeQx5Tw8t7NeO1NxR15c34SOsujy2kK7nE4pgS8q/9fDRcnsCpGX2nTgTwRW4UMJxLpDHhNlCVnCHFSZJrrDlKX2KbLOUyRonVWSh4QPcDlqz6HcsquzMfpHdqMKDtk5KTpX8jQLVhyug7Yr8adY4/aFh6fihLQWpM9nfxEHFw3Md9floY4eP9KvnRE3x4si/wxHviyC93s7UzzgKdyqfk1Jk+1VcaJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:24, Nico Pache wrote:
> khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
> some pages being unmapped. Skip these cases until we have a way to check
> if its ok to collapse to a smaller mTHP size (like in the case of a
> partially mapped folio).
> 
> This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].
> 
> [1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fb3ba8fe5a6c..c739f26dd61e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -638,6 +638,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  				goto out;
>  			}
>  		}
> +		/*
> +		 * TODO: In some cases of partially-mapped folios, we'd actually
> +		 * want to collapse.
> +		 */
> +		if (!is_pmd_order(order) && folio_order(folio) >= order) {
> +			result = SCAN_PTE_MAPPED_HUGEPAGE;
> +			goto out;
> +		}
>  
>  		if (folio_test_large(folio)) {
>  			struct folio *f;

Why aren't we doing the same in hpage_collapse_scan_pmd() ?

-- 
Cheers,

David

