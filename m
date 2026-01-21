Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BABD46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F466B0093; Wed, 21 Jan 2026 11:23:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAEA26B0095; Wed, 21 Jan 2026 11:23:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8BF96B0096; Wed, 21 Jan 2026 11:23:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5B16B0093
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DA158C49B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:09 +0000 (UTC)
X-FDA: 84356490498.10.5E06CF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 045161C0018
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hPtXv11L;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL0+LVL/0/F3lb/k3ta1tTPmCzccC0GRXnixZB4AwtQ=;
	b=nrsYCJjX6tFDPxcvfNxGMyss+LGqNYaPVlaoG04sQ99tJIKg3GQVD00xk96h9UW3kcO4FG
	xZkSE62w+c8uULhexRkQEjL4p05WgsLwyyqGLRNI/bhDGjzy5WA+jLG912RTCPXWxoLRpx
	25iPAwTg81irgLcnZHYLo8z5QCjvXhw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hPtXv11L;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012587; a=rsa-sha256;
	cv=none;
	b=H+Ru19+SapSNL5M1kMJhnTKrxLWEIBecI+In2AWQrVAP9lJE1FVnrm/ZhJIFkTjvARJIMc
	BoaN0uXlNlSMKXW84CJixjv9ELB8kgiZhX9Brnmi3L+ehhUIKcDUsWKoHFdCnNHq19LFfr
	TCQLv6MC8vfCEAhydUC2IdkWvEwarVQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2765D443B3;
	Wed, 21 Jan 2026 16:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A191C116D0;
	Wed, 21 Jan 2026 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012586;
	bh=WUDBQAa58qP3pHbP6EnrIXpUoC+TsGSOWrtaUEZdRJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPtXv11Ln2gr48O8y5lhP2wMqXdSyJ9PLs6FQDAWv2mjYiDNnuuyaLTbk+R8OpGeR
	 3HhjJsCVkqM24M7B/uOVMMftBXp4LTaqXxmB+F8KrL1t9ZMbh1krAoHNZXtM0EiNE7
	 8Q+aJOuHOMlqexznKe7fxgpiD/NbARzvjsWZ0qjREeyXDiba3K3Ue2W4N37osnQsWD
	 T1saLYjV9sVpg9ilt9IMy9q1/0YMg798b6u5h9i8ltdBHY3ehmX39qNsV3uqOhfnVz
	 V6RIt4hxe0NAE+7KuHzwgqdAZ4SVgcSeNo+BCauRm/CZlGvqdEC4I/F9ANjOnElo8X
	 vM/sp6KF1mXAA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 575C2F4006C;
	Wed, 21 Jan 2026 11:23:04 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 21 Jan 2026 11:23:04 -0500
X-ME-Sender: <xms:aP1waWWTAax4WtGH0oovPFB9A-J9Ob76BE7jN_340rxD5MdgWyJMHA>
    <xme:aP1waR246kLwYAe6HT8rUqpnZhis-L_T0k1st6HzgLGDKB7peMUc_2XdPqx0Da--u
    ulRxSQNPqdASyEs3IixY3Y757coLmh_fkGcaz2So8vyvl1rMgrmzQ>
X-ME-Received: <xmr:aP1wadNmdVooacr0mLTi6tgxY9byPHiR-h4HZ_Y-XN8UPzRbqQb33P69-jVhBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:aP1waU0xtD8gUV_H7GUCKSHqtAFSI-XiPPnn5hWRk2MtovlW_gQtQQ>
    <xmx:aP1waU10THAa_Zm-7wyE6Nrh78Ctde0qDlA6D93zm4vFtet6D2h-gQ>
    <xmx:aP1waa8BClrSoqbW1_0pQkxUXvIVKOLPgsL9d-RYHCnL7UiT0996DA>
    <xmx:aP1waYbYLayB2ed9s8S-ASvCXlzltaNE80-pDfyxuVSwNDzWnKvPqg>
    <xmx:aP1waRx_CKPZ0dCQZtWGrfT83dcp5nYKcptuVGA8hfdW0R5S98RTJyOZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:03 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv4 04/14] mm: Move set/clear_compound_head() next to compound_head()
