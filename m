Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F2FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE4F8E001C; Tue,  9 Sep 2025 22:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F398E0016; Tue,  9 Sep 2025 22:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88DE8E001C; Tue,  9 Sep 2025 22:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D35838E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:46:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A9AE160631
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:08 +0000 (UTC)
X-FDA: 83871801216.30.CF79AB5
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA3F614000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a9EKifPb;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H52BMjLyLco7XvI71nPQFltzBJVr7MnXzqkREPVvPkU=;
	b=ER3Q8Mm25zP64M1pf77wLipjI72Mo5nBK+DAEsZJDQhyDY2mzN+CdyZPoXUZo5ZET2i6wk
	9bmEYKh9XDD1ffA8wLIjie862wCHzbvk1BWfT6KiZVaDaEQSeF8mNaUsTM5vr3QYN9JvrI
	2QSW4Psbw+X6f1NuKe1AuExuwLBF7Zc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472366; a=rsa-sha256;
	cv=none;
	b=iLTZrnMkzkxCsVBGi4pNDWwty02TG3bsSkI/iepevSYAIN5o99/3czdgs0TH4/o/d8bqFU
	Br/F4TEj8Oy4CIKMZ719Z2SX6+bNT4JcKKWG4zz6V8B+nrRHxVSjdvTFpyQWnGVMPxiR6l
	2qa3ZC0NwiNBgtMAW/jUlFQEhIRf0As=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a9EKifPb;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-32b70820360so5045139a91.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472365; x=1758077165; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H52BMjLyLco7XvI71nPQFltzBJVr7MnXzqkREPVvPkU=;
        b=a9EKifPbq/pEazoSVlkQmq/DF73mcp/2QHCniP13ZU9xFZHrwHwLrpjfOJN+3w+SRd
         M+eCfemUxUpNurtiPlqNncTnIPowrIc3xT8y6XwiovtKbzyajISniOT5+GylT6NJ9yPV
         gZbBogwT/hQPwQGTjMcn10L/CwFT7tf/YYHB/TTqIFzbpLuK2l18Iw25/107GZz6FLwc
         ULmSF5o4S51ATEsAgaxCv4IoJ5U4jewuMENcuSL11Hp8QVKTkV/KTTAWyS53z+y7O69+
         Ki2bcZ48s5denGe5NcYLhMArLOf1hIn4Qb7vNOZ09sl/wazQayebc1dAzCgoHcvD3O/N
         zStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472365; x=1758077165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H52BMjLyLco7XvI71nPQFltzBJVr7MnXzqkREPVvPkU=;
        b=uVdXMRa++RHsyY4BMY2O1j+JjkR8XZ4DpcHB5K1yS8p8IwdbXV+Fi5aBujDW52VBiG
         ldCDmlhmsWY+5ZvYnlbcYUTROsV/pbbF1WYWl+4aqbRA1wbXOt2/RG0SqWbL4YyrlGLF
         RI0RrD7bGPtj3LxM/F6J/htruf6KCwYERtGUkuvi6Cy3LKnNhlwFkKgJamJbtPiyJqjj
         0vOCWw22rnqTPE5xDvjfUgfKm7oJko+An9AxfUaDa5eidSpMPDuki6vK4tOhXuIOjjYl
         QEUOWZbfZkS/g74SJBLzf0flg/espp+2Q/zrf+FkvuWLef8/k/bf44dCdfJSO1FwHqfm
         FfxA==
X-Forwarded-Encrypted: i=1; AJvYcCVyGBNySaxKAJChjN9NS8JjjJsVIyW+iLUb3KC4nmL60bV049oN5yz2r+xLzHuwenaNYiZ8g+ET6Q==@kvack.org
X-Gm-Message-State: AOJu0YypPg8Vouhhz5jOVo1fLTOvX0sTyP/+RnbVbYb8ZDSRU1c1OECP
	eGWQGZbyoQqpbooxg2C+0cDF4W9UdXbNepoB8h+QlEveFk+Wkj8heEGy
X-Gm-Gg: ASbGncs8TNeU2ysm2JFetnXEBPj7qlw/zoXCr93HwYubQ9v2GW8hw7P2gy8prFg1WiZ
	i3zZMcFUFx9yXN6YtiPNRAqe8C+lb3A7Zo0951/SBl3Mq3q+XBjKCzSV4C8C5xUyNB9ig9odmM3
	iIA1iIo+dJSBHWV54h2TIeQAJmcjI4ZoBAcjUwmw79KLuirQ7P4jY9GRPiYC7b+s2CSCqqKnKxL
	P5xZ1dgFqHz57OpsKCepsVjXIE68XQvKIp+oScLiwmzvOscRCRrOB5Uk1jxdYMzoWkIL6ofqEtR
	nhWzNoWgLcDRmluQ9GJg6gjW90/EESmPOawr7BPwd7ExC9Kih1WLCleTWtMq8Wk43Vn0dKdwCST
	/wc081LgPpxtsSKPXRVEKrwuECgk/J3CfLN0S7Fk4Fe5IP3tpOEEGXSNKZUEpq1t2o7TxVaz2m1
	iYiKyAA9mY3G2gP/XW8HtT5shO
