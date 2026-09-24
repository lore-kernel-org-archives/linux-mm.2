Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1166C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF06E6B0092; Thu, 24 Sep 2026 02:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53026B0093; Thu, 24 Sep 2026 02:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A416B0095; Thu, 24 Sep 2026 02:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3DA6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:22:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 379E012026D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:25 +0000 (UTC)
X-FDA: 85247661450.28.8E1BEBD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89C59120002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vZE1pIh7;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790230943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dq6iKB7XuGLS2dYWQ+BSXdf1EQXXxd6p2s4tq3qcm3s=;
	b=TkzYYRGUKI9ig67XkdFwVtyxrGzPQKLavV+6Z7bBULvNDuuyJ3qITRy4IXvfAmEe7xo3KC
	pzt8U3vm61b7MDqN27+idJP2RaXR1FslHxvEYo15WpLS4lym2TCw4cZEaaHwqu8xbwXF2C
	yPHyKZSxDUE2v0YY6VcGIRvykMs0eIA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vZE1pIh7;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790230943;
	b=C0JJQQLtxtV63H36tFUmWwLpCyFj0hk4zv31HkFtji6HmI1If43lmYP7LQ3etsH08ESkb6
	XdDQ6D7w7wRY5cFMJZYcn7se+QyHvMfLKODmOMPvDHo31gIpJnZuDXy/laSa+r/3g5FwIs
	+rgGaA3UEwTyelDz9hM0j/ztaeiM49g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED0171516;
	Wed, 23 Sep 2026 23:22:18 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1AEC3F86C;
	Wed, 23 Sep 2026 23:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790230942; bh=AFiGAJeNuge1xk0RxTH5cvykdnaiOpoKLFWNCrc5VLc=;
	h=From:To:Cc:Subject:Date:From;
	b=vZE1pIh7XHDLymm0pnaCEQ9P4YoBtWgq3UdWhQgaXWkxYGUI9iq60w/hwMqzSzuT3
	 uNDgd1m4sBRWIAiTdTyeV0brmCr/70thUna+DLivbm842BXwzpi9qwHCGu4NL9y0Ka
	 ncU5ydpeYAf7DW5oaa5UwBsKkmuYRakvbxIv2iiM=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Date: Thu, 24 Sep 2026 11:52:10 +0530
Message-ID: <20260924062214.1635078-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p7zb8k8y89qskepib9zrhe8aqda7rru5
X-Rspamd-Queue-Id: 89C59120002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790230943-147746
X-HE-Meta: U2FsdGVkX1/u3893HoVQKKeuxHK5pXDXVE+1Ix32AHK6TcdfBfRi/khEk7Xl30C49SWNK23m49YUxzf/LTRKqjg2aH90ekIvuHO7pb1xzH7KgeyATs8jeboBwwzf/z+gWB+ta9aWW+h/SM59ljMB3mA1TGH5IWCg33MbP3QGK/1x+5xo5bbP1xl18RQ+YSETI6wAq3Tf5J0NK9QIeuDSwNV9peZlsXsqewFdU5Uwrk3kTiq1FzQcyBymQ6u8k9/PD2iULOJLAEmwCeVVgnQ7NX/3iWolvgKn14zw/lsyNs78ZouBG73ECoTBV1bpY7zJmOj6eaifv7QrUzR/hs/4N23YgcCh2LrIp2Y3cF3ZDhdO2KQVH+Lsp65fIDE8ef9ufs6fMhebsnESE09uvNMEcCW0++22ZGZ12fStpV0/CMmrHRTot3sMh7IjTU/OyBOyv5+2cR52P+qvOd7Uzk8HjshHMLp2y5un416bVAnL9GD4qClnbiuhhyvUzSr5hAEdH2elihELkxK2c7gIpKNBCRvgnXRLeqPNLk1sAlbKml2PGBRa+oHcg3FewRaJ0qm9DpyVBhFtW580IHR8wBcHuHMy8YIXRJBNFdf7c5isOKlTLhpqMLvXBGN39W3viX4se23IqcPkCz89qzwqC++skPdqdjJ24OWSkTM4dxJWunEhIkFZy9eGYeL0sQqVb//95/OXz5S7igv56fNo/fs779jS75IOsoJITrJNJnp/3ZmeRqjnSTtJrQ9Ux7L56DKlCIwrPT76wCJZFmJGH+g1ff36UiurHQdyV/uHgnndZbES9YuJQTMA1NYrslfRpwSsHaY0YZaVaQ+61Ut0tyUyKbANhMHwB+TgqH0CEyXIwO0zJIs2wrp+IraBNw2Lt1z1XNYUhjNlYGWOsHNVjE0iZvFN3i0mIvv7GWSisULYrnd5gcm/TrNX60TvkCGOXq6eVffPJykYLvHoJfH8xls
 y9t/uBsn
 EpESABlXc37vIxfoEiFPW1dd0HATcMl5EdXUaPqPRjoB8h31+92RFbZ3yq+512XpGMLx8CTIRVcWnC1Ez+MtCoZCpOVdHSmXDZVGQX03HJXW6uws/+RVIe03/YJBqykLrSwSrptx9hdNRZJfu+t+CoP1A8Nj03RzyDafpab57LzPbp0oW7vMrHARzt/Fpp3zTxNTtHGXgNr4pgF4kerNO3v/j5DdPYBBm00HqZ/UO/oBYR146GjP3i5CV1puFF9yJv79soUyN+yef6y+tk50DmiiRWu/Oich8cZ3zPYP+WUiAzgVmvjG5WDtI2IiBSLGxT0lc2oa9T9vfKiCfteUnxNZ7H82fco2JdD/9bBeA2PyWXS9avpgu/PNePtY3LCedbQGkxF+eD3Lwp9jdcIgIhuCeg4VsdQO3Twa4ozIR6PNOzLDdVeYBVyxPrZe24aRQuzFgx1uHWoDkCC9BAz7Hi0t/cjKmcXUMQKBjeVnt4xtl4eZxd4q5NIOEU/KLli55LcU9x9B13sWXHKfEroBuplaHmjDbJHm42aQ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
V1 series. There are no functional changes here and besides mm kselftests
do not show any regression.

https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/

This series applies on v7.3-rc4 but after applying the following patches on
pgtable entry print standardization posted earlier.

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

https://lore.kernel.org/linux-mm/20260916044933.2689426-1-anshuman.khandual@arm.com/

These patches have been hosted here as well.

git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v3)

Changes in V3:

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

 arch/arm64/include/asm/pgtable.h | 40 +++++++++++++++++----
 arch/arm64/mm/fault.c            |  8 ++---
 arch/arm64/mm/fixmap.c           |  6 ++--
 arch/arm64/mm/hugetlbpage.c      | 10 +++---
 arch/arm64/mm/kasan_init.c       | 18 +++++-----
 arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
 arch/arm64/mm/pageattr.c         |  8 ++---
 arch/arm64/mm/trans_pgd.c        | 14 ++++----
 8 files changed, 95 insertions(+), 69 deletions(-)

-- 
2.43.0


