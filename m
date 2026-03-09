Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C51A2EFCD9E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6FB6B0095; Mon,  9 Mar 2026 07:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FA46B0096; Mon,  9 Mar 2026 07:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E300D6B0098; Mon,  9 Mar 2026 07:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D47236B0095
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:55:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F6A91A015C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:06 +0000 (UTC)
X-FDA: 84526368612.17.D016D26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB7F6C000C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQZeh5kB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuS6N4Q6edhG9dPnsoY/98RI873leHcWBHdoTPyTaAQ=;
	b=SSe49EOJokrj5UCf7OPiUW432nE2NdXrtN13RaRJ9WtgA8xZ7c5xSy+QOgK39KqZsQyjOM
	mTLkYZErBlQGUnAlMzyxXgPqy5Bw+VHH7i1w3Fw7aYPpJVNSzAG6ilrmU8nXSWZ1lsWbyx
	YdZoWNmn3naeEW+AWjEixO1XZqg1rHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057305; a=rsa-sha256;
	cv=none;
	b=2lxBzFfCLgMshqXHSU/DQPCb4g8tS+QSggd0OGIgqfoBwscIz8ZHeeKJdRjIrBCaHHOOEz
	ih8RVkl0fq3PlLoWJrcXF1cZds8cOpncGzpFZkHT90kNho64c/Ub3EGWC5P2Nlj+7+1cGn
	hAHVt4tjKl1SuSI0A1xKHokxL2QSDiU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQZeh5kB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F27D644235;
	Mon,  9 Mar 2026 11:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310F8C2BCB2;
	Mon,  9 Mar 2026 11:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057303;
	bh=6RXZOME/fI1l63GcOwoRovNmREiLIcVnjWmc5XmjY64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQZeh5kBgJ/ZWCqVNeQ+F4HO+HIquSD9vTuIBzKtqtBEJCvEmmR4KehU8FiXOZgIw
	 OWN6/YnE2DKORuQd4J510m65RqNhfsY0aq6DzmuyBsCg+mNThgyIblpncAJeItvys7
	 Z1tttz52Y9an2AkpwGj1DtiILYbeyrci6kIOY4+3ebU7AByEMbxutKT3/o8hXu++2z
	 SRfn55ud3pVBsW0pzL9AwwZ3PgAPTRWA+SIs4otVWV+v5RDcZGVlqxlLoWogEdC1Pr
	 hkZh8aBQTZTR0azHl5joWDugVJzWStVNhYnklEeDloS3Kg3fJvwPTq9x2hTMagSkvD
	 QDRdcGjvTcTzA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/6] selftests/liveupdate: add fallocate test for memfd
Date: Mon,  9 Mar 2026 11:54:39 +0000
Message-ID: <20260309115441.266805-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309115441.266805-1-pratyush@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB7F6C000C
X-Stat-Signature: aah97657snpuj88udih4ewt5dioeq5go
X-Rspam-User: 
X-HE-Tag: 1773057304-649479
X-HE-Meta: U2FsdGVkX1/G0+zn1DOYcKauvlCE9SK3IE3RWIXhHyStrM4ZpjaRtA2IIMyPdk/DHVlUsm2W6uhbIOf/iBc23blNR4xwH2dWkxKH4r0Nv3zQ+hv+CHlOPnZv+BwB8MW3/XDImNoBr8xY0OLY7cyftbyiHpRXbFmFaSQ7m19SJ+KYW0Y7V8O6+8WMJlQtHcvFd5bpblpuxFxJN64Fd/RnVcUFO/7KaFfUQCGLsnKNpegKZWEubFORXnsVL6JKIp9p6NRI9VCLYKKw9WnFPNlOy1KdyxOfdF8frY424WPrLMV1C2R0tZpOTZFT21iZf5GSZ/CfoEGj4eeOM8xGXzc3jteXj8Ts7IeAqMmAVoItR4ylRYLmTWBVyX7Y8jaF2zLwq/OpffHYYGfH0sShx9NIb1cu9l+pK5Ycb3widD6vwjcesIa7Jo3SPoyLWGf3s1Fp/5gr7kLb9EQppaBSug6EE+6m8w2/QYtl3v9Nc+QzBCWLK/duqEsYU7AZSCAjFkr/oernwLbLUx2nMPB/qiYqSISTcqunPVO0okr+Xy0kwqp8Aaunauo1hoOrFTZdPJqffzK1l6OrWUcGaEy/vvy70GfkvqTAMcgsAxOqkSw29bHU1BbWUogzknVJt1StkbR8Hl48/ZiQtRbbpimBZo99AO5tbZ6DoYOlTcOd8bGOjlzH6TRKocOq+7h/qK48h2Y9dq2XwfmE+dVuaXonX/4UmqDTouudO2PAvhv1SOqjK2V/CiaPD+fysM6XhzAbLcEFHtSB9vdUQxGznCxaOqhoEV27E/SKfnGs71NhOf18d+ECXARoXQLKZRCVw2gRKaulSRAhTiXn5Eb7o0WfvDtb6jU6ms0KIUD+di6PRjt8k/vr7tEyhyCMTRmvME8Vq8RcG4ehMtNEXpiJPpJwl5QlcBCbS1hA1RwQYoIiKdHzXZoVTvyAb7b8olTx8dQOqO+T6OdYYYNmpLbaAUprZEi
 dIXGqWVT
 IybrnJYKjfJLX7raFYPBaVDttq9DrWwgY4s4d3btc1GiBGLtqI9WyG2392ABXU29C5iF4zY1Jn0gCFCCw9fgACYyz4x2Jd33Q26/zLdkrvNWSxcposdjyfi/5fCQ+Ze3FCQqSsNvqRM/cdiUB22kIdpelTBLJIyT57CE2hQtB3z8jQ8rgI9/rB3DSS/66Iyx6YBq5w3EF4NvXvrwEiMcNsVD/+LQxHOGi52JT4GX/JSFEc1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When memory is added to a memfd via fallocate(), it does not get zeroed
