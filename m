Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D9ECA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023A48E002A; Mon, 25 Aug 2025 10:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D9A8E0001; Mon, 25 Aug 2025 10:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A378E002A; Mon, 25 Aug 2025 10:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D70428E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:12:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E75E160425
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:12:37 +0000 (UTC)
X-FDA: 83815470354.23.5448CF2
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EE67140007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:12:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756131155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=49MTJGFyRUZMIarY535tzOdhHQwpBeJkCfWMZX7Ht/c=;
	b=SPTcA26HtNu1Gp6fRd63RFAQiS4n4tuC7Ngs53IMrsEmXYg2jDy+BAwpeyKyNBkkAGrHA1
	VoOZEeowj3KprlAu4hOWrP7zndhkIJeI60G0LftVeuW1AJp5Mja2m/AFGd+v+7VtroAuok
	AxsUzanvPREfEGEgA5zeHIhcD0Kl1QM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756131155; a=rsa-sha256;
	cv=none;
	b=X04mXtep/eWFGNMS5P0fSMlFnXB7J5G+vXSYWEYutq3bgaWo599dM2gyJQP4fc6uHalajF
	SdRtVMYzFk6xLyYLYSX8m/g//83pFZ1YF5mEjvEbW1KbATQe9fgiNS6hNUn7OxvNwR+4ZX
	3uO3ZuulS6UszhcvjcltYYcvrA3e+Ek=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4c9XmY4F8LzYlYVR;
	Mon, 25 Aug 2025 22:12:13 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 22:12:29 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 22:12:29 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <lorenzo.stoakes@oracle.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <mhocko@suse.com>,
	<mingo@redhat.com>, <npache@redhat.com>, <peterz@infradead.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
Date: Mon, 25 Aug 2025 22:12:24 +0800
Message-ID: <20250825141224.2108-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <c2b5c573-c0a3-4063-9a79-d3b06a615fe2@lucifer.local>
References: <c2b5c573-c0a3-4063-9a79-d3b06a615fe2@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1EE67140007
X-Stat-Signature: xa5gwekmk6wpqcp8x68xejrcmq1skw1d
X-Rspam-User: 
X-HE-Tag: 1756131153-730763
X-HE-Meta: U2FsdGVkX19B29dlh9umQ8yG5xbfkwNhy+tNEfVQx4cPq8X0q6YMp63cd70jPIpDjWZ2/uz7t6xdTl0ZmQ7Lq+ZOSadkp2YBjNp4H2jjJcG8gZvACozM8F4n/u0NCb1HGwDTXLm4yKu8BTeQpPU47os4vwcTf2NUrgBQcTzT12nHZJj6eUTNikjhuvvWQdNDyQO65Y9KAb0WuDbQqZbVDuNVMNy0wFZZXMvEgbR6uJxmVye+0Y7gU7ACpmon6Tji4NJUf3jpvo4aMHILFKoquy4Y/+GHbEYkWKgAxJXzhPMUMbLHOEZuM/OV7Bgp42DYuTc8CglqSEkrYwlSto6DP9hG2KKTiRxFyJIj4/biOu7Teyvf+oIDvMdI461TWp465QqNUelcF0cCpzoSVN/IyO0byO0aH9eY0cq+lC8VyY4yUaXqbAYoOBBmL3vzCG2h6NfEKMpE7r5Dv0Q9HwkrfEIhElDta0251wuRD+I2rV40e0WaHUROD9dmNKE4ic33YXOie6nGtwK17/g2oZMp5dwSfkAchmJQosbxx3+X9X/VXrZCl7gzqvWFPb15acDzgFfsHAYhefRD5CcvAr4YZnj89qm+3tGODRCr2/VCNKJ2WrFRxWS3kyasO0xweHfUP7QSQN/RW5owbuA31o5CdT7aePTb8Wol+2mbsLf+5buxh7SU0bkltRNitmgEOyTzQzBicj/2jMxSi/phqHs3KBniBaD+2tXKezlnH5jK3clydU2ak4aNu1NQZy+RLCTdutSzTWT3XdxWzKM+MZVuUhB+DTUlfVxM6ObeE0HHjqrWD4If3+YUAq34j2O4AqnSVtFqyBt5eniyLIkHmtU3by5vtHCEsBnJP/UlOmE8tzod77mIycZ4ZLwtfUxVVA/FuBi4wEmlg9gYy2XE/KvZxAgv/5EVrtKAuWxJ9hrJBntweJingo1YYHzmAx2ggAeDrbCttfmXtVwab+Ek8x8
 nduy57GE
 570PhjBsWg7x4Ol6h1EdHwSZXFHiV5F3fa2vwzCUkLeRWo/Y8CAHj7WHTUknfhrFriptMi4JsVvpuyPwx/cUSjG9xrD+9iIIaTwQjxll9334Wa5pstXOM1pfoeas+YSCFrHihT9AY/COg93slj8ffFVDu1ydDDlJwZxx+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > |--99.74%-- oom_reaper
> > |    |--76.67%-- unmap_page_range
> > |    |    |--33.70%-- __pte_offset_map_lock
> > |    |    |    |--98.46%-- _raw_spin_lock
> > |    |    |--27.61%-- free_swap_and_cache_nr
> > |    |    |--16.40%-- folio_remove_rmap_ptes
> > |    |    |--12.25%-- tlb_flush_mmu
> > |    |--12.61%-- tlb_finish_mmu
> >
> >
> > |--98.84%-- oom_reaper
> > |    |--53.45%-- unmap_page_range
> > |    |    |--24.29%-- [hit in function]
> > |    |    |--48.06%-- folio_remove_rmap_ptes
> > |    |    |--17.99%-- tlb_flush_mmu
> > |    |    |--1.72%-- __pte_offset_map_lock
> > |    |
> > |    |--30.43%-- tlb_finish_mmu
> 
> Right yes thanks for providing this.
> 
> I'm still not convinced by this approach however, it feels like you're papering
> over a crack for a problematic hack that needs to be solved at a different
> level.
> 
> It feels like the whole waiting around thing is a hack to paper over something
> and then we're introducing another hack to make that work in a specific
> scenario.
> 
> I also am not clear (perhaps you answered it elsewhere) how you're encountering
> this at a scale for it to be a meaningful issue?

On low-memory Android devices, high memory pressure often requires killing
processes to free memory, which is generally accepted on Android. When
killing a process on Android, there is also an asynchronous process reap
mechanism, which is implemented through process_mrelease, similar to the
oom reaper. OOM events are also not rare. Therefore, it makes sense to
reduce the load on the reaper.

> Also not sure we should be changing core mm to support perf issues with using an
> effectively-deprecated interface (cgroup v1)?
Yeah, it is not that appealing.


