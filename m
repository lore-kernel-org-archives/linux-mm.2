Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29DBAF55434
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 00:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D396B0088; Tue, 24 Feb 2026 19:24:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837666B0089; Tue, 24 Feb 2026 19:24:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DBE6B008A; Tue, 24 Feb 2026 19:24:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 608816B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:24:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16FA55876C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:24:44 +0000 (UTC)
X-FDA: 84481083288.01.CAA8426
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F196100009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:24:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vGyrsHEs;
	spf=pass (imf14.hostedemail.com: domain of 3SEGeaQ0KCJc1O5CI1JDLJJ5E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--axelrasmussen.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3SEGeaQ0KCJc1O5CI1JDLJJ5E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--axelrasmussen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771979082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y6p6m2t6gYC4KUM+VAX+tvTTd08UPZbYNt8kHVfP8DA=;
	b=yW42H1Ll7dsKCI10PjPkS073vJkyRtJAoSplf/c2uvppB1tDgmH1GypNdpAV9pAhT1FMbE
	uyA0bbQhKYMqxjylJv0mcohveffC7WftiQ57Y9wnDdfJhFpfz9MZ2pg95T5wAtRy9hiIp4
	Y4HBbdtcxVLOO/C5D1Gw5rgHAXxdOlU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771979082; a=rsa-sha256;
	cv=none;
	b=VFCBTr1DDQ5R2T5FvFNwZgtsoQaiPZE5H9DppVOGXBQYDeROYdWJiAyP7uOGwWa4VX1oky
	fddR5T7pEAB2qDMt2UjrpWMJuqhkLeAyoN2lX6nWcxffbI43l4HY8Dpf7Ipq8EZpB5fxDn
	Uxyg95P7b1A3Rjmmc8DJMHkSB/ovF08=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vGyrsHEs;
	spf=pass (imf14.hostedemail.com: domain of 3SEGeaQ0KCJc1O5CI1JDLJJ5E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--axelrasmussen.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3SEGeaQ0KCJc1O5CI1JDLJJ5E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--axelrasmussen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12733e595e5so6228995c88.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771979081; x=1772583881; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y6p6m2t6gYC4KUM+VAX+tvTTd08UPZbYNt8kHVfP8DA=;
        b=vGyrsHEsWw5QNHKc6EsngpzDJv6+2i2GVITcNRlssKcUv4/h0h7tPjUtol81Rn5iUg
         SG/nPYsYcYEh9mte6cW0wAS+A3HcMQ1Xfi1yvYyqxdPnH1nMN8/D9QAYt6lu7V1xnM+3
         fMdyBBbw/HRWfB6fhPJGyQCmagG28ij7rP1Whj+MTvA9UoQSgG+Qy3//r/jVA/NqLzmQ
         DGsuqIRL/4KYpQ2wADLH4l529Bmen6X3+YMhxQ3Z7hprEUEGtJ/q6ZKClrhIIuAN6UgX
         4fRxoWbS8f79OZ9N+KADgzX7a/+gtWLhKJPhQbLPRGtDbt2fwGexKB3bn0G8vLGZIHTT
         0BpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771979081; x=1772583881;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y6p6m2t6gYC4KUM+VAX+tvTTd08UPZbYNt8kHVfP8DA=;
        b=WuY5a9+USZm5G0ChvBnflp+J3WkXEgncYffDi3hAJ9rd5MyrNeI8Z+IRd9NdImSf2w
         SkBQ2/D6rbsEGikEPGqRQehuCLn2ZhYUlsyqnzeKcbcCcEFaJY4ZBhp+XDxiYGyGwXqJ
         jUTyG5ONLU5tlMKZSgRMCwPX79VxcfycaEuy5M9ghZcAoo7pvG2uDQ8/0ajWxtXRMncg
         tGw5+sKu7HXI4Ql0HCRUSrhDlxfBGL1lXF92E6dy8I44WMccbVA4DCgkZHmaRnFHJbDa
         ucpMJTzWCdJsH2VcocAmfOmngym9zqEwUvtyLPsyQA3T4AJ2ls5Yqai2Ep3wSivf4wx+
         HqCw==
X-Gm-Message-State: AOJu0YxrFPcLz5k0E+MfNjmMorFH/ckmJR9gwUEHNQEZaF/U7aSBhgWq
	zUZIBYjMfnRERr+acDqnGVRrCZRF4Cs9rJtaHuF9wBCo2EZzKMJPI2hOfgoW33EBEO9fWO35MTT
	7Lpak1D+krhIidi4wobE944hn4z8eweQDtA==
X-Received: from dlbsn11.prod.google.com ([2002:a05:7022:b90b:b0:127:365a:84c7])
 (user=axelrasmussen job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2521:b0:11b:99a2:9082 with SMTP id a92af1059eb24-12781dd78c8mr205452c88.15.1771979080917;
 Tue, 24 Feb 2026 16:24:40 -0800 (PST)
Date: Tue, 24 Feb 2026 16:24:34 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225002434.2953895-1-axelrasmussen@google.com>
Subject: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
From: Axel Rasmussen <axelrasmussen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Axel Rasmussen <axelrasmussen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: g4i4ip8ewofutw7unren9tw5b5kj59ff
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F196100009
X-HE-Tag: 1771979082-520825
X-HE-Meta: U2FsdGVkX1/FiVdXsoInfv5w1W/8lPcDKQF+HpolhTl4FqeAy4fUzEMoobvUdOiYB9PVcBRpeOYfcU2a8WRLWkxCTazgiNgOSt4+yoTBaNbmbtSHFYpkxSHv7rP/uWTa+HII1WQJlYGb4NhVV5eOWxZ3+d7l7kaXL9IPp/WWAPfGIgkiFZNv9BjuF9KdtstcjhDxJNU4PEGqTqSj0gnmDbD8YsmvmX7LLeGK2LQ5B7VsCWd3WCfrLz0OSxM+JMOMtXKSjK56fWyQkRP+3xkksP/6iNCUI0BZxlffJgZcLTG11ftsAyIuYJmqjESP+yIQawd7P8vaeabXtXbCZ4+7rkv+ua+11CLEqRtksoNbWnj+yU7s1Q2nWBqBAgUB7MQtI1UrwSBhcOUIIp0G5FTvtMukKvkwauQ1ZPdeZPXwMBBX9GC7pLvLh/1LFGAJ6ln1HZvzFS7td/VAVHE/Ho00OS7SHEqV+wm8w8/ULX3EYsnFPTHPuGpETjKFP4mcxnJUigzU8dD03H/4xXwEBB5ytS1Q03k0V9QqDuJSpbncSgT/mQJ4heiPDaBV4MKvXiGU4Qkda+n7/UcGRTEwXSjL9hPJ4kVppcpHpE4DdBId3ZGV1/RVT5AcGSdjX+E9xyeWTXQA4q1u+8h/UKRgI/nrA1i9Ff0iqA1S8o/+2V5vWzfjTx1n8H/FUdYu/UuGDzObmaj5/J2WWuRzmOx1KveEdKsqFRhDJg0ZpxUgD3ozRsFAqje/3rFhBCnHdrNwuZ+MElACar2UjRqdSxQ5XuKBWmpxovtPLHi2WHfmqhytdC1nwINpRaukETOeUddboeqgtmySKv8GFfjkEC+odqow+nk8tZFLovVKxedYE6N2PXjNsQrXQOX3j/hIHCMxPjpoj1uit0GxMUXpQKFzDwBQO0vk8AN6MT4EHWZ90mzZL9n0G97QA7oDIMBFq62APvuo1oHx8MIAo1y1WZmK4I7
 wQllh9Rb
 ImkI3Nts3Y+LjNBcMVEK9iMPK2EV1CfK43pB8b2W/xbe5xIJS4282xl9i1zZqB14xp+OhqjPA0KoI5C2wHa1vrhqi9bvmwlEw+0qXjXjhj0YbYgz9b+D7/rSWvkQEoWQaxVnkmGgkyZD3SVxU3G0qVHnZa8pvfNj/Sye2GrojZoKgXaxgerPf00+NADK3F8WsG46FnHcymZVS2BdHw/VxEEcTeflIbVKZ1ofZVIh0/a6Pq7Lv/luB1/1NP5GuLj2zJ6K/MWXo6SeiPso79Z8Yaf2jURO81svC8A5PEkT/2YRTqG0cU+MEyz67ttS35UX9wDqb1GDDe/4Wrp5Q5J1+2bh0rr1pcl3Biag7cRqva9npx1hsiDkMhLER5HxGDz6TTf3DHmUNlhvkoXjgLekm3aFqYZi1/7xN3wgGmvVo+JmFESYBfKtJgW1Tw0qZKYKxTia4uQJWFRDTUwb1hVApY+MAhH+CwReouZ6TpWB+ruXVPFM840nfeWE8gkZVfgxMnqsbe9sHMP8oWavVOygNoNbSltBqVTw9iT2/QJjXeaaTnImBdFsLmsqwDf107tTpNxzzdQlcgMgLGHiGW2g109I5t6J0AiLAXQvnCpDag2nE4LpOQBp1WLCODzIWbM6soN8dYggHwMJJkntmRpks6XCtHZ3lcVcOOR7jqCHstQwWu2zxB0j4rMlkeK6/58FVuz2/lwbFpRC+XxZW0EuLItmNgp+qbqKdzhXIbVBmlbOZAxd3j4ANlE1ghA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change swapped out mod_node_page_state for lruvec_stat_add_folio.
But, these two APIs are not interchangeable: the lruvec version also
increments memcg stats, in addition to "global" pgdat stats.

So after this change, the "pagetables" memcg stat in memory.stat always
yields "0", which is a userspace visible regression.

I tried to look for a refactor where we add a variant of
lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
folio, to try to adhere to the spirit of the original patch. But at the
end of the day this just means we have to call
folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
accomplish much.

This regression is visible in master as well as 6.18 stable, so CC
stable too.

Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()")
Cc: stable@vger.kernel.org
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 include/linux/mm.h | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..abb4963c1f06 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3514,26 +3514,21 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
-{
-	return compound_nr(ptdesc_page(ptdesc));
-}
-
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct folio *folio = ptdesc_folio(ptdesc);
 
-	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct folio *folio = ptdesc_folio(ptdesc);
 
 	ptlock_free(ptdesc);
-	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
+	__folio_clear_pgtable(folio);
+	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
-- 
2.53.0.414.gf7e9f6c205-goog


