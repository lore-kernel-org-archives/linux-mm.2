Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF036C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4CC16B0088; Mon, 29 Jun 2026 07:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23A06B008A; Mon, 29 Jun 2026 07:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960EF6B0092; Mon, 29 Jun 2026 07:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 701F66B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:20:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFE61C1BD1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:20:57 +0000 (UTC)
X-FDA: 84932708154.02.AA4621F
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2B6A0A000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:20:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CGxWhlmT;
	spf=pass (imf15.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732056;
	b=GZYzz46clvopxjPrCupAibk9o/jbrZEZ/kQAgH+Z0gGfMgJzvOWS03elATldwm6o43tCSY
	fLud0Uibdlmm0ie+HgU09Jm8gvb6Ba+laJs7r+vLF5da8bi0QyI0I1SRm0aLM41awXXltU
	Ui99RfOyTP17skgWCgoB4IeyH90HWnY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViL3fRcEiOH5DjjJbtd4DZVU5q2T+7FWxEKjKuEIV8w=;
	b=8g6UVSRYejGOLm8JXZB96Yaa+H3rxyPBONlW6uHw1JepUQNvp2yUp5auMBDwJ0BJsGtmAq
	4Ph6s8i/9BevMI1oLgDoBZHWbI8AgvQ68F6KxbHlRyXnOio24mzSfGfhhoi2Y4oDdHaU+y
	y4/I5Ei0qLrA3RhLyd6IdfqAJfWkYNQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CGxWhlmT;
	spf=pass (imf15.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c9c1779fc8so5180655ad.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732055; x=1783336855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViL3fRcEiOH5DjjJbtd4DZVU5q2T+7FWxEKjKuEIV8w=;
        b=CGxWhlmT70GotJmsyuWQGyWrAlDsPZjgQPxb8jYfSqg6XaSsmruMyVjcoEeBcMe46b
         hfOid2fqf5wNNK52DmbaQzRlwd7VmtzA2fYUuHEbj+25Eoaq/d8IeK5ZLwl5afJxorBZ
         SODKSzzTKqIKIyDjdg6NzY0MkH4wpEWh/02zkLenyHSbchDvpRxN8sxPiaiLfZnRWgFM
         RshNwPyoqeYAuQ47MtdXRIeG3heftE2S8F/+ZHCoYyWeQVTbSq8yL5mO2B5dSD2U9zh5
         2HcpdE9MLQXyrpFxHGtv8rpOj6/zWZJ6A7ijjxDxz/jsO/LEeUSSwiEmpGx7V9m3xvu4
         Ei7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732055; x=1783336855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViL3fRcEiOH5DjjJbtd4DZVU5q2T+7FWxEKjKuEIV8w=;
        b=GBooANm+tdS9t7BpWrFDMQVGreesa3WE1mGPmsgCcL36lbZxxGa2PG+V/bjO9gOuTb
         1jCzfNvlmuhmGU8uwRnzwVaAMm26hQZAc3HGtfI52kyu1QLy8/C6nvBXewAO628U6zqo
         Lvk49yARLFqg+3exJRVOl5nVtD137QpcbMDwrXOnc91Iwq6vygZ6TNoFp50gOKJiC9ET
         3j+C37h1W4Ym5Cb5Y7sN0iDnoTm9S4syGRyau0ZXwXlUBkGDzeaC4kmbTSrn5bhdhVMU
         qljUr47ucTsYstYNwSR76FnNdizunqlfGyRYyxdNa52gc2FWK4CL4rqN1MDZc/XE3SXH
         toPQ==
X-Gm-Message-State: AOJu0YxgRMeFFUgWyikC67GobZ8lEu+9eEa7TEcIbOtRyCbNTU/WqX0X
	WJzvoH4G6mHp5C7wtoRAzVHffeXzpiFtvlKrZlUzzQZZjeVkp8jZgVj9
X-Gm-Gg: AfdE7claPuDdHj1LBw+11hLa16FZuJGzWDfgBsge32/0QmRk6sFXKnkqUw+fl0ZJWQb
	BGkAt86XXAhhndzar/r1vYa4N/kB8u9R8T26mcR0ExC5jLeQvOjPZQkCl4YWj7st47CFpH8qzhK
	YRjkAF54rwUXlaqEERIurlYIdkpdCrEfae33KF/kdkun1Uqh0lJv1ZANO12lzkyNCa5nEQa6Qzd
	iqvk3jtTXbwBZJCDeRyCFM7tISVPZSw1L5pN0VBU7uZ2Ptkr6HZCBnlo64oxllT8vjR2rsTl51g
	XSlgMOikHO6m/TfJ1fefs5xOo7hbV+BzWoc1mlo9bao3y3Y7dy7YzZD7qN/d1Pa8TK8RTjAps3u
	nzN/hORIGpHv7Z2h5l2opzMapokSyng89LHf+PrGvyGDBb8r6tp5cshiTpJgGxAI9gf6mJypQ3k
	HNVxsHDw9i7+ntmry9oaiRzVjLO8q1YK1+Z2GJiusm2VqN70nzdhQ=
X-Received: by 2002:a17:903:690:b0:2c9:97a7:71b1 with SMTP id d9443c01a7336-2ca26545886mr67075ad.44.1782732055099;
        Mon, 29 Jun 2026 04:20:55 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.20.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:20:54 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 1/6] mm/zswap: Fix global shrinker when memory cgroup is disabled
Date: Mon, 29 Jun 2026 19:20:27 +0800
Message-Id: <20260629112032.20423-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260629112032.20423-1-jiahao.kernel@gmail.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n669inm8wrnm7yfhmkh76rx5hjywyorg
X-Rspamd-Queue-Id: 2B6A0A000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782732056-690875
X-HE-Meta: U2FsdGVkX19fTqeGVmNemy/iaok0hrbaV7gtx/HiuHsFetZDdRNun6Ju8DucrNVWDfnfTaQStXR3x/W1yjqKuT1RasDsuWJQKLLyDYTHhFkf+w/+Dy66715BhOCNsLOJMyvWdsXlfRDTj4reQa+RhLZ5rjFkMe5Qoh16tBbJKAa2ReWezcdOKYDhBHAeRFa5gLBeK5+curN3dcOi0uK13DVRs8YvfJtVEXNFHo0pvYpBKWsjQNIvulnySKk3Jtajw50+cyJGmCiCgL7W3nokZYTrVn7gvFelqSRk8DcjIfdVQfSp+MtnJ276xN4ZAl/5ob0GWwj+WPufj7/nAuiy8JuWsdoCJSj/L1UC64qZxnrMLSrurvrQ+gE5VZSuVPFXSNyGlatRTlmNLE/AWVzl8TDT4FMpxEQ7ne6vIzx3wavtDcdWOaq/7GBbAnNj+pDrHdheLTP712OsAHf917HTvCJspZr2zgS3qRCoXoC7BczfX+eZ3Bvum0g6yXr28yQxj1lZ/m26DT6qX3Kj0DQxAUtdWbW5yzZSZZKQJhkgS364LFVurhY6+YSgRy3I3nZ4CeRqCz25afD8DLEo664/kNs7t8CGEGdYEte8AY/eAOkafG15d6OhNdO25vOd1h4JTDGF6F0wZEnLTmAS3NJ7KFdQR6kzmTzDDsBbQiK/mZuFTtMlOwS5y0+V5DSpN9FTz+NWSddVgYbK49u8NfMvKDXjp6mjwiSgn+XPVDZC4VtcYb+NRFzCJ/NUxMdz3egrFOd/o+Af2ECfCB2kS5pBcuUySUbNfoulJPYihLIlwXFCN+hMzIivFm5K92sT7ct+VxNoZ+ZjgimlCd6XPWzIIgWlE6+pIy2R8WzYNx95BOn0IkPneLi/lL/Z34ZRZeKkRWepPPeTa22PstiebablT4ti1ipfmdq+97pcYud9sqFycJfc7Wq4OiTeByrOu75z4OXa0IeVYnS5k4Nr1x7
 ajStXirX
 Q+Qgc/ioIbn/zvQxZFasSPrxoUO3qrZEqKfe40bWn5s9XVGXtF4dGFxqmyH+vEZ9uXdKvYNYQ2/5qd8Vx/hZwtw5uqC/tYoGRDicEaayjlAeoOaS4OUkfDeSgtvUVUcMxXgadCSy3miHMzMJRtKMBx0civuCercjT+RRUscaTvLzZuCQW2zdgshCuFPB/3W5OAltnJLExlM36or67s6HjxSg5XRA3px+w+iF89asCYVpqm/HJpYp/Y+phVXWIzLBIDGHdj+8zTc3pOULWZ4X52YzdoshncNjIpElFjlFrz656Tr955ho+YamdAc0SW1d9oNte6hIpPfk55MtXZP9kKv9fBRkRy56gIHcNU/SBzvolr1gXol1vQAEDxm/vfSDXVDLAwKmmJHJZWiFdlurgEV4UG/OXLQAWrJ2Fx1/SPcdERsH5cQiVWm51i2BlgRZC5JJtwWntCgYWgxa5JpIpCngq8hGtyADKHuxwkhR5LfxTkx9mMuJ5YXM86PulvOjy28ssTott5iOy8llD98RABkUC7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
Therefore, the global shrinker shrink_worker() always takes the !memcg
branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up,
so it fails to write back anything.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly. Stop the loop once
shrink_memcg() reports -ENOENT, since the root LRU is the only target and
-ENOENT means it has been exhausted.

Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Cc: stable@vger.kernel.org
Reported-by: Yosry Ahmed <yosry@kernel.org>
Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..0f8f04f22888 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1356,7 +1356,12 @@ static void shrink_worker(struct work_struct *w)
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		if (!memcg) {
+		/*
+		 * Reaching a NULL memcg means a full hierarchy pass completed.
+		 * Exclude the memcg-disabled case, where it is always NULL, and
+		 * fall through to shrink the root LRU directly.
+		 */
+		if (!memcg && !mem_cgroup_disabled()) {
 			/*
 			 * Continue shrinking without incrementing failures if
 			 * we found candidate memcgs in the last tree walk.
@@ -1378,8 +1383,15 @@ static void shrink_worker(struct work_struct *w)
 		 * with pages in zswap. Skip this without incrementing attempts
 		 * and failures.
 		 */
-		if (ret == -ENOENT)
+		if (ret == -ENOENT) {
+			/*
+			 * With memcg disabled the root LRU is the only target, so
+			 * we should abort if it has no writeback-candidate pages.
+			 */
+			if (mem_cgroup_disabled())
+				break;
 			continue;
+		}
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
-- 
2.34.1


