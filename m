Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49012FD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFFFC6B00A5; Fri, 27 Feb 2026 14:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE996B00A8; Fri, 27 Feb 2026 14:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96C46B00A5; Fri, 27 Feb 2026 14:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3B2D6B00A5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A0E55B8AC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:42 +0000 (UTC)
X-FDA: 84491228724.19.B782F74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 15E571C0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWDP316C;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNiK4foKnR/mzFqjupikBWO19R9YsVYf5Dbq/rYnRnQ=;
	b=wHRUSrxZy2pgqQc1Q207ZSnvAWMavCgGfml7qrPYvmYoKk9S5teOnmIGXrdJwqppVVwATK
	8bqj9OUGoR3iZ9Fo9ca4PGlevKTgaePau9pMLy/bUafvB12nw76zdOv/DNi49kW7a6jTQM
	c/i/oxtOhv5fOppcTLvlA3Uq8q3Duw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220640; a=rsa-sha256;
	cv=none;
	b=z8goDABbTn8r+WHwcto2krIZxn4kPZr4iZOk1mYBm1+lbCkKRmWaE+pa0fG0b/bUvWXDLu
	723IsMG+J+8AzZumG6tNhQMmGYNoCrM/NDHs1RESe57Wb6WKCo9O9eX04KMqM5KFM27nKU
	TfUcxEI8vAypBeko2M/ANxv5xHo2DuA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWDP316C;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90E1960130;
	Fri, 27 Feb 2026 19:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9220CC2BC86;
	Fri, 27 Feb 2026 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220639;
	bh=SAMYtAvGiq2l3siqpeP/HjyvgvsrRuVBB1mTlVx3THc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWDP316CPXO/9KAo9G7kURhF/pb29KNRJqRv8kTvTBt2Tl4DndSNbq9CE353SQqBe
	 qjj0CgyDip/VSl54DMadgZWcssiRU4eqq+zl9IJ5aio0+LdulkcBjD50ccwUmDqvls
	 5tuE+AgufRKl/SKuLK1vw/FL+3J8DK20ouR8M94LWPr84oYBt4iKjFXwb/gisHKzUP
	 OufxPIzp6dbtnLH2Arbp08gAMNCq05IhNL/dIeNnqR6bkpSyfabhojPV/NPtn/GzPH
	 3pBsaioH9QColcMTxWerbO1L95Wgvpt+XtRqx+wCGVkmBpyEodALkvLgFUtWFFbZJo
	 xdMIA3aOdDrJA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id BB486F40069;
	Fri, 27 Feb 2026 14:30:37 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 27 Feb 2026 14:30:37 -0500
X-ME-Sender: <xms:3fChaeeAYh5ldia37PihNJNfMiM9NY0qA0Fr6FK-ZcKj7-TA8f1kBg>
    <xme:3fChaYVMvAQ8t2MVlwt3813GmSgNxj1fyW1LaE_-UDDCW5HmruVRX5F3u2XjWQgRQ
    VYLfCt36np3GNaKW4s-PHLSK7w6e6spcwHyLYSWRcXtMFwAh59ZVrM>
X-ME-Received: <xmr:3fChadVwXgyK1HzO-2YHtR1f2V_003DgvaXs_pkT9CWATUUA7XMOhkFjk4z0fQ>
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
X-ME-Proxy: <xmx:3fChaQOo5msdLx59Njr8X0fwQwrTfIbPuLtbF2_65bor02BE4vH9Zg>
    <xmx:3fChaY7pBQO7Drmc07c2ajWUVo8tPYWipnWSxdK9pVloShiwuZfhGQ>
    <xmx:3fChaRr5x7tyCHNLDbtVprfiVREklkdNl6C6N75inS96bdmqPojFYw>
    <xmx:3fChaWCSXLHqExDyY9g8OsMX0joMlZuDlIHJil5VS2pczidaluTw9Q>
    <xmx:3fChaXeU_9l5z0yc_1u_8rY6NoJL6I-ZXMD9eOh4Inq4-XpMuQp6CajA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:37 -0500 (EST)
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
	"David Hildenbrand (arm)" <david@kernel.org>
