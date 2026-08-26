Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D3BC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5576B009B; Wed, 26 Aug 2026 12:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565DB6B009D; Wed, 26 Aug 2026 12:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8B26B009E; Wed, 26 Aug 2026 12:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12C356B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:21:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9670B14019B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:09 +0000 (UTC)
X-FDA: 85143935058.28.88D99D9
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf09.hostedemail.com (Postfix) with ESMTP id A177E140011
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=SjZsZs02;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=l0s9+cLU;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761267;
	b=umoua53NhjShQl2ot1uoGAgHpc8NIinHRwyOANz+CGdmn9jaM7dipGYcX+4mNnCag3RFa/
	3Pnpw0d8shVQIXoZR72HRe7a6uo29/rd/Td5AOQbcIF/+PujGOudT7g584kjg1/5HdKt8N
	C2ySfKb7Fa14A8H4ZcQO0kNfKDRREyE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j+6mmJQV8MKheyA1Tiyd0okJyHRYrBha/y7uF4qkZ9c=;
	b=tBhtry/M5E/hV3UnZ9WzTVZf+eolxd8Aws0zCBCF/wKyeTplleb3lrlcXRWfxuh0hZbCDH
	s1bVZbkblJoxkJC3CCBIYb8alme0oLu+94Msp6pZG/WVOTZ5VjM5G04G9Mm1wunSVbzuoh
	ImitlQgDcxBqR6g+1k0EjFUBpHoETq8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=SjZsZs02;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=l0s9+cLU;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1CD391400192;
	Wed, 26 Aug 2026 12:21:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 26 Aug 2026 12:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1787761267; x=1787847667; bh=j+6mmJQV8M
	KheyA1Tiyd0okJyHRYrBha/y7uF4qkZ9c=; b=SjZsZs02x4SYnkC+nDbn534D33
	h2dkZGuJ95BntL97oM5ugPdFHFsUqFaznWFEvEpgyX0mqs1M3w/10rR6tJHaWFh+
	Vws51Oy+LQWw15Iby2iut9kmO67G/Gcq8sVr1xFE8+ZT72O8QyhblsQKNgqEcVEg
	eMX06UUw8rfnu6zIugOL0y7YfdRP8zaswhv1CkYr5gYvaFzEtRyHsYz4TbcFhmYk
	8ubajzTKyNalBqGgktLzElsRz8+uEOl470dj4B8zQC2VCwhduM4lQjjMY+4a0dyr
	JJEnpb0xtlndCHfyCMLLVa9elELGW0NidRamjsvHP1IJXd6xU4bfPzMmb3dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787761267; x=1787847667; bh=j+6mmJQV8MKheyA1Tiyd0okJyHRYrBha/y7
	uF4qkZ9c=; b=l0s9+cLUzVIbhslQjTuRObWJpMg15HTrZJawbXPDojdxqMNlzcr
	ax+L0vuowgZ4r2FmXlvHa0x1dRs7pLFd2OUccNNq+QLTmFNkKFmgyw/CQPZsYIPp
	Vu9+2fUoWYMFkQDgnwLhtelZ+hoZI73D2yzp4lRplKY7vmyeVJK3TResxoG92Cbq
	Wy3zvbBwGFL8Zes5/B1deb0kWxkI6Ap5ofvaQZql9nwJCQKjSo8/Y1vycVnDX5HL
	NSrY0TVPTZhVbSugpDpg9RVb7jzkGAtr/52ip+yejFC+7jk6tFWabwWLh8vlI31D
	D/BJ3EyesPklm+PTE9233E7XOFYqso0CzXA==
X-ME-Sender: <xms:cRKPagsdikrLixsX9PmTOgpasazeuD74ej2-kgOUFnw3qodJn6BhDQ>
    <xme:cRKPapb-TmxX5Jeu26Y9BaOoHEtdEeNFBiRu1R87Ork7c56PYxiS0iOZICKhmqJIZ
    XZEfu7ABTnsSQa5YWNg3rJzXO0woGmvIY6rHQyPR64Pum9mak2nW8Y>
