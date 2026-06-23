Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68F7CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759FC6B008A; Tue, 23 Jun 2026 04:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3B26B0092; Tue, 23 Jun 2026 04:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5852E6B0095; Tue, 23 Jun 2026 04:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 113FE6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:59:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 708FB8DD7A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:59:25 +0000 (UTC)
X-FDA: 84910578690.26.4E9BBBA
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7598520004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:59:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sGX9r1I7;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782205163;
	b=xKx+CdIroQQjKvBoJqUgSmITn4UTG2ePUZzPbYLfVVlwredWYp/T4+a5r36sUMFDd6Hkny
	wTeJwaG4KNzRRV1iKmXIuGlAXRqrW3CoUBOsq4uUrJ4xlxa6Ah3q3frRkrXDIXF1QqFno4
	oBZ30Y+ChfqlJ06b0lpHV1c15DnETb4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782205163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CwxGLz1a/U/PZjtJKb6pMN6pB5nXMPtX6D0w5J8tac=;
	b=YMhEs41AH0rnmRCWxRpQtiZnh59twads6CqsqNfxW96r0GG9NIaElZkrWbSINohAb9IA1b
	HkgyhtlOnBlyzuxJGJXqBKxVwUJu8Y8MNbijIm/3BR7UhPY9xnWM+yWX9s0yzei4CFAFZp
	8L2uVvZez8C7tfkFoNDcUH/RL/qcpGk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sGX9r1I7;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-519ed52bcc6so210111cf.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:59:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782205162; cv=none;
        d=google.com; s=arc-20260327;
        b=BOt5tU+D1gWTeh02v3S6Bo/gr8AL3ceBKbaJ+V3kLuuvA3xJZnrSwZ2wx55HUdNY77
         jVRRPzTBDJargWETNONMG6MyQPQw/7eGmkLCE9R/Xs5LulI/iPsmTNz/BixqlarKLZ6v
         iLz0dyCOLJ6U32afc7sJ1HHrhvRBbOkgUFZr2vroVrFt/Js/+civrrW+JdhLpOaBc/DW
         m/4Eocdm74uwj1lXyLNbCKAPPLTDmysfflzW2BVlwelKDNV8ZQEjuqzxOHS0uI8pw+6O
         vtJpMEGYSnOILGlo7UAEYeNzeyqRisySqcx4A4cBtimKx8PXgAJUyXjH0kfrPphWgFZq
         oEHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1CwxGLz1a/U/PZjtJKb6pMN6pB5nXMPtX6D0w5J8tac=;
        fh=gpRoW5cbdQ+I9PLH/YVfJoadaMJZ3npwdlZU5Ix+B8o=;
        b=bZzPugh4Fs1x5N+hT5T7rEZ3tdHVB5R33rVngXMgH8PGNWYewcqkwbsrTTyGojrXJm
         goTFSDU55orGXgvEGBjVwISzzBzP7DrHoajljxUtCk6I/ClvNOiNtgZyieMHmt+S/hqo
         FkZxGz3/9/cgBjVW+yaVpP4sDZ32Ax+3f19L3aBfl+L6hjp0+IupU/jdZzqF2AJmAKDO
         wm/9VbHTkSodgnZBO1nmtb6xxOb4vDhzko3cSKmnKITJiPAxn7YCE1XkK5GYo8amdCA6
         NQeuoWTXD6GStG/GKNgSITZ5H0CygwVoLzK/8TTjBRErXaBeYd6riuEr1+8BwqCw/uh3
         mGww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782205162; x=1782809962; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1CwxGLz1a/U/PZjtJKb6pMN6pB5nXMPtX6D0w5J8tac=;
        b=sGX9r1I7g3NUdvwUTDmoIJf0ZO5IoLrOPisMIg+sR6GsrsZEMIDpqcyNiCCQgjJpBH
         7vqBtRdeunzmzIRPcNmRBY5Pd6fZZ5GxNcoFBrgYrNcY4QlsfRcWpbjPhiUItffIBijl
         VYS1pq7eoR1NYrxYzcUwRFv/biW30QEeg+PVrphTVTKWxJE2p0ayf9ldbFQAnwo/UsE7
         yzI6Vgam1n7ZuWl0eB41r6mM+gRmpiJIO2lwz/0+5d9Md+fiuY9ss7+wZgeGBc2Rvy/K
         hbAh07VXuUoaLf2i+LAZ/eUYkoiZFP+VJV6Btn6S+i1GTBpIR8omBs+ZnX41csUGANR1
         ZU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205162; x=1782809962;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1CwxGLz1a/U/PZjtJKb6pMN6pB5nXMPtX6D0w5J8tac=;
        b=cnczDsBzI6cF97lyM6pJbmgAKrY1oa6+Tz6JdxR9eFFkBrzt82ykFtplPjLFyncqjv
         /Id7rqGRJxOr1PO5IJE2hqXhFSKBNC7NgDrssP87ogqBy4dxIXZ2yt6oNLcd6YNjESIG
         Da1zwpcclqi4rMhJKYcbzpz/utYQpvjxgYlNs37bc+ALIc9jfQ3SM1wgUDpg6HhGRQ/4
         9uPEgye/1F/xKcfCfW5Uy9Zjm7S11rOO96V/pjUZvN9iYqkeVMUhFBHecdNuxukaXH1Z
         QZDO72r4/owy1qMz+qvEL4+DC1V44br7AAiTmn12Xn0wYG7T7QdMrrqMc/3jxWunFFpV
         VSuA==
