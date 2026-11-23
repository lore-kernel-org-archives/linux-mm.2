Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E806606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=G4RgbyWQ
Received: by kanga.kvack.org (Postfix)
	id 044E16B05C4; Mon, 23 Nov 2026 18:39:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39026B05C5; Mon, 23 Nov 2026 18:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50176B05C6; Mon, 23 Nov 2026 18:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE4D6B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDD39160A0D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:53 +0000 (UTC)
X-FDA: 85468003866.18.8638F09
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 36E0C40008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=G4RgbyWQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3xs4EawgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3xs4EawgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477192;
	b=WY+cqvcEoiUHUxuqPsqYcHeAGnSZhJLyjHTV78lsE5Kd6qS0zG2UPKlMorhJmabXsN4+cS
	B3IO5X4dCsBShyZwYhjllUjSXezrktAPqVcnrLUw/2RmMvLPyR44sNjpRX2owTP+NHLq/k
	gWtNcrj4uACeD99p8OJK1Fp+KIvOycM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78CcJDIfdo4p7bmykJDTTCeKA1HLMY4RkDEhmhcpIaI=;
	b=QsguR7p8T+CZ+oS8mt5vMahP9+Ck1p2PzgOAi9WYCQmzZXac/VBf0uJTIQumozEW8BIFJ6
	sOvN3lqexaShjORy65YU/56ZVRq0a5l+NPzNizqKCRa2jkEVKpy73A5dgnbwjGF02jx9Na
	4Tr+aQdD28kJ9Tjm9AJDMrSzqxYdyqA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=G4RgbyWQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3xs4EawgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3xs4EawgKCNU4D1KC13B7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4dc57e2a3f2so5081921b6e.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477191; x=1796081991; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=78CcJDIfdo4p7bmykJDTTCeKA1HLMY4RkDEhmhcpIaI=;
        b=G4RgbyWQ2LXpL9Bu2LU5tJ5FSwleZGOW+JgYK4VkqP8jBuHpagoSnsQRnm2O38QNmY
         0FCoeyqRoBLVfVE0Y1FTqAcFGH4wUaIv20RnT6SNOgGplYFYzfvzP1oTyD62XvsibmKm
         8sHunXu1+lHIt84+Cr2dLER0qzMP3FasjKn11NAcnMpH+2Hg6qBIL6Pnvs73zp7yLwum
         csItoE/yI3mv9fyn5klwd00uQt24CpocV4hkxhnlct6Vn/kpj4+KI+jz7WY5O7lnXwfd
         5b5pDr5t95jEG6si/RbpO4gXxpixc7pz59O5vmc56ysjHRyNVgPaAIyUdyjiqrS8abs3
         /mgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477191; x=1796081991;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=78CcJDIfdo4p7bmykJDTTCeKA1HLMY4RkDEhmhcpIaI=;
        b=eMa+mvMl+5eUVsYa/nQC6oiN/LqBjR6LP3ID9Pv4Iztw1yeRQWDpMEzGHiDpFL9H4I
         oCvfxbByriu2vP1XxZiMN+8PB8+IYQCLX3u2EC50cRzjZhDTitfZ5P2Gxm61n70weOmc
         WoRjRC22+HR4z6TcscJfIzUD8wMaS1I1/eC/eg7K2f2T3i0FHqWODhW9gKnI5Q8cecje
         hS40CrbAw/O6Spj02guvzXBtn93KSjt3r1Us7VHupuetODDzzTH3jkzaNHkzyGb54o5F
         zYi/E7/R5ePel9fOeqeXdv+iY43JU7JwliQBO71dzOshsJMkhb62rwiykniy6AIenTIM
         JxCQ==
X-Forwarded-Encrypted: i=1; AL+hErE08ql/SHqJxeeLiFtQRuWX6R3aX2lk6xa6ANyGYSScuo5QAfAzg8xWVzaOH1gZq++l6P9rpiKSGA==@kvack.org
X-Gm-Message-State: APuU4Z9aollDwghI3s9K5v4HuVBfF5kdUrXuuuEcnEpmfVIvntEqMNUB
	evHAwG/fA/nIO2FNaaOTeGkTWsgg4HUoYGNBs5WfsBnmqd0ubXyTIKGdKl/rRQ44Hvq9+9c4sBn
	q84VkgwTHqI2Z7g==
