Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D15F9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1492F6B0088; Tue, 14 Apr 2026 16:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121196B0089; Tue, 14 Apr 2026 16:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E356B0092; Tue, 14 Apr 2026 16:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC2196B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E69F8A89E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:42 +0000 (UTC)
X-FDA: 84658234164.30.677D11F
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA4B92000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dBdMq4Yn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196960; a=rsa-sha256;
	cv=none;
	b=RYMC6DkWscZ5ZdC8lH0OP2qiNyt1FcWQeHHnKYuKPDBNgti3M4j+zj0nGg7e1B5YRCpbv1
	t4hR9nSJh8ynvX3HiModtVbi9tnin0b+X93yFhP2iOFvtkLkNX613OEa7N7lJoLAQ0V6HK
	36+Heecfzovg/gPo5zPYk6AnfdOfWXc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dBdMq4Yn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1JKwITjeCygFFMWgjlHnhRhK9rZVbof5rkADvxp5LiY=;
	b=0mvsKg19N4BR6xmzyo9ftafuZ9Jp1rQrEPIFcpReuWPhn6ndLf/zp5+XfquxV0HJih+Yfe
	2OMH9y+g7aDJrq+dtBNUh7RX1OuuPSPoMMx0if5dXhUORAeBsDuXvIi+XHHvW23T7Lf31C
	3+BHtd1Nrp4amgpxI7NTUS2VFb0WISQ=
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-6108228a851so767781137.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776196960; x=1776801760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1JKwITjeCygFFMWgjlHnhRhK9rZVbof5rkADvxp5LiY=;
        b=dBdMq4YnbzjRSD1tc0cqK4IHegrgPpMDlA4d8EYL8FigKm73FdEpKtH2xSbH1JiMKU
         oIxkKNCNx4PrajFb11WdjmriomuQUmxf23gLl+57ZCyIwORiXbqlCx3s4WerDdLRQZW7
         Y+itM276il5ynrcDGXf86V/b4wUb13E5gKUfnmLyKK6r9maxLEKhrXKlfsELWjUCTSls
         NmLi6tGWuJITsPbqqCH03GvrPh7bvuy5DR4WCiXcRALfgcGQnvnf5BXWZEUtpHRQJpwA
         vxd0IP82wvu5xMoNZP5MSaT/tv4+u0mZwdlz8DQh6816WGXS0RJFzCgKVZX+U1i1sofW
         0yaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196960; x=1776801760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1JKwITjeCygFFMWgjlHnhRhK9rZVbof5rkADvxp5LiY=;
        b=a/fDiSRmNmSp1IG8qzZdOkaSWoU/Ugm+PcqJ0XEkzcbVhT+SDWLq+XtHY1UysbdETi
         dbaibqi+fKqsyZDpIGngw1JydhyxL8F4MUOf4jeldeRdxrfXJ/xRfRB2kwg+p8u/PWdT
         I1tS1eWwlcgVpDMNdFKiKEeuhEBY5XF5D4pv2RC5kwNldMlzXCVFE4uA1VdZKUK5U4cZ
         k9vhFXb0gxiqj5LVEpz7TOsjWV+wMLlb3yXMxWyI2fMgUsc3PQJVhCEUZgg0ZxswXvQ8
         gB4fPNPemWk4ehP7SBIZMD3GitG1VQ962FVQH2RHwZ3d6fWLhnDFzqzcuuZiU6CYwVH3
         x6ww==
X-Forwarded-Encrypted: i=1; AFNElJ8POd2zeN5zVazxGU8ejEu33+Ql+CGi3zA82INwfavCH+OWMGYI16zYfIH3uPVOjQhJzRTDHx30nw==@kvack.org
X-Gm-Message-State: AOJu0YzrTdHkh7vEfCNtkSCQ9D1ggtYY4qvrBfkzh0Aq4BXyszdTDXTJ
	a5kRfgdmfOnNQGUAAxAOHwkMtAYSOIFRi2u/mHgtHWXLapnmJ2FqkLeKPaCZ9r15YrM=
X-Gm-Gg: AeBDieucur+PW97yaYwIltNAhUgx8c8KyjBsWJ72oK0AxCYf/aUA8txi/fQloP/QXfk
	9dp9FXSMnybI9RuHPG1jrPFOPswQuw2t8gcCi3tcUA+Z4qZzmgaem/1H+zrvwjPbLuWqV7Gp1gz
	eCyAFNY/Xc4L5VvSOQrvndNfeQ+JwmAQVzfDtRaih1lvUnYQ+uZZGFen39cRuUkHbzf2qECs9DZ
	JomzLhbqZ/ogto5RicFV5QWDzJ67tytxxfe/+m/WUExP0Pv5xXIidXBLC3F8uZA8lfUji36yfWI
	wRRjF440JDF4WT+a/0IyxazZR6AtOyccNgym8ou28I3LtFwepFKpICtgBPcOoxQa/z1ym7yQp/N
	UDE5eCPDyToY7A1nhV4LMX8UGnyK4/ajXOyiKVQFugDm3w4Z2zt4PxMh7UYTinqgLMT3MI0j1Vl
	ExIxBcHSVQHhrK61Cjv52/dDibhzM6W4K4y9vQWzWZjTY7dSjLqZSKG2K+aKuQ99s98g==
