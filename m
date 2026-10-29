Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA56606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=bsYeDhCH
Received: by kanga.kvack.org (Postfix)
	id 6DB666B00EF; Thu, 29 Oct 2026 07:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C2F6B05B1; Thu, 29 Oct 2026 07:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A266B05B2; Thu, 29 Oct 2026 07:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 291246B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:33:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A77CB120346
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:33:05 +0000 (UTC)
X-FDA: 85375452330.02.BE4D93D
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F70A10000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:33:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bsYeDhCH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793273583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEsAp8eo59mWI4USMvrk2DfJuqFK7nYytkvtGnfb6o0=;
	b=s5zsc7mkpLQ9gXoGfnlrz+q4FdOsYlMyGdXEKt5lLYkt4EtLuQjhkCwPBW1uSse0NBuXI3
	YYygCVaOCr0oxicS+ygBczOnBKVFX05Arj3SqYoFKouexNwKLS+69Kqv+cgrnwntUVPiVt
	7QQnOFc400ylP96Uf+YilX1xBDQaT40=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bsYeDhCH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793273583;
	b=pFSFYgEBq0jH9K1zrwXts614HTwkS9HmLsZcrtTKVl5w7boXOSW8b14e0ZxWjCbQXPZB4e
	ctSDgbPkwDC1jduWlOm/dZU2F92WiAMz57uPf/a3yzYqTT7kId3XB1aI5qZYWYUkwbJgGb
	aJ6yFg3U5RfTMLX85kixPmDnBecziSU=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6e560e00a86so1519568eaf.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:33:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793273581; cv=none;
        d=google.com; s=arc-20260327;
        b=nonWJq+VsFW8gv0mn3yAO/xQqlXmGHE7j5iUqc8uu+w3t2wzsBXBZfci5zI2ItzFaK
         aOSZ2Kkq+1Haw1MjwlHRuf4GzFeqtnngWSgnOshT3Nb3be8d5GhPN/q4EsSsfLUcuZNJ
         LdhWf3DqXE2X0M1gypTtnIpwOm0j0IsN1PUIkSI4pWVZIYwwXTh+D1fOrGNOC93+ddTi
         WDo9uiDRny9RqMtQD5CfQlI1s/2Oz7eJe7VJWWrd/Hab6OYphCUgVXsbUoR/CRwrzzNU
         ceMPA2jyJ/pIOwDCz2GN9Lf7UOxGL9EwT0qobdGYVdHA6gcTpy14k6P7SoAOHiou1fLv
         PQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SEsAp8eo59mWI4USMvrk2DfJuqFK7nYytkvtGnfb6o0=;
        fh=F+QSX03V/jLLxpQXuQlU/zjtg/fXcHHpKSxFKRC9bfc=;
        b=erPwuFmJfpbFj8QxYG+nbPYPWejn+vYMdDmWZYIoxGG/CXUREFII1qiuWDoiZdIbGn
         5XjAiQI7shXLZVcZygrnhbTnGh3HKra22ZDNk5j/RaYNLPDOH3Hdw3WVwZQyO9UlYk2W
         0Eaymaf65kBQPovoPlg1xS/AlZVU8iVPfC98crHGZkfPqEne+A372ovcTE/JBXyVDV1q
         0te2YczPVU9JljVlG9r8mGQkUvkIuHPcu3EcVB/kV+xJUl2LcdRKcpjKj33H6RR0pL1s
         xcIHb/dCBV0JOkYPviw5V9d2sR5LB084UhQ2+JF/BYyTVQLtISaVSVvihVewtZ6ibwF7
         +dOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793273581; x=1793878381; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SEsAp8eo59mWI4USMvrk2DfJuqFK7nYytkvtGnfb6o0=;
        b=bsYeDhCHZYILO1oCjzvrk8ogSwg6Fx6YXLKfbO6ly0w6Fryi6p46G4kMYn2XD/iNQr
         6ovFu6h3VsUWjNQyaCqsayXDNGmGDFHGJM2MxMm1F+KXX82mOcKmv7XBKAZwjyeS2wh7
         ALHq7kUHfXnYwdrMFnrXsSbLe2dTbTG9j+6VlmZHh2AVCTgkO3Pi3sFN1uJkDE0HAK9I
         8vYapgV6wv+jPQUsQYOji2p8V/XS6xGMK5i/I35ensOZnuzIlEzdBC1cBJHEFidGbOWQ
         dp834G4AqI8Z6FKREVIezHdfFjK/HxP5a00WGpVWCLutm87jximpbQUeGoryXnguhS4x
         vwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793273581; x=1793878381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SEsAp8eo59mWI4USMvrk2DfJuqFK7nYytkvtGnfb6o0=;
        b=ooI4kDSGleBzI2iNY5y6lJPQCIKreVmF+ejfwgRVLO0oGly0dWFD+w3kpDljcpbq75
         dhGnUXpDsbh+72NuOwMnoxwEkJZwS0HcC04jrmMQtDk+f2/q4ULzdIVmdCUkO+eKwR7v
         ogj/7Wi1PtYDxAsWUYvpq+/WlwP16FgzlLl7OTwNhZUrm66ezhG/5ieS/zzIMSjzUsfR
         n3orP+y8ab6uButTR+YigU3DlGuwRvQFaFbIdQR2dsKG/qGr+gC9408GgXTd5lokoiiZ
         WX6R8wyK2YZEb2Y7w3f1ykMvZfE3mmLhU77MHT+X2a+LjcQPErCz4jgzhSh6+Hgrlkwg
         V6rw==
