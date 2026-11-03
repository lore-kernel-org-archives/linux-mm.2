Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C04E606EEAC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dPCqcT2r
Received: by kanga.kvack.org (Postfix)
	id 33C006B05C3; Mon,  2 Nov 2026 20:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4A46B05C4; Mon,  2 Nov 2026 20:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F136B05C5; Mon,  2 Nov 2026 20:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDF566B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BDE3A7C6C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:29 +0000 (UTC)
X-FDA: 85392007218.19.5BFC32D
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id BCE7020006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dPCqcT2r;
	spf=pass (imf31.hostedemail.com: domain of 3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwwQG+MUKlnnlHmIxe7elcqJvGDbiOqx5PQ/fNouiDw=;
	b=WWoRaM4YR91gkeAxerHSDcOkco9WZhKWiHnC4G+RvpuAuWeuLod3KcXABBz9Ib6p08IdzR
	ySWZ7Lcf/3qEuikJEYQNnyDISP7PKOCX/XH2b+voWdqLHe2BwCf2mLJdsFnBlQOoMkVwQo
	i8XKeJB0WI3+azOr4pHZ4RSiJEBixV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667747;
	b=1yRRIVPemHdc8Cnrs0ub4oTM53nKd+ISSOG0Yo/T0q3bErFLqxMl4VqEN6rMyj3eAiJBrU
	9EnCOh/c5ncx3Fd6K0m8ShU8/zcHpN0o88ESbnkeLzL9C6UxvwvsK2bc1+XA64Kl6eVH+a
	lP2SMIWADrc0Xn0PhtXNw+GKNvn1aX8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dPCqcT2r;
	spf=pass (imf31.hostedemail.com: domain of 3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b08364cdc7so18049a91.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667746; x=1794272546; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vwwQG+MUKlnnlHmIxe7elcqJvGDbiOqx5PQ/fNouiDw=;
        b=dPCqcT2rbAgZ1Rw9YzgFKIXBKHWGcGck2WBUNsgOawF1lvHCIkwxR0eBSffj3CKX73
         Sg0Oe6GfHdGsE3W0+YPf54UBDLdHx6e4uSEVVYqYijLQGqeMRFaSAkMp2Ptw1ie5K90K
         wXqOP79ayD1NIi9y2M5DHbTO225/VVJHyXiNGW8vrh/c3a+qtwagi5Tp3jBsLhcPMM7A
         +5+mryYnEspU4kzsdITu4yvAXvpKKHaLGeQyPV2Ujqc1CYS3oeobAjJeeAb4gXh6PWzU
         u72ZJC/ptiGLW30+pu/KcdMdZdY/j3uF6QPUwwCTWsvnDF+R0W7CBoO+rPgKtV7zv637
         h18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667746; x=1794272546;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vwwQG+MUKlnnlHmIxe7elcqJvGDbiOqx5PQ/fNouiDw=;
        b=cAlg8nOxlhnMMLWJZPDsPPShDV+WO1FxOpeBXxd3lvVS/bXrmlNXNm6Joiztp5iyhs
         QZRX3hujgOSie6xZrYvx/eJ4pTrwCffG/RDKEpLR+fIKtVqufHrdn4sCPn0dfdO7+4me
         Zz66xg8RbcJ0m9XxwVmbxJOPhDqiUJXe8+LMNJ4pqJQbkAs7EDNu4xvTb9yXIcUN+iXp
         kLyNaYnFPuPkUIAMrXoDXDkxxGI4NQo4PBmH7EadvF5l3nyfkf6UWZDkRlsvYdNZob1R
         UcvbeTgdscJdV4kNsVvDLIg64VaszU9JT3RfgNiTHNEmIPKWEek3wF/0voJMAQuPUlTz
         Kl1A==
X-Forwarded-Encrypted: i=1; AKwUvBztZU6tzzA2aJsdOgMVqVpifCSfJVmblZHf5rs7ifoFasFkvz3NzPbXpVJAIainbePe8tnNopnDVQ==@kvack.org
X-Gm-Message-State: APuU4Z/4l8xUXjw9n0NmQNFLDpDCmXsxYNl0je4q5GF2GPAlsRZ4F5Gh
	RpEuUdcOOCi2XsRK0s15N1icEAEOf4LvnRmRJMaC9MEZtEegh8SD967icHFVRUQAsGF4K3fqkv0
	LA+HsDrPSWj9zvg==
X-Received: from pgbm15-n2.prod.google.com ([2002:a05:6a02:618f:20b0:cc7:9d5b:c2a1])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d04:b0:3a7:82ef:bcdd with SMTP id 98e67ed59e1d1-3ae898392c2mr9426033a91.41.1793667746054;
 Mon, 02 Nov 2026 17:02:26 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:08 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-3-dmatlack@google.com>
Subject: [PATCH v3 02/10] selftests: liveupdate: Add tests for preserve and
 retrieve user argument
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uy8guk6d1wjsf68ub9zz1o5phry6kmcn
X-Rspamd-Queue-Id: BCE7020006
X-Rspam-User: 
X-HE-Tag: 1793667748-453078
X-HE-Meta: U2FsdGVkX1+6XAuw7negk7a57cOP4FnG5+5a/VN40webJBielSrUcBXRUbeVzgWFM47fSxMUauTCJlezJUir91lewWGvGOzyBxBRp8xDJhVYUil9KsqDcqchbsK5Vj3hVc/KZYNtd9apc1oJbL4Wv59V6/P/GR+ND0qyo9a5zcOChjegbkucDgaMbL0kKjlLaiJVhdp8iS1maFcdo8tuuAznEkt8qxOAlx95RheVx6kgiuirSMWkAlLb2jmgof7QLNHlr3tEFjZhbmJkpgPW40uppeQ8O6NJ9sEhHe6uSqYvvirOLvtRpt9rIeCnWEGBNCVrUW069HitriBHR3O+6MChZ4sIFMG0oGNF48z3/kQNU19bu6zGZbjIu7anIqmFL5iPEIfgwtq/WJFp4cUBA1hhfzPSJJ7+YLl35a6/ZTFdfuxi2eZfTBfvdjpejNOMFVCPB/TZyc29CeJ4oBOas1/o+U2PczlT8Idqi4HR3qi/ufdb6QbU829vYXqJ2oy7squyvAUTj2bPSbVPLIA8c27V0TkN0U0zeVhklzQRPpIY1bB8nady+Fpehlj5T4nm/YPJ28fWSL5sHRqSnTE87yOy5Pfktkii8qUDWazSr2a1vghuoEj+BR9VAW80WWqxYwlHuZEhsyfIEew584JYzCMbJbwshK55Hg5zonVLai8htObM6V5YpKV8p7byn/+dAKlA3yTIyf2bzKv89QpUlUoGwkPd+NL6sjtZOrlrNQGkjlE5HyVGspmHn3tUCI/qmqmY0Zj1FCkx8UHHcWWOrg1kJkoxU+Ku2mEVQemXpizt+JKf2hb0FPNzoqcV4G45ymFL7tTvlHOrAkseuE9MLRTZRlDPy+P9nBu7Wqg0zhGl3oic2wqnpW2ixXchNkO9p/GQUD0M5xnHiImt7MAca1iJH2RxGlzrYv1nH3Ypq7P+lBih1SKCnEmlIZrqEv+BPnWrvOHFT6h+rlOW82+
 tgInXUi9
 ukv9APal2NT8TGd8SqlcHXxehJTUNsMFzWPj7eerzQxEdMVnsg3gnIdaImlTqp1aUCW2ef7bBzWUmUI+U4eCinlyx8aby6grk8FK0aPlY70CqSzef12SPcWV9ptOXRTeYzh6v4/1zv2Gug3TXabpuR8NL4iQfOsLCr1fNhuWhc9YwM1FruFqHLxjzVS9Ga6qVTFiGukIEQ3vZMnINzBc84J0pVaTByoaiTDUqbg1LD6+kG2uhBddxhjmjqNitDI5S8bRi0ZgTEgIYptEOWuNWnxLujvO1GI8NTuFLIiQpLbYNJCcp7b3e1RZPZ2uGsewMFQyhuvUjkmODQABgLMlSww10A5PbOvNQ4WbrU2W7vqRmEQyfNKEutsGJli1iKam9CjxDG0YiMcYsL+WP6iEXqEbqU5GJW8flDfv1Yyg+L0sVrja4lOWcYfUAB6OG1hgRKr2LazdiZJz/v1r6Zkbi6gD3GcVUopJ11+ek+DBQHebs9akbWfvrMmWOuvhtDjGrJBZJOKamqF0HuMN7d279BGJdkIXSkuuHo71bxgkI+/ueyU2qIbuZuy9QxOIhfeJ224pNYb87LkSC70e8Hu/p6syj/hY9tze1GeZNK6+L8LOGU/pDcNGoRvrC+YWOOa3ICvTm3Rmq821mTvEnfsZDKgU18g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Verify the user argument support in LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD. Add luo_session_preserve_fd_arg() and
luo_session_retrieve_fd_arg() helpers to libliveupdate so tests can pass
a handler-specific argument.

Add a preserve_memfd_with_arg test case to verify that memfd
preservation rejects a non-zero argument with -EOPNOTSUPP, accepts an
explicit zero argument, and remains compatible with callers passing the
legacy struct size up to the token field.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/lu_utils.c       | 17 ++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 44 +++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..cd1d843a0d3d 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -29,7 +29,10 @@ int luo_get_session_name(int session_fd, char *name, size_t name_len);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg);
 int luo_session_retrieve_fd(int session_fd, __u64 token);
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..db7a90b002cb 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -79,12 +79,14 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
-int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg)
 {
 	struct liveupdate_session_preserve_fd arg = {
 		.size = sizeof(arg),
 		.fd = fd,
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
@@ -93,11 +95,17 @@ int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
 	return 0;
 }
 
-int luo_session_retrieve_fd(int session_fd, __u64 token)
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+{
+	return luo_session_preserve_fd_arg(session_fd, fd, token, 0);
+}
+
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg)
 {
 	struct liveupdate_session_retrieve_fd arg = {
 		.size = sizeof(arg),
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
@@ -106,6 +114,11 @@ int luo_session_retrieve_fd(int session_fd, __u64 token)
 	return arg.fd;
 }
 
+int luo_session_retrieve_fd(int session_fd, __u64 token)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token, 0);
+}
+
 /* Helper function to get a session name via ioctl. */
 int luo_get_session_name(int session_fd, char *name, size_t name_len)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..4c4272167635 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -20,6 +20,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stddef.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
@@ -530,4 +531,47 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Preserve MemFD with User Argument
+ *
+ * Verifies that passing a non-zero user argument to memfd preservation fails
+ * with -EOPNOTSUPP, while passing a zero argument or using the minimum struct
+ * size without the arg field succeeds.
+ */
+TEST_F(liveupdate_device, preserve_memfd_with_arg)
+{
+	struct liveupdate_session_preserve_fd min_arg = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "preserve-arg-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("arg-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+
+	/* Non-zero arg is not supported by memfd handler */
+	EXPECT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd1, 0x1111, 1),
+		  -EOPNOTSUPP);
+
+	/* Legacy struct size (up to token) should zero-fill arg and succeed */
+	min_arg.size = offsetof(struct liveupdate_session_preserve_fd, arg);
+	min_arg.fd = mem_fd1;
+	min_arg.token = 0x1111;
+	ASSERT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &min_arg), 0);
+
+	/* Explicit zero arg with full struct size should also succeed */
+	mem_fd2 = memfd_create("arg-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	ASSERT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd2, 0x2222, 0), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0.385.gac671c819a-goog


