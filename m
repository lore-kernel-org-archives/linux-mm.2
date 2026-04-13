Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AFCEBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720296B0089; Mon, 13 Apr 2026 06:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1606B008A; Mon, 13 Apr 2026 06:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E77E6B0092; Mon, 13 Apr 2026 06:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3096B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:46:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB28D1A0134
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:46:57 +0000 (UTC)
X-FDA: 84653204874.26.F5E8431
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B4FD1C0009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:46:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mGjnUYAV;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=55OlgZ/JG9ccYKSxYHh+Mm4gCr9DtOqU2HrBxBlg9aM=;
	b=QEs7r3Wv5AElsLhFw6j7RnGcHE0B9gOXpnMOo2E2Z/afGYi93vMLGPNPRdazoZi/6ns0Yq
	Ot72Y8hQHG6zJzUJnFNfwRIii2NvjkYM1Snuzp+G5Wm8BTuUz4wjI3h2ugrONwqiz9kEHL
	XLFjT9vbtrrzUFP7Ze5ubj0yu8H/QF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077216; a=rsa-sha256;
	cv=none;
	b=ZQIqGqcTjeopsMrXjNaev4KRsSzGWONmlb1u8PwwDNzyaDyefIIBYHVLV0dFy3Yf9ejOLv
	1ecvVVSGAL0batcMCs2OgrFTXyxrr/+wyajYz7un+82zhW58ttr6D76jm7Cvcw7sX0Io/m
	q+3n7/fduRXPg9tyTfZJk4/bWnN9s2U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mGjnUYAV;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32D4B44549;
	Mon, 13 Apr 2026 10:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7825C19421;
	Mon, 13 Apr 2026 10:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077215;
	bh=EV5PQN4ZcY4YowILqRqfScomjrS3S5Dkp7GHlFqTkl8=;
	h=From:To:Cc:Subject:Date:From;
	b=mGjnUYAVdAklmN+5BaaD9L66bnb0uI92gprtqyMm6V45B8YNGskuFNitZQLvqIGEV
	 UMPapzH0LPv14vwdNpEtEHVw0QbFTf+s13E6ON062rKaHF2SBOGhtf+YJgz9OVjztD
	 xtO4riwaKnxs8Bv7M1l+8Ykb4FsZi+dSFeANT1ygnFw7p+VyhVXwUxigQnV/4ZrL+V
	 LtHvgwG/voxJs4qSTHor9TuydqmsOrbZMmBKTUpdf2ZNU8bSgRC5cdDbyPsfjQxy+I
	 +ldlTC+idJ41ttw8V18RmJyjFkyP2vULUDw85Jn009X7k9jqEv8bNZBpu/K6Q4Oxi+
	 aCHflwUP54brA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/10] sh: remove NUMA and SPARSEMEM support
Date: Mon, 13 Apr 2026 13:46:38 +0300
Message-ID: <20260413104649.852228-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3B4FD1C0009
X-Stat-Signature: cxkes91wr9qogdkpis5xqjjm6nujni85
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776077216-759378
X-HE-Meta: U2FsdGVkX19QdcgCU0X/OqRiUdw5za7VOf1XPJpOof7auSamkovrct3uUKoReMcb+SlzIIYdijtBetTTV5JUZYbVD6DLc4aLiPjAVWt8mq0Gq8H77OasUrwjl5amiArbAR4IhJCyBgYffaeaB2j1JD2VIvHZYWWBft4YhM6m0Kdt+5Fuf/Jn2Wt8Hj3sNzfikLSjOB90jkIvwlV4OXwO5S9F5PQ8uBYiBKxRGS9bWlR38ow6MPpAmqiU8kLNEho9d3q4eBmyjSgmeT8LIdfnuyO5UwT34mfagWFpqjQ8E/4WT08VnAoPlgC9AhR4tD18ArWlgSoxFdVNI//JsRy6ggAAhApKDFqvYnG8evQiAq4RinNJ8TngG1OpikLIHs4CzkUCQjJfpgFDC0J7U/PT9cy6Xn3FPP9e/dOWV/pwvmFYXjnNGl+ss9LSUval/wRTiuqLYCqrzKx27l3bEsTIassxiBlZXPSGEbKHHv5wOltAz4ydLIDu0RfJJujw1M8tJ0KGnV62Q5wtYnH0yCYCreGw/jZQnzVneQ4R7fZhFZxgtfzJI573ZbfDpe/4Uv/Sh92I4F/OeNkX8N52UUPIQD0ZTUdM5QsbQfgeSE8lfVkZtvzCjgpAwh9FGGcYX4R7kA6OOF5oHnwoebNjiFU71NAJo2ymJFd0pvOdsDYUEljiso6Vy6cPW9Md6mMTYBsHhTt6N7HtysnUQ32zb/h9oAnH/mOAPWCnQ4cDwr97VyL5xysdR0+rcpwJsnVWh2iuRtB7R4lL8VDbbOKk0lcI9QqjyqQxs/qFnRl+RosuwPM2XOWojD6qJUte4wsoOZvYmKSQHnq3PY4z9GET1pDwbWszFqqy3f3OIDF0XntEZp7QsVG65MA3xFkUjwWYN/FbD26y446JWoTdDquo2tPRet7jf7sfwThy4o4tT+OjBmxJHlE8rvOzpJpixzGDHuysi+SNA0U0J+bOWoB8tLc
 Ju/IDr2s
 8kf6S6SQxF55Rq97Rfg0XRQjbjPBTdxg94o4ki6rVOXt4MuLRXJebX2bbEAPDtL8un13pJdIY3cSz9LEe1GKcl5qHeUvfIzaIqj+1XRexzxZP4oAnI7HThUwqWYR+m8LDjMtpmhUWRlm2SS0IpmERxqD77oaki0dCmWwiNGKLSDTt8r+Y9brb2tMmhToa2yAXkURtsZIcsNEDgOtJwR54DqCJ0cmEXa5enYHWptfoYL21ewk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

