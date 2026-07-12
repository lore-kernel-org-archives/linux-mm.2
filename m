Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D54C44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B6E6B0005; Sun, 12 Jul 2026 11:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC3C6B0088; Sun, 12 Jul 2026 11:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB896B008A; Sun, 12 Jul 2026 11:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 745146B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE77A1408BE
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:17 +0000 (UTC)
X-FDA: 84980548674.15.96A9033
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 259F4C0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hFwbigxY;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/sA+zg3hun+tcy2tg/tGGOKyNNSW3ITFRulSJiyHuZ8=;
	b=SEfMkAAlUzIopA5+KtGyiCELXtmE8a256VpdKfKVMgPT5hEnLUJs5Qp39IAkitZB/JCzD8
	1NebX983Heyl/spZEL6+b5OkWIAhUFJduZvZmjxZ4psj2Ws3pN3U+1dls6vh1l5n8Js37v
	+P7NBeZVMfQyV63LgUVEVdGvft4Vlgo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hFwbigxY;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871116;
	b=Zlst+pX4tdf9gqCRJvPs9QHd2tM+/Jmaai8N13E9Rfe6KFT7n8PSYga1gl2rMMW3QKdEBG
	yGltJrbghXKdgMgbujtjzOpC9ZXb2E2SY9cUkELmTgtGTuYBtBvEk15HX1xHwnfV5QyT9F
	JA3b2quB3JTak2ri7M7ODEGXZuh5J8M=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e5d6f35c1so193409985a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871115; x=1784475915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/sA+zg3hun+tcy2tg/tGGOKyNNSW3ITFRulSJiyHuZ8=;
        b=hFwbigxY4EpftB6bHfcp/LTq56qWy0THiMluunRJ2JB+lrE3u5+b0hjWLxBEtoV0G/
         QYTF2R8/wgkBD6V18k+8ISkCB0u1CplshwsgPCG+GPLQ4ZUYHvpm37XyjMlut94Xb8fB
         eN1A7At/4P1wxeZC8wmkY9yvZCJjU61E9SsUdzgoiYDPXOH2SAetAbIW5PXyTtldw5gQ
         WyhUA/LWqFOqb9mTM4xswXC337WpiS/c0TjQ9iVj5pxKaI/NmTDI9Pa6AgixY28Vdpli
         XXaeECbD2H0pfck/nNgP4TyTcczFhsX9x/RVJQ/g9sUsT71J/06qGwQRX8qjJGgaDuUf
         Kz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871115; x=1784475915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/sA+zg3hun+tcy2tg/tGGOKyNNSW3ITFRulSJiyHuZ8=;
        b=MzHhqofQ75U+oVM5Ol27Tdexe6PtV5MonSP34SY8yHF2vqy7hpRVDuUHBkP/klQFsw
         Rn9Tz6wI0Es4M0oxvaLiA8L0Cer6U432iWC9dDKjeK+clQLJKSVyjX14wy4eYu3nu7xx
         3bI0XO5HDfZSdazhxhUEalFceei2SGxIYlEZ7docoK8DrbIwoSIA8xeWiWYeAyDs+HPm
         y2HswEIaS8WMzrL1906HHW/3hP3mhCb+0pZlf23UwhFzHjqJ3rrunDVubRqwtp3xtUuA
         8oy8YlMXYgFz3jQ062dE8x2HVggRz1n0jWc0L6/jh+HwFAoCxEx4QLCJb8dJW3byVXH+
         YUWw==
X-Gm-Message-State: AOJu0YxJi1V+jknAUsbbALDClvpH3VdS6bJuLzZpG2bh8cki4I0v971R
	c0lOpdhSmIcHB3UzQLRVsD0JlbECAD/bwA7usymOf0JGyZga4tVmRCp0NRb+w1+QzWUYmsxVKmn
	IipC1
X-Gm-Gg: AfdE7cmJPAu4r83wEvENCQ4u+kD3yFDoVnZCDsNEtJGTBa28z2SQHbOc86wwjy73WtM
	GtzPY+e773TaQ/4WznkskULSAO3dYEVPBHhYAoYg/4W35bSLuAWH7NttfyQzRD0RjfvBLTjO4hx
	O5mN0aL5YSgIyhpl0mSU6Vm/JFqae75aWslJHCEjOt4iV/WYta6H7Tblsc6J2RkKCxsjzUzefHr
	GM7+egUYCfVBChSD2JYS+09SWllPbuDCzzPi786mwYhWDIKrBUBNiuKUNaPHgWJBUlL6NVHRDY6
	Ok9GFKHrLqNThJCUc9TeQlyypaY/89iROa4UJHGRKgrhXF8hloEf0SWh7Z1zkxAi9Cd3hmTIeFG
	NGt0+BiQRf2d8FS/FGHU70+tQcPTd4vTQ1CA0G3F4L8B/EGVT+1ABk+KjlnTujzWNChWymA7MA6
	DaTrHcmTgiQZb1BpulrTsC8t3hpU9UZVNWFGOloGLlY68/LdmKGzIlq9xMb6x/wPpNYPybw8L3+
	wTMlZsjjPFn
X-Received: by 2002:a05:620a:6f05:b0:920:4f78:3d7 with SMTP id af79cd13be357-92ef2b4b7e4mr642033485a.3.1783871115261;
        Sun, 12 Jul 2026 08:45:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:14 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
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
	gourry@gourry.net
