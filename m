Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B45C79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330786B018E; Mon,  5 Jan 2026 11:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27ACC6B0190; Mon,  5 Jan 2026 11:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDFB6B0191; Mon,  5 Jan 2026 11:29:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C810F6B018E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:29:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B0B313979B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:29:00 +0000 (UTC)
X-FDA: 84298444440.16.72E8A41
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id D73DA140012
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:28:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpC14z0M;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767630538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhLaZEGztBaqdfRcf1ZLhhb1lILxqOMU/Yvm4+Hg7yU=;
	b=hKjgEOtA7Halum+0kuBumQvJqcpVdNWGrjE3vdPu4d1bnCr8MLuXESsypeRTa75shxjYlf
	A5lW/cc/tIDGITBZoCsGeI6elsm7VXC09zcVdAV3mJr0gqzZqyFQ7s/nL4uY2gmxDtv/bJ
	uiaMwxu8p4PRgQaghmBEcuK0H39vqBQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpC14z0M;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767630538; a=rsa-sha256;
	cv=none;
	b=qdxO9tYWNWzRgriLivb8gQ8eRnjYai0sCKRaQ8WIzplMjYxOevBNj7xSoP7JNkDZJPAAgs
	bk+XEcFgOn3GBWaOZf/RrvrxImzIr8kY9DofeY08hoddwvDa/LCBw6xGuYeA4AzkokoUT6
	nxYyEojbxYH5CoMQLq8nInMgFpCswNw=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-595910c9178so37820e87.1
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 08:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767630536; x=1768235336; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MhLaZEGztBaqdfRcf1ZLhhb1lILxqOMU/Yvm4+Hg7yU=;
        b=IpC14z0M5s1ZierO4cX5E1rXES17SR9jOXaEfGlUyXBkKtvQN54bkE/eiawOQQXe7Q
         KSQGxgkWLZdXbU/kkFS6VcuZs8sbb6SKqdSeSBUezT4qYx527ii3vQlXvfTKN9Q34xDG
         zOLaQ1tbC6BFlO+WKDwkVxIdGE6/q56gsdSn63tPhGsZFQrOqPh/MX3HGET1vE0SWrT2
         WdQ5JIiGfJeWtYiPAlvddgMK+2uMNNLLSjdM6lAHKXQwnOmjySsU5jKAVGu1Cl4HAZFB
         lfddu5UKJfMgYPIPyh5Fu+W46NhAf8wfi3syhKE1TwW/LmUmydVpMHrTOKnRbzjlEjPl
         5vyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767630536; x=1768235336;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MhLaZEGztBaqdfRcf1ZLhhb1lILxqOMU/Yvm4+Hg7yU=;
        b=eBJk0Dx+aLtdzk+umcXwujiusoimniKhjH/pnjAwMdLvHpNKsovimg1m83HOE3fprR
         sT/Zgelv0Qel75GQxS0DW9iFaEsCP3pu07UlxysCuf7tM6Ylgi1eE6K5SRi+jjf9iO3c
         2qlXkMudhNLUkKt8YRNjEbThFAK23gDi9Gqgd4HRYsUim7mIdgvkkFo/+7j26740kLK/
         nWd7NPFkghm6NEy9pJdgJMG5KABBOO+OjFdgpAi/8dkdFDpthJYU2bBEYE2SGI3Hu/OD
         8jQGXNMyfu775qh+7Ie2NDQQ3kTXTCRCMyAPmICx42J3YwJUoifanV2nmmI+278mRZzq
         1VxA==
X-Forwarded-Encrypted: i=1; AJvYcCXpnvbUaOG11M/r6S2QmtWsW+1dlqM1Zh0PZktHlg4chqylb571Oh524mnVJyRb7Z4l9n6tyPP45w==@kvack.org
X-Gm-Message-State: AOJu0Yy6ypcFUVNIfD6xhwOxZn3teH1PsMq08tx0KOuRc8Pqr+/3QMD3
	z6dQsstJpr/EZF0vp0g2zpjaQXLedMxWo51qpGY0M4JOWX8zJCt4AEFk
