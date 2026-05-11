Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F18CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 17:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CD26B00A4; Mon, 11 May 2026 13:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3EB6B00A9; Mon, 11 May 2026 13:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20F36B00AA; Mon, 11 May 2026 13:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFF4C6B00A4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:35:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47688C0FB4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:35:09 +0000 (UTC)
X-FDA: 84755839938.30.32926A3
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 85F2A4001C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:35:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=keK3lWxP;
	spf=pass (imf04.hostedemail.com: domain of 3SRMCagcKCM49BuD6u508805y.w86527EH-664Fuw4.8B0@flex--pratmal.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3SRMCagcKCM49BuD6u508805y.w86527EH-664Fuw4.8B0@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778520907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMFaYjsKt3zyNcL9dbclqKxgsJAOumGvBRCpsgs54Z8=;
	b=0iISOpmqQdfJi014J2hyvpYykR2bc2VFX2Wj20HtUedihMTRTMrMhxfuVdsXIoZJ+YH4Do
	XinDge3CPUtSMHATmZ2paokJ+inrtRX0TjO8sGVhKZiNST78rKOnBXlFTuryzfuxOJKrCr
	ufhkUdLcrOwasPICzJ8lS2bKGM/S4bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778520907; a=rsa-sha256;
	cv=none;
	b=de7wTI6eML4L68yMPvPKUsHnScjNuEAce6MDVCFA8hQN6zkFsn5F6fSP5eHs8c7B6/Zv79
	U7WZrVc7kdy0Xt4z3bYhXoGI1HKVtr2BvP0Q5ZeXDC4PcTCXb7uTo4ek5VHiTPh1FFgE04
	q6zhdyfa+gTOsh/sC77R7OOTsM3Ntqg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=keK3lWxP;
	spf=pass (imf04.hostedemail.com: domain of 3SRMCagcKCM49BuD6u508805y.w86527EH-664Fuw4.8B0@flex--pratmal.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3SRMCagcKCM49BuD6u508805y.w86527EH-664Fuw4.8B0@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ee5b73c5f2so4978454eec.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 10:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778520906; x=1779125706; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iMFaYjsKt3zyNcL9dbclqKxgsJAOumGvBRCpsgs54Z8=;
        b=keK3lWxP/U+lw+Ihje9l/C5SVe6s6HBwde+ONjzbOCYknT1EK3k0xwBX1/HYbq9XJR
         s436PpR040kzGHHv57HKmrRPhcZkfSCp6/U7IiDKgbvC1wtud39olpkxhukUxY1ZEuii
         /+IPEvx3kHIHoN0+CqPl8rXTkPjVOcgCPt+3VUyRZzuA/GmOTCBee0KmYsNfDV6RTrNR
         EHLuA63rflv1wgeXUbuYsxdjTN5cpzR30ddxDlHatSGvEyhNRMjhILPFw8j1Qwula0Wj
         0Msw51VYhd4mScyf30ArdCRjblc90P/B5kRYUm9sJabxMupuu5Gm7aU2NZ4EDeZw9UKh
         L6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778520906; x=1779125706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iMFaYjsKt3zyNcL9dbclqKxgsJAOumGvBRCpsgs54Z8=;
        b=D4vlEsi1JQhIGIBDuQnIXkTk+KZb70i4awFI0CTuNMkRYMH+cvX6Pzg0opf0VcI0H8
         MN7DuecNUxMEQgauujFSkhOpItc6i5WbQlN36XtdwVLjgLvPN6hTKUHXiQsBux/EkYp7
         TXkPpXbCI+o3COIyikbySjCEXcB502fEKpxoPme4JdvexLZJ4pi6N+OjC1j2n6+O+9bl
         ZshhNSb+PITGZhBfJbP9sp87qkEm9l3N6WBU1jyKO3/0JvsGDIPyOapKxqSg25TI2WhV
         Si6KYk0V55FakFwg56AfDhlTc/LZFa/wLJPfN++ULe2BZ4F1LUiLS5KA+PsPLHKg0xIX
         OWIA==
X-Forwarded-Encrypted: i=1; AFNElJ/EG2Uq1IVJQGZUZob5UkebDrqGVw7wQ3RJmZ/w1hXC5ji4Nwosa68Wh2XpqDOgF4BqiE70S552Sg==@kvack.org
X-Gm-Message-State: AOJu0YynN+XFsJS4R24fi9WE5ph6BHil9efNSYDqgkO0NOvKLSaGkmAf
	ZfGQYsSFEla7oyOZ0ywSfwkOGHtT88zKxPtjah1kUSzdL+F9vu7OTLXOR931NyrbXoHSatx/te/
	W6ndEJEI8zg==
X-Received: from dybvv23.prod.google.com ([2002:a05:7300:f897:b0:2fc:f65c:1e7f])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:d704:b0:2c1:7b61:8731
 with SMTP id 5a478bee46e88-2f5490931d5mr13087576eec.10.1778520905905; Mon, 11
 May 2026 10:35:05 -0700 (PDT)
Date: Mon, 11 May 2026 17:34:10 +0000
In-Reply-To: <20260511173411.267628-1-pratmal@google.com>
Mime-Version: 1.0
References: <20260511173411.267628-1-pratmal@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260511173411.267628-2-pratmal@google.com>
Subject: [PATCH v3 1/2] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: akpm@linux-foundation.org, shuah@kernel.org
Cc: yosry@kernel.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85F2A4001C
X-Stat-Signature: i8grboeuc89q59385e8iga47xwjqjkz4
X-Rspam-User: 
X-HE-Tag: 1778520907-504150
X-HE-Meta: U2FsdGVkX18f47FSlSEUYSa4pW5Pj1dxGEDKTeXUrnQR56lBIhnSrgM5JWRoOkfyL29gSp7VypnnUpXFL9LkavzQ6rOgP7M6g1T9QQO/eWHDBJOQAFqyh46bLUl8eHhpPctQ191ksOnbNy/EzXC2KvgK8dfv/xTSop8Q9/VweJWnLAxpBhKPO2TV0bj21HfktRtgLkppnDhHZnLeI6R5z8dykj+BHMs/yQWDlzvh2R4qmXqxsKfg34puoE6E7F1zayO9T3HMBjqnna1flr6fNnnGnkKPIFFguOT6L1Y/stWYgdQJYflEQVVFKRiA6rHt7IRyctzpH3T9zeFh04T8kZR9aZ3TvkO6YC5htva4Gt8/DL7E1RxehMv1xT3XNLt+8JxVdASKALNkG23kY05DNDkoJgLKF/AtvvkQkaIfdsSN8I5dAAd64oYdPKOI2WD/ubWEQ6+YqA1FHtwzcOa2o/aG4PzF09IgzTAYELVyQv41O8QtRGIrJt+R1A703ELD7IRktAJOh10Lp4E8ALDYlomPH3IqjqKdo2Kk7OrPCnRU/oCU98KTNEuo+LqIfimzU75BQkxP8mPYhJho9lo1mOTI8GMPZAgH8cmkwfuxCcXKLFRHxwziLMvbtMWno/Os7wUQliO2164op1X0pFv9xwmvQ6k6dO0FvOycAECF7v4jeSvsJnvp9/QjmiwssIqJAVSozbdVjxBMRpxQNk634XiG0FfJ421BFlVBy92yLG8rQ+yTvqVgPSce2CweLaTaGTj+CMZ0GsBOPbupe4rcMl3tgs7v9Pupj623OTjhYphSH30VpuSafq7AvjjHh6wCYSHT7NwUR0/Zhyr5r5etks7eGBSrt4X0fmNTOrgstma/2lORjB3A3BplInKu5xZbZlqRt1F5Dts1pZIJCdt+Q1PgLUIEOf9QMX9Ihwlvj/BJrCzS4t0BC/g8GSWBAv8cY8SFs32e5Nf1LGogDxT
 Y8zZ82uW
 PkVuu+gePDeBlr5dQnasmakHnnfA6YaTz39U6QnBXHRnImrO296fieIvzatf9uaY5OAaqGTVxJa46qZv9KWVAIJvUx/IQcIwlIX2ENtOpPxqLwJfGfP5Me+1st0nOtGQ/zmmqpBMqKaZCl2jzjTWcv9shXmWkT7rwvpZY45sqgJpLKOWMNX8hsulDPpK+JFRaUdBB/s6MXZk47TjEX/5AMHYy36xR3HTLBmS/YFqXbypHkOsuzGSwQB23hpLbLlVicRJ2W9KID4A2jvVkj7olMM2XO3QDa6yGchwwecxm9t/Ln1MBSjsfzW1V5b+HpeyohRh64yikBr5PTd87VaULMMvk1KlqQlax5kbi/xNoQN41qamipeGM+aXfWtv5DkB6W8hHINILgLBtU6YoNDAiyuJuQpl/7teY1Wfgl2KiCsAwMBc0l6JinagFHhlbSCyA/mqZMehgGT6xLOnk2j3Klt3fIDP2jhVAGgsW0xF6dc8IvObQXJgs7lQX8USdfea9NEerpg8iZRdyH60rtJK34lHs5OCyFC7yxvjWi65aBFl/uQnEF/afmLnWiMXrqTatb2tOdQCnGCOCjWHtxfP97FU5cXbGdhyFfrrwSbJdpCz5ZuXgWqMfsglHRHm1/Bi1BAbsBuLSzuGv3LG050sxSWWO0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

The current .gitignore hardcodes each generated test binary by name,
requiring updates every time a new test is added.

Switch to the patten-matching approach similar to KVM:selftests.
Ignore everything by default and then allow source extensions (.c, .h, .sh)
and tracked non-source files.

Note that un-ignoring *.h files causes the generated local_config.h
build artifact to incorrectly become untracked. A subsequent patch
will rename this header to resolve the issue.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
 tools/testing/selftests/mm/.gitignore | 71 ++++-----------------------
 1 file changed, 9 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 83ad9454dd9d..fcd892ed21e3 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -1,63 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-cow
-hugepage-mmap
-hugepage-mremap
-hugepage-shm
-hugepage-vmemmap
-hugetlb-madvise
-hugetlb-read-hwpoison
-hugetlb-soft-offline
-khugepaged
-map_hugetlb
-map_populate
-thuge-gen
-compaction_test
-memory-failure
-migration
-mlock2-tests
-mrelease_test
-mremap_dontunmap
-mremap_test
-on-fault-limit
-transhuge-stress
-pagemap_ioctl
-pfnmap
-process_madv
-*.tmp*
-protection_keys
-protection_keys_32
-protection_keys_64
-madv_populate
-uffd-stress
-uffd-unit-tests
-uffd-wp-mremap
-mlock-intersect-test
-mlock-random-test
-virtual_address_range
-gup_test
-va_128TBswitch
-map_fixed_noreplace
-write_to_hugetlbfs
-hmm-tests
-memfd_secret
-soft-dirty
-split_huge_page_test
-ksm_tests
-local_config.h
-local_config.mk
-ksm_functional_tests
-mdwe_test
-gup_longterm
-mkdirty
-va_high_addr_switch
-hugetlb_fault_after_madv
-hugetlb_madv_vs_map
-mseal_test
-droppable
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
-guard-regions
-merge
-prctl_thp_disable
-rmap
+*
+!/**/
+!*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
-- 
2.54.0.563.g4f69b47b94-goog


