Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F44FC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006626B009E; Wed, 16 Sep 2026 05:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14536B00A2; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D950A6B00A0; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B04CD6B009F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15D41120677
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:55 +0000 (UTC)
X-FDA: 85219108590.09.A727CA1
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2BAAD120008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B hn8FHD";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kqxh5nkk;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B hn8FHD";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kqxh5nkk;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551113;
	b=Hhab6bG2ZKH7pNMLWAlGrh0N9LV+d2u7iYV5vh4fWv2F+WCHPkA0qXgpt7LOBbneUvrA9L
	x9V+ZaKlDdq3/BGmMazQ4bSvYoqGvFqyiOqXARqUR6q9QYPVaxb4+d4g470sywiia346qP
	FJVNXUNLZ7QEkXO7/2+kIIUuxupD7jA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI5Fa516GYJ3tjpfUWQYw4F0sEV0mYVe3RtQG+xuZIc=;
	b=OAg6CK7jkcejAoULZKV78wXk+XjIdYqWStRvwO11mTWEJrfCfY71sL0COTCHl4WfQriajt
	yIOh1h+mTlIK4z1GL/f29Oy5bHAbjUaWBh99748Nx03OYqXZam0TZsIPf+ZvaVtC8oI3qR
	1fetcaI58IHFJfWNsB3DQuMchg3NCjw=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 29E827A0089;
	Wed, 16 Sep 2026 05:31:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 16 Sep 2026 05:31:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551112; x=
	1789637512; bh=JI5Fa516GYJ3tjpfUWQYw4F0sEV0mYVe3RtQG+xuZIc=; b=B
	hn8FHDCByQ+GdJc0lRviJJLX9D2otwZZQX97ey9dS2ATFtcTTPGO8CVcBlwI5zxm
	UQXbIy0ul/lGFycowa4JG2GvA7JP4ex256VcW6wuPN9XCeyxkEwCHs4tbjkoxrRM
	fDw8NxTrNf5q1dyyKsM/Kk3kCUvMpNlHcw5FLD+NvWpXYNDAQa7LFSwAdqSC8mCV
	IbGSMNngJJRp3yk1ROTY+EmkwFzix7ofcC3Z6fsCLcvgSdPqsxgJnKaaFZDx0EMH
	Z0JRRvWvYdPeteMp1aNI1Fqm/YU3ofF9+sHtvhwf7pG2MPWbyRj7beWo9xntouun
	RGAjpUy6exbFm9c82N56g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551112; x=1789637512; bh=J
	I5Fa516GYJ3tjpfUWQYw4F0sEV0mYVe3RtQG+xuZIc=; b=kqxh5nkkigRC8Y/hc
	ATPt7hojrfK36ZFYv2+lrVEJlENTtWvWz3RfQiOWYIqiQu+pqGrnXd+cMLxd5TO0
	jT7c5iXWDTEsQ+jw+P3sWBlMcu7jFzreeV+s4j4ADfIiVxK43Rq79THKSP9ZHwJp
	+Ngp9oEvDlEbVfrXXG2XPUs4rwD9UfRsnp7DBI64AhfWlWOYZqeryf86FofHb2mR
	+B2btaq3Wptcum88aqgK7v7go7IlOl0Ac+7xHCQW/PLfFjaZjWaPhtOYJ5Muq6gb
	RFdbIb2CksdIvnSbGsdRyTlJgdCNrg4D/OPyXsFLvFiHZQEntI279eMQAH35R0qR
	11itw==
X-ME-Sender: <xms:B2Kqal_L99X54vjMYBUguULWq5-pmWzOM-aMDx8FeE3OG54ftP0dOA>
    <xme:B2KqarONrlsY7L8cZVTElU0OosryntzpqGC9hG2tx6UC-fYoaZbPPvMwU0Hiw1K_8
    m3XbypSNpghQNKt5ZRAuFuB-56JUu3XedHGhbVZbtjseDcLW1tjLtyf>
X-ME-Received: <xmr:B2KqagoAS9qK05aePN5G8-xAZTlggCjjOi0GNuRBajOl5gDrEGe-Fo78euE>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/iiS
    UYsnT0sdXd1+mGrCuKiHZ1L2KKVC614nXF+Mf3lloTxsVreBc7gJjMAQmU8ZV618W/Izmn
    eSMlfn+hj1WiCgpnCISvQOOarVik4o2xz6ldwlcS7aOzOx+YUz57jrl+PRIDPdYamW4gmU
    mgMGM7p1wplBpaGjSG5Mup51bicu/FZPGAcyLig8Z1/UJV/8K36pYtigaLEXi6bfXTPZds
    KqposBmGHUxcr29cTxie9RGUGdtUORuOoZ0EQgZcLjb/l75VAja7SdiS3pvt8WFYx5xvb7
    WSnK6J3WaVsI/SCJBTz15wRxePYKVDs2/8S3xa3vW7U5R8VtrfGrbBpRiMYw
