Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EBFCAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 07:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9AB8E0002; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B892C8E0001; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F698E0002; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 953A38E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47AC7C01C7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:32:39 +0000 (UTC)
X-FDA: 83926955238.04.9765115
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A0B220009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:32:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nGlhSU7U;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758785557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yQVwO6hUbDs4yUnm9nVZ1yfHrPmI7sVRMQiWliYRxhs=;
	b=EB6CNI8DowV7OOUpo8sAs4FKpkOq3ccI60geo7l4SRJ2IuQNUfa1caimE0JztcjKsSGV1V
	7GLQnWDCUDxUSd7PI/9o3Zf7kMzcIB5ijljr+b9FU3uUolwJN3ova56cUYjzP56IyId8YL
	j/0tD3h75NynJesGTowEVcblZehOYwI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nGlhSU7U;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758785557; a=rsa-sha256;
	cv=none;
	b=VeeD+snqFBgKLfLRp134hCi92p4ZzG8nH1GvWuCFroCc/4X7PuC0+JKFDuM66vomtupdo7
	rKuoqxqxnhIgIOzzC7eJTcQs/ctjFt1f3jUBmoLEyUsy36hsDU1rZNF6qBiRUAAuzJ/gdr
	hPL1aoIh6IO4j+IuUVIukJ06YtK9I14=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758785552; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=yQVwO6hUbDs4yUnm9nVZ1yfHrPmI7sVRMQiWliYRxhs=;
	b=nGlhSU7UNpY7AMIJJjbT63ilyu9tAyM+KlOmO7NSEvUGYaDm6b/jnTwU5WUhCJ6Ni6vQtxsgg99HB/lk7H+CuC9cySADH3584PeyvaMMYT+hlpVByGkwP8iQg6XCJGNIZ7iRqI8CuK2JOWueO/QK8DjetEeYny0525kDd7+Upxc=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WomvkLG_1758785549 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Sep 2025 15:32:30 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] optimize the logic for handling dirty file folios during reclaim
Date: Thu, 25 Sep 2025 15:32:10 +0800
Message-ID: <cover.1758785194.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A0B220009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xsg8pndjrmffpya6bqbgdpt7yud3toyq
X-HE-Tag: 1758785556-142859
X-HE-Meta: U2FsdGVkX19cqxgYJ/P0HBl4oMk4rh4gnEcT/rL5lv16Unss84iCbgK+5u9PPLldkT7ouP2GwyYs5XEhy0BCRK8eqB1F+74cDdcJi5rYECgx9UoggRSVsAgA39GmH0FYrdCiVPG4UrOJ1Q5r+WWOSdS7lNi5IqHom2R6il105WIu2sFfksUKH7nffKuSJvtLBCYK/WUjLyDwDJCEeZs8bDmJWTyrRRxzPLQ7RUxo54Mr2RPE8EC7a5J6LMZCA5oMewYwNlmD6QEn8XQhf7okXLWj6yDvqCAR8sOOt4E+mkG1vCATQ8gnTuQsQiv3uO7uDJ1ppkalIKGsW5WKowL+jUN91BSdT0lDOq6VyqiLvEAYljaXmXX5P2piulSFjGgTolQhwZsHALkw0V88U4FA6S3dgA90lr7HUdoq6P3chDxpeXTpyBClgd/XPKuqkA99QaOCLA74gzWE5bOSk7QYM1UcNQ/xDX1PLn/3Ga5ZZmLvT6En1pSEqzD9dEqMpBO6LkVCTpqCgV1HAsd373MAUxz1zLCY9QiLzIRn57q2NEuMSPuPEMLpmOv9wCiWF/ENfw8aGdJsdlqKAwJJGgxPxdYeyOFblFTQIBYqG0Z/2X+6Xk+ocsS6aPgaoM1tgEzedm9efJlyShhg6zyvU9N+YPYxjfFqKGsjM8qGpMzxSUYd0x59Dec77Qi/zMfgnPc03y/tXMEVx4zmuCHTDMu1f+uHArKRaF+DIN9EZSfMJBHrMfWrSZvphl2APIGP7IF2Ekuy6yg39QUbIJsqss8oYNZ9OPoAnt9xKQxgcHWj3CpJjpwYX6HwHIHoNFLsl79HDR7a+eczlc08kwR7+ZYPVVR93IQNLZvOfhV1Wnnx+0ryGmXWdsjbfyccy4shp1Ct5fsvxqq4kN75Z5xI/8bb+CgwB6grm4WQmXjfZZpcP9Kww41PbMEF8G4YQosRQ2nuwklxsufAeY8qK9g+e1m
 75QbBC7/
 FoGAqy3livO7YzU7s/7a4otKf9wtyRQixmdGcmqOlliTv4CSN8RcWH3hJcWI4vGrioRU6CZWuryEhOmlHn3p3g4OpoPsukXkZOSMtX8OL4Pi67EnlcZiCzkAlD1n4TNOJ47uKVbIu92gU0DbZCZe/+6shFH8eY4z6C59nU8TCZbsEKu7a4zAo1B6zbxNBXCIVsUfPkbLT1lbTC9ouwBF33SCDtxSxskEaxsN+63Kz6IJuWD1+dr2cZoNI2ZICDv7H/3KTmUlkQ5c98dJx82pRIe15lSQ0QlOkqJ1i2RN8O00t2KSYm5R/IdCVdy7y/NKy70Og
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we no longer attempt to write back filesystem folios during reclaim,
some logic for handling dirty file folios in the reclaim process also needs
to be updated. Please check the details in each patch.

Baolin Wang (2):
  mm: vmscan: filter out the dirty file folios for node_reclaim()
  mm: vmscan: simplify the logic for activating dirty file folios

 include/linux/mmzone.h |  4 ----
 mm/vmscan.c            | 33 ++++++++-------------------------
 2 files changed, 8 insertions(+), 29 deletions(-)

-- 
2.43.7


