Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83554FD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F6F6B00B2; Fri, 27 Feb 2026 14:31:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628D56B00B3; Fri, 27 Feb 2026 14:31:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BC56B00B4; Fri, 27 Feb 2026 14:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE896B00B2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:31:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F1D813BD0D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:03 +0000 (UTC)
X-FDA: 84491229606.07.5EA366E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F3FD74000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dyp1+8g4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzcDAmaH9JixYOJE/2xZYZ+Vx25l8DSEX8qv2IIlb9k=;
	b=SN0VjH6LTnZdvdcGlojSHNXneNB3pGBFq9RSy5YCWuue2YNP4ppE2LyY3GyrGj3n9AVDM1
	ErqHINmnJFW9TxQufUWDY9DX52fDeC70ccUyfF8YhXaQfTJRZiSWuVdXpH5uDjtmkwJUHy
	H/pNnjVQI5MAlVRlFy68L9AfHqTO0Ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220661; a=rsa-sha256;
	cv=none;
	b=H98Hl8q5uBc6HnbI7YxAHSa8UZ7EpIvq0PkETtxeNdDHWmd2bpx8nr70MC7HrPtcoc9yjK
	UYgNB+cHWDVfUTHQc8tiJn1rcguzQTbJ/sIRfwpPmlOiTGu29JJcxP24Pqz+SHC2cU2igc
	6OJ7QA45bk4KRIHtCJtT7bQwnmyDcmc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dyp1+8g4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C87060130;
	Fri, 27 Feb 2026 19:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EA2C2BCB7;
	Fri, 27 Feb 2026 19:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220660;
	bh=c529vercbwstG5TFH+F+kzdVCfYFyALt69KitoOnUEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyp1+8g48y2OcqOSeYGEjoKT0idbL3jTwpojsnJL0rIcClVGnvuFAaefTamVUqbTm
	 3Q92TAfwMcoA6PcOvlzy9qqPll95AP8IJ/vx/+O434gcvr6hHAn6aOWALlYjJaLmDN
	 MFQDa9dAcKm2BmjemGNQoSIKvZow8DiGkHMBuDvpPwSwnn4d0ygGN/X33kc+Is9XCJ
	 6m1S6qJUthE3hj5ZNGq3rOm09qkGY8a5R8tZxhk/OUrHsbEfqf4M0NB5sKUBfFFKGd
	 REhqQQPtG/Cj/Bvub6xYTHb1SegsT6hhvsEyefmIxUy9e+sqR9zzhYT4goBo/LcRTR
	 wgO4cALvxhe8g==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1D72CF40069;
	Fri, 27 Feb 2026 14:30:58 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 27 Feb 2026 14:30:58 -0500
X-ME-Sender: <xms:8vChaS6jzlkxbDbIyr_vIRi0TUKHS2MFokR3ipxt29nWtG3WBTWAxg>
    <xme:8vChacCuBqQZbyrs4cMNJdE25tahZ0Sg8LjFC-phcf4hYcRvymVIxl4_P3HNbYkHh
    w6JA998peBSuDG3YYCKS1SjAazTll4f2sTYVFLnBXekVcA7TNj31zQ>
X-ME-Received: <xmr:8vChafRFr2tocQkIE-6iOhlqDazLJO0vxQgIapCujOYUzxWjDDXjQX9mvA4jxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:8vChaTZAX_vRkiYzv7zEF9fIomSGXxNse17rmYDENgPgI8ROBdMbeQ>
    <xmx:8vChaUWJIPuC6SpPlWrMn3KhOomQ2gNXCqHQp6HDdE6Zqd1Bte2s5g>
    <xmx:8vChaQVkUDkwX5CSH8gyLAHrHh_J4kgRn-FgNyBkVuBr74bXkRN2hg>
    <xmx:8vChaW86JQ8dAGs-mVd_eRw-IjHCn6X3ju19WpkUScTq4ApigbcwiA>
    <xmx:8vChadqcQP98v8I-LHfbmJSgH6tnptrpPTzN1yL6SgumcEx4S4YzBk1T>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:57 -0500 (EST)
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
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCHv7 16/18] mm: Remove the branch from compound_head()
Date: Fri, 27 Feb 2026 19:30:17 +0000
Message-ID: <20260227193030.272078-16-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3FD74000D
X-Stat-Signature: gyp6b41smh3qi3sbfdma1ahrsq9mwqbz
X-Rspam-User: 
X-HE-Tag: 1772220660-678386
X-HE-Meta: U2FsdGVkX19kGNBIya2e0XmrTIOV9Ay66ANqCuugQvT3iL2NqzO1IsJikgJCEW7VEMwnBi/cR67vA4bX+QQu/MmFQo5jfDXf+NG4jl7DFrxZhPRkmbv2QqC0tZ17HjfQAWR7oG24jiCEvBFefx2tKZQ21EJfT5seRXhijk0aa9bRjs/V7vg1+w7y6z4tibbRDDlri0w7LSND161hYJABRtqsPLcrgqCvCH/RPZ5iGxy05V4VGD4faMT217rFl3sqkwKmvaIpvlcuO5RlNnFPTer4GJudHlU5MSQwJSNRTDRael/YVUlAwuwALMIURjFMoAwFOtTh7ADGNPTaj3n9MZXbMeTMX6nMFwaJSyr+qfhGR5I+U0mr+Xlx0d4vZsnewZESGyjdu2dWZ+TPhZIVYXtUdzPPPasOYTa4uM1C+hURmZoJNj8tUFc2+o08XDN9S8TTKPE6E/5O60SVasnOv4jkgvAyOV6f6n2aoPRT6obvmpHyJ+3FUN8gxGESHueYA4+5uJBCtouMsfdEBTCYp+7AFmQZblzZiSC/hQgzjoDZ7hKZXS5+XdYSNorBNdZnoJo3ECUHfz0suNuicCQEOBdL4DGbM+H2L7G5YfKwcEJdzx3gxdYe3KAwL6kIDtMTPFe2hlmG06aGTBcMTaBWtJlupvWJjOBa5VeMgdPzPsY9xzbgpu5bBylL8ClBbF2rYMSkmqQiWdtUDjai/hn42TzvqkY1PK05gKXjK2r+jC45nbUQtnuLxQHiR1whT/XcmQlfyWBYbUrHDs4d8ZFczs68Rx1IA/MgYzDCZkq1ydfsw+m0mpxeCxT5o8o3ddAbsoJvqDeDxxOz62SSc6p9N1wPSazHQdDm8WXgfuibJ5wXIfRsRXFg6cyRIfibSJp0DPyAkRsnSmSXjJxjbeSgNbomC89Vk/afUr+1GG0AZvP8JWNlrPo5/DlRQWeLzK1wlWdsXwlQt5cF9r7TsnU
 NPTPDSaj
 Jce1Gd2RJQrPxHL/joomD2B9DbskX4xBpIzCjIcuBjadAAosplOiOgcA+Lzjk3Vh3WmH7GWlWfqM1pshGS3gpzG0tf5xh03fp9S90QEvyiFLv8ec4Z5SMUm8uiI4KKg35xYfnt0QBInqZ8/ZkzavCaKEmm6EGdOO2Ao+Cg+gZpeSw7w0b5GvOIery11uxRFVnYWC5JDEHGzlMP7EuRjNdif+n0DY32RJ3XIkmJwK2EM/ipNzrGsQfUOzUydmedtnUGfsZ6Qs5f4YGHYGJQmbjkY4b5pb0CljJvp6jchfq2/1DFRDJ3SDHlud2u+hHlWKa4LTTy8T8etTHFM8=
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


