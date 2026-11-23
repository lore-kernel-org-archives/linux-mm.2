Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3BA606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HFxy+/Lf
Received: by kanga.kvack.org (Postfix)
	id EC3E56B05C3; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BDB6B05C4; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB11D6B05C5; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F10B6B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2409A870E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:52 +0000 (UTC)
X-FDA: 85468003824.01.7BAB0E3
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB17D180002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="HFxy+/Lf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3xc4EawgKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3xc4EawgKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477191;
	b=WYC8qXPsxk/h0gE0t09L7mwvaufjnQUiy6+qeJXGzRGnivNE8v482VAhfc98Smt0UeK2Ui
	9A+4skYcvrAfSOVWaUXbeA0JifcniP1Il0zuv9qBMDub9IyHKhd8PeM9Dk0OGpgRA47C8s
	s7Ih1B1cMDcf78uIDuWovZT8b+H8BO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKSzBSU95DdRnrRamRQphUTqqkxr3KYrkXppzoiSkmM=;
	b=6UwoTT3CQOfTJrCUOJr4xDQsNhIYtF4fy5LoCG4tpA2iMwzLh5zSVClckGw2f3IsT/9HGS
	a7e0DubHXdjCrfL0qg2blS+RuIT/p58wMiKMZLUujhDLR9RZuFVsHw3KmG9dZkifisWJcY
	Fh9SDoniwDkZOw/QzhwniMHlq0GJZko=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="HFxy+/Lf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3xc4EawgKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3xc4EawgKCNQ3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-862a8fcc3caso4454812a34.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477190; x=1796081990; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oKSzBSU95DdRnrRamRQphUTqqkxr3KYrkXppzoiSkmM=;
        b=HFxy+/LfXUt238+MZ471YYD3j6AF8zUWG9RnWDCaKjHsAQF4rOu3q1bDLKt8H76sYo
         T6z6r+2+vq94v+pyHf/XTxo86zSnRfuqpTaha/yp4TZQP93buqdk4EN/7GA/ev0gVxy5
         x46e2glquzj+8A2HlIfck/x4RHWkegdv1bGapP5rBcSdtIlAr2oSE2eYEeewx1/ggVWO
         NP+y8mxKryTSO0aVs/XnJZAgk/PqSwUiopkE5MrxrJp3S4zbHOljdK7mJ9UklcXtHSA2
         pqtZ1qxJ6d49FggS9A2w5fovfHsL+rosmwMY5+4wFkBdj+//jitUptJIwHpwIDhbWKBn
         XnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477190; x=1796081990;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oKSzBSU95DdRnrRamRQphUTqqkxr3KYrkXppzoiSkmM=;
        b=LxCP8TbNvVCPTKeTtvght5Pd1aoCan5ojkhiypJ9r0BWAYmspEg7h6R3omKZ7PgM2i
         j8pwGjdpr0WoHZqwBvUhBsXMXHAo5ldYoRIBpXjLp17/SWvbqNBLX9ZheFqG293dppHP
         F3/k9h6eflTJ657EoE3dFd9JlQTvLTPu5TF+FPmIXb+oqcX6MJm5IFvE9ERsEJskhPm5
         I22idqIvVKcY5QH1TcW84XqbLe4xTIoIIcEFK5UkLSVYty07mUAoTqfaRThhqPqB/kiM
         mhxmqAkJFF3vBLIycxRKfBYDtsG2OYt2OK2338u8pq/yx1oBPJoq9y1cwwi1IB353rxi
         c1Mg==
X-Forwarded-Encrypted: i=1; AL+hErE/hQmix9wdI62VZ9qzkBo5KN94DoTevtHTFhT+9ZmqhlUsl9UnK1eupzYNJlZ4QDS/HqeVgYS6NQ==@kvack.org
X-Gm-Message-State: APuU4Z8HEmLSeQFiX4U4Dl5l1rFLpcPeSqpvZMIGmchI2FTmrFPpwIBS
	NGnSeFoxKOCJyuQD49A18cIZk1gXidfp+Zc/n61qXC6Mqesd7dvqC8P/t39ddGGBrxVec1JQKsF
	ZmqWPrR4v8abQ2A==
X-Received: from ioxg21.prod.google.com ([2002:a05:6602:735:b0:9c7:7f8f:934f])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6415:b0:4d6:92d4:c806 with SMTP id 5614622812f47-57a0ab2fe9cmr13357792b6e.62.1795477189692;
 Mon, 23 Nov 2026 15:39:49 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:20 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-16-dmatlack@google.com>
