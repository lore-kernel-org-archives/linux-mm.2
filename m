Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CFD606B9C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mUitpJHN
Received: by kanga.kvack.org (Postfix)
	id 6E87D6B05C4; Tue, 10 Nov 2026 19:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671BA6B05C6; Tue, 10 Nov 2026 19:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A046B05C7; Tue, 10 Nov 2026 19:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2319F6B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AC591201C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:30 +0000 (UTC)
X-FDA: 85420941900.09.FE2A9E9
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2EA3180002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mUitpJHN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3u7XzaggKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3u7XzaggKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356668;
	b=vVM3BMjpUrFQQHT/uJZB1JHhkYIfylwXiB87kCRQHdla+qOayw54I6CGfTfvbe0L5p8C0d
	Ubr5zl3eUkpoj7UMrOuDUaOxiQu5IWuV98MD0QbENTJ63L2k7UqhseL16SrqkZbydIUw0Y
	v1UQqjrBmH84wFRlgqiFaOxvcCCK5W0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGnTylInlGPnjPgrMZtxSLopGNvVmMmKkB35AW/t6rg=;
	b=2fUzT30jXGYUMWxZ8Wg7St6pIZn6WaRc/tsTYYl968A5mGWarsazn5+fed6+YUXOxCyIza
	Umjolz6n58O1EccGlmWg2J4rEKbnW5wUTos11I+5txQMdzUlefeQwIRzXUDODwJegOPLBE
	zLMYtrTVGnWq4PBQH4aL6NlJXh3Ybwo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mUitpJHN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3u7XzaggKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3u7XzaggKCFQz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-54dbbf252cdso3035718b6e.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356668; x=1794961468; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bGnTylInlGPnjPgrMZtxSLopGNvVmMmKkB35AW/t6rg=;
        b=mUitpJHNKLxSo4MlprNFhX85cFHxLgmlAFN06xdmmHobPWQpU3z0K2LfKRcUaTy6vF
         lz/4olsrgvZAo6oLgyxZwhKX51YdpWgCyqH4Nn8K1j1DuXLVJnKdtY4XZYAqDCy/iYUT
         uPVClfj1WvL/uuLnMqx8syXEqF22a6taHTTAZ4BKDFFdxzPZDkhWe/7QuPnnCDloXHg1
         CTUXJ8qhvfZPHYAzhS0W6NzaMM31IaBB4naSL+8lPD6c7MAUtJEHNANgPVF37igAH22P
         4uIZeP01eR+NewBPHHskTiYnnPTENJBbLxCBZ9pSqLNNAPNaL2za7S45aD5FvdisCDoR
         0QOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356668; x=1794961468;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bGnTylInlGPnjPgrMZtxSLopGNvVmMmKkB35AW/t6rg=;
        b=kejsDAukaasiV5UmmU83lpgOh6TOkXmGuCr/ZlvF+Oe+S/m6mXs/BopDk+r1DMQZhS
         ZwG81yqnD+W4sch1Lozov8Lmu82XgM+3MvRzYyeoeJ4p1IRz/7dDpj6dqAHeA6fx1Zvs
         BXvXg1EIjmdmc/nhHCTg4/YIwPaPZIBc2Wwrvqbv6p3vmXjt3/62S+fGhiliUWOzWApg
         qiRUXvu0nY7OBrohEVxFdNm8c5d30A8R7CcNusu/J0OERYo7/nLO76LgYG2Rb/a4LkM1
         ch6x95h2m2fexJSF3LTmNGIOqlJrSGQ7LJOPRZBLiXniEn3Ns6zfudCMR4Ckn1y/oaiP
         yYCg==
X-Forwarded-Encrypted: i=1; AL+hErFZEq4K8QeSJ/BhnyRDbsfetl0kb1H8KlD77cUO19WXVLzsMyVA1ApxbFXrAmryepK3S1TwX5Z6ag==@kvack.org
X-Gm-Message-State: APuU4Z/SsipJYApmi+1oGXzyfMY5tFDeNkSfGTsN054izNmCTEiz5kjk
	Tr/DtCVMQPlqusT2zS0aGJMWV1GnlvFVFrBNzmrC72P9uYuP8E9iWTZJR+ni7Bws8K+rEmzKPTN
	481RH76gMiqMCLA==
