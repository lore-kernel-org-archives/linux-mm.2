Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FFFC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E906B0325; Wed, 12 Aug 2026 17:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FED46B0326; Wed, 12 Aug 2026 17:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7146B6B0327; Wed, 12 Aug 2026 17:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49D776B0325
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:34:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3D171C0836
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:34:57 +0000 (UTC)
X-FDA: 85093922634.03.56E2B5A
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 218AB1A000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:34:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LvoF8Cri;
	spf=pass (imf19.hostedemail.com: domain of 3_uZ8agYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3_uZ8agYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786570496;
	b=Rlv1x1H3nWklERcA5qHin+I9wWOvf7BuFcy5/Z2ro2ufV5N0SjRWsudSJDRTjbvov0foYc
	NZ3NSJZ3lPCn1+FAfsl0jNAnpdJt0fcZJS43Nh8NPptf9CWq/xZ0XhBfLQ/hg7F534S/d+
	uge0QIe/0KZZ0/aeShS7epIPA0OneOM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LvoF8Cri;
	spf=pass (imf19.hostedemail.com: domain of 3_uZ8agYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3_uZ8agYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786570496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gd+C2m5glZwGB8A6MFkRhDf1k0GKC1mWi3Ys+MVAnsc=;
	b=4vrnpKrFD/L+0hYeJYfvpTGpWqdYlnP5GebG9xWcdgzI6qQLF35Zioeuw8LTe+6yJAkLng
	VLfanRCQZKjgPT2jfS4Ss47TlNoHamr+5ZwxlH/rRkNdiZ5MgX4z9eeRcuQ+lAD3Zlrt7d
	SIs5kSRFgg4fgaAPWgdLpiiMiKn2eKs=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cee1ec30f2so21774435ad.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786570495; x=1787175295; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gd+C2m5glZwGB8A6MFkRhDf1k0GKC1mWi3Ys+MVAnsc=;
        b=LvoF8Cri0Y67/16Ix6LpILe9Fj0IBaVlaPGS5efGYKWizYTmiyBj1aVejf6AyE1YSl
         6xL3gkw79S/2R3ciyqiCJvVJlUd33MhtR/0wmuwNxiAUNFpKNqYQ7mLge12+XNegGa0k
         wo8MCo5cGq0gyRiGJrO3471dSVAdWzNPH/R0UcKQiQaKVrCQhaX5aJKyukdzkKv8w4p9
         4P5seXOFei5P0GC9Lz8N3ddThV+QmO1mmUT0yhnfW7oifoU4olV+3k8brVpbm+bJcmYj
         aMv1rkaoxUUPyaslLNlT+eY+6DrrTIe0QVI+TiDgsyTFD5jZuNCQ/N5oDv01TWAn/H0K
         mahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786570495; x=1787175295;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gd+C2m5glZwGB8A6MFkRhDf1k0GKC1mWi3Ys+MVAnsc=;
        b=lknwDYde7ybsoatph7XGjd+QNHXZCTzWJdMOdsPQa/iNH4J5t3W7ImObQRNyAlKi26
         H9OjgBPIPRkEZo9gltVE6Hvfwl5zLJEdAWeOBwqP0I8vJLKCCXg3MCA3SsmUzc8gwI6y
         05kOmYRS+ZCsI+SY+wpRzUyQ/Uczw+42qHjefkT/frLM5sW4jHT+J5SjZfGW7drFFr4n
         jvSPRNh7Uwno07c602LQvnQRVSspMOW+d9IiW8cshQ2fbyG4tIlWn9iHFi3/HByu07Mi
         qnm5+WLDiRMWr0+yGAAyVLJMBNOiT5YcA5KFyUXMGlzbkII8aI/Ve9jJSf+RtOY/nrIr
         SeGw==
X-Forwarded-Encrypted: i=1; AHgh+RpVjdsi6qhaTTxrORzRS5mAJiYSiDOo77fMTDilc8pUaa0Qgeksa7oF103jTtWismqLedvJeevm8Q==@kvack.org
X-Gm-Message-State: AOJu0YzbnUVH7Y8mZUpi/6ntlsbAuXE47dS02eWqGcXoA7QC9LG/w6wB
	0IgqC+4wFt5iwaRI45tRtwP1p08/4igkShsdyQ+uT0xnNtgB82P1SajY0FZHzqFQffThSrGIdQ3
	+UCSi6w==
X-Received: from plblf13.prod.google.com ([2002:a17:902:fb4d:b0:2ca:eea9:9845])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d990:b0:2cf:9344:b80c
 with SMTP id d9443c01a7336-2d37ebb2b42mr10699005ad.18.1786570494619; Wed, 12
 Aug 2026 14:34:54 -0700 (PDT)
Date: Wed, 12 Aug 2026 14:34:53 -0700
In-Reply-To: <69c86172-9175-46cc-895e-9ecd449332cd@kernel.org>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org> <annnrGR1noVuBkCc@google.com>
 <69c86172-9175-46cc-895e-9ecd449332cd@kernel.org>
Message-ID: <anzm_YLft-J7pxiy@google.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 218AB1A000A
X-Stat-Signature: 9h1w8gwpkezdsokuobiyxcmfmgw14mqp
X-HE-Tag: 1786570496-200473
X-HE-Meta: U2FsdGVkX1+vP1Sj31/ADN8mTC3R4+OOH22T4s/3e3bzXJ9ZPIif9nS6b1lKNYv+0RlT4VOZS1Zh/J7WomighseLDRe9r0OMXIb2WRFCUcnP4i2ijdXEDAvVcL9SVxrGI+3x7hi43eZJ1a9ptmxe7CoK3GfbXKOb+pX/tph1IiFVI5+gHALCY3xx0aI9cgfabltIlK+6uTAKWwjB+o66t8hcJ4Lz+zUfK9oWktO5Pj2m3ehwmzplLWdY0R5O68e0+oqrX1DXRrfZxJ/Lk/2l5Lp5JizJieHYlaP2QNE0Rsz5/K6sYapdkkJPyzA8z36lr98xPKRmTg4IJSGrh/YPchuMWkpmmkHRnjLNhIy7lOM5btWXvUSbU4Xy7qo4ykRIri+mEFtn2PoxASSMCamyC9BV8D02mCNg4Xji3Fal7+a94tnOGtnhxxLJ4P2FS66ydNVLns3RpWsFK/X0TYZN65gUymJtljAMDJ3lDXKddcfjSHntYnxLf5YZ1Re87CkVbQO1jNz3JSrikFveMTCDqiAhGW2HrqxN+yJ9t7tsDcqdr4dxQBIi8BXFW6J/GMkpzad+QKFxXRo9T8/X8rUFGRqVfA5nWwGrAy9MUzrU4jJ0L8SuY1uvG3i3jVazUedXZQb9xWMH5QARWl4lT8Pj+Nt2CCcAs7xMocBvtCsPMXyMd1FE2FsPM341vRi1fntrY9F37n7Z+R6Xbox+iqwjHuZ7cYPmevGIUS5SylE5F5UkRBf8bK5cGB0ia++s2cwAlhgN611wbkDeETz3rmLJSTT2Xhd6MS13OHA1pRGDUh+OJ62hx3VEC3mKrMjMQkSW8InT76bEUl3VrkTShDL5SiofgfNYVgkrqHVDBUPOYehxeieWh8+ApwJCZoQGrx5gJXa7/C39mI+j1PKkxoKqGKew/owwzpbDiT/1HskZqge9jfX1cLLWLn0vbvpUGNyf6vdMumhO4/sWIbvZY5K
 CYWcrCXh
 Q8MziUPH26uu/Bw2p3Gl51wd+V2Ax6Fg/xWA23wm+PFEqDob5Hd9+/43LZLtYUhf1vtO27Ou4lvafa7gWqX5FoQJK5fup3vhJEbu+eSZG8V2V99JQQu+TbGX1lb3V3jV+8NTxCNGdUS0BiDXyUZGfjpLTHYAKTdxwB575lbRVBUCeolKGNWartIKQKa30Zck+Cx6lLlorA9SxOEC0OIEGukKWj5UnU3u+ylyJ6Y6DghtAilO4a46rrGnU8zCYgy3gcQbnU6a5WNTFAxqXHdNny7oUo6gLN2Br3vgVWBzWNudjIChQlokOEa9Wi14+GZdPLCeHp/znEkLegIclRwvuaOPHk5zX5/1cfqayIGaAL4tICREMO8BxUCAHB79L6/9Kwjd7ejebX7xCPOaTCCnRz5NkDz3LEZpXrUrIbF5QN5JxRWogBnHRpHAKWA6VOY7H8IM0Xff7iX35KXOVNHnbV4dmqo7cfG/RdzLyK2DG3TaXfGKA/r/FagqJis08PH0gYHr8Ry735b/FJ39QDXqe27vwyKnzVAGadxFEWj3kBgnnvczttHKdtTESjoGhzpB6XoyOJ30K+xuxgRlyu01th4gNKLWGbP0Fav/wTUYotaSk0G5eGqZ+4FdVX1bmllmpdPEpXgvTMW9+9WEe3Pm7xfIWXRewYe5WBsaTuJakvaDZBZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026, David Hildenbrand (Arm) wrote:
> On 8/10/26 17:01, Sean Christopherson wrote:
> > On Mon, Aug 10, 2026, David Hildenbrand (Arm) wrote:
> >> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>> index 65fbce46b63f4..9477ecebbbced 100644
> >>> --- a/include/linux/kvm_host.h
> >>> +++ b/include/linux/kvm_host.h
> >>> @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> >>>  
> >>>  #ifdef kvm_arch_has_private_mem
> >>> +extern bool gmem_in_place_conversion;
> >>
> >> Is there a "supports/has/enable" in there? And should we call it "kvm_gmem" for
> >> completeness?
> > 
> > It's kinda stupid and definitely more than a bit inconsistent, but overall I think
> > I actually like "gmem_in_place_conversion" the best.
> > 
> > gmem_has_in_place_conversion and gmem_supports_in_place_conversion are misleading
> > because it's not just that guest_memfd has/supports in-place conversion, it's that
> > that KVM is tracking PRIVATE in guest_memfd and so in-place conversion is the only
> > option.
> > 
> > On the other hand, while gmem_in_place_conversion_enabled is better, it's not
> > quite accurate either because userspace isn't strictly required to do in-place
> > conversion.
> > 
> > As for a kvm_ prefix, IMO gmem_ is sufficient for a namespace, and not having kvm_
> > is consistent with most module params in KVM.
> 
> Maybe we should have a helper function instead of accessing the module parameter
> directly, then the gmem_in_place_conversion could just stay file-local and
> kvm_gmem_in_place_conversion() would be used by other code that wants to obtain
> the value.
> 
> Instead of the
> 
> #define mem_in_place_conversion false
> 
> We'd have
> 
> #define kvm_gmem_in_place_conversion()	false
> 
> just a thought ...

FWIW, I'd rather prefix kvm_ than add a wrapper to get a boolean.

