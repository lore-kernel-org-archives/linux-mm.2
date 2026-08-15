Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB2CC5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9C26B075A; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428956B07A1; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A67B6B07A3; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB306B03BC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:54:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B25C0A2A6B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:20 +0000 (UTC)
X-FDA: 85102589880.15.DDA3F29
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id DAEE380004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ONPSH9h1;
	spf=pass (imf30.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786776858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFTk5A+CpTEE2+SBU0kZXE2vNyQzqzpJb7ipur+kflw=;
	b=EzpOhmyPDjMXjB1iKTBA58aYfrxJCN3ZdNl7t+y7vipzLHCZ3ot7q+uCPy9Q7BbGshmeZj
	faYUbOiH2WboIw7XxjiPtgdFOErtLwBqqBDp7vgoqXZliOlRy2fnot8fs8DDv7XFuFouu9
	1C/2Cnb92adIqIXKJ/Ge6Ukzd8uAvnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786776858;
	b=WQ8EUPfjEEVyoaJW+dWw2RzotjCrK6inq/DDeGstBZwFbYGgkgtATDvYIqhr12eIkj3XzZ
	8pQIvvHucowusDeUSNLz0Pe5yDODiiOR/bqbFHmB6BV1xLNyl+AFTX+Z1deRYOegQOphr3
	7oZsht4fA+zyV1qQ9J3V54q6ZS6jqL4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ONPSH9h1;
	spf=pass (imf30.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-381b831d535so2756942a91.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786776858; x=1787381658; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EFTk5A+CpTEE2+SBU0kZXE2vNyQzqzpJb7ipur+kflw=;
        b=ONPSH9h16Io7BiFCeO4arfZeF6khBRSomY1Oq6ogNPLrNnkgBlVv7WIjU9PBbzDKS3
         PB6Hkr/zg25fH1HEPDSx+dwgFyk/7o0kC70nIbTj4QZQvLYjwJT/+bCEhm0Jg2UAG+27
         QKdViz1DX7sLZzi/7XFN9YAMRDgfomV9ehrYDTCbe46smI8ljdgd0FX4o2eFhBQcRJnv
         U41G0f4unhStTq012Ni3KdpOYcyayMo/GbwnbZDK/dbNgUrr8ya+mRz/Xk4za6E4ka73
         EuanL0d4dVTd1qgV8woO40x3MKHSqmrEW7toMDt3Tx16Bx5OBWgyrA5rEG7G43GOggZt
         Qkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786776858; x=1787381658;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EFTk5A+CpTEE2+SBU0kZXE2vNyQzqzpJb7ipur+kflw=;
        b=FUW2mVvFHDIWRVA3znQJDrO3CksFt4ZJ33OaiKihMuvskEoA8R+AcV33cjpuPKOoI6
         Mp2ROEjObSF0vESyxR0v3qjGMxTtJv1IWbB97SGSL3UjsdP1tzGSnkEYnozJi4qqYNW1
         ECf/3JSmlPvmOtIg7dkpysrWX9ZcLrFbRhuZ3+P+ng4uPFkYIFYduSuuNBzh79lDwl3k
         Vq/PZztu29tgo/l84YMcQek0GUgM5JWEgP27mMRgZr4G0D2H1XrrY25SuTywCoG0gTWn
         in3rOK59n6989TAEUpIMME69hryKNDF1JxpijuTSNqC0JnmiHxqJfMpGYs+vrk69uhk7
         IX0A==
X-Forwarded-Encrypted: i=1; AHgh+Rq80ffK7zufmi3pECs4/YeVWWrTX5LY6JKzAzhSCUw3uNR5/ZhZhfWJGAWCKhUSl8LE6/8JM+QRAQ==@kvack.org
X-Gm-Message-State: AOJu0YwE7KVph8W7PBw7Xd1O4bD7Cw6fspiDiCuLsLbYsuAd2hR7CoyG
	Ya6DC6C7Y/eDVdKR1xKIGuOKzPEaz8Y6Uhm4PUMfw8B8mvQeMZyt5V1+
X-Gm-Gg: AR+sD12Vv6eYGTGIW6oiS5cGH+Ii1rGlllwbh1/5Nsvx4PxS1A1fMbb4yA1gganUZNR
	GSRbY+nQ4834TRlFM9YdDXw37Oya1R1wqVZc9QFrWMSl/fJs0jJgFK3qB0qxRACaaQO8EtTUFOn
	wpwhr4ROnrV9mEQZePmg7QjO/rDwilceC8IUxcZ+wQttphaXQU7mi9615X4fqAZJNW/9FMF4wWU
	/ArZCtViBKPpvNNouxWmS7iecaHGp3xMpNg6xTqlFNTHS8HbdJJeVegkw1gaxoDmSqXsZQkNBNh
	dSBDC6BfKq0/TBtcRO1NyJe29IEtJp5Flpc9gZ0g2Vfixs7O+l52bWHOMH1t3zcBi1M1t59lBtO
	Ofh4z/H+hK4IW9fhspnjW8trOu/ZH+8j8qaEJlsgv7KCFC/6DPm23L2mrkhNCzGokNNjtcTYd2u
	LU+SCUnV6bmiMPZKsWIAXPh2O03eyBX3+zxkkwNOvR/yWLwsGw1nRlrdgZOcthpgQ0Lqb5Ni39b
	y7FNRvI3/vrAhS/pvmv5frPzdRVUlItNv1pDG7S6Aj/2CPhyw==
X-Received: by 2002:a17:90b:4c48:b0:38e:488f:7068 with SMTP id 98e67ed59e1d1-3933b6d0d30mr11800411a91.2.1786776857744;
        Fri, 14 Aug 2026 23:54:17 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eb752fe2sm5691360a91.14.2026.08.14.23.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 23:54:17 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sat, 15 Aug 2026 14:54:07 +0800
Subject: [PATCH RFC v3 1/3] mm/zswap: release retired pools via call_rcu()
 instead of synchronize_rcu()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260815-shrink_zswap_entry_0815_v2-v3-1-0171bd86a667@gmail.com>
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
In-Reply-To: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: 89x66zsjy3ej9cmwar73xjdb9xrxc3ik
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DAEE380004
X-HE-Tag: 1786776858-822808
X-HE-Meta: U2FsdGVkX1866m4dfzHYNfyPi1Qjs2Wb8BaosPtZlMG+NoL9ps+M9RUKh8iCj3W5KyEculFE8svLdRwMdS5UuFhy6X64tD1z6VUkdAicdrrrYKnS5zHqk/SwxAJ5nq5NypjUCQ0T5KKnwUtYh+KO1/RfZdb6+cfDFYK7lC7pN7DwctvsFHiP9g98AthJD5MrnWqC+Dh9Iae4t6l1JheanFcyL3gPmkujjh8a4HOCBJbdwqjuQOj/Wep2GNIdmUQ3HM9AyZpcUKj6f+AIZEcUcSwQv0IEJjP16d3sG8mAYzDjgCKvbH31CMKVS1wiB6LAh8QfXkP2ND0LsmSWN1aAlUkNbQbf79MEdSThoBMHbzw+WmJMSteFpD8APk4K26KbuoWFYU+m0sECu3RurYs4a1wjwnufckjc2Y0CBqVIiJJW3c+HXLHXuUOzI9mmOXTu5vGxpIj0eG4vw2xbhy03b269m+BW6LwoIcA0jFW+QIPFRJFeGBbuqQWtlv1+8GeI9ParZA0kvSrM7UPj3M1syX4NU08BoxAG3WCoqhuEFQuI6zctFAyyOzye4Ic3FhRCvWOqUTCkftYC8hiuD/ZdFDScvfoNAaiMhDdm9LdD+QfxQt08teKbJqnducpOk592JwmFGdUFwZaHbHO0gm4vhafaMGlmYsH+Bx0Xh4BwCFm5/sfYERugRefsSEpDaHPneUOxnk+FcCzjb7xton2ZwpjXso8xP3e/u09bpHot5Unk3DKB5znKYyUbsDdEl4N2W0HFx8A72yA9TanP/1+EVt26uJYgyXWp6cm6EoWjVocbL0IBblonW+iSzRP35OpC+7Pb1KCCsjMSR+PowohGZz0KinvvMKO0ULk/B4uzB48oNI6Jz8A+eK0as6uJwU9NO2c3bzU87XHN0grPKQ5QReHhF96348t2pBvlHpeYGMBsNmwdziwoYO9G8Gkt3MubmOV7fvM7rxlONuHi1j2
 9U7REObK
 nHIJQEhnys4Myaf2S/nSBEWZ4QIWKsx7Z5QG1meLHiUP4bV5kqvXeaaAArgniVzZDrOChm9NzWCe5S5++1bkQyvJmizrkf4hWTXyJRgTXKb/XAQHiaiP+dW9bOpdA+oCS+8z1xpidRBBmIvsRULnEEZXgSYYutrgNw+2kKAZd0tbNuzgXzJvAGu5HfjJo6vvxrFuDM3gBBuKr2AqsHjzgNmoMzQYd7Hv2Bs5Ec1N8GMnVkZaDcB/PK2oU7LT4gm+YVFNGLtAYP4SdeH3QqndqHoRbNQKAnI+vaNdQQVrYBtL7fH1LjxmMdZnCsZqVf0N1EdZU/xJw9h82syrUZvD+jTdLEc7ISKuaU0gTNYCjo1Sfmy7oItvLUIMi4zb5AhMZwAbkB7/5rTH0BNp7qzKVCqjwPuhceFMcfoJ0H8TAgC0htvtz2wUi9BU3ce3uhnDTH8xbcDUHy3TY5yUpNJ/rZZ19nOjoqjp+FBUvrhSmsQsE2bvHYlT3OhfJAGhOu95G663d9klWIlPo9/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a pool's last reference is dropped, __zswap_pool_empty() removes it
from the pool list and schedules __zswap_pool_release(), which calls
synchronize_rcu() to wait for readers before tearing the pool down.

synchronize_rcu() is a synchronous, potentially long wait.  Replace it
with an asynchronous call_rcu(): __zswap_pool_empty() now hands the pool
to call_rcu(), and the RCU callback defers the sleepable teardown to the
release worker (the callback itself runs in softirq context and must not
block).  The grace-period guarantee is unchanged; the retirement path
just no longer blocks on it.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..cc4243356e21 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -155,6 +155,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
+	struct rcu_head rcu_head;
 	struct work_struct release_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
@@ -382,8 +383,6 @@ static void __zswap_pool_release(struct work_struct *work)
 	struct zswap_pool *pool = container_of(work, typeof(*pool),
 						release_work);
 
-	synchronize_rcu();
-
 	/* nobody should have been able to get a ref... */
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
@@ -392,6 +391,20 @@ static void __zswap_pool_release(struct work_struct *work)
 	zswap_pool_destroy(pool);
 }
 
+static void __zswap_pool_release_rcu(struct rcu_head *head)
+{
+	struct zswap_pool *pool = container_of(head, typeof(*pool), rcu_head);
+
+	/*
+	 * The grace period has elapsed, so no RCU reader can still observe the
+	 * pool through the list it was removed from in __zswap_pool_empty().
+	 * Hand off to a worker for the sleepable teardown, since this callback
+	 * runs in softirq context.
+	 */
+	INIT_WORK(&pool->release_work, __zswap_pool_release);
+	schedule_work(&pool->release_work);
+}
+
 static struct zswap_pool *zswap_pool_current(void);
 
 static void __zswap_pool_empty(struct percpu_ref *ref)
@@ -406,8 +419,7 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	list_del_rcu(&pool->list);
 
-	INIT_WORK(&pool->release_work, __zswap_pool_release);
-	schedule_work(&pool->release_work);
+	call_rcu(&pool->rcu_head, __zswap_pool_release_rcu);
 
 	spin_unlock_bh(&zswap_pools_lock);
 }

-- 
2.43.0


