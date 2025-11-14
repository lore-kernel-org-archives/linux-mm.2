Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B552CE7B08
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0A68E0009; Fri, 14 Nov 2025 08:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7FF8E0002; Fri, 14 Nov 2025 08:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5E28E0009; Fri, 14 Nov 2025 08:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4708E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:22:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62EEEB8729
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:22:41 +0000 (UTC)
X-FDA: 84109277322.24.7112093
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9488D1A000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:22:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a/lrBJED";
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763126559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuZEuvQ3jmbwZpx7rFiCevGNtHp2p1kTZ05rKerm0EM=;
	b=4MbeZ9CC9b9Ksb+qECPgkPkeHDdehpsU+qoUFi6GfvEffsnUrXGju48xQgpCl3YgMDeeIH
	BwL57YkoghuI1mJ8gRBAbdCzGxVWYOW4tVKaxkVg+YY9PnsHFehu1TkgWBs7lT4blX8aZN
	Ycfb6L81JVaIDXR8PQGW4CkrENVVLWs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a/lrBJED";
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763126559; a=rsa-sha256;
	cv=none;
	b=riIJgU9qpaEIL3ATkVXCKh2BWT+mnU8+OTWyvltKnb6XfhT75NoM+R4lAmdFB1jWihO/51
	6qgHcQP9OJk8cETxGv+jC/DGufcSvngmSHs/T8xKdzeONRQcp/nxvpCFXQrRvqxuEwnf/I
	LgTqY5HR31XNafAKW6pybfD+W4OHyRI=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3436d6ca17bso2118081a91.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763126558; x=1763731358; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FuZEuvQ3jmbwZpx7rFiCevGNtHp2p1kTZ05rKerm0EM=;
        b=a/lrBJEDtM0Ox0wIzYVnSC0FmNf3bLXRsTjGXWZVFCUVt1d3ZpcB1IJFZbKCcM1/DU
         gNp5FO4pp1/j4fddfBkLUDZlv+PhKAAoP8mbONHm3WZRbZEfF9t3sfbOPlKWCL4YajKx
         4DDXEMD7Iu5z3Mm3Lk54oKYEjvK79DuTeOw90phk/XigodqlWpIDXPrkECnVmNKhVRoM
         1Pi3KDjgCBvio70MTtF6Ld4UdxnVniu4LelL6CT9qKfiC1lFhu2D/QmRvu+FmgyUJSuC
         wEUEMmnlBGE9cQ7V645X3E9PCc3wfgjKe8gGvVkYtVxvejP34bkh37lAZgJwS+zdrwoJ
         8ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763126558; x=1763731358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuZEuvQ3jmbwZpx7rFiCevGNtHp2p1kTZ05rKerm0EM=;
        b=T33nVTBzpeo0egCfHNgbwz1oKYfUK6js74FQ6/p/Gb0UUIHiR8sQoi8n2h71oD2i4W
         HPxp+ymafM+ZLXB+EK8okKPBOGwHKgaB1y+BzP+u3YXQvurCGIe5SxI3mHBKmKfBz031
         iHu3bSPN3AB5OsCHNtqdJHXrK0elQcMlvvAZawU4xxta4kMbIiMsiG670vhlKv9Jns74
         oqziUXjW0/S2SUA6OrpODDRqf06Fgq9rQC9JbbE39j1IAJe2aYzhRe1R1SXQDCgzgXEC
         Yd17B171jQVTwg7Q3gjckBbW54BTqsxg2vp/bF8fThYFhm4O6tSduoBz8rzHl9oYCQS2
         nceA==
