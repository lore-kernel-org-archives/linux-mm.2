Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8E2C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85F86B00A1; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1806B009D; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01946B009F; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 818D06B009D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 112DDC078A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.28.3E2E821
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E52140004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozaTqiC4;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTVqjITHJjp8HzTtn0Doc5xS56MGUEWCnd3zvgiKHfQ=;
	b=N+QSYCFBACKuoPULpwvcW091KmPpOg4zv+3Pj1wnZZxSoBj9lspxpI8yZ6lnWExx6UQrOo
	bOkVlcerQl4ZlHj7hPHyW6+/5RX3pgjfTOfeBzeorgQGJfV4AKBYL+Zf1D34qauag4Q/13
	9R1jAfUcJzcB1w44VTJaTWMe6wPqf0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=FWPLABv8Jc9Fz0nmn3OUHgynSgagCzvM3aNao/9MvNOaaLYGQ+CAJ+TRFIbfqZp1t+8pTd
	FfsJb57AyXaWYjdobh/9jOuy6bHwyDnTmkenNgmuJbsBY58mMwkTutFP46nXmObg5MywOj
	7oPJEuFm4fTF66saCi2/Qm8bqsnW1ow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozaTqiC4;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D438447D6;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC293C2BCF6;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=bPm6ZaQk+kt/I6sAAcBSCrNyHmK+Z/anevzTBBSqifg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ozaTqiC4V04B2iYpKwpfal2K3UJdgWQA4ZqQ1uG4CfkeORwBYm5Q8pVkBoFeEjCYa
	 31bhdvH9XymD1cJ3q2E9bjEL8HPa5miX+cBv7814Klm6idQrgjfv2h213ZL0BTCjOX
	 4WkisO1VmqA8dnmCGJR8oMYvp/IC/77hzAt4FtCxXinokR/ngltV1sofyEUNDOWHjq
	 OdnkE72IJZ4+QPUDe01xTDvaZNqURoBQ1GOldHbEMCsaCcqsUVQjgUJGYDn20M2VtH
	 TaQJ+pBt9WP0Ifx2KG7c7PP/VcOQ8ije+Pr/YWp9siTGQNXjT8ybqAxEfR3pp7T+xU
	 ghTpLKWMkQ5Rw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B35C9832F;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:57 -0700
Subject: [PATCH RFC 10/17] KVM: selftests: Test rejection of hugepage tmpfs
 mounts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-10-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=1598;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=uHRD08KWJ33IfEmWlgc0kkQt05Gpcc9eJdkNLri4xT0=;
 b=KVKUJLxxCYvtA5PDFe3Kp6RxITzYbR1FXKIlwN3Ce6FqDa1idF+AAVjWn1CGwjlIZcUQZUsTe
 xcWXqn7k6exC4aW6OmpLcFJPBcw5uw8u3PZ1DNLU6V+yKSf5vxzxbsK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E52140004
X-Stat-Signature: 57cws9mhcgpcsxspaa4xoqgetqebrjrm
X-Rspam-User: 
X-HE-Tag: 1790383854-462726
X-HE-Meta: U2FsdGVkX1+Gt4I43y1RLBxz5P7uCJCVJHvFOGTN3Ys6CVJuBB/nLf1Wjl87v2BjG73e8UOxFri6oNFIuxT5gDRnZD7sJ5tEWbOmY2ru2/hE+Z1vW2ZqdSblAPhaYM1xrnBCcbnvZutQMxz7BwsX4cNpuJjOLYA4ixF15r/+B9ygzdJP/O1IKs7uN3h5utFnwTBBhF5K6COc2yo+RkFORyZnjUaympWn+NUpQKNWtRGI5KN5h7xn9QM1TQQxVl94a44Go76fcSboBXQppW4wd3Ku7hBAzeMNWCCzDyq+lEvF5L4Y8NT21l1zRYyTaNtENqkNvEizJGpauV69zxhibACXwU6HNrYPJyalxQ1zYFrjvl32o3SL8aABHoDDUB/heR8PdUeetuRANAtYg+Q1JlqKOP5iYEfvVoQx8QE2WExGgC5ZDSy7VQge4Opa39mrQ2w4OqHeXIqYETr67e3fA7d4qJ+fDwwGHl/+2T1J61eYtTGhLL8acgf4KM2qjOLRtA3nUKD/ylyfdaMTSOHR3LiyOT4wBXC8IZFOcN4JJsL1uIx5OBsIHTFsWjzUUHiWKoMDyJgRNcTkrZzimFYwip793qMOSkFWmUYkzWVABImte4aS1izKJznjpqh02m4Y8SENGerFyS9W2m8I/9xGUoEj2lesg4C/H1f5cqgE5WTalEn6wTLDNdQrHJTMuaPJZFiZzqZ7A2TtisIM86kFD5Ok8qcBVliJeqPwb2tTTedSnCeINlDQs/dezU1fT3/5VxGRHXTotoX/StWGk0/8BWFFqxtifjdZUD1AHfOp62ocUkPXVjHoq//TX0QbYBukKuH+aVmr0i+T69nbiOBbRHjzh8B6Q7bh5Esoosn367wNCeSQk4kTJBmHvXVII3QYYh3FiPnq85Gb5NBBpXjE2rSORcfxNSznT4rHv6KruHkQI2K6f7t/iarBIcZSsmKQv/JFEW8UYNogCitSDow
 1FkXMoAx
 MvySsVJ1l0ti+hzLQe1lHdgP1tXAlQbXXKa8sn37h76fN0yHj6xvPzmThF43OhLEeEqGTZ/upPROpc4Z68qP/RUYbaKwxWRar1oJsS67J1t67Z5ZxO2y4XPNqdR28jpRN+aDartm97+H4RqB8NqQzo7IKArcqzce2MQIQdNbv2Tqb/oNjKcINKGAhHYpVF00He9L0mpSCGnj70AqjNckRXGldjZ//p1z4UIbkWILKi8NRvgLpdqLWdsfMhbFAViXI480a0igGGOG01LTsnL0AgfUsn+cqUQHWQdh2FwEr92T/WdNOhhshzwObRleyDax+Vu74omPImj8JDEqVhLRcR5vx9SX3mAEObVnYAxrlqljHhNQTfMbXEbbE+1xyJISAmyjO1VNHGlt3raAc2Js+H1Hhs3CNXeauXXB81v1NlWWJewvzsM2dMhpKTuPGA+QHtOFEdVhNInKfKY8sYajE0O7Zbcu/E1TDEH9+nxE6wMQ9rEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Ensure that guest_memfd creation fails with -EINVAL when passed a tmpfs
resource pool mount descriptor that has huge pages enabled, as required
by the tmpfs guest_memfd provider implementation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 5d017164d7b45..e8199ed17b0f8 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -526,6 +526,21 @@ static void test_resource_fd_tmpfs_swap(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
+static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
+{
+	int pool_fd, fd;
+
+	pool_fd = create_tmpfs_pool_fd("always", true, page_size);
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      pool_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with huge-enabled tmpfs should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	close(pool_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -588,6 +603,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_tmpfs_file(vm);
 	test_resource_fd_tmpfs_swap(vm);
+	test_resource_fd_tmpfs_huge(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



