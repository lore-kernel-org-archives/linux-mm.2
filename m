Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F011606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=efENOTEs
Received: by kanga.kvack.org (Postfix)
	id 82F6F6B00EF; Fri, 30 Oct 2026 15:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E09C6B05B1; Fri, 30 Oct 2026 15:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CDC6B05B4; Fri, 30 Oct 2026 15:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 505856B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:06:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56C8040828
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:06:29 +0000 (UTC)
X-FDA: 85380223698.03.DD2385C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AA0880006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:06:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=efENOTEs;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793387187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P34PV8Gm+eH9EYncABOzzwaQjPvD79yWmom9r8Oz8AM=;
	b=b2SyqhrD0pEnJpRNtdM8sxSDk/K89uUNFTOYfoN1/vTwQRqsxk1l7mufIFCt9ajdF52Abq
	yRy+/XyJCKtJAzByiBGzJs6d3vDYJq+7lZKCBHezb+ABrmWmo63SpCMGz2scZFqZBYaRmU
	qLCxjYjbgZlaNecN7oSM+9a5N/G5EmQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=efENOTEs;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793387187;
	b=j8lCqHDV3UMHMkvA1RXG+pUEvg35WNGhuEKO5GeCabCYFI2kP5dcFblyn2aE3ElLSsR/SP
	y1SETxG1z9JB2S7t05irA8vwMc0Mn92GNRihiTPgJhr0bQi10YkbpTTiNE3a+bR+Q2QRKP
	lq3tRvEn8lI7eRwkw1m0q88MXnY/SB8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B93C443A6E;
	Fri, 30 Oct 2026 19:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666C11F000C1;
	Fri, 30 Oct 2026 19:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793387186;
	bh=P34PV8Gm+eH9EYncABOzzwaQjPvD79yWmom9r8Oz8AM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=efENOTEsBtK2gX5ib4tCjhpG5DyOZiEQaiCmzyqXq4PCXRIDX1h3u/sp59LOUG5VZ
	 HA4iTppjwzs9nqIynwW3ktF0kkh2KSd79OVFDSh+Md/fCF8BXhexVXoPWKMJIjTGxw
	 4btgvHlY9mtYNmt/7uXFlttC0Wt9EF85qvQvGmLU=
Date: Fri, 30 Oct 2026 12:06:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, David Hildenbrand
 <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm: kmemleak: scan modified objects as soon as they
 are grayed
