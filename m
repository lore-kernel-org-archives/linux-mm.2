Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAD0CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7438E0007; Wed,  5 Nov 2025 22:30:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967608E0002; Wed,  5 Nov 2025 22:30:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82EAF8E0007; Wed,  5 Nov 2025 22:30:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 675F08E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:30:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1F4016054A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:30:56 +0000 (UTC)
X-FDA: 84078755712.29.B7AEF6D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id D529D8000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:30:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=OAlpwMea;
	spf=pass (imf30.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762399855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNM1MgLcHWEpaTBbCLnta7C99WnzqNME1CrFjvq8FrU=;
	b=21gXeq3N5b35Mx8E1JYz/fYt3qzG70upe6ax/1C7Yy/TJ98R13Du0/4PIT1z5syEWe0fGv
	22sWgBDaBHroKeLUdBKCjyQ13Xx2vsdcVZVMxuET4yrYa/603GhmmvmrKQF36BlS6quhkA
	aGM/uRetniU7lsgFRfN7xWgdfX2DrYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762399855; a=rsa-sha256;
	cv=none;
	b=8AX2++kG4PjS86sB9tDYlsjeAk8sg+6zo88BT8vdJzi2W9UeOhywLHDh06lkTdxJQYfbm8
	b3T65dSurZ8DN4owzoVwNnSbhz63wEQbr2oC6zX9f3oSOjwD41yjDVXtSaBHHTMWSHBKzN
	aS/dHjOwWx8ytogl2NdfO3TcQJupgMs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=OAlpwMea;
	spf=pass (imf30.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34003f73a05so629219a91.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 19:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762399854; x=1763004654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNM1MgLcHWEpaTBbCLnta7C99WnzqNME1CrFjvq8FrU=;
        b=OAlpwMeard/C7ik7/DCUULyQPt1izfq1ss8C6uaDQWQRuhykmVZes9iMUiF4IlfupN
         0cOw26VMIf3qTWAmstN/vTx5hsoX+VeDaub98PaL5Z4xtOpi8QJ532P9Cd6C0piKxaAy
         isZX6pIYi5o1J0hLrT901bH9eKI0JgMkJJYrE/VRGDG9DNQVFoHFP2q26l/4m6SKwBDB
         XVQxha8HEV48L2vd76JdimDrnQU54UXFS19isPvar/oTxbJ6/2YSNYcdAegr/mAV5fs8
         Vdst3XRBpbEURiy8yC/BCppQAd7zvbH3CKqCm/8fAZu8eSWLkmT2wJZjJ5tAEeIigb9F
         0ThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762399854; x=1763004654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RNM1MgLcHWEpaTBbCLnta7C99WnzqNME1CrFjvq8FrU=;
        b=M3lxDF75GNy7PdHKZXwlUBtnDlugEajENeo5yIIuU7iQvxv8kfMeu17jkW6RsvWcLI
         GsInNu+ooGFhWqWWzLu3CKUsDXNmvsQG1kvrNTZbRxY8Y0SP1LuzyU4ieKbOgyJ12u+I
         oO0i2KVH4vfNy2xvUxNDyTXX9FuyHKRjQNm6FKGTLBrPK6MBqRxKDePR0IyNBWy8W4HS
         8Eh8ggCLusku/JXYHMCIM2FacSkdh5yJHwYlEZT7s8uczlH8QODA8RiAF/g2lQXFLqid
         dy5eIhYoVFxN3Qmw/nP9UqtvRo4u9tgunOaI8d5nyemIgRHZMUA8c8yEVdJXKpR5ye1q
         nugg==
X-Forwarded-Encrypted: i=1; AJvYcCUF7D1qZA/P3+j5GYV9qN/qMrfvrSw7SedLtNyxe3SwUvxj6+eZtAif0TPOe9oPdFBi+Jc3QyAj4w==@kvack.org
X-Gm-Message-State: AOJu0YxJ7SOD/H5tY5wvVTpEme/KawlAxapuSWCjI1jxXJ9/S2Sq5EJL
	Ty0jhUoeqpcnkiJi5Qjf+b2y6Oqs15SxpGzPawLiHALUD5dgbThUMgv0ThIXIjnIp2o=
X-Gm-Gg: ASbGnct8HHndDaEjxfUci2sCUsgfXojuIY3JPr58xNAPMFK39aMABB44adpMiTlseVL
	vqdTZp6EJh1SnxPOnqFNiSwH/2GFM8Jmzp228JwdxcmY0a2t2fUD4IJiracAqpMu9WRoS/ae0wx
	ENkaRAS8xGCfB1a2tlHojmvhn+uhKw6+dkC7pwaPVrVngsRAP0VWIxe/H3AgaXLAFPohXHbHGF2
	r/Q0sxyaRc6J4hJw/2xgye7rKtI0COYohCwk/dW/zhTIuyafd+ZKXZ27KxV4wVrSBpX0OZa+xJ/
	eBmbhj0clqyYYPqVAKk5sV3pOiIrK+PWxudtxghOdOMozNKsIS9jJoc9oqP4jdoEVQQsiLcxsr0
	ib6i7emnar9HaF3Q9xcFwGs+lvpgfQnUxGz7ivfTocswa9TEsZkOxGZoTLWCwaTh0MTEcrHiTW/
	fM33G7KQ4SoSNKpg==
X-Google-Smtp-Source: AGHT+IGs3l7sTKPjK4BxzxoB8dGFRJGxiJ/b+4pm0w/YxL5LnyVyRhr4bJJbufT0LQgr9Sm10ohs0A==
X-Received: by 2002:a17:90b:3d4c:b0:341:88c5:d58 with SMTP id 98e67ed59e1d1-341cd150316mr2074007a91.13.1762399853479;
        Wed, 05 Nov 2025 19:30:53 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a69b698asm4663896a91.21.2025.11.05.19.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 19:30:52 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	inwardvessel@gmail.com,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Date: Thu,  6 Nov 2025 11:30:45 +0800
Message-ID: <20251106033045.41607-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <6kh6hle2xp75hrtikasequ7qvfyginz7pyttltx6pkli26iir5@oqjmglatjg22>
References: <6kh6hle2xp75hrtikasequ7qvfyginz7pyttltx6pkli26iir5@oqjmglatjg22>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m9oysbk7bdkgoxb15qc6uefd4wg48qro
X-Rspam-User: 
X-Rspamd-Queue-Id: D529D8000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762399854-7883
X-HE-Meta: U2FsdGVkX18UjN422DNd3I/mFXHCV3G7JmjnKkcaCfHNdwvbgG0UunwVVvBMYYQ/8Y4jehBsgbHCsK5S85CetHu1jQ1yb5FHFigUu9HYKV0+dQL2dr6IMDGDAne8F5JIJQa7LYGyeq3sLODWsuPTHWA5L6aTjfD0wEnh90XNQ9Yqizt4HbnzMZ3RxGbz4EvIhSx/kZ6KXIFrlor8hIl59BZVxQ/Npwr/t35ke083uQ+ggaUow72QWRh7Y1nYwZKBGXZdCtLE4I3eBjbGOFlQ9hj2djhuuXLNzvEHJuaJGZ3fM4OYvdqQtj/09BcnwbMgc3hAZISCbrGuttlZ9fOitxOD5WMMIIpAYPu44jfAwNeop0msx5S7JIn68DrhWVZBkKhmVhdjEe82eS/y3nLuufbQvIq7KzaDjnNTfhtAFsRh5GqPjyuCPbFJvybkuxrIyHSzS0VHsTjLKKzMFDBI67rwT4S9TRVC29YIWRxnPUCmvYR5HGmf1xuqGVv7ji2Z2CVhq/ghJ+Rw0OsBJxel9ahGZgh5/5j57sMg31U2j0I1XmRUf4Fa43KLwqnpUenJIVPDOmbr8WEp/DhEg/NYOAXEHqpFO/seo5BF8X1HE3HYlCFu6LCllr6hcn0Qt61WIFNnTw9wpzFVy4PYGRK+SnTYWFw1m3Rk45A/u/wAUXkT+nF1WjZ6o/xww5sers+gGoSlWUjbLt6Gx8r3Iwk+LB9Vu+Bdh7drPVv9SEF+H/+rtw+fB/yhZsCNF2buvKL+n5Kf89pfXOOlCjLwSuSKRJsgD9bEKqAInbhTfirHqMFeKbzBf7x1B/JYw8FfwLQ646O59TipvRCgIttAD8LSfp1O2dw+tL+sE5MvJQsPrali2Knlkx3De1QD2F5Sv9KKwDuhoQD3QoT5+uSMe/B6ZoXnkmKTeSu5rvyhG3TMxY3ENjw2E9UDdqSTN9ToXt7YCwsR2mhs568hrBydDgg
 Hq2BxKaR
 tqgYNf2nKev6uhGn14cnF2SL3pyrVfOopNYvIN9y/WDFqa4MHtTZuGPhqO0q1DBGsN2g3Nm/0Pe00ISlVTwaMC/aGk4ccAAtOwFeuwPaic8j7n81wkEG63DUIof49abnQUBb6S+6HAxSCyAPsNLHuHmrrwzZWY+Xm/5E9js5ubooR069F3ynAEGFMXIhPVEOq/mIz5q7q17WN+0PoV6vr4qdgwfINK+bYEI69bO0I0BgftROjckvy8NSsa6wkhfzQhSwESR1FMyEpWbo6/te6rxYIh8q2ITHdmxCdriULwkku+qR66tgYnse4aM4ITt8k+ysF4KmwbG+mVxueQJl2UWNI93FjzhU+2dp6T9ZxGRQEQAHvqXr3BxswET77bicHoPja8rQs1ens8QFv80L/RFdC0RY9gAvOMwaqGpmu7ywMl7hX86SFMeAiOd1+a7dj6iKmeq5WPgZN/l1+H7QIzDRT3oRLEzarf/h/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 9:19 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>
> +Yosry, JP
>
> On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
> > On high-core count systems, memory cgroup statistics can become stale
> > due to per-CPU caching and deferred aggregation. Monitoring tools and
> > management applications sometimes need guaranteed up-to-date statistics
> > at specific points in time to make accurate decisions.
>
> Can you explain a bit more on your environment where you are seeing
> stale stats? More specifically, how often the management applications
> are reading the memcg stats and if these applications are reading memcg
> stats for each nodes of the cgroup tree.
>
> We force flush all the memcg stats at root level every 2 seconds but it
> seems like that is not enough for your case. I am fine with an explicit
> way for users to flush the memcg stats. In that way only users who want
> to has to pay for the flush cost.
>

Thanks for the feedback. I encountered this issue while running the LTP
memcontrol02 test case [1] on a 256-core server with the 6.6.y kernel on XFS,
where it consistently failed.

I was aware that Yosry had improved the memory statistics refresh mechanism
in "mm: memcg: subtree stats flushing and thresholds" [2], so I attempted to
backport that patchset to 6.6.y [3]. However, even on the 6.15.0-061500-generic
kernel with those improvements, the test still fails intermittently on XFS.

I've created a simplified reproducer that mirrors the LTP test behavior. The
test allocates 50 MiB of page cache and then verifies that memory.current and
memory.stat's "file" field are approximately equal (within 5% tolerance).

The failure pattern looks like:

  After alloc: memory.current=52690944, memory.stat.file=48496640, size=52428800
  Checks: current>=size=OK, file>0=OK, current~=file(5%)=FAIL

Here's the reproducer code and test script (attached below for reference).

To reproduce on XFS:
  sudo ./run.sh --xfs
  for i in {1..100}; do sudo ./run.sh --run; echo "==="; sleep 0.1; done
  sudo ./run.sh --cleanup

The test fails sporadically, typically a few times out of 100 runs, confirming
that the improved flush isn't sufficient for this workload pattern.

I agree that providing an explicit flush mechanism allows users who need
guaranteed accuracy to pay the cost only when necessary, rather than imposing
more aggressive global flushing on all users.

Thanks,
Leon

---

Links:
[1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/memcontrol02.c
[2] https://lore.kernel.org/all/20231129032154.3710765-1-yosryahmed@google.com/
[3] https://lore.kernel.org/linux-mm/20251103075135.20254-1-leon.huangfu@shopee.com/

---

Reproducer code (pagecache_50m_demo.c):

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static int write_str(const char *path, const char *s) {
    int fd = open(path, O_WRONLY | O_CLOEXEC);
    if (fd < 0) { perror(path); return -1; }
    ssize_t w = write(fd, s, strlen(s));
    if (w != (ssize_t)strlen(s)) { perror("write"); close(fd); return -1; }
    close(fd);
    return 0;
}

static long read_long_file(const char *path) {
    FILE *f = fopen(path, "re");
    if (!f) { perror(path); return -1; }
    long v = -1;
    if (fscanf(f, "%ld", &v) != 1) v = -1;
    fclose(f);
    return v;
}

static long read_stat_field_bytes(const char *path, const char *key) {
    FILE *f = fopen(path, "re");
    if (!f) { perror(path); return -1; }
    char *line = NULL; size_t n = 0; long val = -1;
    while (getline(&line, &n, f) > 0) {
        if (strncmp(line, key, strlen(key)) == 0) {
            char *p = line + strlen(key);
            while (*p == ' ' || *p == '\t') p++;
            val = strtoll(p, NULL, 10);
            break;
        }
    }
    free(line);
    fclose(f);
    return val;
}

static int make_memcg_child(char *cg, size_t cg_sz) {
    const char *root = "/sys/fs/cgroup";
    int n = snprintf(cg, cg_sz, "%s/memcg_demo_%d", root, getpid());
    if (n < 0 || n >= (int)cg_sz) {
        fprintf(stderr, "cg path too long\n"); return -1;
    }
    if (mkdir(cg, 0755) && errno != EEXIST) { perror("mkdir cg"); return -1; }

    // best-effort enable memory controller on parent
    char parent[PATH_MAX];
    strncpy(parent, cg, sizeof(parent));
    parent[sizeof(parent)-1] = '\0';
    char *s = strrchr(parent, '/');
    if (s && s != parent) {
        *s = '\0';
        char stc[PATH_MAX];
        n = snprintf(stc, sizeof(stc), "%s/cgroup.subtree_control", parent);
        if (n >= 0 && n < (int)sizeof(stc)) (void)write_str(stc, "+memory");
    }

    char procs[PATH_MAX];
    n = snprintf(procs, sizeof(procs), "%s/cgroup.procs", cg);
    if (n < 0 || n >= (int)sizeof(procs)) { fprintf(stderr, "path too long\n"); return -1; }
    char pidbuf[32]; snprintf(pidbuf, sizeof(pidbuf), "%d", getpid());
    if (write_str(procs, pidbuf) < 0) return -1;
    return 0;
}

/* Exact mirror of LTP alloc_pagecache() behavior */
static inline void alloc_pagecache_exact(const int fd, size_t size)
{
    char buf[BUFSIZ];
    size_t i;

    if (lseek(fd, 0, SEEK_END) == (off_t)-1) {
        perror("lseek"); exit(1);
    }
    for (i = 0; i < size; i += sizeof(buf)) {
        ssize_t w = write(fd, buf, sizeof(buf));
        if (w < 0) { perror("write"); exit(1); }
        if ((size_t)w != sizeof(buf)) { fprintf(stderr, "short write\n"); exit(1); }
    }
}

static bool approx_equal(long a, long b, double tol_frac) {
    long diff = labs(a - b);
    long lim = (long)((double)b * tol_frac);
    return diff <= lim;
}

int main(int argc, char **argv) {
    const char *mnt = (argc >= 2) ? argv[1] : ".";
    char cg[PATH_MAX];
    if (make_memcg_child(cg, sizeof(cg)) < 0) {
        fprintf(stderr, "Failed to setup memcg (need root? cgroup v2?)\n");
        return 1;
    }
    printf("Created cg %s\n", cg);

    char p_current[PATH_MAX], p_stat[PATH_MAX];
    int n = snprintf(p_current, sizeof(p_current), "%s/memory.current", cg);
    if (n < 0 || n >= (int)sizeof(p_current)) { fprintf(stderr, "path too long\n"); return 1; }
    n = snprintf(p_stat, sizeof(p_stat), "%s/memory.stat", cg);
    if (n < 0 || n >= (int)sizeof(p_stat)) { fprintf(stderr, "path too long\n"); return 1; }

    char filepath[PATH_MAX];
    n = snprintf(filepath, sizeof(filepath), "%s/tmpfile", mnt);
    if (n < 0 || n >= (int)sizeof(filepath)) { fprintf(stderr, "file path too long\n"); return 1; }

    int fd = open(filepath, O_RDWR | O_CREAT | O_TRUNC, 0600);
    if (fd < 0) { perror("open tmpfile"); return 1; }

    long current = read_long_file(p_current);
    printf("Created temp file: memory.current=%ld\n", current);

    const size_t size = 50UL * 1024 * 1024; // 50 MiB
    alloc_pagecache_exact(fd, size);

    // No fsyncs; small wait to reduce XFS timing flakiness
    //fsync(fd);
    //usleep(2200000);

    current = read_long_file(p_current);
    long file_bytes = read_stat_field_bytes(p_stat, "file");
    printf("After alloc: memory.current=%ld, memory.stat.file=%ld, size=%zu\n",
           current, file_bytes, size);

    bool ge_size = (current >= (long)size);
    bool file_pos = (file_bytes > 0);

    // Approximate LTP's values_close(..., file_to_all_error) with 5% tolerance
    double tol = 0.05;
    bool approx = approx_equal(current, file_bytes, tol);

    printf("Checks: current>=size=%s, file>0=%s, current~=file(%.0f%%)=%s\n",
           ge_size ? "OK" : "FAIL",
           file_pos ? "OK" : "FAIL",
           tol * 100,
           approx ? "OK" : "FAIL");

    close(fd);
    return (ge_size && file_pos && approx) ? 0 : 2;
}

Build: gcc -O2 -Wall pagecache_50m_demo.c -o pagecache_50m_demo

Test runner (run.sh):

#!/usr/bin/env bash
set -euo pipefail

# Config (overridable via env)
SIZE_MB="${SIZE_MB:-500}"
IMG="${IMG:-/var/tmp/pagecache_demo.img}"
MNT="${MNT:-/mnt/pagecache_demo}"
DEMO_BIN="${DEMO_BIN:-./pagecache_50m_demo}"
STATE="${STATE:-/var/tmp/pagecache_demo.state}" # stores LOOP + FS type

usage() {
  echo "Usage:"
  echo "  sudo $0 --ext4         Prepare ext4 loopback FS and mount it at \$MNT"
  echo "  sudo $0 --xfs          Prepare xfs  loopback FS and mount it at \$MNT"
  echo "  sudo $0 --btrfs        Prepare btrfs loopback FS and mount it at \$MNT"
  echo "  sudo $0 --tmpfs        Prepare tmpfs mount at \$MNT (no image/loop)"
  echo "  sudo $0 --run          Run demo on mounted \$MNT"
  echo "  sudo $0 --cleanup      Unmount and remove loop/image/state"
  echo
  echo "Env overrides:"
  echo "  SIZE_MB (default 256), IMG, MNT, DEMO_BIN, STATE"
}

need_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    echo "Please run as root (sudo)"
    exit 1
  fi
}

have_cmd() { command -v "$1" > /dev/null 2>&1; }

save_state() {
  local loop="${1:-}" fstype="$2"
  printf 'LOOP=%q\nFSTYPE=%q\nIMG=%q\nMNT=%q\n' "$loop" "$fstype" "$IMG" "$MNT" > "$STATE"
}

load_state() {
  if [[ ! -f "$STATE" ]]; then
    echo "State not found: $STATE. Run --ext4/--xfs/--btrfs/--tmpfs first."
    exit 1
  fi
  # shellcheck disable=SC1090
  . "$STATE"
  : "${FSTYPE:?}" "${IMG:?}" "${MNT:?}"
  # LOOP may be empty for tmpfs
}

cleanup_mount() {
  set +e
  if mountpoint -q "$MNT"; then
    umount "$MNT" || umount -l "$MNT"
  fi
  if [[ -n "${LOOP:-}" ]] && [[ -b "${LOOP:-}" ]]; then
    losetup -d "$LOOP" 2> /dev/null || true
  else
    # Detach any loop using IMG as fallback
    if [[ -f "$IMG" ]]; then
      if losetup -j "$IMG" | grep -q .; then
        losetup -j "$IMG" | awk -F: '{print $1}' | xargs -r -n1 losetup -d
      fi
    fi
  fi
  rmdir "$MNT" 2> /dev/null || true
  set -e
}

cleanup_all() {
  echo "[*] Cleaning up..."
  if [[ -f "$STATE" ]]; then
    load_state || true
  fi
  cleanup_mount
  # For tmpfs there is no image; for others remove image
  if [[ "${FSTYPE:-}" != "tmpfs" ]]; then
    rm -f "$IMG"
  fi
  rm -f "$STATE"
  rmdir /sys/fs/cgroup/memcg_demo_* || true
  echo "[*] Done."
}

make_image() {
  echo "[*] Creating sparse image: $IMG (${SIZE_MB} MiB)"
  dd if=/dev/zero of="$IMG" bs=1M count=0 seek="$SIZE_MB" status=none
}

attach_loop() {
  # stdout returns loop device path only
  losetup -fP --show "$IMG"
}

ensure_loop_ready() {
  local dev="$1"
  if [[ -z "$dev" ]]; then
    echo "Failed to get loop device for $IMG"
    exit 1
  fi
  # udev settle
  for _ in {1..10}; do
    [[ -b "$dev" ]] && return 0
    sleep 0.1
  done
  echo "Loop device is not a block device: $dev"
  exit 1
}

mkfs_ext4() {
  have_cmd mkfs.ext4 || {
    echo "mkfs.ext4 not found"
    exit 1
  }
  echo "[*] Making ext4 on $1"
  mkfs.ext4 -F -q "$1"
}

mkfs_xfs() {
  have_cmd mkfs.xfs || {
    echo "mkfs.xfs not found (install xfsprogs)"
    exit 1
  }
  echo "[*] Making xfs on $1"
  mkfs.xfs -f -q "$1"
}

mkfs_btrfs() {
  have_cmd mkfs.btrfs || {
    echo "mkfs.btrfs not found (install btrfs-progs)"
    exit 1
  }
  echo "[*] Making btrfs on $1"
  mkfs.btrfs -f -q "$1"
}

mount_fs_dev() {
  mkdir -p "$MNT"
  echo "[*] Mounting $1 at $MNT"
  mount "$1" "$MNT"
  df -h "$MNT" || true
}

prepare_fs_loop() {
  need_root
  local fstype="$1" # ext4 | xfs | btrfs

  rm -f "$STATE"
  if mountpoint -q "$MNT" || losetup -j "$IMG" | grep -q . || [[ -f "$IMG" ]]; then
    echo "[*] Previous environment detected, cleaning first..."
    cleanup_all
  fi

  make_image
  local loop
  loop="$(attach_loop)"
  ensure_loop_ready "$loop"

  case "$fstype" in
    ext4) mkfs_ext4 "$loop" ;;
    xfs) mkfs_xfs "$loop" ;;
    btrfs) mkfs_btrfs "$loop" ;;
    *)
      echo "Unknown fs: $fstype"
      exit 1
      ;;
  esac

  mount_fs_dev "$loop"
  save_state "$loop" "$fstype"
  echo "[*] Prepared $fstype at $MNT (loop=$loop)"
}

