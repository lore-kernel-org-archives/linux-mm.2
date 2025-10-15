Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FC24CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 01:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9F08E0143; Tue, 14 Oct 2025 21:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB308E0005; Tue, 14 Oct 2025 21:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9998E8E0143; Tue, 14 Oct 2025 21:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86ABA8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:12:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14458889F9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:12:24 +0000 (UTC)
X-FDA: 83998573008.20.F066D8E
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 21C6D140011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:12:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SdfsHcPH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760490742; a=rsa-sha256;
	cv=none;
	b=L4HUQll3PqLzTryHRQVWmG2DbrywTZRUT+JLpo4YE7BVTcW6jn/ivCo5T2bKca+qijzpKU
	vgUly2FclPPuQJ3NIFiBp4KjR/m4W4sO9d7WpRAYWHe8E7QNsipTighl4xMV1Q7wmLLiPQ
	tWzBn782NYPzXTqc4E85iOiOZJaRkCk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SdfsHcPH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760490742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRM97CWlsOT8ZJdTMoTW/+GjecPCqzJ3uGuQi6pJdPs=;
	b=nE85w8zsl/3pExGCwA+XGj2MCUbl+fdZEYxMcTNCAt5MoZaKDI6NQ31CgZNLVpBtiKAGXN
	QhVBkQMN1Xwi8ZRUBFj8bwr5uKQfpX+aZ3eNLTHYFi5Ol7GF/pNWXMP1sROG7NN/SmCoOl
	FPc9zY3f2WsIu66rflGyA4vS71ibFv0=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-57e7aae5af9so1012989e87.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760490740; x=1761095540; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRM97CWlsOT8ZJdTMoTW/+GjecPCqzJ3uGuQi6pJdPs=;
        b=SdfsHcPH8qOqJQSdIpOPQUXQuGP/mGI8GWFLEOZdfKZFaa65doUnXZFQkp6h/hILZH
         JIPAUoTmS4hLYGI2RVVW2qhZmMV09ytvkLCVaiRg1ujtuiUVnuIapRGt/EWkw0Oc58Jb
         Oj6U2AtmKxXhIeMh15MC5/Ssi006h2rjbFvcn84fmwOJO6K47Dbcdatemle623Aqqe90
         Of3OY4gMNuJKgDNaW8AfVedAZ/VOou73et54KuOgkAGQKbThVxlnIUpdF5E1ilujqpf6
         OJpyOvjW3Gjn5PCxkcZX/FCfmQIFsx4OWBA9bKB1n7q9UqKAA/rczbdm1EWCf0otN+dd
         Bhrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760490740; x=1761095540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VRM97CWlsOT8ZJdTMoTW/+GjecPCqzJ3uGuQi6pJdPs=;
        b=K6UQBrpnMz9u2ilAxaLTOpZvQ37fsityR6AbQFiL0NetYlRy4UFkoj5FPiTieABQ1m
         5rJxG7CIxYY1KUsXkLvIbUUYt87tssDzZ9K8wXRdv/sG2lUnW8ULWRFEFb3723fcULdA
         3KtWVwyORMY3mPvPXnu0r6NzwIjPyupO7B6qvudKaFMzc/6nMc0wctdRsQHIJcdsS/Yv
         iw7opSyCqiZgowd1QKiks48loUrIBruUKEdbQ/z9mZKgTYFTcXE/xM+2oUMQnS9dAGLy
         /6k8Hi61hNWcFNPKRJmvC1t/WaZu5lFyq5Ru5iKC3geIgJooSps/CN/LMiyW2A5j20Re
         CKKg==
X-Forwarded-Encrypted: i=1; AJvYcCX6cDE57foQ7ywb+8Mu4vxgog2UIrTH73F//9nPhGl54APS0OIXEmjo+g1jBU7hzN4v9w4s9Rwoqg==@kvack.org
X-Gm-Message-State: AOJu0YyPnNIypOCfssm048K4v8sDaOMbTkX8mdaNSivbkN2rdWVpMwBs
	baE3nv0y+T+98RniFrEqCeFV2zcaH0kiK+ASWlhaiJ90OrMtcnJNX8X/iWf/9RpzRdeNFu6mBjX
	V6Q7IpdUa0E41EkBZJiA0l0W4e2xYYLQ=
X-Gm-Gg: ASbGncv4Oih0V37wfzYo2t4jxyg4+of+u4hlo0jCQ2YqXQ5X/nI0uovhro9KfFgnZ2K
	vUhx+wI2SQvPyDzEpnsKfSZBRYh75X4AW616ok37vdgad43dNo94zlEA3trLR2rNsrHXoKJ0scm
	xsYhMDZCmzYEbT8PqiUPpzEFntx9CCiOw0Hsdr583TWrVnM9if8gIzC8GgEtqqkm3k9kQoW1uLr
	3iQTVRAvz7cI6rTY49HIvM0k3NkyAkg3CH27A==
