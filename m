Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BCC5C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 03:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFBA6B0005; Fri, 10 Jul 2026 23:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90BC6B0088; Fri, 10 Jul 2026 23:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D589D6B008A; Fri, 10 Jul 2026 23:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD7256B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:03:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11A661A0105
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:03:45 +0000 (UTC)
X-FDA: 84975000810.14.FF75809
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 478AB1C0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:03:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fq1i8cxz;
	spf=pass (imf21.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783739023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPqLXi2lg589wIdZoaJLi7vCawzOw1W2oonH67X+kuI=;
	b=AEprqEfM3qkEJCbHkpl5JyK1ZhKpg3qoaL14Y1+OlW/6sR/wwVeojDfSxAFCXW7ipIwOf3
	DWsUNVn5vsGxs73i06TWgA0iBT9oMEvpGkL59uuyxV02Wgtvn3/d2z7nO1MmW7jME2+rR/
	WeTi3lwslcsBDnoYy+k+6qht7hz2YE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783739023;
	b=6o7NBUYxloRrySxSeRy3Ns/1d6jnZ9bfFICEEK8Q07FXTqP/L6iA3cbT6m6BM7fdJkPx27
	55hwIGLjXqATXJjrmapRAQuXqxm53bVeBCjAg1WFM3ebpaiD1rIyH98Jf8rgg0xsjEKOQY
	oJQlzOoN+9IYKV4J4TFAbWbSQlsiqOg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fq1i8cxz;
	spf=pass (imf21.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so485216a91.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783739022; x=1784343822; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gPqLXi2lg589wIdZoaJLi7vCawzOw1W2oonH67X+kuI=;
        b=Fq1i8cxzTdeKAbg2HyK0qcTYIVd9UQ2BWERmS0baTNs/MDvGwLTxLsvMJ3iuoJO0xH
         fdEiKOzhMBX32TmQtbMSGlGCYtWPRTQn2iChXw3NPY80o4jB4xBdHU6ix2f3el6OFBA6
         60uh6mAho3QGMRXtty7ViS0ba+YpNYiQnZD0RcW0e1HS55X7htdfbdGx9OrWTMRLpzyD
         mWXSaDLr6R/tJ9E6MziQVeJCDlbyEJ5vEtXNc2+VPrTX8E9/zfydK/u0MlXXvuA0it5o
         xfdCpuxqO4ibH345rJUndgbzvXgW6HNfNyzG5pyLGvdGZ2Te/t0dX1RohWDrkFhtR//z
         tSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783739022; x=1784343822;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gPqLXi2lg589wIdZoaJLi7vCawzOw1W2oonH67X+kuI=;
        b=Qn/O/Uw/oKs/+kOUoWY+2Z3MldEwJpl2Ov3kF1NJRIyPDFoZbAwYL4tOJJQyC7Sx24
         jG67cZyf86HOB76Fj24AWVlTjMEZ7ZH8IIIU/PHej6sIWDQLKSaDnqy7MvDfzyZLrw/s
         bxQQY0uy6Tq5yRvtbguLYaMyQ96K4POWoL+ULlyrqNiqE8r3fnZ8m+W8NrwHMKuNR2bX
         nOLPBWgcy0CaYipBTDMVn7do0aMmsErgUCgfGuoJ4QbBnSul5I9fX8bFBM/Me/BVI4+7
         BLZSLIDjEXkLYEz/j/D02ZWvUh3szEuhromsb0ohsb6XisiSriXLv+9qCUg6qSB50dh0
         DDSg==
X-Forwarded-Encrypted: i=1; AHgh+RpLQ6SpJL+fPyBLrySE3WriSc7FYfU7BvVXZhiLVo3bYEPJSI5UxoXjjKf8iY6Apsom8CytM6jv2w==@kvack.org
X-Gm-Message-State: AOJu0Yxg93l3noSlltqYvGPjDXAqRDaoJFybSfCi9Q+Fn1JJbnVt9VTb
	ef+TLAt3kCdU0EaswiyZgDWF5btKLNBPGUshQHo4rF4nfnDyM/aMfMvM
X-Gm-Gg: AfdE7ckKvWQO/QwS+hlHmY6mi7ZqyJiuAYkT6rFAWsKA/PUdZ957CXufwXzQFGHRXud
	0gOex5aaucHn0trp/7oMLwJL8pjPHn+hjcaNfuuq9B+AnYkbiANpQhDWB3qx/O35Oaty7ZuqGwj
	vC4cW9hg7A5E4sKkTFjm39pGPVbuBS9+IfIv5Ub0D2/tpUTHIolyezGRN+nVVPWbIe0aFw8cm3M
	OK4kxpHHuAD8HIARzeKbSfDSbZyqlDn1xgS/F6YFSFy+JlQyXhA+Y7dRQ73NxTXWv9a4CjlfxV+
	gDDQSj7IQwZ1n1GmLhGtGaHqfsDifO4b4SxKMqF8lOiSOTGbfZfaWjsEgoFPfLMiNWZbZ9vI5dS
	9bj3Cd+cZa7pUP4+/G8pWrqMvY1idKC0jHiHELMOP/uO1zpjmVY1uKomb+73S5uMOUtWliFsESv
	UJUj5mk+JaGtu3H6uTZUk4bt7J3CGhDO++FEJAvg6M9eCpiREheNANcm7SmXUvVa+kSgMOCzWPE
	1xBiGTHvDm7mWEny3Z1Dg6grvpqNFQphBz99k1To62Hc9y9
X-Received: by 2002:a17:90b:1a8b:b0:387:e0cb:c8e1 with SMTP id 98e67ed59e1d1-38dc77c3378mr1359152a91.42.1783739021927;
        Fri, 10 Jul 2026 20:03:41 -0700 (PDT)
Received: from jupiter.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a5622ae99sm3496029a91.14.2026.07.10.20.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:03:41 -0700 (PDT)
Date: Sat, 11 Jul 2026 12:03:35 +0900
Message-ID: <m18q7i9qig.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: free unused resources when mremap shrinks the vma
In-Reply-To: <20260710174340.9f3b420629769b556f44640f@linux-foundation.org>
References: <20260710021028.892645-1-thehajime@gmail.com>
	<20260710174340.9f3b420629769b556f44640f@linux-foundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/26.3 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 478AB1C0005
X-Stat-Signature: gr63boa98qwrmdrhmueu6mtjc5eb7pka
X-HE-Tag: 1783739023-965035
X-HE-Meta: U2FsdGVkX1+pYVGFrZ5dR+b+DGJlIbjRUEHSrWlfB5IUQ/EkLbk7yNuhIvTznIhrLNo7xfeCGgtTTmOTOCH8y/ytew85E00+I/IVyww7K1Zgku+SoaCex+978rLUnh993L96Y/lJw1DuhOU1sHf/p9JnwG5h3rACfxIcCTH8ArAVy6wbfnegXODUYXNeNDtmVACkzHx1HMEdzov8CqpqjD0D1UVpyI/kuNavPin4mCs02oIkXwF7vHnp5iGCAC33Z2jOsLCKcoHLEQHYk+PqnTzIsgQ3W8WWn1fVSX7xGFQkCPKTrDPUzU/nDHWfDJAL6TMVWnvG4UAXsRbOs8lwraPPdOgb6S1pTVQ9jQWtpKOA44QBN2ClOQvu8bwcR4f0gC8cdCzovjO424x2udmp4PTAShhR+Tdc+BXWZVlRD/EFstDc0DMzQby6NAGwhyDqA1NXFGkA0Myxlbykd4LVk9ICwDw0Ps1UYSjr4T/VYuNHL22QEKTOTq6vFbzZR9bEbk+gvIJ1ITfuWobwkX7YxXeOKkzmnxzOSPFWrZAnP60rpIW9rIYUZE78TbX3pp8aMADFjXuzAp5nXV59t+VFp8cCLleFpeKehH1NPkJ6b+Nn7rcFfUjRd36LiWyrsnBpCgqc7BsON89JELdF+INBLWgF9thtnOExabwDYHh7zLBJa7U2qCKRLyvRotiUI8mwD/GjWpmFX2P2LAlcqi5A7+w6lTK+BOgCQ3N8AeRZ73xCAVvRAs9c5EIurZCoaeJHqFz7sHQzjTxSMHAN4xfKUIrrBwiBn+S8gIeZGB9QAxdIu99+eBiPv9ZRLk6/mmW49kEjAWRCfyTAyV3rIhp+L7ClMZ1kDuNEFD9X5QpUm1VUMTyysJH7E2E0H4v9CVVqVryzqU7fnI9eR7r34FFSBIpzEsTX/giJRFskcR+9UwZGapHH5sDfjk4CZi7kdcmUQpE8Fj/YU3XkQu7p/xk
 lGER2YKT
 gJzs/HglfAQGeo/Ek/c/Ys+adrkvXuZoACecl9bSf0pwa5ii7nVIPy+52DIcLw9VKXazfLPUlxtqnvCIja0LSoervSk9j2W+hZ2eoMuSJp1ZWAt7HWV+k1OzTqvuA/IZg8zHzp0m0K8vav/RyXWmM6kVoLj/qS5f/2AIZb95zKyxIeDiNViLn5BSHwmaACbnViWGttwajOwLqqp2q+ii0amokQHW/2gRj/QsB3zongYK8eQK9U+qj+YGnTICycMXAsjC/JSui4uplpwynXXMgan2XGT3HRoSuf084ISBKjQmuKR2Y9Mc+4DwUl7hVlTh+rx3nCe4qt9s1nu65DhaJX7vucoQkTa+C4bG3+I+UbnCdjvZGMYDYYJek+zuIF0CGwZC7qAy9WoBBvaKjxIRrUIUjZ2kJAdhdBzS8zED84W/hsBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, 11 Jul 2026 09:43:40 +0900,
Andrew Morton wrote:
> 
> On Fri, 10 Jul 2026 11:10:28 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:
> 
> > When shrinking a VMA via mremap, the bounds are modified directly:
> > mm/nommu.c:do_mremap() {
> >     ...
> >     vma->vm_end = vma->vm_start + new_len;
> >     ...
> > }
> > This shrink the VMA without updating its bounds in the maple tree.
> > If the maple tree (mm->mm_mt) still contains the old bounds, a user
> > process could access the freed portion. The stale maple tree would
> > incorrectly return the shrunk VMA for an address past its new vm_end.
> > 
> > This commit fixes this issue by calling vmi_shrink_vma() when shrink
> > happens.
> 
> Thanks again for helping with NOMMU.  I'd like to give you a medal, but
> you'll have to settle for an overstuffed inbox.

thanks for looking at this and sorry for the rush of patches due to my
bad (lack of local sashiko review).  I'll try to be calm and find a
local env anyway.

> Sashiko is up to its usual tricks:
> 	https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime@gmail.com

thanks, I already posted a v2 patch which addresses this issue (but
found another issue in a different location).

https://lore.kernel.org/linux-mm/20260710054648.924005-1-thehajime@gmail.com/

> I assume that ENOMEM is more likely on NOMMU, and that we should hence be
> more defensive about handling it.  Seems we have not been.

I agree.

-- Hajime


