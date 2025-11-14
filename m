Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C77CE8D52
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7FF8E000B; Fri, 14 Nov 2025 11:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8681B8E0005; Fri, 14 Nov 2025 11:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7578F8E000B; Fri, 14 Nov 2025 11:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62A6A8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:46:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08D00C03EF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:46:53 +0000 (UTC)
X-FDA: 84109791906.28.0A16D2F
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 144E0A0017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:46:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GODjJiDT;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763138811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDQtpO0LuGRtA7x4zSaAXPnOMeh5Kiwvod9aseLK5Gg=;
	b=cCjUapapDFriDlQExprL2C5VWOL1mZjyNs5zWdcbF4sVkt92JJ+pCRp+qkgCimLfgQ4KUH
	Xy95j6Nk0MqweXz9uu9xu2i6jTplT4iqP8pwi0N7pPCjbtNInhNBW4uZ6kQmWvxRWcOn4l
	OPukutyICEdKun7/FLDhRpQbdojHdUE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GODjJiDT;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763138811; a=rsa-sha256;
	cv=none;
	b=sE2py2ar0/lnTDUafEl6+xVMixbMhOdC9/OO/fxTQjAiXvvFm1J0J4voLd2ft6bq8J8lPo
	yZUTHJg1n1N9RjTYnP2A8z8u9dAGLM6YtwGZ8utEZ34XGPRPVj0JIIqvcHlUvvf4qtlwhQ
	+9RV67yMyLkrS6iy4rnCdwAuBdJ9kvs=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso3846938a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763138809; x=1763743609; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDQtpO0LuGRtA7x4zSaAXPnOMeh5Kiwvod9aseLK5Gg=;
        b=GODjJiDTxXmSKjPdQH9zyDqNkv89NOAe0T9mdCsPaHHk3A5kVagcx8R8G//HyqgK8i
         U+YQ2otGL6AU34sLrqlTIh5x/eyC5V7alNWuLMwPRFrGM+v8SIaetR/svQsj5qk7zEdO
         79sSs4jFClrpdmJiQNSMpUcWImqvqXG2MvPTGG/1/SBC8Kj5PLz465JW0KjVsSGPA1rr
         NqejUKMZB23oHj/mznQ1/0HGYCdjwghW14tsC375fpHLVicxAcQd3y4WLhZkY/0YQxt+
         CvycYX2aqyEV+C769g3zIS48gqG8eqPKLB0dsdUabVSd+TrWwGkQ0o/kLgekEK+FG2Jw
         x3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138809; x=1763743609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yDQtpO0LuGRtA7x4zSaAXPnOMeh5Kiwvod9aseLK5Gg=;
        b=krtjZ9bs7IOAdDbfuqMLS+4MU71USi1LCMP9Abb9avgsxiYTP7hvdXCO+Ty2qgySC4
         nUH2Xj/y028HvltRHy5o+87fEsO3D2F+/gvx/CaIlflps98ng0IiuHO+AiCSHX+5nDME
         1SN6ZK/gKrupZ/MDq5R3nCb35uuXjfnaq4i56CTGBiOYZR+MCeDpM2uHYEC2fTUAgVcV
         eqYcBYHyk2cbyCrWsiF5YgUB/mpgqgRgBEbdhXcbWfsct4Pr1llTQqAaDtRILMyBXlDo
         ZgxTUszahM7mRRtmmqY8R98aMdJef5lNM0D0Vwp3voVmWrwQLIHe92tEUh636zToNZLx
         S4kA==
X-Forwarded-Encrypted: i=1; AJvYcCUNl2zqIo1XskqcWSBNqvC4fK2VBnyZl5OXz3/Wa0fXLbLItrWCroSjCe8pTBtd0QLPCFMcGrsayw==@kvack.org
X-Gm-Message-State: AOJu0YxlDbI7yMGxaXChYBtCNBmLc1+7+x14l7JfzHJssXfQRoWQ3Iec
	3HYPdCdeoiwNHsNVnAQFNKoWtayFkjLI0jqdKattBS1i4aLCeqURQFIA0SbeRCUQ3fo4rXXwp5/
	HlI05EYoXBRfrujBKE/ik/Yed8UQO0GYqwA02tcYtkQ==
X-Gm-Gg: ASbGncv6Syl3jUCnCjH3IHtdFei048EPzm+gPHBm5IKwoC4aUKQ0KnhVBzrJ/3KlNGd
	xAnZbZ45femZo8F0ZYnX7XLdW/blBnpxThtHQ2ZzivApRX6h4e3iP9r2BVpKXAQlMvj1zZMpF2a
	pa3JXUNmvtTStMPWS8hWGBXZ4mKbPdbU4PAV2E1buNr9PqHSAK5oHcDY8LgwoaR60Z/nwTcI+xt
	YfZ8KUf2j4z4+nAvmERLbweGZyhZUsA4J5FWaKqBPA7FsIJ8n69N/Lrdg==
X-Google-Smtp-Source: AGHT+IFbJ/KZEyWmM8d4Tn7qAbyKy89sED/8mpiPp9IrefIs6/m2O49OIJhrycbebbsgWFvmsokzshBL66RF2COnksA=
X-Received: by 2002:a05:6402:34d5:b0:643:18db:1d82 with SMTP id
 4fb4d7f45d1cf-64350e2159emr3167393a12.11.1763138809509; Fri, 14 Nov 2025
 08:46:49 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com> <aRdWF8ck4iq1hc0B@kernel.org>
