Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D2ECD6E43
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CE46B0096; Wed, 27 May 2026 16:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCE26B0098; Wed, 27 May 2026 16:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947636B0099; Wed, 27 May 2026 16:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87B4F6B0096
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 344DCA070D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:16 +0000 (UTC)
X-FDA: 84814387392.30.BC1621B
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 53C5040002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uCUkydWu;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5D0XhUH8wxuCdonGZS3m1jXTkJvh4TQTyemwB8RtUGE=;
	b=EpZr6/6/TBuQftRWnW/RydBm7guPC2Lu5qrRx/Ro8WhJH5107TDTzdo7JSnqBORvZi0lCr
	XgoDBW6v8Und17Gj5zHC4xA5pJMPOT28sAAHMmyZDJF1tW59bSNCjQ8BNNreCecEv9NV1E
	gD8auCjk/TGlbnpJP3GF9p3tlvMkD9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914894; a=rsa-sha256;
	cv=none;
	b=lpT8FqIM2WHlSNAS7hc4hfcuIxiKejwdsdn8LjRQUoR5GrsG8koNOBPxdhkW6wMjaiJUP5
	6McqPT1jvwDSPSUds+jW9X4PH9DwMcpHgjBvJg8PfAFaO+WbhkSWa/KiWQFC079mqPVHPa
	Ma4BNgMFSp0QuV7r0B8/1FZi2Xf/6qY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uCUkydWu;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-914bfa75911so613260385a.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914893; x=1780519693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5D0XhUH8wxuCdonGZS3m1jXTkJvh4TQTyemwB8RtUGE=;
        b=uCUkydWu2h+E3NJufFDT2ujLyCRQdivJTpDgesHv9RVPlDrPmUHbLiIPW551WLVu08
         /qKrdYIzDiKgaStXx7lSYK58Im9OiziAvi/MpdgaCNCEewkn71PTQezjNbFrPcjWE4Ae
         tkY6Fg5UabpYOveMOYTX/hyic/i+saip8n6qkxy7dHC2gf00NF31SQoG4Fv7OCSyW0TS
         5mE3MXmDquPhLWaHSwROxqVGEpP/sZPNhHkd8UonHoh03+pEYKbFwqvs3kYvagUIkr3/
         RaXzK9Dm23KMBqa4G0Et/dulOxm2jvvFDidShuYSRo7kl90eFumyhj44eYmH60CsHVpk
         9gww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914893; x=1780519693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5D0XhUH8wxuCdonGZS3m1jXTkJvh4TQTyemwB8RtUGE=;
        b=k5uxv6bVHCbEPqBQoTVSCR2LETmTt+FmyEo4tZyrAztoQgj8mPkJwEjCmF0DD3ZXAo
         muAZbEUKAqa6AzVA/F/ERwqOw5GOZ3SyOWoBb3jDOqK/TW1RL5X+gp2kB/FrXQbEFwnZ
         hyHbbLH0MBZbBl6UTsAH58evozmpRq+xRgX4r3/RoR5tV7rBavrGJKlinADs6QtXdeTt
         xGb/Nqpxg6agBAoWnhhg1TPzsX2KC4SUa2bLXTvPh0FIcPXYzkE4XJukM41fI4iYcFhP
         Q+6ecQgxnnX8NAuI9Bv77MV+uSpBTIs9nzWUTh5PGWIzgVjjzZJ/mmGPfbBPIKUPzk6y
         cMdA==
X-Forwarded-Encrypted: i=1; AFNElJ+2UwU5VoTTSb8QeyAReWBv1o9R35/SoFzVx+I40WFK9ZYg1oQw1DdX3DQlTBBSUrKxYkGDggln7Q==@kvack.org
X-Gm-Message-State: AOJu0YxAC1phrOGIkBwTAREs9bWNW4pgZsRca3GalW9IJRLhtfzGSfMd
	rWAMj7xhgdeyz89S8ruOdo/MTj57Jgl3DoeliJCgRKz5qnPsmMn6EaTkYeK6HF434Qw=
X-Gm-Gg: Acq92OGkQMUw/RraaRCHzFCkynQzJ9qJAReLSnwdBakpXwpkmJtW57rOoACOJAeUh8w
	V9p2Pd+f9XDHK1if6wDnDNVwGaM/zrEzQ1Teqr1+e4jeRln6r4pwwyEkMGGmXqQpWJLRlTZ1VTG
	H9FpjesmIIpk9uPdgDd4kZ2UXc/0mhkxw5q2c2AzeuVgnunOj6qFdIqnGLmgTE3m1/tZEbfpv7p
	Co0YBOEY1v2KFCugyVzbf1EVGu1yJhTPRm4t/qEadQC1ACATSmc5zdekg5ZocV+N4lAr2l+Zb/c
	lRWt+wP5KpYrsMFQE8fKUePWOlRL9bZVb7ZWH/9bNagqN+j+Pt/Gr9tMjvoygh3oglIj1f8NtZe
	l1djW81mgBPPOxMsoppCVYnpoyKMjgQLuPj6ExOwkw3FmG+p6DGDnPnWlBUp14DJeRKUX11aIgG
	m7iKq8S0p4pHwxtIQ3e0jNk6c0Zci0aJ6U
