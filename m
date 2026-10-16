Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCACECC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE4C6B0092; Thu, 15 Oct 2026 22:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F766B0095; Thu, 15 Oct 2026 22:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B468D6B0096; Thu, 15 Oct 2026 22:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D31D6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:23:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E62280276
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:23:00 +0000 (UTC)
X-FDA: 85326891720.21.9B1F23A
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B9BC120003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:22:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qk+cYRFo;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792117378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jh/0G0ZYQOyM/zqDXg34ETho8wDUNuz0didpQnoyiNc=;
	b=450/9kL6zkZpfahWstohyEFXfbmCZEM41v6kAQTEKagkFu5azFGud5+bNtpezpv8ZGtfvO
	ZPyV/6C7CUJRgubC1r5zgwv0+F8y7Dj93nagHCkX0yf4qO6eTTQK/Z67xzSZJlChsgiEmp
	gO7VHdPsCbj1htUdmFFzuiS5UMsMRSU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792117378;
	b=pd3pjo6E7Zf5cyDn5toFj0pdlRFryb3YjZK6u4UZYRKSXcdvEsZGRhC4htXyWnyccvVR/5
	4MC00rFJ7EXnhJ6E3craInSBKJN0oxKzLlfcc5v05CngsryfT1NRqZsEppdxPiNHr31b9/
	IYV0eGXN1AG+ZyMJ0a8WCgzDhJpzr8Y=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qk+cYRFo;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso1702434a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:22:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792117376; cv=none;
        d=google.com; s=arc-20260327;
        b=nGTJR2guMrhVdCgmn58n5QZJkUZuioLwxKoTNzzYco/e7JWkRn8SSU29hRj5fO9+a0
         vbdXysyrWiDILgxBcFi1r2Agg1j1ki7ia8A7IqYbiwo8FgwB9tyZdw/RAfhcHk8b7K+L
         mzNj7rx1c+jgDpFA+clFUtXNf4Fy1YPdz4qwViTgz+y+KR/W3nQOLHGrfesnL51QGx9a
         ig3lY+/sd3sTu/BEk62x/1JjvYpre4IE2j3QmIqUUsjTtB1GuTkuvSsUKeERjWAdTQAZ
         UtPiNtQbgNXYpwSiBwp9pFIa+IaVUt1T0ObbiVtG187icctLuEnggirtQMTvGo4ALBNG
         1OJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jh/0G0ZYQOyM/zqDXg34ETho8wDUNuz0didpQnoyiNc=;
        fh=OB0XQzLrmTNgWAma8YbpR7xirDHTQCnDvCs89FzhiIw=;
        b=RGEzYZ6m6PCqTvnlmOu+w4B2oaNDV15bf0wWis1IX762fIC/orhpYEh5r+Jlbxg9OP
         Hqs4zO1fVSpMlhcqYut0vkqZBMVroDjQAg2JzMfpBB2YuK+32zDfuyhS5reqY6vwpKhh
         DLMBl0jGpckFoIT/wSQEKpoPDlmRbntTM5lcwU2TPQenA+4/7R3tLBroTBO3v0G2pBc1
         Z9OdJwykUpGUNrQPiZUO3W3+ryjvcklYDn2bmnJCDx9GMBHgu3NJgfIfoTnRivUv8XL3
         Gc+IzQbaKPOAyEExiTVs+XKHwvxKnITB3ZvFyqYfYmJBPJXRWp1QOKlxLeYjHHehoH6U
         XnsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792117376; x=1792722176; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jh/0G0ZYQOyM/zqDXg34ETho8wDUNuz0didpQnoyiNc=;
        b=qk+cYRFoaB8ZCb67+af3gXVrIYEopnuxFaS4p38v2vsn4DIlzB4nLSUf7jvmEPd3AX
         2zKsh1yMKRVRG8W9OU6Ft4JKGjtXLPqrfNfZQwOTkgROgtxqVwjIOZ/9B0kw9G1ak+tL
         4vU98uplMjOdizfPM421f3LyzfmRK8fvSkOdQFI8wkMINCClw5qMiJkTApehDOxBAONa
         QeyVTZp6LUiKk6gGcfAKBFuiiey+T83ZW9j7kvg0AVW2KTZltj5TNtmnP2aWc4mymRnX
         OxheMuLAUXs3nAPjHOT2IA7StIJCvHZUu+KPftFPrfQLKudbxEi9ADIHrCE/A64pOXw6
         0+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792117376; x=1792722176;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jh/0G0ZYQOyM/zqDXg34ETho8wDUNuz0didpQnoyiNc=;
        b=G05/w+/WCmda8PrdlynvqgYqygI3sWd+p3mkdlWk1QfJVlqc5hpeHBgD2GeLhccrGZ
         Rp2EXbI86TZUO4HRiKwzBXiOfwzAoLk1XiIJ7UoYYABcKruAnqseApmL7Yf5xU+NG0Cb
         O4Cx5xjaU3EpcBS4TGjvjOP3sm+oznpy8OGClFx0jycgFGVXuoHwzV6J6SJ8FQ2V4EJg
         KFhsUkfILw46wzPC9XwHgvrMVPqLtLvqiR2BssATNcoCZe1b5UFuhEJhHpR/KdGfggsT
         Q2oLsB2L4lY0CIcy14ywRUe/qbXxvCmavYxEx/h4qaq7WbYlTnga4fwqEtm9Lkq7iYEo
         9LOQ==
