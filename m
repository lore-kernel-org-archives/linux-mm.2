Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34ED2606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 23:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MT2/EA0e
Received: by kanga.kvack.org (Postfix)
	id 2BFC06B05B4; Fri, 30 Oct 2026 19:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297606B05B5; Fri, 30 Oct 2026 19:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD0F6B05B6; Fri, 30 Oct 2026 19:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFFEF6B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:48:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80F65120853
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:48:17 +0000 (UTC)
X-FDA: 85380933834.10.75406FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0C02140002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:48:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MT2/EA0e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793404095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQmPF2jG9yjZyMk4TrcEAAEQoxSKIkZQK8ZYddN89K0=;
	b=MQvt+wKBpCmJ97apkF4ma0xR44S0zgI9GR0LbAS9RtVE1ceB0ilBFxPPZjRkpbVzSdGGqP
	OS4yPOtAEp4x78IqV9hZceCZd5kZTtT7fNwvHvNOEdSrqJ9y6jL7hZ+BZ4CD8hQPyzH40g
	OZZPuV1CRxOkkrxUyYVE4ExNxwBvOYM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MT2/EA0e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793404095;
	b=rMUKZ2zuqGz03ccNXDJV8ALH1r9oSbU3t1AcBNWzeiblQuN4JaykXkf2oTQRtlhs7s57pj
	mB/Na6DWt7m3Ld10lII2rXXjJzoQlgHmv6lJjREB3v72hLS/DzYYtEAYDyAHT2j7E+4TCR
	uK85pe5jp1CMlWAHomVM4yTwiymhJX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B642641339;
	Fri, 30 Oct 2026 23:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F9F1F00A02;
	Fri, 30 Oct 2026 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793404094;
	bh=uQmPF2jG9yjZyMk4TrcEAAEQoxSKIkZQK8ZYddN89K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MT2/EA0ezaYproGDll3KiLAyVEWSPZoKHiRXDywJ4aHQIzyhxwRWbhglWb3e7dKsz
	 AEnmNyNX8Rcma59EV7eOcdo43hJV3UWyyp1EEpZA8V53cZzC8ibmhrWsCHhd3ntURg
	 c5P/CKQqJKTkQLSHunG90TVVjWY3k050fH/bObXqsHH1hydv3QVr/OgYQi355iFOiF
	 JtArXodjjPIzQ3o0JyTSceeGaK8Vpf4oWVTDg9aqSczBRMGkGDD9LAfK/1mBWdRTX0
	 vIoNdT2am2JTHVTTgrC8yNDOYEoiKRQXV4BL7VJTm0trkxBMccLX/hXZvuwU8ol1v3
	 PE2FPFd1CIhgg==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Byungchul Park <byungchul@sk.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Dave Chinner <david@fromorbit.com>,
	David Rientjes <rientjes@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Gregory Price <gourry@gourry.net>,
	Hao Li <hao.li@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Nick Piggin <npiggin@gmail.com>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Date: Fri, 30 Oct 2026 16:48:05 -0700
Message-ID: <20261030234805.86833-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0C02140002
X-Stat-Signature: jkpusweqwz8xmz385a89b49ej8tw11rb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793404095-591650
X-HE-Meta: U2FsdGVkX1+QWMhMzMpnNwAzZxROzzKc0n4Pic6NnHJoTf+xd2If5jf3jyMxg5tFC8d3D/qEoaMRRz97yFUyumZ2xYIPfj5wQ/6zCIvVPXuU+cvV6lillwUxX3OVyORZlug71rbcbs4dy2py1Tjit5/rN0QsC/8TaUwFhVsbsPdg+pbzbZbc5Jav6O/yYNZfnsIsLNlWf+Pp+zp/FHdGgn0Fp1YTJlHa/rUzdwyP4XYfJ+F/N0FLugd4/m+JVpCI8zM++Tz8U2sOx8iVyOV56/dx+XQWZ//t+d26bR3Q3b+mOtSg61mw6uqYG7zQc+OE1H+tdJbzaBOzqP+mlgwiw5KJVlzQgcLT5ca04DB3rCDZVdGK6rMvJ3chgRot1MKXcSOiqFhseYWiDyrGGPCnsVK/JOK6N1bHkuZw+Bu7ogcXXDKpQ51awu0DWOd/GaaX+VIXD1FL//m0hbn2DAyUon5XRnBuHsEssZZYc0yksUiSQNOTaGY+ZIpLPFXh7q3NPw9ZHUX4HxQZWI9HxXPonM9hmqH9EVispDjX2q3vhiTMgQr9psnBUqCrqMFKiVd+mlW4G0Uw1+9dq+bBsayGBMDLVVPXODxuCldlv+mZ4ina+skF/O2FC4UxiCB+4PSKr7ECBflfphBtTpxi9kiFNxO3ekgo5tnBED3LVHvWcLgnWBJNi46e2MWARHVjB0BGDwtDGiDKIag7syfus8AG+pwx1clWmBoQDGMxi18bA/o+1xcgcEjEyXfKSo8XT/dkgkVBFqhTLAedYO7b+z0oo2IKRTdItkryrD5jp1ksFGDSm6r3l22Yft9mgNZY7ZyYzZ8tTLpjoxX1oD1bOZs4JwM4YGqOpquZw3SE9GkYOeAT6XqLSgar7bIL7ygkLtmE+6HVkG5caMn9YvHGgUT2wT7lGOmwPRH0hlKVgRzp0pvrFRPoPbO7HmXVLZJvLW2tjuKaPRugBVxx0e7pPbl
 s0MkP3qP
 6sTGaE3+0KW3a+AYlWxKs2ZdpDS/Hi6rSOaUBW+3jFaGnMEU4P19qOAo8275tr/X1hLYfyBRYZosEkyeGrgV7LxdnK6wd20Ne2DE5+tmOurICTU8OwbJ7DMDoLInh0D2CCMgrzEdBJylFZNg87fydNGcPFrnoCRPpvDJvr8Wvzjcys7xg7aI7U8VgkEY6fSkb+KOH2CFau4q0tuBVvHc++qKJ0uHips+meRtSuQeLwctRWJYrtMh3i1mokU55qWkKRAwP9DgD5ZW1tW50S45ypOB8UnNX9XIR7s6Ch0WBL6qHKDSMElrVaBwicA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 22:34:24 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Hi,
> 
> several MM updates:
> 
> Make Zi Yan a THP maintainer (thanks for all your hard work over
> the years and thanks for taking on this responsibility), and perform some
> MM MAINTAINERS cleanups.

Congrats and thank you for stepping up, Zi!

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

All makes sense to me.  Thank you for this great work, David.

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

For the entire series,

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

