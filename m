Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2AC606A880
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jbvSV1cj
Received: by kanga.kvack.org (Postfix)
	id 227E46B05B2; Tue, 17 Nov 2026 04:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200286B05B3; Tue, 17 Nov 2026 04:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115D26B05B4; Tue, 17 Nov 2026 04:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6B8C6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:28:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A8901C3A83
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:28:28 +0000 (UTC)
X-FDA: 85444085496.14.9097042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AFCDA100003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:28:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jbvSV1cj;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907706;
	b=YWpgyXnvRdpqk0vhWCP+8LgYx7EhaFzEwOHmsWv4JTmTzynhA6X9I+b0BOdwFWo5m3+p88
	DE/toQa7GRB0iBK2rhbJdNp2rV1equFIFWg6qA4iPuxGZdltYVCdWvnzsNYXQLBKwTOg8C
	KrdIecWEd2/RiZTOiBYPybNwgZ7emXw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jbvSV1cj;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JWFRXkfma6kJ/DdhTdP8QnpGxO6I9Q72iA/ysnVQGz0=;
	b=EHPY267QWr1IP2XuOxMBvAhzm3k8etI50ZH5V8KCyu28JuiWCRh7YM0MYkrXfY9vnje8FG
	66klYUAp0LibTemZyzm+7IlLKM4aon8HixVJo/3mew6iZ3ayVUeXpViJbk/um08+WFAhwX
	VCr9xhpStw9/Y3gXaBghooJHuBWu+4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E399A41A22;
	Tue, 17 Nov 2026 09:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEFC1F000C4;
	Tue, 17 Nov 2026 09:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794907705;
	bh=JWFRXkfma6kJ/DdhTdP8QnpGxO6I9Q72iA/ysnVQGz0=;
	h=From:Date:Subject:To:Cc;
	b=jbvSV1cjrsKP/qSvWAPv1cKLjYo68GOAuhqUUV+X/UaBiE3CC38LaQywuesl+u699
	 8pLOs4l0099QmrGyfF4j1f83xVpk8ybz/nkh/1PZ51zaWUqRIIzTmu91GvCz9TSGQB
	 o6zO0hZW7q7Cns6vMwZqtwN24y/wJ//KrCwBtrEgY2FBA3zpaFAYjXtu97262VEYlk
	 Z0vVyNxumCUY/QaoKqluttIEUs+12PVNJMx3JKqzcEzPgi+r8mLnctXmqC8SWGllZq
	 CrOJrpFR8+Lo1DCTgAuEOwkD3JxsLbw+Qc7IvX2K4H3ppjELK1X4thD+GKJtIbA6Z0
	 DY7FduHR37bsQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 17 Nov 2026 10:28:18 +0100
Subject: [PATCH] mm/khugepaged: mark ptes dirty and soft-dirty on mTHP
 collapse
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
X-B4-Tracking: v=1; b=H4sIADEe/GoC/yXM0QqDIBSA4VeRc52QFjl6lYhwedKzUYna2IjeP
 WuX38X/7xAxEEZo2Q4BPxRpXTJEwWB0erHIyWSDLGUjhFD87TaLXls0w5ycHwyF9ONloyZV1aZ
 6aA259QEn+t7frv87bs8XjumawXGcML2iXHkAAAA=
X-Change-ID: 20261117-khugepaged_mthp_dirty-067f734d38aa
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Nico Pache <nico.pache@linux.dev>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 Daniel Wade <danjwade95@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2705; i=david@kernel.org;
 h=from:subject:message-id; bh=pWmy/78IyBmo0DcIlSiiIb0hh8w6aq2PIN74mUuISOk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+yJle8vm29ZbDB5mXOqzSq4v0nv1+uePGacMHyot+x
 ESKsBoc7ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAim+4wMjxSW9adcfTTLlmz
 U1O+RD09Gr9P5NT/tSw6Xio8L606S74xMpw/VV/LWcrw/kiGmML8eWbP7kftKlko17Yz+eXZqwv
 dNnAAAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: AFCDA100003
