Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0C1CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64C68E0006; Wed, 12 Nov 2025 10:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15B08E0002; Wed, 12 Nov 2025 10:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09758E0006; Wed, 12 Nov 2025 10:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89DAB8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:14:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24197B9FC4
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:14:48 +0000 (UTC)
X-FDA: 84102302256.05.44D28E2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D0161A0008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:14:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Znx2AKwU;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762960486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQQ0+OyWLqYJubVS6AGNI+hNpf6DosJPXicx/zXp2ik=;
	b=wwgKPw6w4YI0Gb2AEl+FzoTO7x7qVVmV/ZGBGN0e1n9FOUbhWR3FfrkkQd20FV3L37dsTg
	6t3H7OMpm24qFpJWnq3CPeXdPv0Cn/OIlRycYib0neTy1+l7bXqCq0cNWEzUHkOTAgFJYT
	CtClA+JHlAfHZ7KPCV9qPmItMFh6sDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762960486; a=rsa-sha256;
	cv=none;
	b=580ThxH9g1wdJXIT2IItMFsLRfnfKjCVRGcYUmWQCXzp/B18ly37tjVe6K274m+0cuHNl9
	It7wF/bXDZhYvHzm5lyvi+lqjm2dJTlH8VKD0pXEegjnjSZf8RUhp0M2tT4OXww2JnxI5m
	hql4zcNSz+erpxvc6ShI7ZUxAZ7C4xw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Znx2AKwU;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63b9da57cecso1437856a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762960484; x=1763565284; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GQQ0+OyWLqYJubVS6AGNI+hNpf6DosJPXicx/zXp2ik=;
        b=Znx2AKwUpLhKP2SXe5+rybdBdVbE5FcaeEkdyo8fWJWgQevXfWS1pTDrU3stYZeKGM
         t3VNvb9/c4iOjCYPdaXiuV62hilbRcyjUctGkUVQHrUD8hsbmdF2lg3v+qaXkaLpwjVc
         yq+UJBEN5kMwfN1NkdGFKLfyAvi6Jhvq0YXf3bx8vDDfY9C2TchaCN06IGAGF+NqYIS1
         /AKFI1PrGkUCZ8eSp+VC61Wah2C+kbvs6UG1CpPFrpMqiCqAipuusqsum/fg+ixHHTkC
         mLy7SKOEh88HGlBnN6R0A4Nb8WgFA/EwP++PW8VYWdZdGm1DlvG7L1v4dSLCkmMBJIGa
         uMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762960484; x=1763565284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQQ0+OyWLqYJubVS6AGNI+hNpf6DosJPXicx/zXp2ik=;
        b=mg4wSDfTRE9AiWfECbTQ2b2DQS40nYkbLjcPMoH2ftBQZIRySHU1aYj2Cb7RnUZKqI
         n0k6sv18xACSMkFm42dTJBB4wHdRJDnf3oWBsR1BF/wf33z8z23ND2WMGrFGEg2zcoWH
         FSPpTfaNangfkiHFa3kno9Tgl0R5k1Q0x1EPrwpC37Rx7sd7G9Fn5uQdFuT/EScKTwBr
         xupmcx+LcjYJqRVTnpW/mDa6uBTnNMmA9OlCjectFpB3ZR3mwNj6wkW/v8kIgiK6FRRZ
         mbFdUU5OYqovQ3ae2mc9t5ppF0JISIEbLE02giQt7VaWLoy2cfHs/DvFAVcwUyRMFFh1
         VHgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWviWh77MBnBKdAh1eo0NivSLzpsrlpneqaubRJETZ+OVDidD5kt4BiXq6lBiEaXHwsKeGJmnj/ng==@kvack.org
X-Gm-Message-State: AOJu0Ywpu7MgzgH29Rny6xY6O9P2CcRFZpSZErKx932NhLbMvRp2yimd
	GcnAVKhoRcSZ8/lX0zcXwN5a6jyu08dHMURMJlfae+BmASlXH2fHKxtVVyFVByzxWlvoKmIZiL6
	Xf+ea8byrNL8JEupDg7TecMOENQvYHH3HxTcVK8F9vg==
