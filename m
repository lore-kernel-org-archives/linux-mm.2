Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F5BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D70C6B0092; Mon, 29 Jun 2026 14:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788B16B0093; Mon, 29 Jun 2026 14:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678D76B0096; Mon, 29 Jun 2026 14:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9B46B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:58:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5FA71C61F4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:58:09 +0000 (UTC)
X-FDA: 84933860298.30.B415F73
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id ED4DA80003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:58:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LVTlwTLZ;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759487;
	b=E0N8hAk+/VjE1Sl9FjcRIbgPBo4Zw/2UIXssEYMX8XCp90Qv85o8mLKfX+cb6rPwItNwTx
	uc9is5wl+PPDYfwKg8CW3O8Qx65FMeA895LqUeqju3bJEkJECITB6hGj+GrugM/1RPy8w0
	QbhiNBHg3c+RDds7/W1Zr4AQyso8Lks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V216nmU9ttJM2RugBVItOUGA9QghN1LSEfvMALpwJOA=;
	b=MgxAcJsPXGlMUanpzoQ00CzwrO0Q6H783lb1hPZ8y+eWP4ALPCMglxGfPabITuJzIMhUcp
	FrqqBQRKrUW9lvFg3hz6YpG5jk0HSPeiYviFsXrAneEvsYKWnGOSg+X83Kw3hrvY4mFepj
	wb6Ljly9ZNxc5fAfceNTo5O2az4fdKU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LVTlwTLZ;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-845369f60faso2158438b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759487; x=1783364287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V216nmU9ttJM2RugBVItOUGA9QghN1LSEfvMALpwJOA=;
        b=LVTlwTLZUT1UNNKMDXgLA7iMf3vGodZoyFt8Zrz98A2KQZgd48Fnlfw6W8frdlMO+P
         hiJ/C6Qx0KleumzPutp290XjewUG33LKnsfE6J1UP1LjrLb7pXkVftTu/Tjf3KJQCMfo
         66a64ioalQmi70ZixD2LzrnbiP1D9iF7IgFoL37TYTCJeoZVtItgRgWJJAbzDPl+t4eI
         5ZmbqMeT+EkO2uaLSu4B59qwx2m0wzNrqm38C0qc7iA778jEEg5goKD0DGX/sRt/7xzA
         PuvPjCgbrKnx9D35IhbUY/2f/1gKw46p/Msh3so6vimfgLhSFtN0ZaF2g0fGY9FCD0pQ
         jzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759487; x=1783364287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V216nmU9ttJM2RugBVItOUGA9QghN1LSEfvMALpwJOA=;
        b=IQW8IuL/Q86qtlzz4W0NAw2CTY2YgMN+4LwsSyUmWQqGU+i+K0xV+IfDM/AvozwN6V
         bhKRMCofe/EPeIFl8D9eHm+fG9o6A5rNcLdikrSXQcuX6RogJa6s6WwPa3TAuQElOVqC
         9nxKhzYEvupGYu6fEpm45UWGwzrcAQcB+b7MQP7DU5WPexb/qAgsxhHqn/1eR2+G5dki
         1+/NSzqiouO48A3CAuY1NPj0P7UDrb7gMR1vQXryk5ThXYRhzCQb53cLkf3ymWHFQP3c
         8a99Gw26Yii/Aegg2yTxgBO8sd4cyq/0pdDPYof8+N1JI+AxPZQqnUQK1/LzT3ActbY8
         Lj3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq39qH2uqM+Qs5qBY87fV6619xCYcquhTcffAiQWUYanpG3BWKOKLygFv4Z1R+xQdVwUnsPJLxJjA==@kvack.org
X-Gm-Message-State: AOJu0YyHby3kBIbtV/I90om90VHVce+pplho7NzBPYKsE91o431F/RHL
	6q+z4UlSQFqmM7WxFHEjyP76bc+rf4/8KydJVLw45nADkW8gJ+gTMqDN
