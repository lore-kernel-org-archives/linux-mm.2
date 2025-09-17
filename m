Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8616CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 04:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1983E8E0006; Wed, 17 Sep 2025 00:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148F48E0001; Wed, 17 Sep 2025 00:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037A68E0006; Wed, 17 Sep 2025 00:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E39668E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:41:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EDEAB8E4F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:41:23 +0000 (UTC)
X-FDA: 83897493246.04.B213CC0
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id B35DF1C0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:41:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L8wXkYVS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758084081; a=rsa-sha256;
	cv=none;
	b=MllLHmfKAADvs5hAxz6R1312rVkpEP4EN6YfnGt9X1PUtIAcggZWj+i40YZtYw3tiOaaTA
	nRzAlaSbeBzBgl4nLn3ezN8msHmmoKSccb2lPdx3iYVGcnnRmdDkQCnWXARZbtYEA5M/t+
	NyDxZmGTkhtYQ42JBaRDUM68clSEwJ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L8wXkYVS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758084081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gon5BfaqGtVq5KGh55kJh0yGA0JZXCzjrgKlwNh0aHo=;
	b=oh0cAD3JEso9/UN1eBABeWSepy1THs5+Xpmm9tJdKxeIcMOWO/BH8DuRAz2Dg6M9XZq1OQ
	O64KVPCOxweWzdki17RF8PXs9r+Wd3TivG0BKbURO189SJUMemnmdMvn4r6uQKFMC/OQ0P
	NC43Wv4d3M7kPeE8W2QuAZCQqkj05UQ=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-80b7a6b2b47so593217485a.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758084081; x=1758688881; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gon5BfaqGtVq5KGh55kJh0yGA0JZXCzjrgKlwNh0aHo=;
        b=L8wXkYVSE+XYo1Xd+M6uNluhAKSqAGewz0iPOXYEbQX0cuPLadey5l8G4RW/8RNr6A
         BK4eY66WKjptQ2jQJsvRZmLH75cp2BjLbQ315jjU4CTSADqTTHZV7A1vee2yiOuXCiw2
         4EjKuYx4lcEJVtR/2KZ8ur7hl7PYgfhZVS8eS2hcmj0xtMFXQSPgNhCuu0cG9H5VXkJC
         h8HKzw70KenI/Z0eCjakZc7QRO1IMnw6k5hiW9XuWJ7GIyTUCTnACltdZoTonsbPixG0
         cFvy8xYpSfLhVW/VeCyTui116BJe5sABsS8b32AIEr5KRPfLsEh+6k4ljoJbmKHQTTrU
         nokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758084081; x=1758688881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gon5BfaqGtVq5KGh55kJh0yGA0JZXCzjrgKlwNh0aHo=;
        b=pShlX6PQ8iPXXYVvieM6dau3Aa7bLDxlMc2C5Qc7jJhjBNjiHiZg09Y4epFt1FQVuV
         bTU+S4G6fZUNiPkuaJK4a69x2E5FYc9ISABXOlTmazbTsIY54ifYPVCnq8KKaCkLFFUm
         M4igLp3JaaXXDTOnF1WEi2F0tUPBcr4Usw30fiWzQiuKkcBR9KR2Jckpoynad/ZU3sdf
         kWxNxP1m0+PlYixgEWkAaa47vcg6N3Dz/HziUY/tlI82/QJl5urb0wLr3neH2dKCiHr/
         0s2OT7gcv8jD0AXH93s41R9QG0mqASeDKnHxx+9lk3pWNpjgqiYICDctPQgdVpByuYST
         Jptw==
X-Gm-Message-State: AOJu0YynoUlg2qObvC5kbHhmxm5BjGMgabduhDNZ5kIEEfJDRUOJZ6ud
	haF4b5BjCi865+BP24tPDIGxtwoQNhbV4tg3Hp4vhdid4v5veGjuC90XDS0cqhFwsHl/aFEMjMy
	ydX30FjJk+6yi0A+xyiIpTYTVaR5C9lc=
X-Gm-Gg: ASbGncvtFJz125NoUzcdcfDxpVpJWW5QUIdU0fjT0hZTLYFIYpyCJa0BwhdJUlRy8k9
	YYD7uTvmAqGXyt1JeMUAbLLBie8c7UdMd2Ou2H5GCEyVhoLcaEx02dfIq4enH5i+Ui74t4OREaC
	HpXbeFDn1GFbsHtpnE0Rx7QLZy4ekRC0KVREdr6k+fgom+97yBrAmNKqMg1rqZUNB9y3bSPBaCF
	Nl2WzyeU9/erbua0TUrhljs93V7mgwclECrcUme1A==
X-Google-Smtp-Source: AGHT+IHmqnmNEJt9Zp7ueUn+TKxIVVriRysUdeARSQEDPs7LH5hJe/p5khqKRU5SiZkOkKGakYwYphqODKUWjZXhZZ8=
X-Received: by 2002:a05:620a:2887:b0:811:76d4:6d5f with SMTP id
 af79cd13be357-8311053c402mr73152285a.60.1758084080693; Tue, 16 Sep 2025
 21:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-16-ryncsn@gmail.com>
 <CAGsJ_4yrDFAe-3sMj1K2JeWrqNXCBvYvULY06b6B3ogSYjqasg@mail.gmail.com> <CAMgjq7AJ1=ji4iw03JmdN07MpY8V0CFdtUHpF58mTnSjGf=rGA@mail.gmail.com>