X-Forwarded-Encrypted: i=1; AFNElJ/WY6xCuQabIwWDY54UqTcTl31zyH8Ll7G1CQrK0KN6hV9aJvgeM9mqfJ4tEVdRST2+Kc1dDnN/rQ==@kvack.org
X-Gm-Message-State: AOJu0YyV2T8a6ry9V7/p/4nY9fBL7geIxd9Kix2x6bP0082Lp0GIutYt
	uQSHHifWCs6RPWzWHIokiNxnqyJsolV8QaEiSFKDyvSLYx3xZvu6EpepV1YaoSsZAP43jXFATQK
	CpCXWz5AtlFxOjb49QzFf0pNkBLrFtPFGh14DTCbP
X-Gm-Gg: AfdE7cl9S4+to9KbGFWfINvjPC2t76hN8Uvei0S6Rdhs26y6wFIbAIKpRI9F9PhHq4x
	GH+EnC22gH6jKD68GUrAK+pty+o4cPkTTDivfF0hUk8lDnIRLOhGveOuJjt7m/JejvWrGpJQMqT
	z3UO/Cqaj/Kjppo1bldO9n+OJHFAUb4YERVIHv0o6LKPSmZ+WZ3+Yq5sdhFFbR7JtVRZd3NXjUS
	bFSPXWlzmN7lzve8GZm0yd4QQzgFWSisBKDaYbW1KQ2bBJdUToOjSIsfVWp9qu2Z2nhqpArdw==
X-Received: by 2002:a05:622a:53c4:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-51a52188357mr9231071cf.0.1782205161783; Tue, 23 Jun 2026
 01:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
 <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com> <ajneQVLriUshjFIO@google.com>
In-Reply-To: <ajneQVLriUshjFIO@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 23 Jun 2026 09:58:45 +0100
X-Gm-Features: AVVi8CfpDJy0J3C5-XoMAIo3UWrVbaFO5KPC7yjpf-92k1Ny5C4dioD7azy2jvM
Message-ID: <CA+EHjTx-1J0sEVxL8EB=j=y2Sd9mZ1eos1RCmAwj9eKjJsEcqQ@mail.gmail.com>
Subject: Re: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on conversion
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 49x4a33mteyyrj4m7z4e5rtbxw9wxin9
X-Rspamd-Queue-Id: 7598520004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782205163-243985
X-HE-Meta: U2FsdGVkX1/OcwPc4OQc8VKr2ZC0hyuj53G3Tg+eyMW9rG+E5TJLojo3UAAwUKHQdZb1T7u5rRMQQr2NqLu19mOXPRZ3uBEyQmPwvLvwIPWWu4AcXblFl780NG0bdeFJvM5lu+jVfROPkWnKKn6hYXcGp6fzJqqZ23/ojzzSPCylglRyyFzcY5AHWHyo20KjbQM9CUlnp5pZZbUTP6OwVGkNdgFExJIqriZdgDGni2SvyqcSJuZJ0Q1XiAhlMquxu5rgJgDnpOPl7B+DyYHMS2OSl0IfBVb56favMHMWhxUORerAQplVLSc2wQATaX90CrUEFxCV8KHDOWOyA9sB8CmoxtKhcRDYAATDu5mXDJo5UicXDLNGmFjY8ILLFYCKMPAc4fXX6WGSZ3sxvlHRKtsHUCU3wfOACjEt9YK6HFTeF4O1sLa8GzHvg2/Eksw8ks+JrYflbNBtcbDr9TCufwxsd/PTPtzseq0seXhVmulXAQYi8UnFuL2wHf2M3ci+SSKBufKui0dT+x13TMx/HcqSYGT/GdTj64TH+LjdVl0LymmBVHVYWawXgHQBqmAea9q+EeZltjyhPzi96EUwsG+ESs0yVPMs/7L+EBkIhJI7TI1uU5CkZcv6IWYPuRlgXtdoUQrr88b6GSxc+fc+vaYFWgDUFcuCjd9IDUo5j6XjYDlrFmtJMAoeDdA31JI7d29zxQ6n5vTaH+PvogAksWLFSox4p79dvFKo56DnhbLN+cR5itPTtFbSCzhQPErj0cdkx3DmDfQPvBA4Zjjb6HDgI8ONyBrWKiY2h8Jl7JGFQRXLA0CdzX0W98OXOG/kaGdFNDmxpfX8eeWZAFMVSygThkthfcU/vJ93po4D5QXlhzWnsmVj1MtIRP4tmU7nEQXkQ+yUpZ1WBYZiZZ4ouUU2qHwLr9GZrNJydDZbPkC6ajzs5wto4RZ0I6OktQFTzHJ0JVPkhwJv40jHp5g
 Rei1RLEN
 jDZQDR4LWZGVrU4l10xbnkqQWXjD2g4Q+t8a7dQ18MHy1Rmz3hut8wl4eUk5h8E2eZStabB8pc01q8mGNEYb5o21mOhqBxHKafYig5fcRFyHK+LmsYTHfJhn47ksNsWCHjiD1lcahcnRnFjbKoNzkz2LVkv3dxfgxRb+70Qou7T4lSdPUz9Ws9bHSo86cxtcTz5sI3DvsxQtCdRdVefFCrysvjt7h6tPIZHY/VA07PrapLFCPdtuGaRWgPnOFwENp9ar22uKa9s/NijYexpTa62XhrU3y+4ilnUlCNbb2mggmyoy9Qyu2DSQ/rw7KnvgfQjMIulQszPTG0f0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean,

