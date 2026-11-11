Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49130606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=UJKgjDSe
Received: by kanga.kvack.org (Postfix)
	id 57DE36B05B7; Wed, 11 Nov 2026 02:53:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528246B05BA; Wed, 11 Nov 2026 02:53:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E4B6B05BB; Wed, 11 Nov 2026 02:53:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCBD6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B61540214
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:27 +0000 (UTC)
X-FDA: 85422073254.04.273D461
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id B210A80002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=UJKgjDSe;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf02.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oahx99XEloIqEujazr6llRd2iV3ppRMwlmYjmySRohQ=;
	b=Q9QReEUUBD2BSOBKdAy5K7rZto1471t8thQMetmt366NJDSgWH8arqwuLU+IiQcwyo0eYu
	6rNqPAsvMtruXQodKxG3+1TEiUwUW+3IRehMgZOnA8n+sNMQZOdhm2GrAm9lnQTrdqw3xg
	PAezXFaH6hbEPTCkTCxCp0iHv/5nUuk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=UJKgjDSe;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf02.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383605;
	b=HQYhXz+2qIwLmjKzi9I3Z8+YDCIb885d27KWGB0uoXKnzlpS2iicA3vJUBVS85yFDUOy2L
	LsfhGt501aKfFLq7PdWPZ8/Fo7HMb0C5Q3a69Js5kJoVUMTtEGlN4XGF9x4AiK761nbA4+
	RUic/grL0xCAjvqx5uVGJYTd2hVw0KI=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd69954c755so2057002a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383604; x=1794988404; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oahx99XEloIqEujazr6llRd2iV3ppRMwlmYjmySRohQ=;
        b=UJKgjDSe+O+rz76/t9I1kDiA0g/TRLGIEAdqsBM1oLy4T76I1yMqMcQbT1dUAExAT4
         MnTDukkm9RLDARGSa2A689+9l/5ba9VZjEHCVfnALzY1cspSKdHTGPudQN/QLXWeVc9p
         3NwqzKJgjPV/BkiO0TqLK8bfbN6c5OAws4uGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383604; x=1794988404;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oahx99XEloIqEujazr6llRd2iV3ppRMwlmYjmySRohQ=;
        b=syeZPqnGVE/6odeLSGI1WRteP1ENnp3BMlwYGjUOvunZUhTTV217lH7X4b4i+afLGJ
         UufzApOQDjKoWz+Yn79n6VhPf9a08ogXeqPwk8SPdCCQ154xPPI8wUDqm7S7IHT0o23t
         UmmpT1qGrbgwZFVroMSSlSKuMQ3lRFLHD+INS5CYUtrgIq2rROup3lHvNJqxNkq+rsaH
         BJFckLbF9wdz6rwv/CcJYV+NuGo0lBLqS6FQkPyLI4xRTC8B6Z9Lx8FADF2X3k+VoH6U
         7Y9YiZaxBAf4v1vvD6YqoqbPFJeTDP+2lJLeA0OQ1VJQzw0oaJPNanUAHQ/FAgKDxbM6
         EGgg==
X-Forwarded-Encrypted: i=1; AL+hErHsfkJafLlI1iscpxUR+H/nZqJhGVuaeOFEZholkVlwPLpFHKeuVe5MWmGFPjF0WYBFQmz4Vgb/fQ==@kvack.org
X-Gm-Message-State: APuU4Z9ow7li03FFOOmLsygDpWj409oFBoOyfQx8IC7RAIOm3vAwxeaE
	OWlDkoPy+0AQHKrNrq9UUbyGorlHKpkl6HE0YwJa6LTtqhGBtWS77D+K4/ORlEN932B/zMxmR6/
	RJuuQNfgx7f5qCzQ=
X-Gm-Gg: AYBFou01lJ9tdCNl9AeXf8CgtIOGDJcgdrWHd+fP+Cwo70P1bL8z3hH4cMyymKD9Chm
	JqT7B1DusjMySUMy4hCLzPvEqrHD73fAGyoKXlT1En/01jiqxrxJ1kiXbimhfFY+0kBQEHbp2bP
	OXT2n8dcD/Yse7w6a/1uPmKe31p3GjGf3ecb2fQrYGjuKCmLoPu//lKj9cPv6LE8KvOkh+C9p7q
	HpajpIJebZyyuVmM86avI5To+kUq7B7EK4SSposMvNea/WKspTfMZM0hzP99BLVD8tsyc4iwmUt
	35db1jmBqarcCvlkNEL4sKtsjN2bH2WyBNgJ++6usLk7woox2OyvNRyrsJZirDxDE+YIRrdRoth
	DSYrioBSNOlS5Mh0recyHg443Hc4kqrIfOUFrGkK/N1Cs6/PttAdNFs7GxxLqTxC+LBAijix8O3
	sLI82KkYTq9EixGTHTIFwh1uB4vh+IhIAI2Nqaxz9tYSWP9BfGyjSoOxIjW5qV/zrBPlO4FZMt0
	qE8E6jlMsKqHZLoOOTR1Y36/4K6FQMxTACji9XVnTIGrekKBv/PfetJXTUEItm4f5qZ0wfi+jKR
	W168aETp1oHNE5z4/kGcPDWE+HtHtYuqE94pfoWQMvweGMjWiZwGydQnOy6bc4oZ6Y9gUU62uQH
	PYmbRIDJDpWrfRcPyIlYBloG5t7VPwsIO1yzcgHFERy4F+BzCH3Ln9ntM7uYQsjf/crQuwW7waN
	pLSaIFlmwHgNQuNVxhuekPyU+mz04f7YlT+8XMWJw/u/6sYF9ynRiOPzP+/AjMByiKDneKNIXAd
	g==
