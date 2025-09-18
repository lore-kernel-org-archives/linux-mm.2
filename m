Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A208BCAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D840D8E00F2; Thu, 18 Sep 2025 07:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFF68E0093; Thu, 18 Sep 2025 07:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEE78E00F2; Thu, 18 Sep 2025 07:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACB518E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:22:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C3F61A013E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:22:07 +0000 (UTC)
X-FDA: 83902131894.12.3698042
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf03.hostedemail.com (Postfix) with ESMTP id 678D62000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:22:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="B jlnSC4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="O/N6HGa7";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758194525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TC0qa4dJ8ZfxpD8eOHAvcq6Kh4/gpC+GYroIRc1A+zs=;
	b=1B4LoX2DAcKPvKaVhSadCBOwaj2jIgr0NS5Q2WptZAiBVsH8qdyqtwx+WxGei7Tc7BhSKe
	y/dn6ybGhBbdEbv7arhSZJb/aWNFhv9OD+ZLqYveA6PBHEaH0ua55SZtp0UQOxpFtmpkyY
	619AxnahwZA0Jp3W0j93C4x8IOV9N7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758194525; a=rsa-sha256;
	cv=none;
	b=pECNcgMO8MvAuCKobmzjyAcr/xCXMvxm0ysHzoF9FfcZ839L1N9rp/ZysRiyXlsMJbgzAg
	2snq9AbigW4uiJi73iKFaCvMwwFmczHo/jRL0z0czCWkKKce6CoAoXZo1B035Z60yJqUKS
	wMMtkfVtaitbfIKGNPqM2a1TyiV6420=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="B jlnSC4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="O/N6HGa7";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BBA7C1400189;
	Thu, 18 Sep 2025 07:22:04 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 18 Sep 2025 07:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758194524; x=
	1758280924; bh=TC0qa4dJ8ZfxpD8eOHAvcq6Kh4/gpC+GYroIRc1A+zs=; b=B
	jlnSC4I5QYishrFKnKK9wwyolspBZIm5+esjfdskwA4hWQHwKzW5aWOl8JP9pi6o
	yQw6Gwiku0EOklDIv2OfURaJ5tTTsAlzCXHK5oOnX+bdNpfur0ComdoAbdBkB3HG
	p0uImfDZSugFVh0wSpnz6EYcbZRQ4vO5BLMyP2ZbPI6bHY2WTH6ecO/X2PT1AI8K
	cM1QemB8AlPgdUZG2JpTouBOWzMzpdb/4xEspMEnWzlc/byyYb/P/h58xvzh2NnU
	CCGr5eZ6v35UYgc6OHniB+SSNfDP0lIWIvlKLTaPlCuseQnX+td5ErNl3n4YXCvM
	T/p8EHOxOD+j8wqnp+NfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758194524; x=1758280924; bh=T
	C0qa4dJ8ZfxpD8eOHAvcq6Kh4/gpC+GYroIRc1A+zs=; b=O/N6HGa7hAuX5edV4
	bGnn2ILo8TPFaev6z6I0mwCtmOAEfdX+3nYBwWA3z5IH3xVB/aSZGBp56/3OVPVE
	IPrSAn6AaMXOeG6v2Wl5c5PniiPDfff4Nfqxpg31U1TRrUGKAsSsLS7+pOJMSWsW
	7gb/gSJvxOV7fkmUOKt2Y2HcTrN4+JGCI9u0S2+hwVUjeFwQ7/V4GKNxBkqisF6d
	8RIrxJjUv7bt+5f3kX8vi7lJPLyk4Vo7gdZjs+Kt5y6Oaze9Ba/5V9Brgt+rj+O9
	yMkpKvheyoX5SURB29+fmqC0gJ6cweLNZ36iUytieeZf2dukPzJagYKnMqBuo87f
	NAGUw==
X-ME-Sender: <xms:W-vLaOB7u4XeQHsJeH_BZ_HrGgVbvLCpHK3Cz-RNTH1JT_DFjOtQxg>
    <xme:W-vLaDYam0oLeMlzIY3nCSKWeFtYEDfUCaeDPWvywiY8YKNPqM5LtOwi-HSI905fn
    98jw-6X0MHXOkxcOuY>
X-ME-Received: <xmr:W-vLaLz4xOyr5RnAEN9n2T4dwjov5cCxs8NKl5EiYzdL_eolVN2xq-QbSo4Miw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegiedvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgenucggtffrrghtthgvrhhnpeejgeevheeuieefheekle
    eiheefkeekieevteefudefveehhfevffeludejgfehueenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohephhhughhhugesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtoh
    epvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:W-vLaOcNpuyXooUIwx1WKBfD81GiS5toSVqHM6YicQPy474lLOsvcg>
    <xmx:W-vLaJLzXVKBrBcgeOXSzjjxQQ07NKqk8sjrzmzqNiWF8tCnrvNqlQ>
    <xmx:W-vLaP3mGoB3S1jk4-4dgoybx7vfY-HBR0oITCNEb_9q2Cw6DhLynQ>
    <xmx:W-vLaKZxubsjifAQmeKLoMUU5DHCW0hT5h6alCQKFuSFY3RcNjHDhg>
    <xmx:XOvLaJCffpWMSs5QtxvLbLXxpAeu_H6RSf_58M2pMGemLhBJOVxjqFO6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Sep 2025 07:22:03 -0400 (EDT)
