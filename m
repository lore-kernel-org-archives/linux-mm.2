Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47AED3CC80
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE73A6B0005; Wed, 14 Jan 2026 17:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBEFE6B0089; Wed, 14 Jan 2026 17:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAEC6B008A; Wed, 14 Jan 2026 17:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEF5C6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:03:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C56901A0124
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:03:44 +0000 (UTC)
X-FDA: 84331947168.03.47A8413
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id CB9871C0009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:03:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kq9G71hO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768428222; a=rsa-sha256;
	cv=pass;
	b=IqPt4CW4v0Owokx1UNDkKqSBf49bVqK9qZY2H4moNcU4CQfDswwlEaFckpmwvvvvImptkY
	gcZicubu+54Ee8uUbGOOyIlKsKHCq08MBAgMlLv/Wz1kcvazPEs3rojM5A/h+d+KRLu26E
	WjZaU6xkM6lreNqaPslSiVQI+ernGCo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kq9G71hO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768428222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3fL2jCAfWZLF1Vci6ZRE/CAoSZmZ+NVGFQtLj2FMso=;
	b=5WFfSZcb8ujUFaikeZj51mT3k0mtAISi3yvm29Ozs4ylpzDv/5kdmFTyfkqZb+r/bVM7y/
	68/onbCvz4inHFQm2XOE7e8iNjPW89C41wXOmXkXELCK1+B9opGPwUZ7lHvL1Jfqm5Nmb1
	r4gng3dH4iIWFgDSnZRNceeVHJUZbvM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014b5d8551so108861cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:03:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768428222; cv=none;
        d=google.com; s=arc-20240605;
        b=SHyPaNUF7r0NzzUbq+KWe3K+0C4zAqquktdZDlHvD2x3+3oJgMS79NZB82krEv5n6W
         ohk55zYntuPRV7r4M8dnDTN4cCrNI5lgRFRNeaUi0osjcKhFIoHxurAIrusTQQoxU8LQ
         Xye+lSB3eqpWaU7gcZVG/s0HZPe9y3CjSgNamCqSk3sJrVNnlexvwDJf2hUPvHmvXxDH
         oj6T4nLLGA0ur78mg+cUg46G4TB4psjGK5veuMu1HxX9UCTXXEIHDuutz1cW4PTpm6ML
         6W6KVECcj0toFBK7uqK3+BWIeLSG814qzZE0mBSSV10ATbfsvnRjQnAR7YNTlxZ92ne+
         3GGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l3fL2jCAfWZLF1Vci6ZRE/CAoSZmZ+NVGFQtLj2FMso=;
        fh=HeWNblJ3NcA0gP7xoL/Y7oL9DgnE4658lDGLqH6Xp9Q=;
        b=dL+SV6ulhJ19BWEInnJmmX6ezqt2LzBhdFnTx9pEeXnpoQ5E1cd01r/nrro0dXmv6B
         9IOpX+TEJcV1MSGsDtyPismY5t3HzIkMudTKDAixse9GISCSNaL73oqO6AXncZ/isj7F
         VaG+YWvQzHeH3MyB40OgljAYnwYQ3V3m9UU07d+RWv0BEgSzdBt/aP34kOVCTbJdoNmF
         KgbVJV2Ksl577h50+Y43vWtcWrVPxeGB025cJnlMWDZwWQ4AVnLiUTel85pkAPdgqPzQ
         q4Cb9RHRQRxkd+3ZQLSiJM2PnujlOddKUQ03SlbkYuIw2ciK5lP3vFcEPrhdi5jyc7vL
         ZTMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768428222; x=1769033022; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3fL2jCAfWZLF1Vci6ZRE/CAoSZmZ+NVGFQtLj2FMso=;
        b=kq9G71hOvEeZ8YtJ3cUxy+A5ZGtq+9EDCF36PLvjOEqT2SbhWuBGmt7aZzsyq18Cd9
         DVM7rfnxnAtzupvPS8vkApd8Ap8jy+1WE9ETvKr8YOULfKlKcXl4y3gD5hBQMZDWmN+/
         RK6USDLEgkyaZtIPp9Nvt7D68DMEIkmmJQa2BWnbwLicZ3H72Ep8mjd+EmAbgRcCTdwv
         5Of3fnAO9pMM3un8rkZnb12WFRvC1AHl70WBV2JJ/y4Y6eGCuHuUTo257vWP0H3Cb15T
         eW2iedxYjzdVxduqOTcMYCARS9tEOVsWFNGPj5rZ31l9nxNKjzUXf9l/KdLK/rRjnngl
         LldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768428222; x=1769033022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l3fL2jCAfWZLF1Vci6ZRE/CAoSZmZ+NVGFQtLj2FMso=;
        b=XC+eg2alvEaFcAy5pM7FORh3Edj4cmkj+zI/FccurrAgVDnbOk0PgCXFVO4IQLnLmE
         PmLnbmuGifGb0qtxUiCISRWfjL8hZWvkmkyqLbmPNEygiY1+m0adOCZUo19oJQgYN15z
         A/hS0nxEhJcnTrujyTmqqDMzntkFwLyUcftz5WuWXXwcQ98210sdiVRAZGa92CVdIUAJ
         cFomFX38kGIqNx9DYtAr1c1RDUK/o6i1rySBnE8QfnNADKs00GzOX5D8L87Y+akouafe
         BS8cQnY22wcAVR9WLCsbhcX2K5JqDshE+2/zpRNcSgSlSPGeceXNzKnjm2OZ9rlCGte/
         nRbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtmPsw1KJL6+QbqVzFDzsZRJSTWpT/+5kV90rdsv/WpmY2KoJcyGhy9pZfq5CkYYQai2x6zXWy0A==@kvack.org