Date: Wed, 21 Jan 2026 16:22:41 +0000
Message-ID: <20260121162253.2216580-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hcomi813519irfxefyf36cbszy4s9qzr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 045161C0018
X-HE-Tag: 1769012586-562275
X-HE-Meta: U2FsdGVkX19pbEkH60M0EjcvsD0+n6A9/B7hvJVuLVZLj5KUJx/Uv1itez2bZ3S5cH8kNcBGARm5oUvQWPCltrBMgjHVBPR/ujMGydobrmeprbMGEfqXtFf+fTpnrXj63VUDLOo/h9uGmlXnTyF4cxg28S9WsfmKJb6NgURHh5GKQ42/ZZ5hfUmbDGEjx/A4+MhGza6DBU8LEE0PXmtvEmlplAz45TyTBymMZIy9KbD0t1M7bN/8AyDkfcPIIVmTvHRthnWRPdM0nBZ4ihis/jwRs3Vs4fLFUI4FmEaSLmWw+hq4uuHsJDcxLp56HMlVS9TuRzxRMyOWDnOd8taxRERQXB1iEIu9D6Mv9/9CrjJzlLsaNbpbe5tBPUdyqGyG/b2vIB7RAM7jxSey0WX2+Qd/UNqO1f1iJUv+TISfQYxBVxsd4UfXm2iSszquIgKr5M2NpVSz6lBfHr62olDJny8HCFvQBDtD/ztgpQeEs2nbXCyTmEBnpSnwJXRasBaU3U4vkULFHZ2/pyOWF6c6LTSNUlTLy6r9k7lqme8qrO3ztVlnIz4bcR/cc2xROg/J9h6Ge5uQ+TxkhsA0UmuLupA7eTmqyx7eDVLgOhwFfrbb1aWFtQyabmBG2YJlOJggJw9a1HH+nGZW1q3eRd+V11wQLpdl+cEPqrBFvyN+IdvgHKT+54HsKdSAmpBY9Cz4k26KYj/XrvaPRjDwBYRXCQOnm44t94ij5MqkioIDTLbhxKFVis2hGSGBTBCO0o6G17X58muQTQOvYglVaoaVrz7GwYXmgDMlQBK09Q+q1Zx3nQd/VdIkm7MO6c7Swq8chKcGTcOyAeF0QsAkZg4RqbaFgy5VkIUwYV0MoKqU9ZxhxYTsa7dye138Wm4c/VeepfYGd7aiuEcYcQmdKyEt5t1Xm9g/mBRFWtHoJ7+L+x3lzcassaKmmQ9Q+LlyVhBndz4De0dSiSkPk8Zc51L
 701779IB
 1O6BgOhzqwTBRD1q/AimuPMhZ1OKb8PszZynY6QHHt0kdu+IdQVR2r9Wcql5erOJwv8JBbVvzwaYqw0ZPaADYTujRnQ0syFQwBrx4nt4vIiyqHgziSFwcaAXlpEdTgDnE0YR3LJiGKFw6O5/ITrPr2eZxvQXNEvF6o4AKl62xmb/P8OuEjnePsnCczG+AltjipnjWui047qvbRTmvUMfb9ZvcBtt8Vek60VGBuLPDC+OeB5v6ak0kItfjF7FXh+v3RHF5XGoiWfV/F3bIDbdjuir8nqHsaXXXVOFuVwRQi7pICq3QoFWJ4vQc1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move set_compound_head() and clear_compound_head() to be adjacent to the
compound_head() function in page-flags.h.

These functions encode and decode the same compound_info field, so
keeping them together makes it easier to verify their logic is
consistent, especially when the encoding changes.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 72c933a43b6a..0de7db7efb00 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -290,6 +290,18 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *page,
+					      const struct page *head,
+					      unsigned int order)
+{
+	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
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
@@ -865,18 +877,6 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page,
-					      const struct page *head,
-					      unsigned int order)
-{
-	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
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


