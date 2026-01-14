Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9755D3CC84
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D3A6B0005; Wed, 14 Jan 2026 18:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E2F6B0089; Wed, 14 Jan 2026 18:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F1F6B008A; Wed, 14 Jan 2026 18:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D712A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7494EC0410
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:00 +0000 (UTC)
X-FDA: 84332217480.11.A128913
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id B601B100004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:50:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PiyO+kt6;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vjrrFW0XqdppZNNWqIznZXzloYpv+TypGhEeLOQrMhw=;
	b=veb/GQ6QwoseBzKmHWiYK4V06FtL/HVyWqDMv7EB9XzjXIlrBQdXIw0TFHOuG9yVF/athA
	+PjwMBeUBrQYU0fiBK6RPOj1yVXseCaiF2alJdNyISkI1/vlNI4HdOTLad13FsElDhz1f+
	PC0dEKk3xsCRJkuVNoD+7e5NPqUWjTI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PiyO+kt6;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768434658; a=rsa-sha256;
	cv=none;
	b=M4ldJDG/5H8B2R07TEcDrhvnRXn+BDONwLd+7SurZLzl7IMde3oEAxPbcDOG7nuBJhyOiB
	swxC96Q7fTcwZL6WW1+RS4OSZkozX2Udit1baOSY6H4RiES5/tQB+yvkmrgqwJ4t5YnEgD
	EAr9PycM/8m0FBgEmxoUlitMMu8n384=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88ffcb14e11so3562346d6.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434657; x=1769039457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vjrrFW0XqdppZNNWqIznZXzloYpv+TypGhEeLOQrMhw=;
        b=PiyO+kt63W4+7mCMUt7X5vaykCwHw/T9xDCa0uooMrIfWAemflEEWs0enTnbJhvIZy
         Ku9IsLqE5rTsPil8iq8GXTyC8ZIGxUNFaPia6cTS0Oiwe1ihBCOJ8yj+t9XwDWAL6m7L
         93yloVHPVXfrSJkzbr1p4XwBFv4mOpviik0QWLbQ/ONQ3VDizAoQOyitDVl/dRnZTVOV
         voxgf66MOt+JZCgko//K3LB20ucL/z/jCdwQ5T0RDBrp31pV4Pa5uSqVJGvHRUplO+43
         E8DG0uinXZ5ySu57+u0hYvR89SPghN2vuUrJfSeBDizj7KvLEtwOJG4eT1+Lm1i+ZvVx
         ln1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434657; x=1769039457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjrrFW0XqdppZNNWqIznZXzloYpv+TypGhEeLOQrMhw=;
        b=OHQIaPXMkcHvSMCVGiF4o5PNa5naBWInoxIViDmZJfM5GPHYxjRw11wWVY4pXI9aqv
         xsryewaicE065kpdnfG4LLoOgM52TKcSmF/CkdhQaaTXMOsMBY/XPA8PKeQx0rY2j4XO
         IqPbIX03KtoctxNa39OFAPSZBrUjDRw4RFVL0QzMGAC/gadJ9J16fQu68gvsv7prFzzv
         D9A3ZAj9u8SJWw1Fz10k2AkFGlpvlCkdt7Df2D2vqGzfSj7IFP++uVaIOEaW4IH+PmoK
         LTRXhz/eDQdCdRs0NP+PFlaWWTUAvUuQ6bt9jxs1Pgjy12nZJ56rC+WqJu2nkQme2fuI
         JHLA==
X-Gm-Message-State: AOJu0Yylmgvre5DQDTLtPHB5bxVy7MJ6iAeXAeposqzT23yvKzo1f4tj
	5INcDK8kbdP+pVs2d/smWlJVxH0ftolHxFMXk3/CNjuirHQTvxW/zEUk/D0yzuJceksAd0wDzGq
	boqwXL6A=
X-Gm-Gg: AY/fxX6zRLAgIPKSnspaRBlg6BKMOfGFVHmoECIGsfkd8XxB/NXZQ1zXRLrmimBs0rE
	vhKrjzCZYYkxo3jIaUIEHId8RFAoqQz1u02+M0RX4/Lz8iALpOlif163D6QcomzzLZBoQLuDKAi
	Y/IX8RpfOUTBu4omqWd1xKjEA1GAUKH+uVkyXQ0JPPgGF/PwvzdoHal1g8klft3Ov12IUBav/9h
	34sM6+WuKTTYHbb+/aPkBzWc1O4BaNa+JvaFCW/pXTG/RH06p67e93446Z0VI87S5nA0aIeK9Cv
	YCvtsc5Qt7Yjyzh7oaeMDuUQrc+MoOFYGzytQI9queo2tPUPJnAk8KmJ9pkWQG5/YZwvBXHVWty
	Zx6dySH7LdwmzaAy3jNPPPXmXB3qK36W2KP1WMwy49Ks0CgFNo7BPDSjsLrF+fGbhFCbpmtnrhF
	Vx5ITH4l45noHIOAZv+jYvIPxOsY2EUCNsgOQLp0HEYTGF3OLpexuZEZGvnv1rfPzFoUL6foW7E
	I8=
X-Received: by 2002:a05:6214:401:b0:890:6603:f258 with SMTP id 6a1803df08f44-89274373da6mr61800136d6.12.1768434657410;
        Wed, 14 Jan 2026 15:50:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:50:56 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH v2 0/5] add runtime hotplug state control
