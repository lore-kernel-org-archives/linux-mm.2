Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D96C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24706B009F; Mon, 31 Aug 2026 12:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB186B00A0; Mon, 31 Aug 2026 12:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10696B00A1; Mon, 31 Aug 2026 12:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7FD6B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:42:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B6BE1C06CD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:42:00 +0000 (UTC)
X-FDA: 85162131600.11.D640F97
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 49405C0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:41:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WOkBcgKO;
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jgcy4vhcuOFybIiqsdMpVsUmfvN2Slyg4glzbZ+onWU=;
	b=w8StzbNPbrB6+HnHCh2fVS8ZgxoNWv5NTB777B0L/6V4CBZtYVLqSmfwFPsHoZABxeCQ65
	lsNa18oIMMT09VYSeKveU5wRjWHnpyCnNh0ilxH72sWtgbBbno+lczQm6Mj43/rbeaP5px
	CFW4567geyCEzEiC/IYj5arqpfuda+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194518;
	b=OeyIQGk7Suiv8oi4HTBtIxNqj876XwKahQrEKwC0RMyBzig6vkPCgJHT9acvDDlEGFIysU
	l5the0pCmG1uxzHtmnOapZtJb2lYJTZvZSpaU5FmiEG81/830kiJ8+UqyhbbVFTvzSJOoN
	8Ezu0f3MmLrQOeJLP1olYte9Rr561p4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WOkBcgKO;
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d710632717so31302025ad.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194517; x=1788799317; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jgcy4vhcuOFybIiqsdMpVsUmfvN2Slyg4glzbZ+onWU=;
        b=WOkBcgKOfCVdjYDfnxPVDY7w5tlTzAsgq3bjLBQDRqIDRfyoTrQlXoUNerwG7xRebK
         Xjviq7jWGby/NPotUv5g6kNM4zXPdJkPxb3SvZSAALri7/jjqtkqYrFCPfrVNpS7aJCQ
         8VV0ZB7uOuuwnuOa703jWvkgSVDm15CdAseByfdNDL5H3X1VzW0OrqZexFrkgoto5+UZ
         guy8Y44mwFHEE5FpgweW0lQdwiKtdRxRIjNWy342nU8cIS3TW46sH6Riq/ppRtRbPa2V
         Jqa/2uRMtppNOz6r5K+T1s7plmxRW9TySaN15ksU7cCcA/JS4SrQLzqZrsI2B4MOga0e
         xc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194517; x=1788799317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jgcy4vhcuOFybIiqsdMpVsUmfvN2Slyg4glzbZ+onWU=;
        b=CIrIKHN7Zz/SzbGHhF0rjzmpfErVNaqmqigbEvCzWpkmAtJCPG65WdIq7pK6uxEC9z
         6uM1G/Jmh7LyNXuffn/U6gAO4ImNy7shj0hncBkRXthLKPAjDT21YEBvQGPC2/rNz/ZB
         t+mAaurP/7IUO8JNpj9DP+PQJQ9hWTsh6pCKSiHGongLms3AIzwMAE05PxRH6SLtKzVf
         wp7CUXV7HuwaJpKo7S/qs+xkZGRtlqzjzODJtlWoGHHd7prC4Qsds4q2jYhLV4PF1SYW
         PM5KXNh1pZKmPvwY368enQk5rjxuSx/j3EhiIo/GT9jxfHtupuIQnCdLXAu3YLX6t9Bv
         k50A==
X-Forwarded-Encrypted: i=1; AKwUvBx5Ir5h5sEfOrb9ehj6AOSVCaWTacsRSZI/mkj3+SXheZo6hf1fRGdQz4qiR+jq6L3TSVxNMGdd9w==@kvack.org
X-Gm-Message-State: AFuF++lS6XVUJ9nZxk5nC++9qWjK1iOWftHRfMHzJmQ8qxYnZdNTFtdD
	BNdsMUFWjSV8d98gS8rbhLY5xOiy0jsLXyzRM65xbje3J7SdICkmQsAQ
