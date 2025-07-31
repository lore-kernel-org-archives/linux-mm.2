Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC01C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F976B0089; Thu, 31 Jul 2025 18:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28A76B008A; Thu, 31 Jul 2025 18:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A660E6B008C; Thu, 31 Jul 2025 18:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 943A26B0089
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:00:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 137361A0A31
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:33 +0000 (UTC)
X-FDA: 83725929546.28.FA1E5B8
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 22C764001B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dBy9zV75;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3feeLaAYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3feeLaAYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753999231; a=rsa-sha256;
	cv=none;
	b=b1qHItwtYgTAaH9I7Zq3V4YqYvcIpqEW+Rs8QnbTArOjJ/uN7pPq3Xhrqlit0xZsSRpNsz
	BDOrIGnMKwcqwu8s86U1kEZbTCpcOrrJVKeX0flj6YzhVZ4l1nyxPLNLHfhsEBCKybI26q
	CZgmO7aLMtCYD1ZnaujFyfvDHM0fo88=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dBy9zV75;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3feeLaAYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3feeLaAYKCMY463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753999231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNceOmOhkQd57dKgoJb1yry2qV9WAY49fIuYrPBvXdU=;
	b=lSPLDMGgXTEsR1yR7uPRUzPHqUwsOtUcCdPwwxXdOo7os2gEBqvhmHAdI1gXkW9DgQOOE1
	3mbRLV/M9mcMsUppXUpBfzir8/LgIf9giKRXHuBnAIRsL/tAg47weaJhqqdTz//gE9yrwz
	B9XYgYtkNsi3bjefUOkdc7FTu7w9UUs=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74ea7007866so225009b3a.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753999230; x=1754604030; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNceOmOhkQd57dKgoJb1yry2qV9WAY49fIuYrPBvXdU=;
        b=dBy9zV75Qlekaif7Lwd3ALEgVIJ/T//6sd30DhOsUjpgkMPkAyZu00uo5MFSTT4Hsa
         lImYrxFOH6OFHC4VMreQoK/mlSSupNdjsaYNS5AjE8/ZBnTw/XhfvLk3z08yCJY/UnX1
         H1dz1IApT/LY8RiSLCiJRKBB8mMbZqypTtn5MAx2htYabwaWSlt65wab2E4JIAjQqIon
         QSaSivCIvcNzNcVebZJFylbhV4teDWrLqJ/Ru4hA/i9+Dux8rZzPq6+rR3MKyFcV1afi
         xhXSs1/ypfpLlh/T7WKkW0youswW5GBT1e4QllLmGCJgcGA7PTaF/ibPbSRDSawZ4FM5
         ZVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753999230; x=1754604030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNceOmOhkQd57dKgoJb1yry2qV9WAY49fIuYrPBvXdU=;
        b=Hi4a8wtR/CfTAJ0YJvVth4/5vTUduiej+w8PkoeUNmJmBT4kiUtBYFCCJfrLFRvnSr
         088cjg63SrepCAWmoHkjuvkm8Csjv+D/fP8yd3U+fcIk35yoADUgD3vzdLigrWrlyBfq
         C5VXqH9/XIfFTsexbYF3lctXDOpq7nWDzC5Ihn3SdRIHEFrZNveDVHkWvOr8GhSsENBX
         Z0HBvJxn6Bz3FtoTFg0/bNTylzJiz3tSdZztGu/N8GwPREgpXE5+CbA67JW/oPBwcmzS
         4GAqwxTL6FyEuuMd6xr85tKdFM0czOBRIere2Ki9++BA+tgF6yhil/5+xIuDvZL8kyTP
         iH/w==
X-Forwarded-Encrypted: i=1; AJvYcCUpRKEmAYd7uYfSgGuWEmnZujeiShUtxehm7DLrE5/e4X25ZzMmnHGG8mlymGnfQsUGhtvRUZkDKA==@kvack.org
X-Gm-Message-State: AOJu0YzMeHs9mVTYxD5p/vlmvYcpNzmZb0pQtXQl3wNJQTQGeW3VwqZC
	hLJiSCgEi08byziuogt/VOZ6wTFVSE39FOmm0EIQZRB4Hq6CD37M6io3Lvoy5YVR4bXykgMIQyx
	xeBOnbg==
X-Google-Smtp-Source: AGHT+IGN+xdEoqijDkNOjG0dwcR0a2XHO8rj8Ew1U8h+s/FjiVf73gnDDd7MDhE7O1ZnTaPwtmwN5GGXu0o=
X-Received: from pjbof4.prod.google.com ([2002:a17:90b:39c4:b0:312:1e70:e233])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3ca2:b0:215:d28e:8dc2
 with SMTP id adf61e73a8af0-23dc0e84b91mr17365554637.31.1753999229680; Thu, 31
 Jul 2025 15:00:29 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:00:22 -0700
