Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75059606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=nS8VFf5k
Received: by kanga.kvack.org (Postfix)
	id D92166B0307; Mon, 19 Oct 2026 13:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69576B0308; Mon, 19 Oct 2026 13:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30B56B0309; Mon, 19 Oct 2026 13:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C89F6B0307
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:12:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20FADA07FE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:21 +0000 (UTC)
X-FDA: 85340019282.21.FBBD282
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5C7EF20009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nS8VFf5k;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429939;
	b=Lplf9UMnRPSrHnu9wiiWgmloHX25d6n46pnJnrJoX96Y0wvRQ9BHiVJG3yd8i3WA2EitO4
	dE5dL0TDRc13bwEmRK8stLPWGy3QqkD+lKW/nY9gxisgaxXbmNn4iYrrCdrKk7qXaD5Dc7
	NvHKF8+87g0FOpXuqQWRSj1uv7SryD4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nS8VFf5k;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0HBvVezVTtBJY8hj2GhlVDWYrJlySjFH5I8pUaDGQ8=;
	b=ayihC1q6ZyodUcNtF7DmxOYJOoAZ1EOadKUr87XHpJVo0b63Eyp53L6owGPRobkbCuLYGQ
	ttS7+O2hXC3iY7PIHZqufBPLClVD7uDT3zpr5M+6TYcePogbGuqC1t1zS2wSmuU7XmB0rt
	LZpJOwZrvkJZHqohiMTLtLx5VwQ9d9k=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-917aca1aee5so23896556d6.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792429938; x=1793034738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u0HBvVezVTtBJY8hj2GhlVDWYrJlySjFH5I8pUaDGQ8=;
        b=nS8VFf5kmEYiSLnzBq5iR88jJH8TGLbpmWh6xwvgji2JayGsmqaphqh7Z7LSF0jfDQ
         nuDwBMKidMoIdou9J3MpjhtARmlb+xhryveEKZezNgn2e337Hq9SuBwC/UCUcAc9gObB
         9nJo2p6ZZs7uGXSLGhTyB06J3VHT/z1B4rtRbxox9pNIeRqbFe25Zi/+ij/KTlsssNdy
         SY6dGxYBzd75NHAgiK67Wf6nVyeTzzfb5JFgxSO4EVTpZZrFKL2R/PUgJf1pn2g4g/2e
         UlO83XNg2/naf75ALakoo7eK+aaFw2vv/o5igCdAD7saHjboysNFF65xep2lhUCQyb9V
         1s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429938; x=1793034738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u0HBvVezVTtBJY8hj2GhlVDWYrJlySjFH5I8pUaDGQ8=;
        b=HNa5hVMoC22OjAeI5VwlmMfpcqDQEVz5Xp6mQ+Bjyge2kik7wQonUlt0Fq7+uO2X80
         ualjiQH5TOm8hpxbj814cAVr0PZPymmaI5s3WOcRJmuORb3l9zTFJU1ArTyL7/BcxHZm
         3en1e9pFj37mkUw/vumW4Y+cbKrlhk6jO/cwK0qJ+4+1gqRKsXSaWuDVG8KW3n7LAjDx
         P7y26rH/FjKOl1Un8Q/sOkgaN+Je3uHx19bcfJPiv98lfOQmGgJSvEsjXOuqGZPoEHOq
         Nwu22JPG9FmULsYiyNGSaepYr5UWCqg7bBr26AUG7qHVc7SSUBC4gWAbn3Iu+LNudX4p
         vFdg==
X-Gm-Message-State: AFq9FYItO493V3dG+rfRIgNvg9sEHSU758AZVNp/jzStL3+sRS5Yidrl
	x/vXdPV/i3vsFD/yv2E0vFzXYYyXAkQ70n6Kvfca+4z/AackqDQq51+0v0iHfycw47k=
X-Gm-Gg: AYBFou1Z5M9xXFwAB4JeJFSAx3q7Pi9D+pKR6LjGbXRYb8+z+wcC47iA+iD5CmjyAog
	Xa4+H84Uz84Ihn9s/1aiF1bL0CwMx5AJmMyfC4RC6Hw24AI435CouJ1WpM+McFSRILvBG811zgJ
	RwUMYRdbqbb29i/uXTplxEiXSbXFZBAI3l8iby7WNd9RbwHPfm3KXxEYDkbCAAv7ECKl5nZ/BNS
	so8M6nNpSsw61cp0ukjN+uypx9s7G5S55RUPlVw8OD04gJ5XS5kzxX8XcS//fRcjK5A5fQxkyqs
	P1mZvKDJZhXkvFQhZuZcPIslO9csH0ghi0xmWwj90GdxiUeTNjOopbCzih4lU37vrIWZLEvfuGU
	NW5y00odDtY3TtEnrX37EM+jfeNpAEYIJpgYYE9TpV76GTg3e/bdeoX24BhAxsaOAXFtI/k0OsN
	KR6BhlqyFPSBWfsqnI6UkoNrl02am0DlseZsWmFyhm9p5wqgWML7avkC9TG70q6cWe4zSNNjC9n
	iq5axQYpnF8FCAovyp9jZH0dTonraByG+IXpQ+1Ba5j0+6LE8HbJKIEHhee
