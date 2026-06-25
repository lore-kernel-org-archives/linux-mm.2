Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25643CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48776B00BB; Thu, 25 Jun 2026 02:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9FF6B00BC; Thu, 25 Jun 2026 02:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3176B00BD; Thu, 25 Jun 2026 02:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1306B00BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:49:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 052C31405FD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:49:34 +0000 (UTC)
X-FDA: 84917509110.14.BE4D00B
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C09820005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:49:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z9FnLLh8;
	spf=pass (imf13.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782370173;
	b=VE0imWpGDHCKWm/WmYkig8xwxW3Jzu8MecosmIjKyoskd3tqPVtJ/+VqLAs4UwkOcxsqDj
	PmS1DGkFMk7eNoPITPIiqCzxwy47Rd1dhz4V7ngAOESp36JSbBsGcGD2YwXXIu4h4xsrQ6
	zFroEYydy6YfEGxAjx56Qrux49j+rck=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782370173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BW7Opa6Dhh+zjWlX+o6b9MK5iA1TvQIACZyIwKHD0Lc=;
	b=yrm6kjtOKRvFEmlGPaW1I+B4+FdNYgc6Xf5is/bDAd4ZOFoLR9954ffym08ppACik/EJd1
	nWtQD+Pf3VzIuHLGVW0/t1R97uZBjEzeok7X6Iidy4jWT9DHpvzIHKvYWJRfGcjj4jTha2
	C91AUxrK0zzTj4y93/usu/jHEitSTJs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z9FnLLh8;
	spf=pass (imf13.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765531803so160011cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:49:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782370172; cv=none;
        d=google.com; s=arc-20260327;
        b=ECsqd2vyNoOiL0TFF9qrUnC6LtDw5ty5PaoaTSu3wp0I2eXdQXgDy6VqApfDKOfPHP
         LdJtTRMTRJDttWjZm6Gb7eCI6xWpzZinLmn/KXYRSZozxjmc1y+u4V9iXY6WILWz3gfI
         UYNthEPd6UoM6+WbimPnrinPS5PFLyoviwS5LnlNJRohEBjtvCorwax8NX1naAjnmhzj
         unfkI/FtZ1bDJwtDRYnkKLu5RjraVH72hYGFVMhEj7FcE+ElFrwZH5a5rHt++KQS9aiO
         27Pha+lT+TumXMpGdUK4FCWCIdd56vsqgcVjRg0JFOCJkCS+fyBIlc33PCh5PKHfmTxb
         3z4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BW7Opa6Dhh+zjWlX+o6b9MK5iA1TvQIACZyIwKHD0Lc=;
        fh=+UIrtyyu75pE1mKprf6k0mjDYZ9H/YNxVskYV8nCPGs=;
        b=nOKBRGuhoFUQnEKO4TdU95ZQJ5toyjKbYVRazT/Oec8qVAQlTyJ+G78+5nAA2ALNQU
         vIsyk5khfsg91nLkHWsSD6s0GQhNLv5fe32z4zOeEBqmHf7guCXYeQ+7ljsD59b+HMmt
         v2pDywjiwQE62oJquaSNp+ZnjoSFH0ahjfoDu7+clcBDTtm3hLVqUgR/xL8egCpCEgOi
         k3JJFEupAj2guWgUWArrUOjds6pgED1C9WNo9RO+unxmju8juJvGrtQXinpKgCq4H1JS
         9ADc2hZNSWeJOyl2AlXm/YxwdJF0TBkLzerZsULTXuLhpW7vwVOkcgYg6NvbNvT+d3Zq
         L8bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782370172; x=1782974972; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BW7Opa6Dhh+zjWlX+o6b9MK5iA1TvQIACZyIwKHD0Lc=;
        b=Z9FnLLh8LDGTW8+afjCKqFGFodeuvA5HQE9BIOwSj9nuhgtzb+aFdI+aXgkvvVoA5p
         xDJ498R4YqsUHP59TlDA1howNDaMKjAFYv9lgcXsV+gdvZkmDqHuG37FE+nue5uJQVRc
         8FyMOe/iZUWb99dYANg8h/YZzngK3a/GW6Uqz6c8Pm7z/RdBq2ThCH+4wytZ7rfHhm8I
         EytNyNzq3Toooqe7XHbnf2CgywFzw9FdjgnA7cWmkZrS7QljgmHKsRqJ17IuXsM2pRP6
         Uauu7gv9S6lZf0MCSMf5RhQs8dfZsdJmxiA5zb3YlFjpxUUBGq0RYZ6MzU4QOEmbu1hP
         BrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782370172; x=1782974972;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BW7Opa6Dhh+zjWlX+o6b9MK5iA1TvQIACZyIwKHD0Lc=;
        b=VdpmaC1f1bVLlLmnAHxKTNCKkxjOrYe6jrffyf8DbG5Jw5m4RHjZ/XXaGf/n84uxOX
         Nio/zDefdPw7a/FsL4Ba1eOsxBRu7cfI2M3svhcpz/MalzLdPUmKm+heurkKPffsr6tP
         MdBdA9NeFG2u2lT470EJsdzFYK7668RXh8DjOZwQ4SqqTvlK6GuHmECqQ2XJ7CudDWNR
         2oKLIBOtPXf4tYdhLMsyjXebXeBSAzRxHH/JeBIZ4/fv/6Po83CalQqtUgdfT5fm5TzO
         JrqFkV5baSFsyPWmUAjk1ZdCls3C3z/ovDSknQqnYCzrw33THsrPrGRsoKR3lfucYC8I
         afow==
X-Forwarded-Encrypted: i=1; AFNElJ+Y6t8zYJvS5+Gc3Ni01tHNxn2yG4NNMu+BCi9dGKXrcOvJaFpyx2iT/rBtZFV63xI7Kc7unbw8Eg==@kvack.org
X-Gm-Message-State: AOJu0YwpAkwdk5IbG4QEwDd3p/9xQdXY1ZhZ8GfenYW/hAJXwq13BJ1a
	tLcTCxhSW3tauRjMj/oqlNYjV7teKg0qY143oh3ZjzrXqthNROyf5Kj6chqpseI0foAqMrAK6Nx
	BhyBwca/wY2dKmYvq/4w/NeYWI+CIKxFBt8V5avBW
X-Gm-Gg: AfdE7cnustKhDZr9GJQzHje3GwHJGzLJTEmOvADs187+pDALzvuajn2i2NgXc1jBP6d
	61WGFdlfYknDGgewflxYtVea5OHav1Q7WQhCXoH0g2jIYcWQ988cTtDXVAYecITsp8qW5RrSycJ
	o/v7ybZLTH6jW3QZRx7J5jpD+S4jltF17YHA997u6JUtdZWdGTKpWHgurDFuEQFE9BBdOO9F/xx
	+djdCiB4KW5e2Sia4dz+U5UKkrsCfw36GwuiyBnozyW7bla1uPwKMyEXP5ItONLjAMtclq07Q==
X-Received: by 2002:a05:622a:590d:b0:516:4f62:85e7 with SMTP id
 d75a77b69052e-51a6eba2d56mr6487551cf.18.1782370171491; Wed, 24 Jun 2026
 23:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
 <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com>
 <ajneQVLriUshjFIO@google.com> <CAEvNRgGX3GkazCWM=6y9YLgn=YemXuG==Oo+L58cac1Fd86_TQ@mail.gmail.com>
In-Reply-To: <CAEvNRgGX3GkazCWM=6y9YLgn=YemXuG==Oo+L58cac1Fd86_TQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 07:48:54 +0100
X-Gm-Features: AVVi8CfreADhCYO8SWIiCTVF-3y6AW4q3NKMJ9GslS4VlV8Wo9lYZb5g5o0n_q8
Message-ID: <CA+EHjTwLRzrq0vY0-OosENJ2Gkknerux53aVBj0zGRQUkRQP=A@mail.gmail.com>
Subject: Re: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on conversion
To: Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, aik@amd.com, andrew.jones@linux.dev, 
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
X-Stat-Signature: wfahpddykj9zcomw4xp65wam3db3rirr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C09820005
X-HE-Tag: 1782370172-152451
X-HE-Meta: U2FsdGVkX19zS89MPvzM/7cee+DCOU4am7rb8JCErCtrDQZx3LTucUqepztRD9VFiCYx7shuiQ9TjIeOyRXDOfK2rhdyqrHL9MIpPkHAYi/hd455s0ACn7oKnBP7hg6N2+UhE6RgX3bmkAvqzSh7MCTqanwH2mqMeZ9Zoi1OZgLZBrJWbkUkDYbWYIdaLijT8/kdBiF+2GwBHTrJGvcs9JYP47wbbMTpck4I3pcGTEfWJ0N611t0OoDrY97DzQID5IO25RckRvIzn0K0YZC/QhLGx0pvQiMOYeeckBDT+/iIUd2kmdto0hPCfkMsfPmX8mjQoX+7LpE7QLNR2PIAx45RPl5uS5KZ+lhwCNadQ+o6JSD6jwjz2lW/Wk53fqPM3JbeJByHAwgY6deneZ7UbhXTxFMGGZHFbeT+75Y6bQUKcZHBqUidbehzwlJcE8zIv2BGg9sNSjLgy9oG01Akcb9QS1KmAUlU/uREhrUoC0k6NP4rHdBBriIKw4qNR4UFrQB0Dj4fRxMkxpDTa4KCOcD6GGBtT8Ihds68VMbGFGwnMqkmgBCX/lhG6UuVF2cb2gdpbTPdJCqE6brue3sdtxVWVFoP8y71IO3w61X25Du7wZKDfr2z1IiQz6kGbOdU5yinLMw7vzNi79cJfImAwkMR2MHSq8zdytOJ1aW48TlF1UFQlrY3iH/kJdjSjOmTfZh+cbArUoLWaEgORxf0bNxnFisD1g/XnmVMwsg9ddMEwP8i1MSr9w/vUMPghU7AQaou5obuTJBXOTPj2VEuLByZwkYcdT0AANhZa9RzY7Zzjm9rEOGOJzaVLim4juUNqB+2HJ8l4GAXsjsNcwMiyukce6BJs8VjPEL74v+pVzUdF+OVjxrSBNaVvQCON4ahm/S8AGiGn3lhGWQ1Ziif6dG1DEyxCO+iI0cAS916T1zWOip5M1rF3uVQxwRdv7pdmGCb35PopFQS0IBpmIl
 4SiK/JX+
 vO/dRjZLQdT0pfmN6QvItca2X6KjemmGepIWdTpDDEkzoCo7vItScb1FV0eBkLYzCsHKvEMWWOZeDOxh7MFupgGj2b0CbjgszPPfYQwe8B1DOv7WP5xETECWAzjBCUGGMlmDipQrZFutoL4gqjAdSPOKQ9qJRizJvC3vdhAt/qY8ahLEGruMuGg7uIWaPrlhBjyNjzP3UJzzzqCAGJhEDK6Qt9tRiLb0rTqH1HEgc27cDeIPCGiTdybiuU2Grkr+oqZae3IifVaBbkmBm8QmSzNXbMWhm1NAM9t1BaCRpq8+5QU3jvdbxeae2OuA3Xcx6d1GqoqDQN0lqTEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 at 18:46, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Sean Christopherson <seanjc@google.com> writes:
>
> > On Fri, Jun 19, 2026, Fuad Tabba wrote:
> >> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
> >> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >> >
> >> > From: Ackerley Tng <ackerleytng@google.com>
> >> >
> >> > When memory in guest_memfd is converted from private to shared, the
> >> > platform-specific state associated with the guest-private pages must be
> >> > invalidated or cleaned up.
> >> >
> >> > Iterate over the folios in the affected range and call the
> >> > kvm_arch_gmem_invalidate() hook for each PFN range. This allows
> >> > architectures to perform necessary teardown, such as updating hardware
> >> > metadata or encryption states, before the pages are transitioned to the
> >> > shared state.
> >> >
> >> > Invoke this helper after indicating to KVM's mmu code that an invalidation
> >> > is in progress to stop in-flight page faults from succeeding.
> >> >
> >> > Reviewed-by: Fuad Tabba <tabba@google.com>
> >> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>
> >> Coming back to this after working through the arm64/pKVM side. My
> >> Reviewed-by here is from the previous round and the patch hasn't
> >> changed, but I missed an implication for arm64.
> >>
> >> kvm_arch_gmem_invalidate() is now called from two paths with the same
> >> (start, end) signature: folio teardown (kvm_gmem_free_folio) and
> >> private->shared conversion (here). For SNP/TDX that's fine, conversion is
> >> destructive anyway. For pKVM the two need opposite content semantics:
> >> conversion must preserve the page in place (same physical page, the point
> >> of in-place conversion without encryption), while teardown must scrub it
> >> before returning it to the host.
> >>
> >> The hook gets only a pfn range with no indication of which caller it's
> >> serving, so arm64 can't give the two paths the behaviour they need. It
> >> would help to signal intent on the conversion path: a reason/flag, a
> >> separate hook, or not routing non-destructive conversion through the
> >> teardown hook.
> >>
> >> arm64 isn't here yet, so this isn't urgent, but the hook is gaining a
> >> second caller now, and it's cheaper to leave room for the distinction
> >> than to change a generic contract other arches depend on later.
> >
> > Crud.  It may not be urgent for arm64, but it's urgent for other reasons that
> > I "can't" describe in detail at the moment, and even if that weren't the case, I
> > think we should clean things up now.  More below.
> >
> >> >  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >> >  1 file changed, 41 insertions(+)
> >> >
> >> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >> > index 433f79047b9d1..3c94442bc8131 100644
> >> > --- a/virt/kvm/guest_memfd.c
> >> > +++ b/virt/kvm/guest_memfd.c
> >> > @@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> >> >         return safe;
> >> >  }
> >> >
> >> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> >> > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> >
> > Not your fault, but kvm_arch_gmem_invalidate() is badly misnamed.  It's not
> > "invalidating" anything, it's much more of a "free" callback, as SNP uses it to
> > put physical pages back into a shared state when a maybe-private folio is freed.
> >
> > As Fuad points out, (ab)using that hook for the private=>shared conversion case
> > "works", but not broadly.  And it makes the bad name worse, because it's called
> > from code that _is_ doing true invalidations.  For pKVM, it may not even need to
> > do anything invalidation-like.
> >
>
> Thanks, I also didn't like the naming of kvm_gmem_invalidate(),
> especially when conversions also calls
> kvm_gmem_invalidate_{start,end}() and those do different things.
>
> > To avoid a conflict with patches that are going to have priority over this series,
> > to set the stage for arm64 support, and to avoid avoid bleeding vendor details
> > into guest_memfd, as if they are core guest_memfd behavior (only SNP needs the
> > "invalidation" on this specific transition), I think we should add an arch hook
> > to do conversions straightaway.
> >
> > Unless there's a clever option I'm missing, it'll mean adding yet another
> > HAVE_KVM_ARCH_GMEM_XXX flag?  Hmm, especially because IIUC, arm64/pKVM doesn't
> > need a callback for this case, only the free_folio case.
> >
> >> > +{
> >> > +       struct folio_batch fbatch;
> >> > +       pgoff_t next = start;
> >> > +       int i;
> >> > +
> >> > +       folio_batch_init(&fbatch);
> >> > +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> >> > +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> >> > +                       struct folio *folio = fbatch.folios[i];
> >> > +                       pgoff_t start_index, end_index;
> >> > +                       kvm_pfn_t start_pfn, end_pfn;
> >> > +
> >> > +                       start_index = max(start, folio->index);
> >> > +                       end_index = min(end, folio_next_index(folio));
> >> > +                       /*
> >> > +                        * end_index is either in folio or points to
> >> > +                        * the first page of the next folio. Hence,
> >> > +                        * all pages in range [start_index, end_index)
> >> > +                        * are contiguous.
> >> > +                        */
> >> > +                       start_pfn = folio_file_pfn(folio, start_index);
> >> > +                       end_pfn = start_pfn + end_index - start_index;
> >> > +
> >> > +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
> >> > +               }
> >> > +
> >> > +               folio_batch_release(&fbatch);
> >> > +               cond_resched();
> >> > +       }
> >> > +}
> >> > +#else
> >> > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> >> > +#endif
> >> > +
> >> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >> >                                      size_t nr_pages, uint64_t attrs,
> >> >                                      pgoff_t *err_index)
> >> > @@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >> >          */
> >> >
> >> >         kvm_gmem_invalidate_start(inode, start, end);
> >> > +
> >> > +       if (!to_private)
> >> > +               kvm_gmem_invalidate(inode, start, end);
> >
> > E.g. instead make this something like this?
> >
> >       kvm_gmem_set_pfn_attributes(...)
> >
> > Hrm, though that wastes folio lookups in the to_private case.  So maybe just this,
> > assuming pKVM doesn't need to take additional action on conversions?
> >
> >       if (!to_private)
> >               kvm_gmem_make_shared(...)
> >
> > Actually, if we do that, then we don't need a separate arch hook, just a separate
> > config.  It'll still bleed SNP details into guest_memfd, but it'll at least be
> > done in a way that's more explicitly arch specific (and it's no different than
> > what we already do for PREPARE...).
> >
>
> pKVM needs some arch guest_memfd lifecycle functions that
>
> + for conversion, doesn't do anything,
> + for teardown, resets page state (IIUC it'll be reset to
>   PKVM_PAGE_OWNED (by the host))
>
> So I think we need different functions for those two stages in the
> lifecycle of a page with guest_memfd? What if we have

