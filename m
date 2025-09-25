Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D100DCAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361A18E0008; Thu, 25 Sep 2025 19:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311628E0001; Thu, 25 Sep 2025 19:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200B88E0008; Thu, 25 Sep 2025 19:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09ED18E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:03:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A15FC11A449
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:03:46 +0000 (UTC)
X-FDA: 83929301652.23.86A7743
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id D119E18000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:03:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sAgeBxhH;
	spf=pass (imf16.hostedemail.com: domain of 3T8rVaAYKCIg4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3T8rVaAYKCIg4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758841424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtCsq70qhQXvjo5i7WnTkFuUeYKslZCOA6r0Ck9tpm8=;
	b=rs4tEPyW33QffbdGeLXhE1fq+wMPTU8El1eeOtU0RzJYhyNQEcvxPCmjrPVcI+FvtGHNvB
	iAefoWZ0Oc89RhFuvmMhXcrM+HO7mGY0tm5ilVYrRqpH6CtATF7QGDHwgLR789yFkcm9OH
	CqdMPEyF814aVsvIFfkA2th58BohI+w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sAgeBxhH;
	spf=pass (imf16.hostedemail.com: domain of 3T8rVaAYKCIg4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3T8rVaAYKCIg4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758841424; a=rsa-sha256;
	cv=none;
	b=Ol9R4I8XDRIPRYTOYTFkpmfDnD4kV88xuSxPwlfKYquqWwCqWAwEoUIvTZ/ECchfltc/QP
	oisYUgzcYzVdN9iNDf0/vsqeeRcu86vdk9MN3K3HSrptYlbSP+vaiHcgnEk72Ud06KjtKU
	oPzKAvmccsEMYg90YG3CxFptkCBrxJY=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so1438549a91.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758841424; x=1759446224; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtCsq70qhQXvjo5i7WnTkFuUeYKslZCOA6r0Ck9tpm8=;
        b=sAgeBxhHcEjUba5sU2nifZmSDXU7DW5CzVhLNwvzK5F50WA4R0Pv5/WC00YcT9Ok3x
         DE0XAtYd8zeGk1JAb86NQyYFVYsToAVX6dM+2CHYzLPE90aJNAe1vL+rNiA26/rlYVYz
         Ek/N+wNiPp54M4rj3zXI3jWrPWl0MSgkTK7Bpk9b8ckK2C5n0FH/Z68i/8lm8TPjRb8V
         z7Wh6g1wJj4dGEs1yi4diqyLSnzLPCYQsvbCv7EwVFotRjdFKHipeN8bONpn7QcxWrTg
         prBLH5Mt3FEIYxq8SCcIdVWdBLXfIFPWZk4YGwOEr0uhP9EQOUIgwau5Mj3da0ItJ2UV
         1SiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758841424; x=1759446224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtCsq70qhQXvjo5i7WnTkFuUeYKslZCOA6r0Ck9tpm8=;
        b=POjZKN73jrtOFrA1+w+TUgZWoB4WAy3nX0XwuHd6YdCkCQG+uitUbjN5PW1fTBQymf
         R67fh59394KSsQxuc45o/KxI7OvrPFe+bwOd6SMNAEZmZdprBmI6Kx6nO5PCnn/RWhQT
         5dtaLg9iygg3bCDbNvSDrZujG4HgFZ73o/qNnEBkZOGSdWs8KAaS1Ff5D2IDNnPbmAJM
         1MjNjVYXlVxPpfw9eQgnnb/c9jAccYBflWXZgqWjmpGz0IFOE40/88B2T8XS1DeNsZjd
         AAUQ5n5pB7C6MLH+y5c5CXXUCQkytPw+S+q25ENgVeWDnQfzZmUYvOFgWYP0bFI7aDn9
         wnpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx9utdL18AhaE3gJz5vumO1DUtO521PSboWVQNmRg2LmvJCNl1bviQ5qC3KCp9JSygsgqzHQerew==@kvack.org
X-Gm-Message-State: AOJu0Yz5C4pdy5s35kos0lo32QNObLg3AKl+0MpIExXP57Z4ZHp9Iz2m
	FQA4JsOJ6Sef4U6GhJx5KRTx7EXBX5519Zbb0NEMrdTjXc2JgR8pPtoGkN0KE8ZrQ+xdKj3rtcR
	Fu7Ulrw==
X-Google-Smtp-Source: AGHT+IFCIuxfWzAAq0mG13fuYXVsG7N7KK6Fo0/VQdrpMqaeQ2l1EixZPHW4Wo1ErVxR9DWPn0iSBzBRvc0=
X-Received: from pjbqo8.prod.google.com ([2002:a17:90b:3dc8:b0:330:6d2f:1b62])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b4f:b0:330:852e:2bcc
 with SMTP id 98e67ed59e1d1-3342a2ca0e6mr5749959a91.21.1758841423443; Thu, 25
 Sep 2025 16:03:43 -0700 (PDT)
Date: Thu, 25 Sep 2025 16:03:41 -0700
In-Reply-To: <aNW1l-Wdk6wrigM8@google.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-10-shivankg@amd.com>
 <aNW1l-Wdk6wrigM8@google.com>
Message-ID: <aNXKTUnxHQyds4sh@google.com>
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, tabba@google.com, 
	ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org, 
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com, 
	roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org, 
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, 
	yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: D119E18000B
X-Stat-Signature: zqqrdicjxfja8dfxh9173sjna8npttap
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758841424-732920
X-HE-Meta: U2FsdGVkX19Wkfkb4DVeUU1UfcBbpNOFBOsQVutmMC8LPasQsvK6mVx90s87/OWW2Nl+vySJm9gey/9cdJhy1QQNrYJQiEYNfXGLnW2kXFDDnQ5OC12f3yuCMucgaouYd7GyKPi2fIEktPf2Eb4TymWmL0mSvfYbRgkqlCD32sQbC5PC1nVg90MfBZ+D7h74kd/LnNhV0dyD5vZpmAz/4Zb30rIB4PlrDwCE/fXktLd6sQfw4QCFb6pDE4mwSY83kAm4fYyQDKReqGtDXuzSO0+PAyIQXAoTCoIRZBb3Th6lFCzdiPI2JS3RUXrQ+udwG4G+2nPh2L1ahulhtYoY2lb6y/CXYUxmBql11+lGePhGXFN69QQ0KZei8A1nYrHOvykTMKMWg9Y+OiI4kD52aO1eIkp0knvdEPHzpr4xQfNedFU2tzSCkmEQS5ux/7goEYVjGC4C1v3QeQYnb49DxA/aqBMD/rEzJ4oxZrB47E1X7Gx9zp83o/P3Loh9Ate9h+bhhS3/IC4aMBPltMXCx7M4a1HOP9Kjo//pZ/WUtJnDqtrwioBR0vf+kJP1SGInc1Xv3PXX6v/orVaxrNIEJSCPzDPakOhUYl75YHUj4eHk2A5h0JVMUCJEJpEwcy7jIFsM1+H+ITSZ5v43x/K0txI2AI+geO3RfHFbc6i3eOusvMOstYGbW6siW9H7pMj6UJcsaZIobSx4rz+h4sqF8l12HPwo/H5MUUXujRvl8Io+Yc6+GgbeHiarjA4p9iEp1PScsuBcO3+zv9ghTt359w49+0GuuzwocZsxf1RF0qbiSVbz6yaM0ubv5oYjq/OSOjjbDkrYPVdTVQwqAlfaYAFjuKLgdPyrfCRq8Ssx0z3XFsQ3JfFAGiMrTUryRoDkq1bGmjiYDEUPm7yrzemyG67z1SVmbnRjic4UySIzV2xtucL2zNw4FSypc8rkRZcT76OWQP4njgBO+le0ZvO
 enpd9r9g
 IiWBqDtF03DOt1Kf4JsoDxc/B+LYE/Eb06sHwmfqKsq9vkRT+lra2J43LzmAHGW0rtm+KViut1Q5VstzhrD61lMZvYyFFBKtbwC/uyB3dwdk5hhU2+mSlmpN7yGBM7kZPVGwmiLF4XaZAUjz/GEALBMvstdPMsqCzdjdtM8ESYRb7AyOMCxQHnrUGm5nJnMfTCtQOZutiDW/opITCwyF256S0y7xtpks5Xwai/kGvmHIjgk0jwWP9v71L3WZSewKTKLff1HFzmkZpkTW8GW8IDtzQBXPuDsaOwLY2GUf8YS41mnJug9J8Rsj1yZrSbG4kaFQlAchtDkW3fGEaujutv/ROhPFHz3tfDBpX9H3Xk17MIAD8OpOCkVQUNPV84hmqIsnEqqJ0moovp8IpH3jnIaqrdUYWijWXVFSGhctYn2aWJwMZp3itSgMTIchNz/3tXNrT+koMo5f6Y45iCJt2NrinXvDWD09ulLTqeOUxM0UfTR9FSl8KYG4mrKmTYz0mlvzD9Mksb2VAfUdO125g+bmu+DF/WHeWO/kuRFalPACeOVug3sLe8z7CUFg8BvsEAfeLMLXhmz0cjN6+WDB048kEClY16e4ZrsM3uV+FOgCT7Nh+NFl1RwVPENQTV5sauTleBFeK3a9uLt4Qf8htzPxWonEEjbQAVZtw0ZDDTPEM+M/SsCVGMYMzNEziGZYOnFJE37NXuXY1LuepFOFQ3Da2kSRs1JPFZE3E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Shivank Garg wrote:
> > Add tests for NUMA memory policy binding and NUMA aware allocation in
> > guest_memfd. This extends the existing selftests by adding proper
> > validation for:
> > - KVM GMEM set_policy and get_policy() vm_ops functionality using
> >   mbind() and get_mempolicy()
> > - NUMA policy application before and after memory allocation
> > 
> > These tests help ensure NUMA support for guest_memfd works correctly.
> > 
> > Signed-off-by: Shivank Garg <shivankg@amd.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> >  .../testing/selftests/kvm/guest_memfd_test.c  | 121 ++++++++++++++++++
> >  2 files changed, 122 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> > index 90f03f00cb04..c46cef2a7cd7 100644
> > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > @@ -275,6 +275,7 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
> >  	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
> >  
> >  LDLIBS += -ldl
> > +LDLIBS += -lnuma
> 
> Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
> any of my <too many> systems, and I doubt I'm alone.  Installing the package is
> trivial, but I'm a little wary of foisting that requirement on all KVM developers
> and build bots.
> 
> I'd be especially curious what ARM and RISC-V think, as NUMA is likely a bit less
> prevelant there.

Ugh, and it doesn't play nice with static linking.  I haven't tried running on a
NUMA system yet, so maybe it's benign?

/usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/14/../../../x86_64-linux-gnu/libnuma.a(affinity.o): in function `affinity_ip':
(.text+0x629): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking

