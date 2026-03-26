Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7295D109E546
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0D16B0099; Wed, 25 Mar 2026 23:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81B36B009B; Wed, 25 Mar 2026 23:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70E76B009D; Wed, 25 Mar 2026 23:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B36FF6B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:28:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E09F1A0442
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:28:04 +0000 (UTC)
X-FDA: 84586780488.26.51621BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 94CEE40006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:28:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYhwmay3;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495682; a=rsa-sha256;
	cv=none;
	b=X1WpyJG9pr7Bmx5U8HrPET3FxGgeBXlaSCRH7xLljfvUKGwHkBTjFpYWxNo/YaqdtTDEy6
	1E/P99+6cYsr7Z10/A6+iCr4k0Jp3qC5pUE8rMGWUJ5/c2ezxGIW7SAesrY+tAIDxgN+7i
	TKHohePqzL7SUtrf3gMw1U1blfWSyqQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FEF4PcMxcimzj0nghaejrMWC+mQHsYsFdwp2v61C34=;
	b=vPVTpAsy1y9emdklBOHYZHiAGBCKGo8FWuCIp39Tjvif7lJI/dUW8HMue+7h3MpvkhjD8o
	XNyPsVg9abEpCgcfL7lefOGOY/SXn+fMk0jXijhDwEh/b5iyhN59OjHDVKYSGPlfKdDuwh
	TKpV6a4Pda68XgxaVGwk6MU/q7ekl6w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYhwmay3;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5FEF4PcMxcimzj0nghaejrMWC+mQHsYsFdwp2v61C34=;
	b=IYhwmay3kd0FQab9L6EFss7LJcQx8RKctVJMVL/B9RSIsmwUpCWtboAotQyHI5WiIX+d+M
	+gHcwFt/YOf1vbuoICCiFnOqu5nWsBfUFH/7xPCdiuq3bgMYyjv4k+O6BAgH7mKY0lyzsJ
	vydgJxWTTE2/U2toFR7rilonSfgC5wI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-Zk5XMdgqMyqNHJrO1O5hKg-1; Wed,
 25 Mar 2026 23:28:00 -0400
X-MC-Unique: Zk5XMdgqMyqNHJrO1O5hKg-1
X-Mimecast-MFC-AGG-ID: Zk5XMdgqMyqNHJrO1O5hKg_1774495679
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF6DD1944EB8;
	Thu, 26 Mar 2026 03:27:58 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 160451955D84;
	Thu, 26 Mar 2026 03:27:52 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 7/8] selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Thu, 26 Mar 2026 11:26:57 +0800
