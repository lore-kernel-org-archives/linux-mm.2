Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44BDC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6972A6B0005; Tue, 14 Jul 2026 18:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647A76B0088; Tue, 14 Jul 2026 18:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536626B008C; Tue, 14 Jul 2026 18:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 251AC6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2A091C054C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:26 +0000 (UTC)
X-FDA: 84988804572.11.308FE6A
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB73D14000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AV8sTo9T;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vv0t/+7auxcbtGWpvakmJ0ritrqSQFOQmC0jKQCZU2I=;
	b=H3HGKFGBOgEyDL8KgWGgRdeb78wKLT7YO/rNIYfnQLg73YM1YBCqe2by+vGOsBesVb4ypN
	iK6LRZtSqHQ73gVjyXpq0Il5CMO6JFaHdDcySZGF7BGlc5B37AHPDN5Jbdgq2v+ZMDE92y
	WXWpFdrMTZEVnQOrWOJKrv+b1dE6VYk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AV8sTo9T;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067684;
	b=R+AczGieP3iaM4SzYsihhBkUyUlE/gu+JOb29Cint0v+sP+3NFtxSK0NU/sKSUEUC1xuZ/
	8vmsDZ8AYQKfeawaRFcedyN19zn2CPXvqZd9voNlwHmBMsI0laZEzMdrtuPYgtQRr+Q6NK
	VI9Ty8GfDlqwehy+qZhaJdZlpgePDaE=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c85b73ffb52so2662133a12.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784067684; x=1784672484; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vv0t/+7auxcbtGWpvakmJ0ritrqSQFOQmC0jKQCZU2I=;
        b=AV8sTo9TGSGM9+1FyTEhf6/+1ShKbDHE9dJM3bbjCja8MbMm+RuDDnV3j/v1kDZzyh
         E7Hj//gMxqDGTaA2G8I2gSZdnWADNGx6xhmAUIRJwoflFi3l5+LacQDu0l/cqQxG7G0z
         z4dc1195sapV6enXMkiLO+yufZaIX7RmIJfHupTvOQCP/WDs9YvQf4HiDEO5v0ni/RnI
         +ho5DFPKpI6+OZZegJG6592r7FX8cwO5qnepmhODqMo9PETtbabC8nVZBcSreK8rVjZg
         JqX/r+OnSdctiG5JE70y6OO9aq2ilahbPxISXiPqCkyZTJtGSZ7McgvgUH6wUNfVkD+2
         W3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784067684; x=1784672484;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vv0t/+7auxcbtGWpvakmJ0ritrqSQFOQmC0jKQCZU2I=;
        b=FZlZVadm2R5v9nhmeTWK9J0/rPty1HRP1lY5SSCgyRaVHbBqmYGGIRviP9tBr9YZwD
         GHOYvSoSgHjrw/eSwVruU2uQ+91XzRWhOUci0SOtBuSSng+aCB/6sEVhp/x1klnXodVa
         XCbjtcbGOXEs5uRQNL8iCiNlsLej9j7e4uzqYyX2t9WYEhGa/5RNaflzgGrLuR4jQNqb
         p9cJ2z3gbQEbbJ1khVM9dSPrKeYU/g6ahu53Dka3ITHWzLTywE4zIMhZow8oP4pg7WZ0
         zBHiS45nxOLql7WZ05K+NZ9zWb1WAKNFiI/zujZCit5sdiEeO8moqqB2SmlfwtEdRZU1
         gVxg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4QIbzi9b2hEoEP481HN/GJE2kNfjklMtIssFisA4azjEoDfgU+8+A9O2UwYLjQT4JCcRlkjr1tg==@kvack.org
X-Gm-Message-State: AOJu0YwFJ6+EDyKD0mmQESN3Kf0WlwWmOSXp9d6l/WXe0TynkmkNLVH3
	G8ic8rqTwZD7TspOeu/y1bQy/23vIEobnlZOpuu1tEEF8ge5M7M9oohV
X-Gm-Gg: AfdE7cngD0HWMQ+GTUTyk8asWLhm63d+nukE2Wu+PFoWh+noBoUcyX+peJNuoGJMrMS
	ujyVhIbxXGf5g7s5CzKjY/mzDMn8UIIipp2CTcqvtt6DX+w0PTXY7EtY3z/ce+P1tFQcShSJm5x
	SAqkseiKR/PiUAaBiVt7Qu6LgXU3B+bFZknTT5Mug4ilPdhyKaflBxg7jjdfvrXWQVMd4vPNsd1
	vbGSljHbTnsHMacQKoizp7I6HUGG39IC3Qw+2EQgQ8K251paQ7Vh4ocs+nqTkBDmV9yRd7j/+S+
	twmaLptdyqPTmZb0OcXXRxtjb/MtP5xab0dQAxhGkX/LhY5b6tA02p0sU8a5MKsBzvjxrH1FHDz
	cfLP74YDiHhG+CA9qxbe2T5pYvYl3+wSMLd2uxy1TGEgbcwacQH7zC1abH233GCalCtrQpuy1Ke
	8GS+OLk7MzfSsrgG22hUGhShYqsx3gaO9i2Gk+jOyo4YuGR0EtLpVyVIg4ygk=
X-Received: by 2002:a05:6a00:b4c:b0:848:6895:b763 with SMTP id d2e1a72fcca58-84a6735881cmr262012b3a.40.1784067683556;
        Tue, 14 Jul 2026 15:21:23 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3643cd6sm10622134a12.26.2026.07.14.15.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 15:21:23 -0700 (PDT)
