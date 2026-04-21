Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828BEF94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B756B0088; Tue, 21 Apr 2026 19:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E634A6B008A; Tue, 21 Apr 2026 19:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0046B008C; Tue, 21 Apr 2026 19:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA4C76B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:02:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 788441A131B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:49 +0000 (UTC)
X-FDA: 84684089658.25.F539E74
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B7894000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k6TVO3CB;
	spf=pass (imf04.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776812567;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+O4M27v2Tss7FIEhY4PBkpamm/Ohd33d6CzOiSw8EfE=;
	b=SYSGtI/MuqsoKFOi4tDddys5ye2sVZtpbv/bu3wKUDnQI9Pxq6uNwoVyRwL7tkd4qbfmww
	sUlOkrQw7TfbLExUAY/FRQa+2maG6dUDsD8rjstoJXpo41gboJoYMoLnGs+LNSr50s87su
	6ySorBzuzMGbrCHBgiWOdI1YVpaxHTA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k6TVO3CB;
	spf=pass (imf04.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776812567; a=rsa-sha256;
	cv=none;
	b=FKaRT6ihVGK3G0c+S6A6foAzhvaIKrt6EXaka6lgYneAnGUQJndW56yEKWdOILyYB1TeFa
	17L99LWceeyjT/VdnIyoFuWEccBiCy1pl2BKWqz6oyp0nrvdMdyf/l3YdDAmvOOzj7aLLD
	qiq2fTrrLGKMDxN+JAtZ/MsZqz649RM=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12c8f9846c8so3613582c88.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776812566; x=1777417366; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+O4M27v2Tss7FIEhY4PBkpamm/Ohd33d6CzOiSw8EfE=;
        b=k6TVO3CBV/rqn0tSfW7TsqWMpDqjOfJelmwGSyywbyeSWR3jT0tZIQ2EyJ/USxUZeT
         QcfKN7TZacdsVBsLK3I0+G3F+i9iAK5GHQHOgXiflGewqBkKjFwsnn6nb8ku+NkwhQKh
         RHABF2XUaY0N5tSLH3f3b4se5TXQaAy08gJ7goJrF+PxR2VRP30g8WcHett/sXUYrAZb
         i7SE0/AXf6RdC30bVzzxwub0M6feA1ieWJV5jdf2hrF49F/LecK22ypgu9GyCMQC9sBU
         IEnn8JSjIhIK3+O7XYpWQEKLOeq3kF81SuOmFkPq6cipVke4FQXjVaOzX1sZoft7N7m6
         huYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776812566; x=1777417366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+O4M27v2Tss7FIEhY4PBkpamm/Ohd33d6CzOiSw8EfE=;
        b=oAeG0Vcl8oeA9XzTVntuvB/qnowL2O7UdM/a2tHFn6KrkL8qzd8GwaPZT84yj0iRcZ
         9ZxvgMOvzPUtYdRSd6csM0TFXqVHdyoSPsIpHBwgp/a/rCn466N8h1IK+VlCHZcJef8m
         aL1MhKwtaO4c2VZq0CHE+003vlNkDhXZO3+a9oex353ucLdIQuhY/BADwOJPalt0PBrm
         sbRUZu5Xc1LsRQ7k9CMUkWPUhPfdjVuMQiX+i0t9HBMbRTJSOqtMZvJm1GiUvFa5OHtb
         bzp8L5xGIi1QV/D61AMttf4TSPJTmky/Yt2yWBP7oH63YxJ9Bjr+/VA61GjDTH65k5xT
         ZkfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Wf2DM66cr+I3MFndJin43pcgjKv4HtTZO4M3YATwjlhzI2kP2rPy7Inurb7hYkQWHVQmHL6hVXw==@kvack.org
X-Gm-Message-State: AOJu0YxpNEPJ3na+a1s7/MwPwhowgnBEKPbgz2Yxr01VHsiyazxhvomA
	KpBO9DL/2GxJD0d4X3tvt0nhhu1f9Kyg5E395FDFph25iUAIWAjyDYV8
X-Gm-Gg: AeBDievHJ1wN5PzBoCYR6M2ogY93145eptx+8l3iEJZR/IU2udDZ81MWiA2qkPsyPoy
	bWt9D6gr4wsKDu9+bVVTxTCgalnhwU8SMhatG1OppOnEXgxQC33PA2RmWK01T4ujEZ0TQNCvDt1
	JsZvS/2jV2q+u/bhWz+k/M0b6j5GzljBx29npEfE3tFkfFmb3EKsFcYKvbcNs71dgz751BWcXGw
	/VLImwayrziP3eO+TVe4PaVUODN+i13U8XPNnyLFffiwm+MXX5YbgdZ/whn2/Q+tIrWs5jWAyKT
	beP3b5FeUAN4jrSJs2PIjVjh5rPkPUpGE0YcAMY39BYUaq7WmQ84WMAO8EO1+IUEZxxYHU1jEkT
	bZGQbezw8+9Qc7Ndbpoyezp8PrPG3Y3IGl0wr+srInaFedgreic7wk11cZOjLrYSeIRTV5rvDAj
	o4R1b7kdUcK23PjCC4lPEdP0SW8mFihEdP+5vniEURZAS0MSsD6gSTG6C+e85gY1062/Etj+B4l
	vPMwifwhhxerA==
X-Received: by 2002:a05:7023:b13:b0:128:e693:b61c with SMTP id a92af1059eb24-12c73fa713emr10677778c88.27.1776812566137;
        Tue, 21 Apr 2026 16:02:46 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:4678:d28b:b946:bcc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a20eb5sm26453546c88.14.2026.04.21.16.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 16:02:45 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: hca@linux.ibm.com,
	linux-s390@vger.kernel.org,
	david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@google.com>
Subject: [PATCH v1 0/3] mm: process_mrelease: expedite clean file folio reclaim and add auto-kill
Date: Tue, 21 Apr 2026 16:02:36 -0700
Message-ID: <20260421230239.172582-1-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B7894000E
X-Stat-Signature: asudzess1f5696s1k1krk4cdbfrazbbb
X-Rspam-User: 
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1776812567-767973
X-HE-Meta: U2FsdGVkX18PelZi+YYG9fTL9yEo+iNU7W6dXZVq8/eBlF9HYzfZhDLzSHsl6IufeGHGuZZRv69hHMWQ/MmToxhm9OzGYDHCq3j+WZFuJnyXp1u0bwZPIKMejNvbdTw4CacomKImeJxJLM7rharTNxyzpcdSalSC9noHPSvfGR2XhZpBO1pCWh66xEvfrDO0epTpykfMjT560UgvS54LSx+5cwxWg3Cm1WTUHZwotAOVaEyN3129HoVY3mHmc+oRHPU1yzN4uw1omzFgFnXXCnaeYNqmGXaQ42zIXPy4afL1lh3WuHStJEmX3KLaqKj1/hz0/g/98850UrjQ/TA1SU2O/0jGmx67K62o+RCCDlKsNfeEIje0TmDx5G7Cw5P/4xesraxT5bvHFvskFyZGIqm7JuOQB39hO/ZqtYQciMTIBVNYNtbvYVaXP78qH4AF9/MovZ0jB5Pi6WQxZF5bOWANMr3Cz6Vgs3xi6uG4so6WMlF77ZWmGCWR3tKGIWrRsifHuhtBEvjf5ysb+6pAt/AL+pcTJv6jIXISp0ojajJIIdCxaQ4tVgWvN2+WUAmNOJlVZ17qFlfzGk0q/8I2Q5wsIVWuEcGrk+CBDPWwfvtYncMqh4bfr7dw3iHTIaaaygTwTTb+Da0sjCTkhJKfvjMyfdCQEA25180Zp2YzfMa79QCN6OQ5ma62LdNCez/eoROKAgoHTuoiBwjhVwYblc4jjjBAIvQyIqE0te55z1ykvdUVShHwVlkuS2lV83gKkX/1m+OmKMmuXEMqB/rfcwWh6ODnjZOtdfMyLFiwVopo0SxTaHoZ3kjW+5rj7DJAD/s2oMQNwr6yWV0/QrRTW7860TgXkT70THyEwPRGnEyQ1m1twt1hMFsNMuUM4IyenOwX/KGeAfxvvmXUCH4ffs1cIqL3OzHiHCEkL8fFKGJ2g/SyAv8xk4ACxA8j+74rc/Hb3a0Z4gYehMo+KX2
 HXCJUaxk
 TD7kSPNoevomQhat21poDYmEqrKsmMxY7aikNOaGD2mdBpnuFgpaGrRRzN5Y1e9eiyx07INXGr/ZZHXcEJY1wr6PpoCJYIhOO6eLDlrur1Eh7cTx3Jsh2rFeBvWE7MYa47FdzDPfXG0LDFJnEiIv3CH+F0ODexh5nvgDegQxtRbrFy9/rsp/DjvNBeNc8kv3iYJaMMOuzgAcNmZplKUIDWH89o4+/SjmFBwYTQ4brPmurHRDRHbO+VYc/cBIjvkQbChSc/h8/1Zn/ypbFyIuApqjNBvM/DnzoCZ2358EL1793BnRUmRb2G1gNGdbgnKVByKBAb+oGWbswoRJrvNSMmX2sRvSpPL4u64riFuvD6alrXmjinJ3Z31CfBMoShv5riJf3J2NO/NUkIjPFGlCe+lqq6Pzp6plKTL/nJkec9ou21VxJu/9AhUycaER2XZqOHEWMCGGOcHN8cXGeMJMfkSOt4yYRKb9rI1irVwJU65j928oLaABKzH0XQWUk3aParNfkTTcd31/pvElVCIxJpGoEtdD2exuLqNieQV4JF6TYvXzMn+BU3POIBkAaxj6nukLqn3Ft6YDeC6wLb0ZUg5nqh+uIRQzWRVsCyifNt9pAofjKTZdFtmjmY5jRCGM5IWyTg2Cr3ju+44RBIiF+dxQ7xNA35HSLkJqdVYcNboDWzI29khqs6yYHF0+yZtzC27Ag/1a1l8Wrg5/Gtt3JYUplzgyNIEJ0WEI1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Minchan Kim <minchan@google.com>

This is v1 of the patch series to expedite clean file folio reclamation in
process_mrelease() and introduce an auto-kill flag to close race windows.

Currently, process_mrelease() unmaps pages but file-backed pages stay in
the pagecache, relying on standard memory reclaim to eventually free them.
This delays memory recovery in memory pressure scenarios (e.g., Android's
LMKD), leading to redundant kills of background apps. Also, the requirement
for userspace to send SIGKILL prior to process_mrelease() introduces a
race window where the victim task clears its ->mm before the reaper can
act, failing the syscall with -ESRCH and delaying reclamation due to
arbitrary reference counts (e.g., reading /proc/<pid>/cmdline).

Summary of v1 changes since last RFC
(https://lore.kernel.org/linux-mm/20260413223948.556351-1-minchan@kernel.org/)
- Patch 1:
  - Unified free_pages_and_caches() in mm/swap.c to handle both CONFIG_SWAP
    and !CONFIG_SWAP
  - Clean up description - David
- Patch 2:
  - Used !folio_maybe_mapped_shared(folio) instead of folio_mapcount - David
- Patch 3:
  - Used mmget() instead of mmgrab() to ensure that memory reclamation is
    performed synchronously and deterministically by the reaper, avoiding
    delays caused by non-deterministic scheduling of the victim task.
  - Dropped the custom KILL_MRELEASE signal code and modifications to
    siginfo.h and signal.c. Instead, use standard kill_pid(..., 0).

Minchan Kim (3):
  mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
  mm: process_mrelease: skip LRU movement for exclusive file folios
  mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag

 arch/s390/include/asm/tlb.h |  2 +-
 include/linux/swap.h        |  5 ++--
 include/uapi/linux/mman.h   |  4 +++
 mm/memory.c                 | 13 ++++++++-
 mm/mmu_gather.c             |  7 +++--
 mm/oom_kill.c               | 56 ++++++++++++++++++++++++++-----------
 mm/swap.c                   | 42 ++++++++++++++++++++++++++++
 mm/swap_state.c             | 26 -----------------
 8 files changed, 104 insertions(+), 51 deletions(-)

-- 
2.54.0.rc1.555.g9c883467ad-goog


