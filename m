Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80627606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 04:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZiFfe4M
Received: by kanga.kvack.org (Postfix)
	id 6EA2F6B00EF; Fri, 30 Oct 2026 00:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BA86B05B1; Fri, 30 Oct 2026 00:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B16A6B05B2; Fri, 30 Oct 2026 00:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6986B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:46:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44A151A0479
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:46:54 +0000 (UTC)
X-FDA: 85378057548.15.FDD8ED8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B244040005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:46:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZiFfe4M;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793335612;
	b=yCWlXNAsFH2/kdu4SLHm42C+CWgREe5mT85uSw9FTvklxPinP2AAoFS8GV4zuOWw7z34Jy
	eQUw0uyCY/rxgJhLii6pkmQlek9zOgDNmyna9ZJSBh85T6uQjwGF1IZMi6nchGIbwkLzDG
	z0+UrCznqHYhvt67kLJQDRUOd+3dz6I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZiFfe4M;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793335612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DZp5otDluq4NV2cKmLa7Nu+U3zJLkg4HxbRo5oi+i0M=;
	b=nQmI5ZewoRlDdMw/6AAnGhKEUroDqPSROwqkYh40afd3NZnazUKIuNry1dI/lBWnefexSV
	8ix+xiCQCp5O+V/2foEuMjmC46i8Vj4ZNtQzh+VYe8kELv6mOOCehpJ0xhvdyj4dTjKd0F
	1iksnHHJQQSq4hvBWIzxLYG0j4tvUAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B9E9432B1;
	Fri, 30 Oct 2026 04:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4731F000C1;
	Fri, 30 Oct 2026 04:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793335611;
	bh=DZp5otDluq4NV2cKmLa7Nu+U3zJLkg4HxbRo5oi+i0M=;
	h=From:To:Cc:Subject:Date;
	b=MZiFfe4MaqqgRmB0M8Sok3Bxfg3CbjxRydYTFp7y5XUzPe6DLkiZJUwTknZefJSPr
	 saZ96LltFBZ124M/oaiB6gcCOLBs4HUO8MYUPaTLrIB3kko2dfCuC0gjv/BITeMs5A
	 YuKUu69lrKKDpVxInh/TNuYHDscjoLNibIOKlLJU/pK5o7IZu816Jv4IUGx77+a3lT
	 YMG+qNzOlzINkS7X3PdbZntrmEkkObPHfsWatqZd8MSd+BNcQhokZBWcWIReTo0RSL
	 RtSh0qwJfgt89xutqRh6vxGG86kdvQDqg7CaQZ4AUT97K+EIM7K+1YGlzEkQPymJ/W
	 4E8AZY78E4LZQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] selftests/damon/sysfs_memcg_path_leak: define ksft_skip
Date: Thu, 29 Oct 2026 21:46:42 -0700
Message-ID: <20261030044643.157105-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B244040005
X-Stat-Signature: doqxfc3w54ph5411d61zmqfnpnjyk9xy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793335612-431581
X-HE-Meta: U2FsdGVkX1/0k5PwkgRVK+JfvUbaFX/Va8lO/N9IytKYweq5FfRJ35BulNMLpYBcDQvl0IrGSPWgywKr63T3X3bcqbnwPHtOUWVKuyVVKJjuGTGNU+rR6gkb6HdgmT03tZdUvOvdFgQr6R9bnE01I+8DUb0v1s67hVdV4hZsxMHmdmvHY7UyL1x2KjGlRI9KL6zKn0zKAe7xtSfwIW2HyQhYXXkhIF3mIF/qc8fmUWgPuNyQJO+9p4SIVnsUmb4ehwJ4mFOhI50R15tUw1XCnzP8VAYiTMtcNx/2yHBDPBx65r8DbLXS+QqGALRaD5uMYn6btSymlGpGPc3d+WVsm24rJY1vUzQke++6BK8FATh5/s4jgYtJB6KXjGsnuFalHX7Zr/2onIgzfTmk+ByWGwf8P/XVBPIWDObH+3oJ6/IY8iWBOjbLHGTBBjY5nI2s/lBaJTqTHZc8jaXg1CKVN4Uf3UT1wdwlUZfJ/w/VH3E8fyglA145RJ+mIq380L0ElBw/BGeMMInzG5vxBdyX+B+IUhqt9mDsUFezLxm6NaTAwLQSF0MWY9+gFR1vC/h+7IutsKCte/7jWXFhjMVgcWu6XR/+2aYHdCmBLZIYdOq6fxhZVGEM/P8q7lL8j+vbEq9N/afpvJcdyQgYC+g+sHO5wwWTFKqWtUepMOFcXqgXga+ud0O7u088vmxt8gBONZaEzZxk9IapMwQAcRdMAFU/TkL/Vp1MUPsc6nyuK12rKQ0s03EZEshcFuYabbv7vdr4XkdcdhhvbEOnFfDf3q1CBJUz+4b5CahGA5U7c05eo0G9Xqf781WwKDHaEdQIToMpSZiFOLplFOuDsVPIUQFOE4u++DVUUi4n0f08Q7Aqip4GMxap9GXY45lshnqv6vmkkSsTsAVoWroReYU6+sauZrbR8FpHcoclJZ8shH++MC0cJh6EkWRdrT9zV02+Ay9ATDpXVUwxMcUIyoo
 sJnj/KlE
 kOAvj6DWRkisr2R4OZUJFFzNJ+WsklF1+lDKJ4gZJUXVzVrjEHybf5n7uluV3gVtFieZC71axiHYS0L8kHVIxTarmvzWLQ12gK4na8yG3bI6g4hRIKNDhNO+Vs0euP4fZKlIS3FtS5JA+HIv5N8NpaSr61u+iEeSu63RKmbQZLX32PRwE5BFnwEebT9WWqHNgwr6BUD56GbGGqnTMIoIpQG4Fg6MxzZ+CiIb1uD75UcJ+8Cm8hXmTuXUbiMSoTV3bndqMyy+25tmVqDO30o12/LJGvxDjfSoqVSnZujD807HbVu8QHi5697M9nQt572WOc95F90lT/oFY1Vfn+ya3HpWNCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysfs_memcg_path_leak test uses $ksft_skip without defining it.  As a
result, the test is marked as passed while it was skipped, like below.

    $ ./sysfs_memcg_path_leak.sh
    Run as root
    $ echo $?
    0

Users who run the test could therefore wrongly believe the test was run
and passed while it was skipped.

Define the value at the beginning of the test.  After this patch, the
exit code reflects the skip.

    $ ./sysfs_memcg_path_leak.sh
    Run as root
    $ echo $?
    4

Fixes: dfa3cf0bc018 ("selftets/damon: add a test for memcg_path leak")
Cc: <stable@vger.kernel.org> # 6.17.x
Closes: https://sashiko.dev/#/bug/linux-a0456336-0608-4fec-ac22-0ee61d1d6a91
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
index 34c37129c49fe..d407dddb879ec 100755
--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
+++ b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 if [ $EUID -ne 0 ]
 then
 	echo "Run as root"

base-commit: 20b1ca206f8a664a16ad3006262c63b5d37b1ecc
-- 
2.47.3

