Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC1F1125863
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD556B0005; Wed, 11 Mar 2026 14:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584406B0089; Wed, 11 Mar 2026 14:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4676B008A; Wed, 11 Mar 2026 14:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 379986B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:07:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF41C1B7468
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:07:46 +0000 (UTC)
X-FDA: 84534565332.24.C2437B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79B8C12000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:07:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWI5xc8O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773252465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mHHEpf4xMEnxESBzZwJGmT76Di+irV3NK87i5p9v0Vo=;
	b=v4iWJJXov+lk3rc/7lj4aKVg3EPVzaCTcilCamjH5n0QeZsuMopkRxu3cCgiuOde9iHnA7
	dZzlQ6WTGWjd+BqEvSU7uLxU52jyJw14lL5GfZMnbYMkqDv/qUBQnt2rF2gwmtTcfg9v/p
	xoOgbL0v4vlFvg2Z3Yeum047oDwJxgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773252465; a=rsa-sha256;
	cv=none;
	b=EIZaLbGqN3BeQQMDQdz+wFn0Qj+ZjZf8TCg/k+9N9V/wmxWvJa8ir+UyZWTUTm1BhRGxuh
	PSrAf1wQIfWW4LVhWRrEEO0z3jYjl321GL+0VmMUN20Y5/1B/E9PeBpLyPFV8TjCWo1Cqf
	rWpukH4+vlnZtFYAxVEi6ChnGy0Blu0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWI5xc8O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34FE641666;
	Wed, 11 Mar 2026 18:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8061CC4CEF7;
	Wed, 11 Mar 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773252464;
	bh=LVg+1lvKJvZpy5Jn2rGI2ajTj+jY1aenU8+n0G0hBG0=;
	h=From:To:Cc:Subject:Date:From;
	b=tWI5xc8OmuUIkHZObZgz9+hqm+Lx+y7uBP7qa4LZ9288hI355nukuolZRMYkNKSig
	 2IvToMWcNo9L39XR+y06bRRnn926fw28wlLPpyHvfUtetWzSZ489OkzOvydY0KSRup
	 ebhiSacHonBZgYvT5hIgb23MTuwi5xMRF9ge0GAIItD6lHqyxuicQo5OTq9wogOG0O
	 N+/0dwxIlAM1CDPEqkSzJbUYq05qtowrbM5pqaCvs4l79t1wymoV1D0zttJpvna8El
	 3pTLbgmKpC0tDV9jQs3aDU9hp6nyAqaPoUJoU40C2z1Qr5P9VoU9pBtAnjhsFasHUM
	 WBMsQZwARx6zg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] selftests/mm: pagemap_ioctl: remove hungarian notation
Date: Wed, 11 Mar 2026 20:07:37 +0200
Message-ID: <20260311180737.3767545-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79B8C12000D
X-Stat-Signature: bj797zqw8gecrg54hy3qtfca4ijwju3m
X-Rspam-User: 
X-HE-Tag: 1773252465-831866
X-HE-Meta: U2FsdGVkX1/wJYRalqTI9bS0oBy4UuUtpuSOdl9htAqyp8I24TOqyKhpm1Oy1Lzao3vyjcJmtVIURnV9W/L9aYQRcV4qsiaQFqKTxjkT+emn/NccwIrFtZmxpjbK7CFv84biu5zUUBeqZZ61cxJn0peyoRy7ACAigEszNcWICw5wQfdTJ5UgYO2Dw84ao6gnP00Ppmlf/Z7hzLf/gdmkbdq++4NFUoU4aRrItRz/m1vp4v3FGj/iPsWOetvK4jaNm4QVBUrtxK69ZBDw5KsEesKrMHphmdw0TEb482CwZUUiydJmfbWzXnUQX++D8AuufjuZA5lFsqMdVR+BTe2X5sRMrbMJTkHqOcBqfvgIQ9Z6SyaOvb+8bAkKv9kPWwConkLTgZHwiwWTpCuFtLpnghTCk/6/Ru8ajLTMQZglcTfnR6/bqPrKh6fkMB+ZbaMDocVec3za0K27j7E7x3nkwutncIFaegda9Vue1Dp0X6aX9JJA1RP24BAodTHl0jxJ1AuabyohCZe6tK47HwWrm4g4ALWLOGAV6QbT2+YLpVDA/qc1etnZeZD4bZ49OWsdQ3tTMW2+euPfhrJXCjuYKM1XuhvypyPqjZ+w0Vx6hfJxXxRTduxyMZYFL8ZFH3OPgH8cWn6uMXA8fLBkh5wJz4YmhbtR4294lu9g4vqxppIqOU623Vj2UBkWaPVzKXazooPci63KDQRHbLcEfYBwHyLyTdzPECgxu4T/hw1aP4ZTGorgq2B4f45GDC4mwiWr3TLRNfLZgTBXQTh6IVGSucBlnfK+CgzHM1CVZ5LcXnfTJLead9Eti7N+PdVGogfBtzNnS+1AkI91mj3X/zSFnn9Q0xUgyH+C5CMtfvBrfN5HSKJ/k2292e2cFEc55v/E8slfQaLip2rOcoYzQx1PifJiBQg/cytSpFZ6t53d0z3lxha8cwR/IOaxQwXEETsbNRpiakuWERmTYdv7rs+
 4+xbOURG
 1sx29A8Rxh1b0xr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Replace lpBaseAddress with addr and dwRegionSize with size.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 2ca8a7e3c27e..7f9428d6062c 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -113,13 +113,13 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *lpBaseAddress, long dwRegionSize)
+int wp_init(void *addr, long size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
 
-	uffdio_register.range.start = (unsigned long)lpBaseAddress;
-	uffdio_register.range.len = dwRegionSize;
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		ksft_exit_fail_msg("ioctl(UFFDIO_REGISTER) %d %s\n", errno, strerror(errno));
@@ -127,8 +127,8 @@ int wp_init(void *lpBaseAddress, long dwRegionSize)
 	if (!(uffdio_register.ioctls & UFFDIO_WRITEPROTECT))
 		ksft_exit_fail_msg("ioctl set is incorrect\n");
 
-	wp.range.start = (unsigned long)lpBaseAddress;
-	wp.range.len = dwRegionSize;
+	wp.range.start = (unsigned long)addr;
+	wp.range.len = size;
 	wp.mode = UFFDIO_WRITEPROTECT_MODE_WP;
 
 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &wp))
@@ -137,21 +137,21 @@ int wp_init(void *lpBaseAddress, long dwRegionSize)
 	return 0;
 }
 
-int wp_free(void *lpBaseAddress, long dwRegionSize)
+int wp_free(void *addr, long size)
 {
 	struct uffdio_register uffdio_register;
 
-	uffdio_register.range.start = (unsigned long)lpBaseAddress;
-	uffdio_register.range.len = dwRegionSize;
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
 		ksft_exit_fail_msg("ioctl unregister failure\n");
 	return 0;
 }
 
-int wp_addr_range(void *lpBaseAddress, int dwRegionSize)
+int wp_addr_range(void *addr, int size)
 {
-	if (pagemap_ioctl(lpBaseAddress, dwRegionSize, NULL, 0,
+	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN) < 0)
 		ksft_exit_fail_msg("error %d %d %s\n", 1, errno, strerror(errno));
-- 
2.51.0


