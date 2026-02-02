Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB6BE73158
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD606B0099; Mon,  2 Feb 2026 06:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAE66B009B; Mon,  2 Feb 2026 06:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CB26B009D; Mon,  2 Feb 2026 06:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 577B26B0099
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:26:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC645C1AC9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:26:46 +0000 (UTC)
X-FDA: 84399289212.13.5F60BDF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 292C4C0008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:26:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g3I6Rjdz;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770031604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WFjDvdrRxVfmhlp8tolkgkwAJGMn1WaBNsOsOm3xh4U=;
	b=gS6VsGomH1zav4FdMkcV26s/UfEn2kopjfLLIG50XMj3wdbYVRau8xSOctFnj8Xmc6BJv9
	MWoSyjI514OR5dq2dKnkysSV5PxRuhVtdQxxbjjDt36HYl8+fGojl/yssaLP3wUpVeXYCu
	tn23KryI61rkhue3tXgDsF+nXlbu6Pc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g3I6Rjdz;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770031604; a=rsa-sha256;
	cv=none;
	b=V3H4A05SOBcEoSyt0+Eg4yFy1I0DxUDMvAukLUEU1/ejorGOLkDAZ9FA8LcAiJg7P9fGnR
	5LbAsjXQB5ac9Kigpp/h8GiLARw3Q88QGcLJ1cL5q1BywFuL2e4AahC8mMlQeoRm/9csN8
	R4RZFBd8ybAGCdCLCfFChvXqXHKQUTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770031602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WFjDvdrRxVfmhlp8tolkgkwAJGMn1WaBNsOsOm3xh4U=;
	b=g3I6RjdzrvrO544M7+Hknxhg/x0uR0EGSxnS7OHVKMiqeYRqJvMVPEwCqSngbosmC+JQUi
	fkvMDO2q2LQaGawYReH5Ukw6IAnbY/NwdJ85tQ44w4JuJwNIpyRoQFkp34s7/bWST8k6H4
	ioog2x/sHHmkYw40ydM5h29nlyGJrrc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-SD40FBSYPHmI51YRt_RhtA-1; Mon, 02 Feb 2026 06:26:41 -0500
X-MC-Unique: SD40FBSYPHmI51YRt_RhtA-1
X-Mimecast-MFC-AGG-ID: SD40FBSYPHmI51YRt_RhtA_1770031600
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59e14ac0ed7so1937765e87.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 03:26:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770031599; x=1770636399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFjDvdrRxVfmhlp8tolkgkwAJGMn1WaBNsOsOm3xh4U=;
        b=aAv7b1bd2dV0PvEdEve2XdTjHTFwiMQyrbgX8pog5saCrzntzHgaURlkxfraktpO1s
         gl5tUKafnicyTAVPf4Xuby/eUz44we9akngth0HUvLC40liQloXkzLluGBJxF59ZGxKi
         cUSyl+xEvCLrnTom/qcE1PlJJRn2cyU1vc2pD0IOsmi05L/1AU27jGXmKkYA83uVsN6i
         NV6T37hY+Hc2fnZgugA6WkkEf1OYDp5ZMBHG7YFFy3pQx/Z7i/wVtNO5PK1D/Xv9U1C/
         T+71tv9sAoPcVZc45IUoa/zirh9e5Iz+wFRq+SNBVC0UmLCvc0Rp7Ga+6+7CrLxd+vJP
         //ew==
X-Gm-Message-State: AOJu0YxPgdkXzLOZ5s18KMeIo7jVnm1fvfB7zrv3ENsqFHwxn6vwFzPl
	bRV0tlg8fn9KUs5uQv2k7PJTIv7MqqBq9BCnpgwr/koKx21cBIZlUUT3CSTx+7QD7Lbx1AI/shR
	Sgg5r9/mGJNyT0Qk9eEOCPzJ+CTFY1DVBAV0uhkKMZD1gU1u9q8XryPmB1bLccnhySesVjhnaNV
	h0MuiJPEtbLVpAFtjpv36aS/BZmL+iSPXGWiE=
X-Gm-Gg: AZuq6aI6ukcUTnr4W2r5CP/vcF1AJW1PUANDiYlMgFzTy8X+0I5/pAeqEiPLE/ScUa/
	KizxYBW/aKMAQbWXyEUqnltouHQ8Vd/dL6gGCx92e+RIkNmmD2HM/u6Arp8Pi+SJ9EeHknZfhJg
	AvBwOq7cdV27E0xvC9Q6486x4rvMQ9zi9YxSANLgnFaVar2SVT3l32gzK0ydrfyB7sOG911WAIS
	cjBPWGUdJJE1HPxDBSzf19VHW6C+CIOxpniYcze96kiPSIYEI1j9Dc0iUdYTZhytwMu5kdOdX9C
	rYpx0PK4MBWTIukcAXRp/Nd4bxzrGuYIApyQFDDWALnGqP5Z6IetWibCvMpcDC30MunF22YMWk+
	wd46Ms9aihAuHoRkOZE8diI0i
