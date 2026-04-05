Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECCFF3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005356B00AC; Sun,  5 Apr 2026 08:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7736B00AE; Sun,  5 Apr 2026 08:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DA56B00AF; Sun,  5 Apr 2026 08:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D20F36B00AC
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A77461606A0
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:56 +0000 (UTC)
X-FDA: 84624496992.23.BBD2D0A
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id BCC811A000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MMfgEUgV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393694; a=rsa-sha256;
	cv=none;
	b=L25RtX0PNUUIfajPGk1DAqFj9cNl6ARyhhnNT7BlL1OoBY4m+Q7/ZxyUc543c2lFXg05GU
	es17tgiEcN8bE7QFzmBJ4ySZEuH5F6xRidNB84KxTbjYqbH+WX2j37S+WnhETJm9YlWrzT
	ueUjmPkguggHeCWr+gfGHIKRY3BO+Ks=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MMfgEUgV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjgvWFWYEgCOLeyYyMsHcBGvGVNPbR5pUUyMN0Stxt4=;
	b=E7UXG+d1JS4gmLNkD6w2uGIqwW/Kdyrk2ViqhZA/BWEPmJ1n3yxzPNAdJOwIOkDXdrgMtr
	QIeGM3EdHPSLYKkHXXk22NwKvmEIjoCGg6a/kjZKgdwEzXeBfwkNjUmYALdxgDpw+2ETVR
	+XGZEPTWFEcTCojswYNywYce4WpPQRA=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso1933608a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393694; x=1775998494; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjgvWFWYEgCOLeyYyMsHcBGvGVNPbR5pUUyMN0Stxt4=;
        b=MMfgEUgVmmbWKroR51WUCueL/JAb5X55Az9uzH75LsA7MuITfOckLiBITwjwywxRoN
         gkJ5PWIqqoj6KD14JBNgXYblibXN89Agfwrgu2RkwEuRgXyemp/bSP6vH8E6nJWScHNO
         ICyM5K91Ey9O97/mqd9ZmIFI4/hgXciHXQLsqMFUuikFo5luOkeaiCg0u0iuT3VRezmj
         hzjqhM2QhXjsbczIkp2W6UGrlkhtpP6bYhJihVt7jpPOvGzrbz81zajcyv9gfriG7LN2
         JyRg8xglkjF1qqGdawOPiOD4RdoFwNR/AIdd9iIJlW0IzxwQdanvcfT2iU6GnVFuObYA
         WWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393694; x=1775998494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TjgvWFWYEgCOLeyYyMsHcBGvGVNPbR5pUUyMN0Stxt4=;
        b=KIjMAc2BOfDIFYUaPVcA069CcB6fWxLR11lIWDc8GxIvAFQGyu+cRQnDhQOscIrMwn
         J1EFpaBGKWhy9BwMrj4wxBzUSr05/6M4XrWzP27hqdx6Kb6LwmQR4SNsk+GoAX5U1+G7
         7PUrc0w/q8d/aKRsFvQoAdmhUw0GBl/qFEHrcNP5the6yYE6ypPiH7q0qmxnfbH7di18
         oD6qSbEBz+5LTnAUcIfKz8MKaHnytihJlkYty+cw13uNb+yl/Sqv4rgTjUjkGewvgJnN
         XlcJd51sqCknhWcUoI4De5DVWWt+bXKXeji9FPz4viybHvXzaKb4vnDm0Ta+3Dyguq3k
         DUfw==
X-Forwarded-Encrypted: i=1; AJvYcCXDUK3fp+MuZgS+WMo2ensHi6P0hbD1vOM+WeiYt+gwopHoAMtaXM9jYewn1wjm2ARjB50qn6oaig==@kvack.org
X-Gm-Message-State: AOJu0YzUecD4hDn7ybmi9c7/fETGsbg3ylEmSZ/kOjwxNf3NkRkey/S8
	Oyx9PbDzojraPCDoOlq40v/wjI/2GWHTKP2Mu9RPlzd9hynuP6DUkSqO5IOqYTlASfQ=
X-Gm-Gg: AeBDieschbf2yidy35Mz33BhfCVfkejvTahTuGBwywqijBOxwoD5pngLJ6BpOXE3l7L
	P8DRNBtODTU6q6ACjc5K5cdiQlB7vikB/2bVByNMsa84seEknXB8HoE8wXXnvad/Rv/Gk/EI25M
	1MWigAk4SortZG9e6uNihpXV0I/nFizR+a45dw5pKHXf/BaIkvAshhWjgY+Eoeruh9Sotp+DN7o
	AYY3VSnzs2vsYWN9A1wkj5qhPmz6ulmydkoYEplRcWLWWqJ6OPiKHLl64ep1i0kMB1P8AZW/5xw
	E9OMTvWXkSlsKR9zXz0QGOu0Ek6K2lDsngpvSoEIu7bg6Vv1d6Xn3Xw/EZ5Uz29ByWabfuEIY82
	AieXIU8JS1HDuq6gmI+jwc3LEDV2ir4PViyy8/+74rb2M9wf4n22nyZuxqh08ymf03vtdFYSOxX
	/W041HVB3rnB6jd3mSqmVhMroeWkaz3CqxY+I9Hc0JMyM=
