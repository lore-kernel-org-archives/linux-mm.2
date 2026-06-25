Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52260CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DF06B00A7; Thu, 25 Jun 2026 10:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6206B00AB; Thu, 25 Jun 2026 10:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC806B00AC; Thu, 25 Jun 2026 10:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB91A6B00A7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:36:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F2CBC029C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:36:33 +0000 (UTC)
X-FDA: 84918685866.20.7E31A92
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id B0A084000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:36:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vTFzNn4K;
	spf=pass (imf12.hostedemail.com: domain of 37Tw9agYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37Tw9agYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782398191;
	b=Ks8ffIOeeQtIt+ZrtOispGY0/SJU1r1E9+zuV7WYVPNbODcM78R4mQ8pKgCANsQe3PapWP
	jFTrssxgconSG9kv/WGBeQ2XFYfBv/F+w3goCqq6nPotXloEnE4BKoLDq6ZfG7iCkQnNjm
	mvhDhdWrVgeYOxhho9k3uTXKYk8be2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782398191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIUA7CCwzOR/KQalR5wXJaS4YlQ6wVTBXf5qStDGhQA=;
	b=fUqobYU+wiWjcjkMpNGvpNYrprau/bzS2WdJ2Mbq0+XrtZXDr7S3OwMvOZafxwq6/V7iWM
	ApZpmD7RkNucFl0DpXQ/JXqvUtD+IN7roRodskbjOxo34qI1nc3lA0FWM9kkjov/OaCEu7
	aaWw4zkaLikGvnxa7AsDNoZaviuiAQA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vTFzNn4K;
	spf=pass (imf12.hostedemail.com: domain of 37Tw9agYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37Tw9agYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c7cfa17fe6so33436355ad.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782398190; x=1783002990; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yIUA7CCwzOR/KQalR5wXJaS4YlQ6wVTBXf5qStDGhQA=;
        b=vTFzNn4Kc2A7Ec8skmoq+Fu0kkO1bvpaP/08oVPPc1bGhKCcsJutuhUmXRrVnsgW0q
         UrbFNi+BFX+DLYFEAAljH5awX8rm/avacF/ST8Zc3eH1emf1FSD4Nv8yyc1uPzg34AA6
         lVOTcvpqP0d2t3/VklLt60jxicUc7h/lksP6XwYA7kCm9XITaez8WzTAIymDBq3kDPUs
         6TSaXYn92wX4pFzQ43qr02Swum7yO8K8rTyi7GYhysGBFTEtYjhLx+bhhhuUfR8dtSrC
         dIyKzwZbAZ0Tia3o91d9TOjHaA59yl2qaU++LfmgGPZpOl3HmKF1/qRd/DNDngpH/k8T
         Tjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782398190; x=1783002990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIUA7CCwzOR/KQalR5wXJaS4YlQ6wVTBXf5qStDGhQA=;
        b=PF+RiCzx8qVcN1ZB0JY7BfP/a1mn7TZv8nKKmgMiZS4zlk5I70x2no+lwobRSI3nJD
         ZHRmI0b4xLO/SFGwiykeMVefRwf17/xk9xzpwO0vDBuoRPpA2rbUZ3+tfd5FOqdgr0wT
         z84zxdA7wR4KJGnTkVP9KpUbixah9A1Ktj0YCyxzC6KILHjd2LLOtiNItrgUNhXiVSgd
         CPFXcVzr/RgilYzUHjrYeZiKdDNdD2bdiFbYTFYHSDYtxr3NoucJStHwT3CL5JVlJWkD
         BaSOdelcJ3c0EcQt0lyRZCucUA4jXxcyV5TpEOGAx87GZCsf1COYPx6MJ217sImGghF/
         b3vg==
X-Forwarded-Encrypted: i=1; AHgh+RrOWPZzWLMbLZpP+Z7n9M8VoLo/BLqCu+bpmZAzfE9Q497RcfRI9GtTF3NMKuqXOW3afAEAnw7VdA==@kvack.org
X-Gm-Message-State: AOJu0YxgtnUuXdAGuz0aIGhbh8mYvHrrXjh24vYtawYm3Tp9idOZ9vK6
	Jg7zjXB4OXX2gYo/pzsp7OkmfmqrQgtY2gY66JwS4H87TFh1nOKR23DRjjTw+PGfR3WaeXvdelN
	L6gMlkg==
X-Received: from plpb15.prod.google.com ([2002:a17:902:d60f:b0:2bd:a0e6:1a81])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2304:b0:2c0:d91d:c3e8
 with SMTP id d9443c01a7336-2c7fc65423emr29366505ad.4.1782398189481; Thu, 25
 Jun 2026 07:36:29 -0700 (PDT)
Date: Thu, 25 Jun 2026 07:36:28 -0700
In-Reply-To: <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com> <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com> <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com> <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com>
Message-ID: <aj087H1UWSFxbShR@google.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default\
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
X-Rspam-User: 
X-Stat-Signature: buemuihbu3jj3td6o7bz8ii9cpnf9ny5
X-Rspamd-Queue-Id: B0A084000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782398191-381638
X-HE-Meta: U2FsdGVkX1/ZdnNoC4nFXhV3VRaIEXLMkEOoMQpvjlPzzLCqs1iTWSraATghChlvBIRrZDw2VQIyJqHDq3BWwHAM7epNR3+Nz/VrCiPFPnhzk9JfUEVS8H1lqGQzofiFx2fLY2ihVjz1DfN/6fFo4Z8x9IunWWo/D7uD+4xJLqSZT4uA0juNdqi3Av0VsLuUYfSrTYnNq9OwnmrveORcJbGUPrXIF3PWCDcu17F17HZgNwalSD+p7sZ6UjlAFAHKJh4+/9BAR84ckMAvIRiZhxZp+4SvI6f3WQpBoy0rMgUTvKgc/5XyGUv5J5N2tvMaS7qdozZTTTny3Lyc3Nx4N1aepxVDd816SLsGnYLN9f+8ulWcOCewuT8gjdNk537ZJ+n295AsDRCpGQZxD+PbbJSWRMhkKEUyPMLAs8f6g1e25JKEhDqk4ujOAWsSjnrRlA/OvuhrOz8d3uFgu3gZMy5sekL034NxCO27uPY8e2gUwbpfNbZ/jJbaudUQxVd1BvksoeYZHxf20wPZS8SX5H52A8w+EFqAKYCbxjCPcrMnynHTm83rVfog0e9e7WtZjjIVfHaAaC4g8iB7zfC3zkeWF1aTy0SdTdwX1IsnokiWaJujUINJi4EPUbAy77N4RdounmPencQo8jFOcV2IY/1wcjhp+S30F+Rel1zVO6muNA/tiZAClP7a6hgDoGDe5e18w8KTrFrW/HKvzv1Pk9SGvSX5G0VsIhKM4r6J2L9GIOZLShlVrhBovBh4veyOKiKx00f/JPvYuo0FcYv88ni5PtSO07d6UVaNWUxh3DxfGVMXQFmZvaxfw8LBdJdrtUTczjSHPi+pjPqJPhKzmyK2ba4pq1/7IwJsbl8MZO8xs9EJZYkSBwjUzk0T+3OSG87hucT8nfgqyjmhMQ5/NLOHbf7gm87d0yhFpMuecuUBz4kBP6rhBC5+ZWVa/PPzTIkhmuLoTdUADGtpB55
 Jkc5fimj
 aw++5hwKjzKdH4vhtisct9n8wAX9C17H9QxEMCvNfdcMqznFDsqEV2XJQrl0PtHhPGa6FYiPe9+WFRSKSyGh9f55ruI17BV93EdLSfXTYLqd6FlNiZLNo3bk3sj6a56Ifmxuk/8xum+50XgvcNKZFSpkPR+XvbEg7htNyY6mnR7Id8vK8MC7XfklU3Nl9dhX3AmxlMuBtXLVDs2ZSobDJMFNZI4Iv6x6JvarIRhbpgA/d5FhJiZl84VrNZXXaWKelPKv2ycFmkGKQ9uejvjsYdsSsWfvGaXMtC1RJW+XJzWdCk7hKlDMldsL4ChLWpRlFS3mfBUZBa3C4c3uFoZDqAOEpra5aF9hWXveYZ/UQF0I+miFW6fKj2NMx1yGoyGDl2XcSgQQhmMvLIr0P3ZhTLeA+twtAd49EyJj/0mE+Zwj01fJmCnm17zrlB1GQE3/vh83DlUnscbHcyosvVRfd5XIffImlKlZUWNhue2uYJN/Xq+qwG7ktcwwNRFung7N2e0RE/ZyfoIMO/n+Cr1nEeNVxB6UU6huW3SeEZCqslvpOjiygdALgiZ7QQGhk3P2IcBqFSk5+kw53OcvjcBBJb/wxGGlLSg0ffCIgzv7CXdCZfcgFHtHNU9N6aJshSo66NTsgvk3prdQMvt25evofKj4H2fQEpifmRIQJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026, Yan Zhao wrote:
> On Thu, Jun 25, 2026 at 09:51:01AM +0800, Yan Zhao wrote:
> > On Wed, Jun 24, 2026 at 05:41:58PM -0700, Sean Christopherson wrote:
> > > On Wed, Jun 24, 2026, Ackerley Tng wrote:
> > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> > > > > MMAP flag. In such cases, shared memory is allocated from different backends.
> > > > > This means this module parameter only enables per-gmem memory attribute and does
> > > > > not guarantee that gmem in-place conversion will actually occur.
> > > 
> > > KVM module params are pretty much always about what KVM supports, not what is
> > > guaranteed to happen.
> > > 
> > >   - enable_mmio_caching doesn't guarantee there will actually be MMIO SPTEs,
> > >     because maybe the guest never accesses emulated MMIO.
> > >   - enable_pmu doesn't guarantee VMs will get a PMU, because userspace may elect
> > >     not to advertise one.
> > >   - and so on and so forth...
> > > 
> > > Yes, there's a small mental jump to get from "KVM supports in-place conversion"
> > > to "I need to set memory attributes on the guest_memfd instance, not the VM",
> > > but I don't see that as a big hurdle, certainly not in the long term.  And once
> > > the VMM code is written, I really do think most people are going to care about
> > > whether or not KVM supports in-place conversion, not where PRIVATE is tracked.
> > Sorry, I just saw this mail after posting my reply in [1].
> > 
> > I'm ok with gmem_in_place_conversion=true just means KVM supports in-place
> > conversion, while we can still create VMs with shared memory not from gmem.
> Or what about "allow_gmem_in_place_conversion" ?

No, because turning on the param also disallows setting PRIVATE in the VM-scoped
KVM_SET_MEMORY_ATTRIBUTES ioctl.

> > Though it still feels a bit odd to require TDX huge pages to depend on
> > gmem_in_place_conversion=true when shared memory is not currently allocated
> > from gmem, 

I fully expect that to be a transient state, and in all likelihood not something
that is *ever* shipped in production.  Landing TDX hugepages without guest_memfd
hugepage support is all about avoiding unnecessary serialization of series and
features that aren't strictly dependent on each other.

> > it should become more natural over time once gmem supports in-place
> > conversions for huge page.

Yes, and I want to prioritize the steady state for end users, not the in-progress
state for developers.  Once all of this settles out, I fully expect the majority
of deployments to only support in-place conversion, at which point the end user
is only going to care whether or not in-place conversion is enabled in KVM, not
the subtle detail that it's still possible to do out-of-place conversions (and
that will always hold true, it's not like VMA-based memslots are being deprecated).

> > Besides my current usage, there may be other scenarios where gmem memory
> > attributes is preferred without allocating shared memory from gmem.
> > (e.g., PAGE.ADD from a temp extra shared source memory).
> > 
> > For such use cases, I'm concerns that the admins may find it confusing if they
> > enable gmem_in_place_conversion but still observe extra memory consumptions for
> > shared memory.

KVM can help with documentation, but beyond that, it's not KVM's problem to solve.
If a VMM *and* platform owner chooses to deploy a setup that utilizes out-of-place
conversions, then it's on the VMM and/or plaform owner to understand and communicate
the implications to the end user.

And I'm not remotely convinced that prepending allow_ to the param will help
end users diagnose "unexpected" memory consumption, in quotes because anyone that
is deploying a stack that utilizes out-of-place conversion absolutely needs to
understand and plan for the additional memory consumption.  I.e. if the memory
consumption is "unexpected" to the end user, they likely have far bigger problems.

