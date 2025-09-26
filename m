Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB171CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6A68E0012; Fri, 26 Sep 2025 05:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059218E0001; Fri, 26 Sep 2025 05:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A3F8E0012; Fri, 26 Sep 2025 05:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D18458E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 992D311A208
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:58 +0000 (UTC)
X-FDA: 83930892276.30.075E4DE
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA78140004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpOWKARD;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
	b=Ct93lcRMyfinRTWaZj73xWxyxyV7ouRFceeCGxY2ccH5sbA/RO2gE+YZhlxzCB9EQV7021
	NXsiXSVHcEWnW51v1nrvlq6Li3vl+C+dZ/YFiNKT7pdbztt3rFy5LLXeVkMM3ysE5GQpTu
	MamYtiL0dY4sNZuewDHyJSAYodtaO54=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpOWKARD;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879296; a=rsa-sha256;
	cv=none;
	b=Ol20B/LTmfZf5OMcUOfjtKme9HC5BYTrZeQrvN7L7xVCZtD6LupQlJPEenWYcoErQhDutr
	A0fbH/hySlxlIVoyOnWnY4jR66xnbrSLBjLQYuwWQ6CtsX5m2wnur8X6LT8vm/k8GpZJq5
	bT9PRn33Nha5IYQ1Bc54eJwRuElxZtU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27eed7bdfeeso9307255ad.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879295; x=1759484095; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
        b=LpOWKARDkZWqnTgXxqSBxZ8B9vMfnubMJxC0u5xAhtNsemvwULYs3+5nQRWZn/BmQV
         vtlz76ixlpSu4yrDLitd4kr7Cw2MiQt4Htr8VFgaTNB7rapIQu1GLkOYY1sLT75H/yWE
         8fbzv3z5V4/30c1w3tX1ksJZKslmULX9MiQNkJwJy5RfyWAq3t6zgGJuKbXKHVAzyYE5
         j+8dROQaAyyn26r4qZK7dJIkIpHh1A0A7JLhO3kp9uLrx6yNISnTxr9XA+oS5nYlcoaj
         /GmxEIZQmEK7kbUcz92cdOKBQMkuQ1UNAzfgdMyU+CEnzsM13CoWk8YI7wFmitJWYZuU
         G3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879295; x=1759484095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
        b=VbyiKRoO/4+TQ0hGFaU2gBitbx7u/cYnCuN8jc9piryNkoLgguDQbksEIQAm3n4iLN
         X0gEZ674LKhMIfwyEOkQYwp/1YmtlNpzyA+bUIkHnKsbfhJbbIgmwuZbm9l+anZD3qko
         9v3pdlDtDoE06nMOvT6QDrx+m1HBvZkiJ4RoqwckwhvGanzNrwM42cHuOkLv6CI0oEyz
         MYhfEKkx8CWUWE5qwsGvTDJSuFHws6k88E1fPiXrHvZ74a/ZwZ8weFInoGh8rCX2BJr/
         4+I6WyOmLK7HTyxOr8czKvu480ioOJ3guWTf08nGehTynnZ4fd5QJCYec0BV76JdldqM
         BmHw==
X-Forwarded-Encrypted: i=1; AJvYcCUJBbdjihZSaTaDVOgzNszdIUrSV+oT+bXK0tgRyVkvZ8vOoarS5bYNGZmeCBrvTlLVUNQ74emC0Q==@kvack.org
X-Gm-Message-State: AOJu0YzyJ3A1zzuBHUvCT3wyuojVpE8PoBU/w0yBiO+iql9hCbuDrrjd
	7m8K+U3Vl8AVn8ca0/1BArEdI1j4asbsDcN+8abHbNGyPTiXkLkpnHeq
