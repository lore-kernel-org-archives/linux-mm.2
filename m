Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A69CEFCD9D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0EE36B0092; Mon,  9 Mar 2026 07:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD186B0093; Mon,  9 Mar 2026 07:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D516B0095; Mon,  9 Mar 2026 07:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73B906B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:55:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04ACB140168
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:01 +0000 (UTC)
X-FDA: 84526368444.03.F930EB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7794020008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZfhSkk8;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reJOg/6sC4lmxMSzRLRRg9hoXGfhDAxGov9NNB58nrw=;
	b=LBcGU19hCgP00fiDspxAhBYCNWQsMIpxGQvddDHvmpeDJxxxM92KuO2LO/SzmT7Nz1yylj
	c6hwrm7oshlITjFlnMe42leR+w59YQmtY5qbQ0MGs35GlZAxSro2+25DmXLg03p7WVKL+o
	ElS5HfEFSbqzenRvbw3HCuhB+L9/Axo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZfhSkk8;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057300; a=rsa-sha256;
	cv=none;
	b=JxAo7wUKLzj0AJOIjWPdTzNTXueH03YE7lrPx+C0oYSL9aPSSYODcFu5Feh4y6lYTqqWti
	ayZ4HCMy27e97toWY9jpj/RRjcNGMx1SDS5VsYRNycBY5gPBgQ2pbSghmsi9sUEdUtbE+t
	6BUW5T0mY2GiBE1+ZEwWCEvIfyt5pAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A9E143699;
	Mon,  9 Mar 2026 11:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98EDC2BCAF;
	Mon,  9 Mar 2026 11:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057299;
	bh=msGcB9Zdx1CYUYZUlEY30sJksrgQfdKtvara48aboNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZfhSkk80LQ6XowDTBUIF3gokRcMP3Ia+WyiGmzRrKoTsE+ulPe3hhNaMNFdb3Bnz
	 MGw4164XZfzKQElbg4BliKe5j9VgSCGmLRFRdqEg7QFnmJd44jT/M2hqM6pveB/qkY
	 4wbmtpy7l4bs6HbunVsPhH0R1AmZVXG9LrUEc4yLYh8hIx4QO5IP0JyenXnOijf1yi
	 rIZxJphhLRnPzYsiHdCxIq071i6hfltkTIJ0TSFMEecIXdbhK8dRU54ZmfmFFyatk7
	 LVgBXH3NpE3d84tuLBNPPg0QiW5aNdJCnhAJDYdUwvLqvTOjVbJxaquMekC564M0nl
	 L5l1J05HSfLDA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/6] selftests/liveupdate: add test for zero-size memfd preservation
Date: Mon,  9 Mar 2026 11:54:37 +0000
Message-ID: <20260309115441.266805-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309115441.266805-1-pratyush@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7794020008
X-Stat-Signature: iow5j4rfrfm4ok8p1wo38hasxgg3bpoh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773057300-514597
X-HE-Meta: U2FsdGVkX1++nXFNfweHfii3F+yYszu1dThROKlqjI1TwoKHdy1oGrk5tgGOlqyLLGctWwd+UjXpdPvnBNwQIGn0af5q4iLWvtjt057bnU+J3/dgIC300tAx2FjkeHAFiPG3jSp+DjrknkNba5GJkww7HxBL9iVC+OHidVR09Ib1tlNPpDs+Aiqy6COZbXZkdZftVgoxxSMvfVroeZ8fTLFfePi0+tHJLo+ng/JqaTQLQF94stlwPnW78f8i9fwnvVInHcCBlS4xBNSbrHHK9p8f6IVgUFgKJ8blv0pNxkUTNpekehFSvWpuGQt/gMGXONPPpcXN8yLPpI+AxtY+A705JV/jeYqhpYoyZt9XPykuMEAfkrWN4xhvZH4gz956Zfyx36UXBmtVXc8NzAjmHXpalBPN4xI84oCE0M90nGXKK2KUlCNbac719mCSgVpg/cMkT6p+SSil5vRadqEHPjHgUX+a6kOyxBEWhXZShC8553QdwB8IOcIHTX4bpO+bs8G76IiKJCkkRsclDAQp2ljI5q2VDjHHERtlhIxRvVDstho7UPrr8dOoL03PrlcPOGWa5RbDfUaSdd+EFgfcIWPfZBEs46FG3hUfyaIdo3Q8o/r0TOaQc+tGl4LvN/VzeGqzeJf2bv03vaUjqix8tPh/Y46/CGg2yD2CAYUx1NwaZiY3WyS+ekyumiGHyaj4Ol2MhWn9Vwqytz8Ys5yswlS/yUkpr1cMPVNKhSbqm6K34TlBUG3kOdNVzCpdjq5svS7Nt1I05iGCFO7qCjr9OIpCjF5NBHMhF+9Sjt3bCIHY9aTrwU1xWptdcl0GzwE2CDMo1SmqSa3JalMU/SkrTmlpxilGo7ULgWfz4tbYv4V5ZNtoNQR4P1NKWan6X0QHECKEKvAD/k6U7UEUJIqsQeUwEYx40ZN0mFdYDMG0mZpNxHq4WafzMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

A zero-size memfd is a special case of memfd preservation. It takes a
different path from normal both during preservation and during restore.
In the serialization structure, the number of folios if zero and the
vmalloc array with folios is empty. The restore logic should check for
this and make sure to not touch the invalid array.

Add a test to make sure this path works as expected. In stage 1, the
test creates and preserves a memfd without any data. In stage 2, the
test retrieves the memfd and makes sure it is still without data.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/luo_memfd.c  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index 52b5f6b16e19..56106cd09978 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -36,6 +36,9 @@
 #define MEMFD_DATA_BUFFER_SIZE SZ_1M
 #define RANDOM_DATA_FILE "luo_random_data.bin"
 
+#define ZERO_SESSION_NAME "zero_session"
+#define ZERO_MEMFD_TOKEN 1
+
 #define LIVEUPDATE_DEV "/dev/liveupdate"
 static int luo_fd = -1, stage;
 
@@ -89,6 +92,50 @@ TEST(memfd_data)
 	}
 }
 
+/*
+ * Test that a zero-sized memfd is preserved across live update.
+ */
+TEST(zero_memfd)
+{
+	int zero_fd, session;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
+
+	switch (stage) {
+	case 1:
+		session = luo_create_session(luo_fd, ZERO_SESSION_NAME);
+		ASSERT_GE(session, 0);
+
+		zero_fd = memfd_create("zero_memfd", 0);
+		ASSERT_GE(zero_fd, 0);
+
+		preserve_arg.fd = zero_fd;
+		preserve_arg.token = ZERO_MEMFD_TOKEN;
+		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+		close(zero_fd);
+		daemonize_and_wait();
+		break;
+	case 2:
+		session = luo_retrieve_session(luo_fd, ZERO_SESSION_NAME);
+		ASSERT_GE(session, 0);
+
+		retrieve_arg.token = ZERO_MEMFD_TOKEN;
+		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
+		zero_fd = retrieve_arg.fd;
+		ASSERT_GE(zero_fd, 0);
+
+		ASSERT_EQ(lseek(zero_fd, 0, SEEK_END), 0);
+
+		ASSERT_EQ(luo_session_finish(session), 0);
+		close(zero_fd);
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


