Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 674B0D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BADAB6B0005; Mon, 26 Jan 2026 13:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B036B0089; Mon, 26 Jan 2026 13:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FD76B008A; Mon, 26 Jan 2026 13:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 920DD6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:35:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15D9F1B0B4C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:35:46 +0000 (UTC)
X-FDA: 84374968692.18.3795AB6
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3AE0640009
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:35:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kgqhGNBu;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 209.85.221.68 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769452544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wtupvaEvwne0Vq+SODEHB1y4+FGimHGUXOjd7XL3Zo=;
	b=erQohgVl5JXv5mU/l4D1fXtF+Ri77DP2DdRrXi+7VmNfmoabOlwDzol+FMFvFkXZVsDBx/
	88QbSPr0a3kAWU1Yw5H0SuiGMbTrw90gje1T+5n7YtHkPUvenVACDSMnKbqO+tymm8uHYl
	0LrbWDDBeN1Y+dsjAXLOIRFP0VQKZy4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kgqhGNBu;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 209.85.221.68 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769452544; a=rsa-sha256;
	cv=none;
	b=tTKzUTnoiIhkztyHfAM2cE6oU9/1ABxPXjEcwMx2oQrs3RpKToFMNx+B+WH3sI6FP3sYw2
	JUTS9dsyQCBUJl4SK6kEnWnUUJ4OtEIdAwiHBrkwT53TuojReX+76rbmZ+XPI7SbFEb4Lx
	qXTRBUBnHXf5gkjC21Mf/tEfI4xCGKk=
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-4327790c4e9so3130193f8f.2
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769452542; x=1770057342; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wtupvaEvwne0Vq+SODEHB1y4+FGimHGUXOjd7XL3Zo=;
        b=kgqhGNBu7Aytb3sD7xvQgEfOlcEkCOqGcRQN6mEuvaCdMQK8b47lWZluHmnf+YPngm
         2eA25xhAcSXmEKzoQ5BOepnOYxhm1N6Kj9tp3jCLFhSd4DHpI1dh/s3XYb3CousMWGoW
         s+gW4wov2Rf0MAfCKpIWg/HmKSxsrChaMx3VZT23CY/ViBCdNFJQBralFWNuERP5NedA
         i50YVy+SvCc/OA2F16PDlttZv1yMxykFxsO+j/hkcqBDnFbzn3wGhMup/+7HKmmTqVgk
         UQyYCKlPCH94mo+TcZvUOIzAtJSnVcprk5W7KJ+iz2VZ1FoSX4veeO879RfiJ5VAr3N8
         sySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769452542; x=1770057342;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4wtupvaEvwne0Vq+SODEHB1y4+FGimHGUXOjd7XL3Zo=;
        b=B1RIfD/b5SZum5Jt2k+El0uvOME6re/2Uw0jLorQ5DMv6BwSz1ugDEEEFvhpneoOQt
         +Yxp4lGtbL+iP1kioaOAVsOnfkuDVbOPcb9crYhSaUgvvjjCwlDjfHeSt0SenUTpfSYM
         Vi8GLcIkIPnBRNtlHb4RVNAX2reJ363IfTM4HFrHA5mrV023XnNee84dfN1ldQUEiVmO
         KbUTvXjlXkZp07j5Xb4/zqF8RS5AD5H6pZzCzWM3JG/8Np1qF5bh9w1f0wXjjl0yZLhT
         RxojfV0MqW46hxsLhxvMEwzeA/ev/DalCJtI3iw/C6ca8R5Q9Q2+Eeao87TnEqo4LrwF
         Om9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXSl6wxhHzTYsHnTfSd/naGF/GWhAzR0Df6xilB4Cv6ghJpoJ+5OAqeeFuCiwCVh7WinIa2fromWw==@kvack.org
X-Gm-Message-State: AOJu0Yzuyvb5xvE0FPxjM3xnMDVxvoWkJwAJ4SSphxjWEY4ByYdmzICh
	wY3WbPb4FfL0O/BEDT8Mk46wciCK1JMDtAFffvKHVg1mEnfexp3mEpdTsG0dqYCpiw==
