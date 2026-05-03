Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA927FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3214A6B0093; Sun,  3 May 2026 12:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE6C6B0095; Sun,  3 May 2026 12:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E8E6B0096; Sun,  3 May 2026 12:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E05C6B0093
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:51:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A34C91C1135
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:12 +0000 (UTC)
X-FDA: 84726698784.30.4C6591E
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id D431DA0006
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YThSvfZR;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54CfH1z6TNt780aoevT0/jV5wyQdFbwCsijFcJJLlPI=;
	b=HNhfnxxTj6jV6da936bMNfmw+lVzvhg53zLpFdHJVu1x4NvA7Y0V+iz1/J3yfr8fBjAnQ9
	lnQJZs5koIXOOmefgnD/K0TomRXniv9lwF6SFRnea3ST/nUM/FQ1QyGz4LtF+/eirhqp4G
	gWzNZ8YVtcfwvJIJjagqASkL/VY5i/k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YThSvfZR;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827070; a=rsa-sha256;
	cv=none;
	b=qeeyU1mUQ4kmiJUgSSHNKFKKwvn5QP1DDU4uOqXiVDmGFiHz3qk9FqUJbCtq9yF5GgO39d
	JbzDD6dHjJct9Z6ufz5+MwDdnbV3jSbJgU+2JPlEJFrd2S0oVKj2l1nFc6khu2qgBrO77H
	kg+n4m/tstbF8V/DymQMNYoEscmkzyo=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c80203b9d7bso148197a12.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777827070; x=1778431870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54CfH1z6TNt780aoevT0/jV5wyQdFbwCsijFcJJLlPI=;
        b=YThSvfZRKEYBgjAncTKoNe4+s0epoohJFfKLoMFtAny5/imBpM/0uuMGefFGfcEHso
         KhANH1CjRaSW0QApxh9/SZWrh/o9N537kAZ6MT1ejIkoTH9ckgCIsun7Qe95y4ex3LfB
         5zgNZ2wIMuLsTwLbT7i1LmM+KUUFg4CziB+Q6q1XqjRUrcol0OMRpHuOBgMatbaGX24B
         4c7AlI9f2LS3EAYG5GciYRaHmxvlaoJcJo8PwHnaFK1+o2eZ8D3+Ds1HzD1/dz5PSQk3
         ludEPDPJ6YE8hZW2q+2MEA8xR+Fqg/ov5XL32hWTBhe9878HS1angyTUUYpy/MwJ9bbM
         qCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827070; x=1778431870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=54CfH1z6TNt780aoevT0/jV5wyQdFbwCsijFcJJLlPI=;
        b=jDd2y9E4QYZGCYyM4ilMt8MF+vd2kK2CRt3+qH28MhcMgO+7RmF/b70YcFFp7NyeT0
         7xevMY9Y+Pbe5uVgenuR0z3MFtVJX4gDYosi3CfikFFNImI6kinSleiWMTXXFXLCVD/n
         x7Eev7hm/75IDBo+kRtrN3V5msC0vre75YvRELioDDIB7NUXHvRTtGaOx29sv/q0wCha
         h+73AG8G8FmEJadd5t2cffyLeV1K/t2pp67xJ3iWV861rFght/PNUJ8ZZ91Gkp0ZK8P/
         DMhyhmVK+KSZSyo2XppXq3dZL/3ZDJJtiskJswFgQnqTe0b3Kvi7s1RsD7S3Xgu+I4wF
         j6Ig==
X-Forwarded-Encrypted: i=1; AFNElJ+e8t5Tgqc8HQtA7K3VQXaXlOOTaFShPvK3uc2Iqu79cUUDBsi0P40ig8Gc6yj6oor6rZGTcILUjg==@kvack.org
X-Gm-Message-State: AOJu0YwV7n/32vycRatZPRuqf7EPOgTDW4ka3CMrrQC6H+FI5fNCONJC
	diDhzBTVOG9pe53BBwjYlVhBAt9H0xDelR42bXfYBLUIXRZKjLfvvFUR
X-Gm-Gg: AeBDiev5dSNGddMLyoT6ClCgB1tUIWjhnimTGqujzTkofMVrIi1rllI56E7xXapdwSV
	xz5ouiT7VERiOnBMav9sb/239KdWoBjVo3gjALeeJhyM5lT7faEjf3wujjBvXWImGItCOxOcD51
	MQc93q+JA6BSfNSMWD2vmd6vr8lMLrY5PsZaojGvJ206R5+Dz30MjVLdpwrxGDyVNVmR29D7afC
	2eexis4SG+SYnzFfhrygVA5Q42TUKcW/7nktO+hpq2mbqY4w9NtBL4lZrmHs50gWJoUhyYAx0gd
	77ES6KuuSZ+DjaZhsckiTGBJWJjgeqTRAmUpFOFLuTV9EWKyFGw9wSrVhDQvGQpJxvgr/HXMphz
	WeaHTpj1Bk48i7yDnShkdc9EV4rT1Vat3zI24D3UKsXSRAMFTpfORB7yspyWUvEI4fH0MHFAGDz
	BGHkBTLdsHvmmeIfgd/+vLN0X0swj++rvYOLiuuuX4cpTkOdA=
X-Received: by 2002:a05:6a20:4327:b0:3a0:b65a:5df0 with SMTP id adf61e73a8af0-3a7f1bc4159mr6507949637.29.1777827069644;
        Sun, 03 May 2026 09:51:09 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83707fab756sm1494277b3a.44.2026.05.03.09.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 09:51:09 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	surenb@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 2/4] bpf: add bpf_cgroup_{flush_stats,stall} function
