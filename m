Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE597CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1B48E000B; Fri, 22 Aug 2025 15:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A158E0003; Fri, 22 Aug 2025 15:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0681F8E000B; Fri, 22 Aug 2025 15:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4C288E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:21:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5556585A4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:17 +0000 (UTC)
X-FDA: 83805361794.26.1B7CAED
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB09840003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LBCqHVNh;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890475;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDJ8d/bHR7O8n6mBegJlo1lM3XBldB6kCH+6HxYRPK8=;
	b=LNo8mtKznvt8LQBXC+DQI/Mxwq6waMl49hbody6Xg8oKrOGNjnyF3yiUTP2cZy4a4vJXSq
	SuguAYyxW25bLfpdTZqD3n4vsrWg1+EkBNIwRjGx5Q4V3ZoubtwiP3qL3jGJuQnbmn8Ps+
	k1/KL8agEu6UMjHgiv0Y4Lxu88VFfS0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LBCqHVNh;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890475; a=rsa-sha256;
	cv=none;
	b=b3f3bkRzTF90WL3jioTlOOFCeRxeFhf3Guo8FLIpKveoLHqR+WZymQSrCCee0wnnrWcYF6
	Kk090el80ZVu11FUUu7nTMw1SnlvcFbJAdygAWMMwQamQB9oyAJeiRodlEn8zrX0ic/KT/
	sOatJkuFBPEUe/SNhknfVbOh5bIUuCA=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70d814d0f98so21412436d6.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890474; x=1756495274; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vDJ8d/bHR7O8n6mBegJlo1lM3XBldB6kCH+6HxYRPK8=;
        b=LBCqHVNh5gmgBEkkSBFYMFaqqnCpr5QkPebIp8vMAvPKfWgYT03oVobYvOk67CtzYc
         Zorlr/032FjqybEgZ2IBTIMt5SgBRTb/1jaGzeZnqxFa7Oz+9XTS0KyAmeQ5XUH23zXs
         BkOdlI/rTTOnNAs4aNMGfTzxROwX3IkpoWpZi3ASXrOJN4M6OSZfTbBXi+z79wO1XBQm
         vJkmp3lXwYmYycLuAOsHplwYZ7RVbMTPOUJMN/dp0Q/9d/QUESbAGBwtl7gBLnwzVhJu
         7gSfgsXINqGvVgVRWtHIqSALCiOTC4xFwrrf8C/lARaeX6o+Q//pL2ePY1XVuiMETggJ
         UC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890474; x=1756495274;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vDJ8d/bHR7O8n6mBegJlo1lM3XBldB6kCH+6HxYRPK8=;
        b=nyQsOukj5UCyYkuCj8WVvfC9x9o+XbN7yCudL5abBDFkaBaNfJ2QisgfLbh9SpITW6
         Q8d6ROAEUwlPWI7pRn9QwXzNl2sItYDbNM2w71CY/NkNfs9Y/Jppknzc15Sovwdv6BL+
         nRhP8jjAhapJEgSvQdiCcmjoU1oNrd1ETYIlQMMDhcUrcSrTegXBNC8kvE8cNCgjMcXq
         BOiib5Wi61qK5P9IbVmhhPW9f4wo8QSfsoDjdErKUa5zayg7HluIg8Z8F4/DaPjHKKIl
         r/DBY63W/Ce7S+FF/f/Xhu5QWXXZNECyGDhSqVzklCuGTrNvgdHgnVTO935rUEkaocg9
         xTyg==
X-Gm-Message-State: AOJu0YzdlZOS4pQHwUheCSdsULAiXqNFDLIhRhZfQOirfd77fM7zdvkg
	GuxNJmxBQCd+X856+6jiZCmI7Ii//yUZc1fP7rlntqWOg25LyLZyElK4mnZj2Q+VzU0=
X-Gm-Gg: ASbGncuNTf5sohBbjq612SrweFKCEVziV1Ij0q1qsU+Dr83DJLL6xYQBvZx3nS3Jc+w
	Op2C2U3r3BluVqVNRsdZBx0uQBP0ay0bkQZHkSKSrbrCVeMtLdjHv9ilo+bFADGEo5pDrrFNNGm
	Luo0MtCTL8BXdQAxkH+3wo/zLqefmF4QrYOieCyyxljQucu1xDePktCusovNwJLNBLL8pr08JFg
	IWIOMLq/Mu3WBjxc64WLPVKpFUvQzuP/lZ3++QckWrNaMehAErsVJna8l3Fai0MGoukVhsESn97
	/gnJCESVGFwdeov+1dvkbU73+VzfaXh9KJ5mtLRl+Bh28GB4xC92agRzxypAztXKXldHwjA1E4J
	bOv+OFf3kOgC6AReQ4gKApP0xLDGITu4BFg+zxN8KBKQ=
