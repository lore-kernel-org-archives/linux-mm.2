Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F10AFF8863
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 06:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196526B0092; Sun, 26 Apr 2026 02:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EB86B0093; Sun, 26 Apr 2026 02:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44B66B0095; Sun, 26 Apr 2026 02:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE2E56B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6176F40506
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:31 +0000 (UTC)
X-FDA: 84699725502.15.27265FB
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98FAA180005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UJcPi3Xk;
	spf=pass (imf24.hostedemail.com: domain of 3ULDtaQYKCL0vxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3ULDtaQYKCL0vxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777184849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bz3o39/B8+STfzOmNVRr4jYj/f9wiAKcuL2hAc9CAE=;
	b=EVz1AAVSP5aUbCYAvA0SG8+zfPe1htiC4tEFVYuOMYHHjtDDm6CAVyjabBnh58173NTVh+
	4wxP4RawEjttNktc9Kyd4F34K9NVp4QtL966UHFp+Qr75XLn3WaoY9RnRGhkdnBUFf3kpf
	pBX3ydlXTmVFPHy46yZ1UjNbL+YV3xE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UJcPi3Xk;
	spf=pass (imf24.hostedemail.com: domain of 3ULDtaQYKCL0vxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3ULDtaQYKCL0vxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777184849; a=rsa-sha256;
	cv=none;
	b=sOLm+YRM+5xna+yyRYRVgg3gb478R8qe31qVo9q6ikwPkxeedcra7jPlKF61ZjvmU1D7m7
	oDGLdJHk5yCLNMbwMlU1W2FKrRgBg/HCM7djhu7/Vr9tOsVPSmWRaaeOKpZd/lEG1iEJli
	xnzwL5IXnyaBV5lBzxwcgfgrnJo+6tY=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12c21dbc9c1so34624179c88.0
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777184848; x=1777789648; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0bz3o39/B8+STfzOmNVRr4jYj/f9wiAKcuL2hAc9CAE=;
        b=UJcPi3Xkl2Xp01Bfo1cTpXZ3k1ang1F7mabcCqVAEZxXcMgxtPGTE0DmXQBletnqLM
         h8KqKgelR7waePcaBIS6jDHyQhJM3W5IfQzTiSBKUxffGldhUaKdNcuz4Suv7ZJlYCAS
         xNMyUNm8F/TgF5dELjzi/xF+Yu/ZFxLEUb8zDYywFC/DpaTK4xzwH9TFBtnej+85cniw
         xmLviGg8puWi40omloIKeha7dSm1ToOInWEc/I4y4NCfqOTnQhg50wNY8naYtqdBsln3
         CSydqYGC8bMX1pBYvYAM5Hacj2mLgoWM1kr6B3PyZcK7qW1xrD6VFlnsEUrPh/HsoIb9
         tE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777184848; x=1777789648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0bz3o39/B8+STfzOmNVRr4jYj/f9wiAKcuL2hAc9CAE=;
        b=AP6+0+CdTj1+rg48FQAkMJWBnMZYcKI5uOc0Slr8aNkeGxVocENeiXWr2vYz31bdem
         4AafuiJ3yp8+RXi4Dlh2LmCF/Mu3QAg9+wBJPbtTcnMOnFizrc+M9hGtu+x+plTHgAgg
         fUsJhzrz5glKmkqdG5lK4X7Cy6t75eaKTvEs2nzwu18PITXx1tft92dmiEKT+KuExj4o
         lSqxvgV5f0PK31aJhOaY0+76UyiUory2dawJacux/c575KUw0l0hAL/GXnxmppiv6tMY
         fjK/L1OzEgEGTHc3HBbn0uQ7SCO3abOMKJp2rHY+f8IuqIc+mI7RnSRGQYAPNM+GKcPE
         G4HA==
X-Forwarded-Encrypted: i=1; AFNElJ+R3YTF26NZLxpgfQosQlp5Cu02PtxhKfpMbsWZFZxhbkMtnOGytVnpCD7mSOVj2OEpAN7Pq5+sUQ==@kvack.org
X-Gm-Message-State: AOJu0Ywv9PTx/XTXeUjcA+D8/fqfKoBDvZcOjkJrRsxV6tuNa/zqAG9K
	4H+9A0ivAkU2ilFM5DY2AKYEy/jP33yHn80WSNMotICHbkB97UgQ8tyhCJPCARCpT/gLnfYWF0n
	K0/P5oQ==
X-Received: from dlbpu1.prod.google.com ([2002:a05:7022:e881:b0:12c:4955:b382])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:458f:b0:12d:ca9f:7e4f
 with SMTP id a92af1059eb24-12dca9f818dmr3135792c88.19.1777184848209; Sat, 25
 Apr 2026 23:27:28 -0700 (PDT)
Date: Sat, 25 Apr 2026 23:27:18 -0700
In-Reply-To: <20260426062718.1238437-1-surenb@google.com>
Mime-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260426062718.1238437-4-surenb@google.com>
Subject: [PATCH v2 3/3] selftests/proc: add /proc/pid/smaps tearing tests
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98FAA180005
X-Rspam-User: 
X-Stat-Signature: w1itryj3zk9j6xe56qx9mpw85zbybjjm
X-HE-Tag: 1777184849-215863
X-HE-Meta: U2FsdGVkX18QLavf4sAzTBDWapZCNYwWGHMXU/f7vNzjtbs90iPEza8S3ptK+lKItZNoX/bhUPsaAeNRVqCuJCkGwK+R1C5g9SRn3PqQ2xLFDmVY73M4+fgCyb+5Zf492bW7/1VA+rzp8fvj3W0kfingvGv6Wc65qQqfeC4axVPlnMzMJwxZG/bqre1Fj9eQ5KpHMh3pm8gs6MVf+0RQbZIzrhWKmjswYjXhti18CPaCPDU2aktot4aC1KLmd9zS7RB6ylpfnTGDZTqfgAFxPz6QxftHl3cURIns/Btm5OUsH+av0RV4H+uhTReOJ59fRMmnbf9JkFyJuTdv/yjfrPlTkNDnPPImpCklo4sGbXqpvt6HMX9Q7mF3cP5v6O0THIVB8pGZtbpgHes1uqxeb9Bdi0N/8zpMWjhWui0DcuB/eDtosf7TeB6b0wOGhKHdZL0rdMQTKiW8U8xEHiXasawZxJDdFydj+GLkmD2vmntK7d0R4HU1KU4L05M/r2e4mWyEJtgWC1P73AzFT9gUHJ0omRUW4iHOcoOxqlPd2IbhTj9N3g5xL1aCVX8h9TGX3SHyE2YYU3+erSzsF5Dw9mT3zo/gW6e3nGmSlb+O1N8+SIhFeXOoNXu5jdEzkNAkDexkrECK1UTw7gR5oNX4EIetm0JWHHKp+Xoey3Lk8XcjiNG6gdDnu8ln2hRleOwXy8H1P1plaBm19mEGAEpeWDDJ1nLaoA+mqA3NCUckYqFR021ABsEj4wXlxAtKPU31cT9SqODgyxJRdy2wt+dJZXehISTjW6UdrlgwKxCoYeyqxFiuHIxg4pDhYbuTudO60KE65rF7WsFJzzzfygGOr8LpqztQk8xn0qS41A4ORiAy8RzaHtrmzb+dry8dD9GQIWM6mY8cibR+FW8TSDGukeG1vjaEZ743HnG9fiYB1wpnuSeKD8iK6bWUbmfwYsrl7zoYW7+FTFk/RJikI3z
 xI/20J77
 ++DdoVtr/na9ULR0pAfIpnA9Mgv0iiollRlYTZe+NpZe1x5k7Vkt44lZOQvo95lbS1KBn2LTi82rwi5Yl+D39MX77FCgcf9pKhVQFIbwZTov7cfsy6hNxxFH+md2WOyIN/nQX1+uMWLLtAjAKbbFmKJB6A/Z5syTQk/o60rRoy11kMLJeZ3b4EdbKRGNVgA6UGDVIErW3RzJAYgU71g+PCxsoZs1n5jcd25HabTt34F6VKxmNmSzUqnRfrsEY7A1qbA2wdLugSZM971ogifPJFFYDS9XFw0eL3gxfSyTylg9IAwCoFgNkegXBpnPLCcMXqJOAI5EOemzm0w0yJ6emjXJUjonc+SVq+JMrRs3UHXdJ57CGhq+uePnw2/acdui76up9AMw8xsrwVBcv15wS320+ze1eHZEjsAFABCqWa2M4Y1Zu5MPyfKkVxlf+yZ0e6tk/JxEP8Tscv20m7esfGQrLrt/BLceLvH9Nmb9e+UW4qANJ2R22ps8Atjls1qDkaA0P0Lupk6FBvSKDsm77ASsdUMaxsx00cwikG2niL+tVr0Ny2FviTSOw6ASWTa1vrhwFDih1GPu4iV8p99H91o+wdnvwl7Ctz7PwMXZwBeDlp8jS38UPFshMi6gOheHIeYzhEO1FDbWdOGbqrYhp2n3gBRuHtsvTMWT3M/kiCooDw8VNSLGn9Jj7CZJkJoEyBX7kRQrMF4uJChAn+ma1dFt7/l3bKiYLL/CDCqVYFu0R/3CQvVEq6/h+DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tearing tests for /proc/pid/smaps file. New tests reuse the same
logic as with maps file but skipping all the data except for the VMA
addresses, which are the only part relevant for the tearing tests.
Skip PROCMAP_QUERY parts of the tests because smaps does not implement
that ioctl.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <liam@infradead.org>
---
 tools/testing/selftests/proc/proc-maps-race.c | 178 +++++++++++++-----
 1 file changed, 133 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index 5eb350c23da4..1026d8c400e1 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -17,8 +17,8 @@
  */
 /*
  * Fork a child that concurrently modifies address space while the main
- * process is reading /proc/$PID/maps and verifying the results. Address
- * space modifications include:
+ * process is reading /proc/$PID/maps and /proc/$PID/smaps, verifying the
+ * results. Address space modifications include:
  *     VMA splitting and merging
  *
  */
@@ -73,6 +73,11 @@ enum test_state {
 	TEST_DONE,
 };
 
+enum maps_file {
+	MAPS,
+	SMAPS,
+};
+
 struct vma_modifier_info;
 
 FIXTURE(proc_maps_race)
@@ -83,6 +88,7 @@ FIXTURE(proc_maps_race)
 	struct line_content last_line;
 	struct line_content first_line;
 	unsigned long duration_sec;
+	enum maps_file maps_file;
 	int shared_mem_size;
 	int skip_pages;
 	int page_size;
@@ -92,6 +98,19 @@ FIXTURE(proc_maps_race)
 	pid_t pid;
 };
 
+FIXTURE_VARIANT(proc_maps_race)
+{
+	const enum maps_file maps_file;
+};
+
+FIXTURE_VARIANT_ADD(proc_maps_race, maps) {
+	.maps_file = MAPS,
+};
+
+FIXTURE_VARIANT_ADD(proc_maps_race, smaps) {
+	.maps_file = SMAPS,
+};
+
 typedef bool (*vma_modifier_op)(FIXTURE_DATA(proc_maps_race) *self);
 typedef bool (*vma_mod_result_check_op)(struct line_content *mod_last_line,
 					struct line_content *mod_first_line,
@@ -222,6 +241,57 @@ static void copy_last_line(struct page_content *page, char *last_line,
 	copy_line(pos, end, last_line, line_size);
 }
 
+static bool copy_first_entry(struct page_content *page, char *first_line,
+			     size_t line_size)
+{
+	char *start_pos = page->data;
+
+	while (start_pos < page->data + page->size) {
+		unsigned long start_addr;
+		unsigned long end_addr;
+		char *end_pos;
+
+		end_pos = strchr(start_pos, '\n');
+		if (!end_pos)
+			break;
+
+		if (parse_vma_line(start_pos, end_pos, &start_addr, &end_addr)) {
+			copy_line(start_pos, end_pos, first_line, line_size);
+			return true;
+		}
+
+		start_pos = end_pos + 1;
+	}
+
+	return false;
+}
+
+static bool copy_last_entry(struct page_content *page, char *last_line,
+			    size_t line_size)
+{
+	char *end_pos = page->data + page->size - 1;
+	char *start_pos;
+
+	while (end_pos > page->data) {
+		unsigned long start_addr;
+		unsigned long end_addr;
+
+		/* skip last newline */
+		start_pos = end_pos - 1;
+		/* search previous newline */
+		while (start_pos > page->data && start_pos[-1] != '\n')
+			start_pos--;
+		if (parse_vma_line(start_pos, end_pos, &start_addr, &end_addr)) {
+			copy_line(start_pos, end_pos, last_line, line_size);
+			return true;
+		}
+
+		end_pos = start_pos - 1;
+	}
+
+	return false;
+}
+
 /* Read the last line of the first page and the first line of the second page */
 static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
 				struct line_content *last_line,
@@ -230,8 +300,16 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
 	if (!read_two_pages(self))
 		return false;
 
-	copy_last_line(&self->page1, last_line->text, LINE_MAX_SIZE);
-	copy_first_line(&self->page2, first_line->text, LINE_MAX_SIZE);
+	if (self->maps_file == MAPS) {
+		copy_last_line(&self->page1, last_line->text, LINE_MAX_SIZE);
+		copy_first_line(&self->page2, first_line->text, LINE_MAX_SIZE);
+	} else if (self->maps_file == SMAPS) {
+		if (!copy_last_entry(&self->page1, last_line->text, LINE_MAX_SIZE) ||
+		    !copy_first_entry(&self->page2, first_line->text, LINE_MAX_SIZE))
+			return false;
+	} else {
+		return false;
+	}
 
 	return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
 		      &last_line->end_addr) == 2 &&
@@ -497,6 +575,7 @@ FIXTURE_SETUP(proc_maps_race)
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
 	self->verbose = verbose && !strncmp(verbose, "1", 1);
+	self->maps_file = variant->maps_file;
 	duration_sec = duration ? atol(duration) : 0;
 	self->duration_sec = duration_sec ? duration_sec : 5UL;
 
@@ -563,7 +642,16 @@ FIXTURE_SETUP(proc_maps_race)
 		exit(0);
 	}
 
