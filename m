Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD47CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D628E0154; Thu, 18 Sep 2025 11:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB828E00F6; Thu, 18 Sep 2025 11:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5A78E0154; Thu, 18 Sep 2025 11:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64A958E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:57:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 159C41DBF65
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:57:00 +0000 (UTC)
X-FDA: 83902824600.11.65434DC
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB97440018
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:56:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ZZEHpD8F;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758211018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpKO6CsQCuex3g+QZ22KGPC+ZgcKRmVKS1THDCqCkXc=;
	b=g+FjNwXdIn9uPcSj7wOgCkDKKmtb2eUuRe50/Z/d2i6pSjStRWlISqSrCesS+JTlJbl/8n
	wogajrQ543W7yoFCH40iIQGZFHWaHGP0JR0ZXVyAl+H0JmYTeQmSgxGJ6qC9r/8WiuCdg6
	bAsljHa+LrHMAm4ZEjZjvmEORvlRtKg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ZZEHpD8F;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758211018; a=rsa-sha256;
	cv=none;
	b=yhJL2dAimhtRVxVxgWlCxKhqfOnmxz+Uuw6IGAoAS8QJdffxB859LQhuZJWez7jrnlEkvO
	6Mon4GjbgEpyY6TSYLX3sxlUNEZ1OevIfERM2u/spZr2CNYA4O+Xq3gZC0+0Ke4AfSOaOV
	0owkEEMsBF21kiGyihRJGpOOKB2oou4=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-55f720ffe34so1282888e87.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758211016; x=1758815816; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hpKO6CsQCuex3g+QZ22KGPC+ZgcKRmVKS1THDCqCkXc=;
        b=ZZEHpD8FuPhUX8fkUtJUR2YCqoSaDJ5vXbxlWYDJr5rDWS38fJdSU4brGjKzAQIK1W
         mnkduiAUszGF7Plm3AM0u8JaBLnmZm8QHQMicvpovBy03lsSdlJRDDnMwYg3XWXtlJzk
         385bcxwJ6mXR3MPxYwMAXOXmZ+CGbGNyGS5Ho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758211016; x=1758815816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hpKO6CsQCuex3g+QZ22KGPC+ZgcKRmVKS1THDCqCkXc=;
        b=UTOufeSLWYOHtTjiNNjjZpWtfuDcO1xRRXzXOm8Ufj0c4XzxNJ3CUnhfxMlVh5rs58
         5SGbVFSRIN/1LlqKp7zPxjYSwQGN4LyElEMv4Icp0pV/PBhLkCIolRsU9DeGjyREy4Qh
         sN6mG+b1sRzxrMc0fU6uOT/gHa0IpjhN9cuwOEMuXmISc6MvkL43JM0gYK1r++Qpydsj
         Pg1LIouImvuiccNKWrSZ9RBoOjwrmZyfcm2ySwXnXdlMoW3P0isIYyMVnDC0nnaYu7X4
         G/DfYPtk24Q7Q6aRwEvGFVyEUXJn8xrUiLEHresCIRPD/UGL47JOnMUi5AeYQsNU+WSn
         GHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI8ifvSGkz0Zly9hzfhRoWgcuHj37FYL89k7w86tcCg53Tqb39MDa0xVo5dUZGI5l8Qoph+MW9nQ==@kvack.org
X-Gm-Message-State: AOJu0YxhVBJnZEshQ3j3rpN4cJNlosuIzmuSaEeghsSUipQJNH2g5Fj+
	7EQhDW1F1dZgwnDEHGTFMNZzOq2NsXZhxFnScFpl8r447S3I4EzpuM5ysyPwYyHTXZYhI/TGHGM
	q16W6TzHPPw==
