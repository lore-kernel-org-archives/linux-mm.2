Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C93606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OaoXci3l
Received: by kanga.kvack.org (Postfix)
	id E4FF66B0682; Thu, 19 Nov 2026 14:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26B56B06D8; Thu, 19 Nov 2026 14:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEE76B06D9; Thu, 19 Nov 2026 14:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAEFB6B0682
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:44:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04D491208BA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:55 +0000 (UTC)
X-FDA: 85452896592.20.1B4DE39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7304918000F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117478;
	b=IsMe+qZJv0SrM6/a0tyKCC5wWt00XD7CZBB2Qq1GVaQzMdV3xkXaVK+hTPcAPYwZJaSsIL
	VSfVoBS0FRZDcVbUWOy7hATJVJg6G8Yznyb27bT+5SEXsKr81J4C1z153BoyDS0eiLuWkY
	I6lLc0WM4bX/9xXfBgCNYzkJkCPrvFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKyrivJzo+Mben9cmzx8JhnXyAay12IuEg5j9gR3E6E=;
	b=gWHS4ehnZmq4gwcnhZmPy0oxHUWfYaYdMTV5ne/qHnh9XzEOoXYbiI8h9aI9RoPXDeCoIf
	nJfLbuThscolItqMAFCT89UfH6HtYZ7PS4RWKTD679zoEnFORNmxwqhgVz3sOdtDkUaFbP
	GSb03SeF+L5xWStq0gyHMgs4Mr+GSao=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaoXci3l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC13044199
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3CD1F000C7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117477;
	bh=YKyrivJzo+Mben9cmzx8JhnXyAay12IuEg5j9gR3E6E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OaoXci3lHVzfeCba3lln8uF7Qn9l96givMQbGbGKWNk7T3kABm78qlP4MdS4F2Fqu
	 /Y4lzfYPSQbPYX8HLaFPQqkRqRinSsLy7Vpz45XPcYOzATFoPJpOHNHjfGpSDDYrjj
	 TffPUltbSp9ZowtNe2jRuvCW2Qz4JzGn+hjouog7Cs7/mbtsW70Jxv9+lU57+sQkzd
	 CZ46yF4bryVojOPkVGe4AUHNOQlOW3G6NZ+jU3PO+JE90rMbrSU1GNBfzixhvtYMey
	 mfzINn1iW9Q9zHeH7kun39HuPeDfujI6kZnHIzb3UjSnlox3D4jA+qKJJQt7/nWmzG
	 KSVcUcLVqnyGw==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9497a167a6aso159278185a.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:44:37 -0800 (PST)
X-Gm-Message-State: APuU4Z+AqWjbxcrPDk+egTs93+p1FM/ZzMQrBt7Hkrk+IZEio1RgU/X/
	e5Zkm37TEQ0Ys+UDazVMZa2hzemx/Tzy2fn2Ww8jtooNBCwKsizkAhkXMCJXvfo6OUGWb2MR4pH
	Qbht+pdtfs6H40JbM4JN/1HsxmTlqgDA=
X-Received: by 2002:a05:620a:261d:b0:93e:c12d:4ec7 with SMTP id
 af79cd13be357-949b3841debmr323824085a.39.1795117477060; Thu, 19 Nov 2026
 11:44:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 20 Nov 2026 03:44:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xXdPsnHFX6SUff_1vbsEmGCHdZcXAmOumiN8EMar+KAA@mail.gmail.com>
X-Gm-Features: AclHuK_KKF5P4wFEq4Ot8gOVbDoJlPrF_Qs2r1floMy82S2ahYTVnc8-alAnTWA
Message-ID: <CAGsJ_4xXdPsnHFX6SUff_1vbsEmGCHdZcXAmOumiN8EMar+KAA@mail.gmail.com>
Subject: Re: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1795117478-747736
X-HE-Meta: U2FsdGVkX1/Jc7U2tzZlVJ9O3fqf2qlCIrSDKNRqOy7eszbgxTMLcjewxYk+VDeO1vIU3oSLA+qpRy6flGM5XBAUMTcxHelEbdRRz/lbFWLx8oznUiVmcDXgHOHcI8ruWJcrtbMw4sHocq3gQ2SARc8TTXy3iJFeglxHwYSIsE+/nAy+iTxt2zNMggf6//kLCLZgYEgJzW61lOkGzA50bPinYyusxRx+cZze9VyeguojrQLPP+2QxQAetP5hQxCRGhcGSRD6/NTdijCU8BwfxExRsDafvglfQn7P5BQ/1mn+GpMUlAXNyRkD3fNQ+af8wlxf83Pr0eKBqAf/BcSuwQhBNAwNcR5nlqivol4MW9iWS5h2jOXkKR8fu7w78RG+/6UoFl0M31WRKKkwBdanPi99gaBsp6vmDOHDfglFHf7V+MqgTehSbs5Yb75UKgMC4DUz2Mxr1SmXy/prNbac5IWeGzY10tWQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 26 +++++++++++++-------------
>  mm/vmscan.h               |  2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)

