Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D174DC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93A26B008A; Thu, 10 Sep 2026 00:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A442A6B008C; Thu, 10 Sep 2026 00:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932AC6B0092; Thu, 10 Sep 2026 00:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76BE66B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:58:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0115A0421
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:58:50 +0000 (UTC)
X-FDA: 85196647620.10.8840FE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC79240003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:58:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwxxO40Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwxxO40Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789016329;
	b=r3fR0qVhbwSvd59pL3qjl4QKO5SnzAxsOW+RFnob33glaof9gYSdG1aYATIf2+r9j4mGC3
	JGD/Jq98nmal8KXdHQfJdPOp6gihCN+y2UfVCtsV0xBa9Geio+0ITT4528MdJV9EpOnzA1
	veHUyxabo3DLX2952Wu4jNZTrNRIPbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789016329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaJUvdpDpUDbSBpSVuw1s5uwDKMSoFFuKQIxHId5d8c=;
	b=TnTONepjGF1LHXigzwQ98ICC6DcO+9UWM4rGbO+WeZ/Kl5wsEEbNWMK20rbTCBTsp3BsSD
	IrgPB2Il8HQy+kmPYakcRHIv+YRY/kEX8ClxIsoZizfH/mzIO2/d4XFoXylqHPAVUr77rr
	Y33e25lD3MkCq0EX2PWmJLG9VWYrvUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACCB244792
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B6E1F00899
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789016327;
	bh=jaJUvdpDpUDbSBpSVuw1s5uwDKMSoFFuKQIxHId5d8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XwxxO40Quue7z7982LhM3SPoYwje4x6th5sqGFA/Uz6VWZgotsAlT7mG3AoQNMD0i
	 bQT8clEzu+K6GYeJbONdygp2lWNTbDz//oevOHta2odT40Oimh+qf5ZND4Fdsmptqu
	 uA9UZUN3TX3A5ymOjwLVItrPUBJWVlU+rp9dq0cf9ecZQNaLsW/bKViwnTHCAPTUQf
	 3i7l0pGdzcOqxLPQtjZl5gfDmSN9sSMNgRM2QpIgabuRo14IbkUgZ4Q8FbxefCLcT4
	 rnT1IX9TOghg7TCp9D71+S//r44KnM0yUUZqfejHD24MgN1WDJlsetSunZbIviFjnb
	 xDWXqZayz8QBg==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafd6so90142385a.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 21:58:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw7fvGuNjHon06/9jCohBUWfhjn+0laBrVLWcufe3ZUf2Fa89sWB1sdnYoHUEs13yo/tskjCcZqeA==@kvack.org
X-Gm-Message-State: AFuF++lLjw2Hb1F3dKixF4o9Q91Az+nWgvpw9dZ72g6lwkRTzDr52VHi
	FZOfoYAh/LnqJwoH8v+IURPBSfN4ZsgpIQYHTgi2w7VuMfsePGXxDpLdDIwvCq4RzYQcFVgnDng
	89dTAyUHunliSYGcTodbFZzoQWrT9k0M=
X-Received: by 2002:a05:620a:4409:b0:939:191c:cac7 with SMTP id
 af79cd13be357-939d4953b26mr660961085a.13.1789016326635; Wed, 09 Sep 2026
 21:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-9-dev.jain@arm.com>
 <CAGsJ_4yQhafd8zoESxFza3N8kxWxpOpa1Pv-Sf+N=mCPz5or=w@mail.gmail.com> <3f1798bb-c6b9-4c1f-9a9a-fe312c1a0602@arm.com>
In-Reply-To: <3f1798bb-c6b9-4c1f-9a9a-fe312c1a0602@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 10 Sep 2026 12:58:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w5CFoUPLT=YiEwKm4b0CMvj4B0UFLKuGFo3Ko9jdOpRA@mail.gmail.com>
X-Gm-Features: AcwNN1UcFB_eFHPosL252Q_VZRdmuTDwcLnKb5NJr-W5J12yqfDNTHvxufJjGpw
Message-ID: <CAGsJ_4w5CFoUPLT=YiEwKm4b0CMvj4B0UFLKuGFo3Ko9jdOpRA@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] mm/rmap: batch unmap anonymous swap-backed large folios
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, davem@davemloft.net, 
	andreas@gaisler.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: EC79240003