X-Received: from iocre20-n1.prod.google.com ([2002:a05:6602:87d4:10b0:9c7:7dbd:f35a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1304:b0:4e7:8f9b:1185 with SMTP id 5614622812f47-56b932426c4mr552544b6e.3.1794356667453;
 Tue, 10 Nov 2026 16:24:27 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:54 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-17-dmatlack@google.com>
Subject: [PATCH v4 16/19] selftests/liveupdate: Test memfds and LUO
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
X-Rspamd-Queue-Id: C2EA3180002
X-Rspamd-Server: rspam12
X-Stat-Signature: 7n7megenqc3iioxt7exeew8uu3atff1b
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356668-839165
X-HE-Meta: U2FsdGVkX1/C5LqDESBLbSzCAXNDRmf7v3YdDzJ7KeVIRYXdTuCOpmj2xTghmoscRUPzQpe2jeT+MBjJ2wIYL+V2Vh2aLKw6PRNAfxdI1n7OGA62HoC1XdqNDqNS223zJdrTVZPV1bsXr1MgN8ah2LXt2Apx1Y5Cyfx5BXGiUClpz/6gW4J3Fp4zPBwf8T25XuiyxegqIXzXjst18uekTwnfg7p3+0oOg9AEUmKZdzD1g+8158CUatTHfo40mwe1HjjyYkb5gSHO+4iQZ4RBKW80gJ+1CcMaTToBZdunDWttMU5kwXA51scTpMZW0M7vjuWalfxr5r0QHbxIvicwC5mGQrrwqRaH2u3ziLcSqDWb5m1PdP7giTF2sOTyL9hFuI4iS9lyBbkpN6IaVq5LppOr3C/hTbVc1TWFdoTDQ+DP7Er/uCVp/b5kxYY9KoPYwlhkK18bZtUdAD+c4l0xsumLiB95hgpQZ8hAeqRu0Z+3D3PoFGeOjGvvw7BZe/tWQy1xuNYt4tfIS3a2AcR5UKAPzL+j49AksZurN/Tu8vIG5ltiirjo7a7s2UwlbnyvRff7ceylx1GXDf6bpUj1NNm+p+kpaGpbi6shG6dDVRvYppQgIa6afa6RvvYcrLsnreuLoCQRZHjOslWIjrm2P7jdZg5gdnmA2DEhCay1F6AxEMWY1xoUM80wMVyjvTbhuzdR5yRnzwlqNdDD7X0pmd01zXfApyWVVgyIpuNsrYh4EkZ10T6NpuaaZf2n4EhFDA5mCDFT4OiR4MLWE71YNtO9KNSYA0eE2MSMGOyKmb05cTSBdtQ6rRwfPRIi01XFg4mWBo+mAxCS0QIFOilJD+gb7k7W3Xd9vaWUqixo8rSbxvic2Ucc9eexNoW0+LUW/w6PAZ9l3HrPdmMt8TM15ygoMQCcIrMpJ8LaXe9E6Y7G1PUkilDRB+bVv9PwO6/WZsrNLjgQolduCqqQy+c
 izqvk7tj
 4+Ksy7+fJDjrAnxIGCCy2ruvM0FaPY8hLgvce32C2J2d5KXIeYycsFFUNXxHpmnHwnsRm3S3qB2SmuF4WR6pSv/OapBCPtRtcZCiXGKrIxn9I4inMq6sJ+TGsBR4NguelIbK+DCPns5eaqokCHM+b64JyBXrSHFVM4hQdNdEp9btXRtRL0IK+hmyRYbRbgOY1ZYsnqgN329VMUnJOak3PsxfEaKUSEo5ggt6wNk8mNoSLq3leIdcBXi2Mr1Ab7+g/QKy7GBID1Awdzxz+Cd4tB1XzScQukorBn3rLdhNw77a59W8wMvjHW8jFD71Bh6QXdN8Zs+gtXj7u4J8SLt9iZ24UTtK1ELcs9IoihCdutirZFCl5ePbDJYEcftbAJa8exMNyeqiTiD/L6vHo51uuH2g1rDC3F83Q2NXpCUTscG7ysA4sXYcqYwTvsN1TcKkWdf91MZhYbOeKxTlzdsbKLHQ74j17Hu6PJniGi0h0tK91V4eHCwGjTTh9k9HznWTGO12TSnHRQuKxBNza3lZiR0WyRNrwMEb6qxn2M5uwrn8/wdjRlWuaGeYO04LK3MCD6Shl5HEx92T0Zc3zUL8RrQdfENStiB2mWLn4/9InqksXiZORhx4jFVCYMfG4EEEgTmT/pfXHk12SGFC+rQVGMqfQ1wMviyDKNwqq7Xg2N+ssAaiRZH5i+SpKBsGAZxLNQq5OZAdYbXKCDw/6bJhfAmQCmPcdF1pAt4XwQ1DwBCr4XuHDrLfJK5tXRMdzSAvU6ssLCGnNeeH2itGAR7O/NTorEYsVGGVZXPyT
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
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 310 ++++++++++++++++++
 1 file changed, 310 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
index 4e6e035e8433..91a607752ee2 100644
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
@@ -271,6 +285,15 @@ static int link_fd(int fd, const char *path)
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
@@ -397,6 +420,23 @@ static int preserve_file(struct test_case *tc)
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
@@ -560,6 +600,234 @@ static int linked_target_verify(struct test_case *tc)
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
+	int target, path_fd;
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
+	CHECK_EQ(retrieve_arg(tc->token, &arg), -EINVAL);
+	arg.size = 2 * page_size;
+	CHECK_EQ(retrieve_arg(tc->token, &arg), -E2BIG);
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
+	CHECK_EQ(retrieve_arg(tc->token, &arg), target);
+	TRY(check_restored(tc, target));
+
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
+	CHECK_EQ(luo_session_retrieve_fd_arg(out_fd, tc->token,
+					     (__u64)(uintptr_t)&arg), -EINVAL);
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
@@ -588,6 +856,47 @@ static struct test_case test_cases[] = {
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
@@ -617,6 +926,7 @@ static void setup(int luo_fd)
 {
 	unsigned int i;
 
+	dev_fd = luo_fd;
 	page_size = getpagesize();
 	umask(TEST_UMASK);
 
-- 
2.56.0.542.g3ef89b7020-goog


