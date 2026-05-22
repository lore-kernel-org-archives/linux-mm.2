Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF7ACD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B1D6B00B5; Fri, 22 May 2026 13:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED92E6B00B9; Fri, 22 May 2026 13:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6D36B00BB; Fri, 22 May 2026 13:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE22B6B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74CBF1C1D87
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:53 +0000 (UTC)
X-FDA: 84795783786.03.6D33981
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id ACC0F1A0013
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Oqnc3hXX;
	spf=pass (imf19.hostedemail.com: domain of 3TpYQag0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3TpYQag0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYiP6dsX2SKN5nuRcokWCB8bypHWDNwNiF3PrVV8B9k=;
	b=KhPk4tZKWFnifufpkNS+0cURFgKo7PbLhjyuWP6uX2SYbqIzLJBDW6XWFZjK3hJK+qWmI8
	zXWz0P9dm5o2WmCotSnE8On56TTNTT2uqTsBYX/dgv71AkzOkGSwR3C1FxYQpKjeRvVDSu
	v29Nmnc364kivoV2LRpPlAUuv3WtCzo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Oqnc3hXX;
	spf=pass (imf19.hostedemail.com: domain of 3TpYQag0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3TpYQag0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471951; a=rsa-sha256;
	cv=none;
	b=DSvdDBu/kLIBP18Agp4Gw+KFZiDJ1lxiAw9fjuMGA8d8DznSTkL2NtB9SK8agi4FBI+dzc
	9jJ2+cUl0bi1/gJh9uD8ZyA1RxGurmDDJokOcfF+NeOOJoXLQ+uKKgvqjVXRRbNWoUvcSk
	2GwFZ5z9P1/iI0MVsL+Iciv47V6jvsc=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ee5b73c5f2so8476375eec.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471950; x=1780076750; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mYiP6dsX2SKN5nuRcokWCB8bypHWDNwNiF3PrVV8B9k=;
        b=Oqnc3hXX0y5cEVkGk8wvAyGA0eKKvuUqA1JXIrDx8g170GYcfSRN/f1wMHuiOFqxra
         09Bmy4THByCE71VZujDUD8ulPiZIc3gWPCTVgw2eg2/V/jEVF0hv5Eh++3b+QBVjIJR4
         B3DqmjZBi+KLveWMDWShjNTi8KqJX1K3f1kYqi2jfnzDvvR75vNImvg3A98Ngjt5+8m/
         xs8SkcjVNs9yN6ruiogKOW5nqfhaxMtcb4pXbD9GCI32onPSxeqrOCuLz2OX9u/GUlSB
         QLVisQDvCp3tFZXJ1dQsqh1nFVQArsM9PkeOzF15rnMT0lNUslr/G0RLf4sBVhPNBcFA
         cXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471950; x=1780076750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mYiP6dsX2SKN5nuRcokWCB8bypHWDNwNiF3PrVV8B9k=;
        b=AgVnpK7hbmDn8dRn8+m3hvf9lLX5Da9bTq5ojaMh0iM/4pGVf2mba99OfTPr8wqEIF
         5iTmzUtu1zdE3seUXus2yYs6xuMIjoUQwGN1o8E93HBpImgxrp8eVzp+ED/t7osqAglh
         ifEbgogEtykhAaMHJRbZVWiryuSBtoPE/wS9FtELR8NP1p4OTGgVQOiYLM7Uxgoqr2RU
         sl1MtZ8icbWv/hnUB5bGZoevrsVb2AYFqzXZfOmxVD0Czi3yWdBCBhDfA6ZYYa+ih2m4
         xwr9EbWSmRlq9h9V7EFOFfSO/Vzj6sY5U9UxzglpljrB2yOCKPmF7G1PZZb9w+QTA4LR
         6wwA==
X-Forwarded-Encrypted: i=1; AFNElJ/mQ04LneWQqMtLygE6pzpK0/O1EyiV4oSCjITdAyI3o4qQIV0I2Cl+URPNlYkZrgcvcdZ6gHW9qQ==@kvack.org
X-Gm-Message-State: AOJu0YyIRp+Lqs99uUoyc3hpDKHo8hVwS6u56dp287CrkADTWXRrmbco
	HBjl56WCRr9+gFoNJ3K/qtNgohE/z3fGg8GBVWd3Ru4SK5PhSVcPLK0zYorrT9nTOwWpkUxCHT+
	CLlaSWzN4Jv8odGV8JTgWnusS6yPm/QXWgA==
X-Received: from dybgn40.prod.google.com ([2002:a05:7301:2528:b0:303:971a:154d])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:2c0c:b0:2da:b77a:d7a0 with SMTP id 5a478bee46e88-30448ff25bamr2480409eec.9.1779471950175;
 Fri, 22 May 2026 10:45:50 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:36 +0000
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <453a36b27b33b01aabf1d7d020bbbcb4acb3e12d.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ACC0F1A0013
X-Rspam-User: 
X-Stat-Signature: rk6k5i6g9odmapms1a5ya3dyb7mqshkb
X-HE-Tag: 1779471951-25337
X-HE-Meta: U2FsdGVkX1/+Ylftoi1FXpR7lCHS2Z8TBEIjxIxWZpUscZuV6zepe1oMvLReDLpU4yXsntROjLtRL+0WuojZBD/0nuV14++FLYAAIirwliCanmrKHeIHYkmqscvaF62MMFpRR+HHSbNkKftYO26FslezlUNJyrfeGRH5vLYVQ6nRpNnvswsK2mdmzhJGPdXmg6bRFmFTa8NO0zX84zrGZmIkf/utzoiLGe9VSw8F/d9QxQYMnlmeP8SuqX7mmradz2hOxlG7O7vvPBBRMmkGJelKgxt89gnvzqoYCZCMBhJG60p+mE/XkAR3EdpBVYIl0bgsumVOHqQ++7Oxxn/DHPJLesICE5uBCE5Qageu/1dVH/5tK9rTai5D2F763k1WAhwgrUo7UFHkdprSR49s+LhRw/491jIXKPBDki2N9QYXVPeJ7otaYWsG58Y05hjtMYXRhVHFd9N0uXYZGIsyAaQGuCyaElIUKtrs+qVp+mQGimFX38mwdXGaub3Mp1BGU07yiAleZOLoKY+ivHcPjMLP7PUkw46eeWCzgQ5pTU7JXAp8tuQWsv6GdAomztmTtGhMnWDZHgZT7dhZXHjH1MhC++/6EE8jLFVfPORMutS9sO+Rxpgv8yARgq65OEAVDfj8BuyuLtf0QF2z+MTu+7jh9eHRUIWQVCRV2ILCRB4BR0hE4INMRoJeWOOfO4zpnJ4XgmfgXAb10Ts1uysTSqFwo+1ZedrAV+bkbO7e3y00Lc4KfiCx733ntBz/ixvrEkgL3JY7d6X7ek7HvZIx1KmtcKZ4cNI226iUXXlz2WI5Y7BHZteCaT9wrm6WJwoGP5CTVaoirL5lJzbFNYvudh6ubNiOUKc+d4nubc4WMpAEnB4f/uHkIHOFQ3hz3cqjvBHLY4G/ikuuSlmpwGyiQ+xBArBUpnF/3p1MoqrsRsAxsz7rggqJt/uhoQSU0SljzfV/5icnsRXCrCvRZdh
 tFlbeRRs
 39TuwRASh3jT4N1uQJxJXi4cNpfKmXJu7LVgljWkU5Kvdq+qWy9Qc5QPbcfRQrC9C2MO6zbG+dqQfmGdwLuBskiIXsu5XZEd5yquOxQCCjcCTEbpZz3NbO01C8RRTpc/Qn72GNvLeRocH1MF0NSUQkvud3RjCqc+ZIEbUfbpHTPN7v2LBcMSrHg6zAKZ6vUVfQrUWoJlnURsqIO7uxFHZjbFgw+9OFEwyR13RUFqaX99Qyvt9xGn3DCrIr2ZFJvfGgE+r588bXcoBgLsIya3/mZhinTYiza0GGVrKiRNQ+dmTQFiEZRw2U9g32b6DQx+RgS23CtsuUcNQ/cLW/3uIZyRW4Cd7+jvEys0MQHoq3gfXtfUu5ATYZHK4w6G5RSosN2cT4HsYeai0apfRgjQzPKKWhXVfJFaW0Jz2pXgOyQJOKebFp062qe8uUDyk7DA4XQlFb7J7p3NJu6dezdRcv8vP0iGC2oaLr3MPCwM59l7idDdRb/uNlq5Fg4BLTRiefjqpq+MRBJoM6RFHCHbAPhR/sSWwJKRWiaNMOmd+adtAm2twhAImqgwBQBUjxIbWFOaSsakhsuRpZLCZrugWiCm3BU3fvRqsEAH8srRevG5/5/xDtuQ4e8gJgfBbU/5nuYVSpn/dPe37OFkJ9xrot/9s8R6TcWQTTnUlESs5GGET0FGOagcKNyIc2Kszfg8tsYdOcni6oweDrgzfGjfIqLwlw1R//zbkZDo/VOJZAVMac5oaqDiA16ppKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c                | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 45f158bee0a6..6c4c0e609cd9 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -20,6 +20,7 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	__u64 inaccurate;
 };
 
 struct allocinfo_counter {
@@ -39,6 +40,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -48,6 +50,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 6c8743eead2d..b1fc14eed7f2 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -217,6 +217,8 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
 static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			   struct alloc_tag_counters *counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -239,6 +241,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != filter->fields.inaccurate)
+			return false;
+	}
+
 	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
 	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		/* We assume counters is not NULL here as per caller logic */
-- 
2.54.0.746.g67dd491aae-goog


