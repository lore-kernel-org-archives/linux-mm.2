Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2864C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D720F6B00A1; Sun,  2 Aug 2026 15:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB196B00A2; Sun,  2 Aug 2026 15:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3246B00A3; Sun,  2 Aug 2026 15:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4B26B00A1
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC45D14055B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:26 +0000 (UTC)
X-FDA: 85057378812.11.E641B1F
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf10.hostedemail.com (Postfix) with ESMTP id F17B9C0005
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="yWrm+U/7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G 26MfNU";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2c04viUKNcyHIhwoJZycJfPOVi3SeTtBJ4GmRbTe/aM=;
	b=rWSqHgMHO4O4dJQ5gRyG+YF1XwDwIMhLATp1D3/dQ7wO7snf6LkEGZSdP+Wxs1pbLkmWXE
	n6O2vFMcNy9oSMypOB3Gr94O6dkB+NXXcKpy21kImuVThxow1Yuqs4Cw4tgO+VgSeruNXw
	REcf8hMYdfafZSQJ9ug8RXpTgf5mXp4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="yWrm+U/7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G 26MfNU";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700405;
	b=31+EiFd7TeSUQZIxsBRv75LOq/BJYSZRfpvX05Qz1eJqUqeUl5BqMtQQgqaS7owNoAPTPj
	+Cd5VyS+u+BUzcQXtNXpnQvyZaX9WxLXHPHkv3ZU9XCaCekkWtaYpnTBuOi+9wgV8ywpjF
	DkicVgHQfHs7fX4bMZ1dWyzoieOotkQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 6C4B4EC009A;
	Sun,  2 Aug 2026 15:53:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sun, 02 Aug 2026 15:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785700404; x=1785786804; bh=2c04viUKNcyHIhwoJZycJfPOVi3SeTtB
	J4GmRbTe/aM=; b=yWrm+U/7nm6MzG1dXJJW53fouBM8wh4F7u9str+PDJ4CIhIK
	CBDnuAh8AV/AsITnaObFEMo039h9MkMDpECGa5EcfSXeFpLpAwYOqMuo8dTLc2Bv
	opUWnoAIV85ZbyATG9pyFt37VxSjjvLiovfwJFUPxumglyfzalfNLf6zuN9QTXUR
	htbv/TxFNwvJ7Tv2Y5aAuCyCZliLLGOOOAuZtmc32cAa75H79+4/hWVnXt+4QOlN
	PLIvFEhSIxdjj0oDDIysdIa0GyXY0aUZJLEHjKN18xTLAEXsgSjX4x6q22THnuiL
	gJIobAElp/bjoB3+fDpBAoaRs+J0gUUJWorf+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785700404; x=
	1785786804; bh=2c04viUKNcyHIhwoJZycJfPOVi3SeTtBJ4GmRbTe/aM=; b=G
	26MfNUCRsWMe8prJiJZmMIaQugODfgLH3p7bJ93/tFtPvqqc3Ms9f+zq1XJwKQiD
	fG2At1k/PFT7t0KWSECXJVWvmw+UsZl/KBeo+DSNkF9hFJ7uzqT79BISfr+FS+QT
	eT2FvlA5PYcawn1LLBgs0jcIEsI+TGk/zA+ou8YOZNtCLJiAdSCP4tgfMUGGPxSa
	r0PG6ZLXiFgWcY6AqukRGIHaoAe3Ezc7i29tDIEAJC2tVxNo9c4uD5Fq204t/fZ2
	8NgO9XZNgmxPEG3k+M5KXHoYVc/JztypgEbuVprpQM6pNz6Ye0GA9yEQNPAAkSGb
	5FGyvBuDPl7Ph+L2alwPQ==
X-ME-Sender: <xms:NKBvaozybnXtfoN90SPaFDXbFBf1ufJl_4MVrEgnFC8ygaX1DJZ2sQ>
    <xme:NKBvamy18lmvrcGBLaspAOw5RUJoFmGNh_qxS-mdSuqdE-Qx4CfC1mCtMAn13JLnW
    Qayre4wkTyXFEl_8dBdKY3qTFbwiNGEUnNh-LkSp_7_cMe8ngkeS3VP>
