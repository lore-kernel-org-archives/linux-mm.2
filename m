Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CDE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SV/PwDdZ
Received: by kanga.kvack.org (Postfix)
	id 2B32E6B05B0; Thu, 26 Nov 2026 13:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CFE6B05B1; Thu, 26 Nov 2026 13:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1059D6B05B2; Thu, 26 Nov 2026 13:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7C2C6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:39:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27AF7A04AC
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:39:47 +0000 (UTC)
X-FDA: 85478134014.30.4D604E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 815C340006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:39:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SV/PwDdZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795718385;
	b=hn3L6QlhWGbL2sHuQU4AG/EIu7tLHCxgtJ9PGOpMwr9FbiZ5mhxf89009pqnjb1TdDBEVP
	FM12mb9dHHDtB/IC9uJBB9+tGkGv0s1yL36z6FpzHUvXqTwMSlIRlCrT6j5Td7pW5Ad5NI
	p833j0lTLKBRA8zc+o0OUXCbGV7fDqo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795718385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YgMZT03ulx9J7qgm1aKTPY1r170eQ2QP/y8ph676aGQ=;
	b=gb7T6Ly9m5ZX8Vs9jNdouArVl8/rmIYaEeBxs8cSAMCN6vYI3311KXN48ygEXZST2+YEuY
	lU4radJX5ST8fTAc9w5l0tNk6b32IpSBV5f/jA++XopLartMIN6bSSNk6T38DSljKt4gvH
	dJEtjWGIRtwHJLOuPUEUbSRoKTXos9A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SV/PwDdZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F350460CAB;
	Thu, 26 Nov 2026 18:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA4F1F000C0;
	Thu, 26 Nov 2026 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795718384;
	bh=YgMZT03ulx9J7qgm1aKTPY1r170eQ2QP/y8ph676aGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SV/PwDdZMCyCbSnnpfv4+q+fWEiA000+uskuE2j/Z4CGc/sEcC0uvgaE82ZoipvpL
	 dkavz6xXJhHxSzL9JepfDh9TEGdP4w5dEt8h0g0pWqtsIMrVtrdorvSmXORC3duaCg
	 7YeWLUraREwwZudFMJkAXJiH7c2FN5ld69EHEk9s5i+pvuLiyvuiGXJtB6VAbFiRIk
	 YHbl0itOekE/q4S0+vPRKvzx1ZzHpMcrr8i7hQHXMcVnokMKUuwP7T0xSQadqU5+CU
	 ucUCSblS63VS5I9kzoAM+bJ5bsB9dwZBJA3/5Yml7PAxDxE4Lvgp5+TEV6ndVRmUH3
	 FU7zS3gz+csYw==
Date: Thu, 26 Nov 2026 18:39:42 +0000
From: Harry Yoo <harry@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
Message-ID: <awh3A3CIwxL5v-1K@thinkstation>
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <sashiko-outbox-218808@kernel.org>
 <av8GvDahjRIKXUIa@shutemov.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av8GvDahjRIKXUIa@shutemov.name>
