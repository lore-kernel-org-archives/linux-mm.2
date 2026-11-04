Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2D5606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u2L8QUH9
Received: by kanga.kvack.org (Postfix)
	id 8576A6B05B3; Wed,  4 Nov 2026 18:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799AF6B05B4; Wed,  4 Nov 2026 18:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCF56B05B5; Wed,  4 Nov 2026 18:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAA16B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4053E1C42B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:38 +0000 (UTC)
X-FDA: 85399033356.03.8023CAD
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 56C1D80015
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=u2L8QUH9;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXyL3iz4X1JZRSqfChrbLBr2JBJDe4gGCHENjeInkiY=;
	b=EBHY8i2zTyHRC5r7AzMDCxjNfHHX0CUKSTK7UUMyzOaYgHQ4gt87dJ6new9Ifle0JcBy/e
	frIljkaUXF7i2OvhX5P1pKsyfLKE6Bkx2pNNF9l907n9mzU/a8P1m2gd2K+mUhetzK1d6i
	w05HgPQ4noZr+GkNbQo0G+XfbXLRA5A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=u2L8QUH9;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835036;
	b=lZIwWYhmbtDPzjG51Wr3dTLOB1zSxDt0XHzAQpTkggnMgmCNPYUDLV/1BZJ8hUTk1wG4Zl
	DgZOxFlKcGwxNUdy+sA+POs9/Q/nXHFKOMjGiwS2/4PIuNMlFLlHYV3LIgGhvrDW7HShl9
	oXjzO+LY3k6x69kzJ8IvZBuuLmDpCEE=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67be5d0e9cbso1054594d50.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835035; x=1794439835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HXyL3iz4X1JZRSqfChrbLBr2JBJDe4gGCHENjeInkiY=;
        b=u2L8QUH9/RDBggFrrjGG7Q489NEhv+ASPfs+JSnrqe1UxcNj0okxo/Bi6+QTwE2HUQ
         sMTt1/OuQQFIH6vyAhenNHIdWpDAFI95cy4jr6PcBJh1EB4zhmqgb4hQ7MS2ktvQcXuA
         l16Q2De3BJ7RojAidbkHIIDEE6SQAfSZcDG5VymnnK2LoIE2YIL6pZmRe1J3QXMZWjXj
         oFgmaolznKS5TSGyY5IjpBqwUj/Pzx0N17c8vPiP7YXPKDgVWBnEg2taYW3/5dgKyGuM
         N4ywyElWc3hIk44aokY3LJHupZYO3pBjVhYGc9QpeovmhvswkwC5tS5f7dhiCyhsnQac
         douA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835035; x=1794439835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HXyL3iz4X1JZRSqfChrbLBr2JBJDe4gGCHENjeInkiY=;
        b=GJhHgjRGQ0XWobGPngRP2jqGBIF4RLtlfqSWZxGkUTTg8I9XU81gqCxQPhUpspLPCh
         GPzWnBPFxIf1Pmyc9ZV+EeVOEvlOj1d9U1vRT5Zn0QGpdVa8WjXdbI5mziQ6/1yaajwA
         llETPekk6X1Z7WaDvPZr+MCX+hKEwde8SoGLQHCWngQlKUutKTzn6RC+br44XD2JrLqI
         Jg3+EjKhN+fQ1kpp9JlHupXp4hrNZtJGlSE7vr2dGkBMnYC0kxLOfK/uOQfsLt5fE+zM
         wY2sKiSdNnxe2iTjc7gCkGLnyYO+G+R2iVHPfhTONyfYdC4MjKMXE5A4MEum/xQh75cf
         NVPw==
X-Forwarded-Encrypted: i=1; AKwUvBxrqg3xjAwIDgLUumFAnIABFNBm75B6ntURHWo8351UV6JcG8pdbxDV3/QeGEJXzMGnMGyFq80jBQ==@kvack.org
X-Gm-Message-State: APuU4Z+we2H7HFtJZ1xRTAMRUCNsN2Geq+mYUgrAR89qvmqhGt3Js5pd
	6uFSEtu4KrNFCqhSnVCvK5n/Lu4/DC5SXZa3OZylUClYp3Jy25iI9fII