On Tue, 23 Jun 2026 at 02:15, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jun 19, 2026, Fuad Tabba wrote:
> > On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
> > <devnull+ackerleytng.google.com@kernel.org> wrote:
> > >
> > > From: Ackerley Tng <ackerleytng@google.com>
> > >
> > > When memory in guest_memfd is converted from private to shared, the
> > > platform-specific state associated with the guest-private pages must be
> > > invalidated or cleaned up.
> > >
> > > Iterate over the folios in the affected range and call the
> > > kvm_arch_gmem_invalidate() hook for each PFN range. This allows
> > > architectures to perform necessary teardown, such as updating hardware
> > > metadata or encryption states, before the pages are transitioned to the
> > > shared state.
> > >
> > > Invoke this helper after indicating to KVM's mmu code that an invalidation
> > > is in progress to stop in-flight page faults from succeeding.
> > >
> > > Reviewed-by: Fuad Tabba <tabba@google.com>
> > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >
> > Coming back to this after working through the arm64/pKVM side. My
> > Reviewed-by here is from the previous round and the patch hasn't
> > changed, but I missed an implication for arm64.
> >
> > kvm_arch_gmem_invalidate() is now called from two paths with the same
> > (start, end) signature: folio teardown (kvm_gmem_free_folio) and
> > private->shared conversion (here). For SNP/TDX that's fine, conversion is
> > destructive anyway. For pKVM the two need opposite content semantics:
> > conversion must preserve the page in place (same physical page, the point
> > of in-place conversion without encryption), while teardown must scrub it
> > before returning it to the host.
> >
> > The hook gets only a pfn range with no indication of which caller it's
> > serving, so arm64 can't give the two paths the behaviour they need. It
> > would help to signal intent on the conversion path: a reason/flag, a
> > separate hook, or not routing non-destructive conversion through the
> > teardown hook.
> >
> > arm64 isn't here yet, so this isn't urgent, but the hook is gaining a
> > second caller now, and it's cheaper to leave room for the distinction
> > than to change a generic contract other arches depend on later.
>
> Crud.  It may not be urgent for arm64, but it's urgent for other reasons that
> I "can't" describe in detail at the moment, and even if that weren't the case, I
> think we should clean things up now.  More below.

No problem on the parts you can't get into. Agreed it's worth cleaning up
now, and worth doing in this round rather than landing the overloaded
hook: reworking a generic contract once SNP/TDX (and eventually arm64)
depend on it is the expensive path.

>
> > >  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 41 insertions(+)
> > >
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index 433f79047b9d1..3c94442bc8131 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> > >         return safe;
> > >  }
> > >
> > > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> > > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>
> Not your fault, but kvm_arch_gmem_invalidate() is badly misnamed.  It's not
> "invalidating" anything, it's much more of a "free" callback, as SNP uses it to
> put physical pages back into a shared state when a maybe-private folio is freed.
>
> As Fuad points out, (ab)using that hook for the private=>shared conversion case
> "works", but not broadly.  And it makes the bad name worse, because it's called
> from code that _is_ doing true invalidations.  For pKVM, it may not even need to
> do anything invalidation-like.

