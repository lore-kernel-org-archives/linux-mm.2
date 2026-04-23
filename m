Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1686BFDEE4A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600066B008C; Thu, 23 Apr 2026 16:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512FF6B0092; Thu, 23 Apr 2026 16:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428056B0095; Thu, 23 Apr 2026 16:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED0E6B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85767404F3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:54 +0000 (UTC)
X-FDA: 84690974508.11.6DEE54A
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id A798880013
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nI7jYAVh;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FE7KATctX9/flJ2U64Pj9KvPGOu/JEwhawIz5SLby7w=;
	b=lHd+r+0h2o0q3B17jMKwmt+TM3UHS4U/JNVE4M5jorbxNBl61ge7/RMAr4fskqg7K8BuZa
	sdn/ESFVm9+Qz2/FksqvZSbGGiWfvR1r2Edx6+bfJKzZIS6fNbouPOJ2XTDE815IYOdyRV
	BpMMIFoeCBG3UZC8qRIMXy3cr+wMNi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976492; a=rsa-sha256;
	cv=none;
	b=hhJkWkC+89JXvNxVj5ntR3JCnyslUKhNlJxeiVCD1Vgd9OtbT+PdZIX2w3CP7P6yeSxQBD
	X8RGqF5+G+c0JmYi8Ay4DZtSsYGXmLKZpl4Arvkq8zaDCqX8sagsgzFFlGdbOL87gnRnYF
	7bWMZvcwHLQqWa0oASFuhPUgzsPqEEA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nI7jYAVh;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7dcd8ef572aso1912505a34.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976491; x=1777581291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FE7KATctX9/flJ2U64Pj9KvPGOu/JEwhawIz5SLby7w=;
        b=nI7jYAVhBhhDLqwmhoiy5n2Kfokv+PSJSE9oqvjdQL9L1Cd/xFjH9TlfmV/y9ZJ61d
         qh9AgEOV9x0sEo+2OBhEnzFfD+pW+zk+pMoYucxnLBG6U88CvLOarh2J69TR80FpVDRr
         yJfQp94vNy+9gkCY2XjqBWg8n9JXL59WtzjUIIcLl8cN3WPu2kB8N2wvF60ESsKpmqsb
         kRx5pu0O20r8JEHm9D2sr/cLVXdHN5cYXCSvq+QEXqFcsI7KckQ6aocUrnY7yyKaHDWn
         2OX0Ydp5ovJXEU9Chv3ySIZcQEh/EnIDZJ8RI+njlEFhnzxfe3MneslIui8n3jxuCzr9
         OFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976491; x=1777581291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FE7KATctX9/flJ2U64Pj9KvPGOu/JEwhawIz5SLby7w=;
        b=FH7AJ5+lxCHGq5Z+DJUZbKGV1DSLH4yZR2qGRhk6lBFIQh3hrWwl45WpbakcTDaGOO
         pywbLPUOdx0Yu5TXv7Anr9ZbEjDBu42xMhKMLNI08dw0LoS2gWCcUQ1SB55HA5sDkEYV
         aIfvX9Xd/Yl6hwiquPn/0nrfsDyMzC8Szil588bYrej6v94oCoHJp57T5GKPSMcFJf/q
         lCZrjeGI3902KxrmswiykNx7QYabvGU//XZGSDIZfLFfNi3Pd86xWIKtcxSs1k9+pdR7
         iZIK2Vr8oLrO2yEIjV5VRM2SBTerazbVgwbtCtm1JV4G/o16oCXxtryB9P3FTi9OLiJT
         UR8g==
X-Gm-Message-State: AOJu0Yz83odw+3m2oeTez7ocDQIVLizgpwnYEbHJO4yW9/tNX+yi8UE/
	PRkNfJoGmuWwDmSFRBK1IMFYHZUMBqIMK4tP1UQPMz09txavGe8AW450shGIKA==
X-Gm-Gg: AeBDiesorn54dOlPeS5FQLTJHR+9iLpY3AiZlXB1sAN5emHdu8VxO5EmmBMvpc0bfIv
	rv4LFwtKnaC1xL1JOAm4xi7nHXsFf7xK9TG6eWNbCgK//GVTr491dxTzUxYvEdsvfMjrRpsyteh
	ehs3zgaXCXPof6ajLGHl1hW+jKtpsnCoWCg+P6uLzncOu9/VdhDVf1yRnHt1JlTMWqdncrC8CIM
	95d4tsIwnpiqAMX+GkU6ZAwmqPLmBM6faGkS+S+25M1fMzarEUoMDNYy6uDt1Fig0pNh+AnyCtD
	+uXOyU8yoVplwj4cwa6bMKShMU2/ihilt8KOPXK3MSB7ZapnB/oeeS2EHE1is3h0hrh4o3KbKAq
	7Fms8qVQRQs3OI4EZkBoHiI0IK7a7FeITO2ST8YerXQPpMa4kSRsJNIBfaBc3x/K7oGl5d/dxOS
	k3DxihKIarBsKsko//ERgJiZQtz5v1A/xe
