Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFBCC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791E46B00A1; Fri, 18 Sep 2026 11:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7426D6B00A2; Fri, 18 Sep 2026 11:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631AF6B00A3; Fri, 18 Sep 2026 11:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29E406B00A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7EDFA6211
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:38 +0000 (UTC)
X-FDA: 85227277716.30.CD56CEF
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB74F8000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UZpRUtoV;
	spf=pass (imf30.hostedemail.com: domain of 3z1mtagYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3z1mtagYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSlM5tp89ADGL7d7hsn2qc0Ifj+pabEAxR9BGEjE7ls=;
	b=MYp1fcpjV7VAzmih1qoaFJ+2s/unVq3os5d46hj+IkBZqnJhekoVa63oyLTrnqbf24I2zK
	S83i4lg/NciVZifD+u/5/mriq1IUxsj8Y0QqDIHMOrfoEjbC2mjbEtDWswxVLTDnkzqXKE
	K4m83nVJ8Qykk/c5DmpozZdWwwmyL4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745616;
	b=l8gFu0WfB/1kovqToXhcEZbl45Dqq08ddwm2dlPsnKs99bZjcMxUGwqS7tQ31pzC/9ykIs
	cQ3DAcf9Q2hsvESIdk/sxZIfws8DImJQajhCL6FZ580mxl4IoTz5SK4uU3Rf2fa5oMU/Eq
	A7/eVO2DR2Cj6y5/fcdIsYRkmYvhfug=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UZpRUtoV;
	spf=pass (imf30.hostedemail.com: domain of 3z1mtagYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3z1mtagYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2dc7337e2a7so12015405ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745616; x=1790350416; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qSlM5tp89ADGL7d7hsn2qc0Ifj+pabEAxR9BGEjE7ls=;
        b=UZpRUtoVBm/8TbjGZI64NgEWlv+IQSI5H5JAKe/x9Se9BGstSqjf89W3bgwm70CVmh
         Yehck43O5vWpmo9qQYMGYXCq0y6RqaZvrwTbijdw7VQ52BBJrWCiMZ6+JJYP6Sge2gn2
         ejdXxSWuZXkskqlb1BhFlfd936cR5wvc5tiM7C9bTxupAOWQqA7e9y2DSif4JE7lnBPt
         pLFNlrSQTdLzXSrmH2UifJcQ8wTXz/VzFAVAY30E+7UoeQ7pf4cnb982nTWlARaQPzPZ
         N6T4jwmHv2rthALGkprUF1SCX/7xSuudbzy10gybfFqUBEa75knvfaOEC08l4bCVUgnF
         y+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745616; x=1790350416;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qSlM5tp89ADGL7d7hsn2qc0Ifj+pabEAxR9BGEjE7ls=;
        b=UI0nsCcC9fjqcNHH23BDkXFciFzEscEOyCRXW4UqS6iz2Ovwrj5En1kiKMlOpnWXQ8
         OXfiqm+InpZ75be8eZEIVtZ5MsmJMOhxo5a5mdZffBY9r7Epl5UbeEokUkxRiezHel+J
         GUWTIRnwbNIGCN9U2rBPlNQFgZCuO+2g4Ag8FuczkahexEzkrg7oSmsloMc9hAfbjTv9
         oY0wBg/9qwhcebjyt9hVlQ7FCOVIzHzm7Z0IJYwzKhRPw7Ye7FXHpNGELVZjwIIerXXq
         QA6VJrau1kHPvBAHG4TwAxCZgjlsh2CvcdeUUcP1IAkP3kSWwj3EAO4blncv+nfw+bnK
         wpLg==
X-Forwarded-Encrypted: i=1; AKwUvByacnFfp8lkqzq4U3+/p0U/0k1+VrQ68YK8n0TIqfVc7eUecrYLrjrtjHhgs18rG2nOVKCmMAZ0BA==@kvack.org
X-Gm-Message-State: AFuF++kPBflNAko0lajx5uRzUlyP5ENVusAt60LHMEIDCIHb2T5ysLhK
	dNX6uK0IvV8tMQZS7Y/Nw/yFH4aazGVLTkfZBCSECvadGFAJUzxo6p9+esKEVW6cD+LHx89r6px
	cYasI2g==
X-Received: from plly11.prod.google.com ([2002:a17:902:7c8b:b0:2dd:c0fa:93f7])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ac4:b0:2dd:c0a5:6634
 with SMTP id d9443c01a7336-2ddc0a5674fmr2432485ad.15.1789745615483; Fri, 18
 Sep 2026 08:33:35 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:18 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-8-surenb@google.com>
Subject: [PATCH v5 7/7] selftests/proc: add /proc/pid/smaps_rollup tearing tests
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nogfbdwzm4j9mqng5jhg8oqyfpzrdp14
X-Rspamd-Queue-Id: DB74F8000B
X-HE-Tag: 1789745616-605920
X-HE-Meta: U2FsdGVkX19WFuuI6fN4GrvadoO4LM12C3LYsXJRbNKH4Ituo3nZ59oDZuXO5nT8Gd1LQcNwlyyLaCk5uJdaMhev/zH1aUPhSRumGUUPOsymubGevErkUZRJTZQAgWby85UUHysGJPrHknWQGkfpzMAK/ptGqWprzxoq5fvoa8bC4cnsyOowIQNvyhmHWWYvjPJLOwx/u1DMd7L63lmUuqx646QPIkL/k1agkBnAnVtIzbxuHDnjHpFsNDKDTz9pJzcHOJiY+oc0iH3zleR97pdKOTZa6VNnsBXwZ6UhXIMiLWvSHsF31prRiV6M325lfUL0p3Rw8x9U1fD6dE5LLnhNfFpQfNx+4MAh3amaKkj1xtFyAqyrW92YjhRNW3sXUwHAbXPDlVwjlhhaJNnZ/mhWD/qqDJpnVFfe1zt07NjRkk948chVZQBOk1t4W0bZyAkyIFpAaYgC+WDZyUyG5nsZf6vXnbUIMNqWDHAHT2O3vVRKkUqvYMlbJr8fBbxmS/Em8fd43QLAOsEnCmW1A2BY68YUXUlxns3M95k33rDmkvJ/RS6/sbBo8ptj2TG/nrlCxiiRPPvYu6FVm35TSOs+sYqjArYZPmmqD6CAmJUMPrqao9EWLskqgZ8JhzEAaE1e4m7OfGHtGYNmXx6HWtGgyvfUyG+MKPIYzwK3rjYHGivjFkxTh6adMUZYngiOwvbP1gu4F4sSP0/44i9U5UnaucYljyKOIp8xVp2RUUnCLqcv49vMb8lfPSmd2ahA/MdAVrrfqIgJ0oJHKh8cZIUBZ1eE3wDPUXdZAkTeQcDdZ8K9ZDnW3FPVvt4anfq8ON/jVkwPX3u6KI6gjGXOUB140xk8HSE3pZ3R7ThZ8MkkA/g7aviNthXRVWrdlaK0aLaPwod7oEmIc0+4BCBn5KeU4JjwEDccKezJXhB7LskglKoDX4etqAc1Lkqg3fpgl9jT41D3qRawFnhXkib
 22sq3OT1
 IAyShaIsP1QZ17x5Lr7Y0T/Pv0Yshf79LxE6phO7iL5PAeBQvKq/0iHPjjNALBNqcMd4IoleNJN1cvJHQJNGDMQuwnqIz1B1pCbPUiBWnhXvq1Cc3+MI0Y58FeT8YI8yBCMY+IYpMVy5RiSBzSw/fTRe3wYA/dxhzmWcW+jRqoeX+qko6uzxi3scTM7EIHXfruYzUNZrMmwprDX5Sg+QPhx8VUm9xB/BcImPB+auWYoXImyDUQgQ9WbkosNk7HsO2PuuFBRETj4lI5/WU3Mv7VcIj8Fct5m4jc7cF7iDVt0lwmY+Njkeqcw7GV20XxlErNhX3NT3M6WG1yiMSZhnSAv0l9HKNSLR/NXGTgC4xPVibpKc0M9eB01WQraB/ZbytK4/muWWFzJvYyAFZuCji6Na9iFf+IueY/WUyxv7q/V7MQrvXyvALLUQt+NAZVqvK6cXX6gyQKB5Ex6EQUGL5TANAFpwxMjtxTDRXRee3UkeUZ47c3/rpynOmxh6xPO2vfElhYGZ5wnhNbbjvoStEx9JzN2TF+gWjrURqy44Y1ol6ZvBqBWpAvBh0icC4dwrjJsVU5jgIDDqkglPmjostmvshwl64sscO7PXTPvuqo93DV5f11bCh3dg8OdejnYNnu+u3IwsPQulaQup41s7pBGkMiR2QmvC8ReZxt8h1H6fRPPQJLgWX21rxQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During tearing tests, smaps_rollup Pss* metrics should stay constant.
Extend /proc/pid/smaps tearing tests to also check for smaps_rollup
consistency.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/proc/proc-maps-race.c | 186 +++++++++++++++++-
 1 file changed, 181 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index 415eccb70468..bf4c5073f6fc 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -80,6 +80,61 @@ enum maps_file {
 
 struct vma_modifier_info;
 
+enum smaps_rollup_stat {
+	Rss,
+	Pss,
+	Pss_Dirty,
+	Pss_Anon,
+	Pss_File,
+	Pss_Shmem,
+	Shared_Clean,
+	Shared_Dirty,
+	Private_Clean,
+	Private_Dirty,
+	Referenced,
+	Anonymous,
+	KSM,
+	LazyFree,
+	AnonHugePages,
+	ShmemPmdMapped,
+	FilePmdMapped,
+	Shared_Hugetlb,
+	Private_Hugetlb,
+	Swap,
+	SwapPss,
+	Locked,
+	RollupFieldCount
+};
+
+static const char *smaps_rollup_stat_names[RollupFieldCount] = {
+	"Rss",
+	"Pss",
+	"Pss_Dirty",
+	"Pss_Anon",
+	"Pss_File",
+	"Pss_Shmem",
+	"Shared_Clean",
+	"Shared_Dirty",
+	"Private_Clean",
+	"Private_Dirty",
+	"Referenced",
+	"Anonymous",
+	"KSM",
+	"LazyFree",
+	"AnonHugePages",
+	"ShmemPmdMapped",
+	"FilePmdMapped",
+	"Shared_Hugetlb",
+	"Private_Hugetlb",
+	"Swap",
+	"SwapPss",
+	"Locked",
+};
+
+struct smaps_rollup_stats {
+	unsigned long values[RollupFieldCount];
+};
+
 FIXTURE(proc_maps_race)
 {
 	struct vma_modifier_info *mod_info;
@@ -91,6 +146,7 @@ FIXTURE(proc_maps_race)
 	enum maps_file maps_file;
 	int shared_mem_size;
 	int skip_pages;
+	int rollup_fd;
 	int page_size;
 	int vma_count;
 	bool verbose;
@@ -132,12 +188,12 @@ struct vma_modifier_info {
 	void *child_mapped_addr[];
 };
 
-static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
+static bool read_page(FIXTURE_DATA(proc_maps_race) *self, int fd,
 		      struct page_content *page)
 {
 	ssize_t  bytes_read;
 
-	bytes_read = read(self->maps_fd, page->data, self->page_size);
+	bytes_read = read(fd, page->data, self->page_size);
 	if (bytes_read <= 0)
 		return false;
 
@@ -175,7 +231,7 @@ static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
 		char *curr_pos;
 		char *end_pos;
 
-		if (!read_page(self, &self->page1))
+		if (!read_page(self, self->maps_fd, &self->page1))
 			return -1;
 
 		curr_pos = self->page1.data;
@@ -205,10 +261,11 @@ static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
 		return false;
 
 	for (int i = 0; i < self->skip_pages; i++)
-		if (!read_page(self, &self->page1))
+		if (!read_page(self, self->maps_fd, &self->page1))
 			return false;
 
-	return read_page(self, &self->page1) && read_page(self, &self->page2);
+	return read_page(self, self->maps_fd, &self->page1) &&
+	       read_page(self, self->maps_fd, &self->page2);
 }
 
 static void copy_line(const char *line_start, const char *line_end,
@@ -317,6 +374,61 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
 		      &first_line->end_addr) == 2;
 }
 
+static bool parse_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
+		struct smaps_rollup_stats *stats)
+{
+	unsigned int dev_maj, dev_min, inode;
+	unsigned long start, end, offs;
+	unsigned long value;
+	char name[32], perm[5];
+	char *curr_pos;
+	char *end_pos;
+	char *line_end;
+
+	if (lseek(self->rollup_fd, 0, SEEK_SET) < 0)
+		return false;
+
+	if (!read_page(self, self->rollup_fd, &self->page1))
+		return false;
+
+	curr_pos = self->page1.data;
+	end_pos = self->page1.data + self->page1.size;
+
+	line_end = strchr(curr_pos, '\n');
+	if (!line_end)
+		return false;
+
+	if (sscanf(curr_pos, "%lx-%lx %4s %lx %u:%u %u %31s",
+		&start, &end, perm, &offs, &dev_maj, &dev_min, &inode, name) != 8)
+		return false;
+
+	if (strcmp(name, "[rollup]"))
+		return false;
+
+	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++) {
+		int len;
+
+		curr_pos = line_end + 1;
+		if (curr_pos >= end_pos)
+			return false;
+
+		line_end = strchr(curr_pos, '\n');
+		if (!line_end)
+			return false;
+
+		if (sscanf(curr_pos, "%31s %lu kB", name, &value) != 2)
+			return false;
+
+		len = strlen(name);
+		if (name[len - 1] != ':' || strncmp(name, smaps_rollup_stat_names[stat], len - 1))
+			return false;
+
+		stats->values[stat] = value;
+	}
+
+	return true;
+}
+
 /* Thread synchronization routines */
 static void wait_for_state(struct vma_modifier_info *mod_info, enum test_state state)
 {
@@ -397,6 +509,40 @@ static bool print_boundaries_on(bool condition, const char *title,
 	return condition;
 }
 
+static void print_smaps_rollup_stats(const char *title, FIXTURE_DATA(proc_maps_race) *self,
+		struct smaps_rollup_stats *stats)
+{
+	printf("%s", title);
+	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++)
+		printf("%64s %lu kB\n", smaps_rollup_stat_names[stat], stats->values[stat]);
+}
+
+static bool cmp_smaps_rollup_stat(struct smaps_rollup_stats *s1,
+		struct smaps_rollup_stats *s2, enum smaps_rollup_stat stat)
+{
+	return s1->values[stat] == s2->values[stat];
+}
+
+static bool compare_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
+		struct smaps_rollup_stats *expected,
+		struct smaps_rollup_stats *actual)
+{
+	/*
+	 * Clean/dirty metrics might change but Pss-related ones
+	 * should stay constant.
+	 */
+	if (cmp_smaps_rollup_stat(expected, actual, Pss) &&
+	    cmp_smaps_rollup_stat(expected, actual, Pss_Anon) &&
+	    cmp_smaps_rollup_stat(expected, actual, Pss_File) &&
+	    cmp_smaps_rollup_stat(expected, actual, Pss_Shmem))
+		return true;
+
+	print_smaps_rollup_stats("Expected stats:", self, expected);
+	print_smaps_rollup_stats("Actual stats:", self, actual);
+
+	return false;
+}
+
 static void report_test_start(const char *name, bool verbose)
 {
 	if (verbose)
@@ -572,6 +718,7 @@ FIXTURE_SETUP(proc_maps_race)
 	unsigned long first_map_addr;
 	unsigned long last_map_addr;
 	unsigned long duration_sec;
+	char rollup_fname[32];
 	char fname[32];
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
@@ -649,6 +796,9 @@ FIXTURE_SETUP(proc_maps_race)
 		break;
 	case SMAPS:
 		sprintf(fname, "/proc/%d/smaps", self->pid);
+		sprintf(rollup_fname, "/proc/%d/smaps_rollup", self->pid);
+		self->rollup_fd = open(rollup_fname, O_RDONLY);
+		ASSERT_NE(self->rollup_fd, -1);
 		break;
 	default:
 		ksft_exit_fail();
@@ -711,6 +861,8 @@ FIXTURE_TEARDOWN(proc_maps_race)
 	for (int i = 0; i < self->vma_count; i++)
 		munmap(self->mod_info->child_mapped_addr[i], self->page_size);
 	close(self->maps_fd);
+	if (self->maps_file == SMAPS)
+		close(self->rollup_fd);
 	waitpid(self->pid, &status, 0);
 	munmap(self->mod_info, self->shared_mem_size);
 }
