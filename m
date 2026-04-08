Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F01610F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAFD6B0093; Wed,  8 Apr 2026 13:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175626B0095; Wed,  8 Apr 2026 13:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AD46B0096; Wed,  8 Apr 2026 13:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E69A96B0093
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B439EB6D9F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:20 +0000 (UTC)
X-FDA: 84636067320.12.A1CFFD2
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 105BB180011
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E76hhmOx;
	spf=pass (imf24.hostedemail.com: domain of 3uY_WaQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3uY_WaQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coXWpWCJYRhXsanWDc3UBlYfp3L/GbnMTag+lQMZ4EU=;
	b=42GHXPL1C88pDIOgn7shXjw6fHHNrqqgW3yofmQPmrxAPHzkqGkLjp49JZuVTdpgKr7cIM
	cS2OdIqfulJnxIwN+Ead4sgzkIPQ6BHRkdKtQimBOh195Guf7N8QGjlW9SQjEHYBUNnvke
	Jf7B+I5KjwVOzdATW2wevSlOQ5s95hA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E76hhmOx;
	spf=pass (imf24.hostedemail.com: domain of 3uY_WaQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3uY_WaQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669179; a=rsa-sha256;
	cv=none;
	b=TDp0/V5UCjS9jUX6Im4Oag9uV+6b9vXF118ZbjQaaA9NFRS4An28rAGP7B1p2n1nzY7mz6
	PJebK6ilP8DpZo8+i8P0wMSOQTJXE5euj5B5J14vYuhZkR82JTR8o61vgrCIASRIV2mGGW
	UtFIEFNsnvrq91DJOvh9pU4Fru6zfjw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354490889b6so161120a91.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669178; x=1776273978; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=coXWpWCJYRhXsanWDc3UBlYfp3L/GbnMTag+lQMZ4EU=;
        b=E76hhmOxCxlnDvFJigAo7nw0Ex1NyqTCi41/hfcs4bVpuECmDoGrXJHX38LaTNPTpj
         JoQiCL321w6M1UXCl8kFzRFJwFl55lo4zBbSpYhC5wUrFpP3E5NWE+ouy60wVyaIHqMH
         JI6M5dy7Bluz/WnU8nNQ5JbyD6uJwTwaXM4TsIdNtGkwV8BdOR73OIy4uA42cEOu0oi1
         z8i8IUj1B2uHB6I7GeaNPx2msM/i2jsaXAR3xRV5F+aWNr0TgPgfGBp8T0BjZVDbst01
         zXGxqKx6RxJ18tiuyoCET4AINTY8nA/E69+2wxKvhtQnAKHVGlOtyc94ei7h4pSRHSkt
         gxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669178; x=1776273978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=coXWpWCJYRhXsanWDc3UBlYfp3L/GbnMTag+lQMZ4EU=;
        b=OKjFQk4eYO3bE/vsV8Ob6xpbfi32nymt4cjUtPUfqLyQnP35/ajnLYJISp0bytUIXH
         BHlSSZTsEHutPfZqfqJ5cRISTZfjkDGNF9M7zvqYgIU0amItrzKmfa0BJK0iHDm1hMnY
         fTlaUF8B2SRFlzbr+Paogma30Nxv8CCO6UyESXLqncqu/GuD9uxwgueVcbWr9oC4KhZg
         8FZK1QeLCyN6700fxwc9mWqUK9yd3L/uCEztvDXzk1HYhKT9plJ0iwqp2RFQYOM1v6sc
         MoNyBc8Agky565aIO1mgvpquFieR0njBPqum/czcfy3HI1yJL8dP9XNvw8/r6+mjWXsC
         P/EQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEMuS0GQbx3fusZNnj9qXI1evUafI6b9l5qybRLDZif+UkxfBlngsjkdup1x2coiO/E7HpGdYreA==@kvack.org
X-Gm-Message-State: AOJu0Yxfun+567FpzPGGZuk+LdTjILZ16ehjaRoRHtsHX55XxoYPvvau
	uz0SIibymjvV4wcKnMiOqbEL8DMI9f0XEqbPU1U5nnqSkiZQiAujlHUPKxMIRt2QkIjPoIQBI+u
	TLivUqA==
X-Received: from pjbcl15.prod.google.com ([2002:a17:90a:f68f:b0:35d:a03b:ab5e])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c3:b0:35d:a861:36de
 with SMTP id 98e67ed59e1d1-35de691b394mr22211390a91.24.1775669177699; Wed, 08
 Apr 2026 10:26:17 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:46 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=4632;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=9j+Yjxv5DCIhDgqhSAFcOR8cdCu2/7Gl8VDuHjhEuMY=; b=ZLj3IPnlSz73RcVt/W7CdlvSDsYMGQCljZ+P1jxfdDIyI2haYYqfl7EVXP3SrZ7hpSAi0brzc
 aAD0ijgQuUJD3pVUZ4XpVhZmt5xnWRUQ+TjBbKyJ7ygMxyHCoLl8kxe
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-5-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 5/7] mm: selftests: Add shmem into memory failure test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 105BB180011
X-Stat-Signature: b5z4hgyxryyhk4zxw96rbt4d6fnwitmn
X-Rspamd-Server: rspam06
X-HE-Tag: 1775669178-863683
X-HE-Meta: U2FsdGVkX1+URwfmFPSpHlZqKVebzDA0sW4+8HOJX/6FbrNWavR3abziOcOBKurCtQ8Xm/9ewEoW15YVyL6hB4Ke6IjPeWOd4QvlxPBax7VSDZ3M78ZOq2D+KxV9EslEIop3Frk0M7Bu3VHYCy/X6GEVJRltYOXGYHAe7n0tjKDkxTzMJWXXq9U9bxeOgoo8Lb7MQKzO5XM8stNbyl5m07IcFtN1Yv0OV3E7IMLQO/P2YEjZeM/JLwxVhIXD/ihz9wRdYauyWUPjMPN2MFuYHlSZQnQIDzLRGh3wNLJITSdncA29fluMdqzPnCXMGe9TsMp9whBzeOFe77n+bQA2rfhkzpseSO8lSL1GkB8lXLUAPaHPPp2ilT/xYpT1Ya+F5HRmfc2m7a4YbjdCD/mbx9/+cZiC5WTDhziZld0gQEolbqC73Ln3GEiTwHkHsPLGu+YoCno5mdTZIbX4U2v/JfljWq/rwJ0K50nXmB05FYccE+0pCPkT6eMXZjSCFbRpYxBbm7N3WKJ5IJaOVdj8NvB8+HLC+VUKee2AvZsiPPfTADu43rqv+JrfMPyDNHqj7TcIV6x5OduG0vMw2rRHZF5MSQzZ0PA5Y3uuU2lC2GAhLlQMcEq65ycGSbDkuXVTJhZDxOm2xRXZzgEUyKOPTBeqGqTKHNzNMPAPRDGHDj6dLs3dnI2yptocHAXusF5CHTKTVDqN/9tj1em59PzM75fkRo0oPoq/SVBPTbp2JP+D6e8wSKNyk+F5HVNPmFuJHHHTamXLqt3fSlFNQgwIiyIHbrxQWbk8eeoHeHwQQ4KE1sBiomuI0uN8YV6W1qXINK5c3ySw8B+XHky09mt4H+6jsXIF36fPmOCVjHkjzHMe8YZbDh/ryPTrUEU5yPagGRqFSY0FPHE1qS5Fru5An140WaSIdsSajiwR7jKfabn0wf2is3/BPeoWhHjjiop2lL7DbAAgi1YZYjI/1ww
 7/j/QGKg
 60hoK+BBHOdD0PsuV+/C/BPy6y3YpnHeN/6iwfsw68iCUkTu5McOp2Jh4AzJgmVYxGPgNE4dPCVQSOVPxiC1qPHXQQjQSA4GKYMWPJX3nB6PNpFeoPFcOg53wLzfIYD3AZmju7aQptFYmgYMs1p8r6gXRO4b4ZkfDGaRMtQM0d6qF0vR9BMJ47bzCST10FS0g6zLUthAJivn/uq5ht8KjMgzPKIgGiHKPJgiBPVofc/POQ2rk2BfKBoitrf853HPDvhQwbqS+KE7sVyoP0MiLZQZs++EfL430WZGUa5LETtiHtv+YOmSArTGarLb8JleRdjyJb4ZC/+xBFeRNCSREVdxdo6s8Zx4vJb4cnk7GVKkmG/MfDhLWdf6aMD1RY5S1ptNdK10mVll3SoPG0rYLJVnyIQ6AopsOtWRP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shmem memory failure selftest to test the shmem memory failure is
correct after modifying shmem return value.

Test that
+ madvise() call returns 0 when the poisoned shmem page is clean
+ trigger a SIGBUS when the poisoned shmem page is dirty
+ trigger another SIGBUS when the poisoned shmem page is fault-in again.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 109 +++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 3d9e0b9ffb41..eb3f8d98f6c9 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -30,9 +30,14 @@ enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
+	MADV_HARD_CLEAN_SHMEM,
+	MADV_HARD_DIRTY_SHMEM,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
 	MADV_SOFT_DIRTY_PAGECACHE,
+	MADV_SOFT_CLEAN_SHMEM,
+	MADV_SOFT_DIRTY_SHMEM,
+	READ_ERROR,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -165,17 +170,21 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
 	case MADV_SOFT_DIRTY_PAGECACHE:
-		/* It is not expected to receive a SIGBUS signal. */
-		ASSERT_EQ(setjmp, 0);
-
+	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
+	case MADV_HARD_CLEAN_SHMEM:
+	case MADV_SOFT_CLEAN_SHMEM:
+		/* It is not expected to receive a SIGBUS signal. */
+		ASSERT_EQ(setjmp, 0);
 
 		/* The backing pfn of addr should have changed. */
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
 	case MADV_HARD_DIRTY_PAGECACHE:
+	case MADV_HARD_DIRTY_SHMEM:
+	case READ_ERROR:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -260,6 +269,20 @@ static int prepare_file(const char *fname, unsigned long size)
 	return fd;
 }
 
+static int prepare_shmem(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = memfd_create(fname, 0);
+	if (fd < 0)
+		return -1;
+	if (ftruncate(fd, size) < 0) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
 /* Borrowed from mm/gup_longterm.c. */
 static int get_fs_type(int fd)
 {
@@ -356,4 +379,84 @@ TEST_F(memory_failure, dirty_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (ret == 0)
+		ASSERT_EQ(variant->inject(self, addr), 0);
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+	cleanup(_metadata, self, addr);
+}
+
+TEST_F(memory_failure, clean_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	FORCE_READ(*addr);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (ret == 0)
+		ASSERT_EQ(variant->inject(self, addr), 0);
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_CLEAN_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+	cleanup(_metadata, self, addr);
+}
+
 TEST_HARNESS_MAIN

-- 
2.53.0.1213.gd9a14994de-goog


