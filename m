Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38EB5EF48CA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 06:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200906B008A; Fri, 13 Feb 2026 01:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184166B0093; Fri, 13 Feb 2026 01:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AEE6B008C; Fri, 13 Feb 2026 01:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65686B008A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:04:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9CE758ACE
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:04:03 +0000 (UTC)
X-FDA: 84438392766.12.43B20A4
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf27.hostedemail.com (Postfix) with ESMTP id A26F140003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:04:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770962642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NyarWeQBitb4ojI2Fywvs1Aiai+RHgoF/WKc7yVFm40=;
	b=vGKP6F4JP2LYcRVLQdNU/pmOwFkz+4zSXJKxLARrWr2NEAIePrQCdC9wZfaVjATc2ifN7w
	pshWhjFDqdcOO0y/IMCBApuCYUOY4eNmu+s01kC05HqXw4rVVp9iofQ6g/HDhjjBVt640e
	W6m09mHnZDXLhqyQxWKfQ0n2txKEi44=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770962642; a=rsa-sha256;
	cv=none;
	b=OT1zWdgByeqgWmpMD5RkSfjcYtVzyDRsRW7tzRFEPb9/2k8DJWQxeYjvPOq0HlGJppWn1v
	0CWOPEGZ0XU+ffd2d/aXan8rjYwhpTCkIbM0P5wm6RDd2uQaP75jTYgaj+Nvq1JZt8pNFx
	umfponBbuTpBbq+hI28GEyzoclUiPPI=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwC3vZnLvo5pr8gZBw--.1482S2;
	Fri, 13 Feb 2026 14:03:55 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwAHXuvEvo5pWw0bAA--.32545S2;
	Fri, 13 Feb 2026 14:03:48 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	dan.j.williams@intel.com,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 0/1] Identify the accurate NUMA ID of CFMW
Date: Fri, 13 Feb 2026 14:03:46 +0800
Message-Id: <20260213060347.2389818-1-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwAHXuvEvo5pWw0bAA--.32545S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAFAGmONAkAtAADsp
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU8nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: rspam11
X-Stat-Signature: eqgtx9dn8xpfige47zxii898ga9nc3mc
X-Rspam-User: 
X-Rspamd-Queue-Id: A26F140003
X-HE-Tag: 1770962640-555986
X-HE-Meta: U2FsdGVkX1/utMYKg3lGVBNYTp4L723M9DOEHKfDL5kQJM6CnLbDrJCbdr8NtCE9MDLTVXZ0Lo5wX38F+vR2IvQb927AbC/p893IVThIyEMPH969e9L+0Xr1eGoq83WEjqR5whdvajc+CAPDplZkHzJUDWF77wSfC9mzhOMb8kv1h4K+2gcaR+D7mxgv5xvQiVEC1Cuhpup5j+EXXCK5DlHTzUjFfYXvWnR9tlC6KHIn/nzKDjGz4bPOv+0nK/rKbDnvw55M67w7pLAdwSrohKPH3JHJbiJKO3Pqsn6+SW6vs1xEd8geMDT/YUZh/IqIkU6WzYe1rcTB39FpKDJ6t9GWV8PMk89fghDdR4x0123OBbQmFDj4IoCauqC2HzPWQs8nlTrKaL4lQmxxD/4rondrjt7A/f0EMEqzYNOiF7fVjVy51wmD4Vy7jtcSgGLeOytdkxGccJsgyjWSTf2nZeSIrS6MS/H5Ha0mmswO1s+wWg9aLD9OSiCw3Wq+PKW5F4gwOsAZGUVad1ZkTvO6TCYRPGjGGxw4OZLh0XWvK66HqNiMQqH4U64d4MFbLsp4Kk0UX80xoC38Nqsv2M43Lpounhuc4RfrNhbLeFWr29dT/k9YCx8HhTuSqOtLLcE3iRmoZnie7SZ6VhnboAYwSwRYAwQuU0YgTHs2UD4xQESVNvAD+y4Q9MPxUtKy4chLoZeY4htPW693D/Y6vt7fcHhKSk9cvyjkBdX1Gz4YS7kbRdyQFpSxlKByO3U9LDyRlkfzYMgf9z1aH/kJWhqWGeLlT32aZlTIBGw3//hg61g0nE8j7UAIj8sI8rdGThmbNszWgAztPMGRn/O+bT2IYPKTa0WKjfGaiX0FzsId0L7+Ctsc9JEWzSzhDDifogtoBM6iaWMIVT+lQNnJ75vs/wTmUJsT+gi1WSbDEAbtKjvV4t9TedvDcSyuvE84ijvxT3z0HDiwWcHQgAQ4V/7
 MkAleIUO
 wxAkD3sYFa3OoSRONrcJ89KaNz93745CFhQgG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v4:
- Condensed the impact description in changelog.
- Added Gregory's Reviewed-by tag.
- Added Dan's Reviewed-by tag.
- Added Cc: <stable@vger.kernel.org> tag

Cui Chao (1):
  mm: numa_memblks: Identify the accurate NUMA ID of CFMW

 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.33.0


