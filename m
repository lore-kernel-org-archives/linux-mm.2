Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3514BFD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DFE6B0136; Thu, 26 Feb 2026 19:16:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7476B0140; Thu, 26 Feb 2026 19:16:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6466B0154; Thu, 26 Feb 2026 19:16:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB8E6B0136
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:16:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19C0B1C0AC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:16:05 +0000 (UTC)
X-FDA: 84488319090.22.8FF1AB8
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 26E738000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:16:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=khyo8jLo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772151363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0NZDAeKbMdiB3N/VIVp1qkQUzC1j+dSdVDcQsUuKlE=;
	b=eu8gsyNersR+AakjWAOhhKdmM3ZlCksldb+MrNHXnqKTNyVRphfZBl8ybKC5Q0wufc7zHB
	K2ljaGDjtwbJXUfx0cfwZmf9YwH9KcarU+ScmyRcePoFtlaVdFFAxB9uRPRH9U7+yugvHm
	OJtAHbcwDV3/jHHeEsjRA60G9x5JScY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772151363; a=rsa-sha256;
	cv=pass;
	b=FyfAdv8twp+SgKzvSKHcLlV/kaM19plcdUeZlJWz6rTWlZiOl09JXd4sGWrUtxrXLA8zHZ
	VKS5rWtO/5gGEJVkRG/YX1r/yug9bNpDykiQxSn8XUVGNrLLZtpJIgxQdlLhH2N3QmItXK
	CFog6K9ZrwSVCkoadjjc4sUtA13gE/Y=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=khyo8jLo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c710439535so86986885a.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:16:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772151362; cv=none;
        d=google.com; s=arc-20240605;
        b=C2dRaypxAwEb8iU6WbOodE+C8dbx3fGCNduHIDscXBttOe7At7vSbm+KkxjFEsgFQ3
         8WyodCctHc4aGbu+jUB7P/eIoom0d2qarFMfhZH0l+6p+3MhrqMAdLimf9MbO2FUb9Qh
         ro3gAMz4e4oTwD6T37gFAIRd9SoM64ev8v9ML0OHX4BsstJ3izbrZAg3MP7HF4KkH9+N
         b7ds5oQy3nsNNYXOepcsIj0lEBkoykE0EfHwIcyWJu5+Un90lLR6ieRVjF4lOcjK0QaM
         GHv+fzm7b7MGeoHb8llZRUKEJS7MOSlOBvNUrXNyGMMAQYPYLfzT3D15sm36bzo8zrU5
         4X8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w0NZDAeKbMdiB3N/VIVp1qkQUzC1j+dSdVDcQsUuKlE=;
        fh=C6+AOUdjQAe3NAQgNekAzA7BLvLrEkEK4QCk/0/bMfY=;
        b=Y6I3iY1N4hjqHCTYdCXXyIP9gkXOS+ZBeBs9idMdw14Zlc3pJF06MAhPKo9rjae47d
         b4CN0RrSJJRFUTPkM50/Pdkf/KKm/Pyhr4yaBlAH3ZAK3JQr7uPi3m5eSdXZxdvpDYzG
         0KyR50Idl9jdANwzKPQ2kuIpV1eaOzZCz0jocTkCjLu4Kdi3ZE5FReoSUPJOKPJZ40fu
         bo8Dl7DUD9CwzkQMrxHagr5w5LcJLgpu6KAkt/rjJqoxRRHBYKkyby61Sz6RvfIhMaMV
         OCZKHR9rlI+Yk+MnE2BJeQ/VKkXAjW2qOjbI3txJOqYYO8pm/U+E/xfuZEKOnoadnu/x
         HORQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772151362; x=1772756162; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0NZDAeKbMdiB3N/VIVp1qkQUzC1j+dSdVDcQsUuKlE=;
        b=khyo8jLoZO9pah+hhZnaKPXlHhtayg9ovU4Kh0DCZHZqBdT/DXGhL/60JZeIPeCLx8
         PtbISkoGpMfrBEox/Qg9LawpeQfHDqDgEcAuZmOvHxF6NIkqd6XZoPYbriAmFP6kD/RT
         x9UZiewxxtEeN1GF5qL7BPdZ9V4soo53YZpexIPgiajvG08Vzkcix5L7XKcJumNHeWhM
         Zl4AKJBQhVPM+QOKWUz/g75xVhY9i78iFYAwH6sVra9qjAPMWMaQLWc57mbLGvDkDS8j
         A5zh1BpKH14hfRj97cHIFBIxjVHc+O3ApW5EjUD7pDzjiszASFxuXrsjj+KLmOo7LU0Y
         joQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772151362; x=1772756162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w0NZDAeKbMdiB3N/VIVp1qkQUzC1j+dSdVDcQsUuKlE=;
        b=TNl/Ho9No4jd+HxAm5gG51wQBWYGG+v2QeNSVXu3T1NZ//R4z+GcAASMooqZHB9qbQ
         lTM8UGVPQfcrMaB2FXxWMDDs6JZD6lwTOmT/r1AAga0nA+wnJiq3KebykYoZQ/EEeBH3
         WylJ79Jkd1Yf0tmLPhv+k01WSSyNiT+Aui+vGWKI0xB2e1opnH41+nK0qc/d1zhuxK/k
         AZkrUSQRl+q/SGhx51kC3JQaFNEX8HhNUOBHo1zkQ461weuJAD1l0ys02w8L/eMrDgrK
         nRiIyO1Yp1lJ0SN3wok/TTOR7bVifZKO5Fy/ti4j0s/7ngQUrxHg2I9hGkfnzFJU05Fe
         V6XA==
