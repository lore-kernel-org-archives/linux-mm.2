Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD31CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8626A8E008B; Mon,  1 Sep 2025 11:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812618E0084; Mon,  1 Sep 2025 11:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3CE8E008B; Mon,  1 Sep 2025 11:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 551858E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:12:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 030645BC50
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:12:05 +0000 (UTC)
X-FDA: 83841021852.16.19C06A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E532100013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:12:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eoDsL2rA;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbPxT+Idhc+6GwH6hstH+a12TgxrLcV9FQ+XUGXVJQE=;
	b=tt16b2BjrPhaQMME+WaAJrdW8fydl9z1LyZeQAFYh5kKA88XrYzKeEi0Bk+GU+T6diuL0G
	0DyjYNbO56mNMdfYuFUefypyWCK2Nc9VWH8fV/zeEifZ3ZTfwFZ4tvZeSKYgniuIrwVU7x
	glXZm19KRWhBoOViwTsFjs4vSGy4Hmk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eoDsL2rA;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739524; a=rsa-sha256;
	cv=none;
	b=soj2XnAofnFkFI5nSM8PFTdNKL8yjerZxBuwnXieLzvLkW0uLSzRizlf23mOrtRbP/n1g2
	Y51TQfL7zQxK92FooHCniv+lO51wWNyxdcK4wJjLRpvdowUNLHFsgNul8NQfBtt1B0emPq
	CsMv0T1TnTCJ6O5+kqcLByYDNMHT5gU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CbPxT+Idhc+6GwH6hstH+a12TgxrLcV9FQ+XUGXVJQE=;
	b=eoDsL2rAD3zYTpIDQCALRQcOrncxwAjGJlVm1RVYX952UnOmOOp66nx+h4xTMo3qW/5TG1
	lvEatcXRoHHPW7ihKV8OW6fpUp0ZL5yuaB/YYSXBNprZNZ5x+10+NDmJnIiTOB6g4iSvm3
	T4PgKYj8YtEnqi90SewODnv2rxt4914=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-FAlU1mU9OFawvMcvPCgBRw-1; Mon,
 01 Sep 2025 11:11:58 -0400
X-MC-Unique: FAlU1mU9OFawvMcvPCgBRw-1
X-Mimecast-MFC-AGG-ID: FAlU1mU9OFawvMcvPCgBRw_1756739508
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 773F21955F0E;
	Mon,  1 Sep 2025 15:11:48 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D0F61800447;
	Mon,  1 Sep 2025 15:11:33 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 28/37] memstick: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:49 +0200
Message-ID: <20250901150359.867252-29-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: qrp9hj6j4d5iftkztand4hwfj7anegsp
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E532100013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756739524-510670
X-HE-Meta: U2FsdGVkX18mH5X/4dAQPlRpUvWspOhyYJvy2gJAsEuRn2JPkTdq2uO/WyvZ8UV8NtGuTR22SF+jFu20yTQCBwUtRQu9miOZ/1ADV9R3NOsE9bgxMf4ohpcShYeqn1VTNktYY+GhA5tSHqQ6fpWmRrKJ6fbYebTuHoZJg0kYQ6dNx6y2Gx3cJI8KYJZzeV6KvWiwdM6BBiNvgnjnP7yE0q7htQ738mMfRdyx7T4bMo7HEFCNS0BsVslKSLFISvqDswH+mbIasduVgz83XQ5Uy48JysecYaomVo7ZfSFH7P6BXlA94t+7rkSldnKWcglgBOieWuhfXz81Jq4eOQr/ARsgkRjThwRekcbc1wP1LO3mC0GJsU/8vyxB7QbxQHHbPEg1JPytnmSYqlB8MwzX1WPLG18DkThPJrG7+ACLCQf5IlbzczQp5t2lf2jPD7aGLScC1l8tSJNBlY6ok0V1xa1j7Tv0XRsEIi9Yc6k/IkSKdUrPplO2+ucfQPogt6PRdZcNy2Pr8nOUps/gX44vsJWRg96Ky55ZKcfvsBRSbFkqR3/PZjoodqdAY8lMjR/3UYGeni16GBRcfMgCZRH7oSGAmfJLYD0YdkLOBz3rtautn90ee1lZDoAkBEe0LZFrNccE7FU+KNSLKAttkD7PjeD8zsQvP0mgmNgBjns0WP7K9mdVSEclCz9wPU8yZCapQ7+F3BXHlyekqntllNckgCill1nE5w6M/PJpzimjNIlifSYTeF/mPMWWmePOXoWiBp1v40t3cxYfNdApvay9geb7+o7uiMrnl2RfqGOhRyEAEwMe+zeX70V7TMDjZs9bvZo6Pzhl4fILKqSXNL8Rfu5f9tGyXy8JQ41+2yqsvh8fBwFBLMZNungwb3gkteRTLOBFl2gDXkEEoTWSzZNT+8YoRbsO0XU/bCRfh9uXsa5e5einkmX9P/QJwV1mwchazO8zQ1Gyg7VzHE6xs3K
 kUSrl/df
 GRvGLOqdcBaZIT/KFOjT8YdE6IS3TVJn564cjYu9kAse/fGrf8JExsAbAHS8pqMOQ+EswK9nJpxW7mLd5Ib0hzA/M2B/611hFykq7xrEo6LroFw6vRJOU1wz8NnO+kyqqKpZkNmj5eXSPDb0jCWR4q6yEsyvQWw9JTvoFZjYi5ZGMsxZHF/VdNGLP4c4scasn/Ls9Je1PeHnsHNhMgK9Ly8SKZBhxAGedOsOW2kH0iyCr17odLfqUDA9u0dzU3nqljUv7zLSntSBEYZ5KPJ47yl4xBDzPRGlEO97JmAb+8mXiyLw95ud/yMx2CagEkslgBnFl17u5E7MMLT99hNlczUo4b9vOh2ycbGKaJF660SfOlCt1zjAdYTqNzLt58ansMdD1gOhJCWBXatdsBxCqLgrQ+MMITVCvopKR6PSQOv5OGm+wtrGLIS/T8pQ2iFnLQlKgmFTI+BB/HxEa/kdLn20S9kMhth6DUaH2WsC3tkv+YVnaQwSqCJTjI1zgfuNW2qFZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/host/jmb38x_ms.c | 3 +--
 drivers/memstick/host/tifm_ms.c   | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index cddddb3a5a27f..79e66e30417c1 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index db7f3a088fb09..0b6a90661eee5 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
-- 
2.50.1


