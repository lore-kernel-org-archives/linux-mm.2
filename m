Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEB5606D831
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gS0eLZ4n
Received: by kanga.kvack.org (Postfix)
	id 151C66B05B0; Wed,  4 Nov 2026 18:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB056B05B1; Wed,  4 Nov 2026 18:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9AC6B05B2; Wed,  4 Nov 2026 18:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B718F6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5386AA04C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:34 +0000 (UTC)
X-FDA: 85399033188.17.F31D22D
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 83FC0140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gS0eLZ4n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXyZYe/CTboqHUSipMlaWiZYB5WKA52593Qh8Q69WAI=;
	b=tJr0Wihqha5cvQMGXyxzjZf5+hsxQvz3IZ77cns4zNxNrujMDWMveC7RPITEJJ7vC8q+Jx
	53/kW2LlK1EqJt0tLHg9CEQpSPLCZjKpk368Dtu4b/654SpbSISLgmxe1Qxk66Pt0eAIzN
	UyeEiaomAt1SxNGguFAFCkHDaeaSbbU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835032;
	b=fH39oa1njk07mbQTNP+s4g7JBgPznyBuHkRenXf9HQhCwfiQoxDAFXaa6xzyCqOF4Bs9xD
	4W/U3flNE/pOG2TZUdrRJOvRFMkQINbBBmGbXlJvPXCD/avA4pWl5kQh0x5WUl+clK/2Iu
	dp1LSW/Sj2LFP5JgtOvmYyx3crTt6Qo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gS0eLZ4n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b0d126f631so14215307b3.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835032; x=1794439832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXyZYe/CTboqHUSipMlaWiZYB5WKA52593Qh8Q69WAI=;
        b=gS0eLZ4nWkvJvj6a3naq5Csl2JGYs2uPbU5kEyIS9HyX/dEI9g03mMVd/0ScJveM0c
         sTPIjN6ykUtBiKdg+m5mQeLznYipfxkwXGIsKE79ebAVd9lutesgvWvtKG/eXcH4/lOH
         fGLcoWzteADYm3YG5Y27RN1WjP//mEb85OfPrhftSg1dLMAiYdfp56aPjpFBwVLGfn7e
         Jdi8ok7tWnmmvkMvq7bA9uXMq1kPE9ZKsQ6BlpKeesxhY+U2TItna+8H+l7Tmb8Wcu/0
         SrFXRMTq2HajYocYGyZMOMm8RjIge7VCQPV0MvDYzL/uL/9c5TLgb1Olo+wiVrSy0P4b
         furw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835032; x=1794439832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RXyZYe/CTboqHUSipMlaWiZYB5WKA52593Qh8Q69WAI=;
        b=j1ArsMyEav8uG98Dc6onkzPvdijh545xI0rrfUa2o8RH7vs++kHGBAAXBJoxSUI1rS
         vZYMvIq4ixFB5mXNhaQAA8SiJl9MB/L6t7T3p5yIHRbqI8qI00LW0mwHFtbgFv98Wc5O
         rVsAcG+fPlbR0QWIuDSf+O588Fgf21Gp4ZEPen7DS7oD3yxIKEMnHobg5w1glWtlhche
         vN66DkdIBnGKcJO/i13LGQKOkQOaFgJlQLRvb933BLOthlE7AiQ68IkqkDqi/UJ2YP+r
         XkJCrjupeGV3+5DfujSIUTu25nXX7ZvYgAaJP+u8JWTwBE+K+aR4j7rP5PRkn0JqV2iQ
         GV6A==
X-Forwarded-Encrypted: i=1; AKwUvBw/hyMK16/UGkF1OhaE24LTNN/4kYCtIY2KFm7cNII9wDmcxWWl/MVBJ+ynsQadXRQnRjejOOQaaw==@kvack.org
X-Gm-Message-State: APuU4Z+5iFg9aGYY2ditvvwhMc4e4636kuyoZoqaxhNahqfn1RytOiG6
	Y2eS3MQqcEi6fqvhl4bIftGfnNGykFkV0hCku8DlozJ9adewLynTFNa5
X-Gm-Gg: AYBFou3WKyVyiVVT8aknTCPJqhnnhcPMNbQpBbH3MzKMA23zG1v2xsO0DsRgefj5RsL
	2KO534jXWi1xTUYCfpFeVQVjiJNbcjeDM8eyCqvGIeTZLFL1Cpq1BPj4JgdctoEOIaWQsa5Ay/O
	H2PkZXIZzXuUhTg2Z8/Y3cSOBGJeKevLnpo5cwKdgcaYTcfJTN9S1hezRHaEbHsqEMpkDrwQYo3
	HfsjTWnPsHlk8ab+PygWSOSuveQnI/q+To7Ls2t8tfpGFQ34mPvGQ6RDso5w6vTl0JzP6KjGgK9
	qIdNawP6KiYYZ0uDIvQSyXiuLata1g4oMff9gmlPyQuLaQTE2UHhNoE9nSnzJcPXahflO/HU8Dx
	EDhEDKS367NbA8S+bkyw/9Z3vfBM46tBhhu16X4UGEWiARVSGh55eZ6uujBNzUVeLKc7FPq9hpa
	PV70ZiMh6+YK+6GSoJslxqi3R7p0bjkUp/bTfS7MVLgp5hW6JtVWIDG+mFLXNWaY/VUP93uG0ux
	h6C6AWmqeyxh/LiAn578erUdjjFrPJIHmiz0Mn9Pn+eFB98yc2BhngNHbjrbZapEl3mYScEOuaH
	kbcgzGYmR4qFzb4y39LweA8hKAeO4Z4A5aHjqkDTZz/W3ql940ZFiSCZs9kSuVW6XSnaiPxjgiZ
	4wQG37w==