X-Received: from oim24-n2.prod.google.com ([2002:a05:6808:4a58:20b0:4b3:7bff:bf15])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a0c:b0:4f4:fc4e:77e9 with SMTP id 5614622812f47-57a09c0ade2mr14465731b6e.42.1795477190984;
 Mon, 23 Nov 2026 15:39:50 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:21 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-17-dmatlack@google.com>
Subject: [PATCH v5 16/18] selftests/liveupdate: Test the targets of retrieved
 tmpfs files
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
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36E0C40008
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4f1t7d6bfgkjs483k91qf5k1r3zqb9qj
X-HE-Tag: 1795477192-393387
X-HE-Meta: U2FsdGVkX188ve3zo4HFxa8GbqHR+fnygUyamGZIh4ibCXMonE8LD4EH2GazySE8zsVTdT4oVD4Z5xEwIxXgLrI+inmVvtIbQjTz5FTSDjRWgksmcVj1wDWEjkgQgAWIy/qS9Nj9NxZBO20w6hmdddKr3TEygkuAGHaItwXT1g0JlHByFS5jWuesuG3vme3riW7bdssao9OtQ0h2OSoCjqW/RfD+WMyNGuRL2EiWlk4XMamAKbMcFQghni8pzheKeLlCcnNEBr2WJ0IBnv3wy2Cv3g/c3hH68FCkaPevVaQuSSg+Zl4L6thkwFA6yaDRnGhBp5ReW5HJ+Y+hS0m6TMxoRq3GH8ufwthZoFntKjyIi9Xr/oGRR6KyguD72KFRTUuvrF0hXBhjgjkNws08zUErgeK4Djgf8THnAh0UwLigWKRegEMSPUF2mEHeVEQjCU9WA1/UYqFcCmnTm+3jRZelSK1g5OcKj2EFvwZd54HLMGKO361xVYcF2+CCGIsvOTi/As1FIQh7d73jPDo4PHsBYhfL42+Pkm9n4/tYjg0ByPafbZIQEbY0OGIO0r0uYuG3FVAslRm/WEDW+vyNdgSclBIb8dDFzd1WI4m2XmgAqLi1r6+qF2IjQI6KCRi35oy9YhAsdJKv6hExQfOfHnqIipwoVSgynGUanjphZuBsYw10B5LEnPyLMjE1NGMljjMo9qrXoRlINR1pX8jQIymE4P/adGk/75e6g2ZY1/0n4BtYOYZT00grrV5ALfGFYkuBGEVAlI8Fv9CZQdB9Xc/cr7eg+Yhtfk+i3zRdq1hZB36DqCdPQlFSoAx47EJi34+7EeNGfXon/Ey2e7SmsL1DQL+vWbgDrR72hUJtPtowb8tAtkX1p9TukrrdDIM8/oU040Qg3wPpOmcDHZwvDEYtBFAqKfsL0/bv4r1GFkMnqYtdVHsqKQWqpZrHIaSgxyTj1gXBsbqtEWE9TN+
 YTynkHxc
 FaDfHm9mQwhjmpoXiXxmG4p/TXJHuTzwzxzVoHr4b+gAQNR/lWJis3f4ZNsQjtX0mKpus/1BTdLPaKyN8xtRq/bk4xe2HQb8zE2oR65I7WOoY1d15N0YSfGNKozZHcibZPObs743LjBUx3h6CacfqSA11RxpMvd9or4TxnZ4Q+wAeOaPbjuK3GIcuvemwL9aSCkLuFH2HeT+SuzNdw5FnweIOhWOVuevuHhBbfLuQ7LZY9bW7V8qtpDinE0NoonsvGjQLCvvJkCGOi69h2YbapPAfWhL6U8umivLJ9myE0nzbOhmZk+2dhlNpzb6nV8ExffNW932+Uz8GUwqPI6DgNOWJlwxBD2BX/O38B2qhf3w4sSaSQ/5ubBVhqVhbKxlOhY5YciOaZqi/rwp/x7vSgla/Csi1bn0Rmq48cl1JJiul0XHA09Aqh17+Z2fam449OzgKpm5wSUkWXJTaxohDBccEoTNSIeMlv00vVC6cD+D2QJWtWXLC20f5HMEMOdcKFi15vePhnTqY9dfCzOd6AGp9HVzz5A1HdG9asN7anMPhUh4Gv7RutCpekayKr+mDydv0+Nhyy6w5rechdx+kRymQSQh0WQFjjW4X9pm2YGlrdYMof8ghC/tplpTQ2OQMCTey9BuyoJO0g/OUcUCMgssqYCIXE/QoH0xTXfVKK4fRMo1qO2cd+q+NiO+mEeh0R7eKSCiHBCs0CNl4T3et1k1SYGmiG5jkap1LzaG5q+8T1VAh9pcVcl1GtUBjfI8PBYc8w6Hbhz+v40Nr/Xaa9S4Y8LohjhSmp+D8rAQqgnTCanKPGTXimHUj1PIZQPbG0eZLxWSvT4C150JvMzGATKB6fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add test cases to luo_tmpfs for the file that a tmpfs file is retrieved
