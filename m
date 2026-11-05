Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05B0606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XPS377jC
Received: by kanga.kvack.org (Postfix)
	id D39076B05B0; Wed,  4 Nov 2026 23:34:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9E26B05B1; Wed,  4 Nov 2026 23:34:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFAF6B05B2; Wed,  4 Nov 2026 23:34:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0E46B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:34:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19391C05FB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:12 +0000 (UTC)
X-FDA: 85399798344.14.86C197D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F63780003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:34:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XPS377jC;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853250;
	b=yMzr+VQtHsZBjNIUdcGgs5hhV0h93Fr8o8sbMIyRARvUSb63tAxSltKwpOTmwhwtzmhjX/
	mi30mNN63RRXH2z4c68wqiJdk4n1FReX9TDUKCp5LWxVBk/n4YF0W47gMBc3E2bNmj7pSy
	olKRkFX5f3tlE34jRg0hvh1DrjNlU9o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XPS377jC;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mlFkQzvpjx/x5yKaK7WI5PE0EjQPITGcI6vs8hOcC4I=;
	b=UTvmo3DknfkdaQDp2FwPwuo7CEwjo/VriOXaxMOpkwBLkafUO8bDiAFnr4Kldk9drCEswO
	2qbOo9ukODYa/kdye1ng4knzmULo0ihvTaJdN4tFwNp6vv30zNmXx8fMNHVhDc/UlhgaPK
	9b1glONjubu/zu58WwseoIf0XRKDEdI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B9D019F6;
	Wed,  4 Nov 2026 20:34:06 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DB5D3F673;
	Wed,  4 Nov 2026 20:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793853249; bh=IOlUh+PkfRf4TfbFSCgH4Rp3G8UWbreOgh8RH8GQHIM=;
	h=From:To:Cc:Subject:Date:From;
	b=XPS377jC3xLOwH01o3rlZo7Btd565/gec1lp9lxtjOyFBD8Y8uQ/5Z2EEZZz18kLy
	 qOCqZcLb7ayLGiCu/ZetSRNXVcBFlfp+kecgDgGLLYk8S7P+6Jns8Z27oeGGS8ojOM
	 X+t4JMtP1Op6eqRUy1MUVcJv1mnVbRCPY5j//MLQ=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V4 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Date: Thu,  5 Nov 2026 10:03:59 +0530
Message-ID: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wqfjq8c3en4bx4kbeb9xya3wuc7y31u1
X-Rspamd-Queue-Id: 2F63780003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793853250-916449
X-HE-Meta: U2FsdGVkX18sfq8k6qy+cYzIKyQ5bquY4AAFNxooELFOzRtYtO0MlY5FRW73eIj+x9VrrN/3AXtYwHYqixMb95kfNHxVhkneZHaAs/hm0cb7aKik9trEGNLQ3+Uj5GoOoH34a+sfWZfx22jdnjcOkk/uo6jzNFbioPyO7Vtfqro4esbwFVXZTBEr/O+j0SPDFjzwe0Ru2mgEqtFevQ/cxfm8W4224n+HEJDL24nTHlDgrRHhTqHMW5+BLUr5dZz46OWeGP6LXzWADrhn8BZt5Cmi78+Cnx0rwhpZgeesIGTI6yt1s/33T/mnI7dEy2foW335ocrsHfv51infl7jubTQSykphy8JsKqN3ryiqg0hh/xCGDQLxjQHk3Ldi8EzTE2NhIRVgvcCJkZm1Z1isROu94r7jDGtJeQSw26y5ETV7ESqlZBNhDE9OVOjE/iVYL5oXkL6JjQrrFiZRNOrMEQxPCFZsF6TWBJtTxUFW9uRW/zj3sR8cgyK/Aimu22IEVOX/VmPjfnWaAXNn+wxKG7Bpkq4YuyUrdNK98tIo37SqO3n19yBS8OSyILGlDcC3pYb293OvDjGPFdKXa5xAGTg41DSqWUHbNBc2g+KV18Ubbmq9LJUoqrnmzrNYclwwcka82uCOc1GUDMNqK6MGHjBn7FBbmu44D9kcKwOFNIDrul0IO5G4mN+qXQSPtHB7VSSkPcKBUxBRIiRyhrP+yMr8uDu26GCgUVX/VMhTo5/7Mh0l29VRrvd3NwcTBrTZhyJl7wrRft5Whz7DX9eIiPjudhGEO4YOEC9vS9yjDK/V9eleeaFKkxMur5o7+sXfkOJt41PB3bePpSXmLmR/JcPWHhPfk7YTCK9d8couXVrd7d15l4/sShvMODdL8SH6pkaqsR0xOBmXkqQGjYfTYCppEL2EjwLWbNizaidY9g3IspaEWvsQjTmyocRyDLJHbW6Ckry43iBOxhqjimv
 +ENXpg0A
 2GKW1+jYWYlTCNKZ+v5H/7/fVLSzPo9QoHHx0lfhnBApRaivfupXWmU2O9N40HC3zuuvt5qpDom62p0fxFyzmc0nRlvxfirr2eJVadah+Wi9w8WjYdTT6L0V8b4abez6BRM/OwWsBSdWpiepKO8Bzu4PfNANm91LmjKPYKn1iGQABojnKvQPcuUEPJ/vWQA10gTmQW7a/Rn9C/DAZBz1Pg/fqSqOvrjarUx6hMQb6mVlV570difyhE6UKOKvc1qWd38W9NxSQ8RWQEIju3GuQ4gura3Pk9aasmr+CplLSXLN61dC1BwrOyDC46e8bbJHseCmTkvfQ0kcwG/wSiv7kxB7DyvR691Jjyzw6aWgzcu6xwNoWe7zOnnyMYfYTkVzxmn57NJH9anFVwZREGjQRs0X1B4czZtmUGOSZbcAkHil6/nVqvWdSCs0IQ5Zt4UbqoGGy371Q/md5Bo5d2T8w7RAVGmDZ0vRKRaV/VMx2Gwv8whm8HI1G+pVOWdmoq74O5thxh60SA35CIilOlkQY3ErlEgNograwW56l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Route READ_ONCE() accesses on pgtable entries via level specific generic MM
