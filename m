Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C57BFD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18E16B00E1; Fri, 27 Feb 2026 14:43:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02DD6B00E3; Fri, 27 Feb 2026 14:43:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F0A6B00E4; Fri, 27 Feb 2026 14:43:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF346B00E1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20D0A8C729
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:43 +0000 (UTC)
X-FDA: 84491261526.29.DEBED1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25E28100002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PC0m/Cga";
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcJ8r9+9myGaXNcmZJTxEDzI8cwMAukJGYfFOhUtSK4=;
	b=xm2HNfPP8NdGYvCLnx4seTulKr9q+u72EYPOvhSc2XpySpt14h4VCVxTSiVq0JCfw2UaZA
	X1KQHQrh9W8ZotArCG2DRJnQGImxodeMpkhqzhd0cp/dgwoEoIXeSqeBIx527j9ehNlFyG
	lke3zl/5hQQ0H9zoqFKiNnrTRHfA5bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221421; a=rsa-sha256;
	cv=none;
	b=HcrsH5uPx6bHvq+auyihGGLnct8N82ObIp2Dlc+dzZrbZkhsRwN5ZIXaV1Zys4tmRFnfex
	6dXSjbuEjU+Nc9C7EXDe0BccEvjAXTZsv9OxzvCsY7pYP27n4+AZ1rWI1kERZ6nADnbN+a
	CFExgLxfWdIvUCpcKSk1aYiNA04cQzo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PC0m/Cga";
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D7306013E;
	Fri, 27 Feb 2026 19:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E88C19421;
	Fri, 27 Feb 2026 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221420;
	bh=ZAx3R9GqRsOU9srbTUp+FvCts3Vk9aVQHLhkmRYHaUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC0m/CgatqGb61BR32ksOciiVWsh9kabYVfM4sb2/RkMf4uKu8sUINuIQ7YKsorvS
	 X8meq6NX5tAjFYkJAMAc+U2k+i4eTGfCfbcG9qiUSR98uL66OKdBu2ZbkS7YGkr3nr
	 SuVMPjXdhknEHPlp2uncDkaHD6hGh68Q2shP4C4O+bdyrQc93QztUAdoWdQJgpSWLO
	 1u5BiZy+Da2laUwcso8n56StTGi1Kffc9Hdzym29pU9S1xsgQ7VKYCxtwMPHwAGeOM
	 1bE4y5mtV6gJA4o97riwF48Al8mcaiN1rb+cXwo/XjnDN3KOVZmElpaA3kcNbpZ75c
	 /6Ar4HIxZ1vow==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id DF990F40068;
	Fri, 27 Feb 2026 14:43:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 27 Feb 2026 14:43:38 -0500
X-ME-Sender: <xms:6vOhaXubggs39m_iHxkE19Eq9hu-qDTewGwNs2J3KvicJ-8TDyBY0A>
    <xme:6vOhaRq_YY0wM3gUjaruqNPflidLhEMMOlSsW87SO-UNQOtFLRMnAncA9UKz6GDf9
    TmJcSe5URH__nx-T8DX7sb2rTQ6V6z4j07ieih5o7LZsT64IKEw-iA>
X-ME-Received: <xmr:6vOhaU6b9bnfnO44Wsvs220hFH-nJgEtidc-Hcsc3LY2D-quMFF2K9Y39TNI8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:6vOhaXGHJuS7PtiXmnSE6B-g_1FNPKMXgA8MRdODV_MXJvFT7JCUDw>
    <xmx:6vOhaT4b_oBjocIw7sF9fc9YXDuSrFTXQQJZEQz1hkGsuV9uuzIXJw>
    <xmx:6vOhaSjRHpYcTP_XbTmXXQX_gvMAqbFdMtZrz1Mk9NHU5Kc7_4CDow>
    <xmx:6vOhad5lTkgJplK5FXgb-XJWPKapPepvuL0R5_dW7i3dk-y58KJUQg>
    <xmx:6vOhabCzlhPSJWpu803PVqtD4DFwGJAsyhQ7UGlxPIkg8I456R9GWqHZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:38 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCHv7 18/18] mm/slab: Use compound_head() in page_slab()
