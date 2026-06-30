Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B2BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1CB6B00A6; Tue, 30 Jun 2026 17:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B7D6B00A8; Tue, 30 Jun 2026 17:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01406B00A9; Tue, 30 Jun 2026 17:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 868E06B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:18:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BF0CA013C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:51 +0000 (UTC)
X-FDA: 84937843662.05.562992A
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A627160003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n0MBkqfJ;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854329;
	b=Vdu4t89RjK2gGYhZTP3tKE3r/dUOWVx7emzJNM79uTRwLNj7S0ZXeskoiJ7HkWSZtfLsV/
	xq77sBh/eFdHruO1yCC0nfOWyxCFN5e3xgbWgmSA8OqRVsuF5A0R/2BI42os+VGu7eRIA2
	aQo84ZDrG1nscftT6LyLgxQg4nNoVD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=15soTVn10pZL1HzcUE7vkWAPLmAyPlWsN9L93RXfdBQ=;
	b=aCRCSBd5NM7sWaxYhpj7UJDQDC05/tJOnmEcO+Q5dFGm3g5N3LGmOZ1UsUpYWr0Fbtm4zJ
	pb1/HIcNxhfYOWMTRTdGDfwwHd+7txU9L5hmlKwfGTd6dmn6mHQSibh3/KCxSFrstNmM39
	8h/m0+QaN/QwiXEyZwo18BKBU+W5pRo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n0MBkqfJ;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e512a9a6bso197060685a.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854328; x=1783459128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=15soTVn10pZL1HzcUE7vkWAPLmAyPlWsN9L93RXfdBQ=;
        b=n0MBkqfJSGvVVNDFVIHNlHUZ81pgnbgmXvsoUIa9aRXUmaN67+AHoNbTyYQSbLP3/w
         0+cB0eahr/NxmEDm8Qv8YDfBKBBRuL67zHBzta2mc7vEWpcB+jbVZ+BrpIO45y6WWh8Z
         j0uNm6HQa9DdPFBWdc7zUU95Temid2U3YTSH+zRh9sJMZY170ML/CB6pmZ4yHcfGUg/7
         fOxZ4+X0vCr4o20zmPUuDa3ueMJrW2kTVaqM4Wk/i/2x3mRpxCGQqYV2I6QspCstp/9y
         aPODKDc7LptooRBxihFdf0kcqIUb219fHzuFEi6Tr7wsinhxHZ+qjy1RLzXFFHqu2fdS
         lGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854328; x=1783459128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15soTVn10pZL1HzcUE7vkWAPLmAyPlWsN9L93RXfdBQ=;
        b=CLEe9RrIZqiINAaBUIBpodq1wPYjXpx0yOrp1SUxEPij2t8MrmtDD5rEFqSGRvYQGn
         JrUdTFZXy7Cx3PEWBuIemYQZnc3ArTX8dOqrzTEKqzTPsdT9Qs6kaf91tyY7t/5p3rec
         YR4LeWWLEuBXfSH0OsI0F540FLrNdYD+xzyYDdLAHgrNOhoq9GlQnYQmrj5unlIHUtbr
         MSJH4eS3xDzsb+7iAWiIpLCMPqdISlx0pGuXXSRzf4KvBxcxOrHjdNhiEjoZjQgF/Orv
         5mwVrturzBEJev6rnpSYPwImGGE1l5jkHAB8v0YbBI+kp+ye3OI3YTMkkj0btXYnO4Pe
         9kQA==
X-Gm-Message-State: AOJu0Yze7OW/OiQsZ8Ae/VELfvbylfJm2uox6lV+j2g/KfrEwavgsg47
	m4VArTOSL3CNi/sZ4waX00kRxb748fBe4Yt+z5XXc/zAqBxb256Th6XcDh8EGXnZTcIXgWQPZ0w
	9kUN3
