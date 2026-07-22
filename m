Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500FAC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 19:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302816B008C; Wed, 22 Jul 2026 15:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B26B6B0093; Wed, 22 Jul 2026 15:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1C76B00BF; Wed, 22 Jul 2026 15:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9F666B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:17:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 386F0802B7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:17:28 +0000 (UTC)
X-FDA: 85017371376.19.B2636A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C568F18000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:17:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O+6qEmKc;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784747846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgADKQPfJd1AEoeiRdVbxkdpyLJkdcTqBLoWey7SyyQ=;
	b=UaS2l3pv05c7mZxJrAHpJ4DBo6tUHgm+X3MUEhSNYrQIcG9HsZQpAmNvTcP71zKbv1SJCm
	99UBLjoPgflz6iRnk0pKibijwqhjQttNL459aUD4HVrTKVA5DBIha0jFD3zI8/Ydcf37fk
	HOu0DpXA4dItbmwwHK5Ki0COXWAFRiM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O+6qEmKc;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784747846;
	b=2BK/pFB/XlITuiyGXKDUg5xzml4jhbxt2GqOVSSQbtbYpM2PKzXdsm+J3GKjrW7SjjoiYy
	ZRqfnHZpXnx86U8/7hLRFy4qnWWP0Vcl8ydLprmoxKlI+yCyf3yHfnxA67NPtds9acdyHC
	w5Lz60x5jH/CwKxQpcCRY7OrlmGolMU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784747845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fgADKQPfJd1AEoeiRdVbxkdpyLJkdcTqBLoWey7SyyQ=;
	b=O+6qEmKcPx//eIoMU06K8vhMLZafvZKhf5kmtufkW1Wd3mDDeXwe5UfYmq05niaHSY9AtV
	z5F3ye941bvP+j3yFmunG7eYrIx9MarbTwy8ZIt2LZT0vIvCtaBcMaLttqZ4h2C6oyqSdq
	0SOvirEzi5H7XmeeePie4xbYkhLz7J4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-QRuPH5fEPcecr-1kNrFoqg-1; Wed, 22 Jul 2026 15:17:24 -0400
X-MC-Unique: QRuPH5fEPcecr-1kNrFoqg-1
X-Mimecast-MFC-AGG-ID: QRuPH5fEPcecr-1kNrFoqg_1784747842
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3998d89ef9eso59759951fa.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784747842; x=1785352642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fgADKQPfJd1AEoeiRdVbxkdpyLJkdcTqBLoWey7SyyQ=;
        b=XzglY1LiTP8EbfqRbOVStdZBa6FBFNefoeTZ98WhQLsOsdVKjIxTF1hu8yOD+aaN9r
         PQFDByv8yJck4nx56tTK0i4YbtohzYJpcUVTn9Y+L4QK24n3x1DBOa+RWBuzaMYON0ih
         5CXVrj39zLO+CLRURK0tGCZLlawlvccur+fFnoozIBfr1WUf1PWNCCweoQNWYZj7mWAo
         yDDHXAmP6Dlro6QcB8dVHivJfnIv1dTR9CLo4AA/ouMUL7wmKOoZ8ut+5a1jIB2su4u2
         tisLVs6qbzYtVPACYgFwCE44kYUp33TwFHoqEOW8fFdMHtwh3qOkV7uzQxaBlBAD1VtX
         UAYQ==
X-Forwarded-Encrypted: i=1; AHgh+RovCsPYlRXkjTcQdTcuRiG2kvjF+pHTvCaLLDrYL5jUW068qB2wlU79r11rOTJkuQx065IqB3rGiQ==@kvack.org
X-Gm-Message-State: AOJu0YzItpf4G/2sAkojA0MpEMJ8urHxDB63d+yPgrg4b+kJzyVKBWcm
	fuWaHk0jiObmO0RJnZ8QnDfWRX6knS2eygFeAPkAaDCSMAh9q19geXhbK9ggh8of/RXkY0+EI9M
	xwe43wGEd9Hry4J4npDgmReu3JY5evhOqeQ3x2jthb6tI4gug5PIAp1v6wA5SEJDaQutKqC0yNw
	jKP1iY78TIxYwXuAeGAmZ3VfBuKas=
