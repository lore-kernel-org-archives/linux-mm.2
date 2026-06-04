Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B486CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A431E6B0092; Thu,  4 Jun 2026 15:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B3A6B0093; Thu,  4 Jun 2026 15:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9585D6B0095; Thu,  4 Jun 2026 15:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83DB16B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:59:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BB7EA01F8
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:51 +0000 (UTC)
X-FDA: 84843295782.12.BCA112C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 62D301A0009
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JPB7jQM4;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603189;
	b=oTW+is3gB+IIhSStiHwDobyJqPPGa20C33fLWF7rIVG0FyCOGao67OldBNfBVgyKF75K52
	/aMkJhqB9GGJRutJFgGTT58XwBkCuSi8J9l4wOka15rSq+zHbaUH3aWiDlYLH3aZAGUbH0
	oyk46c35P6xkdbF0EzKnhjnZFODLd7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JPB7jQM4;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmiYFIKuE1zvPsAEwECS8Z/13j8fqEOETWiRIjYfqnM=;
	b=7OuJIR1AEcUlc5marl62y0uhHJphbrBQDiI83tijzv4lTn1U0tO58uk0rvg73CPdLrOZla
	evWrNC+Qxil2hGB0p0zwV4MVmlqyBOZ0//8ARHlrLgkhqOc+mWHcV+H5Z1dK0hI1hIR8TN
	qCfBZvD8hpThj4O+W++0pb3L7D06IDE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3CA34368A;
	Thu,  4 Jun 2026 19:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3E91F00893;
	Thu,  4 Jun 2026 19:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603188;
	bh=SmiYFIKuE1zvPsAEwECS8Z/13j8fqEOETWiRIjYfqnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JPB7jQM4qJtWMPT2RpIm3aDZ+OqvI++pmnDzF8FMZBTb31pYMzeuqqRAwPEt2U/M8
	 oJKnydYcgbMlOhGRVfZEoV0I58oPOh+XPf6uMTBjDM9Eep/0dTqrdtnj68lmGASZox
	 PBX5XLmf0gL1N51R9I3dAOan6GiEkpZ++4QT/rp6O1XJsmBIswbVhxlZIoWaRneVA4
	 /VQkNhLFs1jQhfm8QOigz8afOxpQ3XRLy5aaXRNNqiIuKX9UKc1/ytGC3dlFArNUql
	 LdwpoFUyRNrClq/wrHMIXnf1s7kSW43K7mdm0+mdt1SdV+xeMClipC88ye1INxd9de
	 IvKZV6qi03OKA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:16 +0200
Subject: [PATCH v4 10/11] xarray, radix-tree: enable sheaf support for
 kmem_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-10-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
