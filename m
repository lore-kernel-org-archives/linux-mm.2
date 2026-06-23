Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B20CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80EE36B008C; Tue, 23 Jun 2026 14:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BEC56B0092; Tue, 23 Jun 2026 14:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4AB6B0095; Tue, 23 Jun 2026 14:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1346B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:09:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE3971C5AF2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:09:05 +0000 (UTC)
X-FDA: 84911963850.30.195D18D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id C0A50180011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:09:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wgEd/U9D";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782238144;
	b=58gui3cOy+9aKAnpvUMMWW+o6dm6eLbeZonPF7jVC6TSinGHxx5jaJ+oyzDJu8DaGrVKFM
	ppMnD0AY33ZmeyFtjSw4hnV1SEGZp7/DibVYJyUpKXwumoOPYSb2VwVHSOzGOBKwj1znJl
	BUhytuFWagSfWxKlIhNbk3zCwc8o7OY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782238144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXfEiM4jkm920RVfEhKOk9S2wafZQEGin844HPcRxZE=;
	b=4J3VkJnGZoCG6eYwlWOcbmXPCVitNqOYLUUldmbH+mwPMwL3uKD1e3l21I+K/I9MbKZqdq
	nQ774mDERQBSDtGREzsdFbukE9GWJNLNIn7tf8FFylK4O8zhmuVG38nSp/pse6zpBe5ml6
	+kqjQJjX4ekx5Y9O3I6clwghFefhLc0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wgEd/U9D";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 23 Jun 2026 11:08:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782238141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zXfEiM4jkm920RVfEhKOk9S2wafZQEGin844HPcRxZE=;
	b=wgEd/U9Db0WHWapZ+mfVWppaS6KYtdPfphaKlnqjcR3/jlMe6efMFDfyrXFopmBzVtfzze
	4g02EQ2WT0HLbzgAJ5gMNq6kl9MDi0XtctBvx2/SBjTKm0kHOf//4LFdgcqI1hQSiyhTc4
	qJbinVk9+MLAmzDUedlX/VWn9UAgI5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in
 memcg slab shrink
Message-ID: <ajrHa_JGxQvCMf8t@linux.dev>
References: <20260609123047.1948242-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0A50180011
X-Stat-Signature: f8e1gaej3tsf6jrsoxi3ecaiufuut3kp
X-HE-Tag: 1782238143-864849
X-HE-Meta: U2FsdGVkX19geOBFmYWUnD6/vqjn9IPANA57qQxZWGcChmA41N9EuofXQvbg/MPS3nD5ULdiTV3tgL+KSzivoiO1i4xtodm2EPjyrT6k8sCq4NCsmTkEOERsA8DI7FNEQEPoVsI31VqjY9jeeG4mtOdzy3SgAxnKw5CAbKhle0ILUDR5qSao+CPxxZJ18InqMP7HyAE9O4fL9TxgnoC5AhZtI/W3YjNu6p1LB4cPaUw1OrQDW2zYmYkOaBmqDA5Ku00pspZ1/mNbkK3p8dWmg6cnMEqxqmDERKtzyw4n/gvV/0kZEVEeIiAf7VNMoWTD68j/8eE+HTv1JblFHbwsqF00KbmoeDlkZbqwY24yNhfl0io6k1yWm3CbwBgDo8zzzY5Bmnin2ee1RVnPD2yPBKz9ArgN5MJp9pCSmgbvoa+Rj4nojfHgCcxZc7eVv4pb27aHYZuKLlfP5iqmGymkJu152eYf/mDmI/9kPm6Ti/AkQpTH/xN8cNSapf10zqyNy4E+mRtUp9kznbe93cMx/APMhnHa/9euvBQ7qW2mwAKtgWzbGcAYzW4uwUzJQrSWkztiPbmTffPa5e/9Qv5o8wBmzcawKpHzUGSVQdJ0jZ5ZVf7UEGY0cmVO5FMgeDhtyIDmGfYdUAfml+s1JbkdllM3BEDdxpH6hcT8SbFHAViyD67WzP2mLm2fO7dRs9awCmjVyA7SQ/FqFYBanCnUemx5HDNqVs25zBHjCN6oXu0ZJYjmOayYw+F5mZeMunIHAZ1hPuU37GZ/w7NLKVuFn9usB1UrInvDcjThPwOTR/sCNUXpMoIrJCxKnrXFshn1N2NqwhSweTJ+chBWUx+Jnx6X+NdXYa+qfFf3JEKzwk7LFP4pZhuORSHkGCgngSQeUJxYTFJMDzIHd8K07mUra1jZhQ8Xfrz6wqYtpU5Bgmz2b6qvJdjaxXt63AufV0iCWNfT+E1WJ7ewZWBd6JQ
 Rz2WCgXB
 /jDnpQpuG3yuf/V1XBV1J8Ys4sz8qNRi0hPhmtgSEzpV5rhloOpHl0yGcojQhBX3pkeSVip+p+QNge72emIGAre+Konfxv/YiUIYECRq3sydrBktLxaX2oAanZ32zNaCuFHbAVxAhneZrNq9o+YAWElLzrt2rCHACFsWMDbpZGBl24H3k82brqI75/anEODdFL9xSmw/u8n7Ggrod9WgTnnkk4ki8f/hrgWOZMxlwTZc2FznMpS5cfIlmGRjVV+NzdgmC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:30:47AM -0700, Usama Arif wrote:
> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> None of them filter by sc->memcg.

I see the underlying objects whose count is returned by ->nr_cached_objects()
hook is memcg charged for shmem and xfs but not for btrfs. Do you envision
there might be a rare scenario where we have a lot of memory charged to a memcg
consumed by objects which ->nr_cached_objects() tracks and that memory becomes
unreclaimable due to this patch?

> 
> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
> whose bit is set in the per-superblock shrinker bitmap, which on a busy
> host means hundreds of calls per reclaim pass. Each scan queues the same
> global shrinker work item that's already kicked from the root path.
> 
> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
> the returned total stays positive even if a memcg's own dentry/inode LRUs
> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
> in the memcg bitmap, so subsequent reclaim passes from the same memcg
> re-enter super_cache_count() and pay for the global counter walk again.

What is the main concern? Is it the amount of CPU wasted or are we over
reclaiming or reclaiming from unrelated memcgs?

> 
> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
> or root). The memcg-aware dentry/inode LRUs keep being counted and
> scanned per memcg as before; only the global fs-specific hooks are skipped.
> The root/global shrink path still drives those hooks; only their
> invocation from non-root memcg slab reclaim is removed.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I am fine with the stopgap but it would be nice to have proper memcg awareness
in xfs and shmem callbacks. For btrfs, I am not sure if it makes sense to memcg
charge btrfs_extent_map objects but at least to decision to skip memcg reclaim
will be inside the fs callbacks i.e. nr_cached_objects.


