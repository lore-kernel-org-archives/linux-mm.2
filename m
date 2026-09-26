Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BB0C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1026B00A2; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECF96B00A4; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B9E6B009F; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D49DE6B00A4
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58C48A696B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.09.AF37911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B0A2C0005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gnu/hdLL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rf0rckPaB6L0nziF5tqyB1o4FRUkOiMVFAPZejHnrSc=;
	b=rEo8IEn7kuBPBu+cZEoBKsNXTdN6Rp/EffC26gG6LVwrKRIQEwS3KDuT2NK2tmsVIeLCHU
	d9KMvZeK3oEc+wyK2NwOA1IeuWS9H+8uC/alMtjyZDWURxui77SSJFhgFhaiuysrpCsMr4
	UXvVxo/2ETOlwjAdI+AgzFl02THK+nI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gnu/hdLL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=1J/unWwDFVsUrZXPnrA1y9hptxFufSEUZjJE0pFQUK6tgkZHDZT0WBd9+6/MeB3lvCgdkV
	9yxIZkGZN78mXa1U7h8bTX7qNrHCVH+FwO6YHxu8i3Zpt9J91WahdYpGEgIZGr4HBC0Br6
	fuNNE3o9ayO/5BD3MlS7LiPYn4oPGc0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E994C447C4;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C714DC2BD01;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=ZQkHIEo90myH/etAY2BZvV0PdV/I+2f0qu5W0si1/Vg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gnu/hdLL/8rQ1eCpICBDMgQ5bdAfMXUZB6QclisY2veSfL3KWIII4fqBZJYUbNLXp
	 gQeewK6auA3yOn1u0DybDlBl1Ma8sRYeKLTxqDUEH0E9tQKvnfdlPLP1VBfE1GIjZh
	 OIp5kyd8evCiqHhDMCft3eUwZrsrYf6hOBXhO/DHPmm664vH5pQ4Y8xto2O7yG7Lw/
	 Gyk79kiUiMgS4apZ8IdUqc+/Cp8VQNlKPRNIrQUzir4XO3B78NowK3TpB0eaqESPmR
	 UL1NrQQMWmCfQgNokiG42aDhn2vItl+BXAterA85xlL75uU2yAvZZ+J5uO+Gy5hR7L
	 IDfa0vpXFdngA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F4BC98331;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:55 -0700
Subject: [PATCH RFC 08/17] KVM: selftests: Test rejection of tmpfs file for
 resource_fd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-8-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=1833;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pY+7zel/xk6auUHj9TI6BcpE5A6Lb+XZc+WYc5WnDfM=;
 b=6ICqdR//hE/RTxLIzxROFfy94V96cNAwZqPG5viJrO4RVBZA3wcH6/zTFcVp2BIl7ddnTJ1D3
 XWEO8D7UwtkBxgYBX0V2bQmanCnt1ukpEayqoKxStzdpPNHwXUpIqF5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: awwmmqkmh7jb95ftj4sr95m7t9bnj9nt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B0A2C0005