-	sprintf(fname, "/proc/%d/maps", self->pid);
+	switch (self->maps_file) {
+	case MAPS:
+		sprintf(fname, "/proc/%d/maps", self->pid);
+		break;
+	case SMAPS:
+		sprintf(fname, "/proc/%d/smaps", self->pid);
+		break;
+	default:
+		ksft_exit_fail();
+	}
 	self->maps_fd = open(fname, O_RDONLY);
 	ASSERT_NE(self->maps_fd, -1);
 
@@ -608,7 +696,6 @@ FIXTURE_SETUP(proc_maps_race)
 	ASSERT_TRUE(mod_info->addr && mod_info->next_addr);
 
 	signal_state(mod_info, PARENT_READY);
-
 }
 
 FIXTURE_TEARDOWN(proc_maps_race)
@@ -698,20 +785,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 		last_line_changed = strcmp(new_last_line.text, self->last_line.text) != 0;
 		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
 		ASSERT_EQ(last_line_changed, first_line_changed);
-
-		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
-		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
-					  &vma_start, &vma_end));
-		/*
-		 * The vma at the split address can be either the same as
-		 * original one (if read before the split) or the same as the
-		 * first line in the second page (if read after the split).
-		 */
-		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
-			     vma_end == self->last_line.end_addr) ||
-			    (vma_start == split_first_line.start_addr &&
-			     vma_end == split_first_line.end_addr));
-
+		if (self->maps_file == MAPS) {
+			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+						  &vma_start, &vma_end));
+			/*
+			 * The vma at the split address can be either the same as
+			 * original one (if read before the split) or the same as the
+			 * first line in the second page (if read after the split).
+			 */
+			ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+				     vma_end == self->last_line.end_addr) ||
+				    (vma_start == split_first_line.start_addr &&
+				     vma_end == split_first_line.end_addr));
+		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -781,17 +868,18 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 					strcmp(new_first_line.text, restored_first_line.text),
 					"Expand result invalid", self));
 		}
