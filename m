Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C47EC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01686B0096; Fri,  8 Aug 2025 11:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8916B0099; Fri,  8 Aug 2025 11:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15696B009B; Fri,  8 Aug 2025 11:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91C826B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:28:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 407A1812E6
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:28:56 +0000 (UTC)
X-FDA: 83753973072.02.1C80E9F
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 78E2B4000A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:28:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IeoT6sNi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3tReWaAYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3tReWaAYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754666934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZGoPBcCcngLqfzu/WDHEZzT30X9O02KREgicG74Nsi0=;
	b=J2d68j3E/Zli7atJcU8mb9TrqDwGY6nsTM7nr3C4s63V+62jxHjmWZkKdawRBK5ic1fhWw
	2OSMhhxLANUIemC9lSBX0OiLaBgYiWHDJL0epXNGdOsyAZ8EAg49QUBiT25QyosKzbmVYp
	Ub6cWlhuZoAo8zn38Z+47bDdyNogVRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754666934; a=rsa-sha256;
	cv=none;
	b=wgJwqMmjHk0P+BHeFiI3OLqAqHZeRPEENP4qDfiU36Pt8dhSGdSpHu4/eNjQpdG5gF+5Ki
	wWtJyG8LRUMHK2Y0BZg/lFWlAweynJyKYDg15OJ7ES9XoykRvij/SocTsZ7wnh4vsgR/+U
	uEGwx5lpt2BuzB1Wyd+eCclEXjOVe2c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IeoT6sNi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3tReWaAYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3tReWaAYKCIg463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31ca4b6a8eso1717687a12.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 08:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754666933; x=1755271733; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZGoPBcCcngLqfzu/WDHEZzT30X9O02KREgicG74Nsi0=;
        b=IeoT6sNiafPfXfINQ4uzVARomzHX+amgmEChw5UDhHLZGQTBgRwnxnWTBucPTmrk+F
         tXGD316J1xPSHxoGecAQ61TLKmh1fb7brgqKyMoVaGgXWlXToWQNdsKoKtJ2Q+Dq/MTZ
         LYewv3Vu8A11boUrZgVcqBDldRjjOTCLw3On5JvG1aK1q3dcx2he+htnpdTi4GSlZ3rN
         lZeft/dR0G6HWdo2ARYr5qroR3iET5b2UO751XmXjTZddeBrPxQRdsURciL27OiNf4/p
         AQfeks49mPBT4W40Ujui4ImiaScoh3NC5nlWB6E6xMsmnv1hhk39CG48jgMH88Y47lro
         36yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754666933; x=1755271733;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZGoPBcCcngLqfzu/WDHEZzT30X9O02KREgicG74Nsi0=;
        b=jCWZ0THnbnBuFLjziYhCvE9T5zvrk0PnZjUxLevn/zWgNuoxT5imwxsBeScB+Hmz2j
         WmfyXVZWGeGvc7L2P/AJuGw4ruvSktALHGG0gAa+rCDztIUVbbPhC9Zb6k6KoLNgdsSN
         dvF6yBA4GbUdrvfFhtBxT2Z9//E/v7WB4svkrIhhPqBx7JXtVDscJS3qdinUEIXVR+Sd
         MojUMfkyeZN7AC1swAFYc59DXABKpSzLlX6A5dDHxg6v5U86Cvz2+pjsLV76uvi1cAhH
         Gs7KcUh52L2cW3wFv0fyjJ2cwF/049/ysLq6Q/VfbM/F7s1f9QcmgO8KhCs4txgqu4+X
         P0tw==
X-Forwarded-Encrypted: i=1; AJvYcCUTwGuHxt9H78zw5Z0vo9tcP9VKsd3r8NFRom0IV56Vqz04S70BuiOsKToh5Zo3bYN/tack4J70IQ==@kvack.org
X-Gm-Message-State: AOJu0YyX5IQTPVjtRxVpZK2Ov9uPK8GAbFlfD0xkmnahfn8UrGHb43l+
	MuvdgmdKC8yKXhDV5iYDyykv7W9+Br69f3IC1aDCPwAHJk+hd/26B26xf0UY2ZoUV+l3JcnOaJE
	Tqkrqrw==
