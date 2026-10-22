Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E83606F1CD
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TPM1gile
Received: by kanga.kvack.org (Postfix)
	id 043056B099D; Thu, 22 Oct 2026 13:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35E36B099E; Thu, 22 Oct 2026 13:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24CA6B099F; Thu, 22 Oct 2026 13:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA1846B099D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:38:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26A63C0207
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:30 +0000 (UTC)
X-FDA: 85350971580.27.C9C6FC7
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87976140006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPM1gile;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3Ekraag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3Ekraag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792690708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fjiXARepIxbfti2BIQyWUwFTisje2rpKo84txmBJh7c=;
	b=6PhgwRwq2yE3LUsbd+PanNeianYhwcrKKg7PMFWPu8uwOJtcPnOR9OeZRjekdFfv0F/Mar
	UWxNQsPlfW+0LMKMxo7m9yy4P04mOoG6Rfppt/2/7xjqlGb6b1pfb1AfTxTXOh1YCFPTU7
	2jFdxa+gLpL7Y9Nh2j+qIlCspRgkENo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPM1gile;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3Ekraag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3Ekraag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792690708;
	b=O1H/WJeU49V5p0RMziVsuuCnk7nVs6vwsR6OrGb7EeXduK5YsQWA29SvTfAhlwRSpFtsf9
	XHxT/1VTdAJL2PDRytT+eil4CEVU/FsN8gmggH/Zw+ny+Ng+/3X5uKcJIDKZ8qb+ZsGQ5F
	ZvWPTENHFReuyB19LTekcQ/MLLi+GxY=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso61719eec.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792690707; x=1793295507; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fjiXARepIxbfti2BIQyWUwFTisje2rpKo84txmBJh7c=;
        b=TPM1gilekvvs3M7KtCdNVUqq1EOgTVa8jjWkIhvUKyxLetoWb/fKPlW6wl+SVO1TBW
         cCT+sVYM3TeMlEMZyyfUWehdKPQKSTY4MyDgP86neB9HXccM4blJZlXZ6zMsvfKPavf5
         /Km4x9FMOJrE9cHMxP9kaPCUMk3m4xha6bh7Gx7s1BfPhr+2VLb7AHQDFOA7Zu+CPgki
         XF4FX1Lh/sOTv1R2ETHJJGrIbewG4k07HUs1TS+QG238rMxjCqKbh8oNRieHSMeV5X4K
         BA4z/9mux+2u10TkC53KO2Zd82MFUoffW68Rq5SaT9LZ16r2grTvD9Lr5I7FzQX+V7tD
         wLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690707; x=1793295507;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fjiXARepIxbfti2BIQyWUwFTisje2rpKo84txmBJh7c=;
        b=p4aFLU8CxkeMWCwzw+cbFM6EwIqCdg1oLwqFAxBxiuWe9btrq6NrB2gc/O236pDPZ6
         Tq1WmJHLUzxqxNXmvQZPFvwTyNpwvVWfuMArz4c+6oF9/EbVpWmhnKSa28ZuUeCQqKZB
         +iwyhUbj+Nm6Jp1W9am+cgc205eABpoiPC0s1DbRaqXa6HULwLN7OIFxWVmLMonupkFb
         Dq/sQkY+eYmQqd2tOcc3KwiKIGDrIYnlrIRKvKr+Jx5qrfSaiG9f59cYhmySlhsac8sB
         MYj14jkYjS9+FtwYLRzzh2ZArI/e/nWHYk5hHmI2q3Wlwk14fe5DxRq6vlZkxm9T2B6I
         om5w==
X-Forwarded-Encrypted: i=1; AKwUvBybtSxkjJBAq8vG/YfLgXJ9iIMftxjHrbjH45dXmRMpg5kSavEQgbpTUxERV5wnkQI8L0CHkpiPZQ==@kvack.org
X-Gm-Message-State: AFq9FYIV6EjgI4Y7LMbQVp6bV+Ca4VzAY1y/0rfEN61ylfIZEAesC9Vq
	pilDD8nY2qYqjsC79ClduCoN4Gl9ryXOBLv9FdNoXEpHQYYbglVYz2JsHykiuMxsIAv4yLdO+Ur
	Lmjx8QDtD+5i5dyRBrY+wKoC6NClFJoVsrw==
