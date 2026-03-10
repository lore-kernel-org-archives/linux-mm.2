Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC90FD4F11
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0576B0099; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F6C6B009E; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D646B009B; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 413B16B0099
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:58:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9F0F140209
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:18 +0000 (UTC)
X-FDA: 84530912676.30.2495587
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id D9007C0009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HwiXYvpW
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+KNhzYEf7Z4qnoEfyB0FBqnVQ+fhLYoQUFp4aL3UqE=;
	b=CY5idckw/ZzDceoUSTBPwnH0qf1caBk4s/HMf+5SKXWSF8Omh/VX0r5Cs9BB9WJ5M4yJlP
	fZsJYOf3qtNIlgvYXDgZImK35fMSkD05BAVlxf+yuRac+7vB86UvrH1hxMBrKoV4IoN8Zg
	t3/BpcxKM3vnYxJFKkpYkCCj3IZOirI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HwiXYvpW;
	spf=none (imf10.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165497; a=rsa-sha256;
	cv=none;
	b=qj0mEDaLtza9kQxybKliYh3s5/jn9edXobgMuieW4RFGMIdkEM8XW8NzS8C0DjOIB6Vs2r
	kPG05GhIZFC4AwEyrYiWxF0vOqIIP1OsKTntbhGb5DdWQ/7aImxsTUnMOkuu6UehHebBtZ
	LjM0Cdowkc9mPddEhVR4Vm+naLatiVM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=L+KNhzYEf7Z4qnoEfyB0FBqnVQ+fhLYoQUFp4aL3UqE=; b=HwiXYvpWdxpdbwI5HJ9b11pre4
	+NDoDJOm53K24FNAinCfnf2gIk+eMe/Wy/ou3POGGIooEU7pxvdaTlCrksgaFjrupNYeeckABfa3Z
	B3FeTwEVy5ntcZW4SGCJAsAFUw1fyfJO4URWOXbPSiG0LyDF3MICokXdXhpccQJNu9WMlcyaSfkwH
	yDKssVbXjNHFBagSXd5xXoeB+4UG1U/iyE1XSl3cmj0iOx4WcRB5o/oEHZnVXGvYpvVhc1ALllxSW
	u3YLbjVAklqutdA0Xsq1GHIRO8jTrpyVjWyZmnVWySL04DOz/knNhZXXrtsOcfZjIiJcVunZ0jOFY
	/5dKr4iQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w01LF-003AZV-4G; Tue, 10 Mar 2026 17:58:01 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Mar 2026 10:57:07 -0700
Subject: [PATCH v5 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-thp_logs-v5-1-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
In-Reply-To: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1360; i=leitao@debian.org;
 h=from:subject:message-id; bh=oMoTCYuZFb1fOm1lw/KHx/Ut4gfjGFHilENByzx/t8Q=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsFubfa0/+t5o1gsfjniqKSZmIl1lGskKQPYKo
 rsp8i2E69WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabBbmwAKCRA1o5Of/Hh3
 bS2sD/9DQ4RPUfDCgzs0t0hPuxsUFuVQapY+aiPHNBci/XBsV53TnhPvX9ZBN2Uu6hmQujs7syl
 9P6PshEqr9nF/c9+bRe3OlcN4P1MVTvi6sOg2JNiEIpQCyggAqnJa8VAEcgEA+ozTSk8hRxskuD
 2dFFIMTQx8sVIrwwWlIZ9MhvAr/1Q7L0qgha72EwglARazkuGpjqCoKRrFZ7+IEofM3Mzyd87KP
 E6fbdoKm41IkJjZHZd0qsbmWNyoh3shI9OtPgZq+JqwhRGT2Hy5f0sdY831EOIZSSSmg4BjjwPB
 E6fXqZ13B5QM4gTURNLSaqccEfMVYpX3lABxLLaYKDVQMTVP9IYjTL+oDudvhK6evJgIuBDfXsV
 wYQEViNHFd9ZNbqz0qi84tpQG4uXD8h/1g0qoHx+gcLpHeV9M4b72nVFV3SjjFsjwVB3ODJ7/1B
 at1ffDTThmtSc3Q1p5EyoeHz6ZFUXLU/bVMDnQzc7VnEXBqLd5Fvte0hudP5vJnybS7cJrDlKl6
 G2YdYBBkdMyItjvBX5tFXqXK1UKJGzWHwEp2Gi3zbsO9rUoYoRUoy2+LXtvwVaqfiUG5QheHX2S
 fXy3AAQRJCypzxmgerTnxg18m3cLiK3gtzR6GKPo6VGG7H7mLWaqlHoheIR2G3vUS06lQY0hDTl
 Wvre2iBFY9NiCmA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: D9007C0009
X-Stat-Signature: hq81ybbkfn479yn9ti9cope7qomb4q7y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773165496-362646
X-HE-Meta: U2FsdGVkX1+cBIsC6jAxE74Ec5TZc+rqT8EwvA4eL8q/W8myAvEcjmcxh8pZS6/h8KMC8XikkUs0yxi215gycWYTL9t136lTg0gyTwEPTVhoVJdDJaeJ6zf3WqDFloyyPXCMhw7GSYeehQmRdOpekjMefkxnk3M9XTnGTIcLV8LLlRj2M6JwjjPO2rR+sromnfW6xaBwcyeDi3wpR6a/6iHifWrR0jAYT9QhCpYLDCC+gxE460WZC6wIvI24vqWYVJV8eyv76ja0ttd1wSeI4zXCLfjMR/b07YJ0az0Q207Z5s/0C08YrLAxaD2UmMFfjlGyvVDT8ZC47g5Oz2kkkqt/vYKbrX/eWB6xLm+Vf/pZ1SWeJIGo2KbDhp64JZCTn79DMxsb6KRgO4LqKtkLoNJypqdeyCGc9YALksDKhtZ5PbcgQHfS0zKcRpLnfCgjlq0+4a5TBKxT/v3y2PTAx9m+3L2cxdQkkmaLC/6BxqvVxTR4s7+usLq/AXA/aXt96wPKMsSS+jy3O2efJQuXgUEXDs4B58I+/sBkgQS6n9tpTyZKET7tmawxPExr3kw+W0I5Vy2Jzf2WFHbPOotxtit/Xbcg2zgTtqrvbmuF9QZf1EcLGbZ+MrsUYQVh1HxMTY/N0awDdzcc0siWkTt4aPowRxdzp1HpoWsWyZ9lQnUx3ZonWz7PDcfUqdemCn4vx7UGyd/BNnVzIcXa4xPlRtpMaHd8nDVb5rSqVG5/b0LDc8dgR2APLGkBXKX1z9QOSb+M7TQH7NwBab00B+sP0HST/Ix/kdYWafrXRL09HZ/nyKqEwhJ+sax1MzzqxMECzKG9HpI+CYUZ9bKh1eYd74uTmQsOD9S9hTHoQYNPk1/sIaXDTovHAue3SfAEwLNdPJXU4G2lrr/15jthj8bS62t35nozWkeZFPJ6b5TWKYJsc0PEKu6To1+Wqs7Ii2W5QqBgWGAO8JA/3EcW/0K
 WLS3qGPJ
 q+MY8hv7oSQ9KpAjBoQUXlpYJ/qpOFZc0DtEGNbXMvtAJrb1ar9LJnUhW0KEsAhhP+hh/PF1QR9zmsZBU77OFwHG8zXlWIo8KACZEW4jtw4EeLzsySwUKFdR8Muu9Rl9/h4QTE7HvBWLOnaUYGOCM4jY4QzFgx/YLaUuVMYkqXyjHZS8wuEAlilsAL9bWSLWxkOcc+8zFbL0uZeRrOAgAThCooptau0CNItEmS6jsBBahRwfXvFRaZlH7OFiJ18JX5J3fHdospR0Tj4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make set_recommended_min_free_kbytes() callable from outside
khugepaged.c by removing the static qualifier and adding a
declaration in mm/internal.h.

This allows callers that change THP settings to recalculate
watermarks without going through start_stop_khugepaged().

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/internal.h   | 5 +++++
 mm/khugepaged.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d99..7bd768e367793 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -623,6 +623,11 @@ int user_proactive_reclaim(char *buf,
  */
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
+/*
+ * in mm/khugepaged.c
+ */
+void set_recommended_min_free_kbytes(void);
+
 /*
  * in mm/page_alloc.c
  */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610db..56a41c21b44c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;

-- 
2.52.0


