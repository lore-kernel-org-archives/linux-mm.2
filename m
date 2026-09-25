Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D504C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C296B0095; Fri, 25 Sep 2026 00:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD486B0096; Fri, 25 Sep 2026 00:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484CD6B0098; Fri, 25 Sep 2026 00:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14A0E6B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:29:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE1A4160550
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:29:23 +0000 (UTC)
X-FDA: 85251005406.11.AB7DD03
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1597F160008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:29:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BfAdA/IX";
	spf=pass (imf08.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790310562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LU0Go2cyRn/9B1ML6xI9lk2v8ECZiOmXK9suX3taLfI=;
	b=nod60V4w+sZbMCeYxc3YFaZcPCoqDFvn2cWfDuiBjaUuX+ryhqG0Rraat54hy95sTnMl2W
	fbeb1E7MzQRhIXl7NLNVx7SG7ygQ4OLD8nwd2nnA3o5HlApkVlhoK3NbnStr3rB8yjR9Zt
	nCkQw9UwkSVf9ANI5fNOP0Twdbu4bwI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BfAdA/IX";
	spf=pass (imf08.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790310562;
	b=ENipQrm2IhRYYudN+1a2uY1zDp7xL1ihRqG5gV6CS+KaBqXyuP+pVdVe4aL/eQ6Zszb64H
	65LPu8KqPKOfclWYBFoe1vY/27AEqQLQ5BbaqvSdGBfa3mA+URGZb2r5lCywvxdCLwTieJ
	e/6FeNVa58bBmc58Oajf2DJgL5sq/Bc=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2dd58e1e2c7so1835735ad.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790310561; x=1790915361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LU0Go2cyRn/9B1ML6xI9lk2v8ECZiOmXK9suX3taLfI=;
        b=BfAdA/IX9opqdiWnnR1QE5a7zf5JN2UE0ArsmVsNZQ1tS4jjtC/T6c0swHoa+O1Kxz
         roQcRsvIzCnHQSvZCsP+7Nu6ba3vyUbOzVXiLUwvFw4s2QCPEpeNKPy4lnLgLKtbPEwx
         zaD9oawqzih93iFSOuE3knTZnwgMmoGxw9Le6TlNX5pnI2Yi+7Gx/gaJK/STzgUuA0Y2
         ttun8nhIeE8SaaapieSzCGPEHWnK+rvamy2m0uZSCZ1ZXyAcEuMS5y59MmfHEFHuCxX+
         01ecmdHtw5fllUymP3dWQhOOePMmeCjISc8lqd280c5tMwKuVIl0RfxnGXU6ZDPlJ2Rr
         Nf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790310561; x=1790915361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LU0Go2cyRn/9B1ML6xI9lk2v8ECZiOmXK9suX3taLfI=;
        b=pEWtXoWX9yKJI33TPwa/sDysZQabEgvOkQB5zYGpBp1CYCFW+vC2BScs882/WcF2or
         2wW285ptE58E3q4m8I2I2qVBpiuaT4j3mCRyDeaNRAaEvJExiFGIBkIJjl/8MyGXq+gt
         a87/WNxjS1aChiuNp/fx36VRJKngMWVIcQmwl3tWpuosC5GDONl4NwO6TsQxhuZUASd5
         F2KpAoMmz9aOHiToFLiqZUZWZm/1+oQQhbXBT/xiUhhISzrJzsv0zJ0ZCh0yl/L1sZjd
         xQFyQ4JnXkCDzFOvjOJozHjUow6+QmLpVROCwTL+kbk5L/k5lMsHOTEXxrL3u7P/wkuY
         Nl4g==
X-Forwarded-Encrypted: i=1; AKwUvBwKkFo+5PRRyR8li0z1/x5qOkx5wrDYDqfqK3vhu8AXDNxZ9nic6RE+o3rWxaRI7zHmhSFR38w1sg==@kvack.org
X-Gm-Message-State: AFuF++mGvL+DCUNSfxCZzjhnL+ARhSYCOiA9TXHxQCENR+f7+DXtPTe1
	Iomv68cEJQ77wdFQuPqwDz12L4ePzLdDD9iG6b5kW/fxLWgpic6hAS4=
X-Gm-Gg: AYBFou37uSwtulL04yR9TmbjHAxCz1zoxn8VyQMjPaz4FbMzDa5+Ngxr4XJARDA3KkI
	bN+WMp7onYrD9EgBPVdMk/i+CeH9o2DSkEfQ0CMOazYuFu8oMyUuFIeFeqjlqctCG/aDzx/dAph
	OYHHcdL+U6lRZUlVtn+D6HMY08o59eDoF8HUUsDKHxUbfTNGHTjzqHHxm2uF0Ls5/z5GZVoJ599
	c2ZX08JWrg6aOErpY8DyEJWoPHIaPkivyOqFpBPxU+B0MLenwxXqQ0dKMcLr51Z2PEkSMDJ5im3
	fu/I/vSrgSKc5Vmh1ykjAZ6qWDx0hC8g6rljEt9ls0Q0fWa2QuCe7v0DyF7NT6zZsHl3FjcvH4F
	q9vW7MpBm+bMVDXyRY/1QjknJCUHPnyPXU7R0OvRtBPZDKqO3+2kGXtX4yIEDXS43f/lNsf15lT
	XFiC89rS6rxJLSydQZM8G//sSI54IprsRgG3z5SLkoIGokMpNS0QHg1KqK0Do39FcsGIVJzzMzJ
	TQvtrw/qnX2Jh+brvJtnUTg
X-Received: by 2002:a17:902:d484:b0:2dd:c100:b2d0 with SMTP id d9443c01a7336-2df7dd77d96mr38107475ad.59.1790310560808;
        Thu, 24 Sep 2026 21:29:20 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9525cd53sm2499125ad.38.2026.09.24.21.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 21:29:20 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v2 2/2] selftests/mm: add a test for UFFDIO_MOVE of a write-protected swap entry
Date: Fri, 25 Sep 2026 13:29:07 +0900
Message-ID: <20260925042907.2330519-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1597F160008
X-Stat-Signature: whh1azhaya9wxorw6o1uf4k6axduuecz
X-HE-Tag: 1790310561-771701
X-HE-Meta: U2FsdGVkX1/p0FuHE7nJTgHfq7FJAJHH+vSoh3A4pirurcYeXN4ukJjFl9HK0s+ETzch1lbI8N49hjNF7t+RwbC8k+/JFMfgNGKHWUXf9HdWzRVmrAlCX6//oFfuPWJwivaUAbXOwgYUY4Q+QYqUiyLQ5d5alA9GK/5G+L8HJMCk+d0p2/6zjKaKXG73bBKkqQb1r7WVPKXLHVw4kjfzK+XxrgJTSr7Q+LHtxp4DkaqK+XffaYojF6FSls5O+9VWMtQe2gFf3aWXzvotvUXqqBC23EXHV2DCDBViXTCZQu7BVF25d4ebJqxnVnb0kpKqqMD0BPF+92tYKWJ1kEEkk/tNDAoppkdrsOtH9OvoP1uW7HqRU9EaAwWXD13v1icxd1Lvlk/nG7NnLZQovWZHvDe86UqKRc+C4Kgnn7MzicXENwYygmtHiQofu2i88tAhpKQJai0aYq8/8R6N25ExFMmlhP50bYev6iG2vbjC2ysHhTuokrugka3uNQ9+eJUT4m7KrIS/6DJgrw/wxuWetnrou7dj3Tr6lrfq3KShAVxaCzgOduA1gz34oloZkW5OWv0DLrEjF1UNUJhYMY+4VyOqVbLI59j6L/W9qReDlC878FtXbiS2+v9hbas6Vn2Fj1WAJtGUzzZ0CTCJUplVR29vrTn3dzyZY7xsBuKLQ//KXth3DVkvmW9qw3zPFtFA93FnSMjKEipHsEZ5y+USM+c7pQ7bR5WlLoIhWKNewBKaXCu9F8yw78Nb4IafkJB0vyRWKwuFdnMvfbycbnpnQ3hTJDL2hQjjZfNsrdYawcDle2VvCCcBCrsr23RayHumzdb/Eo4mayj53AF9G8DUZLJy3dEzCvy+4cVHPC0tzwfoBj8RPvQRNrDneGjoU47V5VD05wGtJoL4RlYUrBX9jL8ATqb8a/JB51LXIJ67K1p8H4R2qlaojozbY8tSash0Ovnsi5U76esYyEkgA36
 R9RgBIcz
 3HISYuOmKRJ5A51mmXonYTaWSnOZra1yDgIsT1eNXJbbC0S+c3mWW1X16v2kuTWgzL9vA3mbdhv1ys3j4//+LNzMMVKcybeob3YP5pNGusm6D7vN4iQlqT/DJpRGgQIshZfH4RbkqEgBAKqc9XHYsL2TOAjmcLemiyenNRRvLk4XVEJq7vszREllwWw+xAmh8mbSiz/lzKoKtnhDUpDULsTW4UK8hbeYfsmWsUeYNqRzfVo/giOWkTdxvqgL7gIbu5D9O78eY3wpIGjA+H/g1y0sn9RnBr6wOl+xa96F5zKl0mCwaM9mtVyRoSAdmXZJln+wr+xUNqJi6pe91dUO+KWZgVvwPY8g4uIS59HvEzKHyGmoKZGkWatojSk/EAhrNmMnkOz+ZsNx38ch0psvR5QKowPJTYvphPno5U/w+VidUhN2bl1qMCz0PKIjAmFFQWb4/clKFrZm3lVX/xxAdde2KktkTNEbyn//lz1Zt56kaH1BTGSlyBchW4MFK24CNw4tXsLqaZYv+pu10qMBuWnRd0luAFMqJ/uC4/TwvQ5VWiCsInd14kHOC3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move a swapped-out page out of a write-protected area into a destination
registered for missing faults only, and read pagemap bit 57 at the
destination.  The destination was never write-protected, so the bit must
be clear.

Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 61 ++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index ef9b3956bdcfd..ae8b718f0a278 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2037,6 +2037,59 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
 			      uffd_move_pmd_handle_fault);
 }
 
