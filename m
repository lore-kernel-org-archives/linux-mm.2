Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F037606A323
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MdSsXvC4
Received: by kanga.kvack.org (Postfix)
	id 105166B05B2; Fri, 30 Oct 2026 13:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5E46B05B5; Fri, 30 Oct 2026 13:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6BD6B05B6; Fri, 30 Oct 2026 13:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3BF86B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:23:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ADE8A080F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:32 +0000 (UTC)
X-FDA: 85379964264.20.9FD179D
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04365A0003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=MdSsXvC4;
	spf=pass (imf25.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.216.100 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793381010;
	b=r6/iMK1yyf4am5W6v8kJYjwzI/jPvsqdaVkd5kgScxgcwW9n7o/hEVydMD8dDZblZtYvNG
	NpINnlO289K6sgp/MaFSUMePHslIHRmNMeGkeKcMQXu80ZS9XT8sIOOZDKth0AM00GINPI
	fCdeXJtsBENixwXiwCpPVYdbAA2magM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793381010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xxbZQjtm9fOqIJixd8F3mRtkVPXrctgUHoISK45HDYU=;
	b=0G5duCIyFSlGyLuZKhzsGOJDJw0eoOEsdGu6laLnsztq841Aa5JTw2lDO8OLoxxDKkr12b
	gVng89KL/xGhMxjs4uuk9L//R3Ovy5GHZ/T/2CXclGjjcfWHWBM6kXFRGj1PyvlVeCiaqh
	XALecXLIfBDrvwud+O0FSkJMhpTATfE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=MdSsXvC4;
	spf=pass (imf25.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.216.100 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ac78f4c10bso489632a91.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381009; x=1793985809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xxbZQjtm9fOqIJixd8F3mRtkVPXrctgUHoISK45HDYU=;
        b=cuHLf8EtH8EiAeuDwERGok5JILdUSz91/Eg1xdPkaRs6zcG8HkbjMxRzQzl2oy17Xi
         cbS7EfAZ1U4J92VoFgF3GP3LtXI2wTpRrwNPdNYOqLtS+Rr1h71gwL42HaANkOQHcj/9
         aXlN+x1Uc6jNFvaO3S0oYOmzOXaIC9qDJZb9HniliIJMY4EQUckkeAcDwUpl0fM5YZxn
         v/8qjLTttdoC2Y090LlDx5pe1wkDAr0+IVQ07IuiAK7GdH39OU/wV43ntxokDAON0NW9
         SqWlEXSxKWtNHDmCIngGbcU0KuaFXhWiq0v4Bb+tHLQgS/QoJtR5W4sPBWwcP5AGQg25
         6pcA==
X-Forwarded-Encrypted: i=1; AKwUvBzY8Iz2kv2H/8YbuT5aXgXXABrnKCVWb5CceduzXVmHXC6HN2MNEG71nxJnGzR4tj5SDj3RJsX2IQ==@kvack.org
X-Gm-Message-State: AFq9FYI5s9n1Xj6Y8hoIptmWUPwXCaKIJiSrAhefGQQCX3kmgIxS5x7U
	xwX9zNiREMisHnRJBIaCw9oumdTJRLopz3VMSJ9vezLkkNd/5ZP2p1ov9grWxCjJxTDigCTuKqV
	0etlGm55SR/NpNXLYxhtqYeSB8QxN/PqGMvqOkVLuFEs1lRzSqccbXNNhJo5B/UC1VNli1LGuLE
	yoL9T7azEodK+NM49nwzAgMteRdSOvqL+rCMaEONfg9SIvBf3m5cmqt3x/94VfPd3a0qwXK9Ldy
	iP2+gw+KjhygQ==
X-Gm-Gg: AYBFou2Itci7Ln3g0F+VLuoTG88IEN0NBrS4Gf4yB/9lnC/LiPlVojEG8Fwx20j8CFA
	YSE6j91xzMBI4qzILOBX9obeQa2cHewbOnTUQCSIEcKDoR5kjiA9G3162KL8fjIVSARdShrcMTE
	pP+41RZKHjcN038mEsDOQx2dHURTcll4w92PLP0fEoHee2ZADpWWKIk33mWyJqQOsZAS/3ErkB+
	glOWFziO/KuzmAZzYxYeohCyagRNB4g/iC/s0wh3set+6O6bAfGjBACQyL4Vq4TJbNjzOLqZmMV
	aoPJ3JWMya8EMAPVaGe6T1GV2rQkMjq1YkooF5UXiZJ1qcWG3sNqKlXKQDrxJUt7WmaWAaVLkG6
	p/zIpvZr0zTuqnm32wfUI7PaOO3QuQ0Acx9rjFDWVC7qyNlYTxsd3aqL+tjPNfKgCO0V87nONom
	HQc3lnBeBr4cszufeGzFunLnFk1U8RTUp/1S1DSNYF
X-Received: by 2002:a17:90b:3d4b:b0:3ae:2969:903f with SMTP id 98e67ed59e1d1-3ae89771936mr2530412a91.45.1793381008766;
        Fri, 30 Oct 2026 10:23:28 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae881b211dsm797318a91.4.2026.10.30.10.23.28
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2026 10:23:28 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-193b5eb133eso1093583c88.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793381007; x=1793985807; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xxbZQjtm9fOqIJixd8F3mRtkVPXrctgUHoISK45HDYU=;
        b=MdSsXvC4nmHEaobqz5+SDVYpW4VUYb7bfDZZ+25/EtilW043b+rjus2rTVpi8MmlHo
         zz3jtUpk4Ui/8hCbFVF9EbydofUv/nVa8Hvwgh6HiVXi41/z36UJ97eUC50QFXCddfQR
         WHxDw9vgvWs8Ix6Hqdm66pjmAJ37l+ig4DusA=
X-Forwarded-Encrypted: i=1; AKwUvBwcUMzSwG9J4hd1Qn5654juMNoAczKEIqyJ7xIUStYvpu9ZwWzWV9hGq2xuE+05A47vVpaX6f6SJQ==@kvack.org
X-Received: by 2002:a05:701b:420c:20b0:194:f017:5a01 with SMTP id a92af1059eb24-1ac5fc0d363mr3906646c88.42.1793381006452;
        Fri, 30 Oct 2026 10:23:26 -0700 (PDT)
X-Received: by 2002:a05:701b:420c:20b0:194:f017:5a01 with SMTP id a92af1059eb24-1ac5fc0d363mr3906598c88.42.1793381005631;
        Fri, 30 Oct 2026 10:23:25 -0700 (PDT)
Received: from stbirv-lnx-1.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm8463406c88.21.2026.10.30.10.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:23:25 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: stable@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 6.1, 5.15, 5.10 0/3] mm: backport mmap_min_addr handling fix to vm_unmapped_area()
Date: Fri, 30 Oct 2026 10:22:13 -0700
Message-Id: <20261030172216.368052-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspam-User:
X-Rspamd-Queue-Id: 04365A0003
X-Rspamd-Server: rspam12
X-Stat-Signature: 4c4j9enp94ghu3bn6ikgfckaxfjyno13
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793381009-48013
X-HE-Meta: U2FsdGVkX1+XlKsWoJ3xjP4LTZlZ3Nr7+UsLZADWTG038UTuUfl48orS7hAhlHCV7Msn1p0J5HwDHTOx+SrhI2jwsj7PkGkGsFDjhF4xrhTKmqzFNKwX4qMgF1Fcn4Eci+oyZBAVfAZJdNKXYbz6iuyHub63Wnxu0/M55kepD7mMweGhLkwTcLp6mcEl/z+GUhM1rvJH4cviU+LCLZM6VtZubeloEtAQ/YcN6ObPi1ZbpTzlQKRxAWWJkr6UpsQK09HYxCc3xXmvK5MTzGyU0wOBeyY5fMr/Zi5pXRPwPtg/E3zvQdfeHehPTIN3aY7Q5adz+Rp7oRApv4tZmi6YapAwpAyrfdTOB9xSoPUtrljfZEjgB3Jg4DpFkLOFUvLanFJ0Hq4YqU2fbKT9Ue3A+NKTC8TJsFhny++pwTxNxfYNZFtK8Zd0U1pzP9qPkjmC5p1joPxrhluNu9KpRvbr6Vq6Vu7x2t0nmWD/4tqXYOTmYRs50Aqv8GcT70c0Kroqtxgw+QxfRrznhOaczdHHW+tjJGj+AqBE7QvwTNKjtRg9SX94ffTXyV/DsA79/Lwcz9+Q/ddCkQVCVmwHO8orhpJ78Vqku6ocmkM1I2X2JjizjxmF2jLLcuNhLDLvmx1GKlHFwxPczmXTJ04GMcq2NiFyFVouRIQVf2FHV0ATgUmgG+cJIwuYPTonlV9yx4fzMYitWOsHXuc4UUbW12tB5P6EyQs9FmRCW1QihfewxA4nbQoxtoEcgKfb/YS/fQ6+sWR4Do8NApePp4M5vnr3KSxTufgoXLVnTqaEux+mRkv7JizbWjHojLvhCEK/mtMNX7xDViCSjhe0mUHAEjTQKRRvzseVfCzlEkHf5NV7UzzxTrlIpZimMRLTdxph5YT/qN6IEzbWeDkPvHoDWjJScuFtsWrcySEE5XP/wPYabWSkAE/7NRONCL/dzICrhFD/8GENhLw+xO/tWzbSpfy
 mHpibx1Z
 5x5mJLQWu9FzdhkKxjmikgShE70J1yy5CdGLBTH554r+/wUBZyz+Ta+09CLa9hSgp/6rL08jFkzTn4yTJ0o711Qpuu9Tu65HV6jA6SeKqG4ddwrEj6KxwbeuU7Ch3L6pHIio19X/it0OM0xiMXGDl9sEXXAYe7VgQZ7a69FKiJIWBZGYwPyU1Wan5yJlmldmTBI6Hs8N1rDOJ/C3ANO8BHzmYk0f9VWMmXwmkchtPuNTStMWiD8Zy+p6/FItwAm+4746nYitlsZW1PcKfosVEpA6YSfBHZze4DO0bGpsZxBfv5fpZietOtPR6X3WiY0DavMe/x4F3Mm8hvFSd1+4pnr4jtyS1DN/Nmw+QbGbKAHiDz/98Li9Uz2ObFZ5Oo635Vh4gNHb4R3wpQJ35MecQJaDuL92foMaOq5S24UzuxwyP4t+3bz6C7dCY8970p3e8pzvM4TfFgMyOgkuAyht2M6EDT3wp0IV6w9MKVpoUXe0vt53NBxwb4cWsdM1WbMtaxWJgCZ1DDOdN5uNTyytOu0l/xJvguEAJfpiVlJvucm2SXjXJcPc0Huldrh+MH7AOq8yVyroFYBwVTrWBcmhYaqjxF6gU/6yfb7vw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To: stable@vger.kernel.org
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org

This series backports

  6b008640db73 ("mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()")

to the 6.1, 5.15 and 5.10 stable trees. It is already part of v6.4-rc1
and therefore present in 6.6.y and later. The three patches are
independent of each other, one per tree, and are meant to be applied to
the respective stable branch only.

Problem
=======

An unprivileged process can get EPERM from mmap(MAP_ANONYMOUS) although
plenty of address space is still available. This happens when
vm.mmap_min_addr is larger than PAGE_SIZE (the usual case, distributions
and embedded systems set 32 KiB or 64 KiB):

  - with the top-down layout, the search starts at mm->mmap_base and
    walks down towards low_limit;
  - several architectures pass a low_limit below mmap_min_addr to
    vm_unmapped_area() (PAGE_SIZE, FIRST_USER_ADDRESS, ...), so the
    search can return an address in [low_limit, mmap_min_addr);
  - get_unmapped_area() gets that address back from the architecture
    code, but security_mmap_addr() then refuses it, and the caller sees
    -EPERM.

The right outcome is to treat the range below mmap_min_addr as not
available, so that the top-down search fails with -ENOMEM and the caller
falls back to the bottom-up search above mmap_base, as the generic code
already does.

Commit 2afc745f3e30 ("mm: ensure get_unmapped_area() returns higher
address than mmap_min_addr") fixed this only for the generic
arch_get_unmapped_area_topdown(). Architectures with their own
implementation were left alone. 6b008640db73 moves the clamp into
vm_unmapped_area() itself, which fixes all callers at once.

Affected code, determined by reading the 6.1, 5.15 and 5.10 trees and
confirmed by running the kernels below:

  - x86-64 (arch/x86/kernel/sys_x86_64.c), including 32-bit processes
    on a 64-bit kernel, and the x86 hugetlb search
    (arch/x86/mm/hugetlbpage.c)
  - arm (arch/arm/mm/mmap.c)
  - mips (arch/mips/mm/mmap.c)
  - sparc64 (arch/sparc/kernel/sys_sparc_64.c and
    arch/sparc/mm/hugetlbpage.c); only 32-bit tasks use the top-down
    layout there
  - by code inspection only, not run: parisc, sh and, in 6.1, loongarch

arm64, s390 and powerpc already clamp to mmap_min_addr in their own or in
the generic code, so their behaviour does not change; they were run as
regression checks (see below). 32-bit x86 kernels use the generic code,
which already clamps; that was checked by reading the code only.

Backport notes
==============

  6.1.y   The patch applies cleanly.

  5.15.y  Same as 5.10.y, see below.
  5.10.y  These trees predate the maple tree, so the mm/mmap.c hunks do
          not apply. unmapped_area() and unmapped_area_topdown() are the
          rbtree based versions; the lower search bound is clamped
          there with a local min_addr = max(info->low_limit,
          mmap_min_addr), which is then used in place of
          info->low_limit (including the early "low_limit > high_limit"
          check, the final clipping of the gap and the VM_BUG_ON()). The
          arch/s390 and fs/hugetlbfs hunks apply as in the original
          commit. This is noted in the commit message of each patch.

Reproducer
==========

Run it as an unprivileged user, with vm.mmap_min_addr set to something
larger than PAGE_SIZE (for example 65536). It exits with status 1 and
prints "Operation not permitted" on an affected kernel, and exits with
status 0 and prints "Cannot allocate memory" on a fixed one.

  - 32-bit process:                      ./repro
  - 64-bit process:                      ./repro 1099511627776
    (starting with 1 TiB chunks makes the 47/48 bit address space run out
    after a few hundred mappings instead of billions)

--- mmap-minaddr-repro.c ---
// SPDX-License-Identifier: GPL-2.0
/*
 * Map anonymous memory until mmap() fails and report why.
 *
 * Run as an unprivileged user (root has CAP_SYS_RAWIO, which bypasses
 * vm.mmap_min_addr) with vm.mmap_min_addr larger than PAGE_SIZE.
 *
 *   32-bit process:  ./repro                 (64 KiB first, halved on ENOMEM)
 *   64-bit process:  ./repro 1099511627776   (start with 1 TiB so that the
 *                                             address space is used up quickly)
 *
 * A kernel that handles vm.mmap_min_addr correctly ends with ENOMEM once the
 * address space is exhausted.  An affected kernel ends with EPERM while there
 * is still free address space above mmap_base.
 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

int main(int argc, char **argv)
{
	size_t size = argc > 1 ? strtoull(argv[1], NULL, 0) : 65536;
	unsigned long count = 0;

	for (;;) {
		void *p = mmap(NULL, size, PROT_READ | PROT_WRITE,
			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

		if (p != MAP_FAILED) {
			count++;
			continue;
		}
		if (errno == ENOMEM && size > 4096) {
			size /= 2;
			continue;
		}
		printf("mmap(%zu) failed after %lu mappings: %s (errno %d)\n",
		       size, count, strerror(errno), errno);
		return errno == EPERM;	/* exit status 1: bug present */
	}
}
--- end ---

