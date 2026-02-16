Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A2DE7BD8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 10:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B2D6B0005; Mon, 16 Feb 2026 05:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017116B0088; Mon, 16 Feb 2026 05:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C326B0089; Mon, 16 Feb 2026 05:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4B7C6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:37:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7798DBD587
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:37:26 +0000 (UTC)
X-FDA: 84449968092.20.E1F1BCB
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8834312000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:37:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BYspH9Ou;
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771238244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYirSAqhPiJDPw8kC9Ddqr2HbcCD2h97c7AnE13xFds=;
	b=ArrQKFYn4BIbYIq0u0J54tV6dSADVfZrhyANtIfll1ccyxFDZCCdYBZXmdp3TLVFox2gIU
	Dt3OxhErB5sGZbQL7vio3oJhfdnPFzhwdPfaZ1z3/Q1Z0Aayx0SbfPwxh39UoKA/Zm9E0q
	C91iXy1LyxWnc5qD7HbDi2zovIrTeis=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BYspH9Ou;
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771238244; a=rsa-sha256;
	cv=pass;
	b=iSjFXtLwsvkVVHzaBi6dvOD1w4ANQRUxmeF732GGQ38PTSzZ9f/XS138Rv8pVNt1gVHEkS
	TCkqcXvCpdGOxiiVCOYp4d4YUXRGbxNAuA0TR/UzQu051ngNwl8nJ6KKbx6w5MlsDUUvdm
	pHHHK04aVdB54n8cz2CBQ8HFwT9RgK0=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896fa834290so36198166d6.1
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 02:37:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771238244; cv=none;
        d=google.com; s=arc-20240605;
        b=Pq9YYQoL3wIao25nSK/akqBUzRSP15FoO7dFrReh7v5u6s93ymY5laNO45MgSSGCrC
         mBAa1YGMCaydMn0v3qK5Zpzudoz/prNh8QDd76eESAobQsyIIM3NSn7PRX4a0mtMPPBF
         YmT1qHkge16D4aYsykPrD5BArqKJz8BxN11agb0BteHhjDYecZkrXZnt3jeFW2Twa+0G
         IP6ZRfUUgGs9lP7SShkh9uf3QgkmKx1DaiS3wtpHFmbabdTDl99grvWrEU+RQu8p/brl
         N2dAS9wPZy8bC63VW7qDI2UC4gRCVai6VPie+84xr3Ch+9SAD/coCYcmxLUX4pk19MvG
         WSEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VYirSAqhPiJDPw8kC9Ddqr2HbcCD2h97c7AnE13xFds=;
        fh=hhd0I6XJ1GSwECoRmV3y/oprXQsTWBOpmWhHIovp74o=;
        b=aYq2TkppIRcaSTuu+oGBpBfrsNffBuUXX+2jj64TN+mkMsaBcIWYPod1jDHF7iJ5Lq
         MYfV0ahFjQHP84XuTreegxg4ivxniuskvULsW1xWlcH2TCD9XHAuW8ln4/1B1fGXMUtl
         EGyG5RI1uMNKCXFv3Iyw0SMqAJbcEaisI/NwSDcw4A6g9OUuNZQksi/LmtTnuD1YWDJ+
         yfilMszIXFfbrcqQWxoIcX3QuVzr2Ipe44WaTWnxGg1tI40Mu++fbPPhLshEyehNP5S+
         QGailEqn1W8Ew1Km3XFRtpWhSrLI6UU3iaBFzKigs7Ey+BnWMe8+EXfYsnJUZMOaUPB7
         XyBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771238244; x=1771843044; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYirSAqhPiJDPw8kC9Ddqr2HbcCD2h97c7AnE13xFds=;
        b=BYspH9OuZCgixf9F1jwAUyfaDtdGFATblBh4f05q6+QbEzl67RGyAeljuyhaz3y1jG
         nzOG9HnQ5K7XyS51SforFCz0VXQV3SdSMEMLqVSexFMGDAzNAX48+H+98RCzGc/mg43G
         iemAg2KjgmXmeR3sMi89nEaJPLv/cztjxYLo4/AUVgyugK3Iw/79xZXd+sVrZX1zaknP
         z7pgJXHfJAUqYTVHnsPrvIvhYZv0jg1krMbfl4CDNLCWRIFYLk5ALHuTPhxKx38VV1Jm
         XGxZPmCat73cwGpdKBZkW8JPdv7v3Hi6faT9jiyOMkoOJySzwKTdPhuWx2Rcml0TpmtO
         3yBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771238244; x=1771843044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VYirSAqhPiJDPw8kC9Ddqr2HbcCD2h97c7AnE13xFds=;
        b=iIshDOHNUqcrEmHpWC1hSD/xIgWa2X3v0s6Zi/Y+6mBHf/geN2Z56MEiS1VTCd9l2C
         7gzNlwC/HE2yhCE7v6da5LMOnajN/gZ2S/ZWMbkAsBbvU+TbM2D83BYPuFOU2hawXtaT
         7Cdm/Tc+8Ig1pMGAtJq6+rYqfXcQVgmmoJ2XZZSeGRCRaMEllXwilsI0fJPDSV3JENF8
         yr4gBoKNITjEq2a+5amzsHTGGwfCKc/gFkFClFp/XHxeKe365CIaQmDUCCeI6PCW3qvY
         kdII5UZFA+c9I+gcjARDOTHSaal0t+crY/Ob9aEJuIpIdbP4m+KgJpQFcVHp8MjpCI38
         dH9w==
