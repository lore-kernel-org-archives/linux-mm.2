Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B427CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753BC8E000A; Thu,  4 Sep 2025 08:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7045B8E0001; Thu,  4 Sep 2025 08:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619E48E000A; Thu,  4 Sep 2025 08:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 499BF8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:24:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D79C5134022
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:24:50 +0000 (UTC)
X-FDA: 83851486740.16.2F794F0
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8070418000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:24:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756988689; a=rsa-sha256;
	cv=none;
	b=SdUsfnM8FZaa6/Ibw0q+Ssn+WDLVhj6GdPyHOIZLgq8VrihaYWtt+VZnHx0PtQ6YwsY1DV
	63LMbkiWS1B7GdUmAv5PQOGZz5vzVG/dGLsf1sva6B86L+iBd9mECEvp3e6Kx+HD8qHoc0
	50I8ONUr6F8RmL74Bxabl+I/HxBfiMs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756988689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjF+V9syur5wRrS3pnRVAy9cw961+AfI5XG4rssZPQw=;
	b=a8KESgFa/aFEpYxQb2BaagzRWy2vz254OV9/O4ORH7Tc2arrf8I0Ao9Tei1K+oyO3mzl/s
	brObm41LEAFZFH5Mg16qMNSfh2E2AXSztF836boUC3zFl3vx7Oah/vh3bqUI1lHBKTW52S
	UMzNWeOaOf9/shwYjOpDaxQCVEDQOL0=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cHdvT1XnhzYlNNF;
	Thu,  4 Sep 2025 20:24:21 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 20:24:43 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 20:24:43 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <lorenzo.stoakes@oracle.com>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Thu, 4 Sep 2025 20:24:38 +0800
Message-ID: <20250904122438.22957-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aLg7ajpko2j1qV4h@tiehlicka>
References: <aLg7ajpko2j1qV4h@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w011.hihonor.com (10.68.20.122) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 8070418000F
X-Stat-Signature: ic98udcinbseouhp976prcsfa8b8yzm8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756988688-861571
X-HE-Meta: U2FsdGVkX191Gb4zOp8rq9eR1G0+x414b3b0fXu4TUfTDAPHHWQwN6Ax+z3uaChel6XZpANtnuJeTt9nEKpLgvrVe2nfOFKLs0+ljISjqYtAc4gVNdu/We9EZgircdW34hDz56pDSACYQuHsguP0EuH3zVocmRkwGRS6HOcyM5mK4TE0O/oobskzBOWHIFfaDjdzbkT/Xfl2Ma65+3epoYKvd1nuVh/pTltA1AG5A9PQU1IQqEqayvInDl/+PL9TbA/6IOmI/o+tziN/MTyeSdA64H6aKKgfVSLm9J1vY5L0LkGf+7WtSqVvKAORZXUqRtgIZ8YPLRe4DObU95dccq0GIWFXB8t9Y1F44o5tx0AHj9iQJSQb3/WwoKy9iqeCTPE7NrphbxCWy+EZ20A5oP3jodE0EiA8fJMS+6hICX15i7EXZT1cudbpFMX1b6KDG1CufzSNKFncemKssd1M/e0LJbqR8U7Tbs8iLJnJmVft+1e+gqFZ1YeJ9f5FMxAJeLxHYre/wflGM9NMuUvZ27GYG1vn3PyOMySyZdux7+S8glDSrQGNDmVlsLs36L+r94IH+8yn/baucyAiuq8slXumaheFE7trmFKSG4o4sp/ALgTqHfCuuofITw5CiMpW3EixiNpwGfADqgc41zgWxQECV4IPtLEsoJrPxYAqJiYdixfRI27TuKFMTWzHMQdT/12/K4jFE4rE6WyE2lav0yOMYbrnJrAewMTWlTK1x3X/AuctrXQQpys6mtYrKc8w4XnTCJI5AXwmyZGEC1z1owkkBWAAU6Lei/G4+tbgPABrexrIS6NiXFAe2rOnPZJVB4N1oDDAmWCA6kx0HbLEw740qdlREzlKpeX5R2mj0rVWmY2b7mJ5WsFNx+m2W7ly
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed 03-09-25 17:27:29, zhongjinji wrote:
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
> 
> Thank you this is much better!
> 
> > Without the patch:
> > |--99.74%-- oom_reaper
> > |  |--76.67%-- unmap_page_range
> > |  |  |--33.70%-- __pte_offset_map_lock
> > |  |  |  |--98.46%-- _raw_spin_lock
> > |  |  |--27.61%-- free_swap_and_cache_nr
> > |  |  |--16.40%-- folio_remove_rmap_ptes
> > |  |  |--12.25%-- tlb_flush_mmu
> > |  |--12.61%-- tlb_finish_mmu
> > 
> > With the patch:
> > |--98.84%-- oom_reaper
> > |  |--53.45%-- unmap_page_range
> > |  |  |--24.29%-- [hit in function]
> > |  |  |--48.06%-- folio_remove_rmap_ptes
> > |  |  |--17.99%-- tlb_flush_mmu
> > |  |  |--1.72%-- __pte_offset_map_lock
> > |  |--30.43%-- tlb_finish_mmu
> 
> Just curious. Do I read this correctly that the overall speedup is
> mostly eaten by contention over tlb_finish_mmu?

