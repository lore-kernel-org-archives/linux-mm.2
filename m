Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3182FCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B4C6B00DA; Wed, 13 May 2026 10:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB8B6B00DC; Wed, 13 May 2026 10:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB726B00DD; Wed, 13 May 2026 10:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 290036B00DA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:44:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB14FA017A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:44:26 +0000 (UTC)
X-FDA: 84762667332.18.AF74FFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3920C4000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:44:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0NFZoao;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778683465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJ7bRiHKS1Kb1X9Hv1sdAAonfiSS3ixuaEzwGiHqIoY=;
	b=4SLsTXdkRLBo6sQkVYXGZiec9cX0QMHuzeg5OKpkfnzDywocteF4RnVI6JGADkodKrcmVx
	n1HVAJO520nyZcMfyqyPV9NlWAIyYRJj8qWyOPoIGbeMbqJdQU4+F+ObGrJbL/cCXaQMhD
	fNzIXU7dJuQwHpnxI6G2iMHwby4uEc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778683465; a=rsa-sha256;
	cv=none;
	b=N17MtDwusC7njr8deF+yyf4jiGzlBPM5YSjI1Yxmv4glyHu7yYeDblg1CU+HeHfi7MlohL
	XRW91pvXCmOEB0OPhh61SmV50K1gym89Gc+sxZ4Z4mP5bn5vV4zGL3dlmwZX180y9++Ir8
	HpOW5h26u9RZ+qmoR7lXdWCbLUGdSeY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0NFZoao;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA6940D93;
	Wed, 13 May 2026 14:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00750C19425;
	Wed, 13 May 2026 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778683463;
	bh=ig7qEY61qWpO2qqxgUl9QTZ5VrdTBw85h6pXPckbh/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h0NFZoaoDh7fQdlc79oCfhVnXSN8TcLjFKXCH0qOYZtKtmxbwhWEdcXJjBhmTE2Zh
	 KSdaZwyh3Rsnk/b14AMd/XavhYhWeV02x38FFxIM2xQOZLXj8/VcMm6Yterb8B7o5y
	 uhWgyP2i3xEXrwfLLmiPxUrKajn34WJqy529q3Lbzg44AxEwCNByiZlTPl4RJJ9Exw
	 nzQiEqRv/LJ4NAwdsQvmOxOmBb5kub03GMIi8lGXp8jFMcFY9qVNAP633a11TBWy8n
	 1Vs1lQYKWio8VdJgVEOJhTrkoUryhTEsegcqfRXzg2QHvyji7eN3JiFwMZX/CgVxhA
	 Wr48RWKY/YRNA==
Date: Wed, 13 May 2026 17:44:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: introduce for_each_free_list()
Message-ID: <agSOPdfyEi1jCBvA@kernel.org>
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260513-page_alloc-unmapped-prep-v1-1-dacdf5402be8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-1-dacdf5402be8@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3920C4000E
X-Rspam-User: 
X-Stat-Signature: ryh8s7n7k8pe43m3wafzcbuxctujg57k
X-HE-Tag: 1778683465-874466
X-HE-Meta: U2FsdGVkX1/U7+YQZW9pXi7j6J5ll8fOWBvtJtrLpm+BEPsw7wG2rHJVX3NY1TC9vvTBm1yCfAlLiw6fB5BfQVGssUclIA4ZsyAPmFso3Krx9TTH1TsrFwNTikwm2YZj50QkGhh3CQsNjO79I36mnRlj6FlJ+DcgHfYs5Vo36YBxNN/pacAkLfZMixa90SCdt7Fcuy6kSV//lhZU4LxUc6SJ9+IjgWsCGvbWSAij84TjWx/UTEQ117pndtuNJR/om/A9KeHyp6ygieppxRfY/1pP7PnndZmMLL9rOPCn86FazAwkV+upX09FOD3ycadU5+SVf1GkHSS4XWMn67DG+tS9mIMPBd1ca2TksA7/r0sVlDqnSVwuU81luyitJTEc+jjxgYdSDQ0RESK3+xxOs6PbiFvhPnLeJcLVb+TsExFcT3GjIOny7KlDO61IaiczPY4gluoDgLhzh3klOqi/r1mh69i9zppUmlK6N6KrrZeLebxWFqCrV2M9+Id70kd/HgThb0RFcVTa4LoBtLcaGIGUk26CSBdlFFX8Qlf1dVbq8Jo+niQTokSrmF7gshFSzAQMn7YNeiU625cACzRx0OSKUraNTNbZFP+70lLE3uZDoV1xts3Tq2eLnPhepwThx6xEJqw/z//5ppSFWucGjMVZPyw4YkkVd2HQQ9t7QdxiTxehBkKIV7oheU9EOykew1X9lCt7+ZGgfRJJQLvP2ofCRSfeASJZ0AmmgPY61qjkeDWmPxzXltphM7be4ad8iSvpX/RxAPvAcfzDvOfcOKwMAa7byvOuswHNtj3lYKOnGYEnkapLj0ziv+XjRnb154RpogTeZBJrHfcmmxOvgVs0rNKj8ArQZfnn4i3GrwrSsfe+fSqnojLwwmVy+gtzjP8kmvpKZkl9YWCxeL86Znm7wton5Xh7uFT7btgKf9Ywgqu9V3CxoIaI+rYzxuovBPMRiSljs+pqwKiM+yH
 tL3QCy9T
 2/1BastlA/Gsn+O1OcLN21IZZEFy+BJx+R5Wb0E9MNUzAJ9pClOnbb71g57vDQ1hEwDTlQOBb0IgPsrEJZJ6d6/1dRc6Tf5w0Uzhkof1AbKy0rk3eVjR1tgdmiiM/vwkXVvKfKRpy/DcLbUCiZ9fgNrGKqsTbuOtwafVSIR2xGQSsO9ZTrSzBk/aOOMDZtmpzdrdHRhRtoExt2TxEOeaYBhAVDd2lLfc4nUULFBG6R1JlHr1bucrDGrmVg0aXTlMKMamkMrAmxFseJDqHfl4j3hcBzO4wQJKkYx5Gi3ljKpZoRrZ8y/MBsHa+8+fByV1K6l4TNfYXBbpEn9yzzqCZTjbk27zgV/W4s6Hx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 12:35:13PM +0000, Brendan Jackman wrote:
> There are a couple of places that iterate over the freelists with
> awareness of the data structures' layout.
> 
> It seems ideally, code outside of mm should not be aware of the page
> allocator's freelists at all. But, this patch just doesn't hide them
> completely, it's just a meek incremental step in that direction: provide
> a macro to iterate over it without needing to be aware of the actual
> struct fields.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/mmzone.h  |  9 ++++++---
>  kernel/power/snapshot.c |  8 ++++----

looks scary what it does with zones and pages :/

>  mm/mm_init.c            | 11 +++++++----

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  3 files changed, 17 insertions(+), 11 deletions(-)

-- 
Sincerely yours,
Mike.

