Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0208CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F113B8E011D; Wed, 29 Oct 2025 20:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8858E0106; Wed, 29 Oct 2025 20:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26808E011D; Wed, 29 Oct 2025 20:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D15778E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:16:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CEFA89078
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:16:24 +0000 (UTC)
X-FDA: 84052863888.06.2254CEA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id AB78812000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:16:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MykHB0YX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761783382; a=rsa-sha256;
	cv=none;
	b=EbPu7JbNeafNpVeRFL489nXJF4+gWaL8Y+4M7JNZCbGrXpolteF5FAzdRwDIqCRYVavS9N
	lKvwtDIwvc4XchfY5zzE9XeENEt2dt5jFzYIoK6/iouJAZ+8UtBwr8RM2lVo97YOA5ggDo
	uuxyZUfPILj/W8Qtd2uRl8OBYxGVrx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MykHB0YX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761783382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+I/KzwoC12VkmtwKHyh/Qebgf4gkZrqoOo7LWzoDTQ=;
	b=HSVpR65d0pKevACvmMUv+0lYrDCaRwcSS5ureu9GQZVSgvx0ozwspi141s0BEfPf+kSh1W
	jPX9p2E55mTv2+7uEENgU9MzFPbseXfEk6OOC3ANwfUVOPRE4XZUAa8wmbRf/q3Htf9GGx
	B2nzMYYVLvjw0+7K+2LIJBZVRFuOeDg=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-475de184058so1404455e9.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761783381; x=1762388181; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+I/KzwoC12VkmtwKHyh/Qebgf4gkZrqoOo7LWzoDTQ=;
        b=MykHB0YXJDaHBH6XwGABCsmXxrGEgp0ysw8yIiHQSZLRoAJPXNNVZ2ZBbM8gPtiwEU
         HVtu1UdycPOamIGHDdpCKkmm0MVzUsd6DDYnghLNl4jcTYmRHOLUbdCWuC9fA84ctOKX
         GmD/QoUY8ffrGcDYMP/LchLD2AgEOSS1Cpjev4OnPrYor/xwZCSe6HRttSl+RkHROnda
         kq5OxyNr7cTTSIKCA1J7K0E6y8Rie1WpOubOtlxJUWsZ8yzp6JxcSl0IbkiHGQSZvL17
         H0xEtH+NJJQ7iY1ssGKc4uYbLJRkoEdYsg4sTWUzVdA9pqT7ZEOD0SpYJcr+T4nJs7KG
         tVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761783381; x=1762388181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+I/KzwoC12VkmtwKHyh/Qebgf4gkZrqoOo7LWzoDTQ=;
        b=HSlRSwtX1ahTJk6LNCcu6YuXuedliAnF9bhuABoRRuqm4+cbV1E/jJ4uusGtQPDjpm
         nhkg7eCtsV1186jfBSLonhggk4pvS9352BXu9MFBwyYUG/5SXJgdM8SlnvibkqBbBwwU
         6UFelmeUYLctNl8LFW5TpguaubMuH5L2h0fsidMs+nH+dkIRwoqIoG2dgHZF4u+e5mCh
         hc8ea5biZEuWGn0dZdjETiZW1Bz2u5/uQKGb7GG9jCBBfPtQu+AoCYiLMwcpDo4CXxFe
         f3T3FNu5G9iuEgoQUoQoacy6pkBC1K2Dg8H+AAfXfBATlATpcImGoZcYW1GNXGKNp+D8
         T5Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVqFb2hKGpQydkSCI+D9Lc0n4xa5oWWjzJ6CQabHlJoi4auBPRu3rBknB7QEK6lLQY+AZ78+cUvhw==@kvack.org
X-Gm-Message-State: AOJu0YwaivVtrHoWDjTa+MJn/pA2pAZpgA3dV4lLgAyBh3BI0EFzGAk9
	9aF5bWy7QmYq6F6pQ76EvHpsoDwJgGVb8NNrswXIppvddpyaZdhWwYtqL6xLHhgLx1z9arMSjg5
	Ay8u86lZwC6IbgVO+wK2HG/2WZJ+huUI=
X-Gm-Gg: ASbGncubo8QLI0yHp3K7zVVxBmr26WLoBjQR6GAlquwpNH0c5oON4guXOFkHgY/cYqX
	B066ClKeWIoNX8cZSlBFHMm9skVbc69tcIMmpcoHC60Dsp0Jb5K3fzOwGcOjxb/bg5mR1xsDu3U
	DSyYtlKwJlSuTiS16POmnFc3AlZMaOfophJLc1hFmTsWtTSuJUU72j/pbyHNDXPzi/nHA89Bf5k
	+VdpSYQpLVaRGtZOsbVoVVvzWyvwhVdvROinGJ9B9TbZh+FR/+zvazjjJF9QDgakMZQaWGaMTq+
	/t3ze16ftYXnwzUpLQ==
