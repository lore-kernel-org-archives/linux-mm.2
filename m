Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED81C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1126B0289; Thu, 13 Aug 2026 07:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7615A6B028B; Thu, 13 Aug 2026 07:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6785E6B028D; Thu, 13 Aug 2026 07:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 380C26B0289
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:08:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B01E6A058C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:08:29 +0000 (UTC)
X-FDA: 85095972738.08.8731E71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B455C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:08:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzq+bPer;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ulz4BpJ4Po8Y2MvKJhJDY4PM6VLgEsQ3nOUNgt5Cf+I=;
	b=nqtXIvHYnrh4hAo9LV1VSIPDzNQWOZqBGoHrjTVK2cq0bIT3ViGWn01fGq3ZyfVtvHvXs+
	Xnxff9Usa9e0psgh2mVaYiRL4IMCbMrCx93YYsBPZ8Nj55YjquszSbVuHlwOSf+uQc9MoJ
	1sBhvg6iIfBjk3GzK8XAjfv0Q+xg7Ec=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzq+bPer;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619308;
	b=s+1qId83z4A4cst7CGFJiJDO+FdqdYmpe2FI0kZoLe2WOYEYij+VTZd5YpRF8bwbqspwDR
	6ZfjhlmOGX79I2+nvkMCdKq3rwP/Hzc9NyUPNcn3ZCdLMUo/CERqBUsrMGpgL8G8DrCeLg
	r26FDjr6yOV/n1W5JLb/hCBgTkfcyYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A955E600AF;
	Thu, 13 Aug 2026 11:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEF51F000E9;
	Thu, 13 Aug 2026 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786619307;
	bh=Ulz4BpJ4Po8Y2MvKJhJDY4PM6VLgEsQ3nOUNgt5Cf+I=;
	h=From:To:Cc:Subject:Date;
	b=dzq+bPerkF7lMVFj9GsGylafib9JKca3FD3MtAAbv8cZJEhXOxuu3PCeQyBekJWSm
	 3ph+ZaFZppFTzZkEdTNEeDy3yOw6Wcs8hla2XgZcRyGr/BjoQcEE8pqTsd0BPiT8P9
	 F2Z+74rhgfFFnGlJh4v+NhDOI4f44CvZD9uRC/RN0cWS0DNGXF+2a3vQ54r2DUSWCv
	 S09utsRR4rZcNgX+j9rI3rbPa/Tnfi8V1Q/1gl+9VNM/C1t43eiInV8e4sdoCeNMMA
	 T4wVVK1Oauq2K70ZRMSfiLiGaFqXQo4UqKI6oxuVIvhGKv1q52xx8thNmUNFpbCczm
	 gqP111Wb+Tiow==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] liveupdate: updates for 7.3-rc1
