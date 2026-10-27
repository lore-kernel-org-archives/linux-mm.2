Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62416606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D0C6B064A; Tue, 27 Oct 2026 05:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6147A6B064B; Tue, 27 Oct 2026 05:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529F66B064C; Tue, 27 Oct 2026 05:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 239AD6B064A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:12:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 214BE14093F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:12:32 +0000 (UTC)
X-FDA: 85367840544.06.7C02601
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id D29B340008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:12:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bA2/gm+I";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793092350;
	b=gMGfn1B9W8/IZROjnn7HaOoWChDbB9KP/gdN+WE2BydW5VTZxWd1YxkX/Z9QMZD5CeTYHI
	lIltkEWBjDFQ7fJZXMjhkRRih5mvRAuo3yg/bXmZ3+TvVXTT2KlfXVObIkefQo9K4KstWk
	YsNaFJUfxonOWpdaEnGWIP14kUUBHkU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bA2/gm+I";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793092350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ndi2448wVUZuF68kqWF0v2z9NaMIBNKc9nVCJQzYI1k=;
	b=MmIEVVhD6ThjnIZlwLK8eYbywEygrArubfuGNgjbfsHwxBBYj9dmpyg3YSSSRV0exCRR99
	UuJuNS0CTI1FDi2kbQ+4Qzcn6npKLLsFX/wbgJ5A4t0pTpj//8a79Sb+CI8RZygx4Lt9vP
	2K/tR4Pqra9vtQhPoCxXjk8NFy7FCtM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Iy2EZRXCQMOBxljPF+GT6qR9TSW/M2vcb/khwUxJInc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793092348; v=1; x=1793697148;
 b=bA2/gm+InVPxrA8/cUeuKfkv9tlw8WkJfCJkOBEDJtQCHB0HWSave9Iz76npyrcxJMqpPc1t
 uCc6jbvmBvAjzUUwt9MB4DHn/lLKKxWsS6jwJ3eh4ZlxhovExca29l8pVbWHLXsWABOthurUun7
 yDoOp3aXMoQ0FUfbTaxkhPds=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e68cbb451e1e33a5;
	Tue, 27 Oct 2026 09:12:27 +0000
X-Mizu-Trace-ID: e68cbb451e1e33a5
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min protection
Date: Tue, 27 Oct 2026 17:11:58 +0800
Message-ID: <cover.1793086858.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D29B340008
X-Stat-Signature: fsfcruoi88fe3dnzjofazwwnrmymtaqs
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793092349-847195
X-HE-Meta: U2FsdGVkX1+1xMJLtDBS2iMK4y9ExpEzo2lXqnUpmziWx4rLqdAq5hcW4EWpPNK8Eyvizkt5z1yhEZVv3E16VUQjNdgVhqAfOm+myqWxth+Vm7j60suXqFXLI3QjxtxS76ETSthJPFXtNctPZmgwe94uYfhuiDFJxNY7UssXnFqCrk+Y57keRfuIAqJDt9ZB8R9i9w2V0EV8NqMHeC4XZG3PYlbNXckWWz8do1kf+T9K5DIExERvyl1nHAwZXAgQjGhm/E2HZqt281xN32P0P1lpSaoUzi41TrQwJWLEmUEQdqkBXW50eJhwZ19PmijNMppp/YZm6QBN6gvmrf5C5AwlvBBbSbkZddlHmRxnl+oX8yebS4HDJE1vghrP/N6ba6WFSWSKLedw5EiXC6ur8XQ8KXpfkhRpAXUA0MKemb3txrwjfnQRd8TUn+7/i1chdXBAuhdCyt1VQC5DP3pBvKHW2u04+xT34OmVquwmn30BCZE7EKVk/vb/U/UWVFjrGksxG1Csz9Xtcr6xbbSkl5pa0R7p1aVE+D7W3OLd+Tuky0+3XiABCJ/9RUbnJSlxyCZ5QiOqS2ADui67hNAVH8l5klNAE0mvBHKmEd/OE6LrDEklda8vuOnaB9NLTOwEpz6yaZ6ew2FgaI49Kr+DkAPZ30JGyTmTlIWTUtmBTFJdiBqBgV7ZGBpjNLXJYiwdJ1zyh+PBBvzlWf/LgzmoNFiE0sLqBTaL9h6pfI7AN9OFq2cItQfJ13QYRJlaEVtw/JvlStbZp+6JpzE6T4p1a3aoZkDw9iof1UnLoiiV3dHvZ7rlueiBAc5eRIypMfyxvMOgWRe7woCAqKuPCoEZGocY0mL7UlKnpjJP/wX4E8uncd00twjr66jgUbFkZsaz+RxIdUaFE7XFs1WhQC7BcpFezgSRJlwIKFRmqys3UNY7VYHU9u+nkyxxEfdu3xm15is+9nHwQxsNO9CIXSq
 jCV6tx3t
 jmwemUZrioQGlP/9UwelbRaJcT2j829wkdztlNLJRN9/K5/ArEd4vZzKhPVvN93pMMscWWi1DjxmrQeqw1nZgIynykNTBQxWOssvWPLlsnOqnBB63sq+L4I4gChAMd7gj3TGEQVUUmrVi2puUZmFobfCf9olEI7aI+3Akod1lvJueeloa1++mz54+SkGMInw8QRtiaqGxM+WsWMPDFRJw5pX0mIjoS49XDO/NarVsh581QMBs1mZ74UCCoKi27RhFsq/vHhencWdBZ8mps+Ulm0aotRkfM/QtSFAgDjYGANlxtz1ISrY98Hox3UdIiWYT+efZBlgnET9bCz5Ih8y9isbKROsf1jBoCkGZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

