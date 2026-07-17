Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FD7C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37BD26B00B0; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352BA6B00B1; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243636B00B2; Fri, 17 Jul 2026 12:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2B546B00B0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:24:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 023B9A00B4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:35 +0000 (UTC)
X-FDA: 84998416230.01.3B97CB4
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 782BD1A000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=DvCTdk3y;
	spf=pass (imf19.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Inl8/8OF7icdn7qRzGuxWS4G9tqlBzia12zj0KezmwE=;
	b=c4TIJAG1m76Tngj3GCsyZ3acEjrA3vPmMvdrvbmMk0LX5eKCCzqS+CrZmPn199+d+X6PGp
	1eH/d+e53NzL2ELcaekEa14iQA9xcxiakdJA5xP8NmBnaYibsjYdGSAkNzsIkUoOYCPJUk
	RQy2e5+VFatcWuBdFJZ4tFg+8U1KNXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296533;
	b=uzj+e23cPFW0eHn+5UDd1rZOVRI15SzwMqFPjOyKFOOa5ol/fr9tOIINqKa+8+jE4BEyp3
	2xEb5xnIgVOIFz8ICCfB9HcaqiA4chdR5rlUtrJk9EXyYjLwCWTKkh4fe3UaCajN+vmRKq
	50CHr5k+jZ9x2aYExEzqELFZFm4HPUI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=DvCTdk3y;
	spf=pass (imf19.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=Inl8/8OF7icdn7qRzGuxWS4G9tqlBzia12zj0KezmwE=; b=DvCTdk3ymiYp8XDSQsKFehiR4q
	UVRz7k0yrWjtG8tV2PAE4XG4iT7yEh6zMOm4v4SVei4SGHApbIWis7Ame2FLmAGTGgt0v6fViimAl
	cAps70L1iY+x2R5XBVYnsbeSw0IcLBQxTaRmGv8EObEIAVwHrWMYDUadW8mOB0NSP6CC8g0RwY06S
	Lokv+vlMWnSb2lV7Qlm6ZtTmuylO1SbKTcv9oIQm3vcUYFZZRNJJgrrl+FCEYMdXZF9He8LaASbhR
	K5eIifwuJ78cF8Xd5Lg27MTNpS4g3vq/T0Xq61htgHhA3pDyvKyDp2RUVCT9YONfTXYxOR3VMjiOr
	BDsOMpFQ==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj2F-00GXeM-Lv; Fri, 17 Jul 2026 15:55:27 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 17 Jul 2026 10:54:39 -0300
Subject: [PATCH v4 6/6] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260717-tonyk-long_name-v4-6-1fedfc870d21@igalia.com>
References: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
In-Reply-To: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 782BD1A000C
X-Stat-Signature: j3he6cjhroc63s13t5yngqikwmg79dyp
X-HE-Tag: 1784296533-633467
X-HE-Meta: U2FsdGVkX18L+vgvfH7pQXXwb0TUMcCxovmJdZHEMuY1svwEBoBDW4+I3rBbQXm1Jjnf/J8D6ZB37agq3w4MCTE6fT2EZ9/9izJ+ku7PP5vg/PwVPogKhr6KMgcudx0Zul9KiUB9+S6Ju/HimDSyUFQyUXyaljBim/cizCS5m2Per7F+6z1NpY0zuCybabrbNAGw4SYhmn3RfBaZODg3e0yboB+X9QG+3aXTmGClGFDiMMsupvwfs5jTuxNeOwzFjTi2svfOgT5yTcsTUwFOXOO07oBq1e7ZPWG7kHt382aSLHn6Wu1ZZZv1Xpfjx7p/ahuc6dgJyumWKkrJaDWSirpWLl/g8JN9LomQKvOQaoehLzbNMcLVSyCdPiDv9ExSepIWBIlvqb/TvvzEQQ2RnylzzpgrjMHD8+WKw6udrE6dmCJzDwIH4739uNuZ4sxYOGfJ2AoF08o5uVmVhTaeRS9rP4wa1AnzSO5EGPoIeWBYnuOKX7C+UrbrN4mmJaCeNekwZfscZNEkTBfV0m+TtLdgW/i8PXSHgETiZ0vvo2HW7WPXUtSW7Z/fqYy4Y6Yc1UfQm0UeGrUpQrNg1p55ItrWRXyFJooYz2QlIUM3CJu0RlSpp7fdph5ArdtwCaEEWUsWsGY1iBZ0Q4xu9Ls+hI7jJcdhn+aXWZ50wDtUSb/adDj7YX5NiOxYQgSVMQQD6CZuFZ1UHLmrIYj9eTDZeMBgzSOj04Ijs6NwxZsAtXL0ZefDE9XCZL8PKQTdVr6/unngjw4kF73EwoDzaOntdoIkMD4BsvJtOV2A8ttRjg0mvNgO/7Jh/hJjmi+1SRotQFuVBN4gEet+S+yf7cBYmmiKrxX3GS7h3+GNqQVNqm7ISz0TF59WU9P17l/JuLGuqHrU5IDeQpbm1HGohiCLdKwC7FeP1WkjhMPW1+lkUNzJRJvu/2P8ABwHb3lYOGg4+WKAUFATBQKtlBucg2Y
 V+74iE6Z
 cjFCZarbI33wxVQV2jh112eIGk2ZVuRlK1qGofuEuZ/5gEuE8ErB5kzwdkclp4AKCjEWDuvDmzl71tnGYvFxqrJF31ldD7wfqzBKpTfyPSwyoFWI2pQ/JZq4IXFMul2fkYMQbmD2RkVJciBMkQ/gg7ulxoKn1PaCMsVBaopFnC0BoNVx8Zrvixk/B2wFR47+VsX4+dGGGDQMeJp7MUddy+jp05jlCioXTTWhL8I+2vR04f+lIaR7DkFOV5XTSn9q7IQYgEiw7MD8zzmxzzm80CB78B4UMCjIG+dxVqT3+OvAx7z8OReNsaI9Z1nF460Nuud7cGXGtmHxFjl0isKc4jHc/S2L3IWYB8nCttFHo0dbdoNazTGsR/Jp4baxNSm7BDKwKpansHVNQCZEBWARcEeboUSTIi5Sz6nMZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tests for the new interface to set and get long thread names. The
kernel should accept the LONG_NAME and returning it accordingly. For the
old PR_GET_NAME interface, the kernel should truncate the name up to 16
chars. /proc/<task>/comm should return the same string ad PR_GET_NAME.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 tools/testing/selftests/prctl/set-process-name.c | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..0f20f7deac67 100644
--- a/tools/testing/selftests/prctl/set-process-name.c
+++ b/tools/testing/selftests/prctl/set-process-name.c
@@ -9,9 +9,17 @@
 
 #include "kselftest_harness.h"
 
+#ifndef PR_SET_EXT_NAME
+# define PR_SET_EXT_NAME 17
+# define PR_GET_EXT_NAME 18
+#endif
+
 #define CHANGE_NAME "changename"
+#define LONG_NAME	"change_to_very_long_extended_name"
+#define LONG_NAME_CAP	"change_to_very_"
 #define EMPTY_NAME ""
 #define TASK_COMM_LEN 16
+#define TASK_COMM_EXT_LEN 64
 #define MAX_PATH_LEN 50
 
 int set_name(char *name)
@@ -25,6 +33,16 @@ int set_name(char *name)
 	return res;
 }
 
+int set_ext_name(char *name)
+{
+	int res;
+
+	res = prctl(PR_SET_EXT_NAME, name, NULL, NULL, NULL);
+
+	if (res < 0)
+		return -errno;
+}
+
 int check_is_name_correct(char *check_name)
 {
 	char name[TASK_COMM_LEN];
@@ -38,6 +56,19 @@ int check_is_name_correct(char *check_name)
 	return !strcmp(name, check_name);
 }
 
+int check_is_ext_name_correct(char *check_name)
+{
+	char name[TASK_COMM_EXT_LEN];
+	int res;
+
+	res = prctl(PR_GET_EXT_NAME, name, NULL, NULL, NULL);
+
+	if (res < 0)
+		return -errno;
+
+	return !strcmp(name, check_name);
+}
+
 int check_null_pointer(char *check_name)
 {
 	char *name = NULL;
@@ -82,6 +113,11 @@ TEST(rename_process) {
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
 	EXPECT_TRUE(check_is_name_correct(CHANGE_NAME));
 
+	EXPECT_GE(set_ext_name(LONG_NAME), 0);
+	EXPECT_TRUE(check_is_ext_name_correct(LONG_NAME));
+	EXPECT_TRUE(check_is_name_correct(LONG_NAME_CAP));
+	EXPECT_TRUE(check_name());
+
 	EXPECT_GE(set_name(EMPTY_NAME), 0);
 	EXPECT_TRUE(check_is_name_correct(EMPTY_NAME));
 

-- 
2.55.0