X-Received: by 2002:a17:90b:1344:b0:35b:90e7:c453 with SMTP id 98e67ed59e1d1-35de67d6677mr7866778a91.6.1775393693495;
        Sun, 05 Apr 2026 05:54:53 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:53 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 14/49] mm/cma: validate hugetlb CMA range by zone at reserve time
Date: Sun,  5 Apr 2026 20:52:05 +0800
Message-Id: <20260405125240.2558577-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCC811A000C
X-Stat-Signature: iij3be78uihs46cm7di76g8yzq8fuc6y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775393694-779557
X-HE-Meta: U2FsdGVkX1+zRRtYMIIkUpOBS6KrF36fHNVm9HgzarV7W5SVV/EyACS9PYCGOy54t2MXINetQsRex8Sxc6fgzaVxDni0CRjnwHsAPjnEjfy9ECx1ZlXRUMkmHSe88J/8zkL+gfX9tfxt3TMU/Xqazjma8LeOh2FIq7cFWqZ3fiTeQSwqQp+uHLAHLKtHAPZVGWow4+VEbh5GLYbAgzNnezPDZ61xeKpZ96CQQ7qHBlbT27xvwAZORxJg+8KMAxHazsExzyZoorj4X/R6yANOU8ZJ2jSwBLfu3q95MD1tmEKD1cJAW/ajSZX0WRtZb1Xe2lLtAHWAlXYfiEWclpRN3iry0rXfdyIEUn8IH+8lRXUlQPV3GiZTWj7Scq7AnRkioPxu0hCPW7iJGNfo7tDu9pgyPnkGX/9nRZNx5yNSxihnzQ4SiADnobFzCfcIquClIutPQ9ZDvVH2tAnEx/bhR1uk/7eaT/IgMn/sZJ/MI15T1I713PvwJXpCR0tPPDTENMaTccd7zym/2Yrbkpc7ZjxfSYnTV9nt7O4naiaUKQwds1lCiCh8xli7PTPRcUXmuSTIQ0jTrH9hfjwbsz37O9gLuixDEK6BM3ZtEuvyhCUpaeyRw1gl137Z4i6y6ND9r2CDAjeric5aixKAzrOZ2Vf3CTRDE+nVWJR1EFu1ZF8XZWSif9uSGOq9pJ25jW2gwIX+XkzmpBFHA0zTv/UYTAkAapwS7qFoA9uEDmMKgnD2GyX+Nax+l6720kWT5aS8oVydwt9vnJ1MqdvwOiUVlzYmGl7tQvsgQ+mcyI+2z75lwi5G933faDQCi5OX6MoFm9HAc/+4WbTFM5fjO2R6Mg0miSMc2PYy9hEFmssAnYbm4ntJ/NE/MguAoYtotjWyFyK1Q4MCv8QD1wPE38+qhVrQuPguwmqka3uKThKK80OBei6udH+A1Ja430ZLHp/tyZeCvzk2LGMEl5epkas
 /DnfJpeL
 Xcg7OuvW+0VUB9VSKumxnyHFXoKfWMemxxNS4IVYAXq8Ii45qDcBfqzWY74WQoo0DHC1+XyJ8uyucEUmiGmxpPFoS2LSplu3HTzGyJh6JbX3tGYwo/+yY06NaTT/HtkuhdBmuUDkguQGQy22Blkc9gXqqeWoftTNcX0hkCI/5Gfdp/IzvYZ2RyC+swBoiemi+us/NcI+FiHWAhQMAdsDlCaJyc/ceFNBmNm93v+sunelOvnbqNA1AJbuq+UClArCwYFT8SrbzYMm7++9ibeHM0hp4WRH9xK/1RdgkUOah4DRcbFvT/+TiGqdCDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During hugetlb_cma_reserve() we already have access to zone information, so we
can validate that the reserved CMA range does not span multiple zones.

Doing this check up front allows future hugetlb allocations from CMA to assume
zone-valid CMA areas, avoiding additional validity checks and potential
fallback/rollback paths, greatly simplifying the code.

The pfn_valid() check is removed from cma_validate_zones() because mem_section is
not initialized at that stage and it can trigger false warnings; keep the
sanity check in cma_activate_area() instead. This is preparatory work for the
follow-up simplification.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c         | 3 ++-
 mm/hugetlb_cma.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 15cc0ae76c8e..dd046a23f467 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -125,7 +125,6 @@ bool cma_validate_zones(struct cma *cma)
 		 * to be in the same zone. Simplify by forcing the entire
 		 * CMA resv range to be in the same zone.
 		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
 		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
 			set_bit(CMA_ZONES_INVALID, &cma->flags);
 			return false;
@@ -164,6 +163,8 @@ static void __init cma_activate_area(struct cma *cma)
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
 		}
 
+		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
+
 		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f83ae4998990..b068e9bf6537 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -233,9 +233,10 @@ void __init hugetlb_cma_reserve(void)
 		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
-		if (res) {
+		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
 				res, nid);
+			hugetlb_cma[nid] = NULL;
 			continue;
 		}
 
-- 
2.20.1


