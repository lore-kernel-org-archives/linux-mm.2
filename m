Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20574C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA25E6B009E; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8FE6B00A1; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E23B6B009E; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 778636B009F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD9C98C4B8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:25 +0000 (UTC)
X-FDA: 84356491170.19.C4AEDA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB0D8120004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c4or+hyY;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7Jq4YIpdt1t+O3UnlAEkthiJsOtJ47UesU9//6KWkg=;
	b=W80+pdM2OoewW30h03kRwueuexQZ3dkpBLvmtT4UeugHd38kA3PPaPaa4RN3AdBjpnpDIY
	HfKMpZ/KVebZ9Lx1z7N/qjwzUheaE16knzH4KjdEprhM5J2GhMyacIzbRlmQ+CnPId5t0N
	xzFTlz+bDfnXvbrxvqGyIlYOtMal20o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c4or+hyY;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012603; a=rsa-sha256;
	cv=none;
	b=bincKGYCgVwpPhdXQyZAM5awRdROOdtyexmUF5TWsebEveb0PhgzXdd1BQKGz74fr5KNnD
	1wyUXLko2pf6wa6gst9VAnXdXm4L7/mcL94kS2Eg9Mao5jfHyqGgsIlLH9umP5zLZQ5+D1
	ZuLJigT7esnTflVTb1GyuKcJSrq43bY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E914242B7A;
	Wed, 21 Jan 2026 16:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C89AC4AF0B;
	Wed, 21 Jan 2026 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012602;
	bh=Klj25gx2B3J9LEGi0f2xvOyO5QXLttcNMWwuJZL6i1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4or+hyYZwgggBjlmsQfsOEwpfVrAhFoaURagWippT3LTwRQfsgolU6QLe15YKFPH
	 dt606LJvXMYGR6SRKnHwCyCCHg3eMGA4SlXxJ1LIzEJ8VVt+P90XIUewosB+iVAK44
	 3rRNjeJNE8AAx2l25/7N2WFlHh6tWLV78TGpoAtL9TYqzCVOTN4H+3QIW/BOFW3kRl
	 KPgARxzC8HjWGKS81ZGqv3mKb6ZdMF+SEtivRjW+ohXHIyqt4LMj+3qyHVhnWGS70/
	 q8l/lZAiRNms4be0kYqtM/IkInmTgCBavqfvhKkXPTdMxO26QwGjSglsFVJ7Hps0KJ
	 kwVXABhSzHFBQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7DC52F4006B;
	Wed, 21 Jan 2026 11:23:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 21 Jan 2026 11:23:21 -0500
X-ME-Sender: <xms:ef1waWywUwMrwcJw_acXDRQ9p1tv5GY2jX7IKpDK6RNj-EXrNZtG2Q>
    <xme:ef1waRheaQtteJH8dU6fMFMFnNSyQDc3jxlUSlZWmApgV7GPVf30dUjmF2ZKlTyuL
    MPIUVU5Bjd5i--vKQmB2oiimmfxR6YGysQhFBUnN18mLZX7hgfj-g>
