Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9BDC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23456B00BB; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDA46B00BE; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DDF6B00BC; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8604B6B00B9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DAAF4065D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:54 +0000 (UTC)
X-FDA: 85219111068.08.430940E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 69125160010
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=UtvmKs0iNiP/Hw/RMvQjQQ3XCJXJ3OVxPldLNkGF86I=;
	b=wnMPupNODVYnWiWexogTevpW4xKNNvSWn+UpTfyGllOn5AT+mSHMLrYYidHj6GlCjgfNGI
	18c2D5ZNiToPoMbWGvOtE3wFBonZ1KiFl8jAdC8V/kNyOchnWct5i1+px1yKBBuecvm6jU
	TWI0Q/U4sBsYe7235fRRdUQWSK5PFQQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551172;
	b=UMMgPkTVWrjdfYF/eELpvbOU+bHRjGuvDHlOWUQ+GvFqnskYEJrtIcJ0/HYaKgZgpivDQv
	Oz8OrQTTaxlWx4+qFvwMuEM0OdM9HKUEMcXf0kjrf72kkQh2OXePyV54p/7Bywu+51Cu8W
	P7tUbtY+wT2RT7DB50I4p/y8xJr9hO0=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hlDFP5syvzYQv0K
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8511A40577
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVikvYqpq8i0GAg--.65015S4;
	Wed, 16 Sep 2026 17:32:46 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 0/3] mm/truncate: fix data loss when truncating straddling large folios
Date: Wed, 16 Sep 2026 17:24:47 +0800
Message-ID: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVikvYqpq8i0GAg--.65015S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zry3GFW3XFyrKry8ArW8JFb_yoW8uw17pF
	WfG3y5Jrn5G3yxCws3Ca15Wr15tayxJF17Ca4fJwn2kFWYyr1j9r4Iqa1ru3yUAr92gry0
	yw17KFs8ua4DA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRl_MsUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Stat-Signature: ef6ws39sp377g7kiat4mzphiewhuq5m6
X-Rspamd-Queue-Id: 69125160010
X-Rspamd-Server: rspam07
X-HE-Tag: 1789551170-957666
X-HE-Meta: U2FsdGVkX19222iOZwcMy5d35S36FLconrp3c7szn7uG4BdNfQ4tbPL1KRmWed54YfSXMY6gHHaIY549Xg+GcPd13586VR42NhtuSn0MMZVWfGbDqhfL46OxGEgeQJIH2Klb4lwWlaH7G4vUTGpi4qwBojpCdQfTMkTob0ART089U4WUeB7PNo/ImbyMemdyM84Ny4sPQiEFrKE5Q8JMn9UHDdCmJcDjz7YG9+2fPA+c0rS7/OqY8RMuQmprJcjl2QNGW269VL1scOApsHXwZ6j7my459v8PejCqR/hzIfgX+0/72EHkCewZZBp1ATLakWULPcGJMaCOB8RhxeZYTxF0Izp7sve9/uJyYBHx4jDt8oUVgkThkOWqlzi0dOygSyg/SdfqSJCBwv2g0GYMuVQp292ThQrMmpz39Cn6ZZeeSXp7zIY6+VzaZ7oqbAh/m/9eZK/NI5UDq+mz3hWdI/fWZOajEv69bu6VGRs4Yok8CQJACaqwimvDU6+qKFyDzgt9mktBrOA96IZeQWN/mxwHKTozqI7jyrEm2aV1jVKsJ8mV8KsHAvCr8rxSF4x8Wv5qrZ3zGOKwdgtZ8LSv081T/lbaZcUw4Av4vngEUs1be5mIHEG8SBkNhV5wpBltPG5oU2tOJnXemlgnj049IVLiyx3UV4wkQOK7Wn+PfL7QDmHNlTt7AxMpGBMHWNhpktMqLkKIOXXWKPtKMVuE65VFgTIATYMsIE36zXsUEbe6vnqYTtKEWMm7Xs9zlwR1RNBv5HFixk7YQMSYPsotECX1Svii2EluQDiEW+laDOqNqMyw/3+FeXR2ty+ngDsrxkHQhV2NY8NCEeYqOvR0qPQ06Z+wXipLiTKi4T8KnpHXGuR1cQFzwS9fKzt1hCbNnAV9zsR80AIQUp5JpxyoCMxh+9uK4gZd4axK0D1qQI04v88OE1iRBEVyJ/F7NYEbSUVhgABiRmuA1DXPD4z
 JWiZtJAj
 nKLnQwtgyUSK3w2syOdAkm5Wqj4Ln19wwL0NOvlCBR3jUaVTX2zlvIi0VayoGzjd6Si8vjQ5nbnhrhMEjBKRELUKW7TWNlpK4d/1/6MbuTTMokFE8W1ZK3dBg8FGDj5sVayGhOQVWVU0jELA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

Hello,

This is the third version fixing data loss when truncating straddling
large folios caught on the upcomming ext4 + iomap buffered I/O
conversion[1]. I've clarify the split logic as Joanne and Brian
suggested, also slove the concurrent issue pointed out by sashiko and
split the patch into 3 small ones as Zi Yan suggested.

Patch 1: Add pstart and pend parameters to
         truncate_inode_partial_folio() and fix the data loss issue when
         the second splitting straddling large folios fails.
Patch 2: Fix the similar data loss issue also could encountered on the
         filesystem with min_order > 0.
Patch 3: Clarify the existing confusing return value of
         truncate_inode_partial_folio().

Thanks,
Yi.

[1] https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/

v2->v3:
 - Rework the folio2 validity check logic to fix the invalid
   folio->index issue. (sashiko)
 - Clarify the pstart and pend setting logic and the corresponding
   comments to make it more readable. (Brian, Joanne)
 - Split the patch into 3 small patches. (Zi Yan)
v1->v2:
 - Export pstart as a new parameter so that the generic and shmem
   truncate paths don't need to recompute the start value from the
   return value. (Brian)
 - When min_order is nonzero, align [pstart, pend] to the inner
   boundaries of the folio to ensure they do not point into the middle
   of a large folio, which could otherwise cause valid data within the
   folio to be incorrectly cleared. (Joanne)

v2: https://lore.kernel.org/linux-mm/20260909062339.473816-1-yi.zhang@huaweicloud.com/
v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/


Zhang Yi (3):
  mm/truncate: fix data loss when splitting straddling large folios
    fails
  mm/truncate: align truncation boundaries to mapping minimum folio
    order
  mm/truncate: clarify return value of truncate_inode_partial_folio()

 mm/internal.h |   4 +-
 mm/shmem.c    |  13 +++----
 mm/truncate.c | 105 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 79 insertions(+), 43 deletions(-)

-- 
2.52.0


