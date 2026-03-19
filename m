Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2B4109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374CB6B0524; Thu, 19 Mar 2026 12:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CB76B0526; Thu, 19 Mar 2026 12:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262D16B0527; Thu, 19 Mar 2026 12:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 159156B0524
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:07:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4E4EC2166
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:20 +0000 (UTC)
X-FDA: 84563292240.05.CF3D419
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2ED1A140008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1UVObKH;
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0LrqNwPukbVTRMqo7ScJ39KrbqrXvptUSs0I1FXiR5A=;
	b=YzkKqZzrbnoCEC3X1KA4kjeJRw/keYKnvmO0HNsqkphcP5rWmiDeahYgcD/6Ul7NAtbRbE
	6EvCpJ952YWaCRcwPRgR7nfe/bxyPXshUIrSP95J/g/Dn62RZyDjm30Gt6nQgMvl8wnF+o
	5dBBIBZ81gotV/K/BlRnRG52OWq4jWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936439; a=rsa-sha256;
	cv=none;
	b=MHMuTJ7g1cWRY4G1/9TbFHRrXPTJWoDe3IngLEACQUAPyQGIb+xstZfXlfAV1PpB1z5ryz
	qkwEKA7QREsG+KUa98er0xoGNS6TPAjqhpUB2PhzcQmuK4e5CVdjH1hig459VTKDJwvlMy
	2gUT+2PvBzniU4cVbyAG7f1mpPEv4ao=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1UVObKH;
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773936437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0LrqNwPukbVTRMqo7ScJ39KrbqrXvptUSs0I1FXiR5A=;
	b=b1UVObKHsB9hKh4YiF2fIvqEVqNskHAIsi7HStTv1oKz3zvKHA8dtv1ZWzx6grOG0C4SsO
	mYXQl5IYOx4lc1iStWEtZxAskcVuF6DUNauB4aU2vWz2nLOlZRtx6UTC5bWp0rdDH/tk/I
	G+RnAeh2Y0d/EdHrIupkZFdwbCD/W6o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-D8vHMPzCNlqHQmQOB7Q3KQ-1; Thu,
 19 Mar 2026 12:07:13 -0400
X-MC-Unique: D8vHMPzCNlqHQmQOB7Q3KQ-1
X-Mimecast-MFC-AGG-ID: D8vHMPzCNlqHQmQOB7Q3KQ_1773936430
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BBA1195608E;
	Thu, 19 Mar 2026 16:07:09 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3172D30002DF;
	Thu, 19 Mar 2026 16:07:00 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH v4 0/5] selftests/mm: skip several tests when thp is not available
