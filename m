Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3B4CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3791D6B0092; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357CD6B0095; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB8A6B0095; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF29A6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2293A160A4C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:10 +0000 (UTC)
X-FDA: 85315179180.09.4B23C5A
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7C89160005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Cwb/QSX2";
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791838508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Wqv1pEc3eUHWVa1vlKnSnpZ/TcSKODci0Njc/4Uwzs=;
	b=whRVRPxvHPc7RKvbidsDUPWwC22GGuXvPNZbNXu20we4NsQl5cgmdRKzC9Vgo2ci3uODBv
	wQ3PqjJuTorhflKb12JySWPxBOdSeIUOJHcJ+/TUE/2JEykP9n10KGPU1tOjhm/K+7bFEx
	7b7Z9bAHTCL/uh/HhmMcwxal0386oa0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791838508;
	b=KEbDCZnUqvgNfYNiJu0vyKrqZMaivCwZYQN5lGAD7b6c491ElkUfaYQ8DTdDQVVcRiHYJb
	MaaB/+ssQ34tQncDwZ8GbC9z5HSmapq/StyUmvjJaLc9xWBxBISgtTwc6tyzNpZySJhAbQ
	z4Sx/6RtIuyuB0R26DiV6kUcZvSqpFQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Cwb/QSX2";
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4be28b82so2204103f8f.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791838507; x=1792443307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Wqv1pEc3eUHWVa1vlKnSnpZ/TcSKODci0Njc/4Uwzs=;
        b=Cwb/QSX2ev/ggDxL+/XeMwBJWD8ccRl16wdwau+M4BoqOdp5RGMe5J8RpIlQpCwKhq
         Uv3fECnDHY772KnCdyNYPzYDGPyFRAmieSwZYTKe5w/6X978N1ecONZ4c4AQwfY0XNUt
         pA7Mo6UqCbFmjiyb6elQ7ncgi4Wu5k/WH31ADxXU0DxronFdTQZqDzn63WTMG0EdvKlm
         bLJkDyw2o7PNqes13fOd6iU3HHkwZZWdYnrK66PMbrw77ge8sfmtxW9JNS25+zDiKxx5
         4TuBaX/9yQSwhJbDN5czTSWA+0nsNeV+VYjAep76/FEkPdrGKpb/UDbNx3y6j+xQ+pAt
         2vZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791838507; x=1792443307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Wqv1pEc3eUHWVa1vlKnSnpZ/TcSKODci0Njc/4Uwzs=;
        b=WtMVsUe2k9hEmQFfCcsETolQVD9iO+ygDJLx3zZ0/AlpfRPOpkPDBATwVQcKUHhy1g
         Y3tOWdfe9DIIwh+eQ2ycxFXafsEwtgT8/JBApYdbkKokmDIJnuvPiqWF/dHrkoodnqoI
         QSbRxajqpmhciiM4v80RkUnu6EOD1U4MJfKqa2dY5fhMcBhuacYmfdc5wZCK6tLH3SkP
         am/mVhrRSCuM/F7bVBRxMwKwsTvSfeopNDcUzUAE6gGntL9QIAiRnoJjBdJ1cGwr76MC
         o0foWu31eJDbqKORGEoVMEXz+SHe8/R/h0KLFv4MXLH+f0Bn68GapnkJN4uXBi7ldFuJ
         YC2w==
X-Forwarded-Encrypted: i=1; AKwUvByWEwqLVEGjMc+xL1QcLW/5sCGXY9+LyaaL2d3wbTqYQinpUyQUq2JeG5LxTiwWa1AcfTVBMDfEyA==@kvack.org
X-Gm-Message-State: AFq9FYIV93Ye26IaWk9lDEYakap8SIvRucS7MG6ZdC++MP6ULObmCDrO
	d4AnEm2wCCulES7eo55O36mDsdpl0DNJc+M8wAyrHOCsxXHcqwVUCMaw3mpTOCiuyyk=
X-Gm-Gg: AYBFou1c1PCEDQicfrsZk0tM7rj81Z5bK/n0i5uVpJ4GaJzbwLXzJk3VynEMx3O7iSL
	4ryKtvxOItxj7PIaQJtDA7nhQOqeZZI8CiF/ceazXKJZbQfADxlheBH0cfTp0M9U5Vkun05sCrC
	kCt0Nkv32vBHc3+T0/SA38Wz4JRbLijeuLsI98gwW9QF+Jp6XV57cbDP+/ndKzjoge7fI69G0fe
	px0kTaJyPZrDyBw46FxSU9NUBFgMr6wXI5Cl85jeUr4ZrERlhrkSjqfLxynJ8u2TzWm4/z99qMd
	5mjz/MyxyH+dxhDSswGj1GwgsxPs4C1NPDZuuIlCcfVF4iXDFXvqlQcLVq1lFTm2YEx1JG276SK
	G8PW+GyI83A7+IW+goRvq2VLHKaFPHckHhiICTq2hq2/Lxx2vx01NRg2olfGP3r6WnKqm9amB7O
	A6XI8jHTMTxVMcvxNVPZAauUYbZtuWH6/drlZEo9h2jS5WJnIW0wFuawFYf4fWmSZF8lYspOUGH
	mYnBgfsFJG3hVm6z8kXSDWpeBOqgzvj+8/TnyDbMImja4Xnqk9hfHykZSy1stbY1yI8AmNslKk=
