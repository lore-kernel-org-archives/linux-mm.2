Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F33CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD7C6B0093; Mon, 25 May 2026 10:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E486B0095; Mon, 25 May 2026 10:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAAD6B0096; Mon, 25 May 2026 10:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDB026B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:57:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8089CA0147
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:56 +0000 (UTC)
X-FDA: 84806246952.05.369A76D
Received: from outbound.pv.icloud.com (pv-2002h-snip4-11.eps.apple.com [57.103.64.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A12540013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=O+Et232F;
	spf=pass (imf07.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.211 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbidOf+0bR1HgAdWvO64+fM8hMyQOeB8vX0q44hvsZ0=;
	b=vcZ5zcTWse1qZA+OWDwZ1geOLZEXzf5nuTZ6CZU7733oV9uupgg4YhDDZBaQ0ay5mKMOea
	8AusGWvU0v0bjlFxnh9gXJOMSGma8Zg1XJe7/wy2Mw4JAK97+UDAwJbKptIn5SlBUPcPMt
	8KXJsFAxtSMD9LihwZvi+nQZuiILWMU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=O+Et232F;
	spf=pass (imf07.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.211 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721074; a=rsa-sha256;
	cv=none;
	b=04TV4W6NVZRyrHjkzq+31qOpTBUF8xvcA3Uu3ZWQD16RNXnNAibr08dTS4GYbZEkBL3ggN
	2y7mXQU2Ldh80ng3Kdfyddmkw+LUHr+2PONV26dbyhBumAk0wbez50Wk1dB6KeZydDi1Kg
	UyAcU3mZ6IpiGkhnraRvydSSZCi+Hdo=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 0F00A1800123;
	Mon, 25 May 2026 14:57:48 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHV8FRQNBF0kFWBcOVk1DEUMdUhlfH1cTVhR3AlEcVg1XQ1QEX1BfHA4EVAddBV1WUAJaS0ATBEoDTV8OXh8EF0YZVQRHHl1WQxsZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRADEoGQFUKRhNRVUcBVUZUHEwLW0BBXx9DFEAAWg9SVkZYGlBdBytbE1UXRgkZCF0dB1hHFEcODxlaFFwYUw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779721073; x=1782313073; bh=TbidOf+0bR1HgAdWvO64+fM8hMyQOeB8vX0q44hvsZ0=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=O+Et232FeSvG9SPqZpwqGP5l1oV6L2Wk9GHBxcCRSeoGcrcUc5i7qR9TSDA4ddVwJ6+PFjZb28YqwGtwv4rv1HT49LeXjefXin6r1e780KU2Y4nlCkmvPooQCJjC7yZo2+F4T+EPR5hFCQXuzzBw63qKZ+PUoaYrSrkUPVuElhbfdUOBVl3eaXNeKShoC25Ur4o5Azpuf79lzMibpe9XeHQ/YLTjvli2dxsa7wiJirGEFLsXzVaywRAB6v7oxhVocjhKJZFhdde52xdkfNiXhcrOm6TodQ0ymtW7tTfH0bL1Z9k+y1UUt8pGBrZOrO3Mtz/fqgXCP79p8BybTtuUSA==
Received: from [21.6.122.162] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id 777C41800127;
	Mon, 25 May 2026 14:57:43 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 25 May 2026 22:57:19 +0800
Subject: [PATCH v4 3/5] mm/vmscan: extract pageout_one() from
 shrink_folio_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-batch-tlb-flush-v4-3-83789d6abc00@icloud.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
In-Reply-To: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779721049; l=4366;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=HlCDCjaEuUAcWJgatcyXKXkF6++iV8Wx6KA0xfRDRhs=;
 b=Uw+ORlKctNuuGP14pbAYK206TM9iJu+9oCMuARY2+Z7D10MVwgGaeBd1zSXLUxlWxK3A3EB49
 o0Sbb0yPGDwAeHKWYcuF+IigkB9NzVfY5shrkIF7why2DVBPWPcPXfP
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-ORIG-GUID: 35a--qBcikftPTJwDqqOP0OrrlzpSt02
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE1MyBTYWx0ZWRfX5P0N+GhVwVxW
 d0vE8rWeJ4yTK1X2Uz5/2tl9cC9YQ8ZUysZHSBD/cHqvv2Y7KZDLjcMSzAnRJChUf+GblQhGzLF
 9lmBGRRL6A6IhqPoiz9RKbdyhDIL62RcbYIq/nOXcG0BgCSCzA+yKEeK9HkKLIewgFs2gLjvtga
 EuL/bdl46yYkYTzR/8xlm31pq6d2dwYO5xJwL/0Sh+hQU8Hm1c8UxlvxG9XlTaJ50FCx2Uz+ks9
 J0kHZsbEfeRaF7WKLQlZel83EzWjbB9BNGzzRQnaR6IYwCDz5oXPxCqUsvHrk86CIAJMSP5JtUg
 esp4sWC5nVThaOoiZxKwFdp//5NxX+OcHW41sV/Ep9Unfl0b8heGY7Rc842SDo=
X-Authority-Info-Out: v=2.4 cv=N7Yk1m9B c=1 sm=1 tr=0 ts=6a14636e
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=LeMCXtsDaY_ey64dPfEA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-GUID: 35a--qBcikftPTJwDqqOP0OrrlzpSt02
X-Stat-Signature: cr694416tawit6tijgcc4hr1pzneg154
X-Rspamd-Queue-Id: 8A12540013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779721074-277102
X-HE-Meta: U2FsdGVkX19QHl04gL5gGokSLWNSAOWBGQ7e+9Wbpqi2fr8CQYpZtejHCvVY89eSaahVXm+0QxQcZozZbHUba3nOmwCIKAW9v+ou7j0YFeLGBzTppXK20qo/ligrxbs//AQOhnxVRDj5YLDu22z5h9IhZqjjiH09BH2QwGoMVvVyLv3n6rUU1b+4eYLZT+anu7qqUtrCi9xLnukGSKvnOAD1TZhTqFB64vY81NCh5ZV+RaHdTMGT7GhmL0oG1bl4Axm9TmAXE+eQD1MjqnUL7Nj9pKdiAQQ3BvjGreFkxNaL1zrA2mKPqXQZW0Bn4+QsJVcBn8IVptICjHVdw2qtKp4+orezlQ4ARp6aQ00NkwGxcFsjsaDeTuvGHuY9S38MG3hBxQLjvroBG+DASSz59kdNC010h2XqvH/PE72T3UIf2j8Mo8+7YhYOcCaMy2KG1zCqimh6oVD/TUOiRDXdlhFsz0lllDRdGNaghDrxygHUdYVhJeD7JqpbKV73PznZNPxBgXkCJAwz9+e+Oqhpt7U+L5VcToGYmFcI65JL7EsgxO9itrH4cJLMSpSw1JTZnir5rRIEQl1oOlDav0px7AIedylIGTg4i80nsxTP20QAE4fLS+vTkajQv1GyFl6n9lncS54Sdq+YNLdxKkS3vcZyws4o80C6xK2irMVIdrRJbDJU2DlRXwer2YTpdWRa/RgISyizWAi1FlYj3U3sOfXFqmMeY+yWCrs1JSzIBeo8LtaZ0CxqVEAl+OvALqy+G08bNE+EjrDeVbnydiZ8R6glZSBuuSN/U7AThuMBQ3xXpeCmavspw2ZwWpbdi4MEJYzVYlfhmiso4kUpnMRgTmBM1aJdDhFzcOZvUMRPi51OILJQwWJAk+JedpPnBn2Lp+Coj6CXe8cCacrCFpg0UTtZ467s9QJdxDgfrFHPklqifVRMrHjZEkbLFaP8TxSvSDRgP0DHbZ6+i4eqYUi
 Sgo0Nd8V
 4FpYpNhs6zwPP2IpVd63TcSWg8lsbi/vFxJosWV35eHbwHMyFUtHZYcjayjMGtOsEhdnSQ8loJPLna+JoZBuh+XudXIXGAHbyJb0UkaFR/udMf196tW1E5oFUsNQ3FV1b1FjWna8JzbvitMzkZQZchnExXPomvH/2RRz4Zs3tKSpa7lVC31FRW1AN7DXOdUEPMPh1YIxPQ9UOCyTJl3by3KdEAdHMG8RytClegDO+ZweZO9fu2ywxbRys83rvK7sfZkzkqhD9diQ9Q2uEpXjTq4wvofKMQxsAh3Tz53nGmHDbZntJeVPdoyi8cFZBdr0Nr9XPzbFIuOJHfAfimkNfFMB+L6UVuDNM7UiAJq6lcw3Es5rtJAkX5vB6yveBdH38kYHuItoA9C0jInQkg8AwtfkJaijEeUBaKjph1nqeNiH/PMOd1d+c+ClfMAp4yRG2SzwE8CfnEogvnKnxzXVLvH3y6JN29en/CNzBJg7Kzbj2+x4DHcr7b5aytoWGPD3nljJOFFTkOUVTAna/51yEppmDc1nbkh/k+jFZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_folio_list() contains a self-contained pageout() dispatch state
machine. Extract it into pageout_one() to reduce the size of
shrink_folio_list() and make the pageout step independently readable.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 107 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 42 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b31f67801836..456d38eb172c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1161,8 +1161,68 @@ static bool folio_free(struct folio *folio, struct folio_batch *free_folios,
 	return true;
 }
 
+static bool pageout_one(struct folio *folio,
+			struct folio_batch *free_folios,
+			struct scan_control *sc, struct reclaim_stat *stat,
+			struct swap_iocb **plug, struct list_head *folio_list,
+			unsigned int *nr_reclaimed)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	switch (pageout(folio, mapping, plug, folio_list)) {
+	case PAGE_ACTIVATE:
+		/*
+		 * If shmem folio is split when writeback to swap,
+		 * the tail pages will make their own pass through
+		 * this function and be accounted then.
+		 */
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		folio_activate_locked(folio, stat, nr_pages);
+		folio_unlock(folio);
+		return false;
+	case PAGE_KEEP:
+		folio_unlock(folio);
+		return false;
+	case PAGE_SUCCESS:
+		if (nr_pages > 1 && !folio_test_large(folio)) {
+			sc->nr_scanned -= (nr_pages - 1);
+			nr_pages = 1;
+		}
+		stat->nr_pageout += nr_pages;
+
+		if (folio_test_writeback(folio))
+			return false;
+		if (folio_test_dirty(folio))
+			return false;
+
+		/*
+		 * A synchronous write - probably a ramdisk.  Go
+		 * ahead and try to reclaim the folio.
+		 */
+		if (!folio_trylock(folio))
+			return false;
+		if (folio_test_dirty(folio) ||
+		    folio_test_writeback(folio)) {
+			folio_unlock(folio);
+			return false;
+		}
+		mapping = folio_mapping(folio);
+		fallthrough;
+	case PAGE_CLEAN:
+		; /* try to free the folio below */
+	}
+	if (folio_free(folio, free_folios, sc, stat, nr_reclaimed))
+		return true;
+	folio_unlock(folio);
+	return false;
+}
+
 /*
- * shrink_folio_list() returns the number of reclaimed pages
+ * Reclaimed folios are counted in the return value.
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
@@ -1499,53 +1559,16 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
 			 * Folio is dirty. Flush the TLB if a writable entry
 			 * potentially exists to avoid CPU writes after I/O
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				stat->nr_pageout += nr_pages;
-
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
-			}
+			if (!pageout_one(folio, &free_folios, sc, stat, &plug,
+					 folio_list, &nr_reclaimed))
+				goto keep;
+			continue;
 		}
 
 		if (!folio_free(folio, &free_folios, sc, stat, &nr_reclaimed))

-- 
2.43.7


