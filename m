Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49F6CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 18:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2348A8E000C; Thu,  2 Oct 2025 14:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4F28E0001; Thu,  2 Oct 2025 14:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D40E8E000C; Thu,  2 Oct 2025 14:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECFD28E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:43:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B12421605B0
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:43:21 +0000 (UTC)
X-FDA: 83954047002.26.A096133
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id E772640007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:43:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bB7kuI0H;
	spf=pass (imf01.hostedemail.com: domain of 3xsfeaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xsfeaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759430600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BF36+HuAPUu3G3takel+0xxVXkuZOozonOLvpYNbbPY=;
	b=xybqujtz1VNZ031bmN9YdPRmBH23pDzpa/IzAs5p/7IHwv7rkjMHLy5QbG72OHAMCFVxVz
	0+Q+TH9290pFLkVd1eVbYzKFHo23KERvGsg7f5sZkSFdBPICk3uLpDRugi2DXcLSlg3R5t
	IaEZ6yU+5b74UESqbJ4CbZxeTZms5x4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bB7kuI0H;
	spf=pass (imf01.hostedemail.com: domain of 3xsfeaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xsfeaAYKCB8N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759430600; a=rsa-sha256;
	cv=none;
	b=cNmUTgcmqO1TKEShnI3ZoSRsDLyb+qULhhscjrkNJV40L42kaKNNG4aawNGVljAzO9g0LQ
	ZAcWeWP3Utlnqwfxzc4mnrK+GLXsVYA/CBTIXZXSzthpRRD7bk7zsVqF5LzEPZ1sbFqQ6x
	tSdVgiwSqGooRgJUa0n7lJy3AAC5LVY=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ecab3865dso1868452a91.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 11:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759430599; x=1760035399; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BF36+HuAPUu3G3takel+0xxVXkuZOozonOLvpYNbbPY=;
        b=bB7kuI0HJL3hUSfLxWDipOa5JS5YwF+yktLAVR++R+e5GizvPW8LhzJNxoenk2CFRf
         QTfupHFX+dUJXFPrCmgLShavCc1VuBVA3QwAb29RfYQq1lw7aTI0brQHt1I8lq32VWy1
         wAeAHyLqKEQ7/XyQNMOJ81IjsnONw17KnTopaUgV69ByxPPn6clZqm8gLH7FqEgKJXr4
         YYQ6xujUrJ1zx7u+bUsRjIq0REaL7InL97RuVP1vH/u0yL3CiE7gYIwt9lBX9mYiNepK
         1fXZSEu2SkWMTq2poBlZ60ZbnAtMry6XYdd/kB7kGijRIiKwrtBQ4PRAkGcGO5DbYlcj
         WSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759430599; x=1760035399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BF36+HuAPUu3G3takel+0xxVXkuZOozonOLvpYNbbPY=;
        b=dgrUoLutH28w8ZKmE40bZTmdcfc5/Dcieus/pRXAc+ur6Hhn+/qMq19KJCXH/c6b7r
         PNKVeELxsiWVvNpOieuE7iqE0a9yiUsN9licBUDdRyxE61XMpzqt+0aZA6ypyv0XIR0a
         FUuL4a6WQNcU7DohqSrw5zwHS2VYPsJTw59eOjA/JdVTkAePI/dIPiGCp7gR2SzwjyX5
         Ujw1vuPl9r43f6/5G2V4mhumazpsJr0W3KRBpEsdxZSnB0DpspcX7Zv2T5K38knvI5Hp
         rpUSmMvjmrRP4N9184Ak0kyl64NzuDbRJ0zTRISl2P31QHRbN+9s83C5kKed4UkNA7kV
         /szw==
X-Forwarded-Encrypted: i=1; AJvYcCW0QbzSIVYHPxBroL+VlYbE3DJwiqDaskiZ1sq3CjIf4MWHC8Pn5R2qZfCTGGP1oeE+ssvY9iuVrQ==@kvack.org
X-Gm-Message-State: AOJu0YwzrdNLM5Xr4E/LPXSJE2PubkiGdSYHAk0FhveH4Vsyci0GdQf2
	/sXn0mAavmbFP0lnvkqIrfAl1oqt+aE7FDAXYCXHVQJuN+BHoslofTyOdHcVSCPeUGkGRqEx49s
	K2rIuTw==
X-Google-Smtp-Source: AGHT+IHzKP+mkTV9r2F6im0ZZKYHqqWZ0dx4/6eJaCqR+H+7NxXGm68uyuJOAHQ9Qymj9O+tm0fETNVF/Vk=
X-Received: from pjre16.prod.google.com ([2002:a17:90a:b390:b0:330:a006:a384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a8c:b0:32b:cb05:849a
 with SMTP id 98e67ed59e1d1-339c27bc475mr438569a91.29.1759430598389; Thu, 02
 Oct 2025 11:43:18 -0700 (PDT)
Date: Thu, 2 Oct 2025 11:43:16 -0700
In-Reply-To: <09e75529c3f844b1bb4dd5a096ed4160905fca7f.1747264138.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <09e75529c3f844b1bb4dd5a096ed4160905fca7f.1747264138.git.ackerleytng@google.com>
Message-ID: <aN7HxBgFwm2B7Cv3@google.com>
Subject: Re: [RFC PATCH v2 11/51] KVM: selftests: Allow cleanup of ucall_pool
 from host
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: im4tmzfpffdw34si6ciwjufc3reeonz9
X-Rspam-User: 
X-Rspamd-Queue-Id: E772640007
X-Rspamd-Server: rspam04
X-HE-Tag: 1759430599-457443
X-HE-Meta: U2FsdGVkX18JQ9H7MxCt7w+s/A6ICT3inmx7TSyGozmmvNwRwulmpH8fH7gViQQNFgUCS578NTlARs+1bpOIZ34vU+Za6f72GPOEwQ9WQOw0oYS49Bobk2ozkBLrgkJsVt7h13AH2eMGX+GkGpOhhGSGWBPfyVdA/ed7Auz5o77Tq9l2Sl385rxYF8IbkK4M9UgGt7UmNw0fAm9A8RrKoKGU8hReadTA39WeH/FE7YK5YEM79iEHTBryhdYnd34bBq5TaGPG8jzWEypCPwIkkegdeVmlYVatPtUqK2vE1FnLT9aXXgjySvHpwhdVRoPfEel78r22GpCD6jwQx7BkOrxUaVgzyM2mtTVJutVrs1OlFkYVxU8aCPKJWwU53pHhh2pxJS0IQpsqZcaNRNcEKoBBKBX4QtN+t3NGszosJMupau5ecxbhUmgJwDbMjGm3XjL5y0E8GZ+EFeCUoK9BlDCV/SzgsSDbftM205Wi45Jy7+ZgP9dvEOFbr7CpEDi+LGPG3o2kIWXBMA5vgGZp3FynjEzU5YE163EeEGNJHWC7tb4E2fVdMzQFpYA65C65mxuJ4Emg5zo0XgxIFq1YuCg5bU6n81qBneSpsA5dQloveaGfnNI82rRLVhUiqvUrPRL4n8fxOa7XAIwx/pFQ3M28v5eG6n0b0r2LWpVM1C6jB4I/Xg1IFj2hKPffMq0h8vXggcEVVy9C2Aesspe7Sn0a7aTPBUFYbJeDRjDxNfoPKTxXwSiKaBXEK7npVj0lGIHXBf85WgbU02Pa4fSYLlpKemiLBM2wI73dAlJPx2pxFB4b7ua91zDNR5MoYdBsHX9ZWro1irUilR1epz/WqLay0S2euBaofk/8OAOHlZWlGd+xz8KSgIgdA62QWCdrEEILLkI2OD9SLhF95MoQ3RZWifZPVqYA8MY9c8i7dzlMgs9jv7jne4voMuJVaDcsOp0SRMhJdUbHIeBD4it
 iFy95r8/
 q4kDlYj+CKoy7NxCPO/gfTnpx1a0xd89IcAw8A1NUWEKHkESOt6VTkQi7NBvpL28A+wJEXMmWq/afz2xbbuX5NRY3yzI5dUzUp1sRgkCA33A1Pn7wophZ2EHPVkl06B4JTyNBKKuVOrLWmJwQY+r1QNkku0mdQoZZqyqokcHhq35i6kAcnavDeZfNdk1+hFJ9q6Od9DuYkVZej9oZkaS1kqB/qLPY8ETYgrc4soXr+5BQB/mLuVVno8Eq+mWnVjbAashz5cVcGCahQP2KMHtjHs1EahaZoxGRRvvjFDs/yUHZHIU5A90wMaBDEQlINx87tRv+WnGWk8GA9IU765rcC733GYbJPfTDSc7frO6DKUW4d0sNL6kwU8ed9nH+RJvVrlRndXu0/A3z+1jkprD7fpQvMBnntiHeBs6s5RStjLkWgT77mZsH0hbhEpD7hCpct0DVsz8G+yZviqKK9aokVw/34C1rvLx70tYqQA2HPQ2Gwu9ltuNtYUm1zgUxeMJZK+sKCVbbWZEkPkGI8L9ahVy9jvw0uPIS9qV3yy3urbilGQEFYmsYHI/4rBZPAiCfoMZIP1ZGd4W8YeEtflbkS6Z1QOK0W5Er64U31LIB7GIPqbbBFF0M0+gkv5CN/QifhDykG3xUerr14/Je7CYe7NSWNxefZ5CkWufEA19Rl/7g2JhTl7cdH4O5yqoqcWHP9rZXhSoMRglePAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 14, 2025, Ackerley Tng wrote:
> Many selftests use GUEST_DONE() to signal the end of guest code, which
> is handled in userspace. In most tests, the test exits and there is no
> need to clean up the ucall_pool->in_use bitmap.
> 
> If there are many guest code functions using GUEST_DONE(), or of guest
> code functions are run many times, the ucall_pool->in_use bitmap will
> fill up, causing later runs of the same guest code function to fail.
> 
> This patch allows ucall_free() to be called from userspace on uc.hva,
> which will unset and free the correct struct ucall in the pool,
> allowing ucalls to continue being used.

NAK.

The ucall thing isn't an issue with GUEST_DONE(), it's a general issue with not
completing a ucall.  The simple answer here is to not abuse GUEST_xxx().

I tried doing the same thing (jumping back to a guest's entry point) in what is
now the mmu_stress_test, and it didn't end well.  Restoring just registers mostly
works on x86, but it's not foolproof even there.  And on other architectures, the
approach is even less viable (IIRC).  E.g. if the guest code touches *anything*
that's not saved/restore, the test is hosed.

In short, while clever, the approach just doesn't work. Which is why I don't want
ucall_free() to exist: it's only useful for a pattern that is deeply flawed.

The easiest alternative is to use GUEST_SYNC(), have the guest code loop, and
use global variables to pass data.  It's ugly, but it works and is much less likely
to have arch specific quirks.   The worst of the ugliness can be mitigated by
using a struct to pass info, e.g. so that you only have to do one "sync global"
call.

