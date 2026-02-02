Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D339E7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B4B6B010F; Mon,  2 Feb 2026 10:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5926B0111; Mon,  2 Feb 2026 10:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1BF6B0112; Mon,  2 Feb 2026 10:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B09C6B010F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EB2F1B0821
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:49 +0000 (UTC)
X-FDA: 84399974778.27.55D1A31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id F104D1C0012
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLpVBg1L;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVwuFng2nZHrYqkmebOjdjYfKKmOgHaN5oXs2k81MRY=;
	b=4EWgnmMrJLhTrYtWS5YVYIlD2awKLMenjf/aMKFBYbW2rlNHUS1XY+XHqdh3lvsNjpztqy
	2h4GNQY7JT40YP1KIYxu1kT4D/rpiXN+84PbdOVU0H9QSGgGNiZtMCuiZp+IZd3Z1tJwUZ
	1dP1g5aNyxVe6gtHhmxm0rxKg/4+9RQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLpVBg1L;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047927; a=rsa-sha256;
	cv=none;
	b=uzV8m+Sjszf6ZRMVDY4rtaadDiIMColaXpMyB/fUZEb6aqqYfyBU6oC/gfFO2rSNzJGlyN
	CF0ahbk+cwqcHYcPS1HwDTOqltrFJ3VuKSt12qlmK0kvw6ipb9dFPch7nyoED5wPZxdZHP
	rk6oIqhBMZL/AWYZUf9K4MIgDegQsVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C286441DB;
	Mon,  2 Feb 2026 15:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB3AC2BC86;
	Mon,  2 Feb 2026 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047926;
	bh=hHQLWMhahxCY/meKke54BXwjoj9QXEZAW+ce8KhMydU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLpVBg1LZNKswwsnWQ3UZCODEH36kG7z6vpM+HA3uwJpty7LFXOuhG/bBlxA+qWjq
	 OJ9gk7An4n/muz+UpHVrUUz6Vshc/hmar5VtMNZ92Ypg7741E3DPeVE6ehWjEwiN+o
	 FgKDepxGEwDy2L9aUQQ+TDTdFC2uCNtuEXCyGv9TT8oCjZQcDD1bBub6HWvihJfpdg
	 3+BJsc6oBHIVdppqHz2QP42lMFE1eBXLiXD1FbvHq9ctFC3Y5E6A0jPXTY/RQpnJ9T
	 ExCYq22XT4i2B/oZnBhBEbFwBgwJSgDhLjSKY4DSH17hWYExpfvhJ/ML9LHQ9/MzLo
	 OQ7FbT18qQKzw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66437F40069;
	Mon,  2 Feb 2026 10:58:44 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 02 Feb 2026 10:58:44 -0500
X-ME-Sender: <xms:tMmAaT6K18Wvd0HKkaGoE4t1MKUHqKOWniKK8Slh0t0mZVSEigY1Ig>
    <xme:tMmAaSGa0mdtPyBuNth8XS5WbywiUOE954wqqOjbFveO6Fvoi-08_rQSoxGYwJk5m
    vKnhF9tlwM6cJ2z845M71_O3s263TMrXnhJeSLceZxT7LlvFqK04mB5>