Date: Fri, 27 Feb 2026 19:42:56 +0000
Message-ID: <20260227194302.274384-19-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25E28100002
X-Stat-Signature: nq4u4wwtbwpm3frz9zn7n8jhrrrwpc5j
X-Rspam-User: 
X-HE-Tag: 1772221420-516941
X-HE-Meta: U2FsdGVkX1/XZaEMou3Jka/sWpRktmiK6njL1jBLFhwbA6W1/W8l2DmgioA705olmKCx5izIF//Wq0C9OP6rPHaWrt0uYVdCYJzxhwLi8aP7n9G1HlxjixJ76FU1d0um1b7RABpW1q80EwgXA3oXmH5g/C4zBY55OCgzpbwJw6s1w27EGm1Yp5dlEXe9CbGfKdtjCcLFFVTp0q5ZFlRgeaSTurAIJg+7ef4FkS1ZSi/KETv7+vpcc/evjUC9NDYDw3Q2qUJmnL9BkSRlRIjJttbigDab/wHizRdhXqOieMHaw2E15AaSkePRGNxBya+O88IrEQy8W37LXsQx/iQb/bB5LoezlTqFJfZizxlMWXkz5QtrxnUqwovqhzcx46DdcFnYfD7GNwyg2xwrcAcbP25gjSRJWs44yl7Nqvv2QyM4AiG49dRjeJmANzj1svyZDFFwID+MFtRlZRB46TVmeFMt/IpWmZxlhwZmvgqjXGyztulVmpdwOQKhPbnB417q43YSEBLBcHzZqOOz0KE4H7qpaTELgjkf6Q2HAnRH4GEIIgTxl1Q+gAN3eakaRhtKqRDi6ra7B56MyU+PbHrLSpEt/+H+U2GTupY0MRYVKb3/6VkytIy38KVJYrFWbY+49qAtdNf2PwOOWze5bRFkW9CkkxoIqlFj4j/sVWR7VhyAzEueQugEyHT/W5x/Vi7GzOZD+0BEysP+3+5NZOnDHDjSrGif+tTzrUh1X5ssYcC003bwXacJ5pApIa4C4cDRe/YI02bFevm63fYHhDLTFoUcnnhLv0jPFMSDCvlZKZbPEn1D1hjA2CrwnsJVVwZem0RUFoNeFWVF59Tk/12T9SoLgj8x8ebU7JgXCuR1mY64GkrtHoJcLvkMZcIEK9i9JZZRL2IB2GqnDAFY8DGTXqN6DrAmVB9O1H/GzQ7bJBH85QIf2ZQI5Hb5TwjZNW7F+U0HIqVT4jZYyYiIgDA
 EtoAOYP9
 MlVsece4zvzFtvlOkM2rTK3nrW02POqemzTMOhla60bW+EVRoSakGpUr3NzS6N3n2th2UUHMyQldZyU80thDew5x3f6cS+6uj7oRjyyfqHEVbQAngYEWYYDatl5ai1bhFya7omvHLlsFhmwzFHHSCBpsmWkkYo6cPf+ROt+B1UPCouY4CHvfm8O7sufuuSnSdFnN51co6It8WISL1Ek2EWwlYyc8/4LfXA436cd0IPOK4RQPk37GDi+F/v/Akl9khbn9o4QV1JvJsv8J/ILbQumqv9ipe8nwfr46wC9Rpmgq/ydTNlw2H0fYzTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

page_slab() contained an open-coded implementation of compound_head().

Replace the duplicated code with a direct call to compound_head().

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1a1b3758df05..7d3b929019ae 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -131,19 +131,7 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist
  */
 static inline struct slab *page_slab(const struct page *page)
 {
-	unsigned long info;
-
-	info = READ_ONCE(page->compound_info);
-	if (info & 1) {
-		/* See compound_head() */
-		if (compound_info_has_mask()) {
-			unsigned long p = (unsigned long)page;
-			page = (struct page *)(p & info);
-		} else {
-			page = (struct page *)(info - 1);
-		}
-	}
-
+	page = compound_head(page);
 	if (data_race(page->page_type >> 24) != PGTY_slab)
 		page = NULL;
 
-- 
2.51.2


