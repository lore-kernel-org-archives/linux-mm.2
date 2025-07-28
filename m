Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723F3C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52206B008A; Mon, 28 Jul 2025 03:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E027B6B008C; Mon, 28 Jul 2025 03:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1386B0092; Mon, 28 Jul 2025 03:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC11E6B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:05:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36D428019D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:05:45 +0000 (UTC)
X-FDA: 83712788250.29.D0F553C
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 505FE40007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:05:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0pVvhl1w;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753686343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
	b=d4L40/6Q4pNdZk2szEBQgt+XIccx/+sfnoxL0dchAkFg7xtyHLOJbfifd5av/veFms9jfI
	AdmC6x/GxIJzbfw02m0zotFUIDZsrK5FesP2ajwTpkNsfSI9reNEWWEySQaAsIASGG+Qhq
	i31Ifa4o0XnwF5P0JqhbznAL31PgHts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753686343; a=rsa-sha256;
	cv=none;
	b=cplh+QXPTyMDe0E7ugshP9Ztg+clJM8D+kJ8PRPmc3yq1CWkTCE2eafn3YGSEx6z+1FQ58
	5z1j5yvzrSp3TJdVOza3mveLiiNfcIcICsxhx8Thl5vbSrfwdSCs8QS2ivsul77fn4HIhB
	l9x48+1X3HE6gvHaeDuxSyp9e7LdMqM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0pVvhl1w;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=tabba@google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-553aa258aecso7303e87.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753686341; x=1754291141; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
        b=0pVvhl1wJR+NiRyC+TRrH7IeIQmgou8dM+XHg0S8zhWkVdxrp2LEwHLMzIYX0NleHO
         8DVXuuAxfWkzzV15xKA9LSnSrirdO7XYua/lyONyVkeEb7i0U9uxerrKhPJpCJGJnKkR
         6/mTeTKUdZFNRvlhpQxYUJk+iY1i49k+RYqNIpdGUMsoIBIeJSIuaBNd152OkpfnTRmi
         5Qdwimx2viBmxXvovY3I+y48zBXDFNUmuS40FFnnhbZGzmmGOOfACY3E3i8h3A38X1jU
         T2RkhDIGa9xhMM6ZByASH/TLIxvWo5wQ2DnauNrppSdqb47QB/IyCN6yVIvZM6zEyiNm
         nhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753686341; x=1754291141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
        b=HDWJaMje6AkO1CtnSE/7wNlWwoDOB9lbzrrThpxmkjMsD6LtUT0MWuV2dNnOKrNsYr
         uN9wtrd+CSe69/3Hf813aJAsUafZ+7bIbzTwXGnFi0tBR0hEcK0foF/jyeisq8m5lnFx
         hcxq73qRba/6MujMsQlKjtHIBGSng1zUVgMSRNgVwE9yAgXswzdc4Xph9XjqniugFIWn
         PlQvRmSZu9vCBJZtXvkxBUQDolj6Re0cGQQ2oIyYT761BaV9lVqADSbtKNcgH0Fz1/Mb
         CiGrZEZgka0/NeEJQcnLb2KMStX9mGYyKe/ELQI89yeP2H/CmmAT9S2b4/yp4A1wVkrz
         cnoA==
X-Forwarded-Encrypted: i=1; AJvYcCXLS82K1pe32/r1HMMCYRBK7HVJ61yyiHy4MpzEdIZWj0ZofkI6RlMC7KOb/GIQzvjoAsXMEb1N9w==@kvack.org
X-Gm-Message-State: AOJu0YzE5haaJLQKTCCZVgpeJzh/9ZFDRJ0Jodh6QjJyxuZBueYJ0YxG
	U0EtWpSnkc6zoDMTSEdZnyUL94PlLo6qLKpTMfjnLFkftd/9Ex9kKzTAJ+NUsF0SjmWFjzT9iTy
	t1tSVE0jDaheOv8sKbVnrhVcDC9w9o+OiS0xL57+s
X-Gm-Gg: ASbGnctQYKaj8cTTMSndMr1jsa4EGsNgz3Z3uZvnfaivzCqUj5GYIEHuiSQcKPnfpQd
	Ps90/ZMOaAw+47sW+bqFFApltwVQYuaM5Nc6z1sr0OBWTUK2Yog0fdch+TmuiAbh5OoUnbR08J5
	Ig0JIJX+xenYfmu3DPNbXsPBAYvptYPNc0NigcjKWMvYMonXbA13IbvExGM70gXKaMJlJi/+V/o
	5kxnFyf3Tjp12PsEg==
