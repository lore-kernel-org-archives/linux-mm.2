Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2E7CD3440
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C016B00B4; Tue,  5 May 2026 11:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5EE6B00B5; Tue,  5 May 2026 11:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F306B00B6; Tue,  5 May 2026 11:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4065E6B00B4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EE451C0775
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:34 +0000 (UTC)
X-FDA: 84733775868.29.FEC35F7
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3469680013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZZiRnH6R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O97PAflqjjtCiKkA3gTz4fMVjeIt3GdTmnKsTZ8H7Z8=;
	b=yq/Ei+wO8Bl+8BHRTmAq7gAC3swKPcXwOVtXfiQAWIklQ9VW9bppMxH4azu5s21bQPI8Im
	0fGTNw2BZUU/BXRVIGfzU6YC32xVYeD/dK0GAIlgFQnSpAqyw8WeyULxLjFJpsWKhuAGkq
	S6F7OpDDTcDtZ1IVb/2c3U1/ReWRBvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995572; a=rsa-sha256;
	cv=none;
	b=rUpPQ5xVnPNeubgMZ5yv52trayR387Wz/WiKVx5hcb8qFBDrt8MiyJq3Zu+luOuPlduNml
	quc4Ts7V+2pR4pLvRxI41yFlJH+G7IiqRc0XdReL4aqhgqtvb/6BKIX9swrIiF0dyV59wc
	hQXFFD7b4hUMvFmmzBZNwnITIH1w5EI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZZiRnH6R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-42fdab683b7so2832169fac.3
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995571; x=1778600371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O97PAflqjjtCiKkA3gTz4fMVjeIt3GdTmnKsTZ8H7Z8=;
        b=ZZiRnH6RRhXjq9i8dgHo46ocE2odiAXaz30tCwZFTenSzoNiY/KpKeo9TZiZ55tjrI
         ZlUYNs8KvidcSJGFlGzYR+eOxk/VeAyI0plHqYjzls2im8MrtPwKZDQEd/OJFe98OD/N
         awx0NXcjUAi+bZTpgGij/78jSp1gm7nwfvVxsUcjA5fjR8duCNRuqlFr8ZOa+8amhVOq
         nhH2N1kIdrCyUn0fKE4qgVsbnEiQTc+EdxLSLLplEG69AO/L6SMR7hvaBkUeCIqK8YmB
         s5bna6UvD+3Q6H9tPEtPN4RbfKkvq3ZTj4p9NYjvXbu1y8TzOmNHwylBqME4KCzwN7Cf
         TQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995571; x=1778600371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O97PAflqjjtCiKkA3gTz4fMVjeIt3GdTmnKsTZ8H7Z8=;
        b=cwX9RuHTgbtqwwZv3vqdnZT7w2OKjBlVFur5G2QJhsjoIGxFu9ibRtzuBpAEgYVQfE
         z6azuhM/611jGtyjqAmTb+gnVQimUxFxgYH50H2WOHwgxxo5ArQtKToZf3DNzdWKWEnL
         CLsnZz3ZbpwgTdgqBPfkU8QN2dxLwfxiGd0Cjb3qd/CpJSBON1aKsWqKMc6dxkccG0Oz
         6ch3MTz9excsM9Mvxn0NQRUW3+9cYWKZ5+VDUk4SyffXVsViHtReyxfAMqORsoGD2Eku
         /yE9iq2juOECi9Das2VOqKg0wveKA6xLaWHBLb01t6cAXd87746H8x4XRh8jrH35nohV
         xYKQ==
X-Forwarded-Encrypted: i=1; AFNElJ++7hX7oBH2to0/Ww1lSPyJnmkrHRM4W2IpUy5G+Gdww8rR7kQIlw3xNF31MRaWBF3MnHCkbcxLXA==@kvack.org
X-Gm-Message-State: AOJu0YwnI3Tk87Tyjuv+NAaTGmMUNp5lKzyzyt+u/3ewHyulY8aMu19C
	JkNHyn3GrzrRLT3EQsyva4fvToYDAmBE0c0SL4SulGLwqwcou8pu+6JH
X-Gm-Gg: AeBDiesAjYBHG1l1+O4XQTzW/iHwqMqRLPo0DlwbYadyD9xlS2U7aP3NvVRfbs5jWjM
	RJcr5MWSwvHm+CdflpqIIDVxVK+ENuCSggwJwUnFCbS9zYJx6ZlpkM3x4medX9y3NJg8Nz1lpzH
	WSrLpQ46MUNCdvLYdeT/GsdJYD4XVqPdqgkJ8NmWsV70F8D+sCl5sxTrMXO1aIkHW6M8CP1jGwu
	KOyzap83TRLj1eDD32cNJNyeKGMypeLcMgcbu1LtPwjcpesFxzd5Hh9eUsr/oT2XB7MHnjuuY8O
	yIrL2SIYBkNmDaFUwXjObrhp5bsRUVgwFryoQFuOP44Na1UWCqX8HO6+Uf20MM5uF+DBlXNBWsY
	uRJsQt7K8ixdNfSme7Q2s0j5of1fzh1mXblXsm7TdzKYwR80+J4dkHsa0NSvGPjm6bo+NuliI4y
	ubn/dCitT0B/2hCHp/Yn0rdPq9rePPNz3ebmn06RaRRa3qeCFC3bozdSc=
