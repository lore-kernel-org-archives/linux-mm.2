Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D196CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97ED28E00E0; Thu, 18 Sep 2025 04:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9562A8E0093; Thu, 18 Sep 2025 04:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C428E00E0; Thu, 18 Sep 2025 04:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756318E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:59:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21EC6C0812
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:59:07 +0000 (UTC)
X-FDA: 83901771534.30.5A489AA
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 433E8C0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:59:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bes1ymZB;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758185945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YBijHHPgjAyl07nG2F+4O+IZKa9So+D2+79Hhyhtjs=;
	b=bYe/J/mjSanP6869XDiNm21mwrIjNNdneAfNgS1Qsfg0oU2Z/iCfee1NMS8ZuE3dM3wKW6
	BQfxfKfsKDVjmVy//BKQXTjwV/QzXi+Tqe4SfpWlqn/toJkcJwdUDhN6OxqkCYZa7CbUzG
	0bO3L2+l8p7gdc26un+T2m2sYkLiTFU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bes1ymZB;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758185945; a=rsa-sha256;
	cv=none;
	b=005ev7joCe2r2I1b3QJw5lX3kOh+Mty+e2bDquv9SQ9qKFIAs2YKlBH6hBre972dbOY7kD
	1l051Yz9xqsaL6GZm7ITONsYDWog3K4PlG0a463MjkSlrW6u+AVomdofQO3Fsoi7eYrxPT
	SqRcN9l749XFWr+AyYmc+xif7Gm0F+E=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-54a30c66258so188985e0c.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758185944; x=1758790744; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YBijHHPgjAyl07nG2F+4O+IZKa9So+D2+79Hhyhtjs=;
        b=Bes1ymZB3Q7165Y7wuGby1C8IH6/LFpDIYTx1/skhv0PQCHN9WxLZIxF+h4rX/qg19
         7Mp7ZkayFNHSiE1XNZv9hlMmAn2OIlQKuHAbwbSIRTmdAumSIl8prsNmWhAPSjHrx+I8
         Sa+BvObeOiAVbc2mdg87bSuxIMcZOh7cYKN9pvzK5B60h7MaYf9Aw657vMH2zjARTBqq
         HKFR8y6kE53ZNNXI+hnyJsFCOeEGLTTy0jmnkznl2U6n2Lz8356F7IlDuj/EbkxC30BM
         0NyzUlqVegnc/Y7vwTQQsoaIvHTZKhIseR+LcPtnBY2PA8pHGFMLkc7e+5O88f656oAu
         D97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758185944; x=1758790744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3YBijHHPgjAyl07nG2F+4O+IZKa9So+D2+79Hhyhtjs=;
        b=oLly5KuwHAfe1mYKTTzjFi+6Bpywe5ZztFrACtqxCN+e1WCeLFGh2wyyLAMk7SkLfk
         TNQFbGqDUT+k4Bx65QIhPb4HpeH32HKWmGIa0X8Dt5fIJ6lf4eiKRK17Nb2TDyf+dKRs
         knI36dRIsbf+MGFinqcVwB/o7XhheiTQX/luRnWI9Sx/KsVZ0Zwl4UoEf+A2a/Yinzp4
         bjOJVzURK/RDB+eJa+QtNTIKgpjih1O4XmsWWDBrBaUlOVcrTW/DPlwsx+7fSm6wmt33
         30UuqJOIpaK3tl8FrCXQsVRv9QOYJ0pu7KDYxlPYLTg1e81ckUfqCe4Mh/3/HHCHRPYn
         5U2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUnqqenPJQIEcXPxWANrtOtCqhU5wt/uc728q1mnbVNFexeCScaVXYk0aopGF9L6pW+1j0vWUBrsw==@kvack.org
X-Gm-Message-State: AOJu0YyRYgQKPc3/M+2FEGeqB5jsfGAjtj+tbnv1wdVtX0+XrV+stZbY
	Itm2CA27RRUWa280ERYqpzAUww017C2WXPTdq+zkSHBya5+Zp55VLph5/EqPOx99KgSMKqdRzyM
	8JRGWRBRz8smKg6Laudc+lHm41PaUADs=
X-Gm-Gg: ASbGncuKFxXp6CUccDsy698lvq/rSlrYOh9F03jxr+Cg1ZUfonJqScXvpQ9gXvBPJiW
	Qo31HWIpLkGYBCrQHxVaw05jT0E59rVklM4vu9rLA1nU4hykCRUvlJYtxbJxJj1o71x9bXXjzSH
	zJr5lzB2+LGwWLvoRCFUf2PkPxbGcIsLnXcs9gFiZ6QODlSrlO4kvWA4FWidGty+n0PAjq2Fl9l
	YiVQ0So8Et36V/mCRC6uef/mbWDRk0RHWYmGtX032Aygw5/WT87F3vHQfAc
