Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD587606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DkLARLK0
Received: by kanga.kvack.org (Postfix)
	id D98AE6B05B6; Thu, 19 Nov 2026 02:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E9D6B05B7; Thu, 19 Nov 2026 02:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10E96B05B8; Thu, 19 Nov 2026 02:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 935A06B05B6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:00:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F48A1A0972
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:03 +0000 (UTC)
X-FDA: 85450969086.16.05FDD73
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id D55B9180004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DkLARLK0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niVF9RygUWyckhWxTzwkqqzSpVkRZGJqdyALrrQwo64=;
	b=fff7Bh/WOHjRzbZDdnTUUfPZummqnzU12jIUQzBTrlz5Xda2/dkEENQHLtWskn7bCqCgX0
	WE19RF7rsZ3v2Swd6BW7y2NGZ3g9P5AL1PjcOodlXkZRQIogGxDon1IL5ZCa2plljP5fD3
	lWBQhksnQJHn94xjzg3wAMqFUH9Fnsw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DkLARLK0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071601;
	b=JlyTxsVOvDr2YFgBsRWsRjijYdV2qs1oAZ54lvXvUdx+jVozqWT6aWM9RXeCh0YBfgh/1o
	guC81apfNHv5uxENVoIWW8E5vB2D61qVMrmC+rUCO2o6Kvj3TT9HRB15aJqSyvOhS25yd+
	TZmx1llXVee2z1fWURVlOHq6Co/qMVs=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ae691283ecso385477a91.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071600; x=1795676400; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=niVF9RygUWyckhWxTzwkqqzSpVkRZGJqdyALrrQwo64=;
        b=DkLARLK0aPxjm9Ft1aW0pd+vgtH6S9PQRUSJw2f69XlJETk8oUh5BG6KejjzThC3LC
         vG9gp0rzB2QAOAcuM96C/DlVNkQ3F3j7mSqhCNNSWgmoEefCyti/lyjXZlO6J9ilmkTJ
         GivTpPjnhI6iHRS8BC9peILjtu7sWkgfOHlksOfWB+zs+BHFVkgNiPhOzidrUlttlM5z
         ydTDdhpf4AJJEFyl/oHwpuh2ccIIQwa50Hi6WyiPe4+cfRR9ojADKkyU77RgUXjmfpef
         m+CNIJZdTJixhTekGfB5dfy5pdfkIyjTMfxs0OYJH/wKyiLpCe90lgNUSUJ+YVUJ79iT
         H2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071600; x=1795676400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=niVF9RygUWyckhWxTzwkqqzSpVkRZGJqdyALrrQwo64=;
        b=QSzUa6BAqbLDAfB5rJlE+M+QM4DoK+t/xsjDHfdNDu65AkZjVKHKfJSKKv4hO5Qwr5
         1QDtTK26BtgIuTkiU+GHLqA7mdQ+T6iEmNl7zdR6fClwiFUGRtORefQXLEIZJCSppRd4
         XGzTVY1Iv2/oiNLdwelG7gLBZTFmtHSfi0gefmWns1zJs1w2kYDdWaNsGmvy1VxEGW4+
         Tz/A7NUmwkPx6W4PfQ8Wuz+YagZ63nLT6Po8Y+c++eW7xcNodjeEN9mdjK1U2Su3+ClJ
         G4v9KxmGzanf9lkLfeD2cXylRP2/tvFFqPAjUMgvP3v2iOb5zX/XhFD++Nf1cVPqUkOH
         c3MA==
X-Forwarded-Encrypted: i=1; AL+hErGj5CUWlwCxF2L4hYnSW2LwsL+/ppZ16j77He1TABiywUjrWn+rm1z7QxPYdKYrFqlK4vePK5r1IQ==@kvack.org
X-Gm-Message-State: APuU4Z8neYlWkc3cLbVlmF5fxiT/c0H1AOfOC7PtAq3Mv2GRGlp0Lr6k
	1nafgU5hMl6xdN3OUluIZRq+rzx9vixGVKITXub3CrO0oj+lvMSprP5GfGcXbrDmS38=
