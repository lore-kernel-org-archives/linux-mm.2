Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B94D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73ACA6B00A0; Thu, 18 Dec 2025 10:10:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6096B00A1; Thu, 18 Dec 2025 10:10:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8546B00A2; Thu, 18 Dec 2025 10:10:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9BD6B00A0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0070512AF3
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:20 +0000 (UTC)
X-FDA: 84232927842.18.10BAD68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36794C0012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mld3UlRp;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUOkhrxmJoQAnHgmMz1K2mFOCxgqm2x72B03qMy/R8Y=;
	b=lXNBlALmZ3fnEvJCYlFML9/ilsPmM7HAmoehUhoEthItNJKNwrMmVuU0VILpCU2iC0gqkU
	OSxN7Yt0Il+uXOGkY1ZwGJo5ALl44BQdcpgbe4NIr3OzE1z8UQHZNmhQOthvruDzYwfPqA
	xcwU1/jqrtE6S3yXSMk4wY6q39keeYQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mld3UlRp;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070619; a=rsa-sha256;
	cv=none;
	b=tA2TQi1WMGvYDbZty1mHRA4Nntp51oz6VsJd6VB8p6GTV3Crgi2xjx+VmBoZV/1QzRY7O2
	NQXi9v2YSwpBeh8DLObYcTWG3yojhO/q5Nmge2F1CcrNv0ZQH+httElSnGsdEXXOZ2TeFI
	aIBwovL/xZ/Rth1U0rnqQrU6wQhhFAA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE41260147;
	Thu, 18 Dec 2025 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D44C19422;
	Thu, 18 Dec 2025 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070618;
	bh=QHkl3U8ZtD9yZJLHGmP/g7omcn3YG8UOJmM+dOgs4Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mld3UlRpXdkAqoVa4eG6+AE4I23cxtdxS765AtGm9OB9FGQx2B29yweHd1gLJGWbr
	 6JeK7T38JOzsPOnBn05+/itAVsjRwK8PScm3sc1T2i+TfQ14szvc4/Ks01IsvmnI9n
	 UiDO2d9JB3ikjOFmyrCkXhtJk093mz4BUA4BrXOzFb9mVCQJcMYkSPNC5UWrbyRNFT
	 xQ7RVeeRppOmpJ9H/++hxKozbIkYznsW4T8+KsIBbijjTJwM/0M14o7cjsDF0Rrd91
	 poKMMaNs4FzUsOe5eobB8jeT8/WlhPMjm1/iG7RtOhM1q0P59Q4DShj5+8qkYoT2HK
	 3bcDgv8G9YR8Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id E5EE8F40078;
	Thu, 18 Dec 2025 10:10:16 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 18 Dec 2025 10:10:16 -0500
X-ME-Sender: <xms:WBlEaZovwVR03RF5Acpg4wU6YPxRUfBBFEQwZgoPFERiLQdUsO49JQ>
    <xme:WBlEaa7YszlCT8p9ln7nFAYAImCh0ykL2vScArW2RKrCArQggU4E-6Zk3NN_myBk6
    z8-YsqXNUufFiEc_hggBEUk73PAff2-kJHhfKpNlW9yVghb-Sx6Ig>
X-ME-Received: <xmr:WBlEaZCKBuVfv0EvypD9qo7xwAsPXObyu6IPC5a2JYS8ZQxgWLax_rH3ujFH9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:WBlEacY22H2MkTgLzMYosUxBiThL0G3oyKQP57hHVDNFnoKCoUFdMg>
    <xmx:WBlEadJ-GTy0FsnHqqjU5zThpJ-XoMx8A_Ya79145CGZ-xZhMQfWFQ>
    <xmx:WBlEaVD6ZmBDQxSjaA6JLf6PEZZjVEOoHYw2Ox6p_DOOKLUujULGEQ>
    <xmx:WBlEaRNbkLvg1T72So11L5qZA9mQu6anoCYe32Vm4TAc5J7kIyGo6Q>
    <xmx:WBlEaSXDQFHzUkRw45qjwYR4JQe9bFJEnGQq8vnWW7oLhO79s-BXt65n>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:16 -0500 (EST)
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
Subject: [PATCHv2 13/14] mm: Remove the branch from compound_head()
Date: Thu, 18 Dec 2025 15:09:44 +0000
Message-ID: <20251218150949.721480-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: jusfznofsq19j1nyw6rkxdu6dirfi471
X-Rspam-User: 
X-Rspamd-Queue-Id: 36794C0012
X-HE-Tag: 1766070619-86373
X-HE-Meta: U2FsdGVkX18IPyzYJDKXl0+YmdwDZ3ukvDUSNd6vk0sns8mtUEm6CKpDhY2pe4XVVDre/bNtYX1O+vTrf6ZU6WFUpKKkJG2PEuRUqc0JUxq0rV+QDwtkWC2eYMc8nZz3i2YOTaj9ar5i/YGATYR3kuRoUvyHDwK7ujfcmySm7+taPgpH2CNSK9ydnwLW22I2mx69+zP/jUjruLV8xkVvv3wTI7uzy6tPcQW9d6GEgcp8+WIiA3s+noVoYEqlfiYTGx9x9AKZAYDnNVLxLI3WZ5FFNUPUs1uYsHZBD6UMWWk0v0yHchuv0QH9TNAOlh1mXc42pgdOZYoNBT8B5CRCdMAF/J+Vjijc82+oAeOlPyBKQN9RxawW4Zy+KVcaUguuGCFMOJ4hXiChEN8JoP+Tm8ZFkk3PdAnzCSUShIpw5U0j4/8kxi0yTKiLB/kOFABBgvF9MarmQbBTHAKyJAd8IA15jbc1tf189FbUhC4fj54gRMFDMSVkCTzu2Le+eL0vkWvaZnRV1mO6pfQhCPjw6c3u1CNh9G4Bua1ZPimzXvnxJIPSaUJigYe4IQk5q0WP+S2Dly7j/Ou+iMA5oTWdYphg8afT5jHEci5tio4rnqtcSKFpd0CMiuGOd2aEqehHyXPMcC8u1BqCLllpFMzzlwN/QXpyDUtdppFcBLu+NQqzNff+aHUOM09Tc/JPFzPtcd+3Gya3UYTkff8HbuFMOGdSLv7eT58uq808q3aUtvTfAEKHgntu0F6BA1tMOq+znXlKhQyQXIkFtaQcIyRuwIgpm1V+8rNDZ5YqT6DxNPcShYyEk9l/ZmyruoIrMmyo8XU6yVTaAza1bLRuFiGUkwMOwcGVsvIFQ7iWVu8XF8P0e3EjVJxaW1BDjoAvIJWTGo9FHxCslHAWBg98y9Xgz5mbmU0UrPiv+MvRCXjjx4B3765N3zLNOznG/jw6xOnUvY4BsyjPMCZhpbQkN29
 KmQMNoQS
 ZBcZfxBgS0p5kTWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compound_head() function is a hot path. For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 2255e7e6759c..6d5ebd66eda6 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -201,17 +201,15 @@ enum pageflags {
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
+
+	if (!is_power_of_2(sizeof(struct page))) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
 		return (unsigned long)page;
-
-	/*
-	 * If the size of struct page is not power-of-2, the rest of
-	 * compound_info is the pointer to the head page.
-	 */
-	if (!is_power_of_2(sizeof(struct page)))
-		return info - 1;
+	}
 
 	/*
 	 * If the size of struct page is power-of-2 the rest of the info
@@ -219,8 +217,17 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 	 * the head page.
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


