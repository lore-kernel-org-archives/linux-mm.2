Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4633FCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B595A6B009D; Tue, 12 May 2026 12:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A776B00A0; Tue, 12 May 2026 12:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A203D6B00A1; Tue, 12 May 2026 12:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9228D6B00A0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:27:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BC69120517
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:27:06 +0000 (UTC)
X-FDA: 84759297252.07.1A72FFA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22E9910001D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:27:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf14.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778603224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXuUtB3CCXhL8r1+lAD105SNTsTgZT7Ex3o2hArVMWY=;
	b=K5IRcdF9AdYgGy7sMT3Xfsif3Isw6kmNOwJtjQ94McKR3+MAPO1rk7coHy6vs0/+dASASp
	EStTqkOYxmaBw7bNymJ81CmMLmcVOJErreahTiUhtqwmnQW/Z2C5juk0RqHLQ3aFIC+ikH
	gj8RJ2iIOwasjK8QDNqaROHxZnf2xZ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf14.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778603224; a=rsa-sha256;
	cv=none;
	b=0PI5z6TXm3CyjFsisOjIit2HmbKLCP9jUND0gV51unevenSzi7XBn+KnYDs5tCavnyTON3
	ga+Oq4AvseYFjwvQXIsbjd+8qrq76Yywnc4Uq1EZMVMIXsKD19RN+w9OYbRrGymw9ZE+b8
	pSzcwTvNPUY8jrIegEEm5Nim37Lv0Nk=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gFMRx3mj1zHnGdH;
	Wed, 13 May 2026 00:26:53 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id A5D4E4058E;
	Wed, 13 May 2026 00:27:01 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 19:27:01 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: <1234567weewee457@gmail.com>
CC: <fedorov.nikita@h-partners.com>, <stepanov.anatoly@huawei.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
	<virtualization@lists.linux.dev>
Subject: [PATCH v3] locking/hqlock_core: restore missing call in contention detection logic
Date: Wed, 13 May 2026 00:25:03 +0800
Message-ID: <20260512162503.1843025-2-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512162503.1843025-1-fedorov.nikita@h-partners.com>
References: <20260512144908.610907-1-1234567weewee457@gmail.com>
 <20260512162503.1843025-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22E9910001D
X-Stat-Signature: 8wz67zdt1zappcz9779beoktbn4jiugz
X-HE-Tag: 1778603223-302874
X-HE-Meta: U2FsdGVkX19ibN/rYE7cc86vm1vlZoe+/7xgVT0kfv7x+3mQ+9fdqxq4gSCGaB+O79IKsMX4l9duJPRwIVnnk+a31o7YYFdklNJVWFh6skYvRrQJi7lV6twXIqmg9gK4qwxv8KfoUxrBJ2+Tf+NbbfNK93gQhrwMo4GM0R5RZv/4Nbob6hnoSMpKzd88qnt0wS1qAoihyJlHNXT88JFx/iMS4iXpZrJ5E2bWCqleaY6wZwEm3S99AC0HM6y1lJR11pJQ2oEasAEVcATfLDreZN13G0LV0kFKv4jskUTAljEKK6bjoR8NFpYF1/Zc9eps87orjA1VZYth6ZGiR7Qbltw7YAJvwIohGG6ht67ikWIP5yz8e8tfDcB+oe8oOESUttOeZ82zAQL4YjY9wgmES0zeS/B6gBbD1LL259PD+U9RYB8bVoT7tST+X5xwvnnFECPZq+jxT9tEW/T29faqpUs+JgIxSGYedL0VLYH6DREoJjP7H/4DkgrKWwDkHTyRcuHnUIG3+A8p5+SwVl5POwAx8g/kQeSc4ajQAshQc+Z7qRJbDEiz4PjuGk8AG3HA5kUy70aAYU1LGPjjhlnJikaZyj2fiNa9VzUjWiJqkCyiLi+n4zMTDE4GR7kVu9vQ5S96zRgNKEKZDJpmWTXpedSAvK9TpZUpWX43yjxh3DyiDEg3z8LQR20q+Jm/NMpBghj42dbTdS1m/Sg+dygS51GwZd3gsdZTMVRkx7o0Jm+cUvQGneW2msnLdi7ytg4wKHDZ8HpAHGyo+MuZ99Jaabc4m/Hv/N2CJ0AiflUqt2sDo8AVuEFgAQmECPOuMGN7+8ZYHajrjyZC9lIskhDBvHqvBOVCKTTEpQZh181Fu4LkTFuMOEc5319/1Jw5q8qR2a0XKgsiQ3fpO/jHrYf4Js87xksRbXExoT0Jk+9CJSnuSOPLOAWTg33R6If6FF38zMTrLh+fqEIl209y1IL
 qcsnSA11
 Z3EIZicHkMS/whFWuE94/Eowpw9Kndnmsc/l4adm+df8RRJyvlYAlIze1V9shux4qIuaSfgNxpy4j0n0++GKqIFi//AxSiQLWKfgNX6U5GpkfijQDSoyjOe82QZiRXRaBgpGjfvFKr0Mj2TmVQ9WuUL2bD90ijhGWr92dygTwQtRz2G6jidDbRK0PQbsfaqmi1esrfH9FpDZi4VIWEKsBSCW7je/zIpXffpeiOXUTZJdCov9H1/6yJK4SGPvjyfs2ycm3Gqu2tEfs1t6ixhHXrW6yVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A call was accidentally dropped while splitting the hqspinlock patch series.
It did not break the system functionality,
but caused the lock to stay in QSPINLOCK mode.

Restore the missing call.

Sorry for missing this in the previous posting. I rechecked the whole path after fixing.

Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
---
 kernel/locking/hqlock_core.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/hqlock_core.h b/kernel/locking/hqlock_core.h
index 74f92ac3d8ad..226a0bb9a667 100644
--- a/kernel/locking/hqlock_core.h
+++ b/kernel/locking/hqlock_core.h
@@ -580,6 +580,8 @@ static inline void hqlock_clear_tail_handoff(struct qspinlock *lock, u32 val,
 
 		hqlock_handoff(lock, node, next, tail, handoff_info);
 	} else {
+		update_counters_qspinlock(qnode);
+
 		if ((val & _Q_TAIL_MASK) == tail) {
 			if (low_contention_try_clear_tail(lock, val, node))
 				return;
-- 
2.34.1