X-Gm-Gg: AY/fxX5+Yz7c2/UgndvCdXxuRZslaYm+878wKq0C0wj0XzePk1FgGiT18yXeMrfUgoF
	mr2m8Xj0UZttCYis38QFOa7jJRpibZSRBJWkb0JknCwjtyHBP/KoQ2V1rPSfrBbEmhzDj5BhSGy
	Ei2/ZgdwcP5BiaRwmCQN/gIauurSuYJA8Lt1RgVgGHDcqzMDX9YLVrs+XuokAAaDxNoXwnlfJ8p
	5FFhJLYjJyup7Tr4C34+/8f6Jc9wra6gTGqZuOYmake+30MMT5tI6zgxQqNkCrSViosNbUyMY8+
	yPm9fUBywxZxXIN5c4D1ng1LB2lGVAFxnTVJQioerXKgPDgi9Zk/Wjnz9vDFvhJn5Y9kHBOaMaG
	YQGw3p03LOxLhJH5X5D8hhGYFSe3pgLH2bTK4124pz+3czPs2PvWM
X-Google-Smtp-Source: AGHT+IEoZ87k72XOK4WRfNoEGxBoiDEdhg+qxrjQywDuv03+TjElLhMwviVR8rOvTsQRpLgtTWykmg==
X-Received: by 2002:ac2:4f0a:0:b0:59a:113a:f517 with SMTP id 2adb3069b0e04-59b6527a2afmr98478e87.7.1767630535563;
        Mon, 05 Jan 2026 08:28:55 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b655143b5sm5936e87.85.2026.01.05.08.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 08:28:54 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 5 Jan 2026 17:28:52 +0100
To: Barry Song <21cnbao@gmail.com>
Cc: urezki@gmail.com, akpm@linux-foundation.org, david@kernel.org,
	dri-devel@lists.freedesktop.org, jstultz@google.com,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org, mripard@kernel.org,
	sumit.semwal@linaro.org, v-songbaohua@oppo.com,
	zhengtangquan@oppo.com
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
Message-ID: <aVvmxGUp2l0Tavwb@milan>
References: <aUlC6N1jmDbMDPc5@milan>
 <20251223212336.36249-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251223212336.36249-1-21cnbao@gmail.com>
X-Stat-Signature: 8p13cyr3bzsdturb69mt4rfj7jiunqon
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D73DA140012
X-HE-Tag: 1767630537-305877
X-HE-Meta: U2FsdGVkX19e0go1LbPgP67xzO7fXIS+cqNIJfBA85SwqjSTvFOSK3UBQwLTzY5pCf1CWDd8mI6pyP5/S0zYpVjMF8s2tRathz2DOCT/+UK69nCe+ovc6rgrUHretcD2x+ERUlt5GJo+YUNABHEEM8fRuTb2Yk6XKNifFfypFjSXykM6blCMLARghtCqBO5448m6ynBh6RG4SLe42M5TCtIlPLo5QypIfxipnkPhPLDk2cZyNa102B02lHV6MS99/RVWz3oLf8l2gsZHxVZ3wwd1f42eL6fZMmWT18jzaV1Laev85liCeGUiiLZW+DQ0kpvN8jrFeySfcTLjjHdkPMPf9wmDQOPnYXbM2Gp7RAft9mwFGhMf4Yds5CwcR6K8TiFd5gv6nF/WxSWYQX62eaSfnC0EGRJ6zHWggHwxMsY3k4Q7gQWig+pwS1wL16WoGq6XtGmax66WfaagwLUqsyhbTbWvGdAvVWa7V9oQ7E8sOcnr84Zkzy2CmckDJjyRK2bIy1DeM/hOsESji5qwBkJNKbNijvv23fRV+JI2E7xfqmrbESz5aqXjFNFrnLcUrSo4kW7f8s4r/CmZQGJRM7xrpQYl1y3hz78j88FB+rslgzPs6rlssBsZA7SDk6XiXOE9+W77+HKdubdM7Bc6fWDImt4+JBDgDMV9sfYAnRvZN/OaiBCrdncTzt+jEoPQnopHvddcURqV6/qVryy5dz71Nguave8pk6el9VnEbzaLKDKPsQm2m0tQEPuh9uwpB8g7YWyxSQUpO80JPO6j/YWp5fO38Z1IkyUwMUQ/ICJnuAPvqOxnFZQ6kNL2P/7LtbboJdRWOclcpJgzEHkEekuA00TpuUHMdWk9qM7gQpJ+fvn7HrngCaxsQ1yIba67b03m65rwpvNXkhCBdP9+aVWWINH/tM4cQaiyAO2bt03D587WT2oHaqe7XBE/tZrJfevYe2in6Tg52tpPkVM
 1mZHdtMA
 OuAN+/5MtgsHwgzG3tj6q5Ivba61OZ6cjf1JxamJBws1VpigT6gyq6QLiC4z/Ri3Ed0pPaWhT0oB1qru7xVECjLdo+zfSnxVTS0orPHykCXVe8hEtyxZA/889DSsDO5xMl0yErl32dN46YVAkIbxWzeFDdrdbpJBZmAMeIIXYl4SQtEhjVfLd2FvJoSgw7VG6gt5SpnZnI50hlcMh4G6nDL0FV88sqS/EuNMiPFnu8SZ5BbqQvY5xbnLmM01KvWmYqVHQ0n1YauWqD+AhAayddECy+1hTZbp1IqskV4dk+8IK0J5H8sE1NNRzuj4lSQOV1RFgUhdBZDZ/lEQxx4QnOLha+BQ42dnkZBtJYXHS2BcsJzAgtGZabG2xqXDm4enCPci0RfDkr4igFYecEZPbhv4sLWufWPEJiiTH2+Pf8VuUqNlwoxGWAt5pH3+ubuj9Pvb4GlT3HsvRqbEbBNlmhGT/SwV/TDXl6kKAa0J3yzFOGIxCYu8NVZSVLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 10:23:34AM +1300, Barry Song wrote:
