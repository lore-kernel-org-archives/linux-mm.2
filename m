Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4B3EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280346B008A; Fri, 13 Feb 2026 02:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DF36B008C; Fri, 13 Feb 2026 02:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130A96B0092; Fri, 13 Feb 2026 02:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F37876B008A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:24:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75334B8DE2
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:09 +0000 (UTC)
X-FDA: 84438594618.25.F36AAF1
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8994100003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bLZRB+KC;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VwNvFdIKZszOyx5SX4bymsUV474G0+X1JTSop6CJF0M=;
	b=UCYRC+BOB4iAcz40wxPfQcgNPvRF59obrv6hMyTp3eiScQLneUJIO0wgmNAj+WOOReDxoV
	j42ZL0sshhOOmP8NsaygeoKg3531l89UQ4v3olGtQTwQIS21ZOSWXbvO8oop35OUwEGcEC
	vNEXMVhF4nUcBrJQYPpyMtDtW4/jf0U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bLZRB+KC;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967448; a=rsa-sha256;
	cv=none;
	b=thBenR31UAsU+fC8zBJjdEkf1ZPauAbM+UyiVZIn25nImsvD49hLD24T3HsGS+T/1zsfQ4
	By9AUJBEOxA3OqrKXw0PlA1Zc6WY3XyppAeshwnDiY8OvurHITBOQh0Y4KO5MGcs+o0MoK
	t4kNGoldZiR4z2O/LOmla8fC2nsE78A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VwNvFdIKZszOyx5SX4bymsUV474G0+X1JTSop6CJF0M=;
	b=bLZRB+KCujV6r+3tDxD/hCqTqrXaKPY5gKNVJCgqvm9HEhbrD39q8vpE7E4wD5kgiOVmdu
	eq3Sxy4rSM5H+g/vAMMjoAVUXltZTcZ7hYvyfJsPlHilNj02Y6e7JkSl0xQxzUDRmYi4BO
	fKZGFZsoa+VTnuaiC587gmVcpj4IImo=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Hui Zhu <zhuhui@kylinos.cn>,
	JP Kobryn <inwardvessel@gmail.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 0/3] Fix test_cgroup_iter_memcg issues found during back-porting
Date: Fri, 13 Feb 2026 15:23:38 +0800
Message-ID: <cover.1770965805.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wnfm3nmfgphh9amcs4m5k8n77o8s53qh
X-Rspamd-Queue-Id: C8994100003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770967447-75212
X-HE-Meta: U2FsdGVkX196jtMlFXE8NID9BlcjhXFDtst0DX2w8Y1+LUekGhJV9pEfnyx0NeGFyFEXU59w9TLzU5BapxwALXdrFjF7JhgWkdVSbP+mAhKE8xNS7h0qwkyi6eLlC++fHIAEA38KUb5xJI0wrfW+lHNmgDRfZrYmYsRmX5TBo8UubuYXUNyHgbrqV97b1fj+Q6eeYROAY4SDXKIAD25ftN9NMTKWI+AGFatHsQEpHUNNFjmuL4OT+eNpy4ZWFKoq9HyZaMiImXZwvOUsNnl09ro86ou1sgfiSPY6aWD1in1lpc3ef4w7Djus2iNyCQdz2Z0NBG8juQH7hVeXlJjqquP/NE6bkmyCPRsI7Me89NGM0b3spAd/niTArsRBwvCTT3BgqrakbKS1Lpoe62nWZsn5gcCeR9Yek1iqQrJkj8ksGr78aQ1qkpwY0r1j9zOZGSBOlRBvNGtkw+KniQZSEPL0oKhp3Jp4KgJf46yO+Ix8F9fW3/vRZxCJW3dXrLsyVS0C14ukR9W8aVeuZ+tltAYNht44D0eRicP6f+tVfKpMMx3tiu6lI8qsAVVXN14F6YscJgu50eYzOUNg4RwGhvow6ytN1JJNhBC14zZTxU6hQswXCrxWtKdjp1WYYvZRMgzOqdotoPpX7NXH4T7bfs66IZCprcUHEfOrym4X0MENGYuZA7FBb4qZwiOXjtVMqmGfREGsaQbUMmWljMie/piccfEoCk+TV06OwbT0QhFN1m1Vi+ueY8H/EvjdEAKy4+ArEmbx6Anere32dHgV0KNe32w6JxVYWNmdJa+nZ12p0X1zIvSj4HBIDRBmHQx7C7XiLtRg+dkXLpow56L21DShbU8uOAjCcYGhAOzvCGDC/IWoxuOaeXRC+ZqbZgCKpBgpGdRuZ/xhazW/FhD51+lhskj9q4rAtDtY5RDSDWhxx3oEu+6S15ea+sPlpQctZmTmarRau9z1qGjlkG5
 QyILrxH1
 zh5ZHjZDEXDkgqC9QtCOG1tn8wmV6sXpG+0bev7c801oKIa+Tfl446xn3NZMP4F5udE8qUS/BexlsWC8xW6UBv3LiMDP4Y0aJmDb3j5qOChfADPdzKAN92JgL2DtzS7JyzVFoU1cz/zeyCLjxPxKVQ+TcxoAdnk4VIpjPn68LNwzPHxuTEZI73xmID9po0mmZDINBgLkvYV0oQKFLl9sYMJdu5CfsAJLckjkiG6mbtsNJy1VeyAYm8x7KzH+Lv5+vnv4fSAef29i5stRjq86Nf4leVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

While back-porting "mm: bpf kfuncs to access memcg data", I
encountered issues with test_cgroup_iter_memcg, specifically
in test_kmem.

These patches are my fixes for the problems I encountered.

Changelog:
v2:
According to the comments of JP Kobryn, added bpf_core_enum_value()
usage in the BPF program to handle cross-kernel enum value differences
at load-time instead of compile-time.
Dropped the mm/memcontrol.c patch.
Modified test_kmem handling: instead of skipping when nokmem is set,
verify that kmem value is zero as expected.
According to the comments of bot, fixed assertion message: changed
"bpf_mem_cgroup_page_state" to "bpf_mem_cgroup_vm_events" for PGFAULT
check.

Hui Zhu (3):
  bpf: Use bpf_core_enum_value for stats in cgroup_iter_memcg
  selftests/bpf: Check bpf_mem_cgroup_page_state return value
  bpf: selftests: Skip kmem test when cgroup.memory=nokmem is set

 .../bpf/prog_tests/cgroup_iter_memcg.c        | 42 +++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   | 41 ++++++++++++++----
 2 files changed, 76 insertions(+), 7 deletions(-)

-- 
2.43.0


