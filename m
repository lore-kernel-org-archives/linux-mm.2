Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2A5C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443CC6B0095; Thu, 17 Sep 2026 02:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4B46B0096; Thu, 17 Sep 2026 02:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B7E6B0098; Thu, 17 Sep 2026 02:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDE16B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 566C08015F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:18 +0000 (UTC)
X-FDA: 85222221756.15.3DCA450
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B0E5C4000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F64G9Zxd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F64G9Zxd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625236;
	b=ntif38wDaHhGtZP8blBlnguQvb03u/lAdkHXi0rF1FTSf2ydxjKiLcUgUTbLyRWNuFfrZk
	ue6U2NFW/aCfYxfauxH4RgDXykEzNDLNQiBDdO1EuMHpWt4hiHbcPx8jkHgagLFmRMtYS7
	65WOP+gLd818Sh6jaeIRDduKtPUOvBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iU73g1jvl6feg7+ltGvAXjA/dTAvCMcKsUeaZ/YOwCA=;
	b=G+lsK8PHMAQDdSeeo2ozxA/IXTTWitXJfT+sVa4pQ4ti+EcUfe2SypM0OStU9mkfB3HZ5+
	T75uh0j7D9d9sPfADcJuUiQFMCP9qk9Ta/xUDuVs2ekUCcVzWuqhOtlZ6750hrHFKb7CzU
	WMSCxDCqkX7Z2S72EK7N7RYbbLqRM+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D628B60A55;
	Thu, 17 Sep 2026 06:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191E1F000FF;
	Thu, 17 Sep 2026 06:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789625235;
	bh=iU73g1jvl6feg7+ltGvAXjA/dTAvCMcKsUeaZ/YOwCA=;
	h=From:Subject:Date:To:Cc;
	b=F64G9ZxdWZ/xrdo7gIaTiOhKK7qE0nx/tWPLPOuhNcCTjvck6UWxNktHn+t2UFQJ6
	 kM7cgdfWgxp1BsUUTCTLCFnD3LlVq7e6tUA3i33Y65O5C3+zbVis//43Zl6BOoN9rQ
	 LXkUgyd2CLsmRezvHjWECAI2B/4y9zRZt4xnFl+h7kRQLarWrgr5/QKtj8PM9ssjF7
	 TV8yrjNGIfQyBCmOib9kk+8LDuDuoyaUpwFfANCw+jgFncrgnWOUkvt4vqHvpsmqbM
	 X6JDpheJNdYBM9B2brYMsI6Atc6tNHBEymaxMiRcsMkS+WUkKzmNFOEsml4GCXj0Wq
	 6jmdQoC9pWqHA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/5] hibernation: make safe_copy_page more robust and
 remove debug_pagealloc support
Date: Thu, 17 Sep 2026 09:07:02 +0300
Message-Id: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ7CIBBFr9LMWiK0CbZexbhgcJQxQg1DTZOmd
 xd0+X7efxsIZSaBc7dBpg8Lz6mCOXTgg0sPUnyrDL3urZ6MVYGRcnKleupk9YCjJZxGA/XxznT
 n9Ve7XP8sCz7Jl5ZoBjohhdklH9oU41ziMUa1JCkOXwT7/gXF3/CgkwAAAA==
