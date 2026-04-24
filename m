Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB83FB44C2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55156B0093; Fri, 24 Apr 2026 03:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFE56B0095; Fri, 24 Apr 2026 03:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A2B6B0096; Fri, 24 Apr 2026 03:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95CA66B0093
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:03:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 312A740781
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:03:05 +0000 (UTC)
X-FDA: 84692557530.11.44E19E1
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B1E1C0011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:03:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IkaDdnud;
	spf=pass (imf10.hostedemail.com: domain of 3pRXraQYKCNIGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3pRXraQYKCNIGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777014183; a=rsa-sha256;
	cv=none;
	b=U/Rbj5Af+3cB1WejCuuHUiqbARTM0Pmm1Ce181ZfXMevf3dZ6Et+TVGUw7dvkm3uaCFKHF
	HRv+gPohExdl3Ampg3NxNEtg4Sr+By02JFNZnfuliNwimZ1PhcXVXaHaNPNXGrCQ46fBf7
	eGADyCoBq8MWUfKA05lgMkFFB+7/F2I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IkaDdnud;
	spf=pass (imf10.hostedemail.com: domain of 3pRXraQYKCNIGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3pRXraQYKCNIGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777014183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0swTopRwFXSNiJeH+dx7Oyuq8zIyt+95DwEnqw+0GOE=;
	b=Oh7aXRCqAEvHwOgMFeIdFWZSA0VmAwZ72YiXGfdjtyo2UrmqgAQdAta4Ui2iVIpBmygoFA
	+wnwffgXt88GyIg9kLUwyVKYkiTcO5d7lEnA7SIYn8qzsDZbzxWzpgqBbCSQE16WrH6V/I
	V9Hi9u+uqPzk1I9Lp6nK7L4d2OaZsLs=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12c8ccc7593so8291504c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777014182; x=1777618982; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0swTopRwFXSNiJeH+dx7Oyuq8zIyt+95DwEnqw+0GOE=;
        b=IkaDdnudI/cvBe/6MrmFZ13Hx50y6kF0a46sXfC8q+V6WB/lcpXkLxS4QTUC/uio/+
         Nbl4R3y8lTN+LQfR9kveLLrOwcxyxF29JXiE7hduL1KnY+mbN7d6T5kEgjU0l2t2QATH
         f1HIYMln4zCf4UUT6FK0AYVDP6+662XL/F2MfozolAO2vWP1sxhh0Rysxu4WZ+sC+bWE
         MW6CqllkHrEw+Sdb1BvetVOt4cNdmXuLtKyIGSTtf21IQ3yJYOCEBY1qTxEhFFce7lYI
         bd2MVRnHgGqLCfzBJhU1o0kvzDD3WkIB1YDyYDSlOR0zayNCwvMRlKTglrOZqJP4BTXj
         YjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777014182; x=1777618982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0swTopRwFXSNiJeH+dx7Oyuq8zIyt+95DwEnqw+0GOE=;
        b=omQYtw4mOSx8541Os1LRmiaxwwubq0AVqtxfI5YSOA2THY/opDH8MEf8jFO9ld8r4A
         42bdvBwcGqUZuFVO/vDYlO9SMy+rIPC1FL+8Lf08hemFkQp33AbSTvQ7ihdpcRIg+abr
         EsDcTltHVMq08idAWnIiVj5rDzES5WYsnAgfUwSp8ayfUwZHRzxMEHmyOK2c2WNID7IY
         w2VYDwG1dwkycE6Ar/DpbKDd0/kENCVt+0nnUP4YQtDOs2xRC11CMxUekujHNMeu5y0I
         DVPegmoejKQRlEjPXuPs28WmMMMWwgDolrNKxfjhWDW+SefRlLce/4YtPwNEiBNreDir
         bn3g==
X-Forwarded-Encrypted: i=1; AFNElJ8AqIDeBPtVfuihfx2kcKou01SCXd2XwfRg+XH+YVwLaRqXF3oF/Tt5Sk0xEGMSWQBZDtFKRKzCmQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+l7rMkDuddWt+CTmyAv0nkGw4ZKtL7H4gSrlUCL+GZldgCR6S
	jKgNYN9fMM27yXnA1PzRkavS7B0Y20C+ysgwFZ5eb+ZD6u2gYFDBf/jw4IkbNvNF6lqpqZfX7KJ
	/yKFVqA==
X-Received: from dlea14-n1.prod.google.com ([2002:a05:701b:420e:10b0:12c:49a5:e4a4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6b8d:b0:128:ca90:3301
 with SMTP id a92af1059eb24-12c73f71963mr16316333c88.11.1777014181789; Fri, 24
 Apr 2026 00:03:01 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:02:34 -0700
In-Reply-To: <20260424070234.190145-1-surenb@google.com>
Mime-Version: 1.0
References: <20260424070234.190145-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260424070234.190145-4-surenb@google.com>
Subject: [PATCH 3/3] selftests/proc: add /proc/pid/smaps tearing tests
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4B1E1C0011
X-Stat-Signature: 15yx6d65xjcg8essnk81mapob31kjuom
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777014183-829055
X-HE-Meta: U2FsdGVkX19QAtmJU7yKfdlIS3Snvd6MotV8ibDeK6cWbk+lQqOYSarAteSeg0NMeEJMGhgAZrfRMaQ18HkwAG3zOYBgaL1voT1GGvKKcSlLt0a1OIt4rXFj8+CjxWbbcRrl2HQ+GwPLe5vXLvyvDn/hHwKGvqy358jtLI0xsMq4MJiaK+y2LIDiH9vgGOFtIo9rjeqAYdG5u+gx7C0xIL4hOr0iAW6amVQKl8h5GvDh4z4rXGOhRYcWbU8HwkZX5wet4wqIzxVBEkWZcP9GLZiplH3TjgEqch5X1ffpQBmN5n/iyI/F4yn51euTvHLYuPKYz/sTRpq6FG1S8gQvov8sw/4+NBR8MAWhy/ElhTYm2dXTPEbtBnUIT+nJPGEGRrNtjpv+Cuyg0iamnxwZ0zd1uCg36Rq2yXkKNcKtQJXbzCsaZgm42rnBBhjiyrZa7qXWVg6xH3oNw7Zcpa3gV/YLP9jBCRdcMmurfioVwsY7y6YyTP4zyh9jBB1ylGZSXjEAqM7FJLjPsviiKTFTS+xAO5KfvX5mD3gBFImkLMb86imct6GIvoOZHvyWGad9yph13aq7YqA0nRblCgLwvoHR7DwSKIhhmOLHPw5DEtTayOgb13MuuEDjyTPZEJeIyMYBr4X2OYSblOPI1P2nuKziEfrGk4UPM4P6CWvW189FL2j6WMsEex9gfQocTynxghjuXthMGKq4nPrV7d9lESJoh4XTYKzO0vmgb6CvjVU6rZB1XEmDDNaxnO4oaj7B3LmcrM6O7jcOSooo3dOrv7mQOSbTGDHGg3VaYmvUR1YjJOTLgEtex25goJt8PnDJ0KlGLzFl9d137JfIOWyCCwSh7ThTEmLzj+ai4bEeTtgtXRjvn0ojeiBhed7DmKBtFtY4/X6Pkuea2aXLYlEuVBD2ln1M5ds+bL8zS939sAEtUIMXLiQrUqjH9fiMtGtX6w7nyxDBarYtcVXUa/x
 jMMNgwMr
 ZUqfrfXv3YlGB8/0tee2HPBW9rwyP5P7v60Y/LikzZ6SpFEI56K0lOihm2ZSS1Oidpt6INYTwDSlouK/iGOUbKC03V6AWyDf85Sn3Uob1rvNYghBIeMPr0u/n/NDQYbtKXv4SAKwL7TKqLO9Lb8yjdBaE2mjBe3Ykm9lGnGKNxDuxOzstPxI22yCFNbwhoyiEFGDBFut89sTdDR+sroupeYGkRJkYIOxMPl2Fh5601Y2UmhDQqzsNyDWZvO+CUBy0FrLo4nW432LHQcnLteuxRV9B6fz7XjP2std8Pk1rth8rvC8HvD709GR6nB1UKJb/gg9k9rZX7BdOLs7JPQWlsPqgZ787aQ/b4paocXzILuWZv3VBmQPJjEaudi/479YwDovWZxKGGRGA7LOBZLK8wkOn4aT5xAy6toiOUkpdd7gpD00wlTMgfWw4VRw2BHhc6KoyFPylEgLypOfyqYEtE+IzpYDNFOQxPOwdvnnHG2rPJa8L9D9oJGpM/3pHlCHsYLSErkqDqVb6bRfToSm/qoR5Qgf8SUGyx1XO1uq1Lu+0AHCqX+KypBZ/hu/dckSnEIrR+Z/qeanEJXoWcSHRmpwUHO92ZnSLvLnl2iqi2my41KEBi19XY+zR9V+KYmdDGQj0zEsWRsKSBAw1YwUSsLmQJ/ah5ooAkugmZC1Wz9jSFJRviDC6vZ8h3lDe0gekqLeT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add MAPS_FILE environment variable to select whether the tests to be run
for /proc/pid/maps or /proc/pid/smaps. Add support for testing smaps file
by reusing the same logic as with maps file but skipping all the data
except for the VMA addresses, which are the only part relevant for the
tearing tests. Skip PROCMAP_QUERY parts of the tests because smaps does
not implement that ioctl.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 tools/testing/selftests/proc/proc-maps-race.c | 176 +++++++++++++-----
 1 file changed, 132 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index c5031b0593b7..b677bc23cab9 100644
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
@@ -199,6 +205,57 @@ static void copy_last_line(struct page_content *page, char *last_line)
 	last_line[end - pos] = '\0';
 }
 
+static bool copy_first_entry(struct page_content *page, char *first_line)
+{
+	const char *start_pos = page->data;
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
+		if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr) == 2) {
+			strncpy(first_line, start_pos, end_pos - start_pos);
+			first_line[end_pos - start_pos] = '\0';
+			return true;
+		}
+
+		start_pos = end_pos + 1;
+	}
+
+	return false;
+}
+
+static bool copy_last_entry(struct page_content *page, char *last_line)
+{
+	const char *end_pos = page->data + page->size - 1;
+	const char *start_pos;
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
+		if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr) == 2) {
+			strncpy(last_line, start_pos, end_pos - start_pos);
+			last_line[end_pos - start_pos] = '\0';
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
@@ -207,8 +264,16 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
 	if (!read_two_pages(self))
 		return false;
 
-	copy_last_line(&self->page1, last_line->text);
-	copy_first_line(&self->page2, first_line->text);
+	if (self->maps_file == MAPS) {
+		copy_last_line(&self->page1, last_line->text);
+		copy_first_line(&self->page2, first_line->text);
+	} else if (self->maps_file == SMAPS) {
+		if (!copy_last_entry(&self->page1, last_line->text) ||
+		    !copy_first_entry(&self->page2, first_line->text))
+			return false;
+	} else {
+		return false;
+	}
 
 	return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
 		      &last_line->end_addr) == 2 &&
