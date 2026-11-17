Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D901B606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XjQQOCjg
Received: by kanga.kvack.org (Postfix)
	id 1343B6B00EF; Tue, 17 Nov 2026 07:49:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDD56B05B5; Tue, 17 Nov 2026 07:49:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7966B05B6; Tue, 17 Nov 2026 07:49:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C29E36B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:49:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5811316040F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:49:47 +0000 (UTC)
X-FDA: 85444592814.20.C7237CA
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 93D232000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:49:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XjQQOCjg;
	spf=pass (imf03.hostedemail.com: domain of fary.ru@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=fary.ru@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919784;
	b=1ujlgnFJRiFVh7EdYBidFY8yGO8sBW+G9FaQRhkqLXCboKA7BizSNavEYnGhHG/HtN8yQ0
	85bl1DJeQe8VWF/KEWoF1DeKwRddZmCwYHgAm5hLfPpYYHV2w5ULFPjgy8g8RbYmkoLwUi
	vlankU6R1gYMwxuWQbnNzlxCMYgcHa4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7NkXbGqH8tfkmfDZNQTbsEwEgUav04FZtmrAz3OgWBc=;
	b=7USQ77mZGvEUMkfGY2Itl/LpskzajhN+od26aZI95PSLyGIWBEq/UcNNkobKWss7mBkDJV
	5StX2DcS6aCRb/JR0GOk3rVa/TG6Jtz/hFKgmED69hZZdjgq6JRojW0nJtkX0HOejPLpC2
	CJ7C1/R7nO+1uIPrNH45zQ3R4dCGoAs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XjQQOCjg;
	spf=pass (imf03.hostedemail.com: domain of fary.ru@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=fary.ru@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ad5529ae64so43138421fa.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794919783; x=1795524583; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7NkXbGqH8tfkmfDZNQTbsEwEgUav04FZtmrAz3OgWBc=;
        b=XjQQOCjg0yt/2ur7Hk3R5WJEPtBcW86S/p4hvt1KXJ5ohNGJq8y+gztdJTIJFnpVxi
         CubeIWRZulLhjwRiMLB1mJp5DBKVs5evW73SAJYa3Hds4lO+6cCbwt4Kqx9LpKI65ZLi
         ujHIYYZZhAp0xhfJUeHj7fvGf2EWpIrxEQ6eXCnhOd0VWKiRMrsIBjhia8LtkUi5RsfX
         EstBo0vJ360bANARlYghpfh0gpvQt5ZVov9um7LIPL/mLpIoWxtgLxUO76qVErtscBPR
         X0xWIGySGNQSwB2g/G6QRJlxxL2z/n9JGMn5Rh11bleFLkOftZkmG7vdLr0ENo53gLi9
         89kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794919783; x=1795524583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7NkXbGqH8tfkmfDZNQTbsEwEgUav04FZtmrAz3OgWBc=;
        b=oSgJens3HAImqngmG1daw51HybnqcCHbRSxTtcLJMp9mGncs+vpZ95rqetirzZDk/K
         3Mq6p/sdY80xGnqUpHpvJPygZrLTjlyu4kXsZoG/zwceuMipKHf91ARzVfDUlCf0uQVL
         FvN18gvSbW7lQcd+mWlrhOm8CsX/va0mW//VCypTfLej3ch64qr7ZhcXqUjeHbHsTIgx
         5lmINpMazW0/UTId5aR5usMZxiwV/w/scuwAJw+DkuRHAgiM4GwcuVngsU2+EkU8oLyc
         HUExqCijKd7DHRFLk9Bc/3prLVfVWfg+WS2RNV8u5MFuuGd4khS4+fjoB1YwPKPnp+TA
         lgHA==
X-Forwarded-Encrypted: i=1; AL+hErExlLpqJQNKhbX3KSsxRgjkwY125VJa085zd09wmrsBMFPBHcZ+wOdIEQ4g8cHy+gxYpCpnSn7wow==@kvack.org
X-Gm-Message-State: APuU4Z+/o8J9AzF/gA9rX5MtjYgAQyNE5NIyQKi71o7YbGwU5AA4dfUP
	fwnPkDxuPxLHPJI/J5rpj0ZM5lgdBVtCzrSvxf6Ei5FI+7iEZXgrCwsh
X-Gm-Gg: AYBFou1SeTq/cAZczkDE/lPbkX0lHp4bjFKJV4KSb5whlXE37EFo6K6Sh78Q4xn+zIu
	Boh/RPbB8YrtStzorIqgOonLwWiwK5sMEoPF7owLtZbuT9sXdsNZNixuQdIS+o3vYIM4KgnIABp
	en7clFoAN++MuUlNTquJf9nMiOPBcI7ado74hzPTBS02G1WWUeOze9X6+WcV8ZDCuJvnPO836Jn
	afmzpyI3RwFef03IvZBeyqoX4uG2KB7A5mRqDEB4IKr5oK/a1s95ZEq4/tkiRHK8RGRafFfWn4s
	5uAXgwSs0jyqjwR3wdWsMVpDDOJHhtJbH6H+zX3xrqOhuPMQhY+WhpSU4jzIHxHqdoHeUFeJDXd
	snd6qJqcCUZSlibFF8SjBRkaKgQUaPmL4OnoWCLvhP3uI2vtKhyJx0M2D1RJX4dc5ir1nxbQEIk
	xKiTJgWTOTKJRgJrC3Q0iFSPp7/EHJEE4/3PCAyAghXmQNNZNcLFIC/kHroeRWkMs8rEnT1Kp17
	b7+dOSI5QCLO1rVhZkKoYeiDEY5uZ7KJWv0YitgbbWXFIZReisdosT+fhmzaJoYxN1a96O/3Hwo
	R+vgvgy2FTPgOxQ5SSPfHJzw+A==
X-Received: by 2002:a05:651c:41cf:b0:3ac:4ce6:8b7e with SMTP id 38308e7fff4ca-3ae2b53102bmr35843721fa.26.1794919782406;
        Tue, 17 Nov 2026 04:49:42 -0800 (PST)
Received: from dschervov-lin.yandex.net ([2a02:6bf:8080:516::1:37])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae2b7ae92dsm41051351fa.23.2026.11.17.04.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 04:49:41 -0800 (PST)
From: Dmitrii Chervov <fary.ru@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	akpm@linux-foundation.org,
	mathieu.desnoyers@efficios.com,
	mhocko@suse.com,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y] mm: fix OOM killer inaccuracy on large many-core systems
Date: Tue, 17 Nov 2026 15:49:38 +0300
Message-ID: <20261117124938.72111-1-fary.ru@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93D232000A
X-Rspam-User:
X-Stat-Signature: 4oz8a3zwyd61xb8nbpun8ush1w9kqwsc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794919784-374556
X-HE-Meta: U2FsdGVkX1+sxvEVtyJ9UZVBc1RKddwaFPKVAZBpTeRd2Sl6aClxMW3gP1uVzGZK3SwyUr1+lwdxNAhFOqYMHS6wfvxMr+jClLcvPyDXM9LTIJxJkmu1QNNYAhW/Udti79lLCtP5L/rwUrylkj60h+wiYjaoZY6Y8jSIEDpoADiwmsQXeNlej8wfnOct/61EJGG+sKn2XDuIMCLSziWazdSdctpu7PDBEK0YM2XIhHOGea8VilbCbYtIG02Uaha9lnrti0oTPKb6rB/1S7d+XVnCinOV5jA0lNAWI9yX7h7c2n15jNfL5xwd3rYygzLlIr2FurAwKQeSnU/QLosPFOJCuNDtgE6J2ubSorn0Tq3XXsQaU3L6h5S34I+5Phkgh8T4NYT2OMkrcqQC38orbLNLajEQ/1oKBexI62aMpCEJZruko/T6yqr1KMq6RzqgpCAi1IJBYDkREHn9t3j2J8kVxTlc6mP2jsA5crNqEPPL9LClYkXXFpn3P74+zu98734y+HSHwXLh03/slXLlxD5XZ20BH7GeOeZXVdpSRa7w9qYjyp8x2fiWw/umaM3cy1OuVEc77sCAazrA/h20DOMov4K91g0TjJueUzb3fu9CKIAnTNVu4GiKzA4R2MAdhG9hsSwwEsnkZHlCHQChSzMlKhHb3wkp/QaBNnHcO1PWvgPJbUzOPsF3+qav1C14rfyLY8qc3DkVvaQaKto+Jz1o5lYDKglLbRNSkNGwUYRhubD3SpYQs3FKguLKlVINQvsU2AzEHOf9Ff5CrMkWox1m3UyB2iYMQDONGOEXV1/yONruSF2dOWx1tTn3aMIixtxZlkTJ1H/xfwBDLyuZzMbxavC2d4jHeslwgJiCtuDcLm28ZjFy6pplgS2Qm0nGjQq+VQI50C3Ts1L2qKBfyyUiPs9W5/gc7i1G7pDEgbz86FgT4iqGawtQEVG3sBiJs2TZSCWPyqRkbza/jsQ
 e0padhgs
 1nkdN7IiFdzEyozEULoBhhWXMp4J+h7FdxkCG0llloi+mV36QgSKuxs1ODZhCQUGrDxbNwwPNDm/Ht5DQEOlxg6hgQSl05fhIQEkRSVzPysCR46ASb7KjOsRBLH4mSrpuI7jEaqazG2z0zhMElk2DmLamKgJwukgf5ldVkTnln8kAOaUMtPmZfj7mvkYGHIvOI3VZmbXqHjg69RYgb1JruPUDRqmKvkMonAOX0HKosbg2EnZ7wAQjBeR7IZRlrnGnJv+ZGfJHZRJISfbU240D/xNMEq0/qDV3z9MIwFOINTKrvx0QpieMy6aftilCrIdzMsnTvCc7AeLu0YikKk+W9JfX/+NCaZ6+8FWCsaaIqYEa88j2bkHcGjwPTaZ8aXPXBwyqzq+cWafaguJoyzyTGaY112zjqcNrU4cBMDWBurwEJR14CupezAA/QL+dUNAhCOJLA+x/ExjHVhqqJ/NWlvoCpLJypHPjZszaQ5l+dqCkGilPJe9LBdla+T1MMlzxlfdeq2aPDs0VY5oeGa/XkKQnTNpZ83LLAsCxUdl9AXbrylVDr5FEeo4gGhiPJaorX/QHupxB0waVU50fVFUusXZ0AQu55RdlttjKtqAsy/bTaO/9zstwALVa0KJv/qEzS5kN/G1zw90yhsZxOLvz66yk6HDwmZB+rFZGL5M4VB5YH9E4CV3BgPER/rQr9mcY0O5IPo1u85EVbizrsgtjgHHCqtvYxWzj2PRT5YE9v0hUug+Bm4FHXuIFqfwqSmoe9CQ7dTcMYHh1IeSm00OjvIEAcK4QRM/6g3BczyGhmbRIz575kRQg7Suf81cidciBThJhQhmfULKsbDW/N4ofrqcJfpB8foWdncxF1VonUAckMsHFrf2jowyfgQD5dX30iBuD5rf18CCQAMmc/TyQumEWMPqWRc3M4pNLXQBLGwNthE16EHO6Fe2prU2EJaRBaq8eB8ZAkm0bqwMgi3QJA/1VazAh
 dcSn0T+i
 PC0mLI5LZXOHY4m4hpprQskqRF4ZsiQF9hbI2sn+OzsxfLGQoonehjjkVrGaS8zTqCI4zYwOSlHf/nnsyzjQeYiCpA7+tgJt1p8OXZ5VzyRN9QosE+3pesnAc18PwSKVv5SZaNpLDzdoZrwxjelvoptE9/B2OxW27dRSDHNn0LdD4BzeooKejQCKq/oZxFwKt+XvepY5kZcM2r2XS7pN+Xj1HZX8f5GVjON2tABrdTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 5898aa8f9a0b42fe1f65c7364010ab15ec5c38bf ]

