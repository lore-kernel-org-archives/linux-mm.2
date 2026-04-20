Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74CDF557EB
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063BB6B00E0; Mon, 20 Apr 2026 04:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B3C6B00E1; Mon, 20 Apr 2026 04:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93776B00E2; Mon, 20 Apr 2026 04:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2A6D6B00E0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:53:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62C7C14099B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:53:38 +0000 (UTC)
X-FDA: 84678320916.26.25BC523
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id A605418000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:53:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S6asAs7O;
	spf=pass (imf16.hostedemail.com: domain of qjx1298677004@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=qjx1298677004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776675216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PjUw1MUTmp5dgmDDe13bezBVb5C7PS10Nn9b4igxUf0=;
	b=wj0GD79Gdxp4L1+yPVrFd6PK+gfAcoOgCLXdyu8GWNg9Qdk9JBpvm4jBsOuTcdPCwomWs2
	CYF5fxbp2XA/YnNFpINqGiefFDEhIkAZZbtrNKYtX950qL6A6bxEkiqp9/yFo0JPftLgKR
	XNERJZRjYa4IaMgR5NSCtDy2ACfZbCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776675216; a=rsa-sha256;
	cv=none;
	b=ZHeTcrVst0UQQOWXGpctOcWSCUO4BOvUUtIo0/H6PQ6DESdMRh00r9aP2i0iQoKuNEbcu4
	fml99B3OlWzjpMTJ1uwaaCdex+2hX8DtqPa543RuM4AnTjGZHxdwdrF/Kfz4ZVlI2UVJAz
	Zhp/LboEChmabgUVKFuxkpSkhBsTLZM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S6asAs7O;
	spf=pass (imf16.hostedemail.com: domain of qjx1298677004@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=qjx1298677004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so1570416a91.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 01:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776675215; x=1777280015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PjUw1MUTmp5dgmDDe13bezBVb5C7PS10Nn9b4igxUf0=;
        b=S6asAs7OHd+i/UGcqLjmW4bd60lfOUphjfI41fTGdmiZbGvnG79jYr17WE5k1Ks5oF
         T9YSGy//Bly07L7+9ERomEwENmMcuYc+Y6MXiSpzHc1lcGdV/iiLVc7dStyLrstPFUCh
         r0tOKLMwhJaqOyUWlH34UcCEMVGhuWwZDUATa2RdDNxeqcjqoPiLVsIeu15l922hJLdB
         wOuq+OJLJ+UlEmd7HIOEBq/Kgr+n/50nz6VPzT5NiHJ8H4avOnji6gjJGpZPyXZjJQnM
         UjPW0BgruazkTTY0h+fiY8/Z5HPafp+pRND0HEQc6j4+nxznWTCKE+uocUxloJ612xXU
         P8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776675215; x=1777280015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjUw1MUTmp5dgmDDe13bezBVb5C7PS10Nn9b4igxUf0=;
        b=f4sWGWiwEKkuU34fMM2RDMi02zqxiY+dEFqT0XmF4AP6mFIEuyc2P0Wfl40be5YhqH
         +bDrow4iFrpcg0fl+oTZKY0+7ML3aKn0lsh3NuIWmqCxkGPyGm4gc16zzWkFW/5AkIGU
         /rblRr14AUF1nzsUtFyFAc5/wFT+Xfakqh2HN3v+COtzEfCnJY9eB3hJYcQZHEowXyeI
         i/kexizAOVgXGSXrQqkD1IY78Mu+C/rpj0uK0rR2d85MwqXZBUpJzMF4OOP7ikmws+oi
         g/l/KL0jIVLOuE3inKpesd/CACZhZLiCY/zwRRuCNyfk8YP+nGMI4LDx/ChuepOCfk4b
         syig==
X-Gm-Message-State: AOJu0Yy7qs75F5tcsiFRINCwEsUdjNLazXqCUKWpypigiQVcCXGmGh4I
	W+3U57AqLcY2uZBHHtyORIj5ip0Wh+FCFKWQW/mWRqqBfJfgmK6j7jWKklO2WxO6pLw=
X-Gm-Gg: AeBDiesdZa5oNEePB4F4W6UJBZKtjqOKdh8KWyx2nxUMeSWyJR2Muqqi8jXO1gFhl2v
	0c7f85MJtilkns12RqQ5IPJJfr2dPaolNfyGPByW9+rsZwKgmJVc7LbrU6uHGYnPNb6MzDC0cOB
	IZJvJ4tJ5S9U0tb55k+Qbf3OtWvvXjv/NL0pVCTTFU8rAYinDIt/uP6Uq5XCTmQmCuGijt5RYdq
	HAA0HBH11AY/4RpRgDYo2xGxHgwnAwY0Vd8AGZ21xK9VjbOrNGH/2196ImTc7puFiiTSZtCriqK
	KGVsZeOMRu9Da1CH1M7+TfuuPB8x2eISG6Im7DAjZtj/LShFQdd6JIexLA/4iJRSc+JrsXOl6/U
	CsXsRF2r3n0AnuztiJSKCWPmOeoKZ88OWGFcYGNfpwll2u3DBfPICSPznY32bsYCWqvVUGt89Bn
	UUaPC/H9awBeAQlO92DVG7g3OjjWVpVXuUkQi2kFcpbgEAJY0oTEspQbH3DV/x
X-Received: by 2002:a17:90b:2f83:b0:35f:b313:84ca with SMTP id 98e67ed59e1d1-361404aef96mr13393211a91.27.1776675215093;
        Mon, 20 Apr 2026 01:53:35 -0700 (PDT)
Received: from localhost.localdomain ([14.218.34.206])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36141990bb6sm10104820a91.17.2026.04.20.01.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 01:53:34 -0700 (PDT)
From: Junxi Qian <qjx1298677004@gmail.com>
To: linux-mm@kvack.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/sysfs-schemes: fix use-after-free on memcg_path and goal path
Date: Mon, 20 Apr 2026 16:53:32 +0800
Message-Id: <20260420085332.178473-1-qjx1298677004@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A605418000D
X-Rspamd-Server: rspam07
X-Stat-Signature: hqgr8751z89x5tzuhkk8q51eiwnzxxxf
X-Rspam-User: 
X-HE-Tag: 1776675216-519992
X-HE-Meta: U2FsdGVkX1+ro8N7a6LvTG+bWfb+Mm1j01NVjL6FDBNMkV7KMzOh/lNdqXAQfFkbvi5u5BECJFIcYG4PwMKZGFuHkCpkCOB5Mm3eLzZ+xD87S7GDWvI1KSCafKS+DB/Ti3Ua5uGx6WmOBZMhbgflqg3hgf7DLr53V2UnQTj5tPFZBPhXAmqRG9J66tyvNylnH9lzZh+XQ1nFj1IRJEnq+ao2JFZhEOHP5bmz7gooip+mRc/3wjTZyfTPnTrF9I0fsw79onVUY3bq0BCxSmMH7MpCtYCkEf5cGmY+7ApyT9veiKF4K7OrrZoaSQAYCkcorDNdBRgkdsqOqB/kfbLtlxnu3aYipRUQSeQv1eNhHD/c/Zqlh0JsOjw2jLciesHcmkzSSQRVMF/cpYonhHpEl7IjzA612Ag3sIlflNWNl8PtT7pYL/FT4mPNv2HfDvje9hBAILjdONYGmPD2Ea79HD/OgZGGEIKqr+81YmDwY9WqcPp7jxbib3EgIFdLEluHQCaGd8WSOmFrRuzy+31mXAKJAaJwlCmawOLxExwpeldP8KiWoRav1VzVpv4/9C5cKdTF7sDURAH8vTjNq4I53ZCV77LUMMcLC7jEQJTUU2VNDLnGslqHKLvrMwDm0lsiStiSAbZRRci4MoLB0M+j3Xl8mWt1C6W6m96+mS5f6BHFtMOZ9vQSi81Qf5pIx1wCxKsOzt6kh/QcTM4AzZIL+m4Fl+wRBolDy7/KyAaNg6aqA6Nsy1m0C2P+2Oc2p1UEC6DYa9EqgSQQNLInOHLgRt6L/01DxMG0nFIGf9vJS5wPLIkE7NITkPqCrGHnhd1bShOHx6s66Y/KmgePDiWwr0/DqyBylkUfQ/53FTWO1jm2iNVvpz9YMmI9wGev5fXlrqMRRWPZhx8DoEhNgaSaTUaH5oFk8+w5dvu06AwLbF9yZdi4Bt91bgqKvdbe+TbdTe93Y2jGNMYkMct20Nm
 YM0XZdj0
 Ihl+Ubu15CTKOBE7umz+IGnW3CsxiKwvomC5hgEoQx+58DBXRHyn9Q9ECv+dcQqq4yZmY3tr963Zdp51QuegI+4MIyVRoitE57uqM+0WSGhlG9hbIFR6dnZUh1SDdarAheaOSOY811DCkOLFrVYs+c5ujf6UOnZE7S8TJ/hIjySR+RfhKGHXA16ENwbK+RRd3Pv+ij4VVBPHbDQSDvjn48qWOpHjrH2XqGmIQvr4rbzK5NPCBUMEYsO45/qch6WJLOERhwaenZTZ74P7wc7ZQKjRPKE898uKpKTpbV0a8+2sfi5ZzBRofk+qAeQ+n9L0HwbOct5xLJNQEvhC3kxMLgRR+XvDcqwa+ULOfYMXsSrWVJfKtFTteN1Ld3WJhxwHVVjc95nSSZYGKCpLkX+z3uHxDFpUtMYXx/8Bz1L5nlkyZWnYhWdRyOz1kJDZjEKSpseONWwee1SJiUxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_path_store() and path_store() free and replace their respective
string pointers without holding damon_sysfs_lock. This creates a race
with the kdamond thread, which reads these pointers in
damon_sysfs_add_scheme_filters() and damos_sysfs_add_quota_score()
via damon_call() during a "commit" operation.

The race window is as follows:
  Thread A (commit):  holds damon_sysfs_lock, triggers damon_call()
  kdamond thread:     reads sysfs_filter->memcg_path in
                      damon_sysfs_memcg_path_to_id()
  Thread B (sysfs):   calls memcg_path_store() WITHOUT lock,
                      kfree(filter->memcg_path), replaces pointer

Since Thread B does not hold damon_sysfs_lock, the kdamond thread can
observe a freed pointer, resulting in a use-after-free when
damon_sysfs_memcg_path_eq() dereferences it for string comparison.

KASAN reports the following on v7.0.0-rc5 with CONFIG_KASAN=y:

  ==================================================================
  BUG: KASAN: double-free in memcg_path_store+0x6e/0xc0

  Free of addr ffff888100a086c0 by task exp/149

  CPU: 1 UID: 0 PID: 149 Comm: exp Not tainted 7.0.0-rc5-gd38efd7c139a #18 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x55/0x70
   print_report+0xcb/0x5d0
   kasan_report_invalid_free+0x94/0xc0
   check_slab_allocation+0xde/0x110
   kfree+0x114/0x3b0
   memcg_path_store+0x6e/0xc0
   kernfs_fop_write_iter+0x2fc/0x490
   vfs_write+0x8e1/0xcc0
   ksys_write+0xee/0x1c0
   do_syscall_64+0xfc/0x580
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 147 on cpu 0 at 12.364295s:
   kasan_save_stack+0x24/0x50
   kasan_save_track+0x17/0x60
   __kasan_kmalloc+0x7f/0x90
   __kmalloc_noprof+0x191/0x490
   memcg_path_store+0x32/0xc0
   kernfs_fop_write_iter+0x2fc/0x490
   vfs_write+0x8e1/0xcc0
   ksys_write+0xee/0x1c0

  Freed by task 150 on cpu 0 at 13.373810s:
   kasan_save_stack+0x24/0x50
   kasan_save_track+0x17/0x60
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x137/0x3b0
   memcg_path_store+0x6e/0xc0
   kernfs_fop_write_iter+0x2fc/0x490
   vfs_write+0x8e1/0xcc0
   ksys_write+0xee/0x1c0

  The buggy address belongs to the object at ffff888100a086c0
   which belongs to the cache kmalloc-8 of size 8
  ==================================================================

Fix this by holding damon_sysfs_lock while swapping the path pointer
in both memcg_path_store() and path_store(). The actual kfree() is
moved outside the lock since the old pointer is no longer reachable
once replaced.

Fixes: 490a43d07f16 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
---
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <errno.h>
#include <sys/stat.h>

#define DAMON_BASE "/sys/kernel/mm/damon/admin"

static volatile int stop;
static char memcg_path_file[1024], state_file[1024];
static char real_memcg_path[512] = "/";
static int num_extra_cgroups = 200;
static char cgroup_base[256];

static int write_str(const char *path, const char *val) {
    int fd = open(path, O_WRONLY);
    if (fd < 0) return -errno;
    ssize_t r = write(fd, val, strlen(val));
    int e = errno; close(fd);
    return r > 0 ? 0 : -e;
}

static int create_extra_cgroups(void) {
    struct stat st; char path[512]; int created = 0;
    if (stat("/sys/fs/cgroup/cgroup.controllers", &st) == 0)
        strncpy(cgroup_base, "/sys/fs/cgroup", sizeof(cgroup_base));
    else if (stat("/sys/fs/cgroup/memory", &st) == 0)
        strncpy(cgroup_base, "/sys/fs/cgroup/memory", sizeof(cgroup_base));
    else return 0;
    for (int i = 0; i < num_extra_cgroups; i++) {
        snprintf(path, sizeof(path), "%s/damon_poc_%d", cgroup_base, i);
        if (mkdir(path, 0755) == 0) created++;
    }
    if (created > 0)
        snprintf(real_memcg_path, sizeof(real_memcg_path),
                 "%s/damon_poc_0", cgroup_base);
    return created;
}

static void cleanup_extra_cgroups(void) {
    char path[512];
    if (!cgroup_base[0]) return;
    for (int i = 0; i < num_extra_cgroups; i++) {
        snprintf(path, sizeof(path), "%s/damon_poc_%d", cgroup_base, i);
        rmdir(path);
    }
}

static void *path_writer(void *arg) {
    long tid = (long)arg; int i = 0; char buf[512];
    while (!stop) {
        switch (i % 4) {
        case 0: snprintf(buf,sizeof(buf),"%s",real_memcg_path); break;
        case 1: snprintf(buf,sizeof(buf),
                    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_%d_%ld",i,tid); break;
        case 2: snprintf(buf,sizeof(buf),"YYYYYYYYYYYYYY_%d",i); break;
        case 3: snprintf(buf,sizeof(buf),"Z_%d",i); break;
        }
        write_str(memcg_path_file, buf); i++;
    }
    return NULL;
}

static void *committer(void *arg) {
    while (!stop) {
        if (write_str(state_file, "commit") == 0) usleep(10);
    }
    return NULL;
}

static int setup_damon(void) {
    char path[1024]; int err;
    snprintf(path,sizeof(path),"%s/kdamonds/nr_kdamonds",DAMON_BASE);
    write_str(path,"1");
    snprintf(path,sizeof(path),
             "%s/kdamonds/0/contexts/nr_contexts",DAMON_BASE);
    write_str(path,"1");
    snprintf(path,sizeof(path),
             "%s/kdamonds/0/contexts/0/operations",DAMON_BASE);
    if (write_str(path,"paddr")) {
        write_str(path,"vaddr");
        snprintf(path,sizeof(path),
            "%s/kdamonds/0/contexts/0/targets/nr_targets",DAMON_BASE);
        write_str(path,"1");
        char pid[32]; snprintf(pid,sizeof(pid),"%d",getpid());
        snprintf(path,sizeof(path),
            "%s/kdamonds/0/contexts/0/targets/0/pid_target",DAMON_BASE);
        write_str(path,pid);
    }
    snprintf(path,sizeof(path),
        "%s/kdamonds/0/contexts/0/schemes/nr_schemes",DAMON_BASE);
    write_str(path,"1");
    snprintf(path,sizeof(path),
        "%s/kdamonds/0/contexts/0/schemes/0/action",DAMON_BASE);
    write_str(path,"stat");
    snprintf(state_file,sizeof(state_file),
             "%s/kdamonds/0/state",DAMON_BASE);
    if ((err = write_str(state_file,"on"))) return err;
    snprintf(path,sizeof(path),
        "%s/kdamonds/0/contexts/0/schemes/0/filters/nr_filters",DAMON_BASE);
    write_str(path,"1");
    snprintf(path,sizeof(path),
        "%s/kdamonds/0/contexts/0/schemes/0/filters/0/type",DAMON_BASE);
    write_str(path,"memcg");
    snprintf(memcg_path_file,sizeof(memcg_path_file),
        "%s/kdamonds/0/contexts/0/schemes/0/filters/0/memcg_path",
        DAMON_BASE);
    write_str(memcg_path_file, real_memcg_path);
    return 0;
}

int main(int argc, char *argv[]) {
    int duration = 60, n_writers = 4;
    if (argc > 1) duration = atoi(argv[1]);
    if (argc > 2) num_extra_cgroups = atoi(argv[2]);
    if (getuid()) { fprintf(stderr,"Need root\n"); return 1; }
    create_extra_cgroups();
    if (setup_damon()) { cleanup_extra_cgroups(); return 1; }
    sleep(1);
    pthread_t w[8], c;
    for (int i = 0; i < n_writers; i++)
        pthread_create(&w[i],NULL,path_writer,(void*)(long)i);
    pthread_create(&c,NULL,committer,NULL);
    sleep(duration);
    stop = 1;
    for (int i = 0; i < n_writers; i++) pthread_join(w[i],NULL);
    pthread_join(c,NULL);
    write_str(state_file,"off");
    cleanup_extra_cgroups();
    printf("Check: dmesg | grep -A20 'BUG: KASAN'\n");
}

---

 mm/damon/sysfs-schemes.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966da..005cfecb1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -543,15 +543,20 @@ static ssize_t memcg_path_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
-				   GFP_KERNEL);
+	char *path, *old;
 
+	path = kmalloc_array(size_add(count, 1), sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
-	kfree(filter->memcg_path);
+
+	mutex_lock(&damon_sysfs_lock);
+	old = filter->memcg_path;
 	filter->memcg_path = path;
+	mutex_unlock(&damon_sysfs_lock);
+
+	kfree(old);
 	return count;
 }
 
@@ -1196,15 +1201,20 @@ static ssize_t path_store(struct kobject *kobj,
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
-	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
-				   GFP_KERNEL);
+	char *path, *old;
 
+	path = kmalloc_array(size_add(count, 1), sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
-	kfree(goal->path);
+
+	mutex_lock(&damon_sysfs_lock);
+	old = goal->path;
 	goal->path = path;
+	mutex_unlock(&damon_sysfs_lock);
+
+	kfree(old);
 	return count;
 }
 
-- 
2.34.1


