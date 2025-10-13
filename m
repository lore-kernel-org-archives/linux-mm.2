Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92A7CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 16:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520AE8E0054; Mon, 13 Oct 2025 12:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D18F8E0009; Mon, 13 Oct 2025 12:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E72F8E0054; Mon, 13 Oct 2025 12:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAAE8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:20:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C173259635
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:20:08 +0000 (UTC)
X-FDA: 83993602896.18.8C7A30D
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 991C740010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:20:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NkLvXPLt;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760372406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sWgKFnXKgddcA8SesxIqcxmzVwUrjw9E9Rc16q4eHc=;
	b=Rg7wRUHOa+DRMQ8d8LUigMWl+U3wY2Dq+5atJJ4ijzdXJ10ISF6rJdeGlZwYjUWH8tAm9d
	tJmzNF0g5Ch7+p6lLdhWh0OKQJWUEqDK5cok/O97lmrajIF5uhGJHhYhjmqsp0AXL9nNiS
	U44WGAEaaucIHEw5Z+Rz66DOshQwrj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NkLvXPLt;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760372406; a=rsa-sha256;
	cv=none;
	b=mMvIbcnGnoHdgGeXEzvbguPdp5DGZ0xvCWQh328V1zWTsiTgsARigHW/V3qIrsNaIIWmzz
	73p/XGkH254D+SmWSSDF+/AIlJtfrt9qWs/jAls787x6KHO4RComI7uXjLxEwUyW4vGNaZ
	97jbSPtxB1Tdix4Lv6MYjhMYcHMSu+Q=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-636535e4b1aso8628925a12.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760372404; x=1760977204; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7sWgKFnXKgddcA8SesxIqcxmzVwUrjw9E9Rc16q4eHc=;
        b=NkLvXPLtoqy64MjlRO6nrrWjGWJDq9yLUCxqZ0sjzCoCdpJFEe/pJdprl5DCsc8F9c
         hCYTFfy/mTQ98FC0lgY+2IQUWSjm+Wmn6q+aIex0sIXsTVoWYAjP9IozVDoDtDP84qgP
         ZceauCJD3aTYRRdJQ0hp5iTzQ7ISVuR3D6ecc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760372404; x=1760977204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sWgKFnXKgddcA8SesxIqcxmzVwUrjw9E9Rc16q4eHc=;
        b=RkTo6YAKO4HafltXCCC7lNJwvQt379i9x7GM4EiJbd27FC/0fcPZ2h7FvGEEmVHmFA
         B8dbTGsHtgVvwPN0KpYoePxhGZVF+tOF9csPMSzxVnpSbxAsiqiDaY3vuEYG4h1g01Kz
         FI/QnCIt2oqEUwa7K8bUJ2+WS1NKM9mb75fKMTGfU0wEC+QFMvfgMhBQ98P9BhOQJA39
         0rhCT6/H+fztzXNB8SSFHyrgwqASFxwji9J04fZHFSe7hjk5W5vIdVUEMADLzAyNJhgV
         O1ws3yhHMGS70CJf89zoTa71cqMdJjLqyC3CJ0zD3I3jNI2jXT5+PZj4S4MEAFHkDGV7
         hwHA==
X-Forwarded-Encrypted: i=1; AJvYcCWsBusDAHHtKevixbe1ybmWF/TQZcOx6+iSINZpZTPtoNg70h8Bx8+m8r0ZIvxOH70UztjJoIM3zA==@kvack.org
X-Gm-Message-State: AOJu0YzfKgVQSqw2MT4TrbUpIoWo08pKfztgdzqM+iaAVJK49oxWLbmp
	oJrdCOm+JxiH+nolV+B6dWo/eVnGte1izKOXFyyT+fRxRx5k0LdA9ZpW9JI9oOUCrO7BnIZMZi3
	d/7Q6PcE=
X-Gm-Gg: ASbGncv7tDK1cUHiApez+rLZBMaMIWGRk/mwhZGmh36dFPqD1VC30i9e3VbucwDSeIx
	JqVpwl8gpZxOUH4+P4JersRx9SSwU86fIoLc32HU9+BucX23rR/peY1hh4RxlfbnKJ1SW91eIKB
	t8AUwttij22Gsag1/zYqv6CS3TWa4zGFBCuVjNUOdUGmLyqPJYQIdLtORKB1UnnHfat5geAwFDM
	am361QV6rYPkkej3kGPPkSpWroLOaQ55grT265jcksNpp9BIrZBSN6RzD8QdwZccwIOqEBYMWLx
	jFmyGOQ/AnK8YUCC2Y6BgTJAwiZiXuQu+joGGZ0zaKoAPw0rvrt1xuyuwYaAWe7DX+jZroQnO03
	YAm/oZuEqViNhIm4UDSOchTpOiTrWJB/AKV/EQ84fo/q+L0J8hsV3G4v/OMnUS7V6NcgMdanAee
	/H6k/F7qC/y3xDXC7QnSW2lB0E9w==