Use the precise, albeit slower, precise RSS counter sums for the OOM
killer task selection and console dumps.  The approximated value is too
imprecise on large many-core systems.

The following rss tracking issues were noted by Sweet Tea Dorminy [1],
which lead to picking wrong tasks as OOM kill target:

  Recently, several internal services had an RSS usage regression as part of a
  kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
  read RSS statistics in a backup watchdog process to monitor and decide if
  they'd overrun their memory budget. Now, however, a representative service
  with five threads, expected to use about a hundred MB of memory, on a 250-cpu
  machine had memory usage tens of megabytes different from the expected amount
  -- this constituted a significant percentage of inaccuracy, causing the
  watchdog to act.

  This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
  into percpu_counter") [1].  Previously, the memory error was bounded by
  64*nr_threads pages, a very livable megabyte. Now, however, as a result of
  scheduler decisions moving the threads around the CPUs, the memory error could
  be as large as a gigabyte.

  This is a really tremendous inaccuracy for any few-threaded program on a
  large machine and impedes monitoring significantly. These stat counters are
  also used to make OOM killing decisions, so this additional inaccuracy could
  make a big difference in OOM situations -- either resulting in the wrong
  process being killed, or in less memory being returned from an OOM-kill than
  expected.

Here is a (possibly incomplete) list of the prior approaches that were
used or proposed, along with their downside:

