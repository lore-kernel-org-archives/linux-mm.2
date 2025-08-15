Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CC6CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F2D6B0289; Fri, 15 Aug 2025 16:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C670B6B028A; Fri, 15 Aug 2025 16:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C686B028B; Fri, 15 Aug 2025 16:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE7E6B0289
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2533D5845A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:37 +0000 (UTC)
X-FDA: 83780102154.15.4320E65
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6504740003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ojFlotRk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 33ZWfaAYKCNI8IB6MI4CC492.0CA96BIL-AA8Jy08.CF4@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=33ZWfaAYKCNI8IB6MI4CC492.0CA96BIL-AA8Jy08.CF4@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2PRNy71eyK2aZPpC5gSBBIxfuZRCi4H6U9oHXzC7IIg=;
	b=EoCKagWev2QSdXxmmROxV2IiDN9V+PGWhjEQLYeXhjJl2i0VUvg8CoRbuQXxhDuSnfrp8H
	5KeKAlZwEuV2QnAhJQ9XS+RKic5HC3TqcnRO4Yw/lKt2uFeTrn3Jefc0QE21ICi/Hniqva
	CFQTFGM+VqBfsDL3xAeuTUyqs95zwwo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ojFlotRk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 33ZWfaAYKCNI8IB6MI4CC492.0CA96BIL-AA8Jy08.CF4@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=33ZWfaAYKCNI8IB6MI4CC492.0CA96BIL-AA8Jy08.CF4@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289055; a=rsa-sha256;
	cv=none;
	b=zxFh5DL8jOjc8UO/PF04qDgoc+uCc6gpDlMG1tcyEuleYh3qjH4PVmo7LMvrmY8Os3zjXp
	k7cIiycMlsQMHMwaQSclUXYqt+X0QwWjYVKfohkTrvNOuu1KmV/vMx5plZvlsl1sqHo//C
	xF3TTM6QKB4xQaEHxljp/0R98xFUmjI=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ebafe0aso2011574b3a.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289054; x=1755893854; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2PRNy71eyK2aZPpC5gSBBIxfuZRCi4H6U9oHXzC7IIg=;
        b=ojFlotRkXSAeCdenQq5dlJ30s34Q1ywEHqmFo9udwJsiRFD31nQH9mOsMEIs9hgk6E
         aPzBBKs5CY17EN73v75SZzBjQg6p3ttrIE83HW5dHUkSu9WBRL0Ogl/Q7Da2SKczwyOo
         AISZ9NCsY8UVGdicMWmaC6+BGQ0ohSszoj/bFki17gtqITFEZMPXULTJpEhWpxm5oeoO
         Opz33vW+I6X1uvUlqrQTOSi5zGP9zy9w6zoXw5Cl+yyXk9UCqdriRWn4XHYnLJD0UdbY
         mM/lsIO0kINmywpIgU/WWkk8AfLFjbmMkb0Za/fbDdb1r46pJIqFyUQwexVmdUuffnel
         vZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289054; x=1755893854;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2PRNy71eyK2aZPpC5gSBBIxfuZRCi4H6U9oHXzC7IIg=;
        b=TC5SRr6+FhOFlQnnNicKJ0v0Wdtg6gF36/lHU5uVCAwV9H06f1Wt//nOlsRcggkytH
         e7puKlltaQsBbnzFSENw36i4ZmY+37bK6X0duMtoPb9Z7AcuQqG+Mp4GkH+Wt3AV9ya9
         Dp5YelIV7fEMU6Wu19xkB5kSnrP1T+bTsU7lkZJhDOpbUGVbnHC5QMHWB+7tOF15qhpt
         Ae5J8Fppf4HBexT69GVPfbi/ClJItE0U8UYuvj3y+oCNcFi+LeaTPT4qZ8PaK4Xow4TJ
         76yVZ/SpvIclQzCdQbPUCnlf/3M0xbyYiwotOKOkbqnEgu+jB/bBSwyv+j5I/7DHM+EH
         zZSw==
X-Forwarded-Encrypted: i=1; AJvYcCWRVVSN37jFHSuzJjCFb30+IGfaJ6VXJUpPq3ujLSR/k3iybBAYGGC5TywLR0+Qcd9N/SKM18kUlA==@kvack.org
X-Gm-Message-State: AOJu0YyGgo0R37Nr+gmz8ocbB89QfNlQj7LyF9MamE3Lufn4ZkdPCBOb
	VSISoqQO2OIoOt4JqQeIv2FGUocNHG3r6gITF5VPyXf1Svo2JDqAnonUpKLXX1F2csnE3g0x1Pg
	9xlOUgw==
X-Google-Smtp-Source: AGHT+IHmaMP4DwtVSKqH4dVqDx4zRe8jIMCHyyumzBMZfK2MDVM9bvEJ6Kw/6qH1LxunWf0RV1NxlfpDR00=
X-Received: from pgww10.prod.google.com ([2002:a05:6a02:2c8a:b0:b42:2672:b159])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a27:b0:240:5f9:6359
 with SMTP id adf61e73a8af0-240d2f1add1mr5795559637.34.1755289053981; Fri, 15
 Aug 2025 13:17:33 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-1-kuniyu@google.com>