X-Stat-Signature: gnw8deowkijtwjfn97dd3fteg761cqgt
X-Rspamd-Queue-Id: 815C340006
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795718385-993943
X-HE-Meta: U2FsdGVkX19r6qJI/1nrcCUgjq2HwRwi2oC7bmza5n9LpeHBHJxRYqTscs+1CicjxYBKVjRhAm05tuNyFJsf/9giOKx/lQlKGUWNu2tDWDfPxlMJGQsOdgiXPlMEkvrxkL6dy/Uiw3aS2PmPtWwHYamV2qXpHP9EkyHs+wHIB4W/Zzdbnwf2mW75vyuueo0zidgqi7P8+6U6342lHyYeuy8ohuFdZYR/yHY0fLJQfn5dHJKM5ga3UE1MBpGQ5mUhDln3CAK6SrX+wkl3wKVHLMHWru+WCQHBiM3UuUi2I4UtgD+NVi/XruuBYupEBytqTFA6l/uKIRdsxaMkKXPKxdmjbTv8kk+y9ZGno8IYwoPtqFRPulFsqh8q5RL/81EXjXu2moqgOMTdZtnVjRtgtFR7ejh++iU+0vDw7+D+hTXQf5ZmtYogmKle4nFjW+RlnvBQPvBi6PksZdIHdxx8iqRygyJJih507YzTnvAhMCO1y6sIIPNDt5KcofJElXpBhDrH/ZfLbOGdFR37lkiPK7aQ016q8qeEv8PPqMFdMM1p+zos5+1XcSLGlga/UA/RA582PVNpeZrpFZiIbxFYkwmlWvXPHuAAXvb0hlxg3+nhQx5l85K71ocN/cGfvGHJAGA02ecURfxEv78gsIRNs6osVodx7K8g+/00HPPuf7RlLRXzB/OpI+tV+3f7yXCuvsnmll+NioYGky4aPViv1B8O9IJ62KRb1DPdo8rjsK7iC0RyPWyYV+0j3P0Rjmuuif9NKXncDW+OXH/mRX2jJqUp3BVvBiVI6MIDLAGgATgbYCdbQcAiUnHKNp1gvLsRbJxTx0/0kDbZwGi7TAunTdih+/SSJjiSVNq+Et3qta/i9+x+ZFXECSBZ/1EsfNq1KjvL8VuOa4xwHvNnCV6QyRVkAcMF843ROyI173uYGMOTMVvpdLGxJBL96ew8h7l3k8J8a70S4pN8KjbfsCk
 +esBfU3L
 s9YAAiuEQsRhRKMi7jdkn0LxiJqDy5jl3go2LMNB8HltZKDiO3ej4nDle1UmOd71yrh6+Clyqa6Y5PXcIv2oRGihQWJGdi8cZZGl3ayUP5K5JMWArz6BFYnUejQtBx7sLwhdRM6oAH1vkBp5+TU7E+a02YiXNuo6VLeUICJEKNwoATY75IIRMmc2Bx3ooRWQoqFC3g5YZOCzHSCZORNdhbb7J717Qyfv7zdGvphJfSIJKJHa8/9iX+4yoF9WXNcJIr4lzgxiXsbDEWyxWfcRqrgNz7Y5G0QA+6NEM5b1VF/TW0ebdebMs5rnLfVcyM4wStZWI2ouVHdYHERmoQzUZDJwV8x8lXTa4VC8S+Pu3vw+eGG/K9UiWS5xCAqAKEuyOGNLpfcaDitpm0PrQ9jdaV6pquiSOBT9WYMKErjvEKC15mHKB+LCis5oAh8UCs8uSrOoLDiE5/RefHlTnL1qm8atoZSXAKfvVEP1DTgv+H9pmsvx5gQaAhxFdvWnkwoaheb+rLaXgPKmqHOl5i7yQ1XD50qn+M36nnwxBMMvltG60lXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 02:25:10PM +0000, Kiryl Shutsemau (Meta) wrote:
> On Tue, Nov 17, 2026 at 12:51:34PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [Medium] mm: page_alloc: should_reclaim_retry() counts unusable
> >   migratetype pages
> 
> Not a regression. should_reclaim_retry() never filtered by migratetype.

... actually I had the same question as Sashiko. It's not a regression
introduced by this patch, but we might still need to fix it?

Looking at the hunk I was going to ask "what guarantees that
should_reclaim_retry() doesn't keep returning true when it should not",
otherwise seems like a similiar issue fixed by commit 4cd78a2dcfb ("mm:
page_alloc: make defrag_mode retries follow the promoted order")?

I mean it's not as bad as 4cd78a2dcfb because it would make _some_
progress, but still :-)

-- 
Cheers,
Harry / Hyeonggon