X-Stat-Signature: er4nkm4f1s39bm3enokfqdok9i1pxywb
X-Rspamd-Server: rspam01
X-HE-Tag: 1789016328-740718
X-HE-Meta: U2FsdGVkX1/2U6vW61h81AiIl2S4Wg59D2txx1RAQbycmC85WPXD3z/9rvF3MG7EIrbVOxwBupIUWFIlWDa/tht+K41s6WUmTZhviGgkH4zErkFWzVrO3yj1855nVo1LKkh8T5dYaAQMiBvkt5DJiIpwMe8RlQ5DDiNX/MyLZTpuT492Jh39gfCbzBU5NYuCSw/AxSS7CJtSsnKrc/3zLRtAsSY524c/LrqbPSS6YFsXNgsO5ZdTfbXciGxqYHn42adxePbofZ83oCE0OGS4boNBJPM9t+6KXfOagNuKm3S+g+oMHqCPiIajX1y6XFHqxP4eWDGjURbso+gN74gaFfirUOa+N1yWdpyhrTYgnYMHiUfWFVL69HClLxm7ySNJpmmaPgNMbDjcYgqGTsR6j1Um7rwMwH+W5Badq9ienYW9LwukEwSPWTqp+t/xd2s0Yxs6m6hGfAeSoiFUyUsysBy0gXZLeMgBrlb2ruNRYxXci3E0mHf7Wd2hs6QLdil5OpU8H8baTPyk+iYQVK27Sw8AWLOsQyWoSfSGoKSj0i+uwEH7UzsOxQb2nP5B7meM4uBmqHCkT+0bw2ZGOi5JApfZolUSrYg8Svf2ANLoo8WOGfFhI31Mw7cWio4jEshke1Xu9xWSwezIRyOVPAm/leJ3T+vWhmelKwE0fUqyiXX+cwJxRSFFkREs+3UGnktDsNlGSZTkHZrmqTW+xEUmYgxyJ1fksocbPsb7pezBYc3EDMGWRkYmud1r8nzHQUEWy7UF1eWlQOXTY3C2RCtP+Cyv5NIaaJ7WW93kseTwo5ORLsKUMg09c2g2eX5BZ0vO8oK0TH/YJ5wASIPR8RRz1KeJTeCLA/cBscjxKYiubln1HgAv4rnig+iQGXCUvwmDvVTLZOwfkHEpn4ZFaXXRMgne+1gEfCi7VIon99ttLMjckEmwa4Li5Swmnv+uDYOaN3ochLKpgHZpeCRnluG
 2JZ9VnbV
 VNHYgniU+rTuIDJfRrQ74PfE1msfUqrNuKth9H8FmDHfC5RsBGd8g/Y0UIg72tnYbL3H5rk5UWnPFoxrnlTSASLFXL0VDgXu7h0VHSylCmHnNIrt4EDzh7YNRpptoNcHhPdPa2EJPd0pK2vvSDRqhHbjEM5WE7sRNkvBCcOJpqGuqxWzplnHMSzJaVX9ZYwEo7RBphNeSnEZBD0MgIoxKWdlYJbzIKMfq/pXfxE/K6tLfEIX2SOeW9a3MlV8FNQsSABV5dR+oDzsAaohI+yB/bc+kSUOOteDYeLZu/hRJPume+mb+SmpbUBSwzsB32Myeh2dmo/5yi7B7NOVsgsbGSoaDWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:39=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
[...]
> >> +static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
> >> +               struct folio *folio, struct page *first_page,
> >> +               unsigned long address, pte_t *ptep, pte_t pteval,
> >> +               unsigned long nr_pages)
> >> +{
> >> +       unsigned long batch_idx =3D 0;
> >> +
> >> +       while (nr_pages) {
> >> +               bool anon_exclusive =3D PageAnonExclusive(first_page +=
 batch_idx);
> >> +               unsigned long len =3D page_anon_exclusive_batch(batch_=
idx,
> >> +                               nr_pages, first_page, anon_exclusive);
> >
> > `len` is really a bad name, as `len` usually describes a size.
> > Maybe `batch_pages`?
>
> I disagree here : ) I don't think someone should mistake len with size.
> len is ... "length". So in this case it is the length of pages in the
> array, starting from batch_idx, upto nr_pages, which are all exclusive
> or not. Also I would prefer short variable names.

OK, up to you :-)

