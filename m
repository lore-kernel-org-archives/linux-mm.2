Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 526B9606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ICCbTdoW
Received: by kanga.kvack.org (Postfix)
	id 4F4576B05C1; Tue, 27 Oct 2026 04:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5636B05C2; Tue, 27 Oct 2026 04:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D3B6B05C5; Tue, 27 Oct 2026 04:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE3B6B05C1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:44:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C0B01A0908
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:44:42 +0000 (UTC)
X-FDA: 85367770404.22.634BD16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 060DD180008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:44:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ICCbTdoW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+LEOaUQbUL+JHSbe+QhToSeMirP6JQp6AWWXj4VvXk=;
	b=1uvZIYFwg1et8UP0aF/Xva79Pyb9HdNpZNLjvAKA1iXCWZkWSFRVK+jqs5HoYxUSXNa/RW
	US5DsouirsF5Gyy7y2i8UkySwrHpEgO+tdF2HU78d7xomQ+B7p5Q40dYeVyGjmeQmFX45T
	V2JEKGH7ceUK8DdNbcaypZ/yeh2N8kM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ICCbTdoW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793090681;
	b=t7dFyTb9k9Ze7qX5hg40hXwbjJoPV7EmKtbKOzHchcC33cenitSvP5ZYNXOLnoTqtkXqj+
	gRJcPm5hIOHEQQ2ZEkHyneI0GXgyW3bC0zef6v601dJEK9EDJj3JtMGOxXfpX8ej/IZ3Wi
	2kP6Tb/58oDnJa/TWvuu+JdBRAe/haU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31835437B9;
	Tue, 27 Oct 2026 08:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DD61F01825;
	Tue, 27 Oct 2026 08:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090680;
	bh=W+LEOaUQbUL+JHSbe+QhToSeMirP6JQp6AWWXj4VvXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ICCbTdoW/j7vqJ21aKNf/Ed7op7mGrUCMSzQUb8CI9Wrhehz+xNzXORgvl1APqyYy
	 36Djhv9uRr8ibA5ZP/MXz9DGGy2YmD7yoOnrHShKNQ+NeGuxGeCDo7rr3bLeaLmD8S
	 Y6vaYvwfMvcfFhI6X25asa1qBukhNTx8j8CEt/wbHFjYyz6jqnGVxAbA5PciqivIvP
	 H1w3YA7zTBJBBFdxW3/ueobcnz6eECayjH8MEn59pysbYWJt7xD6EkLjBPY8Rz0cxN
	 yndkPIyJetYPEWfWxlUsoRHPsSpa3WU2QdMKXi2GMDbSeMhs4bt8OkMWTEjKTRKmBG
	 Cl5DzBeXFeqTA==
Date: Tue, 27 Oct 2026 08:44:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
Message-ID: <auBkQ-7IlOnZA4mm@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
 <179307206859.1171062.6841971971647864368.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179307206859.1171062.6841971971647864368.b4-reply@b4>
X-Rspamd-Queue-Id: 060DD180008
X-Stat-Signature: k98ttjyapk38uigs6zjzh5yhbyokngzd
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793090680-135273
X-HE-Meta: U2FsdGVkX1+5LWH9cXrcgpobIbx8E7muOcGWTJWsxn04XmxS/5oXJZj8/Cm+qPneQ5MMSBj4dPnkKMjF9OUxuDxJYf+XMp3UCFFI4KJIHYt9hOfQiKwkytBs4auv/DfoRbvEXb/dL4xxROEI6qV4fYzFUs0GfVQB8xdX+TiE/yPh3/DEkbd2MNW/5zh6IExCFCbGiuMEIJA9miurdGV3J8aJGjy0DEKiQbFCSV4GZ+UPFgzeD9MaO1vypOezl3cSjCqCSBam/+DIThB/xG33RcTdaMU7VTyWImTWeneh0KjsC4Dx5b7itjuxeRO3k6t3NHlRtecN0+KGQ/eSXlaG3ESSYcWmOsPrEiLnpDaV//NeSZtDoWfMOm5v2i/Ig1vTkrMzNb1EwWSS1l2BO1NOxa2PP4uaYOl7oLd8XU9SaAgtOwwZpvxfRaaemFHAYIQ1m+AVexgvRzEBVty7ybUkwkev9sAi8fraMRUnT9uSC7InBHFAp8DT496GG63xS2daLcfGlFRKl6K5vo7FJW8zt18A+zot0VyH38VfD2KIxFHOtx1BGeFpOyQaQPWVJNlFfqF2qiJ3q7tUxdEnAQPB3pn+GE3h8OMdB20+RseuJVjVuIEJR9v8UGUHNZdxw6vbtB0//QQJWu656R9BWOBhNjDwN0pSueYUNiQbSlM40W8uwDdsuYelGY+qM4UgSJljxpB4e2sItTdoosQb3kEjli6ynTexq6jzOZL7jx9mZqN/oZBONS9rH9oSRz3nHrtan9eqkZaVVTcACXVBng3UKV8kpzz9GWPAVu95B2N+IAWmo9823pvIVD4Gw9Jlw4NQpj/5KYZ1vYYgQJ6rcGnHN4DzJeow3uPvg+myAbQjhUqUSAxWiASzZjQb61OU4NfmD4aFCWQXML0Udky7KYmsOoJWGNgUDVI3/TBQkaMy8RC5zh1uzFQnDP91WQ1GJuBNrAKA/ehpiA/nFW6Zbcm
 kTK0h5Ns
 FuG1N9eIZ5Fh0HiUsj5OiM12s4LA9rUAxJi2MJkw7TX6uBTUggkUBOYE5LmrjS8AUOlw6SIBoYJulwauCSKxaEeVdWG8JlOMOUydmKtTZ+iTSgzI6KinWGqPr/KIxc3CtqHRVNLmZ4UZNa5bodW1eYnCMwNTiuThoUnJ0U8rpEU/c5uAfPDM2wCAoGudGp4YwoTg8dUWndo8hyDCB/Mw+GQ8u62/4sDQ9akr/t8strzBpMXRvSXWP0gLovwrbCZGaSmDAfD6Wpwlnd2euw/83O/tYYg1WZwtEhlWzIqPTcjVYgPIaQDGh6jybgkA3hqy8+IW8B2xQFUXBXDA4X2ve+bHwi+/ZYFdoY3obOIRYGQhohjSZDKHi6vrSxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 08:34:28PM -0700, Gregory Price wrote:
> This one arguably should have at least a trivial selftest.

Generally, we don't include tests with fixes. So these things have to be a
follow up.

--
Cheers, Lorenzo

