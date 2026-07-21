Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94414C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C476B0093; Tue, 21 Jul 2026 07:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603BF6B0095; Tue, 21 Jul 2026 07:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542A86B0096; Tue, 21 Jul 2026 07:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1006B6B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:33:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82A864047C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:33:23 +0000 (UTC)
X-FDA: 85012573086.24.1875730
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 535A818000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:33:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lxCm8fRX;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784633601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ClK9kZgJgn1pv+f64kpoxUD+b6fg3ben0ahgbGiQz4=;
	b=2x1p8xz6sOOJo+4npBO7RbKdiwoZ0sTNfAzLW+fpvxO1ndq/87iosigyNbbOfVAcVa3vZ4
	t9mgwDseawJcuDNPFGcrFMUvUW3t3Fkcmk7RXc4Emcv0DomTgiMIKjt4KI08Cz1ugR7EkV
	4cr2//gAXv4lXswHu9rd7+iXsz+0Yw4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lxCm8fRX;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784633601;
	b=TGxrBbu8wq9DPYp1znP/gJ+Z9LjVPbK1daVBDM8K7BfsZqUiIcwUixBUvTAcEhD+azA5wO
	++tZy6ncXAFupNfMYaEx6r3qFOdmqMrauDVy6mFGMXg5ooaOE9yy8oETkgNXa04/lVZGKV
	BwFMUDFsMqxtLPJdHoNdQmblltI/9YE=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9305a2121a1so782196185a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784633600; x=1785238400; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8ClK9kZgJgn1pv+f64kpoxUD+b6fg3ben0ahgbGiQz4=;
        b=lxCm8fRXJHRfTm9/gFrm0EFKX82NrPbBe1WrsZUE4yjRhKZhbAOYEIdR4QiXQHn6wJ
         avUwoVSGXmiPmCZ/lT7NyG0e0r6+JI+X5bWIdMBgaDaVjoRc1Ok+hBU5KsFifgpmzcyU
         +md7mdYk8hOQYGvqlmZu0K8rPvaqn/Bz73uTl6uwq3lom3ApROkswi0WTkwz14+EYmn6
         DneQ9/kfbFnUl4+tGqpnTQdwGGKID22Czkh5JDBaRinviqcnKC3/f/OzPetkxY3DEzPk
         Olho06wjLJ42C6jkdwaoks235offVCGVtKAtsQ3znGz48s00fiTdUkcrtUf8YYeZz5XL
         vQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784633600; x=1785238400;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ClK9kZgJgn1pv+f64kpoxUD+b6fg3ben0ahgbGiQz4=;
        b=Xr/R5F5+4l8aUSr74Xel0HNUU6s2LRp12oNbMLO1OVmmmF4l9YnYUaCBSI+OCHn/d7
         vr+lEu9OF293LA/ggC3Nf1e9wYloQA2wcis+05N6q7evXCU0TwJbThfB+ip/QJdLtdQR
         WvSuY7kz8+mHjpzHRfCbgXTKWWSuWJHB3d4lKpPmfbfFiVy/dXl1GZkj89Ie/jckLWm4
         mUoXO22lSEMgKVs/z1apMHE++gLSq0zYsscgot8lusfwES0RQhEWi0PGnMTdlYSyEYSg
         MwnK3UjMpTR4UrvjR3GCN52gO/MSwNkksyPc927b/peSI1BQQ9HWp8J3/XEE/rcie+v6
         q3qQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzqI2hU64fSch6ZwiAvp12x0Wmic/YkFLNWhu0B/orczCXhzI7iY2cBrNP7YK4srMDZhOD9/PwRw==@kvack.org
X-Gm-Message-State: AOJu0YwRJu46b/sFCWAOdm4QOrJgNVyAen57AKlZiY/LaCCvQcl7vmY6
	X6NGrsNogQqEyrujCGgEPamreXRfTltHrzzNlEsRS29XHcSThwctPkrMgSEr296LENI=
X-Gm-Gg: AfdE7cnxk9C3FdprrWU4aafSUPnmy/wwvNem6EUWhbnkLrM9YmbReXDyuK9RPuRCmMI
	jgi7xCMqOx1K1LGPeN6q3+mKsfyf8OeXLH0UYnYtvexP2uG7ZCuaD6zfttYNGLTyYnvhgLguT0F
	ih7Md8dvw0XXWibiJ0HmfFH3PHRoYR2svWZjmFt30eUhrcFKFotTH3be4NQsSClkOoH1agbtoaZ
	Aqop9TfrgZfToh/i/CuztGini/npeoj573hoj3CLM9SWZA91jbGgvthHtqmY/0Z8YXoQbkk7ia4
	pEIAsCasKxOwmc6E+HJ7owPFgDYFPXfo8UijWTXDDtiUjAl43LtA1tcLVnbde30Z4si4bEn1Ypf
	2XzYuUu1KyWFHROtpzjDPTZSMeKnJF8OaMjoX6+YCxxtYeB+BejTpsh66AVkvNVDOoz9GtqxzrP
	Jf
X-Received: by 2002:a05:620a:3709:b0:92e:45e4:c6e with SMTP id af79cd13be357-930b3f37283mr1768481785a.22.1784633600331;
        Tue, 21 Jul 2026 04:33:20 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e253sm1074421785a.36.2026.07.21.04.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 04:33:19 -0700 (PDT)
