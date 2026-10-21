Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704E7606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=gWuGcGby
Received: by kanga.kvack.org (Postfix)
	id 675476B05B3; Tue, 20 Oct 2026 22:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CF66B05B4; Tue, 20 Oct 2026 22:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AD06B05B5; Tue, 20 Oct 2026 22:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 501516B05B3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:40:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D7DA40464
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:59 +0000 (UTC)
X-FDA: 85345078518.12.69A6FAB
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id D85B7160003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gWuGcGby;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pvfl7DviDeBHS//72/Hi95KkgY+0Xu5/rbujyfFHLK0=;
	b=agCfMJo321maw4QfEmauyox6eXv6hQ9bNARmZrsZvWdYgaG6NSkQk0kDsNe0tW8NZX/ncW
	5FHF05WTzal5g0ontN2kKdgAwpNHK8XgfQ7kZUX0r7hXN92aCTQTJgxZyiFQUk8Lh0zVCl
	GkZKqjwy9dWoYmED0v4OdKhqLz7GPic=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gWuGcGby;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550397;
	b=j97jBmf+IUErtgcgnXHNwgSkZlN5PYkwWOKjiqVy4j2DU97bDtlXP+cit021IRvG876jjc
	LaLrmdK/zG0eo2lpWzNs7ayjrWt1dGrA5umv+o36Xb5WuJqCq+BwFCVOpPodYryqGFwwe0
	Rj+dURZSVLk/XXZ7NUae+aXmx8g+xoo=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-9196d8543cbso2198876d6.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550397; x=1793155197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pvfl7DviDeBHS//72/Hi95KkgY+0Xu5/rbujyfFHLK0=;
        b=gWuGcGbys2J/KTbxh+XGyVdmexYSL5fkCNtCttUXRWAj5UOeD9BMYMKUR0ZhW/bj7o
         6LvmGmn5BWxI6zvFVLoaBHNxari8twuQ4ZbTaqffPMzENDBuFd2eYdpJIbD8llQIidOB
         /0mrnsu4BKlTXMwZPYIqP2NXIPyw+6GI3oRUAwKNW4p0HUWkROrf/Wsx/lLPfpBzlnAq
         ac0FgDeq+9j88p5v+kUPek8mmP0JHAduo6EIr0fgQGY4+NueG45lmy4U0q/5EJLwKasO
         yKlZ/pohYUBbo0h9Z33BHEaUVKh2Gzw8T0s1z5VUCATXt3zVdauBgZRN/oZS1kNPk/l1
         kPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550397; x=1793155197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pvfl7DviDeBHS//72/Hi95KkgY+0Xu5/rbujyfFHLK0=;
        b=e+JocYjJmakoos0A3s8bx6nJyBae5wzhMvUzTGmV8dKETUIhgXol3XQ8x5rxEOtNLs
         SKnZcRDYQ3D/BSVm3LE1Qj+7jW1qr5PYM2cAqUQ/QXLMYmRAoSnT4xGZJ1znKfjPPA1S
         6u/QoFDVroWbQNquFU4uMrj6vQIEKTSvLN2WzOvilTnBcUtZRvjIKNnQDm0ph21J7WWB
         U6f0RdDDyYKFlhQd8CWXmtuV34tZxhII6N8px+NDFHHlua5qva/ACwvUn85+jwkd0ZIh
         MFauRBQyDPPz6adghV9pdkPqTZIgGII/KL66hNA+ouFqfOL+FV6flj04OKHPl/N3FSGC
         tAcA==
X-Gm-Message-State: AFq9FYIivIdYUz0Cn51YjkZi3LPEDsNnOJx5hxYgjoZuEWzTH5CNrULd
	rZf63uQoWHoMEb7S0kz3XYw7Lfbtv8dp1DWhs/hurCyxwa9CqI9YysrnwrElatWWqdHO1OaJ+Q/
	OuZCi
