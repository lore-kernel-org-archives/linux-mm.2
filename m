Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3286F606A33C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqTI2cWq
Received: by kanga.kvack.org (Postfix)
	id 1D90F6B05B1; Fri, 27 Nov 2026 07:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189BC6B05B3; Fri, 27 Nov 2026 07:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0526B05B4; Fri, 27 Nov 2026 07:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91B86B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:25:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62C661C3540
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:49 +0000 (UTC)
X-FDA: 85480820418.20.0707664
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB764140007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqTI2cWq;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782347;
	b=DHvCZJ4xC5gC+tkO5yBs0A/oHVpnz5Kt7edMtJmHSp0s3cc4r1vLgvAuuLNAl/dv/JcaQv
	DySuAWvqx7sxQKrIa6SES3whHrX+KspxSnj+sihQcVuD4rBGZpOTq91AY6JVqkf6yMQH64
	2zitlfazIKy+ujrG9NRARPC5bwTIiAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vIra0SPO6KCMA7V7+wMdA0YK65SWM0LHFYgUPK6Xstg=;
	b=TIeTCUMcLDkF0U9PAkxxL41qkrQ8R3FuxiLW0bWk4BF0mO2YN7pd299S3ZHsoppoZsA2Et
	irF031PmDEPO+bxwNBRtJ6Gzej7su+RZTKfBa6kpAe8g1IxJxe3VoZU4g4Ptr5rUPeDERs
	HrHcu8O2UypTqGOnfjLgbZtA1emLCiA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqTI2cWq;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5102761D96;
	Fri, 27 Nov 2026 12:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1CD1F000C1;
	Fri, 27 Nov 2026 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782346;
	bh=vIra0SPO6KCMA7V7+wMdA0YK65SWM0LHFYgUPK6Xstg=;
	h=From:To:Cc:Subject:Date;
	b=NqTI2cWqT7sayH9ORaHeylVAF7fwQWncs7cD1N5+FvdBR+UTvK99Alc4u8fqJafnE
	 UZ86EaZGc/EuW4a0MJrKqXsyQ8vQXSr8yL+e1C6Nobnr8pCzSPZK21j6YlULugFMmy
	 R7e6RX27cnS5xW1ZtCxapH03I4ZLO7oRXvUXi+Wxe4L4XuR+X5bVnlXO7yBqxQnztI
	 pRFvRynI9ct60n6Jhz/RmUpKwi7PjWmNDUPEjm7keqf9tiZqIJcw2oDloU2wKC+vtr
	 EMvlxd73jP4ZtLE0d/kQftOpg9E8r+U8WMdPCT/CmUQ3TPBcl8t3ivNicv/1LtntRD
	 HWZWcPjbgMMyw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 0/6] kho: housekeeping
