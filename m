Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D614C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C9F6B0099; Fri,  8 Aug 2025 11:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E1C8E0001; Fri,  8 Aug 2025 11:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D106B009C; Fri,  8 Aug 2025 11:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05BC06B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:28:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CCC3B7EA8
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:28:58 +0000 (UTC)
X-FDA: 83753973156.12.0CE1546
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id C432F140009
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:28:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IZjIXEaB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3txeWaAYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3txeWaAYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754666936; a=rsa-sha256;
	cv=none;
	b=cHVaoj2Ecl38y4/Mz9wTE8XS+a0aEsFtVjZzg2ur+hanDT1OBGsrjA1Rklv2oI0KdjZU+L
	s5WEqCAj+6cuK9q05jh4X1sEwIfqjuf4rx450zutP7/8K+tzhx/dYiEINx6u+Jm16IuFBg
	aHONsgRZlihRRw7pbvQzoqu8OC3hys0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IZjIXEaB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3txeWaAYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3txeWaAYKCIo685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754666936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8RI3/a/LEClfHbNax20K5D92my9/tqwTk/caS4KXZA=;
	b=wIfIXWgs5dm+SVg2vxVFh0hh9dgzXCBS1cxs13ULF7uOlDQJZJgKIz85xgDuvk1FjjiesL
	t22iJcND7c/T4PY9WmCGOJP21mhPfb0DqQvBi3FjkcEM7BogcklIf4BwkCVrFD4gYB1O6O
	F7a4pemEh736w4U6TLOM0CvnLJefro4=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-240607653f4so20004425ad.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 08:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754666935; x=1755271735; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S8RI3/a/LEClfHbNax20K5D92my9/tqwTk/caS4KXZA=;
        b=IZjIXEaBAiHbd9Ty6imcg/XgOufcnB+xaVfKW9DCO3lXJT+ssuntyBoQJhc2PgQ1b5
         2jkW8rwaqMBnOInamJ/kEkkec4d1+tNILeyCvsNRD8IBIKVtinGyMnwWzO37LaO3wVrJ
         DR0pdvG5VJVfgDQztyKU9EIx+G5GaO6nPQOkHh+wrfwg+X0e9hJGrosKB40y123UfJRd
         afViXEgK7m3bfxGAF4qTrjXxUvi378MOjciUCHg7vwpAU2rvsUIssURd48HY2TWnxp4i
         DoAtURD0LT4QUWRUujvth44/l8+bIxlFXUjf3auVI1SZqMmjfuvhglRWppdKiMDjZpNT
         UwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754666935; x=1755271735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S8RI3/a/LEClfHbNax20K5D92my9/tqwTk/caS4KXZA=;
        b=P0z0QKnUUlIXgtZE0PzeQkgs5Bz7UPA2WCz/ww5RE8zokIrrB7+A91tySimYABdYhl
         uzO8pTFtJC6LICDYgnJrBRR0TInyRCKW5eRVR6MdOIww//iMS8rhSyQfptkNaZgyRzpy
         6bw5ehpShJKyXIMq4xIyj0d4QFU9DUF5sJr+utjNuFAD0NqPv274O7G925FZ4IZ1u+Mf
         Ax5IruypE7LFZYjqq32qKUa1+uyLdYMQld0UEj6jmIaYKnGd/iq1mRVvEmcfknOFlpmX
         UsZIsVXwQd/tQlL8XeCLfW8yHHgzfqtG69I0/1r0OHYl6o0kWWoF+swXy5TN1NzXfsdG
         Gdmw==
X-Forwarded-Encrypted: i=1; AJvYcCXa1fTzRVcK1ur8PZ1br7ihrXX6fWHLjtPATJnsVi8jqkJ9/YTgpCgSyuRI9q84tXUBfw/KPpl2bQ==@kvack.org
X-Gm-Message-State: AOJu0YwK+EhOhDJU8U+2C64pIQ7CGIU14tTFLMjWBU3vliN2sXrFNiOV
	o3ubMRYXk/NYfFd4HsMMPY0UxKlNcpBQ2WbdvFWb84/y5gGYQWuZfvCG0DSbeIMslrpb9bE3bGG
	Lb68gFA==
