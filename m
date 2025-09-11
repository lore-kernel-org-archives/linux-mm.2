Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E82CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 04:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8153E6B0012; Thu, 11 Sep 2025 00:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0EA6B0023; Thu, 11 Sep 2025 00:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6636B0022; Thu, 11 Sep 2025 00:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58B956B0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:06:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9DB1119D14
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:06:22 +0000 (UTC)
X-FDA: 83875632204.19.37D880E
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id 145CE40007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:06:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=T+c3U+WP;
	spf=pass (imf01.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757563581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+ZiXp1IFzinH43Jn6HBGwbQndfUjUiqfZdlX6XJIdo=;
	b=HBb0zDwFTUXQqMjN038VMMwYJYgoo5JrzYcTSvxg6K+qRBK1eAn/tvZe1KWlUDg31dDfpU
	XEXIRPuCDlxcMvR3R5BV8I4p1NCMm75wbKhsDVkgCJMyn9nYwCNW3le6RuxeIKto9YhPXx
	H3eO3upMmeCGQbvunUWlDbYswWC8YU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757563581; a=rsa-sha256;
	cv=none;
	b=JIdG5yTA8QRkcM2X+QSRSAGcx4sxE+rTC+VwLzIJ5prKkiAtv2hpPFjadKvIfD31ED7rYM
	YyiU48rPbh5U6vKKX98bEB61sLxHV7DPCG1fF+2TEGbbViHkyyEJphe76V9E3MhpfQiJTc
	M5fAYXe9YxC5oB0xqB129DZgo7BD5kc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=T+c3U+WP;
	spf=pass (imf01.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=L+ZiXp1IFzinH43Jn6HBGwbQndfUjUiqfZdlX6XJIdo=;
	b=T+c3U+WPfvefnsNsJJ30wBpxcsv2kbWCzFHmObn6AGfSdiSSo+VttGO6OwIfJralUoLj3+q4r
	XmJf+7xJEjt2Ar4kAZ9pJfcfHDORNqjRWgvpJxbf0BooCMeJv7gzACG+HrCj+qHQyEYUbOahAI3
	psxF0XBvtHkBbxPpkzhVcZw=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cMkW81DtKzYl1NY;
	Thu, 11 Sep 2025 12:05:56 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 11 Sep
 2025 12:06:13 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 11 Sep
 2025 12:06:13 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>, <lenb@kernel.org>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-pm@vger.kernel.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <pavel@kernel.org>, <rafael@kernel.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v9 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Thu, 11 Sep 2025 12:06:09 +0800
Message-ID: <20250911040609.6126-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aMGXsenuvA682-Dc@tiehlicka>
References: <aMGXsenuvA682-Dc@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 145CE40007
X-Stat-Signature: 6zar3oqr8ie9xh8tkddbj7d6uhqa14p4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757563579-970347
X-HE-Meta: U2FsdGVkX18LhQuQtPqBl4o55dWIcfTUP1Y6OzUtEuKveQK8H0moUeeK/b8yt5lk4bugV3FLCTCGqwFJU6vaP4iohXXYQ5EC80nfVwR1LeGKLHOde7VexC0CCSENJG5ScKtxRNXGC/MS78BXr8uFeJzziZO//zQ5Z6v5jYYrwSXfcXGTFzkVgZSWIcE6y1BNcBV2vigzXUo7H/miHf0fBcioh/N7frgmIIvID8fmrtweP8TVUCfL77T4cWtyYSQr/XBRzmVs5B+1b08B0EPS1vWlpQC1IyGCbQ7bNiY/Cox3ZUHiqpXs3IaxTlRxeA8bYVyjl0zvnNnVjh9SgBk9e8+KB+PEd5ldVH5vC3Rioa662ek4vCJT5PlTYIG8OE9YbLJrUdvAjUgzqmRgw6y54VRqZ+N7YXT4eaXmiQ3FDQtlPnD9Nr6fGbCEecouiCqc9fzICOw6KtEEV7MNxHb/K5lOl5sWTx+b8IhTqDCJHmGub5pfAevDUFbkisYcKt8J3LnP0EchcLt3gnKftEs7XfVBjYipFOfgG6mnECn5K+fxUjMyolGI+CiQG8nmIxAM+zjjmzebFhySoPpsY5lfQbQi2IQRHPgpK2XLtZXyj40Y9IFfM4SXIyxkYmLBEq0w8Q7nKI5DWq+GFWicYOMHh8+NoJFDS4aa+hfIk4mtxIgRhWesE73Ki/KrrwlWDQtvP6muEyKk9XzsxypszPnIHFbSe8Vod6FuwTBHkOWKHz+1ws8Weguwnl2FxgNh/4zJfGzdSPdxiYmIbsZMJhwemOB+a1oySMrAPlQsLWslDd/GYa1/i5pSOGno2F4KB1ArpBYXPCdiuEX2eB7TndpVnHlMyHmtrsatctBmr9B7jy7UPFSqnJQmCUMlh5oxkQ5Onc+EzZIH4ojysdoGCEKtxWkzQq1/OeE6DNWHL7S1wXeZ9+MIh1seEvuU3XR6sCq4SznOA6Erh2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed 10-09-25 22:37:26, zhongjinji wrote:
> > Although the oom_reaper is delayed and it gives the oom victim chance to
> > clean up its address space this might take a while especially for
> > processes with a large address space footprint. In those cases
> > oom_reaper might start racing with the dying task and compete for shared
> > resources - e.g. page table lock contention has been observed.
> > 
> > Reduce those races by reaping the oom victim from the other end of the
> > address space.
> > 
> > It is also a significant improvement for process_mrelease(). When a process
> > is killed, process_mrelease is used to reap the killed process and often
> > runs concurrently with the dying task. The test data shows that after
> > applying the patch, lock contention is greatly reduced during the procedure
> > of reaping the killed process.
> > 
> > The test is based on arm64.
> > 
> > Without the patch:
> > |--99.57%-- oom_reaper
> > |    |--0.28%-- [hit in function]
> > |    |--73.58%-- unmap_page_range
> > |    |    |--8.67%-- [hit in function]
> > |    |    |--41.59%-- __pte_offset_map_lock
> > |    |    |--29.47%-- folio_remove_rmap_ptes
> > |    |    |--16.11%-- tlb_flush_mmu
> > |    |    |--1.66%-- folio_mark_accessed
> > |    |    |--0.74%-- free_swap_and_cache_nr
> > |    |    |--0.69%-- __tlb_remove_folio_pages
> > |    |--19.94%-- tlb_finish_mmu
> > |    |--3.21%-- folio_remove_rmap_ptes
> > |    |--1.16%-- __tlb_remove_folio_pages
> > |    |--1.16%-- folio_mark_accessed
> > |    |--0.36%-- __pte_offset_map_lock
> > 
> > With the patch:
> > |--99.53%-- oom_reaper
> > |    |--55.77%-- unmap_page_range
> > |    |    |--20.49%-- [hit in function]
> > |    |    |--58.30%-- folio_remove_rmap_ptes
> > |    |    |--11.48%-- tlb_flush_mmu
> > |    |    |--3.33%-- folio_mark_accessed
> > |    |    |--2.65%-- __tlb_remove_folio_pages
> > |    |    |--1.37%-- _raw_spin_lock
> > |    |    |--0.68%-- __mod_lruvec_page_state
> > |    |    |--0.51%-- __pte_offset_map_lock
> > |    |--32.21%-- tlb_finish_mmu
> > |    |--6.93%-- folio_remove_rmap_ptes
> > |    |--1.90%-- __tlb_remove_folio_pages
> > |    |--1.55%-- folio_mark_accessed
> > |    |--0.69%-- __pte_offset_map_lock
> 
> I do not object to the patch but this profile is not telling much really
> as already pointed out in prior versions as we do not know the base
> those percentages are from. It would be really much more helpful to
> measure the elapse time for the oom_repaer and exit_mmap to see those
> gains.

I got it. I will reference the perf report like this [1] in the changelog.
link : https://lore.kernel.org/all/20250908121503.20960-1-zhongjinji@honor.com/ [1]

