Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69EDC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA8B6B009B; Mon,  7 Sep 2026 03:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1E06B009D; Mon,  7 Sep 2026 03:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8186B009E; Mon,  7 Sep 2026 03:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD986B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:09:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB81A1C2621
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:09:16 +0000 (UTC)
X-FDA: 85186089912.20.95DB2F9
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6633C180005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:09:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LKJzNyN7;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788764955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5TLIqKyiE5qY/AYIoD/ltsyqF85KiCXp/e13SHds9Hw=;
	b=oWoypd2mUzqCuXRd1iAuKojh1J073lmYJ5t5x7a7rnOnZOZB+6yvG0aaKRkL7OIM7lUaAQ
	yBxyODxUaIHg84MIwrxQ5f+FuUmjbzuKO2sh7gMqtzHosEm428etTocWqzCjf3BFG6YE2H
	ERNOYMRKSmdOAxJGITOnaRZsfsMazuE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788764955;
	b=tGL+QW1EA0k9puQzx9DCHHh8xIrmjHqT3UKg91JwQQ38Eh2h0k9bt9iCyltgkeEp19bgdu
	i2rNLnbUhnpSnR7QGTYWdexxVF8MhvHAlmmgTeLX5qVQYel+t/T5uHkzXNQtOX8Ln1GXSc
	gL+XPPK4/8DGXYNf7Oi2CCkttgEUfCg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LKJzNyN7;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cMqBUKMjA5LqO1qX/pHGsFFtEHOiPyHSfU21KoovxRg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764950; v=1; x=1789369750;
 b=LKJzNyN7tGf20EM9DrpQX9xGvf9C3CruPGVFuy387y8d3GCrWSFIj+g9/7I4rsZUi6PKn2w3
 mKNAkurG8dEVyKUxCkJkkiTYd1LyPyc+c+5LV5dzQLY1LT1sPNqYq7IUtqy/ZReUuANUfrmbamo
 X8q71bxGu1Eiz6xhGKf7Vhag=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8e71fb95d3d7fb2e;
	Mon, 07 Sep 2026 07:09:10 +0000
X-Mizu-Trace-ID: 8e71fb95d3d7fb2e
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v8 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Mon,  7 Sep 2026 15:08:51 +0800
Message-ID: <cover.1788764121.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6633C180005
X-Stat-Signature: edmho8um3fjomgbhktuq76s9au57fnfe
X-HE-Tag: 1788764953-894194
X-HE-Meta: U2FsdGVkX1/YJ38g7LwX6eQ55M597y/AwvJJtVL3uAkqoILNPJrZ6ZBDcKVM1yCsqGZo9J0OpfILAxq4vhfxLEzGmiNlNAMG6yozx6CZfzTed/gM7cU/vc0ycrbuAag0m+K5ngfBPNHZkAORbzPymcagV7hqW+0j/0GhQjhsBYKdLMyphjfVitvoYHlxNsvCy38ZufStpoI2iwYT5jTz0BtT581ZcovhPYzz4L60DWhiLKqynm1GQdZ8XaU2GHwAp70PfzvG53Uvl81s4lCqE083uqD0fMCcGSNwO9HmNzH28SFAl5Oru5dPTu9Xi2LqiybYpqFy1d2v9LtQXsbyoo0PEBBOR08HMHuCjjXibC+9fq/BgdMZLbhmzyz59PG1UuFRmCj9BxE/kdaaRyKdZTkQ0TWtGG+bsOEhuuPHZjLSxpr4odyNSbJYsUbElgxfcEXupcMWTFVccz4jq3gmf+ysRGTC7HXNMsBNiqAiOTVeBOQrGs5ll69gw0a/uDlA/EwWPswnGkI6OlViJo0VwRXBRsKWzJiGvP8qCl0FpMXS+ALWL0EZu5lh29qtrOjt1n/Rsp1zpbR4Fxpf+rGRosmMO0wvdOclr3hPkffAgiqYeD2CoDcSF7RNvoCTAHWU2BdHEa1zA1buKEIygFf32jedNpSeWLTjd+VHq4Wtf1uCFxxpsHmYsmp1bgsbjobKDj5vgtZNEw3YH/O+WppjGBg6KYqlBk1NNoTpPu4kel7WV8E+pLtKWrJFrcDobc//V2cLALCnAEWWQgTKZmQgwI7HWO0oShLJ6R04x54Si6F93tcttt2T31sEd3+ReSOngW32X9NIylZdLf5VlmoCX18/8heRGIj4JobPx9XGU9w/sLWTBidX3/K8x27C4t/UnnfLH+00I1e/mg1v+K3/O+Tn/nz3yVCKE6D5y/M0LMeYlWVZW7GuPoCiHVHRGccQCnV91MDXhmM9MDGEvyL
 2NzHjC7A
 q4gzPw46yZR7jyGi8iBSv6gpNOk31JvtyzzsVBoWi8n3ow7sQrzIvu0enbBut6Ogq+/QNEC9cN0c9oPgH6OGZ3gpPYXo8USOjNNwNf55aSo7yK3pbFiVORZePFAMdUdrf/9XJZL8EeopjdHsFM9aoSxikNSzsOLVX0Zj2ME5fLGKU2bYdqKXgQksmm4lKgtkB8qML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup (e.g. refault
stats via bpf_mem_cgroup_page_state()), but cannot act on it:
triggering reclaim on a chosen cgroup requires writing to
memory.reclaim, which BPF cannot do. This series adds
bpf_proactive_reclaim(), a sleepable kfunc performing one proactive
reclaim pass on a target memcg, so when and how hard to reclaim is
BPF policy rather than hard-coded thresholds.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context: generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. The
bpf_wq and task_work callbacks of a SYSCALL program keep its program
type and run in process context, so reclaim work can still be queued
asynchronously through them, as the selftest does with bpf_wq.

