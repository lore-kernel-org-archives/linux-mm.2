Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFB8F3D33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C626B00A2; Thu,  5 Mar 2026 12:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D6B6B00A3; Thu,  5 Mar 2026 12:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039786B00A4; Thu,  5 Mar 2026 12:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAD736B00A2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:18:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4EA65740B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:18:00 +0000 (UTC)
X-FDA: 84512667120.08.72EB1AD
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8AA4E10000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:17:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=IrtNrvFz;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772731078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlUx0Q3mIemdGHzrjkfKl0zTwu1Q2a/1NFXe9PhCvmM=;
	b=eZSDoA/+h3UOsrAaJHZiyJxgZ5KYoY2F5lRnOFWDhTSEgqt6xz0PMZ0BRVyU8jh9KkRiWK
	/h2FizHpT4LD6NakbfSE+jPLz4/nlgzPeBxuz1WzF8zQVGAxTqe2ktwnIsDKESWApgU3CW
	yrkkUgeKPDpeLK6TugQ2wraqsU0NZ8Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=IrtNrvFz;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772731078; a=rsa-sha256;
	cv=none;
	b=C5vEO94DKTk51yl9CDB+J9h4AKNQA52CM+z1QKT1rnGttRjxHF0LIvbwfSR4PVtPW2uY7C
	roc9MbIDtQ7+VvDIRGlFxYckoZz0ubKSFj0KaYsLhoA7/Hfu4Jl9l9TWmnTxROUBxTouGe
	tVP+7Hgj9v/8ThW55iCfhbPL5Kt9Uys=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6615c766e60so1298074a12.3
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 09:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1772731077; x=1773335877; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RlUx0Q3mIemdGHzrjkfKl0zTwu1Q2a/1NFXe9PhCvmM=;
        b=IrtNrvFzJVJHyoh8bEzf9hbI3pnvBFV68c7kiuqnWhaWKnXVEyg42Oz5gpFhcFaGxF
         bb8Vxj21BDkQU2BpNdVWFVUmQUwdUeG4MAbrR/Caj2KtuD8io1tHI/erGtdXwauvVNVY
         5FpUIj+VhOYKaoL2Hsm5c+dm3gtocQ5+xhM3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731077; x=1773335877;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlUx0Q3mIemdGHzrjkfKl0zTwu1Q2a/1NFXe9PhCvmM=;
        b=r6HfCPXCc2VovKvNLcrqL8+nr7QWVdjzgHwm0YZ/RuTo7MGjjBkM8lBnwjOdbpui82
         bu3/ClsKSL88sooGmnVode5qF8LQeuZx606NMYn/Dd2gC6b9tVGSkdRyJADUU4M0PYvq
         eUf4Mkaqd5Qw2bHbysYZC0egUPfyHdtiGjwK+6T7K/ZcU8vHG3Uw0tmWPJFdD343qEB0
         ss/R5qshBawM6feQXEAyxnFVGkPmmpUu1WqkngJPNKygEsidOUEAiWHHqNS10B/1SL4R
         83rqU56LjfMHzdybvfAgWBSRgtM+OlJklAtJqhuRlETgIb/+eDlIREt3MbV++GEWx20K
         dZNg==
X-Forwarded-Encrypted: i=1; AJvYcCV30vnIkiG3rAcLAB7koKmI3phzeC9SopBDwcJSoIBQmH29Ic6BsQ6a83C8CCiLxd3B1u//iICb0w==@kvack.org
X-Gm-Message-State: AOJu0YyE3gJp9Jd4bSMh1lXadey3KNHnsaxD43IyldxLjcWa5xcE4ZLv
	kUExhAOjnTuofvOZ+1lSM4VPPy4+JKZNDlmfobrPP1NqWEKj+g1cPJAuD+Y9dNpkcPGXQW3a1f4
	0KIrcRSU=