1) Per-thread rss tracking: large error on many-thread processes.

2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
   increased system time in make test workloads [1]. Moreover, the
   inaccuracy increases with O(n^2) with the number of CPUs.

3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
   error is high with systems that have lots of NUMA nodes (32 times
   the number of NUMA nodes).

commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
users") introduced get_mm_counter_sum() for precise proc memory status
queries for some proc files.

The simple fix proposed here is to do the precise per-cpu counters sum
every time a counter value needs to be read.  This applies to the OOM
killer task selection, oom task console dumps (printk).

This change increases the latency introduced when the OOM killer executes
in favor of doing a more precise OOM target task selection.  Effectively,
the OOM killer iterates on all tasks, for all relevant page types, for
which the precise sum iterates on all possible CPUs.

As a reference, here is the execution time of the OOM killer before/after
the change:

AMD EPYC 9654 96-Core (2 sockets)
Within a KVM, configured with 256 logical cpus.

                                  |  before  |  after   |
----------------------------------|----------|----------|
nr_processes=40                   |  0.3 ms  |   0.5 ms |
nr_processes=10000                |  3.0 ms  |  80.0 ms |

Link: https://lkml.kernel.org/r/20260114143642.47333-1-mathieu.desnoyers@efficios.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Backported without changes ]
Signed-off-by: Dmitrii Chervov <fary.ru@gmail.com>
---
My greeting to you LTS maintainers! This is my second kernel patch.
Servers in datacenters and cloud environments often have many CPUs
and run processes with similar memory footprints. On these systems,
errors in approximate RSS accounting can affect OOM victim selection.
Using precise RSS sums helps the OOM killer select victims based
on their actual memory usage.

 include/linux/mm.h |  7 +++++++
 mm/oom_kill.c      | 22 +++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f05962963e28..baa09a36c4a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2701,6 +2701,13 @@ static inline unsigned long get_mm_rss(struct mm_struct *mm)
 		get_mm_counter(mm, MM_SHMEMPAGES);
 }
 
