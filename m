Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9D2606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MFBRv5Y7
Received: by kanga.kvack.org (Postfix)
	id 5094C6B05C1; Wed,  4 Nov 2026 14:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1426B05C2; Wed,  4 Nov 2026 14:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E836B05C3; Wed,  4 Nov 2026 14:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A34B6B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:03:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0F95A0839
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:51 +0000 (UTC)
X-FDA: 85398361062.21.5656EBE
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF18C1C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MFBRv5Y7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3lIHrag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3lIHrag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1wTzVdxrTRC/qBh+6d+SrZjPquJu2n+wXysktuAQQw=;
	b=0TqZpYVMQVGxt/ApvOfp+W4ZnMm23gUXsQ9So83TiPRvgC+Go5ePKg14ZIiP38PQNK4XBb
	0Vbe12ST+JJfAyMPYS4q7DH6fVBfjoauu0PJXjCQJJzefvC7HpNrYjeHLT3p25c6666UPY
	Zi+kDsN48H8d3w750UYOhsio6v0mMtY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MFBRv5Y7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3lIHrag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3lIHrag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819029;
	b=U7ghgxPHiHxDzvabtlXVf0mItwRNanTyPHfkiu4c+BXHu08idFtaSCh+87eAl4HZqw34Ii
	I3SuU5J4xz21vMHWE9kCaBKDKHYNrF1mD/x07BplBEcPaYtatafT06cMKbGJWQIlvBst0A
	qeskJq8lIPpASf9iXdyxP6g2qwN6vTE=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so1842189eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793819029; x=1794423829; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R1wTzVdxrTRC/qBh+6d+SrZjPquJu2n+wXysktuAQQw=;
        b=MFBRv5Y7S1SATk1jCK45EqKWoAJfSeRzbBF56pVSC6fcGWUufyS3mKYOjmG/7Wm+9+
         C6pIlvqN1lb/JhkyQarW/L1bLaby21gOrNC+u2bg63WfFtCX3Ie1erx+Y9+0AGGQNBpL
         ZLeYcBCOJincJO49bq35um52tyfonbP/Hg7W+KPoOssJXXS6zVYIoWey5VPM0d3vGTz5
         yLyXCM6Wn/o/xoKdhfqoWq6ueNuSmtFBW5xm2FdzELVlP+/K0Vmov1Q01LTrjaAgnVcR
         Xtim684cerN5yIR5wxCQlKsVDylFz/rAVlsEo0quF1fnmO4jxquAJckxVJAm9vG/6Wut
         v9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793819029; x=1794423829;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R1wTzVdxrTRC/qBh+6d+SrZjPquJu2n+wXysktuAQQw=;
        b=mPZ24/V6UlzvMzVc8eM+QZnrlI9ltkr/fBwQmHkq0V8WbVS9ujvTDFU+FYnTTgPpei
         bBGDKK3jwd0/h0AgjW51KRf6uFTbwEM1f16G0Y9T3diUjJTXN/G42v1WF73sYp3iF5S5
         wsrmq9A05cz1+v/F6lJPKoeg7Uzh1N5mLyOimvQQ1NLTu33dZkgxiDGkFVSjX+jKxJQB
         1j0PTBtsdYk8cTk9AInkyMdC8+cQeUZskvUU4aL4m1bmdH8p4wu31qNCSp/gph3fPSRD
         RSteDVcWoscyk8Z02GhHs3oxZMKEu5yFfIkMCFzxDEpKgWs0k43UQjbP9f5MeAE68Z4K
         3VAQ==
X-Forwarded-Encrypted: i=1; AKwUvBy84Rjs0qBYU/QQ+A54WSEwF9VJZVHq24HjjNZN8uYWeUkLoIiKiIQz9AXpqror2fSaeXoUYEcA+g==@kvack.org
X-Gm-Message-State: APuU4Z+UrwSB8wwWN6XltZfvnpJnZTZpf7vcid8O9TKDJpwLasWN/UiJ
	TiNJlC16pDsoF7CHaugjkynvhrXFOrkT/B0W6GnKsIyZiYI/GzokluuM/lq3XpQHnLAuDDuZ+gN
	1xR67EMj19i2kpPYQV3xG4k3OFpq0driHzg==
X-Received: from dlbsv9.prod.google.com ([2002:a05:7022:3a09:b0:1ab:fb55:f657])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:258f:b0:165:dd90:1f54 with SMTP id a92af1059eb24-1ac5eea0384mr32740055c88.47.1793819028398;
 Wed, 04 Nov 2026 11:03:48 -0800 (PST)
