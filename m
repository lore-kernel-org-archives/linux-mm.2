Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634A1606A327
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lg7sNeNI
Received: by kanga.kvack.org (Postfix)
	id 854C06B05B7; Fri, 27 Nov 2026 14:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8046F6B05B8; Fri, 27 Nov 2026 14:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCCE6B05B9; Fri, 27 Nov 2026 14:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 264796B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:46:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7ECBC04BE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:18 +0000 (UTC)
X-FDA: 85481930436.15.FB7D64D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF5832000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lg7sNeNI;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795808777;
	b=zwF0wwgQ3JaE3SExzhTcV6v+UER5QUsNPtgKAmB7DAkijXvg0pd4uAka0O8f1/1mfw5i8N
	KeoZn4POIrvHtJx9dKp3E6zkFxhULv5MiRo1t4io3oeV24epX8awXoinNGCUVYPE8Or8Zr
	qSp1zU6JU6GptNcy5VTyvXKmyl4hvss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NovJGN266ut6F/KwSsg/fm2bkFyGHYseOOEgSUk+sW4=;
	b=kbvULW1KkFbBd91lQIHAT7OnjGY4OHS68kXP+8gw1w7efsmeNaCO+zQLWlWPPgH7LlQXKa
	1KCd2h4txS0jGgqSUSnyslPudiFjqNeFi9++6nVmKFca3uDFcX0cDe1Td98p8nX+54RADV
	Bt/n4ZqyBXX/EH9A7gDMdSrWopU/aEo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lg7sNeNI;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AE5E62061;
	Fri, 27 Nov 2026 19:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F3E1F0092A;
	Fri, 27 Nov 2026 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795808776;
	bh=NovJGN266ut6F/KwSsg/fm2bkFyGHYseOOEgSUk+sW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lg7sNeNIUPTLyrjv0EQC1PBspEKQpD6mwCDWSe0TIl8OUTaKxrQvTa9oZn8m0lEPt
	 LG7WqcGDK7P76nO6qXoIpjrAV9Wu8GQD9UOzldNpMNdbQgvnhiL/D9vsQ4KOxJU4VO
	 sdjsmG9WORMUEVCJmPdXPr5PYReDHbOeZxsdHZqYJ0VdrnY3fabVPkHuD5vbsT///r
	 NIQUxNbxj0aW36HlFkBkXp0ehzOYK7F3HVaDu1VYXQ6QQszr4GLlktKdl2AFALoL/l
	 GJPoG6h1d1ImoSzzaBOpvl5bPS53BnGEfQMMgQw7W15ijNUqU/Fnh042AV0kWlVHUE
	 3kpW9Ym3iSoUw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 27 Nov 2026 19:45:42 +0000
Subject: [PATCH 3/4] mm/mprotect: fix unpaired notifier start at address 0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mlock-madvise-mprotect-ai-fixes-v1-3-e46b2b1eb435@kernel.org>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Hugh Dickins <hughd@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
 Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: codalist@coda.cs.cmu.edu, linux-mm@kvack.org, 
 Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1583; i=ljs@kernel.org;
 h=from:subject:message-id; bh=hFazDhUle6ZFh0ivxxT92eZdFw5uAZSRMAka/e6BWSg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI57758919GLy626I2RXH9E5e29tXOMJRsnuL3coLEl6
 +qUWSZfOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRtNMM/2uy/9Tt3HfOrNvH
 XCOF437Wm9SnbhqfI3nTtde1XhH7sIThn74pb+xRjcsX9oVf5NhvmvrgzMEVbvOXz9iwi1Pi+5u
 iNAYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF5832000C
