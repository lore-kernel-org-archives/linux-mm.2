Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFDE10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735C36B0092; Thu, 26 Mar 2026 18:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70CBB6B0095; Thu, 26 Mar 2026 18:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C0F6B0092; Thu, 26 Mar 2026 18:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49AA06B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1660A5BB1A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:33 +0000 (UTC)
X-FDA: 84589644426.10.A1FF688
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B653140009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AP5/yr4p";
	spf=pass (imf09.hostedemail.com: domain of 3HbLFaQsKCOwOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HbLFaQsKCOwOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dl/bsWYJpdZnQGZ2ISOX0kOe5zrNHYK/8ud0vcSuZwg=;
	b=3mtIpQpkHZyRBSzcQOXHmkPMDjGM8qQPrVNHQNj7BH/Fecz1WIEgCjdsWzFylG61yGtG2O
	JyU2kUH5LQ9qqfnWGLyf2fGV0UhICI8bPe9dQKXXcW6nQN3tJLiuYYZ/tHF2tI5L91q+fv
	uxXb6swDM5oNyZQB0M85i+qqvc6YUAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563871; a=rsa-sha256;
	cv=none;
	b=7CdOZAFd/gs9YwsgExltVChMQmOn+pzSZSCeYwxAxsdsZDBC9qjHfRV0+ECaD9y6OzZQkc
	5vTsczsTmeBamXBz7qG49vC3OBTQ7J055KF9BzIM8pbcJB4GaSqU7pNjp6+Us/tEjPzA1C
	jbWtraG7NT6aC0mtiSh8QDCagqMyKH4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AP5/yr4p";
	spf=pass (imf09.hostedemail.com: domain of 3HbLFaQsKCOwOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HbLFaQsKCOwOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82a82f78a20so2864384b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563870; x=1775168670; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dl/bsWYJpdZnQGZ2ISOX0kOe5zrNHYK/8ud0vcSuZwg=;
        b=AP5/yr4pjRR2mvETDMedlvNsFoYJrXTFBTiTZ+49JC+XNU0PxjhlUk3STE31v1/w9P
         C0TrQq0abpjyo+XyMcXyod9GheCnEWV0Of9NN0I55p5swyRxIBXlSA1GZw+W975ir/Fu
         bZaN/diAONdNfvbGRBudyNvXYjOogS4V8ZajL/OuCh/kMfLQ+fxBJbZVt8P6y6CbX/xU
         4jGtQT9oys47oWPGgLm2r5FPHK/PJ/Eb8qvRkQgTia9kJr0pEZ1SPGCMM8whbqQtM9uG
         sn5GkFhlbXV4xI7gx7u7VCydD1JxHkox4EVH4J3ItuPhQkLEHRfHZ6OgWnuJ1gD40SY2
         lYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563870; x=1775168670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dl/bsWYJpdZnQGZ2ISOX0kOe5zrNHYK/8ud0vcSuZwg=;
        b=LZVOZjPjXivP1SRov18EJEOGl1Y454r57fYtjXuQYoP7nJUk6kEFrB4BboMAi+8zq5
         O7Cjy1VrMIQqzaf8/KhVOsPVthC9A9p9XacoIWKNQRvcxDjVZ/hp0upJdnC7VT0TGBAa
         mG2GghxduaE6FhNAXs3VLWwKXRDojibYvI+ACimbqnGl5FKvJ4wbfCE7o2ZSwPReorsg
         8Y46EarXS9kdjh9q7Ed0kFnx0sjkILthugX+ryd6b7CdBWoJw+XZ64e//vLevNeJGmQg
         YEg+GMpBJTpDlSjpHQQOK4Wl6bncVZTEIspztLKOIs6lZ8XZiQs7KNNj4SP+LbHTtEA6
         dr/g==
X-Forwarded-Encrypted: i=1; AJvYcCW7m4ZH+s+nPYt0GiMbpV672zrUQbCKWqVUFk02mIKc1AslBppAsgxGE7KfAtYTR9ret3EEUNt94Q==@kvack.org
X-Gm-Message-State: AOJu0YzwYkQtISptmeo3CuxgEqZxvATOQDQreDDwPv1WSwO7oLgxrH6f
	926n7CTuchoqVgHuEJJdUeTV0QpyVW1brHACEuZwvO16kuuON1qN2XoWMQSvus9QNX+TdFtfHJE
	yR8sbsBRCpl8h5GvyCm1Inal7lA==
X-Received: from pfbg26.prod.google.com ([2002:a05:6a00:ae1a:b0:82c:20b9:f6a6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac89:b0:824:d09b:9126 with SMTP id d2e1a72fcca58-82c95d38df7mr155334b3a.14.1774563869575;
 Thu, 26 Mar 2026 15:24:29 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:12 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1738;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Emrp5cxolz1mmhbaFPRl70Urv1qo5yybaBiy/upVECw=; b=jNlhGG1OFNUmd0OJb2inFZ4ZpQXusBqRlpeNCh3mEZZbGhxSKlauRl1XnPma0bUG0/xPMxb/k
 pNzq1W9TKccDAK5fYnvrlY1CdXcfNoI0wfb8UynYBbRBdZFhi+ZrIzs
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-3-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 03/44] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
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
X-Rspamd-Queue-Id: 3B653140009
X-Stat-Signature: 4x85ohxkpirynztyiozcoxax4fy5p6o8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774563871-237500
X-HE-Meta: U2FsdGVkX1//0tKkvxXR4JMBW6VKlJsVznugKGsyFom5tacIOWrwkG+cgLzT1MUNvS/ALYK3OfVx274ImCbukwy4aiMrDMRxhRnuOYT5K99HQxQ5hhk29X/MV5HMCVrbCQN0b27M6Y2HFCq2BtfIxJ7UXnLOCSctMFs0BWtEROPg+d8lxt+QkjMNebcW3agj+ReEdpdLN2nOrwEqX/rvtDe6Zeyi+8UiI1KKt3i1phe3PeExrRtJNz3vdvPIA25lwHTB9iItaSAcVbIs8q9/g0L2KM70odIBv8xIw1bRSfYZpfYWsh+/sEj4RWoLvm5iiBQGLirsp+TYYRhuY9JFEbEIUMtFUFtnx8V2qpHEZl3vYCF2dKVeZ++p5AdBzps+zELJ8ECXYr3BUJZO0dBjQ8X/edw2bYdYPUfZT9fXMVF8x0BaQxJhkLIWdsWoLd0WYUX+5h3Gteh72KQcROMI7xkxa/pk+ZLWcOWM1jJOklJ8Vva24ZEbZGo74A887zkutoNbOs2YXxyqJUC7fe4v/WUEFErhV/SimbeQrHccKWqsLY/GLSSSzllEFgcKzS0lxmbEdq0uUyvqlrklTwmuGzL/+f2VNxRkaasvn5npHkpZmk6zTj8XC5TFQjA0ztA97Su8hcvFV6Njr3BR+ixZSccOpcC+GnHeDJWyyHxnirtYWcZFyoh13y2lTpzi/U1dhXOMU2KM4ehcR23pDsxAISSoJ/lqmlQujr7tg6svcGJ1LrCzdiXYUGcAM8P/hIN7yYckbouAm46SlWbbR29dhxhKqB9qeuFz/tfO1e43x3H4qY341aQTJBoME8zGjh9l4BG09GULZPbH5ZtY4HFGd0DcLI+tCDobsdqbhBrA27oFbRnAZkTNfg1RtGKQIGOGDWMiLAcHBG3KzQYylx3GMLE0A3Mkvvayyhj0wfG77g/HZJlfsZK/FYRb4aSGBXuVpkfPCbvQl+ZWkJZCWXB
 sFqrJSQj
 aQDltzcIzs7VdKG/r1bdj/ZrGr8azxGRONI/bXHl3jIuqKnafoTdIOUEwvH3/sHl0MhMCfUVjZ2Eg1FyxtLlPx4pLSqS1j1nCIvQ8eBOAPZLDCSyuLvIluRfxDyuvQpFlORGrCIYFWax8LibpfkhtOXNm/STLRErDUt7Q2khUkbUSJ5aTG0R4xz+DR1f3BLNFp1nLji1if7jEX7RC8QLCgK9zqE9zEdyX2OxlfwhqDomtSXXVhWf3sMYT5mZAkouicylw6MccVSpTKS6ETiq8yufZXYvF6MWa4Rctk1mIDOFxMUMuNxVwJUiLHFagY0mmQDuBNJV+REH8SgsSDNi8dWF+8rnCMRhdu6O6hzQlbrohLFpTcuKRdY0t5phZWvu4xbTenilE/q6/uFA3vknM6lL38llJFD0QxOW2+NLff2iy5faW8zeLHYetERDTO/lFmXgh8MRp0GEWNPWExkt8/1drR7h6o6QEgQ7E8eL3uWjZq+S5cOH7kdbtqhsxaYriq/FUEP7QmNd1hUPhX28r+daS1pT3Lvk+Qu+DKeEqjSbNuKc3qTbtqoCKMnAPhMEh+FDbgmB75m0AzkfWcmcFsmCR8UuQRlKnysekFOqkFZ/G4J6uLDXiAMnzjdrWYw4goc5nPMLm0h747X2DlZhioESJAP3NFGvZZHMkDzvxd7LRQ5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of decoupling
kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
guest_memfd support for memory attributes will be unconditional to avoid
yet more macros (all architectures that support guest_memfd are expected to
use per-gmem attributes at some point), at which point enumerating support
KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
supported _somewhere_ would result in KVM over-reporting support on arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e75f7295af5d0..4ba42a1278d5f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -721,7 +721,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 301d7ddac6ba6..793a2c8476b09 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2428,8 +2428,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }

-- 
2.53.0.1018.g2bb0e51243-goog


