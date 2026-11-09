Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B04A606A339
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=e6uaxJLk
Received: by kanga.kvack.org (Postfix)
	id 0E4C86B05C6; Mon,  9 Nov 2026 04:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC756B05C7; Mon,  9 Nov 2026 04:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FA96B05C8; Mon,  9 Nov 2026 04:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF4B96B05C6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3563CC0611
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:25 +0000 (UTC)
X-FDA: 85415130570.24.419D095
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id A913140003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e6uaxJLk;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218303;
	b=udQAy2EeeqLkfX8+gODkE9tZHl5rtYZo8MxbB8w/49WatGKfDL5/d5f4p0/KZZ6DBL2Db3
	IB9zvI3xz3TTQ7QhIEo+jfC6At+VtkDlBF/5XraAWiGhdrnvOz9HYaM2SgHxfnDEkIJ8n9
	ZaBhYYN+novB3rSCziA9Cg3HT0H3Lpk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e6uaxJLk;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oy4Sqnm7F3cOGv06qj6Z3Ixjl/LADzL4b+dbql4rc0=;
	b=Qb3DvZ7OoauHu25TYu0ga6/W6XBUa8xSAY/xE2h1yaqS4eGtVGo654CXju8OdNAjH9kLcy
	bNEdjD5eYxGstB/RgTnHbkH07ocIWCDhInDyueJkpsINdnFjm3CVwjIporGKkoaWtCLeQU
	HEBSIiTHYCoFubRkBO125sZcPJbbsEY=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b3ada81853so391061c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218301; x=1794823101; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1oy4Sqnm7F3cOGv06qj6Z3Ixjl/LADzL4b+dbql4rc0=;
        b=e6uaxJLkInTiE5rEV+I0K9kVPc3vEJIC8lf1Io089FjCsMev3AUmWKjubfdN0p+U7c
         htUcdI4Pd4tWHEHXG22f0p4XysWtNjxPKVKcIWMlVXusuaYqnCqomrhHuaaB0BUpLLNd
         3jP2tLGpbnZUwYpuCDWAXpGxxen/JbJPTwwrHYHZy0fFjMXtWph7SUVMK4ZqoU6XfF4P
         HzE/Yd4qiQVEnbjwD91ltcDCtgP5fi1bNYb1G8o59feWyDuv4yMVZl5mUXxIhTt3qfUi
         TKZHyxaHqY/Qtvh+cvRxQ910YTScWQIesA9mNNZjqrrgUwxC1eogsHc3GvPsmW8jUBzS
         Dq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218301; x=1794823101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1oy4Sqnm7F3cOGv06qj6Z3Ixjl/LADzL4b+dbql4rc0=;
        b=z8Ypae7F0GfyFLljsgzB4ZI3EPd+j7KlB1XPQKhRyxCRLU5LapFdY/UG9xHno2LQg1
         kA0qV1Qc09p/zIM9nASt0G288mztt6IWOerSWP/cAkxI0AHZVoyPwiWxdcVLWyE3TQLs
         6yYRMJ3sAb9gpDprUxDtrNlo4LOxwdUGBHt7Vuuk7gIEDUb/ZhDJnvUjs63rsrEy2Ejj
         T42bXbIPGYOuDbmCpDZRlJkpcS+l931bD32V+KXAA3A2JKTxPrLjbfncsZ1nwCxq0paV
         9fnW2KfYXLDMXOYFAC9L5DK1ddyjcbpgNnCRuWzG6RD5HIyU0ntk3UuJtl1ZrNDV9kUH
         BPpQ==
X-Forwarded-Encrypted: i=1; AL+hErG3Z6Aixbaulnj1Fxw2HimxMytkwRHKZ0GOtEd44mFcreAg5QlW3A1/g6O90SSuAAYhK4nm/rzC7g==@kvack.org
X-Gm-Message-State: APuU4Z9n7uI4iFyObAuqaUiced/LYT95RCnK6oUlgxjKWBF1y948Ip3u
	roKsVce0NfIw7U1gWKCjjYoRGRfCZO8OyMwKAz46VN+0SsFs6XbwyhionC4k6DE5qPE=
X-Gm-Gg: AYBFou13uIDXtRBNigbi3Wlk/Guy0uXmpXiKVsWd3IYim8+UusqCoX5kbHR2cz1sYFW
	jBRq1mGmHyC6R3MmNGyQ/qZCEnZ8BW/iKNDyBEXsjf8CMJJkyxXozYNvveTql/GXAAAhPGpM4B8
	gVBWRoQjypIbcYWJXpJbNZR9DRN7PysgSuBuDh1hRDiDYzt3Op6ikIsljyNxQ7d3AFuBILj//ir
	b99epxBj3vpapYb93BfR3pWADPise9gToPryyXcOynbdTUVuufrB7Y2ZWZH3OZ912UiD6qg2FDK
	UYx9jHCIUK6FRuutmUYtpfeMDvpjp9UOdShmWL223adtDwEpsIcDj1goQiquUazDEqVE1UGt9Ol
	UBmBq6ZNRzH1GpzPxIv8ib4rH90NXsRTD33gLmvUeZHO/sGBM+k3E303QQpCiDFRIwVLxUtHueQ
	xAxFF0YJB2I82asnCsXAlD9kqwtYAQNySaPtQjBEXgO0rL6GzT33t59yG9JPX1+Sy+9eaSM3St/
	ulBrE55OYqJshfw2gcvs2ymmfDQQHCaizqxAOkVYo5ID3dXF57jvZTGkLNaiqnCJJfPmu9MJROH
	wtNrALxp4yZy5fGHTRG2q7vF2rOa/yeQM7qBMAzO3XYAYsAlpQM7UR/8XTUFmIqipxbbdmzFjfS
	rjaKuyRA=
