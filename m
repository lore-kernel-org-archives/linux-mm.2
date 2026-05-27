Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BBFCCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E7E6B0093; Wed, 27 May 2026 16:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9166B0096; Wed, 27 May 2026 16:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799826B0098; Wed, 27 May 2026 16:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFF06B0093
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36FFF1C05A8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:14 +0000 (UTC)
X-FDA: 84814387308.01.C53B1C9
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68EB720010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=m25gEA2y;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDvTkX11jVGNHNrahXzBPb3ZfYee1UhmGAXLDAQTujI=;
	b=2jAEPC1E1IqLt2NW+JQCMKn6gLkCDff0txhKq1ue+OgV2m/u5mklqADEwbfV9WAdz1pHus
	Fux2qHx1t3ZmjNS8Qz+65fYIIwlxfywVkb5Kyn6NWHOItCPQnQc0fWs7j9q1v2SN1PM6rF
	0F9DR5h57qa11PtxAS6ROhP27GNLRIA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=m25gEA2y;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914892; a=rsa-sha256;
	cv=none;
	b=KLFacEBsakr9/vWe9XXJOsmKtaULVFh+L+yLjrlYYDo4HQiG5SxYpMAIOfcGg16pEjfn3N
	AoBQbA717q6U7lC2nMIFVEzwYoXOpgoAFeHHFRhV61rq+PBAkyIvBqlWfd4xY0s5vUEfTO
	fsgSeYKWVUPC+bnJdOHrKxOtSddgzDo=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-516d15ed2bcso57535581cf.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914891; x=1780519691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDvTkX11jVGNHNrahXzBPb3ZfYee1UhmGAXLDAQTujI=;
        b=m25gEA2ykX2osiKfWtmAGYURJ46l9E/yf96Q/30IW+nI/beJ4S5DL3t8FkQzuKAMOH
         ThIM21FaPoa2o0DuzG9SCBeXs0f5E6oolGejEckYd/v3YPdguGh1eV7CRdLRqIdKXrit
         G7Yw5Nr5Xsfb9szNGw5azG7JLsJ7/i2R6eBOOl+l28a5C0MErnowQJbpguXTHcVntESH
         VSl3TC56IPtTnQrZNn2CfGCod2+T0HC7vIh7J4AWTxmRyQF/LhzY7R/0tM15p7+pe6ou
         dxCBAf0+aNyOSpJnMmmxKsuw7sKJO7AqOboizy+vd9eeD0vq7K+p/aDWcKwC7wUza6jE
         Zh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914891; x=1780519691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sDvTkX11jVGNHNrahXzBPb3ZfYee1UhmGAXLDAQTujI=;
        b=HtRZodAEKj5E0qB5lnFMPRGw3pKlB/kFOXWLgWkpaW+9J8Lav9yqbVOAEdRLrROPjG
         42WFV7W45RHxzjs1SBUU+m3GZuNKbpBVcZ9RySGdi7eQvIJ8XGAvuAlS//k2LPUlfaOe
         MqXRCayD2S1jWY1R/QKLzjyKUFvjCTWHboqSqIkVWNvp8tRg0fVZ905MhmdS3ywnhp//
         qyd29EoAN6/giBDrp/bjjUfQwrBFYB4iu4C5ZIQbWq0mMYET+n+mvOTU/yG6uu9DIOZm
         WNt4R8ewOl//C0pXsmvoqqLXCJ1pKDy3RjvOAg8+Pv8togNuzhBK4RKSSEIObT3UfIvs
         3paQ==
X-Forwarded-Encrypted: i=1; AFNElJ9x4HUM92kr/TxJtEm1PR6FPbfNa+0YSXGdeMuJbIjUYSVh435ZtGOwXqX6fAA1zDvHpgjfW6t3jw==@kvack.org
X-Gm-Message-State: AOJu0YwQr2HAfPoem+1bZ4l4R8FJTv7QxGAcMoqULVCnqAbJoO2bKsFp
	x1NDqgS94jLXanQi58/hirlESL/Cu8MkMnnFh/E1fRSpawb8QbgMuZbE+HS5eFY+hLM=
X-Gm-Gg: Acq92OHLqGXiOKBs9OiV4Ia/sbqTK0j+CIHqy5YT8B7CcQ3mm8bBgif/cAo1AbNCetq
	vZBVfnCGkAudPXHkFoj4mEdI12kRuOJEfajwZNb67S2Spnsn4YOgkQRTwo/rn4KPUwULR41bPOy
	NcBJ6MRhYonj14q+2CKRIhivOs8twAJVJgsfmL5uqsTYUVA8D8iQgx+jQlR/L+impDVIl2QgsY8
	/pSAd+yPFgrYpPykQ7D35SAE9A+CpcYGWDOo2M8dvpfGKPrnX55bdI6Nuqw6X+2IYkPHX5QUjqU
	AHm3BucCvvFwK4HsdrolTUWTjWjvVGI3TwNNan0eVCTVSVLNNp8XVPwDwafbaS7ANDvP1P7ZMzu
	rxnjXU87uz45JoZrrecCXdMV76ULG6gK4/qbR8PvXtAiFsqPAPcLrcFGsq6PKJM+sqDwAT9tPjG
	H2tU7Ad6CeUKt4gM0DCgQmILarNDC3kDbp
