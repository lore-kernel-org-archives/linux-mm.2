Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFD9E83847
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 01:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC206B0088; Mon, 16 Feb 2026 20:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899AA6B0089; Mon, 16 Feb 2026 20:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743D96B008A; Mon, 16 Feb 2026 20:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8F26B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 20:44:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFAE81B55C6
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 01:44:08 +0000 (UTC)
X-FDA: 84452252976.01.2F55369
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3BB4318000E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 01:44:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PpAyYrjU;
	spf=pass (imf16.hostedemail.com: domain of 35ceTaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=35ceTaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771292647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0+U5Pc41BVwnFvqdSoAa/2Rz/ZDywih7O6BgvsAgYk=;
	b=gyV3GbRIJv2FWp873Dy40e+cgnr/cpbZB1ps8ahN+15KSs0JQ3qUXjC560V3RsvKfjGTyb
	Xoo19dc2C+i44AKOIw56R6fNuqVaYbEkd7yB6Jrsd0rdPDhzzbavUo4ar0nQo025q/nx88
	qFj0z6n+ejDCU5ecaSb17ih/I0hXj5E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PpAyYrjU;
	spf=pass (imf16.hostedemail.com: domain of 35ceTaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=35ceTaQsKCBgy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771292647; a=rsa-sha256;
	cv=none;
	b=FhQjw/5pWp5lxDMjTL2LaDER+3ZURgIBVK8gvptimTbI8fBHe80G6X//oqg3WwTCh7mIGh
	cJjIbkOtb+6sDRIQAkNApRsFgfsRThfe+pRi4NVR0f2Bf8+1SMXa4Ci2UgstHGaPWeoQJW
	NP0sSaeK8jsCo9628JM62oepHF1RjBg=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a784b2234dso207963595ad.1
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771292646; x=1771897446; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0+U5Pc41BVwnFvqdSoAa/2Rz/ZDywih7O6BgvsAgYk=;
        b=PpAyYrjUiT6UHpsSWIgYjzGn0NOBKQeMQkLVYvps+zAnJlXxoqgxfvtfng9b57ks5w
         ywHcvQXvq531rCn3ksiGeIBFEvrIzMaXlVrwtoZUNrbDFpemITXTwvH/BFuDFbv9qB12
         YfdEFaZ84dXHjAmDu/YRCelXgzMpzRJANMhisZWdROK9SlIx5ckTXIGqiDKUgEY4HKMo
         KSaIH4GKexnDl2nKp8SbmwUm2nVJHrh00vkKSqKTXXKiEmddcglDNL3pyZgNezdMnTb5
         J00GpB5cyRG1J6+liWSouecnzhAOcd8BUmzwH9X+bekM6SfIsQzJqbYQyqdk1R2uWYhi
         QUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771292646; x=1771897446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0+U5Pc41BVwnFvqdSoAa/2Rz/ZDywih7O6BgvsAgYk=;
        b=M3LoPkDmQse+Zmh+p9XyQaHg4u/5LyirXjuHQZ1dfYzYoHms21/bUiauxklW4Cgptt
         p+H6RYdpZ5b5sSn6XzIku9I8A8Hvocnj2WS4odtT1a4RwleGMYjURcrLnF0vrvqmeydY
         PqbcF99A+BZtZBZpBMDv3KFs+g7di97N75Lg48+28FB1nPwq1KYYlGG+iWSIrQCDo+Gh
         eGP8GIcJMsErDmiSmr0yKyb1Bd1bGOc/NZpOV25hi0jmbku7lVzt8owEsmD69k6x+34T
         zfFtSpIy8QzblBxuFJ2gndo+aZBY0+ssuk3AWKX8u4nxGyn5ZVXSFJN+5S1RUj9Ky6VN
         FKXA==
X-Forwarded-Encrypted: i=1; AJvYcCW9JVmDcyYX4cNbGfwKfTLNF/2ODJLbEsB/cnv6fimqBE3bxOkz1/NLcqId5p+Mj722mJl38CFP+w==@kvack.org
X-Gm-Message-State: AOJu0Yw1PtF4XctIw7wAgCjSDrYs/YSE4U9YqfMjOF4AZKTO8Do3pp0M
	ZaB8LuIdTIE9HD9ZHyI+AqCNbV55o2WqdjcQfAhkFXnSkYq3aQaBhSX3nwP+SUukzr8zqSlh4As
	8eWKtCd3GnPY9R3NUF2BYDVHRgg==
X-Received: from plqu18.prod.google.com ([2002:a17:902:a612:b0:2a7:8c71:aa97])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e943:b0:2ab:2311:e4fc with SMTP id d9443c01a7336-2ab50603a4amr130385745ad.56.1771292645552;
 Mon, 16 Feb 2026 17:44:05 -0800 (PST)
Date: Tue, 17 Feb 2026 01:44:02 +0000
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
Mime-Version: 1.0
References: <20260214001535.435626-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217014402.2554832-1-ackerleytng@google.com>
Subject: [PATCH] KVM: selftests: Test MADV_COLLAPSE on GUEST_MEMFD
From: Ackerley Tng <ackerleytng@google.com>
To: kartikey406@gmail.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: eydp6xeew9f1wfw1dw5bgajyajbizqjy
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BB4318000E
X-HE-Tag: 1771292647-233856
X-HE-Meta: U2FsdGVkX1/+udv/S+/WnnrMvRMIG2ZAIpUfNtFI1nGJA9M3t+CUr9K8A9L0A5X/YKfTZoQwhAcdiO8EDk/+U9WHX+NhC6YpUxK2Jql5IwsaY9RnVlmUHD8iattAgmnowMJIV32Xpx0M4CxTl65Ds5rpm9TbC+YxQhl5AjxobHZkvjiyrbrzGhtJeNtUqbnN1UjaQHssOdCEgT7CsJZNCzZCGwzpLStpPWPFcj7VKOoAOhFtoAC2/Rc1DJzhn0VWj+uPQ6vh9KfIqIqZFQICLZ1lBLkLPhPTeLpob0O+yMZKKUB+4TWGSWEwhOpiMBeDYoTZ0SIB2hNXdoZz1ooidYCE9ZW6ErQ7yaV2S8TnHMcoDsDwI86D1SDOhzG7Aytod50ucCHwRfx8sKwIUY6TgOkLr6Vf1itkYnYi6Y6weNXIvhK4tWBRnHZSfbxtBcYnlJmiwaVYnIOYBPtVevODq+OGetgzqDfXaIb7uS55JCgO0nhzJEvc87o6pwwD8Mi3snQ3ZfRRnx6R36xt/GTmyzkgFXa1WNXukTaLNkqnfCS+z3nj5/lWi0VFMg7Iwan5GoOk1FRSNyPXzBTTs6CZHbC0z44FlIsftOZr0d9jtdCYOxkAWCDY3momgKmkc2KC+nYkdBWYeehgXOcsONmV3CA136TVzRR046wiSt14DRVIA0XgNN/m3is2eEXi5Q8PkQPnLEbAssKg4bddj2s+w62AQGH7vZqrpFqBbClTCJmutQdpLbrNF2aoXSvXtNNCUQhkkeprKrwsnrkSX2dzkHqo4jS4vGZdNa3asPzljlnpGg/m89xcsYl4u4CL1am6cM4sRTLdQ7fPEOSQWRikfALArpN0v5FD8uxw0LQazGld+JqlL4ic/GfoGNoL+LVbIF7O6rGiA8E3F6t+6Zi4CNPvT3t60FBJc6UMwBVINuP6Jo+crsXzV4VcEVGxHAcEdqcQEmIQfcm/peSnQ4Y
 LaHT68Zz
 6bhRkkWUlSCrosYCthmd2his0mNO+gYr4ovHg5JR9A+YC0mhS5gZOZyLuLHwtyFsx7PZfUof7hrOnsq/B5h1tTqXCXQKQLWAzb/Sl+WTR/eWwfMcg/WJ64AzCkL4cLAyJYTxT+u53pPe5sPM8lFMSY4eGGyGYet8GAruYDRCgod9lTAOusoNWev3JXwEPCWLKLbIKQMyxi5H/ezjYgOqmjQp7mSpydoywLVw0mHVkNZCpo4GfDZbIzA7TpcjUoTrW9xgIbeWN+DIE63gkoKisG61eXKVJhj+Q628etxG5yA9d53AOMCkryOWCYOqpwIm0YTJZakrVd6agCdqojIhowBMBM1MXfkZ7BQYCbBSBWoRssjSERbqO4jMklxVL5H0YPfK+W5HKXer95YuOFnpoAvYtboYjjaTwBVpxBQlsaTrSeM2nNsyS3oxZSYB/EImLD7AkQoGNKbdCd2yrYNkd9hymYGfYJFVCsYz4pZmpDWOajgKRuWfv/roKwEkCxHOOrQI6kivRV/ipWV5eizzLtIk2SEM3YEfBT5q8RN6PkythmU3dPoXDRcLiFF9yzc3HAjvgLsRmJ//wFq3QRlBM5FHvAPYn4HcWxJD40DVbwQ4BWezYePu87CRPPohOzt4zcqV+6s129MHpW1xcLTDlHRk1sp9KxrHTKhM5ue4aJ4/D2+mjjT4jZMGD0OOfxHS1vKAdk5wyDj7moRu1PUt06ScvbrHcv2uD53pHckxls7tcfqYspAD3b1fTkGpraRIU3VPd/J5gQu3X21PO+je+N2BTjKppKzU8oci1tdYfwJ3aqts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd only supports PAGE_SIZE pages, and khugepaged or MADV_COLLAPSE
collapsing pages may result in private memory regions being mapped into
host page tables.

Add test to verify that MADV_COLLAPSE fails on guest_memfd folios, and any
subsequent usage of guest_memfd memory faults in PAGE_SIZE folios. Running
this test should not result in any memory failure logs or kernel WARNings.

This selftest was added as a result of a syzbot-reported issue where
khugepaged operating on guest_memfd memory with MADV_HUGEPAGE caused the
collapse of folios, which then subsequently resulted in a WARNing.

Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..d16341a4a315d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -171,6 +171,77 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static size_t getpmdsize(void)
+{
+	const char *path = "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size";
+	static size_t pmd_size = -1;
+	FILE *fp;
+
+	if (pmd_size != -1)
+		return pmd_size;
+
+	fp = fopen(path, "r");
+	TEST_ASSERT(fp, "Couldn't open %s to read PMD size.", path);
+
+	TEST_ASSERT_EQ(fscanf(fp, "%lu", &pmd_size), 1);
+
+	TEST_ASSERT_EQ(fclose(fp), 0);
+
+	return pmd_size;
+}
+
+static void test_collapse(struct kvm_vm *vm, uint64_t flags)
+{
+	const size_t pmd_size = getpmdsize();
+	char *mem;
+	off_t i;
+	int fd;
+
+	fd = vm_create_guest_memfd(vm, pmd_size * 2,
+				   GUEST_MEMFD_FLAG_MMAP |
+				   GUEST_MEMFD_FLAG_INIT_SHARED);
+
+	/*
+	 * Use aligned address so that MADV_COLLAPSE will not be
+	 * filtered out early in the collapsing routine.
+	 */
+#define ALIGNED_ADDRESS ((void *)0x4000000000UL)
+	mem = mmap(ALIGNED_ADDRESS, pmd_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, ALIGNED_ADDRESS);
+
+	/*
+	 * Use reads to populate page table to avoid setting dirty
+	 * flag on page.
+	 */
+	for (i = 0; i < pmd_size; i += getpagesize())
+		READ_ONCE(mem[i]);
+
+	/*
+	 * Advising the use of huge pages in guest_memfd should be
+	 * fine...
+	 */
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_HUGEPAGE), 0);
+
+	/*
+	 * ... but collapsing folios must not be supported to avoid
+	 * mapping beyond shared ranges into host userspace page
+	 * tables.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_COLLAPSE), -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	/*
+	 * Removing from host page tables and re-faulting should be
+	 * fine; should not end up faulting in a collapsed/huge folio.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_DONTNEED), 0);
+	READ_ONCE(mem[0]);
+
+	kvm_munmap(mem, pmd_size);
+	kvm_close(fd);
+}
+
 static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
 	const char val = 0xaa;
@@ -370,6 +441,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			test_collapse(vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.53.0.273.g2a3d683680-goog


