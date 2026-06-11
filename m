Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A00ECD98D5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39386B009B; Thu, 11 Jun 2026 07:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA126B009E; Thu, 11 Jun 2026 07:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFC56B009F; Thu, 11 Jun 2026 07:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFD7B6B009B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:51:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 775071C29FE
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:02 +0000 (UTC)
X-FDA: 84867465564.25.D52209C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5DDD140009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtGIR5+G;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vCLT3MldI+CnLiU5868dQt6KO3qRHng7qPiO+N2n7OE=;
	b=hIaxSKS1F7z75MwUkob8fPYmjQ78FjuT5/xaZn84i6kaKtc1UB7PLzkOrDx4RBpkm8ifHy
	lNImE5jBr5SvZmaraPsxLgprSyrmV+s7cUEcJT4ICaVUesHdAnsIWBo4E08G4pbcbdNZVf
	riPuHTAW1BEsZFt+cto8vH4ZM+M1w5g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtGIR5+G;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178660;
	b=49PuCy8ns+TKzYuP4PMzRTu6g6qbeD9lUXicmgv4XjMsP5jRCTw0y514uSqTYrJlIQHwz5
	tm4OmtqbiGsMI1hw4Z5fnJq5LBwlLE0+KeSJSBRxECV2NBpAL0eykOxX6SW1bg+VvhZT2W
	mTz0GPJ43sp5LCICNMud8LjlrVH1K08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6707B600AB;
	Thu, 11 Jun 2026 11:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58731F00899;
	Thu, 11 Jun 2026 11:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781178660;
	bh=vCLT3MldI+CnLiU5868dQt6KO3qRHng7qPiO+N2n7OE=;
	h=From:Subject:Date:To:Cc;
	b=HtGIR5+GL916gH/Y7pQUGNkTbN8MuH3ekBiP39HWzBoSkEgMaLAkgnPbnhm/I1L1j
	 X4Iqlnzjk019288Y3jDIkS31lfpOc547SmVUX+8LMufuQINzh6ToOVGHaxsumaqyCY
	 QDj3r3WCdeyX8H1HWFPf0LWkeF/ni0rvSpxonwZm8w7zsIJThgeooc6qUHyh+8O3+Q
	 fdJmR/+S8LilJayClGIGaRBQQ7bTdH+uW/ItfRA+PzKDyabxOb/IhhVw2ickuvSA9o
	 vTs29BkfrR9t08hpDblYLpE4GXht/DHCQCCJ0aaFduvRTKKrHJuI0EId4Vaf8RvyII
	 zBhFcdgUpcoCQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/3] mm: cleanup clear_not_present_full_ptes()
Date: Thu, 11 Jun 2026 13:50:46 +0200
Message-Id: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABahKmoC/x3MUQqDMBBF0a3IfBuIkap0K0VCal50IETJpEUQ9
 97QzwOXe5EgM4SezUUZXxbeU0XXNrRsLq1Q7KvJaDPoodNqiXDZpr3YI0OQig2fGO1RIMqH3jy
 mtwsjPNVDLQKf//trvu8fziCL020AAAA=
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Peter Zijlstra <peterz@infradead.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E5DDD140009
X-Stat-Signature: nn1h7sazucu38ityess6stu4b4bm1u9t
X-Rspam-User: 
X-HE-Tag: 1781178660-554253
X-HE-Meta: U2FsdGVkX19c+1y5BWEQ5l+KQKx9+V8B1v/9eNgcgtuhVoO08exGyO6n7s53VIyF7rLwT+IPadkoc53jkKEjJRvQ7M+ntTk9J5e+VV7Fsl8BuA/0XqWrNvbj3CA1mybc5RHFAdN6Bwqk9WmWNuuLX41MDYCdtaytOhsLIq/n9fX5BxvPI6KAgRfl1HCLNaaXLwDBW37FQYT5ruMLLb1Z2MORvQrdxecnECVscRQFzC/icCyDCxcuvhZxgT95peqdo5SMD8/2Kz3kHHeDqzyvVxqPycsC09Dq/4urZJp9Hn4lUfn+G4aUMEPCHFm9qCm0jcetszr5HKYVkpGe40qSQIhxBuyh69Py6GsL1fQ3rXvQdAbGS/n4xjPvQvQv8jz1z+ndHSjkhaSDWYPVRCOhC2HpZAGTmYPX+zrZ77v2T8XvXHlXMSrC1uMXSm/mkKfHxQ1xXurj8pF8ODKDaLRzTMYvG3ZbIn2tGDW5PP9Qa1Ax8K4Uh8O6JRyGKlU8DfcKhh75tpKLYYXDYCjZSd/mx6xE6UXSX+NL36HxQH4bYtPhZOrsZv/2rGql/FEgtkYgRBoUAPk55bp7jsN55gM3n8GNtEUexbRAhzlEvlfMOJqleBkudweJQAKrg47WOVz3XD9a0JNBP8lOn/uDamvntu/xheto6wFa/j7Klt3uCcTl5nXRRCRzPnOLNfQCv5CRhqUfvSUUsyih7BunlKIrn5ecdey5SI+SB0mewaCgEFhw07cJArEnQ7f38QEaaVXJY9F7Lhnxl2Eaqx0N/hD3NPBRnZKjmVMOppG+urR6cbPWUUevT4NNKbrKgawPqOlq+GYBmbv5qu040UHhmD8ANJrr01WpXJxa/pnNN4htXkS7iapPSLzxv2hlAL9IdoeyJ08zMVoXcdgwX6WLMpWYFRKRNCYej9jqZYuclROIbg4ZYUx+UPLgfF2NIwLV2rrRn5GfyLnFOBRg42UAO01
 3vcFO594
 aQ+/qMXVxwI7hlD2MpBj/ovJwI+t+lnsnskQ8f0kx1vVJO4pv+B7l37+YLE0c6D61rAXZWX0CFnz++YVLCXy5yD2m8P7pSlLqwhwq68dnRqv/SaQXDj+HWgHP6DZdAHOGZuxZa0Zu7BuTGoaK1n+JfNYjmUCy1Y3oayDh56d6vjjckSXFVSfSR++Kw72k3pvPCT6J1zAqgXuIeWSFSxMvqwuYDGE+Wh+uotlYhR8vyIqVsC0cjDlcS2i5ICWtcy62QHVU8UikqhrZ4FY/L6lBu8UaxJdY6cQnLhXp
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
David Hildenbrand (Arm) (3):
      sparc/mm: drop custom pte_clear_not_present_full()
      mm: drop pte_clear_not_present_full()
      mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()

 arch/sparc/include/asm/pgtable_64.h |  4 ----
 include/linux/pgtable.h             | 31 +++++--------------------------
 mm/madvise.c                        |  6 +++---
 mm/memory.c                         |  2 +-
 4 files changed, 9 insertions(+), 34 deletions(-)

---

base-commit: be18cf77e1e749c6469ff44df00eb026f7c0a365

change-id: 20260610-clear_not_present_full_ptes-df3258baf7ed

--

Cheers,

David