X-Gm-Gg: ASbGnctt556IOQuuZ0W9Jfn2Flktpgf2BpXmmgRmDfiJF1wtqkyrzYYjaxudu+hDBfu
	JVna6PFNdcd81pW5Qgzr+azY4ICMtES18aOsqex53isaQPsAb2wdk4AIQITBdjDEvwYBHmewjQ/
	MwaiipmvZVyioSwR29NPLNdFRTa4fFEjH+dMlumOU+UxdBAlCAlQuhRnZPttTVUuFnqoxF+iF6+
	85XohEetBt5sG9glg3CJG+ar4PeaU2Ts1myodu5A9kfcjO545x9zCQPQw==
X-Google-Smtp-Source: AGHT+IHvOWdCZpIHJdaITaurDIMyMeqdwSgS8ChEWfqyly8byOG2zD+TlxMB8QW/ltMZhyzar+Gs0r2HAPI8mXk2QxA=
X-Received: by 2002:a05:6402:358d:b0:641:3090:cba3 with SMTP id
 4fb4d7f45d1cf-6431a577cd4mr2984066a12.37.1762960484292; Wed, 12 Nov 2025
 07:14:44 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRObz4bQzRHH5hJb@kernel.org>
 <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
 <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com>
 <aRRflLTejNQXWa1Z@kernel.org> <CA+CK2bB8731z-EKv2K8-x5SH8rjOTTuWkfkrc4Qj6skW+Kr7-g@mail.gmail.com>
 <aRSMsz4zy8QBbsIH@kernel.org>
In-Reply-To: <aRSMsz4zy8QBbsIH@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 12 Nov 2025 10:14:07 -0500
X-Gm-Features: AWmQ_bnD0Fa5WV9clCVqwOFMlUw8urbv0kYDUHAZVRNByd6elh9oV6dClE850Us
Message-ID: <CA+CK2bA6vCH=RkiZjAOsh5iR52BY567bJB3HNAGqDb307YxVdw@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8gey19gjprgi3o1gtozyk86iuufqpubb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D0161A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762960485-277260
X-HE-Meta: U2FsdGVkX189ksDVR6cpJ9A7/zEWMm6LSY6uNYhtV9bhWgI+kD5+YM9En6FfD0EpdrJiOkwh2R/kZjUSWHER69frec/VIyZDQNeJX4S/5wGTGca/hudMVJ4l2TXS2r3rcGHfcF9V1HERRKJptBELNTq0kM8ELI0GYLBYqoflM0FPvv5p9eEyR2nQ0QSwiJiCegCfUlLlv37CXeh6wgztST+cysXvLUJNvQn3PNDWa7XV78xlPgPWh1NWXrjcF1dTBmwLRBxxar4TSxKeSI8RPK+vsj9aEoI+RAG/SIFjMOlHdm+SHj0MGLIatzkFu9GmADEL2w/Q72ktExV/OPnWXOCeQL/Bt/z18phV1VxtfrIUR2OnS76HCG4dEhcFALAUpUjJJVyYOPbBgYlPrYree6PghTzsBfLtIscfFjpbGZDyRoqhY0jhwbZ07IANTpCEH9VEqBnHD26m5KbUzvesUK/YpR8SmD95Pn5KaRTV6V1Zd/ejbsY9BG2QVttDXo/y7Iy1ZpiF0wY848Wm5V6Tfp9FB7Rmp/Kvdo1tB7ho1ITBGPB6G2ROlsys2xwfLVJHRUuHCm1/ec51CI4XyAF4eD4U3xKUgqxjMegr6TG4Hz9yVU4x08J+819FZfI25DnWzZFCm0hBgs3slA7gUbEmirXDk6bWSsvaUsnh9cn5T/+gML3ibTUH/kQ3lwbScTI4zvmObVmlVgOTjdP7Xd+2ys0cO+pZC5SyzC/ahWgSNDuSOjBfgUhTCat6rPHvqlMyJMl7rZ6yEYNrYXruO1fn3ssz8NwYzJYvvnan01HGT7YGJq5s+Qv7B0k53aYL2+sfrY3x3++abrQGItaTaY4ewo2/tPQV+BsK3fGEXmR66RYkMe47ktYpvQHbXVfsJY7nM27WxHHvzkSjfD2SJy12V8BE60UKtpwxwVJm5c8rkYYEJDrbD4fADrB51gX3LiJx1NtSvgw994v9EZd7gW8
 /OYh3nZT
 BBIqe6/o9LUCCYs6bhWfPB86sm1dTPh0whD9jBDhU5WCApobACa4AC6VCFkfx+e/GGXBrumxZay3BATzvfQMi5sig0x0DSbzJYDP1Tcy1fdC3f7Nwc8jpZAgMCyqJ2iOT7O/RNZ9v98mwO0LDY/7Y6BvQ74kfORrwmkGDSMovXOOoqH6AcZvdZnmWqUzIpxkDm+VmYC1rZiYTVQSJD7GbL08m9ClY7/MA9q6uczhJApC6XtQdo/O1mjyv/elGj38fykrkzZoj3I0rReRqNp4Rc5weBb7zdItctgU1WJMIU8v58bwj9mBefOdVAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > FLB global objects act similarly to subsystem-wide data, except their
