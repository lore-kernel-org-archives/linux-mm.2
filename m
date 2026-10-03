Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24223CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 10:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEE06B0095; Sat,  3 Oct 2026 06:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FDD6B0096; Sat,  3 Oct 2026 06:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EA16B0098; Sat,  3 Oct 2026 06:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE9F26B0095
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:30:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4A2CA79DB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:45 +0000 (UTC)
X-FDA: 85280946450.22.D89C7D6
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1098A120004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B9ELjvqk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791023444;
	b=zn2CCBkVQzUEa3V6pD0VFVQ2CYAKGmemtmFemsuDDJRXkrqjhk+P19qMq9xcaYcjzF0RMy
	+CLlf33jqdk8ht4WdGp/g8G8nUsdQsjNNuBLX0xuX/5msR3vVT8HCgUOI7satG/kqa5sCI
	l3PrfuINOkjQnANwyQI5WodsPg49LEw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B9ELjvqk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791023444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrMFpIv7WRJdTe5fhZ+AXxpLaL+kTtS4G30LmhtwQyM=;
	b=qTPCUxMBzy/5rsCQ/+jMn0PtPN0Olml2h3lNdlSdgPoV9u6fU/eA+IP3CMM69/CVjoXSK6
	dWoky/VdGUCFqg1ac3+FtzC6d56fpVn0A/dzMeiXBB0CPN3qrCY5UaCEvyRXKoCm+gfgUQ
	kp8P+oxpsn2IlyL/BOSlB5eLRbe6n90=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so163587a91.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 03:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791023443; x=1791628243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vrMFpIv7WRJdTe5fhZ+AXxpLaL+kTtS4G30LmhtwQyM=;
        b=B9ELjvqkVh77/b35SlAGp9VmGagHBwvwHgjM1KPWIEH0QpIZFHzsl7c8LqQz+xRB2M
         vBSHpua1x1fkC10+uCCRpwvBNDBIQ2rTPX6NA71QgU+n34VucqGenrBmKjgHdXtiYUwl
         YZO5tdOWdudYKrsNIeJUxhxIc3X2MSmRSqhsw0+08ZsC7LhZ2TsS+L36aICj13c+nEex
         +qXZv67xQ4X/5SHGLJhd0TD9rq6AH5xSSXXF4uWbsPa9zFpdKmh71wyvswSKe5UCmWzx
         kFItrqU/SnLU7P3lMwtSiRD6YcxZpTWOQ1cwKbHoG4O4/NyiDvFxjJcCkUwAeTWxIYbS
         6D2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791023443; x=1791628243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vrMFpIv7WRJdTe5fhZ+AXxpLaL+kTtS4G30LmhtwQyM=;
        b=I3wL1l+jXCrUgjsHOjs0dP5qs7WtAkX1KV3haqSImihcICXNSsPlvGT+zCTS2VD67B
         NW8LnB6AcO4PTviV6AR1sEvdJ4yehqekS/SMOXZy36Dj6wRPSDn2hrRht5XgGlxarars
         G8h6rqms3RErhlXxQOEzsODPv2VBlfMaKZbz6ftA3SuSLT+upOPsV94jXwbKhVhSBcvV
         A6ZFZpUZ6usQbD+WdItdYib1Wk6K5QeNp665/LXWVVxR9zJ4Z65iNvB+CwvD70SC6asm
         WNhyUnXLgekKFu1Shx2nNx9I9L7cDTL3v7GSDlZYEmIB+Icp8N1H0lLXTOVtfTPTxGNM
         c6SQ==
X-Forwarded-Encrypted: i=1; AKwUvBzxSWgN8qcEhQJgCsM0iEn5bS1OeOV4tRwGnWgXVy3PMGmn4qd17b3ue1P1pODbMAV22jO5ZMUTyQ==@kvack.org
X-Gm-Message-State: AFq9FYJ/htrDSsjNk3QuPaaeJpOw0Fqw7I1MbsZn3ePzBkL2ZAwY61Kq
	uBCz0wZH1Ba05egnSA72uPJ5bcVnho+0elQovQrWtdQHiCQiYgWPSTs=
