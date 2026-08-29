Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A95BC61DD7
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF556B008A; Sat, 29 Aug 2026 03:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F446B008C; Sat, 29 Aug 2026 03:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DC66B0092; Sat, 29 Aug 2026 03:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15A506B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:42:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A21E4068D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:42:18 +0000 (UTC)
X-FDA: 85153513956.13.FC54D16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id F159C20004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:42:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZGnCJk1u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DUmBwzRISwqZ5Rg6ptgDhg+OBbGHowA1pcDsVBKPQN8=;
	b=ZWFJCy+varPfcp1hLmOOHXVhjRfe596de1XYWB7I427NgjmeuDy6fplA8FQ0MJ/ZOhqXFv
	5gWPvAmsG6rXy71dHl8AfgCeOq0ThtczC57L2Z+HxMpkry8UuwumD9K6xTTJDYKfmAb1tQ
	cGYXER9fXQajwHgiOHNB5yapov1DTrI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZGnCJk1u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989337;
	b=GBI9Khrvy1xn6VYgQ9KWySusRt6Pubnl0VnZoxvorgdoW9aQgzAiKtRQC/npxHugacw6Ze
	TQm2qDc3MZ+BkcuX2AJOpGya0NIREk9u7VTIe5HFoNn0T07lmncDxd6toNHvoae7Ts6LVh
	G4gTR8k1q4lRVaFjzc1di07yujREKCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5698C43FA0;
	Sat, 29 Aug 2026 07:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17B71F000E9;
	Sat, 29 Aug 2026 07:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787989335;
	bh=DUmBwzRISwqZ5Rg6ptgDhg+OBbGHowA1pcDsVBKPQN8=;
	h=From:To:Cc:Subject:Date;
	b=ZGnCJk1uq36JecqZEMc1G4T5znWg/8/9HBjU2rywXy9kz+ORqzwgI5JGijLFds+Ue
	 QK9bTTo33n3N6/iBWBhiXyHkg6WRZ3vqCDahxUgraUp9ieP+rIeXP8TtU3xr3BL9bq
	 VNAarmVH/a2v1yzOLZZ2295719l+n4xVHIIjnZgb7Aj/HQCJn9oxULymVxb80Pk94k
	 N1H8Szl2iX6q5u4eKAkdVLV+jE2vUw1feGhE0JNF2K03Q5ILB513+ep5nanDr9VwJp
	 ADP1KCNKF/Lg7CUPLfo1uIfbD4mUORCnYKSaxobnZbCk2PsiLtkDuDSsJDjVhZ4kwo
	 jZc8+rba/V09A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 0/2] mm/mglru: clean up isolate_folios for readability and clarity
