Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AD8CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9308E00A7; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1DF8E0123; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51AB8E0125; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1358E0123
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5468914096D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:28 +0000 (UTC)
X-FDA: 83996852016.19.554CBFA
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 88FB24000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=We+ifU2F;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=kzVK6HBPKniekrMNl/1wxTDnOZ7ysN2N12wgzUxLUUI=;
	b=jq6XDgkiFumvAGjlbTPd7sEsDLdhDQ9ish86LEWf7x4KO5i649BNjuTvhKpIzxc4PiAmrF
	YUSplRWuED4G5YGFNmWF65ci6pwTWlVQWNQMv9B0TmKC+JJm38LettLtHgGIVn7ZocZ9ix
	ASule9u9QruKRch6AtI6Dz7AAj6rUBo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=We+ifU2F;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449766; a=rsa-sha256;
	cv=none;
	b=rcOXFl8+YsCyVS2qihAp519jfk76rUSEaYmTeIszUkC2meKqi4ErduXuGng95Xh6bYr/ck
	77o8YHu9kkZ3ER6OkLN5PqBHoF3WSfRy3jHXuc41l7LevMSws/u5oTh4Wxu6JrgPWlxSJo
	1ZES5nDm+kxd1PxOKT7xVJHWWNos/Yw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e29d65728so32208795e9.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449765; x=1761054565; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kzVK6HBPKniekrMNl/1wxTDnOZ7ysN2N12wgzUxLUUI=;
        b=We+ifU2F/HGgvIlyvYaYKWNk9kvtO0sGrLzL921wDi8BQ4wdAR1BQqIZ4IZpzZA034
         EmMcXVsIIZxc7u13UGm1y8uVS/2lXcRUtlIjXki6WR8R6Hj5FDpSusr5hVB4Oy3m4KRi
         gHKN3jrpfOKuxMKBZDnwJ5AGVTejliW7tIUjKCQe6vi8660dRXnGzshcLNKHHHXduFqr
         W5xb7+Sji2gX/GG+AdnGum/64Y/tEvlskzJ/QvA21DKFpXwW2ZXFeo3t9UBKylBiOILo
         en7ltBDKNHz6VaWqZvyTKbZojuLMJYB7F80rYCD+FhG/EWPS2JsSnpxwQPq+Qrx66LL9
         x5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449765; x=1761054565;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kzVK6HBPKniekrMNl/1wxTDnOZ7ysN2N12wgzUxLUUI=;
        b=h4xNzIXs8jgtETP4jxoQnUMFDciYuD4qLzeHRs6YUvuawFhyLYwGgI8pJwBDWkTfGA
         AhakaTab4m0PJxNPLGV3qKNLcrZOLVp/pXTT1ry9CJAaWa4YGDf+W1Y6P/CCbXtc7PvQ
         lam3xIZ5cYN8K6OloVk0vfBUNatjIm19y5qCRTRTSXnHwLwGNDaiqYm7p/QqYokwAfb/
         7JaeTXwhwKS8zAWZyyLEtbrQL3/FoxSfZ2Ai9mP6Lv1zdVoMEdG8K2J+ICR5HOUXZ6nY
         T7oDyMf6b/jRaFDzdJkQr27DGU8rmFWlJNj6K65iLISMEAu4dwLHZ/WZNBuJGJfp/0Vr
         zJNg==
X-Gm-Message-State: AOJu0YyNmhprVql37/hIOEQzgUZjd9pRJVELgEovJYN58M0VG5lMj/xr
	qbtEpQ6NJ5BJGlWlo85OpOAN90Fb2vDD4e2kZ199IKxxtIJBblxDmKwU
X-Gm-Gg: ASbGncusYfX1AywNtELfCT9JesFabS3mgC2mKGHMp9ncnToOMgPS4bD2kVM47V2yEwq
	v13WO+/UzJIOxv20jRWktEO9AFQtm6RJz5t7+lh/Rz0mi852OxnVNJyHui3IEkQyJc58nIflYgj
	O/WFfV/VAJXH3EVGpx0XKKjR1tcwZakr7vJ20w0AwelzxBYtxmQA3EUF+u7jfLRNl0AM/4lw3ta
	sAAt3szbwgrRNsJNdmLFoW6fOWgumY8Liyn1fHQfoKbsRASpwbVeE1FzJgllqK5PSgDGyhpHOPz
	XnI0Lg7XL8toUboMYVFaqs0TRMRAcSTX4ADtZIF9QOZ972PxKiFqz/jeWeGAgGCf568ORYKFzXX
	FnsM4tQgJTnSiRGwOQ5j/KzZ+/49dixyH7sdvPyBY
X-Google-Smtp-Source: AGHT+IGTdR9ZIC/BK/q6/w7NLAxJyFYS16aPRSDNs2n92a3xEQd/bTRgeAqn5DCquG5+pSi4g0U3+A==
X-Received: by 2002:a05:6000:4313:b0:3e0:c28a:abbb with SMTP id ffacd0b85a97d-42666ac39a2mr15589858f8f.13.1760449764872;
        Tue, 14 Oct 2025 06:49:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb489194dsm241104065e9.12.2025.10.14.06.49.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:49:24 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 3/5] mm/huge_memory: Optimize and simplify folio stat update after split