Agreed on the name and the overload, and for pKVM the split is more than
cosmetic. The free/teardown path is where pKVM has to scrub a page before
it goes back to the host; conversion has to leave the page in place with
its contents intact (no encryption, same physical page in both states).
Keeping scrub on the free callback and off the conversion path is what
preserves that, so this helps us, it isn't just tidying SNP.

>
> To avoid a conflict with patches that are going to have priority over this series,
> to set the stage for arm64 support, and to avoid avoid bleeding vendor details
> into guest_memfd, as if they are core guest_memfd behavior (only SNP needs the
> "invalidation" on this specific transition), I think we should add an arch hook
> to do conversions straightaway.
>
> Unless there's a clever option I'm missing, it'll mean adding yet another
> HAVE_KVM_ARCH_GMEM_XXX flag?  Hmm, especially because IIUC, arm64/pKVM doesn't
> need a callback for this case, only the free_folio case.
>
> > > +{
> > > +       struct folio_batch fbatch;
> > > +       pgoff_t next = start;
> > > +       int i;
> > > +
> > > +       folio_batch_init(&fbatch);
> > > +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> > > +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> > > +                       struct folio *folio = fbatch.folios[i];
> > > +                       pgoff_t start_index, end_index;
> > > +                       kvm_pfn_t start_pfn, end_pfn;
> > > +
> > > +                       start_index = max(start, folio->index);
> > > +                       end_index = min(end, folio_next_index(folio));
> > > +                       /*
> > > +                        * end_index is either in folio or points to
> > > +                        * the first page of the next folio. Hence,
> > > +                        * all pages in range [start_index, end_index)
> > > +                        * are contiguous.
> > > +                        */
> > > +                       start_pfn = folio_file_pfn(folio, start_index);
> > > +                       end_pfn = start_pfn + end_index - start_index;
> > > +
> > > +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
> > > +               }
> > > +
> > > +               folio_batch_release(&fbatch);
> > > +               cond_resched();
> > > +       }
> > > +}
> > > +#else
> > > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> > > +#endif
> > > +
> > >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > >                                      size_t nr_pages, uint64_t attrs,
> > >                                      pgoff_t *err_index)
> > > @@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > >          */
> > >
> > >         kvm_gmem_invalidate_start(inode, start, end);
> > > +
> > > +       if (!to_private)
> > > +               kvm_gmem_invalidate(inode, start, end);
>
> E.g. instead make this something like this?
>
>         kvm_gmem_set_pfn_attributes(...)
>
> Hrm, though that wastes folio lookups in the to_private case.  So maybe just this,
> assuming pKVM doesn't need to take additional action on conversions?

You're right, and we expect it to hold for both directions, not only
private->shared. pKVM conversions are driven by the guest's
share/unshare hypercall: EL2 makes the stage-2 ownership change (grant
or remove host access) on the hypercall and exits, and the host
records it via KVM_SET_MEMORY_ATTRIBUTES2 afterwards. So by the time
guest_memfd updates attributes the EL2 side is already done in either
direction, and the ioctl is host-side bookkeeping. The only arch
callback we expect to need is the free/teardown one, nothing on
convert, and we wouldn't want a make_private hook either.

>
>         if (!to_private)
>                 kvm_gmem_make_shared(...)
>
> Actually, if we do that, then we don't need a separate arch hook, just a separate
> config.  It'll still bleed SNP details into guest_memfd, but it'll at least be
> done in a way that's more explicitly arch specific (and it's no different than
> what we already do for PREPARE...).

Doing it config-only (no separate convert hook) works for us, and nothing
about it constrains arm64. If connecting pKVM conversion to gmem later
turns up something we need, we'd add it config-gated in parallel, not by
overloading the renamed callback.

Cheers,
/fuad

>
> E.g. this?  There will still be a looming rename conflict, but that's easy enough
> to handle.
>
> diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> index 9ce5be7843f2..8aead0abd788 100644
> --- virt/kvm/guest_memfd.c
> +++ virt/kvm/guest_memfd.c
> @@ -648,8 +648,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>         return safe;
>  }
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> +#ifdef CONFIG_KVM_ARCH_GMEM_FREE_ON_SHARED_CONVERSION
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
>  {
>         struct folio_batch fbatch;
>         pgoff_t next = start;
> @@ -681,7 +681,7 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>         }
>  }
>  #else
> -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) { }
>  #endif
>
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> @@ -729,7 +729,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>         kvm_gmem_invalidate_start(inode, start, end);
>
>         if (!to_private)
> -               kvm_gmem_invalidate(inode, start, end);
> +               kvm_gmem_make_shared(inode, start, end);
>
>         mas_store_prealloc(&mas, xa_mk_value(attrs));

