Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05F01039881
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428036B00DD; Fri, 27 Feb 2026 14:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2CA6B00DF; Fri, 27 Feb 2026 14:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8466B00E0; Fri, 27 Feb 2026 14:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1B96B00DD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B87998C719
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:39 +0000 (UTC)
X-FDA: 84491261358.27.681ABF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A246B1C000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bm0gaAma;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzcDAmaH9JixYOJE/2xZYZ+Vx25l8DSEX8qv2IIlb9k=;
	b=ATOPsmd5WRMjVxV3a2a/5mrAsRMs0vEUFsj0vUYLdloDZ375aO4/vARp/eCZaVWT/aMCK7
	tD7RrteD7PALvnNx+TERrb7DV/3b9/6iS7yW+Dg9CiEj/D6a4cG1zLd170ZpPjjM6I23f2
	8ykxgJYBz9C6494mm2lgbWrybcO+F50=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221417; a=rsa-sha256;
	cv=none;
	b=ZBCsNlV85LTkShLryUEqmnChnh5Xwb4YzZeT7Y8iZCJ5hMVABbCobItMaPwQ21/41S4W+H
	F8I1lhIuphRZK1oakG2BerzHa/yfUN8YimQFApw1JkC4HrNfhJBU/vJ5x+kL3xm02oArin
	lxeYE6XIPfA9ZmMeLUFcI9wcUf1tIQ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bm0gaAma;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F30060126;
	Fri, 27 Feb 2026 19:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6401BC4AF09;
	Fri, 27 Feb 2026 19:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221416;
	bh=c529vercbwstG5TFH+F+kzdVCfYFyALt69KitoOnUEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm0gaAmaQ1bJ8sgx3TWMB+xIREyMHatYIyVBcUHwG79kGLc5qiaxD0Y6gKhxaFMCC
	 YEn+jWI6H6v9+HRmmvOWHFARKqtBK20b3zAAa+WwDKeg0QI9bmKB1iEq1NmQaUm4nZ
	 SfHwMDN9Oz7oSsRwTlfAsI+T+eJjvrQfccm7dnnscjVhgVzV5RImkwVgTCgbeALeqC
	 4bdLfelxN1HtsS57T08sPmWpAGiHfXxSJzzsvb6sWlWLZE/VgLU6Lc7tUfiGK1l40p
	 8L11MfK2pz5awPW+WynXjv65FQD/1CJb3ivmMVtRM3d+sAeIcLuirrgLMa2AZcl37H
	 jBfv5WwapbzFw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8CC92F40068;
	Fri, 27 Feb 2026 14:43:35 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 27 Feb 2026 14:43:35 -0500
X-ME-Sender: <xms:5_OhafekAPt-AIlYFOSJBCUnEbCk8VwCH28zjf1j284W-aqnAfGudg>
    <xme:5_OhaeYw4QguEhBl_mwvB_1OeoNVUzO8DH5vHdMAsBWAZyVrf6OTgPHPnKFpBIg8b
    3OSBv_UCQ6qfOIldpFJ7FMxbKCpam2PwZx23AooL5w6jB2ZDvGvf4k>