X-Google-Smtp-Source: AGHT+IF09btOdHcwxJqodVRN+ViMyO/SoklcID7X1FwZ3ORBb9xOqUsCObSUvrzvXw3Kfh27llznbS5xErV22oTfDgo=
X-Received: by 2002:a05:600c:64c7:b0:471:672:3486 with SMTP id
 5b1f17b1804b1-4771e18157dmr48056215e9.15.1761783381050; Wed, 29 Oct 2025
 17:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <871pmle5ng.fsf@linux.dev> <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
 <aQKa5L345s-vBJR1@slm.duckdns.org> <CAADnVQJp9FkPDA7oo-+yZ0SKFbE6w7FzARosLgzLmH74Vv+dow@mail.gmail.com>
 <aQKrZ2bQan8PnAQA@slm.duckdns.org>
In-Reply-To: <aQKrZ2bQan8PnAQA@slm.duckdns.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 29 Oct 2025 17:16:09 -0700
X-Gm-Features: AWmQ_bnVnjW4yRQWoj8DDZKSY0nxin242cIZkPvDGi7K7MOsZBTy6KJHgZg6C7Y
Message-ID: <CAADnVQJPcqq+w0qDjMV+fx-gYfp6kjuc7m8VD-7saCZ7-bvaBw@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Song Liu <song@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1e6359zpyo9gy9w69ups6mpp5fux9uxd
X-Rspamd-Queue-Id: AB78812000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761783382-408090
X-HE-Meta: U2FsdGVkX19T2nbtvwmVFVY4slcGOq1OvRExjkCBxwcUBzJGP+i5X1YfO2SdUrHc8iPLawwHbtzj5tu2qhVGAoONfCnGYHtTvBdx0hWS7ta2CRiINB6D60bUIibaetANRlgUTmUxOsRjkR/xv98gH4vxwiHQRP3kxJp8160ws8JA/BtZzuV/YBS7+lhv+LnmvDAtPjv4TjQUpD7i0yKBrczkr+IJ0eYeFrWxpuSFe770Q8vbnyupeL6F5r5oc6UgWXrSpY6mFdyp1LORZhqgCwyRw34eqhBduNEakwmdjnUld7XsW2IIHAFUPT30PjN6UwcK1DoH/R13T/Oq+TEb5wMnX+9JVajvUVo3IRAiYgWqDpM7WQSGITsZ03rbjwugjmlfcsuxgSfxcaCDdGCFjJos2hqGtxtUNCdPwk1MP3ByuiLUpOTAGj1/dVjLYnTS8k+Q5I1Z7uSSYEtAmoC3h8Cis2L7pGO9WVaWZ+f+z2IdeFnJrPlVoeswMJgKtlEeUz7R7EcEvWqNQlLrrZQS10M3pj5gFWxHv5Qdmp8jeBaHJigkk+OGlrN8gb7hCZXgZHKBZGVdjkCZeXPdOmRB/4Cuygxlty8JwDAEqfngqf9WEys5MR0akBSy5Quyp8EQYUlNR3xu7/2U1DlmXCnuJ9aoCrn9TaHQYj/6JkYWjLxphXMeSVRHe0ivRwKWsXHmFRznsMMNfmesBQbIiHPBObWH9/9QNZf8caUuVnXBZBsdZvc1Evf8xht1RzsoOXuDg6hlOMNaWXJR9ukmzwwfoC7zawhYW5VYI+fplrWtD3rNUrjuKEiPSpfB7DUES9KQbuYQpcl4rHf+Jj25nCOyuu/J+fpkDbVIrGmfLtGqR/oZmiIVLujGxrtCDXCWm487ZxJdqoMp6IIaaN48akzjzXwkbDLi2nfDtQjQQn3w/XzavYaL3Sb4XPQ5hqGesWF9kyKy6VvqJZAEXV+fvJT
 /t+6Vpi4
 fIEDX4Z+Ju5QFSl8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 5:03=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Oh, if there are other mechanisms to enforce boundaries, it's not a probl=
em,
> but I can almost guarantee as the framework grows, there will be needs fo=
r
> kfuncs to identify and verify the callers and handlers communicating with
> each other along the hierarchy requiring recursive calls.

tbh I think it's a combination of sched_ext_ops and bpf infra problem.
All of the scx ops are missing "this" pointer which would have
been there if it was a C++ class.
And "this" should be pointing to an instance of class.
If sched-ext progs are attached to different cgroups, then
every attachment would have been a different instance and
different "this".
Then all kfuncs would effectively be declared as helper
methods within a class. In this case within "struct sched_ext_ops"
as functions that ops callback can call but they will
also have implicit "this" that points back to a particular instance.

Special aux__prog and prog_assoc are not exactly pretty
workarounds for lack of "this".

