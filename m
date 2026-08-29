Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484BAC61DC4
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A836B0095; Sat, 29 Aug 2026 00:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC3E6B0096; Sat, 29 Aug 2026 00:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311496B0098; Sat, 29 Aug 2026 00:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 108236B0095
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:41:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89FB116061E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:41:08 +0000 (UTC)
X-FDA: 85153057416.10.397238A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id 592C9C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:41:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kqFZ6RjL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of kris.pan@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kris.pan@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787978466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c4RdSTQgCIHBNq3qnE0NnaJV8PxYXmUJkQ04F2niOQw=;
	b=3Bvm1BPGETONa2CC0vg0KuTahXQdfU4LSoEu1VnQmTwF9PjRW+K6+IL4UJ4zpSIuSBVg2G
	Ek7EzXgSFnRRcumW+oB4KPNpPmD2NZ4n0iomRo7UKGT9hwJM7Y6J5LI60inCn54Cwfz/bZ
	tvfBpG/n7Smm03YXP+trqMzUTrmMqjs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kqFZ6RjL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of kris.pan@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kris.pan@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787978466;
	b=MASo3vtPqC5FknUz52r52LfO4weXdaV7TkznrXT+1dP49erOq7BEwrmIcUQuMVMeKt3go9
	LGy2jQcGG6qF/MLbkNCFV63kwQi/bDUf7SuRGSsV5Uu0PsbDzrUbkL2HrYpHnzxV3AjqUr
	3+bLeulRdMi0yqYzdohup7rB3AwUtEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787978467; x=1819514467;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AAbhPvDUaBJKmqmN0hWK2oPT0O7KSyqED1IG1hPaVrM=;
  b=kqFZ6RjLFNtzigyEykzpGhr3lCtuT6j1o5u0ItBX018YO//qJxFRp20w
   zWEX+n89evqFySRzXlCmko5hvwjIjXraBjUSGt0b5YmrPdxYzfnWyjp7f
   ampDZbAa8q8TPZZZP44sS4i3TzXSrZKpgdG2KF57rAzCQd/5qMH/XcbKT
   SDAC8hqJ2pfp4XZsoL5MDIdm4vD/RKuDFSBCaeliG0Woku4bpsrJaAzG3
   qwBe+7UEkfj6TvQ0I3mNhMhWs2poWQ9YulPFO5uqTNqvZ92z84NgtMV0z
   rICL5ZxXlVzLH4+QaAh4+q4VVM2X4fZTtNuFoRg02bofRHZzITTUgS7mf
   A==;
X-CSE-ConnectionGUID: WmzcIbE9R8634zpOLR0xrQ==
X-CSE-MsgGUID: 4VCT1qxbTk2o9n4YLikKGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="88683911"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="88683911"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 21:41:05 -0700
X-CSE-ConnectionGUID: d0jjEtayQcqHCNaaJ2HUJw==
X-CSE-MsgGUID: P70QfAmOQQ2ojogSmjMcaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="266533019"
Received: from pankris-x299-ud4-pro.bj.intel.com ([10.238.152.122])
  by orviesa006.jf.intel.com with ESMTP; 28 Aug 2026 21:41:03 -0700
From: Kris Pan <kris.pan@intel.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	arnd@arndb.de,
	max.kellermann@ionos.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kris Pan <kris.pan@intel.com>
