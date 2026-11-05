Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5EA606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=eNqRssN3
Received: by kanga.kvack.org (Postfix)
	id 11EED6B05C4; Wed,  4 Nov 2026 23:48:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032876B05C5; Wed,  4 Nov 2026 23:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E2F6B05C6; Wed,  4 Nov 2026 23:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B92AC6B05C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48E0140954
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:23 +0000 (UTC)
X-FDA: 85399834086.18.2F2336A
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 80479140006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eNqRssN3;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4CptPZ1xxIkHaBqUwJgyo6uh3NXVfD6E10G6VWgJe8=;
	b=5DguWMD5PUAtJ6mwJkRfsJNwHDaetJ872QI0FgwFEpR7yNoL5b5qi3D4rU/hX3JfCsoVj9
	HrPxMchMBgDblzhlSM3adw4j+SV9OtJvxDHdpCQOsmN4+kjS8GzbY8F1EZoCeFRtQwshmG
	yheWjKpJz4aTz18jJEik7/C80GH8f+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854101;
	b=bwbdgdwpAV83tSs4RO5CDHOeUFMZfn3bEQs9oEbP0TqQIIP8yHZx2yX3tY0paPE3f4Mnvs
	Tt9ohzC0Y9p5AMY8DwW2O33Lia+3YGCxKIwy7ZVouvsp49Bh2FqOG8PZvc1umMotAWaiQp
	phqiGJX1Kmf0ReiW99K8t7CMfC4ZN74=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eNqRssN3;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-15ea896ddc8so2523282c88.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854100; x=1794458900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z4CptPZ1xxIkHaBqUwJgyo6uh3NXVfD6E10G6VWgJe8=;
        b=eNqRssN3DwzN1kKabBLL5kNlV2i5wjf18Ktl9F2WT0LqFAqokH18XUGivSG/ivl5M0
         wVTBpNeSjO2srR9BOmYZTQtvv2SMv59C8h7W84UOj5FYymzK2D6uFyIFwS8aFS9ft02C
         WljwCO0+anCEy20PVyiaLV3EHRRpVnEFCUbTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854100; x=1794458900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z4CptPZ1xxIkHaBqUwJgyo6uh3NXVfD6E10G6VWgJe8=;
        b=q+xL4/hkqQ9sR2jb1i3w6Yt4iWzxVkxluPZecoT3gN4jujcqkFTEOTdYQ8fI7GW/yB
         Q2Hvxl2hZeyEWOuf3beJUedU5gcGjvAC0nO3Rc17hIP2L+rsmrpjXxhYxdHOfXHbOrj7
         E5LcdHrB9O54EBmZiCHosJCcMEc6qfhhfVoK/o7EMslZ8h5yzKHJyQLrw/FfdwJ2sxi0
         e1GiZb7J+Wt9t6gIAe7gWTvqc7Qka5xQvoeDFGpFZ8OYOOXs3qDkVhI3DoXiZ8vGPgQl
         Cc92ZHZrtRYXMZjMm8L1OOhb7DSi14DG6u+Q9sSP4yMOYITjMXo3J3WYrERXsCzSmZsY
         JxvQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4j5wZmwPDqGPhavU4p4GSv2kdWaALa1eY1f00DMHkZOLNAUutkODoRstIRu0id7MKxuIrU5JREw==@kvack.org
X-Gm-Message-State: APuU4Z+Il4W6qSwMBmQbbrZgImaIvLuMjRVMB+OPfFyZQKshwuVB9ut6
	r50vNGb0LqCzQae5GcTqfuSTKfTs4p0U9ORUg3544EBE+halvskEDkuYorkq1Ne7og==
X-Gm-Gg: AYBFou3O/vE1gzv2WgxZGi/H995XM5YkOIuUHD8wcHReFOWCXmVtpDU0Mwmtd8ii6fc
	8cnuLN6E286bi7Ct8CzuriWP87M766wOzdk6zh5wRF08eLCYQUuxxZIRcSf+i71z5Udo7HQyG+d
	Psvp+lH/fcgM4OCM+n2F8xCEPtLiBBHb8AwrGfc72c7C5T3gcF9VW2ILDJG5NWCkWgcQTaITDm3
	YueESr5dQ78KaJkVvacCy4hVyKeVabJxIxUj0M0gpCQ2wA7KMmDmpxKR1bO1LRRbjTW1PBCjoBn
	rMZy/r9VeAqLfhl0naLHisjer5w+U6Es0pmfrWlSpx4QXkKn3ySj0RPW2TOGg9+Kj0+f9zF+V9z
	QJCXLa5zKLifcdek61z3S2lTkQYNSEYoOTUcZStPWLtzwU6f86j0ipR+pfmrJDGhz81hq0F/y/W
	FhDyvC3JhtqSsZzy+tpZTPeeaFRdJFg5i9yqJA6mU0R2zJRQTq9wcMMidHCrfUoBhLWFXlYR46f
	lfxg4zftuCYqxx9GsNtFRrdAc1OBzS5K/w++4ySMWDcyKbCPqmDxkDS+vxSOFevADM3bMXwelPz
	OgASFMFUNo3ORovdwzFrYOxrZDv6j0dEcm7x20z5WIWMCyexeJBETv35Av26NStL9m7cwv9Jpgt
	d5KdJ0mxqpRFgr3UCl53vTQuonRar2/6TmpAyAtw=
