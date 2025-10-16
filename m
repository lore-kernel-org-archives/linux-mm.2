Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BFECCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D948E000F; Thu, 16 Oct 2025 02:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6D38E0002; Thu, 16 Oct 2025 02:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78EBF8E000F; Thu, 16 Oct 2025 02:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6619E8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:40:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17FD1160179
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:40:04 +0000 (UTC)
X-FDA: 84003027528.12.FEE9454
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2107CA0006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:40:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jmxBsQgD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760596802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yv57AS0sud7udBU3VdeXqMkDWR8ZNIb3mkdGXwgT2dA=;
	b=rByqsUEjK5TJMLAmwQqzLjUHLLAaXPbcg2qP84UD2f7KU/4DmwDNRsDT6FE7z1nBxKA5VH
	IRjktPpITHpqOHAIJbWHVXJy/fCNXylfiCxDfYbOwl/HZ9/+Fe5O8EUx8OQYO0MrBykPcR
	f2rnVFRrn/nGhHAWvZ6+xjeSL9rLKFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760596802; a=rsa-sha256;
	cv=none;
	b=tOlb6ixkOsCbC09Zdrx2Pc83NOzqo8aPl7oZCT8Yt8NAcC95zBgWKr82VdeY0GW1dH+VlK
	AM/M3IKQC3ciMZr93tWk1GMXeEyhMCCFlswKH/P/XkByb4HzZP+BFe53S+tA8PWgE9uio4
	Ff/HaJ08X6fNz3GV9siQmZOH8IHFoKI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jmxBsQgD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2907ba47f71so4944545ad.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760596801; x=1761201601; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yv57AS0sud7udBU3VdeXqMkDWR8ZNIb3mkdGXwgT2dA=;
        b=jmxBsQgDx6JxLQ+L9xZcXBD3pKXR4y/6dH3RjmtutSsyDXr5wVpETtT9ClXomIhZSR
         vkAmA/XaXT5ails6v0wPuw8mbRRPvuUsHx2Q9ndPBxK9FiAgCJVKnjTqjG5PQ1MT7dW/
         mLSNibcuKMsiPwuRqQeAjVyWrTPO4YLpqJOk4XVmIDYaKjOOoq3MQq5O4Yh86O/nV5GN
         q9DxX4FBSVU7225hE9ZRfFCgpAAihyQflV8j3Oz2t5pnRTZjbLvxorti75uPuUmCiwnM
         VlUskwmIiD6yybd78QwBlLgLkCHugt/6Rvvj0Kh4tkHJdxuLgvH7pb0eKlpTO99N2Dcx
         6x1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760596801; x=1761201601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yv57AS0sud7udBU3VdeXqMkDWR8ZNIb3mkdGXwgT2dA=;
        b=i7DG+8FhgF3vIqNqoyd/jvJrK99KCjgKoqsMxRUn8fuuhFanED2/PiKYUsFQl3nSNA
         wnVstxsACN1Pu/UHcjUJwDkH8yvied598+H4JjJ9bbr8PnpTzhUqXBsPTO9wkwc21LM4
         9/ienwf5pBFPwAct8H6uxfswK3zQZu54Sgv581a323AQEhUh/6ud219WVnpz8Ng4t85U
         Jy3p3gr4eNi3/9QcoaQhHIFHP8xQ8jg2ieWddjCLcl2FFLqZ3Z2howqyUcQSdHJWW+h/
         /NWmOiDvzT8Yy5mLjVuHkZeCsL4d7bNU6vBy5ifUemEMjdfl/SoCfug9XBTj+6z9DSGR
         rCSw==
X-Forwarded-Encrypted: i=1; AJvYcCUDDWCJJlmXWSmLz+r1B3HHLlovhUgzPYPB6sH/QA525NXRUwHkoCSHJpty90CHsKxPXz1PwG7jtg==@kvack.org
X-Gm-Message-State: AOJu0YzxTZJ2Fj5QbsOpR7yRc492tv0v6Cr8m8aBoL0yfW2dzK2kbn0a
	t4FK4vZgTvGxSmVqn593p5WcJvELtEYKTxKRszDS7qh5BM1DXeWpqBCLrsDpkCEAeSX1Vg==
X-Gm-Gg: ASbGnctLApybE+Ofx+brKk25Z9OIgTTB5FoPlf/CqYycQMvD2ifT//rRQd9xbVzBM2/
	KREzqibIesvocW8gQOTszY8TcrDfSvndekkjxMeJSXiWjLye6BS/a2lDk+mvaUn80btFoO/EbIH
	5vooRuFZUA5dEW5LK2+ziEU6mHQe6tspGEJPWwh5pfi5B2SicWklPlVS3Gmm7PcJNBI9gJRvG7j
	ur646eYBUe2Wmm7DIZT2KrumHMSUDJ4Yxa4jP5W9JFyZ/xYE09CBazPfHKaohQoroJ9V2Uu6nXx
	O3e9K9uR5BiIBahs7j96hrKxD5xtqH04XCDZweIvxK0MVdXXgez69+G+YQi9jSRpwD2UF1na4Yx
	l19UYV4dwYewZiLIL8Ic9Of8qxAw4Ao/blGnt9P6Ot3PNCpBBzDCsbgmCtO2dzlbuzsaKeUBo0O
	1qnK9iYmHa3r8IketC1MHdIEXGgmNFfBxxM98skxcR
