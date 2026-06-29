Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F53C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0136B00DF; Mon, 29 Jun 2026 09:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1006B00E3; Mon, 29 Jun 2026 09:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7196B00E5; Mon, 29 Jun 2026 09:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E89A86B00DF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:50:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 772CB40112
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:10 +0000 (UTC)
X-FDA: 84933084180.07.6C7365D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB12520009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vf2MYgmn;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741008;
	b=rMiZotRHS2Ga1btqUM8nEUjE9fZQGJgF97pEbgH2H3QLtj69N1fjccfLuViLfXgdNTuzAZ
	wYXuH7MBsZBltf1tfBF+SpUSCkdQ8S4MnxEgJ+d/tJr7XO4KJ3FoX47+iNFcFUI8IT8nDd
	WDVCsduXrby1Z1lYIOS21xYoqTvNDjk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gjjJMx54/5mRHa6or1HyeyjorZNM+BytGl3Gs8yQG0w=;
	b=BkHFR2Psq6OGOiMkG0Y28amO13cwZyOQ7/J9xfdfE0cAGqREx3k+2Q5uso66mCAUC39uYx
	dDisc/ZPrGv5IeBcLFWB2l6GlleqrY5big2wKJxiWjDsFVi+FdtS9Ye7aSydNwxynxwg4w
	hTocs5S2BNnz5zQ8YrjB5kZZNmGlCNk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vf2MYgmn;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDBC443E8A;
	Mon, 29 Jun 2026 13:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A73E1F000E9;
	Mon, 29 Jun 2026 13:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782741007;
	bh=gjjJMx54/5mRHa6or1HyeyjorZNM+BytGl3Gs8yQG0w=;
	h=From:Subject:Date:To:Cc;
	b=Vf2MYgmnHnJJVCrzdE3LiX6xkrtsRgLA0cvEj/rK36pg/35cqiSMga/VEXNuykp3t
	 Z6NMsHvGD97MyaJfbJvH7NhPCEPIEK74VybXaAPjHA14RiEstBhgFnE4ooLTW7jdaA
	 NUwVZNW7BFA47VOviNcSOA84Qg/LziTLQuokvpmOXX9U+ya12o1/wjE3xg2a+PYzve
	 hPjYZk2pA/IkQyAK8JhAM1iKe9YLTRzNpvqb5mGiKnqAdPLI6+gEZWtJBz5hCIkj5s
	 h3EyYyuT0Sw5hUi/xzdquujJ5X2mMvXJik0T479QtIqLo4VXqAbKPMpCV+NrFE0IjE
	 /yPMyLxDTyxDg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 0/3] mm: cleanup clear_not_present_full_ptes()
Date: Mon, 29 Jun 2026 15:49:46 +0200
Message-Id: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPp3QmoC/33NQQ6CMBCF4auQWVvTVqnAynsY0iBMobFpybQSD
 eHuVhK3Lv+XyTcrRCSLEZpiBcLFRht8DnkooJ86PyKzQ26QXCquBGe9w460D0nPhBF90ubpnJ4
 TRjaYkyyre2cuOEAW8oWxr12/tbknG1Og9/5sEd/154q/7iIYZ+e6UqXpK6lkfX0geXTHQCO02
 7Z9APlxcpnHAAAA
