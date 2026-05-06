Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21BFFCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E9A6B0005; Wed,  6 May 2026 09:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8186B0093; Wed,  6 May 2026 09:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380A56B0095; Wed,  6 May 2026 09:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20C286B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:09:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C9AB88295
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:09:46 +0000 (UTC)
X-FDA: 84737027172.24.49826A8
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB7E140016
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:09:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mz1JqWbo;
	spf=pass (imf17.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778072984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pdnj5Hu7Nfyr/lCG0RPkxV3fpUJQoiKx5Aiz9/ExKM=;
	b=LdF+hjoZD9TGCXsF6r/o63NA7V8mRI2B95bqCcVGnNkwZEdJKa/NbwLl+tUV31Kkg1rrio
	+rM6APJu91/Lr2Pm7pDqAen6FFLPZWJWs6kK+hQh+duompKwavVd6mOZw9pwO8TtNO/ZJW
	oVPlaqtt3MHyaeirGW9nXqvDcD2phK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778072984; a=rsa-sha256;
	cv=none;
	b=zPuxgT22HYA7z0V2+zgUVn2blQWPK8Sb9hz0zdre33oYW70OagVr8bpyXDr+oUxhhhL3Kc
	Q1tBR2ux0130OQspYAXnCG4mn5+Yh+S8eG5bqRXfO4hnOu9hzcu7rOAdDmjn7y+d86z2Ym
	RIYPAEzbeqstI+MTeF9B9Vu/u4YbV9Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mz1JqWbo;
	spf=pass (imf17.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ba0fc8b1f0so22353945ad.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778072983; x=1778677783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pdnj5Hu7Nfyr/lCG0RPkxV3fpUJQoiKx5Aiz9/ExKM=;
        b=mz1JqWboW2rnIkihfJUoLppo8pICEjMrSs+iQYS3QAW2egddmo0YZkUaSQE27RJy/j
         Iwfe9URKQNneLJzRr9tiisQA2NH46nsICrbBA40PxEXwDO11iYdObjX9IN+O8rxr/Sh8
         IYwVrcHVbYQw9knMXNbpBVJ3wkCdCaC9zsxgEvnRkgk8duC2atFwhS+kWfNEj4NDQ/4M
         6yJFPMbCT3URw54sHlA6hkyGVUQ+BPegGk9z3QzfelI9XFT7rA9RH33zLDf+AS9Ira8x
         MJux1SOXnQsCvZdEyqwN6xF/Au6cytAadvWw4QCU6pvkIfELnjpifUT3U+q55Ri4Nq78
         TlzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778072983; x=1778677783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6pdnj5Hu7Nfyr/lCG0RPkxV3fpUJQoiKx5Aiz9/ExKM=;
        b=Iexn0Prkfux5LxClDL6eY2PIIlvdnEMNH2d8W9xiqnYsRGD4ULtiaF9eAapl9/6gsc
         ox7Olas2hXeVjnWaD3HEB22C0a1dU78//B6/QUxs9EhGcQSY6LM4Yl4MSer3tk8Jjgu2
         Lu5pvFdgsDaHyUYKvBBcF0qfS1xPMxz2+A4vFwuHneK4Ok93yVqT+jI3pAaaQi7UEAio
         L00ZW2r/zWtSSGZ47lrEr0TWykPXtFPoAPSqYg9C0bGdEruxa3movGJcgmKwbK1z9qlV
         1qhkDQ9Ww0EiJ2eLxwvKlrRs+mshdUwqSZ5SFk1ZqB9rVLS2cQc2YQek8LRJZ+ttBkUn
         Igvg==
X-Forwarded-Encrypted: i=1; AFNElJ9g3Iuv4wN2jZMhNjHKG3NObPth5QPMBHg3E/GcROU4aIiy3+1pgYzteOoP821JRS5VcuE6m4weGQ==@kvack.org
X-Gm-Message-State: AOJu0YzOFaYupr7h1Ch9183OwpVtdIElXTH3BYmOcy1h7+/7x9zVV+0P
	bZ5oee2v+GM047uPEH8LvCk1qai9TWcBp+vklkvSxe+87AXpanCXwv5nCLcSBsOL
X-Gm-Gg: AeBDieuMHb0GF+g/3kVERyq9qFNr3ug3rnX3Rq631v+FZDpIWFcOB5E52Y7rU0ihc9H
	77YY3p93pjRYI4R+zGdbtFuFJIUIA9O/lMZWOfCzoE9uviyNmQjTF3Ko222YE0tJYBr7gHykZ5A
	VJ8Q5B7EyGBnYnoM4OiZCvgL9TIh0kDdopQ60BEo7DVmhEa+7BHoMwA33STarujBnvsdZHqIUIr
	LKoc5eHKMfVL0COdHqeMOKu6wVrzi7ji7jVJoJ0Pz0+E1k5rTJQ3h+9RQDBBaunrwIp6KiBM7BV
	C4nUeZcz+siDQbZrqMrGnBbzPCRHUPT1nbIYnk5iPLJpbyVWxBiaJdQwvNTnz8TWzegLTiJHG1G
	cjMY9/wqPxnYK77JBaEFYr2Y1XjSj8HdB3OZReC8scLRF2JWJxQldQChx+PzQxMP2xzWC/7+sUf
	LlL9Nb+tBA4qvXMnVUgkKkdRbJTor5ZW58H8RUIsLGFuVAFUj87dzOr8jbBlv3AdZ7X6illA==
X-Received: by 2002:a17:903:1d2:b0:2b2:539b:d2b1 with SMTP id d9443c01a7336-2ba78f63e3fmr39659255ad.16.1778072983413;
        Wed, 06 May 2026 06:09:43 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba7bf2c4b5sm23780275ad.20.2026.05.06.06.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:09:42 -0700 (PDT)
From: Zijiang Huang <huangzjsmile@gmail.com>
X-Google-Original-From: Zijiang Huang <kerayhuang@tencent.com>
To: baoquan.he@linux.dev
Cc: albinwyang@tencent.com,
	bhe@redhat.com,
	flyingpeng@tencent.com,
	huangzjsmile@gmail.com,
	kasong@tencent.com,
	kerayhuang@tencent.com,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/swap: Add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Wed,  6 May 2026 21:09:19 +0800
Message-ID: <20260506130919.2298807-1-kerayhuang@tencent.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <afQTXPLbNrB3NOqe@MiWiFi-R3L-srv>
References: <afQTXPLbNrB3NOqe@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB7E140016
X-Stat-Signature: gqjh5u7mtwwtgnqrwmt3y4i6qhcsqn4h
X-Rspam-User: 
X-HE-Tag: 1778072984-561765
X-HE-Meta: U2FsdGVkX1/ZvH12z6hgm87uwrkfvzTG9O1KR043AdEDZ+pIgYkESvRQSbtcsv7YC5uqNVT/uXaR+HZnqVUwNfXSmGUhr1cj4NPbEHVH8rwuMfDrbR5uIjXsEKhsWpz0ueJja5TV+SBfKP+N8+NtR3rkzS98muoMYmkKL7HYehlWI1joJD/PhUnhbSDlq/7vpQ0HQiLgMlOVFJ1V25B/3IMI1P7UHp4dY8BpMX19dnx/2Z5xOD1TekkJQNjj5HP2jwolEEMVDQvCO05NsKn7SZoMbb+/FrUb8CduZqRRTbk2jg+pORpF+IkyXkCAdtJPXxbjjPxyquiPzMqmzSIW3qXXmq8m2i6AzP8teug296gHogIguh460EjGmzEHiSYOwJPV8soz67Pb5AwNqSv6RSVsH6iYnziqkLdZJ3M/1mWwkKylUo76fw1ZWXlNJsio2uqfy62rmDZyIQCdl1FVz6PrS/IySvU3KsjpTjZKtH+qAHWQmb6aQ1p0VKm/TU8x5l7Dt9Fm0C7sOzrM+if4NbbHXYJad2wzMGR6LlRi9L/48M9oDjIlbgB9a1rmytAXOg7/64ebEzdEqOuaqVPR5js9229KPFQoDnIlLADWlqypqKhXOXLsAVqLSpMLXJ316Yv/GwQZ0Hk/pmu72lPgznbzVyfMmU4IxCI0HJw7oVbOxfcEbrl8/le9vuOxoiiBbo3V5Iiw7K7Go81HXpYOmTtOiFV+go+I1BLnAsMZRy4XfzXb3GPSYsyz0GKtqEo/I/WslMzsI3EvVG/7HbJ8thTSgcsToHcEjzRIpvb65t3mOcEsgj9ZcDy5JQF2x3JvUSId6jcgScHySXQ6PbzKtaNm9rTuo2MoOTwd5UyZd8RwOgBV0e4AQdT0x9sioVmOpw4PrSGbg+d5ST8oWOjYDGE6tadBe9NmxRECLWrXufWkIQ4O07AbmXVN3bUgH8ArlCqdQv7LT60DeFv0K9+
 a4ugoNDL
 QX8sv3KHoGsmxQDL5Z/3uBrdm7Em1iWdxKDC+vZi7+5r1Me/gc0IzhCuwvBaa8Z6LYvV6ijSivU5TBtpjYiRc7zj7H/3pA8uLtXEF4MR70Ua2lrVhboqDK1hTt+9CGtWGOL8r5JFCu917tXGMnV739CfDfLXXaYnh5khC1oQ7aPb5FhDHjIoaFjyMvygbAnG29/4/loYqKUAnkhAcs3jYIpfiMDHg6eIV+t7pY9qCGMYP0YuRcoJblkSHyilRT4XQG32xWgBA7kPLKU6Ufxu3QGQNMyXjAv9yX090oyGWjje2mTS5GuSyiHlchpQVuZom2sXERPBHuuhywds3SE5xBSuOBYRaS6SXwL9tnJBW2Z2KDpeWKCb3BNSSSSQlZDAVxyyLdsx2KN/PJh2lEu0Fq8QQkGa6NzVQd2/+AOG760sAWbitA6CtvUyiRuZg39ru3l6A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We hit a real softlockup in an internal stress test environment.
The workload was LTP memory/swap stress on a large arm64 machine,
with 320 CPUs, about 1TB memory and an 8.6GB swap device.
The system was under heavy load and the swap device had a large
number of full clusters. The softlockup was triggered during
a stress test after about 3 days.

So, add periodic cond_resched() calls during large full_clusters
reclaim operations to prevent softlockup issues.

Detailed call trace as follow:

PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
   #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
   #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
   #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
   ...
  #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
  #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
  #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
  #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
  #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
  #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
  #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c

Fixes: 5168a68eb78f ("mm, swap: avoid over reclaim of full clusters")
Signed-off-by: Zijiang Huang <kerayhuang@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: albinwyang <albinwyang@tencent.com>
---
 mm/swapfile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..74a1e324449d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
+		cond_resched();
 	}
 }
 
-- 
2.43.5


