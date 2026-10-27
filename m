Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2055606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qkjvFXnN
Received: by kanga.kvack.org (Postfix)
	id 1E8136B0920; Tue, 27 Oct 2026 19:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1806B0921; Tue, 27 Oct 2026 19:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6086B0922; Tue, 27 Oct 2026 19:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9AA16B0920
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:20:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 538F3140B69
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:20:40 +0000 (UTC)
X-FDA: 85369977840.19.BD08A7A
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C33B40009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:20:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qkjvFXnN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793143238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRtwUNH3EsCnj7+Hm+ebJmArJ0vJNQzEEiDjAaJud2E=;
	b=VYTAPiWmfro8v0R3cPR2jPDxxP5P5JEJzN9El+6b1bbp5aVWrgyCZFMNgidQhBcSzUIdG3
	6kuwpkdMcW+d9WTbzIkk6f+Y3v84e9cgVK1M04NzLWrC6G1bw5JtAtnhaSYLyHcXWxE6PN
	80dsXevEYH5oYJTSoFTXe/X2wq6/NUA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qkjvFXnN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793143238;
	b=y6Q4N/9TrEg6f0YwnONeTztrv2PE4C2FAOW88KEC8Tat1WwQNfPlPgvbebJLb7DI5gsoUG
	cImkMH5chOflt1GyUABuStdgklMGWDBVmZP2rTOtIqe0kUYz8BN3R5B6a9nx0kOcvlRYbz
	6reZnTzSqj3LSk8/3Bgwod5D6YrCscE=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso275024f8f.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:20:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793143237; cv=none;
        d=google.com; s=arc-20260327;
        b=LPTjxV1nuule8/9S4phiKyVFTBbhGOU57oSYlMRJKX4Gn5ZFgrFIsRIYis2PMaGu1T
         8sZFHW4UijHO2Fa0wzauU+U3yu3KRhKvDlj2FY4Q3s6g6FIr37TXWpJ6UXklf+lVeNeV
         4l8ggU9r7x4ceeNtwR+bIMRjzCxmfPpK6TQCBPQwN+iA/22Q4bgn/5OXBVR5Zw5KNOnR
         qlQHwqjEL9kknYEuDDnhM9SMfA/yQco4izhvxqGsTS/VbVpsKiXSr6lnRPTvUYTRLtpm
         bESCYrrE3+Cz3scZMvvwQTyF694W1w5pNWnrL+VZf7RdPDSgk1zEEwKoDmIqhZi4tBgh
         xEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sRtwUNH3EsCnj7+Hm+ebJmArJ0vJNQzEEiDjAaJud2E=;
        fh=ClQ2NTONM5+gEKrNvnfy6Q2R0k5wkl4v/ZM+hC6iMdE=;
        b=KyA4xkpW8RcpDrNG/pFsEmtcl9e+9aNRdBIXfbJfShI26lr/DUMIRGBurSQ1U+1Ysh
         E/nfWf8domj8XL+L+YPRiM0g0HgmL2D4NTskwYmc3UDS5nqpXD+XmlOjQGr65dLIc5X/
         CR60mhUhsJP+NdLzXQ2s7HAT4yV7lyKdXg3Tg5Kg8nXvP+y3s68aezGwd3sofRVDrnMF
         GGEs5fRaDU20ngmGgNzExMvpBAu5mqa9zz9/jXNQa3Y7ztwZlZXIKotm6OqVryXV6WZ4
         UCb9TGXo5XYZVqpJS4c75vzCCjiC6bzG+eNYZMI++OH6C1YbHq3XMj7YbUOhy0Ha/23g
         y8WA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793143237; x=1793748037; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sRtwUNH3EsCnj7+Hm+ebJmArJ0vJNQzEEiDjAaJud2E=;
        b=qkjvFXnNJ+A/pk3Pos7+FSEqdd8BG4eaIUVNhaXWicI/atqdoZ60BZK7bkGbNJjwOy
         ioa3lYKqKPFcm3Oe2eoqwtEXrLviysgHjyRJ+6bdJe2t2oFyKDzkKox6FoHz1ptnjZ8S
         pI9DrkKUaIAmZRcY+eEA3ZNqCuvz5mwTn/TXdOopu+SIDp4e+iZlE0Mi4gWBKBrDMheo
         mtMaU0T928/YBDiATc07gSIryIdeYo2DS/DSu793I6Dh9gaW0NjvEm2q13K/H1cdNdtv
         gLuIMUMT+TQz++RnSqxPlWXEwzcU6kl+5/56Zxj/2PJFewn4FurP9Pfikaaa82IWrUS/
         MBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793143237; x=1793748037;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sRtwUNH3EsCnj7+Hm+ebJmArJ0vJNQzEEiDjAaJud2E=;
        b=Lel4u4F7OZTm87unCU8sevfuCG83z0nCfKbp+sVtQ9PTltPiLwHA/JFQEnMYTtWI0b
         7uAjk+fvDNHmQVZevglTU00f8W7O8qma8BpWMnXWhcujox65+47WEDjz38n89uPdRole
         S+pZ7kSMLAP2/NFnnUKFE/8q8mGRMaTtWUbSIho+t7cfiXlSIB/g6PVJsW5sz1MdL0gu
         FErSgUkFRHAyWq9cJHgblbcxEhmL6E7Q3Jk0lo1dmX4XpNUvlCRmSvBGX1Jdl0JRO5Bo
         ieD/cY2ofGSAqi1QIC2AiapdHUe/AzPtfZns103iTA93ppbyxbz0VlzifRh4l142lv5M
         4dTg==
