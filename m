Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362C8C624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B86C6B0098; Mon, 31 Aug 2026 22:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A0E6B0099; Mon, 31 Aug 2026 22:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6F26B009B; Mon, 31 Aug 2026 22:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4477F6B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:21:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 484DC120285
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:21:48 +0000 (UTC)
X-FDA: 85163592696.01.5F98CCD
Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D11C1C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:21:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P1TnX+9E;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788229306;
	b=1tQcgwEea3d8PioSyXPIX8byWKgtx7UoONdvOxIoSsTk1HEckCe0E4tqvQGXMifoVRqpG3
	LG1OdLiuUB3esFNpB5AMOz9yIn6jJzHeWO71QfuhwrospiZNEsBRXVx2yP0DLMNNjyL7PI
	HLdyAn71CrW9yBOa330pbopQYXaki6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788229306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GsoixqskN3XZ9wNmTHAM1E6lcalDiIPYeVn2BLHRL2s=;
	b=O1r9j6PAtK5spaX+iZqrgqf1hyT45CsNDLJCryh1v+yrLbd6swfAdB6D5U9fWSkcasHnFb
	TXdqxDPaQzb6Y7BpyJY9y1TOSI7P7h1tFkea7LVXQ3H/mNOrl08UK2lynlK3omLUsMYL01
	tVLASm60OoChqWGmHLTbMmEU81qOq4E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P1TnX+9E;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7uPbtr2WBHUVzXJjAHM0J1bBu+jQncq3WQCDdhThYVo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788229302; v=1; x=1788834102;
 b=P1TnX+9EVvR12ORR43x+qcpOqYUD2nmqnr+KjWeoHBK/Mfg7V+sWin6bWVuQ3tJIYWtw7Mrs
 Iet6e771XlBGhAMmiaOg27rkns1urEIW5Ye40wQKUk0kcmPm/pETH0Yb9RR0Ai4RLx5PXplKKyw
 mxGi38v1cVcQe+0VTCt/Xsy8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2e88f73ed0aea6f1;
	Tue, 01 Sep 2026 02:21:42 +0000
X-Mizu-Trace-ID: 2e88f73ed0aea6f1
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
Subject: [PATCH bpf-next v6 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Tue,  1 Sep 2026 10:21:09 +0800
Message-ID: <cover.1788228773.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3D11C1C0004
X-Stat-Signature: xcbfaptcfdpcjud76sp38ahkuwxc831q
X-HE-Tag: 1788229304-967873
X-HE-Meta: U2FsdGVkX1+C93ieMWll6/qvlh8lB236PSNS+SoXikj/wpLLsXHzc0WegD6CIVh2DaetYAXYYz6MvaFme2av5hD+U0+PI+otdBt4jKSCBbhGg6daMSfbsAYaAldW+B1QycIvisVMoM6uxZUfeWhD1tpuWPizZoq1fEmdQenOXrVRJvwLr4QhrWlbsaqN9jO4/MJchAuAY23UdySYG5oF/Q4d2JHcXP0ZchohJpPQ5KsOgwknAQqpfWcbne7dsmKaybJorn2laDdpAhBPC0v64R2Y8V2enymMb/iduzhwDi4ZSbWBqcdPTyG4dP2HiOlzq0LokFXdDBh5J6Cmo6XTi8mZUASqnBeStzsgaHvvBwStRVyMijcKoOwPceHEvrqpl17qhpAk93xPiH2FmWPBUJwmK1ZAnWtHLfzKmb/ULQqFTyisnatDE2snL/1q3DSGUgTVd6cXRTTCvFQsCvIcqRbqv0kn603uivE8KtvG+6yA8fNo6UObAegaHUUdNGYWeOyct0H2zTR+9o3WKCduerbNRrx4GTXH21JD0ZNPP1Dr5XAjcRemoZbfo4E4miG/8N0c6jXgAOWyALe9zN3WR5RKqugxY2XwESURZ8MD/dRZj+mrM1jN8r9OuFvmFtby9KS+HFyBJxBoixZVbqsznJoMcbq0LYAgEuWW2N63u9eXlWmg/mL7AgUKoeTQsR5zFFJPPdi/fAwWsDbiEteu7CbjU0CuOifvdlieT+YNhU0qmIBiRdSNt1CWvi3r5LYN0VEjNqbb8j+IkyhJy0pVnYVokWV0wRgxfb1nRuDxfSFUei00hRnlej/czeUGWjgYVk9klNAliQ9J5hhmHUR9kH+FLMBAyk9HxmR9Z70Jtc84E8fRRGOtvctlj6qbX5eDHkQdvScFTaSzFMAy6dlcTZrS/JoRVhtZlku9jMAP7l/4EZh3fAsSuqiBO8HOMZ8iSSrUOoCHYP/IYhat9il
 LYOXYWaK
 mKt1VeLWakDW0R4uyfkdwdOUGwknljM9myo7rhyYIyoRi+BrezXY0amZCEReFyfUw6FsPzEJ3bLf6zotQLyQLiIAL6zk/ly1cpLePr8k6ED7yGatIfT2/N8u8ZZWIzIWpvNBeBmNffsH2qCgK5L0BoJaTnn0mNzBLjJm+YJnJRf9IpT7sXJrljnMBPKzhbEtVReVZ
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

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfunc
  selftests/bpf: Add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  76 ++-
 .../bpf/prog_tests/memcg_async_reclaim.c      | 480 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 181 +++++++
 3 files changed, 735 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


