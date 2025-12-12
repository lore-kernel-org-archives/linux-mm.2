Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BBBD44166
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 10:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB6D6B0005; Fri, 12 Dec 2025 05:38:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC276B0006; Fri, 12 Dec 2025 05:38:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AAE6B0007; Fri, 12 Dec 2025 05:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 186E96B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:38:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD8421604D8
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:38:33 +0000 (UTC)
X-FDA: 84210470106.20.2091EE8
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id BBB5940010
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:38:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="EwRlEg/r";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765535911; a=rsa-sha256;
	cv=none;
	b=x7jy+WnVWYwwtDlj1tEQiBfuku6DQd1/F6aDCHlyDvn0/sJPC/x1fcAnjGbNvLLV5aPYa8
	dY00l/h2IhWCRPA+uJrmUhHYk9ofK5VJZCNz5ZX9GE6jJzB5zA9LlckrSQ3Z/qHDR2K25r
	rARZ2t4WcomYBUi+Cwz7sdFJfhAHaKg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="EwRlEg/r";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765535911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nctQCqtW4QYyeaejz8PEb38w/v2g7uc6tb41WntjKNI=;
	b=rrT0M/JpFVn02G+fmo8rZeliFUINiMPHydFeqrkLnUfeQqf1v/0GnwkLRDHcJ2ywvDWA0E
	AjbQHJ0l0ga+83qsyzZcLiDrK6vY83Jw2K47VmWDqE0mj4leieoisGFirWYrPJu0DQSEN2
	cBogS6lU7V/+vDq1HTjQdy8FsfhB/Uo=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2984dfae0acso18533325ad.0
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765535910; x=1766140710; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nctQCqtW4QYyeaejz8PEb38w/v2g7uc6tb41WntjKNI=;
        b=EwRlEg/riN36kdW0YKU/3uhZtlGyXAlMxRzuATbmBxGXXNjboVFCRehQ53H+pm0mWQ
         KFfroGXt4AM68uf7Qa3heXIa1SQL0u/3BEVHevRcR/AC3AOxr0nFxUqTBIdDzH+TX1UC
         cZgzxGsbDl7unmrmyfr7iImS43tVk/26VDxsJ+knZjkCbxRd7O4vPNlrWixalRlQ01sW
         o8RmoYYXjr8JMFG538Bc9EmUO75w8cfpoHvAesPSU7FB4i79ZKHQzuL6keFk0Jw6JkBN
         FrZLtC+faxK/aMKqcgsOSYI3NtAigSUF8ko+HmXgdyY+K8jspaPMSZ5QwsqLXwgGkK8J
         6FWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765535910; x=1766140710;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nctQCqtW4QYyeaejz8PEb38w/v2g7uc6tb41WntjKNI=;
        b=GbjNymF+FXvDBedz96EJCBhdnBvblpmjttSHGlMueGxe01fDdLoBySP1xwCd+FjY7A
         AyTiPeC7x3cvObVASrIumZ5dDN9bYcBjdcMLzPW+XT3V9+0GvqGOCmIq4NWim+Dheiuv
         SCu100MG+qYni0EkuwOrGOcVEeW0zHzNbDddgoSd0Y09w3YYadt+lbvsLCGYzdGyAjR/
         3gs94QttvAnXkrdAoTAQJBl3JWf5j9uwLufL2rlPdV+skfJfAwQ7t8OyBJuO+OBr2DCV
         jMJKNg0SefuIbQkUR0SpjxKRO6bvyZjSRzhEGz+IdagVy489ukRWdS0ocNwqKRTNaoh6
         neug==
X-Forwarded-Encrypted: i=1; AJvYcCUyhIDZDcYy/hoZjlnWWswX+T8E4xhUkUoHB9sEffFLfR/PT6sdjNHF33iL3qfZ26206XdrEXCkvA==@kvack.org
X-Gm-Message-State: AOJu0YyBmZAQrAVUn/2pbzzkkR2t0XtAHUb5nVDvFU3pmp51M1PVNNPB
	5Dai8f11gQzIG+fL8ns/FHRbgFWTeBdMI1r/E9FVRKVpX1fpsurgCw0twcmrcIFfuO5kr/ZTjSI
	sCZ/C8jokEmkb5VJCKJDbvsSx31t7ZpMIv1z21Oa9
X-Gm-Gg: AY/fxX56gC8r/LC0PqWtClQmD40SHKpAzLPbmx3kUiQnlBG/TGX1/Z0i7xatGlHIAPP
	DwrxzZQgx307KDjBlPTKyqo9GOz2C3GU2QzE9UFYqa0AiA6uvJfK+02ePmFYYFFuJkZvjduXDJ+
	hywbt83r5PE1iFwmihajSZKTQAnmrswlKvWjTKo1cxqAP3PfhIznZj3JpMfMhvlnc7e0R590AqW
	3pRUaJF4ZoA4sad2h1Bf1V9IEKD071JSqjXW+NkQwOagGNGg2qYuf5WDkLW3tX7iY4toPDSH7Ak
	X1Tnv8o5YLSUP0GY2/Q+ZsY3MIE=