Subject: [PATCH v5 net-next 00/10] net-memcg: Gather memcg code under CONFIG_MEMCG.
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6504740003
X-Stat-Signature: na7i7fkgoadbb5m5u33rdpfymok9uote
X-Rspam-User: 
X-HE-Tag: 1755289055-926362
X-HE-Meta: U2FsdGVkX1/DMuoKAsprVLHl43ReC1DsTk8VXudph70XAxdRzv5A9EghWimh/BomFJKDRk3Y7pmRfVZ/MZvs0uhh8oKjNp6qvxMUKN3Sgg+PHXgbBDKDk/T+YUEgUia3U4ta4fCVkMAbSJwbA38nRzlJlEJOvLkDrc2A3t+O2BzewE6ahfxWv9SIXOvb7OXhWH4Ck35BHyGtJqs7broeLHchDshWRYCjVgTLklSYa0ABvEfq2IZab/vXsIsD5tmwlI56OyDao/9rBvSWInfoyXPfxEe/B2fOEJpa4x6cwSCMA9Kn8Mo1PX7l9U/k3Vy563Xkhno0zbdP+MOyJfnHPMCgwr9inJY8uKkmrqE7h3MdsGb4cFG9cbzHfaIszWW0d+BOQfGAL+W7Qil/hYgjK99aalrmBdfVkEhY7F68wUoP0y+2XEyd4ap5lm03nS+3HPwz3Afe97v57+Jb87RwS1m6cWY8JjymsrQpJhdntKEmNwgY35LQ4S6KXEJjvSRlGguU27ph0gJfRMI1a01JwJyMoe1jSqqQjVKt63nG9RXFvUJr5C0DmuQVP2+++3bpvbN3bGiFvCgGpsasDGzKDCwPEm/QvnPTE8ioQ0TAYy1urkvezPMrl5DpJKcuxeNH/O+jIru4d3Ui0GRxLJKycggivAf42CloMKGt6ZPTVYI9ea42MkacaTi/zmF3svZxSw0wpLHlFAHNboLd7/I5VMuayWkhH8fxPUsmOH3NKvjfEs3smAKCgjc6RShqiNSCmI29TM4P3RmD5A4lnhZLLiPvI8nDqDAhN46LUA5UGjn1sEjduTPiZMte/zEcKxHdhh8jHOxraodfudfV6Bao7yU0HCbuzGKLvviz8cst1DBssG6IRXL5zLeMvcvAX3G7Jw++SaKh7h2nyoWihS+udTU1msvt/vDUQLCPqlAtBkdemt2SAI9OusVrYIkGuPiqX/f7bRV6BX+mA96WsTH
 oDeBLu3v
 UlEO0jxJk4INz60767juP4PjkmRdyScXj27t2K4/x6PSdUvRxhGlOkYvEiGugz6qi1qeP9FGKMM9VAUaQ6SJk4FbvpqkJyWTV1/+FaDvB9YGkSaiymHiViGHyKyDSK5w6QY5YhstxaXoQ45ClylGSC4H3SFjO7sKqDqFHmZgHxJ3fnEu9vbbO3MSydApib2GEjz1NM1Lwe5lPhRvbMLKZ3HbwblEGAUFUx+KKN5ahHOeyWWXPpCwVUF/QKp5nYix1jfugreJ7R85dPTTzoMA1DpIABJKjpHcKJoD/alBZ7DmUHIlhsfsc/RAo+S15Z5NGCvQMTT2exiSbTx9qOP3dyU1Yn+13Fho7dX0IgdHUlqo5JAC3XFUx0qnM3yPBRxhAb8C4DV92ZGLByVAduDP59rFH4x1o5EMCGzhzU2m/KYsZ278C3yUmzWOn84mhj+twylkDoQnp6ULvk2a3VhMQDNIwEjwEP3ZAPvUpDLtLtGH86kO65oP0dXUT3YOv63OB8RUo0XIvCc0UrFLbgL2/DkNgoxPuB/rRtCRvZMFlJ+mXenVMR1rcujvo1kIKaKNvbhXjqYG2NCJmxZ9aMWmLBe5zxEIQ+q5/Y7DB8XORHWc8ywU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series converts most sk->sk_memcg access to helper functions
under CONFIG_MEMCG and finally defines sk_memcg under CONFIG_MEMCG.

This is v5 of the series linked below but without core changes
that decoupled memcg and global socket memory accounting.

I will defer the changes to a follow-up series that will use BPF
to store a flag in sk->sk_memcg.


Overview of the series:

  patch 1 is a trivial fix for MPTCP
  patch 2 ~ 9 move sk->sk_memcg accesses to a single place
  patch 10 moves sk_memcg under CONFIG_MEMCG


Changes:
  v5:
    * Patch 1
      * Don't use set_active_memcg() and restore
        mem_cgroup_sk_inherit()

  v4: https://lore.kernel.org/netdev/20250814200912.1040628-1-kuniyu@google.com/
    * Drop patch 11 & 12
    * Patch 1
      * Use set_active_memcg()

  v3: https://lore.kernel.org/netdev/20250812175848.512446-1-kuniyu@google.com/
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


Kuniyuki Iwashima (10):
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

 include/linux/memcontrol.h      | 45 ++++++++++++++++++--------------
 include/net/proto_memory.h      |  4 +--
 include/net/sock.h              | 46 +++++++++++++++++++++++++++++++++
 include/net/tcp.h               |  4 +--
 mm/memcontrol.c                 | 40 +++++++++++++++++++++-------
 net/core/sock.c                 | 38 ++++++++++++++-------------
 net/ipv4/inet_connection_sock.c | 19 +++++++-------
 net/ipv4/tcp_output.c           |  5 ++--
 net/mptcp/protocol.h            |  4 +--
 net/mptcp/subflow.c             | 11 +++-----
 10 files changed, 142 insertions(+), 74 deletions(-)

-- 
2.51.0.rc1.163.g2494970778-goog


