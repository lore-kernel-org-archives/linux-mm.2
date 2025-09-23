Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2783ACAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5E28E001B; Tue, 23 Sep 2025 07:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D8B8E0001; Tue, 23 Sep 2025 07:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4508E001B; Tue, 23 Sep 2025 07:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 469E98E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F02D1A0477
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:20 +0000 (UTC)
X-FDA: 83920238640.30.D2C8968
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D71C180003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=bnuNYp3z;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MOVq3Vcg;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wF9XK8/W3b9Sjw1kBR6CJPdbErNROqE/otknq3MpBo0=;
	b=bTFzB9dL/hUh6NibfVWVk9rX2DQvdpZKmvaVp0a5cBLFBAEfbdyio1vZQzkqoIQnPnBy0w
	INYz3CBvT7/U1WXj7NK1zxY+LGAffvifrc/mY3Qq/7uAWFL6yxS2T6b3Gc9Vovr30EbloA
	ZzLoqwDSQnCEiZoBnqLeKrShyNa+eds=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=bnuNYp3z;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MOVq3Vcg;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625638; a=rsa-sha256;
	cv=none;
	b=XaSzK7K2C2ZKPHMFNCGNizZplVxaW6uNVldp+NPcvbM3PJ2fdSiYCwsT2YIyz30WTyCJxP
	ReZFq+hj0ra9kQyI8Lk3WMuTlAnedo/AybpiQjJS0ILJXjLcsCOq9SaxK0uSGNPHcE2n8w
	FqomDXZSJPZfl6Pd0kM24KBtpfxcAVM=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id A810AEC0090;
	Tue, 23 Sep 2025 07:07:17 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 23 Sep 2025 07:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1758625637; x=1758712037; bh=wF9XK8/W3b
	9Sjw1kBR6CJPdbErNROqE/otknq3MpBo0=; b=bnuNYp3ze7ElSDvbaKGWKAuErF
	8OxgqAw2Z/kCMlbDfthEu13h+toRVOKGfnpOTAdaIKb1+y29K6MSyLOvFb6uMRLS
	bhEnshhoc1wJSem1tlfdCNqpFgbZ5mboHdXxNPYwNjLOZ9R7CutOEKHmlZYkjkoG
	kLXhajidW25W9AdV6fQYKStbNi3jNAEijYM3ATWnRwYsBI354s+T0mkkftFSlXOz
	NVxNCtbXjJHOaA/Vd5i5KCaVWH50wmb9Ux8L1HRC86Lh8gjumkcj4bLTYWkENyiW
	BCrROUIgTplguvEY++ZYbMG/Z0ZZYW8mRQgB3qy+mz6Z2Ngxvvc/1SIkJaSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758625637; x=1758712037; bh=wF9XK8/W3b9Sjw1kBR6CJPdbErNROqE/otk
	nq3MpBo0=; b=MOVq3VcgcZJYV+x+HzB/YzA2V7uJHuXV2M6/iwUA7SfCfBrldoQ
	j9+XO30OsqujuSYBfV3pa9sQcpyA5lyxCkYAGGadC+gG9jpNk7rLgr+YXyTmvY/x
	yqun7HbAw338+qJCkqOrUQCsu5Th6jMlz6a2JGrCkCdyz9ekPZUSDfyta6hRpEtx
	vVf0Y/V72bFX014CEwTgTB3gt9pnpfk90zhE/b2Xov3mDTVfhhGgh7C3sMily15r
	XoWXzL0y7AcUOTl9HlFm8U/La0ibcNa2w8XCzfzZ1CRW4fYZTP01bpevUNPa4k8D
	DGpKqGZ+t6zsRlipF5v/aHj5iLl3R7jMaog==
X-ME-Sender: <xms:ZX_SaD-jWDt9kHAdIB69kTTSm9VMA6hz3Y509f3D5WqGjPHu-gM0Bg>
    <xme:ZX_SaLrawFAxeEp-OqxQf2Xa2z-pS-ZcWHMQhDQG7IyMc-MOmylyFMFYd9RUVoMAw
    hSDLgz29XN1OvTF7n6pxCYFlajSE-ARlyxWp_vON0TatZ97lkpg6A>
