Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BCF10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3BAB6B00D7; Thu, 26 Mar 2026 18:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC57A6B00D9; Thu, 26 Mar 2026 18:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C674E6B00DA; Thu, 26 Mar 2026 18:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B11226B00D7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 857521405B2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:39 +0000 (UTC)
X-FDA: 84589647198.12.019E848
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B6C340005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j9yXEzTn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3YLLFaQsKCDENPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3YLLFaQsKCDENPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZhopEmz9QupHvhORYz2gLUFM61nCO/Ej/TdDgxiHZM=;
	b=Qpi8ZGVVhmqON+gEJLppDHw3ezYKMRN2sSNM1Ppl52TDcKgGpPQd+nzybeWFs9qvV+W0qO
	cVvaz0LTbdKCxrYUvLUzj2PD+4EXaxbNWEd2pnys2oLLVuvC/aY4Ley2v2Tj19ATILNHAO
	o6gxjO3kcaj6X9M6ESnq32kuQnchAM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563937; a=rsa-sha256;
	cv=none;
	b=KaplHh5ldm5HHC+PRIoR48OikHfzaZqjSvLUtGYPDW8VZC9H59CJmnFRiTpakkY2+4Ihw2
	ocxY9VxRQWiEWr8nPQIoonYNYT2NgSjpGKMrCmEgqvXx16z1pKqaCllHnvfQB0y8tFJZ5v
	xzQe45c9iQvDtq8wttKxjcpqDZax2L8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j9yXEzTn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3YLLFaQsKCDENPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3YLLFaQsKCDENPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82c699d8caaso2756459b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563936; x=1775168736; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TZhopEmz9QupHvhORYz2gLUFM61nCO/Ej/TdDgxiHZM=;
        b=j9yXEzTnNKnF1IPKfNS5b4Dhz72Xy5CK56pAdBaakBoFA28dltYOJaKHIgPzz9WPY0
         CJY7hw5gaK2rReLHHNSdNe7Ws+HL5ILYwEZiWUjMAXhBRGy4kBLCHvba7SEcbMrB7NRL
         8lCZPSfVR2mxpM1l9lJuTXLDA0yg+7+NObQ+m8J1/mnSsBrVaM0UovMxfaHz4tDKHEGF
         S+rdwrbGMF3ypdJLnGOY9dU4UVU34MG9zRzROO81U2otaoJnd444mEivUWvsx3lSXZmZ
         4ziBVMVDjJ/npEZVOoZTEyyv8PoKugmY7H7vVacr1fZny+LZ/QxVPa5Vb4vd0mZeOG33
         l5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563936; x=1775168736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZhopEmz9QupHvhORYz2gLUFM61nCO/Ej/TdDgxiHZM=;
        b=rg4A4qo7Xz8CYzqd/YWTLSBYCnpQoYrAtEBgroWMQsa4hlmqCptfwFMylSjEDdPep4
         TclRyiDul7P4yEBT0kEGp1dFq/B9Vd7dl8wVcz1X1W26aanvaECSGgU+R8XldT9ChnsG
         9J/7Xn00sk6ePKbddfWig0dRpaZB3H/LdCrrRP0AlhsPZu6J1hmvp88xJIBWTo0IZZgd
         npbHiMaYkPiZuEQev3NA9q14rrxitracGHAb6C94UMHRD7/DCOXGkDkPzLIivomIjkBm
         thbgi1GppuIV8kwdDrr+chC4rbtMdQ2jmFZEXrGFX1ffvswYSK63P/CzF2KgG1iKxJv6
         fiBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEeV07ziCmpUIokBJuI0/ercmXOasPw11IOMblZIZtlo6FGUKBS9u3lZ8dg76Imnk3w0txiHB82Q==@kvack.org
X-Gm-Message-State: AOJu0YweTso1AeCZ7dyigj0t2z1pAY+8fZVQLG7aTJqBPcP4AFDAT07e
	bY2H4kWGTidH/kEF0fanGySAaix1heifKEpEqLKBuDnPmUyEMux22W2PUFIeXeMG+6IQ5qREoNI
	EJ5MYeZ7RxgIiQ5926rSKL0g1tw==