X-Google-Smtp-Source: AGHT+IFlxlKSCMUqw8tmGfRinu2UgcuhU2GyAppxt8KkAQwwLR/IdUn4KXAoxACQUsO8Cs0cvPq5TA==
X-Received: by 2002:a17:90b:4b8d:b0:31e:eff1:71a5 with SMTP id 98e67ed59e1d1-32d43f7dd49mr17140406a91.29.1757472365388;
        Tue, 09 Sep 2025 19:46:05 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.45.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:46:04 -0700 (PDT)
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
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 06/10] bpf: mark vma->vm_mm as __safe_trusted_or_null
Date: Wed, 10 Sep 2025 10:44:43 +0800
Message-Id: <20250910024447.64788-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h6zbm6ojbka55wqcm86j9p9387efac4a
X-Rspam-User: 
X-Rspamd-Queue-Id: AA3F614000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1757472366-215120
X-HE-Meta: U2FsdGVkX18+SmFiCbZ+SZLcvOWnswB4WcZs10gs6IqTtUl4xso9Aqmgx0V4XAFDDGveFxbxq98kZ/AkZkxlpFlDq1TFiihMCMF6izRABuUXlvabXrkC3WBczcQAVHawlfQdOkvC9Mh9q1L0Enk+KRiQfAI6MJXi8vZKveRMaOjF0TLm5sWxwccWunu49e/rgm2wkyd+bh/uxZ6HEqp5zKGCGSlVF4HG90BakwAHKM8VlcgyBTawMmxJ4sIX/TDxe6xs33ejjstAbtNP0HIDP06uxAOMYARZMibEIMe9LUeibwrhD/m5gWf96c9SQO1EP4ULqtufsbNQsLpS9djcz55sC0f6DQKc5V8PoikJBaxhcW7Ch5m5cQk3nDRiugUNT6WRFFA1ga1EE9GYKiD+FrS44Dtk5LqV03MMiqW3DZJbVLXumPhe35mRD7ZDbWzxRAhW/ckP/3fE5yqDHkG4g++UFBvYrBOX7PIxCKh6RTejb99vEtio4ShLuIaqgY9Bh/nGIkLtYPseMQ8M+3Es8l+PlXqGb6N5jVK/RzFAdhAwfJKi4wdXi/9BdIGo36FrCE75hIAFcOO5pVMb4+WobGn8Z2+2eW5LDY8V/tJGkHxK+MCjyJCl89rLFtmVx/df9BYEHyhKr52RYB6SjIAsCKGvHqqKO5lIDnf8gBCjk59VQFVCjuvljWoPIyq7M+zEiBARAZr0qdkVuwPJo1V/3S2cdI6pAkXkij4/ROX3rB3rsJ7NXHp+6aQ/xPhAv9dzRbQfghzf9XMOYwUZ0h7HHzzfgPlcEMs5Ly9MUTKXRMSGdF2KEq+ax+AtC32SvRm2EuS6g/TML+ajs4M89cUP7s89fcelmJEprT1eIqC94vf9YO332fRDQxLnE7vEzGjB+xRP31WQBte+VV107Id8oeCcRSdvztebcfIpta8w+uo9vRIYIjlUd+dvovihldqwFQ9rgRdeBvwkJBW8rzf
 7X/2p+pt
 JZBaNAT2u0CNlmT/GeugCqCF08uvxm7GRMui+EpL/sIU9gWjo2seROStmgP/9E6aPZVNGg1K8vU4ThtY4GIPMteu88DpxQb3ANw9fCYEOE73B9c9pzj57hSnf+HzmcO/5pZmHuXLlCABakkaubbOZ+HDbM7idh+1VnSSO1yhofc2gDDhCTcH2w/L7RT4Jz8v/jAoiEBO5LEmET0SpoVNGHVpl4jhwj2lncvmfAI49bwjGJO7qhR8puDg2irxHwc5ovmk5s52cO0Smxr5202ad4a6ac4+gBv730TjqK/Yv8VTcnb+DcdohgE8vJkmsz2dOd1aqXsp94cVE6V+rZc++G2QhK0Us6wDuKC9i8RGi1QMzVFhjvb5UeNODSAfEpsf91MVc0u1/xWbAU7Ka5k1Fy3RSrNe54v+98Ar/U7Mp17bzJKz8LsNwZPUFweaMGhDi2WRWEjlJEboTdi4nsYXAoVv/fBMgI2WSZXaU/HKQJCREN2+lnHDIhxgccdj213KUtjKRir41sCmySiosgONfdK/xzBPU3SNUmxhqdr9Cy1ruLy6K5J1+ps5yAw6n1hK/TFFbNXJiHI9FHKvllcHkxPLBAQ==
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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


