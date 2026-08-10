Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36792C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B7B6B009F; Mon, 10 Aug 2026 11:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113886B00AB; Mon, 10 Aug 2026 11:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F726B00AC; Mon, 10 Aug 2026 11:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1AAA6B009F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:01:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B3F9801D3
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:01:06 +0000 (UTC)
X-FDA: 85085672532.17.B899CB8
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C48940010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:01:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQDEQxf0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3rOd5agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3rOd5agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786374064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSKxDjTci2S5HKL2Y8g6gVb9b+tAUX3tfJowR2dLyss=;
	b=adlSDtcDHg3VN97JtCKh/7R8fojMWzlsG7MBKK9qiCntnmQYYotb2r1R7Q1PS189OOkpOM
	1ZuMaKNe0qmSarDDdEXJV1fNqbZ+SKf5sJWpCHCHCPYIoZT0pvvrNy1B93CUu14DQZLCw8
	Fs5Sb1IOFOq/B2Qhzjy5t8ef8pOMqDU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQDEQxf0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3rOd5agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3rOd5agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786374064;
	b=vkvQFmQlwBlJnCkY0WzS+OJ1jXRSHk0mS3BwkVGY86zruuPruWJOiNOcB5EOWIjebW9Ikc
	febnzgLu3JowKzkOJiUqaNsDrFEqs3fjn9rixyjVtWkwDcHACkbcT7cltgxRVPI7hCvbCM
	OXE0jVR6NB00ukwboUt1Pe7b+RBJCyk=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so3350308a91.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786374063; x=1786978863; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qSKxDjTci2S5HKL2Y8g6gVb9b+tAUX3tfJowR2dLyss=;
        b=QQDEQxf0F0frRSwwmUCwDMeswS4xJ59foyMvWDzlr8CXcxT95fJB6DApWAzyHhQ856
         NlVOb2kFzfzMA/3wb69ZYpcCDwGh4qEbQTShi3HIw+DRc8SYgRNNW0l1IZ9H675t+jXS
         0V+AnGHOyxj+ruXyE5XO3KuVJLivNeJefLGIkrWG8ET4n703GWsP1pVhNs0O/kdMzF6R
         WaqbyYsUFP01bC3R5Bv7w3/tWOqjyY5K2RE53V8cgaIJsv5l7lEcmfBAGwf1nJX/rMtY
         jDXtesrqwtp7bS3nFkBnn/cjwIRmcmN+pjP9SHLLoLSPTkwlNG9MUXOc8sRerWl8lxct
         sweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786374063; x=1786978863;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qSKxDjTci2S5HKL2Y8g6gVb9b+tAUX3tfJowR2dLyss=;
        b=avVMNI7c1zUQRP0eqBuUgb4CgE47R4kruEzWdjvGKYOI/Rb5Dk15R1JHu8bBmyDQMd
         I9iB7eweI1dvpb4yOpU7+atR99Z5yFv/TWAWjCDJdyxxP2S7fkWUhsd7gE1lxVx1NbQ9
         DP0HCJbBUraDTRb3zLt8Dq0NC6oowzLPjPxcF6T5HKGM/sCmbDLhkml/E6YssVUlfWRq
         bIFlvlmcFWiwdxeSUTP5PURCRkbr9zHD5rstiL+jKSMgEDbZFQkHtgfl2arXKZmEIVdT
         4pPBWsOh+VPhxTpsCYhQIgRJJM2fUvX2nycuRrGdB7Ri/CuoNHy5C+hZJ9Y78/eI8mcR
         aEvQ==
X-Forwarded-Encrypted: i=1; AHgh+RoHvcy5QRw1KuZPDTqgHIlTCSOqlrwfeFEbQJuTcBHdJdbfN6wHFVx6Lyb/7H0q+qxWkJ6I75acRw==@kvack.org
X-Gm-Message-State: AOJu0YyVVx2KZD77fItC4PKPI3gMYpfDVwjbko11Y1ofB//KpbS6cNmu
	VQX0GwdGGCbyEj3BUz9HKn2CvdTlBACc1mAe19Hof5WKnYqoI45ev+DIsPzE4nuRF7W/0USLlM+
	9Bk8xqA==
X-Received: from pjuo6.prod.google.com ([2002:a17:90a:d206:b0:381:2921:e696])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1347:b0:38e:9045:babe
 with SMTP id 98e67ed59e1d1-392823376d5mr23283260a91.7.1786374060881; Mon, 10
 Aug 2026 08:01:00 -0700 (PDT)
