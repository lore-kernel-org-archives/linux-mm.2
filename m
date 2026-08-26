Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE5DAC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2993C6B009D; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270216B009E; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EDF56B009F; Wed, 26 Aug 2026 05:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D20D26B009D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D5D91A02F7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:20 +0000 (UTC)
X-FDA: 85142869560.01.35D5192
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id B39CA100003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GN2IxRjX;
	spf=pass (imf14.hostedemail.com: domain of 3V6-OagsKCEwoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3V6-OagsKCEwoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TC3Eeg8HHmJGsEMhcB9JAjXxd+Sjyj6Ja2pFhCLMeNM=;
	b=54H6amCuaV9XNT6Isy5wj8VWtzbYZeq+cs/QhMXY05mFQptmadqzOdfYWmHmQdpqZyZSxS
	Lw3X2oZl8iThWJHh8V+TI5f2tONgoXsfuqx/CbeTrcDk80qZr1ou9giIvBqZ4We8v7fAO8
	9r+9ez0CQRUD1AmyF4h/GbhJfVYTunQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735898;
	b=YIx4oEL0p/+D/kqjIDTOqrju2ujQuhjMwtAlZEXemzM46hecbSr7Tz/8x1FIN3UDZmwOiY
	0xcTuZKN+784r69c5wVtm9IKNSNYeJfY4VrIWhj9jJ6rIzCJTEHgThdYRJZ6i3NQoxG+kU
	pFbvO+dy46bu/bNyPf2KuQ9eX15xCh0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GN2IxRjX;
	spf=pass (imf14.hostedemail.com: domain of 3V6-OagsKCEwoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3V6-OagsKCEwoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d70d8839f0so7442695ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735897; x=1788340697; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TC3Eeg8HHmJGsEMhcB9JAjXxd+Sjyj6Ja2pFhCLMeNM=;
        b=GN2IxRjXUaXAMOKNz21vvrj/NPZTrfby26Jhn/CH/DIYg0VSqKkv/91kTX/+Y8a9Ae
         ypGNH28geC/xwstbN5MZfBUiK8ep8Cdzp7Eoy4Um7DyPRzZ4Clo4c0MCgrc7IaBgTffw
         eY4o4mrJr4grCN0BVxNLdpB3gEM9B7gz4BUoUclLCJfIoKul9maMC1TP8EOliPHUgeb3
         y5KcN6JdYb7lwGw1BzjS0Di/BRidad/CJ+JE75n6jovG1B4GAivydGEbJEP/Mc2216kt
         BAI7HsgQQJdjb/v8Z40iqeexG6oC8r4xwdtPZycBGEtUd7I0T+iPiGei5QR4oA6cp52n
         lZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735897; x=1788340697;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TC3Eeg8HHmJGsEMhcB9JAjXxd+Sjyj6Ja2pFhCLMeNM=;
        b=pzHXmyyEm8vjS2wuQbnHAT9qpEQVMe2wT/8kZaAshpWAnqlt55N7iPyd7dPfizYu8J
         yEjtESG404f4PnRG+bKQeGmWobIJq3CGd40GEUl1E6M2q1bp8DgFxfxyhFHeG+yNSwJu
         ECzd9pegVYezJsbfuBH4LhgGkXsLKlDh99ZoDfmOUsRHXh+zIMU5xIYnvzW/PusHVJ9D
         EdhmBSbQtR1rfg3Evj0eoZVSN8aNr7sQQ/fvV5Up6kA7Z1+9S6jbI5Ah9LIm1ZQUAzNH
         BoZJQ/ZTdJHLslhVX8FlvU5ezcwlS7J0ozKK+IpaNVQC9ZjwvpGNysZqbSBNGSodgrWR
         jpRw==
X-Forwarded-Encrypted: i=1; AHgh+Rq6AAt67HcA7of0sNhKRPvJ/Axu2t2eHhUMxml8QhDfZWfpAl1aHdKdLI35gJCswlRAvXq06wk0Lw==@kvack.org
X-Gm-Message-State: AFuF++lABdizWhLPxP8FD7Rm3FXaqaJ8V1B1On9NegJdbK7SMTro4Hrf
	JxlnbadOcKrPD0JfV72yVPgX11Fgp4fjkyHTmPcQZPhSbCz2uWLLXBiOziNWQQa5y+dtPLxrZw9
	ewLKEQOzwF1hhhDWjN3ohEsAcKg==
X-Received: from plgd8.prod.google.com ([2002:a17:902:cec8:b0:2cc:c554:a93e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f549:b0:2ca:481:de45 with SMTP id d9443c01a7336-2d707a501e5mr66214505ad.6.1787735895566;
 Wed, 26 Aug 2026 02:18:15 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:03 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2388;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ogSExkBJJQ0shJgqMiTFGyZ7TdxK9ZVCrr3NofP4mmE=; b=1VX8N8uXNhbB64TEP35V6sDoTKXKwmyT3n8b5as3eYzSda3HxQRMrx3iH9t7mWRMGk60IOhnx
 3126PLKu+/IAhStJ/lCMVD5ke3zv0gqVMqqbPje0NlXfe+BE1kamZ5b
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-5-0a15d8a799aa@google.com>
Subject: [PATCH v11 05/46] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: ewzgekncb7oxc6ih4zjfi3zwdmijeek7
X-Rspamd-Queue-Id: B39CA100003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787735898-422278
X-HE-Meta: U2FsdGVkX1/9fno8PoQsjC9B+hSYKU4YA+6j6mBAFod4WpVNopWQY5ItCLBv3cFpeb10/MiXc0v2MeIbKABn+UUi3Hz8DAnAIpcPfYNx940J4c+gvwin++T655uNLaXooFvf/uffitMekBinYox+jpVj0V0A++mTndfIjsovq4/1Jf+XIKHR2l6HcrwRnDssgiPsRiXWG1/WIuSeE1KGrC2ri68QZ6TgHH9OmYoePI4l5sW0mTcz8wKSmFcsu/3nGJvx0uVzJQbojRCBL7EfLYCIlx4ZATF3lTWR4+x+qSd50foyguEaWM0FHb6qcpvap6zemWo09CTkhVXqsi8S8flel1f5piYEs8yBHk0oB4UepMEuiIjBMlPXL3dmlOSHLkZNqhVUSCj72o6fUZxmIHQRqzJDQAR0fLduR2AyYLg6+c+EzzTdffB9xBsygnQ/WYECOOfy4f4cIvOG4DJF/CbhgEOtskqC2r6hRwmXJXVPnReQ+mwLdB00GmpcntBtUALlM9ZgyHiHpIQkGdeekksmuyiCMbufWyBZZb4kWU6d/MS7xEUO2/V0EKgSkI/WAq9ggOgjdu0uuB0e3FwxMuDw2JpbBBR3dJFUv0VBwmsT0dMCVDv2C1RkAr8Kj9cxca8D+In2ZiNdu+BT+TE/Sac4sZop/iKhnPks7WeFILwzPAOut2iDB7R3wYbDxwOJeQWi8ge4ZilKgReWS1+XlQnUO5b+Uiv+vRpLmetxFYaVbPXsyl3Wj7Fc1OsPOAnsmDPoToeiz4QBW1I2lpJ2CH9OoXzz+LsUi2UpVdkWsVlvg1Vh8MM2Sy1QCTKhoBdibfNG5D5N1oZOWJMmIm9+XLxAddZETGtzINHrLwTDgrTb3GC5ukDfPdF25+VN+Jq6BXbssFCNiZ3W1IKyp5z4I3vx7IVFYBnOHLCKfmHNNfYz5u9R7fDkklMDwEIztsfLMyyVa1cvnjNOtQpgoEV
 b1S60U2B
 htPml6BD4GFNpz5dq37ebQdZU9SQQnSWHO++YowRESh8YDIWmbGYIIej1U0XVVzTg4L1Z4DDhtRzhkt+pkTLka8W727RWZ38GdkS2q38R5l1oy16vXsMcMuzrUquPVSbgR0qpG/Rd7msbfXFEA7uLKBWhiwbk3DCNIMxyRjA40uSEsrhyx5CkBjFpMbPf0sn+YMN80drdQ2G5kGGOcFhDsvOZRQAMNsghxwPbyrefV2SiqnyJo9VeYl03IKAF4dWrPIiTd+EtyrZzTIhidRmjWFKzjxlUOLL9EVVhi1UHCBX2JVB9ZRYGHlk04ffyEYQa58WgMAyp8YrAGde+L9FKc7LpfzZEooxwZA8WD2QaDhlKDyLxbNLhFlqFfcHoUqSeAw+xhJL6/pK7vtjJos2LArg00wLoVdKAlxRQrr4rCgtTkB7UDdQhOMxkk4SuWZybqervGCLYJmcEA+OVun0GvRp/wCZOwgLQDfdMVeGYtwvF38L28spj9jdLtVPB0RQLO+91s3u6d7V9kOYblY2uyWZe9kb/1vlPrf39wvkMLk4iAg855zBL5z0egr1MXQwtRfaeRD4C7vsbF6eUH74eIQYZAXAoyZ8DcpYWVdHGpjdsWEvhvg+o1am7FWJPnjzRhZbarN1MXdJ8NyVKc2Ol6UpvfL2PBBnCeJ2XK1dy8I17gGAEJEQE38dzM22P0ks8vAyVbuaJ8AaCzpdmuN3/x42mXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of tracking
PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
conversion).

guest_memfd support for memory attributes is expected to be unconditional
to avoid yet more macros (all architectures that support guest_memfd are
expected to use per-gmem attributes at some point), at which point
enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
attributes being supported by KVM at-large would result in a system-scope
check (NULL @kvm) over-reporting support on arm64.

Give architectures full control over overriding the default definition of
kvm_arch_has_private_mem() by removing the coupling with
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

In a later patch, kvm_arch_has_private_mem() will be defined based on
whether architectural features are compiled in, and made orthogonal to
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cffa16647f2ab..b45fb80b0aca0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7d5325e3cb44b..050757544a1cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2422,8 +2422,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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
2.55.0.887.g758fc8c411-goog


