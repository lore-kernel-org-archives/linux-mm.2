Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476C9606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9qpsHfY
Received: by kanga.kvack.org (Postfix)
	id 597D26B05B1; Sat, 21 Nov 2026 11:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56FED6B05B2; Sat, 21 Nov 2026 11:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F696B05B3; Sat, 21 Nov 2026 11:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F89F6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17FD74052E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:14 +0000 (UTC)
X-FDA: 85459595508.18.465A538
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3567DC0007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9qpsHfY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795276992;
	b=jr0qvGiJJndRV2LBHcJANp1P4lg2LkKSsrJBJuQ4am7AypxI9bIRjR0RA4IoRGR5CTQpJ/
	y6SkqvkqqfQ5bZvfzQXeKSMG8wz/j4ZauEHDtFu+k4FDbrs9zcYB2vEUx/WogrvMajS3W+
	x2jgLTU60nCeTH4pcFFFhzHTz8NYEM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795276992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KmtJcCst2/r+CIlcfONxSVxRUgwHgVKNPqqN2/5YJ+A=;
	b=0VoFRR5Qj/oV4SOu/S+HWz/el2i+s2B8853raoBJ8kw/HfDj7dZKiThbEuwlsOO0QHaflR
	78UJ3AU5cgyb3veyzq7+TQOdU44LEPY7yD5EUstJ1Cnv0AIpdgPbmflo4GsoliRzMBJ0+f
	ONkk+9YpJH5PpJC9ee2lX8cxy7g1pfk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9qpsHfY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4680740948;
	Sat, 21 Nov 2026 16:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCCB1F000C4;
	Sat, 21 Nov 2026 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795276991;
	bh=KmtJcCst2/r+CIlcfONxSVxRUgwHgVKNPqqN2/5YJ+A=;
	h=From:Subject:Date:To:Cc;
	b=R9qpsHfYx+rDofq/QUCfrQI8mEkYCYK0QQlD1LeSnRo/qiTn7na7Gz5+E+WN8LL20
	 pswwehqF3Bx859yEwso3IIdzx0TJv2XQzANySMF/aKcCQTVCcMNa8woxVq0t5YG3OR
	 4d40WwRIKsN7LItS2fwnEs7xYL02rJXD1Jn867ho3vArpfiq725qIg9G7fc9nGeKqD
	 tVWSAwzHGWHlj6/OpfoE8rIlzuki6E2wlqrbDiAEOvMLRwrKulGYMXHCwcnFokeVLD
	 n0lvFk2YbkHTxv0UbkLWwhcCJnAfeRt/kvTx0xo5WRHRlFw4LK6MmDzMaYS+cjWpZb
	 MgADsX3IIbUoQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/7] mm: reworked AI-generated VMA and mremap fixes
Date: Sat, 21 Nov 2026 16:02:26 +0000
Message-Id: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3LMQqAMBAF0avI1i6YaCy8iljE+KNbaCQLIoh3N
 1g+hnlIkQVKQ/VQxiUq6SgwdUVh88cKlqWYbGN7Y2zDmnbwnjLYC0e5oeyxtKGbHaILVMYz4w/
 lG6f3/QApS8PvZAAAAA==
X-Change-ID: 20261120-some-more-ai-fixes-aed3c4b5ef5c
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2112; i=ljs@kernel.org;
 h=from:subject:message-id; bh=rc0Rcgs0tXdSEXR4lnymZC5iarX/LI0OXwfascDWCDo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2zjvyV23oz3kTz726Nf14lfuuj+g9/gA9vN1LAeu
 f1bJz492FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJMKkyMlwSfuM44Yte2KnU
 3QsyfdtmMzAurIyNWleRqWLw4OLDHUYM/xQbZyjdd5vbpfP/zIVDb1UKBQ++7EjQjyt61qQSvTM
 5nhMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3567DC0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cniiuc61uokf5whs536n7465xm85tjh1
