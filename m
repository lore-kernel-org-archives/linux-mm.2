Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF75CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2208E0025; Tue, 30 Sep 2025 02:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82658E0002; Tue, 30 Sep 2025 02:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A658E0025; Tue, 30 Sep 2025 02:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE428E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:00:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64AA38795B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:01 +0000 (UTC)
X-FDA: 83944865802.29.86D0FB2
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 758E940002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eUSypA0V;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
	b=s7yyP9dJZmTD6sZPW0mSssX/Ca4JcUIXnOpUGJ/EXCItBIxui+uRdIrFkeTO/8LpeMQsOe
	KmG2yHsvE2FCxenDBAwg5kTCK20vBSxWIzJBhMU9noHcyo8Ly3z+zp2nYVKw1Ef9sXx0Hi
	5GJEXvvUasGxI19ev/57F8sr24hj3h8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eUSypA0V;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211999; a=rsa-sha256;
	cv=none;
	b=1MXXuiWKaFvhQiCqVznc931BK6UAlrkmKTVt6mLSb982WFzcgqdGrpVVAhB+xqgtXaOPLK
	4KeEUPpBEEmODZLqNyi8BXJYBHSYcUDEBZC8WUgopXpyztAzLjET+CuocnLSDylycYZzod
	sVRIv9kIwOtE6XskHymgkOZgnEAMZKg=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b555b0fb839so4047956a12.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211998; x=1759816798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
        b=eUSypA0VZmZpAOiwWn3UOzv9KQs9BsbAluBoQL4GNg4liKzZ5kb51P4F7zYpQ8xECD
         BXFdIxklGdW99vXAlw6wZDUMCTXbVsn3ctb6y1MyF6/3pplsme8q6Ndsk7U//pbPmz6O
         E6wKL4MJSdrB4HQTze8n9/PDFe3K7CJbzHadrk9PbjYntG+WKeBXehV2lJWMWKIXjwNC
         lw+JDd+P5JQxXBdlAduFavrq+tDFYYPbOfPegW7kd5ruCJrMvyNpf3G7dLt7AqscKL9w
         3eqyxl5NlYRyq6uLS1rMvaR1AzJX+u7xKzQ157rooU4KHN6o1k/ZN2ZU8H0FcBUnML3S
         kyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211998; x=1759816798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/w5JYrEq/PCfn3Rwv8DsVtkgCdC0Y7Hm3GpSfLGEBg=;
        b=CyahfC2n0Nj3epSfBMhk6NUludTl8AUhAmdTKwQVClG5UKKSlD4XLtavtTvxTRe2aG
         GhlGe+rDeRjvjrQ0+GbYKY8NM54xMUAA8COureZDr+WsLQcLGrmBy/2SbJ6pmFELjFmW
         LcJ+9JO+symnneZ4yuMwr9ezo+8YUDgHjFKNLvc5yBtfMR1l1bjtSxc5aTsi9181qgIx
         K+zbIwE3TENjUl8K8oqhSSrJWTNw+6RyNh8XI5KhRssWry5zhTwwqvGC5XwQn9RolwZL
         +JP/s5gshGUHJGi4u3tFaFoBOWJczoiTjUqaWN2+rKbWLjdeLV1Bx+Xjbys7TTAdfBQw
         PLyg==
X-Forwarded-Encrypted: i=1; AJvYcCX89h2flwjkgLNxiCclFccMOXLKA+mLH57Y7lz5P1V//Xkj2RCcs4flVrhX8zE3IH6fQzpEPBWPwg==@kvack.org
X-Gm-Message-State: AOJu0YyfcG1s25fDQtNQ+McKhGdvZymIbyNnKqrnzArsBrMUFAYAhKDG
	LoRNai/7RIOr5gFXqijzUHQ0fgaMjBGa6UIyufiwHrxrqhTtdEhvBb41
X-Gm-Gg: ASbGnctox7jWZyMkBBfv06OSoUq2n8auxtRS3GpymUAWGa3hFIhodpHpIcV74ek3+El
	RsHur3VhbmsXi6pXkxDvh3xLQ2aettmrFIjhv2/iivSvHNOBouxI8xgQXwHMfDpLqMh5nWl7ZYv
	4unOvrUBsDEAxGH+h4JLa902AqQzQUH8VdsFI0N186KMqcPtd/6MSegwqM273cq7NH09jFz4f5U
	J2rI6EpLV8RaZDK+u2u1pSS88XT0oCw2cjxe5CI6+cqGntmymIk5x1Xo2h5X4xT81zQErgB4CzJ
	+wSM/0A4BYkUeqCSjgRuOU6CAd0sfAxEUxvfsYt5tsfZXcTAEDDeETWVSA/jq8cn0vgAIur4w1d
	Z4AVyhJFf//cpolmX7KccSYZLE6XDGHZaM1qpd1d+yxiwTG8FUlecwLk2eL1gjoVStUI9t1mCnm
	RLgVCMgfUvMNkwAz1uOB5FQ0rLIwCfoRcrmzr+3Q==