X-Gm-Gg: AfdE7cmvAN7/WGJdUtyJXJLyaZEokDsatIt1lnqmQx1/Y+ironD4zj3ATKkvmi7tUBd
	qyZ2R07qtT932MtqUrEL4W7u5qQmb5MiNuFuyxMXdqD1JXfYc7oqTDJVMzvYT5Xh0VEP+LFjddD
	BypSDoTd/W2Ck4Pn0QLRSpuDqjng5Zj14K6iS/+L6Vsunx3sF6wv8duM47YqBas6QqLmhu6ZcZT
	g4uMmmprvv6i2J4sTo+7DnAN/Z6dW8SOxVe1W9dndfqhQ4N6saPCTDbSdTea2eeTviVCutj327s
	dwSU0v0gfLpASSsHT/FnIZhni3vq+k9qw84HNNw71N6C5itpSm9NchlIy+ZOGeucAhdsgh5S/Y7
	V8XtF/m7qZe2slnLl+rz9aEHoIMYTD5SISD895TrrDi0n/yHyf3UoFBpXlNUfMnZR4mEN9RNLUU
	uj71+A1crgz0rAJlfTGRJp1Uqg6X25GF3uAfldnRmfg4Z+f52BGfn0DEfDnGsizZvVd96Dv84=
X-Received: by 2002:a05:6a00:8c8:b0:847:9c3a:b77f with SMTP id d2e1a72fcca58-8479f232bebmr511836b3a.35.1782759486753;
        Mon, 29 Jun 2026 11:58:06 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:58:06 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH v2 0/9] Convert x86 pgd_lists to ptdescs
Date: Mon, 29 Jun 2026 11:57:33 -0700
Message-ID: <20260629185742.126987-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED4DA80003
X-Stat-Signature: py3ge1de31d5thz9iiyke647p8q96nhc
X-HE-Tag: 1782759487-149198
X-HE-Meta: U2FsdGVkX1+Mk1v3dK8S6ofvSrEsA9cXcGX5280DxX3ES4uIojv61itTMpkVbB/qSbNVNISPBObGYfBjDx3PKW3CX1lkELt7uILO1W1zF4xajgM5qDEMBGpzApAxQWGR8xSIFGJEBu572Lp4eJH/RGuosotMOgJdZ3KAYjszBtBUG7SM9n5IQE70OOJ+XZpD+DlMWssRtV4m5fhVqI6zGR32yNsRUDusB++Ffr+QBtV7PHM3gAlZz0K0Uj1cRtobuTt3fb1oGCx10XVpQGPeVAGlDlrs/y7wzye8M8lcchya/dI2MqdAJEco/BMgSUbWaYBpWbAn3HvdHvc6WABLJovYl9atiakZsFkIUkJfcV9t4eu1nk41SaTAPIDYqZ2o8rMidrpNGsSujA5Oo4gbtTfEpTdTHDs+qTUOWEMKIKDsdUsya+Ii0yQJQHjkdOM+Zlk3ddFZLl/Tp1tSJoU5BOs9evD1LOOtu8+C57IYGTHj7lPq0GhPHXuOmIa+hDkdmUen9wCXJffriyJ7W4XeEuwayIPY2/KSmenD/O3oN3f6Bp9JUL1SuvC65Tllgg/bJtUZUzX5F65cFvPDF/1lbx5f8TvaOqh4BgASTaIuPL/pd4S5zRF63Yf8KIMPRqrbLSeTQ/y785Jn3YuhkA7GGE3l+qAGiXZKJMvUJxndrKonObMEHXzZ0y8oQzGe+9hLGrpzd87NV5kSArLKw8OZnE7a6lw3AnK6QiMDQb/CaaGwk4P/6Q5IjicT0CyIjEPtrG+Z4lKiH9IG0rosiGbamcsz0SBKuoPd7u9ZfjdA1y1+rA4+vPDjvBKEjwyWaOk2OnuoVuYR/7QKHl2RZD/wkBiu+aAnAgXy7ib+nT1zO/H9rvOHwdE37vocLZit1l97PJtDD3boYGvs4BWVuQ4KK1Unn3JHqqiQazazjVyaCPljEHCGWyjLDlGdoP3MUSC4+/FmQjK5MiP1WGYtmUZ
 qT7ik0oD
 ZDZLUTOKJoIGi04+hrU2xfMWaw7O7wqM9qTrKOTTGffxTptXtAtJ/vUfR3ZETvXH09HIRNRuaO8Yq2B4iAEboT9LChRtW9W030p6UluuP0mOwjdv0v5g8hzVZY0xl/f0T0EpAa5q6eK5J8RpFwdTMHUlMct+9DK/JZLSDeh1r969CeXGzzM1tpbQAMz1wU7C0QvPimjwTIZg0YBUk8teSWVJCVE5yPFZBnxvfXEeLz9Uz4mMZ7N/ae/RnL5eCSE/nZcbuH+0vMWIjb1xe4bYdREQ/q1/BJoRjTt2DJPwFHYyRuZqqryy69X+7jBGa24KfrmaIoQJl6vsNoC2k8ezW/q2acwmI1gB02XmOtuGrS/1anDz40fmZ1UaGN2M/V4Z7VG4jyU6jVURo1uEB5HbfO0MBWkj6vsy6Sxd6y5vCVrsuJfP2zXBmTbUW2TwOP0q41OQMU+HBazpX2OX+Ku2Pm+6gSGi1eS0io92fF8GqbErdwYpYlKhYG4sGJSx6XNfc0WRGFjY9oaX6Ahn6qZZD/ySa0c0SUWm2wYty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This continues the ptdesc conversions for x86[1]. This is a necessary step