X-ME-Proxy: <xmx:B2Kqag6z7xVmtTV6MTYZx06yUET4hpz6wCdAogboM3aq5Ks7gfFLxw>
    <xmx:B2Kqaqps_oN5y_X9Qr9hCx_3App9I64Qdk78q-Yc79Qc2_g-771ZAA>
    <xmx:B2KqauIfTKz0-9rrQujLBNlO-xQhaJTNlnnFatcNNYl-dwewGY07Vw>
    <xmx:B2Kqang2gYP6CK8tErdtqrVDHVNSW3XH1xpZxZXmcfs9XBfMo0YbhQ>
    <xmx:CGKqagiUn6GoLMf-Sumwj4BYHv5h1eAsyugk4vBNjvQTqRitn3MeMDT4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:31:51 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 01/12] mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Wed, 16 Sep 2026 10:31:28 +0100
Message-ID: <20260916093145.4022188-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BAAD120008
X-Stat-Signature: zs15j1q71kjr511mie6bbap3kty1pss3
X-Rspamd-Server: rspam01
X-HE-Tag: 1789551113-796601
X-HE-Meta: U2FsdGVkX1+CYkzoKPJQJDQrxIxJD5PRhorN0zEy0ZBfdvl+CsUM+mYLP3SNAQkNaL3c++KEEzUHp5YD/AZy5VzDcioHwjG/Yw/BeaAvttGHwC0ZuWEkac+2Q4/19E1IdTum65RDsqBorlbYIqEmEfh5q1Sp8o7YZbVuu9MExHCV9baA/07acMCk0DQGnt8cwYRdJufRcBFi24MyZZGviJ/qET8Prsc1oXAuX86tNX1g3RfojkjleK6MLM/9pVP0DukYY/y08zaCQS0EFOErBDtA5zhr//8Fmr1I3MsqU2HtwNpBaPgL2UIJHkenck970Iu+hS4BAfHpSLScM6aJzFiVxRq6ps9AMyHA9N67nyh4ojrAmdJqV0AMQRzk3BkXNaYgZj1/fI4acFxqdLCE2zjrZE86cu1m0SaQjZeVK2nawIIXbWz4mGKOa2Mcq9zCAJvDG4XZCoJqfUGbVFgB9HH4q6zGLkNfqybtJDELVt2IQOuf1j5TvJYGdElFpVYMfqklFoxROGiS/upSHv9rEef2eJM1RnasqwNxVPi+Zv3WfN+uLGEARvtF4kZS6j6Te58PhGpwtrLZl63qsq9OQmZ13oREyWQQhF6CpfdrltTrFpKoYqywjKDDwIScWpqw5KUtYS5fK9hlD2VZwfIICBE5fXvB1jG+etaVSppS1e9oyy4QN1v+Ig4Dw/2f5O/cW21WctxJMjE6Q4nRcHxIyL60cWYYUosMEdorgg5DOxvTWnHtQqm1I8KjXGcVe3lSGcR4PIZBEk18LB0+I1asVp24UVb2cBYA9t9dkxsB7dSFxkZcfBeERNphTpg+LI0qzV5xuibsmHRJft3pz+PG+ywqsqIf8ljjWAttlUpROFnXLt4NrBwB3f6X3rvELihYJ7aaWBXyRqJnE+64PlU/LGbqQiK+R+X0yZS9M3LhREn2N8cpqbZ7HihkX8abK2nK0z7EKCTIaZPiPj1NX5b
 kl1qb0ZF
 +aHU6myslON5So2T1zaeUYjWf2cIQOKZZs7KUNkFRw0A3hBhy7trR3Z3Cxe1P8m4TMOqmFFs3oMv+jaOj/fQ1bLgNrD14wHsmB6pUsURaWT75UF5EXALz8fDtB3zk0Q+quOe0Q8qPzlcQrWywHDz3vJUwN+idRrFSBgllkxbBHDWCr26IuXSSycM0Utv2q6zbd2b673AnhrK5eBLnef/82MoL88o/ixqhZxXtmxesjMGbDVkLcw1wI9RnW2v1FRZZVhr7+azdYnXRCqxMrvKJRzilHs7KO4vs0aisN7L11DhMnWW8kEVFwACZD6RltyOT5xNXVQC32zb09rsC9x4Zgk3mXIpkJGl6RgKn3HinCmHZ4109f5lncv9VyiKgWVBqTPlLqRXP+iFuoyebDUhxibsqxcJ7XhQApOhqMvUQxNZSlrEn/atmtqyOAc3pcpmwL+1F2iJ9f1i4RFMBoh7PAn4cDlH1yVJst9iAx448Kfvh/dLxWoS+fUvEey9USv0OAiisyUgVXEq5MqFgq50iT+q5gb1ai9ZLqex4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e13d233b9967..75c876acf527 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3229,7 +3229,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3285,7 +3284,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


