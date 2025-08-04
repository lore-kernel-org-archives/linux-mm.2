Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E0BC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303EB6B0088; Mon,  4 Aug 2025 05:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB976B0092; Mon,  4 Aug 2025 05:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F15C6B0095; Mon,  4 Aug 2025 05:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE616B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:11:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B1231411F8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:11:46 +0000 (UTC)
X-FDA: 83738507412.15.DB536EE
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 939AB8000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:11:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=awrsS0eu;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754298704; a=rsa-sha256;
	cv=none;
	b=aO88TQOjmWO0xGXm3A7YPrJmlmjXI68zE3AwWOEdt7xkT6pMgcCQhMAY7ZqNEG7HeVy6uh
	SzihDVuzZDR9jKN5uTsiv1zbHzHqD0SShxDDr90Jz3L/5C6/DFxgTagygetKLIfQOg8von
	q8/rkfkaLfzjmDmCCu+0zJMnW357uv4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=awrsS0eu;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754298704;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pugdPG7uA4O/On86pd0XfQDtWdJcBWVZDEqtuwJC78Q=;
	b=UzeSrjdkGJrE54TAJDyM/T17KMIjyRHXIdH3NgSS1SY5tpeCKFFj2LBdG9paZPPoLUSXi1
	NzK4nOnrB+ZcVmYK5LjZbzsLQP9CSuAcOyp0La0rswj/6/ZvoDbrRqoRxa55VS243sgnk6
	e5Dldmzzvdn9KIulD2cUJrfLQ47zzvE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61576e33ce9so7624719a12.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 02:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754298703; x=1754903503; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pugdPG7uA4O/On86pd0XfQDtWdJcBWVZDEqtuwJC78Q=;
        b=awrsS0euiJc77sN0P2hmoQagDpcxO+dYAPpVaG67puoSCRYZrRODat77li31hT1Avw
         4kVML7jnbPG6ax2DxUs3aRzr8Is5CxYCt+mnEsXaxwzDEkoRJjGO07N6UfON5ztWiBHb
         bSXw3YBF9BfYwWpDieLNIg1nxknbXzOL5JRu/M+ymnlHGiDZfcd/ft6hZTqtepAD9oT2
         ycKj33K60q8DAX7reERLoEe9A31YM+Ip35fzt2pJAvGYJ2bU2lm/xukFIlJ4YTGOQqFg
         7Q6EdcnqN+twOnIt3KulhD5KlByLNpeVDSSWdX5bHyjvHEBOKmYLLhibHfFp4iZCg3YP
         sihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298703; x=1754903503;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pugdPG7uA4O/On86pd0XfQDtWdJcBWVZDEqtuwJC78Q=;
        b=OPEbqX5pGCr0JcCqvIZhiR+EuQabPe5l+0NGDg0k+FO2XQf4maIVuf4stv0aASWqXL
         zt6U44ob31I0u1E+XvdXITMvyPVPcHJd5GoRkadVkXOepq40Q2dC0HWu10iQYv8lzVsR
         3mDugdqrDMR+5kcAnJ1z0CQ9oBbaLtuPa5eioyZqz/6FfuBMzzJHauq5/Wn0Be60DLOe
         Wx4g4gQtqrzhIri2wmFLuU5jqKMFHCyTLp3PrMXBTffTQIeCg0Y0h3V8DQBus+CDeLi9
         P7pyriLMu/7H9v/Hd4wg6HIyHBN4dVyX3vbJ5G9DeVbp3TkEX1vimzd2wpevslBrJF0M
         ccow==
X-Forwarded-Encrypted: i=1; AJvYcCVugGg0mKons7Jw885j4s7cMNKgDC9We0AaQBQAxGPUgX7HDxl+arsxC6yr8FVMVqiOCSlRUSP7sw==@kvack.org
X-Gm-Message-State: AOJu0YxdokaPOzN3ObcNX+GjHe1oTTkE+Jm09FRAwZw+pow3nW/j3o+d
	AOjLE9tilqqf+rFkWyCUAvrGqqQ5AnyiMPzoWpX0vJtDZgV0UgCIq3nY
X-Gm-Gg: ASbGncuaMfwBPK/pjneKnPlb1+aMxbAvV9JT19ZB9TIGzk4DQr2GEXQNsIgXkDzUyX4
	1jcNTkIh+BojyEQsaZJ14wjLqOpWkbANlepk1D3ZC1IVy1T9o6bvX35ORJSpHO+onzzjoANu77C
	X2/hVjPpUR2gS2S7SHY53W9MbPQgGm7ZjXrXOC5s5hPcWKehnjCPJWtNHgdsCudVNDIkSC/UBtr
	bTRktNOge7d/IEVcPUJmiksFdP3HwJLpyXXhkz/gMHWUv4zVM42/JNsJvtEXxI37AsayOZePucy
	RESSn49MQmc9czY7t9aqGR2vMkcwfA/EtB07+xgQsP6ks5Ohybl4inE9BlEQi2SYCLaaGx8DyP0
	3MJvDExMl0SG8TMfaPV5Oj6OdOx8C9bAhaMNCmVhsq9Q=
