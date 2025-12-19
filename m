Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28C5D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6C46B008C; Fri, 19 Dec 2025 13:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC66D6B0092; Fri, 19 Dec 2025 13:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55966B0093; Fri, 19 Dec 2025 13:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC9C6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:34:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 622801A0386
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:05 +0000 (UTC)
X-FDA: 84237070050.03.8093B26
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C144180013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IkFfdw/S";
	spf=pass (imf24.hostedemail.com: domain of 3mppFaQgKCDccbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3mppFaQgKCDccbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766169243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dexQnRTVXD+ocEkT49jxHkdd8wk4eYUcAZvG8cXVntY=;
	b=KIDwW6JJjZ/RoPw7lWKk157MpioXL9GDIUuVzWykmXN79wPwCL0DzF/jSdv+IbRvuAGHAi
	9okCCbt6v7VuD7BUNnTpyXPfGlSiwmwEJVIPEZsZqYNGuQ6L8D6zOR1vcZ+f8D5xOiropT
	qPnCS5FJXRoSk3JbPWf8jRon9Ky3PYI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IkFfdw/S";
	spf=pass (imf24.hostedemail.com: domain of 3mppFaQgKCDccbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3mppFaQgKCDccbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766169243; a=rsa-sha256;
	cv=none;
	b=nAVWYR04WxuIGfRVbcTKChCkTfdVt8oXGZZOyL4UC2h1ZHge7qnoS7i6NQI2EF7BGSm+2Z
	uNt0fHOF1OZFLjZIZD/StudBXV8adSffrKLEumyt8ZrfhCN3DAbwVv3Vb9bhxLq2Xe4IZa
	xbOne+lUpsAooyHZ4eeAzcyyqFmJxfE=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a07fa318fdso34297355ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766169242; x=1766774042; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dexQnRTVXD+ocEkT49jxHkdd8wk4eYUcAZvG8cXVntY=;
        b=IkFfdw/SkxCpy0SqHBRaNztq5klHmxMoKDGdoSJJJED0Pw5UdPMJBoqHjPyuy8NVWS
         dbKZRRMxcVP08w4svPpq7rKUEciCAvCCOt8wyYAsUHqLYGxX0ST07QBzJglQVJtPlGZR
         FENnK79yWKrVeCC3vAVFqTDVeK06Kl3wGrqGqHhp5lbS8+XF7WVsTvfbduo/ZBcexVVw
         gkWdsUztVvHGgxZmoHZ0Or9sAU/WKiL9TukLjIvvAIGlSVGgIAJB79eWnDVp1f1xjhG9
         W+n+gB0Nh0zch/x+vhjK6fS2UHkNrsaDplPBySRDb4dpT0bxGvLVffmF49skrtHa0shZ
         pl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766169242; x=1766774042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dexQnRTVXD+ocEkT49jxHkdd8wk4eYUcAZvG8cXVntY=;
        b=apRdEYmAXyv+06ii8fIgTMCPnVqH/Sw/1u360C09DHJZKuD3OP+WtNJn3WQIgCxm51
         VgeTCQJNnNGHx7FkCoD3wDOh02UjOnxIExYHUoXY+/BV9Gnu7EKU3GVJ5GsDNLcGOnxP
         adNXuaOI3XliunJqnDT9ylBHDYxi4723dBAuxYpYBI5nBD1jFxOmtspMOYYa7mL3rorr
         dC2wLrbPQ62N8Bhwd9OOoznTdWwQSd075p4pjYJm1QwAiCKFbEOoqi8ziygoID5/uWF6
         e2J01Wt04KsX89/GwWODkHDyURzvnrIp8mEeFg54YXo5azi6YCC8dHrzrxZYZVc3vdxG
         6SQA==
X-Forwarded-Encrypted: i=1; AJvYcCX0TV8zOLvrVaOBf3Qa1DoE5PQAL6fdiJ+8BEuniEHHN1datbq2P6oBXR8IlHer+gGPs2TxzzBOiw==@kvack.org
X-Gm-Message-State: AOJu0YwWnpE5M3ZShOtkHbNToSbocAmuraEgdVi4SuoQL6K9KbesN9X8
	Lmh5jFM2rlVlZw1HVex0eJz7OLlShPtbl8Ay/OuD+dLJ4VQXLLRq9QAHoaHu0dxUPyEN5nVTdKf
	eMcQSiMTEpIMi/A==
X-Google-Smtp-Source: AGHT+IGpZ2pGRoO+xCgyW/fLk9ttUQoZ2NHr3ntaK2W3TUshAxXp/I0SeosreA/3425khqCO+Yb9NQ3gG+U3Yw==
X-Received: from plbmf11.prod.google.com ([2002:a17:902:fc8b:b0:2a1:5f23:7ddd])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2448:b0:2a0:b7d3:1bf4 with SMTP id d9443c01a7336-2a2f2212833mr41416655ad.5.1766169242492;
 Fri, 19 Dec 2025 10:34:02 -0800 (PST)
Date: Fri, 19 Dec 2025 18:33:46 +0000
In-Reply-To: <20251219183346.3627510-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219183346.3627510-4-jiaqiyan@google.com>
Subject: [PATCH v2 3/3] mm/memory-failure: simplify __page_handle_poison
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tqcgs8kfsq5qwqt4ru4wny76myyh1z6o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C144180013
X-HE-Tag: 1766169243-475225
X-HE-Meta: U2FsdGVkX1/rTA8bw7J74W+FysYSS+rNL+tp7nMMwOuj8teN90fegSrJ/mk4i1q6Qj2Xlcfmeck7kvsMUBInnl2ukY5D1OqSnza3vVtIjCyCWoyoLqxiw727l8wADVenvY4ewDbAFqmUis42ePvUeaqAyB62PvwtYwVUYyRCQgMk9jxpo8pT+EUxBB0BTS6WKaPLXWQZSJmcMeiLcn+0Rtc8IxNV76bEVZTFvCRJdvVNkSh3SdxT0TRbyYbzrlgACXIVUXVDgm6ZkhqZ9ZxThMHz5qM8kbqEjAvL1Mc2GYo792AKjY7zSccAerFVeraDfNu+itzz7B7Opp9uI5TWPpm5QeRPSb1qCrSBjKZejfUeFOZrd9QDAusQ37zj7YvvhReHog4Z4wdEIFJFut8ZT8fnwv3zYZiEhiIiHFaFWzcJVpVTocyFVVk5Uzv4vZVxII8UETnkZ6F56Ul/237woFXw26RPn+kTgTlC1ZwNWZ/qd6vldVreo1eF55WfgloTihx/7lCB2r6oh4XOYgpsOnSeLuA5DFrRyE8EWxgLUvZPRBgUvmT0pYo0/WQgZnoqtRAeL/P8uJce33IRFFV8+VPcW9xEyYBw5KCXiZ/vENkXsHDHYm0iNvKfYsku0dj3pkExGFNmBb/OTKqHhKvhr6Zj5dfjEvryW+m3U6oEpWcUIFE76Pp2RSSGmcEwcxvyudYxsnJYVa1DLX4/2Bj6AAvQLwv1K2DQY6nQkpzjdhe4dVTsNDEIZjn8XB4ua2/AaGvF+ceTXn9+IMpR+8YXNzRi7CuhHBew0KG6BthN5daVW/5AHpHHGr8GcnqlrdomHdqPtWOH9MCigCLoRr96kXES/eaq1cXo+qveSQK6bgy55VfkIsRBhv7hefR4bg45rfd7fwnPoK90wtO/WIIaVGEkcpgcPOX9j3fKsVZToP9nJG8ASrlFE7mj0jzFi/vOGsxIaAtc0p2FKXtwiRl
 DW7G7khb
 eVRWpc7j8jOdW+he0SdmtqkxEbrrmMWYGS0/moSpWGdKwRJL+sRMj0IMjc+KushVQ37g45kVdY0la1vBEoTHWMmtFwd1jrgdQK7PGzwMg5mwlB5wkvLhCJQMTj1TchKqcf3uEy9B5rsCdoPGaLTUHCAvNoMEVR0LSK4DzYY8fdG3HoBV8yWFp60CuksgCWVdD7OuId5xfHmurnuf2MgwAXr0/zuM6ILPyJ3QNy7JbWGHCXq65lHgN1qt7bFTOXxwI65zrmMMSfTUcD41w1YFmXzrss7Q50jlITWiRZ/rEVGXOptUpGVZgXIZeFyZoyA8Tud28r+jLb08wAXo56ou+my005z7eZV/M2TppORcc6gIqtvZfby6HCD//PVUbBwcchZfJB04+uHvscO0sn8jZjwPvAztrOReHOeiOPt83ONPSTL+a2gJ/1K1zo94gCB9LKxIj1yq+wVBE+DM2vkXLyjbeoswI5/ruztviYQsUtJjSXZjoXHnxq98XK7szvuWD2jo6f36BuvOFVWBsRIDBXxCOGVUKX0dYNN0oYaU9ZIbixTCiQvIihGxt4oG8lAvoMoqRKej0uQIMMXcUKJHV3NqS1vW4eI8RVy+i9AFiB1vGDzXbmNcsUYwj/1ZYm1fxKT6ryQhVXd3HdMUS3w0Bv4YhQQ0f4ZKXQ/X+3cjApg0Midc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that no HWPoison page will be given away to buddy allocator
at the end of dissolve_free_hugetlb_folio, there is no need to
drain_all_pages and take_page_off_buddy anymore, so remove them.

Also make __page_handle_poison return either 0 for success or
negative for failure, following the convention for functions
that perform an action.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/memory-failure.c | 31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d204de6c9792a..54ea840ded162 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -164,33 +164,12 @@ static DEFINE_MUTEX(pfn_space_lock);
 
 /*
  * Return values:
- *   1:   the page is dissolved (if needed) and taken off from buddy,
- *   0:   the page is dissolved (if needed) and not taken off from buddy,
+ *   = 0: the page is dissolved (if needed)
  *   < 0: failed to dissolve.
  */
 static int __page_handle_poison(struct page *page)
 {
-	int ret;
-
-	/*
-	 * zone_pcp_disable() can't be used here. It will
-	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
-	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
-	 * optimization is enabled. This will break current lock dependency
-	 * chain and leads to deadlock.
-	 * Disabling pcp before dissolving the page was a deterministic
-	 * approach because we made sure that those pages cannot end up in any
-	 * PCP list. Draining PCP lists expels those pages to the buddy system,
-	 * but nothing guarantees that those pages do not get back to a PCP
-	 * queue if we need to refill those.
-	 */
-	ret = dissolve_free_hugetlb_folio(page_folio(page));
-	if (!ret) {
-		drain_all_pages(page_zone(page));
-		ret = take_page_off_buddy(page);
-	}
-
-	return ret;
+	return dissolve_free_hugetlb_folio(page_folio(page));
 }
 
 static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
@@ -200,7 +179,7 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
 		 * Doing this check for free pages is also fine since
 		 * dissolve_free_hugetlb_folio() returns 0 for non-hugetlb folios as well.
 		 */
-		if (__page_handle_poison(page) <= 0)
+		if (__page_handle_poison(page) < 0)
 			/*
 			 * We could fail to take off the target page from buddy
 			 * for example due to racy page allocation, but that's
@@ -1174,7 +1153,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (!__page_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		} else {
@@ -2067,7 +2046,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	 */
 	if (res == 0) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (!__page_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		} else {
-- 
2.52.0.322.g1dd061c0dc-goog


