Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E548606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 02:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=VSsuqiCk
Received: by kanga.kvack.org (Postfix)
	id 8E9036B05B5; Tue, 10 Nov 2026 21:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0616B05B6; Tue, 10 Nov 2026 21:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B03D6B05BA; Tue, 10 Nov 2026 21:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 571A76B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:10:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E75F6A01EA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:10:35 +0000 (UTC)
X-FDA: 85421209230.14.092C5DF
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id E784540006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:10:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=VSsuqiCk;
	spf=pass (imf27.hostedemail.com: domain of chris@chrisdown.name designates 74.125.225.138 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794363034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ik0iuyriivwGuaOXOQXI6fjCvEcrYQv+lAummPtyyW8=;
	b=gRg+ostmFf2C1DtkI7p6FIirCPAvYAlU9Ik6+5H8nVuAp0/AuRvteykstHs/T+BHZUBMQg
	jdI+LE8y9Ac3kZTkeDui74PyR7D3wfrzsALewfUr9PTPXIwKaSJyQ73txQGTR3CGYVW7el
	S6VfJ2mIy+YUIBPRaj90ciytn6vnD6I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794363034;
	b=DntQkV0FyzSyqZtmc4ENXZ+RM2OI9V74wsujEpwFSK0ZGpvvqaWoxB7kStWw9A3tNwmGh/
	XhqNU3A+KjduXL/FLEyvn932CAR3NGmytaRyAyPSZ4/eZh0hWVG6sbZyQM+3MYnQb1vbWL
	TXGaxce8h7B57hQKkxtrFWxMXNok6ak=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=VSsuqiCk;
	spf=pass (imf27.hostedemail.com: domain of chris@chrisdown.name designates 74.125.225.138 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b76ade741cso10695955e9.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794363032; x=1794967832; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ik0iuyriivwGuaOXOQXI6fjCvEcrYQv+lAummPtyyW8=;
        b=VSsuqiCkLx9sn/POqpCAwVnHJvWCGhVePaVaYmjBhokQJDth5NElViWvalX9uIImt+
         Gw5q7HbGR9Fs8qQIrU4xEI9hYkQdzClj3j72XrT0tLSM7VUwPmTtQTzWQC6hQYDe4UVK
         msJ1aCLFGUkLfzSffx5ewg4kHYaD2O9QIwTFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794363032; x=1794967832;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ik0iuyriivwGuaOXOQXI6fjCvEcrYQv+lAummPtyyW8=;
        b=w3cRyNo0NCPJgAytoum7W0/TIXpVNA2Msu2w0I2qPEM/DfiUltPxT0CbhreWW/itfc
         /VgA3bhUqYQEkFYj1EQFBpkyDirBLwqv/mUpsr5iE2JbYWYoybatkIA5smJAuCx3VLpX
         36iKPyqEOkJi+ALLnuwIKJ4OyR8Ezo4+MCJdW5loJkIMbjMZni7iNBxNBVAdOV1K4bug
         eD+nVpi8ptBSM9hdNyoly/nyTfutkcEvb6XB3e8CDlm3mtkB0lcTlwHgOBEiv108JxC0
         HcRpWWA2nMDTdzkzFpNFd4OTwWcyl+HPibwfsK4UUzzI/JjeiVAcO6h6S1iOTTvMlDyC
         sMQQ==
X-Forwarded-Encrypted: i=1; AL+hErEZTTyu6IMF85BT/VsAvbQCDx630we4oNHPo+wE/Vbl4Ra5fFFMunwtHfrU84CrpwZP2Ey8C5J/Yw==@kvack.org
X-Gm-Message-State: APuU4Z8vWAOcm8HwDk/6B0hFgAp1x4F1lw0Mc617AMj6CsnJDH47iAUy
	QcmemHiOcPOCHQ0EswNtSJt+vtSRTCsu294JOWfQxhpNkyXNQT/WutHmKsPCRLbAdxk=
X-Gm-Gg: AYBFou0BE0CVg0UIWNxvvCqEjUYJBYjg97iCmOPwK7J0Y0YC7y6sVWjNTrg1IJSUkx7
	uqLGj8ZL9Re8l8fE4q8Y5nFkCEozy8oFunzxd3U/2gxSOq49M90NOlAAlmehN/3/g+upqlIS3Qx
	TTsWanfBKYr8XzO+gH3QeFPBqdyENYswR8xgJVinjqbqd3ahGb8eProxHIf4FqL22Fdl5c+1Lg4
	rmGB3C4VvRjcEEOXB2qzlDfE0QByHQJbqGGvy6Mz7NQ9Lvrd5h/Hft4JgU3OJyKIhXBdBUEyWYO
	QWQuZzRzfPvV1xxzyclUELRq0GnOpt0Qdh2GmukTr+uPGFwbooArnghi+haVJtWIJbfVKpVAPP/
	JvMJ9noeJySyv+ZPzF6tlXeMHA+rsXz2LxzMu2Ul7qy14ALmXNnBKASdukMUZ3UrXGNYfvrA+jy
	u3A1O/GhPGeIvxdbKiEPsqUYqP+JAyAZBFDVmZQjtKwJqM2vyZXSXI9yWzJzk8Shyo/Cku1xHkE
	8+0fXZVb4GMZbxqYXSPiRRUd83X2wYfUHzPXTqDw09bVAkAvPW1yDaJ1gnaeD1rlyfa2RNET0Py
	+RtmmrN/pt+zHNuEX7qtMd2niqqtv4V+kClO+b9sOTvENVYa/LmmLSHRkkR4PRzibqCFYrVry/W
	LtUwXYsqaOTHBuNj6jvONgABTSsxxu2v7XN2Gh7aRD4hLW1xmNeVnqnddmivqjTTK1if8JBv4E9
	jFIXh8QjEyrj5Hn2dYgbjNn2f3bg2wfY3ke2MMiqFSFW9p4nOyAB8K
X-Received: by 2002:a05:600c:348d:b0:4a2:148b:c88c with SMTP id 5b1f17b1804b1-4ba0935cdafmr11818455e9.8.1794363031801;
        Tue, 10 Nov 2026 18:10:31 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983585c5c4sm6776753f8f.17.2026.11.10.18.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 18:10:31 -0800 (PST)
Date: Tue, 10 Nov 2026 18:10:28 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4] selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
 regression test
Message-ID: <avPOlMOmUdjPe5NJ@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E784540006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jfubwyxqpjm9mqd7hrtggmkygtmqyx9c
X-Rspam-User: 
X-HE-Tag: 1794363033-710808
X-HE-Meta: U2FsdGVkX1+awre/k4371aN7ceK7K9VSv6j5agm6dkdRvadOJ93AI6ES3xB6zKfe57tnoI/nrUDxR1hmUdR3mdpAJt5xlP8lRCY5V9xvLvim5R8SI+Uyfxgj0j1PNwrJCWoMbeBCiJqD0fgod5d0C8cUqBmEh+L16LVk66zh10fY31nDycmiNx5O2pvk+fNdsyvaEWVdBC6RUFmXwncitQn2Px82erzb6haexQhV7A6CxHjMIHE4L3Uu/t1XlgJA7H2OIoXmvAW6HUOMnqglJxMmfQeFh4XM/Q7v2FscT25Q9cZI7rXW9LLB4cecmKTI890/feAa2yHv5WOMb/o2NdM2/ekHg6NrcndHFpavil1PbvJE/il+KSI/jOzeo3mNLdZSJ44iBBn5BImOZbofjUd+16xcQWcXUPnvmCgEfvFNwFm9PPyTtHXjIdfHhiiufmgB7pQYkmBXfQpFu6815OkVKrZeWh4wBkqVyd/UmxjOZdYZYRrfGNEwIVKjjLZSmVExmfw6jdJAjvJfJ0zwEDahmxqUNcHQ5HOaCIE5wwGkQwFQvJ6qiulRwLGEOiKzor5LE7tIS4e/H6zZSH8XUiwv3Y34rbieVt6C52dVKtIAFlDwKNQlo8T8NeTP+59VRJgZ482i7xROQmSxUxvQfxPSM26EV0FizG0vFMHcvyomF/CF2yzf5TqCRGM8RwCKsJeBjxvbLhsofZ0O7oo3tGbCQDblpEuHrzaT9AXP5gSewm9m+DovjdsNCandxCTlXhaapHnkBS+wvF/Ync4zNtztsaygE9pIbS05B//CqJ3PkwMiYpQM+njr2Onw1NZZUwpDhpswg/VRPxs6uju8dqmMmvxNQlUf8i7pj5Ta+ShCwmM0Q0sUWHG4EgbPmq053RzLA7k1BgBsxwTIpTfaCvxec/rl6Mg9X4m+juNprEiDWvB5DtJOp9iZaxJDSdZy+6BkoqHHJPhoplED6dd
 Bz6K/tyT
 8Tbah8yLrNS0YCOWrhmtBEENWV4c9cggV0BZgMDf4MV/PXKoPGwgJDagc8nyQzrmTZDzCzBnmcvbnB7TMtApnoT7dHmkxINXqedPWYlPg5/GZ8x2XrHCI7CvI4mm+nC5fOzfSoZAvIDbNQW+dvw9suG4hGR5qMadZDWLw1Krg7D6Kb0E3fOdIyZgfY1QJzQsfAB/meCVFnQPlJbhPAaf/BtWDJkdAM2sRBznGFjw7Ndgqyjo3bEcYHXilBHoHAqz7mHqbum9xbvLmy74nbvf/VpCCVM022fvZuwFS5vu52FLRz8PEDYK9ke0qFO20kr/AsOThEkD1IWDEBo+EwmHLm7JYqC6qn4a01VwvD/N4kCHcFACGV4D+wKP5XuUDCCnot2vCYJQYwpiPo9s6EoA956uppBL/jyOKgWqXz74qqAkRxSYnv8+xQ/kX+2T3unAPw5UNARxPB2wIKocGa22Hte3fTV2Vje2AY9V4RQGcUp+we9dS7WeY4SEtDKWRSLGV0A0nSryPLSTeXtlLhJuZ4EK12+XvKWol2N+n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The move-pmd test exercises UFFDIO_MOVE on anonymous THPs but does not
cover the huge zeropage PMD path.

Add a test that faults in a huge zeropage PMD, moves it in response to
one missing fault, and checks that the destination still maps the huge
zeropage.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---

v3 at https://lore.kernel.org/r/abongwF3X0G8xY1I@chrisdown.name

Sorry, this got lost in my backlog, so resending. This is the companion for my 
earlier CVE patch.

v4:

- Clarify the PMD size skip message, rename pmd_pages to nr_pages_per_pmd,
  and use a single expected pagemap category mask (thanks, David)
- Read AnonHugePages from smaps to preserve the accounting check after
  check_huge_anon() switched to pagemap

 tools/testing/selftests/mm/uffd-unit-tests.c | 98 ++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c         | 29 ++++++
 tools/testing/selftests/mm/vm_util.h         |  2 +
 3 files changed, 129 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb..f05437078101 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2034,6 +2034,97 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
 			      uffd_move_pmd_handle_fault);
 }
 
