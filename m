Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93615F41992
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8CB6B0095; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78596B0093; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9432D6B0092; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88A4A6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39C395875E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:47:02 +0000 (UTC)
X-FDA: 84660613884.07.D362691
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D053140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:46:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776253620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=7FRUtdU00anhMZzys7tY8UABozYVG6xoSCVxZUHCRzw=;
	b=jCS/3EiJ12Z+KQuG5h5lyNLw7L4bmStL0wldBYcrszv2jiQ4Gb68l21NtZUBONfcjXt5QF
	sxNuIOx4Q9utcwtpkiwfyL9imkjAU3dH02qJoraEAcH7INlFNG0+L5VM2VNXtYASiSejwF
	bqKnZZS5cVJEiWS46lxP1EJDDlpkAGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776253620; a=rsa-sha256;
	cv=none;
	b=qe+pJBj77Kec7dtjvhY2tph2NG2zIrjX1ud+5VPOTLlhpMRrVToKrerD+FFNHSDdZ8DfAc
	6aysrU/oP9ykw/jGMfpVWUHRYZUP1m0yJT/QgU7czVp+MD1SgzQkSClYiFS9V1gVtWTnBl
	YWbZNoZmqLiUn0ljKhqP6bHqqgNCKuE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwfVW1cM4zJ46cZ;
	Wed, 15 Apr 2026 19:46:11 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 480A640575;
	Wed, 15 Apr 2026 19:46:54 +0800 (CST)
Received: from localhost.localdomain (10.123.70.40) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 14:46:53 +0300
From: Anatoly Stepanov <stepanov.anatoly@huawei.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<artem.kuzin@huawei.com>, <gutierrez.asier@huawei-partners.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Anatoly Stepanov
	<stepanov.anatoly@huawei.com>
Subject: [RFC PATCH 0/2] Use high-order folios in mmap sync RA
Date: Thu, 16 Apr 2026 03:28:51 +0800
Message-ID: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.70.40]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 0D053140002
X-Stat-Signature: mqj5tx1pm6f4kngrzi9bxw6gdc4fsxqd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776253619-64415
X-HE-Meta: U2FsdGVkX18FGANtPD3No0uC7BRtSJ7W7VqNrQIzDLxqP2yk6rkhzcVkt67HUGxmRqqfWl+ISyWXudcwDVOeFT0IHYYPog0zqapyMUemcxieIAI9E58pk5c1CBGoUkNqtg3ZgO9dQRcsOKXKSNVJKosvIGneSLlNo/28VrJ0NVJ4Ex0Vh4spHiR+UbXlKySP8SCRLEPzFFRbzsSxtGthppPFeZSS8FPkINg0OWdbxDGtQGqNls/g6J3YfnLys/yjPShXWAriBKwwyUQy7h0LIOKSL6PU2hlU7HPGncoHmx1pnIwsd/XdTECrX3qbpEvhFEnpyQwuiu0Qbeu/ahmzBNNni8rphB3q5X00+cT93FfAsUAnxSkO1BFcUzJHehddzC3ShTkL+JR+y7lcFcQVe3yYAfq4FruM3ZBjBBoLYDaDEG/XZF+Syb0thtmqbLxRNEsiNvQ7/zq6Z+AbfpbuD7i//HE24+2HMzPHLmJ6lM0in8STtHmizh5szIMXJblFzvmBDhJq7AqukiRJaweUARnPfyegTmfaW+4nhNgKlhA5fX2HUmbFfmvcSuvIpjaZhNdAc6/ez7Oq4bTQQmFeYJCsYBYy/sdIJy+KPs6w6AvK6R63dlux34SWbhDtgpzVK/ISTrI2QX/BfYZZejT/g0X5gS43flclTgKiRE5s4UVXbYQ6x+KCshPqvlmdp/YK12A22YyPtmPlLQ7yN+1s+TNS2c5dF9f2lJVvudx4RneON8Fo5cH4QMerNMKMZ0dEEOlclA26k8uH6UfatX6fhxodLlumxPdFnCZwLq/0TpBJodsCGazItz7eEyL9/ye5c6klldX4VDi7ZRmwCMqbCr2vndMdzAld7SxxFk1R5+HSVSjAj7MR8qRc/82kpkTcB4GG8VdUvWbC6c2zVoX6B1HzTVdTNC141yQGKtXxkoSMZpGqMB5a9HnJWYs+3YQo9/+nBttK7vZx6HVtjDO
 nMbQSWX/
 tn6u/O+/0KyK5LvfNZPqmeYfk1OdsxKtBr9cu5A0uFvFwfyuzIcdaIOD0IHmRlZo2kDIx+/QlL2wIiArOn8TDuemxUq/WYdvBKDPe7ITvX8rCHZ8L7I4bN4uCSqQvkvHJGcH2Mxd1VVlL5ij+Iq1bPg5y9d8l5yUttL7qnIj+R6QcOmUElY7PpW0BkfBnf6vINNpSXKP2BeHYFyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When "fault around" is enabled, 0-order folios might significantly
slowdown filemap_map_pages().

For example when async RA won't be able to start,
we might end up with a large mmap'ed file with 0-orders.

Imagine an access pattern, when we
just access file chunk-by-chunk, where each chunk size equals to RA window,
until every chunk of the file gets loaded into the page cache.

In this case, we never touch RA-marked page, thus async RA wouldn't kick
in, ending with 0-orders covering all the file.

Let's resolve this by starting sync RA with high-order.

(procfs smaps patch is just for showing contpte coverage improvement for arm64)

Based on linux-7.0-rc5

Anatoly Stepanov (2):
  procfs: add contpte info into smaps
  filemap: use high-order folios in filemap sync RA

 fs/proc/task_mmu.c      | 20 +++++++++++++++++---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            |  1 +
 mm/internal.h           |  1 +
 mm/memory.c             |  2 +-
 mm/readahead.c          |  5 +++--
 6 files changed, 24 insertions(+), 6 deletions(-)

-- 
2.34.1