X-Received: by 2002:a05:6871:3861:b0:417:a283:9c81 with SMTP id 586e51a60fabf-43476281571mr7457002fac.35.1777995571187;
        Tue, 05 May 2026 08:39:31 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43454d35e5bsm13955814fac.15.2026.05.05.08.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:30 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 15/22] zswap: do not start zswap shrinker if there is no physical swap slots
Date: Tue,  5 May 2026 08:38:44 -0700
Message-ID: <20260505153854.1612033-16-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3469680013
X-Stat-Signature: jgkuobgh9ryhd9s3r76ddcdqdoggdyjs
X-Rspam-User: 
X-HE-Tag: 1777995572-87936
X-HE-Meta: U2FsdGVkX1+clBgD3AypQOp7pcbWLo2F8ag3O8U1BIU7FpD1x3A+/XdQGex/MBATgWG9rsREzOY+eSrvN2hSwfxAPm5029AL8NgRkMEqPn3Cslg8l5NN//Vn5yUTjmNFZYT2HLeyI00Gx+F1PMgqvuWZnb9o8K+ACWfRW09r3RG9YTZGBGw8ammtTnxLUau6qQ7cOVAj9BD4hoT9M+16K50wwCsbRsbWzdPOcWDnMd3/WaBpwWRj9weyviP8LYOTMDP1vrojtlrzQzyfljPhagxdvta/liyU6zfCHti4iV8Q4y3yFyP4HyCpfRWOdAnQjc3Ihf845dAt/aKaUIrCL99pYqLnDUpFd59HscxKVOyqq/94RBNizkGeD4713C+fG2qMAEEHFMRv0MueJBO22IHprYgCZF96DVXRFJSm5oMZkM5zMTCuc11O8qnSRe7Nl1eSUpXt5g7h1IiWu6pSxquoJCEKHjvFF8FeBrrm59364S9DEsXT4r4DtjrYJ/oDICbLPyHne/P2ptmRGuRXpXH/b5HynSiXmXQKk/C3bUP8MeqtzwW+CIlMsLOMgRogWGYffaFPDl7fRZgHi8oNvM1R3Tw3tM94Oy1dT+0EMbBZlyWu9RGSKlGvDM/RkPeP1wws33oJ/QiqxbkAlxJXFwzeIpZkmNnUl5aAywBTDSsibqp/g2NfWo5RMZJskWXeoAPHwkkRoF3uM+O+dVF9OxQcLf/NNk4UrRZoN19cvqQX5CJE5kX7qr7fbE1XW76FIgPke52dwCyPAReq1CMPORmgTLVMkCeq7OguuQkriPokVRfY/RLB3iXEZ2xbWPQRCZRVhHBQz6wJWpdJe+DP4nTI4PJ02/kKYrUF71V3jOlDVzYC0pnuChP884+WRSt9yz6vkEht3ZdidzW361hE6l/YJBoN8q57K+S+vV9aM+juXzkazkDq0GBB0RAEfNkuDtbKmgU3nlTJFp5nW7G
 s11dWFRr
 L9Lc/8WBYF7XirNTKWBNJ0/irARnX57mud7BPk09ng7XnbxRUvQKk1ZqYU+q/o8ITohqNLrPx1SBF7cMslbPaaNUW+D1Vf7/EDzJvToQTfKbfV6p6GHFu5uMuwaL516vthXwSwISsNAlNGjexIJyuqT3S4CZrc8pTllJoWrSGKioGG65MCbRxvp6UYMxQNnS92NLD4XEDok9kyDRGmrIl8v0qGR9+cnlC3cX7ppd3gc+sLfxxBzqNbr1JpIpmHCyypYVXGzYgGMgOG3jp65Aap3y8/Nhg49ZuT8kRkx0Nqtk2akU2GR7NCZV+q0CsWIj+Xs/5patmr0kuemoIpFoTK0Mo0f2lEfqPU4Yf5ycFFtOOQ/ncXG6+1LCOUAdCkTZvA0olDl5vwwQ4T2fIDVjslPLBrGU12tLmxkDgIXCCgb9NdzkTuLiWhKzJ+6pbk9jisTfkC0BpjPtMrKNWcjGRTdbKk0L0h6IEmDOCxmUax2WZOid4Rj7plF+P0KNvtkZxu3qlV/RycFOpjmR1ZVp2xMQcoAidXZnRg71a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap is virtualized, we no longer pre-allocate a slot on swapfile
for each zswap entry. Do not start the zswap shrinker if there is no
physical swap slots available.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index e8aa9201ea30..751687b7e2b9 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1214,6 +1214,14 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	/*
+	 * When swap is virtualized, we do not have any swap slots on swapfile
+	 * preallocated for zswap objects. If there is no slot available, we
+	 * cannot writeback and should just bail out here.
+	 */
+	if (!get_nr_swap_pages())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
-- 
2.52.0


