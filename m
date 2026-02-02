Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADB1E7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFC76B0103; Mon,  2 Feb 2026 10:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D586B0105; Mon,  2 Feb 2026 10:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD026B0106; Mon,  2 Feb 2026 10:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0DFD6B0103
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF06F1A020A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:02 +0000 (UTC)
X-FDA: 84399972804.03.9F55B7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B133110001B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KTB/JqlE";
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1iMY+jikK08ZjkLlrur0WsOkROrQqMTAAbmFRToOg4=;
	b=FJV5OHOhjr4Bbm3lrTjByfBwJkK9W50+/Jhfc1KOYfS5KP1B/giN2THan+SweMMKbPwwKp
	q6j/5x7zsqISCRAwN84pTWAGti5HdnoeLZh8EXhqsi6lDB23WBhY76BUXk3FAp+xXU7XJ7
	2fvp3llaATgap23jDtyRi68ws+4jwVg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KTB/JqlE";
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047880; a=rsa-sha256;
	cv=none;
	b=N266V5ap4gToX65rJvmvHmmG3iaOkE2mMskZy2lflg4SJn1IKqvSc+skLjc8SeIJeGlhbh
	32lOYjJ9etERXytaUTIJPWdOWo0+Ex5Hbpf4+qx9wc/xmrYr2FQOJpxoaATd75QT1mXJmk
	ktC/VbpRPc74pI+Qxvwh5+Y9DE2heJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4F6A4358D;
	Mon,  2 Feb 2026 15:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238C3C2BC87;
	Mon,  2 Feb 2026 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047879;
	bh=WA5hQUJoQwTD5DQSyUz0pDcyfXp3ks3On7x7VB179to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTB/JqlEJ0Yf3Mxhwq6g5Eh82E1SFor4YtOXOIN6rO7+jz9lW9Fw29EqJAlEXpsRL
	 iwvtdYp3BaZ5fu3J1xAg713q/QqLl3My9IZgIAQCBiYjfLvhSObD1qCZeWFXkyCsil
	 +vR2/tXjHW0ok76oGn2apDUe0t1dJDx4otlaEv7PuZ5YqUzW25UtS4VIcuR9cKiGoq
	 GqZjOpjlBTkFFAEWMMBEKs+GHBQajRMqu59ZIoprVf6MtX5W2HBsJaA0wE33RKtZ1s
	 Xxn5wZJ7qRNOdEaB2PSAusDvl6Ef+8OTAHQZ+40AtXpTKNOS/Q1Zjc4o85TEqCjXY1
	 9crBnQQSJUBOg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 47309F40069;
	Mon,  2 Feb 2026 10:57:58 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 02 Feb 2026 10:57:58 -0500
X-ME-Sender: <xms:hsmAaTBQZnR96Q91CZbmjPSTynsTVNZHY1DrMuXy2dOUuuY5IVSovw>
    <xme:hsmAaStOjFcQZEGn751h8X3BtKm2h7RP9etcmAKofmY0s7nHtkRsl7PaXQzIiEMmS
    JN9IyHyC_QB5o_wf4KSpLcS4db3EGHqpT0r303vTIlHGddgIbOaa3o>
X-ME-Received: <xmr:hsmAaYvLSawEGBnSu6hIZGeYAtPiRYjKtE7pbBIAio-yUv6gc6DVSi73tcilPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:hsmAaWrfkRMR-C481qatfZVcrV7WP255E9JiKBpBFYHu34vxe6T1sw>
    <xmx:hsmAaUNGSCpkDpGg21FjG5PCQVfurMWNdvxf_13zAqbCu9oHDe3Klw>
    <xmx:hsmAaUmg9Ut75Ri69ArrFnTmH23UMAcC5eOYZyJ9ln4p8ruiWiuQ_w>
    <xmx:hsmAaes8SEOO3JrV17-fS01MfuAA7GyPcoxf10sWs9kU9GIckuILmQ>
    <xmx:hsmAaTnyKO1nCmkLtmeUgvlHwZhpCCTOlpIMK0dE-1r-Nd8eLa9G01Sf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:57:56 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
