Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C302CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EF88E001F; Fri, 10 Oct 2025 14:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755D68E000A; Fri, 10 Oct 2025 14:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6929D8E001F; Fri, 10 Oct 2025 14:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59BD88E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:30:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A656B97A3
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:30:35 +0000 (UTC)
X-FDA: 83983045230.07.87FB844
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49224120005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:30:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7WA4es9;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760121033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFa41gSueEbduqRqe7Clkg9TcBUHyXpOyQKvPNeTGEU=;
	b=Md7B8Y41fBUNeVOk0GluMSCKtQaCoEug4WAnwM6icy4Y5MpnvsR6dsOtlGFg6ef3qSMZh5
	8gU2tyT7DjOcyeXh2Y59bFe2+pKUl1nh+M/EIVJzOpEvBTTaxh6YIJBWr/H97mYwyhXd6O
	l5csq/U6NSQSqUhZ7mG6jMwn/VJ8XRY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7WA4es9;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760121033; a=rsa-sha256;
	cv=none;
	b=aewvMFQaUzA2wRBh4T2x0yRn1xuxg476WfDFsqCj2RNOHHSjUxMKY7xfzBL1I6KgAmABKz
	JlM9eB59gXeUt/4VJevImkxpQDwKgGwdqHBpjlJDgsviXJrl55uudmcfFWbTLTvkLUONXm
	00V8ggmuHlFtcXlGlCbkRWzVbPhfc0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D22944E85;
	Fri, 10 Oct 2025 18:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0724AC4CEF1;
	Fri, 10 Oct 2025 18:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760121032;
	bh=ZOZnVWbV81iSXnE0N2FIQPShPP0gpWUpU8VYEUonzrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7WA4es9SynWyANpqnqALfOUgPoQ6uML85h6viExq4n23365KY2PRssrh5M6AqSJR
	 YGCdBtQdoYaCfnMX+nTFvkpqQVuPVm9QqenbOR5jA9ljOHVrB9tLLLnjkDisBOM9GU
	 EIwWD5+GVOhgF6PmE4Q6e0MQMvUrV6jQYdQkN972tFI25gaRSXn6ffuG62UiEtd6X9
	 iVzrW139Tr+Pobrtuipb1JgVpkFO+YAefhggCiKD+JLz+/TYeEwn8uruwxzcb9Wmez
	 ZOT+02GDcuQS2n8G+8mZNXW2LjIJ5hGvXp22SwnWDyBn5t2PJSuS51e+9Bhj+VGsjA
	 M7tzh6PN6uglQ==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/3] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Fri, 10 Oct 2025 11:30:29 -0700
Message-Id: <20251010183029.68434-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251002204636.4016712-2-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ox8msbwdwuxcn8sfnqccxyb9rq9jupmd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 49224120005
X-HE-Tag: 1760121033-976484
X-HE-Meta: U2FsdGVkX19W3GKSZXMtWZOz/4N0X+XCqmuB3bOwHKHPbrsxUjfwrX0rzaovE/21w2SmR1Lyhz08zpZ0TOm29Kwdi1tJ3bn41M/eZTr6A6fV+eoxYYhwMhn16H+P8BuENTFLvhEk585yqeqPcv0TZk8MI9d5FX2GTHtJyglL777s17j4kq2v3aageIycQdxIR5pEJk9mCO/0lV5Txd9mzL9nCTW6pozYGaD3hvbCGoh+sqW5H5QwApTNhjOkMWDTbVqdjZ8SAjk0g82vV6ShIToEkIH63XSMcMzIXM+kufUDzZvFLAr43nPcvUEx2JQo4yV5WNo7Vno65FyEeAOj48fSbM2OqJE7bFIZGRiRduc0EEW7Al0so4j57Jzqveasc3tnVUFQlWRVgnZb55QI/qQ1rpQ1gCOocO+xYfjCgpR+yW2pyqtW8x0q2pMupO7sxHSid1AhIPkW+muIU/tRcFZus4dh/EYkj7zzLNxQonT/++hSuAtyLdxVZ02aJ1EG9kOVVXGf4kaRsz4cUeeRfc1ocWBYiavnkTIp4wzvyUuIW0swpYUv4bp6OqJEcETqVEm0vkCDte2U/FzftztW1XjV/ZqPLhWwwx68d9traJYos/OYZ1nnEWaxOhdzaGo2yPAkslJLOPnnry83m733X5hBpc80rRxV/fSx2wEGQrmKsYUXn9x/Ey1t6peGo19w25hrIB+szq5FE179ChodM5YfhstsB+TFEgbBYZUUxCB0cNG1RkbZtieJB518RcyHDLQF0DtM3fvcBv8VoYvZ5z99T4z5dyEDOEzaXQm+JdUBXtJx/zjurLkC7fUvB/D5doBrjZGQY647FTI1X16oJ2ovrgqf2xK8I382oiBt7KtwhaHRhPFMlr4U4oKO+QVKWx1C8RGT5KmT7rk1G0NQqJfOsKTZXALKZnwLCob1LEByz6fds9MAaO5vgu290Nr8X6MP1cyodRFRPxGd6zf
 jfz6Rh7t
 rC6kfq4Z7MJo01KJwgaC8ktmVwRTfbZ2qVyMz91wDGZO1YKh0jIJLOfSFNbb0IAQREOMJMru/Zxt97Zl4/uZYen91pUmZkT6qfIUWB6f89B4kYQgqJSfu+4xfvsUO8JJI4IAnX2rbn/ClWFPhHt6F1vXiPskfOUDCCjSojT93EKvb7x2Koo856qoiR3bCgUiuQZZ8thrX8UI2/hAtZc7D5MOALeZFmY5ZkWVPpc9KT4wlkKkqxqceG89VWCQ+B7jUrako/PqntfI+dAYhlmPCbSCnQGDtzmrmPwZpJYU/gSYMLJNFEoVNrnE8t5T9FolJGFarKthf0f2pz7I7muyEkv4T9r93bynTDNDZ9KCqf7KLX1+fOy7R6wuRrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Oct 2025 13:46:31 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Currently, refresh_cpu_vm_stats returns an int, indicating how many
> changes were made during its updates. Using this information, callers
> like vmstat_update can heuristically determine if more work will be done
> in the future.
> 
> However, all of refresh_cpu_vm_stats's callers either (a) ignore the
> result, only caring about performing the updates, or (b) only care about
> whether changes were made, but not *how many* changes were made.
> 
> Simplify the code by returning a bool instead to indicate if updates
> were made.
> 
> In addition, simplify fold_diff and decay_pcp_high to return a bool
> for the same reason.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

