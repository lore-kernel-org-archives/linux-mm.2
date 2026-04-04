Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1491E88D98
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58B0C6B0095; Sat,  4 Apr 2026 06:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDC76B0096; Sat,  4 Apr 2026 06:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5016B0098; Sat,  4 Apr 2026 06:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 250626B0095
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B843A13BB4B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:16 +0000 (UTC)
X-FDA: 84620491032.19.242ECF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05764C000B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LU4xdOV0;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zu2VOCG32vL02sa96w2f0WP91XK2rbRU9L9UqsylM7Q=;
	b=JOPbcm7rqci+OJ5jSVc82Lw88RF/aOuC8yW1YGjwhvlfMKp6ZFYH61i2IE0L4/8hw9JZuy
	tZVJ6UdP+kRXtEz6M6kNAM5BS1cUXGt/YReY1euvqPdVevRn8ScseiEeplSHBat3E4EZI8
	FnoeqbLUhNzDWwRi8aQ6ZuCXwE6yfds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298315; a=rsa-sha256;
	cv=none;
	b=Y+ttgWQ9pS/tT1PczCLz84Vi7WMKt4kbXAaw2IipwNlK69CZgDDBIo1PvFW6yBh54ax6F2
	GZldFtKpLPHFyriQvTPMsTH1nuWoSV9ynNmAel8X0DS77lyqNeR4z1PcErVFQNvoY49hIo
	E2KqLzfQmpseYkcRbEw+tRGIsrzjTSc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LU4xdOV0;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3896943DF7;
	Sat,  4 Apr 2026 10:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4202AC2BCAF;
	Sat,  4 Apr 2026 10:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298314;
	bh=JfLttArZOADtfi5TGZ0YNDYHW3nPoKjJ1lSo350PlLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU4xdOV06IMSDczZpzEpiO/sssF/KovagN6uuJsWEJEOtmpk0im6gHS5tDVGSjFHX
	 FB75OF+rYDWTr2D1DLz/yLtcUcAk16Dq4g1hO9WSLskBQ3vv1bn9t49uWq6BcBpRXL
	 VDD4aDUu8vs4Li8OtsFWjL6ZwWfTpmUBPJyJlU9yyfYEAOUk+0U3yT7YK2Geu1w0gq
	 vZfCqClXMHnoLlt2PMm+rykqOgYx2o1wOqpGVLAh3+su+bJiD2sC9RU5hTjGldmDG5
	 TuBa/R36+4OcxHu1GzI3bckMwYQ4dyE/nr7612/dajhw5uJCemaaQ6ImoRIDYuQNff
	 QBjo9/IDOO1qA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 5/6] selftests/liveupdate: add test for operations on a preserved memfd
Date: Sat,  4 Apr 2026 10:24:48 +0000
Message-ID: <20260404102452.4091740-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05764C000B
X-Stat-Signature: 1kxpx6587jd171fs6kkoup77crk4n3oj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775298314-934749
X-HE-Meta: U2FsdGVkX191ixwxBb0O8dT6KNMM9EzmtrDiAz9F+a/h5d3FIHO3/+YsHdW6Ki2P4ceVsbkr/cNEiAt+GA0JB/hSQV24TsG3neNT3ZO6aCNa3+UxWJQt4nJkFvDmid+YakzDBjWSnQ/znPFYvmcGhPIwzu0iQbCzZND9nhjGR+BbSirPO3WKcFdovAGa3qlJsuWRyVp6MFURG0L3ebNZLd/dvUb86ibO8JpKGipkKFhN29a5xcfkyS7R/DIIsKGd0wKIN+Qj2Q+KZnXGH1OnM8LAnLm6KjQvtzsyl+rOQ4vNVinUfCzHKSF/I5ptjkv7nQCadzvAW0oHSDbIIUs4e3MqO5rbtZo/eLF1epQt8EDLNE64RyXpC3EFAANqcFlDlsaGOuX/UAt/MrvsN2QIMUDUcS38l9DXwCBF/nPjZg29mEJ4NDOljKjJsS/i3ftaYqPIqT62XOpysogvIOUE4Q8ctV/mjqq7xKBtK+dt7cyGMehIIGD+J57sKzEGyLSlOImcTTp4LXVCvFCoysX7ai12Sl45ADtoiun89pcCBolWe8MATmt8vpRy+cOtf+4ooVIxqFBttbneuG/YjcRJVMAlbMZc80mZ7/S/wobRMu2kwdnLbcG0zt3fw/cZVyQucQOdL7pJJVOuGlXOAP4uF11eHljiW4zx2Wn7QZmx5sr5z+bCQRfjTPNQlQgzBOwKAWzFtad7Z6Um+6B/pgf06hMz52aObscpQsvQGSj9ann98faqUAnuisevZuocvvCVRC2f/o0WLRuQsUkNScddEwkpiXeeowpPAf0u3j8xmlWoyVNKlGWsUs9O9fE8oQVzOyTuzawjU7hheygLqtiVGD4PNr30fy62DxlMe5ZB9CXPbEIPcxeT8judDP3/bOjLsBAIauwsLxQKYA2xSVmydznCopi1ceE/h35NbyPc9CeaeNLkmmrMeTfdWKG9UNuAx8mjLmB2HAE3FAomY4O
 uJbOda/8
 Gm/UFCBM6V/gSg8jOBowkO95+dCG21vzq+Cp7YZ7t7HN6XQUbMmEg5YtOYcfbjJ2Btm6P6OIquGd8/N1DbeCfFJQi23ERS0Y0tKjo4cPP3EiziNzgnZqA91erLwXZyVqiKaEQr0UbvV6sftooCunl3os9CP7QS/nQUZuj5nQSwj9U00aroUW1AGMZAWM3ZNF3auy6X1HRjznHPchwiApDPY6KIT4lMf5eXoZM8PspXXK+JHPL5+zi+snYtpnKWD2gmBwaF5CRfVo0Tlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Once a memfd is preserved, certain operations are not allowed to
