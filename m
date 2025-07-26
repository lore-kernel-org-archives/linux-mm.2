Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A798DC83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 23:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079F76B008A; Sat, 26 Jul 2025 19:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AA26B008C; Sat, 26 Jul 2025 19:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C086B0092; Sat, 26 Jul 2025 19:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2EBA6B008A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 19:37:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C02A1141A0
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 23:37:55 +0000 (UTC)
X-FDA: 83708030910.07.C2FE282
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5BAE940009
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 23:37:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FruN6waU;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753573073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tHg+Y1g27jBmEKsSCwCSS49UstWUnsuEvPhc+oks0Q=;
	b=WO9JGAHdeGxsSZncTujSa/xrXQmT2mpLjxW3lSIjtSWg7CmNOgrWN000bYsCGdpIFD05W6
	d6spdgmoMPN/0oDBjhcwdxob6ujcMKHYrIavNKWIuXf+86DJoRT0FWgNvB71/1mfxpAdbe
	6u7vL95sQWCE90TspktIjFvMBhfIZKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753573073; a=rsa-sha256;
	cv=none;
	b=Wqg7PG8cKEeoQtMFysy5sprRfsBe0ItNadImBWMj+37l59Ls0/m+BTZzJJGgh2XLA8XdmZ
	+PMydMkMfbP5+RE4Xtz2Kk/80JRaQHYtg2CxR0cHPeK9qivbmSQS+ULLy4z2mg6Vv6EbuB
	ii8UWyTRqegf4Mk9dZyka+0w2FMlPb0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FruN6waU;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-adfb562266cso474030266b.0
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1753573072; x=1754177872; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1tHg+Y1g27jBmEKsSCwCSS49UstWUnsuEvPhc+oks0Q=;
        b=FruN6waUSKZQr53eDNpE5ruungZaXnthkhx63X6v1MYWfx75ZMKKWdBK2WrZCz7VEg
         iXMIozGJsGYCIxHZ3Ri3UBhUVmyF+LXzNQSxMdwdE96yeAIUTAx5rdwGzeClyBmmQQ2D
         ZIDtq+oysIDkQyjb5j2js2JpXJCG0CEuYR0kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753573072; x=1754177872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1tHg+Y1g27jBmEKsSCwCSS49UstWUnsuEvPhc+oks0Q=;
        b=DWCSmnZ96VGY4uC9KwPRWnUbghg93nlKhTcigWcwWvXCuWODe+ysjHFVfFljSGdaQD
         SOTJcRX+CuttDXaYScJi9Qzj3XeI/aUmcXf7PEBx8SNOONjXYbBkYL/6XhGy9saZmiua
         hG+NdD8RX2aliL1GsTmwzfwi2tDAi5Zl8jaYuzRxE/XzJd/UuS8hDhzQ2rDq2PL+XKXh
         cw7I+6V6XRvg/hkDUgn1IdoGFpeL7OVmOnoXER4BW/+fbPtlRc9Q8jzt+xjbuvx2TZQJ
         MZnlxWJx64vBSBeaU099OFunsjmKG9AUfNDgYAHO4P8clUuPkjsTeAGgh4IhYlX6907W
         lOeg==
X-Forwarded-Encrypted: i=1; AJvYcCWo3mgy1/UohHzni+oWJfxihip7bGFopURlli90aiBoPfaQ6LXu5a3NwC0D38usFJ35S6et0uHguQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9Nmu5OuO/5w2UbeJhQP3f8OtWHvGgoCm2YVmmNR8q5pKwRQ/u
	65jFFqT1Vx0xhslPpbRiWCXKidOzjJTu5gJdH4pi2gIlhfcYxTxOwWlS8hXNYO58WjDXSaBFIxw
	UaJTIQ7Ta9A==
