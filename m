Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D503C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654846B008A; Mon, 27 Jul 2026 12:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605BD6B009F; Mon, 27 Jul 2026 12:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DC06B00A0; Mon, 27 Jul 2026 12:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2B16B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:33:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99F6D1A0129
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:33:26 +0000 (UTC)
X-FDA: 85035102012.01.0A7115C
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id E43E814000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:33:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jESuRiPo;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7p+ZCLHsjU7FD5y18hGGBqxYxk6OAoh5PtbY3fZhP8=;
	b=NExBRAkqBS8mhQEMtPrm4OpN+ZsaSqzCjQ7e1ew8VUybS2OeWOh253msAgF8BwdBc1STz/
	Mm5X7VivSwEtiNoY7YzYoQnC3tkltOFjl+4vjLFcrsFxckCcxOhJuwf11OgmerRzadZ8Ud
	P6TcgKzJTVE5bWKrQLlhR8vXpuUccsg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jESuRiPo;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170005;
	b=J7TaL4RFR//ovVm8Q56mp9SxktS3X5AVsa/ySaxTOqYHZ2P282PopyDNTbG8iosSmt0/HN
	xNf22V3r8Y64H2qm7pkDeCauyO70Z3mi0Ffmklg0hrwpJAchPiViTdwqnL+A9JzjDFAlcO
	WKoU1otO1cl0PCOG6NF8skrM3i4zS0I=
Date: Mon, 27 Jul 2026 09:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785170003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7p+ZCLHsjU7FD5y18hGGBqxYxk6OAoh5PtbY3fZhP8=;
	b=jESuRiPoeVX6ZNM15A2AjxXrgXIRlQ4VOn4ctaxD104FNGt+l6AjMpGCxkwBBsxegyj6WI
	7gMcbjV7fXwcVJlsYA3khuDEyTcYGf7Qy12XYsOWLFi2goTz0wp7PoKQajOkyqxkHweLbm
	EuqTmYuVzACEx2Ew22SU6SUCuR8ejvI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file
 vmstat counters
Message-ID: <ameIMBqJPeF-Wi8J@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E43E814000A
X-Rspamd-Server: rspam01
X-Stat-Signature: goxy6y99kq8xneapicsksftcb1bxs8kf
X-HE-Tag: 1785170004-297749
X-HE-Meta: U2FsdGVkX1/t/gZKvoeX954IlazMpPlOtZ1HTvVsjRs1xGmSYILKkWYJM1p1Y4JRkGYdZYwCQSICpif7WNOq7do0phIZSzXLU11/FGFFRLm4q//Kc1nC+vN2tpKP/XXGspOxm9yDgu0rJuWldAAynkZFXiDFZFFcb3ogQS3IDP/hjDY5WjeMp4tZQwIAvy+zDSuKi3i67Z7qWYx1ZY9j2ZgLzz/uoZ8g5/krxH4Pz3Bk0+QxovbE3UZzogNKm8by6Y8YMzjQj737NSkiaOpLFADKyvAenXk04EeuRHPeXaB+YJjbGUxem03jDMS9KBG4MllQCvmm8919pf9pMGCKY72/ZVi5rIf2ySMIk/hV+ZiS02LTn/EwGQcRibuLKxxLIj/VPiyhEkY4kyM08ao8d3ghrE5zxPWnF3RDjlY5Opk5oc1HqViTI/InKEpLZ1hymoRVfxy18Neqlj2/FuCu/uoM31HG8AKZRUVOVnFp6RGsv8xeR/r1j9IVW+TexDK7kFT+nLMVfwGRVUvpXYXQGJ+iMiFRwCdxRebPvatsxldhiJzQv8T51SsTk1Psc0BsiOo+1NVXXmvK7rQrjQKkKcnwaAAWvDO2/fxNVgR030n9vUuS9F612WTM7pxGA3TZrr+j3I8zm0Xs7CncQBg0ltn3vflRBRoL8NfD1EOp6DFs4zbKLBcDUGwTANOxkG6qPDY6g4vQVMa4Z5MgOVwBpov8CnoQyo9dk3GiBg2tJQwTRqREoPiL5incFC9vpnLag0aM9XMY8X5E3ZDuwYimNyN2VM5km+AjExKtXLCXJxAXdaNgM/6G5ji9rfEW8J4gIJ/b2MaeNTof60qm7NWIq0a1sqvDDd2ovwJ4YhdkfAmoXJjKRv1lS4SgIW1aSLxUa9ypvefhY8LbtWUrAk8e00RnYY+mi47HJSIoayn+FpqNDJYkHNGyNtQv6I/2BGTeOm4yqS5VWYkFfVNW9Jy
 9zC5Zv8e
 147mvOtXklx+lDxX0ZlGKv5qshs/EhXt0j5kDTWvMHiZeUSbKT95CXFIRarZtCsX9GGoQ/mi/X3sPLwG8GENMCELfl9r4IHGpwxNbmj2+j2JqeSBtMHVtbRs5LJQUjtCogRmhOnWCLgu8sv86b3ODS3D4E2dEJhHW+8DwPqb41w9Pyni4nLQGxMn+cyJgPrE3QpZ2rHbz+CLw3sgkFx3AQMqmf6OjLXN7HO3S8HY6aVhSv9WZAnLcZG04sS2s7iEwGL/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 09:23:24AM -0700, Usama Arif wrote:
> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