X-Forwarded-Encrypted: i=1; AKwUvBwnAQ4x5/uvfHxeeMx4dbdgokGPVgpg7C/IiOMIP0RUHh1Bu2ZZAOVipYyxLbXvNyK97K83zSKSvA==@kvack.org
X-Gm-Message-State: AFq9FYJUXi2zV3s2ZVGfKIMIhWzva25Mw4K08OM/V6ZrpzJ//O9Pca1I
	tOT3l8vU0nP+weal1Yuc5HWp/Kb7QpgM6QZ8qfAGrTRqSH3w+x+otnlsU7rqpAz4R3+Gx01LteE
	0TnZhl7gr4sVSf4pVqrM99nvh4x2HVnxJt94eG1amvQ==
X-Gm-Gg: AYBFou2OkUVMWydGOUuhrFB2akiLj17+gB6mtkgADL4YwOqKyBKUYXUIwjQtBmVZTvP
	MQYGuHo1QTXlkip063YyCCvHMvnHGWbRrVCmCAGigUCP4KlCIMh5bPNm6NYv2t2wzhmM4GHPF9Y
	GIZBe0mlTpml5fG6EXuVXFs9l1HY1kklKfqWpokkQXNl37ziz3gQ7A5VpwlaaaaiSXzeuTR0PHc
	9zHJhx2zJPFLq+SV8hHndVa3Hd71Es4wh02afux9rlR7Z5U42o0/yeGXjxGRYvgd3K2z9GXw22D
	/0zYQVTGld2wVai4BY8jud3gBcyZG5bwv02mliujNYezDWpnCiOeUziVLd2XRYs6tgNXklmAK1x
	OsxtEXe+QMVR28DUpkKVBcCsWTrUkSb0T/HiKu0C2oLytu23sIef4Kkgi4JArYlqpoF30Jcw=
X-Received: by 2002:a05:6820:a514:10b0:70e:2d38:4b70 with SMTP id
 006d021491bc7-713eef43a73mr2044037eaf.7.1793273580795; Thu, 29 Oct 2026
 04:33:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
 <anQyoZgi5Urnvvjw@lucifer> <919b804b-6f1d-417e-9c0c-d06f50d765d8@kernel.org>
 <anSar_i8UjniSbML@lucifer> <a6a9e0cc-e6cf-4f83-b6be-7d64058b8fa6@kernel.org>
 <anSqbW1w2bDDHpAx@lucifer> <CAEEQ3wmJoUF5TDQDfMU_dUHnY+gg7MYG=OmmdB3Ynpdu9gJ7-g@mail.gmail.com>
 <3882e553-4be3-4b2d-b884-4443032e7853@kernel.org>
