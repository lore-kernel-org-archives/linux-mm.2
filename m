Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB7AE7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30BC6B00FD; Mon,  2 Feb 2026 10:57:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB556B00FF; Mon,  2 Feb 2026 10:57:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B0C6B0100; Mon,  2 Feb 2026 10:57:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5946B00FD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:57:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 394E4894FF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:37 +0000 (UTC)
X-FDA: 84399971754.28.8A16D77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1AE5A10000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izIKUzYL;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5itD1SDwquwWs2ds/5ZXa9iuE390ctktQFtmzlQ5/0M=;
	b=GbMWsOZ3nnGv3QAG1oRFiJUHd/dWbTZT9diUoUFK4AKAKfMoyBjXNKyyFIKueRbNd1FIBi
	zfp/Os1TpwhGlZdLORqYZy89FGWyWlYFYHtarL6TlqBMSe7BwEUkdk1/wDZMYUaUw/zD1S
	pVjC/l4FQ1YCERAPf9qXNBTtqTXhA+k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izIKUzYL;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047855; a=rsa-sha256;
	cv=none;
	b=xtliY+Qz202bhZ1ZB78svDdpDHI9Ogqbi6RCljgJZQ5oIARA0k5K8ffe2U3+N0PMLByrxv
	JgsfS4srQgBeZaZtYkqJVyYKOOPcC0bX2lrp8wh2tKodzWWH/76O1WcwGr67MdR/JOwdGU
	IIYApNzSvf9ku7ob3Yp+MbaKGnBvAdY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 329194090F;
	Mon,  2 Feb 2026 15:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CDAC19422;
	Mon,  2 Feb 2026 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047854;
	bh=gSmvqtqPx9nfy8Fha/oZ+Wj5/HcAhp/Bj63bLn9BVgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izIKUzYLZJXR2WeI7uakNi4F82v5uaw2wWsdekl5LIQe0+3irnuxFOcYsokeANFo9
	 BPGBTFZMJSJvMo9l2pb8k1Abi7RceVpX9l47L3Z+bNiLmqU/Xye7n8Ca6JIexgKrIr
	 XRL8CXHQFDOoiGGbVKi9t6KRSFv/nBd/6Lb5PRcyy7YO/T5oP0T1ciz1HZj/sd+uZj
	 dKZjkR8DkNj8JhEKW0CcR6taomqmuLh05966fvdr1/j8OWPYUY1Q90isGr2/XR7C3R
	 F+qiKwajZNl6SI1IReH43XujW3Ap8dcdNlEqscYmvyuMCvgxdCHt8wvSk+qUbWGEi/
	 oHv4gcHyg2S9A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id CEB09F40069;
	Mon,  2 Feb 2026 10:57:32 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 02 Feb 2026 10:57:32 -0500
X-ME-Sender: <xms:bMmAaSCzcV5HuR7RJqpanDvjJDdNlFkuvC94IELMOTza9EKqNR1nFg>
    <xme:bMmAaVsOiY6uEI5blRsby8H2_uZCVHiouoW2HGLLXwZnQljYs9d30uBBB5wRKAqf2
    iQfgQpu_YvmiZinco7_EGakCrzBA9U0KBVRdYiEwDxJ-M0ZzjBwJcs>
