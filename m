Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD7DD13C3C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2196B0089; Mon, 26 Jan 2026 11:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8F56B008A; Mon, 26 Jan 2026 11:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C9D6B008C; Mon, 26 Jan 2026 11:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F13D6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:08:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F9F1140855
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:00 +0000 (UTC)
X-FDA: 84374596320.22.CC240C1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9C7540018
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:07:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bjOAzm9v
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769443678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZW3LbSobBIE/Z2jyZt9UDCEFz8BsV1FxKWKSGSxyUDY=;
	b=16CTJ1a3+qW/suAZ5Sz4rqY3j7M15ZIGZ5BZ+vCR/K1OW0LyE8/U4FQsZ2NQDm7TW+EZmu
	rahidlUoWbKo9vv1jfpk9c7uZeig94CQT7o/DV/SolBG2P2uI92aZH8yxzkdFOIN5lJCa3
	EPbj44PyM/bp9ksZzJN5oCoIg75+XXs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bjOAzm9v;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769443678; a=rsa-sha256;
	cv=none;
	b=JkrWDu+cfvn59rIPCV5Qzmvm3MGjuQwZXncosc4F7meTeH3v5J4VWHIqKAkwfQz9TOL6NQ
	RMFSxckrpdM5h/T0OMQTxeZZmOk2TsFhnOnKGkJQ8TrtxRgWFooY3oE+XcOAf4CGkeTDmA
	CpfFQDYfBlFrJAne+84R2sZUxvKUI4c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZW3LbSobBIE/Z2jyZt9UDCEFz8BsV1FxKWKSGSxyUDY=; b=bjOAzm9vtMP4ZEvMIyGT7p/ZhZ
	PUYSRaZMfuRvucznOxAUu+r681bLgJy/lNIaR2sWRxecSiry1S5qz2dd0A3xFPeXGZwWihg+qYxLu
	/SZYN27qRIVAoiI344B5c88grbzkFucPeH6bw7+Tm8YHuN8xDMoHn11/NQ9fqNrEu+UwMkQCESpBb
	QTKZcNAtXhJPAai/MScpmksAWbMh/WA4DFYyBpVRWdNAwgKMpOpMDMVqbpPoUCaCBQk75aqDmXDZD
	eq4ugJonxrY/MbajRrAjtDhMjg7soNyF2/d+VY9hsx1WaN6OIDZkfM1bjrCMTBnCnCyjDjl2lRpKX
	N32Vcdzg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkP7y-00GI7A-Gp; Mon, 26 Jan 2026 16:07:47 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v5 0/4] kho: history: track previous kernel version and
 kexec boot count