X-Received: by 2002:a05:6820:827:b0:694:97ca:9ec5 with SMTP id 006d021491bc7-69497caa1c1mr8146048eaf.51.1776976491332;
        Thu, 23 Apr 2026 13:34:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69464c77c7fsm13161024eaf.0.2026.04.23.13.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 3/9 v2] mm/memcontrol: Refactor page_counter charging in try_charge_memcg
Date: Thu, 23 Apr 2026 13:34:37 -0700
Message-ID: <20260423203445.2914963-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A798880013
X-Rspamd-Server: rspam07
X-Stat-Signature: 7p1qb3e4u3cdsihaup15be3soi65x4zs
X-Rspam-User: 
X-HE-Tag: 1776976492-866963
X-HE-Meta: U2FsdGVkX1//FjVgb8gT2QH45NthxipTDmP7RhNYnTBpJYEizR9wfOKqwpjBBjnp6VcsssWpo3DQyR0TjCZUOFTddIX5qQBaY+AKtjhVed9jz0WtoI2jVvX7fMMQGZoRF1QkgnLTih84RkS6FUFuohAHRR6x98DizMFaVqIpOJsD3KZfj8KA5B98WtasFxcs6cXoDz4FrwAOwsVsJPaTywZZLu21peGzgv3GTx5lRVVfbyb6LFXet+q4MTAxO60MQK/+EgUCM2wX7dHiTFgFgXIpTK5IbZ6ywCcWBS9Z5XdY8u/0f0NWleUX4OC6MYNpgP78qMFkdPVKqN1hPNdSf/oprGjhFAIsy0AYHakdVz6VMwdJVZMbPRVF8kFGN3i/+F0YsmgV09i26euxhoGnlixaQ1+TpVIHqcyJz+hpXALHh0f3Nb3x1vJNqdeRwxHTuryL6kaDzH/8SacwzwFGRt9P3AN0ze0I5ibWDE1CXV1tImhJO7Mhf0TwTSB/4kloB+QLFpLJjGIiztNY7/0XH4apRc85jii+nJVBK5QG0CV3sqvy+x8UJg/mLys3loGr1HIIClLsDTA7gwySSJnLybqpeqzyF2qRT+r6cRmh1e1lB4Vbi0wS4E8OqAwEOtlib5QYxQ3lobDsdvHCpwl6Pr0GMp0Q7dG0FwMeSKBNlX/c6mNsU95iQl/m5nZtBu/WR88wowRYIcl1v2v29IoEpdo0W06+I6VUlv2AQDcRDH2hDp6Dh3Htzsa3nB8ht26CqFM2RGfdUHylFJoBQX3az4qEZNpKwKtTy/It+nsiXfuoA1sLOLsGNW4sCRwAfgWQ0epyOWx3sGWTZFyeCSekpSEUHffjGh9FUYzN95SXdrylfefaZRn6FvAIhdD9vL2qQMi9QBeM1LYClkrr9dl1gtrYEPMQvf4XByCf/ZJxLDtt2fQT0XVhrNIGrXw7Oc8mApJrvDVo//U1P0ojCZT
 oZTkz9HM
 ruk6AgTPAyO4BBeTK2ReqkcUpq18x9jTWAtSEO9n4CEXebmN4Iso+QeTIp6GRizTDOzLXg9Ruo3uHg1GLZMm5Tym5YvP9SPkNhY4PSUtDyXIWdXDLLs9ML/+gQFU8K9IFtvvW40HB3kiY4RGe/J3rPq1qtmo1OYuGhDxUuVvyMy3EZwbG/tXjmc2EUbDTeT4yBDifcQ3J6RoqUfFRtJpNhh3M2cpQ/JMgWB4c3R7fhFWteoMgP38/1AR/IAU/b8xw9aNjNpJ6FlU0VUGDdZMNKwlzyI3xuh3BRqAcF/v0uIo9+p2QCdXwPDjan1ymckDJY5W50Rh9JQ/HdGuSQolrA2jhHhHFtZt+iJAyl/mhltDPj69t3jfgKDeKkXP8yER/0ZNzI9bMoDhHQTNfF9N7oCpW/kv3A60JxdvOWzj7KHmMiY4K3QF30QX61HRbhBKslnCkhoynS0aSje+K0//9WTBsVYLvR3xJi1AUdGbxVPnH+ULo0m8NMHGb+FNXylnz2e7N372Xd7Gir47eUC6NnuhSHZvqDm5i5O8H4vzkPJL/HUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding charging and uncharging of a new page_counter
toptier to try_charge_memcg, refactor the code so that it is easier to
roll back partial charges when any one of the three page_counters
fail to charge.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7de23ecd7cef6..8f7bedb55dbb1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2385,18 +2385,22 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 retry:
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, nr_pages, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, nr_pages, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, nr_pages, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, nr_pages);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
-- 
2.52.0


