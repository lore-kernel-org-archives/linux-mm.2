Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1563CF65DC
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 11:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36EDA6B0088; Mon, 26 Jan 2026 06:20:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342DB6B0089; Mon, 26 Jan 2026 06:20:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224A66B008A; Mon, 26 Jan 2026 06:20:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 116C76B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:20:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2436C2456
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:20:00 +0000 (UTC)
X-FDA: 84373870560.24.BF29AD2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5737C100008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:19:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/BIJ2kD";
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769426398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yM69Fp+p/qvQDMim1NNKj1peSV7uhPcp8MJ7UDoVv8g=;
	b=gUTCKCz+elwiv1hnJGlh8FS3RiEZhDjWvGPCCFjAVgG1OPTBIBlDTuhoNQMQ2Czu/D6VvZ
	MeAPVasXJ++X10jRmagsV/tfjHVA9p6Jx47Q22csKkBNddE3QPUzP81hr9mPsm+u8MOmls
	l4AoBkp7gf5vz59RcHavU3WMGSuFECI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/BIJ2kD";
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769426398; a=rsa-sha256;
	cv=none;
	b=wOrJ4wLkgYl15hPGyA6w9mroTdxyagL9TWuGWBpuAIxWxXwxemxWfQqzp61UbZ5tDPRtNd
	LyVnezzkFXbG5+BiHbV1cAI3QHKfyKg2eCMfXbFnsBGj0FklLIiVnYsjNVtgUOi6xo0ASm
	pQqV8zZ5R+I11V7KzBngrpnQmpu81Q0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769426397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yM69Fp+p/qvQDMim1NNKj1peSV7uhPcp8MJ7UDoVv8g=;
	b=N/BIJ2kDMngGYtrUOUh1NxyLN9VoO4CgMawLX5CNdvNedtmzoNKigX/QB1tsi84UonC0fu
	jNz7Z6HsgLQuM2T231YqbcrGxDJEJ55whMFqZYmhXgyyn3zH24rorH2NmDJON7YrrJ3SuT
	QvGYHKeCTJTt69jN68plO0Zkrxj2Dh8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-hkzu0BLbMZSGIZjAHSkd8w-1; Mon, 26 Jan 2026 06:19:56 -0500
X-MC-Unique: hkzu0BLbMZSGIZjAHSkd8w-1
X-Mimecast-MFC-AGG-ID: hkzu0BLbMZSGIZjAHSkd8w_1769426395
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-59ded5225c0so1157194e87.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:19:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769426394; x=1770031194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yM69Fp+p/qvQDMim1NNKj1peSV7uhPcp8MJ7UDoVv8g=;
        b=v29A7PEB0R0MjoG97FMAXwU7m6R4yFufTUrTk7vp9nUQhfx3YBTm+50Vy5r48MiDJQ
         lCXPf6PODd0lH1AvXjYuw7k1MWYN6FV2M84BAorGy2avkDsqDvW2C/JIN3NreNJYTv22
         PXr3doNt1xwgqqMBST8RzE5Uu+OE+/jJLDoF1iCr2Sx35VHJkzEDhoRe6xERZHmxhKdF
         uq7IHikmpbqdUmbDy1EgtGVl+HJKVP02K9yZtH8si090aGYg1Cutb2Z0aiPIchaz8lYh
         DUDUHcPsR+kKvClwYVsS1uIOJQS/gFwb5TlE72AlYO0pDfhnQDO+UI966G+Qd+VPLCGW
         rqrw==
X-Gm-Message-State: AOJu0YyX0F0fdUJxngKXbpVOijhf47J4GAZHfd8JAUfOZCpcRuGp2nwl
	b1NXnn586LrN5GyXjfbXEZjdDrlFrw5SmKNJ6XMQnCl26If+d7zxrigOiIaj2iJfwgiUc3xKdN7
	9mQSeytSbJwGC6BmqVpbwe7Ejn55bBlY5jZiwKVUKiNY6bLcMVS2lKbhtDyuaisrFcwQNmCgo0S
	bWxddxpz4HXkgOpsh6xeeS5fUrGYd3KOVJG5o=
X-Gm-Gg: AZuq6aL1jWp6EAb0WVFOeYe3Z1bShQBHKdGDEut7Nfk6KKtbzhqz779i7TAHxIgglAg
	fm7oHnrsssVnpW8RpWnWEd5+q2Wup6wBDjoCkaQF/oI7DPyrwZwpPNR9mXStz9QaWMZMRmX4zZG
	CTzTPaHb4280EVSkzrDAUB8rM5XIq8a9PxSoFgPs6GJ6/uawRKFgvwVe+R/p6vnT9N6X97QMTAv
	NyXkQ487yH4ppWEcJ/epWBtgPyH5xGQSz9Q+HNUSkluvpFBauBTVy/uVHpZKAKc4vVhFqB0CF9P
	8hHRBgICe0006SPEaI8QHGh0ynRRGp9THI1zBJjf1EBzWFmxJFur4Cz57SlsdmeDAmuZhH0fojz
	KkHfEn0aLFX21is2DhedQpIKm
X-Received: by 2002:a05:6512:3995:b0:59d:e93e:a8ae with SMTP id 2adb3069b0e04-59df3a3a34emr1437983e87.47.1769426393976;
        Mon, 26 Jan 2026 03:19:53 -0800 (PST)
X-Received: by 2002:a05:6512:3995:b0:59d:e93e:a8ae with SMTP id 2adb3069b0e04-59df3a3a34emr1437961e87.47.1769426393424;
        Mon, 26 Jan 2026 03:19:53 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de48e5f76sm2572221e87.23.2026.01.26.03.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 03:19:53 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
