Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99723F9D0E7
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 16:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC3C6B0088; Tue, 14 Apr 2026 12:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4236B0089; Tue, 14 Apr 2026 12:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9CF6B0092; Tue, 14 Apr 2026 12:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA6F56B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:49:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 720C01A01CC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:49:46 +0000 (UTC)
X-FDA: 84657747972.14.4D5BD05
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8AAF3140014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:49:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AheSCCfk;
	spf=pass (imf23.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776185384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUoYKq79bxvjyxgdJrulHpNt50LqCWweYqk4dEJlv4E=;
	b=iIBYvwggebWwNzj2rJkN5mXQp5/B3mpJRAslCzIHMTkTIVaXCNZZGKI5zfgK/+YgISQG31
	7QMqKCEyKbaVrhwWVs43DxUEcgof7Fg2oGh6VsaP5YbquVrsEcoH6CkkFv/lB75/o9kGYA
	2swdsqv8/h9P8zS1KockUTaYNR1VW48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776185384; a=rsa-sha256;
	cv=none;
	b=JGOc8l3vj2EMba4GjoXdWxx29A0BpOsedXjV9seHEoyVipMW1rrWihAKM3TyFILOZ2NjWF
	UlHYEKuHv6F+eGzq/ZxDLPom6Wv9xfOVKVQJ4vTeO4lBL2NJB96VlgpSOKPwD7IGOXB6Tm
	zxFbHlTLmLmaZNbBqZ8tS4dMyu+cTIA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AheSCCfk;
	spf=pass (imf23.hostedemail.com: domain of charsyam@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b467d03d57so1651985ad.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776185383; x=1776790183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUoYKq79bxvjyxgdJrulHpNt50LqCWweYqk4dEJlv4E=;
        b=AheSCCfkG+BlmdtBDgLL0/Luc2qJZ2SlluO2SA9JwrAtA8wejXSzo8V4jSn+bfGSzd
         QWM+tkl+trd9M1TCKttOBiOUkcdn6CJ73K6pQf5M0V0FhH3t8DnlrOVv0/Hq3KvoidWS
         Ys0tn5wLz/Y2jqwoqhsWFnSPW/N9l8gYyyt11/zyhXfzV84owtK76d8xncMAdop/ncMR
         iDSWOdWDf4pA4eusiz6jPy6YoDwgQvW9wzkoOD96l0SRfYzfo+i4NQBJ8dfraGnR1jgC
         MI4JRBQjRA0MjOd5MHoNsoTOBXnoun3slz02TQ/SDMDKSj3m92BMNoDigSoZB/yWCjhX
         eUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776185383; x=1776790183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FUoYKq79bxvjyxgdJrulHpNt50LqCWweYqk4dEJlv4E=;
        b=bTWp73h0D0CwRC05NdecPLtizgk3h/1z1F8LaLCU724gkDi1aUcpCwzSK+xpKJ476o
         KP2gOvqL/Ec77lDbZ/8LJ1kEU0pcjmSiCukZvhUrgGDni27Mf87RAQRSW+0/+oataw6l
         kbOM1r3BxbWMApC5xALz13Inye9G0ZuX7EK6Y8OCR6wdSQu6Z++V0KOyNTcBwCMAGqZw
         or2zw60aXE3Z5G8E+CKES8ibeeOmz7JMg1dbqAizL9FqBXLWo7N+m8Gevlhn9CwG15/r
         CfF8K/f63Rb162wkS7+DpoU6sLVV9gWzEdhFjGSkD+JqFIJPdnEIsHarkfxSxW/VrToA
         Kyag==
X-Forwarded-Encrypted: i=1; AFNElJ/29HJeKV4FsDeenafrmNHZXwi7gxwrgio6qA/SNukDbquvcw0aE41GdSZ2KrO9xThnidfa79Rhkg==@kvack.org
X-Gm-Message-State: AOJu0Yyhh7w28GUm7LCzJCAI4NeOhWywfevyaLlowV9+puw/GEwasdw2
	1WQRgIfb1kFKpD6Sva2gB+wyLIRVDJgzu3LwOkks5hsvua1IFUfA7Sx+
X-Gm-Gg: AeBDiesQhvbiFQIwK2LkFMNVeSFMWCVBIUWiHrZh8EI4dlILzEDLrDMCKUv3UdZCC8r
	TC4WiiSaKozPsbzRGGpky/x9Dgcp0uHHS7MV8iQnEciwZ1jzpEHsSFGAVki4X0KCyw0SeFa4DqB
	FW67Z6L1Xq1n2ylZ6uHnW6OTzXgXAuyK2QlkSySn6pAdqVBZpFqVQNHxszKz8mgKnU9JKqdmtmK
	qMfsjgUz4RxD1prR8UfGBlA9F6Zg0cTyEu2tc85WJ8ZvuG6IRGb+KUlVD8taJ6a68+b0u4YGdz+
	DNlUzvFw2pLvg9YC43NCrFNNVMyGHA+zjIII69U/gl1cX9ykzGvZeGi2AqBl0FsRS5YJ47+BMOl
	PfS9cJs/85wAK9UWKM/Xr/V8M/cyfYyverHiU10ECsSqWhwpdEvCW4Md3FGFfYt45nv1WIBohF+
	s6DaJmVJGgOFELQGPy
X-Received: by 2002:a17:903:faf:b0:2ae:3f3f:67c4 with SMTP id d9443c01a7336-2b2d580f23cmr111214755ad.0.1776185383117;
        Tue, 14 Apr 2026 09:49:43 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dabca4sm153358325ad.15.2026.04.14.09.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 09:49:42 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2] PM: hibernate: keep existing uswsusp swap pin if re-selection fails
Date: Wed, 15 Apr 2026 01:49:36 +0900
Message-ID: <20260414164937.1363887-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414143200.1267932-1-charsyam@gmail.com>
References: <20260414143200.1267932-1-charsyam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: g86sfsatppsghso9kzfhcxntszbxjjyr
X-Rspamd-Queue-Id: 8AAF3140014
X-Rspam-User: 
X-HE-Tag: 1776185384-542071
X-HE-Meta: U2FsdGVkX1+SbCpB9BXpvwtbmfxsVILpLvTq7E1gu4+jDyTbK6nHrXHXeBHgmpk20i4FvQNt3wg4BhQMPcUQc9R0tNDO/P8eJmacTuZJp4+d+C2Z31kjoGsT4mC6uB9NLnFFOsufVFvjUyTl/8uslKS2rTk2Udo9Rttd9unVTwszpDlypPl5y5IDDwpu64QFS5BS33M3cUMxgYQOevSmA0lQXNtol2iNtkbqtOEzrt2XN5B/0849alOM5Tdp5qiGKmvFclFANZ/3DP6d/2xoXaaTKJbYqQbCym32HVxvwyx2NvIXXS5F6kZd5ECsLk8GlHORqsU6os67V84KHOdFZJaaxnDK0DX4Eze5B0NL+d5PnUOflfZefQOCnp5O7tjh+kijwvBoeN8FEuFy31fqePbrOo7KU6VX9VTlwC/qTqQJ8AHA0KwI+52U0vWX62FDDbNyzDGmZP7KLqxrtImvzxblNVOL0QzckjiLNfJNiT/gLF84OvSOo7GiKocf9EMMiI21eqyEPMVcCOPh8WsCXi4hOifTXlhMOKDT3AF8JStNAvXgpMUWWoJi3rS7VR2BofJ8rgmWxBgI4fUlVveiYLLIRNnXN7DIqjebS0xGL75TDKRB/zlepi4YZfNSLAAk1bpM2aDxCdLLoQ8FYhdoHAXy29OrV2grsVLLCvjiAtmZF9Pw3cZzJghB/y6R6b4Rg+7ZwCHs80b9e7wcxjpO7cKY3Vo+696d5cwArsGulVgQ42lQxd/UXcjtJA9YaN56+LCWDs6tUMRg3oyjzOdK2+UiflLkwAgHYTTzrSYixnMaRw+ILf/VgjYA5QoxB/erVwJ8LD1MKgX5nfIXHoV79byukjU7DT49RD1CpaOF6WNfnYBOW9E4CAOxpjYHjiC9JjWIkK77Sd1TlZgEKIRHTLE8hOml/FhXlG0hGc54KsPsxqGAAAGchVjuiNeXu0loy53P8l2saaljarquCbS
 4aYGIlfs
 q3IWTakXVwhv+U16HU/V71C/jQZPFgT7/lxJrz/aLx+UTkOvz5pGItxhiEX3lh9OGNYTvAbmqtIWxopkuPesvW4Vbg5O6xypWV8ivKf/h9QAjptjw9NYU3PhJBBKJJR7rql5zUEOFqYSoz5B9ybM5SAp/wnCbfjVuuQm388a1h7aRwe2zTwkSvYgiBLihnmlBtM2wdEcAtvwwOxMIQUG1XbKt/f6uXFKfwJhC8331qE75snF5k+bD/9aACQuVZq8okyUQEJw17Lhi+VmhWfxktxdJQhMcfwhYGlRcNo5F4L0yZuvMR/sGhl6qkH/NOdRJ9kCbgpWz5rOc4pWvZr9MkK50/I74XmOeZ0KA4LS1bvHHbxHJyxq43TELY4eu3LGefQ2EFXbkPwDjK5ds2d4ywBqD6+anhrk5wLG0BrMPLkbYoTC8cwkvvMCZrJmdN7U8DBG+ZPcHN8x3TF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5b2b0c6e4577 ("mm/swap, PM: hibernate: fix swapoff race in
uswsusp by pinning swap device") introduced SWP_HIBERNATION so that
the swap area selected through /dev/snapshot remains protected against
swapoff() for the lifetime of the uswsusp session.

When user space issues SNAPSHOT_SET_SWAP_AREA again,
snapshot_set_swap_area() currently drops the old pin before attempting
to pin the new swap area.  If the new selection fails, the ioctl
returns an error and user space is expected to abort the session.
However, preserving the existing pin in that case makes the kernel
side more robust against a failed re-selection, while keeping the
existing userspace-visible behavior unchanged.

Implement this with the existing swap helpers:

  - look up the requested swap area first
  - treat re-selecting the already pinned area as a no-op
  - pin the new area before unpinning the old one
  - leave the existing pin in place if the new pin attempt fails

This keeps the hibernation session protected against swapoff() until
/dev/snapshot is closed, even after a failed attempt to switch to a
different swap area.

Suggested-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
Notes (not part of the commit, stripped by git am):

Changes in v2:
  - Drop Fixes: and Cc: stable; reframe as a hardening improvement
    rather than a regression fix, per Youngjun's feedback that the
    current behavior is intentional and there is no concrete
    user-observable harm.
  - Drop the new repin_hibernation_swap_type() helper. Rework
    snapshot_set_swap_area() in place using the existing find / pin /
    unpin helpers as Youngjun suggested; the change now touches only
    kernel/power/user.c and adds no new API.
  - Update the subject and commit log accordingly.
  - Add Suggested-by: trailer.

v1: https://lore.kernel.org/lkml/20260414143200.1267932-1-charsyam@gmail.com/

Baseline
--------
This patch is generated against linux-next at commit 5b2b0c6e4577
("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap
device"). Mainline does not yet carry that commit, and neither the
helpers used here (find/pin/unpin_hibernation_swap_type) nor the code
site this patch modifies exist there. The base-commit trailer at the
bottom of the mbox records the exact commit.

Testing
-------
The behavior change can be exercised entirely through the
/dev/snapshot ioctl path; no actual hibernation cycle is required.
A targeted assertion test is below; run it as root in a throwaway VM
with two active swap block devices and one non-swap block device
(three arguments).

Run inside a VM on linux-next at 5b2b0c6e4577 with this patch applied:

  step1: pinned active swap /dev/vda
  step2: swapoff blocked with EBUSY while pin is held
  step3: repinned active swap to /dev/vdb
  step4: swapoff(/dev/vda) succeeded after repinning away
  step5: repinned swap is blocked with EBUSY
  step6: bogus SNAPSHOT_SET_SWAP_AREA failed as expected: No such device
  step7: swapoff(/dev/vdb) is still blocked with EBUSY
  result: pin preserved across failed re-set (hardened behavior)
  step8: swapoff succeeded after closing /dev/snapshot

Without the patch, step7 instead reports
  swapoff(/dev/vdb) succeeded after failed re-set
because the old pin had been released before the failed pin attempt.

What the assertion test covers:
  - SWP_HIBERNATION is enforced against swapoff (step2, step5);
  - the success path moves the pin from one active swap to another
    (step3, step4, step5);
  - a failed re-selection preserves the existing pin (step6, step7);
  - the pin lifetime ends on /dev/snapshot close (step8).

What it does not cover:
  - the snapshot_open(O_RDONLY) initial resume-device pin path;
  - the full suspend-to-disk image create/restore flow;
  - concurrent swapoff racing against SNAPSHOT_SET_SWAP_AREA;
  - the type == data->swap idempotent branch (not externally
    observable since it intentionally skips the bit toggle).

A normal sysfs-based suspend-to-disk cycle continues to work; the
find_hibernation_swap_type() / pin / unpin paths themselves are
unchanged. Build tested with allmodconfig and run-tested with
CONFIG_PROVE_LOCKING=y and CONFIG_KASAN=y. The VM was booted with
oops=panic panic=-1 so any WARN/Oops/BUG would have halted the run;
the full test completed cleanly with no kernel log diagnostics.

Reproducer (C source, for reference only -- not added to the tree):

 // SPDX-License-Identifier: GPL-2.0
 /*
  * Reproduce / verify the SNAPSHOT_SET_SWAP_AREA pin-lifetime behavior.
  *
  * Run only inside a throwaway VM. The test manipulates swap state and
  * leaves the target swap area disabled on success.
  *
  * Usage:
  *   ./uswsusp_swapoff_repro <active-swap-1> <active-swap-2> <bogus-blk>
  *
  * Exit codes:
  *   0 = expected (hardened) behavior: pin preserved across failed re-set
  *   1 = old behavior: pin dropped on failed re-set
  *   2 = setup error / inconclusive
  */

 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/types.h>
 #include <linux/suspend_ioctls.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/swap.h>
 #include <sys/sysmacros.h>
 #include <unistd.h>

 static int encode_dev(dev_t dev)
 {
 	unsigned int major_num = major(dev);
 	unsigned int minor_num = minor(dev);

 	/* Match new_encode_dev() / new_decode_dev() in the kernel. */
 	return (major_num & 0xfff) << 8 |
 	       (minor_num & 0xff) |
 	       ((minor_num & ~0xff) << 12);
 }

 static int get_block_dev(const char *path, dev_t *dev)
 {
 	struct stat st;

 	if (stat(path, &st) < 0) {
 		fprintf(stderr, "stat(%s): %s\n", path, strerror(errno));
 		return -errno;
 	}
 	if (!S_ISBLK(st.st_mode)) {
 		fprintf(stderr, "%s is not a block device\n", path);
 		return -EINVAL;
 	}
 	*dev = st.st_rdev;
 	return 0;
 }

 static int snapshot_set_swap_area(int fd, dev_t dev, long long offset)
 {
 	struct resume_swap_area area = {
 		.offset = offset,
 		.dev = encode_dev(dev),
 	};

 	if (ioctl(fd, SNAPSHOT_SET_SWAP_AREA, &area) < 0)
 		return -errno;
 	return 0;
 }

 int main(int argc, char **argv)
 {
 	const char *p1, *p2, *pb;
 	dev_t d1, d2, db;
 	int fd, ret;
 	bool buggy = false;

 	if (argc != 4) {
 		fprintf(stderr,
 			"usage: %s <swap1> <swap2> <bogus>\n", argv[0]);
 		return 2;
 	}
 	if (geteuid() != 0) {
 		fprintf(stderr, "must run as root\n");
 		return 2;
 	}
 	p1 = argv[1]; p2 = argv[2]; pb = argv[3];

 	if (get_block_dev(p1, &d1) < 0 ||
 	    get_block_dev(p2, &d2) < 0 ||
 	    get_block_dev(pb, &db) < 0)
 		return 2;

 	fd = open("/dev/snapshot", O_WRONLY);
 	if (fd < 0) {
 		fprintf(stderr, "open(/dev/snapshot): %s\n", strerror(errno));
 		return 2;
 	}

 	ret = snapshot_set_swap_area(fd, d1, 0);
 	if (ret < 0) { fprintf(stderr, "step1: %s\n", strerror(-ret)); goto setup_err; }
 	printf("step1: pinned active swap %s\n", p1);

 	if (swapoff(p1) == 0) {
 		fprintf(stderr, "step2: swapoff unexpectedly succeeded\n");
 		close(fd); return 1;
 	}
 	if (errno != EBUSY) {
 		fprintf(stderr, "step2: expected EBUSY, got %s\n", strerror(errno));
 		goto setup_err;
 	}
 	printf("step2: swapoff blocked with EBUSY while pin is held\n");

 	ret = snapshot_set_swap_area(fd, d2, 0);
 	if (ret < 0) { fprintf(stderr, "step3: %s\n", strerror(-ret)); goto setup_err; }
 	printf("step3: repinned active swap to %s\n", p2);

 	if (swapoff(p1) < 0) {
 		fprintf(stderr, "step4: swapoff(%s): %s\n", p1, strerror(errno));
 		goto setup_err;
 	}
 	printf("step4: swapoff(%s) succeeded after repinning away\n", p1);

 	if (swapoff(p2) == 0) {
 		fprintf(stderr, "step5: swapoff unexpectedly succeeded\n");
 		close(fd); return 1;
 	}
 	if (errno != EBUSY) {
 		fprintf(stderr, "step5: expected EBUSY, got %s\n", strerror(errno));
 		goto setup_err;
 	}
 	printf("step5: repinned swap is blocked with EBUSY\n");

 	ret = snapshot_set_swap_area(fd, db, 0);
 	if (!ret) {
 		fprintf(stderr, "step6: bogus unexpectedly succeeded\n");
 		goto setup_err;
 	}
 	printf("step6: bogus SNAPSHOT_SET_SWAP_AREA failed as expected: %s\n",
 	       strerror(-ret));

 	if (swapoff(p2) == 0) {
 		printf("step7: swapoff(%s) succeeded after failed re-set\n", p2);
 		printf("result: pin was dropped on failure (old behavior)\n");
 		buggy = true;
 	} else if (errno == EBUSY) {
 		printf("step7: swapoff(%s) is still blocked with EBUSY\n", p2);
 		printf("result: pin preserved across failed re-set (hardened behavior)\n");
 	} else {
 		fprintf(stderr, "step7: unexpected: %s\n", strerror(errno));
 		goto setup_err;
 	}

 	close(fd);
 	if (!buggy) {
 		if (swapoff(p2) < 0) {
 			fprintf(stderr, "step8: swapoff(%s): %s\n", p2, strerror(errno));
 			return 2;
 		}
 		printf("step8: swapoff succeeded after closing /dev/snapshot\n");
 	}
 	printf("note: re-enable with `swapon %s` and `swapon %s`\n", p1, p2);
 	return buggy ? 1 : 0;

 setup_err:
 	close(fd);
 	return 2;
 }

 kernel/power/user.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4406f5644a56..e1ab85db2e95 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 {
 	sector_t offset;
 	dev_t swdev;
+	int type, swap;
 
 	if (swsusp_swap_in_use())
 		return -EPERM;
@@ -239,18 +240,34 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 	}
 
 	/*
-	 * Unpin the swap device if a swap area was already
-	 * set by SNAPSHOT_SET_SWAP_AREA.
+	 * User space encodes device types as two-byte values, so we need to
+	 * recode them.
 	 */
-	unpin_hibernation_swap_type(data->swap);
+	type = find_hibernation_swap_type(swdev, offset);
+	if (type < 0)
+		return swdev ? -ENODEV : -EINVAL;
 
-	/*
-	 * User space encodes device types as two-byte values,
-	 * so we need to recode them
-	 */
-	data->swap = pin_hibernation_swap_type(swdev, offset);
-	if (data->swap < 0)
+	if (type == data->swap) {
+		/*
+		 * Re-selecting the already pinned swap area is a no-op.
+		 * Keep the existing pin and just refresh the cached device id.
+		 */
+		data->dev = swdev;
+		return 0;
+	}
+
+	swap = pin_hibernation_swap_type(swdev, offset);
+	if (swap < 0) {
+		/*
+		 * Preserve the existing pin on failure.  This can happen if the
+		 * target swap area disappears before pinning, or via the
+		 * defensive -EBUSY path in pin_hibernation_swap_type().
+		 */
 		return swdev ? -ENODEV : -EINVAL;
+	}
+
+	unpin_hibernation_swap_type(data->swap);
+	data->swap = swap;
 	data->dev = swdev;
 	return 0;
 }

base-commit: 5b2b0c6e457765adbe96fb2d464ff1bcd3d72158
-- 
2.43.0