X-Received: by 2002:a05:6000:2505:b0:487:27f9:840 with SMTP id ffacd0b85a97d-48dbace65bcmr20779470f8f.53.1791838506637;
        Mon, 12 Oct 2026 13:55:06 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0514ab1sm1895744f8f.0.2026.10.12.13.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:55:06 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 1/5] include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
Date: Mon, 12 Oct 2026 22:54:43 +0200
Message-ID: <20261012205447.2717801-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012205447.2717801-1-max.kellermann@ionos.com>
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7C89160005
X-Stat-Signature: oj159k9wgb3478pz3dcawyexkyyamb8h
X-HE-Tag: 1791838507-788864
X-HE-Meta: U2FsdGVkX18EE/tyhmzgmHfCH/uIF7opUgcw50lOcQvZeCuTN5ECV70G6AzicEnWWPZNxBLc4NKmtr9HzlrHKrOOMBOj+aZTY8aPcI14adZi5l/ztt9LcQHcr7BkCPdarq+wPwaxgbnU2olf91qcbSUffNDueoj7vFh99uvqdlFVng7vhq7aHMs22VEXuU0YDO/G1fVj8XW3aSokxOmiplDKPiMBgTE9l8tDtfXjliddKSRHgH6k6AErAu/hOSPXXMXFdnswimKbShfuCIiET1dYP0lL6cSrP1nIHzbTTIyO19GQwwNbIMsqFDwPAP6K4k6hFV+Lxc6lOXY8aOBp209mz2YdsXIREgY2H8cx4gkXp+e+3GTlI9p5oilvL8ypOO0WSfWUp7nlmrNWONLsyq6qMQTqedZ/RxDzx8e3KZyhWwHyZx3lLkRZYLJxE+evGvDCSAkcBYGxHrF4U0/YNI7Y6vPB0GIXfvn3ugmw/EdtFmKeU/dRHfaPvJl8zH49f7olXhyrtR7eLcsbtjLprURUsOQXkFyuqz0sY2UtZX4pv2kfAnbCPYYJL66URX1NM325XX4M2s58ocAxfIPpec5P72/AHrRpWlWwPVNNRsibziWdC1/pPYSqB0TTpKMUncLhJliMBstdNR65BapMneFwfv4yaPBXPHmPah4q7JSPBYd7YJxZ5BLSaUbpVz61Jn2kYu8fO0FMWDd+Z1xLvNZuNVzXHLVPC71NxMOVbgKPX/Yxk18NiaurKZ86LItwRpFr89gf7yJ+2s8IHt1j1K/5C3xXqXGgzFjwatjoxMy7C1slp5p92W5orNQSzsqywAlsUQdoIvNS3AaBice9YaAaENIloenSPbKJOsfML1FJWiqcDbXLVwqIyjJCPAEdITmrIxK+ImxkJr2KDuCMkY9gdhD1udwlwuuqtCPsZROWR/kw561l1aPBs4GymESwuMtlNFd8zXf3gv8IzaZ
 KPuBug4V
 U2ww1xSY2uZhjcEYu7GhrPuV2Or4FpOUZBL2EidvVq6BM0p2Vug1vebCYVd220VzJ//IaZFihAI4q2Dhf9hexwJkoKTqEn0rlCpf8FhLetSjy5QbVQG4EuLqgz/ETEDXexueEZ9hbh7d6vJ+pBUpv/U4e/twwdv88rN45PhAkDpmDGMNE7R4NN42W1mayMkmBDGzv8z/ddTzAPuQRDqGj+9QWCWQpZV5LfAcfGsxGjfL3JO7E2QEOeczf2PJjj3JfbEjIKP06r82rSuuhRO1DbaTZzEwe+COmMsiKYpFYXu8deXm4+cGg3ouTe4LyFtH/W8gdAvVlp6ddLLqC/enT9ufBCdfTTaHH2mZvYxVQUOL5BinqT6eGi3gcAtYWFsRA5HTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move some code from hlist_nulls_add_tail_rcu() to the new function
hlist_nulls_add_behind_rcu() for callers that already know the last
node of an `hlist_nulls` list, to allow constant-time appends.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/rculist_nulls.h | 36 +++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index a97c3bcb1656..054e477dd093 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -115,6 +115,33 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 		WRITE_ONCE(first->pprev, &n->next);
 }
 
+/**
+ * hlist_nulls_add_behind_rcu - append after the last list entry
+ * @n: the new element to add to the hash list.
+ * @last: the last element in the list.
+ *
+ * Adds the specified element after @last while permitting racing RCU
+ * traversals.  @last must be the last list entry, with its next
+ * pointer holding the terminating nulls marker.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
+ * or hlist_nulls_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_nulls_add_behind_rcu(struct hlist_nulls_node *n,
+					      struct hlist_nulls_node *last)
+{
+	WRITE_ONCE(n->next, last->next);
+	WRITE_ONCE(n->pprev, &last->next);
+	rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
+}
+
 /**
  * hlist_nulls_add_tail_rcu
  * @n: the element to add to the hash list.
@@ -143,13 +170,10 @@ static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
 	for (i = h->first; !is_a_nulls(i); i = i->next)
 		last = i;
 
-	if (last) {
-		WRITE_ONCE(n->next, last->next);
-		WRITE_ONCE(n->pprev, &last->next);
-		rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
-	} else {
+	if (last)
+		hlist_nulls_add_behind_rcu(n, last);
+	else
 		hlist_nulls_add_head_rcu(n, h);
-	}
 }
 
 /* after that hlist_nulls_del will work */
-- 
2.47.3


