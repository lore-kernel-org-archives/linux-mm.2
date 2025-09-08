Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610BECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2B48E0009; Mon,  8 Sep 2025 10:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A2E8E0007; Mon,  8 Sep 2025 10:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7448E0009; Mon,  8 Sep 2025 10:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87CCB8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:59:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2862E1D9B2B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:59:33 +0000 (UTC)
X-FDA: 83866391826.03.CE13DC1
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 375B8140007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:59:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QezIrBgM;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCpK6OFCrAXWZyC3c9WtGrIupiWt1m8Hi382mlStvSA=;
	b=aPqdZBYEg5yVDeSu2Tk+sBdDZaxFWH8O1ZLP33Em2FgfYuYJtCM56SalSTNnmyqHA1I55a
	rKq2BBmK/xtA3VUCg7qGc+jeEdSN7Mp6gO8ODNlQDS1jMHBq+FgNs862clUDOi2upsQVjx
	WmnkTyzs6AZPnAGhfmRLF7/4sp53VLo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QezIrBgM;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343571; a=rsa-sha256;
	cv=none;
	b=BmO9RINQ8s7MBqHIY7h2lLe6o8oliqK9ZkU6Fee9PPcGZmYEJC0xa3l88NvRuvJHWgv0rf
	RK0STSvkVbWns3z6NO7nUvwIQOMntAOI01C6hr5H0NGVWCU5WQy1OVclJ6X2IMPwTpfO6e
	9EY49ByNwU9Cta1FZ9ydoDpQ6+Iu6eQ=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so4357245a12.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757343569; x=1757948369; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qCpK6OFCrAXWZyC3c9WtGrIupiWt1m8Hi382mlStvSA=;
        b=QezIrBgMb2ecqZvrCY7p7RNr5KBNo/vUo4Qy8uV8ZL7aupYIjk/OktEO2m9axep1bU
         sb9ddQKJLzhRE6btmdp2zTWvdXSURwn842yTow00iR5BnlbP19bthRTK3AmUAgWl35aG
         KjFzyhkHA9Pw6hXO+rVWBYRabIsltx+7fZ5QYtvlAhFa7EuOyPLCof8vAFZxbABhlX/2
         IUpMcGu4bzCRgNa0UPR7JpO6FOZfoPAZM/57Q1QmsBy7dExoVU9W2+nM6FveaGP+HEaQ
         /CJAf5La7bLfK1k8pbI2XLflxGA9TU+5bS7JiTAg8U8HC3ATpW1lwOaovuS7PZcvTBgJ
         Uesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343569; x=1757948369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCpK6OFCrAXWZyC3c9WtGrIupiWt1m8Hi382mlStvSA=;
        b=oCodz7ge7W672fTWSnDX93p1Pt3ToHqRAyNtR3tiYseKnh53C3J40Vswa9QwvC1FTl
         L8wfKXPGNop/9SEjxqR4W/2N11An77hMIY2iVSZ8VDr6dDjCNGGD7aLFEmY7lPGjIyqz
         rqgXUx2brj5h94SYmeUDIgLLVJWsqJCB8EDllRZPir2c0PsDFxcUqIKFP0HNocQ4kFP5
         QsebDKHYFqprisdKjOBXY9cFk+JzFE4VeNrDoX0WrAMYQPBfXboK64lV+WC1wIt9ekby
         rwWIhXQA2SDVAvbAjHb530GBayw4S4ZLwZfsf3yz26sMPxHWhyqS1TbAJsoOMEEfBlni
         DxnA==
X-Gm-Message-State: AOJu0YwFSZleogAzs5jzwc59YNhkAv7HxuBdnCfIbnIilQiZPio65s8Z
	DQOr2LEq2I2wSqQMEXV5QW5DUGZ6sexk3Ac3wUEIogsvV/yTDpLK5z33mMPmc/qFifJL+px5tXl
	Q0y0xRvZB6maahKzdawut93pZW38F/7VlEvcuLWlNvw==
X-Gm-Gg: ASbGncsJ+OlNI3V0NGiw2XMcVNGx5l+5KOWHNMtxKLFbaBz60s/VHEhEnTbWtvPSsMD
	6LsfKhj5aRWMdP+4NlRos16Sv5L8F7m3SCvOvQl3cKoTDBW/DTq66Y092yFg4W0OlqCaW2ahtNg
	TlZjQT7uTkxiv225l6dyWel/uWJtsQfqJPm4xL6JieM4mp1mcYgSc80+zxV73cZuZ5UIRA5G0hH
	k1dnMcJo9k=
X-Google-Smtp-Source: AGHT+IFVR7T6+Lm4E2NKqekSiz8GZDSpXQSzI9L5eH92Hm+cLpHRFZSbl6RzOFr2DzC3gQRViVNaDgLDawjUGJ2YOug=
X-Received: by 2002:a05:6402:27d1:b0:627:9d08:97a6 with SMTP id
 4fb4d7f45d1cf-6279d089899mr4287732a12.18.1757343569461; Mon, 08 Sep 2025
 07:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-15-ryncsn@gmail.com>
 <CAF8kJuO31q0nZmZwxeMZDq--wH=zeXwsZ8YK2M_7CyYmbsOouw@mail.gmail.com>