Date: Sat, 29 Aug 2026 15:42:02 +0800
Message-Id: <20260829074204.45304-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f1nur9fi3qr5eay7cn9qrw44j7upijeo
X-Rspamd-Queue-Id: F159C20004
X-HE-Tag: 1787989336-816142
X-HE-Meta: U2FsdGVkX19tFshGq0MkjwebkI6DcZB35KS5sVG/ne9GpidvMqkZ+1oN+S14lxJhkU42BrZ22Dlo0tJkbn+cR9b82yjqKZr50TBw9V6snpmBTzcH3kkyIqV2+I9O/zAOGcI2zmsOFfe2BINbK2c2fHEZi/QlMqCgcbex4ygpmGIuPyPWKP7RSgpCAWRzYUAZGRTHG0L7znFEtfDYRv8qtMT3zI+VXvedmaWib3YmSNFD6RzUefK2XXqk9X6nm6j/DVMXJ7EJAoVDl2sDJVEiDd0GLOLQOe9ihws3jmp08iBcVfaJaPms6cGjWhpz847K7KM0nlINPB1oxfQ2aSp+aAEOzNFD4BG2ZvNPhTyESRLPbuC8Y4UIW8XIhzt8v3vWyA5v1cKm8naKGs5v4SNbE+5qLMnaHu0bQdkJNTvLRyr/D3hFAdopkEZvhzPoGykIobZ9PZh53JwdgIlpuiOcYkaAMRUS8Zk1t5hp2zS28JeDRLrMD30VY9IToUsrnjyZ72jY+iygiX1lxAn1rtAbOMREkA4uFHW8NT7+k4tYftngMIB0yPyLtvmVJTsa1UZnG/DxofEMhmJb6yqEgc8Pb+AIKphfhKbAuSz5iikHeIro3Zc6YJQ+EW4tQ1lHW3r0kUkmqSisnL3BPEtfh0Qa/fOXPFvDb1sUdw8tq0EINUof1nWPYqli4URC3g+LRxyGIYzP/awstsT/KaU6BXFqCwJBwqQtKfx71YQudOva94aKNJLnprYY9gje0ipJXvvI+DFSZqpCevHaIOqTNAkquOCJrDI2MQq6DsOmEO3gbt1JQ1tOXDnuK1CEcez5HWejOWbsW6y2tW9bL3vfOXeAME2OJeTaDxr1sGJO6YgCRwZIDidMbbRxUkFhrDQQyUvSPYFM3qvhWbkB+q6Rvgm8q4zpQSnYAlFSBc/jg1dxL5VyMw4C+t3sLLMqXYRIqc/D+2+X98VpOWMemm3Y3q6
 AaTrYDW9
 knn29t7gEjNBCY6e1AO7Adia8UZ7OLPcaKNIC1tQCSLe+oJKTSenQh3insPw5I8QRbEvxd/RfOoIK/eMF0afSd2ibqoPqE4GadmflKvqIK1xE18GxRnMh3m939XFBAZNT97fyFn2PtDp6uJ+Adtb46bmwnP4yQi3oePrMBBLSEDq2QIURu9y2b6eLo8osUv/ZQu7DelV2rC52S1QQKwYVAOdG2NwWu2h1IvFGNdm7ZyNw5CiwiFmAZd5ySc2vZwIOghrNG7ue8yMwBjoqzg3IK4D+85CLJf8iZHn2EycRHw+zxtu/bzLkqLUe/9Edr8hABJVoXiuOa60FVLuTScLQv1dA8jIf/oi/ceDkw/5scTrcL2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now, `isolate_folios()` is quite difficult to follow:

1. It uses `for_each_evictable_type(i, swappiness)` to iterate over
   the types, but `i` is not actually used as the type within the
   loop body.

2. It retries the same type when folios were scanned but none could
   be isolated, but the retry is implemented in a rather subtle way
   that is difficult to understand.

This patchset makes both behaviors explicit and much easier to follow.

There are no functional changes for swappiness values from 1 to 200.
There is a slight functional change for 0 and 201: with the existing
code, there is no chance to retry for these values because
`for_each_evictable_type()` only iterates once. After this patch, 0 and
201 have behavior that is more consistent with the 1-200 range.

-v2:
* Rename patch 1, to address Baoquan's comments;
* Drop patches 2/3. Patch 2 seems to improve the zRAM case
  but negatively affect the SSD/NVMe case, according to Baolin
  and Kairui. Drop it to keep the patchset focused on readability.
* We received many tags from Baolin, Kairui, Ridong, and Lian.
  Since patch 1/3 and 3/3 were renamed and patches 2/3 were dropped,
  I did not carry the tags forward. Many thanks for the reviews,
  and hopefully you can re-review this version.
-v1:
  https://lore.kernel.org/linux-mm/20260820045603.68809-1-baohua@kernel.org/

Barry Song (Xiaomi) (1):
  mm/mglru: make retry logic explicit in isolate_folios()

Ridong Chen (1):
  mm/mglru: make type fallback logic explicit in isolate_folios()

 mm/vmscan.c | 56 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 20 deletions(-)

-- 
2.34.1


