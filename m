Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6303C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000A26B01A7; Thu, 13 Aug 2026 02:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4C66B03BD; Thu, 13 Aug 2026 02:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A1C6B03BE; Thu, 13 Aug 2026 02:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABC866B01A7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:34:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E3A380540
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:09 +0000 (UTC)
X-FDA: 85095281418.29.A0976AE
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D96E20005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o2gEZ9CK;
	spf=pass (imf13.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AmYjsyIQlmoZpHbLOHvgwFOqIOXRzjPASuNcF55zpJ4=;
	b=pRRDfCdwS0PtCjDN43B2kwzXU3pzErgxowVnvs5U3c2XCtuyOixNJBJTUGk8liuFzjaKeC
	uleaQrIQ8G3RYNbMc2K2ivPGKnrDRL6sZ0uoD/eUd9ZDG5tKB/RjsMpLUrnmJnl+z4UgTs
	boFNd1aaXZVEZaq6pt3imTIUoyk40eQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o2gEZ9CK;
	spf=pass (imf13.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602847;
	b=frg0SUG3oqot92itmnd9TaFmZ8CypJ7GVQRa0z022WnaF6cAIUxPEZ8xXbTAHIN5c/EX2q
	TInZUipvQ9oH78pPCzSSnu/3f2L66KBorBs2uSnhvou5ODNVbvqiNHW/D9n0cF3Ykyr0Zf
	fyLX0o0YXCoBTJfVFr/Swe0jem9+GRA=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so1886796a12.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786602846; x=1787207646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AmYjsyIQlmoZpHbLOHvgwFOqIOXRzjPASuNcF55zpJ4=;
        b=o2gEZ9CKvNJKJl3lbw3hAsuJlt/SD/F0dGGSyFC7BKlAY3lRjeir70IReOaJlw7aaa
         wL7kwuXWy7qrLiaLxofhaJMw/DT3bL8/t1oCWtjJnlQsRhV+ziIP9aR04A5auc2J64OQ
         WVlIEUdtrGPneU6n3NmW2fcFf1zTU7bkBg4t0iywgF5GBIWUGR5lztiUJyYy0DsXTXRT
         Im3ustraQGK0NIOx0eM+tFO0uv0pwapNVJwt6WiFhR6wBMZ53wgpR9sxcRXelcYYyoa8
         71/UguY+7e4TeKrueYDRgm0d5wAqtwMqvxWZUBqp1MQ3UFy0TJ1AzAmPixvQyGPfddrY
         OfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602846; x=1787207646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AmYjsyIQlmoZpHbLOHvgwFOqIOXRzjPASuNcF55zpJ4=;
        b=N1WGlHhuwpuqgr2IsvL27KAmtafP/V1uIAkQvZecsIWnSVrLydi48Wc5KlIOQzA2d2
         qW+RcSUniKRVDtRwkRF/AbDpWO9Yw7tc1c33heyXY3QoD5CXcebZ/w/Ic/C1ix1KJc28
         pW73FH05gY5Iq5Y8M4BGcA1Gw3qXM3MwS6uRCdCrKnyggHTImV69zXjRwPRp9MGd9VP9
         a6FWe3JVmZg8o6jeprs0lQEn1d1sxCJMGtOFJngdkdN4JsqWaInmBM+Uk6uACyFQzbmh
         oJ6w3aJRRfTvuh5sWT25urYCN6vgNwU+wXaN8kBWhRnOZLmE1B4yEWT3Q+ZiyygcyBcl
         OdMg==
X-Gm-Message-State: AOJu0Yxadj03TQ31jVS0P6lWjgKfhDdWAmiBN0YzyIRZJnz/p33fnCF/
	oG4+QuOgqrHEfFAgaE80GHCJi5qWE2r20hbIj8iKuIx2qODmPMCFGucH
X-Gm-Gg: AR+sD12jTlTGFy7W539aHOpa8E4I41rnX+UnYc0MFBce0HvHe45T6enzU9Xuekb5rSj
	QTuwlpQ9GrfHovE3dFkxO+DBX2mdGEObbQ2v5K/zQSqp8PkF/XLVb8U2r7KuTCoQ/NPmXRdfvYy
	5CI4O6Exo63H3AKG5khpiTjG7Cm474fjJM90Pd1IAWJ25TzXjV9T8ONpJlvsJW4ZGEv2nNcO5sk
	8QiNjMaiTP6rclTWlEV+6mudZVtbUBx7XZE6bbn1VJXpo34ohS7f4pthPbS5FiHeIrl73AF24NT
	EjB11h4Qox9e7ppaBdaeYfRDBOO9fI284IJOF0TT4VbZOEx9nnQqWTWuZJiLWVKb8H2af/AH5pY
	eG0t7+q2rEYpYdKrcJyzeuJzjxrAvL1dRhXyRBJvkpUl1/5/KjvJOL2WhgGoWPPaQhy0CsYJBnJ
	Yw4cm4xucRNLrNUiPseRdGnJuk1X+e4/i+ewDxzqccTVyF4wiIpiAFA9ManuIU3Vy8nFgRwwIcD
	qoGLxA5U6Kzr2qt9FAiYffX0prxlW3nmkcobuPWoYZ3p2bfpOHF4DZAaE3+hBQNLA==
X-Received: by 2002:a05:6a21:6f01:b0:3c3:cc3e:a9 with SMTP id adf61e73a8af0-3cc54f4b5e8mr5183423637.4.1786602845946;
        Wed, 12 Aug 2026 23:34:05 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbef6a59d80sm550610a12.11.2026.08.12.23.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:34:05 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 3182115B0429; Thu, 13 Aug 2026 15:34:03 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [RFC PATCH 0/6] fix nommu mmap and add nommu kselftests
Date: Thu, 13 Aug 2026 15:33:55 +0900
Message-ID: <20260813063401.1786548-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D96E20005
X-Stat-Signature: bpayw411kdaam39r9jqt417iahmtsphp
X-Rspam-User: 
X-HE-Tag: 1786602847-270518
X-HE-Meta: U2FsdGVkX19ym4no6NFuOdpFJZVCDuESgF53kQWLWPv0c/I58L0Vd+qe1tAEv/lfrS5FDcjFFRkm44uwgZX6peN7J+28/a6oWUS+YTt8VXCnPWEeUByiYElF29aeVFxTq+agOA0nt4Ca1q2V0W+/9gQouS1xZxzsgPAkXcmaV0ivDXENtduN9s4CoOTe+a2YzNoP4kMmghn3iccCVd5x/0LHMtUsFZ79ng8VuaKdpZ7J4/X7h0cKZxy8jQAKYGL0wCziLVcGXd6dUYoglvOnQSnifz7ZbbptNuM10rpO6UBlsSWDchsR92y652WY1CikZ11/f8tSwKcNj6UbAq55HjVL9+ef4HAF/t9Axhat1bFH3tWOCUQvNuTJHJLSS3OPR344qqEPgGY9R55f89noLwE9iaZErwylBBc/eARH7IZ2yn/LSHy9h5ZDN/EKwy7jFVAy9Bn3sH7nuFRiXLgg6gFA4dF66tTYl0tkrM+f2nxpnOd9XN6uAJEW1CeTxpnz1v5emUa2P0q8Ta1Q+orlaBpM+xiUoHwUFMN3eDnDvHnX7geeSarX8l+GYJR4vwBrjUOOYzwP4mc64tpxtg61n9lqPMywNeihVQol0fJgoXffR+DTLcTPISSLmqzO+ZICzQy/mzKFymfyEBccnRhp1eSzCV2LkodU35etrZfo1bshGpbKEta8V+x6t3aIf5QaRuxzx8KOSFImxSzebtwnn4t0bRIGEbgs+yzBq2y1SE1bR1PuZ/qlOmNfeqMdeHjAAH0C6DGIYlC5ufBpgCrqMI5p0nsxpZGkcmVA8leSTW3LxGmdZmcdHKt+pnljO6jETxfOoPO59uRerzw/Y/DzPRssm2eC05vzaoGRPgF0NcdG3UllzD8nKl4Jp6/l3g22uqXBB5B07QwBAjXT7Xkaqm/qGtmGIW3cnfBrQYzE45AGR1aXh3jbmo8+gUQ/TILqjQEk4+QareOnTjobULR
 XwgOk6B3
 wRut95bXaK60yRhyFFRW7yn3WXht2aSOei45Rk1KrEguGFMtaj1FNKilJP0YqlVGGz/1QL1rjJzpNR34QgFZ3t6KRKTch9cCXCmReGJCaMo9i9x22wLXvrn4Qy5JyaLukfVjL8mDWUWg0ah3doD1/O8RkfP94Yn8XzWotKcQuG3MwIQg6YwAx2//ulAJRMQWyefzPCIKKt+A+9Q/EeUuzwPGd7K8bzpNXfajL+6E35Di/VXsNVH9uoct4hKRWIKADxFara3zX13QFEn/l/HOP9fzm5UT83aRAHkQdZalvfHblTYmGU5A1QUyqL6zucCk6FgkffDf/61flUsC9+/658O/JKmnv+mY27vbaKiJLTYgy4EclUKVqYXNGDq4jZueXcOBjU/AfnilGU58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset fixes several issues on nommu mmap, munmap, and mremap
syscalls and add test cases on kselftests framework, which currently not
runnable on nommu platform.

Fixes for nommu is to correctly handle error cases when vma shrink
happens, and add calling .mmap_prepare callback on private mapping
requests to fix the issue which we cannot MAP_PRIVATE /dev/zero file.

One thing that I'd like to broadly ask you (thus this marks as RFC) is:
this fix contains a dirty check of /dev/zero using device type number.
Since mmap_zero_prepare() should be called before actual mapping, but
some of the .mmap_prepare handler should be called _after_
determine_vm_flags() as the .mmap_prepare handler checks the shared
flags, we cannot use vma_is_anonymous() in determine_vm_flags() to
check the file is /dev/zero or not.  So we introduced
is_file_anonymous() for that purpose, which I'd like to ask your inputs.

And we add test cases to introduce kselftest for nommu platforms.

Currently there are several issues if we wish to run kselftests on nommu
targets:

- it cannot compile/build test binaries because the current files mainly
  assume to build with glibc,
- some of the tests are not able to run on nommu targets as there are no
  fork(2) syscall.

The first issue can be avoided if we can build static PIE binaries (if
targets support it), but in our case (build on ubuntu/glibc and run on
alpine/musl-libc), it fails to invoke due to lack of the GNU ifunc
mechanism.  Thus, we need to cross-compile with musl toolchain, which
needs to be solved the first issue.

The second issue can be simply avoided, at a glance, by globally
replacing the symbol `fork` with `vfork`, which is available on nommu
targets.  Especially the test harness helper (kselftest_harness.h) uses
fork(2).  But the issue is not simple: for instance, in vfork(2) case
parent process has to wait until children has done jobs, parent and
children share the memory and children may corrupt parent memory which
is never happened with fork(2) syscall.  `timeout` command used in
`runner.sh` never works for nommu platform as it uses fork(2).

Additionally, the lack of test cases for nommu environment will (or
already) become serious issues to maintain the codebase in the future.
The test cases is implemented based on the document
(Documentation/admin-guide/mm/nommu-mmap.rst).  The test programs is
implemented with the assist of LLM.

So, for the first step, nommu targets only support low-level API of
kselftests (kselftest.h), and not supporting the harness tests since it
uses fork(2) syscall.  This partially address the second issue; in the
future we can refactor the harness test framework to be able to run with
vfork(2) syscall but this is not the part of this patchset.

Hajime Tazaki (6):
  mm: nommu: fix do_mremap() to correctly update internal states
  mm: nommu: use vma_is_anonymous() to check if vmas are anonymous
  mm: nommu: fix an issue on map request to /dev/zero
  selftests: fix build errors on alpine linux
  selftests: run tests on nommu architecture
  selftests/mm: add nommu mmap and mremap behavior tests

 Documentation/dev-tools/kselftest.rst         |  12 +
 drivers/char/mem.c                            |   5 +-
 mm/filemap.c                                  |   6 +-
 mm/nommu.c                                    | 235 ++++++-
 tools/testing/selftests/kselftest.h           |  43 ++
 tools/testing/selftests/kselftest/runner.sh   |   9 +-
 tools/testing/selftests/kselftest_harness.h   |   4 +
 tools/testing/selftests/lib.mk                |  10 +-
 tools/testing/selftests/mm/Makefile           |   3 +
 tools/testing/selftests/mm/hugetlb_dio.c      |   8 +-
 tools/testing/selftests/mm/mdwe_test.c        |   4 +-
 tools/testing/selftests/mm/nommu_mmap_test.c  | 294 +++++++++
 .../testing/selftests/mm/nommu_mremap_test.c  | 583 ++++++++++++++++++
 13 files changed, 1174 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/mm/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/mm/nommu_mremap_test.c

-- 
2.43.0