X-Google-Smtp-Source: AGHT+IHEQqbAgYefprbsSuiVLt7KDiCECxoW496oPYm+Bj8DbPCCV7ccSZXk9zoE7kqarbEHot35Mb+a9uphNkvnkwk=
X-Received: by 2002:a05:701b:2719:b0:11d:c86c:652e with SMTP id
 a92af1059eb24-11f34ac540dmr1125346c88.5.1765535910093; Fri, 12 Dec 2025
 02:38:30 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120145835.3833031-4-elver@google.com>
 <20251211120441.GG3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOyDW7-G5Op5nw722ecPEv=Ys5TPbJnVBB1_WGiM2LeWQ@mail.gmail.com> <20251212093149.GJ3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251212093149.GJ3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Fri, 12 Dec 2025 11:37:51 +0100
X-Gm-Features: AQt7F2qnWyV-H6zf6AeMnZTuFb_nb7UwLLraoghpFqSJ0q6RecRlENqaq0woPuo
Message-ID: <CANpmjNPcw5AnpLpaFvyRee7mH12Ym-NKTx331xXEusK5zpiscA@mail.gmail.com>
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
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
X-Rspamd-Queue-Id: BBB5940010
X-Stat-Signature: yt31gihrgtbmx13iw7ofitm8a1dywkw8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765535911-34285
X-HE-Meta: U2FsdGVkX18sm0NiC5Q0UeBvJHdCnyjlG7tOSdKnCNsv3mC/ozi4tRXWgTLBiXbH8JVID1lQeokYNTtAgfiT8BxAMwz8ra4+ptc7EWmUpO89jBbbrhJYkEOlYEQqTXFLs2fbO4qZykQk7onit682ak7EJuGoGMq2CyIVeEO9Z97lPHalTQuVu26Ct71VjOypuJ4B2tKAOazjWCU67Eh7htGUbLOdN/no2SpCD7rdB0EtUI1yoseWgmTHCP519O8zNICz8FwcxtuGYj8P2LGC54NScsUl+0mNr4rPfUFvaLuUwwYsAgL9wz/r6yMhcMYSfAguoO3wZJTTISi8vNs16FHdJklr3dLPG2HV3MFxIW36I3YWLp6VYGW70uNItwk41/t84+WrVJ5JgeOcoflNxl3tveQN/3Z9IZt4P/26rZFLcq07hvddBdbB04zZti6eIzeBYsfqzeagQPWb3lgyEXV7i/q2diva6Jp6Dn+5A9SmfoWyARW3GfW9fd8nxZxfYM5hN8vtJnQyVNTTUY1fFcB1emgmh8+WNTCYhLV/ZXifT96JB0q51K2ODqHgMouVFpj6+B+qKQEG5EZ4WJ7ctuifK2oOVvAKTNQtNKDgtBIm0Y+2d766toihGnYYYE59RZ75UOpGq6JmfeGWoSxHfVswbIsOt2G79osWteCvPmhaAuEJ84sY2UoSnWfWPc5/LZ/mJsH4Xo9ZVcvSHnh0lfUMCEPlpOpzbe+rsm8sFkxEeDPIl3qCS9M1U0pAjrh4vK59wr5cZMe194uzZiWKu1eYQVs0gs/3tNUNDUiI9q7LMwsCnUncdKOKNbeJKDxDuOdCgsLlfm4Pk224bnMlgVa/cic2VgzOb2lUlQNK4u21DRyPBCaMJHgtdbU1vuOBR6b7FdA0E9wrJpp1FZ6c4PApaF1kn5qOxZTxw5v+TH6adf62KoRydC5FdwFY2gyz4lDklLObyy9DbIuMgvM
 l3D22wOd
 ncDYY/AEl8hMojT+93F/vc6zS3dSxDFwR4dw248A/4WRIyZF1LvXhCdkMFMYDK6d8dN5c9KVdFnx8jUMdGVwESUM+KLW9g18MI2pC7CxIhTbD5Fmob0K3D8RZUFS/T+xO4V4mmw6lqQTjzWS+MMLt1X1OmQGrS8tRHGDGOKJMis9b/vnkLh+Zx4U4rkwyw/lhcsVIEzI6NGbo/ju9UrGfeU1JcvX0RWKrfwkAXcTzV7bY7DKAC6BautOa3+fMXzNWcC0W8iQ1iDYHxaS9zqrPKZl+CbD4RL8kZZ6e5zPX35+z1UdffeR0x0rr+zcPg5p9VTcp7RTVrQVeaS0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 at 10:32, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Dec 11, 2025 at 02:12:19PM +0100, Marco Elver wrote:
>
> > What's a better name?
>
> That must be the hardest question in programming; screw this P-vs-NP
> debate :-)
>
> > context_lock_struct -> and call it "context lock" rather than "context
> > guard"; it might work also for things like RCU, PREEMPT, BH, etc. that
> > aren't normal "locks", but could claim they are "context locks".
> >
> > context_handle_struct -> "context handle" ...
>
> Both work for me I suppose, although I think I have a slight preference
> to the former: 'context_lock_struct'.
>
> One other possibility is wrapping things like so:
>
> #define define_context_struct(name) ... // the big thing
>
> #define define_lock_struct(name) define_context_struct(name)

Note that 'context_lock_struct' (assuming that's the new name) can be
used to just forward declare structs, too, so 'define' in the name is
probably incorrect. And to avoid more levels of indirection I'd just
stick with one name; if 'context_lock_struct' isn't too offensive to
anyone, that'd be the name for the next version.

Thanks,
-- Marco