X-Google-Smtp-Source: AGHT+IHM3K4OZ+XP8yHHt8iGAEQo+9QHGcIwmPD9Lmbdp7R1ga5jUT96EJoH/t1FQUDctW0UjWXQkw==
X-Received: by 2002:a05:6402:2355:b0:615:3667:f4eb with SMTP id 4fb4d7f45d1cf-615e5dd9a53mr7855785a12.6.1754298702785;
        Mon, 04 Aug 2025 02:11:42 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a911567fsm6396175a12.61.2025.08.04.02.11.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Aug 2025 02:11:42 -0700 (PDT)
Date: Mon, 4 Aug 2025 09:11:41 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
Message-ID: <20250804091141.ifwryfmgjepwrog4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729053403.1071807-4-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 939AB8000D
X-Stat-Signature: cistsfdgiqf14ichxj3sony6n8xjng6x
X-HE-Tag: 1754298704-8986
X-HE-Meta: U2FsdGVkX1+uHEyXT02VREPDo8JtG5oEGNa29r8psUbQXq3ualO8Vb4ewp6CSnNbBUfFiB+7W9LQbDhV4SZScambyAZFQrWneelQF8wR8e29ii4XLB4/NiU20mbXqjqrjljXe1opAfGisdG49LZFEvHg+YVkQGazOcKqVaWFQyx0Z/sbvNoBl68qXk1oz1ylfCYgCXttKZPZcZdW2dODKXmpIKVZJix1G30LZBl3rfoKmYWwZHsRlEKNqdiPx/Z4pYt3U+un4Inbs19JlVvVLtr2y3T7xVy6CT7zi5mo5NGj+x/Hz6xLdoZQ9H9WdhhkpILH1yXRgBLdqJWS80nuXLuYAMZ+/RH09xFdaYzG9iaLGhC5v2NHj2N0+6eAsZGOsb4D++VCRxo4uFPhv8xfngtlA3ZPl1ihMB958DmW/aweCrxYRns9bxb9G6oz3BTazTqfTiIVX9NXIVQQIp4cbqrQ+AbgFbudS9ku2o7vweGH28uDxrpJRClOQTXxKQGroZC9O2qWhGYSOZEg1uAdvMBSA3zviLOVDkA/LxQayLHtLHUHLL7dOPFq6vRtCEuRD7apPNRg2K+eNu865PbMwzTJrPrVZBxhQXST8FOojc3QWLoDO5YwlxNU5CCuWv5kfVeVjpYX5OTjbdwLwVgpPfCeZrnoZ5g7pgSRmYzfDkCv4DeLMPSJhLQXfmr9BTwbuJi0UXd+dbeMxsM2fuKAZdc3i6tvmiANGMdK9WLWNKaxrETo09cbCIIV86O7i9tH7bitEjC4o3bRb2RrmShHrV9gETeT+UII8siDV6cHya+p1+aTsfMO9wUEWS3TQ1q8GgfA23V57NXkY0ar66Niev0rIFw1bf5eQAzRzKxAgeen8oFP3cN4qCq4gVjZ807fBqOqsru0jfMF7PaHeswkAei2v+b+dnDqHM/GKEx2RoxX4B0Oh9BL9fp7tRQsIWFvXNlLPc8yleLEMnRY/i/
 BaMEPHV3
 duH2R8WFO2TnrtyEtQO9A2LW818qRnbn/JYK6z6sLE05+egQujN5JfO/15B0cO044vHaQ4A+klbSmraUxjvyJKYDevsUUUXdAfBzzGMmaqgvb/FKRKuQPcxXjni7dwPfMvEsUj3EsjZ7EFy1rZjvSuR7zGkHRf3uQJQuX7LHQuNLeUajWWyJqzsTNLScs89rmxOOKXh68trIl+CYylsdnICSM42EZvhPhHdZ8NTyUXRPbl7V3aLPgKXK0PGmMd1ay6uQWQlxWB8jGbHmBXj83KpHYMvj735Cu7lKShwTK92n33z8+gjTsI+4SZsrrJmYouWcdUhMaDaE3z5tfyvwPEFVoDMbl5raRz389aMlAeVYIiC1+SCxkW2QXVIzFZC/6OJ+xApaM9QlHw3/CrY+wuO/YKNpHtOPf8Nli8kjzS7ixaa9QedPGAWUNbPT5p0bCqSpCzskIWzTlASkuZONdqzr6m2xbX1VkWapqIKaK4mCevr681o085V1pi0LLaJb1xvq9JynVDhVdu/WXrDW5rCCpYwP6d3ffvBPRBT2Fg4enDlLqpzZJfCwImPumULffrg3C9eTNwFGkGySTSZ4JFMnUJy8XPAsrpEnvgxVFjBeQefgfs5/OMRpNYeJzK5Uad8G1X/h5k5xiz4D8+gljp1hVZC/PIeAKVGNrQhB9aCnBF6Cpc5bHdHJP3UkH1IGsOYAQzEaVFOhC4iCVjVfSY8T9b8Lz1pIpER4k8uudtkOKQRe6LmXqDkW5rgH03EPVXG8AjmoMbnwb7LRtnmciKP0qExszXOrHJFcbGMOZtaBvZqrJlDJxRvcMHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:03:59AM +0530, Aboorva Devarajan wrote:
>From: Donet Tom <donettom@linux.ibm.com>
>
>This patch fixed 2 issues.
>
>1) After fork() in test_prctl_fork, the child process uses the file
>descriptors from the parent process to read ksm_stat and
>ksm_merging_pages. This results in incorrect values being read (parent
>process ksm_stat and ksm_merging_pages will be read in child), causing
>the test to fail.
>
>This patch calls init_global_file_handles() in the child process to
>ensure that the current process's file descriptors are used to read
>ksm_stat and ksm_merging_pages.
>
>2) All tests currently call ksm_merge to trigger page merging.
>To ensure the system remains in a consistent state for subsequent
>tests, it is better to call ksm_unmerge during the test cleanup phase.
>
>In the test_prctl_fork test, after a fork(), reading ksm_merging_pages
>in the child process returns a non-zero value because a previous test
>performed a merge, and the child's memory state is inherited from the
>parent.
>
>Although the child process calls ksm_unmerge, the ksm_merging_pages
>counter in the parent is reset to zero, while the child's counter
>remains unchanged. This discrepancy causes the test to fail.
>
>To avoid this issue, each test should call ksm_unmerge during cleanup
>to ensure the counter is reset and the system is in a clean state for
>subsequent tests.
>
>execv argument is an array of pointers to null-terminated strings.
>In this patch we also added NULL in the execv argument.
>
>Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>---
> tools/testing/selftests/mm/ksm_functional_tests.c | 12 +++++++++++-
> 1 file changed, 11 insertions(+), 1 deletion(-)
>
>diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
>index d8bd1911dfc0..996dc6645570 100644
>--- a/tools/testing/selftests/mm/ksm_functional_tests.c
>+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>@@ -46,6 +46,8 @@ static int ksm_use_zero_pages_fd;
> static int pagemap_fd;
> static size_t pagesize;
> 
>+static void init_global_file_handles(void);
>+
> static bool range_maps_duplicates(char *addr, unsigned long size)
> {
> 	unsigned long offs_a, offs_b, pfn_a, pfn_b;
>@@ -274,6 +276,7 @@ static void test_unmerge(void)
> 	ksft_test_result(!range_maps_duplicates(map, size),
> 			 "Pages were unmerged\n");
> unmap:
>+	ksm_unmerge();

In __mmap_and_merge_range(), we call ksm_unmerge(). Why this one not help?

Not very familiar with ksm stuff. Would you mind giving more on how this fix
the failure you see?

> 	munmap(map, size);
> }
> 
>@@ -338,6 +341,7 @@ static void test_unmerge_zero_pages(void)
> 	ksft_test_result(!range_maps_duplicates(map, size),
> 			"KSM zero pages were unmerged\n");
> unmap:
>+	ksm_unmerge();
> 	munmap(map, size);
> }
> 
>@@ -366,6 +370,7 @@ static void test_unmerge_discarded(void)
> 	ksft_test_result(!range_maps_duplicates(map, size),
> 			 "Pages were unmerged\n");
> unmap:
>+	ksm_unmerge();
> 	munmap(map, size);
> }
> 
>@@ -452,6 +457,7 @@ static void test_unmerge_uffd_wp(void)
> close_uffd:
> 	close(uffd);
> unmap:
>+	ksm_unmerge();
> 	munmap(map, size);
> }
> #endif
>@@ -515,6 +521,7 @@ static int test_child_ksm(void)
> 	else if (map == MAP_MERGE_SKIP)
> 		return -3;
> 
>+	ksm_unmerge();
> 	munmap(map, size);
> 	return 0;
> }
>@@ -548,6 +555,7 @@ static void test_prctl_fork(void)
> 
> 	child_pid = fork();
> 	if (!child_pid) {
>+		init_global_file_handles();

Would this leave fd in parent as orphan?

> 		exit(test_child_ksm());
> 	} else if (child_pid < 0) {
> 		ksft_test_result_fail("fork() failed\n");
>@@ -595,7 +603,7 @@ static void test_prctl_fork_exec(void)
> 		return;
> 	} else if (child_pid == 0) {
> 		char *prg_name = "./ksm_functional_tests";
>-		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME };
>+		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME, NULL };
> 
> 		execv(prg_name, argv_for_program);
> 		return;
>@@ -644,6 +652,7 @@ static void test_prctl_unmerge(void)
> 	ksft_test_result(!range_maps_duplicates(map, size),
> 			 "Pages were unmerged\n");
> unmap:
>+	ksm_unmerge();
> 	munmap(map, size);
> }
> 
>@@ -677,6 +686,7 @@ static void test_prot_none(void)
> 	ksft_test_result(!range_maps_duplicates(map, size),
> 			 "Pages were unmerged\n");
> unmap:
>+	ksm_unmerge();
> 	munmap(map, size);
> }
> 
>-- 
>2.47.1
>

-- 
Wei Yang
Help you, Help me