In-Reply-To: <3882e553-4be3-4b2d-b884-4443032e7853@kernel.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Thu, 29 Oct 2026 19:32:49 +0800
X-Gm-Features: AclHuK-NsCthzCzymfm9IrdjWCbL02wiGiuXLxLhRNRDCgpTPiA9M8Ic3D1KQcI
Message-ID: <CAEEQ3w=t4fCXZSqDUZ+XQCJ7UhtrKz+TSM=H8y=JvdAoJG9NXQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] mm/madvise: avoid skipping pages after
 splitting large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, jannh@google.com, 00moses.alexander00@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5F70A10000C
X-Stat-Signature: 9yabg15zrp3k3wuyeoeri11ix1ke3819
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793273582-535935
X-HE-Meta: U2FsdGVkX1//SU7wn/52QmCBFAwFwHErNl/6MevyTH2okdtj1K/qGFGD+LYphT28UnWjdkxFLjPk8+b8+r71SjR74MCSaHqfjwFyydBlqIQlx6CETaHObQ8nD60PmlMeWlVA+FFlPOHJ6GgGTvshUxsuBQVXFHFJjqNNvdjMKv5XnfT0gujsZNyklJ/buBANSCQaJL5fxA1arT/naM4JBebO8BbAacnw9/i3ly5guJJTYi1E51LAGCqOfLR5zSiDcn5FZMTCcRZihUVShGXREojW4xbdL/xGn97uZsskeeg0SLyHmIQzdZIIWV9DNrWapawVv+2Ne9227xFUq1N79TjUf141oUJqHAscVwoMLIv/5fo+eATBwxogqnCweAU/Fq1faRnFK5cnVPDE0EIg0M93r/HwLXtefGWHBCcO0bhQ1Xy/ZUM1IFaziObCiWzrh8n9qfycKDaYMOfxlzmkcUgAUI5zUc0/u2J3P3Ub3VnFv30f5/mJqjThDiZ7vPNf4E1BWc2pP75yyFiFqRFzKcsPXogz1+L5C3GqnQRABuxx2CqG+uPcafHRKA3smihrE/Q90dxvkReH2vp1dweQXTjpDnuqIlgv5wsc1lrXZFi/MnCCbaJwrws7JZzRkocgupg8mBi3MbOeaemKKqmxLJP4Vbgc1YrJoZ5xnFXwCyu9K9ErPQmRYf+ruij1938ACCLjIl2mogC9veiAtXPfyefwqTKtul7OaBBPAVJsuXhQFaNexkJSGgBDx4zktHyPY1iG1yrmapjivwb2wdO1jLEIrbyRBD2IPAVJMJUzoq8gupmOmw38F2OeUWCGxR0dpTjx2OXOm9IvLHlAwNkQf6zYgk8u6sKfro4iXdgsj31ZZ0EruEJbODNfM/Ac+dLRzt/sdUhoEPMyyMivl3l7xKkUBCZcr8e4th5zruIBYjb42N9ypUMpJHzW80oRtFwCLuDC17MSQxp3VEL2wj8
 PXFb+Fqr
 D2VdsfMcymxRChQ5MTWQ4DBPrpBsHZKHyVO98iXq+N1PMTYVfQo4OFYJ4+Tb9t82P4uZvphCwbCYxvmOIh0+Wa9B78QasJfnr1IDDby2D0o2IikGf8tAHzR3gMga9h/9f1GE12jZyKMPnQJoyjAhy0wJjMlj12+VVdQOi3RJylinzIo1V9EV2zoD8XLU2+zRIhdE8gYWLbqaLrzbfZ1uDWDh90vnh+tDnBTQjADyF7vDSfsYaP+h58FIUeC9sRXXxDycEDzg4gGaOFG0PDXa2b7i2nh6/nrPF2muJx6TQG4TvfPO1x9VnqygEBiI+ap4d8Wo2ZruuLGubX8kMkNx0/8oW+ZWqpYfQd8LmPGCqnPLcTpj8COAReFZ/RIESYpvyPPANDgANZ+KK2PRmhgxBJQYjOKo7wh+S1nf/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Tue, Aug 11, 2026 at 10:49=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/11/26 04:31, yunhui cui wrote:
