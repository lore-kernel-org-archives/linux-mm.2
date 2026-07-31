Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E75C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9857E6B00D6; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937326B00D9; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739B26B00D6; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46DBC6B00D7
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4F6AA163B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:01:12 +0000 (UTC)
X-FDA: 85048477584.04.73BDB8B
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 114001A0010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:01:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Enj/1NJk";
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785488471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoTlsqV3LWOTDYzIn/BMuSAECJGejw6w2jDZ1v0qjMg=;
	b=sPUSXlLsL5GHGit+O3Pt4Vumu5PuYo3LZIpp85+okaYQbBorq8JETHpTlResS4SYpolHVn
	Qxfq/MBwZwca8WycMcXZjOAQ8bkZnPHkNd3jni2AZifm0c0HOq7OLgC6vvtA1vQzBD6J/2
	ZuEjBkDrjh/z20258dzWAVDXekWcsxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785488471;
	b=lwAfMIHK6DGy7X4b+tbz7l3ASfbpJ4+PQQiCtbKqqWCT3gR2ICF7jDxv7JeZ9WGiQxr47D
	NL4JByOtJ8P4XAmhZt4f/Q37TQ9XN62G7G41SdGr1Q7asi4l6Afj/1EtG8lIwVpf7m4HT1
	H4gOe6bqEW1jZL8EOuliS+YH9/XVVvk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Enj/1NJk";
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YoTlsqV3LWOTDYzIn/BMuSAECJGejw6w2jDZ1v0qjMg=;
	b=Enj/1NJk47CJ1vC7YH5BN0DYszJ+ljYBiuJzsEDqKZkRSSg5BVB4Rbw+leJNNQ+khVLKGixKX
	BEZbEBMzRDhg1Z3vQ1Pn4aig/2FUTxOiiQU0jNgJrptUG+BCkWzfXZtrVeTPeqWoCz93XYoUImo
	0oNmJezaARd4hBzcbEvwUCU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hBKYl3BwBz1K9YC;
	Fri, 31 Jul 2026 16:51:39 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7120C40574;
	Fri, 31 Jul 2026 17:01:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Jul
 2026 17:01:05 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
Date: Fri, 31 Jul 2026 16:35:25 +0800
Message-ID: <20260731083526.3953421-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731083526.3953421-1-tujinjiang@huawei.com>
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 114001A0010
X-Stat-Signature: uzedzaftfarp7cn7uwca4gdi9ncx3ou3
X-Rspam-User: 
X-HE-Tag: 1785488469-153229
X-HE-Meta: U2FsdGVkX1/f/krSImg46T0hc/XCXDf5qoHudP5vqy8LcGbdmzfzWGZri23mKx0KCMYmhEdIj6tuHFU07qpMxgH2ZoCy2RytlS5i+swhW0Ue08k0sN22gc9D55J4jzjGRczw0yWS2pNtc4NT0Ae/ZKb/wdsi3qW5+BRqbg85LVw7+ecqptIsy2l9305K4CdhTpUhAYAInRT0WqjAKNM5GqICFjWLp7ZGZYUwqiY+l30CHgYFf/DpdJ02bFJjQubZkrr5PuqKpTl9Jyine88929E0PtKpxFe86IrLGVL8lMPTFdm62/rDGujGMHwXIPVNlKYrP0aTQQvmO8mNgqGr0TQuEQnsJE8Zo53S20StUjfIK1/ou0uMyNVnBthFDvCXRgGweXp9mWQgk1wBieNTU+I6IrMd7x+Byy6bw+6Ow6wODmiNMXzsDOrHd6be2tF4S0MLd/Vw3YpJE4gErpzNLtwVwPYAnwpnW/JV8VfWI4r2NXdQfHWqIg6OiTmJD2hcMaq6h2ktz9HAyo9/SpSxjx5wW2dllnZ4At6cifA/wtyoVfNvap1QSpRGfK/Ou0smWfzv1XcHUnU9W7df0mmIT+r/7CdpTNkkD0X5ObZr8n4IwAX0PhNF55w26PFfmTZlWa9mEqfeJPcxlniFDg+E/2xRGp5TvIrfSM0Au362jHYQgIXc7wg7a7yJ9cDDvmiaSdCKfPYaGhZCDcNogUI1NUspJ7VDLUINTCbmM5sGGDdGbMT6XQt8h7Qdp3Jeh9MLThYdrJSN0ugoa+A+IYM8GVQQ3SGYJqX5/HxAMXLUJIexC1SJXh60gKfWOljSMJPcL3v7PLaiMgIpXG2LsPfE8bWH6U1BJCBypFUmhOrocZtCUkohPzo5xwVpA5dHpmdTtjL+yYIK6YuRPjmwjsXedzM6NlG4WGmmirdW4nTlPnvXYOQTHSESxId41y1Y3kl4PiCUtjiXneKJfv/CzRX
 166hJkdr
 Ps2LAbCh8zEXIDj1a7rG24+dSos6pem0QGfJtqYSaHBa8edxgyb9Q+S2xU8/xbTJMwsdnGKcVZNLRez7kosVDSnZj5b7xMh/NgYcYR7RU4URV4qXsZf0e5B1oEtrqTCFjV8AHQmqRQIbhKB/pIT7cSr98+06hKTzS5Vft/bu06pkVEZ4d+6Xq+ZPaEhv64Q7SgDaBCons3Xgrj47EfvRpbsWgs+92jN103CfaLAO0ZoiRd+5Pz9GQYXoRhlhmffJf60cpJH8Jw+qGg9RsXpJvJ1OQFXWTGqMCukKs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
"advisor_max_pages_to_scan", but the ksm.rst documentation spelled
both as "adivsor_*", fix the two typos.

Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 Documentation/admin-guide/mm/ksm.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index ad8e7a41f3b5..c9f533b10f6f 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -174,7 +174,7 @@ advisor_mode
         The section about ``advisor`` explains in detail how the scan time
         advisor works.
 
-adivsor_max_cpu
+advisor_max_cpu
         specifies the upper limit of the cpu percent usage of the ksmd
         background thread. The default is 70.
 
@@ -186,7 +186,7 @@ advisor_min_pages_to_scan
         specifies the lower limit of the ``pages_to_scan`` parameter of the
         scan time advisor. The default is 500.
 
-adivsor_max_pages_to_scan
+advisor_max_pages_to_scan
         specifies the upper limit of the ``pages_to_scan`` parameter of the
         scan time advisor. The default is 30000.
 
-- 
2.54.0