In-Reply-To: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1241; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=BhCLKxRMqF4V+mE7gy9xjhXHgxHe6HNf41/h4Z3bGDc=;
 b=kA0DAAoB+lApCKrFvdAByyZiAGoh2PKiOBQrTuWb4+c//hzTix9gM8yNN9SYEMxv0B6vxjLml
 4kCMwQAAQoAHRYhBFeK2cjZZnYmKsBqhvpQKQiqxb3QBQJqIdjyAAoJEPpQKQiqxb3Qbq0P/jVv
 ytNdtugJpYOvBMGd1/YyL95/92eWNJhenjaWD1s1c0k4gvnjG7MsQU66xf/lWXcu++IXGQOkSqx
 NU+8laAbYXgJ9wN62QfkdW8g08qC/0aduBghYfnV6wkNkH2TAeb+plHFV3GehmBmt5ah3diPeSd
 q8/UWaLDuC6dFp/gK0VpFU4Jx5nq/I18kDluysSCN2SVcm0YYMEee4taiZaClYxtYt9nmS/9fjz
 pm0KexPuArJ4IHr0LUsEX7m5k+JCUG9v5jFyWHbg97msdx4K9q7/8l/06Ru1TrMFJB31+FGgYFX
 PiQny9SX83eY87vZ2QFPBZoflNlDll8SIEVX0fD3AKwXL8IkIK7GeyvG2pGgs2Tb37siozoMGJs
 BL1TLFNii7SWJoNjTxQcrVb+hIi1ri4hAibMvDE3DCV05yVhiEGX2sQIQnFPEEAoUlH6K2ueN6b
 idJJycJ6yaueCdo5sT7p0hyuIk5m2MJprCBbkbviOogzBeBdhlc3FyovogAtHhd1eS4XMtEsg6+
 NdE5CmDY8wrOrdGdIheNX9d88Utv3GLICqXBLW5kKukdbGuLnXFDjds6oeWEJnBsPr2BfZ+Pj2c
 7f/YdnKxZaIpg5SIR+wVwdSoXlrLhifSSTWTd/QAehI+Ash+Nc0acpg3gWI/knsDdI/46xM0rPI
 0qePx
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 62D301A0009
X-Rspam-User: 
X-Stat-Signature: pnsnwn11utf31j8zg8r54hwnosikthyz
X-HE-Tag: 1780603189-506222
X-HE-Meta: U2FsdGVkX19iL0sqgDR2yCa5pwQAs+QbKM6GfezceiJTvzVoNrpdimPVqMLNwCTQ59KNb4SXOIaPYomq0eCT2gYMnD/YD3s1WqJrCQclAG23QRKnJE7vqzfjwL0IRcytfZXM4cJNA7rqzyBmkDSKlroH18vKaNZsGlxrfqdMdm9VwhLtPicmstw4h1ha+1cPx1N9U8RChwwj7Ijik2sOPhh6E2QeMYAcrRUkipUx1JNkK7EyRVxGTw+nhlMfDrjd+hygpPFXfK2QKIEs7tRMuHbtjSKWc/piojzu3a32zG9DoUqnpeowmfyngmKvpdBKyBZ11YgFPolX43Ya0kjdzF4DZGjCDra1ZSJ5Lw+NkEle2ZoZJm9u7EJRk1XsoAxleoP+/U91iUovuB7kdFSJs8qJnJHMym8X8AtDpNyuGco6lA+OwQBvkxy/uxiVq8cNIVsGxaiBOACt4KyPkEvftRSVR79EqkzM3fMiUvewe8ew8P3WvM/DKsOp8avl65uUrfKsQ4P8s/XYAGNZZCdWioRGU71CNva3c2m9JmzvHScmfu121GIxbWLGYM0V+p8TRgRIiSz+Qdy6Dg0q7pJVXc9vvDsxPPYzK865dkSz8EgCYvtKTHtZns7nV3uRpB62QH5lL2rN+vV0y2Y84bvayhAHBcvo0KouEMuJOBHF3ePbYiHfx/cjUFtPXMPRlLIhqe/dX/oLvRnMIq1H5BrK7WeFzw2oMJBlvRpk4Zy78vvamZfwPGebB+aEiIh01nSi1tIhWCftelEyvX5IR89isSMl6ewf2NBRAga5bCOwvBMpaH1VXmljg7t15Rr1IiRUjHaGSosFSn2/pp4iFB+BLRu7PU1HA2UK8qiYNdHaNXgzijHNQU3yUSCGbyNUp6iB4RtMrEkvVGTuOIdrNOacRNHdkBJ6VNRklTM9/FCR5lyDcUBtcE+9a2rL5VpDj2ifT//jdgnv0GwBC6SYyrM
 O1BC/Hi5
 tGzMtk/dyZLaFa1BcWh/97BYeZBI5n8Dd51iye/12cxFq3ugDqihNxDLAPB29DV+tx/cXIcKsy9TVp4ipPbDUYW7MeRL0Jy/TGKd6sFYNwJND/rE8vAyETkotYUErtR/44PNPAnMShsrL+FOwGRJT2AdpZhcCtS+5otoujux4D+xzknyliaQFq0GG+RbAuuAyFJMlY8eGNUFXRSM2RgvRhZnbE0dACxky1QG5H11zUU/bYJjl+egEk6+eYr3BGAdpZZwXSzUq42qsl3i3AxhRFZsqMGNy600mRlM40jNQ+7nO/bDLMRZXVPcB66bM7YTskRkT219g8+veN+eh96l7ycisx8j9ArnrYXj5JRV9Z7vbsEx5yjvQbwG3prSYjUuCwOrlgJq/08mTc4RrBCm+jygd21/sWKo1Cq7mulX7LHB2IUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The rust null block driver plans to rely on preloading xarray nodes from
the radix_tree_node_cachep kmem_cache.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 lib/radix-tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b..1cf0012b15ad 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1598,10 +1598,16 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
 	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
-	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
-			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
-			radix_tree_node_ctor);
+
+	struct kmem_cache_args args = {
+		.ctor = radix_tree_node_ctor,
+		.sheaf_capacity = 64,
+	};
+
+	radix_tree_node_cachep = kmem_cache_create(
+		"radix_tree_node", sizeof(struct radix_tree_node), &args,
+		SLAB_PANIC | SLAB_RECLAIM_ACCOUNT);
+
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);
 	WARN_ON(ret < 0);

-- 
2.51.2



