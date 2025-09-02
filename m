Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64108CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D39B8E0015; Tue,  2 Sep 2025 11:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9843D8E0002; Tue,  2 Sep 2025 11:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899F98E0015; Tue,  2 Sep 2025 11:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7377D8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:03:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE36DC0231
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:03:43 +0000 (UTC)
X-FDA: 83844629526.01.D249E10
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDC3B10000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:03:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cxfl9LHd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756825421; a=rsa-sha256;
	cv=none;
	b=4Og86i52Glc4IF3EgmnsCb6KxNwPFr+dKq0PNNgBAS53IWWmCoU0lNhPvUkuqLwEc+0SnQ
	7sawJIMpuFWG6KwEIib9lCNttkVu7UV3/aOioP5QaZW0SsNzZKPsCM2eWz+R4GeSQG021S
	Obul2suZPScFuFPYREsbO7E/y4/3xPk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cxfl9LHd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756825421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2EDErnRMKsMMVV5N3TFtUBYfdCq51q/XvrALwUpe2g=;
	b=bvByhq8BkEzDWJrLBCs5KlNahVpJ+uQDLu4nqF+byRv0rT9AfAQARLfjSnPx12us8b8hHT
	u2o+i2+v7rc4Ew2NXmnKRRA7JxeC+8dQ1sAVisTuyYe4Lt97evylH5zw1IHMCa5BGH9Wjb
	alJK/fyIpeS+XjCBqRr4iUjnh9oBeo0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so11382186a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756825420; x=1757430220; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2EDErnRMKsMMVV5N3TFtUBYfdCq51q/XvrALwUpe2g=;
        b=Cxfl9LHdrSYCOxyvj5XVeIP03V5L7HqRrqyaTkjFbdNA8pUMOZErbkWVWCH1ysZwqc
         qCPngPw/evqq07r2m/4bQxaqh4COIDlzePiDUjO+VYNON3xw4+vn4vcswhVUbly5Bxio
         2U3OdwLt49VwpvsBzXBKVNSJbrDlKH5sQlNYRF8LVBBn8Sw3BX/+EQyr49+0pOJC3Qk1
         3viA5elS8ZFcEfgCwykcmM33QJiRtElgaMbiHKaIhbTBMQNtRZ5g2kPRD3KB0NHx8vp7
         M9im0ezn82CNoNdeFGTLaXKh28B6amn7wTu5QAc0rXErxQHwfjHz0Vr4mhvuFrr5AdFV
         jEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756825420; x=1757430220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2EDErnRMKsMMVV5N3TFtUBYfdCq51q/XvrALwUpe2g=;
        b=rXn3xwtp8wtJNaHUPoPaa74WMegGyFFcYK84s2XX3dSqZPP2wVMc5dwMIHqL1HDI2k
         wEGWqU4f+ISbHedXqYXQZPCTqtewqg6sUCqm82Al3R2aMSnIztgXS78F3m11krWV+Bce
         67VlhrdUMb5zSau2nE8uPGWJ4wAjhExseqDNb0R/UEPgRBm1Bdb25cFygFlY8MBFRfxX
         pih0ixZAmtdpzUR5ZIrex7yQlXxycjBrsZKY4ODyRYJOQ4/+u7IPUOSg+pQCep97snPO
         wR43PJADkj9SFz0DgXWeOlR1Tx4ejSnyWAqWc59IZBJVVehU2GZOaIe0mQAwA6IPU4XM
         BA4w==
X-Gm-Message-State: AOJu0Yxp7ZlNPfvuNos7w9jLQ6ZrabLzQvMd8tmIssLUULHsypG7Kr5E
	v/jlp836orIvi/k5zgnkdd2u3z0sDVVhs+/73VOccIEyHgh6ULe0LQrfRMTlfZUVJ7aaTmH0PUK
	Ha+rWkYCO5/rrQqsP6dIRqLAFJ4q492g=