X-Google-Smtp-Source: AGHT+IE9k45OyD1zQ/sX5CO57YKwXTRytMKq5dOgl/BGR9iX74e3JrI32v11I5E6AD/8k/izN7MaGQ==
X-Received: by 2002:a17:903:13ce:b0:275:c2f:1b41 with SMTP id d9443c01a7336-27ed4ada760mr178958735ad.53.1759211998324;
        Mon, 29 Sep 2025 22:59:58 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.59.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:59:57 -0700 (PDT)
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
Subject: [PATCH v9 mm-new 07/11] bpf: mark vma->vm_mm as __safe_trusted_or_null
Date: Tue, 30 Sep 2025 13:58:22 +0800
Message-Id: <20250930055826.9810-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xfuu8ckouqezwxd13b9go5oxkbafrntu
X-Rspam-User: 
X-Rspamd-Queue-Id: 758E940002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759211999-129118
X-HE-Meta: U2FsdGVkX1+JCbEPSRyHlhpnKveBptjiW1JZyGbguZrHhIy/ahM62GxkVI2csEz8kZ+q5r4AAb6bkFeEdgeYYAkQ4RiVjl0u8ISx8KGVCyLpSnfh1m7+hzm5h0AVnF4jk+5VbEj+bfbwIP5UqxD6i0LZ6jlgkokPWtjE8ARAJGwt9lwJdPds/9ARZGcdaP0tdwqv82xcC4qmW7+JmnkRaq0yr/DVmBHNhTEJks4YdIrK3cGPYfUh2+cPcvHkv1y6su5FQ4zCiFsaZUDMlmfDh9dU3nECJ09HLqm1L0eMFz+ZiC1aDYVhsP3BwQhni/ykrnttuNEgdPcEBkX7hJXFb3ytE2U4t6AY0NREy17kDgeO1SGi+kAHD3UinC4I0ItEImMX4S7vDdnfZeQhxGwmqowd8CUrGxNorpk/4lu3CWXkzQ97JUifAwpp6m7BTzJb5khIQTHxkGxCjIiibBj6uJCzuPH80MT+Itss6sXQE22/2CxP32krDPdAZg8Eaytkyj2Z+YB+B+t87DUt6VheQ3uYFlxG+W6LZgzR/fLd7aRWcpgomlMTiZOmcpzvG/87ljVtvSvanOlbtEQ4xxKEQWzPn67D18yt6fuugVbudKEyZDEolm9GURHFCDy4D4cOCPEjiCz5xuMi6sNXTYNmxfQ9dsHswiOKPllLy5SqGwYCDp2YyXLjZ6W+hHF31Z7o8lsfor7rbh3DUHeXJCFMuT0j6C6fxSu9YMgLsWEi8kQZjFKeAuoDneKBBh9mk4kqw6AGz7wSoZyrakFW19PO+snLc6hxAN5hyD64NZnyzTP69c4YlVB9ecNCC9MGRwq/AaCT89qDw2Boz80SxL5gdrlCxJXMtQnxsTWoYa6q0khPaz1f+s9Is2q13goujFk89GjluvXyCuVm1F6vhENfLb3t+uRMYSkcZ9tN+do1J4JMNYAD4kwszWvjGSQCypTTS/D1yGUeRk9HYhhXfke
 iVErAVw7
 o9AEi8n4oQLwdkgxUI/57AfsLYy5TBuPcvphYRwt6qqdRfYefu5mq+ug3DR94L/LNTYa+emjwnOn4DiI22sPiJb7iZqYpXIS5gPEiZms+PNIFTFEHKA2MrzEw+CvRLE2LTfe25s7mgA84Dltt9cZQjNVPARhTKFhonHLjVoTTzBa846d8iHy28r9yG1XGE5Y+R/FXYZr8xgC7BQa72bCOf/cyjOacd7fg4+ry7yZZI+pUgbrbHkLOaZPOfg5gUul+Oq8GoqoZbG1fIf73hPB8xzRuTkmvDucSjrMYdeKfqxj1SuBlMTJm+0D1pHPaGJYO4iykZMLMv71yxzw0f888N0eVF/Ad6OiLgo+dW+5mBM6sTbtQYMhame6++iEyPLCxtb2Qu3N96rWtPA595lohA+bLffnYhwcj+f4ZLQKREaDmF6o2WhGp8YXreLp7rQwu9lcDCtzBt/6paKnfNnWz3YL2gnnT0nzPNImsZ6i/MgC6Los1gEOyogAWM11cHkBeicUa2uAVWrkF57W+NzZznGnPkY6gIgyCSfjK2KXvi5Rqq29HvpY3K5nJyxSwB1rElQKAJuU/s+oteMP7kcCKdZjsXg==
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


