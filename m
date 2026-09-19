Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00B4C982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EA86B00F8; Fri, 18 Sep 2026 21:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CAB66B00FA; Fri, 18 Sep 2026 21:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9A86B00FB; Fri, 18 Sep 2026 21:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1C886B00F8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E88471C08EE
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:13 +0000 (UTC)
X-FDA: 85228740786.25.15DE86A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 50C0540004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8GWpRiz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780452;
	b=K3bGpp//Qi15ZPEfz+jDNwyiNygRIGumzfYlfwCF8hnZwJvGagy240ln28CDIJixnNovKD
	QEA6Eo2xxczexaR0u36kPwixZY2yhy7YzNJteulATF5dr4fKQjuU2kUPIfJqhe2bZAqHGQ
	mg3VdqN7kSTx5Hu1pWctWfL0waVAYbM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8GWpRiz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1sX9mUyRN7/6GImxCu2dritOfCzk+oOrOznq8LURqo=;
	b=f5vsNas92jvgLcgiyDO8GjCgsfRIykEvAPR8wAUgImkSsJbKjOjF/nzPkEaAn9rTwBd+XD
	SkT8qDMRXaun5UTkL6O5kYmN7/RUU5dTos7JP46RQCEJMd/wLErALfotT0y8hnI1KKeKB3
	CnQMO3M108RLi6jci/VgB3RFpEba7tE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97B5D440B7;
	Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177091F0089A;
	Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780451;
	bh=X1sX9mUyRN7/6GImxCu2dritOfCzk+oOrOznq8LURqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8GWpRizei76S0UuKxfiH+DsDk9/rjgfJzoPE7pHmHXQYP9K0QJoeREr52QC7+vk5
	 p8yiE6P9eBHsr4Vod69lNdvcEQKymx1lSJ1M1nPFXIzBrb6CkSRXZgCvYHcTECfbAu
	 /NX64voDVILlwQYDbyEUKyXDFdnget3ZRxbexyiLHpDGtqxnMStIiRPd9/fOS2aTm9
	 55ZhsO9LUS6W67vVi+s2vb0XWUyi1Mdx7iDP/GwiWwJR+vJlPMX0YBfUdXC2jvVmN6
	 zfMEJbYeW0Nknx14mJGaHwGuzsulfOUk8kx4KhYb2CZvfPNtadVLvmZ8rQVfK0oULZ
	 f1LtHEG1EYbjg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 7/7] Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Fri, 18 Sep 2026 18:13:56 -0700
Message-ID: <20260919011359.88921-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50C0540004
X-Stat-Signature: ectyb7na6tqqi5hoyhjfk6dundbad56m
X-Rspam-User: 
X-HE-Tag: 1789780452-712040
X-HE-Meta: U2FsdGVkX18pgQI28LEpRMAR+D3s/OPOHgz6e/wF4CVAlkCsa1lsTTH9fgPkCeIeketea8fdqL9LWI9rqnZ6Y85tz8/3fnZDYrgXBy0GDzq+wbDd8VC6DpfWMbK9Lz7lR2AiwblwwgA7Q8gaJvNMiZAZ2pfsrqupUB6PUn5LUrsp9yrZiWMNrV8/E2V5Va3JZqy3SUemlYN3ppm6c9w48hguxjZWRM1BSpxFUxjGOKLAvjvPerOFtPCfPdM69lTbQAkehDD6nfSSO2FgxU5yvEq3QScSAFW4jlad+26DjlbNByozBVfc0jbZtzSmdLqrOzq/dLMmmOBkTCP8NmQYLvb5/09yaddXl1VFwQESEez5eIxnK1nmlCWesJlDccna8jPhulgrdHUXo3Wz53RfQpkK/EzF+r3geoXPXlFgObg6k2fgymynHqFquKy/pcoLnB/Ar5A8/5TbY97lkqvjv4lGIOeuJZ5VKyqW1IYqrFwP+N3IfRhlQ73zCm3JhEKNzMjFPI6txhL3PwTZRHEVt94HuXW13+QVEOCEgQ91H21oiMN725attNVDIDADBGdgEnsfHYt4Qvsz5hnO5M793be8h1JYiu+nnuUWa+j6ZVJt33i/N7hjYCad35WOsMoVMUdvFmmT+027M07i8HX34aOLzpXrkn6x7k+XXTjLPp2G/sY4e5DGJMNlRJGlG0I/WLbM4dstaOtWBpUVIz8yAd9MQ52wl40AuqarWbBK10FOVqWQiKmV3tVai3xKT+KGnhH+1sv0LEpkNr2YpOGR+eywgn7kiu5Acadh2jh6M7ot+JEfDT/1UKn6XrWgmgygRU/2SE2LGuMZy0jZhqk6d/1Mrn9WBG2Zt4oNT82P3atTG4p9usbcQAx4QElA6gyNhjVJVRmShwe53STq9w50HO98RRnHiM1yyI88suUgPAXhtrB5FyCRuCJHis0ICPdbP9wfBuwywVnLtbWqWB5
 RltO0RF9
 irxmAIr3sye1CxTiPv2afsZtEkkBT/FzcTgsOLgtLfipqTmbyMPn7K7HV7HChNKAetdaUuw5fJN9zJo7aGpJeue/Pz0trt7FEMdZdhKzor/ALS/f+tf+UE4EmzHsCjnfzfRq7FR4HSx2cVsSmaPY3KPDZ/VlqBVruIKPMTOz+weZHcBqTzND9byd+O8PqqbUTpfOmTmQqSaWuvvnCDrM0cDUu+73r7xeWiNjueuQmews2mD26AXR+Z31SJ/ftrPuJ/V3I1m5tKS/AvCBsxAb8OP7sjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 55df688ea596f..4acb2015c2f4f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