X-Gm-Gg: AYBFou2q/JY+NV3OC/5ytcuYnXTyu74X5yz6DEwTS4/92YNVFJvF5CN86iSLrhkxrN4
	BK5ad0z1E5hTgMAgxDWfDqGSuHq2Up2yP3ftQVEFCaVbPDZoO/qJ6+dK4nur0bP5eZBXGKNE+4R
	rX6s9F0PS9+fJ3jUOSp3cW8DW6kAehERqIjGmNBpuCm1MU159evIHhSL6OKrXjmb9IotDXmMtAk
	uHGgbXWfr4mO30Zmkp0720gOURc6BG3SduMjTqdJSEF7tVST6k1TaJxiGk5Jrj4baMR+esfskbh
	n5zGe9+O3k0XAaX3emhdQJs0j10kjYLdzGGTv0u23059WnKooApNcuVHu6xfCegpqc6Q4WHWehh
	TxjDZJspicRazcxZzrM8i9dK0AeLfTP17XdHOfteolt9hrbhxkgwdMDQcgF8TfXBKfQtgdJ+xsS
	XfvPcJgJThmBvPTXWB/fN4X9UtdbhABeQ/NWxUKYxz5bUW/MAgX2vDPdpeti1l1Wdu7aFhh5HoE
	4qOiiYgcyryiF9Gs1pKxwXdBzTLAHUDC59n+dNfJ2CyW2SeB+8bPJNFUFDFJNpgtgBEwl+ahRb+
	Eqha5ANHPmP7KMmB92uCiz5WNpsQIy9/WtTyhCkv66FCmWdLU8XO6wxqWbO51hQ=
X-Received: by 2002:a05:6214:300c:b0:915:eacb:cb90 with SMTP id 6a1803df08f44-91c12dfef37mr14292296d6.5.1792550397043;
        Tue, 20 Oct 2026 19:39:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:56 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 7/8] mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
Date: Tue, 20 Oct 2026 22:39:39 -0400
Message-ID: <20261021023940.1940971-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D85B7160003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qwwui4qb1cbxs1hojmhizof7wcc33r1e
X-HE-Tag: 1792550397-608415
X-HE-Meta: U2FsdGVkX19C3rV3Hz8oqAhXQu/J9O+X4T/PrA+PqGj9FcU9RwaujgWOXHylse9fZBsS2lyWL8koAQ6oiHRln5OLcjbger7DehG8veZo53Ov+mmdrBctGWSk+y/SwGZoLm808vOWXTWzPeA8dKKOw+DH8VxSA9+u/Db6ZK+o/yGwCvbsGfYl/ns11WsnZ3JDAO/ftDlhn2KsYq7+jKnSJMdwGpjVm+JnSmVyiK+ZX9ibfRiTfns6J9ybzioAgfYk+sNRPK/lHAuijeeBjAIxd7C9SJ6VP3KA8qi7WoNpMIP0UugY4irwAsFjqjq8fHCFY0eG+i1jxEuB9TmSARoso+9Vy3lurCWkQll+okBAGpBS0PnZIJg3lfYUAFpmM6ZpMfY/kYXoz5sEvXs0/pIrvimUOaM9fvwPoz9PnFkhmf7z7H4QP8GSiLROordf+TOT9vYP1maYMpX3XUpHXI6F/FLmNaM5K+MtQrS7vH6SdJ3QhZxcREE9TcEr5DWHKaPZbq33Wc3hxiuROkr3wvbQ9Co7WQzWxElqGwaZcAC7WhVL+xhMrueToTNIt4jYAcUCcKjPWTmt6cnErS/o3TZZq8H8llNB1JKiSplu4qPMNAM4s1HIFhJpMRg75U+qxeUtwQsIrxSsnK5AWntIXtQ3VXKonrCvas5uvW0NLm+NKMBeGASuuOF+NygTn4XlNlIrFPhEZQSffPAW006w7rABab1GyJf0G2RFIxzGBa0re+N6gqbJT8yHN5IStclEVedyBFADT96eAXiET/49yZcu8Bk3o+WBl5dfVWIYUuAhOZ1OSA9NPc9HZcpO8m3FSnkfHCYxp/VpIBbeRsKONrcuD0G8kPXL+C1D4iWrkALbn1xCj9cZxpz7aF4fctL5MMA3cZbY0jSecK3wi6EHJXLQ7zXR5mUIJJ1tDKUrwGS2fu4PSrg9UziWa1L+kuQyM06bSAs/nMZe9A+uul48PCv
 nzJE1jmp
 Vhubwj6c+MlUX9dv66rtDqd7QHI7xWe03Aha2ZSNPr+QWOWn9N1s2Ie9/xylkObEMi/07ok5+mrJQrDYQYXCusHEq8i9dRvINu6QbQyXkn6lsl9c65qBlbU3P7OmUI08N4x/o0NspsDBEgp1/AgoBdg8d7kqAymZ2LA41n5ygBdgWADvgdih9LreofgNHNnwfRO/r+nRTl4i+nuN11SeNWStwal5koGLOx5lNuT6DE4+maZbhmVh20UPvZ/1CKuUp3/i4Yrk1NQ5cokMo1RZf0rzU5xQVDoGx6cthkEc+0sRStbLNep47NVVvKHmB9n6H2vfn0meiE9RFuus4irWIIXnkaML07MLU0OAAMvj+YX/tI11tqdqXiaodjb/zzVLH1cIoUep1iGzyoQktKIFBgR81brTxgnJhHhMaFtirMv84PF0t+smczl0ye/KH2PtuS8GsJqfvMr/M2ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone. alloc_contig_pages() can then
