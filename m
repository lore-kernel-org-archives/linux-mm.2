Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3971094480
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1296A6B00C3; Sat, 21 Mar 2026 11:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C496B00C4; Sat, 21 Mar 2026 11:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FEB6B00C5; Sat, 21 Mar 2026 11:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF98D6B00C3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72FFCBA204
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:11 +0000 (UTC)
X-FDA: 84570390702.23.1E3989C
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id B098940016
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z0AIuljh;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=81HYMZ3vgCAeT6eFRo3fsP2FLDXA0ujBDRYZ8Ob/cJk=;
	b=mJKcsXnwrFelenSBuC9CpEUVQu4wDfefB+mW9xOC57br6/C0KvEcPgwDPlGpKnekyH+X3z
	hkkIRKAL/iehteexNbbinVLxwab9RLRz302ExM7zcdCRCIXPTrHDOvxDflhaFMIDPJThWh
	emvty82ZeUrXMggdqb+QkI3YVywG8Gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105449; a=rsa-sha256;
	cv=none;
	b=h5rQqUOJ66P9eshTApgFS6R4IYrGGQ2uhitJyy5wP3w9CA1ZXqkx7ak9zKAPug/vikaBbm
	iYJGl5xiwgCEtZDmrDYhuV7F5UWdN/yZXyZGDRaAc0lrr0ER1EliAUloZt/gBgnCVOf4rO
	n283ALaw8GYHGMOslxg2frjYP0aLJAw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z0AIuljh;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-6028bb29cc9so1605741137.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105448; x=1774710248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=81HYMZ3vgCAeT6eFRo3fsP2FLDXA0ujBDRYZ8Ob/cJk=;
        b=Z0AIuljh/WeRFIhjBMnPqouMco0iCPKUzDnORyB0jtU5ZRkKf0hepisR03YMhqKvoR
         pe3nTN+haUA+MvMx+UZ3sGU4hPRVBU/EFW2/cvS84znV+qARUCTgUZN1eyj9fLNga1C+
         byaZi2Hm0xucno9ntor38Hi2S0niztexdI6t4gD5q28HLiNK9AqHsJBg6duoCNVNCrvj
         GAsf5EWsQIArKcvKk00LQ7IOPQ1Wh/Nwlf+3hEChmD2F59WSlBxdM1lQ/JkkDhAj39XN
         vseF9KH4urnKL6hdP5NMZMJWjx5wT9ym3QPtc4ZSizxuRr6b8dofxduZPr44C/kr+y4G
         9trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105448; x=1774710248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81HYMZ3vgCAeT6eFRo3fsP2FLDXA0ujBDRYZ8Ob/cJk=;
        b=c6tHL1OnbS17PWhWjaseH020hmVL4cvF+ZnHEiqzKajLflY1+lUrqs3b4nbadhpCex
         k50kr2XAYJAq2Nv30mvCV9xR9D9fsi3Eb8wXsKdRyaOBphUc6U1+F2gR01trtU3ZWmxC
         XR49VJLPdx1HV8Ba5kYbow3EXnePzk2ZU8E+QlTBixlw7ShFmdWDW+9/Wj4/d9lVHVaJ
         lWdMwVbHQz6Fs5WybxpEFuUiNEg9fGYeQBLCIqsZBoWv/sCji8/a529YLRGe+1UkTkUy
         Jt3BHXEacA6By+JwmYVJlHE0E6V5tlbmxVV1Vn1mqREHpG8Fn0UnWkykWXpwAw26IJMr
         Wkhg==
X-Gm-Message-State: AOJu0Yx9RHNAMEwfHeXCHsOW0Bjn5uAKP+hndG5d0dY+0UJ/N3HJj8uj
	QVLqIudE9rsAU5jHDa3VS2W9y43bCCMiBdJB0KkG+1msrBHCLMKjdsw6Wc4JyHDEj7cJWeSFc+r
	LOwO+
