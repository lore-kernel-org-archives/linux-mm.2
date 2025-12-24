Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0DDE7490C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8B76B0095; Tue, 23 Dec 2025 23:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBFB6B0096; Tue, 23 Dec 2025 23:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7136B0098; Tue, 23 Dec 2025 23:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1FF36B0095
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:22:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1E788B66D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:29 +0000 (UTC)
X-FDA: 84253068018.22.F88B57A
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBEE4140007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dQA1QOF3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=shu17az@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766550147; a=rsa-sha256;
	cv=none;
	b=Zu41lo1yE985JkoeiBu6edzMt/rbzIqRi5hIK3HjFkRsiqoILZIFHTpwUpN54JH3GTLihZ
	gNDQjMX2eE7vKZwxwt4QdCDfF/p5LvvDR/CJ0PdjpTu9U/kvo7jyOfQxVYgqgq+mSGSy42
	arwk3Igvdn4SzoDYeRc68eWHO8ITyjI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dQA1QOF3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=shu17az@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766550147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8remLMvBFK5RUdUzYsP7LKIRjVVtdklxr8EKcqM/1U=;
	b=EONFZvCKuyjbKbRKxtiOUqjZAg3a9g0WDGcO2lMPWamGm3OPXV/B2VZIvzsZ+UiKoTJcWB
	AbqONCSzT+mUn1FqJjzxvGS71ZVuZGTpdnmBwzdRyLPSvvrjIVf4hQpkBxsgZBCpTEC+Ng
	1pTM1ZYpE/jUsmktu5gP19wwsCqG0Xs=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c2af7d09533so638395a12.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766550147; x=1767154947; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8remLMvBFK5RUdUzYsP7LKIRjVVtdklxr8EKcqM/1U=;
        b=dQA1QOF3/qKB6kjtRxG+UmsnUdHRPh50IDU8P7NJ3tcG4NfRcMyc/cODejixnwoHlx
         a8s+y2CaOmmRLsEbQcxAx3DRfEp/oSA3XUdVhE5gWtq/1WIGNJLlPOKkuh8W2xwG/xNK
         daN/YTGRIP3W6x+ajgl8loM4iL5hk6l+P7gsWHNattjJINqZmqoCJ5D1C2n621cp+V3e
         7HteAzDzJyK/vRDDqrwWU+nJVgdH1WjRIfs641l0WhpLNcd/t9FW9yTZ7rg4TuL/gcHE
         9ynk7McgRxBMOfRUUzR7NmSscH2s58hE7EdVan6JzBfKTVC4Ca5Pgc26lx/+6CYqaBJj
         idug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766550147; x=1767154947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D8remLMvBFK5RUdUzYsP7LKIRjVVtdklxr8EKcqM/1U=;
        b=iQPF1bo2rpQWcDMOl8/MERuth9/CDxf6Z9PUpjqgyy2DIgl+qmsNN1M3cUNIYwyd+1
         WHmEEKXHbWd6mbpz+okSLlGBA3OiqLM/H4kDZTZJYtsxR65eja1+A8c56D0tA4Gg5EKN
         MIQ4VfXQcM5EKymBbfrPSDTSYvlLdP4PwQ83a/o3wDzKjKo19+wmPvEj/C3Nu2lFZRm6
         5BGsfc9s7DiN00fExE2Rtb07zGZ0FeCM6+yq3//J1UmzB5UiZuyIwjnQL6GxAsWg7fLR
         meBRJJR1f2NzGwsuWDigZJwFEatgotrV1Rbn4eZP+wc2oKviwiDQ6zqlPE6aO69n0CRL
         OaBw==
X-Forwarded-Encrypted: i=1; AJvYcCUSyNGlv/gBdfK9xn+NR4XqY85d7r3VDRUSOCaZMRHB72jEBNqhUYGnKhOmv2Zw2TwITdkGVSFbgQ==@kvack.org
X-Gm-Message-State: AOJu0YzfJ64+qxjUdMs09AkLH63IJ61UUsseFw26ihm1G46ABMg8dZpk
	zpXHbjIIaaUnzJf2f0cCHMPAPylW8hVjTURN9Dva4GjLmknvVXWji8ev
X-Gm-Gg: AY/fxX79Avbi+HAR+fvhETt8K4SZ/7mLKkVMVsnMf3rj9eD6h0ec2zjtDT1iqzdLEDm
	nMqpJlvbfZCYjnvuTmkb4q9BvA/riFISZHz6Jcf9FmItwK2B1vU9QaE7WwabPPS4oSGjCcodRLN
	gkSJYZWTE+dtiUI0ZBIHIMv5g3xkWQJ5bmqnU2ogYY2lDWfPcxUdvhunPo66yKmeP77guXHbp3f
	JzrTkag75VOh8BQtQeMFKSDmLe6ivEJa7d7GEdvRdv2czxzH/eQrVSmkuvwnvLfw4ALZYQwnptQ
	nr18X/RLbfGrWjB//q39hk7Kgc6LVWAb4OiWXw9tDog/ZsFqNehX6HOJEqtsXusqUKUXHAEHxEl
	lpQsCZ+nfE4eK/VsiJWiBDxnQXzEsTlih4Yv4mLronNVxfIFDws4QvaicR6CnXQ8+ON5CJMcgWv
	Pidg334BphSsyMC0YNBZzdKQ==
