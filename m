Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CC2C87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C646B0099; Mon,  4 Aug 2025 19:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3E76B00A2; Mon,  4 Aug 2025 19:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D26A6B00A3; Mon,  4 Aug 2025 19:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45A7B6B0099
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:16:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 150BB160A80
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:16:01 +0000 (UTC)
X-FDA: 83740634922.21.29290B1
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F4E220008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:15:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tHIfiaYG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Lj-RaAYKCD0rtqdmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Lj-RaAYKCD0rtqdmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754349359; a=rsa-sha256;
	cv=none;
	b=2d148CdHyBl7547MRv05E+TZmU7MMvCXiBUGUYiDE0Or2+SoYyxz8qWpMmXKzHoZh4SWlt
	nNe1qWu61d3BPHliZ5Jq/o6nul3FGasVFSteeRGH09X4XVeSI/RzzKeaGshvKSqDH1USFN
	e2/hzS/tuSlJphQ2tdawss2EKzjZebs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tHIfiaYG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Lj-RaAYKCD0rtqdmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Lj-RaAYKCD0rtqdmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754349359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rATS4q8eQgXRIMxeVI6i3f0N8VShHmldfKu+DIDZEpI=;
	b=iFv9bV7SMbybfwEBaDANvupioxR+TcLDQfNvD2Knu4OW5knUiaz4R++RU7SsvX1k0fwPp6
	jVr9GU0LjHFVxowRyUJLNnsHu8buuDdIi0vTRetCdej4tmpmr1hQ3X2yUByDERdUbYaqAj
	l6A3XyobTKRSlIeO+eCXC+5IXFvhaI8=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f74a64da9so5552360a91.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754349358; x=1754954158; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rATS4q8eQgXRIMxeVI6i3f0N8VShHmldfKu+DIDZEpI=;
        b=tHIfiaYGGOBlq71oolBmeIEthFe4xVKs0nwRuFbv5/ojxQcExHFEEiTbtz7tzZDdXb
         CtYBf+2jh+g+ONzpXqxs5XHHGViZihYpdjhoJVlkJh5AbSJYP3FtaCyLST61eUl65zrk
         2t0wXvG3rTAj226J6nD2XtSevqmBMlahJR2yFFdLWR0MVW09QdJ6QtuBefSkdrO/U42z
         DP8ex4pvtXmFpJd9CWFb8bWWDXeOPq96iYqXra7zsLKFDYReL2/JyCEtC1oDE/KXPW1R
         5p/d7bqrn9xMEHMQJrK2iwFSzlkQdXvY2TRbhKw2WmcVncukbELgBykXfjpJdNW/kjfn
         WqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754349358; x=1754954158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rATS4q8eQgXRIMxeVI6i3f0N8VShHmldfKu+DIDZEpI=;
        b=E+eNwH+hbCdNL1u/msU0D1oUmFP/lV2JGKy0jNl17nQy+FbP5RWcOnbmqUyXxBbMHN
         +gIvj3ZHWvIwwYeAX9gJ7l1omNZJLoLCvTRwrpyxCO13ei7rgYUz8iunTBUqkerIqAqg
         kIel5tuRUgOO05pT+P6y6c54+mJlrYkZvmXfdkSRzGNuHoZWl74zte4wAYcyg6J7dfwx
         I5Q9c/pBk/Udd/ZSQiZCevv3A/3dax78rWoY4A7ksHYvKmpOE3w+b/KGbWasXdt4Fhpf
         3/Zy0ofpO78qucbqgYEBGBZI7nMPM8yMgX/sfZTWciNwrsupxmhPdSyBezcaI/iJ/mN5
         XvEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzfizO/PxEkioYjEVTx/qXHK86Q7EjU7TEQ/oiT8G0y+zkGdspxb0yMUrZ0wAN+YJlNP9D6FTHfw==@kvack.org
X-Gm-Message-State: AOJu0YypFt4CHQ8hxHx7bkrOINLjl1bO3n7e3T5yPnigCXzX3lRyDJE9
	gR++jlJ+W3sPgFwb4N/vI2w/2T0dgsClDuEfoSpCbGy2jWU8tQ1YIjpj8UTWo6srBL/0dYbQROI
	mkRkf1g==
