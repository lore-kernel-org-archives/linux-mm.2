Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D76606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=gTvmGRRl
Received: by kanga.kvack.org (Postfix)
	id 4CDF76B0682; Tue, 24 Nov 2026 06:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F996B0683; Tue, 24 Nov 2026 06:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7BA6B0684; Tue, 24 Nov 2026 06:06:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F29716B0682
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 773301C460A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:55 +0000 (UTC)
X-FDA: 85469735190.18.8B33F34
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D3D840008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gTvmGRRl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518413;
	b=yLo7svcknMDTeFG9umG0OnI7Cv4GNXP0N+aRUYqCXDTZcGR3fBeYh0RHamgAbRLADQk0sC
	MQQ1pzX9u0RYz+iClYXjyysHCZ++U3BeaSkMDU9cHMC3YykfcpvVC3KRvwIjUlTGnFFVhd
	XRPncj0xbSOMlZJ9CXbI8DpqPsvqS7E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvlM1hx1GDhBhbJqkp1b5HWdob00Mcw6yV0goWO6oHw=;
	b=ajPxkcSUYmmxXl6Zy0iyGkAHqA8nzSlGOdOGTh8vg4u06mSyZcGrCIPIvtbqZKbx4XnxY6
	6NgYwyx6ufGj9auQWEpR0Z9rwNfQBHln/fpzCr0/oZz3cV1Wg1UvlGNaDWeoiIHw1uZWbk
	vv/vvEZyz8v77C5HqbPEMe0RHm1D95w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gTvmGRRl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso1776917a12.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518412; x=1796123212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nvlM1hx1GDhBhbJqkp1b5HWdob00Mcw6yV0goWO6oHw=;
        b=gTvmGRRlbtDctS8gVkJ50SYRJ6slBS9am8YaMbqhaaP4hNo9OXYkJgl9ZRqLL59a5U
         /lVqaXioXJqXR450Rar2CAS4Lf0jE4ELAl/bA7GFd6orHXorjX8e8FKmXngZEb0v25gS
         BANXfJbz+Buc9ztqpkN5uWGVJmo3+lQm6iNFsVBQvNNTK8mX709R+Lj7VsR+3tSiFlc1
         9T6XmRj/qHRzThYzLDVnOokWPAm7e/UGMs/EXxRJtBp/wWgybnGbJsUNvuIMO8MpN8x4
         9THjxeyFieS5brVfDUVdKgSwDwIA6sUgztLtKERnzcrvBGLmSlpemVvxojvOvnBENWVV
         tSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518412; x=1796123212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nvlM1hx1GDhBhbJqkp1b5HWdob00Mcw6yV0goWO6oHw=;
        b=IUq8/IoIxnlMCCUng4JWBoxIzo85Z+C9+7uWVYTpVMdxQjj5ktx+0ccd9cFlSpYLfM
         fVOC4lVlJAW4ike8dax0ZYYgmal5rRmmLGWw/K9JJ2jcbjQe4TpmtsA2q/tppxpyT+n3
         1TBFEfngeMQSsldFB7gFRKvFbbuHyOdadRysHy7eQDdWqIJ8bwsCOiGma54gedgoSMQ9
         5BiFz5pReCkiD37n5a9vQ70/05xl4IJEnh1pRvXkS3AkwcAlsaa+m+V7GlDV1NlmPS4c
         1bKfAMocAs8AF/yDywllJm2ofLP11G59MaD0f24WK+zUaPeR8uE4ZpiMqoiyxKuWsiEm
         F36w==
X-Forwarded-Encrypted: i=1; AL+hErE3qTLWGSnQzq5HzC7nbaWULf+hTLo5scbONdLoSfrZ8mwfFbymJSWk+om/SC7E3TuhokdVF43iYQ==@kvack.org
X-Gm-Message-State: APuU4Z/QZu772mlm9uOBy/2ME/HRdQKpwMr0L2lQM8lUD8Tp4mCW+wa6
	SceZ5ZGaYy8Vni0WuGdk5okRAV5uskSa5g9bWfVb6WxI0lGHwbYPLzFzIrZG8BqPmZw=
