Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A21C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3586B008A; Tue,  1 Sep 2026 14:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B876B0092; Tue,  1 Sep 2026 14:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582EF6B0098; Tue,  1 Sep 2026 14:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD2D6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:26:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EA8A1A04D9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:26:49 +0000 (UTC)
X-FDA: 85166024538.27.3ADB228
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id C8F4220002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:26:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lu4oJEvH;
	spf=pass (imf13.hostedemail.com: domain of 35RiXagYKCM4Cyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=35RiXagYKCM4Cyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287207;
	b=KSILX12yJr5fxmR0PKdQazYaRfvl1wnJYGegAazJ517gPvuy0rw8A4EaHklIL0IwYYKiz8
	NrDhVJ3f1flW7bbTwsulfZLQaR6jCtvf9vZLT0XwHXe2bdVsn9KMQd9rtrd7oo/xMYghgV
	dmsU6HUm1iIH9DNTMW6HasnJDvRu/dc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lu4oJEvH;
	spf=pass (imf13.hostedemail.com: domain of 35RiXagYKCM4Cyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=35RiXagYKCM4Cyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v8dwO4qIccjpXs9ZdhBw1lluA5t2BNdQSYlylga9bQ=;
	b=3+LIgcqfF4QTxLLSPWqT9ddyxFedpbIqceRfoa8LOL1V763YEupO3d9RFqGubXJLe4uI9b
	Qctg+vvX95hqEFawbuKnSc36MxeE3U1ThzUpWcSDz5Cger0KVBFUf0JrprTCQrqMyCbUuT
	XoVxvE0uGu2H+cMncro7STqQ2WUtT24=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so150896a12.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788287207; x=1788892007; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5v8dwO4qIccjpXs9ZdhBw1lluA5t2BNdQSYlylga9bQ=;
        b=lu4oJEvHkdt6oecYn67M6nuerlnHXDKwqCHcuqq9JrT8LgRvqWuqTTE5heBxb0oWYy
         ZW5Zjk0gtzuKXK59r+VDqJq+ptl8v+DeA0zbZY+c2B4p3nnIBJuprmXH4E9wleRnraxp
         ppy6WprpG1CQU0AxM2dc32CnVAUiucVq7Wz8rmiMYqBNdlUEznUCVGrafmvB98eJ5B/I
         t+CSwSyP4B+8GZcdhh3LDpcT9NbkZ/LzXGuPU34vIE1LG3YYox1d1XS6CmuCRXSwt2nr
         Lqq1uknHIHR94VqY4+Mkt30XF0aoqaxBJleedBr38NTj6I1jbi7e0ema+JFxCgJkuPKY
         SElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788287207; x=1788892007;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5v8dwO4qIccjpXs9ZdhBw1lluA5t2BNdQSYlylga9bQ=;
        b=NXtWK8MVm0D7RKN96J3iizek7FffoDW9ZTK0CNVMutjYZ65m0+atIfHoopXcBhS4XV
         MmSsJOxCBEhNVViGfmCYW4KM9jwc6f4bIpn00MON4snaOa03uqwZ8Q07xFfntzB4bDFs
         K2K7r17nFAmlRADwrwO173Z8pUakZLLZ4GtxQ/WB2GJHyCuZAoFilWXLuJ1BN+3B4uxB
         AW5lSasUKz18fojyammCfJuK9xaFGrrYxwczGYaRpjkQB4RNnAtwel43JYQO6inMlHJc
         y5vqKujdATp1F5+xBRoalVfVRG6ugXk+ygxjBu4k59J5lnZB4EXe+9p9CKjSIoXC/+Gj
         D/mA==
X-Forwarded-Encrypted: i=1; AHgh+RqlfoBiGkj1Biu6Ho7B8q/UR19iH2Gg5gA8TsLJZdRW1LUhZqsRp2xMt37kjhccjNRIUCrA8pt1RA==@kvack.org
X-Gm-Message-State: AFuF++n31vDjONFS8EaQaCgSk7gdnp0LkfWR+p8XIX0SfXCHPSqRHoGZ
	Q7D3uJdBNd24Ue4DHojVXqPW6lTDJ/yZlSv8hvcPWVqiUlNMWg680Zdt3jLsi5PtC+RV98s/ZSr
	6nNpzaw==
X-Received: from pgbd18-n1.prod.google.com ([2002:a05:6a02:64d2:10b0:cc3:28ba:e8b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7284:b0:3d0:cc29:ff63
 with SMTP id adf61e73a8af0-3d7ae4ed97emr13763648637.12.1788287205983; Tue, 01
 Sep 2026 11:26:45 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:26:45 -0700
In-Reply-To: <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com>
Mime-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com> <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com>
Message-ID: <apcY5b2o5k04XffH@google.com>
Subject: Re: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8F4220002
X-Stat-Signature: 3daniqa5aujk9hr7rj3tifswrbrpncgz
X-Rspam-User: 
X-HE-Tag: 1788287207-56856
X-HE-Meta: U2FsdGVkX1/WHJfGfQzOsQ/6IBTCtY5QHTlpbzFMfYdU3tPs3MgP+LaOCajlJVQnJxwfRjz1kPYcoredO8KD02+HDV6waGvOMd83ziBn65VUzzYxLWylDfDzQoD6ky9sX75hfIRyVpMzWw8aD/4zz35nwSndox/vVXeFTh0AdJSDYF68CY1phJu23/OVltbkB58o/VLd0D0sNynbVCJMX+q/GYD7ExKe+H5OYpBGr9NMe3j8LhZArGKXfQ8qGxwvoPOX6Xcs8lTO7h13mBUHYg6nUQwrTu4s49usVFOCJ37gqP5N7yN6Z8oAEmR9ghgkjvjWd6VYYO6lF2N/M+nL7IAm5guYVfygkTMcMh0vp81nulFkXJljPUsIwKvt/QLZR/6QVDRPTBxr4edjlCXZ/Gxx1KqOMfaRXkIxdAqw0l5LouLxLyJ0L+uHyrPsNK5OJoV33NlJXILA5xJerTu9wbWkpZYAUoi+d+fjAAY50YRC2napsClI6HIehPBfwJYJND79QkxMlPuSsJB85q5/o6oUHHCGdebzKFZRi5vXwkUxXNk2TDIN1ryzs1BIQtr20krBr6N2MVaFG7oDv+tSozFGmxQhLgPbbv/0mJfZRiQS7j2snE9g9bEz7C3FOrrpaFLqrpeLW/W1UckFNRDYcuXjRiQpUwItMq64J5bKeDDtKwFMN9Ozctu5Xvej47wmIXEqcUHS/WGoNTCpOFXymkadggjub+HHVZPTqE5I87VPLG9mwYrRpuIu4nISidQkVV5piUG9jbjGF6swiYW/bqMKuSsNyXqBqnpeilcPKRERiZQVIBtafVbdWhYK3lBzaT3+pRGaeoV+jIBVwAXvU4BhrUE0plh2Gs6oUd7t9+7DTp9zld+KwHY16v/2u0P9YR/6PWKs8HLmyFCql8BLM6o5cxA0q4Ffd7CCC295n1gvNZK9v0TKqwrQaIWDoO0mSFx1Kqoimm0GYXbc7Me
 dTinB1Qv
 F1w8ZTI8ZMHrMHMzNxEWeT5ZU2Ey2n8X6lT4CUCvLoxTYaLdRdPoAZENHPs+jgeoQIjPADb8Ifi7y05Cbw6RvWk1rt/FvbHs+5VwOeP/XPL8WrTaPnnkh9Sc66PAcceIa5x3rBMGrKZtzXDcIGw7F3qMAtG7HNs3ii4U1oUZOl7jI5izfv3AOfL1KDkYQfIpQZqT4QgD60wu6/il+CoRsemanei23LkixNs2bEyBtlxyNZ7u1WD0vKACqtAnybhLQaeRsvKOOtJ0bpf1Kse+0ZGmL7ulHsVyaYYQMNSkRcuan7IyEkIgmceDdkcwytfF5msvH1kycGZoVCYjrZqqILenuEu4LfxjfRiyiCb5gbELFbWapWU0G1XCLOTGx1lXuueZaCmz1JCDgdJFH8HxB04QZZyeGf766aRyqA5oaOY7+yJgbZsPcT4KeoSip5qCU3p7Q+vMnWzPICLHjSVTOx+h9kmtDEvjHFJaAgumRGIZ2rrJEp+6ZJranCQAVCLo9Or6FOnrDbniri41oOb2ezcLtvljKn/RQo0whWiDsB8TE9X2kOfhGKQkZm/aUrOhgwlXFDT7xFj1eQpBeJ4pVeX4gPmDHHYW0DOCuihBvOFDZx0GNiDPBBEmxn789uyWQoatVG+gAXfik/As=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026, Fuad Tabba wrote:
> Hi Sean, Ackerley,
> 
> On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> ...
> > +       kvm.gmem_in_place_conversion=
> > +                       [KVM] Controls whether KVM enables in-place conversion
> > +                       support for guest_memfd and tracks the private/shared
> > +                       state of memory per guest_memfd instead of per VM.
> > +
> > +                       If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
> > +                       ioctl on guest_memfd file descriptors and disables the
> > +                       legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
> > +                       private memory state tracking. Only the
> > +                       KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
> > +                       per-guest_memfd tracking; other attributes remain
> > +                       per-VM.
> > +
> > +                       This parameter toggles KVM's in-place conversion
> > +                       capability support. Whether a VMM uses separate backends
> > +                       or out-of-place memory management is determined by
> > +                       userspace VMM design.
> > +
> > +                       Note, this parameter is only available when
> > +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
> > +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
> > +                       conversion is unconditionally enabled.
> > +
> > +                       Default is Y (on).
> 
> The parameter is only settable when CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y, and
> in that config gmem_in_place_conversion initialises to
> !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES), i.e. N, not Y. Is the doc line
> wrong, or is N-by-default not what was intended here?

The doc is wrong.  The intent is to maintain backwards compatibility with existing
deployments if KVM_VM_MEMORY_ATTRIBUTES=y.

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 05c518c9b8078..929fd3e1a01e6 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
> >  module_param(allow_unsafe_mappings, bool, 0444);
> >
> >  #ifdef kvm_arch_has_private_mem
> > -bool __ro_after_init gmem_in_place_conversion = false;
> > +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> > +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> > +module_param(gmem_in_place_conversion, bool, 0444);
> > +#endif
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
> >  #endif

