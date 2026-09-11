Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4FAC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84B16B00AE; Fri, 11 Sep 2026 15:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E146B00AF; Fri, 11 Sep 2026 15:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8879C6B00B0; Fri, 11 Sep 2026 15:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8F86B00AE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:42:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D89ACA0354
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:34 +0000 (UTC)
X-FDA: 85202503428.20.F36D9C8
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B34820009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STvW5d5J;
	spf=pass (imf03.hostedemail.com: domain of 3p1mkagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3p1mkagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155753;
	b=ET3yF/gm3nNUEGxkeVABPOQyPY9Enl5SOLhW8rFRa+mC1n3XMRxFv27wSxblMOeLm3bsLO
	Y5tC0vcD855lMHrHASACVmN32O0AL2qpCFwgVUQQl3YpWLgDaiKXxF9e0lWuTOPCV3nDvY
	gUck7uxTBu70JIK4ZwVgUf9q+Cs+0c4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STvW5d5J;
	spf=pass (imf03.hostedemail.com: domain of 3p1mkagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3p1mkagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ohbs4z+CUsr70I4edsl15jnnhRHi6ax7ubJItL9lr8=;
	b=DG40WTzkNQDqbOR8pxQLZYwbP+2/RPagKGcbj+1tT6IUfedTZJiiPMluPBafK+gciqL9P4
	CHaQYkjkkXiWsBir7acthuibhmAWN5I43IvZFnCRqLaE8Z05goMj3/BHWTAdY2wgutn4JP
	1zuwumhThVgI/3gix0Z2zUI8IuM7rjY=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4a447d275so1848554a12.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155752; x=1789760552; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ohbs4z+CUsr70I4edsl15jnnhRHi6ax7ubJItL9lr8=;
        b=STvW5d5JzM2pYWmmSQRWlUQr5u6MybEBRHgZiSivCPfvEwFPjhAduz9/u+abiLuYHL
         6F0wN64vmrNStNHpT8dhD0s8qKuzlnW9qcwhsuVNc9VFCK/e8xEkLCXlIwr5yfVxpn/R
         9e1L+SsOXD1nOcDjQUPgG4+UNkvaGLAhjPs1RhSDzi8SBu8XHd/NnXRpM1p0mRYrJeeb
         GjxzRhFA8IMsXhmatrMBagVwZQNiJVldW2Yx5UFU36XtT2cR4ZUStxei7MifDuNBmugZ
         YeadObVqQeWKR8inZstJRmQIiAW9wyIok5bqSYfP58tFkPAY0TzqeEGgQi6IJOvMgn76
         aTKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155752; x=1789760552;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ohbs4z+CUsr70I4edsl15jnnhRHi6ax7ubJItL9lr8=;
        b=sOzxtyK4VxW+fqb/wQtukfanjmirqvKQPeQb97EiPvQQxriUk80ZidMQPUpNYGIhpK
         UyIFCClHxNWVaOFK2IiDIZdl5j1p3sWw7nLKKdqFogtzxQzKYE99nirnb8oUsORm77wZ
         8c3VLI+KTgJ+rnyZdbAPzaUArbeEJil3mJxwxCcbKw8Oe1vP/KNjOqgly3UZEAc2uJAy
         bv1xud6q6GonhDHajX+6/dmPahx+QpzkrSYo9+p8xoFmSVuXmeophKI9bja33Spto1I5
         IF7dN0/vN0yyvAVZc3oMOEHM7pvNyZepWK7nkVEqas3eqcAEnHQ3fLojXMD0LaUKF7V0
         ZWKg==
X-Forwarded-Encrypted: i=1; AKwUvBxAYzZXi5bC14GdR1PBsaEm8hyrVNKsywwDCyHxn/lKw6SrglY7iO1GAGsHdNer1GlxjLdsWFnPdA==@kvack.org
X-Gm-Message-State: AFuF++lwk1oBJCQT8zitq9rzjqJbSCmjGEwVgywszx50JThk0U5gXBAu
	qd7kQgaVFAFzJIYDxUSF6rqSWQS0H+cUZWncNguOx2dKLrOmAATd22d6inSE6ymSaHhe5qVNswQ
	ZPzvI1g==
X-Received: from dybdn25.prod.google.com ([2002:a05:7300:bc99:b0:31c:55a5:e131])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72aa:b0:3da:bea4:6215
 with SMTP id adf61e73a8af0-3daed38c5f8mr10656354637.19.1789155751652; Fri, 11
 Sep 2026 12:42:31 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:45 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-8-surenb@google.com>
Subject: [PATCH v4 7/7] selftests/proc: add /proc/pid/smaps_rollup tearing tests
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B34820009
X-Stat-Signature: 6bi7hbbjtdocup1ha51mm6roir57tgn7
X-HE-Tag: 1789155753-667080
X-HE-Meta: U2FsdGVkX1/6WxEorRH7wDWoHnV1DG4IDlRVJxzztTcu2LGWljfpfR9vWv/XJO7d+IUSSPl3sw8ggpjQsz3QA4BxZXNMXJcCNe06sYkoZJFEtLnGFBPkqC1aqBPOdlqkGPTsnjA349Y0CHtCyxU8FouXMBfaUSfUQSnWC+dyKELt/jc+b7hoXKOftG8Ow4pehNfyp0dFDEdbXVyW/GHPC7u9ZpdBZw2cnlgE+fWwVuNpXzVMeyhQD34hrqzbtNYoOQeNlzo3+0npz5EIBdUYHOQ56N9k1u3DSJL5SlypCO+o2KEb98mkxtmQatvBKY9+o3xj9QzmPsKrqbMDe6u+UwwmqLQnRqlfhRi59b88S5iCK4MlGIE92yBo8FpWm3QOw4H3V7dg8p6B/OLC0rAUlLbkDTigxDj7Ov8oBlvUiIVl1h1aQtU+SJ2tPyQkAg2YVmPQo6d+/9uPyhplUWjSFqswgrLTIWOYvNCSLIk0SbFUrzbjGdHd4l4SArirLupZlHJ/5IEg9KtMM/37gYzyIxXxnKj67CzHcIWCdvXDiEXJB9045HraluPuNp+aZlNoyfA9R7i7xzjLgcnVYwPDBfIprLIJ7ye3EzbRQuVOPzBJKzKWGUdgpJ/lADuLw7T35XyuIgy+Xafug511J9OyyH5qUQY7cp7bxEn5NDxR2l2K64l3WQBaD6iSata4NEW9CWL/PGTjbZ/oUnCRnsnhHa/n83uZ1JMih5SvJ9PofoOB4ssykwEWo9As5I9KPT9Ae3FLIyAGXrl7maNhIkJFh2t6/a6ZOL9J41p6PyatHR4Ohc0ZyUsqc9mO6w7/vSV0ubSR9megwNhTPIMjAVrA7rX19Ioj2bUVbMCWnDUyoeKSfVcsAe5dRu9RkHcCIi6qfnVqiL55BOmp21xpSWUhV98LISOq8oL3yA+EGADN8IafduyIzsPk+GZY7/Uclq9d93ut5s6bfNpmzv4sW12
 237m7rdN
 OXl92alZSESJObc6sBeBVKWK67fSY25GXfvnvNJGhqmYZrHp3coZmk6RP9k8C0B5zmS4ibpynDf0WIRNwD9U5tbMn15LJSSSGomCFNSQK4q2ZP/l0zlCWnuAWksPyCAkaKdVL4iaN8Jv8meUwXjekqpY9B06q+sZlyYgZOdB7qgPjBqeurxynMiQJujDUA4ngjUqtq/ii2IZGxGeC4nFUOLD4kwCIxfsP8v/ajWc0ZW39y8InguQ6YtgKEATUc89o+pQ6R7pnsSFXlRQv637YfYWy1uFV7zj+vcT1CgfVOfHIXVi93/M2DO1zvPr4vdK9x4iGYvQwge7NvmDA/ri0ytjEfhTeTZNxdG3QM99TM3q41njkodqi6cQYdUJGVYE/NDmUMkbM+Vc0eRHbeEE4EHPmnxWTbq5bYjC9hIhDbLvzay/Z4ZN9rhVk3izRPp4KLMk7gX5+OzBurF6PnIYE6JY75DOGpJaqj5csXNveknYxd3NdrG6M1zOsAne4u5olJs/iN5g9FMwYbE9SRuZ5gO4f+wAGeHcflTqK0bN83bgsayFIG+AMMtNb6FRaAeQyt+2je46zI6qEVQYQp+/8o7bqpGug+aAZXJUSPpmTIj1ebnBzQrMXngADkgrqBtVT2epGlhauirBo6K1B9lB/o4W+8yzOO9RoBJ3pj3QpdOpzgzjki4SWJm3Q+w==
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
2.55.0.1007.g17ff1f9808-goog


