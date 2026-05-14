Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7419CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC62E6B0005; Thu, 14 May 2026 18:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77666B0088; Thu, 14 May 2026 18:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65C86B008A; Thu, 14 May 2026 18:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A40006B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56985A05E5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:34 +0000 (UTC)
X-FDA: 84767460708.14.3CA4C53
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 736D14000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bAC6B1k9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jKaeCysGolB8wQTRAqT3H/WnxvkmBcYreAX7ZFxRMf8=;
	b=DZ2G8lpIq+o1GjeFEriMfNdNlDEU++SlvjgXArXSxclLy8QKVRha52+WciXgBjZ03Per7f
	VXOOE04eUlPCFS5fNT59G4BMt5T1CYPu6jn5+i4kNWoCXcdkPFvsIUxxkw0MdlXPsW6f0a
	apTia7fKpF2OMHq1xMmdrkHm0weFq68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797592; a=rsa-sha256;
	cv=none;
	b=JEoZuUvLCPS0eglK6W0jZDVYZtxCR1KsflsWUjovwlvNJN0Cahefqu8vm95zFzPrqIruLz
	CyiabDlZLi69IZ0/oGEzPR4n8F/deYotPzujA0ZoNWkSUx5CfATMZ3hHJqw+i4fMA9/L0b
	c4ygcQxkAw1l8grWdzZ5HJftADQRo1s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bAC6B1k9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5164dafcf97so9610601cf.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797591; x=1779402391; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jKaeCysGolB8wQTRAqT3H/WnxvkmBcYreAX7ZFxRMf8=;
        b=bAC6B1k9EcXnVgZxijR9IvJKKLAjvYuLbNiC0PpJ9lTzrC2CK0FQgwydupc4N7xsTl
         dU+j9oa7A3HsCDAvXx8vzLe3Q/4dLeefIKbM7y3aiY/hUD421tPeuybVrMdrUKXgsm3c
         j4x4J5BgdXzDrpFTqj9Fp8IFrvHMw513oiI6ykcyytAc6bl3ugZdm4mjfqFiVGZAYt99
         7sD9J9ZxTVszxH+tDODrXujq4E9aWAUoU3+11FW+H2W/TZpXGS6oKL/5yYAotUM9fkhi
         +7Ae2bNrzK+7zLJi9qfsAAvzgwPShEq/0warVTL7+NBYUKWH2RjhU3Y4yxXkJYz6mNG4
         m3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797591; x=1779402391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKaeCysGolB8wQTRAqT3H/WnxvkmBcYreAX7ZFxRMf8=;
        b=hFOOKFBCYdRCo3p5/7ln57jVb2BE1pu1atcQReTuItNDB3sgWNLU0s+mTQAolxYVnR
         AUGX45diGxxbj66Rgd5aogLQ2Uea40BhO/OBrg2H69P/UcNyMaA9XNc1ciiw9B/O4kjo
         70BrGp59dLDIhO2lDRKOwGCvTIwGG31TwF4k2pIpIalZ98LFa/pbF+DlbzvDfDjBWPCE
         98GvX0OwDVFoqBBZCVqNZixOisv54uFZhyvxvfW4m5usyH/TDNF9xP4MRHyPEzwpF78X
         Kj27cHZ6n8ztaKi1d+T2iDmOPmCJ2KEq0rpPWGPlZ/Yv/EhRv8P1v7Pn1bXgqW1kbBm1
         8F9Q==
X-Forwarded-Encrypted: i=1; AFNElJ82Lz1Jyo3pRdd08e+MpAMGKi5WNNNyp719RyJQCca3XeyQy1OK029+Xm6XjuSyFHkzbAiHyVj88w==@kvack.org
X-Gm-Message-State: AOJu0Yx1bfTPKVMdgu+qh8xy0BezNEiWgnIlUb+Vl/Hyl/4XEEam7mzM
	3vRU/0f7mk26IrktHTKDYiPCXzXlgRymfTD5GdaHwByGj08/dU3ClRKwORxqfaIQ4pc=
X-Gm-Gg: Acq92OEm+rt6IjE7l1fqA9IAlOu0HcTOM5VQj9bKIFjv7Dw3fk8nAhfPkD36DQf6Lo4
	KmkHZU/w1qmwXxLdf23j9PKiaGggGhWAlFynWvfOGJV0a+hZUmc9bZkauzzdkttczc23Ifm1H55
	sbMfczgIjIROK6epJsC+Xg13CXXrkD5JxoFcUlBYcDH01OkUQLu22RaZOPyk7mB1LbJloYhq7G1
	RGJgpKiNUsaK2L/Vr8aeM56TkywLBK3uS3wY4udOnc0epSV7/njybonat57h3AUhOHC+ZguXZhs
	3sfzJ0D9R+URurUCvKTUxATNoEn0xbeM46CxsvMZlLybOdXsyfwGLac0NyW/yoaPRRfdzh+I2vX
	uyPzd3DX2BpRV/8rMWG9zTjM7oevWv4ODXBqWkt1X0SaMFdPs1nSBZDKN2y+tgF5lq+XEmnVCpN
	i08A7GfagMXyIK45EvkS08SARrnWMLApT35GMjH78+8TPPMsXCliE=
X-Received: by 2002:a05:622a:6201:b0:50f:817c:2fe6 with SMTP id d75a77b69052e-51659fe0269mr20823261cf.2.1778797591454;
        Thu, 14 May 2026 15:26:31 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:30 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v2 00/10] liveupdate: Remove limits on the number of files and sessions
