Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F47D3B9AB
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 21:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313546B0006; Wed, 10 Dec 2025 16:50:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA906B0007; Wed, 10 Dec 2025 16:50:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2486B0008; Wed, 10 Dec 2025 16:50:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 094AE6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:50:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CA01140665
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:50:52 +0000 (UTC)
X-FDA: 84204906744.09.14331C2
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id A72BBC0016
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:50:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VJAMo6Wq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765403450; a=rsa-sha256;
	cv=none;
	b=rgxzqgN8vusr8h+I+HBRtwLhzbXq8bgsRV2n21lmj8aGW8k5i/MB9Zw/XgAPEcxpGjnkaB
	poOhBA6vKHuAbYckSv63GNrCm6OoVtAOrx3Il06QfMmH8+Kz2eIgXOK2G43R1+ZL4kSMEF
	wqbIsqxpN4arm3ebog1qtcPxruIaYyQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VJAMo6Wq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of elver@google.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765403450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCsZw6r2H+GxT2oqUVKFZFncfDO2e0BQEMkV3Qsj/LU=;
	b=iVeem2Y68BZO06ym57VmOA7z4tfSOP8habAKtAqBkjMZRhbWawbcbVk6mTjWzyBaNbqiot
	PIM8YmEBJp70yCIw2V0OYe954fp7aFF4b4aHF2ScReMwjAxkHqlGe/4Wp3DIrjMuuA+nqV
	J7F1/X5Sfv4H0ScioxEhQyU8vNJm1tI=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so264963b3a.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 13:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765403449; x=1766008249; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KCsZw6r2H+GxT2oqUVKFZFncfDO2e0BQEMkV3Qsj/LU=;
        b=VJAMo6Wq2J12kxcIjyIKWKuF1+S3P5Mjc4aCcBziiWqjUN3+RVvFRXqRyb66j4Lr8g
         KfF8MtpSJZeHKl5Sz79knOC/P7c5d3V+uck8BNf4VYdIP/J3QU6k6aYDeI2RlRDE/ySM
         xZw3GeV1TXRslJ4CMW5STHGLr+Wb37+se8KlnGgY9AFMvG5Cf/VZA3SgYJeIdrcqR9uw
         w6rczMGFv/jgJhqXP1UR4AbklhErC9eCLd62c533NFCBdncAeDRb9dD4HGeuKq4CWw7D
         XQ/Amsrac6v5AdWb5jly9a4M17Un0Z/zcuL7gf81IRvBZeLR+Pohqg4EoqWrDt8DljKv
         1h2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765403449; x=1766008249;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCsZw6r2H+GxT2oqUVKFZFncfDO2e0BQEMkV3Qsj/LU=;
        b=Znxn7S3+ZR0Y3AZn9ErtYd/unie7V3ocRIfkld1+40mqWIn4+eSgYcc53VFrh2oiu9
         oPd1VXyxNjm+zidLONyNNpfVJl1qaR+kEthbQnEePZE5LEsTfjYha52QMlMDvLb7eCmb
         teAW42SpCShFnVpXzUySG3e9zLhJ17KIa8dBpjigRufM7jESJ0SxYznhRAwOx18mlPGE
         BwEemyLM0bUeyDCxfdq23HaF5qYugKEn9AP71T593uTOQ4p/wDJzcIl7hHYBUkUgRDqp
         4MMpKbv1dSEdbH3h8DFD0HW6X3w/mIxeII5QI7YGsyxHlM+N8V6tB5djArj9DpLkBrhv
         lr7g==
X-Forwarded-Encrypted: i=1; AJvYcCVX4xuLIxAfpOF7j8DBRNqUaI9UpETdzX9VIAa9sTXEIETxXWp1MKhCaclQhbTcfidayjqB8AlU7Q==@kvack.org
X-Gm-Message-State: AOJu0YzJGkB2FKd4w84qyQVLeho0TYhP4U6km5t2tititEqscIyS4GGn
	8hiforogJGQ1P35BjZ9sm5/524ypgPQXmPF2HQyTyvkaxZotu4RZSaVM3JEZWO17ypLealMeEnQ
	BEO8YjD+oNhCMctR9UzYp+5k+/IVH75lEohLovWa0
