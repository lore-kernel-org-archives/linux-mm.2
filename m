Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69AA1606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mt/n0Jtc
Received: by kanga.kvack.org (Postfix)
	id 15A8D6B05B3; Mon,  9 Nov 2026 07:04:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133796B05B5; Mon,  9 Nov 2026 07:04:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B686B05B7; Mon,  9 Nov 2026 07:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4BC06B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:04:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6645E1A0675
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:04:20 +0000 (UTC)
X-FDA: 85415447880.16.E662A80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67AB31A0011
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:04:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mt/n0Jtc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MFiKRgYbDh7TYHy8nV42WRITeRtyQvjTK97N2J3pK4=;
	b=W81G4yYc4RHuMAIprYBxbsafEY+04YG82S5cCgK1kwcpshCRuUjzRzRL5vGn+Y7p8zK2SJ
	EpUZB0cgCwzaNeHV97cXgSyIYGh/Pmq6tIVwteK6SohbKgEMVSCUNsEheT8aO7pUvWGrmC
	dbom913BqRMMiZ+0RSW60Rb5rDh7HGs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mt/n0Jtc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225858;
	b=lKLutCCfXMJ5VqU9NziRiJXlPK3GQdLXJoSMZX20gMZPHOikf/GauU8Ds42EENVDwXMjWA
	oeUdwNKic5Jq5Qid+HjqO80F8JeEj0PfEpyRKhCVrITRAuQ0Y+IGA4Nljg99NIt+ZSHbpn
	zphL+HAZpyPZiS/2WMXQ1TPbcptMnCM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6A9845898;
	Mon,  9 Nov 2026 12:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871651F008BC;
	Mon,  9 Nov 2026 12:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225857;
	bh=6MFiKRgYbDh7TYHy8nV42WRITeRtyQvjTK97N2J3pK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mt/n0JtcC9od8cYxe7uDVecnAvAxzv/cU1Vo0IFHPMpU5MiUkxwu8omUODYV5Zcqy
	 LPX8//ZdfaIcEutLlmY5Kl1GtVoLj3HA82/9bm1IEnetSW/2or2GYtn3PaLE+MB4f4
	 WXPnKxkV6rWmcOHXoc5U/1ljClKcmA5xOi2nfngeSgAljF166tDnnUUvHZk+bnGujy
	 PHOHKmSOOXgU9+C2CM2VhhYkE+B6tXrXGnVSRUZyPBUHBq7kwO2FZK0lXEq1rwwaiG
	 /P4Q1Zi7GWkjU9CePeXr/asytuVD8lPk2+vkK/lq8NDBGh4XsNjgcYpSSBvnjhcIq0
	 Eu4SJ9xHJUwVw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id C3CC2198003A;
	Mon,  9 Nov 2026 07:04:13 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 09 Nov 2026 07:04:15 -0500
X-ME-Sender: <xms:vbbxas7vTZ344FZodtk9B_zvzXKOzJFB18lU71dHyERZnO88I0_QbA>
    <xme:vbbxanR68IbNzBLNyT9N8TkeafL1bK9hE0ojWsPXQ3r30Tq_UeOfgS2OaqQYbqSdI
    sqIVB5TBcuz-wdu75KcqvnG6SxRiWwHSx5oPHe3kP8qQB0xHl_IRVsi>
X-ME-Received: <xmr:vbbxaj-ZV81kczXXLZ5HYmfOgEUxfILItKX_4OH16YTcSpFP95k9IgoBAvQ>
X-ME-Proxy-Cause: dmFkZTFNHiUwdQBBta8BQiRQNiL+3aFxYBCGleH13rK/AikNGSSC3QUGqUhmGxAnWboa44
    Oxa+oNSrcFePVCLQ4GNJqtcYf4GxsV9GMptj5ZrpOImzhEVV24EobsIoaE3cyqt1HUzWKb
    uvK/vFY8P9JVFvAY4sv/elH4sBbKNz8TiTp9kbnxQZ5ar8JtE1kD6OyBHc5nmptdrKWCE1
    SHUchB4wZ75gxD0AKiAsvr9dPbzNysAsG0icmsqmjFSwMuBk9eg/M1NxwUGV5B50W5JtPi
    mSSRdlKYNHyBf92yjckRvTvKXC7OSPkjnpnydQqAEDttujjY9r4EKzHT66M2V7UmWGi5er
    ikZqmnu1uDnQHyaxkbjc46ZO43YOdBKQ1RH9KKccapbaOK3TTnl40pdbE/fr9DYpMhsTps
    j7HDy0qRpYPcOYLrtTF/1DiZ5inJTQLs8BJtHHXRT5o3uOQnNATpLAzreKbBQmMaTgZw6n
    JJM8vVVipFfCsj7/JhuP/uX+ZPPZzqzXlmahs13aSfSACRHNO+KiV0rP04PsMuhmhNVCxa
    6VEdZqnX1y4cB2i0dapKU/4yUbSBi+QVM7HrT7Yveslwg0KGF7iTSXxum+Teq0KUQ1NQOK
    eGPOIoU54wqRC/DFCItRABfTGoQHAkcITex6FYgamEzVAu1nbJ3frcEw+1Mw
