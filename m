Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12333CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 19:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359888E0002; Fri, 19 Sep 2025 15:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3311C8E0001; Fri, 19 Sep 2025 15:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246B88E0002; Fri, 19 Sep 2025 15:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B508E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:52:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5D371A073A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:27 +0000 (UTC)
X-FDA: 83907046734.21.A977B47
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 00BC9C000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mBsounJ8;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758311546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BhEwl8pjUtCVBar7ssCbBQPYD+y8By4S7sJUUFiinZg=;
	b=ryR0KT5qtWqbXnQPdi/hWV12qGjrMjSz2jt1jwzJZnL0T+u2TsfF+VINkomkTP/shollbU
	UWC0eFPBh/vIjGdRqUctkiua4RaGmb9Ze+POZ42s8CJQtYKGFmYvHq6mdhEHObPHnxlm/w
	bvbht/QvcUWTkp5uCPVliAsZ8mYIX4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758311546; a=rsa-sha256;
	cv=none;
	b=xksQEsn4fazU2PY2vaiNCParVMVivLVEoW/SAIzIaln3Tj0hCWO3zjPP0gtwfdD/3ViQsj
	nI8JI/fR/d/4nhOgO+NjFGpHLbQVuKM+GRfdOUKB7ee3ojIWKyNtQYVV8JNe1H5dsborMt
	SiCJ21AXWI/qKkGGmu2o1cE27FgabcQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mBsounJ8;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-ea3c51e4cffso2150239276.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758311545; x=1758916345; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BhEwl8pjUtCVBar7ssCbBQPYD+y8By4S7sJUUFiinZg=;
        b=mBsounJ8e1cZvq+HiDRYQiaH6EV9MLvstH71Vt3+SGtNenofHy6mWO+/fYWb1Z7FIC
         eKSV0WIyprn/AbU8dZBd7HKSkuXXs2BQ/oH9paVmnSK3j4RtCEoD0oN3h8DEbbd3MofS
         h8CkMvtl2iEu4tVYlcaSvKjwE2XSMnW5sIneVkKhCIxgCB79sFmvVrMX3JuL3D+Zt1WZ
         4EdxvZtRUHbKKer3XnoMm1kQcB6YMlcZ8sgMQK01uaLfRKJ5C0OsXMMfxdcVEDaVTZQN
         0u2ySRUpy0QED7HJuHP+52YWHS/jLFJ7GWZal+1Q2hYx/+ct+bwLMvLlnYqPndLltY84
         RWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758311545; x=1758916345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhEwl8pjUtCVBar7ssCbBQPYD+y8By4S7sJUUFiinZg=;
        b=tKG7pCRnCgkXxKdI/jmh6fO/zLipHYfb5A9xAHoq7KqCX/xatvKyNWur8aebNsJaaC
         Zj++/XUFmO60LUSk8GGwiU0Xa/coBziZthqGKPu6XUy76YbtZBLStzYKtLn1vWFxniJv
         xu/gIR6kq/uuo41u+BVVm2le6rAvGlycEFdoEU9PLvev7sga0Glduv0pPV/Js5z1WhHZ
         y3kkyQczGRCtdXSH1L2AXiffveHDJ8qu8pqTlbST3eNLVKK/h3TazyOuoJOlcG38fFMv
         0mGui2hPzq/nMLlfGv8xwMUh1DOklg7KT4MbzdbEq7kmEz+/qiCR9juvXmITm2ImLRLF
         8tww==
X-Forwarded-Encrypted: i=1; AJvYcCX3WCJYzwNOvwfTve4AuKrRIsiXwjhBLiRzaBMU8uajpbdG3Cnbgbjy2mSCSj1bB62BC2DWMYR+1w==@kvack.org
X-Gm-Message-State: AOJu0YzGY5Zcqvadcqt9GU+0FGJJvRHh9B0FYfiw8CY/QaZLqZAtl1cJ
	kvupUYBKLX9zcTPBYZmqAJls0CTO0xsymcSy84o3Yrr7Dfudlsi58Fi4
X-Gm-Gg: ASbGnct0jBgJyrAwuf9AEib6cPsMcC44FNiHkZph4m1n3B9jnEQNSrTXT1H+Fgct1ll
	0zew3XXZq28K3/0eN8hFKSG9nO9kPihFxdUIL0izuD2wyDImkqATrjPng6xt2Hx/npo4jHZl4Le
	HLmwbhk0cT8xzaqxWZowkrqcq4VXmbKyOQ4gj9yuJMoil3S/nkzGLgNVQIkBJ0hwLY2IAymNo2y
	m7gMq1lQeXWSquZB9PgAEMfTgamYT5Kkv9iJB3zP7mt7h083YhIhgCgynQV+d2FAKcxeI5biMsF
	owBLgbzSIsATw82MSWJH8frAml9uzIwwD6KkpGL7lvB8yaQFhbJRnDBIWRJMG8S7tUPe8JjZvfZ
	naBZc8sTmLTXR3BN0VyXOZMFTouaOSQhuSVh7KU9R1Fhk4CgA2i49pLC0O0JNwKtr
