Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1615D10AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D556B00E9; Thu, 26 Mar 2026 18:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627146B00EB; Thu, 26 Mar 2026 18:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365B16B00EC; Thu, 26 Mar 2026 18:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22F4C6B00E9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1FDA160E4B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:57 +0000 (UTC)
X-FDA: 84589647954.20.51DB890
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1CCF9100005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JoD3nOeW;
	spf=pass (imf05.hostedemail.com: domain of 3crLFaQsKCEMfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3crLFaQsKCEMfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JoD3nOeW;
	spf=pass (imf05.hostedemail.com: domain of 3crLFaQsKCEMfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3crLFaQsKCEMfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563956; a=rsa-sha256;
	cv=none;
	b=UaCCBJqu4hJp2HUlpgjlbBxTWIMvyKpmzojHm5vT61cGtEGxSty+yNViVgAEu0n2/obo7U
	g1wnmeE4s8E+LWqrGh9Uk/d4c+rJnVpmAQ5QiQVr6Wfoq5IGMm5RbtiY/4XptXTyjYU4F6
	XtuYha2kf5xmYBypMDtYVzWeb525TFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYq3s+F9mgPwmWrETdAju7b1wzJHYtnrsY9IbvdmqE0=;
	b=TAtNkMOCYiW/zMi2I+gSgXpxFD0qNwJr1gyy9vbYNlji1KgQgDu4L8liygEZwkA58SybhJ
	s9ijOVjPI/TPFeMcqPGL3Xvdx6C9hpVubvhtcnKp72/6g+1Twt0y/YbgirErHKQjFcBT7L
	gW74MFdjHj1BJSszC8FpZgLj45wOVBs=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b06b68783dso17629675ad.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563955; x=1775168755; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HYq3s+F9mgPwmWrETdAju7b1wzJHYtnrsY9IbvdmqE0=;
        b=JoD3nOeW9bWbV0vQtTLcJXXq7I4pZS6hofD+it97I4LkZixoXvwWC73WOcyNXJV/Mx
         TVNT7/10qncEU6PrJBIJu+GOE1gwDeAJmVgMrL/IGMqotj/LoALJz8e3g1u9B5hQClOr
         izEMCTq7KdQsgCxN7SXG+GNyNwfnmTNW9hTEfvJnrOZ9pk5CIXBE6Gl/hLuL/YZleQCL
         kC2ZYyEVAmBWUe/Kylz2lbv4fMULDgSeDZs8CRHmpA4EK+IznQhEFwsPkNxN8kq3mTrj
         FsFy3hWLJGUKKrE3SSE7U214NDG+ltTAoZEUAJ9nFkfe5hoABBKEz1G0gJNgV8iJ2eIP
         JvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563955; x=1775168755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HYq3s+F9mgPwmWrETdAju7b1wzJHYtnrsY9IbvdmqE0=;
        b=ZHKn4KqMt2wWYBj7z00U+Ok4sci3RSpYm6Qiz/DMdgG0VUzPdP4fZRNyYM2uTSImcJ
         jtB6+cGQNt5woj9btGePIHyftwGfeX+eEA3x3j0sSYFRhijjs33uHIDIQJLrURVLvpK9
         jTiqQaJsyarm7heH5/eSyeWHRil/4cetZgHv2KeADWNBEooJCLwOn4IcmAtKWh8HcL+S
         oW1MqiXo/a1seO/4PlpQn8MR+5xmvMWnZixBArQPhIY/XcgbkYX9hC1QxSHVmSLdjrYd
         heg5UFTpfS7DQmDZsTYSvw1aSftnDHNDJA+Gzeo4Vb84o+j4f0YB5jXfd87uZbRrMnhE
         z/kw==
X-Forwarded-Encrypted: i=1; AJvYcCXPpjPS9YLPFzkxLyn9kYFL0oiHlyPh07YaalGYg7A7I0iwSZAMHJzmjltanHe+ZhntwPcN2nocfw==@kvack.org
X-Gm-Message-State: AOJu0Yyltnru4JsqfNO7SXq7hERPm8AC+bR85q8PrOgkIcDXd9cc4OOX
	cEmXquVSezmZ0PZIqGK7Qqgv9iD6PvMwuW1SiTTBViDBMJ1XFDORw/RYlm9LWCpnssEmUuYZYBQ
	EFts/1288iIxhku831Fol0A0MLQ==
X-Received: from plpw13.prod.google.com ([2002:a17:902:9a8d:b0:2b0:6121:c2d1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ccd2:b0:2b0:5520:f497 with SMTP id d9443c01a7336-2b0cdc0f454mr2752855ad.9.1774563954612;
 Thu, 26 Mar 2026 15:25:54 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:53 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3745;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZGSq+gTFZDY/anw9T28+HYi6HmGJV6iDHsC4BSDh08w=; b=bl10NJA+tRza4190u7kAzLQjI0OEISMmC1hhtBIOQpOao11zciKPixnzxzkJzUPyjzD9rwpIj
 X6HVw8GptTzD9pYDEM6AtX43w8wyaJLsoqTW8KTBj/fh9MfJfpHu8EW
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-44-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 44/44] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CCF9100005
X-Stat-Signature: boci3geqcx9jn6tmauedapttxrnfg4ie
X-Rspam-User: 
X-HE-Tag: 1774563955-950039
X-HE-Meta: U2FsdGVkX1+5HOVsZp9mXYD4QM9JTdp6x9yR/vuwf3ZeIlO4MdKlZkTjNR3suJJrnhUMrNiO71TSZZ5n6vfTa6YvfHO7gN0gHVPZKtKM8Q7do3ynXvsFrXCuQV+3K9WP10CA7ktlK3rDV6wv5hZfT++TDpRTTOWbCFYiQHHKdNaEYMFbDXTSPZ5QMe0c6orWGZxJ6G7phmhbj7f7vbe5RX9A08ty8h3BL1hLXo6uXjYXhC3FUzbW+ldIZq2n36FiiGwndaEjmAnU5NSWowYIWJjV46sCxscxN0ExgxhVP91+OObwcgGgWgOjRc9k+gC4KHGVlGx0lXTJiAdN/h4TGrjG4G7avNY+4BXVp1Gaq8H3xBzWtdaJuoMaGuVF3UHeVg69szUqj1KPPJpAWPBSDkXQJ/VVb8dvVZZGJOZ1vuLt9BRhp3xb5rr7u3+c9p14F+tfZXqGPQFxhoYPT0zlkUHlq24awqDMOGNAz7MBAa78M0I1z8Q4ARURUF6FZ3+hyzEnXt6WXGWh0GERxPLJgP5VdUPxF9lt4xFLWBXt+6fxPPJY6iRqy4YjlMdqHDJccsKgahwsfJd2QNtxZzo3dcUgwTSfa+HcaefQXiWThS5hp1DaDAvITsFURuxrtd6iZPu3T+fmAQhdgEruGEMtbs9geVNvTq0w/2p3GYGeoAZ5nBxMG9aHbEX/A9GhxqTwCovyHyBTELIazRWv2RreqtAtszNgfGu6zWPpVL46Vg+FlBQcvcwT9YgopAsSNekGrnVtCG+Ut0NmmxvC25qAFkGe0O2bmcwBTo+QHnVX9acbKdavmn5igNpbvn1Jckzyx+neU+uT6RDL+xgzRk77st/9Kqj9LGg4pRust8JffgiSvbUvSjfAaqJQyx1qgpzdmDmM7R1rd9rGOnETTTkocYp1I152CqYS4bNmEl+6m8ktb+LqWCWcEM4OeXBsEe8PWDyE+AtS1Sx4nZlDZdf
 vobJ1r2l
 N/2HrfoIXOnB6GDrbQXZjNkvxp1MlSHhnuagrmsIQSDnOqmkTEPMu3I9X7sIiBb6FjWzXzDKHHy9PsJMZOQl0hKDF6v1bryj7w6bIb7YwkRrVQMll8ac1Nq8uout4IRBiKm//hH92Io2UR0FssNETirjJcX71LYkodLsouLADpweEbMm7YkTOPHoHrbQuySVyJRCnQNJ1JhTcpXnEVJxyBkyzEADGbYeGSLuVE5/ySpyh7YoSCurkVeVIITSaPDbtF25WEVYz4vdJQcPVsXadBy12+pQUZ7ise/lakrz9KEw6kjgDFiADEoJX2vImbkLO3MY+5tbp/0/elfaA9FWbQN/aJrfm1Ip52iqveQ0RPJPxXuBDzr5CNFP9DUg2GF+R4j2slEdeUiSHr+JrG0c9CWYzUfNWP2IBfuAt71cOOwkmytKHmcgt6OcmmVOBwC9R0NbIK9wDptJkZkPL0X+geXqC8/rb5n4FTzw8vF5XPVEVSlsaK6Y8hTFk93E9JmoKKuhcfQk7115klMXPIq6x5bkb3oaRvNPygHg2/R+gq+yDVZDnFH+T1vyL947oAPY3k+qfRPKrB/bpv1UVZlkH7lPYKHt1iDEf+6RVa48/gqkeeOQAxwBf++eFH4lVwApw8jrBLLBHAvwoJm8DfYVRX3lhT9TaTb/APhT7dFk7mqOlRQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the private memory exits test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Expect an emulated MMIO instead of a memory fault exit when attributes are
per-gmem, as deleting the memslot effectively drops the private status,
i.e. the GPA becomes shared and thus supports emulated MMIO.

Skip the "memslot not private" test entirely, as private vs. shared state
for x86 software-protected VMs comes from the memory attributes themselves,
and so when doing in-place conversions there can never be a disconnect
between the expected and actual states.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c | 36 ++++++++++++++++++----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index cbcb5d6d04436..ed1bf27d149dc 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -62,8 +62,9 @@ static void test_private_access_memslot_deleted(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
+	/* Request to access page privately. */
+	if (!kvm_has_gmem_attributes)
+		vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
 
 	pthread_create(&vm_thread, NULL,
 		       (void *(*)(void *))run_vcpu_get_exit_reason,
@@ -74,10 +75,26 @@ static void test_private_access_memslot_deleted(void)
 	pthread_join(vm_thread, &thread_return);
 	exit_reason = (uint32_t)(uint64_t)thread_return;
 
-	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
-	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	/*
+	 * If attributes are tracked per-gmem, deleting the memslot that points
+	 * at the gmem instance effectively makes the memory shared, and so the
+	 * read should trigger emulated MMIO.
+	 *
+	 * If attributes are tracked per-VM, deleting the memslot shouldn't
+	 * affect the private attribute, and so KVM should generate a memory
+	 * fault exit (emulated MMIO on private GPAs is disallowed).
+	 */
+	if (kvm_has_gmem_attributes) {
+		TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MMIO);
+		TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, EXITS_TEST_GPA);
+		TEST_ASSERT_EQ(vcpu->run->mmio.len, sizeof(uint64_t));
+		TEST_ASSERT_EQ(vcpu->run->mmio.is_write, false);
+	} else {
+		TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
+		TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+	}
 
 	kvm_vm_free(vm);
 }
@@ -88,6 +105,13 @@ static void test_private_access_memslot_not_private(void)
 	struct kvm_vcpu *vcpu;
 	uint32_t exit_reason;
 
+	/*
+	 * Accessing non-private memory as private with a software-protected VM
+	 * isn't possible when doing in-place conversions.
+	 */
+	if (kvm_has_gmem_attributes)
+		return;
+
 	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
 					   guest_repeatedly_read);
 

-- 
2.53.0.1018.g2bb0e51243-goog