In-Reply-To: <20250731220024.702621-1-surenb@google.com>
Mime-Version: 1.0
References: <20250731220024.702621-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731220024.702621-2-surenb@google.com>
Subject: [PATCH 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma is
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
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rygy9n19ambruerniiazepbu7u6xsgow
X-Rspam-User: 
X-Rspamd-Queue-Id: 22C764001B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753999230-793312
X-HE-Meta: U2FsdGVkX1/z1fxdsnO1+/gxfbmomIMaz/02AqmfiWxGFC4IfaIv7k9pmsRzhvU4+0XLqMzQpAvdhXohjsJwL3Nzbzf4jqZYiyUpVFSCZBG6Ioy6LiNb8neOHmBQ1MG6odNB9qubBCB1R0r79legqcAhGXz8uU0WEV36AYlSkbGruqvh3scu4E6alFgrh9ymmVYnM0QGFvcsmxjQbdmAk+nmyVSYsf8qG4nndkFlCpbYpCLW/HMn+IK70MMLO2FfudGBzVHYNYB4FGojtdjQHb4i2KVRg1tB7lbOo0p9PsWAb56cFb8JYZX+CT2kZo/W0lgnNHoVW+Fm+TCKsD3R1xr7fi4FlRNVvp46an8GoD8KqRdX8F4k0yvmu889AX0EWxlAjd3CwwK9t4/pkaMX8vQAXIQlulh4J/hcgts7hvXO6hLxsMMC2gJdqByR7E3EMZcX5wxDxGORvucOr7l5WFQbmXzcV/PRNGzmah4sijq1IRjYM2tiGHij77jtDjHH43IhfiTMk7ErIF2LAlNii7t/mzVxgjWbDaIHcAc8o9GRzXfHkeJJSHc9mp5pSP7x2zpnXko5xC+FlD+TCaSehcvwJv2uiHmAYlwX3nCeRLUd4F2IvJaXAfdICx5gNGTFnPwnQNJOP728OdxvAXB/fq+3gTdhUi51dwlxGRU7N8FobhkIHwo9q8sLutFeGnj9qJ5mEkbsQaN53IEV6RgZx+Yi40Ss4+f8yaNfAmLCdjpDqGBHZpMGQZd7hV6jAhz7+TUIetDGdiAIADk35ws2IlL/8bjF9T5dchjWM7VaT/nS8AOCgrAWLaX6u9PDHQkKwMJQB4HYCw7dNvSgURkRCdyaaaVd0UCWiEp54AfjhPppJ7CHyluTwIDhBSYZ806jpzZ66EZlEDYlEBG5zh8HeeAcpRylSUvvcPKV9aGMNVG1/Fl7KFp910ySOj6QsUXHA4gnea2vSMNTpM8QAwu
 Bb3tdW8m
 HSMIbfo7ohxDOl/oLsGo8FI7V26olqd5kPffdA5I4XxMnHPrIKDuEMasW10BJVGIW+YexElV/lhPc1i3gC3PuQPbOFHrLNf1yjto1/j8wM8tQ/ZMz0cV8DTBiCJDbOe/UbOyYcif8p8lQZcfsxMzNyOqM9tK8z9KcNcivtGmAlND9uYs5YHFEZcxwgZvkaxTrly9jLzI5bkqvmueUKQAZpdvj+tLV0+1/h4Z/DMPbyW3XgjhS+KaAZUofW+SPv/RSI8zXVdOhctTymY6m2gSZpG/slt4MNhsMjvX2O1o6k1LU0Y1KCy4V85XykqhBtb+uysAAd+mKpRty2at10BkPW6/eoc/J1QSOmQmdGgiiC/HMfGgq81tb3Bubn8TL0mdtM/9cXAH/8hWQSLRWOTuDBcRECuECpvQDh0DhyDIn9ffUghuKOTbDLRqpOQxYo/4eEWEGmaDvbxX34szhj//hnFqatRafJSP16IqJhZP0p6mezgVBkqQ0+a3dtnGmZUjvqc4KdkvRYLyQEHpWOXX3J31+qKPU7x8srf4a786IVzgKZX5xXBDu0nzwwidrygXMaCoXR2WXZRy9DOvjwQl8ut/g+5sjWZCHUyQ9c6tt2U5SvEbGPNC2CJGXrA==
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


