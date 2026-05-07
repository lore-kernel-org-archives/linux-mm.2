Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81159CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43706B00BA; Thu,  7 May 2026 18:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C3C6B00BE; Thu,  7 May 2026 18:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3A16B00BF; Thu,  7 May 2026 18:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC3476B00BA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 658DB1C0DBB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:50 +0000 (UTC)
X-FDA: 84742049700.04.C297F44
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1473EC0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cWXHrN+G;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XZVwPk/FHchRW7F1q982DWChdDEL7ZRxXSzf1eFvwA=;
	b=TlDTWb/pBOdhlcdsWXpUsfCQ5s5+6Aq3nAqrLVjpdK9c+Ywfov7cuyP86NUs5kif1WmLqW
	zkKsHmGXpcHcaJe0/hdjMmbc1yig6rWKJ2mzCni1qFHQDBZ106xKQD6B0NCra7AAONoJ/x
	spBcveW7SgDe7hIIQs2YGPzD5f3ZgNo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cWXHrN+G;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192568; a=rsa-sha256;
	cv=none;
	b=k0fkegNmlKrCbrhiq+wjc6KFJpr4lhqeoKUCDVbbEvlE2zvpqzzzFsE4Osae2hsN1MF8a0
	1mnRFTmw8dYbCyzMfzYGFW/Yvc1RWh6Ctj+OAmdh3XwtoOAEhdWRZ08lrySUL3E3tdOTxg
	+wNdgMONam1823aOHlCs7BwZX/v3bwU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6XZVwPk/FHchRW7F1q982DWChdDEL7ZRxXSzf1eFvwA=;
	b=cWXHrN+Gry8ZKxK5fJctv8Zl3s+MvWh0zt73Wpi3ReeMJrBpVgdmo0Xco9zLd7Hiv+glzn
	RjZRIsxe89QEtRgO39Y/r8hy9tfCpPH0HKPaBTgKvAF4Rjmu+9GMjWttUcAS/8kNrI9qld
	iVwPaJraVCxCVbnAu/o45xW3dOm9OIg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-dqwCiLW-Pv-JnUisqFpMaQ-1; Thu, 07 May 2026 18:22:46 -0400
X-MC-Unique: dqwCiLW-Pv-JnUisqFpMaQ-1
X-Mimecast-MFC-AGG-ID: dqwCiLW-Pv-JnUisqFpMaQ_1778192565
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44d83e45febso1970336f8f.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192565; x=1778797365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XZVwPk/FHchRW7F1q982DWChdDEL7ZRxXSzf1eFvwA=;
        b=npc0iWrv5inbNinamt8CEtrIE6Y4n18d6cayGFPOVOrq3VnAd3FGKkaoJ+j19c6csM
         N4Ki8wEACQu4/Ut5rCFqq5s4yJ1JOrYXYw1jm/p40qnMae2VLKxeq1lcfQ9WJIGNOtCE
         I91/oMwIyvHAn3Ux2OsNFHBVdayxlB+ko/9v8oPgUYlHK69FppN3eQwYhypt4BDCydwn
         D//TPNrPhQVY20zTXiph3YnLyuP312GSmZDLi4jlsPHVDxBV8yKxJ3VNFt1ou0PdeVdl
         YmE/R9q6m/Pcfm+1DkF9D11Z0bAn3LJU0+LnMmrfbu5jMDNn/2KIrVK+xlf1LdTzJE8a
         8n1w==
X-Forwarded-Encrypted: i=1; AFNElJ/JmffrL6bxfNkZ+jkXh1C0G7DNLfFnk7Ymhs88Mp/fy+79fwGMzH9/lJSuHajX7He0rKRTK/MIuQ==@kvack.org
X-Gm-Message-State: AOJu0YyQPs0RXQEn0+bOz0O0LZM026lvlGLW0EWRSU4nncUYvQt32UTX
	ZNXtxacIfTrKIa7GNHKODZiy/sAgmvzRC+8qNJBPeqvFNbxcp0S5kJQfiHaJlV6tsFv1Iw1hG4h
	wjw/Tb0uRoC8/8gd1JrlIfvuaTUY8CXVwCRWdCJARt72D15XByKew
X-Gm-Gg: AeBDiesCDQ4vQPwO6KzRHziotlbuyVC+qzUASZIoWlaoSoE0OtQxNmo67jqxOlZvLyN
	aVOeiQB9SdCG5oheH0GTUm/YdKXgquCDUn+J1g8YZ9dxMra9qod8M7eXhM5gtYq7XL5F85u5DtR
	XNlGajzPyiocCRFVM86CYkjp9O+ScGiyAM20F4Q9S9hOlL+cZpX1+7X4c2glFtPmmMi4hlkXOmH
	uKC3lTbwRDJnf6TT52kBSWnYwzOjjCuDxkl3fyFzlY848FDxtee1mgC4tswKsTd7DrFK5bG7imY
	xMo8a+ej0Fli/DG6DauTTqH5ZOnhAXDn+VNeqm/1H+LpFwSWWvVRt1xhiV7k2E9oP9neRW8Ua0t
	psaySfl/MZ6VA3CBRii+eZ001lb7JJQ2Ju3sQ/5Tl