@@ -723,6 +875,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 	struct line_content split_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -736,6 +889,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 	report_test_start("Tearing from split", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &split_last_line, &split_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -799,6 +954,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 				     vma_end == self->last_line.end_addr) ||
 				    (vma_start == split_first_line.start_addr &&
 				     vma_end == split_first_line.end_addr));
+		} else {
+			struct smaps_rollup_stats stats;
+
+			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
+			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
 		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
@@ -817,6 +977,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 	struct line_content shrunk_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -830,6 +991,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 	report_test_start("Tearing from resize", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &shrunk_last_line, &shrunk_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -880,6 +1043,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 			ASSERT_TRUE(vma_start == self->last_line.start_addr &&
 				    (vma_end - vma_start == self->page_size * 3 ||
 				     vma_end - vma_start == self->page_size));
+		} else {
+			struct smaps_rollup_stats stats;
+
+			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
+			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
 		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
@@ -898,6 +1066,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 	struct line_content remapped_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -911,6 +1080,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 	report_test_start("Tearing from remap", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &remapped_last_line, &remapped_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -963,6 +1134,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 				     vma_end - vma_start == self->page_size * 3) ||
 				    (vma_start == self->last_line.start_addr + self->page_size &&
 				     vma_end - vma_start == self->page_size));
+		} else {
+			struct smaps_rollup_stats stats;
+
+			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
+			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
 		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
-- 
2.55.0.1082.g2b9226bbc0-goog