> > data has a clear creation and destruction time tied to preserved
> > files. When the first file of a particular type is added to LUO, this
> > global data is created; when the last file of that type is removed
> > (unpreserved or finished), this global data is destroyed, this is why
> > its life is bound to file lifecycle. Crucially, this global data is
> > accessible at any time while LUO owns the associated files spanning
> > the early boot update boundary.
>
> But there are no files at mm_core_init(). I'm really confused here.

This isn't about the files themselves, but about the subsystem global
data. The files are only used to describe the lifetime of this global
data.

I think mm_core_init() is too late, and the call would need to be
moved earlier to work correctly with subsystems. At the very least, we
will have to add some early FDT parsing to retrieve data during early
boot, but that would be part of the HugeTLB preservation work.

I can move liveupdate_init() inside kho_memory_init(), so we don't
need to modify mm_core_init(). Or, rename kho_memory_init to
kho_and_liveupdate_memory_init() and combine the two calls into a
single function in kexec_handover.c.

> > > So I think for now we can move liveupdate_init() later in boot and we will
> > > solve the problem of hugetlb reservations when we add support for hugetlb.
> >
> > HugeTLB reserves memory early in boot. If we already have preserved
> > HugeTLB pages via LUO/KHO, we must ensure they are counted against the
> > boot-time reservation. For example, if hugetlb_cma_reserve() needs to
> > reserve ten 1G pages, but LUO has already preserved seven, we only
> > need to reserve three new pages and the rest are going to be restored
> > with the files.
> >
> > Since this count is contained in the FLB global object, that data
> > needs to be available during the early reservation phase. (Pratyush is
> > working on HugeTLB preservation and can explain further).
>
> Not sure I really follow the design here, but in my understanding the gist
> here is that hugetlb reservations need to be aware of the preserved state.
> If that's the case, we definitely can move liveupdate_init() to an initcall
> and revisit this when hugetlb support for luo comes along.

This will break the in-kernel tests that ensure FLB data is accessible
and works correctly during early boot, as they use
early_initcall(liveupdate_test_early_init);.

We cannot rely on early_initcall() for liveupdate_init() because it
would compete with the test. We also can't move the test to a later
initcall, as that would break the verification of what FLB is
promising: early access to global data by subsystems that need it
(PCI, IOMMU Core, HugeTLB, etc.).

Thanks,
Pasha