+/*
+ * Moving a swapped-out page out of a write-protected area must not carry the
+ * uffd-wp bit into a destination that is not write-protect registered: such a
+ * bit is never cleared afterwards, so pagemap keeps reporting the page as
+ * uffd-tracked.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *targs)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_move move = { };
+	int pagemap_fd, i;
+
+	if (uffd_register(gopts->uffd, gopts->area_src, page_size,
+			  false, true, false))
+		err("register src failure");
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  true, false, false))
+		err("register dst failure");
+
+	wp_range(gopts->uffd, (unsigned long)gopts->area_src, page_size, true);
+
+	pagemap_fd = pagemap_open();
+	for (i = 0; i < 100; i++) {
+		if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
+			err("MADV_PAGEOUT");
+		if (pagemap_is_swapped(pagemap_fd, gopts->area_src))
+			break;
+		usleep(10000);
+	}
+	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
+		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
+		goto out;
+	}
+
+	move.dst = (unsigned long)gopts->area_dst;
+	move.src = (unsigned long)gopts->area_src;
+	move.len = page_size;
+	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move))
+		err("UFFDIO_MOVE");
+
+	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
+		uffd_test_fail("uffd-wp bit moved into an area that is not write-protected");
+	else
+		uffd_test_pass();
+out:
+	close(pagemap_fd);
+	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
+	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+}
+
 static bool
 uffdio_verify_results(const char *name, int ret, int error, long result)
 {
@@ -2359,6 +2412,14 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
+	{
+		.name = "move-swap-wp",
+		.uffd_fn = uffd_move_swap_wp_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
 	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
-- 
2.53.0


