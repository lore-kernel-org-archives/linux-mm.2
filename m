Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5334CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBB66B009F; Fri, 29 May 2026 16:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD396B00A0; Fri, 29 May 2026 16:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC27A6B00A1; Fri, 29 May 2026 16:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1E46B009F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:24:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DBECC15E6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:44 +0000 (UTC)
X-FDA: 84821585688.08.A15B668
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 792CCA0012
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JKO3uwNW;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mTfhntOxmFkuBVIN+P1OGqxgUDuhd3I9XKbqS4UoT2I=;
	b=UXxAxeTOpnvOt3eCpNqDKE1HRUuaCtnNy/+v+KIQH7lKRvE4RUtyAFJgZUshL1UxKniXay
	oYma7q9Un+F5FiYuvG8K216shdxy0TVPz7IKaiyxFjuXkLUq+ESvJf6OZC7UEpwt58RNTW
	/jty8xGLDw5ACUikRBSgm8hdjS8bYXM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JKO3uwNW;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780086282; a=rsa-sha256;
	cv=none;
	b=w0jGyU7U+QZoBD2cBc+iH9C9CyLTyFSlN0v2a7xbMUpoZih0GALCawVl5mnpUUZBMEOcdx
	Il8qJWXIdwq+ibOeAq2CVy2ItXf4wIf8Im9xThtUxdHIXTYWGuUyNA1dDCIQF/J6aFq8C9
	ueU4JiVJ8U3vtamqd4AWbqGmZrphC/Y=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bd9c3b550aso98110435ad.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086281; x=1780691081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mTfhntOxmFkuBVIN+P1OGqxgUDuhd3I9XKbqS4UoT2I=;
        b=JKO3uwNWT+rLKZbyGSga9AgQl5YlZC/x8T+ASe7wALlIBLfDe2RUquCCSV33jpaf0i
         K5sS/uGzxpyjKdwFJl5DWfBrikBpYWqO2EsQ7A5qlBwSnzfleibjCfy/gehAECyM6qua
         KwBUsW8vN6JlO8uaD71+62/VRjVhOtDx4P26DEGF3gUFAZtz6l/BIS51VJT2oYVgGe/T
         9S0Cnv8aEWdnTBRewuuxlz9J3oUTnEML6OQ9TciCfGkbA4M6e/x0IWAmsaJPhjBOxire
         BX/C3aaHJfj/hoZIndl/0vYVFJrrpor4dDAUl0ilxH6Tx3/6SEnC2LzpSzpw6vqh+5J3
         ecfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086281; x=1780691081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mTfhntOxmFkuBVIN+P1OGqxgUDuhd3I9XKbqS4UoT2I=;
        b=KO3EQFZ1MjMqed1m4G77/J9n8cOdQh/hXZoOUOz4jgljoSmchYBrz0kI+lrdDnvTIL
         OPI/FOC34k9GqRkyjbVaMhwu44VNZtQRdGuYq5IpgAro0edbuwUwkYJWvflI6RUFOfGq
         I+lzmckL0sOR83Sugxmb3U396Q+U7tWVCkYCu8Cnduh5KossA8M1gzz+KxtjMPKo8fQE
         O22j85vKykBjsZrkkH92+htQ4Bs6QzFTgwtWyZuMPgDRvjcsA96yD4KfwC7/x3oYEqWF
         BxizQRnQ08Mc37Z24zI9O1DGqA/o3lyEFQGEhKugeBrORoSnm9rdi8p4gBIORhvtT7JS
         w3PQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Mg9+S2EUy0E3KePnfQXfXfXXRcRrDhlMnTe2JlDk18WOCCq8kof1Zy62+t8Ff/vwZUOX+vt2KEQ==@kvack.org
X-Gm-Message-State: AOJu0Ywmm6Iy/2p0U01GAA9gwnixiL/RM3z9YLQHcmBOEyIP/UICfmjQ
	Jn5cRSvSrtCS33GHqc/61sxzpiYwBiVufytNuUMAWJP5nHjvd2CWsrd9