Message-ID: <20260326032658.96819-8-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: dVw2rsgJEQwdkJUTRPVEZX74rRBxd8cyVPboF0cjgtw_1774495679
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94CEE40006
X-Stat-Signature: zm5ig87bnteq7bewpfzzk5k3rres9tp5
X-HE-Tag: 1774495682-160676
X-HE-Meta: U2FsdGVkX1/wWrSlABD3ehQXey4At1GXbp2tDATX0FHfnBLkBw77sqbNUHRZEv+fjKhZnEf3ME3zl/560mHAzGEDOM8qFoy14pBoGDWkC1w2F/VO8/FDDsMHwe9lTNH9f99Z8MsySLRoV51tDJFiR9iGECATfLPciWqqiDoPpNe6iKGqbkdNuvtaRTFFmiJCqHJH4iK8kLAHuqPxT41FXTCQAc/lyTSfCB7aCYhsyluPnBKl6qPgB7zHu/hFsa7YvFokn8srzF/P6fqG57P9ecWjwvUdJCrmuRPq1l608EgERu3Nz3DA+q3Z7dZ0qvb7Fts7mh5gf4BD63sDWiPb4WZHqC11DvnbZwqxgu5ZwTw2p7hl/F862GYzj31dtH9+BBoh3ugJnE5cnIwVP9Kaas52xheLcHrsMhp8CkHOv4/fcCmt0f46nYHcD/kRUlFfS6rnBEW7akBDzUHQ95o5qsq0bhYR6YD+opYDOmo/UMm3xWRKkqKeukX0bCkTP7fOwKd0pE6XnnRB7TLPNMzEdfJXDfhgcqwFzAVeR56gyTVdZhysUJu38YSNZt/dYi1NWSfHR6Bs6jd5IY9QiAIV3tN4NA/Q5lq9s9OoEdXAoH/1Z4te3qUmtUSS7Xy4KoVG+dxdPg4hu0o8+CumsLThbPJaKHlZyG1QliRplVA3YVSKE4mLPIR+XfFCsiRsN4SJHadeOZ9qoB6L9W3H0du56vYtKIIpKgayoqJL4uemFEavPDlaV1VZZ1zhKHD7KIMaUUNUvMQrYmhhnvo1GMqOKj6CWbGpkHEN67b02YHPnMD97eOKtnaRsvh73xo0BX9Mln8c9oMTUNpBkgitRc6fun2IQroBArk45vLxC2+sqi8lOIOp5ElrAHpq5EwzI2xJgfa/fTpxohXJrLGwMhgAssvIecMT7xhGOEEex7ZRic9lW9GIViBWlstW36+hAffI1Iw6t1p5afPUfrLBSIW
 WH85ylCQ
 u9uqcg/YpQX1csIxQTi8vX5+4nWI8CXwr68RGoIhBksyzEc9CSBdv+YkC2oI9pIQIqLw1iRhFsX7cQe/FbLGa3fGD6+SfhyFdzYHPWa4E7M4OEvEE5lqJz8Pl0Lq2Di1Va/16JMS2e0gkNycdAbMtibPmIP9qxmzAmfuCx8pl9r7UNMikzTl/9Oll7Hy7t9EppTd+p0+FMFSS0PDm68+XSY0Uo2Owj9Dw9gaQukcOH26HA0hr/I7EnSOV3s5gayNoY1Kabf48K4FPWWXMqjzNmz4VD1FIGmRugAOZk+O1WVHZeKu06A+gKw0umuBxxMqrQv9IuqhC5XqQsXxeoFijIfuyb5qIrqYhprQlJbRhIruzV94AvMJGl9FANgbtYNHrfBjZFAXqZxrwuThkMBaW320QBCbLzsCK4wttmx3yErIVckeS+13s/KEAZYAbb13xsrSPRZh92FCjM6Fwhy1ZwIZ+RSaRf0EjK2n/TNmqagK1ZVgvNTAKugVQC3fNTzOClY+SHVB/RlUV+pj08b03UQrcuN/ShB7a5DInx7ZXuwlbhCqFuZ8yTgDCB0EcPtOWIqYmfRVDPwKJLaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
page size systems. When memory.reclaim is called, the kernel prefers
reclaiming clean file pages (binary, libc, linker, etc.) over swapping
anonymous pages. With only 64 pages of anonymous memory, the reclaim
target can be largely or entirely satisfied by dropping file pages,
resulting in very few or zero anonymous pages being pushed into zswap.

This causes zswap_usage to be extremely small or zero, making
zswap_usage/2 insufficient to create meaningful writeback pressure.
The test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by:
- Always allocating 1024 pages regardless of page size. This ensures
  enough anonymous pages to reliably populate zswap and trigger
  writeback, while keeping the original 4M allocation on 4K systems.
- Setting zswap.max to zswap_usage/4 instead of zswap_usage/2 to
  create stronger writeback pressure, ensuring reclaim reliably
  triggers writeback even on large page size systems.

=== Error Log ===
  # uname -rm
  6.12.0-211.el10.ppc64le ppc64le

  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  ok 2 test_swapin_nozswap
  ok 3 test_zswapin
  not ok 4 test_zswap_writeback_enabled
  ...

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v5:
    	- Setting zswap.max to zswap_usage/4 to create stronger writeback pressure.
    v3-4:
    	- No changes.
    v2:
    	- use pagesize * 1024 which clearly shows the page numbers.

 tools/testing/selftests/cgroup/test_zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 72082e5d4725..e96e316f7c47 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -273,7 +273,7 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = page_size * 1024;
 	char buf[page_size];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
@@ -311,7 +311,7 @@ static int attempt_writeback(const char *cgroup, void *arg)
 		}
 	}
 
-	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/2))
+	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/4))
 		goto out;
 
 	/*
-- 
2.53.0