Subject: [PATCHv7 04/18] mm: Move set/clear_compound_head() next to compound_head()
Date: Fri, 27 Feb 2026 19:30:05 +0000
Message-ID: <20260227193030.272078-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15E571C0007
X-Stat-Signature: 6uip8qaiu55goza853raat3q34pxbgw9
X-Rspam-User: 
X-HE-Tag: 1772220639-231929
X-HE-Meta: U2FsdGVkX18Ly6N3RpjL2CQaHDXr6+Qhf9zZ6sDGXKAKAJtdcUOecKES6P9H2HuF02m0K/vopHp08CzkrEjGnFkC7hrK9HEPQ/gzZRfkrV+1eTeChqm0HaLjLkklpProVrZQFbaUO6oTRFs/02Ld+G92VX/ZFTifvIEaOGxUhwPqTDRq/1HhZGMbG+dHi3o8MNpmddUutxkpIbIbp38StwLWI4x4F7vI3WEqFgGnCnFMRiJdnLC80GkHuhFW+Ssn078fvOJk+1Vof5C2YCXQrOTDJhg9FS9n6hpFMPJBBF8kI2Ko6Hv5GVc4X+vLXJU8eaF4GUasFN4jUDIVbhKum+5JvStHPQnSTLPi1Cv5sv8hD3ZE9M/DsrJ5OPxeMFsKs6idd6y5DbbZrlLWihMl3NTuoJOL/RHp7LyD522Igfoxc4iooqwiP5xY0zLuTjIRyxqiBjKsI1SCh8HyMFlVktp1oPMPt4dDEhdEID2oyzH09INXggIenxxskqi/il7UkG/tyN48z/sDwzYMdsqjKX9z5aShwYGJGaUOieQUmhzXAzJQ3pQEKvb04d1AkWG8D8TnBO5UAjlYDLAIydImkJf5QZv4QuUk2wooQCz4XTazYR4mx0YQzCMpQ8I7MCy9aEZY5modj8M937AJkdGzp90K6VtqabVVuU2RxvIvQVMoDZh2cus9CQhULwVCzEYIR10qQHlsesRoeKNYQKXUkcZEVdDdIpLNoBbd4iPbEgtkGnq2IVa4S60T/ASTjFFXK2aBXd9PW4Y3vl7uwT7B9UuwQIFfZeX8zdILzalRbv8n251UQVPbvsvZ33uZFQB2EQvsKMD/V8Wclepg1255fl5EIWTKUu8sZ7+m6tSMemOesICQS6UGVHs7y23cD5rrDR9m1Xm+Twebx1IwGuYgoXDzWf+Dj0YnT0RdgtVaAgQtVzmf9PsMRcLnIeBlZWKyLwluAGYhnl3cexKSADr
 yh45IHcW
 sc+JTMPcwXlNr9eUw4I3xbUwaov92q7ggKhXZ1K/Ve2EigibSVvojX0pNQuavOOHDoKZmOsyXvs81SczL+jIK/ejvcG+e/dsyivPKeGS51A5DbPv04mugq4E8pb2VBDKDUnWU9Bva8TCgTdNoWYdSKzHA4PRrfE3p1Qk/+Kblf9yN5SpLzSKLxFA88DdUdyECvURWsKK9Fx8DQFs40qvgA/MPI5xTWuVbt+nwRaVn26p8iZfjEaqCCV9mP2asfhCOSOAV+H+Pl01jL3X1IDNKMdlMEwOgMnxau1CA0vXQWf7HVL5mDNdvQknTqhe0CDvBm0ZseaJc2AHhMnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Move set_compound_head() and clear_compound_head() to be adjacent to the
compound_head() function in page-flags.h.

These functions encode and decode the same compound_info field, so
keeping them together makes it easier to verify their logic is
consistent, especially when the encoding changes.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 70c4e43f2d9a..42bf8ed02a29 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -290,6 +290,17 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *tail,
+		const struct page *head, unsigned int order)
+{
+	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
+}
+
+static __always_inline void clear_compound_head(struct page *page)
+{
+	WRITE_ONCE(page->compound_info, 0);
+}
+
 /**
  * page_folio - Converts from page to folio.
  * @p: The page.
@@ -865,17 +876,6 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *tail,
-		const struct page *head, unsigned int order)
-{
-	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
-}
-
-static __always_inline void clear_compound_head(struct page *page)
-{
-	WRITE_ONCE(page->compound_info, 0);
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void ClearPageCompound(struct page *page)
 {
-- 
2.51.2