X-ME-Received: <xmr:bMmAafu_0vbGRSJSn8kPuLq1vkF2ltv2YTvHV6V7PZrvaOec4UCCuhP6CSCQEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:bMmAaRqTvlKVGJza3f8bEETEcQLhAkukYXxBppzgmGFAd86GXAyhWA>
    <xmx:bMmAaTPoAIB0vrAQLwY5_OjpT2zjbCkRyT1kdRJZ60qw1SnxmZ_Emw>
    <xmx:bMmAaXkzUBbNOvaDtlQfdJVWpos31RDXba8S-nesVoJyPQEwkakqug>
    <xmx:bMmAaVsIVhxfdkZFBh5YITP170M0Lxfh_rPnpeQ4XzAhcu74dCyr8w>
    <xmx:bMmAaekwD2iLHzTQDSNSC9gfE4-g0rjO0kM1JEZhdAY3GGOLZBodlnru>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:57:31 -0500 (EST)
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
Subject: [PATCHv6 06/17] LoongArch/mm: Align vmemmap to maximal folio size
Date: Mon,  2 Feb 2026 15:56:22 +0000
Message-ID: <20260202155634.650837-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: t6yydxopmyi4uyq3s8wro4z58wq64woa
X-Rspamd-Queue-Id: 1AE5A10000E
X-Rspam-User: 
X-HE-Tag: 1770047854-373472
X-HE-Meta: U2FsdGVkX19tsnXE6lj0XzusOQkHWPkeNalFGrKSDB5vWPXBr6KvqCbecEo7f1ObCgJ3vZi6TcokfI+z02kGiCrlnUPMZGrmZxo/fFGdHixx0sN/WT37pB2fAPKH6JTalmANoQpVX/rc4TiGCKrmglJOl+rCRkkTSfIUMxi0VXazozZOECsKrDTNrgtAslzVpfqKcAbNJdk7a+WAkaOUblgSemR0GnyL/QWcv8AqCE6XA3qc7hjCHM4jtQdsyR4nHjcvm3OdTbbXmYgevWZnqmG6SIwN2yXhyICd3xOsyUq9oCLoUnelvakfHoWtg7kC1QHjpnzYk+EpSRl/sUSeuKvFSgmmENhtz2WEzBCsRJU0Iq52pMsXlxumsqZdEGsHB722pISsInbJ9s3gWSTnvynYlVY64f86h4mnyTlQnnUrzVNpXoXl3rBIp+5yGmdBCS36UzOXaRwLM9wPJtf4GsuD2jsawwWY97AJ14XMkgWcS4DCEJboH17xfzlwf9LVmeykmaRQCbMEKB2fbAr3N9ExWTSLyK1wTOWLbIUTrSuR7HgyHVG12uJZ42AK+6J808L3AFWRvHRUvucXNg4Owb2EaXcsSOsj9usGJ5RshS8OaLQ82ixwrWY8eZ3hHi0OcVl1nYS74yu/oYisN/ZAKTzfvH7VcjK71mons7VdlSkQsWq1bJiOWF4v4eLfoNA7a2324PSpLsItOBeSVyFBk328Dm+A5NsuAO9CXyFxCenHaXoeW1cgEB+6Yh9rCnGx1nvmW+egA6hsZ2P/yK3QB910cMfGk3LcqoHnhkiWd/Ml2wH+z/LFHJ1VBBeff+Yp+KyeuA9bBBm+G+/HFUisejGMtm9Px2VgTiaVPHD4V5jqFqVBDmqusLaWR/LtX9oZwbPHg5Oodv21xHqjSlD8b4zemW+iZyXz5L/eVKMYTomkd+96ULfiGi7APcJDorLHyA02Ld6xaHJdMPrgZQU
 495nBeii
 2eNdOY/NPXGzMldB2ZtyRvGUMTqExFr0ZIeOkXoMjMYL8B92mLb04+HlZk84qDbYYQV8bjToFo/8ZbqpIYcKrRzJ7FE9uO3SryvAj6NvK6cbLm+FUvgFTWvFOytIZzbe3cM7Dsuhfk7VlClPXLkXMIxRDmuWGPYOk1rMr9QCOlRG10is6ze2TClnN7hlKUS9jBnyRfl5T0cPlqI0qr61R7td+IJoa2hHiKQOJxEcO71ir7UQhxN+8S3grOum4lU+qvYBv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to MAX_FOLIO_NR_PAGES.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index c33b3bcb733e..f9416acb9156 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 	 min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - KFENCE_AREA_SIZE)
 #endif
 
-#define vmemmap		((struct page *)((VMALLOC_END + PMD_SIZE) & PMD_MASK))
+#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_NR_PAGES * sizeof(struct page))
+#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))
 #define VMEMMAP_END	((unsigned long)vmemmap + VMEMMAP_SIZE - 1)
 
 #define KFENCE_AREA_START	(VMEMMAP_END + 1)
-- 
2.51.2


