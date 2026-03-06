Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24519FCB601
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684756B0005; Fri,  6 Mar 2026 09:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62FDB6B0089; Fri,  6 Mar 2026 09:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506D46B008A; Fri,  6 Mar 2026 09:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 422A46B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:44:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC1001A05FE
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:44:36 +0000 (UTC)
X-FDA: 84515909352.18.5625F06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 221702000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:44:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5IavVUM;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772808275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVOuRHzbb78rDghmOzdwXp0BBGM5x6oDTSHJ79QBAbE=;
	b=V9EEcyWICYXGra6YDbXGa0H7uldQGaMwzL6zpje4duYyxLob67EJlPoxlOS6DPz0sWO1hB
	kXcGoxrXpe+Pk3ostAaMEYK4Q9p8Z1OUJ77tCVtHN27gWR03LhbLvpPcu0hOg4eXI7gUKn
	8+qT0cHY+ptsSZjmz/vhyTVRUcn8wPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772808275; a=rsa-sha256;
	cv=none;
	b=emTcTLVxGdfRd1/CZJ4JcdRIIRq3QOgciR/+3iyUHj/5q3Iaet9UCLD7B2Urxp8XyJSDJw
	mfYnpndNi3Rk7qXrbQ0phgm8BK5h2kX2qhNly3cVuM2X9+i2SRWrDrI9XNPQmK9K/Qn9Fd
	lfihUNSdPPwjs7Q4geI512JOISsK4D0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5IavVUM;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2623A40AA2;
	Fri,  6 Mar 2026 14:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F2C4CEF7;
	Fri,  6 Mar 2026 14:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772808274;
	bh=h+9NOHTHb670Zu/LaAQoajYcmVO5KayLeLmuYtsBpI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s5IavVUMaXkrwKQN2iEP03w/Ma20tNYqh5/cw7vFEa3F2Yzq0z8E64Db5UxXuXLWU
	 SV3VAt3ex/Ny8k60RFhUmy/PSSZOBqxCKUvsAWOIlmbs61bdWP1x0n39RoHRnXsAUf
	 hO14BWZmF2RwY7umyNLWacoxeGw9KmZTAmliY0f82LjFe1W+9Tl8W4O6v3lLc11x6f
	 VwwjkElBr4tn40lpGnbCfZh18u2CTYg67SxqPKwMgUOerITGkyJjJe1cQenHbw9cEt
	 r6NZnhNlstCYXoBs04er4pNstLade/z245MgEOUqrmEDkvQNHpZkwjIzgavqLPw9Zb
	 baZZX52Hb10Yg==
Message-ID: <c04b32be-c5f9-42a4-9f4f-0e890f515d68@kernel.org>
Date: Fri, 6 Mar 2026 15:44:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm: support batched checking of the young flag for
 MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <378f4acf7d07410aa7c2e4b49d56bb165918eb34.1772778858.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <378f4acf7d07410aa7c2e4b49d56bb165918eb34.1772778858.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zi17eu13ds4wqd9nxmfrejaxyj9rrcq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 221702000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772808274-554202
