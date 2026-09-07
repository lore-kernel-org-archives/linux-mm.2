Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E4DC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640CB6B0098; Mon,  7 Sep 2026 02:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F21D6B00A9; Mon,  7 Sep 2026 02:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA0B6B00AA; Mon,  7 Sep 2026 02:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7676B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:39:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0DCAA4881
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:35 +0000 (UTC)
X-FDA: 85186015110.24.B130171
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0DBDA0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XBUGIprA;
	spf=pass (imf25.hostedemail.com: domain of 3JFyeagYKCLEjliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3JFyeagYKCLEjliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7MPdcOKwaU52QY/pYkhfSWrRgRTHQ7GCQeg5bNkckA=;
	b=m9ztTNO/5PQtReobdxwaltQoAOAeR5yXHLvl6IMF/AAZxvNVoyaWGpsOJDKaDWN/PFaIUV
	EAXrn4pRr+n7YRDT7CDx4m1TTkdKETB0dDKlFIBrsTRuLb5uAe331mLos/Q1GsMlfaEKMt
	dn2S4DijTnCtYicO5plH5XQ238drfLc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763173;
	b=SZotvcRP7vhr4kyehKXM1FWMtF5Ev6lfPxbO88dmJelh1hJBr4Fzi41pMCQ06fWMVxFcYH
	kY+Hwa7m00+G2Pf6onBZWEEWNyLchnP6vMRSUYqu4kbMWZ2WnQ968hGHM8qEpX2u82TNR0
	z9MHzVy2h7ARIi3kQlUlY+nk1BCCR54=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XBUGIprA;
	spf=pass (imf25.hostedemail.com: domain of 3JFyeagYKCLEjliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3JFyeagYKCLEjliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso5056169a12.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788763173; x=1789367973; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T7MPdcOKwaU52QY/pYkhfSWrRgRTHQ7GCQeg5bNkckA=;
        b=XBUGIprAD7hl269lVFhp1n3/jjVVmbDyvrwOPbf1Hm+k7sOLP13wzAPEL8X690MOZb
         s/aDfHIzeJi3fAMx5T1/ejwtxE1RgXcOrnGBQXFgu8I/7vFr7GK1LA5aT7Z82FcKEru5
         9aQqAtbyoGfemcPRo7a/kGJ+hofIbGjQlrYVhqkrDTOQEcXSydVLdZGf60BV1DJ42RtW
         l8wAZNVaLzVV9gm681RfrbnEVspl00uhfvFk9Cffagu48Tfnqc8M9GNms2mtGyC6TqBj
         esrHoOzeoc/TSq5wkDTbVqHHBIWNAwjn09YUA0GjwSFCdiwfoC5JbojWcDxwDZseEquS
         0H5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763173; x=1789367973;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T7MPdcOKwaU52QY/pYkhfSWrRgRTHQ7GCQeg5bNkckA=;
        b=G8qFJ25JSAc8OyWXBCX9GimfCi/tlxue2EX/xvBjPaNey1WjLyaxSeblyqY/rhHEIs
         ZId6EsJv7Z+Ez7u2+1BhrZwFVr7qHbt/BsNziWLq7lo9ZV1IXheMUYV39BHzEZzomO6x
         tIgHFxqIbtdyuFOnUNhTkVDmB0yBMiXMuTzxm1jVTX5SGN8V+zUGfE5W7GeNS8AcBAtr
         wQdw4lR9KeW3IsgyV/mKweqL2Ckj+4bED08nU2jo+65M22uUZSS1lwWJkhEtnf5WemxK
         NKIg6ekmKgmabRMy5GmZ5R6ECep1sk/+g45kyn5vPIWJ4ZenZQrin6xfG93/3rBYWXcQ
         piVA==
X-Forwarded-Encrypted: i=1; AKwUvBytfpHIicdPfMrA/oUF+4BSiaaqYmV/CFYSSKCJVPA9edrTcw6Tl6WaaBR/Ujn6vCF12DHUykSRWw==@kvack.org
X-Gm-Message-State: AFuF++mfx7kBAEhSe4w7SEvtcH4FrHP5BxYkClrHyc+8Aczk1Q6eArjS
	eqSAN0IcgYRlz0Pgf9vwCVCBTKz3UD+/2WADCGTk6a/PHZxzoi8W2HFf1z1XRFoxh5VpRlXhn4K
	Iyo2Ygw==
X-Received: from dybdx7.prod.google.com ([2002:a05:7300:b187:b0:32c:7ca7:8f62])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:62c2:b0:3d0:d0ed:f141
 with SMTP id adf61e73a8af0-3da39d18dfcmr32776365637.2.1788763172413; Sun, 06
 Sep 2026 23:39:32 -0700 (PDT)
Date: Sun,  6 Sep 2026 23:39:18 -0700
In-Reply-To: <20260907063918.3432401-1-surenb@google.com>
Mime-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907063918.3432401-6-surenb@google.com>
Subject: [PATCH v2 5/5] selftests/proc: add /proc/pid/smaps_rollup tearing tests
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0DBDA0004
X-Stat-Signature: omag9xq38r55kf9q6uf5n7geuruwacqq
X-HE-Tag: 1788763173-300859
X-HE-Meta: U2FsdGVkX1+qXudHbK2WKh49u9WtE4e7xH1adRMVXoEmFYFJeVZniHda08E9ZtIfEAYEIQZi8b+t2ZWQqBY1CbHRBCipcHE7B/2uLLcfP6YfRSySgMxYoZbMmuPyQeHKGcKCeCUIZ+AqKz3ngKtC0HrjicE5wNSGZCCMkisOdi/gN5m/LEXm6T211pNkcwz9CttNfwMxjBfR6UxuxcNYf5idnXeIcu1Gi/FqDlfrd+95KBulfztoKTNU7f13FWCmuuVvWjdpusMnA/UndllsEhoWjyabCzTCMZrx6y7/PmxlxYys/gGOH2jiXsb3Lnnlrtu30HfLV2R3NSnV0D2OSN8jxobBruQ/RncO3Ugik8aBeCgj0WX97jrGXRcQ1eo7MgkCvoqe62B5xtkBGgY+cKaQh90+dXWwmRaVL/jeaT0Jg+8mO7PhrNcMcXf1aF9IyYvtHGcCZHqJ6gmmYgqJ8a9NUg7khr/jjYvVjJPMw/WlSYXo6IbwP5+H6XUG6WXZPlsB1ZREN+xjIwEwEniVBrYu4a8h2Z21UapPVLro1L4rWppSd/BAK2nxQKhE/T+0Pz1eS63qZzoK4CO+hsDZDvdXGrar9dixCO7H3b7aw0VHGN/oTyAzUFCyz1cgnJ0mmeJuWYt1354GKaVs27la4w0WzdeVDSlzcMPCBpl6z32u3xpmkMlD6OY5hyKxEBw5TtCV3A9z1Kyml08tCuudBoJeVG+BuEM9BSw3CEOCEaYF5Q14Q/ZLx2feUu5Gz7yF1yW/uRBc+GMBkDfqr1uR1MWQQV2WdbScrSBqHxMCxNECmwa0PB5k4slzbNkJf8rbk6Sw4x0VrqAZoj3QrihKVEgCUnXx30K1X9mRyBFbcGR1fIVY5HcGVbvhfm49L4TbAC7evCvCr9Wuv8te5Vj0jzCzyxTJPsk+PxfP1dJ93y7rc41MIl+GLGlwEYltzk/MRBsZqfY2Dt6KY5KYxwV
 22FmX4EQ
 fu1wdPu5UNt5ceUwIFzKJ7nSh8pJ1OGQv09yS4y0Y7qmWJ0AqZ1jKjA7eo4mZ14DA12vs4PTrX4/PXTe1ghhI+8tZya6a9MXLrUyV1aeJfv0glk/QdvNkgGaQ4CoOBIz7zj/4LGBxNeFEI59w5Uq5IyCOaMbQpwwrPZyB79Ekw9E4+Y8yCK/KpQhanl++DDALiUVx/cIMVa7mRoJd92Zjgkwjr6uqwIiCtkhmBiwKhdjXBYWiv0e4OCGGZiE6EoiYX7bj9rbNcoACgGg4IN2U3RcpggItpH2pdxeKb7fpGbSTCGqzZzfNP7F+XEkyfMrorItY0bSmj6S+sagci7zKghZl4vEV3wU1h0qBANkpIP7i3i8m5RXPh3Q4on5RzQyTltPq8HH9lsREnA7L9Li6yEBouCmi7EofMbSyWzhPQuBQuJ9D8Rl7s9mRzWx382IRPvxTlGXUVM/ix3TW1imwCT4jv3BL8g9gJgFlX5KDoioGMNBOYyJTCUfWFLJpurvbbx7lBJwwlBB6eahU5n/8iFqiScOgdmDIZG4RP88IKxGPntgcT03S3w5kCikHZUBuQNwcflajVYf6ITsQAhaVRCbGq9BXsTkA99azCwXvOXMNVrTKRt3UDkBP4J56f2Nmdjxe
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
---
 tools/testing/selftests/proc/proc-maps-race.c | 187 +++++++++++++++++-
 1 file changed, 182 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index 415eccb70468..8d00d7db1c65 100644
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
+			       struct smaps_rollup_stats *stats)
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
@@ -397,6 +509,41 @@ static bool print_boundaries_on(bool condition, const char *title,
 	return condition;
 }
 
+static void print_smaps_rollup_stats(const char *title, FIXTURE_DATA(proc_maps_race) *self,
+				     struct smaps_rollup_stats *stats)
+{
+	printf("%s", title);
+	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++)
+		printf("%64s %lu kB\n", smaps_rollup_stat_names[stat], stats->values[stat]);
+}
+
+static bool cmp_smaps_rollup_stat(struct smaps_rollup_stats *s1,
+				  struct smaps_rollup_stats *s2,
+				  enum smaps_rollup_stat stat)
+{
+	return s1->values[stat] == s2->values[stat];
+}
+
+static bool compare_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
+				 struct smaps_rollup_stats *expected,
+				 struct smaps_rollup_stats *actual)
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
@@ -572,6 +719,7 @@ FIXTURE_SETUP(proc_maps_race)
 	unsigned long first_map_addr;
 	unsigned long last_map_addr;
 	unsigned long duration_sec;
