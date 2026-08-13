Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBCC7C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA776B0195; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64F86B0199; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80D66B0195; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B536B0195
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:43:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1857A1A051D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:43:56 +0000 (UTC)
X-FDA: 85094852472.23.03081C0
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7970D80004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:43:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YAoNliWy;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786592634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0WP5JdN/AIOBXWgf2qmOXq0QvCni7ganoj4mKN1n6I=;
	b=SjUrLX97xUlvphXRN1oGfR9i/TWwvbW/oNMTYh0VaHY9UFALYx0iBAsgUozuC2ljKuEj6h
	rjXssnxbDbGhGozIfNUeMcPtQ9q1IbzWa+q7VR+cxcn3yG4jCbl+8wqIwkBOzldpvRXGf+
	SjDcdiHHG6PuL9l9PPKVzBIjWjCBHuE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YAoNliWy;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786592634;
	b=MbcBfk7JBrgJw81yYM7mn6pUzwxq+yjKB1OVs3+Phn7fWOVBkD3GlRNBaAGht2CZ2IsV2+
	zRnPMc0OPeYKxxicyrXSOS80UkLJ6aP+o3haAhQxM7M+7wMGE77EO8ZfQX67dDsTXfPQmX
	GhQ0GUxdOezvC0hxGYk0HRZg4jPaI0Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Q0WP5JdN/AIOBXWgf2qmOXq0QvCni7ganoj4mKN1n6I=;
	b=YAoNliWyelz+I/5Dr28odx6ViEOy7u5pUiMvI06de7lcxVV6oOrV0NhvYlT4dzmwRe1qMJ4/B
	qMugIzjQzMSZRzr2luYhY5OU/xUmtmvmWWrzJJOElES7rESHZMmW2WE2uUoZcN9+ytJMkM9a6pL
	cpml4UW/fn7R9dkZgCt28h0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hL9tG6LQfzmVX8;
	Thu, 13 Aug 2026 11:33:10 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 67CBE402AB;
	Thu, 13 Aug 2026 11:43:48 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 11:43:47 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 1/2] docs: ksm: fix typos in sysfs knob names
Date: Thu, 13 Aug 2026 11:17:21 +0800
Message-ID: <20260813031722.569983-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813031722.569983-1-tujinjiang@huawei.com>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: hzz9p5ze8u74p6jak6kmop3or6da7db6
X-Rspamd-Queue-Id: 7970D80004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786592632-855865
X-HE-Meta: U2FsdGVkX1/vEKNl51tZsu8T9uCPqRuciUMz1Od3SlysvqAqnOCHSdsZ2HDTNSYBOfHgGd0ROL57kFfa0txfw/hSx8dDEaMlEh408P76HHSgG4wBDH20s1PKWi2mr7a1JVjAmJGLAyZyE3HrTwY19wdv/bxQa3TK2OXqpz2kes3t/EGkydEw+sWAITmohezTODHXDLMH+A2pitF2EoOWfUVN3BHquUmsjqi7ln2FAsAfBI+PRmuYUmeMo662Eg9LNZQRRzZcwuBh42NI9KkDJqTYEZjDoQqeKwEDvI2EN/HqpVEXWCiw9qH5/uZWtBIeKobMdBr/XTnrsmNV18lSqfLfxKTGLyoJ99uRrUITHXHbUzMQmZq6Qtseo6TY2WJNQjPf1gZlEWV62qmckZGRP1CvPEC/CfQXMjDHiBG/UQqwwfoYjvubmCVTIN3UWlZd0Z2kRpMF4aEos4SrbeMFr69AY3yxioFd1Q2v8/v7bPaHGAOLoeyWQUd7Y1UpPEYGFIKpkLbWiPbR0CO0MzfbeHfIsLnfDdJ88dLoRP272Flp6O3EX5ZykvVveIT7MpMmoCwvIHcTnIsq0HiMNsweleQnc0KJIldyEpJGcX4NZrp0+LMgY0ovpqh4ntFV9hXOioohLN5C+ZAiSBai74JUaQL7JOiitxXiKfB+BxPVskSVsK2MKi7iN5dg7nyEVePdJ+B0CFGUsh8JpPBIwC9CyIGz541sFtsOhQtrYRHCXM3hZzc85vANBR1ka3caPUbIDlxuTQYJTjfunfTe+jxYp0tG9WudzasScEey7ziYiQFvPHVL+Ut8RiK/JNzj8gC3RDXzDu/vdmgTEVj7H7hBN0TNWICBYeyGhqipPlEnZsWgacDpDhDueN30Omll9i9lRiSFVtY+UjOXkygoQSzQOget9hAFEjBIJkgomHpkfo0EgKvIPBYVZaMjKFkveEtVPlAYoNaW/nADy6Y1VOr
 PKrhHY+Y
 hfkgoKWDwVzytaxYR0fV1UQxterlEGQdj54Uj6EhiC42u48h+WfzWgRUo51FQmNfTT0N0wPO8AIBifyF3HFKAx8dx7HWQ0Vn4f4XebSWenquo1TZRqR7+xxlClFNuLEQQ60zINmGJekHS333t14iJ5+eTFAN6HASpVGry4x9YEQp4b4ApkoDy+wqPUG5KgXBfPiEpT2i7eUTt2+A6RoroIkHX9D2pv6dAPMJAvB55bX7up6X8PDWID9IR1HFOKjYI+eess0322sFKM6aNRC7Wya/G0ZTbc4e1gsPpQrig7DaSt9im1kOB+7+OOi5iNjodplqO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
"advisor_max_pages_to_scan", but the ksm.rst documentation spelled
both as "adivsor_*", fix the two typos.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
2.43.0