Date: Wed, 14 Jan 2026 18:50:16 -0500
Message-ID: <20260114235022.3437787-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hiekg9byq58azx67dkunqhwjgpx9t7ee
X-Rspam-User: 
X-Rspamd-Queue-Id: B601B100004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768434658-48500
X-HE-Meta: U2FsdGVkX19Xxak6wDLPB86VB/OTIPn5qdf/iaOoHmw4hotC9bjqaL6Tdfshq2O/GeXoizGzG/CQGWHRHsltBLhkc61qeXfXRYeIGiy0GULiab3y74Hpr0hCl9/oIQiToyaN9OIhsHPohdcYafK2ii4ffEbe4SlbOkZbgbh/G0k3rDfECMi3crgW0q4IaC/tljZ08MsJAAhcFhUCXf82WBz8IT63uvY6CYePlKFPzAlV3N2FEyvm8vsjwRyLUTxKNTPIF9oEHxQYSiwwrPzU4qsPgWpvklS2mIAu+q5ceI2TRz3lJp7HJZUy5tRa9Pc/8QVFGh6GC4YZsQufB3JQFCulWl5AplWY1VPLEqW3TDc8hfq9YOtyuqHN0c9zwL7IPljNuoyIg+e7GvYQSPk5NJCQMGoioHlV0DbdHRDM8jn6m3oVpnwzKwYkuZ4JeodTKBmTlnUEfNXpCvzhbW1GY35eKQ6vhZ2HY8i9Jva2akOf9E+1xDYgj2mweZLYWo4Cz1zUOH6ec6CYdZmUrT12bSTN+iMJgnsEwJcfs7KzJVplyrpqH492Pjy3el7ONWnmcufVR6RhH++h28XDeMMztlukV992ugnBfqJGZiC/LZSuwGmkjynK6dkv5pZxpMUuNamUTNvEi5EIbLPYFN82PmtOyn2y3iPNW2UwDD6i2ohi1CpnswaN/FHFrDEoc/9+m9gijVZwH+6Y/ACvDqAmmAbNAjlfS6llvvb/2csulB4goLXEEj03HJ3YGJ4+ICVno3e9s0snL+mKLjwfGVKwAfRfMAmQimKuGm6oKszk3Lu3klBz9kPkFPkIiUJb0h3TCpLVqKFGsqMU4sW+Y2K31rUy1DZPOEId6LXRnBWtWAnu5XcpwYDo41rxdbw81lDus/mTPpnHaKW+XYC55lQewfn4wXsP47+XWIA1hsLSZcdxalNw7cyHL0yvp/Qd8MUR02fVZFk3KHvYcW4LJZD
 tAOHekRg
 HtYfFmu530AlDR5IEtmBUfPFe7vTBRQi2oNeuA92WMR0wOX2eONUJMUZJWSpLl05eDZl9MNfvGUNvP6HUKk70lRGst8hOaXzPAxkW0M2+CPsiB/3OpBWnjygWo9rqK4udniLabF+EKK2mgMzqXR0yoU6bTY/DA6zbHolvk74z94hWJ5dC9ji087sEVvQSTE3IVDGEhsmNjHudUpqgh7LZjNG54/tjvo4vggdZNOm+FTCPGi9vLvC2lNlXbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

This series adds a sysfs interface to control DAX kmem memory
hotplug state, and refactors the memory_hotplug paths to make it
possible for drivers to request an online type at hotplug time.

Problem
=======

Once dax_kmem onlines memory during probe, there's no mechanism in
the dax driver to:

- Query the current state of the memory region
- Offline and hot-remove memory blocks atomically
- Control online type (ZONE_NORMAL vs ZONE_MOVABLE)
- Prevent external interference with driver-managed memory state

This forces users (such as ndctl) to toggle individual memory blocks
prior to unbinding the dax device, and has lead to some race conditions
between competing hotplug policies.

Solution
========

This series introduces a 'hotplug' sysfs attribute for dax_kmem devices
that allows userspace to control and query memory region state:

/sys/bus/dax/devices/daxN.M/hotplug

Supported states:
- "unplug": memory is offline and blocks are not present
- "online": memory is online as normal system RAM
- "online_movable": memory is online in ZONE_MOVABLE

A memory notifier prevents external operations (auto-online policies,
direct sysfs manipulation) from changing memory state, ensuring the
driver maintains consistent state tracking.

Patches
=======

Patches 1-2 prepare mm/memory_hotplug to allow callers to specify an
explicit online type rather than implicitly using the system default.

Patch 3 refactors dax_kmem to extract hotplug/hotremove helpers,
preparing for the sysfs interface.

Patch 4 adds the 'hotplug' sysfs interface for runtime state control.

Patch 5 adds a memory notifier to prevent external state changes and
maintain consistency between the sysfs interface and actual memory
block state.

Gregory Price (5):
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: add 'online_type' argument to
    add_memory_driver_managed
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for runtime hotplug state control
  dax/kmem: add memory notifier to block external state changes

 Documentation/ABI/testing/sysfs-bus-dax |  17 +
 drivers/dax/kmem.c                      | 577 ++++++++++++++++++++----
 drivers/virtio/virtio_mem.c             |   3 +-
 include/linux/memory_hotplug.h          |   2 +-
 mm/memory_hotplug.c                     |  35 +-
 5 files changed, 528 insertions(+), 106 deletions(-)

-- 
2.52.0


