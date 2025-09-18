Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384EECAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6517B8E00F1; Thu, 18 Sep 2025 07:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629608E0093; Thu, 18 Sep 2025 07:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F2E8E00F1; Thu, 18 Sep 2025 07:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41F7F8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:22:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE479822F1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:22:05 +0000 (UTC)
X-FDA: 83902131810.11.50BBE00
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FC49140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:22:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=QT5TucPi;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fypwkU8S;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758194523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TuONL5e3a/q5HMiQsTmfxQteh3y7sUS+8GfVC1rNLv8=;
	b=dftPwzqMLcmWhQgZyw2gP36UvoPcEAf2RglaqDEM7zA/w3dxeKe9IHyQNzK9+l+ZIuZXrc
	GBsQ+jdz7RJnzV3Sp5I8ASPsqLNvE5n+7VLAs3YTP7MNOgkoItayvYCl9oVjoo2VKOvPau
	e7flJCU3csGCtfP2/tB2dWUtysG+IRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758194523; a=rsa-sha256;
	cv=none;
	b=zZTY/yZT9DV8QG8VEq/qYtu9CoqGVgbz2opi20q3wKJYPx+SV32Mc03c+3mvNLFlr/ELUU
	TZd3j86+0Rh4wkBz1pWsYJ2pviUCx7P0ODmUKeKXL3AVB41ks9G692SJk44abYz5ZtaarP
	UpLVYOBxl1b/chbYqv3a/16FhWxyjAI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=QT5TucPi;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fypwkU8S;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5ED78140019F;
	Thu, 18 Sep 2025 07:22:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 18 Sep 2025 07:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1758194522; x=1758280922; bh=TuONL5e3a/
	q5HMiQsTmfxQteh3y7sUS+8GfVC1rNLv8=; b=QT5TucPinBhNszNfa0MAXZ9Hbo
	lTXxdjl0D455MpY2dmtKd0BlkiQvMiS81SYrZf+2/VTV+UkAsgCaFMmBw5ZjAz8Z
	RLWNgCnezic/09CVWlNu9/N7xB56M8VJ1DV8Qmv9kCHoqMOqr4rklcH2+EWoKpx/
	8WY50wzluov/gkO7Le5w1kbNj72RlOFsE4cPIU0TejpxkphOR5V3dnp00ASfByQS
	zeTxHPSkg/iHLWXSx6XknxEWFmYK+tqRfESTwx+aYqemAu6F2MTLsYEoEOzSg6jo
	qaEvR+0odMqEfeyVpqCPxuNXz4xMfe+v+WHxyKDizmL5/ROujZ8QeiNxUQaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758194522; x=1758280922; bh=TuONL5e3a/q5HMiQsTmfxQteh3y7sUS+8Gf
	VC1rNLv8=; b=fypwkU8SiBjDmJ8FHg25oW1ZtzyJQE+xe8G1ntFcWIk6yq9bBAt
	msszl5e9W+lPOSBPC+aJKRLTP4ACBxCOboP+Pbwsz7aSkZhCBt6X/+WiPbjKM2QC
	v/vs4rU3Z3faxnWzuS6FHXrxdPRV9qbAeKhU+d5Oi3FGd18yCtSELd+Bv1fQd8Gx
	ZlveIEWtD+BOHoMJexWZuF6ezk6mj6WcC+NirSgavn2JMVpo/GnRMSYKlVcLCnyT
	I1mNYBCFTmim3GzXw+DNTob0kzldcsH+zYB70d421/LMEodiUlaysXHhFLn1bwlL
	5iUTZ4ePBU8Q0g01ohI8Bo00SFd/aTE6NWQ==
X-ME-Sender: <xms:WevLaElGc6u8MsRm3FcGLgpe7ZPEv0a7oqKJFGsSkMItBZi1-UzOhw>
    <xme:WevLaOuegiDUD-YZyGpDkUigf4uV9SrDVE6t9Ek5FQT_-74s3gWeWNlTJQLdu4opz
    -jbljBUqctmIxtl5zQ>
