Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA2BC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764C96B035A; Sat, 15 Aug 2026 04:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7151B6B035B; Sat, 15 Aug 2026 04:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6044B6B035C; Sat, 15 Aug 2026 04:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2E66B035A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:40:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF0EE1A032D
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:40:43 +0000 (UTC)
X-FDA: 85102857966.01.68E7180
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0937A1C0005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:40:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tym7qOYY;
	spf=pass (imf21.hostedemail.com: domain of eamon112009@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=eamon112009@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786783242;
	b=Rge+e95O+dETiSIEeWPnwWqApsv/YX3LItrNcriL7Qs9/pBZGxkodzKpP64Ygnn/0uDv5p
	+4vWAsvkumzJDUKhAShKrQwaUIruly6VfT1WEUo07CIH69bz2FBxIJiS/x34lSVXR5lc8Z
	OmPepGtqJrhoXpWKp5uIsUbSfQLv858=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tym7qOYY;
	spf=pass (imf21.hostedemail.com: domain of eamon112009@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=eamon112009@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786783242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xcv8l5CiFtE29rX5E363F5csjK5+NcrGXED2GBfGaKQ=;
	b=X6oaYtKUzQKlJUe3JZN0Ap5YLAvaRbaJ7U5JI13w4R74sIXQAgK/+HmQjT8ppLRc3d9D/6
	8GoQIrdx+YBaTlSzx9wWE/d65rpRQTXNzRdtoQFxNzhd12ANPaQ5itY66XWILeNwe44oqC
	OVV3K0G4VJq8TPfKmoPigJKDHfSrSaM=
Received: by mail-pj2-f4.google.com with SMTP id d9443c01a7336-2cabe9335f1so8368275ad.0
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786783241; x=1787388041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xcv8l5CiFtE29rX5E363F5csjK5+NcrGXED2GBfGaKQ=;
        b=Tym7qOYYqi2mLkfLINi+Yhnpi9LhYE+9++kpxRl8OyS1bktwRWeMSVYi57nALgKLLr
         0JPrquj4GhqbEFw7AoOALiEjNgOTLErSiu/9MSt0NJbBzEghYL6mPwqvBDdCUJFpqa4N
         7qjMr3+TxALoI2nF2w+mi4lv00uINT5PX8lYn1RtpkZ1ntmV7mNAXBqI8RkwWlRqzbr1
         j1nLFu/QzP76D8sYY3zmkXz6DpF7MN2/dMHqY7jfoYncEayOpSD0q06LoNleG0rDA7bY
         8ST2CABt7tqcKx3G4jfHgWyHBEDQXf4tAncn46K1bUtaAmSqb6X5uPfij5GAL46/kj+/
         s/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786783241; x=1787388041;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xcv8l5CiFtE29rX5E363F5csjK5+NcrGXED2GBfGaKQ=;
        b=ZRF9BMu/uEuCEiIjbrvBioh4qEiRm8RCpULxcZvQ+2AbdPoVaWitTwOnoJqyIySpes
         PaSSLjtx+lBpnk/uu8FsOncsUzcydC6IgpoerpPmMYKyQv671qH5TKPeYwHJv/HToJWQ
         mKEd4QbCrBMCK4seClvuXI43YqDYwcwpJdP7yxPKJcyLCVcl01y8tll7hRbKkoWv5ebg
         EMDGIbpeT2POZBrGOpMjM5rRL07BWdGy+BYdTZAfOXv7IOQmQluuWpvMgF3Dl/vrP73J
         cSLfd79jOyIAu9jiLjvZP7+gTzR03fBs2MPr4g972jMbXpG7C0RZIrl7ccB2er8amxRK
         L7Zg==
X-Gm-Message-State: AOJu0YxicoVFR8sTCo5730r+PVyO3wsUDEVa6CPvvJjc3kccFPQpnbUx
	DVTLxoHBI6aI8FshT4II6MaTCZf8FjTnsg98ZbSiRc/odM+lIlnWmLHX
X-Gm-Gg: AR+sD107hsB3cgIpZIzj01YDApU/6jbVSOBnXCoS0LyP5ANpVb3BHyhMRIrRbknzrfw
	Ffnkn+hB88xs44mxwtHw7eWHYOs3NBA/U9hs1Mzndf2ckH+Pne41u8nbC0nFSROMaBzI2x/KV27
	8upMQeqXIGQIEPmFK4C5i3XEF90SsjuQ/X+SCLJiZ2cvrCh+wbGtZWDQHTm1pmB9njHK6jjlF73
	+1GL+q167Ks/wMyLDI/o6VOmfHSrJg8fmmO9I87vqphda0tl6UEc3cMe9Dk0XBd7HAcxynF89qX
	GPvIOW6bH18jKVmwQRruodEi+Ko+6el4fvvQiHqvhPk9oNk77wW7E5E7vnmiGW0hl+1fXeGs26K
	hdg3ibvAUOKNFJihwx9Y9/OEKHRbTDi6BCA38KCmHR3bdUs5bEwyBe6UkqGY/edkk+G4noZH327
	QEYdX58+Re6VnkeKX6+j1hYW4hUTDsosqmilEt9IfzBYTDRJXGFJkxJ4hpzWzJgUl6ZBw3WQ7rg
	H8Ri2lWsU1U0Tc=
X-Received: by 2002:a05:6a21:3a47:b0:3c3:9993:d5c3 with SMTP id adf61e73a8af0-3cc71aae5admr15595751637.9.1786783240710;
        Sat, 15 Aug 2026 01:40:40 -0700 (PDT)
Received: from Ubuntu-172-24-64-1.localdomain ([157.37.185.197])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387c56aesm16591312c88.4.2026.08.15.01.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 01:40:40 -0700 (PDT)
From: Eamon Sippy <eamon112009@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Eamon Sippy <eamon112009@gmail.com>
Subject: [PATCH] mm: cma: make mm/cma.h self-contained and conditionalize includes
Date: Sat, 15 Aug 2026 08:40:26 +0000
Message-ID: <20260815084026.44078-1-eamon112009@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0937A1C0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b58wah63yekg8sszkcomosxhzri8qwrc
X-HE-Tag: 1786783241-929577
X-HE-Meta: U2FsdGVkX1/QbNb8KniXt6EyMvRMDJZDCHINIx1yEiWQ92MNfPMPEft5mFtT3dUNPmav0y0pSucYM+kuwveLl7Zsvyx4Z4htcnTFIjs4YZJDuwM3xZmCd82gjZ3f2DuGRmH1CtccQsCRMQumPQIrEVNJey8qfkCdCWC33iNt6iAe18wb640clb271YZum+eC6Gtw0Amnd+NBbLyu1s2SrVcbyZ/0VBxt4U62qMLmlw87CRcnjsHQmLv7hXXgdlUaPqi4uBBt6J69tBNw166N92vOLLwdKigeofTJzLaleZLVhwQ/CWSvuZjTCDUI9lU9ZHHCHleY7cCk2iFXA9bt8LA4mPPZPAW6Gjw/cEuX+94jdBMUUhqZFnn8UBxJLP7gSAM6M9NnEc1tYids8i9AEEi95sDwyy2C16jUyYPGPMxKiYW9jb59atzGZ7tTqgqIR1lllw2tHYlmNfvf4Q4lBF/Tfpjj95IiDbR4a8AutV9S0pqji3/pAPQvw53fYGODyxlgxoZJPBUf9OD7w+dytMFmVMcW0qaLPEHUG6S7YEMNXHpBZaErUd9fWRCLOt0uDLFr3CFYS/Mfd8UrQejR+f5Nzpt4dzBYjGjifnvoQMrotoLuxxbk5N8LWqpAJpJNBBZr+RvI+f8vr5ae3Rn9qx9ImscHybz8DkdbH3BJXHcPJtfb+SF2L10kf85ltgEQWO8bGjMWHzpxBfWxHnf6IiNylGRWH704A5noAGWFh0GiICa0ymsfp/0ME2XZvj5JHK9Ym83MPAI4SdMa1ZrFnnoTNenKOPTEbexCpD+0vDHesPM1mKWfHinrXPXTZpFrZN526pacyrwCFK1fbRpBR60ME+OOKndaGZDeGxdjP26yJ5gLhP3Kj5h96j7vYPzP2mI9U0jQjkUFPIuzCJlMZ+FKBLZlQKa/JX1NqEJeFoSmgPNq4JnHWcYvhuZ9McFc4M+45S1naGMEHRjlUGb
 BhGOgMeY
 ZLR04rtGp7pTkPyzvMEWPwNi7DxObFu+SMRMgHH9k6ir+sHt9K6GQfQSRvwPqfvM2dGRbq6HDGadZrlGDnjpbD6FiHKEsxl/cwy9GPtVuRJjZkt4irrDVGhe2s129YgU0DmXJuoaTZUh6KunmSypyvwlt908VimgmttyYDT5bNNbCzthobk7VA1vGZoa2j+QjdS8MqZ+jwLlpCRMvBrumHjTNNUBczvyxlmShyWa6OOXMn2y8rSDg7BBnDySCC66/M+7MzQKbiYSufD9C+M6mz0Yd3ViH9+9wEqhOfpnbiqhcKgMXqPU1+f4DShyFNU9hyWeiUlXx/YdO3gdmzUwLradKpQ5YtGsNczyZpr9cKdGBri95TWUXh7xcRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/cma.h uses types from <linux/spinlock.h>, <linux/mutex.h>,
<linux/atomic.h> and <linux/list.h> without explicitly including them,
violating the kernel header self-containment guidelines.

<linux/debugfs.h> and <linux/kobject.h> are also included unconditionally
even though they are only needed under CONFIG_CMA_DEBUGFS and
CONFIG_CMA_SYSFS respectively. Move the struct cma_kobject definition and
<linux/kobject.h> inside the CONFIG_CMA_SYSFS block, and move
<linux/debugfs.h> inside CONFIG_CMA_DEBUGFS.

Remove spurious trailing semicolons after the empty inline function bodies
in the CONFIG_CMA_SYSFS #else branch.

Add <linux/cma.h> so that MAX_CMA_AREAS and CMA_MAX_NAME are always
available when this header is included.

Signed-off-by: Eamon Sippy <eamon112009@gmail.com>
---
 mm/cma.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..0a1cb0141756 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -2,13 +2,24 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#include <linux/atomic.h>
+#include <linux/cma.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_CMA_DEBUGFS
 #include <linux/debugfs.h>
+#endif
+
+#ifdef CONFIG_CMA_SYSFS
 #include <linux/kobject.h>
 
 struct cma_kobject {
 	struct kobject kobj;
 	struct cma *cma;
 };
+#endif
 
 /*
  * Multi-range support. This can be useful if the size of the allocation
@@ -37,10 +48,10 @@ struct cma_memrange {
 #define CMA_MAX_RANGES 8
 
 struct cma {
-	unsigned long   count;
-	unsigned long	available_count;
+	unsigned long count;
+	unsigned long available_count;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	spinlock_t	lock;
+	spinlock_t lock;	/* protects allocation bitmap */
 	struct mutex alloc_mutex;
 #ifdef CONFIG_CMA_DEBUGFS
 	struct hlist_head mem_head;
@@ -86,10 +97,11 @@ void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
 void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
 #else
 static inline void cma_sysfs_account_success_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
+						   unsigned long nr_pages) {}
 static inline void cma_sysfs_account_fail_pages(struct cma *cma,
-						unsigned long nr_pages) {};
+						unsigned long nr_pages) {}
 static inline void cma_sysfs_account_release_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
+						   unsigned long nr_pages) {}
 #endif
+
 #endif
-- 
2.43.0


