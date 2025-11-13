Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB07CD6E5C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B27A8E0008; Thu, 13 Nov 2025 08:21:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38AA38E0002; Thu, 13 Nov 2025 08:21:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A12A8E0008; Thu, 13 Nov 2025 08:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 149DC8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:21:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B07AA13BF33
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:21:13 +0000 (UTC)
X-FDA: 84105644826.20.38AB9D3
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id C4F7C40017
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:21:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L0nl3ruo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763040071; a=rsa-sha256;
	cv=none;
	b=piGu/tlhzEupgbjL+CEOG6U48L2zp+MRisPyQtjsnVZSCZKkplgjdShQDHVUw5qx6XSdI/
	SVts1mPout92uxqnyNK85FSPlA/gCTS1RG5Gzp7FeVbXPPRfjqG3b7qgpXW9aOWdNoxrfA
	MfxONsFHSpCkhNRxHV/kAP7kN12cNCU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L0nl3ruo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763040071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nGN2ZFcnSRaiVO+YExpr2QgITSsJwYh/DPnXCfgL80o=;
	b=mBFt6Zwi0Lx2lQCisBy8FE593xGlLRwySYw9jR9msmMAUXCNX+jTvGey9j34E8Wi8jfkal
	+aid3NDKn5FydpqiWXwVntzk5HIPoka0ks/Fs+SBA2enJtW5cvhFYBfYf7tmUyhUWmRxK4
	esykjYA7nvvmeWKEpLjrtDIpS0mb9t0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47776c366ccso508735e9.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040070; x=1763644870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nGN2ZFcnSRaiVO+YExpr2QgITSsJwYh/DPnXCfgL80o=;
        b=L0nl3ruoCHcDytYFlG0C2d0H8VRKrDuamwbXMT8qp1KOgzzR0LYMkac4rH4e5+S4Fx
         AKr31YdUngvINI5GFxX41ynzmb6Sf8KjuamNluoowyHLJorEF/9Q8hPLNNMWAv3286mr
         mJC/gmZddrOOe38i//g+sATOVgQ1X+3JzRpthdy1ojphnD2LfsiqiZkB22Tt1Ws3VEcU
         uZa/AleBcwUGxcDAXTaPLrHoxT7hgqc5RL5d8O2KS1HAwLD5sWvHmnaoXjVq7g8tIf48
         NO/OdtykCAEkasbqtM7Fheh0XjIuIEm1Rm9WpHW+G5aZ1BTwx3hIyhTnvyxG1heHCUjA
         G23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040070; x=1763644870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGN2ZFcnSRaiVO+YExpr2QgITSsJwYh/DPnXCfgL80o=;
        b=mpMoPc/t5FL6i1RPV0e/u4dFEqoWUq44o4FoGG8Pax7zfyySJqdq3qp80Jl9aoIbsJ
         kK12D3HNKDondU9MlwevKO7gjkt8FgvhEl/b3ZMCyFvLNEz9oheLVfo7BjuL0OuD01+C
         Dsgn2g/yLTsjSF63B2DFWCdWYh+sWsnljE4+2k431hGVt7PUHWDqNh4dh+bgoIAadmPi
         xKEbMDiHHeXkyi622q+GRrj39HOhwfk7GD2oIHgtS0SXa/UzYdaHTLGJ/y5LEEFDq7y9
         n9S8BY28lK1nWMSz4WJkZ/rvl0sWPrBRdcaqnhMv9SLksxPs6KcQNIIrzd7kCkO/I8DN
         R4jw==
X-Gm-Message-State: AOJu0Yx4OWTRwJGYqPBbt0n7sqsMydo+/QlM9PGku12Axv7lqmk43cGM
	iJ1Ju2nP60HaHquso/m393/OyG8cwL783UadVkSnnDc6ApyGl0IVkld9
