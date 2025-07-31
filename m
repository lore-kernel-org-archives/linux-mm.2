Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19C6C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29118E0008; Thu, 31 Jul 2025 08:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB898E0001; Thu, 31 Jul 2025 08:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B608E0008; Thu, 31 Jul 2025 08:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86EAE8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:28:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F093A14072C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:39 +0000 (UTC)
X-FDA: 83724488358.13.3CB468A
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22D191C000F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R767bsek;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayWZPS7L38ZOhjcOnH9WSUS7UcJth2Mxw9Vr7h3Jt6g=;
	b=uaTWynMYhwbjMehFvzD38oG8/7cmsHcOlK1UJHGRqzqHOVvKQM5raVl74dM6nGWq3MjkP9
	G9xajCo1RhriUcIDeQXkmsz6JgLLIDOdImAQbm6wsyiurM35v8BxNL8NYI5ke3E7wfo61E
	7danwXJigxvBULD0uaqwEMSiBmBfR94=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R767bsek;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964918; a=rsa-sha256;
	cv=none;
	b=OZvF+EqVXp0+TUrCFlQ7Xjif4w7ycV11LjHZhuVHXtYCVT0C+Re9NxMP0EaNjnDBdqWQ3G
	G/h1K9vd6bIGDJ0MyAzDJt404RVoukeXnGM6q3G7OFtvzGCJBkniTmDHwzfmIvS3N8ypWg
	U5hqUiw1TqgTz0YPEBkiAW6lWHXH6VM=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-7075ccb168bso7467846d6.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964917; x=1754569717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayWZPS7L38ZOhjcOnH9WSUS7UcJth2Mxw9Vr7h3Jt6g=;
        b=R767bsekjdCnAYzCaXQiDNZtYbENoBPxIjFXhwepWGMZ8s0J+e3m/73iZ3hySeoY7d
         nr62SDANDar1NMtXJFcILIqWizGjiZSzs+d/zMpzt4SQYPobycd+fPprLg9h5kqiMKrC
         8DJSNzK8kB2bjyF1Xh82KzqUxyU4KRo/CG/0FLmu2JS35/FDl3uSG30F5cEX6Rxa8Zs2
         5ppYyixI3el386PqjVDVInYYPOpOExv8qdRKFn/4tfnhns8rooem//gXheCyOZd48fEf
         PX7//z9NnvZW9afww7gIRkC0imIcLIMZKkmDc6tAbDUI3zpMI+OZK85pyi55wjKnfW66
         TLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964917; x=1754569717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayWZPS7L38ZOhjcOnH9WSUS7UcJth2Mxw9Vr7h3Jt6g=;
        b=g2AaVpsD2JqnGgYF4Bs7JFTykkcnIquVv9YuM92E0HHeGsBjGEBo1wDyn59R8r20Xm
         82snwZcEgoonY+DBPNVm1vUYbzmrPjhVVxtKah3nsaZ73dbMsbcUJDW59tEBn1/gITps
         GrjefUPHzziN3FM14VRCyteCIqyRR87V9h7twd4qg15uPjyMBBIWKvdoHPf2XTTRf6v/
         n2jwTKy2hBRGOovMr4OlGew/31c7ekil6cV7E+PBUiN5kpZWEwnb2TbYViN3WSpF2rNB
         JgIW6Lt9cphWIawFw3vJgT2gTdrUgW9QC92ES9qd5p7+3rKFMwMKVW9GpEPwwxLrDdHl
         2uuA==
X-Forwarded-Encrypted: i=1; AJvYcCUwM8vdX0kEYMUs3PUNMdEZrvk/Xc6Nul6XcyjPX+wUtQKTuXlZcB6+a+/M07zC+zLh7l7DqokWog==@kvack.org
X-Gm-Message-State: AOJu0Yzba8AIlfoeSVBVOLZUaNWtkh9/ygBnfpJlZeK1EDlE3A7R8VRj
	rWJI39izId6+nIzlUORgHMdd/8jsVGvpBKpMV/hHUu/hgr3zi0XNIO5Z
