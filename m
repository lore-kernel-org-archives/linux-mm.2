Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0D2D41C37
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7776B0005; Thu, 11 Dec 2025 08:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378166B0007; Thu, 11 Dec 2025 08:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267EB6B0008; Thu, 11 Dec 2025 08:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155136B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:25:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99717C018F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:25:39 +0000 (UTC)
X-FDA: 84207262398.10.FD760A0
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id A25DA10000B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:25:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZfSP1Oqk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765459537; a=rsa-sha256;
	cv=none;
	b=ogffALCPovLN1U5AsHWwH/0I25ilYx6jDSOrC5yxL/g9INsBfZMLwPPBFV0wIfSVo4Kg9y
	INTrwUkf0iC0Cg3PwbEV1ElZCwuYr5eweTsqwtCMUNqPxeAb/+VgDHTvSY0HI1K+0Hsutl
	qizi7HgzrBVbi01sFB83vcbzW762ItY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZfSP1Oqk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765459537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWA/kjxAjN+uRNvgRsuZ3C4JKMpyTL0y62dCZ1FivCw=;
	b=Cxzjp1A2teS9UDGySXWw4Parlge7zm0Zt5yZwDfQXvosXHmGUtLUC8DPaONn6t0qfiGoe4
	w762ui6jsFfMdAdxrCdj3K9qmOGY7Ezs5i/HI/tUZD9GFcpvc7K+tTTPHOWbMYfM3M8g0S
	iqEJijoU3QlKFLbXFyyOO5EBJz5yO58=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6447743ce59so66692d50.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765459537; x=1766064337; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bWA/kjxAjN+uRNvgRsuZ3C4JKMpyTL0y62dCZ1FivCw=;
        b=ZfSP1Oqkr2r1pQUlPSTtCU7SKQErj1KOJT1cIA1PzJojbjqlvO0Fznwv7GTnfqedyH
         3XE1FFBJnrOPglU7/IZ+CNXC15fu6/Nu99w99X+9c+jc/jAUxLcbg4rwDFKVQp0As67g
         hqKVTlGwFbSAdxiHd5sKIH+KaKFPCKShvuN2SQv6CaEJpUfM5Odw1nX+jOR63hV8xdnO
         ajFtPFwje4vuHGsoEF15Icy3qwraHbpZJi6OYf0ZYO4Gy6AfcS64io09bqGXIVfLLvXs
         w7BY8UZhIlsfWusKsdep9fkF/sUQDUo2zQvf6zr0NQSpKhSNF+nSH2DpQShJPuuPanoB
         2/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765459537; x=1766064337;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWA/kjxAjN+uRNvgRsuZ3C4JKMpyTL0y62dCZ1FivCw=;
        b=v9aFzwmkSibnAWWLfsfcEDTUWyHxlbs4BMr6pBoFZSqrwAg9WOILGXPc0llZJelYab
         QxH4BDP3EpPNQ9EpNTJxe2aUqNZyAm9GflWXQXcR69d+OqAV09EWEESpjWtwqh9eLSli
         lUhbI2RkMuW4Hk3fjL5F96svJ0UAjQxJfiFUa2U6eyCWdzOwNUbbkWcJlv/RmgY00Ufn
         z9MmHPVL8Ddd1qPEMh72XCguKgMaBBc0hwPYnbbinlrkS0fCc44SRr2xztUTqam7gSXM
         2Zd80tGH0gVmtChD69mepIlGRRsKP4l+S6dqdjblDfSW8nHs7bDCVSDaJ8HJpFXc0tZ5
         C+aw==
X-Forwarded-Encrypted: i=1; AJvYcCUMSO+qVLZHTRjKu8VQzx9DJtZNJE7xQUi20N+C8zYPz7Esha3n18CE/k2kbKchljEAiyVAii/pLQ==@kvack.org
X-Gm-Message-State: AOJu0YyluhHjdCkxzqAE4GMtBsm12ptLa5EIFKnO4Crq2cecSWyksKE8
	63lcjXo9iwDE+7Of7/YH7Bf98WxPtcdbaxMKyQli4CImaGNEw7O3n4mc8rHt0WfF238/Od9sW8j
	Nz5qIynDG+eRu12rKQMarpZVZ3JwY3lLNAXpiw0K1
X-Gm-Gg: AY/fxX4Up1Ee9r/7edjxEnVQNsrUNEOK2laPWS3lNEAO3k5/myyvJFtMcpHcYpONlaq
	1YxBBTJFZTTuXaYJtT4Qww5HLHQoKaaqyGHNpuLv+SKBc7w/yyts7ifossiXHkOobeQwWltNwEv
	IKPGxE2hNRG4+COVsHaNFI9ttK1zJKyCb2mCIGD/uePL2uR4FKUYXwOV83laKxwgKllnNtl+yZb
	2oKJyZ3mIhcIhCFkT5fhj+MwcWY7zlVv7rZeScAFLCiJClPVEEw4DV5n58A1V8dIzG/OYqt+9Lz
	BOPM7qBj8yJIXE2CmisKGYEKtYvVq+v6MA0=