X-Gm-Gg: ASbGnctBqEKmKF8sVloEr4vbZzRdT/x6TJTv48KDzuxqbR8/Xr0cEVcQ6LagngPXhQv
	nPwBMU56qDDnxpo7QXqOv6zJPV4BUQy7Rt7U/gFttBG9KLMjt7OnTbhNVaHXeBl9q+M5BALZZ+k
	gNO/yQrUWYB3/D7q5+OXqKRn6fCXaKckPUMm1PcB1xuna1wIc1Wr0VPUQZkvbhiTMpdspLLgGG8
	r/xtmdhhlHmpAbfwAbfzg==
X-Google-Smtp-Source: AGHT+IGic/23QC4PUaC2yRhDBJYKR3DZQxhhPkpq1/vUXqTgg/aJ0G3deqGBUo4Qbc3UlNDsDUlBss+j9wTnIEZqAls=
X-Received: by 2002:a05:6402:1e8f:b0:61c:c034:10cd with SMTP id
 4fb4d7f45d1cf-61d26d5bddcmr10375580a12.9.1756825419732; Tue, 02 Sep 2025
 08:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-5-ryncsn@gmail.com>
 <39087ce8-6f6a-4998-95e4-813e265318d0@redhat.com>
In-Reply-To: <39087ce8-6f6a-4998-95e4-813e265318d0@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Sep 2025 23:03:02 +0800
X-Gm-Features: Ac12FXyLlzKHhttNr4D3KBMcouTB4kzGccaupNNYaebeIQscQX6NJ_SHFlbVOJc
Message-ID: <CAMgjq7C+mChdnbcrYEkKyuuRN9-THXwBdFeCVwvW_m-_CWCzvw@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info helpers
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CDC3B10000E
X-Stat-Signature: syf9sqqt68oqcp7ern6kherpyfqsjbc5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756825421-969574
X-HE-Meta: U2FsdGVkX19gQ1TmvEbpZI3KzjY3kidnIQZRqpDD1C3o5Ee9iX0oW2jH+quhfivZ2yECpUi7tLcTs/5o5C5WDiNvcU4LvqXDx4rYBcBOkjzZstTfaiBA82GOuuYTxQ4dwOXobFgbrx2p+39RxJBDWcGS0wfNN5P8hHIx0FmWWADaQ7ZpfhMM3NNsjL0Skld8+MIYhxTJdEkFxr6avV/2dUoi3m3HzHtznXl3GxqRFhpNAEJ3D/tHaC/QtTMp4mC1TXI7U50k6DSUVuGcfQENuQLu23I/AVdu/VvzRP240SEVbDzMH0zfXhmd5a9xq/nClUS6JL71y8MiKVk1pEkGdn9MNXAIFPPoPuLVjtQlK0K9/kkGR71NeBV8Og9OqqsagF80fNffRxZO4gNbvBNG/qcgJ1eziMMDoKTBT1zTCmjyfzctwHl+P4/RTVkLwItLxqqDPadzNGXa75l88z1wCJhiWKeyq1QCw/Ud14A++MQIOUd862neQhOYHTn/zhjbNksop6oX25DNVHj1o6us6stjW/F+B9CpdSFCi7N5UNwHwqK7V9PfroZfgURwWvQjrYyV8Tk2r+zjoFUBL1nytN2aNSdN8nrF/V+uJuhYKrZ1FeJ6UN/2j+aaKuVZloOORmEjCGG/tc/X4v60O4EET9flwF8HSG429Eh7Sm00ZJfDGR/vczF6zVhYCEsVQLgqQ6FA7WIDYKmZFhP0SHNq3NjFT3pRs756oFwIIzDHyebAbwTg85nWAJ76SU0fWT5Lu8crtcB3JkPAIF9WeWG7MUUVkzz91fA3KrselrXqClPq10+ehIMMfeGU4biqg1WfaS7+0g8wixwGGKp8U2ULu3aJ/ghqkV01qdzIjOOxfruQFOaoRT71ZgRgzhUs4xZ6qArKzstdyPDSzut0m6H/ftHyPNGKj1gGEhC+0sCml3zcbkJWnDZnHR63fiMU2boWewqmRg+SgMHeCWz03cq
 OZtxAbZM
 1sknqdGZ2fX4PCVfx943/Aeu5jB8XstVgdLGB5hDY0c296knNKnfsdNbjLk4+embR/sVvBkuNjfWDEb9E6LhPJsE10ksZ3hClHAzRnlfmmemw/0K8BYVRczjhGEPpAVf9fnT/GgNSBzGyutg/T5pDr2bRO56QHRti1vo/2g9EMVoboVs3JiD7j8O1hk7wpZV+0wp2m5KrdKYXxs0Iu6CAv19LG32wzwd+RFt2An5Zu1ivGai8UgroOzFhD3C9bhiSHVTVgkRfR8oakzyD2aIQDvzNnfgmAQrlKbC4e6EO6r2TMAa8JVumrqTjxNPJIKY2d5o5Hh6LI//K4W8u+BiIIYI2yi7WH65I4LEGQ14hcIwVs0lH6Rj4YFZXAffw8qdG2+k6Ae12WTQslNN8Y/2gmOPvcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 10:14=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 22.08.25 21:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > swp_swap_info is the most commonly used helper for retrieving swap info=
