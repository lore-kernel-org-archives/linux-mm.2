Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB96606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UH7EORvq
Received: by kanga.kvack.org (Postfix)
	id 0B4936B05B2; Mon,  2 Nov 2026 06:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065116B05B3; Mon,  2 Nov 2026 06:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71BA6B05B4; Mon,  2 Nov 2026 06:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2B1E6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:21:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56CF21C4705
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:17 +0000 (UTC)
X-FDA: 85389937794.10.EAE8440
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B51A80003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UH7EORvq;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618475;
	b=77oKvX3+LeeMjl0tVJrUp8+gJImR61InScSSOhf0FT9ux6jZg17KmlD3zAyOjMvVoL5IYq
	lxBZTEoUGjZaPTcu0edbObo4gDUwlGav3ahIvIns+ShGZCo6HivQp1Uc3uUU9HoENnomeO
	DcPQqyhUiagN/6pKv3bklXs2REJfb2c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UH7EORvq;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XdYGCj3UpBi0eF4iOsSacA/lFpYw0ENrrwVG8qRYI8=;
	b=GBO+4hIBvSWMVke/ixKqJ2CroSNY/s4xV1rND7qh99BmTXXL8lXEvAo/LtOwqtyLwtxcdV
	65KnnUCRpezAj9K/wNKNpwlKWKsjN7SfCVFH87LK8cx/VMiWzj9nsXdNnxuurTrR3pj/Qn
	LABKwowhTaz/qrKf6PgWmhJGsfR2PUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0D7B60F43;
	Mon,  2 Nov 2026 11:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C311F00A17;
	Mon,  2 Nov 2026 11:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793618474;
	bh=5XdYGCj3UpBi0eF4iOsSacA/lFpYw0ENrrwVG8qRYI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UH7EORvqI2yKBl0tVn0dePSsG/1YiHU5g+s0x3uhN8QRhT+CSHq9nOXfW6YBLop0+
	 cDThCLLuLkDUBGLua14aMdqbHNMwC644o/Uk5dK/0dZucKf+snOt4GG5xAHoaCX3uE
	 I/PYLnnwD84radtQKjxZEqf72bv1IZrJ838rRU38CsxFsmfIg5uKKjTamxV+zSkfWk
	 9a7qVOxHd2Ivsc/FNcg1DNK7zsVjoAnjNBt6SI4UCYNUbhk/ZkFF/yfEl/Gd72F7+W
	 vZ5zJZnN1hs2wEeAa7bAIiCBWTh+TblVAdBvnXpBqY3y3KYoY2DHU37fAwTh7Vqwyt
	 LjuhFqh2xHuZQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 91890198003A;
	Mon,  2 Nov 2026 06:21:00 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 02 Nov 2026 06:21:10 -0500
X-ME-Sender: <xms:HHLoal0crmk0arFV6SunM3X_4EGXRFfULYuHVpBz5HyNlRdEBJ-bEQ>
    <xme:HHLoak61HHREnly0wGrcd3mMK9kM2f7bo2cqjvGbSL-JLCB4ASgdasYNcxTEVdelT
    L44y2DqjCXE-bTSPsn-rauDkLFiZjEumD5rtcvbJmn7D8fMoZPwT3-_>
X-ME-Received: <xmr:HHLoauJZq94syw5zA0XN3RjFKcF8IQlUW_lDmW08vYLNTG65tD8KffrtgTU>
X-ME-Proxy-Cause: dmFkZTFijutip9/taopBo2TwiHA5kBefO699Gw0yc43SkJHEMAFyRmQaAz/9amNCKfnBon
    FiV+vO8qDhPO+hZToov87zeh2bR5WPig+D56YNcCUO8RqPVFefpVCkGskNfa9YsAPo6IIm
    UfYvW+QzIhvcSawhjzbZJHyzdBQtbFs0T9zK/mVZSuwJB+N4RadaPwU6YzppvV1hK9zRx/
    olRwL35gSOJL/eWMf/O3uLGQn8Kx4iWFPzn384mtyyBDF7/ymfxQ06v0703h31wE8ctsAK
    /uZoMKq+b6GczAU6Kl065HEvmerXSbMo4Z05ELEV+bKOKu8CiHSwgQswkaTW2kkwn1vsWG
    POviuYNCO5DWbBdR8OIXnrGaX5Ix2h/zrpqiKrGK8kgou+qDAnGsnlUDyf1DMP7A5xEciL
    kIgD0Ytc1puTLUa/n6RA8IH4Y7Bw6GAy1qUDhoz1/l2iJWwmhyEtw93DzLm9BJ78e2g1/d
    SzM6JFFe/YZ/uu0/p1s23C+T/zQu14td/EAJ9n8Ctp17M6Cl3LI9eXRV++irLzwS4/ho5h
    Zb0bGXYGDJ+k5cIf3yMkF3FVl+Ra6f/Bk45/xvlpDB32vKr7rPgbBsCV0jX6jkrLpEWoD5
    8tVk0Y5kuO6jUbpkgy8ex2LGNnp9MuUEBjqGMbIXspX/jHeVjKhq8G17gOow