+	char rollup_fname[32];
 	char fname[32];
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
@@ -649,6 +797,9 @@ FIXTURE_SETUP(proc_maps_race)
 		break;
 	case SMAPS:
 		sprintf(fname, "/proc/%d/smaps", self->pid);
+		sprintf(rollup_fname, "/proc/%d/smaps_rollup", self->pid);
+		self->rollup_fd = open(rollup_fname, O_RDONLY);
+		ASSERT_NE(self->rollup_fd, -1);
 		break;
 	default:
 		ksft_exit_fail();
@@ -711,6 +862,8 @@ FIXTURE_TEARDOWN(proc_maps_race)
 	for (int i = 0; i < self->vma_count; i++)
 		munmap(self->mod_info->child_mapped_addr[i], self->page_size);
 	close(self->maps_fd);
+	if (self->maps_file == SMAPS)
+		close(self->rollup_fd);
 	waitpid(self->pid, &status, 0);
 	munmap(self->mod_info, self->shared_mem_size);
 }
@@ -723,6 +876,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 	struct line_content split_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -736,6 +890,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 	report_test_start("Tearing from split", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &split_last_line, &split_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -799,6 +955,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
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
@@ -817,6 +978,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 	struct line_content shrunk_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -830,6 +992,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 	report_test_start("Tearing from resize", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &shrunk_last_line, &shrunk_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -880,6 +1044,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
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
@@ -898,6 +1067,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 	struct line_content remapped_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -911,6 +1081,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 	report_test_start("Tearing from remap", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &remapped_last_line, &remapped_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -963,6 +1135,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
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
2.55.0.979.g7e5102b832-goog