X-Gm-Gg: AZFdTZcqJz3UMYY5Rsf95g5cl+W2eI8fE6pjXCNDBeZIh2TKZ8H8L4KvMYH3zsC4bxW
	PGXdg05XuXZvLnp9kBlTTwHEk2laE2uDEobbdNwCRIsJh8k4+Z7JAkbLs5Q6B6chkKPLwAadRrT
	fVHt5nrUF3UdDLCId+Fpj6ph+N9InYjp5S5AcQ+iPSo4c1IVDAK0hq52iNjjWDS94G++AFy0kZy
	2RkGRM4f80bnUFALIF66zg3HMGpSn8w0kBnpy1R+FOVctWVCs4ZzhDjR7g3c9M9L65fs5Xk4nHX
	Ukb99yXp2Ne7Epw7pt4ov2aVSRyaMjxz78suLM+8yIjUZS3LD91zEQxyFmx7ykiXyen+obDjdH9
	SwufS1jVeZkEmYjsxDzHLcrXCOd1yGrNqxZ7l5dt4j2jna7lJz1j9nVixYowP7srlLlKPqb9SuG
	TKc7GfNh5O+s13E6qEabqt0Ss926ViyG9+EnODmhyEa0wGuBl9Z1poThebbfvKdU/hz0Y0oRekf
	AJG2/Z8fBk0uBYYnTGbh67/6kN6Tc1gqtLaRwN75Ihg3/0MBhg2BtUh1ZJK96KFhpwQaRxxLNh8
	oiac0+0HzbMUg9h2ndRswwtAQN9I6XfpBFruBe3IuJuCPrdNaCSKL+tgChA=
X-Received: by 2002:a17:90b:498e:b0:3ac:9ad9:6afe with SMTP id 98e67ed59e1d1-3b40a32d9c3mr134496a91.39.1795071599193;
        Wed, 18 Nov 2026 22:59:59 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.22.59.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 22:59:58 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 2/7] mm/page_ext: fix client data alignment
Date: Thu, 19 Nov 2026 14:58:07 +0800
Message-ID: <20261119065812.89959-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D55B9180004
X-Stat-Signature: tr3x5jkjmiq9ohau1rpgnd1bw73c3h45
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795071600-724911
X-HE-Meta: U2FsdGVkX1/5D1evtbJUNkIlyyjFOXvohYoeqtQWFD7V/TC8qcR9s7GXB7Oi7/F4KcV3BBesLvblDRzcylLK3pO131RXvKjK1Ru6bRNjOUAxFcwcMdRy0wdAPwNTE3ZLW3/gA/HHJiQ0v84O9h3rw1Gq4mYMw6meQUgxrJY//lt033oin10kIQJFDEiKJgHnwArCYrdrEiLnJqo9406mme8ShAZ1yYcDWqaRiHqyZrTKadMT3dlHzJpXJn4Fq8qdPkxZmQfVI+yX9QZ2sVheSjTFrhmonfYvF2j1HiDwVjznEYnphRuLGPgi4b9cWItjGzgDjkQ8qineAyYWP84YpSmaNg60nMyMfslvU+1qydkAGhV6/PJhwYsP8iJ9chY3FfghNu0X+FmySEhgxQ7OXsjmI2rXP06d1dY+j3np5VSgynSW1i8AEFkYgF4F32fWCq3WPyyJzbt2fCG6VThN47B92bN451jg/oBKBJ2zVje1FKTIZDjQvQGUu/2ggNAqZuV8gYfAtbiTDNqNoUG6ZejpLqI7enlnfRo11twDy+/8pBKF2wZOcDr6Fcx5vTatFO4p00JVv/6T7MHA5hV5BSUjX8/7F1v8BkoUGLAhAwYjNp1+7tXy8nnszBKivGVHTvOc+0L5BqjMJKX/F2V9U5kzQrJOnidmvjnBE30vkBeGWKc7c3i7EJYlZvD8s8YKFn9NDkKhOplqAKzagoUIYnQuxECXOgErOshRERwbwW/C6gUKj58wiVkKFfq739qs0G5u587aQxniuGO+DPTQl3ajjojNwlvxBbWi0fN2fGk3jCtffhpALHfGkY7u3vjYwiT61FzzzMyn1ZQQ5Dr93Bd8BNbr+xOn1GhbGeIbVQIQYCVTjFy80rutliKJK1y++kii3fppkf4h3MeFy58ITYD7CUAarhnV+mk8M4adTCC7JSQJeYKl5HCWJbo24wB3DXavInlUKy865K0YQMK
 F9bQ4roa
 CdUjEk7nr4GwVlZ8N1+ffpOxff21VuJB23xsVdbyClLJk0YjZ6ZEiUq/GDTmnefQkN5lYyycg3xo6WV5eZ7DLhLTFeE1qaCGl8luFYQVJZg/ese0AeNS17ACMsLoflFe0s1Q6H9Tnv0p+bshdXdyGx7iRL9gvhElQvVNoyFon74NDnhIeFblDPF3wlSgnUMKjFf/guwxqBvZj8kHj51fbKi3A3VhsoRaTO+oxB4Sgz6Uqzk2Xilwpn4TW1+SeLedx0hFViiC+NsSVnhJiC/nkaSMwJyq3jEPu1lpbxAZlEZ6NflH/myAKbBtuypdzPxiiRNnbufFOIowaj+McHnbdPP0KNbody4WiR/yiBFpRR9Idg3yzrYDAXRxW/Kw4xM7dM9IodmC8y7+uUcKP8oJxskLCWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_ext lays out client payloads consecutively without aligning their