From: kirill@shutemov.name
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 1/2] mm/fault: Try to map the entire file folio in finish_fault()
Date: Thu, 18 Sep 2025 12:21:56 +0100
Message-ID: <20250918112157.410172-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250918112157.410172-1-kirill@shutemov.name>
References: <20250918112157.410172-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qp5jfa4crmcujrytxhmuxppqbkzmzhfm
X-Rspam-User: 
X-Rspamd-Queue-Id: 678D62000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1758194525-704384
X-HE-Meta: U2FsdGVkX1/hdcemvPSWQot+cddeP6j+pUJYWTLN5Kvn6nRqj3g9v+ijkTLXCB6LWRhxgrywk+MWnkYfrUChsA8IbCQlCVBp7UYDl52J2mSrL5LnBT6OLUfQ2l61PtqF251NydEgTOUfg0/IsGmR6/4C5WETs+R7RC/cUjBHyBB8fbDdSFSS1593yPEEhxhPMam+yAH3ZG494c8n1Ksm4AkE5axzWNq8fL7z3NXQegMAdbLf5XYbSSRuMeJLUDxQ7hh9Ru/v3qJk8RHEnePmHagKANleGSCkI8hS28daRo/joNYk3FwOvQR8TCPfztFNUD+bXSfHwciT+FPmKipWBd/M0CcHOXUPJVLHjul11kcC/KcxRXZ3eGUqiwkT3VRFcTPCfnTiPjzuz4A5yzqe51QW60U9X+qESICTILAEMFiaifd4JdHH+7063AWOpk/8V0DrAPlXn17JXifJuDFtkPlPMqdiJyHynllKqTYk375mgjkkWkMmU6gjqqtfYoHH4t1xpnHUBRxcrN4l7JmGCS44jQjm43zgQAOgZFqmIFrkUoyBk7fop6AqynWllPucnapQW2EnrOeQaQqR5A4uBY2PMKwgwcEQxotl2Jm2TlnoZiPdRsVQtlAL05kny0h8gkTvXmhZkX76MxpsYIyQQ8+Lgd9OFyOnR8jp4/HybvBvS3rWAfUv00WAhwMbYo2IO3ODZuWr3DWM1IIZLuTruoqPWMCjw3Aois86XQc+faAiCSeVdYoFGR74IjbO97S4O0OF177FlMvl2/PvZlNdF2N4uwfvpQzMhqimipPyb8JQ3lEhI9hGBjGGrFJYNOWHw2ffAwctKwr/qBc2T38gi5vS2KbtunbNHI50d5GPtNFy2FgmArSsvouK8jFWOEyG55sxiUIKCEf7JhjoC4paaCedcZuohizXQK+jGnwqz6eafkiea16mIq/YFceIb2KMjmP7tJy3Wgdqxvvqexs
 Nk6NEkjq
 0nFeSve0i/ircTY9LlVvndH3uxT5OQP/51XjrlxdtYKXHft6fHvAxMrnWb6HYLfr7E+0J5MOIM7r9rcNGUuItnDYFxkXwEGnT2LPn13Ad0T94ZGHioaTg3t4faeeBzGWnJrX4wcr0mUO6sH8ZkM2138YMzbKwVHvHQiIOA9hFi+zXW2zvsF6rAl9TWqwmzAPdxNI5ExEIoGxqS6eljiWSvJ9EPInFdpz0dcLF8ocDCFfDE1KQrOtxh/1ZprVpyHicrJC/DXR2uO5/yqyxzpxSv0TINrwgKAotbS3POh3JFhbGDfaB5Q4a2LfbK07oRV1a82KgxD9ry2jnTAFAw5Lo8X6DSKFb0rlQywFWPAhtSBurB/DiQbHW/2/XZ+7nBtYamRU01zKGGI4/mlbfXm8jS3IG6BtpmhJ9fgn6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The finish_fault() function uses per-page fault for file folios. This
only occurs for file folios smaller than PMD_SIZE.

The comment suggests that this approach prevents RSS inflation.
However, it only prevents RSS accounting. The folio is still mapped to
the process, and the fact that it is mapped by a single PTE does not
affect memory pressure. Additionally, the kernel's ability to map
large folios as PMD if they are large enough does not support this
argument.

When possible, map large folios in one shot. This reduces the number of
minor page faults and allows for TLB coalescing.

Mapping large folios at once will allow the rmap code to mlock it on
add, as it will recognize that it is fully mapped and mlocking is safe.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..812a7d9f6531 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Using per-page fault to maintain the uffd semantics, and same
-	 * approach also applies to non shmem/tmpfs faults to avoid
-	 * inflating the RSS of the process.
-	 */
-	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-	    unlikely(needs_fallback)) {
+	/* Using per-page fault to maintain the uffd semantics */
+	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
-- 
2.50.1