X-ME-Proxy: <xmx:vbbxagpYR0bJyBxZ5WUcSDYmTyQPfKgTDoWexdv4F7Y28rMEwFXGWA>
    <xmx:vbbxahV-Xrm1KZbHFu6yVMLQmpdBhLtQmBHvAIfygaNVaGh5tX-3mQ>
    <xmx:vbbxat5WYPH6be4un4C-Z1rnHjk0rPA4jLt3YvBnoI_yMDhZyO3vxA>
    <xmx:vbbxavASrqab1Rwq6GkTNevdpBpjcqA-hV7oQdjlEneqU4vwiVKAVw>
    <xmx:vbbxahdvpjtgJfsfZzOe8dn5eYMOllmn8MhjVXQxWUJ5zoVw1NEar4-G>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 07:04:12 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/2] mm/memory: refuse to map page cache folios that are not uptodate
Date: Mon,  9 Nov 2026 12:04:02 +0000
Message-ID: <20261109120403.82361-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109120403.82361-1-kas@kernel.org>
References: <20261109120403.82361-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67AB31A0011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w45pn5uhdjz638qyypm944hiweytnn5b
X-HE-Tag: 1794225858-578147
X-HE-Meta: U2FsdGVkX19GwOC8WV+hcrXAEtbjGCzbRsCQ2FIM9CqyVG3m6SwFgZ7p9EiEFVeROSyTdfjxKTKH4sZp+bDxnPd265rLtU4Ke8QgEZ/Q+oQCdok/BUDFAMgcTgedCm9pDqaED8V/d88eI8hg5ZDE0l0ZGULJ7rhSQKW4tL4xatYghD/mCP/6sS8dmId8erfK2Kt5me0aVwDXok77mmbsWINofdpDaAubZw/+tf6F7PxpUL2gjZHTXJfwCmTgCEK8qbY4RxnU87eoP9yds+sYaVK+wU1z4SEaLPTQ3vZyqTkL4T+7aRH2UWmI77/7ZitVROUZGzlNSae7xksnPdIxFk8bfjcBEzSBk/iVKl0vyCpvSHqQesfMFyKRVNzt7vy7P/LoI8iTDz6rU5r0l2KffRytLWSIRdL8DcFDpuyoLodDV6mkrNCMCX8CcT89H2UPZk33UfkRHDEXf5NZk62pajMjVhXYcsR8h7el4c4yN5jr7T0bK+wqUQ5pj6sNrgY0lK0bq0iK9UKGL7vE0OndkEoc4WM0AVQlHWi0zuYMTQEBZOLu+kjy6Hk2rp62p8BEJru7G5CD/YQUP2PDc48FYfWxireovTZ6+sFENnybMjDkSBN4RPdPMi+BoP2rVGhvmjTCVoUbo7OF1wABg6v+zMw1S7pXl6AjaUEcMNIw3ofv/D09UgcJ8XsmHDLHID/k3g4xNjQtafhNkVF7C3GhhmkkHki/lTYgulxrD5WpkCrukUnU5xF493pFExq+U1PgRnini7GaIkOO+wUtA7XgwGLFRkilVbXN+TrnSF0zBmQifuJiu3hC5YD6b70L1bmnCjy8gdX2AfkDuLs+QElD7mmG8sb8oW3+pVhycZLz8GBeGrIqKhVG1Saz6Xu0yb4+H8MY9NUW+IMV++19Ni2f50xLr1pUfufxe42E2QMDc3NrmpE7/ls2emhr9xRPOM+rops8kOriMMDkS4PF6KY
 r8+NNEs6
 iq7bSdCF285GFIAPBZr2HcRBUk/ScHSYoqAnGqAX96JW8FxLSWAzX1Snut3coAKaBoNulHAHCxzuuqNoEiOEMmwO16bC81ZHAE/C8EM2POnsiO1yfyh3gZRIBw5S9mX1dNfZKVaxO4K5L+U5fHIrE7Q+HGDuwdX9ZGYMFJGOHCzlu3NLwB1oB/WZV7jp90gZt8jxiviqH+UW3BD/7C/fZISl8zDuHqwMQOQOnlmOeZOebRugKZM1inWJGLR/SU1aXUrYe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A page cache folio that is not uptodate holds data that was never read
in or cleared. shmem fallocate(2), for one, adds such folios and clears
them only on first use. Mapping one hands userspace whatever the memory
held before.

Each path that maps page cache checks for this itself: fault-around in
next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
Nothing in the mapping code does, so a caller that misses the check
leaks stale memory silently. MADV_COLLAPSE did exactly that with
fallocated shmem THPs until recently.

Warn and refuse the mapping in __do_fault() and do_set_pmd().

__do_fault() checks the folio ->fault() returned while it is still
locked. do_shared_fault() unlocks it for ->page_mkwrite(), and a
writeback error can clear PG_uptodate after that; that case retries the
fault instead. For CoW, __do_fault() sees the page cache folio that
do_cow_fault() copies from. do_set_pmd() covers MADV_COLLAPSE, which
maps without a fault.

The fault gets SIGBUS, as for a folio that fails to read in.
MADV_COLLAPSE fails and leaves the range to be faulted in.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index cc1d0b7d15c7..2324c04d632f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5684,6 +5684,13 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	else
 		VM_BUG_ON_PAGE(!folio_test_locked(folio), vmf->page);
 
+	if (WARN_ON_ONCE(file_folio_not_uptodate(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		vmf->page = NULL;
+		return VM_FAULT_SIGBUS;
+	}
+
 	return ret;
 }
 
@@ -5727,6 +5734,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 		return ret;
 	page = &folio->page;
 
+	if (WARN_ON_ONCE(file_folio_not_uptodate(folio)))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise
 	 * the corrupted page may mapped by PMD silently to escape the
-- 
2.54.0