X-Forwarded-Encrypted: i=1; AJvYcCVckWG7Wm051Er65Zv59wUFqLb7P/Bu+OpT+n58TLoB5woqgrP705QrtseAuC0CFK0yAa01rklatQ==@kvack.org
X-Gm-Message-State: AOJu0YxOHKDymMrqOIew1rwHTwbQURJiNCM+k0p2/fLHptSmC3M4nfC3
	N5uFwCy8kteaSJA74FfTQSuqdnlU3Wa5yPM7zBj4AsXXq4Z3tg4bS4oDd2D6cvsTJyOpT0D7jtF
	/230qfaLPNkABKvqR5h8uRywAuQiGq+eo2ZXtAm2W
X-Gm-Gg: AZuq6aJUqzMOua6SGAN+5TYQukwXe4AwaUoWO3/rtNepH/9iDY9s8vyKc0mHbkxcHwo
	/a8CrQh06WO4RIOcWrAGhZgLtehdDnKGo8BTg+oQA/qDo5xCZVZApgRc7ANyJJdhbrw225wy++v
	tx9F9RT41cBwQRJe99gmHclOxMEVBG2XhGEc783vB4A2M7VJ2aQL8B1L/ZV/LwenQiYC4CHOUNW
	TV0bLKwKSaoe9OJHX+59KT/caN6mttuZ4o/mY9OEPyCWoQQ3mnxu6Inhn7SDrEqlTLBRAoDKHs9
	t8+5zAaIhngsB/FtW3bZz0rkCf/QSmRGsG060g==
X-Received: by 2002:a05:6214:410d:b0:894:7ddf:d4af with SMTP id
 6a1803df08f44-8973f267814mr114601366d6.6.1771238243191; Mon, 16 Feb 2026
 02:37:23 -0800 (PST)
MIME-Version: 1.0
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <aYJBBs17B-SQXFqq@kernel.org> <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
 <aYL3zxuTLT8N7C8-@kernel.org> <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
 <aYXDeN0WGQG8-cxe@kernel.org>
