Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7FCCAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65CE8E000F; Tue, 23 Sep 2025 07:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15DB8E0001; Tue, 23 Sep 2025 07:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6AC8E000F; Tue, 23 Sep 2025 07:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72E808E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:03:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E7F9B9A29
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:19 +0000 (UTC)
X-FDA: 83920228518.28.B1CAD92
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3099E40003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=fgAra4gg;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NcfKpGk4;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v0Iv997UV6fMyfR2AD4bwzcf2iZuLe+1+UK+1BwCASs=;
	b=Ytf6zMBXAlXCef9saukRTXj+p9H4hHQEhfZ747xuVmO/E9nuR3g5ycI+2cyLZwv/ld+Qgz
	QMJqrPESrtn824at+u3HBzmylcr36hdp8a8mdc8Zjr8CHEY6ne/c+or/FnOHHuI89iW6TC
	/txeS6pLlKGgWVasQH4cjg9JwhzV6MI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=fgAra4gg;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NcfKpGk4;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625397; a=rsa-sha256;
	cv=none;
	b=Q3ww6fd4YEX4ABevxXFIF7VmWxlGqp/uRsYxOXKZ2meXTyE1hBo7v1NBu0oEXFzajcK8w/
	z8hY7Kf50HYo8R/8LlRt17BLPXlCHk8EOrUBJWMlKXlAS1l3VVocqTf7wTP0CFVR2Th2iT
	oAh2YxYtZxbVq23fwrzmASakNartQHs=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 7DEBFEC0084;
	Tue, 23 Sep 2025 07:03:16 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 23 Sep 2025 07:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1758625396; x=1758711796; bh=v0Iv997UV6
	fMyfR2AD4bwzcf2iZuLe+1+UK+1BwCASs=; b=fgAra4gg2KoWwsNTu4d4nbdT+b
	+jCGJMm/fQRT9LT9eb65wq+PwizXsr5WB8wQgiFIe4x5Y0n471IwVE0UTPKhbGN/
	341SJhS0Yx9eStfEMaAqIDlOK3/4n/14WOG0VA+cIn69pb22VMfvp+lffq6BSa0b
	Z5unjyVg3onwA+qd0xu/d6RN7aK+iXv2TVlOj5BkmgdCGYXXzsdm0NZwzWEHD+LG
	dxXh3pHzjC8gmL2DGu0amWnN/4rINNO3iFSUsUuQfUzhl1CUafNyyFtiVCFmNv7n
	iZFf6WYXCRr7QqmLsoHQuHlxf2VaguXzO6QlTJ0pSfU2ILSQ9aplAtyxoNtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758625396; x=1758711796; bh=v0Iv997UV6fMyfR2AD4bwzcf2iZuLe+1+UK
	+1BwCASs=; b=NcfKpGk4ZgpwLCBkfJkXM/VA1m4shVyguCG9Nl76jfRigMPSdY2
	Cd4TfM+5/bEbg8O/9VtMkjMWKiHfBQUcrfxrW1ac+nKfwIGIMauyKGAhXQm5UCLr
	bxVCsW/H48yU3AXW97Ndc61jRjWSHn/Ogpf0jIJJlPcoUy96My96YUYcgwIZIqAQ
	tHpG9j941tqAVSO6YUuBdnO9E+/NxqfRrCsHmg4sVxv8lN6IfrMVBlx0HEfgbbEo
	4lpbvI4hPaxgO+DZtbU04XQDtmo4RC2ieBQblv+tF4r/zdW/iiDOZ8cXV35dzqGL
	L2dsdQrIHekKp04LV2xD8ISuJ3igSZbcU8A==
X-ME-Sender: <xms:cn7SaMGSdI08bEYpEzBg_SvLz-cWwgaI8dzA0-KcAkkRo6I9nSQm_Q>
    <xme:cn7SaBShrOfa6qKWJZnbOEDb0BWfaMhJM3qmyMDVf-2KOsozUH2XgsobPLSmMjP3Z
    abrUqUmJSiJll9VEFLLJM-fkO-b9QTaihGj9pNCmyFLK2FHdpyGuEA>