Date: Thu, 14 May 2026 22:26:18 +0000
Message-ID: <20260514222628.931312-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 736D14000E
X-Stat-Signature: 9ssmj835a663iqbqgh8u1cgn6wwbbnh6
X-Rspam-User: 
X-HE-Tag: 1778797592-144025
X-HE-Meta: U2FsdGVkX1+dtSxcEBQSdzYgqV23EAyljnnkeAMoRqNz98M5/a3rpVEMd5AIxgqeT423ewJ5kkyK7n3e3ZZJ3Dl19CBPI/O+AQgO5frGp+2PHnpMvUH/+gCF+7Asg/Jhw5CZ4lBURUCr0UfSYgEdbhbutyQX5KD+XbpT5DUc7BGd1kG7QaxFlvLfS5g/f/C6V7cm5SRuEuzg6ydRF/OCj6tMS9D7iOuMcS+O33NZ7kBIEv4oNJhTC4CkvUcN9hZ4ItHXJWftpbAjUclrH0EOXNhEdIiwW6IgoiQ/LEszSZh/PxjjWJat0e+Bj7sj6Fejt0ljHacXSxCP7TEWXHl7z+2igzOWOZXWeBcCo5h+rX2dGoijRdw+XL5MipfWAmIj9mCkwJ9d9opwj/EpzZfosSjw6evTQ7P1np3yW0v9ugOiFOfUBpSKMLQ25NVZKGjIWsjInCT1aX226TUQXTM9XKd4vgi6IuvvxvlPHm7Y5w2Rzwq0tF+kZcg2wZCO5+Jj2sZ8zaSzSzLfgDq3sAnF56XtIOPczhV+XiNGRJ3w4RMjiSdYfHu7bpzi691/9ciOUIp78DSbtYlPRlZDo8D6VBRkyvkuCzqlzNq/Kf4R9pVypNeEfoNziNGPBBhoiNdpSJ6Law+7MMGrbO3es3180Dkg+4pPBQ+is8elgXq9iniZytPAdBdsXQdJwcJK5Xb1taUJjiaxQnam4Pj2Jlr7dnhD0qeBbNsMmIjkvM10YHC5UjaG6cbx7DKzenr7pdVTG0So+75xtZ2OjfkNtTVjpNimCrL1Bu2RNJMNevG60fmt0Kmnu9BDO09G3K5wUYPXBpUDz5geFSpRpRcU1yXoMQZjj4vpZQ/lpJw3EM7xqxYQjKjGd+gFBUrWcYcXkqTc00XCOOCkD/V1yreLigbwsVOZNf65YwMBWK8tFbGLmAUf3vqA6EywN7mHVCchk294EVNxo8AGf8E2ixdoSAc
 Q5QejdxZ
 YY0rDeatHU+Gkv9C68w9+d/YhISr3hmCUDy4peZBFBp/JhbGG3yCXpaIGCvNraLQZ1AzSmpLDN1DBG+Xn6Ly/YwgkYEIs0UM5F8cHOOXCZpvykWBdvPmm+vcFB76/A6yYqQw8Hwzz4HSHal2cOJljCUWUlOmhB7X+jXzS73IQn1g3/rG1yKHbzES0KB4ghi4pRkOdzYjTsEH+pe3DXQGRT/tMU60/o41RAaJit/hHMbaj+QKHlW0MpnFJa1Ux8NB48YrWGZqljzZtDYQ=
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

Changes v2:
   - Addressed all comments from Pratyush
   - Consolidated LUO state management from FDT into struct luo_ser.
   - Extracted luo_file_deserialize_one and luo_session_deserialize_one
     helpers to improve modularity, and later review (Pratyush).
   - Added dedicated luo_block.c for unified linked-block serialization
     and management.

Pasha Tatashin (10):
  liveupdate: centralize state management into struct luo_ser
  liveupdate: Extract luo_file_deserialize_one helper
  liveupdate: Extract luo_session_deserialize_one helper
  liveupdate: add support for linked-block serialization
  liveupdate: defer session block allocation and PA setting
  liveupdate: Remove limit on the number of sessions
  liveupdate: Remove limit on the number of files per session
  selftests/liveupdate: Test session and file limit removal
  selftests/liveupdate: Add stress-sessions kexec test
  selftests/liveupdate: Add stress-files kexec test

 Documentation/core-api/liveupdate.rst         |   8 +
 include/linux/kho/abi/luo.h                   | 140 +++----
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/luo_block.c                 | 388 ++++++++++++++++++
 kernel/liveupdate/luo_core.c                  |  57 ++-
 kernel/liveupdate/luo_file.c                  | 209 +++++-----
 kernel/liveupdate/luo_flb.c                   |  65 +--
 kernel/liveupdate/luo_internal.h              |  70 +++-
 kernel/liveupdate/luo_session.c               | 202 ++++-----
 tools/testing/selftests/liveupdate/Makefile   |   2 +
 .../testing/selftests/liveupdate/liveupdate.c |  75 ++++
 .../selftests/liveupdate/luo_stress_files.c   | 101 +++++
 .../liveupdate/luo_stress_sessions.c          | 102 +++++
 .../selftests/liveupdate/luo_test_utils.c     |  24 ++
 .../selftests/liveupdate/luo_test_utils.h     |   2 +
 15 files changed, 1068 insertions(+), 378 deletions(-)
 create mode 100644 kernel/liveupdate/luo_block.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c


base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
-- 
2.53.0


