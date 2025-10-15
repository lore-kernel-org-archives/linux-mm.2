Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27537CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D4A8E003E; Wed, 15 Oct 2025 10:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A61B8E000A; Wed, 15 Oct 2025 10:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447A68E003E; Wed, 15 Oct 2025 10:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9238E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08BA3C0162
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:36 +0000 (UTC)
X-FDA: 84000554232.15.7A0A9A8
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 256EBC0019
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOr+3CVA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
	b=pECHBnfgmkkZVM3gfliQ3USFpj0Rx33ut85yI8tVbUugKaFhJsdYQiIZlTw06ag9686hma
	ya8gfN3JAmKHLiq0prygQazjcF8XukGuTbHqFLREBpt2v7hupPoBAUP2kkXsDnY6BiNrAG
	jBHkv5QwKp0ATpRi6O/y/ExJoOmzyWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537914; a=rsa-sha256;
	cv=none;
	b=ezmYWepADea4GR+QRW4HtajB+FZRfFzyK0rhlxVncngyVjIVTgeV/VnKUT00G+af2eLZPy
	6SPMajIHAnzkAn/Y+PTB7eligbgl6cN/dqbXuq4wd+O6tkBK2XCW74mc6zMMMcAyI5YbDB
	ZDH0equFmVON930pCa3wqgo68wAXjDE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOr+3CVA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-781997d195aso4803000b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537913; x=1761142713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
        b=dOr+3CVAYOI9d6tu3dWrFiCGqph4zQrDcKbTs4tC+f0X5LFWNbykPeCIjIzG6Avapk
         iZ27EzRHDR9sqTAniRmxFyq9+SWrm9nPBH2LJiz0SENEfXXLmhvYhH4w7y89FCRUo1dV
         JFf9AZnFrr6v+PQnfRNnAFbDN6jTXse6cTxG0QBBXWpRmX0RwF4IRrSZrdl55GuQRMgN
         cG2yCRQAhCTsQigCK4JK7NfU5mCHxC0dQ8LIlCON3Wnk5rUxUabFf7SC9PT4hTpWrf5L
         11orN5CWIJZI6V3flbfjsIZI8HDdlWIXGFQK8I3KmGkKfTFKQg0ar5PzVsIraNh+otCo
         kGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537913; x=1761142713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
        b=NO3MI67bVjPkIcHD3ZSMaC9/zljWm02kW77J32ClwRJbUR8zFRTsad8NmNEosvld1E
         MD1EisKZJhRtgNqjp2s/bgGcbqiRLp8o1jmWSHE767h4XOOqeFNi5qIW8XaQJqVad617
         PvAppTwVEmurCCwGMZY2v6fubg4qK63xFpEyCneOxn8RxQ58b3YL9Q5VEuVYn3TLaeaE
         Txy6eIs7wkd7HjWC7x24HeNi3K1G/gcCQ8x5dTfaq2QLMAMVBMN+dMv/3sZdqYJzGvn1
         WfX3KhMREVnMDr2fghG7ygusZAyaBA52rz5eoVoYRxVhA8x2iqehPbT7gofR5X2L6f9D
         OAyg==
X-Forwarded-Encrypted: i=1; AJvYcCWr2066y3Paiq/fK6IeyigBfSBQ3xlQSnuRlo4GCPiladRtgQxxvqnWHDozKdk+sRw5u0MtkKCQgA==@kvack.org
X-Gm-Message-State: AOJu0YzxnGqFHUuC7EFbH6imxZwY030Q/neiD5k9IKBlaWG85d2xAeaX
	H3CmkhJVgHVfbNanlHGVvW59wxmEipZ7D74tXhn0rMwESTR6BrSoYHml
X-Gm-Gg: ASbGncs3FKpSUHYz7s8dZQ2ZhxausjujyEcnoIDw1cP5Yw2jSLDhrM/e6tgct8AvMtD
	GeZi827StP75WPjFRch3+ZToguQNfZtS+apbQR5FBaw8EgOk4ZpTUJjxl8bJ+cxzUzvuJuWldzo
	Hs25yOxxhLu7QINSWSft3vVloatsfHgeavsHj9Ke8iAxOC7Glu2uMujlRy8dRzDDF6IEliBVGqi
	Pwi1Qha+wJcg9A1ldGBz0ywjRfiX6XW1y7nUBH1NWXqQcOqng9G6Q6XHE/8CIzGL/XUclIMcuLU
	FTh5fKE/1eTQ6OkASK5FuZ++jAtRQ4qBWYhnyfiYXa63DqT3wU0S3vV46rFEO8DhAWxPdvUaOm5
	34QN/A3fMb8w4KWYSamzYf7xlUtHjSDKp5dGhWuS3A65Q2Yp8z0YoWQIeWsNmRThF0lj7ZZ8klQ
	Pg0g+50Q==
