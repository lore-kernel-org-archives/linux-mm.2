Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308CAC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5826B06C8; Fri, 14 Aug 2026 11:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8CCB6B06C9; Fri, 14 Aug 2026 11:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2746B06CA; Fri, 14 Aug 2026 11:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D16B6B06C8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:05:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D9291A004B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:05:03 +0000 (UTC)
X-FDA: 85100197686.02.1EAD54D
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5331140002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:05:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c2bnKkSC;
	spf=pass (imf11.hostedemail.com: domain of 3my5_agYKCFAAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3my5_agYKCFAAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786719901;
	b=yZOJHLveDrbEt554QqRo9ECTyt9Z45GaVo5qVLkC0JW0AoPABYo1V6ZSfXs16bxpwmnJCV
	lwzoe1VhseEVz1lKpt70VquRqZ+dzhN7l5l72yIwUc28KtIKnqYvc+sHWurLtK+rT+MYyP
	vAgYIYhs98YHw+s3qATaAiR4BASZg40=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c2bnKkSC;
	spf=pass (imf11.hostedemail.com: domain of 3my5_agYKCFAAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3my5_agYKCFAAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786719901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clu0oQ935OCDJt7mErg8+zYCCTgXtjG+YSt87i0Zh9g=;
	b=JIWONBBbOvFcUJ2jtLtUm+5CHA84WeFotQLH7nNgIRi1Nbhnxffd12o7kB+Ay1JNq4cJi9
	zCbf6tGP6QNHsVMmQ27t/uIQoHgoNCt46yo6Ea+vTapIJADPADT1BYwMPb8r9/NmL44WaO
	U3MWDOjzfFA+Gr0pkwyaPzz6bQgNa54=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso768152a12.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786719900; x=1787324700; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=clu0oQ935OCDJt7mErg8+zYCCTgXtjG+YSt87i0Zh9g=;
        b=c2bnKkSCRgxBMjbiD6gbUZtifn5REVZntZzuxs/IzO3FcKo97mkVvYeY70aDrPcOxt
         fpHhIEycowIlZy9ExkeJTF8FdgjEOkHzj3/N17IXQRC/OWHYP6179eLSrMuLK53r5ZCk
         h70pE28ratURtvjIs6Kl+Vg4RFPnCiBg5notecBMj0TU6U5HLvGi8+J9upw+heNCojrS
         kF6tRkf5a7vRzEn7lO5ZT7LIyN9cGaX2uvPkJJ8sPNz1a0NZTGuyOEDCv2czOxLYJ824
         LnSXX3H2FgXP75oGrfCZ7goJ6d7vjeAUrnEZcayDt5w8wfvk4VfcTg3lIxVP/nD6L+39
         gU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786719900; x=1787324700;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=clu0oQ935OCDJt7mErg8+zYCCTgXtjG+YSt87i0Zh9g=;
        b=X97NYhOkX7I5225IniZPUTynTMXK2eRDsX0AxxEptwujehpTEDAI9lQY0FzAPY4Ij7
         HeWSMRsCebZ/e31GAUVuIMhRqobEUXLYvFfjF4G+0qbE6Rqu0hkz/NIbekJyHVPsuYIy
         68lIklKazfzbTFYp4R9b7hbjCb7QqPTJ/p+TyYoFfMTcWwIYJwIX73qcI6XLtxbY0ySz
         D3Bq5fWUykSAwIo0AX3+AiQ2OpLgSs4CBso/bANQ/GwDUI7ZHBLNhk1aBbfW6gH1W9Vc
         dCzpMFzb9IAckPdPMc8lxa/eu+po7jbYycAIAg25EgJHCBfTeOKtdlSrv1IiqzPVQrns
         j0RA==
X-Forwarded-Encrypted: i=1; AHgh+Rrlz9TOmHGwqWPseL9ts2yVwoUWgE3YzGF3NmG2y2Pn3IHAyvtlZMHTu17q1L1voJWFIn6wn7mOkQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6DqoOPLYSn6pMLSssbuHUuUnuPJVGHPrJZQzRZQ97wuNqsStr
	yEHTVhPf8it7aCscmJyI+7og1Wx7ol+GvupcpddnJd8qtXlJU4YHmr+gFBTDxq33C9tRhIkpZez
	rYo83LQ==
X-Received: from pglr26.prod.google.com ([2002:a63:515a:0:b0:c79:65ab:b3b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:430a:b0:3c3:9c4e:de3a
 with SMTP id adf61e73a8af0-3cc71989601mr7356121637.6.1786719899335; Fri, 14
 Aug 2026 08:04:59 -0700 (PDT)
Date: Fri, 14 Aug 2026 08:04:58 -0700
In-Reply-To: <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
 <an5AcEG9mqDgnBYk@google.com> <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
Message-ID: <an8umm0qisEidt4n@google.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
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
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 5331140002
X-Rspam-User: 
X-Stat-Signature: 9gf4rg8pnkyz7h4rnckbka5kejb5x1oz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786719901-362390
X-HE-Meta: U2FsdGVkX19HtHB6XLivBEJGu+cE+8FUZtYYx/wxUizcio4CwpW+4FIBOgHTI7AN8sxLZ1reesW/IOUrSnMxk5CCsZiZeMJNDPJERyzvXofb9426CFhdKwaOES6eodRY6a5J4zSCrBrtBugn39nT77uPyTOfgSFR9+F2hHfIcF7kWircaIAvBhLdVf3CWEmxjakwAub2lhvzQmeaz6UcRif8drlWnZUy7WldMbn14nurny+eaex4QPaYK3KGYt7qiUEScg8ILw2kWOgDq9vzWaRz//nlnQH9t0R+VjO1b6XuPhzzDn9hN5DFXIqvoCWjSnet6m+K6mQldY4AreKhLOz7Ri1l3A6hXJQ3ugLciSWCwMk42I5v08m9Fw1NRLPCQkAyAKvOZ4Wp1gt7HEjpDJ5+VjWa64i16QCqtoMKU4tlrKDLVKs2rHP3pDJ4i+iK2hfHPX4oQvtrCGuFpN5mycDQUEhuY3BVvM4iTsHjsNJEQlxiw4zF18uXvryNmlQzenwXQlV/IXByMyRfiuvBtuixavgD6ysPIIpj0+xfGqtHpsK+TgF3icPn7h+48wVM/3jDrhqBugio/mnLkBj2FjpfHdmgCx6/qIKKSY00GAXF+hhf/xk7a90SBN/dfPSWhA4dPN2zutsW+mDmUhfWKTUhCJcrM94kM8dgaQHC2BqoujoJsjGRIx0CPQS4l4U6lgrZG2dQsWTy7f332C6ynrVIHZ1fhXfuGe1hKnm5HoJrjWoIyZkhc6LUuOfmEGX+6xMlvPIEeXVcYJmTZIUGIApwdKK0YCp6TNpcKeHdHP37BbAFyldxDYh3fcLzAHkP5gBmDw+mjj/9mCKSir9JZBhL4exa7T/HH2bbAMi7dFjZrflzdFu9P5e5/FhqQtsWzgLAmYTB31FLsOUBM5UJWs4GrNxm9ES5xk7WK3QrKQr8kYqkYco54gZjsTyfMryPruJqiixMO0tf6BGlUES
 P5MdiPUT
 sPVEUjlUs5VXeW3KIkz+PBE2yOWOAsr7hiXo3MnCtmnINtMMM23faM8tRl77KjtQuXGFZvcNDu7qJpRGPlKfNXaqWbNLzZuFY+zzTqaGoLWlnOMzWF1u1zQbo/3b0JF+dEklhpD6lom5rIToTcNfXBksuiCAlUoHC1XaUYf7jyo5xNSu0QG2+KjMgKLimQZewLjp7ZJUVTGmQVPbHtrGcUcRWEtP3901bHQ6Mpwz0M/Afft8SD49mrALvJ4R7fu1wgLNsXNGoS2g5hQGtOFeaJHxiONsFtchR37IuL0fxeKsUYATKQTvfyvB4lVRwq6hZxl3UMQqrrdxhehubFLCvMmwaorIts/PoUas3Gz/BUMNpCk0f2QoooT5gwrC7AhS78Ntb3bP3mpNIq95+7UAfnHwhmrYTtTxwLFB40MO2OulmH/udgfWdSInjgU6lBkSICBXSQ6dqgqYJehiqwWRgOLKQH9t7P0LKBfbP8zRZWBcWGItO4QlCecZF6r562W+6DfPJVAdtcRHPACE3B2xvUucGr4Y5+hNOseDlycDWu/EfNXI1ldcT7fTUnQtdKEOLJH6jvpCzPmBMsExDW9xuG4/Gk3+hnp2/OFXxvPMC3yPG44ejJizB3YHmZDxJstnnoTYfxCbd6F8jVA3hrUzSYEEQ2t7qY6a977My
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > That's why I think it's worth analyzing the cost: if it's in the
> > noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
> > the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.
> 
> Is noise defined relative to the entire conversion process? Would this
> benchmark look like
> 
> 1. Convert 4G to shared on TDX with CONFIG_AMD_SEV defined
> 2. Convert 4G to shared on TDX without CONFIG_AMD_SEV defined
> 
> and then compare the difference in time taken?

That'd work, though I was envisioning something even simpler: use rdtsc() to
count the cycles it takes to iterate over various ranges of memory.  Do whatever
is easiest for you though.