X-Google-Smtp-Source: AGHT+IHxfeVdvX9Ciy91R5deOME+aYv7ueJmUkVtXCCRJQe6Fue8/urAgnuJqKKsNGsZiuMfMWy42A==
X-Received: by 2002:a05:690c:2603:b0:734:f858:b1e7 with SMTP id 00721157ae682-73d3ce7a14emr44257107b3.27.1758311544831;
        Fri, 19 Sep 2025 12:52:24 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-739716c0506sm16663587b3.9.2025.09.19.12.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 12:52:24 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 0/4] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Fri, 19 Sep 2025 12:52:18 -0700
Message-ID: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00BC9C000A
X-Stat-Signature: f4uzsz41rq9os8xxgjizg6hwyczqaiq7
X-Rspam-User: 
X-HE-Tag: 1758311545-11843
X-HE-Meta: U2FsdGVkX1+bmF44wBk4CTzvze8yE2cxA6JtfsEt2UdOgBhx7a6P2zyAqX+CMjFbKN1QtD9MEPhyfPdwPYerCow917zhvLwZGhD740tb/vQO9A6ufDxiuGlSJGT0RPamDqm9PXtS323PnakPJ/K6vzVnXVqqUgWnQ8nbu3yrKlboaVUadYngMnx7pJPvT284wxVUjltgvRcLj8OoQhDsmYhgctOEbdRDbGzGKW3TRgGTaiQ4DpuBeNcgKuBWhP/S6UtGAbaMT2eVlvwg9nbHZsD7P/ZSvheUsnYjqxBAzuMbb4ROvj0z9urxYCgt3ZRsrzCDIUFAeP2TGsgMSzVD/PqhPfMzneqO7h1Y/L34K74PP4rx4hZBZwG3q+LL1D13Ls5usCt3dB6z6VKURTwkCMP6HsMMUC0PTP7SgQ6WXPZH0yMeLfLnoMTaV3Oopp0e2Tvc3kh8hA/sa1zUFfLXmzbE23x5hNW3waWCVpFHTAw523rEOZ+jKPpXtPbqG8ZxgxfwRjGKW6qd7Hb7c3UyvaNffh+X+b0V4Xm6UihdMMpDiIoPN5Jfpx0UOkopFmyC4YlrQGOaKBaFdfGfPqOO6XCGxBJxqBPiJHZblhz/mAau3EoCeBa/8/fTuZjvhy6cHWq5k73NFxkp1R0vUuqvMXoTqQkm/zhlnsisa0qBgeQ/oGd4FvC7eL7x/CtSiRxCydIL3U8L3HmGf0s3elhHz5YTyTeekaJ07QhKZcSdN2Nvh6frtOnA+eEXS4XeqeBcPqm7OQ+kOg31sq7Dn0qKPnmM4CI4p39kc5Z9CJYXgxVSl06cH44ddQxfrZPsxbJDIzSBW5PRvIUcy8E1brtuWGbyGON6PmzhvuN4iKBG7VyWSIytqOiYCUeFr529tODvlA4+26uIBkr8ZwRfYo8Bk+KaZnJ4wyNmyH47UoPRvBXAOtGebarCbaSBTsNAahKNdKqR+ngbxN10G0DrZAF
 BEe0Pzg/
 dNWa24hDzBQiFqMe80F4VuP/lomnCnrOmKj4N9pHud4DkdoRR1kSwhpg7rREd/23BxjWzlveN1vFq3g3Q06VH5VQqL0OCi4e1DyY5QBkl6vImFs+AjaZytTgsBXBaifdAnKSTGFBpWgcRCdMxUlwzhXesZCokOWhpsfMKz6Mf3Lt9LDJJjsYAVwanYmzM+gdYbB0WSBGGKqgdoKsGOp9fybRn58c3dCYbk9w7h8pQ9JHkZC55emLOqCYJ71BLuiBS3HQa2Ih6Bv87/JaaeJ/9WL/RVwffSK739TjxMKOevfFSUGP2YyMpQcDtyDS6ioftBEFHayapHpuWvZRsQwzybzkDtGPIl3m1wly9tVfIMP0/crk3bQ9OhO4zDpcxk8cqCxI1XcaSfk65ikSwu/QGMKjIYxL00qNsniGUt0nYpoyALL0jVEkbLw/tzQUVt9rvKGepnMILu0/joXxMXPkiPuc8i0MGq8ocW4MBf9V7saku0gViRDHNRByu+3zEXlPIojzRoeqVFofxv+tFfAHlA/oio847Uq8SwOMqF8c1VUERIy0YqGmA6Qn7P/hICXhQwfbV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While testing workloads with high sustained memory pressure on large machines
