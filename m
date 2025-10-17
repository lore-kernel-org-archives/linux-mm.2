Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B89CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 23:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB36C8E0008; Fri, 17 Oct 2025 19:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B0C8E0006; Fri, 17 Oct 2025 19:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0668E0008; Fri, 17 Oct 2025 19:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA9248E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 19:33:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39BA013A90D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 23:33:44 +0000 (UTC)
X-FDA: 84009210768.14.AE55AE5
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7490540003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 23:33:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=18RqkOgV;
	spf=pass (imf17.hostedemail.com: domain of 3VNLyaAsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3VNLyaAsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760744022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwfPpMJqaisEQVUu9wiIDJQK1raYpWFG3P+DdjsMb18=;
	b=HECLXwCPYQrTH0ShTThiCbSN4mYhuKyBlBshliMXP6ZM9y5S1fomfpcpGwkZs1lULm8CIu
	4Q7O7HWSlYQC/rQT30cqmrvFxI0BGmMDsaeJz1W/3jfV0Sty96iNatWxJHCReCZXQfDJBz
	vzV8IyrEXBPX4M8ey1awLPwqq5g15Wk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=18RqkOgV;
	spf=pass (imf17.hostedemail.com: domain of 3VNLyaAsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3VNLyaAsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760744022; a=rsa-sha256;
	cv=none;
	b=bRpTw4eBPUE4183cDrxKx/xTA+srxm1OKEzrHX49Wi9rk0ytvoy9u9sUzmRG1l1lphU2/k
	+dFT8rOhNq9JW6H5QxJGfOppsNjNOB7iLe/Yef1tj8z37LL5HnG9ryJeuWmUjHB7hLeXqi
	KeaOaThOvPxD7LDzJoQHKZa2IomtVD8=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so2102744a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760744021; x=1761348821; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LwfPpMJqaisEQVUu9wiIDJQK1raYpWFG3P+DdjsMb18=;
        b=18RqkOgVAXprOdNUYrlCo+rRoYjyXIP3vzcbVaPDxnV2QCnT0gN3tyRH4j+9Ya2rog
         L5WNpetOpvROJlAc88j7EyaJj0RXUDT34xr7edlFv0eU4RMogzk32vWcRyOcocd1L01K
         rNIS3I4a+aaALfwHHUrSZh3a4m+lsTAV1UasgC+a9uo3rjvRFpguDiVFVLui+V9hLMCq
         rzqc/epr9tNL2U23i4uzyzI4M1uKkVRFAY+m9enfyFVFH3nJ+HoTJE0D+9XlfPJjgpqQ
         Hy8SBEYtyvKSoFed8129vSnKteKFCBMs15O12KjgoRawuZCeypLuWLxkSt+4DrYUEFNc
         5MEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760744021; x=1761348821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LwfPpMJqaisEQVUu9wiIDJQK1raYpWFG3P+DdjsMb18=;
        b=Bk3KLZNDQ/QTHzoTWgRRbcmVkl8dRtoVLzw16Xc2pD9vvCieuOc2ADEGR8XY8jhbID
         ReFW2RzmMLvQV/FeyQhxTTD33Ev6ccHkydRYiMTkNwmv9jK/Byen9vWuWu5iKgOroASU
         uuA9GjqtjM2LxFeJN+8hvReTXpLOivgUIAO1v4/sAIJtnjT0DD4ANaAZw+z4MRhDAHxR
         Ku0nbKxIps7TV4MssbaBB6tyyhGeFyv0Cs2kgeqH/YDqexGYwuV1oMoEPKkSXYuVNzXz
         eUk41ojuRuYVm/j1iinDhJMRQwZrODDszMOvMs1lj4kJtGQ6aU7TZ4LQN6DV97Q6OHci
         0boA==
X-Forwarded-Encrypted: i=1; AJvYcCXdU2aJOor3nB64wn3USq4AK3XNafPkRx7g1ljoKkBa46lYm0DZBQ92JXssers+nvaeQiz2f9d0Wg==@kvack.org
X-Gm-Message-State: AOJu0Yzk+PZ0cHQlHST9bpZCfcRKMtpRLawnnUO30HSFjBWeOrGSG4vR
	qhCgQ3VPGN0Qn1ADN9CAuoqUyggCxfxNBjHaDlYg4vQW+/8tkfMycJni+t7GFYw/goQCafZJGHq
	0muMFI9Yriyj3oMOS/xXZmlx1Uw==
X-Google-Smtp-Source: AGHT+IEJkm1Y/xUQeOW9OSrw7fOIA8LhUvRSTlkRcfM+UNWeMSJmrld0H6KUJsXbTWNmxyDTB1XySSWqNmUDg7YYhA==
X-Received: from pjtn11.prod.google.com ([2002:a17:90a:c68b:b0:32b:8eda:24e8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d88:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-33bcf90e86cmr6755629a91.34.1760744020326;
 Fri, 17 Oct 2025 16:33:40 -0700 (PDT)
Date: Fri, 17 Oct 2025 16:33:38 -0700
In-Reply-To: <bb336979b10ee5b9c6b3c3934ec3aff19330b3e7.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <bb336979b10ee5b9c6b3c3934ec3aff19330b3e7.1760731772.git.ackerleytng@google.com>
Message-ID: <diqzcy6lp0h9.fsf@google.com>
Subject: Re: [RFC PATCH v1 26/37] KVM: selftests: guest_memfd: Test that
 shared/private status is consistent across processes
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7490540003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: h5qoiemhti9cm9jmitpme1cziyzbq4sk
X-HE-Tag: 1760744022-914721
X-HE-Meta: U2FsdGVkX1+6TZz/WNRjTsjLYsE/UWKUTBsrShBBgIjXR/ZCkNRnF6iDeODn9Q6wiKCXTk/4JHtP7+uIZKts+G8BkF/h3xtNZ+fcZEcTvTN9Z8lzk1XcE9Z720L2rc9g6xYBO2luWzmunB7gYLvAgRnpUqnSijThEqvNyzYxhYKIl88CuSENP5AfNi0WiLVqIcFFxFMKCe45DcxUrYjZSKrekFW2uZDC2cbBh7Bexi43Av25zd3keEtnixPXNK9om11FVPP3XetCNuyrs1QvqX6fX3WJ+U3qOCBwLLv8No1KPcK1gBZ6KFpZZP2AqKEiBjoVDwgHnEBZrvuuMN7VFW+45CT38mmS7m3wui8yznp5/MFX4MSE6pnDwXjy/D3HbRpvMuBgFNDF35kecFdYTuEN1EI9WQQA5s28tVI3P+IfKgsL6TARkgSoyrMwiKcyYpP/lQaOEAZsrtNGBiJo4MASBVGqnY6VGuJynf0ng4bLu2aGAIOtLOw2UEKnAnyNJQ84foBbUY3Y+S+HbABfs5SUIFFTN5VNL87v5mqbE3NxxgJ/UnBEnpkOY4JcKmURi7YX00gHgRNDXhHpHJV02RxogMvATnYVMMGQXLkdOKqQ0YUBZFhHIp3T+ae9epTRVbuqA/6FGpkWZwoufmcAr5uwRa7PUEWL0sBvNj6eWS3O6JbC/MyU4HYYHMnbOerV/3wJpqXMXKv2gZEazUWmM8KmxsFtZqZwhGq+bciCShrRwLxTM1QT+my+kU7e4R12gS8zqTWi1cFfMPEmNUbphGgZMOfyuXGMR8vdhBZIzQm/imDctO06MVwEaRBDKvcB7CJGZRHL+JfYgKN9B/jRiAhe36NCUX9H3zi7mk53qhd+JxiD/LWEdMS3ay8vIqO5C/d3UofZe6yG2KzWZbS7uxWd0UAmP7s9cFL0YhFfvYGf5m8JDCCGIQmiCjviv//OTmK552O3jARMJajWyzp
 5e0yig+E
 IcUElDJYGq3hK2r5rcjPen/Rg33mA2bsYxqUJ587umD/xETo1AgWgcyfhZ6vpboWATxr3GfIkUky+tsrxjmFQPrEWIYXmd+aTVSPOm3ScPubghLaSzaV02+HW75P/nvDuVdqXqxLoE5weA+9GMShCcrGP0XqvmRN0QMBazEbv3Dp1DMSa5aeWBsKNmLhM0yAduNuEHd5e9PZJ8Df+R9eZi0EQusCNatC97teXihI0ILPjeNY4U5O1fredEnoQIOF+wLQCBvsAmKIZb7yQYLGVC3/qJ2+9GyhAVpcpxpgXp+2h/FF6ZQj1ELsx2oxiAiuyxTyCPBQ8QEgEdDb0jqT0tqFzE/Eni4emygEFqB9bWKQep+FGdQQtcBgY0qxUpgTTBt3EybS9CE29bpCifYXl9MWPdZg17skMNj1yW+4S4wYAX5oQxivEgwUxB9Hdn5Mjys7EM2e1zTQFQQjqJCK0CfVFlCqh9Gu/zoa8AJFq/AaHp03bGLYBUMMMe6loFErFCaVp7fTq90sA8BYPyPqf14qZzYvytJW5mwW8mRo2qx2g3TWaT2NUhic9TcLZ9doHtcWA+mlo5xOH4eYc+iSfmJlIUad5Dt8ga8Uu7Azh+du7p8dvRu0ULRX3TAYV3ufpJ//2Qir+f4Je/ldN/YiIIORm1a92QQ3zCO8m3mB0nfsnvrZcqITBy8NWnCywMH4vDhO6yhCCIFtEemNBjYeHpbRCzZPQuwTRcf2sahczcSP/i+Zma5Dgb0x+FBb8whZqrcGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> From: Sean Christopherson <seanjc@google.com>
>
> Add a test to verify that a guest_memfd's shared/private status is
> consistent across processes.
>

Missed copying Sean's note from [1]. Rephrased:

Test that on shared to private conversion, any shared pages previously
mapped in any process are unmapped from all processes.

[1] https://lore.kernel.org/all/aN7U1ewx8dNOKl1n@google.com/

> The test forks a child process after creating the shared guest_memfd
> region so that the second process exists alongside the main process for the
> entire test.
>
> The processes then take turns to access memory to check that the
> shared/private status is consistent across processes.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  .../kvm/guest_memfd_conversions_test.c        | 74 +++++++++++++++++++
>  1 file changed, 74 insertions(+)
>
> 
> [...snip...]
> 

