Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF969FF60C1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7D96B0099; Tue, 31 Mar 2026 00:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141DC6B009B; Tue, 31 Mar 2026 00:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030226B009D; Tue, 31 Mar 2026 00:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2B746B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:02:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8359BC939
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:33 +0000 (UTC)
X-FDA: 84605011386.15.E9163E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF40640006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BXMlbeVF;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774929751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxDRoVyz2HRzp4YgRHoGs0Z0VHavzt0gkcpBjOPrbJI=;
	b=kv0baoG4zrj00UcDpTpbp9Bd4hgw7gZzA9XwVQIjZdVnq6lIuR8F11J0H70EhNGTn16E/4
	yGgfsEIo4MvRTMjPRv5yqMGHRsxshqQknxCDJL8/lzCEmZiW/m3yFgT/F3UYyao17IGVZF
	HClwlIugnjRlz32FvkaW89GGCPqI9Lg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BXMlbeVF;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774929751; a=rsa-sha256;
	cv=none;
	b=ZNaQ9pEfCCvixsn62adjwhKy7qL8SmQqduhSdxOet9KnOfObvXRltZCYzjQcBMXegBumvf
	8FXBNsPOw6U/hDCSNXV7DtEfNSHm9Yl1ny9ysDUiGZwZbdrV5Y0xJVVauFiHv4EFyjIofB
	O7Lf8xYKPS0NmnUyNOjdymuc2oVxkKc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774929751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xxDRoVyz2HRzp4YgRHoGs0Z0VHavzt0gkcpBjOPrbJI=;
	b=BXMlbeVFR+YdwNkTCcDcYip0TnCzvI5etj91hcW0+hzRsTsczKUBkAPG/FVa6d/iHP0iAq
	1MySJiueqf3UfGB3olaKICEoOQHTpI0BuAnAd7iwaLF7tFsm7QwbXt3laQvB7FCaQ536+D
	xZi3obLFl+fAemvfaOfeCglfIVLnvWs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-SmUw6YuZOKCNPKr_74qPSA-1; Tue,
 31 Mar 2026 00:02:26 -0400
X-MC-Unique: SmUw6YuZOKCNPKr_74qPSA-1
X-Mimecast-MFC-AGG-ID: SmUw6YuZOKCNPKr_74qPSA_1774929744
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E0E419560A7;
	Tue, 31 Mar 2026 04:02:24 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 166BC30001A2;
	Tue, 31 Mar 2026 04:02:18 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] selftests/mm: fix cow/gup_longterm link failures when liburing flags are missing
