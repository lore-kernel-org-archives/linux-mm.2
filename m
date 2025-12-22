Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D17E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8CB6B0005; Mon, 22 Dec 2025 17:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CFB6B0089; Mon, 22 Dec 2025 17:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82DE6B008A; Mon, 22 Dec 2025 17:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 967B16B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:18:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E77A7C0604
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:05 +0000 (UTC)
X-FDA: 84248520930.15.8ECD9B8
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf06.hostedemail.com (Postfix) with ESMTP id F02AB180009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y2Gmn3ya;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vsKpZybnVUvHz7hRUHCLmAtPAg5RYYwFpvXRG+uP0Po=;
	b=Xl7ZrzqSyqDwbVW/MOy+L+zXuP4PnwpHQDUGZZ61TjOoWS8cq1QdYTapUenBtBqfehPdpo
	AQiIH7uw67QC5/u5jo08I9LGKQAnbntffdye3epXsZPRUZptqgwyD2zquTbhK7D6wl8eQd
	uYQji5SGm3dAB2rt/OEZuPUl/9iX4Gw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y2Gmn3ya;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441884; a=rsa-sha256;
	cv=none;
	b=fl+IO5h+/V3XtdowMJCOrNvcTVXPLbQI94n7wMgyyU4J31P4TwulWo5QT/SIckKeeL9ZCf
	FGyxZenTFhgBxwdjpXwHkKIMF+90r/3jtIQt17BvZ1K0+2YhOdJw2XULE1cIUnPI0QvFXW
	HfDlrEx1kOkV+LDvtyv3dPw1W9pwM9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766441881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vsKpZybnVUvHz7hRUHCLmAtPAg5RYYwFpvXRG+uP0Po=;
	b=Y2Gmn3yaC40doAZ2YzgTJWK4Mk9JL7G8CzvInTpsFB2aqOmm1KsS/tqmTVGecBk8Bff1P/
	5n8hPp7s42NdiGMj8CjJwdsgmwJfA4m70E5g7xBd5DqoclmMy3aPxSMO6DL7UBg/Opkfp4
	QxnhCaTKiuiOojudbnzJTYAH/u+nrSw=
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
Subject: [PATCH bpf-next v3 0/6] mm: bpf kfuncs to access memcg data
Date: Mon, 22 Dec 2025 14:17:48 -0800
Message-ID: <20251222221754.186191-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F02AB180009
X-Stat-Signature: mii88faugbcfj73dh3ondfski1xra9qr
X-Rspam-User: 
X-HE-Tag: 1766441883-751472
X-HE-Meta: U2FsdGVkX1/KIsfdqAmg8sIwJadq9GTj5jcntSg9NS5qQRGoLVxeOUiyTWZ+Kvor9BaOH9ObTUc0W6RXa8gDEeXkjZHuv7eKMH+xAzOG4ij7qqyvv3KzUIG+TcP849xPepZ9P8N7bt/iuXxFIuGOLTHX21UjXkv7Lo3AMCHZ6JSMgh+sYqvKZBSzfuZX0AlhSVxFkdjlGzX9ZmwgB2Z07nlWWUQd5Obbt4UQ11l84awTbGjZ2zO2SrO41VTDRzJkDgyCfAxhRXbMP8gLZY7G+Vl1+acveN8rFejWYAqDQv1DkVm+dkKfVvfcd/fMiOpvPAu0B9BRrBEJbprz0n/SF0+SZZNWEVmfQV+4+Pmrp9xP+Ge7ejLrQxrFFfwusnwhJuJ3Aj7dvjPba0TIl+T6exwA/+zXPF0nk1G3UTfzL3gCmX8Z1ivGSdWXtBs7scV70weEEixrlRiOaxhTdJSzBg/XbqPatNllQNJ/K7WG2eK/HEsjkmnW3g6NR2HSDTIm4FyJOGO69M4WMUPSgdOyqOAxu3DNjUNQBD51GcWFJcmY2+7FcDfR6mFQPQquZoLGnxq2V0A6qRqOfZZh992wYSNqbXn9et5iUWKD29fKCQiw/yT4Cv42wreUL3+k3PDXEnXK3u/gg8VHE4fPVl3mF7vlwghKHua7Y5wNa3ajCdnWNeb50IGz9vPr54LzFpqwyBG/V2fBeCFqZuNUl6qI43gCf6+CjvGInDwz3NDjogMrCvVbAB3ZE3rPb7SS8ByOBtxN8BgaPKW0DkJYW7OpFyC0p5vmRbR3NZ/rnYVbEJZFfMw2wALFrr18d+a/Jw0BZglsX8oAAYKkS3+rM7B0uhNx3NuQNpWTyHSuLdFGsqw1Bt7qQlYuIrVF3gWCG1jtssBwa7CpZLErHJanLKVLgV8MW76yhjVg57tRPH4nJIqAxPRoCSTyWMUfjEJctxFGII/2bMIA2mG3eLgmYhr
 e/TcYbv2
 ma/+WBYz7lv5KDIdc5K4S5Vm461LyohY8ljud9aGjxexEX51I6Y1jPvJ1uzcuYWt4CC1z7sJDPD7S1rUpd2m2rDQJ1jHlYIgjl+v+Fnr6Hlr5F6ga/+z44BAQn2kEXxxJcQ7izQniIcUI/KPwU+XAn5/M/tmxwgYvMlNMqPIaf1eoeHOIanJoT4l42z2yZ8kXdxSoZ8T166KVqlCUvs9PYJiKMXV8n2dJuXok
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
 mm/memcontrol.c                               |  10 +
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 223 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  39 +++
 9 files changed, 515 insertions(+), 1 deletion(-)
 create mode 100644 mm/bpf_memcontrol.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

-- 
2.52.0


