Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5912DC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FB86B008C; Tue,  1 Sep 2026 18:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10BD6B0092; Tue,  1 Sep 2026 18:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D004F6B0095; Tue,  1 Sep 2026 18:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A223B6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:23:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BF25C0576
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:23:03 +0000 (UTC)
X-FDA: 85166619846.26.32BF110
Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 378B91C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:22:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IYis+cU4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788301381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tItatVelxApRggV8QYFs7ub6jjny/UPt+MFTfMtjPCs=;
	b=bAx/bWDcDn3/XUZa8QITEL/OLWJEIp1u4jl8uLPg/xFp8r9aRV5q+LlXC+xpaN0nMCVY5D
	2XXL17+Ma8i2RQ+/fbTkMpaXH0JY0qGcxNtBP9NFjPofpQP53qTAs23eV9zKaFNSFFbedk
	uAu9l9Bj5JxX8XhZgI6N/dKWzOr9oLc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IYis+cU4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788301381;
	b=0arzU0NK6o0T4IoG8G4FC159HZRD6RhFOjrzkX+ru5juGrLEhZO8pB170oJ2bV2GKNIlU0
	i/H8R2rRkcBN1j1yAz6SEo+V/S8nMwU5O5A/c+FNm8NO8aTXg5sz7FIpE/iETFx+kdJV/f
	+AsGRQ3S0I6WzUiplOao7uMRzPov/iA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CJv9ej77YKh7SqREZUkX1b/9RiHCVq3kJXFgGW0/pcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788301376; v=1; x=1788906176;
 b=IYis+cU4Twr7XNg9WPxCUfI/uHkWPVvVuhNplQPNiYrsFRa4G+gMV04dgVEePyR53ulj8drg
 EAt4/tfoVLGRcqfrPIficlvOe19vJFFbxUqpf3zsxJMLv6i5Qgh5s6F3QdgqUFwihikmSWQrl7j
 48CYjSwKBAVmQGgrLnic/mBg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fe06e1861eaca76b;
	Tue, 01 Sep 2026 22:22:56 +0000
X-Mizu-Trace-ID: fe06e1861eaca76b
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so3172e87.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:22:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzUmW3aLAD2CTeAZgg4Jg+sm6zQXLgm7Wggo5EkAP7ALAHxMWb0tgNYosDrZ2VhZhu4iBFNOSTtww==@kvack.org
X-Gm-Message-State: AFuF++mTVIpw6m7sa9TqIjvAAYNXUDsbwCAui4jb4dxNF4uswdk/Kpt/
	9npjYOX4tdRMyeFfpQrPsRB0/H2f0zKVp8EXgpEju6cFSd5sGPUBvV7km0bXkTx3Y1MR5LVQrn5
	BGXsBV0c6IIvA4L7UtO4yaJdfHE6e5UGLVFqYqhVr
X-Received: by 2002:a05:6512:3d0f:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b609eeb230mr13703e87.15.1788301371454; Tue, 01 Sep 2026
 15:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
 <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com> <apcY5b2o5k04XffH@google.com>
