Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8AE9CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3682A8E0008; Tue, 11 Nov 2025 14:58:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FF58E0005; Tue, 11 Nov 2025 14:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E888E0008; Tue, 11 Nov 2025 14:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5818E0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:58:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A253A1601CF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:58:06 +0000 (UTC)
X-FDA: 84099387372.07.523B07C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA7361A0004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:58:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JD5LAdgh;
	spf=pass (imf19.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762891085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GgqlcdicdOlvJS4d4lOKT+0mM+91PtUwo1QhcetW41s=;
	b=7NUTp5cWqzrP2WbWAAJZ8X+rT2rSRbuePk/8CScZMwQVyAt3Szb09nSLi2RUp+XlQdIBNL
	NcJ3lDRZvs3ZGnxOCwhB4LQP+W/zZB06iTPBxD/M29WATGFKhfnKBE5uANNau37mIo7Vp3
	RMWCbWoYU9+nSljWNqFY1LoVX8AVOvs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JD5LAdgh;
	spf=pass (imf19.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762891085; a=rsa-sha256;
	cv=none;
	b=PWdyPhfElNlf5SH3l3hUDz/LDGvH3PFE/y56L9a9jvDiTDERxTiwQoKFpkkoyC/mdcIwkp
	plmZiKrkNPSwNK9LF1tJFIxx6nuZh5eZzM5p5D4rb1ulE7SDZrm7JWULZ6qGyKnVBgqjYl
	4C7/n0AEO7epL5f+ZBSdOuIh273jowM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b30bf0feaso5862f8f.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762891083; x=1763495883; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GgqlcdicdOlvJS4d4lOKT+0mM+91PtUwo1QhcetW41s=;
        b=JD5LAdgh3pUmv8I8JLgZuap84gxAyUITG16iSUzNOL9nGYjG0mPsKqL5uwnRfRxzlu
         uKA4gdE/QxOLLR27bWL79JgepNp1du2np3RdBruUU+tLRK/3o4zmlFwXW/KgkeguKeUq
         uX7lZyyFoI/J1Z8Jxg9tnp2r4Qcxw62E1+MZEEBzve0T7f+vthoLh8wp4cQbHTrT4k3w
         ntxR7GjZs+VlQ5k0LP8KlaMPPAXx4+/ScGq0X/bp75E/iXpVzLhByNihY/rioSAxO253
         K3XoMX6t/x0Ntj02d5DLP35NTOMUVxRMmQBnw4YMW7C25P3xWSpO85R/UqkFpcYiyJ/G
         Nnnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762891083; x=1763495883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GgqlcdicdOlvJS4d4lOKT+0mM+91PtUwo1QhcetW41s=;
        b=jcGK81qc01t/suCCz/RfVQju7NWfp6y4HkjMaK7psoRE2tTNGUVny1Rl9UsMyHf1M6
         W6HN4gNn+Ofhvx2pD7eixMcHkbHQ8BTsZRc5G/RSO1CUuG8UvGfMR+My1Pn4nm3yd1xi
         KtfIpFWJB6CiifhQskzuvAoWKbe7ONk1R+a2DfX62NumTadZsuGW0BKIPa8FaAl9hbvd
         l7IRY3WzTUkiEsOjtbuvzHG0hKmMM1FlUSY8kK9c/4EbVAe0vG4Em/nhHrYYv2ZwGag3
         XjHWZTUo1U5huA2Z9UYIWQLBMWu2zk2vDtUKtlBtxdqrGLkf1HRU5FIEzwA9N/g+Nb+N
         +YRw==
X-Gm-Message-State: AOJu0Yz8uPKrfYZ3gdiAEtCwrjA9YnKNc0fUgnwJXBCBxTHY4FcW8YOx
	i/g9xrNdZbX/h2yptRBCXijtK5IhcK2jMEE0IrKSFkIs6SCSvcah4e6d
X-Gm-Gg: ASbGnctZnqOP66wo7kdnhuICjfyqhBO0Fdlqp9AjHT+3IGRSimdWcXoaVlOlP6EzMBV
	CyPLMQvbKtWiRsn2O1D1QRhbVt2HAvoydxk8aaXqJuMiOP6UH3RAAXG8vryZkpbN6sQdoOwb3OH
	m/QmdUnPxvr9M88yn0BN+0evHowHglUGyZ8fi34v4thRmAsbGGasnAHs2Qz2dMDipa6dOxsFFUE
	joPUtIHZw3UKWdBVYN9rn3RCxseVjI9vh4f/EJg/itQe8MPGwi1rCEZWQ+RxK+MzPaCluSwJaIT
	RL3pyU3lFjnTrKPdwKyzCs4NheG91UiNp/dRZgnyOHtWQdWqc0sK2arm6NEL59WUOjX7A7Z+6M1
	ZgVwhfEuxxfM6I081OwsIjvYmwEPQTq76MUPwAXMG5XLzqVpEbCeM85VenvRwbSzoM0xsdSzUy1
	UmOEgizbQT6MaeulkXO9cG9rLdBSs=
X-Google-Smtp-Source: AGHT+IE21rOv3E/xf61ATIbFY5zukw0tfOg7SCkZGn4ZrAkN7p8psKMVSUEEhKXeXEJZn8Yww8oxyA==
X-Received: by 2002:a05:600c:4f54:b0:477:5b01:7d49 with SMTP id 5b1f17b1804b1-477870c9a70mr2783175e9.4.1762891083060;
        Tue, 11 Nov 2025 11:58:03 -0800 (PST)
Received: from bhk ([196.239.144.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce211d8sm405969865e9.11.2025.11.11.11.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 11:58:02 -0800 (PST)
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
Subject: [PATCH] selftests/mm/uffd: remove static address usage in shmem_allocate_area()
Date: Tue, 11 Nov 2025 21:54:27 +0100
Message-ID: <20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA7361A0004
X-Stat-Signature: dztjw54rynum5g8mqofdhw7pqasy6438
X-Rspam-User: 
X-HE-Tag: 1762891084-741448
X-HE-Meta: U2FsdGVkX183ICqiyGOT6Nv6BdqEK2kpAFLBWsNf5/Gxe2B366CIvLGPxjWDh5kPzf/ZVZb2d55YWy6Pdfz82JIzxhb9v4/ubAKkhBHZvsZ3M0gCZrkZ475tT5nDiFlg1b8VjT2J0MqhGXVX67N+91QFkC97jBLINgB+CqVxTY/U3GcvHcqfo4HjqJ6HaDOnpN2d5harIbX9If5mnO7KhRc0vsTKj1MEVo06vT8qWrKRCTCrvbSxypk5gyuFj8alQ4xON6ZStbpAHM0pVQriHA1pWANteCve1dYqbUgbQdd0/WtaPi9LQ4TtRQrvflDi3Ktcg/SexPm1o7JES/bQoERfXrf9v90qcoKHMiOKQBFnjj1RZVlz4Va98Jo6FOSnRKdFONjAKXswo4Ma0nRkuG5OGhWS4TIj1WMj02Gm+ssv6ZTXVM7iq6FXJNHmOZlJo1Tvnq/+5vrtBu/6e1j9KB3awGRvK7OpuyUBzjsChDms/RblUZe/M2WbrlF1d773zR2CVtTb8D0j4xLtEauQjQ26cm1y3nqAYDGmLGGzUxZc5wY8dGjcfeDZhNvq4VhKJNi4USUdSB+qmx6CvfP3FhX4CqG+Y8hkFaQyUMDwItM7Q3tdmHvGyF+NskwIIlf7burKTrXqpjJHlYKplPuiDxwB2g5gaeoCT5asmL6uPQzA4CijsyPlGvRCvYN1cTCNxpRxNWQuWCatGKrZPOMit5E9mAX7l/I/e+OA/8wmrjHWq9nbkMcI/TqqNrT8yoepqYJuxdcCU6cdtjK3rIxErve/UDSHWTaJhaFTc5gq8awj98qnZ/uZKnO+MoOXps9xlmbVVrKOqDCkkcn00vxfyGsuBaJppBGRO4psUpcAc82+6fv7teELRFstz8N1Y74Z7OyxmHZUdqQa+3+tqdYK2RKupSCa2l22HkhV+dtLVF8+QtaAhtMcqn91p3dcvT/wSwWtvGDyMpKYi9Mz+XV
 NLn8faem
 b1xyrt8l19n+dfvJDiGtsJobR7xy62ho02zhOW4fUMTzG1BoqKY431H4YNbWkiSc1ZIvPQFfbL6L+8lXmxLR74mvTOIiiSI9ImXF974p37OoQbNrpLjgmh0hPTWHG820DKt6pYgsWG6qWzIHKXD/T29TteQfi5rEOb7sF43zkqFH23hwYyiXX0+cM9rVX39AXF2tm64LKaHVvXkygRL0jhe/HEIgMf53xclrsOsx68GLMQwR6q9ovFOaEzyphLzy5iSq4GQez+aq+aqcB1PHoZKfLYBbTn1s0QuQoQO7Ftb587xJQ6pXE/8lxQU0jwrkRGSRqlDh0wHcxjxua2XLnDP86JVUp1WtUwDReDXvgp+2RUi6EbW/PcV7Ksyfqiby5Wco3UuzEa3VswFXRpjoOwKw4Wi9h/h0mkmUgW43otlKPSoRncE5qPKZPzh9RYDJIh7TQdTvhaMot5mTeBINkYApWmPVeWIS5uLHB1Uedg1ChADkgZJoHqIKIRvkjzYbG0tlj5LRxjtKqQmEavJFL1AhcORfRdPj4ia7GNIyEa6J+02WnAqHgFqptXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current shmem_allocate_area() implementation uses a hardcoded virtual
base address(BASE_PMD_ADDR) as a hint for mmap() when creating shmem-backed
test areas. This approach is fragile and may fail on systems with ASLR or
different virtual memory layouts, where the chosen address is unavailable.

Replace the static base address with a dynamically reserved address range
obtained via mmap(NULL, ..., PROT_NONE). The memfd-backed areas and their
alias are then mapped into that reserved region using MAP_FIXED, preserving
the original layout and aliasing semantics while avoiding collisions with
unrelated mappings.

This change improves robustness and portability of the test suite without
altering its behavior or coverage.

Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
---
Testing:
A diff between running the mm selftests on 6.18-rc5 from before and after
the change show no regression on x86_64 architecture with 32GB DDR5 RAM.
 tools/testing/selftests/mm/uffd-common.c | 25 +++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index 994fe8c03923..492b21c960bb 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -6,11 +6,11 @@
  */
 
 #include "uffd-common.h"
+#include "asm-generic/mman-common.h"
 
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
 
-#define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 /* pthread_mutex_t starts at page offset 0 */
 pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
@@ -142,30 +142,37 @@ static int shmem_allocate_area(uffd_global_test_opts_t *gopts, void **alloc_area
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
+	p = (char *)reserve;
 	p_alias = p;
 	p_alias += bytes;
 	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
 
-	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
+	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
 			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED) {
+		munmap(reserve, region_size);
 		*alloc_area = NULL;
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
+		munmap(reserve, region_size);
 		*alloc_area = NULL;
+		close(mem_fd);
 		return -errno;
 	}
 	if (area_alias != p_alias)
-- 
2.51.2