+static inline unsigned long get_mm_rss_sum(struct mm_struct *mm)
+{
+	return get_mm_counter_sum(mm, MM_FILEPAGES) +
+		get_mm_counter_sum(mm, MM_ANONPAGES) +
+		get_mm_counter_sum(mm, MM_SHMEMPAGES);
+}
+
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
 {
 	return max(mm->hiwater_rss, get_mm_rss(mm));
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 8aa712afd8ae..53ab72f747fd 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -229,7 +229,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
+	points = get_mm_rss_sum(p->mm) + get_mm_counter_sum(p->mm, MM_SWAPENTS) +
 		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
@@ -403,10 +403,10 @@ static int dump_task(struct task_struct *p, void *arg)
 
 	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
-		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-		get_mm_counter(task->mm, MM_ANONPAGES), get_mm_counter(task->mm, MM_FILEPAGES),
-		get_mm_counter(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
-		get_mm_counter(task->mm, MM_SWAPENTS),
+		task->tgid, task->mm->total_vm, get_mm_rss_sum(task->mm),
+		get_mm_counter_sum(task->mm, MM_ANONPAGES), get_mm_counter_sum(task->mm, MM_FILEPAGES),
+		get_mm_counter_sum(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
+		get_mm_counter_sum(task->mm, MM_SWAPENTS),
 		task->signal->oom_score_adj, task->comm);
 	task_unlock(task);
 
@@ -598,9 +598,9 @@ static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
 
 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
 			task_pid_nr(tsk), tsk->comm,
-			K(get_mm_counter(mm, MM_ANONPAGES)),
-			K(get_mm_counter(mm, MM_FILEPAGES)),
-			K(get_mm_counter(mm, MM_SHMEMPAGES)));
+			K(get_mm_counter_sum(mm, MM_ANONPAGES)),
+			K(get_mm_counter_sum(mm, MM_FILEPAGES)),
+			K(get_mm_counter_sum(mm, MM_SHMEMPAGES)));
 out_finish:
 	trace_finish_task_reaping(tsk->pid);
 out_unlock:
@@ -954,9 +954,9 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
-		K(get_mm_counter(mm, MM_ANONPAGES)),
-		K(get_mm_counter(mm, MM_FILEPAGES)),
-		K(get_mm_counter(mm, MM_SHMEMPAGES)),
+		K(get_mm_counter_sum(mm, MM_ANONPAGES)),
+		K(get_mm_counter_sum(mm, MM_FILEPAGES)),
+		K(get_mm_counter_sum(mm, MM_SHMEMPAGES)),
 		from_kuid(&init_user_ns, task_uid(victim)),
 		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
 	task_unlock(victim);
-- 
2.43.0