X-Gm-Gg: Acq92OHQB/V/1Ss9iF8EA2FkPsg9jWsD+ZUTAMRDWo4rF1C2A/LZnsJXZSUZ3vDpJOx
	JJ3JphRm+GpF5sarNCC1T2YFb6pN2r3QB+xQqWueRgzfhEjOBaglCjeZa9oVPK5x2jie2o5uKVy
	+0Z9idnM2XPnpsetuzSwdKuDOgGAJBSBNFy+KRWdLiy3/YZAgsqH/hj0XrpkMSaMrjAwTfsPNeU
	yTGcmbX3XNaoPC7HznwXgBz4nwzHti8jZLntvJn42bjwBRUSRqyqtdS2zRvCrbPd1ukty2uxH77
	mD/r/Dk30vJU7ojCtU9eLcaujwTGZv2jVeQOIvkyxFizJSuLFBR1QAzY01VmtBVJMNJ4HVSdMHS
	m6+SCkYV1mLnrhtJ29MvgnzrI2oUnAUZQObC8tJu0ODQDyoV+RB/qvJpcSg/24DcPt+bfV+yrGy
	jJrrhy6YmFi6iOx6eonF6EwTr7fzxp4EEUsnRZM9ehggIVhac8d+6Y23ZKzsQS+cCSb8rlO9UC/
	poBCuku2iY+rLlEycS1zInckTPFGTPv7MkTzWr3GLKs141x6M4ZHOJGUIrgMP4P8iVY4gOG
X-Received: by 2002:a17:902:e74d:b0:2bf:28e3:a5e7 with SMTP id d9443c01a7336-2bf36793522mr15387015ad.6.1780086281172;
        Fri, 29 May 2026 13:24:41 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e6fe9sm27740905ad.2.2026.05.29.13.24.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 13:24:40 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	david@kernel.org,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	peterz@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH bpf-next 0/4] bpf,slab: Introduce bpf_arena_alloc() kfuncs