@@ -464,6 +529,7 @@ FIXTURE_SETUP(proc_maps_race)
 {
 	const char *verbose = getenv("VERBOSE");
 	const char *duration = getenv("DURATION");
+	const char *maps_file = getenv("MAPS_FILE");
 	struct vma_modifier_info *mod_info;
 	pthread_mutexattr_t mutex_attr;
 	pthread_condattr_t cond_attr;
@@ -474,6 +540,18 @@ FIXTURE_SETUP(proc_maps_race)
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
 	self->verbose = verbose && !strncmp(verbose, "1", 1);
+	if (maps_file) {
+		if (!strcmp(maps_file, "maps")) {
+			self->maps_file = MAPS;
+		} else if (!strcmp(maps_file, "smaps")) {
+			self->maps_file = SMAPS;
+		} else {
+			ksft_print_msg("Unknown maps file %s\n", maps_file);
+			ksft_exit_fail();
+		}
+	} else {
+		self->maps_file = MAPS;
+	}
 	duration_sec = duration ? atol(duration) : 0;
 	self->duration_sec = duration_sec ? duration_sec : 5UL;
 
@@ -540,7 +618,16 @@ FIXTURE_SETUP(proc_maps_race)
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
 
@@ -675,20 +762,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
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
@@ -758,17 +845,18 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
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
@@ -838,20 +926,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
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