X-Received: from dyau28.prod.google.com ([2002:a05:7300:601c:b0:35a:f5b8:c8c])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:88cf:20b0:35e:cfe7:4c5e with SMTP id 5a478bee46e88-3674f424b7fmr7710405eec.41.1792690706777;
 Thu, 22 Oct 2026 10:38:26 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:38:19 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <cover.1792690544.git.abhishekbapat@google.com>
Subject: [PATCH v4 0/4] alloc_tag: Introduce selective tracing for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 87976140006
X-Stat-Signature: 69ueb8epkd3iwhtrmembittsq9raq7tx
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792690708-355917
X-HE-Meta: U2FsdGVkX19GooBWrYJmTKnHMXLR445ieT5qqMCXzkra2n+bvAfZcHo7fvlhHVPyEqnVaYvmyE+iO7gcjM7a2l0aIl5TVHONr9X3lmImJKDB9P2Qy1O0REBKC25EVONqyzlb6TQoqGCQ+BvEBsvSCajF2FTfc1qn/q8C5WXMX5BubMXX4t+70cUObvz/qPFHL5Mug7u8RAURXGfLW3B2sUc/mxjBkTxHBDYRhRfoRUXILmpcyxPB/yLoV5kk97CA5StaEerXboQAEe48jEMnPa7njdVf9azZkb76Y4SPulqAmlxRs3++oPlqAtlgyb1GVWKXPsMG08g1gB7X/5NpgZy4o3sm/yN40zSwg+hW2Y8EOA1elMIrhSD2FYJeHVP0k/DSiS85gUxgCUKJdIlu540bZgkiT9EX/7GWZDdtSQUnJpxA/1eNrDZ1FcOfgBk9o6H7MGFGQFF+Ezo15vPyMAiDdvbWRaEibB2yCtVNakLbxmUWtTX0/SbpHilZljOnPJoGPWZu23NOh+drg084dCH/eIggEwmZx1a2nHj4jnrklA+DkvmSpB6sECm4ExCxTPX+AdfLP/UAGWNQ97Bt3idRIE4hbS11hkKpxa67p1J7PTjdhbKlO4Q0IKVvpKaJ8q3Q9QlmqyL2k47TbScNaIuYmlBVK//RlCuHrJiMlxw78agUscoceneLfe/cPPV5Lxz+ukhCw9ZWs8RFdHrrVjuUAf65JlQbklRFh8/kRJDQ22qWqWzOmXsnc/fhMntjHLRXrr++9+7/Wge1AIJMuuW4cMx77xdTj4O0hkSwqa9v/XzX3VuOeOIHAP7h0b1DXVDlh81KYjROVTv/04HswO2RSZpMTNUvE2TKIhlklV9z7ho1LzX0wHu7BhwqLtD2qwDxuBj/K8Gm0dBtwo1EQu8AOQSsk/EUlRNxHMjlBJU5WedD/oaRDBd2sY/SliLvX7AYsDxY9lvgqYnBjU3
 i4J+1Ur7
 ON8bX3760eV3DQPsnPl9DvJIDUbSQLKeVu+KEGd9oX84nxXQoKjnhP4uQkwdusV72EsCvhmHS+zwTQpLnI6Giy/w97XTvLGj6AS4RvZp5QBYDKHT7E4fd5Fa5qjroDosQV4qithpjjoThog6g9eYuOHvJCq/otz3AtKA+Fl0r8HdH6Lnu2CYsD2Q7HE7Pz7u23fZYdsKRhslbaApgr+LI1zUO8bk4FcV7Vyvse8rgSGYePhhgdypwuv3WaR4U6HAt9wmBiNPcb/GI3Eu3XKS2pZOvBdHqThNibnqVj24ADlM+yOI7du1lpVBjVCbv+jCpH9Cb6DfCQrtURS9vBXP92I4r3XaiX4VtGH6MCbGq6GUP9MFZJyX/p7KxHc4TUa0ksvH3kRU1Cu0mzMsCa5abUJBasGBYIrlsUO+lRxpO4MS3G1w2OzYh+bavteD1Cj5g5SZuibgCL9bxQv47p0wzSygGJvp6ry3lxMMo0mwCgpL/tCsgyDHUgbB8JJdz2S8g3hwlTJEDLftPzpHxPdnnPv6zrrUz00/bF8YGvDW7Gl0SWKAM43QgFTopzY+pTx+zyqMumH5hpLSVeObkdNjWdQneIBWwQ1nEm8Y1UPZNCPJWWXXz8yuPdFBv0i8gotvV6mqWkl+5Gojp2QTjNy8+NZGVyAW+uIjcBmE/dOIxE4/QmUsVTj8+cU9N7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The existing memory allocation profiling (MAP) tool accurately maintains