X-Forwarded-Encrypted: i=1; AKwUvByPr6Jcde4CpXn60rdm9VeoLeTm7EY+GSRgqEPnTm4fX2/l8BxmbzpT0sDif6Kyi+QF93o+mTTGmg==@kvack.org
X-Gm-Message-State: AFq9FYKxHscxCOO75spCltiOp68RV28hX9JSp0krq6FJINnbQCPgqMQc
	tPb0eN0jQAJxOBcmsmx61BX1eSPwtiKPQVMNEtQ8c88vl7/8Kg1mB64ZsiH+55ZETKqXalsFQ5h
	NRccRuwQHwqL4a/HocASFio72RwzCuV25rgYHu9Q=
X-Gm-Gg: AYBFou28AVDlKuj4Rl3akoO3Vg9rfKTQEnod81jdQx5rQ0OeiPIj2z0dJoOOIHxcoE7
	yzh+CNAGRg3eXhx/37Hj5XpbZLq2gBrOOdF/1CVHOPPj78UAZVrGSRDM4TOShh1c+qhP9qpjzF1
	Xs4/w4AjWKsc1HpEr9QnQpyi/VPI/yTyThDIKSkHBWaU87ncV2z9SvVLCMFAZnuj8ZVFGGb1KUX
	8g1PPZa32HFRjwoIyiMGPQgLPzPsyOGRBYcBUCpUNYG7cYZMt0QQfyw8Wo4O4x7Mnts/1B5dr7U
	Qm6YIkrBqnFyubsyap+byCcljtZk+CtktZEA+wJJMhWLaIB6bBwS5swTeDivzDq0c8mwS51hAf5
	ZR2Kx/3q2EB5e8Tn4hwMnptJh9jMyua8lVTbAZ24+vNmNS1n5SO33DfOB3M3fDn7PJgA6i/cDCs
	QGjCjJxZiDABUARGHPoipPqYqkwITnKbsp2KP5Zl+E
X-Received: by 2002:adf:ea12:0:b0:488:89af:e95b with SMTP id
 ffacd0b85a97d-48e5d288cd9mr1593003f8f.8.1793143236888; Tue, 27 Oct 2026
 16:20:36 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
 <20261023230006.3759543-4-joannelkoong@gmail.com> <auDqq827gVJePL-z@thinkstation>
In-Reply-To: <auDqq827gVJePL-z@thinkstation>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Oct 2026 16:20:24 -0700
X-Gm-Features: AclHuK-pAuzRKfbS2AqO6rdM17YsldcUPsrfIIM6GdBEypYF75wq2GbvcdIJ8ZU
Message-ID: <CAJnrk1aRG+8nYkbz5xpPJcXk0-NfNyou2CdXdwT6e=2pEE2xPQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: add anonymous mTHP folios to the deferred
 split list