in preparation for the separate allocation of ptdescs from struct page.
Once ptdescs are not wrappers, the pgd_list should be used to find our
ptdesc, not page.

In fact, after patch 4 we can successfully boot a 32-bit x86 kernel
that separately allocates ptdescs.

All of the patches are rather straightforward, I just kept them split up
for ease of review. There are no intended functional changes as ptdescs
are currently still wrappers around struct page.

[1] https://lore.kernel.org/linux-mm/20260211195233.368497-1-vishal.moola@gmail.com/

----------------

v2:
  - Collect Review tags
  - Rebase on 7.2-rc1

I've compiled and booted both 64 and 32 bit on a kernel with separately
allocated ptdescs. I ensured the codepaths were hit for all the changes
except Xen.

This applies cleanly to 7.2-rc1. Dave, can you please take this through
the x86 mm tree?

Vishal Moola (9):
  x86/mm/pat: Use IS_ENABLED() instead of ifdef
  x86/mm/pat: Convert __set_pmd_pte() to ptdescs
  x86/mm/pat: Convert collapse_pmd_page() to ptdescs
  x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
  x86/mm: Convert sync_global_pgds_l5() to ptdescs
  x86/mm: Convert sync_global_pgds_l4() to ptdescs
  x86/mm: Convert pgd_page_get_mm() to ptdescs
  x86/xen: Convert xen_mm_pin_all() to ptdescs
  x86/xen: Convert xen_mm_unpin_all() to ptdescs

 arch/x86/include/asm/pgtable.h       |  2 +-
 arch/x86/include/asm/pgtable_types.h |  2 +-
 arch/x86/mm/fault.c                  |  8 ++++----
 arch/x86/mm/init_64.c                | 16 ++++++++--------
 arch/x86/mm/pat/set_memory.c         | 17 ++++++++---------
 arch/x86/mm/pgtable.c                |  4 ++--
 arch/x86/xen/mmu_pv.c                | 22 +++++++++++-----------
 7 files changed, 35 insertions(+), 36 deletions(-)

-- 
2.54.0