X-ME-Received: <xmr:ZX_SaHLZ-ViYDVbAYctjyBZH3qcFj21dGWZfqynzXxgVD9pgaFi3ckbmHNPF7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehjecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:ZX_SaF3ae89IQfljzisBLoPa6ddqv35V8N3DH5j-DtLfm08CymMSAw>
    <xmx:ZX_SaGU6Z55yhj_KOWZrZelxAJeEuEyoEWcc0qKK4BuMpxBUtkmP_A>
    <xmx:ZX_SaLU2rzh_h0ixl7EV1pvsgPC_IFwBo77FFYfq8VQB7F0inam5ug>
    <xmx:ZX_SaJEIPD0AZY72ycv3FN-e6Qrt0SoOxmbzqL0IX8P6uwhC9Rz6cQ>
    <xmx:ZX_SaJebJeGZSK2KcXa98vtabQGLUxjNOUoTvfzvNIx5tIdxzVWEC8U2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:16 -0400 (EDT)
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
Subject: [PATCHv3 0/6] mm: Improve mlock tracking for large folios
Date: Tue, 23 Sep 2025 12:07:05 +0100
Message-ID: <20250923110711.690639-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D71C180003
X-Rspamd-Server: rspam05
X-Stat-Signature: 8swk66rhzizra1mpcupjpp8o9e7x8qt9
X-Rspam-User: 
X-HE-Tag: 1758625638-768761
X-HE-Meta: U2FsdGVkX18mbeInDkWPiXPUTOGsYSKPX5uWFeX2d4x83XXVfj00kuLBnadujFaSQaLb3piQz8FcZIzh3z498D76dkuFRm9+XKaXBfTHZpZvPyh/xXCQRSPR1JYJ4XZK8bx9YfQiPmrn+KIaTg5IGI+GHwDsnXMlaOWKkXKBLraWtKyT5iw81Ksf2dQyRn5J7/ag2rp2lBmDm1T4JDE8P3FG9d9paoDsd6BThIoaR2PV1WEYb9YAIAqSWCzXbP2X/dz7/8LAnna7ww47dOhA8euaq6JM/W1QYLx1Zjtp5s4+yiJcl5a+2oeX00V8pRB/vxocODe3ZzLIkoCl8ffQ3SzGf3U2DIe2rinoOOdikTnzydKoJIwjpGuEwSr6IufGvDPMb9ZYEoB8Uyuv00LO9c9L9zqVvdTVAGHi0WGFyDHOqwI4If/f49oqmolZL0dJu2YUCE4FtbsZl5uaandmfAIREdhXVQ4/SI1G/ra35tAhNuQOTjqT3PdXM6mGVptq+SrGKbJO28N0Z7Wn7+WjX1BjbYKUWxAGNC+xfx+AjGmUe1zM2ByLjJA1+iOiJFfdCU4M2ZoCVqp5O3bY3VqVY5KDwr3jmbIJKiUzZtMaQ2DJCp3YLlzt/UJDNq2eVXaYTE86x5Ofemjwz0ai3Kw/IWx8ggypOu+ZJVd8iogsonRNkzDIgLdrvhQZR15pQ3CfnAVvkicCMCpG0NDUebH5n7iNoSCAjaGi0jJCDCCKDcD9ajTt8xUyJI2NWMa7ayWca+YC6kNRIuIBFijOSVqJC9Jqnsi5rQA9vAqU2wx74pDL5dIMmQmk6zRW030j00bb6pUHxbToflIqxcSlqeo2JYktmhjW4dwg8OUBjQMW1vUnT+EJxzFgKfFA7jf1kyzV4W7ScpuJx4YU3T0Fv1auFSbHpo98Par1MyvFDr2xSUf93+BAcQl+HWSsu2890q6FZIqtyYxNr+oEMQDyJIo
 /MDJ9K78
 kNUWU
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

Patch 4-5:

These patches modifies finish_fault() and faultaround to map in the
entire folio when possible, enabling efficient mlocking upon addition to
the rmap.

Patch 6:

This patch makes rmap mlock large folios if they are fully mapped,
addressing the primary source of mlock undercount for large folios.

v3:
 - Map entire folios on faultaround where possible;
 - Fix comments and commit messages;
 - Apply tags;

Kiryl Shutsemau (6):
  mm/page_vma_mapped: Track if the page is mapped across page table
    boundary
  mm/rmap: Fix a mlock race condition in folio_referenced_one()
  mm/rmap: mlock large folios in try_to_unmap_one()
  mm/fault: Try to map the entire file folio in finish_fault()
  mm/filemap: Map entire large folio faultaround
  mm/rmap: Improve mlock tracking for large folios

 include/linux/rmap.h |   5 ++
 mm/filemap.c         |  15 ++++++
 mm/memory.c          |   9 +---
 mm/page_vma_mapped.c |   1 +
 mm/rmap.c            | 109 ++++++++++++++++++++++++-------------------
 5 files changed, 84 insertions(+), 55 deletions(-)

-- 
2.50.1