pxdp_get() helpers which platforms could then override when required. These
accessors on arm64, will help in ensuring page table accesses are performed
in an atomic manner while reading 128 bit page table entries later. But for
now they just default to READ_ONCE(), thus preserving existing behaviour on
current D64 translation a well.

This is similar to generic MM where all atomic accesses have already been
converted from READ_ONCE() into pgtable level specific accessors.

These are preparatory patches for D128 enablement, although standing their
own for D64 translation as well. These patches are split from earlier D128
V1 series. There are no functional changes here, and besides mm kselftests
do not show any regression.

https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/

This series applies on v7.4-rc1 and have been hosted below for reference.

git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v4)

Changes in V4:

- Dropped all pxdp_get() platform overrides per Catalin
- Moved pmdp_test_and_clear_young() and [pud|p4d]_offset[_phys]()
  helpers inside arch/arm64/mm/mmu.c to avoid build problems
- Updated all commit messages as required

Changes in V3:

https://lore.kernel.org/all/20260924062214.1635078-1-anshuman.khandual@arm.com/

- Added overrides for pxdp_get() and replaced remaining READ_ONCE()
- Updated all commit messages as required
- Dropped previous tags

Changes in V2:

https://lore.kernel.org/all/20260922061638.3967467-1-anshuman.khandual@arm.com/

- Rebased on v7.3-rc4 along with all latest dependencies
- Updated commit messages per Ryan
- Added tags from Ryan

Changes in V1:

https://lore.kernel.org/all/20260903060657.2717457-1-anshuman.khandual@arm.com/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Linu Cherian <linu.cherian@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (4):
  arm64/mm: Use pmdp_get() for PMD accesses
  arm64/mm: Use pudp_get() for PUD accesses
  arm64/mm: Use p4dp_get() for P4D accesses
  arm64/mm: Use pgdp_get() for PGD accesses

 arch/arm64/include/asm/pgtable.h | 38 +++----------
 arch/arm64/mm/fault.c            |  8 +--
 arch/arm64/mm/fixmap.c           |  6 +-
 arch/arm64/mm/hugetlbpage.c      | 10 ++--
 arch/arm64/mm/kasan_init.c       | 18 +++---
 arch/arm64/mm/mmu.c              | 97 ++++++++++++++++++++++----------
 arch/arm64/mm/pageattr.c         |  8 +--
 arch/arm64/mm/trans_pgd.c        | 14 ++---
 8 files changed, 108 insertions(+), 91 deletions(-)

-- 
2.43.0


