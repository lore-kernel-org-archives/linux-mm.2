Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141CE60A2639
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=eAywusbg
Received: by kanga.kvack.org (Postfix)
	id C9F536B0674; Thu, 12 Nov 2026 22:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C502E6B0676; Thu, 12 Nov 2026 22:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF11B6B0677; Thu, 12 Nov 2026 22:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE666B0674
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:36:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E3DB80585
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:11 +0000 (UTC)
X-FDA: 85428682542.21.4DB7AE9
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1A51140003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eAywusbg;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540969;
	b=lPhTNLJWxyTdTnYf0ca+Wc8CHFkEsS05Z0JV0u8mcBgADL0v9mL0Wyd41qTr5h4KbgEx0b
	cWduUyM1Kgi1IZNb8lOyW7yKZLLU/VKpr2qND8ZHGSG3usegQXTQvb3Y7P/VbEIoygCULq
	ccKTdYXleT51sPtVlAb0R96cPq1Y+pw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eAywusbg;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AZpKqSn+eNMSBHSNGygoACY8QaCFei3YoxUNTE9SgM=;
	b=srqkTYG1mlUernj3ghNSWk8oFRNdFfb2tVL2Oh0pHh/brgkygIqmFl0wJkgvPwfPoy7Zjv
	LJ0cA+yyfkEpwhaZKFoYAJsDyA6vUCVy8C0bwHTQgzAPAaccKFbvgEWFeQ4DVE1KcNzlpb
	RXl5teibnnJmLCYaz/4ukKe3BJ5aI7c=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3720addb068so814962eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540968; x=1795145768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7AZpKqSn+eNMSBHSNGygoACY8QaCFei3YoxUNTE9SgM=;
        b=eAywusbgVvVUMo11ysxr5hnMVD5CT8Yqwkq5XwcSe9fZYbaiCQ6lb/G9M+EoeeaAxh
         lON5PiWqQa72ew3v9l1r9bHQAEwXaV+whnLxw9NvzDmCwf43QPdus9PbG5vi8CLggcqc
         iJFaJjz+KTyBbNfSjpdPpKadYFF3MHrvVw4nzVgD2IgxF+TdGfzavSI8eaAtZ6Ppt6/o
         6rrqg/qn2Hv1DmyLVQX4iGtNYnT71zm7Crz3/+12x12cnsHlfDQJLAzVRbneuVAgraKQ
         /v8I2DXwX7MxFD+5j+HlJ3r7iajN36dEgr1kHwovaghtwmxoIpsCi709t5GeA+Wnw5Wk
         7Nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540968; x=1795145768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7AZpKqSn+eNMSBHSNGygoACY8QaCFei3YoxUNTE9SgM=;
        b=OgmC89SDNfb+hFTtmr42uxwIWq4159mPrOQ+jDGnxZEWYKJa3hyvQWboymn5oLNLfn
         jR6VFmrSKJYGvl7o8LMOo/8su7RXHEQNjIihw7C/H4zxRBjjfkS6bGUkQmDtRXQUSaG9
         ZuUVimvPf5Y0T/qeC1TfnHPa3mImcO4+uMOrYN37Pa55Cxi+iAXKURoaMkbDKrNWaiKI
         ahIeQe2hO1gVGmZyWIzMqqs+zDUTnciCV2ity5ft9y58qr9jQX9sX2Vs9qWt6tTzBgl2
         p8zpgAK4/i3nAJ7yA094Q4Y1ZjA/sncsAYsVbuphT/SRAUjioLrHI47vB7l4LbIPoyWm
         jxxA==
X-Forwarded-Encrypted: i=1; AL+hErHqBd9FVCsGT7351KMF5Ze6l5gH08jFB3lXgNx4LTLl+p9mbgtAB/eUvD5gyZkCCKY3BZVQ+1KHtw==@kvack.org
X-Gm-Message-State: APuU4Z8yo+PLuURMgrhGuvnE41lt/hs+WlGTq0t0iZ4oxmtRbW8hka+X
	ZN8B4d6+JhTyBrwIY5vyRP6Jwpch9PMoRWZg3E+bR8sS4LmyfHNUjDdDmEygyzAQlCo=
X-Gm-Gg: AYBFou2vXqHb5oLQmbWheEgLjH3lSOFwc9bF9d5NNHyB2inr0Wjsbn3Ihtpfs7yjnRu
	tRoei7aVU7DwrF3oTrm4PdkC2dd2vCYrY7yVeT1kwznr628U9yNNaRH0BL4t4s3RbK4LDmapRiJ
	i+vFnrvMiguvjwR+F5fGfoh/it1uoQw/IHYENZ7U69SsIj+eYpctsmlI6TwZMMpiVxq9MGVtwrW
	5+lZImw91KNEHBKSWM4eNUYAlaw8e7pUvvJUcALgUDcLDBdZnQ03nGDa+P36nORrOpeXG8KK8nn
	iM3v2vzRv15MpPmsWukwunfIP8GH9sjGedXQC+gLQ4dxrz6uXw0rBdKysZuiW/mmMI8NUqzq75E
	H9IbIGmiaYArQDqYSvaCPuCjmPc2r6FRuTKTgruHHXrwJYLArmwlpxhs5tsfTAEZuSI3fuaFQSQ
	Z9SHH29goyBWbw2QiYXyEOqJ2MGDr+pn4i69Ucs1vtF1RnVKpW3EqInhEC99hkWcZSt6QccMDqV
	qrjeL/k6IwaW70PKqdi8iESNnQYbF4v13dTRWaLCjBpoHJ1VdIreeKSbB1HN1lX6Ld/3NTMoVKm
	Vbc2fRPdFP3gAD9jqpv6eG8ZNrAqmNz5MBgKD0FAmIYhxHy2czQ6xQ9+s3l6zQ==