To: Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C33B40009
X-Stat-Signature: 3wnkgt7ori4sbnax578t4quthfi6ww9z
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793143238-391832
X-HE-Meta: U2FsdGVkX197/IZxqCQ1l+lZlLx7ClGN9g+U1WaBYtdCYv1T7fbAv6b7sDAyhtCl37QzWIG66R1mSOTWB1av2z1ldo89/1927BjGevxf9Wi1pteXZgmVxTmmFCbHRouUT3AQSrAa2gIHo88IWlvojA4GoyrMltblDAn0MEKvaepFbA0tIPjIWpt6CspwxeZlE5V4n41H06QW2MBddFRa208euMwe9VN9o/FqYCW+r28Pgoj03Dg0nAFy/fnOWs2Y9cWkisrOAC8Qqt5rwXMPCLmn19muNZb4ZElhdW2k72dRfryiDaFgavtSkAiR3GCSO9lL1yhgQ21zP7zgjmDY0RSu3T9N+MnrzHkTYusJXj3rBxVPeJpo/u1BpgHLEylpWalwwlHtU2iGez0A8Vwgdd12QsYYeb4jL8pmk6WjdQ11SURNr/YJ8LRJilaWoiIaUw/LOW0OJ3rooJ9CWMvl0Q7qPyTxzMAvrEZNWhZ0W1WGKxSTrx5lfUkM3hgSLOZnVSkT1x829EVifcWs7y0wWiYknPM7sZuoB9inpkyNeTBXx36ac6762rEoUI8mlPIOz3bFlGwelH0XjSTLFzSWO27e3tdHrutpUX1j8O/qM+DRwtmlFlHZ3uAuBvUN+jz016Pg59w17jBUkzT0uyMoodBSheOYJQRt4eBn6c6kzaEUB9z9qAbcxGHafoBVcbhYpc9aJGLTVzzGRh1PQubNtFNToFX1NUYL3tcWYCBWuPsQT0wVez62AZKk5he2PXsfGNxqpOdGKdA/XlDvKkjxw4NTViCR1CiUEU8fvXpmWLqLWR7E3ezGuzYVWNhbB6ba0rdGNGiqZ7In56jwGTB2V4Nwd72CGiis0cnc5S8I+iA5oMAVmsHHXjt+XwZyg0Q9fERK91laimC/u4XsL5UTePtYCnmGNZCrAN2WwWJsXwP9Ftchx5dUJ7v/Xd2RcQ39ttSJw8Hy2vBuyM60Fz7
 uJShC6AU
 KACaY1yIStijCGo3HAPOjkH7F2u0UeJ8IDQaLRV0U7sb3+3yRHAjcaKo/iLcaCFlQhlNF1ecUV277TgFSkQ+OogrHaoX1ymY/0LvIDLQwRA9WOKxLk9qL0a8HM3h20+P6AVncLUAnfeVL2vHDugrkdYmK90ZJLQp/Z2GjJCWFnsPHVcyXqDOymdZyysf0AXmX4L5DmFyGDesQ+efRA1+OPUm3fqHRn+rwXOJ40VM+uJBRwbYn6TQomsx7GSO7xGgikk1MmvcEtVCJm4xRmKSBYwhtHp+bR858W5c/tKL1O8B6jjvm9u7F3S7QWu99dZB+maAcFRmw6cRriE+lIFJ2YeOVNTV7ILyljDuCPM6GnEgtb1YEIpvwhIunCOsOnR/P9qiIT/uF3EMYYG1MRNRxXCZkQenF+nwdavqfqpw0ROu4fss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 11:22=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> w=
rote:
>
> On Fri, Oct 23, 2026 at 04:00:06PM -0700, Joanne Koong wrote:
> > Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> > to the deferred split list at fault or collapse time. As a result, a
> > fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> > the deferred split shrinker when the system is under memory pressure.
> >
> > At Meta we would like to deploy 2M THP=3Dalways on arm64 with 64k base
> > pages, as 2M gives the contpte benefits while the PMD size (512M) is to=
o
> > big to use. Without underused splitting this causes memory regressions,
> > as the unused parts of those folios can never be broken down and
> > reclaimed.
> >
> > Add anonymous mTHP folios to the deferred split list from
> > map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
> > already does for PMD-sized folios. This covers both the fault path and
> > the khugepaged mTHP collapse path. If there is memory pressure, a
> > zero-filled mTHP can then be split with its zero pages remapped to the
> > shared zero page and reclaimed.
> >
> > Only queue mTHP folios of at least 2M for underused splitting. With
> > thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
> > folio of order 2 or above could in principle be underused, but for smal=
l
> > folios it is unlikely to be worth it. An order-2 folio on 4k base pages
> > can free at most four pages and on systems that only enable small mTHP
> > sizes (eg Android's order-2-only configuration) zero-filled subpages
> > tend to be few and short-lived.
> >
> > The minimum is hard-coded rather than a knob, since admins have no good
> > way of choosing it, and is a size rather than an order since what a
> > split recovers depend on the folio's size in bytes, and the same order
>

Hi Kiryl,

Thanks for taking a look at this patch.

> s/depend/depends/

I will fix this in v4.

>
> > means very different sizes across different base page sizes. It can be
> > lowered later if data shows smaller sizes are worth it. PMD-sized folio=
s
> > are exempt from the minimum in order to maintain backwards compatibilit=
y
> > since on some architectures (s390, with a 1M PMD) the PMD size can be
> > below 2M.
>
> ...
>
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 976cd03954e3..0622425649c6 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5501,6 +5501,8 @@ void map_anon_folio_pte_nopf(struct folio *folio,=
 pte_t *pte,
> >       folio_add_lru_vma(folio, vma);
> >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > +     if (folio_test_large(folio))
> > +             deferred_split_folio(folio, false);
> >  }
>
> With this, thp_underused_split_page starts counting mTHP splits.
> thp_split_page and thp_deferred_split_page count PMD-sized folios only,
> and mTHPs get per-order stats instead. thp_underused_split_page can now
> be larger than thp_split_page, and the per-order split counter does not
> tell underused splits from the rest.
>
> Should thp_underused_split_page stay PMD-only, with a per-order counter
> for underused splits?
>
> This is messy. I am not sure excluding non-PMD splits from the counter
> is the right call, but it seems to be the most consistent solution.

This is a great point. Your suggestion makes sense to me, to keep it
consistent with how we handle thp_split_page and
thp_deferred_split_page.
I'll make this change for v4, unless anyone else thinks there is a
cleaner way of accounting this.

Thanks,
Joanne

