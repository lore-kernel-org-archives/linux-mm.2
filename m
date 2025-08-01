Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D6AC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABAA6B0088; Fri,  1 Aug 2025 12:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683356B0089; Fri,  1 Aug 2025 12:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572096B008A; Fri,  1 Aug 2025 12:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48A686B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:23:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 072C31D97BF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:23:27 +0000 (UTC)
X-FDA: 83728708854.29.6B907D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D7E1140006
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:23:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ks1tUdyB;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754065404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Sqvb7JAqSKhuY6yKaHlPytiCq88KcrtpeNVaMME5GA=;
	b=G2ifNOHBJ80cT7ePqZqG9Ss+6lJuAEStL/vVMTYFupB9mmRF0g6tMnu46vYi91HnwHQFrR
	Chfir3r2opB0Wc/v6h1T8fIEYlwgAhwe4vtgKfz7abGW50nx52RV/cSjjNdqQzzi4B/mX7
	hRzTIjwEtvbwsmlwPR1QdrpejUPaS8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754065404; a=rsa-sha256;
	cv=none;
	b=dvu90FmrRP18zlPg77UVjBeZULnkO41R4A2pjRV0dIN/cM0/kKeZedN8H8NYRBOx3aHfSN
	O56XUWye22XE0fkCtaZYUj8S/gEVXB1OP2RptVeVvZ4My9H9HXpXyrl8FShOX8ItxSZbxi
	VvKprgxd8Ah/6HL8Xyn9oE4JamlbKLA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ks1tUdyB;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754065403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Sqvb7JAqSKhuY6yKaHlPytiCq88KcrtpeNVaMME5GA=;
	b=Ks1tUdyBdCLAs43b9oSd5j8/5xJeB7FtQy33XTqwEfBox7FCi3oUlQE+WKxzJ+Uh1X2ws5
	a4kKFY4Lbn1p2BKieSzr7+G7CRulVoc6StPMcKo136zTozJf/PB/7IKUog3pC5K6748Ac+
	DlnMVwFJCrFVdv1E0XcAHBYv4LmchSY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-TYIphVYDPzyd-cnWL4PUGQ-1; Fri, 01 Aug 2025 12:23:20 -0400
X-MC-Unique: TYIphVYDPzyd-cnWL4PUGQ-1
X-Mimecast-MFC-AGG-ID: TYIphVYDPzyd-cnWL4PUGQ_1754065400
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-707722d08d9so39262166d6.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754065400; x=1754670200;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Sqvb7JAqSKhuY6yKaHlPytiCq88KcrtpeNVaMME5GA=;
        b=symcQFilXzrw4U+u5Scizp04DXhgy+cQE9Wii+2jgeyNNVwBQEg1WxbmCZftDQFsgb
         4xJW7EEcTUbh4lJKowR8DqeVisudQRHi0vG26Azfydu87ubP14dWJkBGUsJo+36TRkHm
         vH/OtivwZaLaEEJUVy6yLXToWf2i2vJJSPBhexobC5j8IfniQswoi61e+d1iiRevDL8e
         aXuj2YYaa5YA/c7s0jYrANWwgt6fMAWVzwKF4CRZWJEOVXfuPsgRA2feacZ2ko0gvYuL
         1gW0+flHKy7kWcaZ6c1i8P3Q6aDxKgDon1LDLX1RmeQ3kXe2IGs5GOkM1G7QuN7ijd8X
         o8FA==
X-Forwarded-Encrypted: i=1; AJvYcCU3fPHZB543tMVxOIfmp0BD5hbaJbQM6+eYmcK39OiVgXtxUqkYr1wMTQrIpe9jt3NwxmkOVFZWmQ==@kvack.org
X-Gm-Message-State: AOJu0Yxrs7kD8htb/+aQQ+Xu+yd1MahdJry8ANmK1vJdsGnyLQT2Yszg
	kF2LW4wKGtBL6wQ6vvMV56irakVjd6NZTDNS9wSYb1PA6y1phLKGfRTxFteLw+m21eOnooqnxdN
	KrpfxV8OEpMu+zxgc4GPZqwewGDP6eWZGX63WqTAsUTscDM0WVFgV
X-Gm-Gg: ASbGnctlvwt/KlVlNMrFQ16gJgKYnF+qO9wtGXrvni4PYrBdiAk04DTrbY7xwTkfYEA
	/4BNrpz/8aHjFA7J3e3cgkeglvqis13lpuHZWLVZso6BNTLNNaCm0VQWvs+3+ouqgt1VWNIhlf7
	/uWcFAhn4dZgQPUCJIjy/0zPCr8FBTfVWL+zEUn+mf+7VkdlrFUaKuG+ijiJMnh8rhlO6moSFbX
	qlHpEbK9C1OPNdN45hdLjQnmdIuRS3gT1H6Hr03z/tOjQI+jtCdvqaiGwenAUmb1kwK2ggoI7Bs
	O3yDTafbXgPfjJ1aaHuVXoyIDk2PvbCR