X-Gm-Gg: ASbGncvOFh+k3wsUee33dk2IA6dkKd19OxpLwhuCs8JaG0JGWxIFRchmVqni614wMbT
	8oVCJ6eTFBmPx/6Lv9t6xo6wiD4oRkd5BKTqnz4eSpCNTPlRAZxHpbO3W7nvRob5qi62tUimJsQ
	fVlyEIRsr/xd2IM4sW3Cr8SR+EzvbjyFxxXWMzUMnVoeowCw53M2mYYZb4LNvk7gVVlNlPnRLYP
	RzIamsers9Og44ba1FvgrMHsS3ikPW7od/daKfD/MqG3XrG/yzo2hrC+GWmqM6pOybJN1QM0KAY
	SlS7+rGwQa+FUD5tJ+pfyahaZCWAoANYrJgUPvEvrlqYzIWv3P4iot22j53QZG/f8j4KWdR1bai
	YuomeUuDmnfvF6gGmmMc=
X-Google-Smtp-Source: AGHT+IE6BW4SDa30IuP4QhZLFrJkcl9wTyzJR0mdkv6O4rHte+RpwPOH5khsoAqI/rBgCbRpwrMO0w==
X-Received: by 2002:a05:6214:5010:b0:707:5319:d3cd with SMTP id 6a1803df08f44-70767456d88mr92125636d6.26.1753964917125;
        Thu, 31 Jul 2025 05:28:37 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:7::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cea87b7sm6577436d6.87.2025.07.31.05.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:36 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 5/5] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Thu, 31 Jul 2025 13:27:22 +0100
Message-ID: <20250731122825.2102184-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122825.2102184-1-usamaarif642@gmail.com>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22D191C000F
X-Rspamd-Server: rspam06
X-Stat-Signature: nmeebnyztcekrxphsdmh6hzpq3n8ecaf
X-HE-Tag: 1753964917-893991
X-HE-Meta: U2FsdGVkX18P7hfkDejFYZA9uLJ4gIXkstV5AkqNGGqXKjOOw2SQ2bvXHhRPJaSUQO6SyDgIfz+R4LGAWH/WNvDbcccBqMgNaocYs7eU7kR+Okz2oQwkYkhlF539DzKrKY2una3db7Z5SnP7DQGvG63/NAYTv6gKr/9Y0R8yESDxpfezNpJ65q1V9mpi/3jiYLaLdVQXyNuUMfs9X5AEJzxj0SwsE/OEqr81aFyVQvARU8cUvsIi3BvtFUaabQjn6hC0lH6UvP76a67dRrmL65GLMxpmB6j/Ru8655z+/5zQex4sCScBxUzrsnUAuP1cJGJGGCMQQ1vSqzCZjNPqJDBgQX+O1zL1EOIOkT+axTS5ln4xho6liONBJJUY7lit/yBKtlDTqtUn/T+m7j9hd6j4aP3CLeh03psZJyNjILyPULo+uF7GyW70COACZt1gvM45eo07kqD5fPS5LhAyzsqBiLA0Tx7sqQ+ZBE6SFFTLMMWx8yDd1csE/RLcdVaV+wjvCPB64iTHJqGHrFr3Bus8XhA0t98HgRPZIgM2UYE95HUHoXaAQCkcen2yRKrot/C5Pr6rjMbvRe9UkeCrd2NMYfCcUU9rEO4fWezUWNjPcNXJoE33hsA2pj6LhmOfxts1CzdxWcFgHgrkGyUmYMUMgyCbxr5rdXnm3h9qMCBSsMdrdKvs6QLDHn/48NbRnEkuO9oMx1o47MRdhq7xiVkuaCoMj+H/xLGWPnZfToS+LUxzb2+bQ6h5n/avXwolT7p1uLnO5Ie4ULwcAx+TYnBWulPHFbbmf6v+yajOU2eBWfrKJC1nKAP6IANbiPxunYyoGCwOtdH4DUbXg6HQaGUIDSpChBdXdXuq6u9gmFgKI6bO9H92/44sMc/TAa0Cbrrhsi8Z7cJIPAm3Hm/X1xw0ryJY38eEwMpOT5x76PiRlWrrpFqvo+Ta+1Yx5Po5iPlWY+DmENJwZLdz7C5
 Vc0WPzhS
 A1ObRQazLzL7BS3LyxGJ6NH8RTvLRad0CSSyXFBc4lfsZ/Bs4D71YhOhZmX6OxzGT4LOIQYOGxY97U3FVN6+Yc6/SHgmYFr7WBbdnUduGsGAfQxWXVwaOXlVDJQ3GU1lxu3AjRrQLaXJNM5qw5ix28ZdF4TwdCvC9ROS+k2Ti3dogVH3Fv/afYOEU7VKEf0oB6o/rGuFWZ6zxmFmUbHiNMrhxkZSezuhOPtU+NV6pDzsE/ALlinblhpDQGZyiHn5k2pW16fPdSAoJFvNnBk/qjdgUCvPm1840MqaPxSEGkMzqr1C+rqt/gOmUrr7u5SE1v89s5xU+O9Arqd7LL/i+HtuG6fawDYOcmld2IRNhX4EERx19jOl6xTSxufbrC03BRllleLbXDBvbOaUbbbUaVKlxfkPL5Y+kKFNuy2uUDIeAevKUb7HMPu/fiom/amXZp6wco8BTn3XwIVSro/9WdXD2ZhMrybWhqmsI0S833/f/FEd7uNEX14knLzDsfBBITGAliBBjV2cNv8CL/LAmIdvPWVhVkgdpA49qpX3+OOcyra/ArhXgKplb2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to never, madvise