X-Gm-Gg: ASbGnctsu12KXq9qgNPpc//sQeJOU3Xfp7sRcF+EzKflpnXBzOe9wd8zrbO0dzqhmqe
	ro6jINS09eJJMDOw0BMjBaYLCoIT9IpY1P86XRi/IJFQGxkiKuvlka5vjPUsv9PdHIaRNuF5a9O
	3L7oa9riGc7Y821Bvq+LannTRzagXLM6sQf8z29qAGi+AUpNmXaM2+P4Z+DDIvnmW+8wCUaNKl7
	/BfKB8S7z5dTAhPkWIIMyiIlWLJXK5W1skJrObZXm/jsTSzwpa0enaCvG26H/iJ2cX8YlNB9xl2
	sr76aDHf6q15mNik/Gvno2QaQxzlJ1Befs+GNyMhVL8phCofyA/Oy/ayJCjH0kRiO0MI9oHEuWI
	S7Dohv+rqqgNmb6Fz1TUJjjAm+d+avWfcZBHJdCCbj6r7MtFhkFLbsmCj0tnjMQXNMR/DWwNMB/
	/Wx33kelQ4tWb2ZhqIFg==
X-Google-Smtp-Source: AGHT+IGx8ssP5iClseIwkUHT+5FsR90mrzVLd9wC9wrHzrM/UTqLTnqzy2fG3QMa5P5WRYvsJo/OYg==
X-Received: by 2002:a17:907:3d0d:b0:ae2:60ba:da91 with SMTP id a640c23a62f3a-af61ca99878mr826256666b.15.1753573071502;
        Sat, 26 Jul 2025 16:37:51 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6152a0e65a2sm221840a12.42.2025.07.26.16.37.50
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jul 2025 16:37:50 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-60c60f7eeaaso5286892a12.0
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:37:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCURHDGv1NOC0LicELZsp63vtPFBIIxifbw3GXYhWJlyQJCKBorcgQizuViSe8ml8bQ6lvHxdGscHw==@kvack.org
X-Received: by 2002:a05:6402:483:b0:611:f4b2:379c with SMTP id
 4fb4d7f45d1cf-614f1dced8amr5514831a12.20.1753573070075; Sat, 26 Jul 2025
 16:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250724123612.206110-1-bhupesh@igalia.com> <20250724123612.206110-3-bhupesh@igalia.com>
 <202507241640.572BF86C70@keescook> <CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com>
 <B9C50D0B-DCD9-41A2-895D-4899728AF605@kernel.org>