> > >  /*
> > >   * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
> > >   * flush caches.
> > > @@ -658,20 +672,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> > >
> > >       WARN_ON(page_shift < PAGE_SHIFT);
> > >
> > > +     /*
> > > +      * For vmap(), users may allocate pages from high orders down to
> > > +      * order 0, while always using PAGE_SHIFT as the page_shift.
> > > +      * We first check whether the initial page is a compound page. If so,
> > > +      * there may be an opportunity to batch multiple pages together.
> > > +      */
> > >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > > -                     page_shift == PAGE_SHIFT)
> > > +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
> > >               return vmap_small_pages_range_noflush(addr, end, prot, pages);
> > Hm.. If first few pages are order-0 and the rest are compound
> > then we do nothing.
> 
> Now the dma-buf is allocated in descending order. If page0
> is not huge, page1 will not be either. However, I agree that
> we may extend support for this case.
> 
> >
> > >
> > > -     for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > > +     for (i = 0; i < nr; ) {
> > > +             unsigned int shift = page_shift;
> > >               int err;
> > >
> > > -             err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> > > +             /*
> > > +              * For vmap() cases, page_shift is always PAGE_SHIFT, even
> > > +              * if the pages are physically contiguous, they may still
> > > +              * be mapped in a batch.
> > > +              */
> > > +             if (page_shift == PAGE_SHIFT)
> > > +                     shift += get_vmap_batch_order(pages, nr - i, i);
> > > +             err = vmap_range_noflush(addr, addr + (1UL << shift),
> > >                                       page_to_phys(pages[i]), prot,
> > > -                                     page_shift);
> > > +                                     shift);
> > >               if (err)
> > >                       return err;
> > >
> > > -             addr += 1UL << page_shift;
> > > +             addr += 1UL  << shift;
> > > +             i += 1U << shift;
> > >       }
> > >
> > >       return 0;
> > >
> > > Does this look clearer?
> > >
I think so, at least the place:

<snip>
[    2.959030] Oops: Oops: 0000 [#66] SMP NOPTI
[    2.960004] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.18.0+ #220 PREEMPT(none)
[    2.961781] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.963870] BUG: unable to handle page fault for address: ffffffff3fd68118
[    2.965383] #PF: supervisor read access in kernel mode
[    2.966532] #PF: error_code(0x0000) - not-present page
[    2.967682] BAD
<snip>

but it is broken for sure:

i += 1U << shift - "i" is an index in the page array.
For example if order-0 you jump 4096 indices ahead.

Should be: i += 1U << (shift - PAGE_SHIFT)

vmap_page_range() does flushing and it has instrumented KMSAN inside.
We should follow same semantic. Also it uses ioremap_max_page_shift as
maximum page shift policy.

--
Uladzislau Rezki

