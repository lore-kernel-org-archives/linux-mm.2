Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCBCC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143B96B007B; Fri,  1 Aug 2025 19:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BEF6B0092; Fri,  1 Aug 2025 19:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A186B0095; Fri,  1 Aug 2025 19:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3E6F6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:47:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60357111A81
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:47:34 +0000 (UTC)
X-FDA: 83729828028.29.946F2CB
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7110DC0002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:47:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OmKXsg3k;
	spf=pass (imf10.hostedemail.com: domain of sudarsanm@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754092052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLLO3Loo8NOpKwYsGoTU4cHzzMMA1rAQdIDBIoGAXoU=;
	b=X7Z2GhFJ/VGFtbUUK0hTnAWr0/Nfl1F8xnZkS0WKFbqRzKDL7YQk7xwmCRRSV8TBDK/k4c
	O5vkQTkno3OkngKihqm4uKUIJAzo151G/ZKLR4i0WjmocT+BbFOPOOGhHZ7mfh6OSLCUop
	EC7494zM5ZbSRw4iZIbjy/PJUVE61SU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OmKXsg3k;
	spf=pass (imf10.hostedemail.com: domain of sudarsanm@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754092052; a=rsa-sha256;
	cv=none;
	b=XjJp2b/sVCQRX+w7k4zA5pWOZuBQNNUkrukP7LlKV1jU28DIblFrz1Yref/cvGzk/q91Yb
	5LAoloduLsGgU/MXLjnCJ7VMuhL/hu9imvuL3wnrzIt3NE5UZuDXm7D5XDmqKLaDC6VUnM
	dilQY+uAbcIg0lZOD8VzPnckLJplbR0=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso15327955e9.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 16:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754092051; x=1754696851; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLLO3Loo8NOpKwYsGoTU4cHzzMMA1rAQdIDBIoGAXoU=;
        b=OmKXsg3k0hyVxiu5+HTeCymYnqT+lBYM7JXQj6Fy5oKAHBwYVvuTJRU4NHQzRClh7m
         BUGRUkqZTK2N8AcjOKSXnGKozQfWE3dvLyEWioBF4+tF4i77T+PrrswdRrglLfGa7wAp
         UzvIYSjJtFdWyt9nyELVElYcDh7LwFzfxZT2DLvJ7T0UIjChhuZj1m4POIHFdGZud7q/
         T3CZO9sJeYTYOl+L+emyPNhvzvIOrmzBcBiwiVvWWOuHRAR2NYIW3uO2jtTdmPHseywQ
         kVk9lfmhXJ5kQjtBw0FQA4MByjyX1zAkmbqMQjcIjAcuCEULAG9l8oGdQXOGNsz0p+RX
         1zEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754092051; x=1754696851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLLO3Loo8NOpKwYsGoTU4cHzzMMA1rAQdIDBIoGAXoU=;
        b=hb9GNU7e/6gapcrBUQNo/AP0UUPq/Vhb0abPajdWagLcuCm/zA6+B4mgKtl4xUYcAl
         dErG0zmOgVgiHSCieBB23uICxNc2xk3SGRXVIXh6jMeqvLrSxm1UI1jTu3aA0wyLhld7
         tk2kzil235qMnj5XU3IPMEtb/tdFgBltNbfh4pBwQRDFQJ4YKMIEkwbsepgoBUVXD7hT
         KXQfqLhqK22D+phLB1UIiFJjmmNMz7pe6D5FbrJrqxQ+ZA8WYNdZePZDU/T12Bt8Ydqz
         iAYGL1fFsG6yPITlkrjU2MfTbYl5AOMtFB/CJi+oSfjuYyp95ajLk3dYxxxL7PcFfc9i
         tTmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8IgoSv/RzrMIXqlg3QshbMvKLnEFHbSR51TroeRQ1ikUoog+VM8AZ7RJ9BieooqHpCq+S2MwXkg==@kvack.org
X-Gm-Message-State: AOJu0YyryTBYPhEVTu0wy0w/0utgVup3MmFuBM3uRxgIMKxEgP/lhMd5
	o/jkAvpx/82A9yjXjH5UjnsRdfwp5WILTMGbfTIqaS95lILnrnwLUsANn2KnOayLJCxgJJfHrv3
	gIfgJYtq1ggDpExIB96QhIWcHKgUyEmdx2B//0yF7HVn94zy1tFr2rYUM
X-Gm-Gg: ASbGncuU6dcyomg+D/TToaPga+AHFHOZW/Mjik4ymnCt06jWfIved6bL/uIqXEOdgnT
	PYKxM9QnhJHBIQN4N7tcjuqo13/g5Jxju2pGCf3cT6iiTeHHDpsPljfkdyFrMOLEjMChP3+zdi7
	Yjjn+MR5J0NzPQAxUbZJKOJMuxxVx8oUKo65gChIF95tyD4s509Oe6bLI398/ZHtRbMlyxYSII1
	98oCeF6y62OnqWW9NE=
X-Google-Smtp-Source: AGHT+IFkeHX4fAYS31tnOgYxHE/1DKhEFnFigNT0fo/cE3XhN1SqQzHTWnPZni711yFy+uoLfpt/atMsuAMyUTuzXXI=
X-Received: by 2002:a05:600c:3b87:b0:453:c39:d0a7 with SMTP id
 5b1f17b1804b1-458b69ca0bbmr7346065e9.5.1754092050770; Fri, 01 Aug 2025
 16:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250731201009.888945-1-sudarsanm@google.com> <1f95e865-ee09-4ddd-b6db-f2092f0d4b10@redhat.com>
In-Reply-To: <1f95e865-ee09-4ddd-b6db-f2092f0d4b10@redhat.com>
From: Sudarsan Mahendran <sudarsanm@google.com>
Date: Fri, 1 Aug 2025 16:46:54 -0700
X-Gm-Features: Ac12FXzWnMVAHJwon03ldywOBfIPOPXOVgEKP6J99gC3GAwOhyQE_8UHwRC7IeE
Message-ID: <CAA9mObBMtE=w=PS8NpXsrHD5rs51pkDAA55Fi1dB0gCXwL9n+Q@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: pass filename as input param to VM_PFNMAP tests
To: David Hildenbrand <david@redhat.com>
Cc: linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7110DC0002
X-Rspamd-Server: rspam06
X-Stat-Signature: dbiwafu4iw7ujzme8s8bnrxy3hcixxn7
X-HE-Tag: 1754092052-258974
X-HE-Meta: U2FsdGVkX18nkZuaHKSOzB4+zvQ27nmvNG5UwwCNS4bRXBXt9KMDMrta6jw+E1yCmXhCiqDEcua8+XVecmNwXOHq6K1spmPxV1DkC80NNKsiKHXuq2n1O1TelztJeAyGWnL8jjwUF1pqjNwQxclRjNi32vOaImEwx7hxHcbGvzIq/EOIPE+cs01Oq4aGAFtRtRAub4w5QfhT10xISGIVSSSxytQ0wv+L7VYPQZ9P7/R73fnZxG1L6AUlE7Mb9gaTfkwNzNebYY5GG+cz0amY8GEJNi0vE1yJJXdddnDoDEo0gR+iBnoDWIr3ef5Ff/1Wp/Lqf4gfbIv+rbkAkeg1f/GhvJNQ21H03vnTKlJPYoIzKgMnusjuAu93byDd2GtsQNmGVg/tGuksBcCkclnOj5+gg2tqkNGviAv+u7y6C234Kla0UAt+0TYpCwZKoXE/7seEwCFyxwgquax0Y+FgZv3YF9KmtgF5SsMgjC1aBJ60nnKlElma7JXXDg4qZu/EEKpMVvyV+Zu5RvaUL7CZrqq230MYe7sC5UxQLqfPq5YPm67MInaQwLs821bj7puohTBsd33ljRr7ibFPEyjiFpC27AKdyr1SEcZvcnc5CnQ5lxVVlupZL1Fqj8Z6xeDiNjFasmHVu2hNsLQoiyTniGM7GbnKaD863EnZEohtLte2+0j40bCzZpu7s0gobWNpIKLUQupTwsNGlV8exCLzQZMBBhuE+xWDOHkkScOx/Rxd7r7Fa+rWQ0HDC6vJMojeWjEUrppt9JRZCTLme8ojPlfJK8k0MW9NArlS1trqWwDCBQWc9MS8Yg8A7xMR9tkPU3WrqmQ5MvOsauN69m4pFrZ3w6yW7htXYNweZlDcLvOHX/5KusrqBGlBHbe242+xqNc/KL2RlxZR8BD/Hfbt+pooOpauG3vIdfl0DC1CuOlKmyzmgmHOQyXtKLCVk5jLelJJNePE8+1ks2RD7hr
 22CuKQyV
 clnPWXhrgTlJ1gkP8f6hK1afU1UDSkjk9iMWXL4RgG2CiSEDJCS2SAr5qU/nZWcJ6NS000B5D3aGzsTPGzHGUjL6S2qToH8uDFAX6TTBA6mwJSfIUs3+ypC5BEJ0JS/miB1W5PKDDWKdvFi+qObnJxlct6WycHgy6SfR+DFJRds4EiEMb3LRXos9kvv5c7SnVD4wN0j+oi6j+aehFyybRsPS3G7hon3sh3l5eGGkbJefLZNiU3aXefrY/o10PNJ5KyJ3Sv41IBiU8riQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review!
I've sent a follow up v2 patch.


On Fri, Aug 1, 2025 at 12:15=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 31.07.25 22:10, Sudarsan Mahendran wrote:
> > Enable these tests to be run on other pfnmap'ed memory like
> > NVIDIA's EGM.
> >
> > Add '--' as a separator to pass in file path. This allows
> > passing of cmd line arguments to kselftest_harness.
> > Use '/dev/mem' as default filename.
> >
> > Existing test passes:
> >       pfnmap
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       # PASSED: 6 / 6 tests passed.
> >       # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Pass params to kselftest_harness:
> >       pfnmap -r pfnmap:mremap_fixed
> >       TAP version 13
> >       1..1
> >       # Starting 1 tests from 1 test cases.
> >       #  RUN           pfnmap.mremap_fixed ...
> >       #            OK  pfnmap.mremap_fixed
> >       ok 1 pfnmap.mremap_fixed
> >       # PASSED: 1 / 1 tests passed.
> >       # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Pass random file name as input:
> >       pfnmap -- /dev/blah
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Cannot open '/dev/blah'
>
> Now, if you really just pass a random *actual file* that exists, the
> test case will not actually test what we want.
>
> Unless you have a way to verify that you actually get a PFNMAP mapping,
> this extension is questionable. It will make the test report possibly
> wrong results when wrong files are provided.
>
> I think we can test whether we get a PFNMAP mapping by looking at the
> flags in smaps output ("pf" in flags), so I would expect such a test to
> be done in pfnmap, and the test should FAIL if the file would not create
> a PFNMAP.
>
>
> But more importantly, we rely on "/proc/iomem" to find a RAM target in
> /dev/mem. That doesn't make any sense with what you are doing here.
>
> If we are not provided /dev/mem, you should probably try mapping offset
> 0 of the file.
>
> --
> Cheers,
>
> David / dhildenb
>

