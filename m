Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB3FBFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4098E6B008A; Mon, 27 Apr 2026 05:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1256B008C; Mon, 27 Apr 2026 05:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E2C6B0092; Mon, 27 Apr 2026 05:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22A286B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:46:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9CDC120415
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:46:03 +0000 (UTC)
X-FDA: 84703854606.19.628019E
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5273440005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:46:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=GdAv6HW8;
	spf=pass (imf07.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777283162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caEr/cCPAOS7lUtBcTXzM2Ao0/6+pmmZoN+wBM7w94E=;
	b=UpDvj5EthDtJWjOfboB6jEFa9QIKwE0MyFZduyZ7iMI7s0mISdEdVOmLaKwyfHClLvn3Bm
	I5wX68EcuPW5IzWhkJYqOv8Qsi76RMXNNGaujUoULHTYAQwxnAwdBrvgCxW6KriOa2Mc8G
	lH+vn0K75ck2yLMRE6AlkrOBztXmHeg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=GdAv6HW8;
	spf=pass (imf07.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777283162; a=rsa-sha256;
	cv=none;
	b=1BiHfOe6UVsbXP5p1JpzDvSIuAl5lzT3puY+7sSJqbUTMlkdPjyfwVKarr5ZSQ+WIY+x51
	taoH95APhOo338fqp4pNVcUZT0pO91SK4yLN4mUOl6MuguLHZxmUNv+u+mJ+H3jclv9F46
	r1GaN0gwTKxPA99kbVw265jwpgXZzUQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777283156; bh=caEr/cCPAOS7lUtBcTXzM2Ao0/6+pmmZoN+wBM7w94E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdAv6HW8iiitdnrPD+mLM2XUQNIHlMy9z25p4vUkEAKgzY+dsAjPFgYY4ebwSiGvs
	 rd0oCKWSc2LyVx5ExZwk07KiZ99YqFcf7YCgr8ne0m8RTbd7iCczfqbUTB1awMeKfW
	 W+6xtK1LHGtPRkmnMBWLdTuyRtk7qyy7QTnSk1rY=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id B748F4E8; Mon, 27 Apr 2026 17:45:52 +0800
X-QQ-mid: xmsmtpt1777283152t3r2xn4s1
Message-ID: <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3Nt5FwU4X6EKhyI3JM0ioNsa6LDu1k/JFnM/st19XrkwqJalskix
	 YYx3xngayGJzSvVE/CsVfQMBhAeyEGTKJl2ESdAKYxjPf54SBZIiGhJtCQd2wxfCJlaEMqU+mToV
	 mmkvPpDcJh7tUU1q86o7eg764dcCD3emQ3bCxUfhn23ZK6LV8zZGyGkvreSHN5wSlpL/rkmx4Lqs
	 sU37eTPWKa4JXh8K0BMkRh9QgZ+LbXwoGbUj8ywSRfpWWaBBGK8UkGJpOYocz3AFb1yDac9ILQXI
	 gGRv2M9lqKxpDvkWRLPqtF7UmOSmRuSBFxzqW0aOeJXHX1wJiPGtnPFp9EQg4wGagOaI09iZ4qcn
	 IS6c/tcEaDpIl3PFy2xlpB5DvSlPZIbMUrsrYU8Aa4ixKOc2BGH9pv65smoby0mpQgXmnIKkZqul
	 nKZ8GrYHhvqQKyLUHlgwDTrjXf6N5dHisoHwkRYlat2nIwB7Me2j9EeXmpxwtLVInsiiE/ej9n08
	 LAmlFcigBOXcKocUG7UEpgMmxxgLZHqLdKHUw8nd37e3l3BZnxp/RWUdcDZ0v2lf4QXHyGsNB9e5
	 N5xNexcnzWNSOCogdsR/5DvV703jP2bdxPqtQ7QD+soUtYxh5MezZ46v1pF3a74E6kVfWGRbgajw
	 ATx7j0inchIqpVzDhPL3F5d4pwc758mxEAAbCgLii8oBSgsBlcGlM2vpD7CESxKUTiHlYe0pEi8o
	 R4daunvagTSMBCHv8PgIh7hXpBf7W6anpciFwFlDBWNaiArp/nMvzGhtwBsVIvsGXpZtvw+n4jEv
	 AcRh4AMKi9aNJs/HJ8XUs8pVAqng+tMwcEDPvWGmEb3PWNLZ6VVt7C5iS3XgDmdCW2nVEz2XI9E4
	 q9Qpm40RGvP0223HdWX4dtpjiXD+gMnqo4emjspXTlfokZy6ZVLndIH3bCK62xWUbE2MDOs1HDaN
	 H3On2ka6j/sE8F7ZuvKnkr/45xu7k/bO2omkcAnV1h7EWdRBT3fK7jzQtkCUbKseDOrxAwE0RcCH
	 JmljRFhl1VlEzzP2yV
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	fujunjie <fujunjie1@qq.com>
Subject: [PATCH v2] mm/madvise: reject invalid process_madvise() advice for zero-length vectors
Date: Mon, 27 Apr 2026 09:43:30 +0000
X-OQ-MSGID: <20260427094330.3364571-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5273440005
X-Stat-Signature: 9r4e7h1tz3bzjj7e671tnot1uomni6cj
X-HE-Tag: 1777283160-659077
X-HE-Meta: U2FsdGVkX19lh2F1LGNt75d2zt9LfALkEFb1FX4asQb1yp6jRM4WGtZ/xWBqV8orGQwBdW3aTh2J3KlY17iRZPoMyTIeFsRaF5ll2TlEAIt/R6A3GkECk/+hwASdYFEESZbSBnJXJZdb8dkyUI5XXTDMp4WXyUSesR3ecJD6btNV1Hw0OD6RoyltcG07ntcYAk1yIy6h4s2QRdDSz0vOPSJzn54AbKGnpGRgJjq5DoXXhhV6ybjsfVnlt3c/7nh6PRHcZSwIo8wmWsWvZnuBOGzzb2OSGYMsT8ba707AnjD0qJBhErp1fEpAPJuvLE3l9RYF9Af+UG6bS0tAOjSGFffEGH2m3RJ1Nsui5g6A6qNRmXV5nseHXONu3+h43zD00kXHaP8Ry8x2+Gler6SMf2B7pyNsec7bJXw97ZfIBy91wCOH6zSIRsmMD/BHcngigugWF8KNzFEwNTt7L9q1nq+m4PaWhIm2APA0L9v/aAY6Ch7xi9HKKOg76aUnQz7naGsPaWsqy1ge6O/uX+mJ/n7pGq18Pvxm0IVkScbpaSwY7DYhOuUfFBW8huRzumR2cK/cbltMQE/eeqAsn1vbxilZrHR3pkVhvXBRzhw8N1RMZZI7+qKYgA8RVn9isxJ7GJZPvtA1CNEVw5cUcIUg2mBCahEd76hjGOCEvORKTQ6eHt/PNANXVBFNkA7+9KwUuhDZ/uprdWHzG4baNy3dmhdIqGminnGVdOnFC1xElPXGhZJgpDaN2dLIqjU+z7ve3m9YBbMKbCxOITzopyaQYLvobWSFBpX/m3QEdNxl2nDYqPvjwGdyb0HEZIF/uo9cUKWyjBDoGVi2pdSMMtjsQlPhnhzvRTYpUJjRqO6CpnBrMEJYpvQ25TCTd2fBgqZTKYhqTUYkcfCsX8A9dV/Ugv7ZIlS94Gjuz6tmkgecgne+G9PUU0kZg5djDhvIcieBQvY4upBo5UuP3HspuQ3
 7iTRRkm5
 xXvHlBqSPLPiK8yi4MvpmhH2+68QfXf8nse2Fydy9NwZNhUXEyQOUmQxtyHtxKux3XWvjqNCVwJ18o9VzI6ztMYEfww+F/klOHOHZF7hao3WTn5mQXapKRMqdw7mMxW0fcNLU5mwnyLU4vPYxsHHY8ryqmh9kntjg5TZqj3YQ608Gx/FhOA9UbFHJDrb633cS0qqj8HHUAxeS1tqKezGJ8ITISd4oWw9t+tsKI0kLREJvuhn/PC0M17HlkoCW4LEhFe69bMrvvQFVsw1qdcIjlk1qYXveuqPtwqr84zuOzV0HICCnLXvrvrrUD4f6KV/yjNoO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

process_madvise() used to validate the advice while walking each
imported iovec. If the vector has zero total length, vector_madvise()
does not enter the loop and can return success without checking whether
the advice value is valid.

For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
process_madvise_remote_valid() check is skipped. As a result, an invalid
advice can be reported as success when the vector has zero total length.
This differs from madvise(), which rejects an invalid advice before
returning success for a zero-length range.

Validate the generic madvise behavior at the syscall-facing entry points
before any vector walk. In process_madvise(), do this before the
remote-only advice restriction so unsupported advice is rejected with the
same priority for local and remote mm. Then keep the per-range helper
focused on address/length validation, avoiding repeated behavior checks
for every iovec.

Valid zero-length requests remain no-ops and continue to return 0. Add a
selftest that covers invalid advice with a zero-length iovec and an empty
vector, while also checking that a valid zero-length request still
succeeds.

Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
Signed-off-by: fujunjie <fujunjie1@qq.com>
---
v2:
- Validate behavior at the syscall-facing entry points and leave the range
  helper for address/length checks, avoiding repeated behavior checks in the
  iovec loop.
- Put the generic process_madvise() behavior check before
  process_madvise_remote_valid(), as suggested by David.
- Keep the zero-length selftest coverage from v1.

Testing:
Built bzImage and tools/testing/selftests/mm/process_madv. In QEMU, the
process_madv selftest reports 7/7 passed.

 mm/madvise.c                              | 29 ++++++++++++++++-------------
 tools/testing/selftests/mm/process_madv.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf56..ce238dd96f158 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1834,13 +1834,10 @@ static void madvise_finish_tlb(struct madvise_behavior *madv_behavior)
 		tlb_finish_mmu(madv_behavior->tlb);
 }
 
-static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
+static bool is_valid_madvise_range(unsigned long start, size_t len_in)
 {
 	size_t len;
 
-	if (!madvise_behavior_valid(behavior))
-		return false;
-
 	if (!PAGE_ALIGNED(start))
 		return false;
 	len = PAGE_ALIGN(len_in);
@@ -1859,17 +1856,15 @@ static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
  * madvise_should_skip() - Return if the request is invalid or nothing.
  * @start:	Start address of madvise-requested address range.
  * @len_in:	Length of madvise-requested address range.
- * @behavior:	Requested madvise behavior.
  * @err:	Pointer to store an error code from the check.
  *
- * If the specified behaviour is invalid or nothing would occur, we skip the
- * operation.  This function returns true in the cases, otherwise false.  In
- * the former case we store an error on @err.
+ * If the specified range is invalid or nothing would occur, we skip the
+ * operation.  This function returns true in these cases, otherwise false.  In
+ * the former case we store an error in @err.
  */
-static bool madvise_should_skip(unsigned long start, size_t len_in,
-		int behavior, int *err)
+static bool madvise_should_skip(unsigned long start, size_t len_in, int *err)
 {
-	if (!is_valid_madvise(start, len_in, behavior)) {
+	if (!is_valid_madvise_range(start, len_in)) {
 		*err = -EINVAL;
 		return true;
 	}
@@ -2013,7 +2008,10 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
 		.tlb = &tlb,
 	};
 
-	if (madvise_should_skip(start, len_in, behavior, &error))
+	if (!madvise_behavior_valid(behavior))
+		return -EINVAL;
+
+	if (madvise_should_skip(start, len_in, &error))
 		return error;
 	error = madvise_lock(&madv_behavior);
 	if (error)
@@ -2056,7 +2054,7 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
 		size_t len_in = iter_iov_len(iter);
 		int error;
 
-		if (madvise_should_skip(start, len_in, behavior, &error))
+		if (madvise_should_skip(start, len_in, &error))
 			ret = error;
 		else
 			ret = madvise_do_behavior(start, len_in, &madv_behavior);
@@ -2131,6 +2129,11 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 		goto release_task;
 	}
 
+	if (!madvise_behavior_valid(behavior)) {
+		ret = -EINVAL;
+		goto release_mm;
+	}
+
 	/*
 	 * We need only perform this check if we are attempting to manipulate a
 	 * remote process's address space.
diff --git a/tools/testing/selftests/mm/process_madv.c b/tools/testing/selftests/mm/process_madv.c
index cd4610baf5d7d..9a7e2788fcc50 100644
--- a/tools/testing/selftests/mm/process_madv.c
+++ b/tools/testing/selftests/mm/process_madv.c
@@ -309,6 +309,35 @@ TEST_F(process_madvise, invalid_vlen)
 	ASSERT_EQ(munmap(map, pagesize), 0);
 }
 
+/*
+ * Test that invalid advice is rejected even when the iovec has zero total
+ * length. A zero-length advice is a no-op for valid advice, but invalid
+ * advice should still fail with EINVAL.
+ */
+TEST_F(process_madvise, invalid_advice_zero_length)
+{
+	struct iovec vec = {
+		.iov_base = NULL,
+		.iov_len = 0,
+	};
+	int pidfd = self->pidfd;
+	ssize_t ret;
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, &vec, 1, -1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, 0);
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, NULL, 0, -1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
 /*
  * Test process_madvise() with an invalid flag value. Currently, only a flag
  * value of 0 is supported. This test is reserved for the future, e.g., if
base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


