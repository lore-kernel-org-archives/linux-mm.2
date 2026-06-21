Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B795CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 14:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E906B0005; Sun, 21 Jun 2026 10:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFFC6B008A; Sun, 21 Jun 2026 10:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0676B008C; Sun, 21 Jun 2026 10:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 763AD6B0005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 10:59:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDB39166CF3
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 14:59:31 +0000 (UTC)
X-FDA: 84904228542.18.4B1748B
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12BC11C0003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 14:59:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f2Iz3YCi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782053970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q9Iy1NRZrQdiv+3iSOUUb7XMLeE6HcnU1eSibV26qpo=;
	b=GSRVuJm+Vsmbt2z5fDBTYH72+2rjrFAFiKhN2w/obK1Pw1gxnrCCywnjzB4V3pP54Xj4bD
	TfMKEH/sT3RM160oThvx7TwNLMPajyngLY7v41hbUU5FISyM+nmKOrKW14K2HJSetcSBYI
	L9xpZ73pd59iRncfm4BqLHsu6Nz5Xwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782053970;
	b=YZUbOT+Z1Aa5Tim52oyXY/Q5IzfqSAQEihw0v2D1AQXwErMJecX4chp4NzhaY4GgX1aoY2
	4e+OdOnsYZkiB0QFEPUPnz2y+NAqDHrtKPT21oDkrif5dFWZr2gRjsrA2wVSTGZJdVWW7M
	2nqxWOYmLgMguxdogOhcY1BOTOiM3l0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f2Iz3YCi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-37c8e7c8137so1854845a91.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 07:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782053969; x=1782658769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q9Iy1NRZrQdiv+3iSOUUb7XMLeE6HcnU1eSibV26qpo=;
        b=f2Iz3YCilWjXhqdsBq0PsA3Rn8lrIr9UtOSweKXotSMxIYUWdkKrK15zs14zwYRqMd
         HsCJMBegNpDULsF6V3UNHpxCOzyrM5ydWfxftTpuMc0xOsEQbOjFyPYWSeC93km/W6c5
         PJ0ERqfO4Jormq4fKupBknMzDmJUeIVnJ1C8q7sTfVbBZDuga1Cyam28bLr6Ib7THAdR
         NT26xPFK0MLg8DZcWx55uu3d+Ao7DjtU0kKBLQ+r8l0hIUgrcNAeM3/1uENCoqfBMq8m
         C27r/vki43GU7Gu35boT2n5irCCFGQM7Tjk3uFUSYqWCiSM7ORFNgvdIwSy4SLG90a0h
         ye5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782053969; x=1782658769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9Iy1NRZrQdiv+3iSOUUb7XMLeE6HcnU1eSibV26qpo=;
        b=JyVfV/Ltg8G+MnvxSrgTFLYMWygDy67UAT0sO3kxjyDP7ybh68QBwbzPDgJ9KUfirl
         BA5Umra9z9kU873SQ8wC0MssbeoEqcCr/EVL1Ti1awaEj9nQiUiA1Bc9ttj0aBZsv9Iu
         Rcn/S+M8YBS46/94TPjPsF2aiXxzlOmNIXQQU5ZauD5cwjr6jBbIvB6Xeo1W1oA9bAA1
         NU2pxf7K1KzE/I3sy0/WMMpU9dkrelCzWtcQLnb8bfMXnqUrCpU55zqFOZH9JkgO48Ac
         MRlD61vr565uD4O51E/4XOAn0+T1ieo1vDYdHLYuCywjedPhkKoTNYIsJjAhTu9cTFc7
         B7eQ==
X-Forwarded-Encrypted: i=1; AHgh+RopOFFv3yUJGT8G4mOljISpkzviaQE6qSzLCQkeawPF9pROL9KiLk/dLrr+n/TPVyh+i1fU1tmF+g==@kvack.org
X-Gm-Message-State: AOJu0YyTg3O+qGY0ZkxFv0spNDogESQ7h/A4S6xc0d2vSHRzfEDWsoqA
	FKRtj2wu8KuDL4OV8Z1cwSH5Yd8nPFG8nhVhUTlEjL5fYbkxTyWfAXgL
X-Gm-Gg: AfdE7cmJfTjbHJaX4GSc0+DT5Dn+yvEH0/mPa6XFouEQS157qLIqOLRIbNgdh8y5fmv
	ZmkYnF77lrIfYS2ULO+XGykdn8MjEApxnTCT193MVd0it3AaQUX1wqxswDwvEAJJoAULA9Bsac4
	6iBRLMr04nGVZaVi6kwLFWAmVJTIRwr6xHebzxlvzHeZr4tbCtYFwB8cU0j09dD00AYTLsAbn45
	/qGwMOnvGz4mCZc4Uld0HbqbKFlr7efshwBBWBQV5v+3ta7wFJCyit9fhkKw6yYTqxxYgq3Vqd9
	0a8s8T7fCZTbiXIpnZenhUhPCUM7Gxvgzjdr6r4Qr65JYlc+ml8iqmyFseadIL7Hfq9XveXY4b9
	TjLfKj0AQaoDQU/p2gR9h9U/OpoBonBB+5JJEJZlPXWkyjBsyVtf0QVy7CJjB0bW8+o1dGn8OeP
	FuJPZUkWZFU+J18K9GeA==
X-Received: by 2002:a17:90b:1807:b0:368:9da3:c496 with SMTP id 98e67ed59e1d1-37d1ea12264mr9696809a91.24.1782053968739;
        Sun, 21 Jun 2026 07:59:28 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4f225870sm4544896a91.8.2026.06.21.07.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 07:59:28 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Will Deacon <will@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH 0/6] treewide: remove unnecessary invalid range checks in memblock iteration loops
