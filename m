Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A9DC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0446B008A; Mon, 10 Aug 2026 11:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71916B008C; Mon, 10 Aug 2026 11:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39246B0092; Mon, 10 Aug 2026 11:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8B096B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:14:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6887F120111
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:13:04 +0000 (UTC)
X-FDA: 85085702688.05.68CEBDE
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id A648C14000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:13:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HU3Koy1H;
	spf=pass (imf23.hostedemail.com: domain of 3e-p5agYKCJIE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3e-p5agYKCJIE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786374782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP6OZG+k89vE4yr/pvKA0W8zcNVpjbJQrQC8mI91fW0=;
	b=zHCy7cLGJThK5U4b/i6CuSf36tcYLyGey6AmZi0JkM4ktyw3aII3scuKBMxcT0aoEOYuS2
	UfwLs225dL4uyh5up2loW39tDRPlvFqprhj0k+v1oUUC1I/sgxNmHD6xtJuvrjyvOFkXKx
	v6i7If9HFNpyMegw8qRuPRogwDPUMPg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786374782;
	b=u0eehH4IjiEUxE0e1ak2pK+ESJBNhL0IET+WRQevJDfKTWFuhBTs4wb3jRIwnyIhP6YCKD
	VyUMHFJgAFyeNGan2mXgG+SbKoT+ehhIIshFvG6FbQp4xK1yTov8Yj9Y/3lzXef/UN684x
	lgOdSv+2DiC/rPdU4ET4VWSVW3Stfe0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HU3Koy1H;
	spf=pass (imf23.hostedemail.com: domain of 3e-p5agYKCJIE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3e-p5agYKCJIE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84eee2147ffso2653139b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786374781; x=1786979581; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jP6OZG+k89vE4yr/pvKA0W8zcNVpjbJQrQC8mI91fW0=;
        b=HU3Koy1HAPMshnkegrymHDtkNmq02R2XLp1xMkoULa9k+zRhS+LribLhZdKmXjsO5e
         wuhYzPGHJ8fq/Pda1QPOyut6bp1tdjzXeWAhzfLPkyNO+8COXWvf6aV9fNScQb524SOG
         qd8yZdMSXszfa2rBVfrdg0c7ibNqA3cmHtsMNdInWLk8CKvaDPlj0M+ALDIc+8DpPbaS
         hrmIeQy+wuIR26rECcUhG9KafsBjmLAdMKBu+Vip8JUGKK9HLAgf+SCu8AZtulqmrKJM
         GQSdAe2r2oTIvZYMm+xkkYM58QpF7FCcSl9IHhX58BKNoxaN4iywmsfRt+xQVjI7Qq5/
         kuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786374781; x=1786979581;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jP6OZG+k89vE4yr/pvKA0W8zcNVpjbJQrQC8mI91fW0=;
        b=QHZXgWtdOvBVBjQv8efB7rIj7VezCs7wAcCLmBSSFK0ekfocsiSV2RnGutOPd6JlvQ
         Yaj6k0pR+wi5/6Zma3Qs0nRkcloj9j4MR8IkfJ2WUT470S3NtiJVnuYcUq3hEuJ+bC8e
         FkbJJWam32rMSGsenHZAdHR8sYo7vIaH8AnRJW7jlerXBNlbxNKsl09c6K1TWwhXKozb
         70ZE2bfl0lmlIRG550WvxRZc7zloHXDswyTVuCNG7Y7Oc7Po8jMYzwt0NNRby3C1bZSx
         D5ULcv0oGyAa/SrGHKJ6eR99AtZYhyXVeG1jQP/CBB7Zr+7BZPlPTV0IIUw527VgfqRt
         gScw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0EvOKUERy22PVhNk9f8SbtNDJO3OOfrRir9QThS3zBPxcQOjVPtVXU+x36vWyvSLya1u/J4w92g==@kvack.org
X-Gm-Message-State: AOJu0YxWGgz2UMnJFP0U5uuts4Ra06+seMc/OX/kMenSdUKqk+UFiZNi
	tfEYcgyXEaxfe2yynCyeTjM3y5rMRHLEIbI5haf/dz1AZJ/pIvE50DBdUYNzMcCaP2w2YuPi4qO
	9QaVeTw==
X-Received: from pfqf14.prod.google.com ([2002:aa7:9d8e:0:b0:84d:f9cf:1f3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2286:b0:848:76af:db37
 with SMTP id d2e1a72fcca58-84f694200b5mr21737517b3a.7.1786374779939; Mon, 10
 Aug 2026 08:12:59 -0700 (PDT)
Date: Mon, 10 Aug 2026 08:12:59 -0700
In-Reply-To: <20260807-gmem-inplace-conversion-v10-2-2fc18ee6d3ba@google.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com> <20260807-gmem-inplace-conversion-v10-2-2fc18ee6d3ba@google.com>
Message-ID: <annqex-kBOc0UJvp@google.com>
Subject: Re: [PATCH v10 02/41] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5n39nd4hf46tmxd7fwsx1szjkhhphpdz
X-Rspamd-Queue-Id: A648C14000B
X-HE-Tag: 1786374782-310319
X-HE-Meta: U2FsdGVkX18Dq9XIYw2AswiDhAwNoUT6gzGXNcIz2rMy3yGBZD+2l4Sgcu7+wOtWE1pqYeb7+OD+IXCRJdN1Vl0+1un8tmBQSFe2JJD/V12H7vPeN2N9HKEE0P0BPYgRJ2WtD9frRfJ4XgrIGpL6HxRnnB+Drsxmm2zE5FoZtwzAU3bF5ltPUdlxtG1gITzT5mw0YqsolDzO5Adi1ZdMpxQj8LEzbnjflcqEy65m+ywF8wbNAY+++hplYkIswmnbm1Y36GsUyPZxK2BX5jiQoi946HWa3rsp+zc1wDaga58AWsw+RdpeWbJvYLZWcdzCQw3ZE8YLq85pWcaTIu/33OwFOb6WZ0Gj3/YAXV7PCgYVI7iswRIHZD/gIluhuNuDMFWhvqgYwkka9B30Tkc+QD+h8N156l3y2/1Fbc0J3UWK3KVaIAwY+ai/tC0xoPxTbwpoj/2hPRZJ/f5RBFmaI2WDbHu2TvjyAE2o8MzTeji7zjqC573enaDdElQZLPMvQaxN3QRpNaDJpeP3ea7U/14ABfLhKveGIp4Zr4LHMIuqwfm3e909decIIoh4qSjtYgt0X9TiyZ7/HgvfRTfZe24ZofOCU6P1hwXWZhiw/E+0X8Ew54nhos/unprPVrLRk5DR0v1oc8Kh24UZuOmpLvi+WMmmkjhjuuGBex7o0jjs3DZxQ19fnjg09zEsDqNw8jJTbZF6AmE/ZcrIksI8yXldbKDkJLtFahoS56rL19E+M0atJzrCYkhD0t7jyycMuj2FIkNPyu9ttxCx9riW1z4AkT7Uti9VXZ6l1iTkcmvV77qtppIZ+CzZPx4ZKycMfO61VQiRsNELoOn89isRU0k0u55C+6OS0TRhwCvZR9N4hiHnvagqxaEE6OdWDqi622Hh+jw8tWY5GXKvwx1Ntlxz2Psvd3nPUpJRsdsRDjZltLsSvBt5WeLRYpjifPSHueHBC5Fu7ar/Tt7huve
 yMJikUHR
 vVbHRsF8Dzm3lyAetNeAj4+GOVRYsqGhEp7dZ3zAa7bx00ylQskpNHKd5noNGcpXVh4smTo6ZwbbwhMuLab5oRDbIJdII4phONkqC0HRer+ZVqZvhkh2BFa8FTObzTna0Uv7UQQaRk5pgOIymvbpeUyx0lXSIjQklE69xDN83eLdOk0wMzZoxbCYn8CCJKez/DJ7P+QhdiiykeQdAqFLgD+clXmrN0XSBfbKG+IJNVkc+ZmmN04riZ5Q6Q6BWnnNnhB45Z9MktF47VBMEtVFPHAiXsbnnR626D503n7JyB+LjBTYGD415HnZ1HUolJlPM8JXa8JWUkF4dfIZ+zDj/6aHpHZRfRmMI/K6AT3VidNgaGYYNgEYUHX1Y5mEnxVte7TnZA/Qu1aIQfqudH402HszMDtcaPt2rytjhkAHRMvdszqOTUdrUQanttMGKZovj55CMn+UvfS6H7Ebu1OUTshV9OsaGqcc4VTIjvvYhHcBkWUHi4iu40rflEYoKBfwOQS0swNvHK+zKbvAus1etpAOE0rDeigrevaiXQeWsVxZVMMSnPfGIxy2yS/VY4zM1hOvSd5KcozzAaL+QAQyubFVSzkHfnTr0rKTLleZAWcYbxzqLtL41twqxpVnhxNwMjioi9a2N8XTm9JqCmLnSs5fh6tp9jAAkowBssgIUMXd7PJbUGCXU1zI+5Z8GmLlESeXW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026, Ackerley Tng wrote:
>  static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> @@ -61,9 +69,25 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +static u64 kvm_gmem_get_attributes(struct inode *inode, void *entry)
> +{
> +	if (WARN_ON_ONCE(!entry)) {
> +		bool initially_shared = GMEM_I(inode)->flags &
> +					GUEST_MEMFD_FLAG_INIT_SHARED;
> +
> +		return initially_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;

As David pointed out in v9[*], a helper would make this code in particular much
easier to read.  Though my vote is to add "get" and make it plural, because this
function is also plural.  I.e. this as fixup:

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f2bec0d49747..b7435a8d2405 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -69,14 +69,17 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
        return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static u64 kvm_gmem_get_default_attributes(struct inode *inode)
+{
+       bool init_shared = GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED;
+
+       return init_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+}
+
 static u64 kvm_gmem_get_attributes(struct inode *inode, void *entry)
 {
-       if (WARN_ON_ONCE(!entry)) {
-               bool initially_shared = GMEM_I(inode)->flags &
-                                       GUEST_MEMFD_FLAG_INIT_SHARED;
-
-               return initially_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
-       }
+       if (WARN_ON_ONCE(!entry))
+               return kvm_gmem_get_default_attributes(inode);
 
        return xa_to_value(entry);
 }
@@ -833,7 +836,7 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
         * index is represented in the maple tree at all times simplifies the
         * conversion and merging logic.
         */
-       attrs = gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+       attrs = kvm_gmem_get_default_attributes(inode);
 
        /*
         * Acquire the invalidation lock purely to make lockdep happy.  The


[*] https://lore.kernel.org/all/0a85b27a-121e-40a3-92b6-3927fc298e4e@kernel.org

