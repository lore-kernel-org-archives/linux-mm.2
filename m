Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8E7C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5AC16B008A; Sat, 11 Jul 2026 14:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2C36B0088; Sat, 11 Jul 2026 14:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8820E6B0005; Sat, 11 Jul 2026 14:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5825E6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:45:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFEF61A0766
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:45:46 +0000 (UTC)
X-FDA: 84977374692.30.8137418
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 79A4420003;
	Sat, 11 Jul 2026 18:45:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwBiHjyd;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Gq4ADgsF216KVXDCQvsNulS1k0GIw7kWSrVwfWrShU=;
	b=osPMJvqX375tnnamNcqfsXJEBpaip+bUryD4agxafQDWIg3MTKCQw5hu8FMgq80RJBMQ3p
	zwNRYZa+Z6GHkF4/wnApGm1RSwSPPEXos9LrGn/TV5NdwIWGQKdlFr+tBVlFwNEbAIsojr
	jPza+1aKV9xLlfuJYWzP0rGdeqwpmoU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795544;
	b=B1bqHWemnykgS89pxf2BQZgwq8de/X2NljTuiJAn9o4yUYWIUf28YW8N6skZtFCPnHrDlE
	RSWy0cFwh3SPlPmsnJ5iEnEF748iOLbXf05qGegMc5+bVo/kM/9x0EluAqg+Q5GVpNYzaO
	8oVTwHa4/cfyByQlbFKJ1haMpkygJTY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwBiHjyd;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE3B1436AC;
	Sat, 11 Jul 2026 18:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9E11F000E9;
	Sat, 11 Jul 2026 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795542;
	bh=6Gq4ADgsF216KVXDCQvsNulS1k0GIw7kWSrVwfWrShU=;
	h=From:Subject:Date:To:Cc;
	b=HwBiHjydO82LFji0UszYF+rut4yPEXSI9+yS+Eeji5ZCbyrT7X+W6u1SUhVQrniFh
	 k7zXkJTLpkdkF17TCk/BE+KcBy5UxuqcCjXmdN5PS9ECGxuOXb2w3UmsQyrZZxq7/t
	 c+KqnJP4WL+6PC8X11/5T9fjXKiXHAd7Xpt/IXxNiG+CVT7P4gTg2l4JBZQF5qRc7Q
	 jPA9ta75uC74wIyT42vdmuOfCbRm4RxExyPtvpLAMrtRGgX9U5roby63Qt1Y3NlQfu
	 ZTdoDsuPZHxU6x5M8BAHXT6+GUlCHjJtm0CqjR6W2GWRZYz7riaLxSYOABQQKBAl2z
	 Lovf7UvBmWVMw==
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v2 00/13] mm: convert more vm_flags_t users to vma_flags_t
Date: Sat, 11 Jul 2026 19:44:57 +0100
Message-Id: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIACmPUmoC/yWNwQ6CMBAFf4Xs2TZtFYqe/A/DAcq2FIGaLTYaw
 r8LeJxk3rwFIpLHCLdsAcLkow/TBuqUgenqySHz7caghCqElpI1F5bGmtmhdpGNI2takZ/LvLV
 Xa2BbvQit/xzFR/Xn+G56NPOe2Y3OxznQ97hMcvfAhITEpS6VLkShBXd+5kMf70+kCQceyEG1r
 usP7sodQ68AAAA=
X-Change-ID: 20260711-b4-vma-flags-mm-bd05385df9fc
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Russell King <linux+etnaviv@armlinux.org.uk>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Sandy Huang <hjc@rock-chips.com>, 
 =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
 Andy Yan <andy.yan@rock-chips.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, 
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, 
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org, 
 Jani Nikula <jani.nikula@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9041; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LqsBGIOBz5PhtEm4kn0sretpylkcze+o2dhAS4zKBkg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+i02/1R97n5LZdUBvaNhKqyiTOKbuqcr+39vmCDrN
 C/ldFJnRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYy7TDDP8WyBX46r8L/TZLs
 cZaTWbaR54Fcv03k49BlKk/5xW3LKhkZ3pq+mhJ2N67ur3lDuMiZzJwFGnk8BsunfPLc6v+h6dI
 LDgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79A4420003