X-Forwarded-Encrypted: i=1; AKwUvByWUWpCVxwr2AEXMTBy4XLhJIYehqaoUe0asUaJ9Q3YYhI7KLQSc7dGO11rit23xRCluOON3X+Arw==@kvack.org
X-Gm-Message-State: AFq9FYJVW5dPBMMJExqooW8LsFmlwNjj4s2isnw00NmUutqyd+FhopGg
	y0qo8FijqqikgZWlzFacl8tYMihW3fszHIKwFClBNOewK5hVQ/pQmMJFqrsGe90kkCEFpmUY7GJ
	rFB73iYO2CzU1HPjZXydak61o4VsMvSIjQWcEN8o=
X-Gm-Gg: AYBFou3ghGF55nlSRXmfmiqt77aFiNH36jxdEjKD77QvPsmUAiq5lePJP4CPfR33BaA
	jpG9GRP62KfNcQMeNraP/cSVdwr2DjuYMwOzu90dbGXQArMtOVNULfl/zMQSUULOAkRxqL/Ekx2
	A9GO28HRWUPVClSzrcr/Tvy/Z3cqBI6gZoE5SC29wqVZ69ONzNrVNQ3fzymd0dREsb84Tma9E5k
	yOpNpr1lGDJ87qvPI/aq4vARHgsppV9dw8ajcGHQ7W1YBwuTHNB5Et0x6i4IUv0sN+akqOkDg62
	HEO2tCfgaJZ1k7Mxbub79gpTc7zHAZQFYqKdPiGKye08P2q8OsO8T5ueSCGEqKTGG+9JHnpM7nK
	anJnLaESMWcth
X-Received: by 2002:a05:6402:1f44:b0:6a9:93c7:ca57 with SMTP id
 4fb4d7f45d1cf-6b17c29942emr17390376a12.22.1792117376453; Thu, 15 Oct 2026
 19:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
 <20261015184014.715dcdd3a25e18fd4df49e95@linux-foundation.org> <b2f925b6-93e6-4b44-bc18-c94a34b381eb@linux.dev>