succeed since they might make the state of the memfd inconsistent with
the serialized state. Among these operations are truncating or growing
the memfd. Writes and reads to already existing memfd should succeed.

Add a test that makes sure a preserved memfd does not allow growing or
shrinking, but does allow reads and writes to existing memory to go
thorough.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/luo_memfd.c  | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index 2889a21523fd..661a7c922e9d 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -39,6 +39,10 @@
 #define ZERO_SESSION_NAME "zero_session"
 #define ZERO_MEMFD_TOKEN 1
 
+#define PRESERVED_SESSION_NAME "preserved_session"
+#define PRESERVED_MEMFD_TOKEN 1
+#define PRESERVED_BUFFER_SIZE SZ_1M
+
 static int luo_fd = -1;
 static int stage;
 
@@ -165,6 +169,59 @@ TEST(zero_memfd)
 	}
 }
 
+/*
+ * Test that preserved memfd can't grow or shrink, but reads and writes still
+ * work.
+ */
+TEST(preserved_ops)
+{
+	char write_buffer[128] = {'A'};
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+
+	if (stage != 1)
+		SKIP(return, "test only expected to run on stage 1");
+
+	buffer = malloc(PRESERVED_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	session = luo_create_session(luo_fd, PRESERVED_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	fd = create_random_memfd("preserved_memfd", buffer, PRESERVED_BUFFER_SIZE);
+	ASSERT_GE(fd, 0);
+
+	preserve_arg.fd = fd;
+	preserve_arg.token = PRESERVED_MEMFD_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+	/*
+	 * Write to the preserved memfd (within existing size). This should
+	 * work.
+	 */
+	ASSERT_GE(lseek(fd, 0, SEEK_SET), 0);
+	/* Write buffer is smaller than total file size. */
+	ASSERT_EQ(write_size(fd, write_buffer, sizeof(write_buffer)), 0);
+	ASSERT_EQ(verify_fd_content_read(fd, write_buffer, sizeof(write_buffer)), 0);
+
+	/* Try to grow the file using write(). */
+
+	/* First, seek to one byte behind initial size. */
+	ASSERT_GE(lseek(fd, PRESERVED_BUFFER_SIZE - 1, SEEK_SET), 0);
+
+	/*
+	 * Then, write some data that should increase the file size. This should
+	 * fail.
+	 */
+	ASSERT_LT(write_size(fd, write_buffer, sizeof(write_buffer)), 0);
+	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
+
+	/* Try to shrink the file using truncate. This should also fail. */
+	ASSERT_LT(ftruncate(fd, PRESERVED_BUFFER_SIZE / 2), 0);
+	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
+}
+
 int main(int argc, char *argv[])
 {
 	int expected_stage = 0;
-- 
2.53.0.1213.gd9a14994de-goog


