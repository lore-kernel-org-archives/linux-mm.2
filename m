Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6168F606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 11:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TRNbwXhW
Received: by kanga.kvack.org (Postfix)
	id 8B0296B0A89; Sat, 24 Oct 2026 07:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886A56B0A8A; Sat, 24 Oct 2026 07:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CD26B0A8B; Sat, 24 Oct 2026 07:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC476B0A89
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:22:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB86B120344
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:22:06 +0000 (UTC)
X-FDA: 85357280652.05.58FC094
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 63C65180003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:22:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRNbwXhW;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792840925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cGiQ8OTVAeX0o47MTz+ktInH/fOBwJghtHtytzaWqSA=;
	b=rfT7jnuuNmFOLFhQiajKe7Gi1AhigiWXE8ty/SzanUtQ4u8t134VouOGUshugVzUCuB+Ar
	lbk04fZ79WM8k+2xcsLp/vcbVdWKJ27VbGCbNyJNVTRtpoq2tekfbRoXspiDu8vDKA3vm2
	Q/bzKsfAEKhjqTIDgeKcq68eBRwPmP4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRNbwXhW;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792840925;
	b=rvagTWoLQIWMtpgOBft/7nXsWwH/poV22h5mE+xoS4J+ZRjl+0SHmawu6sHspiQudmF0fn
	4VBrHIYeIO1tAOCXivYymA9UQ7w/5LewPJYMraWET/eb4arJ9oJNW735t7ImdEzj+4TzL+
	P7Xg1Uc8lC6BwcdDENlosDKU+XiLfoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6D1B60A52;
	Sat, 24 Oct 2026 11:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA88F1F01825;
	Sat, 24 Oct 2026 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792840924;
	bh=cGiQ8OTVAeX0o47MTz+ktInH/fOBwJghtHtytzaWqSA=;
	h=From:To:Cc:Subject:Date;
	b=TRNbwXhWlrh6M/1ClNTKGyPNstnCcPOnZb6JJKfrQxHhK7/JK+RatDhSfByg57hNX
	 6oFHvIvyDJMBVMWPyZS9ugRtKgj4cqHmurv4A3xBJZMVjjPreNyP/DIMecHI4gvKWl
	 kva6WY1FEjD2e5PiBQCCZ6x77//aFUiU/7AtSgCapiJRh83Xr1Ohl9YqG4B86UjD+x
	 XpEeuXs799qQOIV+vDIJNnIsTTQdJLWZxjYVKpVRQcHYLPPdJnyH0KEKW68/7J31yu
	 DJZTU9CGZQRYpK1z5zfgDBumgHjN9fy2xKKHeyALrUhXc6iTrXfkgmtUayzEeqLwkH
	 NeqgDwLuidrqQ==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] kexec: updates for 7.4-rc1
