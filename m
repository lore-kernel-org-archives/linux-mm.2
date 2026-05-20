Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFD8CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F776B00B2; Wed, 20 May 2026 18:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F75F6B00B4; Wed, 20 May 2026 18:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DDB6B00B5; Wed, 20 May 2026 18:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E156B6B00B2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA9F8140444
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:06 +0000 (UTC)
X-FDA: 84789222252.16.55AC43D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DF9914000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W+ILEl2u;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxMX/pzMUOtdSR/DFO8X8z+nr68xKXZK5hfRbiRHySU=;
	b=MLh1ttxYz7L2W7aiMTh0/baxePR81z+5+ygNjhFUSKu8S2wlIwR1Fh0w8MwUaG1YOBoTkU
	eSG+jeWp2M6fOJZiGC4vDG/KHkF6pCJGx3L3Vwwn2PAwRYK16klz0eQv0K590IetjXZBWZ
	XHw37I0MH6pb9x8R026u9zwKYBUMQEw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W+ILEl2u;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315724; a=rsa-sha256;
	cv=none;
	b=eyZOnINZuQOtvWY5t/arU2cX5b2fpNF1PcQV8/jF5zC1KXmY+4Y+Oxj7PB6G9IbE3takwT
	Qup4uKFleNbWQM3/WQ3q4nGBxF8116ABNmBkAAmCdOmenfNJ4igTXk3d65XfYlrxjdNuKR
	xcJ1huJmeBhNh0Bwwo1bNwqRVQsj4i0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JxMX/pzMUOtdSR/DFO8X8z+nr68xKXZK5hfRbiRHySU=;
	b=W+ILEl2ulzPhjK7foQAj8tW4hyPNAEqLkhcYogkhdnk0TtRGWaOoLfD3hf2UA7hYI2/wYK
	FHiQYaXHrL4Edc2knaFdMWsnZy8e+8lucnU4ar1Z2A0CiA9fYwwBqZuGS0QMFgPNEXS08R
	Dj/7KNKXPXxZOyx4Y1xNgQx9wxH5fDI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-BI7Xi1eSOA6vYDnRluoVXw-1; Wed, 20 May 2026 18:22:02 -0400
X-MC-Unique: BI7Xi1eSOA6vYDnRluoVXw-1
X-Mimecast-MFC-AGG-ID: BI7Xi1eSOA6vYDnRluoVXw_1779315721
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4497a0e3acaso5150011f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315721; x=1779920521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JxMX/pzMUOtdSR/DFO8X8z+nr68xKXZK5hfRbiRHySU=;
        b=D3l6e75neofAJmtvie5rOO2bBLNkPWNfQ7RQPvb4WOQPXap69nwXWb7WKyg/tg3b8C
         1V6T0KJZXoXpShji9YvdUUazo1CnUzc58XeUNfzpheKl4lCjm6xix5BSdanhFb4V0fP4
         skv5zdhqbtOySNGy7Li2pvV079Gz/P2XVL7DWBiF6/mn0Q4KQoQD/flU7bBiiSNKX8Ht
         4Dr855ypsjcP/gEfFn4FeAQ1GC0cN1f3INp5IXenDhZYcAudQLOsxP2WmaUWvpmIb3hw
         PdidPWz6VnBT9KT3kgIp5XDB/C53qa2xH2xvxC5267h8EK09iLD5uFoBjvYwTuW715gJ
         uGNg==
X-Forwarded-Encrypted: i=1; AFNElJ+zzrSb5s+FxTnjBa+FJuzmgCovZb9qU4Var4ZV++ZaDyMoksSrbSQb6hwTg1Q1sl3pS0ddVeNprw==@kvack.org
X-Gm-Message-State: AOJu0YwvwMv/pyapKptSdelcOAwKSFVwmR6ANRIMuatp9YHdgH8HENXx
	Dj8CCCpO3uSF4YqCkzw1k/GDsFXsxgsHyQsOjjHTDqHvkGwz7ek6YbfWVwAYEUin6mETRP5we45
	dG6UqpXmgrindgA9ejA52gC9aR7nE31n6ouV6WmdbuLbDrrlkS0kn
X-Gm-Gg: Acq92OE5vRQig6Tvv/rl6h+MLArA+FHZB23rHNOkMdlgewdXVqrhcKqmmrIOf00HQkL
	hlFl0xIGce+Fc3T/lVpJ/23GaM7YobXpzIQUvWMvw/j0X2dNHftAVWRLLJIQ9weW61zpbmf37QW
	aKRHdQxAeqKAzAVlDJbowvT/C6n9U0/tzb0r4OZznzjLM9QC3UoizS5Amz8Uf6jsy7erdVy+Xug
	7876OS1JaHUtgMH3UyPtnjHYTkFySabZW00cvd8LMdagS29HGu6ZOaSRx6W1ORk1UodHl+7eWwY
	31Rnmy4arCa+ZIYRNd1/ZBN/LckegikqppL+OM5GVWUXqBP66a95jfwx/TVgz9MVpLuHn1vJS9Z
	U5IIyGMQHv79T/GG7DceP5Bfz/WgBDHWpeNPvGUQyG70=
