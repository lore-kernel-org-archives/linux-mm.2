Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D91F109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4AF6B04BB; Thu, 19 Mar 2026 19:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D40B6B04BE; Thu, 19 Mar 2026 19:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9776B04C1; Thu, 19 Mar 2026 19:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDF56B04BB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D62E160170
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:09 +0000 (UTC)
X-FDA: 84564410658.20.06D7203
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 65ED8100004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gjhXRgfl;
	spf=pass (imf05.hostedemail.com: domain of 3Ooe8aQYKCI8FH10t6z77z4x.v75416DG-553Etv3.7Az@flex--wyihan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Ooe8aQYKCI8FH10t6z77z4x.v75416DG-553Etv3.7Az@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zfyz6j+K0eCUgYIAireZB6wFZ/MNqUoA9mP0eBvWMq8=;
	b=UpzDD4ZvDGhn/xDzbEGTlFQRmqifS+N0TwXEJcA2Fka/7i9PRmLcj1kEIA7vzkjJT8InbD
	CZsTd8OenKvTahvyaRZ+lN4P4FdZoeJCP5peNBM+iqBQFhFyqpOWCLbON1N0reArlK1Wtm
	s435YJYxT7LjTuEcF9tnsd8Hq40m1qs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gjhXRgfl;
	spf=pass (imf05.hostedemail.com: domain of 3Ooe8aQYKCI8FH10t6z77z4x.v75416DG-553Etv3.7Az@flex--wyihan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Ooe8aQYKCI8FH10t6z77z4x.v75416DG-553Etv3.7Az@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963067; a=rsa-sha256;
	cv=none;
	b=bsdXvAVd+Zdu6HA6/NEL3t5G2hhZuJrIo4TRNKs6h+LKpbXAyaz9ddBkrwcHkfgucFWWIZ
	VHM/T5+Ri/60vifK2+WTsQpCUzMIEh5MaYdn0fwXXdqkT5h8BbhaSj8P5WHOcG3Gl6hT+v
	6TF5MMwMDVxGIB2wOTzEexg/L/Sac5s=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2adc527eaf5so14307505ad.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963066; x=1774567866; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfyz6j+K0eCUgYIAireZB6wFZ/MNqUoA9mP0eBvWMq8=;
        b=gjhXRgfl9kEukKrjJQckYFOFMNFF8buzfS4urXB//qFFrXD4VaQDi05VCnwamd3I7L
         jaQNXpobrHb1lc9AbTUlBT/sOY1lCWNpzCMZbmOC501dbvTJNZ8fLm36urhaE8pf39fz
         3RSzQXi8fd6T6pmTrcyjtjVtQMRW+TLvrsNZA48Tc18GfOpAPWcvaaXzSOeVnDMRr7E9
         NKVeg4kpi+AxtHb+cVlL+JJv4SyGfc20LHthiaN5uyNLZaWBSMVLzXiFtqxcMoz8eG52
         t8sVBvIOchOGw/oewio5X/id4zTGGeJ1mHQ+MzKetNxbRi11k0Sig23zLFZsFp5jRHOF
         weBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963066; x=1774567866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfyz6j+K0eCUgYIAireZB6wFZ/MNqUoA9mP0eBvWMq8=;
        b=PvGSZCbQbe+T+yKPFpdctY3WUkeLVSwWK/34K26lXc4pJ4bjywjKy9b4gJkPeAWKt4
         gn/A6/DQZksFxZ2b0fsnjn6/HtBuAvjc7tOfnobMAmOS4oOhpE7y/oC5jbdMF6m06BFE
         Jh8LMPs7yr+CCkIrLTKm8yIM0OozU3bNrl2tz+cEgQA3s10oN1aYGx1QFlogY69oxnBs
         G5LA2FBMjXhVZ0ltTxDWLtgB2jkfNOaRxhzJvg0brHtHd4Ca2CHPuE4+VOfVASwxtCCu
         SBMHvA2Edg/ZWBQ4/nZ0flNASRP0OoE8jS86mX9RsDsy9qMCPTMuckvvh1WU64wS0qr7
         tb4A==
X-Forwarded-Encrypted: i=1; AJvYcCUwNZMCDkEgBJwa1nRzfoOFSTFSucABfra1QKio69TvdL/0LvfpPtn/58B18X42bSHonMqWX5xDcQ==@kvack.org
X-Gm-Message-State: AOJu0YzVG3vT/NxpiVwt5X7u2XqSKwTogAyRq2Etx2znl47GlYqgM/QH
	6HBLZ9gmBtsAKw9Nxb8xbasASzIP5QjBNn5403po3/yzR03bryMdBgQd7Tz6dfBUs56OaA4gnxF
	4KeVdnQ==
X-Received: from plbks8.prod.google.com ([2002:a17:903:848:b0:2b0:52e8:584])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f84:b0:2b0:4b3a:9b4b
 with SMTP id d9443c01a7336-2b0826e3368mr7472585ad.16.1773963066002; Thu, 19
 Mar 2026 16:31:06 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:34 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=2809;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=wltySrG4vozgVjDjb43L2B3dD6dgSygZ1tpNGMuiOvU=; b=MzayBc1lrUG8AtictP2UDRMFjSP2+93iY+nziVK024vQNTr5SivQhuoSDPM9eVFFuI+tPuw4N
 h7fKV+BGoAJDypYm6vtelBw4anbbG1sxuJC+lRnOm/wX8wAEripkYXw
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-7-92c596402a7a@google.com>
Subject: [PATCH RFC v2 7/7] KVM: selftests: Test guest_memfd behavior with
 respect to stage 2 page tables
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
X-Rspamd-Queue-Id: 65ED8100004
X-Stat-Signature: rmwawstiznpxu3mmc7sw8bnw1hm9mzz1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773963067-578078
X-HE-Meta: U2FsdGVkX1/bXxnbOMLFW4qQvYt1ic53kVWWWAMasC4jvQOnamHtCz0Qt5vDzDyEsi52/hPhUIxy/+25woP4rs556UZCfZHaUcrSKCaLfOWHfrSOnmxWfxb4EdW2YiWJMAAU0vAv3NTWcCregyOyTuKnl/fjbx3aKHZDAcDZMqyGg3doSGqJQv6pEVp/Xhekhw21K755CiKZKwe+p4huxSbbiO/rj+UUwlNzjFxq7O0/oWC5L71oS3wzZqPW9ksYAmM2xqinHrDFeQgQWyJaOTnms6EoY+ZRxFZUlg6ukOmFG3PItMnt0f1fb0MKsatnMNwBrIWznbqcOyxBtB3f6HcLNQp2R3QWZKNIb4F4/EW46a24p6pcw31FGxtovciwmZfQ741ky+lgxF3YBM5sx8RtNp7GYfTd2MaSwla08bELh6yZjsjp0lt3NXIBSEg9xM2Nqnbv3ymjDEtYBNTLwSWa/KvjcCH5Ma/925rsqvje2cdqcAdZEPiBtHtJqbBjrcr8o19KcbrMXXPboj3TOWzwem3W1y0KtucQ5L2/I7ht1ENwxYXSqaWcXMVi7hAh7S8cFF4BfeCsebzYN2Q52IXAxIiyIt5+R3g4C+QGwjS8317XuJybfP782N+w8L8JD6XsMBg3a/Pl9+LGGm0jIdvETvdQfvaq9nMYvdybjwPN9wZAn/6arCVboNP2JxlLpAfhDO1lM8STRKOx8Q5FyLmTVWAPEyln9y9ws/zKBGnhFsYiVrdtZkL0FRrtSApEShMj2Qo8YskB5QRtxqUH0CXyKsv6dySHH/2t6XVGZa+UiCqbtxfW0AeOrWGT7ilnbgkvIUbfMdMJzwE/8dJ4f9y15O95FRP+gcFBchKjkQox3BNSwlRrOIO1cuVpUn1P1ahckpOgDs8h9gcs3416KqG6cJHMMlRGu4R7XKI8zJSiFAb8Nd72GhEKqiVVeohske1iT/gu0AYIXDMV9cs
 E68U9Uw+
 jJajJI17eWximJzbRY1de5q1al2dBZnJKSlcHY11/BGD9HEygqlZCVf8KrQputnppYTAPk3y0+EoQ/sJhfmQl74dMPAgG1D1blNfd49uYJbQDktBJHIwcpQGn8jtihZ3Zz6zBYuYeO43dJrH0KM/DG00b5wMyXOhh2jEEnHuObkc4pjZOQTqXcoxgTHTe7uMbXayYU0oCaC2E0DEicMpZne7Hb2gBajadZKnhe5wgWRBvn8TiCawQE9c51xoEnviL2ovx4i5Ij95IqZUSNJ7SCXoOILY3emzru4JKi54Me44sl3XnJXSpJagNC+Zx16VLKPW16XNYrhd1xUgn6xOEVM0J0p7sTKn1oDzQWzXGn3Xqeuv0nxRShvbR5tB0DKsMLsN20qMuPGVcQIQzjYIztl8+IIyCgcxsq0xtiJDuSM1C3fnnVnPbeY69E4u5cvzh+wDkX6FIyCxaPNHgZgGg1lMVwg==
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
 tools/testing/selftests/kvm/guest_memfd_test.c | 65 ++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 445e8155ee1e..50907875dc43 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -637,6 +637,70 @@ static void test_guest_memfd_guest(void)
 	kvm_vm_free(vm);
 }
 
+static void __guest_code_read(uint8_t *mem)
+{
+	READ_ONCE(*mem);
+	GUEST_SYNC(0);
+	READ_ONCE(*mem);
+	GUEST_DONE();
+}
+
+static void guest_read(struct kvm_vcpu *vcpu, uint64_t gpa, int expected_errno)
+{
+	vcpu_args_set(vcpu, 1, gpa);
+
+	if (expected_errno) {
+		TEST_ASSERT_EQ(_vcpu_run(vcpu), -1);
+		TEST_ASSERT_EQ(errno, expected_errno);
+	} else {
+		vcpu_run(vcpu);
+		TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	}
+}
+
+static void test_memory_failure_guest(void)
+{
+	const uint64_t gpa = SZ_4G;
+	const int slot = 1;
+
+	unsigned long memory_failure_pfn;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t *mem;
+	size_t size;
+	int fd;
+
+	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_FLAGS))
+		return;
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, __guest_code_read);
+
+	size = vm->page_size;
+	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	virt_pg_map(vm, gpa, gpa);
+
+	/* Fault in page to read pfn, then unmap page for testing. */
+	READ_ONCE(*mem);
+	memory_failure_pfn = addr_to_pfn(mem);
+	munmap(mem, size);
+
+	/* Fault page into stage2 page tables. */
+	guest_read(vcpu, gpa, 0);
+
+	mark_memory_failure(memory_failure_pfn, 0);
+
+	guest_read(vcpu, gpa, EHWPOISON);
+
+	close(fd);
+	kvm_vm_free(vm);
+
+	unmark_memory_failure(memory_failure_pfn, 0);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -657,4 +721,5 @@ int main(int argc, char *argv[])
 		test_guest_memfd(vm_type);
 
 	test_guest_memfd_guest();
+	test_memory_failure_guest();
 }

-- 
2.53.0.959.g497ff81fa9-goog


