Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89747606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UX6d6jQC
Received: by kanga.kvack.org (Postfix)
	id 2DDEA6B0310; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADD36B0316; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1767B6B0318; Thu, 22 Oct 2026 19:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB74D6B0310
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57F49C0329
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:35 +0000 (UTC)
X-FDA: 85351853790.21.C0A1400
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 315B0140007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UX6d6jQC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711713;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6o5o2vytPuBo/EZgeDnQYvxCmd5Tc1l/WSMI7oVGNI=;
	b=wP5D8Q1QUSYNtPitU2kLjE0N34XSXwcBO7ABtcqKZOxWqWnqskOigxUfvfbpcQ0t/mkMPK
	4R1goTq2SEE3k0xJJTiV8o93wn7AV8YiVxPdlSvdRyhUFhKS+HC3HsCR8PHKkdMW9bHu4a
	znBNCOU+LhxjeN9SE+YnavjncTPGBSM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UX6d6jQC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711713;
	b=RnobD/nObpjhkgpdZQFe1ZoVIpRicKRPg/KERSewQ9gs4pLIqZfYYXZwA8eljIlW9zd53e
	OeYAuV+hP8OsOmJlC8QzoaWncjN4qSD3R0+sLcvdXlNWnQesbVi/8yTVA9n1X7LtKJGVD8
	E26UytmyG2mLmUsinI52Ngbi0cPZFdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A118C447B6;
	Thu, 22 Oct 2026 23:28:24 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711704;
	b=Ub4rYvXqQFGSo6Dd/UX+4zo6DA2PJIZxf7AiXncrWDwGW4SD0Sqim4d/yBBdOupyL0HS
	 VSkwE86aiduFBW7AmlMA5YPpxytQfxFPCZuzly8yx0iyCVIJFIfzPt9PZHpW/8fMTh2PP
	 a5LTgIDf/qWXqAuIO/fKSQ+sEotDdyO/Z4DORGYjtpfenjqDqZqt8Epd10jmx+jY7eUlG
	 tN2hTXx5L2JOFdbPqhjyD1ByaMAmGvdDZJ8ZhEM3zFoTo9QM5Y33z7uOtCSKClycxA35n
	 SgNPJ7lrFguN6iEizD9hHCYi9HzgXBhv9ZCcN4S03nf4TIkR+vGZfbBSzVi94f9L9tg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711704;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=H6o5o2vytPuBo/EZgeDnQYvxCmd5Tc1l/WSMI7oVGNI=;
	b=hdI1LfKD56Qm3054Fy5HcaxsyO9YvP0peNsvjykgFDGx5osykJQcW9/uRYLCO2SAYtsb
	 L9VGMFPkpAahwOoJ0ws8aj5Dpb1zmYLVwQUGTVXUHhWbKL+LHEPGGmFO9n9GOtMH9jA9B
	 z5BiiYsoe4pHd8Khfdk5V+wtuyrswvj5KDP8gPJAEFKNcQ3mFNuXXIlyqTSMV3T2nPMG3
	 GaBqUhMhtdeSduKB/M59fzF3rBk0xDGwcK61fq1PTPMXFwU4T6FbVjt8gr5TUrdAkzpzm
	 cy7p69GMTUxMvPMLkJWHufFVrFfFdY32lLfQ7IcCqpYkDS8P5mH6/6Ok9VN3R2gQ7aQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A7CE11F01188;
	Thu, 22 Oct 2026 23:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711704;
	bh=H6o5o2vytPuBo/EZgeDnQYvxCmd5Tc1l/WSMI7oVGNI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UX6d6jQCfcyvfTqh3lHbgjahpTQRc8g2LMjo7+/d9jfrEGbBYQNIuqb2mT3WiCxOg
	 pC0CF9hXwQPOg3alM7d3MA5rVOmkJmlY0JFtDi5q8Mb2sap55jB9KSPJz7VxGGbxxi
	 9D+7YPkSOecvO/fqKii4CnYZAdPReloKXlz0OD8uCE5fipFbfT2lT9xvd2z1bV6/Ns
	 mm0XV9yVv/RXm6HBgfMxgu63N+0EZ+6wSHeiFrcGspSDEc/Zwa5YZgbzbedP0FBmmn
	 kmtwfpmkoRHVNmEoEwzxJmb4f5w/TX6JNBvJ6YRA+GySXS2v8HwQeK06jzfxeN2U8I
	 orSD2r//RkueA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A49974210C;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:22 -0700
