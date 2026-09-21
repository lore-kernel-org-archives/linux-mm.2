Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31689C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501EA6B00EF; Mon, 21 Sep 2026 06:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1E26B00F0; Mon, 21 Sep 2026 06:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1796B00F1; Mon, 21 Sep 2026 06:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 195CB6B00EF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2E461C0185
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:31 +0000 (UTC)
X-FDA: 85237468302.18.7676AB6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED7241C0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TG7hL96k;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988250;
	b=S48Omyy5/I+X6jajRpcRAfR1qMePdZfj5ytyfYTIyFNa3Mjsnh2T7rEtVFUCTo21B2Pwlg
	tM96keruGVL/T+f3HgED6UsrQaSM4jBfy62qs99MrGltesBzUmLjw1RfzBIFMkZxSUE846
	8+c00iKKLcQEvSEIlsmTYhtWO6cGtVA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TG7hL96k;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVFXVZstIho5EUF9I/u2VieCbkKWILmsKne4F8j83w8=;
	b=Xca+cVH/JsHST9jUurYEwD1lnp0xc+sQZKnbuw+lIFgD5HJDMTe3sh9AV4mXi92PWrtZTi
	JU6akRyd5+ywelr/NyvLnfz98SqTQvzdYhP3PHajf7j3bHlD3apZr2BX5/Rb4U7jqy4sxA
	Es4bXnAiL3L6kyVeXrqoH/TqDAx6W4s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 912621CE0;
	Mon, 21 Sep 2026 03:57:25 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B11E63F86C;
	Mon, 21 Sep 2026 03:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988249; bh=ywGIUWe4eG9Fo7o6yUhrB9doRugWRJ87ez63n7dCtOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TG7hL96k21J46PvtLC59HQcHZYmuTxx9rr3LlmBn3clj7nC0IKikp8QCrZXShJiox
	 fJA0U5SPbxEnut2fgoLETk2PoTNcFpOzCPKxMO9mqeqjhO1uEMR7RAtABKtRMHEHQ0
	 b6ZmFs8B7G0JeikmhUafh8z+0+Is/vD6upLImixU=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:30 +0100
Subject: [PATCH 08/21] mm: vmscan: remove stack copy address of pud/pmd
 pass in walk_pud/pmd_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-8-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1416; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=ywGIUWe4eG9Fo7o6yUhrB9doRugWRJ87ez63n7dCtOo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1ONrk530uquKqsKokVTVRoFTxsseBHhNflE
 f+mOH3t5ViJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTgAKCRBt1cPRWsUx
 M6i5C/4jxR695g+aGeGrIAp5Hq3EK+JsBl4Xkw64Rh+MB3TRHC7oHN9GqMwjA0R8KVzPNX4iDSb
 opQlxOkF6mlSjUJGYxtqS1/XQG7tmGB0boaY6gUG0tIPmXOnfHwRWhoUKxqSVO71aiHCKtMDHx3
 bvrSwgP3w3zc8ggNJdnUy0wQcByFeJFXtAC1548O4Arfhb/ldpChjkVK3Ttsmgib2gqXAlb7o7e
 9kQEaAz1xbJx7+O2HbWqlXUHkPJFlrsGFKRoGNPmv+WuUmj9QEtHRlA1kSF54i0Omq+aH1S2gwL
 2LgEZ9bPoknyuFN6E9vrtpQYA1cCcuMTcUiDtUbwVryNrTwccRxsgqHoeJstzUoQ56opOp8sTAF
 Pb7joEtKSjOyjqcbbb/o2KTzQKHOb0DIdBIOTo6cAmoMHyo+NbTIe28IZaY5snJlAQuUdvNKFNo
 qjJD+aHKgVLGvNKvkeq2VdMiw2jy3gEJ6IWGuxArucd2EPLm46Ivh5Ej3meNBg4nU8tb0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ED7241C0006
X-Rspam-User: 
X-Stat-Signature: xmzxi73yh6a73o18bspf9bq11sren49f
X-HE-Tag: 1789988249-553326
X-HE-Meta: U2FsdGVkX18AFd2+w33mm5hybRBfrNKmJpIoWhfgUk/wGLy2O7ce5QZgSIviiTYn8Heb666+TQlAWVAapZKL4yBJl7nkTKU8+dbh4AG1SlYxXSGYdrkNBm5NdnpTrjZyNGXqH3+xKgdvqZHi0B/3VBo00rpB7ZCZpc/oLD4bYqqEIkjCZWq1G6ajHDO6vujZf1frM6AOczy8zmOZVA/qgjbpFXMzrdt2cxyZ+aMphk8Sh7+D5zAk/xDR/pJulXcFPxivhBK8RHP3Bkj+ElaDLlQlkfxV/aEpkIO7+GMfPSSTlXeo6SRG9pDi1+j3BYc3hsV10v4ko4Z0oS/AjktGjpOGUgWnBu3ZpsxYP8yagSuaY5XDGC71fGhoxiUfvTUPrmuyCr5cAt5A7VTOqxHeXPWpQlBqSPMv8u/UOOs7zIN2QLkJwTpF6HwqA0o3ixlYftOkTiwHhjfkx/dM+zpEzhlG/8bo3FOXrzLFAz6ZKCUH4IYZ/KJ9tD4iF8GPZ54Htwg+Fc/zPK7y68EtB+o+U755JmnZrBJiagQQrqqbFFViGxNvKtWCvF0a4ll2tteNwmTwDgKuB45+xEWWhNUZ+/1KbKbyELxCNBly3z3syNtY6L4HHXH3JU57VstvXibE7KAbWFiGz63y+0/b80gNDIBFKF39P79daK3xKRO+lNRVQmOPq0aRuBuNo0FfEzHgPdQ2d6bLIN0kNsjWEFtg4naPsskjkqOwZZyDcjTTRH8QTY/lBvDhFWDR8RtFzOK4zQl24wgiffgss1hZOXw4sBfHaYcQXZ/eg9sFU+SjS10jWJvGd72xy9LXSBJImEzbfnMqAmyAGIiA7aJlekMjMj9f/1+RV+BAUVT6SBEQ0ZWMSI5+sNj1XL/IGsxVyGl9S4We6JCYsgdUTjsQDX1fbfbYAGaMB0Ccw6+5VZieAkEQZOG4RC+ZPoD7DhTK43LO0IF77+NLCpQcHSMwzl1
 5ZPsFT0K
 Xfkr7GHg9TciOIxcz1PEhMoJcmoEz3UchyH5sXQgBXFge6o3/KtNnY7/Bix3SFkLWu8uV8bWuepHX+x0ifEGDC18dL1hkA0kw1OqAezd5EmniR8PJs4y8QzjH/X4uFTpdgbZ3T5ZT6LqPgbakcKd7/HBaqeXvhfH3hKhX/tPal+WDPI2J6wdQSOXmtiydPi4r7JJ030KhhQppQExqF2pzpW0RvJodLOx7rO0gOpwpCk9YAf4hhVhPxRBcBk2apuQFUjNyMOuFZ1fMoMQwPGtSPWoLOcScNl+r7iIkqztbiTzNDNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, replace passing the address of a stack
copy of a pud/pmd to walk_pmd/pte_range() with passing the pud/pmd pointer
directly so that  makes allowing folded entries to be ignored and
check the concurrent access proeprly otherwise pXd_same() would return
always true.

There should be no functional change.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 836f50814ffae..f771443cd78b6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3871,7 +3871,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -3907,7 +3907,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;

-- 
2.43.0