X-Gm-Gg: ATEYQzyb4J0F4lVct3/ARDliXtl1Q/9Wp1pRaC3VC5mSLLJ87pLAK9rIEtbRE9go1rJ
	7Hmy45lD+OHp/6YPQYQJwHfWkA/d2rIUFuTX7iQQ4pV9SAQBkzPBNS7cZgirY1XlP5uW1hSU/+B
	zSyIQ9Q5MSsLRD1Rpo7sJMgbmfHHs6HPw9lNlZL5lMkokaVv80euAWAogLOPD80qZbomA+PQ+MP
	5FHH3/ZhaEJ5rtd8A1pcdVy6otnuUdwXp/TT4nSklAYyphMc8k43FhhnunDyPZMLNUWyLP7YV2z
	n4k5Qjvp3ZqI5UAiEOc1P59mGAgWD0RBoYabMNXq6Jr4b2JPYczxRFcySHMskIUQ6I1fe/ZX0Su
	0dO+aukoP8qc+UIiLm71+SGRETbpopsJCh0Gz8x7W0JmQC2G0nPJFxxthfdhyWdKATLE2rhI2wI
	OYP2T90BSh0y36qCa+Qq7gSZns4vuSlsRfIGbIXN6H0Jml1jY88rmdyraUxz+3KB0RXgRhvViLm
	CXfmr4M9+kQS/y2t6+wpiUpVQ==
X-Received: by 2002:a05:6102:5989:b0:602:79ed:643c with SMTP id ada2fe7eead31-602aea8cc48mr3376178137.7.1774105448304;
        Sat, 21 Mar 2026 08:04:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:07 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Date: Sat, 21 Mar 2026 11:03:56 -0400
Message-ID: <20260321150404.3288786-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B098940016
X-Stat-Signature: e71h6sdxszbp71tueksmxgepsydi8j4h
X-HE-Tag: 1774105449-561901
X-HE-Meta: U2FsdGVkX19EfsyBe0/uXB7mr9P33ZeXzhNJ4qIoNP8mGYzCaOig46qnIn0DPZkFn1ez+/BpWHs47xDRKXcPJ5JlAmGp1qcOZCXFdbFEBLQVXKrvr+tbq/yR9Ktph8LzGrcOFnbiGr3o39dS5ExXLPvCrb4ExYxHHZGjXZ7MWEFbeeidPhZtcIZNIQniO1hZXIU083C8ocy80KgffsX+yP8+/FJ0j8TlRI7OjxmmunAjIfISr+bHjmKkrsKLP+2D8GY3GRwUE7Mwg4mnSIdCnqAOQoK4DR5wsUYBlluY6q6TzvuyxaURa2DGIjdV+33GdGtleCoIeWeXWWQmP43eo1n1g5q7j6Ark9VUyOUL4enxzv0BGL8IWx6uags/wUHy1g/ZDtSdGqFhKhME+cPPpYCWJ33dyIsCoJ6nKaH5VNhs1fqJHETZPm7ZgjfhgeGzQlmevng2f4GiV62fRnENixQGlLPwiv3bTzTJUzKIB+awMGgLON4yAE2Sq3tP7oaf1xEB8N2GHn20iwae1IkSadKFvETvKSQDNTig7czGjoxMevI10FIEf8K0RXSy5QjPsbkHpsGirSt/bkhtILTlLwUYZkFCGdyyq/jY0fvSZEGVHr73idiSm4yVohH2IoRWGg27L8GGl9Un4yxBAu5BaSUbAW0rz4ui8kIN6G2qrGcxdPcEz2xw71ERWRYRqeuSBpq2A2y2IRwlgfDSvn073f9q4tJ/Lst0FW7Pwicxu1mOUYN7TD1P0k6OfAsT6NRXpvXtV1HHUqt1fGYzqarfef7XBtHlMZ3o/1NCqfa4/DNDg5HxkRxNsPrwnl+O7xa0iWvicgCEutL8nke3M3SgwPaqpyUdFy23n3G4wIPgNGrSg3Wi3TE35g/qnrsH6VC2nmbhV/FH9ZwcHDp+oSK7f2hAoetYDcE6IZcBLQyXs8o5cPlrk0aPrC8z4c1hltZmhpVVjmk7l2nuRI6ZYZZ
 n5a2khJ0
 aqQSq6ssD4KJ2XniopWyp5zMa3XgqD2yYTDlXJOjzadRU54JxtlyUfbfiaaLXxBJg52GpmFsrtk5DMC3VMaYEu9ZrXlvRP+pnac4lrY9La67Qn/AEUcGmsWmDJDKCiY0dyx/Ej8+Ltn5w3VzBQVSWkC9eLjdmNDsH5iiAg+xW16pq8yfpjwmdfXbGo8PGbADT+ukfxOZKX42ZbJeu/X9muc+A9DgNuuwq/R+y8rPM6PkB8EFlhcZQSVatUkStYWiuVmJNtGDOTMBLMTccqpdMnyrE6lNrkK+v3uX/UHOX6SngZcDE4rohWBqxzqITsxAqrTDSQMEVDxnAaEjkiGJTaJbHwTtM77zNZrdXvMKmzhH5HwnaokQRBCmogI1XOU0pmjrKE7qZfs9uS6Nvz6Zfjabxz/TnSNy+mt2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver currently onlines memory during probe using the
