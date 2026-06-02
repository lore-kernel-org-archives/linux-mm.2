Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CDACD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA936B0099; Tue,  2 Jun 2026 17:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334796B009D; Tue,  2 Jun 2026 17:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD096B009B; Tue,  2 Jun 2026 17:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 096DF6B0098
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D06CAA0180
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:16 +0000 (UTC)
X-FDA: 84836331552.21.9A73F97
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01F6FC0004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EA9FBTKc;
	spf=pass (imf22.hostedemail.com: domain of 3fFEfagYKCPMrtdcVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3fFEfagYKCPMrtdcVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ6ZTIKmnZDIm2PqykNUkTYiLD4CQXsPT3VeVYf4kfY=;
	b=hj6EvhCaTkRTg/wmEJ+Ms4wjApNiGs7T6n7lAGm3mhyorRQNRa77GDiCYDKJAi9Vx/3YvP
	q39F5QZyGtXITt3E2fkKxCvoYs6F11ln3iVzqMzbxezIiMU/tPZy8jbJNhfKO7ZVNkPLeR
	VlUqsCOSPxURT284S7AmVh8gDD9AGeg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EA9FBTKc;
	spf=pass (imf22.hostedemail.com: domain of 3fFEfagYKCPMrtdcVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3fFEfagYKCPMrtdcVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437375;
	b=Lrd6SoH20nyLpeikGfbX4mFYv+v0ogERzsKA6EWXXWFFU4qIsGzQeOogwd1+W21HoCGGfL
	42hehOmES/sY/24BxlRFwgXvoU6XADzQDlRC3fQzyqqiDkszcgYjwb53Paul3uCwdIG8fC
	lwY6vL/bBT1S6HEpjNbDFpdBuIpYb7Y=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36b7f696b40so4918286a91.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437374; x=1781042174; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ6ZTIKmnZDIm2PqykNUkTYiLD4CQXsPT3VeVYf4kfY=;
        b=EA9FBTKc1dh0XjIT5rfqCI5ad2OEWCPxqzPboriA/AowQqIhuRucY+OkcRP3WAO+95
         VLYbWL59px6bNJ3FaaRd8xzW2KgEBxSBjK4G09aJE27TBk4YEcpF/hqcXqFfoa+WuEq+
         +PjttOUJpEe54l7EvrT6xAq8rmJPx5AsVmSQMK+9Kxvafi2JqTfLKZu52SwurL+bXK+Z
         mwpayJaQlqMoSod6+/FXIVdgZ9IoVPvpUAmZ3u+EmazIjMB/jCTTE/xsNxMRvD6z5Aqv
         UFFqddct9754RrWOYm6LdFLz38871Z5po+zahd+xOSAGhHJGrVamYvRS4wF9Hp1WC1sW
         4Q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437374; x=1781042174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ6ZTIKmnZDIm2PqykNUkTYiLD4CQXsPT3VeVYf4kfY=;
        b=juVsUNXzn6gWEyGhYK2/qIRpNysV0W0uUiUn+ZF4qaoAAmR4PTUJGnyQG/Y12T43+i
         eKduLCh4ujYKDF9AITI0s2bs2RsEsWBMaT7GCz+0Dr14nZk8vi4cTUnhNLXHyh/AwxqN
         5sJtX/afR+Sr50LhVTZQ+1DLuRZ2zo4RaoQPPAapNfZPq0Dr7fPvteeuwFHZjHSZ2sOz
         xuGSBEQRG6xWLvNMOJ6Pr+7fokECtmlaJCNfoey4B/s1vqE7ZdV1jL8r8HWnhlMqX6Hi
         L8vjDAo22WtnZKDaH4f5YHx4NUnCPqlY+aU9lKB6wIqBfW0or/ZIE4WMWa1MLE406fpG
         ISCA==
X-Forwarded-Encrypted: i=1; AFNElJ9eHOxswBXH4wL6zc3tZun6JKsBcJpWR5WrHmxiNeMCfL373hXzbMiSWPT2PbciEOCTODz2TnL2Mw==@kvack.org
X-Gm-Message-State: AOJu0Yys8QjIAZxJIYy7HiyMtFbO+H2wdFq80sCKq/DUUGzEG9W8y4u8
	Wo25Dc2QVNefuV4BO4qjnX+nrKnzwx5r9ZKGovLx4XDUBeYrnRpn+h3lQ6Nt8uY1oniXPdlyecZ
	eZOEK0g==
X-Received: from pju15.prod.google.com ([2002:a17:90a:d4f:b0:36b:89e6:3ee5])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e4e:b0:35f:b647:d98a
 with SMTP id 98e67ed59e1d1-36e30552788mr686479a91.5.1780437372149; Tue, 02
 Jun 2026 14:56:12 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:47 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=3092;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=uanUhuG5chBI7iGRiYb/NQJAUXfg811Uv7P0B8yjofM=; b=onjoJh2jwfvgE5J9KsFufxaaM/BBUoZUbER0Iv4yiEZbnHtSt3LZi3VagZRC8gVSTIjS36l5y
 WirOgE+fH18CGioPV6fp/j5ijMuy/gRGi7+ecGc+dvu8oYZZXqd01R3
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-7-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 7/7] KVM: selftests: Test guest_memfd behavior with respect
 to stage 2 page tables
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 01F6FC0004
X-Stat-Signature: 4gztjbjd4q11bpfzfftxxmqxiqxdgq8f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780437374-229886
X-HE-Meta: U2FsdGVkX19XnSyTUS9B9/ZNfTaM3tKBSiY62CRK8c+LywywCXjNg1+2r0ka6W1+e/Pk7o/i0RoeRmWwWKbcmRzOoIi0cQ2b3y8HhEzKzByv++1WPvi+Vkau33PX/6XyP2qefuXZWYgaFAiXB6ETaWZ/Ep/6WzuIL2897zcz+UBCA7s+nEO6hPLdKdKwMCy37xMJhePcuMmc7ycwW3L5UPTWenLVDaAoao5cStEfsdH2uzedjNHLeApX9zUJgW1/TcESRpJFtmFkS5iGsQuj5XQuUZfdju4MR6ur6Vw3cmYJDDkq9Zv+2h66X94KVifiaRXjV9O/th7V4rRQneUT7phxuh7cytYa58gKaaboHwEgpbGwDitlHhF59RyWfX/qvja38UupkVEMeKN0XoMnXzLKENu1RdDbIMrL9rbAsnEd7UsM7P96iX1329kmW+cv2/sVx/2TTr3KY9zCAcrUFMSPPG0+WWEZ2IeQWdtPWh2LuQTM9ELtax1L3wFYAZ06RhSC6kTsTRCz7xudGBuDQAOv8RC7Nq6mWaHhuU+7nBOu6JRzyn1+nQJ5lJ6bsq5V2IGfZperwInR1CX2O4ulyt8jU6RysEOTB8L97+q9DFAQsQ7+u8x0JKoGjQ+fK5hPvW2UvCrrGRIysvw1j6PMYJR3bF+ODjvVuElVpeVgfpwlla3FE6Pr9YLkDkZJI9NVtAo3Q/lSgAE2FZruA/9aji9Tc62PH2drlpujGvxHglQYfY0y3ocKyQqjyCOnf8Ii7qGXrlwYrJQMeWo6IOx2fRL4UvncH4UWAupvhH3jCGlISq9eoBJpUIESq9P0RCI3MiiuUmpjQxD2066CDiD6DC8oqXq57POjdQ68CpGx7NNhaR3QS7+EyjARrdmiWq1J/TVvDIqDg184kNdZvJ4UtkTTtTVwBju0ZK1pzIvOqA4p0K80kkVQj0B1cTzHRAiHCXmFshVYhd0C4moKwgp
 ZN+IEXGo
 780vsDx1AOzb4OqxsCmO770EGBd8XUL+JdLpION0lsMKR66xboFv4pe12ebBX8A/MM4xJG9K9XhhifLuuK+hATMq7g8+c1Pv606Bx01a1+dcNQ1/ogVfl/UiigFWHNdX7LmGycsCSoNJ+JrJuoLjw+luzB+RbQbS/xelvyGCitHq9EOg/KwfU47VYi4f5unxSKzX3Ak5gv52epMsQ1GcbKxBlCpRYiDKaffRTNf6gAN/VafHDkP+NtSmIsn0k4HRWKIQ9aINAKprtgKeDICpVbusncDADyTaRkb2llskxBzQNYcyA6sFF3rqSbsRVInoz4iIQdawhgWBj5s4vevqXPOVONHruviqjBQLOtwgtuLjYGsXccHIrpyXWx8xWBazrRFS9W9vJVscwonlYRCcpa739mYLJGHyR+TmEqqA4JzrHAwjGMBztqIa6lWa+z1uJAH9tX5R9o7HgJH4waFOK3KTMmatJgAQpfl6Xc41WGf6ITu6aRBKRTdENwJ3gk5lxw7rWkEtDlphxwrmILohm6PiiFS4OR9sdA2K9G1WJYXXleocxHDZQxFxatIU2/YSGho3R9V887/3bCg0ur1LLAtsIehxXAFqc9DFIIPjS5QO3yQZP2o+F5Q2vw3HQrkGtzP7epwj4qzXivKRmQYxkUnBQZl4CQPIhIcwg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test that
+ memory failure handling results in unmapping of bad memory from stage
  2 page tables, hence requiring faulting on next guest access
+ when the guest tries to fault a poisoned page from guest_memfd, the
  userspace VMM informed with EHWPOISON

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 .../kvm/guest_memfd_memory_failure_test.c          | 66 ++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c b/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c
index 6c8032d390ae..e6f4c327bd5a 100644
--- a/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c
@@ -24,6 +24,7 @@
 #include "kvm_util.h"
 #include "test_util.h"
 #include "kselftest_harness.h"
+#include "ucall_common.h"
 
 static size_t page_size, total_size;
 
@@ -313,6 +314,71 @@ TEST_F(guest_memfd_failure, test_memory_failure)
 	}
 }
 
