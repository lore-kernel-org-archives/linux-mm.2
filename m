Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E5AC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 10:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CB26B0088; Sat,  5 Sep 2026 06:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D036B0092; Sat,  5 Sep 2026 06:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C230D6B0095; Sat,  5 Sep 2026 06:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9ADF6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:49:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35933C0302
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:49:45 +0000 (UTC)
X-FDA: 85179387930.02.95CEC58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5A78DC0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:49:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GxKP0rvU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788605383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHAA100hBxoZ3L71lKyk+AmwOPI0P6UvpAuNgR702wU=;
	b=Zay0TPDpQ3bZSd2oIMb99K+uAnqtODHT5ZFTjoshcNyBmL9mov0SVS5xj3QN/NtnbgJ5Po
	MlQpSB0eJJfTeEyEdc/RoOii3e8f5oa+Nr4hsaFlqDwgjayWvuEOqgdmrO8vLyUsz4toq0
	HLiHeql7Q3JcMRN+m5l2Y2MixNUu9Ns=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GxKP0rvU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788605383;
	b=kfNpbbGK1Zr2JTo3b2vugTHRCcXgWLhcR/o9kk3qet2sT89dfcvJ6gcXMuUKMFmt+qmXAJ
	qnttrVq7ZXy/R48C9iF2ryQCZHYSQiR/Y/3Z+mtb9oG75LU7imSUczwPnYUss6kd2TQ5zq
	QdccepRdt3v3Ay/+vyP8fyaYVYJ+jNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10DB0602C8
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB921F01562
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788605381;
	bh=RHAA100hBxoZ3L71lKyk+AmwOPI0P6UvpAuNgR702wU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GxKP0rvUTM1WVaoYWsYbGz9meyuaamSxHMeFLXYm78ZWYmU4OAavJs0kDNE2HR3X+
	 2/nCp8lZPKTgJ7oF64mYgppRgHVvRxi6mY6J9aum5YnBocruHheq2eHYdHg2+jcntw
	 kYHnJRxU1O8oFW9HZD8vh+30sr5Ns5iMbPzLcJ50c2k+vCG6NItKSPPacRaUqvGmRj
	 KQ6uWFyvqLekfQIbbcdJC3VZ/s2HlR6NHKL28hvK2gJoGW+FcAZHbKA+S4uqvGfjsA
	 teB1/pi3kfIfebNqTOHiq0WMZJ8memmBjczuLnxAarBjV33jXEihuQkvk+xvKar3yM
	 gfZFGv1aR7X5g==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93900ed2925so162974785a.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 03:49:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByJnpmvUhGSGXJ9eNIpUAoOHkUtefw20enUkNVeJKWy70OK+op1jGFQlN1iTW4wYpAQ9hDyiwACdg==@kvack.org
X-Gm-Message-State: AFuF++lbTlWagpFIxkEqnCVX5ZQu38GEvkCIxWtAoXuG8ytBBv3buimU
	bUf44rwL2XJkKlseOukz8C7yyVy6uIIKP9h1CTA2noDLTk9yW97GbTxp7Asxoku36TD30FzBiu6
	uWbbBMIpo4LZ9/DGs4j2jwlkmclDGSi4=
X-Received: by 2002:a05:620a:27c4:b0:92b:5408:b6be with SMTP id
 af79cd13be357-9398037370amr1199846885a.23.1788605380850; Sat, 05 Sep 2026
 03:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-6-dev.jain@arm.com>
 <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 5 Sep 2026 18:49:29 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xmeEQWoPsda2qfLh=E=tC5TgNZChTYENu4f+zPqibf-w@mail.gmail.com>