Subject: [PATCH v2 0/2] drivers/char/mem: splice the zero page for /dev/zero and /dev/full
Date: Sat, 29 Aug 2026 12:37:44 +0800
Message-ID: <20260829043746.2929210-1-kris.pan@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 592C9C0004
X-Stat-Signature: ce6bywd95rsruy7yd47uhjorb1uscnox
X-Rspam-User: 
X-HE-Tag: 1787978466-910479
X-HE-Meta: U2FsdGVkX19E5vsIlbDCL197H9Yyygxc0SuyOraLz0C2WjxjmwG2uT5FJ5SjLgXlNU0Ep/WEG0n0JZzewjvp7aqNTi6qZpHm/MT8L/nQvAuOY89X4ESU2NjZ50lCV0yNrX0fuYXevTfpafXJsPHUI7Mj5gh+OAdxe4FbNNFXQEtPwHcs4e/ABwJTIWqNCJBgV/egAqTuEey4nBhFe0kjKIYJ59142MP4NbXWVef95FSKVuXooynLHoSX172zl4DKTs5quXO8ho88vFdB5OYDA68YEPp+Mkiqw/sVuS1zzHBa3v+YSVI0MXbsPTk9lUxjb/AJHBEHuy1QGhOIXcUpJvWKVcWN2328v6eHcB5VrtKyFBpBXcgcwi0G+J6Z8lMG+3tB8x/wOuwtr0AZroQB3eu5WxUVFBL777ll/Gzmo49TUsgxeVzBhuP9RvvBsF8lhOgif15SlLuqGWiRzcZAMSHk9Ob0vsXTgh3Qo00GUIIEULfkfou5argocHf6gFxQXW1tHR2/RMuqkPhNYx8FaorX4KckpLiLneuWXqHVOmEusUr22s1qfSryHoMPHEu13oozITs6HItOzdXPJppMZYckSw+Y5YAyMCvI/JisD2PKS0hZago8Jko5VhSTEt+lRkgZnDPv8z0CrUV0b3z8gBcxUBwo7tn9q/QcUIwyt2Nboh1jaSIdX3QNFzhyTxpZnPur5FxKOWjwamNK9nicOE1x+94PZ4hl4iI8vLDC0kaJBENo4Dnv7IVbIOVg5tqVxe3DwxZGJs5BYd4K44L2ESMNgxF7IrXjs4f42yy7MiIw8GUWBV9CzY/uoU8LTtUjBnRWw23nusxb3XOSuhWXKBrL9JGO8NWOLPnVIR6nEfbGIpcJExX3Q3W2t4sIWSKTejOCCEwbyMUn92569EH52PHOdV0BFYSYaE5T+VGBwB/5V64MiPO+RnQljcOOWjLqwEwCavzpYLWvwMJExsV
 yuaJqNxV
 CblX3dyJRwLqhLmM1Ot5EvxQiQmL+nZfxhZklm6yiWDLQdrhEFkJ/+y1XpUGn+92GV93MAOcsZPVEMvb1uNf0Vj+zdu0WJGbE9AWF7LpRmzrlxOpdoS2yCPMw1rtsG4UurHeEnzuuBm10gdO5b5A4CcMY2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1b057bd800c3 ("drivers/char/mem: implement splice() for
/dev/zero, /dev/full") added splice support to /dev/zero and /dev/full
using copy_splice_read(). The author noted that this could be optimized
by pushing references to the global zero page instead of allocating and
zeroing fresh pages for every pipe buffer, deferring it as "an
optimization for another day".

This series implements that optimization by splicing the zero page into
the pipe for /dev/zero and /dev/full, reusing the existing zero-page
splice logic from mm/shmem.c.

v2:
- Move zero_pipe_buf_ops and splice_zeropage_into_pipe() from mm/shmem.c
  into fs/splice.c so they can be shared, instead of duplicating the
  boilerplate (Max Kellermann's suggestion).
- Rework splice_read_zero() to use the shared helper.

Kris Pan (2):
  fs: move splice_zeropage_into_pipe() and zero_pipe_buf_ops to
    fs/splice.c
  drivers/char/mem: splice the zero page for /dev/zero and /dev/full

 drivers/char/mem.c     | 29 ++++++++++++++++++--
 fs/splice.c            | 62 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/splice.h |  3 ++
 mm/shmem.c             | 45 ------------------------------
 4 files changed, 92 insertions(+), 47 deletions(-)

-- 
2.43.0