X-HE-Meta: U2FsdGVkX18f3ZIqydG/DSbO0qh8G04QnZVpHOU7GOSc5HKLUKAD09GcGr2nzYrL5/xtUv4s+Lmb1nUdZ7utEflh5wmcrdj3wOekt1hsYgfukDt+wkQXtUM32uQCWWumKriPqrMTkzxFmwusRdimwo8UavtSkBPxjhaRAyjGm6BqWHwXcGu4E+1XU4cuaT4KfYredodFRcucdp05o4+sVgLC+YiSGRECCg53k9CI2RFNeyk4geY10TSwG6x289P8ALSbUeqxX+Gu4OsTXm+PXmx5jGw1DiIGrOw+NQwuwYzzs/N/xc9rMxYfNQKlIUCUxwoeiQ1VFSo2EEprl57MCZ4Qn5OL1KOoFEfsyWsFwV4h8bzvcwbKbZ8SrqM0BLuVBGVith4+jpvcAS4yjwD8uXFENVzPNioHWHbyPWjqaGa6KjUi8A8peN7aKFElGejgG3u4rB5b0qWT8jEVLnBl7ox869yG3GclCkH3GOt53OS5sLaQxAlqz8qfBiTSvnx1vidxs9/poRl0XfMpR07HWYRP4ZMIlEP78vbJPMB8eOw/hsZ+3/Cih5wnYud9T+UwRk4BC/L9onfl3X1L8RTZJvdiXeio+R2b80H5qT7ge5ED6Pe4ebP9/7J9RYg/+7iHzjLH9F5WEPZ5x3yb0dvuB2bjwwtEfvEF1rx74QtygjlY3I5dJh+/CrVmMmn7cUKEucOe9Wre2A/gps1dp/49wRM6bYTbltk5WlTku0Sp5SBAgDGA1XYE7r+wWsmwN3hbGRbDJ2V2E+Ri4lZS14LkfZ/8gI9W3Ci/obPx+SVPSsm9F/SgHyDJak5rbGUis8yDLIOZAGzYoK63Uxz30vT/MhyXS+lQ09oymjM8HRl8svxxarV9paloA4+2bkKMRIaQLx1JEC5AJHDJHZLZ7/h27bpHNeI/1xPKB3xoLr9+T4YQY39D00RkxFjPc11V36jAgSvQHEC645EHpTSMwsN
 ZUXmIbpy
 MMKNuh/etdCUhPQFBS3B+leg/191anVnIy6qVqAsUeYJFccfveglrIvSfscbCbA7o3jUxUXup1nT9eAQiHOZHiYTa8yj3czEYSQQNPf6ojJRYOsfCLpBI+Wn+m9C8AliG50qxGQE0JanOassS9zAXNrQppZMWNCMgYx+5mwBo4vX18ZSjlONeJei6/vWLSN5NtVo368+5zmjAum8XVwNSBcQ9hc/lfvB5Q16VOkFOOLn6ktHjSp2J4hUh94yUKqcuR5b8I8bNwA2fxnfYF3KYgBaebkwh3i485ZfG+pBDgGR6Xg2n/Ob4u5MeQqgwJm8dIWaAQfhwePaN8quMWj36aSmgvtq0TyxKEo4RnDuKu2JemVem+/bzo+zKauRq+UabR96yN5y0euNTfDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 07:43, Baolin Wang wrote:
> Use the batched helper test_and_clear_young_ptes_notify() to check and clear
> the young flag to improve the performance during large folio reclamation when
> MGLRU is enabled.
> 
> Meanwhile, we can also support batched checking the young and dirty flag
> when MGLRU walks the mm's pagetable to update the folios' generation
> counter. Since MGLRU also checks the PTE dirty bit, use folio_pte_batch_flags()
> with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large folio.
> 
> Then we can remove the ptep_test_and_clear_young_notify() since it has
> no users now.
> 
> Note that we also update the 'young' counter and 'mm_stats[MM_LEAF_YOUNG]'
> counter with the batched count in the lru_gen_look_around() and walk_pte_range().
> However, the batched operations may inflate these two counters, because in
> a large folio not all PTEs may have been accessed. (Additionally, tracking
> how many PTEs have been accessed within a large folio is not very meaningful,
> since the mm core actually tracks access/dirty on a per-folio basis, not per
> page). The impact analysis is as follows:
> 
> 1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is
> mainly for debugging.
> 
> 2. The 'young' counter is used to decide whether to place the current PMD
> entry into the bloom filters by suitable_to_scan() (so that next time we
> can check whether it has been accessed again), which may set the hash bit
> in the bloom filters for a PMD entry that hasn’t seen much access. However,
> bloom filters inherently allow some error, so this effect appears negligible.
> 
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