X-Received: by 2002:a05:7300:8a19:b0:377:1bfe:14d6 with SMTP id 5a478bee46e88-37965f9d236mr963581eec.6.1794540968350;
        Thu, 12 Nov 2026 19:36:08 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.36.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:36:07 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 11/14] mm/mm_init: make memmap_init_page_from_template() static
Date: Fri, 13 Nov 2026 11:34:39 +0800
Message-ID: <20261113033442.62970-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A1A51140003
X-Stat-Signature: wmkdgj4kmye77ehdnifrj437fr478ocn
X-Rspam-User: 
X-HE-Tag: 1794540969-850126
X-HE-Meta: U2FsdGVkX1+zStTRksOxOIGwsH4fftsBsaWx2PvVQ1J0TTlJm9genG96sqppp/ZUUKoV4KreV1F7SoOS5OWxFfFbGryYJ8QaI4yoRZh6CpzkfiGpBxnKEvYeBpYZaq9QNKQ4bsAK09aDBNCX994sC36OmRi7S2e9ivjTNdm2jMi9hWRA9XvgpGKRcWH2Yiphgcw7ZJ7cFfjE0dvXUQG0YvLNpgebP69GvutUnGKst6p6QMAHTZHy9iX34U294/iY/cMu8Bssl1izJdRG+pIHllmSVUc3I4jFYnvxOC3YASVs6ma3FlOwRIcO2kLyTZLW2I3Yi1bOZPA3Uqe+ASVwlzYbTo0eJtE+GxagTMZufKPDXfiUGtrGLTHEZq2pLi2fKDcM3PEhaXrmzY+o/UXpKu7jQtDwlIE+p1mQQ/W3vAx3vWAajXH6r88ki3/Xin8U5yJlL7uh5B7IWxNRjT6dADjRwYmgvFXvRkwQ8DZVOON2ri9Sjjn8LuaJe+IBkN7cVwXgPaGH+/DyRrbn4HxSX6wkO7CXHt/c3OyRepclp82pXQ8Fgw4KbJXwVDM2ifMQAHE63hlb2ji2UFKdPMHlWW8F9LS2aJoL0cPPuDvdxu4VIaWAAC46fGD5Y0tcQ+PFwh9LowIH+9vYMXRGE1Qxr2ZIPraclxOE6ev01AwJLhXbLuzKDx21hrOFHGq4yxUsWXwdjgl1YUn5M9FK4IHUprMevMgS/RLmAfo1Aq6TpBo6WNrZv/dCJRlJFaNmKx1WrkW2ZSF1zArv1XnfgYT7V4CxyTHfEYlaQfHOHc9w3WtX6cEE5tND8QxvUk6JyvH97h0kCCFjT1xvT7iZMPBAIj6eIy3VxUoDvSLFOD7INlQmsUYSYn6qZ15MOkSyjA0oDz6+mLvO6X2XVOkkCbLiJ8lDpIXljgL8kgRKTfPMM/fjCVE9shZ19anlW0qyZG2+e26cdc/ZOeJnHUjj2aV
 l88PEv/3
 y/clJE7jWEpeC40likcnFcrNvGz24lKwkkilUOosvbIBApx5Yq2Wcp3jfTus00neSTLx2WqDx6faw8V9OZ7NVqhngEaYO3XBNO7N4uDavT7LbNst78RflMKyYP9Md0SfIoJGAmJfaIeVWFVlRoWsGzH9oJ6Q1g6jrObn9KxUX7oV2SKljgJTWvfw14TpgzswFtag6pUDw7tX5wyHH2c0fFbIrGIy6qVLmZBJ5ZybyA+MIRlIGneOU8WT4FdgxmL3Eb4VhDKJNx5788WnoJnU3deqvgdm7eygHf2blqlfZs0Vupgc7enLpXo/ORp7wt+8B++WTu8Q8QpNOLVfl9mnoxLsope0bTleAivna26z219O4s0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memmap_init_page_from_template() is only used within mm/mm_init.c, so make
it static.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 2 +-
 mm/mm_init.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 84de0870f78a..6bf25d03902d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -719,7 +719,7 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
-void __meminit memmap_init_page_from_template(struct page *page,
+static __meminit void memmap_init_page_from_template(struct page *page,
 		unsigned long pfn, const struct zone *zone, struct page *template)
 {
 	/*
diff --git a/mm/mm_init.h b/mm/mm_init.h
index c821aee774d3..7cde357d6324 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -110,8 +110,6 @@ bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
 void memmap_init_page_common(struct page *page, enum zone_type zone, int nid);
-void __meminit memmap_init_page_from_template(struct page *page,
-		unsigned long pfn, const struct zone *zone, struct page *template);
 void __meminit memmap_init_compound_page_frozen(struct page *head,
 		unsigned long pfn, const struct zone *zone, unsigned int order);
 
-- 
2.54.0