X-Rspam-User:
X-Stat-Signature: 46otd8mjr6qa4gxcaxnitiintyxwq8xg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795808776-435126
X-HE-Meta: U2FsdGVkX1/1Z+zkT6G1g26bly8fE3LMpi1ah3F5JGGpHAobUj54FvHYEtOWenO1bvI7TlV6NAVF7m7pz/vqplCXNLjjAHM2x9l95fkXznMPHFnCnkzmTj9M8AOkkJQq9+e+UlJ/q4FsT/YQURj6qv4N9Yt4LUPhZFtu/It48rd+Udpp9N0BDdB08/1AM1HEV3FQN0cv/jK3UTHOeEk+/fZFuA37stq9T/Lm3d8xU6DhJtgQRExXIkgO+JJzao269ENSFwkUwUhDul4UINu0Z+a7WHAcKku/Uw0q3KEfJ44KJ/RgPFJFbttgsuD5cvgqiXhu1c6oC8faUIqZ4x2PGTLqA2mJCymqUwVNGYa156UCZYxUdSdCRL943R8rLko9W3w2nhLrBzIg3pfIAYesA5wpuDBtiFDar1fvbgAmy5s4OaPzmQhmKtJyYM8uWg2rzOou+1/KIiuiQ7/tT4NtCIoN+FPdO8ML/DXJ99M8oeeUywSutznZBAQ9vm3YL+GMQz1Gxl0QkISrnUcT6CJDrqYAdZSSXNZF7IZzctmvgNyfH2xMT+crJhAiG8LPpVYaV0B1MrS/wfZF7Bjwq0DlnIswFIkEAhJHDhpEB0dDVYfti3FzF7spgPwaureNaGTZUe7VT6bO8DdVQpGvUVcem6lTJoVPPBxRANHPJ1DpT6hW2rV8cK4F9hoSwebLyfLyWbn8jXxAocezOBFVln47I8ASjH8MDwSkOD1PGrm1sgT/+0SDHlWzZRP7c1/AOw2avRQw/jkch2ztjj64KvGs0ufFOzSXrMJHBDK4g/EcseX975oq+YM/Oz4CYL6lQR7/q6Pb30AlPa3apIHxVhDVvnD3pjK95Nt+sBhu3CEmXucZKnLOV6nXgS+qVQbusb2YN8RbgZnQxv3Jy4MVNm6aBUFMGjkdLMXtfAWaql0wLRhc6y2wujxZTpQgYXsJA1vInrkpkQmd++qe29z5Di9
 jH8j/4rx
 T6FQRKkIFczUoa2jBO/XUQahdLCXyPFu875yElRiGkZZE1+O7cpZAYjgagMxFnuLvgzrYrYcNaSbSh9578kYfVGpMlczfSJyQ//kVX/UN5jUCCgOyGA1frLYqCw2am2awVEy8k1x1BZNiTx2yBbMKUJ7pAjMtSJy8xiaLBH24VWyC2tK/Azpl5LQiaUEKlAG9TouqBEtWoqxD/S7KxJkaJ9UsWegIOAUM0Ort5fxDY7mv/3NVuogHUCouLord4lyAX07IJBPZciz0A52tCcE0v8jmL39YcTQx52ha/dN0ME8TBtwd3SNdjOHsb+BceDelrLoITJuREMCnPwXRpePetLNfRzeDOzrZoqigngDaVYufR9XqIDS6cwwlRbV1hXQMTY7IulsCWHJEYPMkUoRCjlfaZQozNsj9s+wS4AxWYM0ZvxLRNYqde3rr+BhcepNiKShh1bacEdMB31KjuWwMWKac/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A protection change on a VMA that starts at address 0 can leave an MMU
notifier invalidation open forever.

Waiters for its end, such as kvm_swap_active_memslots() and
mmu_interval_read_begin(), then sleep uninterruptibly and never wake up.

Fix by using a boolean value to track this instead of the start address of
the range.

Fixes: a5338093bfb4 ("mm: move mmu notifier call from change_protection to change_pmd_range")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: commit msg tweak ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mprotect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index e18d4e12fc34..0f94b0287895 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -579,8 +579,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 	pud_t *pudp, pud;
 	unsigned long next;
 	long pages = 0, ret;
-
-	range.start = 0;
+	bool notified = false;
 
 	pudp = pud_offset(p4d, addr);
 	do {
@@ -596,7 +595,8 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 		if (pud_none(pud))
 			continue;
 
-		if (!range.start) {
+		if (!notified) {
+			notified = true;
 			mmu_notifier_range_init(&range,
 						MMU_NOTIFY_PROTECTION_VMA, 0,
 						vma->vm_mm, addr, end);
@@ -624,7 +624,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 					  cp_flags);
 	} while (pudp++, addr = next, addr != end);
 
-	if (range.start)
+	if (notified)
 		mmu_notifier_invalidate_range_end(&range);
 
 	return pages;

-- 
2.56.1