X-ME-Received: <xmr:NKBvanTkC4kyUWLu3vikY5T09rx0F97cSGdQ-Z_TuZ-7-eCO0ZrO_YricTs>
X-ME-Proxy-Cause: dmFkZTF0jcSSKFGDg2KrIu5c43P4SsiipwcvDQBe+CHxos2n8PFgvSXAdv5YVW583HVAOz
    W5evq6qe09LpHqloXNM1K7VWF721j2bpam5IryqVMcYz9qouNwbpBEKv3Y5gifbeJAqW/Q
    YZQrbB51yLEk86mWZaGZ1Drq0Xy949i11wvFP7mkSWE3f4+XiyFqs+bTi+V6AVpUjNMMFr
    yeY2fCKzWlrX4GavSe/JRyGqxABGArlOuRBA0IP4mMA1yNK8fSDYGTdjzDrtr8AjwNqVIi
    3BcHDiClTVSc/WD5f6J8XCsMYF+6dE+0Mr4gWnl6eMmh6FUU5GqCPEjsceh07AxGuRDdTX
    XdmLUZnQtOIo3U12N6vnFLsjhbT6fpNHt4ncCPLjHXv3aD+KUCMK6s6F3lRJxFNOMbgc/U
    7M8qiCi4FTGopPjRHwo8pszqIV5/QQBgCpl3sYpkredorGFz5WdT1fT+V/MeK8EskgLaNh
    UYmt/EhKngGhHufRIXqnTlZUgWgEgyc/ng55idQJ5FtdW3FytevGVbGVrEOEddplajbHt9
    2gnOmC6xkFWB58lo1pGQWWNw8KdkvTh3Vb6cSHwZYFrchM0fhW2zPSkGx7BwwtCejS0vay
    7vHahGFctGxRqhClNQrtPMmAyXmh5oQR0cZQvY0pdTmCITbLENM8FG+aEWRQ
X-ME-Proxy: <xmx:NKBvapNErVdY8WBxizWZtuzbZs5bKQeNf00ChjeO_xyTmpL2b0wRVA>
    <xmx:NKBvaiSIpIYiw1H6n45D9z34-FaSiRYZ0q6Fk5s5n6PZCqiblCi-bg>
    <xmx:NKBvak-mxvXGIjg7jfJFshNgTEe31d28DC4YMoGqDCg8cnNcj6FHEQ>
    <xmx:NKBvakVCi-k3SWXKrHQ-fIuMHQDHxUte4NqaYycuDSbhxRi6ujLRXA>
    <xmx:NKBvaiswm8GPm3Svm_gK2nxdcRwj-qpNwOM843SelLh4egXjA12Loek5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 12/16] selftests/mm: add memory-pressure threads to the khugepaged race harness