X-Gm-Gg: AfdE7cmqIeC3dyYA1T9ZummZVmahA9wZ613WmtT8RhLmPhKuFRT2SuNujIDDROW45nv
	1hHGtGx0L3ZOtLfapSdweXJzymehh3dd/auEXlz8wzJH4UiqY73mPMOuoi72LNJuQh1ZmDrU4Md
	i2mKOSmhQf8Q9sM5NhGFSyjT9KMG6CNesFDDJr70EA8c9j7o/HdpZhGc5ai598Amo3Y4SMQAQdJ
	CbGRxxHuHproi5V7gwjGLsnmaaQgoCxPowgm/4whmxGE00S1yTahoHZgh/Vx1At4wbtXqtai44T
	O6PxodZ9DhRFZaQEj+4DmgQxleMWX0XIyeq6YDuvQ+LsK2PxGhSnCrCym7Ds63wh5ISeQmlCBnH
	2NtEHEK3jkm/94gLj5d/+tjXerCkRE5DttBegHub5Gz71LA2KoZqF2lEfhfGd2biwUHRDDWPE6x
	exOSsIE9XebbulEZUmKm9hHClvcY35qlo6HcanlzBC6s60HPj/ur07Vuj2sCq5quqxsQFPnC2yh
	w==
X-Received: by 2002:a05:620a:29d5:b0:92b:67e6:8ac0 with SMTP id af79cd13be357-92e6284f33dmr789795885a.74.1782854328078;
        Tue, 30 Jun 2026 14:18:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:47 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 00/10] dax/kmem: atomic whole-device hotplug via sysfs
Date: Tue, 30 Jun 2026 17:18:32 -0400
Message-ID: <20260630211842.2252800-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6qkw4ck43tq6gphrju49egdknfrz97z4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A627160003
X-HE-Tag: 1782854328-71932
X-HE-Meta: U2FsdGVkX1+o2eHwhnfW8XUlhrM8VqgxUmZUIZAV9MRCwNqbsVnAZVHxNDQ7z4PTHj4nTLs/59iuFM+O5Oc335gAjXOtYza2vFzrTpHZIqPQz7mcug+02gZYXloWzI4TRTX2a2tyjXjVCCjBsO16llsa09NKa+5HaYOxUXfVkbA3WLk8qmus2KEtnllLUx/PU2mTaONWntNeOAhykqhLhnfz003lyRm19Z0iFFoX9h1hpQWQeQtBQE4kDNXxpO1OtVXm0cBZKvuZ5sLlvhDKPN9QG+BGTzqZc2vWxqMKX1SbsN2jM4GvsSnDmUE1PJE08su+JfAevyOVSTzRmTg41LFtHNjLEWAN0WFqzY1NLupYPdFYkMV2w9UxdFs9Gz2MBfajk8hnX5eWWt5kYEiYh+ovibJ2IuijZ2QsMK1+fxaQu8vNZbCPP7ojhPPtKbW3dTTSqN0FjS3wSx+F9X60PuCiHFGCBFc7H+Z4hWGz2y2CtWnt5YDNNBrwybSqbfHv53NkuXRCPakur+Mk+xsDnLDOV3ddeUof4dIhhBrHQMaJPZFFPiWbArgMxoaXLWFbBBifLvEQg3nCP8y/yo3l/CqCQOvc2oZAjluOKRIpru8rY2D9ND5CXaz0jg/70ZJ/pnXqSkiBmkY3OALrWAh/i/A2kJlo3QPTtBymbgYDvdwWs/4wKIBkjeuetZ1Y0L6ErUuCbHufI/72Nk6ImCRlpZ9M3buFn0s8H9kxV+6Usjhh9tHO1DXeBU8jKynmEg2c06LeLBEG97L0A/BXwcoh7J0+wFvtf7RkDYun8Icjs6v9mskT64+tDwdOP6iau4v5CtG3J3niy1IygfJX8FdGaKJSN73QHOu9UOC8Lzeg4snjcwDA3rC5ChV9Qep11RgpHJUmNeuPHPuEdbEUCkQIBca1yR34TYdHDpD5pC/GmU0KMEvGNC/Bl9QZ4tU/KocZtQua8lC2eRbpC9J8eYy
 pjOol3ku
 3U1F4p2dzOUmsTFB+BSCMCS90+oPISv67/3fMjhiRIbTZe5CIKDGKpGSar0gOWgbR3hxJsgMCsmVPbB6bkDQgw5gEuVUuB0t1+fVlFWcoshjybVfDS/i8KjKyQVl3w/Db8vs00fPvW7zBcTAn9Ul9NeBSty/GiHaBWWu6YLB9AiCX8TTzZaxDZxqvagvkXwegI2An11OkyNz6WtcqZcNZ3lwaihdofyiXO7AeOt9UWzJphDQ2omLNYwHMpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver onlines memory during probe using the system
