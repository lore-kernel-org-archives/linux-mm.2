Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42892D637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FDA6B0088; Tue, 16 Dec 2025 16:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D2A6B008C; Tue, 16 Dec 2025 16:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C166B0092; Tue, 16 Dec 2025 16:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8165A6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:21:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C0D1607F8
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:21:16 +0000 (UTC)
X-FDA: 84226604952.06.414D527
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 78CEA8001A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:21:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ey6woMYF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920074; a=rsa-sha256;
	cv=none;
	b=x5ETO4AcO5WNcYVl1O58mSYHJRCestQzS3RQ3eJXDTMzceExS0vCG/2FcnE2tuJ3Mcm3VO
	cfc22XlRX+r5hFE5TK84iNL8and7ERNsBn67629NBGcSEvuDOFbCVGoBgvLl6dHIcxpqMz
	HC0CHn+UgTU1WYSDZIS7K6EyJBQizDc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ey6woMYF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZfOZ1kb7S1+OirlSYPDDjGrFljxGcHFaYN634TXPH08=;
	b=n/irUpja+PqH/rzjLr0b6BWSI9jc/fA57UDX+a+x058X1kuUqyB1sxeAclHmjMlDnX4XIh
	9eo6NhWDmCc+0nhjIAIPkpups8uCnCgUQAntI9E+/AVqGyGfldhfDKKQEpKw5kwkqCD8Sy
	NDl7nHUE7ltGtHN3HSbUtaOQ4xYWASc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765920067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZfOZ1kb7S1+OirlSYPDDjGrFljxGcHFaYN634TXPH08=;
	b=ey6woMYFLSuMSGJ1GMOKxV+l8NVP/+hqcWLToOCCN8rcLfAqLUsKHsuJRwZ3uujYyzJ+6J
	lZYR2kyyxmQ9XQWq2j1kzCRssuqMk0y2gA/0F8U9allCiqWgajBlM8r99+6pDuBt41blWU
	RGOISzMUDyPXqnXzHwJrh8fqrbDeYZ0=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>
Subject: [PATCH] mm: memcg: fix unit conversion for K() macro in OOM log
Date: Tue, 16 Dec 2025 13:20:54 -0800
Message-ID: <20251216212054.484079-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 78CEA8001A
X-Stat-Signature: siushtwtcprobyfgdb3f1b3r7guxi4jo
X-HE-Tag: 1765920074-985203
X-HE-Meta: U2FsdGVkX1/eMmo+0WUSWywepJ+ptHX4VGh2RqZc8ivHEjzyL9YqvYSl2MIue8tRfCUteqMJVr07JvpyofVjapjkLnHvXkI8ZMGQCVkmIA14eol4ERVk2QVb0PZFuIfcBZ93tU+P27hkoaMvgqzjCSmmm3ML8MEzI6FkjpEWYa0ZZWOrRzJQtJdH41ocS+pSNdVxIfDBzdPLpqdOslGRYY7mDeNJzFVEjYShCJxbVcAYCgAOtxaASp6uDFZz/2kmNC+Cbx11r6S0Yhlos25I0kHR1ipuW+DR6yJYnfg8oaU7QpP8L1wvUtAN5yBd5EnBtn/vLdfUGk6asatmSmsC6jTkVFn5TOtmnmEZEdCGwFjskbenMYI1wA3IWB+3OnlgaxDM7iBTWZZ4YsQ43IOfzmFs90RXahFYsjQTQJAeQaXIe6/0njRdFpgjj9O89i8XbI5IUo7ztzv2r/hUhPrKp4a4UvhGmhKg3fWmuveGMu+FFbFFwCEki09M81awOAuTTTu9EGvjYSEp920+DC0yFCkgh9xawy/0Vaz2u3RcRvHKZFDJwaPNF3fEJ/9QuVHg/1L1e3xAjCzqU9yaQ/zqE3MlbUXNye/zX+Df1CS7qalrsJ1RVR15tlpmOh3Qb+fhMiVYN4q4JBlJ7kkq5TlZy/YrGvaH0I1UoB+8THujcDBiK4gPUnOO7HGYG/A/EXgfOlSQMSI2/vpO/jONsTkl+Iqx6ARDv+CCN1bFG573tBr7llcYX1X48H94jLNTA0ELKc/Y16i09Ryp4em36mvXZe+h/+aarprPHT0Lot/k06CLNXjNOq7crB/x1hoN7I0zutNsuaLfy6ns8Y0upELliwBN4N73YaFYV8QnWUTm3vJ7eP4jkHACrt06/U6vm4kTkCzI8YUK0hMVfnPby45FeqHSJ1z95HDCyYanrrPCS1CgiaWtX6gm2DL0PxT33TGK8NfKqB+tJuma8QahYwK
 GSXjKf5q
 iGjSuEZf9dgBfPSXWAnfSsyQPENYirO7l/mg6DK9g3KC22HZvBos9Ys9bejzF3EAZPMMg4DPjtUNrdKckcNH+Xj+kecWs/GovxwAxXBFdHAF4aCC821STmM2lYyqDeEvWveWqRpsGCvHBoqPAFlHWdNUpXcaoGM8f2vG/Vn55vQnY2Ac3WJ+ZECisv0EXt6l2Mk0QmeznFVzz6NczrFpQrHDPRtgYMiH+nF5Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom
or alloc failures") added functionality to dump memcg protections on OOM
or allocation failures. It uses K() macro to dump the information and
passes bytes to the macro. However the macro take number of pages
instead of bytes. It is defined as:

 #define K(x) ((x) << (PAGE_SHIFT-10))

Let's fix this.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Chris Mason <clm@fb.com>
Fixes: bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or alloc failures")
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2e49f4ec9e0..6f000f0e76d2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5638,6 +5638,6 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 		memcg = root_mem_cgroup;
 
 	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
-		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
-		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
+		K(atomic_long_read(&memcg->memory.children_min_usage)),
+		K(atomic_long_read(&memcg->memory.children_low_usage)));
 }
-- 
2.47.3