Yes, the split is what I was after. One PFN-range hook for both
teardown and private->shared conversion can't tell them apart, and for
pKVM the two want opposite content semantics.

Two configs rather than one is right, since the needs are independent.
pKVM wants teardown but not conversion.

>
> CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES, which gates
>
> + kvm_gmem_should_set_pfn_attributes(attributes) and
>   .gmem_should_set_pfn_attributes
> + kvm_gmem_set_pfn_attributes(start_pfn, end_pfn, attributes) and
>   .gmem_set_pfn_attributes
>
> CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN, which gates
>
> + kvm_gmem_teardown() and .gmem_teardown
>
> SNP:
>
> + .gmem_should_set_pfn_attributes = sev_gmem_should_set_pfn_attributes,
>   and sev_gmem_should_set_pfn_attributes returns !is_private
> + Rename .gmem_invalidate and sev_gmem_invalidate to *set_pfn_attributes
> + .gmem_teardown = sev_gmem_set_pfn_attributes
>
> TDX:
>
> + Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
> + Disable CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN
>
> pKVM:
>
> + Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
> + .gmem_teardown = pkvm_gmem_set_pfn_attributes

Right for pKVM:

- teardown is not a no-op: it scrubs the page and resets the host
  state to PKVM_PAGE_OWNED before the page returns to the host. Your
  "reset to PKVM_PAGE_OWNED" reading is correct.