.
> > It has an internal check that may lead to a NULL return value, but
> > almost none of its caller checks the return value, making the internal
> > check pointless. In fact, most of these callers already ensured the
> > entry is valid and never expect a NULL value.
> >
> > Tidy this up and shorten the name.
>
> Shorter !=3D better. But yes, "swp_swap" was a mess.
>
> > If the caller can make sure the
> > swap entry/type is valid and the device is pinned, use the new introduc=
ed
> > swp_info/swp_type_info instead. They have more debug sanity checks and
> > lower overhead as they are inlined.
> >
> > Callers that may expect a NULL value should use
> > swp_get_info/swp_type_get_info instead.
>
> High-level comments:
>
> 1) I hate the "swp" vs. "swap". Is that a valuable distinction or could
> we just convert it to "swap" as we touch it?

Totally agree. I was just blindly following the old style. It's kind
of confusing indeed.

>
> You're converting swap_type_to_swap_info() to swp_type_to_swap_info(),
> and I am not sure if that is the right direction :)
>
>
> 2) Can we just call it "swap_entry" when we work on a swap entry and
> "swap_type" when we work on a swap type in the function name?
>
> swp_info() is a rather bad function name.
>
>
> 3) I am not sure about "to" -> "get". "to" is much more readable in that
> context and consistent.
>
>
> 4) swp_info[] vs. swap_info() gah.
>
>
> I would just have done:
>
> swap_type_to_info(int type)
> __swap_type_to_info(int type)
> swap_entry_to_info(swp_entry_t entry)
> __swap_entry_to_info(swp_entry_t entry)
>
> __ are the expert functions where we don't expect NULL.
>

Thanks a lot for the suggestions! I also like the idea of using "__"
to seperate the non-NULL version a lot and implis the caller have to
careful.

My concern was that names will be getting very long in later commits
following this convention. Which is also the reason I want to shorten
them here.

A lot of SWAP relate operations will be cluster based, so it will be
very common to get offset or the swap cluster from a swap entry.
We will end up having a really long name like
__swap_entry_to_cluster_offset (convert swap entry to offset inside a
cluster).

Since we already have the swap entry type called `swp_entry_t` and
helprs like `swp_offset` and 'swp_swap_info' that convert an entry to
other swap things, so I thought that anything converts swap entry /
offset to others are named `swp_*`.

Maybe a bad practise here, we can fix it while at it, or at least no
longer introduce more confusing names.

I can follow this suggested style, will it be a good idea if we have
following set of helpers?

For swap cluster and swap device (swap_info_struct):
swap_type_to_info(int)
__swap_type_to_info(int)
swap_entry_to_info(swp_entry_t)
__swap_entry_to_info(swp_entry_t)
__swap_offset_to_cluster(struct swap_info_struct *, pgoff_t)
__swap_entry_to_cluster(swp_entry_t)

And for offsets, we still use:
swp_offset() (Existing helper)
swp_cluster_offset()

Now all swp_* helpers are pure arithmetic operations (we just renamed
swp_swap_info which seems the only exception). Is this better?
I'm open to suggestions as I'm really bad at naming things :)