X-Gm-Gg: AZuq6aIunafBiW6uS43z36wlW9ftyH2YQ1nZlQFbrD0ayHoduBQD714Mb6TFaC4/GRd
	CD3fYs0kcLVUd7J7BW5i8NzwxnCUmzwy62MJiF/WISCxhQX6PbURZIS5pI/aSSfd/b/O9Oz/pBv
	cBjNVlkm7MvGAzU42+8MKaE5JjxJJablCge98bVWqcajGvfnEART92Ge3i7e1hIDEMTVtPCfeIU
	rQPQKlbQPbjDVlhk3uHS7hwQjazIAiMbu1STGEEhPPB6FqIUY1fiGANyNlimWU3qCffPUdfCHw0
	18uDzQE3iJomyKEn6vtv0W1aukcPNUHAz7peYdTJ14xGsa26DIyk/+22lEBgZZJsQc+wtF9W5Je
	ZFfoP/X/YQMsCpGrJv9uO79O6KkjMbG7pP3zEYCgi1bSJJ3EM8xwl28iK4miWmSmIMluLKRvVgB
	u0+IWUXLV72mRgzGu06hZdcMIPv9rKZ2zMMs+p/7O9hHCz5/BYKnWGzyoh6X8=
X-Received: by 2002:a5d:5d06:0:b0:429:c14f:5f7d with SMTP id ffacd0b85a97d-435ca18f3cbmr9441304f8f.29.1769452542172;
        Mon, 26 Jan 2026 10:35:42 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:c598:7cce:ca6b:8ab7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1b6e2besm32040119f8f.0.2026.01.26.10.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 10:35:41 -0800 (PST)
Date: Mon, 26 Jan 2026 19:35:33 +0100
From: Marco Elver <elver@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v5 15/36] srcu: Support Clang's context analysis
Message-ID: <aXez9fSxdfu5-Boo@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-16-elver@google.com>
 <dd65bb7b-0dac-437a-a370-38efeb4737ba@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd65bb7b-0dac-437a-a370-38efeb4737ba@acm.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam11
X-Stat-Signature: axcunnwaf7rt59dm7fbwpe4w1i3fmr7h
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AE0640009
X-HE-Tag: 1769452543-501541
X-HE-Meta: U2FsdGVkX1/NhG5uTGpzXcQ8B7dWwJwC0kbjJsV2MT/4y2HyUfXmAqip6E1czYaJGmUnA63/d/LBPmyB6Xbq8T0Y7Yo1c0PMCjv15cmNxu4Uv2RXkR/0Bu7iSH8PlK5PFHnE5vo2pvboW4XcQbojuxNg+1079u2yHua0VJs8qPOb5vBAZePyVakQ8py0azvI1Kcev5bvdNUxv4Er8Lp8RszgFtGQXMZ8ofOPeibl7Pjonw2dxJeA4bUIyHp0zbgE4jdrg5I3noz1tYIR8+C0QWEYULspF/UxUwTlgI/Dt1BllEaxeUKPgBLluAVgOPX1icmtxYIsoySpoOQCdV/1jW/LJsrCOXBVMv42BFhj2/LYO5RzOpogJ2D+18Ow7PsiTl6IFI0G443VkgO5etScfo7Ts9DLtIKnkEcEbZyULsGlRVU2kOUwNlpsNR7SAS3pb/my74wB791D5zi12eI9wJ94vtikJ2dvvs5V3yHYEAWP3bXyhTvsk2JRU1np7fLoi7NiZCr4yw3nEXHD3ua+dbojhLN5rKDJa46fC/jrV95cwTqGXwQOOjMBlzs4zc9NH7odPbXDigTBT5b98co2E47dmo975zsbUisVlIRVo0d1xo6T96dUKO57colliESREPc3cSKYsgYlEXSDpfbG+RgfpwxmimotFT7mXNHRGLNhrTBAbCCs+994HVzomuu+P0v3arraZ2x6/5wTl/PAb1WCSIrOUIxD8xVWTQCctcStMEIHGQdzWt4Xhz1UI1OUiBZsSQwsUFeoK9Pkd2W9sUNt+7+I245/7xiqdSgmgksiCmNs18wtwqVTbyI6Y8v9ATyeOOEjKcVc/n34J76bgAO+BPwuvKbZOgbJRnFLtfo8oxzB9wZ5HEwgHUGOJ8DsFCJ4+q4COPvy7ruQJU3rCzgWzdugknTau1WvAh71+Xawk317NgewQ+QLSLC4Noy6RKtPEX0hmi/xRsy+La5
 1T8sILTh
 lq6/0IVFc3xorfSvFBXwKnzSApyWb6Mc3/EmUV+2pBhmiVgWR2GSrk/zcu58RUgmqz97XTd6vnMWfDLjdGJdkmBMFz8melRGUb1cIUu4hIwL9faw2XSnAEoTCa7dHDTaPWJbon+kx/m3yBsYPcJvYlfo69g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 09:31AM -0800, Bart Van Assche wrote:
