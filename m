Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F25C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFB56B009F; Thu, 10 Sep 2026 19:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152086B00A1; Thu, 10 Sep 2026 19:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDED16B00A2; Thu, 10 Sep 2026 19:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1056B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:48:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23056A4C30
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:48:03 +0000 (UTC)
X-FDA: 85199493246.02.BA60034
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id 715651C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:48:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RKQ47zX+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3rkGjagYKCBsJLI5E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3rkGjagYKCBsJLI5E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DhSZHjG6hjqVTewVLZe8gYlSfZPhEo21Ej3YTenr/Y=;
	b=M3EegykZFVMzJoyJxoBWOUqPq9IDJNZK+/UOz5iXqO0MwC0/juiFnCJ7Un9mj0tWOYPFWq
	7u7d8VfGfNpHD7PeeRclHkR00/7t+yuuri0U4DXb0k1CnkHqiiX0X15pCC7JtG4lNh4U61
	YGOLF9cm/qH4xPKF0IE5VL8sv9mBVOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084081;
	b=mkUC87cezXwOqYioSk/1+sWdEMH1t2F9EBw0A7ryVqfaefNbIO62DUbYrCQ67XBtqavLJT
	EKmQFH0P4gBgO0pC9+Vcu+7Sgco4PacTVkUj4gHjMu+Ha6QRQjXWcTjseZ4Xo91MjaRDin
	FqS4Z8P27qTTGOBM8Ulmp3l/IF15ShA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RKQ47zX+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3rkGjagYKCBsJLI5E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3rkGjagYKCBsJLI5E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--surenb.bounces.google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso432349a91.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084080; x=1789688880; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1DhSZHjG6hjqVTewVLZe8gYlSfZPhEo21Ej3YTenr/Y=;
        b=RKQ47zX+cVnSNGSNzmijN98sE1t25+wi/vDM0k+DmXQs+QT0+K/PoFBc9qRjgK/8Kj
         MQl+yh3739ykBv2B6Rec11NwfCtl9sX5Wh62iWeyG1yyImTaiADWVP+jSpdmGg0CWVkO
         hAxtLxCwwSyQeIqMdt0RX2bKYeYCm7tC8ITmYCQGW12SopMX/yb5rA8W2+olnIz2iDRi
         vXOU/ubvxKhDLJAULkyLjec4c/VnRAr0IiseZRnb6nQQUKWLubpIxnqVqwxnKCd0iaP+
         zckXGLiK8QalSvm2PC4ZdiVp4GVcm7kKCbviSfy3ABtc4Ab46ZU7MYCThWtbnH3CVL7d
         M7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084080; x=1789688880;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1DhSZHjG6hjqVTewVLZe8gYlSfZPhEo21Ej3YTenr/Y=;
        b=LF7hQEoRv6gJBlDjUjAMzDdNy6voHOxr20nqkIixB9EpkjEk/aQOVQtwUSMChcqlsf
         8xhLIwsWKGS7e8PLTlQtY9F3Yvt8+aB9rfLFormVvkfWA2/szF5DPeGM/VMlPOTyViWr
         wtrp0cZoXEgbfaVeUlyRL/toB3+Oy2nm3dDpbLVWJ+uzRWbiQsltC9NhL48ygd+feXf2
         ieZSJ77rexE+xOQ0v/olFkkYujerPjaJbyQiOWBR9ugtuNiVsH4GJ2bvkEvW2SRiUvtG
         5YJEcLrBC/TbpSj+nta4C0qkixiM81ch8A2uQsJtqNkIpMYERVdNy95tL4Ilz/1SND7D
         mbPQ==
X-Forwarded-Encrypted: i=1; AKwUvBy05+vRgBb8zjhH79F7QjVG4i7B448CR4btaYnajSyOK4qiuvV2iB8u1Z2lyD3dV4TB2iZqwuFqMQ==@kvack.org
X-Gm-Message-State: AFuF++mKhWlz/g1KTgODMZ94TBxUtmGiZXeOa5GjIDfPLzA+UgnkCwFh
	OL/u8ZU2sp7843nS79Cj/IijdRFt1dR2Y0803CdZ4z9X6e9L2+pSaf+oBAIHmuHuCZAd4SeeR5o
	JxJIhhg==