X-Gm-Gg: AYBFou0MBRmrTwICRg/QJf0iZnOxcZEYQVv02bAHxRr2MwEQGUaV2/yy0h/YePT5lMr
	DSXbezOp/oWb+iitWpmcYjf0WA1VxAdi5ZFtumSDPC7A3z3zL9eqQQrVInmz1X1H9flZq1V4I2G
	cheLI5u+YiZQIRs0ImEPl24Yc3C0j5wx4jsrhT7DDfU+QYB4th0uY0GKP2XE98BA5S7FKtAd31l
	6VHWSsPf4eqYIjYQBwsVWRCkCENmsLBtRlgc/EqowAYCy/iO4RuV1h6i5a8AtajudTcoJ4IdE81
	R+BIC2qug1soMLONHN3vtO7ec4JL0/T0AQj865qHsq5Ac63breLg1xJvHiIqEfi8umMXxSFBYTP
	lQfT01H84TY3jGwRHk0LIRP0ez8Do2sCRyXUAG7/3kgwGP2jLcFGw2Znzcv6MYryT3qt4pwAjpv
	6Vy7g0G0+aW9aKLSJPAkD7O+R8r52pXxrHalla8eBWf9GeSqmIJBPv5SUJHzWI85EMdI4KVg==
X-Received: by 2002:a17:903:458b:b0:2d9:51bd:534f with SMTP id d9443c01a7336-2d951bd58e9mr1320725ad.10.1788194516382;
        Mon, 31 Aug 2026 09:41:56 -0700 (PDT)
Received: from gmail.com ([185.220.238.38])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988a1d6sm39974305ad.55.2026.08.31.09.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:41:55 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	akpm@linux-foundation.org,
	david@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