X-Gm-Gg: ASbGncuJk7jK8krQXiIK7nk7fGoRMsMr82DMRXCJYbHAFByU3PUJJce1w/g1EkYXugo
	qJCCbeWq5GvBHsGMJkg/HslC673CL6Tn6O8zEhXRyqV9zkx7FfFN8ckN8hXNhodmL8Lj/JwCH7d
	E3xp6e/buG4OP3fXkvkusm5UUADNBjcPUUZzkk/d8u+n/OtjNL0pd7anHOkItRyNuMHyERpHil7
	qS3XsEQ+ttYFDWiwiwm6hAzDtA7pvy9cDtjU4NlI32VrXHMBmQU92nLVkEImE7U8J7G0g404EaH
	4QReTe6nFINH51WMseCYoNRcyqRssgJ7TLZJVmvKGWHdEy1GKHSq4lB4bI6VihguWRL8+fCUqPZ
	6XDMi7uqhmXPntkawAVD5OC6XUWbF5BfkKGQg2GAhKP8z+fdMt/rl9kUehzhPkKu5TbOM6iJDav
	jfMVPj5DXnzVxRWoVCcfc=
X-Google-Smtp-Source: AGHT+IF+QYzMBUPuMkOOBWC3I9sEFnfsHsG2//ne8b37giWQlA5PYkBwX62n2hsHLRUUSJSirqEeeQ==
X-Received: by 2002:ac2:5e38:0:b0:55f:3f57:a64 with SMTP id 2adb3069b0e04-5789586a27emr928341e87.18.1758211015380;
        Thu, 18 Sep 2025 08:56:55 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-578a8fad8casm766799e87.92.2025.09.18.08.56.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 08:56:55 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3610cb77a2aso12201671fa.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:56:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWouZV3WCqZ++N9p8kIi8aJnbqs/Rj4dOq9mZJQhOzycbNBxlAj4KhE0x3cD0Y9P9j1YyfH7ENaqQ==@kvack.org
X-Received: by 2002:a17:907:9612:b0:b10:ecc6:5d8d with SMTP id
 a640c23a62f3a-b1fac9c9b84mr417765966b.26.1758210601571; Thu, 18 Sep 2025
 08:50:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Sep 2025 08:49:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
X-Gm-Features: AS18NWBk4u9ObN57KesSGhJyt-aPlWZgKdxYhvzpAyoaxlNUF53WHe4dSKjzUBg
Message-ID: <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
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
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CB97440018
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: p85eoj9i8a5p6htxmz8658c6egspxdej
X-HE-Tag: 1758211017-966357
X-HE-Meta: U2FsdGVkX1+vvXG/iisuTui5DMJWQB9YgOUA1bc6fhCVr9kJHwADOowGOHmkkaBubdxCAkBzfkRylzvxypZ9uJTfkzkg6TSnV076IuJmWcS39lFVv2PJH8nQTbpthUSdaD/IWOoJprxbC2+srNWxCjk40TvgxcRqOncKTgm2xuq6CIbHz+8nLoYRiEGCTQnmNy0EvZI0n7gIEfvgzZuCTiDJuCfblGU+8ReKkjDb72QAn7g8bgOeqn8fk72pbJorR9fnM4v5rFD1sp66Zzez1D23l0FJ42CVlOFFzljE4ruDoi52GmLPstb2TaH2BppUHeuHF+4THMl5MM7+MS1qk6ykHH/HXJxZvchC38QS3bCGB+EesRzoVdmIMXzEvdTlRq9kTc7Zbx0u0WRJd1xZZZTh4wodgNWkbUad/XOWBcagmrU9kbEnnUkTIr+kX2RVbNfYyXTC6AwX5A6L1ntC0+YDJ2kipYjIKm6uJuaIlD+1dkiooPps8xgF+FqYaV3Jo1Yq+mXQQYarQ9GFBrpMUzVRY1dC/vwdB9rLwUrYhbk9YJpU+CfSYY82UtOcDn0I/Tgmm8e+Rs+DNg9hmTfhCGhz5/8hI5v4ZVPWeWDh5brKsPX0xWVUKyB3IjWR7cdBuDxY8OoAwkWroOqXb5HTn8LPcfuNX8Soq89dnwBVJq3dwvAZXbAFdJqPEQ8dXGNXyM+8iFZrgBNLAy7JHY6yXttV9u65MQovMRqHfOJREg6Nula8/O8LWCtImVuhTdiDqPtv8PIA4b8NPsg8sCIu6VYrf1wbUPl7bbbUNqBc7Iq4F0YgSN9uP5PTWjeb8x/tdn5G/N8Kl/N5Ctza4OYkukm+GUOWmKWp/GNuTH3rPSZw1sd8glMQqllSErgMbTnNKq8AFQ/rETcec1YqU7+byJ+dsEr36hbGaLk6/qPUvuCFt6EgVZo7Ku/OiLxZaMJf2fn3xsbD18wCUtzqR5b
 Ap550RtL
 jKq7UGUTnutJ7tLzPhkAXZ+R4NWSi6zyC6MOC3D6uGZhHvRH26cK73NBcQejW5uza32GWM5+4enfCpIvkF/qeCQdjp31H42NwHKd+JfWEgPt7JG9JkkInptJ0CzD4KfkuhKtZcrurYvstgWpTbesf0UxkhE9G1NGU0LpMye2jy1+CzKUfVK8MDTkyMhYdL45FsDP92whHM1XvhTK4ib+1pZk120qCvNFcr1Pp9kC2NsvK4Fbnu/oXF2Tg/hgM5A1Fy0Q0LAE17kIurVrFY7+kfQkpOJVvaFnQ1vLpPEDR0JMdwrdC95ocvz8/6iOV6HOyk/WgSYl5Q3ozCUMfoKfqxwzhpMERsCSf9ykg/B8RN3daBrnRK4yYo4q7S5NPkMo/ScxGyEiAPUblBIWTKrq7m7R67b3PZys4HO4mhmNv9ezndWKTJusXd7FkuMohd+dVDMkql60WCUaTS3sAR27iFICSJapNGQlSucFNNGA+FDKKur/QTXRyc+/KJEFak00TUX8Nqvu4ufoYBKBSgryDSaDAkrHuovQkqdULicK8Qkm8/3YM8zleAm80ijKSN+McKJC4QeP32loqeYBfRG61mtWNjiJ7gYJiW1ej
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sept 2025 at 07:05, Marco Elver <elver@google.com> wrote:
>
> Capability analysis is a C language extension, which enables statically
> checking that user-definable "capabilities" are acquired and released where
> required. An obvious application is lock-safety checking for the kernel's
> various synchronization primitives (each of which represents a "capability"),
> and checking that locking rules are not violated.
>
> Clang originally called the feature "Thread Safety Analysis" [1],

