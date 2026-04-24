Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6537DFB44C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7424B6B008C; Fri, 24 Apr 2026 03:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D216B0092; Fri, 24 Apr 2026 03:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E976B0093; Fri, 24 Apr 2026 03:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6AB6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:03:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7C3F1C0AD0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:03:02 +0000 (UTC)
X-FDA: 84692557404.03.F987605
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1DA6240008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:03:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kADeTH6M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3oxXraQYKCNAEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3oxXraQYKCNAEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777014181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QROYaYs151R/blxNlpky7uyYcAQOpuOKLNbRD4r5/hI=;
	b=Dx+3FDt58T/tObsqDQrPg7jzBQKjR48hKCc/yaI0j/ZD3s/HypuXvyWP9dvclmxvI7bXl+
	fy0mHMdUyi/EW+JfvbQUx5A8Dllgyl8k2lIoDbGA3wuY7k+8yzXLRuJ4E/VA91rdIOyjwI
	BhuB4N++BSvvYWMbUREz0LiIdXo4buo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kADeTH6M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3oxXraQYKCNAEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3oxXraQYKCNAEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777014181; a=rsa-sha256;
	cv=none;
	b=3nXwzgxAXehpM0BVM1r3f2WpDCWw8UxZqW4e8CWd2wwfa+96yXipvZGErSNKIVCWPHYrjJ
	fpJ3hQS0yV2CmpqvKbYP16zfSTt76xQkBlsmhVVrO8tmiPXL3OJyZgw5Ss4pP6E2ZIC2B3
	XPC0ooryBtLtgIWa5L1fKH+vottU6iI=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so9251015eec.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777014180; x=1777618980; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QROYaYs151R/blxNlpky7uyYcAQOpuOKLNbRD4r5/hI=;
        b=kADeTH6M9A/xXWBzTFdQIAjTUIwSqtKKBhaLI4elhXRIs9myR1V9XJGW4viSTdja8/
         q6djHgoJ/jyq1CTB7xDKwBjO7MVROWoastfqS7Es6NPvSJyasSL0gGGPTPZhEyKuWJas
         kFioSaAfTqOVjYYSjQBmPvClnf48iBijNUqHQWpEWrleagX5AEdVKUn4p6qay8j6RSsg
         ItCZrXfoXo+dcYlYLJe7Hvk8wbgM4KpDDvy0HlVSffKm4NI/gJUIJscZOx0b6njJd3li
         W7TgZgkAf5vsL5UDw9aApSMO+mDPj76PwoUH9FkSFRIBrDXqyvrRfh7JypPgF4U5goGu
         ztRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777014180; x=1777618980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QROYaYs151R/blxNlpky7uyYcAQOpuOKLNbRD4r5/hI=;
        b=Zdi1okjz5YFpSETzvmuJLOxq56/uHbwSchb8U1zQ2bn2Jpb2gPUpZ6aiGjeFMg48kr
         eZyOCobjQTMRq52hBwpZw/8Em0ws1jGiGnGMKmcMrAnmBcbWcjxZ9efQj8My7IwnN3Gj
         CK6322SMdwAOGVAMVAol5l+RwQGWEj051Yjs/v4PQCldifVf5k0wfBKE750hgOCsob/L
         k1QKOpIRSRyXyaCroHp/2L8ZcBoUWs0H1TY3MrvlYs//bL9eDXb7rpX8hk7gsvsC2i5+
         fU5tFgAGP8y6K6DeK2AdaxQxadu6dIEmSZ0sJyWvVP1VbJSlauNxSRqZZVS8uSduQ7/w
         +6wQ==
X-Forwarded-Encrypted: i=1; AFNElJ8KGqcCCCOkTV/BDsanMLnEPH1niUMcOdHdwrn8a18bquE2aUpUcvB+OZ5hzxR4izySMgTRu56QUw==@kvack.org
X-Gm-Message-State: AOJu0YyXe2O0GUt24FFdV+fAQqsYX+z+BcNkyNaaIkJ45Ldx5DsWOULS
	CDtElMrw3rq6+spuGf6wF8eJcjy9UvxkX/7ITATvOk0h7N5l+S1J3oafFgvBBQY838Xqkk/gbVp
	F2prhNQ==