Date: Mon,  4 May 2026 00:50:22 +0800
Message-ID: <20260503165024.1526680-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503165024.1526680-1-vernon2gm@gmail.com>
References: <20260503165024.1526680-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D431DA0006
X-Stat-Signature: qpzcr34wq4xti1r95b1azdgyxd7amr5a
X-HE-Tag: 1777827070-844324
X-HE-Meta: U2FsdGVkX19YmCHg0DyJ0hDraa4JAWQanf/6BmxPXHh3JakHRZqtLIIJciWfgKgmcv/I20SpILa+ZB4d/kcB4iZUSEMhZcwHaxf0iC1+X90PLDkQ3SZYin+A9Kz+LyPxtis7rzoFLDuS6VKuaQuT1Kqx6sQLvdzBh3K4klGOsUUSjayxo+uEw4gjaCGu2+QiBMZMg30v+lRw+49Twb9VRy9FcFUeRP+DPZATJBIOcb7AL3iWMoP9Ek16//2P8maS1zrYDyXGfx7zAzV+9q+PP2//BRX8DnlGnKwIKcE74gebIcVSVoipv85TlU+xBEnOgnTuTSrrlwGc+eAHa9Y+fPOdIldLt4noxBtDzrp8Rbyws95sZr1eUgkhSQO2CrsItneivy9Mm9G+2iCtW+Y29xmIcgEesGcJEMgggeXAZixSARnc2mGUmHHgVB0Sk2nxCXiLh2Ry1cPX3WGpiL3f63Qf3s71zF3vMCtVTKGY/bRGToZgXP6cEt9Tg5PurarQgXqWIVbWNnki4WkJLrphOC3d4YhvirX/EvD2+nBGwBkKs1LdPdOFkaduVt47P9950WsTW2js7JEY3eMERpjnKAReWRxJv2aOnp8SquM6usdekY129+B7rkmWkgzbXwXLqOiAG1bH+X9mhsqtfPYa09flB0RFzLtEmNjWyX+VfzfS80DhcSTFPmWOuedyUNlyVTDrx0uuUTABmO28YXtb7TOldHcboHqt1Zf0SFAN4odOCM9zkKwXaK8IOadLXQkdV4IdWQei07kNYa9m5LYU0/Qop3Fz0jc0KhFTef1qgdnBbzluwudZvsSJBsb/tqE025mEQdPktJwgxtIon+hCgJKMOdFId5IbDKM6Ptn0kHEEUXUHTbKcOazSHmfsL0A3TOyNje+57StIhhTF9HHuRMUnVQztNcj4mebWDklGOXUcEgIC7nYIb37hXD12OmL1N0Tpy475sO6nuu3JyvQ
 eCS1HhTn
 2mkGTf8oX0aDiLb1/zk4sAMGqbFZJwUmGwWJVGm6HXo7mLpz8gbKrg0AKkF/tzHBPhBJps6mmvkEd8YAF74xGNNFlk/+efPrkwvCNIR0mDTkp23QachLoMC8bKvrd391evEKTagEuuSh72EnmYIJBcaVIRgRePSuYl5cb8edEk0kH4d3upP4/+/knchzNj4SD/mikjPfrhPWvMh53v3fDjLPH84KZVMirpCMko+eGiEgCWTyYlZtkDnFeRxaW2HYOvHHFsm6G2TGSHMngpd8KRaMBZhoj/25gHIJDWAyk/hs6XB+/QwNGKpprZdxUJJD2R7hMG5tGkrKBU+tyXvhIjuFg3S4iBY6KWmo6ukrmttByUhx3yEqWvFZxcL4AHZvwVW08AZKe5eLkTcysYAAo4zsE82fn00NPWTH3VYdObHIuI89+2BDTGDl4Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add bpf_cgroup_{flush_stats,stall} function to prepare for the
subsequent mthp_ext ebpf program.

no function changes.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 kernel/bpf/helpers.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2bb60200c266..87f3072adce3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,6 +29,7 @@
 #include <linux/task_work.h>
 #include <linux/irq_work.h>
 #include <linux/buildid.h>
+#include <linux/psi.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -2819,6 +2820,32 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 	return cgrp;
 }
 
+/**
+ * bpf_cgroup_stall - acquire the total stall time of cgroup
+ * @cgrp: cgroup struct
+ * @states: psi states
+ *
+ * Return the total stall time.
+ */
+__bpf_kfunc unsigned long bpf_cgroup_stall(struct cgroup *cgrp,
+					   enum psi_states states)
+{
+	struct psi_group *group = cgroup_psi(cgrp);
+
+	return div_u64(group->total[PSI_AVGS][states], NSEC_PER_MSEC);
+}
+
+/**
+ * bpf_cgroup_flush_stats - Flush cgroup's statistics
+ * @cgrp: cgroup struct
+ */
+__bpf_kfunc void bpf_cgroup_flush_stats(struct cgroup *cgrp)
+{
+	struct psi_group *group = cgroup_psi(cgrp);
+
+	psi_group_flush_stats(group);
+}
+
 /**
  * bpf_task_under_cgroup - wrap task_under_cgroup_hierarchy() as a kfunc, test
  * task's membership of cgroup ancestry.
@@ -4732,6 +4759,8 @@ BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_cgroup_stall)
+BTF_ID_FLAGS(func, bpf_cgroup_flush_stats, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
 BTF_ID_FLAGS(func, bpf_task_get_cgroup1, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 #endif
-- 
2.53.0


