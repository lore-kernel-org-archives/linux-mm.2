Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C9BC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771066B0088; Fri,  4 Sep 2026 04:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721716B008C; Fri,  4 Sep 2026 04:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637DF6B0092; Fri,  4 Sep 2026 04:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4219B6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5B4B1C2BCB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:22 +0000 (UTC)
X-FDA: 85175407884.21.4B4034D
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94706C0005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SwyJQPQ/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ncUxllqf1cm3UfR8JP1JBVu1ZMGk05vegR0cYzXRhK8=;
	b=L2XrTcNiV9GHcZGpCmbx1YbpdylpyQ/Nor4ZmgxV4PrbI4gS8A9F2F938JfsgMWnt3UGO9
	gKa3Kt7Sj+wqsEdIup83CPTMNwV/pLG3+IpMldPLd1ykKWev7Kmn5jNwF3mHn+wJr1uBGY
	KUJa/0We+PicPNBfqnCt6MtkkGNnYro=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SwyJQPQ/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510621;
	b=43Vql0d6pZKOJPLff9F0ZRgOp/Qtj6eglt6RX7HGJqDQavxzIrd3f5F+jub0L8Xe4JElVt
	x8wN9c5JcYNy78UZlZ5mrxR33t452nae69s5xTXqZKgnke9AxeGWMkFSnJEtKV354qo567
	1A0qUiWkST8AHe8bbwtvF4vvpTjCECg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L8pOajLjq6OOGJ6hOdj/9J4YnLULNmgvV3Ddj6iBbVU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788510619; v=1; x=1789115419;
 b=SwyJQPQ/JsqB0G+VQvAHfhOqVMDhSiAIC4wNpuayZfNUeVrLxXBB47YPlyrxfXF8weTMjmWD
 zMtG0x5ODFmBJzGTVqVb61iOkElSJupyRY8r1iV16nqYAs4x+/s4D9BsqoaCZ/mEJaMkYbOwXPG
 MHZyIm6+6Ci6OKgaWZX8Yb0g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c4aafd7d2505d2d3;
	Fri, 04 Sep 2026 08:30:11 +0000
X-Mizu-Trace-ID: c4aafd7d2505d2d3
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>
Subject: [PATCH 0/8] mm: introduce for_each_process_rcu and for_each_thread_rcu
Date: Fri,  4 Sep 2026 16:29:52 +0800
Message-Id: <20260904083001.553587-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94706C0005
X-Stat-Signature: g79s8niib6h4wsx7ysfo5f877eoyfma1
X-Rspam-User: 
X-HE-Tag: 1788510620-691709
X-HE-Meta: U2FsdGVkX19P3hFWQ7JjN58Gyc9QKq+8eAvlkERT3U8imgv9dpq4OqBBPC/kuo4JUijrRg/sr0j/vp+BzXf0fZYPChUeWEvyaRwzgwRbC0vPh1pqQj7Hjt8JqX6kA1Z/yYXA31PYhIKc3FhE0ky8e9krc6lIWaN1nDLectmJALh7ljte2JJpVXHJRcqsXS7lkfEyjGBFF9aDCQY8mjMHgloeZswwPkpK1CbXtmWq73TNST7v8yaKcH3ocDgpvom1t48McswPSJ9yRXlm9suYanrl2mB07TpFoU43HJdExOIWCA3Ze3CfyNfkCXAKLh9VSxCmGB7BHL1TdLaNGpAOKUaggAjrreIEsGBFw+QYqy225RJmJMuXE6HnDgIbTflvS+4WvR6iKDsWx7uyA7aN/n/V+Mr+k9oSm+NwNv2P2cyYo1G/uN54oCMby2AaURHlWcVaJv/hZpukwl9jFOQyxjeR1Cb4mo951rt8MrS0aROZl3tJxeQ3cFCvNPutM2xtRflaq4laPEpap1cTo5SMD/OEZgpMrVMjF7TFwGUEkVBcTOVjxhARs/nhR/m85ra5LqKW10O2cUQBDCMgetWuYBmB7eCXfasVGw5YGVgwZB7RGWBkI77L/Km+8FzfT1d9/dSv7a2HQa2wT0UyjKZsBtMHcGYawiHU3mTg6iPWZZo64g0FFH+ebMfcZ4x9abb9NXgZfgsSgqDt5C7KOaY0WOk7l268eBPH2sUpG5bvexfPvYlclmjKB4xHGx+WiggkDCcuMN8Xg5Z++BqEKVfqVllzZFx2LzwJBWs0cnadl8/UL4soaOqFSAaur3o6WxGotSh8gzsOidDjYgINvIxzCkQ0EEcd70ayFxhBhdgjvFu/jsyazaBAKvO6QH1pHJRhY2puwJWYMyAtB0NF+qNDxWF7bLvyDA1xcJgeP3v3U2fZXmWy5vwUtU7hXGi60H1ocZxl2tQ/VdrVE5k+vy2
 vNDBWh/L
 18H1JCvk7lF0oyfL9bqBk7+ALC3Uj3UxlisHIB78w6KL6zUw+Gib9xFaNsA/RWpO4GHcpC2Y6MkgAKfltK8hT0G+2ihGcE9+3hKZDpbjJoiKC+xsshFSPe2+5CbZTKdAMBfXZvtawIdoAc0jMELzEnjPbDyMxGsHGt8P4R5HIa9/fAynH0U7qUaWSP3HDar9KBapYmQev22x6MRRPiWHM5OhygYBYZhgQ5Hz3XSNhNvtYj55E0Caqo1rvu7UlcZZtOL/wDPWEBQCMB1nvzYxHbjYFHfAquMy9Kdjhf9/Rzu+tNqdOwOFzSbdvEcXjJGyhP3oMX+Xc1s87OeqNACaAy3eqeJyjNGHAbn4mgWbPW2u8XeMgWAZpgBEPGEiraebBSr0gNmEKGRfpHRcJ+uRR5kbjJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Introduce for_each_process_rcu(), for_each_thread_rcu() and