X-Received: from dybqf21.prod.google.com ([2002:a05:7301:6495:b0:2d8:b1cf:5d12])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:3252:b0:2dd:2ad3:f799
 with SMTP id 5a478bee46e88-2e46ca438admr16552962eec.9.1777014179625; Fri, 24
 Apr 2026 00:02:59 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:02:33 -0700
In-Reply-To: <20260424070234.190145-1-surenb@google.com>
Mime-Version: 1.0
References: <20260424070234.190145-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260424070234.190145-3-surenb@google.com>
Subject: [PATCH 2/3] selftests/proc: ensure the test is performed at the right
 page boundary
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DA6240008
X-Stat-Signature: ihiqkxfir7gstjqpmnj9muggazszws7h
X-HE-Tag: 1777014180-909370
X-HE-Meta: U2FsdGVkX18YHLA3i6920DPYTP90M2J9Zl4lw6r+XAbPYIrKt82n9aOR1hgZpKKoOp23PPpI9QaPy6VD51SSGe9sMuPmG7VIuKHfQDbbS/qHPH+M7rcOZSXPXKJ2NnvqzbQsGNUwkZC+TdJo+ScaW9u3nh5izLvFSedATH43E2I9zhMGD2AG9R9PHwqhpyDUggqD68tvPt2zodfwFL8AY73EUDDcITS4+f/E3mLKc07nHfTEmm82L8VMJl/8+pyCkbWVc+HNBhYekGlhBD/duwU2jjCHmt2kkLZ3GnvoimTcBED2S/HNW+LPIwBVzEB6wjYkFw9grz94OGzjXaemQehYkG4oGsE8qpVQxrPe42EcMUOIytSfrzCm6QsKfyPtQOpckTqHz4KSAHVGFIjWh1GbwMXlXRWgRZErWNm7ugJnCdgaMhbXBgH/Bnd6nx21RcdUMkkllSCixu25UdjRREKXnbp3jxOKdfUkfLYamFDTa8GryHnV6fpenkzRO5j+P1Rjkj25gPIunBGXEvdZ7AjX3I/7iW96z4pisdQbR6rdG9f+RQQgKLOC77J1s7i4TiCLvSYKEw9LGUPUTzjfAKcJB/HJx7M9qKoBonB6eUbQ22M6VGchXKgrjjOAORqYy7L9UEPmcbgRAZTDeTg7G9xyZ0vsvAon+mxYfJcz7oI4A2V50Nx3jwjoktA3pL39cJaJTaqGbAURtUxxiInURRjYczUwTbs6y5NLklPPOmKGsjzqjUD/4OzfBoIj6xLLsYBqQL62fwhY+sV25CIRGaIujxHCeRUWFgVztvJ7A6iTNUZ8g5oGCsRqZ9pi5XzicIwc27N+4imfNlV/zP+Eo4pcun0YH/1HXm9hX7vzE48Jt3blF1ow4sMWouM4JXag6hWai2X3lnkQKeXMTjE6Rr8RRrELCEDbs7Xo8yMPETZFEFYClB01aVTVWHtwkOj2w7ecbIXhpKc0/TpZtlb
 zMT0YeFZ
 UCM/T8KUvOrqynpv/J2hB8gLwvrj0P3XPH/7Re9WaNQ2Hf8oAgJmeIKUgD6echWQCHAD+LRHwCPeXF3VK6aiUdVPdVJwrty/m1yM0EKrJrC64wZAqYqRV66ERccv22Q+ZRC4M5AfJKgtrGZ9Rxl02t6q1UfvGX5jAGUiZxwUv1u7QreyuWQ6/t1x5jqjjVm+UQ8CCayATa4on5NTSQ3Ox1dOODJrA7Rk0Y6MoR1fR06kUX6vtgO4cUxN+8QMs70GshaXKGnz5CjTgyJc441cEiWOAoWthhFd7vEfatmPil9G1N/pAvvzX/oT2uGLj/Nx9l1WjiDZ3FPN+vLZm4dI+k//CU7dmNtkI8FyR3Io1MRJ4lCFaC4t66BCeWS8z/H6UucIpF9iolOjpkXbZiV79ECGkBDG+zG1WZnzUFQO80U1H93AhAFDXjR1knIW2mp46PLatZ9/oAVVdJvC7zBSHoZ3ADDaX643mVE8da3t/AR3gF6+QDDOCi6q0Bw3YpeYX03+EFGgK8CjHS+Ny2mkwCScmD1c5kBbloANCRZ22gqzGl9R+KJ8jPeZSgr7fQkcJfYAl3Khq7TCC/904C5W8maolSreDyguWKaMBx97R67hO+yj/CveMc4eNs9Z++cJBST0hkJq1oLb8MdjMvE6kMhUmI2C2dClxgBOqv054gbhj+4jfGPFhHHuRGhNSj8vKAISK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running tearing tests we need to ensure the pages we use include