Date: Sun,  2 Aug 2026 20:52:44 +0100
Message-ID: <20260802195254.1937477-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F17B9C0005
X-Rspam-User: 
X-Stat-Signature: bdasjym6utccny4i7hqkdjp5f5du6cdq
X-HE-Tag: 1785700404-40528
X-HE-Meta: U2FsdGVkX18PqTP35KMBCUpCHBI4Lij0m2sDMFN5JgKhs1HTGPgGmkyQ3aoK7tcjVk/y+8K2PYPV9lqbuI4cM30Rh9F6lpCd4Ci/Ee7Aw040Q2Q61JErXIbRyc61lp5HCiC4rFlHulUs4J7bruJAV8OiWyIP5iMVBhA9tgOK0yXAiLJ7KOd3Zsj7Jll7U5qDMUoW9CQd9YbHKvZQ2Q9qu7PCL+oD054H7s9TQ9HGnp+3QwFLEBe+Uiz2MDQkiN8PDnSNC0XwsA7NdzlS9Hk8UrjU4X/Xry0fzj0qf6Mvk8l0w6iZH9tTv77E1SQZTeZwra6v7kFy3qWkiUz6jlyIPB4ShZiFVqwIEqxXLR8xM0LGe87oJqmmySQOx1QXhNjodwwySsZiPxq/voCCq2vxQByu/BE+4jX45N7O6FkKyA4TndSVXnHFM7sTvg5dP5bJjWqwRBVBa92VcRcq5Z47HiCJPSzNPGsaferrNUNWLB0jucIbWjjYyEaqma9AEluWF2CHyzHD2UpUX713zaCIBg8m/LYEELCsi8mm0J8FV9/Ju6bF/SGlEmxzdHdJR8UwJB2/3b5OnPtX8HzgmybEAIsN6IslEkQj4JSffzQzPjGu3NP2eA0syYxsSAqAhjYHC2B7dMoyRK63I8HTzmFkCd8NIQ2UvlMZ1bFnIXyk4QLGBpiSPqO5UGhXzuA0I27R3tEfY1YMa2qlIrriPsAHgicMrBtcDYS9TVa0vD1z+tqnKNfvhfv4LvEUzJ0sxy7/VPuSx4z/Siz2AgY+eiwP8/jwQCTY0SPTliAd3Aa45XsTQRuuH9ud1WC1e9uOA8v28/WVefIf9Bzlic9ZfRuhLj2LRj/fAkWnzCk4BH8swPKPgZgZJFEAA6FO8uo3+1VfLjO6EVfsDHoFmVtqRjAy2V3pH8SmBLe56KlRPm1DgZIULut7WllRRjIBRuLHIeelyS51xQP2kvtGmYGLP41
 BU7q8do/
 bqzkNpUf3p10JJuT/q6AELJfUB1nVVV/lKfWIiqfbfMzsbBzMen1ezQD2botcck+VsVqnA3yI/apYXITmrUNIiUY6VZZKxNBpUdYO6RRjFeFb21SHFS0cJri6Px5qmC9p6fXzOA93HIbfL76/XpRm6KbNREUVQlUVbuNJwYecwxa0K3yHWa+pCKfgIlAkkbaFmZv+2EUzR1B53XK3UEKjZ6x+BGl9G4MpXqR0UrZGnZIoMPpXod2U3K6NZp8Om7VQTet8YBDEnslaOFkjNG/YsHq5cLVKhTmbNt6w/cTUxFOE8qXVu2/PjSymplSmfxC7DMbwUU8qMPu0WlI1C3lxZprZJtoraZlyZ0+o/WM0zkFPkteC9xooAB2oU0B2R19N3sJMO8P8Xiq340vY05+BFw8BmaMej01EtM85/oczDhw5GQFllqNVM6HMX+hb8z6ySmnuc+gWFKFUCViAAyRlovyBemkZvHwD7TG0dwbHTPTuKWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The race harness exercises collapse against faults, pins, fork, mremap and
MADV_DONTNEED, but nothing in it ever elevates a source folio's refcount
from the reclaim or compaction side: LRU isolation, migration of a source
folio out from under the collapse, or swap traffic churning the LRU while
a collapse is in progress.

Add -p, which starts two more racing threads:

 - pageout: cycles MADV_PAGEOUT over a dedicated neighbor region
   (4 PMD areas, clamped to [16M, 64M]), faulting everything back in and
   verifying content each round -- swap traffic and LRU churn with an
   exact correctness check, since a page's pattern must survive the round
   trip through swap. Disabled with a note when the host has no swap:
   without it there is no anon reclaim to drive.

 - compactor: writes to /proc/sys/vm/compact_memory in a loop. Compaction
   isolates and migrates folios, so it competes with a collapse for the
   very pages it is trying to gather, with transient refcount elevations
   and migration entries of its own.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 109 ++++++++++++++++++-
 tools/testing/selftests/mm/run_vmtests.sh    |   2 +
 2 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 2e36e242caa7..304c72b4ee3c 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -22,6 +22,12 @@
  * clear, zero-filled copy, install-time pte_none() verify and abort)
  * race the faulters directly.
  *
+ * -p adds memory pressure to any of the above: MADV_PAGEOUT cycling
+ * on a dedicated neighbor region (swap traffic and LRU churn; skipped
+ * with a note when the host has no swap) and a compact_memory trigger
+ * loop (compaction migrates source folios, racing collapse's freeze
+ * with refcount elevation and migration entries of its own).
+ *
  * Correctness signals: every racing page must read as its pattern or
  * zero (MADV_DONTNEED), never anything else — checked continuously by
  * the faulters and the fork children and once at the end — plus
