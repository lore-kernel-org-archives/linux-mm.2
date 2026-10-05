Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00076CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB7B6B008C; Mon,  5 Oct 2026 08:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1753B6B0092; Mon,  5 Oct 2026 08:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D266B0093; Mon,  5 Oct 2026 08:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D65476B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:27:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C64316022F
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:27:05 +0000 (UTC)
X-FDA: 85288497210.29.35ACF86
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00A90C0005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:27:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x4jPGH00;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Kzh/Utin";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hiTqsmgv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gQM2+0GQ;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791203223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5l7VlPR66me4odboWE7ekILisSjtVBHA12CHM7mb7Qc=;
	b=7K376TPit5TCZjefyINbz4DJ33YvKkyTNTlkX1ssVAVQd/UpuzEJs9MlIUVemzb5Vwj2qn
	zlbLFVUZyfn4/Nhoj/7sTBjtHz9h35kKWfAcT/9n1oVbm0AWqxlcNu33GKDcjJ5nJ6WwD5
	VVnQem7nN2eI2ktHyKUJYHZ33c50sSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791203223;
	b=YIPMjrob1cyC0cBX++dCRVAYeboKky4j5hQZQW+iWMC97doqy5YSQFRE3l7H17xP48jMpK
	TAL9/s5QVRDqL7ZTV+FYd48m3OIPYY3AUpasF53u8mRdQgNdp6qyd9wOkQ/2MdZicGQ79R
	SNJg/3h45ToRZ2T74OaqJtF2MBcydSk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x4jPGH00;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Kzh/Utin";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hiTqsmgv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gQM2+0GQ;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB7311F7A1;
	Mon,  5 Oct 2026 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791203216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5l7VlPR66me4odboWE7ekILisSjtVBHA12CHM7mb7Qc=;
	b=x4jPGH00IsomYD4qsQk8nGLEHpkznazt0J5G/ZSNTgYqi6h2b6Wq2/mqLZZPwfL2a5jEBf
	/R9TGEp7Qen8RKGTqDaOSigs/TipAfMOUZEsDTeKEgEs3HFS/PaCD4LKe2rGIJPu7YTeRr
	AXpBqY866zWoM5pmEaCIcx6+abAWwmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791203216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5l7VlPR66me4odboWE7ekILisSjtVBHA12CHM7mb7Qc=;
	b=Kzh/UtinkfQwYwOQ55VuN6tk60EmvHb2WU3/VUGfaPs4bIFOLyeYx0q1XxotsbSw0EClcg
	r4TGr9ZnMbdQDoCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791203212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5l7VlPR66me4odboWE7ekILisSjtVBHA12CHM7mb7Qc=;
	b=hiTqsmgvEsIUVBBYAV2gQXRLmfYRQVaAcD92s1gejeh6CT8Yq01Yc1OeU0nYED+vkM3kvw
	qoZ7/W5BoYyY06ovtPGG3EwrEFC7FR+UqhvB7FM/ObbM7bpQYm7CO52kmedjS8AGrrfP71
	N9JUx71HT3iuQfctEdPKw5bdm91UcdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791203212;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5l7VlPR66me4odboWE7ekILisSjtVBHA12CHM7mb7Qc=;
	b=gQM2+0GQp/lhMVWk8oCqV6wYtDGpUJc9+coi34x8nsEmlgto+Hzxb+yMRAtyk4vbGbdNw4
	5txWsYkxLsLWu3BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88F4513AD2;
	Mon,  5 Oct 2026 12:26:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 16HeF4yXw2rMKgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 05 Oct 2026 12:26:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C40B4A13FB; Mon, 05 Oct 2026 14:26:51 +0200 (CEST)
Date: Mon, 5 Oct 2026 14:26:51 +0200
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, willy@infradead.org, jack@suse.cz, mhocko@suse.com, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, vbabka@kernel.org, 
	liam@infradead.org, rppt@kernel.org, surenb@google.com, riel@surriel.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] mm/readahead: avoid per-folio memcg reclaim