X-Google-Smtp-Source: AGHT+IHfPiFWmZDW4o5w7sYzXHS8vE/zaayVH1U7R9hjLU9hYqPevU+4g14ejv4+rRb+HrXioe9eQQ==
X-Received: by 2002:a05:7022:2586:b0:119:e56c:18a7 with SMTP id a92af1059eb24-121722b4e90mr16067286c88.15.1766550146638;
        Tue, 23 Dec 2025 20:22:26 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm48542031c88.8.2025.12.23.20.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 20:22:26 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shu Anzai <shu17az@gmail.com>
Subject: [PATCH v2 5/5] mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()
Date: Wed, 24 Dec 2025 04:22:00 +0000
Message-ID: <20251224042200.2061847-6-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224042200.2061847-1-shu17az@gmail.com>
References: <20251224042200.2061847-1-shu17az@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CBEE4140007
X-Stat-Signature: b9t48e1faxfaffqf4yt37mzniaexaab6
X-HE-Tag: 1766550147-844873
X-HE-Meta: U2FsdGVkX18sYQMu2Xs1nT3DYbtLIeBCqbg4F5PqoH4Gzn4E3hdbwpIUcRa3/Saa2/BK6g2xGx/C5r7fT3qwqsEZ8KGC+BEW7e2O1BXqVdIzzTp066P2WyJEY7gyT9bAWG44JqlLvfgc+iPEpXx23h7K6nMt7NajTV9Ed7dvPFFUznkbn4GYTEe52uZfMA7AF8l2OVV2khwftICxNjoW1PAXSnwmS+i4bmxhB3MzjYSqo+Yzu8xsGOXT0t+FlIKMcBMMaFnLiYuXa6UIfYpCLJhMMlVUnEsd4BGrV3aU+H1VRthwe8eCYLhWPAjBaPE/nPFJV0ZK/Fes3xVv1BHXJsQufJ3aGQYLByDWmkpb51HyhyfItyOhf/OIdAjyejasiZ6B3J0pSWXytO1g3OX5tB4jpV5QkOahTrXhSsu0oGu65/IX/3iMOrdrIkRMozrfQOXjeJ1IDQqtByQOgak3MJISGgyffnRCUqzgsqRtSCE9A3LobbexWt1pw84Mbti4XtKXtPzvZb6PCRqVap70T65GzREE9Lxz7hZlUL8rH7qm44QyQJHqfkKZ7jxp2vQYXuIIAHZ9bHDX3mNbqnlYFurYWxQmvdKDMypN8NOeYxiUb0CzNTCaBGAg3udMgpYFWqp5OEGooPhgBoBUS7r1tbvc3BPAdctIHxjmHXgas5Z7gwURT3TJ3I1dC+pClHkIO0ppnz4D9QJQLtk7cvrW4h5oMRiY+/LwXs2vK3NdoU1wSN36qeV3mMfS9q/zLykY/K/Qco1ibSHuKORWOx5PLaykwCxCHT6jpgCSjrPBePNOdw6g6Je5J5quGpYHtLpd2XpGCSDYaAPCa1q9s2PJdcywcp/ng/x+ALlnEukS9tydYnHYFigv16qORRWjVN7ilSWluH/ct1FR3EHY1jH1sEINuC7umf4+vxAiTRzDahRptS1ns7pGJ3F5kVyaNwmHQMf2luH4+f0isA+1SEZ
 zUyZbZit
 6eo8hrmjnRQ8340AyPBBQb7n8pKj3KoMjbVYSljec8oi2R42eahk22j6YQARLHydPk+yaBNWSC+j7DNWo/PRPJzV0Xl/j5DlCH6hNyTlL+jBbjWIbYipjWqbERnLcNhb0rYUgqOUfsE/NfFfCGfDpR9rOuXyuBZrwFCN0sFtVxPBTcAbAG1+MK4gjVzuHrWrf4bEA4G5c3wLDp7F7lcD2HdYXRKic+hCTbGQC4H4k4CKm+gwSYVLke8p+lUye2PnNuBstwnIg6eM3dRfEMFES21BRXEwvBiHm7qxcZo0sEhUdD6LCso3kO3hJxWxkcfm0RRMQbXfSHx5KjRnN+Avyefi4DQNgG9MWpMWYMl99hu8kvbtbl0kfnto+LPMoxpvw8zJMYhuwSKJHWkSiDVRqpF6vOYyuKnsHs0dj469yOssvTirgTBUf42KnwjBtRxUm+zSd/vnGwbeR6dI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove a redundant test case from damos_test_commit_quota_goal() 
as it is already covered. Instead, add a new test for 
DAMOS_QUOTA_SOME_MEM_PSI_US, which was previously not tested.

Signed-off-by: Shu Anzai <shu17az@gmail.com>
---
 mm/damon/tests/core-kunit.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 36622a2c11f1..4bf1d172436b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -601,9 +601,10 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal) {
-			.metric = DAMOS_QUOTA_USER_INPUT,
-			.target_value = 789,
-			.current_value = 12,
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
 			});
 }
 
-- 
2.43.0