Subject: [PATCHv6 09/17] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Mon,  2 Feb 2026 15:56:25 +0000
Message-ID: <20260202155634.650837-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B133110001B
X-Stat-Signature: aqmujc63rmpa6ma1mcztixbxjxf8asym
X-Rspam-User: 
X-HE-Tag: 1770047880-134305
X-HE-Meta: U2FsdGVkX1+CRnhnhw5dhtQ9wqNSBZmeL9YiTlBieotIdpQZm2xkDf4HhSn6rYobAWdjLswB13hVGnMSVSgciZHlZ9xSr3srh6mPi4iIr0NQmb+QVkxL4MEsytRNuiCymXvOOthtTycw3L50ThSKGalJXz136ewcNmm5tqHWZUY0I/h1vcprJ0cb0l2AdCx5g94a+Afc5wSGweJybNbV8HAtLO4KdNMwAG3Tri8nQSW8KALMy8ryFdsXB5RtTonWL+CK836xKZMQzJh49ot92QA/r2gMQTQxTNhrhseUwFJ5ZooeQnQSy4VQ22CGsl0H9nFkW0UsD/duBLwA2/FfkipXrEjirkUTi0C+5OzWXh41vm6q3tRoBII2REkhP/1bPUY4WPGnj4iA9EIcYkrtoG9/a4oI1TSqn71ijsEyqvzZLc9C0yxXyLGdnZaXI+NxiW9yaXxlNGsFwl3d+3J0M4Q3wl9/9OqzjbEPd+6ihu2bjoZlSS+662FlBpKm/jdmmyjj6Uc/WCEYhEBZvCr/T+R0/iDStIhpZUop4wkrOwiKl70SRjZLMLal/fSgZB9yjs5exBD0EZy5Mgm6t2T1g0AxcTRjLeS7cVoBiFZEudXbsl9a9TpMDFQjgemNzICIaSp5NRp6GgFSOdrmfBs0rtBeIwvUQ1Y1C48Yy9XPGB1CNCIXWQBpXXMjRSO5jDN2xxKz6INIgOb9OcJXzOWFXrPsy0WSbkzzfyRNW1m0q1FoOZg7q2rMHoaEn4AEY2BZ65xqcMWuTKFHBDSwFKtDHpduQvxg1U8oanLOj8a86q/OlPIXfZSdnDHUBpoz0B4l3dEsLXFO+vDa+x4vUJwjbUhk6JmASjqyzG+ZFU7QARt+AJ1H7dYOT5XI+wMxo/dJ+X/P88x7JwB1PvaSyaehDWl1LSc/qgO4XwYtYjTV/6n+rI7AaWHqLk6BfZCsHtER5cvitD3DBafJjNSmxTY
 BgyGXLWy
 nWykJyCE86GNQgmUndL19WTBwaFxOxaHFWmms2uXaYCe74EfCr5gxL9RC41v3t8NINMmNgY+Q38ShzPjyh648BIXEvPV12xm8O4buVwOfmyg6w2U33WrlBzWfgAJ3GQ//GhgzqwoVUD2ousidTcMNKpG0DUghemCfH77QzXkOEWxqhNscDcwD+CIg0sAAx+AC0uwXLJKufPQaxJjAHOlU3QIkJ/fxB+o/HPgioyjkPGRh+xMSRCEmafN9V+HjnDeke9Gvlqs7RuaAhyQDIOP5Oosai11baV9JYHmDqy586VJ3OWk1ClQ0rwD5xdMaBdbgrbws3RNHpIe+Xm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If page->compound_info encodes a mask, it is expected that vmemmap to be
naturally aligned to the maximum folio size.

Add a VM_BUG_ON() to check the alignment.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/sparse.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index b5b2b6f7041b..6c9b62607f3f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,13 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		unsigned long alignment;
+
+		alignment = MAX_FOLIO_NR_PAGES * sizeof(struct page);
+		VM_BUG_ON(!IS_ALIGNED((unsigned long) pfn_to_page(0), alignment));
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


