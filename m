Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA24C5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D19E6B0095; Sun, 23 Aug 2026 23:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA316B009B; Sun, 23 Aug 2026 23:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698906B00A0; Sun, 23 Aug 2026 23:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7B66B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:35:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AB03120407
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:35:47 +0000 (UTC)
X-FDA: 85134748734.07.B593D88
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1A7940005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:35:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r499xabK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3ELyLagcKCBMFyx418xz77z4x.v75416DG-553Etv3.7Az@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3ELyLagcKCBMFyx418xz77z4x.v75416DG-553Etv3.7Az@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787542546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLeWQI8viIKf2ncJdeLCdpToNayUvXof6lXIwZBpCjQ=;
	b=EEq9XOIYdgMoy/vLIaOV1XujmzY3MtE3/6H6yEv/tLfEsRP9WYtxi03daxtn1rmj2h8NfN
	oxq+JryhlmEXcmz7R+mLbssUNLipgzyYWY/eJE8LoG4dvpc/IFLcq9gHH5Y2bkqEWAGSLI
	EYRQW+ppmVUuSNWu9v11LCX8n2jkrPo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r499xabK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3ELyLagcKCBMFyx418xz77z4x.v75416DG-553Etv3.7Az@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3ELyLagcKCBMFyx418xz77z4x.v75416DG-553Etv3.7Az@flex--wfelipe.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787542546;
	b=hBibjPRCYrdSkJ38gAR3GlZZxb33jLCX0g7Zj+3lwU34d507fBer+CsboRwoWqu+fJlMST
	zofAgvYTTF3V88kRxo9oAvr7x0COsOIAIYJpXrMhnYOdsTMgNgv5zBcyKfv4bO0GhOieCZ
	GkwcXi1KHJbAPg1fSSTlJUr1NEF6jGM=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ce7dff6253so39089245ad.1
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 20:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787542545; x=1788147345; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uLeWQI8viIKf2ncJdeLCdpToNayUvXof6lXIwZBpCjQ=;
        b=r499xabKeAXV/TT2Z7e8UGvRbQWHiGaXEtfnCTTkUnIHRJX9TCLv7QIp783SB21oHO
         821GQ0QgoTlzY4pNXeQ1bVXSC1Zpnl6Ck2fYuAEQqsBmojhdltApowEvOWzOHcdABj9f
         6ZI7CyGfZwXfFLjp6jAQA6L3AYnjwHP/XA63iuXcGeJj8ElJEEJ6x9hJ97tf1yuyzRt/
         G7hj7yWkJ2gxrW1R7N6vLfPUVh98z0k5dRHqgOwJF7mu3UvEaMPK9q992uvJyzMGM5Wq
         zzQF/ZsVRx9FZeL6v2z1/tQl/08v3T8d4X7tjEZxsXjTdEVEB+HyPOTuQyRALM1LhAUT
         HShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787542545; x=1788147345;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLeWQI8viIKf2ncJdeLCdpToNayUvXof6lXIwZBpCjQ=;
        b=hUuYGSTxstHiRsaspVcpg8gk0kKgEfiPMfqZgThm4K8K8IMGdOq2VSjioCAcWlOunR
         /PALjD/bVb3/HApunwrn31HXUzqboH0TnsWwn6v6yvTQnNwrr5X6S1MS5bkv8lk07Cxp
         nk+PVdWQOeD/Q9zN4NX6wLA8i0EY5uaJgX5/+EH+Z9ugA0RhDlTw8wjaDIBYQvROWZ1d
         qw//PLyI8cU8RperG4CLnO1yRm3u8MX/kdAComvhh7h2Kkovl/vPC7+1CdzIP+6pVO92
         Jdk2gXcUubtGi9SLtB+/XDCJ+3Q3YH6hlfM7yzstdtvvrQ5iz1aWB2SZl5UtyNiiTbag
         NLnA==
X-Gm-Message-State: AFuF++mkZY0h5Y8V+3GzAiLlojoNe8lXA5XwVRSVyP3S+MGl8ZEdFJaa
	CKv+YJwCG7wSfffkZjU7i6Pt0+tI5i1/MOCt1Y1q4MXn7jZtVX26elB3WoXlu9O91NQ1XNKReZ6
	7UpHAAQRBPQ==
X-Received: from plgk2.prod.google.com ([2002:a17:902:ce02:b0:2d5:6077:5a69])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3b85:b0:2cc:ac15:ff4c
 with SMTP id d9443c01a7336-2d61a0da51fmr357601025ad.8.1787542544728; Sun, 23
 Aug 2026 20:35:44 -0700 (PDT)