In-Reply-To: <CAMgjq7AJ1=ji4iw03JmdN07MpY8V0CFdtUHpF58mTnSjGf=rGA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 12:41:09 +0800
X-Gm-Features: AS18NWCg85JktjCHMlaLqxFptGC1bgva_j3Nzmnq8WvHDBi87jCKk26cFVpIEwo
Message-ID: <CAGsJ_4wH8ATOQLodxm7fEZb7Nt0oCxeyuiiUcf3ZYBpyC0kiFA@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] mm, swap: use a single page for swap table when
 the size fits
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B35DF1C0004
X-Stat-Signature: kpcwo87ktxnnatmkejej1t4gromzcp7y
X-Rspam-User: 
X-HE-Tag: 1758084081-934959
X-HE-Meta: U2FsdGVkX193pM9WE/aBIWD55x24b71megr7SHT2E4xOCxQ3xb3cQumoiTPhZu0YCsZA3It8LM8o5LqcC6edX5DaGosEiP0kqDnY7+F9dq5Bhf1CCQ7fVSe1kWT8Ji+LpodMSF6AZR7uhrJhkbqn7IS3GGvI7zYNrjlNwNVkLFBYw8icwq8/Lr1zYgPOqQRJTNNlheMiKfDT2kBCCjWTt+x1Mrfe7EpXjXqygVWsG9JMipdNGfOFerRLlXYamMZSMQzYEJGSUSzcJoJk6ci9spRJB4W5tO4KkSeJb4rkJUyDNR7NyClgpGapymWRuVq61dXBzKMIqTkupZaxrpFC2WEsH/g4RjwVljqLpge07HVosxJvM6Ou1aVTgJT4lFg7wBIQK1UpClSJkKz3O1GEIcTdJwfPzfUOkI0w1Gnxx/TIjnhsPYobdbLK8kez2C94ceFIazYVJEC3AkZbAaqatweAp/VG0tan2CA2CANcuFKWdET2NlhP5xJ1KUyoAEMFx6HTcGEA/QpNCYtLC39RT6kQlAtHACKfk1X2t4gC40s/BxkcZVRYQOeP1wx9/+mkYRf97LYK0laHn5zwCuk+uNupOOzn/V/rLX1PU0izP/cRZcYPeZ2a4lL0+0LYjPtQumqiYvri8+G4ZvWvgdKnoB+vI8usTa+kdPK8DNtV0/o8WZtV5C6bg7u3vweqkCnaE6ir/n2mZbeOmJNX+2+50bdCATvZyo/NKLfdizir9D2lDMCihrzaSW5Q3izthO06NEYBXu+e9cYGb6RF6GBlz9wElIvsHWGcCr+5Ua/qMqPAsvwMtEQDp99rlrRJLOBPnZVeSDm4RiPt1MLIt5EfZlO72/oKxC1t/wh5YdTmNLuClzPK+KUTeXQ9UjPbNAJdKrJ8/9Xn0KsAmao/CfgaqnAaY9SDTI+b/yKzaYGqMa161HG5NGoBuimTW2V1kSx5xbRjmnNlOZXGzo+/ost
 RLWIm8TI
 +3Y0bnhjfHaPlkv2M/f7/M3QEltA6W3Oj2ibjvzVvqR3AV/k6zQFZO3bH0occ9oRw6pw70EYrySgyQkfcPZCYbECq6uZ93vOk0uGDPU8Em/4seEIi+5ClG15SrFFTVIwrciUa3e7IJ1Ubcb1KW/CML4m2huvh1CEgVgUVL0jJZt53uibrAKeRgnEzhecMVAYKcZV8XXb80JTStOO0SwlYl2Oc+GpNkX5eMa7CZ4wy5tocD+z7tTbya/NiUK7g5SAv919i161d2PcaobsN3AjNkN1GUexvXVQHsHmAYUROXTC83NQk4QWj6waMVyWVMiOgPQMpRO7iRfg0sysMT/jxpnYpS2sXrcZRI1+bF55nGRYE5l5sFd2PutjmD7UPnE4rf+q9iWqV/dwf/xhPmJT1Frn/NLcYNBdyjZgQ1/pwbysz17sTrfH37CzqQqF34ypBzPh14N8J61nqYGKJWQR5Q2FyAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > > ---
> > > +static void swap_table_free(struct swap_table *table)
> > > +{
> > > +       if (!SWP_TABLE_USE_PAGE) {
> > > +               kmem_cache_free(swap_table_cachep, table);
> > > +               return;
> > > +       }
> > > +
> > > +       call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
> > > +                swap_table_free_folio_rcu_cb);
> > > +}
> >
> > Can=E2=80=99t it simply be:
> > virt_to_page(table)->rcu_head ?
>
> I'm not sure if we prefer folios when possible?

Not sure either, but even Mathew still sometimes suggests using PAGE:

https://lore.kernel.org/lkml/aLrrQDCBzaMwwmA-@casper.infradead.org/

BTW, "(folio_page(folio), 0)" looks quite strange. I mean, why is it 0
instead of 1?
Although we know it=E2=80=99s always one PAGE, 0 still seems strange.

>
> Either way is fine, they are identical for this use case.
>

Thanks
Barry

