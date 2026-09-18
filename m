Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC770C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6C26B0096; Fri, 18 Sep 2026 11:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD156B0098; Fri, 18 Sep 2026 11:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3AD6B0099; Fri, 18 Sep 2026 11:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38B196B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 542DEA0716
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:24 +0000 (UTC)
X-FDA: 85227277128.05.9DB7DED
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9EFA2140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pr8gvJ8B;
	spf=pass (imf09.hostedemail.com: domain of 3wVmtagYKCIY241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3wVmtagYKCIY241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3o3afKIhDxvUwFzaGiZkLeSCGdh09AvtFvmwbyAEPcg=;
	b=dnDhnYcEkAc/Uz8HMtMXT1bAStSnAy/WHeo3wTEKWOXmSjLh7VUhGBEgOK90zmpJzhNHGI
	9mbDIdfXu9o1w1vFtpJP88RHQMoogYSzyRM4u3rRG2OIVFCv4Rsys0281dVKR1IEBuAESz
	M4lBiOEhLlz2oE9iwILlbwILkfIlpEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745602;
	b=v0mSmdhS01piIQP2gyRhnYor7yHK5YVgeHUaWlP/SjLcWFrC1pUjnVa7E82fJfHbamMQJz
	bT1KWW5QiRe1cBNHQgIb9aHkw1qhW1IX0Pznr6LkwzPGfouX0B0a8CCeyHnwyKnPsJYfJg
	VIlV6+33s9Ww0F3gwUSRLRWtrshdKRg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pr8gvJ8B;
	spf=pass (imf09.hostedemail.com: domain of 3wVmtagYKCIY241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3wVmtagYKCIY241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6f80c76e6so17884275ad.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745601; x=1790350401; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3o3afKIhDxvUwFzaGiZkLeSCGdh09AvtFvmwbyAEPcg=;
        b=Pr8gvJ8BzbxAH54lcS9ZA6fd6xETauYLDbE009T882Z8nh/0negSXT/E9LJcY3N13y
         Pb5VMBLzKvLOjGCopE0ID+oDJ3ZTKF4BFlJvRI4EklJTCpweOqGeBu7EHZV4UxLpoz6b
         rHLXaZnlSMgELP5dtbfJqkT6eEi59n8scrKGwCVGqCqu36GowFBNznK1y/v4T7nW4ssR
         3wg0S5TYWSEvir1PG6kIQ/Q+DneCN6dvc5nZqzYVdCu3pI5+DOTPk9XiwAu+/7M/0Myp
         V/h9imbgBmHFbpYZo9YRjERf6fWD/V8MoEEHIJRQpP7lTplihUBnMkTuW0tg/Z1KGGpy
         tQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745601; x=1790350401;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3o3afKIhDxvUwFzaGiZkLeSCGdh09AvtFvmwbyAEPcg=;
        b=YfAkeAqKA+4z878FKSwrLnNv1yo+fnl7fBPvTBTdrYIG66izrBOja/vXcc37/nFYfS
         qsnMH05laXqXAfk2GuaFAhxLdjt6u612PDn7ZR43/NYnul/4uq8HDid9QNjdg0F3dQNH
         5v6JEacRu0OxcFXPGhJxgVLHeEJHtBhLv1y516A2ovLtsS/qrkfRyHNLyizFnTHLwus0
         986HztOoq9vII+sslWgUBreOxwvTJTw0ZLhWwgft0gY9ij86e63HXoh70bze6eSCUimA
         wqN+iWzC14LWXDb2sSAVbmQGYNwShhxJBslbkEH0Z5lCqrQZ/MxvGeYkXyetQTtrHSVQ
         31KQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzA31opmbMnN9KInu2li3Uc6f/lfC7S6bHwdL0ZgWz7toMRxQom+zKj+EFY2PAERPfzheLmXMJAA==@kvack.org
X-Gm-Message-State: AFuF++lOTijgH/cGzzhna7GfPrkt5PQTcdS2ZVBwo7qXpHzazU2zy/pb
	pkySAqAdm9iQ0zc7ycRFh89VaenKQqCLrKzeKrR8MyAd+4WektZth+cRszVsf2XH8RFI6cUi8N5
	lUf5LYQ==
X-Received: from pldu4.prod.google.com ([2002:a17:903:1084:b0:2dd:24d6:a74e])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:a9cb:b0:2dd:c053:e668
 with SMTP id d9443c01a7336-2ddc053e68amr2809575ad.46.1789745601208; Fri, 18
 Sep 2026 08:33:21 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:11 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-1-surenb@google.com>
Subject: [PATCH v5 0/7] read proc/pid/smaps_rollup under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9EFA2140004
X-Stat-Signature: 7eqh3hp99839qgmhdyqotd9mriug4xhk
X-Rspam-User: 
X-HE-Tag: 1789745602-231783
X-HE-Meta: U2FsdGVkX19fwf88ngfb5+JcKy72Lck3f1EvF/oe5zy9MbxmM9Dk7Uk43hGdJZbS9wUx61WXhxTo6YAfpSqL4q8sTWcNOj1oCnTGG/jf1cbpjAr84SAM9mNXAUWxUACclMwDNcrnNWBYlJhlTs+3jAMgdBpWgPDHdDaIKhs/JLa+Uoqn2UHFDHbhNx5UDTD95ZbFCWFPAsOB8aPztfivonW6hTLaPsMTwxrMHfIaQ1t4bw9Q3MwJW+x6CWXefwoWwUMVI70bbr0eG00hsHqgaAPPPS/Sl/LsgfFD+wHUKw6zg6EYN7ls4hXke/q9fi+pATKXdbfQ1UCkZaS+oW5d2WwJ7M+kjh/U2PDOV/neMTiC5qsJPbgJqvp2sjmW/dkKZb2uklSd40q/Ra6JIivjoY7S9LJ8i+aClXnJRLVv5Jfow8kb5ZxCQxzMnWYkD/NhFrELyP+p7bKuB2somxZfOoSBupujTSIx0wa7GcFR/68SqGek9VJf7++oYsqiuDOso8tyF2QoySIrHWDLAJyJCdUs57FUUVM9T0F5D2pzQsf+nZIGSBOnnPpAraZaE4x3Iqm7GIsQAB3GONO3J9WZ5mkQy7r0c7vSFSg/SgpXD3ifBoYwEc1PKrePuB/+is0Ng2FNRGgBIKsIER0vjAZla3DQp0Kh2uNvyIOr0SZaZjBkvnPiH4OoyMgLHp1rrdKH+eA/Yr8NBFU0lGH7UbNBRMxV0Zt+PpTDYTUD8ZufgtOAkxQL+3eReiJ2zm6UnBzoE1Wyw3OKwqcQ2WmbehvypPM65PWosBjjiZ5X7nYklI2w4wVIOjNvmxtJ6eZ90P1bb+K5pR86EQOTYuBDSbqpTv+AJwpUsb7JcAuG2/lEo62hk65sf7q9hu8RIDqpTtLmKUWrgAFO4w9tqnQhJHHYdSpdZBfudGttngEqct1M01zqhYnfce348DdlrI+RAw0IwaSFOpC5CiTG5RbbHj0
 5BNrquQk
 7fgHfThJLCwTaiFmN6OwbZ/vyadJpEUO1wvCx+cYChaN7BJzjr8L/ljldeUUAU9GftyVdCXBIvq3knYPfDJcRzkIlh6z98N8uynUtqMku+6lYkRHiY23PPI0l4/gC7P/bcXXSVmNvefI5fl6KccpO3CosAFAf8dr1cwzaVKC35IJWZP3WSO6KY4Cl7ahQt/31x4r6ipUMVHwYG8eiVLopWDxI1xdFZAWqkrVhrW3L5t2IFej0+Nssb5EgsyREbzqaxwblaaIG+2qyUzqLBmUtCdmv4NPyUSUgkbj7SKYxVnD1x5RLQb9xCMwSIGKdQvAJXbgNl0zIV10ilgNRXc6U1D2IT+XD0/YIIPvDoIyU46mX+IaxyvMAgB1xbxAYUjOvL0JUw0y0+VLC7049CYrt84ICGmJl2HPW+a+UGEiQa0Ip7+vcpJZipyI4kALzg0yQ26DPblFs8ql/vL6KpmsiCsWHTW5Fk0aRlRoOLTnmnKNtugO+HCfJ/Olo83+qqx3867N2YXyQwsLc26/kPE/lq2BpBfxUrL2VhJTNbbWxPMwAQwt2iXG6DcoO4a3w5z1kspxMxlQdIpNURFEc5F3zHaGo0TQr1rQjE/vR5S1OwuBrR3COzPMKehAC6yQp9n9aCwvK1fV4tRyQEEc+MOMnQlCbgz/DJqOSHkuYqhHx3hULLgNWmo9ZA7Bl8Q==
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

Changes since v4 [1]:
Patch 2:
- Fixed warnings with CONFIG_PROC_PAGE_MONITOR=n
- Fixed a typo in the changelog
Patch 3:
- Add Reviewed-by and Acked-by, per Lorenzo Stoakes and
  David Hildenbrand
Patch 3:
- Add Reviewed-by and Acked-by, per Lorenzo Stoakes and
  David Hildenbrand

[1] https://lore.kernel.org/all/20260911194145.1781926-1-surenb@google.com/

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

 fs/proc/task_mmu.c                            | 341 ++++++++----------
 tools/testing/selftests/proc/proc-maps-race.c | 186 +++++++++-
 2 files changed, 336 insertions(+), 191 deletions(-)


base-commit: 854157fc9d011b8dd5a1a86a237447e28d681eb9
-- 
2.55.0.1082.g2b9226bbc0-goog