The use case we are looking at is protecting high-priority workloads:
a BPF program monitors the state of a high-priority cgroup and, when
it degrades (e.g. PSI rises or refaults increase, as in the
selftest), asynchronously reclaims memory from low-priority cgroups
via bpf_wq and bpf_proactive_reclaim(), giving the pressured cgroup
more free pages.

Another use case: several vendor-maintained kernels carry private
implementations that trigger asynchronous reclaim when a memcg enters
a certain state. These exist for historical and partly psychological
reasons, but the underlying demand is real. We expect BPF-driven
proactive reclaim, combined with the BPF hooks for the memory
controller currently under discussion and development, to serve these
needs in mainline, reducing kernel fragmentation and improving kernel
maintainability.

Changelog:
v8:
According to the comments of Andrew, Kumar and Shakeel, drop the
bpf_in_reclaim_context() check because the SYSCALL-only restriction
already rules out reentrancy.
According to the comments of Kumar, Add the swappiness argument to
bpf_proactive_reclaim().
v7:
According to the comments of JP, clamp the reclaim target of one
bpf_proactive_reclaim() call to MEMCG_CHARGE_BATCH so each call is
a bounded unit of work, and document the batching policy in the kfunc.
selftest: check the target cgroup for dying state before reclaiming
from it, and add the memcg_async_reclaim_dying test covering target
removal while reclaim is running.
v6:
According to the comments of Kumar and Shakeel, Restrict
bpf_proactive_reclaim() to BPF_PROG_TYPE_SYSCALL by moving it
to a dedicated kfunc set registered for that program type only, and
document the clean-process-context requirement in its kerneldoc.
v5:
According to the comments of Andrii, Kumar and Shakeel, remove
bpf_proactive_reclaim_swappiness.
v4:
According to the comments of bot+bpf-ci and sashiko, also check
current->reclaim_state to close the fentry-on-trace-iter recursion
window in bpf_in_reclaim_context.
Return bytes instead of pages ( nr * PAGE_SIZE ) in
bpf_proactive_reclaim_pages and bpf_proactive_reclaim_swappiness.
Return (unsigned long)-1 on out-of-range swappiness (was 0).
Kdoc of both kfuncs: updated Return descriptions; added FS-lock deadlock
warning to bpf_proactive_reclaim.
Fix potential child process leak in selftests.
Use _exit() instead of exit() in forked children in selftests.
Rename reclaimed_pages to reclaimed_bytes in selftests.
Fix comments issues in selftests.
v3:
According to the comments of bot+bpf-ci, add a shared helper
bpf_proactive_reclaim_pages() that is called by bpf_proactive_reclaim
and bpf_proactive_reclaim_swappiness.
According to the comments of sashiko and bot+bpf-ci, fix the issues of
selftests.
v2:
According to the comments of Shakeel Butt, replace
bpf_try_to_free_mem_cgroup_pages() with
bpf_proactive_reclaim(memcg, size) and
bpf_proactive_reclaim_swappiness(memcg, size, swappiness).
According to the comments of Kumar Kartikeya Dwivedi, drop patch 2
and patch 3.
Remove bpf_thread_wq code in patch 4.
According to the comments of sashiko-bot, fix the issues of selftests.

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfunc
  selftests/bpf: Add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  94 ++-
 .../bpf/prog_tests/memcg_async_reclaim.c      | 686 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 259 +++++++
 3 files changed, 1037 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


