Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2BDC5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F357C6B0096; Mon,  3 Aug 2026 12:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E116B0099; Mon,  3 Aug 2026 12:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F436B0098; Mon,  3 Aug 2026 12:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A79C86B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4825E160774
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:31 +0000 (UTC)
X-FDA: 85060531542.05.A15325D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2BF7E100005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LyPDW6G9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0pPxGq3j;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZqZzv3B+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="3c/5Zykz";
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Pm0s+AsqOaCIBBUGjt0XXuWc3EEq4aufaW3cPaeVBkw=;
	b=S6KZzkeDp9HuUk0VLPRb0nXNa47ajVV+OHQ3vkWXn3bbGYcCnNuhLi4ZH4O7XPW9byaIud
	4fhcSFHdy6ns9BUu2czS3niyvUpU4pwCdmEFTzTCLnUx0MFEIuZ7B9V71VKEI5LjlfmaoM
	qwsEeonVkd8yWANujOf5+FLSj71j0eY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LyPDW6G9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0pPxGq3j;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZqZzv3B+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="3c/5Zykz";
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775469;
	b=kAE1SWpjLC9EmjgFao0geSYQ+KW6KZHyfBuSQ8h7Ob+YFsp/3I2NGsgWoNlk6928B+T/HA
	tzTzokV/ptLMtc89pM+wtixz9eNn0wl26ZAOHbIZjRJd60nNAUEsoT3rnP4EgHjXUy4xPC
	y/fNOiPY89ghDPe4381U1BKqsXxf6yk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E0E447F296;
	Mon,  3 Aug 2026 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Pm0s+AsqOaCIBBUGjt0XXuWc3EEq4aufaW3cPaeVBkw=;
	b=LyPDW6G9DO9kGmtasy6JzDsxEZSL+/ubBLbvz3Y8qNNkybob446hHJmU+SzJwLthf2oydx
	F7WEPpZDlevxLl+BgjFpMJ2Skz4ogA7PB7lEhnXrJB6sVVypbi3MEvYm+PEZo5rszLXVUh
	8NrThPoWbZPX14llmWnWNWwnh/lpHFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Pm0s+AsqOaCIBBUGjt0XXuWc3EEq4aufaW3cPaeVBkw=;
	b=0pPxGq3jdZp1wnB1Eatpgjw+/kRSXRvgCk60qXhpqlasQ3L1d0XooOzJe4VKkci23lTTbX
	P3sTk++1EdyOpZCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775447; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Pm0s+AsqOaCIBBUGjt0XXuWc3EEq4aufaW3cPaeVBkw=;
	b=ZqZzv3B+eA7ZRC75dOzE0mwwaEXh8rvPayEdnndeVFAbgeqcDixEL/KXDedR0CnJaSiPAR
	Fv4RGs44Tkfq2aOSBwWqvxpphvDOPO7wh0RX2XKhep4EoEDVgyUjkeA4jV08kSJOLuvZ1e
	Hw4anHYdrF5R7wjzJKfUZkvUTku92Mc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775447;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Pm0s+AsqOaCIBBUGjt0XXuWc3EEq4aufaW3cPaeVBkw=;
	b=3c/5ZykzosMf4mcpE1rX0Os1q4KTcbsLa6uY0Vi2qu9zelcgBzB6GL1MDflLsucxbEvdnV
	eMcfSXv+xhYMVJBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F35D0779A1;
	Mon,  3 Aug 2026 16:44:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YvRMOFXFcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:05 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/6] mm: add basic PTE const type-safety
