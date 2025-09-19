Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6560CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2878E0002; Fri, 19 Sep 2025 08:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2CA68E0001; Fri, 19 Sep 2025 08:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A758E0002; Fri, 19 Sep 2025 08:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA2878E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:40:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F7AD1A0233
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:46 +0000 (UTC)
X-FDA: 83905958892.09.34A4A0E
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7216414000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=QH5Vv8m3;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KN44OSeh;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285644; a=rsa-sha256;
	cv=none;
	b=eiAne4PRKoE4DsxrHhlj3KFrzo+9Wt2l7v+EExqbiGsZfWBCQGr6lN6UwQNb0lShuU3I9W
	tlKC58YEvA5hRVERnHKhKuRwPHQJGHk+FaT45zFu9yYl/FKI0MoKpvjMREQBcSIlzRGgVB
	uWOj4kkreCHsBZypGP8V/IPAZuV3ZrM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=QH5Vv8m3;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KN44OSeh;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5ffMgn6FQ8q8wMzL0rsTpcxSZvUCmzDPBgGe/s15TYQ=;
	b=XWVd1zfUc7rQeUDOCUFvgPGUrsiXq35g59iCcDxY1TaZEAkdmkyESv7cB7ojwPhFYD1SiU
	8ggMYj550vgQPEhBCbzTbhYQyWzICVLrPuIdisqkhyfJHllVbH+EgWH0qYMx+JFkOqdfVw
	E/5UuD/faM+QQbaRqxuh5v/lxi8mYiU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id A0E78EC0312;
	Fri, 19 Sep 2025 08:40:43 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 19 Sep 2025 08:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1758285643; x=1758372043; bh=5ffMgn6FQ8
	q8wMzL0rsTpcxSZvUCmzDPBgGe/s15TYQ=; b=QH5Vv8m31EOxWboUzadoDGl0GW
	gz17AK5vWXvqWhErWMUsnW6EUNYVwtgU+5R8nU2I1/gi+oZkkpKeuva1gy3CbTQo
	x4ozQe97L5CikqvD7HYXi3nKoSTgHOtYfPfVzlFpsuvYr5+9NLiA5xRLyY+blEwc
	sNyIYpCEO203rfFjNId6eMjPu9xBr6+3srsGpfzmXuChAt2Hu+Wwh8IxOvw2V2Wt
	Ssz104yvqR7gl9lKk/RYw7r0Ggqgww2TjrCZ90bQE5PdJtv3Dc45LNmK3XSKunf6
	phcerSoZlkBSPN5sVOmHanHAh+YbTv5FQQazKcIdPBwbSSFzebXnRLIf2ESg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758285643; x=1758372043; bh=5ffMgn6FQ8q8wMzL0rsTpcxSZvUCmzDPBgG
	e/s15TYQ=; b=KN44OSehQvkxNLqtg0E1OFob8NKIhzpvw1RJpsBNDJEtKV3V8tx
	GvD4/WaclTmhewrdgYaRSgIqUGyhXQ4eYww9TzPtgnRL7jnG1Npdxc7z6txoayJi
	04Ivaz+LV92X1cBypkPxcBiL6DsqWo4RzUUnentes0JNA5Xw2DAvaa0vO+yDh/cW
	OsDaU52Ii/leuDHnVXniEtR1kWF7XUELZWv0ORVBIUpFSgGBMXEImAgDCg7hm9vh
	WSQxwHBmuyeyYIJP0U5eReaTrzoU76s4rNDxURo1f7vjfuElTuoLvR6uFXrVTFp+
	eutP/3MIFcQuPoD36GKGn2+coIekH4/UcVg==
X-ME-Sender: <xms:SU_NaH5vzBLDonSspRbyQGhQcl3hF-5tNFWmaV0Rm_K8lFUN6Ho-vA>
    <xme:SU_NaOZIQHw0WGXtEVTo3B1msq96Cgld_9qLO07XSKMLMynx0nhjaZeFeFSGFaqlu
    JbTrwIH0SMD-Ur8o38>
X-ME-Received: <xmr:SU_NaMGGi3M8IsgUSToVwguv8sFqQqyngGH3X_SY88Z2WHNZGQ0svH5k-l2W9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegledvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrg
    htthgvrhhnpeetffduudehveejfedugeektddtvedthfehfeehteffleetieevhedvfeeg
    tdehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudekpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhr
    tghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhi
    esihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghk
    vghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghp
    thhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesgh
    hoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:SU_NaPl4JTKKNFiSytw23Ftl5LjnMJRiHJ2szK4DSKG8zTEq4fEQdg>
    <xmx:SU_NaLnTWBULLdvwxIQUL_wiTKEYleJZAv40Zcahc4iNTdCBrRYWbg>
    <xmx:SU_NaEV7NczE2rYtl0xLK5upqNyz_qYY7KH-4nWBvPDlyWJI4KIvXQ>
    <xmx:SU_NaJ8RPNtkhAILe1nYtpcmPc77xmQbvUkwxfOS1352TNgOE4gxmQ>
    <xmx:S0_NaDBIHz6JkTOxf4KonVMn_PB8Io-leM5eeoFdhkzs_bObbxq-CUBf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 08:40:41 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 0/5] mm: Improve mlock tracking for large folios
