Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD52FCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B486B008C; Tue, 19 May 2026 12:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C806B0092; Tue, 19 May 2026 12:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C876B0095; Tue, 19 May 2026 12:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D45CD6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:35:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 882381C1AC1
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:35:28 +0000 (UTC)
X-FDA: 84784719936.18.4EB8A28
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 332E84000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:35:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=EDxSKrUs;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779208526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiNM83ZQYTuKfyrru+DlBd9o7+KhR16wDR5z2HsiXKo=;
	b=GHuD4zoUo4MIqhqRA7VP1WbWfX26o9bVTKJEL7WUptCyPLAE8fnOxaYH0HjPZZGi1PpnFt
	hLxjUO/Y006tAXOxblcnb0yEF7RntXNsYUdak+vN9+aj9/SDg6p/k/QyOcqFpHRY8tkZ/D
	aZ/9oAUQwXegDs3ijH9GyCCZ9X7giKo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=EDxSKrUs;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779208526; a=rsa-sha256;
	cv=none;
	b=XNXR5wTYgmD0YMPXJZZXjOnhP5BYVgZqzM/6uPzKw1wk3X60ICFU+5n4ymw2NTQJTfUAqy
	jGeuTLWu7LCzkCvB8cmWMfzbsZcrjDF3Mw+F04c9qOKqXGpYUz95VuwXvmy27UohkzLeSN
	rZ6fa6XWFbrCfs3ldHv9ZBh0EUdwuIY=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd85ebb368fso491513066b.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779208524; x=1779813324; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NiNM83ZQYTuKfyrru+DlBd9o7+KhR16wDR5z2HsiXKo=;
        b=EDxSKrUsz3sM1axftsihg+HWkxf9jSVMA/bxawBb6zfwi1A2GRsWkBHUWWTIbR8fq3
         jqStPPi9lQiaw4vjMfr+bB3nsYEyM09AqIG88jTlDmoEH90l3K3GyEMQp47RiNLNpNv9
         K7mdGcGDACqgXsCCMU6JuCThoEl3K1qk07d1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779208524; x=1779813324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiNM83ZQYTuKfyrru+DlBd9o7+KhR16wDR5z2HsiXKo=;
        b=UIldijoxOewBN8RXXyqSRztjp+PcJbu0XQdwhOkOx4h2sEKYWGPW78gqfkSLtkrGIU
         WZVcFwBwDq+gkU6L0ULcuL8tEd0ML6/EOwakSlnjm1yRM80/qj/i0qwPBySovaf5AZm8
         J5T9Mv0G8NRk7wZVlw2tUwPaJtJ9ECGjm/2t80h5bdLtkJZJmaF+ZfzUHuffBfEvtnLR
         i9SdRqIImh5rvWkJElsLv923zzcs08hg+YHh5uMNgjMeW69J8UyKhJPyliIgCt6Fzzi9
         Pr7qTZqs0aKgkRXjFLlcCGg29IQOFuU4KnLrj44tUrbohwcj3a5yw7VAX90qURcuICoz
         UUOw==
X-Forwarded-Encrypted: i=1; AFNElJ+VSP3RuNHaLr+/B86mw1lDq7LXromXp01kGntxAUWBUAHXOhgm+OFYFrtx8HoBYOf6P2zObQfRhg==@kvack.org
X-Gm-Message-State: AOJu0Yx73D4aFaTErIKr8A5nVbUlVrTZHS9s1yDFL+JwBv+KbN09wS1Y
	S+9wjXUprAXvZUrVK2N7nQusQJGKWxovMPh3HtGN61xsNdUmNvZz8GxEaMF7Q1qB3AE5e8jDBRd
	2IQeXp6g=