Date: Mon, 26 Jan 2026 08:07:22 -0800
Message-Id: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADuRd2kC/2XNwWrDMAzG8VcxOlfDkp3YyWnvMXawY6XxBsmwu
 7BR8u4jDYOWHgXf768rVClZKvTqCkXWXPMyQ6+ak4JhCvNZMCfoFbDmhtho/JwWdE478YFlJIG
 Tgq8iY/65Vd7ej7t+xw8ZLjvdF1Oul6X83t6stO8eiyshoU2uawLbFDp5TRJzmF+WcoY9ufI/a
 jVpPhCjRnLWRQomUGqfkLlH/kAGNUZKbXTBd8byE7J3iOlAFgmbwY/iXGy9tg9o27Y/TIt1Z0g
 BAAA=
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3984; i=leitao@debian.org;
 h=from:subject:message-id; bh=JWdN5ALVSvxCTZbbbffDLUHfmxM4JPZ0+lFI+jYhOZ4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpd5FNHy0h/eLhMvXQCGWmb1NJbB7x3fo6neNCf
 8MoHIQ4O8CJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXeRTQAKCRA1o5Of/Hh3
 bZ3BD/oCW6ztbhlFifriebt2pOEFjOqQAlQE72skmOP+bELWcyV2ekcnoA47N/lKLa+38GAZKoz
 M1PceiHLa7+u0CMdNQB748zGAmRaan3JkEaCohbf4t92peLFxxiEpp0mhvH91ORLANMlLTqZUrd
 B8tUobTUWtfdnPkNwJRz0Q/O7r+vG4VWpDLUUKxcGftFtmyFlfLLGT6IfuFLud2NNb+pkEVQXLA
 OZYqKvvTHCTALkoK0Wf9eqxVAAZhYVRkeZzEKXGjH0Q8B4+TRNINyDf8HBD2QOMueHLCqzEVHug
 SPDVOrZtAtV+VAWdKdn1EO792tu51g+nJc2V84ws5PNFZWQHGDCLXAZXgq71vDhy/ARx+fZ1jB1
 lT3CWLtkipozqTvBHXZqK7Pu/26Chn+krcrs5dRLJLo50Wb06NCJJUQbB8vnynILtSpC76chEwR
 aNA2DbqgOLZi2IBURmEUjnzNhJfbc6YmtwmE40C+zBL6vzjaYFUTccD2y1L47BBmU+gQ940aQRF
 J2ZDA6OhYV6m3d3yYoqChrUiUb7rfTuP1o/jVcachXeRdckn2f7VN1WL1MaBxb2pAKgCHh6PxeE
 ApWGp+CvRlOSkIwwsp/8wiGU01P6bmPP2Z4d9N3QnydqcGatXEcQTmsll5byCDSIKH5qcyQPj5B
 GDfBkwWURN9TyLg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A9C7540018
X-Stat-Signature: uy76aajh4n8u5bffzzajs3qbo5ukwagh
X-Rspam-User: 
X-HE-Tag: 1769443678-684616
X-HE-Meta: U2FsdGVkX1/A3vbTsr1NrU2PN6LGidDgZwor5k2DrXx/GzKRqhpIoWuOWtHyTl+5xodws4SwJwpuADI2dRTstNQ2oxG9o9oRLSpwDIdBeql0meBXP8LOgT+45wd1AiTtdrKZHyKMxTjH5hE76PkIlFPnR7TNkA65iRGLyiMvW4ihumL+hpxf7Asu86MUIygrn1f4QqLoRQtnsRRbBf/k57dm4vN3lWusy4tRSjuBI6Vh2KQzGd7jAzlzKBIlmY6jQPsL/Gp1WYg8mUIPMjd2Lh9F/bvUKbj7nPPINOdsfCaIhmI5yRd21QPWMxWy6FGsrhnJqFucME9dd9Ba4igZb6r4mW8tFqeJDsTeZvSa1moZm1k5E3h2ZnbT8mf/C4KbX52EHriSNWQzzmljlxK9S4IeT6D5xZFEFCojzqOXpLghftiydPCFgG6/WvBf/DhCgbyaPjHv5QJYaOe0+ceeV5X4fywngj69ZMyvFFlI8NWHT8GuRcdDUhr0G1LRhyQGbj6whIQW4eAT6f1ejlnHwnBcUb6sKjcNtOLOamXzXavrSNO2kicys9WWP0M/TE9yjl1FSwNO30VhbLk0mU4IW72tO1wei4aksR0AZweUV1aw2Izq1x6NymUirLvjbhHtHc/h/khoD0obW+PSl6TEMeEDY2NziEIQSpGTb9q/V+V1vLgc5n9rDDdlA+2KvVCd2eyzC86PTpfh373uXKi60YVvEzSJ3QFPsF3zy4NfhbecJvMrw6TgbwXg3+QNKPSSbcKUCcfiroFcWY4KyT4M39V4DlL3JDYCXa+h9K9qsRYGVNienx2Eyv6+LnxhpgKvO1b/aQRiPaaLUYSahFobkse+ELWR+kD7K0nUDUKMLDpt2xogzIa2GEyX8khiFfbe8Vf9aHfA+Z6bqHvDvhejsE+4vYCauGDjZJnQoadxAihI+yh3nR7LoInokYgTLE5mMOIpJ6PSWvW8/1krSLI
 ALvdooRs
 RyKXcksA5hREKGhP+xrTRzSlZy8WaJ6aBcmftE3vg8dFHcQUvNmbARfN/14ZlZOya/5+GfEautDPxO7cBOrc1TY7WzgYTKa8/mdFuD4uTC5Jj5ogyiCg5UL+9KiANO3A6INT5Ew8gVBiwqUqUg4zcyzuiY2FquzEvGZv1prKFjpCn63abQE5Tp8RiSS1IiCCEtd1pRfxV62WbRZOLv2roz1oM94tt3NitSkQrwvgCzAi/VAmOTyf+6TlJSVzFcD67MbtsH2zsQl1EiW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Kexec Handover (KHO) to pass the previous kernel's version string
