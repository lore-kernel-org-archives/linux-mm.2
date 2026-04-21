Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DCCF94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D440F6B00A3; Tue, 21 Apr 2026 18:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A9F6B0005; Tue, 21 Apr 2026 18:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A506B00A5; Tue, 21 Apr 2026 18:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF9846B00A3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80BD2160AF4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:58 +0000 (UTC)
X-FDA: 84683936316.20.07C8664
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 408A640006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jz9PhPsM;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXNCfNPQyocyWkSCOxjnq/WqPhuX3fxPK4FCFhhbcx8=;
	b=pg1nOPg5nWElXetbTVWk/LgFnEMQmRL6dh8Qd4PcBEjy7jaeXMn0k2TkVhDSkUFwCH1Icj
	jMj7qOTjwtot/gS3M6Yk6kLNHdw6C2ykCwriFpkSavCW9AxsTy1j9uf9y/AmC2YkmJ6WNZ
	1BrmSnDOuZx59MRjX8fHe8Uj0Mnh/2w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jz9PhPsM;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808916; a=rsa-sha256;
	cv=none;
	b=sPHBT45IDJ2EHlfl5+6rRswZUYOlYIPjTSDQU0kc4FGvvcUBbCUzT29RvF8iz4GZWDgmrr
	ZvSDXv+5dmKL3Qk4FNhfYZtyt3PvRMisIHSmkAgji3EjGMl/LPLwFHj5pZ2LUA20VwdWYl
	v4yvM9hBEXV/SGmV3KzBDO58zq+bKPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iXNCfNPQyocyWkSCOxjnq/WqPhuX3fxPK4FCFhhbcx8=;
	b=Jz9PhPsM9gOgMvBHlFx4KSWEUbp13QBKx7u5ZOp7hoFSh+cEHhJTwXsQ600XsQOoMMvfKb
	AgW22NsqkwU4sgMEXqCxeFG4IleoKbZWpZma7Skf16MqHd6NBU5kZ4MjxTdQsTIw+5wCp2
	g4m4nG3oHttL34Q3EVXtaIkuJttQZ64=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-PGV6V4xNNNest68ImHJo9w-1; Tue, 21 Apr 2026 18:01:51 -0400
X-MC-Unique: PGV6V4xNNNest68ImHJo9w-1
X-Mimecast-MFC-AGG-ID: PGV6V4xNNNest68ImHJo9w_1776808911
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso3928505f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808911; x=1777413711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXNCfNPQyocyWkSCOxjnq/WqPhuX3fxPK4FCFhhbcx8=;
        b=cV84NK3UDTP0wXa4XZH/Tt1g3k1vU+i+Xn3JdqsD/fTxB6ztxKCLLuNP+gqhDbaOPf
         ykg+7OoN8BpfRJTJFC4SRBiYrpewwBGxZo+WNFYxVK0p5XPSY6ZwyG2DINta8A2Tk85m
         crcxv2Qerw0y0YyS0e2sWxoYDteJ4sn3931QRYzukBFWIOOrMFMbmbrJ729AHUJllGr9
         Es2AQnZu50nOXt5gFoKabj59INm0UuQBlqoTRIPMGfn4NJLVcZYM0PKSjPgYAFWYq0e2
         eSIeMXqpziz5MoW7p1QvQiTunCp+v+fYPgLvVQuRIm1IIxIC27I9QCqvQftTGKOxGGSw
         Ybgg==
X-Forwarded-Encrypted: i=1; AFNElJ9AohcZK2Wx4bwLYETUI2E+sqgU8EfR49rbvQFOLjOldPLLEO+BxJ/jsY4tfvYXOMIIVt4fSm3/Aw==@kvack.org
X-Gm-Message-State: AOJu0YzjNEmouK90wfKRCTygtgEQej4DlABO1ejgZVlx0ifrV4pB8WAN
	8yfPoUH+IdaH2fOJNmiQGnFFj4ohoCRyZQCYqSm3RgO6eXr4Lim9kPSpUFj11R8x62ZQVtHHYfJ
	85OZ8bO049G5HquuBSAZ8ST3q71GE2XCczgUeGUe5Ad/VlbZPJbwW
X-Gm-Gg: AeBDievnYL+hJ5yS0BR7QazxGoXU2UV3Od9TwdJt14XW2maCLW622DWLKKpmCANLhvH
	SPY2A3uLz1K7XVgPa5DwI3t+za4TbPDpW2mP6Ea0V68SgJUNDuHTkrXDbvCVevbm59VAUijJKoO
	wWtsPSvaIyebMAWMrlpr5QCESCZOp4d3HQValkvbnxg0MFwz3sgQKKps+4RRKzFnRcZuXy29nqs
	waZ1we4KwqrYcrFYHzfdwjF54gIEreT3HRKZj6NWQXIrTwz6y+pQUPRl2x8LEdbTFo4tfLeBmrN
	UvozibMjnmy7ayZJKu1B+f+a3488jY7fRdL458jdwU8sJ/94bnUs0OA/Rsn+1lR4+XRJ1SD8UTe
	5EDL8XlLbs8Cxlv0W5ceX6erUN1I5WZkHUTdoz8yJnL/zyn/TJScIsw==