X-Received: by 2002:a05:620a:40c5:b0:90f:786c:4a82 with SMTP id af79cd13be357-914a240d00cmr3496069885a.39.1779914893344;
        Wed, 27 May 2026 13:48:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f881f214sm578376685a.45.2026.05.27.13.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:12 -0700 (PDT)
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
Subject: [PATCH v5 4/9] mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Wed, 27 May 2026 16:45:11 -0400
Message-ID: <20260527204757.2544958-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 53C5040002
X-Stat-Signature: khr1pas85gzk5jzrffwacph8tao8t8ui
X-Rspamd-Server: rspam06
X-HE-Tag: 1779914894-842035
X-HE-Meta: U2FsdGVkX1+JnhqEKxwDNfgO0Pp3H/jgsRv+OcYjbCIWZRPtbPPjrCdI/Q6MeSaTTz0ecfj2na5Sa7P4nGrOjjxrF0h+8LVIYJC148ihGk71RWWaAmZkcTr+oGFS5kLG/cWBt1dWSUCS24+FQSIEGTI3GTSanjOYBLceQR00qqeN0T5NrszBsfWlzWrbtLGu1BM43jrDPfze33ZRguX6GaKSA1ZP0Q2ZEmzp1UjeZ6MxN7vFaeb9uSsW8pc7ZytmaCGed9fh9S5cUCqIgJX5ssPWlaxSob2dNnxOV1NSWo3MLpgeevaW6GKASX42/9jK2KYlkpPlhNBpsYiN5ABTEiccGKI5R4yeng1onyiUfoSY8aYHWwDINarClxToIimrQjzn45T6kr4vg5tDrM+wowR26qZLDk3HGM4kSBFxrRtJAU2pUuxj0TpCfWJM42/t/lEYfTu3+L3r1rCSf93NvLKK2i/tNN+6GYRS8Js4/RjZ7zEB5hYiaHqQw2WV9hhS0x5N+Ie26ixe+c4LsjRVLbIM6GjaRoKu4JtTZsU4b84w32JkaS1Gbf4bWXBd7NfS5usy6Yk/MiSFJ8Y+vBOLObQuqLKUG6G7e+8KEyd+/oRcoqFXP/6y1WPQ7fQevs4CjUlJU0IJ5NI7nrMlyErE+RKBOKCNbhWwiTEknUxctailzQBjY8qB2hzK0wQDi6Tl8c7SZgA4pKgYCFp28R1fm96KYEaSCG6hFlMAKaN15v8FLkj8BqxIu6esho0zqrBOO4VfuuifM2gMlP9DqD/V49NBNvEDlaY7X+CqusNw3to8rY6f7B6QkfVjiqB3SlqbC3IbLaE8BK6K+FvTnOmf0Zx1t3dA9hk1Yt3JBGJk1uUiM8qbPY5zWPTJMhQfB/yWIOICuZCG+6ogqo1Iyi1cML+OyGVDbIGgwzyTFxKdU9dZrB9VS5ep37obgXgx7VY8gZks/2UYQsX+NdWUC1U
 aH+warou
 O/6ikAdXKCkIbd8I9mUZDg0ZoQAsLmZiBBju0fa7qn5Dx2PNMGeiyJeCadXrIlyg0ECOiUVtvfc481TgyfUkzZxm+YMPPLx8pKLLn3SM/dWkv2tpsXWZ+IvUfFANJhMNx3bijrJ8ALOFABLKoc37NyWNLadI0jxL0vFCjeJQDCCxhzN8lenQwMSZJt9THEIw//eXdfbSo0c5ImWhkktaxr1ajvu8vKVtpokvigI6K4YgBoBy6bCp5e+VFB8HDxPq5KgtAAcgaEhZEPhwHl85vLm8/nFYkuBKOivmCDBQMJLWe2JocNKjmwREiNilcnjThcGUC/lBioNO/nz4DfLu9OtasVWt7TiaJp2OewuHR7Esf/xR8iOs+Mu8oel95PT0IAGKDj8dLM56zZTS3bKik99wVrxGOuS4EerCA7BsX8xbwnTWC/tHn8AwHZKEfsgeF9ulqYUwqPovw8cCQZ8wUGbJC8LQKKGlRUyo/tS8hIWvU0uE3opcDC8+K8fZtf2fZuOiPUUif4mKyYj7M4ilUCFHX3u/FmTsfmGs4rdQrIUTffGbhNEz1DgjJJYOKpI0uGysP2/8DH9JlY3RoL8GdGsrKBIGr7LC8bem0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting. Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 mm/list_lru.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 5497034e80f3..7d0523e44010 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
 {
 	if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
-	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		unlock_list_lru(l, irq);
-		return false;
-	}
-	return true;
 }
 
 static inline struct list_lru_one *
@@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
-		return l;
+	if (likely(l)) {
+		lock_list_lru(l, irq);
+		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
+			rcu_read_unlock();
+			return l;
+		}
+		unlock_list_lru(l, irq);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
-- 
2.54.0