Date: Sun, 21 Jun 2026 23:59:10 +0900
Message-ID: <20260621145919.1453-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 8jm3ueuf4aohxstorineoahnzc5xrcqz
X-Rspamd-Queue-Id: 12BC11C0003
X-Rspam-User: 
X-HE-Tag: 1782053969-31912
X-HE-Meta: U2FsdGVkX19B298H3nEtkwTf9xrIE/py08wX00ZQaO6Xo+bZptMlzQI+H+PORu4P2K66Jl4aN33i/0qudJbxo6+zYg/ajf7TlFXt9b4RxpsGX6FcgBoJCKSCwX4x3i5chJzEqlriYA7puhM81+RB89KIosS4lWUBRi3yLYrLHT9wcIAp+JrUcrhBwQrEmn02ov4fd1os7xsGo7Vyvx424RlJ4CKbZMLKfHaYMoQSQKXJeT0PjhT4VNCy4MHPIzPOzW2YtmtZUT5XlSNRyROtP/Zsnv9SM6lG4cbaL9I0l+bQC738MI2UrxtBpoY+Uaycck3DaKmQqy4r4ACfrscUdZ/Yqrazxrrngr1InSHfsmeZXVdgDAPegjz/i+cFZB6spaRgIB1/8zjbFnxWx4ZsGUc/Y3V0S2lvJDQeEScgoV8saeHMpw1pkfA3HnC90a88rmPzcKzztUGn5zwitkPe667ywjYTWB8Ca0p8euGOzg05THvHHuWAHfQetUEy/Q3hLoILJC84T0eSewFQg6BrcAijc334zn8v+JKfmjruJSd3LEr9rfRBPuidlJaVFo4Md/OhNW9RuhnFZt9Q1CsJniYrlCM9SQIGQuqM7XpAQEOpyiEKt+Y2IG5hEnxAOeLXkbwNPObqkY5/7IK3Fl2esEPJCrUjXK50qXav3e5/Oj53+WCb2CPPTyfTABwlb8YBu+cNkrdAhjuHh875uMz5rVpPHzamNb3p4VNdUPEk1VCC+K/ei1jVWrK259LJ9Js8nX0y1k64D/v6JQ19NTs3598SwdEw68zBo3gQOJ4wwReWVZtLrn0EVnnxAEkhymZMjhXzrbM/22fofNDSb/zcEi+FPftghvyJZf703YOslTikyweYDtX3Djc8ERxLYvy68f9pntaKU4CfTsMQkHOUCeDSw9dLbOwsuQ19U/VCfbXko4sNuAYC4WbYvmjqH19ImXFrlV3pjwrJ2VphSmq
 +d9/9PCX
 1ErV6xwmC1sCpmmPZwZ9QjuOqjBZyRsoZWaPuG+wBRt47zts0I3vmt/B1aLB30QBHYjWBzIBdzdjPT9LAU1G8flLO4mmpeykJr6y/jqdNvXcQgQ+gIeke6Es4J7v9f9Wz5VkzoQZXnJQgBgFcOTH8joqA8JQUK7k+qtZsuefe8LWNXWx8I8NomziY9924M3fknhVLMF6s6v/Uim8rjVUSNsjZz9zNg+COoZM2KGx0jkWpUubb+azXDf/FZ0c+NIO2/oHg/5Pis5tl8l8sndqIo0gRXa1VHDWnwYbqgubR+A6eLum0TO3/Cnvetr6Xuoln+sCzCgVBFKdzARkfgLavAtevmqs3x0ld70un5ekWA1ECicPSDDz+BErldIEPIjuYHZFkCLTh9I+ZM4CyNaqvzrmdH5GFgrpOLY4LXaTN1EEbcHwyKgeyJfclZ17nr0k0TJr11gZFmBvJPBg+wQ8BAQRBYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memblock API guarantees that for_each_mem_range() and
for_each_mem_pfn_range() never return an invalid range, meaning start is
always less than end.

Several memblock callers still have unnecessary invalid range checks in
their loop bodies, so remove them.

Patches 1-4 cover for_each_mem_range() callers. memblock never stores a
zero-size region, so the range it returns always has start < end. Some
callers apply __va() or __phys_to_virt() before comparing, but these keep
start < end too, so the check is unreachable.

Patches 5-6 cover for_each_mem_pfn_range() callers. __next_mem_pfn_range()
skips any region that contains no whole page, so it only ever returns
start_pfn < end_pfn and the check is unnecessary.

For reference, commit 36ca7f4be809 ("arm64: mm: Remove bogus stop
condition from map_mem() loop") did a similar cleanup in arm64 map_mem().

All these checks are in different trees, so I split the change into one
patch per arch/subsystem. The patches are independent and can be applied
separately.

Sang-Heon Jeon (6):
  arm64: mm: remove unreachable invalid range check in
    kasan_init_shadow()
  LoongArch: remove unreachable invalid range check in kasan_init()
  riscv: remove unreachable invalid range check in
    create_linear_mapping_page_table()
  riscv: remove unreachable invalid range check in kasan_init()
  mm: remove unnecessary empty range check in
    early_calculate_totalpages()
  mm/hugetlb: remove unnecessary empty range check in
    hugetlb_bootmem_set_nodes()

 arch/arm64/mm/kasan_init.c     | 3 ---
 arch/loongarch/mm/kasan_init.c | 3 ---
 arch/riscv/mm/init.c           | 2 --
 arch/riscv/mm/kasan_init.c     | 3 ---
 mm/hugetlb.c                   | 3 +--
 mm/mm_init.c                   | 3 +--
 6 files changed, 2 insertions(+), 15 deletions(-)

-- 
2.43.0


