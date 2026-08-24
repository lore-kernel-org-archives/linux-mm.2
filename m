Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0623C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB3F6B008C; Mon, 24 Aug 2026 12:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C506B0092; Mon, 24 Aug 2026 12:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E4A6B0095; Mon, 24 Aug 2026 12:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABC26B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:05:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 085441C0902
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:50 +0000 (UTC)
X-FDA: 85136638860.17.D1F3AC6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56A32100011
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vw1mzenU;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r8ZiiYT+9qVzSyjIbRiqcRyxSZUtJgeMflUyVARDCFk=;
	b=JhclVGOf/4kKaQsuszSvmVkeNfmcho4/T3fUg8kRLTSL/pkIeH7SWmrqyW6jJLlshAIGm0
	EEQFORuPuXOJZLpa9j3setyVS+N347qMfAP4e3jiovbqKq211YLMIyC85iRRmakLv0CxJb
	9zF+ns2y4jD+NcQS5geyy7APga92sIo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vw1mzenU;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587548;
	b=M6DZvtffJI6VLOb1+abzLbI8lxKgNT8fwyNXiPfqxBMjEcKmb5kqjfNWDYhugZ/KskqZFt
	/eX9A7Jnhc6Bd+DZSMxn8KmBpv6L93/X/o5+nmhpFLbdvwD2dkKRa+p0YLsRbW5ohl5zxN
	Z02TDjfhHqT/7tz8RkRHx74evXMPFKE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 492D816F2;
	Mon, 24 Aug 2026 09:05:43 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DD55E3F85F;
	Mon, 24 Aug 2026 09:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587547; bh=1MvPs/PV2tLB4HDsvTjKWixuWNV1rCXGW/G3quH+LLs=;
	h=From:To:Cc:Subject:Date:From;
	b=vw1mzenUY8gK8nUmmAxeKjb9a86TCQ0iVEQWg8R7B4POGuzbglchYJbzDSfmmTfv0
	 gXGiOcK9oIuGSjJ3XjCUH6YEhOp7EgFCD0Z04j3UVhXsw8NB6vnhAHCoq6Him6v4/4
	 emWSAony0re2jPv4WqmCIZPzZeU8g/k+ttOmssaA=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 0/7] arm64: Batch PSTATE.TCO handling in kernel nofault loops
