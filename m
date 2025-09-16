Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812FACAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB34D8E000E; Tue, 16 Sep 2025 12:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8ACB8E0001; Tue, 16 Sep 2025 12:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0C48E000E; Tue, 16 Sep 2025 12:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B583C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A6DF140142
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:16 +0000 (UTC)
X-FDA: 83895580272.26.6A02E76
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68B5D100002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V2Ud3lnR;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038534;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGZJewVWtmBg1AhubXnc5kIP+Etaz+JfrYGw6S6fAgs=;
	b=oblF9n0wUMDohw72G0LER729LdNdyDnl+N077x3JGw2Yg3q81O6vonfdX6p4wB6zhvgHWp
	/ekMk0MN5rWpSnYD/39lrp87FL5Y7BQBXX13fTlas2cxipFNnQvmPrZBtv9568S4uhqovV
	jyK1h+9V9LjE0XZXnx9czZH0rE/LaEg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V2Ud3lnR;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038534; a=rsa-sha256;
	cv=none;
	b=joSW/GWFsQUigBfBcERo0kMfpeUb1ashh63K5lKiYtVNqWIWj6OECxSqF8zOPn4S0JhgtU
	ZfuzNBTNRnuA4dzm5xrbqFLVEws0ed1avnlnQn933kYUwTJbzLllwUVPRFwRUBHe6a5RhP
	zpCYQW0aW+b9X9/sN7a0M3f0hJV0+4U=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-62bbc95b4dfso1692368d50.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038533; x=1758643333; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iGZJewVWtmBg1AhubXnc5kIP+Etaz+JfrYGw6S6fAgs=;
        b=V2Ud3lnRIpYptirZgodWh0VuuZtrQglIzSsFwLoXn/V8NvN9p+genrlnOi0E9T7GrP
         XwmI79uz1cGvV/8ou2rAyY2ZQEcjKpw52z99QJAnY/plW+viArouA7kjIS9iq/0WWgkz
         AcKAAk5EUJcSzWCZ3lmQgZwcgax0Fr2d6znwDqKqPKSm+kz+Zq0EzF7Y3tkV6YVinyMp
         oDRHmO7QHwWZXyHNW/PGju8hJNoz7BD6J8iCjl3zP9dIrHcthZoozy/z6+iYHuCKrtSL
         9xKYZMQh0VBeec8MzjQEACor51I3J8as+vwoVMO+2b23zMrwDgj6uFaCulwIey2gzPxN
         HyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038533; x=1758643333;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iGZJewVWtmBg1AhubXnc5kIP+Etaz+JfrYGw6S6fAgs=;
        b=i1VTaJj9oUYuTndrOyzrPbAu4je+mGLkQuJdpgykZSQUextYphfvTi453Klo4vJfO3
         inF7XgqNjDf0za8WgUfJaVMtvNhFNUNgZUKKUvv7CLbYpdt7cqnNESFf92V8BZWQ/jw7
         qm1Udy3KJ2kLm6UBbCgratqF7hzS7UEZ8+pQtrmdviNXa3u03eGaQcDnROEPZqstbvBP
         f9vICFR7DyyGahascOl6B7l8C7EjaaYWwAmxO/Uwg11ymNEooQaD/rexdB4RawlMc/wP
         lGU8/OLS3w3Ind5uoUDA94T/+eQc95mWiSbtKEl8x7awbThycB6UYONHiwFsnEdWXmCP
         6DxQ==
X-Gm-Message-State: AOJu0YxfEX4wtZ7+P0jQ0c6+v7XKu3TopOphiTtY/T740IuTK8Hf8bsa
	HZqkU+BHfmEytdUrMFMohNOXm4Fo8qXEAiVlGfgzh3Q4j3kbNbOJBzMezRNGo9RAozk=
X-Gm-Gg: ASbGncvTnzVSLN6qFVF1rc+VLN6mbMvgzn/pmOJ3F0yKg4Menwg6VsJBmnXtMPKEkGz
	Ltorp+GLIi/FdIY9OKzMVAtya+HMtn4qE/NMwvKkXOZkI4B0qyesUao2vDKZ89UpKJl+G0cggyb
	QzYGzutYpkCMBAsjEf7tMS2kFq7dn4f47kyMuDkgoBCWoca1oqgpLrt9rcP2Xb6KB+jLvQ1zBhL
	ZIcASzkuZNMVnu4dX3+JEg2KAbwlLwhcJDxXfp7PGPmDyUStgKM9xrYCPn+iZxwkG426GnS57Ep
	6xw92umIfRyZfMIjXk9/ZjpZ6FA20JqHjQXMzJHybzEwx4eE/iKwoVJFFvvn1Xq3r9Bv/oz4kfr
	PYZEZFGZGC5D+rTzePXiFy3uZykoE
X-Google-Smtp-Source: AGHT+IEcPZ6zAaIN8e2Ph8IHvM0WXbapzodJjPQRaKLbM7twTGX8w0w/0UkhEBY/MLHBJSqkT1Ar8g==
X-Received: by 2002:a05:690e:250d:20b0:5fe:ec6a:4d3 with SMTP id 956f58d0204a3-627258617c0mr12912263d50.27.1758038531125;
        Tue, 16 Sep 2025 09:02:11 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.02.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:10 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v4 09/15] mm/shmem, swap: remove redundant error handling for replacing folio
