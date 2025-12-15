Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA06ED41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 07:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6DE6B000A; Mon, 15 Dec 2025 02:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587D76B000C; Mon, 15 Dec 2025 02:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44FF96B000D; Mon, 15 Dec 2025 02:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 318516B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:10:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3A01BE538
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:10:48 +0000 (UTC)
X-FDA: 84220832976.01.1F40398
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id CA6BCC0004
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:10:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765782647; a=rsa-sha256;
	cv=none;
	b=oMlEOswkdxYZcyeu0aV6CJ1WqQ6O0nIAXsUr8CAuBQEZrzYKA1NKST8BSwr3pgvn1z+Yy3
	KhB1eOmq7sRjM4XsHk79138aUJ/mLMDbztI6ZEV09cihSjlcnvdICbtd8n43eRFMtTuZy5
	4X6GUDF9rlzmFr5XV1dscpTXw+gGVv8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765782647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=qJnLoOdWA5W0i+DumM47axkaIzm3dkD3Z2w9f2KLHyA=;
	b=gGPlv99j/QUQHXJ/8AOvJrrekODgZA2YY2qUGFndbhY0oligD/0TfaEEJsYI2pNWikNjtG
	4/Z4v2FSo1ruh/zdhkO4iZR2WLLrhdUxDr6K5xZ9COXLIqqrcBuAbzvDCIjladco+nEjDM
	AX0dXR6hXawHJiSh+knL03lCPZXE2R8=
X-AuditID: a67dfc5b-c45ff70000001609-60-693fb470c4fe
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [PATCH 2/2] mm, netmem: remove the page pool members in struct page
Date: Mon, 15 Dec 2025 16:10:01 +0900
Message-Id: <20251215071001.78263-3-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251215071001.78263-1-byungchul@sk.com>
References: <20251215071001.78263-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSf0yMcRzHfZ/nued5Om6enfBgw25oGuXHsY/NzyFfVluGf8rG0TP30K/d
	VUpjl7J+cEmJXLVdKP0iu9IvpVypw0YLOcOVKzWkiNKVX9fRf6993u/3668PS8oTJHNZMTRC
	0ISqghW0lJJ+nnZ1eXjFJnFF131vyCkrpaFkNBpudFVLwFHaR0BOcSWC747XDPypb0HwrbmV
	hk9NQwiu5Y2QkPM0gYLhsjESamr7EHzMuknD+xY7AyUmP+gs6KWgLrGKBPt5Cw36hHES6h0D
	DJyuLnSKy3UMtFWmSuDiWD4JVbouBp7V5tBgK/0jgV6znoKHhiIKvmQ2k9CZuhlajLNg5HE/
	guayKgJGzuXS8OJKLQF36l8wkNFupKE7oRNBe5OdgsyfSTRkx6UiGB91KgfSvksg+4GN2eyF
	46xWGjf1D5K4ougVgTuyLlDYeu8RgWsMbxlsNEXi8kJPnGJtJ7GpOJnGpqF0Br/pqKOxJWuc
	wjXv1uGa6m8E1scP0P4zA6Trg4RgMUrQeG88KFXrLYHhX6dHX09uJXQoRZaC3FieU/J6SyYx
	ybavPeQE05wHb7U6XOzO+fG3Kp+jFCRlSW6A4esaftATwQzOly9yDLtKFLeYv9OZ5hLJuDV8
	S+PZ/9IFfMntRlfHjVvLX3t7CU2w3NlJ/3DZJeW5RpZ//HQQ/RvM4e8XWqk0JDOiKcVILoZG
	hajEYKWXOiZUjPY6HBZiQs7fKDj5M7AaDbXtMSOORYppsraKjaJcoorSxoSYEc+SCndZktV5
	kgWpYk4ImrADmshgQWtG81hKMVu2auR4kJw7oooQjglCuKCZTAnWba4OndyxfOHqjNK4L6JH
	Ul7Yr9it5T6DG3arGUProe2taE6vJTkAHg2bdvmX7Kyw4Z7IGe2ORI/i37xO5Mz2qUuM3Q+K
	EjdpZFqDURHrVxvgFq+0+Xsr+5RH7fN3+eQSS/cH7j71spBce2ZR3r6GZZot+fufxO+9q/ZN
	7vIM2+b3vkxBadWqlZ6kRqv6C7PmDPEXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTcRiH+59zds4cjo5L9GRhNIvATLtovGGUUtKf6PaljC7kyEMbXtlM
	NLC0DC+1ZV7KdMaksua15t1mhTNvBYWlnEqdWdl9lZo5tWwafXt4fw/Pl1dMyoYpD7EqOo5X
	Rysi5bSEkuwKPLMqtmazanXB2cWgryqnoWwiAW4ONojAXv6eAH1pHYIx+ysGZprbEIy2ttPw
	2TKC4FrxOAn6J6kU/KyaJKGx6T2CT/kVNLxrG2KgzLQTrCXDFJjT6kkYutBBgzZ1ioRmu42B
	0w23HOHqZAYsRZ0ieFqnE0Hu5A0S6pMHGXjWpKdhoHxGBMMtWgo6C4wUfM9rJcGqC4I2gxuM
	P/qCoLWqnoDx80U09FxpIqC2uYeBnG4DDW9SrQi6LUMU5E2n01CYokMwNeFI2rLGRFD4cIAJ
	8sMpgkBjy5dvJK4xviBwb/5FCgv3ugjcWNDPYIPpOK6+5Y0zhW4Sm0ozaGwayWZwX6+Zxh35
	UxRufL0BNzaMElh7xkbvcTsg2RjOR6riebXfpjCJUttxMPbH/ITrGe1EMsqUZiInMcf6cwM/
	3pKzTLMrOEGwz7Eru5OrrHuOMpFETLI2hjPf/0XPDgvYHZzR/nNOotjlXK01i5hlKRvAtT04
	R/yLLuHKbj+Yc5zY9dy1/ktolmUOJ/vjZZSFJAY0rxS5qqLjoxSqyABfTYQyMVqV4Hs0JsqE
	HN8vSZq+2IDGnm1rQawYyZ2lwt1NKplIEa9JjGpBnJiUu0rTBcdJGq5IPMGrY46oj0fymha0
	SEzJ3aXbQ/kwGXtMEcdH8Hwsr/6/EmInj2SEf3cewoF2l3B3yphbsndC1hqS/XVZ1+N04mtQ
	O0EGp9j9mGHPkPaRrZK+e0Ej1pt3Fn446+W12axweTm4v8QWuuXg0uCcNOXtCu2+w8Y/b3WV
	XtosF2cf/y2CxMNnRcLulevWKh9dTYn3jDAzzhZ78cnthZPSiVO6K/onSVGUQU5plIo13qRa
	o/gLKI2TbfkCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CA6BCC0004