X-Gm-Gg: ASbGnctQkbRM/1yhzox6kkcMfTUauy9yW6QhHDmxs3/M9d5gpE+KZJzlqm8HA9wxtU3
	8ZSx2zjb/rAnz7VraKlBOcR6t/MKxMMbZZAk61an+lwRhJoFtyENHMKtVQNWEwb/orQN2bd/s9e
	rYVRoWnzIIvNwSGSgDWj/huwTmLQ4k3iiru7C1T534UUJ2HB/N1DPDFo7koTupBXal+StW0L4yQ
	t//PB8IdWMFuxigfUFB6bj5u4jzltNNHksdrqtS/7iACaMErkI1NipCLF5EsQDckmObS7pX48Um
	5zsYP38bT8icBps0dQbRDF8xeDUxO+FBFvZ43sR6e/KTdac6ImR8x78cVfWd3xDXzYAJ3X/oocE
	l3bVvFKKq1cfmsAl4hdvKevTNi04UCACN1K4EfoZ5oCwf5WOLSSVciWFQU0fvnn3bajdYcKDjPq
	xQQ/EuYY9aB9Hv
X-Google-Smtp-Source: AGHT+IHrdjXmU7uWxKIA6T2fxuFhYbTSMB1I+H7KjcACH1uB/bPjPmFTLzfvYSiunLXewY8lMi00xQ==
X-Received: by 2002:a17:902:db11:b0:27c:3690:2c5d with SMTP id d9443c01a7336-27ed6780b92mr76951455ad.0.1758879295495;
        Fri, 26 Sep 2025 02:34:55 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:54 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 08/12] bpf: mark vma->vm_mm as __safe_trusted_or_null
Date: Fri, 26 Sep 2025 17:33:39 +0800
Message-Id: <20250926093343.1000-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA78140004
X-Stat-Signature: hmbm4834ts8dm9qq84m4rs9z4wf5fuxz
X-HE-Tag: 1758879296-663960
X-HE-Meta: U2FsdGVkX1+wDYOH+GQIURaKa4snDoh+cYKqFhNxjNLcOeLV6dwKfkQM/bHF/6gtxo9wYUyY1cTWg30bsk+HT3vHj3/ukDNHyyrW3q2JcW4zXQ8oPqdjS/gLFpJdhiUy5ZtMZ8Q0QWbQLqSGXxnq8mKEdOKwZK4IHuk1hBK8iDl2LCV2sccViKHqtb9jxPYN7RKskq2VBRpEj4pVyMiB6TUesaoPz7M6ykE6+a1fTEEzD2p5nZCf4S6i0jhbGP5+ZapJ7CTN556Ci2/diI5ZYa/VB0LQJ685mNiuffAB85MvzBYx2L61SmFVtCvqaa1ePU5/CumSLU/IMSEETVbcccnisSFrivcbW88hkI14rxEmaXZL+DeXUVDHGPnO/1StYmCDB1EdkQgy+278M0Aooeip6OeXr0a8YJgtNkxZ6gWu/R6Vt7kzGHcx6/j/kiGqwfRwtpummAcIvmRta3ZuO+LFPJc9GqOKJuHD/EpqPrDnwA8osK0bDfIVwRB1Krro6Fg0jY6RC1TABEKQR8zSyxrDXiRtcShMfiNtYKIALnaT5lURG98SxlLGB71shme+iOknn7dkl3/9kbL64NLetIvhAuPsbqqFvHhmqu0aNMGxzdJZyCjoqVDKkwwO/dTcv7uQYcO7+gNQQ3powIl7/EUM4ueptG6xbSfyEVn0/px8i56utbfnHnK1zM24XmT3U30Za1UmHVoj9gG/ygmzek/nsE15ehTNWGQgAJG4gSHaBBJbuXBLRCUllgB5WEQJUmV8EjHjxnglinNPiearFctsxy/ueEIhTYUID12CBVsuONswSncaJRaxwDtXXYbHdWbaC1GdMEmZXuhe0qpcIfn0EeBZuInYjtnUDkstBLP9DU5NXr0DDCIHMbcuPohSrAu4s5F8smNXKjQqFtX+hMyblyUeR4OPQxTlJHI6p7L1/NvIJZt9RaNryWdmHEFgUR893ys0vV7jYMm9UMm
 XJvaCOwj
 mKqcu2lKaM80lm+3Jjg+ceVgoh2GJJLFMx0ubiYzTnjM5ScVN67KkVmwbprz7Hltcey78PD9fD669eL0nI3pWRnsAPh1CSJ4xx/btKpRVq3CWzrqNVOewR/tULZRrztlWNnHP0XqtlfMujkNSBpQfsbWMW1eBRWiO2NLmkPgO4UdOrhuxBF72VeZFw8M4HPnj8H3dDDPZ+8uR75s414kr/fyKOHiCbfbI58hDFFLV7sfKRmxxmE92yD+VCeEOvTe/IwRjlJETdXSJmmfBlYF1uQ9wnAO5nbstQtZPxulmyqGqHhT9KUk7ev6J7idOi+wo2TDjrocjhv5/zNWTpeGwck78rsorMAYCPV9FymK8s/SoPBeqLVgVlZI0GaJUyGuxODM9iKVJWN/NsNmGM+kw/Qc90KMf/0Nj7CPO+tONPd5EqG0aRwa8UrgXobqOMKBjZ0q784Ynl7bk+cJdoEe6H2dyTKeULV/MPnOCyqpMHsHzd/0R7iNsr+/tCDr94tm6nyueBgClIsE4pDzqb+pECEHoN8BEkKk6OFRsGdkaJHzs02IkcgGraTHdIG+0iu8NPoWhQ8mjE/NBh7HKgAP/5gbrhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vma->vm_mm might be NULL and it can be accessed outside of RCU. Thus,