X-Google-Smtp-Source: AGHT+IG9PAZlU5wX6CfCuIPG52y8YmCpl5qUjiXZykbS1/b+bgq6fwmzpG5T/XrmW/++davGQcBL0s5sdx3isOtSuHA=
X-Received: by 2002:a05:6122:2a16:b0:54a:71f6:900f with SMTP id
 71dfb90a1353d-54a71f6bfccmr745397e0c.0.1758185943888; Thu, 18 Sep 2025
 01:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
 <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
 <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com> <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com>
In-Reply-To: <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 18 Sep 2025 16:58:52 +0800
X-Gm-Features: AS18NWAo-ti9La1j-oEkjznzIVvUZ14li7XE3QDuXeP6to8aA2ac4MfnZt-xdbk
Message-ID: <CAGsJ_4zmkibM_Ex7kGMsr2sni85H-cnxQvh0XwkWiALNQy+zAQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 433E8C0008
X-Stat-Signature: oq5eru5b9n4kkkrtraukfnn5itobik47
X-HE-Tag: 1758185945-818619
X-HE-Meta: U2FsdGVkX19D/mBLpoeDYkDZINUJvKN56NINZNJ8MgwJA9Rntd+RWv3Pu8pRh+gI6c0qLuAclplz4XkiA7pnfnh1slN40odQLgMh9GWz7H7Sc502Yj1iM6UIPenyqzjHnbaGF/ibPxHXKwRNnSp4s3EyxmjB5zEkqZAdpQ7Rc+jgx9VYGBEdi16ZqpKSGOhaLMIqt8p8AUurlfxtSUbic3foSRF7synQpYgmXvzuPSN37cWWTsoZzFY53G9MQr3Cp1txAVxLvFWxwFeOczgUrYcdo7SxGwAOQ2Ly66QSw6o0iMqcLIsE/ij5kjNpg0Z3pir5HZY+D1Czx/qKscYHnp4YylakarcaLG6j8CoBYsMJ+Fn3Hq8zHkI1gsrY7pyC+leuGS3lC4DAR4syVEAvZtABGW2E1CNoF2WqQdHVTDoM36ElQsiahT0aKLUReBnglgdXt7FPBzSh/DlCM7f0sDyll6CCzOFJ56do5BZHkPJtAOe4VSxB8p6/KzrjPgLpFmtOEbr603pKpXLi80M4vn20mjZEWtwILPT3w9RoFoEb1prUo/EJtrbxWnLMULr1LQVVHUJv5inavL/XegZT1OuhkyvSx5/X17z2CKwq6goFELo6j+AkFvIXeImUNKzNxfyMJeaM/YN/eR0WwT7dhRxOiMZHYeAGe+rV3jImIH0K01tL4TqEo39YXWyX0zFNsvC+z5Xpspm8bekINevVZ5WLT1z8K/uwf2UDhMAcEXzrF1VI7HZAb2b5gfdT58Wj7NLZfBbJm2Pfs9cRnCHR6S3nBSkRnbKklanWswlQE8r/INPUAcuGUFtIxr0melRm2hQTO5XJOZAETgWWwt6abqylOTZ2afj6u69/7YqJ9+q63P8H08IIwgsPLRWKYzVkOQz2TfviMB54De5dj0Ajwp2clWUaBaLR3igjDOVj0EfyYnrLU7GdEEq+axLoG25kjzoEnxs6vBpW74lhF7g
 0uB7Agix
 ReXzcihOx4qlHm9HcXOLCoC9B5KLMu8Mq0aP1ZUVwS+WxZ5oCLYD2Zl4DaapK12BdGFn4jCrGPu/PSG7C/ximMeOpUbbLPbYNRykCOzk/ooE6DWYhgm8OO06GbE5+0It5xpjooal7SjeG6XkLEiz3vXbR1/4WtQA/0QDBXeSJnkXcPho9JYERRfz53NdPg6+00bxCBmVceV471ZKy5yg7xPexq7GILbxMvyOU7vL8JJUwfRuJEWKiviC8ZaIrHPd9Re+2KFdZiggCZshA4D36x7zjhk4G4083sIkVmjVeI+HuUHGeRfxdssCayHXcaP2NkfzlLjrg2VYcdjipWqX9Y7kJzvJW3HO8bOJ6F1PcxYUV1B9KRTYkDxfktUDv/HWeH6s1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 3:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Barry,
>
> How about this:
>
> A swap table stores one cluster worth of swap cache values, which is
> exactly one page table page on most morden 64 bit systems. This is not
> coincidental because the cluster size is determined by the huge page size=
.

I=E2=80=99d phrase it as =E2=80=9CPMD huge page,=E2=80=9D since we also hav=
e =E2=80=9CPUD huge page.=E2=80=9D

> The swap table is holding an array of pointers, which have the same
> size as the PTE. The size of the swap table should match the page table
> page.
>

I=E2=80=99m not entirely sure what you mean by =E2=80=9Cpage table page.=E2=
=80=9D
My understanding is that you=E2=80=99re saying:
The swap table contains an array of pointers, each the same size as a PTE,
so its total size typically matches a PTE page table=E2=80=94one page on mo=
dern
64-bit systems.

> If that sounds OK, I will send an incremental patch to Andrew.
>
> Chris

Thanks
Barry

