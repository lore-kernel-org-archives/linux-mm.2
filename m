Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FE5C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5CA66B00A3; Fri, 11 Sep 2026 15:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D766B00A4; Fri, 11 Sep 2026 15:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C976B00A5; Fri, 11 Sep 2026 15:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7600A6B00A3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:41:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 087251C1E33
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:52 +0000 (UTC)
X-FDA: 85202501664.23.59BB155
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67078140004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bvX1s8QD;
	spf=pass (imf09.hostedemail.com: domain of 3fVmkagYKCB4MOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3fVmkagYKCB4MOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NFnX3s9ttQtORT13US/ARsVw733vFoBxkxITzrUPh78=;
	b=k94C0g8fioGXi6+Bfhc0/kMY0OVrf32ydHrOiPSKRx0GkXBd7Xn5SHvckB1DLOt3hCdNco
	AgDrtGcy82VQ64VALybWIx5yz5D5dKO1q34fDBz5YnI8JCSBLQiRmus1LcYX9i2TYE1qx5
	Um+nDA1xkaMLDxa9UnpsjVxckxQD+UQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155710;
	b=B3yXCr4hijkq1x1zBJZFj65zXcb2QoBP+dHWJFMhMqJokRFRdsSm2m961IOEAuWAkKasbR
	y0RCafBQsImlRHl67bFqjD/ICkK7Zd0Vepjbo6EwSsbVB+atqEV1l/uN1e4589kzxo6Srj
	aQLUQRuNn6uxpRITBAr45DnkknqaKIQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bvX1s8QD;
	spf=pass (imf09.hostedemail.com: domain of 3fVmkagYKCB4MOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3fVmkagYKCB4MOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4b524ce78so1010962a12.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155709; x=1789760509; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NFnX3s9ttQtORT13US/ARsVw733vFoBxkxITzrUPh78=;
        b=bvX1s8QDEuBm9ypudEbq08DVO6BjEeRp50YWbtVNSyLAPcMvRv5LtThF4pkqWDQknu
         dkkUajLDdFDc8EmTorqbXbgEsZcG0RtYTTIXPagSV0K42QUrjsaKz6yrcD/fTBTsCuaP
         x4udZLvlZg5cegM6FZzXBiBNn/4taOVRZj+BlLwx0JZ8PSK46DKvfWOveBjh5LyKVqf8
         7NNPThCewS8dJUKJUB1H9l6i/hMCHF6XDGEnPRliRV3NWXpAf6f3AOQ5R5Z1np7PgdCZ
         bBKC98FS04Bivyz7i0FV0vjxKw4g/21vPEaFIkGkug18rSasegC3y0NPvXtNcmNh5EGq
         HA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155709; x=1789760509;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NFnX3s9ttQtORT13US/ARsVw733vFoBxkxITzrUPh78=;
        b=NyXIl4WhChUahl4y+H7Y14YTPduSWA7AtRZ7KIgce2XY6TmuhC+4LM+bMKbG/Wm0Sj
         9GFhGo0vgdjl5kdXeN90cILaeJ8ZS1hy16rPUhzXrT+PgRcoz6GE0HLkcGRtO2FJQe3V
         hQGM4CdnBaPuuQWj/dvC+/zduVZlghaq5h0OZh5ziFGpcKe+atP2xDCZDeh1vz/k76fD
         r9/Rjz9gc5l2vFM5+hmgapEk8IbCLCJllhvjERjrEZmNdSb+zqIcT25Vudgyf2ffBxD/
         StM56nLxSvo2QuUAgCU9rIQ2RUlSFdkL2rmK8utfJLm9uYkaFzoW2GbqKAYVV7Bedug7
         iijw==
X-Forwarded-Encrypted: i=1; AKwUvBxIfC1v0f+o94EnGV5VuIN0xumTJaKZqADuNJoVd0K9ZYDz9fZPlaP7Zjv9pJxxx2J5m3yV8oFZnw==@kvack.org
X-Gm-Message-State: AFuF++msrv9+ph6okoipu6GMLhs5lPUf82MdZ73h0tdXTKVjGhv4/BIf
	zq3zjxxt3TK2eKBPQdJxfObr2dzIVU0tQFtEV6BkLr9zHUpKq3Xhy8QUlSabHNI3Q5VXJ+lLgpw
	ScMfJBg==
X-Received: from dld34.prod.google.com ([2002:a05:7022:322:b0:141:6ffa:3579])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3391:b0:3cc:b26a:7686
 with SMTP id adf61e73a8af0-3daed1515f5mr11763572637.6.1789155709034; Fri, 11
 Sep 2026 12:41:49 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-1-surenb@google.com>
Subject: [PATCH v4 0/7] read proc/pid/smaps_rollup under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67078140004
X-Stat-Signature: ddatyygawmjj6ako7upcd1oqf839rnd5
X-Rspam-User: 
X-HE-Tag: 1789155710-532613
X-HE-Meta: U2FsdGVkX1/UeZTkaNZOd4ehuFuZYbxzwRbpIUhA78BSWkWPaEMAd34zkWv6X89nZZQnEoRaI9EjZYIsew1VcrHAemYGuSae05m9In8iINWmYtV87z3mB/2bIlHsxEqIYvIaxzGN0lITVDh4zY5hU7xQLD1SLiK2zfw0iqbqgY6bj1vSSxEOx5nPb4M2SCmn7YHPplRiBeKjISkykCO0XTx6a7W5d09mvIhqzCgCvh0SDSVy6b89TZia5dVcJczb9jH05Mp9mzUpBiHeIXILizra/WXgHyCS47o8M/weSz1Ld4/3WSD2UVayFbYiJ2ZXtzAH9JPgLUjg359P/3SqH9YHh6rgWsdXxwMWwdZDdcjp8SGwGPHkZWZgz7z87hPkMmW+eyw5m6R5KfoJY6UWDAkoH/trqdUvGLKjWl1YAYVjEbv+Hnl66NaddTHwdI3zjk4scFWAphPpDwiY8F5dmVjkGEzwqB1yQSGSZh7lsoLTn3Ib/SmrFSoVop2v5FlR3Cuvrcbzf4qR+ZSU5xbE3klGcTi+gLHOtU3ipEk4y1CA6KnovMCmXLyb8wn+WnFkN2l9BP0/jCiyXBjCP0llCg0ttuUOZ6y3Mj6iFKrOd58RD+6fAthv1wltkYvKZhSk8Nx0hdePbp6N2IOBmneDDkErTy9G9SmeUNdWOz9VcY4hYGYzBMcFbVynUhw2NnE2FKHH/13xt12Zmv6tHiFhJUZEFXhcaItAWyVAO+DMZoRR6oQZogG3tHzbg+T2CNzYY2mweqKX/NoIWq/ostEPp2NGLUJeRH+3SVfGuWNxdaQivsWzbUC8oRciipxpx/S8sRd55FmbMiqrnBgEY6cYRQ6VwnSFR/GqovBrGRjz6kPfWHulyRwjUcq2dQZpMzReWt3kuektSUKlI4RlG73C05cAYgjSFQANfbPs9ozxr3GTN5tNwttkBpfLJ7+BFbGSZkNaQ69KItlEhdj/mP1
 ttH4veSe
 Jn8dlYllxE5PJWMms30xWvb2L3UbYjnQFgh9UQXwNbsSbzhI6kFqTiBmNWGPDVQYYBjZp2GfP+bUEi4GVyPE+l+nuTdiFKmPVV0ERNCi8/G6ZzmMOdxxF6AM45rOufTbFDPMqYFdRhx8uDDqhdI+c/+T/fxtSFkdg4yWi6UipJX+MAhZqsrPp7Cj/qLpiNzh5/F7qYiKblLJE/vBZEp/H71nHN07YXPwc5N9soNwflJ/jSrFGx6sYQKPQyv7SfyZSIrSP5+nc4Z5uLpMXShI4lUvUwapqA25+vCjHBBbl5rNyNSY1nzQYUdyge3Tv3MPQuYjl2kNB6R0DcueaJImwU4WF0bRJH46gvZx2R8YFmt6soNSTP5YqYXqMq+ItTMSN3pv1+EPY0lvVz21eJBYFj1d7xgTKzSItoCvnVtt1Sn0Qmn0xyF/hlD/bSnuEVq/pbPzn7RsHkqD8yR9CBnSazyb0BGYbXZhJmjQvepwFOWgzsgWindBxONHs4YU2poxfHR4LlIYeEmCVwMkc75kAkSyPbM81tbIV4Kc/QKzN7kBe6yfDpTDn1n6xboO3YCSb/zMxZTVeX5URMSdAldsqf1UGOH9kviGdCx76+qnJP0eeodofFx070ltUiAacoJXsZnXqnZbwVEmqEEKj29tAgr+wg61/X8vx6DEljj+zuCNel4ZFBA46XTW4UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc/pid/smaps_rollup can be read using the combination of RCU and
VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
required to safely traverse the VMA tree and VMA lock stabilizes the
VMA being processed and the pagetable walk.
Note that we have to keep the logic to drop mmap_lock on contention
because even when using per-VMA locks we might have to fall back to
holding the mmap_lock.

The first 5 patches are cleanups making later change simpler. The main
change is in patch 6. Patch 7 extends existing proc-maps-race tearing
test to verify smaps_rollup content.

Changes since v3 [1]:
Patch 2:
- Added Acked-by, per David Hildenbrand
Patch 3:
- Moved conversion of (start != 0) to is_partial into the next patch,
  per Lorenzo Stoakes
Patch 4:
- Moved conversion of (start != 0) to is_partial into the next patch,
  per Lorenzo Stoakes
- Converted multiple lines of arguments in modified functions to
  two-tab indents, per David Hildenbrand
- Introduced smap_gather_stats_range() for partial VMA walks,
  per Lorenzo Stoakes
Patch 5:
- Added Reviewed-by and Acked-by, per David Hildenbrand and
  Lorenzo Stoakes
- Added a comment explaining the check for SENTINEL_VMA_GATE in m_start,
  per Lorenzo Stoakes
Patch 6:
- Added Reviewed-by, per Lorenzo Stoakes
Patch 7:
- Converted multiple lines of arguments in modified functions to
  two-tab indents
- Added Acked-by, per Lorenzo Stoakes

[1] https://lore.kernel.org/all/20260910234737.1340642-1-surenb@google.com/

Patchset applies over mm-new branch.

Suren Baghdasaryan (7):
  proc/task_mmu: remove unnecessary helpers
  proc/task_mmu: remove unnecessary inlines in function definitions
  proc/task_mmu: clarify shmem mapping walk conditions in
    smap_gather_stats()
  proc/task_mmu: remove special-casing of smap_gather_stats() start
    parameter
  proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the
    end
  proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
  selftests/proc: add /proc/pid/smaps_rollup tearing tests

 fs/proc/task_mmu.c                            | 339 ++++++++----------
 tools/testing/selftests/proc/proc-maps-race.c | 186 +++++++++-
 2 files changed, 334 insertions(+), 191 deletions(-)


base-commit: 1f78f28a2945f9e856b4ea8428ac41a6788e4b67
-- 
2.55.0.1007.g17ff1f9808-goog


