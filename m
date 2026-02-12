Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF76FEDF055
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9006B0005; Thu, 12 Feb 2026 03:23:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7568A6B0089; Thu, 12 Feb 2026 03:23:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D176B008A; Thu, 12 Feb 2026 03:23:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5976D6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:23:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A06E16072D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:23:48 +0000 (UTC)
X-FDA: 84435116136.10.6BB39A2
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id DBF6C20004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:23:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XijP+Aja;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770884627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nG1F/Kmp6JwkFcrp15JMZNDubf9nKflBRchreJY3ZlM=;
	b=COB51w3TmOW06IJUpSDoOy7ZOu47aOWGn9q6/+LLuiNll0Kjs3vhpspCjrtIlYPDBDjo53
	oQszJvFe7HotCV56TEoM+EApaL3ls9HIHiqW5RrP7nhINiSkspgO5oAD2E3kS9KardvAoG
	vb2Jt1Hz4Wu3hCUNIf2eAk3Qf7IBfkY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XijP+Aja;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770884627; a=rsa-sha256;
	cv=none;
	b=bTIeSNcS3++klFS84DuK6mYtIwi3TNPTiCUUN+X+UXsVD+wxqu0/IvFdk+bA9MLhcofhC6
	9StP1i/AbGRXJpIL3u6TwTMOXeveRAdTL7KniMO4n7gGFNhHFjZcKOcxM1jc2jo9AzRFLU
	G+gm23YM4LDtMAjlFN/KG+3+9fbppGg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770884624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nG1F/Kmp6JwkFcrp15JMZNDubf9nKflBRchreJY3ZlM=;
	b=XijP+AjafbjgMxF/DSBHdAP+2rp4pvVbeq7EN/TaXPqfY/pR/Rh9/uS4pSE0MRoKKY/n6k
	29dxRtBU7+TC7UIz82mkX2pafsIH8X30sEEfHjJk+VFee9nJuGpQeBsMg7Lg7hjZ7kl+Xr
	6cLpO7nAWVNrWW21hZwdyYyQKsgRNFk=
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
Subject: [PATCH bpf-next 0/3] Fix test_cgroup_iter_memcg issues found during back-porting
Date: Thu, 12 Feb 2026 16:23:13 +0800
Message-ID: <cover.1770883926.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: ziufjoto6q3gyfs1z18zorwsb39wcnen
X-Rspamd-Queue-Id: DBF6C20004
X-Rspam-User: 
X-HE-Tag: 1770884626-500195
X-HE-Meta: U2FsdGVkX1/AOG5wP4f6tiniZLoY3gbEOyCecUW1nvNeJvkNxClaOxxzDMuApkq3QT7gtC5hyXeWsZ9dKO5Xa6XtxL/cMfqhF8wSp6Rdb3JIm4ZP7nNel+Zi+vcD0xKbCskeRT7hZWMCezQVRHFuYRQNzP7ve9/b7mFXKeIjiPdF4uCDtsg98lEk5cyDXXW4D9V+nUJiH+sQL24sbAYE3oakAxWpqakVOrv9tGpRX2MjwhmX3WhPX6SIGeUOb7y8Hfb8s9IPv0zDspgHTsQrvPrBL1CPm3r8HgtWeZgu++lB+uWo2EoX93V6XLKP3z3ARRKbFkdBa8IqWSIo13ePnbON72f/RDPOqyXhYmfqyaTY0b32T21TSWDpzoD4LNF8rxM65+d/ZQA3OroMBVvbWtNSSDJG2Nfb6wg6G56t4WpBif9dF/Bz0tkW2AUrvn+fIhTWyDfEzPXr637gqV7wCfCAoYp209oohQ9a8Ad9w0zV/ED85HFUj0LgKdknTAHqp74Okk2TJ4W409rtYP2fOiHEr2tI/AoiTI7/SYcl9oFK9TjXUWbyaGMDJqv6xiQ5dDqPXQxujBhR8HLp/YtJ/Adobv/pNBW7ABhdlQ4RF9QHm+7kDY5hHlsvRqNriKT1Ywv4uLYL6EhDRSTYUx1uefLXlePe6/1HPfkU9/yVXoFSJnDveRw3nnB0XUlYMPcPw0Xhbqr603dGDCuME6re6cwePfixJGxbAI6AER9qvTn6mVj9tPjw+EqJFjY+Bh+e+urOXYEVZSL794UQ4iJWcfks4JPPQstcFM5yytuVYLYp2x2adJ+y+N1qiaUgtBi3b+8ZACo6ct3S8OKQ+MkgWQyocIAA1SigDrUUS+nczFutGf7LlCFdw94I/Y7Ii6J89CG/eP6lXZQcSnFMlqr6uG04Bl0FgzqaA8cbaY/egJzUmH18XPiApbSnAeaGRZuxJk4ZChleaco9V/L1+6Z
 pg284We6
 a0ngPKZ/Um/zvoQvzOy7lQw//lFT0dtpBIGZ7mnHcTUCngdk4WVCSJw9Ym8YqkR9CYmtxzhFv7RjpOcbFVrCwExSXy6P+wXXEmzoN9OHAQyOFL5WtKkgO6SOR2AyCkdGPcJWHgjA56Xp442YsV/RtIbxnJApIg+0OEAKg/rvMcVGCQ3BBXwk5deyg/IFjZ0b5vEhaMHBg3k0I2XYbQ0h3Ygj1T6iafzZTwde9vvWCSQhmxeMmu0Z1dUnXUNTBT3wcjD1DdaS6djZi+bX5t4OA5VoXBXcAL8/9UHpYHzIzFNROrSM=
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

The test_cgroup_iter_memcg test would falsely pass when
bpf_mem_cgroup_page_state() failed due to incompatible enum
values across kernel versions. Additionally, test_kmem would
fail on systems with cgroup.memory=nokmem enabled.

This series addresses these issues:
1. Add return value checks for bpf_mem_cgroup_page_state()
2. Return error when accessing kmem with nokmem enabled
3. Skip test_kmem when cgroup.memory=nokmem is set

Hui Zhu (3):
  selftests/bpf: Check bpf_mem_cgroup_page_state return value
  mm/memcontrol: Return error when accessing kmem with nokmem
  selftests/bpf: Skip test_kmem when cgroup.memory=nokmem

 mm/memcontrol.c                               |  3 +-
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 40 +++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

-- 
2.43.0