X-Received: by 2002:a05:6102:1526:b0:5ff:2963:52dc with SMTP id ada2fe7eead31-609fe7a6ademr8406630137.4.1776196959613;
        Tue, 14 Apr 2026 13:02:39 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a180a2sm132213656d6.15.2026.04.14.13.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:02:39 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH 0/5] liveupdate: Remove limits on the number of files and sessions
Date: Tue, 14 Apr 2026 20:02:32 +0000
Message-ID: <20260414200237.444170-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA4B92000D
X-Stat-Signature: yyot3jocictcfw1rfm5m9cfe1fjfamd8
X-HE-Tag: 1776196960-341186
X-HE-Meta: U2FsdGVkX19rCG9KwVsV10btheO+ss5MYdqgP+pxfH3yBj2P5e3XOYaHHpiX98O6X/iVO8pn92FdiHjJIJUZGEhRqdppfV15DWIt4MYHGJT8ba9ce4zmFeKk4cXj0Q9QhumC9l5ZSjqraA3KOJCmf6/PD2BFei2G+PCLwiFoLTCdDHdlfvTTRyoscfasshhpaH0lwvKo76ZcXjV3fsaaGUbiUDKG5YfhfL1GRJxBNvC2AalM6M7rc842dT0FrUsXwdeCuotyWjxD2wR3WK2ADwSRPvthzJoWs9yek18i5+GRFJ1Uli263bFEXMErYLFx7fYRlllEZb9k0uBlD6iSSlhaaGuFPmZIjqTbg6pXaAesnXh9aFMcygHLrRHmCf0Zj++QBLPaPeZE+/w2cDjkVGBANI5DvonWNhMo7jsFH1x4jL6DPlE6OMKSIJfVscmhN//SPcakA+QTrfOV9/93qOwM2vc9XCwyH4XRb5PMiFtAUiBNjeTGVVYZUZmmdwejITfCuaGKCQ96BetJ7By9l7QEFNp2Aw2ThgjtQBlL1fzVQdf/2F43R4jgKVTavMohGKNP7DsR1IKFDxeNIlJeYG0ZXIjeh1E2/II3HQ8LUp65VZmazApXdFLOuA5G2j0lYs2AAKVp631lFkOkogPz5I4mw9HKtKj52o2v0F1umG+er/kEm0okSSWNytGRwRRVkDwApopnQ3+UKSWwTibnAFyiFHatvxjmLt2URZQhWdfFWKwRiD8luEOswAZNvo/y4ZDGg9pQcphD7wowuuhIlNwWWDNwsCEMulNl8gXkDA6phhZVKAeZUoeyVHm0y4PUd7IwnOjiHpGJccDV8WDAy1yp7JX0fwSAR2RuncxAAdDTMqCpN9amTJPt3UVIRmBM3CTcGxDs53k5y7WpCR3v7ixeql//UG3OJiHS+nh7J+wWDMgHY5yJoC2A1hg/xTYA+8L+VU/136StuQ1pyRw
 xr6Kxglf
 0LY0VBZNg8WlAxzzWycag1GrLt901PMuKa8DFlm7wb4M9/W23YENl4z0plPeaSlugDke2I+q1ywKcL7mz6nTuuaBV3OUFyQqy7nRBgR9XK9A8vBD3pp6pT1AXSwqjI/bwTMozUyIVSDmbPBpOttJ47Ui9dVlHP/VMliXlqd6ASq5AnVq+WuC+tzhmSauY8mURYlK7/y3cPxnbfrZTxYq9vddsA1Rz5OX2YXBV7/3v17pHOEd5vvELgdcbgWgfFuQiTalF+8T72XywgMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series removes the fixed limits on the number of files that can
be preserved within a single session, and the total number of sessions
managed by the Live Update Orchestrator.

The core of the change is a transition from single contiguous memory
blocks for metadata serialization to a chain of linked blocks. This
allows LUO to scale dynamically.

1.  ABI Evolution:
    - Introduced linked-block headers for both file and session
      serialization.
    - Bumped session ABI version to v4.

2.  Memory Management & Security:
    - Implemented a dynamic block allocation and reuse strategy. Blocks
      are allocated only when existing ones are exhausted and are reused
      during session/file removal cycles.
    - Introduced LUO_MAX_BLOCKS (10000) as a safeguard against stupid
      excessive allocations or corrupted cyclic lists during restore.

3.  Expanded Selftests:
    - Added new kexec-based tests verifying preservation of
      2000 sessions and 500 files per session.
    - Added self-tests for many sessions and many files management.

Pasha Tatashin (5):
  liveupdate: Remove limit on the number of sessions
  liveupdate: Remove limit on the number of files per session
  selftests/liveupdate: Test session and file limit removal
  selftests/liveupdate: Add stress-sessions kexec test
  selftests/liveupdate: Add stress-files kexec test

 include/linux/kho/abi/luo.h                   |  52 +++-
 kernel/liveupdate/luo_file.c                  | 226 +++++++++++------
 kernel/liveupdate/luo_internal.h              |  29 ++-
 kernel/liveupdate/luo_session.c               | 237 +++++++++++++-----
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  99 ++++++++
 .../selftests/liveupdate/luo_stress_files.c   |  98 ++++++++
 .../liveupdate/luo_stress_sessions.c          |  98 ++++++++
 .../selftests/liveupdate/luo_test_utils.c     |  25 ++
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 10 files changed, 709 insertions(+), 159 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c

-- 
2.43.0