X-Received: by 2002:a05:690c:82:b0:8b0:eb6d:d887 with SMTP id 00721157ae682-8b2b678e12bmr130360207b3.56.1793835031679;
        Wed, 04 Nov 2026 15:30:31 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3098c313esm29215227b3.15.2026.11.04.15.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:31 -0800 (PST)
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
Subject: [PATCH v8 1/7] mm/memcontrol: flatten try_charge_memcg control flow
Date: Wed,  4 Nov 2026 15:30:22 -0800
Message-ID: <20261104233029.3282438-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hh1bnbkigw3131i15wx9njtcotg1s7gp
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83FC0140007
X-HE-Tag: 1793835032-145726
X-HE-Meta: U2FsdGVkX1/ftDxn/5D/mzBaYw119VQx3FKfQPYEtpbg5tpM2awX0qTkte8cImhqsbh3VQy1Hxt02feTS4y5waZPMYGqAuIy+t5SDPkAFhHuTLfTiLYaBGmK3UdcPXha/ciHH3uV/tlS1MpuaNXFZDe7kAkh0HmD8EX9NjA3Q1SwmphuQ5etiPtc/OQL0n102TXrNezbDDal2fIQe17IIHsfn2bFFBJvaYi5HE215lNFaa/w5Z/qxRF5IN5Q6u6BQvgzp43yCubUYImHs9ZAReVFZQC2XPyeQBv8WkL4uDglgAGOqs/PSDY4G8B2vPtWP2EhpxkBdROUHSTRXTEyIF+OEid9IXTFSGnhM4BOlq//aPM+PSAdduGfqL71QA1rZOjTZEZLjiKOdSlecLUcYl4yf23BdR3AFTEyxAeFnjX5KBUFgQasvbO7q/p51Y+v7nnZERvyHPqQAvZk9nuE0vHPaInmJqOhh9oPj1aEB0O3X+Ipdy8xVIIaIifm1qmJJ0DjOvwoLUtW8EuUd8hJcsqvp9eo5UfU4j+XGstk7fqRSq9H4fl8DGy59NVc09HiTwBq9YqB4aLggba/UZIiWi5m32nEqYj/KzId068TN1tjbFriCYgomVv+P64oeAR4CeqxHmA7U3JpFGmja6Oq8swxbk3eXUeJAz1Yg9xqiZtCcPz0ojiVwD2lpnz/ZHfzu7+bgew3LMQozs4ukeWROjwxb1izY6sE5kE4Vc5s18xN5zZEU3PpgvVvcNKfVL74LvEI3g8UlMaSjHKu/O4xIrAiV5ir6eSsZ/a/8t74aLtzmmCsG5q+e1garDIWHRAUsWmFfVskZLegzQ3if5wRs/2LPHxG0+vuIiBFthIJyBHprL8ZskJIgiMdAouJ/TnB1Lim/reEbHOR6uv08ynEX9iFaSqQuce3AHexO3veGUtD5fIans6Y+/flFPw1xH5+4G75w+blvnVNGZzphwt
 ZQmFmC6d
 Asz9Bl2fIgzPh17LFG5L6DVxanCpEjUJ30cfR6g7vhy4LHGeKfUyCDtNf/AGCfSLAGaZfBD4poIkYmGUw3nP0eGmNJBn4ZJbrrzi1FrQZYrcsKgJZUCn7RZI9DZTkfTxZdaQu+rdZKNuSpq074ruQoPM7YK8VwwbfxJyNVw68m1qFjvAxZ95M/ABk4J67TKqQXiD4M8CHzJ4MndJEKA2UXBu0hUPQMG6VpgqsjkX44yYrqku3lJ2ofxybYT9jbmXT952S6ywQfxTtPiDsEXLgYAOm+vwcJOUgl8cd2DHaGCU7PqWkuHQW0LnWn31JMp42HQgRateaQ0iV3lSmFCl/pfqgUjbCm96J4+hrKN6tfdD4m0qM4YY75nGv22E0aQHwe0SXS3wGNWpukauMm9DO8jZD+yGGDA+2KEpc/Rctr/6Z5UKjQwneyCOuUUizjfFrLBE8yegjz8muJ7lWD5uDdEJtH4de9Iow3raRg+FFk5gPoJMjP6Ztl1KASdSpDBE+ZnyFt5sMgDwn5/HGLmug+qmwqG6mhpcW1TRuko4RH37NH7CDjGlOLz7cbuhZaiouH/FOdYwqgZdvia0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ffbcea28a608c..66f38efb800ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2811,18 +2811,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta


