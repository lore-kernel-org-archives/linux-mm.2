Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDB010AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0836B0095; Thu, 26 Mar 2026 18:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8E16B0096; Thu, 26 Mar 2026 18:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD7F6B0098; Thu, 26 Mar 2026 18:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0186B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6148A5BB1A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:38 +0000 (UTC)
X-FDA: 84589644636.25.AFCF45F
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A5C614000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aghy53oT;
	spf=pass (imf23.hostedemail.com: domain of 3IrLFaQsKCPETVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3IrLFaQsKCPETVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n14jCm7yu9LC/vBpPkzyqFC4opRbuCMIWsyoVMZR2YQ=;
	b=2RZBlny3AoRFv1QyVWgo+wGv2YRP47SBwZ/jd8b2Czq5RVUMS146u5z3bvVCq2r/5E39TA
	bEQ+lnYF38lU/8SmnX8veE1BPFkVlSTMAdaQpBXDIeHb4q2LO1Z3bARKjJY62/O8GX1LjX
	QTHdhzABBWS7bHwOunT7uE8nAs2TJjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563876; a=rsa-sha256;
	cv=none;
	b=enrrT4M3kxj1WtASGvu3WGS/NZ1UFvW4wPzgikPzxcoxt+0U6ItQLT36Q7iUHPuW/BbFlF
	l51i09x9fiUBHmy35Rb+vzY0Q/tx/HQbRV9+lN60QLeLCe0bewx1+8eBwMQ5UmrNTDHFnH
	y+czQgOiBpN2Mmd2hYCgXM9QSRAN2Gg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aghy53oT;
	spf=pass (imf23.hostedemail.com: domain of 3IrLFaQsKCPETVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3IrLFaQsKCPETVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82c38b85c25so2734267b3a.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563875; x=1775168675; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n14jCm7yu9LC/vBpPkzyqFC4opRbuCMIWsyoVMZR2YQ=;
        b=aghy53oTIK2VpAMzmCVvK5Shh0MkRiuMpLYJSxpYUu0l7++z+wKcqvGCpQl24u+fDd
         X80FN40BgKHheIw7WtVQ9bHiStaVDT41ExJmS7Fx5a04pdVxD7c5EcfYszhrXksCCjyg
         BJAqN5AxAKFJb/lDa5S1SdM3g4E4S/zsIAouNAUno1tiH/OhDc5tMGh5Te0qtpBPvI8+
         lE0C/1zK9xLltCbQ+u2MkqvAck5UdvFxqtvFVeze0FEs452Ihuk7LdoFAs/RSnsUNO3l
         JyJGhx//BBpByttqDCk0t35uLfLpALsMA+4EmtpETnvMoy0gwzN6bz6o/gjfdSeXJsTA
         YMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563875; x=1775168675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n14jCm7yu9LC/vBpPkzyqFC4opRbuCMIWsyoVMZR2YQ=;
        b=ijNem4npAc1779UqPBHpX9eisF59C/qPC/V/UgEHaZ3ykgBppCE7APrr95AUyoIV+5
         Ty7gGH8uNElFEq2SJwihn3DkZs8JB+eN0PeEMnWFfgAyw6azAswRJDfqjFJNG2s5mTje
         Coq6pTj78FwYcLQbSfVSfcFQa7N8J3Gzfr7mGCYa1rBdYIJriLgeAENMy/hkCQHGj+oG
         QTogGGIOmzKDeD9hnkw2Lh9L3UMVlY+Dcp3oeBRWlXFEuTOf8jdGFeusqQAUFwNQPcpG
         sD+Jyg95hUE3oBTDYzdtIKuzzE64GTiNuOCgkj/1uAC/GNoe1dy7RygW0QcmL8QQEnUG
         uOXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuR1X66TqcJDXYYgw5TCmXOqxZPDkeq9/vWncOMPAry0el8vP8Sawk+tYSH4rhpjweq+86aCW+/A==@kvack.org
X-Gm-Message-State: AOJu0YyBb7u4Md+4G6xlWCaMGHts178TlSZzPvoTRce+N0GbT3eSh5jS
	CMuDwlcx6t0O0ruqrKNkcEi4Ce9TCVS+8lpPmICvmqlvE0yDZjBd4+U7KhYNr4xc+h5ZzmXDExs
	Hei1r6qJHX9T8SB74EHzpxMI0cQ==
X-Received: from pfbhw2.prod.google.com ([2002:a05:6a00:8902:b0:829:9a65:4170])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:23c8:b0:82a:805a:7cc with SMTP id d2e1a72fcca58-82c959d4be3mr153491b3a.4.1774563874655;
 Thu, 26 Mar 2026 15:24:34 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:14 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3889;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nVwpFGhdInAIYcCOHyVf1SHbYDR/5EzcpRzGcQJhTh0=; b=lflg/f6MMNyq8okFwTq8rOBXOZkFUGGSvNBdwadMelTajGXnQi6GmTxDhWAO0pxC0zzFjJp3+
 HdOJ+KijHgvBGAbFtTm0ldKzRrFPcdzb6FLv+Jrlabq3WDMpA8igjmx
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-5-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 05/44] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
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
X-Rspamd-Server: rspam12
X-Stat-Signature: f3gq5rmpa4hfgw8po4t6e4j71n94pe3k
X-Rspamd-Queue-Id: 7A5C614000F
X-Rspam-User: 
X-HE-Tag: 1774563876-174007
X-HE-Meta: U2FsdGVkX1++X2jiRQK3dp9FUvyrpZ6F3lWvjKNNEfXLHgHf9GwT6TsRt8G5i9ztGCky/j21xW9NRRlGvKaTG2N/LP4V8JywvhcSH+WhrQWycYb7IBUrjP3kqSWN7KmPoY01nRJcnEG1Zs3StADQ4rMc9an2fWCkJp8/IL1jnSLa0Tm9DgOfNYa6Nm8piwH5zETbc/GnQQwoSSylWDcy+mGkg/eT9zsXViQksxnikNWgXgooqKdbdqWvI2gH2CKT0f41bXm/YMlSquSjXEtYacroFr4l9eknhVvub8rIF8nL0p00mKyVlVa1WPzIq59kc1cFAauS/6diG/Eh9MBtJUsKzqVApIWAL5ZC6EwS1hdl4vSAAcsDTo9zqvzLb5rCy0BrY1uza1WLl9n/HqFrHiz3X5FsWJl4+iUv8tVS09tcmjNRI9Rqp7G7UZRBXfJrzYogq2i+9uvQeXZkP1KHPT0z/plUI9aEJRGVp5+mHmRUohn5qYSO++b1swpGi2yn5imtL+QNKiAPopYlrVwK3buj6ITS+UK5QvlgjAJ92x1j62ic21uORMFlhvOG3hxS1GOZG/Ios5mIAf+k3yJm2D5UZpVPdVGI1Sxx09gmHx0VqD9LulGnwYLj/nIlhisdZNxvfFWRJU6vbRYzE72hMiuzhW8OJ00tm6hEdc7b7dINmCgC2niJDK1JJNmhcQ27GlgIZLGXtbClQeGw+ClshRNHlcRoFemlIB1FzTXejzKYGLj/GUsrpzmA8KU7wVkWphjwawB7qsZ6y6z2cGVSqWYKBm0ApeVBegQBHcO4l6r1q54ZHHYMlM+WPC8JFF0dQrLFBopvojpNG2Y1R3AtR8kp7ydv21NCAYnIT3PI3hBo3LljzWGi3Dkt5V6LqlYvpBqI33DHRZbG5wEhRW7fVS8FpyqNQDiocqWausx7+XmfK0SyAFAQlKVXqoBoqB5rqwHRW04Xg0FvGdSpApL
 SOwzy32D
 2LQP2MkMzDuwyO2dMWkz+AdIJd9vAtLys/9Vtm6WURLFovhdkVM/TTW+vO62bNpf1RDtYhVPL3Wonhwa1zukMmgxB3dKhlBaelfcDcNQb0fEJGC0QV5RFAijnQkdLh9zezsFqgxrxeSVWpzg2IJ26HrBjcWVfCiIdUDnLq/JTHDQINWD6X3CYPavxc8PbsDa+W5Zlidyh3BpHdjOEGk8AkiueBROF3NVS8HI6vsAuGXJdED9Lpe5rPo6L8qt0u2jhv3UOIQcSLAGUYvp+iFuHN+yyfNgkIH6R6rRqKeRainBYo4JA1NQesL1/Gyz486Mw3HDBbJ9NBzKYrUHR0khcd/pTDE14ICvo1SQ3yywrNKRjU7/YhNyAGkXw1FcgbCL1inViFQxHiKvyXeeJe9KgRqAfDGXNLtssTs+8NeISoG2mmlRLotddzLvd7K++uH1qDKjcGzXoZICOV00MKDzdZ28UwZxcJTa7WXjatj8ki3GNROq/KYWvxSAYUptk7AoudaDY2dsPPvb4w2FJ3jcn9Z4hl0DB1xQapz+AQYGjRBcWVLR0U1jtac1oBojGEEQmddSMwAyw+/3WYI2ApTXUUFW7D94YblKEc+jPY3riM0LWq6h/Q6eQGKEQtfS/iBnm1WfA9RA0HS3Tk3Cd9/lVoBuHFC6ENrMJPoH04ITpg/N0VwMqbAOUoiNEV02tINd+m5A8+kE+VkRpdSCGVVCmDgW7pzfZlZ1rOodht3jrrb0cb5uA7sxiXW9iSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
core and architecture code to query per-GFN memory attributes.

kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
queries the guest_memfd file's to determine if the page is marked as
private.

If vm_memory_attributes is not enabled, there is no shared/private tracking
at the VM level. Install the guest_memfd implementation as long as
guest_memfd is enabled to give guest_memfd a chance to respond on
attributes.

guest_memfd should look up attributes regardless of whether this memslot is
gmem-only since attributes are now tracked by gmem regardless of whether
mmap() is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 37 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 3 files changed, 42 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5393854ca5966..0f84421b3f49e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2542,6 +2542,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
+
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index aa2caf5114da2..6f4252c8b3f59 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -515,6 +515,43 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+	unsigned long attrs;
+
+	/*
+	 * If this gfn has no associated memslot, there's no chance of the gfn
+	 * being backed by private memory, since guest_memfd must be used for
+	 * private memory, and guest_memfd must be associated with some memslot.
+	 */
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Acquire the filemap lock to ensure the mtree lookup gets a
+	 * stable result.  The caller _must_ still protect consumption
+	 * of private vs. shared by checking
+	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against ongoing attribute updates.  Acquiring the filemap
+	 * lock only ensures a stable _lookup_, the result can become
+	 * stale as soon as the lock is dropped.
+	 */
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	attrs = kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+
+	return attrs;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dbdcef90a4950..7bb59679c9316 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2660,6 +2660,9 @@ static void kvm_init_memory_attributes(void)
 	if (vm_memory_attributes)
 		static_call_update(__kvm_get_memory_attributes,
 				   kvm_get_vm_memory_attributes);
+	else if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_gmem_get_memory_attributes);
 	else
 		static_call_update(__kvm_get_memory_attributes,
 				   (void *)__static_call_return0);

-- 
2.53.0.1018.g2bb0e51243-goog