@@ -64,6 +70,8 @@ static unsigned long page_size;
 static char *region;		/* NR_AREAS * hpage_pmd_size */
 static char *mremap_area;	/* region + NR_SHARED_AREAS areas */
 static char *mremap_scratch;	/* well above the region */
+static char *pageout_area;	/* -p: dedicated pressure region */
+static size_t pageout_size;
 static int gup_fd = -1;
 static volatile int stop;
 static volatile int corrupted;
@@ -189,6 +197,70 @@ static void *mremapper_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * -p: swap traffic and LRU churn on a region of our own. The content
+ * check is exact — a page out and back through swap must preserve the
+ * pattern, and nothing else ever writes here.
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
+/* -p: compaction migrates the collapse sources out from under us. */
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
@@ -200,8 +272,9 @@ static unsigned long now_ms(void)
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-z] [-a areas]\n"
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-z] [-p] [-a areas]\n"
 		"\t-z: permissive max_ptes_none (hole-heavy windows)\n"
+		"\t-p: memory pressure (pageout + compaction) threads\n"
 		"\t-a: number of shared PMD-sized playground areas (default 3)\n");
 	exit(1);
 }
@@ -210,12 +283,13 @@ int main(int argc, char **argv)
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
+	const unsigned long pageout_bit = 1UL << 6, compactor_bit = 1UL << 7;
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	const char *mode = "stepped";
@@ -225,11 +299,12 @@ int main(int argc, char **argv)
 	unsigned long thread_mask = ~0UL;
 	int nr_areas_arg = 0;
 	bool permissive_none = false;
+	bool pressure = false;
 	unsigned long i;
 	int steps = 0;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "a:d:m:t:zh")) != -1) {
+	while ((opt = getopt(argc, argv, "a:d:m:t:zph")) != -1) {
 		switch (opt) {
 		case 'a':
 			nr_areas_arg = atoi(optarg);
@@ -247,6 +322,9 @@ int main(int argc, char **argv)
 		case 'z':
 			permissive_none = true;
 			break;
+		case 'p':
+			pressure = true;
+			break;
 		default:
 			usage();
 		}
@@ -271,6 +349,14 @@ int main(int argc, char **argv)
 	nr_shared_areas = nr_areas_arg > 0 ? nr_areas_arg : DEFAULT_SHARED_AREAS;
 	nr_areas = nr_shared_areas + 1;
 
+	if (!pressure) {
+		thread_mask &= ~(pageout_bit | compactor_bit);
+	} else if (!swap_available()) {
+		/* No swap, no anon reclaim: compaction-only pressure. */
+		ksft_print_msg("-p without swap: pageout thread disabled\n");
+		thread_mask &= ~pageout_bit;
+	}
+
 	ksft_set_plan(1);
 
 	thp_save_settings();
@@ -311,6 +397,21 @@ int main(int argc, char **argv)
 	mremap_area = region + nr_shared_areas * hpage_pmd_size;
 	mremap_scratch = (char *)BASE_ADDR + 2 * nr_areas * hpage_pmd_size;
 
+	if (thread_mask & pageout_bit) {
+		/*
+		 * Big enough to cycle real reclaim, small enough not to
+		 * dominate a TCG guest: 4 PMD areas, clamped to [16M, 64M].
+		 */
+		pageout_size = 4 * hpage_pmd_size;
+		pageout_size = pageout_size < (16UL << 20) ? (16UL << 20) :
+			       pageout_size > (64UL << 20) ? (64UL << 20) :
+			       pageout_size;
+		pageout_area = mmap(NULL, pageout_size, PROT_READ | PROT_WRITE,
+				    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (pageout_area == MAP_FAILED)
+			ksft_exit_fail_perror("mmap() pageout area");
+	}
+
 	/* Populate so the first pass has something to collapse. */
 	for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
 		*(unsigned int *)(region + i * page_size) = pattern(i);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 83a04b1e2520..f826cf940c3d 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -415,6 +415,8 @@ CATEGORY="thp" run_test ./khugepaged_race -d 5 -m madvise
 
 CATEGORY="thp" run_test ./khugepaged_race -d 5 -m stepped -z
 
+CATEGORY="thp" run_test ./khugepaged_race -d 5 -m stepped -p
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
-- 
2.54.0