X-Forwarded-Encrypted: i=1; AJvYcCU43R29puecurgr/QXsGL5PpVHEiNgJTAUOnWHK5ujnFBBkUn63pZRrgSkjZR24BLlcyVIqUD3hew==@kvack.org
X-Gm-Message-State: AOJu0YxaFR+0KRnV7d8XiqSGbPAdIkgrFrL8Sp2JpBjizkUqIi72TwMJ
	wfDYduaxg8rNrE9bGyRQhE9hGO8EA1U4HjPM5yaItMYjx2EZVZ18BRIqq14dWDl3W3oieCL3JSo
	NkAT9CjM/JbJCgEMzGRrKN/JMnGk69ZvqX3U5IxIY
X-Gm-Gg: ASbGnct+sHZV2JVptjiFPEV/iHS/ipDmVK2yqvBywcOuJssrzs+rfo3cD2dJB5IScvU
	ZhAxntrQgqIAk0mFFhEWQuHMboCAjidK+ScXzgWFlW4/IA1cmI6ZyVIXDYBYb+lHlQf288AEVW0
	EgM6eaVpuDEg+oFp0gvwLW/yPppYvEzreLV8NjFYURd5zSEcDxSrum/aO3PSw+2CNmYjov370Fo
	yeaGiWD3dVXqkzAK6OsIHR/xvDuRiL3r2++/YH4sqLXKuv7UgImmeR8O7vqffhbpMjuf+asQ4s4
	pB0QkJMcp3YmI1LZYaR3aBVtmQOluffVSQMI
X-Google-Smtp-Source: AGHT+IHRKhpP3vzCADgRzmvW5BbtF22FP7gG7Gcfgimn7ZOifR3jME27ZrJCzM+Xqri+6sVXI0f8t3/Rxc2hYDVrt54=
X-Received: by 2002:a05:7022:6288:b0:119:e56c:189d with SMTP id
 a92af1059eb24-11b40f9ed09mr1186107c88.5.1763126557688; Fri, 14 Nov 2025
 05:22:37 -0800 (PST)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
 <aMx4-B_WAtX2aiKx@elver.google.com> <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
 <aM0eAk12fWsr9ZnV@elver.google.com> <CANpmjNNoKiFEW2VfGM7rdak7O8__U3S+Esub9yM=9Tq=02d_ag@mail.gmail.com>
 <20251114043812.GC2566209@ax162>
