Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D25C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E235A6B008A; Mon, 10 Aug 2026 23:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD49D6B008C; Mon, 10 Aug 2026 23:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9FB6B0092; Mon, 10 Aug 2026 23:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5FD76B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:40:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23CFD1402FE
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:40:57 +0000 (UTC)
X-FDA: 85087587354.28.966CFD7
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3E190140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:40:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owwF8cog;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786419655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTISO9RnoqUtAb9p7G8hDIEEL3dlWgZWk60pW4cP7tY=;
	b=Eb49H/bO1BvhdB47BgXyyIEcUNYsOG68Euez80s8p+QTUInGr38jzVU1797wdlYpN33fiB
	absDL3zvCsxPlbSPx0MA5xDlGdiVahZsBMtRL/H2YxmY8DOPzKxDvlVaZbIh9Iour6Poy6
	lVBDVWTc7Z0c11s0c6cugwPzDNxSw4w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owwF8cog;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786419655;
	b=yPoD9vvulcIGgbwA9JpfiQjMlV0YgPSIptuLI7aOUly8OtEn4q5u9oDi8951+rCELYY9oq
	RF76NdNFkqfmH3/ND50Yn93lEalIckXA4gA1KpwXRRBB9YnQoMisU0g/XxjUrKHsHCOvUJ
	QUuWaY3ILaP1wF1HPitoKrVNryaXBGg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786419654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BTISO9RnoqUtAb9p7G8hDIEEL3dlWgZWk60pW4cP7tY=;
	b=owwF8cog8cfLuw1hrPJLGKGk11LYGONgrmm2OsRDLqFc6jbkInni2vOgkq1PpKGwO0g1dZ
	amQD9vOLPJUGQBem7OHcoJfRdCQd/qlyAOT2YBMBTcv3hUpvROW/SVH8i23SHWJ4ghg1xG
	jQ+spXhgjcBe3B46I154hXG8vLSRe4k=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260804035535.2846016-4-songmuchun@bytedance.com>
Date: Tue, 11 Aug 2026 11:40:35 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <BAFC9F46-9588-4A0A-BCF5-2A865CC4A801@linux.dev>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
 <20260804035535.2846016-4-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E190140004
X-Stat-Signature: ts7u48ctnhxxpxi8nh3jia6j6de9q18u
X-HE-Tag: 1786419655-131442
X-HE-Meta: U2FsdGVkX1+QSGS95hhwWPi3s9WU1hlxJ0gzrmjIZ6J9X53Fc4ejDBI+ZdCm7+3oZg1xxvt0hig5rmpYlk+mcyty/aE8Nl7xIPd1oF6KdkBKz2kGs8CvdXWVOmZNy/090FQ9aP3kPUGTLlsfGd838faIdw9sjRFyrA3s+8LOuiIZfawq6PoaZeCSizQsy4zD8BQUE6WdUYpSIImGxQ2ciq3+STjZJrgwcWdV1IrHyusCQjEKrPxTvJ7SvaTXwwljbHVQhnDxMtXDiwDiAOmPV8RmRkSFf3R/7v94wbpXlZss7CULwD9Cxxn6G4xvc+6VoybdUo3TYdddy2F1NJpXlIvawFgczkFEAAhK9NBNLu3TJIBrjMU7OMC4mCo5WhSXc8qmj6tB5AhNEd+D+/jytmMZW8UD2MYkOuklHoEZoKtNlVLyXSL1DLZWL/bkkoOovgJ3ZHbN1pvHkYc+HRotPaG+orkPGBMr6rYOtuvGTs66+kqzHsqh/vpIX90Z46W3YVz2eo9lcEV03dydhg2c++UwsHFT/NNMh4eufQLMfjfGpyCkOp1EKKNPEeMAqFE//efPTJtXrTt30lq9ApbuscPHKEI9G6rw5+Pti0MZ1VIl3j6MoqaQ3HEeBmQQadlyITugk6rsjWy7vdM+cgcgUJFYhMbQ6AHlcT3lW2RkbgWNWbQ3Cv7mTD7GfRnYlgp5jF3XBmO7yKWzC8f4VP6XOvQWTcmUCdMUfHBXFCqECwnk8f7y9PNBge2H2n05LHT+h0sH/wjJk5nlmrJmARYi3GLjisfYEz8p/hHWDxUE2KNfZidPPGj+pBKag/WwmSpryn3+qm1/uv7cxnOv8Sd/H92Vg9lf92yu00rnT8CSOXLnJDaUXWG0NDGRWH1oHYiovGzF0weDW2vy/4ZHxroKPkwniRR3vifQCJ+BRFrM0RH6oT6ZrCHXf/C9He3gfNhvepUw5lTTqJNWF3SS8ra
 ykcvhB3Z
 jkaOaZi5+BQO8L7EmRwh8cG2QSMY32laTV7PSPrKd370K4A3BNAnYr2nkQqmLeRHRLGPwATilcReF88N6eqXZrXM/7zNiXM4nPlepK5dD2xWDJ/RIvO7CBRSLrmx+GNvkIRmtnyqzyBzo2L/OAxwmi/3wMM1LYkYgwsfHyTdmBlisQT8dVGv8pXzlGKdgAodqFwPO1wKDU/GZfIdSrPzQOci2F9txxdnwDMILnr/XqaDeml9Ts9FB0k0KezV89zIjfMob81nWEaHB1miiDCsxbh8TDihBhroVh4zP701+Tvjw6Cuaha/4maJbTlqlVrNgikrv6LXVyo2oOqdHbvtQ6LxC7kP3xpg37BIlNVr4l1BGh7q84VOvdOyUHIdjjOj9yc49
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 4, 2026, at 11:55, Muchun Song <songmuchun@bytedance.com> wrote:
> 
> memmap_init_range() initializes every struct page in the target range.
> For compound pages with vmemmap optimization, the tail struct pages are
> backed by a shared vmemmap page.
> 
> Initializing those tail struct pages would overwrite the shared
> vmemmap page contents, requiring users such as HugeTLB to restore the
> metadata afterwards.
> 
> Track the compound order for HVO-backed sections and use that metadata
> to detect struct pages that fall into the shared tail vmemmap range.
> Skip those shared tail pages in memmap_init_range(), then initialize
> pageblock migratetypes for the processed range with a helper after the
> per-page initialization loop.
> 
> Keep direct mem_section access inside sparse helpers by exposing
> pfn_to_section_order() to users that only need the order associated with
> a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
> without exposing __pfn_to_section() to !SPARSEMEM builds.
> 
> This is a preparatory change for consolidating handling across users of
> vmemmap optimization, and it also avoids redundant initialization of
> shared tail vmemmap pages during early boot.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Sashiko said there is a missing assignment for the new order field in
struct mem_section. This is just an observation, not an issue, because
assignment is placed in patch 10. There's no extra action to take for
this report.

Thanks.