X-Received: by 2002:a17:90b:3ecd:b0:3b0:ae41:2706 with SMTP id 98e67ed59e1d1-3b182defae2mr1841105a91.4.1794383604238;
        Tue, 10 Nov 2026 23:53:24 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17dba5ed0sm3393597a91.17.2026.11.10.23.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:23 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:20 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/9] selftests/liveupdate: Catch incorrect file accounting
 across kexec
Message-ID: <d339c0af9c4ee54a5ee8052d5fe59c81302d82a7.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B210A80002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: mzsrqpgriff7tyc8t5sb3mtdckfr8p54
X-HE-Tag: 1794383605-31071
X-HE-Meta: U2FsdGVkX1+0cojtz7dt1TnYv0AKafCbP93ANNGeI1pkT76u7ovWUaa91I9w6dJQaRsScZYVOVkE7/f+4kI0SQ+FClz3b+56aQAYzPrf45m8RU0HsdD1/rxddM0e8FrhZTlEaeIxlSb93KY3BLfKGbECD6OFkH5YGn0RoJkBuzCvGEgGOdWDfi75w4FSQSGZrYK178/q1KvrbbtxwbkubSI57I1nRTUVcsut6GXii5rzhfYZHH+wL0T/9NfKlqPpjZHfuGyoqeIwwVEbSrDZG+xLdCE2wkGOjhvDOnYYInF+GZasv1NsVYT39cJyCPWSOoG7d6L09PkC8TIHgY+WqvKH704Yh5xEvCmANkhAX7gnIVzselYeBtsV/Ej28d48bxLLkn//WwwEWkY+mg1pbUpZVrnUVMEBracV0Vp4Wg/3Pk0pXd+j3zfOyszuG2Em9ndcoIgx8slmpVrlat/uioG4HUiKYHIhQVzwWW0Jy3sgeEE5XHpRTZBxTLGWUXyH9rNS3EP/QPkN1seLEQtu8vLPV5aa2Hu2mQpUJYBOIx5hbjWNsK+OsQwQg3Vgr4osfH1rG3dymi+16Ym30MewJG7iGnqd0Qy+hAyfwu9fmac15mhzGr4QTgzgZhacq0ze26BN64xUzj2Yo7nTmWePOiFw46BisK21QJc3UnSHQfWpfrPoINH9I+26c7mZrfY/Htp9PLm9Pj0PgsVcpm07QLRkwaMBUiYz3Dm6Pd6i5E7F08nBj/jD34lLnH7Tzr989SXgbYDTHH/eoXvCub9+u2p8hPO4JCPn7hnJ19cfUTU83iNEnLn0lsYp4Nn+8eP8RLGu4qNbYBColvnUE+l4DleezvzTXytVy8ycVB8ZmzW7BKqBzjnAQQTTlIF29pLquzd1KLVov9CLK5WGFeLQQU7zHe3WkeoqpvlyqjvPLUTFwgN5+T6fjCnA8+GJp84IDcqgazCuf8o9nH8eHvN
 UnvR1ivh
 6bDL2/CfWPqltt2FNsklVdR7Jv1hhYGMXleOXrdDh0mI2aurue/VAa3OvIIGQpDRgY+BQI/iXqCX4OppgsbtNVi3KKBfRdRlDDzrzhAUZMd2gsmm11+g1SFOjssZCrag+plfBht7nif8RFTxtz3wHzHOhzwbXG3YJnoJohnCOE4EIwALqJEIpkB8CWuD0mREQZmQjat+vIyEkOJhjBS8JzwpQLAKaUq2Hml/hZKVyUkW4HTR2GYvHREzyKgycHPADvhpvtvt3/PXYrBGenAWT+gYIRk33r7U5adBwR+zAERVzledWc83093DeOlVFfieEaEfaDO3Qbp9kKSs83Ozg9ockeHhXIWTFkEvvZcKV/s+XwPVuqmCsPGA8NM6zWHiKxlEaVOhhGzoNpE7YC0qntVYKGLzy9jT9UC53W8wHGOkyNwHf+xDDm6Ws5rS3JhilfpSqr3DFjSDf0tiyPxP4UEYTQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that each retrieve is counted while the session is still open.