Date: Wed, 17 Sep 2025 00:00:54 +0800
Message-ID: <20250916160100.31545-10-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oy69zsr9ria1645fbgwziu3bda44uafo
X-Rspam-User: 
X-Rspamd-Queue-Id: 68B5D100002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758038534-504879
X-HE-Meta: U2FsdGVkX1+54w/IZAjyR6PTXUmGnL+pBmYvkrp68QTJn7Fb3ntjk3+AoyL9oLCNiNDVPP/eweyt0qEkWP2ioB0ppANMSm3pWCalmoOzGNpepgRWnDPVinaqXy1/nqs78w0lVuWTtJrRIQ9GUAqXSPAQGN7C7yElbszb3eKr0fFruCdy2cJjuKMj86nA1s2NpjSGFuT5YABvb0yFeanaRsiq7T0oZCy5jPCSJrORsS5DxskqJetdrKT/T1XnEhI4n+yIvEUdzYzz+fhttOZCwyCrH/XSbhbmfKUKqTDhD6+9zG2/BXuN3EoCCtVnLyiMtdyvQj79Oc8ztNajbmjPd/N/L86seUXfSGLawLVhbC7l2yg5XnLqwzw72ARFxWntJWB0XIDr4h9hBPp3QZx54QghxsH4KG1u8ppZO9svlptVV065txM9BUGMg33sF9NmGkT//XumitOdEiYEWApYMrJkRiZa3P2QbkP3enLWTXgveQtsc96QyePE5jnONGLDBZQvLDbeRpNlnxZx+td/LJ7YzO3mj2o40WmTExfBlAY3gaCx2qFFvbmiq6egcZ6BFXSvluUh0Ba7bJRpLUT+Foy6qKjF6eTvPb+gxYmnRcCLr5cGMuvJN8XXnfLGw4pcFvfbSw4ciXBGxNFOXswvHGSN5QMCklptiqgDq6VrHm/SOH+i5B8PA7Icnz7COtZkbzQzTQkgKXzEy/13To1XiYm0dRp0N9PZQ/Z+hRGYu7i5vtttHU5H/It2o9DfIjhZSxaacdhUplQykaeBehknJAMfDp7H7JFKogVHn8ypn+9Mos1krnPJIt9pQPl8aFv1XU6GNHIA0xoiHPmvAuWgsMxrmYKnOXLOQU8KZtL5QgRFS4Hh/05kQ4S2OrMblFj1mz31BXcKrqJCAgIWU09VrS7a7FJFzlcjNCq/ghSHPVIAyIbtterqHkX3GgjYxKrUYUcJxMtSuzpFKd/NLO0
 yufP7xmT
 HzbP1+sNjYLb7OuBF3DWz4zyeHdr/1fZjYaFZubEKeXCaIHV1uOHIL4kEYmzj/xv+DSKWHiNwF+su8iU8mzk+SGYILYobcEPyMtBMnpsjLqUq9jmHVQeezGlWVh5/fQYmwWW1K9bmIYpW0bVKgn16YbzhusYWbtaTe48chuzizdQFm3Plhgg4XQo+T5rtoJnQLItGp+sbAF2CGCKCttWQswJaCAmRgrgaVpzl3NBsl+vzgSY5espR1BBtRfnR2cLh6OVX8Zxzn8ASXweyZsyEcNim+bcR4GulItOG63TdJT4cZ2xqGTEcwE7dd7QhMnH3qpRnYdYhn5PG8x0hjkVFpIKio3AqQFAYi+l82AolhilE++Lap94wlblIe2fbHzxC4tIwLBjkIICqdf33ywcAqrJjWbu5dhXsSoOevlk9t418zlCbjCCKJhmyjUYRrylIv4Ter9eW2RWBPHRY8OY4kVsd02Lsj1rk7P06sG6dJXgUSuuO/gOVMErf2eBAf0x1nEd98JPGmSDMOJVf1Duj6j4MlSTI/k7I3W1VYhl6oxP3A9kCp4WYC9+tLG4YEWzpXzfMvY9JS4Dna1f/G2VZ78I/9GnRLHs3ViG8y4h2irsK6rQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem may replace a folio in the swap cache if the cached one doesn't
fit the swapin's GFP zone. When doing so, shmem has already double
checked that the swap cache folio is locked, still has the swap cache
flag set, and contains the wanted swap entry. So it is impossible to
fail due to an XArray mismatch. There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead:
if that happened, something has broken the basic principle of how the
swap cache works, we should catch and fix that.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 077744a9e9da..dc17717e5631 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
 	for (i = 0; i < nr_pages; i++) {
-		void *item = xas_load(&xas);
-
-		if (item != old) {
-			error = -ENOENT;
-			break;
-		}
-
-		xas_store(&xas, new);
+		WARN_ON_ONCE(xas_store(&xas, new) != old);
 		xas_next(&xas);
 	}
-	if (!error) {
-		mem_cgroup_replace_folio(old, new);
-		shmem_update_stats(new, nr_pages);
-		shmem_update_stats(old, -nr_pages);
-	}
+
+	mem_cgroup_replace_folio(old, new);
+	shmem_update_stats(new, nr_pages);
+	shmem_update_stats(old, -nr_pages);
 	xa_unlock_irq(&swap_mapping->i_pages);
 
-	if (unlikely(error)) {
-		/*
-		 * Is this possible?  I think not, now that our callers
-		 * check both the swapcache flag and folio->private
-		 * after getting the folio lock; but be defensive.
-		 * Reverse old to newpage for clear and free.
-		 */
-		old = new;
-	} else {
-		folio_add_lru(new);
-		*foliop = new;
-	}
+	folio_add_lru(new);
+	*foliop = new;
 
 	folio_clear_swapcache(old);
 	old->private = NULL;
-- 
2.51.0