X-Gm-Gg: AZFdTZdrT79+vHFvKOhG2THAOaBxkCa0kez2rknWE6W7Wo8kaNLioVUazuYP/S1NAxU
	GiAZ3Yg+pgI4+8ag3SZgM7xxql/7u4TUh6d0S/HJWCGOs65OYMqNEfc8ZH8EreX5OTCBjqFXEBC
	uTzU4Rwlccj8OXSa4y1V0U46dR+LKRebjIi/PTncFaoi23FU9DdyWcbefvLbKGETszSgSE7FNqL
	ZPP/iisbLNQpA1wh3li09/arXrU/H++vdmQvS7QMCil/0lxa83hn9zSixJm87PdOpSup69GMHVE
	tX2mgZA+LdOpuBoeGLWDCIzvNB5dh0uo3om3SuV17JfnctTIbhbOeZBLKnJMk2Uo1mBuX1BiX5v
	zILCm79q57pfH0L5cdxbFQGf17vQnY9yfjf1DE2KAv5QHxVwkLM9OXm9fq250qxsUbPtu5K15Us
	aZO8t2sWlf1xLmqAT+txkH0BMNarlOEXjd3C8ieFtl3xDHHhhgTi0xk1bNubnf0EPt8MfETyEA6
	oPJkXxZ3w8q3s1DFr/x4KZ2ke5jX+dNuXrldnUA+S5rHXTDiNtzL/YiYDHUTn6wPJCqokXBad1H
	u5Si7zvSojZevGh4JOFILJlK8tFORSoKNCxnpPYFMK/0J8Qqmk6Tnv5CRWlMW1joia3hPQUb
X-Received: by 2002:a17:90b:4b85:b0:3ac:9d26:5532 with SMTP id 98e67ed59e1d1-3b41c7b5fa8mr14177898a91.3.1795518412149;
        Tue, 24 Nov 2026 03:06:52 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:51 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 6/6] mm/vmemmap-optimization: centralize the vmemmap optimization support check
