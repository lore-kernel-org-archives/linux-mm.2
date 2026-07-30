Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64003C53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 00:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA906B008A; Wed, 29 Jul 2026 20:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B166B008C; Wed, 29 Jul 2026 20:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170FA6B0092; Wed, 29 Jul 2026 20:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1A106B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:03:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F1191A088B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:03:17 +0000 (UTC)
X-FDA: 85043493234.21.B057409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9D5E680002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:03:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5nFSGTa;
	spf=pass (imf02.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785369795;
	b=iYoKAC9Kp3RstrI9FbQfVpPaXk+dmPIRTwiNR3+bQDD4RjrXJTIIF7ZnuoYaWQIg5xlaW4
	NfN09iFYb8VUTXSMhe5fj/F3PyGlGaLYCM1axMRer+xzdcvKzf3/RN3zuzuGbOIDmkQNUQ
	oAx/9Rf7GMmTIvWjq5xequ9BhhvvbME=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5nFSGTa;
	spf=pass (imf02.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785369795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZXWw/54kDIDx73XnHw22X7yeZR5LWN5LDGxddSIeDE=;
	b=yV/fAz9itbpQ/X6q8FqNbg0EmZk0s5Lx5ftZoPDFQSBapSX8tB8584FamT4B8fSwWC52dl
	bE3YFxcKUWJJkaf7njbszZRIrJDil0F5h9DuJmFSzCng7SRrb6Np0zA1lD2d1dpgNrEVfs
	oV20bZm0rHT29hHof4YRaNxr4dgghvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24BAC41AEB;
	Thu, 30 Jul 2026 00:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B0A1F000E9;
	Thu, 30 Jul 2026 00:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785369794;
	bh=TZXWw/54kDIDx73XnHw22X7yeZR5LWN5LDGxddSIeDE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i5nFSGTa54IX2AUca+NVsi84ye/eHv0R/PXeVpCmikWEvqGvVEgNq01rWwCctSwKK
	 mcSGvF3NJ2w4pKWWSewA8xqOsYR1ecGWQe+m9DBZu7LmSPKbIh1aJ98HRt7Qyvm0aV
	 oQk7YKhzp9qUhN5VQCcWwqtj/TSSi/pWOQCDTEYW3ZB1zG2vznlvzhwlgz66DRjFYR
	 +0oD2xTAN95YjfGa/2w0oug19eFahFBxbosPh8KDHTheLHoiAWJ+TvHESMEY8wz9Tk
	 brs3/patuZKp+2R16Bh8C86IZ9tQkrrWOxXOO+CNlRDXVDU4uXSwY1nS7XgB2UVAxH
	 A1t9WCsd6A78A==
Date: Thu, 30 Jul 2026 09:03:07 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Steven Rostedt <steven@rostedt.org>
Cc: Hongyan Xia <hongyan.xia@transsion.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Oleg Nesterov
 <oleg@redhat.com>, Naveen N Rao <naveen@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Jiazi Li <jiazi.li@transsion.com>,
 Pu Hu <hupu@transsion.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, "llvm@lists.linux.dev"
 <llvm@lists.linux.dev>
Subject: Re: [RFC PATCH 9/9] arm64/debug: Mark debug exception helpers
 __always_inline
Message-Id: <20260730090307.24d3e4b1041f30d87d390e1c@kernel.org>
In-Reply-To: <20260729140846.3c18f437@gandalf.local.home>
References: <cover.1785153469.git.hongyan.xia@transsion.com>
	<eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
	<20260729140846.3c18f437@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ugh8bfe5wkea5178fio418yzkxfa8x5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D5E680002
X-Rspam-User: 
X-HE-Tag: 1785369795-525301
X-HE-Meta: U2FsdGVkX1+RbiWKPR1qYW4XT0qO/Wo2LYxIsALPBR98TLt/oh0BLfu9eOzd5GUlr+f/8QhLm53fx8LiNZS5xvOAJwY4t781gOCjWLxP3vep/DkUVClFJENAGTy/3bhHpgqWEj85t3DJTS9o8OdxnHvQazEygBM6wIhc+j5lWwpmijBlDAt8sqquPubhgG5/A+Yp56AAGiyooppE17Kkgb8s0rA3vlVG6Iegsf/sJBe0t4hPupqbC3R1UI69m7LmLzzZqDAfc692fYTmaKUlaOoong5g+mC7DVggR+qiS/U8nAza/RERgj8L1elbcugW9lKmtE+BAHshLuZH27heNfTPH4UfiwK727Canh+ak17n88VdUkMNe3Qu1gHq/Ka2b65U/f9F6W8S7w1OLx6vXet3CJH0K/4uYJFWsZxA8G0vigo5+jDFBdbvCIjXhRc8ksJI2DCGUgyH8BcnB2n53KrlhCI6Vr3HFkqYju/wXgGA9dDDYlfqjofLZr7agnroYqVTXOXCLezfGM5Cpab6dyQzcz5ipCzLWfWFGjVK2vXwj3ridRa5uyDuRqV5GZCXuTJiZWKh9NQhFEMYBA++YlSPJDwGc/yP5hHIFHWaI42xYKz4lPCejKfdqzT791zILmDuaXejUJJYhAf/5u39wnhOh1pqnLiePQp/fdWS1dYtgHIuOBaoy/c3SZT9X+0JfC/6uT9h3tRqNrsrF/sWnvmd+/gSEI9fE30tgU5HhFglAG4Z6Ojwre7E1DRwW+QkxtVzQUFsrbE8wvssVPqVmRT0egHqPuwkKyi5qj6M/nklvSIbiasmOj8xFNlDHsVCnHn/FrR0OaRRf4zXVplRJqAH4fm+7XmMv7QTO61KPfqCMqakUQK3eBxPMBR2PbfkWrjVS++tzICvZc5kqXjjPL5wF+hj2sUABczwhEbD0vLl0mXrh2UPon+sCgEGVMeJ1rS7yXUwfgwUomD8+/9
 rWZ/MmDs
 tnuWxRguFYRXQ5eiw0uK6FCk9BBCeUy7Fy2Ks/GO0iSgy39DlE6Ra/Il8s1qiZ7AGy3bdPCBLDab2oHzBDyl7u64Kua1G7Zh0QQ/qTtbXkIUscMHvjoqcOdsV4n1DpCsc5hLCmfakbd6KItS5EH57RrFJGHNpSWWCszToCz5gvAJvRGqOovwqoAGt/quRNG9fBuExZLqPOD+9yT2TVWhXe2rMu6xEcI8xMBgeyBDTGaRnB8PJ1d6tJ4JXs1r/JGxblrMHe+gLT2XGBymEH29R+JypArIwxJ4u6HqqfPyuYEtiMM63Vv6lWx3IAXa+aE8CHfvBRQ+UMQ9GmE88n+6VugQVZ+vNDtRFk+fZR+kXTK5IPAIaZDceMuGLuiYjJkeaZLd4Il5OC4dMKtlSqnX8asQJTfaDjdcQPsoKfgL/yb94xLL/MohyG5Lh6hC0M7OgSC8PZMi55YCpIP23XECoglXwVLp6OmXiM9C2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 14:08:46 -0400
Steven Rostedt <steven@rostedt.org> wrote:

> 
> Masami,
> 
> 
> On Mon, 27 Jul 2026 12:25:48 +0000
> Hongyan Xia <hongyan.xia@transsion.com> wrote:
> 
> > From: Hongyan Xia <hongyan.xia@transsion.com>
> > 
> > Static inline should be enough to actually inline functions for most
> > compilers, but my Clang-19 somehow thinks it's better to outline them.
> > These tiny helpers then live in normal .text sections instead of
> > .noinstr sections, violating noinstr.
> > 
> > Mark them __always_inline so the compiler can never outline them.
> > 
> > Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
> > ---
> >  arch/arm64/include/asm/esr.h       | 2 +-
> >  arch/arm64/include/asm/percpu.h    | 2 +-
> >  arch/arm64/include/asm/preempt.h   | 4 ++--
> >  arch/arm64/include/asm/ptrace.h    | 4 ++--
> >  arch/arm64/kernel/debug-monitors.c | 2 +-
> >  include/linux/kprobes.h            | 8 ++++----
> 
> Are you OK with this patch? If so, can you ack it?

Yeah, this patch looks good to me. Anyway these are expected to be
inlined.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

For other patches, Sashiko noted some comments, I need to check it.

Thank you,

> 
> -- Steve
> 
> >  6 files changed, 11 insertions(+), 11 deletions(-)
> > 
> 
> [..]
> 
> > diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> > index 8c4f3bb24429..5880445ed0f0 100644
> > --- a/include/linux/kprobes.h
> > +++ b/include/linux/kprobes.h
> > @@ -384,17 +384,17 @@ static inline void kprobe_ftrace_kill(void) {}
> >  struct kprobe *get_kprobe(void *addr);
> >  
> >  /* kprobe_running() will just return the current_kprobe on this CPU */
> > -static inline struct kprobe *kprobe_running(void)
> > +static __always_inline struct kprobe *kprobe_running(void)
> >  {
> >  	return __this_cpu_read(current_kprobe);
> >  }
> >  
> > -static inline void reset_current_kprobe(void)
> > +static __always_inline void reset_current_kprobe(void)
> >  {
> >  	__this_cpu_write(current_kprobe, NULL);
> >  }
> >  
> > -static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
> > +static __always_inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
> >  {
> >  	return this_cpu_ptr(&kprobe_ctlblk);
> >  }
> > @@ -449,7 +449,7 @@ static inline struct kprobe *get_kprobe(void *addr)
> >  {
> >  	return NULL;
> >  }
> > -static inline struct kprobe *kprobe_running(void)
> > +static __always_inline struct kprobe *kprobe_running(void)
> >  {
> >  	return NULL;
> >  }
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

