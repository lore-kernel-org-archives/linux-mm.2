Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B7CD711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DAF6B0088; Thu, 18 Dec 2025 20:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514856B0089; Thu, 18 Dec 2025 20:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E2B6B008A; Thu, 18 Dec 2025 20:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31A7F6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5A9AC0314
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:13 +0000 (UTC)
X-FDA: 84234560466.23.4616327
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74D0CC000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KWH08YEc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109492; a=rsa-sha256;
	cv=none;
	b=NyvHzjB+9WM6lXr0edGB9kdD5s12YLKPNgaGAhe+fN4G6N0GCTWBJM77D0U/IXUbFwwCCd
	hBKqUcvZaIu6iLVnf6jMvvWzT+nRbWqYTE8WFaFCXoqPditG/cKJo/3dKv1AgxUSpdhhWi
	63YmNEFIaXrI/XWasoWgOFQVlrAM5L8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KWH08YEc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L2xoCujIaM8urCKbtnvhzmEUA6Re927k76kBPypVsAM=;
	b=Dy/KnxAqqN+Y+PqSpnF3XDJGZlRortiod+tC26XjVdb3Vl8L85fy98bH9rWNVoIsZIHYGw
	i/ErYwkLKFymmBro7xAvAVbcO4Ae/I5AJXJneGHkMTjgQsSb9TOhUMXsfSgV2KlQGA2NW5
	0WjKo4GD+yO10avbNDnJGMBm7tvcwtg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L2xoCujIaM8urCKbtnvhzmEUA6Re927k76kBPypVsAM=;
	b=KWH08YEcj7C6mMQvC0lfQRUPN/zJanVLFFqax3ysRJi1W8cnghsrSM5QUDS1uBEUATGQ+R
	8EK9RZlyY1ZuRe8c+hsSZUFQ0IqM23cQOZEUNbdebKw0yQl+ZGFEjzCVOIvqczdIXjsPix
	8GsMwEGyXGDA30sjJgBKhJNuprh6g44=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v1 0/6] mm: bpf kfuncs to access memcg data
Date: Thu, 18 Dec 2025 17:57:44 -0800
Message-ID: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74D0CC000C
X-Stat-Signature: 6kx68og8641pmuqfmjppyyt4c81wpt1o
X-HE-Tag: 1766109490-321672
X-HE-Meta: U2FsdGVkX1/tcr2KJ8cfWFD4LzqbzIY80VQLTK9ePtIyfuc//T8/bYrDUevKRvR672fepkNqTLE9gWWo1cqIdxM5BS4AGSnYz4BZ7uji7MnEuJKacab8Mcd0qtI+VEYso4ZGAZ8crPRnVBAvzhybFbq9F1HJrnyIIdHLPneG/NvhPLiAHRgltouk6mg0tS8Fl7QeQqQ3bq8uQ0q6KA0wXmA/MV2e/N4Iw47HklWXBhf1ZpvYENxGM+yWhvn+qHhh96OXZvYsI1t1tGMGnqD8Ov4c22pkLsMGsQVpFFuZf1y8mHStuT7bdL1Th7037ExV7DpMwVc+K5hCuwCUmXAyDBXvp8cS7cm5ftHf9DXy0mgEhVZQFDz/ijRv6l1lNVMbZJ8oscc4WRtAzkr8SOA5N3I+bqjJKLIIJxnEoFeQ0BFROd/BtkFXsLn/8W599wxv29NQCdia0mHEg4DNZDw4s1KPU5oYufAcT4Y9mSLp2UxRWioX3U6utEb6HcdgYfvXKsKDQ8GFn+upSCC47oVLeeJokLna6GrXFSaX32kMlhykaUHDygRcA6sjoJtIrv9wxDTo+xPaRvmjFrWb6dltfxIHX/bGdoEyed4IoJS60dq/L9DlBjk3AB7dCjOLTdk2LddaCfkaTDqcxmcNU7o9GCSP27UyT66dg6hI+g7VEMfTEDZpTwK0K7tfoPbZ27VF8xaqZzGFzG+4qYEs3MkGl7KYGVTaREf7i1pwAnFqFwME6UCZ0NHk2biDUIJX9ZqSG3dpgI4wdj57axT2ViZveDf48f37GLAqQ+nCD+lj2xisS70ED1TH7fw8M//LdLZhC9QF6dRmVXaVCmzvgm/xagyIAUSKFqFByO9IXEUFL4PJocalq/1LyJhch0hwpaj5fjgtW1mwNzz+of7tRkdcLbvP593+X4fFiPIGMfLPVI5rl7WTDlyQpzdzlxFuxofG3IFWq+UTRNJCe4NObSZ
 tIwB+HHb
 TUUS3kNZ0mUVtpt7fLhYISV/5bdaetcPGxcOhZEEQBQL3wVWu5W5A+Riueqz4YXYWRfmHIYQXuKWtJ2BaCrHVODIvZ3fMmBRc/dbXxKg3s7j2rmIN+cuU7jc4YaSKLpnflfBUvwxw6B/kgsCnE0O+FWz/SPiD4TMK5upf3vogxB/c2Q+gwlSN51R17457pwq8d5+J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce kfuncs to simplify the access to the memcg data.
These kfuncs can be used to accelerate monitoring use cases and
for implementing custom OOM policies once BPF OOM is landed.

This patchset was separated out from the BPF OOM patchset to simplify
the logistics and accelerate the landing of the part which is useful
by itself. No functional changes since BPF OOM v2.


JP Kobryn (2):
  mm: introduce BPF kfunc to access memory events
  bpf: selftests: selftests for memcg stat kfuncs

Roman Gushchin (4):
  mm: declare memcg_page_state_output() in memcontrol.h
  mm: introduce BPF kfuncs to deal with memcg pointers
  mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
  mm: introduce BPF kfuncs to access memcg statistics and events

 include/linux/memcontrol.h                    |   3 +
 mm/Makefile                                   |   3 +
 mm/bpf_memcontrol.c                           | 175 ++++++++++++++
 mm/memcontrol-v1.h                            |   1 -
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 223 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  42 ++++
 7 files changed, 464 insertions(+), 1 deletion(-)
 create mode 100644 mm/bpf_memcontrol.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

-- 
2.52.0