X-Gm-Gg: ATEYQzzKssrUuxNrx/HPE736eAAlawfHAH6nVr+rcC4z1abAk6t45zxwzSrMr9BcBF4
	9ThrpMhXdypaQeZwZ0dJRZU0rRHVauJWH/i1N7p/xkxsMRDK18ZayPcSiPN+Y0r6kSTg4G1GdEi
	GAxgx+pmBZbZVHU8SzQ1VSI+z4ebMrHy15ITYexZVGbN7sA330syVW8N4tj2ux/56cs5e2BWYOQ
	PAcOpPpPhhTwB/Dx4Y9oGHE4zMFWLb05vxdV0Iq6YDEgKGuDGb6y4FEtTSPCtEhkbzMckCjG3io
	Kduq/Eup6nSGYsrVeUkiVfZSEUDPRA4qdg/srVKwCt9259PWy/rlKkDW/hf9VEToqCGwypcUyjJ
	0CGgBY+sT0SJf4Swf+7SMUri7ujXblIdCbhFpAtWiVgi8wtIfvOVYYBxZWGPr3QwYuvszK7adjg
	ee5cHliAu5itdk36+8wk4WlGWGnyueMOXFkQw8DVy08kIZ+VWnu/4JVG9h1QbBD2Mac4LkZw88
X-Received: by 2002:a05:6402:35c2:b0:65c:354e:94f0 with SMTP id 4fb4d7f45d1cf-660ef8873famr3855513a12.8.1772731076611;
        Thu, 05 Mar 2026 09:17:56 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66105735d75sm1983057a12.14.2026.03.05.09.17.55
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 09:17:56 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b935b8dcab7so1296590166b.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 09:17:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXIc97Xl/RlSthIMH3EXltJKMYqeriWda+9WF3BEu9FqzvHB9o8D8gptS7VMC6sy6xBOEMgfb92jg==@kvack.org
X-Received: by 2002:a17:907:da8:b0:b90:e20b:acb9 with SMTP id
 a640c23a62f3a-b93f0ed492amr449349666b.0.1772731075073; Thu, 05 Mar 2026
 09:17:55 -0800 (PST)
MIME-Version: 1.0
References: <20260305103941.11f1b27d@gandalf.local.home> <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
 <a8907468-d7e9-4727-af28-66d905093230@kernel.org>
In-Reply-To: <a8907468-d7e9-4727-af28-66d905093230@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Mar 2026 09:17:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
X-Gm-Features: AaiRm50MziCc2ZpZgfQkRzw_b1J2hORS0ItOZxFqZ_sDR2-NwymgJYJk3iB9XEk
Message-ID: <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Huiwen He <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>, 
	Qing Wang <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>, 
	Linux-MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8AA4E10000E
