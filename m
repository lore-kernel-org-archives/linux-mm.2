Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896D4CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D236F6B00D6; Fri, 29 May 2026 11:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFBA86B00D8; Fri, 29 May 2026 11:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11186B00D9; Fri, 29 May 2026 11:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B05616B00D6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D285160CD2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:16 +0000 (UTC)
X-FDA: 84820825992.14.BC78C1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 14CF51C0006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=APirCoaT;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068194; a=rsa-sha256;
	cv=none;
	b=vbvSBLdkT4QVm3QQkJYlwR1B3iDc6FcXw27EXnyMUUUb0vtUrP3w1epj3BRXtO9CHbU+Ko
	JRZz2eywFYQbuMEa22+3vpDVmbiSGoRZCPpDN5pAlfTK4uQMTKt4nQzmb6nE8vAMS4m8Ke
	yb5lzwcf1UUoTMYVfB6RijNmQCssT0g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=APirCoaT;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xr0Wq/tgum3c1wWvimcTvl9O1enHA5UssViDpRUdduM=;
	b=XREkrHcx6Wf2xGGcTXSWirXlIo9y+kHBFnRayaLzZ+izBtry9Js2GUW7KfDjMkDYpcn0sM
	1MkVy+SxR+euzg9yPCb8XIkUHx3pkBG0APC+ShIoO8nTaRbZQXw0cw1gGloE1IZxYFZQNN
	/dqyAibf1NEhHzjEWZEvIbqA7woQ4nA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xr0Wq/tgum3c1wWvimcTvl9O1enHA5UssViDpRUdduM=;
	b=APirCoaTRGpugczVmqZjXm8eOmvDF4MOK0vXhs0CisI6HivuXVCo2F1q5DzF7KhAWTmjyO
	vMGknFOTkbE8mK+2266t8N6F4OhWA2UShpBLpSOh9pObd2hU/rrser+qtva+RLUxh/QAar
	ObddwoeUqRRP82SKidiGijPOOOA1xaU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-U3mfIdCFO_6iXXxIq46dwQ-1; Fri, 29 May 2026 11:23:10 -0400
X-MC-Unique: U3mfIdCFO_6iXXxIq46dwQ-1
X-Mimecast-MFC-AGG-ID: U3mfIdCFO_6iXXxIq46dwQ_1780068189
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so8348955f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068189; x=1780672989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xr0Wq/tgum3c1wWvimcTvl9O1enHA5UssViDpRUdduM=;
        b=L5FjslwHeldQNypXqRucLxgWj+20O0X97bAHE8comfh6dP8h7Ar9WfahzhLFHrgy8r
         EcktwBGybSKXERtMW/g2bawYzCzGDAnTHgaKT4KCUEaZx7CA/meBwPT78BiR/3oXMdGZ
         xuDuWyvGK9nkdtnzFirh/OmwJno9yVGklS8OuFUqkxMmiSsZJVVEdsyKNDmb155+cNzN
         6+SBbtlhXaTe5VUxNLei2ZDAhkXEF3OYa7YkZsOV6jBPjwYr8elK3pIpKuVF+xhv5wbt
         YQCW0tgetxtr6tEmmxGCLO7XSIgOVUrxnZBZIdytnHUexwsEe5u++/t2Dij00Ikgpxq/
         aUVw==
X-Forwarded-Encrypted: i=1; AFNElJ+J0tVL4DunYaGx4lk0NFyVL0fxg3aZVvlbfaLeMapgYpRJHciia55VdPltov6tKwWY2/+877wR8w==@kvack.org
X-Gm-Message-State: AOJu0Yyj4c5xoNMWSqaiIWYr32IMrR878GDjCQSxWyp3XQpX+RaSasgA
	I119FCHhW8btoboAeMn9uG5vq1lWKpnFQ7GiAR5IEQDbHMFo/dVCvimpDBSJsLyOFgnSpQIsUbo
	PXwfY3e9f3Lja6nco/ivMBEbesVdjVZTEhVJMiqr/Oy2S3rqf+/vq
X-Gm-Gg: Acq92OHGjj3LgbslnWrhufDwjoy06/UQFLSVE+PnmQ85YLWCwobcxqznv4GCUH/FFo9
	7UBr5xp/0hlPQT86yyNCdXpV5fxAoOTwfu55dzzIkPEsud8B62HlnknNgltn671/GB0p9tCMI+t
	K9xkTR5nQK4LghMQ9SA58C6bn1ixxOOOjCZb727jL4u2jLGQYflY3R9660VXxt1fBoSeikR6QnE
	0PkX4PPCD9zLhjk9/bXiKZAcCFpwI6+sYjAmzd1tUScD0lIHqlQs5M+lDaXvfP4xnBTePpiYiXZ
	4Gt2bviGCRrLlplysvjvPwEJNAaIcPIClb+TisdRSCaxwWy90TGPoQamwGu8gW4ACcTnHzGrIYv
	FgVbZbBIDR0UClUrVeOldFesZh9TtW0sksYvbqAZbubTuiAM05TrATA==
X-Received: by 2002:a05:6000:41f9:b0:45e:93d6:359b with SMTP id ffacd0b85a97d-45ef6b2254amr513193f8f.9.1780068188941;
        Fri, 29 May 2026 08:23:08 -0700 (PDT)
