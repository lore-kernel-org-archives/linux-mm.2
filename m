Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B465C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D29D6B0147; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398576B014D; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7F86B0148; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C87F06B0148
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 520F2C0AF1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:27 +0000 (UTC)
X-FDA: 85113285054.02.CEFFD40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6D41720002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2W3x5sX;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RbgXRHJVBpSuTPuIGNUL00AbJchtZpzKNJiYPUAGr/g=;
	b=KkjnbedfY1gKPgIGnFWXU2P46/UMDuRJkVKUYXOYG9mdwx4TkbTdm4zTPQojSGnHO0gGfW
	hgBPZGcIwkH9lEKZX7z/nt8pQVwjNLiGwTLSzdm7p3ZdGhHoVmdJIQ/pu1QGfejEu0jntl
	7AbrJXhjwgyO1bbyizkhPOfZP5Qp4GQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2W3x5sX;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031505;
	b=P8yAQGQfR7bcJib9PlSKW2av8QHAQj9LhMGS9thHKJvLePTflPNQdbTpSAj53M/8JzsXRK
	MiUTzPvtNpGsedDTNEZvB0MGpOOUpaVL1B0JyyyjuXL/iEK/ldfBhIljeJXGgZL8/HZQUY
	AwRw4TDO0o/lvqLQsoqYpgBvGqEH+EU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D632600AB;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B1EAC19425;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=iNXAL5QBSvFg8MqOSVXEQqqL3N8OsXIMpmVJhlAlWpc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=M2W3x5sXEF0qu1SIMbJ3udwLccLGRQp37dg0x2JDA2r1gQPf4tNEjAix10MskWFMb
	 hC2EI4cgjTi7frkTOk0NOfKdKKxg+r2b0NGj/EkPJeoS/CDLWGLVJRxBwqbGe8uNWG
	 heizzq/NjcnoPJbOs1XWRp44hoVp1/MrXtuV1f5o+3dxVNMVynSlpPpw/AC2UyAL+8
	 +4mSEGbStzySh4Sn5NEcqDMlA+OvgYwlCKmNU/qwTJ8NldfFpyspShkxRSyWDTJU7i
	 xTSyw9R6eoXYdg8PQkQPV/ffMCgo1Ls/gDuG0ELuN10OCjFHWvAJQOdtWXMS8LBApY
	 UJQrG0gleWhTA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4404C5DF70;
	Tue, 18 Aug 2026 05:38:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH 0/7] mm/mglru: clean up folio counters and flag usage
Date: Tue, 18 Aug 2026 13:38:02 +0800
Message-Id: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrDugYkV7FekiHSdxJI2SaUpBv
 HujLt/i/w2Uo7DCo9gg8ldUlpBR3QqgyQTHKGM21GXdll3V4dv5mNB64xTJswlpRaKmJ2vG9t5
 YyOUa2crvvA7Py5peM9PnWMG+/wFKXeG3dwAAAA==
X-Change-ID: 20260818-mglru-flags-cleanup-cc49cfad654f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=1840;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=iNXAL5QBSvFg8MqOSVXEQqqL3N8OsXIMpmVJhlAlWpc=;
 b=Pd+Wqg0HcpNXrBdlBTcn9izWhVx+gpdl+yHTtPE03/yo3IZwhaGWK/gihzWmav8MpWVOP2VyJ
 Lj+mgHjbzZxBXNujNarGSitm06PAQWZLFS8mzZDOViGQKi/AZUvtfjF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D41720002
