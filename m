Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08048C44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E796B00BB; Mon, 20 Jul 2026 05:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97606B00BD; Mon, 20 Jul 2026 05:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADF96B00BE; Mon, 20 Jul 2026 05:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B32926B00BB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:33:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44F831C0955
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:11 +0000 (UTC)
X-FDA: 85008641382.05.AFED0D9
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88EA440009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MFUh344J;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cX0YJdXVCNf3FoytxuzouNIakKfOBk60qEk143M0obg=;
	b=DuedIT8Z2kQE8P+YCTsg7iWZnFFhSM0A8xCSs8WkrwXr02H+R5o6AcSqufzOcDKJHSW0qi
	NRmj+OO3cPPiMLtC6UBKYcL7z+PV01UTT3cZ4pVo1iTcXcA58XosCYzALpVU1DE1c3P05C
	a1TRAqdRizC94zpR+8vbAjhFNC1YKzY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MFUh344J;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539989;
	b=uoxjNR9dVwpa+O8ffDkR2OJxrFQAmvUvmUqI1bOQpgm+wdm80JM3/Sx39ZafCPt/B5tKmY
	+ENPXNCOn4aHFwlD3NzmpbiZxq5Vp4GKzS+JBfMy7hSnh5mWpe7WliWGXFLEyMq41Y+Tt/
	YQiDk6VRP3JJihEJ4/aAx6qeMLGA2e0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cf27856f9cso42074935ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539988; x=1785144788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cX0YJdXVCNf3FoytxuzouNIakKfOBk60qEk143M0obg=;
        b=MFUh344JSv9YqzQ+4HvR7NRsizNZPnQcLxCtvLkmzxuA7B8kzAxVLM2ba0Y6zxP8SW
         9PUeofl4ncv8pNKXd77cdx6mfMQWZl+UFi1umFZhwBcWZWXFPIxQx7rKsVye8eN/8kxx
         AEnTdAj825A4ivQgnokWQf+Nb3siwl8PH1DrPLJ91jdJq2rauppWLW3foq7hVJF2h7H6
         RqmVe7goWPF+jxRgYtAb5gSc+EBgPfSG/tCyuIrBBFHfcvp8Pdd1opQ2UhnEKmn9cteu
         k2Mf6/SNnuT8xwYX45+LHndjQTVavUMaDJztFyFdZLJOvQ/RR2CVtJwQQlSnzguUvPC1
         uazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539988; x=1785144788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cX0YJdXVCNf3FoytxuzouNIakKfOBk60qEk143M0obg=;
        b=Rpex2J7d3C86I5+GR3ioa24nc6vt+BzD56OmLcO+oLdXzBZ+JG1upuX2axLAC1jiBi
         QsBlbAB+N9kCRBtt/LHJhc9B5rqHf3NhggTPnNYLb1ishRJynWPNq3jHRR+SC4gJl9w8
         uGeunrQvrUTgbr+Y8Ydag/OAkNjLo1p7T6qoWpEZZhvQegwMEUW3oGLZwNzzkYfnYIdV
         0FN0XAJwWD3Ua/TLTTK5O6aJ2ESVCbNy6eO/Xx3zZY7b0v/sYxbJNOmipJOFEBLvbJkA
         8/GFCgE0I5+yPvj9ibVWecNjYgVDAd1CTUuY3ZQLIA4ncPEMDVASujzTAbgshimPybmc
         EdFQ==
X-Forwarded-Encrypted: i=1; AHgh+RrIleMjrLwDpbE0Rq6FXkCOcqoHdleso+fPN9cOQ0OKYeXbEUG+sX9+LGYNCD12VcvMMjwecuKgrg==@kvack.org
X-Gm-Message-State: AOJu0YxY2hN8jiBNNvPFdG49wl+hyDYPUWPfgIv45pS9H6JuVMMb7Erw
	Eh5Ps2sbPQMNFzCUMX+XFq11Ef72yXMiaEZ2kxzvlz1G9ggq9I/4UtSKXZwNrAD+h1E=
X-Gm-Gg: AfdE7clUbHjDGpGlvMFs6UN8uBvaB4Tm4Sriak3afOQm+gh6fioa8G7sbZJEcaxFVjH
	MLB1Q7AiDCb2+bmmzYG+8Di1bG8ZHscgz9ICzdgdnYuDK87OnUFtWlFtZNhTGub5X0PNpIog8GG
	98VqDFe9fkQDDWbdmXIp9WgTYqVXgXPi8mONicpmiyInFRMXX9la0ZEIm/wER6GT8GJBTLBfyoX
	vF/m++fKBBv0jjWJdeM293JUYawzt0iw0yZXdWHwjrBGe+d7jj3ZzkLGG/sr0UyDxxhqoxZumvH
	jE/aLobheV64NBCSr/jO4JxBEOOWT3gwVSBXCxRoagVrlyP7PtsfJdutgXAbiC9nXkViJFTjD12
	LThSLPq+U5jtn9LbZM0bYnCA9bPNsgKQcQ7tc07tOF10vp4JsCglb+6jmTKoKd4tWkRU29jyINY
	MjWC9hxd7gaJ9DaKOBSwj8rE8=