Finishing the session should count its unretrieved file as dropped,
while a file in an unclaimed session should still be held.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 tools/testing/selftests/liveupdate/init.c     |   5 +
 .../selftests/liveupdate/luo_handover_stats.c | 198 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 tools/testing/selftests/liveupdate/vmtest.sh  |   2 +
 5 files changed, 207 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_handover_stats.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 634211c66652..78a4419ff610 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -2,6 +2,7 @@
 
 TEST_GEN_PROGS += liveupdate
 
+TEST_GEN_PROGS_EXTENDED += luo_handover_stats
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
diff --git a/tools/testing/selftests/liveupdate/init.c b/tools/testing/selftests/liveupdate/init.c
index fb08bd58b9b9..31bd8f0ec3a9 100644
--- a/tools/testing/selftests/liveupdate/init.c
+++ b/tools/testing/selftests/liveupdate/init.c
@@ -37,6 +37,11 @@ static int mount_filesystems(void)
 		return -1;
 	}
 
+	if (mount("sysfs", "/sys", "sysfs", 0, NULL) < 0) {
+		fprintf(stderr, "INIT: Failed to mount sysfs\n");
+		return -1;
+	}
+
 	return 0;
 }
 
diff --git a/tools/testing/selftests/liveupdate/luo_handover_stats.c b/tools/testing/selftests/liveupdate/luo_handover_stats.c
new file mode 100644
index 000000000000..f18df79dda55
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_handover_stats.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <libliveupdate.h>
+
+#define INCOMING_DIR "/sys/class/misc/liveupdate/incoming/"
+
+#define SESSION_CLAIMED "stats-claimed"
+#define SESSION_UNCLAIMED "stats-unclaimed"
+
+#define MFD_RETRIEVED_TOKEN 0x51
+#define MFD_DROPPED_TOKEN 0x52
+#define MFD_UNCLAIMED_TOKEN 0x53
+
+#define MFD_RETRIEVED_DATA "retrieved before finish"
+#define MFD_DROPPED_DATA "never retrieved"
+#define MFD_UNCLAIMED_DATA "session never retrieved"
+
+#define STATE_SESSION_NAME "handover_stats_state"
+#define STATE_MEMFD_TOKEN 997
+
+/* The first open starts deserialization. */
+static char state_before_open[16];
+
+static void read_incoming(const char *name, char *buf, size_t len)
+{
+	char path[128];
+	ssize_t n;
+	int fd;
+
+	snprintf(path, sizeof(path), INCOMING_DIR "%s", name);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		fail_exit("open %s", path);
+
+	n = read(fd, buf, len - 1);
+	if (n < 0)
+		fail_exit("read %s", path);
+	close(fd);
+
+	/* A full buffer could hide the rest of a malformed value */
+	if ((size_t)n == len - 1)
+		ksft_exit_fail_msg("%s is longer than %zu bytes\n", path,
+				   len - 2);
+
+	buf[n] = '\0';
+	if (n > 0 && buf[n - 1] == '\n')
+		buf[n - 1] = '\0';
+}
+
+static void expect_state(const char *state, const char *expected)
+{
+	if (strcmp(state, expected))
+		ksft_exit_fail_msg("state is '%s', expected '%s'\n", state,
+				   expected);
+}
+
+static unsigned long long read_number(const char *name)
+{
+	unsigned long long val = 0;
+	char buf[32];
+	char *p;
+
+	read_incoming(name, buf, sizeof(buf));
+	for (p = buf; *p >= '0' && *p <= '9'; p++) {
+		if (val > (ULLONG_MAX - (*p - '0')) / 10)
+			break;
+		val = val * 10 + (*p - '0');
+	}
+	if (p == buf || *p)
+		ksft_exit_fail_msg("%s%s reads '%s', not a 64-bit unsigned number\n",
+				   INCOMING_DIR, name, buf);
+	return val;
+}
+
+static void expect_count(const char *name, unsigned long long expected)
+{
+	unsigned long long val = read_number(name);
+
+	if (val != expected)
+		ksft_exit_fail_msg("%s is %llu, expected %llu\n", name, val,
+				   expected);
+}
+
+static void expect_counts(long retrieved, long dropped)
+{
+	char state[16];
+
+	read_incoming("state", state, sizeof(state));
+	expect_state(state, "deserialized");
+
+	/* Three sessions, including the one carrying the test stage. */
+	expect_count("sessions", 3);
+	expect_count("files", 4);
+	expect_count("files_retrieved", retrieved);
+	expect_count("files_failed", 0);
+	expect_count("files_dropped", dropped);
+}
+
+static void run_stage_1(int luo_fd)
+{
+	int claimed_fd, unclaimed_fd;
+
+	ksft_print_msg("[STAGE 1] Checking state on a cold boot...\n");
+	expect_state(state_before_open, "none");
+	expect_count("sessions", 0);
+	expect_count("files", 0);
+
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Preserving two memfds in '%s'...\n",
+		       SESSION_CLAIMED);
+	claimed_fd = luo_create_session(luo_fd, SESSION_CLAIMED);
+	if (claimed_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_CLAIMED);
+	if (create_and_preserve_memfd(claimed_fd, MFD_RETRIEVED_TOKEN,
+				      MFD_RETRIEVED_DATA) < 0)
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD_RETRIEVED_TOKEN);
+	if (create_and_preserve_memfd(claimed_fd, MFD_DROPPED_TOKEN,
+				      MFD_DROPPED_DATA) < 0)
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD_DROPPED_TOKEN);
+
+	ksft_print_msg("[STAGE 1] Preserving one memfd in '%s'...\n",
+		       SESSION_UNCLAIMED);
+	unclaimed_fd = luo_create_session(luo_fd, SESSION_UNCLAIMED);
+	if (unclaimed_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_UNCLAIMED);
+	if (create_and_preserve_memfd(unclaimed_fd, MFD_UNCLAIMED_TOKEN,
+				      MFD_UNCLAIMED_DATA) < 0)
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD_UNCLAIMED_TOKEN);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int claimed_fd, mfd, stage;
+
+	ksft_print_msg("[STAGE 2] Checking state before and after the first open...\n");
+	expect_state(state_before_open, "pending");
+	expect_counts(0, 0);
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2)
+		fail_exit("Expected stage 2, but state file contains %d", stage);
+
+	/* The retrieve must count before the session finishes. */
+	expect_counts(1, 0);
+
+	ksft_print_msg("[STAGE 2] Retrieving one of the two memfds in '%s'...\n",
+		       SESSION_CLAIMED);
+	claimed_fd = luo_retrieve_session(luo_fd, SESSION_CLAIMED);
+	if (claimed_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_CLAIMED);
+
+	mfd = restore_and_verify_memfd(claimed_fd, MFD_RETRIEVED_TOKEN,
+				       MFD_RETRIEVED_DATA);
+	if (mfd < 0)
+		fail_exit("restore_and_verify_memfd for token %#x",
+			  MFD_RETRIEVED_TOKEN);
+	close(mfd);
+	expect_counts(2, 0);
+
+	ksft_print_msg("[STAGE 2] Finishing '%s'...\n", SESSION_CLAIMED);
+	if (luo_session_finish(claimed_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_CLAIMED);
+	close(claimed_fd);
+
+	expect_counts(2, 1);
+
+	ksft_print_msg("[STAGE 2] Finishing the state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	/* Finishing the state session must not drop anything. */
+	expect_counts(2, 1);
+
+	ksft_print_msg("\n--- HANDOVER STATS TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	read_incoming("state", state_before_open, sizeof(state_before_open));
+
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index 6f592aec0f85..bce7679279d4 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -16,6 +16,7 @@ failed=0
 skipped=0
 
 TEST_NAMES=(
+	"luo_handover_stats"
 	"luo_kexec_simple"
 	"luo_multi_session"
 	"luo_stress_files"
diff --git a/tools/testing/selftests/liveupdate/vmtest.sh b/tools/testing/selftests/liveupdate/vmtest.sh
index dea5a6fb2abc..76ffea7d4eb8 100755
--- a/tools/testing/selftests/liveupdate/vmtest.sh
+++ b/tools/testing/selftests/liveupdate/vmtest.sh
@@ -145,6 +145,7 @@ function mkinitrd() {
 	cat > "$workspace_dir/cpio_list_inner" <<EOF
 dir /dev 0755 0 0
 dir /proc 0755 0 0
+dir /sys 0755 0 0
 dir /debugfs 0755 0 0
 nod /dev/console 0600 0 0 c 5 1
 file /init $workspace_dir/init 0755 0 0
@@ -157,6 +158,7 @@ EOF
 	cat > "$workspace_dir/cpio_list" <<EOF
 dir /dev 0755 0 0
 dir /proc 0755 0 0
+dir /sys 0755 0 0
 dir /debugfs 0755 0 0
 nod /dev/console 0600 0 0 c 5 1
 file /init $workspace_dir/init 0755 0 0
-- 
2.54.0