Date: Mon, 10 Aug 2026 08:01:00 -0700
In-Reply-To: <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com> <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org>
Message-ID: <annnrGR1noVuBkCc@google.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
From: Sean Christopherson <seanjc@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8C48940010
X-Stat-Signature: 8ais69d3uhxayrufbz8dh6emzupggz5z
X-Rspam-User: 
X-HE-Tag: 1786374064-136864
X-HE-Meta: U2FsdGVkX1/bovOMqriMHYPFMlbtc07Mfw4x8G8eTgICzBh69yMvGrU/aT4XTtuG1grPhjvtmhlm1+I+KRbW8BdcYAcRQ9QBybgHI9Lk0sQyqy1OfvHX5HwjH5hAAXtirsUpmSKVfcHrRJ0CCP8xS7I94AHEYHdOK71cLzqj7g8EqVfhAzxvFXXq6qdn0LTjZbfPis7pApSyDUitKSxNSbxDKASptBCjfI7DHrrKO+/Ndn+DL3BvznWmVUrhDMsNiYQ/SF52o46lXrwS0t5gHMcByhNWH7kJkT1ohZzEzVF2PtadtCHd/IqqzV8t1I0qWDCZg1ZiqW/kE1VY3iIerIRzg11EXlyPOaGOE92jc6IZqeI0ijG8i39rSeEfGEKvwLchXEKDwelLpjtuaeTumYHJ+51twld94FG5XWo7UMMiP87DliA9aT+/aEMFq0e7hbQ3//o2mNZo0CMmhffK1zk5XvgEga8SeNqyszfgua3KlUnOSeWIO0HvTYuQ9pWYxispCGUEAHhiSrQH2ZT0czCbXK1KIMk5bZoOKpKPDhlrxHvFf654BeT7ia2W2XMDH/CKfjCh2sPGUP4Jt0o1d6VQaXwo1LeB6e9bq6/z9NTQxjNXCeuXTDZ9v4oYkxvtYpuhmSFR5E3Lm7a5lkpIp374WJ0XviM4XQBymXDE9cvVYtGp8oHonJEbnrlAdFmS1+Pf5i8v02CIuKde00mdsiwOYltz7Mtigqw43TCLyeHSAJBIZaMIgzQXiRZ7BviHJ43kUuf5v45DieLsiTX7QHwhtduIdgs8hem9xVuD4B4ZXRBbRUeWXBfRnpkAN+2iM+Nq50P7+OhGPVODaRHsaDSTOYW41mPv5ChLi6VaFq/xJTZUv3FFjqug+M58Bw6UKeCUm4xgdSss7qxXeCwB00LwMH/woD7ED6IroDsDqZ65Xhb63aQerBdxsAgpz1RszSP2cf7xtys84tai6cs
 RR2UVkMo
 sjXrllwtMW4h2678wqu4Z+rYy2LEpXG6MlrLFL+BOj2nEwj5Wt58MvtCAnUFhRVtVNK0g581vvrMOmlDhqp+HpsAsr8wtjgIfG66mnAlm8UMyko3npq8FkLtFfxeat3ONnFO1aQIfK2+AgtOuEuVuxzNqDWRusan3gbujB+zJKlzD0gj+Pe4lHZCBeUB9Sg5I1+6XvqKkKA6pCuE3woHmkxRIOQqw5kvwzSOoO67QJLg0nS1yfC44eidTlMh2b3IYu4shYE7WpQF6x6c/HOqO+BS5iReMjsTXC+fpa1MoDQhWbIlD2wGRUAw2/OWuKfKNmwAidGgNcPl535EHxHMD3bv9GJdPkgWzgBl+yFvNlMpwbmfYdbtzoFt/PfisoCfDuqoJfyKjDlqgF16a79j8ol9V2W4Fci0UbGEStNNdblqqGDCfeWajvT2xDLKKAkg9XDX+ix6Mcr1XHOItTAMuPdlRp3pgNxfFfhhiIIjg0+YQlZlYwF5CL6eMhQsUuz0VF3Bd6kyjtpNHxrQJ7C70YjPj/VQVeDf87vMT4Tka6JrbaDcrtWwhQlJNwLrzwbOnh/WN46OUjgpCZKL1wYBWLdztFbtkhCh8pNARlVlpAkGZiFNfVu3kxCn60VlzwYFtoJoy3PiICNtZ1DEADscUsHktc1H4b336/7ptxi+gJYoJUjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026, David Hildenbrand (Arm) wrote:
> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 65fbce46b63f4..9477ecebbbced 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> >  
> >  #ifdef kvm_arch_has_private_mem
> > +extern bool gmem_in_place_conversion;
> 
> Is there a "supports/has/enable" in there? And should we call it "kvm_gmem" for
> completeness?

It's kinda stupid and definitely more than a bit inconsistent, but overall I think
I actually like "gmem_in_place_conversion" the best.

gmem_has_in_place_conversion and gmem_supports_in_place_conversion are misleading
because it's not just that guest_memfd has/supports in-place conversion, it's that
that KVM is tracking PRIVATE in guest_memfd and so in-place conversion is the only
option.

On the other hand, while gmem_in_place_conversion_enabled is better, it's not
quite accurate either because userspace isn't strictly required to do in-place
conversion.

As for a kvm_ prefix, IMO gmem_ is sufficient for a namespace, and not having kvm_
is consistent with most module params in KVM.

So I 100% agree this is an odd name and has all kinds of inconsistenties, but all
in all I actually like the vagueness and the brevity.

> >  typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
> >  DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
> >  
> > @@ -2588,6 +2590,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  	return static_call(__kvm_mem_is_private)(kvm, gfn);
> >  }
> >  #else
> > +#define gmem_in_place_conversion false
> > +
> >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  {
> >  	return false;
> > @@ -2595,6 +2599,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  #endif /* kvm_arch_has_private_mem */
> >  
> >  #ifdef CONFIG_KVM_GUEST_MEMFD
> > +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> 
> As mentioned in v9, the name is confusing.
> 
> 	kvm_gmem_mem_is_private
> 
> ?

Ya, +1 to kvm_gmem_mem_is_private.

