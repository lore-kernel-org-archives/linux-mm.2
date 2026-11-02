Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73105606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=w05zkXPg
Received: by kanga.kvack.org (Postfix)
	id 425CF6B05B2; Sun,  1 Nov 2026 21:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6C56B05B3; Sun,  1 Nov 2026 21:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F12D6B05B4; Sun,  1 Nov 2026 21:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFAAC6B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:04:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30F5BC0BE3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:04:48 +0000 (UTC)
X-FDA: 85388535456.27.88F8AA6
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3C0F2180003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:04:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w05zkXPg;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793585086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SoV6Ie/u/kLwdZ8E6uFvG3ADmBAEd2i0jYO5Qw9CmA=;
	b=QNpp432wAGbVD1aDgmd/uie8Z76BJJzhxrbwa+/5+jdjJ+KV5oNTPsGs9ZhuvORWwsu1XC
	HCg8vX3Q8EUu535EjNFgH40gO4pMJQeiqvqQ1CPqCuL8z9C5uc30baSZDo7g5qcXCw+qnl
	oSas+kdh836AD3crQ0wScpLIZvul3E8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w05zkXPg;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793585086;
	b=5BQkplGE6hWF2o5oj/CXFnB82nm64Hui9NC5KoVrtQyFei6HNS/4Q59OUTgWBW3C0ONtfR
	csvxHCNsgC4rLWP7bTPCf9ipGOWsDfVhuHNM7ABrQ+k8/uITIYgI0rsXYbb2WRDP4T+XFZ
	zTCxWdt6istI/J5TEQ/CvjAnt7tfQJ4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793585081; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4SoV6Ie/u/kLwdZ8E6uFvG3ADmBAEd2i0jYO5Qw9CmA=;
	b=w05zkXPg6tFH59wFxmHdYqrzt6gRR5EvvFayQ1HH78v5DI82qZuXvn8U8hxONa4AF9xfS49hvmMc1+4lHFS7nbQmdmPrahm0e7POP/hr3x+D9ggAhJKQHN/+7UDnuSjqyXHo6G+PLnTRzBZxiz83euxWjSn8+e5l8+kYbu/3wtQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=61;SR=0;TI=SMTPD_---0XDraKLa_1793585074;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDraKLa_1793585074 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 10:04:36 +0800
Message-ID: <4a797511-2e56-468e-ab88-5ae855439144@linux.alibaba.com>
Date: Mon, 2 Nov 2026 10:04:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C0F2180003
X-Stat-Signature: dwr7anhu541f4xosqga36gmgpzijbwr1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793585084-691815
X-HE-Meta: U2FsdGVkX1+hMpSCvddCqDWJf/8YoNW9kJIGxzeiFMCtzJjQmLUCa9NlR6NeA68yoovKbiuPFOIoy3yVdR7ZIInTeGtR1LggmRbIDfckj+GsLsgfjwV/vChSRegrs2QtoQ5JnYkjz7b0LTg3LLJp31oJT/UydoLxZPPGopt3FKyvEv+330nwRkMnJoKbCg6GjZYSFlZzEYg+Zr0lj308nd3arMGmvngiF94q24TspS8EAMX9ohQJnR5XG7Ixvj/Or2Gbiz/vgCB0mU0/Wn4aSE+/4xwrBIxZYnqDLH1sDlKhFqH9Cm+k/jTiCUll2ug8cEMV4005Bj5C4lC+axy5oKJ5W3L9sbZRAh2OKgI8OP4ku/5xwddZlxn0yJv/ydNxKa2RLPBZBV/eEoGqfKiJyBIeXFSL68CA4ts8Np5171RuYVGbYmKXWGwzytUuYLWlN1v4FD80tvMYXlL1fjir/QnBa8DnZ8XWE1VuWZHi3AriQuLvaz3eF7fj2v3KYtqr+aoO3M3/GHwtmfSrX6RKgzN2iJAKd2Af4DxISSapY5W+s1rvODMQWmM/oM66nAzUDSL5yEYLeey7k/7dLkLz89e+yYZ7jgPEQPNjPY/TaxUValqA7PVBJ6utktEy7X209wb/BY4LWZHuI/qVOedYohfKyuY7xwopqGpPYDsCEKamNZAk4Skcp8mQ81v98A4vicWKarXf2/SZxOVX929znYpeCTK/RO5DoRR8tqPyO67lfa3cxwBZ9SPTWZngdWSCT2uCZL+eVNTBKOp6d9vet8a6IfvJJMDrnyKNS/mgij/nW8QFOKckhiFYayvLLY97Sgt5sjLE6Gb8tcxQtaYbiEaJ47hKDyWF2F0IdsQeXtpSxHPmKgyTGlQZhwykx4Urgp8QGniEp//DdgGMMB0pg6nH/bXKBPf8tDCj4g8xzRoF+7etjz/ENbMh7gSoXR8Ej2eRPTIWZw5f/5BhluD
 3MyRzQ6w
 AVhK7lq8BmSiJj+rZoZeni3YLGGVDHCdPadKSV1uCy+YUZdJ2hP4pp6b3pPCSKfWzAQs9SRAZVk22R60jw/sp25rzwX6m8zcQBfuAYZ5zYpgBm8mtp5gbvZ6lJBD+xYFEMA3T7qghb8BuN12u39mMT40kl0PhV/vMRCT/0WPdwcYsatYWh7ZtMqudJlZRGLJKMtXoq9P9x1UMFH89CxvtxuKAtU4zYupaqmFVWwsS/ej7BQkBcyha9jQ4HX6AsaUtMOL3IORMQknF0wz7b8doPCasR8u5gahm3sD+3VOi4VotaGF9/Nm2Uuo25H3OehDN8EM8tHwX97VcI/pbH7YLnkX5VgfL/WDAYz5TlvZDwG3ODRzqmZB4siZ7vjdSVRjyd/aIXM6Nq074MJX8U21cb+OSVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:34 AM, David Hildenbrand (Arm) wrote:
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
> ---

Thanks for Zi's great work!
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