and the number of kexec reboots since the last cold boot to the next
kernel, and print it at boot time.

Example
=======
	[    0.000000] Linux version 6.19.0-rc3-upstream-00047-ge5d992347849
	...
	[    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107upstream-00004-g3071b0dc4498 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions
are difficult to diagnose. These issues occur when a buggy kernel
kexecs into a new kernel, with the bug manifesting only in the second
kernel.

Recent examples include:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently. At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only
occur in specific transition scenarios.

Some bugs manifest only after multiple consecutive kexec reboots.
Tracking the kexec count helps identify these cases (this metric is
already used by live update sub-system).

KHO provides a reliable mechanism to pass information between kernels.
By carrying the previous kernel's release string and kexec count
forward, we can print this context at boot time to aid debugging.

The goal of this feature is to have this information being printed in
early boot, so, users can trace back kernel releases in kexec. Systemd
is not helpful because we cannot assume that the previous kernel has
systemd or even write access to the disk (common when using Linux as
bootloaders)

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
Changes in v5:
- Add a patch to document the new feature.
- Change kho_add_subtree() to receive the size instad of guessing it.
- reworked some code path to make it more standard.
- Link to v4: https://patch.msgid.link/20260121-kho-v4-1-5c8fe77b6804@debian.org

Changes in v4:
- Squashed everything in a single commit
- Moved from FDT to C structs (Pratyush)
- Usage of subtress intead of FDT directly (Pratyush)
- Renamed a bunch of variables and functions.
- Link to v3: https://patch.msgid.link/20260108-kho-v3-0-b1d6b7a89342@debian.org

Changes in v3:
- Remove the extra CONFIG for this feature.
- Reworded some identifiers, properties and printks.
- Better documented the questions raised during v2.
- Link to v2: https://patch.msgid.link/20260102-kho-v2-0-1747b1a3a1d6@debian.org

Changes from v2 to v1 (RFC)
- Track the number of kexecs since cold boot (Pasha)
- Change the printk() order compared to KHO
- Rewording of the commit summary
- Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org

---
Breno Leitao (4):
      kho: add size parameter to kho_add_subtree()
      kho: rename fdt parameter to blob in kho_add/remove_subtree()
      kho: kexec-metadata: track previous kernel chain
      kho: document kexec-metadata tracking feature

 Documentation/admin-guide/mm/kho.rst        | 39 ++++++++++++
 include/linux/kexec_handover.h              |  8 +--
 include/linux/kho/abi/kexec_handover.h      | 31 ++++++++++
 kernel/liveupdate/kexec_handover.c          | 96 ++++++++++++++++++++++++++---
 kernel/liveupdate/kexec_handover_debugfs.c  | 15 +++--
 kernel/liveupdate/kexec_handover_internal.h |  5 +-
 kernel/liveupdate/luo_core.c                |  3 +-
 lib/test_kho.c                              |  3 +-
 mm/memblock.c                               |  2 +-
 9 files changed, 177 insertions(+), 25 deletions(-)
---
base-commit: ca3a02fda4da8e2c1cb6baee5d72352e9e2cfaea
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