X-ME-Received: <xmr:5_OhaSpXhp-jqJVaHB23ObgaEVvqG3HfA1v28vqqcuzRHy4BTtbKH81ue6q6yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrih
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
X-ME-Proxy: <xmx:5_OhaR0sXqKph5_rw0WuRMyzH5slOQbP7_HOu0RzVuSPrjcjtYIu2A>
    <xmx:5_OhaXrAMXNhRdBv-XJ2UTzY8trTieotBx7KU-tmHo5A9y9nseNW4A>
    <xmx:5_OhabQT4Hf_vRdMH0-qZJfxZQemlC05MvyWyWo647pBJ07JHyvJHg>
    <xmx:5_OhaXqDccoIPKwed1xo-y98V_Nr9hElYCasSjezJIruJ8q_V6r7UA>
    <xmx:5_OhaRx39Jw7lS-g7t_7V_1fLFMMkZlwkHMHOUvdxICj2rPvEBXVbJLA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:35 -0500 (EST)
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
Subject: [PATCHv7 16/18] mm: Remove the branch from compound_head()
Date: Fri, 27 Feb 2026 19:42:54 +0000
Message-ID: <20260227194302.274384-17-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A246B1C000A
X-Stat-Signature: gyp6b41smh3qi3sbfdma1ahrsq9mwqbz
X-Rspam-User: 
X-HE-Tag: 1772221417-478272
X-HE-Meta: U2FsdGVkX19fkphYyZudUO9B/ayq36ezV4b9akOfTHGhps78biBvGdSaLaDBqRx7bz8/DiMfU3UZbshMipiJfSUpNm75U6nGtej7XwQrSdQBe+TNxA0kfbvR15z89hxo04oM0kRixYpPyEmTuRnTB0eZun58TfyWNWKlwIgG7vtNkC9uEAdg81w4ttReuemWR64ddWjR0Za0IqUM6f9YQ77Sa34uykmE5Po7iWRlCAdrsGPER6xCLnEPzuqXFXPrjqu+SVzb5vMvdqZbGp2nenLa82OdGOSFfdxCx19l0zqaElnALCimk8KACobJrescNHSgtbh5HxQNhtj7A8as9JfK5pcDlePm2hTD4SAGiiD1hHU/FCLLZqxPBXut6vdK6Brfz4FwuXIBCgXYmQU6zGYEzAcv9LoXwifPCkw34BpQqREjibEv71XOeavFGmh8vCgr5MwbNboGUgXs1MkD+47TJbn+scdOQlIB3Lo1be7feVEpfHFJD60B8p51iWrcXjmQ0u1Ad/4NSQVZ+IVjK/IqqZw4UcjC5XlWT7k+6ydelEYl83yAv3l0akgiYklj/EwNh0fz79I9NzrCrseDWDHu9EEM0r4y82JD3IeuHcg6ky/d9VPXjzE3gALjNmxhhv6KMX0GP0X6E8HnOVKVRY00FeFLW9WAmaYugJQnN5OtYelDk5ZK1qBklVLbA/qH8wgFG7hI1JT4MFvLtIsUHmOB/b3IFZaUtyBPJyUPhWDQXAESzAb7pxFetDq0DGoCkbgXpQWPM2iTWKR2gAhGKxeJbRadgO53qnxT04VwSzEbLzt7Geiim3HqPhhsh0CkRaR1OSwBPgd1N2jKg15wKgakSJbgpx2Qgtsac3CjtmHLU3Yk/Fi0TXI3HH/vofgJPB0bzQtPC7nomFF+xYtPhSj4gDCnvtsD9UTKjsTZYHVrGrls8pTiTGTBb+03Hi6jBZhtEEKV5YTCqds/fc8
 PnOAAWD0
 v4JkfxlYjAtk5KmlA0yCTAdZgc7edf5H44b63q5Z6idxfKesuiXgj41800AAI2ilyo7Z4ICcE9LZxtjETxHchQRUAuvJ+Yf8haAjjaqbNlz2Vv3ACDM7KRpeb15eQcK/rK4kaFICR87eS77jfmeVEbSFZwi80wX39FCV2N8EwVUX/cBSq95j+MXXTYuwrGlRTEzrwDwbdPOX8ZijZkQ1Bgkm0Abg59HZPFCyYdTygoyg4b7fZlM9SvlKbRoa356+g73m4kyBeRSlhHLT57+UtH36udyMa6mtQw9G0edO9MMyB2jx5Yn4H580xDiQHqyJKoJUtT+pFT3m8KCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The compound_head() function is a hot path. For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8716a27ef347..9ef2c3b28e07 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -224,25 +224,32 @@ static __always_inline bool compound_info_has_mask(void)
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
 		return (unsigned long)page;
-
-	/*
-	 * If compound_info_has_mask() is false, the rest of compound_info is
-	 * the pointer to the head page.
-	 */
-	if (!compound_info_has_mask())
-		return info - 1;
+	}
 
 	/*
 	 * If compound_info_has_mask() is true the rest of the info encodes
 	 * the mask that converts the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 *
+	 * Let's do it in a branchless manner.
 	 */
-	return (unsigned long)page & info;
+
+	/* Non-tail: -1UL, Tail: 0 */
+	mask = (info & 1) - 1;
+
+	/* Non-tail: -1UL, Tail: info */
+	mask |= info;
+
+	return (unsigned long)page & mask;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
-- 
2.51.2


