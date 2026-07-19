Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB79C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C846B009D; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6006B008C; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090276B009B; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2116B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C84711C0853
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:25 +0000 (UTC)
X-FDA: 85006429410.14.6020810
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C496C0009
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=oSDCqezK;
	spf=pass (imf10.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=0vVfLvMaztsjjE2yz5CR4cqMrvi5YAOatcz+igYf5ZZlWfkvZpTN49AyF2yYWdW9I3f8VY
	CohGBtecotg5Z7vkfH8/aetOUwE2klhjVPi3arMYZYZCFxIPo75PI28IGML8bEKt1yNeK3
	wA6dVkjab+56973Ug+SqiNdYxvGr5xQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=oSDCqezK;
	spf=pass (imf10.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAzpNKpcNCtyrAHnItiN1RWU6bwJlMRMpPXgZD5jnVo=;
	b=YTF06fr8Mz+D9r2/qYfvsC1XHWw9qS/xg1nkJuMwpkCamrVTNBg5H1AyMMfIkloQ6ilcY2
	sOIjgR63Gw9kvnRXIGWCQUqVmSX/dTfOnoRcu72dF/W5XenQ2PDetMiP5wOVdHRVbMSNHE
	VkKZqz/ps05y+f6bmjAyykXHH4y8Yu0=
ARC-Seal: i=1; a=rsa-sha256; t=1784487289; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=McJqNokg8RJLtID0rDpHo9dZHGTcCImBNyjNUYGUNKx7Hy6zqpz3HtC81y5rc0sfXObKBS4Y+e3lTVp572kZ92nL9WRYPvz//dOHQDIeg+gxOl+WN+PHsSnsz52S5WD4bEC9Z53LbdghM0M9Ze7kQ74LRQEBinvoaEWzn3KnLUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487289; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XAzpNKpcNCtyrAHnItiN1RWU6bwJlMRMpPXgZD5jnVo=; 
	b=Cj+k8yjMZlLPaVGvfAwb5N7TWBlR2uu0H1Y0tQi/gckdCPxFbiix3Cp0dsDTOk46SEZrU85QatitPy3wLhs10Y95LVTBNhmKcpn50pPxVFVfZJZJSJtjy7hcCFYBaZdsTEQt2QM4cCTszi4dKGTXQw5qoLu+mtPUxiEs+BoIrF4=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487289;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=XAzpNKpcNCtyrAHnItiN1RWU6bwJlMRMpPXgZD5jnVo=;
	b=oSDCqezKKsi/qJYD/MBrcfiWX378g9IN6DcHLRiXs7+RN7K7Vq+gHxkoR4s4DpBV
	L2JKMZvU1ciBmMO3VARq/OG04R6t+GbSS0nZ1/VSTzyqv/lZKKlM6vvNI9KpBKFEJV8
	3guQw0Ax2RZ/tTah8w+9X8Z8wsJJ+ouXl2Xy2unc=
Received: by mx.zoho.in with SMTPS id 178448728809969.40393444362564;
	Mon, 20 Jul 2026 00:24:48 +0530 (IST)
From: Aditya Sharma <adi.sharma@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imbrenda@linux.ibm.com,
	Aditya Sharma <adi.sharma@zohomail.in>
Subject: [RFC PATCH 7/7] exit: route exit_mm()'s final mmput() through mmput_exit()
Date: Mon, 20 Jul 2026 00:24:09 +0530
Message-Id: <20260719185409.409685-8-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C496C0009
X-Stat-Signature: omcaq9mnuhk9uqa74kzbp1w94w33fagn
X-HE-Tag: 1784487323-974782
X-HE-Meta: U2FsdGVkX18OlxwEfBdSCL+LC8Dhc5JvhNN6dGyZlpHyPa8t1eKXJQ7nqKDaj8wVoYcBp+UkaST/xz8j3IXQtLWWAMKrYK6kYEnsF8a7fkDaDceqVo9zscLufDAstiK453+4PisldnhrBKB+6KcqE2pv1828O8qiXPswfl9Ud33gyUNiZ6WTi0GyjrR3RJmbBKfF1oRT7lczpD+VoHq99jGURLJ6uU7BHpaFSOx0/40Bz1EfS9OsBtupE2n/cun76AjLzV1kSLrovdOF7uf9rv98OGdCPqZCeQ9WZJw7w6pbUer/StB56OHSJF+up3yyAfoK3Hztswp0J8wj1czjTHC2lI56JKemaKeJBZEYCcBNmtYfpTsR8sAALZiHZxpCRzBIZUzTDVhSDp2GU2ZYkTCAKgJAbQWr17w3A4pKizkwKouViEOWvUMtT9WmK2oo9H8SUc9SkU1mXAWG/pAj/V2GvBU7tppGq1UX5fN2bxu6fD8Fhr7sTkH4cp6SiIrnT2fojKiUznAc9XU3TtX9HQT6UE0Y9lqh6tY+kOWWuGeeH6sg1+YdXHnw1nIauNh+DjH9uUYze384A0dTsgYBYX5RIvThxxIWMrAg6erhHzUAEZGhufm6bW5QQ/dBIVRKPnEdYuDLkhpuOSYX/jGvdvqQY+jVEoi6jFWXNgAsPMrH5UryDKu2E/SQNBOcgeceG5zg1VB7axouEIcwEBGIr1Ttv2KihHRckMwDmChTY7fAuWpmcF26sifW8SyjOR62NngEKo7NcxKw/ZUYyxJ8f+EXC5vfkXgs2jTZcaZQnu7q8m77mVH4zgFs7xI5TdIZYlTNe8Z5Pe090M3SN5at7rkeec4agvsHEsS4NMVc1fKk3ZV5gZ5IF55VNhH9BmAROoaWpGZ9/87MEVq542PE8Mg5QBfVEIvRfzikYP9uCYc3IIIzNIPmfYc+mY3VF4EPmRJsFO+2Iyf6WGisLiT
 x7z16ELA
 mTYtRza3tkqMeJfEG2MJoWX1Ol+RSosBh1iO4s0WmXDVFhRLhd3RyziZvdvHkFQJZsRLaKFvh0Fi4V1Y92tCzTCo+n1f6X21GXWj7Rh0309pYldrWhH63VKrQY1/iIrE9B8v3FSeKk0rXeRA9FlITeiXvUcTiqzjEjJ5QC5scKN6MSi8rdJn3irK6tyI3N/E7JbVAmlMFjISkDUXbxS04S9R/ZB6f62KplOLlE11mRhzWfHno+4b8a652UvCs4oyusMptuUO6uBDFStqwvIbZ+LKAaf2sd8hLtI6ibA/WBiJ1osGb/lCgjavWwPYWUxy4uBOkM8Nn7AUFkPBk+id2e510eQOIkgCrGPIs5VA0WwPhl3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes the series operative. So far, nothing called mmput_exit().
Switch exit_mm() from mmput() to mmput_exit(), so the exiting task's final
reference drop can defer the address-space teardown to mm_reaper
instead of running exit_mmap() on the exiting CPU.

Only the exit path is routed. Every other mmput() caller (get_task_mm()
users like ptrace and /proc, kthread_unuse_mm(), etc.) still tears down
inline, and if one of those ends up holding the actual last reference,
behavior is unchanged -- the deferral applies only when the exiting
task's own drop is the final one.

The deferral triggers only when all of the following hold, and falls
back to inline __mmput() otherwise:

- vm.async_mm_teardown=1 (static key, default off)
- RSS >= vm.async_mm_teardown_thresh_pages (default 64MB)
- the mm is not an OOM target (MMF_OOM_TARGETED) and has not already
been reaped (MMF_OOM_SKIP)
- charging the RSS to the pending budget stays under
vm.async_mm_teardown_max_pending_pages

Results, bare metal, 32 CPUs / 32GB RAM (31 GiB usable), single
NUMA node, performance governor, medians of 10 reps, THP off unless noted,
vm.async_mm_teardown_max_pending_pages raised to 3/4 of RAM for the
async runs (the RAM/4 default would reject a single 16GB mm on this
box; see the cover letter's open question on the cap default):

reap latency (SIGKILL -> waitpid() returns), async off -> on:
1GB    18.01 ms  ->  0.14 ms
4GB    73.71 ms  ->  0.14 ms
16GB  282.16 ms  ->  0.15 ms
16GB   27.68 ms  ->  0.13 ms   (THP on)

voluntary exit (_exit() -> reap) matches within noise:
16GB  271.27 ms  ->  0.12 ms

redis-server with a 16GB populated dataset (real heap, VmRSS ~16.2GB):
      292.97 ms  ->  0.24 ms

32 simultaneous 0.5GB exits, tail until all reaped:
      157.42 ms  ->  0.32 ms

below-threshold 30MB process with the feature enabled:
        0.56 ms  ->  0.60 ms   (sync path, within noise)

A CONFIG_ASYNC_MM_TEARDOWN=n build of the same tree reproduces the
async-off column within noise (18.01 vs 18.01 ms at 1GB, 282.14 vs
282.16 ms at 16GB), so the config itself costs nothing when dark.

The work is moved, not eliminated: with async on, the 16GB region is
fully back in the buddy allocator ~240 ms after the kill (vs ~283 ms
when torn down inline), and the reaper spends ~1.18x the inline CPU on
the same teardowns (nice-19 kthread, cache-cold on another CPU). The
cover letter carries the full matrix: freeing-latency checks,
backpressure fallback, OOM-killer interaction (an OOM victim is never
queued, tracepoint-verified, including the CLONE_VM-sharer case),
tmpfs inode eviction in reaper context, sysctl toggling under load,
and a freezer cycle with a queued backlog.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1056422bc..6f97d204f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -607,7 +607,7 @@ static void exit_mm(void)
 	task_unlock(current);
 	mmap_read_unlock(mm);
 	mm_update_next_owner(mm);
-	mmput(mm);
+	mmput_exit(mm);
 	if (test_thread_flag(TIF_MEMDIE))
 		exit_oom_victim();
 }
-- 
2.34.1


