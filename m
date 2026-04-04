Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6453AE88D97
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D5D6B0093; Sat,  4 Apr 2026 06:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629F26B0095; Sat,  4 Apr 2026 06:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BD06B0096; Sat,  4 Apr 2026 06:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 316B16B0093
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB2A61A0814
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:13 +0000 (UTC)
X-FDA: 84620490906.24.E3149F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6E418A0006
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYQ7ubCn;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsRYqDdG1gQZV59YZFYazPItw+B07C/bmlzMhMcj9Bw=;
	b=VNzf08zQK4+VydupnDfCXs6jCfnyAHYRI75n71y4JETK5RhbZEL+/CKlSmD45vq9UxO+GH
	PHPuEa9qZ8+fwjpz96cbC072ypgzUjGGcrc6CMyvX/ekQY1bECzXtk7hURPp68K8mH3eOC
	L4J2HGPHiE3W2JbSGmErh4IzDyh+Yqg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYQ7ubCn;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298312; a=rsa-sha256;
	cv=none;
	b=yVigiK3RWRm2/ofTMkiPZNmJEke7jp9Xw+VGNzG+DYdg7f4Pj0t73gC9d7J/BFp8KrLbxZ
	LhMtXAgaigAQxLi5OxTDuMuAwwWKEN8Edp0LcjlVBtu+5x4Clzv2TZ0Dqq5dYUGrDUHSWj
	UfYnosHwGMuTY/O46KlWNE4Wj7tnGlI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A2E86012B;
	Sat,  4 Apr 2026 10:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061D2C19423;
	Sat,  4 Apr 2026 10:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298311;
	bh=yhc+rjmZS+/ri4F15AH1UIS3IbQVJpGORk0EnBOsrJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYQ7ubCnRVb1epQcNt1j443bvLWxuikT4iUFsiuU46MIoNMeVgLQML0zWXDSzi/KX
	 lqPxpdpMEUS7GtjMImivTxeJxMBNqikNRC5Ob9svWrFDvSDnIE5ZKLV+m0Hm/uIloc
	 RMNIVj06ugYvwWO4ZQudVD6r3dISz3lxvpRzRLQk2gSUYbPSIHVhVl/LO4eB+baiY7
	 vLYFjeqIjVnO8urGjlAMtQuoHUZp46a1JLsx38hgFbPlmjPOGnZ3xePH6ezBI+AoAr
	 OKw/KzWXDsyVjDAfaimZD42Fx8eY59/n25MAbWO4lGJX5qHLFuTVSGzO4HFtMY4nmA
	 vg4epi0k04JTQ==
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
Subject: [PATCH v3 4/6] selftests/liveupdate: add test for zero-size memfd preservation
Date: Sat,  4 Apr 2026 10:24:47 +0000
Message-ID: <20260404102452.4091740-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ro7bmmj9m51mwtbn8sfamzrj3xu83fjb
X-Rspamd-Queue-Id: 6E418A0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775298312-729100
X-HE-Meta: U2FsdGVkX189Alkg5REszegt7PD2/NLShjmsWMfpPLFkrOrkcVabSuey50SlnjlNTn01dPX6c4SYpJEHF9mpKkKtSWKR94dZ54EhJKTFfpqH/ms5KFfY5i8d/BJrSmB5zydSVWYSLhGlLOvMlc0tDz80xG8AeEJOakQ+TWwjwWn8F4GH7aDRCjC82Jv3Lsm1tTLnaMbMLTv3fZPsZdc0HCAP2I66rPAwiIWbo92QFdCFXgE4ue/Faz+R/oACtaw0fcxXZMUhFXR65TuaTgWUqTUwWFcvgwLpbL0WynNfrI7FJjvVTSqjO6YegdE1d0LeNGhkD9k29+A/BAX9n9ydi8B35Nm6bUA1pT2ok3H3LlWtHvMZfPAq6XkxiRswNYF0FpRhTDAwxm4JdnBG9mHobao1PvyXu2qIgt8Ocd2s1fG1S+ZparlaLtrY4xbcq3Taj/AwnZxdXSenjUNwXM015r9GETv+njjYtMMe+77n6b+IFVD6bl3riIi8P62gufqVcUymte9UuDHf16DVNbZAqcv1CkEUiudWJw76pPTpr0r/3TQE6iGZ8l/s4Ctz2z35zg9Kvg8D2lz1BBIyHfM03D3ABw9OFUmzSV8gxN/hVCNVlqsmRdK5sczUZKydIxPxxW/nj65A10598QYeUUqyBYtgw+QE9QoXogVEjoMV1e7fmZ5PekLensblupHmBdv9LLt5z111Ii6+DpDwK9psLciXEE8jAw2JYa1ouxj6R3CXOiSQDfQVuQURinyiO8ByD1coq63j+i0DqKy1OUxCbo1YpuETj9gsOfcOJHukYgCck5jziGfMSfaqxyxpRYjBvvAG5CocVPtAyaNAzdyx8wlUvYa9MuBxe5lgFmNss1KLTd93WIgqyw+IoM2D+ek0mbdxOeHK/yMOnyTi/jzaLUPg7qdDwl8j33hcfkOYlhufwfmLyaWnug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

A zero-size memfd is a special case of memfd preservation. It takes a
different path from normal both during preservation and during restore.
In the serialization structure, the number of folios is zero and the
vmalloc array with folios is empty. The restore logic should check for
this and make sure to not touch the invalid array.

Add a test to make sure this path works as expected. In stage 1, the
test creates and preserves a memfd without any data. In stage 2, the
test retrieves the memfd and makes sure it is still without data.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/luo_memfd.c  | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index 068c7f30c4de..2889a21523fd 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -36,6 +36,9 @@
 #define MEMFD_DATA_BUFFER_SIZE SZ_1M
 #define MEMFD_DATA_FS_COPY "memfd_data_fs_copy.bin"
 
+#define ZERO_SESSION_NAME "zero_session"
+#define ZERO_MEMFD_TOKEN 1
+
 static int luo_fd = -1;
 static int stage;
 
@@ -108,6 +111,60 @@ TEST(memfd_data)
 	}
 }
 
+static void zero_memfd_stage_1(struct __test_metadata *_metadata)
+{
+	int zero_fd, session;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+
+	session = luo_create_session(luo_fd, ZERO_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	zero_fd = memfd_create("zero_memfd", 0);
+	ASSERT_GE(zero_fd, 0);
+
+	preserve_arg.fd = zero_fd;
+	preserve_arg.token = ZERO_MEMFD_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+	daemonize_and_wait();
+}
+
+static void zero_memfd_stage_2(struct __test_metadata *_metadata)
+{
+	int zero_fd, session;
+	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
+
+	session = luo_retrieve_session(luo_fd, ZERO_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	retrieve_arg.token = ZERO_MEMFD_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
+	zero_fd = retrieve_arg.fd;
+	ASSERT_GE(zero_fd, 0);
+
+	ASSERT_EQ(lseek(zero_fd, 0, SEEK_END), 0);
+
+	ASSERT_EQ(luo_session_finish(session), 0);
+}
+
+/*
+ * Test that a zero-sized memfd is preserved across live update.
+ */
+TEST(zero_memfd)
+{
+	switch (stage) {
+	case 1:
+		zero_memfd_stage_1(_metadata);
+		break;
+	case 2:
+		zero_memfd_stage_2(_metadata);
+		break;
+	default:
+		TH_LOG("Unknown stage %d\n", stage);
+		ASSERT_FALSE(true);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int expected_stage = 0;
-- 
2.53.0.1213.gd9a14994de-goog


