Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CB8111224E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E196B0088; Wed,  1 Apr 2026 21:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE4D6B0089; Wed,  1 Apr 2026 21:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED1F6B008A; Wed,  1 Apr 2026 21:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1886B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:46:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF2D316031B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:06 +0000 (UTC)
X-FDA: 84611925132.30.E5DCAD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0ADC4000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OjtUWImp;
	spf=pass (imf07.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094365; a=rsa-sha256;
	cv=none;
	b=qWRYKFsBgcuve6QHGGnBRr2XMQbe6PWcBeMjRn7aa7dHUloZ5YHT4598WmskrG5vFszUEE
	6zibyaulGW5P4644ZufGR+/volGtsWUR1mm6fV0WWo1YAcOnuDCmP/2DGy2GSDFt0FlkBH
	WbEi/jSRZGqoBUEk2pgo50zzrmLU60c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=l0Q6r9HPJ8aJ6iX7bMAjVKnNhKfShN4g1Nz0tMndmbo=;
	b=paoVlP7ObfMBKW86KveDRu27NEKBNpOJvdNCHKig2L7hib8TeXblFAyIUd0ARk9WHo9JVl
	98rj7LGYlSjJg8GqMkOjG1Q0PY8CPGVxox6DF1C7uelBegc53KZKN3nkIN4tPFCBvbk0ze
	u1minB8dfKz68QpoPvhG5H1rYytdivU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OjtUWImp;
	spf=pass (imf07.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l0Q6r9HPJ8aJ6iX7bMAjVKnNhKfShN4g1Nz0tMndmbo=;
	b=OjtUWImpnnehhPcqDh4N1ocTQ+qbwy5A/6jAqahDwXNxCyi4JQlGlqobeEDzX3+McwgQI6
	myvB81yn32RNKXXGFGJTQdrDSfs5JeILK6kGejtYKFnofyVSrmKuthrHJHMFeVVqif/m9Q
	oJNbZpsLalf59Ewl30jwOOV96IaF2Mk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-qsMjOyxJMNy_LXPiefNIHg-1; Wed,
 01 Apr 2026 21:45:59 -0400
X-MC-Unique: qsMjOyxJMNy_LXPiefNIHg-1
X-Mimecast-MFC-AGG-ID: qsMjOyxJMNy_LXPiefNIHg_1775094356
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A3171955F18;
	Thu,  2 Apr 2026 01:45:56 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7614C19560AB;
	Thu,  2 Apr 2026 01:45:47 +0000 (UTC)
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
Subject: [PATCH v8 0/6] selftests/mm: skip several tests when thp is not available
Date: Thu,  2 Apr 2026 09:45:37 +0800
Message-ID: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: LvRdjz2IULGaVQK8dtEOypP0wvxpi1kL9ZDUDnCXars_1775094356
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0ADC4000B
X-Stat-Signature: h4yma78w573umcpswozknoupomgmwozt
X-HE-Tag: 1775094364-740469
X-HE-Meta: U2FsdGVkX1/V0m8QZyvj+YC9RQIdSLkqvBerH6pC3jIuGHWYzDjkL7DLXY8Qe4NDVpirGE5cPa4pC+JmHyA8i0or4Vd1JmizIjRweJbXN9se8bchHy6M4xZ8ANVb9EHY9xcAf9XE7M7MjBpLkuLHxXBXGZEjB1wo67OpKe1q91UnBV2nmnAj4RWCbqlS41Fi8mQxc8nGb7PlGkxBS6rM37M++J9bELUr9onMcKQi0kGQRIa4ocZR408EaSbVin+n0VsG+tYPxQ/aLXjThPCQ8DkbhzbiC4JTirr0OsPC7F+UvU/y9xCePXRR0CZZgOHJ+h7lEe5s77yx12pEW/D50BtmA0Jjo0FRM7/f2JgMMxZbOxk0dsMjc0icc23VJ9ASh9sXefrTH6d91k75kTOWrLAw/UJOiZfgCeQ5y/H/dmPpWuSZ0523ADCp8xUe8aHhdW44+jVJKGqX5c7AK6slXFRiTMuCKGorXsgprarM5ocS2jVUoG9mX0pxeR/n1pKgHf8d91WaKbbJJGtnNrSIdNPWh2zemasNIyI504xX1sVjE2alB1iWaLobD4XKdx0dupzt3DVXyXz5zjmzKvlT2oqqTT/TsDfc+6sokTPY5vsPeG/6DCgYbZW7GSaT9bacqrqrggZuj6WJJAicfJxwC2G3wIqKy5vGEw9yfV2yj4eglwIls8kdY5HwE/+ZkxE8Qdq2jDz3Wd8epdw3XVYcz5XKTZWbl4U2LXqI85XjFFXd6NpULjYgNXdLQNeqTOngDVw/YKetJQOmtae/yYu1tjjivP5WrbdQAosVppzrjqaOneHBMiyAu5Y7s2Af7qJRgH5PxpyUhjWmXY8ZHESox5sXfQJd+QJoJ9Sgh0JdO31KfLSx5rLm98VNAXsqVpth+peDqi1pzNjtJCOYaiKGLhdkeTok86BpV8eDjW9Ix6ZeL4wyAHLOzL8FEvOdwWCzs3GSuV9QSWgTS2kH8Rw
 7cF1tTDH
 jJSvziVNvpUiLa/iEMCUVSIKaiABtUhGd/Ft5hfz0HBQgxv0s/Yexsajz5IibTb/ZCjn6dtEpCqE/Krj1U/IKN/1x0rqZAVGTbhGW0K8W57HjHEJY2+OVTiKcQVohtz8E4nmsb6lNMl+bpVI7xn4f6VBCi3j/nOO31q9B9akFf/7h0ZSmdMUOw1c5ThudITibTD9qJrTGFmxb5KAmj+ZTtShpLFiDgTyPUh5kVixRZVIILj+yicRTVOpld04edEIdK8LMIZ+VHCBW+itp6M3gYywM0HfCeEB/LLhZwYgJ072EkSDgrBew13Hoo0gXeliCcaIM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

Changes in v8:
  - removed the patch 4 in v7 (make ksft_exit_fail_perror variable length)
    as no clean way to do it at the moment and ksft_exit_fail_msg could
    do by printing an extra strerror param.
  - patch 4 use ksft_exit_fail_msg instead of ksft_exit_fail_perror  

Changes in v7:
  - patch 1 add reviewed-by from Lorenzo
  - patch 4 new patch to make ksft_exit_fail_perror variable length
    arguments
  - patch 5 change to use %.*s to print the buf when error happened
    Limit the buflen arg as 2 minimum. Check the error path (numwritten
	< 0).
    And use the ksft_exit_fail_perror to print the logs in error path

Chagnes in v6:
  - patch 3 add reviewed-by from Lorenzo
  - patch 4 handle the errno before and after close(), suggested by AI

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
 tools/testing/selftests/mm/vm_util.c          | 24 +++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 8 files changed, 44 insertions(+), 49 deletions(-)


base-commit: 9147566d801602c9e7fc7f85e989735735bf38ba
-- 
2.53.0


