Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CD4D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B2F6B00A2; Thu, 15 Jan 2026 04:21:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DE56B00A4; Thu, 15 Jan 2026 04:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BBF6B00A5; Thu, 15 Jan 2026 04:21:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 044516B00A2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C754457AA3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:28 +0000 (UTC)
X-FDA: 84333655056.14.2CB0C4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F3E2C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rNcPPF+w;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468887; a=rsa-sha256;
	cv=none;
	b=a61WI6RWCs3ivqkJwwNCnShzG8Rqtdc3s8wvtBKsivkrS71OYKKbH0RYUBe5AhmGNDihrA
	axP5xa2xXM9jJaboQeymB1dSmfpmSnJQ9jXKFH2ByA2Mr47e9hY5HQT3lDWRwILP0ZZQFK
	FOaeE1991kb63jOFLsC9PF/KHcAg+2I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rNcPPF+w;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1pQu0oIDX1FMSmN8mEQcr/88w1AsOZnaAzg3v1Ad1A=;
	b=vn+82wn0sU+5XNg0ojOlMg+gtVK/BOQy1QHfFMh5E7YZ1BFgmsOTNzbqJdeBsSf3bRGNJw
	FKboYH1T6r6zfBySgpddCogfErcSFT/3jzeYtxDTRZQjSSJFKj+aekPMSF9jSksgakKROf
	MWlIgZXlKCCPECxMdRjx66ULdXGtB0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79A4741705;
	Thu, 15 Jan 2026 09:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27829C116D0;
	Thu, 15 Jan 2026 09:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468886;
	bh=41/pQYkps40P9BcPiu0aWSmWbv563rsgLU3lmcgFkvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNcPPF+w00AAr53scL8jR18Q7fOodmmK2UlCZZsCOPQEG5dye1hFhrFWKaWMBcJsq
	 HcvZireBCalmRO4S4nV/b3swFSKslwc+AyIpYszWZNzpBRDkKLrIM7Qe2hzywmeN9O
	 Sswm7p6jhDQufIH2rpGOhnmmofd9rfW1tFqNoe9bTTmC+sA18UEjJXkGartnfR4SZU
	 slgCMrFZ6F6p3/cLrbx6GaFoyd8wTmKak9rlPOTC5e8cYpYOALbBCDc2HP+SehECP7
	 EhSNzizFDkYAsy4RMNk/vLZyhmWm1w38i52nIJqG3Dm1ajv8iW2pK80Bt91m1Dc8It
	 l+bdhGCDichyw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 09/23] mm/balloon_compaction: make balloon_mops static
Date: Thu, 15 Jan 2026 10:19:59 +0100
Message-ID: <20260115092015.3928975-10-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F3E2C0008
X-Stat-Signature: fs6nuzt8nz4rbhq5yyn6emg39bhz1dci
X-Rspam-User: 
X-HE-Tag: 1768468887-192862
X-HE-Meta: U2FsdGVkX1/AzmzOrGWvWi1x8X+hNGXN1zeqiHprDz4M1aXhaVZuwE6qEUK/BLz0tinuhfFaSqIYCAWJTyaHxlIkiz3IRw4FEPW9i0s6AmmtIowjlwtoNIB9rd7Lxqac/8HQKtrlb/67283+jRxAWqDp8TNVZ1IkRDl1pZJyGU1cJO27fbEfO5JM3gp9LCnGIc+LQVunQ5p05F2B3b71T5IXqiXGWQLhvg1Q1Has0nnhFcSWudUYs/+Eh8LB7eXD42lIQ8lg9jxCakobyMfQklOEAU+BVtnxobCMjmk4xoK4pu9Y3t8QO99tRhf/xQ6Q44gXqlEdHMGtD+5qHD6mbipxuaJrkmfHgJq8cfHI2quiIGUv27G3YuczbciuFynJV/ThlmlHVielJEkEra+N2fYBnBwigz3InSweQfIoD9G1D0i5T1sX2qTuOixzZnqwvkCuNEbp7WXBSigZ4xG6OXWjZCJFgyhXBV4PL5FptoqGSwwj3HrWzM3ArzErSycZL+Mm0hCIAWUlwUL2UK04F1xOFMxB80sWkJejDwpGfdO9NPNetr471IAj3wNix76ggw+uDWQeuZ+MCugSxnJy9fYbPegp8lagbyv/1nS+szSLby0HCoeHvsPWTGeybz8xEXr3EncdwVjtj5AX/fpZ988EMpCAilzcWXR4ao8TLJOroGKU51tLtZLfgoMR7tDDSKrgddJHQTsGpj9V0HlvM2jjHhjnKlpSsgNmFOq+pDb7grKTadccZBtFZznp3o12AohKxFFnxfh4KY1Lrhr9b31hvYmxCz3LVXZbuqdUimLj//EbodUHHwkxnEmX2E+JrgzwjMU3H5TGdoesEZYOYRdoaZGRg5qcawpWisMen9zLvCVlZbIxDxcBn1CeW7XNesA8xnWyfD7bc99t05vTb+F5AFSignaox60Yt2nfZfx0+uINH8RU284QHChSmG24U4ww6NyN1LYL6JiSEy1
 +UPPUFyT
 HLtjLF01oLmTct0zjeQHa3gzH90lG4tY1w4SlGy9ohUeWxqD0sQW3tVibI+9vY5NxtqqRjPBcKy7oyUXKMOJPwog3Iphf6UAyldvjmwE0OiifEs/GEUTNMPMk+BKKXdC/TjWkyUkdeSYtENFZ5UM4VF1Y96YxjDs27/l0hr6IfjDrOj6o2WTit5f92UNKzwcvj2EECXfZw0rWspwdMAAX5rtdicSx8cCwApmIDE8JwPltzu9Ykd/uFe7A4hxQH1A0W8o9Le6IaofaNY7bV2tvp1/w2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need to expose this anymore, so let's just make it static.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 1 -
 mm/balloon_compaction.c            | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index ad594af6ed100..7db66c2c86cdc 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -78,7 +78,6 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
-extern const struct movable_operations balloon_mops;
 /*
  * balloon_page_device - get the b_dev_info descriptor for the balloon device
  *			 that enqueues the given page.
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 28ef0cb6b3bbc..c44e0b62203cc 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -286,7 +286,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	return 0;
 }
 
-const struct movable_operations balloon_mops = {
+static const struct movable_operations balloon_mops = {
 	.migrate_page = balloon_page_migrate,
 	.isolate_page = balloon_page_isolate,
 	.putback_page = balloon_page_putback,
-- 
2.52.0