X-Change-ID: 20260610-clear_not_present_full_ptes-df3258baf7ed
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: xe3jsqfgnounk4p156ieaeba81jxtx8h
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB12520009
X-HE-Tag: 1782741008-325374
X-HE-Meta: U2FsdGVkX1+2MbJgOVuNya5hK+fKnkPyaJBxNd06Ahw9IJxCfb89DLoa0OFx+ucrqsXxVUcKmFdQihYhxAGi8tl6NbjMv0+p2+fxELLQo4csXObfw+ZHH9XTDcaR4GbLU+YNOZ4OyrF2jQtp61GR/9lsuEDIvBOCbFElyUgfyaiicVPlZJGs+3I08xmg2r0OC7yZYKmY+fpVe5fdFzLfxYgzvuD35+lM/GkmGkN5iy0mLgWuXcCXNmcTw5mznPZ4uUhvmi54zBP8Bun14Zh82OFNy50MOebENmsBVQ0vD2CldAWBTWUE7CZvHoSBZPTDRf0opUrm6P0rgdTRTJoFVYmRrwQL/+xkEM+OQI11ZlmyFGIGv9YiowE9aF0shYSgqfhZ8tuU64W/0y0bwDb5orHZSFNwXz6pVJ9KqjGEh5SRZbI4f1qhQgAFXDvaHV7wP8QgLSNCwHis8kFEg0KDeR8j+i3RfBYLsdzphDcSaV9PYqBfjh97ojvvyJjIMxGEjBf8OxmVGmNEx7eOm1UdYRMA63ns/fMQjHsBoEgtQOqlS1O6DIFB/8IbZpOGDjIJB1Ycjn+cda15qCL1ZNAjKLsw8iCtIi+pkS35RSM2IRDK/XvuYYARV9flt0InIoZa+wh423OdT6/WemVOUrv1T7C0PUjGSiwPNepqU46ivHPl3ZkrpVnUE/0oTU3wO86Ipum+sMEJcFwa9ZcOvC0+NJLWgy+lxpVk5cyHK6iRBMCL0ZJQDqgbGcuu7QxG8iaSK8k2o01xPz8K9IQgh0Lv8HJgvqtKggagiazlwy24zx1N6IJ5IZzJV4akg/jvdEPtSr4+zuF9BndPWBhaeQ6ZIml0vJmA5GRdHgWeDmVKJu0ppucyDMUeOE6JxyxVrvQsF6+3OkQi03a04Sm8xTV2MTr856X27H1VNuTTdgP86DzSFgNGgn0aDWGiNV6vKb+Nze+saQ0nmfsgSN4WuWY
 6msGc8mT
 erhZ8Q2xaGEB0SgfP6OuS9sEpGZiopzfFE0+CBhjcnLLm3+XQXGZebzBTPufHHIsslCxD+CEdd6qcG9IW+IYsmYVWl8vwdxvj8pc8jZvkHL9xPaDKLUpqApYjCJF7Q3tV/o5LMYqdLHr7sJrg5Uql9eQr32NR9gSHIC6OnfCHT0TsMWE4W2QPhVKL17CuwUMTnk9mh0uE27H1Pct/AWD0U+Fld8TBkTc69LMroVMku7QcgPiEcnpHU2lUkGrv8i5C2X41BsainUhY2S6J76EgQ38fajooSx6HYdiE5DOWkDx0M7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While doing some review, I stumbled over clear_not_present_full_ptes()
and concluded that it needs some love.

Let's remove pte_clear_not_present_full() and cleanup
clear_not_present_full_ptes(), renaming it to clear_non_present_ptes().

Heavily build-tested, runtime tested only on x86-64.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Silence warning in patch #2 with architectures that don't use addr in
  their pte_clear() macro by using "(void)addr"
- Refine patch descriptions.
- Link to v1: https://lore.kernel.org/r/20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org

---

David Hildenbrand (Arm) (3):
      sparc/mm: drop custom pte_clear_not_present_full()
      mm: drop pte_clear_not_present_full()
      mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()

 arch/sparc/include/asm/pgtable_64.h |  4 ----
 include/linux/pgtable.h             | 33 +++++++--------------------------
 mm/madvise.c                        |  6 +++---
 mm/memory.c                         |  2 +-
 4 files changed, 11 insertions(+), 34 deletions(-)

---

base-commit: fe61612214b618072b4ea3f5065a81296df6dd75

change-id: 20260610-clear_not_present_full_ptes-df3258baf7ed

--

Cheers,

David