X-Google-Smtp-Source: AGHT+IFjar0LDP3QaLq0VkbUnnA8EmyZ/Zc6YPKzikaNOKCl7VV/VudUH0vvoPaIiBRppfQWPBa4Mw==
X-Received: by 2002:a17:902:e550:b0:25f:fe5f:c927 with SMTP id d9443c01a7336-290272c0a06mr421392585ad.31.1760596800968;
        Wed, 15 Oct 2025 23:40:00 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1d64:636e:f4f7:9293:7b0c:3078])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099b0215esm17555295ad.112.2025.10.15.23.39.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 23:40:00 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH bpf-next 2/2] bpf: mark vma->{vm_mm,vm_file} as __safe_trusted_or_null
Date: Thu, 16 Oct 2025 14:39:29 +0800
Message-Id: <20251016063929.13830-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251016063929.13830-1-laoar.shao@gmail.com>
References: <20251016063929.13830-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2107CA0006
X-Rspamd-Server: rspam02
X-Stat-Signature: jwjjr3exr6o6otzufc7r7j34d9jnor43
X-HE-Tag: 1760596801-546690
X-HE-Meta: U2FsdGVkX184WvizEhlO2L0MGowjQ9lcCNmCDpyZBZqR4lRFBlmwhR65dF+ZDk5HUZsgdh3DQJKiSYyqLIgGrDeTTIAa2YdE6mcJ+Qsxuci8/E1tj615jE1zMValP8We8Exx1OHAaSq+Y5MZtrpMJ3ggTP4oPMFztv2ZCh6nXQfxPSq5HUGpkNE0JHmFz2hEJYIl7UpEjo5QXC53WU68rxIypJ3gIUDRrWWeJF4Oj9X8H5pl6B5FRii6OqxfgWZXcKSx28Lu4A2xQccCB5BvwcNdHt4st1E79lOM/PRj9+cmbjAWxZ25QhQwts8ecQbDZZ6WEzA/fE+Hge+POV7yCRjpNo1u74yHgqfCkNwUS7j/j8SFW5By6HHJqpvUUkdf28nXGMtBHl75ZeBTF6HgRJ1HILYwf+anVClb5xvwbMWaC0dfVDTAKcfb1QHKaoTPkpGu27ZrzsMND8V4RMAhy5v+dfJPmgFCn2ajCnIGYU6xhyKM4QX3MkwaVzPYCZaTWFyBjbdrPEse0h/ADZJTQhSFjsgMkcaQhEt9WcJmNnZHE2JFvukbDem64EtGVBxbq6wA0JBXmZrnuedi09bvXwO71um6jo/VZtXjx/Jz9fIMCHcdenGNFjsSBvUNPB8vuNxjDfKT6Iw7hE1Zv4GHPni1rkddJmUloxOCs9tP8xxGR+MyKpN1bJ4DyBgqDAsKsZNHjYPliliYQR7k7rA3o1AdFZLXN7IxQfigc5VI0/cbr9qeqQOt1EvhFRYQ52GGRbGkt0T/tt0yEvWXAbjZVfS8bPdLXFqJqpAR0yUQQkBQ0YcxFS+FL6hiEe3SVZfPGyHgJba/UV7hpYR6i99PFAgUFioSknm9V734CuU15WDd56BW/kYDTLuIMpbT0SYoqk1eC+Om5hB9LMwxSyJsF9n1MRntUocmhNWhiX13EHXU47lubNi2i35e0OvUdinIb5uczFO42i0gXICgMgN
 6NuPwMVL
 TwVZJH+gcuPJ867qNhtPXEF0GCMU1jwuA/O2f3CL5eXS+1uzEmUjCxnhbiFh97ZnqCq40USvt0IJfVQ9g14Gr/3YQeg12mKC7Umpx+6KB+t02+64kPv+JWvsfHUvd1/yi7/dHsJQ7w84/u/dKjtZI8f8xQiiBIOelVWBGGFZxXo//xbE3ERLTYuWfOEyJJ++QfoA2jBmrJcRQFjcBK93SHYLc+n6tHNMmLtM+IaumHRpgV76KHmkxMh4UVpUWIbeEfyj6g0B8pqZGTlOaZzsoIwUzkkVgqzISXHUh87292XxKRTvKDEf5z0AgcluID93n10xMHw/Tx2iPlEulhhhogwK6BgiqR2nVqTIQwOCCVEFWbNH6CXe2feRDAKL/gXO9TGVtQbGScxPDJeQJleYjfYlPDWAQ0H3V+f8nbAIT18gv1bhRTAtXqG7VNedDCH58LkSrh4MK7k928qha+2MApQQzHHbBgpnV9SUnNcHmIcBpdqKeQJK6a6oH4upYovHKZH+c2L7MuWLVDORHIO7i1UJFou4GykEqXLihC8zqrIUs8kHNdmBAc6rBA1aVtGj7xmFmgrg3xkX5R/+jNq6tDN1Nog==
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

The vma::vm_file can also be marked with __safe_trusted_or_null.

No additional selftests are required since vma->vm_file and vma->vm_mm are
already validated in the existing selftest suite.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
---
 kernel/bpf/verifier.c                   | 6 ++++++
 tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d0adf5600c4d..9b4f6920f79b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7096,6 +7096,11 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
+	struct mm_struct *vm_mm;
+	struct file *vm_file;
+};
+
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
 			const char *field_name, u32 btf_id)
@@ -7137,6 +7142,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
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


