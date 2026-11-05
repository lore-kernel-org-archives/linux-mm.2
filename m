Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17D0606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=roPZPHbn
Received: by kanga.kvack.org (Postfix)
	id D2D476B05D5; Thu,  5 Nov 2026 13:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDA16B05D6; Thu,  5 Nov 2026 13:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77456B05D7; Thu,  5 Nov 2026 13:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6426B05D5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA81C120B7F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:27 +0000 (UTC)
X-FDA: 85401933414.13.CBF29D3
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00D4A140008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=roPZPHbn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nt953ET9NtDcT5DOJGv9MY7MHC3tnD4Orm6EPXl4Ois=;
	b=VapIDlHcLczlrQ1nkYLrqqKXqIUhLZMfXcOvPURr918QpgbLISzHZ8FaJ84QhcYTUcu6Fd
	YKIDKh6mHgA97a1ZdCJbwwRVzSQAOd8HveSmJ/nZrzVO3REdCTquOPqXU1yoUcXNoUOCrz
	JSSjquKdf+YMxdYVhFvwsI85/jgUxgg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=roPZPHbn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904086;
	b=VD+V8ooeXhbjxi4o/Zfagy3PBoyTCpcj8MCagC9ZG0x3dBvdb2MyHESSGm0yvz+CKlrZI5
	A6E76VdwlLiv6IK9yFlkpXQw5z62fdzU31GEAaWjkNGFP6jaFARTEUHHx3+3I/7FttQpJP
	rv3Cjns1YIUlWUjRwJb8VAXx7JguOKQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=A2DSiEYroyA96+szTGlscsdo/zoqOliyNkD97G8H144=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904084; v=1; x=1794508884;
 b=roPZPHbnxu9Gmaa44FvptpdCn5UQ3IK9EoRxph6BzbewOihpqRDVuqv2bJFR4JDhtfopyf9E
 JW9d+mp9uIzERHOePHaJeDoepsqZEAp8Y5oid27k/XlfPOviNzg/4MbKq2OfTglfkPeZkWCftXK
 Z2xfvSsyBbs0o28ZuTVNrJVw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 79d16db9a293cdd2;
	Thu, 05 Nov 2026 18:41:24 +0000
X-Mizu-Trace-ID: 79d16db9a293cdd2
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 15/32] mm: swap: share swap-cache allocation error cleanup
Date: Thu,  5 Nov 2026 10:38:59 -0800
Message-ID: <20261105183940.2236717-16-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00D4A140008
X-Stat-Signature: aap5tghasoqopiq5yp8hac5cooqemdue
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904085-705495
X-HE-Meta: U2FsdGVkX1/t2A75Ub5pekC47ngHsJAzDxRuosYxP3b9dUaHZF27wi+ebubO7nPGsAv3ymhLYeEU8x/H76EU6LVz+pnly31hti1qEHMzTMWZBSZilUYwcUXECMK0lpw0p9t5WLFEClqtfglz60RX7FyNRwbqVrLUje+YuLYvXFL/6QWJdtL6XABzis8JJhqEg5FSnWG9tmJOjGMgso8Ga7O54gC8yH3vt7mka/bVq7N/v6X7UcG5yXgqgib/5PE0DKbs/H3P5WsVkLGicZl+AZRp6EACzwSl463eJN1EeoPo6NdaC7+0FaIadv1ZQEabyATE++fdxr6i9QgoabFZp2ZbA5TlvgUOthDmzvzmLpghd4cR9FqZo5Vn13hvIRKPk+Gy8hpYaMjQsJa+nZxA3/VzJsIxUPNpb/dszYctb0gKszIp6G5qYPtKy5YWjRXE16E/qcAjFwtwk4+jgOIoGBzlfzpyKroi6YEiNjzpFh4WeJnDqJdwbZZwuJFxmpb0fRm+Dxx4C7y3J/nYW017r75CWuf07u6h9Zyn55de73sqnESgl/oiTRn/oB6nktz0tQSZZtDVKhlIcuAzJVs3c5W/ThJNYzhKAfeSWj/JaLo0dzONgJmhMJbAN9xH2ipJGvDZvO5kGLCNwigYq6MgRX5Jky0Hm3v3qrzttG8oJ2Yk+4sMvQrd0/peSISzlRh3Fs35ki3emsnRfK5Uke7vyT9xYonMIRF/wJ7GW2ZlPHsdHXn9dkraNfZHt/IyGxgvXruJC5q5bm+CUrAALt4D4DggqCjvZ9M+fzxx9cOjeM2TSD2e017ThYxdeE+yHMMoDjaLlzds1Y5GcaUzzh4Uxewb+L11V15Ue5XmlvqWosXsEN0HEWyDlHh0fKOARlEjMXhxmGITCxLFXVhoZa45Oca+tR/lPggBC+TdqP15SB94ti/EaOqN/twUWTfR10mJxanTvKVL9u1j6u2gZvU
 Jn87PvwW
 ZzKAj6fmVsrF3OUl4Mu4UyBfANYClSVUGpOwurarCi3ouWWcqkGifYBBN6oyZtNQEEMH4S2dN/N7HamFazAZo1ycnu/BxZMGEo9Bq+vU9odW6NbpplLvTEUkIME4gz6XYgoTfcprwJJEdJGX6RtC0qO+FYLAwzcmyRNVhcTtkWkIkPOMdpxZONwmQrVyc/WJvQJvxDgnsjanveSswKNNSZ2Zmd9yfwg5Q0ZZu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both post-insertion allocation failures remove the folio from the swap
cache, restore its shadow and drop the folio references. Factor the common
cleanup into one error path so additional checks can use it.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/swap_state.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index da65d75ceead1..a8a486b0403ab 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -484,24 +484,14 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
-		spin_lock(&ci->lock);
-		__swap_cache_do_del_folio(ci, folio, entry, shadow);
-		spin_unlock(&ci->lock);
-		folio_unlock(folio);
-		/* nr_pages refs from swap cache, 1 from allocation */
-		folio_put_refs(folio, nr_pages + 1);
+		err = -ENOMEM;
 		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
-		return ERR_PTR(-ENOMEM);
+		goto delete_folio;
 	}
 
 	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
-		spin_lock(&ci->lock);
-		__swap_cache_do_del_folio(ci, folio, entry, shadow);
-		spin_unlock(&ci->lock);
-		folio_unlock(folio);
-		/* nr_pages refs from swap cache, 1 from allocation */
-		folio_put_refs(folio, nr_pages + 1);
-		return ERR_PTR(-ENOMEM);
+		err = -ENOMEM;
+		goto delete_folio;
 	}
 
 	/* memsw uncharges swap when folio is added to swap cache */
@@ -513,6 +503,15 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
 	return folio;
+
+delete_folio:
+	spin_lock(&ci->lock);
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
+	spin_unlock(&ci->lock);
+	folio_unlock(folio);
+	/* nr_pages refs from swap cache, 1 from allocation */
+	folio_put_refs(folio, nr_pages + 1);
+	return ERR_PTR(err);
 }
 
 /**
-- 
2.53.0-Meta


