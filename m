Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27668CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743468E0008; Thu, 23 Oct 2025 11:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3BD8E0002; Thu, 23 Oct 2025 11:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2A38E0008; Thu, 23 Oct 2025 11:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49ACA8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:05:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1145EC0BB8
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:05:39 +0000 (UTC)
X-FDA: 84029703198.19.7DC9C11
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 376F21C000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:05:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmWe8G+J;
	spf=pass (imf20.hostedemail.com: domain of 3P0T6aAYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3P0T6aAYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761231937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvcmXgf+o6Tu2cYvhHpGmpe9m3a/ceHWHcYak3PalII=;
	b=aQoIXsSYzvQMlJFkH6Wix7zddSro6POtzPm5VIZ+rPPz2Hblj80u0BxaX1qq3irMnU+6+j
	FTIQwZ6QFasTe4lJLIbBNH30YKyE4+BWYWC8PtAPJSr+p+zU63GP4/VCSIOBHFqrPY3fDL
	C2br+QYxvSG2iyb4byvQ8g0tN0ZvFuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761231937; a=rsa-sha256;
	cv=none;
	b=pmVmHVuWzO+g4+NMmAD+yFopBcVo2oZ0GZFMrqyJ3w4c04R9VanPRdmLk9qSRm4dRFd4Wh
	wqDk0AyN4kX4ad3o2+SobQC+33hJkRLcsFbfv1mIVoufOqCKwr6c57F6AmFmA3DJCYy3Mi
	k7lbBRDBRlru7fERn6pIwT8NhVktIsQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmWe8G+J;
	spf=pass (imf20.hostedemail.com: domain of 3P0T6aAYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3P0T6aAYKCP4ykgtpimuumrk.iusrot03-ssq1giq.uxm@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso648749a12.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761231936; x=1761836736; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PvcmXgf+o6Tu2cYvhHpGmpe9m3a/ceHWHcYak3PalII=;
        b=KmWe8G+J4X6TFc3yE3/RXOCmpggtMVGfrW8lxDUbI5Fp+cfMWbwIb8X6057pH+2FVT
         AcXmcX1FIPz/bsvMoZhAwGUNa4nBctNzXvi42U6YAGJH1Pjy7CMKKSa9fl2nCh0JNNbV
         7ydOs1x9GOjcetxNMceEvxBQqP+UKN6EEu2ynS054X29E8jubnpTFogKe11WfpWqHiLA
         1cSnlochAf185dDNKt9P+zJJ4xEiORMQT58CFGKR59n1CIcwguC0ZSLDq2Ue0YEctwc3
         zf0MRCdPmIlFI4Zo9oDdBZq/TfEwk8BFa6q5mAcg1zrG1d2WymJud1lOl/gaWUoTRRzE
         2Mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761231936; x=1761836736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PvcmXgf+o6Tu2cYvhHpGmpe9m3a/ceHWHcYak3PalII=;
        b=DVS7Uh7EPvZ/7heIfaFur4ar0AhlJ7VPPr/+fOyoz2gpoWKoQTkyJBL/wgOi0awIao
         hVj+/0lkwl1mLfHH/nj4XoInmOeaG0jEQg9jI5GBxTFfCbmxmekmRY1nYX3eQWrg6OSV
         Ucr4L+MYAg/pqWMT3r18rA5cb+jyrtWkhx/WV0WeHs0h4WylgkkiCUtvSt93qBP7C0R5
         eY+oI3+DbpFAa5HqeT0ZW1rHl5SNLbFuRfMZBiZMZ7IwKhf/gts3b+g6hY3vEr2l+8LO
         +NI5/w7E1KcO27bGRx9nzxLRsMbmZDiLxfzmGF5ZTTUlZzzQWyJ4qhCKlavh3KwUocBN
         Y1YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsBkkRd+G9fk5tdzLzKJXiKDky+gqsNhSwo4ranrup8Whv6D16672tkP2EjIfIE57bqM9Iwoqi3Q==@kvack.org
X-Gm-Message-State: AOJu0Yyj9hM/WMkX1oxTh22B4p0O1ZGVpu1Kme+CRn1JifMFsNqoprEL
	t9JtVTTIWcCQkFe2bEi4cGT5fqF8fYM86gvxuhOQkwLzdIf4bQLmgZMPpDw8EqJYkTdkBuWBiJV
	aMQaz1A==
X-Google-Smtp-Source: AGHT+IHpWV5RNhKUXvWMGZ+xD8d/MTd1Ze+E21K0nbVEiBP6P7EQ34tE5jerqVVq8m5WkJ7UUYnKv9jKozQ=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:33b:b3b8:216b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3141:b0:32d:e07f:3236
 with SMTP id 98e67ed59e1d1-33bcf8e3ab0mr32372876a91.22.1761231935591; Thu, 23
 Oct 2025 08:05:35 -0700 (PDT)
Date: Thu, 23 Oct 2025 08:05:33 -0700
In-Reply-To: <diqzv7k5emza.fsf@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com> <diqzv7k5emza.fsf@google.com>
Message-ID: <aPpEPZ4YfrRHIkal@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Stat-Signature: hukirss17hbqw3du6whunts9angysj3q
X-Rspam-User: 
X-Rspamd-Queue-Id: 376F21C000A
X-HE-Tag: 1761231937-807148
X-HE-Meta: U2FsdGVkX1+TykwaD9e8GaRsxRuT81nQ8Dwjy3LCX2w9II9or1CAXILK1GeCEQDa7NI/PBJcqvnBeXllo1L8/nhsZde5m/sIrkKfSIOAmCxy3xvMmOPq4Py9PLdLkbZv1O2sXTvM/RmvTM2DBgdeuENtu78RrRT5q0oEaoFaTT1i+YYxUQgEGyKna6FiIytC4L7vrLr4rQ52XWnT/2fTssE+gBvvbAsZg1BmiwjjTN6rCVnCRMBeotYrfGFnLC7lEadxEeRLhrLtlMRXiFqcvo33COBlkypjythVINkBKqOf7s48HUQmCl97cqOMbaOee7IGv414XiRLcW9bIKx2PhrkeH1ozwnjc/znezmPAMHbKASrt/zLdnT2ywGIHzZhBmbU2rsKplcljYF9q+Q28wXnRVlqwccLwNUmqWSSDcU43HckfeRgdgsoLkkTj+tfkVoFxUhT67QfXW/KjPOOSLI+4KRARyWPkQiyZp+Y2iezupFCiNa73J8gCZh9+qYR8tjnY1sAzaJNNVG9xR0h+7G+KCUoHDMz8OkHL3L2aljxlLVkHnvN/6mJZfloSNg92jrP6wCPFosuq4xbD3mjNjpPQF4r8zGg57/6pnr8k0W7GeGft3kT+H97tGbpYBXDey6S+Ujd95Achktf5DK1v7OrD8OizJl+vpM+qFFniQ6oKFvXy7EFCmh4j1S2xGSxS/VLoJPmc3Lkl+YMg4GsGdKkkO4MoWo5+C/1+oy6gSv6j7026W5tw1SzganzluQOlK+lCGKWInfhNb2/X6G1yOJJ5zP6R2YwzRdXzJAthzdbKYlmkQtnIK2RYocybuzFwX1bR1KRj7r1+2VkN1DbwDdRSHjUpZlgF4j/Ip3JYzsYpHFpyqQBmh70rv7p9ca/iG+aKV8NG0F1/At8zSacGLP9Xv9hSXnZ3wvaW3AjUa+wizrs0RyOHlQy3myyapf9Enk5SQk33mF41BpaDqP
 uqnK4XYi
 9mISPYXXA0EGHpVs4lM/ZI0Ur4acP6oro8+dzuQjomufLNu/A6beo+jevNW3X2ISNDwZSzQcEwUy77PdyuQcQAGmuqPqfd2EGCnOErhzpXqs254UPXaRZCpvmdD30FUTDlC2YXZ3baZORMDJIFN6lLoUY9ytiADM3Bj0pH/0r7kjn+sNZEPxSZ4cESqTQtYc8hQH/j/l8WabTztgi7RFQth+5K3O4l/9x2oddRsqPS1FV5WLKvwL+50WzrxIOmdS0BejI3HaUKi50fr06DkHY9gmxr65XJJWAnupgunEiyNCcFdo7n5EFMkYzL/Mii2YnckVasPyW6GzaEBUgKDs4rFQd8OAMUB6DIVd8dsazPL6omyGVBdeHSWeRT9cjZEYY2rbgDO2rLGcvyVtRrRmrWKJ04tMZHgf/W5sjRC5XhMI3hfJXU3cF3vpYlbPY/MfmrqorEVutZfMxLRodgKAcv/sDDY07jTwvYQ9VVpXcF73UiN4wASLKwV7/97whjgZGzcG7Ydkb0crq9ZCy31aDJFy6NfVqD2Mp5o6Sn1hM2L5EqojRi3ZDZdgj4UT44mw7ta5SLaTEnAXMbYiVWZYf2QvoaM8NpqQu3IF4wQyiZYITb42MhvhQb8qVBsbo6bVB1hSAdovhKCjbf4VSii3fb+MUZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Oct 22, 2025, Ackerley Tng wrote:
> >> Ackerley Tng <ackerleytng@google.com> writes:
> >> 
> >> Found another issue with KVM_CAP_MEMORY_ATTRIBUTES2.
> >> 
> >> KVM_CAP_MEMORY_ATTRIBUTES2 was defined to do the same thing as
> >> KVM_CAP_MEMORY_ATTRIBUTES, but that's wrong since
> >> KVM_CAP_MEMORY_ATTRIBUTES2 should indicate the presence of
> >> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2.
> >
> > No?  If no attributes are supported, whether or not KVM_SET_MEMORY_ATTRIBUTES2
> > exists is largely irrelevant.
> 
> That's true.
> 
> > We can even provide the same -ENOTTY errno by
> > checking that _any_ attributes are supported, i.e. so that doing
> > KVM_SET_MEMORY_ATTRIBUTES2 on KVM without any support whatsoever fails in the
> > same way that KVM with code support but no attributes fails.
> 
> IIUC KVM_SET_MEMORY_ATTRIBUTES doesn't fail with -ENOTTY now when there
> are no valid attributes.
> 
> Even if there's no valid attributes (as in
> kvm_supported_mem_attributes() returns 0), it's possible to call
> KVM_SET_MEMORY_ATTRIBUTES with .attributes set to 0, which will be a
> no-op, but will return 0.
> 
> I think this is kind of correct behavior since .attributes = 0 is
> actually a valid expression for "I want this range to be shared", and
> for a VM that doesn't support private memory, it's a valid expression.
> 
> 
> The other way that there are "no attributes" would be if there are no
> /VM/ attributes, in which case KVM_SET_MEMORY_ATTRIBUTES, sent to as a
> vm ioctl, will return -ENOTTY.

Ya, this is what I was trying to say with "_any_ attributes are supported".  I.e.
by "any" I meant "any attributes in KVM for VMs vs. gmems", not "any attributes
for this specific VM/gmem instance".

> > In other words, I don't see why it can't do both.  Even if we can't massage the
> > right errno, I would much rather KVM_SET_MEMORY_ATTRIBUTES2 enumerate the set of
> 
> Did you mean KVM_CAP_MEMORY_ATTRIBUTES2 in the line above?

Doh, yes.