In-Reply-To: <20251114043812.GC2566209@ax162>
From: Marco Elver <elver@google.com>
Date: Fri, 14 Nov 2025 14:22:01 +0100
X-Gm-Features: AWmQ_blyYEkItbzeXoq8SnAQp2jhwPLGdi6tZz7V3PtwgmJC3W4HiUeTEvac_zI
Message-ID: <CANpmjNPniOK9K6q2sx7KRrxckeAdCyVnTi4qwLqoFoYzYb7L2Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9488D1A000B
X-Stat-Signature: 9y3sifef9ymnc4n9rg89q1mpjr83u9h1
X-Rspam-User: 
X-HE-Tag: 1763126559-894836
X-HE-Meta: U2FsdGVkX19Sye/160j+1u/NqMo0+zqjvVUppV9ttiy5Na5tsIUo57RyRC1QR4XcMnkVR/djeYgmCIM+8gtPMqFpmWnI7dbq5WX3RAxWjxZLF30nC7ixqw2IERmwu1mdQ2JP9yxfNHdEo9BjiwHB4hoT1qSIdsBg3J8le03IBs6/7g90uBslREYGugr6hZ7mJ6QvPkUwi+6RsUY4MdbpJUab+S0UGkZMNC2kT6jrl+jQDWas2JYlyjdnoTbWFMe2FlpmNO7zQVb/LfhDpUNHAvSiDctPLPKoORXzIMCkiuiSyHxH7pddOJJ2r+lF7Co8Xtpb++cuFBtjBvh5sugwxOPOKLhGOmP8BWJP0FpQ6800Rwui5s+b7I4EoOfeDCCAUxROTge7Qo0uZVBRh4kUCcFWoHn4ZV0B8V9tftk4IIsNDbrRssOGurRD1nXLbm708vGj69mZbtrg4tzxD8mQElstpnH2mrZDiIiKJ7+5RFgLBhRm/XAyFT1E+NLzqRfN5XNXrSJ8nbxBW6NQANyHQ9TOFsqijB5r1k87S1CM4RbXYZsLjwqyYqXNB2Sf0+smAyx8CXywnFSkwEjKhsVmZP+Qfyp3iSK9tAKMAjW76f09isXxIZ/N0ItdMdiV9B8KNqvxeJq7DI3niKCbqon85nAwU8ZuY6mfFyIbvMZL8r/zXX0IPqxPX+OwWwdMC5TjluoM4wXvInsbZHTnSk06d1i9fG3BdCewmGtlW2InGBt0iNl32PACDzviQ5vv4PqOJsHEBtL06kjQasPRzxNuowkmBlYrWd6I9PE93TV/hfAozV9j/+zaOH8Q7lc9H8X8a8G3DTRUO9ulf3IAKlJnxq+KioWBEmB4OO8oDoMOXYusO1r52p47gf6XwmNLxoB8D9Qt0o9Hy9Hi+MCm0N7VBrTq0o9LvB6GkxnPWJXzY4CRfsN3rlhfb/0tXCGo2Jvsbab6YcHa13LcACXeHqt
 c3+CmV7B
 dqmR8PSX1zyJSsQK/OHX9DHXP9/YAkG0Bi2X9IDOPaYJcE4aXuKaw8Ay8IH43bQrELdwmX4SkRXOEaJP57ClRA081WEp1/Bjgk1gQZobSWFGjQfLgiA3rxgTvSze8OU35WvBzHbZZ6QnT0O2VCLDo1B8uECGeAevnMeSO7AkN1Vw/PfAMGSBy4YwHAqk3W6Uc/BowVXH3mJ2yqk4I9PjIlmC7u1P0KO/j8K4BJGD5tC+6m/JBlyMInMOx3R/6XRrmnA3t+6nVvzygLk9L1bRvibZYHD9Znb4RBCjRx9IBWbKuHjzo+chxY75GzwiShTe0sthv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 at 05:38, Nathan Chancellor <nathan@kernel.org> wrote:
> On Thu, Nov 13, 2025 at 03:30:08PM +0100, Marco Elver wrote:
> > On Fri, 19 Sept 2025 at 11:10, Marco Elver <elver@google.com> wrote:
> > [..]
> > > I went with "context guard" to refer to the objects themselves, as that
> > > doesn't look too odd. It does match the concept of "guard" in
> > > <linux/cleanup.h>.
> > >
> > > See second attempt below.
> > [..]
> >
> > I finally got around baking this into a renamed series, that now calls
> > it "Context Analysis" - here's a preview:
> > https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev
> >
> > As for when we should give this v4 another try: I'm 50/50 on sending
> > this now vs. waiting for final Clang 22 to be released (~March 2026).
> >
> > Preferences?
>
> For the record, I can continue to upload clang snapshots for testing and
> validating this plus the sooner this hits a tree that goes into -next,
> the sooner the ClangBuiltLinux infrastructure can start testing it. I
> assume there will not need to be many compiler side fixes but if

I hope so ... Famous last words. ;-)

> __counted_by has shown us anything, it is that getting this stuff
> deployed and into the hands of people who want to use it is the only
> real way to find corner cases to address. No strong objection from me if
> you want to wait for clang-22 to actually be released though for more
> access.

Thanks, Nathan - having ClangBuiltLinux infra help test would be very helpful.
Unless I hear otherwise, I can send v4 next week for review - in case
of a v5 I will wait until ~March (as that coincides with Clang 22
release, and for lack of time on my end between Jan and March).
Could also skip the subsystem-enablement patches for now; only the
patches until the MAINTAINERS patch are the bare minimum, the rest can
be taken later by individual maintainers.

Thanks,
-- Marco