Date: Sat, 24 Oct 2026 14:21:54 +0300
Message-ID: <20261024112155.3384616-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63C65180003
X-Stat-Signature: zx4wb8o61surw73hwynd8drse16qimmq
X-Rspam-User: 
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792840925-789047
X-HE-Meta: U2FsdGVkX1+co4SkMDyiGsiEtXlANHO6OKlMDJRsgK9X/TxJkKARTIuEVe9K7AV/1P/SZPK5r/I+5RAfTy1rSbd7bIUzI2u9XLKR4/ZliQUc71kp2eUIQOQEtUr2V6w65JWzA1wFCnbk+F8z/VpnUBIPxRoGCT6cv+sJbxEIaRbfikdUd5ruHN278EL5VIj8QrrAsq307Jnv8t2F0lQ6GBJiVuEyup1dxDw2zGAERcDnRJc3Pe1xdQpI0731tpw/bYzquCdKeJYedadulsZngoW9Tzp5pHuRAllfrIJPd2LEGZ0Zadaou/Ub6l8IL7693uUAFChiO4g77INT9Mc3cWcqvOl1cuLPBw499nIG3HBvc0e2w2U/Qav83QR1WyPU4PsuuVF8LLRCIupeH0bEKq0JKHpVR5seMibRK59KB/kqrNOYxtl8Yll5Khfan6HkTHgyBrzgCHtePON5ZNAEstQQDA8i3hE32FKCXMlIiJGJGqiA0wSCDjejNMwzLePsNd8FGggZGXxyN9zG7zIS3wHaXWYOlIv9I+A6Ojh4svoMDRptBYzOYTzV2CY6TU4+ow6Be9RsoIA/gFNXolbqD6NgUzVRqKWv7sWIf5vZwGI6Mk7PTBVTijp3+Zc1Lvb5NFeJw92sdbAYtL6XWwf2kKYLOVY5mFJuWlFOFilOeyUXyJmVUi1sWiKsZVMcOwS+gI2xbnaoaWug2UkZvfGSkt6HsU23oaSp0zMhfaIaDC68ApCQN/b1HDkTYbq2C6sdgA5yTTbec6hd2UkOhv416jIrQf1iuChemt6mpaEvDCiUTEL6uv3QFfQYYyLpVYDJp5bhdXKoqJYi7yxcQNI+pPkPTpPkGgRQ00ApL34bdN612cTqTCmo1rnowtGRPWhHMWrfoCSCnx5Yu1L2T7MO8/0sPeA0DYAZy/oizQGRWe2EtSSdhx+HO6jhER9TLzrIZPT3/JiUu0JZe0DEFP3
 0/6i2pe8
 J/L/zs9+F2fm0Aujigd8+AnQdBdR6bk/ps8XHWSBbktSM9PprlHq2UjUfNFehzgLc80NvIMI/sIkGreLUG1mc0S53W7sw4rh168NV0NlbNsmyHagLKZ6OH9J7L5f41G83JR4N1OcbhNSaZ1lfZsKRyoNvp3ZqHMVOQZihUgFDy8uB6CmbUrVY3j9plVtIW8V1C+5zJQlVa0dZmQbBOshyhpKsHJzx1jcSfBEpoztBfokob1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/kexec-v7.4-rc1

for you to fetch changes up to 833d2b79ed9520e77c5d83eb11644e5239b2c5bb:

  Merge branch 'kexec-7.4' into kexec-next (2026-10-15 11:38:21 +0300)

----------------------------------------------------------------
kexec: updates for 7.4-rc1

* Fix probe error codes and error propagation:
  * make architecture functions that probe loaded image consistenly return
    -ENOEXEC when they do not recognize the image format
  * Make kexec_image_probe_default() to distinguish image format mismatches
    (-ENOEXEC) from real errors (e.g. -ENOMEM), propagating real errors
    immediately and only continuing to the next loader on -ENOEXEC
* Make sure the next kernel does not land on hardware-poisoned pages
* Remove unused arch_kexec_locate_mem_hole hook

----------------------------------------------------------------
Breno Leitao (2):
      kexec_file: stop the top-down search before it underflows
      kexec: keep the next kernel off hardware-poisoned pages

Mike Rapoport (Microsoft) (4):
      Merge patch series "kexec: keep the next kernel off hardware-poisoned pages"
      Merge patch series "kexec: fix probe error codes and error propagation"
      Merge branch 'kexec-fixes' into kexec-next
      Merge branch 'kexec-7.4' into kexec-next

Mukesh Pilaniya (2):
      kexec: return -ENOEXEC from image probe functions on mismatch
      kexec: fix error propagation in kexec_image_probe_default()

Sourabh Jain (1):
      kexec_file: remove unused arch_kexec_locate_mem_hole hook

 arch/arm64/kernel/kexec_image.c   |  4 ++--
 arch/loongarch/kernel/kexec_efi.c |  4 ++--
 arch/riscv/kernel/kexec_elf.c     |  2 +-
 arch/riscv/kernel/kexec_image.c   |  4 ++--
 include/linux/kexec.h             | 15 ---------------
 include/linux/mm.h                | 14 ++++++++++++++
 kernel/kexec_core.c               | 10 ++++++++++
 kernel/kexec_elf.c                |  4 ++--
 kernel/kexec_file.c               | 34 ++++++++++++++++++++++++++-------
 mm/memory-failure.c               | 40 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 100 insertions(+), 31 deletions(-)

