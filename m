Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB2BC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709308E0003; Wed,  6 Aug 2025 14:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA7B8E0002; Wed,  6 Aug 2025 14:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9458E0003; Wed,  6 Aug 2025 14:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 450828E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:21:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E555F1405D6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:21:18 +0000 (UTC)
X-FDA: 83747149836.15.5DC4034
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0E34540016
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:21:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jsvYOirS;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754504477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpzHgd6TpTYvjXVHg7u1dC6rZFfWzZnJYbp9d0+ZhbI=;
	b=M+W61+h4lX+iu94TcYU6RT1mkgAnaBwbiOByTrn+Lggm0EpJjO+7/IsW1ofSj2HTTtKwTP
	fOlv4OzbWD535q0z8+YxGj/80bJqtwV/uz3/oyr4k/GmXqjbcnIjk5n0pDPZH0pwI96V+9
	W55dziTua8b6m2mmIfzk6AizbpoJv7k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jsvYOirS;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754504477; a=rsa-sha256;
	cv=none;
	b=rDxHlt/AASUSoi+WJp4w9hqWkAgozFaf6rx0T5a1OWs/IIg/4elcZoaur3O2cMDeiqKbzO
	aDSVYEaqnaBf2lOSSVgU1dSJcEiCn0nGpK8VeMGOvJrrC18Z0bEyYGadytNbpGReVpEotJ
	q2T2rdZ1Y7N+6c+ugk487NotVv+HMAo=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b099118fedso60151cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 11:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754504476; x=1755109276; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpzHgd6TpTYvjXVHg7u1dC6rZFfWzZnJYbp9d0+ZhbI=;
        b=jsvYOirS2cpOPkChEeQrx+JaisXJq/5V2Wwt6UginTC/Nlo7HyMz67k6Mtdoxptqbp
         39eeOaw7D4DVmAev5eoKbHJMyki7KhRcsN143HZkKytRUM27iGGrOpFPmpHY0ro5Fk9Z
         4Xb8OW4oUu5N75pXqjq1Ber3x/m82tLsOTYsT+U1xdLQCYjSrHwFE1lQ8aICR7sEseFt
         fLaAgZFwHQv3WCkYAvRvaNzMBNG6YBGyH19vFboPxRAyr3XIA1DGtYXhiTdBpdApBGUv
         ErylUlIkNoi9GAUq4gouvso/QhP5jQ5R59cQ8bMAfmRdVVwOvkdAE3w+597F5lNBsPmK
         eReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754504476; x=1755109276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpzHgd6TpTYvjXVHg7u1dC6rZFfWzZnJYbp9d0+ZhbI=;
        b=MRKyMXMSFs46HSTXDYUfz9clTNAvDQBK/0UawmZgawcCiXUYnV773tBf/2upgFXf1n
         5t7Ai7GIsqBgoiBWbBPl7iOQcO3m/e6PlPHN6MfYtBWiPbyalgHOh4m8PockXUazHADv
         glNJJOHuAKjKZwsp/NI752D9bUn1Kd6HiMPjoP9VtyeQZtl/uHzokVlCaYkXgIR9VbpH
         WosZt8Fa7JTh4BySd4J855WtGKIsSsstU7DXnpaa11f9DjQEXMmmyLpK+7w4HjNb9ikL
         083jqfGppnOweP4wQDGhyutKbiZguvlOcGIKnR6LXLacA9/N+Croia9yGEnNsE6/7UlU
         FglQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwI9eTA1YPuurbnwM6AUmxua48gF3nr1G0ee1zJ6Us9rp3gELhZHT/XbvmCSjw1lNg4U2bfZBMnQ==@kvack.org
X-Gm-Message-State: AOJu0YyKcX5zbpaPM1Ce2V/seP4yf3e6GTu5wTEtHsasSaTXJ4EoCuke
	q/1j0rXtFr3LAsCyl79wClChrPHUi+mxgcpTvKImbfrdF1XC4SKFx4oUnOhTDRvIxq7oQcdfhXS
	MEMa7hxIDCO+Dek96b3TkjWTmq8D8HLksv08hf/88
X-Gm-Gg: ASbGncs+ebtWIEDNAPPSXtCIJKjYxzl417TFtF/RIFlhXLKBHsRtGpfSaqDgxWfiQAi
	TegKQp0eRi7nCxrmpC+8Bg1UHf/qFUH+h966YkjrJfRoEJwycoRbszz0RL0JWYufx/Nx+DQ+yP1
	exESxy+uQ8kso7geDnmcAnVAC5IyvSHhZYLJ0nWkIqVaY8yE7t/ViS5lsu3IemsOBnhcgxO/CrQ
	6zEfQ==
X-Google-Smtp-Source: AGHT+IF/oBk+1Kx6MOGQZ+KRXoereierCI6MIImjRBAfsMTewdOnZY01NCyaNvQxEiMf8qFgK2ouIA3X3qcui1fNVQI=
X-Received: by 2002:ac8:5742:0:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4b0a1abba87mr458871cf.6.1754504475631; Wed, 06 Aug 2025
 11:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250806154015.769024-1-surenb@google.com> <aJOJI-YZ0TTxEzV9@x1.local>
 <CAJuCfpGGGJfnvzzdhOEwsXRWPm1nJoPcm2FcrYnkcJtc9W96gA@mail.gmail.com> <aJOaXPhFry_LTlfI@x1.local>
