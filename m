Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426B6CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9736B0005; Wed, 13 May 2026 06:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6326C6B008A; Wed, 13 May 2026 06:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521526B008C; Wed, 13 May 2026 06:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2CF6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAD3E407FE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:22:26 +0000 (UTC)
X-FDA: 84762007092.11.47749D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1755100014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:22:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pvgZqZU/";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778667745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pr7dARIqK00yCxhYhbkD1anSUq6hc0OaN5jqWiJwO3Q=;
	b=k2dDNhIQYfKBhPPpMYoUZwHWly1Vnpm4BPeKCwh3JXpFrDnhy+a9JGeyFMkNB4pRJq1FjH
	CMm/CBcqy3SeFEGldfdWx4jLPoYnRmd7VRxLS/8T/R2z4Ex8kMXgro0cD8oYqHdNUe5WLv
	HMTKRbZUT4U9M1Hxe2ARI/N33M8FIT0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pvgZqZU/";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778667745; a=rsa-sha256;
	cv=none;
	b=tgNjM51rKXrKmLQ8jsG8mRJMqPC1R3e+N2Jq0F32lWpPWdnVGbGawICPhlhiFP91psZJK7
	pz85PMEAopHgRzbL03YNHYpQvdAkhvtxUO3yqEG3J7HI5BZSz82TdXWyRoIonriK8Kf5MB
	IMd1nD0OnatGT8k6L3qncVbGsCilX98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1C5E409A2;
	Wed, 13 May 2026 10:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE50C2BCB7;
	Wed, 13 May 2026 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778667743;
	bh=1DYgdZzlhmRaiikUzEm1OxduP6ObZQtAfPa74GcnTQk=;
	h=Date:From:To:Cc:Subject:From;
	b=pvgZqZU/12y+6wJxVUEhDGuzGP86yD23cqn7pwJTdOB9Z1awiUX69w2aaRPkNdmnq
	 z62juYMPcbXwCdfroQEAEbOKDW+Dt+eD8VDGaAXdPucl62xwmvYkZ3mLmLBtK7/t3+
	 ApemIKPXE89HAho8u0azAf26rA7W5rRouJFU31SvQ97Z8AIS3xbc6J8JlALSCETBIs
	 gQiDogwno7LNGYaNxedkDBjadltMZhCDtrnTvkT8s1MVqI3l8Q+SsJTYfsmf/ZhUbW
	 NCEfkAEffZejBBbEKUQ9UdqyF7jNCenrCQweAr8OM2cNL40+EH7FLevaKov+TBgMly
	 MvXMqSNQRVTDQ==
Date: Wed, 13 May 2026 13:22:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] liveupdate updates for v7.1-rc4
Message-ID: <agRQ2pV1vsO-MoTB@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 56cdm7iugpxrf389funecx4sy9xsah73
X-Rspamd-Queue-Id: F1755100014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778667744-912550
X-HE-Meta: U2FsdGVkX18T9LXOfJWDJtucMYR9Lfgs2ceoVnK08VdD/7Xh6KrgEYopuDcZlK3Z6U7ONba+pACJS+csl1Lof3NGNON4SBzcqs0DmnrkKCLuT5EEoQ7XcuiKidryQtV+ch8aMGM3154KM8H2dulwOSSWFF7lfDaV9zh4qBjzig123IGxisB0osXicTS5pKEQXulSFm85K2gTREoi43px7M/8CHp5n/bG6H1p9qf7hQNUFmf7hHvyJBOi+f4gPEZgZliZ2xFY5Rf/I8oI6b/WzKV4h5AJotXn56l23Hz/pyTJ9801NlSh84yzEFGRJFcalPF+YDQ2Y4wz9dK1op8uDBspSwkC3s1ZD3Mx9jm5ijgOKDfUQfIfXTHeFm/eHoyBGsQE4wipSvdzR/zO2TUYAl9/86c4rZ2OKucd+upLprA4zdV1UxclosNgkXECT0d7I6ADuuBT9AhHUnhyFLCdpMo9QqGHmPKzT806iHPLKM/OP+9krRaToc7U7L9NPJKYZNrZLFB1AJbbfF/f3VfgZ1+HqjrVmPSQ2yaPdgpOHM9a+LoMoAFKByctuL+IehR+3Ji/AFQsXh4mwNkSkmhawxhOiNLwv+eVTTk0uZR/shsbB/tCCvBryNxTbEoQcIxcPMlKbwD/bE2RfpIkcCXwX1du7lXhkwl1I//FW/fhMlUotJced3KWIGK1d3uFNNVZQoUFKVGFMoalz/1CgjaQtfPzuTHK9lPctQuo5M3rMDpyRJFPcQnrv7mLJPrnkiGp/tbdpOCypsODI5jNJuTNnDjVDT5Ri7zKrp2z7v71ayfKf+6q5j7ltWkYT+Xon3GV2T1mP/yPW21zIq05lPz89QbEQkoAmeOn0Kgrz8XC7PY4p9xqriOliuIidlnEHAEaNGSleOuEztGx0zLYm62yJwKuMW1CUy05dSvKwpsOZhuejt/3DlqdBEgLCBLjfHoTI5JWnV7MPGCilvXu+49
 EtLUqZ2d
 y4hTOpUKbsTsrZXOmiG8WTwcv8A3UoJQVIVlfKrjhEGeCdXN7IqTl1BX04thvi6n0gMIIPwyqtJhUGe9FIRwB8wwg6ojKa/Ias3iKeHwC+tgNnBg/JfjuT7rZ0zcPdCKg5BtdWPa5fweArZJ3Vm/nKCLr1rww0xuNtpqCsy+sP3nlwWRnSstLcD5oN9JvLMrQvWpVHZVPbcEB4wqOkhU041tik/RHtV0EcsYmpL97Oxs+F/cUjrSCBEBqyyzGklGhXS2ClgvWmSTSfXrelFj+xlOYbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/fixes-2026-05-13

for you to fetch changes up to 7b0b68b2b95606e65594958686833e53423f58f2:

  mm/memfd_luo: document preservation of file seals (2026-05-04 14:03:16 +0000)

----------------------------------------------------------------
liveupdate fixes for v7.1-rc4

A few fixes for kexec handover and liveupdate:

* make sure KHO is skipped for crash kernel
* fix error reporting in memfd preservation if it fails mid-loop
* don't allow preserving memfds whose page count exceeds UINT_MAX
* fix documentation of memfd seals preservation to match the code

----------------------------------------------------------------
David Carlier (3):
      mm/memfd_luo: report error when restoring a folio fails mid-loop
      mm/memfd_luo: reject memfds whose page count exceeds UINT_MAX
      mm/memfd_luo: document preservation of file seals

Evangelos Petrongonas (1):
      kho: skip KHO for crash kernel

 kernel/liveupdate/kexec_handover.c |  2 +-
 mm/memfd_luo.c                     | 25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 7 deletions(-)

-- 
Sincerely yours,
Mike.