X-Received: by 2002:a05:6000:2481:b0:43d:77a8:3bb6 with SMTP id ffacd0b85a97d-43fe3e239d9mr31452780f8f.47.1776808910671;
        Tue, 21 Apr 2026 15:01:50 -0700 (PDT)
X-Received: by 2002:a05:6000:2481:b0:43d:77a8:3bb6 with SMTP id ffacd0b85a97d-43fe3e239d9mr31452682f8f.47.1776808909583;
        Tue, 21 Apr 2026 15:01:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc375dsm36898455f8f.14.2026.04.21.15.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:48 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v3 11/19] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <7d1337e364980896be012ab34fd26bb3bf82c7af.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IuvVS2SXFh2ohZAZr0Mfd6dfdVZTzJgCayB4BsIl6uA_1776808911
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 408A640006
X-Stat-Signature: 6p7qor8f4m8ojn9e36asgu6kzqsrhws5
X-Rspam-User: 
X-HE-Tag: 1776808916-582144
X-HE-Meta: U2FsdGVkX19CiR1ufEF8QJiD04JLuqDBQQ88cFyaxirqn2/GtXpB4dC9RroX+ek1kKZ1cntMhQEYuSt6kV9FsumPilr6aQIPMHUwduBYZ0Yr9vNSPTNJ9TO/EVHW/UGC39uYZN/oFbPgIJVdQaX8Rur1PQe/s3nUN5rsjTyZsIEKFgbagmts18tAYa1BP49ydXFoABfZnscScjKddPEbYEMVzCkipxLYfvOUM4Hlys/jzaPygNQJRQBROL00jkYDUZDyPLIgj8GBX9G0oQTAhw+B0p2Li/eRFYpzfL8JYP2Q1txYBRrhBFyi9VTLJvUqmTRCD7DwIzQFsRRvZquDogl5uaLdkNe4Wm49CMz0zv+rKVJaVT4r7j/tNIIichEWLCqOrS898YvBSvAkJzxPnz0MGQqblouhMC4Rn3lJTv3bF96pLM9zt1S7H/pHeJ35igIguEbel+R+GWldwUoonV6Xvsx2YbRSWTsC4errBrMLo0iiVj1pQJ8CZhY9PdlE22GAHt77VN87JpBTjyMeBnZ9Cl4uPQA0aq2SWRl13fBOla4t9JB/P7ije8VLXPMy4VN18mV2loiGMqAjeH4caUC+Av9xlYhl1g9nUDxsZp1Vs2YztXXpFpILeNkTmldl/pitvOWTL0TKBT42mlfx0aVSQ6i8rAXi7ewhzGiZFhs1SNa4PJCF/aOzCLUvAsyAL9/eIPtZcUQqTlfda9J+6Ugp6z1mMEEjlm4xlJzAUw2jNqzz+IqyTtgpkeqVVnDrbLTmUeAxjuKGVjTjVAlX/3iv22etE6Z+MlsG/z08cVLIaMbHKe+wjeelpUegxsL6lCys+qZ7w4NNF8TnABduhSaKMevSaOWKYsAzV+5Tlp6L+BBhSZjgnDd12zazKHwZg9wGjSOVXDBWkd9zOyN7cqTCiUJavnNuHVxJe+VwpFK5hi7x7BzwCFRfphpu5COnOt83mszY1PMtaqkatco
 F+XN8IZI
 c+erfpIWAjdE8jezjYyh41Hdn+AxKKwtwzWbDDhOcANuq+FjwnvqcNmh/e4fG2h6ElHk2xIQotN008Pj9QgGG7llXxXN7Va82R4lNHuowxhY3/HBDcgzl2+c93HR2YCv9jpIbS+UTd8stQBuELbbFGsUQWjGPKRtBrRteuC+/PCnA0KaRxQ3Mgfk2TbHSQF6vXMEsTk+Cjmd3cZt5TwLMgt6OzeSxvvAGb8TkbJrI9Dlx88A5ynh4NZIQGXSZwo2cv3V0EelehRnMvOtE2e8VOG2wM9IAeG5eJsO2rNjxTKX0XS+cWENt7i94aBdgA5+oMEuHWrgqySmgVuOqLfdoK9kB6Sg9obasywtkm37Mi4wf1htDdKxVZwNjWB6YVAZo3ZLN7NMXsUNrmPm9w1+AkGhIhRrhCFSjZPrA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

Propagate the PageReported flag to sub-pages during expand() so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index db2192ffc27c..211e9e32b91d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2334,7 +2344,8 @@ try_to_claim_block(struct zone *zone, struct page *page,
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  false);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


