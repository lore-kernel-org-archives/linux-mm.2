Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D415CD8C90
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 04:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E74B6B0005; Wed, 10 Jun 2026 00:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397E76B0088; Wed, 10 Jun 2026 00:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADBC6B008A; Wed, 10 Jun 2026 00:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 195C56B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:36:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE731408A1
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:05 +0000 (UTC)
X-FDA: 84862740690.24.684E4A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id A46D7C0002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Hve/LHH2";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781066164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TILSTruWEHE3zB/EHWtmpmrVdB+b+Qw6C4QJlT23Pgc=;
	b=wdL85WJMyoicQJL8axm3f7aCDro21EsIErpbJo0U/O1I0fXp+VTDkOyA0SkBD2Td+5CpCg
	EMM7G9eXuazRqP10PNBY6OsU15eIhIeG22UPEdD7F4gGPwvILPGRMDrojcqbHY+LW2aZFc
	JrQ9nY1HpCgALQjyVswx/CpIfIw+X6A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Hve/LHH2";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781066164;
	b=XgP/ccoriE5Dy3X9+eFksTYBTwqf8z2lK0URy8Hgiy2SCHjajpZqERwpk0Pf72SpPICeLf
	ITkXOGjb/IEgDe92rmlDm21pggcxPH643oN/OcVECQBdNQF8rWgbUeMKpOr+xnB+Cocwee
	IY3/IuMzPxaJeWsUJyZwzoZBUcwxXuA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C98025E3;
	Tue,  9 Jun 2026 21:35:57 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 649AB3FD88;
	Tue,  9 Jun 2026 21:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781066162; bh=3GXiGY517xe/UadGb37rObRReqoIjBTBisS6jBAfnwI=;
	h=From:To:Cc:Subject:Date:From;
	b=Hve/LHH2Etq+3KMCwxsq4ZEOskp1J2Nr8Z9uojcgE70CS6uPIvW1k9fRwrY2FGboV
	 aCO2Afv0S7Bp3/bYEB3PLcRyhZ7PiPFYJSRRhT7gZG3whe+uQKwJKE2SXxNBuKmIkM
	 ceqpLlWypcrtSf3RU+anYjwe5QHflJRBijB7520w=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC V2 0/3] lib/vsprintf: Add support for pgtable entries