X-Received: by 2002:a17:902:cec4:b0:2cc:6329:b7ba with SMTP id d9443c01a7336-2cf34857697mr136542375ad.16.1784539988367;
        Mon, 20 Jul 2026 02:33:08 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:33:07 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 17/17] mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Mon, 20 Jul 2026 17:31:27 +0800
Message-ID: <20260720093127.540540-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88EA440009
X-Stat-Signature: mxep5gykks8wxanjfdm883reoacwzp57
X-HE-Tag: 1784539989-922564
X-HE-Meta: U2FsdGVkX1+KH2SF/sOYT5YFS0ticSUkfdq8jkRJl6AhMYEN9WA6C16l6kVS8Gkj4+EJB8Sg7bV0H+Zac1jNH4LjzFo/JjJ8eC84tMsbxywykT034SCAvd5dARaYnxw7diHIOXKD7ObPEz+2J5SZ9fMHkoRMnMVEbcqsO1OuZKmTN+RqHkIG1dOpuj6RW5i+lnkPvIl1W6H5NaBUKUr7Vo4yJDwzK347dx1pAU/YNLsniAlgKNGCgbjHCT0rOQVFl+ajeHSSD2tizpx8Vqii51r6X8Ih6w0moo9TH6WNh/xtvSYc4GiAUaqVant4miqo/P0BuuqwdKNw21oUdC8b7cBnAqSZX1L86BpmYAArCMTsHqWY2b+3T3e6WO2uWV6hUIhah/8Vz/xO9NL8TZw96hWCnCweiJnB0dZqyuFA0NGXRMasIv870Doh91PsKsOST34+U7okusmx32ph2xc+xrumITYUuAjjANTElbJMX1lBwS9zbCHI88lCYz2CHtnZMeVJnjh7a/KifAQezLADsddCovZ1yeHTOwZyJoflGbb53pm9Z6LZKkBkn4Uhd+eyzvK8gU7iwXHqCaH+WS62H09u+DsYPKw4E23fSQz/yFrNSa4JD190CoBVuyN2V0L29StziBMIG/z6JmBZIvaJRA04RlqjUNvD521dQ6LpbhYetc3EB0iVtc5E/xlktdvvLNlpA1I6hz9uVTMd31vy/tgx3tjTuXso7oqGqo2grReWTb0fxadZPVREvnlWnH8C9T3u1gTz2DNJjnBdmzEanmZfIkLcOxAJQg9ijx7PcjrRkxitzDYi1iyXWqfGx8LlDR4OYe7BKwCUe/nwDiAQVYXLqJG+ZO1oIFajEhXfmOShJBMM8bnANoiNbwPRWCVUhZBe6vLsBaQNWmBsvg8cxb6y4okGUK6aQLn11NqKTr01umbS+62C6F9i8BcIJSQ5hoWhJtx5OQpMaX37Mr6
 pj5bdxB9
 9TA2mxLfEr4E6mf8+/Z0cE2y7gVskfHXl3qICUtdS2iunooppXCCXQJw6Yzr6ZeWTVIpe51eGZM1LEDgjKlEHpRMVRfKtzlMTVpBOsO7nIIM0WzSAAucumSZebFHjV9cArs/abz4nmAhePL3MCwuklCHIVwTz8gTQX/pEo5t8dd32IBDoM8BX4UKDFmuM5zWhPPglQMO7eNvBTaQUW756UhKGhc6PqqqbHvUbybsQrtUrLYXOCrMsbwlYJasPxZj9/NluDf5eK2IqDkVqVC7AihwamJioCbWJRuGJbKFhdjXHJmEmB9zo2s6kd0W5cZV/nQqbFVoOZc8Jz5KARoftNG+PDxTrQ60pnBvSjJZAvKWTPkTNJY3Hw9zMTJWdERDYmelrVpQVjrMIh7rkNTz5LjntPSDDE7SKP8qWipV3TfExGC4VvR+nE6z/qr4Dmqq/JYiiTzJusTXdN2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c. Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h | 2 --
 mm/hugetlb.c            | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 255a258f11d1..900c95e346b2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 364fdf254e78..47e3147ddc12 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
-- 
2.54.0