X-HE-Tag: 1790383855-830024
X-HE-Meta: U2FsdGVkX19UPzvZ2i8tOaZsT86yC6NKyIMEy8ljT6QfqU8rCdcehWzTAamr/NTCu8R/eXrOq1ZdnpxIq0NMmuZqNdlVujoXUBG6OcdraP/Z+mZEQrdfaDvq2b00PiNZILrkyZD4R/m3KBDHKPgZ2jtKnmGWMCFvaKZ+9hOlarlTDffI3/mCRGHoMcIIXl0HNaNzLNCSlyVuplfcapDGTB/QJNA+6TPdhQvHpCKqJSwtBVOeYSXRGYU/0rE1WnuhfxGRbh4ni8SYcHTwm7Bca/+podYWySDUnyYmK/QOUiQ2Dcyuj7UhQyKOmjb851FcYTKnLakDEBcj5d5wGdBdRThC6aCBULT8Y4yCJ1zot/lb/xxbjIt1/D930Hf9K3MV3ACQaZBlfiPenMJAfD/VWY1pFdb77zHf/vhSIUz3by4H0HpJ1BdmhSwH6JcTUy8ekqjjnqKLB/N2Zf4gGfne6xuEVebfwuxGE7sgR72rqBLXGQ+uV5c5GaXG0S57ROXHxDPmK4pgVTHW8rMBEwg2x/dJEIHq9HVlOOTvPXIuZiPO0OexjXGlH4PdomudH8U3tUO0JJAkGb8jfO1Af9aEluTAsewq/ZxXNjL4M25zk94wrwvpj1k8iN71XTYgqT6pCTQpIlhtPj0aC8o52hFhVb+C0fw58TlkJaVZj1h5tX+3DjMSiEsqZdyRnwSpoC6U/45ggRf2v90egGOG5W2zDbyg033FVil4vbkl/C2Hwy6Ek+d/9owDTskZWpxUNdl8cAzwPDsYgSNaRLTxoUrp9fp+Fzbhtm2FDXvM88byU6GF/MXjiV1eX5+2HlbfLA+CVnEpFwu+TgHVdpqrd3qzDCiVgSPIaxfapkBZYeEzmHX8wBIMk3F9rKcabSj3+jWovpjwnKGVAYBukAv6bgpfUXMBPlf5KEtHM+sFDum3UevqTSVfb0qnNkfgAm/5+JUJ4JgLrOUU2U7sG2q7K48
 cyBhwCAT
 Mx3O6lSXW8gO2fGuCLcDbB4iSqesuKaoMzdArMb+3CSWT+U6oPR4hOa6l8uJZx5DFfSUKUgj4IHFkqRP35ezuyDK02OlTIw+1fq4FDOXw2W1M23G2Gl14tqzUoNeNqoi8cxSr5I4tBarJIhEMW3qdlmMkoHa3SFoS7reOKjJVCBaACqjF2c939TQQ1MmcgUNXP3w83ulIVBSBfTZtKcw4i2YsGbeg79Fk2+uvopSGvThoTKwoGI01hGnD4/rVcYXaFfju9GPjA0Tg2MpFaBmwyiVLRsCNmJJzftZOWkVr9kLAvmH+fiPLOJ1bGTRrIguQ9EQteZeaEeR3YmJzWaQPZxK6X9vwKtTTS4ct845QahT63SE6WLRmy9sjI78lqYGZiBR6EAQELBfmTtX2MvafSvxJKCV/XHkfjxCuIPiZymj5jSiPUzGdBCYUSZlpLUh1XJxFSSU2YGStgJZcHuFAiERFfAddYJLzOim4ht5lqlo4dGJi2qYlFz8hpwReBrJmpKdqPSCTmEPAz5v9uzaeRvXMeReaRjBb8fwn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that passing a regular file from tmpfs
as a resource file fails with ENOTDIR. Only directory file descriptors
representing the mount root are supported as resource pools.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 31bc74c4c26bd..a7a1b5470cb2c 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -457,6 +457,26 @@ static void test_resource_fd_unsupported_fs(struct kvm_vm *vm)
 	close(file_fd);
 }
 
+static void test_resource_fd_tmpfs_file(struct kvm_vm *vm)
+{
+	int fd, file_fd;
+
+	/*
+	 * Passing a regular file from tmpfs (e.g. via memfd) is rejected by
+	 * the provider attach callback with ENOTDIR because only directory
+	 * FDs representing the mount root are supported resource pools.
+	 */
+	file_fd = memfd_create("test_tmpfs_file", 0);
+	TEST_ASSERT(file_fd >= 0, "memfd_create failed");
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      file_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with tmpfs file fd should fail");
+	TEST_ASSERT_EQ(errno, ENOTDIR);
+	close(file_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -517,6 +537,7 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
+	test_resource_fd_tmpfs_file(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



