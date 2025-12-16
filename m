Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BB8D5E14C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E4A6B0005; Tue, 16 Dec 2025 08:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C1C6B0089; Tue, 16 Dec 2025 08:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3016B008A; Tue, 16 Dec 2025 08:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7CC6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:23:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2C4BC0683
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:23:33 +0000 (UTC)
X-FDA: 84225401106.07.834E906
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id BD1AC40006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:23:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hLaoBTti;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765891410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDxfhRBysj2yPZBzYVVRhpxcjKV0qpQrPWWhDK3SHYM=;
	b=zQKhUhPcTvfxqSlYFO+NEQsgYK44qHczVlC3rceMFOeMVI+xsybFE/4PJCBN5xJIm+q9b8
	Sji6q3RC1M+mTbjkgWBfv0xJdNqhYGJN/B/DruwaL5Kpe3Xrspwuo4MPX2vU2zL3PxcaOz
	BwAT8eeNdE/5PCeZyNPmlXuSUJPlpxA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hLaoBTti;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765891410; a=rsa-sha256;
	cv=none;
	b=j2/g8D84rD6+StvZn8j+9DKRcVnaqt6M2NTHO7e/vFrPBkS6fSgy7juLcWGxxDvZUUIACt
	wToFIH+3hlfucfFk7qH+987IHv3b4q8T1t5aLS6b2+ntyMb3AlzjGn+B5kkoQ+wcgwaZyN
	6EtDDFUQnn9dE14kUxnzzvMYBu/fp7Y=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so36502705e9.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765891409; x=1766496209; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDxfhRBysj2yPZBzYVVRhpxcjKV0qpQrPWWhDK3SHYM=;
        b=hLaoBTtiWFPWKy3VzBudG+fV3jjAmgE1WrTLG2LhMnhZA61oQHEUqi1nXZTnKNxKPY
         37ragYbylY89OxL5zivzd8C6vFpe/LggFuK2DKEez8TIPDVKCvGhrPC7DRu85d7Pwxl5
         RUCD1sPDASA1BS2ys+ojnUu2Ob6awLfZ6XefhREquCTrgVQFnmFJSNeRXPYxy2ZKWGDi
         OqUl0IlYpntHnZ1y4+wCDYJdA94HUWmgQBHjq9g4HA+b6y71abrcOAYhN1bA3xsNjOSs
         tvuo8KZ0C0L0Yz6tyqMqwuA8702F5OIgr2BqCodYhs1pMVPEicJvNcoRWpVSgnN/jJ4w
         63aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765891409; x=1766496209;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uDxfhRBysj2yPZBzYVVRhpxcjKV0qpQrPWWhDK3SHYM=;
        b=XybNBR7v066wHIpO8tVMB/1ulYXyuV2IweP8KAjMera+wnEB/K/E9hZMh2Rl/9WTvu
         TdPq4K6thiGlSJu5XBeJQscxTFGWPDkNMWy3adEpHjSb6fHJHjUpnQojf91H1jgZeujM
         4316Il0nNTXwbDoLbz5WXz7Ns6wxmr2bM8jHTg5M7Tl1WLKvhHizmrHbAxvuhzM41+aK
         MPpHEtmVB3FINbCnv16OMYjfmMGzmG68Ha69qXE6TkD9/MZZMX8i0KddPCQtIRlAUl5T
         3tHZ1Jd1x+ZlmL9rG6O7VcwtQgalefbjbGCrg9xY0aYfSwYS253KivglvC/UA+bmvE3x
         81xA==
X-Forwarded-Encrypted: i=1; AJvYcCWn/vDs/SBqBbAjyNmXo5pcjF9LkKcik62CxzBReQukiFYpv2e+VkphLvdMaiIWFg5MAB2pzn4dMw==@kvack.org
X-Gm-Message-State: AOJu0Yy1JaVp7eEW9itu54mJHZqYXr05xe8hGCk71OabFevGnaaqTDfc
	rUALi6KvHbfj+Pr7jMpOW1FP9fufDv8cI2GbX4U/OrXrt1GmNvmLFGcZHUrIU/IS4A==
