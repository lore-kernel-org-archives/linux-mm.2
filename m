Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAC7CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978B16B0093; Thu,  1 Oct 2026 11:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A136B0095; Thu,  1 Oct 2026 11:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F5B6B0096; Thu,  1 Oct 2026 11:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0366B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:52:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D67381C24C2
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:52:52 +0000 (UTC)
X-FDA: 85274500584.10.770D6E3
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 08A601C000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:52:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K7XrkJ2p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSlkzBUmp3M8NJ8QezoWTcsem1pj+Ihncq28ei+hc8U=;
	b=HBvgciWyd1kuaJXul/S8cVfbc4ZBqLphL1f1VScR1sIAxh13/Ms5m/Fhi+su0Gb5YUBN8g
	glWbScssUqBcr2Ss62CvobxsFPHW6FPc0PZ5bnH/IhwcmrvFwt8WOZVioLpxQWkl0Sq3aV
	gY7AKcfMa1My4l7nllIdAd6oy2XKws0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K7XrkJ2p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790869971;
	b=mt7lir+LKHKst6H5C/HzDHRCJ7cv7CiQmPkAV8ul5M0whYItRSeesdb1z+df+BBpB4Luo1
	XiSpfknovEPhS0NDQmSB9Q2KRZD24Jigi2KP8hYdg7dsLF3qvEUxN35CPWdoNWxYXU7tB7
	/aPLke+m0pmnwerIoKqMlsioHznds0M=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a8b9acbc6so1035687766b.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790869970; x=1791474770; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fSlkzBUmp3M8NJ8QezoWTcsem1pj+Ihncq28ei+hc8U=;
        b=K7XrkJ2pbZJ4hL01xoDjeJkxuhxa4mGREJXKEUnN9L3QJWSyuQ0hvxYm6IDMUreQaw
         624qXJjGzlnc/OQJHyw+aaZOk+hxIA0chjV+MEOaGj8DeIHqFnXwOcNpU/Rxaw7KQGhK
         guhOBpNYefrDlqXWjc7aTs2MFIC5tnvwoPINii0CvE9laY7Hl6IS6CcC/OJxnfVHppT7
         QccRc7xkLoLVUtjQv2CF2MgudVGugqaN8De0pZUNYixnshwSkghCMqoqPOUaLegSme42
         hEMn85F3URelQP922V5Tx50RjpMi0kyNH3Q2ZkfMzrU06aOZFtaz30I+Xv5V5ablHyTp
         v9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790869970; x=1791474770;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fSlkzBUmp3M8NJ8QezoWTcsem1pj+Ihncq28ei+hc8U=;
        b=ziq6kmPuSoKZ7Ns6Y9OMifAegcT4PxU8h1YpK8ukHdWlwhC3p7jMLg97DXJXx2t/jn
         Whe5GKti5zyVkqXN8iP3g4vPwDertHO2nIh3rMjm/bQpvTmdloISJWWVdc/O/zIpra22
         gm5VosX9zBMJzdGI/yPk6iL2dNdNCZ5knQJfhZExhKBTn1CZ4zghvuHkvFlNp0TBxGYS
         UXm+U3sqDMIyB53+Wec0ltdBN2gOvVkq70efoCi5SSCnTTi8zKUQhiJcg0GMG9c2RVjR
         lNS01AsJ+uwcYxbiFi7K/WeX14297buCSrtCjkRfjWi4VK/Vv+nQiGMtr7NOWTW19luE
         0VbQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5LiUMZTqYxpfYBW7e334+bEUcpuFxFKL88N4U6RJ2/YXJbEnCdD/9TsPvK4SY4KSHD7wYefjPcA==@kvack.org
X-Gm-Message-State: AFuF++kDj+CYlPjG0F9CNR+t7zVy48oyFaSVIXn4JlrB1JSmvVmmSdbi
	FPWnM8bn/2co0qwLx+9JJGMxoAulYu6CHLyDrvXCBJf7QHAAjwncOYJI
