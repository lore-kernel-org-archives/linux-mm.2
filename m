Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA278606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 08:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F9oz3JPD
Received: by kanga.kvack.org (Postfix)
	id 0B2216B00EF; Sat, 31 Oct 2026 04:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B156B05B1; Sat, 31 Oct 2026 04:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC716B05B2; Sat, 31 Oct 2026 04:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9ECE6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:36:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A8651606B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:36:36 +0000 (UTC)
X-FDA: 85382265192.04.D02D8FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3450A0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:36:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F9oz3JPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793435794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbspxFRuG1ePr26isPz4p8MVA1RRVBu6YGTJfFDFJ5g=;
	b=baur4UsM9mEEG8tVv98dDxDt9HRd2qHs6yR+epTUtn+wYHiuv9NYZl/NnMpF6WVNwImutq
	0vU1Hb2+VKTm03nybmPaW6HCzuB6K8g/POPkY7O206NSjqm3mZmO6SNEIoOdpc4BeqbKwR
	atu8tXGXtsKVxOuGUqAVso2m+jTdo0E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F9oz3JPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793435794;
	b=OYoQb0V/TPAlYiUQEPlzz2nfcdG8YK5lTSsnCDNpFiA9EzCtUui8IxxdSlYoY5OdIws2vg
	ipMwY2AQ2Fy9/Vik/LG1/Dh771t7P55LxujbyPdsOVXf7NNiE3HGloUAZFSm+g8Wkn53N5
	+IsRBx+U6aFHsmuS8nHt1IrEdoGX9VE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17DD5600C8;
	Sat, 31 Oct 2026 08:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540411F000C1;
	Sat, 31 Oct 2026 08:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793435793;
	bh=lbspxFRuG1ePr26isPz4p8MVA1RRVBu6YGTJfFDFJ5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F9oz3JPD7vvav88u5xwG7vZiDr3PnHUFI8fOXgW/Qd1UYCWIDNQvtcH5wnrMUl2nD
	 LgnwKJhtkTJxWu8MetMbGDOY5Wy8qJIMQGTWBTUBKLmhz82MjiDIW6kgydZsv/YG/9
	 TdkD1iMlnd4yW2qLxJzDaxj+UF9VRWE4rmUbZBX9EYi3r4TLX+Pe+yYs/90o4NSpBU
	 lz/SF1rDjLZA1FWqQjdpR9CT5O8yO71D9uNO53N2BrYXkBUomlv19t1Ufrq8uPcUSJ
	 Vh+9Nf0M9OI8tToK00G4syxyBAXlNe3QT8l3MMhOnXGekqpai2BlvkmNkpc6pvGPBG
	 MwMQnO5Fjn14A==
Date: Sat, 31 Oct 2026 08:36:18 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
Message-ID: <auWn9O8Ryx6-yCXY@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3450A0004
X-Stat-Signature: bqfqggcfdq5y6dhkqsaoaemj1tocrka5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793435794-904140
X-HE-Meta: U2FsdGVkX19XHfI0Ej8JLb2y73nVIcdkB9QDTpjeGPk+7G47kUTRe5kKRgIK/Ixp9uMRc4QGx4oZgkmPRiBQEGyV+932tBzK1/lARbDvY+KPH4EuiWKpyX8mTDO/adW0Au8TBgTY3/in0KAOYd5HFn7esJM1PBuuOchXE7WJyePjhC9xMxiST4CSHmw4Aas6p1/hB6YbaaC8MIUr4kMJL6ASMazq8u7FihnOX5N74TjLfwSzi+rH7i77uhqXDQixFbJnXAanEZzNd+Nx+RIRaJUrPAwtSEecfzGYZ8XrJtspPPao934jKbZwJuGcCrtLH+o3FTOfrrETNVNjgnM3YeI54HBtJ3Y89VLZMlltfdCIvDDWiBmjTcIUm+6FwEOfknhNmetadk7GEgrCATt2fcTrpi8pF6nHG/I0NnZgPYg1wBlKf3+bhYBXMx+bRcT6V1QiA2BtLC5zWvAShSKo/x7oTJHRhURWc3Nu7KmXU4aKfjbPQXpFv1A+rvVO2ZikDV5IzqlmXmcGr36uIyxMiyUkRjEx0ZeQoGGQmGLl00mx7LDG30MPx/vq++XF9kRjp4r0MOQ2iVF2ivxwWkPMGLrA6Zz76Qx3mlLMtAMYdZpCIPLyXTKbKhXLgmnUdD3IqLslKnW/qzyEdya1I8kZuKy1lcW7UQ6o2REJ78TsFH14yM3c+eIw/G64iptK2wJp87IIcZ5EBOkV9NgMW4mlivakIBYfjLGdX0arjQd/eF0Ui8jidgRrfKsVFqQuyWZ3HL8hb/8pKZ6WlrIxcsyD3v2vg5VlX9IByEayRTO7BBTOgTBATkWwsa2VMIQSnQz5R/uoYwiIQhuLKrU6au7UnsmP0jnaKaP3bh2nB7rENoCcWoXM5ASoV+sFgec0VPCuAwX6/LuqWQDkRhKks7TyOLUE0ej+56LhR8bCs/LFqWCcmeqJmR7efDXKK2eIzM4DhdOCvU+cy48NHD3Wafi
 Yf/3m3R9
 IYLn8ISGAmFBGKAKEBfpvhNeKdvBZagerM5AaU6FyaeTT2oaecLIKmCiqzSS9ZWYMMxMRJvMzgXu5PyYbFd/Tcgqkrr9j10fsEAoo+1xTN4ClFrVKvr17zsWCGl9TYQjLDS1lVKmXc+RTbU5czLeUzIkhc+WLWNBW9J6NIJsmosTjtMG0rF06CF0FKJIlgBRNp7Ob1/SDMmOiALCORlt+n02J8/VSNiE0LQyrtpS9OQRpkIMfWzjdgR9CcQgK/F643iKoo3VVpjmM8LnX64geXsOjw8fItCjn0mqFKtSa5TsvrsCVb0jUp7oF8rkSJHUkl/RJ6SgAtdEr/HZcwa2LMUWpdki7S/eKlhz12F28u4pKeHygQjLCepFglEBnaPJAWkXSrkXUP/yplSqSd63T3a7W9K1az+UlUXJ9jtn6Wh9PcGmnPBUc32cj47RPgDx424RFMlgwbN+m3nm8nXzraVjggJCyJWrtydrivjLb7B7/3FwHusqptbayFxu9ikxQhc2JOsIhE5d4rnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:27PM +0100, David Hildenbrand (Arm) wrote:
> Zi has been contributing to THP consistently and reliably over many
> years and is considered one of our most valuable THP experts. As THP is
> an especially active area lately, having a single dedicated THP maintainer
> is not sustainable.
>
> Fortunately, Zi volunteered to take on more responsibility by stepping
> up as a THP co-maintainer. So let's do exactly that.
>
> His placement in the MAINTAINERS entry is very convenient to perform
> this change :)
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Amazing, congratulations Zi! :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0baeb37b0dcdc..02b5b542f81ee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17817,7 +17817,7 @@ F:	mm/swapfile.c
>  MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> -R:	Zi Yan <ziy@nvidia.com>
> +M:	Zi Yan <ziy@nvidia.com>
>  R:	Baolin Wang <baolin.wang@linux.alibaba.com>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Nico Pache <nico.pache@linux.dev>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