prepare_tmpfs() {
  need_root
  rm -f "$STATE"
  if mountpoint -q "$MNT"; then
    echo "[*] Unmounting previous $MNT..."
    umount "$MNT" || umount -l "$MNT"
  fi
  mkdir -p "$MNT"
  echo "[*] Mounting tmpfs at $MNT (size=${SIZE_MB}m)"
  mount -t tmpfs -o "size=${SIZE_MB}m" tmpfs "$MNT"
  df -h "$MNT" || true
  save_state "" "tmpfs"
  echo "[*] Prepared tmpfs at $MNT"
}

run_demo() {
  need_root
  load_state
  if ! mountpoint -q "$MNT"; then
    echo "Mount point not mounted: $MNT. Did you run --$FSTYPE first?"
    exit 1
  fi
  if [[ ! -x "$DEMO_BIN" ]]; then
    echo "Demo binary not found or not executable: $DEMO_BIN"
    exit 1
  fi
  echo "[*] Running demo on $MNT: $DEMO_BIN $MNT"
  "$DEMO_BIN" "$MNT"
}

case "${1:-}" in
  --ext4) prepare_fs_loop ext4 ;;
  --xfs) prepare_fs_loop xfs ;;
  --btrfs) prepare_fs_loop btrfs ;;
  --tmpfs) prepare_tmpfs ;;
  --run) run_demo ;;
  --cleanup) cleanup_all ;;
  *)
    usage
    exit 1
    ;;
esac

