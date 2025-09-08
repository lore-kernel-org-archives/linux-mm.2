Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 642F0CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BF08E000B; Mon,  8 Sep 2025 06:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCB68E0001; Mon,  8 Sep 2025 06:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A1A8E000B; Mon,  8 Sep 2025 06:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2918E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:35:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EE14C0AF2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:45 +0000 (UTC)
X-FDA: 83865727050.12.F3ACF3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7A3F14000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p44JO1TS;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757327743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aIyksWTmF+WPRQfDWNQ3wfYCg86aJi793lKO/e/geg0=;
	b=peOmjp3ew1FFkB00EriBJnFT8w9eKlQt3kbqSW4ico+s9njZhiBAY9iqbzq0BtjlHEU3Kr
	muTvcN8m0qwgwNZaYfEapMRut2/CCNl4pL6BIJZcD/+//xOtI1nuWr48eQrAOHxpecnmin
	7Uo5Wbry3ZbNnUj0xloSB1NH+BtEiwY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p44JO1TS;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757327743; a=rsa-sha256;
	cv=none;
	b=nwpB7DBRbaxlEONvBhxBLbSe48npi57hNeb5X0HveZux1NQd2B9c7CkspB6IW4wkztYVQa
	2OjrcEETbr0XfGwQQa2/qSdauGWled0T4D9XbEm2rY83E+XvViqnrU+HIjc5EJHUlJkXtW
	BTbNDWwA/eaDx7mkvl0Ax7rRIs7Y4ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17826601BD;
	Mon,  8 Sep 2025 10:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55DBC4CEF1;
	Mon,  8 Sep 2025 10:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757327742;
	bh=Y+6NT7qGhfiYpIQPVV4I0mtOFqnghk5yu59oPQEuT2I=;
	h=From:To:Cc:Subject:Date:From;
	b=p44JO1TSX342echla4JuExSua0T7EzB6vp6j6Kh5CjErmbLMjkm2x/e2lrPzDDv0S
	 kdbLO12BAAf5rMEqTX6Ucz9KLEGP7l3xb9Jq172uruMlKx0uJuuGUGXO774e1GOeuy
	 bPRaFS5AHdICB0FuSMuBBYbcWuxG8f1PCmraAAKhdNANdTZcTDAlIc/2olU2cpoD9d
	 qGrZeggsIMXg6A220VwyyXRBJJFrN4/asEYEj1y3l7S9v6zjqxS8xF4BsL+9psPGP5
	 wDUL7IVuAY2bNYB6tsFyLLKpQr/N63XArOFc8MpPDfHpUQ9tnkK0P9Mv3cxZmyBQah
	 v5jQDBQvP1Amw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] kho: add support for preserving vmalloc allocations
Date: Mon,  8 Sep 2025 13:35:26 +0300
Message-ID: <20250908103528.2179934-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7A3F14000D
X-Stat-Signature: c1mizakorjb65dzjt6z85aidnosz6t5m
X-Rspam-User: 
X-HE-Tag: 1757327743-865640
X-HE-Meta: U2FsdGVkX18ksz7SYAoQyUSTEjtMiC3U5TDb1hFYtGovHahLsdtkMFSZX0EBBgAt3+ODj15VCov0HHIFq+6hK0il/6tFEggqsgMY0LSaKv44Gr58ALOex4F8qrPa9sJDi8fSi12dJD0B6s75HV7MPB5NUuvkTkgew1feblXSUIqyB/qZbYFxVWGium9T7M94/OTOcmyMTnVXKoALOtf/XLkqVy2dP99O+7YDCxI9wOp5uLJ8Cev/AvmMY0zF+Fp0EIeeQoL+s01sf7NR0DuSARQditJZabRfMCDBHCgkCO4RVgU0qFRlrtk8dpt05M6wLMaeAbipZWRolZaOGmnHB9Hbav6TpIGv/P3JWI68CeekVhrMm5MmfZpbFiiARogIyQbBb5rUuUBpVII/P9yxs2W4/BNX8kt1guC9t1ei1LXdjfW7vXRrtqxOehP7uekQjp72SIVUEZLe1qCeh+7FXZgcQc1pBIQdU0riaBSPMq/J9OhtWPP4CSHfO2f5FMZrjbqEN9J5tYKuaR8J684LD0L5hq7kOLIMzwyVYxRnFYa+LAihiB2XBSPMvty2LY91ktUsDNyW9tMmeXYy4DPwXGLMorGXoUyPmcEaLRxFcmYPQpZe+/cH9zrf8AezJ2b3cWmFiRgdlYrINSoVJu8sJT6C7y2v+Ik9t5mOkZu4zJGE3MUW8Kn5U4kU0tVAdd57NhFaVkm+qCu2A+etyqmiK/jOsA8MJs7WbSINnwqOeRuv2yy9m+Ivl2+GBnj+QzcnJv+0R4GbI5jje2SsHmJp0g8RUbkb2fwCUhtcVOfTbdSRE8pGG+cknKWcm4yBUyAMTiGNO3waMJRaD5pt9QaZ4C3SivM33z59YfOp9fR3XZ9HNEz2Z9lIn4dY6v0PvPb5LsgdrP31LQI+BmvliV0vDeAFdnqAofIeSxxQY6EmuiadNXL0oqI8nHTJen2eYsbok5npuvYGRaw6SNazk2N
 9SlfUY1t
 sp9qGSVQ40tb1YcEpQRMQ58zXhP5mjopvpA3xPWp1sYx+ujpDWrn62CFtWrm1gVO4Ln8epbyXoepXc+2hYstFqpmDUq+dXsZiAMtRB5V08ZNrOZt7NlqfHjHXOpnDtjjWHUPggzF3YLSsKf6RpA1FhrNWMfuYltDp/atXUIavrNzYc2ykD/6XrFRWjMVnS4TmVEVd2HYe2nhv9n9LHUnDJEe1J2kMv0rEXmSl6nfcmZ067PBjOqFEgBbA2ktwQ/MB6+Q5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v3 changes:
* rebase on mm-unstable

v2: https://lore.kernel.org/all/20250905131302.3595582-1-rppt@kernel.org
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  12 ++
 kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
 lib/test_kho.c                 |  41 +++++--
 3 files changed, 241 insertions(+), 12 deletions(-)


base-commit: b024763926d2726978dff6588b81877d000159c1
-- 
2.50.1


