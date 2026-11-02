Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A67606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NZ7mLZNI
Received: by kanga.kvack.org (Postfix)
	id 6D9EC6B05B6; Mon,  2 Nov 2026 02:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A2C6B05B9; Mon,  2 Nov 2026 02:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A186B05BA; Mon,  2 Nov 2026 02:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35F546B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:09:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF3FD160BD3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:09:50 +0000 (UTC)
X-FDA: 85389304140.20.A7D42F6
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9CAD8140007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:09:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NZ7mLZNI;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793603387;
	b=7VBVJINXNjHEzrwb1TpNJL3cDSXkoUQKeSaKjPrbGqms9jsYlgfERY9ivvRO+EPnND9GoR
	rFD01tUbeQLJAciC69YQUkms9XvIznV4uL2Qfq6z5WofMSMACwfB0wmPJD2ziN9p9v92py
	FwjVyYlKkS6gek6Jt4v1DjK1rAdP3Zg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NZ7mLZNI;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793603387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fO+hC9G2Gl1xqrTCPgoZEeJNl9zikfHS4tc4D1yVE4=;
	b=IdtbPDCJiE0Sf8iG+Sm6WLAyfzIJt70UtDTkqMI130Ar7uajk1ZTh/6jxVr2XHPLY38i5P
	52WN8q2xoTL2cLFN8bNv8+yIvlCeEw8M6TxhgzTeiSglimceEk8Kj3if4Y+U2KUdQ2hphi
	nnevVuTkwxVl6U0jpOV5agLvDis8lOE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793603381; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2fO+hC9G2Gl1xqrTCPgoZEeJNl9zikfHS4tc4D1yVE4=;
	b=NZ7mLZNI8uJQaeSYoIVETAzHJapvJamo75sSzNds4uSjfhDqrTaqPehrMJ60C5rszlMXPDweu4AEH4jEF1C9ZCY4BmwceyeJX4+umUKxriKfLXKKyEY/mkB4LmiFHFkr0N9gxbLqutB4xXoI6DG/bGZ22MiHdOO3XcqUwWJSKTg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=66;SR=0;TI=SMTPD_---0XDudPio_1793603375;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDudPio_1793603375 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 15:09:37 +0800
Message-ID: <166bcddc-1a03-421d-9cc0-92b5a0159d69@linux.alibaba.com>
Date: Mon, 2 Nov 2026 15:09:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/47] mm/khugepaged: always recheck the pmd in
 try_collapse_pte_mapped_thp()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-15-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-15-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x4ahtx48t68h4zpjpfkpg1wszyqgqcn6
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CAD8140007
X-Rspam-User: 
X-HE-Tag: 1793603384-490427
X-HE-Meta: U2FsdGVkX1+uMO5fgeeFY5RWHEeE4lNxfSTvX90vECjJRW0+bV7d0wNStqMDH7g5CBLvKICinMkHIeQm4PvYiylo/e/mWEl5xDQYQPbQfnns1DjyYmTGBdvBtIcfWOZUZi0cT6GlRIPjPlusDuYdX9vhAG31DnhdBSAziIzaFL3VM6xUcTB0ghRdGBrG69Rrhp894IxQvcGZun9nOfFQf3j1y+pSvUpplxEf2nmR053R3ActkgziAAoDOM9XTdbFyjBVsRLr0v0B0+vKu9zRCs2BMLgaOHc0LYC/iE/tq3oyrWjiYdq0hvu43CiVsTrqnMdzOcTzC9HM8HYKeHM61CGnUoOsW2raV+8mgFZsOkeH8Im1Wgloj2rFXi+6orybHqdkOlbh4P/pDimhIojhm8FQ5CcIpbH71kaNzZ19rlSrtSIBZLPJnF9hlx2rZbm1/llc2dm4liLco8pJ+HWDSzaYdol3PN7J6naXd+j6c5mJy6c90/yn9FGeiGMaFkAvFd71cL8nzp7PTLvCxYtGWhxmHZNnLI+fhkEK6XjJLbOxaPOBqwJxsmKeKBcRZqci30MA6wRWY932+PdEuz5elk6r4CSQG914O9cHuhw2qUS2MR4LcXgxrQxfE+rg5urYrPbrVO/1EvHe195Pb8raQZy2KFtAc4abu2jBMxw4kUot1uOV5I6PUeJCuLxp5xvVNtIEWMoJOA8SAsgsKrcqLjITs5NgXeIBtFmcQe11SAyXxh6n9V8BnYkl0XPB3fgu4Vv3BOUn+e2txNDriN33lbeIXYpsH3iWU6/MuQvDWYxCIS4sEPu+ODmUQqyHm8GpM8Az6JXHyOItCVsMjnrmFVqkJDBwIrQCD6KcolyZlGq5VSh6cdskms8EmTySk5zp27r7m3tBTzNP94a+6Guywq5qXQ3kCy4F2F315dkxStxb+9E30QbPGbHxpKlIZOwYf+lwqe5hMNhDQaL+Yv8
 MyjPYGw5
 8RnZNH8BGxfh3bA/AByQ9Pvnh2+fv+GjZ2U9Yfu6ye4MT22ND0nl/cpH8TQSXJmC0462vbE3dmbKC4+5Yq95AFw9G0wfo/Y77Q/OmPd3oiBfrAU6Q8vNjaUUDeo/x4njaF1JbcuGq367+XA3R2gAEiWaCNMBhwaPPzBS6XiXe3KxzwnXstnUxKM4q+ZQ67R/iVrcKdwLJU6fYAj/reslU7NlxiFhlMdSQoPLNs2mdixPKNgs/W1Y2O2dVoTO1J7PZh4CCOhRM8VhxwrQEfp52tvlc8oNnX/12IlTG9nkNPFin25J3tev2MwQCPAyX5DGw/ikJTdVfMGU0fDpvF1H3OJT8QH63+hGHN6xGmcIWf1wEJVa3K4wkC8YTYjiB8e7Qf1MobX+Lv3/A7tGHGWDNTk6d3XN2P2AomMr0eNfPuEDeSF3h0ntjOqX+K56ZspFhfV1equPxGNhg7pWc79ybNQOwTUjQs5ha3xhVPwpvDN5SLGCt6aK9aOWO1NAXX8KrODX97iKQSbWQAxeT5UL52To4corBzqR/u2TNDEUOiqweA4xNfYwOqPOc/puosD58WICYiKgsfSBkXrzeDxH7TKhDZBC8nbBzGH2I2dbchKNiSf5A4Th96qBLPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> try_collapse_pte_mapped_thp() drops the PTE lock after it has cleared the
> page table, and takes the PMD lock and the PTE lock to remove it.
> 
> In between, MADV_DONTNEED with CONFIG_PT_RECLAIM can reclaim the
> page table. The pmd_same() check is supposed to handle this, but it is
> only done with CONFIG_SPLIT_PTE_PTLOCKS.
> 
> Fix it by performing the check unconditionally.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: adjust description ]
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

