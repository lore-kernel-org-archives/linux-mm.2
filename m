Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8F5C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3822B6B00A0; Mon,  7 Sep 2026 02:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332AF6B00A1; Mon,  7 Sep 2026 02:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A056B00A3; Mon,  7 Sep 2026 02:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECED06B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:39:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40B11C066C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:25 +0000 (UTC)
X-FDA: 85186014690.24.F907EBC
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9946440004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WIIKd3S6;
	spf=pass (imf11.hostedemail.com: domain of 3GlyeagYKCKcZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3GlyeagYKCKcZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dm0sPp817ea+YIVgxkakoV5ujQpRM5ozgV+CKpT59+U=;
	b=kNQJTcPAfUQilVqPYzk2ITmckzskT1ja9wz2fonK8zoXG7hLzXdLFyUg+EXI6zQ8oq5+r+
	3/x2ob9MKiz2gzUHghsXvdRJQXExsFunXOLV6gyo6BWDwuanYJ9UIVVS6IiS+Y5HixAgVh
	Ov1uZNr2n7/8DWu+1DhMeY5cj5BI8rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763163;
	b=Bi/8nqJAezFTZN+x972ullO9/haKW/tyUwBsTo6ZlXlpZUzwiCGtnxE030UuF99Ecf0csB
	F5fY4NaGJdQVMAQne+B1xmOfFI3ZbXVe0/aCVM9TMLKFdFx778vX7jMQk2q/TY3a3h3vjV
	XKcV+u0KSisj0Vl1izzyHYCVL8UW39s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WIIKd3S6;
	spf=pass (imf11.hostedemail.com: domain of 3GlyeagYKCKcZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3GlyeagYKCKcZbYLUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c856470fe9fso2878014a12.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788763162; x=1789367962; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dm0sPp817ea+YIVgxkakoV5ujQpRM5ozgV+CKpT59+U=;
        b=WIIKd3S6/Sk31QDoIW8gqNp0ceRqPbR9D4m10fpEdrb/hpor+CrIJPxztWdBvhmsC1
         HdwlWTK8xZTh4SwtFaTxusNekDUV7v0Ks1uGl3exMz2wSFdrRRpxRe17EM4n9UZRyzAC
         AkjiTkzJz3ayTYHD0tY73/bxYFyJB185vIoNlqQSxK/5J1bhAf9Joavqr9kCRVXtB9e2
         TSOYPeqte291fSWVKMM0W46UmCH8iJdOppcq0eA7LDKIuf/S8WiuLFpOOLf3ByNN/ZB3
         H5nwW27g3OwxuQnSwn4OlXAwpwXAbrZfYxmfCfVzBusaHf/Q+SMxWesNRffWURY9D3AU
         2ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763162; x=1789367962;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dm0sPp817ea+YIVgxkakoV5ujQpRM5ozgV+CKpT59+U=;
        b=mMQIFFkyQ9ytEtKzRR7ocFjPKxWxjei9adE0aCfrF6lRRCVQCkx4MG8CTXAyq+2A//
         QANW9H7e6N2CW6UV3GWcRxlPo4yjWSSq5jmZJwEJocy50P5zx6doYlgz1C69Ro/cqi4d
         x5GY3NB713JAVZS+CcHzwcGCqgP7I7NVQlFobjcz+pCiu8Sye1ni/SoWWk/TuX5ZLUNo
         QYFjuywLrDNZ8egBQlpFjLrIhxscvpBCGw4/NPGDcbgm9g4RimZwxa5NL704Vzd02jAz
         rWlUYySXh1CCqrnl2w7wEw3c32Ff0ZVJ20Xxn7C1KhoMQ37iUlQQF52AcNsdqWIyLrDX
         tJKA==
X-Forwarded-Encrypted: i=1; AKwUvBw2LBCx8Z3Fc26Jtwwwv9Pp1k/8t+RXW5sUjXKfpez3LHHVQrd7InqAT/7rXNSmh5n1447qwZLaig==@kvack.org
X-Gm-Message-State: AFuF++myOQbPj7fq01R86OJoWTuniflOk1KG4+EbtyyQ3WxR4agC/0Yi
	DsYBMtcv57HAckNLFZ7EHj5zvA5IpimPI8s0Xw8iSQVnAGpYV+VOqSq3vzLUfeV5IQwhMQQnYPb
	o2K0nJg==
X-Received: from dyjt11.prod.google.com ([2002:a05:7300:7b0b:b0:337:a3b2:d113])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:168d:b0:3bf:b84c:2984
 with SMTP id adf61e73a8af0-3da39d14759mr32303334637.11.1788763162041; Sun, 06
 Sep 2026 23:39:22 -0700 (PDT)
Date: Sun,  6 Sep 2026 23:39:13 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907063918.3432401-1-surenb@google.com>
Subject: [PATCH v2 0/5] read proc/pid/smaps_rollup under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9946440004
X-Stat-Signature: x8sphj64badx5a4ow3i96pryxu8fegrz
X-HE-Tag: 1788763163-528410
X-HE-Meta: U2FsdGVkX19YOUMWpCsSEufVO7rdOJE5T7xI16g3Yw2FXjdRNF74BuvhsBtVGbKUusRDmfbAYPLrmpR5lsVYMtD00au9VMe84n1m4KI1i0l7qrbk3ZexU0f0dOJWqEXYSPOmHf82XgPwXWnoOHH/XuFB1UTCuQWyiZOVcsXfpsHuN0QoyFmp3lrtkbll6W3Cs7uG/gyK5vZZMyjfEDpXoWgiovrPVmOuKegqJIgutUJUDwfnhDUgdVHjh1tcDN769gE1EHjwqqe1MY1P5KEbCcFZjn2UH6tR97vLbPHw0/O7+ihX17ATf8DhGF+l3wEKAK3B8wTzhG0Ucv01Tc2VCqEl/SUldowB5HJyJDOgQ3xHnWZY4485d8HEO1JT883uaVSINs2rH7s9GyiPP7elSkylA+YE0CCUOUPcXyNXzLLGNwzIDkPQGXFelcUuP3yTkTH/VUcduDE0rIW+Utq0Rxhil7EdSL4Ibo2XysCLANhmcGBiUB6/MlCq5EQKGKP0RZKW0g90YGNYgXEnJvEoaUHEcU5uJuce12xUoOoR0fVw9NRtf2lapw0JbByEGnW0ZrSbghtn+TbXbPy18r+tH+YOGEgBBfy9Yvaaqa6gCnwMaHUeKvCaLK0Py2XnrNcp0X+mPaVONaL8eMWE3PcBq5aCk9HsebBB5xY4nKhcn+4EvnyenadEdInJxrNh8jMtaumVsYyYxmYblL2vcMFw384/34ihj8zfx8AgYY/JmsZOweRSZkx2s7Yj3X6Zqrvq9cG34nDnBhgHeBqqvh3TM+FXPuLWMdHt/9XzX29udlquxK+UZzbpzrxNrnvRglER7gcWbOmZsSrfBE085GV3Km8VVPfF/5+zHFGZdTXpgCanRnPbgzFy0XUeX2loko6+wh1brsJ9XZG8xDSiq7FJbRNq08aabRmBIjMJ/a2mRvsvItpezM8LeTyqKU/L394ZEkFqqLuiCqVv+yePx56
 RfPz0TV6
 YImv1b3MnBg6TFXSxU68nZZm1zeppxT9kEBbL+jQ73Dn+CwN1CFkWCKHq9wrN95bBiX9AwcqisX5EbrMdGPVzKvmZ1rrsf2h2HVqkwdTWC9gQZ5vOiaT2u6b41jdRfuuchXAM7MLq92J24x3JRfnYr7NG/GLiWULogTR07jHq3bvAtLKKZD4civtWQzlzOGcVd4y2aZy4mss2UJTB/bOGZup1o4vWoW9meoBCuvM0OafpHJPeothPhhxN5qcVKJhNs9UPeC9LvzF65zjkJbWagAC1xXMDJu4m9nTneDmQJQS+uZQBsQm8ooty0QLHQ54oyky9B+gLnEt6taiFEBpjyiQG6BST+rUN7Cf8NMkKMsCpaV/Hu1AomXHVVDyZggvX4H+lis2ICb45pgi+sY7xYOQ2tMsWY3EG8ta5IL2rBY1KjeP9uPje0KGHopcr5lIlg5UQ0GThSpshKbSVOBIEdhz/X0aujwYvkwn9jNw+5+W9/QMamhzCGsFbFN+JC0w7waMvyWqBjqzSh/YwdJlF5P77ASaaJdYjXXBS5A7Q7sMFJfDrs98UVmPRFwh+/aZsZk4N+BAMfbbLsUmzLnYG6paqOoGlsVPVgFMF2K5y/4qMEbChoXcosu5F6UAd51yLEjqRUUnYHS+P7rW0VbPo9pKw+g==
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

The first 3 patches are cleanups making later change simpler. The main
change is in patch 4. Patch 5 extends existing proc-maps-race tearing
test to verify smaps_rollup content.

Changes since v1 [1]
- removed helper functions which are not needed after per-VMA locks
became unconditional in [2];
- added a cover letter, per Lorenzo Stoakes and David Hildenbrand;
- removed is_mmap_lock_contended() as it's no more needed after [2],
per David Hildenbrand;
- fixed typos, per Lorenzo Stoakes and David Hildenbrand;
- refactored duplicate error checks, per Lorenzo Stoakes;
- eliminated special case of start=0 in smap_gather_stats(),
per Lorenzo Stoakes;
- updated comments, per Lorenzo Stoakes;
- moved original comment about 4 possible cases when mmap lock is
dropped into patch 4 changelog;
- added smaps_rollup testing into proc-maps-race test.

[1] https://lore.kernel.org/all/20260606015729.1837935-1-surenb@google.com/
[2] https://lore.kernel.org/all/20260813193433.3318288-1-surenb@google.com/

Suren Baghdasaryan (5):
  proc/task_mmu: remove unnecessary helpers
  proc/task_mmu: remove unnecessary inlines in function definitions
  proc/task_mmu: remove special-casing of smap_gather_stats() start
    parameter
  proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
  selftests/proc: add /proc/pid/smaps_rollup tearing tests

 fs/proc/task_mmu.c                            | 280 +++++++-----------
 tools/testing/selftests/proc/proc-maps-race.c | 187 +++++++++++-
 2 files changed, 291 insertions(+), 176 deletions(-)


base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
-- 
2.55.0.979.g7e5102b832-goog