Date: Mon, 24 Aug 2026 03:33:57 +0000
In-Reply-To: <20260824033533.2147900-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260824033533.2147900-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824033533.2147900-2-wfelipe@google.com>
Subject: [PATCH v2 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F1A7940005
X-Stat-Signature: tg8upujnyzdofu7kwqanknptmhnpujii
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787542545-957558
X-HE-Meta: U2FsdGVkX1/LVpvLhaDzOLRXdV5fLgxmjEWFAUZLwinTwCuDjCd79VdzLq893GORfPbDHd8429VIGYTGlXOWvKLPKQcqTKgDetCp3RAZB8mxfKGisGQ4TsACxCseAZI6YEgAnHL1ZLzZ92+h1WUuczPw1j2WQxnaAGbKA0PvjQAFIQbrf1A6s7SQlteun124tsKt3Yw52l2dTmxortQXxYhJqHpnuch4B+HeOfmuGdKChxQt2wl5VP6xX8vdYR2FwS72VPVcZUyHOuEWh9Jq47pg3uVcjwt1rGBiH2JduVvSIqmq+VuobUFnU/i6dRsoKCEY9wZWBA3FJR6Mdm65SmA9YTkfdDvzvRqe0eonOJW0BRd+QoEPVjho9KhudA+mGuFKTuBtuBiF3RuUREjvsQWElafNE2/Be0nXfYkdysD8c82KF1KKTxN83LkZ7sIZSceh2M8lpJPOHR5QC8ctCZ4zPJk22j7aXj6Eayydf1mPInl2V0PuWJ9pJYeeD2XCYQ0IwjPJK0lxTS2EkPgYMhlG69D1nJkPldGfCI9ZLGtOMqdqKlWRr0Nu+18qWk+iT5+INy2ew6ruJndh8LV/rHLC+HdEVOmFyMIxCVIJR2+rcwd11sxi51/juwq+mQNA7e7IcvwcXoDLMdpXneAs+pkBfbfg1YdH7+oHdfGWO74vyjeJKPy5n1iGMYq2s9ZkWRiy0YvBHUUcYisz0lieAZ0yGb0s8pp1gQdXGlwZI2XT/+Dt22xwLyn0R5/v56ZdVIuycXdQhZyTWQL/KtiamJl8H8+WgF08D6wAZWSQ2oACooGn6CT7mdBLUaunr+/sCYHGSzqsNOOZ9pPWSPNHkgL8CJpD1o5KvsmkE6dnRsihUB12TP2UYp3bR3R6mewcs0UGVcwPjXujgF3Q51DzZplFmHt2qfHhgipoWnV+jL9R+VS3rUEE21JrEANjB6sPvCDO+jk6IqNnKnjVX1R
 FXDsbG+A
 HXbQLK/c5vkbNq3fdGJBr+XsN3eOi4+6biPIrnaIX7IDVra3QpgYTUVYNtPjR1cdOlpZvjHx9wNKx5X15ssi1azQynmaEWkZtshoKLeLEe9yxZx0x0RxHp5wYBBB9l8FugGRCxxgskq/p27bPU/6zitJoKGOkWt0kQUW5F40zQR7mtD14zy40NY631fPM+p/91k1bzoWk3aryvFJMsxWOK470fiDvb119jga1O59CQhmFBEaLi4uAnPof7pzBlYG58XkO+4cJXs3Ok2PMgwq5RsxS2MlSezld+79Jp8LUuh/MNo/IJCMfIj8zrz0BTd2c0Gy4sPBJE56o7/WOE1NbzJnA8122AYWrJDlY25xZuFstIyyjapj6La+1xkXJLkURUg1r9TGJMlZMgR0bUrET4IB0ymcJhpwxZCe/rWqpae/mr471H9jat1L3855ojcJaXBQ7ig+wWe0KNV/2eIdNtKL0PgjkXOxXAJXJ++qNNKEYNvliKW1JK+2Cs5EJ3DAVuQmDzbRkLNH5FLX2eDQbtUmNcWeTcM52GKSHtuJ66agdPL93QNIhUmib7kduEn8WgrPT1k5ZhZ6IWc1KjuUioCK9LQ2DerWPNQLyPgSlzt63VxK9Ruc3MgVlo0iA5tCgT76S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately. However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting
task is switched away via finish_task_switch() -> cgroup_task_dead(). On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee79160..a7ff525c1267 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -407,6 +407,8 @@ static int test_zswap_writeback(const char *root, bool wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
 
-- 
2.55.0.766.g2966f0265a-goog


