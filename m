Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D19DCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B698E000D; Wed,  5 Nov 2025 08:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52C38E0003; Wed,  5 Nov 2025 08:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A098E000D; Wed,  5 Nov 2025 08:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B46828E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:30:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69D66140349
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:30:51 +0000 (UTC)
X-FDA: 84076638702.18.DA568BE
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7CCB2A0019
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:30:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LmhdwYzs;
	spf=pass (imf15.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762349449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuKkAI8xRPtJ5Fw1eOvcnr1+sgWhXNgrcDdCSnmoslQ=;
	b=OSUjFKC8cTUtMBfuMjrPRX3mv5qI9njyODWz5DuB3s27zgtjpKSruJCQLM5zJ+WE5ZXJMo
	MgySUChHxN6ArdVTRjhpknhlUNlGUzng/MD4i15mtnBDHno1t/ByenKn/wmFwN7Pl6VNMe
	FqYzwADzcnFTLEbY7OferVQ+i0aKrRM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LmhdwYzs;
	spf=pass (imf15.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762349449; a=rsa-sha256;
	cv=none;
	b=LxcDC3k4TlIQnRQPFy+QNCE/DDtZOtM0UgtyEIKtWlHCMBCGbw5vNnnHMdpt8lJH5VK7JR
	eIOIVGDhXKiNuso42FyFRtWyUuawuMYMa/YKjuGSGQaa8PXRn4HFky492bRkN2cho4uEhf
	fUm57KD2AEdPe8UPtGqD06grdvnhZNg=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-656bb297df2so216691eaf.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 05:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762349448; x=1762954248; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NuKkAI8xRPtJ5Fw1eOvcnr1+sgWhXNgrcDdCSnmoslQ=;
        b=LmhdwYzswRcBeTvoxw2T/7L/FLYAASKP+ao0m75VnYZDIvUA5RZWOWsrUS4nQ07T9r
         Phs+JyF3dh5alGBN9bn7jHQIQq2geSz4MpPcCfBMq+cbqgf76s5czJWqUDxpjBzhS1Do
         lFxrXJuPkCSxcC4cPxAOOTdGP/77UKML7WRG8sXPJ4Ql+Un22TLszsSLdw1AFfdpe6d3
         b+rZz2bp5RULtXB6QVETT96xLpmxdQVVG8Wb1HORDn47RoheOO26h6ojClhFNgkFCGmy
         c4xGBUlgm5BDhHyUj2LDQasGEBQSdK7E6a/pnGoO5v3vVz2/7WXvGRLyfilTVoqZPkgS
         +wBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762349448; x=1762954248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuKkAI8xRPtJ5Fw1eOvcnr1+sgWhXNgrcDdCSnmoslQ=;
        b=LuKIDmAotN0VlCzNOmX6fyR/fUNqBdIQRtV8AsAWi5ewoZRjcf/gPOOiqyYCqC7FJu
         UeLIAMD74/ByqLkUT4+7P1mKTDXFJgdmKLIp/QcUG06xbvBEeItyH4Ny7Be6dTG6nTI2
         08F48O40Xg5Bn0baEJGy0U1BnNSRk4W3jGNRq5X0Fi8+U/7D15PsgQbhj94qy3AjWulD
         ZLSRFibCQ4J/9OWcgH4MFx5jsWG7/t54SqiPJy8MOxaJpTyW6BN4oRlX090XBI7mYxZI
         10bGpABkvSbDpkp35OL7nQ3OR89UmunlqnDWw2tIJaWfNCmwsuwXVnjIuotBSvfG/q3N
         /vdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW0mDxb4qn/UJaEMEkghNj+AlrFF+YctJZxWZtTZqZMWLxfDJDm8S0gjPbYGEoCMB2vvVjJXFurQ==@kvack.org
X-Gm-Message-State: AOJu0YxBMUHZKoYPiEcx9BkpfcmV8xR8AjqIEZKA0ztSLsMHpD74q4zn
	pLF+N43uImbBq4qHTS3cG9PHqsRIBAVy7uJPZs6Y140FTP1BoMlOvp+5
X-Gm-Gg: ASbGncuUCA8n1v8E2CmyM2J0II1Xh1/vvMI0Yfy08hD4HRWYwZjHrfPXFmJYmgqDMKx
	XqIpo4Surh5MuFDwOm/Aw8nUDh24gdPbuChR0BcLGdn1Trh7Cn4dY7R19Vziu0JnlRJPffVJfn5
	mOY771AI0yW/U6L5Ld66UA77PIpegOe4exKuvtA+tp5yfnGLi6Ym+PIeLm8mo8mw8h6JW28kvim
	dHH3/64jgwWHSyUIIbRu9XsOF5Eg+B47GYAsOBv7BdpWYnLxdR6veFWCA9r8yKsURtZxSpAQytp
	FE1+rFPeABhrLdYyUF3NHKrIhCMmpzgHPQ5zcBayPhuZ+NfrApq11bCSmYn/7hjGb1uanOQ/PEB
	2S31FxRyJJjw8Io2ivc5M+gRj13OHLnOEs+1EwmTKgofIpLJDgx/vuN73s1hFLt3Cs+ME3Ne8+L
	V8IzSWbO/oyheF70co/d4sKELiTwJLHlD8qrIZlZ0pbbF+WKMm8FRkDAtEFNtSM0BT
X-Google-Smtp-Source: AGHT+IFt/l5lO1NOARC/MCGJCb3cYRXCFTcjwE7BDBHrYUQg6rEEKsVOfAXgEudyx1baeVZLQvxmVw==
X-Received: by 2002:a05:6808:158c:b0:43f:6bd2:3a57 with SMTP id 5614622812f47-44fed1f22b0mr1431631b6e.20.1762349448293;
        Wed, 05 Nov 2025 05:30:48 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2 ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44fd84b33ffsm1601874b6e.8.2025.11.05.05.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 05:30:47 -0800 (PST)
Date: Wed, 5 Nov 2025 10:28:51 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Revert "mm/ksm: convert break_ksm() from
 walk_page_range_vma() to folio_walk"
Message-ID: <42byvvz55omaszu6ep3g7n2dj5z7mfxy5h3zbc3xjdnslemkpp@kvdzrjz423mb>
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
 <20251031174625.127417-2-pedrodemargomes@gmail.com>
 <a6574561-02bc-4ba6-9fb4-418dcb07cd5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6574561-02bc-4ba6-9fb4-418dcb07cd5f@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7CCB2A0019
X-Stat-Signature: 1kqogqwgknr3u9nmi7a5rmi5x8xj8x5y
X-Rspam-User: 
X-HE-Tag: 1762349449-281701
X-HE-Meta: U2FsdGVkX18wjadSTTjUgApGKJZMB+pJc3G/qPKRRk7ON8K4RR1FchRTzI335HXke1OKWHOXfMSsrIcH3meEZG5kXvF/AtKJSex55+RJff+POCBKMdKUMs8Cs72Kpry7kwxeGEMrGvNDblzLxqPWctV5coRcP57NAAM6jScvxOeY2pXnQfN9JMpagyfGDdlOWpZBDVleIT6zUjUpW8oTUFYjvs6iZIhCNsg8ahxJgQ3I6VbB3VbLeNRe0NpvMPIY4d5e8qyUCwjEnKT6tD62b/JSceQy8vY7A2RUhvQKn943KGI6miuzCNaeIm+ImaZy5MZ9KJUtdgfNNKQR1xPA8Lo0/dfQIBZiiQ7RQqX0RdY8Fxuvq24zWzJxogfW4sHmhkavdmSPfhruA52NEFcAPjgCypLktIr0z3OD+29RiGWKr08Zf9nS/2Jf1Yo8Ezu0c/mC9gcUoyk8hzVp+XDhlYdDAvrsAFC4Q8dFTuBcr9Vh38oLObk7QiMboMRLjXg3SEmKtGAbPMQWPt24NZqohIy0lQwFORq2l+gwFCfkad2jQPcuz7lqVEvrkF2bsPZ5OtsBYA26TKebt8WKR4CCt5Ego6h6Coi5dFehNI16dO7lVgthWTmMZ80G0S2U2Qixqwz7U55TKA0sUE4T3PWLV31qufQOJu3NxcewhwcDmIys5XfhSN5I2ETWV+Z43q1UMtIbyJLyTliBo/6M7X6ve2d0KVIAsaazztMmIsL0qeth9CY/p8FeAkfdhTmrG5GWoBcuF0dbBYTgC7AwPHxfMXu2dTlNKfUKZtFxM0GOLgT8SAWPxukoWM6rLQ+/TWIbp8nSIEZhWE4TyjvzaWHChwedMdZ/9K3XW21/HhKT3br33HVBsBROMZGKh5XjOgPb8sN/JDao2rQNqgQ5oAhsGatav5FdsNCbboX4marlEWY9dvOF1j9NLRmAFj6WgCmCOqBNz6y241K+8XzucXq
 W0x/SrTk
 VBsvn7vltJKZgoN92hOnZSh7/CEAKykRrrQ/Lh/B6pnXCz6ZXXAh6wCBANVw9MdQdGlhOVXOf4/uqXZIotgFqe85/hkCPxPLXkZ1jOBtdvUG1v/7uXKKgecW+F/IkuLv8SB/gKecs/OP28Bpq8R5o5FhQxxwx2tKRGR+5S/5z0ppl6frfJgnHQsW72r2d+WCc4DL79ieBkH01qCYYDR2I2D+qKWrY56I0Im321fCt4DMIaBWcDtWUQbFTLY6tJXuhsDV3O1c9ssNZSuovaE7bEUQeALOaFbkaLsznyBPwGOKu8bG/p4Qq4AriJeii9mRp6Zqvwwlnt+d3aJ9xyy7H/9jqg2UtEv1sGyw77iac9rQZjwPXWy0bfgwhJq4P2JwAXZU688KEwWna4mN7SUKbyGONWOLObs+0VLATS/WbTFnXZN6JLV319YhCiKESjWtkBPeXlGwLob2qM+aZvq++scJFtM/m0wP7XV2MM9UygPgfB02jSpZBaifqd4SdiJEj61sTTfUMmqtkvXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 06:00:08PM +0100, David Hildenbrand (Red Hat) wrote:
> On 31.10.25 18:46, Pedro Demarchi Gomes wrote:
> > This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
> > function break_ksm_pmd_entry() to use folios.
> > 
> > This reverts break_ksm() to use walk_page_range_vma() instead of
> > folio_walk_start().
> > This will make it easier to later modify break_ksm() to perform a proper
> > range walk.
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> > ---
> >   mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
> >   1 file changed, 47 insertions(+), 16 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 4f672f4f2140..922d2936e206 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
> >   	return atomic_read(&mm->mm_users) == 0;
> >   }
> > +static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> > +			struct mm_walk *walk)
> > +{
> > +	struct folio *folio = NULL;
> > +	spinlock_t *ptl;
> > +	pte_t *pte;
> > +	pte_t ptent;
> > +	int ret;
> > +
> > +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> > +	if (!pte)
> > +		return 0;
> > +	ptent = ptep_get(pte);
> > +	if (pte_present(ptent)) {
> > +		folio = vm_normal_folio(walk->vma, addr, ptent);
> > +	} else if (!pte_none(ptent)) {
> > +		swp_entry_t entry = pte_to_swp_entry(ptent);
> > +
> > +		/*
> > +		 * As KSM pages remain KSM pages until freed, no need to wait
> > +		 * here for migration to end.
> > +		 */
> > +		if (is_migration_entry(entry))
> > +			folio = pfn_swap_entry_folio(entry);
> > +	}
> > +	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> > +	ret = (folio && folio_test_ksm(folio)) || is_ksm_zero_pte(ptent);
> 
> Staring again, we should really call is_ksm_zero_pte() only if we know the
> folio is present.
> 
> It's not super dangerous in the old code (because we would only look at
> present an migration entries), but now you are making it possible to call it
> on even more non-present ptes.
> 

IIUC vm_normal_folio will return NULL in the case of a ksm zero pte, so
we can not do
	found = folio && (folio_test_ksm(folio) || is_ksm_zero_pte(pte))
because it will always be false for a ksm zero pte.
So we should do 
	found = (folio && folio_test_ksm(folio)) || (pte_present(ptent) 
		&& is_ksm_zero_pte(ptent));
since if the pte is present and is a zero pte we can guarantee that
the folio is present.

Sorry if I am missing something.


> -- 
> Cheers
> 
> David
> 