X-Received: by 2002:a05:6000:2f88:b0:45e:878b:6c36 with SMTP id ffacd0b85a97d-45ea3ce5a81mr251938f8f.35.1779315721192;
        Wed, 20 May 2026 15:22:01 -0700 (PDT)
X-Received: by 2002:a05:6000:2f88:b0:45e:878b:6c36 with SMTP id ffacd0b85a97d-45ea3ce5a81mr251868f8f.35.1779315720651;
        Wed, 20 May 2026 15:22:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a178adsm60809630f8f.18.2026.05.20.15.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:00 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:55 -0400
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
Subject: [PATCH v8 17/37] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <e1cd6cf31498f273a06a8899c737f514874d0402.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GLKSvIqqQ9oiNLtLI-wergDQ3_XmrRQ__f_YdRSLpfQ_1779315721
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 6k5kphhpfbng3mk71ubmxxxoxm3zxycz
X-Rspamd-Queue-Id: 6DF9914000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779315724-144516
X-HE-Meta: U2FsdGVkX19dSq7HWQyEPEOPyyt7XrAEcB/CZzld00j/7y1ascUc055mBFQ/FBIt1b2UDWxoi7XGWDXOKLuYF06TJS/z8CHufCbtS9Pr2U6v5YcTIldJ6krc8fLOLkAlI2L7JHNqjQgnPaIVe5dIdFIAdk7XgvDlJPf2HORKhwHTKBaIAcMnVU2v2oznP85s+Wez+0pogcalyN1lMa19mxLpPVzpfwru6LI2dZAMODTVvtPy07YNJqIifEX4PW08aEC/dzcYLrN20TPuR1b6IdwFADQu159bWZpPOTSpb6ep6YQc88wpfNLRyvK8JvaisYIjaZlzOIwqRZaFo7pLBYI5rcI0jAofnwiL9mSibC5j66IldPnY1As98J6BRo5iLxZNXD/TpeeghkYot1gsumB/EuwhNIxsYo+XMVuOJo3KQ4YOawSsTtZtEAXw4PfrGe6IqtLsBl8BKHkj7X8mRUupU5nsiKJorcA1gxoeAIrLv+E38Q522QZqz6PHnEIk49BMLVlY/L0ucrlwbPy8AlAFOsXzcn5k0uEHAA5TcsIiW+Ff2EV9ggg1sWmnmefifFmL2aOI7dWGlyX1lfyHijY4MZtUd7fQDqo4nXffG5QmfzWr5qb795TLVrDtaq/RM2dVcd6r2K1tt996wYeMYcEC2MTz44On9O5HTKZkMyrNg4+KqcERhCbjBvYOmuoHlL6JGW9rIxGC5CKzVby9vNN04qh2/tzecjb5k/rXlF31VogWiroOJ/OBXEys+R/Vi7FA44mDG4Z+Gwxha/uo2abJx405DA2I/oYOW0kJ+0t2I/98+IYptqMT4fgEcup1fAuy4VehoTYOW1El3SFhRNsmTL7ywpKsxtMO36rBkWjU/08mya6QY9XkvbGYq+jAYcL7RpjU66YF+MMgU6yync437+OijROP5c3v1MDG5/cw/aSSEgTFOMmw8TtHdMyu9Db+FcJaoJ+o3Vukryq
 2aIUJIeh
 qdFXp0iHqpIfFaJGxsjkNZWuHjHfZ6NZbYdz9Qdl2gcQmWYXo9utyrgMuFW2Y7h8V0PI/gSbX/e8DpkNgXs+AlEBnthAzXxLNwJKfVLF7mOHj66Qi0Th3L4H2hh1uu8e8S5QyMYAXmZqpI6jLa7Az2YmIXrXXoLxTX/x2q/q8F//O6lEUZA/IrpjOE+MgsrsmXpckOJYbKTSJ+ANa3A0HqhC93fNN3PeJz8CWVWqUeEXo5TBmIKzCYRls7VvDban3/q0xTY3hATzEXX1fs6A2t7pFBfQ1T3YQhMzz2iW7kek8PlL2sYBmkrFybbDi/Izpz1NNOUEQkHRo3b4i5yXurxkvim/kQAW2vLFFXBE9BuDrejPcmNAFwT80Vp0jIAhFPHt3Ekws4iGDThtTlgmk+sXwX6HsKVygOuWuv8mUsmEiVxZR6NjTwZhRNlMyYrqCIS/o3puBOGMVkQBOowEBO9nS2tXFAh7voGKWsbLihTIBDkiKglwUDrFrPbrCOUmFX/8SXF47i7F2S8jtA5tk737MaP7LYv1FQqjX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge().  If the charge fails, the zeroing work is
wasted.  Previously zeroing was done after a successful charge.
This is inherent to moving zeroing into the allocator.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index adc228fe3578..895ac72121fe 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5249,7 +5249,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
@@ -5259,15 +5259,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