X-Forwarded-Encrypted: i=1; AJvYcCXbchV/xNbxgdDY+roE3JONNTnO3CqtyarrqfzhHEnskwuwVbrrX1bk8mBlBKUgtYtlKzoNcAtHCg==@kvack.org
X-Gm-Message-State: AOJu0YwvNg7AJEywkIujQ1dy+24BAdW/i9cRwXCn9pF+oa/IrCGbjI9S
	sVBsCAi5o854KfZ12/TQ+GPSlXoSuNTh0k5RZMw90hylIBI/KIPuTINu9i1CCGNMGUKFgKUeh17
	y+H4JPdu0A4beRfbszrq49HpI2Ze9Q5E=
X-Gm-Gg: ATEYQzx+HpykbqY585Fsl7ccmtbopUYXYat3YIEf8awFTrOD26wM7a6ZOiwoiCbWmpb
	GHB6FSN+UAcuYPUvoqizyken3nVbyV2QAqvkSQsVGztWuE6tW9zd7DQAs22Yrq+LmUhNyjaQMbs
	5MHpKLqxKu3mLU/FcnlxxT+CdGz70XTQ/g8J2WNAiiJkdXSzTC5eYPHVNvWYIOskf9BSeMlrnA7
	yk2gJDGIh4lJApGT1qwcmcwHO4E7bPK73CE7eRPhXlJAjRShe5W3Wrdu9L9LrHFp2fvDegptBbS
	7VZaaQ==
X-Received: by 2002:a05:620a:171f:b0:8c5:3067:903c with SMTP id
 af79cd13be357-8cbc8e6a228mr122595985a.11.1772151361789; Thu, 26 Feb 2026
 16:16:01 -0800 (PST)