X-Stat-Signature: 6dxoi1nh8ch4oe6f53ufiyypcek14bu6
X-Rspam-User: 
X-HE-Tag: 1765782646-852937
X-HE-Meta: U2FsdGVkX1/uSD3huD+raaD4hr5UjOYbKym35zMhLcjY3R24haHM3IVwNCtEnMe8rXVUzWQdaXWvXerpo34MrpamBnRZ2kLCULo0URyowhpAtRhjIKetx29jQiA9XjmV+X65d5xt+3A/6/kQ4cqmF8JZ61wsHxZ9iwexBeP8dQ/zBlR046ppvYO8z3Crd+XS/kKOwzVN9WcpSyF6APgww9r102A+jJvmje8cKNVnlxuhkGHhWBMn7+d8ZXo1Sw3v7kbcmtrfQfhfP4eZ8DMFgmhQ1w2aX2SZP+J94UDcG+SP+l8q12Pz++2cVZTNy2LUu91guLmZfz0AEPEvLA8nil5bAVxwcCODJv03FQ6U3p8zBCG9oORUDpj0/EHuOWEm7ArsEv0hsWjy/NwMUh0rDTRrkQl5WMNVBaogeAaDiAJmyVfjWTOKVN7pV4zDz7JgqXDwhWHCf+KxPVY5YgmBHNMFoCMeGA0PjuBCk2lYNf8pvlyB3Yxa6uzNId5Yob4mcEe4qabdJQPbjYm5bHqKSj9dNcvpnpWHyfmPA+U93VByBJFctIxdGqlEYBzzphmBKOwMSGYJXOLZbDJ1kN2vofXsYqUs30fEzCThAch0sXlk/RGENUTznrb3MyXRihnK4aP9Qvm9gjgirdFOzDcdeiGz4A+G1wkJ41QAxtCgudQPRY1vJW8aK0ilap+nMsU1XEueamDjiIPIX6UFhni7AtH8X083g//AYo7Rw64q+eb394wU+BliyIhxx1/Evmt/Qs2Yndc9qsvMjv8AVoMyOl8TwAa1+EUj0j6Ety/DutJ/cYFkvo43Nf0dYiAE7awmgOIsfvkOCwRyqB/uXK0Y0Gu7oVbdFNzKr9J4WhkcSUMiUWpd+4/akzXBWe9W3u/jy6P0khtrA+EYl7GAVaG4OdN3Rp7DmSRF9r+epemv+wAde8/qSvF06ePu3hyy7SdHcjKnaH1PPTxI9O+X+3H
 Nr15m7i0
 iH64eu+IlZZgBvZATs0W2po1e7H0mb6SvXRexR1+oZYPnNaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the users of the page pool members in struct page have been
gone, the members can be removed from struct page.

However, since both struct netmem_desc and struct page still share the
same space, the important offsets should be checked properly, until
struct netmem_desc has its own instance from slab.

Remove the page pool members in struct page and adjust static checkers
for the offsets.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/mm_types.h | 11 -----------
 include/net/netmem.h     |  7 ++-----
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9f6de068295d3..46d3c4b52cc10 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -114,17 +114,6 @@ struct page {
 			 */
 			unsigned long private;
 		};
-		struct {	/* page_pool used by netstack */
-			/**
-			 * @pp_magic: magic value to avoid recycling non
-			 * page_pool allocated pages.
-			 */
-			unsigned long pp_magic;
-			struct page_pool *pp;
-			unsigned long _pp_mapping_pad;
-			unsigned long dma_addr;
-			atomic_long_t pp_ref_count;
-		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
 		};
diff --git a/include/net/netmem.h b/include/net/netmem.h
index 2a73b68f16b15..01d689de11511 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -42,11 +42,8 @@ struct netmem_desc {
 	static_assert(offsetof(struct page, pg) == \
 		      offsetof(struct netmem_desc, desc))
 NETMEM_DESC_ASSERT_OFFSET(flags, _flags);
-NETMEM_DESC_ASSERT_OFFSET(pp_magic, pp_magic);
-NETMEM_DESC_ASSERT_OFFSET(pp, pp);
-NETMEM_DESC_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
-NETMEM_DESC_ASSERT_OFFSET(dma_addr, dma_addr);
-NETMEM_DESC_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
+NETMEM_DESC_ASSERT_OFFSET(lru, pp_magic);
+NETMEM_DESC_ASSERT_OFFSET(mapping, _pp_mapping_pad);
 #undef NETMEM_DESC_ASSERT_OFFSET
 
 /*
-- 
2.17.1