Date: Tue, 21 Jul 2026 07:33:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Yosry Ahmed <yosry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios
 directly
Message-ID: <al9Y_tZH5AzDkK5K@cmpxchg.org>
References: <20260718093723.153324-1-alex@ghiti.fr>
 <20260718093723.153324-2-alex@ghiti.fr>
 <CAKEwX=Nn0dMc1K9drXFVMwt7wMZ2P6KToeh7T3rE1+Xq5yrCFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=Nn0dMc1K9drXFVMwt7wMZ2P6KToeh7T3rE1+Xq5yrCFw@mail.gmail.com>
X-Rspamd-Queue-Id: 535A818000B
X-Rspam-User: 
X-Stat-Signature: 9tipdxfherb8c988uwibaot476y7jwgk
X-Rspamd-Server: rspam04
X-HE-Tag: 1784633601-398517
X-HE-Meta: U2FsdGVkX1/C3jUkuiT9C+Oe/jmZcjR+/iLIMAcQe+4rLeMgvdqh5MlN0AcyWzY++ztKz1GrFHzXNW7KZKpBY3MLstFArTZ7TwU+0gVNDQ0XlhpB7Z9eNK5w8FBXNDXQRUmjy/14phGRK6qRtQi+AWBbn9s41lD+qf4TWD3M/TOx2vwQB6qyCbsbpbUet71EFR/VBXhNUssE2ReW0uSeNmgDnWJIzXlwc3poVfREA0PKgPUai2q6kg1RqbXMhnqdFIpei2gZSuHp7mh/FBp8ZTwoD/NONa4RZb7gWbPt/s/8u/TQZlgM2LsCqK3tLGPuFQE1jeQ6XC4icfogjnUnSwX7NdsNi7vUKb5A15bLewTRVINPWvNJvK9ubuANUizfynkKJaWqkjp17BXKUxqDaYyXa4nAjA4DTtv8QtmoeVVe9vV70nEWlnwJN9CvIgAFlORV7nk+ea5RZcTiK2SB+qxNbM1v3XuebGWf1ZtCpRxgjnIEZDtREWLCQ9VcEzYg4anO4dsEsDTCo8weBRIrhWlnR+J1paF9jKU0ocKaA75E0KKf2On/dt5YL5pCF2Bcob7aJIaeLBZbOq+5eHr3z9IsU2j3W79KR4kloOolkKSxnKfbk/OK+isP3gM9vSm5f3AIgGSXwAvgiFebV+aNQ3u86kUCDl2Pqn1WJrUtcEqR2imnHc623Z4ntwCF+FFIMKby0NNLlI+i91moqSQw+Vu4IFwbIxuMNsHca46sm/1Hw2/V9+ilgnardOaGg646qCxPFhJb9lCTZaS9SFL9vWr3fVt3F61vI0nRWq7XxKDIG54dVeh5VXxI2WDa/wu6+QatsgNRw9mBbKrRMQe8wW7KHRTo+Hvn2YFZGQKwvZq0GGC5xn8TvmW5FLKVjWEHGB0fjI/tIjJasbL8Ckf+dx5LO9pv5+IsvQJh6vZZgh3A6vc/Ino1D3lkbZ694zLVk3ol8qQ0FMKrM7M2zn3
 39Zuc5T4
 9MhugaBocyfnej1kwNgyYf+HOr7UTDX5LxCOyi6SeFNW0mELr79cawkCB3O4qFP/IVfaBEvhdX69Vr0Jb3Gd+WsvbT/3IxkjUXuJd67Hby7oTGd0rwCeLxzo2eaxwaDL5GFsjiDwh/lbNNMvjudo8X/KZoruwt85dVNpyHWRxwnJ/75QMcqMtiue2UCdVW6cubREJV9IYhfASuuqSW3GgBTvNX9VfTXnZ9X0MZCWypQ624nYa8iTP5kDzczULxikXwpxlNXPO2/gmb9WXjxmPd6A8hXBhafGpBQkDsdhnctvfafPtAFQsx1XM2WNwhbk9aDLt/vrRRJrd0YCIsDf2mvO8knTZZE0lOudHRNVaAiwvmVeGShtkVtYeqUAivCt6zKLNWaMyxt3Lus8yF6U38EQ00g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 08:56:32AM -0700, Nhat Pham wrote:
> > @@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> >  /*********************************
> >  * writeback code
> >  **********************************/
> > +static void zswap_writeback_free_folio(struct folio *folio)
> > +{
> > +       folio_lock(folio);
> > +
> > +       /* The folio was allocated off the LRU and nothing re-adds it here. */
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> > +
> > +       /*
> > +        * Gate remove_mapping() on folio_test_swapcache(): a racing swapin may
> > +        * have freed the swap slot (folio_free_swap()) and dropped the folio from
> > +        * the cache, and remove_mapping() must not run on a non-swapcache folio
> > +        * (it would trip __remove_mapping()'s mapping == folio_mapping() check).
> > +        */
> > +       if (folio_test_swapcache(folio) &&
> > +           remove_mapping(swap_address_space(folio->swap), folio))
> 
> Hmm I think you also have to test for writeback and dirty here right?
> 
> After a racing swapin freed the swap slot, the folio might be dirtied
> and swapped out again. We probably shouldn't try to remove_mapping()
> such a folio?

remove_mapping() itself handles dirty state. It fails in that case.

