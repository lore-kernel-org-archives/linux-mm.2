Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9253DC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 17:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F846B0088; Sat, 26 Jul 2025 13:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9526B0089; Sat, 26 Jul 2025 13:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7DF6B008A; Sat, 26 Jul 2025 13:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD07E6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:57:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7104580A6A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:57:52 +0000 (UTC)
X-FDA: 83707173984.19.E3D766C
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 419A9100003
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:57:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=BpgWvIC4;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.178 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753552670; a=rsa-sha256;
	cv=none;
	b=U4cGQVzIgNfp9mVb/MKCg3PT+tCLZdB9peSK8m9DFobUmnuYK0CWlscQx1ihDm1D+CkwMh
	f/fM0HhFi5JPCJnPeA7q/B4qaBvjx73EHlGcmw2rMhqidXDWRc9H2PyWBfs9NKf01RHncC
	8dBJzKKJyGd5da8F/e9oZ607Wn17he4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=BpgWvIC4;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.178 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753552670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSxbEUJxkP0g7ZjvYqH7NhSZ9AP/JqKw188Y1XM8KDw=;
	b=Dm6kroKqV3f0BkXKBelBPDKvsO1T24hiXWDScoN1CBrXm1W0NUBlGUdwLOoGiVQrqgDEOW
	ViqYZ8W6CINOaN9qD2MbBuqECeipu7jBUHgXGiL+rHx82nz6G/+AjfX99NR+0AwQKJAntv
	lprQ1dlQ1i/RndhENxueL1M0g2e2Lg8=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-32ac42bb4e4so34028891fa.0
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 10:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1753552668; x=1754157468; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HSxbEUJxkP0g7ZjvYqH7NhSZ9AP/JqKw188Y1XM8KDw=;
        b=BpgWvIC4hOUixaXkib3RWsm1YmJDCZInix2GUc3oEq5MIIv51U+VPRG7ZdWz3lYbSL
         1JxPS7Al6L0j+UfRu30jAsK4Bt+0dbDNPmqOaSAyOIrdmnN1wzDGamCArzkVXHeh+B0V
         u0Cc0Cl/5yIo99RcAu8LPNVpmlW/V/q2TU8Jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753552668; x=1754157468;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HSxbEUJxkP0g7ZjvYqH7NhSZ9AP/JqKw188Y1XM8KDw=;
        b=vdhgBG/zVgHJjkLj6zIgnSruJqqMcSF/BRk/SvE9+BSZQ9fDQRnvrObJqW4jvlM3tm
         d2KVmq3FXCnpGCVGHSjbvy4JZkIVq1nphtR2RIPy+GB5pC7aKCaeOiM3uacCjkmMGulN
         6VGnV5NXzIcTgXEtR8WEELUEcFCwNxZupvGq//ZUGCTcRPwvrHfDTxksu+d/dHD68P8c
         CUQZqPyrooQj9Gp2FoZalLIP9ynwT9eCOwEqU3wRX2lz6D9cjrJyI6iG+yjwyuJoQVGW
         VnlOLtYq4SEg+TTgRmAP/NYilXkLe1uNaFRVSCfylhabEl0SHZ7mEMxfQUsVzG1u6BRH
         Gl7A==
X-Forwarded-Encrypted: i=1; AJvYcCVDFI8Lr6+a+LsZm4OWAUEv94ZONItYexBNOtu/a0nbZ71YfPfpCQ3+eEbyDPtbftqKrrOhe6MH9Q==@kvack.org
X-Gm-Message-State: AOJu0YzM/pYC0Bi1AOsUICChJyHOlKBjn4LjXTmn70C/LE8PplIssPLZ
	qGQFr0QUlW5CmuodlWE0E/IyK+qkKJdxTSlF5Sm1OhT6hjZf6CNsroNcQfHAaP1P88lVMJ/l58R
	iRM1Z/lA=
X-Gm-Gg: ASbGncuEId+LWJyW6PIHoGJQjeJnd5Efuwm+/qq9+7KqH06shIhPcB0h+ETdPrjq3bd
	C6L6nYPpar4cG1cz4pMzKKGiF2Q5qb3XMQEWv1z836CrOAWudOwidACh192MaXKueSVBK1bIMcU
	YAhjOC4ctRnxCAtjxNrTDVac3TgpfHdTx0mqo/mTZi26PbiHtzevjKtzYt5W4XDaoQCJBsIId3y
	Y7iopStG5FJySwpYvoqMrrpPJB/KsyKtI/h7dJFT8DZdI9oYnw+XgFNbsOzysiJdG9qux/tl/88
	T+YvzQyeKML5FjMEx0fgDN7zBPpELcXDLKlTLYOjURmZd1sm+kTdpIJhHzUc1L/tRkkTzLYWD7k
	NyS2/w5mp4QlZjrFMjjaV6jeH7myQvfCLcG6fWD1rPlnUVRyRydvWWEhPz+OS21DKUR3XtqPq