X-Rspamd-Server: rspam07
X-Stat-Signature: tre6yb6h4zuiqnjyzypsmfr1yu7yf9ck
X-Rspam-User: 
X-HE-Tag: 1772731078-799149
X-HE-Meta: U2FsdGVkX1+h7CpI+poqsams42e00VEo/bWLJ0sJhyukeqWO2Yjez8h56jv5f3rPaK02acmPdFBLXbxfGJuIgCeCayFPbAGxbePApu6OOKkzJdVKNX/eiSz4+9Cl0lV3ydIEP3WQY6N4T8k67WRApTfFLcDTDrXHrV5MMzVRHnzYY+svxxXt6nhTM1GapJ9L0q2ZCjTkKUxP2MJOVlqgL8HQARTrKL6q2nr64D0DhkBRfxZ/FRYXhhItgB/RWFnFHKiLBhzJWGNgDvwH0grINFrGPES1TNORJttwdBXb0layAell8Et5pVyhNoRS8ZBgkjzrzZaWAoFxTaKlj3DJR66+qSJx6NBSQ0xvNeUSjhpNvJ+ZYhx3DQYuxzu+W2JeWB9MVg0ubiGRUT0doLIeO4rx4fiQ1M/O8Ad7N7phxsgDLVGD8U1iE5irZN6z6d+8uxUX/NL569LYHprk4N3DqYK/etSMbkk14hMRAXBqs7wKu4jpx1YdOVqipzL2f7rsw9jX1FRGypdh4eibcOp0/z7C6YMkW5ABObTHDsUeL7jiZT+4lA5yZL63odDT21Zp44DaYoMnhRZgyTQneLSXsq/+jRfgJYI9AThuFTStXN6ihtkHr36UXK/QuGbgF8PbkyjVJ1V5VSid2Qc7ptnKNJ3B8yVof45rKedKg0gvKTSgBTAbM8ygNc3DtaSFqUEqKoDzcxQVADDb1TMlo/hj8NK4JKJmw8XeVAERnCfnADrsRFiYkBzCVCA8Ibf+RwlnrPbHSgLV7+VJpbAc0ONiye+DKa3B52qXJUyN6C9aQilYl/nl9030tvWSeMmpj9onp2neylhyFOuVEOLX99f2Jiii4so2vfCClOp/5RVxPE9kMHC5TM0syHpy2KO0EzOWAC+37146c7B6QMFAjIPD4y1/64o9wcHQu8MwY/fob2rIqKlA+6nOSe3amDPHmGIrKthL2YSohCcbwL0mDWk
 KHctQsgQ
 VabUJZ7VNUDD6jEAd5qo8v3KFu3qYq8o4IpNNLr3ubc57DIKTOZhj8itOlEQq8K3CfSjx5FCCzM3mER18H1Y7PxFuJIRlur/+xb/BVkPb2gwB9hxYJjRT8zLxBXyQxWwLOEq0FbRFk93NTJw5a3YOnXPHik9Qf5IBCt6DB5k3MrZLmvXqB+K6tusOyCH+W7bhfPs6BmyaLcG5nixesoo0OKDjm/uVHmD3tld+yq9EwLq/ifpTWuUXxoSgPt6dqiE3+8a+i2vaiC4X7ZxZBiteOJ0c13krV7Nmn+M/ufdzM8EIe/CuyCfW0MKEngTyuemVtaMP+e9tucElbtam8SC9XuXQy4nsxsDk+dL3Z57CkPXFtuLOjDToXshpOSZFI1YI7LGGf/TjPwpH0UgDb1cKq3pdR7y+vrfAU6KFlMuaLdWQEKebfJpk0Er2K7JT+0hd67poHubDb9vixp8m9cB4z2Z+TZ3Bu4wzR9GQiMKIqeoLub21bzACoxGAPFXlY+NWmT2ckAxhacWealPAy0wgUtDpeJwBZe45Mi/i2igBiMsOpznhAFi7y/x/WNfK9qVDhSBMV0kw/peDZfqCWcenfM4INml6dB9mVfeZOG1v4vpOUw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Mar 2026 at 09:00, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> QEMU traditionally sets MADV_DONTFORK on guest RAM. One reason is to
> speed up fork(), because it doesn't need all the guest RAM in fork'ed
> child processes.

Yes, I think the MADV_DONTFORK thing makes sense on its own - more so
than MADV_DOFORK does.

Because it's a very valid thing for user space to do exactly for that
"speed up fork()" case.

It's similar to how we also export a MADV_WIPEONFORK - for a different
use-case, where we don't want the copying behavior (typically because
we want the child to re-create its own set of data: I thin the main
reason tends to be for things like reseeding random number generation
after fork etc).

So it's just MADV_DOFORK I don't particularly like, because it had
pre-existing kernel semantics (the VM_DONTCOPY bit predates the MADV_*
bits by many many years).

Not copying on fork is always safe. But copying something that the
kernel has said "don't copy" just sounds *wrong*.

> > But I get the feeling that maybe we should at least limit MADV_DOFORK
> > only to the case where the *source* of the DONTFORK was the user, not
> > some kernel mapping.
>
> ... that makes sense. Forbid toggling it on something that has
> VM_SPECIAL set, maybe.

Yeah, I think VM_SPECIAL would be a better match than just checking
VM_IO.  At least it would also catch things like that VM_DONTEXPAND,
and PFN mappings.

So just changing the existing VM_IO test to cover all the VM_SPECIAL
bits would be a simple improvement.

Maybe I should just do that and see if anybody even notices (and
revert and re-think if somebody does)

                 Linus

