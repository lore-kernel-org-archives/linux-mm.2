Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB12CF3972
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275B66B002F; Wed, 19 Nov 2025 12:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225E16B00BB; Wed, 19 Nov 2025 12:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163096B00CC; Wed, 19 Nov 2025 12:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0511F6B002F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:12:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AACCD1605C7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:12:28 +0000 (UTC)
X-FDA: 84128000376.08.900CC30
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id B39B540009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:12:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=avDkQlxB;
	spf=pass (imf27.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763572346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lttwGYno15TKpeAV3UohAgRcGG4eYP6EQ60N4Vw7zBA=;
	b=IBckDLVTVGNnxM6KzrYoayRiGZpy3/dAkbnQhLtQFXPZxKFtob8pNMgZg5C49jvRewTimM
	Bl/5Zh/gKb1lKJfnQ4ccsdPWyiVsQvlCzpCScIiYlDZGtUTbA6QC71gCaqZSIZxw+ELMZF
	qR1GJWo9+s7ymKc9GBohjOz5utGPOzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763572346; a=rsa-sha256;
	cv=none;
	b=6BOBy5DRR8vowAhfJf+9th5UKfLl5Z2iJIGNIYasE7hSrRWbjaEe77iPa3VNFjB/PnbWje
	qprzctPLi7ODSLBneBCnuwNwGyucWhWno6fdiCnbIIf9EPqfdtwYOwlAuMXe54U4YFQKXU
	KrsCXES5t7hVZgSh6JELu8frGGXkwDU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=avDkQlxB;
	spf=pass (imf27.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-343d73d08faso974727a91.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763572345; x=1764177145; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lttwGYno15TKpeAV3UohAgRcGG4eYP6EQ60N4Vw7zBA=;
        b=avDkQlxBWM271/eFQOCkWrjZa0DIHiX030xZMsmCglTsLlI/L0XTj0nw3XloA4Kyxq
         fXpVYXBghOGnL11k47m0ldNHbiEzaZsBnAoZz6dOccxV+DapUrK+2MgpWc+QYVByfsBF
         NPzygfVIY3kDcImEqdtFAglJXFnF25iBB7zLe59iYUayt3WlebTres2/62thtEje14vb
         yhiXrbUEkKQeF82QXkXBLyI9XPQLg6ziPXXfgafyiy87svDTd7OGMoDF8UlD0EjFa4kZ
         ZQFwKW9Bt3G024u8I1EXN4kMQUFACDIauUvu2J4HMi4LLaByE4RG6WdnWyFKBqGP1zGh
         yJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763572345; x=1764177145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lttwGYno15TKpeAV3UohAgRcGG4eYP6EQ60N4Vw7zBA=;
        b=cg1N1cycyuLH+OLiOrnASZTttfbBPh3Fe/7k/rkD0cdy95mHgHz8KqaN7XgCPweyJ2
         infZHJglrkBKoQ37cY5D1gMi7A5OWvFF2Dv5jAuesYcL3qYog3yFzYteXdnUcE+dkTpT
         ZXHjbaHq8orfbNiX9t55EIWy5G/ZqHb6fYtm5kLdfmnR68WKjD6TW/NRoarLfzSdpD3/
         Aegm/qMcxAFZjiqDa0FgJm+UDr3YqTYzn0GzYI0n8sGKH56rG1upyr6wcyifWyJI3i5A
         AgOLldpAydbkLhj6KxjOiCJ+3tQjD5EkHHTTfPZ3ASqDxsM3sV+Ee828Ubwsa6K5+ufY
         gzFg==
X-Forwarded-Encrypted: i=1; AJvYcCXpdLIoBGWSk961VnACwuG/yyS4ZduhhLABjLN3fETYS5OGPUXY+Z2UHAJqxgjpR12XjsUyo8o5qg==@kvack.org
X-Gm-Message-State: AOJu0YzQ82RRCwgKnkBBxIxI4vgOzJjDWMWJf9gAuY4HgeOraN7qJEfu
	LDy019il9Vwc/ohkIX5zwbvmx88AiCU2ZgWuOu0FVo/CdkDg2kTfgI0q1wJSeafcTrTu5yedA4b
	B7bgNqI8W8vH1+tnAO/7ZQACjNu9FxIU=
X-Gm-Gg: ASbGnctMLEPZ3XUqjlItnwPKJTWBLD0qyX4ZPbxXkGXB7Z3Yr4dacX8mmDBQxm0ACj3
	uRtZkNgO7hARJUEJxKUg+eK/hZoLnMD969aPX/M0nLzchnen6E5FqerwswVLjT67n88H3ZRTE4M
	1/l29Yl1EkAPXCL+DS+pSxRcXWEh2HQsjytkE1iBhXPMH/4HSTXFG7eelN08Fq7KajXqJB9lZGV
	xLDio+bsss1B/xHQtmHXpptcNpHUprkgIQmFj43dVre/v6YyErFMRAKIbNonjSnKij/fA5+CX8O
	xkV8eZv4LmUp6yQC1Q+Fag==
X-Google-Smtp-Source: AGHT+IF9TqhCM5sftaGQEl9XduGer2CQZxEu8IUrH3eRt+kYJfd47IRIpaKq9Ngl12wdt9H+9C14CbQPOOKDWoLkN3c=
X-Received: by 2002:a17:90b:51cd:b0:343:7410:5b66 with SMTP id
 98e67ed59e1d1-345bd1fb660mr3491803a91.11.1763572345294; Wed, 19 Nov 2025
 09:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20251114193729.251892-1-ssranevjti@gmail.com> <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org> <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org> <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org> <aRySpQbNuw3Y5DN-@casper.infradead.org>
 <CAEf4BzY1fu+7pqotaW6DxH_vvwCY8rTuX=+0RO96-baKJDeB_Q@mail.gmail.com> <aR1awLOhdOXNMl9c@infradead.org>
In-Reply-To: <aR1awLOhdOXNMl9c@infradead.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 19 Nov 2025 09:12:13 -0800
X-Gm-Features: AWmQ_bnhWvlGu_up0m2ui85unGpA2DRPQC9h14GAV7wAvQEwMdsyPJvZ2JIRYok
Message-ID: <CAEf4BzYWBUE0VseYgoa4r+UndxiOdCWazZ5FgZxi=dfhXaM16g@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org, 
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org, ast@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B39B540009
X-Stat-Signature: muzcf3zem7h4jhpk8of7qud3fmz5osdn
X-HE-Tag: 1763572346-905006
X-HE-Meta: U2FsdGVkX1+QfvkEQp03XUE/nOBRmhBuRP8PAVKKnl12KE5NM2tlfaibQFDos38mZH3Qwn6lzxzUBdWN6A1INx/PkT2ladnqL9mS9tvdmMbfJ3tB6kzsyda6HTS23nLSTX+jsHgcss+M94K0/kOyGHJdEDN/ulcon1/m6rrXq4Z7+FGBsNiWU6cm1mGuMQZ/f8yvJPAjqltSD0PDFA4fOJ5AdNGmEaQwBp9TJPYM/q57bC/1LYCJJR6thcDYdJqPc5B15eiv38xBNyfrEpxG4FFuDxJH6FxgCXN9P3Ifq+MVCNyDSyVZD8W1qaOrdX8MmDtjvPo7ZUZWNLOW96X/ECw48nmFeoAiL2Ocf84ZYcM9Q2G9cxogEzbvD7HjI0qrd64hjjNiTw8dOT2ARr1nCPW9N8E9kV43zTzYOZqOlE7AeTZt6iEsff4fltbgaeHFU5z60LCAWKbWmYbo89C1pIrc5PiahuciUCQoiG2SPGyFdI09i07fm0Ftz/L7TOAsUPvRA4rn2GGUTDQNbSCI3sg8Ng7bBNICYwtlNQVD3hx9nGyEBAZ2GTKlM+pnHN2Fm4QdjNZWpeQsf4xBd3KeWfHKEuj6VzWnNF3kCNjMr3vSFGI9CbdkegMTiOSGK2jcl9G99KYqs9UpUPH9Na+w2/sSJRbGiYB7pewnfevxF6n8cN2pcahPtUpGEQYwGRTJ3epx3UJZ5Cs0paxK4pauCd78NpYRBPFQsr1P4PrzRfwVR+EoS7QA3de5LAWm9/VliUp7bQEmr2j9kacGBtWFKlajrubJ1WBybBKSl/Xkpv7euS/KdQ/V7dGQVGTORIMDlLDoQwTMCCaFaYQRgT7CFfbHnx9nAJOb4GyIe8pk9CwguIPIro67Pr8Vn/Tn1FpbT8IhtRIsHUnF1Y3QZgW9n/ca0T3PXqX6mlt99e65p9ANtuG32P/MMDR/qiONDLxb7KgeXAq2dodZQDb1ay4
 S0karPYX
 wDV+CeAFKup52RvaefSHgIItsR5mcE72FLn/mzst6D0MU+kyS/Oio9oTvTTf8WmMHa52CwF8wfUMrKTunUeYqidBeyjjadiR16b7H3K/fuRPL/Re8pFdVO/vkz/Hv7qz75fCyms2kkhnKPq4fGoGlv7Gqr96PvAx+8qWHMHOU1NY5buy1NEcJzAjJlsdwmM1uhMAHS+oUwjCsro9Zis1AFhU8aLopKXNE0e1rX+uzFD61sTJOYNLfB0FLy6FlNMKtQcU3BsLf9/zReOsryUoTgtJomBcqQYq4KdHL3iw51xQLh1qPb/JXAIQX0JYoHJTY14yvC3kLG0sy0Rscq+6NUSTWlUNOK87RkA6r9QfPodiQ0BkCoeLz8wUjpvvQcP/t1ULoay597ANCl7ngmSag4F75adPwSR+lR0PgTl00Epdxp/pSzqHOvIBLKjAbdK0khPth8pBBAEot8A9YNvumVXO9YzmfS2Me+YXDWdhixFc/rh3yvHAcZm4ho6t/hXYYrpNwJ16ajvGWAnlFtgW2yytJbkthK67636cHTkgdYO3lWiEiyTghXELuCoXCVd/jX4M/xhZI5m1M/W5JFlRsosGorVCWLMlDWUYVOtw14O7QdUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 9:50=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Tue, Nov 18, 2025 at 11:27:47AM -0800, Andrii Nakryiko wrote:
> > Then please help make it better, give us interfaces you think are
> > appropriate. People do use this functionality in production, it's
> > important and we are not going to drop it. In non-sleepable mode it's
> > best-effort, if the requested part of the file is paged in, we'll
> > successfully read data (such as ELF's build ID), and if not, we'll
> > report that to the BPF program as -EFAULT. In sleepable mode, we'll
> > wait for that part of the file to be paged in before proceeding.
> > PROCMAP_QUERY ioctl() is always in sleepable mode, so it will wait for
> > file data to be read.
>
> That's pretty demanding:  "If you don't give me the interface that I want
> I'll just poke into internals and do broken shit" isn't really the
> best way to make friends and win influence.,

Did you read the second part of my reply? The functionality in
question ([0]) was developed in the open, over multiple revisions,
with both mm and fsdevel mailing list CC'ed. Matthew Wilcox did look
at this, provided feedback and suggestion to use filemap_get_folio() +
read_cache_folio(), which I did incorporate.

  [0] https://lore.kernel.org/bpf/20240829174232.3133883-1-andrii@kernel.or=
g/

>
> > If you don't like the implementation, please help improve it, don't
> > just request dropping it "because BPF folks" or anything like that.
>
> Again, you're trying to put a lot of work you should have done on
> others.  Everyone here is pretty helpful guiding when asking for help,
> but being asked at gunpoint to cleanup the mess your created is not
> going to get everyone drop their work and jump onto your project.

Gunpoint, really?.. Am I not asking for help to improve the code? This
functionality is being used, and we can't "just rip it out" as you
propose. Let's fix it instead.

