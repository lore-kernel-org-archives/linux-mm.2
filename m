Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130D3C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9A26B008A; Tue, 22 Jul 2025 11:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881716B008C; Tue, 22 Jul 2025 11:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE706B0092; Tue, 22 Jul 2025 11:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9DA6B008A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:58:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E0EC1A0493
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:58:34 +0000 (UTC)
X-FDA: 83692358148.24.6583CC1
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7B97E4000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:58:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZSLShXaN;
	spf=pass (imf27.hostedemail.com: domain of 3J7V_aAYKCNoOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3J7V_aAYKCNoOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753199912; a=rsa-sha256;
	cv=none;
	b=l2GEhrAZzpOb6W0Rbu1tt6LAFSpAwqfmMJ2LG7dpcs0wVY5ljAlWCM50lTkfUk09CzfBmf
	FgvA37EkNEP2SesGiJA7T39rNXdFMfmRSABgzgPQ7QsJv8Z3zukL0oeZQ+DA9oal1XVFLS
	NQPPw4i8zN6B1puaP78JN1bD7G49s/U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZSLShXaN;
	spf=pass (imf27.hostedemail.com: domain of 3J7V_aAYKCNoOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3J7V_aAYKCNoOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753199912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dntet92u2ZnbqIvi9ZAjtry5gw5mzuxy85aL6ZIpFs4=;
	b=rzopNAIvdxWA+Y/c0F8xSlKT8hG5TOZiF7aEq405wXAJ7OQMwuCds0YglnQOIUp+lzPt36
	xEbbYP4iZC6RCVOFKVimTaB9N/ed50ExNnpF8JnZ1WOj+agkbWxRBnOw3DymyAzv2/ppnF
	acYO/7U9qcJd+aVvFdQV/FdximZRD6c=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso29141a91.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753199911; x=1753804711; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dntet92u2ZnbqIvi9ZAjtry5gw5mzuxy85aL6ZIpFs4=;
        b=ZSLShXaNfWPDzTuHo7mjobg1k+aFCXYbIIPT4Ypt4qDuVfROEsHgBxNnuAyg/HVLeV
         FgT/qdSKEcLg7OuWzWGJ2Bjis4oYCYi90b6FGn1RMkyMrINwZW6eKJYJLZgsd9Cu2hJ3
         r2yMi4eB0JgUA9SplUj+8bLEyuqaCrkvBjirjDOVHUNuboYgmlFEuNjDgSe4NcpGr34E
         VuO97mESIp1bACBkc8j/CIduV386CDp0AD6a96JbCsHf1r7Mj3D3qRym/8YPT4BEDJDV
         rWkG7wMGk8fEDtla5dP2A5qhXRBEpanfFOagVEoPJtRo8qgAUfe3zE1gFFgdQOGp9WJw
         99HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753199911; x=1753804711;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dntet92u2ZnbqIvi9ZAjtry5gw5mzuxy85aL6ZIpFs4=;
        b=sqjdLJXKr+2+tkFVEguitpYaS6p9/Z5Dxeu+8/K4QYNZSu6cP6+XOfzRiuiJ3kGQ0y
         l7HQoOGowyQ5gSOG7ObfEyxtK7GIFxzjEc0lFPT4dG1CwH6syMkw68J7WJKttEZfuFDk
         sUTku0QWAgygoyO5HXSnPGBgHje5YvnAI92FrcZq6DsxjUKkuvFWhLI4xNwt/KA3xCZH
         BnPZVF+6QYzvy6k/URiHxx9Vs800erooo5eAeruOhdhn9ujd1TqtQVuPVfVnKaBdHD3H
         baZrARtrc0SaBSfT6DvL7ptcR//KP/UCxiKTX6RlyeX75OgC+OfnRW7drIus9TTd60lM
         dvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0lmawg27pqvra8NGbMQoqifgnTTJND+cqMPImHxMBgZi/II3f4EbCwvIfMWmoAQPTQxAcboFLWQ==@kvack.org
X-Gm-Message-State: AOJu0YzMRLovhKrLKhfw0jW88q/NUDURNn0M+nIZeaSKFw/LVZxwc5vo
	bRg9VLMEmGtwr2ISoOQVQmMwQoGygEsb6a+UWAB6BgQYEyKIOGP1v1+kIa4TadeD+JtO83tMMuA
	9rHfi9g==
X-Google-Smtp-Source: AGHT+IE/ERPxhDR98Vn1sldOeqYOq7x311jxRpTo9srVBTYAHk1WavBhVIfa86MxXTjpt/R+lS32JDT5tGA=
X-Received: from pjbkl7.prod.google.com ([2002:a17:90b:4987:b0:31c:38fb:2958])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3945:b0:311:482a:f956
 with SMTP id 98e67ed59e1d1-31e3e12e57fmr4933468a91.5.1753199911156; Tue, 22
 Jul 2025 08:58:31 -0700 (PDT)
Date: Tue, 22 Jul 2025 08:58:29 -0700
In-Reply-To: <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
Message-ID: <aH-1JeJH2cEvyEei@google.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B97E4000F
X-Stat-Signature: zetk3ortiq3k4x81f3y7hrta8hcd636y
X-HE-Tag: 1753199912-441938
X-HE-Meta: U2FsdGVkX18GUHGG3XYjtjJakDCOviJLcX1v6kjZmBj8E7gBAylT7GOsD9AdfGqEBzP5hRMwefkH5L/d4Sv2JHJt76MPP08rkxEtZWdP0f/fdGuRgZjNp7U5bycAhc5SSpEQmN1nCll8hTdJxEL5GXO10NbRptFgx+0WKdNHXVk7EW62hC4eCDiJV6nhvNT+GD2dX5KeoB4Jhce8Q2XWm9GEgQBZXQdwxQQtbfLlFvyUhx9NZE/a8ehzanqMxPZPe9Or1A+BWS1aX9Ea97NgnX1fE3hseGU3uLDe67wYUawknRCLfpMwQtwKcP5rG475Wihoe1GSsWGy9SWOrIGuUC+QdC8BNzL0L+ZfPthF121C1LomC7d2XlrwQXg92wH8wM8FulrxZuV/aROVyxsDVXXRlHXkZak0aI1PUxv6olJJBZI0RpYrFQQcAfo1Gh2TkbWboU+z6t/9PJTZ+HKr48IyiIrTNCYuH/Lg3hVNNIOdNM1Vrg3LFLy8wMNfokb1F6bzmOTAVAaVBVxhXj+zXKbjFLAF3j0D++GKNvBE/OzAm29k+AjeqBs9xUFbiicOXEgNgIdSNhsMwmZBBJ77yIJ14S9RDbjnsbB/YzNOsoLYVd/L1YcELrLMUTpBrLlzKucW621HWgwV1YHjLEItQMlKkseXXccHt2E4u1r2mqnIrLontl3LCUW9yISkIAlGdauT+UuLjYtW0hkf/VocdaXJgzc5EhO7k21VgYl9fYfLOi+yzAzSc6RxIsAtjdVEsCk5f+URbKY2d6FjDY5WCMknB1uXJqJ8uZLGLJP2/CnFDMwZoVKLQFN6wiWkPcfEesDgeh30BYKD2rt76vlQ4+oYj05CpQ5QSB6/K2xCNILKIP6QRko4gvZ1p3LlVbqKp+Od/kV0EGBcEiJiB8ELDIe/bpppuRy3x2nJGnAVDnKrRSb78bv8tID0SBUYn3BteYurRY+9Xaogn6v4uVO
 Mwvpu4N1
 5EcNeneungBC7gbeKTeekj/cpM88bMZxj+LjT4PlsCHFnuCAF4Gc+5d81jvqEgEdlAcqRJSUtZFL4T3sLcAccSpDvBpFG4OINAvoq7JjYRnKqEFFfvWH7btMey9p6lhzX+NHNPWtqbSbcRbnF1h4QR+yN6Wb27ukSax3HH1TTrO6dLNviDakjuqPcT7E4s2mlvbaMQ96vwGaTiqSLTLFHWWObmiVoqVL6c7eWyQxoB/VWRbJXTc8sgUEA8M12x0yjEz374EAd2ohros0+z6HTYLsrbu4+fJuMo6Ff1KvOD4pUviB2iYHtTHNKmW4jaBVcic2UyflG/x5apXIjv+eVeOOMSfax0pIakWWam02loeehZW5qUVQToLkWKu1wQ2rda406awVNHkpQXLao8jHEmpNtmiLrq0Uk6YjVi3A655KCBx8gnXLTgslQQqRL7eDcgqZewhjHhuh2MAwblB6rMurhj8x8Uebx91yqAz5Y3FqklbVqrkF/tXvDAVc392RTORJ/nvW3w/U60pj4q+XZ+oqpKcm2mJschFaoIschV78IcDh0GYLZNyneETnhi3lHtRl6130ZvXFNKxL9OJ/ubF5DMn1oQLF3/SddMcQcDQPjxQhU3pdWb+jI8SyIdOAMTj0R4C+Vkzq/vHIvZYbLkTiv/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, Fuad Tabba wrote:
> On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > cleaner resting state (see the diff stats).
> > >
> > > So just so that I am clear, applying the diff below to the appropriate
> > > patches would address all the concerns that you have mentioned in this
> > > email?
> >
> > Yes?  It should, I just don't want to pinky swear in case I botched something.
> 
> Other than this patch not applying, nah, I think it's all good ;P. I
> guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> somewhere in a local tree of yours. There are quite a few conflicts
> and I don't think it would build even if based on the right tree,
> e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> rather an addition of an undeclared identifier.
> 
> That said, I think I understand what you mean, and I can apply the
> spirit of this patch.
> 
> Stay tuned for v16.

Want to point me at your branch?  I can run it through my battery of tests, and
maybe save you/us from having to spin a v17.

