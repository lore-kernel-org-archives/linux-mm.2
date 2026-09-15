Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8733AC88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358446B0093; Tue, 15 Sep 2026 12:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308B16B0095; Tue, 15 Sep 2026 12:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7A56B0096; Tue, 15 Sep 2026 12:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD8F76B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6843A40484
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:02:56 +0000 (UTC)
X-FDA: 85216465152.02.09DDEA2
Received: from mail-ed2-f31.google.com (mail-ed2-f31.google.com [74.125.228.95])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FD4A18000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:02:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Q8lDAxH2;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.95 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789488174;
	b=iBHivu9LB1JXN8dgr4sabbUpRcxskzZPtXCGQISLzlVVXT/ZuDixvxqy3lQXmCcFPlo2CF
	vGFn5+qs6lp/TkbHFMXdnWVUJKgK/8+gnUBTWZjIxtN5gQlGrqobH0e/xVHD4WLOc3wkB9
	iinsApO6sMgvJrlqhiBTYo8ZVK/oNus=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Q8lDAxH2;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.95 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789488174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cj8iWYGkmy9fr6Sp+MjBMi0cvssqzarl8Tgut8FUMEc=;
	b=7hNKqOiUh1n5SSv5KyNwOW8F68eOoykgZqB0zP41mXvhAzCfALDuYbPe6m3y6UzveeKXUQ
	wwQjR/KxuhAAzjcxiW/fCEQtgkRV+LftKBE4MFsPzd5jCA3DAK1fl37n94OUkGbtIgfixI
	1FZ+HnZNXMRtt8pnC/iyJHOgCSrOyWo=
Received: by mail-ed2-f31.google.com with SMTP id 4fb4d7f45d1cf-6aa053900f5so2031806a12.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789488172; x=1790092972; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cj8iWYGkmy9fr6Sp+MjBMi0cvssqzarl8Tgut8FUMEc=;
        b=Q8lDAxH2LIwYR2spnZ2zvUJe9ufXJtgd2eVvSvQXC3eghP1+NlitLkzwP45iJzATi5
         tWjpjeoglPlja4Fj7zHgJPXsvyyUklo2KNmmxxaO+RwgqkHgUlALdDYi6ffEjM1eWRyY
         SGX3Dov8pifG6SWE4YxWxUONlNWIToAuWhiRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789488172; x=1790092972;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cj8iWYGkmy9fr6Sp+MjBMi0cvssqzarl8Tgut8FUMEc=;
        b=Oyg+fF9bOoHBmwywfe87qanc2JSQ5/znjlND4gwBzmkEUYcMKZnBd74gSYTcwoL2hm
         pRX00MWoLdnz2rRZLyHYfsrJAnypyYnovfaUy1G7dH5rXPk5jPRINKf5wgJJBvTpUj9y
         jp2+K7IdOMbGZs9GmscumHNouBhNsN42Q/Elat9PZdLiFFkofYW16N+4R8DIa9CIlwRs
         YoWBoeWXTrcSUaw19HgO9hrEQk0wB4Qpaq6ME30SOTYABXk5lJTwaAtAcA8H+2Hu2OjV
         ldzBcKJsRBm/SLWSEjsbHkZla0gP6JdcXDBKb/5nLiJHwNdaBGOgkQlLpNlXOZoZi6Ry
         bfgQ==
X-Forwarded-Encrypted: i=1; AKwUvBzC7+sE5MuiemFx1wyBlT61hjxGIX+fcKUa61+xpDa9DSkF8TVIJtB6VN7SWgbIQ+QjMCDoAiaiHA==@kvack.org
X-Gm-Message-State: AFuF++naFIcwethHLZk9QPd0qPlQvseV/tKGiVVS00uso/0MUh6vFe7h
	NoyQXeH5rSnU84c0mSXKHm3FyAVKLUINx7DZTFtqIEdBQCvt3ruMPEYJ4cdeFe8D/Ej5pr84p2r
	ygCTtHQU=