This follows the memcg_ext RFC [1], which adds bpf_memcg_ops - a
struct_ops type attaching memory controller policy to a cgroup - and
one member, high_policy().  Its cover letter names dynamic protection
as future work; these two patches are that.

Why it matters: memory.low and memory.min protect a cgroup by a fixed
threshold and have no idea whether it is using the memory.  A
high-priority cgroup that holds a large working set and then goes idle
keeps suppressing reclaim on its siblings, and that memory is wasted.
A policy program sees the real activity - page faults, charges - and
can grant or withdraw protection as it changes.

The hooks are not new: [2] proposed the same below-low and below-min
decision on its own memcg_bpf_ops type.  Only the carrier changes
here.  bpf_memcg_ops already supplies attach, the ancestor walk,
result combination and the re-entry guard, so protection costs two
members and one walk helper shared with high_policy().

Patch 1 adds low_policy() and min_policy().  A program gets a
read-only snapshot of the check the kernel is making - the memcg, the
reclaim target, the threshold and the usage - and returns a request;
BPF_MEMCG_PROT_BELOW, the only one so far, treats the cgroup as below
its threshold, so reclaim skips it and counts it in memory.events.
The kernel compares elow/emin first and asks BPF only when it found
the cgroup unprotected, and ORs the answers of the cgroup and every
ancestor, so a policy can only add protection, never take it away.

Patch 2 is the prog_tests runner: attach both policies to a child,
fault 8M of anonymous memory into it, reclaim from its parent, and
check that both hooks were consulted and that the ctx described the
check faithfully.  Both answer NO_OPINION, so nothing about reclaim's
outcome is asserted.  A working example that does answer BELOW, so
reclaim skips one cgroup and takes the memory from a sibling instead,
is maintained out of tree at [3], released under GPLv2.

[1] https://lore.kernel.org/all/20260921192559.2619635-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/all/cover.1779760876.git.zhuhui@kylinos.cn/
[3] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_plus

Hui Zhu (2):
  memcg_ext: add memory.low and memory.min protection policies
  selftests/bpf: Add bpf_memcg_ops protection test

 include/linux/bpf_memcontrol.h                | 104 ++++++++++-
 include/linux/memcontrol.h                    |  23 ++-
 mm/bpf_memcontrol.c                           | 162 ++++++++++++++----
 .../bpf/prog_tests/memcg_ops_protection.c     | 151 ++++++++++++++++
 .../bpf/progs/memcg_ops_protection.c          |  72 ++++++++
 5 files changed, 470 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_protection.c

-- 
2.43.0