into. It must be opened for writing, but can be write-only, and it keeps
its file status flags. It must be an empty regular file on a tmpfs
mount, so files with data, a size or blocks past the end of the file are
rejected, and so are memfds, pipes, directories and immutable files. All
of these failures can be retried with another file.

Also check that an unprivileged process can retrieve into a file it
created, which keeps its owner and mode, that a running binary can be
preserved through a read-only fd, and that the retrieved binary can't be
executed until the session is finished, since LUO keeps it open for
writing until then. The exec test case runs a copy of the test binary.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 496 +++++++++++++++++-
 1 file changed, 494 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
index 47d4fd27d105..27ec750351da 100644
--- a/tools/testing/selftests/liveupdate/luo_tmpfs.c
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -69,8 +69,13 @@
 
 #define SMALL_SIZE		8192
 #define SPARSE_PAGES		8
+#define NOBODY			65534
 #define TEST_UMASK		022
 
+/* The exec case runs a copy of this test with EXEC_ARG, see exec_main(). */
+#define EXEC_ARG		"--exec"
+#define EXEC_STATUS		200
+
 /* TAINT_BAD_PAGE, TAINT_DIE and TAINT_WARN. */
 #define BAD_TAINT		((1L << 5) | (1L << 7) | (1L << 9))
 
@@ -129,8 +134,12 @@ struct test_case {
 	int (*preserve)(struct test_case *tc);
 	/* Stage 2: Retrieve the files and check them. */
 	int (*verify)(struct test_case *tc);
+	/* Stage 2: Optional checks after the session is finished. */
+	int (*after_finish)(struct test_case *tc);
 	/* The tokens of the case are token to token + 0xff. */
 	__u64 token;
+	/* State kept from verify() for after_finish(). */
+	int result;
 };
 
 static unsigned long page_size;
@@ -147,6 +156,11 @@ static int do_fcntl(int fd, int cmd, long arg)
 #endif
 }
 