X-Received: by 2002:a05:6000:41f9:b0:45e:93d6:359b with SMTP id ffacd0b85a97d-45ef6b2254amr513116f8f.9.1780068188420;
        Fri, 29 May 2026 08:23:08 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef35874b7sm4319354f8f.35.2026.05.29.08.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:07 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v9 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <efa8b140d51f8993d9b11b2f69cde07b3ee1ab26.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y8jEU1Oe8FuRA1uy9QsfwtwjMYLRZgz8FmG0nll45m8_1780068189
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14CF51C0006
X-Stat-Signature: n9uazz1mgc6u38iuyk49s8o4bcypfbej
X-HE-Tag: 1780068193-185773
X-HE-Meta: U2FsdGVkX1+If/UN5ek2ySkqgqiHdK71sudmqfn2U9vVeXz3r3lMUJPw4IQIlpw7AUhHXU2KmXYkz++iwZHGMxpeZp1k9HzKbxYuur1gRhK2RKI4mOH/zPgGL1qnVBgNvVJZTdfdHM7fNXskg2nZflcAU9H573G+CmVzlliKmJlIVCStwvPusGeb80UyjF9PATHXt1Lib3j9h6wSgmXp2ehTRgCAo/Ate8ucL2x11MwN7LRH33l1hW7++NeMLUtdVJxjFwD8mwiJ3UX0HzxJAX8eLbjQ23WzZ/SGBdVQZ/Yd/AsrQw+xF1IkKpDIPN9TpwhCVWWxPMhdXWqJVu7GevkrFNgagBRrSExfNxyAx/MGzkPUlWjN63AnSoh1/fQKNKIjXRjXKDukLIk+2t8iUH7GfbmjhIAN6IIl6ws/oTmAQjlC6ABm9PEEoAIsy8QdmnyaHrmXcQrKKloEK7nDwd56wnq3tshgFkIMnmJXqcFqOtNZIgpsCH7qypo26Eb9ou1LI2Y98uoo+mNKAJZIZBgxfg0GK7Wn0FcW0CUhRlHH5RDW1sUVynYB6xaTwY/HtAAUN9sJiWoZGkGcE6WJZsWMZBLca0zlQg8yHBPtN9eLPuVF/lwHowbtCkR9P+5Gt2N8fxiARcR1qvrd5dAWll4VSPP7vxwWGa6qvU4oc1w4uCsNcbBRIJ3YAKDmmmKlwxIzDBi0921aCJ0n+M0gFxTJnVY9aH0nPF4MVKDaDBWJpD7JtYx/8oOu8YWYGYyPJhMu4dWarjtwqjRIG3yWcjkK6dWUcVAxLxm2pmiGCihqXCLdm5JEI6s9pcHbm70QLqJlcETtaN2F0wT5pOy4IZSW1yFCC6he/lRHhubICr4tFHbBzFz+Ozs5YBmBPCn7i9EmMEIZTbgjQe6tgzZqPQG1wIYZ9crXvg5+kztOFfw0txSo9asuaJ5rcnpFHymeRUZjeXW3G0E6n/YhOhN
 t2gL4Lo7
 48PBodX3IiBgLMusFxBLc11sDr/TpcEea1G5uHd9mhAM8uNeH72Za7Hk9ptQMwC6kxpB67ZuAOtEcUTpiTP0rPPSzm1Rli2uf9YxVAZo5DwCtbaFFRiQDKcbq2WEg0fPjXB5j5wFpF9qKgvu+vJBEFoGx+jTSrj5EzKefSVFcieECcNviMvoh/+cqlwpBw39ibN0Kq6ouEGmPtKrNnw8PHnhPrBwdWvEbewqCzzOLIismC/t5zrlYboM5jD/TgP4WlneG9nubq6907UuspfCz8WA9T8uLM5TAE/v3Of4VxYI3FYpYK9IGOzbR49HwpJkgWK1PcfSrzAIcTNc2wm3No76QB5Nbu/mZBQYT0NbTxrwccklJlqcBC6cQj/psdOKNIbX2D67PeT6YJqmLtx7LdvMyfNpZ/1J5eOc4sO3eA+a+sUmjllE+v/mh3NMEukrzdBno
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
 mm/page_alloc.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3108ac9061ce..ad0655387e9d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1864,9 +1864,38 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * On architectures with cache aliasing, pages zeroed via the
+	 * kernel direct map (e.g. init_on_free) must be re-zeroed
+	 * through a user-congruent mapping.  Host-zeroed pages
+	 * (zeroed flag) don't need this: physical RAM is clean.
+	 */
+	if (!init && (gfp_flags & __GFP_ZERO) &&
+	    user_addr != USER_ADDR_NONE &&
+	    user_alloc_needs_zeroing())
+		init = true;
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE) {
+			/*
+			 * folio_zero_user relies on folio_nr_pages which
+			 * requires __GFP_COMP for order > 0.  All user folio
+			 * allocations set __GFP_COMP via __folio_alloc.
+			 * user_addr != USER_ADDR_NONE implies sleepable
+			 * context (user page fault).
+			 */
+			VM_WARN_ON_ONCE(order && !(gfp_flags & __GFP_COMP));
+			folio_zero_user(page_folio(page), user_addr);
+		} else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


