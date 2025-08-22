Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57D1CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 05:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5BB28000F; Fri, 22 Aug 2025 01:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286278E0056; Fri, 22 Aug 2025 01:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C26628000F; Fri, 22 Aug 2025 01:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C85D8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:59:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75233138E08
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:59:29 +0000 (UTC)
X-FDA: 83803341258.23.BAF8CCD
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1147120008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:59:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d2WqELDZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aha310510@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755842367; a=rsa-sha256;
	cv=none;
	b=3gdASqaXGwrwHnRI6vK/l0rUAYkn830hPDuwJTw3coY5y28SfKI3XSOrjTo+lI1PyW6FeG
	Wxo9JVVdJ823ytkm5XkK9I61xuK4q6H3ztgNxbLgqpNo0SX1oaapg6OTWVwC6KLoKEO4mE
	rfyzRCxvJs1S+DkkXtACThLLok0fJuA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d2WqELDZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aha310510@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755842367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/0/YH7tpqD6R0a1Qoz2f15khTHHnT14HYSHBnDr+ltc=;
	b=ZfBTx6NCtfGNA8tjqv5NScwmSd48gAXETYxlVOm7G9+6wlxXFbCCN/ZDnJl8HdNEdcXwWu
	JbvnFmCE77803b/LhZYFJdpWViCZTbdZQ2uFW5HBDBdKGsgIUqoNvYxTYweldDtVNq/rti
	eG1suqelwZ/YphmHL3cEQhU3wBlmAJA=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e93370ab8so1860354b3a.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755842366; x=1756447166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/0/YH7tpqD6R0a1Qoz2f15khTHHnT14HYSHBnDr+ltc=;
        b=d2WqELDZ03HUvsggRJ6leoGj6oRMf9GilVvuGqscnRunR+5rq6eS35Vp/NszWaO+kY
         jvNJ+0+SmLlXiYLvMHZNUtGfmfyOjxY5mnyzmkFrailhavxkP0BqoTJlWiXbR3m4uL+5
         iWfH3jvlNuRp0DJR0iolRJbfXIxnHV+CUHbhiT4eh7SZd/bwXclyoHeWUyWdVojvxhiB
         MK7BiJjoGRkTai86C5X1vuDdVgHgX77IZZx6/wgPsGu5EbXQr7uLtDKmEe6WDo6o+uWn
         p26AjAyezJiNrttni39dC8fBHwNgSw082sFv8nhG4LXeW+T4D0K78c5vWG0+Yd4TI5gF
         t75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755842366; x=1756447166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/0/YH7tpqD6R0a1Qoz2f15khTHHnT14HYSHBnDr+ltc=;
        b=g9MSJEdWu3GiJYlRaVLwzs0kvg+imv/a/Gbe76IMHZoWQMGpZvmnn4J4fk1LRMjatZ
         zQQyz+LQbXPN+r8o3Ubkc1p5DfrgA8F06Q/oSQwHy9K+sw4/n5XK1lrPSGDcWqBcR6gZ
         0bKuZpmG5YzJ5yOz+BUsHw5sv2f4oMwjyN5mTBQVmVTF7/Eyl4YCfzkaMIjC9UANPb9g
         epU9WhjFaGHd5iaboAxsPjoojyATMSqcf1ZCqJMJLLwOqiPscldT+k3Et9vApjCamVhT
         4Hq6LuFuY+TmrMQrk/KYJDYg5VVPu8qDhdQTz/S0xVE30nx4CTf58WVxicBEAFgv1a6H
         Y5Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXwRbOPK5QoXe83oWqXEfEyNEY38APAkzfsYfQYPNVSmhKHt8hGjVFxGQo7yYD2CcZ35/deTe3Zcw==@kvack.org
X-Gm-Message-State: AOJu0Yz6SH96o4sLptjUH3oieoOdCz86EZxlHC8yJb9E2v9D4PZljfg3
	oSFryBhoOYU4uG8rRloSfBzS1cdUY6m0cefj4WzwBdgSVTt/Phf3fVMh
X-Gm-Gg: ASbGncuv8hF4Esn38OV9ewUsf+QWK7WicpYX1/iKpqUxuWqJGcx+LqbDuxPvjf0mntQ
	T4jB2pYs5NgzKT39Rn+Vw5buIPj1NWvAVa+EJxrr7jLSlIXcX4q19bs7SXhmeUHQIJmUN+Wptoz
	jXhZroyvJKUYnBBrYsaiQQ0V8gZMtD9Z1sc9iQLMBxaT51oeFO6YhkYzy/yOopE6KiWDUpoIYVb
	gZpeyJyXI5+zEnuB8bg8WpvYWdBimFTqYPlCW+cL+71jcWvURvcirVBAL6/kp6v8b3O9OBg/Qr0
	5D8mRrSOJdBWQ40qhYaVKkypfxORAFPu4b22GLkglcwl64wI3+OCwmMCHIrOnkM8s2S92MyLtny
	OVACbKjeASfDdI/hps2awRschEFqD0u2EQnYHeFTFeDjxdnoKwA==
X-Google-Smtp-Source: AGHT+IHu9AgiKmSd6Ip9ikRTzrXIGUl52NPjCcqZHHIbtsA0QL36We+giK2O+7PzugyFlXTU3i/w3w==
X-Received: by 2002:a05:6a20:3948:b0:240:16af:401a with SMTP id adf61e73a8af0-24340cd32b2mr2634360637.32.1755842366455;
        Thu, 21 Aug 2025 22:59:26 -0700 (PDT)
