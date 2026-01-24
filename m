Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007F5D77898
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 03:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00ACE6B0574; Fri, 23 Jan 2026 22:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DEF6B0583; Fri, 23 Jan 2026 22:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02E76B0584; Fri, 23 Jan 2026 22:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE16C6B0574
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:22:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46BDEB6AFF
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 03:22:42 +0000 (UTC)
X-FDA: 84365410164.09.1B9926C
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3DF691C0008
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 03:22:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gEh4blQF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769224960; a=rsa-sha256;
	cv=pass;
	b=syOcr09bjT5MuYmfatfSEMbdUxv3NK53NDGZO9Vv/4Iu2r/Bf8RaSAZk2iPJqmI8RYPDDx
	FAka1nCz5I7BHN71oCtBwdRHtFF3tygGVA+ge8BEhHgiTgmCsL6NkqMx8vTN/4ftEm0tIe
	cR+IV5pHoTDt8xEaqdUF2rJMcrPLVs0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gEh4blQF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769224960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJnEhsYobRa7Nq/ouTP7DPdDgpq0nPHFcvwZsXoSYNo=;
	b=r2ZzNzRWHvG+H+1GXW6GQIJ5ialiM6xIuN895Zm+IiCnhBDlVT7v49WKrFtjvqo1wFyf31
	XTSpaT15d7tAHVQot4isR6XgIlQcY/g1gaS5ZnNK0l8aqlU9+EKbT7v/mtD+hSutNRYpe/
	46MYNmZIKplzOf4o/36fbUfFTqFFS/c=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-385b9be0759so24854411fa.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:22:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769224958; cv=none;
        d=google.com; s=arc-20240605;
        b=J5bxpUxmggQyeg9QObb9XGWsXZohLygKdakA/Kx3m90h7a19kS7Px8+VdAFRG73/wC
         65P5DjDZQZasG6EdZMRQZ/iva9VxHfsz0n/gOb5uKMPsp7w1F89d4tC6nUB7fu8obqCo
         tU1kKVzJIvf7UGjr2/5ycFgGlA6jCeoVVTdGTqUjFO46gyaepFY1S11OBxlrSeGRuvhn
         COQpehMN/ai8tk5WBkLBmS9TQrReZIraaHkSTbPPKRGOOOCpcfi4uoZmsUzASULflZVN
         M7swNHw/UZwwHUNxdkFtyJAg2IL0EQ+Qb6J/WSDEa4perLjIxhaVmWLnCbkvivhXjSoJ
         xkMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nJnEhsYobRa7Nq/ouTP7DPdDgpq0nPHFcvwZsXoSYNo=;
        fh=vA/l8JOwgilqBIR6e3NS1jmKBy3N9ghIBLmU3wEnAFc=;
        b=bttrqOvtJVtiwSbMencwQFUUvfZpCRzbpVifxrv1zE8zYzwgy1HCWtVms5ruGpjV4A
         4PUkfSBinTCQHYic4A/Bqsl4UPZlFPmcHhwjHggShyrZen0pLBsncHg14/aLQ/yh55uW
         zG1xOu6KIVTnxe7qQ44Y9yjT18lBHLwzPN/Ts6xMskIkz6BmYw8K0G2jcuCDeXP9uNSn
         P04t51cnzxA9V/7fls58Axja1npIi4hgrZhDjGygOkKR280cj9F9hibziChOLde6Vacn
         5EL0ZWK9CRJV8WM+xwJE64YusaCiDPkL6TFVAv9rmXfc3Lb/IuKF5LjZAvkPWylFTtGH
         5Tbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769224958; x=1769829758; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJnEhsYobRa7Nq/ouTP7DPdDgpq0nPHFcvwZsXoSYNo=;
        b=gEh4blQFr3iVgVJ3kqUSTzp8/4IwNWvphTv9qDBUMJMjGpqSnxxgK8d43ATJozzGVK
         eqvJENsjf2okiusxqmDW6dYbO+Y49CLiQ00uGIopkbomEKq+U2+zJTJcF6xbWFGeq+YH
         9vHCTGRC3kpzSPAOCrpnltS+Rs9p4rPL5u5l1Huo/FdQ28I+PWs79k1XSnG2Y8Gn9qvT
         6nD8GXTrzTDOgjfE0iD0tpn0JQClMyluCpi1qlS2TNcWHFCrrdba0BhEGao6s1fwPY+x
         THmeHlg7Ne3dBZVcotuwsrUW+uiWFzed/g/Kk4dq1xHOX6Miq5GaSgKhpp/YOEz3hCI+
         BAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769224958; x=1769829758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nJnEhsYobRa7Nq/ouTP7DPdDgpq0nPHFcvwZsXoSYNo=;
        b=WxeOk91ejCRItX9fc3dUWTiZ8HOLGlGzQFxujmhOedcQJI42j2iYJwbJtBDGwIcnkW
         xpLZimLMoXk5B/6ZSGVrnbV3th+XWHhhUBZDSG46QX+eFqSdhjdzkXtnCchpOxY4/T1W
         fdmZBoAsW9O2yRZ4E/ndgAUaD1wAtEDHSQNk8MAxe98WWmBq5p9QXkIjK8BlPj8E4hBy
         rR1xgXDkOs3xsO9BiOsXNf5q7JzAgjhkC4q5LD6tHgJSLp2Ja3EddoY4e7U4zdWCh3WK
         YmtppBlmppk2xv6kyC4ks5nmE5h5xEU5xQCWPLcTCW6FJuLARPRYF5bLp49VrNrzj8qh
         QL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXN6IPZwAe891Hp7BpYnOc+9u9/fjV7487Cy6XXUz5sgfzf85IWkpTKO2nelfszolo4QUj95UPgUw==@kvack.org