> > Hi Andrew, David, Lorenzo,
> >
> > On Thu, Aug 6, 2026 at 11:40=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> >>
> >> On Thu, Aug 06, 2026 at 04:46:10PM +0200, David Hildenbrand (Arm) wrot=
e:
> >>>
> >>> We GUP'ed a single page and now try to be smart about which other pag=
es we'd GUP
> >>> next.
> >>>
> >>> That's just wrong, and hugetlb special-casing is just ugly.
> >>>
> >>> The problem here is that, if we GUP'ed a page and poisoned it, the GU=
P'ing the
> >>> next page might fail and we'd return an error.
> >>>
> >>> But maybe that error can simply be handled? We have FOLL_HWPOISON.
> >>>
> >>> So maybe we can just use FOLL_HWPOISON and skip over the entries that=
 already
> >>> return -EHWPOISON?
> >>
> >> Yup this is ugly debug code so that works for me.
> >
> > Thank you for the review. Based on your feedback, I went back through t=
he
> > madvise, GUP, soft-offline, and memory-failure paths and outlined the
> > changes I plan to make for the next revision.
> >
> > The issue is that using a page obtained for one address to infer how fa=
r
> > the range walker can advance is the wrong abstraction.
> >
> > For an anonymous large folio, soft_offline_page() splits the folio to
> > order-0 and handles only the supplied base-page PFN. Advancing by the
> > pre-split folio size can therefore skip the remaining base pages while
> > madvise() still returns success.
> >
> > Lorenzo also raised the semantics of a range that covers only part of a
> > hugetlb page. Looking at a range that crosses a hugetlb boundary expose=
s
> > another problem. For example, with two 2 MiB hugepages:
> >
> > hugepage A: [0, 2 MiB)
> > hugepage B: [2 MiB, 4 MiB)
> > requested range: [2 MiB - 4 KiB, 2 MiB + 4 KiB)
> >
> > The first GUP resolves the last base page in hugepage A. Adding the ful=
l
> > 2 MiB hugepage size to that unaligned address produces the next address
> > at 4 MiB - 4 KiB. That is already beyond the requested end at
> > 2 MiB + 4 KiB, so the loop terminates without ever visiting hugepage B.
> >
> > For MADV_SOFT_OFFLINE:
> >
> > - ordinary pages and large folios advance by PAGE_SIZE because
> >   soft_offline_page() handles the supplied base-page PFN after any spli=
t;
> >
> > - hugetlb advances to the end of the current hugepage because successfu=
l
> >   soft-offline migrates the complete hugepage and leaves a healthy
> >   replacement mapped. If the walker advanced by PAGE_SIZE, its next GUP
> >   would resolve that healthy replacement and soft-offline the same virt=
ual
> >   hugepage again;
> >
> > - ZONE_DEVICE does not need a stride case because soft_offline_page()
> >   rejects it.
> >
> > Advancing to the current hugepage boundary, rather than adding the huge=
page
> > size to the original unaligned address, lets the next iteration start
> > exactly at hugepage B.
> >
> > For MADV_HWPOISON, I plan to follow David's suggestion and walk at
> > PAGE_SIZE using:
> >
> > get_user_pages_unlocked(start, 1, &page,
> > FOLL_GET | FOLL_HWPOISON)
> >
> > get_user_pages_unlocked() is the appropriate interface here because the
> > current gup_fast_fallback() flag mask rejects FOLL_HWPOISON, while the
> > memory-failure madvise path enters madvise_inject_error() without
> > mmap_lock held. get_user_pages_unlocked() acquires and releases mmap_lo=
ck
> > internally, handles fault retries, and propagates -EHWPOISON from the
> > fault path. FOLL_GET makes the page-reference ownership consumed by
> > MF_COUNT_INCREASED explicit.
> >
> > A successful GUP is followed by memory_failure(). If GUP returns
> > -EHWPOISON, the address was already covered by an earlier larger-granul=
arity
> > injection, so the walker continues with the next base-page address. Oth=
er
> > errors are returned. This avoids hugetlb, DAX, and folio-size inference=
 in