X-Gm-Gg: AYBFou1DEsAYKR1Rhm2R4CWtTmcKyerBFfV9eTyyVqjdwvczEmo7Ll6eJWVMa4B2R74
	v5KQ6TVhIbpQ5symEHkNw8i9jD92p4Jm9aUi0ayc30NmafT4Hly0l3UmzgPtOfTCWHcjk4AO0Bq
	H347H5JTB5Q9YEmA94faf7WWtSJSp0V4GnnTH1J3T9GjO4rp98aCd2e2w2dqg1GwgTUZuJmYkRX
	EwL3dYUTFf8iGV7ythDaDYT2Phtm7LlWTOH5MuR/k19AF9bozks9LB595wLXbF78OWsXAXOKpot
	qLUkgAQJYVrOw4gWicFniJW5pEkRCsO8XAdOCdVJNbwHJAF5Y2fOTSlrTAE0xvcpPaVMz9efO+q
	y9iNstn123s/QeCqjneLd87wB9+fHSziQDDQtpbWyytzp/Piyr+LIuiVubDWKfE8bEnb/qT/GCS
	RxprAWC1Myieb/u+zjQvJi+FBpDwve45S3cn6G39VNIyCEhTM7WwwmaFErYdN/UkWLbMqqgeEsF
	IVZfe1bNG/jQtkK2zagE2Lt9zEv7I3fVYzniJdjcsj3TAEUFWHmlUgGbOkLUq8aYDGIvYOGXNpw
	IN8UOdbLVfdFmk0IbwroFFcAbC0BBz6fmDd5888VQKVzeQgSMNXZrsdNRnI=
X-Received: by 2002:a05:690e:13cb:b0:67b:f91c:109c with SMTP id 956f58d0204a3-67bf91c2553mr1172619d50.46.1793835035335;
        Wed, 04 Nov 2026 15:30:35 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee27bfddsm2429362d50.15.2026.11.04.15.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:35 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 4/7] mm/memcontrol: check PF_MEMALLOC after trying the limits