Message-ID: <gz7cxhldkfkinbzpx4goa6rhdqpzldpaenzhtfoxcztpzj5avw@hkzo4fbdbck3>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003001555.3498357-1-joannelkoong@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00A90C0005
X-Stat-Signature: pt67fpj31s1em6r6onw6pmdb8d31fe6r
X-HE-Tag: 1791203222-8779
X-HE-Meta: U2FsdGVkX1+wWwrN6Y5V32A+Sd3Hp8vn53w0xE1qXlPvPlDo7Wckw5F+ntQGkpGBfA33PXMXxuaQ0Nu/0lfHYOLmmmcd8h0pl3c8mIC4iIoBrx+F6P1LiHxkNm9SM7xlQ+34ASPj5KYieIosVLVaXR83V9ReAEqtvM2/Cc5WVaYfY7ubMzIoBu737Cfl7N2dFl1ukKsJKtyR2G265tBCB7n/anDR4h8gJxC8sKx9sv9kQ50YvQ5xPejXCwIN1/A2wxmBkwmn95Z6ChwzkKSzH54uafHqgbl4OZwGYerNCRJrfTRrw8tMmdJ/dVRWQ3xsBUlf6GU+cLovrKCYYXSGZDQZ3AHsqtJJAf4F9reV5c+xgbhiFB9b28YvCdyOZn3lLE2t5NQkccSaeIt8JYl3mpYIAGUO0yDXRz9F8rGDu3X8xw1PAQazYz5v0+iOgcKOZjeUYZ63Ech+mEPvdmnK7J8ac/P4ylF4GCYz4ilfmt0BvJaCkWds9TzYJ7wWYUlg3FNa8MAWFaxhBSVCeppcU3CwQQ0AXvFtbSduIsIN7bqHKW/0Wcz63ZR+hdbFSKYzerURgRRpMedt0T9M/vPHDnBWbP/MSVvjhQ6RKaCDthd8ovEebDdEiux4kx1TGeWQ/JyqPCrhd4qP2r6rlr5uWQdCoudWY0WpstGpb98T7+KcHNNOMKumw7sH7bzcsqYRpWgHRmFU9ofiqf6xa2IwV2xOG3/9yDS0i0yKnzaIGalWnfwX8+HXTJq/iMZgL8HotdMfFLcv7ROLlSZVtdLlSqezu8RgYIjmw1PtUNDxZu4xYsKPYzW3o/PuYFEzoD19DKdgqY1QxIzTtX/3WeP1AbJxcWdYuzhXXgdW90vxJGFJbKmiTaojx0qHPxLlipmPOUme/K0LNMedErFd4nb2HNtgbRtKAJS4f+lEwlB5JfTkKD9Du7ix3B1CMpRiwm4E94ql/BONNBP5sSjjUaw
 FA2B70v9
 MDvflvaxisXv3HAmfF64CtrkUqceBLf0mpgaZuBwjVpdH7qOVf7kGATt3GGKWpIZ64vLE8Y2A2JsuaB0HBIvlSBDN0OPluUy9sReMQHjkr729/x6yxX2eDDQxwacDZ3bQDDfQ0DuRZMsWvJPxS8jOZ8HFjMRqwvsF6K7HiT8I/DMtohQKawVp8cRAhMycSAflQqfC/COZE8p/XVV4ZMjB69fYLMnN+/rV+OZD7+cdsg+3GNDFpU6e2o0cM0Zlzn2MLdpGrBqxVI6NJPA/KnqlBbVJFvTO8JeMD/abVog0/dlThwfK3MxHW54l8bd59FJRLwwH10FhmqXMyXEz0VR7GLoIUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Joanne!

On Fri 02-10-26 17:15:52, Joanne Koong wrote:
> Readahead adds the folios in its window to the page cache one at a time. Each
> folio is charged separately. When the memcg is at its limit, each one of those
> charges triggers reclaim. With many tasks faulting in the same cgroup, the
> margin one reclaim pass frees gets consumed by the others, so the faulting
> tasks keep reclaiming, all to make room for speculative folios, and in the
> worst case, reclaim livelocks.
> 
> On Meta's fleet, this per-folio reclaim is a large cost. From fleet-wide CPU
> profiles at Meta:
> 
>  - Page cache insertion (filemap_add_folio()) triggers about half of all
>    memcg limit reclaim CPU, more than anonymous faults, swap-in and
>    memory.high combined.
> 
>  - 93% of that comes from mmap fault readahead: filemap_fault() ->
>    do_sync_mmap_readahead() -> page_cache_ra_unbounded() ->
>    filemap_add_folio() -> mem_cgroup_charge() -> try_charge_memcg() ->
>    try_to_free_mem_cgroup_pages().
> 
>  - In filemap_add_folio(), 83% of the CPU is memcg reclaim while the page
>    cache insertion itself is 6%.
> 
> Most of it comes from services whose worker cgroups run at their limit while
> many threads fault in mmapped files, mostly on btrfs, which our hosts mount
> with compress-force=zstd:3.
> 
> This series adds readahead folios to the page cache without direct
> reclaim. When the memcg is at its limit, readahead reclaims for the rest of
> its window all at once instead of once per folio, and tries a second time if
> the window runs out of room again. Please note that this only applies to
> speculative readahead folios. For the folio a fault or read actually needs to
> read in, it is still charged with the mapping's normal gfp mask (with the
> reclaim flag set), like before.