offsets or the final entry size. This happened to work while the active
payload sizes kept the stride naturally aligned, but IOMMU debug page
allocation added a four-byte payload after data requiring eight-byte
alignment.

When page owner and IOMMU debug page allocation are both enabled on
x86-64, struct page_ext, struct page_owner, and the IOMMU payload use
8, 64, and 4 bytes respectively. This produces a 76-byte entry stride,
leaving struct page_ext and page_owner data in every other entry only
four-byte aligned instead of eight-byte aligned.

Align each client offset and round the final entry size to the largest
active alignment so every page_ext entry preserves the alignment
required by all active clients.

Fixes: 466ae6978a5b ("iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
v3:
- Cap client alignment at u64 alignment to preserve 64-bit alignment on
  32-bit architectures (reported by Sashiko)
- Open-code the lowest power-of-two factor for readability (suggested by
  Andrew Morton)
- Use a local for the u64 alignment (suggested by Mike Rapoport)
- Simplify the commit message to focus on the alignment guarantee
- Collect Reviewed-by and Tested-by from Chris Down

v2:
- New patch to fix the existing page_ext client alignment bug
---
 mm/page_ext.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index b679a8c1f7d7..39a4464fc979 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -116,8 +116,27 @@ static int __init setup_early_page_ext(char *str)
 }
 early_param("early_page_ext", setup_early_page_ext);
 
+static inline size_t page_ext_data_alignment(size_t size)
+{
+	const size_t align = __alignof__(u64);
+
+	if (!size)
+		return 1;
+
+	/* u64 has the strictest alignment required by page_ext clients. */
+	if (IS_ALIGNED(size, align))
+		return align;
+
+	/*
+	 * A type's size is a multiple of its natural alignment, so its
+	 * lowest set bit is at least that alignment.
+	 */
+	return size & -size;
+}
+
 static bool __init invoke_need_callbacks(void)
 {
+	size_t max_align = 1;
 	int i;
 	int entries = ARRAY_SIZE(page_ext_ops);
 	bool need = false;
@@ -126,6 +145,7 @@ static bool __init invoke_need_callbacks(void)
 		if (page_ext_ops[i]->need()) {
 			if (page_ext_ops[i]->need_shared_flags) {
 				page_ext_size = sizeof(struct page_ext);
+				max_align = __alignof__(struct page_ext);
 				break;
 			}
 		}
@@ -133,11 +153,17 @@ static bool __init invoke_need_callbacks(void)
 
 	for (i = 0; i < entries; i++) {
 		if (page_ext_ops[i]->need()) {
+			size_t align;
+
+			align = page_ext_data_alignment(page_ext_ops[i]->size);
+			page_ext_size = ALIGN(page_ext_size, align);
 			page_ext_ops[i]->offset = page_ext_size;
 			page_ext_size += page_ext_ops[i]->size;
+			max_align = max(max_align, align);
 			need = true;
 		}
 	}
+	page_ext_size = ALIGN(page_ext_size, max_align);
 
 	return need;
 }
-- 
2.54.0