X-Google-Smtp-Source: AGHT+IH+nhG03vhszpw4SpGxLBcsItXrblXPXI/Z3jowcjOUQPpqAObstdzHVPgpSKZxUwqvLJJMux8lmEFM7MWk230=
X-Received: by 2002:a05:6512:2117:b0:55b:5e22:dfb2 with SMTP id
 2adb3069b0e04-55b63a96040mr246280e87.0.1753686340942; Mon, 28 Jul 2025
 00:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
 <aIObJH439LQWjnqq@google.com>
In-Reply-To: <aIObJH439LQWjnqq@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 28 Jul 2025 08:05:01 +0100
X-Gm-Features: Ac12FXyVGBddx8pm5Wrn9wDW0AE2GoOgT_q7kkPWz9XW40HNA-igFWzzFSoA1tE
Message-ID: <CA+EHjTyhSU0WiAc7GhwrdZjoUe0w5Uk-gGxd_AD6SRmezYNROQ@mail.gmail.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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
X-Rspamd-Queue-Id: 505FE40007
X-Stat-Signature: h4ewkyo8b93x6aax4ytif3x3se3pj5qo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753686343-408037
X-HE-Meta: U2FsdGVkX1++be8j9Gafx0GK+Jo+mSr02y2mxUcLHnXHXFiIaxIBRttu9wpbzA9XPuGHHxs/kG+tM/pn4twfuCj0Kvb9kO9/6BciE89N5QuqPHg23ssvoO4NApL8mfuRWNJBed+KZc9FDuCKoEW94TOtDGLCW1AyhE23bucX7D8j7l2yyrDxT5L6dNHzQ53qAP888PMtpErDLmv4DbmSXdDppT2aBy7v5OCiuB6t5CPbcsU0mUMdrF2ed1taMnagdEM53ymltVRU0Zj8bOQKaK3aM2Ivd9HPvA1A84wHNinYSQSlPlRHp0s0LAhpAFkoD+jpg0Pw3UgMdhiYio8R3Z24Arm/sFaTXj6Bx5ED+xE/OljI2cPXkys+D3DdtVWZ6MUGHydBmtkgw1BJdBgeXfkM1OdpG5CumYufiQr0edfHe6TKOz0LOJQx6/uAi/zYq9qiqcaCkbUO/Z1Nxsx6nWZdsSAaJy6UOr9lkCFNY9wWADOggjeXN3kffme72VPXTO2R787hTb0br29uS4TyTB8mSY0HZe9jGWcNHLKqPZtvzJCJBJFHiLbqnsb3MA/YqlEahloqUwZssJ2vcbtbVWcMYHdBJvAJR5n02xkbL4RPfGNmQczZi2SI5j7bzDZA51+OpMP5ixsgmvaaZlc1Yn46hnB3iOkJKxFG4BdP5xnK7wRkMYTStMla1nvOT1NTk3+1R8Xhsj+1ThB1C0El5jELHruZSWAQpCCGP+jSBGVrdfA7fl4zusspwK7V91OP+jEYQyh7LTQJjMson7ejA0NT5HksqFWcED8/aMtera3/NnXh1xlikEmsTpvIgzUFhYnjEVnY8bXihfIXsXd0q1cxb6Si/XFI3CTMknAdz9vYynI6qvLWcG/XoTZp90AZwV8uXHf6garGAxCAGmafxkh7Fxz8x/mFq4IijUW1T/Lm98p6ZLNkqhHAGQlxtRNHgmoBhRRkdtunQMqxc/H
 34bT31P6
 IHzGZUHJUbE8Q+VIS7quAXTYq99UYmUgNAJh7MP53Ip9yebs4MbXW7o6BxPbqf8e4x8+rM3jkR6nWudM7i+08pgoXP4UGA8yE3BGtN1tzFUFICETSrbrxn+sseV+3u9uoK6NApJPDCDn4r5IYSPYq2dJGoS6yIjBHcYFApPr37G9SCnjSWiDaeew0d5HChb41q6vr+l8J56hZO6iT/TdmQer23T2Psg406ZvheSL9y15G8vOYTjngZQSJbs8MiHVv1K/HJaZdYXgXwQAJR0b8e42y5d0D4X0Bc0l7I93zy2RYKPJK7DUstJ4cj+wKk+qkg7Ub
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean,

On Fri, 25 Jul 2025 at 15:56, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 24, 2025, Ackerley Tng wrote:
> > Fuad Tabba <tabba@google.com> writes:
> >
> > [snip]
> >
> > Did the patch [1] for x86/mmu that actually allows faulting when
> > kvm_memslot_is_gmem_only() get dropped by accident?
>
> Ah shoot, it did get dropped.  I have a feeling Fuad read "drop the helper" as
> "drop the patch" :-)
>
> Faud, given the growing list of x86-specific goofs, any objection to me sending
> v17?  I'd also like to tack on a selftest patch to verify that KVM can actually
> fault-in non-private memory via a guest_memfd fd.

Whatever you prefer. No objection from me for you sending out a v17.

Thanks!
/fuad