Example output with vm.mmap_min_addr=65536, 6.1.y, x86-64 kernel:

  without the patch, 32-bit process:
    mmap(65536) failed after 63458 mappings: Operation not permitted (errno 1)
  without the patch, 64-bit process (./repro 1099511627776):
    mmap(32768) failed after 172 mappings: Operation not permitted (errno 1)
  with the patch, 32-bit process:
    mmap(4096) failed after 65513 mappings: Cannot allocate memory (errno 12)
  with the patch, 64-bit process:
    mmap(4096) failed after 184 mappings: Cannot allocate memory (errno 12)

The hugetlb paths can be exercised with a variant of the same loop: use
MAP_HUGETLB | MAP_NORESERVE (no huge pages need to be reserved), keep the
size a multiple of the huge page size and stop halving at the huge page
size, and set vm.mmap_min_addr (as root, before dropping privileges)
above the huge page size, for example to 256 MiB. Huge pages are
aligned, so with a smaller mmap_min_addr the search can never land below
it and the problem is not reachable.

Testing
=======

Every tree was built twice per architecture, without and with its patch,
and booted under QEMU (TCG) with a minimal initramfs. A process running
as uid 1000 was run three times per configuration (once on s390, where
a run takes about 17 million mmap() calls) with vm.mmap_min_addr=65536,
with 1 MiB on powerpc64 (64 KiB pages) and with 256 MiB for the hugetlb
runs. The results were identical for 6.1.y, 5.15.y and 5.10.y.

  kernel / process                           without patch   with patch
  ------------------------------------------------------------------------
  x86_64, 32-bit and 64-bit process          EPERM           ENOMEM
  x86_64, hugetlb, 64-bit process            EPERM           ENOMEM
  arm (multi_v7), 32-bit process             EPERM           ENOMEM
  mips (malta, big endian), 32-bit process   EPERM           ENOMEM
  sparc64, 32-bit process                    EPERM           ENOMEM
  sparc64, hugetlb, 32-bit process           EPERM           ENOMEM

  arm64, 64-bit and 32-bit (compat) process  ENOMEM          ENOMEM
  arm64, hugetlb (generic hugetlbfs path)    ENOMEM          ENOMEM
  s390                                       ENOMEM          ENOMEM
  powerpc64 hash (POWER8) and radix (POWER9) ENOMEM          ENOMEM
  powerpc64 radix, hugetlb                   ENOMEM          ENOMEM
  powerpc32                                  ENOMEM          ENOMEM

The arch/s390 files touched by the patch were compiled and linked on all
three trees.

Not covered: parisc, sh and loongarch were not run at all. hugetlb on
s390 and on powerpc64 with the hash MMU could not be run, because QEMU
does not provide a usable default huge page size for them. The
generic hugetlbfs hunk was exercised through arm64 only (where the
behaviour is unchanged, as that path already clamped locally).

 6.1.y:   4 files changed, 16 insertions(+), 9 deletions(-)
 5.15.y:  4 files changed, 13 insertions(+), 11 deletions(-)
 5.10.y:  4 files changed, 13 insertions(+), 11 deletions(-)