(1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
Further investigation showed that the lock in free_pcppages_bulk was being held
for a long time, even being held while 2k+ pages were being freed [1].

This causes starvation in other processes for both the pcp and zone locks,
which can lead to softlockups that cause the system to stall [2].

[ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
[ 4512.604370] rcu: 	20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
[ 4512.626401] rcu: 	         hardirqs   softirqs   csw/system
[ 4512.638793] rcu: 	 number:        0        145            0
[ 4512.651177] rcu: 	cputime:       30      10410          174   ==> 10558(ms)
[ 4512.666657] rcu: 	(t=21077 jiffies g=783665 q=1242213 ncpus=316)

And here is the trace that accompanies it:

[ 4512.666815] RIP: 0010:free_unref_folios+0x47d/0xd80
[ 4512.666818] Code: 00 00 31 ff 40 80 ce 01 41 88 76 18 e9 a8 fe ff ff 40 84 ff 0f 84 d6 00 00 00 39 f0 0f 4c f0 4c 89 ff 4c 89 f2 e8 13 f2 fe ff <49> f7 87 88 05 00 00 04 00 00 00 0f 84 00 ff ff ff 49 8b 47 20 49
[ 4512.666820] RSP: 0018:ffffc900a62f3878 EFLAGS: 00000206
[ 4512.666822] RAX: 000000000005ae80 RBX: 000000000000087a RCX: 0000000000000001
[ 4512.666824] RDX: 000000000000007d RSI: 0000000000000282 RDI: ffff89404c8ba310
[ 4512.666825] RBP: 0000000000000001 R08: ffff89404c8b9d80 R09: 0000000000000001
[ 4512.666826] R10: 0000000000000010 R11: 00000000000130de R12: ffff89404c8b9d80
[ 4512.666827] R13: ffffea01cf3c0000 R14: ffff893d3ac5aec0 R15: ffff89404c8b9d80
[ 4512.666833]  ? free_unref_folios+0x47d/0xd80
[ 4512.666836]  free_pages_and_swap_cache+0xcd/0x1a0
[ 4512.666847]  tlb_finish_mmu+0x11c/0x350
[ 4512.666850]  vms_clear_ptes+0xf9/0x120
[ 4512.666855]  __mmap_region+0x29a/0xc00
[ 4512.666867]  do_mmap+0x34e/0x910
[ 4512.666873]  vm_mmap_pgoff+0xbb/0x200
[ 4512.666877]  ? hrtimer_interrupt+0x337/0x5c0
[ 4512.666879]  ? sched_clock+0x5/0x10
[ 4512.666882]  ? sched_clock_cpu+0xc/0x170
[ 4512.666885]  ? irqtime_account_irq+0x2b/0xa0
[ 4512.666888]  do_syscall_64+0x68/0x130
[ 4512.666892]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[ 4512.666896] RIP: 0033:0x7f1afe9257e2

To prevent starvation in both the pcp and zone locks, batch the freeing of
pages using pcp->batch. 

Because free_pcppages_bulk is called with both the pcp and zone lock,
relinquishing and reacquiring the locks are only effective when both of them
are broken together. Thus, instead of modifying free_pcppages_bulk to break
both locks, batch the freeing from its callers instead. 

In our fleet, we have seen that performing batched lock freeing has led to
significantly lower rates of softlockups, while incurring relatively small
regressions (relative to the workload and relative to the variation).

The following are a few synthetic benchmarks, made on a machine with
250G RAM, 179G swap, and 176 CPUs. 

stress-ng --vm 50 --vm-bytes 5G -M -t 100
+----------------------+---------------+----------+
|        Metric        | Variation (%) | Delta(%) |
+----------------------+---------------+----------+
| bogo ops             |        0.0120 |  -0.0011 |
| bogo ops/s (real)    |        0.0109 |  -0.0091 |
| bogo ops/s (usr+sys) |        0.5560 |  +0.1049 |
+----------------------+---------------+----------+

stress-ng --vm 10 --vm-bytes 30G -M -t 100
+----------------------+---------------+----------+
|        Metric        | Variation (%) | Delta(%) |
+----------------------+---------------+----------+
| bogo ops             |        1.8530 |  +0.4728 |
| bogo ops/s (real)    |        1.8604 |  +0.2029 |
| bogo ops/s (usr+sys) |        1.6054 |  -0.6381 |
+----------------------+---------------+----------+

Patch 1 simplifies the return semantics of decay_pcp_high and
refresh_cpu_vm_stats, which makes the change in patch 3 more semantically
accurate. 

Patch 2, 3, and 4 each address one caller of free_pcppages_bulk, and ensures
that large values passed to it are batched. 

This series is a follow-up to [2], where I attempted to solve the same problem
by relinquishing only the zone lock within free_pcppages_bulk. Because this
approach is different in nature, I decided not to send this as a v2, but
as a separate series altogether. 

[1] For instance, during *just* the boot of said large machine, there were
    2092 instances of free_pcppages_bulk being called with count > 1000.
[2] https://lore.kernel.org/all/20250818185804.21044-1-joshua.hahnjy@gmail.com/

Joshua Hahn (4):
  mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
  mm/page_alloc: Perform appropriate batching in drain_pages_zone
  mm/page_alloc: Batch page freeing in decay_pcp_high
  mm/page_alloc: Batch page freeing in free_frozen_page_commit

 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     | 65 ++++++++++++++++++++++++++++++++-------------
 mm/vmstat.c         | 26 +++++++++---------
 3 files changed, 61 insertions(+), 32 deletions(-)


base-commit: 097a6c336d0080725c626fda118ecfec448acd0f
-- 
2.47.3