> On 12/19/25 7:40 AM, Marco Elver wrote:
> > +/*
> > + * No-op helper to denote that ssp must be held. Because SRCU-protected pointers
> > + * should still be marked with __rcu_guarded, and we do not want to mark them
> > + * with __guarded_by(ssp) as it would complicate annotations for writers, we
> > + * choose the following strategy: srcu_dereference_check() calls this helper
> > + * that checks that the passed ssp is held, and then fake-acquires 'RCU'.
> > + */
> > +static inline void __srcu_read_lock_must_hold(const struct srcu_struct *ssp) __must_hold_shared(ssp) { }
> >   /**
> >    * srcu_dereference_check - fetch SRCU-protected pointer for later dereferencing
> > @@ -223,9 +233,15 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
> >    * to 1.  The @c argument will normally be a logical expression containing
> >    * lockdep_is_held() calls.
> >    */
> > -#define srcu_dereference_check(p, ssp, c) \
> > -	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
> > -				(c) || srcu_read_lock_held(ssp), __rcu)
> > +#define srcu_dereference_check(p, ssp, c)					\
> > +({										\
> > +	__srcu_read_lock_must_hold(ssp);					\
> > +	__acquire_shared_ctx_lock(RCU);					\
> > +	__auto_type __v = __rcu_dereference_check((p), __UNIQUE_ID(rcu),	\
> > +				(c) || srcu_read_lock_held(ssp), __rcu);	\
> > +	__release_shared_ctx_lock(RCU);					\
> > +	__v;									\
> > +})
> 
> Hi Marco,
> 
> The above change is something I'm not happy about. The original
> implementation of the srcu_dereference_check() macro shows that it is
> sufficient to either hold an SRCU reader lock or the updater lock ('c').
> The addition of "__srcu_read_lock_must_hold()" will cause compilation to
> fail if the caller doesn't hold an SRCU reader lock. I'm concerned that
> this will either lead to adding __no_context_analysis to SRCU updater
> code that uses srcu_dereference_check() or to adding misleading
> __assume_ctx_lock(ssp) annotations in SRCU updater code.

Right, and it doesn't help 'c' is an arbitrary condition. But it's
fundamentally difficult to say "hold either this or that lock".

That being said, I don't think it's wrong to write e.g.:

	spin_lock(&updater_lock);
	__acquire_shared(ssp);
	...
	// writes happen through rcu_assign_pointer()
	// reads can happen through srcu_dereference_check()
	...
	__release_shared(ssp);
	spin_unlock(&updater_lock);

, given holding the updater lock implies reader access.

And given the analysis is opt-in (CONTEXT_ANALYSIS := y), I think
it's a manageable problem.

If you have a different idea how we can solve this, please let us know.

One final note, usage of srcu_dereference_check() is rare enough:

	arch/x86/kvm/hyperv.c:	irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
	arch/x86/kvm/x86.c:	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
	arch/x86/kvm/x86.c:	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
	drivers/gpio/gpiolib.c:	label = srcu_dereference_check(desc->label, &desc->gdev->desc_srcu,
	drivers/hv/mshv_irq.c:	girq_tbl = srcu_dereference_check(partition->pt_girq_tbl,
	drivers/hwtracing/stm/core.c:	link = srcu_dereference_check(src->link, &stm_source_srcu, 1);
	drivers/infiniband/hw/hfi1/user_sdma.c:	pq = srcu_dereference_check(fd->pq, &fd->pq_srcu,
	fs/quota/dquot.c:			struct dquot *dquot = srcu_dereference_check(
	fs/quota/dquot.c:				struct dquot *dquot = srcu_dereference_check(
	fs/quota/dquot.c:		put[cnt] = srcu_dereference_check(dquots[cnt], &dquot_srcu,
	fs/quota/dquot.c:		transfer_from[cnt] = srcu_dereference_check(dquots[cnt],
	include/linux/kvm_host.h:	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
	virt/kvm/irqchip.c:	irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,

, that I think it's easy enough to annotate these places with the above
suggestions in case you're trying out global enablement.