Date: Fri, 20 Mar 2026 00:06:51 +0800
Message-ID: <20260319160656.1480279-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 4MyUK0mSXoeEE0OG1Ke4lrbeLFYRio8GWDoKZKOXOGY_1773936430
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: ouyht7ehyex5ufari3f15p8dwf3tradb
X-Rspamd-Queue-Id: 2ED1A140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773936438-427362
X-HE-Meta: U2FsdGVkX19+ojAArgXXFURY55WUMJIgHBooILMBqZVtqZ2bWxPshGg7OTNdNTbo4y5IzkRma/RXeXK4mxdqjFPgJt8aW28VMtLe//t+UL2655rqXL/593bAgy6fqJQcxl1yjkKPivY4Cuh2echKI6GBNnJPAxTIEnA3KJqIAGcCoezNiRzkM9YUgB+avf+t8l7TIslf8RcRb99yP1tBDXtY5digmbLqfahvS+xviQ4+Y4Fotmbxgte0LZjHwSimJJ6I/40WIfaCWP8jhKhBhG9yjmSkvw5ZCV/J276/Aw51FqlwaZsDWkAkw7wzTGAUUXohgzWpSr8cKpWpNy5PtInoUuNd/tgFVQaH5gAZRKk9vyeKo1XtwUr7RARI0kOJvKWpNgkEDkT38IoThMumlWiw9vMhBHYXeUWzcMV3zKitjKUYjnR80ymFqZlPJUKu+n2MoGCNBF31l+E76Mr8UsR4WsfKJwUderSjbpFNj7UKH8E8Ci1BU/cZ05YY6ovqZtaxuAHxOApJzTc2Y+UyPCjEpIaR24SALbE4vKzJJzGO9IJgI/234OkcsBK99Z4SWb4siqvu7J1sZKpqCqz6nv3akWmydOGxfXgy7ayKxEP8OaezCOCewx0o5Nf86C0rjWRWDJogJJYK32ynqrE09Bds31eK8J40YdI03ThT6SZhiQGNDC644CNv1PxcCNATsy24gPOyiypMF+R6tlN8zFU0v12YIoyWBKasvXupkwJQ4dChF1DRuhd0kX8nkh/6RTZ2czd6HpXMRmNt9VXa5T/RdsGkOxBpRu8xD6II27Yeszbb6pCbUBHVCBLA/ENcIlg9QP0AXcT6GDpWIiIlYs4f/a/BH85tzwMF6XU4kCommHbWSYSbX36VFvrgf28X2Vnv5Lfw1XikipvFvgZu4p3TcVqhCE6LoPEhs4qBALZy/r4fIi5FxI1hpjC3TQPsqa2Q7Hf76CHiY3yO5yw
 xU83n1bG
 ws3khhcxMWZ4ZpYcUGUcSfgtoqlxYR9UyjxAmExB9/FXk/lmHBv7Weof4gH9XXZClA8QMdeku0vopKCVhEEdSZiD6zlcDAn2qBVqbkSjEIgt08Gc/zK+QKx4owoeJ5FPsoN71iW3yfmw+llCDja0g9xuZlc0OW3hLMiiOQ0hSB8PAaUvaZVtbgQqZWsWbtTckrfA4hJKNTFOYXeeWsvqKoZzjwoTMqbhXi/azy4G4MiFsb4BMWUHPSIqjNR2vPP5xZaBolmComuj32eoPjD4M62EB0x9AZ3vf+z2PQLyuix2dhLJ1gDsQhyXRGT8tzjlWHFqa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

Changes in v4:
  - patch 1 update to use thp_available instead of thp_is_enabled,
    suggested by ai review
  - removed reviewed-by and acked-by

Changes in v3:
  - patch 1 update commit message to show the log snippet with where the
    fail happens, change the 'false positive' to 'false negative'.
    Update reviwed by
  - patch 2 update reviewed-by
  - patch 3 make write_file to void return
  - patch 4 and patch 5 updated reviewed-by/acked-by

Changes in v2:
  - replace 'false postive' with 'false negative' in cover letter
  - patch 1 and patch 2 add reviewed-by/acked-by
  - new patch 3 to add write_file() in vm_util as a common helper
  - patch 4 removed the {} in if block, removed the write_file helper
    rename chunk in v1. Add reviewed-by
  - patch 5 move the exit chunk to the front of ksft_print_headers() as
    suggested by David.  Add review by.

Chunyu Hu (5):
  selftests/mm/guard-regions: skip collapse test when thp not enabled
  selftests/mm: soft-dirty: skip two tests when thp is not available
  selftests/mm: move write_file helper to vm_util
  selftests/mm: split_huge_page_test: skip the test when thp is not
    available
  selftests/mm: transhuge_stress: skip the test when thp not available

 tools/testing/selftests/mm/guard-regions.c    |  4 ++++
 tools/testing/selftests/mm/soft-dirty.c       |  4 +++-
 .../selftests/mm/split_huge_page_test.c       | 19 ++++-----------
 tools/testing/selftests/mm/thp_settings.c     | 24 +------------------
 tools/testing/selftests/mm/thp_settings.h     |  1 -
 tools/testing/selftests/mm/transhuge-stress.c |  4 ++++
 tools/testing/selftests/mm/vm_util.c          | 16 +++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 8 files changed, 34 insertions(+), 40 deletions(-)


base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
-- 
2.53.0


