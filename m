Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D052AFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39F46B00A3; Tue, 28 Apr 2026 19:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11F86B00A5; Tue, 28 Apr 2026 19:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF276B00A6; Tue, 28 Apr 2026 19:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC4996B00A3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:25:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93AA41B9BAC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:29 +0000 (UTC)
X-FDA: 84709548378.15.09ABAE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A27740004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tk8v8nB7;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418727;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TT3iGrHZa7ApYuUs/9IDQZzDr6QU/IqtGKkO1j+po/M=;
	b=ZHMn5qe+PTkIjaX3BEMYXXajykaq3DPA0GqGkPnUQH82Hf9up0/RMAM8L65pDBYZowBOUJ
	Uyk+Ntxi+Otz9nLaXkh53kor+DS3gmjqbxy5Swu+F6UZCR58KXLMDAQxMak5VcbNxi0dCl
	zpObXsuhx86bD5oeS4IR9oEviXwKN78=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tk8v8nB7;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418727; a=rsa-sha256;
	cv=none;
	b=F4mCYRNx9MEGjUNA/3Y2sfnNv+KCpSTQtQ0oG+4I/rvYtXpvwdDMa74ZaDrgAPc5XXKkZF
	nloy5D5bTj4vTQFFM0xJ3WdrOYUKO6CzQdHdliyNQ5pSXI64ngirQdUX3QNAzi1D8zNFj0
	0MZffyrtr4u7ieNqa5MG/osUKbCM2/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 026684436C;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0E02C4AF1A;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=UjB3Q8xP2+/jLCiODH+4GnaWPfVWe36CvWf3Dh0lyNw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tk8v8nB7bwg2HgNUKy/3dSbh1sX2By5WJlLidJ1Av30V2f3k8yXSOmd3d+RIsUiTG
	 FKfPonFTqIELdBlrt1T2Ywoi5P6ZM4bQIS8EFRNrUskt+Wspz90GIXlWQhWORJshWf
	 H7K7bd4oD2xfuKY2gyqJZeb89PAcC87zJvPQz97dJjle3Q5+ztTFAk3SvnakeKdPE7
	 axiMB8p1x8M+XFyPbHFq9CBisWa9EuoFmU2VCWYyK2961IoaKOrxGnTvCveRQ2u4s0
	 SB+exL1U3B6OIz1E8XCK3DHJaiWTF7AdW3OtQI9znXEO7A03DDQnaFocSs8sFDcrwY
	 oIiepIJK9AfVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD332FF8875;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:15 -0700
Subject: [PATCH RFC v5 20/53] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-20-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1390;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9LP/svD9TvgxKqvednNMupCSsWJ+AFS+3tUCHtCnRqA=;
 b=7TverXUJlngRxhJ4vEWJkucYIO7XShyfSISUb/HZPT3irzIwFpodwZIaXKo0xt09LhSOu99cl
 vzzDW2Ybw7TASLiyA7ny4f0JXMSI7+HJSNDTw51rwwdQnOzO+yzu59J
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: yo53wygdgj3fww1phhga3dyjgyhqmaf7
X-Rspamd-Queue-Id: 7A27740004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418727-902978
X-HE-Meta: U2FsdGVkX18/z46SUPma4rSWupTK1FOydKmzANvGjDjOqdO3PiE0FJayxe6cS6gcwnG3ufQvVe3V7tmGfbKJmA76z6+dK0xIgaodqek1dSuBBbMWSwsZ+JGRHIMINO2X+GBvIZlefmfE8R48GpB6lcjfCairaUBckGSldUb/3BI3/cx+sAMUBhg9xcO2svhl58DukvyRm4q3t2rSj5RG5do6DuHCxx5erlFZxkNFZwwdUMIMDrzEYWglcouwj8GQD7pIgkv67x3YCYnmjnKAzc0ReNinFov74nuag0tapstt96Cb7geM/TG9NwDb7SMuuca+4EnvgF05nFSG669Px4SfPDzGaZm/41tZSzIrUUivv6ngg2KqY5VHeQoHqEyjTVkoWRdb+c4J4QkHmKkTphnIlVOx2HIk3y/Vdz013eE1+yrCRt1MWeegIkqoMYFkg0a0QsIRZZrsy7viYw98dO2Gn3j9fO8BgQDFejSXbTsheLW1H0cuiHQJlbHLP3/yx7UZRONO3BaVwByTf8wk71vXI5Rcl54hh8dXaZ/Y5LxR4OcJvPTSApbsjiDxGyNfHOroLiFIgF0KDCA12KZx0TousgTrWkPBLkN2cA9NxSZWt3vqt9f2SogMvfkmYPrDl/r5bF6cZgZQXVfDcSoxFxeF6EaLjyxIOnRSuPdeakASsRhnQ6jjQkLjNgjMQKjIvJ0w7RPx/8trtE8jyZGRd6aJyw/+3Vvl1je2upWZFW5LX7BUO4z9oDxToI7LH5QHaCHKWEzzhge2FqgxDFx/7P1stmW1kRZiYHj0JAaD2rR7gZFKLEeFjGmIz2/Zz2dwF0L83WxBXY/b9kPbJWrBybEssTUK/blwGq1plDee0LSWrA1PzlRqkdtelTsndzr8586V3TwfA6CnHNp3tCen7ZtEgdxRZQ2jwZJAFutxLtQY+K4rCorVTl0DIZ8wzCn386rI4DedUSSqTOuMewx
 81i3lsqI
 /ZFFcVgWrlTCzYT13mN49R37qO6zRNaB2hJtoov4a+uALSn7dIEZc5JaUGufe8VM7VI9WoiSkFqyXQF9B2m1ZHBuxa+j2VfJ6YRYsDskQz2VetiCz3vGZ9LTT90iEb/DqVXIlkrzYWsdLsXV5GE6fmV0AA2L/FVgMPjVj+rTBWzF3Lroe6BI4ZNxjwrxBcKQtQRvTIiEJPgBTSBcZ+jdyOAayw3X2JNjNop6BQ+Gc/TCw5tXjpUYKROlVGgi48UL/LuZn707V2zcIEWB2OsMu7b0eldPcPuYHQhQrlcIZYAeF9ZkCPENn+rbTvTXuHbn1f5/qxPGuWNGx+E5QJ1JPmEH5lR1YJqn50xltXGRByC/VLuNnyJGYTdfQiJKB3bHsBDVv6mXblAhywLoU0SQyBVt7fLAh91u7vmwotdcA1YGn+Nh4Q+KZnnEuVWRReuY/3n0eGVztNbiW1PImZWS2OXcxFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
are disabled, i.e. when it's actually possible for a guest_memfd instance
to contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1560de1e95be0..6609957ecfea3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14172,14 +14172,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED isn't supported if the memory attributes are per-VM,
+	 * in which case guest_memfd can _only_ be used for private memory.
+	 */
+	return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE

-- 
2.54.0.545.g6539524ca2-goog



