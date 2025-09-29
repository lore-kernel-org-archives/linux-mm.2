Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A42CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3746E8E001D; Mon, 29 Sep 2025 11:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B4E8E0002; Mon, 29 Sep 2025 11:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261588E001D; Mon, 29 Sep 2025 11:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12DAD8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:16:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF909119B08
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:16:01 +0000 (UTC)
X-FDA: 83942638122.10.E8CDA39
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18F0E14000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:15:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wB+x4U9v;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759158960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pkhN2ukYJYto1i2+aNs4By9tc5QGN3dIe+1Mwb8VZY=;
	b=dbO+aTxASe22yiOEkrvYs+ZkIz1IzgmkcmCfZ7rMm/VytXEcqvttxlXc1tJ/b7LAGoxC2D
	U5A4QXqEoNE5Acc5XWXLECzvCTiNQHNhWz72gJaXfhnaR6E4gTHaoOBckYEi/V0p5hNPyS
	ZEaB52xYM4IadPts59IiOj+RkqshWxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759158960; a=rsa-sha256;
	cv=none;
	b=LrGWGxPMUmY8wujles8jsVZog93ogSPLb3PDxMG9Puc6vZs3E0Yy5yAxBpjsIZlW8Vt9L6
	pMIl7+pmOcinFH6zcTG+GiOB14U1IteWWvwHanHA1+VKADdUataQcMuQCxRlRU8U0dRS6J
	ApCoHUZIyPXh+06jTnXynBNTCwkXOn8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wB+x4U9v;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e3f213b59so135895e9.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759158958; x=1759763758; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pkhN2ukYJYto1i2+aNs4By9tc5QGN3dIe+1Mwb8VZY=;
        b=wB+x4U9v+p9ia+QiJIR24PGpPSwCJH+intrb1OCMRTqts6kF/ooYvLbvMvQYTVZS1K
         2zPds7zNBK3HTb913W3YFDooGSXHQv/gFwe8APR4SLIgD1aDgDkZcgd/3oUxRuAzKghd
         XFraaift9COqDOXmfnGe3cbbZ8EWCbB3p+QLx2dIFinjWd5B3j84HHnjHKfKHuyBqcaT
         XQsitI6+s7hybLrZV9tbnsnj60BFCboL5Hn3v+mc2XNvsFtqFw3XL1MyQDGTUIcJl8DG
         grf/lS1/cGDTvoGcBIEujqVgJXYGAh2G1K1CyzdM3QYlYp/ZYFUOVo4H2E0wkbE1KLoq
         r3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759158958; x=1759763758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pkhN2ukYJYto1i2+aNs4By9tc5QGN3dIe+1Mwb8VZY=;
        b=vk+mK+jqOd1sDgFep8snBM8eUpySZbSOfb4o2LzeVpuoYsgHm4X3k53seIVtjshohc
         mgCb5gOSpZAS8xElINwy6Nj2GsDuuJlonOPJLkkI6zyMbQJiYcxeNDL11tYUs+3toRvJ
         T4HQkHkpkfIG2ABNe1ffWERD0jpFWY1vJtg993/g1gY2R6lKxAkcF1gno/CCBc4+OotN
         ZMakBX2nnF15Ge+dNiYIMRzhYVe51Hq6TEJbQfGwjTxOobYLkWCw+lVrI1Xaw8Mqi2bh
         TA57W4RJxeYE8C2P0PPrzcBJD7/0evw8lknmFZ8APNpbCmx9YuaGG+051KwFmIEYP6AB
         Nt2w==
X-Forwarded-Encrypted: i=1; AJvYcCXZJ9irBOZHmWgFPGtTp9ZZ5heLMW1itI8XexojmreiSuQYaz/edvCOL+t3QN4pV8Wbckh9YrKWJg==@kvack.org
X-Gm-Message-State: AOJu0YxpHdzf/XFVL7o1PNnuQL5QkGibfAYPPqLOGT9KRCl9wmYq487Z
	yzQGib9uVQb0TxFWD3HwT5E4rrPuhjs1nCj+JgC/KBZRP+VFriLnIhiZPd/uYRI3Mvx/+PDeEql
	fscRnl8+Bmu30wB8kJA0rJLh+1HP4PLzTGSRceZPU
X-Gm-Gg: ASbGncsHAoj3cSMDG5YdgDMrVDW7j0r74v6bUN9V3Ye86UJhYXaHCWOrpKBe4T4XvWF
	z5oFh/dA+7fUR1FBWm8RyR3tfuRV8z9gXsf0p2qONqmTfWGKYi5J4/fWgOrPi9RKjhhzDaM0d25
	gsTi8Rsx2JZZ0DnQv3EujOmpiTSHuzYShXo27p+P72n0cfv7VbI1kM3X3htJ229AmxaDywIIXMq
	KbJYIVwXRjEQE4gVxejg9C8H9T1YnkgOH+/gdWCWy2RLA6cPyOuuvmW2w==