Subject: [PATCH v5 15/18] selftests/liveupdate: Test memfds and LUO
 interactions in luo_tmpfs
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DB17D180002
X-Stat-Signature: 3bajce3am8eyeth6pmtdey3pomk364n1
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795477190-315584
X-HE-Meta: U2FsdGVkX18Sucry1yl45O8h6ckLGl9SxjeN2y1V/8e5ukEW0FPCJOb6mlgFsjTM62N5kF519DP0dmoKK+3q0q+DS98Kz1j8vMjo4g3ZCs9HMbEHJ153TUX1JuKqeZkGfA7lNzpxpVD11L6PEL6nXukxSh4pdwpmtnEipC+BdkisbiR+ayR+eeOtc2DwE2liGSv7WTYL5QiZ43y9v11pwyRqqfjRu1wuCr1ZWw2YTq10HkAnIWMgGiPw+Rclohvpv/dobtQQKZ/Tu5K0UffB5U/emjouGKRfsQioDGIxN1EOg7cCSdml4LwusCUy/o7cD2KJVYXqCc1mhXTYjvaPnqb41XRPTRRnM+ePHVAuZvn6zF+lt2dqVEP6iza/N8m+D5ULvc9mcCWvCVTSK7F2DcbGB9E2BxwOqf9ZaY6JVW1BOvEaU9aT8jH4SwS9uNtIeCdcWigpSSMD7w6a/SVKvRCFSBN0MPM0o0R/528xtY0ERPteD6JdD1/eEpOesJptz5e8brt4vcxqw1AIuexL4YfzLHT4KLD2IliJUVN1BrLnw3Q35lP2Blng06S9F0Cyl4d6iwRfEbptL9EMTAXacJt8S5pxYLnJ81VBt5uTgQhVx+umIVSx6zmAEMhdKZ6cBr9dNz2bOIGBquMNkfKKUmUda/NrrF9qeOkZL6aGknml82YBiiK+3vIDaE2CU0tsHwiXOhVXK3+egPpUEiChfTpjbkiWSS15MnjSaz/6XkoY4HkdQvmFiZKZTVdiNLu8bOHpRoZHQ597VLFwJ+91FA0uYoKL+Oq8Zi4lJQRvDjbLAOTitedAigThZxmF2rEm9Hcs6UqCZArk2c+vccyNH1NY7ei6tktvwiHGZIypGPxYYKm6VL05R1cfRnBYHUhQl3nyOC7NBZ0SAVdST+bLbdjbPcQDh9r0vdTs/05iaJH1wtm7qF8FJUb5cjeEVwWUD8cDqzLNApEdBtMG3+4
 f3eFDnK6
 TiBqDpHQs9KdnS0f0RndgnhvPz2o/GDjd1OXV5oBTtzYqcebwxX6kZi8T02yzlXrEJo4j0h6WhXujMCxqo6MGWW2e4T/5xO33g7S0O1vCoVoTTgKmb7GvVCqKwMJS9zZfnJmntmcIf1/e9Ao2YNdsRgwWYDtCZui7OIw7aFdQa45Y9XTFwj/oB0PRDN0gHG5OE80Fq839xaJYbEMC3YSw7SLvWMIORUoINnuTejPPRkni2Sln3Ep5xY0H4r2TZ5kf3O3TOC4vqJVM9+Xr0C1HpY1qvcS5IFSnHXBwE+Ued1ThU8oVW8nrJBX8WyIHgM17h5EcKN0s2HS4doAlqOErINW3qRe3DSbUrLwh6TfdeyKZMMOczJ9hefIWGc0kKz1wxxdGfvCAjHDhrFqpdVTHx5tNHz+4TK3++4hiTXXgUdmh0QUKLWa+3BOt1Gfhdwi324aA9dE82IfBQE6ura5mKiAORYlXtqQqzdhO9VynCiTfp0oOVDlHhyQslU+PvnKbTVfFpc7spwKDnjFvrBbOGObMnhfvDdmE/RRxNbcKMzeXm7pwezUZw7sZpf3UyTogcgzRyguRdWEH4PufH44sop6c5PU9ELO+AaFATdogtBMTAyzkTscteRvWGOTvv0d7M0yZRBm74bx5Y0Qi/+RNWrL3ABUDUzzmtUSVGVZ0wxODazjVWlD455T3Uu3BETQHNFdhQq+nc2eZibKReJt1sv45Fj5z1/W6BXi7mEnz4I6PkSp9qnnCj4sgE9O7dNPAamNMUau5OlOyM0GYp9ULPIZJoHkIMtojB2akH+fuf/f+HdY8YbeWdpLiaWPEzjNg1hbsM23MD5DiFqg+GM4c92ATMIqop8ozBOcAqFJNTWszUqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add test cases to luo_tmpfs that check that memfds are retrieved as
