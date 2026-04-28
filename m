Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1AFFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922616B010E; Tue, 28 Apr 2026 19:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA006B0113; Tue, 28 Apr 2026 19:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FFB6B0114; Tue, 28 Apr 2026 19:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7FF6B010E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:42:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E7191A1298
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:37 +0000 (UTC)
X-FDA: 84709568874.30.79384C0
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 21BDD140004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Cnc/NS5r";
	spf=pass (imf23.hostedemail.com: domain of 3zUPxaQsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zUPxaQsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JdDnj6qR6N2qFPR2vghpCWrCloc8FcwG1Yf0aZJlDY=;
	b=In6aTjDN/iFO3dP6Yzo+qA8cdDVtkZdqH+xjmXfz9MFI1STnN4AWT7pntZkYP4RnADE0Ya
	qmYNxPTmfeVManAB9dFGrbhia4RtedrhcIqpG+7ivMryuvj/sZ7Z/su8TXANZdUQkKeEQo
	Xr6nqk7E493apC/tHueQX2sbGEYLUmM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Cnc/NS5r";
	spf=pass (imf23.hostedemail.com: domain of 3zUPxaQsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zUPxaQsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419215; a=rsa-sha256;
	cv=none;
	b=nVjlO63C5su5RhWwBHq7YMFcCvHfqLQAvoUikU+DYBq30bKJ/GTspd9wTVdJ7901y0Ye0m
	IrSKKtC6VfkDcEfYpuUQIjtMY7prmSpMchP5n3MSvkzvIjZ6clWsSoNop7BOka1ITjfLVP
	5tPDyJ/lE86DK6KLrDdR/t3JPA4LBYs=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fa2165c3eso7558402b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419214; x=1778024014; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JdDnj6qR6N2qFPR2vghpCWrCloc8FcwG1Yf0aZJlDY=;
        b=Cnc/NS5ruILpcvpCOVs/oB+57f4dXzNZCoz0fx9umHd15MR6k6Kv79l6HGoFAcyuF5
         +2SGyclXThvUEfd9w59WyDUddpur6NoHDqO2LmXetdArx9slTBeQgCePdsVJeoJkA0Rl
         qE7U/v8s0t/w0ioe5tGSf3FK0HVpGszBN5UY4xBfK0AePKr4dd8SoO8YvXHQH1/snjeq
         MggyXGlL0iOgEFzJUzlmukNgc/NhcIhr6BcMX7xJk4V7p4gAq4KDOOTPZ6oNPcNJqUyO
         EaN/Ir2vCsOlEuID5umsLBTwubWqoY7B0n+4GecbnBxPwvCrlzqiwJ63CtAChmV6fR9x
         44iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419214; x=1778024014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3JdDnj6qR6N2qFPR2vghpCWrCloc8FcwG1Yf0aZJlDY=;
        b=TM4YtsrdtOZYJY+8W3KIkycDcbXxOt/cLeOUiIDD0gDtR9Yl2N04bdXWp+a6M8GwEN
         blYY0uWrXHkOUkQ35Wdmoa62KX8Dc/C16mQ/geoz2cDIMtggZ6yfyJL8Bm4gm0Kex1mm
         jECW3HdbsN3nQlnv57UVHxMkXehDeuirXYH6zfQhTfzV2icUziLruPudxTYRuQPYgT5C
         AheJQ9dsImRchpin/I0N1X8N7JAkj2km/7WIP2NCEVsCyK/7LYhJsgEkZh+PXWNmWBlR
         ODNb+fXwLVCnjE+/7Ph1GtrW+quH3g/4V8aNREdDpbdb3mkkFsau9pSzLSpSYgTczYjH
         BPkA==
X-Forwarded-Encrypted: i=1; AFNElJ/FkhvtSv1YZqNc+mwy456P/OnuTEayIfOgIa6NQ+Zf73/1TAz+4hbQ2AdiBEyzUX8AVAYynbQgJQ==@kvack.org
X-Gm-Message-State: AOJu0YwPuA+nbMdzw2ugbkuY9Q+UDeYMMPxJAdyXe7Z50vPRO4/qnVg9
	2OKb9XAfVosfa/qIcg7MhA+J78KZa2nVkgWxlhmHJxiEGoa3yX25mSFwMtdl830TalT/hJUpLDo
	GNJHBIXyIxI2IsadCj78xNkSLqg==
X-Received: from pfbkh40.prod.google.com ([2002:a05:6a00:9468:b0:82f:ac74:4db5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:84b:b0:82a:5ef0:210b with SMTP id d2e1a72fcca58-834ddaec17emr5534199b3a.15.1777419213403;
 Tue, 28 Apr 2026 16:33:33 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:24 -0700
In-Reply-To: <cover.1777418884.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <cover.1777418884.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <a8c4b7958bf1d8667338b816409fd02dbee11174.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 4/6] KVM: selftests: Allow specifying CoCo-privateness
 while mapping a page
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
X-Stat-Signature: 1noytcztikka4wuxuughupjkwp44y6qj
X-Rspamd-Queue-Id: 21BDD140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777419214-114736
X-HE-Meta: U2FsdGVkX19IIlq6vdeMt6G7ZK3dG9mReewIPPZWccDOlbXWmPGIuu3AWJlduLyr8HSQm9lVU/6oz2KhwNJ9ekMjYt3Z6f85yr8GhOtZAJP5vsUkbEzMPYrXdaTQ1nbPWl+9KFLVjjGXEH9oxEU15ggn2xmWkNBWqeCP1rjkbESjEKfGrLbxVy4q7xzCwPusN0IqgMx4dqEa+8lygrYXl1jT25cyURSmEd/O8gTIZNPcMi3piJtIKVFDqe5N6/X28VQMH0CQzfYukwoIMORPZNYxvX4Q+Zs3tkh7hUTZkHHAkqrHi0Jp/zN2ikccAK1qTEvOXiSM25qPL/fLCZg/tRyJUfdfKO2cUcg2Rp+AGHHx7s2XXuxZycCOMPa8CEd3jQkGAUMtsTqscUgzBeSq/QWqLQMJYQ7nLJsNNDf8rYj/jE0jrKq/wcd/6yzWryR3KB/UTTgM2f4FF140oTwcOK3aDBHzGiUxTwDC+YFxCSh34zz0BChmY+ud56oYrCZnY9kFPB9p4cftBsWcHBEFk3iDC626iHi5lsr/r1z76CZCRhRmzNFNDHfWN0zjHQoVEUnW53aojgWq/qVpqzuvy9ERYnMqVgPfj/ColVzrgesuQMQmGRVHopk6l3HL8xh2boD8I4t4av6etmYyDPBmdwF/MJRF59AwRe5wX5UBkOLth54k7XJqlDQGdOALZCbfNheWF9Ppa42BzXhiPpYlxYq9PS831NJSCh2Umq2PuJkOIZYzMLLry+Xn0L5yC1j8zgakO1WvZjw/13gBHBI8n80J2D/f11kl5dukVBGJSyMNIc7I3mXSlXnBNuUir1DzWfDkX2PNTDQPxtfgo3Im0R3GK0iJ8/fPqmBRtF9hul9CuZKHlOzZdXVLM050KAsRv3IecStYs9U3vhzkR426c7f3kajPbNGMkSvdmiK34Se0RVXgadQ1jNq0gk+Ds/rV+++MXhtSWPX0Moi7vRu
 QvMqHVae
 ZqzrKaLf/+nz8kXStgS2uwwilS0r28ZiwBLmN6c/XYv4TrVhtPn9itZQU5lR6CbdJsLVMiWK70yOmCEm7aJsKwnSw2m5zqUp2fyprD8km9WgQj6qiYNNhGRbV/Zxt4MaTIDnLBuO57rLlSEsL4ns2mQwfaWoqNrz7QanwUURph27dRKGejwr4Y6dX341a/N4bNL1ve6zFaj9xHFxRpbPDxmQ605rTVQ40Sls7uCmFMnMK/L6/bbO47ICqjkOed+M+7bSJLYeLUQWjVGg85dJ/RFnt/9NOYrN7NNYN9m6ZfJfYTi+qzzQdSQvyIoGYpendD0cop3DwRuVjLuqQl/sNJV/ucEFGAgVtR3Xng+SBkEabalILKgwqKuZweRubC9dKkGhxWHMAboE0Goeq+eWobjzj1umSqCHHAXo5smBU8iMoX44BIScsqSQsFaU35iGGsuce+Rxrk9sSXiDTM/VYPJZLhtvsjaAleaMQ5PZzvtSlSW0TbtR2r1e7LH6jpgzx24qpvy7quCr7wRz27t9eST9YDnCUoYjbd4ioQRE16m3RuqHaneTZxYpy7zd2OIO6YQGjZ2BjdtN1abtHB3fj/KWmdti30FFX6+YgQ/g9UfhD7SBQcyesDsh4mxRwVQ2LHMldm5BE+t2Qb46Hs4a9mVR5Nv/QfF45yjrT8OSMqt1jO42G8qH80v5NFts58tOYZBUHhlWa1j0mN7Ts0xd1Md3+f7YrGqmz3idNQoOKOEHIwj+4IySBkNo3d7RvSleU0kcMtbRTXkKEMns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 77f576ee7789d..683f21452db58 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1507,6 +1507,8 @@ enum pg_level {
 void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
 		  struct pte_masks *pte_masks);
 
+void ___virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
+		    gpa_t gpa,  int level, bool private);
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 		   gpa_t gpa,  int level);
 void virt_map_level(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b51467d70f6e7..02781194f51a2 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -256,8 +256,8 @@ static u64 *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
-		   gpa_t gpa, int level)
+void ___virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
+		    gpa_t gpa, int level, bool private)
 {
 	const u64 pg_size = PG_LEVEL_SIZE(level);
 	u64 *pte = &mmu->pgd;
@@ -309,12 +309,19 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 	 * Neither SEV nor TDX supports shared page tables, so only the final
 	 * leaf PTE needs manually set the C/S-bit.
 	 */
-	if (vm_is_gpa_protected(vm, gpa))
+	if (private)
 		*pte |= PTE_C_BIT_MASK(mmu);
 	else
 		*pte |= PTE_S_BIT_MASK(mmu);
 }
 
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
+		   gpa_t gpa, int level)
+{
+	___virt_pg_map(vm, mmu, gva, gpa, level,
+		       vm_is_gpa_protected(vm, gpa));
+}
+
 void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
 	__virt_pg_map(vm, &vm->mmu, gva, gpa, PG_LEVEL_4K);
-- 
2.54.0.545.g6539524ca2-goog