In-Reply-To: <B9C50D0B-DCD9-41A2-895D-4899728AF605@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Jul 2025 16:37:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wixR7ZR+aebFsWX4qWZ84tMTmyNWLUPmTy3YvaNJGqd-Q@mail.gmail.com>
X-Gm-Features: Ac12FXwLhT2VoOEv9kNeOdgouvN4zZ9YLvHzVMPIsLMuRmQFnkSkLFn13r5tjO0
Message-ID: <CAHk-=wixR7ZR+aebFsWX4qWZ84tMTmyNWLUPmTy3YvaNJGqd-Q@mail.gmail.com>
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
X-Rspamd-Queue-Id: 5BAE940009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pp8yr5ah8b64o8qfwg4qbqzystpaz8ao
X-HE-Tag: 1753573073-328276
X-HE-Meta: U2FsdGVkX1+Uw5+eTVFJqryudCFWGYr8ANorvBZmoi+c2mjRRd9Ti2WI0hTHH8Y/oqzgRPnk+yr2xg/2DkHautdDnZO2nuuDH4y0SfhLkSfXFkrb888f+QHXh8IvXuxrdExSPyfsOTotmEdzGMVqVAK5kSGgUhEVrwdXatPMgl3yR93g8mSEla8a8fFxHjVrIXvMXn4C9QOAMjTRxyGEx3mUOMWBZrkth61mjv1cqark9IMZNGSLb7JdCaR6wkxGZWVuna3vElE/rXGFaGbAD7x/tlmapzVsfnBT/hV77fEFpOibhy3yx3Rou1m2farAEh7xOBMw1m6upvPn97U18XGMxGGbymA1tTKrEcwnwP39E7TBTIvgEU9iNt26+tNXfUsxbsgivUonMIZkfBStPQLQYDQZym+Lod4wNRlILfnl4ml4S5C9F9HBP9ztmaK4K0Z2MHzxEjU3cKWfAgtNsdjGiqFvluDVGbvPDHmLRm0Q/8K3Mv8v4MQpE5yaiG/0nRce6JZKbn7XVASig50UJe0TOgL957Lc2wvuxLedLAkzoJOfN8kYWczAexBJ1QNaMYjPxYHkpeSC5+tV7tHpTA2WOdS0/3GAhAbsbIWluPt4JN0zgsY1CLH5dDPfQkwJmwKAaDdegB4fkvuM2a34y5ULNCHQCWAxjZeFcmTrO2cuJZ7B1EeoAR9eEp0DznIiDk0cjnQ/A1NtmyOrttNCnBOkOrjVsTXccGHAW6kVZRsZjb0/aK2MGHsaqDa0TshOuaXbjl2BDnE7Qt8eIGRO7qtA0yapdYZJnmg4qHRY7cfdyrjoxqUuMw55vYm58fSn1Swit5/6LukPEuEFpvoIRdb52zAbKk/qzfXY/G5Fb0xIF2JSBBoNRC+V57UFsgrIiyzQdDk4L4tCcVbFU59WGMEutHHQGYv3U9WxaRiYMZG5vban2PJlopjmsIYm+Kn60l7OyC1pOP3Qqh4aSkT
 IgjqdyA5
 ZNoafzzZrbIwvnG78Yy5jNYjwAYhA/oIQso/ORb+nfk4ipFXmoAf8wbbralLmXQ8OyVc+0w7PTjKAnzOe5wro4XhTO03T8RxN7GmxEQC07dYrfwql1R5fFBPZOkZ/AnQ6KnXGQp5p2Fs7sfaGSFL7UG2CVCtLO0AI7dvfcbIcS7OoBWnjliAZSIsbIJv2o7/joE2jdijnuNl6qJ8zyYimgf5yji5nziQuGKWXD4Za74QWFQqKoEaT6iIYzZdYKk3ug0kzuv9/a8nymHda2ikibRL3Mp5CbDYj8T28sXOwaom3hpx6BQ+1BWq1lsIcI2FC41/55P94zD177Ef9mL9HpoihmGsroenJiZ4IKQB8J4zlDdhFNCCFQ4+sC1TUZWY8E+MonEKSLvWqh0RtcPY58sj4IB9rLEmjhiGTa5xgAGuTum79fW+lqBun0MmuXEYqm3XF4Ot9XjIDjIffR/Zhd8FXcvHSWqMK35X0j4SvbNBTjnZgCBJqSVPrxgHF6vS3MLLspDG2PwO2UH71In6tRVKCWQ7CNvltUaDq2j4w0AwQpNe6RKH1laLQxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Jul 2025 at 16:19, Kees Cook <kees@kernel.org> wrote:
>
> That works for me! I just get twitchy around seeing memcpy used for strings. :) if we're gonna NUL after the memcpy, just use strscpy_pad().

I do worry a tiny bit about performance.

Because 'memcpy+set last byte to NUL' really is just a couple of
instructions when we're talking small constant-sized arrays.

strscpy_pad() isn't horrible, but it's still at another level. And
most of the cost is that "return the length" which people often don't
care about.

Dang, I wish we had some compiler trick to say "if the value isn't
used, do X, if it _is_ used do Y".

It's such a trivial thing in the compiler itself, and the information
is there, but I don't think it is exposed in any useful way.

In fact, it *is* exposed in one way I can think of:

   __attribute__((__warn_unused_result__))

but not in a useful form for actually generating different code.

Some kind of "__builtin_if_used(x,y)" where it picks 'x' if the value
is used, and 'y' if it isn't would be lovely for this.

Then you could do things like

    #define my_helper(x) \
        __builtin_if_used( \
                full_semantics(x), \
                simpler_version(x))

when having a return value means extra work and most people don't care.

Maybe it exists in some form that I haven't thought of?

Any compiler people around?

                 Linus

