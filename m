Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932F5CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03998E0014; Mon, 15 Sep 2025 12:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBB28E0008; Mon, 15 Sep 2025 12:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18D98E0014; Mon, 15 Sep 2025 12:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D15B68E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:45:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BC9D59610
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:45:55 +0000 (UTC)
X-FDA: 83892061470.25.C6AD966
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD39A40003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:45:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="J/gmuKIP";
	spf=pass (imf04.hostedemail.com: domain of 3wELIaAsKCLMdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3wELIaAsKCLMdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Dh1IS3JVHOf86RTcG+zb9g2w/Ys+63vuY/qru+PreQ=;
	b=TLPJ5k32NFfILrFcpm429QGZVLUGcXXniIF2PQyo/3/MrBHW7eVjZnuAOg3lU5stzhmwdQ
	vW64MhzaNR3pTbsgajmr8QkDAaCloQhR/pF/a6X8XC3Gxe85SAbK9Ng1p10bxdV6PmKSpF
	6PCR8pwZKMi4HVncxBtTlg6CWQxkKPc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="J/gmuKIP";
	spf=pass (imf04.hostedemail.com: domain of 3wELIaAsKCLMdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3wELIaAsKCLMdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954753; a=rsa-sha256;
	cv=none;
	b=y93rKaJufzi8kwaY8adAd6Lznx/BeVWhpCsYbahkbDuiNpTCB0KXc3gGzfROurubQidABW
	+NNjjqt6rFONv52ch7xI4vSeU//UIJ1BXMClrqfJ53DmaXxujs1GnwyOnYK9Zacu6cASH3
	6uWftH8CFbCh9D1brgj0Tt5wBh3t05M=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244570600a1so48031345ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954752; x=1758559552; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Dh1IS3JVHOf86RTcG+zb9g2w/Ys+63vuY/qru+PreQ=;
        b=J/gmuKIPgFspRwxh3e3vkO22RZSa5rmzOPxMpDnADkN9lyz1POLDQtgPElFX5swPfX
         Krv9t+BGU74B6yLy/ppZMsneXrNOWP/sCfMnr/nnyyMiSi5elQfOVNtJ2myEm4PjHfoj
         obPLgqonkcmu8gTMq4vkqMhHLbeVbxhX1hsQDCjiAqax5IVR3KUNtwb9bqdaAXJEqNJ0
         DAtBJtgobRHXNCod15O7NI1QBN3EK+3pBfeESaKNEnCNacXLlcZ7eHZ4KDFqWMCrmSfD
         QfIfUp5FrLE0/t8Di+HMgiIy1sny+ffiROQ2304+eIX+iR5qRZRIysAwcqvTjhIZvttx
         SzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954752; x=1758559552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Dh1IS3JVHOf86RTcG+zb9g2w/Ys+63vuY/qru+PreQ=;
        b=GdhlZFOd8dt9ncbw1HF4jPu5JL0zT+SnyxLk/6PmqxvDRGiOwQUO80MRvFKUVBCzI9
         5AWaWxu6+WW2yGzXITEX+NtvX/uAwqElBpk8dOTQzUS1haqJQ+giVxPHYRJDjpprqw8t
         2elDS3gmMCgFfAYsYuUU18YraxJxScRusKBFg4FsG/KVBj5zWVBYYnWteLXcCNkmX5jg
         4v33CLUMs1fTvSPVcZHemCUywnoC6ZI9RpYB3g1m5UxrOxux5zt3G/vmFokXjPDbyipC
         za55Tym4cbN/JzZGXARc0RlWqvSgZyHKheEu81EuAHx3PNhc1YBtWruWyfDOLz4OmsvD
         Bwhw==
X-Forwarded-Encrypted: i=1; AJvYcCVptt6B1EYQphlDWKHG/loQwpCM0nJP2bBNJ0rhvxIHH6fpn4CZ26RQ6iTl9tAO0qoYlROPQ5qZlA==@kvack.org
X-Gm-Message-State: AOJu0Yx6OiebQS+EnKA3yqfCOx9A3JFG500s2oPJk6Jt4zPpDuf11/ar
	RDkf4/qbt+qBhGs8RqbLx9tr/4Iaot9XIMSlmdauFHXFy6fSxD3Mrd3oosfFidxOZPg0VhOKC9p
	Qz2bonKMtFztl/0C+CttT+MeFdw==
X-Google-Smtp-Source: AGHT+IETeFsnzxOgNLMCiDHUaYpnu2vRB/Fb66R7+b7xgDA1s+PPQqB4+bTMKY9LvQ479LuxEWFmKDI75ZPJsp8Xlg==
X-Received: from plkb5.prod.google.com ([2002:a17:903:fa5:b0:264:7b3c:4fe4])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:dac2:b0:24b:1585:6350 with SMTP id d9443c01a7336-25d2ac3c545mr185756655ad.11.1757954752355;
 Mon, 15 Sep 2025 09:45:52 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:32 -0700
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-2-kaleshsingh@google.com>
Subject: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit checks
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, stable@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AD39A40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mqkxdedkoatq5tk51yj7f9m6gntgkdx9
X-HE-Tag: 1757954753-276663
X-HE-Meta: U2FsdGVkX1/XGIg9jLlSM4ZSehbUhigaut5QlqG5w427xPTGXoa2/kAdsyg37vJZYyIS2xHzvqK5xjILbX1llPAFw5MBQynrIVqX39Qp+BBZTmwOuJnGOPdmFW+GH8JUEwgmilBCCE/fFPRgK4SFV07nwcOPZlwMf3c2wCuntBLa3R2xHoWtHSNKu/cQGmfbLqwfee2MUp4CJj1Enjt3WSzizJ9G7COf1qN/Ty5Kf2ZjQdZp61pFp6PMfrgW9QAJT8M59FoKbXbAYIZTv8Xcjt1l3nJW+rU8/pzinK8sJufH5KzF15bBFiUXascw6mMUJk3nuNVA9dnNXTZIQOtmMtXI2dvwsUxslXJDT1fpgsHN2En7erAtYUfyp5Uja7e+VR5+PKmmg2XnWOElLmYTtG2XRMuHIprgkIFFEN1a0RnXnwp0uxLfRtpst9qlXQI+XkeY01AllSXFz6YBsHgheBN4p8AaVnhaxwFwpPP7RF4ZcIHYT9z4+CeuNhWhVmYVqB9vpPBPyR9ElJTj+OIfFuARnQwsc02PgBGnhaRmgQBSa+lUPhg45hWESj4dwhMyL0eRO36Wqzlf9OmhmrPC0ZfZ/3wQ2xCWnjtg2Kds4F6pqZYEvf1JDK/0l9PN6lWldZN01fFmSzqenlFSP2IW2VlLD+rTfEaNvMI56659OSBwCt+OWLeWi+FqtbKbZvK5ty3aNDBKjHrX+QRtmm6JAx4fnEpJpDWeO7nGcpKtLfgsVaOVpcfycsgYT6Uq3QQq7ZpVrzqYhkA3ln8/Pl1ZfnTGB5y6GMe9LJtb5X471vqTZnhYSho4JW0/xJ0PBYKN+FjYaDRMqdDmnhUu+zuPdDYjPq5PfWFQgWuXwqc+dzGYsgF4NSJBwf0gho/JAwLCmYWjCDaJbz2Rzr6o4Wt0qDakL98iJz6COSltbbezjE7VOlablUX+62yry9a0SchQ05LndRDJfeMbMitj7tx
 se/28pam
 dwQ9E9ZpS8W9KTvSgMyOxEThdyBeAPGN8o7L+dWYuPTQuKtwwAsSO7Qm9shAZNY8wOz5lWKb0Z5HkGibV9DWpeZElAKQenRUvwwEX/hzEJBZC4reE6tnC4Gtn3JzO1wPi50g6mToyVOk0k6/VDiCMaktBXQB2kuV4jr7GSW0A8z7gQljjgXanbb+PyQTUzbQD1+ZO8McwWXpoN4ExKJk2VBd2koeEBQ/2TR6tM/ag5r9wu7UlcoJ2HteAPNVCxXcUORhzIvE0RT+oh527hukVUj/lUK1/EaBzzrDHypmNe0aQ0JjQE5loEDZ4WktmK+6KjMddJmaYTuSRaL5Mrckpj189Kx412Ulhwtu2ZwLg4tp4Lh+sIKUaAuu/7fbMJslPc7UtkYsoU4sfIvKA35s5xtDh+3w7/mCbRtSGkX54gPzHT1ia8PFGs/7zr4XVnMc0P/7iW4yYJ0Cq5b/jSk175TcuqwgemuAFzZWh+hBNOTamIM5mAkSuraIEky2tMeCLE98Aeks00zk+OYZb6GOJV+53qQvRzq1AczEkBxISBnDW5QvsTtV2/m9iXCGl0sfq652XgrRMpvtg/Qx2w//YqLslOQSpbvXwoUqgKNWP/QmZXvYwxgsQvHk4BOInntbBrXE/nlAvXOulIrCIocP+rYuDJDDKB7AhWKgPZeK/IYQSyc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMA count limit check in do_mmap() and do_brk_flags() uses a
strict inequality (>), which allows a process's VMA count to exceed
the configured sysctl_max_map_count limit by one.

A process with mm->map_count == sysctl_max_map_count will incorrectly
pass this check and then exceed the limit upon allocation of a new VMA
when its map_count is incremented.

Other VMA allocation paths, such as split_vma(), already use the
correct, inclusive (>=) comparison.

Fix this bug by changing the comparison to be inclusive in do_mmap()
and do_brk_flags(), bringing them in line with the correct behavior
of other allocation paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Chnages in v2:
 - Fix mmap check, per Pedro

 mm/mmap.c | 2 +-
 mm/vma.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7306253cc3b5..e5370e7fcd8f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 3b12c7579831..033a388bc4b1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
-- 
2.51.0.384.g4c02a37b29-goog