Date: Mon, 24 Aug 2026 17:04:45 +0100
Message-ID: <20260824160523.3907021-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e6jray6i7aenafhk4tnyqs5jqxajx3hh
X-Rspamd-Queue-Id: 56A32100011
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787587548-350515
X-HE-Meta: U2FsdGVkX1+FX/wMA04/0d8J+ZB5NODT8u/Xe4gpXK6l1TeFKiKN7AzSDAN1EpFSAAUpnzelwlq1UyPhL/aenUGQI4O8P2G+i05jpthFZKIyuEKW3t4vtSBebraJoWRLZv/4TZRNM02vUU7M1PwIOmbIqX3+lL3erx1NOA8/NpHEwLGy1cQaRSfeP9+uWSgJtLDke65xPvVcoorwtGSRcdFJNa1ag0+AFwxEQufkUN+vVniSAt1WuWI2AZ5RYgWdj7QwG5CKi/K+P3RPco/cq3QaFSQnR8daR3v8/bYzmmfvfjgLixp/5VHABH9Fe4zSaqPR5pU0XBPzVpWaM/nlHTt/ZigFcpE0gpTXbiT6gOo1txc/v1kihltsICE7p6zu19O0Cw2fRr4GtkiiqXnPT7EdHJuGXnPCsb7TXBDFlIgsDZkJhFgkxFN9CL51UXrh9jqX/N3U5pBaFLi2MeY+0457KCSOhXiN8hfk3SXcCjXCjvDgLQlqpwpHFOo7x8gcP5+C0169nF3TmMI8/Wd0XLs4cybxWyEwBEVn5LeNIWawPh6Siqh3QkXZkrQ6IlEZGNQkYKzpJRsvGpeEqfBM3fP8GOiNpaHZMHsYI9RF+1PZ2V5103H4TSfUo6MvLvHOGyoO0Bg38YJXs1ZYOzAN/4ioYBuSp9PESyqZZ9zUwR9tUxa+SAeirOxe3P14ajbwndsknvvPjRFG6qwmzlcAWjQ/x5xbFYXcYKJLuv5gtuu22Kaz0Q3gcKhS7ycp+YjEPG1J6SmVZTpIZB2/41eyzvbD+Q6vk0FcgdF7ZDruH0dfI5i9ahIQQ+CFKyIBDLBVUWMcH0sLn7BasJJnhFkTZgQOx/MrN004FcYKOcbDwRTav5uNveHKRHOFeU1Mu9aef9IMZG8l1ZhxXDTuXmqxC7SZqbk7lx27toju2ZL4lLw6VAdP4fZNjIoXGFP7ad6yM/qcHh+mAtZ+jMzOEOx
 TRD/mKHG
 DRu7V4zUo68BCCfkOBawADh+ffIB4q08A68yGVMSujL7sRgY3vk+9LHVoBl3f+sYfA8DRUT8MafqAyxh3Q5sJPegOVByII3BpzNOb/xP9u5prYhuh3hJa8hgwdLJAaSRaWTXR/GVQ9waux/q6VK5ZNdRjnrLz2XBiUyQHJkriRhIQ7eNqOQijkBoDjB3wGN8eXSJNvIbMtXOZ3fvbnQ3Z583Sn2Deo0Kk2zV+NbIBKnPKzUne4JjEXm1zwh8vBHeScaAr1FWhNWAZABfK6LD+rSH4PxaMgCE/VXLpGZgRcnsBiDlif520gWOtaUAc3LbHr2CoBJRG/6FLwjJMRKp466Dtm++7Cxla1XnCgA+JvPM3RAeu3i+X3AOa2TQIMwoiZq9GOK1yI/U2QgLicVb2tk3WnDNL5S9G6M+pbqdtdLrubLp7p+q555Uo4wxsyYvfeja2YuFKKsbMBPald8ezTHfL4zypGRNAW2DnMQZoNmBHQAb5grlnnL6g819ekDMB6WsKRYRv4acG9I9cn+aw9dAhouqEg/uAHsfUtzPPUjmhym6FMJwhKqw/cSNCA8CWQfs9bKZBxYXL/s3pTG2KJVajZxuMvE6wNbQ+6ceqFu+YXac9aOr58j86xBmzmeBZl+GBBUi2XAj+BDLcl51mF/haRJoS+d1pfkeLeNSjM7tpIgMnMgPm3Ga2fniURnY2szuO9q65O6q1hceIgPq97w6GhgSu/XQFX2FQenQ9q49I0v02BqOPfLN3Pyi3peB/cf0fR8hSrkvVE8mtgE+vtIJpLvATqJpv2WUcB44TLYrO2ZMxYX5derBIa6V/DJmL8pNVKIUhyPDOdsMh+k617l7FQGPoUQJ0vE8nqrt/fP0MrxuKWoZDDEsHqa+nC/eA89Av
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With Hardware Tag-Based KASAN in asynchronous or asymmetric mode, kernel
nofault loops currently set and clear PSTATE.TCO around every access.

Introduce bare nofault accessors, batching hooks, and an internal scope
guard. Convert maccess page-fault cleanup to scoped form. Skip
page-fault setup for zero-sized kernel nofault copies and zero-length
BPF string operations. Then use bare primitives in the maccess and BPF
loops. For non-empty operations, this reduces the code-derived dynamic
MSR TCO execution count from 2N to 2. Two-string BPF comparisons fall
from 4N to 2.

The BPF changes and an earlier maccess implementation with explicit
cleanup were tested with QEMU arm64 using Hardware Tag-Based KASAN in
synchronous, asynchronous, and asymmetric modes. All nine arm64 MTE
kselftests passed in each mode, as did the 138 focused BPF string_kfuncs
and varlen subtests. The focused BPF tests also passed with the default
non-MTE arm64 CPU model. Both final maccess scoped-guard patches were
arm64 cross-built. Runtime tests have not been rerun after that
conversion.

Muhammad Usama Anjum (7):
  arm64: uaccess: Add batched kernel nofault accessors
  uaccess: Add scope guard for bare kernel nofault regions
  maccess: Skip setup for zero-sized kernel nofault copies
  maccess: Use a scoped guard for page faults
  maccess: Batch TCO handling in kernel nofault loops
  bpf: Skip setup for zero-length string kfunc operations
  bpf: Batch TCO handling in string kfuncs

 arch/arm64/include/asm/uaccess.h | 71 ++++++++++++++++++++++++--------
 include/linux/uaccess.h          | 20 +++++++++
 kernel/bpf/helpers.c             | 41 ++++++++++++------
 mm/maccess.c                     | 68 ++++++++++++++++--------------
 4 files changed, 139 insertions(+), 61 deletions(-)

-- 
2.47.3