Date: Thu, 13 Aug 2026 14:07:58 +0300
Message-ID: <20260813110815.2482807-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B455C0002
X-Stat-Signature: qrk3tgebcw97idttz4i8g87iz3sywri7
X-Rspam-User: 
X-HE-Tag: 1786619308-54316
X-HE-Meta: U2FsdGVkX19hCla/s03HfIBxvdjwifi7iBVT3G7skAIndyPSCXywJ2yBD1H+R5SEwvAhDEOBBma47l9krBtVjtmskNTYa+C/QiDKKCFARndcSAWYLZb1li+g44r71lElPfYwPLS27hCNBuQRVQ3vmonYf05S72YkraDY9rVqipUNocVA0gxmrfPyXAmFct3lg8qEwscXZGtD6iJNAV0hONVtfb9vKW+6HC9cm1ZcMiKmjbx3tlM8DxOboN4hQgRzzSFtPgGS3WrwvE/fd6wPmCWEoxKkOEtG1l8TfdvvqM6JCpvS3DMV3uyvhzvgH6zLvpWwYFqEBhrKvNoI50fiKrgp4P3PgVJcuZE9bItRmukig73JB9OVx34wTgCekKjChyv1Y8dhE8l3dZhbYU8nXNH17MYXr7bw53hXQ/ntGYwQ0xn35SZWyE/WZFi3/zm95BMKVKLdV31W3t6ORGutO4y2zdUs8bCzttFSi9s6UwsZ1FgEIHLmNWYpdTGY2hxqhAatpwI35kcmSBc1ddan9OCRNQxA8VTWcvPy+pajG27uASzU3xoLhhz+RT/cZ4TFOIpPxfxYrboEBbslUGqFLplQa2m4GIn5D1damgEBkuOvh9cpgnDGIQ5AMezB7FoCeVFreyGA9tuaSdJL+uK7ni1GyKT6EhFJOxe+AkxLpMOFsxDV1GL0XVXJdbpGoSnPqAjxawhlU9bisizyJmS21SKDg1rbgUfYQWugC0830sVHnJHLucHNReQAo+s+O3lqXhg4nABXBbSnlzUy1Gg9sQ4FSBjs+o4d8NcjQMb/BAFmX3wztAVKl1sSBN1cZWhJRO2DNqUtuw5uI1rBADbJxVokFR4M3x0XBJg5tJIhjPWQt0/WlslkiL4bac0/LR8m/+RgZUX4nXiLMRNxhzqnrRoCchSPkcZqSH7/H4DHKOv6oXrjFBdR/6/7GotxPBTSI//jCnWvEs1AlLDReV+
 pf5Z34h3
 GHoCnsDFix9Vnbe1BBmfE0oPCtgCeoLBHwc2XQt6KJl4V1u8HK6++DwcLPgln7V4FGsyoMTr7hVCHRkjb/+eEMlLAMikBUV4EI8nZud6W3g4ToXDZbzxoQNRaNLX91LMTBSGXTfLiHD/LUKij1vclrZPD8nyl0DQQczxHcl7juTNX3ASV9Mx9W8oRGuigZC1XZL1GyfleDt1uSH9vhZRBR52PI3Bd/yjSOh7VNHqD+QpRc9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit 797fe91e50d6927f90f0c3b4444277c2c7c8b42b:

  kho: align kho_scratch to MAX_ORDER_NR_PAGES pages (2026-07-25 15:26:30 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-v7.3-rc1

for you to fetch changes up to bcf2a0b55e322a663c9602c9e773770b87d3e629:

  Merge branch 'selftests-lib' into next (2026-08-04 10:52:22 +0300)

----------------------------------------------------------------
liveupdate: updates for v7.3-rc1

KHO:
* Fix size calculation in kho_preserved_memory_reserve() for preservations
  larger than 2 GiB

LUO:
  * move liveupdate selftest utilities into a library so that selftests of
    subsystems participating in liveupdate, e.g. PCI and VFIO, can use them and
    drop direct ioctl calls from the tests
  * add end to end liveupdate test infrastructure that allows running the
    tests across a kexec in QEMU
  * remove redundant INIT_LIST_HEAD in luo_session_alloc()
  * remember the error status of an FLB retrieve() and return it on subsequent
    attempts rather than retrying retrieve() with an FLB in an unexpected
    state
  * reference count the outgoing FLB so that it cannot be freed while a caller
    is using it, the same way it's done for the incoming FLB
  * reject nonzero reserved field in LIVEUPDATE_SESSION_FINISH so that it can
    be reused by a future extension

----------------------------------------------------------------
David Matlack (2):
      liveupdate: Reference count outgoing FLB data
      liveupdate: Remember FLB retrieve() status

Hongfu Li (1):
      liveupdate: Remove redundant INIT_LIST_HEAD in luo_session_alloc

Jackie Liu (1):
      liveupdate: reject nonzero reserved value for SESSION_FINISH

Mike Rapoport (Microsoft) (4):
      Merge patch series "Make liveupdate selftests library"
      Merge branch 'fixes' into next
      Merge branch 'misc' into next
      Merge branch 'selftests-lib' into next

Pasha Tatashin (1):
      selftests/liveupdate: add end to end test infrastructure and scripts

Pratyush Yadav (Google) (1):
      kho: fix size calculation in kho_preserved_memory_reserve()

Vipin Sharma (2):
      selftests/liveupdate: Use luo_test_utils.c for liveupdate ioctl APIs
      selftests/liveupdate: Move luo_test_utils.* into a reusable library

 include/linux/liveupdate.h                         |  11 +-
 kernel/liveupdate/kexec_handover.c                 |   2 +-
 kernel/liveupdate/luo_flb.c                        |  20 +-
 kernel/liveupdate/luo_session.c                    |   7 +-
 tools/testing/selftests/liveupdate/.gitignore      |   2 +
 tools/testing/selftests/liveupdate/Makefile        |  14 +-
 tools/testing/selftests/liveupdate/config          |   1 +
 tools/testing/selftests/liveupdate/config.aarch64  |   2 +
 tools/testing/selftests/liveupdate/config.x86_64   |   2 +
 tools/testing/selftests/liveupdate/init.c          | 179 ++++++++++++++
 .../include/libliveupdate.h}                       |  11 +-
 .../selftests/liveupdate/lib/libliveupdate.mk      |  20 ++
 .../{luo_test_utils.c => lib/lu_utils.c}           |  78 ++++--
 tools/testing/selftests/liveupdate/liveupdate.c    | 106 +++------
 .../selftests/liveupdate/luo_kexec_simple.c        |   2 +-
 .../selftests/liveupdate/luo_multi_session.c       |   2 +-
 .../selftests/liveupdate/luo_stress_files.c        |   3 +-
 .../selftests/liveupdate/luo_stress_sessions.c     |   3 +-
 tools/testing/selftests/liveupdate/run-vmtests.sh  |  97 ++++++++
 tools/testing/selftests/liveupdate/vmtest.sh       | 263 +++++++++++++++++++++
 20 files changed, 700 insertions(+), 125 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.aarch64
 create mode 100644 tools/testing/selftests/liveupdate/config.x86_64
 create mode 100644 tools/testing/selftests/liveupdate/init.c
 rename tools/testing/selftests/liveupdate/{luo_test_utils.h => lib/include/libliveupdate.h} (77%)
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 rename tools/testing/selftests/liveupdate/{luo_test_utils.c => lib/lu_utils.c} (80%)
 create mode 100755 tools/testing/selftests/liveupdate/run-vmtests.sh
 create mode 100755 tools/testing/selftests/liveupdate/vmtest.sh

