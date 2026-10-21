Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E274E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uJEUkpII
Received: by kanga.kvack.org (Postfix)
	id 1B3C76B0599; Tue, 20 Oct 2026 21:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1647B6B059A; Tue, 20 Oct 2026 21:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07AD46B059B; Tue, 20 Oct 2026 21:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D86C86B0599
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:35:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61FA31403CD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:35:38 +0000 (UTC)
X-FDA: 85344916356.08.96D2039
Received: from mta0.migadu.com (out-168.mta0.migadu.com [91.218.175.168])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB5A0100005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:35:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uJEUkpII;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.168 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792546536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DrsebUbLp13fzrXzEa+wLSyr3pCfG+dstsywGVgOW8=;
	b=SWxEaucjrTH7YCifk6XW/6DFcw+d5dhCx2E507aSVZ3pf+MpNseXTTPIk5jUhyoUNoU3cE
	Ic1yuDGXPtGomVHad1k7mV24aHEDtkhjgbNHDaJE1QFusSncqafJJLoB8wIBIxNcdFZPBZ
	xd0it3ZR5pXTHbDr3SvPCAEPLor1hgI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uJEUkpII;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.168 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792546536;
	b=qVp3VQV2lgBuFlQwRl8xxmfLvgl7xNEeXhbQdEACUMu7LLFm8szvOaPGTu5r5kTS5k1QgY
	ym2TIj3XQU6s9cUNBOxe9aMdVmGDafCIC/STIpxJ8509cKcxyVJgjXiQgU95aLcmBU4qyX
	3iWpscD+NyW0UaX3PS/PtxP3+X+JEO8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=U4cwMEsU5qtx0w9jQC7lKQe8YciLG2ZHaqb1h0PZGWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792546533; v=1; x=1793151333;
 b=uJEUkpII0xASAFqy+OyFz21nWdXbOvPvi06zXr7G/p7WjwYCqAgEbjhmxN5aDi6MqQfNzXEV
 1HRn1mT8xnhJBgSdHeJ20VjONagAJncpXCIKbWHS5ia8nNFOT6TQveSqergfFbO2unjJNmed1o9
 lWGx6b1iBzmzWg69aybEyxD0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6f2b2204164ec746;
	Wed, 21 Oct 2026 01:35:19 +0000
X-Mizu-Trace-ID: 6f2b2204164ec746
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 18:35:16 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: publish null pointer before dropping
 css reference