X-Gm-Message-State: AOJu0Yw7kGAgZqMAfpEiRPiZmmVoHYQe1H6WGjOE9guRYjqaJRX2MJ0B
	MzKi3ghQwi4WjSMecnqmEF5GXydgYRKB6ItpZ3biTuqqWJUJfOtqY2JLF43K6nIVUiOJlNQsy4w
	TaNDeiGI7ayDoxT02vwJj/KuNaEYCC0Y=
X-Gm-Gg: AZuq6aLj1TkB00XTQ/h2DEA0dHcTBhcUHq7cVJo09q4GJBNgrxfaf+u+2zV+Tu3wsEY
	2pJu1wWMeGC4z9UHE2tLFfIBBLWfJny7fv9PG79ZuGCF7LB8vxdLJ9LX0yovXW7oJOqswbJKfeo
	bGxLbB9QdQ40myzCk9EHH9up0r3snVhHv9B+sFt5UcnnLgQvNxFvWZ3qPuwHU67e4ANB89efiIl
	Zy9uvN2ociUEtrcoGO/ljbYsMg/tzJCzzDa86ajV5oNp+L3DEARmEqdVOeRk4rKC055W/M=
X-Received: by 2002:a05:651c:198e:b0:383:1704:21ef with SMTP id
 38308e7fff4ca-385da028beamr17202181fa.25.1769224957961; Fri, 23 Jan 2026
 19:22:37 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-5-vernon2gm@gmail.com>
 <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev> <CACZaFFPCZfxG+FK9rrefFi1UmtWxiOf2j6KXx+9JDJfcHBz8ww@mail.gmail.com>
 <8fb6cba3-681a-4e63-9409-d35ab628d42c@linux.dev>
In-Reply-To: <8fb6cba3-681a-4e63-9409-d35ab628d42c@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sat, 24 Jan 2026 11:22:26 +0800
X-Gm-Features: AZwV_Qg5ILLAiNHXPpfsTwNfAhLAAwJGVM0zEQgcC0ZPGpvZ2LG36Z_uTgIgCfA
Message-ID: <CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
To: david@kernel.org, Lance Yang <lance.yang@linux.dev>, baohua@kernel.org, 
	dev.jain@arm.com
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DF691C0008
X-Stat-Signature: 1idwixu3z3rj1s434dnuejbg8ub79csd
X-HE-Tag: 1769224959-153689
X-HE-Meta: U2FsdGVkX1/QWe4t1hZh8VaCZP6OBDBPGo4K/artql9KdhrC/p1pJ0fvAnbK/HFTV/rsvg91yeaGpij/70NUh+xjrpdpb6VOyu5KPT07nGM0CqBCf0/XcqAuiNUXOz1yeH6vXc07usvG86/IE3iNpZwQwEtVEbKZqAt6dKIvgF5ZEJ0kUaWFWTILCfHB/X2/kXocQn4d8Qz4eXILAGmhdR/CFOlU9bwT2BNI3OcYg80JDF4N1WiKkqJlyi/nmKgcuBxiyhtReTlP4gOdYZXW3BBd+N3+JP3KJ7Tw5GEWj3mtQNNMVsD0fxQhQR53VMU978fXQSt2cP9rxBcTmpvG8Wq5LXhBYxnqvei46kCmQm8tkecMTzDimr90rGfL7zUZuZz/pq7rd2oDxSrt/Hu1PMKmCwWHpXHU888J49jd5zWoDnpVTzgRJ2isnp+/IqM/n5lyohOiz4n7WIieAQFnv0zpQ6pGGsUieNmruRB30h9qQr/Y+lKtQcwSGv2b4zGFMDKQJU/hNYj3f+VChhp+rneHGoW24m8/st7b1AfpyWYQF0w4hrO7N6irTH3px9+DqPkPVAuZ3W9CDXyNb/T0EdvTWDxHKvY2ioe3KuNRMt8EbKlwcqLxfogNtmmKLPKD0L+33ac4vAbwHGGm4OUs8KFX2FEiUPQcbS8Mo0jX6rfy/4uwnhQJflLXQjNlLrcROT/PnQy1GibAGXD8Si191wDt1R4xwp9LCOH2mCyLM8ZsrA862u9CxSdha6TuT2dH49uAeA4nqCldwjEzQJPMTnd/d2SiPTFdO+TQsDeN58tYhk13nHY02PkSYmNvJOPvx328PXm7HKukIsHiMOQN/lHPJKCd9R68gQ3tgb8P+LdqRVsp6+21nBq9Tm7wcSE/pBCJFiMvW2rbAgKdkpvUM6+730L7hgL+NIuvbILQnbALO1Zhr8ZOt7zGdf79NsF2aFGI57nUOOnwp/U8R0N
 7baKI+uN
 oOcNIZ2xklVh/JdZdAZj3V7BbD4Vh04Ma7Ez7GOAOIUnNfq/nP0snscmMmJXrQz8iAwCJ3PuoJv6WGuBAAFx2Mk5wIPEeTvNGaNbemlFYjVtTHVz6IqY4IxgcoA6py0L4QjgNs3Z4QCv7iFtoReL0Q+rxaafOr2CmmNWQCWkncMOpQZ2NMwKh/pkvArLJCY9Mj9FYJYQfTi9STuM4XTxtzYLh3SdTEzdqFg8GEXhsAIm2TupEvyrmMflo5WT6IPSoShieyHopH36eQk5G930UN5mHH8mrJskwds5KZ7Y0OkAakT6rCvZB2KyqcIJFXxOHRCpcZ7peWUmQwlJi5vNi0DYAxTO16+pYXkkEMohCDxt0dASmR2VZiguTMQFvER9fQ6vvx1cfLF0lRfBo1TlUCsRLcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 12:32=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
