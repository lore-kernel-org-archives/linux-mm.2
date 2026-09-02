Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B3A1C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5926B0099; Wed,  2 Sep 2026 09:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE0E6B00DD; Wed,  2 Sep 2026 09:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15DF6B00DF; Wed,  2 Sep 2026 09:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C44266B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:30:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 429B51A021D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:30:38 +0000 (UTC)
X-FDA: 85168906956.07.EC4BCAF
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8759E2000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:30:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="eo0/Ov4Z";
	spf=pass (imf03.hostedemail.com: domain of 3-iSYagYKCAEtfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3-iSYagYKCAEtfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355836;
	b=E/tfBOmj70nCO+x59FJfn1DxR91Qna/KHAn9GOk0UZvfuL9m9D/IgMoXFR3orj5G9da24D
	LLDrkjSenIl9f7Yl7n0Ptkr3fyT94vpOWvtizIGEv9MLPOr2t0B0d53gamAe8oK/D2ptf4
	5RKe4Hs0vureZ94H+1hIZLVb0lkGsg8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="eo0/Ov4Z";
	spf=pass (imf03.hostedemail.com: domain of 3-iSYagYKCAEtfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3-iSYagYKCAEtfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjYXG96MoSl8fTQZ7UxomEUfCMCHuYclL43aTeN6TlM=;
	b=kQm6KynZuJ+KuJKVByfecxQMkc+Jpzk9jUsEwJ4bghGMlm1pQOybSp3CPXPJbV8L+U72l4
	aHuU8C09vx1s0OZGWD7+xVDy7/n+SafK0KEHcQVlbNhbJ4ZNOv6SiWwDI7A4ODvV9qy+17
	3s/RgCE2/2WcgyICiPD9IpUXoGk70yM=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d70d8839f0so13233305ad.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 06:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788355835; x=1788960635; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mjYXG96MoSl8fTQZ7UxomEUfCMCHuYclL43aTeN6TlM=;
        b=eo0/Ov4ZWYvQXfmgYqcAckIYkDj2OGJ+YzFX51ZTv9buY+c3mxuqZAUfN7HlAYVdOe
         wDhHGUh3fQk7SpH6Kt6IiPijWQ7M9JynuM9+nDCvf2MqL7Vf3AMfnGaRtpYWq+p363Zt
         q5oUOzQrkVytzPQL5QRQ5NMZceBbAXq50j258ACXfwBeyoTQYGqbQ4nZrWn+e6vhpRUt
         eFqMvJFF4j4RUvX8qnkxeJHWL4p7TlSg0po4AeeVhfDjhQfE9rsbMkx2o8YRrOItIm9r
         nS1TP3cZOvfLiily4RKv27ZBkKjsBJaiBoVgNEGpF6mtCPCWqSGicNMKxZFjozbUNXEU
         dq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788355835; x=1788960635;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mjYXG96MoSl8fTQZ7UxomEUfCMCHuYclL43aTeN6TlM=;
        b=ZGVwgLl4JS+lEbOh4+Ri68WZfQRgjER3aifuMimLtzy3hjzrRXF14RD76pUSI7L5uT
         6pAKgsnLXOwyO0zp5nt7epupGG09eNOK8nyyFBFN6tBM6dK8CbcUVVHXwkBLW44oOvkv
         UPArHyZ5oEfN2VMfEV7cUTl6IK9HQ1yYdRqvv/8WoK5lGALXRLR4CFeV813sbluaSFoK
         pQFIh9JgAEf29VLM1fF5VAzhxZ4oApyKwWz/TsuVI6P4YqaPe31sK2b3u57K4yKWxTQn
         A7E+Kw6tEUiWVGD+hedyaCxeDgLAsZSZs4qpiMJVYR1y+qXsf72pmYS2I1JdTKjvpuMi
         Ye4A==
X-Forwarded-Encrypted: i=1; AKwUvBzjPx+HEJp5+/ke7NacVQZUNBYIoL0RMdgGgvIluSlH3SCBYrA66j0X8+7F/vj7s4uI1T/nwmVBsQ==@kvack.org
X-Gm-Message-State: AFuF++nRriB+eihMiTqJaHHOPIm0M6uSekAQQwXWTXZFtEMFtORy/RnY
	AVv6GC/B1PtXXoTWXpI+RfoICu34g9o1NI0RU/jty2ZjVtjG7mxC+CYn051ICmrZw5e/OhVdfje
	qYFCR4g==
X-Received: from plnt11.prod.google.com ([2002:a17:903:196b:b0:2d3:7166:b1a6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8b:b0:2d9:43f6:59f0
 with SMTP id d9443c01a7336-2daec7bae38mr68887665ad.22.1788355834704; Wed, 02
 Sep 2026 06:30:34 -0700 (PDT)
Date: Wed, 2 Sep 2026 06:30:34 -0700
In-Reply-To: <33431813-fc94-48fb-9042-5cfc68af05b8@linux.intel.com>
Mime-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
 <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com>
 <apcY5b2o5k04XffH@google.com> <33431813-fc94-48fb-9042-5cfc68af05b8@linux.intel.com>
Message-ID: <apgk-nKsB31WVCWp@google.com>
Subject: Re: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, ackerleytng@google.com, aik@amd.com, 
	andrew.jones@linux.dev, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8759E2000A
X-Stat-Signature: wb7zcbmeasrh58qiyykacddhntz9fotw
X-HE-Tag: 1788355836-274308
X-HE-Meta: U2FsdGVkX1+YaQ//9BklVXikd6uYxkT7eA+BUqgMqrIOmwFMi0eM+jcgMY8TiZM0najb8WMbx27PgC5lIGvHTf52WZdtuAhFcRPTjmCiSFMMnI/ZvYXq6wiFu8lrCjOntxwvR+AakUF2ew+Uf8aCIay4vdDGbUXyZsAhTOjv2np3gall8sr9upTzmHrt149bCMqiudakYPeRzX2pUeu4i7YaxPMNqs95rkmyYfSCuQJRcO9cCwnF1gEpRNqrMKq98uyL5/h43N7GYChRrx6QwrhyKCyQhvCidk1E5f+E3y5r4DYLdB8L+XcPhIX55vWAK5GPaW9rlbLlbgt+LBiuC3qI14a6ccO+q8iGKjIApkIcka+5ndm5FcswXmdPNm+Y5ZyuqGNh8N5R1QTIavBT1U4kx/3d2+rWx3R1y1izzJbJOgINC4puMwQJDKxWXdYAtDRGvXAq58/cOQIpRgtzUn6Y8y0pPMUOOGJ/8YzwF/54SgSGZl6zjPZYAPF8POPig1wwbpIaQ1wWdBPr4RCXS7hEDggKw6zRtmISelyFmMlvp9gAbjbKSUFnfaBcn488zeUuh0WvA8qJwSj02DJ8i2O0nVl8fTnqYGXILOAXGmdvWAOrXBLT9MQAPSS01c0g23eVhLgad5VZqDQqYE4YPob5VAWI3nvfyXELQmJCqo4K8uC9PJncfEHW80CyXoLU47mBHBEjV2jW6dzYaTHxzHpF631K9mgJ5TUfOu+0Rox0FJmBy37+oXh74P8H2+BicrTv7D0H5lg32b36va2FqlMoHsygqwpGqPpidG/8EqCNMEkm1VK/gGtZalFj5j18dxS4WtOhFuKo+zTIEVRPjwrdR/KUo3tru3fHngVs5rDYd+Od3HENmQwGCbVK4g1wcsZ0DXcu5KE7ypKzJTNCbbW+3hfsjnXu7CypMQdLDz/h3usVraA/wKbhhTOjzFmFr9D52VT/u9Fa6k/GuOu
 Imh2cjZH
 7Nn94rDyWnqHfH/iqV9ua07/Kde7sjqcH+AbLgPgjyAdCYrbOnYIw/axW4sFRyqjaDMrTmuDzvbrLScJpfbqhvJATA+NDCUgrJu12UOxW/O/4Lc7mwUrUtPa9krIfYWBTOSd8L2TVtHmLwXyVEvXVMQIoej9ZPTi1ISG2CoZtxIuJBM+3fvulE/uYEL8Er6jpfxZu2zTTaxftW7wxBXlO6jvaU+oq6E3i82CNbIeaepQy7P92uRMqUGeuUsyzs59z+zGiNcOPd40vrvVPYxkE0ctHd0KPWmrqVezrFygZZw0HUGXMcl/gigZTuaZjMcwyDFa5SmUjBBNjgvhlAxIZ3+Pcw71nPXgf+c245qOHWUzu+FFxOHheBWlts4BHxD9bpVznzjx+2BalbQPO2HIFFB2le3eM0DqzPPLoYLqg7v5QDMj/xw5CvwnwvrkLa9lQ8elwZCtUMzADQQ1abvPzmtmSvDnetqZ5x1V5CWhb5BAIjkLCtfV9SPU3lx4YWpp47BlIZnctpx+mKVdpK3Q34cEm7JdCy2bEp4CCfzs5Wt0uHcEYfYigaWvW/vWDxOoxeApOfhQX2sZim3HN7B8TxpYc9kZglDiP9XxheMfKv3q8DxNUG7UjkT+DyqZfSIxvYLZyEHqfFn68Jqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026, Binbin Wu wrote:
> On 9/2/2026 2:26 AM, Sean Christopherson wrote:
> > On Tue, Sep 01, 2026, Fuad Tabba wrote:
> >> Hi Sean, Ackerley,
> >>
> >> On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
> >> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >> ...
> >>> +       kvm.gmem_in_place_conversion=
> >>> +                       [KVM] Controls whether KVM enables in-place conversion
> >>> +                       support for guest_memfd and tracks the private/shared
> >>> +                       state of memory per guest_memfd instead of per VM.
> >>> +
> >>> +                       If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
> >>> +                       ioctl on guest_memfd file descriptors and disables the
> >>> +                       legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
> >>> +                       private memory state tracking. Only the
> >>> +                       KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
> >>> +                       per-guest_memfd tracking; other attributes remain
> >>> +                       per-VM.
> >>> +
> >>> +                       This parameter toggles KVM's in-place conversion
> >>> +                       capability support. Whether a VMM uses separate backends
> >>> +                       or out-of-place memory management is determined by
> >>> +                       userspace VMM design.
> >>> +
> >>> +                       Note, this parameter is only available when
> >>> +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
> >>> +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
> >>> +                       conversion is unconditionally enabled.
> >>> +
> >>> +                       Default is Y (on).
> >>
> >> The parameter is only settable when CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y, and
> >> in that config gmem_in_place_conversion initialises to
> >> !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES), i.e. N, not Y. Is the doc line
> >> wrong, or is N-by-default not what was intended here?
> > 
> > The doc is wrong.  The intent is to maintain backwards compatibility with existing
> > deployments if KVM_VM_MEMORY_ATTRIBUTES=y.
> > 
> 
> Will it result in the situation that kernel builds with CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> enabled by default for backwards compatibility, which requires users to explicitly enable 
> gmem_in_place_conversion by the kernel option? Then it effectively disables
> gmem_in_place_conversion by default.

Yes.  My intent/expectation is that the only reason to build with
CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y is for backwards compatibility, and so it makes
sense to have the existing behavior be the default.  If a deployment only wants
the new behavior, then it can simply build with CONFIG_KVM_VM_MEMORY_ATTRIBUTES=n.

Folks that want only the new behavior but are using a distro/pre-built kernel will
need to manually enable in-place conversion, but that's not too onerous, and it's
simply not feasible to provide defaults that work for every possible scenario.

> But I guess it's OK for CSPs since they know what they want.

Yep.

