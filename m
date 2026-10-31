Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B3B606A323
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 07:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k2DV4TNM
Received: by kanga.kvack.org (Postfix)
	id AB9746B00EF; Sat, 31 Oct 2026 03:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B016B05B1; Sat, 31 Oct 2026 03:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959576B05B2; Sat, 31 Oct 2026 03:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6359F6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:49:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C591A1A013F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:49:41 +0000 (UTC)
X-FDA: 85382146962.08.8C9C67C
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8EF34C0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:49:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2DV4TNM;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793432980;
	b=1oBCs+k2rY6c9LjdYhOKU0ql/Bw4GeVFHAWkt8Bp25qirKuKS3WfmiKGMN31xsofd0TdB4
	oIzHwmDK7bnjAOhejkEs3U/ywZRYKK5HZh8Qw+DvW7E9Pv1MU6Sg4pe8GDD3d88TaWwfEe
	r7JsXEcIgMIqW20vc4CtKocdvoEFuY4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793432980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yrnXSjuGtKvXirNf19gKPohNcjZeXRzs8MVdnL1uJo=;
	b=OmSsJvHMkqq6xRVgXVakOeF9EPUxN4C9l9GMVqx841L211i/VJpk/sAn4xiVlnmgt1c4kB
	SF1WDeNcZDwuimy9t4h16DBc5r3tdiZ/0xfBTCIscciGw5OBT6MCpqI8bhjtKLRFfXMGof
	P8lwvqigA0AeiTCSTpIoGdLi6aO6YV8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2DV4TNM;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2hMyZCs1UGewOfOEo2oSastc/qJPy14To9PU6CeHTdk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793432978; v=1; x=1794037778;
 b=k2DV4TNMPKdue/DBAOU7cA9uLmURd3BY5v6y0UkKo/1LnjZyF5jKWpC5kyg5sInIFdiW/AEu
 CnbFpM0zZMgWnea8Q76MIVqWbrstSK5H/CD46HilBSKHlzQXIXNrAmMI6bvBfc7zSlP78gdkNIr
 Bzrrc2qmAnyIelevzXHnJn4E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1faece7cfffda491;
	Sat, 31 Oct 2026 07:49:37 +0000
X-Mizu-Trace-ID: 1faece7cfffda491
X-Migadu-Flow: FLOW_OUT
Message-ID: <33ce5d90-cc8b-4d21-9838-17db23407e84@linux.dev>
Date: Sat, 31 Oct 2026 15:49:12 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Rakie Kim <rakie.kim@sk.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ty6afge7rm3eg4pobn3o517eytpkwep
X-Rspamd-Queue-Id: 8EF34C0002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793432979-661045
X-HE-Meta: U2FsdGVkX1+q3M5rJH6RJQ5OPJY4llYyLUA3Q46pGxKBdzUwgDYc2Bz3gyKDywWUnDNeOrLPydNUzq31901gRhHq1NMgre7rvzSEpsvbW+zmU3a+BHYt/5OBXCEN/XeqoQXlT65HjXqfecKufPOaBAIKWNfhsVI7vVGXpIo+0G7ydEFKT5COHvDwEppcyJN0CF9VwepnFnFFRxISLCUSy6xTbGrkpLsWZ6gFWm0xadcmL5TVaKBJBShvpAt1jzJfP0wErA0EJksJM/xh3Rq4I3beEtPIqG/AQGcChq5xbmm25Lcf6lg7OJXRCfZ2URNmX0mY+YOcy72fLK96xAgideh6tVmrM5hrs2Hu44ARigQbm8MqfDw04frIfGSa7SArZK2ROYQ/+ZhgSk0IuGnQzANDCCNaF4RfmPPGwNrYMySPupVLD4JtZjBRrOgi88pup+XWMVpdDy7srhRFmIhs2bHSUOYsxwY6BuBrWRWqvmnknvta8RYLM4ndPhdMcxAttJc/Vpmeesjlv3v/PUCajzWPM4ugpaymTWbDXCnL0QreudV11QsWeT6tQzB4XbBKzqlPJfxy/8CYYXX6vhqDvamyJL4//AQebGL6oF0zjb5PDA2EpC5v8Krj9LGhBqzDIFjaHxazMVlouDgI7+Kb9kgLOtUqPhSENlfz4Zsc6rtWr1HrphhAOCkPGyfK+KcekGQOL+d1/0IYODranIj5Y0MH39mALE2DpJzTjBF5g+IoW9sXYAtk3nBpq5OUUY72+oQ6+UOpJT3XEjbKG8Bi/Kiqlz2uNxLUYVaZtZyDHNV3CzZJ/Tu6nPJbcI8aEqRXSvX1dfH5q76m1hW7xncvZuqCkCUNAXZKaAeRVycOestWBEr+sxkbeAFtysamw1QBi39Z8xlL8tUf1/nmNCsgrbh3knalYUH61iqzvEXaJGZVaojgDgynCNIWo+Bp2qbk21j+6iuoDMh1FkRjbXJ
 7FYHxd2Y
 kcBN9+ONuqtXSeFtD5uwfEBJdhdy2DBnjFoPBg+wtpByzfSty7GZ4G93zdQDQLHluYg613eCKnd+9HOr8CPDwwlGAGFh/VyvKjYeALNdjUlg7fpna7qJJzszy1IgRDy4jzG7Ri3Ruhly3T7oRvH2Zwn1cVSwVthb6T2FKusTcGTbN/cto30S94fncbiMaU7+LSL0Dd0TbQhM4X6YicSrerW0yIe6TGHn+TQCjDxbWtvNbXYE8jJhKVYYB4A0e+0/ymLSekgUS6gAQIUiUcpufbFC3JJUuKGzQwxNFhlDo9NFqfBU/FhYn6avt0kgVTGi67iPIWjiAjOheQTpGWMAs5+d/m8T2kdAtR8PPNemdvAVW7enyM/FXELYAq6Hv8lCfPOMZZ3FWBglWfygpBwQIMySybHogy7bvIbqhEAFEq8kOCfodfG1mPXpFoMYKUzU7k7l6wDCQvSlrkEJEvds7uDSZqPY6/FcbObtk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:34 AM, David Hildenbrand (Arm) wrote:
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
>       - MEMORY MANAGEMENT - BALLOON
>       - MEMORY MANAGEMENT - CORE
>       - MEMORY MANAGEMENT - GUP (GET USER PAGES)
>       - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
>       - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
>       - MEMORY MANAGEMENT - MIGRATION
>       - MEMORY MANAGEMENT - NUMA PLACEMENT
>       - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
>       - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
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
> ---
> David Hildenbrand (Arm) (7):
>        MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
>        MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
>        MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
>        MAINTAINERS: sort entries in MM sections
>        MAINTAINERS: add missing files to MM component sections
>        MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
>        MAINTAINERS: route more MM changes through mm/core.git
> 
>   MAINTAINERS | 165 ++++++++++++++++++++++++++++++++++++++----------------------
>   1 file changed, 105 insertions(+), 60 deletions(-)

For this series:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> ---
> 
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
> 
> change-id: 20261029-maintainers-e2699bff7521
> 
> --
> 
> Cheers,
> 
> David
> 


