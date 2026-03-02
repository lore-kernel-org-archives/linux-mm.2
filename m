Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F5EE9B35A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14796B008A; Mon,  2 Mar 2026 05:40:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5696B008C; Mon,  2 Mar 2026 05:40:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAFE6B0092; Mon,  2 Mar 2026 05:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C03EA6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:40:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F94DBCDE3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:44 +0000 (UTC)
X-FDA: 84500779608.04.565B4CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 62801C0004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aog7aCLr;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772448042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH6gWAo3wpTsdLSXH1KnsIBPkSak0VzX5WEe8661axw=;
	b=2kBkRPZr9heh3+IkNilFleqrlOfVhQsop1dpT2Lwg2dsMzRrQPoBKLxgkbk8PR5f0ioOmY
	MA1wSS26b2jQ/LTsjR1/aqp/1NUT8OvhS2eoXxo92qBsb/XmhIZgVDFyv5HsW6rME5VL9+
	9FJKDO5kytHvkHeWnKo2ko4cyplkJuE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aog7aCLr;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772448042; a=rsa-sha256;
	cv=none;
	b=S3P25EJ4CrNCYFstHxLh5vDuAfz59346vAjw/PpFMn+zL3FssurGatkNAs/wikLW6VNpAO
	SIxLRpXbhG5GewMWeJje8smpvPGT7xKWolohh04AWKskeUCAF2QqddTa1WzK/mLpGCJq0s
	3hLmrRVx2QwCsN5YshxBMVgeTcNRVwE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772448041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nH6gWAo3wpTsdLSXH1KnsIBPkSak0VzX5WEe8661axw=;
	b=aog7aCLrXIjpWNs49Pd8li7T8KSMxq1jbYAFKXM6JWsIP6dlSn6LnvRX8DZTAx0vGDNQp6
	amcvx4sjJtF6x/CiNr4Qy8PSQZ5iJcGsqs9J5zRs6Ajn6RfqCVKnV/oZlGkvjjvoTmKDyt
	qOF1di+y+vzi775HFg7n8PNOmuqYB0Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-sva0Te74PjaXnWHGKQISeA-1; Mon,
 02 Mar 2026 05:40:35 -0500
X-MC-Unique: sva0Te74PjaXnWHGKQISeA-1
X-Mimecast-MFC-AGG-ID: sva0Te74PjaXnWHGKQISeA_1772448033
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCD21180057E;
	Mon,  2 Mar 2026 10:40:32 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.98])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD7B030001B9;
	Mon,  2 Mar 2026 10:40:26 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Date: Mon,  2 Mar 2026 18:40:14 +0800
Message-ID: <20260302104016.163542-2-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-1-bhe@redhat.com>
References: <20260302104016.163542-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YjcRLhPhP00iTx80EoJENZf6iCXr5bkL1Ci9bZ-P4eQ_1772448033
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62801C0004
X-Stat-Signature: 9wcrd3dfr9dykth7i9nwucp6iw6i7ydr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772448042-105265
X-HE-Meta: U2FsdGVkX1/zvWNbv9EwE8Cx/3Xn7kMlZRAbMcTBjHfD0aA5DbsFnU+rUqRpcJ0wcB8OwxQJnZp1Z9IB/QQBIt/Rs9zxxuph02KogzkuYe9g5YQamaNaeWZt6p293zTkTOdDIF31Z2Moh5omK4VuCkkLNhmxQGmqmQtksBJt6UJTwdi5uTdtxXHHPXd2hjXfm2OKBOXB+Ypi/08OhDaMO2JsL2zJTMJ1Ut/ndKI3Y/Vloowe/vZQQayXV00Ay8asQoKchsT25QLcwpCMF2UL/udmHWJCwG9eB8jBReSLfWwuLx+i4d0jfIusc87W5cVGwRPxS+uL5YfFtQzjukJL4EoWR6Om4RUN9jnAIQDELrrFf5Wk4D7cS4WoW9uAapsTSs0TgdV0Afgs7IzSBggQhEWD1ohm4JGyl9Z+Q6rSmCpIXNWHT1DrQtCvc2VK5g9wmNdjG6jD6T+6/fVejPkEfA20nfNMKR84hn0OlB1ZR6OSWRUOf5mqII5kwHrtdl/T8MKuqwdXlAz+VHN29jF8yMI9OMgWHELRa0BFWHpRouBZnLpTDaOYhve1Vqpc6TWbOlAdHPWBSGD/X9T0a7dxAohx0Nma68ixVtDskpRzhawB2mQ3bZboVUz7wlvF7SS3nxJO7Mjg/+saHyqHM1BWF5QJapdlMN96c7TMtYmbecjZx3kyi2mhy4gv2V/rDAX2z7x1+YKDbGsyDIUv/yirgN402Pwbo+umEpdBOhfDwmtuQPRfH0Yn6DjoRHKZ0NH1W4pgqtZkE8M0VMlIFzxWD7gRy+URkl8YJR/JN00BHkI4n5y89ha6MkSipmVAEjlIvb45j9/VTs466PIPzPT0mEEJaHx7ap+Jh6lE45jpxdF2S3CFkw0yGzsuPA2J51cqjUtQDrHkrfbmMEl1dYd59Jdy9baC1w2WcUGhrBylavuFHTQOlTU8uCg4CYBE+lBZh5cjXnEJsjlPIBxkkom
 lmNm0b7t
 dlvgYV8DFhr5JaV8IBb4GZjuDxH5llMi7tCHOdIWUe8xJcsbaTKNgjbOo6Y4RHwohD+IXt7e35WiRkwfFzfhSnu0LtWDbmdYUsgw7mksDpL1GOiQOBDpmct1h2GsUXYTuLsFX2J/f659cH2OLFijOhORswMfzz5/Bchgi5SFPhy0xwll57txiDzYJo0Yd+snsRv7rtS5Zi6anySh6IeOiO/fX6yc1AC9/ifNTd+T5t9wN/pjGWQBW5F988ozkvG7GyeVE8Q97KVU/jTHEuZld9dxxveqezekHYz17DwezSgH3ypFFGU6mY3LW/xyf4nW+Esg6GGYU7t3rrP/i/MqoqZ6reQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Codes in mm/page_io.c are only related to swap io, it has
nothing to do with other page io.

Rename it to avoid confusion.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 MAINTAINERS                 | 2 +-
 mm/Makefile                 | 2 +-
 mm/swap.h                   | 2 +-
 mm/{page_io.c => swap_io.c} | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename mm/{page_io.c => swap_io.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14899f1de77e..6ff65f8bc27b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16945,7 +16945,7 @@ F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
-F:	mm/page_io.c
+F:	mm/swap_io.c
 F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..a65ac900096a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -75,7 +75,7 @@ ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= swap_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b..161185057993 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -214,7 +214,7 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 					struct swap_cluster_info *ci,
 					unsigned int ci_off, unsigned int nr_pages);
 
-/* linux/mm/page_io.c */
+/* linux/mm/swap_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
diff --git a/mm/page_io.c b/mm/swap_io.c
similarity index 99%
rename from mm/page_io.c
rename to mm/swap_io.c
index a2c034660c80..d1cdb10ba133 100644
--- a/mm/page_io.c
+++ b/mm/swap_io.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/mm/page_io.c
+ *  linux/mm/swap_io.c
  *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
-- 
2.52.0