X-Received: by 2002:a05:6214:3285:b0:91b:5d3a:f127 with SMTP id 6a1803df08f44-91bdf2dd132mr149004556d6.50.1792429938570;
        Mon, 19 Oct 2026 10:12:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:18 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH v3 6/7] selftests/mm: check MADV_PAGEOUT file permissions
Date: Mon, 19 Oct 2026 13:12:05 -0400
Message-ID: <20261019171206.3331374-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cu88ndghaquhawsnpaphwssjjweep6fk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C7EF20009
X-Rspam-User: 
X-HE-Tag: 1792429939-814164
X-HE-Meta: U2FsdGVkX18H6FK5HrJnviXrSh65D2/TZwZYFIhus0XcM2HVnV3XhfYsVfaEfMsRKRlL6Ig/Ej4ox7ifE/pzGkAQG+Fy9kvOGv0ybUH8+xp16uFpqhOb+ndwtle1fIn+crMHeWlq83j5NbRszK1U89Riboq+GTr9m/j7VOexhFvRlk4xiUPimb19CWZcBMGJ0wOPS4XOizUY4W6E2+0r8tnVI2J4MVh9xxBelJaNzBqWLH2wSAZUmnONdzrHEYlETgAJSVOd+4d9j6YQU/zppS652MC/ffQC+7B2cZmYOq6haZuX1/MvfetxqZiBQQKsXxKIEKYUmh7+nO5i1pSuqYMPhVeJrz8diWufyaU5aBQ3FsuoJ3jW35XYKUhQ9K7hHEXbiuTQe1m+hCxtJl27w2IP27Xay2RHzhF+mdXWKQjejzQE/eagNc7AagsHV558cV3HO9IXfnSBaadJmBS0gbxWUmOvWXxEe99xejK5Xr/XpkGaJ1nNpX4Kwbr7P21OUoGWj1AodXen7hDrjnc76yYl6EvKrrd3iGdhRqXPL93EStilRkckFZlVyAXkpf2+AaSHFHEZzAHRP2xkutyt3MEvGapXPrqIpEj/lGBuu9Swy+GVB4I9BNDx9uilRUtZADSjMmTOz/ceNsEhMi6LNgqbV5IJ8LbShFK7Vjzqs6KoyCVjmRKuEvN6RSkS4XIQBi5pv/FwK2FAEkK575nP2O8Qdzjgw9jbNEdTg6kJLqJ+XquGMk1diaCKBllyj31nTu6Hw0/ZjLDkgfw2kQ63l9da7/Y/vFlhi+d575u36jc82k5ruQ8lywNhNegi25gzHNjovtTT1dg4J81LrB5ZNumRlaT6QpE/vZZVXdRp/jgT61GRy+GGsqsfjGLwOnaXGGSQHq80KKOzfIk3yGOC3qNSBeROuTm2SgnTjLuYBOPsJnkaMmejPCyYpia1q7+LtU8i7F+kBDBIHk6ACTF
 UHc+SyXc
 xH35JA/Grmm2xoDrG6cKQ2Z/tZ5yUpVLxxDfnktYGeJ5YlwcIfVFuOL3aH0vgEH92hjme3K/cHKbnsGcddWHDbKcRy63vs8md3J/2pI2ZjtfLCiTvT/WblTV+uAagn9PEE0Wg01XD5kA4n2G+x1PUN0qgd8Cvz+jJOndhGvjZYoex7MvLO1PaCOQUjWsNsx9oETEJTpriN08FOasjagnAsq4mVCPIsIR+Gq1Vz7664vwQT+QGSI+cVMiR2RfsjXnK4h8TBOtRW2igPRWW7pUtqHWXSyvZeVR/CSDAEJ6iou+eoaoNYy3lK5s9rKZZqc1XE1BNRKEe0fH3+aLZUQ/cvBoLvOfFEF+2+8aX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_PAGEOUT only pages out file pages for a caller that owns the file or
could open it for writing, per can_do_file_pageout(). Any other caller
gets nothing from a shared file mapping, and only the anonymous COW pages
from a private one.

main() now also checks once whether MADV_PAGEOUT can unmap a clean page
of a file in /tmp, where the tests make their files. The tests below skip
if it cannot, since none of them would show anything.

Check that the owner of a read-only file can page out a clean page of
it. When started as root, the test hands the file to nobody and drops
privileges, so that capabilities cannot stand in for ownership and
nobody need not be able to write to /tmp.