X-Received: by 2002:a05:6214:623:b0:707:1eae:17e9 with SMTP id 6a1803df08f44-70935f6c42emr3328426d6.21.1754065399946;
        Fri, 01 Aug 2025 09:23:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpZI71GEayMeGwYSIqUSspyQlyLLtHuQaSsWRKAdHTVneK9AyXLakZUxoMF71iimA1I9hOJg==
X-Received: by 2002:a05:6214:623:b0:707:1eae:17e9 with SMTP id 6a1803df08f44-70935f6c42emr3327936d6.21.1754065399325;
        Fri, 01 Aug 2025 09:23:19 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9dc383sm22996276d6.16.2025.08.01.09.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 09:23:18 -0700 (PDT)
Date: Fri, 1 Aug 2025 12:23:05 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aIzp6WqdzhomPhhf@x1.local>
References: <20250731154442.319568-1-surenb@google.com>
 <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local>
 <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4NpiyBJQrsQgM5KoainCEbsA1PQ6TG20vbjKzXNxY00_1754065400
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D7E1140006
X-Stat-Signature: t7mdiq5qn8xrax1ydj3yy6pncjuwtjor
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754065404-411783
X-HE-Meta: U2FsdGVkX193K6eORfyhv2nOL24uQkIWcX8iXAaNgDAKU0nTYuYyfMxOZ/sKRBj8RLzeKdUl35w5VNy/gl/AkgkViKLhWR/E7VuRX1wTlg9r/l5rH6rKCOH1ijQKpMzEqf3gIxmkp5yRvai7h/UgkOF4vmoA4Sq8FJ9sgA+9fSgufiRri405D62hzLdqV5Z4gJI0y81Z4S0xU1XTkGEarKwaZjt/DPeeRfadj0NBB7XdT5CIzTUeHUfsVvtXR4ZkgmFol4Vzsl1utuvEqS7705+TEXGOB6HBV7Ov/5jnNHnJdSl/aV/fiELZGviBejFfyNNUVApvqXQlNcocfx6PdlgHoYvsVt7QXQALday7VpOpBJ8y7SVCql7B53vEPE7Q0cVpOE5ozPmNklT7E7AVFB9N3Y2oPrTZUiNxB+cKllCNSMKNiqAY7VScV0hfB79PgsTbDx7/+nOerrQZj0SPIl4G5l8emPGhHaK7W5wXea04UJWhslZclwfOZs3EJJhCfqwO5uHOqqw0ikM9VUd6Sd/XXgvEU8iCiEmAcNbHysVVl/WiiTaSij3grUcI7jdNNxvnHmBwSfB0eMnTZliZN+WlTMLC3WaBfQGWrU43QS2SmGnFxXC6z1dggWPIjpCKMxZJoUY8oAPPFjFZk9c/LTbFbVwmR5XsMC4Ij331dzE1ZAidA2bT7Pq79qLHoCr6wGOtTf+017Gzw1kSn9j8vpHBwOy+mD0fm6fvFL7njaVFQiu191HFrd10RSON7nEjR5lwljjSAlJonWXztCMz3aY4Evg5KMPGTpBrUnnR+ueBsHGER1o6BbTb30dPI2pJXL5PzTrDdj31qzB9khYiVt6V31zSAYO11J+l9k1sMNqmnfae+gty9LwmutP42s1apoAvyZrTtEd5sV2xeeO1lUrjYxw7TevojZRXbIGcdP2yGe0nZIb6A1BMvEFZMgRCq/aMIm27g2sY0JjyEBr
 o8Rv2n3i
 fBeiy85lekm1imE5uCQIqQRWESxx3qnj/GGAsLJH7ogEpSQyd/8N6k2/W/KmnuE1D0pesZIHnj6y83DJB5rNnsqqxcxCx+B5tuZdkKspnIOHvurDpl6S6dDtcdFk6KZVIBnIxxmr73BFCR8pHyWnQult6k4KJiB7mFMj8shQqAA34oYwgGdiNtxsprToMFWMbk0r76O7FpEqdqwyOHbH410S1LNFyNWewg6uE2wv6drzRXOXWO3wTdNzeFxUhhrf+1Yyo1rOZxfxdxVYf1NNguRRa+WVHjt79ihK8Am9ALgqFpcemPu4OxiHITTswltz/y5FmTUCcmlX/0oktlKFxuHg8WnVWqv8UDmgQyXIinWPUmX9/s7vWA/wxGiXSw+8w6iTov5WcG5qt0V0f14QehHKuwpj3N/Cu6yXizSm+dKK/N62QV93yA5rzFCxkiUo/knG+pIcGFsB766N39p4pBDmqcZzeDNGo+XEEOZC72IaCREC3VFwk5XpfhHo2LA4m9uUR16ynywCJNfI19VhYqTGq2GUJyWisST8s6+Dvigfp9poXgvgr/YITXNb6nZ77306g38SC6ZUtYFyg75AFweRKWviN6Xst/h9c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> On Fri, Aug 1, 2025 at 7:16 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > >
> > > Hi!
> > >
> > > Did you mean in you patch description:
> > >
> > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> > >
> > > Talking about THP holes is very very confusing.
> > >
> > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > > encounters a non-present THP, it fails to properly recognize an unmapped
> > >
> > > You mean a "non-present PMD that is not a migration entry".
> > >
> > > > hole and tries to access a non-existent folio, resulting in
> > > > a crash. Add a check to skip non-present THPs.
> > >
> > > That makes sense. The code we have after this patch is rather complicated
> > > and hard to read.
> > >
> > > >
> > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > > Changes since v1 [1]
> > > > - Fixed step size calculation, per Lokesh Gidra
> > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> > > >
> > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> > > >
> > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > index cbed91b09640..b5af31c22731 100644
> > > > --- a/mm/userfaultfd.c
> > > > +++ b/mm/userfaultfd.c
> > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> > > >             ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> > > >             if (ptl) {
> > > > -                   /* Check if we can move the pmd without splitting it. */
> > > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > -                       !pmd_none(dst_pmdval)) {
> > > > -                           struct folio *folio = pmd_folio(*src_pmd);
> > > > +                   if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
> >
> > [1]
> >
> > > > +                           /* Check if we can move the pmd without splitting it. */
> > > > +                           if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > +                               !pmd_none(dst_pmdval)) {
> > > > +                                   if (pmd_present(*src_pmd)) {

[2]

> > > > +                                           struct folio *folio = pmd_folio(*src_pmd);

[3]

> > > > +
> > > > +                                           if (!folio || (!is_huge_zero_folio(folio) &&
> > > > +                                                          !PageAnonExclusive(&folio->page))) {
> > > > +                                                   spin_unlock(ptl);
> > > > +                                                   err = -EBUSY;
> > > > +                                                   break;
> > > > +                                           }
> > > > +                                   }
> > >
> > > ... in particular that. Is there some way to make this code simpler / easier
> > > to read? Like moving that whole last folio-check thingy into a helper?
> >
> > One question might be relevant is, whether the check above [1] can be
> > dropped.
> >
> > The thing is __pmd_trans_huge_lock() does double check the pmd to be !none
> > before returning the ptl.  I didn't follow closely on the recent changes on
> > mm side on possible new pmd swap entries, if migration is the only possible
> > one then it looks like [1] can be avoided.
> 
> Hi Peter,
> is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
> && !pmd_present()) PMD to pass and that's when this crash is hit.

First for all, thanks for looking into the issue with Lokesh; I am still
catching up with emails after taking weeks off.

I didn't yet read into the syzbot report, but I thought the bug was about
referencing the folio on top of a swap entry after reading your current
patch, which has:

	if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
	    !pmd_none(dst_pmdval)) {
		struct folio *folio = pmd_folio(*src_pmd); <----

Here looks like *src_pmd can be a migration entry. Is my understanding
correct?

> If we drop the check at [1] then the path that takes us to

If my above understanding is correct, IMHO it should be [2] above that
makes sure the reference won't happen on a swap entry, not necessarily [1]?

> split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
> indication that split did not happen. Afterwards we will retry

So we're talking about the case where it's a swap pmd entry, right?  Could
you elaborate why the split would fail?  AFAIU, split_huge_pmd_locked()
should still work for a migration pmd entry.

Thanks,

> thinking that PMD got split and leaving further remapping to
> move_pages_pte() (see the comment before "continue"). I think in this
> case it will end up in the same path again instead (infinite loop). I
> didn't test this but from the code I think that's what would happen.
> Does that make sense?
> 
> >
> > And it also looks applicable to also drop the "else" later, because in "if
> > (ptl)" it cannot hit pmd_none().
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >
> 

-- 
Peter Xu