Date: Tue, 31 Mar 2026 12:01:56 +0800
Message-ID: <20260331040156.119158-4-liwang@redhat.com>
In-Reply-To: <20260331040156.119158-1-liwang@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: YfC_WdApSGTFiQHyqQqN_FP3cys5NgJHWzt2PY_YiaI_1774929744
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: BF40640006
X-Stat-Signature: 5inpsmfz3mn5pyjom57hrnkbtxro1hwj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774929751-169966
X-HE-Meta: U2FsdGVkX18js/04M+njPmUIvzvRYwf4r/ZCHpA4kpi2y0bXNGaaQjoaVYuq9LpAjzC7JytL/+I3tdTd4+xglaGa7Rzb+Tt1lZT70xpzVsYCDnJAn9iGvtYAwmIfCUatLzz+bZRwRFsnRSdjYheWaasiFQTTu75AE1K+vJVsckTxHHxJVWTgzwfnepMlL24Q7HVTsTDMQdCBuarswO/FnR4yWZvuZ1pws43/oAhRJEfWAx5UM+o2rhhWCCe66+OdXL9+ea0MjX6DyNrRNsb2Zqvdw3M5ksuQVTtwivcFbFsI+0dT9fcyVBtKtXryZdKrR7K1NVqDnfzXppya0jOjKONl3Y8UHl4PGhigcfel2GS5zqOkS4N6j8TxxO/TIdX8WWCkPIxS6ZtDvydGzWsRNHXbP35LRT3sDXjEMQhInx38lE5csAs2HpJLssyWyAACQiA3vaDHLNHkzMdVjXFAGFdMlkF8FHXzVRHEWt7ARsEhYZ14Uw3jprPPJwHwBxQFLLGgXjQZTMAkPeGs1OqCCoY+Lo/MA3I48zYsezsORl4fikoTWATi+W3TAq/HJzDb26/9PxvMCQHy/1A8mjs8zHE2Ud5MxeQIfBM9U+QrlPSleXvrkuHXb3msZvqMZ+ICXYdetgvNQfArIQD6nUBzS69qI9bQTAgDGLNh1bwwEOAn+ejurBIPtxp/sIxBO4s55OZMfzDiNApBTyE/+HcNZmNEiUDa0gt3Emw2jvQfYqKctO7Xn5daAYOcKU4Znshk3LLDuep1BEf37ErTzSG1zVea/z9PDRkTkpcmKEAjXnpCBTP3lxGstjBUBUc6NDIJ3RpltToe0/7Q/CYed9oXPy92z3XIjS7v/X7fhVzsLaL/Zz693pyb+So+XB6eLGBC9ZNqk5Dyz5ibb2qyQpqAX0D4FFFDAWMnIwj6pfOi+455YG7eqopPFowSS+yv1R36dogTYBK/22AJi1zD0yL
 ceag3TiD
 iBr8a3WRk1L62WPv1/qzoNCPRdVKTh24wtlw0j62XqoOlrV0lorv4N2UC7vPHAoBx6GIK4blI55uqn5iV7gjPuyhg591BGKgHfT/XF6iM9PZ/Nr3oFobLiIeRzPMQPFhj3BO4fo9gRnNsUZqAaqJKlNnl6BaixxMpOeGU8K1aevDf2jLANEX6PAwa2aPpFdcP2U3QMbMBtuHTSOsxI153mbZup9GSRIUVQqGYtNSWLmVhl1MCDOOJW6tZC5Pqa1+8hRrDg/hY2W16+yaPoHrTb1MQR2vKS5dkfwCqsVI1bxmiyKyuX6X9S8bWInTN6Ok3UC/ZZTyNp9GNawOlrr2rFu7tCTwWidmaudCNtQ6gzHHV+2uZDeYPX9bu4WmirdvhmP38oUea5XnnBms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm selftests rely on IOURING_EXTRA_LIBS (typically from local_config.mk)
to link io_uring-based tests (cow and gup_longterm). On some systems
with liburing installed, IOURING_EXTRA_LIBS can still be empty, causing
link failures with unresolved io_uring symbols.

Add a fallback detection:

  IOURING_EXTRA_LIBS := $(shell pkg-config --libs liburing)

when IOURING_EXTRA_LIBS was not set by local_config.mk.

Also gate io_uring-dependent test binaries (cow and gup_longterm) on
IOURING_EXTRA_LIBS being non-empty, so missing liburing support cleanly
skips those tests instead of failing the build.

Signed-off-by: Li Wang <liwang@redhat.com>
---
 tools/testing/selftests/mm/Makefile | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 78496f705386..01bdd25e04e4 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -10,6 +10,11 @@ LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
 
+PKG_CONFIG ?= pkg-config
+ifeq ($(IOURING_EXTRA_LIBS),)
+IOURING_EXTRA_LIBS := $(shell $(PKG_CONFIG) --libs liburing 2>/dev/null)
+endif
+
 ifeq ($(ARCH),)
 
 ifeq ($(CROSS_COMPILE),)
@@ -55,10 +60,12 @@ else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
-TEST_GEN_FILES = cow
-TEST_GEN_FILES += compaction_test
-TEST_GEN_FILES += gup_longterm
+TEST_GEN_FILES = compaction_test
 TEST_GEN_FILES += gup_test
+ifneq ($(IOURING_EXTRA_LIBS),)
+TEST_GEN_FILES += cow
+TEST_GEN_FILES += gup_longterm
+endif
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugetlb-read-hwpoison
-- 
2.53.0


