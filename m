Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D839FE73165
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 19:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60E56B008A; Mon,  2 Feb 2026 14:41:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7896B008C; Mon,  2 Feb 2026 14:41:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5C46B0092; Mon,  2 Feb 2026 14:41:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACFE76B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:41:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 378F0B698E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:37 +0000 (UTC)
X-FDA: 84400536234.12.EEA52BB
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F8D31C0006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cKgCt0zP;
	spf=pass (imf18.hostedemail.com: domain of 37v2AaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37v2AaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770061295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xJyNzAFjx6HxtPx+hx1i0rUvha8B/sysQiqMz13rtk=;
	b=7UWY61l1ltL5F/9rU1G4dovsaXXNL3OZqe6ZqJnrET+mdDRmt8jCH1Rgwz3Oy6dAIbFZRr
	3a0jUEXtJ+6YptH8wLiFAOLxkOgHx5nPRROfZwbXZpqv7ZZb82qrEm7QbmGNF3Hg0Umul0
	Acerb+zLlu52uI9IRqDGn80oTIgT9QI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cKgCt0zP;
	spf=pass (imf18.hostedemail.com: domain of 37v2AaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37v2AaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770061295; a=rsa-sha256;
	cv=none;
	b=qQI14Tc2pmXMQ8plFinFcrii2aWzMWuecWgIPdPZGFGqRind+FxePZC9JpLfVgZQnHP7GO
	c/IVHq3DGBQ5I43qT4R9GkCoO5sWsNb4fKRQFzfhSWj23CR7S7YfGS2i/r9k0uamJkwMTG
	9gnyA4b+o0BFbe/qvXLg9AjvbmAYg6A=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a07fa318fdso49479635ad.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 11:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770061294; x=1770666094; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2xJyNzAFjx6HxtPx+hx1i0rUvha8B/sysQiqMz13rtk=;
        b=cKgCt0zPgX05eg1TOw5joB0mz0mjPIrGrBituButi0Ac5Up65nNTHax+0WXbV2fBGD
         2Nf0XpUmraGVwQQr2TQROW41oQcT30jvCwfI7UX3l0CL1jszafsvFH1hxAWgcSQSkTX8
         Oe+4rJ3D5qGI6sYwXHDbGhQIbkfkS3jwQnnucEXJzE2P8sEB6LV3DdH8kqFbqpB5jcZF
         +GBjhavUWZtzU1NYnH676SmtmH8fhn+KPCOaixCwfFBtr3CU2nRBmIuVfumNbkIN1nZ6
         uMDHIvgTEAggXwgLRjke5n1MD29Q9KJyoVOZZsGaZ/f6Lsnu6M8Q/kYpX3gWJlk4ZW9a
         tX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770061294; x=1770666094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xJyNzAFjx6HxtPx+hx1i0rUvha8B/sysQiqMz13rtk=;
        b=RIvaBAdxxu+P6/dOsEtqEq4Xbr1LebtZ/BfeVLj/FTex7Y0xE3c427v4j/K9gdAVe6
         9K+XEj5tUWXyDwHLHOjnEqH9KU9xv9OKk4OBiErgG6wbTSbXq/iZx+7k43eTHEkZANBN
         XFgdgRk3xQs785SpvTBS2OvwL0Gwelz8dbFymNbJXKen6V6kKnsnYmIFIKr84eRzLl1x
         jUUDRQUWnIxoYyh6PSuTuzvVpjwEBphr8L9ZusFZnLPN4xHq6Zzn9PLepjE+dYXeon2E
         AYOpOjO9WWcjBhfpPBVG7UtnvRdmYkCMrOgY7Q2qSiwj8do2IIGkVh2CYd+wd1NldzMN
         leJw==
X-Forwarded-Encrypted: i=1; AJvYcCUrue015D5HNDPnSBx9nBAo2EpCGf/Rz11xA55+uSR3cdkb8sYihg3K52r+Xdi1G/v74ZWn89QOfQ==@kvack.org
X-Gm-Message-State: AOJu0YwQJ1zLyiwtfx9vJLu2kkrixi18mB/TJS8crOSzenjhSXk00bxe
	SJDs0b7K0Abn04x0f9IMnw9KWp/RxRsmas+izev+CTMjfZcnski7+OXXWsgFZ9D0qe9HVHcKoWY
	v7kERMi7DeoHwQw==
X-Received: from plps16.prod.google.com ([2002:a17:902:9890:b0:2a3:29a1:b818])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1984:b0:2a7:9196:a94e with SMTP id d9443c01a7336-2a8d96a2af7mr109252935ad.15.1770061294535;
 Mon, 02 Feb 2026 11:41:34 -0800 (PST)
Date: Mon,  2 Feb 2026 19:41:25 +0000
In-Reply-To: <20260202194125.2191216-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260202194125.2191216-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202194125.2191216-4-jiaqiyan@google.com>
Subject: [PATCH v4 3/3] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9F8D31C0006
X-Stat-Signature: jcb4g4zyfo141kk6maobhkcwbes71ohk
X-Rspam-User: 
X-HE-Tag: 1770061295-49986
X-HE-Meta: U2FsdGVkX1/DLrAhH+8eUkBsPOXJxk8bFkMroyMt/jrvrh3CGvYkgwncCPi7HX6cMcdDueNoucBbyKUyi4FWvczi0VfuyvPg/0V3wGuv4MQvJW8Goe5JtG84fajDwxfLZS4I+eb4TyXq6wGW30NwsWRj8Csca2oddJyrH8kPDPBucO4kehfyuBGZr0G1dzu+xKzbJ/d8Zces7mbn2FP3s6BSwzwXSdC3kZPVWnYh1O7l5TUbvwdo7qkGaGONz7HWYYCk0CMX35zoHTQ5yZtZRIKyPidZPRrS8FQXZYbc0DaQuaf6x9R4qE0NuCwCRa/wGnH9Neix3ZyQ88ekRJR3XwEdLCcF4p41++VgtNVVb2skvS5Q+qeoZsr1zHsoY8+Pp1zeUmcY3muRLntrHwWNDef/AGbAE0qWmpNSrTJXVrMyhLWVn47Jh3RSTDZcTK8vv4ikuZ4gkmqJM+rhapF5W7bQ1L6iu0CPvVQquoBeI8LZg2vdO1Pkgmy6THhOc1gkFN84WsN+mRdi6QXuDVXE6Hn8MAy9XQviipPVH7H42bNBX/N0SbVjY05oYJUYLr4ScAXbcHdjo9HMWLGiUWnTCJEyklXNuHgv8odvObVsxO2pepgqlsMQD7N/I+tqt+yik+9MMgJAMwr+8jrWYQyEr/ZgmT7hUF7C7e3GnJOJr+tTUwjwiUT2ROQshFxW527XJGoxRZzZq9yAB7XCOSNYxe6NSMmrvEJWIXrWFyEL+XVvNXX4e34404Gvjrad/ADHW+cTf9+ZJ/FV8+uhdCH6ELSuJaEicNASrrk+xr/mfJ4pb6VXx+u9nvzbZsCNippXu75RlkE7vXZxMN/qslhzT0SPN2xbLuFvlsOERXuhLSrQdAgriiixlMKaOqgQpLXQBj2ErDIU49zBG3VJg3hJDgsxFJl2Y/z/GhPAjJDDWpo84wki+CMLHQyA+eJTD0Zc8GokgQygmTgajwgbBeC
 d+zNKZfo
 wUJGN1T+NR/vDFcZVh6v9/8W2R/Jnlj8XusRDlfy+uQoBqzyT3Ef1GLX4952lzAnnIgXc9q3KXEca0dowB47p3lMgKaLq4ophkHTsPjlPoTqO1rVHy591TQ3Ej3QWVoK2DTSSwTIy/D+VjKpiiF/D6vG7oI8Sohmt55UqSTSnIaa9IOGhaonqIrVxxwAU9fbQ/XE3LdRVF2kK0Vz5INm4javr8RmI1bMF4UsaNJcXoyV5iD1DI/m4yek9Pymaz7hAco55xdNi0Yszktxv3F5aGMzqH9c+tiWnGKX+hkxcq5KS3HNzfp627MQZciNm1B9kvzBX00s0wMo+49r77+GAtSU0B21hsbM3h/Iobur3aiUkVBoF+fW7KFCo38bGNQkYdB4hIhKqs+GhJlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that HWPoison subpage(s) within HugeTLB page will be rejected by
buddy allocator during dissolve_free_hugetlb_folio(), there is no
need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
succeeded returns false, making caller think __page_handle_poison()
failed.

Add __hugepage_handle_poison() and replace __page_handle_poison() at
HugeTLB specific call sites. The being handled HugeTLB page either
is free at the moment of try_memory_failure_hugetlb(), or becomes
free at the moment of me_huge_page().

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 529a83a325740..58b34f5d2c05d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -163,6 +163,30 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
 static DEFINE_MUTEX(pfn_space_lock);
 
 /*
+ * Only for a HugeTLB page being handled by memory_failure(). The key
+ * difference to soft_offline() is that, no HWPoison subpage will make
+ * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
+ * so take_page_off_buddy() is unnecessary.
+ */
+static int __hugepage_handle_poison(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
+
+	/*
+	 * Can't use dissolve_free_hugetlb_folio() without a reliable
+	 * raw_hwp_list telling which subpage is HWPoison.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		/* raw_hwp_list becomes unreliable when kmalloc() fails. */
+		return -ENOMEM;
+
+	return dissolve_free_hugetlb_folio(folio);
+}
+
+/*
+ * Only for a free or HugeTLB page being handled by soft_offline().
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
  *   0:   the page is dissolved (if needed) and not taken off from buddy,
@@ -1174,11 +1198,11 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (__hugepage_handle_poison(p)) {
+			res = MF_FAILED;
+		} else {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
 		}
 	}
 
@@ -2067,11 +2091,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	 */
 	if (res == 0) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (__hugepage_handle_poison(p)) {
+			res = MF_FAILED;
+		} else {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
 		}
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