X-Received: by 2002:a05:6512:3d93:b0:59b:9f92:301f with SMTP id 2adb3069b0e04-59e163ff690mr4203309e87.7.1770031599079;
        Mon, 02 Feb 2026 03:26:39 -0800 (PST)
X-Received: by 2002:a05:6512:3d93:b0:59b:9f92:301f with SMTP id 2adb3069b0e04-59e163ff690mr4203300e87.7.1770031598523;
        Mon, 02 Feb 2026 03:26:38 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e0a43e8ebsm3221336e87.55.2026.02.02.03.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 03:26:38 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
Subject: [PATCH v4 0/3] Migrate on fault for device pages
Date: Mon,  2 Feb 2026 13:26:19 +0200
Message-ID: <20260202112622.2104213-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 67ZILJvile2USLEfhhnrr4ytYDYncJ9WcrRHWzcqXDE_1770031600
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qa8qfgwpk1kmz3938rh1arzsxmgipqqm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 292C4C0008
X-HE-Tag: 1770031603-824229
X-HE-Meta: U2FsdGVkX1+BvLfZ5dZ1akln18BUCAbA28reKfsSpeZf/JZSiEt9x6dgGOTI061wnD2kd8eCxrxD1qYo0XXhU+eyU9uoSkp+KP+vBiV4Y9unAwa2YbM1IGiZMmAIEMSgE+8voRDMM5S+LX6dJMemTalw1n+gFWQ3z0g0U1ko8mZiFNEYZJgb1Q/smirYMK4o1pf15PYheL9nMGiouf4Wh75WpVLJuy2qbu+uVSNqj+vvPiGEUhpb/zv6vL9FzX1KjqQpX6t73zugxMxo/rjxsNsvZwsV7qde044E4whd9tOZ4Ml6qQOpo65akIpl4aF86OXW+wrm7R1z4gpSyvOfk4nG5oGDEgaD8ehrPnFzO7FhojIu9/p2xvsixygZWDnrZvExhcskPgqv2iPgfgaI+YXaVuhX1tAGcAPFqrqAq5QcqvXgw6FlT8nJkdQQvWgsbQwVY+J2CLGIe7xJIiOFDbDUmo+Tx0nef+dC8D+jgW5Mr6D2Gf7yE3v5bx9G5KkGyhNLmPG/gLXU9tDFcydfLa/HUoC3oUWKpXRee7QjuJEzDpmyDaUAlgYNeO+V1gqY5iLNoBP2JyjENTKAZbyjpHRKoCOIvNrQh67BmOhAycHBSnVi6yXFQPtd2SL3P5hOaXe7EmDHROxmr4AM9CkaHWmuuvlU2kuCsUuWkDHzHQ4IJQlN5R7JmbIJzMmvi9aO+DTM4+x2jXHgiP/MzMEc0UN89x5YdJXKH/ZHmViLn9tgVWCZMDCNZuVF7f2r4Q52yeWuBszIVDR3TcEYqm3tkkfoOilxWPOV/X/Lk1C1FKJsTn3MVis0ckbzwfaQlVEr5be6ObVSW5DAZAtrraT5Bn4xiyujxozhcpGy6Q0/QRQXQBtKbPQeiyZSj7xQIECYalAD2QWEuUU+p+0ZK75n0Gt9AqwaAPw7t0d21FuEpL4sXiSJVl/evrIdAV2tfL1VugWjRgfalWDFFuZhcJF
 4jkSqry4
 7rjKEVYsQndUkzQg91HDn5gPacRRwOcXVO8dJhEpgNIGQtxjSkt1AXXTr3o2wDwCEQ+KpkiMhqLBxcUhtRtb9fH6LIfhu8lX5CFQa0P71heMgAiObjheTSNQACHXNhTtdTPKi5cOyv0HR9kPpHvKXYdujj0lFktFLDy5KyIVcP+uagSC+bOKM0muKNLO0LAaaD1JO+Sa5gptUtc0uQCyJ315bMP78PoULNMppmI1FGiYQMJrJQo38UH9i/CuL7ZsXMq0x103wKh4WgrHOe5WVQUfyAqHhasq6uYpmYuuGo3RE+bsIoMPMa+UysV5DVkAqvTjD0dgo8mnZGiAD8TmM1giGY30lnNbJpv10t9i0AknTabmilnX3u8E06M3aXI2H9dm6AstXK5aXjHMT9Z6YS9b0kyYcLA8NR/u6nvzxxjhv7NM6bHb+pDru12iOApeOXEhD
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
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes v3-v4:
  - rebase on 6.19-rc8
  - fixed issues found by kernel test robot with random configs
  - fixed typos

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
  - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/

Mika Penttilä (3):
  mm: unified hmm fault and migrate device pagewalk paths
  mm: add new testcase for the migrate on fault case
  mm:/migrate_device.c: remove migrate_vma_collect_*() functions

 include/linux/hmm.h                    |  19 +-
 include/linux/migrate.h                |  27 +-
 lib/test_hmm.c                         | 100 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 802 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 594 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1034 insertions(+), 583 deletions(-)


base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.50.0


