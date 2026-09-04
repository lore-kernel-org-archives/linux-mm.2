Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5548FC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E66F6B00AF; Fri,  4 Sep 2026 12:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE716B00B0; Fri,  4 Sep 2026 12:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAE86B00B1; Fri,  4 Sep 2026 12:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 455176B00AF
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:10:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0EFBC0140
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:10:09 +0000 (UTC)
X-FDA: 85176566538.04.81B003C
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6FF03180018
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:10:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="nH1/DUIn";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.194 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/dj2tdiAd1cTUZz8ylHlEPfPG8XqvRkzCQtnk9erCM=;
	b=doWi5yL2lrrhPEr2dmV1jDWFh7/7qsJLYcAN9RmcELTx1T1uXTf4IljV3WxlQRTVc5t7+j
	lhsdDFmquvGvYWyTJV32wU6lvBI+rKJhOHP3VlEe8ioHAxT8tVJBUoXVFp0/Exy3iBCcSR
	hcEcqk3abvTN7ctixWEfXrTOFDnKMUE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="nH1/DUIn";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.194 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538207;
	b=0RdXZcdlbRY2EyvQyXlv7Ja848JDswshluj6hUJlIHhZbve+eXHlqU5ba+HpVuPonfagne
	d1NG6jqU3dXZ7ytg1K/XmuLJwF0EdUkNcaLBY8meBof3uqyxbjIgHtkgXOH/Fi2S+zP3ra
	zZgSNzke5uKuMzV3GpBE5XLfjFFX2lk=
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-936dfd009d1so253495385a.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788538206; x=1789143006; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O/dj2tdiAd1cTUZz8ylHlEPfPG8XqvRkzCQtnk9erCM=;
        b=nH1/DUInt33XQWFmBvyqXh2JC20tkS0RWzsbMkO6kosgbE8u0SqKD4W7c/Ypkr9v2K
         Z0/PiNj+AXGlxsVlkXGZWLq6u2uL/Oult6wvX3bbWEPpRI6QsDXjwpH1g6nKSejzpm9z
         Vq/SuLsxeFfwXO0Ra1FosyX8qjbtfqEaavYisA4VA1NCaAHS1SEzJAwhf6MNTQyKprcI
         0O4EMQKRFl7+wRseMvtZGZe6u5JaC1AGD90+Nj/d5wvTGnOrWR0W8fZi3eDLSuM7JsGb
         ainvRikwYnMZ0lLSm+OTCmyuimDvyI9tNCQSi31RczACHVzU/XhGz+MaqmEoSJcfA04H
         45gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788538206; x=1789143006;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/dj2tdiAd1cTUZz8ylHlEPfPG8XqvRkzCQtnk9erCM=;
        b=cyb4D/B5E+e8Eq57M9j8q91OmA3Gp1ZnOl7fhGn5T+YEI6rxTLBuqLDb+cfviZq/zp
         pEhTClDeEkcVvpDlrglqPspNRpc0CfefPkylq27NYq04uV9cihBuWz0+ZLDZyur9hVv1
         LFpTmZquzYpCXA+LPRWwX/VzZzW3rYOOrwVVdkSfwaxzsscTgT2G/0uwwudOlOyRhR6k
         ZGadwBZlFafoELCfv8SzUlWZDxwkyucAOSSumWUmE0kAGw1vjz8NO69M+fr42ZJvrhTZ
         ptiSQz4hDcPm9nmGYirrBxKe+ab3MeOiSFGyVh8G65jYbUe/Oc1uYIv5Akqv7Pk7v42L
         Xfng==
X-Forwarded-Encrypted: i=1; AKwUvBwp9iAds76rFqjXAy2P4aBTYF7+aOpUF5njwQGSKT1ZGO/H8sRkS8cK9zpVllkEHj7GW8sGDJafAw==@kvack.org
X-Gm-Message-State: AFuF++kCe0QXRQ2AK1QUqnRjTS5MEQC8M1eyhXEtn8Ll99Yz7q9XYdUL
	prF9UPgiF8cJCx+vAu/ignOs5FmGbHnqmfj9wxJZdllrrWoYzIDZVgxWyBZSfF4a08I=
X-Gm-Gg: AYBFou13oqw6/u+9i/bB8RLEdK8sYUVuvEdbHHRjpAsKxJK7iFnCpR16QAf3ro2EZ7y
	BGY1pjG4QIBLU72+hBBiRHxLztVpA4tNnhu/jz+DCP6+o9DUpu/5FRCE8+EvZOwpZikHIU5t4Ul
	4D9S0ixw+scwK4hSKv14/IE57itX9OsyhJiVbg6alF5ttw9lhHRTgtN0WUwLdaaJAe9ohIzlUJJ
	t6Juu+If4JfmOuA7T5yHO1O4z0zZf0K3ouLlSqFMYdQu7RPXXO3V4LPHA3T7fnBqfXV+iqPT95g
	L0YEUgSzco4sfGSmyCzdK7MTu99pETVtEppjYu8m49sIWNmcx0ZQvMP4z8FO8urvPcwpoUcCqPn
	IkEyZ3xArYQ0QAzyeO1Zoctqri6oIrdsDlB86ibWeoX6MOxPO1j+0tYme4XCHCDsJrv98JEr3U1
	mImWLsNamoP4iO2bgxU38W+Br5Qw2LiXjpAc0W
X-Received: by 2002:a05:620a:6cc6:b0:930:f285:5ee9 with SMTP id af79cd13be357-9396e0b2fc3mr1194176885a.20.1788538206229;
        Fri, 04 Sep 2026 09:10:06 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104067b125sm23869576d6.29.2026.09.04.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:10:05 -0700 (PDT)