memfds, with their seals and file position, and only without a retrieve
argument, while tmpfs files can only be retrieved with one.

Also check that invalid retrieve arguments fail and can be retried after
fixing them. Retrieving a token again fails with -EBUSY with an
argument, and returns the same open file without one. Files can't be
retrieved from outgoing sessions. A file that LUO already manages can't
be the target, whether it is preserved in an outgoing session or was
already retrieved.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 312 ++++++++++++++++++
 1 file changed, 312 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
index 4a50b26d509e..47d4fd27d105 100644
--- a/tools/testing/selftests/liveupdate/luo_tmpfs.c
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -96,6 +96,19 @@
 	}								\
 } while (0)
 
+/* Check that a system call fails with @err. */
+#define CHECK_ERRNO(expr, err) do {					\
+	long __ret = (expr);						\
+	int __err = errno, __exp = (err);				\
+									\
+	if (__ret != -1 || __err != __exp) {				\
+		ksft_print_msg("%s:%d: %s: %ld, errno %d, expected %d\n", \
+			       __func__, __LINE__, #expr,		\
+			       __ret, __err, __exp);			\
+		return KSFT_FAIL;					\
+	}								\
+} while (0)
+
 /* Call a function that returns a KSFT_* code, and return if it fails. */
 #define TRY(expr) do {							\
 	int __ret = (expr);						\
@@ -121,6 +134,7 @@ struct test_case {
 };
 
 static unsigned long page_size;
+static int dev_fd;
 static int session_fd;
 
 /* nolibc doesn't have these, so use syscall() where needed. */
@@ -282,6 +296,15 @@ static int link_fd(int fd, const char *path)
 		       AT_SYMLINK_FOLLOW);
 }
 
+/* Open the file @fd again with @flags. */
+static int reopen_fd(int fd, int flags)
+{
+	char fd_path[64];
+
+	snprintf(fd_path, sizeof(fd_path), "/proc/self/fd/%d", fd);
+	return open(fd_path, flags);
+}
+
 /* The contents of the files depend on their token. */
 static unsigned char pattern(__u64 token, size_t offset)
 {
@@ -408,6 +431,23 @@ static int preserve_file(struct test_case *tc)
 	return preserve_source(path, tc->size, tc->pos, tc->token);
 }
 
+/* Preserve a memfd with the contents of the source of @tc. */
+static int preserve_memfd(struct test_case *tc, unsigned int flags,
+			  unsigned int seals)
+{
+	int fd, ret;
+
+	fd = memfd_create(tc->name, flags);
+	CHECK(fd >= 0);
+	CHECK_EQ(write_pattern(fd, 0, tc->size, tc->token), 0);
+	if (seals)
+		CHECK_EQ(do_fcntl(fd, F_ADD_SEALS, seals), 0);
+	ret = preserve_fd(fd, tc->pos, tc->token);
+	close(fd);
+
+	return ret;
+}
+
 /* Retrieve the file of @tc into a new file on a new mount at dst. */
 static int restore_verify(struct test_case *tc)
 {
@@ -584,6 +624,236 @@ static int linked_target_verify(struct test_case *tc)
 	return KSFT_PASS;
 }
 