X-Gm-Gg: Acq92OEU0/BhPF38+KzOvAGMqdJqb0cLCwfThmC/Kd8X2gbqgVMiCBw9aQdn6fWtBhK
	iLOzKapjhW8+bZAWHYTftjvFgNAy89cS/fHyRnJpIEgdLMCOuUWwdib8dvTLbjPP9kV+IxPUqJK
	BXu+KYaz7n87uzXyU577j0T0ETkqADw4LdWqASgM5vWR5Z0iCXbdjalPtT1Z5tHC7blEr4crkyL
	KLDzA71dIOvWHz8j6UL7UYzEPVbl2DuA3h5RJYpVxXNYs/DFVuHtu89rkArxuUyayYcxugZMJ8p
	uXAs+3sbcy6CIDob8RZ0i09tcJ/AqnZYsdYGvz7eciESah3JGXpswhOnaBeR9GpXMpyF4wtxzP5
	N7coGhxqUxtIZGzv0sdlQpaeACwswAvGfOhDNV8aVc6k/tzDvHM9yyD+WKpoZNWXSNwQT8UxZ4E
	LZ9eExiAsoVGPzfuQRLhjG+fz3LqXR4KIQu1x3Wyb7Cj2ydObWVbgVr93OlcEyfMiI6P0nBORIz
	Mj4VAlfQg==
X-Received: by 2002:a17:907:3ea5:b0:bd4:c64c:5a9a with SMTP id a640c23a62f3a-bd517aa757bmr1162030266b.36.1779208524231;
        Tue, 19 May 2026 09:35:24 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bcf7f3sm717836666b.2.2026.05.19.09.35.22
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 09:35:23 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bda62f13d90so5785466b.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:35:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8N408xq+BRebTwrV5h4xvlkR4og93KpXtwRifkK5+L1wFw/3CqJtWk8CAPRefGH2PYb18Ua/5tjg==@kvack.org
X-Received: by 2002:a17:907:15d5:b0:bd3:1b44:2ec with SMTP id
 a640c23a62f3a-bd51785f67amr869397266b.15.1779208522442; Tue, 19 May 2026
 09:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
 <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
 <CAG48ez3jeAAvy5mymVkLq84Lf27VyQqM9JkjFYzXps+-jLKMkg@mail.gmail.com>
 <CAHk-=wjxBg4Mb98zjJP95gYsC1kYzzBdtp-Yz+J3ZYD+3HrHyw@mail.gmail.com>
 <CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com>
 <20260519-gehversuche-lokomotive-cd720c53bab1@brauner> <20260519-lehrling-backt-261d022de809@brauner>
In-Reply-To: <20260519-lehrling-backt-261d022de809@brauner>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Tue, 19 May 2026 09:35:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj+NgoDH3GSicJ140SV8OoDd71pLmL3fgFEsTcgoMC6Og@mail.gmail.com>
X-Gm-Features: AVHnY4LU0PA_bfa48mWWsfNlNCKTB0_1yiHae_SgLHiE0_gyU2glxZoUUeLssSY
Message-ID: <CAHk-=wj+NgoDH3GSicJ140SV8OoDd71pLmL3fgFEsTcgoMC6Og@mail.gmail.com>
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field post-exit
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1mc13a89p9yt6t5hxdig1ywq3mmrakph
X-Rspamd-Queue-Id: 332E84000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779208525-593423
X-HE-Meta: U2FsdGVkX1/4Eya7M2+F7cIV20RxmhDRt7V0F6+BogTwDq7Ec+DbVE8Xa2Wvxz17Zyc8ts5zTyasCoaVdR+dgfJUZhbqbOav4ldoC9BKQu7xjEzO52P/eAi54WWBcir/dVzIImvherI3OX6kY6DJ0gaQqgvBGVqONvJPXdBPfB/L4GFUSDEXUXzOZkEGTK4OMglKlJGBlRTSbmyIcdCrxwo7Qkr2ubsepnofAntNwY+vLVz9T2n9gWOeDip2VPUiF70bOToz1tZjewLB7IANVYizb35THJ99RLwasNbh80gMcOyazBw0Bjak3UoaCBGAF4jT2BYcBq7Fze2Eo2BItMJIVcd/6yIdgN5pDehqIwH8T/d28zkecWmdpR1JpqSSSOu6K5hH6dyHVYT1i9yIp7O86d6qpM7fp+hBy9ibuW7WmnGs3nsT5CTHqqaom11ys6yX0AYQVBb4l+PZpAzgIm+tzzbSTRvNl2/UTtZgpYx8/3G0R/W69QY9ungypoeBEHO/rEIAnCAvHf5Y5RIM69Aj6CbiBI6SqwMZY6dc2UNbnXFwJE9CF7syVbIVrUflON7EbqlfA7DA3iv2QBKXBrAwdMM8/fsVD/NGQza2hU9pFt2ap0PKfwRcfnzKoMmx1RHNBP6hDsD55irhU+mQiTmmjLmnhYE68nxCJGRm5JZJr/zSt+XBK+hZ+8H6OrKAF0c73HBdh2cW008J3aj0k6Y6nFKD6Ht5UoMJUiOJ5VuXUIuLR19toXe3CC8+r73jssxKibdvZ+Tg9Zt888yOO5AK7IDmHKqzmMvE+P4MemkO7MyJX7B9iIeuY2nGmveHDPpY8OHUYa2h+qohRNeM/dKPmIpmolR6qoTT55/5QBMORidDsD2QKouukVmLXPjcHIMveBgvpIn/Y3EIRE8FkzbfdCGNKyytB/yV+gqzS6J7ngQY064Vb4rBG6Vzyr1OWwhxlh5hBPkJmFmfITU
 dFZ9jpic
 WWxpopoehBmYQveJgrXadGJqGBTWjWJv0A3tiyFtD722kqOF9oH3KtbXL8JV5cg5Arp8ILvCUqnVPwPzHcF8N/2VaS7Hi36AqjBlHLEdNJFBRJsyoo8CFsQHexD8WQAEpQkWuK7xNdIeGXir8sSZ47LpWMXRmXqpVjvIaNUJ993sD6j6FNkWnXVgS+0K8FzBXFYwh12Ygy2C/wFPm2WqRP4QCmFexOBBl34/oRx47CEjhtffT4+m8T4lQdSzi8HGlv02DKKGB76yBajNhfww3d8HrN2N1zcZsNrmvQ46G1qOv6m5bSXATp8ePAZ37jWk2FMtNwLnbLQYeOiLrSk7MN9LqzqFmW2jNDl2L7R1GslfRiyPeZbp5ETEhUUmqvix8hQGOjiJ4auPT5ifQmEsclvjCSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 at 08:49, Christian Brauner <brauner@kernel.org> wrote:
>
> One thing I played with is to move dumpability and exec namespace into
> struct task_exec_state which hangs around until the task is freed.

I like that just because it would actually make *sense* to have some
kind of "this is the state that we got at execve time", and just share
it across all processes that started from that execve.

But I'd go much further than you presumably did - I'd not tie it to
'struct mm_struct' AT ALL. Even a regular fork() would just keep the
"this is the execve() that started this all".

Because I'm not 100% convinced we really want to synchronize any of
this with 'struct mm_struct'. Yes, it's what the historical behavior
is, but does it really make a lot of sense?

In reality, all "normal" programs will either share nothing, or share
everything. And in many ways, 'struct mm_struct' is not really special
wrt any of the other things we're sharing. Certainly not for anything
that uses

    ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);

which literally has nothing to do with the mm.

For that one, it would actually make more sense to have dumpability
flag be about 'struct files_struct' (or 'struct fs_struct'). But
keeping it all in some "this was the exec that gave us the original
rules" would actually make a *lot* more sense, even if it then got
shared between fork() cases.

Because imaging that you had a setuid process that started out with
elevated privileges, and then forked a lot of helpers. Those helpers
still have information that may be privileged, and if they do a
'setreuid()' to drop privileges, that information may still be valid.

Only when it really does a new exec has it changed "domains".

Now *that* would actually make a ton of sense to me. And perhaps more
importantly, that kind of "this is the state we got at execve time"
could then contain the actual execve credentials and namespace, so
then ptrace_may_access() could really use *that* information, and not
the odd hodgepodge of "mm->dumpable" and "cred->user_ns" and
"mm->user_ns".

Again: what makes "cred->user_ns" and "mm->user_ns" so special - and
we use both of them for different cred tests - but then we happily
cross pid namespaces, for example, as long as the kernel mapping is
the same?

So I think having a "exec context" would make a *lot* of sense. And be
quite conceptually simple: it would basically be a subset of our
existing 'bprm', except it would be attached to the thread, and then
clone - all forms of it - would just increase the refcount on it.

Yes, this would be *very* different from the current 'tied to 'struct
mm_struct'" model, and very visibly so across fork(), but I really
think it would finally make all of it make *sense*.

Think of the fundamental race of a suid binary that then does a
fork(), drops privileges in the child, and does an 'execve()'. The
child process really has a *lot* of potentially very sensitive
information in its mm, but currently we think it's all accessible to
the user that matches the dropped privileges. Isn't that fundamentally
wrong? Having a exec_state would fix it very naturally..

                     Linus

