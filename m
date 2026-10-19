Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5795160A2617
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PL3yj1tL
Received: by kanga.kvack.org (Postfix)
	id 643F36B035E; Mon, 19 Oct 2026 16:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE806B0360; Mon, 19 Oct 2026 16:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD2F6B0361; Mon, 19 Oct 2026 16:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7536B035E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:00:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA3FBA850B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:33 +0000 (UTC)
X-FDA: 85340443146.28.64A56DB
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E677C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PL3yj1tL;
	spf=pass (imf28.hostedemail.com: domain of 33nbWag0KCIMhiopzolrihwh0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=33nbWag0KCIMhiopzolrihwh0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440032;
	b=daQCvc/IBlTvrGrmpKZB+aImCCB/DbeHVh3Tf9u+ldaL/CkSnakFFnOJFIBO61bk/OHp0I
	QN5XzJkkFBX31rSwaT+Y6swrPss547TPAkuu2KxPlhPOSSHFKFNuJstLF0bKmxCH9YcsCR
	kVJTruXIaMBVMOepX2yQ2kAEHQAngHg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PL3yj1tL;
	spf=pass (imf28.hostedemail.com: domain of 33nbWag0KCIMhiopzolrihwh0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=33nbWag0KCIMhiopzolrihwh0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i+///8mnECIM/kitzuhNw6Hg5zOvNqOpkINZPbtisJU=;
	b=eqf4hIuHL+HwJQ3GJXmoB5hyoaqM0Az8M9p9klktD7hF6EzChNBS+NJllvnBAZTsnYae7C
	Y+1J+Fmxa863BindMaZ6GbbkdXyPE1rDB486yL1OnO9UJX+iR/pJNwIPsR42lcrppxyKBO
	ICcRwB8Z8zFfI3Xu7bXwe6/+u3ZSu1U=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3510d0baf63so6304421eec.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792440031; x=1793044831; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i+///8mnECIM/kitzuhNw6Hg5zOvNqOpkINZPbtisJU=;
        b=PL3yj1tLrj5Rj4PBb/qe+FiRtqFfJyttcmZZn39RTOUs5hCPYY1GGdGLKwcclfYu+m
         x1WVtyXeRm0uyrDlyv6ndOq1c7/4+/siRar/jVwf91tQM6bJSSmCic7c1kDF/qh54nAS
         6MlVTUCaFXYmDcfN07b/zIuIBrPoTKtjIeU9Bkxeu7T7Ik2awXWrGLA6p2VpIiPwKxls
         tK8++txv5ra3SfC3CswN76tbKppFdFOb8DQ2KDHXbEtTrLt50MQvTOGOrBhEmEn5VSnW
         W1Dx+6q7UIRxKyP7BqScGbykiy7kwFCUe1MeOo5qFcddBC8zkq8C6fa6d4VfJPofJT79
         j8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792440031; x=1793044831;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+///8mnECIM/kitzuhNw6Hg5zOvNqOpkINZPbtisJU=;
        b=qBMNvshJebJMDbjDFF9iOOnpSjMXTytfAGoJsO5s2c0hUhz+9z7JQRDVjhH7RR34Oo
         7MCn4I/kJ+7Qarm354gBW6sh/HgFiCgE450y03GX4LRvFXKw3K8deKflCQExnPCcP7MC
         6Fxd6MIVw+oXc5/MEcxpYT+qOstrSQ4Epp5K+mabUTJTM7qJQDmDYm34drkC6Na6rrgP
         77NCjmXA7lwD0PS6y6klmxoxTTyQFsJlvGAumEf54fTEsq118fJvuEsWZXDBPKoslQXd
         uJAMY6JTFGc+ILVWI2t8JuOAlnorYWnViTqwD6IHQiincAgq5Zx+7eWRdEWlusAojvOw
         lJxA==
X-Forwarded-Encrypted: i=1; AKwUvByxc56wyD2+bpI8CUUaexy7lzyYsrnUUIAiX033JhcTLK55XuJ7iNfC5sWJ4VhAl9Y3gSuCQUBLMg==@kvack.org
X-Gm-Message-State: AFq9FYKawKl1JoKe1FKyE4gIfFwt3gl9s5oHYDL95i9kUSWlLqdXIWdf
	CmBuV//NgvttU435PPeCIHiUQsozzHrnXrD1Gow/1q3w6Ft4eTeeeQSMm0jkh37v0MpsQoULU02
	+pBSanRofuHIZqmzuom8csfghfzyYsuQosA==
X-Received: from dycmb7-n1.prod.google.com ([2002:a05:693c:20c7:10b0:350:9a68:218d])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:8092:b0:35c:ea0d:a9a6 with SMTP id 5a478bee46e88-361a2942afcmr13177681eec.32.1792440030193;
 Mon, 19 Oct 2026 13:00:30 -0700 (PDT)
Date: Mon, 19 Oct 2026 20:00:23 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <cover.1792439751.git.abhishekbapat@google.com>
Subject: [PATCH v3 0/4] alloc_tag: Introduce selective tracing for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E677C0003
X-Stat-Signature: dcujrarntsc1g9t6up7ttx8gqskp8jtn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792440031-885219
X-HE-Meta: U2FsdGVkX19SVVFk04IeyF+O/FlORHFDlDc8mnGJoAkFoGv1Y/HJJI1SADvOojTVpm9gqct7sSdLuqkFrLbWRlLdJtsrFSOao4dnUrp/l04CTrX7joHG+k7DlGdgLfNCFJ8HFEl7sjyZ8yWGG2k5TMssORqLLU7sKnGWUdvH17tOwKSe8dUiHnAhH3yabgN7KAePVlzue2sbK5e/HZ4qQ73utaP1JqnaXUn3zmeJRD730wQ2nbMxiB2fHzjTub6lgI4/g1ZUBSA4ky9r9Su4Vx2VnTN+wALWQ88b07HtulmDthZRdKQc316ySXUvpvN8M5kJR2WbAYExUs7gm6EItdNoaNkgg4RU3IPgkO2MFEs1nspSQX/etsr9JnboMu8nTTGMpvFUeU/P2YhGcZBZZoXG2XDGo/6oC0JIEleU/S1e75miZoGWX6JKSahYQabpotGegE9PvVsYrf+JBsG7eKp9I39fn9L9ELBsReFYjPIINvkuKDOqotSwPuX6BkhiFxRbLWm53RyaUQKKO0iuhxzp0bvIRrgVCMtSGKIz8BXQ6W/qLCvBqdqRVCSvhVF72vinL94aVdgC94itcbd0jTN8/nQJnFmsWkIGcPI/s9rpx20Mg1j8ePYQeqbswlUw6fL9HiN+8QGXswfbiDCpKmNgiPq8ttSLd50vBjFmi7BGBN/MNjyxHuclWDNluM0WoJGswazd4LeXtUFUzmloAYgaQxYewIhZRTHUlOyQ3U5TAkXfTZu3EYMmlbpfmr5N/+Ewchq+BQ2cXR0jvuSaajXECDSDRC+OCvBHOoTT/SmVn19J+ggCzYsgHChhVfngPcrR8joWl8TiccgRKRVvZ2pIelLN9gW/tf04uVFdiMxUeQQsiFO5wS0TkfWp4F9x82qgYb8mcRFV+xUYNDMWmKxc2tCIhRGR/goB5e3W9c0/2Z5YhTkNgwdAdJETWrqBaRWuDv/CAoSQRQLdwKJ
 ugCU4F/G
 PaRAG55/fcoRqak98duPsK5SOvaZBAkcY6HVsayMXlZZ35Yj2xLtpG+o8TDqLOIUgEO3T5AhgO5qhP8VjCOGkOiX/8FxSaoCYzp/6/ixsBOYigaKP7tFI4bJn/vSVIdGSDwybO2yijfrk2CzSG5KWQUpodW+xApDTacT5wJPxJPXfteYf7T8iaax6E0hMRMhj5RvFw0wFkWF1QAmWitVjKWEjcxcx/9wdy1UTZpC7HvwzeNXlVfDE/rlgN7qRlSdyvnFHa8JQOFlkbTboxdPTYo3l5FyWqiUTfDxV6AQzua0KL2LJa5/tEPq1ialMFbQHNoQuZV9XB7thTUBixa979RF5X1nCcAyl2GwFI5BAvkvF0ZYm4RxmRzqAplcS176WE7co3Hgd3VvAL3sNM/xHeC4aQdO/4sLcQ525VnBYQv2wwo3ua5oSoTlzqwEpWYsUjfvmLRrXZGXiTYCzvMSpqE6EW/SiQlpagZ1tF1y5Ybjstu61U1PrPrInTlzPOurNBywEqpAw3whfEPd86GhExR65EhKiP3rK/wFTRn8km1xT9NddZpWqo0ugOfQ5Z5pKTMjV3liZVFtEaPKNCLT12s0KTS1ugV9HMcexsh3pRFdnmDHeIhHjAeYn/o/VnSaGimw8FwCGM8zsLH2cZGocC+faAbfE7B95QyeQGmt3djThvj2Ah6zJM39rSA==
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
 include/linux/alloc_tag.h                     | 104 +++++++++---
 include/linux/codetag.h                       |   5 +-
 include/trace/events/alloc_tag.h              | 122 ++++++++++++++
 include/uapi/linux/alloc_tag.h                |  21 ++-
 mm/alloc_tag.c                                | 159 +++++++++++++++++-
 mm/page_alloc.c                               |   4 +-
 mm/percpu.c                                   |  13 +-
 mm/slub.c                                     |   6 +-
 .../alloc_tag/allocinfo_ioctl_test.c          | 113 ++++++++++++-
 11 files changed, 572 insertions(+), 49 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h


base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a
-- 
2.56.0.218.g1ec904b173-goog


