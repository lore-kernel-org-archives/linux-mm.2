Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C424ACCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C226B0096; Fri, 16 Oct 2026 10:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC836B0098; Fri, 16 Oct 2026 10:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A296B0099; Fri, 16 Oct 2026 10:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94B186B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:35:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CCA3A8054
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:17 +0000 (UTC)
X-FDA: 85328737074.26.63E1D5A
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3AE54A000F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G2nseRFJ;
	spf=pass (imf15.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45yjWNO0nNHXei6UzhNbwOEuF+X6mrmEeZx1XWQKEss=;
	b=MNbSBCU1BDjX3N+zh5MMa9ZIA5ejldmoJrVdchrgUTEh5mnSCzC8CB2scieLprkpMf5c8S
	XAnY4oqiQHf52OdgttybhrTEBDZy4oXCXCZXsX0TODmGAtsIRr/EpcTJCUkVeaIvy6p5t6
	Zh89jm0xIWSRZZy2opQkk2Q0FYlL0z8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161315;
	b=PQcp8qM9np3w1wBkk/5zEiza9XxJk8xHFwEDfWK2FZH2YSig8rkExmIUK0s48F/j3dOoUq
	YZVUB1/kd/Xm+Y+I4kfeaqTdAzzc/XgT1COVB0xcJ6sAjB00VG4AvHzR/Aeu8c0fdBzNSQ
	Uf6J8achAf5oIx+2get47QDO9c+caUU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G2nseRFJ;
	spf=pass (imf15.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-354ba08cfd1so10608244eec.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161314; x=1792766114; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=45yjWNO0nNHXei6UzhNbwOEuF+X6mrmEeZx1XWQKEss=;
        b=G2nseRFJ7nd+Agfqem6SUb1/aCk/weinnNIGD8J16C/g7Ua27K1dGqJv7AsLSM53/5
         L+owfo4S2NNfWMuFUrrXBwNzKRI72RX/yLJJDKKNVEDuQE+TG/gsVlEhW/YyixK5cQZX
         KXom6NOVrEbzkK1HYgYAU/pxyh40o/ifBIuVkbUR8Q0R56oNTn9piCla8GLdH0HUj8y+
         xPMk8KbchabpHikZ5qThCzU6GC9Nrq//4yRVdONjyuLdWV3YYSY5wPVm84rX3BTA7i/S
         IFQNLq3XJTeKLZavHmcQvdWnLNnzrfRuNn16PEDRINrbADNarJeMCGEMJOFhVY+CXoLH
         N/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161314; x=1792766114;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=45yjWNO0nNHXei6UzhNbwOEuF+X6mrmEeZx1XWQKEss=;
        b=xEwWuJQnfe9sHy7SC2RLuC6cbXY2Ov7XLgRt91GaBuvClYTRMdqHCbiYRwSvHIhC+A
         GmzCxin6J1zpfDQQ+OZRtI13/k+b0M4sUBOcZDdl5esPW+ytmY6Y3zG78e1D/ohZzipF
         0m1FYS+jJ3reKcrCHlsDl//VrmLR7yRhtUtyTIxt5IdKMem4cRbjkBspYKauFo1BBYDt
         fOcEQNLh9paz0y9hNFhGAvleMOj4V6a5IPLx/gfa7EedczHMI1f3I5BuDzRXfVfMhVQ7
         6KuP0cI+f8zUAmNTFhAQaJXbL2KHAuebMd3FpTnNPmPGjImbVY/85RN1TgARJmruq3jc
         ENAw==
X-Gm-Message-State: AFq9FYKZvHGsHtBbmFPRvap7kWE7om76u+G92WjeOn0zenzHtnGpmUKu
	uCMwiFFcoAbvwmTNbsT1JBw1b2nAhHJO7K3M+x2BKhR/VlkTE8x6FOlb
X-Gm-Gg: AYBFou0eQFSbWIkHkblqHoqS7hRbGAV9DT9RwmSoHSH/wmT+lKc1lpd0fjbPJQOluks
	J1KlFm6DAixCnJzjIeiWj7/UwA1it3vX0sZQeGspc2WjqsoKGB7BlGqLxgEIIHxUEfolWZPDo0Y
	kUiwBNhDMj6268OnFv95ebc4G91RPZR8hGBABMsrKIhWTNOebVEzm+BlExK5NF7pBEEgmyAXX27
	Wer4X2wpaIWfTIWCIkDgPc9B70SngLTbuukLISZ3ck4PMS1YgUUuXHNWF8rDINtbWdXYDQT3SpI
	Vt9RdpPMKGttdM62JerdLE2pv6Z4rruGe4yPeGVAI5YdGwrBQ6XrLn3HX6NqJgGaZHq8RxKtLE5
	qdbKbIrzjo9deggcvjHt7D6ziVnF1KDFIJAOckrg2HEnwaq4iRsCgmJwsLI2sT6k0rR74d0CYO3
	0erVODw1xA0uddf1YwiDOD5fOwo0v09wCbBFHBUzGpxsTVU0wke+ijmkeoOpIMPISQIB9JGlyRj
	CI1VlLLu09cLJ4fHFAsXNo42bo0CMsGc01A8ne/q86nJJsO0Tg=
X-Received: by 2002:a05:693c:2a13:b0:35c:99e1:c755 with SMTP id 5a478bee46e88-35c99f11cd8mr13996357eec.38.1792161313598;
        Fri, 16 Oct 2026 07:35:13 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608297f4f7sm7611812eec.23.2026.10.16.07.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:35:12 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 16 Oct 2026 22:34:56 +0800
Subject: [PATCH 1/2] mm/ksm: align smart scan skips with the scan number
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-1-2f91d76416be@gmail.com>
References: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com>
In-Reply-To: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AE54A000F
X-Stat-Signature: fmwpgt9ytfwy3nzfyycf3u9pokedy5ye
X-HE-Tag: 1792161315-504684
X-HE-Meta: U2FsdGVkX19CtJ/mEjnqiBXokrPW/LKT8Nh1IRyOOZABwpVQyIt3+2EUylw1giHccBULEKLtxXaW05wFUdk3vcol38ZCHkbPJt8z8uKkxzha56Bd7ZNaR+9A4uZmrDcRrdLuQmkmOJ4FO9JY2joW8FjaIUj/07Bi+CkUcz2k30EgpOB/AIh8ADlvMD13/d1YBGPWoXSKiEGgZ6tcVlrt+/vS0PoI6C0EjE03Z1pWfgKQhfenjewGMiFT8TWg51crhCxxMz7HRgxC7hrnImOXLiLxP5+0ukCYqUEvCg2UzLgZalQnoRcxRXp/Fau16aq/NunibdZHn1QR0rm1oaeIErFVl0wL+5Hgl76PbS3k9QetJ50wii9ryaEORjagz7gJkinH00K3+H+wZlHWJwQK6jQ1+YnwSfAaMZ5Uyn/iPoqYvfrUfy/0TBsUfbNA1kvVSEESXeQMIdkg0NV51aJ3s5XcXfvlePvJ+sZWQ4hjvtd55jYe/mQCyY2iNvAoeoPDQornf6Z9sr65Vru2TGyYacWsdrBbLjCbSCvue5+rY9/IPAT9U8/vh5h5QS3oCw8ktBxU8HSLeSorJ7TrwC7wZEWxP2vdLW2g7GnFCgw4Uk6O7ShsXAeYNP8vWc5ikPVe+Bn7lylrjeHawWAcXuU+uViclZawRBdYgBXmUERZcCsC5WGFtHPRTSNfH0GXKcmgFcbUfIFyZcqj/QId3QL+mW/CdkhOmjT6F6MCyURQVmqfomy9vJborK2yw50fNOLx0iSGMma6QKDTpbWL48ORw4dEO8I9pM7u1dLEHQvflLWtFuqxt2kJt3cvkeZfXeWS1sjksj7eRc52AhPL80K52IDnJG7YPsfl9c9TXVMnXsBdhOtMMogzb99RM9JroXXvQfx1+D9MbvSo+osB2IzhSjugms5a6ThtL2fQuyizJuGgaKVoZkHdemavnM0m7B2HEEWcEKVNpsbVqlUN1LA
 MLO+Iz6a
 wtztnC+jxGrHUef6WyTCcCbs1F3e90FnT8tDNP9mZM+LqijJJnhsE4k36rP4JTaX5eYph32hCq2jhQQSHXm5IOL1m98ouspaVvL09ry2u4vwVLknL6YBt9JZrQugzf4PzEsvr92JIGx0woFbFe12bMAdA9XXMvhubNkjKmUX/TLjwuoaFlHnNDfyXjqIVyp8r4dO3lmVOFLbcIcaF+2mnVavSkhL8gTj+skzW36Lq42bY9p3RHFeTBCfHP44FTRQxLOQSQhs/bS0WaOKrFzfzrCSctzmxttWJI/Jxx7S4wivl7kHFQ22phlhLAkZPGJSXSISV01Qg6dLckmau9BXTjJOc5nIjqJQjxfselWIXyO2YVuD0oawM7UhPWxi12LXAXyz2DTy2+8wSX2xhziSRO88v/NCVUBbyPkGqCM5qJUI38WIfPt7BvhLpgFldD7w02TG3XtyKsnW6zSnpTPbOc4lLlhc7SFITw/hWIu+oRqAqakpA1Mvr/0wWqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Smart scan skips pages that KSM has failed to de-duplicate for a while.
Once a page is three scans old, its rmap_item counts down its own number
of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
at every ninth scan.

The unstable tree is rebuilt on every scan, so two identical pages that
are not in the stable tree yet can only be merged in a scan that looks
at both. Each countdown runs from when its own page became mergeable, so
two pages that became mergeable at different times end up on different
phases and, once both are old, may never be looked at in the same scan
again. They then stay unmerged for as long as they live. Making a page
mergeable, waiting for 0 to 20 full scans before doing the same with an
identical page, 20 times for each wait, and checking the pair after
another 64 full scans shows this, and so do intermittent failures of the
ksm_tests "KSM NUMA merging" case:

                                      before     after
  pairs merged                        317/420    420/420
  ksm_tests -N -m 1 failures            3/200      0/200
  64M of unique pages skipped           89.1%      87.5%
  ksmd CPU time per scan              5.9 ms     6.3 ms

Pick the skipped scans by the global scan number instead, with periods
of 2, 4 and 8 scans. The periods being powers of two, every old page is
looked at on each scan that is a multiple of 8, whatever its age, so any
two pages meet at least every eighth scan. The longest period goes from
nine scans to eight, which costs about 7% more ksmd time on memory that
never merges.

Fixes: 5e924ff54d08 ("mm/ksm: add "smart" page scanning mode")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/ksm.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b1892..a97d7563c2124 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -196,7 +196,6 @@ struct ksm_stable_node {
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
  * @age: number of scan iterations since creation (unstable node)
- * @remaining_skips: how many scans to skip (unstable node)
  * @linear_page_index: the original page's index before merged by KSM (stable node)
  */
 struct ksm_rmap_item {
@@ -213,7 +212,6 @@ struct ksm_rmap_item {
 		struct {
 			unsigned int oldchecksum;
 			rmap_age_t age;
-			rmap_age_t remaining_skips;
 		};			/* when unstable */
 		unsigned long linear_page_index;    /* for reverse mapping, when stable */
 	};
@@ -2446,16 +2444,14 @@ static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
 }
 
 /*
- * Calculate skip age for the ksm page age. The age determines how often
- * de-duplicating has already been tried unsuccessfully. If the age is
- * smaller, the scanning of this page is skipped for less scans.
+ * Calculate how often a page of the given ksm page age is scanned. The age
+ * determines how often de-duplicating has already been tried
+ * unsuccessfully. The older the page, the fewer scans look at it.
  *
  * @age: rmap_item age of page
  */
-static unsigned int skip_age(rmap_age_t age)
+static unsigned int scan_period(rmap_age_t age)
 {
-	if (age <= 3)
-		return 1;
 	if (age <= 5)
 		return 2;
 	if (age <= 8)
@@ -2505,17 +2501,17 @@ static bool should_skip_rmap_item(struct folio *folio,
 		return false;
 
 	/*
-	 * Are we still allowed to skip? If not, then don't skip it
-	 * and determine how much more often we are allowed to skip next.
+	 * The unstable tree is rebuilt on every scan, so two identical pages
+	 * can only be merged if both are looked at in the same scan. Pick the
+	 * scans by the global scan number rather than per page: the periods
+	 * are powers of two, so pages of any age meet on every scan that is a
+	 * multiple of the longest one.
 	 */
-	if (!rmap_item->remaining_skips) {
-		rmap_item->remaining_skips = skip_age(age);
+	if (!(ksm_scan.seqnr & (scan_period(age) - 1)))
 		return false;
-	}
 
 	/* Skip this page */
 	ksm_pages_skipped++;
-	rmap_item->remaining_skips--;
 	remove_rmap_item_from_tree(rmap_item);
 	return true;
 }

-- 
2.43.0