X-Stat-Signature: fxwubbx8fjbd9c5badugk9kgtjc3m16u
X-Rspam-User: 
X-HE-Tag: 1787031505-406083
X-HE-Meta: U2FsdGVkX18wOXS9DHV7fanDsbimZZ8FDOhrZRFXKJZlKZIoYtKiOXvVDrogGVNGmqOGYQ3rbLBnMHaZ2N/KPGTAMtfokJi1VOd0xsELmmvff5Uzf2RTfj2fSJfUKlEIn0RPQcKnDrGi16cBGt472aLRTqCDYc7EAXzjFSZLO8lcTNDK2EivdZRpaFZXG23u/vGboYQ5UasKlL8bAxs5gMS3PHroaZ9v6KgwImskayHRJMf8/6XREqRJRMaGO4KActDlOWR1c7ZzYhys9Uvnvq9riXqt4vSRKrKvuXryU/cRQwkNai22BMnQiAfb6NY1CP8/3O88HLewlAtTLGNifp4WkEW0cvZ8WyC9e6P9621HNltgwSx6q0EXucFe5zeWGQC+QGN4DOPHeDea3yHED8UdZjBS38FTXTwF1Aw4o0B1vhlrzQeQGg+d4WLroUZF8G382q1AyL49eDm3RK0y9Aaf9PoR7g0+sVTzVglinswZsEkyocsx8BNA3Qz1sXhjm8A/K9+LSe+MFQ89xCpAOT4aGDUQSR9YY316WmdEnyrllt5XCR1zQY940xnxTcVt3946ia39/br4K3BCHB7f1AdviFrrCNCT8RNKrF3okJXTNu5Cp/Om2VuhjnsAPkyxW4PzmqIxrMYQxPzVtJ7uwE8um9FBSdzHJ9b+yWzsUl4DzsvJEa0WixpoJbwPH04eJZh5d/S1eWTENV4sdqtO4LgogT/OuWi1CLeLvjaBWR9zkP5vdzZAvqAtHkXHrQ9gvHF/1mcSwafIDnipZNFdE4Fp2UXi8NOFUssGHyrybyJPpldlhBRaC70fsDBP3JBkgVAOgCLfpKBsw+XMrpsATriEAUAtUHXDXuYdc/FnxP2tBYhjCNguMNmWP9yWhTiIguYX7BPyb1twZJfs1ErLmpzxrjWafy0MAwT/sGXkPK/An7fmFhIg0EqSgkYiTBnEv8DxMSllNRh2xXIe0jJ
 CshL9ms7
 Fj+dfmN/4+14Wsnxqyl7Q7ewL4IGnbFlPJbhlPpHi9SHi5T0NrW8WPDDnrWP9afMsw4m6pm4Vwbl619NKkEGzPWY+Rhkre/9WGxG+ci21U1j49NGZctzEXBaal4SQy8OitnDsPm79qv5wPN+TTzCAZqC9rm2BrmNg+cM0Z0XLFrkQXr7DLxea4jSFmLC44JxsHT8h71kCEt9YnkECLUkAay+dZBs1B7tkFBtKaDourhePwCMxkQGp0tFizon88HoacLVUkxve9oo3l7xiaezsnxTPlDc3TvztS9FznAW1/RJZUWZ6k6EIrjpeqZgisqk2adYugEDfEu6iSyDoa4dBs4/BNbe+LxaP30ynXxXvSZMYD+S52aQyrEK+PHDCK9108RrFexCY5bpu90kw7oQMQUpQkoDmRHQG4XTqewzMuOGT29o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a cleanup series separated out from the MGLRU-FG series [1]. As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix. It mostly replaces
the open-coded bit operations scattered throughout the MGLRU code with
new helpers, with proper kdocs, sanity debug checks, and hardens a few
MGLRU functions.

A subtle generation counter leak is also found during the refactoring
and the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series, thanks to Barry and Baoquan.

Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (7):
      mm/memcontrol: make lru_zone_size atomic and simplify sanity check
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy the referenced state via folio_migrate_refs()
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak
      mm/mglru: improve code readability and harden folio_inc_gen

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 102 ++++++++++++++++++++++++++++++-----
 include/linux/mmzone.h     |   4 ++
 mm/folio.c                 |  19 ++++---
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   4 +-
 mm/vmscan.c                | 129 ++++++++++++++++++++++++---------------------
 7 files changed, 183 insertions(+), 102 deletions(-)
---
base-commit: 3b1d6bd7bb11fd040bfa7b712486f5bd41a276cf
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>



