Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBA5E91299
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7CC96B00A1; Thu,  5 Feb 2026 04:05:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26FB6B00A2; Thu,  5 Feb 2026 04:05:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D386B00A5; Thu,  5 Feb 2026 04:05:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A03816B00A1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:05:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64C08160491
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:56 +0000 (UTC)
X-FDA: 84409820712.04.A1A6E41
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA20A40010
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IbYJKuCW;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i1ShHh5ClWcmCHwMFMiVuWgx784rSmRCEENm03t/Yg=;
	b=CT6+OYT2ac9uHvmIcOj3scc+wT5yfiX8mJ/y2IwzxF3x9aEfr8hYl2hZ21aTedGEu7tgvB
	J8ynVOrZc+SBApTguO1/xnqsrtoYZCcvsmW24gL6Ng+1eBIQ6Kh9A3XOwO6NXAlx+WTv/V
	sIdHa8SXRI/YFVNPRcQETS5fLlaah+Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IbYJKuCW;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282354; a=rsa-sha256;
	cv=none;
	b=GGUMbyywtdy3WjgdEGVD+BGVsQdQmlNKMyGDJFMhAEVRG+Klfp+WuoxKqcZsfn9oBqm1kc
	i9R7lMnwkJqSlTBVkoAi1fWHbYgnqj4nNOXF1T5uln9ez2RZKeunPba0TO42znSrnqNuiV
	PZg1dwBvJUoHdiMf92nu7Z5HtH2VJAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5i1ShHh5ClWcmCHwMFMiVuWgx784rSmRCEENm03t/Yg=;
	b=IbYJKuCWmrvsiZOAkOoaeC9xzCD1Lt5XQz3LK9kF21xpu/f5IkXBXafMYiR0K3IBwu6HjZ
	R7rw+IdXnSDZ/CP/rhK1WzxmsO4jbfhw9hsmPfIc8CggrZn2HwYDfqQBrguvg1x+Y+sPQT
	YiFkrx6+ksXxJdJQAu+9tbTcap64BE0=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 31/31] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Thu,  5 Feb 2026 17:01:50 +0800
Message-ID: <cf1678070fb6bab6ede8fe48f835fe913a0bb728.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: qqx54rmf4i3hdggnthggfz3tagon5w4z
X-Rspam-User: 
X-Rspamd-Queue-Id: AA20A40010
X-HE-Tag: 1770282354-151181
X-HE-Meta: U2FsdGVkX1+BKSApoR44GZMoTgnjWTEoOz5gZSoBiTTejr/BTQzM1qUGYCwDUfkDw6GDZPNDcoXePQsrCvZBjpP2igZIrDY2WkEMdZ/KZyy07cKVIWdnX9uv29AfoqoSST2Wav9dClB7x7n2NM2mZUswxe2HepWPlyvSvIkIbUbWefnARTRH9n+5X72veb0+D1Xv04NGhSldpaT8oREbgXxZ/512rEDD5lKuVcCNh3Wx5jpvGjbZ4KhVpMe2iMQBS6+EMzAIHJgQG2rYB+KixtInJpAxHw3ArBm/IBBwv7LlXBdcWP5uxrRPQFOIs8RXS77Gh74T30exQFCIqyKm/EYUk0Ywy7v2SPSfV55H9gm5kQ4QM2gOi74JZMkD+l+i8TovIDIOW+25WUGAaYDHbql7SzU4RxTGnuHRh8dKPIIzHsMJgmWzY3xOuWGdMbCZNv8TQdKQqD6TewptEqxteehsCFwbFKTfwbq41/u+tuRmJ+oVdtbOXRgYm7aU+q1u9DMPOWj2sGs+DO++4Lx8qP1FYZdRycf+QUcnd+GTosYMY8/IybFgpNizODr8C/JDJ2jGRnvgKpBO8IVYk7VhGqEo41gnXry3p4tlXMvtlCJsXyys6Flwwkn3iTeTqm0Hhq654T98Avp2c6HRpDijIt6NjD5xFnvp+dcD2GOJ+No/TQKYjeaGmD4eCSXyvvG20chx1i1MpdcPB69yTP5n/WN0Yw0dRwimR/IS1pX/fuBZUFHBS7y5Rnx1fy04iwXadPYVD06hXcRPjG5LXXyABCN9r1KmNs97nNLxCtd/Q6JbCld7toAFFNrZnKihiT+Jw24bxrJqoXsqLEW70UMjH8z+Dn432FCGaU67cnNMaJScahnHM7BSGIps6iIoU+23BHXviRiPXFXWNcyuydVIqFiWrMAEac2Za/OJl1D3yZFx6Vt3UjSMgQNJqYI63QcxnXJbkZV02YpUjCVeD0J
 7LiYgucG
 qU5RUKi2yEHsPNNeB1Gu86XWmS1y1f13qwzpn37H3ArSp7SbmkTfQlRf8ONEs3ofE0HTeJBoLQXbpGMevsSpMSZ4UMU1PkRO+OrozcY2ANO4KmDqOA0DCiXr0QA82MSWfZEyt8LJHoX0aD+466S1WVws5HUIGz9m8prD19wsGUKOmmLhuAHTL4EWSAPwqvqg0fqZF5sLU2F8o/ZI6B+ip8NeEu0JxNbaKIN3SYpzR4jyjnXtEZxjXSQTMyGW5Ja02QS8K0/sL8ZHgR2HbazhEGLFY6FlMZ1jMqVrds35+uuyEhGIx1jRRIKuVpUMMx6ZzTReSo4PSgYCgE8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

We must ensure the folio is deleted from or added to the correct lruvec
list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
add_page_to_lru_list() will perform the necessary check.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b53..ad50688d89dba 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -342,6 +342,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, false))
 		return;
 
@@ -356,6 +358,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, true))
 		return;
 
@@ -370,6 +374,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4dc52b4b4af50..5f69b252b403e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1921,7 +1921,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-- 
2.20.1