Date: Wed, 10 Jun 2026 05:35:42 +0100
Message-Id: <20260610043545.3725735-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A46D7C0002
X-Stat-Signature: r89q98rci774cy61tbqg65dgbz7uxztp
X-HE-Tag: 1781066163-10609
X-HE-Meta: U2FsdGVkX19Jr7GyWXEIu76hLwEDopUJQDYnmBSY29XBJH/OaZc9VKWce6U86vAuF2QeqT5bNgH28F0I0UI4jAWohfAL+FSaJsu5KYbpbrkZNFJPlgLg3wcjBHrnEorUPe5rU8BVj7SpeHh5b0JCmBnadfZMkAZEJdJiZ4PibleMwUKDk6Vktz+AwnNAyZayAMBekard9pkmtcTSMKtyAkn9tm6vor1udE2HcijiCp7yr2yDHM0ijEs46E4KtFvKEfex481V26cC+Pz7lHSvkZGWggQtxrkHpQJl8tIew7nVQzUEPHI/1DV6FwJlgW7feMNTGNFSrM9ckKKJEISAw5KqbIr0/jwUwgcWNr0TucotRdMvvQYPmQBXoVwf2aSgAkfTXgWn/xQU/smvFo17Vs28a3a/+eJDIRG39nDgKwM+V3pKiNjKxwW3MaPbJiHIBUOLFWEctkH8geIPb4/mjGSPoCyXVpMUAc26KuwBdePy3OvjwkVGa6WSXPhby55nTCyFR+42981fG1N6y/+ws6f5stGt3vx5497v0c6heK4ul70fKausJuM4UQqFi71El1bb1hpzUp3em/QU2wQJKUgZQRiIQwRniHU8YvR27HwhFNbL547BCO7dMZ1xiJzeZMABqH91bbT6g5xuJ3csORne90nlCe3nU02OmRYidzlaEFsabyHyu5a8fCEzHxFxymRP0azdzYCHWuc7ALUQgagmGYT+ZwQjeOc7xRZzfnopxL3r485W5TUuCWxG/Y2ydeGM2zbkeJZGU06ndqvszwK42m2eNLSV68/24so+ZYAFus6tjDxvxzp2RIH6dN8xOqHZpLn5/6PJAgse/4npCCMwcuMie4QGK1bTzdc40i6jd1PPkoST4ahyORXolxIYyePDVXzeGnW9L0Xd6zG4v4fl2Bsin5TXo7HdROhK0mFgeg2uZ1iXRhyF8N73Hlay+OtH/Aer1Ni2XX7IOWm
 qXDZ/j0e
 Vwf1VT4N4gXnnOstDpQorkvnZzRgcbgKRDQEV78naUqGyA4RC18JrwevDik+O8zo1bMPu5OV/Rz5yoMV+iZ7c14c2MvUwe3ywo7lAbgNbpwbxsrOWAehCdw5Iht2azj2teWkd5TJFnLGl+578k1zuRtdiLdc0nbfF9izRiMJHfqxy+XWlu2azzyHxWYZC7503ZJr184KTrmP8Jw9T+vwPKykJG7cWh0XjSYk5bMRkop2PWGSMLpTuDtviXioJ93NzuBbCAVJ0UU/34ZifHHl18BNqqOL2bgSfyI5jfS1xiW3nLQcR5xPDhh51NvZ4hzHXv1k4rT8+sGhClLg/mSzFhEV5VDfBrJEh8l3JWiDvcOryfsC2rZxUTswPlAeQ2PEDuln0EVkpk35+m7xBq5BbcH3UoZA6n+pYDKNIP/GnRT9o0Cx8a+LYkOjS31BVunvEp2pey7nw80hsaqDMpFeQxiTk6RrEjYsIBwaoe1sQnvgThvOdimNnitaMEKa6kZyjHli9Ou6iWs/Swo2BsC2BLa6JIQh4heLL930d8fm5a+yetOp+HlkmHWh14Hfp0etwBFlKja17whWmWRArXcCc5c8eUcTHPkNO3SdLs3AeYZUFHhQrmvwhqZvzKu6pS/adT1n/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Printing page table entries has been a common requirement both in generic
and platform memory management for various purposes. Hence let's create a
dedicated printk format for such entries which will also help standardize
pgtable printing across different platforms.

Also add a test for this new print format in lib/tests/printf_kunit.c via
existing CONFIG_PRINTF_KUNIT_TEST.

This series applies on v7.1-rc7

This series has been tested on arm64 but built tested on several others
including x86, powerpc, s390, riscv, and mips etc. Although it does not
build on arm32 platform due to existing pgdp_get() concerns.

Changes in V2:

Accommodated most suggestions from Petr Mladek and others

- Moved __print_bad_page_map_pgtable() changes into a separate patch
- Added helper pxd_pointer() for pgtable print format
- Added buffer check via check_pointer()
- Added special_hex_number() for base case printing
- Added static_assert() to ensure acceptable pxd_t size
- Avoided direct dereferences and used pxdp_get() helpers instead
- Improved printf KUNIT tests for all level page table entries

Changes in V1:

https://lore.kernel.org/all/20250618041235.1716143-1-anshuman.khandual@arm.com/

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (3):
  lib/vsprintf: Add support for pgtable entries
  kunit: printf: Add test for pgtable entries
  mm: Replace pgtable entry prints with new format

 Documentation/core-api/printk-formats.rst | 19 ++++++++
 lib/tests/printf_kunit.c                  | 57 ++++++++++++++++++++++
 lib/vsprintf.c                            | 58 +++++++++++++++++++++++
 mm/memory.c                               | 15 ++----
 scripts/checkpatch.pl                     |  2 +-
 5 files changed, 140 insertions(+), 11 deletions(-)

-- 
2.30.2


