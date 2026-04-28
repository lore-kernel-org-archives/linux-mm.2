Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBF3FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0446B00C2; Tue, 28 Apr 2026 19:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8066B00C3; Tue, 28 Apr 2026 19:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7516B00D2; Tue, 28 Apr 2026 19:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79A3F6B00C2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:39:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1422C121013
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:35 +0000 (UTC)
X-FDA: 84709568790.13.DACEE81
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34A541C0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mxzxDcMH;
	spf=pass (imf21.hostedemail.com: domain of 3y0PxaQsKCG4MOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3y0PxaQsKCG4MOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKlqfvGeioYCy/1YHyXYlqGH92j3/mbwl8rUOBF5k84=;
	b=T1kttlfIli6Cr35whDJSHepbv9ohd+N9cQMqCWt8oLxyeIIHl++XMZO5JbiFNzYkzu7v92
	a8utjJcFjowLCyKh4CIU0Gqpd67C0FBIN2QQ6h/YsHttWN5TQLCH+SPC8Hc5/9HjHct2WG
	fLRJVyoZ7+o2mNyivwf1icIbTqUZkBA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mxzxDcMH;
	spf=pass (imf21.hostedemail.com: domain of 3y0PxaQsKCG4MOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3y0PxaQsKCG4MOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419213; a=rsa-sha256;
	cv=none;
	b=yLe6b6UvYzpgp5KWMooYPf881NORKs7IYo5JAmUf+ALh0DtYT54sMKes6alRv0ehen9os8
	bH91TJqsAJen3KOqS0Lzz3ratbSmgFiSHeZEORVW50TWpNOKKnVzldHTyc2S1t0AoQPHS4
	kiUbnwvKu6KCz72HaRvqtMhEePU8lBY=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6097ca315bso18173998a12.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419212; x=1778024012; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OKlqfvGeioYCy/1YHyXYlqGH92j3/mbwl8rUOBF5k84=;
        b=mxzxDcMHFfuyVtO8DEfo9m5MdEidLVvuQDHFZnhuqYQuCoyTxsEa45XAasPbIA3Clz
         29av+MCJGjMNIuw8hMgxkhixvBEDOWK/ncSNC7glI0KsZt7us7oC4j3PNMGbHp6/PRxl
         dBUwm5QNsYu0ov5lJixpFsZirBFfyzNTA0bM177bTO44rud5GT1d+DMXnEf1O0oV4QE7
         IGRRkhqc2S5RNasfZ4IYCUCeQnd+Ttb8nV+Qb/NkwB/B7fVM/NxwZ6sOy8q1Dk63IVXq
         ct32qNf+qLW6JUrJSsvSvw/BE9XdOW1uarNt6KMk8Nzuyn134voieyJ+L5wUrj62/1RN
         9o0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419212; x=1778024012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKlqfvGeioYCy/1YHyXYlqGH92j3/mbwl8rUOBF5k84=;
        b=gsDsiQsNDhRL7wZ3zgdeWgGlWFezO59P+oRivzaHXFaJuVjGZXtNFU/W/NmJ29H9MU
         aIdcW5RT2xliermygyMEpS/22igEQibXkdz6Z4t0wriUb7QhYX0ej6t8X1rhV4P+z8/B
         vRh7p6lXORRXun7RSG3MFG1zmdHgf6KtX5iJu0JNd5IyG98pflZQOBcMv8jIAcOaUYa5
         cIfmafk5A3ZtgPD7C1sK1TY22WNO48njjhgyJspanQCBFncgCMaVh4jLKaMCW4tuMdOK
         4BaIviyedCg++yu/CIUgttChmrdERBaCzMW7iRXc6ukGpsjSKVZZN60TmPRN+NM+RlNo
         yY7A==
X-Forwarded-Encrypted: i=1; AFNElJ+qdFxay+IYoRLWldJjmD/9BpRQ35jvFisKw7hIMv/Qm//HNQLCcpPrJg7efoutVE9IZjlv11bveg==@kvack.org
X-Gm-Message-State: AOJu0YxGXmAb75vMF/2OfFmjd4H1ufEBKqL09q+g+FKpTuH18+ueU/wD
	PsW/NbwoHLFTZSxy5+dHyl+UYOiUF8KUyMxTWw2JMcbS3Sb+IB+8S0/GAZ14NGZuwJtT/CzZ6c1
	+bNE8zEYR6gD/ELugL2rRagNPXA==
X-Received: from pfwp18.prod.google.com ([2002:a05:6a00:26d2:b0:82f:61ed:8b2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4487:b0:82f:77c9:a89f with SMTP id d2e1a72fcca58-834ddc57adfmr5463785b3a.37.1777419211701;
 Tue, 28 Apr 2026 16:33:31 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:22 -0700
In-Reply-To: <cover.1777418884.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <cover.1777418884.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <bfbf372d037a77504563fc6e1f25306fdaf1f48a.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 2/6] KVM: selftests: Use guest_memfd memory contents
 in-place for SNP launch update
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
X-Stat-Signature: naaeon8fy8xc78b9q813ktujusfwc5wx
X-Rspamd-Queue-Id: 34A541C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777419212-269104
X-HE-Meta: U2FsdGVkX1+PkUpUxZH1YJXLjcxOu4dH9A5MEnJbnjoWFiuj0DC53oyNb1Riwkcp4lRnmA6qImqO+xNjzxwrNadVcxsgpTaiw/v9eF7agoDP+WHAR5emQaxKKvk/EFniW674facKiOfjkROg+7y3fezSoQ4GsERkqwkvN9GmAMRCqhyCYDjStjhxZveTbsHNqhrpsIpA9uYAiUsiEMxPPUjkjKy5XUnM/Ghr+4gq9OxFITei0Slwfpknnvg2FbHkb+L1GQielKHGsiOWjqlRvwzoa47y3tvvCyqjkyI4gLDRoDg/4DwlfB9SOoPV4f4XujSgCIwZZBqFQISrb2ZCB7UYfGRtv+aknIizdBVxkaQjnS7pe8QtFzsIfFaWmED3jOAQOm67X1EF4RTTJNuZZGvRSthVt0kgTIaFXXJRanoKUbynveITgwy9tROUMrvG5z12RkRDobgvObqvGsIBrnbC2Kq+dk+wawqShcuQ+qeSncE4vL1yO2CpH9fHf6jAsd2i4aI9+crRWhyEOZVx9zn3Sri4AZnkJu7N/oJJLLvCGiAdd3q/3jQR1U0REOw/qIL/EOkSpxTIqkV6FQglnriTit7N8Qs5GI45X72PmbRjaxp6Aq9njQ8PNX8tyKD7xVL5qIr+R6s4ImPxFnfivm0tp2ZtqmVnTMl4SvDMpNkQcHjay59rwNef2wI1HGTCUwRu7jT0Gkz7qrlml/OcKPio3zo2IvGc+F3+8JQVd6Xnj3qeK5WGSPaSJuWk38bV/hVoFDigHD2xEkZrvUTneDQdymq92+aernaqr0q7kIeKxBFnG0MaIRkT8DAgzqj3TBuTdez74itgsVde+rzP90cHWYGV4+BM4m1nwAurTKwAMljxBT3Kvgf9SZcxWDV2kpbvGi4CXpNFceKM3XsyM2M6ZSIjIgSmd46ACp6UucxTIvkICgfFYHtXtbr7n1+G06+FYPA0i36KBOYWbM8
 KwqbK9AV
 b29GIvOtsuuD//L000Wr9TTP0gheJBK+8BEzPCAG1W3sxpMyA6jzRNNc0bNFrfjgJZ8mg3tVo2UsKJLc+L1JFV1g+PM9E3OCDEjZS9llGxr/MPcOUOgu1Z4hVy1VDRx4x3Yvev13DRs9SUTVGql9awYTboKOCMwV/FEyhn3R76Dn/bQi/HfzpF4VtgmEX/SkRvM/LLJhiXS+XU1phuU7daMIYBOWLwOZLn1AgCncHaettGj5UePWC86JqPy9Xo3wxux7R81a5pWTxFzdcUBLNxBXzuj9VDEGVMgOO7UnUshdgUHk3essH5kJntUUqYj7kz85uzPdKrkG0hQiAYIdvCEBLg5oI+pWdLzBwqps0Uw39XS/cNVtDEC6tKL329i9Hc7zcweWBwQePpK8HrjF7oQx6NdGVTLDnBmgvHz299IUNPFqhZOGnwybB8SDzMVQeWL3IieZcywK+spT1a0MT9r03kP6aBR0xwQ+Cimw3gUWhxtw5Hmf3qmIkdSexqS4atyuillkD9eV8hCULlhN9xgAsRwAWKbimPhXDHbB5cTv+AMrDiOFLJcslAplcFSy96V4s90tk171BloUEdqYV368l9YVa4vmHInXWjKT284w/iR3eplvHQWZnf4EmSUnfLvkI2uKHeq6Nagcsw0eg+Q8DS5vT0j0DOxcoAgi0G0/Ths4sqCGA9CBrWzUnA/5YS+Imz17MeErkpZ+g66NfKEl+5V1L50to2tZ18FHSRJs7hSOLqqEyc9Nzxbc2ry6NQ7Xp8bk/65qY7kgtDjUUG3M8aMQeZRrAXUE85X8O/8/iHaEra+rA6PrY+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the SEV-SNP launch update flow to utilize guest_memfd in-place
conversion.

Include the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE flag when setting memory
attributes to private. This is permitted before the SNP VM is finalized.

In snp_launch_update_data, pass 0 as the host virtual address. This
instructs the kernel to perform the launch update using the guest_memfd
backing the guest physical address rather than a userspace-provided
buffer.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/x86/sev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index d0205b3299e0b..72b2935871fe4 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -32,13 +32,14 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 		const u64 size = (j - i + 1) * vm->page_size;
 		const u64 offset = (i - lowest_page_in_region) * vm->page_size;
 
-		if (private)
-			vm_mem_set_private(vm, gpa_base + offset, size, 0);
+		if (private) {
+			vm_mem_set_private(vm, gpa_base + offset, size,
+					   KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
+		}
 
 		if (is_sev_snp_vm(vm))
 			snp_launch_update_data(vm, gpa_base + offset,
-					       (u64)addr_gpa2hva(vm, gpa_base + offset),
-					       size, page_type);
+					       0, size, page_type);
 		else
 			sev_launch_update_data(vm, gpa_base + offset, size);
 
-- 
2.54.0.545.g6539524ca2-goog


