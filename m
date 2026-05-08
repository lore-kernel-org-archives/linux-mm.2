Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00BECD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135326B016F; Fri,  8 May 2026 11:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10CBA6B0171; Fri,  8 May 2026 11:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022856B0172; Fri,  8 May 2026 11:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32B96B016F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:01:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D23C40199
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:26 +0000 (UTC)
X-FDA: 84744566172.15.1E1E643
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DEF81C0021
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g6v8ucrK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QueeMM+8Rtdi14b6LI2wohmsfdt2dh1GY7mMDDoIeZw=;
	b=vO4GHTIzbU+5FMa6rWILCBrh+6dxtDnA5nLuTHI77zVOnkwQDrKAjnK3T8w9khjqHWPB4P
	QiOsHxpuHghWcZBMi2NcAsXStfp8a37AYaNXyEarQgtYXRvm7jq8+hq3YIeVSVkchaV9OE
	h3Aj/CHvNSV3w3h51b2V6047b8Mk9dY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252484; a=rsa-sha256;
	cv=none;
	b=wwPBQ9de7Lf5AnY/aSgFQ1/F+ul/od7XwdiFwooNoQgsj5ceIC5BgK8bdATMWYzFhZ080a
	WoFSoofZsRS7kk0QpYuS0D+sCrAq2g1uxSskBb4SZ3Uc2NQd0hP+XqW2HrKetLX28A3yCI
	/9/zFCvuc5rtwmYJteKdQcf/8yfl2rg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g6v8ucrK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82fa8d6425bso1046931b3a.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 08:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778252483; x=1778857283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QueeMM+8Rtdi14b6LI2wohmsfdt2dh1GY7mMDDoIeZw=;
        b=g6v8ucrKg89jYmDyIlyGUeaXLQgi/x2lzJFagt54N0QEMfqjYgPCZG1qHAVRE3YbU4
         1aP0GueIgmlWzggD2RQecT6SpTvn7+lao0XF21cy+I6MdJcrjzBoMZFlXHP36vfKg0/+
         jta2IyShSt/gC8o664jMxFpnLFYqcSu8f4DYUPHkTnSubyCeuUo4OHHHL/VziYrBjGrr
         c1fP+0o4Dpn61SWkbN3WFRVE9yCobu40sQ08k9Q7FfQFM4CUMryjYYdiFwSRZ5Fx/W5u
         5CNxpIaZiIXlSgMeo8LS8XOPiku2qYozMYZce45iL79SHKuciMVwtkwxSLekS+uNsIJh
         8a7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778252483; x=1778857283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QueeMM+8Rtdi14b6LI2wohmsfdt2dh1GY7mMDDoIeZw=;
        b=UbK3GOSCtsMUpJchbO2jboDQoGlfWWc2SFwCs0uoO9V3kdoey/gQU2c16vA6Bn1FoG
         eAGgIiaZRjVtm5NI4ihvvamXnuWf11Yf76emWyp02TORlVrAwfY/Chnjt/nBgFVf2jnP
         DKW3Bk6cc6lX0sBtqg9ACo9kyzpwwXTM2L6BoK4hmv74xplG7bBmPIThn6NkNTVvrODV
         FlRly4oX493wmrcY8tk3JwADJo1BH/Oejy1h/foRQnWk3uBAvTktjqGnoLZ7uI1G0E1M
         xnXlTh4VjOFO3cZqWkNbDNka0TVq/obboHAQ6JVKRtsfyNjbTFOL+oAr+0HOl+PKz0Nb
         gMFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/EPm4or7rEcdeBWzPws7nYzlMFpixI0StfxskYHPbrFnkERHCCayHhZ4hJHcsMi/SI7Cg+TTTXng==@kvack.org
X-Gm-Message-State: AOJu0YwqXRCqbFnfr6PhKzDINuD82sRj8IVzCWzaq5HHBmheW3P+8wPS
	Ru7/2NSob7e+vfGbuVuLnaHfvCRCXz9SWdjvFxke7xrlR7kZRpZYVthI
