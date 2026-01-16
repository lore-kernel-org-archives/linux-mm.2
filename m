Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8722ED4A609
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3A76B0089; Fri, 16 Jan 2026 03:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B4A6B008C; Fri, 16 Jan 2026 03:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9870E6B0092; Fri, 16 Jan 2026 03:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 889D26B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:54:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A9C08C0D7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:54:02 +0000 (UTC)
X-FDA: 84337214724.28.772F2AB
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id 341EAC000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:53:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fMzegftB;
	spf=pass (imf28.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768553640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33Q2PhF2WYxmq/ogA5PjyvsxiVXdLLFmrPqiyNG06ZA=;
	b=1eMVIxRTSOluFQ/i5GtkO+q5Ssz07QzA269ZasBYnLYAXfhRE3S/MB3+q/ltVmMqQ8x5kp
	5rpaF+dW3avg6dHs/WaLOkQSRxqjc4+i9tGy6UHoW5uJGKkN/1Hay6AIyy3oX3z1wtqKK7
	5B/Jqwo474V557jK6a9N8xbb/x2OpE0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fMzegftB;
	spf=pass (imf28.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768553640; a=rsa-sha256;
	cv=none;
	b=gJtKLc8CNN9eGMyWhEIe1+CA/arik8+NTPKEn3sAaXzn1Oww1QNxxe2yhdvwx10YYaTk2B
	IpVrL/3zpQSRolWjmFQnIjEV4pe/cln3ueYGdHL5dpemVlGMkI04CV/2j9+GnNiooK7dyV
	kc2h4y5A2qTIwhUMuBd2cqLtGNs5EJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=33
	Q2PhF2WYxmq/ogA5PjyvsxiVXdLLFmrPqiyNG06ZA=; b=fMzegftBUnCngDNnH+
	agGi/V2u+xvTvI5+0nxdk1Gh6sXIDg9IMHuHcZDbVRk5oHR+Ey/74O6UnnuBIC3I
	+iUX4dkULe0kM8MGeaA5HsL5dmjmzeXUUbalCM660lkwEhpKhTK97HuA6RJxAQzh
	vkL/qBq+GBAKzurox0+0GuEDw=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3A6R9_Glp7FkOGA--.61S2;
	Fri, 16 Jan 2026 16:53:19 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: lorenzo.stoakes@oracle.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	harry.yoo@oracle.com,
	jackzxcui1989@163.com,
	jannh@google.com,
	kuba@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	vbabka@suse.cz,
	weixugc@google.com,
	willy@infradead.org,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH] mm: vmscan: add skipexec mode not to reclaim pages with VM_EXEC vma flag
Date: Fri, 16 Jan 2026 16:53:16 +0800
Message-Id: <20260116085317.3945633-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <14110b70-19e7-474d-b0dd-ba80e8bed9b0@lucifer.local>
References: <14110b70-19e7-474d-b0dd-ba80e8bed9b0@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3A6R9_Glp7FkOGA--.61S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jw47tF4Dur1UArWxGryUZFb_yoW3ArWxpF
	Z3Gryjkr4kXF1xJws2yw4DWw1rA395GF45Jr9xC34xC345Wr129rs2kryjyFyxCrnrGr1a
	qr429rykZa15AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_jg4JUUUUU=
X-Originating-IP: [124.77.188.51]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC6B8THWlp-H80CwAA3F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 341EAC000F
X-Stat-Signature: a5e6d134wfuhw7d9fzcrzb4dxr6bkn5h
X-HE-Tag: 1768553638-719344
X-HE-Meta: U2FsdGVkX19yEDb11KwKtGFzI1xq+y5uXb8Ss0SeQDR0ZMwb1TIVPSU62VmbIAaWp0uMcSsk/rn1dCxef/LaHYCOII4U9rLY/9FtQtcY5U2aa1eVi/ObYQhT45zE1wzjr8HiZdJanQH5WTEUD+6VS2u7HWlli81RYBmMNXS0U4kxq9RAklt8TuRXVN9YjouUS+rceU+RabAdzgb4+6SrNe121JpYb1sc8oBfnxWr2MA5/c9DmpTDo+q8L7Ox+1xkP2pxX3sbBinItnLpdd8sjyMzlNornDw/pVpGsxDOxh+KuJRZ7SiYO3Jg6UyLKM8G8VmgMhn0emyAcKxzvLDhc7oVEK6qyibWMsKAk4y/4AtYm2sZ4M/hASMpKGFgYpjxlTIcUy9eCJbXDS/yK5j5WcsL3nYZOj0UHYxddMa0i23ECYmnMPi3PTf4qia7W0dw/UPZFsaMBHxkyi+0UxHjjHyKp0QEXxWQV9Hj41f2RT+lFFdQD/eJzU9Md+u2Bl2UVoo3AaXyti8fptnoFrvznTak2gksixPpT79Hv8bxFlYWkKMYRevusrOq77tbmoIRoRDgljkJXzcnrobwJtZGrni7u62jVK4tJe/XXX083y8YrvTsu5bPPfiv2V2iGq6Sz1w+7+qcqgk/wFrIblW3zZ0a0lM46Qgl+jubVPVArLX3Coi5cmg2e69dmahM6OPM/7Hf4juV1ehhclOP7bWE8Sak6nMMHwVQ5qO2jLrLQc1d3ZnWFv0Z4gtx6erojay+Drnm+FyVK7/yqT6Ts+chJFJ7We8vJMA4C7Pr64OS6GCT3pnxW5sUera0/epgt6RRGePQySsRfyRndbFNcQi2dnGWaUjYzjKCPbJQ6lWDVGvtFOFVhZqiNoW5Gew5KCepNArup5cabp3A1cNJGFyaNqN5MPt7U1dsoB/h4/oxVozdBdITCYUvn/ifm1G0fvcclTGbQTqdJCUPu85ZjNk
 ghdvoPPq
 kzsQyBEDUjg9PkQBLEhllDwUqPIwlImgowz4eVNhufx0lUWYVUN3IaQUt/CzUZf3qpB8G4sQvhVl+N2sAurwhIr1DOnkif5ZZmmjQ8ysaX2Jw7bsXocnKvsS3HKdkayxZUIv9USSv6/dZoUJiUtV/yhqNp1dMEipxfRT2EdKyyJpourxzrVO7G2HCWTwpbNllTc2E9BOFVH63APOUYYSbhNmhy7vNtShAwUUb6USgCuZgettBtCB7yXJ7bF3YyuUZVQn7WegKJv+0e/HAUJciqGDfnkNi8OZxxRWYAVcRhjUpiyUZ0zPX8/P9Jv5tSizgbvlmogivHOQ6baAkyYu31eFkfiAvy7qi8KOtE29cOnIDVnhSobRBkGM83TPTaO6+UlgTca0NeYpzs6+zU5gCY0lGQL38mqzSRT3IoPWFEpBE+mHvoGKD2Em3Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 08:20:08 +0000, Lorenzo wrote:

> We already absolutely deprioritise reclaim of VM_EXEC regions, so you must
> surely be under some heavy memory pressure?
> 
> > The iowait problem becomes even more severe due to the following reasons:
> >
> > 1. The reclaimed code segments are often those that handle exceptional
> > scenarios, which are not frequently executed. When memory pressure
> > increases, the entire system can become sluggish, leading to execution of
> > these seldom-used exception-handling code segments. Since these segments
> > are more likely to be reclaimed from memory, this exacerbates system
> > sluggishness.
> >
> > 2. The reclaimed code segments used for exception handling are often
> > shared by multiple tasks, causing these tasks to wait on the folio's
> > PG_locked bit, further increasing I/O wait.
> >
> > 3. Under memory pressure, the reclamation of code segments is often
> > scattered and randomly distributed, slowing down the efficiency of block
> > device reads and further exacerbating I/O wait.
> >
> > While this issue could be addressed by preloading a library mlock all
> > executable segments, it would lead to many code segments that are never
> > used being locked, resulting in memory waste.
> >
> > In systems where code execution is relatively fixed, preventing currently
> > in-use code segments from being reclaimed makes sense. This acts as a
> > self-adaptive way for the system to lock the necessary portions, which
> > saves memory compared to locking all code segments with mlock.
> 
> This seems like you're trying to solve an issue with reclaim not working
> correctly, that is causing some kind of thrashing scenario to occur.
> 
> There's also nothing 'self-adaptive' about a user having to specify a
> sysctl like this.
> 
> The fix should be part of the reclaim code, not a sysctl.
> 
> >
> > Introduce /proc/sys/vm/skipexec_enabled that can be set to 1 to enable
> 
> No thinks, we emphatically do _not_ want a new sysctl.
> 
> sysctl's in general should be the last resort - users very often have
> absolutely no idea how to use them, and it in effect defers decisions that
> the kernel should make to userland.
> 
> > this feature. When this feature is enabled, during memory reclamation
> > logic, a flag TTU_SKIP_EXEC will be passed to try_to_unmap, allowing
> > try_to_unmap_one to check if the vma has the VM_EXEC attribute when flag
> > TTU_SKIP_EXEC is present. If the VM_EXEC attribute is set, it will skip
> > the unmap operation.
> 
> Hm I really don't like the idea that was pass around a flag to essentially
> say 'hey that thing that has been scheduled for reclaim? Just don't'.
> 
> >
> > In the same scenario of locking a large file with vmtouch -l, our tests
> > showed that without enabling the skipexec_enabled feature, the number of
> > occurrences where iowait exceeded 20ms was 47,457, the longest iowait is
> > 3 seconds. After enabling the skipexec_enabled feature, the number of
> > occurrences dropped to only 34, the longest iowait is only 44ms, and none
> > of these 34 instances were due to page cache file pages causing I/O wait.
> >
> > Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
> 
> So yeah I'm not happy with this patch at all and I think you're doing this
> entirely wrong.
> 
> You really need to dig into the reclaim algorithm and figure out why it is
> not correctly protecting VM_EXEC mappings.
> 
> Consider:
> 
> 		/*
> 		 * Activate file-backed executable folios after first usage.
> 		 */
> 		if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
> 			return FOLIOREF_ACTIVATE;
> 
> In folio_check_references() and:
> 
> 		/* Referenced or rmap lock contention: rotate */
> 		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
> 				     &vm_flags) != 0) {
> 			/*
> 			 * Identify referenced, file-backed active folios and
> 			 * give them one more trip around the active list. So
> 			 * that executable code get better chances to stay in
> 			 * memory under moderate memory pressure.  Anon folios
> 			 * are not likely to be evicted by use-once streaming
> 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
> 			 * so we ignore them here.
> 			 */
> 			if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio)) {
> 				nr_rotated += folio_nr_pages(folio);
> 				list_add(&folio->lru, &l_active);
> 				continue;
> 			}
> 		}
> 
> In shrink_active_list().
> 
> We _already_ take into account VM_EXEC regions, but for some reason your
> use case either encounters such extreme memory pressure that VM_EXEC
> regions end up being the least recently used.
> 
> It may be your workloads are doing something crazy here or you would end up
> thrashing anyway, or you simply need to mlock() them?
> 
> In any case this needs deeper analysis on your side and any proposed patch
> should be in the reclaim mechanism, not to provide a 'ignore reclaim'
> sysctl.

