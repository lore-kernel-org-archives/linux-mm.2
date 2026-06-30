Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E17C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9BC6B00AB; Tue, 30 Jun 2026 13:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B18B6B00AC; Tue, 30 Jun 2026 13:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C92F6B00AE; Tue, 30 Jun 2026 13:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D458C6B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:30:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FF881404E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:30:46 +0000 (UTC)
X-FDA: 84937268892.27.9D594A6
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8C43B40020
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:30:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hDNo9Jg4;
	spf=pass (imf27.hostedemail.com: domain of 3Qv1DagYKCKUXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Qv1DagYKCKUXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782840644;
	b=62PUj95xv0jc1ookXkzqRhJm1CAw0qzFZmHo+jryDxP1Xb06yi/uyhWRkGGjqGZQU707K7
	tOw+1IzzFleGNOqOUu2R/Tln9yU6a9rsDEABmoL+LF9Fq4Rf38UvZW54CodFFp8XCOnzW5
	W2Tt8qkpCuyO1ubo9464mveB76icJ5s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782840644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxXDGdZP36dVSNVXo6OGlh08WQ4jD0j+gPBa9WDdARQ=;
	b=sO0YWV/Gni4BZfjswj300U1bSnYJRs0gghore5Ipv59e5df6S7+7BL2+SGtzAiRAc+7qjU
	R/7MAxLgqEDn5bc+8MzsRCpQcaKAUFe1GKwNL4Rt/nQneL/DsTL5KbTyIAIILJ0RSV26mo
	cxcVdGWgS2lEPFMHLifbBeWBOMkkQ5E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hDNo9Jg4;
	spf=pass (imf27.hostedemail.com: domain of 3Qv1DagYKCKUXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Qv1DagYKCKUXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c890bac374eso5237737a12.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782840643; x=1783445443; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KxXDGdZP36dVSNVXo6OGlh08WQ4jD0j+gPBa9WDdARQ=;
        b=hDNo9Jg4UisPtW+0DPiRbs2ZVKW6pnen+OOBZgcnbqtCX3qbzOizP3LYJB2o+BixAW
         VnMYTLf7+ocxzKwcHhbDLAXc8PqroEDmmWaHN/pjWpWVJD/zxnbosbLC73djc4LFf2GT
         cATYTf66ysDWbMSTzrgjOIqUaZ7S03MCeNVLMG3prDsA8gyrUcNbdu0J14kygJxNstZC
         /+BG7da61yWwQ6lo3aP6vXNWhIUU9B+xH7o3E9JcsshW4NL1cmE/FdGMPClCw2cej33G
         KWxBtomiiFQsnpLfvGL7RIYwx8f8k8xwaeXss57WTk+fFXxGPxUjFOrqe2MYZrvnEaCH
         Qqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782840643; x=1783445443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KxXDGdZP36dVSNVXo6OGlh08WQ4jD0j+gPBa9WDdARQ=;
        b=N3Ou8UAxvAOqDTV5uoW1ASi2G7kRwmbFz6O+5h8K905gGshB6wgqtmKNaiJjPEZA7/
         GDDVHU2s7FB72aD811nZroDofS83DUbMIHQy/mpdsxxz4n7NEF7cQfgS/17VG50pLbNv
         f6ENcXcUs93BGRoW4Rw8GDlRuE5cZkfe1cIJ7ilt4gRio5pcUmpMnBSRsEPx2XjHhXeZ
         62LNhRMcE/62Mq0vgxKUxWfvkpjpKNM69FP914qXhfPRTC7mwisnlW6tQeS7X3ESQul1
         E2+KR25qmofo4ebE2LgulK5FUj8vvkt6QQhALJBLtRiIfSLCwj5lO7/kqhkXTizh4ni6
         sIwg==
X-Forwarded-Encrypted: i=1; AHgh+Ro60z1Trq4ctJ0ViSzwyWba5LxoePenSfgd9yK224f54aPnmEJeyfGGb6Zhzw3GLw+c0oKqzTcjWQ==@kvack.org
X-Gm-Message-State: AOJu0YwfzebQxHZqQaZflAAAdbuZYToTSEUVfbvbfxuoEri96h914sKP
	xO+g85qxUT9rLKW3E4WF08ne/OON2R6DJD+lWbK+bWooSYyCc99NnaYSJWyjB1JV8lNA+XejRYV
	V1E1OSg==
X-Received: from pfbfb9.prod.google.com ([2002:a05:6a00:2d89:b0:847:84b8:2dcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b84:b0:842:6004:3fcf
 with SMTP id d2e1a72fcca58-847adeaa420mr1564771b3a.29.1782840642918; Tue, 30
 Jun 2026 10:30:42 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:30:42 -0700
In-Reply-To: <a1b06afb-af6e-4666-8c7d-990e7fa150fa@intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com> <a1b06afb-af6e-4666-8c7d-990e7fa150fa@intel.com>
Message-ID: <akP9Qv_IPVEh7GAB@google.com>
Subject: Re: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: e47c38dj76utziixwwgmmahytabnsc8s
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C43B40020
X-Rspamd-Server: rspam02
X-HE-Tag: 1782840644-167297
X-HE-Meta: U2FsdGVkX19v9rOfcBxoH25XKbA8s2O57lmq/p5DCojBUOSbNBM9QZEE7fwbD4Sq6Ond9mrk2f4pB/umMyGnIMfEXXNQDOvHPMYXEfWodKvV36CFa8SPPO4F868MAS6OWVVMd7cmM9X52Y/FMfo6DCFhDY8BLo9atBEaKVF9X35VEf5xonZ/UAhfkuQuPR/8FLHR8iqRkQDYJjvQZXO8YQM+ZdNUfoeIAKTcYVpVX33lo7xp+1J5zw2vv5RQcQqmBN/L1INHywoaWhdIuwE/ZY/IB3a0pawLOaXfXzaoBAEyO8wB1uCcf4uhySI8HCjXyCfzRRIh4dbUAoWFIDu1NX+9lwNlKFaUl268UQ6gHZ3i9XhQsHxYsQ9MsztPwKwq5/NTm2kOg8YaDY9atKOvVWC7AM2ehXRVhGRtQZayEvKggJ2+Gs54BEOTj7REwJxNZbT+NqD3bgrSgxTo4u+a0N3YJDmpsX0Fdu3RXwjpFFlrUMGAIcTvJBEyMzcV/3YcQANvAZaJWtLMUztgaqNQVqEmcj/MOOuMGv5zaOXGV0j7LmdOuwVl+PZKdXvUF/iozzff3DMPCARhuaRLyG+DN1sKaQ6wOVOs93rNRjctK3q8AQFLfCtW3n/2GZWMLwi4SIqyHqOIVCetRVViSZW6HRMZy8Of5ch848z+fbKwLjT36dhtZO6/pMUdJ14j4sVzvftJInAoDIFXA/WgxkPhrWP3+6IbPHkFhFs5k6FwHXI4V4d1SwlinCoSTxmCtiI8dAXpFa3ZgqEYQ8wg1DeeZSGTPiTO5tuu1NWlH9PLzxxnDCjA0ARxiOqvMNYN0UmSXPQ6333kvqmMInD1w7gfVt/4gMnssHcF5t7ky9WGJEqhdnCK8uJt3Hgils3xP3cpmTDiDfIcJS2TCXp4M1At55l9O/JFOUw6AILjKxwGjazmqluVocZBmJThfIyosq2WdqRAqeMlYs07MF4CzSR
 2VkTGO8L
 So+MqJ2m0bry0D+V4PVPMgvUEcsLZ/VTn/3rgZNFLmDAbFgYkcDwjJwwgHwKV/q+PtCqaDPLwPSbQ+8bhxn5yFyRjZRHKmrRdcFu3MNT1cg59u0bQXqhUzgKSehjWKpCVAMYxrk5vUiTDOw/Q2C2ocrdA4MXeTVLlLXwyeux/X3T3ocZ+6n14+YBlIhb6a1kff0NRqdnuIlLQS3fJqJgJBpwD1RrPZKo+MtuRilHYWBSycaYofvrN36JGO8EhsTvYMbh9lmy8rDKNohlt9SEpi7vTmb+5s3SN0AlF3vAboH1Qhdvfij7WF/aEr1KTkM4AqQNKXrmcA8f2zKRIjuLHGag4VVXqo7wpmZRdrZWOsVzRhV/T5iSNtWO9ydAPekuNKoBPHgak4KR8+ih3vVBOLTcn724g1UupI+X/cnfNbBg4BGD92S2ExJJ8yv9OVTTry36fOYNY87kObx5eD2sx1Gz9TPLi0GMmXiFnb8lUvL1DaFEfhBooA8P9nYQDV2VLhHKb4YDLBxal0m6LBCTRPT18oFmtBHDOyKNNiEL0TXw0I/cDGamqRKHQs1rBFerRpbc2cb5CjqdUD7dD6ubwN74asw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026, Xiaoyao Li wrote:
> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> > -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> > -				     unsigned long mask, unsigned long attrs);
> > +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> > +					unsigned long mask, unsigned long attrs);
> >   bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> >   					struct kvm_gfn_range *range);
> >   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> 
> We have
> 
>  - kvm_pre_set_memory_attributes()
>  - kvm_arch_pre_set_memory_attributes()
>  - kvm_arch_post_set_memory_attributes()

Yeah, that's probably for the best.

> left, do they need to be renamed as well?
> 
> then the interesting one is kvm_vm_set_mem_attributes(), which contains "vm"
> already while it means "vm ioctl". Do we need to rename it to
> kvm_vm_set_vm_mem_attributes()?

I say "no" on this last one, the fact that the function is scoped to a VM ioctl
is enough to communicate that it applies to per-VM attributes.

Actually, since it's a local helper, we could go with kvm_set_vm_mem_attributes()
to be consistent with the other functions.  That just leaves
kvm_vm_ioctl_set_mem_attributes(), which I think it appropriately scoped.