Date: Mon,  3 Aug 2026 17:43:54 +0100
Message-ID: <20260803164400.531199-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BF7E100005
X-Stat-Signature: ytmmb568fw3ig4nybbn74mmt4eoa3m5y
X-HE-Tag: 1785775469-574892
X-HE-Meta: U2FsdGVkX1/qJpm/o4Bzj9Z+5i21wp4vNB2GamDUBpM9r7ZJYck6hA2jh+lvE9TftCi8fiO7olhEwFF1+IEyuJDTV+KiEku67vKoy2rradP0u9lgH6WSORz6zIiubGnawh69tVzybCSjujFooHSdV3nMNWBxgc6YyUa4qjrfANqTD3Yrrtlpxi5u56NBAU9wVZuybfLdeqcw2C7stABgafOex5CJJlVPnCjtGVWTzuTRYOFHXYKodnu3iuh9+8s59wqkCR3V9774sbN05a0v6xMrlEJpX3FVAPGbqlkFeBIU6AdJ6NmgEeohaygdj31Or4YODp7qFN+VCPmP7qu7S81R7uMeh4RKbeFOC8+7PBDUoZYzJHjC8PtMma1cTlZLh465dglbbXUKY+AR6GSk7L1Tke88pp3ZvtVrOgdFwU5G9f46lPGjhDyHiKsKzITZ7b4NYz068bNeOo9vLKN+xIKdu7aIcQaZ0VVe8+qVXZ7tNP1TjzpzwlqsgcJtd0ayaZsYji8FoLLdWjIVE93suS72BYokiKuXBJqGwBYQbdWWfBiH5pbtroxi9C8x3ChpeN9e+JITZvsYKUzbdiEYcEzOuJ5WZY1Zng7pxX7dkuF4sWtrTbeYPVkzaIP5jlrC3bauzy8pDoBH5T/c1mToi/gkat8h8lAdjo7XXrLOgZEdW7Je/OsRoDyLs0sE0+2D7iHnExhtkAF6cLzOXbBv0X9dblK/iVmM5yCA1LLj+t/i74ElG6mtbxKMGK0hZpw9k+lv0ryeu1gnGp+Udw8geRHCf2G5FSPgNmvj/zajDbX5LcLT2TLat8zugwWfDlgliH7O/p47gkOHZR5Bpg8l/tPKuP55k6Oxj3cxdM+SgniX7KyjFvQ1RuHYDqgQRlEa5jfUK8pIjshtckz3hw+ElsOFDAn3hrMgxQuaZ51LTjWj7U+jFPDNF4zc/K5CYTaC5Q3Cso9qSB6tD0cjZ+t
 ri3yRkds
 r4Uzoj4Y5r3Ve1Lump4uwR8Y20v8RZ6gh00hfky8KlG0gvB8M3CvtLkcF22/XLOED49wW69hGvTavYb3M2WQqv6LfTxkV5kpHd9hw5wdG7kW+qmln2rqC3jt1yStXas6oExNNNU6Vowb54Io7apkwV28TSqmbBhQca3ev7scm0sBheJHT/SOKX1sko+KUMIwIBdFyhV8223N2iC3J+rK7yV8ZAHg6Vz0Rk8U3L5mliCeDeOpfqo9yNgf6cfAYmVyX5f5Nv6nV+t4T6YBM6GIHszigBQupxLrrtJrhWToAIKvMKCx+UqQcj9wWX74Z/afZVupEPe/oij3PfjWDNG2NE/JQFwZYnXyhVflwoV1pqfehUrA6OCrMpGD2zG5mUmwGK75Am8E3Xr9UxhlxA1GmaXEdN7A1xRlKCgZSkci5zGV5l+HbnRMzqkiauFdk6UJJ/Pf5ZQ0njfs3982MmjX/Dzp2YOwZUMN5LaUOdEnuI1zv7joFxImeLU9zenkxr4jqIzkW/qy+ALMX0C6QVXGn7a80+V2SFYTuOhOooe/COhaYEer4LY6msDCEPi454MagIfL7pBGN7HFRaGVk9lhMHXK1Bro09TC3uq5zjBPdH6kyQa09kvmr1jPucmt1A9zhSS7D2b8q/pg7Zyu1PMd1BMu7XTdEh0ajC+ETqu3mVFjPKPhMmnAVb0AkSjrU9pz3xqvmI94RBV/wnio2vi/5h3TpWVAK7JhzIB4VJEcpcf84JCn5ycDQlCEq6xjYxVLjRWhiTxhUORLHDKKfA1aKWZezwvChN0WYFUbkUMI7n+HDYvH+KeVkcOJIPBKCejpO/7ovKyciQE+Wk+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since forever, MM code has thrown pte_t * around with no concern for const
safety, or typesafety of any kind. This is confusing. Attempt to address it
by:
1) Making sure pte_get*() helpers can cope with const pte_t * arguments
2) Constifying the pte_offset_map_ro_nolock() return type, which by definition
already pledges that users will not write to it.

These two simple steps were already able to uncover code smell from
khugepaged + do_swap_page().

Separate steps could include introducing pte_offset_map_ro_lock() for more
widespread usage of this.

Benefits of this include less confusion and better type-safety. It could also
futurely aid in efforts such as [0] which may want semantic annotation of these
accesses.

Based on mm-unstable and compile-tested on a handful of architectures.

No functional changes intended.

[CC list editorially trimmed for brevity reasons; apologies if you're not on it]

Link: https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-0-eaaacdacc67c@arm.com/#t [0]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org

v2:
 - Small fixups on the arm64 side
 - Re-order patches in a way such that bisection is preserved
 - Pick up Helge's patch dropping parisc ptep_get()
 - Constify s390's ptep_get() as well

Helge Deller (1):
  parisc: Drop own implementations for ptep_get() and
    ptep_test_and_clear_young()

Pedro Falcato (5):
  mm/arm64: constify pte_get*() and contpte get logic
  mm/powerpc/8xx: constify ptep_get() argument
  mm/s390: constify ptep_get() argument
  mm: constify generic pte_get*()
  mm: constify the pte_offset_map_ro_nolock() return value

 arch/arm64/include/asm/pgtable.h             | 10 +++++-----
 arch/arm64/mm/contpte.c                      | 11 ++++++++---
 arch/parisc/include/asm/pgtable.h            | 20 --------------------
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |  2 +-
 arch/powerpc/mm/pgtable.c                    |  2 +-
 arch/s390/include/asm/pgtable.h              |  2 +-
 include/linux/mm.h                           |  4 ++--
 include/linux/pgtable.h                      |  8 ++++----
 mm/filemap.c                                 |  2 +-
 mm/khugepaged.c                              |  2 +-
 mm/pgtable-generic.c                         |  4 ++--
 11 files changed, 26 insertions(+), 41 deletions(-)

-- 
2.55.0