X-ME-Proxy: <xmx:HHLoaj0-K2A6mWRmcjNoZ0DqiU5RT_hBtX-IXkd9p_cGHfZ1dKvV9w>
    <xmx:HHLoanaa16MjhNTCvpcqKEXbXO11_jFRpe11Vi7Fh8wI0x5B6-DIxA>
    <xmx:HHLoarpptNb3uaXKOv5-gp7oc5AGju1JGJN6oyyQUMbF1QnS05YxYg>
    <xmx:HHLoanhbLex4XVT1_bQq-aL7mORvunco3U1WRCiVDVTKg2EvCKAJTA>
    <xmx:HHLoaqvnGxzhMM3LDFm86Qwaq8lmwZNUfLdugAVcqG8E_IvjgYxwSS3e>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 06:20:58 -0500 (EST)
Date: Mon, 2 Nov 2026 11:20:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
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
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
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
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Message-ID: <auhx--fF1TpX-ZYz@thinkstation>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B51A80003
X-Stat-Signature: 8w6ce3gb6ip1dh8mt7mfxdremf3w3b7j
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618475-902047
X-HE-Meta: U2FsdGVkX18rbr+0A/UPGNo9g3cWVwzg7w3UlD6VDXzRYgc4qVpNzkiPxvSKVaoUHx2AoadEOyDCv0NIy75Jb0ZQkTYh3SX/lugfI87hXcSMEPc7iZyULE6vjwcw4KNmAtRGbFyXVLZN7u9RqKZW+LL8LXMsK+NEHYKcB+WHZgpmPmy4nd4FYcoq6R/B3iKJAQ7VMGV1Mfq//2KuGIH9hRa024a/kzc+w8mLajKZYUtsxEusNu76KFcxHsrnNktKTPtKUK2UIlu9fThxe5FvSYZc9lxvnGg5aG9NrBQZrQgmJQcfKMcviZ8imCUm80ZZvMWAilUl5NegOTKHJXjSAgeWcgCG0tfAk6bSqVWXXf31l2kEALEFZ7vPkjOWkf9ZOAAdlf0SAMwOykvMZvuBRTqMdNVspv17weic8JhvtrOUczEtOeOSmhkKhJ3SuGRnTjvOR0PZo37Anw+Vrf62F3MhP0/P2cahxYAqC80hJrFYwjFHfPNq2FAVFgFs4E62N/AK503m1eILuQCi5HE1uTtgOdys0ORxwb45ndH9fhrGh/sQHYhgui5K8A4HdiFk1S+9EARxzf6QhrCW4df8BXTZTtbNd86VoRMeTcOQqN61O0JuEteQY+LSiqEH+nHrT46GlDziQUgaabPBXwVFY9/drGNjNR6WpyTJzc2pTCYe8Jj/jljfpEf8CYE8+ePNTJE1Jb12Kp+q4MO27iwMsN/KZqKcAYPnw/4YWDPzTVDB50zWvRX6NCYt/YQym73UxndcbeoMLiTomvwRImCm0ETgNfDBOL4AOkkJ2s+pwLrYi6RFkHVGmOcH7o+k0JideZuVfMGcn7J11Jrq7PtnUmfoozpGEw4rJIoWwHIvYhdh485sqXpoduRXwdFwr2EyD2GDzy9UjqpVDz0fZr3rV6NuPl2nACrYskiTJW6E8wdIcVyXMVGQCIDZ+WjNSmFncoPBEOV04ew/t0X609R
 O0paIgMj
 H5mfkF+DbSNWx51q49t9voC9yBA2DaBnnMD58P9akE6hqyCzAkZgLHLngZnyawAkRlKCToItxcVcsAWM9jGpClykSpO1CTwnBXb1TruKx6J0JXzqEaEB698nGg+2AIiRy+MWSRWJ4Am/MdcBWEXU2mX+Rgvlf8MFZzCj3uhRwTsXwA186A/S0n7sk07GkfWEPjr01sXgA6WSAGWuSQ0bfp3zvc0Rks4wTCTIKE+mtzkX/XrMO8vOgSEvZi3OsA9ZVDTLoOKxlcSDN3rjNJaTriOJJ4chyLq90Vt2tywGKjg1iCRM0U9fJEirR7g3ygXnlWnePtqWG/rcdcNIb69IvD2EIGdApxmXykzzXMHIesNbvYoQOySJz4CjWBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:24PM +0100, David Hildenbrand (Arm) wrote:
> Hi,
> 
> several MM updates:
> 
> Make Zi Yan a THP maintainer (thanks for all your hard work over
> the years and thanks for taking on this responsibility), and perform some
> MM MAINTAINERS cleanups.
> 
> Then, start the next step of the transition from Andrew's MM tree to
> separate component trees that all get integrated into the mm-next
> integration tree.
> 
> Start routing shmem through mm/core.git, adding me as a maintainer
> primarily to pick patches.
> 
> Then, target the following components for the mm/core.git tree that I
> (co)maintain:
> 
>      - MEMORY MANAGEMENT - BALLOON
>      - MEMORY MANAGEMENT - CORE
>      - MEMORY MANAGEMENT - GUP (GET USER PAGES)
>      - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
>      - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
>      - MEMORY MANAGEMENT - MIGRATION
>      - MEMORY MANAGEMENT - NUMA PLACEMENT
>      - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
>      - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> 
> More details in the last patch.
> 
> In the upcoming cycles we'll then route more of the other MM components
> through different trees.
> 
> Let's see how this goes, in particular with the continuous stream of
> fixes. But getting these in in a controlled way has highest priority
> right now wither way.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Congrats, Zi!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

