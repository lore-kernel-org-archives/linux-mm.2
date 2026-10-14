Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F5DCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5AD6B009B; Wed, 14 Oct 2026 05:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BF06B009D; Wed, 14 Oct 2026 05:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2976B009E; Wed, 14 Oct 2026 05:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1995F6B009B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:55:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CB4F1A02F0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:55:51 +0000 (UTC)
X-FDA: 85320775302.25.E2E061A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id E651020002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:55:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKrpzTox;
	spf=pass (imf03.hostedemail.com: domain of ngocquy0700@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ngocquy0700@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eo7EXw67vjv6v+p6PQKohVa243q8P8L2AoGfCHvln/U=;
	b=km7jA38bfS9VbZfY7HFm/0eVXZjUbvmFHw4ojZ1l+CF7jwo9ye147FEDl98SGwnzIezYRx
	DoZurA33wXvrnfJiE5x6q1PWFOKUepQD9bszsX+Wp2IdPS42zo6YRLHPMpHORWIwhdh1Wu
	ml2V7xCyp/MQs6qHxAFLOsTetq0hMR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971749;
	b=SVQ8xTq6pJOT5bBf1YMgShUAnEmrdG6qApqQBSxVOlynyUE9B2ZntLaHO2EZzMi2aQ/UdH
	58phoykqAVSAWirC45mtcMqbUYwZ4h7ViY55O9zG3H3GdkVvQWX3Fo/k/VfEKyvQKTT1yf
	6LI6Hv7Z/cQc9LEFdBdk6mzBNRs2XOE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKrpzTox;
	spf=pass (imf03.hostedemail.com: domain of ngocquy0700@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ngocquy0700@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e942864693so1263365ad.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791971749; x=1792576549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eo7EXw67vjv6v+p6PQKohVa243q8P8L2AoGfCHvln/U=;
        b=PKrpzTox8QHK54blZq7F3BvS4E7jKhwZyMIkGhHI3MCx6KKO3ESmvMwpRIfQW1Xtvt
         e90dgbL/oTiR0HGyQ7Z+HDm52HvgjVwHNr66R7wJRQfVpMYX0tEt98yphBnrTOcOcQDd
         Dbi5NnHV6mnTq4NdIE0bIC/xsa9sfHltywnUE7iD/0fnD6AVBSi+OBnFJYL8+xPR3dtH
         Dt6UxHIGqLpaPGg6DDP0y64qE0gMzXsDYHadGrmaFEqOm2V2Uo1UXf19sOxJ9pKcjdVH
         hkaw8VjDVj+hv9VieAlQkUWMLliB9FDFOsXNzCqYERA4uFNvBEwc4G/ZX61vzKua4ny4
         4okQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791971749; x=1792576549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eo7EXw67vjv6v+p6PQKohVa243q8P8L2AoGfCHvln/U=;
        b=K9pDBxBQfTp1eqYQs2JCDbvJY+fWrxzIMCAGCunzKbola7Z8qqon+36i+qynO2J2ng
         EMa/yiX0RcbSqTAdhmiSPYLP3pOlwxvTj85WYlcYF2ElVDBfQLAHbFEIUPgC+f3tDYUE
         3akRC7PxZLfrnCI0dYnueKQekF42UlJWjrAawSfzXw4w27jbNoZ2eeGRbBH809gdAqgx
         VEYwjx3Y2rZyaNDr+2L+Edh9E+jlJbQKjsO8Deyqpk+hm7uZF1T9NDqphr04m33dQPYG
         0LDDmB+/7+M9T8wscaaSW4nPUbyoatSn1ijKAM/prBxsfUR97ing7iFVDSWSPxNWz9Os
         6sUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxH9t7ekMII1mq30EPfUVlWyDdU9KjVn+YuPlnSlHmO2GS1681iHi514W5TIaFQvhD+7MuVw99ObQ==@kvack.org
X-Gm-Message-State: AFq9FYJXPVVAsl6yC3LD+XlxN4jvsPCc/gLW1s4kb1TWJXwrYVNESzJL
	M294mraItQHS1oIq74VPTlvmoCTZN6A7Bg0E8S4mAjWTKbCyBfMRMhe8
X-Gm-Gg: AYBFou3OSR25bfAEb/P4aET8Pb1Vp/r+gHhOVZsNrZekJQvCtoDVi++BkWuevH55Rwe
	WqniKcKjL+4NetPlaQRw32GtyF5yi+3In74uczJdDoR9I25OrcuQzFaLztvcuI6Mk1inDzArhaS
	7hfnkcqZLlOF3alysdeHNxwnI5St+t/2Tvwk3LZaEmRbMJv905IZhkztjIhKumZQeadobE+/XPr
	NnGkYbdv1foHge2bUrgLA9mzslwOP0RD5h9+r1/IL+o9L+rcLLbY0qmtSm8dzLxXob9eDtfUiZT
	wVqWJjGPBDyCKrQ7yA0KWiOaRvCtQNtBJV3in/yIvDfhacUEy0DrfaC73puhRtSsdUyinn5a1J8
	KeUHtz2m/FLmYSK+t/F5npMoqNbArTxsidZLFef+XdJdCaaA2Jop1mjrafu1spppE2CdIPSNbfI
	4P4ProGeONySBb7nZsELkpXaGM1U+hODNQZslfD0GD00rIHW4xxD18WMKYKCe7rZrwqKkoxUBCn
	R7q
X-Received: by 2002:a17:902:f688:b0:2dd:ad74:ac22 with SMTP id d9443c01a7336-2e842cfcd6emr137809885ad.29.1791971748657;
        Wed, 14 Oct 2026 02:55:48 -0700 (PDT)
Received: from chinocute.lan ([123.20.221.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b5924sm67131405ad.47.2026.10.14.02.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 02:55:48 -0700 (PDT)
From: Ngoc Quy <ngocquy0700@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Date: Wed, 14 Oct 2026 16:55:40 +0700
Message-ID: <20261014095540.3261469-1-ngocquy0700@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E651020002
X-Stat-Signature: jtiat7e31gz6io6xjsxskj4z5keym63w
X-HE-Tag: 1791971749-357301
X-HE-Meta: U2FsdGVkX19QI8TCZUMZaCWlpLarZH4CVl3kSwCSgogB0XpnNz95bxyk1iZ4uKZJuJW2NxXqfIx/KSU2U89QS7qtYNOmGir3lnr57oiL71cvDCx+SymSGhSV2sQsWnSUNguYtwJbtpqlL8sEwCmrrQ00vkBAKHdl6yTVJSm1Z1VDQiNPd4WYSCvhgb40aRvP98ByidEqJd6ubaoZmEO6HC1dejUp6IW7GhjKuyzdd5HDldwnjW7uht54NqoyI53I1gwZ5UfKv8rGoCnKr3Z1WkMvq6FQ+lHGISDbk++Y4qAXsR3qkfxFf2iYna6cG/LcFWjutkszQjssvJU2BaGtFeERq34eKm03nOnNiaR6Q4aYtRy5soyRNalfTBCQSt9MMh/YbdLEeGjvH2cSwMBEQdRQfIevkqagCFV4JYwVgpyquMJxAR4ujf2eiDJE34SdIl8v4jE51C7O1egoMubTKX2dcR/SXssVDRfgmTGQplSE7mLJLyx8e/ztguAWCswnQ92sYkm7hDBP90syvuDHmcV3ukLVsa7NFdUjWWqb1rfniQ4bqJvEpo/4JGS0A1+aqirZEp6lY3xgAHhhJadcd+jPERaRB6scYbEF29uNbeRlUsMO7UW21XRzPUDFZ18o1PyBXP0pzGFQq/ROaYFmTWFHCk6MajgioWT/uDNGGXMOPLuWw8K67DAS4Nvyt4lNvYjSncPOngtrVmxSHUa996nBSBsODEIuFKJQBj+DPqlo9BtC+KckiBSS4QtKIiWaQNdWhQMURIn0FVoDlm5TA8NeU64BrPdoLdM25+Xax5tjQJi64jyv7mYptCLEk4oJ4rHEKy4Se2rhPfX7S/ShlSgEmNJFjJNUABeJb6zet0ZYYyQDVKA0f9FJmhRJDMG/HXqXrKnpC/EJsTU5motnVDPZVkNemj1c26KO4WxiYllyCVMDyVNdqaiuhBsdmMi8hIVB7aDUzi3rQ4qRlQd
 d+hb3v8a
 bLpGJS2J116o13FYepfHaaCmDHDyFvRHHitM8kUnaj/rg1Y5/woz11WNvEM/2hGOQnpxh9OFz4vmJ+7nWVKmdzpxQCUwieM1beTHZHM54yAxUw9J3qQI7zF4Ft5TPdwEK90r9EdJaGLSrs5ByEEK5rJ3O/8w15Cmi9Uc1/xJCWGpFW8b/rZtjiH6sbVuo9JD4RPDqFdj9SfMorg6m04zrka6yBCS1364rlpcnAQt6yOTlp//04apmT9zMIINwOb5rMIXhDuUAfdVoam7I/w4/bPn9n8bgP11Yoz/5RQt6CRj6SUXEAMtYQeBMB/PPhCWEDtNO4KsA8fe1LfIZVOmPnIbBwy6I53EV/icjEdMhm6bq5gTcXK7Slvz3idNp4EKE+qAZ68khrM6ZJyXxN6pido7ln+HzpmygDVlzk/RIId6InaQXpQUvyJSpNKY7PVXlxaeao1KrnxPExTgeYgR491bF9/t7g9w5wo3xgcIABz9rRcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
/proc/<pid>/pagemap without holding a reference to mm_users.

proc_mem_open() deliberately grabs only mm_count, so a consumer that
touches the address space has to call mmget_not_zero() first. Every
other consumer in this file does -- m_start(), do_procmap_query(),
show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does
not.

Without that reference the target can reach exit_mmap() concurrently,
and exit_mmap() calls unmap_vmas() while holding mmap_lock only for
reading, which does not exclude the scanner. For ordinary VMAs this is
harmless, as free_pgtables() and remove_vma() run afterwards under
mmap_write_lock. A shared hugetlb VMA is different: __hugetlb_zap_end()
frees the VMA's hugetlb_vma_lock inside the read-locked phase.

walk_hugetlb_range() can therefore load vma->vm_private_data, have the
lock freed underneath it, and then down_read() a freed rw_semaphore.
The load happens before the freeing side clears the pointer, so this is
a use-after-free and not a NULL dereference. Any unprivileged user can
reach it with no huge pages configured, as hugetlb_reserve_pages()
allocates the lock before the VM_NORESERVE early return.

Pin mm_users across the scan, the way the other consumers do. mmput()
from the exiting task can then no longer reach exit_mmap() while a walk
is in progress.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ngoc Quy <ngocquy0700@gmail.com>
---
 fs/proc/task_mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe2118..8825b01f5e38 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3231,15 +3231,18 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 	size_t n_ranges_out = 0;
 	int ret;
 
+	if (!mm || !mmget_not_zero(mm))
+		return -ESRCH;
+
 	ret = pagemap_scan_get_args(&p.arg, uarg);
 	if (ret)
-		return ret;
+		goto out_mmput;
 
 	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
 			      p.arg.return_mask;
 	ret = pagemap_scan_init_bounce_buffer(&p);
 	if (ret)
-		return ret;
+		goto out_mmput;
 
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
@@ -3294,6 +3297,8 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 		ret = -EFAULT;
 
 	kfree(p.vec_buf);
+out_mmput:
+	mmput(mm);
 	return ret;
 }
 

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