X-Stat-Signature: pqpodzkt4pfafxxs91ajchdrrkcjdtqo
X-HE-Tag: 1783795544-970027
X-HE-Meta: U2FsdGVkX19Q5YzWphahKVoU0mGAmLj57e8CC7RDFCGWh2P9tHGrSXinFuPixH3e73QuyXXJpLgRqKL0/Y0np6Quun7QHqUKzmqNRWwij4TklzF7NNxPs3p0XLEFEzxncIJLpgAVNLidAqny0KZ9usPEh+cAEMeZYUKknYo5GI0by3vxkTUqI/z2F8HVXajhHsMeNfkn6ktNGDefSfLNDsTgqVBuJfcGQ+IU10Kdd5OnKeQ9E25SHuclk5QUSdlB3ttYF8XsyN4aeERgbs9sQUWD+1IC64+VRy90568qXCNkHDhJIhFeovDVE/vCzBs0o2HlQS9m+tw9WT6/JNi4fPV4a8cV/hf4lFsVBGCjis5Z2YXL9tnxC1y/rfoayS7gIjuWfT9qd+zeVdkzThRQNclm02iYlczzBxwuBaY7JjBcRRr9Fgwq/owzJGD9DckyCwFGMCrJ76P966QNViL7ysMlfebC3zMKQBlrPOUi0NR27Or51BlsiEo0bs7AI5wm9lfMt1/hWBqr68KBq1YoMdUTq1OFZBGdWVLG9aIXAQlgozT3J0TXpm0PZX2r7gzmNRPMoDygd6aSWXGab2XB39kBzLVXiMlHVkwFn0XmfNU8eQzme5Bb/4r3eUKn8YK8LlZNvMUQq+fhK1ySnbuOeSgrMnRsujCQrhbnBzMzoz5G7SzruHG3OxFABjSpcufxh6rHX8Bff7sGiNdtR3lYPvjQPWcCybiXex6tvR0y10A2IzD1MGaXo+AewoV+OEde4Tg/4YUXitppmWnm9obafVwYJioHKw8YRjawWa+EMJryrXIJHMUrJd2X01mltFkXiNzyFZzKDI92vR/7XEL64R2uuGg28Yp/J8x1G0wlWNSHBG4Wv7T8aJkQKuXbI+3fhCycfE9PbED4pdHTn3U2QTwmOuDhj9jt+wUhZmvqkLw5kvGMgvR8mIOTIor/KU3b6qZz8Rdw5auo0xQssam
 6TRXS9N9
 DdfJm7Jeqhp6JdJDroMZws3+oxpNu1mSBrCMpiNhX74VKfqyDguRfFnhko4gmBtmLCGXNnEyy9bSRsgCrN2V/DYi+Ujwgu/fE98caGZN9TYBZfFcqyw0qXBBg3Ea9t6WQ6bhC0ohBFln0qNooqy87yhQQejKtXXxtigIIJnBDM+B548tS5kiagfnx2tj1H8bRU8f24KpRcNMBhq3MIPiTVeJ9+j5pXtIcHCbiFYNfpwiSgCS0GP4BM05eoOrqH/7E7nmoQw97ET/NZcDkqdZNgcKGYf/INggXX0Q6zkmQ+dAunsVQx/cQj6plbYLI80LmCLV9HiT9NNF0nwgkRQWy1Q69q0x+fhdSIwP6f/cP2G9wHA3LOBDvoMhIyQft/WwjictZtvAL9nRu460naQNBEy5x962q8K7lDlwd9XUKxKwMguTUsItZl+JLRke5ltS8y7NAWSA5d8vBR05B1afFz7L3pmv+zwsaeFT1WpqdsE84h3D2ShLIY0+JgDjXtHJUN8AFAlkm0mKewuGQ0LQNsP8NhLp3qrRbJhlHdg9LoXSzIQMMBHad6+tdzS+wDd3ucPK8+TewRHztiudrahAPOJtShBqnOKTTSEiXgmjYe8pvyUOfs7dvfsZ2ElakFgUQSTWBtkcLaLd+7lCVKDwHHQvVI2HSGx8nRRd5m5jGSOyYN6lg91vYJs5nmU56/iP93GKr17nvWXjeDk/4lhZtLNQiF/4GjnzxBP/Pboa8k0a6A//VjqbnpC0+QYz9SoKT2pi5MYd3/TXC4SvrebZeeNBGFpFy+AN7FfuE8UmpDTkndSqjsvyOvESgxsr0bJ11ZZ7PPvuSY8RgK3SHLmQZGULcTuoiM6LGSsOxl1HdFGeZLQ0cmIqW4U8ZwC3eqmgf74i3ivC6o8mYUCVd6E6V7TSZOuPx7CkFG6c9zSusjfN6CPynNVSHuXMbLCeadWLMks9YdZDpSJd6ZzVH22O1WkzsCWag
 tUUdNEYE
 ekeoujPDQU8RRKz2Mk5+LP3Mc6OJz0quZ4BrbMz/ghYIxme2gD5w064dRHW5xxw+QWWN3wmAwWeSRnUf44pBkICv70GSaVFOd7Lc+FEAxqLzLnszjq1C4daL2nMyrx3gja9k251HtIYioTYUDK+23RLoju+qZaEnsr7bmPMKfcOTZMJruV/mD/rjkIP6o/ANnfRKRkErkeI5pNEcbO9KdaWcRbKubHmaTX5SiRmipaZuTBh4zMH7gQApt96GvSwDomZtgnrPbpJrnCdtW8IATVXVjDCyc5OpBXC37u81JczIvQ8QoQsuVrmA2d0iLuhq4v3Rw9WPE/g5VHk145i+9VvpqsGNLXOhwFn+Pt2Y+eowmGgfQTESOzvbznEem81QbSETwqtqzBeDBkxJeZfzAxqL3492MI9tj1HMxefGFpI7CucAuAKlelW2r4iFmyd/vxsFjpBe2fvhvemeJ2htnNEOzLb+VCwkaumgHEIGX0pj8kMt61nE5auZs/Gc33FDaXK/yRoU+1Sqhep8n5cxoi/rv/u78DAopaoCRZ4Bwm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series makes further progress in converting usage of the deprecated
