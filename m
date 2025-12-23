Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99773E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5074E6B0005; Mon, 22 Dec 2025 23:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48ACE6B0089; Mon, 22 Dec 2025 23:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397336B008A; Mon, 22 Dec 2025 23:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8996B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F08113AF99
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:10 +0000 (UTC)
X-FDA: 84249488820.30.180E4E6
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3FDD180006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eSPxj8VF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464929; a=rsa-sha256;
	cv=none;
	b=2MhanSyYmCoXHj8TNyXs3o6OyIGe8oloLPGPiUfPruNVTI8JvYq9HcrWr9aybsqMTtIWEW
	KmZgSrpIpx3ENSVFApZZZN+i0hpozPWT6FUFWyE2Qeq6p6SCnhK6N4SXyBWPN9CkxancsN
	vM9mbbJCTR68jEutJvQoiNSINKZFiaE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eSPxj8VF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SjJvNSdwQ4A6e4PX6vyjBTwXtvr1QpS9I/j4kVhHdy4=;
	b=EYkoqr9iVvdiAZtXHO3YEEffeykoN1AFuAZG33KSZy62HbbLVdRpHkfaQgT9QswYUmdx4t
	/ZcxMV9bAD0P5W10ZS4wEgt9D3z5rEAWXCu0dOF+E/bgUhEdNrJsBHL4BjYsPPHQ2hVjWx
	ugpSkSCWd0LUgrAxrIm5fiVCvwl21M0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SjJvNSdwQ4A6e4PX6vyjBTwXtvr1QpS9I/j4kVhHdy4=;
	b=eSPxj8VFCZxBnerYcHV2YPXOcaJnq6PpJ7dqoZ7G3iHU6YXzZaNuCQuOjnKUSS7PnG8YnF
	SjTRSkx4Q6UjGIvW2uDwerwWfW8wUXnbjlcA2zJV2lIIR9F2j/fi4MFhgzwjTA/ntOiRu5
	Q3PhgpM6m3jpzs7AmfTPagoR9T7HhMk=
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
Subject: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
Date: Mon, 22 Dec 2025 20:41:50 -0800
Message-ID: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3FDD180006
X-Rspamd-Server: rspam03
X-Stat-Signature: otwngdz9bg3rnioh6h6fz5fa6j9c5mr7
X-Rspam-User: 
X-HE-Tag: 1766464927-696286
X-HE-Meta: U2FsdGVkX190t0tzM3ZQ8wV5BQmGsVJHCcGvbG3zp+hRFQhd9YXvURhPgnylkB4g1tSo6ffhVXyG0JBOG2+63uJWnfifuukcZOGNmgHn3GXMf9OEOGXAeTaN6l7sQ70noLeyHb169WRqOQrStgqotn+5DK8x2+8b/rh8lADPftO2VIgTwDkIDR2JAqB7Tyfti/+r/ad8/ebo4MC2HWaKcP2FgOe4Z0f0duboYcsXvfCp5Ij6mbhh3/+lGtFmT6LXGl8ntEtvjROoffYxE5pRCS216oqybOpsxrRNCFjrd9QN8yCPDMW3zgSeEtoh4vQLnI3gye6ilMHRhQcaLszFDs7+vYeDj0ZguANDd/9vuNtkfoS4iiCvkcC22FAS3Nx4VBR35M4KcYzZAnV4Bs+eHfl6j2g2UDZ/5CeFFCglvX5o0VQ9GJhkKbONqV1jV0x5bWhp4IQKtmAp3Ka2M1nfIx4wQorVBvqeeXQvauEqn99ecxpHuuVP3dRCAWIvxjmHSoD7Xh55vvXLUdlYWttbc8aA2hMx8wjak9mVs+io2x2LOxvm5b6fyCWjy9kJ8kTZApe3KuhTfjy/lxg8+fsLZiDa8++8fWdHKx5IuAmBUnYEJIRC4+S5G6Cgoy9/aMNWag83hgotLqG0ItEWKa1q4LxaxPP/4n0Bu9pMiQwsMGvQ4IX/A+A2yu1yZFkjAemqMDelNHAS9+qzeBo3DWDL2V9Q1p2fvd/aO1Pb4duF8qbMwV8NEeEloypRJAmEuz2uSmreFpql3AwRaDTXSbdFt8Ye0qaRVBI9P9w6PkFzKFrBy/jiFBINPZiT5OlwP3Lh9LXH9L2jqZcQQOR0Z5MtsV01n/IW9TJTuSEkSA15LE9KitfDaGE8gQSkF8pmhfZNnBglHYyLfct+IysJfnjFvwrD66h1W5MBXXKYwicMzeS+jvhcZXWKOhFlGptO4IQB4kTOXWoYjTROSY/a4CS
 lWsiaS6q
 xu8apQwSq/GPy54WgFtKzllSi6tM/abhA7YPyz+NNnE2CfdCQ94U3o2IP5MJ8GksCYnMxXSahOXtfaRLV83kpeGh7doWFzB0hchVToThLoENJFQjNOgzEVccgd00LAJqJqr/bBfFzJx3GGb2jVKBpfK/ZIkeygOyoQOYpf9bZhfUbQ5/cfWWUbRzHRwHNtTFsRuJ6zcXnvuWOQ5Q4t7PMpcQMtwR9dQBDIT0o
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

v4:
  - refactored memcg vm event and stat item idx checks (by Alexei)

v3:
  - dropped redundant kfuncs flags (by Alexei)
  - fixed kdocs warnings (by Alexei)
  - merged memcg stats access patches into one (by Alexei)
  - restored root memcg usage reporting, added a comment
  - added checks for enum boundaries
  - added Shakeel and JP as co-maintainers (by Shakeel)

v2:
  - added mem_cgroup_disabled() checks (by Shakeel B.)
  - added special handling of the root memcg in bpf_mem_cgroup_usage()
  (by Shakeel B.)
  - minor fixes in the kselftest (by Shakeel B.)
  - added a MAINTAINERS entry (by Shakeel B.)

v1:
  https://lore.kernel.org/bpf/87ike29s5r.fsf@linux.dev/T/#t


JP Kobryn (1):
  bpf: selftests: selftests for memcg stat kfuncs

Roman Gushchin (5):
  mm: declare memcg_page_state_output() in memcontrol.h
  mm: introduce BPF kfuncs to deal with memcg pointers
  mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
  mm: introduce BPF kfuncs to access memcg statistics and events
  MAINTAINERS: add an entry for MM BPF extensions

 MAINTAINERS                                   |   9 +
 include/linux/memcontrol.h                    |  20 ++
 mm/Makefile                                   |   3 +
 mm/bpf_memcontrol.c                           | 193 +++++++++++++++
 mm/memcontrol-v1.h                            |   1 -
 mm/memcontrol.c                               |  16 ++
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 223 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  39 +++
 9 files changed, 521 insertions(+), 1 deletion(-)
 create mode 100644 mm/bpf_memcontrol.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

-- 
2.52.0


