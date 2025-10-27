Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A324BCCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 10:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3C580035; Mon, 27 Oct 2025 06:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BAA8000A; Mon, 27 Oct 2025 06:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC0F80035; Mon, 27 Oct 2025 06:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1E9D8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:49:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A5D758E62
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:49:18 +0000 (UTC)
X-FDA: 84043572396.14.C97F04D
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 979F080015
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:49:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XnBXr96Q;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761562156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgHGUo7vKPOLMFys7tnpJgx6l5wHevbg8X8g3p58eD4=;
	b=Ray2/cs8dmgFHqAWRTPSdo5GSrRroazBBAB7D+sJ/pf29CtoxplV5UXz9RSQlQU6iuMklf
	1S9R1HBiBG/E8YM8eF9lxp4FTRicKZt0zScRjBWsbNjcQ970rDQlCN1CeoVQXaXjQDQbGm
	Cupyy097HoY8MHZtWIfalcAlM2ooeFc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XnBXr96Q;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761562156; a=rsa-sha256;
	cv=none;
	b=2ArcDCplV6lbia4KDnWw7/C4VDiTf1q+bsqCxeZG7B6kU3jZbK4l0oRo1rC7dutOjNwJnu
	tkPqlRQv2vVWhSVyyh/CjvMmgMjz1YyaEBC7M4VErdlH6W9NA1zv/f6W0rNieQG2uBwgMI
	X4UpYU04Sc5kr1fLKPz2re8CKF6Lw4U=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-784826b775aso48833217b3.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761562156; x=1762166956; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OgHGUo7vKPOLMFys7tnpJgx6l5wHevbg8X8g3p58eD4=;
        b=XnBXr96QxHGkMOCRYekQTB97sWD9X4Jwv5BzcXQ9nzNN3onNvgfdG5wwTibydC3Jde
         sfcIor6V3mYu8FQVxTot+20wWeByu8bpYrkBymHSMx4Qx8cYKYjhXYPD6Tv9VtLl6gkL
         M0+cnl7J7pgH7ERogKxQvg3v97GZVTx3nobQ35Mtr0WidkstXAqTf3bRFqbnn1cchbtV
         spHhC73AQOFv3s+/1Mo2YD4a2XgYKrKcTqTV8rVcPslmyqihD+maXAfjk4E828MKpOsf
         kwpntCYdB09lqc27mKy3cWy8H6zz1GTq+u8DXRHNYdI0kQfGY7WQQ/wLNByWFBM4qW0j
         gR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761562156; x=1762166956;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OgHGUo7vKPOLMFys7tnpJgx6l5wHevbg8X8g3p58eD4=;
        b=uQAM6moyMdw0IHgGqGT1UYUHkIRWITC4XlAJUrBn13jVwY5VAofpTggl0Aa2fS9xpb
         wxQrny358r9Ys2ktrpqQA2Qq67kDKNADC2NYGcbVgHlZyFv8JfCpHE5nVN9kDpQ6Y/li
         9mZskTEZZn9qV3g8sYMAShNk6Fb7RM1SBMW8lNaZsRMmY764klsKnFWstF1eyra7PHp9
         DMmMd5YkD8wSX7x7aMklWkVlekhM0xDrYy2ZbY3xo2nQDsSDnBOtYlBmDj1wVf7GO7AH
         Q0AqAsKVoZbAZ5TxYXWzhSgS/ZNNIFM5UNsPDminnzUsg40kjlJOykUW8koPoebinyri
         epuA==
X-Forwarded-Encrypted: i=1; AJvYcCVZ9m2UFyHXMfUMIoUgbEQf178LVzzc7DPv7442dsyMwKXniXBQIIniAGrPxqAIWU6QVyskfPdE5w==@kvack.org
X-Gm-Message-State: AOJu0Yw8KppTzfDbGAaO69gAJoxvNvA2ywxsL12cg/q9I/AE8ON5yca1
	P4WVSSPycWG0wzujszM3K/shMzRZh5/e2MTBQ0mxWu5Yr14ls3NCXgQ4pfawgSDxJA==
