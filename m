Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD670D730AD
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340416B0093; Fri,  3 Apr 2026 15:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA266B0095; Fri,  3 Apr 2026 15:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8936B0096; Fri,  3 Apr 2026 15:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0656B0093
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1069C10F2
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:37 +0000 (UTC)
X-FDA: 84618261714.20.68F8499
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D75240009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ITI6lWTo;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMRnDakgnz0Oi1dOG2GEDJBmFicXVDDo5B3kx6YpuWA=;
	b=mFlNRPQjDrypggs++qMYRceH+2BtRMK32ZDxG3Th4Z8IHfaFfYv7sI5XwH3jEqhYx0zUZ0
	x19+iX/Fo6bobdW2CaQ964+GJ0d3ErP5KcYan9Qv+0R/L6Y1+kklCpghNjn/RCJGd0FcnG
	LC5fN42zpLAtjDu51nxvs6oMk1q/UUA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ITI6lWTo;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245236; a=rsa-sha256;
	cv=none;
	b=M6woYrDvbAJ0GgJL1S20vpRMLSIBcWDp/s/DVMzdbCe5qyIno+QDxJd5oxJGq4/nMOWbX1
	4Y5x3Fnv88uzTh+xuO41YCLnwLVvdRKXC9isFOdgg2veHxfOfhySnAx5sLS73E2Qo7HvGH
	wwVfJwxwfjHO4Kts4zVxwM/kwtCva54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 87ECA60128;
	Fri,  3 Apr 2026 19:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E04C2BCAF;
	Fri,  3 Apr 2026 19:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245235;
	bh=FJIlVUEHAp7ZJEKT0idl4M4VyELOXTlHEmJHYyO6eBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITI6lWToNau7UFzXYD5NG6S04w5VvF0y9PiRgP8aOTF8SaPWU0ntqT+ztUJHwCQsQ
	 lFVEWyHtVOSgin1AwMzWxwxHaXokWKEr12q0OSjUSg64SQFwpnOf8f4y3a8YQ4/On2
	 9yaFxndaJx+FCSG0610AJQfawQNYrkDmAnqVHH4s4WpQ+6vQcm4/g3kESjOm6eBVlU
	 WY017tHR10glhlBpnfRshzKObMqgQ1XA677drxqveJMqzq4K/Km8bRQ2QDrxabyOxj
	 emAl0D4bLmYM+V3qsYgwFV5rQhev7Zxg26TKN4Yo+0IJF+3314bz1X3YBlDBSQLSk4
	 dw7KVccZMB7ZQ==
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
Subject: [PATCH v2 4/6] selftests/liveupdate: add test for zero-size memfd preservation
Date: Fri,  3 Apr 2026 19:40:10 +0000
Message-ID: <20260403194014.3704180-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t67kcnoy73db4qcgrebtq1ajmn1ayd15
X-Rspamd-Queue-Id: 1D75240009
X-Rspamd-Server: rspam09
X-HE-Tag: 1775245235-704126
X-HE-Meta: U2FsdGVkX1+jqDLtbQLPrlfqhdCQ82Y6CNQJGXJCAXUCOpcSnLwd0U9z7Gw7j9q0YkPGTfRsl1TVUzl9PKZmA1q++nGbF7nC7JP4I31QO8a2Q9k9IVymVrIetyiM5YFdLXOYUbRw/xyyHaOCEIls9mun5aJIq69KsqqnYdbQU4c9YcGd6RXvwGnxXB1j9Mr4QbL0vv0KkBUzhOotyitHQNgwQvjhtkMwM0YcW+/piEz7UOFOv4W7D2lkzajkVCDfEb387iAdkz2E7P+xS08opd3cDUthBW4U7Laa8ISig/jfqoIkbnIh3Sg+fv4paoXfGrS2OF79D5veS5Jriv4QU4mmCZOZR1mXK0ZKGRrsRJNPfw/vXDgrpZ25GFeE2JW7Os+EHyG2qxSFX+FHzWV+Pe2J+Dege6xjLIKQrpAvDL+PXV4b1wRRCQnFhecDQ3R6Lo+0OO6PMOV6YksUP4GoawjylP+57XP56ZWz2EDOvKqOezbySTNdhYttR3TKoZuw6GLEze76snb3zRUeA9cCyvWwZMFLELLU1tA1xbtMr3DoeNssc/XPwsEu4Tn+SF0RnBZBjPwK5y1gvBTJgF0E2KAbmrc4UOCINEefOgKDRGQs97WWbIkcoET/wH+QtZpKlk7YdhJHz7YVHY5R5DPOdnlzKclUWJWL4IurdEe49IxzSoB9+OF6c5iUyNUOOrGu2Jp0JhPbhHFr8Ir0r1Qo3WeVcDrq2a8QrdlSbW55bvxv2Aw+/UsIDPeHW0mOTayZm2+axPZne8d/hu9P/MaD65NbM0N7EqbUVS2c81c5Wt/HM7SIDnktZPHKDsjEGvKCorb5Pu4TNOK+ywgDrvZu8YoO4xRBa+r0b6N7IO7ew+RZwfQxJSw00rMK7lCgmCkSMMFzosrflwfw41FSRPQerecyjYLTNm5B1QEj+JorC6706hI7wUc+sfvWRaeH8cJF4OKjpat9Umt8tcDmKRL
 bCjyGZ78
 U+AhKMLPjbiodz3VvSBW50W/1+cf9OVXPK0FHpXlJZ8l/XdXMy+nnwlt9DXt2MTA7PKf7VGnIWv2dnV0p5vZlH8NDptQ4FfD1JXruEh/xi+G9YkM7SBayJdqVn2WXDuM+lwGEZ82PaS5M0yPDWurx1mUKqJqDjo8ys9Hc9BTzVshvZpf9WVllbe6irBwEGoP19Wy3lyDLroly4f+V9GoWdV20AQnkIwvQ4feMP827z48ky6E=
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
index 70eb96950f04..3ba0709f2c61 100644
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