+static void __guest_code_read(uint64_t gpa)
+{
+	uint8_t *mem = (uint8_t *)gpa;
+
+	READ_ONCE(*mem);
+	GUEST_SYNC(0);
+	READ_ONCE(*mem);
+	GUEST_DONE();
+}
+
+static void guest_read(struct kvm_vcpu *vcpu, int expected_errno)
+{
+	if (expected_errno) {
+		TEST_ASSERT_EQ(_vcpu_run(vcpu), -1);
+		TEST_ASSERT_EQ(errno, expected_errno);
+	} else {
+		vcpu_run(vcpu);
+		TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	}
+}
+
+TEST_F(guest_memfd_failure, test_memory_failure_guest)
+{
+	const uint64_t gpa = SZ_4G;
+	const int slot = 1;
+
+	unsigned long memory_failure_pfn;
+	struct kvm_vcpu *vcpu;
+	uint8_t *mem;
+
+	/* Limit guest test execution to a single variant to avoid redundant runs. */
+	if (variant->method != MF_INJECT_DEBUGFS ||
+	    variant->kill_config != PR_MCE_KILL_EARLY ||
+	    !variant->map_page || !variant->dirty_page)
+		return;
+
+	self->vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, __guest_code_read);
+	vcpu_args_set(vcpu, 1, gpa);
+
+	self->fd = vm_create_guest_memfd(self->vm, self->vm->page_size,
+					 GUEST_MEMFD_FLAG_MMAP |
+					 GUEST_MEMFD_FLAG_INIT_SHARED);
+	vm_set_user_memory_region2(self->vm, slot, KVM_MEM_GUEST_MEMFD, gpa,
+				   self->vm->page_size, NULL, self->fd, 0);
+
+	mem = mmap(NULL, self->vm->page_size, PROT_READ | PROT_WRITE,
+		   MAP_SHARED, self->fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	virt_pg_map(self->vm, gpa, gpa);
+
+	/* Fault in page to read pfn, then unmap page for testing. */
+	READ_ONCE(*mem);
+
+	memory_failure_pfn = addr_to_pfn(mem);
+	munmap(mem, self->vm->page_size);
+
+	/* Fault page into stage2 page tables. */
+	guest_read(vcpu, 0);
+
+	self->poisoned_pfn = memory_failure_pfn;
+	mark_memory_failure(memory_failure_pfn, 0);
+
+	guest_read(vcpu, EHWPOISON);
+}
+
 static bool can_inject_memory_failure(void)
 {
 	int fd;

-- 
2.54.0.1013.g208068f2d8-goog