In-Reply-To: <apcY5b2o5k04XffH@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 23:22:15 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyUke815MNgCh7kEKw7JEprRG754gHi3UJ6R5RdbuUhyA@mail.gmail.com>
X-Gm-Features: AcwNN1XG2R0freerIjVIIorEq648d7QWyFSXRnqa21AMKowGv086HSc-AbV0xtQ
Message-ID: <CA+EHjTyUke815MNgCh7kEKw7JEprRG754gHi3UJ6R5RdbuUhyA@mail.gmail.com>
Subject: Re: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ohj9kgyafd49utkunfrj7xnn5thm3g5u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 378B91C0007
X-Rspam-User: 
X-HE-Tag: 1788301377-928189
X-HE-Meta: U2FsdGVkX19EKcor6iM9zhtDtBYuQSCl8lq2ystV64KJc+bHSnEuH0iS/Man7BDLK87KkWEojWhwmaQ5db54ec0Ml55E7c0Y22g54IRGrmfBOSSVdCiRT2QuQ6bBwKFA6uFklw45fjwPhoanCr+cr9sc8SdTdUcTz/RwDLGY1AzOSXMhkD39kexM1cFevq998sBsawGkx5qZQ0D3Vj4OEIQJvcK/ZEw9LpRDHiSmdAEySF0X1XHOzP5j7tYRTjphJE1EHQPdBzSVZJ9wEKYcEl6GitKglGa7ApA+ZMCN327TwumCK0RQn8GtpYR5LfViZZUk0daKK74R5ta7UXF7m2XDYbgIrfpd7pE6AvQwjFKHT7yIVN0NPkatJaS3mY1VW/oI5yNNbc3DJEaQc584P0PKgywJp+ODsady3UhOLYqkK+UzVBC4Kvvz4IK2nanZFZnjacSEER//00mY3h13jv9HLcl37WQVJJl0s+yvCf7IE5aeiBb0cBXNh5VFxERrDIVSDpCIrIA+CGJN8t34ZN3Ww+wXygFwzd+CCjE+hEgk9U1ZwNr76UnMn4RuyNPExMhqyGICOj18WwO6WebWCrtqU3xCfymtD4Taag8WFwvQ31egybAhlIRfeIbIES8+MIZbbvAeSmuClaBjUdZxXWm6+R4wOtmjJfSW6m/2pFV5qkS98tHuuuf1I3gE9TU11m3rijaw2bVclBSgLh8XknhKun70JfF9iG+fL/irNAHpzVDOvW+sTsuBdD6vX8V4PdvaeHIJfLSvCaseBZ/TsbCzTRh3moBqnPX+l3jgRuRwIEZupp3hVKWrarkBxDUtwN+RNYRRTsM1HNPBN2DiqDGs8XWKr09nh34zYZzDYykdPATbYKXp4QxBWqiELq+qB3+lM0DBrKlrYO1pA5Kvw4vk2glpzch7vUI18cJmYkkvEKp3vq8uYlnaEL4jZr9ix4fLYMv9d1/dgjc6v2q
 YwcK7Pk5
 hKoZBXH6SejYkaEPManpuSTGHkiHT22/ToXR7pN1NaToBNB71gCwdwT2/xN3CXCID1SFeXFhsXD0RbAPqzSMcM6gIWhHxAcSjkG6CXzPg0JJg3XIWI50ROP1Gg/WFSwxMk/VUtym4H7daB9Gl1A1n1MBUoDGRi1EDuw1iyrkfffOidMnmSNRcl/YUYkX4JRc7TevzX0pVewoo32XZJJktyuprlzGmbmfVMKxXVmrbkLuJt+xWAsWf8l9lJqDJ+htN+8sfKBn1xji+L5LMYLult6dQrv50x7Ze1RlhrXq/116i1ATpIhKCHWoYuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sept 2026 at 19:26, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Sep 01, 2026, Fuad Tabba wrote:
> > Hi Sean, Ackerley,
> >
> > On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
> > <devnull+ackerleytng.google.com@kernel.org> wrote:
> > ...
> > > +       kvm.gmem_in_place_conversion=
> > > +                       [KVM] Controls whether KVM enables in-place conversion
> > > +                       support for guest_memfd and tracks the private/shared
> > > +                       state of memory per guest_memfd instead of per VM.
> > > +
> > > +                       If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
> > > +                       ioctl on guest_memfd file descriptors and disables the
> > > +                       legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
> > > +                       private memory state tracking. Only the
> > > +                       KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
> > > +                       per-guest_memfd tracking; other attributes remain
> > > +                       per-VM.
> > > +
> > > +                       This parameter toggles KVM's in-place conversion
> > > +                       capability support. Whether a VMM uses separate backends
> > > +                       or out-of-place memory management is determined by
> > > +                       userspace VMM design.
> > > +
> > > +                       Note, this parameter is only available when
> > > +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
> > > +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
> > > +                       conversion is unconditionally enabled.
> > > +
> > > +                       Default is Y (on).
> >
> > The parameter is only settable when CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y, and
> > in that config gmem_in_place_conversion initialises to
> > !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES), i.e. N, not Y. Is the doc line
> > wrong, or is N-by-default not what was intended here?
>
> The doc is wrong.  The intent is to maintain backwards compatibility with existing
> deployments if KVM_VM_MEMORY_ATTRIBUTES=y.

That explains it. Thanks.
/fuad

>
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 05c518c9b8078..929fd3e1a01e6 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
> > >  module_param(allow_unsafe_mappings, bool, 0444);
> > >
> > >  #ifdef kvm_arch_has_private_mem
> > > -bool __ro_after_init gmem_in_place_conversion = false;
> > > +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> > > +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> > > +module_param(gmem_in_place_conversion, bool, 0444);
> > > +#endif
> > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
> > >  #endif