Message-Id: <20261030120625.c2aa64b3e6378a2e78f2f676@linux-foundation.org>
In-Reply-To: <20261030-kmemleak-gray-drain-v2-1-3ec29a96668e@debian.org>
References: <20261030-kmemleak-gray-drain-v2-1-3ec29a96668e@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7AA0880006
X-Stat-Signature: 8ck48nyphohh69ouq9x79reqrnx6cyah
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793387187-708535
X-HE-Meta: U2FsdGVkX18k5RDrObonw4t0qpDCql9K75IpBa954h6Rodee7hAvIYt4GH8JNGhqmL/Fqq5vy7q+UzRRV0Fu513li/XFuHI/5KHl2tVeSyiisgFwBpczibEgJJCZF5z0/+k63whBHCVPbugdI7gk6RlJx/Kn7cO1+uLiiowj+pLYoi2G8aCvER9gbUoKnZQ07Lig61Yrr6Y4ikWPRghNIeg2eH0IsCV5+lmyWEBrfedkhV45H9SKEeY2SJGghWJ4n4zrjyMpLFGiVKkXfYlQgQB3c8DHILvgS5mxgIDXE2+R2YA1K6/330FzZGHj1jjiFF+TGArJudNB7CNugmhonXOwEYIKUBeRXMznGmHNMdTOtAZTcu8mdNjhzPM/kTlalgWv9NHGJkB8BjoFCVTnXHnbtSK2JXdbOCUQ7k1QB8Pr99kR9a6ktqRykS3FNHPFVvIBGpupYBdT+spYspgb1lRtVjFpFUpQ3kVUCo4KaaooHzrrvVTEpFv6ohZPgbmlI2k90N0VUtZQ64qE77qLHtJIJDUtsWGS/RIVe3S652Xd+HG39hUlHbcgViHR9vOODxseLLFaCmXNET5V0ZYdJWoCLb5EoBctF16LsJfX54HBPTLZdkTKIt3bYmYHAQ+YeOqGPmuYUbwoz73gJnEyXctW2UDV8ro15yV5/b6BnleHJrFE/4N8zXNi8Yh69Uf72G6CmTiN9bbxjbe/9FbV4/V7+kjKlIQ5EYKRC4WKq7dytpu/QqG68fkum0pLDsBn/xCaCpfShLc879fsM5p6xyGGg7gfihq5qnSZkl3SqDfv/HjZD5kQWnIA4IZdcUkMMKjOZBZ22NpylIY03i5K4rVbDVjyl4QdG55s9Z3Hj5299MuTVXNIRLDimFI/BWWA1U4KQfBjkJV01GBHwLpg2vQCWQK0wmOqsNVsKG4ixTm5Ee2HiexKlpLma1VYcqOeGcu8zvDt17Xdkn+2QYw
 F3b4oCjg
 tq73Z86m5ie/V7jGZXeJIEPePrkuW+9oLPrAi6ZoIt6QAt9h8gxgwEjyiNYMHWH9AdKq3+n6B/VpLvwpOrfBXIjsuTPK/q0bjnSYhkVpskP1ggOYHU/s5SeEIQPTD51JHwi8cVrVLpGtSyoHn3h3+PQiJGfDf+iFDkU9o+N3yaGgB5A4h/2VvJHB9AH/kOSjiF7iIk23oDJNpjZQmhuyd6IEUE+Jwjy85n1NYJHA/zJ7CZJlSpicL6CRA4IdD8Xs8PJfP62/Zd5CZoWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 11:31:10 -0700 Breno Leitao <leitao@debian.org> wrote:

> kmemleak keeps reporting the guard page of a systemd-journald thread
> stack on Meta's debug kernels, even with min_unref_scans set:
> 
>   unreferenced object 0xffff88829a30ae40 (size 256):
>     comm "systemd-journal", pid 961, jiffies 4294814590
>     backtrace (crc 49b3881c):
>       kmem_cache_alloc_noprof+0x2ee/0x630
>       vm_area_dup+0x36/0x750
>       __split_vma+0xef/0x7d0
>       vma_modify+0x11c3/0x18a0
>       vma_modify_flags+0x1ea/0x2a0
>       mprotect_fixup+0x249/0x630
>       do_mprotect_pkey+0x531/0x820
>       __x64_sys_mprotect+0x7c/0x90
> 
> The VMA is still mapped. It was never faulted in, so it has no anon_vma
> and no file, and the only pointer to it is a slot in a maple tree leaf.
> The mm tree runs in RCU mode: every write replaces the leaf with a copy
> and frees the old one after a grace period. journald rewrites its tree
> every couple of seconds, while a scan on a large debug host takes many
> minutes, so the leaf kmemleak queued is freed before its turn, and the
> copy that replaced it was linked after its parent had been scanned.
> 
> The pass over modified objects is meant to catch such moved references,
> and the new leaf, being a new white object, does get grayed there.
> 
> But the gray list is only scanned after the whole object_list walk, and
> by then that copy has been replaced and freed as well. The confirmation
> scan has no such pass, so the miss repeats round after round no matter
> how many consecutive scans are required.
> 
> Scan the gray list during the walk instead, within a jiffy of an object
> being grayed. Do it from a variant of kmemleak_cond_resched(), which
> already pins the current object while the RCU read lock is dropped. The
> live leaf is then read shortly after the walk reaches it, before it can
> be freed.
> 
> Scanning the gray list after every grayed object made a full scan 41%
> slower (1.72s -> 2.42s, arm64 guest with lockdep) when the pass grays a
> million objects that do not point to each other. Scanning it at most
> once a jiffy keeps that at the baseline, leaves idle, file storm and
> mmap churn workloads unchanged, and still removes the false positives
> at HZ=100.

Thanks.  I'm thinking

Fixes: 04609ccc40c4 ("kmemleak: Reduce the false positives by checking for modified objects")
cc:stable

Agreed?