Date: Tue,  1 Sep 2026 00:41:42 +0800
Message-ID: <20260831164143.2517715-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <apWlLTa3oZq1wwvR@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nwej6do8ewxee9ipnecayaie58so1egc
X-Rspamd-Queue-Id: 49405C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788194518-877781
X-HE-Meta: U2FsdGVkX18NZBa2J1WOIfYdxJP/qNhZ/Q0XyGjZDtmB3ho3xJX3vD27bYVZ1bqxGDfdws9406X5fx2CeL9ute1vns4H3fTKC0l3nJYl43eUdrgHDyHT6f05sHRaFBNwiLs/KVpkpSf3wOT5I8/Ify+362oB34KL/6kx0M3Hlnx02kDGx/6WthEdjEDr6+zikusPtPI1MmyIAz1MKE0+qohcVA0T2mbOdYqlOinSVCgAG6mIJ2ISyUM+t1+aJg8IgoVDk+FqBcXcjDg59WM3EdXplxOJZTYyMqOT7cAKUT+GoEJ7j7GuT8mruWtC1i5P/J/BRMY/Nb+EDsAMgYkHWtAh1l5QGk1trzpNYUJ4a1tXdC26NIaaL7+02R3w3vOeNPB5dOgeGdqtgvdU4K8VM5q3PqOIvlgj5JY+KGDl8R3gQZW+LeauL5+z+EcY+sJ2EeTgE9IGogYGIdv5/yRFj4KYBAXfe7gPaQvMBkOQuNY02mzJYRdqPuqnX4LSsVsN1IGJB/NOQpAsDRbfAn5Ry9c0xkcMlhoBofmmt/0ynKMJlZEPDM5Z2GP89AJTVSlRCYL3WcNIOggm5AjtzAkIZjS3DqpJKlMbtzJOUMpKf055A8uWogan8sTZwpT9lsB/Yh71qJwvKjRuTpXUHgrkJqxsLoC1ypV9b7ItNbGv6XLqcR06HO4selRoCqjo44gcSdFxIL7ECNI0bOntzAmfn5MlECzGY1xuA/C1mJyGOhxrLF62B6QCtYQNzdM8voEAA2JrpfqF0wWlkwHkAxtJX4F5HCeu3eWK5gFhSzGzPd0hpTDeyAlW91C+z7gGJbThAhbQtcQR7wQ9vQxK3Kp8/RtvVQ2MA/fSsi46b9nzq0KKlLbjb6a5GAHn90UE6Kalf2LR3PvhmTktLiFkiL8sMq5BZUOZyexNROgJgmZ4U+GtOSW7Gk3yrzP2zwXV+jn0dm2PelWnxHvS04+E60i
 i9TA3xJS
 yHZvd6q13l/ltZz52BLIIYHB5LfUmaOjyWzFqNtCTEt3tCkYcOYuh28kweUGtrpzb/k3cmVb/zbd38k7KSk0ox4ikSMeXSkzB4RE0obuFLX2MJI4EjldSEtys62cf+O/ORR7T8L5/3AeEHqy4rCS1MBp73JoY/CGfE0OJAcX/fsEEJcWvNguQiWJNa+0lzNYV0BxynMn3bLLZZfuTNjb2MeiAQeiMrsL4jGeCWqWFvFNVLeXaSM+OIzKWgcwp0I74LBDtOo2pDU6nLg44v5Ysd1GzIHX7NZsjJJR8xu2mC1PC/ykV7q+1zlDZa41RYIwoo98KYnmUmdN7LqbuGEO79zM2PrWtRricpvV5Sl7I0kjJMHLBLEuMnzzZ+eMOQ0Zwlw0MiQSeNrQp16Rx9lqcJN7Yv7++4H54hl0vJnZWX4PfkZxlm/v7Tnmx77GL3q+W/J5DXLAZ7auXPLxZr4i1ORyqiG4ZPZ1JDKGokykxv3oI5+m9WHjqu/J3p5AKsSIkmiuNyYdmcwlyOeb0EAI7iK5Z4RwrlrfmBBJREf2eQPCa7Pp8N5hc+318BnglZvy28FU0alGz+pj2Jhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 17:00:56 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Mon, Aug 31, 2026 at 11:59:12PM +0800, Kunwu Chan wrote:
> > On Mon, 31 Aug 2026 08:28:47 +0000 Dev Jain <dev.jain@arm.com> wrote:
> >
> > > Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> > > try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
> > > the folio_test_hugetlb() check.
> >
> > Yes, the d4ec5572825 change shows that try_to_unmap() dispatches
> > hugetlb folios to try_to_unmap_poisoned_hugetlb_one(),
> > so try_to_unmap_one() cannot be called with a hugetlb folio.
> >
> >
> > It would be better to add:
> > Fixes: d4ec5572825 ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> 
> Nope, let's not thanks.
> 
> This isn't a bug.
> 

Got it, thanks for pointing that out. 
I mistakenly treated the stale code as a bug.

Thanks,
KunWu

> >
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> >
> > Thanks,
> > KunWu
> >
> > >
> > > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > > ---
> > > Rebase soup - my huge_ptep_get() fixes landed after the refactoring.
> > >
> > > This patch applies on Linux 7.3-rc1.
> > >
> > >  mm/rmap.c | 7 ++-----
> > >  1 file changed, 2 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index d1819fd699380..606c8ecf31302 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -2299,11 +2299,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> > >  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
> > >
> > >  		address = pvmw.address;
> > > -		if (folio_test_hugetlb(folio)) {
> > > -			pteval = huge_ptep_get(mm, address, pvmw.pte);
> > > -		} else {
> > > -			pteval = ptep_get(pvmw.pte);
> > > -		}
> > > +		pteval = ptep_get(pvmw.pte);
> > > +
> > >  		if (likely(pte_present(pteval))) {
> > >  			pfn = pte_pfn(pteval);
> > >  		} else {
> > > --
> > > 2.43.0
> > >
> > >
> >
> 
> --
> Cheers, Lorenzo
> 