X-Received: by 2002:ac8:7f8f:0:b0:50f:a53b:9d3 with SMTP id d75a77b69052e-516d58a803emr268033681cf.27.1779914891532;
        Wed, 27 May 2026 13:48:11 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706b0bad4sm53558101cf.31.2026.05.27.13.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:10 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/9] mm: list_lru: deduplicate unlock_list_lru()
Date: Wed, 27 May 2026 16:45:10 -0400
Message-ID: <20260527204757.2544958-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 619a5i9y6rhiq1iarxbmdcn91s5c4ac6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68EB720010
X-Rspam-User: 
X-HE-Tag: 1779914892-149581
X-HE-Meta: U2FsdGVkX1+PuxHRxs5sP6Vqb8Tzii96jhQoC6j2K0+tHF5afHTWeCoRzBQjbXRhoPUruZt6pZ2ZhmXHwUJ6xk/NfKNWwweumzy6djH0lODePjMSSzRbwNSIeee442bJlvnPqOKHo9oQag8AwKj/WT2jUPbqtnlG04pmaaV+LiK9l4LBTfhL7l5EBkIRgE/PgCvzS7gBUcd0rjBDfioT1llx0oOiW823BmnSJbz0vRyr4V0nJKx3gyJX2iBMmF704j7BSlpYa8hffiQ7w1DvFc3CSEo49JCioXvRD43YBS6utuf35bxzd4lTV1jYCZG0LRLxhh6qkokoHr9DN0vDHLJR11mCCbVhlaTaEZdLWMQQk8rivKESkNZ+ZGSBHEAz32XGfGHzrBR1ilP9Oc/FofJABuSR9l/NAMbp4j/UTaCLEhsMXWOqrLEymscZGMMzWfqqdG6Rtu0sGbFFJFyCZdMVAi6fpNGfSfgjCLynvJlpvKaYYm+MPgZRSKnSVKCRUiaoymzvELSWOhrDTGqPuqfYIvRpaSBJJfNxD7FjKsgyFD3BpTKq3JBKmrCe2yCHUbEdTQq5/Rn/loidcyjQl25/HXcZCScbW+BMIZrUV7LIOi/Ocjp9AzISxz9QAuGlYKlWbopzbGSg/nsM9U8metkKn3lJtOOBqNJN7oIeVxWTfHN87yAZRU8c6tcafAhB6Pn9y/4nneQXwon5lrupcKRK5K0ECIddtpbnzeYDjV/hl5EHn9yIIb0eXZk4aM11arIoOuOmL0Kp6bLbu77pfslLbHyylC0XtP2mL4BxxAWekulhhe3+2C+px1Kqef+rLa/LvDPv+YMh8imuQC1Hyp9c7VFYBKV8VVdjDaOxSkmM924MuZNTVW0Z8uoEmxmhbMTPAJ+WnepNXQIHpU60jRqLztnWNAYn3UKO9AkV8UAHwQYv7LAOk1gLDDlid1svZfrdrHzMx8XE44JuO57
 1EqYk1nR
 nfcT/mQGtoqLCSF51Lb7kblfCJ01MLiYFCReMUWAG22OU3gWwU35HW9BE9K5Rqy1+FZxUhJo8Fuce2tTGwFBHiK3wnMJKpWik/HyyBsr7/9oQHBwvM6z0plYwO+k25Pn03bAU04pVghsexzQP2/YOKTYUccc2mSdvBgB2Hi68xRjRPw0RF9+fFBAs7QafVB2zYkw76WVF4Y61ox9YId7PjL0CJ40asLcvMgU+Yxv5OV1YVZT5TnEMNiHl6g3mH67mMiEDaIMxLhC1Z+FJZM+o0VcJz4I22oyLqjeBbJq88c+hcBT+5cfl6wSl0GKrlUS0NO/nntz+Nux+lMaz1que+WEbQfGdl/f4IpwzjFF0ZlFnDp+4oJ2DrQdb+msL8Qbhc5UkPekB8cKqxp/rL2cmr02XYQeFZiEWb7+56YGtt4/S368FGlNTAxGklekww+yXGv3bKXNMlVNXWK+ONM4JtL7IRucVzldPPdxExBrZ+k8O0MBjIp85BGM3vHJF5huLL0yel3x+nWJY8Puxlrc4V3KWic/1WoNYturS3RvGaHBKGR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
same pattern when bailing. Consolidate into a common implementation.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 mm/list_lru.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 77999ed78fa5..5497034e80f3 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+{
+	if (irq_off)
+		spin_unlock_irq(&l->lock);
+	else
+		spin_unlock(&l->lock);
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
 	else
 		spin_lock(&l->lock);
 	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
+		unlock_list_lru(l, irq);
 		return false;
 	}
 	return true;
@@ -101,14 +106,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 	*memcg = parent_mem_cgroup(*memcg);
 	goto again;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 
 	return l;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #endif /* CONFIG_MEMCG */
 
 /* The caller must ensure the memcg lifetime. */
-- 
2.54.0