X-Gm-Gg: AYBFou2RHME2ouT+zXyQEJfVq0AhxFzQRBtvw9TJTV1rUCMxNXf9uUWTEN2W0dXvI49
	tsNvHawvh9HQUtLed6oQLSt0Q4+N/XwtJRH4imuW/I7r6I9BOZU/H9hA5jdsT9LAsbqmjdgJKZD
	KptGAOd9rXB6gHlnm1sk77qH72/o5FH7lYy5T0273mQIn4SupUneLuyTSodqUDtUEPQ75kQLt/D
	lJtEq+62ZNGR9UjdsUQIlWJSgY59NF4thEm+zh0o0mZ2ccLa+I+V17eSAv273pqivyljJvgBWwl
	m33aXao7LO1lyHf2njxaZS919N2jCrFsV3zJbnnCc/I3Bz7w949rLsE6H1B29Jh+PQ4yAs6aTQS
	862wUYV0TNNnE0++hQp5Rlacx5DcIbCoLAHsHJRAfuVS+JbUyBTLwfQbvOS0kho5jM2fQ5a2BwU
	a/U8GJyBB1CvZyqNk8HY+gc86iK4/l4GgzU3v707aYUTFWCGVE4mr7KYngZqQCiYW3hYbOCQ+/r
	30WSwmIBN3ltWgXk5HhTAxU
X-Received: by 2002:a17:90a:ec86:b0:3a0:d75c:239f with SMTP id 98e67ed59e1d1-3a78717d98dmr1420413a91.11.1791023442881;
        Sat, 03 Oct 2026 03:30:42 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a709a4e80bsm2121961a91.4.2026.10.03.03.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 03:30:42 -0700 (PDT)
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
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v4 2/2] selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry
Date: Sat,  3 Oct 2026 19:30:30 +0900
Message-ID: <20261003103030.63380-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
References: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ai9tuidazt1r7ysqy1caah9f6ykzu76q
X-Rspam-User: 
X-Rspamd-Queue-Id: 1098A120004
X-HE-Tag: 1791023443-512496
X-HE-Meta: U2FsdGVkX18s8MbBbcd1EKGGN/odePv8SUwfJME2dJaGMEzmKgqQ7bsDR3PIgghBW+c2F072MUqRFhbLwQRT04Ct/0L1InkWsL2bHLv1KgMpXQzdAqyFHxO+SYowTLxz0vTrFZDveFympeMT9zAjjHmwQFKijBRRf5skgtiA2aE+hWtbhqcGvfEsrRYSbAdEGbQkohN94L9gEC+62aE6K1S2/32ewD4i4lrm/LAyXvH5O2bKaUyBVO3axKfzIkB7zAHyJ9iLJIxbDHlj0Y+5P0LS6L50qhqt+M9VduBPhDlvQ5sowGWLFFhKmH4m6Mfsgpw2ABSDmYW0JygRKgb4XdINskHyZ7w1VCnn2BJSJ3Qrcqjh2pR+11DSf/EaAJTnb+m4kyvgfOFY6IhwiB+ewoijnnj26dYC4zIJNbe32qty9s3bNypTct2K3yPCqRQj/BV0Z4vIC4tEmgBXDjjvDNkSbYROG3B2yk+BLQOl4mod/2+HdX3+iEgjqd1UxfyVN9rjSQ6Ck9UF2t4MEAI4mUJz/+1+WJ4gEF6SdszuLMocXmBmoie9yUMTqDnQVUYmtJ3ynsC6ddtJYmtN3hiZbAWSiIRjWJoInC9mQgwd1eaPPp+yABJHhFpejt6rtgx9dj1WoOnTcjNIN+W9JMSW06kZfJXcYLxUOs39Xn3deMb8bIVf9PCJTN6Cux2FD2Gu6u922A5YTvgzRUgf49mXnxzLjsG3EU7lHDqTp+xMXw+lOs5ryUwFrBrRKfIB2DEQAC/skStF2iakkQ4bTIXEao9KJvmQ+PN22blqVGHJHnXUy5ycPeaCZn/J5HDDlOIrFHKjk2nt16BQJRh6WgiOX9uKkJroZHLs/9jJJdhuD9klnlugyni3fY5N8F2NrzdvsKBbzZRuZk2T4kXD9IeaSW9ZBHwi+OFpaCr2/nYDKeU/ao4yUGVu2yRsocWMxKkIXZwVmPXPxaN8exJ0AE/
 b1Rw40lB
 Fcp1DlGzlVgX4pUxizUrlg4PEg9FccTfpkAyJCmsJ3NkP311eUYCHPkagXAOU9zUTTc7C18c2gH8c0BipZsw3RT0DJvLIPovxN046wH0Igiws6LQ2MhBI+pjWnTiWYHCnpw+aCvJUovwO2Y4lQhsmA1LNIfd5yDezuoZqjhkA6QCf37r1diaUIgIeQpEMiAJO0UXwxU6Vy55jSuD0/eYUcQVjddp7AC1J337Gw2KeavYmcN6WvZQolTsbMegEI8H9t3NktvM5kLBGJ1Laf89l3i1naeQDFP88ufCcbKfG/nBs8StI9hyD+77lvOVXT2cOHLcth160snD96iog+Lx098NS7dTaWvRWbvABHjinaH/YwSg9JC8R9fydtZlQeyFAHCENI4aIYAb6bpEZyf2GRjDWnHuCKn+mMfQdxdx+OQ71Rq6WNLPSQRZdBulJ2cFRyQwgyA5RL766ecePuADtcAp+yEoS8QdtpiOwKZeuYLRipqw/hPTXYJWLKDeOdzf0xe8RHHNV0sSzeY8LGt2I7R8/A4J4GJJTu2/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move a swapped-out page out of a write-protected or RWP-protected area into