Message-ID: <atgWux9N9a47BHE7@linux.dev>
References: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB5A0100005
X-Stat-Signature: 7p9zzkpfih76fihwmkiy9cwtygqgib7o
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792546534-641624
X-HE-Meta: U2FsdGVkX1+QN96Z6PX8tlkjXmV0aGClgOxOJxQuYauGUqxsB2/c5rZl3P3ZSV36lRa4GosCHNd6fjXpjrWBLrpm64LD93trkAZITJ0CpnPXVJlM/tVQPblyKiKf1JhYEMYM3cHX628wNeRSpzANSZZWKAcmn51GrsTH78hFVPVd+4M25QZ7DdIQxMALOt2oQJwt2V5nhoVm+VU0XVr93Ve9tMJoP21b1m85zxaNEkLnvLazmwVLlGKi5Zh6rpPUh3fSy7Ac+eOTEXAvUs1NSEsTvg+RDwrXchpIrb8JTamG4Svf4x/HcUHYhzvhI/wg8s9DE29DYEQ6FaAk+801RI6jC5Hqbsw9wL9TlHdAtUBWB832m6JNIzOEEcgFClWdNy1C3nfllSUSWfuhLmzXDQYQnBiO7I5Ah5loYRNRZbJy018vKbaKWg1o49uzjy9xziMic4QIAz6JfE6sYCOR1kHPhQVO27etv1/s47lEVTzcNnaGFw7fdjp4pQZzKp770fsHotHeeMtUE9yDDNcy9jvNtXCm9/mOjoEY3Mfgm1JXRbmRUELR7HLMZiNDDRNIdTEJVAXL9q1vn0G1ODpUXiCgMB1r9wA/f2AwgKwz8w5s8cwaASqDT34qnXAnM2cMBFxVcTfYLA0zY3PDnLL44vR4jhZ3gsZlpqU0X4yf/jkMbT+vbr8K0OJjqTfTqax76GIeBCrtkanR5HsUn3TxxN38FPInoXjeCL1on5Hhp5sdrf8MFFfLrPzdCB+mSDe4E8Qjxe28ppegrYVoEeyrtEMNaQNcyQtCVSafa+shIEy/SLWfQQEmvzsi8ZLHaZrUOP+5iKiMWZbbShgo8AXYQvAwA+Jyq5cb2tK2scdhhkwmt/FCjvCTpLbwxoJq1XOQugbGI7AB+mUJc4wTxPNxUsdXRndnu0/DUYVaRLn7kCi1Pvx8T4heG06ywBu2Xg8IPb608JzBVKZOVV+bFns
 MKTERyCn
 ZRSLNw1JzIjpAcYoD3Vn83YDW+GyF3+JIXg3KCpUyVGFkXnpyRUV/G0MmXFanHlcW3AL9dizX9wpxs8fw8QeVmVbWrRctGYAKDxlNhvm4vwbPt6fXqNmqfJl5cD2wj+sZQvBq9iHDmiAienaPAez8Jge2mIhlXw12iF0+lE2553UX0rGN137WfjMcAA0IZ5DUUOGCvtPxJgNi18ky7mpqCWEnO8MqfEMa7aY2mt3rkNc8TcnZpRmPxPL7K2f8/thNmZxcItc+lqViKFu+mgcmynJHkeeBUXDt+iFL5vGq/gM8fC/1uGj6sHKeChk37ffyWAXJkY4YT21p3skUIrqN2qQt8k4RkdktdOnMzcrXemL37tumZGHt3Nl0iNi0SVkRmewmm6ulf3t9VSBR5NRIV1Dr7imdYljHQZ5fSXZQutfk87aqYrC3TeoYksaYAjcAOkXlJ9rc5QIR8e4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 06:00:50PM -0700, Joshua Hahn wrote:
> struct memcg_stock_pcp hold references to cgroups that it tracks to make
> sure that the memcg never gets freed with unaccounted charges still
> living in the stock. When the cached stock goes to 0 for a memcg, its
> reference is dropped and the cached memcg pointer is set to NULL.
> 
> If that was the last reference, the css_put would free the associated
> cgroup before publishing the NULL pointer, which can be racy on 
> PREEMPT_RT. To summarize Shakeel Butt's analysis in [2],
> 
> CPU 1					CPU 2
> local_trylock() takes a per-CPU
> spinlock, which is an rcu read
> lock along with migrate_disable
> 
> drain_stock
> css_put drops the last reference
> release work is queued
> 
> kworker runs css_release_work_fn()
> call_rcu() starts grace period G
> which waits for the refill task.
> 
> <preempt>
> 					drain_all_stock
> 					is_memcg_drain_needed()
> 					enters rcu_read_lock(), but
> 					 grace period G does not wait
> 					since it started after G did
> 
> 					<prempt>
> 
> stock->cached[i] is cleared and
> unlocks. Grace period G ends,
> old is freed
> 
> 					mem_cgroup_is_descendant() reads
> 					old->css.cgroup which has just
> 					been freed.
> 
> To close this gap on PREEMPT_RT, switch the order of the referene drop
> and the publishing so that we publish the NULL pointer before dropping
> the reference. Note that this can only happen from drain_stock who can
> hold the last reference, but not on consume_stock since another
> reference will always be held. But fix this in both sites to maintain
> consistency. 
> 
> This is based on a report from Sashiko, who found this pre-existing
> issue in my page_counter_stock series [1].
> 
> [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> [2] https://lore.kernel.org/all/atfMngq7nyZpt4u-@linux.dev/
> 
> Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