> On 2026/1/23 23:08, Vernon Yang wrote:
> > On Fri, Jan 23, 2026 at 5:09=E2=80=AFPM Lance Yang <lance.yang@linux.de=
v> wrote:
> >>
> >> On 2026/1/23 16:22, Vernon Yang wrote:
> >>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>
>
> [...]
>
> >>> @@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_iso=
late(struct vm_area_struct *vma,
> >>>                folio =3D page_folio(page);
> >>>                VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >>>
> >>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
> >>
> >> I'm wondering if we need "cc->is_khugepaged &&" as well here?
> >>
> >> We should allow users to enforce collapse via the madvise_collapse()
> >> path even if pages are marked lazyfree, IMHO.
> >
> > $ man madvise
> > MADV_COLLAPSE
> >          Perform a best-effort synchronous collapse of the native pages
> >          mapped by the memory range into Transparent Huge Pages (THPs).
> >
> > The semantics of MADV_COLLAPSE are best-effort and do not imply to enfo=
rce
> > collapsing, so we don't need "cc->is_khugepaged" here.
> >
> > We can imagine that if a user simultaneously uses MADV_FREE and
> > MADV_COLLAPSE, it indicates a misunderstanding of their semantics.
> > As the kernel, we need to safeguard the baseline.
>
> No. Afraid I don't think so.
>
> To be clear, what I meant by "enforce":
>
> Yep, MADV_COLLAPSE is best-effort - it can fail. But when users
> call MADV_COLLAPSE, they're explicitly asking for collapse.
>
> Compared to khugepaged just scanning around, that's already "enforce"
> - users are actively requesting it, not passively waiting for.
>
> Note that you're *breaking* userspace. Users would not be able
> to collapse the range where there are any lazyfree pages anymore,
> even when they explicitly call MADV_COLLAPSE.
>
> For khugepaged, skipping lazyfree makes sense.

I got your meaning, this is equivalent to two questions:

1. Does the semantics of best-effort imply any "enforce" meaning?
2. When madvise(MADV_FREE| MADV_COLLAPSE), do we want to collapse
   lazyfree folios?

This is a semantic warning, and I'd like to hear others' opinions.

> >
> >>> +                     result =3D SCAN_PAGE_LAZYFREE;
> >>> +                     goto out;
> >>> +             }
> >>> +
> >>>                /* See hpage_collapse_scan_pmd(). */
> >>>                if (folio_maybe_mapped_shared(folio)) {
> >>>                        ++shared;
> >>> @@ -1330,6 +1336,11 @@ static enum scan_result hpage_collapse_scan_pm=
d(struct mm_struct *mm,
> >>>                }
> >>>                folio =3D page_folio(page);
> >>>
> >>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
> >>
> >> Ditto.
> >>
> >>> +                     result =3D SCAN_PAGE_LAZYFREE;
> >>> +                     goto out_unmap;
> >>> +             }
> >>> +
> >>>                if (!folio_test_anon(folio)) {
> >>>                        result =3D SCAN_PAGE_ANON;
> >>>                        goto out_unmap;
> >>
>