Date: Fri, 29 May 2026 13:24:33 -0700
Message-ID: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e9676xefjkgfxiww7fbxhr4h5tgybogf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 792CCA0012
X-HE-Tag: 1780086282-323261
X-HE-Meta: U2FsdGVkX1+7nkDHJS+uZMjWkENvcRMWNvHp2Ou/LH5PAOCwq48luJ3fW7T/jf73WGjxJEM9zEPkvBTrdbyYGW2g9d0vMWHN+tbREeuHaekAqQv9bg36ZuMt60j8aU0O8d/AE9ej/N0/KzDyT3ey0Khp2AQ9vVQ3IIDCfQIpoDPREv3qTQ9M7jb4G+SHPFKb5spQRGUXatsTjxHj9VS6QLGKV40qYya9ce2WHLtPg4oO2iy/CVxk4fHVd7cWZ58RyynGAoo4s6X+IV27NZ/HgVYMqGtpg+0sIPTdJ7gCcf9RaNHotTfyXKmVG15YU7OxbKB2MNHmzbVmBpRLmTWET+qEEZvvKBizHbQvADvyVR4ywFrZLlAlhqVK2kvkZuarsU56Yw1YxtHDQ2PYL7fv6izETpMNlPvADO6SZ5XDDK3m6mSOhyn0dfwpSoOzzDcx4Nxs1NvP5zJIV2npA4skATsdcG5eD2zcOXZKfWgTFQZams9Dho33ySqqWHcT5qHsNWpTzsW2x4iSq5wkXeMstuCNZm8b70QFYA6bBFUMOMvMm+cmlRBydamDEjwQHrXwldOjReIKNhCp8dEhuKGQxKtrko3XK17nOG+Ex9zKUo+CL9OZr3NOfY55Ag8ElXZZ+9bM5wM7E8yxvD7Iw8XRsJqVNlKHYmywDO7lRUCv/gQHQ2vlElZLrU7Vizq1T4wSVcz2iX5p+Do/Ho433T1hfpSh8uXiSSzqKPgfFpqIYSPZ0uc0WwIeCaOW3uqTwHBcXin0v7jfwKzalFyxAM8FARf5gz3Xu2pbnQP1MHgUA3oeL13HkN3p5f1QL15OmXABVPShhEdgbL+EIFygKus+u71ywn3qrzyUTN5WXv6DLsLKHHL2kX87ML9n/UdiOOTMnvJiE9T//WD8/ClfuQYLPBvEN98pLuqXXiApY2nOaTrBcyqrMYWsMDnOwX67Yt1DB/Y4JV56Bg2wjpIUJM0
 vyRbmy2n
 OoMSB9xkMfIz4fB6mki2yP8J3x43yQY3mXQv768hS3TmdqTMR6gn7zaCGLG506erH16sg4fqpXAFHyisy/4lUk+n/8k64/Bo7RWbjBNy2DXL643C8flSr9YsRC0l4j2kVhh2svKQsfoD/B2FWa0SvMfEHogORVfqUjCDAQyIyQm+XBMI/hUIB/j3iH22OBhHhyMnALYL4xlsUffslqrhI1REHpSJLCTfE88se9jk+4i46mGuD3q97w8fKF79wBeKXhKZlqX9KLtKOkUXw6ZGfcp9G/qmmzmBXfS4WdPLdOew0YNhyRrSD7QtUGiwqWOhZ5ThnfbrBSiENzfFjRN8kb1lTMNg9R/6J54+CzNgwGsUHKEIzUBNvSFrSgz3oXNlUA9vsHXgCb1EokhfzrxaJBBiMrZFUdgFr3i56QsDt/YafVVx9dv0DlzfYTPFSNv29kPh5ZZuu2Rip9VfYQrnHKa23mS/NsvtI4tEeSxmPhv7DBmJRZEzuSIU8Bd1d9RMzRMNyXKk6/FfWUup9OTJExII+IEbJQ57FP8hA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Let BPF programs and kernel allocate objects in bpf arena via
kvmalloc-style API: bpf_arena_alloc() kfunc.

Currently sched-ext BPF programs implement various allocators
as BPF programs on top of bpf_arena_alloc_pages() kfunc. 
This is inefficient.

Recently sched-ext kernel core introduced scx_arena_alloc() backed
by gen_pool_alloc() to allocate arena memory too.
This is also inefficient and gen_pool_alloc() is not fast enough.

Hence adopt sheaves and slub as allocator.
See patch 3 for algorithm details.

Alexei Starovoitov (4):
  slab: Introduce kmem_cache_alloc_nolock()
  slub: Pass kmem_cache to alloc_slab_page()
  bpf,slab: Add slub-backed allocator for bpf_arena
  selftests/bpf: Add tests for arena slub-backed allocator

 include/linux/bpf_defs.h                      |  13 +
 include/linux/slab.h                          |  27 ++
 kernel/bpf/Kconfig                            |   3 +
 kernel/bpf/arena.c                            | 366 +++++++++++++++++-
 mm/slab.h                                     |   6 +-
 mm/slab_common.c                              |   2 +-
 mm/slub.c                                     | 201 +++++++++-
 .../selftests/bpf/prog_tests/arena_slab.c     |  59 +++
 .../prog_tests/arena_slab_freeptr_stale_pcs.c |  28 ++
 .../testing/selftests/bpf/progs/arena_slab.c  | 179 +++++++++
 .../bpf/progs/arena_slab_freeptr_stale_pcs.c  | 120 ++++++
 11 files changed, 977 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arena_slab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arena_slab_freeptr_stale_pcs.c
 create mode 100644 tools/testing/selftests/bpf/progs/arena_slab.c
 create mode 100644 tools/testing/selftests/bpf/progs/arena_slab_freeptr_stale_pcs.c

-- 
2.53.0-Meta


