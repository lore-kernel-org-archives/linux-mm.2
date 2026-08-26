Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A945CC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E306B00C0; Wed, 26 Aug 2026 05:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE636B00C1; Wed, 26 Aug 2026 05:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557CD6B00C2; Wed, 26 Aug 2026 05:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 101FF6B00C0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63BFC802E8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:07 +0000 (UTC)
X-FDA: 85142871534.28.667465A
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9721B40004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C2Y3BUZN;
	spf=pass (imf07.hostedemail.com: domain of 3h6-OagsKCHwfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3h6-OagsKCHwfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735945;
	b=4RzCxFMNb8yLu6JzHwIc4GyV7K1HfTnBfYw13J0n2IEX09BIDlN9xNm4trIbAtkw6pDZI0
	brald9N3T6fbidgq9j9/nayjyafgYKjejwKrS+kcJgQeQOrCETzddkmOZOcMrAoSzOc7Rn
	ql4OqCpoiohopX4IsB219r8XQ3Rmy8M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C2Y3BUZN;
	spf=pass (imf07.hostedemail.com: domain of 3h6-OagsKCHwfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3h6-OagsKCHwfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+QIStebluGuNMlcnL56N5FeU5gomqFB4kLU+1RXvFs=;
	b=u+07H91ayhVjwFuOqhMMD4+80pkZ5MYFTQgj2bvBPAP4QLMVGA6+sdkGDFAHg+pnAYzGkt
	hvCc874SK9sIhDz60FWhS1LbeA0DSfonQUaoifAA5gAYezELsGp0WTI8/dmSPcvvNaa8gr
	iJWaPXFf75DL+znBgi1mhVuf0SOotAs=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ccb6823efcso9254815ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735944; x=1788340744; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U+QIStebluGuNMlcnL56N5FeU5gomqFB4kLU+1RXvFs=;
        b=C2Y3BUZNyESBuPCddi8ya23ixTp3sKB9eYRyqzMHS5fhR+SUJvA3gtdroQjIEjjmOD
         ijg6LNSTtfTTmH0LdbnhAUjd4h0KhXc8m2cS/zrKMZPTeHV37tHMt2MmnS65wHsPH6My
         kR/+z9m4s3OOcNfph1WVdZ9nZfc7ZcpoKFSINKQnHPxs3JD3AmlQB4z+1kByvpGH3AR5
         7X2SnA9iuJVpVyBGs/gapvunwL/YjmqCrRIWb9FvjVN/pN5D3rx4+3rFga8Mbj7ucHVt
         KfdeBPzJUbTfcTq6Xm23jOpPmAhtgtq7S5sgnJHwYNnlqxjCZhrhUtLPcMDJesbl4izF
         YTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735944; x=1788340744;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+QIStebluGuNMlcnL56N5FeU5gomqFB4kLU+1RXvFs=;
        b=Vbd0itx8UZi+LDTBrl6Ffrx27nr6oCkTD+6mZzvLpsF5Axaw4G3O1EG9S/cDw2ydi9
         SkaAqMJmr/KP+6NyA4KhK0svwZ2bzIYpNg98Bxgs40dW7rNDuLSmlS08iQtGOuJGSR4+
         kr6cilFRvxicwCOj7os2J9uOEEv32JM7c0snY8Yj/6CP/MhIEc5TwmlesXWfmevS7YF5
         65sDBNbVSLV/Rj/yzeOKecN3Eni49RfagsC86FsDdBcOM/W39QmoWVhW35HEeQh+hXyy
         1j6ENGxaSs75/5vQS9K55GwrFr+XEegtoR+97wHrCKLXIlobSXoHvPFc2F5QQyrRNYsJ
         16vQ==
X-Forwarded-Encrypted: i=1; AHgh+RrDlyqaLaWjRJKVId7X619b0zPp2pd/jkR99ngRFzTQAOtcD60AzOpnfNB8jwEYPt/rtAbGzVp/Tg==@kvack.org
X-Gm-Message-State: AFuF++kY7TtWaAv4M/VVOhnQxsjOAuqmsTXpzQqtc5yG4FbqixIwwXaC
	0CHSEnax8W5gucJdf8e5PZQ4nkVsk3kQC+RxFrBdZcBykXegBeTmUN9/LLLo9j59qL1XDLWBDih
	/klttg7zliHGRJazwEA5mnlq1TQ==
X-Received: from plblb3.prod.google.com ([2002:a17:902:fa43:b0:2cf:75c1:ab87])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2283:b0:2d6:7409:7145 with SMTP id d9443c01a7336-2d707a2edd0mr90992585ad.1.1787735943792;
 Wed, 26 Aug 2026 02:19:03 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:31 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=1811;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Z2UFei2SRBY3/wzto9IlHBrYtnnFhcb6Xe3JALubj7U=; b=iF9oclctKMAmtq8/BXAmeziLVob0gwQiMxab9AP4cOna1dViC2KVb0DXsHietLlhMm4MmiLFx
 NG5IyiRqrCFAgls8o8R4aRa0shTBIbhH28LRiR+I6Ogpy3OSwNF8ZVo
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-33-0a15d8a799aa@google.com>
Subject: [PATCH v11 33/46] KVM: selftests: Test conversion before allocation
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9721B40004
X-Stat-Signature: cq3ewddg81mgusw3xn6hk6r56ue9ic99
X-Rspam-User: 
X-HE-Tag: 1787735945-94596
X-HE-Meta: U2FsdGVkX19LfZY3bS3diiRMQsBbNxXFDpTzWRta4pBz5eH7wlaopWTrS4H/ZdQOuQFLYNyKGSMgKiId/RuU96g9Q5HGMxR7SMsSZ1LoEdlnmhO7Ek9hR8LeRChI7llEbK/SGSnrPMCkNCt4HCrR9hSe0Xkvv9qIkwqvEnZaKtmz9M6LTXnH0zYpVlJKdNJXehGBIEN/zV1V2WWm++r3gFLhZtgzeNyvpJgYcfIaWKCtptWd6/fc5gUvpJ9uEb/M8alBBe/L67syRkgws37ABWH/yLvbNc9hoQgxgbqvf0Yt0XHaAoeJPZsbHBQvi4fKLMekNTLp2vJQAP2UwKbANLxzDjyvTWFCwx5l78TNpP3/HhHPaSB5XKUw6oNi5erXNc/lWvN2/5Qav7CJt9O9EiTNnRy5VBzQtD/YAwfOxCW8q9d8xfNMuxufylKRaTpWWK5OeWrsctTDPpKNpRjw7IN2TV9EnJksW8f+GVU7nMElS/qZAMGOQQj+NyAJdJL4bxX+y7MkBICRiazKBY6H6FODd8e85d3paP8x+eZtzkbewC6fNcgFiFi9RnzRd7B4OdTitckVMngwrchd5GsfPigSUK7LosyHA5oZtfl936Ki3sfsudf68/uXb8uZbnICKg0x1eqa8ePspf/mherzoeClHN44Y+XmbB0nbpOfphH3IVY6Jn2v9rhtDuLTgfHIS6ETqFRXvHx25ye7k/tzvviJsPW+5jqhZku9jZNCJL3cYMpPkfrmf+v/iVXPRAVIDa1QioPThIFsL7JmFjTVnOkc3d6Ij6Y6rfE0POSP7zzG+bhZvkT61W6olzFIAXVvJ4UF7ZYODgmQS9mORi7rj1oMufLkbOoEqigYB6pM1NR3s82tCobm4i7WZCLvFs86M9LLO2HcIolyQU7Ruz2Pb46+kVYNwq6j4dGuyTFYI+XJuGMbIwLxhlrYDzv+MDR8GkosxuuOo2z2sdWeaOB
 A7915S+R
 50WI/FXVmm+O4YRFMJkk1TpMQRIMYOPgdNdSdNfGXu4D93nXpPYbUhDsoGteDgeykHFzkVX3hd1wAYgWM67+ZMxPBT5XpRSXKOBFroeI1SoElYqAAo6MS1ffaEpRxGSTWA1NUoIB0zpifLhOApbMx1v/xlbWkPOU4uXDWhuVPKFJm+Z3Dx25PC0Ju8UXOThFvtblJDaB1BAqTqCOKUfwUl089xChVTgK6pwnYAY1zIo1gkqQs5TIPpaySvuoLZruv91qpXej+vZaAj+ey/Na7G5kbiQ871R9lrR0eMqau1HEzDoGELRpQT5Cb7rUus85teeMXJGueYKwQ7o/pbe9LOj3GhUqr/4p0R1OH8FSQu2pKsKlgdjsg8aPHc3SRyBT1a8C+r7xFDcu8OLFY//F9mMiEOOqNQuIE79UYXFAaqA+JaW2nNMqyqHFVTNwbCzdeo1szjH4X0Hhvv30vAxYYtaCjP4EAXuT0s2b/mOK7o6i7CGqubSFiTjktn9OF6jOtugxYrlzjs8QOyy+g3LVzLozMLP+WKz2LlxxR2cMvJgDZvchiT7jkHDDuIHGDadgUcXSUmGW6J3xmvViojKJbhh+tiTOZoZIGUIsArGbXdHxS33x0ihuyEZe88gAwW2lR2SMC1Jc0TKsLJbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two test cases to the guest_memfd conversions selftest to cover
the scenario where a conversion is requested before any memory has been
allocated in the guest_memfd region.

The KVM_SET_MEMORY_ATTRIBUTES2 ioctl can be called on a memory region at
any time. If the guest had not yet faulted in any pages for that region,
the kernel must record the conversion request and apply the requested state
when the pages are eventually allocated.

The new tests cover both conversion directions.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index a8d89df53e46d..f46f1530a94b9 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -268,6 +268,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 #undef combine
 }
 
+/*
+ * Test that even if there are no folios yet, conversion requests are recorded
+ * in guest_memfd.
+ */
+GMEM_CONVERSION_TEST_INIT_SHARED(before_allocation_shared)
+{
+	test_convert_to_private(t, 0, 0, 'A');
+}
+
+GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
+{
+	test_convert_to_shared(t, 0, 0, 'A', 'B');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.887.g758fc8c411-goog


