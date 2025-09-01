Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10377CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A808E007A; Mon,  1 Sep 2025 11:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB4F8E0079; Mon,  1 Sep 2025 11:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411528E007A; Mon,  1 Sep 2025 11:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC1C8E0079
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:07:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C335C1608E1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:26 +0000 (UTC)
X-FDA: 83841010092.20.01602C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1727FC0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qy96MkBd;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739245; a=rsa-sha256;
	cv=none;
	b=OMxZ0z8W+rMziI3TuW6E7v3dOhXT3DV6X6FzzL2sAVu6lqTTwhzNG9M8GqiwN3z9HADMln
	DNz35MyTjQFuV5uuTD/PQAzQrrG+9/wKz/4YDd34H2eJZSS1eFvcDXmw9Ovc504wLYnJ/i
	k6IRAMQf4gjhZUnJd7gWWoKqUC1fveA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qy96MkBd;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFQCeV5GlShS/zx1bu5/T/iLUPYfRFaciJSmR65IujE=;
	b=KciuZVNcFVUGz2ipd9vhY/xSbfwB0axlsO7oeawrefDCAZ280MMBay+6Q+5X/sLgNxInhR
	kw0vxLu5lqTAZVWp4YYe2WmWQiOdr3dCynJIBgiRvw/9ZgBs6GQeJBheuRQFIkPawhTMH0
	Gmbw5MlVsIwJPEPfHlHiMGGaJhRF/Tc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gFQCeV5GlShS/zx1bu5/T/iLUPYfRFaciJSmR65IujE=;
	b=Qy96MkBd4IUKd1TNuArbRxmOmH6FfjlZeJSp5yBdAfTIIBbl2IX3entzod2lX/qYBtD3Kx
	BsS4zx+qzl3txchl1XjnZrMNmhunFKWyW0TWJOnfQrI8XxIHKSQmPWuKhb1ED377F6VQZA
	veCgGuFz61Pg3qI92H0RmO+YA6NWUbU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-CT1kZFJdPz29r0kFU6Fbtg-1; Mon,
 01 Sep 2025 11:07:20 -0400
X-MC-Unique: CT1kZFJdPz29r0kFU6Fbtg-1
X-Mimecast-MFC-AGG-ID: CT1kZFJdPz29r0kFU6Fbtg_1756739235
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09663180035C;
	Mon,  1 Sep 2025 15:07:15 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90EDB1800447;
	Mon,  1 Sep 2025 15:07:01 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	x86@kernel.org
Subject: [PATCH v2 10/37] mm: sanity-check maximum folio size in folio_set_order()
Date: Mon,  1 Sep 2025 17:03:31 +0200
Message-ID: <20250901150359.867252-11-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1727FC0007
X-Stat-Signature: mb1dxcrdrq9yck8qewgzdy93ka7y97au
X-Rspam-User: 
X-HE-Tag: 1756739244-577710
X-HE-Meta: U2FsdGVkX1/Q62+MLAjMWhlhmpp0qfE8nYpzakd3I/lGcMfr2R6x8YcDJo6EHK6WwMz28KReoABaTeYEgutNxnHrvVHl7i61WcxIDjXnSVTghpTDC2DvonvUQMrMEYxGlPZfbsobEnZ1Gh9VPFUmE3oSDMbvro9dw/KJmFuzyNxBK6a8RmcOJPd7Eb+OLstnQqWMa6E/nAmg2LM2QPoQEHCRQt5viHHnMatz0oRSDnZ8T7rWBa+OTSepIWEZBGUCZmhHguDgRaeyU4Ilu7RUSNgiiDA9tVLhW1zvjkr+Lz7Vr58yQ8PMmGfz0NE/iYGi9ldS5gOjaTDdSVg4m68iE9NN6Wavs4uW84wj/wtXOk7dL1+oriLBn/U6857qcF4zlfFDopo9NYTSpi2jPos2kCrPEWPhDQ2OV6rmnU5amxzw1sGuSN6VbIm//Bhi0/cXCUvSyRwdqR/aXxmg1/IPHvezWEZoerdPB3FUwNZCrGmlAevgerO8/169e8lfnqC2c2yIH+8OPa7NE1uCQfitJLcMOA4RzksygpJ1jV4EdBm5G8XRJwsok6HOzNbT50T6od1ZDGd0iEM09T/0J5nw/pfCRb8lLyK/Zh53DOekLy2lmD+nOB24+dTptoY776HZNy8c5UsEdX0GOynB6XOqgRzf0oz+7trSETr18Sub0K2tavfx3j+34xmDvGejizT/FFsrb5TsaYY2OH3KD87RWQEw0ZL9Vrn6SUqoS9w1DJ1KQiMEaPXKuCxzIaEEVNDJ64GWdr/oTZxC8TNhC6lT5rgsChuSA6E88QK9J6d63KLeNdy6olxQ+Qn8acmhCGzQz+l3KHF4ja1L5woZlVv7LFcprnqd9QCXyll/T7DbnDrh8QXiyfAg4YQ/SHoDjQAEu7XOTh98Fdm7cmJzeoc+LiGfvdD8c1TVQmoAaXY54MBS9tJ8rhlZQDyERlXZTpNRKi6BccApCuVFDYpZwh8
 PXA3yMNO
 WiJnESZj/V3psShPYExCb/AU/OmpQnC9m9eiPZf4AXoy4uImk3zcHnyYpfpDtUQfk8C/XQU/jWkJtLeBqX0Xdig3sWoCAJxBt153FdMrZRNAoLkrU6Rh+FVvFurN5kk11o8AvSNO6ccPt+xUgwyeyJmtly4XXKJDBeOS7P6vjqxHxwUVtRek9OV23FdNIIkotn1XNqyvv3fFVXpZuCLVDRfupjUECn1K3y4wmWjXLtyneLZs4tN2kZga3RU7O/7GGWcCOJ9KcBMz1s/LO+e+0vFYVLurHiubRN31GMT5kwgmSlQ0ThHWcvh6rkp08YVSAeq1LykJA555h3AyxaiQ6C9ljPRVwxeov4n0jgqsj0LHz7s5zFSWsItQX2dbdF1rHyHpEceGOP8vy7CTuR/H8+kqKVK+oel458OirCo5jTZDlmDJULLxG1tmNJpawyimjkBb1LBvZs2Z2aOz0mukvY6MCOckR8f6MHDhD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's sanity-check in folio_set_order() whether we would be trying to
create a folio with an order that would make it exceed MAX_FOLIO_ORDER.

This will enable the check whenever a folio/compound page is initialized
through prepare_compound_head() / prepare_compound_page() with
CONFIG_DEBUG_VM set.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/internal.h b/mm/internal.h
index 45da9ff5694f6..9b0129531d004 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-- 
2.50.1


