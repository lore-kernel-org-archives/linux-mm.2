Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD3CC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 16:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3326B009B; Tue, 22 Jul 2025 12:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A7B6B00AA; Tue, 22 Jul 2025 12:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7786B00AB; Tue, 22 Jul 2025 12:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3236B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:02:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C453B1DA8BE
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:02:07 +0000 (UTC)
X-FDA: 83692367094.19.9DC9180
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD79C2001C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:02:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rk98DT1C;
	spf=pass (imf13.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753200125; a=rsa-sha256;
	cv=none;
	b=8rBB+CqhJlnurTy/xIDyqTnhHpk5IOkoVgMqwmCTsFjcxWRPDjSiUmT6SQGfit3Kfz2Nfs
	QX13KB8fDjqwB+hExGYz5C4u8yU3zmvBJKGyCBSkItDJzfH858s0l+R453BBbcIX/ZgZmF
	+bSQwm9pQfUBPfnEo0fgENttYK1AhRI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rk98DT1C;
	spf=pass (imf13.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753200125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
	b=4yiprv36ehvRblV9rJV1/quXTG6e1GTO5bywRct0jukmZpijyoWmL2QWkqHvw1heOSCNT9
	ed/r2Icywqjo5NX/V3ezDP6GQA2ypPVZwHNTrRlsUn1ZDy3LkpdtzKMmKuzbiDZLDa41+h
	renj00g8FdDoFHzdWcYuCw88BiQWGng=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso517051cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753200125; x=1753804925; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
        b=rk98DT1CQk8WfCsB5RtLwTFy7ztygRitg/vSOT+bxnPITa7yCAIck2W+tSh/5nllMU
         OAznrLI/PUTbgD0NSBJNVpnbMj1ZEsMJj3hmnEEqiOaiA+mLSMT1d0zoTG/sM5cIgArw
         dRncDZDOK/fxlD4ubPAzbQ0UFhwgVQ9rF4ebgA1BIpMDkeCAmbg1qFJtmk7hSrE7Tvnm
         5QzrntUgWksBEluGM7i14eM8SozVA+vVZY4ksKVA7DcSXGlm+F/60ml+vvQEOQ2Oxr6u
         IcqImk4sciEuMAeNJ5uXflEYTRZ8mx8XJVkOrpqcnpuWxXzP2NnG4oN2R4UC0LBLOUdw
         Nb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753200125; x=1753804925;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
        b=g4xVgNUvZwg9FOwWPTFcmPHLJwrwLMcO5ds2qi6HQthDm1BhgdoBOuI9aCPtIfe/+3
         Ud6Syqrfyk+s1ZZLL1cvefJPimAW+2K1mAkwexRUxmo/VX+DHycaMz6wp2bdw+MqTu1X
         ic1ZZL684xB2kSJrO/lk3k5xC4uoptCP8zPak7tTmmAwgucaKrNBTYRrYSdd/PvbZ9AZ
         ethGrZL6d8plntbb5g8NGJRV+2BaOPyx6p4Xz3OKccLiduXEbp6lgvxXxUj+F2v4Qzbu
         4kQ1V6qFGBvSxDZ9kC4X6zYYjmcF0bpwPesRvz1dGGAwQimT9ibwyTmkfmApjXYiyn0L
         I4fA==
X-Forwarded-Encrypted: i=1; AJvYcCXR+mWCUMjMo4Z2gRXP60tZaeFN5KCo0IkEFF0qA94T8QTwxH8HDKfwvOJMsNFoy1Kzzi7MuEmjtw==@kvack.org
X-Gm-Message-State: AOJu0YwLdQDC4f+cpy1k0HK8SeVjBKHIqycW8h2LssVDHldjpPUPfWw5
	02ZFpakpWG0mJMm7IpdscUsO26bpGfhvNUvaye//S/agJhawyiu5BasGYnxgNvCcmTnKZ3/RZWq
	q3TeawSrZh6aaro9pTz8nu3D7jJKomnuOwesJ+m9o
X-Gm-Gg: ASbGncvgHiQzO53NvULK1ZE2gQoYILFswFYtNMMCzgRBKRMS2pvGwOdo+d4fR8pQLPB
	pp0ItaoRDVqsc5TLuGQs57T0TNuvmlLBWyVt+YO+vIZKw+f6kYXq3zzJo8U2Ukqd9cjU4/niOEM
	CPvQpXlfOXyYQDpep1v3hz76h7B9hE+1/Ek8x7xcVFBqiG7tU/FcLfsvj9QsNIeeICDjtUhvTmd
	UyIYIgoF0F9cZ0l4A==
X-Google-Smtp-Source: AGHT+IHz1Md5CvjkMr0v63+zalLU7h1VJHuKRRiw/5Kb9EG5psNH9QWi7eZC9q9jEanCdF+aUxZTXQqWhAN+64R/RQ8=
X-Received: by 2002:ac8:628c:0:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4ae5cc6db00mr4063241cf.2.1753200124082; Tue, 22 Jul 2025
 09:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com>
In-Reply-To: <aH-1JeJH2cEvyEei@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 17:01:27 +0100
X-Gm-Features: Ac12FXztwmXhhi72jh3H00X5S1zdW7e0Z4aKDTPt7mq7MLiUgNVB0JPJsFGM4PY
Message-ID: <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD79C2001C
X-Stat-Signature: tidubeikzxmewk4ygdtpedt535rcw4hc
X-HE-Tag: 1753200125-801502
X-HE-Meta: U2FsdGVkX1+VXfwjyigxQ++Q4XnHRzj8n8uuVzx4VgT+GcqlvPrSpfKIYJ2C3g2yLU+7VZBQrs15pq0way+kzhuBWKGKRZtIaQhsDK+5xPYQYXNgt3/yzpTXCUyGfOoU1X57mKlTzwLjM/bQ15qVTaA/3u9lhANlItqdQldrX6YG3ooSTqoJl7/bV0j8PLyvtpP96XzNB6ROJkGTpt14h6LQTfU0Ef+t/KYyu58wtSADDlJA6+WwsHlu7FsEKn2+DMDkCLXtuvSGpaii25zyaCQaPr4uaz/s6M/XJnKE5KsmRyGgR3WO5b9lITdPZtjUFcb8eYX4eGMfzcJWeK4XJirJwXQZ+hDoZwcvQSQkYP7Mx9tzTCybggbxzGMY4TXvTI79equEk7/l26YXRmCvFRdBduSXkVecP6ujHTBwhiGNYKCd3/Q++ZXr+dGCXni1n2hnCNKyv37+HcWjSbTX7Udbx9hkvBtMrEz5Mghj4HD87DjsNAtvLCMlt9gKMrBYst7wvHWhQ5OYPXVvxWUHV5mbIcTEq0V9qftiLbCXrMwgkgufEzGcra8PPqUa8Ae5uZuyQBw0r4sv9dSVDCOdJERMV5M6gUISxQzcb3rSJtnkXKa6E0hSig8NqHB+rBah3Khu/zU84xEjCbkI1NhAOXSLd5on3AeS/UXw0v3wzGfGnZG2S/bqJ/a/cArmLidL/P7kO4vx9/YVRqXoeEhOGxCO+aEOrz2Q5U2L34EfH9TIGDR5u/kzfJ0PpTj3cJ8XtFGhkn2oS8UTH3/yKb2Nq0he9TURYMAPHEAWTEdP10wawoQwTGxMVX2zP8HvpNRJTW7kX1gDBcU6mvU4s4HRuJj0g0qr6aWlzbv7DZhlyMoO+ofF3wAuhBZkiPPthaa2s7FVi7v5f8FV/q/p+UEFXu35vWRvhgeBzAzsPODl4X74ugZzSyLaQ0IA2zND8Wiptoqy50O1QaEsqv+GXiN
 sqfN2uFA
 nVwzWAxN3CCVkw/ylEFN9dJpawtD/fMi7NBGeap7k3kPOjkpNdL5bm+GaPJ5o62jmIn4CR5rE2HziJbXYerhHn9w5YTRanZoqrC29UrJyrC6QEAKbJi+U69z7YGuiall/5FAx4oaixJk9nZPOi3lzZ6BMYGnxOvYe2JuDHzhEsFvQ940hgINAnF9RjAGj+TCIAByU6W2h2jatELSNvN5ON2N2GDazWGm6PwyQJcLg9QhucaJiY90iFt3uUZocioiHIvVyO+aIRmytOoJOG00EFdd0WC8CXvsHgQGmeQjMeK/0K1eDcwFnqJZTN/ZLxAFAcN8auHWPCr/ZtKhWMO878jDoa8dtS0N6CYKN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > cleaner resting state (see the diff stats).
> > > >
> > > > So just so that I am clear, applying the diff below to the appropriate
> > > > patches would address all the concerns that you have mentioned in this
> > > > email?
> > >
> > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> >
> > Other than this patch not applying, nah, I think it's all good ;P. I
> > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > somewhere in a local tree of yours. There are quite a few conflicts
> > and I don't think it would build even if based on the right tree,
> > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > rather an addition of an undeclared identifier.
> >
> > That said, I think I understand what you mean, and I can apply the
> > spirit of this patch.
> >
> > Stay tuned for v16.
>
> Want to point me at your branch?  I can run it through my battery of tests, and
> maybe save you/us from having to spin a v17.

That would be great. Here it is:

https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16

No known issues from my end. But can you have a look at the patch:

KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks

In that I collected the changes to the config/enable checks that
didn't seem to fit well in any of the other patches.

Cheers,
/fuad