a destination registered for missing faults only, and read pagemap bit 57
at the destination.  The destination was never protected, so the bit must
be clear.

Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index ef9b3956bdcfd..97484c82f24e1 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2037,6 +2037,75 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
 			      uffd_move_pmd_handle_fault);
 }
 
+/*
+ * Moving a swapped-out page out of a write-protected or RWP-protected area
+ * must not carry the uffd bit into a destination registered for missing
+ * faults only: such a bit is never cleared afterwards, so pagemap keeps
+ * reporting the page as uffd-tracked.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_move_swap_test_common(uffd_global_test_opts_t *gopts,
+				       bool rwp)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_move move = {
+		.dst = (unsigned long)gopts->area_dst,
+		.src = (unsigned long)gopts->area_src,
+		.len = page_size,
+	};
+	int pagemap_fd = pagemap_open();
+
+	if (rwp) {
+		if (uffd_register_rwp(gopts->uffd, gopts->area_src, page_size))
+			err("register src failure");
+		rwprotect_range(gopts->uffd, (unsigned long)gopts->area_src,
+				page_size, true);
+	} else {
+		if (uffd_register(gopts->uffd, gopts->area_src, page_size,
+				  false, true, false))
+			err("register src failure");
+		wp_range(gopts->uffd, (unsigned long)gopts->area_src,
+			 page_size, true);
+	}
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  true, false, false))
+		err("register dst failure");
+
+	if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
+		err("MADV_PAGEOUT");
+	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
+		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
+		goto out;
+	}
+
+	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move)) {
+		uffd_test_fail("UFFDIO_MOVE failed: %s", strerror(errno));
+		goto out;
+	}
+
+	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
+		uffd_test_fail("uffd bit moved into an area registered for missing faults only");
+	else
+		uffd_test_pass();
+out:
+	close(pagemap_fd);
+	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
+	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+}
+
+static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *targs)
+{
+	uffd_move_swap_test_common(gopts, false);
+}
+
+static void uffd_move_swap_rwp_test(uffd_global_test_opts_t *gopts,
+				    uffd_test_args_t *targs)
+{
+	uffd_move_swap_test_common(gopts, true);
+}
+
 static bool
 uffdio_verify_results(const char *name, int ret, int error, long result)
 {
@@ -2359,6 +2428,21 @@ uffd_test_case_t uffd_tests[] = {
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
+	{
+		.name = "move-swap-rwp",
+		.uffd_fn = uffd_move_swap_rwp_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
 	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
-- 
2.53.0


