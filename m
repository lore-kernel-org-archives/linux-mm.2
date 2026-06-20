Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A0ACD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A7B6B0092; Sat, 20 Jun 2026 14:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972666B0093; Sat, 20 Jun 2026 14:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8883F6B0095; Sat, 20 Jun 2026 14:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB006B0092
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:17:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFF8F1A0217
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:01 +0000 (UTC)
X-FDA: 84901097442.16.D74B350
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8654100002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:16:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OvbRZs/a";
	spf=pass (imf05.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJKZguEXiL1hQOqIpjORXu9lui0EjNZRPirTC2qeoYA=;
	b=RV0TrGxmkxjjIYnBxiBbr9wXS3ElPQP2vakbdXRXLSy1DasxNK/EXaKbBBXcNIIPpFNnlM
	85uQk9uLd2VpY0mKzWI/bhRly+jNXZeGomPqYtpe0ElAPaY5B4sThlbeudetXoosfW0G05
	69YZ9ZY4LIlbrGZeIyBTbwFNLjRZKjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979419;
	b=n9v0bnckRek4O82/TB8vaWyM6XKbFB7UqozUrmX+kHLWdLT1QiAfAC6W0VdFvXIQ1QvwFQ
	DX9YQsOyvIYpMtv+EwuNN+5oD5RGO4eJKgAUPZK/NbmDg4mye4ZSiTk57H5hYOehVjogTv
	ocrR3rxut9S0XQbADVCiFosH2hj6HD0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OvbRZs/a";
	spf=pass (imf05.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-37cae998401so1456779a91.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979419; x=1782584219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJKZguEXiL1hQOqIpjORXu9lui0EjNZRPirTC2qeoYA=;
        b=OvbRZs/aOR8A3/wfwxdWjix3517hd0ZGBBFVboz+XeL+MeincJB9OfhFSVBgNVB7ai
         /M4texp4tqQPuoJ5cd2NTu7HRhhsZUOtgnt1ONHT950vXgI3NPewrLw+K8RXIPYkbd9m
         pgbt5YT/JSoidn26pxcIbCRBPWV4dbp37gVSf+w2NxoZRiz6A4TDP8RuYmD/gTYYNONe
         XO/d4vPq6vq97cuzwE2qJHXJ3kwP54pa2TR50dKcYec6fdRoaC2J+UTVAm4Q6HgEuzlS
         FnRsF0JqS3ORoMWWlb6F8rEw0Q3pOEUiwXfKYe6YCXPIBf5lszpBBwhoR9jVKCQF8N+J
         FptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979419; x=1782584219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJKZguEXiL1hQOqIpjORXu9lui0EjNZRPirTC2qeoYA=;
        b=mvwUZjROZQONwg0+OEwIR3MiHBFMcsYChjxLAeyp04KxwxQn8lCUHR/VGi57R5trBx
         jFf+ozUy9iEWvE1pYGidlrSflPspCtBWMsCnYq8VHEGDsHBP3GcXLvr7X7jryI+gnMbu
         sUHijmv1Fx40xhLr4bB5u3TLiijJKWjrFNgD2QRepVPYV8cdsGHh3tb8obPzleQ0nqcF
         RoUwjvutulW+KmGehix9MAQ+tL85PIbi5CF2HXrZJh1Rv4HYcAi76v1Y5nfwJY5cTQXl
         DUmXE3KKtOu1CrSLS/C4jm7leE4Pw3i0rtWHLVHoTVCRrKw7+L50mRFFM4uTF8MS2cws
         F0rg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/UDw8HRv6/jMppQwFvmfGgOOJsiLa3U4OPbgsZRJEEcicoE3+Gwv/ZDvSiZxyqaDHkmBFrXeIqQ==@kvack.org
X-Gm-Message-State: AOJu0YzXk5B5eMFMxLaKC+NNhScLWvOYkQ2GM7HRPGYjlspO+mR8COM+
	7wayJ6/SElmgRYrlIpoNnwEN0bookITM/5YbumwQFaSg8+o7eC5iBSXi
X-Gm-Gg: AfdE7cnhKyDdsVFFMALtZYj0H1QGJZWVfKuTUClbtCTKJP/A7KgA/+PLpMlHnz3uytj
	QT9Etg0Xq0lsbyBVHjwy00NFdDHgF4RquiBa4OTCDCPPcPNoGdV/vjlsQia5iaKPqvVeN3UJiM9
	ekj/j3HuZs7qhlzqeaW5WKVjLkibQRI5zu0kEIiBhIiBTbYEVeQe/csNtI4kPCR3Bz+Ov97sr60
	TtDR+g2ZlFRkiVDRmYp25b/sHiVNGjgq4wD+6OrFcOnEDDy+MLfCDTIO7iCxDzQyFrJYBrb06E8
	LjujHSVSdA18LMmAWWiko3t/sPRINpnTrVVnQ8p8uG8yMHDDHSFmwSaQqMkamSWQwJNKfGoXJ/8
	o+SsMTF5amZuhaHq+haPHDpMMKfOweqzLqtfjrEirfudj4GRu4rsnxBkR5AO3QLmZBFVs/C01nH
	wipA6eawZEctfSIo9wtJ0/3xvpvWZxa/XCdIFcWzFhjZfyEmRflSiNISiv9u9UNastaCpeuaLW1
	Gru0jksvrqO
X-Received: by 2002:a17:903:46c7:b0:2c6:b87c:e5a3 with SMTP id d9443c01a7336-2c718ed74e6mr89125855ad.15.1781979418632;
        Sat, 20 Jun 2026 11:16:58 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:16:57 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v9 2/6] mm: swap: associate swap devices with tiers
Date: Sun, 21 Jun 2026 03:16:27 +0900
Message-ID: <20260620181635.299364-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
References: <20260620181635.299364-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8654100002
X-Stat-Signature: ha19bsbjjfoxskbfpftqwsoncs67jwfu
X-HE-Tag: 1781979419-327392
X-HE-Meta: U2FsdGVkX19uJq2w95tS04K/B7mDDBG6o495EW3nthEc8NvO5X9y9HpVwnX6yrGnz1xQYp9Cp1IfDatCokFGrnML51b+bV/7F0F9NoxnPGKGSOkZIHeq6MMsqLoKEkIWmseAYvdBtSPOjjPkl2Ylp8O2aFhU7N7WoEyE+xui3A4vVQ6TmsEJ6VCLhrTtHN9FqTZtT+MEOw0+kXzJKMjggCjUzOBsqQreJnx35jQ42ONSkoWnwJHEma4TvH5Ed0JJcxY/h5ixzVLC7r+Ylrv8kcGGE5JLK8AherqVi+29nBGy4nzPuAaQ6w+rWBP5dM29pkXdnY+2hjwkHdq/x4ewVb/8SwuXCV2dW93Uk9KCJuyaHBpC+IITwxGY7WHzmvck/DXqncsQBXLw8QBVfdeWBYY0gBcAtlN0dF2Cpo2xq9QszcxhhnPl7rj8ae7+BIL3W9N7gq+un/4rdUCjg2goONzNaMbzFKOKllzPloUIlt5eP7dE3LIhaSGtdE958QPuop2kY+AD3VuPGrl7VZXDhaG19GU1gNKrhSdpnKeV/f0s8rZHQI1uCiA7LYh4GPejipZCSfuw+d4mUjJhm2rtjiF/n1TYUM/4zGnGDt4nu2PwqoFWMkKQBeKGPWV/UPdl/4sCN4MwV2+0yCqJJ0HRWVCJsLXjIxg2pM8TIw2Xrrrv2BXG+zS4rv68qJXYUs40yTB8Q9BQ/eHHDspcphVuAqX7FytqwhsbuFTkVC5rHHqWy4x1XgSQEadKtdmfGz6GsPDxys0PeioGJWiBwnGhWConw7Pho24/IJlQYh6W+6yHc8U/9Qn3ZAitlFimLwvfEMyE9JHCcP5D/xfAMoRfJ1pqIvPb6tc+AalJzo25L8hmG4TcExwKkG5GdUzXUfbDvaLZVo5oVfreJ3aLnNosCWEzrsHKE79a9CgAw6IF2fKfcZ1Z0I2U8AIlEPflQ6ZpGDrpciXSQgnPwOWZ7sl
 o7LUY3Hg
 5yGp0p3JtziytlPjIHNSZtqc/NRFy2Zhfotl4OpVFFc1zjE2J+US0ivGaUWzJELeh9CBiC+C9DhAmoFA8RzxC0u3gmp13Ct06ktx6ywcoJXHKEa0afGoty1kW9ydPpone0oBJTgTD8pRqK0XkbtPAXVwRDheAsb4fNMkuQvEq/Qyw7LmtYg25KQ7tQa2SKqCEDbO1p1Yl+0FtXeVr4NZsMAExa1gqirNMz2idyfrto0uwVfFDW8OxxJJdsKuNMJuwgylE36Nhagfe21R2OYPqXDBBxVWfI+/IXejZjhV0Mv3UQfgIKSwLoGg712OQ66suADd8BBSDG+V2gFl2Ui5DwE7N4Ct6h+ZlTo5HUTbVlwWGXYPxmiaCpupylK/TKc3LIf8eampDzyavpbfjj1HFrsTic/aWGL0F7J99naNxFcCitNt1BHSBOyYSo3tPAuaAc/kpdJnS2DzLz+jT5e2w8ygSKrDxh89Nqx3TyxF8jnmGR65GVKLmZmLvMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch connects swap devices to the swap tier infrastructure,
ensuring that devices are correctly assigned to tiers based on their
priority.

A `tier_mask` is added to identify the tier membership of swap devices.
Although tier-based allocation logic is not yet implemented, this
mapping is necessary to track which tier a device belongs to. Upon
activation, the device is assigned to a tier by matching its priority
against the configured tier ranges.

The infrastructure allows dynamic modification of tiers, such as
splitting or merging ranges. These operations are permitted provided
that the tier assignment of already configured swap devices remains
unchanged.

This patch also adds the documentation for the swap tier feature,
covering the core concepts, sysfs interface usage, and configuration
details.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/mm/index.rst     |   1 +
 Documentation/mm/swap-tier.rst | 150 +++++++++++++++++++++++++++++++++
 MAINTAINERS                    |   1 +
 include/linux/swap.h           |   1 +
 mm/swap_state.c                |   2 +-
 mm/swap_tier.c                 | 101 +++++++++++++++++++---
 mm/swap_tier.h                 |  13 ++-
 mm/swapfile.c                  |   2 +
 8 files changed, 257 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..a0d1447c5569 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -21,6 +21,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_reclaim
    swap
    swap-table
+   swap-tier
    page_cache
    shmfs
    oom
diff --git a/Documentation/mm/swap-tier.rst b/Documentation/mm/swap-tier.rst
new file mode 100644
index 000000000000..0fb4a1153a67
--- /dev/null
+++ b/Documentation/mm/swap-tier.rst
@@ -0,0 +1,150 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Chris Li <chrisl@kernel.org> Youngjun Park <youngjun.park@lge.com>
+
+==========
+Swap Tier
+==========
+
+Swap tier is a collection of user-named groups classified by priority ranges.
+It acts as a facilitation layer, allowing users to manage swap devices based
+on their speeds.
+
+Users are encouraged to assign swap device priorities according to device
+speed to fully utilize this feature. While the current implementation is
+integrated with cgroups, the concept is designed to be extensible for other
+subsystems in the future.
+
+Priority Range
+--------------
+
+The specified tiers must cover the entire priority range from -1
+(DEF_SWAP_PRIO) to SHRT_MAX.
+
+Consistency
+-----------
+
+Tier consistency is guaranteed with a focus on maximizing flexibility. When a
+swap device is activated within a tier range, the tier covering that device's
+priority is guaranteed not to disappear or change while the device remains
+active. Adding a new tier may split the range of an existing tier, but the
+active device's tier assignment remains unchanged.
+
+However, specifying a tier in a cgroup does not guarantee the tier's existence.
+Consequently, the corresponding tier can disappear at any time.
+
+Configuration Interface
+-----------------------
+
+The swap tiers can be configured via the following interface:
+
+/sys/kernel/mm/swap/tiers
+
+Operations can be performed using the following syntax:
+
+* Add:    ``+"<tiername>":"<start_priority>"``
+* Remove: ``-"<tiername>"``
+
+Tier names must consist of alphanumeric characters and underscores. Multiple
+operations can be provided in a single write, separated by commas (",") or
+whitespace (spaces, tabs, newlines).
+
+When configuring tiers, the specified value represents the **start priority**
+of that tier. The end priority is automatically determined by the start
+priority of the next higher tier. Consequently, adding a tier
+automatically adjusts the ranges of adjacent tiers to ensure continuity.
+
+Examples
+--------
+
+**1. Initialization**
+
+A tier starting at -1 is mandatory to cover the entire priority range up to
+SHRT_MAX. In this example, 'HDD' starts at 50, and 'NET' covers the remaining
+lower range starting from -1.
+
+::
+
+    # echo "+HDD:50, +NET:-1" > /sys/kernel/mm/swap/tiers
+    # cat /sys/kernel/mm/swap/tiers
+    Name             Idx   PrioStart   PrioEnd
+    HDD              0     50          32767
+    NET              1     -1          49
+
+**2. Adding a New Tier (split)**
+
+A new tier 'SSD' is added at priority 100, splitting the existing 'HDD' tier.
+The ranges are automatically recalculated:
+
+* 'SSD' takes the top range (100 to SHRT_MAX).
+* 'HDD' is adjusted to the range between 'NET' and 'SSD' (50 to 99).
+* 'NET' remains unchanged (-1 to 49).
+
+::
+
+    # echo "+SSD:100" > /sys/kernel/mm/swap/tiers
+    # cat /sys/kernel/mm/swap/tiers
+    Name             Idx   PrioStart   PrioEnd
+    SSD              2     100         32767
+    HDD              0     50          99
+    NET              1     -1          49
+
+**3. Removal (merge)**
+
+Tiers can be removed using the '-' prefix.
+::
+
+    # echo "-SSD" > /sys/kernel/mm/swap/tiers
+
+When a tier is removed, its priority range is merged into the adjacent
+tier. The merge direction is always upward (the tier below expands),
+except when the lowest tier is removed — in that case the tier above
+shifts its starting priority down to -1 to maintain full range coverage.
+
+::
+
+    Initial state:
+    Name             Idx   PrioStart   PrioEnd
+    SSD              2     100         32767
+    HDD              1     50          99
+    NET              0     -1          49
+
+    # echo "-SSD" > /sys/kernel/mm/swap/tiers
+
+    Name             Idx   PrioStart   PrioEnd
+    HDD              1     50          32767       <- merged with SSD's range
+    NET              0     -1          49
+
+    # echo "-NET" > /sys/kernel/mm/swap/tiers
+
+    Name             Idx   PrioStart   PrioEnd
+    HDD              1     -1          32767       <- shifted down to -1
+
+**4. Interaction with Active Swap Devices**
+
+If a swap device is active (swapon), the tier covering that device's
+priority cannot be removed. Splitting the active tier's range is only
+allowed above the device's priority.
+
+Assume a swap device is active at priority 60 (inside 'HDD' tier).
+
+::
+
+    # swapon -p 60 /dev/zram0
+
+    Name             Idx   PrioStart   PrioEnd
+    HDD              0     50          32767
+    NET              1     -1          49
+
+    # echo "-HDD" > /sys/kernel/mm/swap/tiers
+    -bash: echo: write error: Device or resource busy
+
+    # echo "+SSD:60" > /sys/kernel/mm/swap/tiers
+    -bash: echo: write error: Device or resource busy
+
+    # echo "+SSD:100" > /sys/kernel/mm/swap/tiers
+
+    Name             Idx   PrioStart   PrioEnd
+    SSD              2     100         32767
+    HDD              0     50          99          <- device (prio 60) stays here
+    NET              1     -1          49
diff --git a/MAINTAINERS b/MAINTAINERS
index d1bb3b4b1e1c..4293048be1ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17052,6 +17052,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
+F:	Documentation/mm/swap-tier.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6d72778e6cc3..21286945770a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -250,6 +250,7 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
+	int tier_mask;			/* swap tier mask */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 762d9ca6ad5a..2f382d4dcbdc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -1063,7 +1063,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_validate()) {
+	if (!swap_tiers_update()) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index ac7a3c2a48cb..6b57cadb3e95 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -38,6 +38,8 @@ static LIST_HEAD(swap_tier_inactive_list);
 	(!list_is_first(&(tier)->list, &swap_tier_active_list) ? \
 	list_prev_entry((tier), list)->prio - 1 : SHRT_MAX)
 
+#define MASK_TO_TIER(mask) (&swap_tiers[__ffs((mask))])
+
 #define for_each_tier(tier, idx) \
 	for (idx = 0, tier = &swap_tiers[0]; idx < MAX_SWAPTIER; \
 		idx++, tier = &swap_tiers[idx])
@@ -59,6 +61,26 @@ static bool swap_tier_is_active(void)
 	return !list_empty(&swap_tier_active_list);
 }
 