MIME-Version: 1.0
References: <20260225223712.3685-1-21cnbao@gmail.com> <2558f7d82b9a482387960f45409e1b76@honor.com>
In-Reply-To: <2558f7d82b9a482387960f45409e1b76@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 27 Feb 2026 08:15:50 +0800
X-Gm-Features: AaiRm53P5clO_2juHQObOB0l4f9jyL9LfcjYoi5jGuXN8wzTTgjYnLWb54eQRDI
Message-ID: <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
To: wangzicheng <wangzicheng@honor.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, wangtao <tao.wangtao@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 26E738000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: uarc97dqya99shsqg1ro188cgagokqmf
X-HE-Tag: 1772151363-998304
X-HE-Meta: U2FsdGVkX1+WXOQ9ijNZKbi0JAtAAyISU0zkAXjDhk/+QfVP1O52/iX454pVRRBvvr1E2DSaw3C/ruw4NOoArLrvDdDcrerEagcBEA/MVC5GDx9O4intLd1XPu6mgTM5i7UsH+EuePgd/OVMrwZ6waU/N7mzlZHOfTQr8CmEmbkDsv9zLKuqiTEBZUMkWQujP3SaBs4mIaxSX0EEbkzE1Z9o/yazlDRVbbglxe8UpzoEyL6/6oCyB7SwtZ1F1FW4TRQADJnxKqckM9QaeynuzrVG8EbJx7g98CQUJrodi/vzxnoZ98cI7zm80HyPtlbc2OAXUaICHzqWL9SN4+vUvtrPzt6Fxq1HIZNdEub8dB8mB4Ixbqd9s9O7Cuvlaq2TgygBkGH/jI4VBoTf/JnTiVSK8YF1Xot+0pS9kFPhSiQsY19w6+sqVeEq91PFqK66F4Ksr92+36TmhnUX7Tcl6uk428L8dVQD5bONV6SUCgA+FUmOqznG8NmK0HLd1lT8NzCAvwXFw6PH2k2XdGFha4AQjeN9oM3VSQUlZQNoEugFffOzz4+i6IbbFQp5pzwcFJD+r7ljs3iLzy0dDSx8DD/7f8RsQPS+U7akW5zmHXBfQxY9r9n5MgA+HecJm2YBFq+t/virhFisS7wVSW5N7h4qXWOIP1S5nqBZrc1rDdvinb9GlbDc2kZmB7yAVIct/sQ/BNgZjplr+6vh31Wri1zAj6LX6wHrrPjgCD0sZ6ZTHPdrC37hoSYuq/RFSlcq1Hs4QvQu9End6q5eSc29rFBaxMAVwxxkSysSaafve8VrM0paYGsFBTVgmLDGe3HYix+MdTaj3alHaim2Slp5DMrliB6IeX1QO+c3ACkfYWK3wHNxMF9NJh6owhG6+OqKNglVeFdqT68FooUGMfGYAFf22PllQ+GaQA6ihaL/Avd3kIb1PsTfjX/HXbdXLVPq2g4b65U2tTIUkbSwutJ
 dij8FAZC
 UvHItwS/VimDFRZ+PDwVBfivRE4zKm9+wuRN6kCIfYIvPuQOKdOpsKQmQbZbmwV/ovTOs+tJTY1VIuMmyM7k4lndrlIvYSBhwKh0ukSTj+/asxlmu2my08YJucWBf0Civ4xmdwUSbSX4QERWXtBJ+zIbN7H75mBkwTOH7KaKvi4Pyvt7pg6Am1mnyNauz+gY0A8nP3Qkw+1B/fk+hgXia8ypJsZJ28ynHoA+4Xqun5qFJekXB3enmIMc8yhbUNPeomUvvscc8ZlfIM2dDkEhSNB9nGq7wdXAgTWJ8IFCqZtlnXDUX0+ZOXM9PbrfLO70VgJ1OI9uNNZKcr7RN23nvnPzMGtDr2mDOHemm/OZEOW9k+yQ8Fb8/GAeIUwb+4TqNHzgh6U+c8m4IdhbDVvkv88E+yqKFl+a1A/CUpmRKmanGkHZ9Ei9N6GMH70JboKavLdSQzLE9hxC5K9Z0XyEwpCbRGaGbEamJovXc/xzrL3HxhgNkCtmV45FSUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zicheng,

On Thu, Feb 26, 2026 at 8:57=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
[...]
> >  /**
> >   * folio_add_lru - Add a folio to an LRU list.
> >   * @folio: The folio to be added to the LRU.
> > @@ -506,7 +519,8 @@ void folio_add_lru(struct folio *folio)
> >       /* see the comment in lru_gen_folio_seq() */
> >       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> >           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> > -             folio_set_active(folio);
> > +             if (!folio_is_file_lru(folio))
> > +                     folio_set_active(folio);
> >
> >       folio_batch_add_and_move(folio, lru_add);
> >  }
> > --
> > 2.39.3 (Apple Git-146)
>
> Hi Barry,
>
> Setting only non-filelru-folio in folio_add_lru looks reasonable and
> should help with over-protecting readahead pages that are never
> actually accessed.
>
> For our workloads that already suffer from file under-protection, we see =
two
> sides here: on the positive side, keeping only actually-used readahead pa=
ges
> in memory could improve performance; on the other hand, since we already

Right, the fundamental principle of LRU is to place cold pages at
the tail, not at the head, making cold pages easier to reclaim and
hot pages harder to reclaim.

> see file under-protect issues, it's not clear whether this change might
> exacerbate that or even hurt performance.

I find your concern a bit surprising. If I understand correctly,
you=E2=80=99re observing that file folios are currently being over-reclaime=
d.
In that case, placing hot pages at the tail might make them harder
to reclaim after PTE scanning (since they may still be young), but
this seems to violate the fundamental principle of LRU. Moreover,
when scanning encounters young file folios, reclaim will simply
continue scanning more folios to find reclaimable ones, so scanning
hot folios only wastes CPU time.
Since read-ahead cold folios are placed at the head, relatively hotter
folios may be reclaimed instead, causing refaults and further triggering
reclaim, which can worsen the situation.

>
> We'll test this when available and report back. We hope to have a
> chance to discuss this topic at LSF/MM/BPF.
>

Sure, thanks!

Barry