Thank you for your reply. Your response has been very helpful to me. I will go
back and investigate the reasons why the algorithm is not correctly protecting
VM_EXEC mappings during reclamation. In our project, we indeed encountered
situations with a lot of I/O wait exceeding 200ms, which led to significant
latency spikes affecting many tasks. During this time, we did not enable any
extra mechanisms for pagecache shrink.

Earlier, in our x86 project, we developed some customized features to limit
pagecache and set a theoretical threshold. We also encountered significant I/O
wait issues, and I suspect it may be related to the priority settings in the
logic below. You are right to point this out; I should take a look at this
reclamation logic to see if it can be optimized and whether I can reproduce the
earlier I/O wait problem. Perhaps there are incorrect priority values set in
the following algorithm:

void __memcg_pagecache_shrink(struct mem_cgroup *memcg,
			      bool may_unmap, gfp_t gfp_mask)
{
	unsigned long nr_should_reclaim;
	bool need_requeue = 0;
	struct scan_control sc = {
		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
		.reclaim_idx = ZONE_MOVABLE,
		.may_swap = 0,
		.may_unmap = may_unmap,
		.may_writepage = 0,
		.priority = DEF_PRIORITY,
		.target_mem_cgroup  = memcg,
	};

	/*
	 * We recheck here mainly in case the pagecache is already satisfied,
	 * especially in asynchronous scenarios.
	 */
	nr_should_reclaim = memcg_get_pgcache_overflow_size(memcg);
	if (!nr_should_reclaim)
		return;

	sc.nr_to_reclaim = max(nr_should_reclaim, SWAP_CLUSTER_MAX);
	sc.nr_to_reclaim = min(sc.nr_to_reclaim, memcg->pgcache_once_reclaim);
	if (sc.nr_to_reclaim == memcg->pgcache_once_reclaim)
		need_requeue = 1;
	do {
		if (!is_memcg_pgcache_limit_enabled(memcg))
			break;

		if (sc.nr_reclaimed >= sc.nr_to_reclaim)
			break;
		/*
		 * In case there are not enough pagecache to be reclaimed during
		 * direct reclaim, we only enable mapped pages to be reclaimed
		 * when priority value is smaller than DEF_PRIORITY - 4.
		 */
		if (memcg->pgcache_limit_sync &&
		    (sc.priority < DEF_PRIORITY - 4))
			sc.may_unmap = 1;

		/*
		 * We only enable dirty pages to be reclaimed when priority
		 * value is smaller than DEF_PRIORITY - 2, and the reclaim
		 * must be in an asynchronous scenario, in order to minimize the
		 * performance jitter when dirty pages are reclaimed.
		 */
		if (current_is_kswapd() && !memcg->pgcache_limit_sync &&
		    (sc.priority < DEF_PRIORITY - 2))
			sc.may_writepage = 1;

		if (__pagecache_shrink(memcg, &sc) < 0) {
			need_requeue = 1;
			break;
		}

		/* Avoid hogging CPU in preempt voluntary */
		cond_resched();
	} while (--sc.priority >= 0);

	if (need_requeue) {
		/* Update memory static stats, avoid over-reclaim */
		mem_cgroup_flush_stats();
		queue_delayed_work_on(memcg->pgcache_limit_core, memcg_pgcache_limit_wq,
								&memcg->pgcache_limit_work,
								msecs_to_jiffies(READ_ONCE(memcg->pgcache_limit_interval)));
	}
}


