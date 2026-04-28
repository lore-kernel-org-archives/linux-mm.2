Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA31FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A7F6B00AF; Tue, 28 Apr 2026 19:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AE96B00B3; Tue, 28 Apr 2026 19:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A476B00B5; Tue, 28 Apr 2026 19:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6636B00AF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA4E11C0CE4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:42 +0000 (UTC)
X-FDA: 84709569084.28.9AFF6E4
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id BB1D7C0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N9Xfzx+n;
	spf=pass (imf22.hostedemail.com: domain of 300PxaQsKCHYUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=300PxaQsKCHYUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZczNi69+WMKOJksOctcu51kanJpEjkfDW1oXPOUGF4=;
	b=RjVXFuXTcUxchJhF2Ona1jhZIEUbRnsd+JoRRD4JbYDw9SIJz2luLtYAEs4XJaW5cQI4yY
	p86hDv2j2vs+pKa14SQjzQDvnSJH64TgHJREduEnrvFHonyWoZu82ddE73mVI3DwcXajvW
	OiELfx35uHKqPB6SwyVFa85hdEVuukY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N9Xfzx+n;
	spf=pass (imf22.hostedemail.com: domain of 300PxaQsKCHYUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=300PxaQsKCHYUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419220; a=rsa-sha256;
	cv=none;
	b=g5jgMKkl27urE869Ec9sw3c8AKgP75bo20V6idjy08QlORix6cYvgBnpEGdHuhacE9Ke58
	ffp57GmsjcL3yXqJr3nE6yCpYBqYjOEiIfYEf8rOxjzB9PydM4UgGDsHIfKaZgO4hLWzHl
	+6bhQxb8LXDMMkRqh4sNFtRBaCdgk9I=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35d9278587bso14388647a91.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419219; x=1778024019; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZczNi69+WMKOJksOctcu51kanJpEjkfDW1oXPOUGF4=;
        b=N9Xfzx+nQYzQ6QnpcEFbqupEtKUkoYq9qR0H8uwcpTdu50HUOlh+RXMrYM5co22r8E
         CdZqJihRkGxAbzSdZFqIkXZdUjZn2bqrCL3SpsPsqNKIvqvucU5hWa2PiIK7uJC2rhAI
         1grmfybiuSyK2PsCQdsUiZGKn9YohqLmSNhYAoy6AEuHnkcsxPM59XgEYuWVc+We8RBX
         4eTMKkxwEd4f6C4NdfVpPdkpXMfbXXfnhBgiIaef6F1aMOjyCU98eKd9j1Bym6M6rpq4
         9TZ8mt7QpuZ9SZhkuWeDilGgO1tQ5rdIIfcutqbceFflPMfFN5bBfPRltp94c6GNPZxK
         QPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419219; x=1778024019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZczNi69+WMKOJksOctcu51kanJpEjkfDW1oXPOUGF4=;
        b=d2714cjY+NYC89XWIR9et3RZ6BLZfvRSXc+0Sery63H8C7g2brW79O4SYxR2lXCgdc
         9wrdaW/rGDMz6elB3BGKwYNcHpXU1jv8QV/qXN/fv1Rvl0QkrR5V3w9DYHrWitn57OA9
         6ouUH/okp3iaR2hGbtD0/3OtbjFXOclldz3f7rEwtyYJv8OOutcJe6nOL0V43gQZg1Ii
         pttENM2ackNiXuvKJCLvlSCgJVDZ+o7o+X/VNlfSJEIMCMHtQ666NHDU5B82dbm1ZBa5
         DA2dSMklMuu3b74HOKe7Ep+58kmDofN4seGGGXkZMWslCyyTXptn2+4X/QOEbfi3qkQ7
         3fIA==
X-Forwarded-Encrypted: i=1; AFNElJ/XUlynv10oWcFAnQSEA50ojFDR46SYYnAGAyHmV6pa66A84XX5gfGcoH/zdg9vyF6Ip2tntzSyCQ==@kvack.org
X-Gm-Message-State: AOJu0YzerP3ZaU0QjzAHgUmgbhEY+5qm8sHVfiDwyi7FN7ra1hGTZxlf
	HO/R2kxS1STOy79pihrP9XDa8mar0rhU3HBJPYX9DM42jI3AXS53TTAi41FyJiw7SUGZanucfW4
	rm9rxl73xYE0vGpk74jG5ObkSbg==
X-Received: from pglr36.prod.google.com ([2002:a63:5164:0:b0:c76:a2d8:308a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d20:b0:398:9820:f6cc with SMTP id adf61e73a8af0-3a3af654fdemr1435167637.55.1777419219029;
 Tue, 28 Apr 2026 16:33:39 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:26 -0700
In-Reply-To: <cover.1777418884.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <cover.1777418884.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <8ab73dc90c83af8dd30af3fe531fa68ee1cb4b96.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 6/6] KVM: selftests: Test content modes ZERO and PRESERVE
 for SNP
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: x7ruo8jtqy5hqc96ugnbc593ct6shnh1
X-Rspamd-Queue-Id: BB1D7C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777419220-320430
X-HE-Meta: U2FsdGVkX18SCMZY9Jgenb1O+8LN+Oz7c+9iZNl+cwcQWzQhVp4KAG5J9GboPvscWh8B+M4UHWWLUfahHW8pj+7KA5ZAlKVg431PCg2vWEHi1CwhboisQ+XyNy/TPQzK7tcp2kBCTdHuLx8JsjQ1Ns6838cjAei0ez9Kg28STiJxaVlVfmXHMAhaOClupOu/Jx02E4uQqGN/Rg8NdwTeV0EQBGgG4pHf9UkFfW4CGa8KadrbkMR+qxfZwG7my3IlifStqeJnK2uK4/kP1W1AFR2vBEwmgKH+CD3MQqRgqopneSshij3O4+BT91F9qqwpfyE1vx48mxu8cJOcfLWRJKax8ZiKeZyqzUBajIG2wkvOzcH+/5jD+ZNGzgSZNa31NPdKkJ4oFsRDPEQrD6rBzJQXs7rBRqsOH3kf0S1fXADxFI/uXPk6RIfuK4t4zXC+0Gvi8YazZ9hhjynQAMRGVcZdPyq8va3aPsN9m/SKB49UOilzLrn7uL2+HKzyLpGPjwCT2ybFoLmPjlKbM0Tq+Mywx3t3MX435NERoxUqgdVVgs7CjBriWNcCtn0hhZqxl/krSx30PPLnA7lDyfumsGhChGd0ujtAZFqkIP2/rSbE99ypr3VoWnN/ZlL9DI78FyysDF0uPdGeDKZ3n/Vp+g5EoOjf7MFG1PEFz3LvYdIjN8Y1WfqqhwA/XwhqoQ5F85/2JLsNRF7VcAnMw0ZF9R+T0cb/8a76kMWs6FriXyfH317xSpbtzeBpY43tG1rIIRYXma3Rkae/x5sfQwACmZsP5hiJdFo0AOXJesK6wNk5E3XYNsoiDNfM8o6vGt/CdZftIXNPpNDA573pDqXTUt61GwgI53zxZ1oVdS+BXo/AWS2lGzjzhcgNrzBI5sBj4lriLfJtLWpOzq1Tc18AY0DOasug8xUzUpHGBeDDwT6Y4edKl53sKUwFdJpfIc2/fSsOufFEbvfq1kjZUuO
 O2mFyuKr
 H742Q84cZHvCoJ+aNDv92HBCEv64rVXELsUtcdM0+LLwSdoGZgKivOFdZtaNU0i0YaLP3UZNF3VuMM7laM/9ksEwmE3hlzY4nKhJlw+AOEA94MdeNSmwQhmZTrAgk8IRwXcwsrEYP2QpRHFkTejdYLtMEcMaQ9+CC4l3EYpaxMHSWvfqXPctrBoHEI3eaOVGzw59fL/643v8iMkIXnIUzUwfkY7GVkSthquradlDlOqK0gMNBvZFfGH8KtvG+++BjZ4EjcjDF1ZA7uAoD1iLC0P3ju8Ib8b4vpdQpBwcJLI+ob1EJ6mzsKrGTagA5+OZ+4vrcWzUKol1JAJjkJHjjpqT0B+INSJC7boF2LsAawlpBVDbWTvxA5gCFYOkY7wLVxsdJwj60vzq2bzyrkPQ5zszTOue7IfDBc5rKpX0+i1AJujW4M+2Ra5uHhLu7hB7yPh7N+ZgLX8xBsjMDRiilMK0zCfRSiMVSYC2Oo69tkUEs/LNPZ9hT4zt8HKz1sBYilqSxgkQNUABa6BKlu0k3D+b9jpPzoYmq1dLqcKv6M7SJpJ33/WaptH3urxE9GQUmEunApU+D+ZJpx9K0XgeA6ihbPIT9yprxv9rQDYoSaNfyVnd/F2r3NHPFe+cctcAm5gVZ0d8WFy177osoY2chyzwAZReqJ8RIHhy1g36Arh+8FF3Is+4Fp+ehDve64Rt2Y6Sk1jN/Suem1l0qB8z2uly26jMb23Q+GTuOtfLwjZIh0K/Wk0BTfb/Swwbx1sCTjNcvXmCTXpiIiyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/sev_smoke_test.c        | 47 +++++++++++++++++--
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 86f17e59e9392..7a91a113c4fb7 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -365,7 +365,26 @@ static void guest_code_conversion(u8 *test_shared_gva, u8 *test_private_gva, u64
 	vmgexit();
 }
 
-static void test_conversion(u64 policy)
+static void vm_set_memory_attributes_expect_error(struct kvm_vm *vm, u64 gpa,
+						  size_t size, u64 attributes,
+						  u64 flags, int expected_errno)
+{
+	loff_t error_offset = -1;
+	size_t len_ignored;
+	loff_t offset;
+	int gmem_fd;
+	int ret;
+
+	gmem_fd = kvm_gpa_to_guest_memfd(vm, gpa, &offset, &len_ignored);
+	ret = __gmem_set_memory_attributes(gmem_fd, offset, size, attributes,
+					   &error_offset, flags);
+
+	TEST_ASSERT_EQ(ret, -1);
+	TEST_ASSERT_EQ(offset, error_offset);
+	TEST_ASSERT_EQ(errno, expected_errno);
+}
+
+static void test_conversion(u64 policy, u64 content_mode)
 {
 	gva_t test_private_gva;
 	gva_t test_shared_gva;
@@ -409,6 +428,21 @@ static void test_conversion(u64 policy)
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
 
+	/* ZERO when setting memory attributes to private is always not supported. */
+	vm_set_memory_attributes_expect_error(vm, test_gpa, PAGE_SIZE,
+					      KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					      KVM_SET_MEMORY_ATTRIBUTES2_ZERO,
+					      EOPNOTSUPP);
+
+	/* PRESERVE is not supported for SNP. */
+	vm_set_memory_attributes_expect_error(vm, test_gpa, PAGE_SIZE, 0,
+					      KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE,
+					      EOPNOTSUPP);
+	vm_set_memory_attributes_expect_error(vm, test_gpa, PAGE_SIZE,
+					      KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					      KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE,
+					      EOPNOTSUPP);
+
 	vm_mem_set_private(vm, test_gpa, PAGE_SIZE, KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
 
 	vcpu_run(vcpu);
@@ -419,7 +453,12 @@ static void test_conversion(u64 policy)
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[1], 1);
 	TEST_ASSERT_EQ(vcpu->run->hypercall.args[2], KVM_MAP_GPA_RANGE_DECRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
 
-	vm_mem_set_shared(vm, test_gpa, PAGE_SIZE, KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
+	vm_mem_set_shared(vm, test_gpa, PAGE_SIZE, content_mode);
+
+	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_ZERO)
+		TEST_ASSERT_EQ(READ_ONCE(*(u8 *)test_hva), 0);
+	else
+		fprintf(stderr, "test_hva contents = %x\n", READ_ONCE(*(u8 *)test_hva));
 
 	vcpu_run(vcpu);
 
@@ -441,7 +480,9 @@ int main(int argc, char *argv[])
 	// 	test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
 	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
-		test_conversion(snp_default_policy());
+		test_conversion(snp_default_policy(), KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED);
+		test_conversion(snp_default_policy(), KVM_SET_MEMORY_ATTRIBUTES2_ZERO);
+
 		// test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
 	}
 
-- 
2.54.0.545.g6539524ca2-goog


