Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B2FCA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 06:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD8C6B0012; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D896B0022; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473A06B0025; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 324D06B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C56C5597BB
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:02 +0000 (UTC)
X-FDA: 83828885364.09.06084BA
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf02.hostedemail.com (Postfix) with ESMTP id 695BE80003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756450561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EwRvO1KhEakTOiWURiGIwfH7ZUlxXsWyOGm3XKd05TQ=;
	b=L/NXfXzvsX69nvNAUYg0BRZe4IiX0h6a2g+pAVsmgaPYbTPMTQ9EG6SJDMVpQVtWwgeRas
	eSpgRIKoZWfh7MMY87Yr9AM1MwgX2n4H+MWu0csS1lFR9WmpzUMhZonsi25yldVimhaokL
	tKpPcZFsdUANYHLYVAj3AmmhilXcUAE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756450561; a=rsa-sha256;
	cv=none;
	b=QfR9mOe+hCmiPhyk5eAiDRJ6OIpinq9ZednMdjxdyKnPCzAImp+jeBW5PIf2hDNjEXk9Iw
	Lj2M3Mcx7la/bYK7BppwpqTqCWrpYsrntS1zCvodFsc2mIO+vepNp9RKKosDJgBO/OFSPI
	KydDMapa6Zlsg/RXVoin/U/nK7hVQQY=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cCptx6T7YzYnQcn;
	Fri, 29 Aug 2025 14:55:37 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 29 Aug
 2025 14:55:56 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 29 Aug
 2025 14:55:55 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>, <surenb@google.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <tianxiaobin@honor.com>,
	<fengbaopeng@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v6 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Fri, 29 Aug 2025 14:55:50 +0800
Message-ID: <20250829065550.29571-3-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250829065550.29571-1-zhongjinji@honor.com>
References: <20250829065550.29571-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 695BE80003
X-Stat-Signature: kmt99kt3ijngkuj7j4xhucryko5r99wn
X-Rspam-User: 
X-HE-Tag: 1756450560-214785
X-HE-Meta: U2FsdGVkX1+NSLHR+3s3oEC67ENb15qwWSlVgMMERI/gVofsY+L8qxuDJ+oqPdVoYR4pss8TxbxmDJBM/kpRiyS0scWZp+AE7+Pud9ThJEgNS15HT3HMpqajOOh3z56WOTjRY/b++IHr8hreMV+01xteyvEA4X7a6oLGwX7THbAuhKi+kN3SUu1p1ie8+GR/5RAyardiD9hTber2YwDGXasx0GdVe/mE8ILxM5plYGSkxCJoIKL/oYbAnQFrfIsqKWXf68ooa4bgQQBVs2hIn9+3k2i3phTDDl1p7F3YaGNo5/V1mN+8PhA0GhQf4pBX/CjrTSgdWYG6uD+AIOi2zdxmiqaCszMENqz4g0BrfemUPgE6Hb+UZlQok5nVPAfAvcLOsJgKhvS2VdpItox5MPg28XfA4lTu86uQkm50mkyKu15HiXle2iN+q7SG2swccYCkOm5cwXEquLePwclh/FQGzXYXJg8aQpfJop5V9C27VMCRi5QZRFuBijzFrAIrt5yABT00MSWlI4Mt1byLKvo+IKipNLM3pFNbp/f4abUZZrfa3kCpL8AWv+bomRS0vU3etJorJcJQ38OFtA6Um+p8w1lsOpMzhM3HtA1vcW4J7sdA6b4ds0pY6HZngLEoqVni8PpcUNq9CysnuJLloFj2jmq25gIi/Anyy/65+TdtJtQNoj/65M43ZMehnDUWvM/3bkstHluDyAPY1kOydjsB3hhiVs0BO4JpIShc+zsmdYopQB1L1RZwQN5YK22y3/Z0r+1BZFNMI5/L94YTvJd0yPXx7OL8zKnk8FMEUWv9jVSRyPGvPy0/g65aEBnPUYj7WaHM0OlkTt5iC5hRH8n0Gj27JanI8oNxj/nHbxKBFHQWFItxZAo0XrGej6B0bE567yQjMqgGb7EofyR22/QXlb9yQ9SNZeAsEb3/AuBPv1Y+abTm7EEUFlzZDCYDM3GXSJ/ZdKug5r3Uuzo
 YMyu3Lfw
 QjRhUTN3yXIdkMdgsPvPJnyHV3IUTgPpzH2SZeEJcjBxGTIyhBNQy21RwMK+5BiXpmCRutiLs17c/awmeGJYTH+ToTRo9TCe1vWNBgyL0mdskA15KLP+vkjNzkQHaBiY5Vded3b+M05Z/LvKQdI3gdDnWND4BIO8k9V7EmDY5cz0XjTctgkLpK2pNBtcrt54qfbtR0SNEfhXJaM0DVOuIjVzLM9Qt6OKoZl8FmN8RwoziX0X7mmCP8AaXQWeyBpp2KYpp
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

Reported-by: tianxiaobin <tianxiaobin@honor.com>
Reported-by: fengbaopeng <fengbaopeng@honor.com>

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index a5e9074896a1..01665a666bf1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
-	VMA_ITERATOR(vmi, mm, 0);
+	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -526,7 +526,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	 */
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
-	for_each_vma(vmi, vma) {
+	/*
+	 * When two tasks unmap the same vma at the same time, they may contend
+	 * for the pte spinlock. To reduce the probability of unmapping the same vma
+	 * as exit_mmap, the OOM reaper traverses the vma maple tree in reverse order.
+	 */
+	mas_for_each_rev(&mas, vma, 0) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
-- 
2.17.1


