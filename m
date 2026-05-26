Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02071CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA546B00C5; Tue, 26 May 2026 07:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1826B00C6; Tue, 26 May 2026 07:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8706B00C7; Tue, 26 May 2026 07:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB2416B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:37:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65D50C19B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:45 +0000 (UTC)
X-FDA: 84809371290.05.D90D613
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5ADD1A0010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pgdNdW5j;
	spf=pass (imf25.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795463; a=rsa-sha256;
	cv=none;
	b=OsA4zsPYhO10iSrQ7mOcZR1n4DTZ+hLd64R3b1hRCbpCE2n7h2vsJjLGdDiNOEzQvJ1ZKe
	5WJAFBHDk3lXMo7sIavmDUQsQNNse7NRDuzw/HmzB02ngv9QYXKpN/3ibpcvhkEYq6SFCS
	t0pm2ZgXcETl2cIhJVG8OK+8qYFpH9o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pgdNdW5j;
	spf=pass (imf25.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLeHkQsXAybNTL4Q4w5mxgSBDAtaR04/XoGzkQTY4uA=;
	b=sodrWh7jqJWZVmMyt0qoz/gYbgQZ7dTsT44igQq6d5MsVIlLbv2MThzKt7BV4Trz1WeWTy
	3uLF8lEyn33kvGoSBlP1/Ok6kwROjEVxJzR+B/30ujEhB6abCSObe/eTPRaCjTOHiL3To3
	ifN8nepby0vvVk5wE7KrnOd97/+ETaw=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a85b30dd54so11222464e87.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795462; x=1780400262; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FLeHkQsXAybNTL4Q4w5mxgSBDAtaR04/XoGzkQTY4uA=;
        b=pgdNdW5jAlYIlFPZo4Z0zjbzoHA3x8SLUFZQFehhX2k2A1Tidu4/sDM/dTkj2jepjR
         HJkupiYCwRfUfnqMQfkCmDz4+u0X4fIaa4B9lp+YBmtUI6lxCGSXw47f2d/ayv1jYfsM
         8qmwQo6qQ8zUJluuslESmckeV2MGesqxkvSmq5AEHWwWIR+tkBvMM/ZXNGdaz9Z+Nqka
         +vivE+CEAy3bn5C15M7Y8mhU7oYEkVgIjIkiocsgJ1JWjPvQTZuKCWacikCqrZY80RVX
         +/2ERirt8Nfq8dcwqJQqZLqDUztJmON3JHiIDJJKJeVBhz5yt2j1cEoMzjjOKJKHBr4u
         yfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795462; x=1780400262;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FLeHkQsXAybNTL4Q4w5mxgSBDAtaR04/XoGzkQTY4uA=;
        b=cdEvEjklgr9RGY7+/CqvVKvLP5fCYYzyLQzsSpqPeVLSDwdQX3cTDuRnMj6srf4GDS
         AETZPLcL01F01ZAe4bF17tZAS0kYF653FilhnUVRGr5p4ZsuMGxwReLO2v3QEQoDGSBR
         wC0PtCsOHObVK3AdIs/CCS2oEJF7dcxOIjAmZ9efD9nIls7WanGpeguEAPjUs7yzc/hx
         MTnuucBtbfvSlfJYzK1RiNZjEiBNNHEcCcj6HAaS9VCqz425/sTa3PQ/7m8Fpm63X+31
         AjhNL1Wr7ExBjy4nMmBYxKnn6U2ZhpILtAv70JpUcsQLj8tTxT+skyH1orpo8QFpT/ro
         Q4CQ==
X-Forwarded-Encrypted: i=1; AFNElJ90AX9J4K8BhCHR+lqll/FhH47Xb0RDSn6UK2iehSQlQHJqzt/tpSX7yX2hQOKgehFUH6GUeiJEVw==@kvack.org
X-Gm-Message-State: AOJu0Yx0ZVQHTTh5UOyrlCcjjLK+VLF2w8yuJFvF5Qf3RDyrHRM+6voh
	7r5XMYd+DYS/OgpC3txS2egJY+o4uMPzPFbwfo5t9f63eFfqG71mUwF9
X-Gm-Gg: Acq92OFLPsnz45yGYJrIIMfSH+MH+0yJk2Jr0JOchtRvg4j1B5iWIOhXZq4LLkFLgjQ
	A94o4PRmpEb/Kp4Au0jfadYAJS8vbadHImhjH9DfeC6zVgXFZW4lAQhMcgfmVuJKWhBqR7twGUg
	unrSRoDVpvBr++W6N1YHzaRfxqT8hGjgHKMWzFm9UA36ynFNE3y4ud6uBQY4gIbVEuaXfdKKg1C
	aiTkk3wK9M0OP1VIVGWZIHT4ncGdG4khgNlOnAOvchikLmQEf4tvTobrAvd65pT38r38XxxFUgE
	qfxFbfJIrQBdUNqATeFP2YEU2zgT8tL/OAopVMxSqOTJgILPPQ5PCDVyr00B9Uohr2XFPrmgmv4
	rzC37YG0J0dt2YRF8JXukn1SCuvXDIrYdcx54QyOhjI+h0vrXLxOPfq+eDo09oUPh4jHgw617VD
	a8rrJXsxZr+/+1DV7gs/q6FEw8g5F/rK/LOZXvUFCuHjgXpecvioQwF1nBWfePzUxUAzf9
X-Received: by 2002:a05:6512:3b21:b0:5a4:1a2:1d39 with SMTP id 2adb3069b0e04-5aa323143camr4952108e87.6.1779795461414;
        Tue, 26 May 2026 04:37:41 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa46330d9asm376332e87.59.2026.05.26.04.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:37:41 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Tue, 26 May 2026 13:37:04 +0200
Subject: [PATCH RFC 3/3] mm: use non-temporal stores for demotion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-rfc-nt-demote-v1-3-eb9c9422daef@zptcorp.com>
References: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
In-Reply-To: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ADD1A0010
X-Rspamd-Server: rspam03
X-Stat-Signature: o1gf8zc93qd7us35rg4wbozrfs6knwbq
X-HE-Tag: 1779795463-824813
X-HE-Meta: U2FsdGVkX1+5s0bjxlp0ic8yEF+miHAcWWLmsWsQs9pDiX1TGtAs0q7cK786FlE+qmndxOIUpSUlOv8xajcdqI0enZTHGCdFqqyoHdznyjRLGq/TdVbj80zANJXHPjQZ3FDqjq1VocIeGggKME6JO8qLjCXjpNY5QMSBhva3qAY/mi6avSUarEzTfFiBGtWQNY4W3o57IvoC29t0LYcSMeuIZ7XO4JLmLxdp4TkuhjPODEw1RwvvIYAX2/ZyvL2FeKP6uW1GHUKZrqSZAdd4RPM+ZcmTsa3a+Sm02lzWtgWpduNhx/Bj6eVktpgLdy/wTF7hVOQ6hg2XVcuudPFAfHfT5FPlXezCBvMZSRycQgCTO2OtdoavgZQ4Js2ue8AWtcC7EsMdByY6gLl3/oXhz+3ex784+2rh9UrMkIVH1Q0UxgBDQoEJJ2VhfYxmXZ3+BxoCZWhnB1HW8K9qVUFmx4Wo7c8ZeuLuiV+WnQ7OE47kEh5v2hQhym0jW4ZNTTGOVKnLPDDTDWt88df/0gnbXZ8+BM+JSmd1g5lSgqFZJSxSvVOaJjk2BBlp0vKoBVmjGtgSg+MGO6JE9DRGdgXX92VGtHhdc4tvYFDQJokbMcZ1UtR06ZnayZ05tNxMQh0Ov+cqoyd5W6Azqg+OtfFdr6Z3T9cvoSG67jxH5aLJHXN5flQfUBKvgf7Uc6/eDRopi/zwUl/jGuW4foxTidO/mw/Ki6mp1RqMt7urjZzz8zOt3a35WJktxEO7NuwwLOIopTOAxWTVeGgkwLCqvb7T9Bdgmjgp92o57GPYg8GNCBNYSmhy8wa1bOdshnKIlt8ngK+QY7++u+U3yTOUJNIMDtnFWoebiohgw1lQLlyCArH5eOSAMudHL0eTc+8zw/TIg5qnn2Af4ZnOhehgj7yuWoucqR2Je2t/HUkeOrrEhGwcViZVRU/4SjZz2oJGUCG17N1jJgs2N9x+ncMXRne
 64jCOKTv
 KVsncjrgMs9QK8tcDSewUFUfkNXVtKoG+W4ZfJjzub7c+sfY6+qP6yMm4vzJogLAUFyQyoLbJdWXslHifgqhzS7/9Ga4XjqLsDGTQBU/x9X7W9NnpzneyKYIjB9NVtrhjGbGt+NXefX8RKzxi3sbkfJ7NTA4ihH7FXdLmQcoNDBIRBG7KuK41ZeoI8ozjRXhTp7Y9X2uIbBaYsRANrkQaHJZfsEDXKJo80A2dzVOFX9jaZdPB3+jLzcmzOSRk1KGZeKOuq9Yc4x+oGrjgV+Yw1sM6cmpceognQ+HmA3QDQm4FT4RUhz7UyxeoaY/JTEoT3EU0AOotc4mo3FJM4b6AJC/cDmR5iF7G+abtNfzjrIYQ637ZBey0j7ORPcrrOon3s7wlAtttFPjesnwfhdia6L2M2qL5STYUuudjheloeWPKb0NUMztp1fQb8TiWnfqQ7mpJHekbShGDDvj7vnM4c3087tPAkd7oIPFFOvSDzZF6zpGvvlm2EGvOBSbcLOHZasNMdmA7w7cPKdlK5pvOr77vD6rAddbgtEwLlI2IhW1Z/QKB5A6IImfuDL1YJ5dTCEM5AwZQEJhVNxLsnQZ5yuo7F0ZCcCwPUk9Bg3kd1AdZ9HExR6G23Zyg9Z0bQoqer0Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alirad Malek <alirad.malek@zptcorp.com>

Memory demoted to a lower tier is assumed to be cold and most likely out of
the CPU's last level cache. Additionally, in certain demotion targets (e.g.
CXL devices with compressed memory) the bandwidth can be negatively
impacted by the eviction patterns of the last level cache when standard
memcpy is used. When the feature is enabled, use the
MIGRATE_ASYNC_NON_TEMPORAL_STORES flag in demotions to trigger the folio
copy path using non-temporal stores.

Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
 mm/Kconfig   | 8 ++++++++
 mm/migrate.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..4b7a75b57f6e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -645,6 +645,14 @@ config MIGRATION
 	  pages as migration can relocate pages to satisfy a huge page
 	  allocation instead of reclaiming.
 
+config DEMOTION_WITH_NON_TEMPORAL_STORES
+	bool "Use non-temporal stores for demotion"
+	default n
+	depends on MIGRATION
+	help
+	  Enable non-temporal stores when migrating pages due to demotion.
+	  If disabled, demotion uses regular migration copy paths.
+
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
 
diff --git a/mm/migrate.c b/mm/migrate.c
index ff6cf50e7b0b..368d40dc8772 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -862,7 +862,10 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
+	if (mode == MIGRATE_ASYNC_NON_TEMPORAL_STORES)
+		rc = folio_mc_copy_nt(dst, src);
+	else
+		rc = folio_mc_copy(dst, src);
 	if (unlikely(rc))
 		return rc;
 
@@ -2081,6 +2084,10 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	LIST_HEAD(split_folios);
 	struct migrate_pages_stats stats;
 
+	if (IS_ENABLED(CONFIG_DEMOTION_WITH_NON_TEMPORAL_STORES) &&
+		reason == MR_DEMOTION && mode == MIGRATE_ASYNC)
+		mode = MIGRATE_ASYNC_NON_TEMPORAL_STORES;
+
 	trace_mm_migrate_pages_start(mode, reason);
 
 	memset(&stats, 0, sizeof(stats));

-- 
2.43.0


