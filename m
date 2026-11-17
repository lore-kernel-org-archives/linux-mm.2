Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91204606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DKVy9BgQ
Received: by kanga.kvack.org (Postfix)
	id B6AAA6B05B6; Tue, 17 Nov 2026 07:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8FF6B05B7; Tue, 17 Nov 2026 07:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB316B05B8; Tue, 17 Nov 2026 07:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52E026B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA217120404
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:20 +0000 (UTC)
X-FDA: 85444485840.02.0CBA821
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 407F040008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DKVy9BgQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2oAxC901LsFPrZY7XEv49QJustbmbWIIv6Ichi+IBM=;
	b=ASOF9LJiiDWfeEojzI9gX0yqLTKOEESaybTBmwwwYWFKVgZHf9TpZXHZASq/m6dkcBCTVf
	PobwAGetCcCUFMwckKzg1QdIQu5RX1FTJtOhR5eKfqLIlHaJH/MramJalz5MXhRBY6hSmk
	dFo5AjD8xb5dF8+q5Ju33hqYFnDYUsM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DKVy9BgQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917239;
	b=3q6bjbG5DoH+87VE7Px/bGxu/sZ+3QyWUW32kZBqSzk7bEvI5rXdbG6aGYdK9oLqQET2+H
	zCXNFFaMtGq/xVtioDPHbpuMSTCuXaTcE8lE+ekbWTKas1Nbbi5o8GDhg/c+b9O4xEokLr
	UYBLRPkIJllkdKKpC8gO1zdj1NwbR2c=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-170135e43c7so7234025c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917237; x=1795522037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C2oAxC901LsFPrZY7XEv49QJustbmbWIIv6Ichi+IBM=;
        b=DKVy9BgQfczRafTXVM7eQJQawNWhsKuB1mGpZ4e/RfVibKYIp1CXe8mLYHUkWRiHeK
         WuAuScwJ8EgEkiSPcY3KiIbqacGPEJv9Ah5+59tFUIvQfLjP97gJBqlW4FpImYa3p+WN
         hymvwB/UnQG3IS/S4GJ815TWeHKRkYAS9oRPowL5jxxM9U0C2pVibF6P5wdYcOP2bzac
         oNWxhlgSru0ikzpMx5t0wE53MIEd69nE8YyVoUhXjl2D+3Fw4769z4Fhrh+S/jriOs0h
         woiPV4uyhsd0vUIiTpLpGwmBwqRyItt4hbZEMsLqo8pMuc26mVumPR61aC2AglEobO6i
         S6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917237; x=1795522037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C2oAxC901LsFPrZY7XEv49QJustbmbWIIv6Ichi+IBM=;
        b=Pgq9n8+4dsWBbw6moHuy8qedcDeMq2EOCuNThyAmPHI0DWVPyG51iCjiSfHxY4rONp
         dILsBI6b6F9uVE6Hv1j6J3cYytFhTGWaSphR3ydN3AzymMqdvMLIzJdQ+1DYpaLsx7+V
         mSCdNrPR0JlURfQF4haPG/uoeJTn2+GtQHrhqcEwQQwh64NVhzDeMSIXMtOfgpLX5LgQ
         OCoTmhGsUcmwf/6vRS+k2rPYPRf9oSS/IKrLFFwg7A7QwvKm1Eo2IrHxRBlynRgJ/BuR
         QLnoKkrOsmmEkq9YYyfYK5hCgU7cKZR+QmU8gm052RFuTymszf//0BgTGccZDNC/+69/
         LKUw==
X-Forwarded-Encrypted: i=1; AL+hErFsY7QoWvRhehbIoa+H2qrdRu5v00rBIZL9ujUyGDaJQ8OrTMx6SEAo0rVfnWRiUWvaCwC0nqY05A==@kvack.org
X-Gm-Message-State: APuU4Z/p6sb5to0xN9/jfAdafrfjxa+8UAvQfwLcbwSJrL+I/CLAKs9Y
	44vZwT9Buh9tYS2VastfMF+gJLqrvKLKqh+2Yn9ByzpFyyx2JBr5ywqdL4b/B1Iw940=
