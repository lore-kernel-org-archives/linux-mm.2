Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7C8FC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE806B008C; Mon, 30 Mar 2026 11:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6446B0098; Mon, 30 Mar 2026 11:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC396B0099; Mon, 30 Mar 2026 11:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69FF06B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:14:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0683FC214C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:14:08 +0000 (UTC)
X-FDA: 84603074976.14.1817344
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F83140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:14:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGgDu9yg;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xETw+8gpCdkjsgRzeD0pmJ+bgMxkAEpJAG9tRxYLZUM=;
	b=I0YpYdnOL8P5jb64GgDqvVOWmVgjTmrmI+RzBiO/SzwPAnyjfbj4lwvmTGy9OvkaZgcG6w
	JFPOMUltJ8bTZYZQY0GWiNV1QQ+NUE4l8RVkSHzNHYmLFoDQloDbOCVMJuPqdrOqKGp/du
	VcACHgs53VYdznpwL5HYt00LBWR583g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGgDu9yg;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883646; a=rsa-sha256;
	cv=none;
	b=w128fwMFEwo3KjC5HSmA10C50mB0MAhkDdk8ndlrjihFo6nCJDrQPyLcYcU3XKaCS/9Ctc
	79HAZS31iUYMfRMXjS0lPbF+PIOTfuZBsyMz5B6O5lJHi1iUOwu5xp+wAgwtVjh5Snfrgh
	3RyQlRYgBD/f5tdCgVbgw2iIb96c6V4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xETw+8gpCdkjsgRzeD0pmJ+bgMxkAEpJAG9tRxYLZUM=;
	b=DGgDu9yg+OPBKEn9VskrCaK0z2t5OH2boBrggh64U9T0VLTf5yBidogP/3kOPOc324AT6G
	StuAFRevcIB3msNF7w2DvctIsQ+CrbA78P4W4ls5UAEqZcq69C0C1mms9jQFXom5pFn2Tj
	Nd1BEcp+7VmCAaMN38qLruK/NQ96rX4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-zM3py8vJPpeXppRVtmLw2w-1; Mon,
 30 Mar 2026 11:14:00 -0400
X-MC-Unique: zM3py8vJPpeXppRVtmLw2w-1
X-Mimecast-MFC-AGG-ID: zM3py8vJPpeXppRVtmLw2w_1774883637
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A885E1956096;
	Mon, 30 Mar 2026 15:13:56 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4AAE30001A1;
	Mon, 30 Mar 2026 15:13:47 +0000 (UTC)
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
Date: Mon, 30 Mar 2026 23:13:36 +0800
Message-ID: <20260330151343.670374-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: upk7oMxo3vUpZrr8aRUl6ifs8aRaCCQMn-kw7GQuekc_1774883637
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 3F83140003
X-Stat-Signature: rc9a93rwgschkc77piw5esaotu1rnreu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774883646-811408
X-HE-Meta: U2FsdGVkX1+96ABRtBAYGQIKT4Cip66QWV2vHWP+nrn0fj5GyvDWxzjTH7Sl/QCbGQsFM2wIyEKkLkHW9rZUrrPGNkMq6Hs+0WSaWyVqN3826k4CWx5qumD6wYf5RuMfRyW+ubmE9vlfkTF8QApJKu6ZNvxxqUYQvYgYaUtOoWKi5TkBAadAvGyOCNBZFWKFFON2dwbh1x05fIomgwktN1FdqRkTDPXTjwaMBo3LEhh91uKk7n1FSt0mjai2/ikNavJh+xwHlzGcbA4X392yx8T6osaPy8Ku6K7VzYPX8hVnVR9+f5JsgI9lMzeJfbXHF1CekJeUb81Qv195cz+UVXiU1n43AHv4pbZeKNQEfS0lKxJitL0tRPV/HuMHW7jqdwmr6kSkiuHGJ+5C1QZoSCR/Svi8B25/ddEXYAcl3ce3uBOK3Pvj5X0kVq3KC9WgOKJQBzQMz+vYNvcU09RZnjp3bHPjlJJb4lUVlysBcuaMk9WItBHCPNsOg2sp7e4Kna8gIQBzjZLz5vBH/1kVeIIImrqAS4fkY0nXHPjM+BJsOYva5ZZtZ/dcVzWUlqiAdDTgf/o2qiwqyt3y/iNmQTC2uG9S22n55W2P1qRQJv92WU094VcD0zfmjW/Mihl0bdLZjUjp04DXEclKVIHNOIBXIRfPAIXNLuDc0Gxo1C1Pr7ReFWomHuP3OHR2UELsKsdNe7UA6yG9yOVdhiw+1W6fApusDkzp+Zjgi14X9jzW9iyNixIdgIOpJNGxKYiXNsVuBZjGc/zmgoh3AqUckJow+4eQzQCK7Mq5TGMI6Absmj9bxnAGvgsQfKqqkwgeMjgILhy1xMWdAPUGMbJVG0nbC5ffPnmRLcAQ3Gjr7bZ/2SlQeTBGUYJQaRzlJfw8NojuthE6gvXYDuxDAfNezZFHEqibu6dGHkYsBxzFloCkcWAw6T/GVW5iKDnFTSt7POBxF1LaLxg8x/ooMuc
 TyP9PBix
 yQRZfrVPjamVqd6ELf7m/rFaV8A==
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