X-Google-Smtp-Source: AGHT+IEuSOf2jMTxPxDkqYSl5LW5Zcze6ynU2QOTKW6hn3gYFMFUvn0B/NfoN2M6d8RkK8dOvKSIuLnzjmM=
X-Received: from pjl8.prod.google.com ([2002:a17:90b:2f88:b0:31e:d618:a29c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a88:b0:31f:867:d6b4
 with SMTP id 98e67ed59e1d1-321161f0711mr16728967a91.10.1754349358011; Mon, 04
 Aug 2025 16:15:58 -0700 (PDT)
Date: Mon,  4 Aug 2025 16:15:49 -0700
In-Reply-To: <20250804231552.1217132-1-surenb@google.com>
Mime-Version: 1.0
References: <20250804231552.1217132-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804231552.1217132-2-surenb@google.com>
Subject: [PATCH v2 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma is
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
X-Rspamd-Queue-Id: 3F4E220008
X-Stat-Signature: x4jydt6acg835j3kdz6q7p4kkf89hx5n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754349359-262736
X-HE-Meta: U2FsdGVkX185g5vHKxcoh0DKlv9A+XQK9xD4ck1zKkFPi5O5uCDF9UTJ8cVpLZYhtl3bi2tVrwjXRo8m+5n8gD2aeYe+1xgBKoejsmX1eUwNfHlSmV9YJBisMHo9BoqLorqbbjJ+avbiXZK+WM5Ten8dYKbW8HUJbzFOa3cCdKx0VaNWm42ZCfX6r8pYckZNdOHkyNrt4dgfQo0jrmYR6dRumPt6bPmt21RqvaFOx+Y4kkTJKIQkc9txoZtuSdfCO8YerngukxBsjeoF4E+NTSciLeOSAFMB50LG4+o2S9E817L4Gwi1MONT3OuUqeUTasxmD0QBcIeuOyYddhUHQIZ4qdBO1WCWKWesyqWFKksOSJL3VZLymM79sLO6WmZ2gP+eGKn0RUoL1HNMsJdzS2JLu7TdPYBfzhvZ0DMwZnNi91GLQYD4Ujb50wcdLdtmdmbmXBtZgOKhgRgEtcDb1YNalPWrktOY0r8H/P2IgUqRDppKN0M7Rn4SBwyAugE2vkAqU0KVMyTbI7zMGOTcjepNXpB+ROJlQ4VChwAqtlfey8Tq6tPgwBSwhWGgDP4+RwP7Lh9+v6pmYMyCctjdZ8ftc8oYwHd2UPAddNPbET9uIOQL+59a9GiKWEZH6bqu10C+pOn2tsXCheoaJANX3r0uMdTtFvW5BqpwNtXaJyDRPuPoTrAO8+aUhmjuZBIMdlpLgq2kVWKlZVTyo+svkQN0bhnOIQ86tK1XmRmbUsstdjPp6k+0mz7r+R/2lTueMrB54yP1lcM+SoJmb13RLxu6NVbt/0SmyOUzfF3dUL2eY4I4ifIwzJUVev2c2Ec7mfRUgVbpBdfm+ZdpKCdmyszto8lDlvNExS1F9uGmskE1bZdFX4SzLkKoc95DXaNErQfMD/swG1YVEVdGOJzAEKV8gKBOM0cW+jrbX0y3ftin4ZyE6liW6iN5AKgQxQqhf6VrZi5ftT3E4g5Dubn
 WgGetHP4
 6fpqNp9ebKzbKW007bLuII6zTylS0mls+qf2e06jitk0TxisHvIYMllstQ4T3vjCOo+iM3ebvt8AiN2kc7fqzn0mqFlxJ3WvnRUnamhJBECfE5aa9oauBhjjxlTNXOLkhwih2AVQrcdzYxpxaSjCUIgmOP+RupaXLU3xe5sj6rlkTvDFDjzg8eDKFKpXtND9ZDZXMqJHrZKhhwQ668rhpDlUEsdHNtxxpQT6fzmlkcU5rkD6KSTaTidH0T+9hAp8RW4ocHYJJFdXON3MSIychX7lr+JCFvTeNKaxcPE0sABk3nz5UG82JcqeEAL5dtdk1tCmJgVqbAV2D5SvO9zEsJyoePpUqM/aukc7veFW65E0Ty0fj59E+w1V3OmsTTQAeLkPvILzb2w69pDwT0kFgbPClmE8SlbSvZNq11OWG3H/GDdFdgSrqoQ3jSp/1n+F8iiQeznphf5SxWqdIpz4qCaAJ80ZQKojiImDxiGYT2JJ0fDs+iv+B6CK4Qzs33+bNn7TKGhRzWeXOIhq9bLJLRT0fc+bDM2p5f7BjuTNU06kCUkKPOCWKJPOe755R2qvfNxMU99NhUn/2RvAO0IWNP2fTYHHR5RVrBDjqS9m5HVWkJeQ=
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
index 66773685a047..d40854a07ec1 100644
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
2.50.1.565.gc32cd1483b-goog