X-Gm-Features: AcwNN1VVa-rvJYwwVPRxR_MMRDJhw3RmKWC3O0AZSlLS_T3XLrO55yM2YEBtp44
Message-ID: <CAGsJ_4xmeEQWoPsda2qfLh=E=tC5TgNZChTYENu4f+zPqibf-w@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 51by3smx1tkhydtsaq4uhhs4bohwu6pz
X-Rspamd-Queue-Id: 5A78DC0004
X-HE-Tag: 1788605383-58117
X-HE-Meta: U2FsdGVkX1+M0c7M0ZvnAB+OJNFH/gq8klo2n37nxDILvXUT7AnvSupEwAT+4Du6KAE4JHCRS+JGC48LcuZN3ASIpTgfX4OF7tULxLXuZVoliISzGJ86+ipSgSbBNkPsgcilKmE5XVPiQIcex4LDDmfV9t0xBvTsgsetVl1nl9TWHLUx1OusEPNrQxrM7f55PHmzaFAvHWyjcDRfoNsxFUQyn6zG+ijQTRuQ30BHV+WaV7bszrQ21HaDDJwWO4jsHzEd4H+GIw4XC9/zEkZObKyG5vAjLtZ0p9tkov3HNWKthbRVc8iZH7ioJp7DsGEKWicuIF2RI0mCJpLHvbpiWK4PJpMYDyFmy4DmXkF2BrRZDvuCsr0S4GuJnQkJDm8bKW6A4Rbq9LjYJeKs292V3Gx1pXn1K6d9qK4CZvmQY74/Ow6Q9PSkVXRvWwnGiJBZ8WvSGp6FHEmfDTPxf8iw+dUzm80Ek1Jp75WDocMS+y6A3AjvD0sNDFzbqjkyxAb1cjBiHK9yC+47WeI0cEOU9gdULlmzWMO5bkxC9tdcSkawUVpesbVSLSiW6+qBxMX46fRQwfDzfR/xC3uhbDVYfJ9wkTindNzLf02x3vEuEsDNILgM6FtZLCcXt1TdmvaPfWWRbAXMdZbscl4A6piEasc6cr1+SPs+6eigkomSScxKzISyzU0ZAxD0Uv0BW+2o0JynATd/D5aZCiRll9VlAzUTHt0agSyT4HK1cNNxKSubg4Rx6828GZwiL7wn0RdNFf3yxvtXgyJc5h9L4S4lI2jGoRMUg5jYBEnwsWPBKarYT2a3TdlKOlRZmFA72qjehupcCYwj/e3NCIaxum6gOmdTnaKBycu9CdCdKzvONdBBG3aqBKgs+OEMSzcCZLtsD27QjgnoZOXU2vLsk4F8BUh6n/yRNtc6fC1cpoih+2JS7dXjnZ1dTVapqr1PCPMJqepMmEGWsKEwblXoH0v
 TpFz9Qjf
 CwjWtdaM6ReXeONlLL4S4B8+WCMPqIZkPcwkJLzBANWQIeVN0OsO/GMxYQRQDowcRKxgOe0j9TwSN2j8YC2ON4JI18qssnxXjJwCeIfs8BAE/Y7eMvps7q+SQM6IFWqsOBXd+gfTe2NBGusQQ04T6o9VaUJVffzZdsUX/Y/uWgGGbokiFvSSTeFvMpy2TBQNocXrE0aB7Rcpj35v255KZQhF6gYeWDghgak1+c/r2FTB50tf+Glk10+IxLOBDYcxvAgpaq1OHkgn5WfDOe4CDB1sGKdsL9eCkXLjGkerhBZX393VQXuWUg4nQ/Rxvjo7kv9SegDrMVKN0vQ8dHlycYFDUiI/TZrd9eJmeb9nADrPT7j2JSokGdvzU9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 5, 2026 at 6:42=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Tue, Sep 1, 2026 at 1:44=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
> >
> > In preparation for adding a helper to set softleaf ptes in one go,
> > generalize the swap entry helpers shifting the swap offset by delta,
> > for softleaves.
> >
> > Note that the soft-dirty bit, exclusive bit and uffd bit preservation
> > will still work for non-swap softleaves, since a softleaf entry is
> > constructed out of a type and offset, and those bits are ahead of
> > the soft-dirty, exclusive and uffd bits.
> >
> > For example, for a migration entry, pte_swp_exclusive() will return
> > false, as the exclusivity is encoded in the type itself
> > (SOFTLEAF_MIGRATION_READ_EXCLUSIVE).
>
> I don't quite understand why you mention this. Is anyone calling
> `pte_swp_exclusive()` on a migration entry? Shouldn't it only be called
> when `softleaf_is_swap()` is true?

Is it the rename from `pte_move_swp_offset()` to
`pte_move_softleaf_offset()` here that is causing this semantic confusion?

static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
{
        const softleaf_t entry =3D softleaf_from_pte(pte);
        pte_t new =3D __swp_entry_to_pte(__swp_entry(swp_type(entry),
                                                   (swp_offset(entry)
+ delta)));

        if (pte_swp_soft_dirty(pte))
                new =3D pte_swp_mksoft_dirty(new);
        if (pte_swp_exclusive(pte))
                new =3D pte_swp_mkexclusive(new);
        if (pte_swp_uffd(pte))
                new =3D pte_swp_mkuffd(new);

        return new;
}

If so, I wonder if it would be better not to rely on the implicit
assumption that the softleaf type and offset fields are laid out before
the soft-dirty, exclusive, and uffd bits. Could we make this explicit
in the code?