X-Google-Smtp-Source: AGHT+IGNSQD1WxAEGhIfclSTBAYCVgRmrTBWD1s0RY4VmJuVnwfqa+b3t6gBlHwKanEb0R6SwWT25A==
X-Received: by 2002:a05:6512:1322:b0:551:f0ce:80e3 with SMTP id 2adb3069b0e04-55b5f403505mr1329718e87.25.1753552667723;
        Sat, 26 Jul 2025 10:57:47 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b6318296csm519828e87.50.2025.07.26.10.57.46
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jul 2025 10:57:46 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5561d41fc96so3585554e87.1
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 10:57:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVT2sdQ+JIdtXibiEw1cvLhfsQhSmFSg6dlWMojOLtPC5joPZkw4Ov1KbhZ427dbPMNJDuAdJ2OlQ==@kvack.org
X-Received: by 2002:a05:6402:14d:b0:611:d10e:ebd7 with SMTP id
 4fb4d7f45d1cf-614f1da658amr5711204a12.19.1753552272125; Sat, 26 Jul 2025
 10:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250724123612.206110-1-bhupesh@igalia.com> <20250724123612.206110-3-bhupesh@igalia.com>
 <202507241640.572BF86C70@keescook>
In-Reply-To: <202507241640.572BF86C70@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Jul 2025 10:50:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com>
X-Gm-Features: Ac12FXwUXdIlVLvMNocbefDF6HEUwlAESHc5g0TBeq7Fw2jKEkXsJpBWks3U_Dc
Message-ID: <CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] treewide: Switch memcpy() users of 'task->comm' to
 a more safer implementation
To: Kees Cook <kees@kernel.org>
Cc: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org, kernel-dev@igalia.com, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com, 
	laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org, 
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com, 
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com, 
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org, 
	david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, 
	brauner@kernel.org, jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 419A9100003
X-Stat-Signature: sq58ja9tk7ao6fjtca8shxqtmzd6rdba
X-HE-Tag: 1753552669-295233
X-HE-Meta: U2FsdGVkX1+B/H/bLvicpzGFiW/K2wBL7lQmNwPbZ1+M+zgq5GMiCCFVhjMFGaDhG/jB65Zhc5CSjdQaVh8P1Zt+gFoPFL4fmqr4xi1xYLTSLwGPu3lmlq8n7S6X1I1pesytB6bpn+10BVqVlXrQQMrUrsTLiqEov4RweN5bHgRp7sjkPkUeUAeUDfyx5z5eW2ODLmo5pp8pQD6whRQ2OswQO+3j0/3cLkB6pDtVUPKbX+aToqlvNQ9xT2ZDKb7FVbvf02PoiQLCIXirnISeFamODuDjPdBpF1OvMCMsRXqL1abUw4V1AJGFiTcwqOYzvRMV9M/NjCC6p47CQPZLVI6Mex7wrASHuyznjJ6dDZ5ZGy51BMbHcu1O0ukptsOdKIWUDHnCWKcJpb6JEM0zH6XYFppSdYoTWi7VSy91dUhMxm0Ckrag885ggA3NCyl3EvjwMY3oIcHBCk/BUP204+7Xc2fTXJf9E3u1WJQlOXayquCeRAtrkbptRTzAUp2ubdlWZJXe2kOo8NMfL9LvyYAdbckbhjEAWBG3h1gqfFNxxOYWhSl56JlZuAW/nMb56Upmon3QGHH8nUlSTIBrBNBNOzsLqirPubBtSprYIN9rMKuUW1zvF1puJWaw9iOtDhkExkmKedq4UhxSnvosLKQ8I4LOWur6xV0nISyMSCcK+Riki3OS62BXjKPXtz+i3WV6Wnc0cQRloRu9rwpjFD4C19YiVS7EosvAyUGbBwabPGdK5vIZY2EH7Z22fW0FmHuees0vuw+XxP5FXNPFtPjegv1vcGGZ1p6tY41bbQ8IAwAIvMJeciSj/XgwxJmu287EtCFVDNBQJ1XBvxt5vnQDbEQ1KYQ5IDBfytOq1uy39LFXsh/jnbHyqxRZmCalqk9PL01t+TIcUBYZNqm0vW4d6CNSiD+HfDYtTxqVlLy5qjH/lhHjyIrVLXKZZrdW+vMdWf9Sc2OvOvOCqZb
 fazExXrg
 iW7i4noaiQ/ECj54LBHGw0+NdJBelCAk0vvPv2by1lJIqGPZbDNYaTIjFWjhgSEJHdN4E5AqdFnLJlVDKE6cfoiVYcqxBMvycQMi/pyt3osivmlIQcc5MhH8JeIzX+l/r9sC7WGXO7JNaRzpTxuyDCN9vDXKZPie7ngAXJiOasIhi8dFm918yk0M24McMVOXh3vW4cHxdMmkqxNpk9bn4wNgtPbdeFllBpKeyDBs5irtts6hAepoVwYNzDT45cEVDnMHALVhzuzcYW9OCJ4oN4E1XDdgJNkt1WqxgxlRtYVmGobE4MwxdadgEQTEsFuiI5QYCwYCiZ3IjQ7RufhdRCe1BpzZPY7+Ua++CC4aqJYmslgKClbwEXR4BHZ/VR8i0YDIL1nFgzLJB2Anae5ym3RWe8kPaGMnkGvTirUWyTbkiS6HFkxCXnwcZ9yeZlaYQ9rY3vspksg0IaeGxsu5U1Bq8z4RqC7ZxkBoWYfb8xup4xTWpspvVjRn7RkG6g/8ALZufs7myJZzc2qPOETMdspeKNjls2f1VD82xkqpVtyTY7vJr8MVo6LspN73LZQoU09AXYgYaYqScZRG1quwr89VMJZXBi9CibGNj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

