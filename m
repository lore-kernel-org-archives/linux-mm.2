Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1CBC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 04:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BC16B0093; Mon, 14 Sep 2026 00:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DD46B0095; Mon, 14 Sep 2026 00:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B1B6B0096; Mon, 14 Sep 2026 00:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 275206B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:21:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F6E3C0FE4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:21:39 +0000 (UTC)
X-FDA: 85211069118.18.BC29D8A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD21340003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:21:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="VHq/c8Pp";
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789359697;
	b=6N7oY1QMeHQbMrIBE8p3XvpTMxQJG1pXzt/Ugb1gSQEa/Ba7hFuMc20C9L/Yg8uQNVF5Jc
	O2PXWwQALmv+SgRKpD0dJcQd7pkOhDzLrRlnJK/faoD/sQMfmz0Ssb1hJIkD6MsOpJ2Zg+
	uwZUCJ7NTKi2WGXoN1IuM3UeiSOWIOE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="VHq/c8Pp";
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789359697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIa/QTT2Vtv8NiYChAuw57Ae+l0UAwkEY31SNMwQavs=;
	b=klEJOXZ4cv1wU2SH0uZ51iXxRZP15Dc3RYlyVHheQgy37RFZSbsun127sMftVYOFQUYpVx
	jfPWlX4GMvSfZbeBDaQ0NEds/P7iYh8e9NniTcu7yU1lHod+URKcjpdo84m7cvX/L+4ybd
	5wIiZdQ7XXAS0jNIYhS22aF5RB2JM1E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XIa/QTT2Vtv8NiYChAuw57Ae+l0UAwkEY31SNMwQavs=; b=VHq/c8Pp7UCdPy63XwI1Y7/evy
	Zs6wNzMUH3y9lsWgsWNb5RSGYeSQu3+dwRZdgXhGjQadm2skLDAn/gsZQSr0RPAMMeECDGpa+etFJ
	GZ9W0qUhgJ+QpqD56J7NZ5uRTrraPD2HDAatD107Dp3uDh0n+iOUAQepIYxNbT07CT1OivKUu4rqR
	9T7pMp18HVSaFbknP5sOsW0VTb6JH/cNVnoDNqHZ/wAn8VlL9cIRO8bUeAaRAYVhxkupw1SgasBjf
	4D0IoMEvGnWlzdIMpEsme0E/QLtp6CUPuirl9Z1VPsWGxuq6MgoCtKLvy6o4mAhIx6zXHL2D24MjY
	lZwDMIbg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5yBr-00000008huW-1WeH;
	Mon, 14 Sep 2026 04:21:11 +0000
Date: Mon, 14 Sep 2026 05:21:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org, Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Tal Zussman <tz2294@columbia.edu>, Gao Xiang <xiang@kernel.org>,
	Jan Kara <jack@suse.cz>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-trace-kernel@vger.kernel.org,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dave Young <ruirui.yang@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/16] Remove PG_private by using page/folio->private
 checks instead
Message-ID: <aqd2N1J3ui1llWWG@casper.infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD21340003
X-Stat-Signature: tzm4y6touopqonxwwqm9hwee3zaqkdte
X-HE-Tag: 1789359697-259553
X-HE-Meta: U2FsdGVkX1/dXxh7M5WIJLLa32hJEKA3Bkj2PyABIQK9LVHFq3IxLh7aXUDdvNVvbz60Iglye/+2HHBlhLmM/AS+dTQpjMI7qa9PfyEFg17rCTizSJrZSu6uetRQI+f3ghVEYCnugFNBMyuXCGuqX2RIeWNyfxp8gviL04gWfcJDHUn27STW7Nk5zh4lJDwUm+9QLQq0lcDCO6u2uVBjlGwWCXpunc3bBu/cB7REru5XqJ0Qb+WaOdkVaMMyCXV0ov6P3gV99d0XcRQGKo8uLmNBZ+wvOg5fXuZrQbQuqi8ZqZcfMvidLSvwxVjurxBE52uABGn7vq7Nu743nZ4gLO0H2c2QZvT9FNjr0cQR5k7wbfWYonEn74B69Q/jN50XMEoGkL437TM6PCrSBspxKTvSbYpKiJbhxWGrzzP8Xotafhm44CQd46GyL8117dgU5upy2EDWGbHj4HeQl9HdVoJCRVFEBKtpiZxxT2bj16oKRPjYVtEmtAV2C9SmMemQx0pbr/H9y+ERmKvAVhcYiaFL195G4JudCBgmjDhEOoUN58LjF3S1Jr5k/wgguWcwCFhjy4wHyaydSqKL9BPOkh2YsdQiWAOsRR+9YXNOh3nWZVibaayq9wLSoOzRftlm4g67alla2M8ehLmtz7V5zmdD79wbaqogWMzA6oJq0UfXYr7e8SEArjuPPC4NONIcg19OU2D7TWwwT45AFWjmWNL+jO14Q40YjMiFTRzfsuJsazCfaDMoZlhSW0LzGxYF5ob1K9nQuOV7pEq8krymM1tuBv1WjOA3q7kGyedAUmr+4X3kYnwjOMa8hJ3HUPhbqtRHrNE80kgDbQuRY/bCUcJTeDJHLPnltarC+fpTTu5nfRlmY9osKi7gX1Zo1vcW9DLGufLzjkYdKfbYjpp4Pf7AklkGW7TKg9kRTCYTdCY3MMcwx3x773flyZMoZrv+JZyohTjS/fERSFU+znj
 4djAyLGl
 +q6+bgPkyuYEt+p1yiQP4AfAobPetnxthFl6nQSwiERX3BhKo260KQ0icIVx7TLaLWH6AVBYslkeMBI3SP0+rHTUcRvUS7UyCeIAaRxDh1GvM7bV1/kmDEtHyIRx9cNnn5W6XuEnvJE5/j60gCjxvLZvE8HBjyDeGCt8v76eofrDZ8IbrMrsdo5K7Z9kO8huoSnrXkDWqNidHQzCKAlHuVbwMrrXl1yPx+k2n/t5NPKQsATinofQCsbyAQcV+eBw6YngcokLMhZz9m7z0KA/mJ8uzqoMs109IguIH/4Pk6uSS79kkNvxRUNrpDRhy7gASGWyaxIUqVdHFciktxrMHBMCxlhPwNcm/ZnAnygiQNIkTfhzP9T6Xj/rtghidCw7/JkV8XtODcMhLVLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 10:23:58PM -0400, Zi Yan wrote:
>       md/md-bitmap: replace PagePrivate() with page_private()
>       buffer: replace page_buffer() with page_private() and delete it

Sorry, looks like I screwed up git send-email usage.  I'm proposing
replacing these two patches wth the three I sent.

