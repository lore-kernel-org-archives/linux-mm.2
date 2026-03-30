Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8EF1061B09
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68E76B0095; Mon, 30 Mar 2026 11:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40486B0098; Mon, 30 Mar 2026 11:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A561A6B0099; Mon, 30 Mar 2026 11:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94C546B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:15:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E15613B501
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:25 +0000 (UTC)
X-FDA: 84603078210.12.34BFB27
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE5ED100012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dLIBAN74;
	spf=pass (imf14.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883723; a=rsa-sha256;
	cv=none;
	b=0CtK1+VIZLIXWZEZkC0M0/xH8ev5rMRKlBNAcCHmiInj2gcfTIdW3ezF0LLqJgbX6/0XeF
	H7i/FS2Vw3G9r2qyjHhniIOOul6Ij08LP++VlXZ/JEaWz3LYM9luJtHzUDs4knamt6lrox
	fjQD3sy5vFJLSaFXZRVqtEMbOUkUabI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xETw+8gpCdkjsgRzeD0pmJ+bgMxkAEpJAG9tRxYLZUM=;
	b=J7exJLv2lU20J9GtRUjyCbg7SyiXGxeV1SzbMN450T2Pkh5rHvjl4FinTCaj5CRRGyMIgW
	XPpa/yPF9gmV0dOOojVlg/JBYEiR4S4FFCiO+z6zhlm5EyJKI+KT2Qm/gV0AwxE55kJWRo
	Z9AEOvYbzq3RcsFi8pUOs3r5yZM0lww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dLIBAN74;
	spf=pass (imf14.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xETw+8gpCdkjsgRzeD0pmJ+bgMxkAEpJAG9tRxYLZUM=;
	b=dLIBAN74RJ2aJcWC3VITZK19X1c5jXphjftTi2B4wo5VfeL3NednR9DuglMi2zQMX6EcT4
	+ONUeOFWECPdhvMER2lGzSMNrZafW13D1B+1faXXq8QSK0f0SQs6mBxzmK+LdFFI9uADhl
	Ol+l3VhqrzPVhtmc0QKU7Wm1gSvi5NI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-dC5UyRSYMXuiPYXmccF87w-1; Mon,
 30 Mar 2026 11:15:19 -0400
X-MC-Unique: dC5UyRSYMXuiPYXmccF87w-1
X-Mimecast-MFC-AGG-ID: dC5UyRSYMXuiPYXmccF87w_1774883717
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5476E18002E0;
	Mon, 30 Mar 2026 15:15:16 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30B5219560B1;
	Mon, 30 Mar 2026 15:15:07 +0000 (UTC)
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
Subject: [PATCH v7 0/7] selftests/mm: skip several tests when thp is not available
Date: Mon, 30 Mar 2026 23:14:56 +0800
Message-ID: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: nWZHnhds8D7hIXvOZNc16-4oNI-FBv5S1FppPR8lItg_1774883717
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE5ED100012
X-Stat-Signature: rc9a93rwgschkc77piw5esaotu1rnreu
X-HE-Tag: 1774883723-925744
X-HE-Meta: U2FsdGVkX1+A4FF6tz2Rn2NE8rnowJTYISJCI7d0TAX4/ELciADTddFwSUuJJx5Oq8vb0WQCigzxO2ofFqc+AAwyfri0Vj0H3cMAiMM0MQbeZeAAH8UbSwqpHj3XEoNngLX1QuHO2gkCAfuo8Po0eETqTjEbWNa0trTb4IZkfiFiIJqGEZjX/gVczf/SIqD6+vLZvBFxQHgAawsD8feE1EQzzaWQjF/Q8g+lCrg0NwysrpoUlrhLQJJ7UtdNKrWsfs8dMyPGXlmKBz3sL/2ZUoqo6Bgu/surEuPHVjU7mruNeufdqObokyRS4aXCy3NDH6xXueWvwF5nBpCfokYw8YNQfBo5z+Xe4/1+n1NIrtFZcuVtBavot7kKxyHu1z8A0MJbAFplOIT6eoJaQ6Jq93cBXXgyaCewi18a3Z3UazpLnnwHRelOWcElPolPhq/oFMUzGurRC2MgpqTDvMMlxCyNX6ihDpk9Qog92cBJnQrQnrMMYTCsW3Avy9LE6Zyy5AIynZSD2kXWKg3K24Li7XC9YrqWIpPK6BVZQBMJ9cKwNAY2/ArHJVlQW/xxaGQHRizU8ax0Bgf20dqt07EfWxqHl7G03xFmLSjkYQoRjxSL7p6D0G8f2osTUdhK/WbZf0NjpZz+deKnPUiGLO9jh+ag+8KQDu+6JK9barEWLOHt4jrqcMPcB4ed61ZoOdLU57nxH+WJQo5fpknjvH5r/Y0nRnkQNw/9KrTmw6Zr1pqnu6OYReYx1dSNARxPo71j8YO3/Ju3PYpnYtEJkgfPZHck4bsb98OVteyeFKl4r4dguv+Go7+iMzcs2nnuqPllDMFRZVw0O4S5t+LRijTI2kzGh4WSUrwCwdOUYj+3RBVItsaI2doU27xoOYbomcKGZxqjyBhZx0p8cs1OgHn56GoIf6tGmf78LqNyny2onzAWBOCspcKlk0bveamMq7Ul6vsNOanKPR/W5/W8J/N
 XMwHVaSg
 tjC+1q234+M4L2xN3HIo7/Ml5tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

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

Chunyu Hu (7):
  selftests/mm/guard-regions: skip collapse test when thp not enabled
  selftests/mm: soft-dirty: skip two tests when thp is not available
  selftests/mm: move write_file helper to vm_util
  kselftest: make ksft_exit_fail_perror support va args
  selftests/mm/vm_util: robust write_file()
  selftests/mm: split_huge_page_test: skip the test when thp is not
    available
  selftests/mm: transhuge_stress: skip the test when thp not available

 tools/testing/selftests/kselftest.h           | 21 +++++++++--
 tools/testing/selftests/mm/guard-regions.c    |  4 +++
 tools/testing/selftests/mm/soft-dirty.c       |  4 ++-
 .../selftests/mm/split_huge_page_test.c       | 19 +++-------
 tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
 tools/testing/selftests/mm/thp_settings.h     |  1 -
 tools/testing/selftests/mm/transhuge-stress.c |  4 +++
 tools/testing/selftests/mm/vm_util.c          | 24 +++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 9 files changed, 62 insertions(+), 52 deletions(-)


base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
-- 
2.53.0