default policy, with no atomic control for the state of an entire
region at runtime - only by toggling individual memory blocks.

Offlining and removing a whole region therefore races with other
userland controllers that interfere between the offline and remove
steps. This was discussed in the LPC2025 device memory sessions.

This series adds a sysfs "state" attribute for atomic whole-device
hotplug control, plus the mm and dax plumbing to support it.

Transitions are atomic across every range of the device. The state
names mirror the per-block memoryX/state ABI with one modification:

  - "unplugged":      memory blocks are not present
  - "online":         online as system RAM, zone chosen by the kernel
  - "online_kernel":  online in ZONE_NORMAL
  - "online_movable": online in ZONE_MOVABLE

"offline" (blocks present but offline) is reportable for backward
compatibility but is not writable because it entices the race condition
we are trying to solve (offlining all the memory blocks in one atomic
and unplugging them in another atomic).

mm preparation:
  1. mm/memory: add memory_block_aligned_range() helper.
  2. mm/memory_hotplug: add mhp_online_type_to_str() and export the
     online-type string helpers.
  3. mm/memory_hotplug: pass online_type to online_memory_block().
  4. mm/memory_hotplug: export mhp_get_default_online_type().
  5. mm/memory_hotplug: add __add_memory_driver_managed() so a driver can
     select the online policy.  The override is restricted to in-tree
     modules via EXPORT_SYMBOL_FOR_MODULES().
  6. mm/memory_hotplug: add offline_and_remove_memory_ranges() for atomic,
     all-or-nothing offline+remove of several ranges under a single
     lock_device_hotplug().

dax/kmem feature:
  7. Plumb online_type through the dax device creation path.
  8. Extract hotplug/hotremove into helper functions.
  9. Add the "state" sysfs attribute.
  10. selftests/dax: regression test for the attribute.

DAX Kmem probe still creates the memory blocks by default, even when
the default policy is "offline" to preserve backwards compatibility.

Unplug (atomic offline+remove of the whole device) is the new
capability provided by the attribute.

I downgraded a BUG() to a WARN() when unbind is called while the device
is not unplugged.  The old per-block toggling pattern is still used by
userland tools and disconnects the 'state' attribute from the real region
state; until per-block control is deprecated or restricted in some way,
WARN() flags that tools should move to the new atomic pattern.

Changes since v5:
  - mm/memory_hotplug helper into own patch (david)
  - offline_and_remove_memory_ranges - nits (david)
  - offline_and_remove_memory_ranges - warn and continue (david)
  - memory_block_aligned_range(): end-address underflow (sashiko)
  - dax: store the online_type sentinel as int (sashiko)
  - dax/kmem: skip ranges that failed reservation on hotplug (sashiko)
  - dax/kmem: on unbind fallback to legacy if still online (sashiko)
  - selftests/dax: avoid cascading skips, clobbered state (sashiko)

Gregory Price (10):
  mm/memory: add memory_block_aligned_range() helper
  mm/memory_hotplug: add mhp_online_type_to_str() and export string
    helpers
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  mm/memory_hotplug: add offline_and_remove_memory_ranges()
  dax: plumb hotplug online_type through dax
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug
  selftests/dax: add dax/kmem hotplug sysfs regression test

 Documentation/ABI/testing/sysfs-bus-dax       |  26 +
 drivers/base/memory.c                         |   9 +
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   9 +
 drivers/dax/cxl.c                             |   1 +
 drivers/dax/dax-private.h                     |   4 +
 drivers/dax/hmem/hmem.c                       |   1 +
 drivers/dax/kmem.c                            | 516 ++++++++++++++----
 drivers/dax/pmem.c                            |   1 +
 include/linux/memory.h                        |  27 +
 include/linux/memory_hotplug.h                |  14 +
 mm/memory_hotplug.c                           | 161 ++++--
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 190 +++++++
 tools/testing/selftests/dax/settings          |   1 +
 17 files changed, 836 insertions(+), 138 deletions(-)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

-- 
2.53.0-Meta


