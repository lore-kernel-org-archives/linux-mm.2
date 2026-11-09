Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA7C606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BPuMJIeq
Received: by kanga.kvack.org (Postfix)
	id 547596B05D2; Mon,  9 Nov 2026 13:58:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C956B05D8; Mon,  9 Nov 2026 13:58:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A266B05DA; Mon,  9 Nov 2026 13:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDCD76B05D2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:58:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB37C402BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:58:57 +0000 (UTC)
X-FDA: 85416492714.21.BE39BC4
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EF501C0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:58:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPuMJIeq;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794250736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kScsvF5omIBGyCzx6Xt1u7IAsBNAtQ0U2ngEcowLFMQ=;
	b=8TtlLG5J5C8Ex8cxtiLDKO7SDWpTY0YkQCCgzAhS0grEBx0GY6YQTsBD+RfDEUc6waoM2N
	rS1YiRi417RR6WU6m6WebH3+nJXDWL94BBLPM+2V5BC5d+KXZp1m1eK96qHUqWaXIg1zSw
	a3WAzxuACpfIQ0O+5XhOGCuvVUzYfh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794250736;
	b=c3AkonH/bUdiP8ae4cxFUoJXtOR7oFVoy6fA2TddDlq1P7pA7KwtrEaK2NOI5neKlkU8ft
	1BdR2IjSxHtj/vbRC82Gs18ocs1PhgHNqGgEkA64KuhSo/W7WGHKVt0Hem2lsTKpZ3NeGy
	alGJj6RIc+qFaHbSUhAB/qnw0X/1JJ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPuMJIeq;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5uFhdvDgxVAAgzuSFrp+bOOxogJv3XKqImRI03XYWSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794250733; v=1; x=1794855533;
 b=BPuMJIeqJI0F0ZsTQf9N6zhrjSoZXQ6AuCiqnXzcCbRNuzPNNq8GmwdKwxov4FcVS14JxzoZ
 pT265pq9o/Mo+mhQgUCRKAQwiXc6f0SeUrOBMrrpXDyFxHwiK6d25wKcNUG/FZ5f06mWGsaTw41
 /t2OpoR3568A+7iSQ74zE5FU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 785622e6d21c5f4f;
	Mon, 09 Nov 2026 18:58:53 +0000
X-Mizu-Trace-ID: 785622e6d21c5f4f
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 10:58:48 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Zhan Xusheng <zhanxusheng1024@gmail.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM
 victims
Message-ID: <avIXz853VU6FSMX1@linux.dev>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Rspamd-Server: rspam06
X-Stat-Signature: 1fi1j3yoy557e4qrx9uxetx1rsb37k3y
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9EF501C0007
X-Rspam-User: 
X-HE-Tag: 1794250735-136135
X-HE-Meta: U2FsdGVkX1+B6bzpbIrklf1OUMfePdRdZDGAbU/Q/bcVmKSauJktnTs2Ags8yY8vmLBkRBBhr55urvOsAL+sHmo38mu7Yad07CIA+luoXGItkhruobNWx3QRBkv9TjaMtzNkwgEDKdU5YQHTOx2KFqNh0ScW5McaTgwmaRsojS2oiMLWM/axykxa1G1QuaeuLA4gYawVbIULv7+gCUcGYa1VHDIXKwZ35l887YkqaiXvsxyTI+09nXRh/lE6Gwn9maDjZ6Bou7BCNe8O7Q6196nN3+7bkpfJnk88giBdRiXJSE+lHJVCI2XzUq6r1JGy2hj1FvpgeHVHwFP/AYW7smnA8xwvJpfqJzsJWno5ay+gjWi4Tq/OHbANAALUVNDXlhCkseEPrKO6B4YThefwnS+XXHzHzzRKzrHWVAqX6TbcxglF01XG4lBuulZ57rJqW3W1FJbYF+MZbea9xOINaWK9XrCSwg4M6GKrG2iSYeW30nGOy4Fsc2zl5H1/VumcVSmj2c+Of5p7deeUYDT90YdRmH+VBG2cCl/A6GZWR6oo/IUXY8td/mTzz2B7748++CAC3P7A4QyMVZxT+7Ho08ROVFMdoW3x0zpVKcpXpPvE4eJrDzZ0nU7hAuPvdXLR2IDMwmj3naiVdTVFDd6HMpHh1kWHDXAnnozCqGdZkrZcDgf9CCrpsgymwQTjZ8lqTuMMirgtgBzlxvx3IPK+WSPsR37VZyD3XVKkGQSuHt9Xx20xrJP5Q8uhv+hlNr0JUR6YUqaG5t34AoQ7TTlLtfOxUQHdM58n26tKpTjvoKbIbIjfYkT7lZexUSi4aOX6q6r2oHsfti5Ip7OcfxetnIXizM2bRzRrKyEtBAUivTLLwBn1CQ1apqAm0uq3MJHrU3D67wC8Pd1ZMRwyzjp5RnpxsZEY/KOuM47w0635swT7SIXT71FFHk6NtsUhaVvs4AoeSl1hhIIiMmsxvYO
 QfxZ2gKZ
 fmV5OYGeKSqKKzWiCDKos17r4hVgREChhiSFxMXsdfLvnh27AavTlyku2ArcQNRAvABOonTtyT/eFFd6w2IBV9a6hMuPzDdnUqRacPGF/sxWid8koQmGKthkWRpecNLGlfyBuGsg2gSvm2ZLO4W2jA7OiPr6OdC1g09fGBEuaNOIHJE9i1kpPgyt0Q315Y89Nib8a4ahBGTzJ0N3i5sS25SfCHtfvS99uJduufbAdn1Ommv3VN+m3rLDmXrRpkDk+DQ1a3q3wSbGYPCdo0UFp2wcgBAIcIK2VRfuoQqhWMXlbBU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 12:41:37AM -0800, Chris Down wrote:
> When oom_evaluate_task() comes across a victim we've already killed, it
> backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
> a chance to free some memory before we kill anything else. However,
> since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
> css_task_iter skips exiting tasks once signal->live reaches zero. That
> happens before exit_mm(), so a single-threaded victim can disappear
> from the memcg scan while it still has all its memory.
> 
> This can kill another process when the first kill would have been
> enough to recover, and we've seen it happen in production. If the
> second victim is in a cgroup with memory.oom.group enabled, the extra
> kill can take down the whole workload.
> 
> In tests I used a 64 MiB memcg with swap disabled. I started a process
> that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO
> read to null_blk, and goes to sleep. I set null_blk to take 10 seconds
> to complete the read so the victim would have to wait for it in
> exit_aio(). Two seconds after starting the first process, I started a
> second one that tries to fault in 40 MiB.
> 
> The 40 MiB allocation hits memory.max partway through and triggers an
> OOM kill. The OOM killer picks the first process, which has more
> resident memory. With the read still pending, the victim blocks in
> exit_aio() before it can tear down its address space.
> 
> memory.events showed oom_kill 2 in three runs. In one of them the first
> process hadn't submitted the read yet when it was killed. The slow read
> just makes the window easier to hit.
> 
> The cgroup iterator hides these tasks so that cgroup.procs doesn't
> show processes that waitpid() may already have reaped. That's fine for
> cgroup.procs, but the OOM scan needs to see a victim even after its last
> thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
> for sched_ext, so use it for mem_cgroup_scan_tasks() as well.
> 
> With this applied, OOM selection backs off while the first victim still
> has memory to free. The 40 MiB allocation completes and memory.events
> shows oom_kill 1 in three test runs.
> 
> Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