X-ME-Received: <xmr:cRKPah7Ghp8rq7jHQQtVjm0rrqTfLT_YVirWmHwtANsbLfQ-me6S-9Yb1FY>
X-ME-Proxy-Cause: dmFkZTGdDRZOmCQhCp3v7Z4DXYRb7jaytuKsqhJJ+i6wDChkAgllaSm2c6/LznZNVrhuZZ
    DxABY3gbSNrfSJQ8iT3kMENZkvvkLhwKvasQHxWKW9f7+6U1ciLUnxkkLGR4lJY8DToqve
    nQAd1Pwzx8Q3e3f1jMOjm9izuZD0xrMia/Xd//1C/SzMgaFmQ/f+3xj8O9m7UCbMRfpA32
    xNoFeOKVehYNB1PUY2RDqcnq5sTA8HESoP6+LU+rfu66zy4u4d2Hd25BimN9k8yq6Y0GRU
    rv/CUjbCmRsFYNTmMC+EFy6SemdOsOo7KqMofNzNAak4gK8H0LY9U1zwKpdK3TtWR5bjh6
    FYu9GHd6ArxlHNyQoAC74cn0vu3VIFRz3z20rCOItcieV46yI8HjaZFT41O11JikmLe8ng
    4oz5/wlufrTbK5y93u6z3rDz25LahNobyrAqGaQqOc4NF9ylr/9DvbjkZtTqvitQj53x05
    BRzvqpur/UoRoz8HCycKzZe6sc7qLeTvrSr4xo9ZcmPMxQ8iJGyFXT2lmyOpqR05bfTfoT
    2dX5DqrGxStebT3pR3UpaYQRz1DH1cvAHDfEyfjTk/HEb1xf3/UXK0SelqRBRXg1/Z4kpc
    HSb5goz9pruaO+Y7uLVmst4T8KhcRyaE0QIig/0AzcnPM7dq4/LL//AimCGw
X-ME-Proxy: <xmx:cRKPapknr8xImVVLs50yC1EXoiKkQwWnhLPUZZAT4qNnJpSwqpF1uw>
    <xmx:cRKPavEE87_RkDzvi5FuVnZmxWPLrgiC6RUNNLPH9JQTRPYGrJFs3g>
    <xmx:cRKPalE8PjqPaWwV_SgoX0rguqDoydBLgY6BrDE120ABKNnE7gRpRg>
    <xmx:cRKPav2T-9nr0J1k84bwih18GqsIgtkX-sdLTSDOjLDVPV680i2qwA>
    <xmx:cxKPat2eOI4DsoEQm227vIA0N3MtKtLA5_n_0UjQp2jK9_pKIG4_eN5K>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:21:05 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 0/5] Fix deferred_split_isolate() and clean up __folio_freeze_and_split_unmapped()