take a range from a zone or node its filters rejected.

Writing 1 to a node's 1G nr_hugepages while that node's first
ZONE_MOVABLE block comes online puts the gigantic page in ZONE_MOVABLE,
which commit 79b63f12abcb ("mm, hugetlb: do not allocate non-migrateable
gigantic pages from movable zones") excludes.

alloc_contig_frozen_pages_noprof() walks the zonelist with the caller's
gfp and nodemask, and the iterator approves a slot before the walk loads
the zone from it:

  CPU 0                             CPU 1
  alloc_contig_frozen_pages_noprof(GFP_HIGHUSER | __GFP_THISNODE)
    slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1]
                                        -> [MOVABLE1, NORMAL1]
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */
    alloc_contig_frozen_range(MOVABLE1 pfns)

Check zonelist_update_seq before using each zone the walk returns, and
on the way out with nothing found, and restart the walk if it changed,
as the hugetlb pool walk does.

With kprobes holding the walk across the online, the base kernel put the
1G page in ZONE_MOVABLE in 3 of 3 runs, and this change put it in
ZONE_NORMAL in 3 of 3.

Calling alloc_contig_pages() directly, GFP_KERNEL with nodemask {1} got
a ZONE_MOVABLE range and nodemask {2} a node 1 range in 3 of 3 runs
each, and neither did with this change.

Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5ca8e57c5fcbf..96ae09c8099be 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7592,6 +7592,7 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
+	unsigned int zonelist_cookie;
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
@@ -7600,8 +7601,13 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 
 retry:
 	zonelist = node_zonelist(nid, gfp_mask);
+	zonelist_cookie = zonelist_iter_begin();
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
+		/* A rebuild may have shifted an ineligible zone into this slot. */
+		if (unlikely(check_retry_zonelist(zonelist_cookie)))
+			goto retry;
+
 		spin_lock_irqsave(&zone->lock, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
@@ -7640,6 +7646,8 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 		skip_hugetlb = false;
 		goto retry;
 	}
+	if (unlikely(check_retry_zonelist(zonelist_cookie)))
+		goto retry;
 	return NULL;
 }
 EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
-- 
2.53.0-Meta