X-ME-Received: <xmr:WevLaM0Xb07THI-cGYF7KMb7GURu9NC6IvrH66ajh1nNq_6Z6Y-U1RZc8Kmi9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegiedulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpehkihhrihhllhesshhh
    uhhtvghmohhvrdhnrghmvgenucggtffrrghtthgvrhhnpeeivdejveetueelgeeiveehve
    duveffkeelkedvteejiefftdekteevjeejgfeuffenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepug
    grvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohephhhughhhugesghhoohhglhgv
    rdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtph
    htthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphht
    thhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:WevLaCSOqrsU5J7WwB6P18Ki2gVViuhU94_5syI1NReipkFQPQsMCw>
    <xmx:WevLaItbu6C3-rdqsPD_3OKHAxFJ8P-c_5kF_XqOyQ0HilYNnu9vSQ>
    <xmx:WevLaALi1ZBrhUmc9dGCo35R29gxtHBiKPYufVquzSsT0I-i9XHbNw>
    <xmx:WevLaMfQeJdHWzwvwsQSqRp6glinSxHkefTTfm52TBy4ugrr5SV0Fw>
    <xmx:WuvLaM0uh74Z0_bun45mSjdRmEHzM-YNot_rti55JUoF5XbYUYQ3QEKq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Sep 2025 07:22:00 -0400 (EDT)
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
Subject: [PATCH 0/2] mm: Improve mlock tracking for large folios
Date: Thu, 18 Sep 2025 12:21:55 +0100
Message-ID: <20250918112157.410172-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: spkurwy7uxdbzwfq5tuu7wkyfnj66ybd
X-Rspamd-Queue-Id: 1FC49140007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758194522-954410
X-HE-Meta: U2FsdGVkX1+hhC7i3e5M6fEZ1h2IHGlrWeWr7+BOhb0qTUG/vcnRbBXMuZ87zg1DFUKd68CuoL8g04No3yuszh3RtuXOtOidqRBzG92pf7w2LnBJX86U5sPNBJoDal+aOMJ6vt7M0mI7lnB3ir9dhV+HfPLJP/kjoWTI7VCrzDTZS7c12b8Ly+mhrEuZwN+J50jLlsDHAjR7RwSLHde8+4+q4I6pEtBsWDJJzKeKYvtPf/PPJcrRRoyzcKZwo4aJK3OrVItXaVYE1UX7VeG0ytgYmxeObyje68VDq2GcnbrAjRVPAWUWJJxpbYRBhz+U6WpFtWyOS4UtfcKqTnlOeIvk2Q7k/QZitL0hfKb8kjBbZPxfjZvncRUOipFcVpojE7V9PRLvMZ1o1uF2992nHUZfOwNmUjARW8hsJ6m2CUh4LjWqFj5WUHWt5Zh/UT/r3xxAeGV9uaiDxzJE7XcIOXf5hGThcvlZb6O0z0Ppv3VVHfFlTuyGnjL631Pc/wApu4EVstt4JHNk2ZV2bBbwyeomOC9P3JChnvbPoCrse7/5q6gZT/RTZkepzS+nY+2F2aPTM1enikZm9Q7zDSWT7Ns4h6d48LaTAOVoAQkIvtG86xwLAsX6ELdoL6l474n3jHCZedEgsvCb/JR64mkfYiptlS+t5StoNf0D0HqMY5gVFGG9oEvKcqePDgFJDFjMfRcjtApB2zWcn2TS7RMU3RqhmJp6NUiIUed3TxO3hEODdRUcjUHDYwxkLqeEbHIja//d6/fmkd2AXrrGueCym97zgey3AmxCNt01ArAZ1BpEVONgky5UNPoIlX9ebRlkrKmJnS/2s+uSjTxY+bMV8k13ANk2zwtUn4lJTacDUOqc7Z2y4+DnBRl3pcZDnccEfOXxFIJVFkpXLhkcbEVCXKZ09PPwyEaCYeC3SSbg4m2+m8b7Jut/T1cNswR1FaYTcZXYU6cgtsIuaipFPrZ
 VJbD1hqs
 kExvX5glk3ApNcsxIPlFcPbcp4RkRs7kdorjeulBHE/7FxXJskQ9+nuEwf7b3fWsFZ2Q4ZZtljH+n6LmML4mEbKqK+CNrJlFYbhPCpheaWav6r70ov+4grjoS1qqFvx35OHOx8GRCSZwgLmpKJjmu48lF6wglN5EvZWE1xHw2joJ2hQcBTGe2qHuErVKx+nj7AtCS6l2uwCwNq5A4k7wZ4J0SM6lt0FO2DKAOF2a/32LwyFVadIELWD2UBwNYKY8MsckuC6FGwM51AcWr3M34YbQJ6K+csAT8E24yV2i4yW26j0n5EOqnvI2uKY7k4Ule9YQJ9G2EU2eiKXKXjNINpC8ZT3dbrthbIvBkUwfEtWJ+eXnE0hlnInjn+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

We do not mlock large folios on adding them to rmap deferring until
relaim. It leads to substantial undercount of Mlocked in /proc/meminfo.

This patchset improves the situation by mlocking large folios fully
mapped to the VMA.

Partially mapped large folios are still not accounted, but it brings
meminfo value closer to the truth and makes it useful.

Kiryl Shutsemau (2):
  mm/fault: Try to map the entire file folio in finish_fault()
  mm/rmap: Improve mlock tracking for large folios

 mm/memory.c |  9 ++-------
 mm/rmap.c   | 13 ++++---------
 2 files changed, 6 insertions(+), 16 deletions(-)

-- 
2.50.1


