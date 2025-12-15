Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B80D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38456B000A; Mon, 15 Dec 2025 07:38:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8506B000C; Mon, 15 Dec 2025 07:38:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE326B000D; Mon, 15 Dec 2025 07:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDCC6B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 260E6134AA5
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:38:40 +0000 (UTC)
X-FDA: 84221659200.07.FE0EC84
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf05.hostedemail.com (Postfix) with ESMTP id CEA1E100007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:38:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F17DNVbO;
	spf=pass (imf05.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765802318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bbIFC6VJA77jkt1FfGS/knbgL34kn+rdZVOQ9YOnR24=;
	b=n4+0ti2AU90ReiUdT87CXl9nBCfKghfXKnKL6bmqGvBL4aSOx8/Byal4uJBjn/mqFw5s8r
	33vkxt0XgBtyVtPHO3TpciXoNbojodLCDxJRmpUg9bhuMruTpvmbFzzLWioto/rvv9to01
	Yp+PsjnDl3BNOqDqZl8nJpfWvmShc2A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F17DNVbO;
	spf=pass (imf05.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765802318; a=rsa-sha256;
	cv=none;
	b=atsXGtN9Eld2jBKWx5AFLoHCGMp7H7m2yK1/KEBjNmvDmDj5Nzy0DBwNIN42eW8TsNXzGr
	xDglcmvaaPuVE6jwwR4ZhalYi1vD90tIr7l7ozjjaQPab1W44yt9hoJ1jZwr7CyW4kOHaO
	gF4Izm/dKwbwxy9E2MJO1voVu6Q9zPM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bbIFC6VJA77jkt1FfGS/knbgL34kn+rdZVOQ9YOnR24=;
	b=F17DNVbO6fDO22XDpcGSqnWsLSYRd4I1YP6aJGypREcF7lFZX5PB7E3+h1IrFk6h/tocsm7VM
	6XtFHHSl+XhVjYW2r3IH2OYLTBMdTw9b9otytpRpq1r0nyyFJqbd/YqvkGeJNhVdAft1mTA19FS
	59yGCo5FftDJGHOMsCF0iZU=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dVKL73ZJ9znTVZ;
	Mon, 15 Dec 2025 20:36:15 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A3FB1400D4;
	Mon, 15 Dec 2025 20:38:30 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 15 Dec
 2025 20:38:28 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <corbet@lwn.net>
CC: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Zhang Qilong
	<zhangqilong3@huawei.com>
Subject: [PATCH next 0/2] THP COW support for private executable file mmap
Date: Mon, 15 Dec 2025 20:34:05 +0800
Message-ID: <20251215123407.380813-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Stat-Signature: zmhrqawgm3zpnfcn7yip7eddc9fawan4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CEA1E100007
X-HE-Tag: 1765802316-194899
X-HE-Meta: U2FsdGVkX180BQDbRkqsWwNqrCDakNItJCBOdRrJ1dgtSjUt4IN/RW/TsJU8XaSMPPWG2M/G7newhlmPGg8mw4o8/QCyPfZIiRUYKE+UKVPHsxBXsaNCUZGOLkDiMbrwtC0rk2EXabdkLUt4/EFB+GxRxukwHKs8I4vCLF97EahaTTXo+tnZiI6w9VjgseO2L2pY3wyThj8JoQnxwfqubbEZdnWw0EzBntnebThAWN729xA9Gq4mVDbWzBaP4x5PyIIPjg+KV2+JvkkJ5oqOAUzk/Ctcv0h1HRzQ9xOeqqRon1MyXFRXtfwCfLXylYZajnZvi9ZA+zGdY4qJ5nXZaq/GZEP6Gi7KFuyzTMYAxR0eLhUEtuibgF5eJhMhZJ2cyRhhP/jzBW51X3SIVf7a19l8GOcDeYjb280YNUNvi7OI8H7Vu7h2taLW2qG2vVJ72bl8Mx5stBcdWr6JSjwOi6EvaWSWPLPQFppOjKAi94FdSec3cubEYh1nZbtvAIrKGt+QtLkmbYJcYsFmcB98vKJqLlYxAGskcttU9gFKGbZaASWCpzb8bg6JNHhTsNlssZWZvtdJCzaNEDA6NwlDij0wYoy0GBihfNZ7kHKY92Sr7isdqHLOqOWEE8IUgmgd1vmZFqbrB4b3IXx6FMtY8Ye0vw83dR3PhMP1hRWJnoUJdrbJlm92EYTaSyMFu6S/r6u70EmqbpcoBMCS9ZiX+8zFY3YHbk2d59Eiv39cOauy1NrmFW0JIETSQv3mIvn88FfN26aSVGK/QIrI3JwFRuZrnS786y2xqV82ywlzcnV+pi6X8AoE/eXc+AluSj0+PzcKnSZ9e6oaPdn78o/gmah800I9y+6wPO5ds0t+0npFMURWXY6ERrrB7t0DPUp/Vc+jutkfhxXBISe5UAR6pm1A+uew51cbpH5EizZtDI3D7QSgTaB2+O/XvDvIndFqJUQsR1kqMfDy2ZhR7jw
 loN6bd7s
 PXRM1icHRfxRd1MdxB0UgBFIYfAgadVERYSuve6+Slzf2IYLiipR61UFAJ4+RFMIHugQuW5HmPUIR22iJS5AskU3zONUv9wdFwkBmu1o+eEL76bgeE5hBu7g2LSGLrtPX6UdARTwWLIrHBY4GPz/xtN5m1npwYvlKlj5VNKIDgaJuUK3TGEKu9XzzRKPNvWKFPAjQPo9M2vojxbUbZSHAW1XryZ0lsJuAM6HV3SIr9Q47eQPzFDaco6U2cIZEHVjsZT5tszVIsQ0HF2gzBqYjLGTBN5BrNUaSXBDn4qZmOzUs0fI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series implementate THP COW for private executable file
mmap. It's major designed to increase the iTLB cache hit rate for
hot patching application, and we add a new sysfs knob to disable or
enable it.

Zhang Qilong (2):
  mm/huge_memory: Implementation of THP COW for executable file mmap
  mm/huge_memory: Add sysfs knob for executable THP COW

 Documentation/admin-guide/mm/transhuge.rst |   8 ++
 include/linux/huge_mm.h                    |   5 +
 mm/huge_memory.c                           | 105 ++++++++++++++++++++-
 mm/memory.c                                |  13 +++
 4 files changed, 130 insertions(+), 1 deletion(-)

-- 
2.43.0