X-Gm-Gg: AY/fxX7PUAoJJcgHgao18alnCdmAkDPzmdXRvQ/7JZVLSR+w2cAeGQZycVGLSHuN1hC
	nwgcs8BAUO571MnuTFf4TWxzPPyl6GLgY1Vgj8gWCVJ5g6zONLm9FGfFEhRpodH7aC1sMGG8Ooa
	m1YpACZjH44Wd2nIvCmsmlg9rtay7UEHog4Tak7pj8sffHZFq+/piZkp888NVlGH9BGGw3g54JZ
	Ly7DXy0f6fWSC0wIpK58zHrM3FG9r8+9sbSElY8ffO0L6WYZNfXNSZyyNugB9cTogAGcMLvVgMb
	ef49Hg39ZOpR2W/HnZ70yNFQGJuqFaWrBClmhTHcdemUuZStgrJ3aWznTtIXv+fm74W99D8b1n/
	nHkVFqXiiO4oey3munwyu0TaQlB8nx+1nmkIwQEkCkkxzJOE7HiOGjXnjmFJffjpNH0WwIq0HQx
	USLD6vppnkSm032/iZ7QksIfXxAWAbepRLDLKlNFTD3WChSoAq
X-Google-Smtp-Source: AGHT+IHeQgMekTiUSXYyDxvkGceEMaJToW+cfsdKtACjSuXcP89Hj1YmnWwqaTNfU+el5KGHlOYfZQ==
X-Received: by 2002:a05:600c:4f90:b0:477:6d96:b3e5 with SMTP id 5b1f17b1804b1-47a8f8ab02bmr133331835e9.7.1765891408469;
        Tue, 16 Dec 2025 05:23:28 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:ea4c:b2a8:24a4:9ce9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd8f86b83sm10764215e9.2.2025.12.16.05.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 05:23:27 -0800 (PST)
Date: Tue, 16 Dec 2025 14:23:19 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
Message-ID: <aUFdRzx1dxRx1Uqa@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <20251216123211.GT3707837@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216123211.GT3707837@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Stat-Signature: 9x4caiwyfjhe1a3u8nox73a3xcdobajx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD1AC40006
X-HE-Tag: 1765891410-755151
X-HE-Meta: U2FsdGVkX199egvN2uz3k5VPT9skL/L/T7/rkTBh2+jRbwPgwo411+dOUCuQRgE5He78ljbCaIlleQCpzYs3GFo3VoFgt0s33TdI4SFe0FtO4XmqNt2F419+MFWE08Gs/ByAnxJ5aUpspy8f8Nagso9S6kYf/ab8SGyncM3tFDTOPgLBwA9SMTCBoZewD3YsVT5QY/8lY9ZSX9puYJdyLRmlGjGh59DZgqaOgW3hhkQI/ZmRciZ5A75XJgQugqoQ4R3HdzNxf8rObX91GS5aAwD7AMoKjXA7cwh3zOuqnchGBAmgH9ieavzROtrGZFKQUReXMFhIFOx1yt9KDC/RkIf0AAPKjSUxnBmi0KhLEBUoLD6EnKpTKtti5KKm6TWl5khgtEJuxqLuexIAE/Fbg5oJ/3F3LkZiz1Ci9XmC8mO6//X2Eio8EDP37xbrl74j0yYDPGE5uGx4TSgoh3PT+Jp8Bs4YPYGOtdAm8yEOMfCg5xYrLepNk18nuuMjIbuoE7any6D+6TuZVwve0OZb03BHGMtAPCimkJzH1MgfTx1c6bc+E/yLgRu0nNwtPVU8erWag28ofDV2eOFcC3B1FeEOqGdv1+yYcttvLLP0rQrXwXFYVjCABH63GdovaFvI10WUt4zK2un1ooHTk0I1X2BmXc+xzpWrDUCaol/nICwJX8SjoiJE+kN/euZV+IX1eyoLpAZx0lr3V0TkOBspCNknYu1HylkRXlNl13Cu6qtVJkyy4DkiOSnco+lXCxHfJyOdBrQQp56DuTY3OGt+d9/V9fiLn3goSKNOb76Vlxsyiw/RttglvKppWxkyeGOrYDCZZGos99DmMuhQ9BwX4nTYU08yCtKF97NPN/LHOnQiOXtlNGlfgu8ojCpRZPk5l96o4p2MKMeniNZm+RoNyiQJSbRF5J1Q9utr3HA+ry3VcRn5u98m5Tf3ib2cRrXrxfIzl6mlPtov5NQmk0w
 Ldt716GR
 ysY3sVseodZ21gXPGvMSJRQwntwtbmJdfNc8AqFxgTFx9RpYlj7tnZJaf5M/LLS5t18jY98sm0tfxucV6IYJnF2kDPpEkSnZeI2lN5M3qC21DSF7+sjks2/yDn7WnkcxPUnF02G4W99MefqrhUDM6t+CXu1RF577Wt+adsSZDBMt/W84mlEK6e4IKIESAR70DsCwreOiswldmm2Cgyo93RtWG5SvPMLYmXxe/HuK7HAYZS05kvGcthuEMabHBs2d6sUg3i/iH+qBO/8yiUHVqK29Wrc3yZPkKkXUp40DsXaO32376/IMPUl9KxPmZwCbhpLR/eTt+F11yhjYVLuwwy4tNfBcZV5RGqZ1M79htZJl+XAJrsh+IZvLywuewrSM1Rsx4NIGO+8uirQk4ROuUoV8dfkpBIa2hoo0t3ataqmPRwCtmrUsAg41lUzophRGshZ04ZDucSWGjrkvYAtI4jhshFduiBxU6guE9H/hfa07z/yADuU9RltmYVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:32PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 15, 2025 at 02:38:52PM +0100, Marco Elver wrote:
> 
> > Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
> > abstraction. For that one I was able to make it work like I thought we
> > could (below). Some awkwardness is required to make it work in
> > for-loops, which only let you define variables with the same type.
> 
> > 
> > diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> > index b5563dc83aba..5162962b4b26 100644
> > --- a/include/linux/seqlock.h
> > +++ b/include/linux/seqlock.h
> > @@ -1249,6 +1249,7 @@ struct ss_tmp {
> >  };
> >  
> >  static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
> > +	__no_context_analysis
> >  {
> >  	if (sst->lock)
> >  		spin_unlock(sst->lock);
> > @@ -1278,6 +1279,7 @@ extern void __scoped_seqlock_bug(void);
> >  
> >  static __always_inline void
> >  __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
> > +	__no_context_analysis
> >  {
> >  	switch (sst->state) {
> >  	case ss_done:
> > @@ -1320,9 +1322,18 @@ __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
> >  	}
> >  }
> >  
> > +/*
> > + * Context analysis helper to release seqlock at the end of the for-scope; the
> > + * alias analysis of the compiler will recognize that the pointer @s is is an
> > + * alias to @_seqlock passed to read_seqbegin(_seqlock) below.
> > + */
> > +static __always_inline void __scoped_seqlock_cleanup_ctx(struct ss_tmp **s)
> > +	__releases_shared(*((seqlock_t **)s)) __no_context_analysis {}
> > +
> >  #define __scoped_seqlock_read(_seqlock, _target, _s)			\
> >  	for (struct ss_tmp _s __cleanup(__scoped_seqlock_cleanup) =	\
> > -	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) };	\
> > +	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) }, \
> > +	     *__UNIQUE_ID(ctx) __cleanup(__scoped_seqlock_cleanup_ctx) = (struct ss_tmp *)_seqlock; \
> >  	     _s.state != ss_done;					\
> >  	     __scoped_seqlock_next(&_s, _seqlock, _target))
> >  
> 
> I am ever so confused.. where is the __acquire_shared(), in read_seqbegin() ?

Ah this is just a diff on top of this v4 series. The read_seqbegin()
already had it:

	static inline unsigned read_seqbegin(const seqlock_t *sl)
		__acquires_shared(sl) __no_context_analysis
	{

> Also, why do we need this second variable with cleanup; can't the
> existing __scoped_seqlock_cleanup() get the __releases_shared()
> attribute?

The existing __scoped_seqlock_cleanup() receives &_s (struct ss_tmp *),
and we can't refer to the _seqlock from __scoped_seqlock_cleanup(). Even
if I create a member seqlock_t* ss_tmp::seqlock and initialize it with
_seqlock, the compiler can't track that the member would be an alias of
_seqlock. The function __scoped_seqlock_next() does receive _seqlock to
effectively release it executes for every loop, so there'd be a "lock
imbalance" in the compiler's eyes.

So having the direct alias (even if we cast it to make it work in the
single-statement multi-definition, the compiler doesn't care) is
required for it to work.