X-Received: by 2002:a05:7022:7e0c:b0:14c:d8d9:9502 with SMTP id a92af1059eb24-1ac5a0b8a9amr26997590c88.14.1793854100117;
        Wed, 04 Nov 2026 20:48:20 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:19 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 7/7] zsmalloc: constify struct zs_handle pointer in read-only functions
Date: Thu,  5 Nov 2026 13:47:37 +0900
Message-ID: <20261105044752.1997895-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ptdewmjiygf7eoox9gqzawhp6ui8fdjo
X-Rspamd-Queue-Id: 80479140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793854101-987656
X-HE-Meta: U2FsdGVkX18FBICpYZE9hZs0JuG4932+smUQ8TvQdXUaFYb9mXkzp1x6ChQuKDPzsvU8tTr3zHvy4HojyfaU/A1lVUXuXT0UP80a5afZRfaVSmsj8Oz1xdnzh8KxuE7PILM5VvuCr5Rxxt83NyExXdJLa6UZ2/YizzJ/wdVLvWnNGZjz0pj/BLs0iUTe3CIrmaYI++YMXCoEd4ZLjA9EmDc+ySETeJjIrRdJfTH83JhvYT8hvlsianIwwBitTuErr2xn30r9okneAFmYUnOyvf73nVuDN/+blUc5P+UW+kT/VLzzWQqGSTOLC5HHUFJVmTDzhxCCzJF3GiEjlZf3eaGCdmOCv7P1U7+kK43fVyvvYZ/9mT+f9YswNxlHW3AtVbpnH8GC7WvqhHZBceCdpQDfXHkqv48HFhEdIxaVg5hJELTPSimBd2kCxKzPf6Jwl+ZdBY55XUXJ4QCcIHZs7kq2dvSmt6xymz3VnfoRMCAFblRoaPlXBeIrKNfnZcaXj/MlD2PihfdQTHD7DSkkYiecAP4BuKGxkkdMM+ihAB22llGnLbkPEUmdExcrdFTGRHJ+hutloiEj6pSnN3aDhK3/oiJFQo7eSfXILBmineSZEhKSchH2kDwYb/U+COTOcLDlMZiVo75Vf+XoI3Hqnc0qVSgVAjD+hsv4zqhdgDIybjii4CDpfn+gdmm+l5p8VOA/c/RgZ3yK88RUHSBg0pr+u9estJF4hJeMkbrArx5Wcx50MeAidhaOvPyoaTfvXvqPYfVdVjDRwDYBtWNUslcpt2LIj5o+kBRgGowJvrnRZsuMpiZvnPVUxkHvk26fCE731rgr9Vley1W6ZAZYXqVaVKt5iP//vm1QOQcaruMpbCwZxNZmqhwQSzbY8S45STntZMx2zRaY8iLgqjXN4k6iqNTJ3NGvL40QXyU1htnegR9jcsTvzcLrVXTSlbXQ9DAV2OxEy3QwbarmuKO
 139+WXLW
 H18iZd6OoVN+qlL/Yy6++UxAqNOcZX0374HiJDpprUsIWwuX3CzesmPlxCDl8OpN0urkS/mCWWydCGeEiiyko1Jbb7EbqQIIUBh3nFkAINutLjDtkQxv7Xfq+KmbPEbaj3NnVul8byfYexZ0Ezwf7EJdRwoVYL2Z9C+AJ0yOZmbp/+bgP4oQQ9zi3zOXkqGXEqBoV1tk66jOv6aLgNVfN1rXv+QGMnW2HpBhoWSNgJozB+X/fPBOa2sCnlmAXDxOvz9WUGwp7FN3+dsAL+rDGNmUaXfADMAlBoEt1qOQVVj02Odfh5DfX9trCwY9sGpXQslxSqtVxkTd+2QlgoFJ59aKQjXA/B/S09fGf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Constify struct zs_handle * in functions that don't modify the handle.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 include/linux/zsmalloc.h |  4 ++--
 mm/zsmalloc.c            | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 674358f39191..793fc887015c 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -65,9 +65,9 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
-void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
+void zs_obj_read_sg_begin(struct zs_pool *pool, const struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len);
-void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle);
+void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle);
 
 extern const struct movable_operations zsmalloc_mops;
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index ff1cde4c5dc2..e0f89a3b77f1 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -805,7 +805,7 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 	return obj;
 }
 
-static unsigned long handle_to_obj(struct zs_handle *handle)
+static unsigned long handle_to_obj(const struct zs_handle *handle)
 {
 	return READ_ONCE(ACCESS_PRIVATE(handle, obj));
 }
@@ -1110,7 +1110,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
+void zs_obj_read_sg_begin(struct zs_pool *pool, const struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len)
 {
 	struct zspage *zspage;
@@ -1157,7 +1157,7 @@ void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
 
-void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle)
+void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1395,7 +1395,7 @@ static unsigned int obj_to_class_idx(unsigned long obj)
  */
 #if ZS_OBJ_CLASS_BITS > 0
 static inline void obj_class_get_and_lock(struct zs_pool *pool,
-					  struct zs_handle *handle,
+					  const struct zs_handle *handle,
 					  unsigned long *objp,
 					  struct zspage **zspagep,
 					  struct size_class **classp)
@@ -1415,7 +1415,7 @@ static inline void obj_class_get_and_lock(struct zs_pool *pool,
 }
 #else
 static inline void obj_class_get_and_lock(struct zs_pool *pool,
-					  struct zs_handle *handle,
+					  const struct zs_handle *handle,
 					  unsigned long *objp,
 					  struct zspage **zspagep,
 					  struct size_class **classp)
-- 
2.56.0.398.g882cbad275-goog


