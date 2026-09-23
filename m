Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBEDC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8236B009E; Tue, 22 Sep 2026 22:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78F46B009F; Tue, 22 Sep 2026 22:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98EE36B00A0; Tue, 22 Sep 2026 22:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 799DC6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:31:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0607F40672
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:31:44 +0000 (UTC)
X-FDA: 85243451328.13.6D3E229
Received: from out-2z4y-a153.jellyfish.systems (out-2z4y-a153.jellyfish.systems [198.54.127.153])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31157C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:31:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DQ1m2Cq3;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf22.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.153 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=atpMB5sAObGBHnnZwrOzoT8hf1VnqLifryohDjX8lnw=;
	b=W5ywuP2DYEHHk+dx1sF/ZhAG1njTF2jHU/YScxve6aIej2H8Q9BNqQF8uQc/P4msxfzszH
	7k15t1OuEqRx2O3rQm+Lh62cvgQ0Y7V3S7ZL+ytGsRb/ZToC73M1Dg8GrE3cnh08CCMTiL
	yB+PKvQeLP4O6jLNB2ag05VoB/mIPuU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DQ1m2Cq3;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf22.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.153 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130702;
	b=fnRF5ke1t7Tz95nqYatXjvA7GWiwuJUH7nIwlvjm7Zay3RM0TV+nF2BcjYvmN3rbHzdoRc
	UROc1tQCmOyExtcI+AzR3oFpssUs/htllVRQMQbtESzEeQt3XBvVJsUw70bRrga1zpOKWE
	U2Sk0gExdikj4xtUZrcHqD2hUwX2VRo=
