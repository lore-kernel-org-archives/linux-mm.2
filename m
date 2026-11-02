Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B21606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tnmzTSqr
Received: by kanga.kvack.org (Postfix)
	id DA52B6B05B1; Mon,  2 Nov 2026 03:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C2D6B05B2; Mon,  2 Nov 2026 03:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3EC6B05B3; Mon,  2 Nov 2026 03:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7FEC6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:07:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5EB91C3A99
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:07:46 +0000 (UTC)
X-FDA: 85389450132.12.E96C74A
Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DC174000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:07:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tnmzTSqr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793606864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmW9W+b2NUCMbTNqn6LeM8cKiTUqHkz3gaeuB+SxxjQ=;
	b=CsotPpFdGiXlhAKd7PA+rlqCeueXF9d15yfKCewoqfCYsyQ49fKAPUVafqKWGLhGcjntaR
	stzJw4ysfCG8tfAzdcav1J6pL3nkL8fcknMsHYBdr9oRRR/k2EH+mnUI8ubZNQO5EQiwDa
	YX/69oEeyFNZpeAhQZP0Pd8LBb+VScw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tnmzTSqr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793606864;
	b=7FvUPe8wyPDZAKfLS26VMjeEsnKcO5qllIlNQ8kpnKze1u7PncepW69rIoG9JWQEs8zZaU
	Nf/7ho0CdwaOgqogn390bgqcUCISlf2kRVFzNmj6w9yFy3C3KC8W+lrpndzb0GmeTCxZCN
	WSTZvUlVeZ6K7cEDpiSS1PVo7ANa3EQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VFK7vMxbPR50n7fFLwXWLZ6ZPyv6K4TCi+2Re4RLgtA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793606862; v=1; x=1794211662;
 b=tnmzTSqrsxUQkb2Ygb/cunZg4/OUqK6lMcAvJ0bQ7Es69dTB9ZtIaSWepDAbbVg70L7cpC6f
 V1JdH5YEhU0YdyJOo/OdoN6Kk3QzYgnGNo5mWmNFybxDGnbMDNC8TevzmkvMqfTctpYJT0lpmgr
 g9XjIsaSGBn+f1SHLI0M2a+k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ab74e95e87cc3cd0;
	Mon, 02 Nov 2026 08:07:42 +0000
X-Mizu-Trace-ID: ab74e95e87cc3cd0
X-Migadu-Flow: FLOW_OUT
Message-ID: <a857f808-1988-43bf-9300-86e24a01436b@linux.dev>
Date: Mon, 2 Nov 2026 16:07:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when
 returning folios to the pool
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>, Zi Yan <ziy@nvidia.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Chris Down <chris@chrisdown.name>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-3-kaitao.cheng@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261102024910.31486-3-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7DC174000C
X-Stat-Signature: ary46mzhcp6p8dx3oq78mspg5brogk9y
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793606864-143737
X-HE-Meta: U2FsdGVkX19RiH2MufnurED65L/vynRtDU/77XtRPW+qUYQslSthDwBzvyooG4WRwfAIsUOOOdLpU8mGIPwTM7qTGyeTojeogpow7hKdjNC3EY3u8rGdlLpdLuIrWnBZtP0HMfGucbxKBYEeTrJ9R6oGwxQ/3AXFb1RBMN9muFW0PnUVzoULFGK20Quk9z+15rwKUAvABzUBjldkGgbQVPLC7ghiY6Atc8Y/6lHSRNHRsJ5SdCrKHwAZHrn9aLMoLBZ6SMS9O9j3aydc8nG4y5Rd0mT870nCmPO/L3hIseH5oROjv2MKbM7jj5m93da0LbgFiN9cBG11QOxmtLgqmtLzAC+OR1cFedNgCAck0iQifbJuBCqYrhQIF+Cc1tj8KEKa0ivR5E9xGeVEb6eFMWW3SI1Sqj7RgnL1GNgZ0oieZjWBN8/TMBZg1HyL6ts08W0oBGtxHuZWssv+hDrIKQ9tCLdHXmWZ+Vfwm/yotCY5/Vp30KaScwRGHFiJWpVSt9fLSx2HqIiGhco9rlxGf4FOmFJwUMPm78wuXOC7V5FESf4jNDYZmrOrMC7424rGtgS5+mUO/i4J9OmeAwyGojPZqIwkvybGeoLN6M65Jbp7U69AktVgwXaFcTFKmnW1gqmoB/NgEsWzdl1VspncTK9Ryy/H8v5C+zMhYxvSQlN4EVzgV6jEzYKYZcOm3LHQLU3yx+wd2E3ICM412CD/o4r3fOOCE3D9ar4KFYNtok0iMLWPuBxszZVarvNSkGeNnMyu7xzGP6xZESOhIOB9I5ckbLlAQiF9cmd/B6yvnEtBfX9zaNRGhYTnmigEFzwo4pnkGpbLzp6hF64z00eEwwMd2OQwR7HOj/dEc+jISLnQDduecVUsReQWAlWYWD18u2Y40mbixe4t94Mu61AA1b6czZMcgjcmes5MfBDSfXA/4bnVwlvxd6rwibBz+nBLYHrd+9kpJkbgbQUDaS7
 yN41iJ6K
 kFFbYgwoFvio5k5e90e4cd+xieYArCwvk8Jp7nCTDnPYmQMOUl/FptWfAcrsO+Bum7clinqCya77GsP1zjbaMqjU8mCLWXDHih8q0PPgba/FRt8WXPMxhw7ltfzCW1gzKgqjVy+SvR8+aZH4T1BZQIhRzHJ4wrX5C0S4NJdm3vfmBa45JC3zwPJzBLBI30/JOi3yiT+Z4d29XzrRPTEhlp4CoKsbCCJN6NihnGGKz97fIxmS6Nk7WSYmF+yjgdkgAst2MfOmXlA0+xWCx/7ETfqqndJWkuR4vGKKttatFR3KzP5orzA8LMoAE/cm6WZ1LTJOiUxMkiwzp3Msj8sEX55FhzTWzfPCl0uBj0xCh3qiDH3gfPoEOP91xOwYupNePd4LR/81x75Dc8a0CvGMQYUlQKaiRkgNFMvCoNxKtt4t1JuLzg2YbGlsW6b6ycqWCN+mzlZpHt3Twsio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/2/26 10:49 AM, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
> restoration fails. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing other flags that must survive the rollback.
> 
> Clearing HPG_cma causes a later free to bypass the CMA release path,
> leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
> loses the indication that the locations of poisoned subpages are unknown,
> undermining the checks that prevent freeing or unpoisoning such folios.
> 
> Preserve the existing flags instead of resetting folio->private. Callers
> already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
> returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
> before attempting to free a temporary folio, so a failed vmemmap restore
> does not leave that flag set on a folio returned as surplus.
> 
> Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
> HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
> incomplete transient flag cleanup.
> 
> Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
> Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>   mm/hugetlb.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