- the arch conversion hook is a no-op, so disabling SET_PFN_ATTRIBUTES
  is correct. Conversions in pKVM are guest-initiated: the
  share/unshare hypercall does the stage-2 and page-state transition
  at EL2. The host still runs the generic conversion path (safety
  check, attribute update) and accepts the conversion, but EL2 has
  already done the transition, so there is nothing arch-specific left
  for a hook to do. The page is preserved in place (no scrub).

  If pKVM does turn out to need a step on conversion, it stays
  non-destructive either way, and it can opt in later without touching
  a contract others depend on.


Folding the direction check behind .gmem_should_set_pfn_attributes is
a good cleanup, it keeps the !to_private check out of generic gmem.

On naming: gmem_teardown is better. gmem_set_pfn_attributes reads a
bit close to KVM_SET_MEMORY_ATTRIBUTES, but naming is hard. :)

>
> Suzuki, does this work for ARM CCA?
>
> This way,
>
> + The if (is_private) check doesn't leak SNP details into guest_memfd
> + .gmem_make_shared doesn't stick out without a .gmem_make_private
> + .gmem_set_pfn_attributes, .gmem_prepare and .gmem_teardown are aligned
>   conceptually as lifecycle hooks
>
> + I think the private/shared check for prepare can also be folded into
>   preparation.
>     + Preparation perhaps doesn't need a should_prepare equivalent since
>       there's no iteration and getting the gfn is just doing some math?
>     + In another patch series?

Agreed, separate series.

Thank you Ackerley!


/fuad

>
> > E.g. this?  There will still be a looming rename conflict, but that's easy enough
> > to handle.
> >
> > diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> > index 9ce5be7843f2..8aead0abd788 100644
> > --- virt/kvm/guest_memfd.c
> > +++ virt/kvm/guest_memfd.c
> > @@ -648,8 +648,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> >         return safe;
> >  }
> >
> > -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> > -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> > +#ifdef CONFIG_KVM_ARCH_GMEM_FREE_ON_SHARED_CONVERSION
> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> >  {
> >         struct folio_batch fbatch;
> >         pgoff_t next = start;
> > @@ -681,7 +681,7 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> >         }
> >  }
> >  #else
> > -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) { }
> >  #endif
> >
> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > @@ -729,7 +729,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >         kvm_gmem_invalidate_start(inode, start, end);
> >
> >         if (!to_private)
> > -               kvm_gmem_invalidate(inode, start, end);
> > +               kvm_gmem_make_shared(inode, start, end);
> >
> >         mas_store_prealloc(&mas, xa_mk_value(attrs));

