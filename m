Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB4DCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609AE8E0026; Mon, 25 Aug 2025 09:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9B58E0001; Mon, 25 Aug 2025 09:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4913D8E0026; Mon, 25 Aug 2025 09:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FAA68E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:39:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0ADB139151
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:39:08 +0000 (UTC)
X-FDA: 83815385976.25.C385AC4
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98BB1120014
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:39:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=VlsDG2Id;
	spf=pass (imf29.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756129147; a=rsa-sha256;
	cv=none;
	b=jE43Mz20wp4qTwSPhd1davXTwpjTIeg/3eUa+RmcN+c8Z80rYODcBk0fdBTUnwhCHQVKg7
	78SFI9aUh7A1uV3iNStwmpxaqP8dc26BJgYo16+TEDeEu9vPK1cHIQCA7fffFbMVLIoMNw
	tu70b2VeQ/uHy23OndVPXB6ftulsuCI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=VlsDG2Id;
	spf=pass (imf29.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756129147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e01QAR5JDTSQnGFTtnf/BBtTF0FubM4Lr4gx30e0yhI=;
	b=u/m3YtdCwJFTQeiZbCnr8aKG4bzpmxRindL6/UQrk84fLhQ5p9l3rg+vcRu143qLqc1Boa
	Nbb34Vly7g8+y8rf2QMbiL2Xn7zW3iAqemjMzEtKqcMS26LRtN+MbFM/CPgvNiZ7suoNh+
	vaQZaQz849rKVhwgjo/QXjmCRYqC9Uc=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=e01QAR5JDTSQnGFTtnf/BBtTF0FubM4Lr4gx30e0yhI=;
	b=VlsDG2IdtAp/2hZRJLYa/Soo4y4Mt+Q+DsvVy3NkT4QDTVovF8ZwtjyYebt3Ukp/hh6zQTr7V
	rp/sWixZspUkFeZa96Q+7HKRIcPxBJWExNPi4yQFnHUonoxJcnf1BjKlzDBSRIEzWz2n9xbWCpJ
	PPCTuy3Z1XiVPexTiHP2WKk=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4c9X213dMPzYkxf9;
	Mon, 25 Aug 2025 21:38:49 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 21:39:00 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 21:39:00 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple tree in opposite order
Date: Mon, 25 Aug 2025 21:38:55 +0800
Message-ID: <20250825133855.30229-3-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250825133855.30229-1-zhongjinji@honor.com>
References: <20250825133855.30229-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98BB1120014
X-Stat-Signature: p8xqgwxfqc3x6dx6zty8y85xuzugpo4d
X-Rspam-User: 
X-HE-Tag: 1756129146-13908
X-HE-Meta: U2FsdGVkX1/YOHo/CCcf+Fj0a3T3FF0sWR2cbgYi0kLZQoVuFE6OMkF5VxUoK25p/ZWZddPHoYCr6NjkLc3hkZXUuhNN3iNQD8/TQFODR8RMSr/FlG4ZpTPQpiYYLf0f2XqWp5UXe4ZaH6BRAbt3SIhqNd7FIierLI7KD5Y/rsYISK1t2Q/abJwj9spQzaBT1o8YOLGdoKUW98/NNdMMIZ9R5Jp7VGVp7eIMIqESplZNH2yfJvK6cAVAKs3LppVeORF8XDGFvHECF0L0JlJHM2CFv8XT3RGQ5AsZodlV50tAiVSJd8RnGVxkRA94w61qD5dzkoz3JHlnsKBv4/1Yr1JIsTvtJUlcmxs95qs/dBuvKQ3OsQ08N/V19OhqDu9f4Ed6KhkGsrf9MN3LEnl+XyPUQYgxoev0GIWi4cdGncSRPmQ3jq5lKtjgMPU9uv5XqX62FjytxQrxEQVt/ZEVgDa2+HowJuW7bQHUSbzkctcni7xjzmOD6Nbr7839hW0pfnWoTpDhpVyzEFFUkELsT6txG+xmtwC0sTP3oRJtNQPrePSnaJSAHKir127D9DkRLSLMECx9CeDLQO9F8yiMf09S/tNaVqa8l494NPgTOab6apwV21Jv7zQc7BIAjWJ0I9zBtlWdORtg7pDVoYf4kWPGb6Bo9NWQD6PVO9YG/HYkk8PQTaFj6RFb5FfskNMaJmIg3hS6ohkaGO7ZjOQ/rFcfqzDtoI9LtQ51AdFBpoznd3oUZSWCvBykZzcNPBVaQ5GSMd1adXKqXA/5gEl6T1B/0a3eXi97eTWncIZy++l10VWG5RyHvOD2vlhQlucGjUI1d2djdURiVtNM+o7rWOsyWYvhD2SH027afxaxaLVsZqiIpF+c2wr6JSV+9Dl0nG9Ki7wkbJQHtqzWDfiwKC8BeWUv7n2r7rAP/yrk7Qpa4oxqExqQaZucNP6EoENClkE3VnrujClyU2dbcM7
 YtJ0VUBo
 Y8ZPusXfQtaQrNEd7DKL2o9OICtcEFbL71PWbcCJsWTuMLuvvBty87sPH9JpUH8ekxqWopYIXTqNulBDNkkkxHzdHhpf4w2lEKW1xwv2NfcbeIQ2AMeI3q9LSgggkw/nmQRAEKmWhzlZ9J/o7b7iTpinHnDhFcNZXzUpjiTFvScwdNcYfRyuX8Tnv7rDn6IoB1yo491Derx0KpRo0pXfmRqjOQjKyJR9gbn962hRePhtKbejXLchHzimhPkzgwkNHnAgH9IR5kiXz5ltcLvB4T9KfDAs0Hqtq2rmJ1Mhu7EfDE7vtQ4R/gTj94Sekmbu7Bn0XIuCF1ocuisTy383LLn8cvzewkvnvd11O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a process is OOM killed without reaper delay, the oom reaper and the
exit_mmap() thread likely run simultaneously. They traverse the vma's maple
tree along the same path and may easily unmap the same vma, causing them to
compete for the pte spinlock.

When a process exits, exit_mmap() traverses the vma's maple tree from low
to high addresses. To reduce the chance of unmapping the same vma
simultaneously, the OOM reaper should traverse the vma's tree from high to
low address.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4b4d73b1e00d..a0650da9ec9c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
-	VMA_ITERATOR(vmi, mm, 0);
+	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, 0);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -526,7 +526,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	 */
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
-	for_each_vma(vmi, vma) {
+	/*
+	 * When two tasks unmap the same vma at the same time, they may contend for the
+	 * pte spinlock. To reduce the probability of them unmapping the same vma, the
+	 * oom reaper traverse the vma maple tree in reverse order.
+	 */
+	while ((vma = mas_find_rev(&mas, 0)) != NULL) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
-- 
2.17.1


