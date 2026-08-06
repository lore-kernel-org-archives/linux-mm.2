Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E2DBC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C7B6B00B8; Wed,  5 Aug 2026 21:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544946B00BC; Wed,  5 Aug 2026 21:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A976B00BA; Wed,  5 Aug 2026 21:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE3596B00BA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9E961605F4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:37 +0000 (UTC)
X-FDA: 85069069554.11.874C323
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf13.hostedemail.com (Postfix) with ESMTP id 118EB20005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FXiOc37t;
	spf=pass (imf13.hostedemail.com: domain of 3gt9zagcKCGsShNbLJbPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jyescas.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3gt9zagcKCGsShNbLJbPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMQCLZS6DH1nuKj6XZQA4CCWO5WJygqkZvtHLpH3qzU=;
	b=Kz1iYsZBLBP2sgVtfL5WfNp/QsSSTRbEf2YYTP8J6uNMeazyw4BOZm6oB5gprU0WCBwOYT
	G3XoRCFX2qV9VJ82dYPfjMa1irDquNYquKAXOsUzjIuYGttWzq/oWG4of51EYfP4YzKA7F
	YsRJ2yQQ4oy3kvQ+CGV44KglciYfoBg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FXiOc37t;
	spf=pass (imf13.hostedemail.com: domain of 3gt9zagcKCGsShNbLJbPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jyescas.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3gt9zagcKCGsShNbLJbPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978756;
	b=UX7dL0UMbDC7fYYN4LQOLTNArT8x3yrmPzvsNXD8MtVG4X36fA8MHGEPVwtUcVuayu2tsy
	AEaMWVPvSFcPSYPQBp2fqn+pr3QOCVlorl0xU3DzGzkjmxz+BHWRNTGTVt7YowbHDBWqO3
	Q20LbwNppUnSzD2nuLBhoPg4sbNCggs=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-848860def2cso1880286b3a.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978755; x=1786583555; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TMQCLZS6DH1nuKj6XZQA4CCWO5WJygqkZvtHLpH3qzU=;
        b=FXiOc37tI4KOeqVvqD2d/vtoT1Cb77yH/6wkYfMtGG9ysCy/9ORfEDH3DSf3wx3bV9
         UCmmd5lpfMXqQO762ilUPTrDYl/ushmm3QN5LyZJpKCe0sHgvhnRDAkIUfZoZsyU56+x
         WDw0ODcapusF+/e+SLOrvP7IzM2QQrhlmr39/Qi9VWx5HRQMsnw8veG/kmlgWKQwsLED
         e2WHTYAsnMt3ZkysMfdqhyiwhQi7o+Q5sw3k48qkNhwL3T2LHKeTpe5vv/HnEJeWCJx1
         LOr/qF7dU25YmHEvntpaRSQVpY5tzTaRstkLsBXe9gT1Z9KIWOo2ajxlnH8T7pSTvfgP
         n3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978755; x=1786583555;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TMQCLZS6DH1nuKj6XZQA4CCWO5WJygqkZvtHLpH3qzU=;
        b=Fe03Giec9wtrOis2N0OUl+3KqwO3KGgFl1WTk37rpuaPm0Q2IY7Rs/N432WSV/rV4W
         W9fMkO5ScYpOYZ7DETr7PsaqfaVeL+QwU4ZQH4ycMpHsfd+FMU7okvUJqg30ACQ+nd1q
         SHpowzzWRQLGT3ZpMFKg51TRVScuga9Q6O41h7tAqM6pMmeR5cnMakQkrsIqCyBDi2YC
         18Jzbakgdy/9Ap7XupUAvxfzO9VjiHAakhEoO1/VFZujk7OTnQBXfTR1e/LeViQKWY3C
         82YJ7cwcOPToRfbNxKN+x46FRuxGmVvLbT+tOPKFoyXZ74CEkKarZ0W+V5+8auw65Lgv
         ryLA==
X-Forwarded-Encrypted: i=1; AHgh+Rr98fG2JGvz4yuCry8zlBeB7gn7p5IMfkVRBx8s8tISB0euc4D5liXcIEg2S2A1J8J7/jfJvhIltw==@kvack.org
X-Gm-Message-State: AOJu0YzMMdwsLmBxSefDDBr0P0CQSeL2RrFaIRP3RDanS//6+RT/yXIV
	3x+XKMbvE+Ak59rbokZetMOnB4lA6Yk2Ze2NKLojFy0WDq7wqeT2LbR7kOf1yJQzgNrcm7X2zbK
	Rbg2jPXDzuA==
X-Received: from pgkg21.prod.google.com ([2002:a63:fa55:0:b0:c7f:cbe1:2d84])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e17:b0:847:8f7c:fa10
 with SMTP id d2e1a72fcca58-84f2e12d04cmr11046682b3a.35.1785978754627; Wed, 05
 Aug 2026 18:12:34 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:10 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-10-jyescas@google.com>
Subject: [RFC PATCH v2 09/16] mm: Read the nr_pages_allocs value given by user
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4m43df46b7tzcmxc3br3pfiiqi9qcd6q
X-Rspamd-Queue-Id: 118EB20005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785978755-601490
X-HE-Meta: U2FsdGVkX1+rxaZim2yg8Ez1Hkm8PqNKKojKmXzeEHLvLxmQqUN8qtv5RDYeajUcNQm4DMSYXanuePtN0nKBrc3/YLKCNCSsaos9s0kfB/ExcCzEJo4nOYyzkGF5F9Yf6GErgTPERoNVBpSk6JZlA58o9GqiW1yEsOokIlapInAjaF4M4NNw4MJCmfTLj2nWwhMcg+s/NOsgdg+dhGq56fwhRCWYPmJzXs72V2rb724V7m3wMjYmrHNLUEQVmbUunnaSycuzXAprD/g14xvxubXImeGcfTzB6d10SY+Phci450h2YQKlTtUyypBPKA+zEGJwkfjseVkgn2XxnYNlbRhS/H8f+Hagt09T0oltaO0YT29tlZmutKpc0to/pDiuGo0YI0VYir8WweGdUpZlfc09PRQoDoKAM5r9n+0TfsYwWRxVo5llohyfLcMSmDeuP2tcKeTG41gUiFiNN64L6J1jRlxHD5MulKPtqNvHUXhxzpNoYAszb3NjS2bon0U/Owtu7TcbQrk8Ry6zhgImvvdpVThEJaqKUQnhaS54HFguVG5301gW1lcDD/8/S7QMagC5hECiKjVpH+AsZRnrKDqCSWBmEo1n5kEPApnuy1bxUyQ0GWN5BwatN7vEC1/Wi+yUV+RHhXSAV5+K7ngLxqItEs3fw9l+DPIidNnOe4K2um3GHEGYksfizTNlgVKXa+Z8Q7qBMAc9S+zhYxh8ZgoR1YpSTsmRzDjgvp2MZw1aBkSMH8oR9vglS2I48Pp0sqowIa/nw4aWF/vWinJ8Hd5qOcaSqJXBP3yLeCnIj+LbP4878pzhm+7k1eG762o+qkRxEr2F0lnqm2eN+eilRvZP4YfmCPUjnHJa0BF8sc8F9EDB9je5BmRR/4VOMPp6t5PCBBKbI6PWD11LO0WZNP/n3bQ//XvLcUY499q6zRGGYsm9QzzoYkDuHN4HQq4Cm+dlsPJUggfEDeNegYD
 UPiMHvJ/
 bCmrQJYovxTZ/0V4uG2q4ye43rQ1W4kJhvrk9lwT0AgGv/XH864vzoI5AH/Wr3RvQsqLI7kGG2hvHbTO0ArvaTEk6t6OJTxqevRYP1066yj3ZX0/bjP1Dp1jomy11jfp2o5ErEGfRrk1f6+461Toy0msVqR1pYEFa4+1oKAbSUfJ0bhiWrcIToRkhX4pcy6owQKmclYR4LsJ6mMbAz/jdlmYUXs9K4s5ws+oy27/bmLMc+0MT9FvXmZB84zvbdMJlkwg7dfInt/ltP7Nz+QG9ySUKgMmfy2FIznpmRIb8jStdYsVU0TVHaSChY+6c7c4aoau5WyEwqsCQ5G4fXW7nt6acrTlbMt7BibTM6yghYojiQxvsmTY2yjhoFJMlFeasPakn3sXieIip7LEEIPQx6MmKjDLs9bB2UT34YRAkU731x2QOAdn9wiupWMxTT1tU98MQ+rZYmhlqsfOiPSA/LVncsKstAzY46VggXPNK7s6+ocv+blMGr/78+dI+aSYgjsFfSUKp9lgx9j9RfQl+n473iNrASASWPPvJeWrFL5zXwIjyWeCOU/jT40rwdupMWUCOjt28KC4EJiOpEXM7BI+D97P6VV5XyZRrEut9LYRFfOz1/q4NCt7MZRc6DSAzGhhk9CXVxsI8wNxWVXbDk9+kiYtkKStGeS3okd2OeGzIfpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change reads the nr_page_allocs value given by the user and
validates that is an unsigned long.

If the input is valid, it will allocate an array of nr_page_allocs
size. This array will store the allocation ids. These allocation ids
will be used to free the allocations.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Free allocs_ids.

 mm/page_alloc_hogger.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index ded3f0fc6641..9b1eaf3814e1 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -135,6 +135,21 @@ static struct kmem_cache *page_alloc_cache;
 static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 				     size_t cnt, loff_t *ppos)
 {
+	unsigned long nr_pages_allocs;
+	unsigned long *allocs_ids;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &nr_pages_allocs);
+	if (ret)
+		return ret;
+
+	allocs_ids = kmalloc_array(nr_pages_allocs, sizeof(unsigned long),
+					GFP_KERNEL);
+	if (!allocs_ids)
+		return -ENOMEM;
+
+	kfree(allocs_ids);
+
 	return cnt;
 }
 
-- 
2.55.0.629.g250fe7f194-goog