Date: Wed,  4 Nov 2026 19:03:39 +0000
In-Reply-To: <cover.1793818636.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1793818636.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <1cb54b7e6ffe2e7a0890815c3072d8a3819b48d9.1793818636.git.abhishekbapat@google.com>
Subject: [PATCH v5 4/5] alloc_tag: Extend allocinfo_filter to support tracing queries
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EF18C1C0005
X-Stat-Signature: q5ehxom5gwu3sxsnkigom4n91woere4u
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793819029-747121
X-HE-Meta: U2FsdGVkX1+V8GfUYudn5sZEqeDAFYbnBqimln2ZCH2wQl5vjlYdozC/jccrl1Xobimt0Nc8zKVIgALO41je//VHFRsh/GK0bIuZvw54oZ6cCfzONkK5woMsnlMaNEaUPsigjGd/BqlXRQYEtxtYlNhVNUHCeNkRI1V0HCc4xTBrfQgjr6YavZzBt51B3J4/mxHubyvhVX7FRaiA4/lut9EeAaKmUoGNCAfcgk3pNXYGnD77EUBea1Y3PDUy6TNHawjyvb+tKgF2EbANkeyXEjtsVx5JTPhP7hAqsOEf8s7e+Y6xegsNgZYIDAtcUQsC0oxhevZmZAFkq8Z4kOkTKjF7wYTkNVLjVZrFtbS1OR7u5FVEOad5qokAGFibNmqk8HU3qQEl0PLjCjxw0OXO3MHtiZvRja5PnY/9X3ikBO3Qy/8xETZZropzMHGHPMVyL67y/qfEE5rSJ1u7smuPFjRCVNA/8Y6sVsDwBIDXynPuIP0g6eiO9yLvJvaA2kyYN1jUKjXPHV6cu4n4CfBswZfEvVJ4Cy6/GMI/MvVECgMM4rWvRdoC5Mn6DS12dM9VolkfxBwY0u1ePacH+zPGqKs3vmmh1Izp8JYw1xTUquAtdvZkbb8vA+wxI7p1CCKouBW7mhRM4Dsj2aa91yaKryQ0SVg13xYMWog+fAvPS55rCoa3lNh6ayIlg6YxI9IlDaMgYjIr15Y+ECAYF3FTPKS+Pkgjdv6TB3/SYAy/bouC6Uz8yN3Enztx6aXhLY548sBdt0J51H433gZhvBosujQsijtN/oU93gZjlk8j7cM4GNyOpXITr3MDxabXap1ukokaFzuwvNeYG2Mn2P3/IUQcgN+sJPVuW6U8URmDS6zPpCL/Ebm5Wy0OI78p/jlZlm5euxZi0aGq0yt/d8e4lQFEdIz6DlIzxDontRiqNXV01LiYeeheXgLE345iG81OBFdoEJhLEbIlIsDGCCV
 7/EW4EFc
 qTN9og7Chqnu3RFNJjvXOe0JWFHiDPGAhJ58hmnSK3+hFVyAknh3CbKR+jpVjYeNX3Z5gZx46F3bYDQMHNZCHHf/Z9WYzXt1x3AgT/VSDp4joG05XSs+eLY9tO8OFjDuCT1z/O1kWZxd3X8zibVl2hsxur5DjzOrSbNJnhNFK5W9+dnsV51AiiT3Jo9Ml/sfA6ULnQYOeubU3jpqzvGJIkKPv9WzLOmYg/nbH+ie97AHCIpWrmLM+0JaxhbmkYPaYq79K3ZJi1Ln+H7pnbBThgDiSHkVbDM337eoIv0K9XxX2irlM1wd1dBf4bW6fctSj1OgesKfne0alc4lqXUZ/9uoanhHXOdNhLgNzxBkKds+4YZcPdrOO3iUIl91j3Gf8u+1gaG0vpRq/dmciK02Waenf6VUU3R5f9i5qzX6WSzu+Wr7MItiOKfWXNqYSTji5l5ZqHDbQQ9hR1hnXU3x6cUK9h1qjpF2fqgbTCAygu3gZ159unjNTkgAAW/gWOQTo3AMGhe7sN+6c/+LrS04bD72Dj6WdIvZ7aDxOZzeq96BLn+onCrCIZfrzbFkAjs/3quLYXh9HzkwzCwfB23Lg1CFgtP/hHS0D21puknWYtecXQDJFvHNOY2NNn32gwxeLeyTvIBiQ3fMiS/vC90eNNulxBk4nHOJk7AlJtvhwJYjdozI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their trace state.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
---
 include/uapi/linux/alloc_tag.h | 8 ++++++--
 mm/alloc_tag.c                 | 8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 2fc843bb06bc..ca0779051cf4 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -38,7 +38,8 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
-	__u8 pad[7];
+	__u8 trace_on;
+	__u8 pad[6];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
@@ -54,7 +55,8 @@ enum {
 	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
+	ALLOCINFO_FILTER_TRACE_ON,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_TRACE_ON
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
@@ -64,11 +66,13 @@ enum {
 #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
+#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
 
 #define ALLOCINFO_FILTER_FLAG_INACCURATE	(1ULL << 0)
+#define ALLOCINFO_FILTER_FLAG_TRACE_ON		(1ULL << 1)
 
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 504c1a85050d..e9b70268eacb 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -250,6 +250,7 @@ static void allocinfo_to_params(struct codetag *ct,
 	data->counter.bytes = counters->bytes;
 	data->counter.calls = counters->calls;
 	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
+	data->counter.trace_on = alloc_tag_is_traced(ct_to_alloc_tag(ct));
 }
 
 /*
@@ -323,6 +324,13 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			return false;
 	}
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
+		bool tracing = alloc_tag_is_traced(ct_to_alloc_tag(ct));
+
+		if (tracing != !!(filter->flags & ALLOCINFO_FILTER_FLAG_TRACE_ON))
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.56.0.506.g506a7eabc5-goog