Date: Wed,  4 Nov 2026 15:30:25 -0800
Message-ID: <20261104233029.3282438-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 349d63tg6ea4nkkro3qwe9o9cwwwzhk8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 56C1D80015
X-HE-Tag: 1793835036-960647
X-HE-Meta: U2FsdGVkX1/vDS1PXnkegBSlSY02vFpWhIze3CWJ7HDTDiGiok6fXKjJmbGKyetqzjWQljfMIN4CNVoD/oExjuyAWqqvAECsq0YM1xdXYMqrgYiuFH78WicZHIFFogy9gmf45Md1CnhJFqOMzK9Dr4Qj3IQ5kN7VEjhhBMnEA53YygnDoIdQGNOFHNS7/WKNqirG2Rx/m12kHTQ+m2dI8nsbx6rehJXlxWzRWaIvGgoYG44IqxXyOnfgcK1kmWhD3Z1AHszVxCjocK6bT9aBkLG7+NuGyHNyyvuQG9kIUiSC0nyU26WEcrHXPDRfghmXPFckZHD+VXkWl1myyQbfGbSkYtUUKPQ3y3L5HWdXmKIj8joCOwcagu9N73Kyy3h6FxmAR+DkGjFIijZEHijy5rWBcXUrGWCSVgVqBr6l0BUQFYoktvDWqt4vlgLRJxDcxjdvLe+gYMcPXrUhidl/wycUJay07Nl3Xso8SBZefr/28WamVUKIMAzKkcPTkZfr6fmqs2EhiRDExs5QzAv5/Ob6fi5H6kNzKlUwDx0Gfe4MsPqlsv0rJ4PVdhvvbbwJb3WMAiLbVafWmrbd3Yw8OQYiuBTYutuL/IUMcvMCUkOLKQDtFJAtey186A0sI8akisAmaQ0IaYvY4ZDjP00leYBzHA7HTdh3oWt85UhvfRY2o9HAzsr/4jwuBE00Lv5xHJQhxeW5AT9YCElbZBVpC2W7XoHe3+FpaeteC4/NHfzG4r+VWoJIFdS0076Lf3c1pDGfGkvSXhbeM+Pj6C5twOCxZtMBFIdUkM+VOfVdjuc3h9m3wg+AV2pndGpRRgoHW3gqe68xsvZsBt0gFE+V/Sbi0s8+Q60cBCiCgE3hvDtpY9rMa2KnL5+MprXTUPjM6/v5VyKicAXBbUVXp+dn9JOuRB2u9RJ/EUdZBuvyukzwjME4cU3ePpId8R3SIBq6EkskkRpy3QFvGOlWWoD
 /r0zPpKZ
 B3Y+bEeOzurVRfLTvzQ1mOlMWf3rSzi+yXsqzqXWhipjnmzOI8xjsTQlxZUeYN/zeKLp6wafjTEQg/mQwepOAn5XBLcBel8f+McKn88nqy0Lvc71yVNeFIFTcHG4EoOdnzwbZbjToeNbyKsKipyOvCKv8CW4SJx7YaR8NTzt+h/Bdyw151K/T8L65ImLw3N+lUV0XR1bDLsN357pX68FxvujZnu+/AK39kOSu2vucEYMvtzZQjQwyi7MgyX8JEAps/JhrOZ8igj6qEJTQpw03uXr6B64+/4DYd5SucSQ6lUbEPN08Ww+ciJOpqLAp/94JNjp0f7fQ8+4SQ5e3FLWE1drmnf6Av2oskMN/3y0v2pEmNeuQwTWzXkScQdH0xPhYdN2LGD7q8jiD3FzJOtzrMql1MOtqr31yjd2Ldo4W4H/uB/YzP9WqYA4cJveu2e39efcvIyK79tuu0KYW7I7Aevd9zlOP9At6GWFlZSnCMvG7skpJrR4hjIjxz5LCm4ptt3JimVz+HfhPPtCiLzkr5VFoLvUtZIwbYJoJR93BAcscPZHHsahPd9oq+xDB2o22wfBFSydOl7A8os26GVXwvY4U7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PF_MEMALLOC charges are currently forced right after consume_stock(),
before trying the limits, so that they skip memory.high and the
high_work worker can't queue itself from its own reclaim.

A later patch in this series moves the memory stock into the page
counter, so that the stock is consumed inside page_counter_try_charge().
That leaves no place between consuming the stock and trying the limits
for the PF_MEMALLOC check.

Prepare for this by checking PF_MEMALLOC on both outcomes of the page
counter charge instead: skip memory.high on success, and force the
charge on failure. These charges still do not batch, so the resulting
usage is the same. The differences are that a PF_MEMALLOC charge that
hits a limit is counted in the cgroup-v1 failcnt again, and its
MEMCG_MAX event goes to the cgroup whose counter failed, as for any
other charge.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 311bc2fa644a3..75b915febb06b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2791,23 +2791,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return ret;
 
-	/*
-	 * Reclaim may need memory to free memory. Let it go over the
-	 * limits for a while rather than fail or OOM kill. Doing this
-	 * before trying the limits also skips memory.high, so the
-	 * high_work worker can't queue itself from its own reclaim.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC)) {
-		/* Find the cgroup this charge puts over its limit, if any. */
-		for (mem_over_limit = memcg; mem_over_limit;
-		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
-			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
-				break;
-		goto force;
-	}
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
+	/* Charges from reclaim or non-spinning contexts don't batch. */
+	if (!allow_spinning || (current->flags & PF_MEMALLOC))
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
@@ -2832,6 +2817,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2927,9 +2919,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 out:
 	/*
 	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
-	 * requests. mem_over_limit is NULL if a PF_MEMALLOC charge fits.
+	 * requests.
 	 */
-	if (!raised_max_event && mem_over_limit)
+	if (!raised_max_event)
 		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	return ret;
@@ -2938,6 +2930,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
+	/*
+	 * Skip memory.high for charges from reclaim, so the high_work
+	 * worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		return ret;
+
 	memcg_enforce_high(memcg, batch, gfp_mask);
 	return ret;
 }
-- 
2.53.0-Meta


