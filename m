Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2C1C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46AD6B00BE; Fri, 18 Sep 2026 20:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0D06B00BF; Fri, 18 Sep 2026 20:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFFF6B00C0; Fri, 18 Sep 2026 20:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83AB16B00BE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EB891A0151
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:34 +0000 (UTC)
X-FDA: 85228618188.05.7B5610B
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27ACA180004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A NdQgC+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OUvKr+t8;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777532;
	b=h9k6Ujwh/U/0OJI6oXMycUNeAbSbiV3Z7wiVBFXNXTvWIBVGaLNZFlZRPgGvu2y9N7L4DW
	RdhAIDIYPiul+5xv4+WXmqvpuEH7fzRqtnMaQVXuTIhPAOwfCP0ZW7aJN8hOR+oP0oZp/p
	KoQNjv8QcD5FeVspvCN/2wxc4teUvTE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A NdQgC+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OUvKr+t8;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hSKa8/sTyi+jf6ploRbE5LilQNqTTyCg9z8yjvcVBA=;
	b=jJ+cwLItzi0sHUszcksYd6vVkATNXiFiUxt/cNUVQfYS8MhGCKoITuXzveKOD8iuDZ/RbJ
	VqVwLIC7CM6aXV+K8DK+fOis4+2bYyZwLPRR6FYYlCHFPZLJ4krhNLQwN2T8QtKtZqeoZD
	xfgoCGQVPJ+gILpO0EGU8QzSPN8tOLI=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id B4C08EC0232;
	Fri, 18 Sep 2026 20:25:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 18 Sep 2026 20:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777531; x=
	1789863931; bh=0hSKa8/sTyi+jf6ploRbE5LilQNqTTyCg9z8yjvcVBA=; b=A
	NdQgC+W2bZFOcVIoI4T8bHZS0N1i8PAzJVNbgghGQyba3z7Y7q3XMa8rPUkQTTgm
	f8w6jJBqUVAq7dFgNdvrv+c2xWLmizvRXCQXaDlkP44OtYa57KIbYPj51wu+S6p1
	kxHANAVyrHR+b5OFD+p0KYdOzNBaqrgRTMG21buK75KTh2GE8aUuTo3o21sXxumX
	5V8Bqzhy23s1sNpXg5BQ82dVrxrerIOWUwIMCwBC27W1JoBHvVieGfMXt5WZMr5j
	hDFFPUbNURVCk+oSdnoYnxNXlfISP062th4XcJQ2mezNXu70iEgt7GiQMn7uegF/
	9dRShJfYweO/zQaIyQfRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777531; x=1789863931; bh=0
	hSKa8/sTyi+jf6ploRbE5LilQNqTTyCg9z8yjvcVBA=; b=OUvKr+t8nldXfgooL
	J15lfCu1YPcoKvc6mCAds2YTBu2p1wwGaDuFmLKcMlklPcTX0aC+Q/V0GWUaMtyA
	jq0zOO+Q44xn0p+U0GxiUWf26eDpnqONHWoBOl169cRkRC9pWjS2cRUXFc0rmas+
	pg1HCk52i6FrhnMUFpxRpAd52ikU4OdAOYcSO/kQoGnA+26vIHtUdVce1kamILfQ
	t0knQO5zBY3MsU394pEPu8ez1rdDkPtq3xsWQBhWB7hesv0nalFExpG1P1wfytrF
	Tc8MslSC+FCUCb/ffXE/A0sEPrgo7T7ZcMqUKQWmpXAAJtwFMIqU0keuns0zUung
	a9Kpw==
X-ME-Sender: <xms:e9atagx5N91UxjBh8aSO4vAjD_nIgXW33l1EN3OD2ylmGoPxojZ7gg>
    <xme:e9atasrqs3CkNprJzMYmyvgODFXELUNEEPpZUaZnbTh15dx-FXGxFUm4_in-YtP3y
    VQ52FOSAQ5hu6mc-0ou5Oeapb4MKDuqnuQWr2KiHZ6NA-2L75U7ydAQ>
