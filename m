Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7895FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E318E0006; Tue,  9 Sep 2025 05:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D153A8E0001; Tue,  9 Sep 2025 05:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52DE8E0006; Tue,  9 Sep 2025 05:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B23B08E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:52:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66E88B9875
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:52:50 +0000 (UTC)
X-FDA: 83869247700.20.C7FDDEE
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id B36EF1C000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:52:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U2O1zuTg;
	spf=pass (imf21.hostedemail.com: domain of 37_i_aAgKCC4iOZOSVSXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--yepeilin.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=37_i_aAgKCC4iOZOSVSXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--yepeilin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qOFVmhbI856obbOouijqOO2ps+J/JpM5ycRu9RASoGg=;
	b=XmAFUVELGQJmPRyH7kGE3qSCW09MkWrdymS9Ljs81KO10YABhYN1YSfJSgVz2VFitmeeEj
	2/XFMnqX0TO3mxuOTFpp3sDAyr27nR0/5cXHRCnd0U5yi8eEQjkD6eVKpAxI/X3hVK/feH
	Pn2wDwMSxaMUq3IB+cWXfssstWeNf/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411568; a=rsa-sha256;
	cv=none;
	b=2Ok4eDlHI7tuswZWE+Q0XTiZ6E4cR59N5NrA57EjbaX2YNvfzcpXohMTaBgU/prOLJQoOb
	BJNhHFjNxWaBETEeLs1Lm8BkBmU8hmNjrYxXdmk8LZQrSvExMVKfNKwpAY4PYINjyGRSTk
	5Bx2L+5bgeCpfxxzuCR0jQFASMEYaug=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U2O1zuTg;
	spf=pass (imf21.hostedemail.com: domain of 37_i_aAgKCC4iOZOSVSXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--yepeilin.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=37_i_aAgKCC4iOZOSVSXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--yepeilin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7724ff1200eso4928275b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757411567; x=1758016367; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qOFVmhbI856obbOouijqOO2ps+J/JpM5ycRu9RASoGg=;
        b=U2O1zuTgyXkR6itFbcl3Qdd2jh0eB/WEqJWsHCmrkKV8hgdrbggHdXG2jksnUwG4+n
         6JXntge7MpCiQ/IoD8Jc3Z3kv3SVtrKImZkk8W3sySw0T0fhT45cYAHoURxVTJG9Sw9n
         171CGdcKQMbh/RbsnWOiy5KBN/uuzWAc8Q/Br/ILZJ+HgtU+4b9vvZKUzaB33FdValZg
         X78bywjXHS0xkUhYkYzA3wZC9kflQIH2NRpRr0VmoukkxxU0X7zhyNISaOPEuLM622/t
         74+qWFrro6CjV+KEZ3gxwx2wMxjeEKrz8vgsoHZNK6Tqg6nUe1TJPrfpahiUuu49Au2x
         mrRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757411567; x=1758016367;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOFVmhbI856obbOouijqOO2ps+J/JpM5ycRu9RASoGg=;
        b=F+S5Cab6X/Z0BHSaTf1PdO/Y156MMVAvf0M6KSuoOXljflve4bsXxw9c3dt69rIgcO
         kgu4QsqLQVOxtv/i79W3HBWqUQW9GVdQzPmlq8a58oCEhKP7iWhfVW7zGyX9rYopE4ZG
         ij7us0GqUAb/B2w/FsOLaiCANs1Om10WhV0EXxdl62kzj5AEVq+556hu3egrylHTIG/i
         tx+54dMaZnVK7KVU1Oqe2yKFPNu3QxdyvisVSvalDdTNGcE6euRuvio+i0o1OHCrXono
         DaBcRZpJgf82dq4jGlWuc4+nQu6nIw8rcSJnJLagYYFORmay+HpzrlS+HylSysWUP16o
         JCSg==
X-Forwarded-Encrypted: i=1; AJvYcCVsWtPLMcviKLTeXXScWXwnn01CH40g3vxUeO7T7RBQDgyZzaAfaS5jOmstWqorGmdrH2cbkRnAQA==@kvack.org
X-Gm-Message-State: AOJu0YyhzHubobAX0qXVcP2MIg9oe1bepIDJuZh1S2//VW+z0ii2+5yo
	GVGUaAnDb9gG5Hv3IRsvPFsDT+iJgEDkZ1QR7856kD5zy7yMc7zOJ2f1YkS2RF8UrNHhVU4Gjfa
	bTxf6yTexEUHdxw==
X-Google-Smtp-Source: AGHT+IFqmQ+9VVjPtSUUrkCUHF3CruI5aNTXXYKoJuAYl4F0Pt7URhDMSiYRtDdjo9N8yw+OspG5qKJ1hqcjvg==
X-Received: from pfwy4.prod.google.com ([2002:a05:6a00:1c84:b0:772:630e:8fd4])
 (user=yepeilin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:983:b0:772:46b5:cc90 with SMTP id d2e1a72fcca58-7742de71235mr15612483b3a.32.1757411567046;
 Tue, 09 Sep 2025 02:52:47 -0700 (PDT)
Date: Tue,  9 Sep 2025 09:52:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909095222.2121438-1-yepeilin@google.com>
Subject: [PATCH bpf v2] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC in __bpf_async_init()
From: Peilin Ye <yepeilin@google.com>
To: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Peilin Ye <yepeilin@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, linux-mm@kvack.org, Leon Hwang <leon.hwang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B36EF1C000A
X-Stat-Signature: pw484xdki4qn141rq8apuw3i48hbhqcq
X-Rspam-User: 
X-HE-Tag: 1757411568-526818
X-HE-Meta: U2FsdGVkX182slAEM3S5aeGUlPSd7qRRBWUJ224JsBK2+Uxi8xC0EWP1XGBmOdOSumPQ0Bvn/NYNUkXopRMZpFZmYkPjNUMK5ZL8mZo4wwrjcL+5F5g0i/mtDtFmbpCWooVu7mTDORQYgBJS2KcUxnqxk/A4nIBBsoUVV3ftEXbHC1ILPLMLj7Agb+3yA2Mw3JAjvOGs7lX49g/HwSq5KBFk7t5iyU07emLiKd3t3o/slP+Cl/doF+4Xbgad2mzFVYw2KBUgcH61dljDb3iEuuyB3UbsBkbPdoRAV4HqW0+uV5wa1GENbGiYQDmwehm6gibO4nomO6jggN0FtvfiGIxknr3JkWE6NxhCq7srCoyNxFhYEJnEpW4UDIMz5HrkP+0XvV6badIGYHocLwM85Z/4Pz33MCBVMkHyJfzApqRoRz8zTxxZXWreeRRUuGWJKjQITPnSL5biIY5OgXdfLnxtVzm92LPJ6fEcOHsijaik/aSGexXkGEtG5lVoulPNQM897UoPoWaL8nJPUGhXqg7QNdzWFPF8QpbptqVxXexGRknNxnukDuVVze3JDtXQmFQxTZIwxbVbJkvMiHjCrlO/oU8QDSBkYLZH3gdaoa8x9yda6DpPMCdBXv66IPqyMapagP2GGVYqc1rrQsbC/3KBUw2LDIollGIwpN2P8lH3aKSQz3tV/MvFi9ztS/Aiu3/wSju6UQZbX2kB7xNXEzeEYcN2qwrAZ+FX3CE4/plA9zx0E972QktnPs7+BMGnsRrTNHCFFvdhYqeBqToJmQ1udmdg2uFOOBmwO3MBbWbhWwCekdIwGboeyTVPi1qnPJ7JPEp1E9KSRgay7tM3D1s0Q9H+7VaFRFCw3PDh4P5CDpWMVwIO+HUpVVy17Dl/BiOnO8uTkApwz2YCBWKTBNdRUIJReOstqtZVkQJgCXmM81kYoALqsx/B6uxRQbachcoRZGwtHczXhEyQFiz
 4p7D3irp
 yn9Mk0MmmP7T83iLjpIUJHtWyEL2r42DeuELw1HljDQquJ5UUZPv1drbKPY2HgXZJXaWAAsUy1yokustacdUjvB2wpMk4aiJoR7AwVt8+nAqpYCK3BJtXCbAYfPhh3PyV/8TzDjnTmRpWReEqLv2jy7WYHupu6DLbcSKqa7cHUM6jWV1pifHwFJxNOzbgbx29zwRj8w/WL+Om7MuvWlx5dkOPBKpm7KbLSPVGuMSQz0IlpIWnwShYffUCZ/xVqYed1/4k0vzkXjdKfGVezTJzadXlrdJ8amznMLgIWU54Las2ekF+pa2AMJOrZzLgIcBnpiG1nkMGtRXvo3ShiapnM6qr/b43Ajst/T37vum5YVAuEhLsOSQLs2R9HYjn6IHEJ3EntAMjbL5LRMhEdOjQyRb2Nx2pNGE4jv0/nW2F2ACXxhvcIKmfc0mZ6v7tSzg488Mjc2iqyCu061vDMWlmVfUtoH41NjcoDdM5CuVnSqw02wrccTieMRSXj+kwPMVQ3BTz67/ocDGt3CvTK6wvv79PtQc7Z2zSF+RRpEzS61yMNAo+7CXQs2MZyi/Qv6BukvtsiuPDF6IFyxYOUV7z268JJ+f9EFvlGq3yRzKqQcprm9WV4J22hTVmNKST4d1C5Ns16RefJ9iDbcm9eR0X1dSYxHybYrUR68w415hiDbsAdhPmB3myyGxXPDL6gxpDva8k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, calling bpf_map_kmalloc_node() from __bpf_async_init() can
cause various locking issues; see the following stack trace (edited for
style) as one example:

...
 [10.011566]  do_raw_spin_lock.cold
 [10.011570]  try_to_wake_up             (5) double-acquiring the same
 [10.011575]  kick_pool                      rq_lock, causing a hardlockup
 [10.011579]  __queue_work
 [10.011582]  queue_work_on
 [10.011585]  kernfs_notify
 [10.011589]  cgroup_file_notify
 [10.011593]  try_charge_memcg           (4) memcg accounting raises an
 [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
 [10.011599]  obj_cgroup_charge_account
 [10.011600]  __memcg_slab_post_alloc_hook
 [10.011603]  __kmalloc_node_noprof
...
 [10.011611]  bpf_map_kmalloc_node
 [10.011612]  __bpf_async_init
 [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
 [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
 [10.011619]  bpf__sched_ext_ops_runnable
 [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
 [10.011622]  enqueue_task
 [10.011626]  ttwu_do_activate
 [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
...

The above was reproduced on bpf-next (b338cf849ec8) by modifying
./tools/sched_ext/scx_flatcg.bpf.c to call bpf_timer_init() during
ops.runnable(), and hacking [1] the memcg accounting code a bit to make
a bpf_timer_init() call much more likely to raise an MEMCG_MAX event.

We have also run into other similar variants (both internally and on
bpf-next), including double-acquiring cgroup_file_kn_lock, the same
worker_pool::lock, etc.

As suggested by Shakeel, fix this by using __GFP_HIGH instead of
GFP_ATOMIC in __bpf_async_init(), so that e.g. if try_charge_memcg()
raises an MEMCG_MAX event, we call __memcg_memory_event() with
@allow_spinning=false and avoid calling cgroup_file_notify() there.

Depends on mm patch "memcg: skip cgroup_file_notify if spinning is not
allowed".  Tested with vmtest.sh (llvm-18, x86-64):

 $ ./test_progs -a '*timer*' -a '*wq*'
...
 Summary: 7/12 PASSED, 0 SKIPPED, 0 FAILED

[1] Making bpf_timer_init() much more likely to raise an MEMCG_MAX event
(gist-only, for brevity):

kernel/bpf/helpers.c:__bpf_async_init():
 -        cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
 +        cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC | __GFP_HACK,
 +                                  map->numa_node);

mm/memcontrol.c:try_charge_memcg():
          if (!do_memsw_account() ||
 -            page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 -                if (page_counter_try_charge(&memcg->memory, batch, &counter))
 +            page_counter_try_charge_hack(&memcg->memsw, batch, &counter,
 +                                         gfp_mask & __GFP_HACK)) {
 +                if (page_counter_try_charge_hack(&memcg->memory, batch,
 +                                                 &counter,
 +                                                 gfp_mask & __GFP_HACK))
                          goto done_restock;

mm/page_counter.c:page_counter_try_charge():
 -bool page_counter_try_charge(struct page_counter *counter,
 -                             unsigned long nr_pages,
 -                             struct page_counter **fail)
 +bool page_counter_try_charge_hack(struct page_counter *counter,
 +                                  unsigned long nr_pages,
 +                                  struct page_counter **fail, bool hack)
 {
...
 -                if (new > c->max) {
 +                if (hack || new > c->max) {     // goto failed;
                          atomic_long_sub(nr_pages, &c->usage);

Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Peilin Ye <yepeilin@google.com>
---
v1: https://lore.kernel.org/bpf/20250905234547.862249-1-yepeilin@google.com/
change since v1:
 - simplify comment, and mention kmalloc_nolock() (Shakeel)

 kernel/bpf/helpers.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b9b0c5fe33f6..8af62cb243d9 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1274,8 +1274,11 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
 		goto out;
 	}
 
-	/* allocate hrtimer via map_kmalloc to use memcg accounting */
-	cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
+	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Until
+	 * kmalloc_nolock() is available, avoid locking issues by using
+	 * __GFP_HIGH (GFP_ATOMIC & ~__GFP_RECLAIM).
+	 */
+	cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
 	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.51.0.384.g4c02a37b29-goog


