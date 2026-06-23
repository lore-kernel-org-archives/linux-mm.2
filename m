Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB68BCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E77F6B0096; Tue, 23 Jun 2026 04:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF206B0098; Tue, 23 Jun 2026 04:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7286B0099; Tue, 23 Jun 2026 04:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5806B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:20:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A8481A0448
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:20:50 +0000 (UTC)
X-FDA: 84910481460.09.B787B47
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 80C4D40009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:20:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a4kWolYf;
	spf=pass (imf27.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782202848;
	b=PRSk2PsY8xA+lmqVuZuum/YLcjrtATNW+ueN2sjl8gJ08J0Fo9wD6M8ncNtfyOTwfeuTSx
	60b8FWA2pr0xf9DxKb3oWTW17Z7hyxHHqDQvTq7eau0GQatGdkxDnUbMfui2DzEizzyzJZ
	QxtGa5DBilfpgPVXrzUE/xlGQjvtmEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782202848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXAENCcp5BDbPSOsn4f1upfQaIKMcigDEFtOKnyVkvM=;
	b=2BnP+s2wzpf32motVevqlCJzg5H/OSRMUWqzOmMvVQa7U27FlrBwvIJm1WYZUH8zDLKDQE
	qjHKHtFTE1vCWmv/sUH31FWXIxSTD+44cz66yeQMvpq+/f9Qzj1a8uTyIrsEm53SsAOxgR
	KMVIffcjSkaieDJZUFdFm16fxW9DgO0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a4kWolYf;
	spf=pass (imf27.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AFNElJ8UKhbjSwtZkxkxnip6xllM/7pxyDQxczycfJI8mvwQ8oxaxIyaB+lhmQBIvr1DNsXAfi6StPh2Tg==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782202846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QXAENCcp5BDbPSOsn4f1upfQaIKMcigDEFtOKnyVkvM=;
	b=a4kWolYfP+oAyRKjJJ92ku5DrejiTBPG2MZxl9sqLPBTA96QFzyTQxYx1IyTXIw05odeIt
	w2JSZZKOsctDxIIYNBhNjR7R/JdB+F0EPggNzIPYPPe5pxfx7DopXnqpt4E/UWyGdlvpob
	XtgukHhQqEMi8xCHr+N38yBgCRpfpJU=
X-Gm-Message-State: AOJu0YyJjoHQJW3FiC9dDLNigfUXUK68CC2lywTi1fayb22v69EzoRgl
	V0ZgBEIS/17adx4/5lFytQ7PfPIEIwi7LOh46G5+JZP2KvvLaQit1HewRK/eebJjkReibCvc1+d
	o/td+uwm5blNvhup+oY7XZ9yvnf7UAy+d8E1SKEEX
X-Received: by 2002:a05:622a:1246:b0:519:f8a0:16b4 with SMTP id
 d75a77b69052e-51a522c6f26mr6874451cf.14.1782202842728; Tue, 23 Jun 2026
 01:20:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
 <CA+EHjTx2xKjheiW5VzHw_TdWFUqdJqfgu=dOPa=_yaYBMY8uyw@mail.gmail.com> <ajnRxuJ19OzZ8zJC@google.com>
In-Reply-To: <ajnRxuJ19OzZ8zJC@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 23 Jun 2026 09:20:06 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwLPCvZJgPv=8u3pgp+kwEwQbsXn_13FL3xUbJ7HRfXzw@mail.gmail.com>
X-Gm-Features: AVVi8Cd8AX_ogmuHxl3lyKLs763XEWuLTlPOQRHFThhzmhUCsdYVCq6sKYCvrh8
Message-ID: <CA+EHjTwLPCvZJgPv=8u3pgp+kwEwQbsXn_13FL3xUbJ7HRfXzw@mail.gmail.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g1zhyza3jtzwuy4mhg8a3a9mja74gs5j
X-Rspam-User: 
X-Rspamd-Queue-Id: 80C4D40009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782202848-429973
X-HE-Meta: U2FsdGVkX1+YVmvV/1/fPmbBux9Qw78d7DFDm1IZUNkYnaKyqnerkWV32sgRxkYXq5Fi/EEthfNf81iPzbO0d9l1L42WsfaBWUYMhZkKNl47FhY2z+muBkJqJ+++sfAEag3TXcHLH6U34rdxVKOPu75cjwjcuwbap9TfxM1VtBG1G4X1GK8ubYkBJSFz5n2BE/NPZTu/kXmyqWCpcCnt3d9jhhHdiVhBXmIwYAcPJ6dSYicPdspHM2srzNmyeucz6T3M6lD/ahGHbiG91SWbF7q0zkWfsVahpxQLNOy8qjpTJXNsJbFF9zvzsQ3LhyI7BMorD5B1Yz7p2jUez8P5RkZM+EsWfTpLNUnIPjOREoQLD1AL12AqYDxXb1oFcbiFN/C/l5XJ+dGCXiXVMLjxKGL3WBJjQWMD72C30TQMBU4PNNkbdZGGIi+1Jxkv1dHCDITHbSVg3SSzuP1I4/4J1dX1lPuvu2Z2/It68jzA2JOgapTBsH28hNNZYE9ic5VCeT9KM0fLsV33n5oxyIBTrwTJnfpodLntw0JH3SzPLO/CwRlc/XL0VoPqnE5NKmlm84S3b3Xc6VbkQ+9r8kuGz9R2+g9rF3wJ75dxlaQgBvxtgdWZntxBUm+Dm6R1228lflVkP1oJvqijackJKPVT3QpNv4SmDEJJedm5F1cbdb2NAwPOu4d011YEfz98GslUuaYEc8d9PonK4FoFIfT5qLXQvwDYaoypFY7NMNhxIdQWXJzYePeFugfXOwaKMhYHtwJ0tkM/0epgbnVR1jHoMzLhWcHAX9LOsk5BeT6+msfCS663x96X/U+19qNnkkhO+zCYe5kP4ha521JRsOmPXaLwki/p5dLcigG1yQ5GSzePIC/0vC6wGQYv7hBo4Ljss3nnJirYmVK59beW4JZzo8Yv32+Zrxu11hdYU8Mgqais3lgVEVKyTkIzNwizUNp31tEf3/ybQ2JmlncJho9
 CP1bOmaK
 BlWOtb2EHZT7ri/s4ZPibVVg7Ksd5lf9gnQYgiSn8SEyg0jxg0oElzVGj/8aFMyzj4mQgemlijXuUzFJ79RxEbnrDUJoRcH0NbVN13B7XnGfuxNiy/AwDOqJZEAtUB91zBQboEYRQ2oibygznbF6oYmAIN/G+zKuBr19n0L3QMOolVrApI4utimwPUZK+Fb4vK/jmeW/3Z2wq6A9a/5Q1Hjq1xSiHu/l0MtQqPZ8HT4is4wP2WDDzw6pBKVyoZwN/AVjmQPkjlgfpOTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 at 01:22, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jun 19, 2026, Fuad Tabba wrote:
> > On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
> > <devnull+ackerleytng.google.com@kernel.org> wrote:
> > >
> > > From: Ackerley Tng <ackerleytng@google.com>
> > >
> > > Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> > > just updates attributes tracked by guest_memfd.
> > >
> > > Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> > > by making sure requested attributes are supported for this instance of kvm.
> > >
> > > A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
> > > KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> > > details to userspace. This will be used in a later patch.
> > >
> > > The two ioctls use their corresponding structs with no overlap, but
> > > backward compatibility is baked in for future support of
> > > KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> > > ioctl.
> > >
> > > The process of setting memory attributes is set up such that the later half
> > > will not fail due to allocation. Any necessary checks are performed before
> > > the point of no return.
> > >
> > > Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> > > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > > Co-developed-by: Sean Christoperson <seanjc@google.com>
> > > Signed-off-by: Sean Christoperson <seanjc@google.com>
> > > Reviewed-by: Fuad Tabba <tabba@google.com>
> > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >
> > Note sure if it's user error on my part, if I'm applying this to the
> > wrong base, but I found a build break here on patch 13:
> > kvm_gmem_invalidate_start() doesn't exist in the base tree. The
> > function is kvm_gmem_invalidate_begin() here. The rename
> > (190cc5370a8b6) landed via a different merge path and isn't an
> > ancestor of the stated base.
> >
> > Patches 19 and 20 have the same mismatch. Fix for all three is
> > s/kvm_gmem_invalidate_start/kvm_gmem_invalidate_begin/.
>
> Ya, Ackerley used a slightly older kvm/next to send the patches.  I at least was
> testing against kvm-x86/next, which does have the rename.
>
> Other than noting that this should be applied against the current kvm/next, I
> don't think there's anything else to be done?

Agree. Sorry, didn't mean to be nit-picky, but this really threw me off :)

Cheers,
/fuad