X-Gm-Gg: ASbGncvbQUdsxiUV0p/CS9TVwXqert63WAABocqvOl+H87J21VdYR1ssIJs0Sx7EuJw
	tk2h+ha+FaBYg+G+/uUZB4yqe6dic6+yUu0VdKllCSTYRLd1dC05nWaFkAPywGU7VtYHFrTSHq0
	4m4LJ6agFCMFXa896Wtn44RdzHn8Xjd3P9ngHTYfR06OVG04OabwulzvB8eKylhSak2pXMJeVZ0
	Hm5kUtAEl9PKST5qHe/akiuDOER+cL29DwgflU7gRXNyMqnKYCzlbx59pxMd2ZtfqKkg6C2bTnQ
	1TCC5+YIRXDg8XS7Ru9JOuUo2up0ick+3mZvqy/XM+3PJWIWSL/Bv3ddd3kp+7VfSmieemzLGFO
	lLD0fWiW7LDlKM8yDXUMVC6f76Ama330LudWwqZvc7TWYK0YVE1VxooZsc1HiAXFKXIvc1K3RFh
	738Xlwi8YL/swkEViL5RBdLs6BEtOPgp019/QbTsoTbDpO/w/oKm+41DgPBEb1j4GlPfwqUM0=
X-Google-Smtp-Source: AGHT+IF4G0GWxPrawsqJUunlI8mR7Zlz3Bdu/PVS/V73SpblujEtTUttzB5AMtvsR7iP+Kk1d5taaQ==
X-Received: by 2002:a05:690c:25c4:b0:723:bf47:96f8 with SMTP id 00721157ae682-7836d343077mr323894387b3.53.1761562155421;
        Mon, 27 Oct 2025 03:49:15 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785ed1e84ffsm18025877b3.55.2025.10.27.03.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 03:49:14 -0700 (PDT)
Date: Mon, 27 Oct 2025 03:49:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
cc: David Hildenbrand <david@redhat.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Yang Shi <shy828301@gmail.com>, Dave Chinner <david@fromorbit.com>, 
    Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