X-Google-Smtp-Source: AGHT+IGoVtKn/z+fvBHETKBwCTIhHjfyaWPkAklb+f6MmLruI8Ybm05I9etHLrGBfigctLEhHMHLShZjSxTcGUhWdbc=
X-Received: by 2002:a05:600c:4849:b0:45f:2e6d:c9ee with SMTP id
 5b1f17b1804b1-46e56713c8emr799655e9.6.1759158958285; Mon, 29 Sep 2025
 08:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
 <5f117b73-8d7b-b233-a0a8-2a29ea6312a8@huawei.com> <SA1PR11MB71306ECC0662B9A952EA3534891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB71306ECC0662B9A952EA3534891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 29 Sep 2025 08:15:46 -0700
X-Gm-Features: AS18NWBdlALjklZrPik0xP6HICNNusJc_VQT87GL7dSv5ULvD7SM592G5TPsAWM
Message-ID: <CACw3F52QNe-JsnK1iu8s21LXGC9heZy0zsGvE3kaRz32HmqjNw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	"david@redhat.com" <david@redhat.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "Luck, Tony" <tony.luck@intel.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"Chen, Farrah" <farrah.chen@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Andrew Zaborowski <andrew.zaborowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18F0E14000A
X-Stat-Signature: czjt5csm3doy3e664f89ts46iuo9ck3i
X-Rspam-User: 
X-HE-Tag: 1759158959-353325
X-HE-Meta: U2FsdGVkX1/qxOFcCMv+BsOr3x/Qm0PQhKJEwVZHpUPnkQOTE+fW4IgMwayoJLoWkwT8dMJEPQnztsUHV3BIFfbri7pK3K1hD4DFFJPIcOd0JhK2qp2p2yQWwY7HZXb1+3Vu3ezP9RRmU31cdDWvzA2v7WeAZXdCNSrV686sIu9bzmIjMN+JTjJTkuoSJNQjZF10yEUgoH9wn4KaPTSlwaHjenrMisVEX6/SrnmO+V5Vd3KVS/3EmiYPMNO06V6jq112w5Jc4pfSWMHAexEBfmZlGaJeA4OQC/oC52q/VlcgmbSDalViF5kTqVq92rSX9rELt+6WeAA78TQuM3zAi2To6NjT5WOhIkHS5cqoJ8gecciEOVS7PR2lcKqD1vaPVu/BeYcMQagdwafkgnBqmg9vGsOl7Y4//yFcC5Vow9j739B4+nOCXvXQCFsS/EfCytmV4M7wPcvxYUYyAAvOyBt5nQ35W0yjNyL+cgCjVurHUJBKr/+iCHpgl6L0G77kNtrXoJ5N5HOpl1pleqwmX2XIVb7LHm2/7arwwIzEZ99Gd+lPuqmIwsq08XPmHM1GmzO2uBjgjFiLYdpEFld+sacTse6Q5/DbN/ddTYlEt4Ul7AyIX3ldDA+vzlWzU9Tax8Br0iAKHzbmRtbWNurpjWKnAha3dZ66dafBLblA7w8vKZHHPUcGlTcW+7ecHtXqfswPtH1hNRjwupAQKrALkJ9Zp9ahARE8cz2yJS1j/Ym9P2ci8zd5eCVbnSAaBNTT0UIf725P45y2noHI8tE7MZzYoIXQZO+xvR1b6fNiJPCxG4pswLPlO3u8+MhiMlSMAbM6PC1dco6Xv07spvdK3g3q3xofTy0vvYmJCLYEvSWYBzUdCSCmbCPWlN2icqLwbL+pdVwGeCPEcA9zvWbQeI8QMNOCdmurPO1AI93gp3Kv/MKhuXTZa9DeT4m71GwGWC6UGnWq5kwTDlh8Koi
 no6XUWE+
 +BUSBk3dFgRucM+b/b0FQzIgz8Q29xAE8YWdbQp/6qK6NmPMKL1ReKcpP0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 6:57=E2=80=AFAM Zhuo, Qiuxu <qiuxu.zhuo@intel.com> =
wrote:
>
> Hi Miaohe,
>
> > From: Miaohe Lin <linmiaohe@huawei.com>
> > [...]
> > >>   First Machine Check occurs // [1]
> > >>     memory_failure()         // [2]
> > >>       try_to_split_thp_page()
> > >>         split_huge_page()
> > >>           split_huge_page_to_list_to_order()
> > >>             __folio_split()  // [3]
> > >>               remap_page()
> > >>                 remove_migration_ptes()
> > >>                   remove_migration_pte()
> > >>                     try_to_map_unused_to_zeropage()
> > >
> > > Just an observation: Unfortunately THP only has PageHasHWPoisoned and
> > > don't know the exact HWPoisoned page. Otherwise, we may still use
> > > zeropage for these not HWPoisoned.
> >
> > IIUC, the raw error page will have HWPoisoned flag set while the THP ha=
s
> > PageHasHWPoisoned set. So I think we could use zeropage for healthy sub=
-
> > pages.

Oh, sorry, somehow I forgot this so I thought there is no better place
to do the HWPoison check than in __folio_split. Yeah, since we know
the exact raw error page, checking in try_to_map_unused_to_zeropage
like David suggested is much better!

>
> Good point.
>
> David's suggested diff in another e-mail checked the raw error page inste=
ad of
> entire folio. And I tested that diff and it worked well.
>
> -Qiuxu