X-Google-Smtp-Source: AGHT+IGPj4VYuvzobJuySeUtMjR2owpUV9b14snNLjzBypYDLw2+crQYToZkiUGcBVWZIJW//ll4Or+5K7PYShnu4As=
X-Received: by 2002:a53:d01b:0:b0:643:1a78:4492 with SMTP id
 956f58d0204a3-6446eb6016cmr3860639d50.81.1765459536448; Thu, 11 Dec 2025
 05:25:36 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-8-elver@google.com> <20251211114302.GC3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251211114302.GC3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Thu, 11 Dec 2025 14:24:57 +0100
X-Gm-Features: AQt7F2r5KNsATXW8d-J0gXHLFG6W_D0lOL42kIv9mnu54Km1ZPN_9U9TSDd09do
Message-ID: <CANpmjNObaGarY1_niCkgEXMNm2bLAVwKwQsLVYekE=Ce6y3ehQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/35] lockdep: Annotate lockdep assertions for context analysis
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
X-Rspam-User: 
X-Rspamd-Queue-Id: A25DA10000B
X-Rspamd-Server: rspam10
X-Stat-Signature: j85bxh3xo5dq73jwt1sr7a3ybpwju1fy
X-HE-Tag: 1765459537-880370
X-HE-Meta: U2FsdGVkX19ltsNVn60Jw3V0WREkZk2WkjK19KywRU3HdWFlQIEbn98hDeKrylspDK8S0VAsX53MKdzt0GbqsBF2ze61mzXsYNm9Uxq9gT8lk0bfr8VduT2CKLtclneQTLfwaEsvTLMjOhHwN0SB9f69bGCyAfEdm6PUs+LNurBLGDcgWGR3ieuaxNqvoMpD/CnY4DXpz0DW3DeZ9g4zaXqwE7LWU8BiAIg1kYDVDg/z3XFBqHW/OkMTjFd8gscRWbE62pSxe6uw2ywUOaWHy5V15duLSsEqRWOuIwbDiKN1mUgwXcV33Mokhj4Cu3yC83HbxXxn6nHSgcwfZW9wHRQxgDiwxFt5hViitVM98wxqy55ZibhlztnLQJ7AXxOr4GvmZqkewCbnGqJJgxw1p1ao1riIQWaJS9TNvgYpYLLKto71Qxjq7Kc+ri/50ud16QpT5K66NcnSdjiIO7q8K0VdSKpm7/QloijOw+tQJ3Jkil6ieA4yHNpXWdYVl07Up5dG8kmlvvWzy4RLNbxFFHDeRQYE+7yEtKQvPWVtJjB/UQBnW3BHFyG/QBZAX1XMhRf0SBR5BIwRXjk/5a6xnvIoaqSIR0ZZ9koyoJB7KKiwVbe1m7VDI+wpcwj7q9VzVg5g5WFn8zaAhD9D+FBkDtpALx0HB5R5+n+WHn+C05r8LqhGOYNANSb7I0M08sKAGuYATGgRyJM5Lq6hTMAVIR7bEEwNF0ikQTKQXiDtXZEyyESANmjkoj5UL0xjxJF1twlqQEdBi/QPMGTHKpD91YUyIKObGuco+M6gLT9W3J6UY9QLzQ1lXo19a7rl5WXZvpeLH+XlUZ+tQQzV+eNWUWz69SAUe5FOxW/ctAtIW1tRIgGYz0AuWLnlXT3dOFHQpqLaLwGESms9/EC44CH2lAcdXL97ujHWEcMcpDXnqfaZxKCubEIPOAI3FzQo44SNPiehX6yVlB1nD/ZQR5Q
 UM+oBb6r
 xBfCKvApWSeGk1tsnu7zExGWotGwKIN4jeerbetHb3lxyMMLr6Y45WBIgZX/pbCgLjGHBAeMDhFOoqUcJaPzZyhO3D5s2OZwOWrBPiGIdYespozNY53ypHw3QTtvPq8OYPAmWeajfa4eZ1UAwXxWIeRLr1gdSR+zCJgCFH0OwqGkAOs9E2QzAeQE/pL9qJtBM7I3cJ9NGdOTm/lZEl/Q30Hu6P/YrXCLTjcz1HykGb06BIpMeAeVm6bdDoKF65YZsFCVQ9uP7Ygcx+liiSs0WByQ1vATeXTqDC9B6VHFNje4UXrk1drfdyoxx1D6xlatD2h3tWeHMd0sqz+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 at 12:43, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 20, 2025 at 04:09:32PM +0100, Marco Elver wrote:
>
> >  include/linux/lockdep.h | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> > index 67964dc4db95..2c99a6823161 100644
> > --- a/include/linux/lockdep.h
> > +++ b/include/linux/lockdep.h
> > @@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
> >       do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
>
> Since I typically read patches without first reading the Changelog --
> because when I read the code later, I also don't see changelogs.
>
> I must admit to getting most terribly confused here -- *again*, as I
> then search back to previous discussions and found I was previously also
> confused.
>
> As such, I think we want a comment here that explains that assume_ctx
> thing.
>
> It is *NOT* (as the clang naming suggests) an assertion of holding the
> lock (which is requires_ctx), but rather an annotation that forces the
> ctx to be considered held.

Noted. I'll add some appropriate wording above the
__assumes_ctx_guard() attribute, so this is not lost in the commit
logs.

