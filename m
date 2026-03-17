Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A92F3382F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF20C6B008A; Tue, 17 Mar 2026 05:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA356B008C; Tue, 17 Mar 2026 05:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFFB6B0092; Tue, 17 Mar 2026 05:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B03F6B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:44:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41E19C02E3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:44 +0000 (UTC)
X-FDA: 84555070488.26.46CF388
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3ED4B1A0011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TAG1tnxK;
	spf=pass (imf19.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c8GlmATBq0zxhVHV+3sWeuVgZ4UPDFrGCjDb3oe3T+I=;
	b=duCqp4uWWtMkAIiAaxy5VlyynS8AwsWMZFygaSWsF6KBEGgQVM2Xi/RJSiX8yKfIGprn9Q
	MWsVu+5CRCs3eGAGPrg2LkT4l20NnAIkMlo79YJqOGj4IEdOPYjaDCWZ09RE5p12UcK7gH
	XX1oPMxBs4u/xd0ZUIcManXv006Xtfg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TAG1tnxK;
	spf=pass (imf19.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740682; a=rsa-sha256;
	cv=none;
	b=wE4jH5Xwf1lz1tX6QrnPIZvUdffOeInT7pl2Yw2dQmrJAGT/u4q7Kf25B0aJkSPJrjvH+A
	URpDNIqkyuRfRf4vQURQhhkUIgm4XiqN29+xuAWP4FMMS6rSiosH+6boAppF/Dl2AyuE2N
	qXaikAxKKwFqscuG0DqPNymPyssbT/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773740681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c8GlmATBq0zxhVHV+3sWeuVgZ4UPDFrGCjDb3oe3T+I=;
	b=TAG1tnxKcxQgAz/fRXuLkGRdNNHP3w9iZp1nJ+MGoX0BOsk50HUe6CPkIs3k1Ujxi1WZWE
	z0uxUP2oP+bUSPp7D4//4Wf81kLAmw4hECBsw7LpdioUF83GcP0Ue/5wwpsgYy9wW/gRyY
	q93bKndQwCsk4Sy0tUQpB/0tIs3Qff0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-IBhb6YRVOZK4LFIeCThPZQ-1; Tue,
 17 Mar 2026 05:44:35 -0400
X-MC-Unique: IBhb6YRVOZK4LFIeCThPZQ-1
X-Mimecast-MFC-AGG-ID: IBhb6YRVOZK4LFIeCThPZQ_1773740672
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A622195609E;
	Tue, 17 Mar 2026 09:44:32 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BDD73000223;
	Tue, 17 Mar 2026 09:44:23 +0000 (UTC)
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
Subject: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not available
Date: Tue, 17 Mar 2026 17:44:14 +0800
Message-ID: <20260317094419.1429259-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: z-EG6wrSXA31diQhpnQrky0SF-jJCjrkwjdLPngU6EE_1773740672
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3ED4B1A0011
X-Stat-Signature: u14qpx9sn6h9o5ts8kzxxt9mor78cbgh
X-Rspam-User: 
X-HE-Tag: 1773740682-190151
X-HE-Meta: U2FsdGVkX192M7ZJBc0JJTEKdowa33YLNgxRADz9Pfa9OGQH1pJ1/WDAg7I13n7rnhk6hD4Vcn1f0VLsfHw6laW2TE9Co/TfDyqQR3hRqTuCqlwZNeXL0ItmaLmQkRsGpr56KMEjNLTKFQQ+jGEeUHZmnT1iWz2PiErRPA8LZ7DPkIITCxgIMnv6ctu40Zx4mbvVguWYnWrH8X24P8596RZb/brYK/O8vZ5llYj/F5wAdP7SvsocagbtXnuvkRco+dOiY8DXVr39fEo4ZHu5LDAdYrL+Y7JvB4NCczrwlb6mHAV1HYesv2yL485WR1Yp+xLmiltwmWRvtBZ0cSV3ZWO6OfJj0L1Cn1rZiuG9qxO5u7nBxMT6bdJaWY6xQDvFWCkN82nT90Gm+2bas6EwqF/Ws8+svCuIq6bHj6xghIIx1cKDQZUkjve1fhiy2fbFiWXLH4UVafl8yN3maoQjfBrUfkTLWzRk8K8VZ/GdGDNRx0JjDfJ0y58RFYNy5W+filHW33Trfh281sjqDInWr+xnGgd3xGe97GHXtK1c5s4KpE4j4ya7EFFDZ5NYg3nsN0Zetbg1GYT/qs1kb4gvkeAyid25YOlTWAZcHZKdPO6LndnugfzsH+uEDcbp4iBC3Txhw9pS3uEYpsmNpi9DUMPKQ4NuAswK3vi3SN9lnK+pyWmY9oYDoV/0YH8K2Kn/Q0k0jlNi41rT0GR7LGkdKdjyNpx+jYeLS47tBayaqFVXnaksxX4n1bt5kaBq25dd12X+M+trXrUbzqrPuWlSfRXh4BsZLBxcaBjxOpxAIniql3S9uBTMBsVzhLa/hjFLDSUy5aUrjjh2lH+yryj84KEgWiQK8Hjke5TnIhVSPQLCG1iNJs77TDPEA6oQzeYoprqeiZNGd9TF4rmcNUQt2mFxULrfyUJ67TMVQIFgy79PuU2rZZOBilID1L6PW2qADzbob7U1lPEzfuvlVFH
 Xi8Naj9w
 lAqnGbrq4TdVheL9Xs/4Gw4HA/lBlokzHiuIaLnW8LWhtL33bfUiIrV2Nec/D3l+NDFrRpoT1CWQTB6NaVRP7nEUTvy5qb7RzEX0e9xafeMGJ8+newDvG5R8Mi1kmstXqOFoD4mxesfZFTl+Xfcf32Wq6npFOF2kBu2q2WbWDu13uOlHGiQxJHvj3YimcJg46YB/ibk/+I4pQc+jmJ0z3c3zAnEwftoospU3dLRHI8d79hx1oB19zZNMzUQMSe/srAUK08qSaU+waG4FgufAHQ14Ct8LSzxY09l91YSHHAcmLMq3pPZiLkpqf0Yv2LCW0CtH+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

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


base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.53.0


