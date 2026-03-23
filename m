Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41390F4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7743C6B0088; Mon, 23 Mar 2026 11:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74BE36B008A; Mon, 23 Mar 2026 11:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6895B6B008C; Mon, 23 Mar 2026 11:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 576CE6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:18:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F1195C635
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:17 +0000 (UTC)
X-FDA: 84577683834.20.23A5A5D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D56C80012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="B/EErfKT";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279095; a=rsa-sha256;
	cv=none;
	b=IPpnHr7PEqcLpAIb8HDN3lMihdNXoczGz8OSH1CmWWYSQqe+pFc8G1uIDyADYWOmaj0MkA
	UdyWKpnWdzOAw/MZAkB3S56nrkQXebSUm7YSbyZ1hu+SfoWxlQRc6fPqq4evWyWeKWUQs/
	q9GBhphTz23Ex5FH5ZU5SQ5jxiNfbA4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="B/EErfKT";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T9KzDyLK2LRxExt+5uizkYCxde+QVD6hfmZBmFidYm4=;
	b=OWh836L7fgE7NFMp+lesOW4tnrRKkqsGXvmy/2rLsyGvuPnfZh4LnXoXA7qD25PtbO16Qb
	8OazGyAEyOHyz9/iPLQHOBX9Z9sULuFJiOJfmz8ZaM4fHvytLUm5HaAjD0r775wZNCtmwP
	1TSmyLDH5mpxIyuEDkcY9DmH/9s4CcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T9KzDyLK2LRxExt+5uizkYCxde+QVD6hfmZBmFidYm4=;
	b=B/EErfKTl/NC2qfSWLiC2Cv7MTruuHW2yZQV8zhqsM8XRWm6+FplRX3TXLS49nSWCr6Hea
	wAqIfpvq+Ht5HiyupD7Ycp5P3H4AlGUEO/mt+dnP1eB1zvFUX95+qlh71jq30Em4L29WuZ
	+j10PVgx5mtXcRwg5OIRB10mphpOtzs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-6rlNJSsIN-m_ZjbbsoPUFg-1; Mon,
 23 Mar 2026 11:18:10 -0400
X-MC-Unique: 6rlNJSsIN-m_ZjbbsoPUFg-1
X-Mimecast-MFC-AGG-ID: 6rlNJSsIN-m_ZjbbsoPUFg_1774279087
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0E8E1800365;
	Mon, 23 Mar 2026 15:18:06 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3808B1954102;
	Mon, 23 Mar 2026 15:17:57 +0000 (UTC)
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
Subject: [PATCH v5 0/6] selftests/mm: skip several tests when thp is not available
Date: Mon, 23 Mar 2026 23:17:47 +0800
Message-ID: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: It4rEQ-Te8y3ptrfK9e9D8PAdtKcRy55NWCpLrz-r_s_1774279087
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2D56C80012
X-Stat-Signature: qx7p9qr8qk8nweut6uixqizzmoep5tyd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774279094-651090
X-HE-Meta: U2FsdGVkX1+wiYlqnjdbt9Vkc+tqOExgXlChU82LclVbGnoRFnGnvWjcRofJQIyHEBlQOYvepOEotJ1jRurcYMk+pAuZp6j1e8ZIpaI2XiJfvxbyGddZrogAoxyjJZegfJho6jJDaluxt2ECB5jlQzRwdFpiJUNVA/mnjfLDz/B6WLehB3C/6X18D+ZibgcZb3rljQh5YmQcTlKQsM7wj4U7GQ8NUmTs7Gr2796V21Snze4w9Svl0eIc2SL8murIXscSI6q9KnPxAOA/notLpYqs0cPgq4x2YwV3fj5gjgsF0xeviOP7gKNZnIG+PuFZhbH9jxX+UF8KjO9qVKsQvEGxEj8jngVozxeJu6beXOuvq9Iqns5vgl0yo701V1a/CgKrxVYtaCHYn1EZlrxn1jP27JdfpqduSGNgcLUDvb346KptoXZY+GEXuI4kjxHH/pSezEYaSkfOVTeh/OwofHM4D+HMAkRBrq4TNenDslLsqdBfMedJREAPOAWpFj/dhl0r9y3W+bav9RbY2Fngq466iI1g1xaK1ehgrOCcJ+LoePmLyk0NlTqwa/JVNT/MIUpIcWBuI8Tk/v1WrE4b+j657bFibnw83475Gd8+TsoHVS15kbrpqbLGDM8RG4BmRcFDCHoI7iYKrO/NIaZGjWYDePn9cxP37nmAOMr83aWJrVDbCgUTNSbYu2pat4s34zWyEqwBfWKHTlTOPbPTHgMgXAOZlSxqtQZzc9gyxqZWPl2lHonVitdozHnRETGDvOjhx/zw1r3mduU68/njKQns2uyhjCaNiiax16PyEM0CaW65AgxMu+q1G8rYx8KdOx2POKbXf+7J2Mq2TcBfowUF8ojNuwRuPGL8PduSafsrk23eJNvbJTefIAmt/m/wHH8Bgwtt40yr6pXtxxRoCqpHS5EAi747WRxmugC9TSNPTjXgKcPe+vznOOfCznyot7oghmMrdcxZrZJAwUQ
 TH3I4jXb
 78Z0+g+z/mRPRvyMzNnpHXjJyGzivIEqj5i6bZaAmiwIdYJMmJ/ZS9U81hsTopxGAzbhaiQ9QbXC4XpI4QGUyHuzbXNL/+TJp0jgSr1OhH8QRWKSFykXvyX0imwIwiUIiWT51o4oMBtu46r3DJfrk0enF59rVH8MrJRO9c3QkQcGlDKiG9bV2vqylv7uVJoa2WS1mL6EMPoplmTMocI8NBFm3nRNusigS8NZcU6FPnBXganIVjtd6fhUfG4brqQFcKcyZfWcmvYKqiXSXuzUraExbGpYWJHoXtooMp1a4GLcQExu1jXhYvSuUcCBkyFjKEjUg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

Changes in v5:
  - patch 1, patch 3 updated reviwed-by and acked-by
  - patch 4 adds new patch for robust write_file()

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

Chunyu Hu (6):
  selftests/mm/guard-regions: skip collapse test when thp not enabled
  selftests/mm: soft-dirty: skip two tests when thp is not available
  selftests/mm: move write_file helper to vm_util
  selftests/mm/vm_util: robust write_file()
  selftests/mm: split_huge_page_test: skip the test when thp is not
    available
  selftests/mm: transhuge_stress: skip the test when thp not available

 tools/testing/selftests/mm/guard-regions.c    |  4 +++
 tools/testing/selftests/mm/soft-dirty.c       |  4 ++-
 .../selftests/mm/split_huge_page_test.c       | 19 +++-------
 tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
 tools/testing/selftests/mm/thp_settings.h     |  1 -
 tools/testing/selftests/mm/transhuge-stress.c |  4 +++
 tools/testing/selftests/mm/vm_util.c          | 21 +++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 8 files changed, 41 insertions(+), 49 deletions(-)


base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0