Subject: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope HMM
 timeouts
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 15:21:21 -0700
Message-ID: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DB73D14000A
X-Stat-Signature: kqk983db7zgbxjscsa7grxcs8pniah6g
X-HE-Tag: 1784067684-811589
X-HE-Meta: U2FsdGVkX18nXGH6iDSrrgdmML63VsC7AcfLpg8mjwWUNhk00HydS6ElYa8dVhcNis+j9zTtPt3c8Wp7W2mwRzMUkhQ51ygAZsayXiqNlXuErf6UjkYJn5I8TA97m5rJKajEk68D5D1Wf8z7PGrPGs4bHZxe563Bua/1shnOlTmXJYZel4ShK39em/Vw397J3ibsYUVl43PwhvT0y6YjYjgT9zlb+Ob2qHqmlFnvsRta2nNuQGhadE1gCLTnIBvbVbpKLUz7Yi6WMlc3ewn0eyHd+/J3YenncmhXYHLbx2Odn6iZ2Gj6lElkbVAvmHRsRB+W2Aw4tHHgx9BghjGJHF+kqIygGmYHbH+3URPJsIZ5hr6L4c1XYGGoM3Ejc/Vpo5Bc5k7GzAJvFmIYq+X3oFSvszyPB3FsMCToaIV7aChSUk9qbu/waJ87sewUk0DzYrLn12N0A28sRKZk9PoG+fLgJdtRyCChGWy/YZY/nZmKVqIxjB64eFB0Ic5NL6uevZ+jqTLguyrB7CsxHmmQtcGeKRMxdMh52N18EXqn2+r8fiAvkIryMnTNRMD5S9rkELGPuOHih64Z7xNGOT+A/Z+5n42bWJjktz2BkXs+Tm2mdIEV/hRFXuLZGWVfdDpVTzG66sDuzypUD9n4SV5pGT0EmZRfApAGgLj5wt8LxO9Pi+R9Z/Pf7jP3/a9WeiFhVVIg1qgt4V5U677ivUz8zktWu8hl6dSRSmAIHKLX/OkeJ6Jgcg9CTY3SKfDHE3+w9TmQCZmI+C8yc2n9UCxUfFyxIWm8TlaWXwObPsVzGm78rmUDOxMHGbkEE3JYs6VxfV2DSuUmUcW5vDR4FXRICQHqN8OrfN6lSDx64uWxMP+U98njwxSZjU+/lSrqnEV0E6R7yVfxaRLxqBtUJ/Yjs2fmwpWjOvgztvgYx8wH+SDSUpqieKFQMhT7BXlZ6Uc00tHNyi1n0H6UXm1sWJN
 fe133O+o
 uTQ5FpRU3V5wczHaZ4WSjJ08+KhkedfqZOGtXwoS6SN/HteJ1B5JZGTSsMtsLbTu3xgbQjjsvZJBVJKkiCPqpobuAaD2fpN1ok4PR+sIQx2JtDV9u/E3Zq3I073gxUWfgitSc7rMMI2RtlXVvNABR5eqZnnHeeKvIqBBFbFl56rie4kIXBWeTKM+k+nZAReGHhWz9KsWyX+3MgU5AgUpjeIRtAxPBtbwRxSJI+xJMnBNdONvECenL4XC0sCcwFuTsgtlgbNiUi7LZE9UqTOUPWDXRm9WVZPVoe2eqO5btg4pGsXDRrGGs+1NuJ2X5DQwk9zTvdUx4UTX+3e6hWT3375s7H0Rv4duSLf5hm+QeZnZ9Mvb9TMpHLORg9HynmRvUOpNuPsv1P8AJgqiq4eDFYosCiiOdJrlix/JncFBqNSpEn82ejvoT0GANqKb3376iAThGeEaqfm+xAsuCJyX+DzzBr6a+yvK4UsNk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This small fixup series applies on top of:

  [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings

The first patch updates the HMM documentation example to make the
mmu_interval_read_retry() state explicit: callers should use the notifier and
notifier_seq stored in the same hmm_range that was passed to
hmm_range_fault_unlocked_timeout().

The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
HMM retry budget. These callers no longer keep an absolute deadline around
their outer driver retry loops or pass a computed remaining time into HMM.

This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
HMM succeeds and the driver later observes an invalidation through
mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
retry budget.

Changes in v2:
  - Kept the nouveau outer absolute timeout around the
    mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
    bounds HMM’s internal retries, while nouveau faults are handled from a GPU
    fault worker, so userspace fatal signals cannot break an endless stream of
    invalidations there.
  - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
    timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
    never 0, which would mean retry indefinitely.
  - Updated the nouveau fixup commit message to explain the worker-thread
    timeout issue and the time_after_eq() boundary behavior.
  - Fixed the amdxdna fixup commit message. It now describes
    aie2_populate_range() correctly instead of carrying stale nouveau prose,
    and notes that command submission still keeps its broader timeout while HMM
    gets a fresh relative retry budget.


---

Stanislav Kinsburskii (4):
      fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
      fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
      fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
      fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults


 Documentation/mm/hmm.rst              |    5 +++--
 drivers/accel/amdxdna/aie2_ctx.c      |   12 ++++--------
 drivers/gpu/drm/drm_gpusvm.c          |   21 ++++++---------------
 drivers/gpu/drm/nouveau/nouveau_svm.c |   14 ++++++++++----
 4 files changed, 23 insertions(+), 29 deletions(-)