So this looks really interesting, but I absolutely *hate* the new
"capability" name.

We have existing and traditional - and very very different - meaning
of "capabilities" in the kernel, and having this thing called
"capability" is just wrong. Particularly as it then talks about
"acquiring capabilities" - which is *EXACTLY* what our lon-existing
capabilities are all about, but are something entirely and totally
different.

So please - call it something else. Even if clang then calls it
'capability analysis", within the context of a kernel, please ignore
that, and call it something that makes more sense (I don't think
"capabilities" make sense even in the context of clang, but hey,
that's _their_ choice - but we should not then take that bad choice
and run with it).

Sparse called it "context analysis", and while the "analysis" part is
debatable - sparse never did much anything clever enough to merit
calling it analysis - at least the "context" part of the name is I
think somewhat sane.

Because it's about making decisions based on the context the code runs in.

But I'm certainly not married to the "context" name either. I'd still
claim it makes more sense than "capability", but the real problem with
"capability" isn't that it doesn't make sense, it's that we already
*HAVE* that as a concept, and old and traditional use is important.

But we do use the word "context" in this context quite widely even
outside of the sparse usage, ie that's what we say when we talk about
things like locking and RCU (ie we talk about running in "process
context", or about "interrupt context" etc). That's obviously where
the sparse naming comes from - it's not like sparse made that up.

So I'm really happy to see compilers start exposing these kinds of
interfaces, and the patches look sane apart from the absolutely
horrible and unacceptable name. Really - there is no way in hell we
can call this "capability" in a kernel context.

I'd suggest just doing a search-and-replace of 's/capability/context/'
and it would already make things a ton better. But maybe there are
better names for this still?

I mean, even apart from the fact that we have an existing meaning for
"capability", just look at the documentation patch, and read the first
sentence:

  Capability analysis is a C language extension, which enables statically
  checking that user-definable "capabilities" are acquired and released where
  required.

and just from a plain English language standpoint, the word
"capability" makes zero sense. I think you even realized that, in that
you put that word in quotes, because it's _so_ nonsensical.

And if not "context", maybe some other word? But really, absolutely
*not* "capability". Because that's just crazy talk.

Please? Because other than this naming issue, I think this really is a
good idea.

           Linus

