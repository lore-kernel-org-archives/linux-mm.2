Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 663E4CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 23:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B708E0009; Tue,  4 Nov 2025 18:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC3C8E0002; Tue,  4 Nov 2025 18:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1958E0009; Tue,  4 Nov 2025 18:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71C978E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 18:13:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4EC613B9A5
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:13:04 +0000 (UTC)
X-FDA: 84074477088.11.FB343DF
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id D20AB160009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:13:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CFvJtUhs;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762297983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4A6s2r85JE/O60Sma91flPa89d+O9AdRu1hAAy0Ftc=;
	b=Z6YUEvlexYR5Tfxwhr5rkxKSxG88+qEIZ98nS9lJL6MENRq5btAwabwnGsL4cIutSeFndg
	3Qfr5t3J5Pzun3+ulUBp2UmVAR2bmMmWUcgbnnZa20GOuPdHMyJ5kGSXAsuHrhAjMVWWNN
	4tFjbHc5Rx+sat1VT20whk2V1OfJKas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762297983; a=rsa-sha256;
	cv=none;
	b=VZvriEhNCU+SmmJbWDHudI+Np9Df0D4iZW9Hdvzth+yQ9EPdyhZUJHy4f1YS1d9mMFHqbp
	yDXifcwLCyF46y3wNgUvchOpqulFWEVRPPUEkNTODj1tAhNRrgN6ypOaK8ZBiiC/+CGAht
	ouLwjdjwTN1cwWUpzsuFWsmm0CrAnuM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CFvJtUhs;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so5157532a12.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 15:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762297981; x=1762902781; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4A6s2r85JE/O60Sma91flPa89d+O9AdRu1hAAy0Ftc=;
        b=CFvJtUhssbeGIp1dNn56wZcoDX0c/3jrRvXaOZ0KYs4BTUMQ/t0aJsKNLdLS1J5QAo
         rrhuCpnKbUVfEScyNxCNX2D8/F8nzgx9MctZjyxPKhjooEp6sPRmeLVkuSDrKFN0iy0S
         Yd37UL1EZa18ZbE2EgRcFZeKtyTuSLI7tvQkx9jurHx7mlvEUL04JGT/u5yDm+aQd2IY
         0PqDgcxNKtSFHu5fmnE5TJ9EMFZQbsEkkrW7nmemEGeTKVOKYZ1h2edQMfwnXqYru6A3
         PC4QxvGW4WVZT2kh7WvStDahC+KmrKVRoQkrEfpj4CaZyfarhImh8t9T749Gbw9vjqr8
         h4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762297981; x=1762902781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4A6s2r85JE/O60Sma91flPa89d+O9AdRu1hAAy0Ftc=;
        b=DMLAYKf4nqqKiBBBDJy5qbNqa6qpe8VMIFyD5KbiqJqMYrM5/nZXHMDJAEQ3Hc3V58
         xqB6Pg9Mhs8R3Rhh1DfsNXwmadgsioMOaa0ZFWD5LQ2meU916EihhpamMgFlJUSQIAeG
         W3yfOiqMD01oDW/0XZjoP8x1AhZ+VUOkozsSfufE8MQJDEzvUqWlYyo2Z9Qo3B+NaIha
         nUAEB9ZrZjNgAHiHDl3xJuggh7/zuWXW3FPdjbm6Eksv1tROEgcWtpBIAPsJMp0GYusn
         mYvJ3HSrHjMBuP+1XoIhKhtHhGIHrT7AcQi7f89+6roPrJMFwdKJ/Afs3bGtKf0Rr1Na
         5yoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8JFNnmF2q7Rf9ZonIe8Za9wUs93qEKOoTNxj8AzR0rpcqAQNkXCdRiO9Q/xaIp+nR/L1fa6H2bQ==@kvack.org
X-Gm-Message-State: AOJu0YyPavheit4hsC04j8mtx0Z+RW039Fedtdh0TxYF8fnebFsIPlmn
	JQUCyO4owEn7MJBmrv7sAJk9E7txOr5NB/uARqmwJkvKA0I0MApLFGZwxYR39iGKBxwMnVG2ffS
	vlj5IJk8P1PKHUVWk+5A414JQtw6VfSUm6d6prvVg1g==
X-Gm-Gg: ASbGncvxTNikAI10UfOS2BFxRt95QjXNPgyxdZll8J1qLsw7TFkmFTBixprv4FupTUD
	d/ufq3nfckW8M+Iy1TgANjZ06Se9BVK1Gg5iFvkI9+9rV5lJvNxEmcT1ePwB1zcDT9G8P9SeWN3
	jXE1notkTsEdeGnOe8lOfgpd6fVxxvbSobx2bX+WA/uwW+vNDLnttIf3JfBM4Gme2wzo6MW7Xv2
	c5o9iPVoRCwnSDqS6O8bglTYBXoDrzurpWeihdQY8XddveaM59nxSQOcg==
X-Google-Smtp-Source: AGHT+IHkWWZErYuLad1UBr4njjLSBFdMzkNER6OzhDlN3Gq2YnhAVj0tylfyLg91Povf3vXT6QPN/toCi7bUhtkuZFk=
X-Received: by 2002:a05:6402:35d6:b0:63c:690d:6a46 with SMTP id
 4fb4d7f45d1cf-641058d0b39mr882506a12.13.1762297981094; Tue, 04 Nov 2025
 15:13:01 -0800 (PST)
MIME-Version: 1.0
References: <202511042251.paO6f5BZ-lkp@intel.com> <aQod7jDFBjw9T-u2@kernel.org>
 <CA+CK2bBYF5AndNHgqcb5zDbUOV04nE6xiZ0igcTdYf-GOU4aOQ@mail.gmail.com>
 <CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com> <20251104141501.48a1f76a3f83967f08d00097@linux-foundation.org>