> > the MADV_HWPOISON caller.
> >
> > Device DAX is relevant only to MADV_HWPOISON because
> > MADV_SOFT_OFFLINE rejects ZONE_DEVICE pages. Since the proposed
> > MADV_HWPOISON walker advances by PAGE_SIZE and uses each GUP result as
> > feedback rather than inferring the handled range from folio_size(), it
> > should also avoid the same granularity problem for Device DAX. A
> > successful GUP is passed to memory_failure(), while -EHWPOISON indicate=
s
> > that the address was already covered by an earlier injection. Advancing
> > by PAGE_SIZE should therefore also work for Device DAX in principle. I =
do
> > not currently have a suitable Device DAX setup, so this remains unteste=
d
> > at runtime.
> >
> > Because MADV_SOFT_OFFLINE must advance past a hugetlb replacement while
> > MADV_HWPOISON can use FOLL_HWPOISON feedback during a PAGE_SIZE walk, I
> > plan to use separate walking models for the two operations.
> >
> > Before posting another revision, I plan to split the work into:
> >
> > 1. the MADV_SOFT_OFFLINE range-walk fix;
> > 2. MADV_SOFT_OFFLINE large-folio and hugetlb selftests;
> > 3. the PAGE_SIZE + FOLL_HWPOISON MADV_HWPOISON walker;
> > 4. MADV_HWPOISON large-folio and hugetlb selftests.
> >
> > Does this separation of the SOFT_OFFLINE and HWPOISON walking models lo=
ok
> > reasonable?
> As Lorenzo says, this reads AI generated.
>
> I assume what you mean is:
>
> MADV_HWPOISON will actually hwpoison the pages. We can just use FOLL_HWPO=
ISON +
> -EHWPOISON and should be good. So far the theory.
>
> MADV_SOFT_OFFLINE will migrate pages instead. So if we don't skip multipl=
e
> pages, we could end up migrating multiple times (and setting hwpoison mul=
tiple
> times).
>
> Well, for large folios (except hugetlb) that's not a problem, because we =
try
> splitting to order-0 either way, and if that fails, we bail out.
>
> So what remains is hugetlb, which is nasty.
>
> I don't really enjoy having any special-casing here, because the moment w=
e e.g.,
> change how soft-offlining deals with splitting, we would be in trouble.
>
> Assume we start support splitting to min-order at some point, we'd also w=
ant o
> skip over min-order. Gah.
>
>
> Can we just make our life easier and disallow specifying ranges for
> MADV_HWPOISON/MADV_SOFT_OFFLINE?
>
> It's a pure testing interface IIRC. tools/testing/selftests/mm/memory-fai=
lure.c
> seems to always call it with PAGE_SIZE. Similarly
> tools/testing/selftests/mm/hugetlb-read-hwpoison.c
>
> There is one catch I think: an existing LTP test case issues MADV_SOFT_OF=
FLINE
> on a larger range. But it respects -EINVAL at least :)
>
> So we could return -EINVAL and fixup the test case to issue multiple madv=
ise().
>
> [1]
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sy=
scalls/move_pages/move_pages12.c

Sorry for the late reply, and thanks for the feedback.

This turned out to be more involved than I expected. I am not an
expert in the memory-failure/hugetlb area, so if someone is interested in
taking it over, that would be appreciated.

Thanks,
Yunhui

>
> --
> Cheers,
>
> David