or always depending on the fixture variant and the 2M setting to
inherit before it starts (and reset to original at teardown)

This tests if the process can:
- successfully set and get the policy to disable THPs expect for madvise.
- get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
  is madvise/always and only with MADV_COLLAPSE if the global policy is
  never.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- repeat the above tests in a forked process to make sure  the policy is
  carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 .../testing/selftests/mm/prctl_thp_disable.c  | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 2f54e5e52274..3c34ac7e11f1 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -16,6 +16,10 @@
 #include "thp_settings.h"
 #include "vm_util.h"
 
+#ifndef PR_THP_DISABLE_EXCEPT_ADVISED
+#define PR_THP_DISABLE_EXCEPT_ADVISED (1 << 1)
+#endif
+
 static int sz2ord(size_t size, size_t pagesize)
 {
 	return __builtin_ctzll(size / pagesize);
@@ -238,4 +242,117 @@ TEST_F(prctl_thp_disable_completely, fork)
 	ASSERT_EQ(ret, 0);
 }
 
+FIXTURE(prctl_thp_disable_except_madvise)
+{
+	struct thp_settings settings;
+	struct test_results results;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
+{
+	enum thp_policy thp_global_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
+{
+	.thp_global_policy = THP_POLICY_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
+{
+	.thp_global_policy = THP_POLICY_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
+{
+	.thp_global_policy = THP_POLICY_ALWAYS,
+};
+
+FIXTURE_SETUP(prctl_thp_disable_except_madvise)
+{
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	switch (variant->thp_global_policy) {
+	case THP_POLICY_NEVER:
+		self->settings.thp_enabled = THP_NEVER;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 3,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 1,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 0,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_MADVISE:
+		self->settings.thp_enabled = THP_MADVISE;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 3,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 1,
+			.prctl_applied_collapse_madv_collapse = 1,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_ALWAYS:
+		self->settings.thp_enabled = THP_ALWAYS;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 3,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 1,
+			.prctl_applied_collapse_madv_collapse = 1,
+			.prctl_removed_collapse_none = 1,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	}
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_write_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_except_madvise)
+{
+	thp_restore_settings();
+}
+
+TEST_F(prctl_thp_disable_except_madvise, nofork)
+{
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL), 0);
+	prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
+}
+
+TEST_F(prctl_thp_disable_except_madvise, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL), 0);
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