X-Gm-Gg: AR+sD11SsKwBiDCBmdyEbHHIu/Ikip4I4DknoD4D4zqWODjmjGzp8fjzSOKgtX1JGT4
	/24lUCE/lkeh3VdgHz2V3Y2LLPVYUV4q3b5mX29URdo/8j8QVQAS2ftvsAGh21ptV1w4307F4f/
	oe+SExkMo6IgIA5akOddA93lLUxw0VqQYleUw8jRGqii27T1BkFh7b8g==
X-Received: by 2002:a05:651c:1442:b0:39c:7d51:70de with SMTP id 38308e7fff4ca-39f07ec9fe4mr5421fa.24.1784747842210;
        Wed, 22 Jul 2026 12:17:22 -0700 (PDT)
X-Received: by 2002:a05:651c:1442:b0:39c:7d51:70de with SMTP id
 38308e7fff4ca-39f07ec9fe4mr5071fa.24.1784747840707; Wed, 22 Jul 2026 12:17:20
 -0700 (PDT)
MIME-Version: 1.0
References: <20260717064502.1980173-1-npache@redhat.com> <20260717182947.534af296aaa1831d13f8ae6d@linux-foundation.org>
 <CAA1CXcCrA9nrraxVNTdo19TRONvqM-fndSbDaCib4tZCmQC9tw@mail.gmail.com> <5766bfae-8dd9-4542-bbab-324dbde0e2f5@kernel.org>
In-Reply-To: <5766bfae-8dd9-4542-bbab-324dbde0e2f5@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 22 Jul 2026 13:18:46 -0600
X-Gm-Features: AUfX_mxBP6oQ9YP4CSpm6uLN70-PCju-h_3ep9e5ccbsKoOnsmvoI6BqZQW6fM4
Message-ID: <CAA1CXcCFrnw4K+yStkmdEOdfn+9XJd4tXYNyOnBKobLo_WRX0w@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm: fix PMD level mTHP accounting bugs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>, 
	Barry Song <baohua@kernel.org>, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HQ8Yh6_VqlFKGxyZ_syK5nvONf8W8zaS4sXcKI-cg0w_1784747842
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C568F18000C
X-Stat-Signature: qym1jeq1pdjz75ng44emh3o7yd9fq63t
X-HE-Tag: 1784747845-271975
X-HE-Meta: U2FsdGVkX1/zpcBo8z52u41hwg0YjX0k68JbaYRiDNaVSZC5TH7ur6MXxUiL6wGXvhZpfFmlAQG30v15Z9fzdkRTd2o2l/M7xZFverBZU2mDOX10sNQ0B0uJCVJeL9+ToEejcQZUK591jnrQ3pWM2TtSwCwZazzMLDlaNbya/N+OiNsk5eO+spxxWU0nWP9IXDVjwHLmBxrBBFsa2cjbODgz3ItMkBTOQBTImJTJTKDAsTuizNSpQgcV2G2t2GU7B014ctscjMUsMGbv/0HkE/sqk9yXvUCp0a9C1C3R2g8281XyUS494sRNETVQluNqOVz6Bt0nTszh1v37+VwtEtddonligx4qhmM2h+7zSKW9UOM4ZlUf0um2UgWZfCvyoMkfch2ju47uU/adZkqhgoadcj6PMsNF55W3L2XG1PLBb98wz+NhPM7ixgUIHslX8B+Gpbs1x5tKPP5hcOn1mvRiKdFSarpHoqOpjmE8p8DZ/ppBQSoauxE1druHTla8SEruFJ0oUpPNDynvhRdlruRAsUFMegGzmm0VlccOYErYijdqNaOiPgJRgww8/cULvKpgj6tGF2ywjE3we3RNIa5I+mMMTdDxZnlLMbcv1oZlhRafANeJImnesJCr97JqQR2AFT0JIqXf+pvvdCbYcyrzVoxs4a2ELSfCJkx3h7CIrS+3BuRKErQvw2HV5KYInKNgl22+x2MhUWDaK120QV4iWEG8qP0YkV/NMWfinax+RVVU276bnnkIvGD9FtLk/GHxH8neGrzkAvSD6OMo4nwgiUPLDATJR7P6U6MM1BVvf8xcp2zto3Jwsu5KNVKL+nR5paG3C+EcDZEBB52CeH4m3hD/E5TjIgdH/nx1G+qVQTe9GLJPVh4KG8PIGHklllPl2pQqhbh5Kx/l8uZHx+LfivtJJovvZNNLjmfusJoOJdDtYlVUt9PTgOTU7xoBmppnnmLxBWqtoP0vzOH
 vnahxsMt
 puk/H5NHvy/MMcPkTjWZXExfXGXplg0CzxIcypKyGwhsS4PixOZjpWOqeDA/9YJgUH7Mwi5xPy5gpO3RnwMODjqkoRPNa/gzXiuhq5X+emZesBuMoNHb+mp/SW87bo26pKXdJL4iMDQJjtCapV9eoA/AI3PJE0RGHktXM5BrPazc71zYRAoMTa7Bx6U53mnH9nzEN5rezc5MkyhuF0ZjvkrLSIG/06cmtDoiT49XSIOJlo7XUU+6gEZqbOmVsx4ODh/sQUkhEGLCvHHwANmbDhUPxUz10jRHd24IRjzqEkizosAdZFKONldZB1KvxQmLy6QgDhpctj5XQx03BSN48TqeUeOP9Z2vsTrxDnjlLzsThqwTCC3qOaV1/y3zpBd79MlYgLOFqBDEdBnR0yJ5GYjGNGxJANyTurA8I3qyZJA6nXfLWipKY5CfpG+RV1G63dn9Qrzjx+B4BzHKF1Pj64qGVNAPYx1pxQIjg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 8:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/21/26 15:57, Nico Pache wrote:
