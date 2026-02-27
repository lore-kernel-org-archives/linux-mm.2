Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C7EFD9E1C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095766B00AB; Fri, 27 Feb 2026 14:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84646B00AC; Fri, 27 Feb 2026 14:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09B96B00AD; Fri, 27 Feb 2026 14:30:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE2DD6B00AB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A4D95B8B3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:48 +0000 (UTC)
X-FDA: 84491228976.20.EFA09C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C3F880003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZsBQD2tz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psX1/RN4D7tc0hPQm6iUSxbTVKqJFYhFZ0jsRV8hStY=;
	b=5xX9/X+T6khTW80qDTW9j/Slowm1xFYDOzfq835TIBdFqmyx4BRxUenJX0lTYoNwkYlcsg
	GqBGpg9QEohxaYVDN7lH8TGiEZJgMmVRFn04XrEkwcqaw2hX1AC2piV9cjetsCvwftEbpq
	I0Yjh7bRGC+baKDVrXxAXU1VldzYP14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220646; a=rsa-sha256;
	cv=none;
	b=O/eNqviLChMIDQHIfB1oc2qVq6YuOJibUM0oe3EFh2lbvjDaNZ6ebiwxKHS8kxKxkRwn4L
	GAskE79Fj6G9ysnSWp/wcfWFE0t3rsyEJByPUs4JkSP+TSzC/u5mNHBtIFDEP/KhWK2gfW
	X72PSOoPA4FXrtV1dLO27TI/GHa5avg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZsBQD2tz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21E9D61344;
	Fri, 27 Feb 2026 19:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAAEC2BC86;
	Fri, 27 Feb 2026 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220645;
	bh=qL/9y03XAUyVqo5OQVqiOiCFnXGU+LUEF5AtRX0sSeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsBQD2tzfYu543gNy+ACr4mi/Hv5Dnqoq/PeZts1R4OKNurck7yK4gOrQR/nFQjMm
	 hWBaCghcemVHSnCF/kS7zj2+r59Yv9uGvXh+naJt00XKpnXR0PHc25yH/TaoOXypBz
	 SJt5rzdy3A0FH7awE1RXRyFpP1BbC2zMa6U8j1krzTjTm9sC81a+1S8d/y7uLMjbP9
	 LsjjlJU23KJn+4EvJRgIWsIv0uOoYv0LRexOd3LMi0xgsL528phqKPLF7YwL9i52p/
	 2SkigM4SOXN1uGF1QIf0QSF6Q80eitzQhvVeqdjYATuSWuvIQMLD0aTFNk5VFLp8Bx
	 MOFN3wVcKGG0g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 730AAF4006A;
	Fri, 27 Feb 2026 14:30:44 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 27 Feb 2026 14:30:44 -0500
X-ME-Sender: <xms:5PChaeHNa8uVhrct1Uccqzjua5E_GWwmn_J752P2PkczmrKtz4tnIw>
    <xme:5PChaYjY-7BOCgcSVKQWUsXepNil9-KkDwWWdS6Bn0BnBWAbxgg4LrnYxoxnMG7MA
    qwF_iErrwHY4jVtptQh6_68gVyRNkqBJsaMUCTQmGzNjTspkUJMcDU>
X-ME-Received: <xmr:5PChaSRD0ypMJx_QyALMeHtwordrV1grw2N1MA7VShVI6akoZKJtEcVy0iCF0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:5PChaY9BmWQg0N4t0rzE-4IKm0tjs6EPE_Nj0ERt1N_DiQcfcz7Cvg>
    <xmx:5PChaQROttwJrfc81Bs1Rq957unyIflFHFYtq9M3jwSv4ng3GUoMww>
    <xmx:5PChaXZTsqMmtCvmJ0mwH7ZMzmoqNEDYBRWQ2rSVM6-WfuL8VOzh4Q>
    <xmx:5PChaRT1Fluji9nz_lXyK0nSTBpaEPTqNVl8x7Rxz4FPF1d4KQrdag>
    <xmx:5PChaa4xbh2w2LQwUWkm8sxVKxAiXwicQ1as3hoBcQL3yMwYU6ufDbh9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:43 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 08/18] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Fri, 27 Feb 2026 19:30:09 +0000
Message-ID: <20260227193030.272078-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C3F880003
X-Stat-Signature: pe4dy9ijsq9c1mfrruygxhzwbn566wdw
X-Rspam-User: 
X-HE-Tag: 1772220646-117773
X-HE-Meta: U2FsdGVkX1++1kYLM8VEffzSyB/fpXxBcVSqkJxYeWqSNofNNSFN+yDjA+FCLd6olY0+MjRIikXkuxkYqbdWo5AEZPQ/Yjt6gy9SDtYsgtkoy6jpJQRMcrrEgW6pHPhyXkp1sY8aVsXlZBOHnHM6dCYAzQv8EM2gf7AqhDuxhlsV9QbaD6ErzNf32SVFcwp8llFyOoe36RwEzJnBns93OSnnUJO94+NQvMzQrmGgdIggkpSyVZcA5gnpkR2peV7U3NbiQg3rizoPBfQ+q1qG6tZVIi0EKruFmKhjtlspeD+L3E4moCEieTKryMrKkbWPGLiKYUs4yxo5aE5O8Fntyv2IJOYyx13C3aM3QFthVOeRXA71cP9EMJkUKwOAJs8qCBcXJEWk5yMpCeckdzOeJ3wF3Yl7f4fwAcHAZjxD7WPjmNSLnEWu52rYmF9nROCMZqTe+5lpBaAD5eeJYYWlbcalTWa9w5q7REF54I1tJ61FB6eLq4SzyoWSBYbkPWtygaoEewSLCPbQPL2WifZw5+1Pw1CQ3NDS9Xd8fhk/+9HinuZCJcFI3MVtyj/sc+WmCTaMPgESrZS7a4N7a0uOPX+z/ntEH5qwJ4IOJKTwAtEpqA6sMkqAfUo3ThRH3EqUB4H0VaMjbbR4wlICn8k7uJ3ePkmvjdw4lFZ1Zo+5ZZOaonC6sfw6dgfUANCMeZWynaJ/bxcMwarqUSny8cYYGWc3RVmPPH5qmQ9k7u67GtX23u31rH74mcIvwFuCtToWcRe64k6V3ptNQ4aZ5H+F3mbgW/GSi7Jr6fqIXKniGvANArcfXEBWNKGy2P7d+koLoeeSUUX1vPXXyKB2txCYgM1T7pwGEvcWT+c05QYa1aUVHBa36V7vIj1fN3/9Rh+DqrP19pfO3Th8zHtBp5nGFQRCs2evLzT8GmUJfggZJfeekkRyn0mD2UNicTosCCMy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

If page->compound_info encodes a mask, it is expected that vmemmap to be
naturally aligned to the maximum folio size.

Add a VM_WARN_ON_ONCE() to check the alignment.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/sparse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index b5b2b6f7041b..dfabe554adf8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,11 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
+				    MAX_FOLIO_VMEMMAP_ALIGN));
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