we can mark it as trusted_or_null. With this change, BPF helpers can safely
access vma->vm_mm to retrieve the associated mm_struct from the VMA.
Then we can make policy decision from the VMA.

The "trusted" annotation enables direct access to vma->vm_mm within kfuncs
marked with KF_TRUSTED_ARGS or KF_RCU, such as bpf_task_get_cgroup1() and
bpf_task_under_cgroup(). Conversely, "null" enforcement requires all
callsites using vma->vm_mm to perform NULL checks.

The lsm selftest must be modified because it directly accesses vma->vm_mm
without a NULL pointer check; otherwise it will break due to this
change.

For the VMA based THP policy, the use case is as follows,

  @mm = @vma->vm_mm; // vm_area_struct::vm_mm is trusted or null
  if (!@mm)
      return;
  bpf_rcu_read_lock(); // rcu lock must be held to dereference the owner
  @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
  if (!@owner)
    goto out;
  @cgroup1 = bpf_task_get_cgroup1(@owner, MEMCG_HIERARCHY_ID);

  /* make the decision based on the @cgroup1 attribute */

  bpf_cgroup_release(@cgroup1); // release the associated cgroup
out:
  bpf_rcu_read_unlock();

PSI memory information can be obtained from the associated cgroup to inform
policy decisions. Since upstream PSI support is currently limited to cgroup
v2, the following example demonstrates cgroup v2 implementation:

  @owner = @mm->owner;
  if (@owner) {
      // @ancestor_cgid is user-configured
      @ancestor = bpf_cgroup_from_id(@ancestor_cgid);
      if (bpf_task_under_cgroup(@owner, @ancestor)) {
          @psi_group = @ancestor->psi;

          /* Extract PSI metrics from @psi_group and
           * implement policy logic based on the values
           */

      }
  }

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
---
 kernel/bpf/verifier.c                   | 5 +++++
 tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d400e18ee31e..b708b98f796c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7165,6 +7165,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
+	struct mm_struct *vm_mm;
+};
+
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
 			const char *field_name, u32 btf_id)
@@ -7206,6 +7210,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
 					  "__safe_trusted_or_null");
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index 0c13b7409947..7de173daf27b 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -89,14 +89,16 @@ SEC("lsm/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
 {
-	if (ret != 0)
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (ret != 0 || !mm)
 		return ret;
 
 	__s32 pid = bpf_get_current_pid_tgid() >> 32;
 	int is_stack = 0;
 
-	is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
-		    vma->vm_end >= vma->vm_mm->start_stack);
+	is_stack = (vma->vm_start <= mm->start_stack &&
+		    vma->vm_end >= mm->start_stack);
 
 	if (is_stack && monitored_pid == pid) {
 		mprotect_count++;
-- 
2.47.3