X-Gm-Message-State: AOJu0YyPIXG11vimtxfHYSsA0vHrZQoAtNlccJv6XwrmSnMAiJXleUes
	pL9fa8PKHhp3yJFANyJK9t3htB5zCq1VqxU1iLpGf7ILK1HPi2PbjB38nv57YIXazV4c+SKmWLJ
	jqsiz3SjaT973oyE3lqKD/XGFNoi4s2z9xEwH4/1j
X-Gm-Gg: AY/fxX4XChgUcrO+3hJVjRg3pwGr8TlYytOW+ReEds/FnWY+BlvtvkdMxKK/dGS91So
	aPtGp95Euo8mmJkWSrG46b1AUc91wqdo13SV3DYyz0ccoX+w0j/oPaBv7hQwgc7IDqsz8rCgBQy
	TJInOB0piLppDAkKvG1KSPWD0Nxvdxy3REV28kpQI/kQ2Qb5jgpLeKdeMkvY3yZisiVTgY0vTly
	QW05+xl9ED5swLKFVE660c9PkNED+wxs0KH8G0dY7+rEHowZMKYpVP9G7tEFnhsjxkWT2QvxG1s
	bpcHBkzTOwZNTKlAKBhj/nPwgw==
X-Received: by 2002:a05:622a:1886:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-501eaba6816mr2892901cf.16.1768428221476; Wed, 14 Jan 2026
 14:03:41 -0800 (PST)
MIME-Version: 1.0
References: <20260113033403.161869-1-ranxiaokai627@163.com>
 <2vxztswoi16k.fsf@kernel.org> <CAJuCfpEwa=_fubhf5wBnFKrKpOgjyXRy94f2BDx38x_NALE_OQ@mail.gmail.com>
 <2vxzpl7chw8d.fsf@kernel.org>
In-Reply-To: <2vxzpl7chw8d.fsf@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 14:03:30 -0800
X-Gm-Features: AZwV_Qg5vTKHUbo3UIWgMBqfS48OHF8JA7wML31Ex5lRim3U9cb7GEUBvsiGrdk
Message-ID: <CAJuCfpE3ffje9qXdwB3QZsyE+rD-unChSNXPfrijSkk5Nrt5CQ@mail.gmail.com>
Subject: Re: [PATCH v2] kho: init alloc tags when restoring pages from
 reserved memory