NUMA support for SuperH was introduced a long time ago by commit
b241cb0c885e ("sh: Support for multiple nodes.")

	"... for boards with many different memory blocks that are
	 otherwise unused (SH7722/SH7785 URAM and so forth)"

In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
shx3 at the expense of all the NUMA related code in the kernel.

For build of v7.0-rc7 with defconfig and the same configuration with
CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
overhead in code and static data that does not take into the account data
structures allocated at run time.

And all this overhead has been there for nothing for almost 8 years
because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
those additional "nodes" could not be used by the core MM because the
maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.

Mike Rapoport (Microsoft) (10):
  sh: remove CONFIG_NUMA and realted configuration options
  sh: mm: remove numa.c
  sh: mm: drop allocate_pgdat()
  sh: remove setup_bootmem_node() and plat_mem_setup()
  sh: drop dead code guarded by #ifdef CONFIG_NUMA
  sh: drop include/asm/mmzone.h
  init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
  sh: init: remove call the memblock_set_node()
  sh: remove SPARSEMEM related entries from Kconfig
  sh: drop include/asm/sparsemem.h

 arch/sh/Kconfig                        |  8 ----
 arch/sh/configs/migor_defconfig        |  1 -
 arch/sh/configs/sdk7786_defconfig      |  1 -
 arch/sh/configs/se7722_defconfig       |  1 -
 arch/sh/configs/shx3_defconfig         |  1 -
 arch/sh/configs/ul2_defconfig          |  1 -
 arch/sh/include/asm/mmu.h              |  2 +
 arch/sh/include/asm/mmzone.h           | 42 --------------------
 arch/sh/include/asm/setup.h            |  3 ++
 arch/sh/include/asm/sparsemem.h        | 12 ------
 arch/sh/include/asm/topology.h         | 13 -------
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |  5 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |  7 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |  1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |  5 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |  7 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |  5 ---
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   | 18 ---------
 arch/sh/kernel/setup.c                 |  7 ----
 arch/sh/kernel/topology.c              | 12 ------
 arch/sh/kernel/vmcore_info.c           |  4 --
 arch/sh/mm/Kconfig                     | 29 --------------
 arch/sh/mm/Makefile                    |  1 -
 arch/sh/mm/init.c                      | 24 ------------
 arch/sh/mm/numa.c                      | 53 --------------------------
 arch/sh/mm/sram.c                      |  3 +-
 init/Kconfig                           |  7 ----
 28 files changed, 6 insertions(+), 268 deletions(-)
 delete mode 100644 arch/sh/include/asm/mmzone.h
 delete mode 100644 arch/sh/include/asm/sparsemem.h
 delete mode 100644 arch/sh/mm/numa.c


base-commit: 591cd656a1bf5ea94a222af5ef2ee76df029c1d2
--
2.53.0