aggregate counters for overall memory accounting. However, relying
purely on aggregated counters restrics the visibility needed for
targeted debugging.

This patch series integrates three new tracepoints (alloc_tag_hit,
alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
alloc_hooks_tag fast path.

Enabling trace events globally for all allocations introduces a severe
baseline overhead. To limit the performance overhead, we let the admin
select specific allocations to be traced.

A new IOCTL is introduced to allow privileged users to determine which
allocation tags need tracing enabled. The IOCTL utilizes the
pre-existing filtering mechanism to specify the allocation tags to
enable tracing on.

v4 changes:
- Patch 1/4: Minor refactor, changed macro definition of
  `alloc_tag_trace_hit()` for the NOOP case.

v3 changes:
- Patch 2/4: Minor refactor, documented the `CAP_SYS_ADMIN` requirement.
  Moved the mutex lock / unlock outside the for loop.

v2 changes:
- Patch 1/4: Changed the trace events for the page allocator to track
  pointer to the head page instead of codetag_ref.
  alloc_tag_trace_enabled() no longer takes a tag arg, that arg gets
  added in patch 2 instead where the function makes use of it.
  Introduced new sections in the Documentation expanding on the newly
  introduced trace events. Minor typo fixes.
- Patch 2/4: Toggle traces IOCTL now uses the same filter as other
  related ioctls. IOCTL returns -ENOENT if no tags match and an empty
  filter matches all tags. Added a subsection in the Documentation
  expanding on the new IOCTL.
- Patch 4/4: Updated the test to work with the new UAPI from patch 2.
  Updated commit message to accurately mention that the test flips the
  state of trace_on, verifies it and restores to the original state.

Abhishek Bapat (4):
  alloc_tag: Add trace events for tracing allocations
  alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
  alloc_tag: Extend allocinfo_filter to support tracing queries
  alloc_tag: Add a test for trace state toggle and filtering

 Documentation/mm/allocation-profiling.rst     |  73 ++++++++
 MAINTAINERS                                   |   1 +
 include/linux/alloc_tag.h                     | 106 +++++++++---
 include/linux/codetag.h                       |   5 +-
 include/trace/events/alloc_tag.h              | 122 ++++++++++++++
 include/uapi/linux/alloc_tag.h                |  21 ++-
 mm/alloc_tag.c                                | 159 +++++++++++++++++-
 mm/page_alloc.c                               |   4 +-
 mm/percpu.c                                   |  13 +-
 mm/slub.c                                     |   6 +-
 .../alloc_tag/allocinfo_ioctl_test.c          | 113 ++++++++++++-
 11 files changed, 573 insertions(+), 50 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h


base-commit: 5f980b2d53abf3950caff5d77b5c69dc6ebb19b6
-- 
2.56.0.257.gf7497c7d27-goog