In-Reply-To: <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com>
Message-ID: <b8e56515-3903-068c-e4bd-fc0ca5c30d94@google.com>
References: <20251017141536.577466-1-kirill@shutemov.name> <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com> <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy> <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-1022125602-1761562154=:3513"
X-Rspamd-Queue-Id: 979F080015
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ujdwrupcch3xi5sfif8z18wijahef1wd
X-HE-Tag: 1761562156-276223
X-HE-Meta: U2FsdGVkX186uj6j4g3twOnaY7P9CavZTIycnsAK+9VgDeHVc6GB4vUkWPgI2NhQTe2ngtHMUpdZ7a9HjKXvjjn6gq69b+ANC5WO8MS+8FQj5VldMbtf3KNwWOCKLfXeEv5OzLETmk5GnIJy7IgUq/q0uxIb6I3fAGGxqT5xTnvtfbiut732U7FyU38KoEMhpYMlJw4FZqkdIBMLkeov0HngwpTlYocfUxaJrlWRhBxNAQc4yKKIvWXgvIxwwk5YpxIcFrqSRxLMTloJtQgSSeu0sEs5mgMmUjVglEpgopbh87+WknFg6HU66xCcmWROQ/+8QvPXnN0ilEfXZxErCOKRyU9iLHAy69neTJgZuQyRIgKgodaXzFkJTsUMYXu6yN0Vo1Rd2WZCUP7J3QxATg5qSNvkp7i6HrAeb6o9A2ylXRXivQZADhoH8N8souqOQUqZtxOIFijZ0fH/90Ab7E7M5YWBznUqF21GMMo4v3EfxobdVvDw/sFpoCrwX3n9LSt+vDmUgNypccLKHREYENbl+n9viB6XuoWLNOsj6yyq3PPxQsklx+QbnPdxpviiRrjeCBvX7fAPqB5xhJGf9QBcVvMDl6wimVP5r36uDb1LwmPSUwvNGaG07EHoopmik4CW8geKzBHWCak8bfGdLYvsVFDobR2RFeSJUON2mFU6bSnxq7Fr8YbGImlXtXd+JFy8Ql70PkrPrHwvQesrZXsF6apN9CM/USM39T1M8JtNVuGOWaIhtMSA7BDL0a2xqW2v4RBTblTboBDROLaeESlbaf3HtjN6K3YV0Ci0TEk7SB/gBHsfAlRz8eTCroplkqi/SV+zhTCh0p95AXEK0nuIdebv4T2Kt/Czvo6oSna/Wxt3AX154khoeDP/0zctc7aaygWD4smptxOMvhW2hybPmlzhAG9Uut1Ab4Nd/bqI/WWzPzaKTBRgL2DUzgybqLpKUAPVjxUhxZWkKjg
 1irjq39P
 Isoc0m4x0rC2u1nzw39I/8CSWGb5YykqZDW540hSBrzH2KxQDJHtsaHI2QymSaJSI5qEEAtEGUoK74L9VTUUJhxkqTRXBVTQy9t2tGeu/diPhBc/9dngsOwgE14iDOcRx0k2wGsqLdyKp92RZcvn2EU4rJYMeCi+2OdR7XTMMxIOtsavSGtC0c6M42KnT+9SzYOQeufOD7ABDmyJt6izwrWjehDn2XytPu6ehBpzu9puJwLgs7pvlnfEZ7UagITQh4S8v0PjJawzNUqJ2KuOierrN4w1dUCFrRlzJ8pinD1+N57WhNtetjweJTqkM6RA5X7XNM3OwcbZfbK4sKoecfGxZfBOLyWgVMGqOOn4CYGHXo8jYqS6luRM2q39OBQ4YWCd8E3vzELcLKsMGV+Ecrgf/98ifUUOo/TVb8BVBgP4PiFWQBQ23KiMJMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-1022125602-1761562154=:3513
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 23 Oct 2025, Yang Shi wrote:
> On Thu, Oct 23, 2025 at 3:34=E2=80=AFAM Kiryl Shutsemau <kirill@shutemov.=
name> wrote:
> >
> > On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
> > > "garbage" as in pointing at something without a direct map, something=
 that's
> > > protected differently (MTE? weird CoCo protection?) or even worse MMI=
O with
> > > undesired read-effects.
> >
> > Pedro already points to the problem with missing direct mapping.
> > _nofault() copy should help with this.
> >
> > Can direct mapping ever be converted to MMIO? It can be converted to DM=
A
> > buffer (which is fine), but MMIO? I have not seen it even in virtualize=
d
> > environments.
> >
> > I cannot say for all CoCo protections, but TDX guest shared<->private
> > should be fine.
> >
> > I am not sure about MTE. Is there a way to bypass MTE check for a load?
> > And how does it deal with stray reads from load_unaligned_zeropad()?
>=20
> If I remember correctly, _nofault() copy should skip tag check too.
>=20
> Thanks,
> Yang

Not a reply to Yang, I'm just tacking on to the latest mail...

I sew no mention of page migration: __folio_migrate_mapping() does
not use page_cache_delete(), so would surely need to do its own
write_seqcount_begin() and _end(), wouldn't it?

It is using folio_ref_freeze() and _unfreeze(), thinking that
keeps everyone else safely away: but not filemap_read_fast_rcu().

And all other users of folio_ref_freeze() (probably not many but
I have not searched) need to be checked too: maybe no others need
changing, but that has to be established.

This makes a fundamental change to speculative page cache assumptions.

My own opinion was expressed very much better than I could,
by Dave Chinner on Oct 21: cognitive load of niche fastpath.

Hugh
---1463770367-1022125602-1761562154=:3513--

