Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B889CCA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 14:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202D18E0001; Sun, 14 Sep 2025 10:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA998E0009; Sun, 14 Sep 2025 10:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6478E0001; Sun, 14 Sep 2025 10:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFAA38E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:38:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC4E71601E6
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:22 +0000 (UTC)
X-FDA: 83888111244.14.DE2006E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id EBAD54000C
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf04.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757860701; a=rsa-sha256;
	cv=none;
	b=VtZvThfbC6Ysc+WaZrkpN5z/wGpF+kxfNRriEzmSg22msDzRl1qYCAKmTXd2r9udHVoB3D
	2OMAv8y0pz0PC7xXabb6wZ2g881sGQ92N1w9H52PrMsbCwRQyiCTHN6Ise+6D9sbnlcalU
	bla1G7z23nq376V8I5+y2Q8LEPAN7SI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf04.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757860701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o9wU/W+z4HWlBo+SMsLu49fjjkbDPftXMJWXc0qCbjY=;
	b=rj+3MLemcnbP3ej/Uy+aUv6ZsVI+NFxqv1ZQGjfCnY6bZamNnllXjIOwMbclL0V0kOdXw2
	VRDmcsl+SH4b1lWabvI6lD5qXtr98V4mMytWqnqW0mOmr81N9/hZUh/o4xJNbXFw2A5Q+L
	iADlCn+uY2bI8RzUHsVYRDgHLb0qiP8=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-244580523a0so33876565ad.1
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757860700; x=1758465500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9wU/W+z4HWlBo+SMsLu49fjjkbDPftXMJWXc0qCbjY=;
        b=X5llwhfeMX5OPSJDnHpLv4eP6ppTg08KCYbPHQTbmkzmWEdfWqIiXNZBJ8S2pvwRxu
         yMWcWNolUHuxQaccm6f7lQ4Zcgi63MtzwjgT0rHDsNr708y1MEzhTCXxBKnT0gUCRx8J
         Sj0nDciXKbX5cH1BOKU7uqyvM3aQXSXn4x8O3pqXqkrOQp++z7/9GxSLZqTcRTtLVFkT
         ePiEzqDsDw0zykTa74lRGuWWT57fDo1wehu2gYWkz+0Hj8CCtaFGVeZAeIMUu4x7/7wQ
         gT6svdV2/sEshyBKBfotaSHhRXa4OLkW/fJVnaF/J5tZdgS8U68R+602Y2SwoaXf6Zfm
         6SmA==
X-Forwarded-Encrypted: i=1; AJvYcCXpyxbQseQtnngJDUNXuQvZMZBerk4oIkI7kl7GC1HrwpoZ9xDSMEpbA1OY5XYt9a5rJGaOYtnoOw==@kvack.org
X-Gm-Message-State: AOJu0YxZk3Jzd2eqlBfo+c7GRabqXlTTPqkO7p143A99UOnkJdpdYdX+
	yrTea4AcMfquTajSzfk744iHaLwFpT7ikfmpSoJv3fg6oRKSetBODJHy
X-Gm-Gg: ASbGncuBNz48B1SoXTzjbf+JowjxeZatvsjeICiX/ilBZzgRIOu6vGKIjZ42GwPjNU4
	OTFKA7EeqSbReYE6sbkIEOxFigRyb3JMIeB/QAr/OCPOypr54Jm4E+S2dzHL9eZ04lsS8A9PEP7
	Sz3FfMOO/3lzNIrEXYSqTkMiahuD00Su87bMCNg7fqk68bQJq3YccIYJ0GC6u9oW4vBzf+/IgYO
	arrBYIEgIdXSmfQk4E34g9BT0YnG2j9np0a5ydLoO93ANE5xA0ZVo4tv4hc7c2NVSeApzyr//qT
	F5G8JmfMZD4pbPpjerPyrWizDNa7LEJ+6kjvl4RtN2sfS8bEQNXd1Ix/1lyBcOx7mvFQLa58JhT
	OFotfg9MKtunGWQBR8giR8Q==
X-Google-Smtp-Source: AGHT+IFE+Wpu/pBUtNagskZ5QY9uGCvmN51O/TiqoKWmlQZLPEx1SxIwpA5S3oFgwluS1EavPOZLkg==
X-Received: by 2002:a17:902:ebc2:b0:24b:25f:5f7f with SMTP id d9443c01a7336-25d2801094emr94123065ad.60.1757860699829;
        Sun, 14 Sep 2025 07:38:19 -0700 (PDT)