system default policy, with no way to control or query the region state
at runtime - other than by inspecting the state of individual blocks.

Offlining and removing an entire region requires operating on individual
memory blocks, creating race conditions where external entities can
interfere between the offline and remove steps.

The problem was discussed specifically in the LPC2025 device memory
sessions - https://lpc.events/event/19/contributions/2016/ - where
it was discussed how the non-atomic interface for dax hotplug is causing
issues in some distributions which have competing userland controllers
that interfere with each other.

This series adds a sysfs "hotplug" attribute for atomic whole-device
hotplug control, along with the mm and dax plumbing to support it.

The first five patches prepare the mm and dax layers:

  1. Consolidate memory-tier type deduplication into mt_get_memory_type(),
     removing redundant per-driver infrastructure.
  2. Add a memory_block_align_range() helper for hotplug range alignment.
  3-5. Thread an explicit online_type through the memory hotplug and dax
     paths, allowing drivers to specify a preferred auto-online policy
     (ZONE_NORMAL vs ZONE_MOVABLE) instead of being forced to the
     system default.

The last three patches build the dax/kmem feature:

  6. Plumb online_type through the dax device creation path.
  7. Extract hotplug/hotremove into helper functions to separate resource
     lifecycle from memory onlining.
  8. Add the "hotplug" sysfs attribute supporting three states:
     - "unplug": memory blocks removed
     - "online": online as normal system RAM
     - "online_movable": online in ZONE_MOVABLE

Transitions are atomic across all ranges in the device.  Backward
compatibility is preserved: probe still auto-onlines when the configured
policy matches the system default.

Specific notes for maintainers:

I downgraded a BUG() to a WARN() when unbind is called while the dax
device is not un an UNPLUGGED state.  This is because the old pattern of
toggling individual memory blocks is still used by userland tools, and
will disconnect the `hotplug` value from the actual state of the overall
memory region.

Unless we move to deprecate per-block controls, we should just WARN()
instead of BUG() as an indicator that userland tools need to be updated
to use the new pattern (the old pattern is subject to race conditions).

The first two commits are semi-unrelated cleanups that conflict with the
changes made in the refactoring commits. (memory-tier dedup and align_range
helper). These are intended to be used for future cxl region extensions,
but if you prefer them to be dropped or submitted separately let me
know.

This is technically v3, but the patch line has diverged considerably and
I've reworked the cover letter, apologies for prior obtuseness
Link: https://lore.kernel.org/all/20260114235022.3437787-1-gourry@gourry.net/

Gregory Price (8):
  mm/memory-tiers: consolidate memory type dedup into
    mt_get_memory_type()
  mm/memory: add memory_block_align_range() helper
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  dax: plumb hotplug online_type through dax
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug

 Documentation/ABI/testing/sysfs-bus-dax |  17 +
 drivers/dax/bus.c                       |   3 +
 drivers/dax/bus.h                       |   2 +
 drivers/dax/cxl.c                       |   1 +
 drivers/dax/dax-private.h               |   3 +
 drivers/dax/hmem/hmem.c                 |   1 +
 drivers/dax/kmem.c                      | 457 ++++++++++++++++++------
 include/linux/memory-tiers.h            |  34 +-
 include/linux/memory.h                  |  22 ++
 include/linux/memory_hotplug.h          |  32 ++
 mm/memory-tiers.c                       |  29 +-
 mm/memory_hotplug.c                     |  67 +++-
 12 files changed, 501 insertions(+), 167 deletions(-)

-- 
2.53.0