X-ME-Received: <xmr:ef1wabKU5S5lY5-tYsTHJOA6IDa16IBgKgVmFNwt_oj7vxKvgWsiXRb0EI0R4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:ef1waUATQii2HzrSIyNx6up6fhBwy7JM7LTLGXSG1xGTs4hm7CUPLg>
    <xmx:ef1wacT6ufM5U6UvnIqTbbLGVIig_VvakYa6FnXUKP6BRWqKgAgfWA>
    <xmx:ef1waVosL96L5EbLFvmmQZGOL-mmn__DPT64BZ1F1cchOiUKxi3Qxg>
    <xmx:ef1waVWl-vMe73t2mSTOpEn_g_MfrhCMUcFXxAEClgipMocoXIj0Nw>
    <xmx:ef1waT-tEYYGVdnAa8R1vL5Q1SaSPesAFU6z22snZQ9XCdiLLAvUt0lU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:20 -0500 (EST)
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
Subject: [PATCHv4 12/14] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Wed, 21 Jan 2026 16:22:49 +0000
Message-ID: <20260121162253.2216580-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB0D8120004
X-Stat-Signature: fm9r8ap1g3hxjx3parqeoagkd8izbj1w
X-Rspam-User: 
X-HE-Tag: 1769012603-583667
X-HE-Meta: U2FsdGVkX1+30/2yPRKbaSO/9FYNQzvpHL0pSkELRnFGtgvBkEMeSKmHNyyVfNYhsu3D0A7MZpv/W+vYOQv07AX3UP4xZpv3Eme0JQuoZ8ehagpAO8iB0q9mY59aO2P4fczTfFUAe2xzXvZs0CPtPEaDaPxhRRbCIjXneAdhQS/idtkbw9XPw+7HG0fVANDtgS/JPw2asrWjli28sIgxrfwfaR/FUUoNVGsKTOCMMBeBys6uE9f1HVLOIBc7hjXw+/8UVCCXEibVIouU79KS5ctC3ciWYBwtThWYnpOhAhefVkm/PD9FTkNmAra/vLmefYmfISnY7oakY9DtSDtFgLq7KvHTdGO8pxVojp8S9G9vHWaOyrAQgtm5A1rBH6siaevKrbMr16patHlR6/KTnYNRtipxuaQXrCILQ+r5vp+ths8ZcV9rwIF/EAwTzmObMFRXYyi3XTkF8EIYUqeKrQw8JLR+Wl1+5B3g9nbxRtC140bHxfmwpRUWe3Sioz26qIcxLgRORxfcjtJ5lT0oPyEsS5MOcHmI14qF9dj+EjYEXoR0MabyMk+l1joSYmrWRNaaByC7chsZ5sFmOrK9F+NpOucqx1DacH+oeNfIHnW0/U4u/skoASGgn3rAu/6LGmPHCYZozzcPcaZogvC9yqaTpLUmKx9OogJEHlLN2p+A2+yetpiGpnHToRlX+LFw0tQbuegUhjc4oiuD2cPLoQq5LGWj5Ej/gOCEIXFJoRhAuW+1xRHaynSzw10wtTfnTtG0Yjw40YRh+V06B9teaNDi7LXnd0YSIi0dUzyhM6Hg+CdEmeaQgfclfEPC7o4hWqZsKXzUd6PYwxwTDNg34jKwO5TqcsHbV+3sesnomz62SBRRn8Vc0RCIH+RpgNSqDbqUFxefBRpc14+uJmSlBEneVbNbjlN/op26G9zHuwdApWAnSVKp0FPuhLTH03GMTzB8Wzo2V2CmC7wb6Ud
 lOUHWTnx
 jFz6Jxvni/CEGI80kDxI8EYvV8KWQ5C/kG04Oe358kJ0AY0D5AZAtbJPpJzR2DQlbqlzUr2XmtvhjH7EKUb4Eu7bp5WgCCQB5gXHHvC0hlLAsjNKtSvu7acoeZqyYwlcbnVLsg/pikhndNSxQnCDZNc39Y5/7sBu6J+8cXq2jS3T/yLrTMP/qD7ylqjjlntQSMXguCDP1md2gI+FwK+J1obJo3UU2qW3J27ric15v/qKRXmFu1NhETlWb2j/roG3HHlSZSyd6QVYg9fZU219OrVzZyyYitWGK5BvHmFrTyGFX4bYlaKU1sicZ/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb_optimize_vmemmap_key static key was used to guard fake head
detection in compound_head() and related functions. It allowed skipping
the fake head checks entirely when HVO was not in use.

With fake heads eliminated and the detection code removed, the static
key serves no purpose. Remove its definition and all increment/decrement
calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h |  2 --
 mm/hugetlb_vmemmap.c       | 14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 660f9154a211..f89702e101e8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -221,8 +221,6 @@ static __always_inline bool compound_info_has_mask(void)
 	return is_power_of_2(sizeof(struct page));
 }
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index f2a3340c8e22..379a130cf1d7 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -386,9 +386,6 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -419,10 +416,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
-	if (!ret) {
+	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	}
 
 	return ret;
 }
@@ -554,8 +549,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -592,10 +585,8 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret) {
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-	}
 
 	return ret;
 }
@@ -661,7 +652,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