In-Reply-To: <aYXDeN0WGQG8-cxe@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 16 Feb 2026 11:36:46 +0100
X-Gm-Features: AaiRm53lx_IG236LrxT5wObHUzkZBCI1ibMnFCDqX286kMnVPASCSHp6Gpu46Sc
Message-ID: <CAG_fn=UZ8DX41YCZNo2PtqZbgwXHp_Bi8nZqe+t7SOMeTvmzMw@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct page
To: Mike Rapoport <rppt@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: dunjdughnzy6m59ojqosgru9u79aiu1f
X-Rspamd-Queue-Id: 8834312000A
X-Rspam-User: 
X-HE-Tag: 1771238244-294253
X-HE-Meta: U2FsdGVkX1+HnTE3zMyY+mldNOuBTUlDAyPaRRHqC1Sbd1tjwveW8wzBjs19qvxkpCm3vaJ3+bNo3Oigfrf/RQXAle+wHD97cs6/i93BthJuAYFMuq42PJZ+jQazD4lhcUIctzqpxNRJd2pFZ4XxbM5mIhbUOwxgVdumNxxUDP/DtbSaQeKsbMayGByDNvzEr1CORA6NFKN+locmC0EDd2vOas3H6toJcwGFrD4b+pozByvTU0d9rHKJbyVKlt4HiMC7Q3UsPtVvnsu1wZZ+tMH+WzZIxZ+bhg8PF+v68AM+/UqJgSQ3ik5pAZ0q19x6hLK4kc8RO+z7m7+3Hyc4zrsFge9I4OcefheoWo4Pa8PoXlAr/Zkm9oF0hW9r4NXxFtv2nTDsfUgn8a3hEmWL/Qzoeyj7eFV3ipGyhZtwnditZE1opdJBGbmtmPfmBZM9fuif4B7eYIzvf317feB0fD9ENukpN1gmBQ3xsMp6tO1ows7Q+iXCf1QRjoZQGx8d0jqDI83bcTrEWoJlgCq7TJWfP+sIrbg9lV0HbdFMat1I/MBR/HBTEZUt10cCY70wuQlqE6ye3PS68iaKV9JZmcVvlG3HxhzwU2GJOJ+zIbOd4nn5Bu5I9MF+NTo0SCNGOj5uvGc1dlO+n9u/gTY9catnaiKKidkj8VukIoAvrGsC2cui0NhvCd/La3BkCppfa4YkKoz/t78oTkaWu02gnD/TJO6Q36+Q/8xbId7/c6qs+Jn7z7YYIOq2z49J5u140uVjrU3X1+RuuzPPUrqVumA0OCBjyCBjc8WpYGaxMNg7d7u5sGq5VPKtg2a6V301JI+fo5RuNPe7MGC52bPixzdIc1UnXEQiRsXM8xQdSl9Mb/o2kRT8/Da9W8z7jad9uoTIfhgIAUNv+DFM6LDj1LxPrzRjQU5ZDfAPGdq1JVXwAxgxWShKesi0WDMyc7z2JO3DaciJBekrio+OXVG
 yC7VgcOA
 aSa2/7oaFkaec9sdeTH1l3zpTv7eFkVTDopiEPwy1iVrxhxoteERLxNkghLD2vnlUKt9dJ7LTiB3cq3hEZCxUN7ZTBzD9ispGoRtHXv7qa5lgWLxdMX8xRfEw8XyCBv4mFpTQdt13yseX4XABWQJw53ljVe/c3vZVvRiVgSC+1ETznkSiXYjOddkyIZIMuJ8jM4xcepShi/0pSG31C2oTMiZVquiVCwuVZ1o+g8nng60JfODaRglhm+XMo+bN4dOtPXU8asnUyOIgkKtuLbMBNNyxb2eZTCqa6IdOFAJeO360Veku5gMu61PI1z0LNjKzOd/KhAjY/LmXlPVcU8RFsEfnUw1qaFiDNSYqn2fcxskaV7Cn3vZ1ImS/Xp1HXwwnnwWQ+pIVvB6+76o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 11:33=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> (added KMSAN folks)
>
> On Wed, Feb 04, 2026 at 08:02:13PM +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2026-02-04 at 09:39 +0200, Mike Rapoport wrote:
> > > > I might be missing something but I don't see what would restrict
> > > > this
> > > > to the early pre-initialized struct pages other than that
> > > > early_page_initialised() test, so we can't rely on anything in
> > > > struct
> > > > page inside memblock_free_pages().
> > >
> > > Right, we can't rely on PG_Reserved being cleared for uninitialized
> > > pages :/
> > >
> > > But I overlooked an easier and actually reliable way: use
> > > free_reserved_area() instead of memblock_free_late().
> >
> > You mean replace all callers of memblock_free_late() and kill it ?
>
> That would be great, but with all the subtle differences you note below
> it's for the future :)
>
> > Or make memblock_free_late() use free_reserved_area() instead of
> > memblock_free_pages() ? :-)
>
> Yes, I think either calling free_reserved_page() in the loop in
> memblock_free_late() or replacing the entire loop with free_reserved_area=
().
>
> > The former misses:
> >  - totalram_pages_inc() and kmemleak_free_part_phys() in
> > memblock_free_late()
> >
> > They also both miss as far as I can tell:
> >
> >       if (!kmsan_memblock_free_pages(page, order)) {
> >               /* KMSAN will take care of these pages. */
> >               return;
> >       }
> >
> > But I don't know if that matters, I don't know anything about kmsan :-)
>
> AFAIU, here kmsan allocates metadata for each page freed to buddy, but it
> handles reserved memory differently anyway, so it shouldn't be a problem.

I am a bit late here, sorry.

Yes, kmsan_init_shadow() iterates over the reserved ranges (which I
believe happens before memblock_free_late(), right?) and reserves the
metadata pages for them. So freeing these ranges we won't need to call
kmsan_memblock_free_pages().