X-Gm-Gg: AYBFou2xVatbn6EpHjkvH3NwGrMH2Hxv1QoFuuLveyQe1rDzQefF7W1oYXuehmsBM7I
	41A/jRlHjQNxPIf6ViLpDHu7SsuGXPtQEo1occ2vfAErDXDGmVm/LuWrbVLLhzGxEvcmCj2rO+r
	BnNWd+ltL8ajpsSLfJOP3xWQk8162GSgCkajuUzuQgilH55SFxoSToBi+1BYhE/Ntw+BAyj1A6C
	+QvDvU6YC32lkbZcvZQmHL+f2Q4JRPWMtuYaGkr2D/h375rb/EVSv1Dy+waYAcIqIAHa4vXcRPK
	fAeEqjXjbnS5gFdV0VtGV8UpePQRwKyniIJS8IgCZK5pSbft1b2tZE4WL1yVKhBvcb1sJx27H92
	y8Oq4WJegAgTUdtGjaGki8gvxhAPtzOo+h0tu0T9Tgt1tTZSaobPCqBUl84OlYoOaND2H4Z2T/q
	NePC7yWoJOSm8Ofyt8mAHwow53qSn+0tDotyhKRmsr02pgBg==
X-Received: by 2002:a17:907:9406:b0:c2d:23af:5fcd with SMTP id a640c23a62f3a-c2e23e1fcd8mr487499166b.44.1790869969629;
        Thu, 01 Oct 2026 08:52:49 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31dc7393sm179858266b.65.2026.10.01.08.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:52:49 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 1 Oct 2026 17:52:46 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	catalin.marinas@arm.com, linux-mm@kvack.org, will@kernel.org,
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org,
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
	leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	rppt@kernel.org, ryan.roberts@arm.com