Date: Wed, 26 Aug 2026 17:20:56 +0100
Message-ID: <20260826162101.1314941-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A177E140011
X-Stat-Signature: 7rghdtard77hbdw6dqjatebp31rdq1bf
X-HE-Tag: 1787761267-31391
X-HE-Meta: U2FsdGVkX1/EiwGkOeMelzDXPq4ubFarbEKkFKrY9zXqiE1DKcBctV0djqnGKxJMqW/RxRcEMfyUS2UfKztMT+17zN9Toau+UlbEJ+Es82ufO7Q3qABqyKaUJsOO3+hfN0EnP7NGltjGZhDfOdx9ZzEZStsseAlb72ns4MS7lf9lUbpuph9o+pGgz1Uj2Fy/ID5f3WOYiGoMz4HIe8vlf6WALBdbnGYxB0ecCRNA/qUAOBz1uFTCu4a5kUxHtGqjhBFq6XTHpv+DlFZT5PV8kSApsDoCwkWKZjAanqSzNLm0vRVoNYv0NEr9lqFfRZu1a5Nw6PNL4dTZlEg3zFtR0kaUHJw+blA5O3MtOybUYpCSyna5As8VoBJeG4DYnL8owRzYdetsaFgrNgD7yzOXyRHSS4qRrI8roFEUHzVY6Bm7/gTuWdeb+5P/Vtc7i8pKrJalUFbA04CaIW2mQutZQWGsS3C3BD7QyMjMomJFziccOKafYSl1sAvPjQMBHq/jH9Pqcs5K+lKIv7GR+WRhY4fNdxLjFN0ij8HQ+7jnfhby1oaVjufS17xX6PCj6/DHkhI/ABU77MY55UYZTga4uTu9i6wA6aLv3B8OyGCGI1eIJztqwzy6vHd6AAey/U+9nQPst8/dH1+TTmFHDAj2SD23qsZZLTkBXefRrVGDcU59qYh2ANx9kWuOUf4i0V4mcPvZnWRiFfeqFjUK7wAEMg6ur5SD0/LiLEGLEGB4fvGL49Pxu1h7n6pFakWBIG24CBiNW4eZ82MlXoMO6xCFd7oilHvut6cfPrIzj5BNBuzaaR/Quo6PyOhrfw821rV5PcsnPptC5ec/ix0RwKeMtozyzjoVwkfYdNHf87cg3QafZxvJhNszP4yLC0yWUrwtqQnXv/eVflpU19nHUCx8gw9K+hUBk2Fm1kjOvbU1C9s5T2mSfzQak/VJnYKkxbFSRPurDaEe8w2MxSzbfMA
 nqD/ZJY9
 HUCFHoVZrgYSma2YwrB33jgcm+Pxhvkj8X1pwKrvuvaUU0LH2schc6ca8emDGtxUS5rCooJmWS6dDOQUEztBngdiaERLej5b3kbvRvr5kPzUsUczDo0yTI6eELO2t5I1fFOh6vptlgydUq6CY5qNQwdIwQ1N1xi3GRvzBf1znj1AD9ox6vQf80v0XDqG4vk39xejtIIzG9q5MpubnzEfX4XhdZ55qHCT6MqabhfCsqoO57IyjDYDu//KrzrmL1433a3/ui/wJ8+8kN0JbiCzZTL4inDDZF/VDLYdGJZLLuFanUCi7bwfqLkrgXwxMex66XaUNvWPX3LIkL25AYpvDmg3gchE0jh2GJvxQsjVAqw9+6dIzSnTeycLy36nSpLt/ct/d0nOun+mmKUY62FcfbrxU2+4xqWb0Vh7nwmFrWmnkcERn73e07z25usP3jNL2C3KG7ux7bZiyUOqSGjkNApYNzadbyx3xEhopZb6Hrnypj17DRsmJT75fiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put().

It leads to wrong results when !folio_try_get() was not caused by
folio_put(): for a frozen folio, PG_partially_mapped gets wrongfully
cleared and the folio dropped from the queue.

It came up in the review of my collapse RFC series:

  https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/

The bug is inert in upstream code:

  - __folio_split() works around it;
  - __folio_migrate_mapping() freezes a folio it is about to replace;
  - reclaim freezes only what try_to_unmap() already unmapped.

No stable@ needed. But my collapse rework steps on it, so it is worth
fixing.

The first patch fixes deferred_split_isolate().

The second patch removes the workaround for this deferred_split_isolate()
behaviour from __folio_freeze_and_split_unmapped().

The other three patches are trivial cleanups in
__folio_freeze_and_split_unmapped() that I stumbled on while looking at
it.

Tested in a VM: split_huge_page_test, folio_split_race_test and cow pass.

Also ran a test that leaves 16 partially mapped THPs on the deferred split
queue and drives thp-deferred_split through debugfs, checking
nr_anon_partially_mapped.

Kiryl Shutsemau (Meta) (5):
  mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
  mm/huge_memory: dequeue the deferred split after the split freeze
  mm/huge_memory: reduce indent level in
    __folio_freeze_and_split_unmapped()
  mm/huge_memory: fold nested ifs in __folio_freeze_and_split_unmapped()
  mm/huge_memory: turn the swapcache-with-mapping error case into an
    assert

 mm/huge_memory.c | 260 ++++++++++++++++++++---------------------------
 1 file changed, 109 insertions(+), 151 deletions(-)


base-commit: 33f61b12d297562321533c048e034b1fb21c1cf3
-- 
2.54.0


