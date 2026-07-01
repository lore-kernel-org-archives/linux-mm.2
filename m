Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E16C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254E76B00A6; Wed,  1 Jul 2026 11:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C726B00AF; Wed,  1 Jul 2026 11:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1449C6B00B1; Wed,  1 Jul 2026 11:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF0996B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:07:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86822A03D8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:07:16 +0000 (UTC)
X-FDA: 84940536072.05.A2D04C4
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB3BA4000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:07:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7veYNnl;
	spf=pass (imf07.hostedemail.com: domain of 3IS1FagYKCOgcOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3IS1FagYKCOgcOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782918434;
	b=hCOSOhIxSgBhrf4Ysom/jDJXAqpasgrrz5XWFheccm1YjRlNYBZ1nzP9iTnTOmvkzSZopb
	ENqHwSwwYkcG83K+02gLPiEh/TiZ7BNJcCvnRYxsc6s2ejQrm7acdn7xicL/qUbmGm2mfA
	+cAKsD6DnrlaoI42mEYTl0hdzemqBvs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782918434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35ip1FXhxTsr49Tf+Elt4WaaVNO58PfZuNT2YrZrg5w=;
	b=xj5GtMMaOa8uoPGyvVwlQvKLqjdpd0J3BgaT0LIeJgsu91vg6hnqMyomWs2iMqV0e+C3Eb
	7WHuoTu6D8XnJ0aR9vbk07uumFUxpM97Ho2LxQ4SoJ1gKrOkKZEfWiQnDcIZHdSuZTMDRH
	hpl01APWb9m/PhirOxFH7/DcqiuNyRE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7veYNnl;
	spf=pass (imf07.hostedemail.com: domain of 3IS1FagYKCOgcOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3IS1FagYKCOgcOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c825562f8bso8485295ad.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782918434; x=1783523234; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=35ip1FXhxTsr49Tf+Elt4WaaVNO58PfZuNT2YrZrg5w=;
        b=Q7veYNnlgynlKIH40BUT4vCGDV1jTVn7YITYwQBt3XG8NfLO+jFSEW8/+VzlUirUcK
         Q0fPb8JmyTwcweZdbJlXsckpS+oNw19vxUXG5R8OCrGhgtFBLYgCXwV6jpK6mNu9jhpS
         /QuW3/aS+UV07WlqoGysWw6UrqqppRLPoNRwB8pNxJvvwotGM1yDCkBr1xmhr43sOwU+
         JIE6U61W+JVyjy2hYZUITuYhN8HJ9rpAjP5fGUKpVMwqZle/ZsBlungGj3lkReelHaqK
         arMHck26QJQFr6ZolY/ojl4Ej3TKThLfKZBp0QuuwzS4/T6bUYGgNa5F3thVC+dKu52V
         X0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782918434; x=1783523234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35ip1FXhxTsr49Tf+Elt4WaaVNO58PfZuNT2YrZrg5w=;
        b=HEdym+6DZPB86UIQSDK6vRuKBq0e6o3OR4rQDKrHZWE9rrjCmjPuToeJsfVQ12TZoB
         TPzGDdQwGCvA5GSFb1iJFOkvTq2SS8uyfGFcv/T1i481jEbl+kOeGyfXV7hg6kJvm3hw
         bZS1w7nm0+J61T487amLCdXjZ0j+eJ+KFagEvzszvFBBeJyUtDhJwh/tk4Q+Xv8p/puy
         oW1+Evf7d1d/6m5n1JlHSz12WHUxYgcROsx7fM+FtQoUUXji0o3nLnYHhyKLnI8mdpdC
         4l9BfUycv+CHkHG+qnd2xeiC8O5mpwLqHWq8o+tVVUi9/z/Hd28D2xs/H+3IXf/yIEdb
         hBHg==
X-Forwarded-Encrypted: i=1; AHgh+RrHMolIb76S+60s6cncqbGSPYR2ElhOqPO+iyTkskpSVP2oO68x7PRGr2TePpMkRzvcXRGyU7yZ1Q==@kvack.org
X-Gm-Message-State: AOJu0YxGo0lobcSh2U0ClEvfu7BHCjzaBKX7vIw1vyUhXZm7zGb1ZkWp
	me5Q2xV6cAxe85sp6WK4BEx51+BRmj3pu3zwlaolOzTs1B3OkWSvJl3Lzg1ddf2r/RWdXzMklc9
	HInVexw==
X-Received: from plbl14.prod.google.com ([2002:a17:902:eb0e:b0:2b0:aef9:a5a2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c50:b0:2ca:e5c:7fcf
 with SMTP id d9443c01a7336-2ca7e654686mr23268045ad.3.1782918433131; Wed, 01
 Jul 2026 08:07:13 -0700 (PDT)
Date: Wed, 1 Jul 2026 08:07:12 -0700
In-Reply-To: <e5876e41-a11a-4d5e-958f-9e247c19d387@intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
 <a1b06afb-af6e-4666-8c7d-990e7fa150fa@intel.com> <akP9Qv_IPVEh7GAB@google.com>
 <e5876e41-a11a-4d5e-958f-9e247c19d387@intel.com>
Message-ID: <akUtIDdRiU9YOr8-@google.com>
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
X-Rspam-User: 
X-Stat-Signature: wjhun7kb1afaidnnqse6irgphbuu5q5w
X-Rspamd-Queue-Id: CB3BA4000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782918434-767535
X-HE-Meta: U2FsdGVkX1+CbRtK2Rv8Z67/LCfAkRg4eFIADvpvV2FMDW/uo+RebWmSsm2RzgQL36cVB6BcpNWgTTGj+NoYpQeetQ80lPuWq5nXtb844t50pI9i6tb0jQApy6byPWzGNbkR3xIU1eWjr/ff2q/v3Cqwk6+rLatBVXJXacDWxEEpmM4lWjIx6W8elrluqHXjtA3mnPkPex3vPvjlCPgz+NkElDr6xWNiHgJi8a0vHZKXeTO1g2DZq6ZNF1Cc+htZI5TLDjUQLbqSa/sJGtvzB3P4qSU1BPJLkHmZC2cQAWv+LQoPUauEOJEquQnya6iQw7WyJVB2CXBMrLJj1G2us2C5g/JclJ3yWSvN/5TTB97ftws9eu7afT9/5/U9Zn66HTcEmRGABD3qwUwIG6Cvhw7LY66hfiXqz27bmq1uTIy/cMZIhNQD2apbZ7eC98D2Lc84D9wq7/0HokOALY5tmekHlgJXsNMwb+OI+qlDUp+/DFHgXRaFpzTrnx6WcnvVpcMbzly4jWyhziENBS31dJcgQEQY3mHeAkbdTaBwXP/GiUguthFifobPhASdLpN0X2QYvzRnTsC8uxFNFDR1OfeQFzJeaIiVTLMB5CsgUQPFN4Cv42LsG6/Vrjl7mF9C3uIbXjI/p0zVe3clsuGDvYEgWBRyxKf+j41srHATMn8ZPYskBjS8vvQx7fW7ZjiU44cE/nfhkbY4hOTz+7PLZdiG4uOvrGBbAqkkksNAAxnr4w7UjE8aKXWQijYruiX+WDdWQRpo++KLO2Fg75JKiRfeiE2Lg223TViHdkxWjLDyJ3x2eC8L3l5Vod3+zQYRUUwEkQ6D7OZreoVYQ8061taqjH9Qjp3ncBH3Ml+U9V4jiYYy3kOj1p2uPhpt1LHZihQbPA58Oj+J4HMTGJSaUo+wcomm3ndRBlp94SVooPdrZhJj3cZNU2YkxH9PLJJg+yRnR7UpTNljgCk3znl
 VodOcwuX
 cDSEZ+mA7Yz0/b+EqfzltdDZjSlqIGJT50Qdx/S1gQPDup8o220jYwzwMJwovz/0KkkgxRl9Xb2IOI9TYOlojsUdxL6N4fp4SvKSsm8z4zp6nYC1Pzygt3JJ1uXqdthlhgG7wpQEkRYJXQ6+ks5/wg6Bp1Cpf2O8O3RWtjM5+bC01L8W/ksoqAJ//ENalSyt0ZoiimO53o1FeWQ8xvcwb3FEzRlS2H4QMVN7JiksogTyek3SDOAU5Lnj96Qv9MJImC2oWSyepoIF48dnHfVwWrelCHTJNWBvtWDFF5heZd2fvhMwKwUrX92bprN7dcd11rcfYZOzkhTXlv3Au6vnowxMBS6jpxvBZ2fNZ+grbF9436ZlzlXtU4t/pnI/bEa0e0ViEI3mf7t0XSNz7BrqBqcrTtezIRNVIX6q0VNO9Moh45ydZggnsnqkHDTZd7oaoeudysqvC41iIgK9l4JCpFzs+WGHG17WWmkcV1rJsZXFY9uPMKoMCWRUoQw/2KUPmP8EAX4k2i06pNJN0/W7mu18Y2PQp8IgOhLEEy7LrWE9SkpG9hzec9rffYty8Lhwu+WSebkmyMbeTKhKQ01SrhsS7LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026, Xiaoyao Li wrote:
> On 7/1/2026 1:30 AM, Sean Christopherson wrote:
> > On Tue, Jun 30, 2026, Xiaoyao Li wrote:
> > > On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> > > > -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> > > > -				     unsigned long mask, unsigned long attrs);
> > > > +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> > > > +					unsigned long mask, unsigned long attrs);
> > > >    bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> > > >    					struct kvm_gfn_range *range);
> > > >    bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > 
> > > We have
> > > 
> > >   - kvm_pre_set_memory_attributes()
> > >   - kvm_arch_pre_set_memory_attributes()
> > >   - kvm_arch_post_set_memory_attributes()
> > 
> > Yeah, that's probably for the best.
> > 
> > > left, do they need to be renamed as well?
> > > 
> > > then the interesting one is kvm_vm_set_mem_attributes(), which contains "vm"
> > > already while it means "vm ioctl". Do we need to rename it to
> > > kvm_vm_set_vm_mem_attributes()?
> > 
> > I say "no" on this last one, the fact that the function is scoped to a VM ioctl
> > is enough to communicate that it applies to per-VM attributes.
> > 
> > Actually, since it's a local helper, we could go with kvm_set_vm_mem_attributes()
> > to be consistent with the other functions.  That just leaves
> > kvm_vm_ioctl_set_mem_attributes(), which I think it appropriately scoped.
> 
> If we finally choose to rename kvm_vm_set_mem_attributes() to
> kvm_set_vm_mem_attributes(), I think the trace
> trace_kvm_vm_set_mem_attributes() needs to be renamed to keep it consistent?

Ya, good catch!