X-Gm-Gg: AYBFou0hwO323GWieeZ4p6chh7zwnscqsLNC3V20faojzCk4Hz/DJqVAm1BJ+udnuwZ
	IwiItUWY3sGIEUNSKwHqKi6y4y/wzwRePz+Vv/6HunOU0WegzOcaorQn6CZgYeY5V+7i3HstnJb
	33tfg0yofc84m6gUA7s/WJzl9ZNPHPHPhTPgfUPujL41plloxLLgPc2pnfPDhr4PdSjC2HtiGzq
	bhwRCB3Qyy1oO44CPbnfWTxiITPIoEDzgctCPtmDDOitmBizzWiUYvfhl2BZ04WWqfzo0/q1fQV
	wCloeUVFs7EeVhH//m175bj4IUy03DN94WAFlFbvnpF4/d6LnDBLpCO0Eb4LuGMGrkxX3JOUPhu
	0raaI2Otz7vNJVPYvApiW071A4BCcDWUp2YQIffYEsw9DM+yrjRqaJgTOQaRrDwHS0hCFhigZRi
	uzjRUg4sXvS2NjqmjYpSueLBAoNx/Cefd3jJUuWNrY0SCKrNzIWcrton4z651dVw1g5ZG8eyYSD
	IYRl+L8tlxkmsClO9c/oHxzjUo7mh1nQ6k0fZA9f20VQ+vHUw==
X-Received: by 2002:a17:907:720d:b0:c24:6985:d7a1 with SMTP id a640c23a62f3a-c29b84ded7emr538057666b.7.1789488172279;
        Tue, 15 Sep 2026 09:02:52 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29de6040b8sm117066b.48.2026.09.15.09.02.48
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 09:02:49 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c264788fd58so553974866b.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:02:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxNl+Qb/yGeRsoZkCpI2IE1x5ynk1tYHO6prrAis23pzx5Z5yQWsO/Pvs98Fw6cASMAknMTKswdoQ==@kvack.org
X-Received: by 2002:a17:907:cd0d:b0:c29:439b:d5c1 with SMTP id
 a640c23a62f3a-c29b86141b9mr553591866b.16.1789488168046; Tue, 15 Sep 2026
 09:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Sep 2026 09:02:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com>
X-Gm-Features: AcwNN1WK06t9f9BcKFBIanysXcyUXK4eRICuH4x14s60AdlpF6ijCATIYaYAAvQ
Message-ID: <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com>
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Jan Kara <jack@suse.cz>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, 
	David Airlie <airlied@redhat.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	kexec@lists.infradead.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FD4A18000D
