Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D92D46624
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472296B00E1; Thu, 15 Jan 2026 16:11:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FE16B00E3; Thu, 15 Jan 2026 16:11:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322016B00E5; Thu, 15 Jan 2026 16:11:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 236E26B00E1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:11:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C40DE1BBE8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:11:23 +0000 (UTC)
X-FDA: 84335444046.12.57F80C7
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id E9F37100006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:11:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkinOLso;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBUMRSearfqlg3Cc70zgYWNZYbsBrCb0aDCW/HMIjHY=;
	b=QB62J8QH0FVd/D5OcRGWNVDrYjMfTLIS86zBkddxjyXK/ALtfEdddEEfwtx8pN6mFufLn1
	lH8mb3xcedi3AqVxsOT46cGY3ZvDoxSMHyJJPvd4RPAoEM9J4xP+fyKzRS0YNqCdgFB1by
	CVR2pjVZNHy4q1NZgpfCvWOrCS/4lMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768511482; a=rsa-sha256;
	cv=none;
	b=uKRYQQbQfcMqXEvYpkFfit9N9TQpsiJ2EBGpY/XTaAw6VJA2qEXAYfQz1VIoAVTfb+yIuN
	k0NoM2GMiDCymfpozyVwvZmpBFtwWZj4o7C1dmAe6c5hDwVTtNDZeZKMc6P2yGJ5opjZzM
	8ok3XHzKk2naKE+Pj3C36zlU3MURPYo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkinOLso;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6481bd173c0so1271707d50.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768511481; x=1769116281; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBUMRSearfqlg3Cc70zgYWNZYbsBrCb0aDCW/HMIjHY=;
        b=jkinOLsoklo0Am5ToPJuUeH/33AIwsN5kawDT7L04BfXuSJMjyRITCllLyrE1z/Cng
         viLdlO4O/bkGsBruxEYp2ybsj6pBuRgi06GswgGYbfmgSs+n299WqBbobk1URRrjewR+
         u6D3T4XxOltDPVykzjhZEH0x1IZbwtvkEZixUcV37FLjCGZA4QDHoefeAna0C2agiKt2
         C6cVhk3zZ0fBIVA9DuAdKsiMsL7Dd02+d71kVw+wOqX8KLzCoLCOpIR0TqQpr4SzJpX1
         kzKklqEb09OEzf4oe46Xa+Kx5v8DeL6nDUiMzKHI+THbFiXnzb+6IgSiuXNjZxGLA2fD
         a1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511481; x=1769116281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rBUMRSearfqlg3Cc70zgYWNZYbsBrCb0aDCW/HMIjHY=;
        b=T2L01YdtSYqZme+61Lq9mmTHkwkJ6l1BDxzKMCjJahtTyFg3f3NxZxGGxNTCCF4U/9
         IfDbn9D4QlJtWWRdWTR/SVDOwp6geLdiFpZLW+rIXGmEq/EbkcX7S4T6WaYy5Tma7Qjv
         X/z27D+Dp/7wau0FO7u1syWtw5NZwxgeItINEF2848rxMr6utWXIgIVnelmj2QlmpSpJ
         nq/c8pLqGYcMZlGhrGQ51tO3Tw8kcE73rAzK20TQ6gk2j8mweMu6r1YUx7uTC5pffQeL
         bcB02F9vZin9pTqU+wgBMiZt9DKXG9AkJE7gzq4PM6qLYsf32cD3WhwJkGyCXjnZJVjK
         zgoA==
X-Forwarded-Encrypted: i=1; AJvYcCXUgS80Nq7jCb68arO+TMMs/YYzhg158ZzQB/nGk82t1GGuP7moHn/xKErg4Ps+oARwopDxLK1Rfw==@kvack.org
X-Gm-Message-State: AOJu0YwpbbBLUyFSDY1XpCu8eB1WWSyiXaMx/mUaMsrPigT+BdSmFLYn
	CCFVv9hgY/jZUgfbaIpViXaXO3coxEDfjOq9c3uSFT6Z5R57LvefJ2KV
X-Gm-Gg: AY/fxX6AZLEJDnyoR3fOw7aSYdHBdVbh95RNqy0SPZ3mKksOWVTAspsepWQiVeQwjHN
	cXq0rSUwzOMPZMrHBcJ8k5qLhN1egBYycSF+Kr4zkjEYePh0FsUBoChCx/dCk/O82tIhkkr77xI
	oaoVcmWmJmmY0CdCaOYwfbFt1cYi7SijFlWed7teRvjndJjNLrUGCo+lMj6LhbrbAJrIWdp+6Ks
	P4gIGZHbfckuOhht9nkbutBeQfUWnRHBjzW85f9hAfJX/pWXlviKJ8+hfAeYFFppKiGLnmWLFI2
	Cg0HxuXB2t7GnWsJZ37Rf6MtJCzYFpzn2IHkGz8U0Sg2c3GelIad5hY5mdE9ep+4M2HeeHQtOeh
	wlNBdoY7IwqSJkOoghNcAxY2MubG9y47xTLBliNkxUydBMCAiTDK9QqQtsZoPs7es5GrraG/E3c
	QgwHHT2SBaWA==
X-Received: by 2002:a05:690e:14c1:b0:644:6af1:1922 with SMTP id 956f58d0204a3-64917750ad0mr392799d50.53.1768511480901;
        Thu, 15 Jan 2026 13:11:20 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68bec97sm1712297b3.50.2026.01.15.13.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 13:11:20 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