Subject: [PATCH RFC v2 50/50] KVM: selftests: Test guest_memfd conversions
 with sample memory provider backing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-50-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=5170;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rlB85PYh1jaJvMrL1kLAqla/p5s2l4avZfOOeeGlWDM=;
 b=VSMpakwCoRWmpL30l5zo+rYlaAKf2cnLwpQ7a87uoka6eTdULgcyR5+xHnOSv19D2vO2aAMw7
 uw5/EyEtXt5Amy29y7apd5iX/XRwsIqytyCd7Kch17Xizk0nX9V2GLL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 315B0140007
X-Stat-Signature: kqbpefakydingc7oc15k3nxbckeh1bi7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711713-557307
X-HE-Meta: U2FsdGVkX1+d1xAt3iSNJo5OIwtOqf3WFor4laGkWZX75Gmoi1WCwUDH7KUk06/1qeY+v7srQcYkcynfPfGf/cNVSw02X3H1QM+I2aVe87Xl+fzus0txy56tVQtrv1Vo+ioNi2Ij4tBFJJsvHm55ovRDymW8pQ3Q+PjNXjkxRGXvqX8aR/3vZJdmbfi6O4AM9GuiFYYx0dg2CfHdFTc0qlx53N1ehfgvDZ+zkYhHgvhpboZxr8LFeI65L8JYhMWNJoH+zmIgl+hZyl9jRgx6r1nQXqzybA7k2GB1R8HVYG7+yLQhLKdlcUDkkzvlVTDYkntXj3BYm+emJzfdXqvL9/2ARtd4ygbHGrzv71NqHySOCrh20yrgbfBWXaZbag3PVFd/8KZ48oHgY0BpHRS4GEab3XSRLVAs9/D0x4UONJDH5/zTtoENAK7nQ+Y6fGTv4rV7sf1hvy1b1focnQc8X/IYHAaqtH1W3aEwgrTPG31jFSO7YT1bRKQAqNjufPTIYcEdx31fVCKQ1XPonJKtP1V2yOpYYu0NTnvZRtbmVN+T0RWx9UvTSTzkbX7Iwny313bXmUC++McqPWkHmhmK8jCpNpOK0ud1sw/MxdCkUG+3bjzdwRAi3NlTexmC/n/Pr6VKb+Oa+HbiDAjSisKm/fTp6xbqQTM6+mzPW+nyuqJGsVikELXXC7VVErSIunKQ+bwofWqE/HQGO5pbgUfSAKu3R2Kz1I8ab6tCA/EW6wjDxWkZjk+d2j2eplWWq28FUv6WiaPEuH0Z+Ld1OQMU/9hrIlco6TpHwtKWhH5Bmb2qPZOBH1e63eSB7Mce/AM8fHRo0XzdcPI/lYnlOsBSEk3t/LkvtSnoAe2sQXZinpmQ3etswvFpVnzEiQmaeRkVrrgfyJcsSIB/1cZsPWJm8tCXgOac4JXc+UkPawfGTN1GblNqcr0N+iWn4/XUKDc+Niy8aPS4SgQX5R2KSBb
 NqNfGUn8
 232Miz/iMxGZ3jnE73Ty9m9Cl4d6kNvMsDYyxnpB0Ad31/nIH3aGV2FmRb9A0bOIBPAydmynBl7B/9I8arczdnNOH91ef8bFDdHDuOQI+kJw2Va2eVqz3l0tlSHxal3IgQzS2J02bXVG1+cypXxh/8h5okaJ8nCna5R9Dv8Dqwov6z5bed9oxSsSD0/1CyF2FHraJXNnn9/b2FxUrzFwhDJffAHoX5N3Ly4FjCdcUo0hPYLm6V/ZVXKgplbYmlsqCq+emmPQMrtJONRCzyS0YsUjvWVBgsU0UfBNNlwLmfQDjpPTP+Xg48G5uf84Fe3U0cKqae2iOJeMQWqkKPLsBcQk87dVhWFwbQHYtQLJMFaAkL3Ip+N4PWrWlHtQEljXbWd4JOGe8qNoeD7d9tJdGaRsP6XHv+0vzLzLZ/9SyC56+OOhoFlmIMnZiMm4dhZK0qZ3pY1nQZO5nREzganHIgfzCpX4zt2BPDVcjnCOuS2kiyHxSeyEUvWncFooURn8fCtUQ57HWVvkpHUDa9ZVs0DabAUqIOQfvMV/sXefmn48jIoyBgCsAHhTYllVRJXvGfQpw8PPzPOqcNIZKRt4y6RhDLcssV0Ht/J9fxboldasqSgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add fixture variant for the sample memory provider.

If /dev/mem_provider_sample cannot be opened because the module is not
loaded, the mps variant is skipped gracefully via TEST_REQUIRE().