Date: Fri, 4 Sep 2026 12:10:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <20260904161000.GC6641@cmpxchg.org>
References: <20260904115629.3993331-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FF03180018
X-Stat-Signature: u3qpaztyj7e6zq3sderq47o7td84m8ud
X-Rspam-User: 
X-HE-Tag: 1788538207-6847
X-HE-Meta: U2FsdGVkX19bjwvCsQRvDPBP01yDcXflwIMK+/1VnjsaS3uZdkWqqiFLdjRheJjBcAp2Eksg64Sl+CWjHw076WXZlTqeQQPreCmWTeTP89PnDR+1h/d+LUt4D0yFHMR1Iw62OeY7A1tZK/Q6Qqqsm1bCGOYTYBbPEU2gR8N/qNrr2UD9jrtMapH9AHNxhiTax/2iZBI0dUnhVvDHfvSWeMy/gTzQfIBA9emrBhLBjWkac492Z3e4hRuj4NXVsGPYnmz0ENDWjsvLDikjEqSP8X2ZwqKxetcOUOzW2zbSNkkFA8Y5kZ9Z0aCrfQ5Wq7xVUPfTySpYiHzQqp60Pkhom8g6AQxfcQs7ImoPKpZT4Q11vdxD4uiznj6Yq/goaj8uZ2NHhSuLx1+nZy1QYq1FJDN5kb/RZe3ZFsQpttgL3P6HPSRv7YnR8vWaEl/+Mo6mAjJ7cm3NgznMOhv+x6wWvI/BCtbsf3OA6zaqHJbopL8oaIkeA+Uc6Futx+BtKWZIzEOKt1BFFmSPcAdTGlPnKCnA6jZsOhtfUlipUEtDEmwU2au5pLy2RN5ECWViGuiSNXiy3Cvu26JNIsZOb1gkY3jNvJqNI9CGHKEbT6g+CxSGH9/qa10xAB/bj89UFBFGeVswU+Ns0sJXSYzkkipVB/jsriej5Yw2JFI1wYDYQxFOn9THHZshsvziFtzq1TOixBcumDO7KYlk2zFOfDa46RjYqkSwg4izX9Jp4ZR00JtYWVJewSOZCUCdvgLjWJ8UCLzO5m6Tfp2voBseS02pWDwK0BztWpWv1nq1rCdn4IYVyZ27Ljv6rup0aqV7tM96/wWvt9iETyNz8yHwoUKBB3Gj31B/K1kXfNKh+sAXygDU2gHUjlqZumMwJGGcpUR6ncIC+Sjd31GOKpKJnCI9bxY9b+CFHvIFVo/q+VJNIxLry8qIefwuw9k0Y/eBjDtad9csgoW3bP2qFxpXoF9
 obhHyo0s
 QqwnQVswdQRT3nWnPsW30+9UWljsiw3Uqsd9FBM1NCz6bFVDgdFxYxK5KzdLHt7TyUMtCDl8DMn6VTxipMZsRiyEwbDhr9sFvpwhSTFz6UV2dLckLlEDBZTxCRj2MvrQAYoDZFMZr7oEyjhFlbW9YOQPDe1qvMyvDGwEJlIUwIVNxtAfYPXAQLWiDjZf5l9KkmkEHZlqTK4CNsd0c6ifTz6X9P6H7TPhn6d2jEU/1LeSkDTsmleYP8CGPzuIzceDjQIdaXwPwOZhLJWQ0yl+T6umP5qgDNBC/hv01iLi6e2QUlbj93NAzrd9RNZly61nYwnvy8Yz1E1FfXeBFZANdnI+bEM3yS+s6HcMFt6D6xYqPabyINV9VupqCUVfFMXRSwC2Tiy4cckwDPhgUzrBkQCN3MDGEwlMWUXeIU785zPYOsqBchYYYVd5sCKoOjT35M+FlY3GAdJgFHHzigaYflzPZzHAf01AETY4NVWvYhP+J6WTS2FCzPjlE4l4SL+g3J7rg/75YQrKV1IBwZl6uVVvuuBNEV6wM7zup1tIyBem8M36qeSQ7SXfgveB7fKzkrFYMxpyOOq076z6cdwDXeCQmIqoIImpJCggcnL8SDrF0sAtc+3rtiJ1sn3FLV+wriolLkaMPfc12rrGB+tWWWxWqRUHcv5ySI4vY21wA3SJqIEUh/aM+OrXiJ02tfEREUHkZbrHxb2agfld8hDVV4gjZZLX4wzgfSxf79rJ0gbBjnMcwCeCJ0dyKH0829cHsBMLwJr4sAZJEGAzVB5VThFlM6rO/6AYgW1L3/i93nfaGrhmKAn40sLc2+G8S7Hg/DKN0hNdDKtSQN/iF5szRSGDn8Gd5ZnTe2wiX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 11:56:28AM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, clear
> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
> can_direct_reclaim, can_compact and the nofail checks are evaluated.
> This makes the entire slowpath treat the request as non-blocking: no
> direct reclaim, no direct compaction and no drain_all_pages() IPI
> across every CPU. kswapd (and in turn kcompactd) is still woken further
> down for background defragmentation, so compaction keeps working for
> long-term system health while being removed from the latency-critical
> direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
> 
>   Config                   Avg TPS      % vs Baseline
>   baseline (no patch)       59,408       -
>   With this patch          155,409      +161.6%
> 
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>

Looks good to me, thanks for keeping at it.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