vm_flags_t type to its replacement, vma_flags_t.

It focuses on mm, though updates some users of mm APIs also.

It updates:

* The core do_mmap() code path for VMA mapping.
* Unmapped area logic.
* The usage of mm->def_vma_flags.
* VMA page protection bit logic.
* General usage of VMA flags in core mm code, mlock, mprotect, mremap.

REVIEWER/MERGER NOTE: This is dependent on [0], which must be merged before
this.

[0]:https://lore.kernel.org/linux-mm/20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org/

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
Changes in v2:
* Rebased on to mm-new that has the 33 patch rework dependency in it.
* Distributed tags, thanks everybody!
* Moved VMA_STACK_INCOMPLETE_SETUP and VMA_STACK_EARLY VMA userland test defines
  from 1/13 to 9/13 as per Zi.
* Fixed whitespace in 3/13 as per Zi.
* Updated 5/13 to use %*pb formatter for VMA flags (to match mm flags formatter)
  in dump_mm(), as per Lance.
* Updated 8/13 to update panthor_gem.c to vma_get_page_prot() as per Lance.
* Fixed up comment type in 11/13 as per Lance.
* Fixed bug of using VMA_GROWSUP_BIT rather than VMA_GROWSUP as per Lance
  in 12/13.
* Added detail about when we are and are not required to open code
  vma_write_lock() for VMA flag mutators in the commit message for 13/13 as
  per Lance and Zi.

v1:
https://patch.msgid.link/cover.1782760670.git.ljs@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Benjamin LaHaise <bcrl@kvack.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
To: Nicholas Piggin <npiggin@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To: Maxime Ripard <mripard@kernel.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Lucas Stach <l.stach@pengutronix.de>
To: Russell King <linux+etnaviv@armlinux.org.uk>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
To: Peter Griffin <peter.griffin@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Tvrtko Ursulin <tursulin@ursulin.net>
To: Rob Clark <robin.clark@oss.qualcomm.com>
To: Dmitry Baryshkov <lumag@kernel.org>
To: Abhinav Kumar <abhinav.kumar@linux.dev>
To: Jessica Zhang <jesszhan0024@gmail.com>
To: Sean Paul <sean@poorly.run>
To: Marijn Suijten <marijn.suijten@somainline.org>
To: Lyude Paul <lyude@redhat.com>
To: Danilo Krummrich <dakr@kernel.org>
To: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
To: Sandy Huang <hjc@rock-chips.com>
To: Heiko Stübner <heiko@sntech.de>
To: Andy Yan <andy.yan@rock-chips.com>
To: Thierry Reding <thierry.reding@kernel.org>
To: Mikko Perttunen <mperttunen@nvidia.com>
To: Jonathan Hunter <jonathanh@nvidia.com>
To: Gerd Hoffmann <kraxel@redhat.com>
To: Dmitry Osipenko <dmitry.osipenko@collabora.com>
To: Gurchetan Singh <gurchetansingh@chromium.org>
To: Chia-I Wu <olvaffe@gmail.com>
To: Zack Rusin <zack.rusin@broadcom.com>
To: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
To: Matthew Brost <matthew.brost@intel.com>
To: Thomas Hellström <thomas.hellstrom@linux.intel.com>
To: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
To: Helge Deller <deller@gmx.de>
To: Kees Cook <kees@kernel.org>
To: Jaroslav Kysela <perex@perex.cz>
To: Takashi Iwai <tiwai@suse.com>
To: Boris Brezillon <boris.brezillon@collabora.com>
To: Steven Price <steven.price@arm.com>
To: Liviu Dudau <liviu.dudau@arm.com>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-aio@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: dri-devel@lists.freedesktop.org
Cc: etnaviv@lists.freedesktop.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org
Cc: freedreno@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-tegra@vger.kernel.org
Cc: virtualization@lists.linux.dev
Cc: intel-xe@lists.freedesktop.org
Cc: xen-devel@lists.xenproject.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-sound@vger.kernel.org

