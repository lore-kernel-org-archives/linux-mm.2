Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FDA2C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387716B00A1; Thu, 20 Aug 2026 10:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312216B00A2; Thu, 20 Aug 2026 10:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200206B00A3; Thu, 20 Aug 2026 10:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED1546B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:27:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 881BD120184
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:27:18 +0000 (UTC)
X-FDA: 85121875356.17.CE184E0
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96A8520006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:27:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=kbH4IsA6;
	spf=pass (imf13.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.181 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787236036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WtOwLAxWd9JV0xL4eCgYozrhrxTZBTtuL9Rwu2zTYA=;
	b=ZzKRfIh+uLqr1jJrA4L8kjmAV5Y0MeWCqfYmnuzFTI6SRNNviIWCwPheuhw3IzzLU2gnY1
	WW9ko3R4Ue6Ph1ow4zGsAml6hP20C9cAmD98XHejj9N2aPVjkgMODIV+bt5U0yud49rStJ
	VrVrAaNJNTy8vPzD1mu9hut3BqPmACU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787236036;
	b=rzBzxL0W2UzpiQwP/bwi07hqU9RipBCjLnQ6P6YUvgom2dsqEE1D81TZJZSukQ8AbiZUF4
	vMIPIDR/XhXaFre1YDf53juoCLsRTZbai5Wrvq931MbNxHS3OrafNJ4qpK4QD36RYhReRU
	sm+BVs2repF+oCp1tDUk0Tj9r9L2zVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=kbH4IsA6;
	spf=pass (imf13.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.181 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-930f4e5eed1so154174685a.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1787236035; x=1787840835; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6WtOwLAxWd9JV0xL4eCgYozrhrxTZBTtuL9Rwu2zTYA=;
        b=kbH4IsA6Rr5K0IuGdouZtKFW1vMny4D/ALHydJzoqk5240VTo7bXpFRmYgSl1Nd3lW
         16TI1Lwhet7UwvrXWP+cAY5W/ex09nzfh/qW1u66W/WZDNiD1CR2d4RuBrngcRzEHGHu
         z8I3P9wR+fZqT3xNOxJHGs1CfRwdKJNgbBQS9LuR7QSOsB5dfJmJPW3Rg6PKxXvzrUm6
         RZWhL9meISMkMWJCyDvEohjI2sATf/w42MGfBaxaxpWDPYiKMCz39IruWY1j2gn0O2yO
         uWOjpziD8Qb5LeqShq2P7jz/ObyhCVDmAP5YHOZAOSyVbmj4iDVggiLmYuNcXwKYQrxB
         sT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787236035; x=1787840835;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6WtOwLAxWd9JV0xL4eCgYozrhrxTZBTtuL9Rwu2zTYA=;
        b=nopND5A2nIJF/SUhdWW0oKC7XjvQ4u7zzpkAapLR5zCl9866qQwnmcwLxANVpRnJlS
         rc9X+m+y9vq+Tl8yx0dqmSCk97k8hHJudcse5rhIFnNQfFM3oVKcNttvryBI7C+KW+b9
         nB1m9TIxzDbBnXbqq5lBvRCOrPwR1/yY6qzr3tQ7u5snUJJ61EC79aBEoWtPXCCgfr8s
         9Msz867lobepjpk6pPa+7lejNpP41U4mr0Hj1NHqW3+8AS82iDERg3G213rY+OPH1Bnq
         8RjSJZTeP6oYIQV46kjdPKm1zyq/4ZN+LCNh0v6Cl40sggaEbLe7P97YavV431lsN3pH
         RtSA==
X-Forwarded-Encrypted: i=1; AHgh+RpGLpoQhuu6wiTYnbUlGrTdBcI26T534+sYPE+BKLCzxu/ZYmXGeCwve+Hx1OHQseWyA30/3cS+qg==@kvack.org
X-Gm-Message-State: AOJu0Yyq4nrDv8dr9xEGPS4z0erZTVan2KKfS3JI8e0eywIk1qyIiGUg
	C6xZEmOilcCw+qCuwromErGRXpSIcSh9B3sCbPKkS/gl3k0uXtoD0as/HHBjAjzmjQ==
X-Gm-Gg: AR+sD11+2N1K9AmM1yVTGoAD0vcKkwAdgufKYFc5xcs98vlkIyKpTadrG2FMoSB7x07
	NUDlC0+uyO3tuKut8MiizCPxObH/qJ3Elh5SkHbsnB/e3jadeDKQT9+LQJ/ulfgSI91XCz9KGWW
	yT9KScPG742mvL9SocokF3J91t5+/YjNG8Lf2MoKbYCQWsRDnavxw5NKfU66zzH2vg2kpyddQPt
	jYfk7xMuDgTBgaAWeV7TX+sk9GUhfW/rzF/g+H+Blno9UhKCE+aaqEK5Z8wlxlZRJLR7dpFpfRw
	f7UyGu456ZUKzCaOJRZP1vpjHwhwhQq+7bPR+AB+bw0Drjd63AL9H3mZYRDlMqiOCaATDXcCjWG
	oM+qKpILJd1QIZwcUagFw4hfrmdPM95BRJ8ywSdgk2ouZqCENC4YfSfgtcTinhTJ3Jh3IlwYfiQ
	u22s1IXwwOTJluK27he1iqsBg9txIQ3ICxZzGaW5Fzd67R9P9w2ew1G8SC0Nr607kAM3zlsEZ0d
	Ay6hCE=
X-Received: by 2002:a05:620a:458d:b0:92e:9d63:a700 with SMTP id af79cd13be357-9371e20500amr925016585a.9.1787236035215;
        Thu, 20 Aug 2026 07:27:15 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720595cddsm382561785a.41.2026.08.20.07.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 07:27:14 -0700 (PDT)
Date: Thu, 20 Aug 2026 10:27:12 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, apopple@nvidia.com,
	byungchul@sk.com, david@kernel.org, gourry@gourry.net,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <ffd191a0-17c1-4d23-a072-cdc6c9f7b4e2@rowland.harvard.edu>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com>
 <DKTTPHY9SMDO.3R1VBEGOKR95N@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DKTTPHY9SMDO.3R1VBEGOKR95N@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: 3mf5uhq4q3p5w7ywurep81nuqrkxkbwp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96A8520006
X-HE-Tag: 1787236036-296065
X-HE-Meta: U2FsdGVkX18ARdVO9jJEkvlxYIttQagJdmxg5sKBuHKwuncsL8ZGM1zHQrzCdU8CiBCP84FlI/NZ6nuJNdvv31cX+cOSi5PDZn+FsYOytanClBtsEr5flFRcrQrC8kGnR4dRTAdvFxea+JFgWFxdbjpmpHgXqaVLAHA9cH0TQolh2hvVH4GTibU22CFXt0R12UHNX2pTt/UIXI3HODKgj+z7rDrM4ID9CDrTA58a8XD19VkZIgvFE7pH7F9ZNLdnGdgdKBqS+eFWV4NoASPWd50j50niGAE2dRbwBuVIbtMZ5bNQv2hpeQW2pfdFa3qi8oIqgNQkwXIFCig239pXQDQSVbnzyEuWNIgeaG7WY+OQEbWOSuWRyUAj1DcRLF59IAsRJG+NJeYTFB+q6pYdqtoeaUmVEk3rY2CfjGqBlglaade+r65l1VsVrWPoXRO2qrgPjNTm1AEo3jH4/dH66eyhIP9zXbb+QMq79Hfu6S2Kb3ENzWLRg/a7NHGklf+SOU0/7YtnIQyZxCAo5PBnWsm6xtP/KIwFdGGq76I3o/Y/B4nq3/ongiDauDAhyAZ0FYlhSu1aOZpU6ikrZeyYkVbEMbgMfQGxDxo90m2DgWWq1LqGmE8XkRlBoKKlLayTCmxf0b0ZC6+Lrz21TuyELpFx7y2hdkwon/NRL6LA5u/Zxpco+p9+DLjonYj88yB1ok74KHJvvuo6PSP2nK7RMSuEi9XYcBdo2k6Wyq1oj3pP2cQlciiwWLAHRtDLFu8e4JexgE039Q1r/C8KNiROMaCfsNZHEYileUsu7c5U8N5MogG0TqtATH99kxxJpfxuJqEgxwV2fwSfsBunpGl4QEGfxL9c6G33zb/dMEcyOfsU+SCkvaULvoKiwAX2PjNXCyGoStfp8N0E7UslgxGKjGiqQzp3jPkWKZ0ibmCJ/SkGm3wqqFAxUIcQn8QopW/ModRd1Bq/M9k5CvVQ8D5
 FU4EenBi
 vaV17VxBYy7B+gPTuj/JpaimYcTMwljKPCEO/ljNZ6Rdmag0goUp54lUYvx71HDbkJWERHZmYnwRUTqinr0hpMSKOHnBLf2YH4DwGqs23fTjrgGnmfGFYsOTxTRaW+NpSajkr+L1MmYmZX1VfsgivKPmSmL1QFLyR7PERrjyKgNYORfWXJwI0Wa9niiwC9qhkVFv7m10aZpw8EAD6N8fDv3xAJULmxwvWLdo2TtD6UabVfmcsc3epW32GWmVdJqoCcJnVB8Uep+1cpBnYbpcRhlHTTHX0E02kQEOIBBKgcv4HuHHSsr67GFZPYJZmASPxKlBizOTO6kQ6+CJYaatxhmgHPqljuZgOFSgARd+UPxxkVBsVc3BcvzvkxXEyfZwYNLHj8Dnlo68e+OXTZde9QaWUv433kfxirV+pu8woGF0403gBUjADuNRHxMy2izz16ZeZNwp1TMPeiRf9+fczMHcpsR8Mw4CzdiDqh9w2pxpn6A0ySsYrT8S6QuPVfRiqH0Lf5yeRG3ZOW9PqXgiqWgHFTzi7l6X2Lnk2FIU9XtENXeUIb40SArzeOkgyhjeQLYcydH5c78TjfEJowOWvJmqvNkr9e6oI0o9m01XsQe2CZtMrwwQvEiimlll8TVjB1Ln2Y7xZkvJBDv7tYN6glcDAoX8oXjMFOx87dXvAK+SjtYRoXvM78tJVxvAQ7w9STbUNq0FDfww/vWjabfCn5nFID+HThSzlrSFjli9sT7girIdp8oS+nFzk7ST3E9+iKSdn1WbvGZCLwHp2gppzURWhaEugDmtORKioHFLMn9Vxj6OvA+H11vpL8EfOsXs9bid4UncaJQ8KrOaVTg8bXxy4ze3u0Dkyz0SUkU4v0d8t3dspORapSKa7EMZH+GLz5pL2p7gjFmdKwaah+2i4JZIbRLPXpX1QwhzTS3bczZalZEkX7nf4Z5SbWakS0uJJdIRG57aZ2B7gKzg4+S942pUSlxn2
 Y2Lr7dgl
 hh3gXBNIukpD+xWA+g50bk15dlWYAtXI3hfqhqd8N6na9I3WJn0WdSTPLC6y9YetFMr513k/t4DL+i+VwjDH6Y+Ub6PYv5sxtFkGvcAR/sYsVrhEFu+plIfaVO9zWux3HiKOwK44GX5Cwk04zA9pwK0H0elsoa35lwdEsf8nJrjhLRd9OUIWoI/7a/N1t6FX2Byg48h3539mgD0+sR1uqt9w+jgRYlgsdnHsfbb67kqc32mVi/ZNTMrWz2I4pFYKjh/vJfYPlY5qENHV1uz9nWO0JrXx0qI77XrcOk5DtjrbVZZowwC9YlyeGozE9nOAYTD+bKcLVKU9XvFm8RZGwCCsLPa2VL/R9H2rLkiFjV4pOrFBvE+Poe9pgaD96MuUOR24Yok/I+vtX720ufl9bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 09:59:27AM -0400, Zi Yan wrote:
> +Vlastimil
> 
> On Thu Aug 20, 2026 at 9:55 AM EDT, Zi Yan wrote:
> > On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
> >> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:
> >>
> >>> Hello,
> >>> 
> >>> syzbot found the following issue on:
> >>> 
> >>> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
> >>> git tree:       upstream
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
> >>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >>> 
> >>> Unfortunately, I don't have any reproducer for this issue yet.
> >>> 
> >>> Downloadable assets:
> >>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
> >>> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
> >>> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
> >>> 
> >>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> >>> 
> >>> gadgetfs: bound to dummy_udc driver
> >>> ------------[ cut here ]------------
> >>> 1
> >>> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
> >>
> >> Thanks.  drivers/usb/gadget is the offender.
> >>
> >> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> >> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
> >>
> >> I expect an easy fix would be
> >>
> >> --- a/drivers/usb/gadget/legacy/inode.c~a
> >> +++ a/drivers/usb/gadget/legacy/inode.c
> >> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
> >>  		return -EBADMSG;
> >>  	}
> >>  
> >> -	buf = kmalloc(len, GFP_KERNEL);
> >> +	buf = kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
> >>  	if (unlikely(!buf)) {
> >>  		mutex_unlock(&epdata->lock);
> >>  		return -ENOMEM;
> >>
> >> or do what Gemini said.  Me, I'll add some cc's and run away.
> >
> > Let’s do this instead of suppressing kmalloc WARNs. Since a similar WARN[1]
> > showed up yesterday and that WARN is better handled by a bound check,
> > I do not think we want to lose the WARN from kmalloc/the page allocator.
> >
> > [1] https://lore.kernel.org/all/6a863306.ae6ddae5.3da009.0013.GAE@google.com/

Fair enough.

> > Like the patch below:
> >
> > From 732ea7074854ac3495bbceb274cdd01966118e57 Mon Sep 17 00:00:00 2001
> > From: Zi Yan <ziy@nvidia.com>
> > Date: Thu, 20 Aug 2026 09:19:12 -0400
> > Subject: [PATCH] USB: gadgetfs: do not WARN about excessively large memory
> >  allocations
> >
> > GadgetFS passes an excessively large user input len to kmalloc and kmalloc
> > gives a WARN (see below for details). Suppress it by passing __GFP_NOWARN
> > to kmalloc used by both ep_write_iter() and ep_read_iter(). Follow the same
> > method as commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively
> > large memory allocations").
> >
> > kmalloc is used to allocate physically contiguous memory for kernel
> > allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
> > the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
> > sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> > because kmalloc allocates an order greater than MAX_PAGE_ORDER.
> >
> > Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fast path")
> > Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
> > Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/usb/gadget/legacy/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
> > index d87a8ab515107..278a0a2b39f4c 100644
> > --- a/drivers/usb/gadget/legacy/inode.c
> > +++ b/drivers/usb/gadget/legacy/inode.c
> > @@ -604,7 +604,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >  		return -EBADMSG;
> >  	}
> >  
> > -	buf = kmalloc(len, GFP_KERNEL);
> > +	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
> >  	if (unlikely(!buf)) {
> >  		mutex_unlock(&epdata->lock);
> >  		return -ENOMEM;
> > @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  		return -EBADMSG;
> >  	}
> >  
> > -	buf = kmalloc(len, GFP_KERNEL);
> > +	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
> >  	if (unlikely(!buf)) {
> >  		mutex_unlock(&epdata->lock);
> >  		return -ENOMEM;

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