Subject: Re: [PATCH v9 07/10] mm/vmalloc: extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
Message-ID: <ar6BzubFrn46vuTu@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-8-jiangwen6@xiaomi.com>
 <ar0nuJ7ocTMgbiMu@milan>
 <CAHKocdH-NeWYJBrCVfGctuDyh=D4a2YrzUf1VxB3cG7Di-EAMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHKocdH-NeWYJBrCVfGctuDyh=D4a2YrzUf1VxB3cG7Di-EAMw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: g9wx8jat7fc7shkfipmzf5io9qgpbthe
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08A601C000B
X-HE-Tag: 1790869970-576031
X-HE-Meta: U2FsdGVkX1+ohGtutlW7niYZC3eJoV/mdhvEPRCl5Hwug9DXETDTos8Ts18+2ZxC2/7IUrwBsSbgA+OqjdajfeHoIFhV1h8AZg6oMw1pMsFh4QcL8PTXBJhgHe0d3ZzgdLsPHv573qclzIJ0/0IzOxllJtJtXSQBG5pKnhLmxSKcs8sOwG0Z/8bVyJEhgVtxhp5//N3Mi+j8hJBt8b5h2e8EffPZt1oUZQVTPZmk2CByj7GgrrK6kYjpsUIifQ7OPMeG19+yd4BDVht6x7q+pmxMjZfh3eOx2SUIpUnr+/ojKxp+wUGcK9v2Nv5U6tNnkQZ55Rykqecz1nGoHhJsnqBXr79JQZYDOTIyOVj2orm+5wUkBzsskFEViO712O1WBScuwXj2X66QZpan3R8W1HoYdHkwLzV42Xay4oLpNskWdy7S9v9R2Z9/mPfRTew6Gpyhy9TA5CPqNF50VWDLg7aVjAb2UFV98K6EguWHF8VHRhvstIKDvhrpOLShaEtvy4+pygxnPqsQYr8aipQROEXbuKqCaNu4aK/YB9XBWPBVwZnsBCjVtHzNHIel4kKPYzFmcD8nUCqsgwqI0iZIlBd9hB04mU0yndvkxDRvx3E+glUQyjcuShyNCryZusSfxjpPJcFYBeb7WdT9dBXtPX8OY6HzIVz65yKR5afZrKEe5AWpClohsDmW1CxHJ76EPNDgzX9g9CenU7UpUWwX0DGO3AWNG/B8r7PWb5+s9SadYsJkH71B0+pD+jWlAPSlBI4zBuZtxhTaeHhysd5eR6xoaBU1qyBWn3QarsRVKkw/FaUlFiNwm1COTrbTAkkjRx35BtaWIQvixxtRWJQ7UZExya9V9pf4tdn1Z8xC5QMynw8Tc9Skz830YbyXqIR7RWuiZamzrXlXC+fOp3K9e5v1dzVIkf+WSC07ew3tTmKvHQvT9j3eLtvMA3KUOf+195MZmurtEqbSup/7/WK
 M28UpUdF
 0gQeEMBdiCaNIj//4FsfZd3Gx5WUYhreJl2E4HFPBUYCA8mWeDzvnQxiJYtmrHsuYAf1rr1GSBKveim353lFnO6Kw2gyPaDrzlDOWvG4OCdJiIoB74VuUwWTdce9JJfTWVk2+h8KxM+P9E4RReXGu/+jEOb0Ye+lmoF+F5KuFKFiTOFheZz7oDu7hfauyaYrzEFrUPPqhBKXKcaxOxPUGluP37iruleCVcRx7LXq4ATySwoTTIOSiTm7410KUTK62W46FcH0ZSKFfIJuqXCdLu/dao/lXvkcJk1oniEhneINfEm1TmArsrGxpL5+w2NEcfyDrShMcQyY6kq1SMCqlKDOh3hP0Cjw9bnwZ27Tc4a0gDYy8Dzk3kcieymF3+XZvGPPBMWsiQgeb2NSnfLqIav9f0xhWM+snay1ECQxTRzoYomlYi2+w40K6L6iXtQT2ew0DY5vnASnAygucUpxNkC1D1Kc/aiH7C8+wqlLvLDG0irvnUOf3O0sOOOm4W2EInCGajaH6H7UCTy1tRLjKr9ghEW+P5S3148fWns6g5kqChmlwUaqhFLE81rFqLIJMWFTOpkTHOvAJpDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index d475e52110e4a..6e0dec73107a7 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -558,8 +558,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
> > >
> > >  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> > >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > > -             pgtbl_mod_mask *mask)
> > > +             pgtbl_mod_mask *mask, unsigned int shift)
> > >  {
> > > +     unsigned long pfn, size;
> > > +     unsigned int steps;
> > >       int err = 0;
> > >       pte_t *pte;
> > >
> > > @@ -590,9 +592,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> > >                       break;
> > >               }
> > >
> > > -             set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> > > -             (*nr)++;
> > > -     } while (pte++, addr += PAGE_SIZE, addr != end);
> > > +             pfn = page_to_pfn(page);
> > > +             size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> > > +             steps = PFN_DOWN(size);
> > > +     } while (pte += steps, *nr += steps, addr += size, addr != end);
> > >
> > nr_mapped_pages?
> >
> 
> As noted in the patch 6 reply, I'll rename steps to nr_pages here as well.
> 
Thank you!

> > > +
> > > +                     if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot, shift)) {
> > > +                             *mask |= PGTBL_PMD_MODIFIED;
> > > +                             *nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
> > >
> > *nr += 1 << (PMD_SHIFT - PAGE_SHIFT); --->  *nr += 1U << (PMD_SHIFT - PAGE_SHIFT);
> > as it used to be?
> >
> 
> Agreed, I'll use 1U.
> 
Thank you. With noted modifications:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

> > >
> > This is not about this patch but probably on that WARN_ON we should bail out
> > early.
> >
> 
> I'll send a separate cleanup patch changing it to:
> 
>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>                 return -EINVAL;
> 
Sounds good.

--
Uladzislau Rezki