Date: Thu, 15 Jan 2026 16:10:51 -0500
Message-ID: <20260115211053.1406264-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a63c7a84-99d9-40c6-93cc-6c6fd46c4333@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9F37100006
X-Rspam-User: 
X-Stat-Signature: 3ufm7pogmkhi7wc49xaad4ac44hix71e
X-HE-Tag: 1768511481-105668
X-HE-Meta: U2FsdGVkX18qKqwa32gscTzeXniS0PItVk7j4E7qI+3VRUL81KPZZcZYw0K11ThOxqDqchx3hBt2pgzYd6Qq2x1HlJlVgbiOOd5wjCIv2aSHM+tbn/xSO+vsgy45V/VD0C60VilXtj8U6M5qH1j3KuhQBwSxmFdnTevTtlq30wOyoNDcxurn/N2Oe6F0PX/Pnt74Y73mNswoH/MpQk9OpQcSgI7XHVvDo1266SosGEljJKpPJ9dnUGkjr3v0Z6AgLLHvfKhbySJo11pogQPUqh+2bdvCEv7vYMiQT5LiZsboTVh4o3Z8aCUFDB+F2KZQ1T9Nxwx2pWNKmuIq8SJteQG95cDCsIad6YXwjD3TWMyO7rJpqPwEVkA+Ym+wnnwijiM8tUMrniCdHVsk4v/HtvmWfhoZaN6kq0L4duFvwnXzREbDhcBlXNsDsPHbq7mphsQkAa9WAFNN0NB/QJeZEAXYVSBbc4o8pE7b4gE5yYU464y9FlawI1JhFMna8qOJMSW4DSQqjY+2lVGERpoka1FgmZEMMc9B/UDNtPZCK/6xEtgQyWumMCtlFKZKNkoV+zgx6rPXqc4O+RHjJxfuGgu+THoS9qqYFFWS4IPr5FZ9E+5oo1ZurdjmmwTfyoNhOrK+PQAaa537fVFWtAP5goCjGWuXCEZq8h0EypODKEfZg0gWoU6+vL8kZDuMkZnHyQ++PUsXhSVh4LEJ5/hUTenxWBuzFjAi+eNoPQvcP9OEqP95ZuFx16ht4+LcdAwApltiTf45c/adZMcjwhhSLv95Mglr1OgRmLPsvyKcp+DQQPxhuRfoD3fZZTiqUR4ZnIPYP6HzkYpt3HiCT6mY8FoF9dF4BC73KdpgElQKRP4NhwUYHPAAL4v//vPJ7px5CLi434nmC1ldchze+2yuFXESuFtxyDmcU5PdaTOJSl08HHgnnEFWiwyFtOZ8s3V5upVzuuG8mTpj0Pyjp4m
 bWuPAv0x
 EXnm8FnU4BgKg46s+mFGEzngmXoVhI0MuCd0JrY3XC/HQEUrVL7Absz5K67OUgyPdyRu3IDUDyixHXvQdwQOZ1L/9xvfS+REPM7gOs7oBUDLSIxsAy/NDpKQBO5iSzdfG/0MXXsQnjjShKl4w+rtLbsWfpERgWyXIELnLZAS/h6Fr/kZ9erw2t44JC9cmDBbUham8hIE+2G608ZbzlAzS3nacyGQYaVluSGFwBFewR36y3XIciiCVYVrQQLl3Z8nffGaakz5HD8XqZEqAEPXaPUEcDgSzodcZfSlKaqiScCexL0QxlD6pvSb5ivzbrOdzh3ai5/wuDbR7bv4Pqn3I4GNodEf8tDV1jSEHioeDco7CLQ+2FZWYbC3BD83G8hB8bi2rY9weAaDIaX8wDcxIz9PHNb0LQmBdWNr/3lEdlOfFdxIn+zYViYaCYOmvRpCTMlF51anKu0A9ngFbPnfrNr6ILzyLzRbtStjLrCzL8CegxxYxpd5dLqKDj6XOqMpG/AfdaRK54H3haOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 21:14:15 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 1/15/26 19:14, Joshua Hahn wrote:
> > if (map_chg) is always true, since it is nested in another if statement
> > which checks for it already. Remove the check and un-indent for readability.
> > 
> > if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
> > 	...
> > 
> > 	if (map_chg) {
> > 		...
> > 	}
> > }
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >   mm/hugetlb.c | 12 +++++-------
> >   1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 88b9e997c9da..432a5054ca1d 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -3019,13 +3019,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
> >   
> >   			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
> >   			hugetlb_acct_memory(h, -rsv_adjust);
> > -			if (map_chg) {
> > -				spin_lock_irq(&hugetlb_lock);
> > -				hugetlb_cgroup_uncharge_folio_rsvd(
> > -				    hstate_index(h), pages_per_huge_page(h),
> > -				    folio);
> > -				spin_unlock_irq(&hugetlb_lock);
> > -			}
> > +			spin_lock_irq(&hugetlb_lock);
> > +			hugetlb_cgroup_uncharge_folio_rsvd(
> > +			    hstate_index(h), pages_per_huge_page(h),
> > +			    folio);
> > +			spin_unlock_irq(&hugetlb_lock);
> >   		}
> >   	}
> >   
> 
> MAP_CHG_NEEDED = 1
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thank you David, I agree it's helpful to include MAP_CHG_NEEDED != 0.
Will add in the v2! Have a great day : -)

Joshua

