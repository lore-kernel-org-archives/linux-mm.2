Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B92CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D178E00F6; Thu, 18 Sep 2025 23:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD7C8E0008; Thu, 18 Sep 2025 23:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC688E00F6; Thu, 18 Sep 2025 23:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C743F8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:49:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91124140549
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:49:46 +0000 (UTC)
X-FDA: 83904620772.27.047C6CF
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id B06F01C000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:49:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZcLEFZ2Y;
	spf=pass (imf18.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758253784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qta8j4KZvgpuCZEInGOfHTtc26DcWYqWpsrutb5sExg=;
	b=7Ym2Z9fQ9Bptfoa+68DcKDdx6G3n+qX0r2BYMFcQR8OTxyKRu/XzN9lY9DcuTnCS4n2k7e
	sgGuP14m6uTOYYmCBMfPc16JFhk5IKAV4hMbG4f9LteSe5G6yuYHbBtv1gAAfSRetZVVgc
	36/Qin58KE5nPxCfJFDx8wc6SRXEiX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758253784; a=rsa-sha256;
	cv=none;
	b=3LnbZQHZ+RbUx3DRLXdAztViVtEFIDIX0R25g0X1QJ7YfMSib7a+ki45UgexqL0LRXVImZ
	dG4sCpsHpx6WAOIPT1CuJZgVelVElpAbSmcWUmzOSRK0JytdEtvynRNoN/7jxHfh6FLvQx
	FCsVob2ryh+Fo6XkWE/EPaO/x8rtkw8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZcLEFZ2Y;
	spf=pass (imf18.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso1105355a12.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758253783; x=1758858583; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qta8j4KZvgpuCZEInGOfHTtc26DcWYqWpsrutb5sExg=;
        b=ZcLEFZ2YvCLsNZb1VdbYwvFVFctO+FrX1bYgjFZxa/SYRxu5Px9yNBDsUTLXyMsrIf
         rVfUi4A7HxgTjLmLk9LcmZHiJg4O2aCiprUYw6KOfmKz5eVMKdSyf2y4kTAExJgzCHiT
         RMyvG94F/A0uH0l1QHADNrouMKi7Dx4UadIwBeTkUOgH/UN89zJAXWF1RYoq/kr39qmp
         1R6IGsIqm05lB6vf2mRc211pfI7oJw90Jb/SipljWnZtAcBhAdmj04eJA269IyjL/cSs
         bsSjZ7OM2sP24ILqK7rm63VriUilABpoNrXq6UZVeNEWcYmkhPkwIszXQPOkyl3OkZCJ
         uGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758253783; x=1758858583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qta8j4KZvgpuCZEInGOfHTtc26DcWYqWpsrutb5sExg=;
        b=hMQPIbjx10pVTUmANIpbmP8G8ehubS0lkaperDDx9HTiQN86SVHtuADqfkZlBRZPtN
         qxFPrESnuwBL32hZASDLDzH+hxb0kzzxqlUdupgWaUuRVPQikn0kIpFcL5HoEND2vzkJ
         qesWMqti2GlPEfPipYKsuSMf0zJxyburcSjJzdbzqBdMgGYGApLu9jys17VGvctgz1YA
         pVhTzooICZW0tONL89ELCsy0mwlOIMCMwnyFXLZI8+FYJFxmG3wf6zEeYLC2WJnvFXBj
         6ShWMAWrWHHXZbs8wGQrVq1Oi7e/o2MNzJlzCmLlyWXffaypvp/22sTHXZmUO5ZVQu5y
         HN0g==
X-Gm-Message-State: AOJu0YxdKiiaZwkpnI2Dpwet0C9HYeq/aA1r/Scq5cGalXsjTgjQZDqN
	YGh9jFe4/h++IKwaYrC1wYVTBL3NU0TtFfnYYh95kI1OREdg8FlrfBsIOb4hb7Leug8=
X-Gm-Gg: ASbGncvegxXPM8tw7vC6LHpJud+wUmHBamIGW/6c7oG3EOCPi3GR8D0aAebF1zNzUFI
	N9Lp3+3UZO/UNTznoE1uTDOsBU0vdDMBQ7QIOSJbsK60RM8WO0Baq09ZlTPtnI3lsujLQzEs3lu
	7u234xvpZEVTT/4pyElvLJTfGfK8Mus1uYyM7p7LRljkkO+09tHabokganJnqCPe8ujd1JVuJbl
	LzSpvpQXV6fUHEQOu6O3sBKtogQoj7C7y96xNLfw+cC/oEhM3jsxhZiRU5BgQqWHIn/gQ60u2jk
	ur2KMc824we0ABcAdGfIcvptc/qiB1K2f9nmchXXlxF1sfDrgIVUO6X56d6pFLqiTXhfZIJAm5m
	K1lqjzS2yJTI6+Pb8D+QU6uXPWr4jKr+WHKFL+Q9+OR6harNBvuWvxImV4Jo12KT05YXxtDg=
X-Google-Smtp-Source: AGHT+IEKIcUFF6fbBY5OZR14G5gZ1jT642lbrLvDNjajNIskg3XnlnI32L5cYmFTm9cWzyX4rO37Qg==
X-Received: by 2002:a17:903:298c:b0:267:ba92:4d19 with SMTP id d9443c01a7336-269ba253554mr27527575ad.0.1758253783635;
        Thu, 18 Sep 2025 20:49:43 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802de5e9sm39629235ad.72.2025.09.18.20.49.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Sep 2025 20:49:43 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 1/4] mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Fri, 19 Sep 2025 11:46:32 +0800
Message-ID: <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758253018.git.zhengqi.arch@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B06F01C000A
X-Stat-Signature: iuif4hadga367ycjcr7s46wwhoij3nr6
X-Rspam-User: 
X-HE-Tag: 1758253784-510084
X-HE-Meta: U2FsdGVkX1+Hl7/YnH3cp0EtCafytOht6YU6PJ4h2vaRhzdp6s6e+/2Cn8nCXH/KzaCbr9VwZjU3GvI1QKDz07pLAy6rm1WQZ/a8v/5R1x8tpjQ3vTRJyYNuWsjBZrDV6EVo4EOwQQZW4nkt33yNh32cJQFonUH8aGhbkiYrpNXZEGWiV1h6cNz9Rb2TZFR6uAp0wRUpLyuCz50vpwireA6pwLC2xxkiRZ4ev/E+9uGm3HN5o1sxLwnoa/Zd8bZ/XUe38cC1ZBvWdA01r/lhewE3mKAGSIjY/OpBOaUAW6gUCgO4beme/PI6SkEp/8hXxPeBozf7DC2oSwjHKrclHDdk678xqNvpENr1V5l2e8gs+RoLEaNBfh1uZstbkHLJOQLDNKEQ6EZYwM7s9v2Jf2owi09LL4rgYbD/1HoUBog53dsqKnVfiQP13HV45kckpP1CfaU66hcWAE7gFZdoDBW8YDK3ZjkSyS401mPc+0uuwHqE9tgAmRiJ76/rHet1TnfMMJmRv304/0rEXARWx4lf4bC2uzEwzlAGIuV5RjxLx2M4qGQxJ/crR72zAYGcWpmgMowna4ZpCLa21r9ZBw7Nbi5ppS7BIJ7p3rR1kvoRhwnswnbjJOlbsKSZRE+I7xcJHE79UqZKwGcMfzQZgLLO5MD+2rWyLF8vIfGFUTQnnskpkYnMX5nFGHL6CMpml7KCCeP7ix3AAfTZuYYjmyfBcO6MH8awzO6jPCjWfaYo0mAD7L+H4OiKXJ6hqmzW0XvdeCeKLIDcePYfmXM12i+DIQ8JDfdmWirDyjhKXqBkCPGc0xw1KyBWckYhLYV67x3iZEe59QXQnjTzWFSxKU16UnykIwgOH+gnQ3T8imASO7CHMr5dTxNVAkx+aT+z3CDcp9dS+ADwwOi2oxLGvgp6KIryklnv/JPkEz5+PPT66Jv3fHA+D2he7Xf3yNAmPYLJa6Vo6nLtyA1LkPK
 c9WuLD+2
 NvhQstIY3m7WKRCik+T/ONL2ipP6ah7+gSNZQaSaJ49UtDt8JMwGbO8c4haW5LIcE3PIZ7hT0aeCMa7eComdp4hutWZh01W5M0/9ORIjrqrdfOqqkR0LD/9ey6Xu8rxRynvaFdIfwdvl9J48sBp/l4U+s6oLc3vvIJjRHtZErFPLX1xD6H0xZ7B5Tho4nqzcvn56Zjplr8TyBgHhYE6NfqeL0GH3VQEu1m+F7aHZEPxuvPN2TeHSLKAi7kHFVYHxvc26H7rCkXKePRal6c1STXsoNu/eioDcgn9/+oYIPU+yWEvu+KvhetyGWUgh/JHRWsgocxm6PpqCL0J1l6wXot9IiCplYbVuHOsd+HzMphBi4rP0cnZV4Lb6Iz6vQgWF1P8u7HdWKHCVZbvKi4VxfqIaWNRyURhaq9FlDbdRsz+Fpy15CvUKlAUt9uI/FmBIw6f9K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer. It is more efficient than folio_memcg().
Therefore, replace folio_memcg() with folio_memcg_charged().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5acca24bbabbe..582628ddf3f33 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4014,7 +4014,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.20.1