In-Reply-To: <aRdWF8ck4iq1hc0B@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 11:46:12 -0500
X-Gm-Features: AWmQ_bnccF6a3b19rd__cNBKQXa9KGCdbhYFEGJJeXr8Oiyaq_gWPptNojqbe4c
Message-ID: <CA+CK2bCgdz3Hv90axzuSThRtEF17oSj-RKHgVwu5rQ7TXcoKcQ@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] kho: simplify state machine and enable dynamic updates
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com, 
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, 
	graf@amazon.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 144E0A0017
X-Stat-Signature: mhu4hpjw7pxbwaryooagmtopx54aqnw3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763138810-138210
X-HE-Meta: U2FsdGVkX1+JZBrBGPHpiRwGZQySnRupTGW3XOsXUeNu1981S3Hbz9JEjwJcMdWckWA6JhOVOpYSo5qMxZKF3UGeF+LdyDcey+Ken6qlAyyfA7Ok9sSXk+f85NXR8PZ2vOvbLTfhHmIFJ2HX+Kf8ADjvnFfDravJhhY5M3iKeMB7bDgfL7v/pQZM7DbzK+UsVDglJDDzAfA/PCZfS/WfT7/T7k5IYLYlsgEKeEhf94a4UL+cuTWzSnIzwWoOz6dCE7UV8W7bLpy6zjhwEVyr2TdgRHBFSUnbwVrtuKmWqNyCU+ooxz1mtbhAXsjPkNQQBtwpc6Lf0xRV76PblpQPW+om6BjhoD3CFurvcGu6PK1DHEg4XoYsnhp9du1qcoBr9JTN8uF7VGVXigstsWqjSqdDJZQGPOoOv6EGDUiW6Xeot0ndBRRrZWCXtftnLnfXFmyLRdv2PAia5ujyKC+wqF1iUo2RrSmpkCm6Kb2tprEY6yZEP1alBGbUrg4w9UE1h46K0Zza4+yQmv9uVdec/FgApatuALlofyA/biuwOsECwUtqM3lRKBoogPsBToPf45F7exBiwOWqSLksxH5BdM2JzSUuCi5N5lvHAklffDGo7PoY1TvBO2T7f7bUo9qiQnw8ycsDLbkS8rLBZ5ha7F+KptMwkFzend7eB0CkS2A+hUo9tulsBNa6txvHcTauGAs6SfMFZug4Wx7yuYBhC1Y5F1tj1DcjZK5SJau6d/USZRwskbfFqsjI9qW/LCJASTritt2NZqw63xF+6DmuSvwQRUXOnmAou9YdlyFvwcy3KrFMFl2eFZB81AQvnGADmapV4mPoqTDTBaf1SfGlbHP8h2tF6mB7EeDKSflq3mYHiEJpwoU26eAnc4hvAvFg4FPEWqE0lfJu1zO9Jki9TtvXJeUl33aCdYoA6pgHqebjYzcA9RL7TIUgVnZK2eyhwe1AkyiRxA7Cp7Kpal3
 mQvymWNQ
 x3FPE/HK2tpXJDytU0LVBXdTQSN0I6t2CKr4tC475KkxeH4JdfFFw9vwl2pXHea0w7u9SQo58Ev/TiUPAwGLEVFEToNmqyHEkvs06u94NfQhAoajfTVrEGTxXBjOhkNRUa0WVWdFwMrL1tle4LUCJA3tGqbQFFwwwo5TOzdAZPrdH08URD1ydB660SHO6Hb3f8BKNgN9tjkX6Vcsyi9Cp4VUDqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 11:17=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Fri, Nov 14, 2025 at 10:53:45AM -0500, Pasha Tatashin wrote:
> >
> > This patch series refactors the Kexec Handover subsystem to transition
> > from a rigid, state-locked model to a dynamic, re-entrant architecture.
> > It also introduces usability improvements.
> >
> > Pasha Tatashin (13):
> >   kho: Fix misleading log message in kho_populate()
> >   kho: Convert __kho_abort() to return void
> >   kho: Preserve FDT folio only once during initialization
> >   kho: Verify deserialization status and fix FDT alignment access
> >   kho: Always expose output FDT in debugfs
> >   kho: Simplify serialization and remove __kho_abort
> >   kho: Remove global preserved_mem_map and store state in FDT
> >   kho: Remove abort functionality and support state refresh
> >   kho: Update FDT dynamically for subtree addition/removal
> >   kho: Allow kexec load before KHO finalization
> >   kho: Allow memory preservation state updates after finalization
> >   kho: Add Kconfig option to enable KHO by default
> >   kho: Introduce high-level memory allocation API
>
> For the series:
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> with small nits in patches 9 and 13 in replies to them.

Thank you Mike! I will update the series, and post v2 shortly.

Pasha

>
> >
> >  include/linux/kexec_handover.h              |  22 +-
> >  kernel/liveupdate/Kconfig                   |  14 +
> >  kernel/liveupdate/kexec_handover.c          | 338 ++++++++++++--------
> >  kernel/liveupdate/kexec_handover_debugfs.c  |   2 +-
> >  kernel/liveupdate/kexec_handover_internal.h |   1 -
> >  5 files changed, 232 insertions(+), 145 deletions(-)
> >
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
> >
>
> --
> Sincerely yours,
> Mike.