, but

On Thu, 24 Jul 2025 at 16:49, Kees Cook <kees@kernel.org> wrote:
>
> Why not switch all of these to get_task_comm()? It will correctly handle
> the size check and NUL termination.

I'd rather aim to get rid of get_task_comm() entirely.

I don't think it has ever made much sense, except in the "guarantee
NUL termination" sense, but since we have basically agreed to always
guarantee that natively in ->comm[] itself (by *never* writing non-NUL
characters to the last byte, rather than "write something, then
overwrite it") the whole concept is broken.

The alleged other reason for get_task_comm() is to get a stable
result, but since the source can be modified by users, there's no
"stable". If you get some half-way state, that *could* have been a
user just writing odd names.

So the other reason to use get_task_comm() is pretty much pointless too.

And several of the existing users are just pointless overhead, copying
the comm[] to a local copy only to print it out, and making it much
more complex than just using "%s" with tsk->comm.

End result: all get_task_comm() does now is to verify the size of the
result buffer, and that is *BAD*. We shouldn't care. If the result
buffer is smaller than the string, we should just have truncated it.
And if the buffer is bigger, we should zero-pad or not depending on
the use case.

And guess what? We *have* that function. It's called "strscpy()". It
already does the right thing, including passing in the size of a fixed
array and just dealing with it the RightWay(tm). Add '_pad()' if that
is the behavior you want, and now you *document* the fact that the
result is padded.

So I claim that get_task_comm() is bad, and we should feel bad about
ever having introduced it.

Now, the tracing code may actually care about *performance*, and what
it probably wants is that "just copy things and NUL-terminate it", but
I don't think we should use get_task_comm() for that because of all
the horrid bad history it has.

In other words, if "strscpy()" is too expensive (because it's being
careful and returns the size), I think we should look at maybe
optimizing strscpy() further. It already does word-at-a-time stuff,
but what strscpy() does *not* do is the "inline at call site for small
constant sizes".

We could inline sized_strscpy() for small constant sizes, but the real
problem is that it returns the length, and there's no way to do
"inline for small constant sizes when nobody cares about the result"
that I can think of. You can use _Generic() on the arguments, but not
on the "people don't look at the return value".

So we do probably want something for that "just copy comm to a
constant-sized array" case if people care about performance for it
(and tracing probably does), but I still think get_task_comm() has too
much baggage (and takes a size that it shouldn't take).

"get_task_array()" might be more palatable, and is certainly simple to
implement using something like

   static __always_inline void
       __cstr_array_copy(char *dst,
            const char *src, __kernel_size_t size)
   {
        memcpy(dst, src, size);
        dst[size] = 0;
   }

   #define get_task_array(a,b) \
      __cstr_array_copy(dst, src, __must_be_array(dst))

(Entirely untested, hasn't seen a compiler, is written for email, you
get the idea..).

But I think that should be a separate thing (and it should be
documented to be data-racy in the destination and *not* be the kind of
"stable NUL at the end" that strscpy and friends are.

               Linus