In-Reply-To: <b2f925b6-93e6-4b44-bc18-c94a34b381eb@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 10:22:20 +0800
X-Gm-Features: AclHuK90w26bVbnVGbbVThIr0n9_20vKmHT-hT2gr5ingTf8fnlIELNh8L5ISUI
Message-ID: <CAMgjq7AGRP3B0UZ9-wJKtz8D-ayivhV0gn2WxsrJ1Q=Qm4TVWQ@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1B9BC120003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8rqjcgtjnr6rktd4zayi166cuwnmsd1c
X-HE-Tag: 1792117377-434570
X-HE-Meta: U2FsdGVkX195Rm9gUULP2THLTDS+L79ce4njm0Apatk6gNYQbLGrNQ39qthoHQOkhziTjFddUvIZjdhdGWR2TtbwjgqXfpRoEENFYykxhRGWMZTlRYUO557O/OAud6nv/SKeuKBFrVECLAUS6enEDj1nt/RqwwSLcZhVpcEA+HPN82Ifk1Virtie/TEofaLqIbEpZYT0xm7DEjIjvuoqnSFg94YbDuX+5ST0GRnwxDLC+G91t99CH6TG5BLTR0U0Hr+yJhoh76esp3W8zZIo0InsbvPSZ4SsBEWeypagoFhZLoqH1ylt9P+q4pKOUOjP2SReWHcggFKXZ1PPErasLFZMXgxKcsej75l9k9mb9M6C3sSvD2YKWPKZ96CPdoZJuUzKJJ7q8UiRtYTZnzwoeTQKQ9zSSekFPreIMHjXqP9gVN5e64ZJf7LxBBQ95uiXfBaUDRlb5ggJD70Gp5U6J0WzuG/WHpIabV5hsRwrpt7I3FZOqdCFLyBoJFNQfmFMIfNV0ikPjjm0KctuhRokn16iEJddAQwtizYtIjEyKbJXpu2v2DoEwI2blF1hwwarQ8lPENz3AMUj0BJXnU0otDRC/Igv2zmHaGMYNrOZss1iVqD332jr4b9gXQsO3QGx4ViCUZ9YRclh8/91cPa1N+UrDOvAscAKw1960cN+/pJII+1BWG6sNo762WFTTI8MhlE9c9QbQjBarVNmzuShZQwWvBjnZALpQE60usdFHZx7ji7tCWJ45mNOg9kESDPTi7db+uz2kdmVe6gjGw2bAPoKI4Djsg7sf35EfSH0tccG2av5b8KsX5X0KSpvpvGeYdmXldyX0zfFXb6gWZFU6XtEPv8JTYk4+3+6lIu+pgLUb0zphnKK6XZE2++TmzTWAV8JfqVR08dmHkJPgAfWsoQUMB/eOXHEPzJF3DGLQZ1OA+P9bPC4DgXdBqStBJmhk7fmt+3nUffHQC0p67z
 NP3C5MEx
 N2WNbG/OV08sgCgsHC5l/Bu6zyF50rhdrokInErc8HHFEEBdMhD88OlR4rQodcnAM7R9ALs76znY8ZOFOcWzBMHA5yYQKptspaOq+gDQ/RR1+Z1j/6P49DvNflu7mY8Q3iAwf6hSAJ/6Iywsn4LjwB5eH/7CCjM2nNobOm/R65uBHaA3X6exZdQHD47VnzorgfliqDfEgaGGmSSEF9JVmF7EGIY04uqemk1YOgr1vdvixHFsHtRtLGX43WBAOALAbjFRplCslZ0yn+6izRK+plfI5aTu8E1+iPt5tmfwFUfc/CttikjIJClj5HxOz4ipM9be7YYTy7Gj6KDfi3jNKTqcmGKQBRrwWyz2vqz2VauryE1V8I/0/BcAfEM7N+MTrgYgKxxQV53gaaKbNKizRm6Fuc85ogrX2LqSoLk2VqtIYElRAGrzNqk2lmuIrHJa1K4FI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 10:16=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.d=
ev> wrote:
>
> Hi Andrew,
>
> On 10/16/26 9:40 AM, Andrew Morton wrote:
> > On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux.dev=
> wrote:
> >
> [...]

Hi all,

> >
> > So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead an=
d
> > takes the folio lock of someone else's page, before
> > folio_matches_swap_entry() finds out the folio is not ours.
> >
> > Recheck the slot after folio_try_get() and retry if it no longer holds
> > this folio.
> > Thanks.
> >
> > As always, when fixing a bug please fully describe the worst-case
> > userspace-visible runtime effects of that bug.
> >
> > I asked $LLM for this and was told
> >
> > : When the race occurs, a swap fault can acquire a reference to a
> > : physical page that has been freed and reused for an unrelated purpose=
,
> > : potentially by another process.  The fault handler may then clear tha=
t
> > : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio loc=
k,
> > : and potentially attempt to remove it from an unrelated swap cache.
> > :
> > : These operations can interfere with unrelated workloads and may cause
> > : unexpected stalls, impaired reclaim or writeback, and potentially
> > : system hangs.  The subsequent swap-entry validation normally prevents
>
>
> I don't see a way to a system hang: the folio lock waiter is woken when
> the real owner unlocks, so the worst case is a stall. I suggest
> dropping "and potentially system hangs".
>
>
> Writeback itself is not affected, only the PG_reclaim hint on where to
> put the folio after writeback. So "impaired reclaim or writeback" ->
> "impaired reclaim".
>
> So I'd suggest:
>
>    : When the race occurs, a swap fault can acquire a reference to a
>    : physical page that has been freed and reused for an unrelated purpos=
e,
>    : potentially by another process.  The fault handler may then clear th=
at
>    : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lo=
ck,
>    : and potentially attempt to remove it from an unrelated swap cache.
>    :
>    : These operations can interfere with unrelated workloads and may caus=
e
>    : unexpected stalls and impaired reclaim.  The subsequent swap-entry
>    : validation normally prevents the wrong folio from being mapped into

It's documented that caller always double checks the folio so this
part is harmless from the aspect of data corruption or crash.

> >> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache =
and switch API")
> > Given the above, I suggest adding cc:stable.
> >
> > Do you and maintainers agree?
>
> Agreed for me.
>

This is more like a optimization than a bug fix, but it's clean and
easy to follow, Cc'ing stable is fine to me.

