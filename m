Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5EEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974026B00AC; Mon, 29 Jun 2026 20:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9247C6B00AD; Mon, 29 Jun 2026 20:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC906B00AE; Mon, 29 Jun 2026 20:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6A66B00AC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:35:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C41B4402F2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:35:53 +0000 (UTC)
X-FDA: 84934711386.13.4B68458
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 149C7100011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:35:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jmra7+YY;
	spf=pass (imf05.hostedemail.com: domain of 3Zg9DagYKCOkdPLYUNRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Zg9DagYKCOkdPLYUNRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782779752;
	b=FE8Wc3b0QLffXPsBzmsaTaC2y0X1bda44XiYUMmG9JkeN1+CqChRPibleTiFzgOrSxMl3Q
	e79b6hDRDhocC4YTh8V1yUtHhLFosmLWnsjXpdb8HjeO92aEhget7oqer3haXJebLlAs3D
	HAG+I9Cua5aRLHNW60q4hq2jtwHl4x4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782779752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mG7UMEOa4l/HjKEvkoTYx4SxOpxm9xemhK9kHyjngUI=;
	b=jMLdBP6MWbYDhYQOqwETLhWW9PN6sphJQXfm96JmxSFS11wsf0wt9++7BeEVJ3ZXrsyqcR
	GpTKatBSKcTOJTw+ziZvLO4mV03q43ZDuNluohC0exIya+g9P53PwG5F+AXV/bJ+4FB20L
	WngwZFrkupWZjX3cPDBket7fKe6ABRs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jmra7+YY;
	spf=pass (imf05.hostedemail.com: domain of 3Zg9DagYKCOkdPLYUNRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Zg9DagYKCOkdPLYUNRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c894c1c4aa9so1874976a12.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782779751; x=1783384551; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mG7UMEOa4l/HjKEvkoTYx4SxOpxm9xemhK9kHyjngUI=;
        b=Jmra7+YYIeJohlhgN7WcbCanRV57xg6EhaRWc8afFi7lIW9dAR8E80+ci47h2LvdPS
         ciSw8hXo6quzJw1IPZ7Y+wVESK1qwEVYflmpis04ibhScCtQlRdBMrdlUaWeIwQX7SDC
         BEZBriNbvHWVbbVZj2BY9rB4z0ORVqWMvsk/E9oRmKLbrOJoS/xEM+2z0pbrpKmVZ1sK
         FzEDWG4jtpoXTDT8TPRzBWgF8eJBHkkdOM53XjY0K2SDtlFqry+36a+aJ+NKx1FNupHo
         kQCZeiMnyq+f+QNoWALd7+Shad6orgo4s2Er5GQo/t8WxkP+gamOkyYcn3m+zw/33fYo
         qV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782779751; x=1783384551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mG7UMEOa4l/HjKEvkoTYx4SxOpxm9xemhK9kHyjngUI=;
        b=MjVKjRSsY47dnBR+DgZ1KzNKS1gcZo7K2XV2C2qe8XWKV3srd76Li2X10ZU4Ttijfc
         Bhz9KrRAPKrlrnhhze5VmLCd7ktPL5Hs38pL3X5by/SRQ3ZbJGqCdR4V+gCAw9yoQG05
         6OiazhVDgW5pF989yfHviKmnw8OKFk1OKZsR+cwtlsVU8MDujJF/DLqajiY4ZyL0g1lN
         6elyK72+t1t8jh0TaphCrFmBBkj7TyghkDb6hqrkWEIUUTHzU9DARh6K10yLpkeDzSsR
         uxgBKm624bniG1Yd0gJrhaflDAw6AmnCjCocE7d3hf3oUAEhvK0gGzhHS54kFEuvfMAV
         votg==
X-Forwarded-Encrypted: i=1; AFNElJ+oaDtu0PyaGpNoRXfOP2ZOZeQBnKcOgVhAhI/xoFzXAIi6dpA/FPAvCTpOeT3cCFo/Shz/YYLLDg==@kvack.org
X-Gm-Message-State: AOJu0YzSlPF+FIgEKdczfcIyPQqsPTE0yU444sKhpJveb1o/O75N2OyD
	R0Y17Fk2GGKEZ1vAh/xy0qClNisVCkzoQcdHBgUp68o8RnEEuhNNEs9pIcisaDfGd631YNWLOV7
	mHDxHZQ==
X-Received: from pgvq1.prod.google.com ([2002:a65:6241:0:b0:c89:2504:2df5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6713:b0:3bf:b3d5:ce2d
 with SMTP id adf61e73a8af0-3bfc50b8944mr1254419637.7.1782779750525; Mon, 29
 Jun 2026 17:35:50 -0700 (PDT)
Date: Mon, 29 Jun 2026 17:35:49 -0700
In-Reply-To: <akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <ajnf5Z9nWZxoLS4x@google.com> <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
 <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com> <ajxasFBzp_9KnQLq@google.com>
 <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com> <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
 <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com> <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
 <akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com>
Message-ID: <akMPZePBdwQlD74H@google.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
X-Stat-Signature: gbrnw9gs1453irosegbjj34c53fjztsy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 149C7100011
X-HE-Tag: 1782779751-859258
X-HE-Meta: U2FsdGVkX19oEysrDzxfOuR4xmdZp9WjEH4Qs3vVLAjmFdYsfR8ECPLiZfYzYK4Dko7TCXw7cfTC2b6J/1oAouT+9OU3QYrs18yEJ4Nzo9C8/bAHmVQ31GPQxDVdI9JUmd8s6UvaaJPEOqB4PzkUSHMRTKH2TLtaTZz3zBvCB0jwxyHumPVEaKi97YDowMfBM23zoOXi3rtJpeFsvaDRJQ3Q4ZmDBWCpH+wmbueRfFuWQ1vUZQ8QLL+qCHIrFx2LNxcWlr3o8iVgmiyWgkKnhpEYI5IKybmeagnvvZfgNZrvqe+QVXCp1cC/2GjDAoeuJ/bYaeEJhIeDT1ADetFF1oHExH7+s/CW0mBvWQzMNRQObIZ5IGWQe7qWfJ1PxCnGKlqdQVy0HE56Et3tlyrONYcTy75WE+Jyvm9nRwqATFZpBdxX1GZUUjc0fG61U0ffGxcRMW3BxOgqsgWoI7QcE7pYvp1dlLnN7lnQZVxabSban3U4fuBsW8E+Es3xEsQvjiCxt0HCLuE+5JKqxEQelYZUzZ3XRCRpY5gynoDG9W+AJUfe1aWm5PZmM9dtPKHJs62sT++l9YfrPzpI+day3bZh/jmzqWCnRz+vDe8+FONa5dtaeei/42n6GrJ0K6k/TtpIaP+pB//44gC419APcCkIjAWJ2D3w8RSFGwMEMYcb5NuYayiFHH0O0vrT0VH79mLh+/DzyQ2JgbbEOjZknMnMqI31RqAibH2s/4zX1mEPWSEgIvSOsFDhnS+NOb+Xac4ePyTyYLh0XyqIS/n5RmBY08pan7DvPTcbfRvOU5WzerXc9cT7TK993I2DYdVnPhNHW8++Kd7ESpgiCLrP4R8iMqp8wIj8JxE87jdlbN5cK15Y0+thoIMGGLRVQglQycsgSIes3Z24z79cd1suHdrGPysu+kyg1/3NZjoDJPgM6JFcrA3JPyUXy6uHPQl0hF4tsG9rKqmRBBu9oMK
 FbmAdU8V
 rWhRsvOQNNQJ2vz6z7QLcsfFpBnDisyCkl8WdTYDvUqpwMhA0pgnYySSuZvvKBnCaIgUnCSDRcjJNC2Z2Q/MGcoiTR2W9lpesCnfrdbnpp9MYvhUOOh/YBrnrrnx6R//dJ9N0Rv6CvULTk6npaFHSp7liAa36rfH/XT5kHT3PuGj62T2K9u8c0tsFpxa9qehHhC59FLLHLVe7m2qdSAyLIh2z1kGsKJAgqOIlxjHit4Ba03yAOBIU4xCUoKmN4HM2mfUT+segpDWI+boH8RbKDnx2Q6kb0v+1whCmy+LHMVW6FwSu4f0dOHmdWwgBmoAE7mb8aCDgRK3Gf/Utoq1VkUJqPqavGr0fz9cD4nAW+lpRn1zIpjPC/cYH82dynEpViT3QWJpOhplSxcZ2hfAtqRoXRAXf7bT+oktSB3hEyBx2XO3Ia8AjVYKW3ku04IwNPA/HkeqKK5FGWThoM5TjF9R+0k/wzPCvhek2dZS9/sm6SdzCMLpNe2ouY0fcz07fCRkgxSRsppci1UvyzWNbjQrJIGco+kJGc41FKCLMicnA9ecDzR4/RsvP43Lra93to87AO4eKjMXbxpqp2GyZF+8XcJmBLREFXme/ioRQdCQ0gQnV1h/FzwqMMmyuAeVQbK0pSb6RJHzPJbRrNJd7gbxQsOy5IZaaALwV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gah, I thought I had sent this out this morning, long before Ackerley's response.
But I got distracted by a meeting and forgot to get back to this... *sigh*

Sending what I already wrote, even though there's a lot of overlap with Ackerley's
mail.

On Mon, Jun 29, 2026, Yan Zhao wrote:
> On Fri, Jun 26, 2026 at 08:28:32AM -0700, Ackerley Tng wrote:
> > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
> > > source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
> > > treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.
> > >
> > 
> > I'd say the original uAPI perhaps just didn't document 0 as an
> > unsupported uaddr. Given that commit 2a62345b3052 already merged, uAPI
> > was perhaps accidentally changed and no customer complained, I think we
> > can move forward with 0 as an invalid src_address? I wouldn't think
> > anyone relies on 0 intentionally being a valid address.
> > 
> > I could document that, if it helps?
> What about just documenting that 0 is an unsupported uaddr which will be
> re-purposed as an indicator to use the target pfn as the source, regardless of
> whether gmem_in_place_conversion is true? i.e.,
> 
> if (!src_page) 
> 	src_page = pfn_to_page(pfn);

Because KVM can't generally use the target page as the source without in-place
conversion, it's not supported today, and out-of-place conversion is being
deprecated.

> I don't get why the two scenarios should be treated differently:
> 1. gmem_in_place_conversion==true, shared memory is not from gmem 
> 2. gmem_in_place_conversion==false, shared memory is not from gmem
> 
> In both case, a 0 uaddr could be mapped to a valid page not from gmem.

That's immaterial.  KVM's ABI (that we're solidifying) is that an address of '0'
for the source means NULL.  The fact that userspace could have a valid mapping
at virtual address '0' is irrelevant.

Again, just because something is technically possible doesn't mean it needs to
be supported by every piece of KVM's uAPI.

> So why not update the uAPI to handle both cases consistently? :)

Because retroactively adding support for out-of-place conversion is pointless
(requires a userspace update for a feature that's being deprecated), KVM can't
generally support using the source for out-of-place conversion (it's effectively
an obscure zero-page optimization), and IMO rejecting the out-of-place conversion
scenario is valuable for KVM developers, e.g. to help newcomers understand what
exactly is and isn't possible.

Side topic, isn't TDX broken if target page has already been added to the TD?
IIUC, kvm_tdp_mmu_map_private_pfn() will be a glorified nop due to the page
already having a valid S-EPT mapping, and so KVM will incorrectly allow a double
add.  Ahhh, no, because KVM will return RET_PF_SPURIOUS and
kvm_tdp_mmu_map_private_pfn() will then return -EIO.