Date: Fri, 19 Sep 2025 13:40:31 +0100
Message-ID: <20250919124036.455709-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7216414000D
X-Stat-Signature: euo4z985gbjgiqko8y5ojnjgtpq99had
X-Rspam-User: 
X-HE-Tag: 1758285644-169014
X-HE-Meta: U2FsdGVkX19pCForg7YQsP0sEwvb45qPt+ddZHYqTr43q5eutFj1FdAq+yxomCl005jATnA1HzMzNnjVnD6qmWHNfitdcGqyMD3B7z6JkikKbdoy9ZpAprP0yy2Af5FB/4pX2R2bmfm53wZ0Lj9uGXOCZkVVid1PxBxcvVThR5tZtkB5QJTmUJhaOjgvV/BuwrcFa05auRe6yQ/+jl4rMg31tI4qWT3DktXNqttlG9BTDdC/F98nfMbhb22Xim2Yuk/cjG9SS3+jwuK8p9O7Ok3Jdmur8IqZkRPbVrODmTrYPTanR7RG+Y2Tgy5oipmetKcjEfMkaofQ3fKAOoqgJJu7qPSmFjHPqHJ1FHbohMLvHZHu0baTGYd96s6VheJqFtrIpIxXUWxcXXvnCMHbK/pyx6gP3RMwRSu2/PFLAwGdGAnPhKNmtc66tcvj/wWnRuB2EiH4oPbkoco5C4M/NK9Yr7SKxkYIGHrWkRBPljHd0I94GkDRiB+EuoTbkbqsCg6vQccGLei/9AzEuF9bgsHrR934LcS02BYKkiftxikMXQKtoOJeDp9JtqFp3YoshK85JKhBHUJVBGdx1cX1wTqxeW0vACYAx02Z8QbRuuEeSEdEwyJLz9Vl018OlRrab5VK/1D8rtgeXj9ymU9lAqhkl3uJtBXtzAkJGP2UjMe4IGJ/UbgltAJWFVmTBnUOxqxx8Ey3lCHK3QA2pkNYPSNvFeJ4aFGi28LxJQmVkNdzNhViI4PMT2XFge/dw3ST0wNh9rSxFjjb05S4uKHUnWWpwKX8nBna/XmHinmEulzbrfQXhsmJcq7W1yM2hgi0W0YMqv6yTM3Ca8yJDxZucGNzRNgXnv9Eyy8QO/4LCT5I4S14kKcmHJpwvvau+kEesGVLijRjgLvYiJAZVLQ41ui18yaz01dN2jGKWgQd3oKN2QD4DiduuYtCIIKAv8dECb+l89UPbnZeqap811/
 cmxZvqDJ
 FBihJ55hQTkFDQCZEFLrFUe1S9uZZcyE8HUejifMy1/sRSAtlHHfYGkpzO8d/0W2gAPFMkdTnknOUdav1KQf5AqLIbbiHu+ObVKE3r5+4jlJ7XPBUhuil384xPYqRrdq/DmOhsvxVZgmLg2tz2Qk5GXMnXN8YX5/iRL/CuS/hZmIW05J6h2a6dKVbx0nlbORwuBdERoWjS89r13YjQ+CocS41eIdll1HbzHUZzoz6tOC+0SfRh7FBpjsphWbwZXNV8MfQjZTI55pN7mVtOz2zrNdCQtaoiTseADoygGWH/6aMY7wsKllSVB/pX93+27ys5HAWo9gMAGdQVCJ+bfT6Z2HFWcVw4Y9J/vDXsWHz04xiAzL+bZbNnOMEbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The patchset includes several fixes and improvements related to mlock
tracking of large folios.

The main objective is to reduce the undercount of Mlocked memory in
/proc/meminfo and improve the accuracy of the statistics.

Patches 1-2:

These patches address a minor race condition in folio_referenced_one()
related to mlock_vma_folio().

Currently, mlock_vma_folio() is called on large folio without the page
table lock, which can result in a race condition with unmap (i.e.
MADV_DONTNEED). This can lead to partially mapped folios on the
unevictable LRU list.

While not a significant issue, I do not believe backporting is
necessary.

Patch 3:

This patch adds mlocking logic similar to folio_referenced_one() to
try_to_unmap_one(), allowing for mlocking of large folios where
possible.

Patch 4:

This patch modifies finish_fault() to fault in the entire folio when
possible, enabling efficient mlocking upon addition to the rmap.

Patch 5:

This patch ensures that rmap mlocks large folios if they are fully
mapped, addressing the primary source of mlock undercount for large
folios.

Kiryl Shutsemau (5):
  mm/page_vma_mapped: Track if the page is mapped across page table
    boundary
  mm/rmap: Fix a mlock race condition in folio_referenced_one()
  mm/rmap: mlock large folios in try_to_unmap_one()
  mm/fault: Try to map the entire file folio in finish_fault()
  mm/rmap: Improve mlock tracking for large folios

 include/linux/rmap.h |   5 +++
 mm/memory.c          |   9 +---
 mm/page_vma_mapped.c |   1 +
 mm/rmap.c            | 101 +++++++++++++++++++++++--------------------
 4 files changed, 61 insertions(+), 55 deletions(-)

-- 
2.50.1