X-Gm-Gg: ASbGnctOK/9f/9RfSkbeJsrIppDrl87XqkFRYI8Ci3+g8EyS8Emwi9Mt1cQ0aveo9tR
	YnKlKESRCcaKocB+pke1o8a+CqF8f8zovFQgfczeETNUQwAUKEvYH9nq10Z9rcajB06cP4U8AXW
	UQmOifczZE2PdbmIIUivXcYcYfQW7EfgEj1OBJOtHY+Tbz0fPV+uJpaVW/c5gMdrJ8JQc15xDAN
	TQzRmiKZN4+clchilX7KDBU4tHG7/TCh0YdyTF+0zNCu5AhqSM1T94OrbuFA6XnsX2GJfe36E6f
	fmbCZRJMhk7KtsiPZGCsVIhCZvs=
X-Google-Smtp-Source: AGHT+IHcqqK/RTKOSxZWEANFuU3c8u73aLDpG+WRToaBe7OD17Ln70WBODyf5Ae5mb8izrjo+C8lI0krQmOvZa0lPLM=
X-Received: by 2002:a05:7022:b9c:b0:11e:1bc:bd9c with SMTP id
 a92af1059eb24-11f296cbd83mr2505193c88.28.1765403448696; Wed, 10 Dec 2025
 13:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-15-elver@google.com> <98453e19-7df2-43cb-8f05-87632f360028@paulmck-laptop>
In-Reply-To: <98453e19-7df2-43cb-8f05-87632f360028@paulmck-laptop>
From: Marco Elver <elver@google.com>
Date: Wed, 10 Dec 2025 22:50:11 +0100
X-Gm-Features: AQt7F2rgWALnmd_GDAhG6zPIDGFcnPDoNGOr0zzF94TJ0iWpe4L1lGnI4olCNso
Message-ID: <CANpmjNNsR_+Mx=H6+4zxJHwpRuM7vKUakS8X+edBD521=w4y_g@mail.gmail.com>
Subject: Re: [PATCH v4 14/35] rcu: Support Clang's context analysis
To: paulmck@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A72BBC0016
X-Stat-Signature: zi73g4jndn5rnrfubgs6k95qd84fri19
X-Rspam-User: 
X-HE-Tag: 1765403450-234430
X-HE-Meta: U2FsdGVkX1/FcjwKkLRBtUgRTojEpDpxhIT/WtXedffH4l4YMqDYvdvq2JscaK8ek/7t75l0UP0wn12/Z4kKh6Q8dFhw9RPZh3Um9stOg+GJ5wUf4Q6DcMCWnGpeVWz8U2jeGVH+xgwDlBL7YlM4/YrcaSz5wjfyk+bT9mHVUMWrgcf/H6bIi44sSVqnCqWUcoahq56CbTR3Bp+ezpbJEq41fyTH6Wc0HW4YgTrcKW/evFNeIGIeGHNiqkpMnSYcNrY6TElyJmOxHVmgVcmMvDTDVYUaPfOUITINzdIgSaakMlb+J/pEpgkG8U8zuDOsEfMSxSgKCIGFHUMUSTHH1dF2nrAB9cduG7ATYz5VE9vmPHE31KbzobIxwcUgC5440fBOBxcDes4hHR/KscHdKSvwBGo16rMCKueIldD4xW07uWBv4GMsf+gkqb8YsQRrx2vtfgAs2L8VPM4bTbAlDIaMMnxB3VdXJvSXd/Fc03SN4r1MuNMacSabywFpzLiOTipzHPQYI479M/cZ7l3a+TAS4nzqlmssYp6nOi8FnWXv+98NxsBUYbaJb/d3Kj0+O9MBMsZfGb3PPk7ek4IedzUnSI7wIG48MRlnc5frJPoTAlvGSKa9YxHEW4eoOP7cO+0coWzXODP4zVjJFJOpv7cG9g6hchlW2v64cJd1rjN37GmVCpQFPOCCQLEewt7cHlTB9aXad7vDzDLHr8+AkMV8KsLZ5rZeWUzjN4ZAzsy9m8zNmZKbxEQSU5NIhLAmD4erqc/oLufcJ2uHpDlBFBhLYQFPAutcG9HH/LBrcJEZ+KctClgrhM4t87ofX6xsIeBzavO36mUWy+fLDtDiM+HNmJ+2nh/roFGfgfxm7KLzc7VMy7f/v0jUApl5MLl1GB/j3Hc3ayiqh44WcjRk7/cfo4eOo31EAfPzXIrA5uSSDfUD6ay5vMMdbNS9m36jmz/ckzBwiYr/YjWGLvs
 XwlfiSrL
 vLPbNxFVxwwLP0ZBxkVwWkjJNqMGawrVH6OQiKjz1bQLOQ99UMBBu031zP3Ipe2RMYXFf3sp0bIOE0Y8tBY+Z/nXL8lpSSvETYzS9p8yPnUdjATtQU8Fht19sAWHZ56hLUXHRkyWzSurRxbAoRgAtFRYpt8Idoqt/Dk2FeGov3aIBQkHaiIdY3FPoz9mw6RvDveIcuOllqTkUSBWO96kosJ1+qO5QKbrEZfI3qP+uJwiu0Krz9JBzpAi8wgo2/RYJ16sEWYtuRATR+/oErVLXeWFCbwMl/pw4mAaZ7Q3zs+85+RhitAzl4mCG/bjksCoFvtFg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Dec 2025 at 20:30, Paul E. McKenney <paulmck@kernel.org> wrote:
> On Thu, Nov 20, 2025 at 04:09:39PM +0100, Marco Elver wrote:
> > Improve the existing annotations to properly support Clang's context
> > analysis.
> >
> > The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED;
> > however, to more easily be able to express that "hold the RCU read lock"
> > without caring if the normal, _bh(), or _sched() variant was used we'd
> > have to remove the distinction of the latter variants: change the _bh()
> > and _sched() variants to also acquire "RCU".
> >
> > When (and if) we introduce context guards to denote more generally that
> > "IRQ", "BH", "PREEMPT" contexts are disabled, it would make sense to
> > acquire these instead of RCU_BH and RCU_SCHED respectively.

 ^

> > The above change also simplified introducing __guarded_by support, where
> > only the "RCU" context guard needs to be held: introduce __rcu_guarded,
> > where Clang's context analysis warns if a pointer is dereferenced
> > without any of the RCU locks held, or updated without the appropriate
> > helpers.
> >
> > The primitives rcu_assign_pointer() and friends are wrapped with
> > context_unsafe(), which enforces using them to update RCU-protected
> > pointers marked with __rcu_guarded.
> >
> > Signed-off-by: Marco Elver <elver@google.com>
>
> Good reminder!  I had lost track of this series.
>
> My big questions here are:
>
> o       What about RCU readers using (say) preempt_disable() instead
>         of rcu_read_lock_sched()?

The infrastructure that is being built up in this series will be able
to support this, it's "just" a matter of enhancing our various
interfaces/macros to use the right annotations, and working out which
kinds of contexts we want to support. There are the obvious
candidates, which this series is being applied to, as a starting
point, but longer-term there are other kinds of context rules that can
be checked with this context analysis. However, I think we have to
start somewhere.

> o       What about RCU readers using local_bh_disable() instead of
>         rcu_read_lock_sched()?

Same as above; this requires adding the necessary annotations to the
BH-disabling/enabling primitives.

> And keeping in mind that such readers might start in assembly language.

We can handle this by annotating the C functions invoked from assembly
with attributes like  __must_hold_shared(RCU) or
__releases_shared(RCU) (if the callee is expected to release the RCU
read lock / re-enable preemption / etc.) or similar.

> One reasonable approach is to require such readers to use something like
> rcu_dereference_all() or rcu_dereference_all_check(), which could then
> have special dispensation to instead rely on run-time checks.

Agree. The current infrastructure encourages run-time checks where the
static analysis cannot be helped sufficiently otherwise (see patch:
"lockdep: Annotate lockdep assertions for context analysis").

> Another more powerful approach would be to make this facility also
> track preemption, interrupt, NMI, and BH contexts.
>
> Either way could be a significant improvement over what we have now.
>
> Thoughts?

The current infrastructure is powerful enough to allow for tracking
more contexts, such as interrupt, NMI, and BH contexts, and as I
hinted above, would be nice to eventually get to!  But I think this is
also a question of how much do we want to front-load for this to be
useful, and what should incrementally be enhanced while the baseline
infrastructure is already available.

I think the current series is the baseline required support to be
useful to a large fraction of "normal" code in the kernel.

On a whole, my strategy was to get to a point where maintainers and
developers can start using context analysis where appropriate, but at
the same time build up and incrementally add more supported contexts
in parallel. There's also a good chance that, once baseline support
lands, more interested parties contribute and things progress faster
(or so I'd hope :-)).

Thanks,
-- Marco