Date: Tue, 14 Oct 2025 13:46:04 +0000
Message-Id: <20251014134606.22543-4-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251014134606.22543-1-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88FB24000E
X-Stat-Signature: kmmoxt9dxp3xffr3bw34unjkbhn7kt6d
X-Rspam-User: 
X-HE-Tag: 1760449766-634589
X-HE-Meta: U2FsdGVkX1/icK08MrDfYw7j4lbpyQRk/ATJf6Y2PeCDJSrUPEpAvXSfYNzrixrrlyv76FBVfmRI7XzvSl2AexSCaBXPX3kVmVXFrLoCVAlwGb1AzH9f1U0c5uIFD+jxqhfrUnXAhBV+LL2ZG7cHMPMiN8V/BpsjSYhrN+PV+M9MLqfejEzFV1HzAWSvCEj+duKUh+TKgPZz1wE3aAy0Vjr/RlNbs2AC/o2QjbJ+q/+iwRBQXrChMoUJph4W/Wiz4m8+JyXUEJQJlvm+fP9sNrrySNMjZzz4pNO0Gya3sEXjjlAhMxyV5ddK5sMe454sgfCquHt70CM3nHRwhgEU13LcaNJpmz+oL6KI/TD1pYcbUD/ReHdI12VfnpBY0xR9B6m2Ff7R7IyHQH+Vj7kBjpfoQJ4RndCmX6mokccRdVXuS+qdxO78/hTXQiYSrtJSDdja+xlpH9LC7OtZOn8jFt6o35pljpg4QO2p+zedbgJ/2g122kEKAZnO5g0UEY8McPzcNIJBJILuYGLi1MEnVI0MZLFs5/FtWnJLItdXv5vfmJhXPh8QFiWc+2IHgaYY1Toqt5VVgHy81O17F1JFJmzjmb7WBdzT/BVZSgaTNZmpDCFcQNfZngAN0Kj8FAAXjNXGdNMmRBSm4Uojq+J0qfREVXizoyRsgHkvZ2+l0SvFInbu5j7CPIYQ0HFBIEdDP/13ZRZDnS3P8SnLA7kbUauHamUXkua4frNGS+Yi/BXTnAc+0tNi2JMgCUUhCFDqqen39Qd1Rv/JA52XfbC+OzhoGwvpdIg9fe/DSRUjBGK4zYMP5d9xs18Q6ZjYw1l03dvVLqjX9+mOm6M6EjNLAvId8OUOj2ARkSN+k6c7ggAKwKPcnHmcuq/N4IQxqJrcJUhb5XTKg6hxzOiDTayn7qH2uhSjnqZPqCVvJqReexzuAmlqhz0MhyszWw/iCuerU3rDZ1hxsOuHMJp+Eev
 hk8UULK6
 nuQqs/VPKnWi1quu4xuLiNvQQJaYOB0tIFDPDP1aJcU0WoYJEsEyk1mxJwcmRj6Z+OFESVQt4WpMsHdYj/sUCY9ka89u3JvDwFwi4NAVZV/dtkUK2+QwDFoeSyt0uUOWEWs3JTFq08cO8ifnXcxmGEE41xdhGkNDPt4IE2a0CRLe39gtGyXZNUqoG9Vy4ksPff+8qZApsYsX/csJyK0xOdz+vyoBberDXDUwqXvbEQynhChvqzfMJgfpNGprKD4xs6w6/5WHGBG8TRWUkW2Slfy6nubisYxBpze7sQpgmPC2hnuxsp0tSUh2S3oupv6gk8FGIgxinqjaMyfDeZIO3Y0KxYaiunI11HhmsES+gwOsT4udGB3kmtm4E/syb20Afgabb75mya3Ulm/wD5ptJ/YP6liXk9smxTT6w9CcFQbW+XfdNiFdlqL9hZiyvpLY6aMkvmRl14XIwTTS+bkUUeZ8DqXiJAufJq8BcN+6KezlU/S06V49pFLvsLbmWm07vCjTfd2dyOz5mCOYYabU0TammIyW76/yfVt0/kDWiQQZ9q7SmBFwzrvnyEx8cXDSDghRW1lOHoI532LwzKZzvnxRycQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loop executed after a successful folio split currently has two
combined responsibilities:

  * updating statistics for the new folios
  * determining the folio for the next split iteration.

This commit refactors the logic to directly calculate and update folio
statistics, eliminating the need for the iteration step.

We can do this because all necessary information is already available:

  * All resulting new folios have the same order, which is @split_order.
  * The exact number of new folios can be calculated directly using
    @old_order and @split_order.
  * The folio for the subsequent split is simply the one containing
    @split_at.

By leveraging this knowledge, we can achieve the stat update more
cleanly and efficiently without the looping logic.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bafbd66769ac..482a734b61ac 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3530,7 +3530,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	struct folio *next;
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3542,9 +3541,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
-		struct folio *new_folio;
+		int new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
@@ -3573,19 +3571,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		pgalloc_tag_split(folio, old_order, split_order);
 		__split_folio_to_order(folio, old_order, split_order);
 
-		if (is_anon)
+		if (is_anon) {
 			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
-		/*
-		 * Iterate through after-split folios and update folio stats.
-		 */
-		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
-			next = folio_next(new_folio);
-			if (new_folio == page_folio(split_at))
-				folio = new_folio;
-			if (is_anon)
-				mod_mthp_stat(folio_order(new_folio),
-					      MTHP_STAT_NR_ANON, 1);
+			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
 		}
+		folio = page_folio(split_at);
 	}
 
 	return 0;
-- 
2.34.1