X-Stat-Signature: i8s4t7m1n5regoqzg8enok5cqwybhafn
X-HE-Tag: 1789488174-965869
X-HE-Meta: U2FsdGVkX18tQtSvnLAHygXJxhttKv1MyuXv1eOj0joKjyXKXyiOR0Lu9Fpz9rNtxwR3R3SA0jEZsK2XeVZjGvkM8qT7EKmZJdoL4xVsMWkFs2PFEosonQlMurNjX8FPqElAqABSiRV8Ka85jOu3zykEQmLj/FKq7e7+KvwElixYI0Mv1+oE8/D9TLasvQx+npjQnxaxbzRC0rYqMAxnUD3uMtmx2Lfe6Ocn95u6qYwk/Uhi+pNAT3oukMTTt0GIm8zh1+uDPc9nOY8AmmleThR8iwa7aIzgl3jxsN7w1MK5vPsOfblh8+hQiZ0MDI7wTTtXDEFEVQ5W9LOOnNg1XAh+fp7Ic58UmiYWm8kHi/pXYPBHpN7svdkeT8gH1xJQxOER+ckNXykaTsOiw4Z0sOcvZANGLyYwpHrNxrSwd2HTLOE27EeRIRLrvFbohOYWM77ITQbZoRaGY81UNC6V3J/qh4Z8SAWQc87hiLZ755m+i1uNoUI3RU1QDJFhlOGiL2JWl35jkUIBJnjc2HD0GtmpRszxY18bK9OsHKB7VCnYwY+px7EkX0sUYiFb1bBzMe3QPCa3xhYiNBtluWmyvhLDiX2bOv+3acSRe8UeED7RZUtB9M6ylzGYTSrjbjDlUwfP7pHNneQotpp0/ChFDiE5OLi1lfaZ5LlScJk4b2sVnWfeC3k7wO+uYd1I6KTsYFNTyXGRnmW3lWhURKXwJWTxKM8qJ/t9Tqe9+Ooxbz/m/97sJJMG0s88s2fyuYoOpVvvRm83f1PCgsIZOHoBzEWCwcIs+2161MNyRWewQs8agvonzTNil6PKsc9ezCad2Mg4SBDgblkk+Y9Jx6uOjWodct02AWxp4lHnhnOrOyphTHZsxx4OldyNMktE2fDGFhdOk9+B/paMD3A7Xa4VrYlmJdsPgR8O/cwVTfGSkD3TxqFw/1tcLau+HARB/v//D2PxOuj1jfOMafWWTSR
 8eOAOY9X
 oo49VveZ7yzTbWA7WMshDUq1Bg8LCuiRGE9TFfSBGrhTLlfsW9fAHDrdXCCffMMcRvl5IXWRUWNyL0tCXPfLGJj6KcsN8NNTS63mTUT9DUIMsdB242tO3KCbeJyFpMYnmicGIfzbl9lYc9TupGOPjKgUt6vOxsZo1mwQRNYvFY1+CKfIjZIxqE4f9GRqtE2fSTpSNN8TkSW+o+n1yajxjrO9m00a0YbpVxaCWzY0C9siO5miFUeNcPjElUmcDJ28VOwPDIh44iqCgCdopChfeMXCYbm07c3lYKoWS2Ng8i8N1dUD2iRO2x72y5a+x17nUrFddCdKidPjBydgoHrOtQrgbWDXF81VxN5NvxUCCx7UaZiq9/28IV+KSEvnYF12ldL19QGp7l6QXkJBW02sX8omP4dAQZQ9LUAfV0NG4XxccTGxzCJ2Jg+NAkA+zMtzJJ9+7U6NPlSZ4db7ySptY/8qPmS23sveFJbABYALYnXinubFe8q3yviT8EmlhhHkt6GNMdu36m/kCSim/xF1SbVcqSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sept 2026 at 04:31, Christian Brauner <brauner@kernel.org> wrote:
>
> TL;DR, this lets arch code handle fd install and cleanup. fd_prepare()
> allocates a descriptor like get_unused_fd_flags() does and records it in
> a slot on the task. fd_stage() attaches the file to that slot and
> returns the number.

Honestly, I am *not* a fan. At all.

I think this adds complexity rather than removing it.

The diffstat tells a story:

>  106 files changed, 962 insertions(+), 861 deletions(-)

in how this adds a hundred lines more than it deletes.

But to make things worse, it adds them in bad places: low-level
architecture assembly code.

Those extra lines are *not* making complicated code simpler. Quite the
reverse. They are taking fairly straightforward "just deal with errors
with normal cleanup in the place where it makes sense" and makes the
*straightforward* case simpler, while making the big picture more
complicated and subtle, and adding new code to places that are not
simple and just blindly do somethign that makes no sense in that
context.

IOW: it's more code, and it's more abstraction, and it DOES NOT HELP.

And yes, most of the well-maintained modern platforms (read: x86 and
arm64) use the generic infrastructure and they don't show that
low-level asm effect. So for those cases, it's mainly just  that added
conceptual complexity and a new odd rule - and makes a *successful*
system call go through that "extra work" and indirection phase that it
didn't use to go through.

So it just spreads out the work, and moves it to a less obvious place.

All for the very questionable advantage that you can now randomly add
a file descriptor without the few lines of fairly straightforward
rollback.

IOW, I do not see a single real upside to this, and I see immediate
downsides to it, and a more abstract complicated machinery.

I do *not* see why we woudl want to make this be a "every system call
exit" kind of thing. If there are places that think it's complicated
to do, they could have *their* local little stack of fd's pending. Why
force it onto the low-level system call entry for every system call
when there are only a small handful of actual real cases (the vfs
itself, and random ioctl's by odd driver subsystems).

              Linus