Received: from fedora (unknown [120.199.7.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqLZJ3fkcz8sYH;
	Wed, 23 Sep 2026 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1790130697;
	bh=atpMB5sAObGBHnnZwrOzoT8hf1VnqLifryohDjX8lnw=;
	h=From:To:Cc:Subject:Date:From;
	b=DQ1m2Cq3mutHCmf62FSW3M/unrd1lwHkBQARS34Crz9uY49SCD15QOhS9fI975POz
	 kFUV8asMjEoSR8PU6pJIcBAuXRpW6+B96JcoFVSmZPS2TbwSSK6eZgrTNVFjVnpGMn
	 15YWHFNgN5s5y5N+xRr55hL75j/kKUrMkGvBYhrnu9WdEM89ixC31s8KmbCsG3tEXQ
	 U3yW6+nNQEsP5WAOqp8VU+7Wzc3/kkG5EUxiiMB74y75dnbtJySeOAoA9/YaglZstS
	 wZ6q/Y+dIKQJE3PsrXY7IBAO5/QOiW7jugWLwpkHD233D6C978J81S4H31EIQLyULy
	 s/jqhLWjiwYtQ==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] memblock tests: fix BUILD=32 address conversions and warnings
Date: Wed, 23 Sep 2026 11:31:22 +0900
Message-ID: <20260923023126.1910311-1-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Stat-Signature: po9d8u8qqwtmkzd1rifmxrcuwh7rbtpk
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31157C0004
X-HE-Tag: 1790130702-96851
X-HE-Meta: U2FsdGVkX1870M1vPaRPL2bR3LsQa4bGYLKW8rdNV3jwuA3NXBodvpQNZaKrwCWhXe07rFh/6UlY/R4AALpZE2+lW5APmBwb77hcbM3viF072R2/HcL7AUQwKddK42kM9+GXT2A8sw3Y4IYEaswN/+kWsYamNjHOjB+zNbrXHDzaM6PvOjFMENbgM4x8MbyWCBp9faokSRmcA40xLeLWi4+6rUaTki+aj8ofClFzDGT764DfI5XcGFNq85S/KuWZVOHQsL4A4oK/myZS0bsbubMAUktYZPqzoXMekLJu4Ef2Gy2SpIAfAbv7xzmxyljPuLUtMA+EskrPPd2Byba+WZhA9JY6vC3dfOegmLD3dIFuwgbjKt8INHeBodtfy+QJWIm3M7TluCx1+4Zc4ThmE5pjNLbQ0VRE7JN8StZh/r5dJBBxiocDjZOcMVJuScUBQExgVEYoahuBgj0I5+x7ytBj7u36FcGj1kMhXcaKlkIjvfmeNrZmO9CHiaH5sURD+Qh7R5rlWEx2Ejmeuc9njdvZoRKimANxLVJth7y5UgxPlWhe7Qgh4u6swpzV0LY8y8tsT2WhmNWiS4EDTJEUcrGXHy3ACFOmQ722wpyHg7dL60W7Iq/WA7vSk/6MkL4k8Lq9Zb5BXLMEy055C6sTNhY3OyW7BHsPJlOD+vxco6JQCgtODaagsB2e8PkZKAcApKXowcCW06Dqbi3mSe27XvM5FTtqYkhgt37Dt9rl8j4okPHMGvD6yMUwwOP2krFP6UVveJhJsqD9EtCv+CQLo5rjzDvbMN346VibvBmqz3SLGWWU3WRqVz6sBWEcrKKYyj4LcJx4GDiwebEKwN0B07EPo3c8PuSTM/+2Mfm7hRm177v2a8LbvFdjwx16snMYHnz3W4UszqCJn3mG9BF0Zqq83x0gSMevlphQ1hWTCSpDHWfNh50nhIuU/oD2gcV/YdgHB1efu5hktGGpxZI
 2v9kc9Xj
 dj21JJVLI8Ny2mDtl2j0cGXZ6+Cykn2oCU0mT87Xzws/+2hci+VxTCm8pKaeY7xrINZJWx6grOZGoYFH5vPBidhYLvvqkxYFyijGX5O1e9l35BOoFGSwVTTmegP0/aK/RvKHUasfwErAoPqvmDF/1DzZE0+ZRfbqrfnZlQbJ3DeoXct6+wbOuCDiqAqG4jrTV0lbGHKhPD+9IrKCJ5+m+3mrR04K9GZezMth+MpdRLV6XJad6QAPpCIUC2BAAlladKz6jflz30VRAJHVlUYm85ANlksuJvoVHm2Ha3nkQejigTkBrpSyt1nfBsN1wb2W2XJfRIJhsWOQ8Xv/sFH+UJIeCaMFLFhMVliiU6lr4RJ5ydnNu0zPRIQKjT4waDBJkomGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the BUILD=32 physical-address truncation and sign-extension failures,
and address the remaining GCC warnings reported during review.

Changes in v2:
- Use memblock_phys_free() for all synthetic physical ranges in the basic
  API tests, not only the maximum-address check.
- Keep the dummy-memory address conversion fix unchanged.
- Use __pa() in tools virt_to_phys() to avoid a pointer-size warning and
  sign extension of 32-bit pointers with their top bit set.
- Initialize end_rgn to avoid GCC's maybe-uninitialized warning.

Clang BUILD=32 without NUMA also passes on v1 (189 checks). The earlier
cover letter only mentioned the NUMA-enabled configuration tested then.

Validated v2 with GCC 13.3.0 and Clang 18.1.3, retaining the default ASan
and UBSan flags and adding -Werror. Both compilers build without warnings
and pass ./main -v and ./main -m -v in each configuration:
- Default and NUMA=1.
- BUILD=32, with and without NUMA=1.
- 32BIT_PHYS_ADDR_T=1, with and without NUMA=1.
- BUILD=32 NUMA=1 MEMBLOCK_DEBUG=1.

Each run passes 189 checks without NUMA or 272 with NUMA, including both
allocation directions. A separate virt_to_phys() boundary check passes
with both compilers in 32- and 64-bit builds; GCC BUILD=32 failed it on
v1 for 0x80000000 due to sign extension.

v1: https://lore.kernel.org/r/20260916161105.2548281-1-hi@tychen.cc

Tianyi Chen (4):
  memblock tests: use physical addresses for region removal
  memblock tests: zero-extend simulated memory addresses
  tools: use __pa() in virt_to_phys()
  memblock: initialize the region merge end index

 mm/memblock.c                            |  2 +-
 tools/include/linux/mm.h                 |  2 +-
 tools/testing/memblock/tests/basic_api.c | 20 ++++++++++----------
 tools/testing/memblock/tests/common.c    |  6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)


base-commit: 5728d3523f12826a2b180c1c5738f74e33197e14
-- 
2.55.0


