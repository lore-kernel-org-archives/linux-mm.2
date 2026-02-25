Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2FCFFD3770
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E36F6B00A8; Wed, 25 Feb 2026 11:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467236B00A9; Wed, 25 Feb 2026 11:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FF46B00AA; Wed, 25 Feb 2026 11:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25A956B00A8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:14:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA74A1B6F18
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:12 +0000 (UTC)
X-FDA: 84483475944.19.0F94CBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 61BA040008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jiEHsHfMpWlRl7bljrHmdd+gJcFtALSCg3Y7Z7VxAHw=;
	b=dGAoek1+DLYZtmSioXq29/ifiEUmjnis+LcS6YL5ZbNwH3az4ILjQex6rXKkJoVobcPKLG
	9VDHM4625V45KPqBT8N73kFnoG5OlT7DTCMg8X/XqwvfvhvZl8kHuzWNfAIJ8Q1jyCfCAO
	MfgXUxzj5f1diAZ7uHh+xFPcKzJzCzg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036051; a=rsa-sha256;
	cv=none;
	b=4oe34RNtPfpKLtNfH6w7JZ/5hrF0EJJw3SQ0EQ7I9t1RQrdfm6CrbepH7yvUTUBsvyBlGL
	32SS2QGK4OdMRpI/zQjWL9QeMd8qtKNVW4MYNx4Utj+7wOV+9uAt3gt+9BILM9qtakyQCL
	TUNWW6P1Arg8PR5S5SkFTxOqF5BfgEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D443B600AE;
	Wed, 25 Feb 2026 16:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38738C19421;
	Wed, 25 Feb 2026 16:14:07 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/5] mm: arch/shstk: Common shadow stack mapping helper and VM_NOHUGEPAGE
Date: Wed, 25 Feb 2026 16:13:57 +0000
Message-ID: <20260225161404.3157851-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: owzjcz6cr9x34ezc78imhqe1ykwq91xp
X-Rspam-User: 
X-Rspamd-Queue-Id: 61BA040008
X-Rspamd-Server: rspam01
X-HE-Tag: 1772036051-573169
X-HE-Meta: U2FsdGVkX1/NOUP1osYaHYgW1YkA3nn9Oy3PLzvS5WG3tzNznZrlQVtF443U9Y+HACWI2jU0+QbdiSds/Lug9gPFFGhkfrIbfheuGNW3FDiPTOrvktfh5lnQxuM6sdsfW+rBRkBI7Ewu3Pcj0sDfZvG4Ie0w6A2cp47SlHlpXB0yMO3lPfUgbDBsux32KFyDirKU7irp2bKsPFrIH+DVIhzznUmCbKej0RStv9s5U6YPTnXnwuRSMRDl3tZbtDjFHEdUohpChuyDzuK6Jx7wHzUAszF5Ejy2lM8D6GUydbQSJwUI79NiRHohkpPuWX/F/NV2WRTvqndVRdREE4KouPXbU2Bun7SG7EYn99XbZi0sO44idbM5aZ40mSo3GP6rLoQrUsj0+JczG4kzzOUvjObeeb2Pc28Ab7RUebcEL62O/AielvMTWdsUH4tdToqKSYsn5QlPtD6uta3pb33xhqAp+YB2IGmaaIfm+LSeHRQrz1U3nAm3B4ftkfFRHa/JyXUYtp3MrllGhgQi6P4fR/YHYWRf/xbjlRcU6HCKPgzF2n3fSdG2PJMYodzXD0y2TV7Y1+iHyQUtapiGWe48UEUEt/6eVYVodH1AwEbeKIo1EH9jGLKWtcWiNAYBgUUNUNJuOdZlLIGavcRTN4vKwSj25K/9bYaPxCmXupbuMwimZW1paFgI+XKNd6X5ii6BLq+6oMDRHQl899mraZpedASLgy2NmgjqXZQEwrkPQVFFszFUwmXEmoVbrF6aFO5Gmu6PtCN4PA9wn6X6y5hvriqGbAfdpWOowyqY/9Zp22E7whh48Es7uYCBSALJYUAvYg3E7Ljdb0tMLYoyTfUM6o0tBny39kVUZ/DR03FzHwSzz8IRtJerpJnjNHmW7OW/zgJU4FiXClb4HdiCrhLQo6gjC9CLD0x94aXHailpabUw08ywfc03kuTciTCMdA3J7WK4EsHaIwZmwrHXKOy
 7bb7qPaI
 GAaM8s7M7rsf1jQMdIxRh/E2KqKJSf8qEl53ic6/TVw83Oi1YKB1dbXrPzIIOmLAmKDCKywYUJEjMbibG/7K2ZgucdRWfch0FudB89InESALmTUMQowSju0ZzaYF1zKHKZ6cTr0+P+iatkhSuh3kmevoNyD1WrzwdwiG1e1NEiTvBDfOGP2wTSXSNGI/938aCflXqIiBFSwJO3phuApRU/rVEmh7BFvgBHyynwaRUwXpTYFljfq96zzEn206u1t/N6a8y956K9LGS56N3X2V1XggxWmBgDlXuHJBb23x3myvVhwEcaRHJXFo61edZemFCNrMKlZJ6PizSf31z0KYoGrmEC0ya/4fb7/xENWSnRzqksXCFQ35mTmdJcKxSl0OjkJ6Pu+iQOojweClBt7k3lDjoKmqRfLap5n0AEmEgo8Gu8PqZ93A7JLIyLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v2 of the series extracting the common shadow stack mmap into a
separate helper for arm64, riscv and x86. Thanks for the review.

Andrew, if you are happy with this, I think taking the patches through
the mm tree makes most sense.

Minor changes since v1:

- Removed #ifdef from the helper function declaration
- Used two tabs for the alignment of multi-line function arguments
- Added "There is no functional change" to the arch patches log
- Collected ack/review/test tags

v1:

https://lore.kernel.org/r/20260224175800.2500729-1-catalin.marinas@arm.com

Catalin Marinas (5):
  mm: Introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK
    mappings
  arm64: gcs: Use the new common vm_mmap_shadow_stack() helper
  riscv: shstk: Use the new common vm_mmap_shadow_stack() helper
  x86: shstk: Use the new common vm_mmap_shadow_stack() helper
  mm: Do not map the shadow stack as THP

 arch/arm64/mm/gcs.c         | 14 +-------------
 arch/riscv/kernel/usercfi.c | 12 +-----------
 arch/x86/kernel/shstk.c     | 12 ++----------
 include/linux/mm.h          |  2 ++
 mm/util.c                   | 29 +++++++++++++++++++++++++++++
 5 files changed, 35 insertions(+), 34 deletions(-)