Date: Tue, 24 Nov 2026 19:05:30 +0800
Message-ID: <20261124110530.3004071-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124110530.3004071-1-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 8D3D840008
X-Stat-Signature: k77od16afxqicbzqfkqbi5n86edhgsig
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795518413-585838
X-HE-Meta: U2FsdGVkX19YWn5HGZeQAsRz7adNPCmTPyOeD9PWcK4o3jAjSpxHBqbZke3G/oUsilCslD41EYXQgO+bcfb/3hwAoGy+woMvrkLPwOR7yRKhl/j4IxnnbbkFn6YAMvWlEuGLlFvywpmQcxj/DLx81BuT5hDJDpxlkIDHAd22nIeH1OqWIHZAEwNFetr/Hh0iqsJZQXi6pm0r8y9s/Z6TR5GxN+5Sc31tFOhnKZj+O8oNS4OoDLZhPugBwsCCbt4D3jFFFZGc/2kG8yp6gIaavL/b7gs5QIKTdhrtuL6eY8QpnUg4hKMNq0GZ8SRTBpNYruqQYcXqlBn7rl+OG7E2erkGy2ZeZDOOn+4ovxSrUT3tmoPAl+WKcNE092QFsIrSaWaJAlRLy/5y4nNOcj+3o9bw+EmylnYjQSQwVVOxWYGhQNo3hBcOML1mFhwQHo8gD2+tNgJ2VRheFiuhxV/OE7EMdFGGj0a+IoJowk6Bx96J26dqSqplreo0wpQYJx0sDCHYSL9fGuFOKH9IP5ArBlStvbFEmh/PNGjOmozMteq7LmB+zSailTnnOPAtL8IEXuTApnyp8o2MarwaucxUwiFyty/MlaeJCSe8t+LFwU7gKrA4gApLGOFvH83EYyeVEvAORNwJ3DVG4xD1IKEUc22IlZz64lV5+JiJCRdU4PY6GaJs47k5qA1lYpjJPUnD0LN80lfNaXajN9dJuqQ/Wf57I+y7joeojjZb/npw63cYze3ZNhbvcUj+m98H+NvBnsJVlmDyECNe+OPIAmzikjuhM8D2BwpCnBweIDpe18aZpUWygkOwxdkLit55iduJUp5erMLVDKyVWsiXzRzvdXb4zbWzMcdu5nyo14gOsjy9v9yIUYlIo0JbcByZrFhuk4+361djJDJ82/ILoFuLu44CH1v4QYNfYMebdnjxkrar4Z9TeYwGxtPrdpYhMcKPtMrEiXwEtQnJY0nuaXF
 cmGYq3Wo
 eTGlVyevUKUko0jzzdW0nHK+krpnliFUsen2vr7O/7lcEWamU1ZtxkiBN0iDhUUsLxuk1Soai/Mw6TYnB2gDgXVcCu71wUJiQD/INong7s8wsm5n2/kcSuKsMr1HPZfxlZK7fKs7xoYkAiRsC8YeO/W3TN5FYXdxkLtdwI7C2a62dMGnUiLUVHBbHH8blT/VbkQZSb3YVk3IRFXo2yY+Y06lWBDZqMwkdsuLsN+2xNqvPbCbOHbnhJ+O29HkNOdj2aPfeQNFzouT3UXhVemEdHUE4A4FalVmCNbLrqzI0iA6R7DSFSwCIoe6R/Icq/RDPoRj8RUbQ/MmWuss/os5amO665B3uHQ86+XaT/X+KNFr5RHkewOeuihr5YfRrt1GlqNiG3HcyoNlYIdGc77+n9np1Ou4SxKST6gVkF5M/1CgXSmxRgOhQCv175CFaWzT9nTe8ArJveEf9W7Xi2BSofuh1uUBP9UifqjfgVyV4hTeQuHpSjB1k5cQ4WOiccNwYzmZTtSn/9ahME33yRik/wlS1YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Whether vmemmap optimization is supported depends on both the configuration
and struct page having a power-of-two size. Open-coding this condition
in several places makes the support contract easy to duplicate.

Express this contract once in vmemmap_optimization_supported(). Make the
existing checks use it.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/page-flags.h           | 10 ++++++----
 include/linux/vmemmap-optimization.h | 14 +++-----------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b0ddc652e76c..6133966ba292 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -193,6 +193,11 @@ enum pageflags {
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
 
 #ifndef __GENERATING_BOUNDS_H
+static __always_inline bool vmemmap_optimization_supported(void)
+{
+	return IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&
+	       is_power_of_2(sizeof(struct page));
+}
 
 /*
  * For tail pages, if the size of struct page is power-of-2 ->compound_info
@@ -210,10 +215,7 @@ static __always_inline bool compound_info_has_mask(void)
 	 * but it requires validating that struct pages are naturally aligned
 	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
 	 */
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	return is_power_of_2(sizeof(struct page));
+	return vmemmap_optimization_supported();
 }
 
 static __always_inline unsigned long _compound_head(const struct page *page)
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 985a37dfcab7..0ae8a96a0874 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -21,9 +21,7 @@
  * HVO which is only active if the size of struct page is a power of 2.
  */
 #define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
-	 is_power_of_2(sizeof(struct page)) ?			\
-	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+	(vmemmap_optimization_supported() ? MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
@@ -33,10 +31,7 @@
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
+	if (!vmemmap_optimization_supported())
 		return false;
 
 	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
@@ -115,10 +110,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order
 {
 	const unsigned long nr_pages = 1UL << order;
 
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
+	if (!vmemmap_optimization_supported())
 		return false;
 
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-- 
2.54.0


