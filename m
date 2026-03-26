Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A680910AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F01F6B00A7; Thu, 26 Mar 2026 18:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1256B00A8; Thu, 26 Mar 2026 18:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D866B00A9; Thu, 26 Mar 2026 18:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D9DF06B00A7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF293E13E4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:02 +0000 (UTC)
X-FDA: 84589645644.18.37DDF72
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id B1D741C000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=McFSBPqB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3O7LFaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3O7LFaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ammt0BhOIyLXS2ULMUn5WewBTpBTKqlX10HzkZ/Adsk=;
	b=2o4v/JIy/s1QafSFglgKtu1DDCxn5Hgz+DsS3+Y6CwmIdvp7Wsy05xyfkwMnZGDTGPN73+
	RGXtK6TfhJ98W0kHS/Q5FLlO9bOTrn0+5IgMxohIABrtCOuQ22r1ilAeS+dbcxwK/4SGFO
	GuK3SOR71v314/jhK+Y8K+gDEFV82P4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563900; a=rsa-sha256;
	cv=none;
	b=bO+iO8HD47bzRzPkqXsoktT1Wu4eSHIAZTihay/4J5EnrOxLdW7rVSkA+UZ+BHzGxN3zt/
	YD7pFJoZGfDzzawwAHCGvRN89AmxOioHybn37S8ifsYkn5nOHZoqo7K0QTsnscorjk+wFy
	63k60B5D9IV6kWANzBeIJXFb4snFR94=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=McFSBPqB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3O7LFaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3O7LFaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c8768a633so1553537b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563899; x=1775168699; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ammt0BhOIyLXS2ULMUn5WewBTpBTKqlX10HzkZ/Adsk=;
        b=McFSBPqBMy9PptRXE5wkanLs2UgsVIyK8s3S6N1vfT8URWHe2lonj8dZpfPmyVs5Up
         WWa9r6L9Gt3Ltzqpf9WakKTbbSzHkpvzdmpoGqkTm6ebqNmSjKz8gNY3TydTwRX5zh3c
         4KrJnulG/cj9wyH+qTUgknQnUGvG1EY38snLmeE7h879MRzqKeYWC2mvkFrijQ6b+VPD
         6QyjwQ08ZGfVzO2RAtTtIDWupZ7rvCnBIQ7AGD78WEP2QFVQ+7+LHZrsl4/L46gnCm/n
         kXgwanzpdGVUvXtnNgNCNLkFZwxLN+9yf9FsI6JuG4gyyK4SRbB7By++R9Yd0+ds/OJT
         lhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563899; x=1775168699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ammt0BhOIyLXS2ULMUn5WewBTpBTKqlX10HzkZ/Adsk=;
        b=pmjmUFP4VKLSfH53/xIR057Z9r1Oyn3ox2M74INoXmhb4pbrRzNsFgHjK+uopTa+a4
         pmK3lKcpArTCrIl7il40tx50HETfkxYJ1VncVjzS7UEAZXLuM40I4YKu+8GYznRfvkmH
         E/gtf7UjfSlQvGLv06PJpMU33seqNWBHEBIlpkuhDlXi7YF9WlLfiN40UTVFQeVv8Hjj
         g+iXC4iXWmVjzmOv6m6tkpmerT9AgLKwMJaOGFF0HmKD/Xvag4eGJk5jCJIgkVmdwm6s
         otrgTBEA8kczyKXUlL1uIcjsv4yM5ct2np+T0cI+CKAYYvrHqAuV0HGatf7YMByVg3Ya
         LjkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjudHy8QHs7ytaBKV7Mwawg0WRtv+Cocspp8SAJN501x+hUU1KrOJ7so82mldUeiGZZb+0WwN68g==@kvack.org
X-Gm-Message-State: AOJu0YxR3sF8wvZO8Hkhmaa7bJufYyDUBuHuSgMItbRbpgFO+MMjJi3T
	8Fxu2l4wBEO/7mYEucOn8yfSFcXT6+ovJqNX+d80bWbjmoFcSBPt6WGBQmMnN85Fs6HdmDFQMzr
	3IUauzwHFta04EVVdhmDTH2EknA==