In-Reply-To: <CAF8kJuO31q0nZmZwxeMZDq--wH=zeXwsZ8YK2M_7CyYmbsOouw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 22:58:53 +0800
X-Gm-Features: AS18NWD4IDdiHB5mIiuiWAojKjPiQpn3DyQZG4c0y4smD4KrFO55nVVEatPd84Y
Message-ID: <CAMgjq7CYuCA9-gV_SfD7+WkQSdWtN+pacrqp2TuMuzEzU-CBsw@mail.gmail.com>
Subject: Re: [PATCH v2 14/15] mm, swap: implement dynamic allocation of swap table
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k8nzrfhnhga8hedwc34qzdo9y7j7hiqp
X-Rspam-User: 
X-Rspamd-Queue-Id: 375B8140007
X-Rspamd-Server: rspam04
X-HE-Tag: 1757343570-813540
X-HE-Meta: U2FsdGVkX1/FFhuAtHZvqpLoDUKmqR/uwurunOsbedgNcGzFMdBii0FFEqFFS+TMwQtpAbwc6t+9CVl/33RTmmLMXtbSTvQcgPpBBk0jHas6iz+sdXJfdKnDwef10VqvWtJwkahx6fiuQytoa6VZ84Z0hQfpzMS+KoLD/X4eDOgv7UPpRUp+2w/er54Nco0cnFTYfl4DpzgVvsevNE/fPQO+kL219nf2MUqeIpqF9szxgyOGSK+K1lD2cV/k0KXI3WC4EAqtu2jkPMqy/1w8qFxVhlYcyMR/+wK2/SVryXPAV7L0w9/ZUWswv5giBHPSbkuW0EIYz/pSxyTXyI9XaJM5PtaTtBlagFcQQymO8oC/6qB+7uDZl/+XpbUYcxbCHFgWFmWgTwSluwe7v5os2UQDNI6kw3faiWZW2wBMO15rOCnN4aG+15sTm3QOjF3DuVvcJ+KzNaoogGLSo00vnzdp8WALSlNoM/AeamGbbUTMgddcVYSWnyLRZq27DOzrp4QzSonNr7ippBP3r/mDtZd3zxq6nCkWC8+7YMttHOS1VJw/yr/hY/78QASmK4DhDWjfOUxquoD0EXy6QzA7TNDGsEpiZ4serJptdzn3nEM0qThJQnZu99PDdrs2exuO13RztNhONJtidg4kaKgmAecoB0zyb9uik9GOav0JG8bt1QWiTtD3k7uj/vaHMfWqtFLKSAYSj+XO18F7WPVG2iaVNPXgXGRzt1qB0TNTUfhiRvqs/3lWCKTgJJy4FlE5H1J6T9euvNatDrhlcK/X171ehLOuH8m07aiC5XOZiFVcwJvH34gzHUjU/zXo0CYwfxx6BWPib3hJmxPQQj9maLsF+msxVVP1wBLLAQAlClPyOhebDdNvpa7f1jQ5kaR/bPXyJPq3ftkXGuNFjCTwzmmXhpmAWFFz0Lhq1NvrN99U7/gLfJjvDm9aZi/w7ZiYo8spGkSgON8WScpkTgF
 74jxPWSa
 K3buI0qvTJjP2PD92ckxTOveY9LewHhJ0iIXKkF3pElpaJ02eC7WEZ1BaZsUHAXdUVS1pczYsksP7cdlKGjMnu3RUzFBAaRhTxbk5eCsr7t784YD3d8+/t4h0z8MCIKY2GA11MZXVIjdo20K4S+QwtfMnHT19BEBWz0NBlyzLBj7k5YdCiubp/axjYYKdIRBQzmAV5jO2+en450O5rtxOe+YPYlBEGwTwHffGSi/3/yKTuCAQMgIosXaynRm/Q50+O+HqDAFRnJBnPdGqivZC2DFSFWT9Nzz5/FwpmElQlSN3BKJqkis7Fv0ApaQ4Z+1VCtSeCEvZiXoMuhGPXCSZeHBfh/1CA4AGpm+awhe5tMnj/lgUWFCBDNSq5mihi2/F0ck5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 11:59=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Kairui,
>
> Acked-by: Chris Li <chrisl@kernel.org>

Hi Chris, thanks for the review.

>
> BTW, if you made some changes after my last ack, please drop my ack
> tag on the new version or clarify ack was on the older version so I
> know this version has new changes.

Most of the patches are basically the same as before except the xchg
change and naming change. I'll mention and drop Ack's if any patch is
updated non-trivially. Thanks for the info.