In-Reply-To: <aJOaXPhFry_LTlfI@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 11:21:04 -0700
X-Gm-Features: Ac12FXx7qPXyaQOngW6323VZjhzisIrfexf_bbuz5pNIpI6czJ1v3UXAemPUJ5o
Message-ID: <CAJuCfpF0RJ9w0STKFaFA7vLEA5_kEsebuowYWSVnK-=5J2wsPQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] userfaultfd: fix a crash in UFFDIO_MOVE with some
 non-present PMDs
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E34540016
X-Rspamd-Server: rspam06
X-Stat-Signature: 5rped19crjpxrkdjik6x53h8wip4taot
X-HE-Tag: 1754504476-667371
X-HE-Meta: U2FsdGVkX19dwoKEkRoObJQiHiw61U7k4bgnLayzk+WtY9FmBVWSMBnKblOiC7JjDOJxSDjb2GlmA9xDKpeS5WzoksHafP+XtjkofKRQW6GvJ0c0v+qX+obdgSoUaG3+giu/VqqC1UgvA/Zvd9kOQOV734rS9wrqRD4r8ugbqob/WVoLDegVCMxkRWmOlRPSpa3EtBm7FG5Sa2U9AN0hZv5P8Wbs/Gp9gdRmM8FUn+e2npqN5CwZXB79gdhOekUlxoF1AdzAzvqrhyEkl+fe3MoJYg7UTr3yWWZTrooGktvGY0197XVpa7eQ+Ee5+t5IoY28aaNpwioUuxWJt8qjumq32emE+Z5NHpNeYw1X2OP2Hk2LQ0OKAi/P7LiNpQaPC71iW1hqk59DKY2SUbY236OltQ/N563YI2DTBh112kJu+TyMdQYfqAeYfX6vCLMw0lZhng/qrVtOeeqcVf+fyPNmiFp1AAVYickIhPnypswZm729DAkHTcl9EQmLjIkeg8DDF/0jGfklZ+bcqKHjDhHfNrkLp4xoJtv06BhU+2xdjkxQ3vXaH4e7f79hqsq8TQXh1psOGlz3lJ02AIFG7Zi6SdYcwcJ6fMCBopxp0ypoS3ziL9l3iigyc2sTL8vEYnll/DC38oLLTYGuLFgOwktCYurhCus+3zmtLmQ4f6eMBhVHpylnj/H6/5QHL5xIbjCfzFA4pWxbxRnr2B8KZCMcuOSBK8VTzka/EKzAVnfm1xZGwYGhBEssAntnpNfg4/SYOEaWc8aChrCv9+09cAXQzRhdkQhpwkWKH8z68NCoe8PXpbeB/4gPXnk0X4qDiSoRUkM+yztbwpaLfgtn9y20hf7lZUEReWougW7ZUga/C7ERW/g3F29XG9ZpcpSfKRLlhgL6MZ7KkfjVha61t821T42dSzRekPCg55DNFlA5CMYLOxFBSTM9YROnYLcdF5Kkdzy/NRr4SClMs49
 ilrqP05i
 9jw3YY5AaLn8zPDHRfNXJs7rfiRrDCnXBOaUkjo5hykSX1fXXHBjZoyM9mVpxrdTZocLLsmHWAVrrc5EF8ajYZsZeBTspTsU0owrbV5LWHqjTwOfrZtiTqLeE9czxzVPxHcaTz3T2su7Te9a4HP12SWmlPuu/ATEWOJ8Ju9jPBagJ2n/on8O0n3I2NmO7poOmKLSV9OLyhGhKIFQFaGfEMU+oEyTf/CLbPaslZ3TQWGScnMtRj8aK/zUvZ+/gsNO1F2WsbQG/O4Tx3kgFR327NJqHAzP8hTnLANRuusNXLTXLBU/uelt7tBLX1rQywqsa8equF6b7By0XfCFvpYqFlm3wtYiBhFxNp00f9z7adwdv+Bbc6fArMbfDsfmN4RLhjjzUYw1sm+0kyDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 11:09=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Aug 06, 2025 at 10:09:30AM -0700, Suren Baghdasaryan wrote:
> > On Wed, Aug 6, 2025 at 9:56=E2=80=AFAM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > On Wed, Aug 06, 2025 at 08:40:15AM -0700, Suren Baghdasaryan wrote:
> > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and =
it
> > >
> > > The migration entry can appear with/without ALLOW_SRC_HOLES, right?  =
Maybe
> > > drop this line?
> >
> > Yes, you are right. I'll update.
> >
> > >
> > > If we need another repost, the subject can further be tailored to men=
tion
> > > migration entry too rather than non-present.  IMHO that's clearer on
> > > explaining the issue this patch is fixing (e.g. a valid transhuge THP=
 can
> > > also have present bit cleared).
> > >
> > > > encounters a non-present PMD (migration entry), it proceeds with fo=
lio
> > > > access even though the folio is not present. Add the missing check =
and
> > >
> > > IMHO "... even though folio is not present" is pretty vague.  Maybe
> > > "... even though it's a swap entry"?  Fundamentally it's because of t=
he
> > > different layouts of normal THP v.s. a swap entry, hence pmd_folio() =
should
> > > not be used on top of swap entries.
> >
> > Well, technically a migration entry is a non_swap_entry(), so calling
> > migration entries "swap entries" is confusing to me. Any better
> > wording we can use or do you think that's ok?
>
> The more general definition of "swap entry" should follow what swp_entry_=
t
> is defined, where, for example, is_migration_entry() itself takes
> swp_entry_t as input.  So it should be fine, but I agree it's indeed
> confusing.
>
> If we want to make it clearer, IMHO we could rename non_swap_entry()
> instead to is_swapfile_entry() / is_real_swap_entry() / ... but that can =
be
> discussed separately.  Here, if we want to make it super accurate, we cou=
ld
> also use "swp_entry_t" instead of "swap entry", that'll be 100% accurate.

Ok, that I think is our best option. I'll post an update shortly.
Thanks!

>
> Thanks,
>
> --
> Peter Xu
>

