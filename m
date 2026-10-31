Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15417606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 01:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i4RxBCx4
Received: by kanga.kvack.org (Postfix)
	id F2DF96B00EF; Fri, 30 Oct 2026 21:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB79B6B05B1; Fri, 30 Oct 2026 21:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FE26B05B2; Fri, 30 Oct 2026 21:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A802E6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:42:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1929F16087A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:42:20 +0000 (UTC)
X-FDA: 85381221240.24.DDB301D
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7BA53A0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:42:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i4RxBCx4;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793410938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5beK/wqta6fa7ekid99EnBANYB7xsLLW6wDEnyFugQ=;
	b=Yf/VklsoXQz31nSH+t51EzDM4NnW2MyzKmCEw9HYlLVhIGRXQwdIA3zdXaIGs4MHFcO1IY
	RkGZnWBHW9/AZFLws/t/dZzIaxHkzy2S+caBkeouabYbc5jhPSBC1jV0KEbXV4l3bWf3wu
	qqJEWJUN7kJoaiw5HaZAs07yJ2c/uus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793410938;
	b=CKwyQ4yYXEiP22Vd5ZypFEHj/1jgmHVF3W+YclmkJDPehVvnwNWklF8qKIIg4+bj/8fkPx
	hmbWKpIAJvrmAe3GOvS+WS/4K6xDnIszbYvo6i/OscsLaBabuzuLpdzOz3WtEfe4Qod6Ga
	B76ubDc+xvxyRARKiUAkz1zREL0fUSg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i4RxBCx4;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MpJ2KknoxvhydMM0mBu6hlDwlGwxhQOvcnm75Ft8d4M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793410933; v=1; x=1794015733;
 b=i4RxBCx4+vXFIwhiP6CNwflbt3rAtoBok+EdOFAGJXqPkgnid6trH1RYGNUsz+s0B79enYr8
 c7kWo/qZ/bkJtum4X3dvnr5XpPJDNhEMkqmtbV5EHWkoKh7AlaPIljgPOcsVoG9ZsLRhFMyZGU8
 PtnFVSvFeTCx34K90DjAn8LY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bee3307f5ff8da89;
	Sat, 31 Oct 2026 01:42:12 +0000
X-Mizu-Trace-ID: bee3307f5ff8da89
X-Migadu-Flow: FLOW_OUT
Message-ID: <febf6aeb-82dd-4a98-9a33-0ef321792285@linux.dev>
Date: Sat, 31 Oct 2026 09:41:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>, SJ Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261030002004.154595-1-sj@kernel.org>
 <6d679adb-a866-4a76-b9ea-3b8c64171fae@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <6d679adb-a866-4a76-b9ea-3b8c64171fae@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7BA53A0002
X-Stat-Signature: zq1gyjo6c4c35c4z9xkmbat3fxhcpscj
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793410936-873588
X-HE-Meta: U2FsdGVkX19mr2UMgo/52akV5wsccRclBAqMKTP/enOEtunhQLVavjKv1CVu+OHVrpU5y1Y5igKDUioTxQiYeD7O6eDKVE7eU5xdWixN3kfgN4ZgFlXbeEA8Rm9wgK61P1EJTWReVJHMX02NBlSck3E4QmXzHceJ+zyV9CX2+VU+DTq3DXonRXjPtwPMP9B1GwB3Qpm6ttqjh70gAKRynx19qTQVLSN9E1ogZ7Oc+kNj2DyPIlWvjWCe0mgU2FelaGCD/QGc4vn8qqo9sLm0EdmygR1psDrilN3HnCpWlC4bgbpqMScLONDrkml8T/l6cFtTwYsf3bWBH1rClcscPphRJ5twVtW0qnvl7ZaMBUUvmqdamJINRoVJ4md1AXLp0zjDaDlUYJYyq3zreTimQ/j3/7nZ2T+kFSSVhfohqY/9laTIcyDjkksF4nyR1F0A9USUsFn1AT67iweXGdCpdlDo2nm/+5N9yAlmKuZH7X0skn4ic9YcuQgoHEUpa+2ont2k+7zaDi10WQbiqJNJG+h1nhaIUWr4ER0Qnl5MwbyMRB98/oIM51wEh6P0706cq7tnyKj/DrxGtNctKM+DxOxwwBScXd1DfJFTRFhpH52mQc4qQ4svKbvOE1KXk46b8Vk4m6OG96FdO02Vm9nRGXCy5sryk/viB1nXcD6oLqoCajp36DHk4NyDV7a3rhwQOLZY1lPTXiC+lQT84h3ofwcf+pMi8dpYTkykW43ui6+hvCDL3N2Jsa9Oy5uG9CEr0QR5vBz3h+vmGxDH6pEF6kye8/JXAbhTsqjbitxUMReHd8TsBt96kKEk9VYkET26uOGPzj0RNrf30HsUzj0LOksjn8w+0jcl1Ukjs+U7O6csQX/DhH3r0d7MJL6QN30GPjmtitZtkOoykhy/skqIt0RKybzSDDMe+TBZPBbkp8NtVqxpFECEqgsh/MrvJKeV4h/TUT84uREkREn6X+9
 ghgl9DrO
 D/Wnq1M5FF9QPqlYlshzJ0UhYdxXQY6PJntAgaDM4oOrxajud3k2brruEucTvNN2H4sNVfqJfhqkoZ8ptKmwKXNZCt29KxalgE2tJyXPTXNs9PSfqgyiDIhPPYtySBTqSuOWdF8CXdKhrwjzcYf7cjZO5wY06rnJfiXagndktqG6XMIVhb5xFDY7ZeP011/hFaCFUFzFOu3gYrunv+y+A2n2bxuQL/BU1uIQ2UkHMI5kzPgHPNUBeuiAtyljuUGHVeaYOFOErvpOvuHOuN8926lV8UN9y0kZG8xM+23Qigl0Kj3s4U/HIbLZQ5kuYtwSuiIisNgSSSME5dZ4GnBg2oD1reBOFfXZ7UWhPGeAwcliBDjQ19bz/M4oFQSGyPE1140ExE0mq8thwVX5FgnXpLagKud4ZHrCx2mjWVs67A6bGglT4akMyZctTtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/30/2026 6:21 PM, David Hildenbrand (Arm) wrote:
> On 10/30/26 01:20, SJ Park wrote:
>> 'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
>> But I can show there are already quite a number of recipients, so I'm just
>> noting here.
>>
>> - Brian Geffon <bgeffon@google.com>
>> - Oleksandr Natalenko <oleksandr@natalenko.name>
>> - Steven Barrett <steven@liquorix.net>
>> - Yu Zhao <yuzhao@google.com>
> 
> The CC list was so long that I limited it to people that area either a reviewer
> or a maintainer of code.
> 
> MGLRU not having any real maintainer is a big problem; because that maintainer
> would know whom to CC.
> 
Agreed. FWIW, I think Barry Song and Kairui Song would be good candidates
for the maintainer role.

Both of them have been contributing to MGLRU consistently and
substantially. Barry is currently working on improving aging and fixing
the swappiness-related issues, and Kairui is driving the MGLRU-FG
optimization work.

They have also been active in reviewing MGLRU patches, and their review
comments are usually to the point and helpful. They have been looking
after this code well, so I think they would be a good fit as
maintainers.

-- 
Best regards
Ridong