X-Gm-Gg: Acq92OEB+Y4t7nSxfolHgrihFORQ9L809hrBIssaB7xHANUJ492t47xvaExpBtJXIqf
	VMUPyW14ZOyO3/n+bX0SCrKhSjJMudyl9W209JSRxJyRAbJIUjB1y4/UdHeqT9Kgmwx4g/XBGWG
	j+9hCChKTIxv44o25bya3a4CkVVzr5suCdUgiguMHaGQzrriVBmLt7VY4jQ5w/gTkqR37oC0yqV
	DQ/7WG2ZSq/7uuwKJOZYTHo3/2jFlx3xv0zjh1nS82x9xvFjX/Wi/s+5IpEeMw6y0z8DLfU7Y84
	7rAnrGn6D9ettPFeFT2sZmJJjMRuVZOBbC99c18/PXDje0Qkqrgd8zqY1gdbCrBo69qAwl5AQLI
	VAcp3U/RbgGQa3Atn4W6nCNj49qPfIAwtVO6ywnSY5V+WhF27cyN6Feiwnwa7TqEQHSbFwBKfgD
	vKg4tkjQQEaYeMRvx/a01TdObp4Jj9bFnS4iQO
X-Received: by 2002:a05:6a00:aa08:b0:837:f79d:909 with SMTP id d2e1a72fcca58-83a5e13d6d5mr14036326b3a.39.1778252482867;
        Fri, 08 May 2026 08:01:22 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965945c1bsm13110064b3a.15.2026.05.08.08.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 08:01:22 -0700 (PDT)
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
Cc: tz2294@columbia.edu,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	laoar.shao@gmail.com,
	gutierrez.asier@huawei-partners.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 2/4] bpf: add bpf_cgroup_{flush_stats,stall} function