Subject: [PATCH v7 00/10] dax/kmem: atomic whole-device hotplug via sysfs
Date: Sun, 12 Jul 2026 11:44:54 -0400
Message-ID: <20260712154505.3564379-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fc3ym5k8aj7duxid788ramqqq7gwy46s
X-Rspamd-Queue-Id: 259F4C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783871116-661245
X-HE-Meta: U2FsdGVkX1/NouY7/4n85mYgfMpeyr0oFq124WFFdu1c4/tPkMhPwZ7oEDL1c1t43FXLF/8i13iw/RzZCgYWMgI19nVWXk+woG013R5FOsztYlRTCoT6ng6koLsRvkw1srbRIN9uOr+CNc4q6DVSvrGn1dly4goAu33N93ttNKs1feDD4Ygf8ZyvDvNQn22DKjl4dAg4EEAZZ9/0Y7ihLo0p9ptwA+JycKJMm43ZkCJ5VvMu0VicSpy/+ZxcyqzONZiVHwoseTcp8PsnjxZOoGE3QHxcZMA9DxqJvfv6PfCMdjHBHtfgbth5pRQMQaqrfyJkadyvA8V1fiQaWfZ46K5w2cEOXcFNTo0t6aJLNYH1e1YL5jGM147LxC5WznjhmcS4TIAnOMLQyZEcpuUOKt2To5uIDDeTH533CJephZUcxXufVNZa+HlPiaCSjz0oJT7iSVI7oiwpEb0ZWT0DvmXzjQBsqqFKORUOdLyYEr+ONs08n3vRwtjrtzDCOk2KvtamgY2DEguC/WJd+GO6AQMl9dOQeB6rjjBh9XfY+3LsXzU9Oy+acxDVw+cLRZiO8CwGvXPENHbx3a36Eac/3jSDJfGIlxntQVIcLjksay3RaUrLU5gHKzn/IB+Q1TjYD8fAN+slz9CeGZSbwpNMLSunGOjGneeIRjZkEgVlntDK8t0CmkzRp1aOgJ5FxZqUbQIV7Nl/ujPzGdUcbYsyJ/gBxEU1pjKhYK/nItK3UJ3WR1VOutzAKiFtNZEh/NhZLrwBfhLEGa6wPouM9PdU/RzQe20yMeJkkk/JxCXv8KjChgGZnEWi7Mz3b6o48yBXRHCX/0+S9/ae3l+JikWMHqiKOEpEwQovsbV5sH3Q9S1mtwRQU3u+5xjsiowuOR5k4Y3WtXuUEpOW/PVMGRtafesuD0fSu/6unllEQ/jvTolvpRKL71vEtve2R7BuTCFucgC0VrTs5kowG9aL/xy
 DJFZ9Giv
 dpzZAXC8Y5dVr9RjkEaGVRohthQ1+IjBxv1uwnfAqCnpLL7Qnu0lwE0V67cUydvz6XP32L7x57dYMIFGNWeadSP9lrDyOeAz2utMh480GFYi5gt/HAIogcrksoTAcofixjv+uAHv82Uv+seObFs6uXD39DSPEoexPUOkB3SgjDbyLm8xLrf/4fpBJP/BtDOaZJGWgSz440ge+gXewdLwZ4/hbzhG8ODfOGdf0FwU7W+Yt/bbcmhcSWK656w==
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
userland controllers that interfere between the two steps.

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
we are trying to solve (separate atomic steps for offline and unplug).

'unplugged' (atomic offline+remove of the whole device) is the new
capability provided by the new kmem sysfs attribute.

dax/kmem probe still creates the memory blocks by default when the
default policy is "offline", to preserve backwards compatibility.

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

dax/kmem:
  7. Resolve mhp default online type at probe time
  8. Extract hotplug/hotremove into helper functions (refactor).
  9. Add the "state" sysfs attribute.
  10. selftests/dax: regression test for the attribute.

---

v7 changes
- picked up tags
- dropped !data checks (Dan)
- re-defined 'DAX_KMEM_UNPLUGGED (-1)' (Dan)
- converted `state` to static ATTRIBUTE_GROUPS (Dan)
- dropped DEFAULT until later commit with per-driver settings (Dan)
- state_store now frees reservations on total hotplug failure (sashiko)
- kmalloc_array -> kmalloc_objs (Dan)
- unbind reworked to just remove_memory() (still never offlines, no deadlock)
- added memoryN/state and daxX.Y/state desync test
- gated destructive unbind tests behind DAX_KMEM_TEST_UNBIND
- added DAX_KMEM_TEST_DEV environment variable for target dax device
- added comment in offline_and_remove_memory_ranges for clarity
- minor spellcheck, whitespace, doc fixups

Gregory Price (10):
  mm/memory: add memory_block_aligned_range() helper
  mm/memory_hotplug: add mhp_online_type_to_str() and export string
    helpers
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  mm/memory_hotplug: add offline_and_remove_memory_ranges()
  dax/kmem: resolve default online type at probe time
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug
  selftests/dax: add dax/kmem hotplug sysfs regression test

 Documentation/ABI/testing/sysfs-bus-dax       |  24 +
 drivers/base/memory.c                         |   9 +
 drivers/dax/bus.h                             |   2 +
 drivers/dax/kmem.c                            | 500 ++++++++++++++----
 include/linux/memory.h                        |  27 +
 include/linux/memory_hotplug.h                |  14 +
 mm/memory_hotplug.c                           | 162 ++++--
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 317 +++++++++++
 tools/testing/selftests/dax/settings          |   1 +
 12 files changed, 928 insertions(+), 139 deletions(-)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

-- 
2.53.0-Meta


