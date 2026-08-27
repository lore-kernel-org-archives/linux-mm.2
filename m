Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3469FC5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFF36B008C; Wed, 26 Aug 2026 23:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371366B0092; Wed, 26 Aug 2026 23:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289CA6B0095; Wed, 26 Aug 2026 23:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F40C66B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:48:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88AFBA02E9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:48:20 +0000 (UTC)
X-FDA: 85145666760.15.D41BC62
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0F5B20008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:48:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zu6zrbU5;
	spf=pass (imf13.hostedemail.com: domain of 3gbOPagcKCII2lkrovkmuumrk.iusrot03-ssq1giq.uxm@flex--wfelipe.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3gbOPagcKCII2lkrovkmuumrk.iusrot03-ssq1giq.uxm@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787802498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ASdk2IOeNuFGEIsjmCHgLUlwUNJIVTG3wsjeSpdDNkA=;
	b=AX1o3o2S7NKxuDa/DzCccQOjjJhs2Rphl8UPt1m778Ul8u45PVVa2hmKw7cexjL9RO5Nkd
	Qyd/i1b2NjgywtQE8rJlRKINDoIBXRHX3JmSAtJGdjfjSeA2xlHtRyAvD5AoduQGxI9eIO
	t2ydpmBa77f1o4q3ak3OxuffCd5jmjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787802498;
	b=UNspl0shn/O3UdM1DnIs+AQ8UoUtHzCSwYwI2JiXB24S3HGeCSsoOLh2BhQFJCMovBVM9n
	dGkMKKCFvmjkbe8ywz8d+w8+v6dFk8PBPF9MqXU2BUlP6mtbi8zlKlxDkzs1JDArhocAn/
	/tdNj0h0bwBZ2Sy2+imAPblvIa5F+U8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zu6zrbU5;
	spf=pass (imf13.hostedemail.com: domain of 3gbOPagcKCII2lkrovkmuumrk.iusrot03-ssq1giq.uxm@flex--wfelipe.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3gbOPagcKCII2lkrovkmuumrk.iusrot03-ssq1giq.uxm@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca8aee88725so2217887a12.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787802498; x=1788407298; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ASdk2IOeNuFGEIsjmCHgLUlwUNJIVTG3wsjeSpdDNkA=;
        b=Zu6zrbU5fbCPMHmzfLAnsv/4DJu5abzKzMS6nOUXq7nQOM5LByOaKzpMZHuHYqia7M
         E3wvnMvqRCeCPgwoSxDAyQvzvzdY/baOQ8umQk7a9Mm1/5zJXUzAlAxKfV9sUdqyO6tV
         M0VMrfN7pKg1IGFXQyzh9qSQHxx8y2TleHQvDy+veyp/6jt8qPxIiWu5CaoOJi+WtzAy
         WCjvMeY3SDThenTIRB0avYxT0/zpuukMQlA/tRHOPKw2OhTOLqpRaGS5xrcN8ByFzk7+
         K+jyWkeKkW0xMdyaT/cMRdB4mRsWS9B2Y4K/PCW5rAo9zKAi00Bi/o9SdE/iLYoRMsyv
         jqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787802498; x=1788407298;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ASdk2IOeNuFGEIsjmCHgLUlwUNJIVTG3wsjeSpdDNkA=;
        b=Dsr9B/z9s78VL5L7neUWaTmYTGAzKs/+9wdBC94e9KNSSSzbdgTMp4i7OmDCKTVJ9B
         Xo4Q+TGNfC7GcPKSAsWsvx/87+t0oHOltzsaRz2OWGbay8xKT8HI4VdRmPepC4WLeQVC
         GTxUbqCuvhHUMeGRfts5G4aqeN4QguTb/aCEwVr3GU0vpjMFGFJIOFsd/KdVfgjAkPUz
         Ar7QQLWYOyoUdeIUxtXvVcsUCVqlk7i85MrQc0+GdVTLE728LBZCfqkZ8Wr/lu0eq7+J
         pjFOAzRf11UCV56Sh1ymklAB9xxkuZtzATxFBF3OYJviBQCjSAp/n6RrgHQj2Z/wvOJu
         dIyA==
X-Gm-Message-State: AFuF++mZjhSjhH7FQ4tH7VqlJV9Ihpf4e/oiyyV7Ti8uELvOl5Hg5qMD
	l3XjZ6idV/oGvdOJbuZznW1rDf20yGLK3dse2LxMHokHkLxPVbtQMV8kzsfF/mY/FFEZUjvZUwA
	2WCzTVBYyRQ==
X-Received: from plbkb13.prod.google.com ([2002:a17:903:338d:b0:2d3:768a:b66c])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2392:b0:2d0:cc92:f7a3
 with SMTP id d9443c01a7336-2d707a53a0fmr241134785ad.2.1787802497345; Wed, 26
 Aug 2026 20:48:17 -0700 (PDT)
Date: Thu, 27 Aug 2026 03:47:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260827034807.2822234-1-wfelipe@google.com>
Subject: [PATCH v3 0/2] selftests/cgroup: fixes for test_zswap on single core VM
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0F5B20008
X-Stat-Signature: u8s9jjbocscxbhr3zurm4apa5szsac1o
X-HE-Tag: 1787802498-454967
X-HE-Meta: U2FsdGVkX19aIDIVfbIW5zBKQC2PV0cwZoxECKbe6LXPQzzOgP9iajzRBTUpzxdKWjP+CVyW+CGyLGqcho/Fg//KJ19m6seePDA6oIbiKCW33B4qcU+UA59AoSE6rPdCQvlsiM2PtH8D3x1LkCGpprRTXYmHGomrob0ge4BTzItl6Cvqc34cgO+OQkkLY/htSPjtG+Ajsru+SOt/LWk8Kxo7ppEoTms3+xhiGS0TlAVS740CW4tzqT3ZaoyoGFImydeZVRgnwfB8bwbhVVQ6ZghWRz/onbXs8dN1YVvGt3a9LqVFE758oplz0x8dok4Jflu1N70zAZiFDU7frwz+fdqiwoI9vo+pJB05GPw9GogvPwIN6ifVhFe4Yqaavl6hQXRv+bdTLKaCXxuXJ8NDiZ0FHL9VpFk3xyNtcT0kWrlHRFwzpxSpZO3Xr5/FpFtPPsmBGN+rpqpC6dpP/7fae+Nb/otC8BzZn+iNJaxdVpMM9Vy8mSOzP2y56es/XMAxoVvzMl57V6ANyeFRs04aRVw4YR04Lis4dJioj4jf/Abcgz6HvnEi2Cf2ssVNIP5YjQGJkV8HBujuCR4B8qprjsCI2gemkE05KtMYTYLblMvyVCUCGRRxuGjAUMmY0N8TKSf+t1MH2sI7iMuSYQZ2RDLrdZy/Y/yN+jvVBOG/S0lLJYaEJDOhJuoE3lyw7tb5dhZv/kuDmYxHoTGzCjylHK8/YluT9KY9OCatk7wSnQhVr8E1KKuUwezv3wiITDxgyu5rjrkORfs6X/08FwVISJ6fsflSobEhSBcJUqRu9WJo2ByaNTd1VvGh+XbepLU0ZTVha/vH0dbyqTOHa9NHgMsYYwzYZagcgLw1Dv65/pt7HpL7X289ncND5J3KTeXA+nKhtUkP8Dk1Ryor3u78M9HXi2RdV97VHhGlBO9VspXAuk/gTqilol3e8bZC995cuXVAC4aKWDwyOnQILoY
 d+wQd1N+
 8ROYeFKDgYm4gVZg8fgtu1l8CUfgRoRof3j6xPENmb7X7O3P39tW7D9IJDwYKd79F+oxwWgMe9bPi9W7fh6jUjP2vOxwwII/cdnaBgfUoVszq6pnLUpk71laEOWhiEZXcrq6j1tQzirJ3QC2lpA0gxCPaPlD2YmBFWFlYfhHdSjVMBi+n7LJK15lAx1hFelt5ttGMmXPYuzUEvmuzDSdxEFzO9NI7ZMJqQCcQm1r+UBBZrHvpDLBVKCLYucJc5suMyQ9R/KjOB5oawFKgi/KBSOvruI9hWPu4ugDarIbnJrlIj0MlFX81tcY4h/4Z1Q3T3Ug8/DswoMC7zGin1erBGr6Nnsmrgd6zswzkTMk9Ip37zp+Tcyjl6O9XCTgBmPsKNfbO8wSZwNY8/BurABZ8VsBxTYeerPuHsAac6Sy6JNUrKYyFw5cHAGth9lm8HpMCoISxlvOXwH67tcMs6jWuYUbobbSfOxiaUirsQg7hyu78Lrc/bJuBBIxe23XlekB3Z/1s+35TinzyD5KPlycm11VwY+xEuKPVvviZTFK9BF54eGPkLMrAkohsa5DUUNcTSDnCgS8LqbYDAMvnR46WFCblQfZi7NsBJPq9l0vcwb+NAPPrtHkoF1pdTxmdtakaP+Qo/8wAa9TD+PTJ9djthRFCeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY. We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.

v2 -> v3:
- Patch 1: Collect Acked-by from Michal Koutn=C3=BD.
- Patch 2: Explicitly cast stored_pages to (long) in delta calculation and
  inline the return comparison (Michal Koutn=C3=BD).

v1 -> v2:
- Patch 1: Replace EBUSY retry loop with cg_read_strcmp_wait() waiting for
  cgroup.events "populated 0" (Michal Koutn=C3=BD).
- Patch 1: Clarify task lifecycle in commit description (Yosry Ahmed).
- Patch 2: Remove abs() and declare delta/zswapped as signed longs with a
  signed threshold comparison (Michal Koutn=C3=BD).
- Patch 2: Add Fixes tag (Michal Koutn=C3=BD).

v2: https://lore.kernel.org/all/20260824033533.2147900-1-wfelipe@google.com=
/
v1: https://lore.kernel.org/all/20260804042053.56940-1-wfelipe@google.com/

Wilson Felipe Pereira (2):
  selftests/cgroup: test_zswap: wait for cgroup to unpopulate in
    test_zswap_writeback
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 tools/testing/selftests/cgroup/test_zswap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--=20
2.55.0.887.g758fc8c411-goog