I cannot really comment on how much sense this makes from memcg POV (I'll
defer to people understanding that area better). When I'm reading your
problem description I'm wondering about one thing: Are the folios we are
faulting around really used in your workloads before they get reclaimed?
Because what I'd expect to happen in cases under heavy memory pressure is
that ra->mmap_miss would quickly grow over the limit (100) and we'd just
stop doing mmap readahead for the files. If the read-around pages aren't
getting used before being evicted, then the first natural thing would be to
actually stop reading them in the first place :) The mmap_miss logic is
actually rather dumb so I wouldn't be surprised if it doesn't work in your
case...

The experiments you have conducted below indicate that if you effectively
disable readahead you get more page faults & smaller IO requests (expected)
but for your realistic loads under memory pressure is that really an
overall performance loss?

								Honza

> 
> On a 26-core/52-thread machine with btrfs, running 26, 52 or 104 processes
> (one per core, one per thread, and 2x oversubscribed) that each mmap their own
> file in one memcg with a 1G memory.max (before and after measured in the same
> boot), reclaim passes per major fault drop by 94-96% for both random and
> sequential reads. With data compressing ~3:1 under compress-force=zstd:3, the
> runs that livelocked in reclaim without this series (4 of 18) no longer do.
> Throughput with incompressible data, where the disk is the bottleneck, is
> within 5% of before in either direction and the drops are within run-to-run
> variation. With the compressed data, it is 9% higher at 104 processes, where
> reclaim contention is.
> 
> More details on the results seen (medians of 3 runs of 10 secs, 5 for seq, rand)
> are as follows:
> 
> Reclaim passes per major fault:
>                        26 procs      52 procs         104 procs
> cold, rand          23.2 -> 0.88    23.2 -> 0.88    23.1 -> 0.89
> cold, z3            21.7 -> 0.95    20.0 -> 0.91    17.9 -> 0.85
> seq,  rand          78.3 -> 3.66    45.8 -> 2.37    26.8 -> 1.24
> seq,  z3            42.0 -> 2.59    37.2 -> 2.01    22.9 -> 1.24
> 
> Throughput (pages/s), after vs before:
>                        26 procs      52 procs         104 procs
> cold, rand            -5%             +5%             -5%  (disk-bound)
> cold, z3              -3%             -1%             +9%
> seq,  rand            -1%              0%             +4%
> 
> (read_ahead_kb=128, "cold" = read 64 pages from random offsets, "seq" = read
> 4096 sequential pages, "rand" data doesn't compress , "z3" data compresses
> ~3:1, which moves the bottleneck from the disk to the CPU).
> 
> Cold readers get the same readahead as before (pages per major fault within
> 2%). Sequential readers get up to 18% fewer pages per major fault, but their 
> throughput and read bandwidth are unchanged or slightly higher, so readahead
> pretty much does the same IO but in more and smaller pieces.
> 
> There were a few alternative approaches considered and tested in experiments:
>  - don't reclaim in readahead at all:
>    This cut reclaim to 0.02 passes per fault, but effectively disabled readahead
>    in cgroups that live at their limit, and led to ~100x as many major faults.
>    Each read request sent to storage was around 5KB instead of ~120KB.
> 
>  - charging the whole window up front:
>    This leads to overcharging, as it charges for folios that may turn out to
>    already be cached. With every other 16 page jjchunk of the file cached it
>    triggered ~15x more reclaim passes per fault than this series.
> 
>  - One reclaim attempt per request:
>    This led to the fewest reclaim passes (0.75 per cold fault), but at 52 procs
>    10x as many requests end early and sequential readers lose 29-35% of their
>    pages per fault. This is because with many tasks in one memcg, the room one
>    reclaim attempt makes is often used up by other tasks before the window has
>    completed, and with no second attempt, readahead stops early.
> 
>  - Two attempts per request without the immediate drain-and-retry:
>    3x as many requests end early as this series and sequential pages per fault
>    drop 16-22%.
> 
>  - Up to four attempts per request:
>    At 52 procs on z3 data it gave 14% more pages per fault for 8% more reclaim
>    than two attempts, but this is within the noise of the two attempts'
>    run-to-run variation (13%)
> 
> Swap readahead charges the folios in its window one at a time in the same way,
> so it can hit the same per-folio reclaim at the memcg limit. This will be
> further investigated and followed-up on in a separate independent series.
> 
> This series was run through an LLM for sanity-checking / reviewing,
> structuring the cover letter and improving the wording of commit messages,
> helping generate some test scripts, and for bouncing ideas for different
> alternative designs that could work better.
> 
> Joanne Koong (3):
>   mm: memcontrol: factor reclaim logic out of try_charge_memcg()
>   mm: memcontrol: add mem_cgroup_reclaim_for_batch()
>   mm/readahead: avoid per-folio memcg reclaim
> 
>  include/linux/pagemap.h |   1 +
>  mm/internal.h           |  10 +++
>  mm/memcontrol.c         | 131 ++++++++++++++++++++++++++++++++--------
>  mm/readahead.c          |  51 ++++++++++++++--
>  4 files changed, 163 insertions(+), 30 deletions(-)
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