X-Google-Smtp-Source: AGHT+IE/5V1we7mjfSltph2PB14SkEdsf9YF6/SvnBOx6HQEtExLI6O1owR2JQ+Vi6vr3EjUTpbRoQ==
X-Received: by 2002:a17:907:c297:b0:b3f:f6d:1d9e with SMTP id a640c23a62f3a-b4f40789662mr3068608666b.6.1760372404491;
        Mon, 13 Oct 2025 09:20:04 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d9525a29sm941505066b.79.2025.10.13.09.20.03
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 09:20:04 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63a10267219so1613864a12.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:20:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXJUlk7kT0b3Ep5Kme5PsRwOU7LuN5T7b38DVIw/JS2t8/T4NV5nTFMi3ZF9s/EtPN6Y5UjoK/xzA==@kvack.org
X-Received: by 2002:a05:6402:35c1:b0:62f:1366:46e8 with SMTP id
 4fb4d7f45d1cf-639baf075f0mr25361887a12.7.1760372403624; Mon, 13 Oct 2025
 09:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
 <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
 <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
 <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf> <dz7pcqi5ytmb35r6kojuetdipjp7xdjlnyzcu5qb6d4cdo6vq5@3b62gfzcxszo>
In-Reply-To: <dz7pcqi5ytmb35r6kojuetdipjp7xdjlnyzcu5qb6d4cdo6vq5@3b62gfzcxszo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Oct 2025 09:19:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgrZL7pLPW9GjUagoGOoOeDAVnyGJCn+6J5x-9+Dtbx-A@mail.gmail.com>
X-Gm-Features: AS18NWC_26IcmmEQwm0Kzayu0MFl0jqhPq6BKmyAI8MXuCaJVEX1viMlot--KWU
Message-ID: <CAHk-=wgrZL7pLPW9GjUagoGOoOeDAVnyGJCn+6J5x-9+Dtbx-A@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rdj31xrboi6okdai75iabtgqdebeheur
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 991C740010
X-HE-Tag: 1760372406-839806
X-HE-Meta: U2FsdGVkX1/CY1WOUT5bQktICxDtnDkvkNIwNqxdRAQUpA/Bc1DeSXZ3y98dezAYYmncb9UorgdFc642kBu57qrV1mxwfagN2U8t48eeJ6TO0xofIMeRnn+n5SlbEKFO01E0B/D9xIvwe5E5a3Efg0CDFbaBqA8f4Scm5jMaapeF3WVMZuUpHzoYhT3y2zlGVNoAkmbir7UbHKXlYWa9HkXr7ubdrndS4B/dOcHi15kH8/JSPysUMiHGF4WzpC4Iu5uKtW6K7la205yzeYxcG3xPyJCyZGvXT86JRlElTxvVg0vn/evW5pJ++gXG4eLikDaDAzOmrhBtIy9kZQtueCn7zmIzmNTg+ZynZNQnUbf81xH/GAzmNgyR7x/URNunFKvEnJ9hGxEsLIddIIOq5pQ4vPqxYG997qzbAgTAdCjT5gxCDtz8pUw+G9Ka2usAN5/iwgI3A+4cFB8kp6dxwx11qKhRacJ2KuakaDtpYkybkTHtiAjOuVrwchuXYbqTr1ESNoBTTZbeenMMgIDoNYaVZnhncEbP7rGCnlIPxIFkuX/7Xyong8rIGWJMv1xbR87+bVWnDCoUiQdvOhkyHvvMnM8o6/pmAwClR1Hlj3wMtlvBviM/OStGpxS5XKhMgK/cjF8m6U+ljiX9fhi46B6I9fgPFgWw/1FLVz4IPv17bjDVEHA7GO3RG3ThblnzNLiqQJ2Hi1fR+0+A69WBqSpmQ3GCeVGJtr2TDXDcim7oSFwbd0s2ThqnM5afqVWM/qF9HTJQb5IuVUr+zpvkolZWakPvsL/DQtziudf93ZEuWv8ynuVpKsyQqimXfuyQ9kGrKgLOKYNN/dW86m//r05+yiFbEYtIHxbNraH58N/iKmctwtPOPAJPyUiGZZLSIC6QLXc/4+NHFeOgXN8WGVj4CBUtwFKnv+NL9bnhg7KDEoFHJnsSE0XVcHd+AtOC9pYbsk96eZ60JCcGmWG
 YRHhzoO3
 lhFWlyZfA13Lzr2bmt3wTm3UTMI1B0g1rHdDXDzqdmdv4FQcYkNT9m6ec8yJlYxNQvC2HqnLvRt7BhlvUDUc9CuMm3bm2jqp4Nr7t4BQ1uzxyLynhpsXTWQRrPm4Mfc74YxlWoGdTb0T4lBvWosAiXddbyP0N9TqVZMDWF1i7JnIXSNsRVBGCJe4PL2J+OLy9fL1wK30zxvqBYOVfU8t6v4wWWcft846marc8cNhT79aFlpjxDmR+yVGuIvefqpZIf1O26sy5QyRn+W/HKAgbiqZJ2kDUD9FmdOTFmea4EodKkdE6padgFXrj0zYhvp23jGR5sQZO6Ygog4TgoZRQHCNclpoURNsOLXZXxXCaWQXx7+7IKHuHEgi53Xp2bhZoo6oSQ/Lcl5jpdx2y1yT3LQBv5Ykuc5fkI3AzOYqAllTeL2SlhLJmK00wku37ly5wWytRy/umCaJNNHA49dxf4PBkmccX/3yIJeSYHXVbLhsnMNp0l0z4YmkK7ciLTjBWHqc6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Oct 2025 at 08:39, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> And, for archiving purposes, here is the last version of the patch that