+static int memfd_preserve(struct test_case *tc)
+{
+	return preserve_memfd(tc, 0, 0);
+}
+
+static int memfd_verify(struct test_case *tc)
+{
+	struct stat st;
+	int fd;
+
+	/* memfds are only retrieved as memfds. */
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	CHECK_EQ(retrieve_new(tc->token, "dst"), -EINVAL);
+	CHECK_EQ(mnt_used("dst"), 0);
+
+	fd = luo_session_retrieve_fd(session_fd, tc->token);
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+	CHECK(!fstat(fd, &st));
+	CHECK_EQ(st.st_nlink, 0);
+	CHECK_EQ(do_fcntl(fd, F_GETFL, 0) & O_ACCMODE, O_RDWR);
+
+	/* Unlike for tmpfs files, the file position is restored. */
+	CHECK_EQ(lseek(fd, 0, SEEK_CUR), tc->pos);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+#define MEMFD_SEALS		(F_SEAL_SHRINK | F_SEAL_GROW | F_SEAL_WRITE)
+
+static int sealed_memfd_preserve(struct test_case *tc)
+{
+	return preserve_memfd(tc, MFD_ALLOW_SEALING, MEMFD_SEALS);
+}
+
+static int sealed_memfd_verify(struct test_case *tc)
+{
+	void *p;
+	int fd;
+
+	fd = luo_session_retrieve_fd(session_fd, tc->token);
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+	CHECK_EQ(do_fcntl(fd, F_GET_SEALS, 0), MEMFD_SEALS);
+	CHECK_ERRNO(write(fd, "x", 1), EPERM);
+	CHECK_ERRNO(ftruncate(fd, 0), EPERM);
+	p = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	CHECK(p == MAP_FAILED && errno == EPERM);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int bad_args_verify(struct test_case *tc)
+{
+	struct {
+		struct liveupdate_shmem_retrieve_arg arg;
+		__u64 extra;
+	} big = {};
+	struct liveupdate_shmem_retrieve_arg arg;
+	int target, path_fd, fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = new_target("dst");
+	CHECK(target >= 0);
+
+	/* Files from tmpfs mounts are only retrieved into files on tmpfs. */
+	CHECK_EQ(luo_session_retrieve_fd(session_fd, tc->token), -EINVAL);
+
+	memset(&arg, 0, sizeof(arg));
+	arg.size = sizeof(arg);
+	arg.fd = target;
+
+	/* Problems with the argument itself. */
+	arg.size = offsetof(struct liveupdate_shmem_retrieve_arg, fd);
+	CHECK(retrieve_arg(tc->token, &arg) < 0);
+	arg.size = 2 * page_size;
+	CHECK(retrieve_arg(tc->token, &arg) < 0);
+	arg.size = sizeof(arg);
+
+	big.arg = arg;
+	big.arg.size = sizeof(big);
+	big.extra = 1;
+	CHECK_EQ(retrieve_arg(tc->token, &big.arg), -E2BIG);
+
+	/* Problems with the file descriptor. */
+	arg.fd = -1;
+	CHECK_EQ(retrieve_arg(tc->token, &arg), -EBADF);
+	path_fd = reopen_fd(target, O_PATH);
+	CHECK(path_fd >= 0);
+	arg.fd = path_fd;
+	CHECK_EQ(retrieve_arg(tc->token, &arg), -EBADF);
+	close(path_fd);
+	arg.fd = target;
+
+	CHECK_EQ(retrieve_arg(tc->token + 1, &arg), -ENOENT);
+	CHECK_EQ(file_size(target), 0);
+	CHECK_EQ(mnt_used("dst"), 0);
+
+	/* The failures didn't consume the preserved file. */
+	fd = retrieve_arg(tc->token, &arg);
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+
+	close(fd);
+	close(target);
+	return KSFT_PASS;
+}
+
+static int retrieve_twice_verify(struct test_case *tc)
+{
+	struct stat st, new_st;
+	int target, fd, new_fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+
+	/* The argument only applies to the retrieve that restores the file. */
+	target = new_target("dst");
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -EBUSY);
+	CHECK_EQ(file_size(target), 0);
+	close(target);
+
+	/* A plain retrieve returns the same open file. */
+	new_fd = luo_session_retrieve_fd(session_fd, tc->token);
+	CHECK(new_fd >= 0);
+	CHECK(!fstat(fd, &st));
+	CHECK(!fstat(new_fd, &new_st));
+	CHECK_EQ(new_st.st_dev, st.st_dev);
+	CHECK_EQ(new_st.st_ino, st.st_ino);
+	CHECK_EQ(lseek(new_fd, 77, SEEK_SET), 77);
+	CHECK_EQ(lseek(fd, 0, SEEK_CUR), 77);
+	CHECK_EQ(mnt_used("dst"), nr_pages(tc->size));
+
+	close(new_fd);
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int preserve_nothing(struct test_case *tc)
+{
+	return KSFT_PASS;
+}
+
+static int outgoing_session_verify(struct test_case *tc)
+{
+	struct liveupdate_shmem_retrieve_arg arg = {
+		.size = sizeof(arg),
+	};
+	int out_fd, source_fd;
+
+	out_fd = luo_create_session(dev_fd, SESSION_NAME "_outgoing_session");
+	CHECK(out_fd >= 0);
+	CHECK_EQ(mount_tmpfs("src", 16, NULL), 0);
+	source_fd = new_target("src");
+	CHECK(source_fd >= 0);
+	CHECK_EQ(luo_session_preserve_fd(out_fd, source_fd, tc->token), 0);
+
+	/* Files can only be retrieved from incoming sessions. */
+	arg.fd = new_target("src");
+	CHECK(arg.fd >= 0);
+	CHECK(luo_session_retrieve_fd_arg(out_fd, tc->token,
+					  (__u64)(uintptr_t)&arg) < 0);
+
+	close(arg.fd);
+	close(source_fd);
+	close(out_fd);
+	return KSFT_PASS;
+}
+
+static int target_preserved_verify(struct test_case *tc)
+{
+	int out_fd, target;
+
+	/* A file preserved in an outgoing session can't be the target. */
+	out_fd = luo_create_session(dev_fd, SESSION_NAME "_target_preserved");
+	CHECK(out_fd >= 0);
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = new_target("dst");
+	CHECK(target >= 0);
+	CHECK_EQ(luo_session_preserve_fd(out_fd, target, tc->token), 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -EBUSY);
+	CHECK_EQ(file_size(target), 0);
+
+	/* Once the session is closed, the file is no longer preserved. */
+	close(out_fd);
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+	TRY(check_restored(tc, target));
+
+	close(target);
+	return KSFT_PASS;
+}
+
+static int target_retrieved_preserve(struct test_case *tc)
+{
+	TRY(preserve_source("src/target_retrieved_empty", 0, 0, tc->token));
+	return preserve_source("src/target_retrieved", tc->size, 0,
+			       tc->token + 1);
+}
+
+static int target_retrieved_verify(struct test_case *tc)
+{
+	int target, other_fd;
+
+	/* Retrieving an empty file leaves the target empty... */
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = new_target("dst");
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+	CHECK_EQ(file_size(target), 0);
+
+	/* ... but LUO manages the file now, so it can't be a target again. */
+	CHECK_EQ(retrieve_into(tc->token + 1, target), -EBUSY);
+	CHECK_EQ(file_size(target), 0);
+
+	/* The failure didn't consume the preserved file. */
+	other_fd = retrieve_new(tc->token + 1, "dst");
+	CHECK(other_fd >= 0);
+	CHECK_EQ(file_size(other_fd), tc->size);
+	TRY(check_contents(other_fd, tc->size, tc->token + 1));
+
+	close(other_fd);
+	close(target);
+	return KSFT_PASS;
+}
+
 static struct test_case test_cases[] = {
 	/* The restored file. */
 	{
@@ -612,6 +882,47 @@ static struct test_case test_cases[] = {
 		.size = SMALL_SIZE,
 		.verify = linked_target_verify,
 	},
+	/* memfds. */
+	{
+		.name = "memfd",
+		.size = SMALL_SIZE,
+		.pos = 700,
+		.preserve = memfd_preserve,
+		.verify = memfd_verify,
+	},
+	{
+		.name = "sealed_memfd",
+		.size = SMALL_SIZE,
+		.preserve = sealed_memfd_preserve,
+		.verify = sealed_memfd_verify,
+	},
+	/* Interactions with LUO. */
+	{
+		.name = "bad_args",
+		.size = SMALL_SIZE,
+		.verify = bad_args_verify,
+	},
+	{
+		.name = "retrieve_twice",
+		.size = SMALL_SIZE,
+		.verify = retrieve_twice_verify,
+	},
+	{
+		.name = "outgoing_session",
+		.preserve = preserve_nothing,
+		.verify = outgoing_session_verify,
+	},
+	{
+		.name = "target_preserved",
+		.size = SMALL_SIZE,
+		.verify = target_preserved_verify,
+	},
+	{
+		.name = "target_retrieved",
+		.size = SMALL_SIZE,
+		.preserve = target_retrieved_preserve,
+		.verify = target_retrieved_verify,
+	},
 };
 
 static long read_taint(void)
@@ -641,6 +952,7 @@ static void setup(int luo_fd)
 {
 	unsigned int i;
 
+	dev_fd = luo_fd;
 	page_size = getpagesize();
 	umask(TEST_UMASK);
 
-- 
2.56.1.809.ga0b61035b5-goog