X-Gm-Gg: AYBFou3Ds/K6slwQkRZAmy64i+W+ftK/84HUwrEpauKLuh04mTEJWKQopgkEZwYMGdW
	H/Hlc4sJWo8dvREeWCC3xuYysWfFN+nftOdQelfl3RK8QPvgBoiLR874d8vbrrEEaG9MQQW684Z
	B2a2r0tx6Xi/SxjW7YslGlvm6qp6fMsApqzEc6bCKcifBzkxd+yiyAK4+ujxcG3swX6W6s5iwO5
	1MAWXJIr8j2tpWwySzsy5dvuCsgL55FbhOx6PIU4kyVkDLPDMKgDjTth0gWQOL2vlJlEooTidgJ
	t+F5LGeWShcbqTNc4D1uzHSuKMnj4DTnEvLOg6c/JpawBuUN4MuycdfT0sb/JxpqZE6XRC8weNU
	JELnurNDyKt+zhM7/oybuG/RZMF/HA61wYRvYQu0HAOdguA70WJr0EoJfC2ZgwG32d0Gx5SRR6Q
	zFBuAN/fuHMZStZy5fAbWjEimnTIa1lp4QKth8d0Yw6vT6qYAFNYVbCSjScmHuUmnhfzUgIb6qr
	IXF9u64GpsQAivmiCD4pDu6UU7c1+nkoWTZ+VcIEdiOxSSSQ6QeRG3NhrpUvoG9E5+V7lvLEkVi
	FvI/K0sSU8IZrJsYrmIVpEpUCjW9A57Jp7kZrtZvvyEsT9vy3GlROmEEe4BvAyXsTizItImsH+7
	Uu5qj/MfPoc0=
X-Received: by 2002:a05:7022:1583:b0:1ac:1343:fa54 with SMTP id a92af1059eb24-1b503112a8cmr14843601c88.14.1794917236797;
        Tue, 17 Nov 2026 04:07:16 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:16 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 2/7] mm/page_ext: fix client data alignment
Date: Tue, 17 Nov 2026 20:06:22 +0800
Message-ID: <20261117120627.50601-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 407F040008
X-Stat-Signature: o1tunaysuf3fn94h7rnk5mwpizwas7za
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794917238-887812
X-HE-Meta: U2FsdGVkX19RJHbuEXoPV4mzMTEqKuV6mH18aHd4JnlOMIZD179uj700lP1TKjdUD4QEE781WMGORNyUE5jC8yTZ/sJD6WCI9pHzfQUS0RBiItjMFLQMGAmM8/Tomv45So/pp5VX48thnB7g3SeUrQjEqq+OF2/d6MkeSoIFDLa+lTWcfK2KVWu3p8GGZsOClRj7G71aQs/JfI1Uirri6RHDPvwm0XLlpx08usXWrUQlcL+GrTxeH1FPrLQvbEZC3dRNOTt9RVN9WpF7V4rOmYf0A0dX+6Kk+74ZFyL+3NdaJeqrW3LbKqnvFp456lByF2xtZ1hyiBdDmTLQq6x4RGuHsAgLU6xy4JNj65dEj4jIPjxOFa2ANKLGu2QKPRjZbe8UkeSenZ4HgKXugPTOTHD4SM0UXDUPnqwWIGmRVuUCyDMT6wi+K1JjIU8wBKzD2fhHNsWyPO1dRe4A+ABRQUNR0x7n+BbFBVZK39tXyIDLb0acd/Hib+Pkq7Su74IEsQXyAlPFBJiJlp1XGswvgYBcQAanE8dMEVO3c82lWYDoZmkzqaBe7Ja8zds/09KVdTQHnMUy3JoZJaRpupI2E9bXM2GnZXOOavMG6HJJ6QbYJ57CqXuKsYxUpenFl1b+1Z7Fuh2Y9vnDnUEpirUVbrYrAEGr1lYxpnKy4XwWPpIpLx7vZHVVXPqLtYvhK53DyvmEcbyuN+VNGy8t6XfFZHYTDeIdN3iBKiyNq4Zui1hr2AFUhX5zO2bSEsvFxxaDf+IyVzhrTwPxXr9A3nn9komNA2u4qZXOKf6UvjtlF85brYGFr1vs4868MHX83Z0S3H5KC5DILNrrN5JivDl0e9xd0OK6CfYdHoA2vRpliTO3effRHUm5/9Al9Qn7afauCzKPX/gPhHfholGrdr8AhQxrsNiuWRg6Ip5uWgC52gP4xIm/fLerHfJp6ciHU+AaYeyQ4DYrlMFs4X+XDsp
 J0sVQU97
 JFN1cpcq/5qqV/V+mSr4btKgl9mJfTUupZ20dgXFq+QD2i0+lwytUontco1nsSOX1oCGjgim3s6ykjWzUu1b1orhzEnyFg1Tw1quz9kf8zXoLlX9DZL8DAjc5bvIalDPAT/n/YSggZZHGx6SLDzkErgYqbno4gyvcDQupjWPWx0s/XRh4oXM3whGuxDvjSLhn7YCrRgBal6SKucAP4FnOdX+PJgwh7tqika+WSqe4T7j3OCFuxU95sjcOR3wZR9gM/VK5VzovihmC+SutgLRovQ0yO2pASjJWxdPnK/uu3d+pXg3qpdd47zRxVI1X1zvaSX+DlhekmdGCn2hL9ZY3Rj2H0cDyR9v3cGjSdt1HP7kn4IU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_ext lays out client payloads consecutively without aligning their
