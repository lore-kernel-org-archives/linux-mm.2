Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657E9C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3706B0118; Mon, 17 Aug 2026 18:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A6D6B011A; Mon, 17 Aug 2026 18:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0CC6B011C; Mon, 17 Aug 2026 18:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9766B0118
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:20:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FCF3140993
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:20:58 +0000 (UTC)
X-FDA: 85112182596.25.2F9DA24
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE807140003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:20:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lfK/VuVJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3R4mDagYKCMI0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3R4mDagYKCMI0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787005257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QnMwcUHFkDNVo8ywONCXuoDqyMfQDcpXyu7v/SbVys=;
	b=PEQ4KDUD+oJKk32ItoxH5fKNHOBd2Q5tu1N7PBWyBmuHhcZ0u4CNgzBRI6UerRWELh8BH1
	UNuzL+F+Rra7WoJ1OB0gshdPjeXImIiw/OIS9e6TNC3VdA6D0zgybnGO/Orq7mmhHJ9Iwa
	MClOHk51udB/17a5gwXvbW13ZAe+hSA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lfK/VuVJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3R4mDagYKCMI0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3R4mDagYKCMI0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787005257;
	b=1J0PorUOPc2BJ7kqA2JKyfDQFCbD4ESCKDPr+0faxZleXXRg5cee6pjQPd/EiMzq6DnbUX
	EY+J1l9hHA4kcSXuwYxEsn6iq73dcZQaaefMbh0gmKvI0GDcN0UrsucCWRHZ0YwYJ99OVr
	g4T+1/m3qJ+sd+WJbK4wOMu7+JDojVw=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8487eb67173so6734866b3a.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787005256; x=1787610056; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4QnMwcUHFkDNVo8ywONCXuoDqyMfQDcpXyu7v/SbVys=;
        b=lfK/VuVJEAASl1rOvZwVt7eMkYgxeOjtoH9+nAkBuSGmPy7SsH9Rgo5Z5dLSDJljJw
         buLzkII/qo1zHgW1QTbQEkHA03CmuUqFCPIF06qn+g1/ukys9eyKId3/qn7pzYhFk4SN
         oIUEvHuQbvuqNwp0ktS5yInxEzlRLWZADGnA9uFlrvCWwCnXYw+jnRL/u5/VVw0ee/KX
         QZIXWQMmIRPTUfE2fagDOhJgg88Z24d6QFwY7klWwU5LMtQyyTmZHFdMKo24SSywS5tD
         Dmdlw+CmHfrI880hYJipOvJNHUmPzbv+zc6JPuJAdJdIUTitCgYQEEM306dxmKtbNe0y
         CBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787005256; x=1787610056;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4QnMwcUHFkDNVo8ywONCXuoDqyMfQDcpXyu7v/SbVys=;
        b=ZXAgSJ/mDnMLJjwWcjrEiyCNxD6EpLN5S0ybOS6/fMcnld0+gevCiHTyb+APIl7chL
         e4p/VccGcNmTt4lVq1oGpPlNfBZ2WGQT/A9XYpxIyjgbo9X9eGZ7PtzWBX8akErf6eVP
         YEq/H1c5Nig4VETD50LiXZgrcSLUNAcpPul1BmAL67PR0CvFhXwLD6CGkLj4Y1+egnzz
         JzvNj9air+dCsA6NaFa5+6bdWDYOMsCN5kq/pmpRdQXPZTnIyCNzyv7E+3d6+M2glKfA
         IaoFxUtUd02CXNcVMsgOX88HBd891HHkLTKkrWlghcOrB/OYcVNxw0AmFs+mLGqui50i
         wOZg==
X-Forwarded-Encrypted: i=1; AHgh+Rp8s4vUfA0KtX6oHK+SZVQ5qa6qZ2VI7KB1kMX2g7Cxe2RrEArOQUeHBSo7d5bV/xsxoHHRWsK37w==@kvack.org
X-Gm-Message-State: AOJu0Yw6k+edorqGydsl5lcx3IDs7KQ9/C5EV661Ue+nNhavPD7iEpGf
	PBNsCDWvJv3/msqb7jt4W7dMuU9njaielXqag1W5w72ITvOAExT7d7JfStQ9QQYlOA0bqYx3Ei7
	ViXVyLw==