-
-		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
-		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));
-		/*
-		 * The vma should stay at the same address and have either the
-		 * original size of 3 pages or 1 page if read after shrinking.
-		 */
-		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
-			    (vma_end - vma_start == self->page_size * 3 ||
-			     vma_end - vma_start == self->page_size));
-
+		if (self->maps_file == MAPS) {
+			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr,
+						  &vma_start, &vma_end));
+			/*
+			 * The vma should stay at the same address and have either the
+			 * original size of 3 pages or 1 page if read after shrinking.
+			 */
+			ASSERT_TRUE(vma_start == self->last_line.start_addr &&
+				    (vma_end - vma_start == self->page_size * 3 ||
+				     vma_end - vma_start == self->page_size));
+		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -861,20 +949,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 					strcmp(new_first_line.text, restored_first_line.text),
 					"Remap restore result invalid", self));
 		}
-
-		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
-		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
-					  &vma_start, &vma_end));
-		/*
-		 * The vma should either stay at the same address and have the
-		 * original size of 3 pages or we should find the remapped vma
-		 * at the remap destination address with size of 1 page.
-		 */
-		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
-			     vma_end - vma_start == self->page_size * 3) ||
-			    (vma_start == self->last_line.start_addr + self->page_size &&
-			     vma_end - vma_start == self->page_size));
-
+		if (self->maps_file == MAPS) {
+			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+						  &vma_start, &vma_end));
+			/*
+			 * The vma should either stay at the same address and have the
+			 * original size of 3 pages or we should find the remapped vma
+			 * at the remap destination address with size of 1 page.
+			 */
+			ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+				     vma_end - vma_start == self->page_size * 3) ||
+				    (vma_start == self->last_line.start_addr + self->page_size &&
+				     vma_end - vma_start == self->page_size));
+		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
-- 
2.54.0.545.g6539524ca2-goog