+static int do_fallocate(int fd, int mode, off_t offset, off_t len)
+{
+	return syscall(__NR_fallocate, fd, mode, offset, len);
+}
+
 static int do_mount(const char *source, const char *target, const char *type,
 		    unsigned long flags, const char *data)
 {
@@ -448,6 +462,206 @@ static int preserve_memfd(struct test_case *tc, unsigned int flags,
 	return ret;
 }
 
+static int drop_privileges(void)
+{
+	CHECK_EQ(syscall(__NR_setgroups, 0, NULL), 0);
+	CHECK_EQ(syscall(__NR_setresgid, NOBODY, NOBODY, NOBODY), 0);
+	CHECK_EQ(syscall(__NR_setresuid, NOBODY, NOBODY, NOBODY), 0);
+	return KSFT_PASS;
+}
+
+/* Run @fn(@tc) in a child process, and return its result. */
+static int run_child(int (*fn)(struct test_case *tc), struct test_case *tc)
+{
+	int status, ret;
+	pid_t pid;
+
+	fflush(stdout);
+	pid = fork();
+	CHECK(pid >= 0);
+	if (!pid) {
+		ret = fn(tc);
+		fflush(stdout);
+		_exit(ret);
+	}
+
+	CHECK_EQ(waitpid(pid, &status, 0), pid);
+	CHECK(WIFEXITED(status));
+	return WEXITSTATUS(status);
+}
+
+/*
+ * A copy of this test that is executed with EXEC_ARG writes a 0 byte to stdout
+ * once it runs, and exits with EXEC_STATUS once stdin is closed.
+ */
+static int exec_main(void)
+{
+	char c;
+
+	if (write(STDOUT_FILENO, "", 1) != 1)
+		return 1;
+
+	while (read(STDIN_FILENO, &c, 1) > 0)
+		continue;
+
+	return EXEC_STATUS;
+}
+
+/* Copy the binary of this test to a new file at @path. */
+static int copy_self(const char *path)
+{
+	static char buf[65536];
+	int in_fd, out_fd;
+	ssize_t len;
+
+	in_fd = open("/proc/self/exe", O_RDONLY);
+	CHECK(in_fd >= 0);
+	out_fd = open(path, O_CREAT | O_EXCL | O_WRONLY, 0755);
+	CHECK(out_fd >= 0);
+
+	while ((len = read(in_fd, buf, sizeof(buf))) > 0)
+		CHECK_EQ(write(out_fd, buf, len), len);
+	CHECK_EQ(len, 0);
+
+	close(out_fd);
+	close(in_fd);
+	return KSFT_PASS;
+}
+
+/* Return the number of pages of the binary of this test. */
+static long self_pages(void)
+{
+	struct stat st;
+
+	if (stat("/proc/self/exe", &st))
+		return -1;
+
+	return nr_pages(st.st_size);
+}
+
+/* Check that @fd has the contents of the binary of this test. */
+static int check_self(int fd)
+{
+	long long size = file_size(fd);
+	void *p, *self;
+	int self_fd;
+
+	self_fd = open("/proc/self/exe", O_RDONLY);
+	CHECK(self_fd >= 0);
+	CHECK(size > 0);
+	CHECK_EQ(file_size(self_fd), size);
+
+	p = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+	self = mmap(NULL, size, PROT_READ, MAP_SHARED, self_fd, 0);
+	CHECK(self != MAP_FAILED);
+	CHECK(!memcmp(p, self, size));
+
+	munmap(self, size);
+	munmap(p, size);
+	close(self_fd);
+	return KSFT_PASS;
+}
+
+/*
+ * Execute the copy of this test at @path and wait until it runs. Return the
+ * write end of its stdin, which ends it when closed, or -errno if it can't be
+ * executed.
+ */
+static int start_exe(const char *path, pid_t *pid)
+{
+	char *const argv[] = { (char *)path, EXEC_ARG, NULL };
+	char *const envp[] = { NULL };
+	unsigned char err = EIO;
+	int in[2], out[2], status, ret;
+
+	if (pipe2(in, O_CLOEXEC))
+		return -errno;
+	if (pipe2(out, O_CLOEXEC)) {
+		ret = -errno;
+		close(in[0]);
+		close(in[1]);
+		return ret;
+	}
+
+	fflush(stdout);
+	*pid = fork();
+	if (!*pid) {
+		if (dup2(in[0], STDIN_FILENO) >= 0 &&
+		    dup2(out[1], STDOUT_FILENO) >= 0)
+			execve(path, argv, envp);
+
+		/* Report the error instead of the 0 byte from exec_main(). */
+		err = errno;
+		if (write(out[1], &err, 1) != 1)
+			_exit(2);
+		_exit(1);
+	}
+
+	close(in[0]);
+	close(out[1]);
+	if (*pid > 0 && read(out[0], &err, 1) != 1)
+		err = EIO;
+	close(out[0]);
+	if (!err)
+		return in[1];
+
+	close(in[1]);
+	if (*pid > 0)
+		waitpid(*pid, &status, 0);
+	return -err;
+}
+
+/* End a program started by start_exe() and check its exit status. */
+static int stop_exe(pid_t pid, int stdin_fd)
+{
+	int status;
+
+	close(stdin_fd);
+	CHECK_EQ(waitpid(pid, &status, 0), pid);
+	CHECK(WIFEXITED(status));
+	CHECK_EQ(WEXITSTATUS(status), EXEC_STATUS);
+	return KSFT_PASS;
+}
+
+/* Execute the copy of this test at @path. Return 0 or -errno. */
+static int run_exe(const char *path)
+{
+	pid_t pid = -1;
+	int stdin_fd;
+
+	stdin_fd = start_exe(path, &pid);
+	if (stdin_fd < 0)
+		return stdin_fd;
+
+	return stop_exe(pid, stdin_fd) == KSFT_PASS ? 0 : -ECHILD;
+}
+
+/*
+ * Preserve a copy of the binary of this test while it runs, through a
+ * read-only fd, since it can't be opened for writing.
+ */
+static int preserve_running_exe(struct test_case *tc)
+{
+	int fd, stdin_fd;
+	char path[128];
+	pid_t pid;
+
+	snprintf(path, sizeof(path), "src/%s", tc->name);
+	TRY(copy_self(path));
+
+	stdin_fd = start_exe(path, &pid);
+	CHECK(stdin_fd >= 0);
+	CHECK_ERRNO(open(path, O_RDWR), ETXTBSY);
+
+	fd = open(path, O_RDONLY);
+	CHECK(fd >= 0);
+	CHECK_EQ(luo_session_preserve_fd(session_fd, fd, tc->token), 0);
+	close(fd);
+
+	return stop_exe(pid, stdin_fd);
+}
+
 /* Retrieve the file of @tc into a new file on a new mount at dst. */
 static int restore_verify(struct test_case *tc)
 {
@@ -624,6 +838,229 @@ static int linked_target_verify(struct test_case *tc)
 	return KSFT_PASS;
 }
 
+/* Set the inode flag @flag, e.g. FS_IMMUTABLE_FL, on the file at @path. */
+static int set_inode_flag(const char *path, int flag)
+{
+	int fd, flags, ret = 0;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	if (ioctl(fd, FS_IOC_GETFLAGS, &flags)) {
+		ret = -errno;
+	} else {
+		flags |= flag;
+		if (ioctl(fd, FS_IOC_SETFLAGS, &flags))
+			ret = -errno;
+	}
+
+	close(fd);
+	return ret;
+}
+
+static int target_rdonly_verify(struct test_case *tc)
+{
+	int target, rd_fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = new_target("dst");
+	CHECK(target >= 0);
+	rd_fd = reopen_fd(target, O_RDONLY);
+	CHECK(rd_fd >= 0);
+
+	/* The target must be opened for writing. */
+	CHECK_EQ(retrieve_into(tc->token, rd_fd), -EBADF);
+	CHECK_EQ(file_size(target), 0);
+
+	/* The failure didn't consume the preserved file. */
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+	TRY(check_restored(tc, target));
+
+	close(rd_fd);
+	close(target);
+	return KSFT_PASS;
+}
+
+static int target_wronly_verify(struct test_case *tc)
+{
+	int target, rd_fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = open("dst", O_TMPFILE | O_WRONLY | O_APPEND, 0644);
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+
+	/* The target keeps its flags. */
+	CHECK_EQ(do_fcntl(target, F_GETFL, 0) & (O_ACCMODE | O_APPEND),
+		 O_WRONLY | O_APPEND);
+	CHECK_EQ(file_size(target), tc->size);
+
+	rd_fd = reopen_fd(target, O_RDONLY);
+	CHECK(rd_fd >= 0);
+	TRY(check_contents(rd_fd, tc->size, tc->token));
+
+	close(rd_fd);
+	close(target);
+	return KSFT_PASS;
+}
+
+static int target_not_empty_verify(struct test_case *tc)
+{
+	int target, fd;
+
+	/* The target must be empty: It can't have data... */
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = new_target("dst");
+	CHECK(target >= 0);
+	CHECK_EQ(write(target, "x", 1), 1);
+	CHECK_EQ(retrieve_into(tc->token, target), -EINVAL);
+	close(target);
+
+	/* ... a size... */
+	target = new_target("dst");
+	CHECK(target >= 0);
+	CHECK_EQ(ftruncate(target, page_size), 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -EINVAL);
+	close(target);
+
+	/* ... or blocks past the end of the file. */
+	target = new_target("dst");
+	CHECK(target >= 0);
+	CHECK_EQ(do_fallocate(target, FALLOC_FL_KEEP_SIZE, 0, page_size), 0);
+	CHECK_EQ(file_size(target), 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -EINVAL);
+	close(target);
+
+	/* The failures didn't consume the preserved file. */
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int target_not_tmpfs_verify(struct test_case *tc)
+{
+	int target, pipe_fds[2], fd;
+
+	/* Like the preserved file, the target must be on a tmpfs mount. */
+	target = memfd_create(tc->name, 0);
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -EINVAL);
+	close(target);
+
+	CHECK_EQ(pipe2(pipe_fds, O_CLOEXEC), 0);
+	CHECK_EQ(retrieve_into(tc->token, pipe_fds[1]), -EINVAL);
+	close(pipe_fds[0]);
+	close(pipe_fds[1]);
+
+	/* It must also be a regular file. */
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = open("dst", O_RDONLY | O_DIRECTORY);
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -EINVAL);
+	close(target);
+
+	/* The failures didn't consume the preserved file. */
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int target_immutable_verify(struct test_case *tc)
+{
+	int target, fd, ret;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	target = open("dst/f", O_CREAT | O_EXCL | O_RDWR, 0644);
+	CHECK(target >= 0);
+	ret = set_inode_flag("dst/f", FS_IMMUTABLE_FL);
+	if (ret == -ENOTTY || ret == -EOPNOTSUPP) {
+		ksft_print_msg("%s: FS_IOC_SETFLAGS is not supported\n",
+			       tc->name);
+		close(target);
+		return KSFT_SKIP;
+	}
+	CHECK_EQ(ret, 0);
+
+	/* An immutable file can't be the target, even if opened before. */
+	CHECK_EQ(retrieve_into(tc->token, target), -EPERM);
+	CHECK_EQ(file_size(target), 0);
+	close(target);
+
+	/* The failure didn't consume the preserved file. */
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int unprivileged_child(struct test_case *tc)
+{
+	struct stat st;
+	int target;
+
+	TRY(drop_privileges());
+
+	/* The file keeps the owner and mode it was created with. */
+	target = open("dst/nobody", O_TMPFILE | O_RDWR, 0600);
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+	TRY(check_restored(tc, target));
+	CHECK(!fstat(target, &st));
+	CHECK_EQ(st.st_uid, NOBODY);
+	CHECK_EQ(st.st_gid, NOBODY);
+	CHECK_EQ(st.st_mode & 07777, 0600);
+
+	close(target);
+	return KSFT_PASS;
+}
+
+static int unprivileged_verify(struct test_case *tc)
+{
+	CHECK_EQ(mount_tmpfs("dst", 16, "mode=0755"), 0);
+	CHECK_EQ(mkdir("dst/nobody", 0755), 0);
+	CHECK_EQ(chown("dst/nobody", NOBODY, NOBODY), 0);
+
+	return run_child(unprivileged_child, tc);
+}
+
+static int exec_verify(struct test_case *tc)
+{
+	long pages = self_pages();
+	int target;
+
+	CHECK(pages > 0);
+	CHECK_EQ(mount_tmpfs("dst", pages, NULL), 0);
+	target = open("dst", O_TMPFILE | O_RDWR, 0755);
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), target);
+	TRY(check_self(target));
+	CHECK_EQ(mnt_used("dst"), pages);
+	CHECK_EQ(link_fd(target, "dst/exe"), 0);
+	close(target);
+
+	/*
+	 * LUO keeps the file open for writing until the session is finished,
+	 * so the binary can't be executed before that.
+	 */
+	CHECK_EQ(run_exe("dst/exe"), -ETXTBSY);
+	return KSFT_PASS;
+}
+
+static int exec_after_finish(struct test_case *tc)
+{
+	CHECK_EQ(run_exe("dst/exe"), 0);
+	return KSFT_PASS;
+}
+
 static int memfd_preserve(struct test_case *tc)
 {
 	return preserve_memfd(tc, 0, 0);
@@ -882,6 +1319,43 @@ static struct test_case test_cases[] = {
 		.size = SMALL_SIZE,
 		.verify = linked_target_verify,
 	},
+	/* The target file. */
+	{
+		.name = "target_rdonly",
+		.size = SMALL_SIZE,
+		.verify = target_rdonly_verify,
+	},
+	{
+		.name = "target_wronly",
+		.size = SMALL_SIZE,
+		.verify = target_wronly_verify,
+	},
+	{
+		.name = "target_not_empty",
+		.size = SMALL_SIZE,
+		.verify = target_not_empty_verify,
+	},
+	{
+		.name = "target_not_tmpfs",
+		.size = SMALL_SIZE,
+		.verify = target_not_tmpfs_verify,
+	},
+	{
+		.name = "target_immutable",
+		.size = SMALL_SIZE,
+		.verify = target_immutable_verify,
+	},
+	{
+		.name = "unprivileged",
+		.size = SMALL_SIZE,
+		.verify = unprivileged_verify,
+	},
+	{
+		.name = "exec",
+		.preserve = preserve_running_exe,
+		.verify = exec_verify,
+		.after_finish = exec_after_finish,
+	},
 	/* memfds. */
 	{
 		.name = "memfd",
@@ -1013,7 +1487,7 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	long taint = read_taint();
 	unsigned int i, nr_tests;
 	struct test_case *tc;
-	int stage;
+	int stage, ret;
 
 	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
 	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
@@ -1027,6 +1501,8 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 		fail_exit("luo_retrieve_session for '%s'", SESSION_NAME);
 
 	nr_tests = ARRAY_SIZE(test_cases) + 1;
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
+		nr_tests += !!test_cases[i].after_finish;
 
 	ksft_print_header();
 	ksft_set_plan(nr_tests);
@@ -1034,13 +1510,26 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
 		tc = &test_cases[i];
 		enter_case_dir(tc);
-		ksft_test_result_report(tc->verify(tc), "%s\n", tc->name);
+		tc->result = tc->verify(tc);
+		ksft_test_result_report(tc->result, "%s\n", tc->name);
 	}
 
 	if (luo_session_finish(session_fd))
 		fail_exit("luo_session_finish for '%s'", SESSION_NAME);
 	close(session_fd);
 
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		tc = &test_cases[i];
+		if (!tc->after_finish)
+			continue;
+
+		enter_case_dir(tc);
+		ret = KSFT_SKIP;
+		if (tc->result == KSFT_PASS)
+			ret = tc->after_finish(tc);
+		ksft_test_result_report(ret, "%s_after_finish\n", tc->name);
+	}
+
 	if (chdir("/") || syscall(__NR_umount2, TEST_DIR, MNT_DETACH) ||
 	    rmdir(TEST_DIR))
 		fail_exit("Failed to clean up %s", TEST_DIR);
@@ -1059,6 +1548,9 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 
 int main(int argc, char *argv[])
 {
+	if (argc == 2 && !strcmp(argv[1], EXEC_ARG))
+		return exec_main();
+
 	return luo_test(argc, argv, STATE_SESSION_NAME,
 			run_stage_1, run_stage_2);
 }
-- 
2.56.1.809.ga0b61035b5-goog