X-Rspam-User:
X-HE-Tag: 1795276992-163108
X-HE-Meta: U2FsdGVkX1/GYnpu73BcuTQJzuguo/2BsIx1jh1xXo6bEsdNPKKoUEBQba3nbY839qQgjvIUBgft/HNv4il+btZTVU6JlqHEP/0wBqGyHe5o0eT2OrvkRCNmDi4wLzGlx9AOsnZPxeaNaVeK3FVXO3dZIzv8mrkzuvzSCs5CfmsOhe9DraTykdOfCuv37PSMnK9hvZj/srZUYIqkA3pfAzsg3V9vBUDjPWTfQwOFe/1Cmc8kP90ThDps/dHTydoCZo66at4D11OH4L0r0vipzpoh16KJP3QrOyUE1jr5G/iuvCmVLCocMjmD4D4z/BzbRM8gYSPVzcjIg2qoM/NgYaqVMCOjpLVfN0d2u3BwqieEj6i5Outs88LjL0oWOhySx09vBc7jU7r0bO4W/ovbkOHKvZCzdhIJTOWY2bLGRrIenpBAxMI/MYu5Rzen/Gq0moyE8CSjm1RTIZUM/UVzrnNPo3jwIdoHa7M4FNu2tpwFET27QiE+dt2zPzioQvm5Wgvu3+nlSh/fZBLnCMcOhkqXOq/6CDb7fBekgTX/UmZwvfYaWnxzUlmUQvNhaNWKXjzTsx+vzBRgndRCjITHUJTUpiiZ/bsZTPkHQWheovCH2FyPCLUm5xzjFVVbWrkjliqqcW5cOpEB9Rx53tzF16iI8NPD8phIls6QH5Cotxdeg02m2uppbkV0mzMBtxErnsdSKqn8uVHxdJ4+CMIxhknuXG2NU/IDFgM6UouwJbiAVI9jMig302npi/XfQtcWH7JlnU1nhyBni8yWl/C3JJJAOUXFprNZpoYLLYOSUUCFmD47i7P5ZXXU+/33u/HUz0gdmC8mMQnW+5YhH3np7cxAAvlXmmm8chiAGmHbDm05SWxwUISxP3AUmQBjYuGdErP5sQnvv8+0rKFVnplUszllGHseZ+nzir4IVnODEbowc9KRh1KU7KHDeTCBzNDDXQ0HoZfn7Frihx8Gayc
 yktkUdMQ
 3QsD9TvRI8uoMPrbg84RCgZzYWUYWyKggdtff8bildFtRG9MmSZBkD9m+vIyVdxMFux2d95mC1VHKBsIJQUCPwMuiX85rtPobWQCtqPCikVHPeITnaIYpahgYBlIulNdK6kt0rZJzT6BjNSIKOMtax3SoGRQ3t4jqPFr+hEb4P+prgKtGx7q8Y0tSVmvoaSzYCT8oOkj+POnjG4mg7RFIcJAzMGycVCxq9QpEpHTvz1SQ65W68E1iiqXtdwgfdHIPxJe7EgSlol96hPrvYmqZUkGRs9GesD/pYypdm03OssdwxZ7rpmXK7Lhl/I39+10iP82JQAvzDNNMkY9oYcon8OwPim2oYyrtSx4rZMuK+N2OVVtKIvn/gNgyG4mgT9ZxD1vo/GaDyjo0lIg7ulLg5M2d0ylcZDSDZ7Ly3nAOz6GNs0NrgGLUI+gQp8sFwPQLoOkcLCi8z7Q1irxxs+TpAlhl0KJqGwFfP+6J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I have reordered the patches here by priority, David - the first 2 should
be prioritised as hotfixes, the rest can go in 7.5:

== Critical ==

1. unmapped_area_topdown() invalid bounds - possible memory corruption,
   triggerable by any local user.
2. Lock VMAs before mm_all_locks_mutex - system-wide unkillable hang,
   triggerable by a local user with FUSE.

== Need fixing ==

3. KSM unmerge only interrupted by fatal signal - silent data loss on
   mremap() of KSM memory.
4. Uncharge after failed stack relocation - strict overcommit limit
   defeated system-wide.
5. mmap() offset limits on mremap() expansion - invalid file offset
   reaches the DAX fault handler.

== Hardening (no need for Cc: stable) ==

6. Guard gaps on in-place mremap() expansion.
7. Non-executable brk mappings under MDWE.

As usual, please go through and check these carefully for correctness,
sanity.

Note that one of the original patches was punted over to the BPF
guys ([0]), as it doesn't feel that it'd make sense to change core mm to
address it.

[0]:https://lore.kernel.org/all/awGZWsCp6v63H_py@gremlin/

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Chris Mason (4):
      mm/vma: fix uncharge after failed stack relocation
      mm/mremap: apply the mmap() offset limits on expansion
      mm/mremap: respect guard gaps on in-place expansion
      mm/vma: make brk mappings non-executable under MDWE

Lorenzo Stoakes (ARM) (3):
      mm/vma: error out on invalid bounds in unmapped_area_topdown()
      mm/vma: lock VMAs before taking mm_all_locks_mutex
      mm/ksm: only interrupt unmerging on a fatal signal

 mm/internal.h |  2 ++
 mm/ksm.c      |  4 ++--
 mm/mmap.c     |  4 ++--
 mm/mremap.c   | 10 +++++++-
 mm/vma.c      | 75 ++++++++++++++++++++++++++++++-----------------------------
 mm/vma_exec.c | 22 +++++++++++++++---
 6 files changed, 72 insertions(+), 45 deletions(-)
---
base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
change-id: 20261120-some-more-ai-fixes-aed3c4b5ef5c

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