Received: from name2965-Precision-7820-Tower.. ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d4f7cf7sm9891448b3a.69.2025.08.21.22.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 22:59:26 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH] mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
Date: Fri, 22 Aug 2025 14:58:57 +0900
Message-Id: <20250822055857.1142454-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B1147120008
X-Stat-Signature: sdjqwkg4wkrj81truku6mwozziu1ct8n
X-HE-Tag: 1755842367-568395
X-HE-Meta: U2FsdGVkX1/tVrQUZ1/TTmGGtAp6CKBef4oSLxTHmNV/2H2dc4gPbsDcIwzEgFFSGcUmR283jTfG7B5fgT3gvc+uzBuXMvrVUI+0fwlKAUmX4pS0nDr1w4F1usdTx9eQP2PUFUI3IAYhJ3IDJsjxdHebrDSEI0MWIbEQ3WxqFF+IJ6/9EckqO75ifbtKhTccYqhcMzGlz1zpZqy2aVMeubzlLsZPHJFGRRS8hx2qy41rFFAHJodVOuk/Qa8S6hvoyEDQ/uvyQVAnRxZMh60VNi7KtjSubIwD48KypoH6/r7GjJBy0VCKzje/AHz9r2RUQWudqg6OX+cfPwYDB9BGkn/5FwAYLK54kiHB6HyrPRKCiknZIG+rZGeEWjJzIkLuNV8KUhgegDf/xH+OLouJdFFMKCNpJgmScxY4KmEFBnwEwaVNyXR7a4/gbIOfBNYnHnBJTaT4cuehnl3MuINS+8MbI1ZGNn+0mPouXVT1hDYjdZvrloJOrC/NL2yyHVuebkdfCn7F8BzcViR+LdL4e7dewVPmbc/vNcHeZOoP6om5K5sICXcc2RZCMJufAc3ENsJCBCiYMxkIqJG4R5PeQp4aI/xVYATQNXC4e3H40iIWbmRbfM0eIE/zbSNRlQXdTixBQM6EXVAzDdw6xSD4IGbqLWtb9yUSJ56otUJ9fDPuQYExVcYnNHt5TLBfJs0bBACQ4QOW7Rc4O54nri79C2t+08gyInxJnPDAq8hs39xcPiUV0ikO29GKIQ30YJ1zO9sfkXXGu4VXfM8yUksjca+WpyJpDyXmIK56c/caUqQiiBz+kQkS8lyR1Cu+EYcKV4OEJ7X/gmjfhSM+R1sjCI/H/y/OLOffPyCOOUoYhDrcQ4itSDWD/ktXwJ2wx2zV0LIpIQuPWHBSY+h//ry41TPad5Ur1jQpEbHnTz0fH5KILxnrk/DjF7WtoM/SSs8OJYnvWKod/RaAwVj2NBH
 4ePIlYr3
 VhRCmAwRALpldTxo129rLFUNLPQVUFrxAA6gcOL5YCX37t3dTc6+Nt8wBFVclIU7PuBZE9NuhNuFLQ+pYI386xJpk2ZgpU3IUi04rpIPSTh4v7JwiHlISu0fJCJy1utN15SDogdJz7OlHmcFcsIF4ghzrCx2NQsSGNAtQbJNLwU0Uw/8/FNUOw4S3DGYi4wmRqjxikwYyC0Z9xCOxcGOyaLmnHrEDc0/1LzXtsKeJ0ud0YJagvqHBwwEM4mrRZZQnhl73nh5WZwLNICpQoFj/sCjrjT6TxEcssp1BtuK4mi3LNN1337HEHYkMpQedyE2HWbldHuhLrgVKZz37kN4TYAEYidvQ4awPAq1BXbmNL35i8QDEJaVoue4yVUh/ShuQRiYRCZZPFGCyKUyAujMu/UgZ+YPVYNWWDfm2SOhAuE6b2sCdEGlrq16flG5JpEZymgiLVgNEwUFy5Tu3SCWLSAu/ApROCDfoNq5hSlxNzdC6zJ7Ox7I0SwhsSlamW/cAjd/+so5nDSscARtnaY7j1p25w4mcQpp/H/qx4/F4F72wyqOBKu7l+BSlu1zxy03iHJXJ1bAACXqGRIbKZsXE/aUS2CjKGJft/Yt7sL/qZQzSHiK5C6yP7kjAFp2JbDsO1LkOhgvdn9XniKpGZikAI0ZC+0IPnDOE3Bf8Kp62TSxi4c0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When restoring a reservation for an anonymous page, we need to check to
freeing a surplus. However, __unmap_hugepage_range() causes data race
because it reads h->surplus_huge_pages without the protection of
hugetlb_lock.

Therefore, we need to add missing hugetlb_lock.

Reported-by: syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=417aeb05fd190f3a6da9
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 mm/hugetlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..e8d95a314df2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5951,6 +5951,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
+		spin_lock_irq(&hugetlb_lock);
+
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
 		    folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
@@ -5958,6 +5960,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			adjust_reservation = true;
 		}
 
+		spin_unlock_irq(&hugetlb_lock);
 		spin_unlock(ptl);
 
 		/*
--