Because PFN-backed memory cannot be pinned via GUP, expect pinning to fail
for the mps variant in the elevated_refcount test.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  9 ++++-
 .../kvm/x86/guest_memfd_conversions_test.c         | 44 +++++++++++++++++++++-
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index eca296539db79..1a1387f36a52c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1350,6 +1350,7 @@ static inline int pin_self_to_any_cpu(void)
 	return pin_task_to_any_cpu(pthread_self());
 }
 
+int __pin_pages(void *vaddr, uint64_t size);
 void pin_pages(void *vaddr, uint64_t size);
 void unpin_pages(void);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d42e201eba763..9793818f54d23 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -674,7 +674,7 @@ int __pin_task_to_cpu(pthread_t task, int cpu)
 
 static int gup_test_fd = -1;
 
-void pin_pages(void *vaddr, uint64_t size)
+int __pin_pages(void *vaddr, uint64_t size)
 {
 	const struct pin_longterm_test args = {
 		.addr = (uint64_t)vaddr,
@@ -685,7 +685,12 @@ void pin_pages(void *vaddr, uint64_t size)
 	gup_test_fd = __open_path_or_exit("/sys/kernel/debug/gup_test", O_RDWR,
 					  "Is CONFIG_GUP_TEST enabled?");
 
-	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
+	return ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args);
+}
+
+void pin_pages(void *vaddr, uint64_t size)
+{
+	TEST_ASSERT_EQ(__pin_pages(vaddr, size), 0);
 }
 
 void unpin_pages(void)
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 023df9cb9d4a6..b99e4cdbab8e6 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -16,11 +16,13 @@
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
+#include "../../../../samples/kvm/mem_provider_sample.h"
 
 FIXTURE(gmem_conversions) {
 	struct kvm_vcpu *vcpu;
 	int gmem_fd;
 	int resource_fd;
+	bool expect_pin_failure;
 	/* HVA of the first byte of the memory mmap()-ed from gmem_fd. */
 	char *mem;
 };
@@ -29,10 +31,14 @@ typedef FIXTURE_DATA(gmem_conversions) test_data_t;
 
 FIXTURE_VARIANT(gmem_conversions) {
 	int (*create_resource)(size_t size);
+	uint64_t extra_flags;
+	bool expect_pin_failure;
 };
 
 FIXTURE_VARIANT_ADD(gmem_conversions, native) {
 	.create_resource = NULL,
+	.extra_flags = 0,
+	.expect_pin_failure = false,
 };
 
 static int create_tmpfs_resource(size_t size)
@@ -42,6 +48,34 @@ static int create_tmpfs_resource(size_t size)
 
 FIXTURE_VARIANT_ADD(gmem_conversions, tmpfs) {
 	.create_resource = create_tmpfs_resource,
+	.extra_flags = 0,
+	.expect_pin_failure = false,
+};
+
+static int create_mps_resource(size_t size)
+{
+	struct mps_new_file nf = {
+		.size = size,
+	};
+	int dev_fd, fd;
+
+	dev_fd = open("/dev/mem_provider_sample", O_RDWR);
+	if (dev_fd < 0) {
+		TEST_REQUIRE(errno != ENOENT && errno != ENODEV);
+		TEST_FAIL("Failed to open /dev/mem_provider_sample: %d (%s)",
+			  errno, strerror(errno));
+	}
+
+	fd = ioctl(dev_fd, MPS_NEW_FILE, &nf);
+	TEST_ASSERT(fd >= 0, "MPS_NEW_FILE failed: %d (%s)", errno, strerror(errno));
+	close(dev_fd);
+	return fd;
+}
+
+FIXTURE_VARIANT_ADD(gmem_conversions, mps) {
+	.create_resource = create_mps_resource,
+	.extra_flags = GUEST_MEMFD_FLAG_PFN_MODE,
+	.expect_pin_failure = true,
 };
 
 FIXTURE_SETUP(gmem_conversions) { }
@@ -75,10 +109,12 @@ static void gmem_conversions_do_setup(test_data_t *t,
 
 	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
 
+	t->expect_pin_failure = variant->expect_pin_failure;
 	t->resource_fd = -1;
 
 	if (variant->create_resource) {
-		uint64_t flags = gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE;
+		uint64_t flags = gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE |
+				 variant->extra_flags;
 
 		t->resource_fd = variant->create_resource(size);
 		TEST_ASSERT(t->resource_fd >= 0, "Failed to create backing resource");
@@ -506,6 +542,12 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
 {
 	int i;
 
+	if (t->expect_pin_failure) {
+		TEST_ASSERT(__pin_pages(t->mem + test_page * page_size, page_size) < 0,
+			    "Pinning PFN-backed memory should fail");
+		return;
+	}
+
 	pin_pages(t->mem + test_page * page_size, page_size);
 
 	for (i = 0; i < nr_pages; i++)

-- 
2.56.0.257.gf7497c7d27-goog