VMAs that were mapped by the child process for this test. Currently we
always use the first two pages, checking VMAs at their boundaries and
this works, however once we add tests for /proc/pid/smaps, the first two
pages might not contain the VMAs that child modifies.
Locate the page that contains the first VMA mapped by the child and use
that and the next page for the test.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 tools/testing/selftests/proc/proc-maps-race.c | 78 ++++++++++++++++---
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index a734553718da..c5031b0593b7 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -39,6 +39,13 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 
+#define min(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		_a < _b ? _a : _b; \
+	})
+
 /* /proc/pid/maps parsing routines */
 struct page_content {
 	char *data;
@@ -77,6 +84,7 @@ FIXTURE(proc_maps_race)
 	struct line_content first_line;
 	unsigned long duration_sec;
 	int shared_mem_size;
+	int skip_pages;
 	int page_size;
 	int vma_count;
 	bool verbose;
@@ -105,27 +113,68 @@ struct vma_modifier_info {
 	void *child_mapped_addr[];
 };
 
-
-static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
+static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
+		      struct page_content *page)
 {
 	ssize_t  bytes_read;
 
-	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
+	bytes_read = read(self->maps_fd, page->data, self->page_size);
+	if (bytes_read <= 0)
 		return false;
 
-	bytes_read = read(self->maps_fd, self->page1.data, self->page_size);
-	if (bytes_read <= 0)
+	/* Make sure data always ends with a newline character. */
+	if (page->data[bytes_read - 1] != '\n')
 		return false;
 
-	self->page1.size = bytes_read;
+	page->size = bytes_read;
 
-	bytes_read = read(self->maps_fd, self->page2.data, self->page_size);
-	if (bytes_read <= 0)
+	return true;
+}
+
+static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
+				  unsigned long addr, unsigned long size)
+{
+	unsigned long start, end;
+	int page = 0;
+
+	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
+		return -1;
+
+	while (true) {
+		char *curr_pos;
+		char *end_pos;
+
+		if (!read_page(self, &self->page1))
+			return -1;
+
+		curr_pos = self->page1.data;
+		end_pos = self->page1.data + self->page1.size;
+		while (curr_pos < end_pos) {
+			if (sscanf(curr_pos, "%lx-%lx", &start, &end) == 2 &&
+			    start == addr && end == addr + size)
+				return page;
+
+			curr_pos = strchr(curr_pos, '\n');
+			if (!curr_pos)
+				break;
+			curr_pos++;
+		}
+		page++;
+	}
+
+	return 0;
+}
+
+static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
+{
+	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
 		return false;
 
-	self->page2.size = bytes_read;
+	for (int i = 0; i < self->skip_pages; i++)
+		if (!read_page(self, &self->page1))
+			return false;
 
-	return true;
+	return read_page(self, &self->page1) && read_page(self, &self->page2);
 }
 
 static void copy_first_line(struct page_content *page, char *first_line)
@@ -418,6 +467,8 @@ FIXTURE_SETUP(proc_maps_race)
 	struct vma_modifier_info *mod_info;
 	pthread_mutexattr_t mutex_attr;
 	pthread_condattr_t cond_attr;
+	unsigned long first_map_addr;
+	unsigned long last_map_addr;
 	unsigned long duration_sec;
 	char fname[32];
 
@@ -502,6 +553,13 @@ FIXTURE_SETUP(proc_maps_race)
 	self->page2.data = malloc(self->page_size);
 	ASSERT_NE(self->page2.data, NULL);
 
+	first_map_addr = (unsigned long)mod_info->child_mapped_addr[0];
+	last_map_addr = (unsigned long)mod_info->child_mapped_addr[mod_info->vma_count - 1];
+
+	self->skip_pages = locate_containing_page(self,
+					min(first_map_addr, last_map_addr),
+					self->page_size * 3);
+	ASSERT_NE(self->skip_pages, -1);
 	ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->first_line));
 
 	/*
-- 
2.54.0.545.g6539524ca2-goog