> supports large blocks.
>
> Do you think it makes sense to submit unsafe_copy_to_user() optimization
> as a standalone thingy?

Without a user, I'm not convinced. I think right now there are zero
cases of unsafe_copy_to_user() that are large enough for this to
matter. It looks like we have exactly two cases; the readdir() case I
knew about (because I did that one), and one other user in put_cmsg(),
which was introduced to networking with the commit message being

 "Calling two copy_to_user() for very small regions has very high overhead"

so that one is very small too.

HOWEVER.

What I like in this patch is how you split up filemap_read() itself
further, and I think that part might be worth it, except I think you
did the "noinline" parts wrong:

> +static bool noinline filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
...
> +static ssize_t filemap_read_slow(struct kiocb *iocb, struct iov_iter *iter,
...
> +ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
> +               ssize_t already_read)
> +{
> +       struct inode *inode = iocb->ki_filp->f_mapping->host;
> +       union {
> +               struct folio_batch fbatch;
> +               __DECLARE_FLEX_ARRAY(char, buffer);
> +               //char __buffer[4096];
> +       } area __uninitialized;
> +
> +       if (unlikely(iocb->ki_pos < 0))
> +               return -EINVAL;
> +       if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
> +               return 0;
> +       if (unlikely(!iov_iter_count(iter)))
> +               return 0;
> +
> +       iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
> +
> +       if (filemap_read_fast(iocb, iter, area.buffer, sizeof(area), &already_read))
> +               return already_read;
> +
> +       return filemap_read_slow(iocb, iter, &area.fbatch, already_read);
> +}
>  EXPORT_SYMBOL_GPL(filemap_read);

Look, the reason you did this was presumably for stack usage when you
have a big 4k allocation, but the part you *really* needed to protect
was filemap_read_slow() that then has much deeper call chains.

So filemap_read_slow() should *not* ever see the big 4k stack slot
that it never needs or uses, and that eats into our fairly small
kernel stack.

BUT with this organization, what you could have done is:

 - don't share the buffers between filemap_read_slow/filemap_read_fast
at all, so the 'union' trick with a flex array etc would go away

 - both filemap_read_slow and filemap_read_fast would be 'noinline' so
that they don't share a stack frame

 - filemap_read_fast could have the on-stack byte buffer - I think 4k
is still excessive for on-stack, but it could certainly be larger than
256 bytes

 - filemap_read_slow would have just the 'struct folio_batch' thing.

Anyway, I think *that* part of this patch might actually be worth it
independently of anything else.

Of course, that re-organization does cause that extra level of
function calls in order to not have excessive stack usage, and the CPU
errata can make 'ret' instructions expensive, but whatever.

So I don't know. I like how it splits up those two cases more clearly
and makes the baseline 'filemap_read()' much simpler and very
straightforward, and I like how it also splits up the stack usage and
would make that union trick unnecessary.

But it's not a big deal either way.

                Linus