X-Change-ID: 20260916-hibernation-7603b86eb981
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: B0E5C4000A
X-Stat-Signature: dg976xbmcbwit5dhb56cf3s9odckcfxy
X-Rspamd-Server: rspam01
X-HE-Tag: 1789625236-755854
X-HE-Meta: U2FsdGVkX1/+l8+qEBYHWe5RaCmrE/6TQIB2Z+I79wUnPkIQBF0MH71DRNT0HEvvzF3HIfthZcyqHeXB0XhCC4SdQqQ0772OABiypftRruJ0rARYljKSNCfqxhek/p53C7VCjyFP2NEJIdOXP1xx7ZgBFXX0GRpzoLduJ5kdtYqQrXlpp3ZS9yNhRTb2dDGDlMrdEpPTPaZ843VFzy3wR/10uLv/328mt5PJ3FqVMAbHVYF22Iv3S4WaAwTDd2SnIJRbY7wZAbX12qE+BkIBdINK3PiKoBPCASwD2BgnUlXCaGiD7nU7diAUF63XEfQwmo5whAyoaOD9h810PwuQgyfPgxaHGHzm8A9I9mvpzO2HeQBtTxTQ5vnD4Vk09mmr4/tNE75rm64rD0ffGx2sHwzMkjzuq803SHBLV/6BkXvhMCCigeK03MIrJ5Y/PoBU7hcfrcqz0QWpDkmZQS9qbap5NpwhFcRx34DIlP8Rc8sp+0qYCgq8GKqphSPtc/20IvGQ119Rk1FCtwpUgqbd1pdYCCeRf+lwoaPe7lmPbxJJSzqTFVios5pfkdIGhI2ET+osm8SxMexRTr20TaN9xHRWxg9ZRnbmB4UQU8MnreedSRhGqVe6LNZ8WWwjgReJ8AuQR4NMOaTPraC6OnsrAFsjbDOL7qsOzb9P5e/xfwH0lNrxRUd01Tzq0Fkf7GYu311n67kOXiKrhYEIZo/LWdsqjRV1KE8y43BqYf5z5Ct1gK7IZfwvYiiApgnG5sH2Iy+C0DsbFImypi3amlcSMeU0kDuTnqADJqxSW29baFbFbqRO/Y1xqGJ9kgl6DCRrEvHlWc8GKqHDHjRDX13GA/NgBo23jayqN0teM04AdWHkweCVxNq5hJxLUVdnvMItiBAm0SwxGFyj2WnmPuUsYN6tPInYMvCra/Yz/1FeFPNm6Lan7Pg9MelibZtxzLevloiePvw4MKyL614+fe8
 /ySUEY9t
 1NTKIyg9gXJ2R2TkUGz9vRtAWtRvTww1XsG1kWKOJjUh5GBBiJbeX4bS0Go87V36sMNt/m/HSztl35WulRADYipz5nBW8B02KLwltHd36pFLEjt5F8arcfZ4X9fvpQhkPoS9tJrHp0bbN94YVZ2vtuK5JE4wgcmZsBse+LpcXb+0YSI+leClkbKVqE7crBgdQIqRmP0IqKBZ9Rglcpki3NsTsMrqHVItdhkIGE/p5yIl6CRPXu13WV68O5+uxumRHk5zIa/s4iihCg3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When hibernation creates a memory image, it uses set_direct_map() APIs to
temporarily map pages that are marked as not present in the kernel page
tables.

Initially, this was intended to support debug_pagealloc along with
hibernation on x86.

With the increasing desire to use set_direct_map APIs for hardening
features and with their inconsistent implementations across architectures,
using kernel_page_present() + set_direct_map_valid_noflush() to save
non-present pages in the hibernation image is not very safe, to say the
least.

Worse, some combinations of debug features, such as debug_pagealloc and
PAGE_POISON cause a crash during restore.

Keeping debug_pagealloc compatible with hibernation requires a complex
infrastructure for tracking free unmapped pages with a page flag/page type,
verifying that it is actually a free page that hibernate_map_page() tries
to remap and making sure there are no stale or failed page table updates.
With init_on_{alloc,free} and/or PAGE_POISON on top, this also requires the
ability to map and initialize these free pages on restore.

This complexity does not seem justified for a somewhat niche debugging
scenario.

Instead of a complex fix to support hibernation with debug_pagealloc, make
sure that copy_data_pages() and its helpers properly handle errors that may
happen during page table updates, explicitly enable saving of KFENCE pages
and disallow hibernation when debug_pagealloc is enabled.

---
Mike Rapoport (Microsoft) (5):
      hibernation: make swsusp_page helpers static
      hibernation: ensure secretmem pages don't reach a snapshot
      hibernate: handle potential errors in hibernate_{map,unmap}_page()
      hibernation, KFENCE: explicitly map/unmap KFENCE pages
      hibernation: make hibernation unavailable when debug_pagealloc is on

 include/linux/kfence.h   |  29 ++++++++++
 include/linux/suspend.h  |   6 ---
 kernel/power/hibernate.c |   6 +++
 kernel/power/snapshot.c  | 137 +++++++++++++++++++++++++----------------------
 mm/kfence/core.c         |  52 +++++++++++++++++-
 5 files changed, 159 insertions(+), 71 deletions(-)
---
base-commit: 0820e2e85e8aafde66256c567ad37a5b15708d4d
change-id: 20260916-hibernation-7603b86eb981

--
Sincerely yours,
Mike.