X-ME-Received: <xmr:e9atakjMiGrPUXnwRG4SBJMUOg0eB2FXbrjWM4G6kmFk_LjRBwk63-D9UMs>
X-ME-Proxy-Cause: dmFkZTFdeCslqvGFSSbmnhtdeah2m5aJ+JS0pA7YZcLyjOSl38+BaMD8ToGDiujTmfb1FY
    hwc6MyP6OTrwB9YZ5cf4L42pzgHwmSUyeXVwqH+rQjzPLdOU7n8WI+L1MfkDKNJ/RFAPzh
    NlCaR2Fewfb53OcTxvB5KvIlzV5JISHwTvfMhxp8O5pDxNZaie3hjiM7DwEdIJtFqP5P16
    IJzN4rLPSq8PL3AzI9mCzJTBQz13YM+0hrUjs/JUttTBmoH69TA/2ONguP0NQ8nHQtvIz0
    3uJBRgi18k1Lqi8M3Hll9BkUCzWjsIEVqdaORpYkNdmWXEBvzlr7NFm9TsFftEQV4t5xs5
    JYtk2rCMb4KS87zC7serU0f9USLxq0fLzi7UaQV0oWZxxP9NbTq3K9wpk2GV/8P30K8k0A
    p0SSrjokXJVK9PMUwRPKpAu5O6c3/d1Wjf2Q/6rduQ0xbcl0kyQp/CLcSqGkFVNaSN3E3O
    nu5z2Su6ZetWS2nFgWLQ+bQWNOB9lDQgXXc9oGBeAchiC3RtK6tTOahUr6v/M3fAgbKRCR
    2nfMVRtUvk+6ZLz1wQ8G1tIpZxTNRonsWIIxDluPYOuPeVzJvUk0UIgeO0zr3iORf76ofj
    MKMjYL2NgwtDyckSq3QcqMKsuxvhlXXyjxvbq9CMsa6fjH2G5jLODhL5SX6Q
X-ME-Proxy: <xmx:e9atamXchfflHJvj5EzER2gDSfs1Rvn9n2NrCmeoqGIl-ssmIOROmw>
    <xmx:e9atakH-7rSXPydVfPHsnxU5aeHSCg1UJ81MinF1zJ5xe8sDYxJVGQ>
    <xmx:e9atau8GLMhN6otidUU6ztmBp-LaqNhIMnS770f4NxclyQd4SWDEpA>
    <xmx:e9atas1XPxNBiaog36kkg8PBKpw8-lq4F2Yv5QbVA9gJKP53RBTqnQ>
    <xmx:e9atajMaGFaBWEYnylNlaq-VcNm--wkkOjy2swqacnsYs_PNU6DmmdZc>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:31 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 18/19] selftests/mm: add memory-pressure threads to the khugepaged race harness
Date: Sat, 19 Sep 2026 01:24:48 +0100
Message-ID: <20260919002451.496763-19-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27ACA180004
X-Stat-Signature: gpuegzkyfbuorenxed1qwo7ubngccae8
X-HE-Tag: 1789777532-391912
X-HE-Meta: U2FsdGVkX193TwpD8CGd+p1pupjwgCJmIuSuhM+c3oK4Dkgui5dDc1ae0QBcm4DA0dCQmIIMCsR/EaUwni+vvxXWhlI9basdb4mBJqbgn9fPONAQ3kHamm59fftOqhg3RX/3Pk2hHK/ctjXcpDBvQizTuu2XtO9d0z1FBDEa6I8kSTWvOOsv7Df3kKFaqibHySlrTsyX6+1MNTum5fJKYDnEUZvYZppOz4MT4EiHpbIntMiIyQ9ugG9n2u/XK89Gxk0i2nR54+90bbHmakRQ91jaAqi60Ty+EbYJ0wtlQikPFYMMRsq2KpLA2johCFrdlNauIu6Xb98LYfCMqyWXCOmWMKkoi+5FPm3e3Fpp3Uk2O69tMQ01lt+HnjBifA6FoQrQFvELEPnHPDB+hOnKLcBdoZEgiPZ7Gx5OGv3cwAmw1AFLw5z9DY0ibxpZZtXzhpj4uEMqP1o9k45EUm3JK/lz7xhOLuLgbgkZpltSRljfEVR7xqd6ULtCxhPNQrijOoXEO0RrSRNvpV2P0urJc4YvyYQvTa3+p6QcFh2/JskUMWQvpr3B1fSEIw35rr9ypvqXgVtyRmkJOQoAMIVyP6kmQXsixSbrguW9dyn27lQoYS6W7ihX9r/ddaaYtfaxa0aK1JcyWjJQ4LHni5pIxydA51m5H4scizfwm1ceTjEPLNO3Nar6vO6Bh5JKQlAkFdYm9oSVjS3IHCJY8wKxpgafpgceB8+hEl+YuuRo99rOxt36nrL/+iafTKpf1fgZAsSmQeQv0ZaIWNuV0khMJFGbdReFsEUQk+x4XQMZsl32cSYLmrQ2fNgHBqvLgA5JfCitWXZoWK9jp76L3E+J1Ij+P9qUiBcLPoqn50+ZeBOxVPVpe+LoCYdV9WvGFZVUDOWZcIQSDwKRGAU+apV/XO3qnxQELxgswpNka9RX2Mli93Jjdm20SIRU66WBA/gXl8pNiPjRjP/Qvw16WWK
 hCNw7HMw
 /OxOpT2/mGVdOhlONR4f2puL1G6wH/GbD9l2jk+xjSYedLFCv2Db2SbCxgH545CCnWzicw6JnjgGPCdEQ67She1W3G7bVwTAvvQxQO7vMxzv4d7rYmVFy50H2lB4jOAd43yd9TrH5PQMhB+nH7oi5afmOA8ozFwZ6VDAuQxoQZ++naLpaG6CwwQm2gsi+/ZhO6WtDfkAAf8hMg7wpoQ44Gu93uH6jdGGkjsrFzZLfpLKFa6ys9ksKA4J5WlpxfaJ4N8SfcdeyXNQanX1dBxyihFq0XhHnlMVzA36Ty8y6pp5VYsQ3fs7y5slWLa1eaBkIxwgmFwJvsDM2MyWzCd7CTPNO8fycfTO3fQlCs9oHdozkEawi7tby+SofN/cq9TyBOTyc5QAtjoiFfc83rj9uN3juajIpKuoSjRnl6puNESaa7Yet97LIg3kIr5RTBjoN1KK0RYuQfu+7BMzt4Ofu4S9mLsT95gmSODnpE4Pj0nuQZ+8YuSssY+yAhjKq1EsItSx9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness races collapse against faults, pins, fork, mremap and