for_each_process_thread_rcu() macros that combine the existing
iteration macros with scoped_guard(rcu), so that the RCU read lock
is automatically acquired before iteration and released when the
loop exits — including via break, goto, or return.

The rest of the series converts manual rcu_read_lock()/
rcu_read_unlock() and guard(rcu)() pairs across mm/, kernel/, fs/,
lib/ and security/ to use the new macros.

Patch 1 may trigger checkpatch "Macros with complex values should be
enclosed in parentheses" errors.  These are false positives — the
scoped_guard() pattern is a control-flow construct, not a multi-
statement macro, and the same idiom is used elsewhere in the kernel.

Suggested by Michal Hocko for the oom_kill path [1].

[1] https://lore.kernel.org/all/20260813092933.562028-1-ye.liu@linux.dev/

Ye Liu (8):
  mm: introduce for_each_process_rcu and for_each_thread_rcu
  mm/oom_kill: convert process/thread iterators to for_each_*_rcu
  mm/ksm: convert process iterator to for_each_process_rcu
  mm/memory-failure: convert process iterator to for_each_process_rcu
  kernel: convert process/thread iterators to for_each_*_rcu
  fs: convert process/thread iterators to for_each_*_rcu
  lib: convert process iterator to for_each_process_rcu
  security/landlock: convert thread iterator to for_each_thread_rcu

 fs/proc/base.c               |  4 +---
 fs/resctrl/rdtgroup.c        |  8 ++------
 include/linux/sched/signal.h | 19 +++++++++++++++++++
 kernel/cpu.c                 |  4 +---
 kernel/freezer.c             |  4 +---
 kernel/hung_task.c           |  7 ++-----
 kernel/locking/lockdep.c     |  4 +---
 kernel/rcu/update.c          |  4 +---
 kernel/sched/core.c          |  3 +--
 kernel/sched/debug.c         |  4 +---
 kernel/trace/fgraph.c        |  8 ++------
 kernel/unwind/deferred.c     |  3 +--
 lib/is_single_threaded.c     |  5 +----
 mm/ksm.c                     |  4 +---
 mm/memory-failure.c          | 16 ++++------------
 mm/oom_kill.c                | 20 +++++---------------
 security/landlock/tsync.c    |  8 ++------
 17 files changed, 46 insertions(+), 79 deletions(-)

Signed-off-by: Ye Liu <liuye@kylinos.cn>

--
2.25.1