Also check that an unauthorized caller leaves a shared file page mapped,
and that it pages out the COW page of a private mapping but not the file
page next to it. These need root to change credentials, and skip if that
fails. The private mapping check also skips if MADV_PAGEOUT cannot swap.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 .../testing/selftests/mm/madv_cold_pageout.c  | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
index b5eec490fb68..f5a81d7bd08b 100644
--- a/tools/testing/selftests/mm/madv_cold_pageout.c
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <grp.h>
 #include <sched.h>
 #include <stdbool.h>
 #include <stdint.h>
@@ -29,6 +30,8 @@ static size_t page_size;
 static size_t pmd_size;
 /* Whether MADV_PAGEOUT can swap out anonymous memory, see main(). */
 static bool can_swap;
+/* Whether MADV_PAGEOUT can unmap clean file pages in /tmp, see main(). */
+static bool can_unmap_file;
 
 /*
  * Keep this task on one CPU, so that draining that CPU's LRU batches drains
@@ -276,6 +279,15 @@ static char *map_temp_file(struct __test_metadata *_metadata, size_t size,
 	return mapping;
 }
 
+/* The uid and gid of nobody. */
+#define NOBODY 65534
+
+/* Become nobody, an unprivileged user without capabilities. */
+static bool drop_privileges(void)
+{
+	return !setgroups(0, NULL) && !setgid(NOBODY) && !setuid(NOBODY);
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -689,6 +701,97 @@ TEST_F(madv_cold_pageout, cold_preserves_half_of_pte_mapped_thp)
 	ASSERT_EQ(munmap(mapping, pmd_size), 0);
 }
 
+/*
+ * The owner of a file may page out its clean page-cache pages. Run as an
+ * unprivileged owner, so that capabilities cannot stand in for ownership.
+ */
+TEST_F(madv_cold_pageout, pageout_unmaps_owned_file_page)
+{
+	char *mapping;
+	int fd;
+
+	if (!can_unmap_file)
+		SKIP(return, "MADV_PAGEOUT cannot unmap file pages");
+	fd = create_temp_file(page_size);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	/* Hand the file over first, as nobody may not be able to write /tmp. */
+	if (!geteuid()) {
+		ASSERT_EQ(fchown(fd, NOBODY, NOBODY), 0);
+		if (!drop_privileges())
+			SKIP(return, "could not drop privileges");
+	}
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_PRIVATE,
+		       fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	close(fd);
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_TRUE(pageout_until_unmapped(mapping, page_size,
+					   self->pagemap_fd));
+	ASSERT_EQ(mapping[0], 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * A caller that neither owns nor may write a file must not page out its
+ * shared mappings. MADV_PAGEOUT succeeds but leaves the page mapped.
+ */
+TEST_F(madv_cold_pageout, pageout_skips_unauthorized_shared_file)
+{
+	char *mapping;
+
+	/* Otherwise the page would stay mapped regardless. */
+	if (!can_unmap_file)
+		SKIP(return, "MADV_PAGEOUT cannot unmap file pages");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0400);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * A caller that neither owns nor may write a file may page out the anonymous
+ * COW pages of a private mapping of it, but must leave the file pages
+ * mapped.
+ */
+TEST_F(madv_cold_pageout, pageout_private_file_reclaims_only_cow)
+{
+	char *mapping;
+
+	if (!can_swap || !can_unmap_file)
+		SKIP(return, "MADV_PAGEOUT cannot swap or unmap file pages");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	mapping = map_temp_file(_metadata, 2 * page_size, MAP_PRIVATE,
+				0400);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_EQ(mapping[page_size], 0);
+	mapping[0] = 1;
+
+	ASSERT_TRUE(pageout_until_swapped(mapping, 2 * page_size,
+					  self->pagemap_fd));
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
+					 mapping + page_size));
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[page_size], 0);
+
+	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
@@ -706,6 +809,27 @@ static bool probe_swap(int pagemap_fd)
 	return swapped;
 }
 
+/* Unmap a clean page of a file in /tmp, where the tests make their files. */
+static bool probe_file_unmap(int pagemap_fd)
+{
+	bool unmapped;
+	char *page;
+	int fd;
+
+	fd = create_temp_file(page_size);
+	if (fd < 0)
+		ksft_exit_fail_perror("create_temp_file");
+	page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (page == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	close(fd);
+	FORCE_READ(page[0]);
+	unmapped = pageout_until_unmapped(page, page_size, pagemap_fd);
+	munmap(page, page_size);
+
+	return unmapped;
+}
+
 int main(int argc, char **argv)
 {
 	int pagemap_fd;
@@ -724,6 +848,9 @@ int main(int argc, char **argv)
 	can_swap = probe_swap(pagemap_fd);
 	if (!can_swap)
 		ksft_print_msg("MADV_PAGEOUT cannot swap\n");
+	can_unmap_file = probe_file_unmap(pagemap_fd);
+	if (!can_unmap_file)
+		ksft_print_msg("MADV_PAGEOUT cannot unmap file pages\n");
 	close(pagemap_fd);
 
 	return test_harness_run(argc, argv);
-- 
2.56.0