MADV_DONTNEED, but nothing in it runs reclaim or compaction against the
collapse.

Add two more threads, and run every mode and occupancy limit both with and
without them:

 - pageout: cycles MADV_PAGEOUT over a region of its own, faults it back
   in and checks the content each round, since a page's pattern must
   survive the trip through swap.  Left out when the host has no swap,
   because then there is no anon reclaim to drive.

 - compactor: writes /proc/sys/vm/compact_memory in a loop.  Compaction
   isolates and migrates folios, so it competes with a collapse for the
   pages it is gathering, with refcount elevations and migration entries
   of its own.

Each result says whether it ran under pressure:

  ok 2 stepped/strict/pressure: 5s, 88 steps, no corruption

A full run is now twelve combinations; -m picks one mode, -d shortens
each run.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 142 ++++++++++++++++---
 1 file changed, 122 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 6575045c0482..68046f0bf6d3 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -44,6 +44,8 @@ static unsigned long page_size;
 static char *region;
 static char *mremap_area;
 static char *mremap_scratch;
+static char *pageout_area;
+static size_t pageout_size;
 static int gup_fd = -1;
 static volatile int stop;
 static volatile int corrupted;
@@ -204,6 +206,69 @@ static void *mremapper_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * Swap traffic and LRU churn on a region nothing else writes, so a page's
+ * pattern must survive the trip through swap exactly.
+ */
+static void *pageout_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+	unsigned long nr = pageout_size / page_size;
+	unsigned long i;
+
+	for (i = 0; i < nr; i++)
+		*(unsigned int *)(pageout_area + i * page_size) = pattern(i);
+
+	while (!stop) {
+		madvise(pageout_area, pageout_size, MADV_PAGEOUT);
+		for (i = 0; i < nr && !stop; i++) {
+			unsigned int val = *(unsigned int *)(pageout_area +
+							     i * page_size);
+
+			if (val != pattern(i)) {
+				corrupted = 1;
+				ksft_print_msg("Pageout corruption at page %lu: %#x != %#x\n",
+					       i, val, pattern(i));
+			}
+		}
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+/* Compaction migrates the collapse sources while they are being gathered */
+static void *compactor_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+	int fd = open("/proc/sys/vm/compact_memory", O_WRONLY);
+
+	if (fd < 0) {
+		ksft_print_msg("No compact_memory; compactor idle\n");
+		return NULL;
+	}
+	while (!stop) {
+		if (write(fd, "1", 1) < 0)
+			break;
+		usleep(10000 + rand_r(&seed) % 100000);
+	}
+	close(fd);
+	return NULL;
+}
+
+static bool swap_available(void)
+{
+	char line[256];
+	int lines = 0;
+	FILE *fp = fopen("/proc/swaps", "r");
+
+	if (!fp)
+		return false;
+	while (fgets(line, sizeof(line), fp))
+		lines++;
+	fclose(fp);
+	return lines > 1;
+}
+
 static unsigned long now_ms(void)
 {
 	struct timeval tv;
@@ -227,17 +292,23 @@ int main(int argc, char **argv)
 {
 	static const char * const thread_names[] = {
 		"faulter", "faulter2", "dontneed", "pinner", "forker",
-		"mremapper",
+		"mremapper", "pageout", "compactor",
 	};
 	void *(*const thread_fns[])(void *) = {
 		faulter_fn, faulter_fn, dontneed_fn, pinner_fn, forker_fn,
-		mremapper_fn,
+		mremapper_fn, pageout_fn, compactor_fn,
 	};
+	enum { T_FAULTER, T_FAULTER2, T_DONTNEED, T_PINNER, T_FORKER,
+	       T_MREMAPPER, T_PAGEOUT, T_COMPACTOR };
+	const unsigned long pageout_bit = 1UL << T_PAGEOUT;
+	const unsigned long compactor_bit = 1UL << T_COMPACTOR;
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
 	static const bool occupancies[] = { false, true };	/* strict, holes */
+	static const bool pressures[] = { false, true };	/* quiet, under pressure */
 	const int nr_occupancies = ARRAY_SIZE(occupancies);
+	const int nr_pressures = ARRAY_SIZE(pressures);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -246,6 +317,9 @@ int main(int argc, char **argv)
 	unsigned long end_ms;
 	int duration_s = 5;
 	unsigned long thread_mask = ~0UL;
+	unsigned long base_mask;
+	bool have_swap;
+	char label[64];
 	int nr_areas_arg = 0;
 	unsigned long i;
 	int steps = 0;
@@ -305,7 +379,13 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes * nr_occupancies);
+	base_mask = thread_mask;
+	have_swap = swap_available();
+	if (!have_swap)
+		/* No swap, no anon reclaim: compaction-only pressure */
+		ksft_print_msg("no swap: the pageout thread is not started\n");
+
+	ksft_set_plan(nr_modes * nr_occupancies * nr_pressures);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -313,9 +393,25 @@ int main(int argc, char **argv)
 	/* Base of the settings stack; the bottom entry is never popped */
 	thp_push_settings(&settings);
 
-	for (int run = 0; run < nr_modes * nr_occupancies; run++) {
-		const char *mode = modes[run / nr_occupancies];
-		bool holes = occupancies[run % nr_occupancies];
+	for (int run = 0; run < nr_modes * nr_occupancies * nr_pressures; run++) {
+		int rem = run % (nr_occupancies * nr_pressures);
+		const char *mode = modes[run / (nr_occupancies * nr_pressures)];
+		bool holes = occupancies[rem / nr_pressures];
+		bool pressure = pressures[rem % nr_pressures];
+
+		snprintf(label, sizeof(label), "%s/%s%s", mode,
+			 holes ? "holes" : "strict", pressure ? "/pressure" : "");
+		if (corrupted) {
+			/* Memory is suspect; the rest would prove nothing */
+			ksft_test_result_skip("%s: skipped after corruption\n", label);
+			continue;
+		}
+
+		thread_mask = base_mask;
+		if (!pressure)
+			thread_mask &= ~(pageout_bit | compactor_bit);
+		else if (!have_swap)
+			thread_mask &= ~pageout_bit;
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -349,6 +445,20 @@ int main(int argc, char **argv)
 			ksft_exit_fail_perror("mmap() playground");
 		mremap_area = region + nr_shared_areas * hpage_pmd_size;
 
+		if (thread_mask & pageout_bit) {
+			/* Enough to drive real reclaim without swamping a small guest */
+			pageout_size = 4 * hpage_pmd_size;
+			if (pageout_size < 16UL << 20)
+				pageout_size = 16UL << 20;
+			if (pageout_size > 64UL << 20)
+				pageout_size = 64UL << 20;
+			pageout_area = mmap(NULL, pageout_size,
+					    PROT_READ | PROT_WRITE,
+					    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+			if (pageout_area == MAP_FAILED)
+				ksft_exit_fail_perror("mmap() pageout area");
+		}
+
 		/* Populate so the first pass has something to collapse */
 		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
 			*(unsigned int *)(region + i * page_size) = pattern(i);
@@ -397,26 +507,18 @@ int main(int argc, char **argv)
 		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
 			check_page(i);
 
-		ksft_test_result(!corrupted,
-				 "%s/%s: %ds, %d steps, no corruption\n",
-				 mode, holes ? "holes" : "strict",
-				 duration_s, steps);
+		ksft_test_result(!corrupted, "%s: %ds, %d steps, no corruption\n",
+				 label, duration_s, steps);
 
 		/* The next mode maps the same fixed address with its own settings */
 		munmap(region, nr_areas * hpage_pmd_size);
+		if (pageout_area) {
+			munmap(pageout_area, pageout_size);
+			pageout_area = NULL;
+		}
 		thp_pop_settings();
 		stop = 0;
 		steps = 0;
-
-		if (corrupted) {
-			/* Memory is suspect; the rest would prove nothing */
-			while (++run < nr_modes * nr_occupancies)
-				ksft_test_result_skip("%s/%s: skipped after corruption\n",
-						      modes[run / nr_occupancies],
-						      occupancies[run % nr_occupancies] ?
-						      "holes" : "strict");
-			break;
-		}
 	}
 
 	ksft_finished();
-- 
2.54.0