X-Received: from pfblh10.prod.google.com ([2002:a05:6a00:710a:b0:827:1713:6de8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:909e:b0:829:86a5:d30a with SMTP id d2e1a72fcca58-82c95d3979fmr158458b3a.16.1774563899156;
 Thu, 26 Mar 2026 15:24:59 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:26 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2856;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YkFqhRwEQZVyHiDJUj6H4E4tU4Wvsdzaj7skS/qkZuE=; b=fYqOIs0iI3/nAEboIQ/PrkKD3DqiKgh0ZKOH0/alwG+ByCa4bQDdDE7B7eewnHx+Vkr5yyN3L
 qYWooCrUe9JDhY0cerupGdZo3deYAs2/zlmrWXsG3XBYe8lS1/Lli9y
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-17-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 17/44] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
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
X-Rspamd-Queue-Id: B1D741C000A
X-Stat-Signature: win8do184jopjyuo3knxmuaduisjajra
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774563900-985233
X-HE-Meta: U2FsdGVkX1+zR/HKQzLWXlJSoPCmVWwaSWIbGo580g3gpN8+OTwoCJcBdbArGisUTZRsd6TafHVrjLpQi3QWWTOK1Y1K2QJ8IHSBe7LmEP5q3PdOC6UdZeaP0jrXAbm6UIoPENNCcGL1R/868skCVHmaKwTKxA0Sd4khD8YMx2ngCBcVcoG/eQXVAIwdwQn56/nnBikVaMK7eht+y/6Er1dZ4R7L51i9ne0XONaN+3JJQeakMIBGehMKO/JzFTE4wrZzZ1gvKz4yI7iRwi/cQ+BSYRLdTCbo4ot6MAjcnPhFtNQ72fqFR4ziGXin4cUaf1nw90nTQkrMwGYC1x0qOUMCUZB0jJggO3s2hHn+TrneU4Qa9jc/kK0BWBM8maQJbjX/uWyrxm+Lrlc/qYPipkkT+v0pR83SWwxbRJd9plE1mH9CSQY8ysErJ+T0caWxJh2wsEruJi2Z5IhC3VTMbxiISWiy9Hs95JAXrhTLqMmt/FbyU3WjYV6jnZST/tlVEATEC8qXhmHTFPtGNr/QqfHnVoXJBYApq7bFt/4flisY8bhhkhsCo9fRR9LNJpYncKYYWFhVYHn99leIeOxqmWO/cNkFUzz/BERhq2zVEb/K3oe9Rw1IOKBfXbEI2BC0W3c6oUnZ9pRYJPfDNGGYzfGvM9b8uy1KBC1D0LjpbzJu3pigKcvw2CveMn2EvLnVPNpVxq1TAi9P5c5xpxX3BxV9vqyprieplLmXrJxhUTidRDn3A8ffQzSZXAnEwCOndsH+WuzyhTMC0xyMz7gjfu/jwe+8hQGuskYhz5hNmDE3qI4Ra4o/JnAlOUCBQ8DibI+wY19PTpPq86q5gXvNxSnWLXk/vbGoXn4Wm3y1h3tBFMTpydOMVHew6b8CxTvXQtllNS0W8LFsaPRQ3ak/FSZeUjyWOvNsDoQWOYNP5/XezslvirJ9T7CevQr7lIxvOG1T1442JNLShvbbPL1
 CfjxE85V
 bpOwszinMXdXnPVbv0BRAb8LDwp6CjeKS1hMdD7RAOQRC72ntlEX7pEijAJKmLS+wMA75J6APOCAWXIxIFHMnU8GKytUt74zRZPzagxd6ocIFaBI5Fpdl03qDjvA6ohZBOJ0gwpO9PnFiyN6zazefAIiYMDyvNamKS2FJ028d+u75EUtl3EV/RXwcPSDilb8BAdvqsW1ceIwgBcTcIKp2L/oDcZW+IVLLY2fnoQzBY2D49U/QhpyP4A85XpxIIzNpPQ2JPgr1ViqjUdYBdHqumETTjvbr7vfcqbnBRNQ16hnLEnSs+oEQjkKVanjuyosvaN7AAEc7FIrFIlwGlrhmSKfdDZwC6Lhx7Wx67T1Guy1R8URiPDmyXMurw0E9Ztj7MbSAiQH3PTEV4DkDdwmxG3z/wrurswWcW+j6a19ZF0Xw0irnOt2oSSWrtdN4ksMC5YmoWnasUV5L9dW3ugMdGbfQpClQFmC5iyFsUjtN8J8+0y8ry3xTBvCb0JCl3UiuOQyMDdNFIZnePbCPdgUazkymYCxJ5JVZ0l1QvEHK+ZruPWvppxVkUAoOrWMcpZij3fo6qC4Dh/2+p1GBWT4fcM9XOW2wHZERpn5vajP3h3jTm40mrOVSOktvzdSD0WmXab47MNj2go9KKeY/U9TKUbAMamTKItyQUlm8DDdn1cmrI2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Make vm_memory_attributes a module parameter so that userspace can disable
the use of memory attributes on the VM level.

To avoid inconsistencies in the way memory attributes are tracked in KVM
and guest_memfd, the vm_memory_attributes module_param is made
read-only (0444).

Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
that might use vm_memory_attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 13 +++++++++----
 virt/kvm/kvm_main.c  |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b6d65ee664d0f..8b97d341bd33f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -82,13 +82,20 @@ config KVM_WERROR
 
 config KVM_VM_MEMORY_ATTRIBUTES
 	select KVM_MEMORY_ATTRIBUTES
-	bool
+	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
+	bool "Enable per-VM memory attributes (for CoCo VMs)"
+	help
+	  Enable support for per-VM memory attributes, which are deprecated in
+	  favor of tracking memory attributes in guest_memfd.  Select this if
+	  you need to run CoCo VMs using a VMM that doesn't support guest_memfd
+	  memory attributes.
+
+	  If unsure, say N.
 
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_VM_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -139,7 +146,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -163,7 +169,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6607127eaaeed..05e203f5292be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -105,6 +105,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 bool vm_memory_attributes = true;
+module_param(vm_memory_attributes, bool, 0444);
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));

-- 
2.53.0.1018.g2bb0e51243-goog