> > On Fri, Jul 17, 2026 at 7:29=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> >>
> >> On Fri, 17 Jul 2026 00:44:58 -0600 Nico Pache <npache@redhat.com> wrot=
e:
> >>
> >>> While running selftests I noticed the PMD level per-mTHP stats (nr_an=
on)
> >>> remained elevated after each run. After further investigation I notic=
ed
> >>> this accounting error occurs for both the migration.private_anon_htlb=
_test
> >>> and the HMM tests.
> >>>
> >>> In the HMM case this is due to folio_add_new_anon_rmap() incrementing=
 the
> >>> mTHP stats, but never containing a corresponding decrement in
> >>> free_zone_device_folio(). We solve this by making sure to decrement t=
he
> >>> counter when freeing device memory.
> >>>
> >>> In the migration case, we are incrementing this counter without first
> >>> checking whether this folio is a hugetlb folio, which relies on a sep=
arate
> >>> accounting system. We solve this by adding the proper hugetlb check b=
efore
> >>> incrementing this counter.
> >>>
> >>> With these changes in place, the two tests no longer cause elevated P=
MD
> >>> level accounting issues.
> >>
> >> Thanks, I've updated mm.git's mm-hotfixes-unstable branch to this
> >> version.
> >
> > Thanks!
> >
> >>
> >> Sashiko is worried about the existing code ("list corruption or a
> >> use-after-free panic"):
> >>         https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache=
@redhat.com
> >
> > https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache@redhat.c=
om
> >
> > I dug into this, although I'm not very familiar with device memory.
>
> In general: Don't let a tool waste your time on unrelated things if it wa=
sn't
> you that asked the tool for it. Someone else asked the tool to find unrel=
ated
> things.

Ok sounds good. It flagged the same issue in both of my submissions so
I figured I'd investigate. It also helped me better understand the
code by forcing me to dig.

>
> I thought we only support anonymous THP for device-private, not device-co=
herent.

Device-coherent has PMD support; albiet I dont think there are many
users of using the MIGRATE_VMA_SELECT_COMPOUND flag.

I think Matthew is fixing this from a different perspective. Teach the
split code how to handle this.
https://lore.kernel.org/lkml/20260722044220.1110278-1-matthew.brost@intel.c=
om/#t

Zi made some comments about it there.

-- Nico

>
> Maybe lib/test_hmm.c could somehow trigger it by selecting
> MIGRATE_VMA_SELECT_COMPOUND?
>
> But in migrate_device_coherent_folio() we have
>
>         WARN_ON_ONCE(folio_test_large(folio));
>
> So this would already be pretty broken and I wouldn't spend any more time=
 on it.



>
> --
> Cheers,
>
> David
>


