Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05F5E8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C776B0095; Fri,  3 Apr 2026 15:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E746B0096; Fri,  3 Apr 2026 15:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033E76B0098; Fri,  3 Apr 2026 15:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E84846B0095
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA34CE1877
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:39 +0000 (UTC)
X-FDA: 84618261798.20.D4890E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 479A51A0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3ej2wEl;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDyq9HExdd2NtQmwWnuThiqJJcrLIztXI2KFny+50Hg=;
	b=2Nlehhw3GjF+7GD05QVECkEyOqjPixb+WxERTQg6NdqyArzEnmW5kpqgv3Q2aMLAvhWCNG
	k4YKAk87dPRTO8nJLbasbByvKOxHL+ky4hu6a4RU90trvflnI/Kisr9RDWWCh0AOMXur9V
	dHCm3pKKpyKwuaw9wuNvb8vdGmGYT54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245238; a=rsa-sha256;
	cv=none;
	b=f0K/Z8qICfW44lGRtERutQGgzxfwKEYcfZgPEldxnISn0YVQYANjlAgdGkx7LMR29j90LS
	+g02if2XZbKx38XdIKxNFPwTLtB3qOb4i6FYxWqOirfcdgSgJmdq1OMRdeZ/xlJ1ZZUGkb
	Tj4r6/xCbB1EZE8p8ZHgm51rWhwKca8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3ej2wEl;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D38CD60132;
	Fri,  3 Apr 2026 19:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB6FC19424;
	Fri,  3 Apr 2026 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245237;
	bh=hx4LuheWBNtlwVbJuz9IzDnvXJqSAD9ip7Q7EdlOqnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3ej2wElP+3pm9krk6g11dT5QXKQSXJCjHbUiold3i0U+NJB8RlKfgZcxGbiLUSz7
	 A6VoexLAElGlVS2Q4t7lSFX28GrDvLxgGRkqVuqsTgAmsofO5O+ryPwnOZk/HW7fWY
	 KwYGJGnuhroSM2GPlktidOMiaKIFBeV5JpM2e1nFGFlW+LshjuEP19yqngZgIufq2U
	 /+KfF/d4qQRm5/iMnkyw6OYn2Q8i97CTHv8HthTlYdZD930cYZzZQUn7Bm42GPFema
	 Jf0HRYsmBhlwfgob+j81QzJIMm/OGdp72nhgv9wbjES9lkOMRMvklpnv4jKZZ0f/aC
	 UEMcEsbWjtupA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH v2 5/6] selftests/liveupdate: add test for operations on a preserved memfd
Date: Fri,  3 Apr 2026 19:40:11 +0000
Message-ID: <20260403194014.3704180-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 479A51A0005
X-Stat-Signature: fhd6jgimyysd4gzg9egsbteiahg1gjrg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775245238-287663
X-HE-Meta: U2FsdGVkX18oKyWnV5QBkiGV3IcaQvrZ8fuSs8Zx03V3u63xNGcLawyo9rZpxH85CGlrqRpoPUxb8lzMPVk/XGnsUmu4pmXiK9C7SuQNRvDvleloe2z+Ls7QV8EmBlev5+AzqY1Ld5R4Jg5K+csb/yK4Px7JL3Tj6YhyyunYJF86LST8vuROfNXq9sHukxc3OtlwxFK0RY5JmeaWUoprmQMAgeEytbtQ2Ul5d3CQ5PMp+RXjr4J2RXRfvFdzhzSGJccGw7tMV12OBuLxfbFNnxvNAIkGW/IJ0BU5YaySimOuYH4efoFWpI9QgKBnWV3LtWpsn1524oZJjZ7LUNpHDrfzjRCntI6RWqC9QyJMibqKJwopvYSE3t4gOaAZ2BKJt619xcVwwvj+X6Lq9ZpZk5w7eUwpDefHoNb8kiJeMsLHGOBCTF48d04LJi2An9vvb3oE42CFYi6FNu2ojZ0aS46oeyl9ojNcpDyL1xOuuClnFTva2Kqc4BLvB4fAd2p6d3QjmzwhGbcoSJOdoMrY7RDE1kFJG5Bpt6L5RkSgZgto7JfpkBDDX/mmRDcbcL1m2wvjXhFjxfOxMOdMhaPlMHvXSuNwWs39nbnc2PIO++/5GsjLanyx2V0JA5BmGXx+J78fvi+xmUhH4YiLTpz/vKsag8u7o8ClXEP/ibsgwluJvBSWAsvAHkRgNZJrh7eU+hBQiYnZJS68UZ7le9tG4IJDGEvlyLd7vK9i+DZapiJ77Nhqfo/tfLS/3dIEL7TkUpUk7pUeqc9YNGrTfHn8q6anGAE3nnw9VHiR5upeecLz2ItxBd3YcQcw11I6r93H9RCRfp2xuUxyBrLuagUzdtixPYQTQLb2td/vk9A5zYBg2nN8ZidnTueLZ2HkTI91Vp92o31GNvhrxQRRu94iKEgVttczFl7ofvNw7WwNAU0lxtkWX4q6zQ==
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
index 3ba0709f2c61..a1e9f34da006 100644
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