X-Gm-Gg: ASbGnculCkKsgdrys+KwAdgkA4BwIeEFMqgDt+noQfz8ufxJHwaDy9XKkzf8cPczxY9
	TYZYxKyEWHJU2THIEp7Gu/JTE//CLkhae/lBiLDkIDCZtoBc4FeN7vlX0yEdy8ID9FKX0qGev9E
	PDxEpT8OcD+MikDZs7pgY/GzXadmQY0+6YcjjX0/JWYz0NMwhQw9h7ZP3x4b8LKZMsEnoutPCLj
	zNaEOreAiGvbdH1dzqkjt64iqbBEpLk69LVxeeClWMkHRJgwnSOzvsTfau98iHchMBMYJV5D4Xe
	4xr7acMGs13npfw19t/AckZUNp3zY42OyMEruaNbR86mRb2+9vq+5I3QpURbY6xCoUyIXmUMUbd
	fyDNKLScmXLU9q1FsmjNsKnqpwRD691u/+v/vwcH6K565ZvXivBYlOrgatzVFc2HTQWn83xh343
	69DCtP3Q==
X-Google-Smtp-Source: AGHT+IHlXVk7YngFwj47tCWravVebZ/U0ARUveuTel5lnc94KY28fXvMntNp7EdpGNvXfNWhmY9jAg==
X-Received: by 2002:a05:600c:3105:b0:477:7a78:3000 with SMTP id 5b1f17b1804b1-477871f4030mr35118405e9.6.1763040069752;
        Thu, 13 Nov 2025 05:21:09 -0800 (PST)