X-Received: by 2002:a05:600c:3b8f:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e642deefamr16106275e9.7.1778192565044;
        Thu, 07 May 2026 15:22:45 -0700 (PDT)
X-Received: by 2002:a05:600c:3b8f:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e642deefamr16105995e9.7.1778192564484;
        Thu, 07 May 2026 15:22:44 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e65c0da87sm3543195e9.21.2026.05.07.15.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:43 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 05/28] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <4b89470a07497a55ce2a8d31e4b746e734df1f4e.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qy_-oVUJBNJYWaJgHGKxwSvrwezD9-OZDEmQ_v71vMA_1778192565
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 3w5dxtf1syo45mfeayskbmsmjotoshtf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1473EC0005
X-Rspam-User: 
X-HE-Tag: 1778192567-934358
X-HE-Meta: U2FsdGVkX18yAWHn5egtczHI+nfsIbLaedjdfwgsBqvODdTXF2NP1mTtuJ+fScqmA17eDK5A8sdNSCvPx9PiZIb4bAW74ZaTAs8NYjR4H5ThnXej/FuydIwMcKGLZ+9KTf6vj3nvoes6Hl3BOaj++Z0nSuIsPES/lPt8CzbNM3WpmNfIBBmH8duoQgpqepmsTvkU1MA+umrm2XQzexq1YE9kCO2c70mRAiAHc/TzBoP1+gFAF5bkrUvslyCLZnxda0Rcg48LXzF6uF9Cqvllu8wpggeXpf7e96Nv1f/hqFvLZiHArKfTPRH3Nddxo9M3Ciy0lHxGOVrir/geQsVh1MUCSxQHKkzEUToYjzraEskFAhw3iZCxWbU20QPftfUHINxUOL4qp/Vf6vqvMDq/OntT4m4llno5GjLKiIrFJlUx4TTuXHenxylU1otX8kxl0n+8hERvBSf41Do339EYC/Ga69iZZD1X4e9nnzUchisA7LHAPEhrHYBmzbJ24is3G9rciniibzMXkDxJTLdRgzA7WfgcQ4hPMvutDY71ArGG5S5LUOsFXRCe4i+EaMUwGUqJJbUdU4Dfc7x2Rh+m5TgQwGQM7t/Bq7yjOvkC5MH7YPz5TUkvHLRRlNmzL73dUA08zWtyf9BwN6OCLDwxXnrTVPqBJ3Ehgs+GTGw2liZ42E4SH5lJ+jInLxcT7aZpsNkzsC2nvt/yoVOP5XB9cQFWPWue9ZVcjkAsAxr9fpe+eXzOFUYMoM0vCc64rGhLrjv7/cDTU8iq/941XldRgFo0wZ5VJ1oG6Rb0+cbi+qNXiOnOO4umgF9aKp0yyPYN8WS1v4WV/GpsI6KefpxCIc2I+hqxz3EBAisKu1kOh3/lXDpV1Lnjn330qfEo7b+IMAFRpYjT1Ac+4DoOS2pkdnGJ5vXwae2v6b5M13Q2RixmBlRPphhkMtzPJ6gWKGCi2uTFYZFY+010EKnMdjW
 ySwX/XKG
 eFLW70O7xY7Tfd0fncBSzJrPAaSoMFVrxqYBXZouh3HGf9mDYHC++v8QjjB8L5oSpzNQXY8DTxhA2WipK/sbBhZGe9vM7LkUxGv+L+4G4DbozOv7g8ZSRq9tLJnlvTZ5vXPYkzg9i8k/JzEz5UOr4JF0/f658zSopsFjq6b8byxCPFZgc121ZcOaPDuwRbH+X2bSUMcCBFE5lYfVLXI5PB4uMAXPtEesKZM3P8QNgMRREX5MVUUuM+PGHG154jihozqjsrqcgimy6j4w7uhcADUq/Hivtu/QQBN1zgY7ysf204f99+gwQ/VDbp4ic2Ecp+45iDlAxNGjmPK22nPkFphYVi8T//6gzFBFkUt0c/bPadxiyBYVXipGibg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When post_alloc_hook() needs to zero a page for an explicit
__GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
instead of kernel_init_pages().  This zeros near the faulting
address last, keeping those cachelines hot for the impending
user access.

folio_zero_user() is only used for explicit __GFP_ZERO, not for
init_on_alloc.  On architectures with virtually-indexed caches
(e.g., ARM), clear_user_highpage() performs per-line cache
operations; using it for init_on_alloc would add overhead that
kernel_init_pages() avoids (the page fault path flushes the
cache at PTE installation time regardless).

No functional change yet: current callers do not pass __GFP_ZERO
for user pages (they zero at the callsite instead).  Subsequent
patches will convert them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 92640ddb0b7b..2bfa9ab60976 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1882,9 +1882,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


