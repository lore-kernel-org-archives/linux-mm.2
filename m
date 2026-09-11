Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EEFC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F456B008A; Fri, 11 Sep 2026 08:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0ED66B008C; Fri, 11 Sep 2026 08:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24FB6B0092; Fri, 11 Sep 2026 08:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB5E6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:45:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E948401E2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:45:34 +0000 (UTC)
X-FDA: 85201452588.08.3DF29FD
Received: from mail-wr2-f11.google.com (mail-wr2-f11.google.com [74.125.225.75])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9349A10000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:45:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KJI7gjO8;
	spf=pass (imf05.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.75 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789130732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=stX4u/q9+UX8srql6LxNnbXBhPlMhXVPibUjinvI7Fc=;
	b=CnSqd7jJoWCmhZQA3Hc+iz4bBg9pxeWO+H44rm++bkLvMb6AI6UxtsNW8qeHqEs+cEHR+i
	2MD0hYT6NIcLvkaMtJ1oUXYM4XTBG5VTOgclnzsfB+fbTAW9dG0xtf6YYSYQJ7sMJ/V4F2
	YR9scBjKdJekSZMRtsvMGw01QrauSNE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KJI7gjO8;
	spf=pass (imf05.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.75 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789130732;
	b=B4Kevls/01oqbntQgROR4bAwo4d+oF8WH68cUZSAJR8OzwKajKxPAW6XypZI/84TiEeC5Z
	zSiAMCvG6fOMynXaEi0L01xMZ9CxBZoW/6gWP76jrAxu8KPEpvune0fxcovHmk6aMkB6Vs
	VCRjSEmSzwk9A02XWIhPOduBF2BQH+E=
Received: by mail-wr2-f11.google.com with SMTP id ffacd0b85a97d-48351e5bb47so250716f8f.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789130731; x=1789735531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=stX4u/q9+UX8srql6LxNnbXBhPlMhXVPibUjinvI7Fc=;
        b=KJI7gjO8E9nGLmnN69was4+RkXpx7q3GLA31I/e2OVG+ZTUxO9S7Kk1I5UzxH43KMf
         F/9l28m9XAWUK3KErEwr7Z+4FMkKRlXk0o/+ft9k7w8C6iR+ymeEHv7AQX8M0D50pxhd
         BNHt3kN320Xtf/DweXwMQqPTQXMKfWHfJyfESCdnbtXSaJdVBmElWZ5QnMEiINwastRH
         s+r6QLzfAw0DbpQufMO81YmrqIa/LmKKlPvBVC5g3kFtb7ePljzFHwywCHg6fBi7zDeS
         qPY11kluo9Lfx+HpMDZg1VDTRBwtApB9cjS8wx8GHGIDkVlL5u4DtN5uatm15BL27clH
         atFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789130731; x=1789735531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=stX4u/q9+UX8srql6LxNnbXBhPlMhXVPibUjinvI7Fc=;
        b=TmvkVC95uTATYMsApYE7gbOC/AaOlKQxf9OxeBf/RflsuajGpqN7R5WjkMGITWW/2h
         WnmfhlsXlSL7VU+l4alSXt2sDMgFnQy+cV6geMaBkLswLUR9DGsqBoEpZfDALnIh/kTY
         e07SZpxWLYX0+QhV9v1kzIUbTTFgm14zr+l5PUu9Y0T6q0Hi5eDMC47QYCQD3GODAJpl
         x4/H/lIqp7wxYhCL7qrilQGoRvrOu3q4NqpYvt9zfKVliSKco1WYjBzwg5VOORJeRRaC
         7se+gB0SdwZbvoOSf72XAFAMD9GO1lw7ax3yIVBZ52fQXNgn7EGgZiQGgJ7NPhqAffhv
         UqNA==
X-Forwarded-Encrypted: i=1; AKwUvByOcxy0T54M37XjVTepeR0fYQh8/90yqGSO8SDbIzKcn/V/zsp/t2ey4cD95V02E8F9ZaIoK0ROGA==@kvack.org
X-Gm-Message-State: AFuF++nssGGXfN8EnmB1evTCuGSIm7XLaQ+iUiV9LLbuo+83J8Iha0ne
	9nShPSBWFS2h7+1HEDlpnJiqGmQ5ZW2saO6TFPscpwZLfIxtfDJyXT/2
X-Gm-Gg: AYBFou3VyH0aMwBlcWMcLxBrv4DyLJJHh7vdC1r5JvBpHWKEUoB8A5DriQuUSeMhbt1
	VgJ+9mLm/hfGjaTjWnXDLmBWKmXyyj7ZjW1DiugXNXWj9xgVw2SMU513osSUFo46hiv35Zh3WGr
	JyvaYpVsnz89GKUaf38f8w6xaanvhHk0xT8NZNNPqGcvFKFd5lcbRV+AmxufqfP8wPtSGmh2aML
	DLUp/KrCWXyphlFEY75aPk7b0XdQe1NKvXgfNGI5kowHxqZLoyW1ez5ONK74uLe54Fy8Rq7Mn8N
	cxYpvcxwLFR3lcBwvLiiIDxXicbceveWeywi8AU93ejVbcozRd6hTeLpD+szCmanodft/vnB5iv
	KmzWNHakbCtkGyzDNYayvnK132kwN42M1pRVSSZB6MF57ivA84/FVMgk4vZ/VaGA3gxve/HdOh6
	+PIcKGvWbOCK4eX7AcuRWAGuk4wYM4QMzGt17vtzhuaFURm88v5Kjh58lNUsqf74EPmCA2Li1of
	ZCrhJHTWMjwkvfTjRake8+NMCgjVDd/VgiKoqT3pTiUX/oglZNyLRpFwBCbfVna
X-Received: by 2002:a5d:68c9:0:b0:484:3310:710d with SMTP id ffacd0b85a97d-486eb3529admr7227286f8f.25.1789130730835;
        Fri, 11 Sep 2026 05:45:30 -0700 (PDT)
Received: from jaeyeonlee.eduroam.tuwien.ac.at ([2001:629:3800:12:5380:8eae:5873:65c8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb357288sm5902298f8f.29.2026.09.11.05.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 05:45:30 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: akpm@linux-foundation.org,
	shuah@kernel.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: [PATCH] selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
Date: Fri, 11 Sep 2026 14:45:17 +0200
Message-ID: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9349A10000D
X-Stat-Signature: 9zqa91dohk1izjaz9wcg8zr4nczjkq43
X-Rspam-User: 
X-HE-Tag: 1789130732-47093
X-HE-Meta: U2FsdGVkX1+ZD6blRVbxrsplLDV845/7MSPO2OVioxqd1Sbhy3KfOk5endg6pOu6Hu3tGq7he8O7wWQz9dzJ8SikB1dSdhyaC5SIRAa24NYR1oJE7unaiwsZajRm50ryAafp5/j5YWczpDKuMT2s416DKPry6haItmQk4zOTQKjEJJbEP0HxutYame6c931Odhna/dZWl5okUd9yw2zJMidWTKJOa+d3q8kDsuT9+0PNy0JpYkYHq1HnYMTRnZ+BbKVd5RXVjcCAIfLrKVZ3d86HSrq+ZxsW496btHq3MUuQzTEJtnFidgcs46j8qOVVh854Hqw9LXSyWxwXlf8yHkXxL1rH6fHLwsz2xI4AYR9Fgq6dEQ6SLBLpJu+Rj3OdiSJT4mnvVrKsiJ4FbfTMTj/LDzmv7DnW2vKvHHo1xV45hD9MiHwjyCeq3hRqmNDjSxjpl7u3q90cK+k9YTvtcLuwmt1e8XET2KXAefgRQkY855YBX5I2jtH8R/vA47BfowAVcPaTM1qQWD6lX3uKmWtbwXtBDzcey3oC3FelxYrhIsjcsw9R6NAqllQA1CoImoeg/FYK7kdxtjjnnxrfj0Vmj2pJIIFnMpFC2zy2x9Uv432DG7NOS45OwycDE/672TLqhjEkfeh9olL9FxQV1/vfdUJdrfIlYK8u28hLyXrFzZI0yIO8qSRbXv83Gmwg/0hy60/jYj26sU8BfABFEnABEZzCqj0vcH1y2qFKE2dJjpNuj9vpu8js7oq2TfZRuL4EugCL2orAJyC5yV5ecZaZkbY5gzHBrURuXyePCHzm2q6w+hFeBD8/i3KF90kHH9jp8zFPYfupF1pBn/wtf4YLfNp7CAwbZJGyQYJqMS7CzwjDubtRif40lzjoFj4pzXtU2w3sRG5IuvpN0JUiJrasmOqs1TGo5H12LSHPR7g7DZILgdDJMVfjqE3zkgSUYxDHa33bAInMQxvcMOM
 F/YxEJWE
 tLFQ+ZRDpntFe5/wZy4u0OrBcYEoYJtKCFZ6t/ooJP20H4R4wXn+l0n+EfQUGq6PkbG7JSG2LvdpvfjbpYFT4ZG4TTNTk9FRfXYCZXxFT81AyWluUeZrMS6PU9UT3nHd4CEEdhEkZ4TAbtAY8QE7lB4txKhAwWbeTFF7dZYzntGzJvcLMFbDHUskcYcU2H5BRVanXhzJTuUrD82kObploLSNV83bW/jfW4dlFY5dRqzlVdXBcR8j4SpxuGe2IPKamGZ2Ip+JBd3Q8V9SMMC1vpr24fEWIjA0dxGDAjzQACkzElUVBXKNk8yF80XXnJQelACoawMnMU4aaIXnCRUMeFtPglaK526A3ja9FFMV3e4q3FhOQ2I7pWEykym2cMdcbcBKaNRz4n5Zv/UyX/KZlvCwssD9pyX3DyRgGdmPMyNoWunNzaqiO443s8azxvCeIw6cICNjfowYHw8Zuq9w6IfaFZwm+GouKHH+drH1vl+1Ny8VfGuvOyp1mhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The XFS setup for ./khugepaged all:file checks that the kernel supports
XFS but not that mkfs.xfs is installed. When CONFIG_XFS_FS=y and
xfsprogs is missing, mkfs.xfs and mount both fail, but
SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set.
The test then runs against plain tmpfs and six subtests fail.

The script already has a skip path for this test, but it never runs
because the path variable is always set. Check that mkfs.xfs exists
before attempting the XFS setup.

Assisted-by: claude.ai:claude-opus-5
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..6315b67b6733 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -415,7 +415,8 @@ CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-	if grep xfs /proc/filesystems &>/dev/null; then
+	if grep xfs /proc/filesystems &>/dev/null &&
+	   command -v mkfs.xfs &>/dev/null; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
 	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}
-- 
2.43.0