Received: from bhk ([196.239.132.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4778bcfc687sm19745305e9.10.2025.11.13.05.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 05:21:09 -0800 (PST)
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
To: akpm@linux-foundation.org,
	peterx@redhat.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: [PATCH v2] selftests/mm/uffd: remove static address usage in shmem_allocate_area()
Date: Thu, 13 Nov 2025 15:20:33 +0100
Message-ID: <20251113142050.108638-1-mehdi.benhadjkhelifa@gmail.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4F7C40017
X-Rspamd-Server: rspam07
X-Stat-Signature: x8a66ukc1rzsayrwe6idc9bnka4anxgo
X-Rspam-User: 
X-HE-Tag: 1763040071-767272
X-HE-Meta: U2FsdGVkX18O/W6hfri320xq6qkNCjd8h4YEN3mRfHr9H+vflwAI5Sg+n79/3hWy8GckdbuiMymWBiP+vTQRpt/tdV7YkYWrIZq7sr7u2+nFr6b8p4TIk/aESuXvd6bgxb3Kjv2yESNAp42OeUAV1k/v8tLKCw2YN/GVCzWWLbibyd5/aI394AuojbG5AG1FbzJMIFhAjLsYbGarHmZYKdfiBcTvyRuGK8Rah+PjCumHXpCeQTOtwe85R3C4/9BtgKk0oLgC80fJ8TJ7grIr7Wzk29+HJA2hURKWgHw9SkYaKW0shb30AJ0505B7ibSH1ZOkcemnd8g0fq87zOBvwyIEdaoa/Rmgge02/+choawkKtxw3f16JMO4f47vsUX5ufwkqdqDLjsXkIxO6MmPRpb9mKTBmk/Kh7VMmKWRbwMyb871EHAyvW5FktecIhHULVRtnLPpsJl0afVXEcvaDKVc+dbxkoe7cDfUktyl8rl8JPvzXJKJXdWD+80tJ9q9EiuSBqRA9KpzXQsrBBck3iZszK9c6BdsuIaAg3LaA/xEXW2bgf0k6A6IlY9tSLKmnFzBgVcY5qSyeAV8xjeVInKx1DPEJBN/bNL2PpN9TnR6kxr5z+jsBv6iIJbMwImNdub4RHxOSeErynlbCHEfhIuj53byb9tJsu1dnuWnqcj7fdoc8cBBmqxkRY0vcK/GDCQpVnggNA22lU4GuR/Iy1iOtlQtWpNgPiMAeSLlfJP6m/HCjDYVfRkLQ4QGH3m5NoHvJ9wxdUtY9At4mKh3GAVdo5lkt7aA4yZOZ9APw8OBApXv5zC3oTpIJxYsw2F99pi3fJYx8aYDtZuHQt0OTOQTe1zhCNQOVqCDE0HF38Ouk/2l2n8FnP946/txWM671IVVBvkOC5tJL0TGqc2S/VMp7P02AqKMDuCD7KF7/e+CTfkkUQo74J06y6MGI8Qf9hAgNrrRRmbM9jx9P7M
 UxRlwBro
 Oh/bB8MPHqemkxOk1GwDCnhZhU7HO0MT6SNSfEfDvt6uvIwENnaJ0g0BFiPil0g3RYdS1VYmdLegcFY+rIuvvo70nErnuvGAV5zfhLR9oZoa9pAKSqHrdNggP086Xt0V6J4Z8vXCZjr2XdXgpK92Xaum9fkdLucYQe0Glqx3wHTRMVw+SxHRheAg1GFPejHnnz+n3MA+UroYfDdQSjYxi6SVfCKjwa4A6ehtcI5mX6Vdr+Fy+K0MBdlxBXOWsuECFM0lDzcnDj3FlYMZKbkuKYxDdrOkcMvZ7+pDhKhU8FDGE61vMPWDu4qejuWdcL7gfnTvYGmJvzRt5BfhrT4blm7SsxcJM5cjT+xFjYp8KwPRp9pdACJYzs8Bc4TM96NCAPzKXRyKj3/j7zdYYtwgPqqOA/dYHsFrOR/0fhncZA9oj1k21zo4FABjDBJ6DbwEnNKw66KEcCNtQdymlmnvhc9G5uQ3cF70qHj2OtyNllA1ttkey8YsZ4HYsRtLpwq7nwVLxCLakrkqeN6se9b33EBeMUSJqT1WeUCFRBUaH7whFd9XYxwZf8CRDyEDzwVSBZc9mIsp3d6xPDTkywWIFXmrGYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current shmem_allocate_area() implementation uses a hardcoded virtual
base address (BASE_PMD_ADDR) as a hint for mmap() when creating shmem-backed
test areas. This approach is fragile and may fail on systems with ASLR or
different virtual memory layouts, where the chosen address is unavailable.

Replace the static base address with a dynamically reserved address range
obtained via mmap(NULL, ..., PROT_NONE). The memfd-backed areas and their
alias are then mapped into that reserved region using MAP_FIXED, preserving
the original layout and aliasing semantics while avoiding collisions with
unrelated mappings.

This change improves robustness and portability of the test suite without
altering its behavior or coverage.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
---
Testing(Retested):
A diff between running the mm selftests on 6.18-rc5 from before and after
the change show no regression on x86_64 architecture with 32GB DDR5 RAM.

ChangeLog:

Changes from v1:

-Implemented Mike's suggestions to make cleanup code more clear.

Link:https://lore.kernel.org/all/20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com/

 tools/testing/selftests/mm/uffd-common.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index 994fe8c03923..edd02328f77b 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -10,7 +10,6 @@
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
 
-#define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 /* pthread_mutex_t starts at page offset 0 */
 pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
@@ -142,30 +141,37 @@ static int shmem_allocate_area(uffd_global_test_opts_t *gopts, void **alloc_area
 	unsigned long offset = is_src ? 0 : bytes;
 	char *p = NULL, *p_alias = NULL;
 	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
+	size_t region_size = bytes * 2 + hpage_size;
 
-	/* TODO: clean this up.  Use a static addr is ugly */
-	p = BASE_PMD_ADDR;
-	if (!is_src)
-		/* src map + alias + interleaved hpages */
-		p += 2 * (bytes + hpage_size);
+	void *reserve = mmap(NULL, region_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,
+			-1, 0);
+	if (reserve == MAP_FAILED) {
+		close(mem_fd);
+		return -errno;
+	}
+
+	p = reserve;
 	p_alias = p;
 	p_alias += bytes;
 	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
 
-	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
+	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED) {
 		*alloc_area = NULL;
+		munmap(reserve, region_size);
+		close(mem_fd);
 		return -errno;
 	}
 	if (*alloc_area != p)
 		err("mmap of memfd failed at %p", p);
 
-	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
+	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			  mem_fd, offset);
 	if (area_alias == MAP_FAILED) {
-		munmap(*alloc_area, bytes);
 		*alloc_area = NULL;
+		munmap(reserve, region_size);
+		close(mem_fd);
 		return -errno;
 	}
 	if (area_alias != p_alias)
-- 
2.51.2