+static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
+					     uffd_test_args_t *targs)
+{
+	unsigned long pmd_size = read_pmd_pagesize();
+	unsigned long nr_pages_per_pmd;
+	unsigned long bytes = gopts->nr_pages * gopts->page_size;
+	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
+	char *aligned_src, *aligned_dst;
+	unsigned long src_offs, dst_offs, max_offs;
+	pthread_t uffd_mon;
+	struct uffd_args args = { 0 };
+	char c = '\0';
+	int pagemap_fd;
+
+	if (pmd_size <= gopts->page_size) {
+		uffd_test_skip("Could not detect PMD size");
+		return;
+	}
+	if (!detect_huge_zeropage()) {
+		uffd_test_skip("transparent huge zeropage disabled");
+		return;
+	}
+
+	nr_pages_per_pmd = pmd_size / gopts->page_size;
+	if (bytes < pmd_size) {
+		uffd_test_skip("not enough pages for one PMD-sized move");
+		return;
+	}
+
+	aligned_src = ALIGN_UP(orig_area_src, pmd_size);
+	aligned_dst = ALIGN_UP(orig_area_dst, pmd_size);
+	src_offs = (aligned_src - orig_area_src) / gopts->page_size;
+	dst_offs = (aligned_dst - orig_area_dst) / gopts->page_size;
+	max_offs = src_offs > dst_offs ? src_offs : dst_offs;
+	if (max_offs + nr_pages_per_pmd > gopts->nr_pages) {
+		uffd_test_skip("could not find aligned PMD-sized src/dst window");
+		return;
+	}
+
+	if (madvise(orig_area_dst, bytes, MADV_HUGEPAGE))
+		err("madvise(MADV_HUGEPAGE) failure");
+	if (madvise(orig_area_src, bytes, MADV_DONTFORK))
+		err("madvise(MADV_DONTFORK) failure");
+	if (madvise(aligned_src, pmd_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failure");
+
+	/* Fault in a PMD-sized huge zeropage mapping in the source. */
+	force_read_pages(aligned_src, nr_pages_per_pmd, gopts->page_size);
+
+	pagemap_fd = pagemap_open();
+	if (!pagemap_is_huge_zero(pagemap_fd, aligned_src)) {
+		close(pagemap_fd);
+		uffd_test_skip("could not fault in the huge zeropage");
+		return;
+	}
+	gopts->area_src = aligned_src;
+	gopts->area_dst = aligned_dst;
+
+	if (uffd_register(gopts->uffd, gopts->area_dst, pmd_size, true, false, false))
+		err("register failure");
+
+	args.gopts = gopts;
+	args.handle_fault = uffd_move_pmd_handle_fault;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	/*
+	 * One fault on dst should trigger a single PMD-sized UFFDIO_MOVE from
+	 * the huge zeropage PMD we populated in the source.
+	 */
+	force_read_pages(gopts->area_dst, nr_pages_per_pmd, gopts->page_size);
+
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (args.missing_faults != 1 || args.minor_faults != 0)
+		uffd_test_fail("stats check error");
+	else if (!pagemap_is_huge_zero(pagemap_fd, gopts->area_dst))
+		uffd_test_fail("moved destination is not a huge zeropage PMD");
+	else if (smaps_has_anon_huge_pages(gopts->area_dst))
+		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
+	else
+		uffd_test_pass();
+
+	gopts->area_src = orig_area_src;
+	gopts->area_dst = orig_area_dst;
+	close(pagemap_fd);
+}
+
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
@@ -2357,6 +2448,13 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
+	{
+		.name = "move-pmd-huge-zeropage",
+		.uffd_fn = uffd_move_pmd_huge_zeropage_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_pmd_case_ops,
+	},
 	{
 		.name = "move-pmd-split",
 		.uffd_fn = uffd_move_pmd_split_test,
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 515031b8283d..0b8a5100e393 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -122,6 +122,18 @@ bool pagemap_is_populated(int fd, char *start)
 				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
 }
 
+bool pagemap_is_huge_zero(int fd, char *start)
+{
+	const uint64_t expected = PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE;
+	uint64_t categories;
+
+	if (!pagemap_scan_supported(fd, start))
+		return false;
+
+	categories = pagemap_scan_get_categories(fd, start);
+	return (categories & expected) == expected;
+}
+
 unsigned long pagemap_get_pfn(int fd, char *start)
 {
 	uint64_t entry = pagemap_get_entry(fd, start);
@@ -351,6 +363,23 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
+bool smaps_has_anon_huge_pages(void *addr)
+{
+	char buf[MAX_LINE_LENGTH];
+	unsigned long anon_huge_kb;
+	char *entry, *end;
+
+	entry = __get_smap_entry(addr, "AnonHugePages:", buf, sizeof(buf));
+	if (!entry)
+		ksft_exit_fail_msg("could not find AnonHugePages\n");
+
+	anon_huge_kb = strtoul(entry, &end, 10);
+	if (end == entry)
+		ksft_exit_fail_msg("could not parse AnonHugePages\n");
+
+	return anon_huge_kb != 0;
+}
+
 static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d432..a9b84d4391f8 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -89,11 +89,13 @@ uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
 bool pagemap_is_swapped(int fd, char *start);
 bool pagemap_is_populated(int fd, char *start);
+bool pagemap_is_huge_zero(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
+bool smaps_has_anon_huge_pages(void *addr);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);

base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.54.0