Subject: [PATCH v3 0/3] Migrate on fault for device pages
Date: Mon, 26 Jan 2026 13:19:36 +0200
Message-ID: <20260126111939.1332983-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PJFw4BB_92oQYYpuU8wCp26OKHmC-qEBE8yktWC0Hho_1769426395
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5737C100008
X-Rspamd-Server: rspam07
X-Stat-Signature: jibpb3mne9cggpz5ay476xcn4n8bb3ok
X-HE-Tag: 1769426398-929508
X-HE-Meta: U2FsdGVkX1/XYAlfaVOteLuToImkkQ9thYHgO1YyJLGfGBy3OznBDUbJT1dGSSjI7y3WIaYW9TfTI3wgvtEDpZGJT/exgsjz+cvPtWZkEqTPQHh4k18tjKwJRqY4I0jiz8Jsq7mQ2Ya/W73HcrEFW6WsKyh6QFy4Uxt5N+aTHjDsq5bI8PSV//7WSTTLHoecW4qdUk06NEbNy3PvaaTg420n3gMfcFDv4YDpjQjN2a9FO74Tgr6EjUNYG9XbSYnrvzTkIDduaFX3aAPkiUD5L0KodbQY2+mQ7jX26O4nU/vBuojc+ngRwpYVl3rjRdPZxxHoUyAOklLgmJ1fbwIUCukaWu0zJUiesKPSkELsj1z/HdktKkFt24gKrYCk3j/y448aPvYFN1Ib+ENwspmLuSHD2gJ3BHlmkh7LiifWYoVkhHiAl6WipmLa1ONqthIToB7fwfCRiK5lPOLjUkUbYUz9yegkwxYuYaBTRCcFmF9wbWEaktkD0W4WL1pJsC7aNl/6Q+MnEMrup7vkU1F9LogeOGfwrVpsvxEfqFPuWy/qLIfNWmsSRhiBOtoTFFEGDeqeBujSHJy1u6f6OtVK1gxZVG5Mq8SiPC913qBWqVy1jNSHWS0ukgttj4V2iXbkYtm3wSga0i2Tt4EBc2YFl6jfe4ztF+FwiuqhRq2QW1R4EIFOpSiqBOuM2QMumQZLNkX0+hCX6lq/sHFOiDkuQZYkJxgOSUjmIxbTB1upiuZxD70TV2b+PrkpiKQwISlkl6/3tvaIKIS5Jx8Zlz+NdNBFJIHoLxDU3V6d9DUTLCLpdtMF6to669H1+c27Ng+6W2/8bIQFVx3pBBRHE0ro7Meg0jD7S6AT5KTRkJdc8AnD5NA3gyFVC1HffJssO6XVonMCmwGHI879H1KezaXf8g9QBarJfB6nF8CKBRGEepT4koFg9Y7o4zSBHzgUP7qJHf9RQKMLrTFzK9fpIYY
 B91cabmW
 /QcdQyQagWV3VzS3N/JE+v0kX2WWFu81wXhONY2udbWxBevkeCgwRZsbSP/WB3F50MzL/5wG/lriDbym0J0KdxbFT7Y7uCpvgWQNOrFvkbW0B1tj/4gqz1SMkCRjJx8uPFf2KVlIRXBbuFb5xuq9fnvH8DpuNG7pNOSCDTQFd45Vqr9nQ2ceh0sQBP6bynTT0ylP92+d7wGhsP93aUz7BsZ4W+xRHqzHjk7jJQ39VY//GtSxO1nM3UZSVneXAQ3Qw4P32j0YIfUd+Q7jZWKT46ZHb2e15TPzenHbp+BLdVjSzJWP/Pq7sfipVqtrjDZMZZ4fVxQg1T+Yx3ZZQQUYtDZOFLTjaWyaM4Cybc6sthLz8n7W3ldPcb5wUdHMsoX52cGU5X53cP9Ji2ufVCEtt5AZyhwDeeI/zHMsJulHeFG4eqtduigmpDTxmlds4xii0nZn/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Currently, the way device page faulting and migration works
is not optimal, if you want to do both fault handling and
migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the
following sequences:

1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It is also tricky to code correctly. One page table walk
could costs over 1000 cpu cycles on X86-64, which is a significant hit.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

One extra benefit of migrating with hmm_range_fault() path
is the migrate_vma.vma gets populated, so no need to
retrieve that separataly.

Tested in X86-64 VM with HMM test device, passing the selftests.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260123062309.23090-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes v2-v3:
  - rebase on 6.19-rc7
  - fixed issues found by kernel test robot
  - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
  - fixes to lock handling (pmd/pte) on errors
  - added assertions for pmd/pte lock states
  - other issues discovered by Matthew, thanks!

Changes v1-v2:
  - rebase on 6.19-rc6
  - fixed issues found by kernel test robot
  - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
    parts if migrating
  - other issues discovered by Matthew, thanks!

Changes RFC-v1:
  - rebase on 6.19-rc5
  - adjust for the device THP
  - changes from feedback

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
  - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/

Mika Penttilä (3):
  mm: unified hmm fault and migrate device pagewalk paths
  mm: add new testcase for the migrate on fault case
  mm:/migrate_device.c: remove migrate_vma_collect_*() functions

 include/linux/hmm.h                    |  19 +-
 include/linux/migrate.h                |  27 +-
 lib/test_hmm.c                         | 100 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   1 +
 mm/hmm.c                               | 801 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 594 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1032 insertions(+), 583 deletions(-)


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.50.0