Date: Fri, 27 Nov 2026 12:25:26 +0000
Message-ID: <20261127122536.3708770-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB764140007
X-Stat-Signature: qex6aj8xeutk9xihm7j8sxfnhbpjowqz
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795782347-225204
X-HE-Meta: U2FsdGVkX1/t105FCW6IRzgVMSpWVfAOU/C6ts2rEl2Ll+x9VI5qAR62JJOpaxDpo/aaujA54PTBAujJ4VTz7VwLk4+98NnM2avR4dPbCbUlj3GTcWPlo3GuHKdpL2xJO3dbD8E653fG9ZBprEEPPTforiXOCUbA6bl+Voev9CI9AZXUyb6UAt0UNstXOI92J6PDe2FqIZ5bXJ2cyJ1rBzPBaD7ztmQbk8ypoWbUPAVcW0kBY0t9TaoSL3G0+2aOj+J8NwYl0uZoCie2o9keEC8f3AC56lmz1Q9WLLJUIPJZ9aBfVzXDfGuDA73cqaJXWLE7lQsq+iSoyrAWVG3pu19MBDtxo6oTlexN7fAV8eKyy2NM87wJu0Fgqv8DUJMWN1D+nwtbCTj2foo1+Tjqkb3jixU102rUq+wunOH+oMYBKqtDejHLkxNZiQ83csNrcp4o8tjZncMWIIyt9bDN5UD0p7JoGjil8+OcsLx7QcADtRsTOA6VOB65nsAPgBv9IyshTkxE/hKVJj26yOo7cikmceCzikYcvRZIc6j5nDL7CYuxqWUWB4zanZYWlc3e0RKhxlIt7ghvo6oKS/j6UzLEzDA+r4+yIiXfTdcdKM8fLKyKs3uXkUOekp7hxHfCZ1KysOgw80lKH41AnAZ6q0jwqigPoA8ySrMRzEZDau16Ap92PWQZCP5nPLOklQX2nxRhkawv3feviT2zgUqGZgsxhQLypbxEAw7rSVu+lWx2b7AYgNNoBPyZVZ00lIK2LIzcYDAbGY9AmiTLkJsRQQuhyoOnw+RKmFxu2gLTSmajCiuhC8cpowXvi9pO721r2rxk08UjZJvI0Ny35RtW/5WooAEMRZkMKTTMBwmwe8CReP+XO5kFp2QF9zkjZJG83Wi5BQmnXjvwSc01AwR/pTBx789vSjUmYT5MbmVhIm+H8PWdiFoWs+ZqYCisO9melgcURUZaYs+C8a+1O/Y
 KkDByLxy
 wL6NphEr5IsMkEtppom7mSVSkVdWzgDEyXdYYd6ntHvkTyWMwL3KHTnivjtmkeL17t6xMEV+GmMv24j6Ezk6+nbei81wfMjqdcxC/0RKFGRKDKQy3VyxuGLcQwG2F6EGsEJDBQ3NRtQIHupdxSHzmv+Jmox1SzYCXFEU+EBKpDc1VtswsXIuzZI+0/CDZ8eblAoBLFO+/DMNsjs703FI5uJh7AViuumD4PSZs/AYM/s1kLMDc604y2Ks23ZeHNuYGzkZKAeVrAS50ArfQhZ6d3SgHYM5B0V/4lY20P+VD4hnw+tcxbKNyrqf2iUcgRCfV5zuhvPkLeiYI3wQETB2m8Z7KQkZdlCGJUZQSYnmp7QfuVxvlyf6PxRSXrKNeXzHBuj9jNtVuE+7dFABQK60J2yGGOfEI1avW8SikOi5nCCN6XISHH6hiCdEUzgfJpPL0qQBHjjY19hsG5iU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series is a collection of miscellaneous cleanups for KHO. The
patches are all independent of each other for the most part. They are
kept in a series mainly to keep things easier to track and manage.

Patch 1 is lifted from [0]. All others are new.

[0] https://lore.kernel.org/kexec/20261116134013.1636689-3-pratyush@kernel.org/

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (6):
  kho: build KHO objects into a single kho.o
  kho: use acronym for KHO .c files
  kho: move kho_{block,radix_tree}.h into include/linux/kho/
  kho: use unsigned long for kho_preserve_pages() and co when KHO=n
  kho: fix kernel-doc return for kho_alloc_preserve()
  kho: don't reference subtree blobs as FDTs

 Documentation/core-api/kho/index.rst          |  6 +--
 MAINTAINERS                                   |  3 +-
 drivers/pci/liveupdate.c                      |  2 +-
 include/linux/kexec_handover.h                |  6 +--
 include/linux/{kho_block.h => kho/block.h}    |  0
 .../{kho_radix_tree.h => kho/radix_tree.h}    |  0
 kernel/liveupdate/Makefile                    | 12 +++--
 kernel/liveupdate/kho_block.c                 |  2 +-
 .../{kexec_handover.c => kho_core.c}          |  8 +--
 ...kexec_handover_debugfs.c => kho_debugfs.c} | 54 +++++++++----------
 ...xec_handover_internal.h => kho_internal.h} | 10 ++--
 kernel/liveupdate/luo_core.c                  |  2 +-
 kernel/liveupdate/luo_internal.h              |  2 +-
 kernel/liveupdate/luo_session.c               |  2 +-
 14 files changed, 56 insertions(+), 53 deletions(-)
 rename include/linux/{kho_block.h => kho/block.h} (100%)
 rename include/linux/{kho_radix_tree.h => kho/radix_tree.h} (100%)
 rename kernel/liveupdate/{kexec_handover.c => kho_core.c} (99%)
 rename kernel/liveupdate/{kexec_handover_debugfs.c => kho_debugfs.c} (75%)
 rename kernel/liveupdate/{kexec_handover_internal.h => kho_internal.h} (87%)


base-commit: fcddbfa7a3693f1225a4d32b28401543b3bbedaf
-- 
2.56.1.839.g22a8290db9-goog


