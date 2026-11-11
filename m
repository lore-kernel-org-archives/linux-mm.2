Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A560606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OwNR3b+W
Received: by kanga.kvack.org (Postfix)
	id 43A756B05B1; Wed, 11 Nov 2026 17:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB236B05B2; Wed, 11 Nov 2026 17:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA536B05B3; Wed, 11 Nov 2026 17:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12286B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:26:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76C9214024C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:26:44 +0000 (UTC)
X-FDA: 85424273928.25.87F25CB
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DB1DC0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:26:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OwNR3b+W;
	spf=pass (imf10.hostedemail.com: domain of fvdl@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=fvdl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qXxJbBqWWiSbLfZQoa2Zp5mRREk6/0luQcqtAQF1PU=;
	b=nskyiTtTM89MPwE/uL5kLI649MYS2nI4nE+b7LnBmX0/kGL1HnOatxgJLrITRlpvIrNtUp
	sy4pCOWKIiU1i5O8Dmveg4Gtv3pm6musCgOUwXDuQbL+oiNo3E8xRY3YTMi7f5drZYx75x
	RxTodzv3A3KqydZyG3d8Tctl0aVdCKA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794436002;
	b=kWhr9aGyorp+F6SkefRn6WvZappCtBPY2elBI3c6hrKckYo+6l0KWibWEcgedDrfDDTbIF
	EoBt5FY2Ne8u4ZHyCSKo3zPWf5GKPjeOSBjvxt7yQ2tv8/qjcAFHkCpPZD4vkiOVmhsF+o
	igeOSMhHqXLsL3aTqZuNCjYrhxm2w9Q=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OwNR3b+W;
	spf=pass (imf10.hostedemail.com: domain of fvdl@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=fvdl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-533202fe429so28881cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:26:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794436001; cv=none;
        d=google.com; s=arc-20260327;
        b=Ocv4nGuXOZ/LnIix60rBa09Dx/fNuwH62ZBzUf0/XgoGQCtyk4hZwxE6oZlV0XLsrW
         H5J/i1EeG6kvY3lyMWKJjEhGlFooEBwr/PRp+lbAx0qysgEck0++YloF2u/zzIJVV845
         xhrknNXBd+ue1fZejZbkVFmJf0Y8KUyF+l8HEkky6QHXRWYCFjFxdT9NO8ifemASDHV5
         YuCIqYMgkrEED9JF7Fu6xVsnCqSe/irf9FR4FA7EQ2kRgbs1U96xKvPfgt2uFb568dYo
         42CJim7HPcU/tt0nUCvXdkr2rkhy+TT1SwnVG12Q50OUf6LtMV33qasR5jifmnhbyn+a
         PrvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0qXxJbBqWWiSbLfZQoa2Zp5mRREk6/0luQcqtAQF1PU=;
        fh=2MiCX2lde5EGL1e4yv8vbqLqj0+pbOZ0GPQQMYos44I=;
        b=U6oODTV9U1E6RWfWM25W7SiVSbUCYct/iwx2b3DF/VQJWgQ2QDflKmfGIVzB6/z3ny
         zSD4kGFQG3RV5+sKSYoTAcDJGLDwyhV5VbtiPM+CRN/aWSKe4Ev1WDObmapZzPf1uzIz
         o+icn4q+B8paOzqIRfuy/P3rU4/bGLoKjXFE8rAthaOJ86odOIpZP89mZWG8lTOQY+VV
         CVL3QPE7WstfmYiwvFZDRe/lnjT9yX95OHWovkCCrtDNh2KI98d8EBtLjCOQHOU2ExJ/
         mtK9wVnXsXqp3HIkTZIQiOOawHI+sVUB3+LSinBjsOFkB3O9XS3XTF6YnUHgXoQihxp2
         nn8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794436001; x=1795040801; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0qXxJbBqWWiSbLfZQoa2Zp5mRREk6/0luQcqtAQF1PU=;
        b=OwNR3b+W+cZX9utfWMRnRpWDAn+J9O5/Pbe2R85ij83jJyOaDCQlTr9Oymdu5kaS3Q
         4BMBwXt/mX4+sIY7eYJ+nYICD3IFugRIZet2DNfKdUbi7JnfXVJQWRwDfRPvZoA/6tcO
         6IJR4vhJ4/mRRVATRA06vk2i1pUWvtkn/IDeGscZa0/up4K9lFaWVcdenDDQD9vpZU7A
         muMiegyaDf5U9/lf6vdygCENLtoHhsmk7dXCxKGwTbqEO/GGL2FiZA2cjLjIGIgvlGCr
         FWZNJblMO51ZcUng2HZj6P7PbJ+pMAcPM2syy+5kYLgj5THSPG/Hb9YpHe29xEEydIct
         jfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794436001; x=1795040801;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0qXxJbBqWWiSbLfZQoa2Zp5mRREk6/0luQcqtAQF1PU=;
        b=gCORLKTHEyxkI6GSCltnKSlhJjnduOhedOb1kxGoNyfTXwlwQI+KYGX/0kcv3o7Y1P
         inXOHHQ4lziS0cA6+9TFS1QPFQgNkmWMK201GfhElEvXFPtTowsK+5K7t8KpkV3SnMIx
         PKyN4SATJkiI73EJvUujb88ZtL4djgWw4oMtJPEZhM2dspBMRpTV93HoRM4pKRvBemD8
         9TMmuzCVrHoAdL5sMwpubGtY6ziQlqR9QD+YLOXJbuAUsyyqL7nDysmDVTvtN9X9X5K2
         V2D8ErbYLjB4SJg1lqcdDiQqzTLIByrWGRTeJi5KXLnJX4X5lBnZazmJyNt27xMU0038
         lVjg==
X-Forwarded-Encrypted: i=1; AL+hErGRbNKkO0AaoEExpy4oOazbZRZTWf9eJvP5oFwjy+IeTnBj3hF3Fe6jxKzCHHcN6t0x/GUUtqJzbA==@kvack.org
X-Gm-Message-State: APuU4Z+F0GWUqlTt8Azj4frd2l471x5JVlIsRrU4AJ93n1yeo+v3TEeM
	LNBax7V5pPYjZijyhNjekjqAUDxY/RXSzTrpyH0pQMMMEK/WSxvxsZth1Il0jsX8QwdevWGCTP+
	/KdAxwmbYkwuSHfEsTOk0SuBV34HHtlVgH7U7jhR+
X-Gm-Gg: AYBFou2CH1bYANRC9zEUyKEdSF8M2dAIfrmyToYe5PU3UfXfEWMa0sFPWG2+1MhznID
	G1oeSsQdiTz4JHqYx7F3KWalCNk8Lhl5L2QON/Ynl1NXy499AucU8/v7idjvm73NG9/l7Y93kcJ
	7yWw0qceII6h9GQa1EMLmI+I+19+8vI8OSBnI3KAPoygncy/JUOnaBrI8RbIcsE8mX8RcclaqVz
	aB79V9ziblTvDtA0YhZR9sPzzd4ZZPKU4WXy9FwIe4BneVVoKwDUxq+NeJbdYL769/KDeOEre9g
	Qrjcn/t+p63M2kRatn5Pmb2nV2JPmtDKHt6cCLTpH0kV9S28OGaubS7n00bwu+YePF7IsN32S7T
	Z459mEujgPH4oMgNPhe0b8dVoeU+NtPtih6bc
X-Received: by 2002:ac8:5c84:0:b0:534:d386:c3f1 with SMTP id
 d75a77b69052e-5598d505571mr2598201cf.9.1794436000897; Wed, 11 Nov 2026
 14:26:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com>
 <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org> <423c9b28-ecf2-4fab-817d-2fb326690c73@linux.dev>
 <3a1a3bb5-0b01-4f20-aa0e-74a952544b8c@kernel.org> <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
In-Reply-To: <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 11 Nov 2026 14:26:30 -0800
X-Gm-Features: AclHuK8ui2RDy0cmaEz9Z61Dze9vT6ffy1pZqe99lY-d2GDxcD7lU32xjKq4-x4
Message-ID: <CAPTztWb0XbjCxtihyp=Tx16Z_kjF+M8sa7YcUjvFv0WcS83MAg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev, 
	Qi Zheng <qi.zheng@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 39oxmmc9jazidxw9s1o7m4t9ahnwwrs7
X-Rspamd-Queue-Id: 6DB1DC0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794436002-407965
X-HE-Meta: U2FsdGVkX192dbLdVo9g6whB5G1a7bwTffjo1npNgwmDyb40L6kUMxVjRtoLlwMF8XtBZN1vzm//EYXRZ5fDSbpJKHK0EKMWTjK/d/mVJiBgfqedFKzn6p5nsvRiiSKtJbgQYjpm2IwCJjnMih4KSOEYYqzg1td52ZEYD/PDgGaw0a6vDnHtpXYVvoiE+rQntPzElGJ9dVeWMrNrgNXfpC3kcUW8eKqXandIEIeDBKuaHGo4CThbbNOkIvfB3S3h8257kLSUHy8sCiQ27S0BGtz42rjAqGVeUCTg2+kV5Yq/zt5P1gHj+2yRY2qpVZzmpA4ZuWsUFDx+0kN0NPPwEBnmNc7tcoj7Fp55ME+LT2RlcGl6z+J86nukaJ44ytGTMuVqWcMWC3BqCWf5VPt0G4m7TWGvUkwMJoRro65m9DsB7yPfIfu5F0vhznRaYy9o0355w9wx/P1b4mjAY36fBAVJ2c3/i6YiCV77ELIJWjszxWGyC0P8jVgGGUAbKM2ZP4Y/aqN1q9eQ1A5uKMymsHZBavEHlwgiCFKKoiq0Sz713ajrezbXOWlF9SoykFu6aj0noo5erpHH0q2urC8Zoekteb6RACk1lPXxHbz2E0HU2Y8mQXkYdVXikpf1BDGccLeZ5OWiiUh+f/FKSODSXLyTbBt+Rf9mMgCZRQTGNXyN8Apfq3SN/irRfY6JFWfRkk2oI94mguy2sbZ1y3BcX7Wsrqv92uGQc1e/uUCUsSu1u9R8dhL/z1drhb6EXQv3D97hhjpOMG5lOD3vmRN1X3CFz42W5nNZAgaFxxjZMm1MgaYj+dsjdWsza2fZ3DyHw5d8jWhy7ERpwt7KVsNcLpDWcg/MzRi8v4biQSJV/zkP6npQM+w+xEZUOP2PVOErrWfDjohV50Nm1hHpdDlV3O1tw6WYd2VghchRs5uXrXTHIhNPb9sy3gLlEII9EOXXIIbaTf/vWJre8ShOF81
 1oNgd3bb
 PHJ27wCX+nf4eB1HlbCqY9MRswPCPO+LBPxHbfqTIBvfs6xkOQoHBfrlmlVL7IqySEM8veBI9TDhqvx3n1/u/xKdj9OysAtUzgCW7Q/o0QXYFJ9tsae04LM1Z1nsbob0CYyoo7mRpOyt2vI0xT47iiQGK62jziFNoDdRcp51IXJXc6ZzhY6cLhidxskyfI3T/iiivaNYYA6RZySFpyK6n57M+BeZTjKbOwBOUHEvpnfysg6GdzrvgQbLc/O2uoVgq9zzYZmbNkMH5LR3fINVc9WxpRbN/ZS8ypH2+f9bej6oWbscGKBwUyoQt/Cip45cJ5zoVb60+4TOE01E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 2:27=E2=80=AFAM Qi Zheng <zhengqi.arch@bytedance.co=
m> wrote:
>
> Hi David,
>
> On 11/11/26 3:43 PM, David Hildenbrand (Arm) wrote:
> > On 11/9/26 04:10, Qi Zheng wrote:
> >>
> >>
> >> On 11/8/26 1:58 AM, David Hildenbrand (Arm) wrote:
> >>> On 11/7/26 11:30, Qi Zheng wrote:
> >>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
> >>>>
> >>>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
> >>>> unpinnable, causing unnecessary migration or pinning failures.
> >>>>
> >>>> These folios already own their CMA bitmap ranges, and memory blocks
> >>>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
> >>>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
> >>>>
> >>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic huge=
pages using cma")
> >>>> Cc: stable@vger.kernel.org
> >>>> Suggested-by: Muchun Song <muchun.song@linux.dev>
> >>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> >>>> Acked-by: Muchun Song <muchun.song@linux.dev>
> >>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> >>>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> >>>> ---
> >>>>    include/linux/mm.h | 29 +----------------------------
> >>>>    mm/gup.c           | 31 +++++++++++++++++++++++++++++++
> >>>>    2 files changed, 32 insertions(+), 28 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>>> index 2d0b8a4c9974f..75dd40265d3f4 100644
> >>>> --- a/include/linux/mm.h
> >>>> +++ b/include/linux/mm.h
> >>>> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct=
 folio *folio)
> >>>>            return is_zero_page(&folio->page);
> >>>>    }
> >>>>
> >>>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
> >>>>    #ifdef CONFIG_MIGRATION
> >>>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
> >>>> -{
> >>>> -#ifdef CONFIG_CMA
> >>>> -  int mt =3D folio_migratetype(folio);
> >>>> -
> >>>> -  if (mt =3D=3D MIGRATE_CMA || mt =3D=3D MIGRATE_ISOLATE)
> >>>> -          return false;
> >>>> -#endif
> >>>> -  /* The zero page can be "pinned" but gets special handling. */
> >>>> -  if (is_zero_folio(folio))
> >>>> -          return true;
> >>>> -
> >>>> -  /* Coherent device memory must always allow eviction. */
> >>>> -  if (folio_is_device_coherent(folio))
> >>>> -          return false;
> >>>> -
> >>>> -  /*
> >>>> -   * Filesystems can only tolerate transient delays to truncate and
> >>>> -   * hole-punch operations
> >>>> -   */
> >>>> -  if (folio_is_fsdax(folio))
> >>>> -          return false;
> >>>> -
> >>>> -  /* Otherwise, non-movable zone folios can be pinned. */
> >>>> -  return !folio_is_zone_movable(folio);
> >>>> -
> >>>> -}
> >>>
> >>> Moving code while adding new stuff to it, please don't.
> >>>
> >>> Move code first, then modify it.
> >>>
> >>> I don't want to play "find the difference between two pictures" on a =
Saturday
> >>> evening.
> >>
> >
> > You resent your series way too fast.
>
> Got it.
>
> >
> > Now we have discussions in to threads, congratulations ;)
> >
> >> ;), got it.
> >>
> >> I moved the code to resolve a build dependency.
> >>
> >
> > Why can't that be resolved differently? What is the dependency?
>
> The dependency is that the new check wants to use
> `folio_test_hugetlb_cma()`, which is a HugeTLB-specific inline helper
> from `include/linux/hugetlb.h`.
>
> `folio_is_longterm_pinnable()` currently lives in `include/linux/mm.h`,
> while `include/linux/hugetlb.h` already includes `linux/mm.h`. So I
> can't simply use `folio_test_hugetlb_cma()` from `mm.h`
>
> >
> >>>
> >>>> +bool folio_is_longterm_pinnable(struct folio *folio);
> >>>>    #else
> >>>>    static inline bool folio_is_longterm_pinnable(struct folio *folio=
)
> >>>>    {
> >>>> diff --git a/mm/gup.c b/mm/gup.c
> >>>> index 2b405cce2ca5c..f41701c603500 100644
> >>>> --- a/mm/gup.c
> >>>> +++ b/mm/gup.c
> >>>> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr=
, int *locked)
> >>>>
> >>>>    #ifdef CONFIG_MIGRATION
> >>>>
> >>>> +bool folio_is_longterm_pinnable(struct folio *folio)
> >>>> +{
> >>>> +#ifdef CONFIG_CMA
> >>>> +  int mt =3D folio_migratetype(folio);
> >>>> +
> >>>> +  /* These HugeTLB folios own the CMA memory, so they can be long-t=
erm pinned. */
> >>>> +  if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
> >>>> +          return true;
> >>> More hugetlb hackery ... don't like that, sorry.
> >>
> >> Agree.
> >>
> >>>
> >>> I think this just goes down to a problem we discussed a while ago tha=
t is
> >>> independent of hugetlb: we'd need some way to identify that the the p=
age was
> >>> actually allocated by the CMA owner, and it's not just some other mov=
able
> >>> allcoation that ended up there.
> >>>
> >>> For something generic non-hugetlb thing, can't we call into CMA to as=
k whether
> >>> the current chunk is marked allocated?
> >>
> >> The existing bitmap is set before allocation completes, so the range
> >> may still contain borrowed movable pages. A set bit alone cannot
> >> establish ownership.
>
> The more accurate code path is as follows.
>
> Assuming the 2M buddy allocation is successful, page P is borrowed from
> the 1G CMA area.
>
> Now, proceed to request a new 1G huge page:
>
> only_alloc_fresh_hugetlb_folio
> --> alloc_gigantic_frozen_folio
>      --> hugetlb_cma_alloc_frozen_folio
>          --> cma_range_alloc
>                  /* set bitmap!! */
>              --> bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
>
>                  <time A>
>
>                  /* may fail */
>                  alloc_contig_frozen_range
>
>          /* set HPG_cma!! */
>          folio_set_hugetlb_cma(folio);
>
> At time A, for page P, a bitmap was set, but HPG_cma was not set.
>
> If a concurrent FOLL_LONGTERM pin uses the bitmap alone to determine
> ownership, it could incorrectly allow P to remain pinned. If
> alloc_contig_frozen_range() fails, cma_range_alloc() clears the bitmap
> bits, while the long-term pin on P remains.
>
> HPG_cma is set only after explicit CMA allocation succeeds. It records
> the folio's own CMA ownership, whereas a set bitmap bit can represent
> another allocation's in-flight reservation. Therefore, the bitmap
> alone cannot replace HPG_cma in this check.
>
> >>
> >> A generic query may need separate ownership tracking, such as an
> >> owned_bitmap recording successfully allocated pages. Its updates and
> >> lookups would also need to handle concurrency with fast GUP.
> >
> > Or simply two bitmaps? "trying allocation - allocated"
>
> As a fix, perhaps this is a bit too complex? :(
>
> Alternatively, we could adjust the timing for setting the bitmap, though
> this might introduce new concurrency issues.
>
> Thanks,
> Qi

Yeah, ideally there would be a way to identify folios allocated
through cma_alloc. But that would probably require.. dare I say.. a
page flag. Trying to check bitmaps does seem too complex.

And, since we've had a local change that does exactly the same thing
for a few years (which I apparently forgot to send along with other
hugetlb_cma changes), I can confirm that this looks good to me and
works. So,

Reviewed-by: Frank van der Linden <fvdl@google.com>