---
Lorenzo Stoakes (13):
      mm: introduce vma_flags_can_grow() and vma_can_grow()
      mm/vma: update do_mmap() to use vma_flags_t
      mm: convert __get_unmapped_area() to use vma_flags_t
      mm: update generic_get_unmapped_area[_topdown]() to use vma_flags_t
      mm: prefer mm->def_vma_flags in mm logic
      mm/vma: convert vm_pgprot_modify() to use vma_flags_t and rename
      mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
      mm: introduce vma_get_page_prot() and use it
      mm/vma: update create_init_stack_vma() to use vma_flags_t
      mm/vma: convert miscellaneous uses of VMA flags in core mm
      mm/mlock: convert mlock code to use vma_flags_t
      mm/mprotect: convert mprotect code to use vma_flags_t
      mm/mremap: convert mremap code to use vma_flags_t

 arch/mips/kernel/vdso.c                     |   4 +-
 arch/powerpc/mm/book3s64/slice.c            |   6 +-
 drivers/gpu/drm/drm_gem.c                   |   2 +-
 drivers/gpu/drm/drm_gem_dma_helper.c        |   2 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c      |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c       |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c     |   6 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c    |  12 +-
 drivers/gpu/drm/msm/msm_gem.c               |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c       |   2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c        |   2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c          |   6 +-
 drivers/gpu/drm/panthor/panthor_gem.c       |   2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c |   2 +-
 drivers/gpu/drm/tegra/gem.c                 |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c       |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |   2 +-
 drivers/gpu/drm/xe/xe_device.c              |   2 +-
 drivers/gpu/drm/xe/xe_mmio_gem.c            |   2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c     |   2 +-
 drivers/video/fbdev/core/fb_io_fops.c       |   2 +-
 fs/aio.c                                    |   2 +-
 fs/hugetlbfs/inode.c                        |   3 +-
 include/linux/huge_mm.h                     |  10 +-
 include/linux/memfd.h                       |   6 +-
 include/linux/mm.h                          |  52 +++++++--
 include/linux/sched/mm.h                    |  13 +--
 ipc/shm.c                                   |   3 +-
 mm/debug.c                                  |   5 +-
 mm/huge_memory.c                            |  21 ++--
 mm/memfd.c                                  |  15 +--
 mm/mlock.c                                  |  99 +++++++++--------
 mm/mmap.c                                   | 164 +++++++++++++++-------------
 mm/mprotect.c                               |  16 +--
 mm/mremap.c                                 |  38 ++++---
 mm/nommu.c                                  |   3 +-
 mm/util.c                                   |  10 +-
 mm/vma.c                                    |  26 +++--
 mm/vma.h                                    |   8 +-
 mm/vma_exec.c                               |  20 ++--
 sound/core/memalloc.c                       |   2 +-
 tools/testing/vma/include/dup.h             |  23 ++--
 42 files changed, 341 insertions(+), 264 deletions(-)
---
base-commit: 61cccb8363fcc282d4ae0555b8739dd227f5ad0b
change-id: 20260711-b4-vma-flags-mm-bd05385df9fc

Cheers,
-- 
Lorenzo Stoakes <ljs@kernel.org>