X-Stat-Signature: 8asq13xa4rzmn6jz9jgm1bg1ft3g5dcf
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794907706-68287
X-HE-Meta: U2FsdGVkX1++eixrtBxPVtM25cmzPw+pwj/cvgwutVKmQOY4bqi5a4mbWYPHbnSoqpFBIUdxsvkohZkxs/+oPsjciYZn+6kt7f7hYG8cQdtfLLzJdNgpE1O/a3EnW5f4jUPgb5POTUrhnRpYrcvNSrt0JbUfzwnehj8TTsxzc/hTTyG6VaCfXWtC4DjAHFZX0wtPsALaKohggRxWAWWmPSquG7nZCUjBVbiJtABofctk/FSb07nkdcmee41xz1Aa7HTKpha2ehronsSktGthaHOLQ3Lv4I11ttNX8rTna/W2SNn6MSbawD0wHi289bcft/LLiLfzD4f/7sbNhEKe5Fj1YIietLg1iYruFkVNcOp3toAGoUG9Fo7BQq01zwt/92uu+FvHjzRKr0wHFbrApinw+Prf6l2sorU+Io/ZO1kDn6gw5mkNYoL+IaYkpQR7dekqXOPHOXzxZzgK7tfstk26ADZmnuQB8fyGbNUxGHszbisZzx1yPAcjQ0f5dsmI53p6iELjNo2G2+L0QXO8ush/8gFjf8YG8j4l1rhPXt5hLT5jjuLMIceJrRyxb+BUoexOXM93e4Ta/ZqDaVkVWv/IsKiC1FpT7JdvkEvZgtxfwV4UbIu3uc0eUhP17/g1i8kJ/RxydWQQRg5GftHXeXbtr6N+Ng8moSn2lK/fm7PPuZRrMkboHYicUayrcnC+QE3IRYvj0te73bQoJVdTcsHmIJzsFNhGPooyj4Bv1oz6MjMuVYrRyVifsqR1Mw38gVa0ILrE8wwrUpd0kTbsjgaFUbGAKF+3z8Ddd7mkgDK4qk5noQ/uO1YSgQrPvCxbCGkvXSK6FLRWuZ7llMI8lIv+7qdCalBfGcpw28vmxls0pQIMWpM7kKFVCrVihs/8aPAby2m2Tohxqzdnqkbc2IW5vxw9lK67yJWlQDrDBLqzk/WV+qjoVk2CjAK6bBDsto0f1lBfKAc8xQ+L61Z
 WbAm5G/i
 nIaQYiYvslRyTWp4/qPnkLkwOMMHuWBPfC46biXBiw7gFsFPi7eDjBw+NcVZ7V1M4n7W4q6eDWEve5rJB6ft0Ro8nKJceiI66+DQLAo/1Zrd1Rrbbx9Rl9Cc/EkxxyDAF+VQpt+NxJ9CRWPliaN7IIB4Bx76NAza8Fy3PE8ujdZO8YZJJzhPwEJuJsUJf6SQvv9rWXYactGSGJW6vxj0AN8+DtDAl46fuLO8nvBpfZcluedWpHG8zNrtvqD39Moxpcdk1AD+fJii8EY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An mTHP collapse can lose soft-dirty PTE bits if pages were written and
the VMA was then made read-only, and not setting the PTE dirty in
VMAs without VM_WRITE can interact with a later MADV_FREE on a COW-shared
page such that all processes lose the data even though a single process
MADV_FREE'ed it.

Collapse does not preserve the soft-dirty bits of the old PTEs, so the
new entries must be marked soft-dirty. map_anon_folio_pte_nopf() relies
on pte_mkdirty() to do that, but only calls it if the VMA has VM_WRITE.

Further, after CoW-sharing such collapsed folios later, all PTEs will be
clean and the folios will be clean. One process doing a MADV_FREE can mark
the folios as lazyfree and result in all processes sharing it losing the
data once memory reclaim zaps it.

In map_anon_folio_pte_nopf(), call pte_mkdirty() unconditionally, just
like map_anon_folio_pmd_nopf() already does with pmd_mkdirty().

Consequently, we always mark these PTEs dirty (including soft-dirty) but
only set them writable if the VMA has VM_WRITE.

This essentially reverts Hugh's commit 1ac0cb5d0e22 ("mm: fix anonymous
dirtying") that back then touched do_anonymous_page() to avoid forcing
clean anonymous pages through swap instead of discarding them. This no
longer applies as shrink_folio_list() allocates swap for ordinary
anonymous folios and unconditionally marks them dirty before unmapping,
regardless of PTE dirty state. Keeping their PTEs clean does not make
them discardable.

This now also marks fresh anonymous PTEs dirty and soft-dirty in read-only
VMAs when page faults allocate real pages.

This has low urgency.

Fixes: e22f2fe72c74 ("mm/khugepaged: generalize collapse_huge_page for mTHP collapse")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reported-by: Daniel Wade <danjwade95@gmail.com>
Closes: https://lore.kernel.org/all/20261117075246.61336-1-danjwade95@gmail.com/
Reviewed-by: Daniel Wade <danjwade95@gmail.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d2f48d78b0d7b..45875d1d3b3df 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5522,8 +5522,7 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 
 	entry = pte_sw_mkyoung(entry);
 
-	if (vma->vm_flags & VM_WRITE)
-		entry = pte_mkwrite(pte_mkdirty(entry), vma);
+	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (uffd_wp)
 		entry = pte_mkuffd(entry);
 

---

base-commit: 1c2962a57377c9878cbefb747488324d4e678982

change-id: 20261117-khugepaged_mthp_dirty-067f734d38aa

--

Cheers,

David