X-Received: from dlbrj7.prod.google.com ([2002:a05:7022:f407:b0:143:5fe6:4e1a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b44:b0:398:bd37:6a49
 with SMTP id 98e67ed59e1d1-39d9c1bf032mr1926105a91.12.1789084078931; Thu, 10
 Sep 2026 16:47:58 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:37 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-8-surenb@google.com>
Subject: [PATCH v3 7/7] selftests/proc: add /proc/pid/smaps_rollup tearing tests
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 715651C0003
X-Stat-Signature: 4gk98uytkn3x36z56yzsbrt8bsuoosfk
X-HE-Tag: 1789084081-786868
X-HE-Meta: U2FsdGVkX1/G0DP1JZ7KVpJ/X1GnFLq1Ya5GojwSWV0yoKWFfWEfivKib2nGGTAVLKLtopOMNFBAmUuvj0zrVWjKoq/6g+12K3mztkp0lj9fLXWoHc0O0gd3Bny3kw4qP8bNhAHTu1vtvnq9UEq/Fq1bLISg2xD0ZOiptCTCTI3z6pklq7FesSEMFKw7OwsHKirzCd5fmlF/3nmRjpS1QzU2Na/w+3HzOUVZz/Qb9G3u5Hsrpg8uHIQofXjvzBFepzOyKSi7XFdBQtEHueD+o7edAH1NyhQLNQ/tyAnr6lZoFUBfBgEQD/q3FcI/3AJx85jjqtu5G6hWqyfraS3ivYPmwe5E2I0kV3PlwDr6bA+bD6UHufdG9MnEifrd9C8HKt0JjB9skasf9hCgNRLaG/INeX+MPFOO4Aqu5NJQ1gMbZc034C3w2VE5f0F2XRbrkz/zllTwr1J4KeoyokNQcxP+taQK+PDmOjY+y0yW+9W/HZmt8IsqyGr6Rs9yS552wJsboqeiLBrK5521j5QZQpl2KgqqO2fpMZxy64BJsE+8ThwfHJ6Bqx8I9MRl8SUWTwe3La/mNO+pzXLiuP7OCKYHrz+Sx8Svf5FNtU/iCb3Zi22/Tkv5hebSZtyUfKMcl0+lWXTHMv8jypRqdwB1Yt0JH1DH9qq/PdV91U1122FZOmlCOVtobdwLvXgc2xlCa1rvTJN9QV+p1qnxz/ZzV8SCtUUjlIwQiaGQye/4S2lHwQbaj7z2Xpe1XwJws5dNx/TBL7Q7aZ7vA1MDY563x6L+Wn0RpWEWE0r31BCw+jA1qx22b0GxRyoGf02v8jUfrwJgix82Pwy0+k8bQv/YJGVeQld+p0EWcsKOL0hvHSdoh28ugx9036j2/2BcxQQwtH4t11En1isGvLO/h1vT+HFpqrfYIIiOIxdmH0ExJdPBQlet1xVB1338xJNg4JJdAvGOVT3Q7nAKerJzUH8
 W04zWBuQ
 0MDzpx7l3Z8s96OboLwVIeQEcu/d4uqr5wYkzpkp9Cg9svQ/4/n2vkVKVV7068CcpMBVm0UKtEDk7j19CCgGMsA1dnWDykU+Hd6X6adbqD1eATOWRrrEeYn03NH6ZPtlI0FSZxII14OxvnVJbBydnaHDbvqgWgPU5kxdrd7ez1aoJP6kT/p1twwLHDXeUzepSLkdtFlrP5otGeiU+qL6e5cW7EfyxQ6w2SlE3vplGNLbCsItDFNl4xEdMHALI/+5smtXhgOTWPqpitZV2XyFzcatGtYf9q6yZrHaxEm8srlm2qjY5m9w+UKH4QJFADDLMR36NsidmbKs+C3tLEcWewNr2jqzzgiN9LKj85feOlsjinZhZFPgPIo1BBlCaEr8lurU8rlNehCaAkSDN75cVl0opk5YEfk9AYY1xwNINE2VGS1FyooZ4aqtkDLliX6y/0odikidsrkXqe1s1RolEpqaAydlwI5asgkkCcLIVkvFofaURjm+Xbta61HMEOm38zRmnOT8gNEvGGm/LBYbV0impKSrHsh5vgMfeIE/EtdF4kZEZjJ4rwZehsMVZ8haxCUH9xyPPADUfD8B43JWv0MRBQOWCTPDd8sWwdKKdbCFMRI0hfi6hrVwpGuXtdnvLCIXYSJvw7CcjS5F/kDGG+i+jhfXgN5lCZaoH
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
2.55.0.1007.g17ff1f9808-goog