X-Received: by 2002:a05:701b:2054:b0:191:444:425 with SMTP id a92af1059eb24-1b39fe2dd86mr5786268c88.2.1794218301076;
        Mon, 09 Nov 2026 01:58:21 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:20 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH 01/11] mm/mm_init: verify zones for template-initialized pages
Date: Mon,  9 Nov 2026 17:57:56 +0800
Message-ID: <20261109095807.41547-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A913140003
X-Stat-Signature: c8sihu8s85ca3a47uop19h4tuje5sr5g
X-Rspam-User: 
X-HE-Tag: 1794218302-71794
X-HE-Meta: U2FsdGVkX19+mAOOLj/Cd8adVDs15+Po2PGKMcN4e8fo2xPtX6EH4QwZcB01NuU/TkByoNo6fpWeI6uRJl1w3ZxyLfTyRxj1DL3Rn3gcFE6K7s9p6TBCwxbse747SMAZnrdEeXxjM77cu+OIM/rjD2bauLO0rgCr+X9UVTTyQWmqwTBjHu1APBSqfLZiPWQOAYCajwasf5q/MyEGqUQW1WkKM/ZTJIw6ZFsSM7KiTwIqXNCLkrEmcl8zhocQ8fFnu29JVxQaUYLQieJ6y+Mfc732NZ/9MwDObVKwIhTpiroPNeqm2w9wJ5AFEmnY5fdgTbkmVZo24k5+OTL3ElDvJ8Q3Eo4OJVMOx7TbwCWAVEX9VaNHr9VOX0u5vLyDIU0pRAdpnx4YAbuP7X7Kp+A31mby8G0UQHRjlkGAj9RWc+KClbHP4is261UjnWSVmf/FS4tX3elat7hHm07K22ooTUW9eTWstWomWbqNidOiJ1BNebITTfw55LfiBCJMJ1orSFQdQ71MGC7CYWmuogWDPGvjFHrDgS7EkN1BSUSGIfrd5PRIRbxxh+it45p3lZl1sMAsTl0NcnHyHBd1J3hf43aEYpPnF1bv7lKeVU2ylg3Bo0fRA2P0Yi7/6ImPHWftYleKwsHpAyworYom+Sj+Fo3CH+6NXJ+8/c5k/yHZ/F0sLjPeXJkK5RplqB+XnJD6wFfXHytq524PNbChm1QXF0epwzMheLEzkn07f53s8w3iJPVt/rvMK8NMzoygcNfCHs6g3IZW5JwNJ2mLnlQXnkdpe/DOBmBT2HYVCJj5BRuoxWZjC4b1Ure+DCkL+A84t5SITJGpyI/8YpfsZO4OvKhLniJqDIyPsbCgPg054DLrcXKVTRkoBV1GJ6KP2/QSnA898Ueizqc32rSuaJiMAVaA/IMDuPwOup62xkatVk+H3cFGz4injrO2Z9hwyZwrqnH76qq6nw22xRkQ8ZR
 BXXpjs7v
 XxnlhFxJyTOawa/YvUHCrYpSXOCzFZd0AlfeeKmPSUntPKgx4KXa0IN/s9R9zA62/uFopT+FUvccxHxsOkghnp3YO1MHCIQUtMh4NsG34+dHM7vuwRsFUbD9WpcetNrMdiaS38Skawfh9MLLts4CEXs0scUUQadQFCTzN/xxJljdw0jGzfYF7EJvOaHFAQ5uC7PUjMYy6waNihf5oltzX4YVmEULRViPzzcpOt0V7xfPLyGgANGol7GL8o2J42HLoT6qutE2+xEgVbFfBDts7RGIt9tVJTgnxQUSyLSP4MmlTsVphPoTTYuZlgsUUttfhOHCawic/VCGFa3UaNtJGdc1zkNGrV+cKynY+TZTXBKqtfB6MDqHsVYP3/IWU30rvNOT4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Template-based ZONE_DEVICE initialization bypasses
__init_single_page(), which means copied struct pages do not run the
vmemmap zone consistency check.

Verify each destination after copying the template so the fast path gets
the same validation as regular page initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a9d848c92678..0129152b74d8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1082,6 +1082,7 @@ static void zone_device_page_init_from_template(struct page *page,
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
 	memcpy_nontemporal(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
 }
 
 /*
-- 
2.54.0


