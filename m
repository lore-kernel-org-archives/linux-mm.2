Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9DDC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CA08E0014; Tue,  5 Aug 2025 12:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CC98E0001; Tue,  5 Aug 2025 12:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B358E0014; Tue,  5 Aug 2025 12:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDECA8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:52:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93D3856D4E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:52:00 +0000 (UTC)
X-FDA: 83743296000.28.B2242C4
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6534140002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:51:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bM5r1Ql6;
	spf=pass (imf23.hostedemail.com: domain of sudarsanm@google.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754412718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdp2THZ+E1qrWvs/TZoDbRRKtgHUJqw+d2seDNABwpY=;
	b=zJydvPh5KWQ1dTa9k4G/pmLAvUM7ChT4Ee1EoeDgHhdVNfx4YjYiq1RolJ8hNtCI0D3YoG
	DCJoEAWdDyc3scs2t8JVxlHEsAVY4Gt9sV6X4wvSpMjibuOPcU4exLsHCvf3GBfrMbzbwh
	I0OBP05jMbI2JGLiySVvaCUy+GalI+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754412718; a=rsa-sha256;
	cv=none;
	b=xxptQx0l4Y1jlxMk+sYKZYu7GMHIjFCAKQ83FZsX7w4vTmhOwd6cbPrTgZ0/ddzEXxE9Ft
	1VasdQiQZoBClkIMkcb38/ecaYBqIYq2kM09MAf/ufBR9UQRxaL0OzTYabyXcvzNeKRSn8
	DtFWqSI+d97s6HieJjOAopl1wpCRz6Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bM5r1Ql6;
	spf=pass (imf23.hostedemail.com: domain of sudarsanm@google.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b785a69454so2880032f8f.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754412717; x=1755017517; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdp2THZ+E1qrWvs/TZoDbRRKtgHUJqw+d2seDNABwpY=;
        b=bM5r1Ql6dL5202cxvEcFXTUUK5LX83dEnWTkwMM9avwPNVyibeAs0xoYBAyihEH28G
         DpOtkrWoPFo/VnPiJ7TyczPn/xYH3VbIFu/+qbRae84W52jv3kFu1KR9wzYYgPlDRGpu
         AqPnOgeutb5Fu3r95/BuGAIiIop72wNRPuULnf6NtlHX4XWdcxyijqnXjQoMT5JhC/Jl
         7VEAiFspqkHI/9By2uzbXbq7AV9LeIGEX24SJohVepLL196J9mGz2DWY04BBLq7tpkDG
         2Q9XW7PXhWLUa5Lh03H7FixrfxME0cbNibpvzchhhIPeg63NkEvaDFMeVzGrvacMuH7s
         b3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754412717; x=1755017517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mdp2THZ+E1qrWvs/TZoDbRRKtgHUJqw+d2seDNABwpY=;
        b=ff8OfYojltbq+l4caZSQzoIRyFBk8E5FT3QfR6qnoS+FtcDOl7Z6rpfXlSxssC06n6
         F5d7h2g8q86tMBdfrrNJ3WDV07l02Pgw/rnIyElF1nRz08ErAjvL7JbfRDy/7BgMdyI0
         5MoKUpebw9Hw0L72NQNwwkmiwaTaGLP37XmS2X6CEn+GjrmIDZVrYVeddVzOmsTCLofc
         FviGNeWbslPOvMCRo9UYeGqot330oucWHxKfB49OyJMD/9Hpm/WUbb243cNh5fu4+omB
         aVhhakxpZ/95iBelFhJ8MxsP4prFjCaAi8PkU7AINm9Rn8z+/2R8Olz3B0umRzFZLL9p
         ZkRg==
X-Forwarded-Encrypted: i=1; AJvYcCXbmGeOPNAzfC6+vs0UxXneU3aYXBA19esa2okYqm0kP9eyseb8NuCPLhgxCyPAczZHzOuw3axCZQ==@kvack.org
X-Gm-Message-State: AOJu0YzEMG8zI2tC+tH4ZknSUB+uDFV/UkyQGIWrbuZ6BAT/5yRKJp7j
	scz0baS0Elwi8evcMd33dxHtjAYEbBntWuD9rw13YEUUmnI6toQ+DFmMLGDDNzZC/eW4HCeSbFT
	lvHIxJPieGl/g56KZLpCJSTzZapE1bAKMLpUHchYf
X-Gm-Gg: ASbGnctUTa01a7qY+4VxBWQyV07jTYitzAXFcI/VXICEumVWdlI2OPhsd06QXxs9L2u
	Ap/7cczy2PHkgiNN7cCWGdouV0s3FjzUqwufkMYXTGi6JHZFR5KCM8etdxJfXyKK53j/v6ExAA2
	O6bkj6ww6att7Cfyz89NttK3hTvVK7/QDQvjHkZQNbwwIP4U5LGLcUN106REJp7NLuNxd6hIJGP
	oX04bZ6
X-Google-Smtp-Source: AGHT+IGCJi6AAfzPaIlWNF5t//K43GKbKBI8wrg/kqvHP0TtvUzS781NSDVS2jaYJIrQrznLTHRuQGhHzTOhedemSVQ=
X-Received: by 2002:a05:6000:18a6:b0:3b8:f356:a2a9 with SMTP id
 ffacd0b85a97d-3b8f356a2demr395048f8f.46.1754412716960; Tue, 05 Aug 2025
 09:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250805013629.47629-1-sudarsanm@google.com> <24bbd9df-efa7-4090-a696-1eb40904ad85@redhat.com>
In-Reply-To: <24bbd9df-efa7-4090-a696-1eb40904ad85@redhat.com>
From: Sudarsan Mahendran <sudarsanm@google.com>
Date: Tue, 5 Aug 2025 09:51:19 -0700
X-Gm-Features: Ac12FXxbwVDLUIinZ5AcPHR32UCRbFB-2WNiOt5M-pCIiVirC4bpkJyI48QVUN0
Message-ID: <CAA9mObD9zr8Y8Z4F7OZGi_NiPfSZxUu3gKNWPQYRAeBFQBO=SQ@mail.gmail.com>
Subject: Re: [PATCH v3] selftests/mm: pass filename as input param to
 VM_PFNMAP tests
To: David Hildenbrand <david@redhat.com>
Cc: linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6534140002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ucd7816hq7yorab9ngue9sunf4qz7kff
X-HE-Tag: 1754412718-727996
X-HE-Meta: U2FsdGVkX1/ZgDriKqmiixlupP+IX1Y6jAinno/G2k34sfTPJK2p3Jfp5svOtRWTX9rxiPHTgXYAayNUl0jAdzROA57Y4QB9kisD+Mv3YHC3Cr3OEXmpS8QWfhlLwUeyPaLY3QIMdBH+/2l8gj/7Nu3zp2mhAC3K2GhiD9fIogruktUt1hNm86aZkA5DgUGzvKzvOJuO2zmU5/qKNANp09ktqKNXoSQIOU52xFcQayh2MPhIfffSNgte7zyrC3tL0BKwx91t1XqgQGLgxgmXz5/nUhmovNoZNbhWh5QqUapRjszy8VVLagKRTOp3qJqplf6HqEghdSuuNY7cd4JRz5ycWDV0/BRm9XfGwlmtBhKksAOG8vkScUXdsDJykTn3jgBdcQi4upf35hWVTR7GV2CYqOxE56uJITxd1HZwQBV7UegnQc8oRh+xnQ2eYFHxDuZPGduigiSsGQyrZX30op5OloFcgLe5PZNy2ZnEajxgY87l8E+oJZQ3Tz56P+jy29NrKL5XhD0ovxmlQRJMHo1c9ZJplw0TJUDCNE0pMmpDVo8/UHc4p230A3mq4Rx98SHkEPXxB5vDbTPt6DZjpnhdWMH5G965Ir2z9pcUNvhbtxuSmOjNAYTUMfFvdEebz99qBkkki40YRSeT75EO+DrIqKCNiIIDY52wIkmhWuXrTMYKX1AEr6TTwy50WzMbFZZODLt+XdH5tLtp1H+dSarX4xlBA0D0ciMZClYiCNzyNU8w9Q664ONtw45+FKYuwqVHfjEVp9mypyGfRo+hwNkY01J8bhscR805azrEazCDCJ22btRoSwarOFMSo92EZajuXgY1dQAZFnnwlZ5b2pkl7ZcjFGV1rz0iQIOBYXcgat1YeKPLmlIPXRYrHBTWhUKCzyoA5HzrAXF5tf810GbhDEMkTAN2yImYrCWjD4BUXMqbKuAvHsFOI0sQV4ghJFfGyhawdha5oeh3xm6
 Bl3DAtZY
 YfTAGpLkHxXWDIZ5zfb3z1SK5UECXMHfkia8GYHbMiX/92fXFk2MmscJWaGL2nDQj30LTizCBxWm1YMegIoXDIpv+EkNnoklfda5L2ZqjlPMQJLtlND4xa9g7hZgyljre6PdgWdBifPUL+ADMO24eQfIt2pGWuXhlZgX1+Bpm7UkNfbQFTzmmuCeEpDG+CNuQ1NZZX4xQ/OuPz/ThRTisgOw0G1sOsPgAoartmm9BC8Zgrwi0Eo7SXY4S4KGatDUoGih5kqew9oRwQWjDwiU+YscT3glKIEbEY4/q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David for your insightful review comments.


On Tue, Aug 5, 2025 at 1:47=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.08.25 03:36, Sudarsan Mahendran wrote:
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
> > Pass non-existent file name as input:
> >       pfnmap -- /dev/blah
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Cannot open '/dev/blah'
> >
> > Pass non pfnmap'ed file as input:
> >       pfnmap -r pfnmap.madvise_disallowed -- randfile.txt
> >       TAP version 13
> >       1..1
> >       # Starting 1 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Invalid file: 'randfile.txt'. Not pfnmap'ed
> >
> > Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
> > ---
>
> Thanks!
>
> Acked-by: David Hildenbrand <david@redhat.com>
>
> --
> Cheers,
>
> David / dhildenb
>