X-Google-Smtp-Source: AGHT+IELDzzPgMm+39UaZJjm8Tn8NXpoMJEAAaRaanTag6m6o3qi4t1yNnmGCams/nVAxvB7CcmtNDxM1x4=
X-Received: from plbm13.prod.google.com ([2002:a17:902:d18d:b0:234:b2bd:b68f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bd0:b0:240:66ff:b253
 with SMTP id d9443c01a7336-242c222c21bmr56641595ad.46.1754666933115; Fri, 08
 Aug 2025 08:28:53 -0700 (PDT)
Date: Fri,  8 Aug 2025 08:28:46 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250808152850.2580887-1-surenb@google.com>
Subject: [PATCH v4 0/3]  execute PROCMAP_QUERY ioctl under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 78E2B4000A
X-Stat-Signature: br5hb14xf1kph3wy147qiq439x83f8eh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754666934-748298
X-HE-Meta: U2FsdGVkX1/axq6lWKIvxbipHyaVUtq4DeUyPQcx/mrP/X6+5dpJPkIDuJZIzPw4inYZUjBmG8sfwr6ZG+VGuDv8IK8rxoYLICG71xGpiitkM2rADfykZtbR0qfkls1DLgB5v+tUGj+76+E9vWbKv8ETDtFm4Yekxa1W7e2KcRH5zJz/N/aAXwjpcO64qFfoZuYyuW9hxlXXA5lwFt3nnsEGx6kj5Y5YBwB/u8yNcpBfVhCkjPLhS9sRniZDGkFr2PB3mNrvPoS1wqH/zLsX6x5GvfwoCOZ44Lrj3fFUixc5zG6jMREXPdkaWmaTkDnwoxdEbgeRmlXuSlArT6Jkpxd63uGul6hKo0xKZBLHwfCUogots7uwIlqCV0fqmwmk2HKFhScJLjE4csTZymLahokrYUKpBBlcV+9amWlkwXdnojT054dq+QucDntFIAhIZqCODrv1UjGHwLcftvRqvTYrdoxbrC13GjgP2OiY4+Ga00D9b37qa3poZB3YYf2lu3cp1TXX+00+2J+O+YBKlRQQpiKZeUUPqX5YBheqcagxUSlmZE756Wm+aeHvJ+/0IM1X4tRPQWm/EYvJzpp3VUYtdKXDKQyHWYz1ASBgdW8Abmnq0bmE3HDuuv/j8UKq4LDwoedHBpaehJxa9ySPDN8Ys1FKCD0PJrt27+nq1CX2tcijDa47Q2e4VWaQlnWRTZxNfpad38Ofd5CGQACFD+oRY038Pi/XxqVY5FMHHyrkG1ba6yOJMi5bYBUqTfCBQ8G4urZ5wz2G336LJnVdZTn/X3gdCHDJ+Yy2Esc61C2IqJFgchTSlKoxD76EbniPertKQ1lNIlDKA5486O3sEe0XsjmceHF8DIHNjmwurfNJgEoMzqqd18qpnSAXbEDzrbBA2DcdG+jXqoN3Z//seQaHEnCGeaOGgHRqqtAcfYtJbZ/HVpZ6Bs0Wf6QvKv7jRcP1Nc6UXzT0oYvqYWR
 S+FCWyfL
 fkv78YHyTlKzMSS/ca/tOtU+LjNnZCTW97LYsKxWTr00hbwpmCkVehjSHyCaeyIVDmmLfTTV0M+cYMUJl70oBPT1CWdkLp+2G+ybFwIYJUMrgrLM/pxnj4VuER5uMT6v9ENk8D9Ftz+dV4b9TfJNElUwalSrieYQZfEr+3w1WK+uYvqhuBruhCY1kzh70p6CpA9ClgLUJOucl3U83OX11Fnpv6DN2qvaSTD5k3TcR7SHR2adkNvSewkRcmSxLzYi1Uv5lgkidoLk3Xp6NU40PuAZz/qPZaYLAAGAbH00gpbI9Eh//GVmB8Q2K1NWhQ7f0sn5QpzejzpXDyDgvrvtVVekBgLr3cVTvFgqSGxZWyrhkLg2i/K6ia/hi4l4VjlDRuc8roGhxk+WMv10kPsqfR8arQRR9CUDdCuuFaAybnLaHhpVuel5QyiLu0KozqEP1lfVu4zJdqRScc08e33LNEMcdP7bJ3a5vQ4rPMDDvBKKDHUGupByrgl5iXrOvH8EApwTi0WQFGqx5fvT4WgIADSNjVW1IhTKrPxnLCmM1hjF7FSNDWNIlhu88uKKVHRPD5deWVVi8pyf4l3/OSUN4Oar3pzXLbZ2p/+BtYw25qO1ouyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With /proc/pid/maps now being read under per-vma lock protection we can
reuse parts of that code to execute PROCMAP_QUERY ioctl also without
taking mmap_lock. The change is designed to reduce mmap_lock contention
and prevent PROCMAP_QUERY ioctl calls from blocking address space updates.

This patchset was split out of the original patchset [1] that introduced
per-vma lock usage for /proc/pid/maps reading. It contains PROCMAP_QUERY
tests, code refactoring patch to simplify the main change and the actual
transition to per-vma lock.

Changes since v3 [2]
- change lock_vma_range()/unlock_vma_range() parameters,
per Lorenzo Stoakes
- minimize priv->lock_ctx dereferences by storing it in a local variable,
per Lorenzo Stoakes
- rename unlock_vma to unlock_ctx_vma, per Lorenzo Stoakes
- factored out reset_lock_ctx(), per Lorenzo Stoakes
- reset lock_ctx->mmap_locked inside query_vma_teardown(),
per Lorenzo Stoakes
- add clarifying comments in query_vma_find_by_addr() and
procfs_procmap_ioctl(), per Lorenzo Stoakes
- refactored error handling code inside query_vma_find_by_addr(),
per Lorenzo Stoakes
- add Acked-by as changes were cosmetic, per SeongJae Park

[1] https://lore.kernel.org/all/20250704060727.724817-1-surenb@google.com/
[2] https://lore.kernel.org/all/20250806155905.824388-1-surenb@google.com/

Suren Baghdasaryan (3):
  selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently
    modified
  fs/proc/task_mmu: factor out proc_maps_private fields used by
    PROCMAP_QUERY
  fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks

 fs/proc/internal.h                            |  15 +-
 fs/proc/task_mmu.c                            | 184 ++++++++++++------
 fs/proc/task_nommu.c                          |  14 +-
 tools/testing/selftests/proc/proc-maps-race.c |  65 +++++++
 4 files changed, 210 insertions(+), 68 deletions(-)


base-commit: c2144e09b922d422346a44d72b674bf61dbd84c0
-- 
2.50.1.703.g449372360f-goog