To: Pratyush Yadav <pratyush@kernel.org>
Cc: ranxiaokai627@163.com, graf@amazon.com, rppt@kernel.org, 
	pasha.tatashin@soleen.com, akpm@linux-foundation.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB9871C0009
X-Stat-Signature: bmwcowkjidmno8a84h9qucf7aazindj5
X-Rspam-User: 
X-HE-Tag: 1768428222-822216
X-HE-Meta: U2FsdGVkX18im6dhP3xEX0GBEBmhq8t+QCPg9FCZZIaay+4jbmPB6yIaRDIL3uYg1cadmlCFphwi57Q0AU4z2/mrvMONx85hvlxmDdL0ei4zG+TXIz7bWFURh3tiFrfN8vb3dsNsCKU2O61deK66Y/PjXDW4+1Q2zHs3QaWtltFC7kkiRRvPXcFydyGbsDMdE4Jrd92Hpx2PMKaSSSmmxAowYHhja1KvKIUlVMqITGq+8uaem2Zu++ZupKSZoYbXmLTW91GNLZAdQ2WE7V6BO5gU44JkXDApxIQsFjlYgvVUEToARQ36HPN0ImjK7w51HPWW68tjRKK3xX+TGrev9xReMZaHKXx/+wRPnUuKz0oxqI4oslTioWPcsjiQUegFyagG5+aCry2XEnp/F3vRQcIYw/sWi+bmPyshvMiksxx3ROQDClhnYfFLrZAtbnnmxd4UirNW1iJssdd6i+9TCTcpCDlp2sT5hvDZnnGT7Fh7yXQrH4XQuugZoj7wXb5o0iBbd39VWrJvVUhKq5YuhVpQSFLzqJFU/B5cr05m78YtoGgJTObcrXi0IlB/04NqHqtCVzg0UtJfB2OjpIMaUo36fb2r33CQMJbefRT8z9K+tswLYBwwgKtJzvpsllr/g4NAbNO1RPbS/FtLK1jmagooPiD41tzb051UZ1/2NikUDYbCEXr5nloZYCXrWJqSoklbG62bj67CV58gH7BL4SLoMKSs5HG9Ip4HK5n/D7iYnDesEoWnTVUbNYoleBqK4oMtXP9hZe9o9iR2K48opfp8CfP9VisYWGUrZr8cgdcuWd7s/3jB5NZweYtGJ1IalrRNip5j/qtoRRXhUFOV9GXXZaF9B4KLYm/boL5oKIaXljWRyoh8GrOmabT+Qbd2niVO1ed/STn3GzcOCdwA4vJw2aVWtd7yNz1AbrUiA6bVP3QITfgZL0Mz3QnXsvN2ymc3I8f7A5P2LVu91rR
 mdRwAc/S
 gwlJRWjCtywHpnTeWhxGTU84xCcscCzNo2dc63TU2Z1oWj9IsYr4fZ9BPEebn3iSFhLQmkhQGV2uZCVW9GN4HwJhALuQs13doQcHxuMdPcXYVW/kpTdUN6EP6YzZvtgIACz/C81tsIRj+Qz1iEvEjCDUFkszOm5tadPSppm3xYLKSkpuE8Rm4+SIR9g1ZDPg+aHDzURIjodh8EWRk2NrEa9QPW0Svwzx56TgaO4DP7dM6fgi51bUO+W/AbpRyDAz29wsBDCxAidbF4+VgXY7j62r6k+zxowyJA5pitzJXSR9xadnShBK/P+1nqYgM9Mt1Sff5+mJHo5i+UmZWC2kmMkPq5zx0FKcCnm67dHnJcPEpBMyLFNdGoRZQDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 10:42=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Wed, Jan 14 2026, Suren Baghdasaryan wrote:
>
> > On Wed, Jan 14, 2026 at 8:55=E2=80=AFAM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> >>
> >> Hi Ran,
> >>
> >> On Tue, Jan 13 2026, ranxiaokai627@163.com wrote:
> >>
> >> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> >
> >> > Memblock pages (including reserved memory) should have their allocat=
ion
> >> > tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before be=
ing
> >> > released to the page allocator. When kho restores pages through
> >> > kho_restore_page(), missing this call causes mismatched
> >> > allocation/deallocation tracking and below warning message:
> >> > alloc_tag was not set
> >> > WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, =
CPU#1: swapper/0/1
> >> > RIP: 0010:___free_pages+0xb8/0x260
> >> >  kho_restore_vmalloc+0x187/0x2e0
> >> >  kho_test_init+0x3c4/0xa30
> >> >  do_one_initcall+0x62/0x2b0
> >> >  kernel_init_freeable+0x25b/0x480
> >> >  kernel_init+0x1a/0x1c0
> >> >  ret_from_fork+0x2d1/0x360
> >> >
> >> > Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> >> > fix this.
> >> >
> >> > Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservat=
ion")
> >> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> > ---
> >> >  kernel/liveupdate/kexec_handover.c | 1 +
> >> >  1 file changed, 1 insertion(+)
> >> >
> >> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/=
kexec_handover.c
> >> > index cd6b3fb9dcae..2d47f2c50bd8 100644
> >> > --- a/kernel/liveupdate/kexec_handover.c
> >> > +++ b/kernel/liveupdate/kexec_handover.c
> >> > @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t=
 phys, bool is_folio)
> >> >       else
> >> >               kho_init_pages(page, nr_pages);
> >> >
> >> > +     clear_page_tag_ref(page);
> >>
> >> You are only clearing the tag for the head page. The tail pages are
> >> still un-initialized. Is that intentional?
> >
> > In the case of a compound page we set the tag only on the head page,
> > so this is correct.
> >
> >>
> >> What about non-compound pages (the ones you get from
> >> kho_restore_pages(), aka when is_folio is false)? Do we need to clear
> >> the tag on all pages in that case?
> >
> > In the case of kho_restore_pages() we call split_page() which calls
>
> Not since 7b71205ae112 ("kho: fix restoring of contiguous ranges of
> order-0 pages"). That commit removed the split_pages() call and
> open-coded the page initialization logic tailored for KHO.

Ah, I see. I missed that change.

>
> So I think you do need to initialize the tags for kho_restore_pages().
>
> I sent a patch [0] simplifying the page init logic a bit. I need to do a
> v2 but it is a very simple change so I can get that done tomorrow. I
> think it would be good to base your series on that since that would make
> it easier for you to modify only the kho_restore_pages() path and the
> end result would be cleaner.
>
> [0] https://lore.kernel.org/linux-mm/20251223104448.195589-1-pratyush@ker=
nel.org/

Ok, let's wait for your patch to see the final result. Please CC us
when you send it.

>
> > pgalloc_tag_split() and that propagates the tag from the head page to
> > all the tail pages being split from it. However now that I'm looking
> > at it, I'm not sure pgalloc_tag_split() works correctly if the tag
> > reference of the head page is CODETAG_EMPTY. In summary, this patch is
> > fine but there might be a bug inside pgalloc_tag_split() if the tag
> > reference is CODETAG_EMPTY.
> >
> > I'll analyze and reproduce that case. If it indeed has the issue I
> > think it's easy to fix it by creating a specialized alloc_tag object
> > with alloc_tag->ct=3DCODETAG_EMPTY and  make __pgalloc_tag_get() return
> > it if the page's tag reference is CODETAG_EMPTY.
> >
> >>
> >> >       adjust_managed_page_count(page, nr_pages);
> >> >       return page;
> >> >  }