offsets or the final entry size. This happened to work while the active
payload sizes kept the stride naturally aligned, but IOMMU debug page
allocation added a four-byte payload after data requiring eight-byte
alignment.

When page owner and IOMMU debug page allocation are both enabled on
x86-64, struct page_ext, struct page_owner, and the IOMMU payload use
8, 64, and 4 bytes respectively. This produces a 76-byte entry stride,
leaving struct page_ext and page_owner data in every other entry only
four-byte aligned instead of eight-byte aligned.

Derive a suitable alignment for each payload from the lowest set bit of
its size, capped at unsigned long alignment. Align each client offset
and round the final entry size to the largest active alignment so every
entry preserves the alignment required by all active clients.

Fixes: 466ae6978a5b ("iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- New patch to fix the existing page_ext client alignment bug
---
 mm/page_ext.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index b679a8c1f7d7..dbc1bfa258f1 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -116,8 +116,22 @@ static int __init setup_early_page_ext(char *str)
 }
 early_param("early_page_ext", setup_early_page_ext);
 
+static inline size_t page_ext_data_alignment(size_t size)
+{
+	if (!size)
+		return 1;
+
+	/*
+	 * A type's size is a multiple of its natural alignment. The lowest
+	 * set bit of the size is therefore at least that alignment. Cap it
+	 * at unsigned long alignment to avoid excessive per-page padding.
+	 */
+	return min_t(size_t, 1UL << __ffs(size), __alignof__(unsigned long));
+}
+
 static bool __init invoke_need_callbacks(void)
 {
+	size_t max_align = 1;
 	int i;
 	int entries = ARRAY_SIZE(page_ext_ops);
 	bool need = false;
@@ -126,6 +140,7 @@ static bool __init invoke_need_callbacks(void)
 		if (page_ext_ops[i]->need()) {
 			if (page_ext_ops[i]->need_shared_flags) {
 				page_ext_size = sizeof(struct page_ext);
+				max_align = __alignof__(struct page_ext);
 				break;
 			}
 		}
@@ -133,11 +148,17 @@ static bool __init invoke_need_callbacks(void)
 
 	for (i = 0; i < entries; i++) {
 		if (page_ext_ops[i]->need()) {
+			size_t align;
+
+			align = page_ext_data_alignment(page_ext_ops[i]->size);
+			page_ext_size = ALIGN(page_ext_size, align);
 			page_ext_ops[i]->offset = page_ext_size;
 			page_ext_size += page_ext_ops[i]->size;
+			max_align = max(max_align, align);
 			need = true;
 		}
 	}
+	page_ext_size = ALIGN(page_ext_size, max_align);
 
 	return need;
 }
-- 
2.54.0