X-Google-Smtp-Source: AGHT+IGMQRqzJHiHnVfuKEi8nOXVfKtRDNFlKQ6AKTG17G4aeKVlt5RMD53mTqVXNIbYrqDfmCyjHA==
X-Received: by 2002:a17:903:1b44:b0:26c:87f9:9ea7 with SMTP id d9443c01a7336-2902741f6demr352102665ad.59.1760537912651;
        Wed, 15 Oct 2025 07:18:32 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.18.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:18:31 -0700 (PDT)
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
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 7/9] bpf: mark vma->vm_mm as __safe_trusted_or_null
Date: Wed, 15 Oct 2025 22:17:14 +0800
Message-Id: <20251015141716.887-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: c6hbr9g58omepatuu8amcwzbhe3r8imn
X-Rspam-User: 
X-Rspamd-Queue-Id: 256EBC0019
X-HE-Tag: 1760537913-60336
X-HE-Meta: U2FsdGVkX19kZWM51i2UqO6BOB9BLu925Px60pI40BjLsq0ErCjiFsFkhn06GFyTNXrJElc/iqrJQ2eyq7A1tIYFMGKt3uzjBZDrswZGkKeQbHtfZxX81MsWH9O2CvZacLLVJvm2NE9zWZeDH191eFpKJS7ETP6lnrzTW7tfIQIfueaBTMOFmS3khGelL6VTO/IVL8F3AII1zCVg9L4+jF2mlxt3xg+J/tcpbqs24JqpNx3iXz5KbTSVE7Sc7mjUEME4ZicJm7vPstieFJ1994pSB7OHELzm7ogb6a65j6sUfBUqTXd5FNVqlbjunw4H4ZaonD/NJpiADeabAR9ZmfzQN40hA6l7dowV6qSEW49/VfNY7Hl2greZjjSRcTUbYIg9sAOCgSpAc5wy0KK53Zoa3b4YPPt9o8rbwEv5tbDdVZDvfZBdSsZOYXg2CxJulDaMAG9sAcMcgZRNUDMh9ww3YfuJb21DbZbD1sv4yjwGyyT6SpuWRrkoFak0tYGzBNQV6pXX27VEvl8BqcVo7PbH5zKedEQ2xppapA3pmuC4ctABYJZqZ7toRbjYAAesnPbGNwI4eyGV3MQOSQ89AQCcOGmiJAuXACEdsmDugvZe0u9Uyk0lMghaNJEWnu/S/cojr0VHz6mA2u+tO5T19wzmtw32LR9RMc1x3A8UkYkHINrZrjnIpA2qSwALbJF7DINtYwoX8npLAu817PycHyEJl+0tyrAAgIsSkiATy7We874kuz/nH7DavE7NAv3DpI33PZWYddKKpaEg6T76Hil3uHRzAkJfMtqluwmJqf9H9D07HAmHy29enuWybr74kPxq0HyjvETCf5qNEj6EKaUnARLRRfaRgv7X4jAtmcSD+bPoZ/QJzWgA98B5zeE6qbP9Srd33UdU2qtAjO+t66yUNBkTbW/3o+vgSmqT/qXrI3S7byswX18mJF5CCQKXk1YF/6WaWFU0e3kOiRI
 AUuozm39
 yJAPieBI/npxhuE24ZyasmFnFKEvDwPXFppZEZ7Gw+agoU+4fyhvPGeKBhgKPJTr5QnvL6JbWTdx69usKAb0V6Ks6apJ/bT+IxwtzCvPpOl/lW+btRDuE+du2OEKgFEOtdU9t4DE8f6j0MA2aafwPh80vcMTqWOP/QwLeH6vlTHWBdAVAYRqp+etNV8lv6ZTN8vaOGtBjwS541Il6FqcfHiVcVasgTkz8NUWFRDGdi0q4tmeJvgXT+NIGlxRRzY2vIZuL+qeuxTyJloZKss2yZpLSVuwdA3XLoWfL3iYntQgt6JucaZgxchPMxuZKiXQJ7UqHiU9VWAii4VJUrjkj6rFGSk7gn7IoUocyniey8zO5Y5FLte13m2ceFhi/SwjcAijYDHRpDQXYNb9EAKyNZFbD/eMKVpNko64b1Ru4iQjUOzHZPg4v2PtiE5jPxsNDggTc8Y0cEH8UKEmnX/Ci40LOw8c6MbSCcNDHSLiDEZnnH0Bf5MI8TnSblaZtgsXNn2uT9JGnJe01iRaNrCU8CJkkUYTQcuNI2YoaOjMZCSU1+776DzIHZYJd4rFkrYFq5aJvmYvY52lgnAc8luuLYz94Jw==
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