Date: Fri,  8 May 2026 23:00:53 +0800
Message-ID: <20260508150055.680136-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260508150055.680136-1-vernon2gm@gmail.com>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DEF81C0021
X-Stat-Signature: aczhjnt3u61i3p3nuzb8f4pazdyrkza9
X-Rspam-User: 
X-HE-Tag: 1778252483-746976
X-HE-Meta: U2FsdGVkX1+A5rmgB7F+lrC14aKUMv+CxbUDxKcm+/FbA1vqyN/fGeWxGomGuJeSPSK/MKlGilsul1q8nc1umK4Z226x2VMLo0a7+9tCQ5IHEUqWiAI5GuvmL9fkqE1aus5tufb+AFsElXwCeMd+NhazYyu6RV1rUEO+97SQED/j0THTnUCiHPp1aVm0G6DRnshT1s90nlAyk7nQzO6ZQgNnjJwu+FkgGiv6xjH2KeHPcWtPJVOaowdK+N/eU0+ii6hazQM0uBeBmQzsobyXG6bNpYDsGXPFaChRp0o3aHstb6peIr9H/uSbOQEbsq04fk22I2mS3vM35ZQSl5/+E7cVJo0BbtKP5pk+Xb3xgnNPhd+9aPUUbNfVKq+ezqHPzA37DxfAbl40igRgtnTdgAeKGoZaBzUm5khQLp7o/rWUTOfgLe23T3GfJ+fCfKsOnwUwmzfLat2IQyrVfz1IULMJRIxi1zB4shQ7vlqDfU1IEB2sXDSFfE8zMNrgaThwBRPxlE3RtGAsLTe4IL8CYnIYQb528zggK8Gd6rurdOzevjWjfmdpNU02erXtBBvAJtACYkWETN4vCWaHRXGEu7UNZ9XOwS01YdO7uWnJ3yMD6MAUBOpgTk0IPqLgDegHyXIhPlkpYgpvqVXwX5LnXIlwgT0pLiuJ9lcqMLl0Jn+EfHjILA0oU+gKSnowJX91JVM04aoNzsFjNORrcpZyAthYi9C15hEFO3B+U7fl+ZrZGkbZg2z0J3uGybEesKIq8PAW1iFNxhZ00D6TSdK1gPUqtchln1oZdYQpsPCbhcnwpBSUwjX0liZfaiRVvyKew1UdMO/8H0kUTxaygtFhxENbOYl1aQGtdD390NkDFCZLlYszbI1oqVVCcHIhvZ0y3HOV0+dNLMu9iIyM3tQb4eNoao/OAJ9yPliLLHhVzdVpstCFfIGZ235gzJhcb3unkyMl7DpsR/R/mWBJxVV
 J3KXaRlA
 7nQ1B5n1k25mDNOrIhzWrdQuJR3BMkfuwkZgCF4gkMzewYzSf2Uxxy7kWOegJu95CXQmaF8cPbWBljzb/0L3LHWTQ7XCqQQ5XIFFzdGKSuSBq5scEDE1AFxtAJb5gOsv1FBZzruC1/ON9tACIizUXpCue3pvPZBjGF7Y3bpkkbLiM7ULhDVajiDdQl10ZrRlBcuW4WsuSM57kV4EN9qdhQf7JSRUJ2jfRqyQzmBaqij0LvUNRkoC+CRz5Pr0QgKkCZrnyVEksFO4A8Y2p4KTSZoT9zWl3/dglLxFWbc12RuaJdJW5mfyGh2o7yiK74mhaKXk9nWJOn7P+h7mgmNeuuSw8TgmF7bt5zN9bC08wtKqnnPC0kOlVX8i1mOhSv0sL+RuxfDhKLxmXGJq3o/0EHdYXDOtZnVxr8NJB0Qmhx6TZcz4OaQ3+bULQ4nt19PnTIYtMUhudva7ucK4hbm/5lTuIrocDp/Pw9TOu6DizVw5RohAvkqeHOmmKu61lhrpZoRYq1TR6pE3qPUIDAlsjzdViVgG4QyFwCGMY
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
 include/linux/psi.h  |  4 ++++
 kernel/bpf/helpers.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7b4fd8190810..243dcf97bea4 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -52,6 +52,10 @@ static inline void psi_memstall_enter(unsigned long *flags) {}
 static inline void psi_memstall_leave(unsigned long *flags) {}
 
 #ifdef CONFIG_CGROUPS
+static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
+{
+	return NULL;
+}
 static inline int psi_cgroup_alloc(struct cgroup *cgrp)
 {
 	return 0;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2bb60200c266..1c353e0ff14f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,6 +29,7 @@
 #include <linux/task_work.h>
 #include <linux/irq_work.h>
 #include <linux/buildid.h>
+#include <linux/psi.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -2881,6 +2882,37 @@ bpf_task_get_cgroup1(struct task_struct *task, int hierarchy_id)
 		return NULL;
 	return cgrp;
 }
+
+/**
+ * bpf_cgroup_stall - acquire the total stall time of cgroup
+ * @cgrp: cgroup struct
+ * @states: psi states
+ *
+ * Return the total stall time.
+ */
+__bpf_kfunc u64 bpf_cgroup_stall(struct cgroup *cgrp, enum psi_states states)
+{
+	struct psi_group *group = cgroup_psi(cgrp);
+
+	if (unlikely(!group || (u32)states >= NR_PSI_STATES - 1))
+		return (u64)-1;
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
+	if (unlikely(!group))
+		return;
+
+	psi_group_flush_stats(group);
+}
 #endif /* CONFIG_CGROUPS */
 
 /**
@@ -4734,6 +4766,8 @@ BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
 BTF_ID_FLAGS(func, bpf_task_get_cgroup1, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_cgroup_stall)
+BTF_ID_FLAGS(func, bpf_cgroup_flush_stats, KF_SLEEPABLE)
 #endif
 BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_task_from_vpid, KF_ACQUIRE | KF_RET_NULL)
-- 
2.53.0


