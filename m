Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2054EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16D816B0213; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE3F6B0246; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00986B0246; Thu, 13 Aug 2026 04:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06E96B020F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:52:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4616BA2BBD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:15 +0000 (UTC)
X-FDA: 85095629430.25.FE606F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69411140005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZmubVdxz;
	spf=pass (imf26.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qFiT+Pr1AQIU4ZNv6NmG1FCSg5BHa1g8bQiWrMBibjc=;
	b=JVpfFFfzDVVdnToJkhnKiFgJDyxrogO7gbT1uuGNsdPWrWtY3SrHp2hCwvrHcRNNbPSqis
	Vu7H90XR1Lu077Sm0b4uxAI1mD7HlZNtbCMaU3PUzcnz0wgwAv7o3BsqSGy8FRF5uXdTm9
	rapKUCHG6+wpXx1a5/1yF2/jrsyD1lQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZmubVdxz;
	spf=pass (imf26.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611133;
	b=ThUHDAnxHueK0afOX1YAQHcEjPFww781a8vzmznxOOf7KoE6ScZxo3j3OJwQ+Zm3Bb539k
	dKyKRrfbwfKAqDZ7GB8OfwLmD2z6ySsGV7fyrNCz8I4c3p20A1JVbJrTKwD+ROCt9Gl8cZ
	uAiAvVohXzFk8ThQC+EqHKChfbT7LOU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA430600AD;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7ECC3C19425;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=KF0xDds5w/g3aR4DwwjXLrfgHcalIYAD5qSFXpEkNZo=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ZmubVdxz9PvR78VwNZN9dI8t+pCcbr17Uw6NOD5C4hUenogFMlJbEEk5DMzsd76nV
	 nWucf13kMBKzNuQEJ/VDYSlW8RO/3HcYLUTBn1gu8jxsohTdfsTe4UXDGzDM/v+mOd
	 MROcreMGooBVcsg3iicgnrihFGupArSM6THEaJ+gKtyA/NznYLSm12dfguSCjtfZO9
	 5zELh7GRDZGdTi95tdfD2aNurj1YArXahTM62tzOgcUq2sVOvtbL+ImGABA8wCcwXg
	 9vkdxH2YobcgTNFnFVOf3wZVLeQgyLWqo4mekm7kdzdm6hvs1ZBBi5xgRzcJbl/OxZ
	 hYlNHF1N4thcw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B42C5B572;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Subject: [PATCH RFC 0/5] memcg: fix dying memcg pinned by swapped out shmem
 pages
Date: Thu, 13 Aug 2026 16:52:01 +0800
Message-Id: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALGFfWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDC0Mj3dzU3OT0zBTd/KSs5HTdlFTLNFNzi9Q0QyMLJaCegqLUtMwKsHn
 RSkFuzkqxtbUAC7c3uGQAAAA=
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bfguo@icloud.com>, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=8802;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=KF0xDds5w/g3aR4DwwjXLrfgHcalIYAD5qSFXpEkNZo=;
 b=hUrUDZC9vcOK4OhNBfILovwU//i4z7hYvRM++jGf52u9aDMx/T9svF5e/5e6H0/Vo6vuGcDvg
 617UoZDI/mGCGlGwEbZl9RhW3tXxl9pF2W2iefCg3lfi/SV4y/rTPQ6
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 69411140005
X-Stat-Signature: 83t5wzummdu4i4etypxu67zkaiwufn4e
X-Rspam-User: 
X-HE-Tag: 1786611133-184000
X-HE-Meta: U2FsdGVkX19p436N7IjZMCqzrDdspuouFJoC57VEKXx04xnTGQC8OG48fwlX1wnfUhufJK0ELPPRMpKf+yEUspORhIMsHlSwjBm7LMuZBJ0JsdpF7UpKV6owmpgxAWdecotFuC1IrXDq5H2yijB+jgicm0c2RUaZYpAw1NuBKYh/wOpCyLlYlxh52aAxHcu4vnvubDyUDayMDL2FhFxe9Sojwlofy97xjgxC7McLuJYSD0gaqeSyjdy1KX2nUWjeueQ/29oJfsIzi44j3f+z/Ias0iQsl4KVUkPL+BBmbFqvkwKDNLoSsb21lNkh8MVnVsDxLnOgHn/PaiEWRS/IlfWs0wctAcKv3krIMwX+jPNUFrLtrTfWOvjQw+uQbfv5PoCI1PFoVFoJaJyThhvnzl7CSSbu5b2K+6M5yFguT5yXqh+tQrVBTGlECBdhhw4olK3dSz9mkpgLR/OehmHSeivveLsTrF6l9j2sG0YY1CoDJwfOTd9m2hZvSxc71vYpt0ihccQRpJp1qcCz1Hvuzcs6HEx29oCVL9/1k7RnaDUSkC2VAaWo8mKz6rnzGhPcL/pDsYY5tvlaJzHLFBUnB2uSR1MLSMuaN6UPwLkOF1ovlNiU4W8EZhOPrWXrsxn0jbzHrxjFqrWqwv+IsyjIbpdhrPjORApKWAfRdip6nR9g7dt3Qg+5tZu8ZsvVKbq4q64ffq6E9MQhA97osjwuHvLX1ROu6uV9hvbjIxgLUDFtPy5WC2EXJqpio4RtUETMhZzEEOlk7nRRjEXwVNI08vnDB2pw8UWjtjQYrTcHYREysCkce5barEz8hSQx6d2yrqAKGwvhDrCFvCkHmRqVhqgvhRil3y4RhQjvTkZJvQqpLC7BIpz/nNDw8Hao8Draxmn5I4mXeRDmOYSq+PtXiDPId6GrvHLwdtv24/JcxUUTiGlyPuZYo2EgCiX04ppgjnvKNxhSNiUFwgsgnuF
 bcLn9UF/
 f/+untfs2Nh2UoL/CQMKp514AYE/AIyy7rSeXCBXISZuMtn5XICqHuUonj8Fc6kkAMxt0E29RuxyW9wty/hzQZqz8fGuvzUR97HURMQK7GJ04WL4MpnDVdL1DSXUf/yAYHgL8QblFOOVZUZraJe+/gM+6nDZ2UBuKTrldWrzfKsOa4IiAqAE03IW7Z0rItW7JZYzH5k6JdHWb0gmOeo+udTCF2EZOyI5WFDjY24HavxrqNx3jjMzOnXgAIpWn7jrvqAy4Ckeh9LSKSNmoY65u63+pv3XhmjKqeAxGJLO26TQm+X8M0Rcni0x2qyLm7E6S4ogrCfoLvxwxWkfXcY3YiklyNQ06lywG/feVbvve9iHA6iq/8P3wEEBXrqFWpdzeaUBWtBfPw1Mt4h9J2IEgdudbL/juFAIcJeOe+GGXBk5IGp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the private ID of a memory cgroup holds a reference to its
css, so that users such as list_lru and swap entries can look the memcg
up by ID even after it has gone offline.

This has a downside: a memcg that still owns swapped out shmem pages is
pinned via its private ID and is never released until those pages are
swapped back in. Workloads that create and destroy many cgroups can
accumulate a large number of dying memcgs.

This series fixes that by moving the memcg private ID reference count
from the memcg to its object cgroup. The objcg is cheap to keep alive
and is reparented to an online ancestor when its memcg goes offline, so
holding the ID no longer pins the css.

Patch 1 (memcg: move memcg private ID refcount to objcg)

Move the ID refcount from the memcg to its objcg, so swapped out pages
no longer pin the dying memcg. The online state pins the objcg, and the
ID is released in css_released() after reparenting; this guarantees the
id refcount is alive for any caller holding a memcg reference. After
reparenting, mem_cgroup_from_private_id() returns a live ancestor
instead of the original memcg; callers that need the exact memcg are
fixed in patch 5.

Patch 2 (memcg: get stable memcg first before getting memcgid reference)

Both __memcg1_swapout() and __mem_cgroup_try_charge_swap() now take a
stable memcg reference first via get_mem_cgroup_from_objcg() and pin
the ID afterwards, dropping the rcu_read_lock() usage and the
get-error-put handling, and recording exactly the memcg the folio
belongs to in the swap entry.

Patch 3 (memcg: remove retry logic in mem_cgroup_private_id_get_online)

With the ID released only in css_released() (patch 1) and every caller
holding a stable reference (patch 2), the retry loop that walked up the
parent chain can never trigger. Remove it, rename the function to
mem_cgroup_private_id_get().

Patch 4 (memcg: add a helper to get online memcg from memcgid)

Add mem_cgroup_from_private_id_online(), which looks the ID up and
takes a reference through the objcg. Since the objcg is always
reparented to an online memcg, this guarantees an online memcg. Use it
in mem_cgroup_swapin_charge_folio(), dropping the manual id lookup and
css_tryget_online() check under the RCU read lock.

Patch 5 (memcg: filter out reparented memcgs got using memcgid)

After reparenting, mem_cgroup_from_private_id() can return a memcg that
no longer owns the ID. Callers such as list_lru and workingset refault
expect exactly the memcg the ID refers to, so check that the returned
memcg still owns the ID and return NULL otherwise, letting the callers
skip the entry.

The following program reproduces the problem: it repeatedly creates a
memcg, dirties one shared shmem page, pushes it to swap, and destroys
the cgroup. Each iteration leaves a dying memcg pinned by the swapped
out page.

shmem_dying_memcg.c:

```c

static int write_str(const char *path, const char *val) {
    int fd = open(path, O_WRONLY);
    if (fd < 0) return -1;
    int rc = write(fd, val, strlen(val)) < 0 ? -1 : 0;
    close(fd);
    return rc;
}

static long long dying_memcgs(void) {
    FILE *f = fopen(CG_ROOT "/cgroup.stat", "r");
    if (!f) return -1;
    char k[64];
    long long v = -1;
    while (fscanf(f, "%63s %lld", k, &v) == 2)
        if (!strcmp(k, "nr_dying_subsys_memory")) break;
    fclose(f);
    return v;
}

// worker: join the memcg, dirty one shared shmem page, swap it out, exit.
static void worker(const char *cgdir, const char *shmfile) {
    char pid[16];
    snprintf(pid, sizeof pid, "%d", getpid());
    if (write_str(cgdir, pid) < 0) _exit(1);           // cgroup.procs

    int fd = open(shmfile, O_CREAT | O_RDWR | O_TRUNC, 0644);
    if (fd < 0 || ftruncate(fd, PAGE) < 0) _exit(2);
    char *p = mmap(NULL, PAGE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (p == MAP_FAILED) _exit(3);
    close(fd);

    p[0] = 1;                                          // fault in + dirty
    if (madvise(p, PAGE, MADV_PAGEOUT) < 0) _exit(4);  // push to swap
    _exit(0);
}

static void one_iter(long i) {
    char cgdir[256], procs[300], shmfile[300];
    snprintf(cgdir,   sizeof cgdir,   "%s/m%ld", CG_BASE, i);
    snprintf(procs,   sizeof procs,   "%s/cgroup.procs", cgdir);
    snprintf(shmfile, sizeof shmfile, "%s/f%ld", SHM_DIR, i);

    if (mkdir(cgdir, 0755) < 0 && errno != EEXIST) return;

    pid_t pid = fork();
    if (pid == 0) worker(procs, shmfile);
    waitpid(pid, NULL, 0);

    rmdir(cgdir);   // memcg goes dying; swapped page pins its id
}

static void cleanup(void) {
    struct dirent *de;
    char p[512];
    DIR *d = opendir(CG_BASE);
    if (d) {
        while ((de = readdir(d)))
            if (de->d_name[0] == 'm') {
                snprintf(p, sizeof p, "%s/%s", CG_BASE, de->d_name);
                rmdir(p);
            }
        closedir(d);
    }
    d = opendir(SHM_DIR);
    if (d) {
        while ((de = readdir(d)))
            if (de->d_name[0] != '.') {
                snprintf(p, sizeof p, "%s/%s", SHM_DIR, de->d_name);
                unlink(p);
            }
        closedir(d);
    }
    rmdir(CG_BASE);
    rmdir(SHM_DIR);
    printf("cleanup done; nr_dying_subsys_memory = %lld\n", dying_memcgs());
}

int main(int argc, char **argv) {
    if (geteuid() != 0) { fprintf(stderr, "run as root\n"); return 1; }

    if (argc > 1 && !strcmp(argv[1], "--cleanup")) { cleanup(); return 0; }
    long n = argc > 1 ? atol(argv[1]) : 1000;

    mkdir(CG_BASE, 0755);
    write_str(CG_ROOT "/cgroup.subtree_control", "+memory");
    if (write_str(CG_BASE "/cgroup.subtree_control", "+memory") < 0) {
        fprintf(stderr, "enable +memory: %s\n", strerror(errno));
        return 1;
    }
    mkdir(SHM_DIR, 0755);

    printf("before: nr_dying_subsys_memory = %lld\n", dying_memcgs());
    for (long i = 0; i < n; i++) one_iter(i);
    printf("after:  nr_dying_subsys_memory = %lld  (created %ld memcgs)\n",
           dying_memcgs(), n);
    printf("release with: sudo %s --cleanup\n", argv[0]);
    return 0;
}
```

Run with:

```bash
echo "=== before ==="
grep dying /sys/fs/cgroup/cgroup.stat

sudo ./shmem_dying_memcg "$@"

sleep 1

echo
echo "=== after (root cgroup.stat) ==="
grep dying /sys/fs/cgroup/cgroup.stat
```

To release the pinned memcgs:
$ sudo ./shmem_dying_memcg --cleanup

Results on my machine (20000 iterations):

Before this series, all 20000 destroyed memcgs stay dying:
```
=== before ===
nr_dying_descendants 20002
nr_dying_subsys_cpuset 0
nr_dying_subsys_cpu 0
nr_dying_subsys_io 2
nr_dying_subsys_memory 20002
nr_dying_subsys_perf_event 0
nr_dying_subsys_hugetlb 0
nr_dying_subsys_pids 0
before: nr_dying_subsys_memory = 20002
after:  nr_dying_subsys_memory = 20002  (created 20000 memcgs)
release with: sudo ./shmem_dying_memcg --cleanup

=== after (root cgroup.stat) ===
nr_dying_descendants 20002
nr_dying_subsys_cpuset 0
nr_dying_subsys_cpu 0
nr_dying_subsys_io 2
nr_dying_subsys_memory 20002
nr_dying_subsys_perf_event 0
nr_dying_subsys_hugetlb 0
nr_dying_subsys_pids 0
```

After this series, dying memcgs no longer accumulate:
```
=== before ===
nr_dying_descendants 0
nr_dying_subsys_cpuset 0
nr_dying_subsys_cpu 0
nr_dying_subsys_io 0
nr_dying_subsys_memory 0
nr_dying_subsys_perf_event 0
nr_dying_subsys_hugetlb 0
nr_dying_subsys_pids 0
before: nr_dying_subsys_memory = 0
after:  nr_dying_subsys_memory = 314  (created 20000 memcgs)
release with: sudo ./shmem_dying_memcg --cleanup

=== after (root cgroup.stat) ===
nr_dying_descendants 0
nr_dying_subsys_cpuset 0
nr_dying_subsys_cpu 0
nr_dying_subsys_io 0
nr_dying_subsys_memory 0
nr_dying_subsys_perf_event 0
nr_dying_subsys_hugetlb 0
nr_dying_subsys_pids 0
```

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
Bingfang Guo (5):
      memcg: move memcg private ID refcount to objcg
      memcg: get stable memcg first before getting memcgid reference
      memcg: remove retry logic in mem_cgroup_private_id_get_online
      memcg: add a helper to get online memcg from memcgid
      memcg: filter out reparented memcgs got using memcgid

 include/linux/memcontrol.h |  11 +++-
 mm/list_lru.c              |   2 +-
 mm/memcontrol-v1.c         |  23 +++----
 mm/memcontrol-v1.h         |   3 +-
 mm/memcontrol.c            | 151 ++++++++++++++++++++++++++++++---------------
 mm/workingset.c            |   6 +-
 6 files changed, 126 insertions(+), 70 deletions(-)
---
base-commit: 288058d8db5d35623228d84f48d9bea3707d5c85
change-id: 20260812-memcgid-objcg-de9f578ef128

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