+static bool swap_tier_prio_in_range(struct swap_tier *tier, short prio)
+{
+	if (tier->prio <= prio && TIER_END_PRIO(tier) >= prio)
+		return true;
+
+	return false;
+}
+
+static bool swap_tier_prio_is_used(short prio)
+{
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio == prio)
+			return true;
+	}
+
+	return false;
+}
+
 static struct swap_tier *swap_tier_lookup(const char *name)
 {
 	struct swap_tier *tier;
@@ -99,6 +121,7 @@ void swap_tiers_init(void)
 	int idx;
 
 	BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER);
+	BUILD_BUG_ON(MAX_SWAPTIER > TIER_DEFAULT_IDX);
 
 	for_each_tier(tier, idx) {
 		INIT_LIST_HEAD(&tier->list);
@@ -149,17 +172,29 @@ static struct swap_tier *swap_tier_prepare(const char *name, short prio)
 	return tier;
 }
 
-static int swap_tier_check_range(short prio)
+static int swap_tier_can_split_range(short new_prio)
 {
+	struct swap_info_struct *p;
 	struct swap_tier *tier;
 
 	lockdep_assert_held(&swap_lock);
 	lockdep_assert_held(&swap_tier_lock);
 
-	for_each_active_tier(tier) {
-		/* No overwrite */
-		if (tier->prio == prio)
-			return -EINVAL;
+	plist_for_each_entry(p, &swap_active_head, list) {
+		if (p->tier_mask == TIER_DEFAULT_MASK)
+			continue;
+
+		tier = MASK_TO_TIER(p->tier_mask);
+		if (!swap_tier_prio_in_range(tier, new_prio))
+			continue;
+
+		/*
+		 * Device sits in a tier that spans new_prio;
+		 * splitting here would reassign it to a
+		 * different tier.
+		 */
+		if (p->prio >= new_prio)
+			return -EBUSY;
 	}
 
 	return 0;
@@ -199,7 +234,11 @@ int swap_tiers_add(const char *name, int prio)
 	if (!swap_tier_validate_name(name))
 		return -EINVAL;
 
-	ret = swap_tier_check_range(prio);
+	/* No overwrite */
+	if (swap_tier_prio_is_used(prio))
+		return -EBUSY;
+
+	ret = swap_tier_can_split_range(prio);
 	if (ret)
 		return ret;
 
@@ -226,6 +265,11 @@ int swap_tiers_remove(const char *name)
 	if (!tier)
 		return -EINVAL;
 
+	/* Simulate adding a tier to check for conflicts */
+	ret = swap_tier_can_split_range(tier->prio);
+	if (ret)
+		return ret;
+
 	/* Removing DEF_SWAP_PRIO merges into the higher tier. */
 	if (!list_is_singular(&swap_tier_active_list)
 		&& tier->prio == DEF_SWAP_PRIO)
@@ -236,13 +280,15 @@ int swap_tiers_remove(const char *name)
 	return ret;
 }
 
-static struct swap_tier swap_tiers_snap[MAX_SWAPTIER];
 /*
- * XXX: When multiple operations (adds and removes) are submitted in a
- * single write, reverting each individually on failure is complex and
- * error-prone. Instead, snapshot the entire state beforehand and
- * restore it wholesale if any operation fails.
+ * XXX: Static global snapshot buffer for batch operations. Small
+ * and used once per write, so a static global is not bad.
+ * When multiple adds/removes are submitted in a single write,
+ * reverting each individually on failure is error-prone. Instead,
+ * snapshot beforehand and restore wholesale if any operation fails.
  */
+static struct swap_tier swap_tiers_snap[MAX_SWAPTIER];
+
 void swap_tiers_snapshot(void)
 {
 	BUILD_BUG_ON(sizeof(swap_tiers_snap) != sizeof(swap_tiers));
@@ -282,10 +328,30 @@ void swap_tiers_snapshot_restore(void)
 	}
 }
 