X-ME-Received: <xmr:tMmAaUknPx1N-S0kFLlVg1ElOKs4Zx8dgAQ7u5mGO9mT7KqaIEdJD84TMHSW6Q>
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
X-ME-Proxy: <xmx:tMmAaVCjnvOi37sjHrH5c2YoK5qniyc88D6-zATSoj-K260C6NAz1A>
    <xmx:tMmAaTFTwBN4w2sY2x9XHsmuLbNm77XhH562heWrOazwBYQNMv7o5w>
    <xmx:tMmAaZ_1GN-puOj1MakR2gQ_GcZ8roej8ffqPxtHQcjAswIwy94giw>
    <xmx:tMmAaYnWRueQ_UyYgaOP70c45ePncAFrZZlTzvg6i4J6oDGNdMrunA>
    <xmx:tMmAaX9OPCBnH-pK8V3B8suUm7HtyXnXY7qSHuhx3EvW4oizJzdXFCOm>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:42 -0500 (EST)
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
Subject: [PATCHv6 15/17] mm: Remove the branch from compound_head()
Date: Mon,  2 Feb 2026 15:56:31 +0000
Message-ID: <20260202155634.650837-16-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F104D1C0012
X-Stat-Signature: g8wqj796ytox8r8bkmoqor3n5p6z8gid
X-Rspam-User: 
X-HE-Tag: 1770047926-424440
X-HE-Meta: U2FsdGVkX1+Ta9VyralmHgYctchkwr5sUtPbXzrYQSX0hW7MkCJvGEfZLkeJTxlbfpipuY0A4f6qV/4n3WOoBVxJxK9vmZ8A5YqSvT1ITuNP2cwjz+MYtPKkAuWpUm11FxvdaedbdMzJesqV/PwiSIOP9ScUkv87bRvV4abC6ocA4FsI3fXe1Icjs8tVsVnUzFUThr4e5atSyjSS+u1xArlFyaUS++SuMKKFBqcA+LffxNd8ydFyHOas0oyYa+XWAeZCecp97hzMebv05GrYwlcY1cXs4XR8ZjHUc0mLyLfVEDxiEzU8X4W2QEfOKh4bIlOocNBbl0zBhHFW1Mc4H1FcsyeYmC9+Qx8kZzIHhyO9R7loToXKRWxsT62Ht18h1NJArkQSBArSNPqjbRLHkozNLJ4DiPLvKgFkDOCVmOM57lNQMGGg/XEzLAbOTb2JVHX6OWibsh0pRkazHt5TwB7SfdqyrvuqXs4HqYLCfxasc968cmTj4PONyz/TchoU3+ZGwgZKykchkJQjAkrNyLqQh1YUHKYcqQ0DvC1NJiLRbq0nyf1/U21vr5n5B7VEt111siTEQsdEcVj1aNj64T70Ef/XwqSlJ02saLXWOF0RNeYQYZE9QSKWnVD7gE/ZRrYqch/VExiVllPQg1emcb6jvvYGh6dkh7glt6pREpjySqF3w9KUqsZg/+lEw+PH48Qrswzl6tnDGsLX6JxytixuXzxRk7Rog439Fo7gIZCAGtmY8iRDZW//NmtQyt8HCh4l+9zHIxCwznzlJR345Z+l+g3N/HtZlISjd/pbp2s3k7ySjtPs/Qz08Whb4vOq6SGeUOWTPD5HzZN/d4JzRdR9j60BrlRgK/I0NPK/RfeR5QtERUJG4mzQz88j7BeEvQSPV72ujwqfkxiOO4xpVnivIslfKw9FxJ+Vi3D5G5oeubr0F1ehOaUcUM1LRzb10a0YJFMqk2Lz0AGxM1G
 9Tzth8lF
 SWzF8mnptrYfHlflepzpHRzi0t5iwKpYKX7cxa6WUDThMdCZ/1Okph/Lu24/BtuBIQWXZKkp1q/5/Wqq/uqVlbHTtvYK2Sm8zWehv3RIbex/Ht8Yk3+MGKvqS3oXVWvspEKex/emYrOf22DtktrbysatpIak7V849wbL/gKyEQ5b0RX3Vcra5tb0jLdIvc1uLt5V27ldfBLE5d5GUonqYN3hW7rsTdp+c65frionyPgEe0KksnfKJJdUbqgH1O0h7UWlcwZlJOZP3v0IfxqRtt8572eXadlFsWBW57Tf45gyS8pxo0S3A3MhIsvrX88pp2M/vgjDXXejzQB0=
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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 1aaa604f4b9b..16384cb6f962 100644
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
 	 * If compoun_info_has_mask() is true the rest of the info encodes
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