Here is a more detailed perf report, which includes the execution times
of some important functions. I believe it will address your concerns.

tlb_flush_mmu and tlb_finish_mmu perform similar tasks; they both mainly
call free_pages_and_swap_cache, and its execution time is related to the
number of anonymous pages being reclaimed.

In previous tests, the pte spinlock contention was so obvious that I
overlooked other issues.

Without the patch
|--99.50%-- oom_reaper
|    |--0.50%-- [hit in function]
|    |--71.06%-- unmap_page_range
|    |    |--41.75%-- __pte_offset_map_lock
|    |    |--23.23%-- folio_remove_rmap_ptes
|    |    |--20.34%-- tlb_flush_mmu
|    |    |           free_pages_and_swap_cache
|    |    |--2.23%-- folio_mark_accessed
|    |    |--1.19%-- free_swap_and_cache_nr
|    |    |--1.13%-- __tlb_remove_folio_pages
|    |    |--0.76%-- _raw_spin_lock
|    |--16.02%-- tlb_finish_mmu
|    |    |--26.08%-- [hit in function]
|    |    |--72.97%-- free_pages_and_swap_cache
|    |    |--0.67%-- free_pages
|    |--2.27%-- folio_remove_rmap_ptes
|    |--1.54%-- __tlb_remove_folio_pages
|    |    |--83.47%-- [hit in function]
|    |--0.51%-- __pte_offset_map_lock

Period (ms)           Symbol
79.180156             oom_reaper
56.321241             unmap_page_range
23.891714             __pte_offset_map_lock
20.711614             free_pages_and_swap_cache
12.831778             tlb_finish_mmu
11.443282             tlb_flush_mmu

With the patch
|--99.54%-- oom_reaper
|    |--0.29%-- [hit in function]
|    |--57.91%-- unmap_page_range
|    |    |--20.42%-- [hit in function]
|    |    |--53.35%-- folio_remove_rmap_ptes
|    |    |    |--5.85%-- [hit in function]
|    |    |--10.49%-- __pte_offset_map_lock
|    |    |    |--5.17%-- [hit in function]
|    |    |--8.40%-- tlb_flush_mmu
|    |    |--2.35%-- _raw_spin_lock
|    |    |--1.89%-- folio_mark_accessed
|    |    |--1.64%-- __tlb_remove_folio_pages
|    |    |    |--57.95%-- [hit in function]
|    |--36.34%-- tlb_finish_mmu
|    |    |--14.70%-- [hit in function]
|    |    |--84.85%-- free_pages_and_swap_cache
|    |    |    |--2.32%-- [hit in function]
|    |    |--0.37%-- free_pages
|    |     --0.08%-- free_unref_page
|    |--1.94%-- folio_remove_rmap_ptes
|    |--1.68%-- __tlb_remove_folio_pages
|    |--0.93%-- __pte_offset_map_lock
|    |--0.43%-- folio_mark_accessed

Period (ms)           Symbol
49.580521             oom_reaper
28.781660             unmap_page_range
18.105898             tlb_finish_mmu
17.688397             free_pages_and_swap_cache
 3.471721             __pte_offset_map_lock
 2.412970             tlb_flush_mmu


> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> 
> Anyway, the change on its own makes sense to me
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Thanks for working on the changelog improvements.

