Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 898AED58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD5D6B00AF; Mon, 16 Mar 2026 00:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80C16B00B1; Mon, 16 Mar 2026 00:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C616B00B4; Mon, 16 Mar 2026 00:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8505E6B00AF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:43:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 190AB1A0DDC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:43:57 +0000 (UTC)
X-FDA: 84550683714.12.412597D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 234F1C000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:43:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bSOXQFWp;
	spf=pass (imf10.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773636235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5bromE0Lb/4AXZwonjlJ3gcGLoMNIPlz6OjkLdJzlFc=;
	b=QYvvsdGnU5KtzxPiVxjcZm0lpO+6soA5w+dKbn9jIIS9GgxjpXFOwZBwOi8O0fNun2LLb6
	hTpKsmU98qaursXhiNbqy8LT4UZmwM5K6f+2daJIDrbanVxKZlOzPnGiofht4BGYMt6GK1
	jxsFZqzp5AoNGl0cFSELsHKJJrM2Erk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773636235; a=rsa-sha256;
	cv=none;
	b=fUmyoDdLUC0yW+0P88OLO/OQUpIFArPJuqV01cpMoF0OzQ3J3tTczvxNR9M7KedyHA8iqj
	Xlrew+1DhJLS8q2MCSnS0w4+yout6h8KYYZGi2ObCTxuI/3PL62LeUpsk2QkF5N5QpD8uP
	yG9/07R6//lmk40+uf0HJ2+yrB0HFXE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bSOXQFWp;
	spf=pass (imf10.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773636234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5bromE0Lb/4AXZwonjlJ3gcGLoMNIPlz6OjkLdJzlFc=;
	b=bSOXQFWpnxBdCAN+3sfR85W7Ek2d39BnZkUBf+oW5N7AHk46y9iFO/4upqW+TxN5wpHDfw
	g7MeeeUEYvM3klGJnk+LNHThy/SbVQnrt46KuQ/no8DwqzJ+2IPevGSvPijD8TFm85qnAm
	lnrNjGujB5S+f88XAuRhRWyX54xA5xc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-8F_wa5rhNq6fKYmb1esTYw-1; Mon,
 16 Mar 2026 00:43:52 -0400
X-MC-Unique: 8F_wa5rhNq6fKYmb1esTYw-1
X-Mimecast-MFC-AGG-ID: 8F_wa5rhNq6fKYmb1esTYw_1773636230
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A43D9195608D;
	Mon, 16 Mar 2026 04:43:49 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F05019560B7;
	Mon, 16 Mar 2026 04:43:40 +0000 (UTC)
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
Subject: [PATCH v2 0/5] selftests/mm: skip several tests when thp is not available
Date: Mon, 16 Mar 2026 12:43:30 +0800
Message-ID: <20260316044335.1390608-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: vO_Bktu2IjL_g7L_MOwiIZetv6-rT0SkJUROnuJJJRs_1773636230
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: yqf7nrkx7r3yeq6pnrnxpwsodc9ezucx
X-Rspam-User: 
X-Rspamd-Queue-Id: 234F1C000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773636235-496927
X-HE-Meta: U2FsdGVkX187KmOoTd2vJ0z8DA3Yhg2P9Qzt3wChK1+LhIEGY62XVrYOX+cFPamif04OyZosgGnOouPHStAloAErl7g073tmTNrj7/QbnHO6pdZkrdOExR5/LRpeVE1oRLk3iXPFZmj0PvoM+/Bm4sVQi/Hla78GQIitdDkI+eEtRGLq6V3FZBuT/pC31KTCtR9PJ1MwSZsKbUeq61q4vJ6nPtrnfE8ORG9+qJQ7mNwQsEI2qiYVUn0X8S15y0oDhqQDFb5l7MhkMAtBjsvuyGdw7iSfk6nbVqiiwf7cRYJ5wTVWPQ6+jo2rzWRnzxAIPG0Sc2WAYljPHHi+UnWhxebKzpmb+Xj0wUpuQqFD5dJ+STKmW1Hy73TrqElz+guUnzo2gSE/0+a6HzWuJMjQeEYEaatAYT60itmZSZhPSzxKdohCVf3r9Xr0nHDMvH+fl0m49YKWnsK5U5JnxyYOZbXsD678tM1K7P9ILemOK28SYyAbxsFAOqI7aDzx2khP293UEmELJNg4dK/nCFddbi0Rnih3LAMtKP1+BQJMzWA/uNR7Y9LPHTdbgu3RtoyI/o4EaZrNjbBJwItNyFtcK3AU/V3ehfamivq3K763S6uf/3Z8QOD/hw6JGLaXywES8qmcH/BD4u3Y+RNVrIvcIjb45FsYPXcKfi58kaGN3vmYsXPKpGbBhzFtPpRvwYFQD8SdLKJN7Av/YRgjkNiEAbYpmQdcrdjEFmAD2l/cAVcAxr1K1y0Ul+X5SOE/yJdtbIfDgAkAJboO5GXsEAv6IHnqpDYD++/KZULvO2y2pkiF+Pq6MPknlG+6YppWcnfvS0ituH3ZMW1TddhSaD/ygOt8be4XbMXQVxkmfXCTzIgH/Eq4rVHlADgs+ds5bTL8QmsO5iyczudZH632fqK3N1UaKNn/oUvIWn4og07VUQhowMNN6TtIKwCN9HFe8etKem9SjoEJHTKkkwZNkg4
 CUm0VP5t
 4jl7rXsFgOS8BDUUx4ohaWgkKQCJGwLx3V8YEruSTaHtACiLZps9JYBeRGk2g351mha24yeEM/oSUcCCeyZ0i2IPf5FJgwR4VchjXGaxSWLI8qB4fYQBqi7ay8r6kKx/1Nkq35LBGsuAK9rHFY75zrfLnijFGIu601HYCYhilYU3Fk24RO/1dUWtv/8jX+2xIeZ5kJaTJfh7xSvuCfNlWkRlQN3HhpuboFyML4vEgt8gjTMa0nD/BOGJ4EK1R5H4S2OvL+6DI1S+3J3UHDRbk92D++a7zMGnbpSQmjRT9GDzinuVkMn7HIiE4WOKa6PwUWe5j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

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


base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.53.0