X-ME-Received: <xmr:cn7SaMQpilZtF127zMbjMcKq5O-z6J7cWVwCVTzwpycWQe_I18unNnYXtlK8FQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:cn7SaEe5r5WHRDSR68JoxWB4haNtAduHKyEGQYl90rnZPeWoAlAX7A>
    <xmx:cn7SaAdgewjJ1ZxEoNxkJ8yTmuWYkL-4QRHpv-BpBU8JUaVIZigV1w>
    <xmx:cn7SaK_IaqrwPiCoC9HY_Drgk9oy-Cd4i2EX__9reo1Jv2wTpo6JKA>
    <xmx:cn7SaAPMt43Vpjl4Fic3wHtn8noiVWqE-s1M_25uk-6v8418F0ow-Q>
    <xmx:dH7SaOaXb4iVhWti3Xbm-GHEMwARJY5XamyJ9Tfq2CT2SBLEURHh7iU4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:03:14 -0400 (EDT)
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
Subject: [PATCHv3 0/5] mm: Improve mlock tracking for large folios
Date: Tue, 23 Sep 2025 12:03:05 +0100
Message-ID: <20250923110310.689126-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3099E40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9prg57jp9f15mqpfi43h71wf676z1q7t
X-HE-Tag: 1758625397-119493
X-HE-Meta: U2FsdGVkX19gCm+Loj88OOL5B9p6MJ8+RUc/bIE7gWuOa2amtQv6elpNM1SrHdF608MAZLIfan57LxJeG3SQHsdrmPfaheKZFQP2JU3kroNj/pHUwfdkEun5EzwqcUb6vouEqxVm67k8z8Er0J+QqmetiZ10fF7JmvDIh+EvdSmD9cJ7Rkn4yV7k1pjoaf7Jsn00Z5x1lZPJL0lxoxI+5Sed2xESihym5io3oj6V2diJtxR4e3SP1D/YAu6eL6VuRF61fEedPmURgLA54/N34/f/60IEKBERdTjy4Po669YXmpO+l3qbbqGEkNLPy6jM/wmJAHovbAVRnQu1ODzIwZBVSyGNsNiDDmfm1JdmVB3wtWrztKKOZx91OIp8T6xtpXshGyUzwNcmsIfTskTShvhBi3UKpiU47lz5Wfeuu4dvPFMthd60+wycmeGxchxoeieIB4pR0Mkd4okns6cd7Zq40uJ7Ad298CNOk6EuRwyoj21afyIkJLO0Bb8caipt2V6TetaQrUN4pm6NHPzwhc/KnyZ0merGTsLgfsMAayYjnHnuyVUXW3/4ReO3bSXEwI45apQ0kBFcTWl7rEIX5qv0X+0xTxynPoZyg/GBoM51VB+KyretLuWfzTIdRSkQI2JEO7dyM9S3MiBTkFgOsznHIYS9pB5PWIjnYq3LN/PF8PDbXeV6daJUsHay4EmGHkhOfgExZwNmXhbg7quxwVR3FM9++7R7yCfjDTCo0Gw5+d67SvQeseXuM3GDDqduASGXxznH9/tJQAew7VcPgwBuSyKpjKbyj9rZgN3s8PQ6HFo7p4ZkMK+K5jiQrngVwpLe0Fs2SHqwM9wXL6xhmXkQUTFVarYr5EJgCzp3sb3MGYkLQdvodm40iMt7MKoWnLfz1XJJE066R9jUyHsJMArUgGz1J2H4WrEjxkE8CwlcAqFi5StLoIhmv46vm1VRdM+WrvHdgXqp09MATcc
 re9pRx0I
 jEOmn2oNdzi9AFzIok6oc20C59lyEsTp962A/BshyRKl3RAGLNmRdK+6C2cUDACZu7lL1r8kLlskPbLR35SmV4H7BHFsS/Mx9nblV73tvUPQFqOhiMM27/7R1rzSWgqClhyVvglk3DIjO4sakRTrsgX2+TP2t4YYKAKpb/+mYbdi5/TZssUea4L18lN0x8368M2OQIiLwlPTxeh+N6Jm9O7WPCKRfl3DN7x3i0AjZTkzqqi85+UUUSKoKIGdaqr7eHMQQ6CtxDJ15TkfFIAwPey/FTQGyMmY6XajtZqaq26C6d6+vVJYMGxOLcxnyYRxfBIkYHPMS/4125nou11fwlVnyaOp11XyGUSEeV0psQ6h9fKz/ARGKMi2Igg==
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

Kiryl Shutsemau (5):
  mm/rmap: Fix a mlock race condition in folio_referenced_one()
  mm/rmap: mlock large folios in try_to_unmap_one()
  mm/fault: Try to map the entire file folio in finish_fault()
  mm/filemap: Map entire large folio faultaround
  mm/rmap: Improve mlock tracking for large folios

 mm/filemap.c |  15 +++++++
 mm/memory.c  |   9 +----
 mm/rmap.c    | 109 ++++++++++++++++++++++++++++-----------------------
 3 files changed, 78 insertions(+), 55 deletions(-)

-- 
2.50.1