-bool swap_tiers_validate(void)
+void swap_tiers_assign_dev(struct swap_info_struct *swp)
 {
 	struct swap_tier *tier;
 
+	lockdep_assert_held(&swap_lock);
+
+	for_each_active_tier(tier) {
+		if (swap_tier_prio_in_range(tier, swp->prio)) {
+			swp->tier_mask = TIER_MASK(tier);
+			return;
+		}
+	}
+
+	swp->tier_mask = TIER_DEFAULT_MASK;
+}
+
+bool swap_tiers_update(void)
+{
+	struct swap_tier *tier;
+	struct swap_info_struct *swp;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
 	/*
 	 * Initial setting might not cover DEF_SWAP_PRIO.
 	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
@@ -298,5 +364,16 @@ bool swap_tiers_validate(void)
 			return false;
 	}
 
+	/*
+	 * If applied initially, the swap tier_mask may change
+	 * from the default value.
+	 */
+	plist_for_each_entry(swp, &swap_active_head, list) {
+		/* Tier is already configured */
+		if (swp->tier_mask != TIER_DEFAULT_MASK)
+			break;
+		swap_tiers_assign_dev(swp);
+	}
+
 	return true;
 }
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index a1395ec02c24..3e355f857363 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -5,8 +5,15 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 
+/* Forward declarations */
+struct swap_info_struct;
+
 extern spinlock_t swap_tier_lock;
 
+#define TIER_ALL_MASK		(~0)
+#define TIER_DEFAULT_IDX	(31)
+#define TIER_DEFAULT_MASK	(1U << TIER_DEFAULT_IDX)
+
 /* Initialization and application */
 void swap_tiers_init(void);
 ssize_t swap_tiers_sysfs_show(char *buf);
@@ -16,5 +23,9 @@ int swap_tiers_remove(const char *name);
 
 void swap_tiers_snapshot(void);
 void swap_tiers_snapshot_restore(void);
-bool swap_tiers_validate(void);
+bool swap_tiers_update(void);
+
+/* Tier assignment */
+void swap_tiers_assign_dev(struct swap_info_struct *swp);
+
 #endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3f7225dbc6cd..9a86ebe992f4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3036,6 +3036,8 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	/* Add back to available list */
 	add_to_avail_list(si, true);
+
+	swap_tiers_assign_dev(si);
 }
 
 /*
-- 
2.48.1


