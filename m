Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8219C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAA5900010; Tue, 12 Aug 2025 13:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3CF8E0151; Tue, 12 Aug 2025 13:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC58900010; Tue, 12 Aug 2025 13:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A54A8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:58:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E0EA80140
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:58 +0000 (UTC)
X-FDA: 83768866356.07.AE787A7
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5698BA0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gwyTGNwZ;
	spf=pass (imf25.hostedemail.com: domain of 33oCbaAYKCJkDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=33oCbaAYKCJkDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r2V1v9VHmhBBpIoyn/8bp16McXh5rwC69+hYhu5VhtU=;
	b=vl6l05n2vc0ixbYWQgtrAI9RtOkuWHnwggZuY1yAW7VceB0Llzhn3IqvhAbbA24UCVrr3T
	4Ua0EUomabFRd3YkpbQ5KA3BTd+Md/RQXeoFUCsGACct/AHwkqMzvMgBrh3jssxMei/0ZL
	4xFEYN5dyaQuFo2dKRWqLrzzObvpQKU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gwyTGNwZ;
	spf=pass (imf25.hostedemail.com: domain of 33oCbaAYKCJkDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=33oCbaAYKCJkDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021536; a=rsa-sha256;
	cv=none;
	b=xzAmSXJU5dBINK5aJp9WjqcQ6y8ON0nex27eiR8NH5gFJ/RGtV00EpT197zH4tMOv6rTKK
	872eHewkSFlHp5AS9rDYIicId4pXnpPLFBgL5MEJwzbISFSKGpWwcYn1K5FLUz9wFLvRLm
	18jijtV0B2U4CUVVhFWQ8Icps/BtA8E=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bf3e05024so5388061b3a.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021535; x=1755626335; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r2V1v9VHmhBBpIoyn/8bp16McXh5rwC69+hYhu5VhtU=;
        b=gwyTGNwZHTYjr4BdzbJu7oYhIxBZ+8YHXy6H3ksNOSCvjfWh794I9OLB/Bj6ZCBMjA
         Mj7RZ6ofOTLUTnWjisQpph7Rt48uj/KBkkDocHuR5rkbfCQ3PQkLs6uXM3InNTcS+8zN
         zh9BAoWPRN2YGp965riQGmt7G8ullPztDqHwjJUp4z0AJ9LH03G3UjeYwYQbCAbF+y/N
         tBs8ws/x13T71gNZP+MoHNbuq0y+hiEAIuMkEIPOh+CsOdrbJVV3ZYWD4KBRejjP9DBi
         QNcq7ybfKAie+8Q3j/zTqSwjOZ0x0mnQ4OR0Zr0SO1dVVRTDaxpEP3Bkq1HwoXgR5Mvt
         jxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021535; x=1755626335;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r2V1v9VHmhBBpIoyn/8bp16McXh5rwC69+hYhu5VhtU=;
        b=a+gi5paKfqOK2B5kE0q+cUp9RiG3RmEWbnh50LV4nn3xz6TYlyF7anMzxeRQ/Tpjwm
         ZD0ncYkkB7du1glzt8GDX2iRfMURX2h+YujA7UBTQEQnsrWTS0jez9i8+pBAP8o475Hv
         d1NNcccDkdfCbiKrhbmJU2rn1ItTAbOwAwKMy/wL7Y7o4xwRdbv9IKmcqJ5Eq5C4DQ2k
         RFyCDnX5TVbd2fee7jBC0M5A4t25Na69uZ35oX2XR4Lk3Mxf3Rq08ey+adDdH+SYx8SD
         m6gkcpKuuSWiwcd+HChwBnhyRG9n+HnAq+cGGmSAZiZwrTT5P1cZXT1aJ+tyHFWOCn/L
         yJFA==
X-Forwarded-Encrypted: i=1; AJvYcCXxp3rG7pn8vF5F7+C+OwWHnqoCTmxUAM0bE3u7cSuzYjZHsdBAXp+rJy3J9C9nY8bGmnVosqsGsw==@kvack.org
X-Gm-Message-State: AOJu0YzyyQiD6YktOgWPB8P7uhcPda4W+XonDAiO89R3fH/hzdoT3Zik
	lzIEIq1fYTA+IvNAzEVCcIa2OKHVbq+jjwnfvcnCHZcPCBtTmc/O9laixER8GbSHYnLmavfJTOm
	4j6VBaw==
X-Google-Smtp-Source: AGHT+IHpI2A58X7fiHu4X8DLCY/YyPjXlJ8KtqdQYuS0Jk77Gj/N6hjXCZ5aN91Gfz65dY+Oy92efigaL18=
X-Received: from pfbde4.prod.google.com ([2002:a05:6a00:4684:b0:740:5196:b63a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939d:b0:240:1119:d70c
 with SMTP id adf61e73a8af0-240a8bb39dcmr219488637.44.1755021534987; Tue, 12
 Aug 2025 10:58:54 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-1-kuniyu@google.com>
Subject: [PATCH v3 net-next 00/12] net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zr1imwopo17aakknydhau637ayrsohy9
X-Rspam-User: 
X-Rspamd-Queue-Id: 5698BA0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755021536-561701
X-HE-Meta: U2FsdGVkX1/h6dAKdlvqW4Y9TsVHTI2G0AwODgC+PmWQWET41MJ2jhMN11Rzkj4EXCgaYPGTcXHHIxwo/RJBs8cUexzEKhz8a79dwKFYB6HIMbh0MKLAOzU3GUu+Onx9gajHvefPXclq38o8+ZSQOjGimeIR7dMvpleyGYKELIHu/YAqgmOYXZhv85BA1tTsWyLVAutNvwM8+QqX9EPJ+Y/Dua3vBYXx+1KAkMmtkZGgnYKhvzbFiQBQTEdzYpnh1OsIv0sxKGw2fHUH/xkSm4RFymFtVBvI/Z9RBw+ogJpDh5q9RQCxnX16+hGTOnLOHZN5yGOHZ+GsvitUaDx0//1DW1WBNS5u8BXYkcvj0kwz72YZJlvzlEQH/uoKtaEMiMBuKX5LipcJnMf9sO0BtYPS5fauqMWYYw/uR85Dsf1r1JJEWIcq1Lc1a2IE/RM75hgnV7XCicDKLau4sMNmKmVXDfBmRsS+R9SjFiJysA2Zq9F6W6VS8XSCTjSuzsgy3GS/yfEjRMAyrYL8+Sa7vVpOZoHPKAeXaEVW/fzEeiHoSlUI/SXJfeXH09Hpka4WploEB32KzBoGeoqTZJ8enTMN3jvWicOaTTUA2B6yTTCcbvovoEnRl7SFolWuw49N/YtaYhh5coNivImkidQPrxNdq7j503LME75opWOkDSjSSicDsRVtodTGRGLLXdoclY+Bq/grZSzg7LCmIWks4ZMY5gXqu2lKDuDmqcLummf9LsQgth42ZyYGlFC7r4bIFPzmd7jRo49FjWBeQKGiVHlrYixXYyFFP/+0KuWmrXiK+iI0hQEPAqsNIJOUqkvk+/8Twqyk4dezXct19cacM2gIPIPXQMx9PD/1Lg2CmvbwTst0Q/ihNPWfJmWost8wdaLVC6nQxll+O5K2QNy2XngvpntmCYf8tD+T/5lkEqSBK39dUlNOB8zbO08WLb1wO99RMpgQeH4lVDB9X89
 oytl1pw6
 3SyI1hGG7Jc3uDJhRIazJ9hWNUnSvefI+4dWPlvuGPjqP2BirfeDe8Dld1n1sWlk0sg8SqMHHJY0xT6Z7HtgCUsdQBHsP2FTmkOobIgU8gRPRBVq2dI8iPZSK9U2XS7U8ILrdnFpKkTlSRDC0xoCBpGk2MLtR6URaJMKKipXSgVYdcG9p6N9FIqeftD8sKQXBzSQJv/AjUOY7rbd1ygS1UpSY/507hicm3VSE4bYDdoAtsB/C00wDglhQmOpyIl1EfBcFaKoAn0zy/HpLkNS7scIi4MSJdDF7VD406mOhNoMVqWU1iqXgBA64IK3kCmu50D/zQSXG+CRKrq58PN5f50r896lJ9qLLGGkec4ymJgjfBfh2I+R7D2Ov3cRapB/zNjdoiLzzBNhwyxkQsJVwI426ZWNWKL0zgA11y2Kn1ot6tGrZyEaljvD7hAVmDm6qvVhwKJsodERhKLc6kNqb9xrFFxRXZV0an9wHIrQEX5OwSxKSvVLX+SFboxY1Dr87KpbKqrzcI4dpwD7vykSPT0/yn8POijosUjI+crRQ/PsXPxSNExi5vegCUNIzP+WULdm09PqJAz81l9ayVu35dYe/3RgbgDbCK5RHrodo0IEcoBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some protocols (e.g., TCP, UDP) have their own memory accounting for
socket buffers and charge memory to global per-protocol counters such
as /proc/net/ipv4/tcp_mem.

When running under a non-root cgroup, this memory is also charged to
the memcg as sock in memory.stat.

Sockets of such protocols are still subject to the global limits,
thus affected by a noisy neighbour outside cgroup.

This makes it difficult to accurately estimate and configure appropriate
global limits.

If all workloads were guaranteed to be controlled under memcg, the issue
can be worked around by setting tcp_mem[0~2] to UINT_MAX.

However, this assumption does not always hold, and processes that belong
to the root cgroup or opt out of memcg can consume memory up to the global
limit, which is problematic.

This series decouples memcg from the global memory accounting if its
memory.max is not "max".  This simplifies the memcg configuration while
keeping the global limits within a reasonable range, which is only 10% of
the physical memory by default.

Overview of the series:

  patch 1 is a bug fix for MPTCP
  patch 2 ~ 9 move sk->sk_memcg accesses to a single place
  patch 10 moves sk_memcg under CONFIG_MEMCG
  patch 11 stores a flag in the lowest bit of sk->sk_memcg
  patch 12 decouples memcg from sk_prot->memory_allocated based on the flag


Changes:
  v3:
    * Patch 12
      * Fix build failrue for kTLS (include <net/proto_memory.h>)

  v2: https://lore.kernel.org/netdev/20250811173116.2829786-1-kuniyu@google.com/
    * Remove per-memcg knob
    * Patch 11
      * Set flag on sk_memcg based on memory.max
    * Patch 12
      * Add sk_should_enter_memory_pressure() and cover
        tcp_enter_memory_pressure() calls
      * Update examples in changelog

  v1: https://lore.kernel.org/netdev/20250721203624.3807041-1-kuniyu@google.com/


Kuniyuki Iwashima (12):
  mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
  mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
  tcp: Simplify error path in inet_csk_accept().
  net: Call trace_sock_exceed_buf_limit() for memcg failure with
    SK_MEM_RECV.
  net: Clean up __sk_mem_raise_allocated().
  net-memcg: Introduce mem_cgroup_from_sk().
  net-memcg: Introduce mem_cgroup_sk_enabled().
  net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
  net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
  net: Define sk_memcg under CONFIG_MEMCG.
  net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_memcg.
  net-memcg: Decouple controlled memcg from global protocol memory
    accounting.

 include/linux/memcontrol.h      | 45 +++++++++-------
 include/net/proto_memory.h      | 15 ++++--
 include/net/sock.h              | 67 +++++++++++++++++++++++
 include/net/tcp.h               | 10 ++--
 mm/memcontrol.c                 | 48 +++++++++++++----
 net/core/sock.c                 | 94 +++++++++++++++++++++------------
 net/ipv4/inet_connection_sock.c | 35 +++++++-----
 net/ipv4/tcp.c                  |  3 +-
 net/ipv4/tcp_output.c           | 13 +++--
 net/mptcp/protocol.c            |  4 +-
 net/mptcp/protocol.h            |  4 +-
 net/mptcp/subflow.c             | 11 ++--
 net/tls/tls_device.c            |  4 +-
 13 files changed, 254 insertions(+), 99 deletions(-)

-- 
2.51.0.rc0.205.g4a044479a3-goog