X-Received: from pfbji4.prod.google.com ([2002:a05:6a00:8f04:b0:829:a298:e5f2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b60c:b0:82a:780f:a18a with SMTP id d2e1a72fcca58-82c95ee9102mr155260b3a.44.1774563936260;
 Thu, 26 Mar 2026 15:25:36 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:44 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2085;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=TKwIneM09cvvLCUdRFakE58DgmH+kzGWLG04CD3qLX8=; b=oVFtCvMAE6x+EWDc+ry+cyq4SuvkUPW14QkvvxiXdSdeccBpOGoDim0sAaLqVyLTdu9yvnNDz
 56H+dt+vbO1ARLNr5kGJLYZ6iZL2rOnEZG0XxMIEmctPUz2XJRmzJZV
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-35-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 35/44] KVM: selftests: Test that not specifying a
 conversion flag scrambles memory contents
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
X-Rspamd-Queue-Id: 9B6C340005
X-Stat-Signature: odjbmp63qmodkdsw5ga311i7tak1juca
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774563937-261259
X-HE-Meta: U2FsdGVkX18Q5Mw3R71oThhwb1QDwf+oH4pSK/RZp1tkX487i9l7eaUNefT2UXr/KbDANKnFpIzXKxzuQ79c/mcfBB56IRHjZf3cLJaMAv76mW72KF4VlMjqQ2nBmrlFBwcaP+M64kSp7+AzgNGvgeVt3+k5cwrV1bVl0ErvIlrVZPkbdQkv2fnIcx32p0nR0N9u+eSKuJ1Zm5S/rL7Yc0WWtbdL1SSQNYh6Wp6ourKfjkv8Qyxgd3WbngBWppfr+8UKAbQOxrJry5R1Si0jUmPVCzA0PdRWedzRLhK5uPM8bePnWljvGIRjhN/oar2JTBn05zFoPUsaidZETQdpdskN0cyxQXEpBHUIDfFNpQHLMJfKyahJOFRpPNSUDV3sX3w2mzObi3AhRF1NK49eQhBFRwqVR3NwnGmtMtSTRb8OH3VWNhBtSSM6+EVVommCFwA9dzx1cGjN9eup+dfga4M1UlDMAkCJaobAa5q7YxirNyKExSH8mesbHpXwbVu4MOY0WT9xH7PA3ajRvzegdRBIx5/AIdXY89mWflBRR6XH/LIFcHm9CxAxhJWHRPtTbDXyE/XxLk1HW2mNBMb1qLDiyYxhr/Zg0TOYUle/mLNI3OjmGTgmddmUBJAo1VDLrfO4yicAIpK8yc5RxL9gjblQHghgnkwB2tfUkT8/WE6CwTS8r2RcRHGNpk+EtX3bvG4oN/tCHqM9FGgI8bvkppzfmy5P62MS5mQnKp+tiD5fEXACM/Fab6uM19Eic/c+PKyEIn5dI8aQcmtMyhIgY6pTZVtsxKj2Dy2v4T1ckUpY5+90tMGW6NjXVLlKBLBhwEDG0qgjzca+uH3HpO30dYU/5yiUIf+/LtfDc8Ha4smVip2BCyXmHAJ0ODSjmQKYkmi+yduCSAOkPQD7wkTJTsyVpCUoiPYR4KSJCCsxOjDKUJjmtkAI7B3MkJMmM0X9W97kvlEAYVM9Cp03Mct
 XkGCgYuP
 7mTWmMsDrplw468AlnTvXmPtHYahXfoXCqe3v0jDxLhgEeKsM9D9eNGYz323NRp+NdUyrHC5ZYcbI/tl1GD8m3I/KcBt5TfRK1VB3lCtRrnem7yRN49rzzHvx27J/gj5yvzaaNx/yL7arIk9uwbWei0PEFzANJh47/p5MQsT63fLLeZorMcgwnJ5gvc3yP20Mi+53fvSER/ydwdgTV8cC6VOq7I4LqafWbN2jgnF8NG7C88wacYtLZbrUzMPhQ1FzoEmr5TS/NfaYexFNn8f/r3eq3S8kdWvDoDq6yNrFd5ylvSHvL3O8yxagx6MQwfn27v3FATLHRELjJsgZKKxxtWYFSyRkrcyWsru+MWyy3rkB/dY+SLQuDLc+PQiFUj3RrA2Es1MMIlzE4zxjd+i5TSikswNkViHnqQ0kqgQhWEnuth/+Cved7GWk+TWnnhD3mWndSGUjsVRVNDN0S/ohvv9AOLLABTMUrYlSd1ZV4SgZzh2sah9oWCcEUhSDkYYVr0cwOgwkuwQ51/za4gL2Gki9TGmLhClypt3c2l6aTMtks43Cew6dg731KNDrAbThG3udEymS29HExFhGi+ed15LC9izo6cIfy00Sjc73wVSs+ILsSyJpSsbDoUTF0qlokbz92ilBUzw11+dxycDKxiT+pw+BWqM6mSrBTmvKuY95q0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using KVM_SET_MEMORY_ATTRIBUTES2, not specifying flags for the ioctl
implies no guarantees on memory contents.

For KVM_X86_SW_PROTECTED_VM, this mode is implemented by scrambling
contents of converted memory ranges. Add a test to check that the
unspecified conversion mode was handled in KVM by checking the expected
behavior, that existing memory contents are scrambled.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 277b122ec294c..4b2f00afda01c 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -512,6 +512,34 @@ GMEM_CONVERSION_TEST_INIT_SHARED(convert_to_private_does_not_support_zero)
 	TEST_ASSERT_EQ(error_offset, start_offset);
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(convert_mode_unspecified_scrambles)
+{
+	loff_t error_offset = -1ul;
+	int ret;
+
+	test_shared(t, 0, 0, 'A', 'B');
+	ret = __gmem_set_private(t->gmem_fd, 0, nr_pages * page_size,
+				 &error_offset, 0);
+	TEST_ASSERT_EQ(ret, 0);
+	TEST_ASSERT_EQ(error_offset, -1ul);
+
+	/*
+	 * Since the content mode 0 scrambles data in memory, there is
+	 * a small chance that this test will falsely fail when the
+	 * scrambled value matches the initial value.
+	 */
+	run_guest_do_rmw(t->vcpu, 0, 'B', 'C', true);
+
+	ret = __gmem_set_shared(t->gmem_fd, 0, nr_pages * page_size,
+				&error_offset, 0);
+	TEST_ASSERT_EQ(ret, 0);
+	TEST_ASSERT_EQ(error_offset, -1ul);
+
+	/* Same small chance of falsely failing test applies here. */
+	TEST_ASSERT(READ_ONCE(t->mem[0]) != 'C',
+		    "Conversion without specifying mode should scramble memory.");
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