X-Google-Smtp-Source: AGHT+IE+DfdsmL2T51tGBXmSDKHhykJ4R796cnuth2Y+HKuXvkKdRqWEuUnZeBDrebjvi1qQ6D/RrsYt7R4=
X-Received: from plzt11.prod.google.com ([2002:a17:902:bc4b:b0:23d:ecc7:14e6])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc6:b0:242:9bbc:3644
 with SMTP id d9443c01a7336-242c225a177mr50512595ad.54.1754666935527; Fri, 08
 Aug 2025 08:28:55 -0700 (PDT)
Date: Fri,  8 Aug 2025 08:28:47 -0700
In-Reply-To: <20250808152850.2580887-1-surenb@google.com>
Mime-Version: 1.0
References: <20250808152850.2580887-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250808152850.2580887-2-surenb@google.com>
Subject: [PATCH v4 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma is
 concurrently modified
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C432F140009
X-Stat-Signature: zqjytyr5nuo4qoq8jwagggjgd1fpjgbu
X-HE-Tag: 1754666936-151934
X-HE-Meta: U2FsdGVkX18d13TPeaGLQjFvNhsA/bXgFMQ+HMeVPnSIzFF+/x6av7A+pTP74iRrSypxKaqSSaU497Q6u2f7KsL1ivnaYko6UuGHFH9AivqyADVJXb/FHFKPwc5Cuv23KpfvtjHNgMi9ka2ePK2IawCee8Tp35Xx8zid27fuIVRh1xpy0h/gnQQ//iIjxOhZTb6bS3InuPNSnxEJvoOa3M99U3X4UxGCOzmzDCAsNkXa4OCqxhgaN+/oAqwzEZY6100AhnKmSkxnyWigZzTSQAfA2dFQd3vi4Xj1jo78vXgShcZagAj/2RZpSB0lSC1X3bjUd5X04ObERxwBYBl4iPkEcJGVqB5r9qjKO0R3XhCMc8tAtmOI1crsByGK2firR+3VvTGQgbtwjALlYOAjn16zwjyUg8VQVJcSjDKE+AC8On/MNu9IEsW4OYo2/FOIx7mq7hyhgshcX1SmQ8tC+kDbuAi6lLK8wleMMkh5wmDcyN/GzqcdZev6VPDcp2aKRo9gN3YTBYrF/k/l1sUMqAngqd5urMKBk94Y+wcCLNJ65Xwm5suSsinsdaPZaT/Er5UV8dpy/Ia6U9B//9/cfG07lVyBQ1AntyKiawthMWnF8MbZZZREPoZNgxG3D5jtlEXh4W6PfgmwWPIBNwrNhIUy/WvMB2RQPL+no/kJ+JfiJxLKhFLN68YU2Mpm7TFJR2ipWD6GseDJWqt0O0IZ4sguZ74o6zULGmRByGw9h0i7vjXPZGGbEpT0JWFIIlIsWhFrkoW3X2icARSXrrLPSMEaG85tUb/mz8jgjNUEqKleuEu/Bm3LUfbcHVGjS000q63h7a14oco5kN1hK0GdXfiIWvHxgUYR6NN13noouqA1htsZ/cMX9BSYVI5zM7Tk6A7vCA9oCHoGl2D3+u2agy49FV5ZkzcpYiktDfGsbFfP6NrXad/3F3B8wOmQ8p4uhPX0dlCRym8F2nN8kv1
 YMAGSO30
 qI9kap4Ao3xz1X0Kd6CUHcTVhvFKUAngUvP6w8o6/0/Uvf3WiOTVNDDp3w2O9Dgz2kyhpDmUOOjDVm31e0xfpSk5YfFADayE0F8oOr16QD1YRHSvYRl+QQNscP0Fetp7YSwi1eSXKxGaReFBtHpkf/yUxVYM2NNzjqd6rXLHNndwZ8fvfS4Ppxv2TQv6+s0MhTCS/MWUj3IO6FYmjJLGsXi0neeKd7ulW7NZVA6avBqOXr7XItJf74baKYbMsIOwZ63tSsan/wX6+PDR6nHRXCQnzR36yad6oiZuqPXeJ2XvKz2uQ5dRwfUeWfhJlzgC57PJJNWuG83O2EXEZylK9y1uRl69fjJvbu4txMD8iojfnWEd5L2kxKpkkD37fDDKvRXlZYryUpNdH3p2N5Nlgdx45qFFZgttyJkv/1jl6Xl8UunPJMlOv54FL52N/IxWk1lsMu1s06mLqkGiDrjZW/qaj7AosMgReDL5zOkNOpoVL3n+9rgMg8XbSIzfmuMaG2EjB3fAb3WdoUOVq5+RX6PlmQP2SixzD9cmoVWrnWanGIQIU8tKBKfCluRAo0VBUjlQz9SRv7O3CNh9tK9NQ8DpiE9uFpPmc4N8azA5q3zWhjTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl operation
correctness while the vma is being concurrently modified.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: SeongJae Park <sj@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/proc/proc-maps-race.c | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index 94bba4553130..a546475db550 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -32,6 +32,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/fs.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -317,6 +319,25 @@ static bool capture_mod_pattern(FIXTURE_DATA(proc_maps_race) *self,
 	       strcmp(restored_first_line->text, self->first_line.text) == 0;
 }
 
+static bool query_addr_at(int maps_fd, void *addr,
+			  unsigned long *vma_start, unsigned long *vma_end)
+{
+	struct procmap_query q;
+
+	memset(&q, 0, sizeof(q));
+	q.size = sizeof(q);
+	/* Find the VMA at the split address */
+	q.query_addr = (unsigned long long)addr;
+	q.query_flags = 0;
+	if (ioctl(maps_fd, PROCMAP_QUERY, &q))
+		return false;
+
+	*vma_start = q.vma_start;
+	*vma_end = q.vma_end;
+
+	return true;
+}
+
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
 	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
@@ -559,6 +580,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 	do {
 		bool last_line_changed;
 		bool first_line_changed;
+		unsigned long vma_start;
+		unsigned long vma_end;
 
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
@@ -595,6 +618,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
 		ASSERT_EQ(last_line_changed, first_line_changed);
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+					  &vma_start, &vma_end));
+		/*
+		 * The vma at the split address can be either the same as
+		 * original one (if read before the split) or the same as the
+		 * first line in the second page (if read after the split).
+		 */
+		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+			     vma_end == self->last_line.end_addr) ||
+			    (vma_start == split_first_line.start_addr &&
+			     vma_end == split_first_line.end_addr));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -636,6 +672,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	start_test_loop(&start_ts, self->verbose);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
 		/* Check if we read vmas after shrinking it */
@@ -662,6 +701,16 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 					"Expand result invalid", self));
 		}
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));
+		/*
+		 * The vma should stay at the same address and have either the
+		 * original size of 3 pages or 1 page if read after shrinking.
+		 */
+		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
+			    (vma_end - vma_start == self->page_size * 3 ||
+			     vma_end - vma_start == self->page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -703,6 +752,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	start_test_loop(&start_ts, self->verbose);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
 		/* Check if we read vmas after remapping it */
@@ -729,6 +781,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 					"Remap restore result invalid", self));
 		}
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+					  &vma_start, &vma_end));
+		/*
+		 * The vma should either stay at the same address and have the
+		 * original size of 3 pages or we should find the remapped vma
+		 * at the remap destination address with size of 1 page.
+		 */
+		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+			     vma_end - vma_start == self->page_size * 3) ||
+			    (vma_start == self->last_line.start_addr + self->page_size &&
+			     vma_end - vma_start == self->page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
-- 
2.50.1.703.g449372360f-goog