Received: from localhost.localdomain ([2a11:3:200::10b2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b0219f9sm102571545ad.123.2025.09.14.07.38.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Sep 2025 07:38:19 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new 2/3] mm: clean up and expose is_guard_pte_marker()
Date: Sun, 14 Sep 2025 22:35:46 +0800
Message-ID: <20250914143547.27687-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250914143547.27687-1-lance.yang@linux.dev>
References: <20250914143547.27687-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBAD54000C
X-Stat-Signature: 7qp763njp6hmfarpsthzbi6ysr6tjjm9
X-Rspam-User: 
X-HE-Tag: 1757860700-801233
X-HE-Meta: U2FsdGVkX18JWIDQ9duN4/ZaD8/wIzTCrhAZALmMB94MMKmcfAERJNjXZbV76zEDkl9/tagc/AoQoVnvMfircYYWyqTr4yaUqI6oxzGsSz8L9xYhysZMLv1peAJ5RolXkH8UwJRX3ElwMzq9BAH4Ypf6/GLckLtRnZEhtlOfXL13yuS64lugwDnZuXHXnhU3qI3GkgMgiwxlVDNrnJBRkCgvruT+ihhDspHTpCWsuu2oJ4Kq4uxxy+kTJA66xugRIYrGvI9G0sXcRjIYqnHj/A/P/7Qqz53mG9dHPWUmmsO+6DYAjmUfxDrub+vnhK9jluZBcwQj345n2jYJQQe73G7wadm9IE9DMgYLTh2LjzK8LRC2LVo8xXUsZHTH55X3Zr1l4CHhLtwgHJcUN1UhOxsCGhUCeEUKnhfcZ336mfyZobtbH4VJHdw0nRWudLEGOtFFn3cEyUJdU7MaZNKbLGfcx04nbtnD4wS8IKdW8QPIU7wW8juLoWYf5vj6wrIHXHrD2LvMpwZNvO0VxZ55MFUDtYE/Vg/qBi0+SjUL7uyZorrLZ3oUd2MaU6sonfqeYPVCOKRogHr/AuOBgKwZ9zCj+1O4M2t+EWHq0L4RqT0FuEAIdHaucpCecLyQ2KkjJ9ZzInfpQjjl7vj12BbeaJPwjVTfnF7rn0B0HYuMxz2opdvnvPXSR27aFkWG+xxYgTgTN0G+uFKFnpkrKHnfcEOfcNTEKvbycYYsGeyKfjMAcLfO3ZpeS9FiYewaH2LraIY/2WJwwmCaj3zkWZNAkxEPiIr2H9/ncMPsutO863BVDzrqsfnB/lJjMeRiaO/FOHm3TbrurU9HH4MOTtDzV7U1shL2KLNuG/DIoSDBSRzPuZlctZ5/rW4ZD4jkVyW9mIePxtZBJsrpTpijxm3nCHy/CUxArEQbkoPCPN+P76gmNVHUZrkmLhNmIm+AdObHHniKutr6ySg9SVW02EY
 PPDDyQzc
 UKfMZ1RW607yVbnXcQ0fazAtE8DdySQYXH0BQcKzcoO9rpSbw7PehzAXmhRyBQKrXTs10DCbdKdp62/FHBpMzLa64USRBot2XI2Gkz5nM1E2oM+ezA2lmlytz62zoZXQjNzZL9DQNauREiyq410dSa9MC4LyDDquFUd9444Ov9Xsrxc4C0W2MxvU3OfrmeLZdO9KL1KFtOFxC9/H9Kt8P9CT3KN1lRwyJpxmfxzXX0uxzb+HHrxPVrG8BnxTB72fv6jP+4bmW4onUE2gi2oFaDimJNjacjeDb3gnehVjBcgQdD8bq/kAfv+zGVf/1wRh/L0thc2MMd9lK3K/Dm4dVqs3XMpFS/q3mLkuAV+nzV0WrJNtUBL9gydKXiYlkhfcnjnJfJYnwOB0fMdhfTVlUFnYme0UlQgeF2+bxgprR/Y+evbXgz7/8t2BfvCvR2hJ69bMGQyWP8QaJLrdDU2OrOnF2HY9dGlzg2HdLV4r8mxJkua6UhLbIAu50Cdy0kUPJuCmUwvYz14vz3SiaLJuhLhxFkPg/Uy1ilXNm5reqw1HFerCG55QbOwDvBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

is_guard_pte_marker() performs a redundant check because it calls both
is_pte_marker() and is_guard_swp_entry(), both of which internally check
for a PTE marker.

is_guard_pte_marker()
 |- is_pte_marker()
 |   `- is_pte_marker_entry()  // First check
 `- is_guard_swp_entry()
     `- is_pte_marker_entry()  // Second, redundant check

While a modern compiler could likely optimize this away, let's have clean
code and not rely on it ;)

Also, make it available for hugepage collapsing code.

Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/swapops.h | 6 ++++++
 mm/madvise.c            | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 59c5889a4d54..7f5684fa043b 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -469,6 +469,12 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
 		(pte_marker_get(entry) & PTE_MARKER_GUARD);
 }
 
+static inline bool is_guard_pte_marker(pte_t ptent)
+{
+	return is_swap_pte(ptent) &&
+	       is_guard_swp_entry(pte_to_swp_entry(ptent));
+}
+
 /*
  * This is a special version to check pte_none() just to cover the case when
  * the pte is a pte marker.  It existed because in many cases the pte marker
diff --git a/mm/madvise.c b/mm/madvise.c
index 35ed4ab0d7c5..bd46e6788fac 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1069,12 +1069,6 @@ static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
 	return !(vma->vm_flags & disallowed);
 }
 
-static bool is_guard_pte_marker(pte_t ptent)
-{
-	return is_pte_marker(ptent) &&
-		is_guard_swp_entry(pte_to_swp_entry(ptent));
-}
-
 static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
 				   unsigned long next, struct mm_walk *walk)
 {
-- 
2.49.0


