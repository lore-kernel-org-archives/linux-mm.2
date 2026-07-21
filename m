Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67E1C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C146B007B; Tue, 21 Jul 2026 01:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7236B008A; Tue, 21 Jul 2026 01:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E386B008C; Tue, 21 Jul 2026 01:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62C3F6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:19:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D92041C005D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:19:08 +0000 (UTC)
X-FDA: 85011629976.13.93CFB9B
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 470CE1C0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:19:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r8+kpwXh;
	spf=pass (imf20.hostedemail.com: domain of 3SQFfagsKCCII8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3SQFfagsKCCII8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784611147;
	b=h0ClvEAFOdBXWHTlUAKL0A1bJjszFrf1Ng5ifma3ENNvG3DKWS1KTMDqnDjla51S7Wrm/x
	/YPYuZVZMichnTJckQVzA7SGcfxaPaQJz4f2k4enuoq1hCaTkFpQIgVGzSpXRl/rMmoFdS
	WU3gJiUdGULC30VFyHmYmkpuEX+40m8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r8+kpwXh;
	spf=pass (imf20.hostedemail.com: domain of 3SQFfagsKCCII8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3SQFfagsKCCII8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784611147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TV+Y8XsBdBXL7khfi7GOI5Bku1aKo0kWKoXNOlZBFC4=;
	b=r+kzoA6n6aFODzDXrKr/fCDLBi6JNJTFTAUxfYF0M1vLdjUApjYyZzBydPCQQm/F0fRBBG
	oufR/EKznZsx1nr1tOtbsT5gzVe/uMGmtYlhio0yOOfCXvx0LytnrEpJNHJ+QYOaBs/Wmw
	ibg+ADlxIwLZoV90xHdEcMfAqMHUiXg=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso2134349a12.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784611146; x=1785215946; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TV+Y8XsBdBXL7khfi7GOI5Bku1aKo0kWKoXNOlZBFC4=;
        b=r8+kpwXh+gFKRjKXG4SktPqadUggMU0r8hPOWoCW2+jWixF6WdGRckAlZNXMIUSnqY
         +sREuVO1UPUZH6wq8fFvR7toKbr3k7isXV1o4hTcgTF4YjTHymXIIA0XDvxvK7kdncdh
         tJA3aZ2bx9Z16qEaD0j7D3IhyGRxjQVzINGz5RHNOUgBXNzQjxAREbF9nLiQrXWXjIsN
         KeZ/5e7xKb5/QC447tNHwwG3OIuuk9JGEftE3fX6VMAVukpVdr0xlk6ye/c6cZzP9tsX
         eWwuSa+jIGj5Rj7PnJHw8k/X+yx2bkgR5Z+ABJCkqDpFU9PqKUq505i+fc6Q36K4WuFv
         z6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784611146; x=1785215946;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TV+Y8XsBdBXL7khfi7GOI5Bku1aKo0kWKoXNOlZBFC4=;
        b=JRXEjsq4pTzKhyBzuiUgVeEJnGdZbImo1Wjo8L2OghKARAZ855QJv+WgtWEvfBm+yk
         nyfQW6aPN98YK9T0UbseSJ2zYpFNJE+VlNQB4H8X+SX40tikC502A+Chih9wQX7KkMji
         f+1lICdAF7RLx0nuyqTOTR1MbE1uus4RkwpiksKRnzDcXZCbw1pQ2IziVkT/km7vZBU6
         OGlnY9NPE0lB+U7wF6ec0qltNy1adTmIS3TIcTEP9dVuK/e8VjxMCUOSZsWBP8xaMFLH
         YMgoORf1feWJhUMeDRPWAFpS/IDG48XCsk00ZgstK6qRrAycfGxUbywwvhOovHc4YCVg
         ht1A==
X-Forwarded-Encrypted: i=1; AHgh+RrJI4rvrex89ZTJXmy0OMwqC/u2UBSGLNHXA9AMTG9O4Y9OqDBnL/JVFxXJMPgv2W/klZ22cBT7Hw==@kvack.org
X-Gm-Message-State: AOJu0YwS7sqRxTamDjuWU9PYevk9wrPa83FErAZz9nUm+z3uRDjDSqlx
	UdYvpCgsXVpdkU8HmFw48vhb/TpGdA0wtNma7+1lcd3qnZsSzmysZ5JA0Qd+JUkaRfYTCPJji5z
	7Bbv0MaLxikELRVcP0y7llAHqrQ==
X-Received: from dyvs16.prod.google.com ([2002:a05:693c:42d0:b0:311:5a71:d53c])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:9785:b0:3c3:af85:85e7 with SMTP id adf61e73a8af0-3c3af85b991mr13297408637.34.1784611145830;
 Mon, 20 Jul 2026 22:19:05 -0700 (PDT)
Date: Tue, 21 Jul 2026 05:19:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260721051903.691848-1-kaleshsingh@google.com>
Subject: [PATCH] mm: proc/task_mmu: Use walk_page_range_vma() for smaps
From: kaleshsingh@google.com
To: surenb@google.com, akpm@linux-foundation.org
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ftwkw11tiwd6ataxkpfp4iotse4743mh
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 470CE1C0009
X-Rspam-User: 
X-HE-Tag: 1784611147-988962
X-HE-Meta: U2FsdGVkX19tbJueGJ1efQ0cCVRZgjWM7dap5bwm5W2aT3yAqbUj6B2s84K7BFy42DV9rQ84dfLHCohBGrkng1TMRE0Dn/iEZFto7JKqhC/l+X8D9GhGgBk6y96F1BNVoKjIJv6zLj56UFjP8923IznkRLNUfqUBOH0iZrcC1AEu9a331XbZAt5H+MMKyinwjy3g0YV7V7l6hR2w3+U2BZ5IJMrAYOrqQc1RdM/pWsvEuRND8t0ZHVWuLVq+MJeuY/bIk/+2xBGBViLyZKtxkDI/ddX6AfqpA4WRbkoLBTbmENq23ShpFPPGr2MYWKRhEUz3P8CR621THqLmPIoqcycoq6BIN+O0muVZ9zApcDsYB57Zf7EjoLaPy80/ZQC/p2HVvnc0e/w4V5y6J1CaFhtEaLto7TJ53b/WFYRj8r7edqBX9r900APPwZbr8yrsHhrO2il7IgvY753xK773j0yZeqd7tPElEheiWCgub2ivt3zhcsV/xqs21a9OEuk/jkMVpxyxGpB2sDf8KW8BtBbP1fpEMepwbPeT0SE3qZCGa/9POl/FGLfVvDTaR25tQf+D77ZUOgscagdja5MfM51qiEmYBXLkLQKQOv+1YIqtBH4wCxunz5LoPC24c7fzFS8Kb4PrXTmvYdY35Uzu5wn3jSci704qD6yivPoG3XnEgy1tj4BXWQZF/w0nZyHEBJGZ5KUQ5SlaTYXX60mhylDmO8rlONR7Lq2OJ21t09nUYzKGGpkgcmrueBMtynCWftw/HV7zzPKD8WVTDXc6CjuT4YZcPJup2nGjih+qnioLMB1oq8Q5LDDDVNvCJRxGJBN7K/tDBkRhwk97YOzoqMEnpsYouFv6cL1kNU1ymAtMfd2/nBi/nA6H5PYQVbLECRMKVP2wL5rawxgdVa5PRyOkp6LWGFIYjWlmwz83mPH3qABpU/cCGoTOQUDVMHP4wqRxrKpKv3eQ3+t5WH5
 4TqfkxD9
 xRB3UkKonxu8RivOCgD+gbeYBK/xrBFQgsd6Es7qEXpN07FdcEWZ9gIm1OYd0mht+Soh9TPZOesT31t42u3cQmP3eZK4YpvlxFNwQ5Fqbs66Lfk/LulJODqA3JhLyNPbZJl1MSh+wpHx07lqZqrJ+RGNLSym58a2Nw7Ky1J9QmYiP0WqbWUDjGN7WVGjIpEg/NyYNx7lXhfLI7kf3li555+KG+tu7mjf8QVoUMZrApioH1PO5hoPq3Qt5Ao6TeGzzHN8iUSGMjHL8zFFcqpUDzplr0g+4ZQmLSh8uhnHYJfpaO16+9alBzxzaMSuy8hW/JhOoyKdhMpUQ34xnJuCm14E9xPu3pAXMFRWWn6o6qlBt6Ff64k9ysf4rrE6C1D6zc/IQrLsZvU2CgjTEvB31V9izdU7JOBtAV3lzhIIaGCbf2izTbVgSRSFMXZ0a3omyzJdB8h50traNv6kAYne3JoO6wnaaIGxTt8zPjWhDBA2VRPq9Gk0AeJXl1b+BOMQYkmRKbqEIgw01M9s3ItCKiYmegGRe7r+Wn3F2JBFhBttlVvnkuQ/GXNsryKkyClydqhqtj5LBZHMSPVSKqtNe5gvEx1BpS9p0ZSzr8FcMISPvLDlIFLMjucmJQ/ylJvy40PAui1ekO/wI513s+r2N5lfuBcaa3dBR/VDRAasWsCnIUeiAinU47LirhKU2BkFWeBIddUhaQz8uWN2oD+QNyvF7KTV7Jc8OJrExLvV84ze6XowgcyMtTtu8K2kzhg1uq5whduMAwV0QFpJONwHsA9gyLZJ3ajln4URvlKZEdPTA7Zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kalesh Singh <kaleshsingh@google.com>

Modify smap_gather_stats() to use walk_page_range_vma() instead of
walk_page_range() when walking page tables.

walk_page_range() internally calls find_vma(), which asserts that
mmap_lock is held. This assertion fails when reading /proc/pid/smaps
under per-VMA locks (where mmap_lock is not held).

walk_page_range_vma() walks a range within a single VMA and does not
use find_vma(). It relies on the VMA lock instead (when configured
with PGWALK_VMA_RDLOCK_VERIFY), making it compatible with per-VMA
locks.

Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 fs/proc/task_mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..5d301bdd05fc 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1369,9 +1369,12 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 			      struct mem_size_stats *mss, unsigned long start)
 {
 	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
+	unsigned long end = vma->vm_end;
+
+	start = start ?: vma->vm_start;
 
 	/* Invalid start */
-	if (start >= vma->vm_end)
+	if (start >= end)
 		return;
 
 	if (vma == get_gate_vma(priv->lock_ctx.mm))
@@ -1401,10 +1404,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 		}
 	}
 
-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	walk_page_range_vma(vma, start, end, ops, mss);
 
 	reacquire_rcu(priv);
 }

base-commit: b95f03f04d475aa6719d15a636ddf32222d55657
-- 
2.55.0.229.g6434b31f56-goog


