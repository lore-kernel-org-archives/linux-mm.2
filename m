Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A02BC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 04:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294DC6B0093; Sat, 26 Sep 2026 00:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246EC6B0095; Sat, 26 Sep 2026 00:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6DF6B0096; Sat, 26 Sep 2026 00:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE69C6B0093
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:55:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A59B16084B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:55:55 +0000 (UTC)
X-FDA: 85254701070.04.F1EB0B9
Received: from mail-dl2-f42.google.com (mail-dl2-f42.google.com [74.125.229.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7659B1C0004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:55:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WG5SUsNa;
	spf=pass (imf18.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.170 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790398553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUecpfSBrOk+7mAldclmse685XDqEY+Uz7+ijcEhEUA=;
	b=pJcIT5uBeN4WNvbwVXtbQO++h18uaJGW+iSS9Vs0196Oi6QfoScxM33Cc22OF9r7L3PC64
	t7z3LkNUAGegGKbM7/9jrzLNskISPy2qUO9ng/q1eS2MHvwmxinAFYX+K6q7FD67uc35pl
	E+H9jwXKONszDwJWleAMJmeufS7bzis=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WG5SUsNa;
	spf=pass (imf18.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.170 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790398553;
	b=0mT2kuWGIBMyU7M6JMBOkX9Nh0NSWx2xCoDbU3CgPP85vIdCkgHcENLvmKYk+OzitFByAm
	DCw/KWcHrQbesUdfG4VOkVUAdbWKPeFcA/ebc1e8FUlL8gVJahXZVNY73kLeZBa+MP9+xr
	ZbdmHw3zxflNHgt+mLjGJktJ4s90Irs=
Received: by mail-dl2-f42.google.com with SMTP id a92af1059eb24-144e32aaa1cso847977c88.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790398552; x=1791003352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XUecpfSBrOk+7mAldclmse685XDqEY+Uz7+ijcEhEUA=;
        b=WG5SUsNam+j+iIhAarrBtL/wrDU1hrKMrKUx88nRrB8/mUFwrl7Zmy0P35s2eOa5q2
         y/dVG/fifx0qamyxf1JYjOt/vpP5+xnETs9uqP1NyQaMhwPohdN4fu3ej0yDJTr3vKSt
         GK99fBONbqqZRf+/D2A9FOvS4euVsEVVjkgs+tZTO+Eof3JeklQP9ATu+xzPoF3ZmEWs
         YXRrCCXMQAlmVRsnZVCaHq9k3gJCWLOx+8m02uCd90tOWxrqaGlkOA2bOIP8bkkdOP2v
         qacxWC2nwGAOd+XrZBWts0XRuZ6iJJMA3+WQBzMCrzUc9uz+7UaoLAdqteuJ3xkCoe0A
         DWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790398552; x=1791003352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XUecpfSBrOk+7mAldclmse685XDqEY+Uz7+ijcEhEUA=;
        b=Xee/7DCs6ZSkZYozI/xEyppGZRiuXv1KQZixhD8jhKzpaZGrFtxcw34XnoF1/zZjIP
         3GB2hEVmwWyRZVb/Y5YnVVvKjrAkTsbSQs1xSLIvRqimK8zgSuC0LbQmUFUoFqkGhrlC
         tCriZaBmQsSGBZv6e203IfJ+yh4pcjmQ5W9DVZ36xHFIuvOWvKSfcBKrGkPJhT/4IYGi
         4ONS79nzGmJERG8Gq8hXUJh7SsjxZHHSLd4IbxnfKviukzoL+yCdaObJ7LU5djbFOeOI
         oa56Cay9i4SbAzWKyUDNn2TQO2yp39WsAOMq5ISYojnhGtkvaDgWtXYI6DmIww2XJUNw
         Mfdg==
X-Forwarded-Encrypted: i=1; AKwUvBzNHS0CwLwbXnrqbKD86Ygn7WbKJVFyABEDAfWIH5NDm2s9MPrJzPUHQlnVMgqlihVq7J82cMMN2A==@kvack.org
X-Gm-Message-State: AFuF++ne/Rd2qNNv+x6/O8eBNxmR1D/GXVxRK4IQ60DjiYDkJtOvFR1w
	D4Xiy2V2ARqwlF3MRuyeA+ixUYuvAt3eWnfzI8sz5HLuk57vEn2DhyEM
X-Gm-Gg: AYBFou0XqVOtKgQtJTo8IgGpxJk+OzxQluOBlFQfGEJ7K/DzruUhupkTxkVPJZ7NOBQ
	cDj6dkoJFuUka/Ig6utw3cBsFhdT4iHHr/NofMLQhQBJkbHBoNewZMTh2oFc3T/jPJDpxtyD7SC
	nWLZVu0pSVirvaJYZ2YYJhhrcCCgFSTrdkiTwyrOhWBL1Fuj/bdK3keUBFXWZSXe6tjX1ndO3Dj
	l9IbeIsedV9G8R+4Pyr8w2xmVU953V4witpgjdMqx6Q2HEE9nLnW/iN0RBmorhne98jyLa5fdnE
	hztXVaTE4gSvdlsD3riWS7qHzBCLRZPYe9J71UeQAejXEE/VS0LMqm3vFecqpIL9m3bzU8ogcaA
	N9+QO5fXrg48GIt2xhPPGEAo5EP30W5lXL2DP1hTvHfTFuppiFfriT0PO/o8AoOS/tpKECA9lao
	y2RZzgneRaaAKeM391py6+drLi573EIkJIsY0FaOj2KuW2TAyE7M9Nu/gX3uHwleQmIq9uHf/wx
	BYOCZxna+DPox4rhVxWCTAVdL1xkaTCAgRn6F/6t1keTkwO3M/1srTCis0LLzj3SOZ0zmqbpWxH
	EQy1KA9imKxTa8gfo/bPJEiD2hINBkTtOjexuvkXhjibaXzx8Q/VSXEcPWm1rIKfQ4UxiVU=
X-Received: by 2002:a05:7022:28c:b0:139:bf81:637f with SMTP id a92af1059eb24-146ce775f18mr2027803c88.16.1790398551939;
        Fri, 25 Sep 2026 21:55:51 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145adcc5b00sm9334211c88.15.2026.09.25.21.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 21:55:51 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH v2 4/4] selftests: zram: cover retained offload-only entries
Date: Sat, 26 Sep 2026 12:55:17 +0800
Message-ID: <20260926045517.3458413-5-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7659B1C0004
X-Stat-Signature: b8xknm5skj8gchq6ci6fa67fghnr3k98
X-Rspam-User: 
X-HE-Tag: 1790398553-149310
X-HE-Meta: U2FsdGVkX19621oaJjCgXBPvQbVuP3LrZR6bf9Y4kFEA23urYiG5lApZ1pnSVdI5crsh1tw/wCdQ+B6JE3da/qvkxWhkSOLkW4l2NazP8coxUiIlVRMDJ3hNw7zAcgNag7gUrzgqwZZy76dm1dtq/5cdUiZY+RV/FlGV9p1dh3wK0+tavAlwmTmZHsmManmlQU7M79UcxxDQ0yptoDuPA/83I4DCi20oD3ho9hlE4Kbt+ASg60u+cxjKGYSrG+T0cYwJCgU1G26pQLG/Rmfz2XohroTItpEG28ZBDdj2Ri50mgTfiaRanMV8rf6buAiv7t2a2vJv8LInMJojxunUUG1l8fMuRlkM4437XRRUAmDV2JHcbgKphByK23oKvdK+ITvw70nRRZhp6SEjnTFGIrM2DjiKHSfKWs8tdi+Yhy90M5utylNXKNANXTMf6jR8pc/Yz52tdSf0Mb3WBWePEOJ2hVt7pF9n2GABHF6502wmgSTKKtugHuoHu4yRaaIPZUeD68i6DljKroTbvKy5OvFKzwD4gjv88rGhZk/spmpQxcnSL7iNI5gQrW8uoISHz/AMlCGNxF6BQW/jgyshizXDkjfeLC/dPo37ikm2y1THT3H+1sz0uDoZ9ZX/f0af3kr8ojJGqVOl4g/V8s80uzK6OVcVJAXPT+PCQJu7EgWzkv5XpKEUdEXsQ5lziFBNFj9cjDXbI+HJ1USU5/n7IRI8rJVnlJgg1tFUYitozV8EKZkv6xbQZ2PmV47YN1yb+JiQfqrfmlWOLFrS1Gv+pnCiYwc4dQ/JEuoUrpiol7lvmTc6oB2mcUgVNxVj21a8yFOF1YAbFL7e7hDN4dXmFY9Y/Day1EMlEGwAVH/Azxx5Sh3+q5BNFzi30pqCkp45Dh7ke4jx8rxQYLz9m5MDBiDcHQDLoMbGYGRppSZ95jo8HsQEXjsDsa3UTC2mZP5JAn0ubvLFEmU3fY20IT5
 6/IaM214
 YrYOdvMggzW2cjYjgFIjX11M5LP/Jfv2c/lGqsZ0RWQ6c5dl2TtLMxkUJRMzWnr06ubvnGHdr2YoRPa9d5cDLSo4U2qZIbTwQElJ+TGLtYoxnqK1RFHIR88TJeb2lZ1agt7R3hzRKldK+PDXZQIxH2LCQ2exVgzSwJUz/Mh6MoS1KcKsc8PvJGHkvyqRXcGYaofBT+a4VSIlm1dlM2hB1EqmVhxKqGkJaZqU2jlOHc+CmMMcmbu/5H7AjUfdKlZaFSriD1jSiSzU5Duw6QglzZaDFJu70i4R9ynAkdxZmWTUS5FF5elT/vEFSvxJIXKp+OCRTMr/Mt5UpfpB6Vgys6Na/HjsrIuI+IPFBj11m/kn2fVh7OD/524oJTzbZ2dPnY7pDaalr/GiuzAtnxD3kDuwvHvBQY+PGnXhthYvpgK8HkfCtOeNKOL95XgW8rRnVZ0Egw6u8qX5Lmfic3HmCQ1bqogp91j5CJ9JHoBceKq0vSvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Faulting and dirtying one page of a swapped-out large folio can leave
sibling PTEs referring to its existing offload-only swap allocation.
Exercise this path with zram behind dm-delay: ordinary reclaim must not
rewrite the allocation, while proactive reclaim must still be able to.

Check backing-device writes, refusal counters and data integrity. Derive
the folio and expected I/O sizes from the architecture's PMD huge-page
size. Keep this test separate from basic routing coverage because it
also requires transparent huge pages, MADV_COLLAPSE and dm-delay.

Measure retained swap in the target VMA and lock ancillary mappings to
keep them out of backing-device write counts.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 tools/testing/selftests/zram/Makefile       |   2 +-
 tools/testing/selftests/zram/README         |   8 +-
 tools/testing/selftests/zram/config         |   4 +
 tools/testing/selftests/zram/settings       |   1 +
 tools/testing/selftests/zram/swap_offload.c | 205 ++++++++-
 tools/testing/selftests/zram/zram05.sh      | 447 ++++++++++++++++++++
 6 files changed, 664 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/zram/settings
 create mode 100755 tools/testing/selftests/zram/zram05.sh

diff --git a/tools/testing/selftests/zram/Makefile b/tools/testing/selftests/zram/Makefile
index 781d10a20e56..b83e6a1563b2 100644
--- a/tools/testing/selftests/zram/Makefile
+++ b/tools/testing/selftests/zram/Makefile
@@ -2,7 +2,7 @@
 all:
 
 TEST_GEN_FILES := swap_offload workingset_offload
-TEST_PROGS := zram.sh zram03.sh zram04.sh
+TEST_PROGS := zram.sh zram03.sh zram04.sh zram05.sh
 TEST_FILES := zram01.sh zram02.sh zram_lib.sh
 EXTRA_CLEAN := err.log
 
diff --git a/tools/testing/selftests/zram/README b/tools/testing/selftests/zram/README
index cd7f389ed3c6..8c11d70d2a1f 100644
--- a/tools/testing/selftests/zram/README
+++ b/tools/testing/selftests/zram/README
@@ -28,6 +28,7 @@ zram02.sh: creates block device for swap
 Offload-only swap tests, registered separately:
 zram03.sh: checks proactive routing, pressure fallback and zswap bypass
 zram04.sh: checks file workingset activation with offload-only swap
+zram05.sh: checks retained-entry write refusal, recovery and data integrity
 
 Run these tests as root in an exclusive disposable VM with the offload-only
 swap policy and the options listed in config. They change global swap,
@@ -35,7 +36,9 @@ zswap and reclaim settings. Use the initial cgroup namespace with an
 unrestricted cgroup v2 memory hierarchy mounted at /sys/fs/cgroup. A child's
 memory.zswap.writeback value does not reveal restrictions in its ancestors.
 
-zram04 needs a disk-backed TMPDIR.
+zram04 needs a disk-backed TMPDIR. zram05 additionally needs dm-delay,
+transparent huge pages and enough locked-memory allowance for its fixture;
+it skips when those prerequisites cannot be established.
 
 Commands required for testing:
  - bc
@@ -46,6 +49,9 @@ Commands required for testing:
  - swapon
  - swapoff
  - mkfs/ mkfs.ext4
+ - dmsetup (zram05)
+ - blockdev (zram05)
+ - stat (zram04 and zram05)
 
 For more information please refer:
 kernel-source-tree/Documentation/admin-guide/blockdev/zram.rst
diff --git a/tools/testing/selftests/zram/config b/tools/testing/selftests/zram/config
index c59b8c3806a5..018429d8f5ca 100644
--- a/tools/testing/selftests/zram/config
+++ b/tools/testing/selftests/zram/config
@@ -1,6 +1,10 @@
 CONFIG_CGROUPS=y
+CONFIG_BLK_DEV_DM=y
+CONFIG_DM_DELAY=y
 CONFIG_MEMCG=y
 CONFIG_SWAP=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
+CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_ZSMALLOC=y
 CONFIG_ZRAM=y
 CONFIG_ZSWAP=y
diff --git a/tools/testing/selftests/zram/settings b/tools/testing/selftests/zram/settings
new file mode 100644
index 000000000000..6091b45d226b
--- /dev/null
+++ b/tools/testing/selftests/zram/settings
@@ -0,0 +1 @@
+timeout=120
diff --git a/tools/testing/selftests/zram/swap_offload.c b/tools/testing/selftests/zram/swap_offload.c
index b2b94cd6ee3a..0c01c97d8476 100644
--- a/tools/testing/selftests/zram/swap_offload.c
+++ b/tools/testing/selftests/zram/swap_offload.c
@@ -3,6 +3,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <limits.h>
 #include <sched.h>
 #include <signal.h>
 #include <stdio.h>
@@ -17,6 +18,7 @@
 #define SWAP_FLAG_DISCARD_ONCE	0x20000
 #define SWAP_FLAG_DISCARD_PAGES	0x40000
 #define SWAP_FLAG_OFFLOAD_ONLY	0x80000
+#define KSFT_SKIP	4
 
 static int activate(const char *path, int priority, int discard_flags)
 {
@@ -201,11 +203,210 @@ static int allocate(const char *size_arg, const char *procs,
 		pause();
 }
 
+static int create_marker(const char *path, unsigned char *memory,
+			 unsigned long size)
+{
+	char *temporary;
+	int fd, ret = 1;
+
+	if (asprintf(&temporary, "%s.XXXXXX", path) < 0) {
+		perror("asprintf marker path");
+		return 1;
+	}
+	fd = mkstemp(temporary);
+	if (fd < 0) {
+		perror(path);
+		goto out_free;
+	}
+	if (memory && dprintf(fd, "%d %08lx-%08lx\n", getpid(),
+			      (unsigned long)memory,
+			      (unsigned long)(memory + size)) < 0) {
+		perror("write marker");
+		close(fd);
+		goto out_unlink;
+	}
+	if (close(fd)) {
+		perror("close marker");
+		goto out_unlink;
+	}
+	/* Publish only after the payload is complete for the shell reader. */
+	if (rename(temporary, path)) {
+		perror("publish marker");
+		goto out_unlink;
+	}
+	ret = 0;
+out_unlink:
+	unlink(temporary);
+out_free:
+	free(temporary);
+	return ret;
+}
+
+static unsigned char retained_byte(unsigned long offset, long page_size,
+				   int touched)
+{
+	unsigned char value = offset / page_size % 251 + 1;
+
+	if (touched && !offset)
+		value ^= 0x5a;
+	return value;
+}
+
+static int verify_retained(unsigned char *memory, unsigned long size,
+			   long page_size, int full)
+{
+	unsigned long limit = full ? size : 1;
+
+	for (unsigned long offset = 0; offset < limit; offset++) {
+		unsigned char expected = retained_byte(offset, page_size, 1);
+
+		if (memory[offset] != expected) {
+			fprintf(stderr,
+				"retained data mismatch at %lu: got %u, expected %u\n",
+				offset, memory[offset], expected);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int retained(const char *size_arg, const char *procs,
+		    const char *ready, const char *touched,
+		    const char *verified)
+{
+	unsigned long allocation_size, mapping_start, size;
+	unsigned char *mapping, *memory;
+	char *end;
+	sigset_t signals;
+	long page_size;
+	int signal;
+
+	errno = 0;
+	size = strtoul(size_arg, &end, 0);
+	if (errno || *end || !size || (size & (size - 1))) {
+		fprintf(stderr, "allocation size must be a power of two\n");
+		return 1;
+	}
+	/*
+	 * Keep existing runtime mappings out of the backing-write measurement.
+	 * Enable future locking only after creating the unlocked target mapping.
+	 */
+	if (mlockall(MCL_CURRENT)) {
+		int error = errno;
+
+		perror("mlockall ancillary mappings");
+		if (error == EPERM || error == ENOMEM)
+			return KSFT_SKIP;
+		return 1;
+	}
+	if (join_cgroup(procs))
+		return 1;
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size <= 0) {
+		perror("sysconf _SC_PAGESIZE");
+		return 1;
+	}
+	if (size < (unsigned long)page_size || size % page_size) {
+		fprintf(stderr, "allocation size must contain whole pages\n");
+		return 1;
+	}
+	if (size > ULONG_MAX / 2) {
+		fprintf(stderr, "allocation size is too large\n");
+		return 1;
+	}
+	allocation_size = size * 2;
+	mapping = mmap(NULL, allocation_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mapping == MAP_FAILED) {
+		int error = errno;
+
+		perror("mmap");
+		if (error == EAGAIN || error == ENOMEM)
+			return KSFT_SKIP;
+		return 1;
+	}
+	mapping_start = (unsigned long)mapping;
+	memory = (unsigned char *)((mapping_start + size - 1) & ~(size - 1));
+	if ((unsigned long)memory != mapping_start)
+		munmap((void *)mapping_start,
+		       (unsigned long)memory - mapping_start);
+	munmap(memory + size, allocation_size - size -
+	       ((unsigned long)memory - mapping_start));
+	if (mlockall(MCL_FUTURE)) {
+		perror("mlockall future mappings");
+		return 1;
+	}
+	if (madvise(memory, size, MADV_HUGEPAGE)) {
+		perror("madvise MADV_HUGEPAGE");
+		return 1;
+	}
+	for (unsigned long offset = 0; offset < size; offset += page_size)
+		memset(memory + offset, retained_byte(offset, page_size, 0),
+		       page_size);
+#ifdef MADV_COLLAPSE
+	if (madvise(memory, size, MADV_COLLAPSE)) {
+		int error = errno;
+
+		perror("madvise MADV_COLLAPSE");
+		if (error == EAGAIN || error == EINVAL || error == ENOMEM)
+			return KSFT_SKIP;
+		return 1;
+	}
+#else
+	fprintf(stderr, "MADV_COLLAPSE is unavailable\n");
+	return KSFT_SKIP;
+#endif
+
+	sigemptyset(&signals);
+	sigaddset(&signals, SIGUSR1);
+	sigaddset(&signals, SIGUSR2);
+	sigaddset(&signals, SIGALRM);
+	if (sigprocmask(SIG_BLOCK, &signals, NULL)) {
+		perror("sigprocmask");
+		return 1;
+	}
+	if (create_marker(ready, memory, size))
+		return 1;
+
+	for (;;) {
+		errno = sigwait(&signals, &signal);
+		if (errno) {
+			perror("sigwait");
+			return 1;
+		}
+		if (signal == SIGUSR1) {
+			unsigned char value;
+
+			if (mprotect(memory, page_size, PROT_READ)) {
+				perror("mprotect read");
+				return 1;
+			}
+			value = memory[0];
+			if (mprotect(memory, page_size, PROT_READ | PROT_WRITE)) {
+				perror("mprotect write");
+				return 1;
+			}
+			memory[0] = value ^ 0x5a;
+			if (create_marker(touched, NULL, 0))
+				return 1;
+		} else {
+			if (verify_retained(memory, size, page_size,
+					    signal == SIGALRM))
+				return 1;
+			if (create_marker(verified, NULL, 0))
+				return 1;
+		}
+	}
+}
+
 int main(int argc, char **argv)
 {
 	if (argc == 4 && !strcmp(argv[1], "activate"))
 		return activate(argv[2], atoi(argv[3]),
 				SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE);
+	if (argc == 4 && !strcmp(argv[1], "activate-no-discard"))
+		return activate(argv[2], atoi(argv[3]), 0);
 	if (argc == 4 && !strcmp(argv[1], "reject-page-discard"))
 		return reject_page_discard(argv[2], atoi(argv[3]));
 	if (argc == 4 && !strcmp(argv[1], "accept-discard-once-pages"))
@@ -214,9 +415,11 @@ int main(int argc, char **argv)
 		return pin_to_one_cpu(argv[2]);
 	if (argc == 6 && !strcmp(argv[1], "allocate"))
 		return allocate(argv[2], argv[3], argv[4], argv[5]);
+	if (argc == 7 && !strcmp(argv[1], "retained"))
+		return retained(argv[2], argv[3], argv[4], argv[5], argv[6]);
 
 	fprintf(stderr,
-		"usage: %s activate DEVICE PRIORITY | reject-page-discard DEVICE PRIORITY | accept-discard-once-pages DEVICE PRIORITY | pin PID | allocate BYTES CGROUP.PROCS READY VERIFIED\n",
+		"usage: %s activate|activate-no-discard DEVICE PRIORITY | reject-page-discard DEVICE PRIORITY | accept-discard-once-pages DEVICE PRIORITY | pin PID | allocate BYTES CGROUP.PROCS READY VERIFIED | retained BYTES CGROUP.PROCS READY TOUCHED VERIFIED\n",
 		argv[0]);
 	return 1;
 }
diff --git a/tools/testing/selftests/zram/zram05.sh b/tools/testing/selftests/zram/zram05.sh
new file mode 100755
index 000000000000..c37f670e2824
--- /dev/null
+++ b/tools/testing/selftests/zram/zram05.sh
@@ -0,0 +1,447 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Test retained offload-only entries under ordinary and proactive reclaim.
+
+set -eu
+
+# shellcheck source=zram_lib.sh
+. ./zram_lib.sh
+
+TCID="zram05"
+cg="/sys/fs/cgroup/zram-retained-$$"
+cg_created=0
+cgroup_root="/sys/fs/cgroup"
+tmp=""
+ready=""
+touched=""
+verified=""
+holder_pid=""
+safe=""
+safe_active=0
+offload_backing=""
+offload=""
+offload_active=0
+dm_name="zram-retained-$$"
+dm_active=0
+dm_node_created=0
+zswap_enabled=""
+thp_size=0
+thp_kib=0
+thp_sectors=0
+page_kib=0
+
+fail()
+{
+	echo "$TCID: [FAIL] $*" >&2
+	exit 1
+}
+
+skip()
+{
+	echo "$TCID: [SKIP] $*" >&2
+	exit "$ksft_skip"
+}
+
+cleanup()
+{
+	local status=$?
+	set +e
+	if [ -n "$holder_pid" ]; then
+		kill "$holder_pid"
+		wait "$holder_pid"
+	fi
+	if [ "$offload_active" -eq 1 ] ||
+	   { [ -n "$offload" ] &&
+	     awk -v device="$offload" '$1 == device { found = 1 }
+		END { exit !found }' /proc/swaps; }; then
+		if swapoff "$offload"; then
+			offload_active=0
+		else
+			status=1
+		fi
+	fi
+	if [ "$safe_active" -eq 1 ]; then
+		if swapoff "$safe"; then
+			safe_active=0
+			dev_swap_ids=""
+		else
+			status=1
+		fi
+	fi
+	if [ "$dm_active" -eq 1 ]; then
+		zram_wait_for_udev
+		if dmsetup --noudevsync --noudevrules remove "$dm_name"; then
+			dm_active=0
+		else
+			status=1
+		fi
+	fi
+	if [ "$dm_node_created" -eq 1 ] && [ "$dm_active" -eq 0 ]; then
+		rm -f "$offload" || status=1
+	fi
+	if [ -n "$tmp" ]; then
+		rm -rf "$tmp" || status=1
+	fi
+	if [ "$cg_created" -eq 1 ]; then
+		rmdir "$cg" || status=1
+	fi
+	cgroup_disable_memory_controller "$cgroup_root" || status=1
+	if [ -n "$dev_ids" ]; then
+		# A live dm mapping still needs its zram backing device.
+		[ "$dm_active" -eq 0 ] || dev_ids=" $safe_id"
+		zram_cleanup || status=1
+	fi
+	if [ -n "$zswap_enabled" ]; then
+		echo "$zswap_enabled" > /sys/module/zswap/parameters/enabled || status=1
+	fi
+	exit "$status"
+}
+
+wait_file()
+{
+	for _ in $(seq 1 400); do
+		[ -e "$1" ] && return 0
+		if [ -n "$holder_pid" ]; then
+			holder_state=$(awk '{ print $3 }' \
+				"/proc/$holder_pid/stat" 2>/dev/null || :)
+		else
+			holder_state=""
+		fi
+		if [ -n "$holder_pid" ] &&
+		   { ! kill -0 "$holder_pid" 2>/dev/null ||
+		     [ "$holder_state" = Z ]; }; then
+			if wait "$holder_pid"; then
+				helper_status=0
+			else
+				helper_status=$?
+			fi
+			holder_pid=""
+			return 2
+		fi
+		sleep 0.05
+	done
+	return 1
+}
+
+require_helper_file()
+{
+	if wait_file "$1"; then
+		return 0
+	else
+		status=$?
+	fi
+	if [ "$status" -eq 2 ]; then
+		[ "$helper_status" -eq "$ksft_skip" ] && skip "$2 is unavailable"
+		fail "retained helper exited with status $helper_status while $2"
+	fi
+	fail "retained helper timed out while $2"
+}
+
+written_sectors()
+{
+	awk '{ print $7 }' "/sys/block/${offload_backing##*/}/stat"
+}
+
+vmstat_value()
+{
+	awk -v name="$1" '$1 == name { print $2 }' /proc/vmstat
+}
+
+memcg_counter()
+{
+	awk -v name="$1" '$1 == name { print $2; found = 1; exit }
+		END { if (!found) exit 1 }' "$cg/memory.stat"
+}
+
+measure_thp_vma_swap()
+{
+	# Measure only the helper's target; process-wide VmSwap includes other
+	# mappings. Before reclaim, require the entire unlocked target to be huge.
+	awk -v want="$thp_vma_range" -v expected="$thp_kib" -v initial="$1" '
+	function emit() {
+		if (range == want) {
+			matches++
+			if (size != expected || swap < 0 || locked != 0 ||
+			    (initial && (anon != expected || swap != 0)))
+				invalid = 1
+			matched_swap = swap
+		}
+	}
+	/^[[:xdigit:]]+-[[:xdigit:]]+[[:space:]]/ {
+		emit()
+		range = $1
+		size = anon = locked = swap = -1
+		next
+	}
+	$1 == "Size:" { size = $2; next }
+	$1 == "AnonHugePages:" { anon = $2; next }
+	$1 == "Locked:" { locked = $2; next }
+	$1 == "Swap:" { swap = $2; next }
+	END {
+		emit()
+		if (matches != 1 || invalid)
+			exit 1
+		print matched_swap
+	}' "/proc/$holder_pid/smaps" > "$tmp/thp-vma-swap"
+}
+
+wait_offload_quiet()
+{
+	# A bio queued inside dm-delay is not yet visible in either the backing
+	# device statistics or the mapped device's inflight counters.
+	sleep 4
+	previous=-1
+	stable=0
+	for _ in $(seq 1 240); do
+		current=$(written_sectors)
+		read -r reads writes < "$dm_inflight"
+		if [ "$current" -eq "$previous" ] && \
+		   [ "$reads" -eq 0 ] && [ "$writes" -eq 0 ]; then
+			stable=$((stable + 1))
+			[ "$stable" -ge 20 ] && return 0
+		else
+			stable=0
+		fi
+		previous=$current
+		sleep 0.05
+	done
+	return 1
+}
+
+check_prereqs
+[ -x ./swap_offload ] || skip "swap_offload helper is unavailable"
+command -v dmsetup >/dev/null 2>&1 || skip "dmsetup is unavailable"
+command -v blockdev >/dev/null 2>&1 || skip "blockdev is unavailable"
+command -v stat >/dev/null 2>&1 || skip "stat is unavailable"
+[ -e /sys/fs/cgroup/cgroup.controllers ] ||
+	skip "cgroup v2 controllers are unavailable"
+grep -qw memory /sys/fs/cgroup/cgroup.controllers ||
+	skip "memory controller is unavailable"
+[ -d /sys/kernel/mm/transparent_hugepage ] ||
+	skip "transparent huge pages are unavailable"
+[ -r /sys/kernel/mm/transparent_hugepage/hpage_pmd_size ] ||
+	skip "PMD huge-page size is unavailable"
+grep -q '^swpout_offload_refused ' /proc/vmstat ||
+	skip "offload refusal counters are unavailable"
+
+thp_size=$(cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size)
+case "$thp_size" in
+	''|*[!0-9]*) skip "invalid PMD huge-page size: $thp_size" ;;
+esac
+[ "$thp_size" -gt 0 ] || skip "PMD huge-page size is zero"
+page_kib=$(awk '/KernelPageSize:/ { print $2; exit }' /proc/self/smaps)
+[ "${page_kib:-0}" -gt 0 ] || skip "cannot determine the base page size"
+page_size=$((page_kib * 1024))
+[ "$page_size" -gt 0 ] || skip "base page size is zero"
+[ $((thp_size % page_size)) -eq 0 ] ||
+	skip "PMD huge-page size is not page aligned"
+thp_kib=$((thp_size / 1024))
+thp_sectors=$((thp_size / 512))
+expected_retained_kib=$((thp_kib - page_kib))
+expected_refused=$((thp_size / page_size))
+
+tmp_dir=$(mktemp -d "${TMPDIR:-/var/tmp}/zram-retained.XXXXXX") ||
+	skip "cannot create temporary directory"
+tmp=$tmp_dir
+ready="$tmp/ready"
+touched="$tmp/touched"
+verified="$tmp/verified"
+trap cleanup EXIT
+trap 'exit 129' HUP
+trap 'exit 130' INT
+trap 'exit 143' TERM
+if [ -e /sys/module/zswap/parameters/enabled ]; then
+	zswap_enabled=$(cat /sys/module/zswap/parameters/enabled)
+	echo N > /sys/module/zswap/parameters/enabled ||
+		skip "cannot disable zswap"
+fi
+
+# Swap priorities are global.  The ordinary zram device must be preferred to
+# any pre-existing swap, while the delayed offload device remains first for
+# eligible proactive reclaim.
+max_prio=$(awk 'BEGIN { max = -1 } NR > 1 && $5 > max { max = $5 } END { print max }' /proc/swaps)
+[ "$max_prio" -le 32765 ] ||
+	skip "cannot outrank existing swap priority $max_prio"
+safe_prio=$((max_prio + 1))
+offload_prio=$((max_prio + 2))
+
+dev_num=2
+zram_size=$((thp_size * 4))
+[ "$zram_size" -ge 67108864 ] || zram_size=67108864
+zram_sizes="$zram_size $zram_size"
+zram_load
+zram_set_disksizes
+set -- $dev_ids
+safe="/dev/zram${1}"
+offload_backing="/dev/zram${2}"
+safe_id=$1
+
+sectors=$(blockdev --getsz "$offload_backing") ||
+	skip "cannot read offload backing size"
+[ "$sectors" -gt 0 ] || skip "offload backing has zero size"
+dm_table="0 $sectors delay $offload_backing 0 0 $offload_backing 0 3000"
+dmsetup --noudevsync --noudevrules create "$dm_name" --table "$dm_table" ||
+	skip "cannot create delayed offload device"
+dm_active=1
+dmsetup --noudevsync --noudevrules info --columns --noheadings \
+	--separator ' ' -o major,minor "$dm_name" > "$tmp/dm-devno" ||
+	skip "cannot identify delayed offload device"
+read -r dm_major dm_minor < "$tmp/dm-devno"
+offload="/dev/mapper/$dm_name"
+if [ ! -e "$offload" ]; then
+	mkdir -p /dev/mapper
+	if mknod "$offload" b "$dm_major" "$dm_minor"; then
+		dm_node_created=1
+	fi
+fi
+[ -b "$offload" ] &&
+	[ "$(stat -L -c '%t:%T' "$offload")" = \
+	  "$(printf '%x:%x' "$dm_major" "$dm_minor")" ] ||
+	skip "delayed offload device node is unavailable or has the wrong number"
+dm_inflight="/sys/dev/block/$dm_major:$dm_minor/inflight"
+[ -r "$dm_inflight" ] || skip "cannot observe delayed offload I/O"
+
+mkswap "$safe" >/dev/null || fail "cannot initialise safe swap"
+mkswap "$offload" >/dev/null || fail "cannot initialise offload swap"
+swapon -p "$safe_prio" "$safe" || fail "cannot activate safe swap"
+dev_swap_ids=" $safe_id"
+safe_active=1
+./swap_offload activate-no-discard "$offload" "$offload_prio" ||
+	fail "cannot activate offload-only swap"
+offload_active=1
+
+cgroup_enable_memory_controller "$cgroup_root" ||
+	skip "cannot enable the cgroup v2 memory controller"
+mkdir "$cg" || skip "cannot create test cgroup"
+cg_created=1
+[ -e "$cg/memory.max" ] ||
+	skip "cgroup v2 memory controller is unavailable"
+echo max > "$cg/memory.swap.max"
+
+./swap_offload retained "$thp_size" "$cg/cgroup.procs" "$ready" \
+	"$touched" "$verified" &
+holder_pid=$!
+require_helper_file "$ready" "creating a PMD-sized anonymous huge folio"
+read -r reported_pid thp_vma_range < "$ready"
+[ "$reported_pid" -eq "$holder_pid" ] ||
+	fail "retained helper reported the wrong pid"
+# On tmpfs, the helper's marker data is reclaimable and charged to its cgroup.
+rm "$ready" || fail "cannot remove consumed readiness marker"
+measure_thp_vma_swap 1 ||
+	fail "target is not an unlocked PMD-sized huge VMA before reclaim"
+echo "$TCID: thp_vma=$thp_vma_range"
+ancillary_locked_kib=$(awk '/VmLck:/ { print $2 }' "/proc/$holder_pid/status")
+[ "${ancillary_locked_kib:-0}" -gt 0 ] ||
+	fail "ancillary helper mappings are not locked"
+echo "$TCID: ancillary_locked_kib=$ancillary_locked_kib target_locked_kib=0"
+
+# This is the only reclaim before the retained entry is made dirty.  It puts
+# the whole folio on offload-only swap so the later single-page fault leaves
+# sibling swap PTEs referring to the existing slot.
+setup_thp_before=$(memcg_counter thp_swpout) ||
+	skip "large-folio swapout counter is unavailable"
+setup_fallback_before=$(memcg_counter thp_swpout_fallback) ||
+	skip "large-folio fallback counter is unavailable"
+echo "$thp_size swappiness=max" > "$cg/memory.reclaim" ||
+	echo "$TCID: setup reclaim was incomplete; checking resulting state" >&2
+wait_offload_quiet || fail "offload device did not quiesce after setup"
+setup_thp_after=$(memcg_counter thp_swpout) ||
+	fail "large-folio swapout counter disappeared"
+setup_fallback_after=$(memcg_counter thp_swpout_fallback) ||
+	fail "large-folio fallback counter disappeared"
+[ "$setup_thp_after" -ge "$setup_thp_before" ] &&
+	[ "$setup_fallback_after" -ge "$setup_fallback_before" ] ||
+	fail "large-folio counters went backwards"
+if [ "$setup_thp_after" -eq "$setup_thp_before" ]; then
+	[ "$setup_fallback_after" -gt "$setup_fallback_before" ] &&
+		skip "PMD-sized folio fell back to base-page swapout"
+	fail "setup did not swap out a PMD-sized folio"
+fi
+kill -0 "$holder_pid" || fail "retained helper died during setup reclaim"
+kill -USR1 "$holder_pid" || fail "cannot request the dirty-page transition"
+require_helper_file "$touched" "faulting and dirtying the retained entry"
+measure_thp_vma_swap 0 ||
+	fail "PMD-sized huge VMA was missing, split, merged, or changed size"
+read -r retained_kib < "$tmp/thp-vma-swap" ||
+	fail "cannot read PMD-sized huge VMA swap usage"
+[ "${retained_kib:-0}" -eq "$expected_retained_kib" ] ||
+	fail "retained $retained_kib KiB, expected $expected_retained_kib KiB"
+echo "$TCID: retained_kib=$retained_kib"
+
+wait_offload_quiet || fail "offload device did not quiesce before pressure"
+ordinary_before=$(written_sectors)
+refused_before=$(vmstat_value swpout_offload_refused)
+echo $((thp_size / 2)) > "$cg/memory.high" ||
+	fail "ordinary pressure reclaim failed"
+wait_offload_quiet || fail "offload device did not quiesce after pressure"
+ordinary_after=$(written_sectors)
+refused_after=$(vmstat_value swpout_offload_refused)
+ordinary_writes=$((ordinary_after - ordinary_before))
+refused_pages=$((refused_after - refused_before))
+echo "$TCID: ordinary_sectors=$ordinary_writes refused_pages=$refused_pages"
+[ "$ordinary_writes" -eq 0 ] ||
+	fail "ordinary reclaim wrote $ordinary_writes offload sectors"
+[ "$refused_pages" -ge "$expected_refused" ] ||
+	fail "ordinary reclaim refused $refused_pages pages, expected at least $expected_refused"
+kill -0 "$holder_pid" || fail "retained helper died after refused write"
+rm -f "$verified"
+kill -USR2 "$holder_pid" || fail "cannot request dirty-byte verification"
+require_helper_file "$verified" "verifying the dirty retained byte"
+
+# Proactive reclaim must still be able to rewrite the retained PMD-sized slot.
+# Repeated requests make the test insensitive to a short-lived writeback
+# collision; the backing-sector delta still requires exactly one folio write.
+wait_offload_quiet || fail "offload device did not quiesce before recovery"
+recovery_before=$(written_sectors)
+echo max > "$cg/memory.high"
+for _ in $(seq 1 8); do
+	echo "$thp_size swappiness=max" > "$cg/memory.reclaim" 2>/dev/null || :
+done
+wait_offload_quiet || fail "offload device did not quiesce after recovery"
+recovery_after=$(written_sectors)
+recovery_writes=$((recovery_after - recovery_before))
+echo "$TCID: recovery_sectors=$recovery_writes"
+[ "$recovery_writes" -eq "$thp_sectors" ] ||
+	fail "proactive recovery wrote $recovery_writes sectors, expected $thp_sectors"
+kill -0 "$holder_pid" || fail "retained helper died during recovery"
+rm -f "$verified"
+kill -ALRM "$holder_pid" || fail "cannot request full data verification"
+require_helper_file "$verified" "verifying all retained data"
+kill -0 "$holder_pid" || fail "retained helper failed full data verification"
+
+kill "$holder_pid" || fail "cannot stop retained helper"
+if wait "$holder_pid"; then
+	:
+else
+	status=$?
+	[ "$status" -eq 143 ] || fail "retained helper exited with status $status"
+fi
+holder_pid=""
+swapoff "$offload" || fail "cannot deactivate offload-only swap"
+offload_active=0
+swapoff "$safe" || fail "cannot deactivate safe swap"
+safe_active=0
+dev_swap_ids=""
+dmsetup --noudevsync --noudevrules remove "$dm_name" ||
+	fail "cannot remove delayed offload device"
+dm_active=0
+if [ "$dm_node_created" -eq 1 ]; then
+	rm -f "$offload" || fail "cannot remove delayed offload device node"
+	dm_node_created=0
+fi
+rmdir "$cg" || fail "cannot remove test cgroup"
+cg=""
+cg_created=0
+cgroup_disable_memory_controller "$cgroup_root" ||
+	fail "cannot restore the cgroup memory controller"
+zram_cleanup || fail "cannot clean up zram devices"
+dev_ids=""
+if [ -n "$zswap_enabled" ]; then
+	echo "$zswap_enabled" > /sys/module/zswap/parameters/enabled ||
+		fail "cannot restore zswap"
+	zswap_enabled=""
+fi
+rm -rf "$tmp" || fail "cannot remove temporary files"
+tmp=""
+
+echo "$TCID: [PASS]"
-- 
2.55.0