immediately. This is tracked by the absence of the uptodate folio flag.
Initially, memfd preservation simply saved the folio flags at preserve
time. This led to a bug, where all writes to un-initialized fallocated
memory after preserve were lost after live update. This is fixed by
patch [0] (not in mainline as of writing this).

Add a test that fallocates some memory in a memfd, preserves it, writes
to it. Then in stage 2 it verifies the written content is still present.

[0] https://lore.kernel.org/linux-mm/20260223173931.2221759-2-pratyush@kernel.org/

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/luo_memfd.c  | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index 75f88101e7b5..dde3c78db50e 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -43,6 +43,11 @@
 #define PRESERVED_MEMFD_TOKEN 1
 #define PRESERVED_BUFFER_SIZE SZ_1M
 
+#define FALLOCATE_SESSION_NAME "fallocate_session"
+#define FALLOCATE_MEMFD_TOKEN 1
+#define FALLOCATE_BUFFER_SIZE SZ_1M
+#define RANDOM_DATA_FILE_FALLOCATE "luo_random_data_fallocate.bin"
+
 #define LIVEUPDATE_DEV "/dev/liveupdate"
 static int luo_fd = -1, stage;
 
@@ -193,6 +198,65 @@ TEST(preserved_ops)
 	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
 }
 
+/*
+ * Test that an fallocated memfd is preserved across live update and can be
+ * written to after being preserved.
+ */
+TEST(fallocate_memfd)
+{
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
+
+	buffer = malloc(FALLOCATE_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	switch (stage) {
+	case 1:
+		session = luo_create_session(luo_fd, FALLOCATE_SESSION_NAME);
+		ASSERT_GE(session, 0);
+
+		fd = memfd_create("fallocate_memfd", 0);
+		ASSERT_GE(fd, 0);
+
+		/* Fallocate memory but do not write to it yet */
+		ASSERT_EQ(fallocate(fd, 0, 0, FALLOCATE_BUFFER_SIZE), 0);
+
+		preserve_arg.fd = fd;
+		preserve_arg.token = FALLOCATE_MEMFD_TOKEN;
+		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+		/* Now write to it after preserving */
+		ASSERT_GE(generate_random_data(buffer, FALLOCATE_BUFFER_SIZE), 0);
+		ASSERT_EQ(save_test_data(RANDOM_DATA_FILE_FALLOCATE, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+		ASSERT_GE(lseek(fd, 0, SEEK_SET), 0);
+		ASSERT_EQ(write_size(fd, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+		daemonize_and_wait();
+		break;
+	case 2:
+		session = luo_retrieve_session(luo_fd, FALLOCATE_SESSION_NAME);
+		ASSERT_GE(session, 0);
+
+		ASSERT_EQ(load_test_data(RANDOM_DATA_FILE_FALLOCATE, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+		retrieve_arg.token = FALLOCATE_MEMFD_TOKEN;
+		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
+		fd = retrieve_arg.fd;
+		ASSERT_GE(fd, 0);
+
+		ASSERT_EQ(verify_fd_content(fd, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+		ASSERT_EQ(luo_session_finish(session), 0);
+		break;
+	default:
+		TH_LOG("Unknown stage %d\n", stage);
+		ASSERT_FALSE(true);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int session, expected_stage = 0;
-- 
2.53.0.473.g4a7958ca14-goog