X-Google-Smtp-Source: AGHT+IHAPlr2J3KCV0LUW3oevZ44eqeFOr5c9XUGP5N3YDy/mqVt/tLuB8Hg/3fh/SZEIT3/dJDT8A==
X-Received: by 2002:a05:6214:4b02:b0:70d:9f16:9a37 with SMTP id 6a1803df08f44-70d9f16c223mr31439766d6.62.1755890474481;
        Fri, 22 Aug 2025 12:21:14 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.21.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:21:14 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH 5/9] mm/shmem, swap: remove redundant error handling for replacing folio
Date: Sat, 23 Aug 2025 03:20:19 +0800
Message-ID: <20250822192023.13477-6-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB09840003
X-Rspam-User: 
X-Stat-Signature: wgyt73gwru3c6w7orsxfwthxncsw6sp9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755890475-430236
X-HE-Meta: U2FsdGVkX1+lhP4CCPxAIRohf7r5khgRVgU45H67ccTTXvSbjKen2svTSSpLgUOIJ9OK0q9c5wAaqyy+gdYz8lf0pVnpWtFdSRXf45C9MyOlHJKuMAekDTw/BESMi6CpjYi2I5ZyoGTFiJCXt1gvdg6llEGyMt9wX/+kA8Z02gkFIZ0tqyRi3JvjPHaPIURZTpqf5rXdPeyftfDPgdO90Vo9X8Vz10Q/F+Na526amjL/uUsxIQ2F5SViwwLy5EjdhI+BbZhq1MBmY9TTVI0BuwmvoCOll27+/MNo9OzNV6/8+Qoham6aXlRyS0+hcHo5earLlhxn8uKSZZZb/Ge2xxsU9yjzfYwyaKmXsJU2CkF9ceGeC38QGoldQChWhHCci9F24lDavGuzGGxwtVNifj8DyRftDgdidYlp+sDsLGGVseUdeGZCY0bzs4SZZIdcn3vf2YudnIHDB13lSfKral7f33aIfXr349WDb8yqtLNv3TffJyVMlPjjX1bOYGhrG3l/olUUSFoqfIMFp8hUMGovJssZR+xCz1qteRf7+Fggfr+3NI2L6mxhA6UER+UMds4BRbJlW/zNk59QDW2uAGt13+Hjg4B1UYYFamfHZBQFbc6PAvVpmCQA/SxkEfNLRv+Z3f4RurNcT6VKb4BpPKnnV0PojWyrISPW9CP8nwBNNpPZhKapAP9MYmHF1pq8QGN/rAoV9Zwgy3GKk3DYHnsCsRXYHB9Jnhebe5GoPXEHBS7WF54WsjdEAtSvepEeaKoVdCujoPK029SnSwWTy3+GTWTKVxAHxZ6ekYpMPWRHFnKJ1obFylyIomuskFq4GWFFLeZT3FO3L/fxWWUaLTv0i0p8XtUvSzyQoU7isc6sLUIhDNtKGw2vOXVzXwacp9uvQfvc6LLB0PXY0KpkvcpIIWDev06lGQKF8rv1+fqpb6jww++B3P6+VhuGABwB/RG/O7piKQWiu01v537
 IXDlKDaW
 FwXa5KRL99To0BbjIJ3DJxhLZeA01wRDTwJ9SysoX8HboiOnJ+fM6bAzWGLblS6t2RW9A+lpcOgcqbwqNONOFd+MqS9CHxw5enEQ5W/8bHEQUpBlynp9Qr3J8RGdn8DB9eVaA4ayyA8udyYrvJTT8Sf+TQo2ifXsXIB612eUSuXaudNy2TRyxvgAUDbnmJyW1SEKt8z90n1+6pGwV8lnhMkNXb7qvXIsD2ZADTA8+P6cLRj/4tfnGBE77wWTy7fO6PmWkxRI1u2PLgGrpgU4C2uxCIT641LYbaJjjeDaeP2ZaQyFsGkh2TOlR7SULH8sYGxRB+AclD1pOp6LHWJg27COJ66k25ZhkUr128CoKivo66dHuR5CBqRhRpI9/ecjMJ1gKvXnD1irJnEgQSISYhM3BvRjvOsyEBUlo+OquAf0e6Wn283riYIJyLsR5pNRiJLDag/TKjXnzfLgSW9b0MFjs5kc5f/s36MAA2WvImrlubaORF4JBNzXDKEz5WeyloKiuWgktAnxvm7K27KEqloSnFXp92IfE81TT6Aa8W7xLFLj983x3fUG0xm6R3Gsh2BsOwnif0G7+57Bc+dyJysbOZM0jhfZ7NMe5
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
fail due to an Xarray mismatch. There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead:
if that happened, something has broken the basic principle of how the
swap cache works, we should catch and fix that.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b4d39f2a1e0a..e03793cc5169 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2158,35 +2158,13 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
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
+		WARN_ON_ONCE(xas_store(&xas, new));
 		xas_next(&xas);
 	}
-	if (!error) {
-		mem_cgroup_replace_folio(old, new);
-		shmem_update_stats(new, nr_pages);
-		shmem_update_stats(old, -nr_pages);
-	}
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