X-Google-Smtp-Source: AGHT+IH/YU1kpB0Wn/4zP9l5pqChZfQXv1sm3d4LmsjcWXKZ0Ktc3UNXw8IIJzlfWpkxIJ+KKbvjrd6UrdDNej2f8Fk=
X-Received: by 2002:a05:6512:23e9:b0:586:15ea:53c8 with SMTP id
 2adb3069b0e04-591c8faf0b0mr151534e87.2.1760490739902; Tue, 14 Oct 2025
 18:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-3-zhaoyang.huang@unisoc.com> <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
 <CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
 <ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com> <20251014171003.57bbfd63@mordecai.tesarici.cz>
 <97da9924-9489-4d30-a858-8ee5c87bc031@amd.com>
In-Reply-To: <97da9924-9489-4d30-a858-8ee5c87bc031@amd.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Wed, 15 Oct 2025 09:12:07 +0800
X-Gm-Features: AS18NWDwKUa99eX_upbZCKKbzQIUyuG-r_RZ364dCpA2z_s2W1WiiM3YMGbpa3o
Message-ID: <CAGWkznGnmb=8GgcrfDvY2REHdRZYVXZy=F3thXhK0FaSoiK7tw@mail.gmail.com>
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>
Cc: Petr Tesarik <ptesarik@suse.com>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Mel Gorman <mgorman@techsingularity.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3xwkkyfwauhr3zow557qon9ir4c3pmkr
X-Rspamd-Queue-Id: 21C6D140011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760490741-721223
X-HE-Meta: U2FsdGVkX1/19eiexnf7f18KhEXUwSiJi97WTZCDR/M5dyEojZm+jp8XWkfIWXNgou2qyY4984jSxScjPQUQaGymoFdMEaxjI7gxrQdCA1H9LMOt2cXe2lA3oCpYf2tCUpAUGPJZQIol2nDN1PIShkogDf+vkBAmNd08FGqrSwwVGEJISZtCs3Jg0lODNcsm0mL1uk+UTEKH5AE6nvK24QZFQGK9L/cXWQXO+fjKwCpUDQ8jOVTr41OEOOUZkMjwGYyxwVSeLJGYOyNXshu+nWHxcGLUQ1Hw/Oh6Z9xBy/b1t92a5tb2iF0p7LuSeb65i9TlKWSBouwK1C0nU3+o/da1idX1XYUe6cKMAA0HohEP7NkEuqQHKbOt5rnlutuyZfh5f6TXSfIRuzSI5o8lMkizW8696NqUUIIhwaMYdh2hEBPJWlu9mdABiHVIZrEzjLh1Wmzs1XM3mAU5ll3OAvrpRSGEsWzl4+aC8Vt/knBF0CTrRyW/Rx7jd0d8Gl+o9rQ07ySNO6OeSf/ZZ7hL+Y/xlgG4ZvFVknFu6pqjUd5ycjoUf26/6v8X2ghA3ZlqgXnvqTfsDDV2Qxpr8HTIbGcyfzsAMSvpIakUUQ11OplzOopCg5s1MiqhpFXm7dVemEs0yR+OCfZ2rzi0qgZYdMWLkjjF6vIUJJVolijVaYSQmqmqIlHDlYAH34+qXLdFS1RYGIesZZEwPhox/KKp8xfW8zlAh/RmQ3Gfm/lOLbFPD06Dja2JnV/qkHNIHOJ7xxvDjfoGDs2LCDTo12mcNTDam6UDQW6XZHlrX1ZsN7gIV4SRGK8dk/8nDuYTJnw2cWlKKH+oeRyS8MkkymvEZxAJCGv72SEXAsviEDutD87otnyK0jWWzywC/ihTzHSq2YZZtw0FHurwLiIMP869snPBqVz9uh+aN1dwP60caFQdRa/G9PTkBZH/B8SC+mRCsX/1fzdWNC6uje9/fLr
 6cfYmT15
 vdehjgVPJxTEETm2QPDLo8cxOpyLyEY58qw9LRhoAK5GOfH1KTI9CUgY8veohy6lw6HXUW36PqtIevzvOdv5ya28nmFzzNMArqKND9ZaM1L/d6FulP99Ts5k38hT1Yw6Z8AZ/hT1mkZf0XnHBG8UYAK1a9VqOP/v+oRoEicDLH682bFbC5NOPyDQcQTteNDvnydYaHtwHD++M5Sq0HUba2rlEvrEuOFlDXmkzoNkzBFd1m1pL+huKAetn0I6ccUP07mDc833HMP/e+pd0VenDH3TgjNsZH8EwlIXvOONVxb/9m65ok1nVBUkqjrxX5RwBvkCryww8UJjRgIAqr7NUI6P3d2101aldNN4RG4BL7zqs1Tk3e1DaEGKO+Xqd1S5SGrmn1Mix8KqVAq6iZKW6xlpvDn/jpBQ3zg39HmC15+WS3O9Rz4WzxXH4vfrNkSEgz5OtDgWy9M2hOnC6bdwKTHGfJINE8v/9x1rp3ye8aCgGDzA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 11:52=E2=80=AFPM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 14.10.25 17:10, Petr Tesarik wrote:
> > On Tue, 14 Oct 2025 15:04:14 +0200
> > Christian K=C3=B6nig <christian.koenig@amd.com> wrote:
> >
> >> On 14.10.25 14:44, Zhaoyang Huang wrote:
> >>> On Tue, Oct 14, 2025 at 7:59=E2=80=AFPM Christian K=C3=B6nig
> >>> <christian.koenig@amd.com> wrote:
> >>>>
> >>>> On 14.10.25 10:32, zhaoyang.huang wrote:
> >>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>>>
> >>>>> The size of once dma-buf allocation could be dozens MB or much more
> >>>>> which introduce a loop of allocating several thousands of order-0 p=
ages.
> >>>>> Furthermore, the concurrent allocation could have dma-buf allocatio=
n enter
> >>>>> direct-reclaim during the loop. This commit would like to eliminate=
 the
> >>>>> above two affections by introducing alloc_pages_bulk_list in dma-bu=
f's
> >>>>> order-0 allocation. This patch is proved to be conditionally helpfu=
l
> >>>>> in 18MB allocation as decreasing the time from 24604us to 6555us an=
d no
> >>>>> harm when bulk allocation can't be done(fallback to single page
> >>>>> allocation)
> >>>>
> >>>> Well that sounds like an absolutely horrible idea.
> >>>>
> >>>> See the handling of allocating only from specific order is *exactly*=
 there to avoid the behavior of bulk allocation.
> >>>>
> >>>> What you seem to do with this patch here is to add on top of the beh=
avior to avoid allocating large chunks from the buddy the behavior to alloc=
ate large chunks from the buddy because that is faster.
> >>> emm, this patch doesn't change order-8 and order-4's allocation
> >>> behaviour but just to replace the loop of order-0 allocations into
> >>> once bulk allocation in the fallback way. What is your concern about
> >>> this?
> >>
> >> As far as I know the bulk allocation favors splitting large pages into=
 smaller ones instead of allocating smaller pages first. That's where the p=
erformance benefit comes from.
> >>
> >> But that is exactly what we try to avoid here by allocating only certa=
in order of pages.
> >
> > This is a good question, actually. Yes, bulk alloc will split large
> > pages if there are insufficient pages on the pcp free list. But islates=
t
> > dma-buf indeed trying to avoid it, or is it merely using an inefficient
> > API? And does it need the extra speed? Even if it leads to increased
> > fragmentation?
>
> DMA-buf-heaps is completly intentionally trying rather hard to avoid spli=
tting large pages. That's why you have the distinction between HIGH_ORDER_G=
FP and LOW_ORDER_GFP as well.
Could you please check the alloc_pages_bulk_noprof in the patch 1/2 of
this series. According to my understanding, it try to get the order-0
page from pcplist firstly and then fallback to normal
alloc_pages(order-0) as same as what current dma-buf do. That is to
say no extra large pages splitting introduced by this commit.
>
> Keep in mind that this is mostly used on embedded system with only small =
amounts of memory.
Actually, dma-buf is the main consumer for driver's memory allocation
in the android world(multimedia, camera, npu etc) which could use even
half of the system RAM with dozens MB for once allocation.
>
> Not entering direct reclaim and instead preferring to split large pages u=
ntil they are used up is an absolutely no-go for most use cases as far as I=
 can see.
Yes. This behaviour would NOT be changed under this commit.
>
> Could be that we need to make this behavior conditional, but somebody wou=
ld need to come up with some really good arguments to justify the complexit=
y.
ok, should we use CONFIG_DMA_BUF_BULK_ALLOCATION or a variable
controlled by sysfs interface?
>
> Regards,
> Christian.
>
> >
> > Petr T
>

