Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82934CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 22:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42768E004A; Fri, 10 Oct 2025 18:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF32C8E0002; Fri, 10 Oct 2025 18:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08A78E004A; Fri, 10 Oct 2025 18:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 901E08E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:08:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32AC4C0452
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:08:48 +0000 (UTC)
X-FDA: 83983595136.08.92737B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D9F718000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:08:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VGYITCBY;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760134126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2FnMEtDi3K6IIuIl5tWLypX3F7nmJ9cKo6ZFf6Zj0Tw=;
	b=pSOXX0y5HtrYoiyLiyMB8GWHNHXt4+4nZkJzaZmcV0wvfupx4XBgAmzpWamiazwlu5FbB2
	ST0u7pjeIdB0sq6giuIcuT+s8QE8hcm35J6icIRTa4vwviFbBLmTR4aEBloE4zT9QGSq0M
	ddh9lFRWtSglOsyLwchc9T+/OsDK6EE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VGYITCBY;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760134126; a=rsa-sha256;
	cv=none;
	b=CUKp2/a+U42/filzzctvBalawz2Na2tAaFJ3BvUje9wwRcu+W70fBfeBaouABKyvYvNxhH
	rNjUn3c2g7yODgliOHlo9PEH06da1gQFOnfolXsexBwkFKwZf/BarwlVOpGA4LLlCgsCMD
	IAZ2NZ28JMbyslDhylSaGDSNQv+T2cE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EC8943949;
	Fri, 10 Oct 2025 22:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C63C4CEF1;
	Fri, 10 Oct 2025 22:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760134125;
	bh=V+KqT3fmN9PfM0xYoQfnTgfVMW7tzUUYviSX+SWUvaQ=;
	h=Date:From:To:Cc:Subject:From;
	b=VGYITCBYPDQbn5ijuhutsAgIenUjKZrMdR40UGI5xCRvqTPRjqqEd3r8pYuhEqWsQ
	 ysmK7Ba5RT4RQf8+ZSGx2j4E1tQL3MccKvKlEKmWoLlgz5dHShx53rFI1xsZ4knyBw
	 BQIXxH3KhjjMr4B60kOclTEY+1Ot1539bJhImNSM=
Date: Fri, 10 Oct 2025 15:08:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional non-MM updates for 6.18-rc1
Message-Id: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iw8dosi76szodjbyun4hkms1oz9zdpck
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D9F718000E
X-HE-Tag: 1760134126-753276
X-HE-Meta: U2FsdGVkX19UvnJsN96drHXlPjQXlQ1zsHaHtYamODEPzRTIbZm7cHDF3k9j/+BkLEH0C7KGREKmXZZqRl8gPF56paMb+XnzEKGkrzVifW5bnicQw6h88WWFaH2YNW4yhX5ggV5vfPHpk9nCnJRS1vpNvcsYbzQetarGrt/8rzGA0w5vnSZHE7xhBZLQWYIJZZTf3ejd7NvkYJtXw505sHS7zjA2H/1kYvuq+SprRC+1ykSrmHBCbhlGYBslUmB9LOu05VJzq1SzcmDgxePw0Q1x20gnoeYQHlyON+Pa0UU/NVvbVro65xyPbuGu/ifwJyatY0GferlfXqoHtMJYAigAncSO2mMq0OrIXooSZbH1YxR9HwPUaq7VcnpmzL4PiTL4gYimtDp4ACl7NC6O9k6dapD/bHhZhXp+l6mPeyinRxHiUO8KOTrP4AYNzE2vHBW0ZAM53zZDJCpP4zba/rpb6B5XZUPHDNG5oKoDAep6S7HwxwWuvVYFREPNyQ2TYY2Pn4TTZgQpZFkaK90bWrP6T5YgREAxnoeYIuD1GrnXMLXeHxhLzIQpb3t65/JsmrWw/JVbR+eex9GUkNi2Fc09VlwtD2IGo0YMllYmUZWTxzkAB6JHh0AfNVafioab+pzgA0SHcWO+QO0vuSEuHOeYAWQHcuS6P59r4M6AFHEc7uLnEtb0C7sr65SRE9petus1I5luZc+LYbxqfv4uX8Rx4TAQqKxZDbZ3sAj82wNxLGJ+l9iiST2wzA0B7iusFRfICucTvp1hO+tkDVAQxFBZ6xeOgKLmLacMIbqpOPjp3lD5lyWS0vg/I7vc7mRSsoAcVucqrj+vftCtPQTt5kchthab7E34XmG8QS248AXQRAi3H9g5IktS5dQ7Nqq/ojWlvk788mDKGuJnlWtxqkmlxnRoK4EMK9pue0wc3g7r9TNgaEO5CtblAYkV0v/7mBok1nlo1pn/zJ28omv
 oS7nxVfI
 1Eg/rUu0urct7KeW8x4HX/oJRuSFb6A1aw/2S4F0+aBDk1VAT2556MwIWgh/1LGnG+5HL4IEDt6D0tj1GbMdvsVfLsJx9jm1arpiHifD2elytvgx9PFDb0tZreleup1wRZ3YqFEuI2eXCyZo2sD77LAxpu23m0gBgyGQqnOCmtMK/HfIgNjnImYX4pnCVB/vowfd/8rkF1gihlElL2FiSeyVTGNPxACEteSouwL/i5Wkd11skWxXaMPirXPDUTpZc1L3v9l0Bp7Pisn8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this small and final batch of non-MM changes for
this merge cycle, thanks.


The following changes since commit 7a405dbb0f036f8d1713ab9e7df0cd3137987b07:

  Merge tag 'mm-stable-2025-10-03-16-49' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2025-10-05 12:11:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-10-15-03

for you to fetch changes up to 90eb9ae35727a662789c850efaf225ffe5511fae:

  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt (2025-10-07 13:48:56 -0700)

----------------------------------------------------------------
Just one series here - Mike Rappoport has taught KEXEC handover to
preserve vmalloc allocations across handover.

----------------------------------------------------------------
Mike Rapoport (Microsoft) (4):
      kho: check if kho is finalized in __kho_preserve_order()
      kho: replace kho_preserve_phys() with kho_preserve_pages()
      kho: add support for preserving vmalloc allocations
      lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

Umang Jain (1):
      MAINTAINERS, .mailmap: update Umang's email address

 .mailmap                       |   1 +
 MAINTAINERS                    |   2 +-
 include/linux/kexec_handover.h |  33 +++-
 kernel/kexec_handover.c        | 361 ++++++++++++++++++++++++++++++++++++-----
 lib/test_kho.c                 |  41 +++--
 mm/memblock.c                  |   4 +-
 6 files changed, 383 insertions(+), 59 deletions(-)