In-Reply-To: <20251104141501.48a1f76a3f83967f08d00097@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 4 Nov 2025 18:12:24 -0500
X-Gm-Features: AWmQ_bnjdc4QtlbQ63r-Q4KMUd0Myc6Dyj0vlY4QdgnbVI_lhk-7gxKFlvCmp18
Message-ID: <CA+CK2bBJRXX5u9sCkG+WKW_OK1biyBUfdcJ73yuUdeNv6QevbQ@mail.gmail.com>
Subject: Re: [linux-next:master 4972/5926] kernel/kexec_handover_debug.c:16:18:
 error: use of undeclared identifier 'kho_scratch_cnt'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: aqzbanwg4xizhzspnb1bfpj1gwwcxsch
X-Rspam-User: 
X-Rspamd-Queue-Id: D20AB160009
X-Rspamd-Server: rspam01
X-HE-Tag: 1762297982-184167
X-HE-Meta: U2FsdGVkX1+QV5SsRlAawu9RHYsAJsTaB1sXFTD69aqTR8jHHfb2z6bQdkHXWUkZg6jX1mlyl1lCS1doU3Ry8ZbFolZyvu+bB8d0T47aZ5XNtAjVwsu4SjViEgC7T/XMOqiAc2hnp3nJwHbud5H+Bk2S4YEUoHZ3utO1g6BBxlRw/jdXKpf5sU6cU9LlqA8DUIwUSsxLVlmNdpubyY+hx5CcYFVd2hxxytBA+XswHIA9QaPr+LkRGfJLnrinNAFRjsxRZ8jPilK/1rJSZVIzAVTcyZqiVCKh5zpvqW/WECon0MTLh7bCTxQJKpNTT9yF45UXjiGgKDRMZ4J0Is26Vu71fo/EjlhtMjInMtvdwrwzjJf8wXJsHj2twrxBVh+oCJaSIFlpGAq39j3X3RcFugE/rdkzL/nHYdCk8rIX9A2VrRL5Qnc0kBWkBUxmuYu3PJH1v8qQksBEpxRGNJHxGd1+s3/Fvu6qM4xqdv1p+uD18VIt0kXRg3Zjcpq3P4IjM0EbTzrYslHJJchhT0v8hDPiLjxdfw1COVKXDZsuOyY1c+q4ojL0DFvPssVO2i6q4Gcb0JelJUKPM+VayT7UfHMtteStvtR05qc4jnBc1+VM/qTd7bzfDoNKyARSC6k1fmq/KthBDseHsH9Iq8wtHOxr5dJaV7hZYcND5amfkkp9wB2+QL4j79poGmvlyo8/98PABx6zBhtGdzcgd7DEoI08MTGZNk3q0V5StS8rnwhNo6c4PjGEEAAyzoDDRBxy+NkL/hdghK/s0g1SCJ3WKDe1B2/JvZl7yuKOsweSh2OCcF5+umluQP/DFecu4ow/Twg93rK2w8xoIn90RlWohVvuUXrdpjHXDGNbHdXJlACVPm6RQ0rAOshFwLgkNgdAOvOPuOnSiqFebE+L7fBqlduVsdw+OfS3cfywXfj75AX8BCB9HCQmfzS/1bJTWTPh5UkmsOqeSO/PxHT3U3l
 +fDj0DT+
 uyoxyVmCM65g1CeJrs280VDyFO0KjpVTMnLl7SeDOmD6rUFethrEbhD379zcwFt+PIPIKXmCe5ngG6zKXa09M3r+y2XfIrnAai5rbdKOKz628tJodkYn6oOlNrMwDh2Kw1mnPZD9wN7z3FjPxbBbt0hQXCN7alyV/J1JNJuWwX3+qb/5x+5ybRH9AXfe+P/DyyZEknImDKdoxX60IW8T20Axiq+XPJOd6jlXignyzWssNL+N9MfBihwR9dUMsHpLsTijOwB+h2pC4vnhSB2Za4vcQEHoifWZ+ptDW8dNtx7yyyXLPaK5Pkcbkz7XVEpyU7Djzv7UyUVSRLVJUZLvfGQ0clIFk0dCf9Imt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 5:15=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue, 4 Nov 2025 12:50:49 -0500 Pasha Tatashin <pasha.tatashin@soleen.c=
om> wrote:
>
> > The fix looks like this:
> > diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> > index de4466b47455..2a8c20c238a8 100644
> > --- a/kernel/kexec_handover.c
> > +++ b/kernel/kexec_handover.c
> > @@ -477,8 +477,8 @@ static void __init kho_mem_deserialize(const void *=
fdt)
> >   * area for early allocations that happen before page allocator is
> >   * initialized.
> >   */
> > -static struct kho_scratch *kho_scratch;
> > -static unsigned int kho_scratch_cnt;
> > +struct kho_scratch *kho_scratch;
> > +unsigned int kho_scratch_cnt;
>
> This patch is making changes which are already present.
>
> > --- a/kernel/kexec_handover_internal.h
> > +++ b/kernel/kexec_handover_internal.h
>
> Against files which were moved to kernel/liveupdate/!
>
> > Andrew, Mike, do you want me to resend the "[PATCH v3 0/3] KHO: kfence
> > + KHO memory corruption fix" series with the fix included?
>
> A little fix against what's presently in mm.git would be great, please.

Hi Andrew,

This is because in mm.git you have patches that move kexec_handover*
to kernel/liveupdate/ (and they fix this build problem), but
linux-next does not have these patches. The patch I sent is a fixup
for  "kho: warn and fail on metadata or preserved memory in scratch
area" patch.