X-Received: from pfbfq10.prod.google.com ([2002:a05:6a00:60ca:b0:84a:3bc9:3bcd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1149:b0:847:7ffd:ce35
 with SMTP id d2e1a72fcca58-851b87eaa83mr3450412b3a.8.1787005255291; Mon, 17
 Aug 2026 15:20:55 -0700 (PDT)
Date: Mon, 17 Aug 2026 15:20:54 -0700
In-Reply-To: <CAEvNRgH_=8YqKHb_OJfT583ZJ346cceRimd9YJ762Vv08uJGHQ@mail.gmail.com>
Mime-Version: 1.0
References: <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com> <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
 <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
 <an5RJYTwlYeym--O@google.com> <aoKnmW9St5zCoTD3@yzhao56-desk.sh.intel.com>
 <aoNrFX9yLfsM7KQI@google.com> <CAEvNRgH_=8YqKHb_OJfT583ZJ346cceRimd9YJ762Vv08uJGHQ@mail.gmail.com>
Message-ID: <aoOJRk5SXBzzT24K@google.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"forkloop@google.com" <forkloop@google.com>, "tabba@google.com" <tabba@google.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>, 
	"tarunsahu@google.com" <tarunsahu@google.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jthoughton@google.com" <jthoughton@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com" <shivankg@amd.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "youngjun.park@lge.com" <youngjun.park@lge.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org" <liam@infradead.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: j1gqbf7y5wqnp1mx3ekoft3f18hjsaet
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE807140003
X-HE-Tag: 1787005256-313609
X-HE-Meta: U2FsdGVkX18GqHJF3/bXZeRlqPUVnWYOs9Msh2wC45W+vtW+peRQEIZOeWFtQ/R6lO0yEYOm31ucZpBB0CY+Jmyr+ef8Qda53NLi//eSssFm3WnObo/GAfM+/mM/9wlll3Npo+K6cbPOlcj75OtXINUALPQ4mqY4tVy3mbxbCNU+FRFUh7InPM20+i66qNEQxxg46q5z2p7ed/BuG6/80jUCIkkV0MPNEj3dhtfMQrydK21JcMN2fDDOpZzK+5nXSjW2G1ANz7TTzuQmmlTAxclKbE6NVVPKGBd6osuyW6Z/BrOnN6eXAChbgsaxOdf7u/iYE6B1o4DYQqQTCLCDOPaR669SPb3AAZOJ+aZ0HqVW1IpkAgjnWSizrgLkFZdaqsj3nAxlTvZnJsuCWzOmwi5Ltb28uRStjTh0biz9etb8tUltGAsNlPebcZ4HdxZ18A8wYYT1SvE/8l+fG5LudD6rz2jqB5ATcC+nqJ0q5hrOWE2SSZz4TZhZj5naEmrh2xNlSNj/HQuMOT82mJy3mQLSKMVcCgy0LAKg1Cq6nZHD6cOtlskMky1yd5rgq1x70lgSY+b+PHLOCQflGN6IrTvyW72QFsBor1LcmCUiLRlFEaZI5qyMm1/5wFLFi+497UotgZsOxzVMZZ298KPrVDicIIeQgwoTvl/Tr0Bo+leAxr5l3weK0qZOPJlWC3Bf3UZV39NXCcmB1xoFS5s5cbpexQ61iImQjQTTMBa0eVpIxn/OIr6pq14qGSW113lpQeheiyhu8ztoFSSjFzs1kc4MoT0rdflpZT+Ffkkp8dtb7DIh/hypea6mu7ZaaCYv1RZJ+dYuTmT91LueNFMSiOybg+aFXW88+BQ1XqDR8fu0ITD9kwc3zi4yZc+x+7Ih/ehx4sg5YHzJ6Q47692j3jEocqKDxMmcaxnb0zfDaHMJTHnxSx+JSPcVYlNI+TNVmRVSgPlij8Z0UEkdYPw
 9z1Urtgx
 zojJJDCXd5LPZZ/1/Bua1ooJLFQcWfdDyLEgBucyj/U6crzyWQ7OlU3whZY4edyMzegR5tui0lIHZTEMEH3DOM7bLqt+j6dyU7M9iMhSug0Up9pueBN8GBPdHnX2A3qF5aFpUFjFWwaOk5G6sJ2EUw2mTvnLH2RYJcBAqbFacCVUlpHBueg3QXu4aR+weJsqtjejFQO5HQ1nfWAa1GRe0IaIZS1uCZ8cWOFR1+sCrbEw249C5562eYG74dquM8rV5CAX3kbOfeJPvkUs2QhbtQrPEu67X14nWDY5zUmshRNndlhdXRHWXr91rPuVXtIlFf7H0XKy03JG3wMZ1TwudWja+49Yrvl2SxFnhdl6FJHpkficzx3USQTDAbhkNWb9gJ++F6tNksuG+/AiPSLLtZSgAP9flfzWmYQvwtycu1A7JEt4ambuc2jo2ZAKDQoUaCf9SNQKQk0N+zb2oPY1Y7YoyiV4/ordFJPQleJ6HxTTUxBD4RQ+oOZ6JlGSBlZc3jhAPZb/6PWsn2j5bnGxCvdYeh8KYNBIzMPoe5/i1zrQqwva5EC84GB55nGDNTzqdMVQDO8ywF/lDJ1U9oNmt2pPHoG0XN638x1Lps0tOKIjWtrTun99wom/aOlslVwJIv7ls+vX2mHTdk63Zf58uhsGHxPYVpPDo20yealw2rXJTPCHaQFhk954BB1s3F+m2lzZZCQpwIBRIzzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > On Mon, Aug 17, 2026, Yan Zhao wrote:
> >> > converting a page and another faulting in the same page.  An NMI, SMI, or IRQ at
> >> > just the right/wrong time, especially on a preemptible kernel, could lead to the
> >> > same test failures, even if KVM drops the refcount "immediately".
> >> Could you elaborate on how an NMI, SMI, or IRQ at just the right/wrong time
> >> could lead to the same test failures?
> >
> > Ah, sorry, my bad.  I was speed reading and missed that the key to your suggested
> > "*page = NULL" change was that the reference was put _before_
> > filemap_invalidate_unlock_shared(), i.e. before dropping
> > the invalidate lock and thus before __kvm_gmem_set_attributes() will walk the
> > folios to look for outstanding references.  I was thinking that putting the
> > reference right away was just shrinking the timing window, but putting the
> > reference while still holding the invalidate lock closes the window entirely.
> >
> > So, I take back what I said about this not being ABI, and about this not blocking
> > in-place conversion.  It most definitely affects ABI, and so needs to be addressed
> > before merging in-place conversion.
> 
> I thought back then when David suggested that conversion can return
> -EAGAIN, one of the core ABI benefits is that this leaves the door open
> for things to gradually improve. If we can improve stuff within the
> kernel, then the the kernel would just return fewer errors. This retains
> backward compatibility, since extra userspace code that handles errors
> can continue to exist, it just won't be used.

Ya, that's definitely one of my hesitations to trying to guarantee success in
the kernel.

> > The only question is if we want to commit to
> > guaranteeing that conversion will succeed in this scenario, or if we want to take
> > the easy way out and formally document that conversion can fail with EAGAIN at any
> > time, even if userspace has never mmap()'d the memory in question.
> 
> I don't really think there's a need to commit to this, IIUC in principle,
> ignoring that on many paths of those guest_memfd may be excluded, refcounts
> can be taken even if there are no host userspace mappings. For one, memory
> failure handling doesn't care if there are mappings, the refcount will be
> taken for a short while and could cause this conversion failure.
> 
> Here's the relevant part of the documentation added for conversions:
> 
>   If this ioctl returns -EAGAIN, the offset of the page with unexpected
>   refcounts will be returned in `error_offset`. This can occur if there
>   are transient refcounts on the pages, taken by other parts of the
>   kernel.
> 
>   Userspace is expected to figure out how to remove all known refcounts
>   on the shared pages, such as refcounts taken by get_user_pages(), and
>   try the ioctl again. A possible source of these long term refcounts is
>   if the guest_memfd memory was pinned in IOMMU page tables.
>
> > I'm leaning pretty strongly towards guaranteeing conversion will succeed.  We'll
> > still need to document the EAGAIN behavior, but IMO there's a massive difference
> > between conversion failing if there's a lingering reference acquired via a VMA,
> > conversion failing because a vCPU page fault raced with conversion.  E.g. being
> > able to assert success in a very curated test, as the stress test presumably does,
> > would be extremely valuable for helping detect/prevent edge case bugs.
> >
> > The argument against guaranteeing success is that we might make our future lives
> > harder, e.g. if it turns out there are legitimate, hard-to-solve edge cases.  But
> > I'm ok with that risk, as it seems highly unlikely to be problematic in practice,
> > and there is real benefit to guaranteeing success.
> >
> 
> Is there really a need to commit to anything? This is already documented
> as "can fail", and it's orthogonal to whether the memory was mapped.

Yes, but the above docs also say "it's userspace's problem".  Which I generally
agree with, but that's not a very good story when it comes to KVM itself taking
transient references, because then the answer becomes "Stop running all vCPUs",
which I don't like.  E.g. in a very pathological scenario, it's theoretically
possible that conversion may never succeed.  That's what gives me pause.

> The transient nature of refcounts on pages in general makes it hard to
> guarantee, and this stretches outside of KVM. I mean, anything could take a
> refcount on a page in future and we can't be auditing the entire kernel for
> no refcounts on guest_memfd pages ever.

True, but at the same time, if there were never any VMAs then I would expect there
to never be transient refcounts, modulo memory failure.  And it'd be easy enough
to document the memory failure angle.

> >> > As for in-place conversion, this is not a blocker.
> >> Sorry. I didn't intend to block in-place conversion.
> >
> > LOL, what we intend and what happens aren't always the same. :-)
> 
> I don't think we're ready to guarantee conversion success when guest_memfd
> pages are not mapped to userspace 

Yeah, that was too strong of wording on my part.  The needle I was trying to
thread was "conversion for this specific scenario, in a controlled environment,
is guaranteed to succeed".

> without dragging this out way further.
>
> I'm all for KVM not taking any references on guest_memfd, but I think
> eliminating KVM itself as a source of transient refcounts can be a
> series in itself.

Yes, it would definitely be a separate mini-series.

> KVM not taking any references on guest_memfd memory is definitely welcome,
> it'll pave the way to using non-struct-page memory in guest_memfd.
> 
> It'll come, can we not block on this please?

FWIW, it doesn't have to block initial merge, just the final release.  E.g. even
if we decide that this is a blocking issue, we can still land the in-place
conversion series, so long as it's not exposed to userspace in the final release
of 7.4 (or whatever kernel) without fixing the transient refcount issue.

> If we find a way to strengthen the guarantee, wouldn't that be an iterative
> improvement?

Yes, but we do need to draw a line in the sand.  E.g. if conversion failed 99%
of the time because KVM was taking spurious references, I think we'd all agree
that needs to be fixed before the code is released.

I'm still leaning towards saying this one has to be fixed, because it would give
us a solid baseline from which to start, and a way to enforce it going forward
(Yan's stress test).  I could certinaly be convinced otherwise, though dropping
the transiest reference seems straightforward enough that hopefully it's a moot
point, i.e. we land both in 7.4 and don't actually have to make a decision.

